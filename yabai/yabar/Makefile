PLUGINS = ~/Library/Application\ Support/xbar/plugins/
NAME = yabar.1d.sh

all: yabar install

yabar: yabar.go
	go build yabar.go

install: yabar.1d.sh
	cp $< $(PLUGINS)$(NAME)
