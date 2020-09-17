# file for console printing functions
# turn into classes to support different file structures
# need to get base data first, will be classes for sql integration

def stringcheck(string):
    '''
    checks string for common updates and
    updates it with the correct information

    systime, 
    '''

    if 'systime' in string:
        # get system time
        # replace in string
        return string


def pyprint(message, cprint=True):
    '''
    prints console message to be scraped for data
    if systime in message, print system time

    cprint: bool to test print to console or not

    message: f"file column data" seperate by space
    '''

    if cprint:
        print(stringcheck(message))


def rprint(messagelist, cprint=True):
    '''
    prints list to console, seperated by spaces

    structure message list as c("fp", "column header", "data")

    0 = filepath or name

    1, 3, 5, .. = column headers

    2, 4, 6, .. = data objects to scrape
    '''

    print(messagelist)

    messagelist = " ".join([stringcheck(obj)
                            for obj in messagelist])

    if cprint:
        print(messagelist)
