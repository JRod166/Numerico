unit Jacobiana;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,Matrices,ArrStr,ArrReal,Dialogs;

type TJacobiana = Class
  public
    fx_List: TArrString;
    var_List: TArrString;
    val_List: TArrReal;
    filas,columnas: Integer;
    constructor create();
    Function evaluate(fx_ListI,var_ListI: TArrString; val_ListI: TArrReal; fil,col: Integer): TMatrices;
    Function derivadaparcial(fun:TParseMath; x:string;valor:Real):Real;
    end;

implementation

constructor TJacobiana.create();
begin
  fx_List:=TArrString.create();
  var_List:=TArrString.create();
  val_List:=TArrReal.create();
end;

function TJacobiana.evaluate(fx_ListI, var_ListI : TArrString;  val_ListI : TArrReal; fil, col: Integer) :TMatrices;
var
   m_function:TParseMath;
   aux_mat:TMatrices;
   i,j: integer;
begin     //fil = cant de funciones //col = cant de variables
  filas:=fil; columnas:=col;
  fx_list:=fx_ListI;
  var_list:=var_ListI;
  val_list:=val_ListI;

  m_function:=TParseMath.create();

  for i:=0 to columnas-1 do
      m_function.AddVariable(var_List.get(i),val_List.get(i));
  aux_mat:=TMatrices.create(filas,columnas);
  for i:=0 to filas-1 do begin
      m_function.Expression:=fx_List.get(i);
      for j:=0 to columnas-1 do
          aux_mat.A[i,j]:= derivadaParcial(m_function,var_List.get(j),val_List.get(j));
      end;
  Evaluate:= aux_mat;
  end;

Function TJacobiana.derivadaparcial(fun:TParseMath;x:string;valor:Real): Real;
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

