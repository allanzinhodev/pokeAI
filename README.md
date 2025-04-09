# pokeAI - Pokémon Crystal Bot

**pokeAI** é um projeto de automação para o jogo Pokémon Crystal, utilizando **visão computacional com Python** e **automação de controles com Lua** no emulador **VBA-RR**. O objetivo do bot é detectar o estado atual da batalha e responder automaticamente com comandos apropriados.

## 🎮 Funcionalidades

- Detecção da seta de seleção no menu de batalha (Fight, Poke, Pack, Run) via imagem.
- Controle automático do personagem e execução de comandos de batalha.
- Sistema de comunicação entre Python e Lua via arquivo de texto.
- Script de inteligência para enfrentar batalhas selvagens automaticamente.

## 🧠 Tecnologias usadas

- [Python 3](https://www.python.org/)
- [OpenCV](https://opencv.org/) - para visão computacional
- [PyAutoGUI](https://pyautogui.readthedocs.io/) - para captura de tela
- [Lua](https://www.lua.org/) - para automação no VBA-RR
- [VBA-RR (emulador)](http://vba-rerecording.googlecode.com) - para rodar o jogo com suporte a scripts

## 🗂 Estrutura

```
pokeAI/
├── main.lua               # Script principal em Lua (executado no VBA-RR)
├── funcoes.lua            # Funções auxiliares para o controle
├── pcVision.py       # Script Python que detecta o menu com visão computacional
├── opcao_menu.txt         # Arquivo de comunicação entre Lua e Python
└── imgs/
    ├── fight.png
    ├── poke.png
    ├── pack.png
    ├── run.png
    └── menu.png           # Imagens de referência para o detector
```

## 🚀 Como usar

### Pré-requisitos

- Python 3 instalado
- OpenCV e PyAutoGUI instalados:
  ```bash
  pip install opencv-python pyautogui
  ```
- VBA-RR configurado com suporte a scripts Lua
- Imagens de referência capturadas do seu próprio jogo (garanta que a resolução e paleta estejam iguais!)

### Execução

1. Inicie o script Python:
   ```bash
   python menu_detector.py
   ```
2. No VBA-RR, carregue o `main.lua` como script.
3. Inicie o jogo Pokémon Crystal.
4. O bot detectará automaticamente o menu e tomará decisões durante batalhas selvagens.

## 📌 Notas

- O sistema usa captura de tela e comparação por template, então mantenha o emululador visível e estático.
- Este projeto está em fase experimental, melhorias futuras podem incluir OCR, redes neurais ou controle mais refinado.

## 📄 Licença

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para mais detalhes.