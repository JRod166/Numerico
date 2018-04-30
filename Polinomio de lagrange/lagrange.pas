unit lagrange;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;

type
  TLagrange = class
  constructor Create;
  destructor Destroy; override;
  function lagrangeano (x,y: TStringList; posicion: integer): string;
  function polinomio (x,y:TStringList;valor:Real): string;

  end;

implementation

constructor TLagrange.Create;
begin

end;

destructor TLagrange.Destroy;
begin

end;

function TLagrange.polinomio(x,y:TStringList;valor:Real): string;
var
  i: integer;
  res: string;
  cad: TStringList;
begin
  res:='';
  cad:=TStringList.Create;
  if(x.Count<6) then begin
    for i:=0 to x.Count-1 do begin
      if(StrToFloat(y[i])=0) then
      else cad.add('(('+y[i]+')'+lagrangeano(x,y,i));
    end;
  end;
  for i:=0 to cad.count-1 do begin
    if (i=0) then res:=cad[i]
    else res:=res+'+'+cad[i];
  end;
  result:=res;
end;

function TLagrange.lagrangeano(x,y:TStringList;posicion:Integer): string;
var
  i: integer;
  temp,aux1,aux2: double;
  res: string;
  cad: TStringList;
begin
  temp:=1;
  aux1:=StrToFloat(x[posicion]);
  cad:=TStringList.Create;
  for i:=0 to x.count-1 do begin
    if (i<>posicion) then begin
      cad.add('(x-('+x[i]+'))');
      aux2:=StrToFloat(x[i]);
      temp:=temp*(aux1-aux2);
    end;
  end;
  res:='/('+FloatTostr(temp)+'))';
  for i:=0 to cad.count-1 do begin
    res:=res+'*'+cad[i];
  end;
  result:=res;
end;

end.

