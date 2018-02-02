unit GameX01;

{$mode objfpc}{$H+}

interface

uses
  DartClasses, Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons,
	Menus, ExtCtrls, TS_Edit, TS_SpeedButton, TS_Panel, BCButton, BCPanel,
	BGRASpeedButton;

type
  TDartGameX01 = class;

	{ TFrX01 }

	TFrX01 = class(TFrame)
		LbSets: TLabel;
		LbLegs: TLabel;
		LbPunkte: TLabel;
		EdLegs: TTSNumEdit;
		EdSets: TTSNumEdit;
		MenuItem1: TMenuItem;
		MenuItem2: TMenuItem;
		MenuItem3: TMenuItem;
		MenuItem4: TMenuItem;
		PnlSelectPoints: TPanel;
		BtnStartingPoints: TTSSpeedButton;
		Btn301: TTSSpeedButton;
		Btn1001: TTSSpeedButton;
		Btn701: TTSSpeedButton;
		Btn501: TTSSpeedButton;
		XBestOfMode: TTSSpeedButton;
		XTieGame: TTSSpeedButton;
		XDoubleOut: TTSSpeedButton;
		XSetMode: TTSSpeedButton;
		XDoubleIn: TTSSpeedButton;
		procedure BackgroundClick(Sender: TObject);
		procedure BtnStartingPointsClick(Sender: TObject);
	  procedure BtnStartingPointsSelect(Sender: TObject);
		procedure EdLegsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
		procedure EdSetsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
		procedure PnlSelectPointsExit(Sender: TObject);
		procedure XDoubleInClick(Sender: TObject);
		procedure XDoubleOutClick(Sender: TObject);
		procedure XSetModeClick(Sender: TObject);
		procedure XBestOfModeClick(Sender: TObject);
		procedure XTieGameClick(Sender: TObject);
	private
    Game: TDartGameX01;
	public
		procedure SetContcols;
		procedure SetGameOptions;
	end;

	{ TDartGameX01 }

	TDartGameX01 = class(TDartGame)
  private
		fBestOfMode: Boolean;
		fDoubleIn: Boolean;
		fDoubleOut: Boolean;
		fSetMode: Boolean;
		fStartRemain: Integer;
  public
		constructor Create; override;
		function HasOptions: Boolean; override;
		procedure CheckOut(aPlayer: TPlayer); override;
    procedure EndGame; override;
    function HasWonSet(LegsWon: Integer): Boolean;

    property StartRemain: Integer read fStartRemain write fStartRemain;
    property DoubleIn: Boolean read fDoubleIn write fDoubleIn;
    property DoubleOut: Boolean read fDoubleOut write fDoubleOut;
    property SetMode: Boolean read fSetMode write fSetMode;
    property BestOfMode: Boolean read fBestOfMode write fBestOfMode;
	end;


implementation

{$R *.lfm}

uses
	GameX01Player, DartResources;

//*************************************************
{ TDartGameX01 }
//*************************************************

constructor TDartGameX01.Create;
begin
	inherited Create;
  PlayerClass := TPlayerX01;
  OptionsClass := TFrX01;
  fDoubleIn := False;
  fDoubleOut := True;
  fSetMode := True;
  fBestOfMode := True;
  fStartRemain := 501;
end;

function TDartGameX01.HasOptions: Boolean;
begin
  if not Assigned(Options) then
  	Options := OptionsClass.Create(nil);
	if Options is TFrX01 then
    TFrX01(Options).Game := Self;
  Result := Assigned(Options);
end;

procedure TDartGameX01.CheckOut(aPlayer: TPlayer);
begin
	inherited CheckOut(aPlayer);
end;

procedure TDartGameX01.EndGame;
begin
	inherited EndGame;
end;

function TDartGameX01.HasWonSet(LegsWon: Integer): Boolean;
begin
	//Result := LegsWon > (fLegs DIV 2)
end;

//*************************************************
{ TFrX01 }
//*************************************************

procedure TFrX01.BtnStartingPointsSelect(Sender: TObject);
begin
	if Assigned(Sender) and (Sender is TControl) then
	begin
    Game.StartRemain := TControl(Sender).Tag;
		BtnStartingPoints.Tag := Game.StartRemain;
		BtnStartingPoints.Caption := IntToStr(Game.StartRemain);
	end;
	PnlSelectPoints.Hide;
end;

procedure TFrX01.BackgroundClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
end;

procedure TFrX01.BtnStartingPointsClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
  PnlSelectPoints.Show;
	PnlSelectPoints.SetFocus;
end;

procedure TFrX01.EdLegsAcceptValue(Sender: TObject; var Value: Extended;
	var AcceptAction: NTSAcceptAction);
begin
  if Game.SetMode
  	and Game.BestOfMode
  	and ((EdLegs.AsInteger mod 2)=0)
  then
    Value  := Value + 1;
  Game.WinningLegs := Trunc(Value);
end;

procedure TFrX01.EdSetsAcceptValue(Sender: TObject; var Value: Extended;
	var AcceptAction: NTSAcceptAction);
begin
	Game.WinningSets := Trunc(Value);
end;

procedure TFrX01.PnlSelectPointsExit(Sender: TObject);
begin
  PnlSelectPoints.Hide;
end;

procedure TFrX01.XDoubleOutClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
  Game.DoubleOut := XDoubleOut.Down;
end;

procedure TFrX01.XDoubleInClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
	Game.DoubleIn := XDoubleIn.Down;
end;

procedure TFrX01.XSetModeClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
  with XSetMode do
  begin
    Game.SetMode := Down;
    if Down then
    begin
    	Caption := rsSetMode;
      EdSets.Show;
      LbSets.Show;
		end
		else begin
      Caption := rsLegMode;
      EdSets.Hide;
      LbSets.Hide;
		end;
	end;
end;

procedure TFrX01.XBestOfModeClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
  with XBestOfMode do
  begin
    Game.BestOfMode := Down;
    if Down then
    begin
    	Caption := 'Best of';
      EdSets.AsInteger := EdSets.AsInteger * 2 - 1;
      EdLegs.AsInteger := EdLegs.AsInteger * 2 - 1;
		end
		else begin
    	Caption := 'First to';
      EdSets.AsInteger := EdSets.AsInteger DIV 2 + 1;
      EdLegs.AsInteger := EdLegs.AsInteger DIV 2 + 1;
		end;
	end;
end;

procedure TFrX01.XTieGameClick(Sender: TObject);
begin
	PnlSelectPoints.Hide;
  Game.AllowTieGame := XTieGame.Down;
end;

procedure TFrX01.SetContcols;
begin
	PnlSelectPoints.Hide;
	BtnStartingPoints.Caption := IntToStr(Game.StartRemain);
	BtnStartingPoints.Tag := Game.StartRemain;
  XDoubleIn.Down := Game.DoubleIn;
	XDoubleOut.Down := Game.DoubleOut;
	XSetMode.Down := Game.SetMode;
	XBestOfMode.Down := Game.BestOfMode;
	XTieGame.Down := Game.AllowTieGame;
	EdLegs.AsInteger := Game.WinningLegs;
	EdSets.AsInteger := Game.WinningSets;
end;

procedure TFrX01.SetGameOptions;
begin
	PnlSelectPoints.Hide;
	Game.StartRemain := BtnStartingPoints.Tag;
	Game.DoubleIn := XDoubleIn.Down;
	Game.DoubleOut := XDoubleOut.Down;
	Game.SetMode := XSetMode.Down;
	Game.BestOfMode := XBestOfMode.Down;
	Game.AllowTieGame := XTieGame.Down;
	Game.WinningLegs := EdLegs.AsInteger;
	Game.WinningSets := EdSets.AsInteger;
end;

end.

