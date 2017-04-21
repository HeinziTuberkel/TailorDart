unit GetSpieler;

{$mode objfpc}{$H+}

interface

uses
  IniFiles,
  DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
	 ValEdit, Grids, DbCtrls, StdCtrls, Buttons, TS_FileINI;

type

	{ TFrmGetSpieler }

 TFrmGetSpieler = class(TForm)
		BtnOK: TBitBtn;
		BtnCancel: TBitBtn;
    CBxAvatar: TComboBox;
		EdNachname: TEdit;
		CbxSpitzname: TComboBox;
		EdVorname: TEdit;
    ILAvatars: TImageList;
		LbVorname: TLabel;
		LbNachname: TLabel;
		LbNickname: TLabel;
    LbAvatar: TLabel;
		MRU: TTSFileINI;
		procedure BtnOKClick(Sender: TObject);
		procedure CbxSpitznameChange(Sender: TObject);
		procedure CbxSpitznameCloseUp(Sender: TObject);
		procedure CbxSpitznameEditingDone(Sender: TObject);
		procedure CbxSpitznameGetItems(Sender: TObject);
		procedure FormCreate(Sender: TObject);
	  procedure FormShow(Sender: TObject);
	private
    //Nachname: TStringList;
    //Vorname: TStringList;
    Farbe: TColor;
    SpielerID: Integer;
    DefaultSpieler: RSpieler;
		function GetSpieler: RSpieler;
		procedure SetSpieler(AValue: RSpieler);
    procedure UpdateEdits;
	public
   	procedure ReloadMRU;
    property Spieler: RSpieler read GetSpieler write SetSpieler;
	end;

var
	FrmGetSpieler: TFrmGetSpieler;

function SpielerLaden(DerSpieler: RSpieler): RSpieler; overload;
function SpielerLaden: RSpieler; overload;

implementation

uses
  DartConstants, DartFunctions,
	TSLibObjects;

function SpielerLaden(DerSpieler: RSpieler): RSpieler;
begin
  VerifyForm(TFrmGetSpieler, FrmGetSpieler, fdmCreate);
  with FrmGetSpieler do
  begin
    DefaultSpieler := DerSpieler;
    ShowModal;
    if ModalResult = mrOK then
		  Result := Spieler
    else
  	  Result := SpielerKeiner;
  end;
end;

function SpielerLaden: RSpieler;
var
  S: RSpieler;
begin
  Result := SpielerLaden(SpielerDummy);
end;

{$R *.lfm}

{ TFrmGetSpieler }

procedure TFrmGetSpieler.FormCreate(Sender: TObject);
begin
  DefaultSpieler := SpielerKeiner;
end;

procedure TFrmGetSpieler.FormShow(Sender: TObject);
begin
  ReloadMRU;
  Spieler := DefaultSpieler;
  CbxSpitzname.SetFocus;
end;

function TFrmGetSpieler.GetSpieler: RSpieler;
begin
  Result.ID := SpielerID;
  Result.Vorname := EdVorname.Text;
  Result.Nachname := EdNachname.Text;
  Result.Spitzname := CbxSpitzname.Text;
  Result.Farbe := Farbe;
end;

procedure TFrmGetSpieler.SetSpieler(AValue: RSpieler);
begin
	EdVorname.Text := AValue.Vorname;
	EdNachname.Text := AValue.Nachname;
	CbxSpitzname.Text := AValue.Spitzname;
  SpielerID := AValue.ID;
  Farbe := AValue.Farbe;
end;

procedure TFrmGetSpieler.ReloadMRU;
var
  I, Anz: Integer;
  S: string;
begin
  CbxSpitzname.Items.Clear;
  Anz := MRU.Int[iniSpielerNickname];
  for I := 1 to Anz do
  begin
    S := MRU.StrIdx[iniSpielerNickname, I];
    if (S > '') and (CbxSpitzname.Items.IndexOf(S)<0) then
	    CbxSpitzname.Items.AddObject(S, TObject(I));
	end;
  if not Derselbe(DefaultSpieler, SpielerKeiner)
  	and (CbxSpitzname.Items.IndexOf(DefaultSpieler.Spitzname)<0)
  then
  	CbxSpitzname.Items.InsertObject(0, DefaultSpieler.Spitzname,TObject(-1));
end;

procedure TFrmGetSpieler.BtnOKClick(Sender: TObject);
var
  Nr: Integer;
begin
  if CbxSpitzname.ItemIndex >= 0 then
  	Nr := succ(CbxSpitzname.ItemIndex)
  else begin
    Nr := succ(MRU.Int[iniSpielerNickname]);
    MRU.Int[iniSpielerNickname] := Nr;
	end;
  MRU.StrIdx[iniSpielerNickname, Nr] := CbxSpitzname.Text;
  MRU.StrIdx[iniSpielerNachname, Nr] := EdNachname.Text;
  MRU.StrIdx[iniSpielerVorname, Nr] := EdVorname.Text;
  MRU.IntIdx[iniSpielerFarbe, Nr] := Farbe;
end;

procedure TFrmGetSpieler.CbxSpitznameChange(Sender: TObject);
begin
  UpdateEdits;
end;

procedure TFrmGetSpieler.UpdateEdits;
var
  Nr: Integer;
begin
  with CbxSpitzname do
	  if (ItemIndex >= 0) then
    begin
      Nr := Integer(Items.Objects[ItemIndex]);
			if (Nr>0) then
			begin
				//CbxSpitzname.Text := MRU.StrIdx[iniSpielerNickname, Nr];
				EdNachname.Text := MRU.StrIdx[iniSpielerNachname, Nr];
				EdVorname.Text := MRU.StrIdx[iniSpielerVorname, Nr];
        Farbe := MRU.ColorIdx[iniSpielerFarbe, Nr];
			end
		  else if (Nr = -1) then
      begin
				//CbxSpitzname.Text := DefaultSpieler.Spitzname;
				EdNachname.Text := DefaultSpieler.Nachname;
				EdVorname.Text := DefaultSpieler.Vorname;
				Farbe := DefaultSpieler.Farbe;
			end;
		end;
end;

procedure TFrmGetSpieler.CbxSpitznameCloseUp(Sender: TObject);
begin
end;

procedure TFrmGetSpieler.CbxSpitznameEditingDone(Sender: TObject);
begin
end;

procedure TFrmGetSpieler.CbxSpitznameGetItems(Sender: TObject);
begin

end;

end.

