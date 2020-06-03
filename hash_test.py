# -*- coding: utf-8 -*-
"""
@author: obaby
@license: (C) Copyright 2013-2020, obaby@mars.
@contact: root@obaby.org.cn
@link: http://www.obaby.org.cn
        http://www.h4ck.org.cn
        http://www.findu.co
@file: hash_test.py
@time: 2020/6/3 17:14
@desc:
"""

import hashlib,base64
import os, sys


def calc_hash(filepath):
    with open(filepath, 'rb') as f:
        sha1obj = hashlib.sha1()
        sha1obj.update(f.read())
        sha1_hash = sha1obj.hexdigest()
        print("sha1:", sha1_hash)
        bs = base64.encodebytes(sha1obj.digest())
        print("hash:", bs)
        return bs


def calc_md5(filepath):
    with open(filepath, 'rb') as f:
        md5obj = hashlib.md5()
        md5obj.update(f.read())
        md5_hash = md5obj.hexdigest()
        print(md5_hash)
        return md5_hash


if __name__ == "__main__":
    if len(sys.argv) == 2:
        hashfile = sys.argv[1]
        if not os.path.exists(hashfile):
            hashfile = os.path.join(os.path.dirname(__file__), hashfile)
            if not os.path.exists(hashfile):
                print("cannot found file")
            else:
                calc_hash(hashfile)
        else:
            calc_hash(hashfile)
        # raw_input("pause")
    else:
        print("no filename")