#!/usr/bin/env python3

# https://gist.github.com/lwrubel/0f7dc13940bf5a8072edfa94c1396739

import argparse
from datetime import datetime, timedelta

import webvtt

parser = argparse.ArgumentParser(
    description="Shift caption start and end times in a .vtt file"
)
parser.add_argument("inputfile", help="input filename, must be VTT format")
parser.add_argument("outputfile", help="output filename")
parser.add_argument(
    "seconds",
    type=float,
    help="number of seconds toshift caption times. Can be negative.",
)

args = parser.parse_args()


def adjust_time(timestamp, seconds):
    t = datetime.strptime(timestamp, "%H:%M:%S.%f")
    d = timedelta(seconds=seconds)
    new_timestamp = t + d

    if new_timestamp < datetime.strptime("00:00:00.000", "%H:%M:%S.%f"):
        return "00:00:00.000"

    return new_timestamp.strftime("%H:%M:%S.%f")


vtt = webvtt.read(args.inputfile)

for caption in vtt:
    caption.start = adjust_time(caption.start, args.seconds)
    caption.end = adjust_time(caption.end, args.seconds)

vtt.save(args.outputfile)
