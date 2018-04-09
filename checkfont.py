#!/usr/bin/env python
from itertools import chain
import unicodedata
import pdb
import sys

from fontTools.ttLib import TTFont
from fontTools.unicode import Unicode

def chars(font):
  ttf = TTFont(font, 0, allowVID=0,
                ignoreDecompileErrors=True,
                fontNumber=-1)
  cmap = set(["U+{0:0=4x}".format(element[0]).upper() for element in chain.from_iterable([y + (Unicode[y[0]],) for y in x.cmap.items()] for x in ttf["cmap"].tables)])
  ttf.close()
  return cmap

chars0 = chars(sys.argv[1])
chars1 = chars(sys.argv[2])
ch = chars0 - chars1
unicode_range_other = ",".join(sorted(list(ch)))
unicode_range_light = ",".join(sorted(list(chars1)))

f = open(sys.argv[3], 'w')
f.write("@unicode_range_light: ")
f.write(unicode_range_light)
f.write(";\n")
f.write("@unicode_range_other: ")
f.write(unicode_range_other)
f.write(";\n")
f.close()

f = open(sys.argv[4], 'w')
f.write(unicode_range_other)
f.close()
