import re

from xkeysnail.transform import K, define_keymap

terminals = ["Io.elementary.terminal"]
browsers = [
    "microsoft-edge",
    "microsoft-edge-beta",
    "microsoft-edge-dev",
    "Microsoft-edge-beta", ]

define_keymap(None, {
    K("CAPSLOCK"):    K("ESC"),
    K("M-Left"):      K("Home"),
    K("M-Right"):     K("End"),
    K("Super-Left"):  K("C-Left"),
    K("Super-Right"): K("C-Right"),
}, "normal cases")

terminals = [term.casefold() for term in terminals]
termStr = "|".join(str('^'+x+'$') for x in terminals)
browsers = [browser.casefold() for browser in browsers]
browserStr = "|".join(str('^'+x+'$') for x in browsers)

define_keymap(lambda wm_class: wm_class.casefold() not in terminals, {
    K("M-Shift-Left"):      K("Shift-Home"),
    K("M-Shift-Right"):     K("Shift-End"),
    K("Super-Shift-Left"):  K("C-Shift-Left"),
    K("Super-Shift-Right"): K("C-Shift-Right"),
    K("M-C"):               K("C-C"),
    K("M-V"):               K("C-V"),
    K("M-Z"):               K("C-Z"),
    K("M-A"):               K("C-A"),
    K("M-X"):               K("C-X"),
}, "except terminals")

# Keybindings for terminal
define_keymap(re.compile(termStr, re.IGNORECASE), {
    K("M-Tab"):   K("C-Tab"),
    K("M-C"):     K("C-Shift-C"),
    K("M-V"):     K("C-Shift-V"),
    K("M-MINUS"): K("C-MINUS"),
    K("M-EQUAL"): K("C-EQUAL"),
    K("M-W"):     K("C-Shift-W"),
    K("M-F"):     K("C-Shift-F"),
    K("M-T"):     K("C-Shift-T"),
}, "terminals")


# Keybindings for General Web Browsers
define_keymap(re.compile(browserStr, re.IGNORECASE), {
    K("M-W"):     K("C-W"),
    K("M-F"):     K("C-F"),
    K("M-Tab"):   K("C-Tab"),
    K("M-MINUS"): K("C-MINUS"),
    K("M-EQUAL"): K("C-EQUAL"),
    K("M-Shift-T"):     K("C-Shift-T"),
}, "General Web Browsers")

# Keybindings for lark
define_keymap(re.compile("Bytedance-feishu", re.IGNORECASE), {
    K("M-KEY_1"): K("C-KEY_1"),
    K("M-KEY_2"): K("C-KEY_2"),
    K("M-KEY_3"): K("C-KEY_3"),
    K("M-KEY_4"): K("C-KEY_4"),
    K("M-KEY_5"): K("C-KEY_5"),
    K("M-KEY_6"): K("C-KEY_6"),
    K("M-KEY_7"): K("C-KEY_7"),
})
