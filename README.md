# Rubuntu

A simple ROS-Flask service/server for deeppavlov's DREAM.

It currently is only meant to be used as a service in DREAM.
Standalone launching is also possible, but you would have to modify the Dockerfile and `server.py` accordingly.
For example:
- remove DREAM-specific imports from `server.py`
- modify paths in Dockerfile

Or you could even use the Dockerfile in this repo as a general guide or a reference point to installing ROS on debian-based linux distributions. It may prove to be helpful, as I found the process of installing and using ROS quite confusing at first.