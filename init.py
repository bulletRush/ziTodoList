#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys

__inserted = False

if not __inserted:
    cur_dir = os.path.dirname(os.path.realpath(__file__))
    peewee_path = os.path.join(cur_dir, "thirdparty")
    print peewee_path
    sys.path.insert(0, peewee_path)
    __inserted = True
