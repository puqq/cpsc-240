extern printf
extern scanf
extern cos
extern sin

global area

segment .data
pi: dq 0x400921FB4442D18
str_prompt: db `Welcome to Amazing Triangles. Enter the length of side 1, length of side 2, and an angle in degrees, on the same line, separated by a space.\n`,0
str_nextline: db `\n`, 0
strf_user_values: db `\nInputted sides %lf and %lf with angle %lf°\n`, 0
strf_answers: db `\nPerimeter: %lf\nArea: %lf\n`, 0
strf_three_doubles: db "%lf %lf %lf", 0

segment .bss
perimeter: resq 1 ; resq = reserve n qwords (n=1)
area: resq 1

segment .text
triangle: 
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf

; print prompt
mov rdi, str_prompt
call printf

; get values from user
push qword 0 ; rsp lineup for scanf call thing

; set aside 3 doubles

push qword 0
push qword 0
push qword 0
mov rdi, strf_three_doubles ; address
mov rsi, rsp ; rsi = rsp side A
mov rdx, rsp
add rdx, 8 ; rdx = rsp + 8 = side B
mov rcx, rsp
add rcx, 16 ; rcx = rsp + 16 = amgle (deg)
call scanf

; put values into XMM reg. for calculations

movsd xmm15, [rsp] ; side A
pop rax
movsd xmm14, [rsp] ; side B 
pop rax
movsd xmm13, [rsp] ; angle (deg)
pop rax
pop rax ; undo rsp lineup

; print users inputted values
mov rdi, strf_user_values
mov rax, 3
movsd xmm0, xmm15
movsd xmm1, xmm14
movsd xmm2, xmm13
call printf

; convert xmm13 into radians
movsd xmm12, [pi] ; xmm 12 = pi 
mov rax, 180
cvtsi2sd xmm11, rax ; xmm1 = 180 denom
divsd xmm12, xmm11 ; xmm12 = pi/180
mulsd xmm13, xmm12 ; xmm13 = radian angle

; perimeter calculations
; side C = sqrt(a^2 + b^2 - 2ab*cos(x))

; xmm15 = a
; xmm14 = b
; xmm13 = angle (rad)

mov rax, 2
cvtsi2sd xmm12, rax
mulsd xmm12, xmm15
mulsd xmm12, xmm14 ; xmm12 = 2ab

movsd xmm11, xmm15
mulsd xmm11, xmm11 ; xmm11 = a^2

movsd xmm10, xmm14
mulsd xmm10, xmm10 ; xmm10 = b^2

; cos(x)
movsd xmm0, xmm13
call cos ; xmm0 = cos(x)

mov rax, -1
cvtsi2sd xmm9, rax
mulsd xmm9, xmm12 ; xmm9 = -2ab
mulsd xmm9, xmm0 ; xmm9 = -2ab*cos(x)
addsd xmm9, xmm10 
addsd xmm9, xmm11 ; xmm9 = a^2 + b^2 - 2ab*cos(x)
sqrtsd xmm9, xmm9 ; xmm9 = side C (missing)

; add sides
addsd xmm9, xmm15
addsd xmm9, xmm14 ; xmm9 = perimeter

movsd [perimeter], xmm9 ; store for later

; area calculations
; area = [a*b*sin(x)]/2

; xmm15 = a
; xmm14 = b
; xmm13 = angle(rad)

movsd xmm0, xmm13
call sin ; xmm0 = sin(x)

; do the formula

movsd xmm12, xmm0 
mulsd xmm12, xmm15
mulsd xmm12, xmm14
mov rax, 2
cvtsi2sd xmm11, rax
divsd xmm12, xmm11
movsd [area], xmm12

; final result
movsd xmm0, [perimeter]
movsd xmm1, [area]
mov rdi, strf_answers
mov rax, 2
call printf

movsd xmm0, [area]

    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    fin
