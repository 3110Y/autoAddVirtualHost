#!/usr/bin/env bash

addVH() {
    PATH = $1
    TEMPLATE    =   `cat template.host`

}

dellVH() {
    PATH = "$1/www"


}

echo "Creating Virtual Host"
PATH = $1
cd PATH



addVH PATH
dellVH PATH