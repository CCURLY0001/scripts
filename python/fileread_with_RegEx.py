import sys
import os
import re

filepath = input('Input Filepath: ')

pattern = re.compile("(?<=\>).+?(?=\<)")

if not os.path.isfile(filepath):
    print("File path {} does not exist. Exiting...".format(filepath))
    input('Press ENTER to exit')
    sys.exit()

with open(r"{}".format(filepath)) as fp:
    for line in fp:
        for match in re.finditer(pattern, line):
            print(match.group())


input('Press ENTER to exit')
