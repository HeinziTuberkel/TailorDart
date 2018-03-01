unit playgame;

{$mode objfpc}{$H+}

interface

uses
  Windows,
	DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

	{ TFrmPlayGame }

	TFrmPlayGame = class(TForm)
		ScrBxPlayers: TScrollBox;
		procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
		procedure FormResize(Sender: TObject);
		procedure FormShow(Sender: TObject);
	private
    ActiveGame: TDartGame;
    FontID: array of Cardinal;

    procedure SetScreenPos;
 		procedure LoadFonts;
		procedure UnloadFonts;
	public
    procedure PlayDartGame(ThisGame: TDartGame);
    procedure OnEndGame(Sender: TObject);
    procedure ClearGameBoard;
    procedure ShowGameSelector;
	end;

var
	FrmPlayGame: TFrmPlayGame;

implementation

{$R *.lfm}

uses
	LResources,
  TSLibGraphics,
	TSLib,
  SelectGame;


{ TFrmPlayGame }

procedure TFrmPlayGame.FormCreate(Sender: TObject);
begin
  ActiveGame := nil;
  LoadFonts;
end;

procedure TFrmPlayGame.FormDestroy(Sender: TObject);
begin
  UnloadFonts;
end;

procedure TFrmPlayGame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	if Assigned(ActiveGame) and ActiveGame.NeedKeyDown then
		ActiveGame.OnKeyDown(Sender, Key, Shift);
end;

procedure TFrmPlayGame.FormResize(Sender: TObject);
begin
	if FrmSelectGame.Showing and (FrmSelectGame.Parent = Self) then
		FrmSelectGame.AlignToParent;
end;

procedure TFrmPlayGame.FormShow(Sender: TObject);
begin
  if ActiveGame = nil then
	 	ShowGameSelector;
end;

procedure TFrmPlayGame.PlayDartGame(ThisGame: TDartGame);
begin
  ActiveGame := ThisGame;
	ActiveGame.InitGame(Self.ScrBxPlayers);
  BorderStyle := bsNone;
  WindowState := wsFullScreen;
	ActiveGame.OnEndGame := @OnEndGame;
	ActiveGame.PlayGame;
end;

procedure TFrmPlayGame.LoadFonts;
var
 	Path: string;
begin
	Path := ApplicationPath + 'fonts\';
  SetLength(FontID, 3);
	if LoadTemporaryFont(Path + 'blzee.ttf') then
		SendMessage(Handle, WM_FONTCHANGE, 0, 0);
	if LoadTemporaryFont(Path + 'chawp.ttf') then
		SendMessage(Handle, WM_FONTCHANGE, 0, 0);
  if LoadTemporaryFont(Path + 'ARCENA.ttf') then
		SendMessage(Handle, WM_FONTCHANGE, 0, 0);
end;

procedure TFrmPlayGame.UnloadFonts;
begin
	if UnloadTemporaryFont('chawp.ttf')
  	or UnloadTemporaryFont('blzee.ttf')
    or UnloadTemporaryFont('ARCENA.ttf')
	then
		SendMessage(Handle, WM_FONTCHANGE, 0, 0);
end;

procedure TFrmPlayGame.SetScreenPos;
var
  Dsp: TMonitor;
begin
  Dsp := Screen.MonitorFromPoint(Point(Left, Top));
  Left := (Dsp.Width - Width) DIV 2;
  Top := (Dsp.Height - Height) DIV 2;
end;

procedure TFrmPlayGame.OnEndGame(Sender: TObject);
begin
	ActiveGame := nil;
 	ShowGameSelector;
end;

procedure TFrmPlayGame.ClearGameBoard;
begin

end;

procedure TFrmPlayGame.ShowGameSelector;
begin
  ClearGameBoard;
  with FrmSelectGame do
  begin
		Parent := Self;
  	AlignToParent;
		Show;
	end;
end;

end.

