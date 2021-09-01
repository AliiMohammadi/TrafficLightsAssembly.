include 'emu8086.inc'
;8086 Microprocessor. Traffic lights with sensor program.
org 100h  
    
    NorthVehicleCount dw 4
    SouthVehicleCount dw 2
    WestVehicleCount dw 1
    EastVehicleCount dw 0
    
    TLsStandardTime dw 60;s
    UpAndDownGreentime dw TLsStandardTime 
    LeftAndRightGreenTime dw TLsStandardTime 
    YellowLightsTime dw 5;s  
    
    UpDownFreeValue dw 2640h
    LeftRightFreeValue dw 9090h 
    YellowValue dw 4920h 
    
    ;Infinit loop 
    Main:   
        UpAndDownTime dw TLsStandardTime
        LeftAndRightTime dw TLsStandardTime
        
        call SetAutomaticLTTime
        
        call AllYellow
        
        print 'Up and down green.'
        mov AX,2640h
        call SetOperatorLights
        move CX,UdAndDownGreentime
        call WaitForsecond 
        
        call AllYellow
         
        print 'left and right green.'
        mov AX,9090h
        call SetOperatorLights
        move CX,LeftAndRightGreenTime
        call WaitForsecond
            
        SetAutomaticLTTime:
        
            jmp CalCulateTime
            
            CalCulateTime:
                DivNum dw 1
                finalTime dw TLsStandardTime
                SumUpAndDown dw NorthVehicleCount
                SumLeftAndRight dw WestVehicleCount
                
                add  SumUpAndDown, SouthVehicleCount
                div 2
                add  SumLeftAndRight,EastVehicleCount
                div 2
                
                cmp SumUpAndDown,SumLeftAndRight
                jg UpOne
                jmp LeftOne
                
                LeftOne:
                    mov DivNum,SumLeftAndRight
                    div finalTime
                    mov UpAndDownGreentime,DivNum
                    add -DivNum,60
                    mov  LeftAndRightGreenTime,DivNum    
                UpOne:
                    mov DivNum,SumUpAndDown
                    div finalTime
                    mov LeftAndRightGreenTime,DivNum
                    add -DivNum,60
                    mov  UpAndDownGreentime,DivNum 
                
        ret 
        ;This label will turn the main light on trafic lights on red and green 
        SetOperatorLights:
            out 5,AX  
        ret
            
        ;This label will turn all yellow lights on
        AllYellow:
            print 'yellow all.'
            mov AX,4920h
            out 5,AX
            mov CX,YellowLightsTime 
            call WaitForsecond
        ret    
             
        ;This label will delay with CX value in second
        WaitForsecond:
            mov BH,1000
            mul CX
             
            call Delay
            Delay:
                nop
                dec BH
                jnz Delay
            ret
        ret               
    jmp Main
    
ret