#!/bin/bash

repo=$1

if [ -d ./keys/ ]
then
  rm -rf ./keys/
fi

if [ -z "$repo" ]
then
  echo "Error: You must give the 'repo' variable a value!"
  exit 1
fi

git clone ${repo} ./keys/

FILES=./keys/*.keys
for keyfile in $FILES
do
  filename=$(basename "$keyfile")
  user=${filename%.*}

  if [ -z "$user" ] # Make sure we have something
  then
    continue # Variable is empty, let's skip this one
  fi

  if [ "$EUID" -ne 0 ] # Are we running as root?
  then
    if [ `id -u ${user}` -ne "${EUID}" ] # Are we handling the keys file for the current user?
    then
      continue # Nope, let's skip this one
    fi
  fi

  if [ `id -u ${user} > /dev/null 2>&1` ] # Is the user on the system?
  then
    continue # User doesn't exist, skip!
  fi

  userhome=`getent passwd ${user} | cut -f6 -d:` # Let's get the user's home dir!

  if [ ! -d "${userhome}/.ssh/" ] # Does the .ssh folder exist?
  then
    mkdir ${userhome}/.ssh/ # Create the folder
    chmod 700 ${userhome}/.ssh/ # Set those permissions
  fi

  if [ -f "${userhome}/.ssh/authorized_keys" ] # Does the file exist already?
  then
    if [ ! `diff "${keyfile}" "${userhome}/.ssh/authorized_keys" > /dev/null 2>&1` ] # Is there a difference between the two?
    then
      mv "${userhome}/.ssh/authorized_keys" "${userhome}/.ssh/authorized_keys.orig-$(date +%Y%m%d-%H%M%S)" # Backup the original
    fi
  fi

  cp ${keyfile} ${userhome}/.ssh/authorized_keys # Copy the new contents in place
  chmod 600 ${userhome}/.ssh/authorized_keys # Set the permissions right
done

