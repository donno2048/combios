mov dx, 0x3c2
mov al, 0xc3
out dx, al
mov dx, 0x3c4
mov al, 0x4
out dx, al
inc dx
mov al, 0x2
out dx, al
inc sp
inc sp

push cs
pop ds
mov al, 0xff
mov dx, 0x3c6
out dx, al
mov al, 0
mov dx, 0x3c8
out dx, al
mov cx, 0x40
xor si, si
inc dx
palette_fill:
mov al, [palt+si]
out dx, al
inc si
mov al, [palt+si]
out dx, al
inc si
mov al, [palt+si]
out dx, al
inc si
loop palette_fill
mov cx, 0x240
xor al, al
filler:
out dx, al
loop filler

push 0
pop ds
mov WORD [0x40], clear
mov WORD [0x42], cs
call setup_keyboard
call setup_screen
xor bx, bx
mov cx, 0xff
mov si, 0x100
push 0x2
popf
mov ax, cs
mov ds, ax
mov es, ax
xor ax, ax
jmp _start


times ($$-$+0x100) db 0
_start:
%defstr file COM
incbin file
hlt


setup_screen:
    pushf
    pusha
    push ds
    push es
    push cs
    pop ds
    mov dx, 0x3da
    in al, dx
    mov cx, 0x14
    xor si, si
    mov dx, 0x3c0
.arct_loop:
    mov ax, si
    out dx, al
    mov al, [arct+si]
    out dx, al
    inc si
    loop .arct_loop
    mov al, 0x14
    out dx, al
    xor al, al
    out dx, al
    mov dx, 0x3c4
    out dx, al
    inc dx
    mov al, 0x3
    out dx, al
    mov cx, 0x4
    xor si, si
.sequ_loop:
    inc si
    mov dx, 0x3c4
    mov ax, si
    out dx, al
    inc dx
    mov al, [sequ+si-1]
    out dx, al
    loop .sequ_loop
    mov cx, 0x9
    xor si, si
.grdc_loop:
    mov dx, 0x3ce
    mov ax, si
    out dx, al
    inc dx
    mov al, [grdc+si]
    out dx, al
    inc si
    loop .grdc_loop
    mov dx, 0x3d4
    mov ax, 0x11
    out dx, ax
    mov cx, 0x19
    xor si, si
.crtc_loop:
    mov dx, 0x3d4
    mov ax, si
    out dx, al
    inc dx
    mov al, [crtc+si]
    out dx, al
    inc si
    loop .crtc_loop
    mov dx, 0x3c2
    mov al, 0x67
    out dx, al
    mov dx, 0x3c0
    mov al, 0x20
    out dx, al
    mov dx, 0x3da
    in al, dx

    push 0xb800
    pop es
    mov ax, 0x720
    mov cx, 0x4000
    xor di, di
    rep stosw

    push ds
    push 0x40
    pop ds
    mov BYTE [0x49], 0
    mov WORD [0x4a], 0x28
    mov WORD [0x4c], 0
    mov WORD [0x4e], 0
    mov WORD [0x50], 0
    mov BYTE [0x62], 0
    mov WORD [0x63], 0x3d4
    mov WORD [0x65], 0
    mov BYTE [0x66], 0
    mov BYTE [0x84], 0x18
    mov WORD [0x85], 0x10
    mov BYTE [0x87], 0x60
    mov BYTE [0x88], 0xf9
    mov BYTE [0x8a], 0x8
    mov WORD [0xa8], dummy
    mov WORD [0xaa], 0xc000
    pop ds

    mov dx, 0x3d4
    mov al, 0xc
    out dx, al
    inc dx
    xor al, al
    out dx, al
    dec dx
    mov al, 0xd
    out dx, al
    inc dx
    xor al, al
    out dx, al

    dec dx
    mov al, 0xe
    out dx, al
    inc dx
    xor al, al
    out dx, al
    dec dx
    mov al, 0xf
    out dx, al
    inc dx
    xor al, al
    out dx, al

    mov dx, 0x3c4
    mov ax, 0x100
    out dx, ax
    mov ax, 0x402
    out dx, ax
    mov ax, 0x704
    out dx, ax
    mov ax, 0x300
    out dx, ax
    mov dx, 0x3ce
    mov ax, 0x204
    out dx, ax
    mov ax, 0x5
    out dx, ax
    mov ax, 0x406
    out dx, ax
    mov cx, 0x100
    xor si, si
    push 0xa000
    pop es
.copy_font:
    push ds
    pusha
    mov cx, 0x10
    mov di, si
    add di, si
    mov si, [font+si]
    push 0xc000
    pop ds
    cld
    rep movsb
    popa
    pop ds
    add si, 0x10
    loop .copy_font
    mov dx, 0x3c4
    mov ax, 0x100
    out dx, ax
    mov ax, 0x302
    out dx, ax
    mov ax, 0x304
    out dx, ax
    mov ax, 0x300
    out dx, ax
    mov dx, 0x3cc
    in al, dx
    and al, 0x1
    shl al, 0x2
    or al, 0xa
    mov ah, al
    mov al, 0x6
    mov dx, 0x3ce
    out dx, ax
    mov ax, 0x4
    out dx, ax
    mov ax, 0x1005
    out dx, ax
    mov dx, 0x3c4
    mov ax, 0x3
    out dx, ax
    pop es
    pop ds
    popa
    popf
    ret
setup_keyboard:
    pusha
    mov cx, 0x10
.flush:
    in al, 0x64
    in al, 0x60
    loop .flush
    mov al, 0xad
    out 0x64, al
    mov al, 0xa7
    out 0x64, al
    mov cx, 0x10
.flush2:
    in al, 0x64
    in al, 0x60
    loop .flush2

    mov al, 0x60
    out 0x64, al
    mov al, 0x70
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    out 0x60, al
    mov al, 0xf5
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    out 0x60, al

    mov al, 0x60
    out 0x64, al
    mov al, 0x70
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    out 0x60, al
    mov al, 0xf0
    out 0x60, al
    mov al,  0x1
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    out 0x60, al

    mov al, 0x60
    out 0x64, al
    mov al, 0x30
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    mov al, 0x20
    out 0x60, al
    mov al, 0xf4
    out 0x60, al
    mov al, 0x60
    out 0x64, al
    mov al, 0x20
    out 0x60, al
    popa
    ret
clear:
    pusha
    push es
    push 0xb800
    pop es
    mov ax, 0x720
    mov cx, 0x410
    xor di, di
    rep stosw
    pop es
    popa
    iret

arct: db 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x14, 0x07, \
         0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f, \
         0x0c, 0x00, 0x0f, 0x08
sequ: db 0x08, 0x03, 0x00, 0x02
grdc: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x0e, 0x0f, 0xff
crtc: db 0x2d, 0x27, 0x28, 0x90, 0x2b, 0xa0, 0xbf, 0x1f, \
         0x00, 0x4f, 0x0d, 0x0e, 0x00, 0x00, 0x00, 0x00, \
         0x9c, 0x8e, 0x8f, 0x14, 0x1f, 0x96, 0xb9, 0xa3, 0xff
palt: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x2a, 0x00, 0x2a, \
         0x00, 0x00, 0x2a, 0x2a, 0x2a, 0x00, 0x00, 0x2a, \
         0x00, 0x2a, 0x2a, 0x2a, 0x00, 0x2a, 0x2a, 0x2a, \
         0x00, 0x00, 0x15, 0x00, 0x00, 0x3f, 0x00, 0x2a, \
         0x15, 0x00, 0x2a, 0x3f, 0x2a, 0x00, 0x15, 0x2a, \
         0x00, 0x3f, 0x2a, 0x2a, 0x15, 0x2a, 0x2a, 0x3f, \
         0x00, 0x15, 0x00, 0x00, 0x15, 0x2a, 0x00, 0x3f, \
         0x00, 0x00, 0x3f, 0x2a, 0x2a, 0x15, 0x00, 0x2a, \
         0x15, 0x2a, 0x2a, 0x3f, 0x00, 0x2a, 0x3f, 0x2a, \
         0x00, 0x15, 0x15, 0x00, 0x15, 0x3f, 0x00, 0x3f, \
         0x15, 0x00, 0x3f, 0x3f, 0x2a, 0x15, 0x15, 0x2a, \
         0x15, 0x3f, 0x2a, 0x3f, 0x15, 0x2a, 0x3f, 0x3f, \
         0x15, 0x00, 0x00, 0x15, 0x00, 0x2a, 0x15, 0x2a, \
         0x00, 0x15, 0x2a, 0x2a, 0x3f, 0x00, 0x00, 0x3f, \
         0x00, 0x2a, 0x3f, 0x2a, 0x00, 0x3f, 0x2a, 0x2a, \
         0x15, 0x00, 0x15, 0x15, 0x00, 0x3f, 0x15, 0x2a, \
         0x15, 0x15, 0x2a, 0x3f, 0x3f, 0x00, 0x15, 0x3f, \
         0x00, 0x3f, 0x3f, 0x2a, 0x15, 0x3f, 0x2a, 0x3f, \
         0x15, 0x15, 0x00, 0x15, 0x15, 0x2a, 0x15, 0x3f, \
         0x00, 0x15, 0x3f, 0x2a, 0x3f, 0x15, 0x00, 0x3f, \
         0x15, 0x2a, 0x3f, 0x3f, 0x00, 0x3f, 0x3f, 0x2a, \
         0x15, 0x15, 0x15, 0x15, 0x15, 0x3f, 0x15, 0x3f, \
         0x15, 0x15, 0x3f, 0x3f, 0x3f, 0x15, 0x15, 0x3f, \
         0x15, 0x3f, 0x3f, 0x3f, 0x15, 0x3f, 0x3f, 0x3f
font: incbin "CP437.F16"
dummy: times ($$-$+0xfff0) db 0
db 0xea, 0x00, 0x00, 0x00, 0xf0, 0x00, 0x00, 0x00
db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfc, 0x99
