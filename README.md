Wrapper around fonttools (pyftsubset) to extract characters of a font

Python script that automate the extraction of a subset of a font.
useful for CSS3 property unicode-range

```
docker run -it --rm \
  -e FONT_NAME=myfont.woff  \
  -e FONT_FILES_KEYS=key1 key2  \
  -e USERID=${UID}  \
  -v where-my-font-and-light-range-is/:/tmp/in/  \
  -v where-to-write-less/:/tmp/less/  \
  -v where-to-write-font/:/tmp/font  \
  fonttools
```

Generate 2 fonts per key plus 2 for the rest
* myfont-key1.woff
* myfont-key1.woff2
* myfont-key2.woff
* myfont-key2.woff2
* myfont-the-rest.woff
* myfont-the-rest.woff2