""" Merge all PDFs in a directory with bookmarks. """

import argparse
import os
import re

import PyPDF2


def natural_sort_key(filename):
    # Split filename into text and numeric parts for natural sorting
    return [
        int(text) if text.isdigit() else text.lower()
        for text in re.split(r"(\d+)", filename)
    ]


def merge_pdfs_with_bookmarks(input_dir, output_path, add_bookmarks):
    pdf_writer = PyPDF2.PdfWriter()

    pdf_files = sorted(
        [f for f in os.listdir(input_dir) if f.endswith(".pdf")], key=natural_sort_key
    )

    if not pdf_files:
        print("No PDF files found in the specified directory.")
        return

    current_page = 0
    for pdf_file in pdf_files:
        pdf_path = os.path.join(input_dir, pdf_file)
        pdf_reader = PyPDF2.PdfReader(pdf_path)

        # Add each page and track current page number
        for page in range(len(pdf_reader.pages)):
            pdf_writer.add_page(pdf_reader.pages[page])

        # Add a bookmark with the filename (without extension) at the start page of this PDF
        if add_bookmarks:
            pdf_writer.add_outline_item(pdf_file[:-4], current_page)

        current_page += len(pdf_reader.pages)  # Update current page count

    with open(output_path, "wb") as output_pdf:
        pdf_writer.write(output_pdf)

    print(f"PDFs merged successfully into '{output_path}'", end=" ")
    if add_bookmarks:
        print("with bookmarks.")
    else:
        print("without bookmarks.")


def main():
    parser = argparse.ArgumentParser(
        description="Merge all PDFs in a directory with bookmarks."
    )
    parser.add_argument(
        "-d",
        "--directory",
        required=True,
        help="Directory containing PDF files to merge.",
    )
    parser.add_argument(
        "-o",
        "--output",
        required=False,
        default="merged_output.pdf",
        help="Output path for the merged PDF file.",
    )

    parser.add_argument(
        "--add-bookmarks",
        action="store_false",
        help="Do not add bookmarks to the merged PDF for each file (default is to add bookmarks).",
    )

    args = parser.parse_args()

    merge_pdfs_with_bookmarks(args.directory, args.output, args.add_bookmarks)


if __name__ == "__main__":
    main()
