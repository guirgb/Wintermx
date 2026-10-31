#!/bin/bash
# ============================================================
#  Box64 + Wine (x86_64) em Debian arm64
#  Usa o repositorio Ryan Fortner (pacotes box64 prontos)
#  e Wine x86_64 oficial extraido para /opt/wine
# ============================================================
set -e
export DEBIAN_FRONTEND=noninteractive

ARCH="$(dpkg --print-architecture)"
echo "Arquitetura: $ARCH"

if [ "$ARCH" != "arm64" ]; then
    echo "Dispositivo nao e arm64; instalando wine direto do Debian."
    dpkg --add-architecture i386
    apt update
    apt install -y wine wine64 winetricks
    exit 0
fi

# ---------- Box64 ----------
echo "--> Instalando Box64 (repositorio de pacotes prontos)"
KEY_TMP="$(mktemp)"
if ! wget -q https://ryanfortner.github.io/box64-debs/KEY.gpg -O "$KEY_TMP"; then
    rm -f "$KEY_TMP"
    echo "Não foi possível baixar a chave do repositório Box64." >&2
    exit 1
fi
if ! gpg --dearmor --yes -o /usr/share/keyrings/box64-archive-keyring.gpg "$KEY_TMP"; then
    rm -f "$KEY_TMP"
    echo "A chave do repositório Box64 é inválida." >&2
    exit 1
fi
rm -f "$KEY_TMP"
echo "deb [signed-by=/usr/share/keyrings/box64-archive-keyring.gpg] https://ryanfortner.github.io/box64-debs/debian ./" \
    > /etc/apt/sources.list.d/box64.list
apt update
apt install -y box64-generic-arm || apt install -y box64

# ---------- Wine x86_64 ----------
WINE_VER="9.0"
WINE_DIR="/opt/wine"
if [ ! -d "$WINE_DIR" ]; then
    echo "--> Baixando Wine ${WINE_VER} x86_64"
    mkdir -p /tmp/wine-dl && cd /tmp/wine-dl
    # Build WoW64/amd64 do Kron4ek (binarios prontos)
    URL="https://github.com/Kron4ek/Wine-Builds/releases/download/${WINE_VER}/wine-${WINE_VER}-amd64.tar.xz"
    wget -q --show-progress "$URL" -O wine.tar.xz
    tar -xf wine.tar.xz
    mv wine-${WINE_VER}-amd64 "$WINE_DIR"
    cd / && rm -rf /tmp/wine-dl
fi

# ---------- wrappers ----------
cat > /usr/local/bin/wine <<'EOF'
#!/bin/bash
exec box64 /opt/wine/bin/wine "$@"
EOF
cat > /usr/local/bin/wine64 <<'EOF'
#!/bin/bash
exec box64 /opt/wine/bin/wine64 "$@"
EOF
cat > /usr/local/bin/wineserver <<'EOF'
#!/bin/bash
exec box64 /opt/wine/bin/wineserver "$@"
EOF
cat > /usr/local/bin/wineboot <<'EOF'
#!/bin/bash
exec box64 /opt/wine/bin/wine /opt/wine/lib/wine/x86_64-windows/wineboot.exe "$@"
EOF
cat > /usr/local/bin/winecfg <<'EOF'
#!/bin/bash
exec box64 /opt/wine/bin/wine winecfg "$@"
EOF
chmod +x /usr/local/bin/wine /usr/local/bin/wine64 /usr/local/bin/wineserver \
         /usr/local/bin/wineboot /usr/local/bin/winecfg

# ---------- winetricks ----------
wget -q https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    -O /usr/local/bin/winetricks
chmod +x /usr/local/bin/winetricks

# ---------- Prefixo Wine inicial ----------
echo "--> Criando prefixo Wine (pode demorar)"
export WINEPREFIX=/root/.wine WINEARCH=win64 WINEDEBUG=-all DISPLAY=:0
export BOX64_LOG=0
# sem X ativo no momento da instalacao: apenas prepara; wineboot completo roda no 1o boot
echo "Prefixo sera finalizado no primeiro uso (winterm-first-run)."

# ---------- DXVK / VKD3D (para jogos) via Zink/Turnip ----------
cat > /usr/local/bin/winterm-first-run <<'EOF'
#!/bin/bash
# Roda uma vez dentro do desktop: finaliza o prefixo e instala runtimes basicos.
export WINEPREFIX=$HOME/.wine WINEARCH=win64 WINEDEBUG=-all
wineboot -i
winetricks -q corefonts vcrun2019 dxvk 2>/dev/null || true
winecfg
echo "Wine pronto."
EOF
chmod +x /usr/local/bin/winterm-first-run

echo "Box64 + Wine instalados."
