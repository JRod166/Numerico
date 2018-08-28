unit ParseMathCompleto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Variants, math, fpexprpars,Dialogs,grafico,Interseccion,Cerrados,mOpenMethod,Integral,EDO;
type
  t_matrix= array of array of real;
type
  TParseMath = Class

  Private
      FParser: TFPExpressionParser;
      TFrameGraph:TFrame1;
      identifier: array of TFPExprIdentifierDef;
      h:Real;
      Procedure AddFunctions();
      Procedure ExprEvaluarFuncion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprPlot( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprPlot2( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprInterseccion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprMetodoCerrado( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprRoot( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprIntegral( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprArea( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
      Procedure ExprEcuacioneDiferencialOrdinaria( var Result: TFPExpressionResult; Const Args: TExprParameterArray);



  Public

      Expression: string;
      function NewValue( Variable:string; Value: Double ): Double;
      procedure AddVariable( Variable: string; Value: Double );
      procedure AddString( Variable: string; Value: string );
      procedure setGrafica(graph:TFrame1);
      function Evaluate(  ): Double;
      function EvaluateString(): string;
      constructor create();
      destructor destroy;


  end;

implementation



constructor TParseMath.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();
   h:=0.0001;

end;

destructor TParseMath.destroy;
begin
    FParser.Destroy;
end;
procedure TParseMath.setGrafica(graph:TFrame1);
begin
    TFrameGraph:=graph;
end;

function TParseMath.NewValue( Variable: string; Value: Double ): Double;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;
end;
function TParseMath.Evaluate(): Double;
var
  auxr:Variant;
begin
     FParser.Expression:= Expression;
     Result:=ArgToFloat(FParser.Evaluate);
end;
function TParseMath.EvaluateString(): string;
begin
     FParser.Expression:= Expression;
     Result:=FParser.Evaluate.ResString;
end;
function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;
procedure ExprFloor(var Result: TFPExpressionResult; Const Args: TExprParameterArray); // maximo entero
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   if x > 0 then
     Result.ResFloat:= trunc( x )

   else
     Result.ResFloat:= trunc( x ) - 1;

end;
Procedure ExprTan( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x - 0.5) / pi) <> 0.0) then
      Result.resFloat := tan(x)

   else
     Result.resFloat := NaN;
end;
{
Procedure ExprNewton( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  f: string;
  TheNewton: TNewton;
begin
   f:= Args[ 0 ].ResString;
   x:= ArgToFloat( Args[ 1 ] );

   TheNewton:= TNewton.Create;
   TheNewton.InitialPoint:= x;
   TheNewton.Expression:= f;
   Result.ResFloat := TheNewton.Execute;

   TheNewton.Destroy;

end;
}
Procedure ExprSin( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := sin(x)

end;
Procedure ExprCos( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := cos(x)

end;
Procedure ExprLn( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x)

   else
     Result.resFloat := NaN;

end;
Procedure ExprLog( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x) / ln(10)

   else
     Result.resFloat := NaN;

end;
Procedure ExprSQRT( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := sqrt(x)

   else
     Result.resFloat := NaN;

end;
Procedure ExprPower( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,y: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
    y := ArgToFloat( Args[ 1 ] );

     Result.resFloat := power(x,y);

end;
//MetodosCerrados
//MetodosAbiertos
Procedure TParseMath.ExprEvaluarFuncion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  funtion:string;
  x,rpt:Real;
  parse:TParseMath;

begin
   funtion:=Args[0].ResString; //funcion;
   x:=ArgToFloat(Args[1]);
   try
   parse:=TParseMath.create();
   parse.Expression:=funtion;//del mismo parse
   parse.AddVariable('x',x);
   parse.NewValue('x',x);
   rpt:=parse.Evaluate();
   {if IsNan(rpt) then begin
       rpt:=-1;
   end;}
   Result.ResFloat:=rpt;
   except
     ShowMessage('al parecer no existe la funcion en este punto');
     Result.ResFloat:=-1;
   end;
   //Result.ResFloat:=rpt;
end;
Procedure TParseMath.ExprPlot( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  funtion:string;
  min,max:Real;
  listFuntion:TStringList;

begin
   funtion:=Args[0].ResString;
   listFuntion:=TStringList.Create;
   listFuntion.Add(funtion);
   min:=ArgToFloat(Args[1]);
   max:=ArgToFloat(Args[2]);
   TFrameGraph.GraficarFunciones(listFuntion,min,max,h);
   Result.ResString:='   se grafico correctamente ';

end;
function evaluaten(f:string;x:real):real;
var
   parse:TParseMath;
begin
   try
   parse:=TParseMath.create();
   parse.Expression:=f;//del mismo parse
   parse.AddVariable('x',x);
   parse.NewValue('x',x);
   Result:=parse.Evaluate();
   except
     ShowMessage('al parecer falla en evaluacion de parse ');
     Result:=-1;
   end;
end;
Procedure TParseMath.ExprPlot2( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  funtion:string;
  min,max,newX,newY:Real;
  listXn,listYn:TStringList;
  pares:t_matrix;
  i,j:Integer;

begin
   h:=0.1;
   funtion:=Args[0].ResString;
   listXn:=TStringList.Create;listYn:=TStringList.Create;

   //listFuntion.Add(funtion);
   min:=ArgToFloat(Args[1]);
   max:=ArgToFloat(Args[2]);
   newX:=min;
   while newX<=max do begin
         listXn.Add(FloatToStr(newX));
         newY:=evaluaten(funtion,newX);
         listYn.Add(FloatToStr(newY));
         newX:=newX+h;
   end;
   SetLength(pares,listXn.Count,2);
   for i:=0 to listXn.Count-1 do begin
        pares[i][0]:=StrToFloat(listXn[i]);
        pares[i][1]:=StrToFloat(listYn[i]);
   end;
   TFrameGraph.showPoints(pares);
   {while min<=max do begin

   end; }
   Result.ResString:='   se grafico correctamente ';

end;
Procedure TParseMath.ExprInterseccion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  funtion1,funtion2,rpt:string;
  min,max:Real;
  listFuntion:TStringList;
  IntersecciondeFuntion:TInterseccion;
  puntos:t_matrix;
  i,row:Integer;

begin
   funtion1:=Args[0].ResString;
   funtion2:=Args[1].ResString;
   min:=ArgToFloat(Args[2]);
   max:=ArgToFloat(Args[3]);
   listFuntion:=TStringList.Create;IntersecciondeFuntion:=TInterseccion.create();
   listFuntion.Add(funtion1); listFuntion.Add(funtion2);
   TFrameGraph.GraficarFunciones(listFuntion,min,max,h);
   puntos:=IntersecciondeFuntion.executeInnterseccion(funtion1,funtion2,min,max,h);
   TFrameGraph.showPoints(puntos);
   row:=Length(puntos);
   if row<>0 then begin
        rpt:='      ';
        for i:=0 to row-1 do begin
              rpt:=rpt+'('+FloatToStr(round(puntos[i][0]*100)/100)+','+FloatToStr(Round(puntos[i][1]*100)/100)+');  ';
        end;
   end
   else
       rpt:='     No hay interseccion';

   Result.ResString:=rpt;

end;
Procedure TParseMath.ExprMetodoCerrado( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,e:Real;
  f,metodo,rpt:string;
  MetodoCerrado:TCerrados;
  //extra
  listFuntion,alist,blist,rlist:TStringList;
  raiz:t_matrix;
begin
   //variables
   f:= Args[0].ResString; //funcion
   a:=ArgToFloat( Args[ 1 ] );// Args(Args[1]); //valor inicial
   b:=ArgToFloat( Args[ 2 ] );
   e:=ArgToFloat( Args[ 3 ] );// StrToFloat(Args[2]);//error
   metodo:=Args[4].ResString;
   MetodoCerrado:=TCerrados.create();

   listFuntion:=TStringList.Create;
   listFuntion.add(f);
   alist:=TStringList.Create;
   blist:=TStringList.Create;
   TFrameGraph.GraficarFunciones(listFuntion,a-3,b+3,h);
   case metodo of
        'biseccion':rlist:=MetodoCerrado.biseccion(a,b,e,alist,blist,f);
        'fp':rlist:=MetodoCerrado.falsaposicion(a,b,e,alist,blist,f);
        else begin
             rlist:=MetodoCerrado.falsaposicion(a,b,e,alist,blist,f);
        end;
   end;
   rpt:=rlist[rlist.Count-1];
   if rpt='-1' then  begin
      rpt:='-1';
   end
   else begin
        SetLength(raiz,1,2);
        raiz[0][0]:=StrToFloat(rpt);raiz[0][1]:=0;
        TFrameGraph.showPoints(raiz);
   end;
   Result.ResFloat:=StrToFloat(rpt);

end;
Procedure TParseMath.ExprRoot( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,e:Real;
  f,metodo:string;
  MethodOpen:TOpenMethod;
  listFuntion:TStringList;
  rpt:Real;
  raiz:t_matrix;
begin

   f:= Args[0].ResString; //funcion
   x:=ArgToFloat( Args[ 1 ] );// Args(Args[1]); //valor inicial
   e:=ArgToFloat( Args[ 2 ] );// StrToFloat(Args[2]);//error
   metodo:=Args[3].ResString;


   MethodOpen:=TOpenMethod.Create
   ;listFuntion:=TStringList.Create;
   listFuntion.Add(f);
   TFrameGraph.GraficarFunciones(listFuntion,x-5,x+5,h);
   case metodo of
        'newton':rpt:= StrToFloat(MethodOpen.newton(x,f,e));
        'secante':rpt:= StrToFloat(MethodOpen.secante(x,f,e));
        else begin
             rpt:= StrToFloat(MethodOpen.secante(x,f,e));
        end;
   end;
   SetLength(raiz,1,2);
   raiz[0][0]:=rpt;raiz[0][1]:=0;
   TFrameGraph.showPoints(raiz);
   Result.resFloat :=rpt;
end;
Procedure TParseMath.ExprIntegral( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,n:Real;
  f,metodo:string;
  Integral:TIntegral;
  listFu:TStringList;
  xIn,yFin:Real;
begin
   f:=Args[0].ResString; //funcion
   a:=ArgToFloat( Args[ 1 ] ); //desde inicial
   b:=ArgToFloat( Args[ 2 ] );//hasta final
   n:=ArgToFloat( Args[ 3 ]);//cuantas iteraciones
   metodo:=Args[4].ResString;//nombre del metodo

   Integral:=TIntegral.create(f,a,b,n); listFu:=TStringList.Create; listFu.Add(f);
   if a<b then begin
      xIn:=a ;yFin:=b;
       TFrameGraph.GraficarFunciones(listFu,xIn-0.5,yFin+1,h);
       TFrameGraph.GraficarArea(f,'0',a,b,h);
   end
   else begin
       xIn:=b; yFin:=a;
        TFrameGraph.GraficarFunciones(listFu,xIn-0.5,yFin+1,h);
        TFrameGraph.GraficarArea(f,'0',b,a,h);

   end;
   case metodo  of
        'trapecio':Result.ResFloat:=Integral.TrapecioEvaluateIntegral();
        'simpson13':Result.ResFloat:=Integral.Simpson13Evaluate();
        'simpson38':Result.ResFloat:=Integral.Simpson38CompuestoEvaluate();
        'primitiva':Result.ResFloat:=Integral.Primitiva();
        else begin
             Result.ResFloat:=Integral.Simpson13Evaluate();
        end;

   end;
end;
Procedure TParseMath.ExprArea( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  min,max:Real;
  f1,f2,fun,metodo:string;
  Integral:TIntegral;
  listFu:TStringList;
  xIn,yFin,a,b,rpt:Real;
  puntos:t_matrix;
  row,i:Integer;
  intersecfunci:TInterseccion;
begin
   f1:=Args[0].ResString; //funcion
   f2:=Args[1].ResString;
   min:=ArgToFloat( Args[ 2 ] );
   max:=ArgToFloat( Args[ 3 ] );
  // metodo:=Args[4].ResString;//nombre del metodo
   //ShowMessage('f1->'+f1+'  f2->'+f2);
   intersecfunci:=TInterseccion.create();
   puntos:=intersecfunci.executeInnterseccion(f1,f2,min,max,h);listFu:=TStringList.Create;listFu.Add(f1);
   row:=Length(puntos);
  // ShowMessage('row:->'+IntToStr(row));
  TFrameGraph.showPoints(puntos);
   if row>=2 then begin
      a:=puntos[0][0];
      b:=puntos[row-1][0];
      fun:=f1+'-('+f2+')';
      Integral:=TIntegral.create(fun,a,b,10);
      //Result.ResFloat:=Integral.SimpsonEvaluateArea();
      //listFu.Add(f2);
      TFrameGraph.GraficarFunciones(listFu,min,max,h);
     TFrameGraph.GraficarArea(f1,f2,a,b,h);
      //ShowMessage('rpt->'+ FloatToStr(Integral.SimpsonEvaluateArea()));
       rpt:=Integral.SimpsonEvaluateArea();

   end
   else  begin
      listFu.Add(f2);
      TFrameGraph.GraficarFunciones(listFu,min,max,h);
      rpt:=0;
   end;
   Result.ResFloat:=rpt;
end;
Procedure ExprNewton( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,e:Real;
  f:string;
  MethodOpen:TOpenMethod;
begin
   MethodOpen:=TOpenMethod.Create;
   f:= Args[0].ResString; //funcion
   x:=ArgToFloat( Args[ 1 ] );// Args(Args[1]); //valor inicial
   e:=ArgToFloat( Args[ 2 ] );// StrToFloat(Args[2]);//error
   Result.resFloat :=StrToFloat(MethodOpen.newton(x,f,e))
   //MethodOpen.Destroy;
end;
Procedure ExprSecante( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,e:Real;
  f:string;
  MethodOpen1:TOpenMethod;
begin
   MethodOpen1:=TOpenMethod.Create;
   f:=Args[0].ResString; //funcion
   x:=ArgToFloat( Args[ 1 ] ); //valor inicial
   e:=ArgToFloat( Args[ 2 ] );//error

   Result.resFloat := StrToFloat(MethodOpen1.Secante(x,f,e));
  // MethodOpen.Destroy;
end;
Procedure ExprTrapecio( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,n:Real;
  f:string;
  Integral:TIntegral;
begin
   f:=Args[0].ResString; //funcion
   a:=ArgToFloat( Args[ 1 ] ); //valor inicial
   b:=ArgToFloat( Args[ 2 ] );//error
   n:=ArgToFloat( Args[ 3 ]);
   Integral:=TIntegral.create(f,a,b,n);
   Result.resFloat := Integral.TrapecioEvaluateIntegral();
   //MethodOpen.Destroy;
end;
Procedure ExprSimpson13( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,n:Real;
  f:string;
  Integral:TIntegral;
begin
   f:=Args[0].ResString; //funcion
   a:=ArgToFloat( Args[ 1 ] ); //valor inicial
   b:=ArgToFloat( Args[ 2 ] );//error
   n:=ArgToFloat( Args[ 3 ]);
   Integral:=TIntegral.create(f,a,b,n);
   Result.resFloat := Integral.Simpson13Evaluate();
   //MethodOpen.Destroy;
end;
Procedure ExprSimpson38( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,n:Real;
  f:string;
  Integral:TIntegral;
begin
   f:=Args[0].ResString; //funcion
   a:=ArgToFloat( Args[ 1 ] ); //valor inicial
   b:=ArgToFloat( Args[ 2 ] );//error
   n:=ArgToFloat( Args[ 3 ]);
   Integral:=TIntegral.create(f,a,b,n);
   Result.resFloat := Integral.Simpson38CompuestoEvaluate();
   //MethodOpen.Destroy;
end;

Procedure TParseMath.ExprEcuacioneDiferencialOrdinaria( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  xo,xf,yo:Real;
  f,metodo,Rpt:string;
  edo:TEDO;
  n:Integer;
  listX,listY:TStringList;
begin
   f:=Args[0].ResString; // derivada funcion
   xo:=ArgToFloat( Args[ 1 ] ); //valor inicial
   xf:=ArgToFloat( Args[ 2 ] );//valor final
   yo:=ArgToFloat( Args[ 3 ]); //yo inicial
    n:=Args[ 4 ].ResInteger;//iteraciones
    metodo:=Args[5].ResString;//metodo
   edo:=TEDO.create(f,xo,xf,yo,n);
    if metodo='euler' then
       Rpt:=edo.Euler()
    else if metodo='heun' then
       Rpt:=edo.Heun()
    else if metodo='rungekutta4' then
       Rpt:=edo.RungeKutta4()
    else if metodo='dormandPrince' then
       Rpt:=edo.DormandPrince()
    else begin
        Rpt:=edo.RungeKutta4();end;
    TFrameGraph.ConstruirFuntion(Rpt);
    listX:=TFrameGraph.lisX;listY:=TFrameGraph.lisY;
    Result.ResString :=Rpt;

end;
function LecturaArchivo_Puntos(archivo_a_leer:String):t_matrix;
var
  LineasArchivo: TStringList;
  unaLinea: String;
  i: Integer;
  //para obtener intervalo
  PosSeparador: Integer;
  X_,Y_:String;
  matrixDatos:t_matrix;
const
   Separador = ',';
begin
  // Fase 1: Cargar Archivo En contendor
  LineasArchivo:= TStringList.Create();
  LineasArchivo.loadFromFile(archivo_a_leer);

  // Fase 2: Procesar archivo
  SetLength(matrixDatos,LineasArchivo.Count,2);//setear la cantidad de datos
 // cantidad:=LineasArchivo.Count;
  for i:= 0 to LineasArchivo.Count - 1 do
  begin
    unaLinea:=LineasArchivo[i];
    PosSeparador:=Pos(Separador,unaLinea);// el que separa valores ;
    X_:=Copy(unaLinea,1,PosSeparador-1);
    Y_:=copy(unaLinea,PosSeparador+1,Length(unaLinea)-PosSeparador);
    if StrToFloat(X_)=0 then begin
       X_:='0.001';
    end;
    if StrToFloat(Y_)=0 then begin
       Y_:='0.001';
    end;
    matrixDatos[i][0]:=StrToFloat(X_);matrixDatos[i][1]:=StrToFloat(Y_);
   // ShowMessage(unaLinea);//Hacer_Algo_Con_Cada_Linea(unaLinea);
  end;
  // Fase 3: Guardar Archivo
  LineasArchivo.SaveToFile(archivo_a_leer);

  // Fase 4: Como somos limpios, limpiamos antes de salir
  LineasArchivo.Free;
  Result:=matrixDatos;

end;

Procedure TParseMath.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('tan', 'F', 'F', @ExprTan);
       AddFunction('sin', 'F', 'F', @ExprSin);
       AddFunction('sen', 'F', 'F', @ExprSin);
       AddFunction('cos', 'F', 'F', @ExprCos);
       AddFunction('ln', 'F', 'F', @ExprLn);
       AddFunction('log', 'F', 'F', @ExprLog);
       AddFunction('sqrt', 'F', 'F', @ExprSQRT);
       AddFunction('floor', 'F', 'F', @ExprFloor );
       AddFunction('power', 'F', 'FF', @ExprPower); //two float arguments 'FF' , returns float

       AddFunction('evaluarfuncion', 'F' ,'SF',@ExprEvaluarFuncion);
       AddFunction('plot', 'S' ,'SFF',@ExprPlot);
       AddFunction('puntoPlot', 'S' ,'SFF',@ExprPlot2);
       AddFunction('intersection', 'S' ,'SSFF',@ExprInterseccion);
       //metodos cerrados
       //metodos Abiertos
       //  Comand.Lines.Add('Root("funtion",Xo,error,"newton")--->Metodos Abiertos');
       AddFunction('rootC', 'F','SFFFS', @ExprMetodoCerrado); //aqui le cambie************************************
       AddFunction('rootA', 'F','SFFS', @ExprRoot);
       //esta dentro de rootA y estA NO GRAFICA
       AddFunction('newton', 'F','SFF', @ExprNewton); //two float arguments 'FF' , returns float
       AddFunction('secante','F','SFF', @ExprSecante); //two float arguments 'FF' , returns float
       AddFunction('integrar', 'F', 'SFFFS', @ExprIntegral);
       AddFunction('area', 'F', 'SSFF', @ExprArea);
       //integrales  ----> esta dentro de integrar
       AddFunction('trapecio', 'F', 'SFFF', @ExprTrapecio);
       AddFunction('simpson13', 'F', 'SFFF', @ExprSimpson13);
       AddFunction('simpson38', 'F', 'SFFF', @ExprSimpson38);
       //EDo
       AddFunction('edo', 'S', 'SFFFFS', @ExprEcuacioneDiferencialOrdinaria);
       //AddFunction('rungekutta4', 'S', 'SFFFF', @ExprRungeKutta4);
      // AddFunction('power', 'F', 'FF', @ExprPower); //two float arguments 'FF' , returns float
       //AddFunction('Newton', 'F', 'SF', @ExprNewton ); // Una sring argunmen and one float argument, returns float

   end

end;

procedure TParseMath.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);

end;

procedure TParseMath.AddString( Variable: string; Value: string );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;

   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
end;

end.
