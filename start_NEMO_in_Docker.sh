#!/bin/bash

# Exit if any of following commands fails
set -e

# Run migrations to create or update the database
django-admin migrate

# Collect static files
django-admin collectstatic --no-input --clear
cp -a /usr/local/lib/python3.6/site-packages/NEMO/migrations/. /nemo/migrations/copy
# Run NEMO
gunicorn --config=/etc/gunicorn_configuration.py NEMO.wsgi:application