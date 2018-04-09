FROM python:3-slim

RUN pip install brotli fonttools

RUN mkdir -p /usr/app
COPY *.sh /usr/app
COPY *.py /usr/app

CMD /usr/app/fonts.sh