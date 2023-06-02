FROM ubuntu:20.04

ARG USERNAME=dkr
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata keyboard-configuration

RUN groupadd --gid $USER_GID $USERNAME && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && apt update && apt install -y sudo && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

# if there are errors mentioning the firewall/ports/ip/index out of range, the next command may be responsible
#RUN sed -i "s/ppid = open(name).readlines()\[0\].split(\')\')\[1\].split()\[1\]/ppid = open(name).readlines()\[0\].rsplit(\')\',1)\[1\].split()\[1\]/" /usr/lib/python3/dist-packages/ufw/util.py

RUN apt install -y gnupg curl ca-certificates

RUN grep -E 'sudo|wheel' /etc/group

USER $USERNAME

SHELL ["/usr/bin/bash", "-c"]

RUN sudo apt update
RUN sudo apt install -y lsb-release build-essential python3 gcc g++ make cmake git python-is-python3 apt-utils nginx

RUN sudo apt install -y ufw

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN sudo apt update
RUN sudo apt install -y ros-noetic-desktop

RUN source /opt/ros/noetic/setup.bash
RUN echo "export PATH=/home/dkr/.local/bin:$PATH" >> /home/$USERNAME/.bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc
RUN source /home/$USERNAME/.bashrc

RUN echo /home/$USERNAME/.bashrc

RUN sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool
RUN sudo rosdep init
RUN rosdep update

RUN sudo apt install -y python3-pip
RUN pip install flask

#RUN pip install "fastapi[all]"
#RUN pip install pydantic

RUN cat /home/$USERNAME/.bashrc

COPY ./listener.py /home/$USERNAME/listener.py
COPY ./flask_server.py /home/$USERNAME/flask_server.py
#COPY ./fapi_server.py /home/$USERNAME/fapi_server.py

COPY ./launch.sh /home/$USERNAME/launch.sh
RUN chmod +x /home/$USERNAME/launch.sh

RUN mkdir -p ~/catkin_ws/src
RUN touch ~/catkin_init.sh
RUN echo "cd ~/catkin_ws && catkin_make && source devel/setup.bash && echo $ROS_PACKAGE_PATH && cd ~/catkin_ws/src && catkin_create_pkg ros_dream std_msgs rospy roscpp && cd ~/catkin_ws && catkin_make && source ~/catkin_ws/devel/setup.bash && source ~/.bashrc && mkdir ~/catkin_ws/src/ros_dream/scripts && mv ~/talker.py ~/catkin_ws/src/ros_dream/scripts/talker.py && mv ~/listener.py ~/catkin_ws/src/ros_dream/scripts/listener.py && cd ~/catkin_ws && catkin_make && cd ~ && source ~/catkin_ws/devel/setup.bash && roscore" >> ~/catkin_init.sh

RUN chmod +x ~/catkin_init.sh

RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc

WORKDIR /home/$USERNAME/

CMD ./launch.sh