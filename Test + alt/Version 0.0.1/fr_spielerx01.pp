unit fr_spielerx01;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Grids,
	Buttons, ComCtrls,
	DartClasses;

type

	{ TSpielerX01 }

	TSpielerX01 = class(TFrSpieler)
		BtnBack: TBitBtn;
		BtnFertig: TBitBtn;
		EdPunkte: TEdit;
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
	  procedure BtnFertigClick(Sender: TObject);
	private
		fAktiv: Boolean;
		fPCPlayer: Boolean;
		fRest: Integer;
    fSpieler: RSpieler;
    fAufnahmen: Integer;
    fPunkteGeworfen: Integer;
    fFinishDarts: Integer;
    fFinishes: Integer;
    fChecked: Boolean;
    fNoScoreCount: Integer;
    PunkteDieserWurf: Integer;
    fWurf: array of RWurf;
		function GetDoppelquote: Integer;
		function GetLegMittel: Double;
		function GetSpielMittel: Double;
		procedure SetPCPlayer(AValue: Boolean);
		procedure SetRest(AValue: Integer);
    procedure SpielerVorbereiten;
  protected
		procedure SetAktiv(AValue: Boolean); override;
	public
  	constructor Create(AOwner: TComponent; ASpieler: RSpieler); overload; override;

    procedure Neustart(Level: Integer); override;
    procedure WurfEingeben; override;
    procedure WurfZurueck; override;
    procedure WurfFertig; override;
    procedure WurfAbbruch; override;
  	procedure Gewonnen; override;
    procedure Verloren; override;

    property LegMittel: Double read GetLegMittel;
    property SpielMittel: Double read GetSpielMittel;
    property Doppelquote: Integer read GetDoppelquote;


    property PCPlayer: Boolean read fPCPlayer write SetPCPlayer;
    property Rest: Integer read fRest write SetRest;
	end;

implementation

uses
  DartConstants;

{$R *.lfm}

{ TSpielerX01 }

constructor TSpielerX01.Create(AOwner: TComponent; ASpieler: RSpieler);
begin
  inherited Create(AOwner, ASpieler);
  SpielerVorbereiten;
end;


procedure TSpielerX01.Neustart(Level: Integer);
begin
	inherited Neustart;
  EdPunkte.Clear;
  SGTafel.Clear;
  fChecked := False;
  fNoScoreCount := 0;
	//Rest := Modus.Punkte;
end;

procedure TSpielerX01.WurfEingeben;
begin
	inherited WurfEingeben;
	EdPunkte.Clear;
  if BtnEingabeBoard.Down then
  begin
//	Grafische Eingabe über Dartboard
	end
  else
	  EdPunkte.SetFocus;
end;

procedure TSpielerX01.SpielerVorbereiten;
begin
  fAufnahmen := 0;
  fPunkteGeworfen := 0;
  fFinishDarts := 0;
  fFinishes := 0;
	LbSetsLegs.Caption := '0 / 0';
	LbAverage.Caption := '---';
	LbFinish.Caption := '---';
end;

procedure TSpielerX01.WurfZurueck;
begin
	Aktiv := False;
  PunkteDieserWurf := -1;
end;

procedure TSpielerX01.WurfFertig;
var
  I, Pkte: Integer;
	WurfTxt: string;
begin
  if BtnEingabeRest.Down then
  	Pkte := Rest - StrToIntDef(EdPunkte.Text, Rest)
  else
    Pkte := StrToIntDef(EdPunkte.Text, 0);

  if (Pkte > 180) or (Pkte < 0) then
  	Exit;

  if Pkte >= Rest-1 then
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

  if (Pkte < Rest-1) or (fChecked and (Pkte=Rest)) then
  begin
	  Rest := Rest - Pkte;
    PunkteDieserWurf := Pkte;
  end
  else
  	PunkteDieserWurf := 0;

  I := SGTafel.RowCount;
  SGTafel.RowCount := I + 1;
  SGTafel.Cells[0, I] := WurfTxt;
  SGTafel.Cells[1, I] := IntToStr(Rest);

  Aktiv := False;
end;

procedure TSpielerX01.WurfAbbruch;
begin
	inherited WurfAbbruch;
end;

procedure TSpielerX01.Gewonnen;
begin
	inherited Gewonnen;
end;

procedure TSpielerX01.Verloren;
begin
	inherited Verloren;
end;

procedure TSpielerX01.BtnFertigClick(Sender: TObject);
begin
  WurfFertig;
end;

procedure TSpielerX01.BtnBackClick(Sender: TObject);
begin
  WurfZurueck;
end;

function TSpielerX01.GetDoppelquote: Integer;
begin
  if fFinishDarts = 0 then
  	Result := Round(100*fFinishes / fFinishDarts)
  else
	  Result := 0;
end;

function TSpielerX01.GetLegMittel: Double;
begin
	if fAufnahmen > 0 then
  	Result := fPunkteGeworfen / fAufnahmen;
end;

function TSpielerX01.GetSpielMittel: Double;
begin

end;

procedure TSpielerX01.SetAktiv(AValue: Boolean);
begin
  inherited SetAktiv(AValue);
  PnlInput.Visible := AValue;
end;

procedure TSpielerX01.SetPCPlayer(AValue: Boolean);
begin
	if fPCPlayer=AValue then Exit;
	fPCPlayer:=AValue;
end;

procedure TSpielerX01.SetRest(AValue: Integer);
begin
	fRest:=AValue;
  PnlRest.Caption := IntToStr(AValue);
end;


end.

