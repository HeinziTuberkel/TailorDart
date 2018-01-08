unit DartClasses;
{$mode objfpc}{$H+}

interface

uses
  Forms,
	fgl, Controls,
	Classes, SysUtils;

type
  NGameMode = (gmSingle, gmBestOfX, gmFirstToX, gmEndless);
  //NThrowResult = (trDone, trCancel, trCheckOut, trLoseOut);

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
	{ TPlayer }
//****************************************************************************

	TPlayer = class(TObject)
	private
		fGame: TDartGame;
		fNickname: string;
		fEnabled: Boolean;
		fStartPlayer: Boolean;
		fThrowing: Boolean;
		function GetGame: TDartGame;
  function GetScoreBoard: TWinControl;
    procedure SetNickname(AValue: string);
		procedure SetThrowing(AValue: Boolean);
  protected
  	procedure ExecuteThrow; virtual; abstract;
    procedure ExecuteUndoAction; virtual; abstract;
		procedure SetEnabled(AValue: Boolean); virtual;
    //CheckOut and LoseOut: called internally when the entered throw
    // leads to winning or losing the game. These methods are triggered by the Result of
    // functions IsCheckOut / IsLoseOut inside the process of ThrowDone.
		procedure CheckOut; virtual;
		procedure LoseOut; virtual;
	public
    constructor Create; virtual;
		procedure InitGame(TheGame: TDartGame); virtual;
    procedure InitLeg; virtual;
    //Initiates the throw. It is completed by calling either ThrowDone or ThrowCancel.
		procedure Throw; virtual;
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
		fGameOptionsClass: TGameOptionsClass;
  	fPlayerClass: TPlayerClass;
		fPlayers: TPlayerList;
    fOptions: TFrame;
		fScoreBoard: TWinControl;
		fThrowCancel: MThrowCancel;
		fThrowDone: MThrowDone;
    fGameEnded: Boolean;
		fUpPlayerIdx: Integer;
    fStartPlayerIdx: Integer;
		function GetPlayer(Index: Integer): TPlayer;
		function GetPlayerCount: Integer;
		function GetStarterIndex: Integer;
		function GetUpPlayer: TPlayer;
		procedure SetPlayer(Index: Integer; AValue: TPlayer);
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
    //Adds a Player to the List fPlayers. Returns the new Player's Index. Returns -1 if adding failed.
		function AddPlayer(NewPlayer: TPlayer=nil): Integer; virtual;


    procedure NextPlayerUp; virtual;
    procedure PriorPlayerUp; virtual;

    //PlayDart starts the game.
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
    //The game is finished.
    procedure EndGame; virtual;

    property Options: TFrame read fOptions write SetOptions;
    property ScoreBoard: TWinControl read fScoreBoard;
		property PlayerCount: Integer read GetPlayerCount;
		property Player[Index: Integer]: TPlayer read GetPlayer write SetPlayer;
    //UpPlayer: Index of next player to enter his score.
		property UpPlayerIndex: Integer read fUpPlayerIdx;
    property UpPlayer: TPlayer read GetUpPlayer;
    property StartPlayerIndex: Integer read fStartPlayerIdx;
	end;


implementation

uses
  ExtCtrls;

//****************************************************************************
	{ HPlayerList }
//****************************************************************************

//*************************************************
function HPlayerList.MaxIndex: Integer;
begin
 	Result := pred(Count);
end;

//****************************************************************************
	{ TDartGame }
//****************************************************************************

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
  fStartPlayerIdx := -1;
  fUpPlayerIdx := -1;
  fStartPlayerIdx := 0;
  fUpPlayerIdx := 0;
end;

//*************************************************
procedure TDartGame.InitGame(TheScoreBoard: TWinControl);
var
  I: Integer;
begin
  fScoreBoard := TheScoreBoard;
	for I := 0 to fPlayers.MaxIndex do
  begin
    fPlayers[I].InitGame(Self);
  	fPlayers[I].IsStartPlayer := I = fStartPlayerIdx;
	end;
 	fUpPlayerIdx := fStartPlayerIdx;
end;

//*************************************************
function TDartGame.AddPlayer(NewPlayer: TPlayer): Integer;
begin
  if NewPlayer = nil then
    NewPlayer := fPlayerClass.Create
	Result := fPlayers.Add(NewPlayer);
end;

//*************************************************
procedure TDartGame.NextPlayerUp;
var
	I: Integer;
begin
  I := fUpPlayerIdx;
	repeat
		fUpPlayerIdx := succ(fUpPlayerIdx) mod fPlayers.Count;
	until fPlayers[fUpPlayerIdx].Enabled or (fUpPlayerIdx = I);
  if not fPlayers[fUpPlayerIdx].Enabled then
    fUpPlayerIdx := -1;
end;

//*************************************************
procedure TDartGame.PriorPlayerUp;
var
	I: Integer;
begin
  I := fUpPlayerIdx;
	repeat
		fUpPlayerIdx := (pred(fUpPlayerIdx) + fPlayers.Count) mod fPlayers.Count;
	until fPlayers[fUpPlayerIdx].Enabled or (fUpPlayerIdx = I);
  if not fPlayers[fUpPlayerIdx].Enabled then
    fUpPlayerIdx := -1;
end;

//*************************************************
function TDartGame.GetUpPlayer: TPlayer;
begin
	if fUpPlayerIdx < 0 then
    Result := nil
	else
		Result := Player[UpPlayerIndex];
end;

//*************************************************
procedure TDartGame.PlayGame;
begin
  if PlayerCount > 0 then
	  Player[0].Throw;
end;

//*************************************************
procedure TDartGame.ThrowDone(aPlayer: TPlayer);
begin
  NextPlayerUp;
  UpPlayer.Throw;
end;

//*************************************************
procedure TDartGame.ThrowCancel(aPlayer: TPlayer);
begin
  PriorPlayerUp;
  if Player[UpPlayerIndex].CanUndoThrow then
		UpPlayer.UndoThrow
  else begin
    NextPlayerUp;
    UpPlayer.Throw;
	end;
end;

//*************************************************
procedure TDartGame.CheckOut(aPlayer: TPlayer);
begin
	EndGame;
end;

//*************************************************
procedure TDartGame.LoseOut(aPlayer: TPlayer);
begin
  NextPlayerUp;
  if fUpPlayerIdx = -1 then
		EndGame
  else
		UpPlayer.Throw;
end;

//*************************************************
procedure TDartGame.EndGame;
begin
  GameEnded := True;
end;

//****************************************************************************
	{ TPlayer }
//****************************************************************************

//*************************************************
constructor TPlayer.Create;
begin
  fNickname := '';
  fGame := nil;
  fEnabled := False;
  fThrowing := False;
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
function TPlayer.GetScoreBoard: TWinControl;
begin
  if Assigned(fGame) then
		Result := fGame.ScoreBoard
  else
    Result := nil;
end;

function TPlayer.GetGame: TDartGame;
begin
  if Assigned(fGame) then
  	Result := fGame
  else
    raise Exception.Create(Nickname + '.Game not Assigned.');
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
procedure TPlayer.UndoThrow;
begin
  if CanUndoThrow then
	  ExecuteUndoAction;
	Throw;
end;

//*************************************************
function TPlayer.CanUndoThrow: Boolean;
begin
  Result := not fStartPlayer;
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
procedure TPlayer.ThrowDone;
begin
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

