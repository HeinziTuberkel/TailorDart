unit fr_Player;

{$mode objfpc}{$H+}

interface

uses
  DartClasses, YesNo,
  lmessages,
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons,
	ExtCtrls, TS_Panel;

const
  msgRemove = LM_USER + 456;

type
	{ TFrPlayer }
	TFrPlayer = class(TFrame)
		EdNickname: TEdit;
		ImgBtnRemove: TImage;
		Label1: TLabel;
		TSPanel1: TTSPanel;
  	procedure ImgBtnRemoveClick(Sender: TObject);
    procedure PlayerOnEnter(Sender: TObject);
	private
		fIndex: Integer;
    fOnDelete: MListItemDelete;
		function GetNickname: string;
    procedure CMRemove(var Msg); message msgRemove;
  protected
    procedure SetNickname(const Value: string);
	public
    constructor Create(TheOwner: TComponent; StartIndex: Integer; OnDelete: MListItemDelete); reintroduce;
    procedure Remove;
  	property Nickname: string read GetNickname write SetNickname;
    property Index: Integer read fIndex write fIndex;
	end;



implementation

{$R *.lfm}

uses
	LCLIntf;


{ TFrPlayer }

constructor TFrPlayer.Create(TheOwner: TComponent; StartIndex: Integer;
	OnDelete: MListItemDelete);
begin
  inherited Create(TheOwner);
  fIndex := StartIndex;
  fOnDelete := OnDelete;
  Nickname := '';
  OnEnter := @PlayerOnEnter;
end;

procedure TFrPlayer.Remove;
begin
  if Confirm('Delete Player ' + Nickname + '?') then
	  PostMessage(Handle, msgRemove, 0, 0);
end;

procedure TFrPlayer.ImgBtnRemoveClick(Sender: TObject);
begin
  Remove;
end;

procedure TFrPlayer.PlayerOnEnter(Sender: TObject);
begin
  EdNickname.SetFocus;
end;

function TFrPlayer.GetNickname: string;
begin
	Result := EdNickname.Text;
end;

procedure TFrPlayer.CMRemove(var Msg);
begin
  if Assigned(fOnDelete) then
		fOnDelete(Self, fIndex);
end;

procedure TFrPlayer.SetNickname(const Value: string);
begin
  if Value <> EdNickname.Text then
	  EdNickname.Text := Value;
end;

end.

