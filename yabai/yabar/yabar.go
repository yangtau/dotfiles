package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
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
		if s.Focused {
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
	Display int  `json:"display"`
	Focused bool `json:"has-focus"`
	Visible bool `json:"is-visible"`
	// Id               int    `json:"id"`
	// Label            string `json:"label"`
	// Index            int    `json:"index"`
	// Windows          []int  `json:"windows"`
	// Type             string `json:"type"`
	// NativeFullscreen int    `json:"is-native-fullscreen"`
	// FirstWindow      int    `json:"first-window"`
	// LastWindow       int    `json:"last-window"`
}

func main() {
	var now time.Time
	if DEBUG {
		now = time.Now()
	}

	// true of false
	// darkMode = os.Getenv("XBARDarkMode") == "true"

	os.Setenv("PATH", "/usr/local/bin")
	cmd := exec.Command("yabai",
		"-m", "query",
		"--spaces")
	out, err := cmd.Output()
	if err != nil {
		fmt.Println(Red + err.Error())
		return
	}

	spaces := make([]space, 0, 10)
	if err := json.Unmarshal(out, &spaces); err != nil {
		fmt.Println(Red + err.Error())
		return
	}

	focusedDisplay := 0
	for _, s := range spaces {
		if s.Focused && s.Visible {
			focusedDisplay = s.Display
			break
		}
	}

	spaceStatus := make([]string, len(spaces))
	for i, s := range spaces {
		spaceStatus[i] = color(s, focusedDisplay) + left(s) + shape(s, focusedDisplay) + right(s)
	}

	output := strings.Join(spaceStatus, divider)

	os.Stdout.WriteString(output)

	if DEBUG {
		fmt.Println(Reset)
		fmt.Println("elapsed:", time.Now().Sub(now))
	}
}
