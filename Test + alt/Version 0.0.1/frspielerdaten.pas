unit FrSpielerDaten;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, ExtCtrls;

type
  MSpielerDel = procedure (Sender: TObject; SpielerNr: Integer) of object;
	MSpielerInfo = procedure (Sender: TObject; SpielerID: Integer) of object;
  { TFrSpielerDaten }

  TFrSpielerDaten = class(TFrame)
    ImgAvatar: TImage;
    LbName: TLabel;
    LbNickName: TLabel;
    Panel1: TPanel;
    PnlBtns: TPanel;
    PnlName: TPanel;
    BtnDel: TSpeedButton;
    BtnEdit: TSpeedButton;
    BtnInfo: TSpeedButton;
		procedure BtnEditClick(Sender: TObject);
  	procedure BtnInfoClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    fOnDel: MSpielerDel;
    fOnInfo: MSpielerInfo;
    fNr: Integer;
    fSpieler: RSpieler;
		procedure SetSpieler(AValue: RSpieler);
  public
    constructor Create(TheOwner: TComponent; SpielerNr: Integer; OnDelete: MSpielerDel; OnInfo: MSpielerInfo);
    function SpielerID: Integer;
    procedure EditSpieler;
    property SpielerDaten: RSpieler read fSpieler write SetSpieler;
  end;

implementation

{$R *.lfm}

uses
  DartConstants, GetSpieler, DartFunctions;

{ TFrSpielerDaten }

constructor TFrSpielerDaten.Create(TheOwner: TComponent; SpielerNr: Integer;
  																	OnDelete: MSpielerDel; OnInfo: MSpielerInfo);
begin
	inherited Create(TheOwner);
  fNr := SpielerNr;
  fOnDel := OnDelete;
  fOnInfo := OnInfo;
  fSpieler := SpielerKeiner;
end;

procedure TFrSpielerDaten.BtnInfoClick(Sender: TObject);
begin
  if Assigned(fOnInfo) then
    fOnInfo(Self, SpielerID);
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

procedure TFrSpielerDaten.SetSpieler(AValue: RSpieler);
begin
	if Derselbe(fSpieler, AValue) then Exit;
	fSpieler := AValue;
  LbNickName.Caption := fSpieler.Spitzname;
  LbName.Caption := fSpieler.Vorname + ' ' + fSpieler.Nachname;
end;

function TFrSpielerDaten.SpielerID: Integer;
begin

end;

procedure TFrSpielerDaten.EditSpieler;
var
  Tmp: RSpieler;
begin
  if Derselbe(fSpieler, SpielerKeiner) then
	  Tmp := SpielerLaden(SpielerDummy)
	else
	  Tmp := SpielerLaden(fSpieler);
  if not Derselbe(Tmp, SpielerKeiner) then
		SpielerDaten := Tmp;
end;

end.

