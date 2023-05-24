FROM ubuntu:20.04

ARG USERNAME=client
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata keyboard-configuration

RUN groupadd --gid $USER_GID $USERNAME && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && apt update && apt install -y sudo && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

SHELL ["/usr/bin/bash", "-c"]

RUN sudo apt install -y build-essential python3 gnupg curl gcc g++ make cmake git apt-utils python3-pip
# flask

RUN echo "export PATH=/home/dkr/.local/bin:$PATH" >> /home/$USERNAME/.bashrc
RUN source /home/$USERNAME/.bashrc

#RUN pip install "fastapi[all]"
#RUN pip install pydantic

COPY ./socket_client.py /home/$USERNAME/socket_client.py

WORKDIR /home/$USERNAME
RUN pwd
RUN ls

RUN touch launch.sh
RUN echo "python3 socket_client.py" > launch.sh
RUN chmod +x launch.sh