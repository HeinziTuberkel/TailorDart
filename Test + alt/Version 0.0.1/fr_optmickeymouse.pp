unit Fr_OptMickeyMouse;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls,
  DartClasses;

type

	{ TFrOptMickeyMouse }

 TFrOptMickeyMouse = class(TFrSpielOptionen)
		Edit1: TEdit;
		Label1: TLabel;
	private
	public
    constructor Create(AOwner: TComponent); override;
  	procedure StarteSpiel(SpielerListe: array of RPlayer); override;
	end;

implementation

{$R *.lfm}

uses
  Dialogs;


{ TFrOptMickeyMouse }

constructor TFrOptMickeyMouse.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
end;

procedure TFrOptMickeyMouse.StarteSpiel(SpielerListe: array of RPlayer);
begin
	ShowMessage('Spiel ' + SpielName + ' wurde Gestartet');
end;

end.

