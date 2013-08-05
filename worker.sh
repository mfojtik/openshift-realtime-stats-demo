#!/bin/bash

bundle exec "sidekiq -r ./initialize.rb -P sidekiq.pid"
