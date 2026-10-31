---
name: Sugestão de melhoria
description: Proponha uma melhoria de uso, documentação ou compatibilidade
title: "[Ideia]: "
labels: [enhancement]
body:
  - type: textarea
    id: problem
    attributes:
      label: Que problema a melhoria resolveria?
    validations:
      required: true
  - type: textarea
    id: proposal
    attributes:
      label: Qual solução você sugere?
    validations:
      required: true
  - type: textarea
    id: alternatives
    attributes:
      label: Alternativas consideradas
    validations:
      required: false
