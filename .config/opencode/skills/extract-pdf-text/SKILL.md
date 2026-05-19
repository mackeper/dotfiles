---
name: extract-pdf-text
description: "Extract text from a PDF file without external dependencies. Use when: reading a PDF, extracting text from a PDF, summarizing PDF content."
---

# Extract PDF Text

Use `C:\Users\marost\AppData\Roaming\Code\User\tools\Extract-PdfText.ps1 <path>` to extract text content from a PDF file.

The script uses only built-in .NET classes (DeflateStream) to decompress PDF content streams and parse text operators (Tj, TJ, Td). No external dependencies required.

## Usage

```powershell
.\Extract-PdfText.ps1 "C:\path\to\file.pdf"
```

Output is plain text grouped by page with `--- Page N ---` markers.

## Limitations

- Font-encoded text may have missing characters if the PDF uses non-standard encodings
- Image-only PDFs will produce no output
- Only deflate-compressed and uncompressed streams are supported (not LZW/ASCII85)

## Safety constraints

- This skill is **read-only**. It only reads the specified PDF file.
- If the script fails or produces no output, inform the user that the PDF may use unsupported encoding and suggest opening it directly.
