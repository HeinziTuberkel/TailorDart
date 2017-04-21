unit DartMain;

{$mode objfpc}{$H+}

interface

uses
  DartClasses, Fr_OptX01, Fr_OptShandy, Fr_OptMickeyMouse, Classes, SysUtils,
	FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls,
	PairSplitter, fr_spielerdaten, TS_FileINI, TS_Application;

type

  { TFrmDartMain }

  TFrmDartMain = class(TForm)
		BtnAddPlayer: TSpeedButton;
		BtnGameMickeyMouse: TSpeedButton;
		BtnGameShandy: TSpeedButton;
		BtnGameX01: TSpeedButton;
		BtnStart: TSpeedButton;
    BxOptionen: TGroupBox;
		BxSpiel: TGroupBox;
    Panel1: TPanel;
    ScBxSpielerListe: TScrollBox;
		ScBxOptionen: TScrollBox;
		ScrollBox1: TScrollBox;
		Splitter2: TSplitter;
		TSApplication1: TTSApplication;
		procedure BtnAddPlayerClick(Sender: TObject);
		procedure BtnGameMickeyMouseClick(Sender: TObject);
		procedure BtnGameX01Click(Sender: TObject);
		procedure BtnGameShandyClick(Sender: TObject);
		procedure BtnStartClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
	private
    fGameType: NGameType;
		function GetSpielArt: NGameType;
		procedure SetSpielArt(AValue: NGameType);
  private
    OptX01: TFrOptX01;
    OptShandy: TFrOptShandy;
    OptMickeyMouse: TFrOptMickeyMouse;
    Optionen: TFrSpielOptionen;
    Spieler: array of TFrSpielerDaten;
    procedure OnDelSpieler(Sender: TObject; SpielerNr: Integer);
  	procedure OnSpielerInfo(Sender: TObject; PlayerID: Integer);
    property SelectedGame: NGameType read GetSpielArt write SetSpielArt;
  public

  end;

var
  FrmDartMain: TFrmDartMain;

implementation

{$R *.lfm}

uses
  DartConstants, fr_dartboard, PlayDart;

{ TFrmDartMain }

procedure TFrmDartMain.BtnAddPlayerClick(Sender: TObject);
var
	I: Integer;
  Sp: RPlayer;
begin
	I := Length(Spieler);
  if Assigned(Optionen) and (I >= Optionen.MaxAnzahlSpieler) then
  	Exit;
  SetLength(Spieler, I+1);
  Spieler[I] := TFrSpielerDaten.Create(Self, I, @OnDelSpieler, @OnSpielerInfo);
	with Spieler[I] do
	begin
    Name := '';
    Parent := ScBxSpielerListe;
    Top := Height * I + 1;
    Align := alTop;
    Sp := SpielerDummy;
    SP.Nickname := SP.Nickname + ' (' + IntToStr(I+1) + ')';
    SpielerDaten := SP;
    EditSpieler;
	end;
  if Assigned(Optionen) and (I >= Optionen.MaxAnzahlSpieler) then
    BtnAddPlayer.Enabled := False;
end;

procedure TFrmDartMain.BtnGameMickeyMouseClick(Sender: TObject);
begin
  SetSpielArt(spielMickeyMouse);
end;

procedure TFrmDartMain.BtnGameX01Click(Sender: TObject);
begin
  SetSpielArt(spielX01);
end;

procedure TFrmDartMain.BtnGameShandyClick(Sender: TObject);
begin
  SetSpielArt(spielShandy);
end;

procedure TFrmDartMain.BtnStartClick(Sender: TObject);
begin
  FrmPlayDart.Show;


end;

procedure TFrmDartMain.FormCreate(Sender: TObject);
begin
  OptShandy := nil;
  OptMickeyMouse := nil;
  OptX01 := nil;
  Optionen := nil;
end;

procedure TFrmDartMain.FormShow(Sender: TObject);
begin
  SetSpielArt(NGameType(TSApp.INI.Int[iniDefaultGame] mod Integer(High(NGameType))));
end;

function TFrmDartMain.GetSpielArt: NGameType;
begin
  if (Optionen is TFrOptMickeyMouse) and BtnGameMickeyMouse.Down then
    Result := spielMickeyMouse
	else if (Optionen is TFrOptShandy) and BtnGameShandy.Down then
  	Result := spielShandy
	else if (Optionen is TFrOptX01) and BtnGameX01.Down then
	  Result := spielX01
  else
    Result := spielUnbekannt;
end;

procedure TFrmDartMain.SetSpielArt(AValue: NGameType);
begin
  if (AValue <> spielUnbekannt) and (GetSpielArt = AValue) then
    Exit;
  if Assigned(Optionen) then
  begin
		Optionen.Parent := nil;
	end;
	case AValue of
    spielShandy: begin
      if not Assigned(OptShandy) then
	      OptShandy := TFrOptShandy.Create(Self);
      Optionen := OptShandy;
      BtnGameShandy.Down := True;
		end;
    spielMickeyMouse: begin
      if not Assigned(OptMickeyMouse) then
	      OptMickeyMouse := TFrOptMickeyMouse.Create(Self);
      Optionen := OptMickeyMouse;
      BtnGameMickeyMouse.Down := True;
		end;
    else begin //X01
      if not Assigned(OptX01) then
	  		OptX01 := TFrOptX01.Create(Self);
      Optionen := OptX01;
      BtnGameX01.Down := True;
		end;
	end;
  with Optionen do
  begin
    Parent := ScBxOptionen; //BxOptionen;
    Align := alClient;
    Left := 0;
    Top := 0;
    Visible := True;
	end;
end;

procedure TFrmDartMain.OnDelSpieler(Sender: TObject; SpielerNr: Integer);
var
  I: Integer;
begin
  I := Length(Spieler);
  if not Assigned(Optionen) or (I > Optionen.MinAnzahlSpieler) then
	begin
  I := Low(Spieler);
  while I < High(Spieler) do
  	if Spieler[I] = Sender then
    begin
      Spieler[I].Free;
      while I < pred(High(Spieler)) do
      begin
      	Spieler[I] := Spieler[succ(I)];
        inc(I);
			end;
      SetLength(Spieler, I);
		end
    else
    	inc(I);
	end;

  if Assigned(Optionen) and (I <= Optionen.MinAnzahlSpieler) then
  begin
    for I := Low(Spieler) to High(Spieler) do

	end;

end;

procedure TFrmDartMain.OnSpielerInfo(Sender: TObject; PlayerID: Integer);
begin
	ShowMessage('Hier werden später ausführliche Spielerinformationen angezeigt.');
end;

end.

