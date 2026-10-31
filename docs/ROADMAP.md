# Roteiro

Este roteiro acompanha as prioridades atuais; não é uma promessa de data ou compatibilidade.

## Estabilidade e testes

- [ ] Validar instalação completa em Termux limpo em pelo menos um aparelho ARM64.
- [ ] Confirmar os nomes atuais dos pacotes Termux/Debian e a disponibilidade dos downloads externos.
- [ ] Testar VNC, Termux:X11, áudio, atalhos e reinstalação sem perda de configuração.
- [ ] Documentar logs úteis e procedimentos de recuperação/backup.
- [ ] Fixar versões e verificar hashes dos artefatos externos.

## Experiência de desktop

- [ ] Corrigir casos em que XFCE conserva uma configuração de painel antiga.
- [ ] Testar seleção de wallpaper e nome do monitor no Termux:X11.
- [ ] Melhorar onboarding, acessibilidade e alternância de tema.

## Integração e desempenho

- [ ] Avaliar compartilhamento de arquivos com armazenamento Android.
- [ ] Testar perfis de desempenho de Box64 em dispositivos ARM64 representativos.
- [ ] Documentar limites de gráficos, áudio, consumo de bateria e suspensão do Android.

## Distribuição

- [ ] Criar um fluxo de atualização e backup/restauração documentado.
- [ ] Avaliar uma imagem rootfs pré-configurada somente quando houver mecanismo confiável de integridade e atualização.
