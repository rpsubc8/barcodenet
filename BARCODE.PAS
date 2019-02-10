{USES Graph,Crt;}
USES Crt;
TYPE
 tvideo=(textmode,cga320,cga640,vga320);
(* 0 una posicion, 1 2 posiciones *)
CONST
 cgaX:ARRAY[0..11] of byte=(0,1,1,0,1,0,0,1,0,0,1,0);
 codeX:array[0..8] of byte=(0,1,0,0,1,0,1,0,0);
 textX='Þ ÝÛÞÝÝ';{en negativo de color}
 cgaF:ARRAY[0..11] of byte=(0,1,0,0,1,0,0,1,1,0,1,0);
 codeF:array[0..8] of byte=(0,0,1,0,1,1,0,0,0);
 textF='ÞÞÝÛ ÝÝ';
 codeE:array[0..8] of byte=(1,0,0,0,1,1,0,0,0);
 cgaE:array[0..11] of byte=(0,0,1,0,1,0,0,1,1,0,1,0);
 codeD:array[0..8] of byte=(0,0,0,0,1,1,0,0,1);
 cgaD:array[0..11] of byte=(0,1,0,1,0,0,1,1,0,1,0,0);
 codeC:array[0..8] of byte=(1,0,1,0,0,1,0,0,0);
 cgaC:array[0..11] of byte=(0,0,1,0,0,1,0,1,1,0,1,0);
 codeB:array[0..8] of byte=(0,0,1,0,0,1,0,0,1);
 cgaB:array[0..11] of byte=(0,1,0,0,1,0,1,1,0,1,0,0);
 codeA:array[0..8] of byte=(1,0,0,0,0,1,0,0,1);
 cgaA:array[0..11] of byte=(0,0,1,0,1,0,1,1,0,1,0,0);
 code9:array[0..8] of byte=(0,0,1,1,0,0,1,0,0);
 cga9:array[0..11] of byte=(0,1,0,0,1,1,0,1,0,0,1,0);
 code8:array[0..8] of byte=(1,0,0,1,0,0,1,0,0);
 cga8:array[0..11] of byte=(0,0,1,0,1,1,0,1,0,0,1,0);
 code7:array[0..8] of byte=(0,0,0,1,0,0,1,0,1);
 cga7:array[0..11] of byte=(0,1,0,1,1,0,1,0,0,1,0,0);
 code6:array[0..8] of byte=(0,0,1,1,1,0,0,0,0);
 cga6:array[0..11] of byte=(0,1,0,0,1,1,0,0,1,0,1,0);
 code5:array[0..8] of byte=(1,0,0,1,1,0,0,0,0);
 cga5:array[0..11] of byte=(0,0,1,0,1,1,0,0,1,0,1,0);
 code4:array[0..8] of byte=(0,0,0,1,1,0,0,0,1);
 cga4:array[0..11] of byte=(0,1,0,1,1,0,0,1,0,1,0,0);
 code3:array[0..8] of byte=(1,0,1,1,0,0,0,0,0);
 cga3:array[0..11] of byte=(0,0,1,0,0,1,1,0,1,0,1,0);
 code2:array[0..8] of byte=(0,0,1,1,0,0,0,0,1);
 cga2:array[0..11] of byte=(0,1,0,0,1,1,0,1,0,1,0,0);
 code1:array[0..8] of byte=(1,0,0,1,0,0,0,0,1);
 cga1:array[0..11] of byte=(0,0,1,0,1,1,0,1,0,1,0,0);
 code0:array[0..8] of byte=(0,0,0,1,1,0,1,0,0);
 cga0:array[0..11] of byte=(0,1,0,1,1,0,0,1,0,0,1,0);
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
 {volcado:ARRAY[0..63999]OF BYTE ABSOLUTE $A000:0000;}
 vcga:ARRAY[0..15999]OF BYTE ABSOLUTE $B800:0000;
 vcga2:ARRAY[0..15999]OF BYTE ABSOLUTE $BA00:0000;
 linea640cga:ARRAY[0..639]OF BYTE;
 x,y:INTEGER;
 globalGFXcolor:integer;
{---------------------------------------------------------------------------}
PROCEDURE SetCGA320x200; NEAR; ASSEMBLER;
ASM MOV AX,4;INT 10h END;
{---------------------------------------------------------------------------}
PROCEDURE SetCGA640x480; NEAR; ASSEMBLER;
ASM MOV AX,6;INT 10h END;
{---------------------------------------------------------------------------}
PROCEDURE DrawCODE39cga(cad:string;modo:tvideo);
VAR
 i,j:word;
 cont:word;
 aux:byte;
BEGIN
 cont:=0;
 FOR j:=0 TO 99 DO
  FOR i:=0 TO 79 DO
   BEGIN vcga[cont]:=$FF; vcga2[cont]:=$FF; cont:=cont+1; END;
 FOR i:=0 TO 319 DO linea640cga[i]:=1;{Son 320 pixels}

 cont:=50;
 FOR j:=1 TO length(cad) DO
  BEGIN
   FOR i:=0 TO 11 DO
    BEGIN
     CASE cad[j] OF
      '*':linea640cga[cont]:=cgaX[i];
      'F':linea640cga[cont]:=cgaF[i];
      'E':linea640cga[cont]:=cgaE[i];
      'D':linea640cga[cont]:=cgaD[i];
      'C':linea640cga[cont]:=cgaC[i];
      'B':linea640cga[cont]:=cgaB[i];
      'A':linea640cga[cont]:=cgaA[i];
      '9':linea640cga[cont]:=cga9[i];
      '8':linea640cga[cont]:=cga8[i];
      '7':linea640cga[cont]:=cga7[i];
      '6':linea640cga[cont]:=cga6[i];
      '5':linea640cga[cont]:=cga5[i];
      '4':linea640cga[cont]:=cga4[i];
      '3':linea640cga[cont]:=cga3[i];
      '2':linea640cga[cont]:=cga2[i];
      '1':linea640cga[cont]:=cga1[i];
      '0':linea640cga[cont]:=cga0[i];
     END;
     cont:=cont+1;
    END;
    cont:=cont+1;
  END;

 cont:=0;
 FOR j:=20 TO 50 DO
  BEGIN
   cont:=0;
   FOR i:=0 TO 79 DO
    BEGIN
     aux:=(linea640cga[cont] SHL 7)OR(linea640cga[cont] SHL 6); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 5)OR(linea640cga[cont] SHL 4); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 3)OR(linea640cga[cont] SHL 2); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 1)OR(linea640cga[cont]); cont:=cont+1;
     vcga[(j*80)+i]:=aux;
     vcga2[(j*80)+i]:=aux;
    END;
  END;
END;
{---------------------------------------------------------------------------}
PROCEDURE PruebaCGA320x200;
VAR
 i,j:word;
 cont:word;
 aux:byte;
BEGIN
 cont:=0;
 FOR j:=0 TO 99 DO
  FOR i:=0 TO 79 DO
   BEGIN vcga[cont]:=$FF; vcga2[cont]:=$FF; cont:=cont+1; END;
 FOR i:=0 TO 319 DO linea640cga[i]:=1;{Son 320 pixels}

 cont:=50;
 FOR i:=0 TO 11 DO
  BEGIN linea640cga[cont]:=cgaX[i]; cont:=cont+1; END;
 cont:=cont+1;
 FOR j:=0 TO 15
  DO
  BEGIN
   FOR i:=0 TO 11 DO
    BEGIN linea640cga[cont]:=cga9[i]; cont:=cont+1; END;
   cont:=cont+1;
  END;
 FOR i:=0 TO 11 DO
  BEGIN linea640cga[cont]:=cgaX[i]; cont:=cont+1; END;


 cont:=0;
 FOR j:=20 TO 50 DO
  BEGIN
   cont:=0;
   FOR i:=0 TO 79 DO
    BEGIN
     aux:=(linea640cga[cont] SHL 7)OR(linea640cga[cont] SHL 6); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 5)OR(linea640cga[cont] SHL 4); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 3)OR(linea640cga[cont] SHL 2); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 1)OR(linea640cga[cont]); cont:=cont+1;
(*     aux:=aux OR (linea640cga[cont] SHL 3); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 2); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 1); cont:=cont+1;
     aux:=aux OR linea640cga[cont]; cont:=cont+1;*)
     vcga[(j*80)+i]:=aux;
     vcga2[(j*80)+i]:=aux;
    END;
  END;
END;
{---------------------------------------------------------------------------}
PROCEDURE PruebaCGA;
VAR
 i,j:word;
 cont:word;
 aux:byte;
BEGIN
 cont:=0;
 FOR j:=0 TO 99 DO
  FOR i:=0 TO 79 DO
   BEGIN vcga[cont]:=$FF; vcga2[cont]:=$FF; cont:=cont+1; END;
 FOR i:=0 TO 639 DO linea640cga[i]:=1;
 cont:=100;
 FOR i:=0 TO 11 DO
  BEGIN linea640cga[cont]:=cgaX[i]; cont:=cont+1; END;
 cont:=cont+1;
 FOR j:=0 TO 15
  DO
  BEGIN
   FOR i:=0 TO 11 DO
    BEGIN linea640cga[cont]:=cgaF[i]; cont:=cont+1; END;
   cont:=cont+1;
  END;
 FOR i:=0 TO 11 DO
  BEGIN linea640cga[cont]:=cgaX[i]; cont:=cont+1; END;


 cont:=0;
 FOR j:=40 TO 70 DO
  BEGIN
   cont:=0;
   FOR i:=0 TO 79 DO
    BEGIN
     aux:=(linea640cga[cont] SHL 7); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 6); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 5); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 4); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 3); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 2); cont:=cont+1;
     aux:=aux OR (linea640cga[cont] SHL 1); cont:=cont+1;
     aux:=aux OR linea640cga[cont]; cont:=cont+1;
     vcga[(j*80)+i]:=aux;
     vcga2[(j*80)+i]:=aux;
    END;
  END;
END;
{---------------------------------------------------------------------------}
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
PROCEDURE DibujaTextCODE39(c:string);
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
PROCEDURE DibujaGFXCODE39(var c:array of byte);
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
PROCEDURE EscribeCODE39(c:char;modoGFX:TVideo);
BEGIN
 IF modoGFX=vga320 THEN
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
PROCEDURE EscribeCadena39(cad:string;modoGFX:TVideo);
VAR i:integer;
BEGIN
 CASE modoGFX OF
  textMode: BEGIN
    FOR i:=1 TO length(cad) DO
     BEGIN EscribeCODE39(cad[i],modoGFX); END;
   END;
  cga320: DrawCODE39cga(cad,modoGFX);
  cga640: DrawCODE39cga(cad,modoGFX);
 END;
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
 (*EscribeCadena39('*FFFFFFFF*',textmode);*)
 SetCGA320x200;
 EscribeCadena39('*0123456789ABCDEF*',cga320);
 readln;
 Setmode13h;
 FOR x:=0 TO 318 DO
  FOR y:=198 DOWNTO 1 DO
   MEM[$A000:((y shl 8)+(y shl 6)+x)]:=15;
 {MEM[$A000:((y shl 8)+(y shl 6)+x)]:=pantalla^[x,y];}

 globalGFXcolor:=0;
 globalPosX:=40;
 globalPosY:=30;
(* EscribeCadena39('*0123456789ABCDEF*',true);
 readln;
 SetCGA640x480;
 PruebaCGA;
 readln;*)
 (*SetCGA320x200;
 PruebaCGA320x200;
 readln;*)
 ASM MOV AX,3h; INT 10h END;
END.
