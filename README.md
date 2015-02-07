This script is designed to run as root, but can work as any user if the user is only deploying their own keys.

It can operate without a ~/.ssh/ (it'll create it if needed), will save the original authorized_keys (if it exists) as authorized_keys.orig-%Y%m%d-%H%M%S`.

It clones a repository (containing the keys), then proceeds to copy the ./keys/$user.keys to the $user's ~/.ssh/authorized_keys after making, ensuring permissions are correct and making a backup of the original authorized_keys file.
