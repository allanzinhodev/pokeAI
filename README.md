# Pokémon Crystal Automation (Lua Edition)

Os testes e o código em produção que estou desenvolvendo podem ser acompanhados ao vivo no meu canal da Twitch: **[twitch.tv/allaorodrigues](https://twitch.tv/allaorodrigues)**. Passa lá pra trocar uma ideia e ver como tudo tá funcionando na prática!

Este projeto é uma automação para o jogo **Pokémon Crystal**, com foco em exploração e manipulação do jogo em tempo real, utilizando **Lua puro**. A automação simula uma visão computacional do mundo do jogo interpretando diretamente os **offsets de tile** da memória.
O sistema opera diretamente sobre a memória do emulador, identificando o ambiente, NPCs, obstáculos e interações do jogo por meio dos **offsets de tiles** do mapa. Com essa "visão computacional emulável", o bot toma decisões automaticamente para se mover, evitar colisões, conversar com NPCs, entrar em portas, entre outras ações básicas.

Este projeto **não utiliza mais Python**, sendo uma solução 100% em Lua neste estágio da refatoração.

---

## Recursos principais

- Leitura dos tiles do mapa a partir da RAM.
- Interpretação de colisões, portas e NPCs.
- Navegação baseada em lógica de tiles.
- Sistema de decisão contextual com base no mapa atual.
- Detecção da seta de seleção no menu de batalha (Fight, Poke, Pack, Run) via imagem.
- Controle automático do personagem e execução de comandos de batalha.
- Sistema de captura de pokemons
- Sistema de ações de mapas
- Sistemas anti-freeze
- Sistema de troca de pokemon
- Sistema de troca de Skill
- Script de inteligência para enfrentar batalhas selvagens e treinadores automaticamente.

---

## Changelog

### Refatoração Lua Pura
- Removido completamente o código em Python para simplificação e portabilidade.
- Nova arquitetura baseada em módulos Lua para leitura, interpretação e decisão.
- Adicionado suporte para leitura precisa dos **offsets de tile** em tempo real.
- Implementação de um sistema de "visão computacional" via memória do jogo.
- Melhor desempenho ao rodar dentro do emulador com menor sobrecarga.

### Melhorias no Navegador
- Caminho adaptativo com fallback quando bloqueado.
- Reconhecimento de portas, paredes e NPCs com base nos valores de tile.
- Lógica de desvio para contornar obstáculos de forma natural.

## 🧠 Tecnologias usadas
- [Lua](https://www.lua.org/) - para automação no VBA-RR
- [VBA-RR (emulador)](http://vba-rerecording.googlecode.com) - para rodar o jogo com suporte a scripts


- [Python 3](https://www.python.org/) - REMOVIDO
- [OpenCV](https://opencv.org/) - para visão computacional  - REMOVIDO
- [PyAutoGUI](https://pyautogui.readthedocs.io/) - para captura de tela - REMOVIDO

## 🗂 Estrutura

```
pokeAI/
├── main.lua        # Script principal em Lua (executado no VBA-RR)
├── config.lua      # Variáveis e funções importantes para contexto
├── move.lua        # Funções relacionadas a movimentação
├── battle.lua      # Funções de batalha
├── map.lua         # Ações de mapas
└── old_scripts     # Scripts antigos / refatorados
```

## Observações
- Este projeto está em fase experimental, melhorias futuras podem incluir OCR, redes neurais ou controle mais refinado.
- O suporte ao Python poderá voltar futuramente para análises mais complexas ou integração com IA.
- Este projeto é apenas para fins educacionais e experimentais.

---

## Autor

Desenvolvido por Allan Rodrigues • [linkedin.com/in/allanzinho/](https://www.linkedin.com/in/allanzinho/) 
