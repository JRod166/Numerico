unit EDO;

{$mode objfpc}{$H+}

interface

uses
  ParseMath;
type
  t_matrix= array of array of real;
type
  TEDO=Class
    public
    funtion:String;
    x0,xf,y0:Real;
    n:Integer;
    matrizXY:t_matrix;

    function Euler():String;
    function  f(x,y:Real):Real;
    function Heun():String;
    function RungeKutta3():String;
    function RungeKutta4():String;
    function DormandPrince():String;
    constructor create(fun:String;a,b,y:Real;n_:Integer);
    destructor destroy;
    private
    Parse:TParseMath;

  end;
implementation
uses
  Classes, SysUtils,math,Dialogs;

constructor TEDO.create(fun:String;a,b,y:Real;n_:integer);
begin
  funtion:=fun;
  x0:=a;
  xf:=b;
  y0:=y;
  n:=n_;
 { matrizXY:=Tmatriz.Create;
  matrizXY.c:=2;
  matrizXY.f:=0;
  }
  Parse:=TParseMath.create();
  Parse.AddVariable('x',0);
  Parse.AddVariable('y',0);
  SetLength(matrizXY,n+1,2);
end;
function  TEDO.f(x,y:Real):Real;
begin
   Parse.Expression:=funtion;
   Parse.NewValue('x',x);
   Parse.NewValue('y',y);
   Result:=Parse.Evaluate();
end;
destructor TEDO.destroy;
begin
  Parse.destroy;
end;
function TEDO.Euler():String;
var
  m_function:TParseMath;
  res:String;
  h,y,x,aprox,pendiente:Double;
  i:Integer;

begin
  res:='';
   h:=abs(xf-x0)/n;
   //ShowMessage('h:'+ FloatToStr(h));
   x:=x0;
  // ShowMessage('x0:->'+ FloatToStr(x));
   y:=y0;
  // ShowMessage('yo:->'+ FloatToStr(y0));
   for i:=0 to n  do begin
       res:=res+'('+FloatToStr(x)+','+FloatToStr(RoundTo(y,-6))+')';
       matrizXY[i][0]:=x;matrizXY[i][1]:=y;
       y:=y+h*f(x,y);
       x:=x+h;
   end;
 Result :=res;
end;

function TEDO.Heun():String;
var
  m_function:TParseMath;
  res:String;
  yn1,h,y,x,aprox,pendiente:Double;
  i:Integer;

begin
 res:='';

 h:=(xf-x0)/n;
   x:=x0;
   y:=y0;
  // ShowMessage('yo:->'+ FloatToStr(y0));
   for i:=0 to n  do begin
       res:=res+'('+FloatToStr(x)+','+FloatToStr(RoundTo(y,-6))+');';
       matrizXY[i][0]:=x;matrizXY[i][1]:=y;
       pendiente:=f(x,y)+f(x+h,y+h*f(x,y));
       y:=y+(h*(pendiente/2));
       x:=x+h;
       {//yn1:=y0 +h*funcion2(x0,y0,f);
       res:=res+'['+FloatToStr(x0)+',';

       res:=res+FloatToStr(yn1)+'] ; ';
       matrizXY.matrix[i,0]:=x0;
       matrizXY.matrix[i,1]:=y0;
       matrizXY.f:=matrizXY.f+1;

       x:= x0 + h;
       y0:=yn1;
       x0:=x; }
   end;
 Result :=res;
end;

function TEDO.RungeKutta3():String;
var
  m_function:TParseMath;
  res:String;
  k1,k2,k3,k4,h,y,x,temp,pendiente:Double;

begin
  {
  res:='';


    h:=(xf-x0)/n;

   for i:=0 to n  do
   begin

   res:=res+'[ '+FloatToStr(x0)+' , ';

   res:=res+FloatToStr(y0)+' ] ; ';
   matrizXY.matrix[i,0]:=x0;
   matrizXY.matrix[i,1]:=y0;
   matrizXY.f:=matrizXY.f+1;


   x:= x0 + h;
   k1 := h * funcion2(x0, y0,f);
   k2 := h * funcion2(x0 + (h/2), y0 + (k1/2),f);
   k3 := h * funcion2(x0 + (h), y0 -k1+ (2*k2),f);

   pendiente := (k1 + 4*k2+ k3)/6;
   y := y0 + pendiente;

   x0:=x;
   y0:=y;

   end;


       }

  Result:=(res);
end;

function TEDO.RungeKutta4():String;
var
  res:String;
  k1,k2,k3,k4,h,y,x,pendiente:Double;
  i:Integer;
begin
  res:='';
  h:=(xf-x0)/(n);
  x:=x0;
  y:=y0;
  for i:=0 to n do begin
      res:=res+'('+FloatToStr(RoundTo(x,-6))+','+FloatToStr(RoundTo(y,-6))+');';
      k1:=h*f(x,y);
      k2:=h*f(x+(h/2),y+(k1/2));
      k3:=h*f(x+(h/2),y+(k2/2));
      k4:=h*f(x+h,y+k3);
      pendiente:=(k1+2*k2+2*k3+k4)/6;
      y:=y+pendiente;
      x:=x+h;
  end;
  Result:=res;
end;
function TEDO.DormandPrince():String;
var
  res:String;
  k1,k2,k3,k4,k5,k6,k7,Z_Y,h,y,x,ytmp,pendiente:Double;
  eps,s:Real;
  i:Integer;
begin
  res:='';
  h:=(xf-x0)/n;
  x:=x0;
  y:=y0;
  eps := 0.0001;
   i:=0;
  while (x<xf) do begin
      res:=res+'('+FloatToStr(RoundTo(x,-6))+','+FloatToStr(RoundTo(y,-6))+');';
      k1:=h*f(x,y);
      k2:=h*f(x+(h/5),y+(k1*(h/5)));
      k3:=h*f(x+(3*h/10),y+(3/40*k1)+(k2*9/40));
      k4:=h*f(x+(4/5*h),y+((44/45)*k1)-((56/15)*k2)+((32/9)*k3));
      k5:=h*f(x+((8/9)*h),y+((19372/6561)*k1)-((25360/2187)*k2)+((64448/6561)*k3)-((212/729)*k4));
      k6:=h*f(x+h,y+((9017/3168)*k1)-((355/33)*k2)-((46732/5247)*k3)+((49/176)*k4)-((5103/18656)*k5));
      k7:=h*f(x+h,y+((35/384)*k1)+((500/1113)*k3)+((125/192)*k4)-((2187/6784)*k5)+((11/84)*k6));
      pendiente:=35/384*k1+500/1113*k3+125/192*k4-2187/6784*k5+11/84*k6;
      Z_Y:=y +5179/57600*k1 +7571/16695*k3 +393/640*k4-92097/339200*k5 +187/2100*k6 +1/40*k7;
      y:=y+pendiente;
      x:=x+h;
      //x:=x+h;
      // para calcular s :
      s := power(h*eps/(2*(xf - x0)*abs(y- Z_Y)), 1/4);
      if s >= 2 then begin
         h := h * 2;
      end
      else  begin
         h := h / 2;
      end;

      if (x+h > xf) then
           h :=xf - x;
  end;
  Result:=res;
end;




end.

