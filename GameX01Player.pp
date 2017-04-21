unit GameX01Player;

{$mode objfpc}{$H+}

interface

uses
  GameX01,
	DartClasses, Classes, SysUtils, FileUtil, Forms, Controls, Grids, StdCtrls,
	ExtCtrls, Buttons, TS_Panel, TS_SpeedButton, TS_Edit, BCButton;

resourcestring
  rsNoScore = 'no score';
  rsBusted = 'busted';

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
		LbName2: TLabel;
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
	procedure EdScoreAccept(Sender: TObject; var NewText: string;
		var AcceptAction: NTSAcceptAction);
	procedure EdScoreKeyPress(Sender: TObject; var Key: char);
	procedure Panel1Enter(Sender: TObject);
	private
    Player: TPlayerX01;
	public
		procedure Init;
    procedure LockInput;
    procedure GetScore;
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
    StartScore: Integer;
    ScoreList: array of Integer;
    RemainList: array of Integer;
	protected
		procedure ExecuteThrow; override;
		procedure ExecuteUndoAction; override;
		procedure SetEnabled(AValue: Boolean); override;
	public
		constructor Create; override;
		destructor Destroy; override;
		procedure InitGame(TheGame: TDartGame; NewIndex: Integer); override;

		function CanUndoThrow: Boolean; override;
		function IsCheckOut: Boolean; override;
		function IsLoseOut: Boolean; override;

		procedure ThrowDone; override;
		procedure ThrowCancel; override;
	end;

implementation

{$R *.lfm}

uses
	strutils;

{ TFrX01Player }

procedure TFrX01Player.BtnUndoThrowClick(Sender: TObject);
begin
  Player.ThrowCancel;
end;

procedure TFrX01Player.EdScoreAccept(Sender: TObject; var NewText: string;
	var AcceptAction: NTSAcceptAction);
begin
	Player.ThrowDone;
end;

procedure TFrX01Player.EdScoreKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
  	Key := #0;
    EdScore.Accept;
    Player.ThrowDone;
	end;
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
  Left := Width + Player.Index + 1;
  Align := alLeft;
  LbNickname.Caption := Player.Nickname;
  SGChalkboard.Clear;
  UpdateDisplay;
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


{ TPlayerX01 }

procedure TPlayerX01.SetEnabled(AValue: Boolean);
begin
	inherited SetEnabled(AValue);
end;

constructor TPlayerX01.Create;
begin
	inherited Create;
end;

destructor TPlayerX01.Destroy;
begin
	inherited Destroy;
  if Assigned(Frame) then
    Frame.Free;
end;

procedure TPlayerX01.InitGame(TheGame: TDartGame; NewIndex: Integer);
begin
  if not (TheGame is TDartGameX01) then
		raise Exception.Create('Wrong game type for TPlayerX01. Must be TDartGameX01');
  inherited InitGame(TheGame, NewIndex);
  ThisGame := TDartGameX01(TheGame);
  if not Assigned(Frame) then
		Frame := TFrX01Player.Create(ScoreBoard.Owner);
  Frame.Player := Self;
  Frame.Init;
  StartScore := ThisGame.StartValue;
  SetLength(ScoreList, 0);
  SetLength(RemainList, 0);
end;

procedure TPlayerX01.ExecuteThrow;
begin
	Frame.GetScore;
end;

function TPlayerX01.CanUndoThrow: Boolean;
begin
	Result := (Length(ScoreList)>0) or (Index>0);
end;

function TPlayerX01.IsCheckOut: Boolean;
begin
	Result := inherited IsCheckOut;
end;

function TPlayerX01.IsLoseOut: Boolean;
begin
	Result := inherited IsLoseOut;
end;

procedure TPlayerX01.ThrowDone;
var
	Score, N: Integer;
begin
  N := Length(ScoreList);
  Score := Frame.ScoreInput;
	SetLength(ScoreList, N+1);
  SetLength(RemainList, N+1);
  ScoreList[N] := Score;
  if N > 0 then
	  RemainList[N] := RemainList[N-1] - Score
  else
  	RemainList[N] := StartScore - Score;
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

end.

