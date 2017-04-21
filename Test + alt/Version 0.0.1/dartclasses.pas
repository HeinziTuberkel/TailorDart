unit DartClasses;

{$mode objfpc}{$H+}

interface

uses
  Graphics,
  Forms,
  Classes,
  SysUtils;


type

  NGameType = (spielUnbekannt, spielX01, spielShandy, spielMickeyMouse);
  NWireRadius = (drBullEyeI, drBullEyeA,
  								drBullI, drBullA,
                  drTripleII, drTripleIA, drTripleAI, drTripleAA,
                  drDoubleII, drDoubleIA, drDoubleAI, drDoubleAA,
                  drBoard, drBounceOff);
  NRadius = (radBullEye, radBull, radSingleInnen, radTriple,
  						radSingleAussen, radDouble, radAussen, radBounceOff);
//Version für Segmentzählung im Uhrzeigersinn.
//  NSegment = (fld6, fld10, fld15, fld2, fld17, fld3, fld19, fld7, fld16, fld8,
//  					fld11, fld14, fld9, fld12, fld5, fld20, fld1, fld18, fld4, fld13);

//Version für Segmentzählung im mathematischen Drehsinn.
  NSegment = (fld6, fld13, fld4, fld18, fld1, fld20, fld5, fld12, fld9, fld14,
  					fld11, fld8, fld16, fld7, fld19, fld3, fld17, fld2, fld15, fld10);


  //Bestimmt, wann ein Leg beendet ist
  NLegType = (ltWinnerFirst,	//...wenn ein Spieler LegWon hat
  						ltWinnerLast,		//...wenn nur ein Spieler noch nicht beendet hat.
              ltWinnerAll,		//...wenn alle Spieler ihr Leg geschlossen haben.
  						ltLostFirst,		//...wenn ein Spieler ausgeschieden ist.
              ltLostLast,			//...wenn nur ein Spieler noch nicht ausgeschieden ist
              ltLostAll);			//...wenn alle Spieler ausgeschieden sind.

  TFrPlayer = class;

  RDartPolar = record
    Radius: NRadius;
    Segment: NSegment;
    Punkte: Integer;
	end;

  RBoardPosition = record
    X, Y: Integer;
    Radius: NRadius;
    Segment: NSegment;
    Score: Integer;
	end;

  RPlayer = record
    ID: Integer;
  	FirstName, LastName, Nickname: string;
    Farbe: TColor;
	end;

  RThrow = record
    Dart1, Dart2, Dart3: RBoardPosition;
    Score: Integer;
	end;

  MThrow = procedure(Sender: TFrPlayer; Wurf: RThrow) of object;
  MThrowUndo = procedure(Sender: TFrPlayer);
  MLegWon = procedure(Sender: TFrPlayer);
  MLegLost = procedure(Sender: TFrPlayer);

	{ TFrPlayer }

  TFrPlayer = class(TFrame)
	private
    fGameType: NGameType;
		fAktiv: Boolean;
		fGewonnen: MLegWon;
		fLastName: string;
		fPlayerID: Integer;
		fSpitzname: string;
		fVerloren: MLegLost;
		fVorname: string;
		fWurf: RThrow;
		fWurfAbbruch: MThrowUndo;
		fWurfFertig: MThrow;
		fWurfNr: Integer;
    fWuerfe: array of RThrow;
  	function GetFullName: string;
		function GetWurf(Nr: Integer): RThrow;
		procedure SetLastName(AValue: string);
		procedure SetPlayerID(AValue: Integer);
		procedure SetSpitzname(AValue: string);
		procedure SetVorname(AValue: string);
  protected
		procedure SetAktiv(AValue: Boolean); virtual;
  public
    AktiverWurf: RThrow;
  	constructor Create(TheGameType: NGameType; AOwner: TComponent; ThePlayer: RPlayer); reintroduce; virtual;

    procedure Restart(Level: Integer=0); virtual;
    procedure GetThrow; virtual;
    procedure UndoThrow; virtual;
    procedure ThrowDone; virtual;
    procedure CancelThrow; virtual;
  	procedure LegWon; virtual;
    procedure LegLost; virtual;

    property PlayerID: Integer read fPlayerID write SetPlayerID;
    property LastName: string read fLastName write SetLastName;
    property FirstName: string read fVorname write SetVorname;
    property Nickname: string read fSpitzname write SetSpitzname;
    property FullName: string read GetFullName;
    property WurfNr: Integer read fWurfNr;
		property Wurf[Nr: Integer]: RThrow read GetWurf; default;
    property Aktiv: Boolean read fAktiv write SetAktiv;

    property OnWurfFertig: MThrow read fWurfFertig write fWurfFertig;
    property OnWurfAbbruch: MThrowUndo read fWurfAbbruch write fWurfAbbruch;
    property OnGewonnen: MLegWon read fGewonnen write fGewonnen;
    property OnVerloren: MLegLost read fVerloren write fVerloren;
	end;

  TPlayerClass = class of TFrPlayer;

	{ TFrSpielOptionen }

	TFrSpielOptionen = class(TFrame)
	private
		fName: string;
 protected
		fMaxSpieler: Integer;
		fMinSpieler: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    property SpielName: string read fName write fName;
  	property MinAnzahlSpieler: Integer read fMinSpieler write fMinSpieler;
  	property MaxAnzahlSpieler: Integer read fMaxSpieler write fMaxSpieler;
  	procedure StarteSpiel(SpielerListe: array of RPlayer); virtual; abstract;
	end;


	{ TFrmDarts }

 // TFrmDarts = class(TForm)
	//private
	//	fAnzSpieler: Integer;
	//	fLegs: Integer;
	//	fLegTyp: NLegType;
	//	fSets: Integer;
 //   fSpieler: array of TFrPlayer;
	//	fSpielerKlasse: TPlayerClass;
	//	function GetBestOfLegs: Integer;
	//	function GetBestOfSets: Integer;
	//	function GetSpieler(Idx: Integer): TFrPlayer;
	//	procedure SetAnzSpieler(AValue: Integer);
	//	procedure SetBestOfLegs(AValue: Integer);
	//	procedure SetBestOfSets(AValue: Integer);
	//	procedure SetLegs(AValue: Integer);
	//	procedure SetSets(AValue: Integer);
 // public
 //   property SpielerKlasse: TPlayerClass read fSpielerKlasse write fSpielerKlasse;
 //   function AddSpieler: TFrPlayer;
 //   procedure RemoveSpieler(Idx: Integer);
 //   property AnzahlSpieler: Integer read fAnzSpieler write SetAnzSpieler;
 //   property Spieler[Idx: Integer]: TFrPlayer read GetSpieler;
 //   property LegTyp: NLegType read fLegTyp write fLegTyp default ltWinnerFirst;
 //   property LegsToWin: Integer read fLegs write SetLegs;
 //   property SetsToWin: Integer read fSets write SetSets;
 //   property BestOfLegs: Integer read GetBestOfLegs write SetBestOfLegs;
 //   property BestOfSets: Integer read GetBestOfSets write SetBestOfSets;
 // end;


var
  DartNULL: RBoardPosition;
  WurfNULL: RThrow;


operator = (D1, D2: RDartPolar): Boolean;
operator = (P1, P2: TPoint): Boolean;
operator = (P1, P2: RBoardPosition): Boolean;
operator = (W1, W2: RThrow): Boolean;
operator = (S1, S2: RPlayer): Boolean;

implementation

uses
	Controls,
  DartConstants,
	TSLib, GetPlayer;

operator = (D1, D2: RDartPolar): Boolean;
begin
  Result := (D1.Segment = D2.Segment) and (D1.Radius=D2.Radius);
end;

operator = (P1, P2: TPoint): Boolean;
begin
  Result := (P1.x = P2.x) and (P1.y = P2.y);
end;

operator = (P1, P2: RBoardPosition): Boolean;
begin
  Result := (P1.X=P2.X) and (P1.Y=P2.Y);
end;

operator = (W1, W2: RThrow): Boolean;
begin
  Result := (W1.Dart1=W2.Dart1) and (W1.Dart2=W2.Dart2) and (W1.Dart3=W2.Dart3) and (W1.Score=W2.Score);
end;

operator=(S1, S2: RPlayer): Boolean;
begin
  Result := ((S1.ID<>0) and (S1.ID = S2.ID))
  			or ((S1.ID=0)
		    		and (S1.FirstName=S2.FirstName)
    				and (S1.LastName=S2.LastName)
    				and (S1.Nickname=S2.Nickname)
        );
end;

{ TFrSpielOptionen }

constructor TFrSpielOptionen.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  MinAnzahlSpieler := 2;
  MaxAnzahlSpieler := 2;
  SpielName := 'unbekanntes Dartspiel';
end;

{ TFrmDarts }

//function TFrmDarts.GetBestOfLegs: Integer;
//begin
//	Result := fLegs * 2 - 1;
//end;
//
//function TFrmDarts.GetBestOfSets: Integer;
//begin
//	Result := fSets * 2 - 1
//end;
//
//function TFrmDarts.GetSpieler(Idx: Integer): TFrPlayer;
//begin
//	if Between(Idx, 0, Length(fSpieler), bndLo) then
//		Result := fSpieler[Idx]
//	else
//  	Result := nil;
//end;
//
//procedure TFrmDarts.SetAnzSpieler(AValue: Integer);
//begin
//	if fAnzSpieler=AValue then Exit;
//  while AValue < fAnzSpieler do
//  	RemoveSpieler(AValue);
//  while AValue > fAnzSpieler do
//  	AddSpieler;
//end;
//
//procedure TFrmDarts.SetBestOfLegs(AValue: Integer);
//begin
//	fLegs := (AValue + 1) DIV 2;
//  if fLegs < 1 then
//    fLegs := 1;
//end;
//
//procedure TFrmDarts.SetBestOfSets(AValue: Integer);
//begin
//	fSets := (AValue + 1) DIV 2;
//  if fSets < 1 then
//    fSets := 1;
//end;
//
//procedure TFrmDarts.SetLegs(AValue: Integer);
//begin
//	if fLegs=AValue then Exit;
//	fLegs:=AValue;
//end;
//
//procedure TFrmDarts.SetSets(AValue: Integer);
//begin
//	if fSets=AValue then Exit;
//	fSets:=AValue;
//end;
//
//function TFrmDarts.AddSpieler: TFrPlayer;
//var
//  N: Integer;
//	Sp: RPlayer;
//begin
//	SP := LoadPlayer;
//  if SP = SpielerKeiner then
//  begin
//  	fAnzSpieler := Length(fSpieler);
//    Result := nil;
//	end
//	else begin
//    N := Length(fSpieler);
//    SetLength(fSpieler, N+1);
//    fSpieler[N] := fSpielerKlasse.Create(Self, SP);
//    fSpieler[N].Parent := Self;
//    fSpieler[N].Align := alLeft;
//    fSpieler[N].Left := fSpieler[N].Width * N + 1;
//	end;
//end;
//
//procedure TFrmDarts.RemoveSpieler(Idx: Integer);
//var
//  L, I: Integer;
//begin
//  if Between(Idx, 0, Length(fSpieler), bndLo) then
//  begin
//    fSpieler[Idx].Free;
//    L := Length(fSpieler);
//    while Idx < pred(L) do
//      fSpieler[Idx] := fSpieler[Idx+1];
//    SetLength(fSpieler, L-1)
//	end;
//end;

{ TFrPlayer }

constructor TFrPlayer.Create(TheGameType: NGameType; AOwner: TComponent; ThePlayer: RPlayer);
begin
	inherited Create(AOwner);
  fGameType := TheGameType;
  if ThePlayer.ID > 0 then
  	fPlayerID := ThePlayer.ID
  else
  	fPlayerID := 0;
	fLastName := ThePlayer.LastName;
  fVorname := ThePlayer.FirstName;
  fSpitzname := ThePlayer.Nickname;
end;

procedure TFrPlayer.Restart(Level: Integer);
begin
	fWurfNr := 0;
	SetLength(fWuerfe, 0);
end;

procedure TFrPlayer.GetThrow;
begin
	Aktiv := True;
end;

procedure TFrPlayer.UndoThrow;
begin
	if WurfNr > 0 then
  begin
    dec(fWurfNr);
    SetLength(fWuerfe, fWurfNr);
	end;
end;

procedure TFrPlayer.ThrowDone;
begin
  if Aktiv and (AktiverWurf <> WurfNULL) then
  begin
	  Aktiv := False;
    SetLength(fWuerfe, WurfNr+1);
  	fWuerfe[WurfNr] := AktiverWurf;
    inc(fWurfNr);
    AktiverWurf := WurfNULL;
	end;
	if Assigned(fWurfFertig) then
  	fWurfFertig(Self, Wurf[WurfNr]);
end;

procedure TFrPlayer.CancelThrow;
begin
  Aktiv := False;
  AktiverWurf := WurfNULL;
  if Assigned(fWurfAbbruch) then
  	fWurfAbbruch(Self);
end;

procedure TFrPlayer.LegWon;
begin
	if Assigned(fGewonnen) then
  	fGewonnen(Self);
end;

procedure TFrPlayer.LegLost;
begin
	if Assigned(fVerloren) then
  	fVerloren(Self);
end;

function TFrPlayer.GetFullName: string;
begin
  if fVorname >'' then
  begin
    if fLastName > '' then
    	Result := fVorname + ' ' + fLastName
    else
    	Result := fVorname;
	end
  else
		Result := fLastName ;
end;

function TFrPlayer.GetWurf(Nr: Integer): RThrow;
begin
	if Nr <= fWurfNr then
  	Result := fWuerfe[Nr]
  else
  	Result := WurfNULL;
end;

procedure TFrPlayer.SetAktiv(AValue: Boolean);
begin
	fAktiv := AValue;
  Enabled := fAktiv;
end;

procedure TFrPlayer.SetLastName(AValue: string);
begin
	if fLastName=AValue then Exit;
	fLastName:=AValue;
end;

procedure TFrPlayer.SetPlayerID(AValue: Integer);
begin
	if fPlayerID=AValue then Exit;
	fPlayerID:=AValue;
end;

procedure TFrPlayer.SetSpitzname(AValue: string);
begin
	if fSpitzname=AValue then Exit;
	fSpitzname:=AValue;
end;

procedure TFrPlayer.SetVorname(AValue: string);
begin
	if fVorname=AValue then Exit;
	fVorname:=AValue;
end;


initialization
	DartNULL.X := rectNULL.X;
	DartNULL.Y := rectNULL.Y;
  DartNULL.Score := -1;
  DartNULL.Radius := radBounceOff;
  DartNULL.Segment := fld1;

  WurfNULL.Dart1 := DartNULL;
  WurfNULL.Dart2 := DartNULL;
  WurfNULL.Dart3 := DartNULL;
  WurfNULL.Score := 0;

finalization


end.

