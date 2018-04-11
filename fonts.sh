#!/usr/bin/env bash
#set -x
set -eo pipefail

# IN
FONT_FULL=/tmp/in/${FONT_NAME=?Define FONT_NAME}
UNICODE_RANGE_LIGHT=/tmp/in/unicode-range-light.txt

# OUT
echo UNICODE_RANGE_OTHER=${UNICODE_RANGE_OTHER:=/tmp/unicode_range_other.txt}

UNICODE_RANGE_LESS=/tmp/less/unicode-range.less
FONTS_TARGET=/tmp/font/

[[ ! -d ${FONTS_TARGET} && -w ${FONTS_TARGET} ]] && echo "FONTS_TARGET should be a directory" && exit 1
[[ ! -w $(dirname ${UNICODE_RANGE_OTHER}) ]] && echo "UNICODE_RANGE_OTHER file should be in a writable directory" && exit 1
echo "Will affect generated files to ${USERID:?Define USERID}"

# COMPUTED
FONT_FULL_NAME=$(basename ${FONT_FULL})
FONT_NAME=${FONT_FULL_NAME%.*}
FONT_TARGET_LIGHT=${FONTS_TARGET}${FONT_NAME}-light

pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_LIGHT} \
  --output-file=${FONT_TARGET_LIGHT}.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_LIGHT} \
  --output-file=${FONT_TARGET_LIGHT}.woff2 --flavor=woff2

/usr/app/checkfont.py ${FONT_FULL} ${FONT_TARGET_LIGHT}.woff ${UNICODE_RANGE_LESS} ${UNICODE_RANGE_OTHER}

pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff2 --flavor=woff2

chown ${USERID} ${UNICODE_RANGE_LESS}
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff2
chown ${USERID} ${FONT_TARGET_LIGHT}.woff
chown ${USERID} ${FONT_TARGET_LIGHT}.woff2
