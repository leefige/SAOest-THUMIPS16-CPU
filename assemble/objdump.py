import sys

def get_ins_by_hex(v):
    first5 = v >> 11
    first8 = v >> 8
    last2 = v & 0b11
    last8 = v & 0b11111111
    last5 = v & 0b11111
    if first5 == 0b01001:
        return 'ADDIU'
    elif first5 == 0b01000:
        return 'ADDIU3'
    elif first8 == 0b01100011:
        return 'ADDSP'
    elif first5 == 0b11100 and last2 == 0b01:
        return 'ADDU'
    elif first5 == 0b11100 and last2 == 0b11:
        return 'SUBU'
    elif first5 == 0b11101 and last5 == 0b01011:
        return 'NEG'

    elif first5 == 0b11101 and last5 == 0b01100:
        return 'AND'
    elif first5 == 0b11101 and last5 == 0b01101:
        return 'OR'

    elif first5 == 0b00110 and last2 == 0b00:
        return 'SLL'
    elif first5 == 0b00110 and last2 == 0b11:
        return 'SRA'
    elif first5 == 0b00110 and last2 == 0b10:
        return 'SRL'

    elif first5 == 0b00010:
        return 'B'
    elif first5 == 0b00100:
        return 'BEQZ'
    elif first5 == 0b00101:
        return 'BNEZ'
    elif first8 == 0b01100000:
        return 'BTEQZ'
    elif first5 == 0b11101 and last8 == 0:
        return 'JR'
    elif first5 == 0b11101 and last8 == 0b11000000:
        return 'JALR'
    elif v == 0b1110100000100000:
        return 'JRRA'

    elif first5 == 0b11101 and last5 == 0b01010:
        return 'CMP'
    elif first5 == 0b11101 and last5 == 0b00010:
        return 'SLT'

    elif first5 == 0b11110 and last8 == 0:
        return 'MFIH'
    elif first5 == 0b11101 and last8 == 0b01000000:
        return 'MFPC'
    elif first5 == 0b11110 and last8 == 1:
        return 'MTIH'
    elif first8 == 0b01100100 and last5 == 0:
        return 'MTSP'

    elif first5 == 0b01101:
        return 'LI'
    elif first5 == 0b10011:
        return 'LW'
    elif first5 == 0b10010:
        return 'LW_SP'
    elif first5 == 0b11011:
        return 'SW'
    elif first8 == 0b01100010:
        return 'SW_RS'
    elif first5 == 0b11010:
        return 'SW_SP'
    elif v == 0b0000100000000000:
        return 'NOP'
    else:
        return '** ERROR **'

if __name__ == '__main__':
    v = int(sys.argv[1], 16)
    print(get_ins_by_hex(v))
