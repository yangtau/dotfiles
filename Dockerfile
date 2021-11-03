FROM archlinux:latest

RUN sed -i '1s/^/Server = https:\/\/mirrors.tuna.tsinghua.edu.cn\/archlinux\/\$repo\/os\/\$arch\n/' /etc/pacman.d/mirrorlist

RUN	pacman -Syy

RUN	pacman -S --noconfirm openssh sudo zsh git wget jq go nodejs yarn gcc nix tmux neovim which

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
    useradd -m -G wheel tau && \
    echo 'tau:hello' | chpasswd

# Install config
RUN su - tau && cd /home/tau && \
    git clone https://github.com/yangtau/dotfiles .config

# Run openssh daemon
CMD	["/usr/sbin/sshd", "-D"]
