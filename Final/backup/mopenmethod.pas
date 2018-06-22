unit mOpenMethod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, mResult, parsemath,Dialogs;
type
  TOpenMethod = class
    private
      function getPresicion(error: Double): Integer;
      function getZerosStr(precision: integer): string;

    public
      function newton(x: Double; funExpression: string; e: double): string;
      function secante(x: Double; funExpression: string; e: double): string;
      function derivadaparcial(fun:TParseMath;x:string;valor:Real): Real;

  end;

implementation

function TOpenMethod.newton(x: Double; funExpression: string; e: double): String;
var
  fun, fund: TParseMath;
  xn,xn_1,eAbs, fxn, fdxn: Double;
  i: Integer;
  resMatrix: array of array of string;
  ePresicionStr: string;
begin
  fun:= TParseMath.create();
  //fund:= TParseMath.create();

  fun.Expression:=funExpression;
  //fund.Expression:=funDExpression;

  fun.AddVariable('x',0); //fun.Evaluate();
  //fund.AddVariable('x',0); fund.Evaluate();

  //digits:= ;
  ePresicionStr := getZerosStr(getPresicion(e));
  eAbs:= 10000000;
  xn_1:= x;
  i:=1;
  //fun.NewValue('x',xn_1); xn := fun.Evaluate();
  SetLength(resMatrix,i,3);
  resMatrix[0,0]:= IntToStr(i-1);
  resMatrix[0,1]:= FloatToStr(xn_1);
  resMatrix[0,2]:= '-';
  showmessage(FloatToStr(xn_1));

  while (e < eAbs) do
  begin
    i := i+1;
    //fund.NewValue('x',xn_1); fdxn := fund.Evaluate();
    fdxn:= derivadaparcial(fun,'x',xn_1);
    if (fdxn = 0) then
    begin // verificamos que la tangente sea != 0
      xn_1 := xn_1 - e ; // si lo es -> perturbamos xn_1 con el error
      //fund.NewValue('x',xn_1); fdxn := fund.Evaluate();
      fdxn:=derivadaparcial(fun,'x',xn_1);
    end;

    fun.NewValue('x',xn_1); fxn := fun.Evaluate();


    xn :=  xn_1 +(-1*(fxn /fdxn) );

    eAbs:= abs(xn- xn_1);
    //xn_1:= xn;

    //fill matrix
    SetLength(resMatrix,i,3);

    resMatrix[i-1,0]:= IntToStr(i-1);
    resMatrix[i-1,1]:= FloatToStr(xn_1);
    resMatrix[i-1,2]:= FloatToStr(eAbs);
    showmessage(FloatToStr(xn));


    xn_1:= xn;
  end;

  //Result.result:= FloatToStr(xn);
  //Result.result:= FormatFloat( ePresicionStr , xn);
  //Result.matrix:= resMatrix;
    Result:=FloatToSTr(xn_1);
end;

function TOpenMethod.secante(x: Double; funExpression: string; e: double): String;
var
  fun: TParseMath;
  xn,xn_1,eAbs, fxn, fxph, fxmh, h: Double;
  i: Integer;
  resMatrix: array of array of string;
  derivada:double;
begin
  fun:= TParseMath.create();
  //fund:= TParseMath.create();

  fun.Expression:=funExpression;
  //fund.Expression:=funDExpression;

  fun.AddVariable('x',0); //fun.Evaluate();
  //fund.AddVariable('x',0); fund.Evaluate();

  eAbs:= 10000000;
  h := e/2;
  xn_1:= x;
  i:=1;
  //fun.NewValue('x',xn_1); xn := fun.Evaluate();
  SetLength(resMatrix,i,3);
  resMatrix[0,0]:= IntToStr(i-1);
  resMatrix[0,1]:= FloatToStr(xn_1);
  resMatrix[0,2]:= '-';

  while (e < eAbs) do
  begin
    i := i+1;
    fun.NewValue('x',xn_1); fxn := fun.Evaluate();
    fun.NewValue('x',xn_1+h); fxph := fun.Evaluate();
    fun.NewValue('x',xn_1-h); fxmh := fun.Evaluate();

    derivada := (fxph-fxmh)/2*h;

    if (derivada=0) then
    begin // verificamos que la tangente sea != 0
      xn_1 := xn_1 - e ; // si lo es -> perturbamos xn_1 con el error
      fun.NewValue('x',xn_1); fxn := fun.Evaluate();
     fun.NewValue('x',xn_1+h); fxph := fun.Evaluate();
     fun.NewValue('x',xn_1-h); fxmh := fun.Evaluate();
    end;

    xn :=  xn_1 -( (2*h*fxn)/(fxph-fxmh) );

    eAbs:= abs(xn- xn_1);
    //xn_1:= xn;

    //fill matrix
    SetLength(resMatrix,i,3);

    resMatrix[i-1,0]:= IntToStr(i-1);
    resMatrix[i-1,1]:= FloatToStr(xn_1);
    resMatrix[i-1,2]:= FloatToStr(eAbs);
    //resMatrix[i-1,3]:= FloatToStr(xn_1);
    //resMatrix[i-1,4]:= FloatToStr(fxn/fdxn);

    xn_1:= xn;
  end;

  //Result.result:= FloatToStr(xn);
  //Result.matrix:= resMatrix;
  Result:=FloatToStr(xn_1);
end;

/////////////////////////
function TOpenMethod.getPresicion(error: Double): Integer;
var
  eString: string;
begin
     eString:= FloatToStr(error);
     //AnsiPos('.',eString);
     Result := AnsiPos('1',eString)-AnsiPos('.',eString)-1;
end;

//DupeString function needs srtutils library
function TOpenMethod.getZerosStr(precision: Integer): string;
begin
  Result := DupeString('0',precision);
  Result := '0.'+Result;
end;

Function TOpenMethod.derivadaparcial(fun:TParseMath;x:string;valor:Real): Real;
var
   h,a,b,v:Real;
   funaux: TParseMath;
begin
  h:=0.0000001;
  v:=valor;
  funaux:=fun;
  funaux.NewValue(x,v);
  b:=funaux.Evaluate();
  funaux.NewValue(x,v+h);
  a:=funaux.Evaluate();
  derivadaparcial:=(a-b)/h;
  result:=derivadaparcial;
end;


end.

