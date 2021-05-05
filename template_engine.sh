#!/bin/bash

usage() {
    echo "Usage:"
    echo "    engine.sh -h                Display this help message."
    echo "    Mandatory options:"
    echo "        -f                      Template file to be filled"
    echo "    Non-mandatory options:"
    echo "        -p                      Parameters to be used to fill the template"
    echo "                                It must be defined like key=value"
    echo "                                Example: engine.sh -f file/path -p username=john -p id=32"
    echo "        -s                      Opening delimiter. This define how a keyword is declared in the template"
    echo "                                Default: <="
    echo "        -e                      Ending delimiter. This define how a keyword is declared in the template"
    echo "                                Default: =>"
    echo "        -o                      Name of output file"
    echo "        -d                      Dirty file. This avoid to substitute the rest of parameters in the template"
    echo "                                with empty values"
}

split() {
    IFS='=' read -ra splitted <<< "$1"
    key="${splitted[0]}"
    value="${splitted[1]}"
}

cdir=$(pwd)
dir="$(dirname "$0")"

cd $dir

opening_delimiter="<="
ending_delimiter="=>"
output_file_path=""
clean_file=true
options=':hf:p:s:e:o:d'
while getopts $options opt; do
    case ${opt} in
        h )
            usage
            exit 0
            ;;
        f )
            [[ "${OPTARG}" == "/"* ]] && file_path="${OPTARG}" || file_path="${cdir}/${OPTARG}"
            ;;
        p )
            params+=("${OPTARG}")
            ;;
        s )
            opening_delimiter="${OPTARG}"
            ;;
        e )
            ending_delimiter="${OPTARG}"
            ;;
        o )
            output_file_path="${OPTARG}"
            ;;
        d )
            clean_file=false
            ;;
        : )
            echo "Invalid option: ${OPTARG} requires an argument" 1>&2
            exit 1
            ;;
        \? )
            echo "Invalid option ${OPTARG}"
            exit 1
            ;;
    esac
done
shift "$((OPTIND -1))"

if [ -z "${file_path}" ] ; then
  echo "Template file path must be included. Please use -f option to do it"
  exit 1
fi

if [ ! -f "${file_path}" ] ; then
    echo "Template file does not exist! Please provide a valid template file"
    exit 1
fi

if [ -z "${output_file_path}" ] ; then
    if [[ ${file_path} == *".template" ]] ; then
        output_file_path=${file_path::-9};
    else
        output_file_path="${file_path}.final";
    fi
fi

cp ${file_path} ${output_file_path}
for param in "${params[@]}"; do
    split "$param"
    sed -i 's@'"${opening_delimiter}${key}${ending_delimiter}"'@'"${value}"'@g' "${output_file_path}"
done

if ${clean_file}; then
    sed -i 's@'"${opening_delimiter}\(.*\)${ending_delimiter}"'@'""'@g' "${output_file_path}"
fi

cd $cdir
