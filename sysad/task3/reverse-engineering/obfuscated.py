# picoCTF123_13492
from z3 import *
# def obfuscate_string(s):
#     result = 0
#     for i in s:
#         result ^= ord(i)
#         result = result >> 7
#         result+=ord(i)*5
#     return result

# str1 = input("Enter the String: ")
# a = obfuscate_string(str1)
# target_value = 252
# if a==target_value:
#     print("Flag: You have found the secret string")
# else:
#     print("Incorrect string")

def reverse_obfuscate_string(target_value,length = 16):
    #length of the flag is 16
    s = [BitVec(f's{i}',8) for i in range(1, length+1)]
    result = BitVecVal(0,32)

    for i in s:
        result ^= ZeroExt(24,s[i])
        result = LShR(result, 7)
        result += ZeroExt(24, s[i])*5
    
    solver = Solver()
    solver.add(result==target_value)

    if solver.check() == sat:
        model = solver.model()
        print("Solution exists, the string has been found")
        for char in s:
            # print(char)
            # print(model[char])
            print(chr(model[char].as_long()))
    else:
        print("There is no solution")

reverse_obfuscate_string(252,16)