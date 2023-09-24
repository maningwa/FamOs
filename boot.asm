[bits 16]
[org 0x7c00]
mov [diskNum], dl
mov bx, string
call print
call readdisk
cli
lgdt [GDT_descriptor]
mov eax , cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:0x7e00

jmp $
readdisk:
	mov ah, 2 
	mov al, 1
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, [diskNum]
	mov bx, 0x7e00
	int 0x13
	ret
print:
	cmp byte [bx], 0
	je .end
	mov ah, 0x0e
	mov al, [bx]
	int 0x10
	inc bx
	jmp print
	.end: ret

diskNum: db 0
string: 
	db 'Hello Weirdo',0x00
GDT_start:
	null_descriptorr:
		dd 0;four zero bits
		dd 0;four zero bits
	code_descriptor:
		dw 0xffff;
		dw 0
		db 0
		db 0b10011010
		db 0b11001111
		db 0 
	data_descriptor:
		dw 0xffff
		dw 0
		db 0
		db 0b10010010
		db 0b11001111
		db 0
GDT_end:
GDT_descriptor:
	dw GDT_end - GDT_start - 1; gdt size
	dd GDT_start ; address of GDT

CODE_SEG equ code_descriptor -GDT_start
DATA_SEG equ data_descriptor -GDT_start
times 510 - ($-$$) db 0
db 0x55, 0xaa
