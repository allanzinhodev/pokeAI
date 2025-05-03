import cv2
import numpy as np
import pyautogui
import time

def capturar_tela():
    screenshot = pyautogui.screenshot()
    return cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2GRAY)

def template_ativo(screenshot_gray, template, threshold=0.8):
    res = cv2.matchTemplate(screenshot_gray, template, cv2.TM_CCOEFF_NORMED)
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
template_attack_menu = cv2.imread("imgs/attack_menu.png", 0)

templates_opcoes = {
    "fight": cv2.imread("imgs/fight.png", 0),
    "poke": cv2.imread("imgs/poke.png", 0),
    "pack": cv2.imread("imgs/pack.png", 0),
    "run":  cv2.imread("imgs/run.png", 0),
}

templates_skills = {
    "skill1": cv2.imread("imgs/skill1.png", 0),
    "skill2": cv2.imread("imgs/skill2.png", 0),
    "skill3": cv2.imread("imgs/skill3.png", 0),
    "skill4": cv2.imread("imgs/skill4.png", 0),
}

def detectar_skill_selecionada(screenshot_gray, templates):
    melhor_skill = None
    melhor_valor = 0

    for nome, template in templates.items():
        res = cv2.matchTemplate(screenshot_gray, template, cv2.TM_CCOEFF_NORMED)
        _, max_val, _, _ = cv2.minMaxLoc(res)

        if max_val > melhor_valor:
            melhor_valor = max_val
            melhor_skill = nome

    return melhor_skill if melhor_valor > 0.8 else None

# Loop contínuo
while True:
    screenshot_gray = capturar_tela()

    if template_ativo(screenshot_gray, template_attack_menu):
        opcao = detectar_skill_selecionada(screenshot_gray, templates_skills)
        if opcao:
            print(f"[Ataque] Seta está em: {opcao}")
        else:
            opcao = "ataque_menu"
            print("[Ataque] Menu de ataque ativo, mas nenhuma skill detectada")
    elif template_ativo(screenshot_gray, template_menu):
        opcao = detectar_opcao_menu(screenshot_gray, templates_opcoes)
        if opcao:
            print(f"[Menu Ativo] Opção detectada: {opcao}")
        else:
            opcao = "nenhum"
            print("[Menu Ativo] Nenhuma opção detectada.")
    else:
        opcao = "A"
        print("[Tela neutra] Pressionando A")

    with open("opcao_menu.txt", "w") as f:
        f.write(opcao)

    time.sleep(0.5)
