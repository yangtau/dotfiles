package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
)

// config:
var (
	divider = "  "
	left    = func(_ space) string { return "" }
	right   = func(_ space) string { return "" }
	color   = func(s space, focusedDisplay int) Color {
		switch {
		case s.Display == focusedDisplay:
			return BrightWhite
		default:
			return BrightBlack
		}
	}
	shape = func(s space, focusedDisplay int) string {
		if s.Focused == 1 {
			return "●" // "⦿" "◆"
		} else {
			return "○" // "◇"
		}
	}
)

type Color = string

// ANSI colors:
const (
	Black         Color = "\033[0;30m"
	Red           Color = "\033[0;31m"
	Green         Color = "\033[0;32m"
	Yellow        Color = "\033[0;33m"
	Blue          Color = "\033[0;34m"
	Magenta       Color = "\033[0;35m"
	Cyan          Color = "\033[0;36m"
	White         Color = "\033[0;37m"
	BrightBlack   Color = "\033[1;30m"
	BrightRed     Color = "\033[1;31m"
	BrightGreen   Color = "\033[1;32m"
	BrightYellow  Color = "\033[1;33m"
	BrightBlue    Color = "\033[1;34m"
	BrightMagenta Color = "\033[1;35m"
	BrightCyan    Color = "\033[1;36m"
	BrightWhite   Color = "\033[1;37m"
	Reset         Color = "\033[m"
)

type space struct {
	Id               int    `json:"id"`
	Label            string `json:"label"`
	Index            int    `json:"index"`
	Display          int    `json:"display"`
	Windows          []int  `json:"windows"`
	Type             string `json:"type"`
	Visible          int    `json:"visible"`
	Focused          int    `json:"focused"`
	NativeFullscreen int    `json:"native-fullscreen"`
	FirstWindow      int    `json:"first-window"`
	LastWindow       int    `json:"last-window"`
}

const (
	YabarFilename = "/tmp/.yabar"
)

func main() {
	os.Setenv("PATH", "/usr/local/bin")
	cmd := exec.Command("yabai",
		"-m", "query",
		"--spaces")
	out, err := cmd.Output()
	if err != nil {
		fmt.Println(Red + err.Error())
		return
	}

	spaces := []space{}
	if err := json.Unmarshal(out, &spaces); err != nil {
		fmt.Println(Red + err.Error())
		return
	}

	focusedDisplay := 0
	for _, s := range spaces {
		if s.Focused == 1 {
			focusedDisplay = s.Display
			break
		}
	}

	spaceStatus := make([]string, len(spaces))
	for i, s := range spaces {
		spaceStatus[i] = color(s, focusedDisplay) + left(s) + shape(s, focusedDisplay) + right(s)
	}

	output := strings.Join(spaceStatus, divider)

	ioutil.WriteFile(YabarFilename, []byte(output), os.FileMode(0660))

	if len(os.Args) >= 2 && os.Args[1] == "debug" {
		fmt.Println(output)
	}
}
