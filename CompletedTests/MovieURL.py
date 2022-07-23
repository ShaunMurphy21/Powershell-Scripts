from bs4 import BeautifulSoup as bs
import requests as request

movie = input('Enter a movie name:\n>>')
try:
    movie=movie.replace(' ','+')
except:
    pass

url = 'https://www1.moviesjoy.sc/searching/'+movie

r = request.get(url)
r = r.content
doc = bs(r, "html.parser")
for a in doc.find_all('a',href=True, class_='poster'):
    print('URL:'+a['href'])

