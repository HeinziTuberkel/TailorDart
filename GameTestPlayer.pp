unit GameTestPlayer;

{$mode objfpc}{$H+}

interface

uses
  DartClasses, YesNo,
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, TS_Edit;

type
	TDartPlayerTest = class;

	{ TFrTestPlayer }

	TFrTestPlayer = class(TFrame)
		BtnOK: TButton;
		BtnUndo: TButton;
		BtnCheck: TButton;
		BtnLose: TButton;
		LbWurf: TLabel;
		LbPunkte: TLabel;
		LbNickname: TLabel;
		EdGeworfen: TTSNumEdit;
		procedure BtnCheckClick(Sender: TObject);
		procedure BtnLoseClick(Sender: TObject);
  procedure BtnOKClick(Sender: TObject);
		procedure BtnUndoClick(Sender: TObject);
	private
    procedure Init;
    procedure Deaktivieren;
    procedure PunkteEingeben;
    procedure UpdateDisplay;
	public
		Player: TDartPlayerTest;

	end;

	{ TDartPlayerTest }

	TDartPlayerTest = class(TPlayer)
  private
    Frame: TFrTestPlayer;
    Punkte: Integer;
    Wurf: Integer;
  protected
    procedure ExecuteThrow; override;
    procedure ExecuteUndoAction; override;
    procedure SetEnabled(AValue: Boolean); override;
    procedure LoseOut; override;
	public
    constructor Create; override;
  	destructor Destroy; override;
		procedure InitGame(TheGame: TDartGame); override;

    function CanUndoThrow: Boolean; override;
		function IsCheckOut: Boolean; override;
    function IsLoseOut: Boolean; override;

		procedure ThrowDone; override;
		procedure ThrowCancel; override;
 	end;



implementation

{$R *.lfm}

uses
	TSLibColors;

{ TFrTestPlayer }

procedure TFrTestPlayer.BtnOKClick(Sender: TObject);
begin
	Player.ThrowDone;
end;

procedure TFrTestPlayer.BtnCheckClick(Sender: TObject);
begin
	EdGeworfen.AsInteger := Player.Punkte;
  Player.ThrowDone;
end;

procedure TFrTestPlayer.BtnLoseClick(Sender: TObject);
begin
	EdGeworfen.AsInteger := Player.Punkte + 1;
  Player.ThrowDone;
end;

procedure TFrTestPlayer.BtnUndoClick(Sender: TObject);
begin
  Player.ThrowCancel;
end;

procedure TFrTestPlayer.Init;
begin
  Parent := Player.ScoreBoard;
  Left := Width * + 1;
  Align := alLeft;
  LbNickname.Caption := Player.Nickname;
  UpdateDisplay;
	Deaktivieren;
end;

procedure TFrTestPlayer.Deaktivieren;
begin
  UpdateDisplay;
	EdGeworfen.Hide;
	Enabled := False;
end;

procedure TFrTestPlayer.PunkteEingeben;
begin
	Enabled := True;
	UpdateDisplay;
  EdGeworfen.Show;
  EdGeworfen.SetFocus;
  EdGeworfen.Clear;
end;

procedure TFrTestPlayer.UpdateDisplay;
begin
  LbPunkte.Caption := IntToStr(Player.Punkte);
	LbWurf.Caption := IntToStr(Player.Wurf);
end;



{ TDartPlayerTest }

constructor TDartPlayerTest.Create;
begin
	inherited Create;
  Punkte := 501;
  Wurf := 0;
end;

destructor TDartPlayerTest.Destroy;
begin
	inherited Destroy;
  if Assigned(Frame) then
    Frame.Free;
end;

procedure TDartPlayerTest.InitGame(TheGame: TDartGame);
begin
  inherited InitGame(TheGame);
 	Punkte := 501;
  Wurf := 0;
  if not Assigned(Frame) then
		Frame := TFrTestPlayer.Create(ScoreBoard.Owner);
  Frame.Player := Self;
  Frame.Init;
end;

procedure TDartPlayerTest.ExecuteThrow;
begin
  Frame.PunkteEingeben;
end;

procedure TDartPlayerTest.ExecuteUndoAction;
begin
  if Wurf > 0 then
  begin
  	Punkte += 11;
    Wurf -= 1;
	end;
end;

procedure TDartPlayerTest.SetEnabled(AValue: Boolean);
begin
	inherited SetEnabled(AValue);
  if Assigned(Frame) then
  begin
	  if AValue then
	  	Frame.Color := clTSBackground
	  else
	  	Frame.Color := clTSLightGray;
	end;
end;

function TDartPlayerTest.CanUndoThrow: Boolean;
begin
	Result := Wurf > 0;
end;

function TDartPlayerTest.IsCheckOut: Boolean;
begin
 	Result := Punkte = 0;
end;

function TDartPlayerTest.IsLoseOut: Boolean;
begin
	Result := Punkte < 0;
end;



procedure TDartPlayerTest.ThrowDone;
begin
	Punkte -= Frame.EdGeworfen.AsInteger;
  inc(Wurf);
  Frame.Deaktivieren;
  inherited ThrowDone;
end;

procedure TDartPlayerTest.ThrowCancel;
begin
  Frame.Deaktivieren;
	inherited ThrowCancel;
end;

procedure TDartPlayerTest.LoseOut;
begin
	inherited LoseOut;
  if Confirm('Neu anfangen?') then
    InitGame(Game)
  else
  	Enabled := False;
end;





end.

