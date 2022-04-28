%include "io.mac"

section .text
    global vigenere
    extern printf

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 20]     ; key
    ;; DO NOT MODIFY
    
    mov ecx, 0
    mov ebx, 0
    jmp cipher

 lowercase:
    cmp al, 'z'  ; verifica daca este litera si o scrie daca nu este
    jg write_letter
    sub eax, 26   ; scade 26 pentru a nu depasi valoarea lui 'z'
    add eax, [edi + ebx]  ; adauga valoarea cheii
    inc ebx
    sub eax, 'A' ; scade valoarea primei litere din alfabet
    cmp al, 'a'
    jge write_letter
    ; adauga 26, in cazul in care cheia e mai mica decat distanta pana la 'z' 
    add al, 26
    jmp write_letter

uppercase:
    cmp al, 'A'  ; verifica daca este litera si o scrie daca nu este
    jl write_letter
    add eax, [edi + ebx]  ; adauga valoarea cheii
    inc ebx
    sub eax, 'A'  ; scade valoarea primei litere din alfabet
    cmp al, 'Z'
    jle write_letter
    sub al, 26  ; scade 26 in cazul in care s-a depasit valoarea literelor mari
    jmp write_letter

;parcurge fraza si cheia de la inceput catre sfarsit
cipher:
    cmp ebx, [ebp + 24]  ; verifica daca s-a ajuns la sfarsitul cheii
    je reset_key
    cmp ecx, [ebp + 16]  ; verifica daca s-a ajuns la sfarsitul frazei
    je end
    mov al, [esi + ecx]  ; ia fiecare caracter din fraza
    cmp al, 'Z'  ; verifica daca este litera mare sau litera mica
    jle uppercase
    cmp al, 'a'
    jge lowercase

write_letter:
    mov byte[edx + ecx], al  ; scrie litera noua in fraza
    inc ecx
    jmp cipher

reset_key:
    mov ebx, 0  ; reface indexul din cheie
    jmp cipher

end:
    ;mov edx, [ebp + 8]
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY