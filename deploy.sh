#!/bin/bash

FILES=./keys/*.key
for file in $FILES
do
  # if ~user exists, create .ssh, move original authorized_keys, copy user.key to authorized_keys
  # id -u matt > /dev/null 2>&1 ; echo $?
done
