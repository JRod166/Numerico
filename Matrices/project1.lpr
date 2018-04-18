program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,Crt,SysUtils,CustApp, Matrices, Jacobiana,ArrStr,ArrReal;
  { you can add units after this }

type
  {Matric}

  Matric = class(TCustomApplication)
    protected
      procedure DoRun;override;
    public
      MatricA: TMatrices;
      MatricB: TMatrices;
      MatricC:TMatrices;
      JacobA: TJacobiana;
      k_doub: Double;
      seg_Int,Nrovar,nrofun: Integer;
      fil,col,select,p_Int: Integer;
      Option:String;
      fx_listI: TArrString  ;
      uniq_fx: String;
      var_listI: TArrString;
      val_listI: TArrReal;
      constructor Create (TheOwner: TComponent); override;
      destructor Destroy; override;
      end;
  {Matric}

  procedure Matric.DoRun;
  var
    valI:String;
    it:integer;
    valI2: Real;
  begin
    repeat
    select:=-1;
    {Functions loop}
    repeat
    ClrScr;
    writeln('Elige una opcion:');
    WriteLn('1 Suma +');
    WriteLn('2 Resta -');
    WriteLn('3 Multiplicacion *');
    WriteLn('4 División');
    WriteLn('5 Mult. por un escalar');
    WriteLn('6 Potencia');
    WriteLn('7 Inversa (A^-1)');
    WriteLn('8 Transpuesta');
    WriteLn('9 Determinante');
    WriteLn('10 Jacobiana');
    ReadLn(Option);
    Try
        select:=StrToInt(Option);
        WriteLn('Opcion: ',select);
    except
      On E: EconvertError do
      select:=0;
    end;
    until (select < 11) and (select>0);

    if (select<9)  then begin
      writeLn('Ingresa filas para A[]');
      ReadLn(fil);
      if (select = 5) or (select = 6) or (select = 8) then begin //potencia,inversa y determinante
        writeLn('A[',fil,',',fil,']');
        MatricA:=TMatrices.Create(fil,fil);
      end
      else begin
        writeLn('Ingresa columnas para A[',fil,', ]');
        ReadLn(col);
        MatricA:=TMatrices.create(fil,col);
      end;
      writeln('Inserte datos para matriz A[',fil,',',col,']');
      MatricA.setMatriz();
      if (select<=4)then begin
         if(select=3) then begin
          fil:=col;
          writeLn('Ingresa columnas para B[',fil,', ]');
          ReadLn(col);
        end;
         if (select = 4) then begin
          writeLn('Ingresa filas para B[',fil,', ]');
          ReadLn(col);
          end;
         writeln('matriz de tamaño: ',fil,'x',col);
        MatricB:=TMatrices.create(fil,col);
        writeln('Inserte datos para matriz B[',fil,',',col,']');
        MatricB.setMatriz();
      end;
      writeln('Matriz A: ');
      MatricA.printMatriz();
      if (select<=4) then begin
        writeln('Matriz B: ');
        MatricB.printMatriz();
      end;
    end
    else if(select>=9)then begin
        writeln('funciones');
        MatricA:=TMatrices.Create(0,0);
    end;

    case select of
         1: begin
             MatricA:=MatricA.suma(MatricB);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;
         2: begin
             MatricA:=MatricA.Resta(MatricB);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;
         3: begin
             MatricA:=MatricA.Multiplicacion(MatricB);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;
         4: begin
            MatricA:=MatricA.Division(MatricB);
            WriteLn('Resultado:') ;
            MatricA.printMatriz();
         end;
         5: begin
             WriteLn('Inserte escalar (k):');
             ReadLn(k_doub);
             MatricA:=MatricA.MultEscalar(k_doub);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;
         6: begin
             WriteLn('Inserte potencia:');
             ReadLn(p_Int);
             MatricA:=MatricA.Potencia(MatricA,p_Int);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;

         7: begin
             MatricA:=MatricA.Inversa(MatricA);
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;

         8: begin
             MatricA:=MatricA.Transpuesta();
             WriteLn('Resultado:') ;
             MatricA.printMatriz();
         end;

         9: begin
             ValI2:=MatricA.Determinante(MatricA);
             writeLn('Determinante: ',ValI2:0:2);
         end;

         10: begin                                ///jacobiana
             JacobA:=TJacobiana.create();
             fx_ListI:=TArrString.Create();
             var_ListI:=TArrString.Create();
             val_ListI:=TArrReal.Create();
             writeln('Ingrese numero de funciones');
             readln(nrofun);
             writeln('Ingrese numero de variables');
             readln(nrovar);
             writeln('Ingrese las funciones');
             for it:=0 to nrofun-1 do begin
                 ReadLn(valI);
                 fx_ListI.push(valI);
             end;
             writeln('Ingrese las variables');
             for it:=0 to nrovar-1 do begin
                 Readln(valI);
                 var_listI.push(ValI);
             end;
             writeln('Ingrese los valores');
             for it:=0 to nrovar-1 do begin
                 Readln(valI2);
                 val_ListI.push(ValI2);
             end;

             MatricA:=JacobA.evaluate(fx_listI,var_listI,val_ListI,nrofun,nrovar);

             MatricA.printMatriz();

         end;

         11: begin                               ///hessiana
         end;
    end;
    WriteLn('Continuar ? si = 1');
    ReadLn(seg_Int);
    MatricA.Destroy;
    until(seg_int<>1);
    Terminate;

  end;

constructor Matric.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Matric.Destroy;
begin
  inherited Destroy;
end;

var
  Application: Matric;
begin

  Application:=Matric.Create(nil);
  Application.Title:='Operacion de Matrices';
  Application.Run;
  Application.Free;

end.

