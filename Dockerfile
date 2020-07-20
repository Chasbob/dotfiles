FROM alpine

ENV TERM=xterm-256color
ENV COLORTERM=truecolor

RUN \
      apk add --no-cache \
        git \
        zsh \
        neovim \
        bash \
        ncurses \
        gnupg

ARG USER=chasbob
RUN \
      addgroup -S $USER && \
      adduser $USER --shell /bin/zsh --home /home/$USER --system

USER $USER
WORKDIR /home/$USER
COPY --chown=$USER:$USER . .config/dotfiles/

ARG INSTALL_PLUGINS=true
RUN ["/bin/bash", "-c", ".config/dotfiles/install.sh"]
ENTRYPOINT ["/bin/zsh", "-i"]
