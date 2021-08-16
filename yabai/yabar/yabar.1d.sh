#!/bin/zsh

# <xbar.title>yabar</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Tau</xbar.author>
# <xbar.author.github>yangtau</xbar.author.github>
# <xbar.desc>Plugin that displays total number of spaces and highlights the current space.</xbar.desc>
# <xbar.dependencies>brew,yabai,skhd,jq,zsh</xbar.dependencies>

# Info about yabai, see: https://github.com/koekeishiya/yabai
# For skhd, see: https://github.com/koekeishiya/skhd

# Sets unicode encoding to UTF-8. Fixes issues with displaying *many* but not *all* unicode charecters.
export LANG="es_ES.UTF-8"

# Exports the plugin to your $PATH to allow execution. Make sure you run `chmod +x yabai.1d.sh` after downloading
export PATH=/usr/local/bin:$PATH

YABAR="/tmp/.yabar"

cat $YABAR
