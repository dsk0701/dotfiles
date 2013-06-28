#! /bin/bash

ErrorCheck()
{
    $*
    if [ $? -ne 0 ]; then
        echo "------- Error Command : $* -------"
        exit 1
    fi
}

__usage()
{
cat <<__EOT__

    "Usage: `basename $0` [zip name]"

__EOT__

exit 1
}

if [ $# -lt 1 ]; then
    __usage
fi

ARTIFACTS_ZIP_NAME=$1

SIMBOL_FILE_DIR=`ErrorCheck find ~/Library/Developer/Xcode/DerivedData -name "*.dSYM" | grep -w "Debug-iphonesimulator"`
SIMBOL_FILE_DIR_NAME=`dirname ${SIMBOL_FILE_DIR}`
SIMBOL_FILE_BASE_DIR=`basename ${SIMBOL_FILE_DIR}`

ErrorCheck pushd ${SIMBOL_FILE_DIR_NAME}
ErrorCheck zip -r ${ARTIFACTS_ZIP_NAME} ${SIMBOL_FILE_BASE_DIR}
ErrorCheck mv ${ARTIFACTS_ZIP_NAME} ~/Desktop/.
ErrorCheck popd

