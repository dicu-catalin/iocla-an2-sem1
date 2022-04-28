%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

xor:
    ; parcurge sirul de la sfarsit spre inceput
    mov al, [esi + ecx - 1]  ; copiaza litera cu litera din textul initial 
    mov bl, [edi + ecx - 1]  ; copiaza litera cu litera din cheie
    xor al, bl  ; xor intre cele doua litere
    mov byte[edx + ecx - 1], al  ; muta rezultatul din xor in noul string
    loop xor

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY