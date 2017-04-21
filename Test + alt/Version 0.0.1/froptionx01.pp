unit FrOptionx01;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, DartClasses,Controls, StdCtrls, TS_Edit;

type
	{ TFrOptx }

 TFrOptx = class(TFrSpielOptionen)
		CBxPunkte: TComboBox;
		EdBestOfLegs: TTSNumEdit;
		EdBestOfSets: TTSNumEdit;
		EdGewinnLegs: TTSNumEdit;
		EdGewinnSets: TTSNumEdit;
		LbBestOfLegs: TLabel;
		LbBestOfSets: TLabel;
		LbLegs: TLabel;
		LbLegsSuffix: TLabel;
		LbPunkte: TLabel;
		LbSets: TLabel;
		LbSetsSuffix: TLabel;
		XAllowTie: TCheckBox;
		XDoubleIn: TCheckBox;
		XDoubleOut: TCheckBox;
		procedure CBxPunkteChange(Sender: TObject);
		procedure EdBestOfLegsChange(Sender: TObject);
		procedure EdBestOfSetsChange(Sender: TObject);
		procedure EdGewinnLegsChange(Sender: TObject);
		procedure EdGewinnSetsChange(Sender: TObject);
	private
    ChangingSets: Boolean;
    ChangingLegs: Boolean;
	public
    constructor Create(AOwner: TComponent); override;
  	procedure StarteSpiel(SpielerListe: array of RSpieler); override;
	end;

implementation

uses
  Dialogs,
  DartFunctions;

{$R *.lfm}

{ TFrame1 }


{ TFrOptx }

procedure TFrOptx.CBxPunkteChange(Sender: TObject);
begin
  SpielName := CBxPunkte.Text;
end;

procedure TFrOptx.EdGewinnSetsChange(Sender: TObject);
begin
  if not ChangingSets then
	  try
			ChangingSets := True;
      EdBestOfSets.AsInteger := BestOf(EdGewinnSets.AsInteger, XAllowTie.Checked);
		finally
			ChangingSets := False;
		end;
end;

constructor TFrOptx.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
  CBxPunkte.Text := '501';
  MinAnzahlSpieler := 2;
  MaxAnzahlSpieler := 6;
  SpielName := '501';
  XDoubleIn.Checked := False;
  XDoubleOut.Checked := True;
  XAllowTie.Checked := False;
end;

procedure TFrOptx.StarteSpiel(SpielerListe: array of RSpieler);
begin
	ShowMessage('Spiel ' + SpielName + ' wurde Gestartet');
end;

procedure TFrOptx.EdBestOfSetsChange(Sender: TObject);
begin
  if not ChangingSets then
	  try
			ChangingSets := True;
      EdGewinnSets.AsInteger := NeedToWin(EdBestOfSets.AsInteger);
		finally
			ChangingSets := False;
		end;
end;

procedure TFrOptx.EdGewinnLegsChange(Sender: TObject);
var
	AllowTieLegs: Boolean;
begin
  if not ChangingLegs then
	  try
			ChangingLegs := True;
			AllowTieLegs := XAllowTie.Checked and (EdGewinnSets.AsInteger = 1);
      EdBestOfLegs.AsInteger := BestOf(EdGewinnLegs.AsInteger, AllowTieLegs );
		finally
			ChangingLegs := False;
		end;
end;

procedure TFrOptx.EdBestOfLegsChange(Sender: TObject);
begin
  if not ChangingLegs then
	  try
			ChangingLegs := True;
      if ((EdBestOfLegs.AsInteger MOD 2) <> 0)
      		and (not XAllowTie.Checked or (EdGewinnSets.AsInteger > 1))
      then
        EdBestOfLegs.AsInteger := EdBestOfLegs.AsInteger + 1;
      EdGewinnLegs.AsInteger := NeedToWin(EdBestOfLegs.AsInteger);
		finally
			ChangingLegs := False;
		end;
end;

end.

