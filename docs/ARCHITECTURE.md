# Arquitetura

WinTerm OS roda como um ambiente de usuário sobre o Android; não substitui o Android e não requer root no aparelho.

```text
Android
└── Termux
    ├── proot-distro
    │   └── Debian (rootfs de usuário)
    │       ├── XFCE + aplicativos Linux
    │       └── Box64 + Wine (experimental em ARM64)
    ├── Termux:X11 ───────────┐
    └── PulseAudio ───────────┴── sessão gráfica / áudio
```

## Fluxo de instalação

1. `install.sh` verifica que está no Termux e que o dispositivo usa ARM64.
2. Instala dependências no Termux e provisiona Debian com `proot-distro` caso ainda não exista.
3. Copia os scripts e recursos para `/opt/winterm` no rootfs Debian.
4. `debian/setup-inside.sh` instala o XFCE e demais pacotes, configura o VNC, o Wine/Box64 e a aparência.
5. O instalador cria os comandos `winterm`, `winterm-vnc` e `winterm-stop` no `PATH` do Termux.

## Sessões gráficas

- `start-winterm.sh`: inicia Termux:X11, áudio e XFCE.
- `start-winterm-vnc.sh`: inicia o servidor VNC local na porta 5901.
- `stop-winterm.sh`: encerra processos e libera o wakelock quando disponível.

A disponibilidade de aceleração gráfica, áudio e aplicativos depende do dispositivo Android, dos drivers e dos aplicativos companheiros instalados.
