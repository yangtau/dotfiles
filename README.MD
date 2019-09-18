# Dotfiles

This repository consists of configuration for some tools that I use within my Manjaro. 

![](https://github.com/yangtau/dotfiles/blob/master/screenshot.jpg?raw=true)

# Key Components
 - [i3-gaps](https://github.com/Airblader/i3)
 - [i3-lock-color](https://github.com/PandorasFox/i3lock-color)
 - [rofi](https://github.com/davatorium/rofi)
 - [polybar](https://github.com/polybar/polybar)
 - [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
 - [compton](https://github.com/tryone144/compton.git)
 - [nvim](https://neovim.io/)

# i3

## [TocuhPad](https://github.com/yangtau/dotfiles/blob/master/30-touchpad.conf)

This configuration enables natural scrolling and tapping for touchpad, and it requires libinput. 

Usage: `ln ./30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf`

See the ArchWiki about [libinput](https://wiki.archlinux.org/index.php/Libinput) for more details.

# polybar

I modify the configuration in [polybar-theme](https://github.com/adi1090x/polybar-themes) to get my own config, and I add two different bars to adapt multiple monitors.

# compton

The comtpon that I use is a fork of the original version, and it can have an effect of frosted glass. The config file is a copy of [compton.conf](https://github.com/theniceboy/.config/blob/master/compton.conf).
