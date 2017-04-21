unit GameTest;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
  Controls,
  Classes, SysUtils;

type

	{ TDartGameTest }

	TDartGameTest = class(TDartGame)
  public
		constructor Create; override;
    procedure EndGame; override;
	end;


implementation

uses
  GameTestPlayer,
  Dialogs;

{ TDartGameTest }

constructor TDartGameTest.Create;
begin
	inherited Create;
	PlayerClass := TDartPlayerTest;
end;


procedure TDartGameTest.EndGame;
begin
  inherited EndGame;
	Showmessage('Testspiel beendet');
end;


end.

