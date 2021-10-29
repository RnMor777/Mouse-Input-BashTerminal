segment .data
    initSys     db    "stty -echo -icanon", 0 
    initMouse   db    "echo '", 0x1b, "[?1003h", 0x1b, "[?1015h", 0x1b, "[?1006h'", 0
    resSys      db    "stty echo icanon", 0 
    resMouse    db    "echo '", 0x1b, "[?1003l", 0x1b, "[?1015l", 0x1b, "[?1006l'", 0
    frmt_print  db    "%d %d %d %c", 10, 0
    frmt_delim  db    ";", 0
    frmt_Mm     db    "mM", 0

segment .bss

segment .text
    extern getchar
    extern fcntl
    extern system
    extern malloc
    extern atoi
    extern strtok  
    extern printf
    global main

main: 
    enter   0, 0
    pusha

    push    initSys
    call    system
    add     esp, 4
    push    initMouse
    call    system
    add     esp, 4

    call    subfunc

    push    resSys
    call    system
    add     esp, 4
    push    resMouse
    call    system
    add     esp, 4

    popa
    mov     eax, 0
    leave
    ret

nonblockgetchar:
    push    ebp
    mov     ebp, esp

	sub		esp, 8

	push	0
	push	4
	push	0
	call	fcntl
	add		esp, 12
	mov		DWORD [ebp-4], eax

	or		DWORD [ebp-4], 2048
	push	DWORD [ebp-4]
	push	4
	push    0
	call	fcntl
	add		esp, 12

	call	getchar
	mov		DWORD [ebp-8], eax

	xor		DWORD [ebp-4], 2048
	push	DWORD [ebp-4]
	push	4
	push	0
	call	fcntl
	add		esp, 12

	mov		eax, DWORD [ebp-8]

    mov     esp, ebp
    pop     ebp
    ret
processgetchar:
    push    ebp
    mov     ebp, esp

    sub     esp, 8
    mov     DWORD[ebp-4], 0
    
    topGetCharLoop:
    call    nonblockgetchar
    mov     DWORD[ebp-8], eax  

    xor     eax, eax
    mov     ebx, DWORD[ebp-8]
    cmp     bl, -1
    je      endGetCharLoop

    mov     ecx, DWORD[ebp+8]
    mov     edx, DWORD[ebp-4]
    mov     BYTE[ecx+edx], bl
    inc     DWORD[ebp-4]

    cmp     bl, 'M'
    je      returnGetChar
    cmp     bl, 'm'
    je      returnGetChar
    jmp     botGetCharLoop
    returnGetChar:
        mov     eax, edx
        inc     eax
        jmp     endGetCharLoop
    botGetCharLoop:
    jmp     topGetCharLoop
    endGetCharLoop:
    mov     esp, ebp
    pop     ebp
    ret
subfunc:
    push    ebp
    mov     ebp, esp

    sub     esp, 32

    push    17
    call    malloc
    add     esp, 4

    mov     DWORD[ebp-4], eax
    mov     DWORD[ebp-8], eax
    add     DWORD[ebp-8], 3

    topScanLoop:
    push    DWORD[ebp-4]
    call    processgetchar
    add     esp, 4
    mov     DWORD[ebp-16], eax
    cmp     eax, 0
    je      topScanLoop

    mov     ebx, DWORD[ebp-4]
    xor     ecx, ecx
    mov     cl, BYTE[ebx+eax-1]
    mov     DWORD[ebp-32], ecx

    push    frmt_delim
    push    DWORD[ebp-8]
    call    strtok
    add     esp, 8
    push    eax
    call    atoi
    add     esp, 4
    mov     DWORD[ebp-20], eax

    push    frmt_delim
    push    0
    call    strtok
    add     esp, 8
    push    eax
    call    atoi
    add     esp, 4
    mov     DWORD[ebp-24], eax

    push    frmt_Mm
    push    0
    call    strtok
    add     esp, 8
    push    eax
    call    atoi
    add     esp, 4
    mov     DWORD[ebp-28], eax

    push    DWORD[ebp-32]
    push    DWORD[ebp-28]
    push    DWORD[ebp-24]
    push    DWORD[ebp-20] 
    push    frmt_print
    call    printf
    add     esp, 20
    jmp     topScanLoop

    mov     esp, ebp
    pop     ebp
    ret

; vim:ft=nasm
