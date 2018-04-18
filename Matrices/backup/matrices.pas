unit Matrices;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  m_Matriz = array of array of real;

type
  TMatrices = class
    public
      A: m_matriz;
      constructor Create(n,m: Integer);
      procedure setMatriz();
      procedure printMatriz();

      Function Suma(B: TMatrices) : TMatrices;
      Function Resta(B: TMatrices) : TMatrices;
      Function Multiplicacion( B: TMatrices) : TMatrices;
      Function Division(B: TMatrices) : TMatrices;
      Function MultEscalar(n:Real): TMatrices;
      Function Potencia(B:TMatrices;pot: Integer):TMatrices;
      Function Inversa(B:TMatrices):TMatrices;
      Function Transpuesta (): TMatrices;
      Function Determinante(B: TMatrices): Real;
      Function SubMatriz(B:TMatrices;i,j:Integer):TMatrices;
      Function Adjunta (B:TMatrices): TMatrices;
      procedure Identidad();
  end;

implementation

constructor TMatrices.Create(n,m: Integer);
begin
  SetLength(A,n,m);
end;

Function TMatrices.Suma(B:TMatrices): TMatrices;
var
  i,j,fil,col: integer;
  res: TMatrices;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  res:=TMatrices.create(fil,col);
  for i:=0 to fil-1 do
      for j:=0 to col-1 do
          res.A[i,j]:=A[i,j]+B.A[i,j];
  Result:= res;
end;
Function TMatrices.Resta(B:TMatrices): TMatrices;
var
  i,j,fil,col: integer;
  res: TMatrices;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  res:=TMatrices.create(fil,col);
  for i:=0 to fil-1 do
      for j:=0 to col-1 do
          res.A[i,j]:=A[i,j]-B.A[i,j];
  Result:= res;
end;

Function TMatrices.Multiplicacion(B:TMatrices):TMatrices;
var
  fila,cola,colb,i,j,k: integer;
  res: TMatrices;
  temporal: Real;
begin
  fila := Length(A);
  cola:= Length(B.A);
  colb:= Length(B.A[0]);
  res:=Tmatrices.create(fila,colb);
  for i:= 0 to fila-1 do //i para las filas de la matriz resultante
      for k := 0 to colb-1 do begin// k para las columnas de la matriz resultante
          temporal := 0 ;
          for j := 0 to cola-1  do begin//j para realizar la multiplicacion de los elementos de la matriz
            temporal := temporal + A[i][j] * B.A[j][k];
            res.A[i][k] := temporal ;
          end;
      end;
  Result:=res;
end;

function TMatrices.Division(B: TMatrices) : TMatrices     ;
var
  fil,col:Integer;
  res,aux: TMatrices;
begin
  fil:=Length(B.A);
  col:=Length(B.A[0]);
  aux.Create(fil,col);
  fil:=Length(A);
  res.create(fil,col);
  writeln('entro');
  Aux:=B.Inversa(B);
  writeln('inversa');
  aux.printmatriz();
  B.printmatriz();
  aux.printmatriz();
  res:=B.Multiplicacion(aux);
  result:=res;
end;

Function TMatrices.MultEscalar(n:Real):TMatrices;
var
  i,j,fil,col: Integer;
  res: TMatrices;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  res:=TMatrices.Create(fil,col);
  for i:=0 to fil-1 do
      for j:=0 to col-1 do
          begin
          res.A[i,j]:=A[i,j]*n;
          end;
  Result:=res;
end;

Function TMatrices.Potencia(B: TMatrices;pot:Integer):TMatrices;
var
  fil,col,i: Integer;
  C: TMatrices;
begin
  fil:=Length(B.A);
  col:=Length(B.A[0]);
  i:=1;
  C:=TMatrices.create(fil,col);
  C.A:=B.A;
  if pot=0 then identidad()
  else begin
  while(i<pot) do
    begin
        C:=C.Multiplicacion(B);
        i:=i+1;
    end;
  B.A:=C.A;
  end;
  Result:=B;
end;

Function TMatrices.Inversa(B:TMatrices): TMatrices;
var
  fil,col: Integer;
  det: Real;
  adj,res: TMatrices;
begin
  fil:=Length(B.A);
  col:=Length(B.A[0]);
  if (fil<>col) then exit;
  adj:=TMatrices.create(fil,col);
  res:=TMatrices.create(fil,col);
  adj:=Adjunta(B);
  det:=Determinante(B);
  if det=0 then begin
     writeln('Matriz no invertible, determinante = 0');
     result:=res;
     exit;
     end;
  adj:=adj.Transpuesta();
  det:=1/det;
  res:=adj.MultEscalar(det);
  Result:=res;
  end;

Function TMatrices.Transpuesta():TMatrices;
var
  i,j,fil,col:integer;
  res: TMatrices;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  res:=TMatrices.create(col,fil);
  for i:=0 to fil -1 do
      for j:=0 to col -1 do
          res.A[j,i]:=A[i,j];
  result:=res;
end;

Function TMatrices.Determinante(B:TMatrices):Real;
var
  s,k,ma,na:integer ;
begin
    result:=0.0;
    ma:=Length(B.A);
    if ma>1 then na:=Length(B.A[0])
    else
        begin
          result:=B.A[0,0];
          exit;
        end;
    if not (ma=na)then exit;

    if(ma=2) then result:=B.A[0,0]*B.A[1,1]-B.A[0,1]*B.A[1,0]
    else if ma=3 then
         result:=B.A[0,0]*B.A[1,1]*B.A[2,2]+B.A[2,0]*B.A[0,1]*B.A[1,2]+B.A[1,0]*B.A[2,1]*B.A[0,2]-
                 B.A[2,0]*B.A[1,1]*B.A[0,2]-B.A[1,0]*B.A[0,1]*B.A[2,2]-B.A[0,0]*B.A[2,1]*B.A[1,2]
    else
    begin
         s:=1;
         for k:=0 to na-1 do
         begin
              result:=result+s*B.A[0,k]*Determinante(Submatriz(B,0,k));
              s:=s*-1;
         end;
    end;
end;

Function TMatrices.SubMatriz(B:TMatrices;i:Integer;j:Integer):TMatrices;
var
  w,x,y,z,fil,col:Integer;
  res: TMatrices;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  res:=TMatrices.create(fil-1,col-1);
  w:=0;z:=0;
  for x:=0 to fil-1 do begin
        if (x<>i) then begin
           for y:=0 to col-1 do
               if (y<>j) then begin
                  res.A[w,z]:=A[x,y];
                  z:=z+1;
               end;
           w:=w+1;
           z:=0;
        end;
  end;
  Result:=res;
end;

Function TMatrices.Adjunta(B:TMatrices):TMatrices;
var
  i,j,s,s1,fil,col: integer;
  res, temp: TMatrices;
begin
  fil:=length(B.A);
  col:=length(B.A[0]);
  if(fil<>col) then exit;
  res:=TMatrices.create(fil,col);
  temp:=TMatrices.create(fil-1,col-1);
  s1:=1;
  for i:=0 to fil-1 do begin
      s:=s1;
      for j:=0 to col-1 do begin
          temp:=SubMatriz(B,i,j);
          res.A[i,j]:=s*Determinante(temp);
          s:=s*(-1);
      end;
      s1:=s1*(-1);
  end;
  Result:=res;
end;

procedure TMatrices.SetMatriz();
var
   m,n,i,j: Integer;
   numset: Real;
begin
  m:=Length(A);
  n:=Length(A[0]);
  for j:=0 to m-1 do begin
      for i:=0 to n-1 do begin
            Write('[',i,',',j,']: ');
            Read (numSet);
            A[j,i]:=numSet;
      end;
  end;
  WriteLn(' ');
end;

procedure TMatrices.printMatriz();
Var
  m,n,j,i:Integer;
begin
  m:=Length(A);
  n:=Length(A[0]);
  for j:=0 to m-1 do begin
      Write('[ ');
      for i:=0 to n-1 do begin
            Write(A[j,i]:0:2,' , ');
      end;
      WriteLn(' ]');
  end;
  WriteLn(' ');
end;


procedure TMatrices.Identidad();
var
  fil,col,i,j: Integer;
begin
  fil:=Length(A);
  col:=Length(A[0]);
  for i:=0 to fil-1 do
      for j:=0 to col-1 do begin
          if i=j then A[i,j]:=1
          else A[i,j]:=0;
      end;
end;

end.

