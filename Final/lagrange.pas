unit lagrange;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math,Dialogs;

type
  TLagrange = class
  constructor Create;
  destructor Destroy; override;
  function lagrangeano (x,y: TStringList; posicion: integer): string;
  function polinomio (x,y:TStringList): string;
  procedure selectsort(xlist,ylist:TStringList);

  end;

implementation

constructor TLagrange.Create;
begin

end;

destructor TLagrange.Destroy;
begin

end;

function TLagrange.polinomio(x,y:TStringList): string;
var
  i: integer;
  res: string;
  cad: TStringList;
begin
  res:='';
  selectsort(x,y);
//  ShowMessage(Inttostr(x.Count));
  cad:=TStringList.Create;
  //if(x.Count<6) then begin
    for i:=0 to x.Count-1 do begin
      {if(StrToFloat(y[i])=0) then
      else}cad.add('(('+y[i]+')'+lagrangeano(x,y,i));
//      ShowMessage(y[i]);
    end;
  //end;
  for i:=0 to cad.count-1 do begin
    if (i=0) then res:=cad[i]
    else res:=res+'+'+cad[i];
    //showmessage(res);
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
 // if (temp=0) then
  res:='/('+FloatTostr(temp)+'))';
  for i:=0 to cad.count-1 do begin
    res:=res+'*'+cad[i];
  end;
  result:=res;
end;

procedure TLagrange.selectsort(xlist,ylist:TStringList);
var
  xaux,yaux: TStringList;
  i,temp,j:Integer;
begin
  xaux:=TStringList.Create;
  yaux:=TStringList.Create;
  temp:=0;
  while xlist.Count > 0 do begin
    for i:=0 to xlist.count-1 do begin
      if(StrToFloat(xlist[i])<=StrToFloat(xlist[temp])) then   temp:=i;
    end;
    xaux.Add(xlist[temp]);
    yaux.Add(ylist[temp]);
    xlist.Delete(temp);
    ylist.Delete(temp);
    temp:=0;
  end;
  for j:=0 to xaux.Count-1 do begin
      xlist.add(xaux[j]);
      ylist.add(yaux[j]);
  end;
end;

end.

