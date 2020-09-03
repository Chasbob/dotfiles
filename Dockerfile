FROM ubuntu:18.04

# Update && install common dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -yq \
        ncurses-dev man telnet unzip zsh git subversion curl make sudo locales \
        autoconf automake python golang-go \
        neovim htop gnupg

# Set the locale
RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Add user
ARG USER=chasbob
RUN adduser --disabled-password --gecos '' $USER        && \
    adduser $USER sudo                                  && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    usermod --shell /bin/zsh $USER
USER $USER
WORKDIR /home/$USER

RUN ["/bin/zsh", "-lc", "git clone https://github.com/zdharma/zinit /home/$USER/.config/zinit/bin"]
COPY --chown=$USER:$USER . /home/$USER/.config/dotfiles/
RUN ["/bin/bash", "-c", "/home/$USER/.config/dotfiles/install.sh"]

ARG TERM
ENV TERM ${TERM}
RUN SHELL=/bin/zsh zsh -i -c -- 'zinit module build; @zinit-scheduler burst || true '
RUN chown -R $USER:$USER /home/$USER
#
ENTRYPOINT ["/bin/zsh", "-i", "-l"]
#
