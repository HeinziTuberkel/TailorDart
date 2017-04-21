program DartBasic;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, DartFunctions, DMDart, DartClasses, Fr_PlayerX01, PlayDart, 
GetPlayer, DartConstants, DartMain, fr_spielerdaten, 
Fr_OptShandy, Fr_OptMickeyMouse, Fr_OptX01, fr_dartboard;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
	Application.CreateForm(TFrmDartMain, FrmDartMain);
	Application.CreateForm(TDataModule1, DataModule1);
	Application.CreateForm(TFrmPlayDart, FrmPlayDart);
	Application.CreateForm(TFrmGetSpieler, FrmGetSpieler);
  Application.Run;
end.

