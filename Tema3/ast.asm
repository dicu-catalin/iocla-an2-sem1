section .data
    delim db " ", 0
   	node_memory db 12
    null db 0x00

section .bss
    root resd 1

section .text

extern printf
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
    ; pastrez valoarea lui esi, registru pe care urmeaza sa-l modific
    push esi
    ; pastrez stringul(numarul ca sir de caractere) in esi
    mov esi, [esp + 12]
    xor ecx, ecx
    xor ebx, ebx
    xor eax, eax
    ; verific daca numarul este negativ
    cmp byte[esi], '-'
    jne make_number
    ; daca este negativ sar caracterul "-"
    inc ecx

make_number:
    ; iau fiecare caracter si il transform in cifra
    mov bl, byte[esi + ecx]
    sub ebx, '0'
    mov edx, 10
    ; inmultesc eax cu 10 inainte sa adaug o noua cifra
    mul edx
    add eax, ebx
    inc ecx
    ; verific daca sirul de caractere s-a terminat
    cmp byte[esi + ecx], 0x00
    jne make_number
    ; daca primul caracter este "-", inmultesc numarul obtinut cu -1
    cmp byte[esi], '-'
    jne positive_number
    mov edx, -1
    mul edx

positive_number:
    pop esi
    leave
    ret



create_tree:
    enter 0, 0
    pushad
    ; am mutat stringul initial in ebx
    mov ebx, [ebp + 8]  

    push dword[node_memory]
    ; aloc radacina si o pun in esi
    call malloc  
    add esp, 4
    mov esi, eax
    ; iau prima valoare din input si o pun in nodul radacina
    push delim
    push ebx
    call strtok
    add esp, 8
    push eax
    call strdup
    add esp, 4
    mov [esi], eax
    mov dword[esi + 4], 0x00
    mov dword[esi + 8], 0x00
    mov [root], esi
    ; pun pe stiva nodul radacina deoarece contine semn si nu este terminat
    push esi  


next_node:
    ; aflu urmatoarul element din string
    push delim  
    push dword[null]
    call strtok
    add esp, 8

    ; daca elementul din string este "null", programul se termina
    cmp eax, dword[null]  
    je end

    ; construiesc urmatorul nod
    push eax
    call strdup
    add esp, 4
    push eax
    push dword[node_memory]
    call malloc
    add esp, 4
    pop dword[eax]
    mov ecx, dword[eax]

    ; verific daca elementul este cifra sau semn
    cmp byte[ecx], '0'  
    jge number

    ; daca numarul este negativ, primul bit e "-" si mai verific o data 
    cmp byte[ecx + 1], '0'  
    jge number

    ; iau de pe stiva ultimul nod neterminat(nu are fiu stanga/dreapta)
    pop esi
    mov dword[eax + 4], 0x00
    mov dword[eax + 8], 0x00

    ; verific daca are fiu stanga, iar daca nu are pun nodul curent ca fiu stanga 
    cmp dword[esi + 4], 0x00
    jne right_sign
    mov [esi + 4], eax

    ; pun pe stiva nodul anterior(nu are fiu dreapta deci nu e terminat) si 
    ; nodul curent, care nu are niciun fiu
    push esi
    push eax
    jmp next_node


right_sign:
    ; daca nu are fiu dreapta, pun nodul curent ca fiu dreapta
    mov dword[eax + 4], 0x00
    mov dword[eax + 8], 0x00
    mov [esi + 8], eax

    ; pun pe stiva doar nodul curent, deoarece cel anterior s-a termiant
    push eax
    jmp next_node


number:
    pop esi

    ; daca nu are fiu stanga pun nodul curent ca fiu stanga
    cmp dword[esi + 4], 0x00
    jne right_number
    mov [esi + 4], eax

    ; pun pe stiva nodul anterior, deoarece acesta nu s-a terminat, iar nodul
    ; curent nu este pus pe stiva, deoarece nodurile cifre nu pot avea fii
    push esi
    jmp next_node


right_number:
    ; pun nodul curent ca fiu dreapta, fara sa mai pun ceva pe stiva  
    mov [esi + 8], eax
    jmp next_node


end:
    ; refac registrele si pun radacina in eax
    popad
    mov eax, [root]

    leave
    ret