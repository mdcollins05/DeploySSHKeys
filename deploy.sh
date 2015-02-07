#!/bin/bash

repo=$1

if [ -d ./keys/ ]
then
  echo rm -rf ./keys/
fi

if [ -z "$repo" ]
then
  echo "You must give the 'repo' variable a value!"
  exit 1
fi

echo git clone ${repo} ./keys/

FILES=./keys/*.keys
for keyfile in $FILES
do
  filename=$(basename "$keyfile")
  user=${filename%.*}
  # if ~user exists, create .ssh, move original authorized_keys, copy user.key to authorized_keys
  # id -u matt > /dev/null 2>&1 ; echo $?

  if [ -z "$user" ]
  then
    continue
  fi

  if [ `id -u ${user} > /dev/null 2>&1` ]
  then
    continue
  fi

  userhome=`getent passwd ${user} | cut -f6 -d:` # This should probably change, but maybe we can fix it above.

  if [ ! -d "${userhome}/.ssh/" ]
  then
    echo mkdir ${userhome}/.ssh/
    echo chmod 700 ${userhome}/.ssh/
  fi

  if [ -f "${userhome}/.ssh/authorized_keys" ]
  then
    if [ ! `diff "${keyfile}" "${userhome}/.ssh/authorized_keys" > /dev/null 2>&1` ]
    then
      echo mv "${userhome}/.ssh/authorized_keys" "${userhome}/.ssh/authorized_keys.orig-$(date +%Y%m%d-%H%M%S)"
    fi
  fi

  echo cp ${keyfile} ${userhome}/.ssh/authorized_keys
  echo chmod 600 ${userhome}/.ssh/authorized_keys
done

