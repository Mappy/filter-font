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

f = open(sys.argv[3], 'w')

chars_other = chars(sys.argv[1])
chars_ranges = sys.argv[2].split("|")
for range_name in chars_ranges:
  range_file = "/tmp/font/MappyIcons-Regular-" + range_name + ".woff"
  chars_range = chars(range_file)
  chars_other = chars_other - chars_range
  f.write("@unicode_range_" + range_name + ": ")
  f.write(",".join(sorted(list(chars_range))))
  f.write(";\n")

unicode_range_other = ",".join(sorted(list(chars_other)))

f.write("@unicode_range_other: ")
f.write(unicode_range_other)
f.write(";\n")
f.close()

f = open(sys.argv[4], 'w')
f.write(unicode_range_other)
f.close()
