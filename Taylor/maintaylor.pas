unit maintaylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, class_taylor, math;

type

  { TfrmTaylor }

  TfrmTaylor = class(TForm)
    BbtnExecute: TButton;
    cboFunctions: TComboBox;
    ediError: TEdit;
    ediX: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memResult: TMemo;
    Panel1: TPanel;
    rdgAngleType: TRadioGroup;
    stgData: TStringGrid;
    procedure BbtnExecuteClick(Sender: TObject);
    procedure cboFunctionsChange(Sender: TObject);
    procedure ediXKeyPress(Sender: TObject; var Key: char);
    procedure ediErrorKeyPress( Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
     Taylor: TTaylor;
  public

  end;

var
  frmTaylor: TfrmTaylor;

implementation

const
     ColN = 0;
     ColSequence = 1;
     ColError = 2;

{$R *.lfm}

{ TfrmTaylor }

procedure TfrmTaylor.BbtnExecuteClick(Sender: TObject);
var
    x: Real;

    procedure FillStringGrid;
    var i: Integer;
        Error: Real;
    begin

      with stgData do
      for i:= 1 to RowCount - 1 do begin
          //Error:= abs( sin(x) - StrToFloat( Cells[ ColSequence, i ] ) );
          Error:= abs( StrToFloat(Cells[ColSequence,i-1]) - StrToFloat( Cells[ ColSequence, i ] ) );
          Cells[ ColN, i ]:= IntToStr( i );
          Cells[ ColError, i ]:= FloatToStr( Error);
//            Cells[ColError, i] := FloatToStr(sin(x)) + ' - ' +( Cells[ ColSequence, i ])+'='+FloatToStr(Error);
      end;

    end;

begin
  Taylor:= TTaylor.create;
  Taylor.x:= StrToFloat( ediX.Text );
  (* when we sincronize *)
//  Taylor.FunctionType:= Integer( cboFunctions.ItemIndex);
  Taylor.FunctionType:= Int64( cboFunctions.Items.Objects[ cboFunctions.ItemIndex ] );
  Taylor.ErrorAllowed:= StrToFloat( ediError.Text );

  (* when we dont sincronize *)
  case rdgAngleType.ItemIndex of
       0: Taylor.AngleType:= AngleSexagedecimal;
       1: Taylor.AngleType:= AngleRadian;
  end;
  if (Taylor.FunctionType>4) then
     if(abs(Taylor.x)>=1) then ShowMessage('Invalid x.'+#13#10+ '|x|>1')
     else memResult.Lines.Add( cboFunctions.Text + '(' +  ediX.Text + ') = ' + FloatToStr( Taylor.Execute() ) )
  else memResult.Lines.Add( cboFunctions.Text + '(' +  ediX.Text + ') = ' + FloatToStr( Taylor.Execute() ) ) ;

  with stgData do begin
      RowCount:= Taylor.Sequence.Count;
      Cols[ ColSequence ].Assign( Taylor.Sequence );
  end;
  FillStringGrid;
  Taylor.Destroy;
end;

procedure TfrmTaylor.cboFunctionsChange(Sender: TObject);
begin

end;

procedure TfrmTaylor.ediXKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in [#8, '0'..'9', '-', DecimalSeparator]) then begin
    ShowMessage('Invalid key: ' + Key);
    Key := #0;
  end
  else if ((Key = DecimalSeparator) or (Key = '-')) and
          (Pos(Key, ediX.Text) > 0) then begin
    ShowMessage('Invalid Key: twice ' + Key);
    Key := #0;
  end
  else if (Key = '-') and
          (ediX.SelStart <> 0) then begin
    ShowMessage('Only allowed at beginning of number: ' + Key);
    Key := #0;
  end;
end;

procedure TfrmTaylor.ediErrorKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in [#8, '0'..'9', DecimalSeparator]) then begin
    ShowMessage('Invalid key: ' + Key);
    Key := #0;
  end
  else if ((Key = DecimalSeparator)) and
          (Pos(Key, ediError.Text) > 0) then begin
    ShowMessage('Invalid Key: twice ' + Key);
    Key := #0;
  end
  end;


procedure TfrmTaylor.FormCreate(Sender: TObject);
begin
   Taylor:= TTaylor.create;
   cboFunctions.Items.Assign( Taylor.FunctionList );
   cboFunctions.ItemIndex:= 0;

end;

procedure TfrmTaylor.FormDestroy(Sender: TObject);
begin
  Taylor.Destroy;
end;

end.

