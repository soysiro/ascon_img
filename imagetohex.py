import cv2
import numpy as np

# Đọc ảnh dưới dạng nhị phân
image = cv2.imread('Tran-Tuan-Viet.jpeg', cv2.IMREAD_UNCHANGED)
# chuyển ảnh thành grayscale
image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
# Chuyển ảnh thành mảng 1 chiều dạng byte
image_bytes = image.tobytes()

# Mở file để ghi
with open('output_hex.txt', 'w') as f:
    for i in range(0, len(image_bytes), 16):
        # Lấy 16 byte 1 lần
        line_bytes = image_bytes[i:i+16]
        # Chuyển từng byte thành 2 ký tự hex, rồi nối lại
        hex_line = ''.join(f'{b:02X}' for b in line_bytes)
        # Ghi dòng đó vào file
        f.write(hex_line + '\n')

print("✅ Done! Hex data written to output_hex.txt")
