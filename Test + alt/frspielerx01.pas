unit frspielerX01;

{$mode objfpc}{$H+}

interface

uses
	DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Grids,
	Buttons, ComCtrls;

type

	{ TSpielerX01 }

	TSpielerX01 = class(TFrame)
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
		procedure BtnEingabeBoardClick(Sender: TObject);
  procedure BtnFertigClick(Sender: TObject);
		procedure EdPunkteChange(Sender: TObject);
		procedure LbNameClick(Sender: TObject);
	private
		fAktiv: Boolean;
		fLegsWon: Integer;
		fPCPlayer: Boolean;
		fRest: Integer;
		fSetsWon: Integer;
    fSpieler: RSpieler;
		fX01Modus: RX01Modus;
    fAufnahmen: Integer;
    fPunkteGeworfen: Integer;
    fFinishDarts: Integer;
    fFinishes: Integer;
    fChecked: Boolean;
    fNoScoreCount: Integer;
    PunkteDieserWurf: Integer;
    fWurf: array of RWurf;
		function GetAverage: Double;
		function GetFinish: Integer;
		procedure SetAktiv(AValue: Boolean);
		procedure SetLegsWon(AValue: Integer);
		procedure SetPCPlayer(AValue: Boolean);
		procedure SetRest(AValue: Integer);
		procedure SetSetsWon(AValue: Integer);
		procedure SetSpieler(AValue: RSpieler);
		procedure SetWurf(Idx: Integer; AValue: Integer);
		procedure SetX01Modus(AValue: RX01Modus);
    procedure SpielerVorbereiten;
	public
  	constructor Create(AOwner: TComponent; ASpieler: RSpieler; AModus: RX01Modus); overload; reintroduce;
  	constructor Create(AOwner: TComponent; ASpieler: RSpieler); overload; reintroduce;
    procedure LegStarten;
    function Werfen: Integer;
    procedure WurfZurueck;
    procedure WurfFertig;
    procedure WurfAbbrechen;

    function Wurf(Nr: Integer): RWurf;
    function WurfNr: Integer;


  	property Spieler: RSpieler read fSpieler write SetSpieler;
    property LegsGewonnen: Integer read fLegsWon write SetLegsWon;
    property SetsGewonnen: Integer read fSetsWon write SetSetsWon;
    property Average: Double read GetAverage;
    property Finish: Integer read GetFinish;

    property Modus: RX01Modus read fX01Modus write SetX01Modus;
    property PCPlayer: Boolean read fPCPlayer write SetPCPlayer;
    property Rest: Integer read fRest write SetRest;
    property Aktiv: Boolean read fAktiv write SetAktiv;
	end;

implementation

{$R *.lfm}

{ TSpielerX01 }

constructor TSpielerX01.Create(AOwner: TComponent; ASpieler: RSpieler; AModus: RX01Modus);
begin
  Name := '';
  Spieler := ASpieler;
  Modus := AModus;
  SpielerVorbereiten;
end;

constructor TSpielerX01.Create(AOwner: TComponent; ASpieler: RSpieler);
begin
	Create(AOwner, ASpieler, Modus501);
end;

procedure TSpielerX01.SpielerVorbereiten;
begin
	SetsGewonnen := 0;
  LegsGewonnen := 0;
  fAufnahmen := 0;
  fPunkteGeworfen := 0;
  fFinishDarts := 0;
  fFinishes := 0;
	LbSetsLegs.Caption := '0 / 0';
	LbAverage.Caption := '---';
	LbFinish.Caption := '---';
end;

procedure TSpielerX01.LegStarten;
begin
	Aktiv := False;
  EdPunkte.Clear;
  SGTafel.Clear;
  fChecked := False;
  fNoScoreCount := 0;
	Rest := Modus.Punkte;
end;


function TSpielerX01.Werfen: Integer;
begin
  Aktiv := True;
	EdPunkte.Clear;

  if BtnEingabeBoard.Down then
  begin
//	Grafische Eingabe über Dartboard
	end
  else
	  EdPunkte.SetFocus;

	repeat
  	Application.ProcessMessages;
	until not fAktiv or Application.Terminated;

  Result := PunkteDieserWurf;
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

procedure TSpielerX01.WurfAbbrechen;
begin
  Aktiv := False;
end;

function TSpielerX01.Wurf(Nr: Integer): RWurf;
begin

end;

function TSpielerX01.WurfNr: Integer;
begin

end;



procedure TSpielerX01.BtnFertigClick(Sender: TObject);
begin
  WurfFertig;
end;

procedure TSpielerX01.BtnBackClick(Sender: TObject);
begin
  WurfZurueck;
end;

procedure TSpielerX01.BtnEingabeBoardClick(Sender: TObject);
begin

end;

procedure TSpielerX01.EdPunkteChange(Sender: TObject);
begin

end;

procedure TSpielerX01.LbNameClick(Sender: TObject);
begin

end;

function TSpielerX01.GetAverage: Double;
begin
	if fAufnahmen > 0 then
  	Result := fPunkteGeworfen / fAufnahmen;
end;

function TSpielerX01.GetFinish: Integer;
begin
  if fFinishDarts = 0 then
  	Result := Round(100*fFinishes / fFinishDarts)
  else
	  Result := 0;
end;

procedure TSpielerX01.SetAktiv(AValue: Boolean);
begin
	if fAktiv=AValue then Exit;
	fAktiv:=AValue;
  if fAktiv then
  	PnlInput.Show
  else
  	PnlInput.Hide;
end;

procedure TSpielerX01.SetLegsWon(AValue: Integer);
begin
	fLegsWon:=AValue;
	LbSetsLegs.Caption := IntToStr(SetsGewonnen) + ' / ' + IntToStr(fLegsWon);
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

procedure TSpielerX01.SetSetsWon(AValue: Integer);
begin
	fSetsWon:=AValue;
	LbSetsLegs.Caption := IntToStr(SetsGewonnen) + ' / ' + IntToStr(fLegsWon);
end;

procedure TSpielerX01.SetSpieler(AValue: RSpieler);
begin
	fSpieler := AValue;
  LbName.Caption := AValue.Spitzname;
end;

procedure TSpielerX01.SetWurf(Idx: Integer; AValue: Integer);
begin

end;

procedure TSpielerX01.SetX01Modus(AValue: RX01Modus);
begin
	fX01Modus:=AValue;
end;

end.

