#!/data/data/com.termux/files/usr/bin/bash
# WinTerm OS - launcher via VNC (alternativa ao Termux:X11)
# Uso: winterm-vnc [LARGURAxALTURA]     ex: winterm-vnc 1920x1080
DISTRO="debian"
GEOM="${1:-1280x720}"
DISPLAY_NUM=1
PORT=$((5900 + DISPLAY_NUM))

pkill -f pulseaudio 2>/dev/null || true
sleep 1
pulseaudio --start --exit-idle-time=-1 \
  --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
  --load="module-sles-sink" 2>/dev/null || true

termux-wake-lock 2>/dev/null || true

# define a senha do VNC na primeira vez
ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs/${DISTRO}"
if [ ! -f "$ROOTFS/root/.vnc/passwd" ]; then
    echo "Defina uma senha para o VNC (6 a 8 caracteres):"
    proot-distro login "$DISTRO" --shared-tmp -- vncpasswd
fi

# limpa sessao antiga e inicia o servidor
proot-distro login "$DISTRO" --shared-tmp -- bash -c "
  vncserver -kill :${DISPLAY_NUM} >/dev/null 2>&1
  rm -f /tmp/.X${DISPLAY_NUM}-lock /tmp/.X11-unix/X${DISPLAY_NUM}
  vncserver :${DISPLAY_NUM} -geometry ${GEOM} -depth 24 -localhost yes -xstartup /root/.vnc/xstartup
"

echo
echo "=========================================="
echo " WinTerm OS rodando via VNC"
echo " Abra seu app cliente VNC e conecte em:"
echo "     localhost:${PORT}   (ou 127.0.0.1::${PORT})"
echo " Resolucao: ${GEOM}"
echo " Para parar: winterm-stop"
echo "=========================================="
