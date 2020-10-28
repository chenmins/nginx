#!/bin/bash
git fetch --all
git reset --hard origin/master
docker build -t chenmins/nginx:latest .