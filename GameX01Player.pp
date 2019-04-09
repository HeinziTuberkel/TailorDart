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
		BtnInputTarget: TTSSpeedButton;
		BtnInputScore: TTSSpeedButton;
		BtnInputRequire: TTSSpeedButton;
		EdScore: TEdit;
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
		procedure EdScoreKeyPress(Sender: TObject; var Key: char);
		procedure Panel1Enter(Sender: TObject);
	private
		Player: TPlayerX01;
	public
    constructor Create(TheOwner: TComponent); override;
		procedure Init;
		procedure Reset(AsFirstToThrow: Boolean);
		procedure LockInput;
		procedure GetScore;
    function IsCheckOut: Boolean;
		procedure UpdateDisplay;
		function ScoreInput(ClearScore: Boolean=False): Integer;
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
		procedure ClearCurrentThrow; override;
		procedure AddCurrentThrowToList; override;

    function Require: Integer;
		function CurrentScore(ClearScore: Boolean=False): Integer;
		function IsCheckOut: Boolean; override;

    procedure ThrowDone; override;
		procedure ThrowCancel; override;

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

procedure TFrX01Player.EdScoreKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    #13: begin
  		BtnScoreDone.Click;
  		Key := #0;
		end;
		^Z: begin
  		BtnUndoThrow.Click;
  		Key := #0;
		end;
    ^R: begin
      BtnInputRequire.Click;
      Key := #0;
		end;
    ^S: begin
      BtnInputScore.Click;
      Key := #0;
		end;
    ^T: begin
      BtnInputTarget.Click;
      Key := #0;
		end;
	end;
end;

procedure TFrX01Player.Panel1Enter(Sender: TObject);
begin
  if EdScore.CanFocus then
		EdScore.SetFocus;
end;

constructor TFrX01Player.Create(TheOwner: TComponent);
begin
	inherited Create(TheOwner);
	Name := '';
end;

procedure TFrX01Player.BtnScoreDoneClick(Sender: TObject);
begin
  Player.ThrowDone;
end;

procedure TFrX01Player.Init;
begin
  Parent := Player.ScoreBoard;
  Left := 0;
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
Self.SetFocus;
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
var
	I, R, Z: Integer;

	procedure WriteNoScore;
	begin
		SGChalkBoard.RowCount := R+1;
    if Z = 1 then
	    SGChalkBoard.Cells[0, R] := rsNoScore
    else
	    SGChalkBoard.Cells[0, R] := rsNoScore + ' '
                                + StringOfChar('}', Z div 5) //ergibt einen 5er Zählblock in Schriftart "CHAWP"
                                + StringOfChar('{', Z mod 5); //ergibt einen Zählstrich in Schriftart "CHAWP"
    SGChalkBoard.Cells[1, R] := IntToStr(Player.ThrowList[I].GameScore);
		inc(R);
	end;


begin
	with SGChalkBoard do
	begin
		BeginUpdate;
		try
			R := 0;
			Z := 0;
    	for I := 1 to Player.ThrowCount do
    	begin
  			if Player.ThrowList[I].Invalid or Player.ThrowList[I].NoScore then
        	inc(Z)
				else begin
					if Z > 0 then //one or more "No Score" entries.
						WriteNoScore;
					Z := 0;
      		RowCount := R+1;
          Cells[0, R] := IntToStr(Player.ThrowList[I].Score);
          Cells[1, R] := IntToStr(Player.ThrowList[I].GameScore);
      		inc(R);
				end;
    	end; //for each Throw;
			if Z>0 then
				WriteNoScore;
		finally
			EndUpdate;
		end;
	end;
end;

function TFrX01Player.ScoreInput(ClearScore: Boolean): Integer;
begin
	Result := StrToIntDef(EdScore.Text, 0);
	if ClearScore then
		EdScore.Clear;
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
	ClearCurrentThrow;
end;

procedure TPlayerX01.ClearCurrentThrow;
begin
	inherited ClearCurrentThrow;
	if ThrowCount = 0 then
		CurrentThrow.GameScore := ThisGame.StartRemain
	else
		CurrentThrow.GameScore := LastThrow.GameScore;
end;

procedure TPlayerX01.AddCurrentThrowToList;
begin
	with CurrentThrow do
	begin
		Invalid := Score > LastThrow.GameScore;
		NoScore := Invalid or (Score <= 0);
		if NoScore then
			Score := 0;
		GameScore := LastThrow.GameScore - Score;
	end;

	inherited AddCurrentThrowToList;
 	Frame.UpdateDisplay;
end;

function TPlayerX01.Require: Integer;
begin
	Result := LastThrow.GameScore - CurrentScore;
end;

function TPlayerX01.CurrentScore(ClearScore: Boolean): Integer;
begin
//  Result := CurrentThrow.Dart[1].Score + CurrentThrow.Dart[2].Score + CurrentThrow.Dart[3].Score;
  Result := Frame.ScoreInput(ClearScore);
end;

function TPlayerX01.GetSetMode: Boolean;
begin
	Result := ThisGame.SetMode;
end;

procedure TPlayerX01.ExecuteThrow;
begin
	Frame.GetScore;
end;

procedure TPlayerX01.ThrowDone;
var
	N, R: Integer;
begin
	CurrentThrow.Score := CurrentScore(True);
	//Frame.AddScoreLine(CurrentThrow.Score, Require);
	inherited ThrowDone;
  Frame.LockInput;
end;

procedure TPlayerX01.ExecuteUndoAction;
var
	N: Integer;
begin
  Frame.RemoveScoreLine;
  inherited ExecuteUndoAction;
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

end.

