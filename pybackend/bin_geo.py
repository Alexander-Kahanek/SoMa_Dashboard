# console printing library
# import pybackend.console_print as cp


def script_bins(lats, lngs, xbins=None, ybins=None, nbins=None, cprint=True):
    '''
    takes two latitude and longitude lists, as well as
    number of x and y bins, or number of bins if same.
    '''

    def check_data(lats, lngs, xbins, ybins, nbins):
        '''
        function for recieving data from R
        returns true if input is wrong
        '''

        if type(lats) is not list:
            print("lats must be a list of data")
            return True
        elif type(lngs) is not list:
            print("lngs must be a list of data")
            return True
        elif nbins is None:
            if type(xbins) is not int:
                print("xbins must be an integer")
                return True
            elif type(ybins) is not int:
                print("ybins must be an integer")
                return True
        elif nbins is not None:
            if type(nbins) is not int:
                print("nbins must be an integer")
        elif len(lats) == len(lngs):
            print("lats and lngs must be same length")
            return True
        else:
            return False

    def create_bins(xbins, ybins, deltax=None, deltay=None):
        '''
        takes number of bins and deltas,
        returns an array of lists for bins.

        pass delta[x,y] to add (left, right, up, down, indexs)
        otherwise returns lists of zeros
        '''

        if deltax is None and deltay is not None:
            print("Must pass in both deltax and deltay")
        if deltax is not None and deltay is None:
            print("Must pass in both deltax and deltay")

        abins = []

        for row in range(ybins):

            rbins = []
            for col in range(xbins):

                if deltax is None:
                    bin = 0
                else:
                    left = deltax*(col)
                    right = deltax * (col+1)
                    up = deltay * (ybins-row)
                    down = deltay * (ybins-row-1)
                    i = []

                    bin = (left, right, up, down, i)

                rbins.append(bin)
            abins.append(rbins)

        return abins

    def sort_xy(xypair, lrudiList, xbins, ybins):
        '''
        sorts x,y pair into indexes list of lrudi list
        '''

        x, y = xypair

        # start at middles
        col = int(xbins/2)-1
        row = int(ybins/2)-1

        notsorted = True  # exit while loop
        move_count = 0

        while notsorted:
            # initialize moves
            left, right, up, down = False, False, False, False

            p = False

            try:
                (l, r, u, d, i) = lrudiList[row][col]
            except:
                print("Something went wrong, please choose different bins.")
                return

            # left limid < x < right limit
            if x < l:
                if abs(x-l) > .000001:
                    left = True
                    col = col - 1
            elif x > r:
                if abs(x-r) > .000001:
                    right = True
                    col = col + 1

            # lower limit < y < upper limie
            if y > u:
                if abs(y-u) > .000001:
                    up = True
                    row = row - 1
            elif y < d:
                if abs(y-d) > .000001:
                    down = True
                    row = row + 1

            if not left and not right and not up and not down:
                # no moves left to find
                notsorted = False
                # add index to lrudi list
                lrudiList[row][col][4].append(1)
                return move_count
            else:
                move_count = move_count + 1

    def scrape_lrudi(lrudiList, array0):
        '''
        take lrudiList and count number of times a object
        was added to a bin, add this to array0
        '''

        for row, rowobj in enumerate(lrudiList):
            for col, (l, r, u, d, i) in enumerate(rowobj):
                array0[row][col] = array0[row][col] + len(i)

        # print(array0)
        return array0

    def main(lats, lngs, xbins, ybins):
        '''
        main function, follows algorithm:
        '''

        fp = "bin_geo.py"

        # get bounds
        xb, xa = max(lngs), min(lngs)
        yb, ya = max(lats), min(lats)

        # subtract to normalize to 0
        xypairs = [(float(lngs[i] - xa), float(lats[i] - ya))
                   for i in range(len(lats))]

        # deltas
        deltax = float((xb - xa) / xbins)
        deltay = float((yb - ya) / ybins)

        # create list for left, right, upp, down limits
        lrudiList = create_bins(xbins, ybins, deltax, deltay)

        # sort x, y pairs into lrudi list indexes
        num_moves = [sort_xy(pair, lrudiList, xbins, ybins)
                     for i, pair in enumerate(xypairs)]

        array0 = create_bins(xbins, ybins)

        # print("scraping data from lrudi to bins")

        matrix = scrape_lrudi(lrudiList, array0)


        # printlist = [
        #     fp
        #     ,"xa,xb"
        #     ,','.join([str(xa),str(xb)])
        #     ,"ya,yb"
        #     ,','.join([str(ya),str(yb)])
        #     ,"xbins"
        #     ,str(xbins)
        #     ,"ybins"
        #     ,str(ybins)
        #     ,"deltax"
        #     ,str(deltax)
        #     ,"deltay"
        #     ,str(deltay)
        #     ,"tmoves"
        #     ,str(sum(num_moves))
        #     ,"screenmatrix"
        #     ,str(matrix)
        # ]
        # 
        # print(" ".join(printlist))
        
        # "{fp} xa,xb {xa,xb} ya,yb {ya,yb} xbins {xbins} ybins {ybins} deltax {deltax} deltay {deltay} tmoves {sum(num_moves)} screenmatrix {matrix}"
          
        
        return matrix

        #########################################################################

    # check data before main
    if nbins is not None:
        xbins, ybins = int(nbins), int(nbins)
    else:
        xbins, ybins = int(xbins), int(ybins)

    if check_data(lats, lngs, xbins, ybins, nbins):
        print("Error with inputs.")
        pass

    matrix = main(lats, lngs, xbins, ybins)

    return matrix


##############################################

# example of run

# lats = [float(rand.uniform(1, 100)*3.213) for i in range(1000)]
# lngs = [float(rand.uniform(1, 100)*2.1878854595) for i in range(1000)]
# # xbins, ybins = int(rand.uniform(2, 5)), int(rand.uniform(2, 5))
# xbins = int(rand.uniform(1, 20))
# ybins = int(rand.uniform(1, 20))
# nbins = int(rand.uniform(1, 20))

# # matrix = script_bins(lats, lngs, xbins, ybins)
# matrix = script_bins(lats=lats, lngs=lngs, xbins=xbins,
#                      ybins=ybins, cprint=True)

# print(matrix)
