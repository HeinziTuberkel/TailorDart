unit fr_dartboard;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, TS_Panel;

type

	{ TFrDarboard }

 TFrDarboard = class(TFrame)
		ImgBoard: TImage;
		PnlCurrentAim: TTSPanel;
		procedure ImgBoardMouseMove(Sender: TObject; Shift: TShiftState; X,
			Y: Integer);
	private
	public
		function AimName(X, Y: Integer): string;
		function AimText(X, Y: Integer): string;
    function AimPoints(X, Y: Integer): Integer;
    function AimDart(X, Y: Integer): RBoardPosition;
	end;



implementation

uses
  TSLib,
	DartConstants;

{$R *.lfm}

const
	coordMax = 2000;
  defaultOffsX = 10;
  defaultOffsY = -4;
  boardA =980;
  doubleAA = 758;
  doubleAI = 755;
  doubleIA = 715;
  doubleII = 708;
  trebleAA = 478;
  trebleAI = 469;
  trebleIA = 434;
  trebleII = 430;
  bullA = 80;
  bullI = 70;
  bullEyeA = 38;
  bullEyeI = 27;
  bullEyeAim = 0;
  bullAim = 55;
  singleIAim = 330;
  trebleAim = 453;
  singleAAim = 610;
  singleAim = singleAAim;
  doubleAim = 736;
  boardAAim = 825;
  bounceOffAim = boardA + 10;



var
  OffsX: Integer = DefaultOffsX;
  OffsY: Integer = DefaultOffsY;
  DrahtRadius: array [NWireRadius] of Integer = (BullEyeI, BullEyeA, BullI, BullA,
  																	TrebleII, TrebleIA, TrebleAI, TrebleAA,
                                    DoubleII, DoubleIA, DoubleAI, DoubleAA,
                                    BoardA, CoordMax);
 	ZielRadius: array [NRadius] of Integer = (BullEyeAim, BullAim, SingleIAim,
  																				TrebleAim, SingleAAim, DoubleAim,
                                          BoardAAim, BounceOffAim);



{ TFrDarboard }

procedure TFrDarboard.ImgBoardMouseMove(Sender: TObject; Shift: TShiftState; X,
	Y: Integer);
begin
  PnlCurrentAim.Caption := AimText(X, Y)
end;

function TFrDarboard.AimName(X, Y: Integer): string;
var
  Dart: RBoardPosition;
begin
	Dart := AimDart(X, Y);
  Result := boardRadiusName[Dart.Radius];
  if Dart.Radius in [radSingleInnen, radTriple, radSingleAussen, radDouble] then
  	Result := Result + ' ' + IntToStr(boardSegmentPunkte[Dart.Segment]);
end;

function TFrDarboard.AimText(X, Y: Integer): string;
begin
  Result := AimName(X, Y) + ' (= ' + IntToStr(AimPoints(X, Y)) + ' ' + punkteDisplay + ')'
end;

function TFrDarboard.AimPoints(X, Y: Integer): Integer;
begin
	Result := AimDart(X, Y).Score;
end;

function TFrDarboard.AimDart(X, Y: Integer): RBoardPosition;
var
	Ratio, BoardX, BoardY, Radius, Winkel: Extended;
  R: NWireRadius;
begin
  if ImgBoard.Picture.Width/ImgBoard.Width > ImgBoard.Picture.Height/ImgBoard.Height then
    Ratio := ImgBoard.Width / CoordMax
  else
    Ratio := ImgBoard.Height / CoordMax;

  BoardX := (X - ImgBoard.Width/2)/Ratio - OffsX;
	BoardY := -((Y - ImgBoard.Height/2)/Ratio - OffsY);

	Radius := sqrt(BoardX * BoardX + BoardY * BoardY);
  if BoardX <> 0 then
		Winkel := arctan(BoardY/BoardX)
	else
  	Winkel := pi / 2;

	if BoardX < 0 then
  	Winkel := Winkel + pi
	else if Winkel < 0 then
    Winkel := Winkel + 2 * pi;
  Result.Segment := NSegment(Round(Winkel*10/pi) mod 20);

  if Radius > DrahtRadius[drBounceOff] then
  begin
    Result.Radius := radBounceOff;
    Result.Score := 0;
	end
  else begin
		R := drBullEyeA;
	  while Radius > DrahtRadius[R] do
  		inc(R);
    case R of
    	drBullEyeA, drBullEyeI: begin
        Result.Score := 50;
      	Result.Radius := radBullEye;
			end;
			drBullI, drBullA: begin
        Result.Score := 25;
      	Result.Radius := radBull;
			end;
			drTripleIA, drTripleAI, drTripleAA: begin
        Result.Score := 3 * boardSegmentPunkte[Result.Segment];
      	Result.Radius := radTriple;
			end;
			drDoubleIA, drDoubleAI, drDoubleAA: begin
        Result.Score := 2 * boardSegmentPunkte[Result.Segment];
      	Result.Radius := radDouble;
			end;
      drBoard: begin
        Result.Score := 0;
      	Result.Radius := radAussen;
			end;
      drBounceOff: begin
        Result.Score := 0;
      	Result.Radius := radBounceOff;
			end;
      drTripleII: begin
        Result.Score := boardSegmentPunkte[Result.Segment];
      	Result.Radius := radSingleInnen;
			end;
      drDoubleII: begin
        Result.Score := boardSegmentPunkte[Result.Segment];
      	Result.Radius := radSingleAussen;
			end;
		end;
	end;
end;


{ TFrDarboard }

end.

