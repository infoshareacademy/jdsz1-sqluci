#typy danych - zad. 4
#Stwórz plik in.txt o następującej treści:
#1 2 2 3 1 4

file = open("in.txt", "w")
file.write("1 2 2 3 1 4")
file.close()

#a następnie:
#otwórz plik in.txt w trybie do odczytu,

file = open("in.txt", 'r')

#odczytaj zapisane w nim liczby,
print(file.read())

#otwórz plik out.txt w trybie do zapisu,
file2 = open("out.txt", "w") #tworzenie pliku
file2 = open("out.txt", "r")
#zapisz w nim unikalne wystąpianie liczb z pliku in.txt; liczby w pliku powinny być oddzielone spacjami.
str1 = ("1 2 2 3 1 4")
print(str1)
str1=str1.replace(" ", "")
print(str1)
set1=set(str1)
print(set1)
s = " "
set2=s.join(set1)
print(set2)

with open("out.txt", "w") as text_file:
    print(set2, file=text_file)

#instrukcje - zadania 1,2,3
#zad 1

n = 5
l = [(1, 2, 100), (2, 5, 100), (3, 4, 100)]
suma=0

for a,b,k in l:
    suma+=(b-a+1)*k

print(suma/n)


#zad 2
# Napisz program, który dla zadanej zmiennej przechowującej dowolny ciąg znaków zlicza wystąpienia
# poszczególnych znaków w ciągu. Wypisz na ekran znaki i ich liczebności w porządku alfabetycznym.

x = 'hjloujcpoqfwhph'

chars = []
for line in x:
   for c in line:
       chars.append(c)

print(chars)

print(set(map(lambda x  : (x , list(chars).count(x)), chars)))



#zad 3
#Napisz program, który w obustronnie dokniętym zakresie [2000, 3200], znajdzie wszystkie liczby,
# które są podzielne przez 7 i nie są podzielne przez 5. Znalezione liczby wyświetl w jednej
# linii oddzielając je przecinkiem.

l=[]
for i in range(2000,3201):
    if i % 7 == 0 and i % 5 != 0:
        l.append(i)

print(l)

#konstrukcje składane - zadania 2,3
#zad 2
#Wyświet na ekran wartość True jeżeli w napisie znajduje się dowolny ze znaków: 'x', '^', '@',
# w przeciwnym razie wyświetl False.

var1 = 'qwerty123!@$'
if 'x' or '^' or '@' in var1: print ("True")
else: print ("False")

#zad 3
#Dana jest lista
a = [[5, 3, 7], [1, 8, 1, 2], [5, 9]]
#Napisz kod, która zamieni listę do postaci jednowymiarowej:
# [5, 3, 7, 1, 8, 1, 2, 5, 9]

flat_list = [item for sublist in a for item in sublist]
print(flat_list)

#funkcje - zadania 1,2
#Zadanie 1
#Napisz funkcję przyjmującą dowolną liczbę parametrów liczbowych i zwracającą
# wartość maksimum z pobranych liczb.

def my_func_max(*args):
    return max(args)

print(my_func_max(400,50,6))

#Napisz funkcję, która dla zadanej cyfry d odbliczy sumę liczb: d + dd + ddd + dddd.

def f(d):
    dd = int(str(d) * 2)
    ddd = int(str(d) * 3)
    dddd = int(str(d) * 4)
    x = d + dd +ddd
    print(x)
f(3)


