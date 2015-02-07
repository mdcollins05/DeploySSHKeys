#!/bin/bash

if [ -d ./keys/ ]
then
  echo rm -rf ./keys/
fi

echo git clone git_repo ./keys/

FILES=./keys/*.key
for file in $FILES
do
  filename=$(basename "$file")
  user=${filename%.*}
  # if ~user exists, create .ssh, move original authorized_keys, copy user.key to authorized_keys
  # id -u matt > /dev/null 2>&1 ; echo $?

  if [ `id -u ${user} > /dev/null 2>&1; echo $?` -eq 1 ]
  then
    continue
  fi

  userhome=`getent passwd ${user} | cut -f6 -d:`

  if [ ! -d "${userhome}/.ssh/" ]
  then
    echo mkdir ${userhome}/.ssh/
    echo chmod 700 ${userhome}/.ssh/
  fi

  if [ -f "${userhome}/.ssh/authorized_keys" ]
  then
    echo mv "${userhome}/.ssh/authorized_keys" "${userhome}/.ssh/authorized_keys.orig"
  fi

  echo cp ./keys/matt.keys ${userhome}/.ssh/authorized_keys
  echo chmod 600 ${userhome}/.ssh/authorized_keys
done

