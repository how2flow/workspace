# Dockerfile
FROM ubuntu:latest
LABEL author="how2flow (Steve Jeong)"
LABEL version="3.0.0"

ARG DEBIAN_FRONTEND=noninteractive

# shell: bash
SHELL ["/bin/bash", "-c"]

ENV ID="user" \
  TZ="Asia/Seoul" \
  WGET_FLAG="--no-check-certificate"

# set timezone.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER root
WORKDIR /root
COPY fixups fixups
RUN chmod -R +x fixups
RUN ./fixups/preinst
RUN ./fixups/ssh
RUN ./fixups/id
RUN ./fixups/sudo

USER ${ID}
WORKDIR /home/${ID}
RUN mkdir -p .vim/colors .vim/bundle
RUN wget -O .gitconfig $WGET_FLAG "https://raw.githubusercontent.com/how2flow/config/master/ubuntu/gitconfig"
RUN wget -O .tmux.conf $WGET_FLAG  "https://raw.githubusercontent.com/how2flow/config/master/ubuntu/tmux.conf"
RUN wget -O .vimrc $WGET_FLAG "https://raw.githubusercontent.com/how2flow/config/master/ubuntu/vimrc"
RUN wget -O .vim/colors/gruvbox.vim $WGET_FLAG "https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim"
RUN git clone "https://github.com/VundleVim/Vundle.vim.git" .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN echo "alias tmux='tmux -2'" >> .bashrc
RUN echo "set -o vi" >> .bashrc
