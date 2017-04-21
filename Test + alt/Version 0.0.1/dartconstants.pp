unit DartConstants;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
	Classes, SysUtils;


const
  boardRadiusName: array [NRadius] of string = ('Bulls Eye', 'Bull', 'Single',
  																								'Treble', 'Single', 'Double',
						                                      'No Score', 'Bounce Off');
//Version für Segmentzählung im Uhrzeigersinn.
//  boardSegmentPunkte: array [NSegment] of Integer = (6, 10, 15, 2, 17, 3, 19, 7, 16, 8,
//  																						11, 14, 9, 12, 5 20, 1, 18, 4, 13)
//Version für Segmentzählung im mathematischen Drehsinn.
  boardSegmentPunkte: array [NSegment] of Integer = (6, 13, 4, 18, 1, 20, 5, 12, 9, 14,
  																						11, 8, 16, 7, 19, 3, 17, 2, 15, 10);

  punkteDisplay = 'Punkte';

  spielerKeiner: RPlayer = (ID:-1; FirstName: ''; LastName: '';
  														Nickname: ''; Farbe: 0);
  spielerDummy: RPlayer = (ID:-1; FirstName: 'Neuer'; LastName: 'Spieler';
  														Nickname: 'der Neue'; Farbe: $00B7B700);
  rectNULL: TPoint = (X: -16384; Y: -16384);
  lvlRestartLeg = 0;
  lvlRestartSet = 1;
  lvlRestartGame = 2;






  //Konstante für den Zugriff auf INI-Daten.
  INIDateiSpielerMRU = '.\TailorDarts.ini';

  iniGrpSpieler = 'LastPlayers|';
  iniGrpDefault = 'General|';


  iniCounter = ' Count';
  iniSpielerNickname = iniGrpSpieler + 'Nickname';
  iniSpielerVorname = iniGrpSpieler + 'First Name';
  iniSpielerLastName = iniGrpSpieler + 'Last Name';
  iniSpielerFarbe = iniGrpSpieler + 'Color';

  iniDefaultGame = iniGrpDefault + 'Default Game';


implementation

end.

