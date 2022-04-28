%include "io.mac"

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

    inc dword[edi]
    jmp search 

found:
    mov dword[edi], 0; cand se gaseste substringul, indexul devine 0

reset:
    mov edx, [ebp + 24]
    dec ecx

search:
    cmp ecx, 0  ; verifica daca s-a ajuns la sfarsitul frazei
    je end
    inc dword[edi]  ; deoarece se parcurge in sens invers, indexul 
                    ; substringului creste de fiecare data
    mov al, [esi + ecx - 1]
    cmp al, byte[ebx + edx - 1]  ; se compara caracterele din stringuri
    jne reset  ; cand se intalneste primul caracter diferit
               ; indexul substringului se reseteaza pentru a reveni la inceput
    dec edx
    cmp edx, 0
    je found
    dec ecx
    jmp search

end:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
