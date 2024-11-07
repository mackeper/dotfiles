import sys

import qrcode
from PIL import Image, ImageDraw, ImageFont


def generate_wifi_qr(ssid, password, security_type="WPA"):
    # Define Wi-Fi format string for QR code
    wifi_string = f"WIFI:T:{security_type};S:{ssid};P:{password};;"

    # Create QR code instance
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )

    # Add Wi-Fi data to the QR code
    qr.add_data(wifi_string)
    qr.make(fit=True)

    # Generate the QR code image
    qr_img = qr.make_image(fill_color="black", back_color="white")

    # Load a font (You might need to specify the path to a .ttf font file)
    # Try loading a TrueType font with a specific size, fall back if not available
    try:
        # You need to download the font file from https://www.nerdfonts.com/font-downloads
        font = ImageFont.truetype("CaskaydiaCoveNerdFontMono-Regular.ttf", 32)
    except IOError:
        print("TrueType font not found. Using default font.")
        font = ImageFont.load_default()

    # Calculate image size for SSID label
    text_width, text_height = font.getsize(ssid)
    qr_width, qr_height = qr_img.size
    new_img_height = qr_height + text_height + 10  # Add padding below QR code

    # Create a new image with space for the text
    combined_img = Image.new("RGB", (qr_width, new_img_height), "white")
    combined_img.paste(qr_img, (0, 0))

    # Draw SSID text below the QR code
    draw = ImageDraw.Draw(combined_img)
    text_x = (qr_width - text_width) // 2
    text_y = qr_height + 5  # Position text just below the QR code
    draw.text((text_x, text_y), ssid, font=font, fill="black")

    # Save the final image
    output_file = f"{ssid}_wifi_qr.png"
    combined_img.save(output_file)
    print(f"QR code saved as {output_file}")


if __name__ == "__main__":
    # Ensure correct number of arguments
    if len(sys.argv) != 3:
        print("Usage: python script.py <SSID> <PASSWORD>")
        sys.exit(1)

    # Capture arguments
    ssid = sys.argv[1]
    password = sys.argv[2]

    # Generate QR code
    generate_wifi_qr(ssid, password)
