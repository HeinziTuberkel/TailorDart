unit playgame;

{$mode objfpc}{$H+}

interface

uses
	DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

	{ TFrmPlayGame }

	TFrmPlayGame = class(TForm)
		procedure FormShow(Sender: TObject);
	private
    ActiveGame: TDartGame;
    procedure SetScreenPos;
	public
    procedure PlayDartGame(ThisGame: TDartGame);
    procedure OnEndGame(Sender: TObject);
	end;

var
	FrmPlayGame: TFrmPlayGame;

implementation

{$R *.lfm}

{ TFrmPlayGame }

procedure TFrmPlayGame.PlayDartGame(ThisGame: TDartGame);
begin
  ActiveGame := ThisGame;
  Self.ShowModal;
end;

procedure TFrmPlayGame.FormShow(Sender: TObject);
begin
  ActiveGame.InitGame(Self);
  AutoSize := True;
  Application.ProcessMessages;
  SetScreenPos;
	ActiveGame.PlayGame;
end;

procedure TFrmPlayGame.SetScreenPos;
var
  Dsp: TMonitor;
begin
  Dsp := Screen.MonitorFromPoint(Point(Left, Top));
  Left := (Dsp.Width - Width) DIV 2;
  Top := (Dsp.Height - Height) DIV 2;
end;

procedure TFrmPlayGame.OnEndGame(Sender: TObject);
begin
  AutoSize := False;
  ModalResult := mrOK;
end;

end.

