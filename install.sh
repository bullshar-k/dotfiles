curl -sS https://starship.rs/install.sh | sh
sudo pacman -S kitty fastfetch 

cp starship.toml ~/.config
cp kitty.conf ~/.config/kitty
cp current-theme.conf ~/.config/kitty
cp -r Moga-Neon-Magenta /usr/share/icons
cp .bashrc ~/
