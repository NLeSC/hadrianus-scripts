#!/usr/bin/env python3

import re
import fileinput

text = ""

for line in fileinput.input():
    text += line

print(re.sub(',\n\);', '\n);', text))