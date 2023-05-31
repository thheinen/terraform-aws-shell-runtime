FROM ubuntu:22.04

ARG AWSUME_VERSION=4.5.3
ARG DIRENV_VERSION=2.30.3

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# System base with common tooling
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install --no-install-recommends --yes \
     lsb-release vim sudo curl wget apt-utils dialog apt-transport-https ca-certificates unzip software-properties-common \
     yamllint python3-pip git less jq ssh \
  && apt-get autoremove --yes \
  && apt-get clean --yes \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir "awsume==${AWSUME_VERSION}" \
  && awsume-configure \
  && curl --location-trusted "https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-$(dpkg --print-architecture)" --output /usr/local/bin/direnv --silent \
  && chmod +x /usr/local/bin/direnv

# User configuration
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && echo 'alias awsume="source awsume"' >> /home/$USERNAME/.bashrc \
  && echo 'eval "$(direnv hook bash)"' >> /home/$USERNAME/.bashrc \
  && echo 'complete -C /usr/local/bin/aws_completer aws' >> /home/$USERNAME/.bashrc \
  && echo 'complete -C /usr/bin/terraform terraform' >> /home/$USERNAME/.bashrc \
  && echo 'disable_checkpoint = true' > /home/$USERNAME/.terraformrc
