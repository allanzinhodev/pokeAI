import cv2
import numpy as np
import pyautogui
import time

def detectar_opcao_menu(templates):
    # Captura a tela e converte para tons de cinza
    screenshot = pyautogui.screenshot()
    screenshot_gray = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2GRAY)

    melhor_opcao = None
    melhor_valor = 0

    for nome, template in templates.items():
        res = cv2.matchTemplate(screenshot_gray, template, cv2.TM_CCOEFF_NORMED)
        _, max_val, _, _ = cv2.minMaxLoc(res)

        if max_val > melhor_valor:
            melhor_valor = max_val
            melhor_opcao = nome

    return melhor_opcao

# Carrega os templates do menu
templates = {
    "fight": cv2.imread("imgs/fight.png", 0),
    "poke": cv2.imread("imgs/poke.png", 0),
    "pack": cv2.imread("imgs/pack.png", 0),
    "run": cv2.imread("imgs/run.png", 0),
}

# Loop contínuo
while True:
    opcao_atual = detectar_opcao_menu(templates)

    if opcao_atual:
        print(f"Opção detectada: {opcao_atual}")
        with open("opcao_menu.txt", "w") as f:
            f.write(opcao_atual)
    else:
        print("Nenhuma opção detectada.")
        with open("opcao_menu.txt", "w") as f:
            f.write("nenhum")

    time.sleep(0.5)  # espera 0.5 segundo antes de verificar de novo
