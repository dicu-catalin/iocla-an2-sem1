%include "io.mac"

section .data
    len_hexa dw 0

section .text
    global bin_to_hex
    extern printf


bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     esi, [ebp + 12]     ; bin_sequence
    mov     edi, [ebp + 16]     ; length
    ;; DO NOT MODIFY

; calculeaza cate secvente de 4 biti sunt in input
    xor edx, edx
    xor ebx, ebx

    mov eax, edi
    mov ecx, 4
    div ecx
    mov dword[len_hexa], eax
    mov eax, edx
    xor edx, edx
    mov edx, [ebp + 8]
    cmp eax, 0
    je end_line

set_len_hexa:
    inc dword[len_hexa]  ; aduna 1 in cazul in care nu este divizibil cu 4

end_line:
    mov ecx, [len_hexa]
    mov byte[edx + ecx], 10  ; adauga \n la finalul stringului in baza 16
    mov byte[edx + ecx + 1], 0  ; adauga \0
    xor ecx, ecx

transform:
    dec edi
    cmp dword[len_hexa], 0  ; verifica daca numarul in binar s-a termiant
    je end
    mov al, byte[esi + edi]  ; parcurge numarul in binar de la sfarsit
    sub eax, '0'  ; transforma bitul in numar 
    shl al, cl  ; face shift la stanga cu numarul de biti corespunzatori
    add ebx, eax  ; adauga valoarea la suma de 4 biti
    cmp edi, 0  ; verifica daca secventa de 4 biti s-a terminat
    je add_to_hexa  ; adauga valoarea in hexa
    inc cl
    cmp cl, 4
    je add_to_hexa
    jmp transform

add_number:
    add ebx, '0'  ; transforma valoarea in ascii
    mov ecx, [len_hexa]
    mov byte[edx + ecx - 1], bl  ; adauga valoarea in noul string
    dec dword[len_hexa]
    mov ecx, 0
    xor ebx, ebx
    jmp transform

add_to_hexa:
    cmp ebx, 10  ; verifica daca valoarea in hexa este litera sau cifra
    jl add_number
    sub ebx, 10
    add ebx, 'A'  ; transforma valoarea in litera corespunzatoare
    mov ecx, [len_hexa]
    mov byte[edx + ecx - 1], bl  ; adauga litera
    mov ecx, 0
    dec dword[len_hexa]
    xor ebx, ebx
    jmp transform

end:

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY



push delim
    push ebx
    call strtok
    PRINTF32 `%s\n\x0`, eax
    push delim
    mov eax, `\0`
    push eax
    call strtok
    PRINTF32 `%s\n\x0`, eax




    %include "utils/printf32.asm"
section .data
    delim db " ", 0
    node_memory db 12
    null db `\0`

section .bss
    root resd 1

section .text

extern strcpy
extern printf
extern atoi
extern strtok
extern strdup
extern malloc
extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree

global create_tree
global iocla_atoi

iocla_atoi:
    push ebp
    mov ebp, esp
    push edi
    push edx
    push ebx
    push ecx
    push esi
    mov edx, [esp + 28]
    push edx
    call atoi
    ; TODO
    add esp, 4
    pop esi
    pop ecx
    pop ebx
    pop edx
    pop edi
    leave
    ret


create_tree:
    enter 0, 0
    pushad
    mov ebx, [ebp + 8]
    push dword[node_memory]
    call malloc
    mov [root], eax  ;primul nod
    add esp, 4
    push delim
    push ebx
    call strtok
    add esp, 8
    push eax
    push dword[root]
    call strcpy
    ;mov [root], eax
    add esp, 8
    ;xor eax, eax

    push dword[node_memory]  ; nodul dreapta
    call malloc
    add esp, 4
    mov dword[eax + 4], '\0'
    mov dword[eax + 8], '\0'
    push eax
    push delim
    push dword[null]
    call strtok
    add esp, 8
    pop edx
    push eax
    push dword[edx]
    call strcpy
    add esp, 8
    ;pop edx
    ;mov [edx], eax
    mov [root + 4], edx

    push dword[node_memory]  ; nodul stanga
    call malloc
    add esp, 4
    mov dword[eax + 4], '\0'
    mov dword[eax + 8], '\0'
    push eax
    push delim
    push dword[null]
    call strtok
    add esp, 8
    pop edx
    push eax
    push dword[edx]
    call strcpy
    add esp, 8
    ;pop edx
    ;mov [edx], eax
    mov [root + 8], edx
    ;push root
    ;call print_tree_preorder
    ;call evaluate_tree
    popad
    mov eax, root
    leave
    ret






    mov ebx, [ebp + 8]
    push dword[node_memory]
    call malloc
    mov esi, eax  ;primul nod
    add esp, 4
    push delim
    push ebx
    call strtok
    add esp, 8
    push eax
    call strdup
    mov [esi], eax
    add esp, 4
    ;xor eax, eax

    push dword[node_memory]  ; nodul dreapta
    call malloc
    add esp, 4
    mov dword[eax + 4], 0x00
    mov dword[eax + 8], 0x00 
    push eax
    push delim
    push dword[null]
    call strtok
    add esp, 8
    push eax
    call strdup
    add esp, 4
    pop edx 
    mov [edx], eax
    mov [esi + 4], edx

    push dword[node_memory]  ; nodul stanga
    call malloc
    mov dword[eax + 4], 0x00
    mov dword[eax + 8], 0x00 
    add esp, 4
    push eax
    push delim
    push dword[null]
    call strtok
    add esp, 8
    push eax
    call strdup
    add esp, 4
    pop edx
    mov [edx], eax
    mov [esi + 8], edx
    ;push root
    ;call print_tree_preorder
    ;call evaluate_tree
    mov [root], esi
    popad
    mov eax, [root]