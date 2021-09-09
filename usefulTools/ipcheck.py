import requests as request

res=request.get('https://httpbin.org/ip')

print(res.text)
