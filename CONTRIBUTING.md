# Contribuindo

Obrigado por ajudar a melhorar o WinTerm OS. O projeto é experimental e ainda precisa de testes em dispositivos reais.

## Antes de abrir uma issue

- Confira se já existe uma issue sobre o mesmo problema.
- Informe o modelo do aparelho, versão do Android, fonte/versão do Termux e resultado de `uname -m`.
- Inclua apenas o trecho relevante do log e descreva os passos para reproduzir.
- Remova tokens, senhas, caminhos pessoais e outros dados privados.

## Antes de enviar uma alteração

1. Abra uma issue curta para discutir mudanças grandes, especialmente as que alterem o instalador ou adicionem dependências externas.
2. Mantenha scripts compatíveis com Bash do Termux e Debian.
3. Verifique a sintaxe de todos os scripts alterados com `bash -n caminho/do/script.sh`.
4. Documente dependências, permissões necessárias e qualquer download de terceiros.
5. Não inclua binários, APKs, credenciais ou conteúdo sem autorização/licença clara.
6. Envie uma branch e um pull request com resumo, testes realizados e limitações conhecidas.

## Testes locais

A checagem estática básica pode ser feita no checkout do repositório:

```bash
find . -name '*.sh' -print0 | xargs -0 -n1 bash -n
```

Essa checagem valida sintaxe, não confirma que os pacotes, URLs, serviços gráficos ou aplicativos funcionam em um aparelho.
