unit DartBoardTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, TS_Panel;

type
  NRadius = (rBoard, rDblAA, rDblAI, rDblIA, rDblII,
            rTrblAA, rTrblAI, rTrblIA, rTrblII,
            rBullA, rBullI, rBEyeA, rBEyeI);

	NBoardFeld = (fld6, fld13, fld4, fld18, fld1, fld20, fld5, fld12, fld9, fld14,
  					fld11, fld8, fld16, fld7, fld19, fld3, fld17, fld2, fld15, fld10);

  NFeld = (noscore, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,
					d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,
					t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,
          bull, bulleye);


  { TFrmBoard }


  TFrmBoard = class(TForm)
    BtnRing: TButton;

    BtnRadAngl: TButton;
    BtnXY: TButton;
    Button1: TButton;
		BtnAbweichung: TButton;
		BtnTries: TButton;
		EdErrX: TSpinEdit;
		EdErrY: TSpinEdit;
		EdTryAnz: TSpinEdit;
		Label10: TLabel;
		Label11: TLabel;
		Label9: TLabel;
		PnlAim: TTSPanel;
    XFlugbahn: TCheckBox;
    EdDartNr: TSpinEdit;
    EdAimY: TSpinEdit;
    EdAimX: TSpinEdit;
    EdOffsX: TSpinEdit;
    EdAimRadius: TSpinEdit;
    EdOffsY: TSpinEdit;
    EdAimField: TSpinEdit;
    EdRadius: TSpinEdit;
    ImgBoard: TImage;
    ImgDart1: TImage;
    ImgDart2: TImage;
    ImgDart3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LBxRadien: TListBox;
    PnlRechts: TPanel;
    TmrNxtStep: TTimer;
    procedure BtnRingClick(Sender: TObject);
    procedure BtnRadAnglClick(Sender: TObject);
		procedure BtnTriesClick(Sender: TObject);
    procedure BtnXYClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
		procedure BtnAbweichungClick(Sender: TObject);
    procedure EdAimXYChange(Sender: TObject);
    procedure EdOffsXChange(Sender: TObject);
    procedure EdAimFieldChange(Sender: TObject);
    procedure EdOffsYChange(Sender: TObject);
    procedure EdRadiusChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
		procedure ImgBoardDblClick(Sender: TObject);
		procedure ImgBoardMouseMove(Sender: TObject; Shift: TShiftState; X,
			Y: Integer);
    procedure LBxRadienClick(Sender: TObject);
    procedure TmrNxtStepTimer(Sender: TObject);
  private
    DoStep: Boolean;
    Abbruch: Boolean;
		AimX: Integer;
		AimY: Integer;
		AimRadius: Integer;
		AimFeld: Integer;
		Radius: Integer;
		OffsX: Integer;
		OffsY: Integer;
    function Board2Form(Pt: TPoint): TPoint;
		procedure Kreis;
		procedure Zielpunkt;
    procedure ZielXY(ZielX, ZielY: Integer; Farbe: TColor; Clear: Boolean);
		procedure ZielXY;
		procedure WirfDart;

    function Abweichung(Ziel, Fehler: TPoint): TPoint;
    procedure ZielUndTreffer(Ziel: TPoint; Clear: Boolean);
    function ZieleAuf(Rest, DartNr: Integer): NFeld;


  public
  end;

const
  StdOffsX = 10;
  StdOffsY = -4;
  BoardA =980;
  DoubleAA = 758;
  DoubleAI = 755;
  DoubleIA = 715;
  DoubleII = 708;
  TrebleAA = 478;
  TrebleAI = 469;
  TrebleIA = 434;
  TrebleII = 430;
  BullA = 80;
  BullI = 70;
  BullEyeA = 38;
  BullEyeI = 27;

  boardRadiusName: array [NRadius] of string = ('Board Außen',
  																			'Double', 'Double', 'Double', 'Single',
                                        'Treble', 'Treble', 'Treble',
                                        'Single', 'Bull', 'Bull', 'Bull''s Eye', 'Bull''s Eye');
  boardFeldName: array [NBoardFeld] of string = ('6', '13', '4', '18', '1', '20',
												  '5', '12', '9', '14', '11', '8', '16', '7', '19', '3',
                          '17', '2', '15', '10');



	ZielDart1: array [1..350] of NFeld = (
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //10
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //20
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //30
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //40
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //50
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //60
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //70
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //80
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //90
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //00
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //110
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //120
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //130
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //140
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //150
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //160
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //170
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //180
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //190
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //200
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //210
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //220
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //230
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //240
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //250
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //260
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //270
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //280
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //290
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //300
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //310
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //320
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //330
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //340
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20 //350
							);
  ZielDart2: array [1..350] of NFeld = (
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //10
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //20
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //30
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //40
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //50
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //60
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //70
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //80
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //90
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //00
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //110
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //120
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //130
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //140
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //150
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //160
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //170
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //180
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //190
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //200
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //210
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //220
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //230
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //240
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //250
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //260
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //270
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //280
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //290
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //300
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //310
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //320
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //330
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //340
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20 //350
							);
  ZielDart3: array [1..350] of NFeld = (
							noscore, d1, s1, d2, s1, d3, s3, d4, s1, d5, //10
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //20
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //30
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //40
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //50
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //60
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //70
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //80
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //90
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //00
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //110
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //120
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //130
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //140
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //150
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //160
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //170
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //180
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //190
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //200
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //210
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //220
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //230
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //240
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //250
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //260
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //270
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //280
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //290
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //300
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //310
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //320
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //330
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20, //340
							t20, t20, t20, t20, t20, t20, t20, t20, t20, t20 //350
							);

var
  FrmBoard: TFrmBoard;
  Rad: array [NRadius] of Integer = (BoardA,
                              DoubleAA, DoubleAI, DoubleIA, DoubleII,
                              TrebleAA,TrebleAI, TrebleIA, TrebleII,
                              BullA, BullI, BullEyeA, BullEyeI);


implementation


{$R *.lfm}

{ TFrmBoard }

procedure TFrmBoard.LBxRadienClick(Sender: TObject);
begin
  if LBxRadien.ItemIndex >= 0 then
    Radius := Rad[NRadius(LBxRadien.ItemIndex)];
  EdRadius.Value := Radius;
  EdAimRadius.Value := Radius;
  Kreis;
end;

procedure TFrmBoard.TmrNxtStepTimer(Sender: TObject);
begin
	DoStep := True;
end;

function TFrmBoard.Board2Form(Pt: TPoint): TPoint;
var
  Prm, X, Y: Extended;
begin
	with ImgBoard do
  begin
	  if Picture.Width/Width > Picture.Height/Height then
	    Prm := Width / 2000
	  else
	    Prm := Height / 2000;

	  X := Width / 2 + (AimX+OffsX)*Prm;
	  Y := Height / 2 + (AimY+OffsY)*Prm;
    Result := ClientToScreen(Point(Round(X), Round(Y)));
	end;
  Result := ScreenToClient(Result);
end;

procedure TFrmBoard.Kreis;
var
  R, Prm, CtrX, CtrY: Extended;
begin
  with ImgBoard do
  begin
    if Picture.Width/Width > Picture.Height/Height then
      Prm := Width / 2000
    else
      Prm := Height / 2000;
    CtrX := Width / 2;
    CtrY := Height / 2;
    R := Radius;

    ImgBoard.Invalidate;
    Application.ProcessMessages;
    ImgBoard.Canvas.Brush.Style := bsClear;
    ImgBoard.Canvas.Pen.Color := clYellow;
    ImgBoard.Canvas.Ellipse(Round(CtrX-(R-OffsX)*Prm),
                            Round(CtrY-(R-OffsY)*Prm),
                            Round(CtrX+(R+OffsX)*Prm),
                            Round(CtrY+(R+OffsY)*Prm)
                            );
  end;
end;

procedure TFrmBoard.ZielXY(ZielX, ZielY: Integer; Farbe: TColor; Clear: Boolean);
var
	CtrX, CtrY, Prm: Extended;
begin
  with ImgBoard do
  begin
    if Clear then
	  	Invalidate;
    Application.ProcessMessages;
	  if Picture.Width/Width > Picture.Height/Height then
	    Prm := Width / 2000
	  else
	    Prm := Height / 2000;

	  CtrX := Width / 2 + (ZielX+OffsX)*Prm;
	  CtrY := Height / 2 + (ZielY+OffsY)*Prm;
    ImgBoard.Canvas.Brush.Style := bsSolid;
    ImgBoard.Canvas.Brush.Color := Farbe;
    ImgBoard.Canvas.Pen.Color := Farbe;
    ImgBoard.Canvas.Ellipse(Round(CtrX-1),
    												Round(CtrY-1),
    												Round(CtrX+1),
    												Round(CtrY+1));
	end;
end;

procedure TFrmBoard.ZielXY;
begin
	ZielXY(AimX, AimY, clYellow, True);
end;

procedure TFrmBoard.Zielpunkt;
var
	Angl, R, X, Y, Prm: Extended;
begin
	Angl := AimFeld/10*pi;
  EdAimX.Value := Round(AimRadius*cos(Angl));
  EdAimY.Value := Round(AimRadius*sin(Angl));
  ZielXY;
end;

procedure TFrmBoard.WirfDart;
const
  StepCount=30;
var
	I, J: Integer;
	Dt, Start, ParTop, Ziel: TPoint;
  ParA, ParB, ParC, ParY, ParX, ParY2, ParX2, Step: Extended;
  Pic: TImage;

  procedure Reset(P: Timage);
  begin
    //P.Parent := PnlRechts;
    //P.Align := alBottom;
    P.Visible := False
  end;

begin
  Reset(ImgDart1);
  Reset(ImgDart2);
  Reset(ImgDart3);
  ZielPunkt;
  case EdDartNr.Value of
		1: Pic := ImgDart1;
		2: Pic := ImgDart2;
	else
    Pic := ImgDart3;
  end;
  Pic.Visible := True;
  Pic.BringToFront;
  Pic.Align := alNone;
  Pic.Parent := Self;
  Pic.Left := Self.Width;
  Pic.Top := Self.Height;

  Ziel := Board2Form(Point(EdAimX.Value, EdAimY.Value));
  ParTop := Point(Round(Ziel.X + (ImgBoard.Width-Ziel.X)*((2+Random(6))/10)),
  								Round(Ziel.Y*(1+Random(7))/10));

  //Bestimme die Flugparabel aus Zielpunkt und Scheitelpunkt der Flugbahn
  //Scheitelform der Parabel nach a aufgelöst
  ParA := (Ziel.Y - ParTop.Y)/sqr(Ziel.X - ParTop.X);
  ParB := - 2 * ParA * ParTop.X;
  ParC := ParA * sqr(ParTop.X) + ParTop.Y;

  DoStep := False;
  Abbruch := False;
  Step := (ImgBoard.Width - Ziel.X) / StepCount;
  PnlRechts.SetFocus;

//  Pic.Picture.Bitmap.SetSize(Pic.Width, Pic.Height);

  for I := StepCount downto 0 do
  begin
  	if XFlugbahn.Checked then
    begin
	    //Zeichne die Parabel zur Visualisierung der Flugbahn
	    Self.Canvas.Pen.Color := clWhite;
	    Self.Canvas.MoveTo(Ziel.X, Ziel.Y);
	    for J := 0 to StepCount do
	    begin
	      ParX2 :=	Ziel.X + Step * J;
	      ParY2 := ParA*sqr(ParX2)+ParB*ParX2+ParC;
	  		Self.Canvas.LineTo(Round(ParX2), Round(ParY2));
	  	end;
    end;

    //Warte auf Tastendruck für den nächsten Schritt
    while not DoStep do
    	Application.ProcessMessages;
		DoStep := False;
    if Abbruch then
    	Exit;

    //Nächste Flugposition des Darts
    ParX :=	Ziel.X + Step * I;
    ParY := ParA*sqr(ParX)+ParB*ParX+ParC;

		//Dt := ImgBoard.ScreenToClient(ClientToScreen(Point(Round(ParX), Round(ParY))));
  //  ImgBoard.Canvas.Draw(Dt.x, Dt.Y, Pic.Picture.Bitmap);
  //  Refresh;

  	Pic.Top := Round(ParY) - Pic.Height;
    Pic.Left := Round(ParX);
    //Refresh;
  end;
	Pic.Left := Ziel.X;
  Pic.Top := Ziel.Y - Pic.Height;
end;

function TFrmBoard.Abweichung(Ziel, Fehler: TPoint): TPoint;
var
	Rnd, RndRadius, RndRichtung: Extended;
begin
  repeat
		Rnd := Random;
	until Rnd > 0;
	RndRadius := sqrt(-2.0 * ln(Rnd));
	RndRichtung := 2 * Pi * Random;
  Result.X := Ziel.X + Round(Fehler.X * RndRadius * cos(RndRichtung));
  Result.Y := Ziel.Y + Round(Fehler.Y * RndRadius * sin(RndRichtung));
end;

procedure TFrmBoard.ZielUndTreffer(Ziel: TPoint; Clear: Boolean);
var
  Treffer, Fehler: TPoint;
begin
  ZielXY(Ziel.X, Ziel.Y, clTeal, Clear);
	Fehler.X := EdErrX.Value;
	Fehler.Y := EdErrY.Value;
  Treffer := Abweichung(Ziel, Fehler);
  ZielXY(Treffer.X, Treffer.Y, clYellow, False);
end;

function TFrmBoard.ZieleAuf(Rest, DartNr: Integer): NFeld;
var
  R: Integer;
begin
  R := random(1000);
  if Rest > 350 then
  begin
  	if R > 990 then
	  	Result := t17
    else if R > 950 then
    	Result := t18
    else if R > 850 then
    	Result := t19
    else
    	Result := t20
  end
  else if DartNr = 1 then
  	Result := ZielDart1[Rest]
  else if DartNr = 2 then
  	Result := ZielDart2[Rest]
  else
  	Result := ZielDart3[Rest];
end;

procedure TFrmBoard.BtnRingClick(Sender: TObject);
begin
  Kreis;
end;

procedure TFrmBoard.BtnRadAnglClick(Sender: TObject);
begin
	Zielpunkt;
end;

procedure TFrmBoard.BtnTriesClick(Sender: TObject);
var
  Pt: TPoint;
  I: Integer;
begin
	Pt.X := AimX;
  Pt.Y := AimY;
	ZielUndTreffer(Pt, True);
  for I := 1 to EdTryAnz.Value do
		ZielUndTreffer(Pt, False);
end;

procedure TFrmBoard.BtnXYClick(Sender: TObject);
begin
  ZielXY;
end;

procedure TFrmBoard.Button1Click(Sender: TObject);
begin
	WirfDart;
end;

procedure TFrmBoard.BtnAbweichungClick(Sender: TObject);
var
  Pt: TPoint;
begin
	Pt.X := AimX;
  Pt.Y := AimY;
	ZielUndTreffer(Pt, True);
end;

procedure TFrmBoard.EdAimXYChange(Sender: TObject);
begin
	AimX := EdAimX.Value;
	AimY := EdAimY.Value;
  ZielXY;
end;

procedure TFrmBoard.EdOffsXChange(Sender: TObject);
begin
  OffsX := EdOffsX.Value;
  Kreis;
end;

procedure TFrmBoard.EdAimFieldChange(Sender: TObject);
begin
	AimRadius := EdAimRadius.Value;
  AimFeld := EdAimField.Value;
	Zielpunkt;
end;

procedure TFrmBoard.EdOffsYChange(Sender: TObject);
begin
  OffsY := EdOffsY.Value;
  Kreis;
end;

procedure TFrmBoard.EdRadiusChange(Sender: TObject);
begin
  Radius := EdRadius.Value;
  Kreis;
end;

procedure TFrmBoard.FormCreate(Sender: TObject);
begin
  EdOffsX.Value := StdOffsX;
  EdOffsY.Value := StdOffsY;
  OffsX := StdOffsX;
  OffsY := StdOffsY;
  Radius := EdRadius.Value;
end;

procedure TFrmBoard.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 then
    Abbruch := True;
	DoStep := True;
end;

procedure TFrmBoard.ImgBoardDblClick(Sender: TObject);
begin
  ZielXY;
  WirfDart;
end;

procedure TFrmBoard.ImgBoardMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  S: string;
  I: Integer;
  R: NRadius;
  ARadius, AWinkel, AX, AY, Prm: Extended;
begin
  if ImgBoard.Picture.Width/ImgBoard.Width > ImgBoard.Picture.Height/ImgBoard.Height then
    Prm := ImgBoard.Width / 2000
  else
    Prm := ImgBoard.Height / 2000;

  S := '(' + IntToStr(X) + ', ' + IntToStr(Y) + ')';
  AX := (X - ImgBoard.Width/2)/Prm - OffsX;
  AY := -((Y - ImgBoard.Height/2)/Prm - OffsY);
  S := S + ' -> (' + IntToStr(Round(AX)) + ', ' + IntToStr(Round(AY)) + ')';

	ARadius := sqrt(AX * AX + AY * AY);
  if AX <> 0 then
  begin
		AWinkel := arctan(AY/AX)/pi * 180;
    if AX < 0 then
    	AWinkel := AWinkel + 180;
	end
	else if AY < 0 then
  	AWinkel := - 90
  else
		AWinkel := 90;
  If AWinkel < 0 then
  	AWinkel := AWinkel + 360;

  S := S + ' ' + IntToStr(Round(ARadius)) + '@' + IntToStr(Round(AWinkel)) + '°';

  if ARadius >= BoardA then
  	S := S + ' Bounce Off'
  else begin
    R := rBEyeI;
	  while ARadius > Rad[R] do
  	  dec(R);
    S := S + ': ' + boardRadiusName[R];
  	if (R >= rDblAA) and (R < rBullA) then
    begin
      I := Round(AWinkel/18) mod 20;
			S  := S + ' ' + boardFeldName[NBoardFeld(I)];
		end;
	end;
	PnlAim.Caption := S;
  AimX := Round(AX);
  AimY := -Round(AY);
end;

end.

