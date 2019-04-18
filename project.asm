; A very basic calculator written in assembly language
; You can run it via emu8086 emulator



.model small
.stack 100h
.data
    menu_message db "1. Add", 0dh, 0ah, "2. Subtract", 0dh, 0ah, "3. Multiply", 0dh, 0ah, "4. Division", 0dh, 0ah, "5. Power", 0dh, 0ah, "6. Factorial", 0dh, 0ah, "7. Exit$"
    option1 db 0dh, 0ah, 0dh, 0ah, "__Addition__", 0dh, 0ah, '$'
    option2 db 0dh, 0ah, 0dh, 0ah, "__Subtraction__", 0dh, 0ah, '$'
    option3 db 0dh, 0ah, 0dh, 0ah, "__Multiplication__", 0dh, 0ah, '$'
    option4 db 0dh, 0ah, 0dh, 0ah, "__Division__", 0dh, 0ah, '$'
    option5 db 0dh, 0ah, 0dh, 0ah, "__Find Power__", 0dh, 0ah, '$'
    option6 db 0dh, 0ah, 0dh, 0ah, "__Find Factorial__", 0dh, 0ah, '$'
    input1 db 0dh, 0ah, "Enter first number: $"
    input2 db 0dh, 0ah, "Enter second number: $"
    number1 dw 0
    number2 dw 0
    answer dw 0
    fact dw 1
    i dw ?
    j dw ?
    choice db 0dh, 0ah, "Enter your choice: $"
    wrong_input db 0dh, 0ah, 0dh, 0ah, "__Wrong choice__$"
    result db 0dh, 0ah, 0dh, 0ah, "Result: $"
    power_message db 0dh, 0ah, "To find X^Y enter first number as X and second number as Y", 0dh, 0ah, '$'
    factorial_message db 0dh, 0ah, "Enter a number to find its factorial: $"
    thanks db 0dh, 0ah, 0dh, 0ah, "Thank you for using the calculator.", 0dh, 0ah, '$'
    again db 0dh, 0ah, 0dh, 0ah, "Press any key to calculate again...$"
.code

main proc
    
    mov ax, @data
    mov ds, ax
    
    jmp start
    start:
    call menu
    mov ah, 9
    lea dx, choice
    int 21h
    mov ah, 1
    int 21h
    sub al, 30h
    cmp al, 1
    je addition
    cmp al, 2
    je subtraction
    cmp al, 3
    je multiplication
    cmp al, 4
    je division
    cmp al, 5
    je power
    cmp al, 6
    je factorial
    cmp al, 7
    je exit
    mov ah, 9
    lea dx, wrong_input
    int 21h
    jmp end
    
    exit:
    mov ah, 9
    lea dx, thanks
    int 21h
    
    mov ah, 4ch
    int 21h
    main endp

end:
    mov ah, 9
    lea dx, again
    int 21h
    mov ah, 0
    int 16h
    mov number1, 0
    mov number2, 0
    mov fact, 1
    xor ax, ax   ;
    mov ah, 0    ; for clear screen after each complete operation
    int 10h      ; remove these line to view previous calculation
    jmp start

addition:
    
    mov ah, 9
    lea dx, option1
    int 21h
    call input
    mov ax, number1
    add ax, number2
    mov answer, ax
    call output
    jmp end
    
subtraction:
    mov ah, 9
    lea dx, option2
    int 21h
    call input
    call compare
    mov ax, number1
    sub ax, number2
    mov answer, ax
    call output
    jmp end
    
multiplication:
    mov ah, 9
    lea dx, option3
    int 21h
    call input
    mov ax, number1
    mov bx, number2
    mul bx
    mov answer, ax
    call output
    jmp end
    
division:
    mov ah, 9
    lea dx, option4
    int 21h
    call input
    call compare
    mov ax, number1
    mov bx, number2
    mov dx, 0
    div bx
    mov answer, ax
    call output
    jmp end
    
power:
    mov ah, 9
    lea dx, option5
    int 21h
    lea dx, power_message
    int 21h
    call input
    mov ax, number1
    mov bx, number1
    mov cx, number2
    mov i, 0
    for8:
    add i, 1
    cmp i, cx
    je exit7
    mul bx
    jmp for8
    exit7:
    mov answer, ax
    call output
    jmp end
    
factorial:
    mov ah, 9
    lea dx, option6
    int 21h
    lea dx, factorial_message
    int 21h
    mov ah, 1
    int 21h
    sub al, 30h
    mov ah, 0
    cmp ax, 0
    je jump
    mov cx, ax
    mov i, 1
    for12:
    cmp i, cx
    jg exit8
    mov ax, fact
    mov bx, i
    mul bx
    mov fact, ax
    add i, 1
    jmp for12
    exit8:
    mov answer, ax
    call output
    jmp end
    
    jump:
    mov answer, 1
    call output
    jmp end

menu proc
    
    mov ah, 9
    lea dx, menu_message
    int 21h
    mov ah, 2
    mov dx, 0dh
    int 21h
    mov dx, 0ah
    int 21h
    
    ret
    menu endp

input proc
    
    mov ah, 9
    lea dx, input1
    int 21h
    mov cx, 0
    for:
    mov ah, 1
    int 21h
    mov ah, 0
    cmp al, 0dh
    je num1
    sub ax, 30h
    push ax
    inc cx
    jmp for
    
    num1:
    mov bx, 10
    mov i, 0
    for1:
    cmp i, cx
    je exit1
    pop ax
    mov j, 0
    for2:
        mov dx, i
        cmp j, dx
        je exit2
        mul bx
        add j, 1
        jmp for2
    exit2:
    add number1, ax
    add i, 1
    jmp for1
    exit1:
    
    mov ah, 9
    lea dx, input2
    int 21h
    mov cx, 0
    for3:
    mov ah, 1
    int 21h
    mov ah, 0
    cmp al, 0dh
    je num2
    sub ax, 30h
    push ax
    inc cx
    jmp for3
    
    num2:
    mov bx, 10
    mov i, 0
    for4:
    cmp i, cx
    je exit3
    pop ax
    mov j, 0
    for5:
        mov dx, i
        cmp j, dx
        je exit4
        mul bx
        add j, 1
        jmp for5
    exit4:
    add number2, ax
    add i, 1
    jmp for4
    exit3:  
    
    ret
    input endp

output proc
    
    mov ah, 9
    lea dx, result
    int 21h
    mov cx, 0
    mov bx, 10
    mov ax, answer
    for6:
    cmp cx, 5
    je exit5
    mov dx, 0
    div bx
    push dx
    inc cx
    jmp for6
    exit5:
    mov cx, 0
    for7:
    cmp cx, 5
    je exit6
    mov ah, 2
    pop dx
    add dx, 30h
    int 21h
    inc cx
    jmp for7
    exit6:
    
    ret
    output endp

compare proc
    
    mov cx, number1
    mov dx, number2
    cmp cx, number2
    jge skip
    mov number2, cx
    mov number1, dx
    skip:
    
    ret
    compare endp
           
end main


    
