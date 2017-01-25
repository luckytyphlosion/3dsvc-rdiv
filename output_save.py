output = ""
with open("3dsvc-rdiv.sav", "rb") as f:
	while True:
		byte = f.read(1)
		if byte == "":
			break
		else:
			output += ("%x" % ord(byte)).zfill(2) + "\n"

with open("3dsvc-rdiv.txt", "w+") as f:
	f.write(output)
