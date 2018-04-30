unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, ExtCtrls, ParseMath,lagrange;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnExec: TButton;
    btnEval: TButton;
    stgLagrange: TStringGrid;
    x,y: TSTringList;
    ediPuntos: TEdit;
    ediValue: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    stgPoints: TStringGrid;
    procedure btnEvalClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure ediPuntosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    pmath: TParseMath;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ediPuntosChange(Sender: TObject);
var
  temp: string;
  tempint :integer;
begin
  temp:=ediPuntos.Text;
  if(temp='')then tempint:=1
  else tempint:= StrToInt(temp)+1;
  stgPoints.RowCount:=tempint;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

procedure TForm1.btnExecClick(Sender: TObject);
var
  i: integer;
  Lagrange: TLagrange;
begin
  x:=TStringList.Create;
  y:=TStringList.Create;
  with stgPoints do begin
    for i:=1 to Rowcount-1 do begin
      if (Cells[0,i]='') then x.add('0')
      else x.Add(Cells[0,i]);
      if (Cells[1,i]='') then y.add('0')
      else y.Add(Cells[1,i]);
    end;
  end;
  Lagrange:=TLagrange.Create;
  stgLagrange.Cells[1,0]:=Lagrange.polinomio(x,y,StrToFloat(ediValue.Text));

end;

procedure TForm1.btnEvalClick(Sender: TObject);
var
  func: String;
  value,temp: double;
begin
  value:=StrToFloat(ediValue.text);
  stgLagrange.cells[0,1]:='p('+FloatToStr(value)+')=';
  func:=stgLagrange.Cells[1,0];
  pmath:=TParseMath.create();
  pmath.Expression:=func;
  pmath.AddVariable('x',value);
  temp:=pmath.Evaluate();
  stgLagrange.Cells[1,1]:=FloatToStr(temp);
  pmath.destroy;
end;

end.

