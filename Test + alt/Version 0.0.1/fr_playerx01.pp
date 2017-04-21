unit Fr_PlayerX01;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Grids,
	Buttons, ComCtrls,
	DartClasses;

type

	{ TPlayerX01 }

	TPlayerX01 = class(TFrPlayer)
		BtnBack: TBitBtn;
		BtnDone: TBitBtn;
		EdPoints: TEdit;
		LbAverage: TLabel;
		LbFinish: TLabel;
		LbName: TLabel;
		LbName2: TLabel;
		LbName5: TLabel;
		LbName6: TLabel;
		LbSetsLegs: TLabel;
		Panel1: TPanel;
		Panel4: TPanel;
		Panel5: TPanel;
		PnlRest: TPanel;
		PnlEdit: TPanel;
		PnlInput: TPanel;
		BtnEingabeRest: TSpeedButton;
		BtnEingabeBoard: TSpeedButton;
		BtnEingabeWurf: TSpeedButton;
		SGTafel: TStringGrid;
		procedure BtnBackClick(Sender: TObject);
	  procedure BtnDoneClick(Sender: TObject);
	private
		fAktiv: Boolean;
		fPCPlayer: Boolean;
		fRequired: Integer;
		fRest: Integer;
    fSpieler: RPlayer;
    fAufnahmen: Integer;
    fPunkteGeworfen: Integer;
    fFinishDarts: Integer;
    fFinishes: Integer;
    fChecked: Boolean;
    fNoScoreCount: Integer;
    PunkteDieserWurf: Integer;
    fWurf: array of RThrow;
		function GetDoubleAverage: Integer;
		function GetLegAverage: Double;
		function GetGameAverage: Double;
		procedure SetPCPlayer(AValue: Boolean);
		procedure SetRequired(AValue: Integer);
    procedure PreparePlayer;
  protected
		procedure SetAktiv(AValue: Boolean); override;
	public
  	constructor Create(TheGameType: NGameType; AOwner: TComponent; ThePlayer: RPlayer); override;

    procedure Restart(Level: Integer); override;
    procedure GetThrow; override;
    procedure UndoThrow; override;
    procedure ThrowDone; override;
    procedure CancelThrow; override;
  	procedure LegWon; override;
    procedure LegLost; override;

    property LegAverage: Double read GetLegAverage;
    property GameAverage: Double read GetGameAverage;
    property DoubleAverage: Integer read GetDoubleAverage;


    property PCPlayer: Boolean read fPCPlayer write SetPCPlayer;
    property Required: Integer read fRequired write SetRequired;
	end;

implementation

uses
  DartConstants;

{$R *.lfm}

{ TPlayerX01 }

constructor TPlayerX01.Create(TheGameType: NGameType; AOwner: TComponent;
	ThePlayer: RPlayer);
begin
  inherited Create(TheGameType, AOwner, ThePlayer);
  PreparePlayer;
end;


procedure TPlayerX01.Restart(Level: Integer);
begin
	inherited Restart;
  EdPoints.Clear;
  SGTafel.Clear;
  fChecked := False;
  fNoScoreCount := 0;
	//Rest := Modus.Punkte;
end;

procedure TPlayerX01.GetThrow;
begin
	inherited GetThrow;
	EdPoints.Clear;
  if BtnEingabeBoard.Down then
  begin
//	Grafische Eingabe über Dartboard
	end
  else
	  EdPoints.SetFocus;
end;

procedure TPlayerX01.PreparePlayer;
begin
  fAufnahmen := 0;
  fPunkteGeworfen := 0;
  fFinishDarts := 0;
  fFinishes := 0;
	LbSetsLegs.Caption := '0 / 0';
	LbAverage.Caption := '---';
	LbFinish.Caption := '---';
end;

procedure TPlayerX01.UndoThrow;
begin
	Aktiv := False;
  PunkteDieserWurf := -1;
end;

procedure TPlayerX01.ThrowDone;
var
  I, Pkte: Integer;
	WurfTxt: string;
begin
  if BtnEingabeRest.Down then
  	Pkte := Required - StrToIntDef(EdPoints.Text, Required)
  else
    Pkte := StrToIntDef(EdPoints.Text, 0);

  if (Pkte > 180) or (Pkte < 0) then
  	Exit;

  if Pkte >= Required-1 then
  begin
		inc(fNoScoreCount);
  	if fNoScoreCount = 1 then
    begin
      if Pkte = 0 then
		  	WurfTxt := 'no score'
      else
		  	WurfTxt := 'busted'
		end
		else
	  	WurfTxt := '0 ' + StringOfChar('|', fNoScoreCount);
	end
	else begin
    WurfTxt := IntToStr(Pkte);
    fNoScoreCount := 0;
	end;

  if (Pkte < Required-1) or (fChecked and (Pkte=Required)) then
  begin
	  Required := Required - Pkte;
    PunkteDieserWurf := Pkte;
  end
  else
  	PunkteDieserWurf := 0;

  I := SGTafel.RowCount;
  SGTafel.RowCount := I + 1;
  SGTafel.Cells[0, I] := WurfTxt;
  SGTafel.Cells[1, I] := IntToStr(Required);

  Aktiv := False;
end;

procedure TPlayerX01.CancelThrow;
begin
	inherited CancelThrow;
end;

procedure TPlayerX01.LegWon;
begin
	inherited LegWon;
end;

procedure TPlayerX01.LegLost;
begin
	inherited LegLost;
end;

procedure TPlayerX01.BtnDoneClick(Sender: TObject);
begin
  ThrowDone;
end;

procedure TPlayerX01.BtnBackClick(Sender: TObject);
begin
  UndoThrow;
end;

function TPlayerX01.GetDoubleAverage: Integer;
begin
  if fFinishDarts = 0 then
  	Result := Round(100*fFinishes / fFinishDarts)
  else
	  Result := 0;
end;

function TPlayerX01.GetLegAverage: Double;
begin
	if fAufnahmen > 0 then
  	Result := fPunkteGeworfen / fAufnahmen;
end;

function TPlayerX01.GetGameAverage: Double;
begin

end;

procedure TPlayerX01.SetAktiv(AValue: Boolean);
begin
  inherited SetAktiv(AValue);
  PnlInput.Visible := AValue;
end;

procedure TPlayerX01.SetPCPlayer(AValue: Boolean);
begin
	if fPCPlayer=AValue then Exit;
	fPCPlayer:=AValue;
end;

procedure TPlayerX01.SetRequired(AValue: Integer);
begin
	fRequired := AValue;
  PnlRest.Caption := IntToStr(AValue);
end;


end.

