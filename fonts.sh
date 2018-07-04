#!/usr/bin/env bash
#set -x
set -eo pipefail

# IN
FONT_FULL=/tmp/in/${FONT_NAME=?Define FONT_NAME}
UNICODE_RANGE_COMMON=/tmp/in/unicode-range-common.txt
UNICODE_RANGE_ITINERARY=/tmp/in/unicode-range-itinerary.txt

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
FONT_TARGET_COMMON=${FONTS_TARGET}${FONT_NAME}-common
FONT_TARGET_ITINERARY=${FONTS_TARGET}${FONT_NAME}-itinerary

# WRITE COMMON
pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_COMMON} \
  --output-file=${FONT_TARGET_COMMON}.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_COMMON} \
  --output-file=${FONT_TARGET_COMMON}.woff2 --flavor=woff2

echo "Common fonts written"

# WRITE ITINERARY
pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_ITINERARY} \
  --output-file=${FONT_TARGET_ITINERARY}.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
  --unicodes-file=${UNICODE_RANGE_ITINERARY} \
  --output-file=${FONT_TARGET_ITINERARY}.woff2 --flavor=woff2

echo "Itinerary fonts written"

/usr/app/checkfont.py ${FONT_FULL} ${FONT_TARGET_COMMON}.woff ${FONT_TARGET_ITINERARY}.woff ${UNICODE_RANGE_LESS} ${UNICODE_RANGE_OTHER}

# WRITE OTHER
pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff2 --flavor=woff2

chown ${USERID} ${UNICODE_RANGE_LESS}
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff2
chown ${USERID} ${FONT_TARGET_COMMON}.woff
chown ${USERID} ${FONT_TARGET_COMMON}.woff2
chown ${USERID} ${FONT_TARGET_ITINERARY}.woff
chown ${USERID} ${FONT_TARGET_ITINERARY}.woff2
