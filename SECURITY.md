# Segurança

WinTerm OS é um projeto experimental. O instalador executa comandos de instalação no Termux e, por meio de `proot-distro`, configura pacotes como root **dentro do Debian isolado**. Ele não deve ser executado como root no Android.

## Downloads de terceiros

A instalação usa repositórios do Termux e Debian, além de downloads de projetos externos para componentes como tema, Box64, Wine e Winetricks. Disponibilidade, conteúdo e segurança desses artefatos dependem dos respectivos mantenedores. Antes de executar o instalador, leia os scripts, especialmente `install.sh`, `debian/setup-inside.sh`, `debian/theme.sh` e `debian/wine-box64.sh`.

Atualmente, os artefatos externos não são todos fixados por hash criptográfico verificado pelo projeto. Portanto, não considere o instalador adequado a ambientes com requisitos fortes de integridade ou segurança. Essa é uma limitação conhecida a corrigir.

## Rede e VNC

O script VNC usa o modo local (`-localhost yes`); conecte-se pelo próprio aparelho em `127.0.0.1:5901`. Defina uma senha forte quando solicitada. Não remova a restrição de localhost nem exponha a porta à rede sem compreender os riscos.

O PulseAudio é configurado para conexões locais. Não altere permissões de rede para `0.0.0.0` sem uma necessidade compreendida.

## Reportar vulnerabilidades

Não publique detalhes de uma vulnerabilidade explorável em uma issue pública. Use os recursos privados de reporte de segurança do GitHub para este repositório, se disponíveis. Inclua passos de reprodução mínimos e não envie dados pessoais ou credenciais.
