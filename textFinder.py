import cv2
import pytesseract

# Carrega a imagem
img = cv2.imread("screen.png")

# Converte para escala de cinza
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Aplica binarização simples
_, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)

# (Opcional) Recorte uma área da imagem onde aparece o nome do Pokémon
# Exemplo: crop = thresh[y1:y2, x1:x2]
# crop = thresh[100:120, 80:160]
# texto = pytesseract.image_to_string(crop, config='--psm 6')

# Detecta texto na imagem inteira (ou só no crop se quiser)
texto = pytesseract.image_to_string(thresh, config='--psm 6')

print("Texto detectado:")
print(texto)
