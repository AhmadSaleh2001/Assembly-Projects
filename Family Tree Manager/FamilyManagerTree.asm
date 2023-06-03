INCLUDE irvine32.inc


.stack 4096
.data

Buffer BYTE 20 DUP(?)
NameSize = ($ - Buffer)
Names BYTE 101 DUP(20 DUP(?))
EnterName BYTE 'Enter Name : ' , 0
EnterID BYTE 'Enter ID : ' , 0
EnterParentID BYTE 'Enter Parent ID : ' , 0
Graph BYTE 101 DUP (-1)
EmptyString BYTE ' => ' , 0
List BYTE '1 - Set Parent' , 0ah , 0dh , '2 - Track Path For User' , 0ah , 0dh , '3 - Print All Tree' , 0ah , 0dh , '4 - Exit' , 0ah , 0dh , 'Your Choice : ' , 0
Separator BYTE '---------------------' , 0ah , 0dh , 0
Space BYTE ' ' , 0
Matrix BYTE 101 DUP (101 DUP (0))

ForIDLeft BYTE '(' , 0
ForIDRight BYTE ')' , 0


Temp DWORD ?
.code

printPath proc
    
    cmp al,0
    jne Continue
    ret

    Continue:
    pushad
    
    mov al , [Graph + eax]
    call PrintPath
    popad
       
    mov ebx,eax
    IMUL ebx,20

    lea edx , [Names + ebx]
    call WriteString

    lea edx , EmptyString
    call WriteString
    

    ret
printPath endp
    

printList proc
    
    lea edx , Separator
    call WriteString

    lea edx , List
    call WriteString
    call ReadDec
    

    ret
printList endp


HandleTrackPath proc
     
     lea edx , EnterID
     call WriteString
     call ReadDec

     call printPath
     call CRLF

    ret
HandleTrackPath endp

SetChild proc

   pushad
   IMUL eax,101
   add eax,ebx
   mov [Matrix + eax] , 1


   popad

   ret
SetChild endp


PrintID proc
    pushad
    lea edx,ForIDLeft
    call WriteString
    
    call WriteDec

    lea edx,ForIDRight
    call WriteString



    popad
    ret
PrintID endp

PrintCurrTree proc
    pushad
    
    inc ebx


    call PrintID
   
    mov Temp , eax
    IMUL eax,20

    lea edx , [Names + eax]
    call WriteString
    
    mov eax,Temp
    IMUL eax,101
    mov ecx,101
    lea esi,[Matrix + eax]

    L1:
       mov eax,0
       mov al,[esi]
       cmp al,1
       jne Continue

       mov Temp , ecx
       mov ecx , ebx
       call CRLF
       L2:
           lea edx,Space
           call WriteString

           lea edx,Space
           call WriteString
       loop L2

       

       mov ecx,Temp
       

       mov eax,101
       sub eax,ecx
       call PrintCurrTree



       Continue:
       inc esi
    loop L1


    popad
    ret
PrintCurrTree endp

PrintTree proc

    pushad
    
    lea esi , Graph
    mov ecx,101

    L1:
      mov eax,0
      mov al,[esi]
      cmp al ,  0
      jne Continue
      

      mov ebx,0
      mov eax,101
      sub eax,ecx

      
      call PrintCurrTree
      call CRLF
      call CRLF

      Continue:
      inc esi
    loop L1
    popad
    ret
PrintTree endp

main proc
    
    mov eax,0
    mov ebx , 0
    mov ecx,3
    
    lea edi , Names

    Running : 
        call printList
        cmp eax,1
        je HandleSetParent
        

        cmp eax,2
        je HandleTrackPathMain

        cmp eax,3
        je HandlePrintAllArray

        

        jmp Continue

        HandleSetParent:
            lea edx , EnterID;
            call WriteString
            call readDec
            mov ebx , eax

            lea edx,EnterName
            call WriteString

            lea edx,Buffer
            mov ecx , NameSize
            call ReadString

            mov Temp , ebx

            IMUL ebx , 20
            lea edi,Names
            add edi , ebx

            mov ebx , Temp


            lea esi,Buffer
            mov ecx,NameSize
            rep movsb
            


            lea edx , EnterParentID;
            call WriteString
            call readDec
        
            lea esi , Graph
            mov [esi + ebx] , al
            
            call SetChild


            jmp Continue


        HandleTrackPathMain:
           call HandleTrackPath
           jmp Continue

        HandlePrintAllArray:
         call PrintTree

        Continue : 
        cmp eax,4
        jne Running
        

    
    exit 
main endp
end main