#!/bin/bash
set -e
rm -f /comedy_recommendation_app/tmp/pids/server.pid
exec "$@"
