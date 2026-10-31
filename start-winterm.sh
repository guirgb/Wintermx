#!/data/data/com.termux/files/usr/bin/bash
# WinTerm OS - launcher
DISTRO="debian"

# limpa sessoes antigas
pkill -f "termux.x11" 2>/dev/null || true
pkill -f pulseaudio 2>/dev/null || true
sleep 1

# audio via PulseAudio (TCP local)
pulseaudio --start --exit-idle-time=-1 \
  --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
  --load="module-sles-sink" 2>/dev/null || true

# servidor grafico Termux:X11
export XDG_RUNTIME_DIR="${TMPDIR}"
termux-x11 :0 >/dev/null 2>&1 &
sleep 3

# abre o app Termux:X11
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1

# evita o Android matar o processo
termux-wake-lock 2>/dev/null || true

# entra no Debian e sobe o desktop
proot-distro login "$DISTRO" --shared-tmp -- bash -c '
  export DISPLAY=:0
  export PULSE_SERVER=127.0.0.1
  export XDG_RUNTIME_DIR=/tmp
  export MESA_NO_ERROR=1
  export MESA_GL_VERSION_OVERRIDE=4.3COMPAT
  export GALLIUM_DRIVER=zink
  export ZINK_DESCRIPTORS=lazy
  export BOX64_LOG=0
  export BOX64_DYNAREC=1
  export BOX64_DYNAREC_BIGBLOCK=2
  export BOX64_DYNAREC_STRONGMEM=1
  export WINEDEBUG=-all
  export WINEPREFIX=$HOME/.wine
  dbus-launch --exit-with-session startxfce4
'
