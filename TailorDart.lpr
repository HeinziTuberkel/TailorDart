program TailorDart;

{$mode objfpc}{$H+}

uses
		{$IFDEF UNIX}{$IFDEF UseCThreads}
		cthreads,
		{$ENDIF}{$ENDIF}
		Interfaces, // this includes the LCL widgetset
		Forms, runtimetypeinfocontrols, SelectGame, DartClasses, playgame, GameTest,
		fr_Player, YesNo, GameTestPlayer, GameX01Player, GameX01, DartResources;

{$R *.res}

begin
		RequireDerivedFormResource := True;
		Application.Initialize;
		Application.CreateForm(TFrmPlayGame, FrmPlayGame);
		Application.CreateForm(TFrmSelectGame, FrmSelectGame);
		Application.CreateForm(TFrmYesNo, FrmYesNo);
		Application.Run;
end.

