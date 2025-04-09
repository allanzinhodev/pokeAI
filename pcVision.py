import cv2
import numpy as np
import pyautogui
import time

def capturar_tela():
    screenshot = pyautogui.screenshot()
    return cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2GRAY)

def menu_batalha_ativo(screenshot_gray, template_menu, threshold=0.8):
    res = cv2.matchTemplate(screenshot_gray, template_menu, cv2.TM_CCOEFF_NORMED)
    _, max_val, _, _ = cv2.minMaxLoc(res)
    return max_val >= threshold

def detectar_opcao_menu(screenshot_gray, templates):
    melhor_opcao = None
    melhor_valor = 0

    for nome, template in templates.items():
        res = cv2.matchTemplate(screenshot_gray, template, cv2.TM_CCOEFF_NORMED)
        _, max_val, _, _ = cv2.minMaxLoc(res)

        if max_val > melhor_valor:
            melhor_valor = max_val
            melhor_opcao = nome

    return melhor_opcao

# Carrega os templates
template_menu = cv2.imread("imgs/menu.png", 0)
templates_opcoes = {
    "fight": cv2.imread("imgs/fight.png", 0),
    "poke": cv2.imread("imgs/poke.png", 0),
    "pack": cv2.imread("imgs/pack.png", 0),
    "run":  cv2.imread("imgs/run.png", 0),
}

# Loop contínuo
while True:
    screenshot_gray = capturar_tela()

    if menu_batalha_ativo(screenshot_gray, template_menu):
        opcao = detectar_opcao_menu(screenshot_gray, templates_opcoes)
        if opcao:
            print(f"[Menu Ativo] Opção detectada: {opcao}")
        else:
            opcao = "nenhum"
            print("[Menu Ativo] Nenhuma opção detectada.")
    else:
        opcao = "A"
        print("[Menu Inativo] Pressionando A")

    with open("opcao_menu.txt", "w") as f:
        f.write(opcao)

    time.sleep(0.5)
