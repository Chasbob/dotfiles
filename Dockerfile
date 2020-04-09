FROM ubuntu:18.04
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y -qq \
    git \
    zsh \
    neovim \
    sudo \
    locales \
    ssh \
    tmux \
    autojump \
    direnv

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
