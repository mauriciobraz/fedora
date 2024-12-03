function devtools
    install-tools & wait "Installing Tools"
    install-docker & wait "Installing Docker"
end

function install-docker
    sudo dnf remove docker \
        docker-common docker-logrotate \
        docker-client docker-client-latest \
        docker-latest docker-latest-logrotate \
        docker-selinux docker-engine-selinux docker-engine -y

    sudo dnf install dnf-plugins-core -y

    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable --now docker; and sudo groupadd docker; and sudo usermod -aG docker $USER
    sudo chown $USER:$USER /home/$USER/.docker -R; and sudo chmod g+rwx $HOME/.docker -R

    sudo systemctl enable containerd.service
    sudo systemctl enable docker.service
end

function install-tools
    set REPO_URL https://gist.github.com/23b57d239e7583fe9adacd6a490aa47b.git
    set REPO_TGT /tmp/23b57d239e7583fe9adacd6a490aa47b.git

    git clone $REPO_URL $REPO_TGT 2>/dev/null

    sudo cp -f $REPO_TGT/automatic.conf /etc/dnf/automatic.conf
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc

    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
    echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" | sudo tee /etc/yum.repos.d/1password.repo >/dev/null

    sudo dnf check-update; and sudo dnf install 1password code dnf-automatic go -y
    sudo systemctl enable --now dnf-automatic.timer
end
