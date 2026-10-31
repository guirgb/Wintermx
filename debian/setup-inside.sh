#!/bin/bash
# ============================================================
#  WinTerm OS - configuracao dentro do Debian (proot)
# ============================================================
set -e
export DEBIAN_FRONTEND=noninteractive
WT=/opt/winterm

echo "--> Atualizando Debian"
apt update && apt upgrade -y

echo "--> Pacotes base + desktop leve (XFCE)"
apt install -y sudo nano wget curl git unzip xz-utils ca-certificates gnupg \
    dbus-x11 x11-utils x11-xserver-utils xfce4 xfce4-terminal xfce4-whiskermenu-plugin \
    xfce4-pulseaudio-plugin xfce4-clipman-plugin xfce4-screenshooter \
    thunar thunar-archive-plugin file-roller mousepad ristretto \
    pulseaudio-utils pavucontrol network-manager-gnome \
    fonts-noto fonts-noto-color-emoji fonts-liberation fonts-dejavu \
    gtk2-engines-murrine gnome-themes-extra papirus-icon-theme \
    firefox-esr mesa-utils python3 python3-pip python3-pil \
    xdotool wmctrl tigervnc-standalone-server tigervnc-tools tigervnc-common

echo "--> Configurando sessao VNC"
mkdir -p /root/.vnc
cat > /root/.vnc/xstartup <<'XS'
#!/bin/bash
unset SESSION_MANAGER DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR=/tmp
export PULSE_SERVER=127.0.0.1
export WINEDEBUG=-all
export BOX64_LOG=0
export BOX64_DYNAREC=1
export BOX64_DYNAREC_BIGBLOCK=2
export BOX64_DYNAREC_STRONGMEM=1
exec dbus-launch --exit-with-session startxfce4
XS
chmod +x /root/.vnc/xstartup

echo "--> Arquitetura e suporte x86 (Box64 + Wine)"
bash "$WT/debian/wine-box64.sh"

echo "--> Tema Windows 10"
bash "$WT/debian/theme.sh"

echo "--> Finalizando"
apt autoremove -y && apt clean
echo "Setup do Debian concluido."
