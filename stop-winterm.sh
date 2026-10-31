#!/data/data/com.termux/files/usr/bin/bash
# WinTerm OS - encerra a sessao (X11 e VNC)
proot-distro login debian --shared-tmp -- vncserver -kill :1 >/dev/null 2>&1 || true
pkill -f startxfce4 2>/dev/null || true
pkill -f xfce 2>/dev/null || true
pkill -f Xvnc 2>/dev/null || true
pkill -f "termux.x11" 2>/dev/null || true
pkill -f pulseaudio 2>/dev/null || true
termux-wake-unlock 2>/dev/null || true
echo "WinTerm OS encerrado."
