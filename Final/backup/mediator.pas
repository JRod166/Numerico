unit Mediator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Grids,variants,Dialogs,math,ParseMathCompleto,matrices,grafico,lagrange{,sisEcuDifOr};

type
  matrix_str=array of array of string;
type
  TMediator = class
    public
      MatrixVar:TStringGrid;
      grafica:TFrame1;
      constructor create(matrixVA:TStringGrid);
      procedure addVariable(Input:String);

      function execute(Input: String): string;
      function matrixoperation(Input: String): String;

    private
      Parse:TParseMath;
      function MatrixOut(Input:string): t_matrix;
      function MatrixIn(vari:string):t_matrix;

  end;

implementation

constructor TMediator.create(MatrixVA: TStringGrid);
begin
  Parse:=TParseMath.create();
  MatrixVar:=matrixVA;
  MatrixVar.RowCount:=1;
  MatrixVar.ColCount:=3;
  MatrixVar.Cells[0,0]:='Nombre';
  MatrixVar.Cells[1,0]:='Valor';
  MatrixVar.Cells[2,0]:='Tipo';
end;

function num(valor:string):boolean;
var
   numero:Real;
begin
  result:=TryStrToFloat(valor,numero);
end;

procedure TMediator.addVariable(Input: String);
var
   posIgual,PosVar,i,j:Integer;
   vari,valor:String;
   matrix_A:t_matrix;
   const NewVar= -1;
begin
  posIgual:=pos('=',Input);
  if (Input[posIgual+1]='[') then begin
     vari:=Copy(Input,1,posIgual-1);
     valor:=Copy(Input,posIgual+1,Length(Input)-posIgual);
     PosVar:=-1;
     for i:=1 to MatrixVar.RowCount-1 do begin
      if vari=MatrixVar.cells[0,i] then
         PosVar:=i;
    end;
      with MatrixVar do begin
       case PosVar of
            NewVar: begin
             RowCount:=RowCount+1;
             Cells[0,RowCount-1]:=vari;
             Cells[1,RowCount-1]:=valor;
             Cells[2,RowCount-1]:='matriz';
            end
            else begin
             Cells[1,PosVar]:=valor;
             Cells[2,PosVar]:='matriz';

      end;
     end;
  end;
  end
  else if(Pos('interpolacion',Input)=posIgual+1) then begin
     vari:=Copy(Input,1,posIgual-1);
     valor:=Copy(Input,posIgual+1,Length(Input)-posIgual);
     valor:=execute(valor);
     PosVar:=-1;
     for i:=1 to MatrixVar.RowCount-1 do begin
      if vari=MatrixVar.cells[0,i] then
         PosVar:=i;
    end;
      with MatrixVar do begin
       case PosVar of
            NewVar: begin
             RowCount:=RowCount+1;
             Cells[0,RowCount-1]:=vari;
             Cells[1,RowCount-1]:=valor;
             Cells[2,RowCount-1]:='funcion';
            end
            else begin
             Cells[1,PosVar]:=valor;
             Cells[2,PosVar]:='funcion';
      end;
     end;
  end;
  end
  else begin
    vari:=Copy(Input,1,posIgual-1);
    valor:=Copy(Input,posIgual+1,Length(Input)-posIgual);
    PosVar:=-1;
    for i:=1 to MatrixVar.RowCount-1 do begin
      if vari=MatrixVar.cells[0,i] then
         PosVar:=i;
    end;
    with MatrixVar do begin
      case PosVar of
           NewVar: begin
             RowCount:=RowCount+1;
             Cells[0,RowCount-1]:=vari;
             Cells[1,RowCount-1]:=Valor;
             if num(valor) then begin
               Cells[2,RowCount-1]:='Real';
               Parse.AddVariable(vari,StrToFloat(valor));
             end
             else begin
               cells[2,RowCount-1]:='Funcion';
               Parse.AddString(vari,valor);
             end;
             end
           else begin
             Cells[0,PosVar]:=vari;
             Cells[1,PosVar]:=valor;
             if Cells[2,PosVar]='Real' then begin
               Parse.NewValue(vari,StrToFloat(valor));
               end
             end;
             end;
      end;
      end;
end;

function variables(Input: String): TStringList;
var
   vari:string;
   posParentesisI,posSeparador,posParentesisF: Integer;
   const
     ParentesisI='(';
     ParentesisF=')';
     separador=',';
begin
  Result:=TStringList.Create;
  Result.Clear;
  posParentesisI:=pos(parentesisI,Input);
  posParentesisF:=pos(ParentesisF,Input);
  posSeparador:=pos(separador,Input);
  vari:=Copy(Input,posParentesisI+1,posSeparador-posParentesisI-1);
  Result.Add(vari);
  vari:=Copy(Input,posSeparador+1,posParentesisF-posSeparador-1);
  Result.Add(vari);
end;

function TMediator.MatrixIn(vari:string):t_matrix;
var
   posvar,i: integer;
begin
     posvar:=-1;
     for i:=1 to matrixVar.RowCount-1 do begin
       if vari=MatrixVar.Cells[0,i] then posvar:=i;
     end;
     if posvar<>-1 then Result:=MatrixOut(MatrixVar.Cells[1,posvar])
     else
     ShowMessage('No se reconoce la matriz ingresada')
end;

function TMediator.MatrixOut(Input:String):t_Matrix;
var
  PosCorcheteI,PosCorcheteF,posSeparadorF,posSeparadorC:Integer;
  columstr:string;
  auxInput,tmp,strColum:string;
  listaFi,valores:TStringList;
  colummnas,row,i,j,col,x:Integer;

const
   CorcheteI = '[';
   CorcheteF = ']';
   SeparadorFilas = ';';
   SeparadorColumnas=',';
begin
   PosCorcheteI:=pos(CorcheteI,Input);
   PosCorcheteF:=pos(CorcheteF,Input);
   valores:=TStringList.Create;
   if (PosCorcheteI=0)or (PosCorcheteF=0) then begin
      ShowMessage('Matriz mal declarada');end
   else begin
          posSeparadorF:=pos(SeparadorFilas,Input);
          if posSeparadorF<>0 then begin
             valores.Clear;
             auxInput:=Copy(Input,PosCorcheteI+1,Length(Input)-PosCorcheteI-1);//aqui
             posSeparadorF:=pos(SeparadorFilas,auxInput);
             listaFi:=TStringList.Create;
             while posSeparadorF<>0 do  begin
                 tmp:=Copy(auxInput,1,posSeparadorF-1);
                 listaFi.Add(tmp);
                 auxInput:=Copy(auxInput,posSeparadorF+1,Length(auxInput)-posSeparadorF);
                 posSeparadorF:=pos(SeparadorFilas,auxInput);
             end;
            listaFi.Add(auxInput);
            row:=listaFi.Count;
            for i:=0 to listaFi.Count-1 do begin
                strColum:=listaFi[i];
                col:=0;
                posSeparadorC:=pos(SeparadorColumnas,strColum);
                while posSeparadorC<>0 do begin
                      tmp:=Copy(strColum,1,posSeparadorC-1);
                      valores.Add(tmp);
                      strColum:=Copy(strColum,posSeparadorC+1,Length(strColum)-posSeparadorC);
                      posSeparadorC:=pos(SeparadorColumnas,strColum);
                      col:=col+1;
                end;
                valores.Add(strColum);
            end;
            x:=0;
            SetLength(Result,row,col+1);
            for i:=0 to row-1 do begin
                 for j:=0 to col do begin
                       Result[i][j]:=strToFloat(valores[x]);
                       x:=x+1;
                    end;
               end;
          end
         else begin
           strColum:=Copy(Input,PosCorcheteI+1,Length(Input)-PosCorcheteI-1);
           valores.Clear;
           col:=0;
           row:=1;
           posSeparadorC:=pos(SeparadorColumnas,strColum);
                while posSeparadorC<>0 do begin
                      tmp:=Copy(strColum,1,posSeparadorC-1);
                      valores.Add(tmp);
                      strColum:=Copy(strColum,posSeparadorC+1,Length(strColum)-posSeparadorC);
                      posSeparadorC:=pos(SeparadorColumnas,strColum);
                      col:=col+1;
                end;
                valores.Add(strColum);
            x:=0;
            SetLength(Result,row,col);
            for i:=0 to row-1 do begin
                 for j:=0 to col do begin
                       Result[i][j]:=strToFloat(valores[x]);
                       x:=x+1;
                    end;
               end;
          end;
        end;
end;

function TMediator.matrixoperation(Input:string):string;
var
  tmp:string;
  OperMat,OperMatB: TMatrices;
  resul, AMatrix, BMatrix:t_matrix;
  listvari:TStringList;
  row,col,i,j,px,py,sm,sp,potencia,posvari: integer;
  escalar: Real;
begin
  if Pos('suma',Input)>0 then begin
    listvari:=variables(Input);
    AMatrix:=matrixIn(listvari[0]);
    BMatrix:=MatrixIn(listvari[1]);
    row:=Length(AMatrix);
    col:=Length(AMatrix[0]);
    OperMat:=TMatrices.Create(row,col);
    OperMatB:=TMatrices.Create(row,col);
    OperMat.A:=AMatrix;
    OperMatB.A:=BMatrix;
    OperMat:=OperMat.Suma(OperMatB);
    resul:=OperMat.A;
    tmp:='[';
            for i:=0 to row-1 do begin
                 for j:=0 to col-2 do begin
                     tmp:=tmp+FloatToStr(resul[i][j])+',';
                 end;
                 tmp:=tmp+FloatToStr(resul[i][j+1])+';';
            end;
             tmp:=copy(tmp,0,length(tmp)-1);
             tmp:=tmp+']';
            Result:='     '+tmp;
  end
  else if Pos('resta',Input)>0 then begin
    listvari:=variables(Input);
    AMatrix:=matrixIn(listvari[0]);
    BMatrix:=MatrixIn(listvari[1]);
    row:=Length(AMatrix);
    col:=Length(AMatrix[0]);
    OperMat:=TMatrices.Create(row,col);
    OperMatB:=TMatrices.Create(row,col);
    OperMat.A:=AMatrix;
    OperMatB.A:=BMatrix;
    OperMat:=OperMat.Resta(OperMatB);
    resul:=OperMat.A;
    tmp:='[';
            for i:=0 to row-1 do begin
                 for j:=0 to col-2 do begin
                     tmp:=tmp+FloatToStr(resul[i][j])+',';
                 end;
                 tmp:=tmp+FloatToStr(resul[i][j+1])+';';
            end;
             tmp:=copy(tmp,0,length(tmp)-1);
             tmp:=tmp+']';
            Result:='     '+tmp;

  end
  else if Pos('mult',Input)>0 then begin
    listvari:=variables(Input);
    AMatrix:=matrixIn(listvari[0]);
    BMatrix:=MatrixIn(listvari[1]);
    row:=Length(AMatrix);
    col:=Length(AMatrix[0]);
    OperMat:=TMatrices.Create(row,col);
    row:=Length(BMatrix);
    if col <> row then showMessage('Tamaños incorrectos')
    else begin
    col:=Length(BMatrix[0]);
    OperMatB:=TMatrices.Create(row,col);
    OperMat.A:=AMatrix;
    OperMatB.A:=BMatrix;
    OperMat:=OperMAt.Multiplicacion(OperMatB);
    resul:=OperMat.A;
    row:=Length(AMatrix);
    tmp:='[';
            for i:=0 to row-1 do begin
                 for j:=0 to col-2 do begin
                     tmp:=tmp+FloatToStr(resul[i][j])+',';
                 end;
                 tmp:=tmp+FloatToStr(resul[i][j+1])+';';
            end;
             tmp:=copy(tmp,0,length(tmp)-1);
             tmp:=tmp+']';
            Result:='     '+tmp;
            end;
  end
  else if Pos('powerMatrix',Input)>0 then begin
    listvari:=variables(Input);
    AMatrix:=matrixIn(listvari[0]);
    posvari:=-1;
    for i:=0 to matrixVar.RowCount-1 do begin
                    if listVARI[1]=matrixVar.Cells[0,i] then
                         posVari:=i
                end;
                if posVari=-1 then
                     potencia:=StrToInt(listVARI[1])
                else
                     potencia:=StrToInt(matrixVar.Cells[1,posVari]);
    row:=Length(AMatrix);
    col:=Length(AMatrix[0]);
    OperMat:=TMatrices.Create(row,col);
    OperMat.A:=AMatrix;
    OperMat:=OperMat.Potencia(OperMat,potencia);
    resul:=OperMat.A;
    tmp:='[';
            for i:=0 to row-1 do begin
                 for j:=0 to col-2 do begin
                     tmp:=tmp+FloatToStr(resul[i][j])+',';
                 end;
                 tmp:=tmp+FloatToStr(resul[i][j+1])+';';
            end;
             tmp:=copy(tmp,0,length(tmp)-1);
             tmp:=tmp+']';
            Result:='     '+tmp;

    end
  else if Pos('mulEscalar',Input)>0 then begin
     listvari:=variables(Input);
    AMatrix:=matrixIn(listvari[0]);
    posvari:=-1;
    for i:=0 to matrixVar.RowCount-1 do begin
                    if listVARI[1]=matrixVar.Cells[0,i] then
                         posVari:=i
                end;
                if posVari=-1 then
                     escalar:=StrToInt(listVARI[1])
                else
                     escalar:=StrToInt(matrixVar.Cells[1,posVari]);
    row:=Length(AMatrix);
    col:=Length(AMatrix[0]);
    OperMat:=TMatrices.Create(row,col);
    OperMat.A:=AMatrix;
    OperMat:=OperMat.MultEscalar(escalar);
    resul:=OperMat.A;
    tmp:='[';
            for i:=0 to row-1 do begin
                 for j:=0 to col-2 do begin
                     tmp:=tmp+FloatToStr(resul[i][j])+',';
                 end;
                 tmp:=tmp+FloatToStr(resul[i][j+1])+';';
            end;
             tmp:=copy(tmp,0,length(tmp)-1);
             tmp:=tmp+']';
            Result:='     '+tmp;

    end


end;

function validpos(Input:String): Boolean;
var
   posicionValida: Boolean;
   posicion: Integer;
begin
  if Pos('plot',Input)>0 then begin
        posicion:=Pos('plot',Input);
        posicionValida:=(posicion>0) and (posicion<2);
     end
     else if Pos('puntoPlot',Input)>0 then begin
        posicion:=Pos('plot',Input);
        posicionValida:=(posicion>0) and (posicion<2);
     end
     else if Pos('intersection',Input)>0 then begin
        posicion:=Pos('intersection',Input);
        posicionValida:=(posicion>0) and (posicion<2);
     end
     else if Pos('interpolacion',Input)>0 then begin
        posicion:=Pos('interpolacion',Input);
        posicionValida:=(posicion>0) and (posicion<2);
     end
     else if Pos('edo',Input)>0 then begin
        posicion:=Pos('edo',Input);
        posicionValida:=(posicion>0) and (posicion<2);
     end
     else if Pos('sedo',Input)>0 then begin
       posicion:=Pos('sedo',Input);
       posicionValida:=(posicion>0) and (posicion<2);
     end
     else
         posicionValida:=False;

   Result:=posicionValida;
end;

function TMediator.execute(Input:String): String;
var
    tmp,aux,f:String;
    OperMa:TMatrices;
    lagra:TLagrange;
    resul,priMatrix,seconMatrox:t_matrix;
    listVARI:TStringList;
    xlist,ylist:TStringList;
    row,coll,i,j:Integer;
    valor:Real;

begin
 if ((Pos('suma',Input)>0) or (Pos('resta',Input)>0)) or (Pos('mult',Input)>0)or (Pos('powerMatrix',Input)>0)or (Pos('mulEscalar',Input)>0) then begin
    Result:=matrixoperation(Input);
   end
 else if (Pos('interpolacion',Input)>0) then begin
    lagra:=TLagrange.Create;
    xlist:=TStringList.Create;
    ylist:=TStringList.Create;
    tmp:=copy(Input,Pos('(',Input)+1,Length(Input)-Pos('(',Input)-1);
    while(Pos(',',tmp)<>0)  do begin
        aux:=copy(tmp,0,Pos(',',tmp)-1);
        xlist.Add(aux);
        //ShowMessage('xlist added: '+aux);
        tmp:=copy(tmp,Pos(',',tmp)+1,Length(tmp)-Pos(',',tmp));
        if(Pos(',',tmp)=0) then aux:=tmp
        else aux:=copy(tmp,0,Pos(',',tmp)-1);
        tmp:=copy(tmp,Pos(',',tmp)+1,Length(tmp)-Pos(',',tmp));
        ylist.Add(aux);
        //ShowMessage('ylist added: '+aux);
    end;
    if((xlist.Count<>ylist.Count)or (tmp<>aux)) then begin
       ShowMessage('Ingresar pares ordenados (cant de variables par)');
       result:='Error de entrada';
       exit;
    end ;
    Parse.setGrafica(grafica) ;
    f:=lagra.polinomio(xlist,ylist);
    //showmessage('plot('''+f+''','+xlist[0]+','+xlist[xlist.Count-1]+')');
    execute('plot('''+f+''','+xlist[0]+','+xlist[xlist.Count-1]+')' );
    Result:=f;
 end
 else begin
   listVARI:=TStringList.Create;
   i:=Pos('(',Input);
   tmp:=Copy(Input,i+1,Length(Input)-1-i);
   tmp:=tmp+',fin';
   f:=copy(Input,0,i);
   while(Pos(',',tmp)<>0) do begin
     aux:=Copy(tmp,0,Pos(',',tmp)-1);
     tmp:=Copy(tmp,Pos(',',tmp)+1,Length(tmp)-Pos(',',tmp));
     j:=-1;
     for i:=1 to matrixVar.RowCount-1 do begin
       if aux=MatrixVar.Cells[0,i] then j:=i;
     end;
     if j<>-1 then listVARI.Add(MatrixVar.Cells[1,j])
     else listVARI.Add(aux);
   end;
   for i:=0 to listVARI.Count-2 do begin
     f:=f+listVARI[i]+',';
   end;
   f:=f+listVARI[listVARI.Count-1]+')'  ;
   Input:=f;
   Parse.Expression:=Input;
   if validpos(Input) then begin
      Parse.setGrafica(grafica);
      Result:=Parse.EvaluateString();
   end
   else begin
     Parse.setGrafica(grafica);
     valor:=Parse.Evaluate();
     Result:=FloatToStr(valor);
   end;
 end;
end;

end.

