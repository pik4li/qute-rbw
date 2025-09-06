# qute-rbw

A simple qutebrowser userscript that integrates [rbw](https://github.com/doy/rbw) (Bitwarden CLI) with [fzf](https://github.com/junegun/fzf) for password selection in forms.

## Features

- Fuzzy search through your Bitwarden vault using fzf
- Seamless integration with qutebrowser's insert mode
- Caches recently used entries for quick access
- Supports TOTP codes if available

## Prerequisites

- [qutebrowser](https://qutebrowser.org/)
- [rbw](https://github.com/doy/rbw) (Bitwarden CLI)
- [fzf](https://github.com/junegun/fzf)
- [kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator)
- make (just for the installation, you could call the script with bash if you
want to. Make just `makes` it easier :D)

Make sure rbw is installed, and configured

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/pik4li/qute-rbw.git
   cd qute-rbw
   ```

2. Install the userscript:
   ```bash
   make
   ```

   This will:
   - Check for required dependencies
   - Copy the scripts to `~/.local/share/qutebrowser/userscripts/`
   - Make them executable

   If you want to skip dependency checks:
   ```bash
   make skip
   ```

   > [!CAUTION]
   > Keep in mind, when skipping dependencies, the script might not work as
   > intended. Only do this, if you know what you are doing!

## Usage

1. Configure a hotkey in your qutebrowser config (`~/.config/qutebrowser/config.py` or similar):
   ```python
   config.bind('<Ctrl-b>', 'spawn --userscript qute-rbw', mode='insert')
   ```

2. In qutebrowser, navigate to a login form and enter insert mode.

3. Press your configured hotkey (e.g., Ctrl+b) to launch the password picker.

4. Use fzf to search and select your password entry.

5. The selected password will be automatically inserted into the form.

## Configuration

The script uses the following defaults:
- Terminal: kitty
- Cache directory: `~/.cache/rbwzf`
- Userscripts directory: `~/.local/share/qutebrowser/userscripts`

## Troubleshooting

- Ensure rbw is properly configured
- Check that all dependencies are installed
- Verify the userscripts are in the correct directory and executable

## License
[MIT License](LICENSE)
