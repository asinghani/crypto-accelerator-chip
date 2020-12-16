from vcdvcd import VCDVCD
import numpy as np
import cv2

vcd1 = VCDVCD("dino_vga.vcd")
data = vcd1["dino_vga_tb.dump[40:0]"].tv
data = [x[1].zfill(41)[::-1] for x in data]
data = [x for x in data if x[40] == "1"]

data = [x for x in data if "z" not in x[30:33] and "x" not in x[30:33]]

# Parse to [(hs, vs, r, g, b), ...]
data = [(x[31], x[30], x[32], x[32], x[32]) for x in data]
data = [list(map(int, x)) for x in data]
data_parsed = data

print(len(data_parsed))

img = []
line = None
ready = False
for hs, vs, r, g, b in data_parsed:
    if not hs:
        if line is not None and len(line) > 0:
            img.append(line)

        ready = True
        line = []

    if not vs:
        print("DONE")
        break

    if hs and ready and line is not None:
        line.append((b, g, r))

img = np.array(img, dtype=np.uint8) * 255
print("Image shape: {}".format(img.shape))
cv2.imwrite("frame.png", img)
