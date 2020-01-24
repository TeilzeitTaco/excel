import hashlib

version_secret = "3fbdf489c004aba3589cff5db5c7e455ae26c77716becbfa018ad56681b3a79e"

def make_mac(str):
    str_hash = hashlib.sha512(str.encode()).hexdigest().upper()
    mac_str = str_hash + version_secret
    print(mac_str)
    return hashlib.sha512(mac_str.encode()).hexdigest().upper()
