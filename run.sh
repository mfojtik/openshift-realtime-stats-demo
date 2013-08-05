#!/bin/bash

bundle exec "rackup config.ru -s puma -E production -p 9292"
