# Dockerfile
FROM ubuntu:22.04
LABEL author="Steve Jeong"
LABEL e-mail="how2soft@gmail.com"
LABEL github="how2flow"
LABEL version="2.0.0"

ARG DEBIAN_FRONTEND=noninteractive

# shell: bash
SHELL ["/bin/bash", "-c"]

# vars
ENV ID="user" \
  TZ="Asia/Seoul" \
  CSCOPE="https://raw.githubusercontent.com/how2flow/config/master/ubuntu/mkcscope.sh" \
  GITCONFIG="https://raw.githubusercontent.com/how2flow/config/master/ubuntu/gitconfig" \
  TMUXCONFIG="https://raw.githubusercontent.com/how2flow/config/master/ubuntu/tmux.conf" \
  VIMCONFIG="https://raw.githubusercontent.com/how2flow/config/master/ubuntu/vimrc" \
  VIMCOLORS="https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim" \
  USER="add-user" \
  PACKAGES="install-packages"

# set timezone.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# root user fixups
USER root
WORKDIR /root
COPY ${PACKAGES} ${PACKAGES}
COPY ${USER} ${USER}
RUN chmod +x ${PACKAGES} ${USER}
RUN ./${PACKAGES} && rm ${PACKAGES}
RUN ./${USER} && rm ${USER}
RUN wget -O /usr/bin/mkcscope.sh --no-check-certificate ${CSCOPE}

# allow rsa-key type Authentication.
RUN echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
RUN echo "PubkeyAcceptedKeyTypes +ssh-rsa" >> /etc/ssh/ssh_config

# normal user fixups
USER ${ID}
WORKDIR /home/${ID}
RUN mkdir -p .vim/colors && \
  mkdir -p .vim/bundle
RUN wget -O .gitconfig --no-check-certificate ${GITCONFIG} && \
  wget -O .tmux.conf --no-check-certificate ${TMUXCONFIG} && \
  wget -O .vimrc --no-check-certificate ${VIMCONFIG} && \
  wget -O .vim/colors/gruvbox.vim --no-check-certificate ${VIMCOLORS}
RUN git clone "https://github.com/VundleVim/Vundle.vim.git" \
  .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN echo "alias tmux='tmux -2'" >> .bashrc
RUN echo "set -o vi" >> .bashrc
