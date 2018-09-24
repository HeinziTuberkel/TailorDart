unit YesNo;

{$mode objfpc}{$H+}

interface

uses
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
	StdCtrls, TS_Panel;

type

	{ TFrmYesNo }

 	TFrmYesNo = class(TForm)
		ImgBtnNo: TImage;
		ImgBtnYes: TImage;
		LbQuestion: TLabel;
		Panel1: TPanel;
		PnlButtons: TPanel;
		procedure FormKeyPress(Sender: TObject; var Key: char);
		procedure FormShow(Sender: TObject);
  procedure ImgBtnNoClick(Sender: TObject);
		procedure ImgBtnYesClick(Sender: TObject);
	private
		function CalcSize(ForMessage: string; SetSize: Boolean = True): TPoint;
	public
		{ public declarations }
	end;

var
	FrmYesNo: TFrmYesNo;

function Confirm(Question: string): Boolean;

implementation

function Confirm(Question: string): Boolean;
var
  H, W: Integer;
begin
	if not Assigned(FrmYesNo) then
  	Application.CreateForm(TFrmYesNo, FrmYesNo);
  with FrmYesNo do
  begin
    LbQuestion.Caption := Question;
		CalcSize(Question, True);
  //  W := LbQuestion.UndockWidth + LbQuestion.BorderSpacing.Left + LbQuestion.BorderSpacing.Right;
		//if ClientWidth > W then
  //  	ClientWidth := W;
  //  ClientHeight := LbQuestion.Height + LbQuestion.BorderSpacing.Top
  //  								+ LbQuestion.BorderSpacing.Bottom
  //                  + PnlButtons.BoundsRect.Bottom - PnlButtons.BoundsRect.Top + 1;
  	FrmYesNo.ShowModal;
  	Result := FrmYesNo.ModalResult = mrOK;
	end;
end;

{$R *.lfm}

{ TFrmYesNo }

procedure TFrmYesNo.ImgBtnNoClick(Sender: TObject);
begin
	ModalResult := mrCancel;
end;

procedure TFrmYesNo.FormKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
  	#10, 'Y', 'J', 'j', 'y', '1', 's', 'S':
    	ModalResult := mrOK;
   	#27, 'N', 'n', '0':
      ModalResult := mrCancel;
   	else
      Key := #0;
	end;
end;

procedure TFrmYesNo.FormShow(Sender: TObject);
begin
  CalcSize(LbQuestion.Caption);
end;

procedure TFrmYesNo.ImgBtnYesClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

function TFrmYesNo.CalcSize(ForMessage: string; SetSize: Boolean = True): TPoint;
const
	AddW = 50;
	AddH = 50;
var
	MaxW, MaxH, FontH, W, H: Integer;
  AFont: TFont;
  R : TRect;
  DC : hDC;
  Flags: Cardinal;
begin
  W := 0;
  H := 0;
	MaxW := Screen.Width div 2;
	MaxH := Screen.Height div 2;

  FontH := abs(LbQuestion.Font.Height);
  AFont := TFont.Create;
  AFont.Assign(LbQuestion.Font);
	//LbQuestion.CalcFittingFontHeight(ForMessage, MaxW, MaxH, FontH, W, H);
  Flags := DT_CALCRECT or DT_NOPREFIX or DT_EXPANDTABS or DT_WORDBREAK;
  R := Rect(0,0, MaxWidth, MaxHeight*2);
  DC := GetDC(Self.Handle);
  try
    DrawText(DC, PChar(Formessage), Length(ForMessage), R, Flags);
    NeededWidth := R.Right - R.Left;
    NeededHeight := R.Bottom - R.Top;

  finally
    ReleaseDC(Parent.Handle, DC);
	end;

	Result := Point(W + 2*BorderWidth + AddW, H + 2*BorderWidth + PnlButtons.Height + AddH);
	if SetSize then
	begin
		Width := Result.X;
		Height := Result.Y;
	end;
end;

end.

