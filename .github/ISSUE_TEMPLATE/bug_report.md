---
name: Relatar um problema
description: Informe um erro reproduzível no WinTerm OS
title: "[Bug]: "
labels: [bug]
body:
  - type: markdown
    attributes:
      value: "Obrigado por ajudar. Não publique senhas, tokens, dados pessoais ou logs completos com informações privadas."
  - type: input
    id: device
    attributes:
      label: Aparelho e versão do Android
      placeholder: "Modelo; Android xx"
    validations:
      required: true
  - type: input
    id: termux
    attributes:
      label: Fonte e versão do Termux
    validations:
      required: true
  - type: input
    id: arch
    attributes:
      label: Arquitetura (`uname -m`)
      placeholder: aarch64
    validations:
      required: true
  - type: textarea
    id: steps
    attributes:
      label: Como reproduzir
      description: Liste os passos e o resultado esperado/obtido.
    validations:
      required: true
  - type: textarea
    id: logs
    attributes:
      label: Trecho relevante do erro
      description: Remova informações pessoais, caminhos privados, tokens e senhas.
    validations:
      required: false
