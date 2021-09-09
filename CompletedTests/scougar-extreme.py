import requests as request #imports the requests fuction as request so I dont keep forgetting.
import json #has the tools requires to read the json file with the names in 
import os
import random #self explanatory
import string #to use when making randomised emails/passwords
import threading #speed up script

url = 'https://httpbin.org'

numbers = string.digits

num = None

def phone():

		global num

		num = '077' + ''.join(random.choice(string.digits)for i in range(8))
		return num
		

chars2 = string.ascii_letters

addresses = []

addy = None

def address_Gen():
	
	address1 = ''.join(random.choice(string.digits)for i in range(2))
	address2 = ''.join(random.choice(chars2)for i in range(6))
	global addy
	addy = address1 + ' ' + address2.upper() + ' GARDENS'
	return addy

postcode = 0

def postGen():

	post1 = ''.join(random.choice(chars2)for i in range(2))
	post2 = ''.join(random.choice(numbers)for i in range(2))
	post3 = ''.join(random.choice(chars2)for i in range(2))
	global postcode
	postcode = post1.upper() + post2.upper() + post3.upper()
	return postcode

emailList = []

'''payload = {
	
	"firstname":
	"lastname":
	"email":
	"telephone":
	"address_1":
	"postcode":
	"country_id":
	"zone_id":
	"password":
	"confirm":
}
'''

chars1 = string.ascii_letters + '123456789' #creates random string to use for random email domain

for i in range(100): #creates 100 random email domains and appends them to 'emailList' 

	x ='@' + ''.join(random.choice(chars1.lower())for i in range(5))+ '.com'
	emailList.append(x)

names = json.loads(open('names.json').read())

chars = string.ascii_letters + string.digits + '!%^&*()@#./' #used to create a random password
random.seed = (os.urandom(1024))

threads = []


#function for telephone number

num = '077' + ''.join(random.choice(string.digits)for i in range(8))



def main(name): #function for the main part of the program
	for name in names:
		name_extra = ''.join(random.choice(string.digits)) #creates a random 'choice' of letters/digits/symbols from the chars 

		username = name.lower() + name_extra + random.choice(emailList) #combines all the elements. So a name from names.json, random letters/digits/symbols we created above then adds the random email domain
		password = ''.join(random.choice(chars)for i in range (8))
		telephone = phone();
		#print(telephone)
		extra = random.choice(string.ascii_letters)
		lastname = ''.join(name.upper())
		#print(lastname)
		#print(name)
		postcode = postGen();
		#print(postcode)
		addy = address_Gen();
		print('sending username: %s,  password %s:, postcode: %s, address: %s:, phone: %s, name: %s, last name: %s,' %(username, password, postcode, addy,telephone,name, lastname))
		request.post(url, allow_redirects=True, data={

												 "firstname":name.lower(),
												 "lastname":lastname.lower(),
												 "email":username,
												 "telephone":phone,
												 "address_1":addy,
												 "postcode":postcode,
												 "country_id":222,
												 "zone_id":3526,
												 "password":password,
												 "confirm":password,
												 "agree": 1,
												 "city":"oxford",
												 "newsletter": 0,
												 "customer_group_id": 1

												
												})
		  #prints each one it creats in the format username(email), password

if __name__ == '__main__':
	for i in range(10):
		t = threading.Thread(target=main, args=(1,)) #this sets up threading so it allows for the program to run fast
		t.start() #starts the threads
