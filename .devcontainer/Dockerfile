FROM python:3.11-slim-bullseye

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY ./python-debian.sh  /tmp/library-scripts/

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell "/bin/bash" \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo git \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN bash /tmp/library-scripts/python-debian.sh "${USERNAME}"

USER $USERNAME

# Everything following will be owned by $USERNAME
COPY ./bashrc  /home/${USERNAME}/.bashrc

