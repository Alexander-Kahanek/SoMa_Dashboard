import pandas as pd

import pandas as pd
import ast
import geopandas as gpd

from shapely.geometry import Point, Polygon
from fiona.crs import from_epsg


def flatten(raw):
    '''expects first column in dataframe to be the number of items'''

    newrows = []
    droprows = []

    for row in raw.itertuples():
        if int(row[1]) > 1:  # is items tagged more than 1?
            for n in range(int(row[1])):

                # get row values seperated
                rowvals = [1]  # new row has 1 item
                for val in row[2:]:  # append rest of data to row
                    rowvals.append(val)

                # create dictionary for row
                newrow = {col: val
                          for col, val in zip(raw.columns, rowvals)}

                newrows.append(newrow)
            droprows.append(int(row[0]))

    raw = raw.drop(droprows)
    raw = raw.append(newrows)

    return raw


def classify_points(raw):

    points = [Point(lng, lat) for lat, lng in zip(raw['lat'], raw['long'])]

    crs = {'init': 'epsg:4326'}
    geodf = gpd.GeoDataFrame(raw, crs=crs, geometry=points)
    geodf = geodf.to_crs({'init': 'epsg:4269'})
    residentialgeo = gpd.read_file('OG/shape_files/residential/POLYGON.shp')
    commercialgeo = gpd.read_file('OG/shape_files/commercial/POLYGON.shp')

    classifications = [('residential', residentialgeo.geometry),
                       ('commercial', commercialgeo.geometry)]

    alllist = []

    for point in points:

        contained = False

        for classification, polygons in classifications:
            for polygon in polygons:
                if polygon.contains(point) and not contained:
                    alllist.append(classification)
                    contained = True
        if contained is False:
            alllist.append('Other')

    raw['classification'] = alllist

    return raw


raw = pd.read_csv('OG/RClean_rubbish.csv')

data = flatten(raw)

data = classify_points(data)

print(data['classification'].value_counts())

data.to_csv('clean_rubbish.csv', index=False)
