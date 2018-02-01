unit GameX01Player;

{$mode objfpc}{$H+}

interface

uses
  GameX01,
	DartClasses, Classes, SysUtils, FileUtil, Forms, Controls, Grids, StdCtrls,
	ExtCtrls, Buttons, TS_Panel, TS_SpeedButton, TS_Edit, BCButton;

type
 TPlayerX01 = class;

	{ TFrX01Player }

	TFrX01Player = class(TFrame)
		BCButton1: TTSSpeedButton;
		BCButton2: TTSSpeedButton;
		BCButton3: TTSSpeedButton;
		EdScore: TTSNumEdit;
		LbAverage: TLabel;
		LbFinish: TLabel;
		LbNickname: TLabel;
		LbSetsLegsCaption: TLabel;
		LbName5: TLabel;
		LbName6: TLabel;
		LbSetsLegs: TLabel;
		Panel1: TPanel;
		Panel4: TPanel;
		Panel5: TPanel;
		PnlEdit: TPanel;
		SGChalkBoard: TStringGrid;
		PnlGetScore: TTSPanel;
		TSPanel2: TTSPanel;
		BtnUndoThrow: TTSSpeedButton;
		BtnScoreDone: TTSSpeedButton;
		procedure BtnScoreDoneClick(Sender: TObject);
		procedure BtnUndoThrowClick(Sender: TObject);
		procedure EdScoreAccepted(Sender: TObject);
		procedure Panel1Enter(Sender: TObject);
	private
		Player: TPlayerX01;
	public
		procedure Init;
		procedure Reset(AsFirstToThrow: Boolean);
		procedure LockInput;
		procedure GetScore;
    function IsCheckOut: Boolean;
		procedure UpdateDisplay;
		function ScoreInput: Integer;
		procedure AddScoreLine(Score, Remain: Integer);
		procedure RemoveScoreLine;
	end;

	{ TPlayerX01 }

	TPlayerX01 = class(TPlayer)
	private
		Frame: TFrX01Player;
    ThisGame: TDartGameX01;
		function GetSetMode: Boolean;
	protected
		procedure ExecuteThrow; override;
		procedure ExecuteUndoAction; override;
	public
		destructor Destroy; override;
		procedure InitGame(TheGame: TDartGame); override;
		procedure InitLeg(AsFirstToThrow: Boolean); override;
		procedure AddCurrentThrowToList; virtual;
    procedure LegWon;

    function Require: Integer;
		function CanUndoThrow: Boolean; override;
		function IsCheckOut: Boolean; override;

    procedure ThrowDone; override;
		procedure ThrowCancel; override;
    procedure CheckOut; override;

		property SetMode: Boolean read GetSetMode;
	end;

implementation

{$R *.lfm}

uses
	strutils, YesNo, DartResources;

//**************************************************************************************************
//**************************************************************************************************
{ TFrX01Player }

procedure TFrX01Player.BtnUndoThrowClick(Sender: TObject);
begin
  Player.ThrowCancel;
end;

procedure TFrX01Player.EdScoreAccepted(Sender: TObject);
begin
	Player.ThrowDone;
end;

procedure TFrX01Player.Panel1Enter(Sender: TObject);
begin
  EdScore.TryFocus;
end;

procedure TFrX01Player.BtnScoreDoneClick(Sender: TObject);
begin
  EdScore.Accept;
end;

procedure TFrX01Player.Init;
begin
  Parent := Player.ScoreBoard;
  Left := Width + 1;
  Align := alLeft;
  LbNickname.Caption := Player.Nickname;
  SGChalkboard.Clear;
  if Player.SetMode then
	begin
		LbSetsLegsCaption.Caption := 'Sets / Legs won';
		LbSetsLegs.Caption := '0 / 0';
	end
	else begin
		LbSetsLegsCaption.Caption := 'Legs won';
		LbSetsLegs.Caption := '0';
	end;
	LockInput;
end;

procedure TFrX01Player.Reset(AsFirstToThrow: Boolean);
begin
	if AsFirstToThrow then
		LbNickname.Caption := '* '  + Player.Nickname
	else
		LbNickname.Caption := Player.Nickname;
  if Player.SetMode then
		LbSetsLegs.Caption := IntToStr(Player.SetsWon) + ' / ' + IntToStr(Player.LegsWon)
	else
		LbSetsLegs.Caption := IntToStr(Player.LegsWon);
  SGChalkboard.Clear;
	LockInput;
end;

procedure TFrX01Player.LockInput;
begin
  UpdateDisplay;
	PnlGetScore.Hide;
	Enabled := False;
end;

procedure TFrX01Player.GetScore;
begin
	Enabled := True;
	UpdateDisplay;
  PnlGetScore.Show;
  EdScore.SetFocus;
  EdScore.Clear;
  BtnUndoThrow.Enabled := Player.CanUndoThrow;
end;

function TFrX01Player.IsCheckOut: Boolean;
begin
  Result := Confirm(Format(rsPlayerCheckOut, [Player.Nickname]));
end;

procedure TFrX01Player.UpdateDisplay;
begin

end;

function TFrX01Player.ScoreInput: Integer;
begin
	Result := EdScore.AsInteger;
end;

procedure TFrX01Player.AddScoreLine(Score, Remain: Integer);
var
  R: Integer;
  Z: PtrInt;
begin
 	R := SGChalkBoard.RowCount;
  if Score > 0 then
  begin
    SGChalkBoard.RowCount := R + 1;
  	SGChalkBoard.Cells[0, R] := IntToStr(Score);
    SGChalkBoard.Cells[1, R] := IntToStr(Remain);
	end
  else begin
    //Im "Object" der Row wird die Anzahl "No Scores" für diese Zeile gespeichert.
    if R > 0 then
	    Z := PtrInt(SGChalkBoard.Rows[R-1].Objects[0])
    else
    	Z := 0;
    if Z = 0 then
      SGChalkBoard.RowCount := R + 1
    else
      dec(R);

    inc(Z);
		SGChalkBoard.Rows[R].Objects[0] := TObject(Z);
    SGChalkBoard.Cells[1, R] := IntToStr(Remain);
    if Z = 1 then
	    SGChalkBoard.Cells[0, R] := rsNoScore
    else
	    SGChalkBoard.Cells[0, R] := rsNoScore + ' '
                                + StringOfChar('}', Z div 5) //ergibt einen 5er Zählblock in Schriftart "CHAWP"
                                + StringOfChar('{', Z mod 5); //ergibt einen Zählstrich in Schriftart "CHAWP"
	end;
end;

procedure TFrX01Player.RemoveScoreLine;
var
  R: Integer;
	Z: PtrInt;
begin
  R := SGChalkBoard.RowCount - 1;
	Z := PtrInt(SGChalkBoard.Rows[R].Objects[0]) - 1;
  if Z > 0 then
  	SGChalkBoard.Rows[R].Objects[0] := TObject(Z)
  else
    SGChalkBoard.RowCount := R;
end;


//**************************************************************************************************
//**************************************************************************************************
{ TPlayerX01 }
//**************************************************************************************************
//**************************************************************************************************

destructor TPlayerX01.Destroy;
begin
	inherited Destroy;
  if Assigned(Frame) then
    Frame.Free;
end;

procedure TPlayerX01.InitGame(TheGame: TDartGame);
begin
  if not (TheGame is TDartGameX01) then
		raise Exception.Create(Format(rsWrongPlayerClass, ['TPlayerX01', 'TDartGameX01']));
  inherited InitGame(TheGame);
  ThisGame := TDartGameX01(TheGame);
  if not Assigned(Frame) then
		Frame := TFrX01Player.Create(ScoreBoard.Owner);
  Frame.Player := Self;
  Frame.Init;
end;

procedure TPlayerX01.InitLeg(AsFirstToThrow: Boolean);
begin
	inherited InitLeg(AsFirstToThrow);
	Frame.Reset(AsFirstToThrow);
	CurrentThrow.Score := 0;
  StartRemain := ThisGame.StartValue;
end;

procedure TPlayerX01.AddCurrentThrowToList;
begin
	inherited AddCurrentThrowToList;
 	Frame.UpdateDisplay;
end;

function TPlayerX01.Require: Integer;
var
	N: Integer;
begin
  N := Length(RemainList);
  if N = 0 then
  	Result := StartRemain
  else
  	Result := RemainList[N-1];
end;

function TPlayerX01.GetSetMode: Boolean;
begin
	Result := ThisGame.SetMode;
end;

procedure TPlayerX01.ExecuteThrow;
begin
	Frame.GetScore;
end;

function TPlayerX01.CanUndoThrow: Boolean;
begin
	Result := (Length(ScoreList)>0) or not IsStartPlayer;
end;

procedure TPlayerX01.ThrowDone;
var
	Score, N, R: Integer;
begin
  N := Length(ScoreList);
  Score := Frame.ScoreInput;
	SetLength(ScoreList, N+1);
  SetLength(RemainList, N+1);
  //für evtl. spätere Unterscheidung zwischen "No Score" und "Busted".
  if (Score > Require) then
  begin
  	Score := 0;
	  ScoreList[N] := -1;
 	end
	else
	  ScoreList[N] := Score;
  if N > 0 then
	  RemainList[N] := RemainList[N-1] - Score
  else
  	RemainList[N] := StartRemain - Score;
	Frame.AddScoreLine(ScoreList[N], RemainList[N]);
  Frame.LockInput;
	inherited ThrowDone;
end;

procedure TPlayerX01.ExecuteUndoAction;
var
	N: Integer;
begin
	if CanUndoThrow then
  begin
    N := Length(ScoreList);
    if N > 0 then
    	dec(N);
    SetLength(ScoreList, N);
    SetLength(RemainList, N);
    Frame.RemoveScoreLine;
	end;
end;

procedure TPlayerX01.ThrowCancel;
begin
  Frame.LockInput;
	inherited ThrowCancel;
end;

function TPlayerX01.IsCheckOut: Boolean;
begin
	Result := (Require = 0) and Frame.IsCheckOut;
end;

procedure TPlayerX01.CheckOut;
begin
	if IsCheckOut then
  	LegWon;
end;

procedure TPlayerX01.LegWon;
begin
  inc(fLegs);

end;



end.

