import random
import string

chars = string.ascii_letters
numbers = string.digits

postcode = 0

def postGen():
	
	post1 = ''.join(random.choice(chars)for i in range(2))
	post2 = ''.join(random.choice(numbers)for i in range(2))
	post3 = ''.join(random.choice(chars)for i in range(2))
	global postcode
	postcode = post1.upper() + post2.upper() + post3.upper()
	
postGen();
