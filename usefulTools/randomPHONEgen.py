import string
import random


global num
num = 0

def phone():

    num = '077' + ''.join(random.choice(string.digits)for i in range(8))
		
    print(num)


for i in range(10):
    phone();
