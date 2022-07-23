import string
import random
import requests
import threading
threads = []
def main():
    alphabet = string.ascii_lowercase
    dig = string.digits
    count = 1
    while count == 1:
        n = ''
        for i in range(12):
            num = random.randint(0,10)
            n = n+random.choice(alphabet)
            if num %2 == 0:
                n = n+random.choice(dig)
        url = 'http://dood.polskastrem.cloud/e/'+n
        r = requests.get(url)
        r = r.content

        b = '!DOCTYPE'
        b = bytes(n,'utf-8')
        if b in r:
            print('Found: '+url)
            count = count + 1
        else:
            print('No: '+ url)
            
if __name__ == '__main__':
	for i in range(50):
		t = threading.Thread(target=main) #this sets up threading so it allows for the program to run fast
		t.start() #starts the threads