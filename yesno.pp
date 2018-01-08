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
		PnlButtons: TPanel;
		procedure FormKeyPress(Sender: TObject; var Key: char);
  procedure ImgBtnNoClick(Sender: TObject);
		procedure ImgBtnYesClick(Sender: TObject);
	private
		{ private declarations }
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
    AutoSize := False;
    LbQuestion.Caption := Question;
    W := LbQuestion.UndockWidth + LbQuestion.BorderSpacing.Left + LbQuestion.BorderSpacing.Right;
		if ClientWidth > W then
    	ClientWidth := W;
    ClientHeight := LbQuestion.Height + LbQuestion.BorderSpacing.Top
    								+ LbQuestion.BorderSpacing.Bottom
                    + PnlButtons.BoundsRect.Bottom - PnlButtons.BoundsRect.Top + 1;
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

procedure TFrmYesNo.ImgBtnYesClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.

