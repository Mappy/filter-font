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

chars_all = chars(sys.argv[1])
chars_common = chars(sys.argv[2])
chars_itinerary = chars(sys.argv[3])
chars_other = chars_all - chars_common - chars_itinerary

unicode_range_other = ",".join(sorted(list(chars_other)))
unicode_range_common = ",".join(sorted(list(chars_common)))
unicode_range_itinerary = ",".join(sorted(list(chars_itinerary)))

f = open(sys.argv[4], 'w')
f.write("@unicode_range_common: ")
f.write(unicode_range_common)
f.write(";\n")
f.write("@unicode_range_itinerary: ")
f.write(unicode_range_itinerary)
f.write(";\n")
f.write("@unicode_range_other: ")
f.write(unicode_range_other)
f.write(";\n")
f.close()

f = open(sys.argv[5], 'w')
f.write(unicode_range_other)
f.close()
