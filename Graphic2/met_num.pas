unit met_num;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, Dialogs;

type
  MetodosNumericos = class
    a, b: Real;
    xo:real;
    ErrorAllowed: Real;
    minimumsList, maximumsList, metodosList,sequence : TstringList;
    numericMethod : Integer;
    function execute() : Real;
    function f(x: Real) : Real;

    function derif(x: Real) : Real;

    function Bolzano(x1:Real; x2:Real): Boolean;
    private
      error: Real;
      function newton(): Real;
      function newtonSecante(): Real;
      function puntoFijo():Real;
    public
          constructor create;
          destructor Destroy; override;


  end;

  const
    isNewton = 0;
    NaN = 0.0/0.0;
    isNewtonSecante = 1;
    isPuntoFijo = 2;
implementation

const
  Top = 100000;



  constructor MetodosNumericos.create;
  begin
       minimumsList:= TStringList.create;
       maximumsList:= TStringList.create;
       metodosList:= TStringList.create;
       sequence:= TStringList.create;
       sequence.Add('Xn');
       minimumsList.Add('a');
       maximumsList.Add('b');
       metodosList.AddObject('Newton', TObject(isNewton));
       metodosList.AddObject('Newton Secante', TObject(isNewtonSecante));
       metodosList.AddObject('Punto Fijo', TObject(isPuntoFijo));
       error:= Top;
  end;

destructor MetodosNumericos.Destroy;
begin
  minimumsList.Destroy;
  maximumsList.Destroy;
  metodosList.Destroy;
end;

function MetodosNumericos.execute() : Real;
begin
  case numericMethod of
       isNewton: Result:= newton();
       isNewtonSecante: Result:= newtonSecante();
       isPuntoFijo : Result:= puntoFijo();
  end;

end;

function metodosNumericos.f(x: Real): Real;
begin
  Result:=(2*power(x,3))-(2*power(x,2));
  //Result:=(1/x);
  //Result:=x*sin(power(x,3));

  //Result:= (exp(-x)-x );
  //Result:= 2*power(x,3)+2;

  //Result:=  power(x,3)-power(x,2)-(4*x)-4
  //Result:= (power(x,3)-(3*x)-4);
  //Result:= (power(x,2)-(x));
  //Result:= power(x,2);
  //Result:= (power(x,3)-(3*x));
end;

function metodosNumericos.derif(x: Real): Real;
begin
  Result :=(6*power(x,2))- (2*x)
  //Result:=(-1/(power(x,2)));
  //Result:=sin(power(x,3))+ (3*power(x,3)*cos(power(x,3)));

  //Result:= (exp(-x) );
  //Result:= 6*power(x,2);

  //Result:=  power(x,3)-power(x,2)-(4*x)-4
  //Result:= (power(x,3)-(3*x)-4);
  //Result:= (power(x,2)-(x));
  //Result:= power(x,2);
  //Result:= (power(x,3)-(3*x));
end;

function MetodosNumericos.Bolzano(x1:Real; x2:Real): Boolean;
begin
   if f(x1) * f(x2) < 0 then
      Result:= true
   else
     Result:=False;
end;

function MetodosNumericos.newton(): Real;
var xn, h,df,fxo,fxoh,e,e1,x0: Real;
    n: Integer;
begin
  h:=ErrorAllowed/10;
  e:=1;
  e1:=0;
  x0:=xo;

      Result:= 0;
      n:=0;

      sequence.Add(FloatToStr(x0));
      repeat

        df:=derif(x0);
        if df = 0  then
           begin
             ShowMessage('dicivion entre 0');
             exit;
           end;

        fxo:=f(x0);
        fxoh:=f(x0+h);

        df:=(fxoh-fxo)/h;

        xn:=Result;
        Result:= x0-(fxo/df);
        e:=abs(Result-x0);
        sequence.Add(FloatToStr(Result));

        if n > 0 then
           error:= abs(Result - xn);

         //ShowMessage(FloatToStr(error));

          if (n<>0) and (n mod 3=0) then
         begin
         e1:=e;
         end;
          if (e1<>0) and (e1<e) then
          begin
         ShowMessage('La funcion Diverge');
         exit;
         end;



         x0:=Result;
         n:=n+1;

        //ShowMessage(FloatToStr(result));

      until (Error < ErrorAllowed) or (n>=Top);




end;

function MetodosNumericos.newtonSecante(): Real;
var xn, h,df,fxo,fxoh,e,e1,x0,fxomh: Real;
    n: Integer;
begin
  h:=ErrorAllowed/10;
  e:=1;
  e1:=0;
  x0:=xo;

      Result:= 0;
      n:=0;

      sequence.Add(FloatToStr(x0));
      repeat

        df:=derif(x0);
        if df = 0  then
           begin
             ShowMessage('dicivion entre 0');
             exit;
           end;

        fxo:=f(x0);
        fxoh:=f(x0+h);
        fxomh:=f(x0-h);

        df:=(fxoh-fxo)/h;

        xn:=Result;
        Result:= x0-(2*h*fxo/(fxoh-fxomh));
        e:=abs(Result-x0);
        sequence.Add(FloatToStr(Result));

        if n > 0 then
           error:= abs(Result - xn);

         //ShowMessage(FloatToStr(error));

          if (n<>0) and (n mod 3=0) then
         begin
         e1:=e;
         end;
          if (e1<>0) and (e1<e) then
          begin
         ShowMessage('La funcion Diverge');
         exit;
         end;



         x0:=Result;
         n:=n+1;

        //ShowMessage(FloatToStr(result));

      until (Error < ErrorAllowed) or (n>=Top);



end;

function MetodosNumericos.puntoFijo(): Real;
var xn, h,df,fxo,fxoh,x0: Real;
    n: Integer;
begin
  h:=ErrorAllowed/10;
  x0:=xo;

      Result:= 0;
      n:=0;

      sequence.Add(FloatToStr(x0));


        fxo:=derif(x0);
        fxoh:=derif(x0+h);


        df:=(fxoh-fxo)/h;

        if (df < -1) or (df > 1) then
           begin
             ShowMessage('no cumple condicion de derivada');
             exit;
           end;

        if f(x0) = 0 then
           begin
             Result:=x0;
             exit;
           end;

        repeat

        xn:=Result;
        Result:= derif(x0);
        sequence.Add(FloatToStr(Result));

        if n > 0 then
           error:= abs(Result - xn);

         //ShowMessage(FloatToStr(xn)+' '+ FloatToStr(result));

         x0:=Result;
         n:=n+1;

        //ShowMessage(FloatToStr(result));

      until (Error < ErrorAllowed) or (n>=Top);



end;

end.
