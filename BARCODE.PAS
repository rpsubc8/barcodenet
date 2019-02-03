{USES Graph,Crt;}
USES Crt;
(* 0 una posicion, 1 2 posiciones *)
CONST
 codeX:array[0..8] of byte=(0,1,0,0,1,0,1,0,0);
 textX='Þ ÝÛÞÝÝ';{en negativo de color}
 codeF:array[0..8] of byte=(0,0,1,0,1,1,0,0,0);
 textF='ÞÞÝÛ ÝÝ';
 codeE:array[0..8] of byte=(1,0,0,0,1,1,0,0,0);
 codeD:array[0..8] of byte=(0,0,0,0,1,1,0,0,1);
 codeC:array[0..8] of byte=(1,0,1,0,0,1,0,0,0);
 codeB:array[0..8] of byte=(0,0,1,0,0,1,0,0,1);
 codeA:array[0..8] of byte=(1,0,0,0,0,1,0,0,1);
 code9:array[0..8] of byte=(0,0,1,1,0,0,1,0,0);
 code8:array[0..8] of byte=(1,0,0,1,0,0,1,0,0);
 code7:array[0..8] of byte=(0,0,0,1,0,0,1,0,1);
 code6:array[0..8] of byte=(0,0,1,1,1,0,0,0,0);
 code5:array[0..8] of byte=(1,0,0,1,1,0,0,0,0);
 code4:array[0..8] of byte=(0,0,0,1,1,0,0,0,1);
 code3:array[0..8] of byte=(1,0,1,1,0,0,0,0,0);
 code2:array[0..8] of byte=(0,0,1,1,0,0,0,0,1);
 code1:array[0..8] of byte=(1,0,0,1,0,0,0,0,1);
 code0:array[0..8] of byte=(0,0,0,1,1,0,1,0,0);
TYPE
 SCRarray=ARRAY[0..319,0..199] OF byte;
 PTRArray=^SCRarray;
VAR
 grDriver,grMode, ErrCode:integer;
 c:CHAR;
 globalPosx: integer;
 globalPOSY: integer;
 globalCad: string;
 Pantalla: PTRarray;
 volcado:ARRAY[1..64000]OF BYTE ABSOLUTE $A000:0000;
 x,y:INTEGER;
 globalGFXcolor:integer;
PROCEDURE Retrazo; NEAR; ASSEMBLER;
ASM
 MOV DX,3DAh
 @bucle1: IN AL,DX; AND AL,8; MOV AH,8; XOR AH,AL;
          JZ @bucle1
 @bucle2: IN AL,DX; AND AL,8; MOV AH,0; XOR AH,AL;
          JZ @bucle2
END;
{---------------------------------------------------------------------------}
PROCEDURE Setmode13h; NEAR; ASSEMBLER;
ASM MOV AX,13h; INT 10h END;
{---------------------------------------------------------------------------}
PROCEDURE cls(scr: ptrarray); NEAR; ASSEMBLER;
ASM LES di,scr; XOR ax,ax; MOV cx,32000; REP stosw END;
{---------------------------------------------------------------------------}
PROCEDURE DibujaTextCODE39(c:STRING);
VAR i:integer;
BEGIN
 FOR i:=0 TO 4 DO
  BEGIN gotoxy(globalPosX,globalPOSY+i);WRITE(c);END;
 globalPosX:=globalPosX+length(c);
END;
{---------------------------------------------------------------------------}
PROCEDURE LineGFX(x,y,h:word);
VAR i:word;
BEGIN
 FOR i:=0 TO h DO
  MEM[$A000:(((y+i) shl 8)+((i+h) shl 6)+x)]:=globalGFXcolor;
END;
{---------------------------------------------------------------------------}
PROCEDURE SetGFXcolor(c:byte);
BEGIN globalGFXcolor:=c; END;
{---------------------------------------------------------------------------}
PROCEDURE DibujaGFXCODE39(c:array of byte);
VAR i:integer;contColor:integer;
BEGIN
 contColor:=0;
 FOR i:=0 TO 8 DO
  BEGIN
   SetGFXcolor(contColor);
   contColor:=contColor+15;
   if (contColor>20) then
    begin
     contColor:=0;
    end;
   if (c[i]=0) then
    begin
     LineGFX(globalposx,globalPosY,50);
    end
   else
    begin
     LineGFX(globalposx,globalPosY,50);
     globalposx:=globalposx+1;
     LineGFX(globalposx,globalPosY,50);
    end;
   globalposx:=globalposx+1;
  END;
  SetGFXcolor(15);
  LineGFX(globalposx,globalPosY,50);
  globalposx:=globalposx+1;
END;
{---------------------------------------------------------------------------}
(*BGI PROCEDURE DibujaCODE39(c:array of byte);
VAR i:integer;contColor:byte;
BEGIN
 contColor:=0;
 FOR i:=0 TO 8 DO
  BEGIN
   setcolor(contColor);
   contColor:=contColor+15;
   if (contColor>20) then
    begin
     contColor:=0;
    end;
   if (c[i]=0) then
    begin
     Line(globalposx,globalPOSY,globalposx,globalPOSY+50);
    end
   else
    begin
     Line(globalposx,globalPOSY,globalposx,globalPOSY+50);
     globalposx:=globalposx+1;
     Line(globalposx,globalPOSY,globalposx,globalPOSY+50);
    end;
   globalposx:=globalposx+1;
  END;
  setcolor(15);
  Line(globalposx,globalPOSY,globalposx,globalPOSY+50);
  globalposx:=globalposx+1;
END;*)
{---------------------------------------------------------------------------}
PROCEDURE EscribeCODE39(c:char;modoGFX:boolean);
BEGIN
 IF modoGFX=true THEN
  BEGIN
   CASE c of
    '*':DibujaGFXCODE39(codeX);
    'F':DibujaGFXCODE39(codeF);
    'E':DibujaGFXCODE39(codeE);
    'D':DibujaGFXCODE39(codeD);
    'C':DibujaGFXCODE39(codeC);
    'B':DibujaGFXCODE39(codeB);
    'A':DibujaGFXCODE39(codeA);
    '9':DibujaGFXCODE39(code9);
    '8':DibujaGFXCODE39(code8);
    '7':DibujaGFXCODE39(code7);
    '6':DibujaGFXCODE39(code6);
    '5':DibujaGFXCODE39(code5);
    '4':DibujaGFXCODE39(code4);
    '3':DibujaGFXCODE39(code3);
    '2':DibujaGFXCODE39(code2);
    '1':DibujaGFXCODE39(code1);
    '0':DibujaGFXCODE39(code0);
   END;
  END
 ELSE
  BEGIN
   CASE c OF
    '*':DibujaTEXTCODE39(textX);
    'F':DibujaTEXTCODE39(textF);
   END;
  END;
END;
{---------------------------------------------------------------------------}
PROCEDURE EscribeCadena39(cad:string;modoGFX:boolean);
VAR i:integer;
BEGIN
 FOR i:=1 TO length(cad) DO
  BEGIN EscribeCODE39(cad[i],modoGFX); END;
END;

{---------------------------------------------------------------------------}
BEGIN
 globalPosX:=100;
 globalPosY:=30;
(* grDriver := Detect;*)
(* grDriver:=CGAHI;
 InitGraph(grDriver, grMode,'c:\tp\bgi\cga.bgi');
 ErrCode := GraphResult;
 if ErrCode = grOk then
 begin                   { Hacer gr ficos }
   {Line(0, 0, GetMaxX, GetMaxY);}
   setCOLOR(15);
   RECTANGLE(0,0,630,190);
   floodfill(1,1,15);
   {LINE(0,190,630,190);}
   c:='*';
   globalCad:='*0123456789ABCDEF*';
   EscribeCadena39(globalCad);
   Readln;
   CloseGraph;
 end
 else
   Writeln('Error gr fico:', GraphErrorMsg(ErrCode));

*)
 TEXTBACKGROUND(7);
 clrscr;
{ TEXTBACKGROUND(0);}
 TEXTCOLOR(0);
 globalPOSX:=6;
 GLOBALposy:=4;
 EscribeCadena39('*FFFFFFFF*',false);
 readln;
 Setmode13h;
 FOR x:=0 TO 318 DO
  FOR y:=198 DOWNTO 1 DO
   MEM[$A000:((y shl 8)+(y shl 6)+x)]:=15;
 {MEM[$A000:((y shl 8)+(y shl 6)+x)]:=pantalla^[x,y];}

 globalGFXcolor:=0;
 globalPosX:=40;
 globalPosY:=30;
 EscribeCadena39('*0123456789ABCDEF*',true);
 readln;
 ASM MOV AX,3h; INT 10h END;
END.
