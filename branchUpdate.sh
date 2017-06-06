#!/bin/bash
#
# @author Zeus Intuivo <zeus@intuivo.com>
#
git pull;
php composer.phar dump-autoload;
php artisan migrate;