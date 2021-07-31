PLUGINS = ~/Library/Application\ Support/xbar/plugins/
NAME = yabar.1d.cgo

yabar: yabar.go
	go build yabar.go

install: yabar
	mv yabar $(PLUGINS)$(NAME)

clean:
	rm -f yabar
