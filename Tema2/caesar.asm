%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;reduce cheia la valoarea care ii corespunde in intervalul [0, 25]
    xor edx, edx
    mov eax, edi
    mov ebx, 26
    div ebx
    mov edi, edx
    mov edx, [ebp + 8]
    jmp cipher

lowercase:
    cmp al, 'z'  ; verifica daca este litera
    jg write_letter  ; scrie caracterul in cazul in care nu este litera
    sub eax, 26  ; scade 26 pentru a nu depasi valoarea lui 'z'
    add eax, edi  ; adauga valoarea cheii
    cmp al, 'a'
    jge write_letter  ; scrie litera
    ; adauga 26, in cazul in care cheia e mai mica decat distanta pana la 'z' 
    add al, 26
    jmp write_letter

uppercase:
    cmp al, 'A'
    jl write_letter
    add eax, edi
    cmp al, 'Z'
    jle write_letter
    sub al, 26
    jmp write_letter

    ; parcurge stringul de la sfarsit catre inceput
cipher:
    cmp ecx, 0  ; verifica daca s-a ajuns la final
    je end
    mov al, [esi + ecx - 1]  ; se copiaza fiecare litera
    cmp al, 'Z'  ; verifica daca este litera mare
    jle uppercase
    cmp al, 'a'  ; verifica daca este litera mica
    jge lowercase

write_letter:
    mov byte[edx + ecx - 1], al  ; scrie litera in noul string
    dec ecx
    jmp cipher

end:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY