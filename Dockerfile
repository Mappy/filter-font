FROM python:3-slim

RUN apt-get update && apt-get install -y build-essential
RUN pip install -U setuptools
RUN pip install brotli fonttools

RUN mkdir -p /usr/app
COPY *.sh /usr/app
COPY *.py /usr/app

CMD /usr/app/fonts.sh
