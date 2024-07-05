s = input()

f = s.split(", ")
out = ""
for i in f:
	out+=f".{i}({i}), "

print(out)



