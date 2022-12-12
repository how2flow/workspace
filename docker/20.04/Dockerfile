# Dockerfile
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# shell: bash
SHELL ["/bin/bash", "-c"]

ENV ID="steve" \
  TZ="Asia/Seoul" \
  CSCOPE="https://raw.githubusercontent.com/jkhgit/config/ubuntu/mkcscope.sh" \
  GITCONFIG="https://raw.githubusercontent.com/jkhgit/config/ubuntu/.gitconfig" \
  TMUXCONFIG="https://raw.githubusercontent.com/jkhgit/config/ubuntu/.tmux.conf" \
  VIMCOLORS="https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim" \
  VIMCONFIG="https://raw.githubusercontent.com/jkhgit/config/ubuntu/.vimrc"

# set timezone.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root
COPY packages packages
COPY user user
RUN chmod +x packages user
RUN ./packages && rm packages
RUN ./user $ID && rm user
RUN wget -O /usr/bin/mkcscope.sh --no-check-certificate $CSCOPE

USER $ID
WORKDIR /home/$ID
RUN mkdir -p .vim/colors && \
  mkdir -p .vim/bundle
RUN wget --no-check-certificate $GITCONFIG && \
  wget --no-check-certificate $TMUXCONFIG && \
  wget -O .vim/colors/gruvbox.vim --no-check-certificate $VIMCOLORS && \
  wget --no-check-certificate $VIMCONFIG
RUN git clone "https://github.com/VundleVim/Vundle.vim.git" \
  .vim/bundle/Vundle.vim
RUN vim +PluginInstall +qall
RUN echo "alias tmux='tmux -2'" >> .bashrc
RUN echo "set -o vi" >> .bashrc
