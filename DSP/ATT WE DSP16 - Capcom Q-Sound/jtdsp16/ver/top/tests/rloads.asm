# Test register loads
move r0 = 0xFFFF
move r0 = 0
move r1 = 0x11
move r2 = 0x22
move r3 = 0x33
move r1 = 0x1111
move r2 = 0x2222
move r3 = 0x3333

# j, k, rb, re
move j = 0x4004
move k = 0x5005
move rb= 0x6006
move re= 0x7007

# pt, pr, i
pt = 0xbeef
pr = 0xcade
i  = 0xae00

# DAU
x=0x6532
yl=0x2312
auc=0x6
#psw=0xdeed
c0=0x10
c1=0x11
c2=0x12

end:
goto end
