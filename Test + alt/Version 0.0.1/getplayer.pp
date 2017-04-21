unit GetPlayer;

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
		EdLastName: TEdit;
		CbxNickname: TComboBox;
		EdFirstName: TEdit;
    ILAvatars: TImageList;
		LbFirstName: TLabel;
		LbLastName: TLabel;
		LbNickname: TLabel;
    LbAvatar: TLabel;
		MRU: TTSFileINI;
		procedure BtnOKClick(Sender: TObject);
		procedure CbxNicknameChange(Sender: TObject);
		procedure CbxNicknameCloseUp(Sender: TObject);
		procedure CbxNicknameEditingDone(Sender: TObject);
		procedure CbxNicknameGetItems(Sender: TObject);
		procedure FormCreate(Sender: TObject);
	  procedure FormShow(Sender: TObject);
	private
    //LastName: TStringList;
    //FirstName: TStringList;
    Farbe: TColor;
    PlayerID: Integer;
    DefaultSpieler: RPlayer;
		function GetSpieler: RPlayer;
		procedure SetSpieler(AValue: RPlayer);
    procedure UpdateEdits;
	public
   	procedure ReloadMRU;
    property Spieler: RPlayer read GetSpieler write SetSpieler;
	end;

var
	FrmGetSpieler: TFrmGetSpieler;

function LoadPlayer(DerSpieler: RPlayer): RPlayer; overload;
function LoadPlayer: RPlayer; overload;

implementation

uses
  DartConstants, DartFunctions,
	TSLibObjects;

function LoadPlayer(DerSpieler: RPlayer): RPlayer;
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

function LoadPlayer: RPlayer;
var
  S: RPlayer;
begin
  Result := LoadPlayer(SpielerDummy);
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
  CbxNickname.SetFocus;
end;

function TFrmGetSpieler.GetSpieler: RPlayer;
begin
  Result.ID := PlayerID;
  Result.FirstName := EdFirstName.Text;
  Result.LastName := EdLastName.Text;
  Result.Nickname := CbxNickname.Text;
  Result.Farbe := Farbe;
end;

procedure TFrmGetSpieler.SetSpieler(AValue: RPlayer);
begin
	EdFirstName.Text := AValue.FirstName;
	EdLastName.Text := AValue.LastName;
	CbxNickname.Text := AValue.Nickname;
  PlayerID := AValue.ID;
  Farbe := AValue.Farbe;
end;

procedure TFrmGetSpieler.ReloadMRU;
var
  I, Anz: Integer;
  S: string;
begin
  CbxNickname.Items.Clear;
  Anz := MRU.Int[iniSpielerNickname];
  for I := 1 to Anz do
  begin
    S := MRU.StrIdx[iniSpielerNickname, I];
    if (S > '') and (CbxNickname.Items.IndexOf(S)<0) then
	    CbxNickname.Items.AddObject(S, TObject(PtrUint(I)));
	end;
  if not Derselbe(DefaultSpieler, SpielerKeiner)
  	and (CbxNickname.Items.IndexOf(DefaultSpieler.Nickname)<0)
  then
  	CbxNickname.Items.InsertObject(0, DefaultSpieler.Nickname,TObject(-1));
end;

procedure TFrmGetSpieler.BtnOKClick(Sender: TObject);
var
  Nr: Integer;
begin
  if CbxNickname.ItemIndex >= 0 then
  	Nr := succ(CbxNickname.ItemIndex)
  else begin
    Nr := succ(MRU.Int[iniSpielerNickname]);
    MRU.Int[iniSpielerNickname] := Nr;
	end;
  MRU.StrIdx[iniSpielerNickname, Nr] := CbxNickname.Text;
  MRU.StrIdx[iniSpielerLastName, Nr] := EdLastName.Text;
  MRU.StrIdx[iniSpielerVorname, Nr] := EdFirstName.Text;
  MRU.IntIdx[iniSpielerFarbe, Nr] := Farbe;
end;

procedure TFrmGetSpieler.CbxNicknameChange(Sender: TObject);
begin
  UpdateEdits;
end;

procedure TFrmGetSpieler.UpdateEdits;
var
  Nr: Integer;
begin
  with CbxNickname do
	  if (ItemIndex >= 0) then
    begin
      Nr := PtrUint(Items.Objects[ItemIndex]);
			if (Nr>0) then
			begin
				//CbxNickname.Text := MRU.StrIdx[iniSpielerNickname, Nr];
				EdLastName.Text := MRU.StrIdx[iniSpielerLastName, Nr];
				EdFirstName.Text := MRU.StrIdx[iniSpielerVorname, Nr];
        Farbe := MRU.ColorIdx[iniSpielerFarbe, Nr];
			end
		  else if (Nr = -1) then
      begin
				//CbxNickname.Text := DefaultSpieler.Nickname;
				EdLastName.Text := DefaultSpieler.LastName;
				EdFirstName.Text := DefaultSpieler.FirstName;
				Farbe := DefaultSpieler.Farbe;
			end;
		end;
end;

procedure TFrmGetSpieler.CbxNicknameCloseUp(Sender: TObject);
begin
end;

procedure TFrmGetSpieler.CbxNicknameEditingDone(Sender: TObject);
begin
end;

procedure TFrmGetSpieler.CbxNicknameGetItems(Sender: TObject);
begin

end;

end.

