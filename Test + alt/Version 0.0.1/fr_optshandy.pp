unit Fr_OptShandy;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls;

type

	{ TFrOptShandy }

 TFrOptShandy = class(TFrSpielOptionen)
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

{ TFrOptShandy }

constructor TFrOptShandy.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
end;

procedure TFrOptShandy.StarteSpiel(SpielerListe: array of RPlayer);
begin
	ShowMessage('Spiel ' + SpielName + ' wurde Gestartet');
end;

end.

