#! /bin/bash

# refer k-vim install.sh

if ! [ -x "$(hash git)"]; then
    echo >&2 "git in no installed."
    exit 1;
fi

#系统统依赖 # ctags, cscope, ag(the_silver_searcher)
# ubuntu
sudo apt install ctags
sudo apt install cscope #ctags增强版
sudo apt install build-essential cmake python-dev python3-dev  #编译YCM自动补全插件依赖
sudo apt install silversearcher-ag

#使用Python
#sudo pip install pyflakes
#sudo pip install pylint
#sudo pip install pep8

BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
}

echo "step1: backing up current vim conifg"
today=`date +%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc; do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today; done
for i in $HOME/.vim $HOME/.vimrc; do [ -L $i ] && unlink $i; done

echo "step2: setting up symlinks"
lnif $CURRENT_DIR/_vimrc $HOME/.vimrc
lnif $CURRENT_DIR/_vim $HOME/.vim
lnif $CURRENT_DIR/myPlugin/Kwbd.vim $HOME/.vim/plugin/Kwbd.vim
echo "step3: update/install plugins using vundle"

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

vim -u $HOME/.vim/vimrc.bundles +PluginInstall! +PluginClean! +qall

echo "setp4: complie YouCompleteMe"
echo "It will take a long time, just be patient"
echo "If error, you need to compile it yourself"
echo "cd $HOME/.vim/bundle/YouCompleteMe/ && python install install.py --clang-completer --racer-completer"

cd $HOME/.vim/bundle/YouCompleteMe/
git submodule update --init --recursive
if [ -x "$(command -v clang)" ] # check system clang
then
    python install.py --clang-completer --system-libclan --racer-completer
else
    python install.py --clang-completer --racer-completer
fi
echo "Now will copy defalut ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py to your home path"
read -p "Copy Now?[Y/n]: " select 
if [ "$select" != "n" ] && [ "$select" != "N" ];then
    lnif ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py ~/.ycm_extra_conf.py
fi

echo "Install Done!"

