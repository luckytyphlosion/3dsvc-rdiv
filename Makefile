#gawk sort order
#export LC_CTYPE=C

.SUFFIXES: .asm .o .gb

all: 3dsvc-rdiv.gb

3dsvc-rdiv.o: 3dsvc-rdiv.asm
	rgbasm -p 0xff -o 3dsvc-rdiv.o 3dsvc-rdiv.asm

3dsvc-rdiv.gb: 3dsvc-rdiv.o
	rgblink -n 3dsvc-rdiv.sym -o $@ $<
	rgbfix -p 0 -jv -k OK -l 0x33 -m 0x1b -r 04 -t "RDIV" $@

clean:
	rm -f 3dsvc-rdiv.o 3dsvc-rdiv.gb