#!/bin/sh

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php 
rm composer-setup.php

curl -sS https://get.symfony.com/cli/installer | bash

if [ -d "bin" ]; then
  rm -rfv bin/composer
  rm -rfv bin/symfony
  mv -v composer.phar bin/composer
  mv -v $HOME/.symfony5/bin/symfony bin/symfony
else
  mkdir bin
  mv -v composer.phar bin/composer
  mv -v $HOME/.symfony5/bin/symfony bin/symfony
fi


