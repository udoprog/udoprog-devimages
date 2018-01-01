FROM ubuntu:artful
MAINTAINER John-John Tedro <udoprog@tedro.se>

ENV LC_ALL=en_US.UTF-8

RUN apt-get update
RUN apt-get install -y apt-utils locales
RUN locale-gen en_US.UTF-8

RUN apt-get install -y curl git make
RUN apt-get install -y nodejs npm
RUN apt-get install -y python3 python3-yaml python3-pystache python3-pip
RUN apt-get install -y python python-pip
RUN apt-get install -y ruby ruby-dev
RUN apt-get install -y zsh

ARG EXCLUDE_TARGETS

RUN git clone https://github.com/udoprog/dotfiles.git $HOME/.dotfiles

WORKDIR /root/.dotfiles
COPY facts.yml facts.yml
COPY secrets.yml secrets.yml

WORKDIR /root

RUN mkdir -p usr/bin
RUN EXCLUDE_TARGETS=${EXCLUDE_TARGETS} DOTFILES_UPDATE=force,noninteractive $HOME/.dotfiles/bin/upd

RUN mkdir -p ~/.local/share/nvim/site/spell
RUN curl http://ftp.vim.org/pub/vim/runtime/spell/en.utf-8.spl -o ~/.local/share/nvim/site/spell/en.utf-8.spl
RUN curl http://ftp.vim.org/pub/vim/runtime/spell/en.utf-8.sug -o ~/.local/share/nvim/site/spell/en.utf-8.sug
RUN rm -f ~/.dotfiles/state/last-sync

ENTRYPOINT /bin/zsh
