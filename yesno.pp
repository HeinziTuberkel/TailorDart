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
		Pnl: TPanel;
		PnlButtons: TPanel;
		procedure FormKeyPress(Sender: TObject; var Key: char);
		procedure FormShow(Sender: TObject);
  procedure ImgBtnNoClick(Sender: TObject);
		procedure ImgBtnYesClick(Sender: TObject);
		procedure PnlButtonsClick(Sender: TObject);
	private
 		procedure AfterShow(Data: PtrInt);
		procedure CalcSize;
	public
		{ public declarations }
	end;

const
	fontDefaultSize = 16;

var
	FrmYesNo: TFrmYesNo;

function Confirm(Question: string): Boolean;

implementation

uses
  lclintf,
  LCLType;

function Confirm(Question: string): Boolean;
begin
	if not Assigned(FrmYesNo) then
  	Application.CreateForm(TFrmYesNo, FrmYesNo);
  with FrmYesNo do
  begin
    LbQuestion.Caption := Question;
  	FrmYesNo.ShowModal;
  	Result := FrmYesNo.ModalResult = mrOK;
	end;
end;

{$R *.lfm}

{ TFrmYesNo }

procedure TFrmYesNo.FormShow(Sender: TObject);
begin
  Application.QueueAsyncCall(@AfterShow, 0);
end;

procedure TFrmYesNo.AfterShow(Data: PtrInt);
begin
  CalcSize;
end;

procedure TFrmYesNo.ImgBtnYesClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFrmYesNo.PnlButtonsClick(Sender: TObject);
begin
  if Sender is TControl then
	  ShowMessage(TControl(Sender).Name)
  else
    Showmessage('Klick');
end;

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

procedure TFrmYesNo.CalcSize;
type
	FontHeights = array[8..24] of Integer;
const
  MulW = 1.1;
  FontHeight:  FontHeights = (15, 16, 17, 18, 20, 21, 23, 26, 27, 29, 31, 33, 34, 36, 39, 42, 44);
var
	LineHeight, MaxW, MaxH, CenterW, CenterH, W, H: Integer;
  WFactor: Double;
begin
  W := 250; // Startbreite
  H := 40;  // Starthöhe
	MaxW := Screen.Width div 2;
	MaxH := Screen.Height div 2;
  LineHeight := FontHeight[Abs(LbQuestion.Font.Size)];
  LbQuestion.Align := alTop;
  with Pnl do
  begin
	  Align := alNone;
	  Width := W;
	  Height := H;
	  while (LbQuestion.Height > Height)
	  	or (LbQuestion.Width > Width)
	  do begin
	    if Height < MaxH then
	    begin
	      WFactor := 1 + LineHeight/Height;
	      Height := Height + LineHeight;
	    	if Width < MaxW then
					Width := Round(Width * WFactor);
	    end
	    else if Width < MaxW then
	    	Width := Round(Width * MulW)
	    else
	      Break;
	  end;
	  H := Height + 150;
	  W := Width + 60;
	  Align := alClient;
  end; //with Pnl
  LbQuestion.Align := alClient;
//	W := (Screen.Width - W) div 2;
//  H := (Screen.Height - H) div 2;
  Self.SetBounds((Screen.Width - W) div 2, (Screen.Height - H) div 2, W, H);

end;

end.

