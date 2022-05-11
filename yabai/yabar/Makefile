PLUGINS = ~/Library/Application\ Support/xbar/plugins/
NAME = yabar.1d.cgo

FLAGS = -ldflags "-s -w" -tags release

all: yabar

yabar: yabar.go
	go build $(FLAGS) .
	cp $@ $(PLUGINS)$(NAME)

clean:
	rm -f $(PLUGINS)$(NAME)
	rm -f yabar
