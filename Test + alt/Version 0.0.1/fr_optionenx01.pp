unit fr_optionenx01;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, TS_Edit;

type

	{ TFrame1 }

	{ TFrOptionenX01 }

 TFrOptionenX01 = class(TFrSpielOptionen)
		CBxPunkte: TComboBox;
		XAllowTie: TCheckBox;
		XDoubleOut: TCheckBox;
		XDoubleIn: TCheckBox;
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
		ScrollBox1: TScrollBox;
		procedure CBxPunkteChange(Sender: TObject);
		procedure EdBestOfLegsChange(Sender: TObject);
		procedure EdBestOfSetsChange(Sender: TObject);
		procedure EdGewinnLegsChange(Sender: TObject);
		procedure EdGewinnSetsChange(Sender: TObject);
	private
     ChangingSets: Boolean;
     ChangingLegs: Boolean;
	public
	end;

implementation

uses DartFunctions;

{$R *.lfm}

{ TFrame1 }


{ TFrOptionenX01 }

procedure TFrOptionenX01.CBxPunkteChange(Sender: TObject);
begin

end;

procedure TFrOptionenX01.EdGewinnSetsChange(Sender: TObject);
begin
  if not ChangingSets then
	  try
			ChangingSets := True;
      EdBestOfSets.AsInteger := BestOf(EdGewinnSets.AsInteger, XAllowTie.Checked);
		finally
			ChangingSets := False;
		end;
end;

procedure TFrOptionenX01.EdBestOfSetsChange(Sender: TObject);
begin
  if not ChangingSets then
	  try
			ChangingSets := True;
      EdGewinnSets.AsInteger := NeedToWin(EdBestOfSets.AsInteger);
		finally
			ChangingSets := False;
		end;
end;

procedure TFrOptionenX01.EdGewinnLegsChange(Sender: TObject);
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

procedure TFrOptionenX01.EdBestOfLegsChange(Sender: TObject);
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

