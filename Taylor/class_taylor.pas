unit class_taylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TTaylor = class
    ErrorAllowed: Real;
    Sequence,
    FunctionList: TstringList;
    FunctionType: Integer;
    AngleType: Integer;
    x: Real;
    function Execute(): Real;
    private
      Error,
      Angle: Real;
      function sen(): Real;
      function cos(): Real;
      function exponencial(): Real;
      function senh(): Real;
      function cosh(): Real;
      function ln(): Real;
      function arcsen(): Real;
      function arctan(): Real;
      function arcsenh(): Real;
      function arctanh(): Real;
    public

      constructor create;
      destructor Destroy; override;

  end;

const
  IsSin = 0;
  IsCos = 1;
  IsExp = 2;
  IsSinh = 3;
  IsCosh = 4;
  IsLn = 5;
  IsArcSin = 6;
  IsArcTan = 7;
  IsArcSinh = 8;
  IsArcTanh = 9;

  AngleSexagedecimal = 0;
  AngleRadian = 1;

implementation

const
  Top = 100000;

constructor TTaylor.create;
begin
  Sequence:= TStringList.Create;
  FunctionList:= TStringList.Create;
  FunctionList.AddObject( 'sen', TObject( IsSin ) );
  FunctionList.AddObject( 'cos', TObject( IsCos ) );
  FunctionList.AddObject( 'exp', TObject( IsExp ) );
  FunctionList.AddObject( 'sinh', TObject( IsSinh ) );
  FunctionList.AddObject( 'cosh', TObject( IsCosh ) );
  FunctionList.AddObject( 'ln(x+1)', TObject( IsLn ) );
  FunctionList.AddObject( 'arcsin', TObject( IsArcSin ) );
  FunctionList.AddObject( 'arctan', TObject( IsArcTan ) );
  FunctionList.AddObject( 'arcsinh', TObject( IsArcSinh ) );
  FunctionList.AddObject( 'arctanh', TObject( IsArcTanh ) );
  Sequence.Add('0');
  Error:= Top;
  x:= 0;
end;

destructor TTaylor.Destroy;
begin
  Sequence.Destroy;
  FunctionList.Destroy;
end;

function Power( b: Double; n: Integer ): Double;
var i: Integer;
begin
//  ShowMessage(FloatToStr(b) + '^' + FloatToStr(n));
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function Factorial( n: Integer ): Double;
begin

     if n > 1 then
        Result:= n * Factorial( n -1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function Module(a: Real; b: Double): Real;
var x: Real;
    i: Real;
begin
   x:=a;
   i:=0;
   repeat
     x:=x-b;
     i:=i+1;
   until (x<0);
   i:=i-1;
   i:=i*b;
   Result := a-i;
end;

function TTaylor.Execute( ): Real;
begin

   case AngleType of
        AngleRadian: Angle:= x;
        AngleSexagedecimal: Angle:=x * pi/180;
   end;
   Angle := Module(Angle ,(2*pi));
   case FunctionType of
        IsSin: Result:= sen();
        IsCos: Result:= cos();
        IsExp: Result:= exponencial();
        IsSinh: Result:= senh();
        IsCosh: Result:= cosh();
        IsLn: Result := ln();
        IsArcSin: Result := ArcSen();
        IsArcTan: Result := ArcTan();
        IsArcSinh: Result := ArcSenh();
        IsArcTanh: Result := ArcTanh();
   end;
end;

function TTaylor.sen(): Real;
var xn: Real;
     n: Integer;
begin
   Result:= 0;
   n:= 0;

   repeat
     xn:= Result;

     Result:= Result + Power(-1, n)/Factorial( 2*n + 1 ) * Power(Angle, 2*n + 1);
     if n > 0 then
        Error:= abs( Result - xn );

     Sequence.Add( FloatToStr( Result ) );
     n:= n + 1;

   until ( Error <= ErrorAllowed ) or ( n >= Top ) ;

end;


function TTaylor.cos(): Real;
var xn: real;
    n: Integer;

begin
  Result:= 0;
  n:= 0;

  repeat
    xn:= Result;
    Result:= Result + Power( -1, n)/Factorial(2*n) * Power( Angle, 2*n );
    Sequence.Add( FloatToStr( Result ) );
    if n > 0 then
       Error:= abs( Result - xn );

    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

function TTaylor.exponencial(): Real;
var xn: Real;
    n: Integer;
begin
  n:= 0;
  Result:= 0;

  repeat
    xn:= Result;
    Result:= Result + (Power( x,n ) / Factorial(n));
    Sequence.Add( FloatToStr( Result ) );
    if n > 0 then
       Error:= abs( Result - xn );

    n:= n + 1;
  until (Error < ErrorAllowed ) or (n >= Top );

end;

function Ttaylor.senh(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + 1 / Factorial( 2*n + 1 ) * Power( angle , 2*n + 1 );
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);

end;

function Ttaylor.cosh(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + 1 / Factorial( 2*n ) * Power( angle , 2*n );
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);
end;

function Ttaylor.ln(): Real;
  var xn: Real;
    n: Integer;
begin
  n := 1;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + (Power( -1, n + 1) / n )* Power( x , n );
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);

end;

function Ttaylor.arcsen(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + Factorial( 2*n )/ ( Power( 4 , n)*Power( Factorial( n ) , 2)*(2*n + 1))*Power( angle, 2*n + 1);
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);
end;
function Ttaylor.arctan(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + Power( -1 , n ) / (2*n + 1) * Power (angle, 2*n + 1);
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);
end;

function Ttaylor.arcsenh(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + ((Factorial(2*n)*Power(-1,n)) / (Power(4,n)*Power(Factorial(n),2)*(2*n+1)) )* Power(angle,2*n+1);
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);
end;

function Ttaylor.arctanh(): Real;
var xn: Real;
    n: Integer;
begin
  n := 0;
  Result := 0;
  repeat
    xn := Result;
    Result := Result + 1 / (2*n+1) * Power( angle , 2*n + 1);
    Sequence.add( FloatToStr ( Result ) );
    if n > 0 then
       Error := abs( Result - xn);

    n := n + 1;
  until (Error < ErrorAllowed) or (n >= Top);
end;

end.

