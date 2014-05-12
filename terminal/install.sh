# Use a modified version of the Pro theme by default in Terminal.app
open "${HOME}/.dotfiles/terminal/OiNutter.terminal"
sleep 1 # Wait a bit to make sure the theme is loaded
defaults write com.apple.terminal "Default Window Settings" -string "OiNutter"
defaults write com.apple.terminal "Startup Window Settings" -string "OiNutter"
