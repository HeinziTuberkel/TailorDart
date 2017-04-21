unit PlayDart;

{$mode objfpc}{$H+}

interface

uses
  DartClasses, fr_dartboard, Fr_PlayerX01,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

	{ TFrmPlayDart }

 TFrmPlayDart = class(TForm)
		FrDarboard1: TFrDarboard;
		procedure PnlCurrentAimClick(Sender: TObject);
	private
    fGameType: NGameType;
		fPlayer: array of TFrPlayer;
	public
  	procedure Reset(TheGameType: NGameType; ClearPlayers: Boolean=True);
    procedure AddPlayer(ThePlayer: RPlayer);
	end;

var
	FrmPlayDart: TFrmPlayDart;

implementation

{$R *.lfm}

{ TFrmPlayDart }

procedure TFrmPlayDart.PnlCurrentAimClick(Sender: TObject);
begin

end;

procedure TFrmPlayDart.Reset(TheGameType: NGameType; ClearPlayers: Boolean);
begin

end;

procedure TFrmPlayDart.AddPlayer(ThePlayer: RPlayer);
begin

end;

end.

