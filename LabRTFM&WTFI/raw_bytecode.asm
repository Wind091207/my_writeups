PUBLIC asm_scratchpad

.code
asm_scratchpad PROC
    ;code goes here
    db 0B8h, 0DDh, 0CCh, 0BBh, 0AAh
    db 9Eh
    db 74h, 5h
    db 25h, 37h, 13h, 03h, 00h
    db 0C3h
asm_scratchpad ENDP
end
