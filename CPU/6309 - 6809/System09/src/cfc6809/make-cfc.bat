cls
as6809.exe -l -p -o -g cfcide.s
aslink.exe -p -s -o -m -x -u -g WORKPG=0x2200 -b WORKPG=0x2200 -b DATAPG=0x2300 -b IDE=0x3000 cfcide.rel