#!/bin/bash
# ============================================================
#  WinTerm OS - tema visual estilo Windows 10
# ============================================================
set -e
WT=/opt/winterm
mkdir -p /usr/share/themes /usr/share/icons /usr/share/backgrounds/winterm

TMP=/tmp/wt-theme && rm -rf $TMP && mkdir -p $TMP && cd $TMP

echo "--> Baixando tema GTK/xfwm4 Windows 10"
git clone --depth 1 https://github.com/B00merang-Project/Windows-10.git win10-theme || true
if [ -d win10-theme ]; then
    rm -rf /usr/share/themes/Windows-10
    cp -r win10-theme /usr/share/themes/Windows-10
fi

echo "--> Baixando icones Windows 10"
git clone --depth 1 https://github.com/B00merang-Artwork/Windows-10.git win10-icons || true
if [ -d win10-icons ]; then
    rm -rf /usr/share/icons/Windows-10
    cp -r win10-icons /usr/share/icons/Windows-10
    gtk-update-icon-cache -f /usr/share/icons/Windows-10 2>/dev/null || true
fi

echo "--> Cursor"
apt install -y dmz-cursor-theme || true

echo "--> Wallpapers e icone do menu Iniciar"
cp -r $WT/assets/*.png /usr/share/backgrounds/winterm/ 2>/dev/null || true
cp $WT/assets/winterm-start.png /usr/share/icons/winterm-start.png 2>/dev/null || true

cd / && rm -rf $TMP

# ------------------------------------------------------------
#  Configuracao padrao do XFCE (aplica a root e ao /etc/skel)
# ------------------------------------------------------------
for HOME_DIR in /root /etc/skel; do
    CFG="$HOME_DIR/.config/xfce4/xfconf/xfce-perchannel-xml"
    mkdir -p "$CFG" "$HOME_DIR/.config/autostart" "$HOME_DIR/.config/gtk-3.0"

    # --- aparencia GTK / icones / fontes ---
    cat > "$CFG/xsettings.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Windows-10"/>
    <property name="IconThemeName" type="string" value="Windows-10"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Noto Sans 10"/>
    <property name="CursorThemeName" type="string" value="DMZ-White"/>
    <property name="CursorThemeSize" type="int" value="24"/>
  </property>
  <property name="Xft" type="empty">
    <property name="Antialias" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
</channel>
XML

    # --- gerenciador de janelas (bordas, botoes a direita) ---
    cat > "$CFG/xfwm4.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Windows-10"/>
    <property name="title_font" type="string" value="Noto Sans 10"/>
    <property name="button_layout" type="string" value="O|HMC"/>
    <property name="title_alignment" type="string" value="left"/>
    <property name="use_compositing" type="bool" value="false"/>
    <property name="double_click_action" type="string" value="maximize"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="workspace_count" type="int" value="1"/>
  </property>
</channel>
XML

    # --- area de trabalho (wallpaper, sem icones extras) ---
    cat > "$CFG/xfce4-desktop.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitorscreen" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/backgrounds/winterm/wallpaper-hero.png"/>
        </property>
      </property>
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/backgrounds/winterm/wallpaper-hero.png"/>
        </property>
      </property>
    </property>
  </property>
  <property name="desktop-icons" type="empty">
    <property name="style" type="int" value="2"/>
    <property name="icon-size" type="uint" value="48"/>
    <property name="file-icons" type="empty">
      <property name="show-home" type="bool" value="true"/>
      <property name="show-trash" type="bool" value="true"/>
      <property name="show-filesystem" type="bool" value="false"/>
      <property name="show-removable" type="bool" value="false"/>
    </property>
  </property>
</channel>
XML

    # --- painel unico, embaixo, estilo barra de tarefas ---
    cat > "$CFG/xfce4-panel.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=0;y=0"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="length" type="uint" value="100"/>
      <property name="size" type="uint" value="42"/>
      <property name="icon-size" type="uint" value="24"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-rgba" type="array">
        <value type="double" value="0.09"/>
        <value type="double" value="0.09"/>
        <value type="double" value="0.10"/>
        <value type="double" value="0.96"/>
      </property>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="7"/>
        <value type="int" value="8"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whiskermenu"/>
    <property name="plugin-2" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="firefox-esr.desktop"/>
      </property>
    </property>
    <property name="plugin-3" type="string" value="launcher">
      <property name="items" type="array">
        <value type="string" value="thunar.desktop"/>
      </property>
    </property>
    <property name="plugin-4" type="string" value="tasklist">
      <property name="grouping" type="uint" value="1"/>
      <property name="show-labels" type="bool" value="true"/>
      <property name="flat-buttons" type="bool" value="true"/>
    </property>
    <property name="plugin-5" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-6" type="string" value="systray"/>
    <property name="plugin-7" type="string" value="pulseaudio"/>
    <property name="plugin-8" type="string" value="clock">
      <property name="digital-layout" type="uint" value="3"/>
      <property name="digital-time-format" type="string" value="%H:%M%n%d/%m/%Y"/>
    </property>
  </property>
</channel>
XML

    # --- menu Iniciar (Whisker) ---
    mkdir -p "$HOME_DIR/.config/xfce4/panel"
    cat > "$HOME_DIR/.config/xfce4/panel/whiskermenu-1.rc" <<'RC'
button-icon=/usr/share/icons/winterm-start.png
button-single-row=false
show-button-title=false
show-button-icon=true
launcher-show-name=true
launcher-show-description=false
item-icon-size=3
category-icon-size=1
view-as-icons=false
position-categories-alternate=true
position-search-alternate=false
profile-shape=0
menu-width=520
menu-height=620
menu-opacity=98
favorites=firefox-esr.desktop,thunar.desktop,xfce4-terminal.desktop,winterm-first-run.desktop
RC

    # --- aplicar wallpaper no autostart (garante o monitor correto) ---
    cat > "$HOME_DIR/.config/autostart/winterm-wallpaper.desktop" <<'DESK'
[Desktop Entry]
Type=Application
Name=WinTerm Wallpaper
Exec=/opt/winterm/debian/apply-wallpaper.sh
Terminal=false
DESK

    # --- GTK3: fonte e botoes ---
    cat > "$HOME_DIR/.config/gtk-3.0/settings.ini" <<'INI'
[Settings]
gtk-theme-name=Windows-10
gtk-icon-theme-name=Windows-10
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=DMZ-White
gtk-decoration-layout=menu:minimize,maximize,close
INI
done

# ------------------------------------------------------------
#  Script que (re)aplica wallpaper em todos os monitores
# ------------------------------------------------------------
cat > "$WT/debian/apply-wallpaper.sh" <<'EOF'
#!/bin/bash
sleep 2
IMG="${1:-/usr/share/backgrounds/winterm/wallpaper-hero.png}"
for prop in $(xfconf-query -c xfce4-desktop -l | grep last-image); do
    xfconf-query -c xfce4-desktop -p "$prop" -s "$IMG" 2>/dev/null
done
EOF
chmod +x "$WT/debian/apply-wallpaper.sh"

# ------------------------------------------------------------
#  Atalhos de menu: primeiro uso do Wine e apps Windows
# ------------------------------------------------------------
cat > /usr/share/applications/winterm-first-run.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Configurar Wine (1o uso)
Comment=Finaliza o Wine e instala runtimes basicos
Exec=xfce4-terminal -e winterm-first-run
Icon=wine
Categories=System;
EOF

cat > /usr/share/applications/wine-open.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Abrir com Wine
Exec=wine start /unix %f
MimeType=application/x-ms-dos-executable;application/x-msi;application/x-ms-shortcut;
Icon=wine
NoDisplay=true
EOF
update-desktop-database 2>/dev/null || true

# atalho .exe -> Wine
mkdir -p /root/.config
cat >> /root/.config/mimeapps.list <<'EOF'
[Default Applications]
application/x-ms-dos-executable=wine-open.desktop
application/x-msi=wine-open.desktop
EOF

echo "Tema Windows 10 aplicado."
