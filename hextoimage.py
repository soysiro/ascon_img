import numpy as np
import cv2

# Image dimensions
width, height = 825, 1100

# Read hex data from file
with open('output_hex.txt', 'r') as f:
    hex_lines = f.readlines()

# Convert hex lines to byte array
byte_data = bytearray()
for line in hex_lines:
    line = line.strip()  # remove newline
    bytes_line = bytes.fromhex(line)
    byte_data.extend(bytes_line)

# Convert byte array to numpy array and reshape for RGB
image_array = np.frombuffer(byte_data, dtype=np.uint8)
image_array = image_array.reshape((height, width, 3))  # (rows, cols, channels)

# Save image
cv2.imwrite('reconstructed_image.png', image_array)

# Show image (optional)
cv2.imshow('Reconstructed Image', image_array)
cv2.waitKey(0)
cv2.destroyAllWindows()
