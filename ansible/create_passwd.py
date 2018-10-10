#!/usr/bin/python3

import sys
import os
import secrets
import string

def write_htpasswd(filename):
    # check if filename exists
    if os.path.exists(filename):
        print(f"{filename} exists, aborting")
        sys.exit(0)

    # create password
    alphabet = string.ascii_letters + string.digits
    password = "".join(secrets.choice(alphabet) for i in range(20))

    # write password file
    with open(filename, "w") as f:
        f.write(f"zap:{{PLAIN}}{password}\n")

def write_stdout():
    # create password
    alphabet = string.ascii_letters + string.digits
    password = "".join(secrets.choice(alphabet) for i in range(20))

    print(passord)

cmd = sys.argv[1]
if cmd == "htpasswd":
    filename = sys.argv[2]
    write_htpasswd(filename)
elif cmd == "stdout":
    write_stdout()
else:
    print("invalid command")
    exit(1)
