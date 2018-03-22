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
          Error:= abs( sin(x) - StrToFloat( Cells[ ColSequence, i ] ) );
          Cells[ ColN, i ]:= IntToStr( i );
          Cells[ ColError, i ]:= FloatToStr( Error );
      end;

    end;

begin
  Taylor:= TTaylor.create;
  Taylor.x:= StrToFloat( ediX.Text );
  (* when we sincronize *)
  Taylor.FunctionType:= Integer( cboFunctions.ItemIndex);
//  Taylor.FunctionType:= Integer( cboFunctions.Items.Objects[ cboFunctions.ItemIndex ] );
  Taylor.ErrorAllowed:= StrToFloat( ediError.Text );

  (* when we dont sincronize *)
  case rdgAngleType.ItemIndex of
       0: Taylor.AngleType:= AngleSexagedecimal;
       1: Taylor.AngleType:= AngleRadian;
  end;

  memResult.Lines.Add( cboFunctions.Text + '(' +  ediX.Text + ') = ' + FloatToStr( Taylor.Execute() ) ) ;

  with stgData do begin
      RowCount:= Taylor.Sequence.Count;
      Cols[ ColSequence ].Assign( Taylor.Sequence );
  end;
  FillStringGrid;

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
          (Pos(Key, Edit1.Text) > 0) then begin
    ShowMessage('Invalid Key: twice ' + Key);
    Key := #0;
  end
  else if (Key = '-') and
          (Edit1.SelStart <> 0) then begin
    ShowMessage('Only allowed at beginning of number: ' + Key);
    Key := #0;
  end;
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
