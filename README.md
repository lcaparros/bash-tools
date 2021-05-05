# bash-tools

This repository contains multiple useful tools made in bash. Please find below a little description of each of them.

## Template engine

We know different template engines as erb, mustache and some others. However there's no way to use easily those engines with our bash scripts. This what is covered by this tool. This script allows us to define a template file using the separators we want and fill it just running this script.

### Usage

```
Usage:"
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
    echo "                                with empty values
```

### Example of template file and usage

Find below an example of a template file. This template use the default separators **<= and =>**

```
ID=422
NAME=MyService
ENV=<=env=>
IPVERSION=IPV6
HOTS=<=host=>
PORT=<=port=>
SECURE=false
DELAY=10
```

To fill this template run the command below, for instance:

```
$ ./engine.sh -f file.properties.template -p env=prod -p host=127.0.0.1 -p port=4444
```
