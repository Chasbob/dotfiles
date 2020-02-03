FROM ubuntu:18.04

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/chasbob/dotfiles.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y -qq \
    git \
    zsh \
    vim \
    sudo \
    locales \
    ssh \
    tmux

RUN adduser --shell /bin/zsh --gecos 'charlie' --disabled-password charlie
RUN locale-gen "en_GB.UTF-8"

RUN echo "Defaults:charlie !requiretty\ncharlie ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/charlie

USER charlie
ENV LANG=en_GB.UTF-8
WORKDIR /home/charlie
ENV TERM=xterm-256color
ENV temp=temp
RUN git clone https://github.com/Chasbob/dotfiles
COPY install.sh ./dotfiles/
RUN ./dotfiles/install.sh -y
CMD ["/bin/zsh", "-l"]