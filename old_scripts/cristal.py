import cv2
import numpy as np
import pyautogui
import time
import os

class GameScreenAnalyzer:
    def __init__(self, pasta_imgs="imgs", threshold=0.8, arquivo_saida="opcao_menu.txt"):
        self.pasta_imgs = pasta_imgs
        self.threshold = threshold
        self.arquivo_saida = arquivo_saida
        self.templates_menu = self._carregar_templates(["menu", "attack_menu"])
        self.templates_opcoes = self._carregar_templates(["fight", "poke", "pack", "run"])
        self.templates_skills = self._carregar_templates(["skill1", "skill2", "skill3", "skill4"])

    def _carregar_templates(self, nomes):
        templates = {}
        for nome in nomes:
            caminho = os.path.join(self.pasta_imgs, f"{nome}.png")
            imagem = cv2.imread(caminho, 0)
            if imagem is not None:
                templates[nome] = imagem
            else:
                print(f"⚠️  Imagem não encontrada: {caminho}")
        return templates

    def _capturar_tela_em_cinza(self):
        screenshot = pyautogui.screenshot()
        return cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2GRAY)

    def _template_ativo(self, screenshot, template):
        resultado = cv2.matchTemplate(screenshot, template, cv2.TM_CCOEFF_NORMED)
        _, max_val, _, _ = cv2.minMaxLoc(resultado)
        return max_val >= self.threshold

    def _detectar_melhor_match(self, screenshot, templates):
        melhor_nome = None
        melhor_valor = 0

        for nome, template in templates.items():
            resultado = cv2.matchTemplate(screenshot, template, cv2.TM_CCOEFF_NORMED)
            _, max_val, _, _ = cv2.minMaxLoc(resultado)
            if max_val > melhor_valor:
                melhor_valor = max_val
                melhor_nome = nome

        return melhor_nome if melhor_valor >= self.threshold else None

    def analisar_tela(self):
        screenshot_gray = self._capturar_tela_em_cinza()

        if self._template_ativo(screenshot_gray, self.templates_menu["attack_menu"]):
            opcao = self._detectar_melhor_match(screenshot_gray, self.templates_skills)
            if opcao:
                print(f"[Ataque] Seta está em: {opcao}")
            else:
                opcao = "ataque_menu"
                print("[Ataque] Menu de ataque ativo, mas nenhuma skill detectada")

        elif self._template_ativo(screenshot_gray, self.templates_menu["menu"]):
            opcao = self._detectar_melhor_match(screenshot_gray, self.templates_opcoes)
            if opcao:
                print(f"[Menu Ativo] Opção detectada: {opcao}")
            else:
                opcao = "nenhum"
                print("[Menu Ativo] Nenhuma opção detectada.")
        else:
            opcao = "A"
            print("[Tela neutra] Pressionando A")

        self._salvar_opcao(opcao)

    def _salvar_opcao(self, opcao):
        with open(self.arquivo_saida, "w") as f:
            f.write(opcao)

    def iniciar_loop(self, delay=0.5):
        print("🎮 Iniciando análise de tela Pokémon Crystal...\nPressione Ctrl+C para parar.\n")
        try:
            while True:
                self.analisar_tela()
                time.sleep(delay)
        except KeyboardInterrupt:
            print("\n🛑 Loop interrompido pelo usuário.")

# === EXECUÇÃO ===

if __name__ == "__main__":
    analisador = GameScreenAnalyzer()
    analisador.iniciar_loop()
