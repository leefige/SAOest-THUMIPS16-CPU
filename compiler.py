import os
def readfile(filename):
    """read and store test file"""
    fobj = open(filename, 'r')
    lines = []
    for eachLine in fobj:
        lines.append(eachLine)
    fobj.close()
    return lines
def writefile(filename, l):
    """write the file with the binary"""
    ls = os.linesep
    fobj = open(filename, 'w')
    fobj.writelines(['%s%s' % (x, ls) for x in l])
    fobj.close()
    print('DONE!')
def splitOandD(inst):
    """split the op and data"""
    sinst = []
    for x in inst:
        z = x.rstrip()
        y = z.split(' ', 1)
        sinst.append(y)
    return sinst
def numtobin(num, count):
    """tran a num to binary"""
    s = (bin(num))[2:]
    ss = ((count - len(s)) * '0') + s
    return ss
def regtobin(reg):
    """make a regs to binary"""
    regs = reg.lstrip()
    regnum = regs[1:]
    if((int)(regnum) <= 31 and (int)(regnum) >= 0):
        regb = numtobin((int)(regnum), 3)
        return regb
    else:
        print("***no regs: ", regs)
    return regb
def handle(ins):
    """handle the strings to regular binary code"""
    op = (str)(ins[0])
    data = (str)(ins[1])
    sdata = data.lstrip()
    dl = sdata.split(',')
    if op == "subu":
        opcode = "11100"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        rz = regtobin(dl[2])
        incode = opcode + rx + ry + rz + "11"
    elif op == "addu":
        opcode = "11100"
        rx = regtobin(dl[0])  
        ry = regtobin(dl[1])  
        rz = regtobin(dl[2])   
        incode = opcode + rx + ry + rz + "01"
    elif op == "neg":  
        opcode = "11101"  
        rx = regtobin(dl[0])  
        ry = regtobin(dl[1])  
        incode = opcode + rx + ry + "01011"  
    elif op == "addiu":  
        opcode = "01001"  
        rx = regtobin(dl[0])   
        imm = numtobin((int)(dl[1]), 8)  
        incode = opcode + rx + imm
    elif op == "addiu3":
        opcode = "01000"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[2]), 4)
        incode = opcode + rx + ry + "0" + imm 
    elif op == "addsp":
        opcode = "00000"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx + imm
    elif op == "and":
        opcode = "11101"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        incode = opcode + rx + ry + "01100"
    elif op == "or":
        opcode = "11101"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        incode = opcode + rx + ry + "01101"
    elif op == "sll":
        opcode = "00110"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[2]), 3)
        incode = opcode + rx + ry + imm + "00"
    elif op == "sra":
        opcode = "00110"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[2]), 3)
        incode = opcode + rx + ry + imm + "11"
    elif op == "srl":
        opcode = "00110"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[2]), 3)
        incode = opcode + rx + ry + imm + "10"
    elif op == "b":
        opcode = "00010"
        imm = numtobin((int)(dl[0]), 11)
        incode = opcode + imm
    elif op == "beqz":
        opcode = "00100"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx + imm
    elif op == "bnez":
        opcode = "00101"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx + imm
    elif op == "bteqz":
        opcode = "01100000"
        imm = numtobin((int)(dl[0]), 8)
        incode = opcode + imm
    elif op == "jr":
        opcode = "11101"
        rx = regtobin(dl[0])
        incode = opcode + rx + "00000000"
    elif op == "jalr":
        opcode = "11101"
        rx = regtobin(dl[0])
        incode = opcode + rx + "11000000"
    elif op == "jrra":
        incode = "1110100000100000"
    elif op == "cmp":
        opcode = "00110"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        incode = opcode + rx + ry + "01010"
    elif op == "slt":
        opcode = "11101"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        incode = opcode + rx + ry + "00010"
    elif op == "mfih":
        opcode = "11110"
        rx = regtobin(dl[0])
        incode = opcode + rx + "00000000"
    elif op == "mfpc":
        opcode = "11101"
        rx = regtobin(dl[0])
        incode = opcode + rx + "01000000"
    elif op == "mtih":
        opcode = "11110"
        rx = regtobin(dl[0])
        incode = opcode + rx + "00000001"
    elif op == "mtsp":
        opcode = "01100100"
        rx = regtobin(dl[0])
        incode = opcode + rx + "00000"
    elif op == "li":
        opcode = "01101"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx + imm
    elif op == "lw":
        opcode = "10011"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[2]), 5)
        incode = opcode + rx + ry + imm
    elif op == "lw_sp":
        opcode = "10010"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx + imm
    elif op == "sw":
        opcode = "11011"
        rx = regtobin(dl[0])
        ry = regtobin(dl[1])
        imm = numtobin((int)(dl[1]), 5)
        incode = opcode + rx + ry + imm
    elif op == "sw_sp":
        opcode = "11010"
        rx = regtobin(dl[0])
        imm = numtobin((int)(dl[1]), 8)
        incode = opcode + rx +imm
    elif op == "nop":
        incode = "0000100000000000"





 
    else:  
        print("***Not Define: ", op)
    print(incode)
    return incode  
      
   
def main():  
    l = readfile("C:\\Users\\Mao Yiming\\Desktop\\i.txt")  
    s = splitOandD(l)  
    b = []  
    print(s)  
    for m in s:  
        if m != ['']:  
            print(m)  
            b.append(handle(m))             
    writefile("C:\\Users\\Mao Yiming\\Desktop\\o.txt", b)  
if __name__ == "__main__":  
    main()  