unit fr_spielerdaten;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, ExtCtrls;

type
  MSpielerDel = procedure (Sender: TObject; SpielerNr: Integer) of object;
	MSpielerInfo = procedure (Sender: TObject; PlayerID: Integer) of object;
  { TFrSpielerDaten }

  TFrSpielerDaten = class(TFrame)
		BtnIsVirtualPlayer: TSpeedButton;
    ImgAvatar: TImage;
    LbName: TLabel;
    LbNickName: TLabel;
    PnlSpielerDaten: TPanel;
    PnlBtns: TPanel;
    PnlName: TPanel;
    BtnDel: TSpeedButton;
    BtnEdit: TSpeedButton;
    BtnInfo: TSpeedButton;
		procedure BtnEditClick(Sender: TObject);
  	procedure BtnInfoClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
		procedure BtnIsVirtualPlayerClick(Sender: TObject);
  private
    fOnDel: MSpielerDel;
    fOnInfo: MSpielerInfo;
    fNr: Integer;
    fSpieler: RPlayer;
    fVirtualAllowed: Boolean;
    fIsVirtual: Boolean;
		function GetCanDelete: Boolean;
		procedure SetCanDelete(AValue: Boolean);
		procedure SetIsVirtual(AValue: Boolean);
  	procedure SetSpieler(AValue: RPlayer);
		procedure SetVirtualAllowed(AValue: Boolean);
    procedure UpdateDisplay;
  public
    constructor Create(TheOwner: TComponent; SpielerNr: Integer; OnDelete: MSpielerDel; OnInfo: MSpielerInfo);
    function PlayerID: Integer;
    procedure EditSpieler;
    property SpielerDaten: RPlayer read fSpieler write SetSpieler;
    property CanDelete: Boolean read GetCanDelete write SetCanDelete;
    property VirtualPlayerAllowed: Boolean read fVirtualAllowed write SetVirtualAllowed;
    property IsVirtualPlayer: Boolean read fIsVirtual write SetIsVirtual;
  end;

implementation

{$R *.lfm}

uses
  Graphics,
  DartConstants, GetPlayer, DartFunctions;

{ TFrSpielerDaten }

constructor TFrSpielerDaten.Create(TheOwner: TComponent; SpielerNr: Integer;
  																	OnDelete: MSpielerDel; OnInfo: MSpielerInfo);
begin
	inherited Create(TheOwner);
  fNr := SpielerNr;
  fOnDel := OnDelete;
  fOnInfo := OnInfo;
  fSpieler := SpielerKeiner;
  VirtualPlayerAllowed := True;
end;

procedure TFrSpielerDaten.BtnInfoClick(Sender: TObject);
begin
  if Assigned(fOnInfo) then
    fOnInfo(Self, PlayerID);
end;

procedure TFrSpielerDaten.BtnEditClick(Sender: TObject);
begin
  EditSpieler;
end;

procedure TFrSpielerDaten.BtnDelClick(Sender: TObject);
begin
  if Assigned(fOnDel) then
  	fOnDel(Self, fNr);
end;

procedure TFrSpielerDaten.BtnIsVirtualPlayerClick(Sender: TObject);
begin
	if IsVirtualPlayer = BtnIsVirtualPlayer.Down then
    Exit;
  if not VirtualPlayerAllowed then
    BtnIsVirtualPlayer.Down := False;
	IsVirtualPlayer := BtnIsVirtualPlayer.Down;
end;

procedure TFrSpielerDaten.SetSpieler(AValue: RPlayer);
begin
	if Derselbe(fSpieler, AValue) then Exit;
	fSpieler := AValue;
  UpdateDisplay;
end;

procedure TFrSpielerDaten.SetVirtualAllowed(AValue: Boolean);
begin
	fVirtualAllowed := AValue;
  BtnIsVirtualPlayer.Visible := AValue;
  if not fVirtualAllowed then
		IsVirtualPlayer := False;
end;

procedure TFrSpielerDaten.UpdateDisplay;
begin
  LbNickName.Caption := fSpieler.Nickname;
  LbName.Caption := fSpieler.FirstName + ' ' + fSpieler.LastName;
  PnlSpielerDaten.Color := fSpieler.Farbe;
end;

function TFrSpielerDaten.GetCanDelete: Boolean;
begin
  Result := BtnDel.Visible;
end;

procedure TFrSpielerDaten.SetCanDelete(AValue: Boolean);
begin
	BtnDel.Visible := AValue;
end;

procedure TFrSpielerDaten.SetIsVirtual(AValue: Boolean);
begin
  fIsVirtual := AValue and VirtualPlayerAllowed;
	BtnIsVirtualPlayer.Down := fIsVirtual;
  if fIsVirtual then
  begin
	  fSpieler.LastName := 'Ich (dieser Computer)';
	  fSpieler.FirstName := '';
	  fSpieler.Nickname := 'Virtual Darter';
	  fSpieler.ID := 0;
    fSpieler.Farbe := clMaroon;
    UpdateDisplay;
  end
  else begin
		EditSpieler;
    UpdateDisplay;
	end;
end;

function TFrSpielerDaten.PlayerID: Integer;
begin

end;

procedure TFrSpielerDaten.EditSpieler;
var
  Tmp: RPlayer;
begin
  if Derselbe(fSpieler, SpielerKeiner) then
	  Tmp := LoadPlayer(SpielerDummy)
	else
	  Tmp := LoadPlayer(fSpieler);
  if not Derselbe(Tmp, SpielerKeiner) then
		SpielerDaten := Tmp;
end;

end.

