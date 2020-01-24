import hashlib, random, string, datetime

version_secret = "3fbdf489c004aba3589cff5db5c7e455ae26c77716becbfa018ad56681b3a79e"

def make_mac(str):
    str_hash = hashlib.sha512(str.encode()).hexdigest().upper()
    mac_str = str_hash + version_secret
    return hashlib.sha512(mac_str.encode()).hexdigest().upper()

def rand_str(length):
    symbols = string.digits + string.ascii_letters
    return "".join(random.choice(symbols) for cycles in range(length))

def make_token():
    return rand_str(32) + "-" + datetime.datetime.now().strftime("%d%m%Y%H%M%S")
