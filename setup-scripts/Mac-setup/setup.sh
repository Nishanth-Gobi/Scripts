#!/bin/bash

install_homebrew() {
	if ! command -v brew &> /dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "Set your path variable and re-run the script"
		exit 1
	else
		echo "Homebrew is already installed"
	fi
}

install_gui_apps() {
	GUI_APPS_FILE="gui-apps"
	if [[ -f "$GUI_APPS_FILE" ]]; then
		echo "Installing GUI apps"
		xargs brew install --cask < "$GUI_APPS_FILE"
	else
		echo "File containing GUI app list not found: $GUI_APPS_FILE"
	fi
}

install_terminal_apps() {
	TERMINAL_APPS_FILE="terminal-apps"
	if [[ -f "$TERMINAL_APPS_FILE" ]]; then
		echo "Installing terminal apps"
		xargs brew install < "$TERMINAL_APPS_FILE"
	else
		echo "File containing terminal app list not found: $TERMINAL_APPS_FILE"
	fi
}

install_fonts() {
    echo "Please click on the following link to download and install required fonts:"
    echo "https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k"
    read -p "Press 'y' once you've installed the fonts: " -n 1 -r
    echo    # move to a new line after user input
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Continuing with the script..."
    else
        echo "Fonts not installed. Some ligatures might not be shown..."
    fi
}

setup_zsh() {
	echo "Installing Oh-my-zsh..."
	sh -c "$(curl -fsSL https://install.ohmyz.sh)"

	install_fonts

	echo "Installing Powerlevel10k..."
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

	echo "Switching to Powerlevel10k theme..."
	sed -i -e 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/' ~/.zshrc
	
	echo "Restart the shell and type 'p10k configure'"
}


echo "Starting script..."

install_homebrew
install_terminal_apps
install_gui_apps
setup_zsh

echo "Setup complete."
