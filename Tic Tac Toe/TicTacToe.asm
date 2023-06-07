INCLUDE irvine32.inc

.stack 4096
.data

Grid BYTE 9 DUP (0)
Sz = $ - Grid
NewLine BYTE 0ah,0dh , 0
PlayerChoice BYTE 'Player Number ' , 0
EndOfOutput BYTE ' : ' , 0
Who BYTE 2
FoundWinner BYTE 0
Winner BYTE 'Player ' , 0
EndWinner BYTE ' Winner' , 0
OldCounter BYTE 0

Draw BYTE 'Draw !!!' , 0
.code


CheckForNewLine proc
       
    cmp dl,3
    jne MyExit

    lea edx,NewLine
    call WriteString
    mov edx,0

    MyExit:
    ret
CheckForNewLine endp

PrintGrid proc
    

    mov eax,0
    lea esi,Grid
    mov ecx,Sz
    mov edx,0
    L1:
        mov al,[esi]
        cmp al,1
        je AddX

        cmp al,2
        je AddO

        mov al,'.'
        jmp Continue

        AddX:
        mov al,'X'
        jmp Continue

        AddO:
        mov al,'O'
        jmp Continue


        Continue:
        call WriteChar

        mov al,' '
        call WriteChar

        inc dl
        call CheckForNewLine


        
        
        inc esi

    loop L1

    ret
PrintGrid endp

CheckForEachRow proc
    

    mov eax,0
    mov ebx,0
    mov ecx,0
    lea esi,Grid
    mov cl , 3
    
    mov bl,[esi]
    


    L1:

       mov OldCounter , cl
       mov bl,[esi]

       cmp bl,0
       je Continue

       


       mov edx,esi
       mov ecx,3
       L2:
        cmp [edx] , bl
        jne Continue

        inc edx
       loop L2

       mov FoundWinner , 1
       ret

       Continue:

       mov cl,OldCounter
       add esi,3
    loop L1

    ret
CheckForEachRow endp


CheckForEachColumn proc
    mov eax,0
    mov ebx,0
    lea esi,Grid
    mov ecx , 3
    


    L1:
       
       mov OldCounter , cl
       mov bl,[esi]
       cmp bl,0
       je Continue


       mov edx,esi
       mov ecx,3
       L2:
        cmp [edx] , bl
        jne Continue

        add edx,3
       loop L2

       mov FoundWinner , 1
       ret

       Continue:

       mov cl,OldCounter
       inc esi
    loop L1

    ret

CheckForEachColumn endp


CheckForFirstDiagonal proc
    
    lea esi,Grid
    mov ecx,3


    mov ebx,0
    mov bl,[esi]
    cmp bl,0
    je CurrExit

    L1:
        cmp bl,[esi]
        jne CurrExit
        add esi,4
    loop L1

    
    mov FoundWinner , 1

    CurrExit:
    ret
CheckForFirstDiagonal endp


CheckForSecondDiagonal proc

    lea esi,[Grid + 2]
    mov ecx,3


    mov ebx,0
    mov bl,[esi]
    cmp bl,0
    je CurrExit

    L1:
        cmp bl,[esi]
        jne CurrExit
        add esi,2
    loop L1

    
    mov FoundWinner , 1

    CurrExit:

    ret
CheckForSecondDiagonal endp

CheckIfEnd proc
    
    pushad
    call CheckForEachRow
    popad

    pushad
    call CheckForEachColumn
    popad

    pushad
    call CheckForFirstDiagonal
    popad


    pushad
    call CheckForSecondDiagonal
    popad


    ret
CheckIfEnd endp

main proc
    
    mov eax,0
    mov ebx,0
    mov ecx,Sz

    L1:
        XOR Who , 3
       

        pushad
        call PrintGrid
        popad

        lea edx,NewLine
        call WriteString

        lea edx,PlayerChoice
        call WriteString

        mov eax,0
        mov al,Who
        call WriteInt

        lea edx,EndOfOutput
        call WriteString
        call ReadDec
        dec eax
        
        mov bl,al
        mov al,Who
        mov [Grid + ebx] , al
        
        pushad
        call CheckIfEnd
        popad

        cmp FoundWinner , 1
        je ExitFoundWinner

    loop L1


    jmp ExitNoWinner

    ExitFoundWinner:
    lea edx,Winner
    call WriteString

    mov eax,0
    mov al,Who
    call WriteInt

    lea edx,EndWinner
    call WriteString

    jmp MyExit


    ExitNoWinner:
    lea edx,Draw
    call WriteString


    MyExit:

    exit 
main endp
end main