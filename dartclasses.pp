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
		fIndex: Integer;
		fLoseOut: MLoseOut;
		fNickname: string;
		fCheckOut: MCheckOut;
		fEnabled: Boolean;
		fScoreBoard: TWinControl;
		fThrowCancel: MThrowCancel;
		fThrowDone: MThrowDone;
		fThrowing: Boolean;
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
		procedure InitGame(TheGame: TDartGame; NewIndex: Integer); virtual;
		procedure Throw; virtual;
		procedure UndoThrow; virtual;
    function CanUndoThrow: Boolean; virtual;

    //ThrowDone: called, when the player has finished entering his score.
		procedure ThrowDone; virtual;
    //ThrowCancel: called, when the player has cancelled entring the score (=undo the prior players last action)
		procedure ThrowCancel; virtual;
		//IsCheckOut: Returns TRUE, when the player is throwing and the current Entry results in winning the game/leg
		function IsCheckOut: Boolean; virtual;
		//IsLoseOut: Returns TRUE, when the player is throwing and the current Entry results in losing the game/leg
		function IsLoseOut: Boolean; virtual;

    //Game: The TDartGame object, this player is playing.
    property Game: TDartGame read fGame;
    //The Container on which the score board (TFrame) is placed.
    property ScoreBoard: TWinControl read fScoreBoard;

		//Enabled: True, when this player is allowed to score in the current game.
		//				 When set to FALSE the "Throw" method does noting and directly calls "ThrowDone"
		property Enabled: Boolean read fEnabled write SetEnabled;
    //Throwing: True, when this player is about to enter his throw.
		property Throwing: Boolean read fThrowing write SetThrowing;
    //Index: Number of this player in the game's player list.
		property Index: Integer read fIndex write fIndex;

    property Nickname: string read fNickname write SetNickname;

		property OnThrowDone: MThrowDone read fThrowDone write fThrowDone;
		property OnThrowCancel: MThrowCancel read fThrowCancel write fThrowCancel;
		property OnCheckOut: MCheckOut read fCheckOut write fCheckOut;
		property OnLoseOut: MLoseOut read fLoseOut write fLoseOut;
	end;

//****************************************************************************
	{ TDartGame }
//****************************************************************************

	TDartGame = class(TObject)
	private
		fLegsIdx: Integer;
		fLegsMax: Integer;
		fLegsMode: NGameMode;
		fGameOptionsClass: TGameOptionsClass;
  	fPlayerClass: TPlayerClass;
		fGameEnds: TNotifyEvent;
		fLoseOut: MLoseOut;
		fCheckOut: MCheckOut;
    fOptions: TFrame;
		fPlayers: TPlayerList;
		fScoreBoard: TWinControl;
		fSetsIdx: Integer;
		fSetsMax: Integer;
		fSetsMode: NGameMode;
		fStartPlayerIdx: Integer;
    fUpPlayerIdx: Integer;
		fThrowCancel: MThrowCancel;
		fThrowDone: MThrowDone;
    fGameEnded: Boolean;
		function GetPlayer(Index: Integer): TPlayer;
		function GetPlayerCount: Integer;
		function GetStarterIndex: Integer;
		procedure SetPlayer(Index: Integer; AValue: TPlayer);
  protected
    property PlayerClass: TPlayerClass read fPlayerClass write fPlayerClass;
    property OptionsClass: TGameOptionsClass read fGameOptionsClass	write fGameOptionsClass;
    property GameEnded: Boolean read fGameEnded write fGameEnded;
		procedure SetOptions(AValue: TFrame); virtual;
	public
    constructor Create; virtual;
    destructor Destroy; override;
    //Clear removes all players and sets all properties to default values.
		procedure Clear; virtual;

		function HasOptions: Boolean; virtual;
    //InitGame sets all game Start values whithout removing Players.
    procedure InitGame(TheScoreBoard: TWinControl); virtual;
    //Adds a Player to the List fPlayers. Returns the new Player's Index. Returns -1 if adding failed.
		function AddPlayer(NewPlayer: TPlayer=nil): Integer; virtual;
    procedure NextPlayerIndex(var CurrentIndex: Integer); virtual;
    procedure PriorPlayerIndex(var CurrentIndex: Integer); virtual;

    //PlayDart starts the game.
    //	All further game actions are conducted by the methods below (ThrowDone/Cancel, Check/LoseOut, EndGame);
		procedure PlayDart; virtual;
    //ThrowDone: The current player has entered his score.
		procedure ThrowDone(aPlayer: TPlayer; PlayerIndex: Integer); virtual;
    //ThrowCancel: current player has canceled. Undo the prior players throw and redo.
		procedure ThrowCancel(aPlayer: TPlayer; PlayerIndex: Integer); virtual;
    //ChechOut: current player finished this leg.
		procedure CheckOut(aPlayer: TPlayer; PlayerIndex: Integer); virtual;
    //LoseOut: current player is out of the game.
		procedure LoseOut(aPlayer: TPlayer; PlayerIndex: Integer); virtual;
    //The game is finished.
    procedure EndGame; virtual;

    property Options: TFrame read fOptions write SetOptions;
    property ScoreBoard: TWinControl read fScoreBoard;
		property PlayerCount: Integer read GetPlayerCount;
		property Player[Index: Integer]: TPlayer read GetPlayer write SetPlayer;
    //UpPlayer: Index of next player to enter his score.
		property UpIndex: Integer read fUpPlayerIdx;
		property StarterIndex: Integer read GetStarterIndex;

		property OnThrowDone: MThrowDone read fThrowDone write fThrowDone;
		property OnThrowCancel: MThrowCancel read fThrowCancel write fThrowCancel;
		property OnCheckOut: MCheckOut read fCheckOut write fCheckOut;
		property OnLoseOut: MLoseOut read fLoseOut write fLoseOut;
		property OnGameEnd: TNotifyEvent read fGameEnds write fGameEnds;
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
  fSetsIdx := 0;
  fLegsIdx := 0;
end;

//*************************************************
procedure TDartGame.InitGame(TheScoreBoard: TWinControl);
var
  I: Integer;
begin
  fScoreBoard := TheScoreBoard;
	for I := 0 to fPlayers.MaxIndex do
    fPlayers[I].InitGame(Self, I);
  fStartPlayerIdx := 0;
  fUpPlayerIdx := 0;
end;

//*************************************************
function TDartGame.AddPlayer(NewPlayer: TPlayer): Integer;
begin
  if NewPlayer = nil then
    NewPlayer := fPlayerClass.Create;
	Result := fPlayers.Add(NewPlayer);
  NewPlayer.Index := Result;
  NewPlayer.OnThrowDone := @ThrowDone;
  NewPlayer.OnThrowCancel := @ThrowCancel;
  NewPlayer.OnCheckOut := @CheckOut;
  NewPlayer.OnLoseOut := @LoseOut;
end;

//*************************************************
procedure TDartGame.PlayDart;
begin
  fUpPlayerIdx := fStartPlayerIdx;
  Player[fUpPlayerIdx].Throw;
 // repeat
 // 	case of
 //   	trDone:
 //     	ThrowDone(Player[fUpPlayerIdx], fUpPlayerIdx);
 //   	trCancel:
 //       ThrowCancel(Player[fUpPlayerIdx], fUpPlayerIdx);
 //     trCheckOut:
 //       CheckOut(Player[fUpPlayerIdx], fUpPlayerIdx);
 //     trLoseOut:
 //       LoseOut(Player[fUpPlayerIdx], fUpPlayerIdx);
	//	end;
	//until GameEnded;
end;

//*************************************************
procedure TDartGame.NextPlayerIndex(var CurrentIndex: Integer);
var
  StartIndex: Integer;
begin
  StartIndex := CurrentIndex;
	repeat
		CurrentIndex := succ(CurrentIndex) mod fPlayers.Count;
	until fPlayers[CurrentIndex].Enabled or (CurrentIndex = StartIndex);
  if not fPlayers[CurrentIndex].Enabled then
    CurrentIndex := -1;
end;

//*************************************************
procedure TDartGame.PriorPlayerIndex(var CurrentIndex: Integer);
var
	StartIndex: Integer;
begin
  StartIndex := CurrentIndex;
  repeat
    CurrentIndex := (pred(CurrentIndex) + fPlayers.Count) mod fPlayers.Count;
	until fPlayers[CurrentIndex].Enabled or (CurrentIndex = StartIndex);
  if not fPlayers[CurrentIndex].Enabled then
    CurrentIndex := -1;
end;

//*************************************************
procedure TDartGame.ThrowDone(aPlayer: TPlayer; PlayerIndex: Integer);
begin
  NextPlayerIndex(fUpPlayerIdx);
  Player[fUpPlayerIdx].Throw;
end;

//*************************************************
procedure TDartGame.ThrowCancel(aPlayer: TPlayer; PlayerIndex: Integer);
begin
	PriorPlayerIndex(fUpPlayerIdx);
  if Player[fUpPlayerIdx].CanUndoThrow then
		Player[fUpPlayerIdx].UndoThrow
  else begin
    NextPlayerIndex(fUpPlayerIdx);
    Player[fUpPlayerIdx].Throw;
	end;
end;

//*************************************************
procedure TDartGame.CheckOut(aPlayer: TPlayer; PlayerIndex: Integer);
begin
	EndGame;
end;

//*************************************************
procedure TDartGame.LoseOut(aPlayer: TPlayer; PlayerIndex: Integer);
begin
  NextPlayerIndex(fUpPlayerIdx);
  if fUpPlayerIdx = -1 then
		EndGame
  else
		Player[fUpPlayerIdx].Throw;
end;

//*************************************************
procedure TDartGame.EndGame;
begin
  GameEnded := True;
  if Assigned(fGameEnds) then
    fGameEnds(Self);
end;

//****************************************************************************
	{ TPlayer }
//****************************************************************************

//*************************************************
constructor TPlayer.Create;
begin
  fNickname := '';
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
procedure TPlayer.InitGame(TheGame: TDartGame; NewIndex: Integer);
begin
  if NewIndex >= 0 then
    fIndex := NewIndex;
  fGame := TheGame;
  fScoreBoard := TheGame.ScoreBoard;
	Enabled := True;
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
end;

//*************************************************
function TPlayer.CanUndoThrow: Boolean;
begin
  Result := False;
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
	else if Assigned(fThrowDone) then
  	fThrowDone(Self, fIndex);
end;

//*************************************************
procedure TPlayer.ThrowCancel;
begin
	if Assigned(fThrowCancel) then
    fThrowCancel(Self, fIndex);
end;

//*************************************************
procedure TPlayer.CheckOut;
begin
  Enabled := False;
  if Assigned(fCheckOut) then
    fCheckOut(Self, fIndex);
end;

//*************************************************
procedure TPlayer.LoseOut;
begin
  Enabled := False;
	if Assigned(fLoseOut) then
    fLoseOut(Self, fIndex);
end;

end.

