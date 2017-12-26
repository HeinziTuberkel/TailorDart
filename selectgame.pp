unit SelectGame;

{$mode objfpc}{$H+}

interface

uses
	fr_Player, DartClasses, GameTest, GameX01, Classes, SysUtils,
	FileUtil, RTTICtrls, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
	ActnList, StdCtrls, TS_Application, TS_Panel, TS_GroupBox, TS_Splitter,
	TS_SpeedButton, BCButton, BGRASpeedButton;

type
	{ TFrmSelectGame }
	TFrmSelectGame = class(TForm)
		AcAddPlayer: TAction;
		ActStartGame: TAction;
		ActMain: TActionList;
		BtnAddPlayer: TTSSpeedButton;
		BtnGameMickeyMouse: TTSSpeedButton;
		BtnGameShandy: TTSSpeedButton;
		BtnGameTest: TTSSpeedButton;
		BtnGameX01: TTSSpeedButton;
		BtnStart: TTSSpeedButton;
		BxSpiel: TTSGroupBox;
		PnlOptions: TPanel;
		PnlRight: TTSPanel;
		PnlRoster: TTSPanel;
		ScrollBox1: TScrollBox;
		SpltOptions: TSplitter;
		App: TTSApplication;
		TSSplitter1: TTSSplitter;
		procedure AcAddPlayerExecute(Sender: TObject);
		procedure ActStartGameExecute(Sender: TObject);
		procedure BtnSelectGameClick(Sender: TObject);
		procedure FormShow(Sender: TObject);
	private
		PlayerList: array of TFrPlayer;
		SelectedGame: TDartGame;
		DartGameTest: TDartGame;
		DartGameX01: TDartGame;
		DartGameMickeyMouse: TDartGame;
		DartGameShandy: TDartGame;
		procedure OnDeletePlayerClick(Sender: TObject; Index: Integer);
		procedure SetGame(var Game: TDartGame; GameClass: TDartGameClass);
		procedure CheckShowOptions;
	public
    procedure AlignToParent;
	end;

var
		FrmSelectGame: TFrmSelectGame;


implementation

{$R *.lfm}

uses
  PlayGame;

{ TFrmSelectGame }
procedure TFrmSelectGame.BtnSelectGameClick(Sender: TObject);
begin
	if BtnGameX01.Down then
		SetGame(DartGameX01, TDartGameX01)
  else if BtnGameShandy.Down then
    SetGame(DartGameShandy, TDartGame)
	else if BtnGameMickeyMouse.Down then
  	SetGame(DartGameMickeyMouse, TDartGame)
  else if BtnGameTest.Down then
		SetGame(DartGameTest, TDartGameTest)
  else begin
    BtnGameX01.Down := True;
    SetGame(DartGameX01, TDartGameX01);
	end;
end;

procedure TFrmSelectGame.FormShow(Sender: TObject);
begin
  BtnSelectGameClick(nil);
end;

procedure TFrmSelectGame.ActStartGameExecute(Sender: TObject);
var
	I, N: Integer;
begin
  if Assigned(SelectedGame) and (Length(PlayerList)>0) then
  begin
  	SelectedGame.Clear;
    for I := 0 to pred(Length(PlayerList)) do
    begin
	    N := SelectedGame.AddPlayer;
      SelectedGame.Player[N].Nickname := PlayerList[I].Nickname;
    end;
    Self.Hide;
	  FrmPlayGame.PlayDartGame(SelectedGame);
	end;
end;

procedure TFrmSelectGame.AcAddPlayerExecute(Sender: TObject);
var
	N: integer;
begin
  N := Length(PlayerList);
  SetLength(PlayerList, N+1);
  PlayerList[N] := TFrPlayer.Create(Self, N, @OnDeletePlayerClick);
  with PlayerList[N] do
	begin
    Name := 'Player' + IntToStr(N);
    Parent := PnlRoster;
    Top := 1 + Height * N;
    Align := alTop;
    SetFocus;
	end;
end;

procedure TFrmSelectGame.OnDeletePlayerClick(Sender: TObject; Index: Integer);
var
  I: Integer;
begin
  if Index < Length(PlayerList) then
  begin
    PlayerList[Index].Free;
		for I := Index to Length(PlayerList)-2 do
    begin
    	PlayerList[I] := PlayerList[I+1];
      PlayerList[I].Index := I;
      PlayerList[I].Name := 'Player' + IntToStr(I);
		end;
    SetLength(PlayerList, Length(PlayerList)-1);
	end;
end;

procedure TFrmSelectGame.SetGame(var Game: TDartGame; GameClass: TDartGameClass
	);
begin
	if not Assigned(Game) then
		Game := GameClass.Create;
  SelectedGame := Game;
  CheckShowOptions;
end;

procedure TFrmSelectGame.CheckShowOptions;
	begin
	if Assigned(SelectedGame) and SelectedGame.HasOptions then
	begin
		SelectedGame.Options.Parent := PnlOptions;
		PnlOptions.Show;
		PnlOptions.Height := SelectedGame.Options.Height;
		SelectedGame.Options.Align := alClient;
		SpltOptions.Show;
	end
	else begin
		PnlOptions.Hide;
		SpltOptions.Hide;
	end;
end;

procedure TFrmSelectGame.AlignToParent;
begin
  Left := 50;
  Top := 50;
  Width := Parent.ClientWidth - 100;
  Height := Parent.ClientHeight - 100;

end;

end.
