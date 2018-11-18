#!/bin/bash
COUNTER=0
INSTALATION_DIR="installPowerLevel9k"

function check_step {
if [ $? -eq 0 ]; then
    let COUNTER=COUNTER+1
fi
}

# switch to downloads directory
cd $HOME/Descargas
if [ ! -d installPowerLevel9k ]; then
    mkdir installPowerLevel9k
fi
cd installPowerLevel9k

#update system
sudo apt update
sudo apt dist-upgrade -y
check_step # 1

#install git
sudo apt install git git-core -y
check_step # 2

#install ls color
if [ ! -f $HOME/.dircolors ]; then
    wget https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors
    check_step # 3
else
    let COUNTER=COUNTER+1 # 3
fi

echo 'eval $(dircolors -b $HOME/.dircolors)' >> $HOME/.bashrc
check_step # 4

#install fonts
#install powerline fonts
sudo apt install fonts-powerline -y
check_step # 5

if [ ! -d ~/.config/fontconfig/conf.d/ ]; then
    mkdir -p ~/.config/fontconfig/conf.d/
    check_step # 6
else
    let COUNTER=COUNTER+1 # 6
fi

if [ ! -f ~/.local/share/fonts/PowerlineSymbols.otf ] || [ ! -f ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ]; then
    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf
    check_step # 7
    mv PowerlineSymbols.otf ~/.local/share/fonts/
    mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
    check_step # 8
else
    let COUNTER=COUNTER+2 # 8
fi

#install awesome terminal fonts
if [ ! -d awesome-terminal-fonts ]; then
    git clone https://github.com/gabrielelana/awesome-terminal-fonts.git $HOME/Descargas/$INSTALATION_DIR/awesome-terminal-fonts
fi
cd $HOME/Descargas/$INSTALATION_DIR/awesome-terminal-fonts
bash install.sh
check_step # 9

# install nerd fonts
if [ ! -d nerd-fonts ]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git $HOME/Descargas/$INSTALATION_DIR/nerd-fonts
fi
cd $HOME/Descargas/$INSTALATION_DIR/nerd-fonts
bash install.sh
check_step # 10

#install vte
sudo apt install libvte-common -y
check_step # 11
if [ ! -f /etc/profile.d/vte.sh ]; then 
    sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
    check_step # 12
else
    let COUNTER=COUNTER+1 # 12
fi

#update font cache
fc-cache -vf ~/.local/share/fonts/
check_step # 13

#install gawk (zplug dependency)
sudo apt install gawk -y
check_step # 14

#install zsh
sudo apt-get install zsh -y
check_step # 15
if [ ! -d  $HOME/.oh-my-zsh ]; then 
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    check_step # 16
else
    let COUNTER=COUNTER+1 # 16
fi

#change shell
chsh -s `which zsh`
check_step # 17

# install dotfiles
cp $HOME/.zshrc $HOME/.zshrcBAK
if [ ! -d  dotfiles ]; then 
    git clone https://github.com/Nikola43/dotfiles.git $HOME/Descargas/$INSTALATION_DIR/dotfiles
    check_step # 18
else
    let COUNTER=COUNTER+1 # 18
fi

cd $HOME/Descargas/$INSTALATION_DIR/dotfiles
mv oh-my-zsh.zshrc $HOME/.zshrc
check_step # 19

if [ $COUNTER -eq 19 ]; then
    rm -rf $HOME/Descargas/$INSTALATION_DIR
    echo -e "\e[1;32mInstalación completada correctamente\e[0m" 
else
    echo -e "\e[1;31mError $COUNTER\e[0m"
fi













