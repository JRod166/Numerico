unit Interseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Dialogs,math,ParseMath,MetodosC;
type
  t_matrix= array of array of real;
Type
TInterseccion=class
    public
       restaF:String;
       constructor create();
       function executeInnterseccion(f1,g1:string;min,max,h:real):t_matrix;
    private
       Parse:TParseMath;
       function Bolzano(ay,by:Double):Integer;
       function fB(x:Real):Real;
  end;
implementation
constructor TInterseccion.create();
begin
     parse:=TParseMath.create();
     Parse.AddVariable('x',0);
end;
function TInterseccion.fB(x:Real):Real;
begin
    Parse.Expression:=restaF;
    Parse.NewValue('x',x);
    Result:=Parse.Evaluate();
end;
function TInterseccion.Bolzano(ay,by:Double):Integer;
var
   test:double;
begin
  if (IsNan(fB(ay))or IsNan(fB(by))) then begin
      Result:=-1;
      exit;
  end;
  if ((fB(ay)=0) or (fB(by)=0)) then begin
      Result:=1;
      exit;
  end;

  test:=fB(ay)*fB(by);
  if test<=0 then begin
      Result:=1;
  end
  else
      Result:=-1;
end;
function TInterseccion.executeInnterseccion(f1,g1:string;min,max,h:real):t_matrix;
var
  valor:Real;
  intVA,intVB:Real;
  error:Real;
  //Puntos:TStringList;
  Puntos:Array[0..20] of Real;
  i,j,test,x:Integer;
  y:Real;
  Bisecccion:TMetodos;

begin
 restaF:=f1+'-('+g1+')';
 intVA:=min;
 intVB:=max;
 error:=0.0001;
 Bisecccion:=TMetodos.Create(restaF);
 i:=0;
    while intVA<=max+h do begin
         test:=Bolzano(intVA,intVA+h);
       { Bisecccion.a:=intVA;
        Bisecccion.b:=intVA+ht;
        try
        valor:=StrToFloat(Bisecccion.biseccion());
        Except
         valor:=-1;
        end; }
        if test<>-1 then begin
            valor:=StrToFloat(Bisecccion.biseccion(intVA,intVA+h,error));
           //ShowMessage(':'+floatTostr(valor));
           Puntos[i]:=valor;
          i:=i+1;
        end;
        intVA:=intVA+h;
    end;
  SetLength(Result,i,2);
  Parse.Expression:=f1;
  for j:=0 to i-1 do begin
      Parse.NewValue('x',Puntos[j]);
      Result[j][0]:=Puntos[j];
      Result[j][1]:=Parse.Evaluate();
  end;
 { for x:=0 to i-1 do  begin
      ShowMessage('x: ->'+FloatToStr(Result[x][0])+'   y:->'+FloatToStr(Result[x][1]));
  end; }

end;

end.

