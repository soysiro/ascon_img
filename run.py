import os

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


# AEAD Data
associateddata = b"ASCON"
plaintext      = b"ascon-unicass"
ciphertext     = b"ascon-unicass"


load_data_aead(associateddata,plaintext,ciphertext)
