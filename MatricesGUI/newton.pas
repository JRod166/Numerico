unit Newton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Matrices,Jacobiana,ArrReal,ArrStr,ParseMath,Dialogs;


Type
  TNewton = Class
    public
      constructor create();
      destructor Destroy; override;
      Function execute(fx_ListI, var_ListI : TArrString;  val_ListI : TArrReal; fil: Integer;Error: Real): TStringList;
      function distance(ValMatrix,Val2Matrix: TMatrices): Real;
end;


implementation

constructor TNewton.create;
begin

end;

destructor TNewton.Destroy;
begin

end;

Function TNewton.execute(fx_ListI, var_ListI : TArrString;  val_ListI : TArrReal; fil: Integer;Error: Real):TStringList;
var
  Jacobiana: TJacobiana;
  i,j: integer;
  erroractual,errorallowed:Real;
  ValMatrix,FuncMatrix,JacobMatrix,Val2Matrix: TMatrices;
  m_function: TParseMath;
  cadena: string;
  sequence:TStringList;
begin
  errorallowed:=error;
  Jacobiana:=TJacobiana.create();
  Sequence:=TStringList.Create;
  ValMatrix:=TMatrices.Create(fil,1);
  Val2Matrix:=TMatrices.Create(fil,1);
  FuncMatrix:=TMatrices.Create(fil,1);
  JacobMatrix:=TMatrices.Create(fil,fil);
  m_function:=TParseMath.create();
  for i:=0 to fil-1 do begin
      m_function.AddVariable(var_ListI.get(i),val_ListI.get(i));
      ValMatrix.A[i,0]:=val_listI.get(i);
  end;

  repeat
    for i:=0 to fil-1 do begin
      m_function.Expression:=fx_ListI.get(i);
      FuncMatrix.A[i,0]:=m_function.Evaluate();
    end;
    JacobMatrix:=Jacobiana.evaluate(fx_ListI,var_ListI,val_ListI,fil,fil);
    JacobMatrix:=JacobMatrix.Inversa(JacobMatrix);
    FuncMatrix:=JacobMatrix.Multiplicacion(FuncMatrix);
    Val2Matrix:=ValMatrix.Resta(FuncMatrix);
    cadena:=FloatToStr(Val2Matrix.A[0][0]);
    for i:=1 to fil-1 do
        cadena:=concat(cadena,',',FloatToStr(Val2Matrix.A[i][0]));
    Sequence.Add(cadena);
    cadena:='';
    ValMatrix:=Val2Matrix;
    erroractual:=distance(ValMatrix,Val2Matrix);
    for i:=0 to fil-1 do
        m_function.NewValue(var_ListI.get(i),ValMatrix.A[i][0]);
  until (erroractual<=errorallowed);
  Result:=Sequence;
end;

Function TNewton.distance(ValMatrix,Val2Matrix: TMatrices): Real;
var
   i: Integer;
   temp,temp2: Real;
begin
  temp2:=0;
  for i:=0 to Length(ValMatrix.A)-1 do begin
      temp:=Val2Matrix.A[0][i]-ValMatrix.A[0,i];
      temp:=temp*temp;
      temp2:=temp2+temp;
  end;
  Result:=sqr(temp2);
end;

end.

