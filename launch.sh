#!/bin/bash

roscore &

# rosrun ros_dream listener.py &

gunicorn --workers=1 flask_server:app &

wait -n

exit $?