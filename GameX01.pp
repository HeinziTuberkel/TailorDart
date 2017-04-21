unit GameX01;

{$mode objfpc}{$H+}

interface

uses
  DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, TS_Edit;

type
  TDartGameX01 = class;

	{ TFrX01 }

	TFrX01 = class(TFrame)
		CBxPunkte: TComboBox;
		LbSets: TLabel;
		LbLegs: TLabel;
		LbPunkte: TLabel;
		EdLegs: TTSNumEdit;
		EdSets: TTSNumEdit;
		XBestOfMode: TSpeedButton;
		XSetMode: TSpeedButton;
		XDoubleOut: TSpeedButton;
		XDoubleIn: TSpeedButton;
		procedure CBxPunkteChange(Sender: TObject);
		procedure EdLegsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
		procedure EdSetsAcceptValue(Sender: TObject; var Value: Extended;
			var AcceptAction: NTSAcceptAction);
		procedure XDoubleInClick(Sender: TObject);
		procedure XDoubleOutClick(Sender: TObject);
		procedure XSetModeClick(Sender: TObject);
		procedure XBestOfModeClick(Sender: TObject);
	private
    Game: TDartGameX01;
	public
	end;

	{ TDartGameX01 }

	TDartGameX01 = class(TDartGame)
  private
		fBestOfMode: Boolean;
		fDoubleIn: Boolean;
		fDoubleOut: Boolean;
		fLegs: Integer;
		fSetMode: Boolean;
		fSets: Integer;
		fStartValue: Integer;
  public
		constructor Create; override;
		function HasOptions: Boolean; override;

    property StartValue: Integer read fStartValue write fStartValue;
    property DoubleIn: Boolean read fDoubleIn write fDoubleIn;
    property DoubleOut: Boolean read fDoubleOut write fDoubleOut;
    property SetMode: Boolean read fSetMode write fSetMode;
    property BestOfMode: Boolean read fBestOfMode write fBestOfMode;
    property WinningSets: Integer read fSets write fSets;
    property WinningLegs: Integer read fLegs write fLegs;
	end;


implementation

{$R *.lfm}

uses
	GameX01Player;

//*************************************************
{ TDartGameX01 }
//*************************************************

constructor TDartGameX01.Create;
begin
	inherited Create;
  PlayerClass := TPlayerX01;
  OptionsClass := TFrX01;
  fLegs := 5;
  fSets := 3;
  fDoubleIn := False;
  fDoubleOut := True;
  fSetMode := True;
  fBestOfMode := True;
  fStartValue := 501;
end;

function TDartGameX01.HasOptions: Boolean;
begin
  if not Assigned(Options) then
  	Options := OptionsClass.Create(nil);
	if Options is TFrX01 then
    TFrX01(Options).Game := Self;
  Result := Assigned(Options);
end;

//*************************************************
{ TFrX01 }
//*************************************************

procedure TFrX01.CBxPunkteChange(Sender: TObject);
begin
  Game.StartValue := StrToIntDef(CBxPunkte.Text, 501);
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

procedure TFrX01.XDoubleOutClick(Sender: TObject);
begin
  Game.DoubleOut := XDoubleOut.Down;
end;

procedure TFrX01.XDoubleInClick(Sender: TObject);
begin
	Game.DoubleIn := XDoubleIn.Down;
end;

procedure TFrX01.XSetModeClick(Sender: TObject);
begin
  with XSetMode do
  begin
    Game.SetMode := Down;
    if Down then
    begin
    	Caption := 'Set Mode';
      EdSets.Show;
      LbSets.Show;
		end
		else begin
      Caption := 'Leg Mode';
      EdSets.Hide;
      LbSets.Hide;
		end;
	end;
end;

procedure TFrX01.XBestOfModeClick(Sender: TObject);
begin
  with XBestOfMode do
  begin
    Game.BestOfMode := Down;
    if Down then
    begin
    	Caption := 'Best of';
      EdSets.AsInteger := EdSets.AsInteger * 2 - 1;
      EdLegs.AsInteger := EdSets.AsInteger * 2 - 1;
		end
		else begin
    	Caption := 'First to';
      EdSets.AsInteger := EdSets.AsInteger DIV 2 + 1;
      EdLegs.AsInteger := EdSets.AsInteger DIV 2 + 1;
		end;
	end;
end;

end.

