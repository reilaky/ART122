import time
import os, sys
import pipan
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("pan", type=float)
parser.add_argument("tilt", type=float)
args = parser.parse_args()

pan = args.pan
tilt = args.tilt

p = pipan.PiPan()

limit_y_bottom = 90
limit_y_top = 180
limit_x_left = 110
limit_x_right = 170

if pan <= limit_x_right and pan >= limit_x_left:
    p.do_pan(pan)

if tilt <= limit_y_top and tilt >= limit_y_bottom:
    p.do_tilt(tilt)

