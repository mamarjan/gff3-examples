#!/usr/bin/env python

import sys
from BCBio import GFF

handle = open(sys.argv[1])

count = 0
for rec in GFF.parse(handle):
  count = count + 1

handle.close()

