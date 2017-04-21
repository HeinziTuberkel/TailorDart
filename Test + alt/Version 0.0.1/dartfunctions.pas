unit DartFunctions;

{$mode objfpc}{$H+}

interface

uses
	DartClasses,
  Classes, SysUtils;

function Derselbe(Spieler1, Spieler2: RPlayer): Boolean;

function NeedToWin(BestOf: Integer; AllowTie: Boolean=False): Integer;
function BestOf(NeedToWin: Integer; AllowTie: Boolean=False): Integer;

implementation

function Derselbe(Spieler1, Spieler2: RPlayer): Boolean;
begin
  Result := (Spieler1.Nickname = Spieler2.Nickname)
  					and (Spieler1.ID = Spieler2.ID)
            and (Spieler1.LastName = Spieler2.LastName)
            and (Spieler1.FirstName = Spieler2.FirstName);
end;

function BestOf(NeedToWin: Integer; AllowTie: Boolean): Integer;
begin
	Result := NeedToWin * 2 - 1;
  if AllowTie then
  	dec(Result);
end;

function NeedToWin(BestOf: Integer; AllowTie: Boolean): Integer;
begin
  Result := BestOf DIV 2 + 1;
end;

end.

