# Dockerfile
FROM ubuntu:20.04
LABEL author="Steve Jeong"
LABEL e-mail="how2soft@gmail.com"
LABEL github="how2flow"
LABEL version="1.0.0"

ARG DEBIAN_FRONTEND=noninteractive

# shell: bash
SHELL ["/bin/bash", "-c"]

ENV USER="user" \
  TZ="Asia/Seoul" \
  CSCOPE="https://raw.githubusercontent.com/how2flow/config/ubuntu/mkcscope.sh" \
  GITCONFIG="https://raw.githubusercontent.com/how2flow/config/ubuntu/gitconfig" \
  TMUXCONFIG="https://raw.githubusercontent.com/how2flow/config/ubuntu/tmux.conf" \
  VIMCONFIG="https://raw.githubusercontent.com/how2flow/config/ubuntu/vimrc" \
  VIMCOLORS="https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim"

# set timezone.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# root user fixups
USER root
WORKDIR /root
COPY packages packages
COPY user user
RUN chmod +x packages user
RUN ./packages && rm packages
RUN ./user $USER && rm user
RUN wget -O /usr/bin/mkcscope.sh --no-check-certificate $CSCOPE

# normal user fixups
USER $USER
WORKDIR /home/$USER
RUN mkdir -p .vim/colors && \
  mkdir -p .vim/bundle
RUN wget -O .gitconfig --no-check-certificate $GITCONFIG && \
  wget -O .tmux.conf --no-check-certificate $TMUXCONFIG && \
  wget -O .vimrc --no-check-certificate $VIMCONFIG && \
  wget -O .vim/colors/gruvbox.vim --no-check-certificate $VIMCOLORS
RUN git clone "https://github.com/VundleVim/Vundle.vim.git" \
  .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN echo "alias tmux='tmux -2'" >> .bashrc
RUN echo "set -o vi" >> .bashrc
