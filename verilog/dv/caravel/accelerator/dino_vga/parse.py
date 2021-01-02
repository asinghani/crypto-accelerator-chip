# SPDX-FileCopyrightText: 2020 Anish Singhani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
from vcdvcd import VCDVCD
import numpy as np
import cv2
import sys

vcd1 = VCDVCD(sys.argv[1])
print(vcd1.signals)

# dino_vga_tb.dump[40:0]
data = vcd1[sys.argv[2]].tv
data = [x[1].zfill(41)[::-1] for x in data]
data = [x for x in data if x[40] == "1"]

data = [x for x in data if "z" not in x[30:33] and "x" not in x[30:33]]

# Parse to [(hs, vs, r, g, b), ...]
data = [(x[31], x[30], x[32], x[32], x[32]) for x in data]

def int4(x):
    if x == "0":
        return 0.0
    elif x == "1":
        return 1.0
    elif x.lower() == "x":
        return 0.3
    elif x.lower() == "z":
        return 0.6
    else:
        assert False

data = [list(map(int4, x)) for x in data]
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

print(len(img), [len(x) for x in img])
img = [a[:705] for a in img]

img = (np.array(img, dtype=np.float32) * 255).astype(np.uint8)
print("Image shape: {}".format(img.shape))
cv2.imwrite("frame.png", img)

