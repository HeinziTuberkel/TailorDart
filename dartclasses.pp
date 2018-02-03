unit DartClasses;
{$mode objfpc}{$H+}

interface

uses
  Forms,
	fgl, Controls,
	Classes, SysUtils;

type
	NSector = (s1, s2, s3, s4, s5, s6, s7, s8, s9,
							s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20);
	NRadius = (rNone, rBounce, rBullEye, rBull, rSingleInner,
							rTriple, rSingleOuter, rDouble, rRing, rOutside);

  NGameMode = (gmSingle, gmBestOfX, gmFirstToX, gmEndless);

  TPlayer = class;
  TDartGame = class;

  MThrowDone = procedure(aPlayer: TPlayer; PlayerIndex: Integer) of Object;
  MThrowCancel = procedure(aPlayer: TPlayer; PlayerIndex: Integer) of Object;
  MCheckOut = procedure(aPlayer: TPlayer; PlayerIndex: Integer) of Object;
  MLoseOut = procedure(aPlayer: TPlayer; PlayerIndex: Integer) of Object;
  MListItemDelete = procedure (Sender: TObject; Index: Integer) of object;

  TPlayerList = specialize TFPGObjectList<TPlayer>;
  TPlayerClass = class of TPlayer;
  TDartGameClass = class of TDartGame;
  TGameOptionsClass = class of TFrame;

//****************************************************************************
	{ HPlayerList }
//****************************************************************************

  HPlayerList = class helper for TPlayerList
  	function MaxIndex: Integer;
  end;

//****************************************************************************
	{ TDart }
//****************************************************************************
	RDart = record
		Sector: NSector;
		Radius: NRadius;
		Score: Integer;
	end;

//****************************************************************************
	{ TThrow }
//****************************************************************************
	TThrow = class(TObject)
		Dart: Array [1..3] of RDart;
    Score: Integer;			//points scored with these 3 darts (if applicable in current game).
		GameScore: Integer; //usually either points scored or points remaining (depends on game).
		NoScore: Boolean;
		Invalid: Boolean;		//special form of "no score". e.g. "Busted" in 501.
		procedure Assign(TheThrow: TThrow);
		procedure Reset;
	end;



//****************************************************************************
	{ TPlayer }
//****************************************************************************

	TPlayer = class(TObject)
	private
		fFirstToThrow: Boolean;
		fGame: TDartGame;
		fLegsWon: Integer;
		fNickname: string;
		fEnabled: Boolean;
		fSetsWon: Integer;
		fStartPlayer: Boolean;
		fThrow: TThrow;
		fThrowing: Boolean;
		fThrowList: array of TThrow;
		function GetGame: TDartGame;
		function GetLastThrow: TThrow;
		function GetScoreBoard: TWinControl;
		function GetThrow(No: Word): TThrow;
		function GetThrowCount: Integer;
    procedure SetNickname(AValue: string);
		procedure SetThrowing(AValue: Boolean);
  protected
  	procedure ExecuteThrow; virtual;
    procedure ExecuteUndoAction; virtual;
		procedure SetEnabled(AValue: Boolean); virtual;
    //CheckOut and LoseOut: called internally when the entered throw
    // leads to winning or losing the game. These methods are triggered by the Result of
    // functions IsCheckOut / IsLoseOut inside the process of ThrowDone.
		procedure CheckOut; virtual;
		procedure LoseOut; virtual;
	public
    constructor Create; virtual;
		procedure InitGame(TheGame: TDartGame); virtual;
    procedure InitLeg(AsFirstToThrow: Boolean); virtual;
		procedure ClearCurrentThrow; virtual;
    //Initiates the throw. It is completed by calling either ThrowDone or ThrowCancel.
		procedure Throw; virtual;
		procedure AddCurrentThrowToList; virtual;
    //If possible, the results of the prior throw are cancelled and "Throw" is called.
		procedure UndoThrow; virtual;
    //True, if a completed "Throw" result exists, that can be undone.
    function CanUndoThrow: Boolean; virtual;

    //ThrowDone: called, when the player has finished entering his score.
		procedure ThrowDone; virtual;
    //ThrowCancel: called, when the player has cancelled entring the score (e.g. to undo a prior input).
		procedure ThrowCancel; virtual;
		//IsCheckOut: Returns TRUE, when the player is throwing and the current Entry results in winning the game/leg
		function IsCheckOut: Boolean; virtual;
		//IsLoseOut: Returns TRUE, when the player is throwing and the current Entry results in losing the game/leg
		function IsLoseOut: Boolean; virtual;

		property CurrentThrow: TThrow read fThrow;
		property ThrowCount: Integer read GetThrowCount;
    property ThrowList[No: Word]: TThrow read GetThrow;
		property LastThrow: TThrow read GetLastThrow;

		property LegsWon: Integer read fLegsWon write fLegsWon;
		property SetsWon: Integer read fSetsWon write fSetsWon;
		property FirstToThrow: Boolean read fFirstToThrow;

    property Nickname: string read fNickname write SetNickname;
    //Game: The TDartGame object, this player is playing.
    property Game: TDartGame read GetGame;
    //The Container on which the score board (TFrame) is placed.
    property ScoreBoard: TWinControl read GetScoreBoard;
    //Set "TRUE" by the Game, if this player is the first to throw.
    property IsStartPlayer: Boolean read fStartPlayer write fStartPlayer;

		//Enabled: True, when this player is allowed to score in the current game.
		//				 When set to FALSE the "Throw" method does noting and directly calls "ThrowDone"
		property Enabled: Boolean read fEnabled write SetEnabled;
    //Throwing: True, when this player is about to enter his throw's result.
		property Throwing: Boolean read fThrowing write SetThrowing;
	end;

//****************************************************************************
	{ TDartGame }
//****************************************************************************

	TDartGame = class(TObject)
	private
		fAllowTie: Boolean;
		fFirstToThrow: Integer;
		fGameOptionsClass: TGameOptionsClass;
		fLegs: Integer;
  	fPlayerClass: TPlayerClass;
		fPlayers: TPlayerList;
    fOptions: TFrame;
		fScoreBoard: TWinControl;
		fSets: Integer;
		fThisLeg: Integer;
		fThisSet: Integer;
		fThrowCancel: MThrowCancel;
		fThrowDone: MThrowDone;
    fGameEnded: Boolean;
		fNowToThrow: Integer;
    fStartPlayerIdx: Integer;
		function GetPlayer(Index: Integer): TPlayer;
		function GetPlayerCount: Integer;
		function GetStarterIndex: Integer;
		function GetPlayerToThrow: TPlayer;
		procedure SetPlayer(Index: Integer; AValue: TPlayer);
		function MaxLegNo: Integer; //0-based.
		function MaxSetNo: Integer; //0-based.
  protected
    //The class that is used to create new player objects.
    property PlayerClass: TPlayerClass read fPlayerClass write fPlayerClass;
    //The TFrame descendent class that is used to show/edit/get the game's optional settings.
    property OptionsClass: TGameOptionsClass read fGameOptionsClass	write fGameOptionsClass;
    property GameEnded: Boolean read fGameEnded write fGameEnded;
		procedure SetOptions(AValue: TFrame); virtual;
	public
    constructor Create; virtual;
    destructor Destroy; override;
    function HasOptions: Boolean; virtual;

    //Clear removes all players and sets all properties to default values.
		procedure Clear; virtual;
    //InitGame sets all game Start values whithout removing Players.
    procedure InitGame(TheScoreBoard: TWinControl); virtual;
    procedure InitLeg; virtual;
    //Adds a Player to the List fPlayers. Returns the new Player's Index. Returns -1 if adding failed.
		function AddPlayer(NewPlayer: TPlayer=nil): Integer; virtual;

    procedure SelectNextToThrow; virtual;
    procedure SelectPriorToThrow; virtual;

    //PlayGame starts the game.
    //	All further game actions are conducted by the methods below (ThrowDone/Cancel, Check/LoseOut, EndGame);
		procedure PlayGame; virtual;
    //ThrowDone: The current player has entered his score.
		procedure ThrowDone(aPlayer: TPlayer); virtual;
    //ThrowCancel: current player has canceled. Undo the prior players throw and redo.
		procedure ThrowCancel(aPlayer: TPlayer); virtual;
    //ChechOut: current player finished this leg.
		procedure CheckOut(aPlayer: TPlayer); virtual;
    //LoseOut: current player is out of the game.
		procedure LoseOut(aPlayer: TPlayer); virtual;
    //The Leg has ended. Either one player has won or all players are out of the game.
		procedure EndLeg; virtual;
		procedure EndSet; virtual;
    //The game has ended.
    procedure EndGame; virtual;

		property WinningSets: Integer read fSets write fSets default 1;
		property WinningLegs: Integer read fLegs write fLegs default 1;
		property ThisSet: Integer read fThisSet; //Set counter, 0-based
		property ThisLeg: Integer read fThisLeg; //Leg counter in current set, 0-based
		property AllowTieGame: Boolean read fAllowTie write fAllowTie;
		property FirstToThrow: Integer read fFirstToThrow write fFirstToThrow;

    property Options: TFrame read fOptions write SetOptions;
    property ScoreBoard: TWinControl read fScoreBoard;
		property PlayerCount: Integer read GetPlayerCount;
		property Player[Index: Integer]: TPlayer read GetPlayer write SetPlayer;
    //UpPlayer: Index of next player to enter his score.
		property NowToThrow: Integer read fNowToThrow;
    property PlayerToThrow: TPlayer read GetPlayerToThrow;
    property StartPlayerIndex: Integer read fStartPlayerIdx;
	end;


implementation

uses
	TSLib,
  ExtCtrls;

//**************************************************************************************************
	{ HPlayerList }
//**************************************************************************************************

//*************************************************
function HPlayerList.MaxIndex: Integer;
begin
 	Result := pred(Count);
end;

//**************************************************************************************************
{ TThrow }
//**************************************************************************************************

procedure TThrow.Assign(TheThrow: TThrow);
var
	I: Integer;
begin
	for I := 1 to 3 do
		with Dart[I] do
		begin
			Radius := TheThrow.Dart[I].Radius;
			Sector := TheThrow.Dart[I].Sector;
			Score := TheThrow.Dart[I].Score;
		end;
	Invalid := TheThrow.Invalid;
	NoScore := TheThrow.NoScore;
	Score := TheThrow.Score;
end;

procedure TThrow.Reset;
var
	I: Integer;
begin
	for I := 1 to 3 do
		with Dart[I] do
		begin
			Radius := rNone;
			Sector := s1;
			Score := 0;
		end;
	Invalid := True;
	NoScore := True;
	Score := 0;
end;


//**************************************************************************************************
	{ TDartGame }
//**************************************************************************************************

//*************************************************
procedure TDartGame.InitGame(TheScoreBoard: TWinControl);
var
  I: Integer;
begin
  fScoreBoard := TheScoreBoard;
	fThisLeg := 0;
	fThisSet := 0;
	for I := 0 to fPlayers.MaxIndex do
    fPlayers[I].InitGame(Self);
end;

//*************************************************
procedure TDartGame.InitLeg;
var
	I: Integer;
begin
	fNowToThrow := (fFirstToThrow + fThisSet + fThisLeg) mod fPlayers.Count;
	for I := 0 to fPlayers.MaxIndex do
		fPlayers[I].InitLeg(I =  fNowToThrow);
end;

//*************************************************
procedure TDartGame.PlayGame;
begin
  if PlayerCount > 0 then
	begin
		InitLeg;
	  Player[fNowToThrow].Throw;
	end
	else
		EndGame;
end;

//*************************************************
procedure TDartGame.EndLeg;
var
	I: Integer;
begin
	for I := 0 to fPlayers.MaxIndex do
		if fPlayers[I].LegsWon >= fLegs then
		begin
	  	fPlayers[I].LegsWon := 0;
			fPlayers[I].fSetsWon := fPlayers[I].fSetsWon + 1;
			EndSet;
			Exit;
		end;
	if ThisLeg < MaxLegNo then
	begin
		inc(fThisLeg);
		PlayGame;
	end
	else
		EndGame;
end;

//*************************************************
procedure TDartGame.EndSet;
var
	I: Integer;
begin
	for I := 0 to fPlayers.MaxIndex do
	begin
		fPlayers[I].LegsWon := 0;
		if fPlayers[I].SetsWon >= fSets then
		begin
			EndGame;
			Exit;
		end;
	end;
	if ThisSet < MaxSetNo then
	begin
		fThisLeg := 0;
		inc(fThisSet);
		PlayGame;
	end
	else
		EndGame;
end;

//*************************************************
procedure TDartGame.EndGame;
begin
  GameEnded := True;
end;

//*************************************************
function TDartGame.GetPlayer(Index: Integer): TPlayer;
begin
	Result := fPlayers[Index];
end;

//*************************************************
function TDartGame.HasOptions: Boolean;
begin
  Result := False;
end;

//*************************************************
function TDartGame.GetPlayerCount: Integer;
begin
	Result := fPlayers.Count;
end;

//*************************************************
function TDartGame.GetStarterIndex: Integer;
begin
	Result := fStartPlayerIdx;
end;

//*************************************************
procedure TDartGame.SetOptions(AValue: TFrame);
begin
	fOptions := AValue;
end;

//*************************************************
procedure TDartGame.SetPlayer(Index: Integer; AValue: TPlayer);
begin
	fPlayers[Index] := AValue;
end;

//*************************************************
function TDartGame.MaxLegNo: Integer;
begin
	Result := (fLegs-1) * fPlayers.Count;
  if fAllowTie and (fLegs>1) and (fThisSet=MaxSetNo) then
		dec(Result)
end;

//*************************************************
function TDartGame.MaxSetNo: Integer;
begin
	Result := (fSets-1) * fPlayers.Count;
	if fAllowTie and (fSets>1) then
		dec(Result);
end;

//*************************************************
constructor TDartGame.Create;
begin
  fPlayerClass := TPlayer;
  fGameOptionsClass := TFrame;
  fPlayers := TPlayerList.Create;
end;

//*************************************************
destructor TDartGame.Destroy;
begin
  fPlayers.Clear;
  fPlayers.Free;
  fOptions.Free;
	inherited Destroy;
end;

//*************************************************
procedure TDartGame.Clear;
begin
  fPlayers.Clear;
  fStartPlayerIdx := 0;
  fNowToThrow := 0;
end;

//*************************************************
function TDartGame.AddPlayer(NewPlayer: TPlayer): Integer;
begin
  if NewPlayer = nil then
    NewPlayer := fPlayerClass.Create;
	Result := fPlayers.Add(NewPlayer);
end;

//*************************************************
procedure TDartGame.SelectNextToThrow;
var
	I: Integer;
begin
  I := fNowToThrow;
	repeat
		fNowToThrow := succ(fNowToThrow) mod fPlayers.Count;
	until fPlayers[fNowToThrow].Enabled or (fNowToThrow = I);
  if not fPlayers[fNowToThrow].Enabled then
    EndLeg;
end;

//*************************************************
procedure TDartGame.SelectPriorToThrow;
var
	I: Integer;
begin
  I := fNowToThrow;
	repeat
		fNowToThrow := (pred(fNowToThrow) + fPlayers.Count) mod fPlayers.Count;
	until fPlayers[fNowToThrow].Enabled or (fNowToThrow = I);
  if not fPlayers[fNowToThrow].Enabled then
    EndLeg;
end;

//*************************************************
function TDartGame.GetPlayerToThrow: TPlayer;
begin
	Result := Player[NowToThrow];
end;

//*************************************************
procedure TDartGame.ThrowDone(aPlayer: TPlayer);
begin
  SelectNextToThrow;
  PlayerToThrow.Throw;
end;

//*************************************************
procedure TDartGame.ThrowCancel(aPlayer: TPlayer);
begin
  SelectPriorToThrow;
  if PlayerToThrow.CanUndoThrow then
		PlayerToThrow.UndoThrow
  else begin
    SelectNextToThrow;
    PlayerToThrow.Throw;
	end;
end;

//*************************************************
procedure TDartGame.CheckOut(aPlayer: TPlayer);
begin
	if Assigned(aPlayer) then
		aPlayer.LegsWon := aPlayer.LegsWon + 1;
	EndLeg;
end;

//*************************************************
procedure TDartGame.LoseOut(aPlayer: TPlayer);
begin
  SelectNextToThrow;
  if fNowToThrow = -1 then
		EndLeg
  else
		PlayerToThrow.Throw;
end;

//**************************************************************************************************
	{ TPlayer }
//**************************************************************************************************

//*************************************************
constructor TPlayer.Create;
begin
  fNickname := '';
  fGame := nil;
  fEnabled := False;
  fThrowing := False;
  fThrow := TThrow.Create;
end;

//*************************************************
procedure TPlayer.SetThrowing(AValue: Boolean);
begin
	if fThrowing=AValue then
		Exit;
	fThrowing:=AValue;
end;

//*************************************************
procedure TPlayer.SetNickname(AValue: string);
begin
	if fNickname = AValue then
    Exit;
	fNickname := AValue;
end;

//*************************************************
procedure TPlayer.SetEnabled(AValue: Boolean);
begin
	if fEnabled = AValue then
  	Exit;
	fEnabled := AValue;
end;

//*************************************************
procedure TPlayer.InitGame(TheGame: TDartGame);
begin
  fGame := TheGame;
	Enabled := True;
  Throwing := False;
end;

//*************************************************
procedure TPlayer.InitLeg(AsFirstToThrow: Boolean);
var
	I: Integer;
begin
	fFirstToThrow := AsFirstToThrow;
  for I := 0 to pred(Length(fThrowList)) do
		fThrowList[I].Free;
	SetLength(fThrowList, 0);
	ClearCurrentThrow;
end;

//*************************************************
procedure TPlayer.ClearCurrentThrow;
begin
	CurrentThrow.Reset;
end;

//*************************************************
procedure TPlayer.ExecuteThrow;
begin
	ClearCurrentThrow;
end;

//*************************************************
procedure TPlayer.Throw;
begin
	Throwing := True;
  if Enabled then
		ExecuteThrow
	else
    ThrowDone;
	Throwing := False;
end;

//*************************************************
procedure TPlayer.AddCurrentThrowToList;
var
	I: Integer;
begin
  I := Length(fThrowList);
	SetLength(fThrowList, I+1);
	fThrowList[I] := TThrow.Create;
	fThrowList[I].Assign(CurrentThrow);
end;

//*************************************************
procedure TPlayer.ThrowDone;
begin
	AddCurrentThrowToList;
  if IsCheckOut then
    CheckOut
  else if IsLoseOut then
    LoseOut
  else
  	Game.ThrowDone(Self);
end;

//*************************************************
procedure TPlayer.ThrowCancel;
begin
  Game.ThrowCancel(Self);
end;

//*************************************************
procedure TPlayer.UndoThrow;
begin
  if CanUndoThrow then
	  ExecuteUndoAction;
	Throw;
end;

//*************************************************
procedure TPlayer.ExecuteUndoAction;
begin
	if ThrowCount > 0 then
	begin
		fThrowList[pred(ThrowCount)].Free;
		SetLength(fThrowList, pred(ThrowCount));
	end;
	ClearCurrentThrow;
end;

//*************************************************
function TPlayer.GetScoreBoard: TWinControl;
begin
  if Assigned(fGame) then
		Result := fGame.ScoreBoard
  else
    Result := nil;
end;

//*************************************************
function TPlayer.GetThrow(No: Word): TThrow;
begin
  if (No > ThrowCount) or (No=0) then
		Result := CurrentThrow
	else
		Result := fThrowList[pred(No)];
end;

//*************************************************
function TPlayer.GetLastThrow: TThrow;
begin
  Result := ThrowList[ThrowCount];
end;

//*************************************************
function TPlayer.GetThrowCount: Integer;
begin
	Result := Length(fThrowList);
end;

//*************************************************
function TPlayer.GetGame: TDartGame;
begin
  if Assigned(fGame) then
  	Result := fGame
  else
    raise Exception.Create(Nickname + '.Game not Assigned.');
end;

//*************************************************
function TPlayer.CanUndoThrow: Boolean;
begin
  Result := not fStartPlayer or (ThrowCount > 0);
end;

//*************************************************
function TPlayer.IsCheckOut: Boolean;
begin
  Result := False;
end;

//*************************************************
function TPlayer.IsLoseOut: Boolean;
begin
	Result := False;
end;

//*************************************************
procedure TPlayer.CheckOut;
begin
  Enabled := False;
  Game.CheckOut(Self);
end;

//*************************************************
procedure TPlayer.LoseOut;
begin
  Enabled := False;
  Game.LoseOut(Self);
end;

end.

