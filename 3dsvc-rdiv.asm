INCLUDE "constants.asm"
SECTION "vblank", ROM0 [$40]
	ret

SECTION "Entry", ROM0 [$100]
	jp Start0150
	
SECTION "Header", ROM0 [$104]

	; The header is generated by rgbfix.
	; The space here is allocated to prevent code from being overwritten.

	rept $150 - $104
		db $00
	endr

SECTION "Main", ROM0 [$150]

Start0150:
	di
	ld a, $a
	ld [$0], a
	ld bc, 8 << 8 | rDIV & $ff
	ld a, 1
	ld [$2000], a
	xor a
WriteRDIVToSRAMLoop:
	ld hl, $a000
	ld [$4000], a
	ld d, a
	jp WriteRDIVToSRAM
AfterSRAMWrite:
	ld a, d
	inc a
	cp b
	jp nz, WriteRDIVToSRAMLoop
	ld sp, $fffe
	ld hl, rLCDC
	bit 7, [hl]
	jr z, .skipDisableLCD
.waitLCD
	ld a, [rLY]
	cp 145
	jr nz, .waitLCD
.skipDisableLCD
	ld [hl], %1
	ld hl, $fe00
	ld bc, $a0
	xor a
	call ByteFill
	ld hl,$8000
	ld bc,$2000
	dec a
	call ByteFill
	ld [rBGP], a
	ld hl,rLCDC
	set 7,[hl]
	jr @

ByteFill:
	inc b
	inc c
	jr .handleLoop
.loop
	ld [hli], a
.handleLoop
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

SECTION "Main SRAM Write 1", ROM0 [$3ffc]
WriteRDIVToSRAM:
	ld a, [$ff00+c]
	ld [hli], a
	ld a, [$ff00+c]
	ld [hli], a

SECTION "Main SRAM Write 2", ROMX, BANK[$01]
	rept $2000 - 2
	ld a, [$ff00+c]
	ld [hli], a
	endr
	jp AfterSRAMWrite