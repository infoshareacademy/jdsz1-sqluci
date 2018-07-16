# typy danych - zad 4
print("- - - - - - - - - - TYPY DANYCH - - - - - - - - - -")
print("- - - - - - - - - - zad. 4 - - - - - - - - - -")
with open("in.txt","w") as f:
    f.write("1 2 2 3 1 4")

x=None #force proper lifetime scope
with open("in.txt","r") as f:
    x = list(map(int,f.readline().split(" ")))
print(x)

with open("out.txt","w") as f:
    f.write(" ".join(map(str,list(frozenset(x)))))


print("- - - - - - - - - - INSTRUKCJE - - - - - - - - - -")
print("- - - - - - - - - - zad. 1 - - - - - - - - - -")
n = 5
l = [(1, 2, 100), (2, 5, 100), (3, 4, 100)]
#dict instead of list to avoid jar enumeration ambiguity, slower but more robust
jars = dict((key, value) for (key, value) in zip(range(1,n+1),[0]*n) )

for a,b,k in l:
   for i in range(a,b+1):
       jars[i] += k
   #print(jars)
print("stan cukierków w słoikach to:")
print(jars)

avg = int(sum(jars.values())/n)
print("średnia licba cukierków to ",avg)

print("- - - - - - - - - - zad. 2 - - - - - - - - - -")
txt = "Lorem ipsum dolor sit amet"
d = dict()
for c in txt:
    d[c] = ( 1 if (d.get(c) is None) else d[c] + 1 )
for c,n in sorted(d.items()): #since charaters occur only once in dict, whole items can be sorted
    print("character: \'{}\' occurred {} times'".format(c,n))

print("- - - - - - - - - - zad. 3 - - - - - - - - - -")
from itertools import filterfalse
R = range(2000,3200+1) #assuming integers only

#it should be compressed to one-liner, but then it would be hard to analyze - sorry for Mathematica like indentation
line = str( #create a string line from tuple and strip the first "(" and last ")" element
            tuple(  #create tuple from iterator
                filterfalse(lambda y: not y, #extract the values that are not equal to zero
                            map(lambda x: x if not (x % 7) and (x % 5) else 0  ,R)  #make a mapping returning value if condition is true and zero if false
                            ) #filterfalse(
                 ) #tuple
       ).replace(" ","")[1:-1] #str(
print(line)

print("- - - - - - - - - - KONSTRUKCJE SKŁADANE - - - - - - - - - -")
print("- - - - - - - - - - zad. 2 - - - - - - - - - -")
s = 'qwerty123!@$'
chars = "x^@"
res = any([ s.find(c) != -1 for c in chars ])
print(res)
print("- - - - - - - - - - zad. 3 - - - - - - - - - -")
a = [[5, 3, 7], [1, 8, 1, 2], [5, 9]]
flat = [e for b in a for e in b]
print(flat)


print("- - - - - - - - - - FUNKCJE - - - - - - - - - -")
print("- - - - - - - - - - zad. 1 - - - - - - - - - -")
def get_max(*args):
    return max(args)

print( get_max(3,2,-2, 20, 8, 0) )

print("- - - - - - - - - - zad. 2 - - - - - - - - - -")
def funny_sum(d):
    if d in range(0,10):
        s = str(d)
        return sum([int(s*i) for i in range(1,5)])

print( funny_sum(1) )
print( funny_sum(4) )
