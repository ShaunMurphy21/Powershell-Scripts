import discord
import requests
import os
from keepalive import keepalive
morse_trans = {
  "a": ".- ",
  "b": "-... ",
  "c": "-.-. ",
  "d": "-.. ",
  "e": ". ",
  "f": "..-. ",
  "g": "--. ",
  "h": ".... ",
  "i": ".. ",
  "j": ".--- ",
  "k": "-.- ",
  "l": ".-.. ",
  "m": "-- ",
  "n": "-. ",
  "o": "--- ",
  "p": ".--. ",
  "q": "--.- ",
  "r": ".-. ",
  "s": "... ",
  "t": "- ",
  "u": "..- ",
  "v": "...- ",
  "w": ".-- ",
  "x": "-..- ",
  "y": "-.-- ",
  "z": "--.. "
}

client = discord.Client()

@client.event
async def on_ready():
  print('We have logged in as {0.user}'.format(client))

@client.event
async def on_message(message):
  keys = []
  ke = ''
  if message.author == client.user:
    return
  if message.content.startswith('$translate'):
    trans = message.content
    trans = trans.replace("$translate ", "")
    trans = trans.replace(" ", "/ ")
    for word, replacement in morse_trans.items():
      trans = trans.replace(word, replacement)
      
    await message.channel.send(trans)
    await message.delete()
    
  if message.author == client.user:
    return
  if message.content.startswith('$convert'):
    morse_trans[" "] = "/ "
    trans = message.content
    trans = trans.replace("$convert ", "")
    lol = trans.split(' ')
    for i in range(len(lol)):
      lol[i] = lol[i] + ' '
    for i in range(len(lol)):
      for key, value in morse_trans.items():
        if value == lol[i]:
          keys.append(key)

    for i in range(len(keys)):
      ke = ke + keys[i] 
    morse_trans.popitem()
  
    await message.channel.send(ke)
    await message.delete()
keepalive()
client.run('OTgwNDQxOTgzNzUzNTI3MzU3.Ggf3HJ.cWGSAxPRi4Grotx9wFu6x2bcgIk9O3cdX22TvU')
  
