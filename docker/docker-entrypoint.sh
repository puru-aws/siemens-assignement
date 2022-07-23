#!/bin/bash

echo "Runtime read by parameters : $1"
if [ $1 = "CPP" ]; then 
    cd /code/$1
    echo "Compiling CPP to create an executable "
    g++ hello.cpp -o runme
    echo "Running the compiled executable "
    chmod +x runme
    ./runme
elif [ $1 = "GO" ]; then
    cd /code/$1
    /usr/local/go/bin/go version
    /usr/local/go/bin/go mod init runme
    echo "Compiling Go executable "
    /usr/local/go/bin/go build
    echo "Running the executable"
    chmod +x runme
    ./runme
else 
    echo "Invalid Parameter "
    exit 1
fi 