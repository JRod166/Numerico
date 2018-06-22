unit grafico;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph,Graphics, TASeries, Forms, Controls,Dialogs,ParseMath,math,ColorBox;
//Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls;
type
  t_matrix= array of array of real;

type

  { TFrame1 }
  TFrame1 = class(TFrame)
    Chart1: TChart;
    AreaSeries: TAreaSeries;
    AreaResta: TAreaSeries;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    LineSeries: TLineSeries;
    MostrarPuntos: TLineSeries;
     lisX,lisY:TStringList;

   { constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;  }
    procedure GraficarFunciones(funciones:TStringList;min,max,h:Real);
    procedure GraficarArea(f1,f2:String;min,max,h:Real);
    //procedure graficar2d(min,max,h:Real);
    procedure showPoints(pair:t_matrix);
    procedure ConstruirFuncion(pares:t_matrix);
    procedure ConstruirFuntion(Input:string);
  //TFrameGrafico = class(TFrame)
  private
    { private declarations }
    Parse:TParseMath;
    cadena:String;
    FunctionList:TList;
    ActiveFunction: Integer;
    funtion:TStringList;
   // lisX,lisY:TStringList;

    procedure crearLineSeries();
    function f( x: Real ): Real;
    procedure graficar2d(min,max,h:Real);

  public
    { public declarations }
  end;

implementation
const
  FunctionSeriesName = 'FunctionLines';

{$R *.lfm}

{ TFrame1 }




{constructor TFrame1.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  MostrarPuntos:=TLineSeries.Create(TheOwner);
  //MyObj := TObject.Create;
end;

destructor TFrame1.Destroy;
begin
  //MyObj.Free
  inherited Destroy;
end;}
procedure TFrame1.crearLineSeries();
begin
   //ShowMessage('cantFuntlist'+IntToStr(FunctionList.Count));

   FunctionList.Add(TLineSeries.Create(Chart1));
   with TLineSeries(FunctionList[FunctionList.Count-1]) do begin
      // Name:=FunctionSeriesName+IntToStr(FunctionList.Count);
       Tag:=FunctionList.Count-1;
   end;
   Chart1.AddSeries(TLineSeries(FunctionList[FunctionList.Count-1]));
end;
procedure TFrame1.GraficarFunciones(funciones:TStringList;min,max,h:Real);
var
  i:Integer;
begin
  //crear los TLineSeries en el tchart
  Parse:=TParseMath.create();
  Parse.AddVariable('x',0);
  FunctionList:= TList.Create;
  //funtion.Clear;
  funtion:=funciones;

   for i:=0 to funciones.Count-1 do begin
        ActiveFunction:=i;
        crearLineSeries();
        graficar2d(min,max,h);
   end;

end;
procedure TFrame1.GraficarArea(f1,f2:String;min,max,h:Real);
var
  i:Integer;
  newX,y1,y2:real;
  listF:TStringList;

begin
  AreaSeries.Clear; AreaResta.Clear;LineSeries.Clear;

  Parse:=TParseMath.create();
  Parse.AddVariable('x',0);
  newX:=min;
  //ShowMessage('f1:->'+f1+'f2:->'+f2);
  while newX<max do begin
       Parse.Expression:=f1;
       Parse.NewValue('x',newX);
       y1:=Parse.Evaluate();

      //ShowMessage('y1:'+FloatToStr(y1));
       Parse.Expression:=f2;
       Parse.NewValue('x',newX);
       y2:=Parse.Evaluate();
     // ShowMessage('y2:'+FloatToStr(y2));

       if y2>=y1 then begin
          AreaSeries.AddXY(newX,y2);
          //AreaSeries.AddXY(newX,y1,'',clDefault);
          //AreaSeries.AddY(y1,'',clDefault);
           AreaResta.AddXY(newX,y1);
          //ShowMessage('x:'+FloatToStr(newX)+'y:'+FloatToStr(y1))
       end
       else begin
            AreaSeries.AddXY(newX,y1);
            //AreaSeries.AddXY(newX,y2,'',clDefault);
            //AreaSeries.AddY(y2,'',clDefault);
            AreaResta.AddXY(newX,y2);
       end;
       newX:=newX+h;
  end;
  newX:=min;
  max:=max;
  while newX<max do begin
       Parse.Expression:=f2;
       Parse.NewValue('x',newX);
       y1:=Parse.Evaluate();
       LineSeries.AddXY(newX,y1);
       newX:=newX+h;
  end;
  AreaSeries.Active:=True;AreaResta.Active:=True;

end;
function TFrame1.f( x: Real ): Real;
var rpt:Real;
begin
  //func:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.Expression:= funtion[ActiveFunction];
  Parse.NewValue('x', x);
  rpt:= Parse.Evaluate();
  if IsNan(rpt) then
     rpt:=0.01;
  Result:=rpt;

end;
procedure TFrame1.graficar2d(min,max,h:Real);
var
  x,y:Real;
begin
  with TLineSeries( FunctionList[ ActiveFunction ] ) do begin
       Clear;
       LinePen.Color:=clRed;
       LinePen.Width:= 2;

  end;

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
       TLineSeries( FunctionList[ ActiveFunction ] ).ShowLines:=True;
       AddXY( x, f(x) );
       x:= x + h
  until ( x>= max+h);
 { Parse:=TParseMath.create();
  Parse.Expression:=funcion;
  Parse.AddVariable('x',0);

   with LineSeries do begin
       //LinePen.Color:=clBlack
       LinePen.Width:=2;
  end;

  x:= min;
  LineSeries.Clear;
  with LineSeries do
  repeat
       LineSeries.ShowLines:=True;
       Parse.NewValue('x',x);
       y:=Parse.Evaluate();
       if not IsNan(y)  then
          AddXY(x,y);
       x:= x + h
  until (x>=max+h); }
end;
procedure TFrame1.showPoints(pair:t_matrix);
var
   col,row,i,j:Integer;
begin

  row:=Length(pair);
  if row<>0 then  begin
     col:=Length(pair[0]);
  end;
  with MostrarPuntos do begin
        CleanupInstance;
        ShowPoints:=True;
        LineType:=ltNone;
  end;
  for i:=0 to row-1 do begin
       MostrarPuntos.AddXY(pair[i][0],pair[i][1]);
  end;

end;
procedure TFrame1.ConstruirFuncion(pares:t_matrix);
var
  col,row,i,j:Integer;
begin
  with LineSeries do begin
       LineSeries.clear;
       MostrarPuntos.ShowPoints:=True;

  end;
  col:=Length(pares);
  row:=Length(pares[0]);
  for i:=0 to row-1 do begin
            LineSeries.AddXY(pares[i][0],pares[i][1]);
  end;
end;
procedure TFrame1.ConstruirFuntion(Input:string);
var
  i:Integer;
  listaX,listaY:TStringList;
  x,y:string;
  posCorcheteIni,PosCorcheteFin,posSeparador:Integer;
const
   CorcheteIni = '(';
   CorcheteFin = ')';
   Separador = ',';
begin
  LineSeries.Clear; listaX:=TStringList.Create;listaY:=TStringList.Create;
  listaX:=TStringList.Create;listaY:=TStringList.Create;
   with LineSeries do begin
       LineSeries.clear;
       LineSeries.LinePen.Width:=2;
       LineSeries.ShowLines:=True;
  end;
   with MostrarPuntos do begin
        MostrarPuntos.Clear;
        MostrarPuntos.ShowPoints:=True;
        MostrarPuntos.LineType:=ltNone;
  end;
 while Length(Input)>1 do begin
       posCorcheteIni:=Pos(CorcheteIni,Input);
       posSeparador:=pos(Separador,Input);
       PosCorcheteFin:=pos(CorcheteFin,Input);
       x:=Copy(Input,posCorcheteIni+1,PosSeparador-posCorcheteIni-1);
       y:=Copy(Input,posSeparador+1,PosCorcheteFin-posSeparador-1);
       LineSeries.AddXY(StrToFloat(x),StrToFloat(y));
       MostrarPuntos.AddXY(StrToFloat(x),StrToFloat(y));
       listaX.Add(x);listaY.Add(y);
       //ShowMessage('x->'+x+'y->'+y);
       Input:=Copy(Input,PosCorcheteFin+1,Length(Input)-PosCorcheteFin);
  end;
end;


end.


