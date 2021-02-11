#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# set file rights to www-data
sudo chown www-data /var/www/html/ -R
sudo chmod g+w /var/www/html/ -R

# Execute CMD
exec "$@"
