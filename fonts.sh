#!/usr/bin/env bash
#set -x
set -eo pipefail

# IN
read -r -a FONT_FILES_KEYS <<< ${FONT_FILES_KEYS=?Define FONT_FILES_KEYS}
FONT_FULL=/tmp/in/${FONT_NAME=?Define FONT_NAME}

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

CHECKFONT_RANGES=""

for RANGE_NAME in "${FONT_FILES_KEYS[@]}"
do
  FONT_FILE_NAME=${FONTS_TARGET}${FONT_NAME}-${RANGE_NAME}
  RANGE_FILE_NAME=/tmp/in/unicode-range-${RANGE_NAME}.txt
  pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
    --unicodes-file=${RANGE_FILE_NAME} \
    --output-file=${FONT_FILE_NAME}.woff --flavor=woff

  pyftsubset ${FONT_FULL} --name-IDs='*' --no-ignore-missing-unicodes \
    --unicodes-file=${RANGE_FILE_NAME} \
    --output-file=${FONT_FILE_NAME}.woff2 --flavor=woff2

  chown ${USERID} ${FONT_FILE_NAME}.woff
  chown ${USERID} ${FONT_FILE_NAME}.woff2

  if [ -n "$CHECKFONT_RANGES" ]; then
    CHECKFONT_RANGES="$CHECKFONT_RANGES|"
  fi
  CHECKFONT_RANGES="$CHECKFONT_RANGES$RANGE_NAME"

  echo "Font range '${RANGE_NAME}' written."
done

/usr/app/checkfont.py ${FONT_FULL} ${CHECKFONT_RANGES} ${UNICODE_RANGE_LESS} ${UNICODE_RANGE_OTHER}

# WRITE OTHER
pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff --flavor=woff

pyftsubset ${FONT_FULL} --name-IDs='*' \
  --unicodes-file=${UNICODE_RANGE_OTHER} \
  --output-file=${FONTS_TARGET}${FONT_NAME}-the-rest.woff2 --flavor=woff2

echo "Font range 'the rest' written."

chown ${USERID} ${UNICODE_RANGE_LESS}
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff
chown ${USERID} ${FONTS_TARGET}${FONT_NAME}-the-rest.woff2
