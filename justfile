CMD := 'python3 -m dots'
INSTALL := CMD + ' install'

MODULES := `find modules -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`

interactive:
	@echo "{{MODULES}}" | fzf -m | xargs -ro just install

install +modules=MODULES:
	{{INSTALL}} {{modules}}
