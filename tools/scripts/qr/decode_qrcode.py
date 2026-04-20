import sys

import cv2


def decode_qr_with_opencv(image_path):
    # Read the image file
    img = cv2.imread(image_path)

    # Initialize the QRCode detector
    detector = cv2.QRCodeDetector()

    # Detect and decode
    data, bbox, _ = detector.detectAndDecode(img)

    # If there's data, return it
    if data:
        return data
    else:
        return "No QR code found in the image."


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <path_to_png>")
        sys.exit(1)

    # Get the image path from command-line arguments
    image_path = sys.argv[1]

    # Decode the QR code and print the result
    result = decode_qr_with_opencv(image_path)
    print("Decoded QR Code Data:", result)
