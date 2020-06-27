#!/bin/bash

echo ""
echo "--------------------------------------------------------------------------------"
echo "Step A - Update machine & Install packages"
echo "--------------------------------------------------------------------------------"
echo ""

# Update RHEL/CentOS
sudo yum check-update
sudo yum groupinstall -y "Development Tools"
sudo yum clean all
sudo yum update -y
sudo yum clean all
# Install packages
sudo yum install -y gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel ncurses-devel

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
echo "Step C - Update autoconf"
echo "--------------------------------------------------------------------------------"
echo ""

wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz -P /tmp/demo/autoconf
cd /tmp/demo/autoconf
sudo tar -xvzf autoconf-*
cd autoconf-2.69
sudo ./configure
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
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
echo "$USER" | chsh -s /usr/local/bin/zsh

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