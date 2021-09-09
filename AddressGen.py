import random
import string


chars = string.ascii_letters

addresses = []

addy = ''

def address_Gen():
	
	address1 = ''.join(random.choice(string.digits)for i in range(2))
	address2 = ''.join(random.choice(chars)for i in range(6))
	global addy
	addy = address1 + ' ' + address2.upper() + ' GARDENS'
	
address_Gen();