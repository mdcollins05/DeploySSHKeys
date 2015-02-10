I created this to simplify deploying hosts automatically via Ansible.

This script is designed to run as root, but can work as any user if the user is only deploying their own keys.

It will create and set permissions for each user's `~/.ssh/`, if necessary. It will also make a backup of the `authorized_keys` to `authorized_keys.orig-%Y%m%d-%H%M%S` if there are any changes.

It accomplishes this by taking the URL of a git repo and clones the repo locally. It then processes each file matching $user.keys for any user that exists on the system.

How to run it:

`deploy.sh https://github.com/mdcollins05/DeploySSHKeys.git`

Binaries that are used (most, if not all are usually already installed in a distro):
* basename
* id
* getent
* diff
* cp, mv, chown, chmod