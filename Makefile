


cmd = python -m dots
install = $(cmd) install

all:
		$(install) all

modules/git:
	$(install) git

modules/kitty:
	$(install) kitty

modules/spacevim:
	$(install) spacevim

modules/tmux:
	$(install) tmux

modules/zsh:
	$(install) zsh
