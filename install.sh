#!/data/data/com.termux/files/usr/bin/bash
# WinTerm OS — instalador executado dentro do Termux.
set -Eeuo pipefail

DISTRO="debian"
WT_HOME="${HOME}/winterm-os"

fail() {
    printf '\n[WinTerm] ERRO: %s\n' "$*" >&2
    exit 1
}

trap 'status=$?; printf "\n[WinTerm] A instalação falhou na linha %s (código %s). Consulte a mensagem acima.\n" "$LINENO" "$status" >&2' ERR

printf '\n========================================\n'
printf '        WinTerm OS — instalação\n'
printf '========================================\n\n'

[[ -n "${PREFIX:-}" && -d "$PREFIX" ]] || fail "Este script deve ser executado dentro do Termux."
[[ "$(uname -m)" == "aarch64" ]] || fail "Arquitetura não suportada: $(uname -m). O alvo deste instalador é ARM64 (aarch64)."
[[ "$(id -u)" -ne 0 ]] || fail "Não execute o instalador como root. Abra o Termux normal."

SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
for required in debian/setup-inside.sh debian/wine-box64.sh debian/theme.sh start-winterm.sh start-winterm-vnc.sh stop-winterm.sh; do
    [[ -f "$SRC/$required" ]] || fail "Arquivo necessário não encontrado: $required"
done
[[ -d "$SRC/assets" ]] || fail "Pasta de recursos não encontrada: assets/"

printf '[1/6] Atualizando os pacotes do Termux...\n'
pkg update -y
pkg upgrade -y

printf '\n[2/6] Instalando dependências do Termux...\n'
pkg install -y x11-repo
pkg install -y proot-distro termux-x11-nightly pulseaudio wget curl git openssl-tool

printf '\n[3/6] Instalando ou verificando Debian...\n'
ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs/$DISTRO"
if [[ ! -f "$ROOTFS/etc/os-release" ]]; then
    proot-distro install "$DISTRO"
else
    printf 'Debian já encontrado; mantendo a instalação existente.\n'
fi
[[ -f "$ROOTFS/etc/os-release" ]] || fail "O rootfs do Debian não foi criado em: $ROOTFS"

printf '\n[4/6] Preparando arquivos do WinTerm...\n'
mkdir -p "$WT_HOME"
if [[ "$SRC" != "$WT_HOME" ]]; then
    cp -a "$SRC/." "$WT_HOME/"
fi
chmod +x "$WT_HOME"/*.sh "$WT_HOME"/debian/*.sh

printf '\n[5/6] Sincronizando arquivos com o Debian...\n'
mkdir -p "$ROOTFS/opt/winterm/debian" "$ROOTFS/opt/winterm/assets"
cp -a "$WT_HOME/debian/." "$ROOTFS/opt/winterm/debian/"
cp -a "$WT_HOME/assets/." "$ROOTFS/opt/winterm/assets/"

printf '\n[6/6] Configurando o Debian (pode levar de 15 a 30 minutos)...\n'
proot-distro login "$DISTRO" --shared-tmp -- bash /opt/winterm/debian/setup-inside.sh

printf '\nConfigurando atalhos do Termux...\n'
mkdir -p "$PREFIX/bin"
ln -sfn "$WT_HOME/start-winterm.sh" "$PREFIX/bin/winterm"
ln -sfn "$WT_HOME/start-winterm-vnc.sh" "$PREFIX/bin/winterm-vnc"
ln -sfn "$WT_HOME/stop-winterm.sh" "$PREFIX/bin/winterm-stop"

printf '\n========================================\n'
printf ' WinTerm OS instalado!\n'
printf ' VNC: winterm-vnc  (conecte a 127.0.0.1:5901)\n'
printf ' X11: winterm      (requer o APK Termux:X11)\n'
printf ' Parar: winterm-stop\n'
printf '========================================\n'
printf '\nO Termux:X11 APK precisa ser instalado separadamente no Android.\n'
