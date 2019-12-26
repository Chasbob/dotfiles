FROM ubuntu:18.04
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y -qq \
    git \
    zsh \
    vim \
    sudo \
    locales

RUN adduser --shell /bin/zsh --gecos 'charlie' --disabled-password charlie
RUN locale-gen "en_GB.UTF-8"

RUN echo "Defaults:charlie !requiretty\ncharlie ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/charlie

USER charlie
WORKDIR /home/charlie
ENV LANG=en_GB.UTF-8
ENV TERM=xterm-256color
RUN git clone --recursive https://github.com/Chasbob/dotfiles
RUN ./dotfiles/install.sh
CMD ["/bin/zsh", "-l"]