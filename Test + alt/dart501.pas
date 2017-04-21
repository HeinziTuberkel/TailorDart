unit Dart501;

{$mode objfpc}{$H+}

interface

uses
	DartClasses, FrSpielerX01,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
	StdCtrls, Grids, Buttons;

type

			{ TFrmDart501 }

	TFrmDart501 = class(TForm)
	private
    AnzahlSpieler: Integer;
  	FrSpieler: array of TSpielerX01;
    LegsGewonnen, SetsGewonnen: array of Integer;
    Starter: Integer;
	public
		function Spielen(Spieler: array of RSpieler; Legs, Sets: Integer): RSpieler; //Match-Gewinner
    procedure Vorbereiten(Spieler: array of RSpieler);
    function LegSpielen(StartSpieler: Integer): Integer; //Index Leg-Gewinner
    function SetGewonnen: Integer; //Index des Set-Gewinners.
    function MatchGewonnen: Integer; //Indes des Match-Gewinners.
	end;

var
	FrmDart501: TFrmDart501;

implementation

{$R *.lfm}


{ TFrmDart501 }

function TFrmDart501.Spielen(Spieler: array of RSpieler; Legs, Sets: Integer): RSpieler;
var
  I, Gewinner: Integer;
begin
	Result := SpielerKeiner;
  Vorbereiten(Spieler);
  repeat
    repeat
      Gewinner := LegSpielen(Starter);
      if Gewinner < 0 then
				Exit;
      inc(LegsGewonnen[Gewinner]);
      Starter := Starter mod AnzahlSpieler;
		until (LegsGewonnen[Gewinner] >= Legs) or (Gewinner<0);
    inc(SetsGewonnen[Gewinner]);
	until (SetsGewonnen[Gewinner] >= Sets) or (Gewinner<0);
end;

procedure TFrmDart501.Vorbereiten(Spieler: array of RSpieler);
var
	I: Integer;
begin
  Starter := 0;
  AnzahlSpieler := Length(Spieler);
  for I := 0 to pred(Length(FrSpieler)) do
  	FrSpieler[I].Free;
  SetLength(FrSpieler, AnzahlSpieler);
  for I := 0 to pred(AnzahlSpieler) do
  begin
    FrSpieler[I] := TSpielerX01.Create(Self, Spieler[I]);
    FrSpieler[I].Parent := Self;
		FrSpieler[I].Align := alLeft;
    FrSpieler[I].Left := I * FrSpieler[I].Width;
	end;
  Show;
end;

function TFrmDart501.LegSpielen(StartSpieler: Integer): Integer;
var
	I, Rest, Dran: Integer;
begin
  for I := 0 to pred(AnzahlSpieler) do
	  FrSpieler[I].LegStarten;
  Result := -1;
  Dran := StartSpieler;
  Rest := 0;
  repeat
    if Rest > 0 then
	    Dran := (Dran+1) mod Length(FrSpieler)
    else if Rest < 0 then
	    Dran := (Dran+Length(FrSpieler)-1) mod Length(FrSpieler);
  	Rest := FrSpieler[Dran].Werfen;
	until (Rest = 0) or Application.Terminated;


end;

function TFrmDart501.SetGewonnen: Integer;
begin

end;

function TFrmDart501.MatchGewonnen: Integer;
begin

end;

end.

