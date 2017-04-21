unit Dartboard;

{$mode objfpc}{$H+}

interface

uses
	DartClasses,
	Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

	{ TFrmDartboard }

 TFrmDartboard = class(TForm)
	private
	public
  	function WirfDart(Ziel: RBoardPosition): RBoardPosition;
	end;

var
	FrmDartboard: TFrmDartboard;

implementation

{$R *.lfm}




{ TFrmDartboard }

function TFrmDartboard.WirfDart(Ziel: RBoardPosition): RBoardPosition;
begin

end;

end.

