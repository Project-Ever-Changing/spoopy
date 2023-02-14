#!/bin/bash

cd ndll

{
    rm Windows64/*.ndll
    rm Windows/*.ndll
    rm Mac64/*.ndll
    rm Mac/*.ndll
    rm Linux64/*.ndll
    rm Linux/*.ndll
}&> /dev/null