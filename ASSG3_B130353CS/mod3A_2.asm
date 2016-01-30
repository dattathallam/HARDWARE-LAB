section .data
	msg1: db "Enter First string : "
	msg1_len: equ $-msg1
	msg2: db "Enter Second string : "
	msg2_len: equ $-msg2
	msg3: db "Are Annagram.", 0Ah
	msg3_len: equ $-msg3
	msg4: db "Are not Annagram.", 0Ah
	msg4_len: equ $-msg4
	
section .bss
	pnum:	resw 1
	temp:	resb 1
	nod:	resb 1
	
	
	string1: resb 200
	string2: resb 200
	string1_len: resd 1
	string2_len: resd 1
	count1:	resw 30
	count2:	resw 30
	char: resb 1
	index:	resd 1
	count:	resd 1

section .text
global _start

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, msg1_len
	int 80h
	
	mov dword[index], 0
	reading1Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading1
		mov eax, 0
		mov al, byte[char]
		mov edx, dword[index]
		mov byte[string1+edx], al
		cmp al, 'A'
		jb skip1
		cmp al, 'z'
		ja skip1
		cmp al, 'Z'
		jna gotCaps1
		cmp al, 'a'
		jnb gotSmall1
		jmp skip1
		
		gotCaps1:
			sub al, 'A'
			jmp skip1
		
		gotSmall1:
			sub al, 'a'
			jmp skip1
		
		skip1:
		inc word[count1+eax]
		inc dword[index]
		jmp reading1Loop
	
	endOfReading1:
	
	mov edx, dword[index]
	mov byte[string1+edx], 0
	inc edx
	mov edx, dword[index]
	mov dword[string1_len], edx
	; mov eax, edx
	; call print_num
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, msg2_len
	int 80h
	
	mov dword[index], 0
	reading2Loop:
		mov eax, 3
		mov ebx, 0
		mov ecx, char
		mov edx, 1
		int 80h
		
		cmp byte[char], 0Ah
		je endOfReading2
		mov eax, 0
		mov al, byte[char]
		mov edx, dword[index]
		mov byte[string2+edx], al
		cmp al, 'A'
		jb skip2
		cmp al, 'z'
		ja skip2
		cmp al, 'Z'
		jna gotCaps2
		cmp al, 'a'
		jnb gotSmall2
		jmp skip2
		
		gotCaps2:
			sub al, 'A'
			jmp skip2
		
		gotSmall2:
			sub al, 'a'
			jmp skip2
		
		skip2:
		inc word[count2+eax]
		inc dword[index]
		jmp reading2Loop
	
	endOfReading2:
	
	mov edx, dword[index]
	mov byte[string2+edx], 0
	inc edx
	mov edx, dword[index]
	mov dword[string2_len], edx
	; mov eax, edx
	; call print_num
	
	; mov eax, 4
	; mov ebx, 1
	; mov ecx, string1
	; mov edx, dword[string1_len]
	; int 80h
	
	; call print_newline
	
	; mov eax, 4
	; mov ebx, 1
	; mov ecx, string2
	; mov edx, dword[string2_len]
	; int 80h
	
	; call print_newline
	
	mov edx, 0
	compareLoop:
		cmp edx, 26
		je endCompareLoop
		mov ax, word[count1+edx]
		mov bx, word[count2+edx]
		;movzx eax, bh
		;call print_num
		;movzx eax, bl
		;call print_num
		cmp ax, bx
		jne endCompareLoop
		inc edx
		jmp compareLoop
	endCompareLoop:
	
	; mov eax, edx
	; call print_num
	
	cmp edx, 26
	je Equal
	jmp Not
	
	Equal:
		mov ecx, msg3
		mov edx, msg3_len
		jmp print
		
	Not:
		mov ecx, msg4
		mov edx, msg4_len
		jmp print
	
	print:
	mov eax, 4
	mov ebx, 1
	int 80h
	
	Exit:
	mov eax, 1
	mov ebx, 0
	int 80h

print_num:
	mov word[pnum], ax
	pusha
	cmp ax, 0
	je printZero
	mov byte[nod], 0
	extract_no:
		cmp word[pnum], 0
		je print_no
		inc byte[nod]
		mov dx, 0
		mov ax, word[pnum]
		mov bx, 10
		div bx
		
		push dx
		mov word[pnum], ax
		jmp extract_no
	
	print_no:
		cmp byte[nod], 0
		je end_print
		dec byte[nod]
		pop dx
		mov byte[temp], dl
		add byte[temp], 30h
		
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
		
		jmp print_no
	printZero:
		mov byte[temp], '0'
		mov eax, 4
		mov ebx, 1
		mov ecx, temp
		mov edx, 1
		int 80h
	end_print:
		call print_newline
		popa
		ret
print_newline:
	pusha
	mov byte[temp], 0Ah
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	popa
	ret
