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
    * myfont-light.woff
    * myfont-light.woff2
    * myfont-the-rest.woff
    * myfont-the-rest.woff2