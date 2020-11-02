#!/usr/bin/env bash

# set the git username and email
sudo -i -u vagrant git config --global user.name "$1"
sudo -i -u vagrant git config --global user.email "$2"
