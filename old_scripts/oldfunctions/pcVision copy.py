import cv2
import numpy as np
import mss
import time

def detectar_seta(threshold=0.8):
    template = cv2.imread("menu_arrow.png", cv2.IMREAD_GRAYSCALE)
    w, h = template.shape[::-1]

    with mss.mss() as sct:
        monitor = sct.monitors[1]  # Captura a tela principal (pode ajustar depois)
        img = np.array(sct.grab(monitor))
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        res = cv2.matchTemplate(gray, template, cv2.TM_CCOEFF_NORMED)
        loc = np.where(res >= threshold)

        for pt in zip(*loc[::-1]):
            cv2.rectangle(img, pt, (pt[0] + w, pt[1] + h), (0,255,0), 2)
            print(f"[✔️] Seta detectada na posição: {pt}")
            break  # Detecta só a primeira ocorrência
        else:
            print("[ ] Nenhuma seta detectada.")


while True:
    detectar_seta()
    time.sleep(2.5)  # A cada 0.5 segundo
