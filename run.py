import os
from sys import argv

def load_data_aead(ad="ASCON", pt="ascon", ct="ascon"):
    keysize = 16
    key   = bytes(bytearray(os.urandom(keysize))) # zero_bytes(keysize)
    nonce = bytes(bytearray(os.urandom(16)))      # zero_bytes(16)
    
    k = len(key) * 8   # bits
    r = 64 
    a = 12   # rounds
    b = 6   # rounds
    l = len(ad) * 8
    y = len(pt) * 8

    key = str(key.hex())
    nonce = str(nonce.hex())
    associated_data = str(ad.hex())
    plain_text = str(pt.hex())
    cipher_text = str(ct.hex())
    
    with open('testbench/aead_parameters.v', 'w') as file:
        file.write("`define k " + str(k) + '\n')
        file.write("`define r " + str(r) + '\n')
        file.write("`define a " + str(a) + '\n')
        file.write("`define b " + str(b) + '\n')
        file.write("`define l " + str(l) + '\n')
        file.write("`define y " + str(y) + '\n')

        file.write("`define KEY 'h" + key + '\n')
        file.write("`define NONCE 'h" + nonce + '\n')
        file.write("`define AD 'h" + associated_data + '\n')
        file.write("`define PT 'h" + plain_text + '\n')
        file.write("`define CT 'h" + cipher_text)

def load_data_hash(variant="Ascon-Hash", message="ascon", hashlength=32):
    a = 12   # rounds
    b = 12
    r = 64 # bytes
    y = len(message) * 8
    h = 32 * 8
    l = hashlength * 8
    mes = str(message.hex())

    with open('testbench/hash_parameters.v', 'w') as file:
        file.write("`define r " + str(r) + '\n')
        file.write("`define a " + str(a) + '\n')
        file.write("`define b " + str(b) + '\n')
        file.write("`define h " + str(h) + '\n')
        file.write("`define l " + str(l) + '\n')
        file.write("`define y " + str(y) + '\n')

        file.write("`define MESSAGE 'h" + mes + '\n')

# Choose the ASCON variant
variant == argv[1]

# AEAD Data
associateddata = b"ASCON"
plaintext      = b"ascon"
ciphertext     = b"ascon"

# Hash Data
message        = b"Hello World!"
hashlength     = 32         # bytes

# Configuration
threshold = 0
fault_protection = 0

if variant == 'aead':
    load_data_aead(associateddata,plaintext,ciphertext)
elif variant == 'hash':
    load_data_hash(variant,message,threshold,fault_protection,hashlength)
else:
    print("Please enter a valid variant of Ascon")
