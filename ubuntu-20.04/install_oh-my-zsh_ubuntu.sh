#!/bin/bash

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step A - Update machine & Install packages"
echo "--------------------------------------------------------------------------------"
echo ""

# Update Ubuntu
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
# Install packages
sudo apt-get install -y build-essential zlib1g-dev autoconf libncurses5-dev libncursesw5-dev gettext libcurl4-openssl-dev

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step B - Update git"
echo "--------------------------------------------------------------------------------"
echo ""

wget https://github.com/git/git/archive/v2.27.0.tar.gz -P /tmp/demo/git
cd /tmp/demo/git
tar -xvzf v2.27.0.tar.gz
cd git-2.27.0
sudo make configure
sudo ./configure --prefix=/usr/local
sudo make && sudo make install

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 1 - Install zsh"
echo "--------------------------------------------------------------------------------"
echo ""

# Install zsh
wget https://github.com/zsh-users/zsh/archive/zsh-5.8.tar.gz -P /tmp/demo/zsh
cd /tmp/demo/zsh
tar -xvzf zsh-5.8.tar.gz
cd zsh-zsh-5.8
sudo ./Util/preconfig
sudo ./configure
sudo make && sudo make install
# https://askubuntu.com/questions/812420/chsh-always-asking-a-password-and-get-pam-authentication-failure
sudo sed s/required/sufficient/g -i /etc/pam.d/chsh
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
echo "$USER" | chsh -s /usr/local/bin/zsh
# https://askubuntu.com/questions/812420/chsh-always-asking-a-password-and-get-pam-authentication-failure
# revert back to original setting
sudo sed s/sufficient/required/g -i /etc/pam.d/chsh

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 2 - Install oh-my-zsh"
echo "--------------------------------------------------------------------------------"
echo ""

sudo echo Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 3 - Change theme to Powerlevel10k"
echo "--------------------------------------------------------------------------------"
echo ""

git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sudo sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 4 - Enable Auto-correction; Install and Enable Auto-suggestion and Syntax Highlighting"
echo "--------------------------------------------------------------------------------"
echo ""

sudo sed -i 's/# ENABLE_CORRECTION="true"/ENABLE_CORRECTION="true"/g' ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo sed -i 's/plugins=(git)/plugins=(git)\nZSH_DISABLE_COMPFIX=true/' ~/.zshrc
sudo sed -i 's/plugins=(git)/plugins=(\n  git\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)/' ~/.zshrc

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 5 - Add dir_colors"
echo "--------------------------------------------------------------------------------"
echo ""

sudo git clone https://github.com/arcticicestudio/nord-dircolors.git /tmp/demo/dircolors
sudo mv /tmp/demo/dircolors/src/dir_colors ~/
cd ~
mv dir_colors .dir_colors

sudo tee -a ~/.zshrc > /dev/null << 'EOF'
test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)
EOF

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step 6 - Cleanup"
echo "--------------------------------------------------------------------------------"
echo ""

sudo rm -r /tmp/demo

echo ""
echo "--------------------------------------------------------------------------------"
echo "Done"
echo "--------------------------------------------------------------------------------"
echo ""