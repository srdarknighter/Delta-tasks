import random
import math
def isPrime(x):
    if x<2:
        return False
    for i in range(2, x//2 + 1):
        if x%i ==0:
            return False
    return True


def generate_prime(min,max):
    prime = random.randint(min,max)
    while not isPrime(prime):
        prime = random.randint(min,max)
    return prime

def mod_inverse(e, phi):
    for d in range(3,phi):
        if (d*e) % phi == 1:
            return d
    raise ValueError("mod_inverse does not exist")
 
p,q = generate_prime(1000,10000),generate_prime(1000,10000)

if p==q:
    q = generate_prime(1000,10000)

n = p*q
phi = (p-1)*(q-1)
e = random.randint(3, phi-1)

while math.gcd(e, phi) != 1:
    e = random.randint(3,phi-1)

d = mod_inverse(e,phi)
print("Public key is: ", e)
print("Private key is: ",d)
print("n is: ", n)
print("phi of n is: ",phi)
print("p is: ",p)
print("q is: ",q)

message = "Hello World"

message_encoded = []
for c in message:
    message_encoded.append(ord(c))

cyphertext = [pow(c,e,n) for c in message_encoded]

print(cyphertext)

message_decoded = [pow(c,d,n) for c in cyphertext]

message_final = "".join(chr(c) for c in message_decoded)
print(message_final)