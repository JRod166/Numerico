unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Grids, ExtCtrls, ParseMath, lagrange, Cerrados;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnGraph1: TButton;
    btnExec: TButton;
    btnEval: TButton;
    btnGraph2: TButton;
    btnIntersec: TButton;
    Chart1: TChart;
    Chart1FuncSeries1: TFuncSeries;
    Chart1FuncSeries2: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    Memo1: TMemo;
    stgLagrange: TStringGrid;
    x_list,y_list: TSTringList;
    ediPuntos: TEdit;
    ediValue: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    stgPoints: TStringGrid;
    procedure btnEvalClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnGraph1Click(Sender: TObject);
    procedure btnGraph2Click(Sender: TObject);
    procedure btnIntersecClick(Sender: TObject);
    procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure Chart1FuncSeries2Calculate(const AX: Double; out AY: Double);
    procedure ediPuntosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    pmath: TParseMath;
    func: TStringList;
    minval1,minval2,maxval1,maxval2,maxtemp,mintemp: Real;
    xpoint: TStringList;
    procedure addxpoint();

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
  func:=TStringList.Create;
  func.add('');
  func.add('');
end;

procedure TForm1.btnExecClick(Sender: TObject);
var
  i: integer;
  temp: Real;
  Lagrange: TLagrange;
begin
  x_list:=TStringList.Create;
  y_list:=TStringList.Create;
  with stgPoints do begin
    mintemp:=StrToFloat(Cells[0,1]);
    maxtemp:=mintemp;
    for i:=1 to Rowcount-1 do begin
      if (Cells[0,i]='') then begin
      x_list.add('0')
      end
      else x_list.Add(Cells[0,i]);
      if (StrToFloat(Cells[0,i])<mintemp) then mintemp:=StrToFloat(Cells[0,i]);
      if (StrToFloat(Cells[0,i])>maxtemp) then maxtemp:=StrToFloat(Cells[0,i]);
      if (Cells[1,i]='') then y_list.add('0')
      else y_list.Add(Cells[1,i]);
    end;
  end;
  Lagrange:=TLagrange.Create;
  stgLagrange.Cells[1,0]:=Lagrange.polinomio(x_list,y_list,StrToFloat(ediValue.Text));

end;

procedure TForm1.btnGraph1Click(Sender: TObject);
begin
  minval1:=mintemp;
  maxval1:=maxtemp;
  Chart1FuncSeries1.Active:=false;
  Func[0]:=stgLagrange.Cells[1,0];
  Chart1FuncSeries1.Active:=true;
  Memo1.Append('p_1(x)='+func[0]);

end;

procedure TForm1.btnGraph2Click(Sender: TObject);
begin
  minval2:=mintemp;
  maxval2:=maxtemp;
  Chart1FuncSeries2.Active:=false;
  Func[1]:=stgLagrange.Cells[1,0];
  Chart1FuncSeries2.Active:=true;
  Memo1.Append('p_2(x)='+func[1]);
end;

procedure TForm1.btnIntersecClick(Sender: TObject);
var
  minint, maxint,temporal: Real;
  closed: TCerrados;
  i: integer;
  temp,points: TStringList;
  funcion: String;
begin
  funcion:=Concat(func[0],'-(',func[1],')');
  closed:=TCerrados.create();
  temp:=TStringList.Create;
  points:=TStringList.Create;
  xpoint:=TStringList.Create;
  if (minval2>minval1)then minint:=minval1
  else minint:= minval2;
  if (maxval2<maxval1) then maxint:=maxval1
  else maxint:=maxval2;
  Memo1.append('Intervalo: ['+FloatToStr(minint)+' , '+FloatTostr(maxint)+']');
  repeat
  points:=TStringList.Create;
  points:=closed.biseccion(minint,minint+1,0.000001,temp,temp,funcion);
  if(points[points.Count-1]<>'Xn') then begin
  xpoint.Add(points[points.Count-1]);
  end;
  points.Destroy;
  minint:=minint+0.5;
  until minint+0.5>maxint;
  addxpoint();

end;

procedure TForm1.addxpoint();
var
  parse: TParseMath;
  i: integer;
  temp: real;
  cad: string;
begin
  Chart1LineSeries1.ShowLines:=false;
  Chart1LineSeries1.ShowPoints:=true;
  parse:=TParseMath.create();
  parse.AddVariable('x',0);
  parse.Expression:=func[0];
  for i:=0 to xpoint.Count-1 do begin
    cad:='';
    parse.NewValue('x',StrToFloat(xpoint[i]));
    temp:=parse.Evaluate();
    cad:=Concat('     (',xpoint[i],',',FloatToStr(temp),')');
    Memo1.Append(cad);
    Chart1LineSeries1.AddXY(StrToFloat(xpoint[i]),temp);
  end;

end;

procedure TForm1.Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
var
  parse: TParseMath;
begin
  parse:=TParseMath.create();
  parse.Expression:=func[0];
  parse.AddVariable('x',AX);
  AY:=parse.Evaluate();
end;

procedure TForm1.Chart1FuncSeries2Calculate(const AX: Double; out AY: Double);
var
  parse: TParseMath;
begin
  parse:=TParseMath.create();
  parse.Expression:=func[1];
  parse.AddVariable('x',AX);
  AY:=parse.Evaluate();
end;

procedure TForm1.btnEvalClick(Sender: TObject);
var
  funct: String;
  value,temp: double;
begin
  value:=StrToFloat(ediValue.text);
  stgLagrange.cells[0,1]:='p('+FloatToStr(value)+')=';
  funct:=stgLagrange.Cells[1,0];
  pmath:=TParseMath.create();
  pmath.Expression:=funct;
  pmath.AddVariable('x',value);
  temp:=pmath.Evaluate();
  stgLagrange.Cells[1,1]:=FloatToStr(temp);
  pmath.destroy;
end;

end.

