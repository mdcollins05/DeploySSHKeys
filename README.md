I created this to simplify deploying hosts automatically via Ansible.

This script is designed to run as root, but can work as any user if the user is only deploying their own keys.

It will create and set permissions for each user's `~/.ssh/`, if necessary. It will also make a backup of the `authorized_keys` to `authorized_keys.orig-%Y%m%d-%H%M%S` if there are any changes.

It accomplishes this by taking the URL of a git repo and clones the repo locally. It then processes each file matching $user.keys for any user that exists on the system.

How to run it:

`deploy.sh $REPO`

Binaries that are used (most, if not all are usually already installed in a distro):
* basename
* id
* getent
* diff
* cp, mv, chown, chmod

Hint: Using `ssh -A $HOST` to connect to the host is great when you need a key to access your repo but don't have them yet and you've added the key to your SSH agent.
