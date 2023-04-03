import string
import random

email = []
chars = string.ascii_letters + '123456789'

for i in range(10):

	x ='@' + ''.join(random.choice(chars.lower())for i in range(5))+ '.com'
	print(x)
