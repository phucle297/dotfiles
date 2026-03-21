sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update -y --fix-missing
sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo apt install -y build-essential
sudo apt install -y vim zip
sudo apt install -y libyaml-cpp-dev libyaml-dev python3-dev
sudo apt install -y fzf
sudo apt install -y gcc g++
sudo apt install -y make cmake
sudo snap install code --classic

# Install Fish shell
sudo apt install -y fish
type fish || exit 1
mkdir -p ~/.config/fish/conf.d

# Change default shell to Fish shell
sudo chsh $USER -s $(which fish)
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install lambda

# Install ghq
mkdir ~/.tmp
cd ~/.tmp
wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz
/usr/local/go/bin/go get github.com/x-motemen/ghq
rm ~/.config/fish/conf.d/ghq.fish
wget -P ~/.config/fish/conf.d "https://gist.githubusercontent.com/sosuke-k/2cabcd4e8c63bfafc4ee7df0950794b6/raw/b5e297ad0d3b80d37652e6ac9e03e63e8a2aebe3/ghq.fish"
cat <<'EOF' >~/.gitconfig
[ghq]
    vcs = git
    root = /home/permees/Projects
EOF

# Install fnm
curl -fsSL https://fnm.vercel.app/install | bash

# Install dotfiles
yes | ghq get git@github.com:phucle297/dotfiles.git
