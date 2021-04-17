import sys
import os
import re

import csv

# Define and check Filepath1 as an existing file path.

filepath1 = input('Input existing file to check: ')

if not os.path.isfile(filepath1):
    print("File path {} does not exist. Exiting...".format(filepath1))
    input('Press ENTER to exit')
    sys.exit()

# Define and open/create Filepath2 as the export file path
filepath2 = input('Input full path of data export file: ')
fp2 = open(r"{}".format(filepath2),'w')

# Define REGEX Patterns
pattern = re.compile("(?<=\>).+?(?=\<)" + "|" + "</tr>")

# Open Filepath1 and run the main loop. Reads each line, finds pattern match, replaces </tr> with new lines.
with open(r"{}".format(filepath1),'r') as fp1:
    for line in fp1:
        for match in re.finditer(pattern, line):
            data = match.group()
            if data == str("</tr>"):
                data = str("\n")
            print(data + ' written to {}'.format(filepath2))
            fp2.writelines(data + ',')


# Force User interaction for window close, cleanly close file
input('Press ENTER to exit')
filepath2.close()
