Unit Unit1;
 {$mode objfpc}{$H+}

Interface
 USES
  Windows, Classes, SysUtils, Forms, Controls;

 TYPE
  TForm1 = Class(TForm)
   Procedure FormCreate (Sender: TObject);
   Procedure FormClose  (Sender: TObject;  Var CloseAction: TCloseAction);
  End;

 CONST
  MM_MAX_NUMAXES =  16;
  FR_PRIVATE     = $10;
  FR_NOT_ENUM    = $20;

 TYPE
  PDesignVector = ^TDesignVector;
  TDesignVector = Packed Record
   dvReserved: DWORD;
   dvNumAxes : DWORD;
   dvValues  : Array[0..MM_MAX_NUMAXES-1] Of LongInt;
  End;

 VAR
  Form1: TForm1;



 Function AddFontResourceEx    (Dir : PAnsiChar;
                                Flag: Cardinal;
                                PDV : PDesignVector): Int64; StdCall;
                                External 'GDI32.dll' Name 'AddFontResourceExA';

 Function RemoveFontResourceEx (Dir : PAnsiChar;
                                Flag: Cardinal;
                                PDV : PDesignVector): Int64; StdCall;
                                External 'GDI32.dll' Name 'RemoveFontResourceExA';

 Procedure LoadFonts;
 Procedure RemoveFonts;


Implementation


Procedure LoadFonts;
  Var
   AppPath: String;
 Begin
  AppPath:= ExtractFilePath(Application.ExeName);

   If FileExists(AppPath+'FONTS\MONO.ttf')
   Then
    If AddFontResourceEx(PAnsiChar(AppPath+'FONTS\MONO.ttf'), FR_Private, Nil) <> 0
    Then SendMessage(Form1.Handle, WM_FONTCHANGE, 0, 0);
 End;


Procedure RemoveFonts;
  Var
   AppPath: String;
 Begin
  AppPath:= ExtractFilePath(Application.ExeName);

   If FileExists(AppPath+'FONTS\MONO.ttf')
   Then
    If RemoveFontResourceEx(PAnsiChar(AppPath+'FONTS\MONO.ttf'), FR_Private, Nil) <> 0
    Then SendMessage(Form1.Handle, WM_FONTCHANGE, 0, 0);
 End;


Procedure TForm1.FormCreate(Sender: TObject);
 Begin
  LoadFonts;
 End;


Procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
Begin
  RemoveFonts;
End;


End.
