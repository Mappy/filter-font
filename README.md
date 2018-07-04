Wrapper around fonttools (pyftsubset) to extract characters of a font

Python script that automate the extraction of a subset of a font.
useful for CSS3 property unicode-range

```
docker run -it --rm \
  -e FONT_NAME=myfont.woff  \
  -e USERID=${UID}  \
  -v where-my-font-and-light-range-is/:/tmp/in/  \
  -v where-to-write-less/:/tmp/less/  \
  -v where-to-write-font/:/tmp/font  \
  fonttools
```

Generate 4 fonts
* myfont-common.woff
* myfont-common.woff2
* myfont-itinerary.woff
* myfont-itinerary.woff2
* myfont-the-rest.woff
* myfont-the-rest.woff2