program DartboardGrafikTest;

{$mode objfpc}{$H+}

uses
	{$IFDEF UNIX}{$IFDEF UseCThreads}
	cthreads,
	{$ENDIF}{$ENDIF}
	Interfaces, // this includes the LCL widgetset
	Forms, TestMain, DartBoardTest
	{ you can add units after this };

{$R *.res}

begin
	RequireDerivedFormResource := True;
	Application.Initialize;
	Application.CreateForm(TFrmBoard, FrmBoard);
	Application.CreateForm(TForm1, Form1);
	Application.Run;
end.

