import imdb
import easygui
import webbrowser

def getID(name):
    ia = imdb.IMDb() 
    search = ia.search_movie(name)
    idList = []
    plotList = []
    for i in range(0,6): 

        id = search[i].movieID

        title_id = (search[i]['title'] + " : " + id )
        idList.append(title_id)


        try:
            plot = (' ')
            plotList.append(plot)
        except:
            plot = ('No data available')
            plotList.append(plot)


    msg ="Which one is it?"
    title = "Movie/Show Choice"
    choices = [(idList[0] + ' | '+plotList[0]), (idList[1] + ' | '+plotList[1]), (idList[2] + ' | '+plotList[2]), (idList[2] + ' | '+plotList[2]), (idList[3] + ' | '+plotList[3]),
               (idList[4] + ' | '+plotList[4])]
    choice = easygui.choicebox(msg, title, choices)
    choice = choice.split('|')
    idNew = choice[0]
    idNew = idNew.split(':')
    idNew = idNew[-1]
    idNew = idNew.strip()

    return idNew



def getLink(a, id, x):
    if x == 'TV Show':
        if len(a) == 1:
            url = 'https://vidsrc.to/embed/tv/{id}'
            url = (url.format(id = ('tt'+ id)))
            webbrowser.open_new_tab(url)
        else:
            url = 'https://vidsrc.to/embed/tv/{id}/{season}/{episode}'
            url = (url.format(id = ('tt'+ id), season = a[1],episode = a[2]))
            webbrowser.open_new_tab(url)

    if x == 'Movie':
        url = 'https://vidsrc.to/embed/movie/{id}'
        url = (url.format(id = ('tt'+ id)))
        webbrowser.open_new_tab(url)


def main():


    text = "Would you like to get a link for a TV show or Movie?"
    title = "Choose"
    button_list = ['TV Show', 'Movie']


    if (easygui.buttonbox(text, title, button_list)) == 'TV Show':
        msg = "Enter the details of what you want to watch"
        title = "Show link"
        fieldNames = ["Name", "Season #", "Episode #"]
        nameofVideo = easygui.multenterbox(msg, title, fieldNames)
        id = getID(nameofVideo[0])
        getLink(nameofVideo, id, 'TV Show')

    else:
        msg = "Enter the details of what you want to watch"
        title = "Show link"
        fieldNames = ["Name"]
        nameofVideo = easygui.multenterbox(msg, title, fieldNames)
        id = getID(nameofVideo[0])
        getLink(nameofVideo, id, 'Movie')

main()

