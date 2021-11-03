FROM archlinux:latest

# According to https://serverfault.com/questions/1052963/pacman-doesnt-work-in-docker-image
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

RUN sed -i '1s/^/Server = https:\/\/mirrors.tuna.tsinghua.edu.cn\/archlinux\/\$repo\/os\/\$arch\n/' /etc/pacman.d/mirrorlist
RUN	pacman -Syy
RUN	pacman -S --noconfirm openssh sudo zsh git curl wget jq nodejs yarn nix tmux neovim which

# Generate host keys
RUN /usr/bin/ssh-keygen -A

# Add password to root user
RUN	echo 'root:hello' | chpasswd

# Fix sshd
RUN sed -i "s/#*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config

# Expose tcp port
EXPOSE 22

# Create new user
RUN sed -i "s/^#.*%wheel ALL=(ALL) ALL.*/%wheel ALL=(ALL) ALL/g"  /etc/sudoers && \
    useradd -m -G wheel -s /usr/bin/zsh tau && \
    echo 'tau:hello' | chpasswd

# Install config
USER tau
RUN cd /home/tau && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    echo "export EDITOR=nvim" >> .zshrc && \
    echo "alias vim=nvim"     >> .zshrc && \
    echo "alias rm='rm -i'"   >> .zshrc && \
    echo "alias mv='mv -i'"   >> .zshrc && \
    echo "alias cp='cp -i'"   >> .zshrc && \
    sed -i 's/^plugins=.*/plugins=(git vi-mode tmux)/g' .zshrc
RUN cd /home/tau && \
    git clone https://github.com/yangtau/dotfiles .config && \
    sh -c 'curl -fLo .local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' && \
    nvim --headless +PlugInstall +qall # && \
    # nvim --headless -c 'CocInstall -sync coc-fzf-preview coc-pairs coc-yank coc-git coc-json coc-smartf coc-tabnine' +qall && \
RUN cd /home/tau && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

USER root

# Run openssh daemon
CMD	["/usr/sbin/sshd", "-D"]
