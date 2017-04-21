unit Fr_OptX01;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, TS_Edit,
  DartClasses;

type

	{ TFrOptX01 }

 TFrOptX01 = class(TFrSpielOptionen)
		CBxPunkte: TComboBox;
		LbBestOfLegs: TLabel;
		LbBestOfSets: TLabel;
		LbFirstToLegs: TLabel;
		LbLegs: TLabel;
		LbPunkte: TLabel;
		LbFirstToSets: TLabel;
		LbSets: TLabel;
		EdFirstToSets: TTSNumEdit;
		EdFirstToLegs: TTSNumEdit;
		EdBestOfSets: TTSNumEdit;
		EdBestOfLegs: TTSNumEdit;
		XAllowTie: TCheckBox;
		XDoubleIn: TCheckBox;
		XDoubleOut: TCheckBox;
		procedure EdBestOfLegsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
  procedure EdBestOfSetsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
	procedure EdFirstToLegsAcceptValue(Sender: TObject; var Value: Extended;
		var AcceptAction: NTSAcceptAction);
  procedure EdFirstToSetsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
	private
   CalcLegsSets: Boolean;
	public
		constructor Create(AOwner: TComponent); override;
   	procedure StarteSpiel(SpielerListe: array of RPlayer); override;
	end;

implementation

{$R *.lfm}

uses
  Dialogs, DartFunctions;

{ TFrOptX01 }

procedure TFrOptX01.EdFirstToSetsAcceptValue(Sender: TObject; var Value: Extended; var AcceptAction: NTSAcceptAction);
var
  Sets: Integer;
begin
  if not CalcLegsSets then
  	try
      CalcLegsSets := True;
  	  Sets := BestOf(Round(Value), XAllowTie.Checked);
      EdBestOfSets.AsInteger := Sets;
      if Sets > 1 then
        EdBestOfLegs.AsInteger := EdBestOfLegs.AsInteger + 1 - Round(EdBestOfLegs.AsInteger) MOD 2;
		finally
      CalcLegsSets := False;
		end;
end;

procedure TFrOptX01.EdBestOfSetsAcceptValue(Sender: TObject; var Value: Extended; var AcceptAction: NTSAcceptAction);
var
  Sets: Integer;
begin
  if not CalcLegsSets then
  	try
      CalcLegsSets := True;
      if not XAllowTie.Checked then
        Value := Value + 1 - Round(Value) MOD 2;
  	  Sets := NeedToWin(Round(Value), XAllowTie.Checked);
      EdFirstToSets.AsInteger := Sets;
      if Sets > 1 then
        EdBestOfLegs.AsInteger := EdBestOfLegs.AsInteger + 1 - Round(EdBestOfLegs.AsInteger) MOD 2;
		finally
      CalcLegsSets := False;
		end;
end;

procedure TFrOptX01.EdFirstToLegsAcceptValue(Sender: TObject; var Value: Extended; var AcceptAction: NTSAcceptAction);
var
  AllowTie: Boolean;
begin
  if not CalcLegsSets then
  	try
      CalcLegsSets := True;
      AllowTie := XAllowTie.Checked and (EdFirstToSets.AsInteger = 1);
    	EdBestOfLegs.AsInteger := BestOf(Round(Value), AllowTie);
		finally
      CalcLegsSets := False;
		end;
end;

procedure TFrOptX01.EdBestOfLegsAcceptValue(Sender: TObject; var Value: Extended; var AcceptAction: NTSAcceptAction);
var
  AllowTie: Boolean;
begin
  if not CalcLegsSets then
  	try
      CalcLegsSets := True;
      AllowTie := XAllowTie.Checked and (EdFirstToSets.AsInteger = 1);
      if not AllowTie then
        Value := Value + 1 - Round(Value) MOD 2;
  	  EdFirstToLegs.AsInteger := NeedToWin(Round(Value), AllowTie);
		finally
      CalcLegsSets := False;
		end;
end;

constructor TFrOptX01.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
end;

procedure TFrOptX01.StarteSpiel(SpielerListe: array of RPlayer);
begin
	ShowMessage('Spiel ' + SpielName + ' wurde Gestartet');
end;

end.

