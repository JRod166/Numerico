unit mainmatrix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, Grids, StdCtrls,Matrices,Jacobiana,ArrStr,ArrReal,Newton;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnNewt: TButton;
    btnTraza: TButton;
    btnDiv: TButton;
    btnPotencia: TButton;
    btnSuma: TButton;
    btnResta: TButton;
    btnInversa: TButton;
    btnDet: TButton;
    btnMult: TButton;
    btnTrans: TButton;
    btnMEscalar: TButton;
    btnJacob: TButton;
    ediNewt: TEdit;
    ediMEEscalar: TEdit;
    ediNewt1: TEdit;
    ediPot: TEdit;
    ediPotOrden: TEdit;
    ediMultColsA: TEdit;
    ediMultColsB: TEdit;
    ediMultFilasA: TEdit;
    ediJacob: TEdit;
    ediTransCols: TEdit;
    ediMECols: TEdit;
    ediTransFilas: TEdit;
    ediSRFilas: TEdit;
    ediSRCols: TEdit;
    ediIDFilas: TEdit;
    ediMEFilas: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Resultados: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    stgNewtFunctions: TStringGrid;
    stgNewtValores: TStringGrid;
    stgJacobVariables: TStringGrid;
    stgJacobValores: TStringGrid;
    stgNewtVariables: TStringGrid;
    stgPotMatrixA: TStringGrid;
    stgPotMatrixB: TStringGrid;
    stgMultMatrixA: TStringGrid;
    stgMultMatrixB: TStringGrid;
    stgMultMatrixC: TStringGrid;
    stgJacobFunctions: TStringGrid;
    stgJacobMatrix: TStringGrid;
    stgTransMatrixA: TStringGrid;
    stgMEMatrixA: TStringGrid;
    stgTransMatrixB: TStringGrid;
    stgIDMatrixB: TStringGrid;
    stgSRMatrixA: TStringGrid;
    stgIDMatrixA: TStringGrid;
    stgSRMatrixB: TStringGrid;
    stgSRMatrixC: TStringGrid;
    stgMEMatrixB: TStringGrid;
    stgNewtonResults: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    procedure btnDetClick(Sender: TObject);
    procedure btnDivClick(Sender: TObject);
    procedure btnInversaClick(Sender: TObject);
    procedure btnJacobClick(Sender: TObject);
    procedure btnMEscalarClick(Sender: TObject);
    procedure btnMultClick(Sender: TObject);
    procedure btnNewtClick(Sender: TObject);
    procedure btnPotenciaClick(Sender: TObject);
    procedure btnRestaClick(Sender: TObject);
    procedure btnSumaClick(Sender: TObject);
    procedure btnTransClick(Sender: TObject);
    procedure btnTrazaClick(Sender: TObject);
    procedure ediJacobChange(Sender: TObject);
    procedure ediMECols1Change(Sender: TObject);
    procedure ediMEFilasChange(Sender: TObject);
    procedure ediMultColsAChange(Sender: TObject);
    procedure ediMultColsBChange(Sender: TObject);
    procedure ediMultFilasAChange(Sender: TObject);
    procedure ediNewtChange(Sender: TObject);
    procedure ediPotOrdenChange(Sender: TObject);
    procedure ediSRColsChange(Sender: TObject);
    procedure ediSRFilasChange(Sender: TObject);
    procedure ediIDFilasChange(Sender: TObject);
    procedure ediTransColsChange(Sender: TObject);
    procedure ediTransFilasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ediSRFilasChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediSRFilas.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgSRMatrixA.RowCount:=fil;
     stgSRMatrixB.RowCount:=fil;
     stgSRMatrixC.Rowcount:=fil;
end;

procedure TForm1.ediSRColsChange(Sender: TObject);
var
  cola: String;
  col: Integer;
begin
     cola:=ediSRCols.Text;
     if(cola='')then col:=0
     else col:=StrToInt(cola);
     stgSRMatrixA.ColCount:=col;
     stgSRMatrixB.ColCount:=col;
     stgSRMatrixC.Colcount:=col;
end;

procedure TForm1.ediIDFilasChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediIDFilas.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgIDMatrixA.RowCount:=fil;
     stgIDMatrixB.RowCount:=fil;
     stgIDMatrixA.ColCount:=fil;
     stgIDMatrixB.ColCount:=fil;
end;

procedure TForm1.ediTransColsChange(Sender: TObject);
var
  cola: String;
  col: Integer;
begin
     cola:=ediTransCols.Text;
     if(cola='')then col:=0
     else col:=StrToInt(cola);
     stgTransMatrixA.ColCount:=col;
     stgTransMatrixB.RowCount:=col;
end;

procedure TForm1.ediTransFilasChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediTransFilas.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgTransMatrixA.RowCount:=fil;
     stgTransMatrixB.ColCount:=fil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;


procedure TForm1.btnSumaClick(Sender: TObject);
var
  AMatrix,BMatrix,CMatrix: TMatrices;
  i,j,fil,col: integer;
begin
     fil:=StrToInt(ediSRFilas.Text);
     col:=StrToInt(ediSRCols.Text);
     AMatrix:=TMatrices.Create(fil,col);
     BMatrix:=TMatrices.Create(fil,col);
     CMatrix:=TMatrices.Create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgSRMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgSRMatrixA.Cells[j,i]);
             if(stgSRMatrixB.Cells[j,i]='') then BMatrix.A[i,j]:=0
             else BMatrix.A[i,j]:=StrToInt(stgSRMatrixB.Cells[j,i]);
         end;
     CMatrix:=AMatrix.Suma(BMatrix);

     for i:=0 to fil-1 do
              for j:=0 to col-1 do  begin
                  stgSRMatrixC.Cells[j,i]:=FloatToStr(CMatrix.A[i,j]);
              end;
          Amatrix.Destroy;
     BMatrix.DEstroy;
     CMatrix.Destroy;

end;

procedure TForm1.btnTransClick(Sender: TObject);
var
  AMatrix,BMatrix: TMatrices;
  i,j,fil,col: integer;
begin
     fil:=StrToInt(ediTransFilas.Text);
     col:=StrToInt(ediTransCols.Text);
     AMatrix:=TMatrices.Create(fil,col);
     BMatrix:=TMatrices.Create(col,fil);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgTransMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgTransMatrixA.Cells[j,i]);
         end;
     BMatrix:=AMatrix.Transpuesta();
     for i:=0 to col-1 do
              for j:=0 to fil-1 do  begin
                  stgTransMatrixB.Cells[j,i]:=FloatToStr(BMatrix.A[i,j]);
              end;
     AMatrix.destroy;
     BMatrix.destroy;
end;

procedure TForm1.btnTrazaClick(Sender: TObject);
var
  AMatrix: TMatrices;
  i,j,fil,col: integer;
  Res: Real;
begin
     fil:=StrToInt(ediIDFilas.Text);
     col:=fil;
     AMatrix:=TMatrices.Create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgIDMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgIDMatrixA.Cells[j,i]);
         end;
     res:=AMatrix.Traza();
     AMatrix.destroy;
     Resultados.Append('Traza='+FloatToStr(res));


end;

procedure TForm1.ediJacobChange(Sender: TObject);
var
  fila: STring;
  fil: Integer;
begin
     fila:=ediJacob.text;
     if(fila='') then fil:=0
     else fil:= StrToInt(Fila);
     stgJacobFunctions.RowCount:=fil;
     stgJacobMatrix.RowCount:=fil;
     stgJacobMatrix.ColCount:=fil;
     stgJacobVariables.RowCount:=fil;
     stgJacobValores.RowCount:=fil;
end;

procedure TForm1.ediMECols1Change(Sender: TObject);
var
  cola: String;
  col: Integer;
begin
     cola:=ediMECols.Text;
     if(cola='')then col:=0
     else col:=StrToInt(cola);
     stgMEMatrixB.ColCount:=Col;
     StgMEMatrixA.ColCount:=Col;
end;

procedure TForm1.ediMEFilasChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediMEFilas.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgMEMatrixA.RowCount:=Fil;
     stgMEMatrixB.RowCount:=Fil;
end;

procedure TForm1.ediMultColsAChange(Sender: TObject);
var
  cola: String;
  col: Integer;
begin
     cola:=ediMultColsA.Text;
     if(cola='')then col:=0
     else col:=StrToInt(cola);
     stgMultMatrixB.RowCount:=Col;
     StgMultMatrixA.ColCount:=Col;
end;

procedure TForm1.ediMultColsBChange(Sender: TObject);
var
  cola: String;
  col: Integer;
begin
     cola:=ediMultColsB.Text;
     if(cola='')then col:=0
     else col:=StrToInt(cola);
     stgMultMatrixB.ColCount:=Col;
     stgMultMatrixC.ColCount:=Col;
end;

procedure TForm1.ediMultFilasAChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediMultFilasA.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgMultMatrixA.RowCount:=fil;
     stgMultMatrixC.RowCount:=fil;
end;

procedure TForm1.ediNewtChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediNewt.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgNewtFunctions.RowCount:=fil;
     stgNewtVariables.RowCount:=fil;
     stgNewtValores.RowCount:=fil;

end;

procedure TForm1.ediPotOrdenChange(Sender: TObject);
var
  fila: String;
  fil: Integer;
begin
     fila:=ediPotOrden.Text;
     if(fila='')then fil:=0
     else fil:=StrToInt(fila);
     stgPotMatrixA.RowCount:=fil;
     stgPotMatrixB.RowCount:=fil;
     stgPotMatrixA.ColCount:=fil;
     stgPotMatrixB.ColCount:=fil;

end;

procedure TForm1.btnRestaClick(Sender: TObject);
var
  AMatrix,BMatrix,CMatrix: TMatrices;
  i,j,fil,col: integer;
begin
     fil:=StrToInt(ediSRFilas.Text);
     col:=StrToInt(ediSRCols.Text);
     AMatrix:=TMatrices.Create(fil,col);
     BMatrix:=TMatrices.Create(fil,col);
     CMatrix:=TMatrices.Create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgSRMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgSRMatrixA.Cells[j,i]);
             if(stgSRMatrixB.Cells[j,i]='') then BMatrix.A[i,j]:=0
             else BMatrix.A[i,j]:=StrToInt(stgSRMatrixB.Cells[j,i]);
         end;
     CMatrix:=AMatrix.Resta(BMatrix);

     for i:=0 to fil-1 do
              for j:=0 to col-1 do  begin
                  stgSRMatrixC.Cells[j,i]:=FloatToStr(CMatrix.A[i,j]);
              end;
     Amatrix.Destroy;
     BMatrix.DEstroy;
     CMatrix.Destroy;

end;

procedure TForm1.btnInversaClick(Sender: TObject);
var
  AMatrix: TMatrices;
  i,j,fil,col: integer;
begin
     fil:=StrToInt(ediIDFilas.Text);
     col:=fil;
     AMatrix:=TMatrices.Create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgIDMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgIDMatrixA.Cells[j,i]);
         end;
     AMatrix:=AMatrix.Inversa(AMatrix);
     for i:=0 to fil-1 do
              for j:=0 to col-1 do  begin
                  stgIDMatrixB.Cells[j,i]:=FloatToStr(AMatrix.A[i,j]);
              end;
     AMatrix.destroy;

end;

procedure TForm1.btnJacobClick(Sender: TObject);
var
  Jacobiana : TJacobiana;
  fx_list,var_list: TArrString;
  val_list: TArrReal;
  AMatrix: TMatrices;
  Cantidad,i,j: Integer;
begin
     Jacobiana:= TJacobiana.create();
     fx_list:= TArrString.Create();
     var_list:= TArrString.Create();
     val_list:=TArrReal.Create();
     Cantidad:=StrToInt(ediJacob.Text);
     AMatrix:=TMatrices.Create(Cantidad,Cantidad);
     for i:=0 to cantidad-1 do begin
              fx_list.push(stgJacobFunctions.Cells[0,i]);
              var_list.push(stgJacobVariables.Cells[0,i]);
              val_list.push(StrToInt(stgJacobValores.Cells[0,i]));
     end;
     AMatrix:= Jacobiana.evaluate(fx_list,var_list,val_list,Cantidad,Cantidad);
     for i:=0 to Cantidad-1 do
              for j:=0 to Cantidad-1 do  begin
                  stgJacobMatrix.Cells[j,i]:=FloatToStr(AMatrix.A[i,j]);
              end;
     Amatrix.Destroy;
     Jacobiana.Destroy;
     fx_list.Destroy;
     var_list.Destroy;
     val_list.destroy;

end;

procedure TForm1.btnMEscalarClick(Sender: TObject);
var
   AMatrix: TMatrices;
   i,j,fil,col: Integer;
   escalar: Real;
begin
     fil:=StrToInt(ediMEFilas.text);
     col:=StrToInt(ediMECols.text);
     if(ediMEescalar.Text='') then escalar:=0
     else escalar:=StrToFloat(ediMEescalar.text);
     AMatrix:=Tmatrices.create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgMEMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgMEMatrixA.Cells[j,i]);
         end;
     AMatrix:=AMatrix.MultEscalar(escalar);
     for i:=0 to fil-1 do
              for j:=0 to col-1 do  begin
                  stgMEMatrixB.Cells[j,i]:=FloatToStr(AMatrix.A[i,j]);
              end;
     Amatrix.Destroy;
end;

procedure TForm1.btnMultClick(Sender: TObject);
var
  AMatrix,BMatrix,CMatrix: TMatrices;
  i,j,fil,cola,colb: integer;
begin
     fil:=StrToInt(ediMultFilasA.Text);
     cola:=StrToInt(ediMultColsA.Text);
     colb:=StrToInt(ediMultColsB.Text);
     AMatrix:=TMatrices.Create(fil,cola);
     BMatrix:=TMatrices.Create(cola,colb);
     CMatrix:=TMatrices.Create(fil,colb);
     for i:=0 to fil-1 do
         for j:=0 to cola-1 do  begin
             if(stgMultMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgMultMatrixA.Cells[j,i]);
         end;
     for i:=0 to cola-1 do
         for j:=0 to colb-1 do  begin
             if(stgMultMatrixB.Cells[j,i]='') then BMatrix.A[i,j]:=0
             else BMatrix.A[i,j]:=StrToInt(stgMultMatrixB.Cells[j,i]);
         end;
     CMatrix:=AMatrix.Multiplicacion(BMatrix);

     for i:=0 to fil-1 do
              for j:=0 to colb-1 do  begin
                  stgMultMatrixC.Cells[j,i]:=FloatToStr(CMatrix.A[i,j]);
              end;
     Amatrix.Destroy;
     BMatrix.DEstroy;
     CMatrix.Destroy;
end;

procedure TForm1.btnNewtClick(Sender: TObject);
var
  fx_list,var_list: TArrString;
  val_list: TArrReal;
  Error: Real;
  Cantidad,i: Integer;
  Sequence,errores: TStringList;
  Newt: TNewton;
begin
     Error:=StrToFloat(ediNewt1.text);
     Newt:=TNewton.create();
     Sequence:=TStringList.Create();
     errores:=TStringList.Create();
     fx_list:= TArrString.Create();
     var_list:= TArrString.Create();
     val_list:=TArrReal.Create();
     Cantidad:=StrToInt(ediNewt.Text);
     for i:=0 to cantidad-1 do begin
              fx_list.push(stgNewtFunctions.Cells[0,i]);
              var_list.push(stgNewtVariables.Cells[0,i]);
              val_list.push(StrToFloat(stgNewtValores.Cells[0,i]));
     end;
     Sequence:=Newt.execute(fx_list,var_list,val_list,Cantidad,Error,errores);
     with stgNewtonResults do begin
          RowCount:=Sequence.Count;
          Cols[1].Assign(Sequence);
          Cols[2].Assign(errores);
          for i:=1 to RowCount-1 do
                   Cells[0,i]:=IntToStr(i);
     end;


     fx_list.Destroy;
     var_list.Destroy;
     val_list.destroy;

end;


procedure TForm1.btnPotenciaClick(Sender: TObject);
var
   AMatrix: TMatrices;
   i,j,fil,col, potencia: Integer;
begin
     fil:=StrToInt(ediPotOrden.text);
     col:=fil;
     if(ediPot.Text='') then potencia:=0
     else potencia:=StrToint(ediPot.text);
     AMatrix:=Tmatrices.create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgPotMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgPotMatrixA.Cells[j,i]);
         end;
     AMatrix:=AMatrix.Potencia(AMatrix,potencia);
     for i:=0 to fil-1 do
              for j:=0 to col-1 do  begin
                  stgPotMatrixB.Cells[j,i]:=FloatToStr(AMatrix.A[i,j]);
              end;
     Amatrix.Destroy;

end;

procedure TForm1.btnDetClick(Sender: TObject);
var
  AMatrix: TMatrices;
  i,j,fil,col: integer;
  Res: Real;
begin
     fil:=StrToInt(ediIDFilas.Text);
     col:=fil;
     AMatrix:=TMatrices.Create(fil,col);
     for i:=0 to fil-1 do
         for j:=0 to col-1 do  begin
             if(stgIDMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgIDMatrixA.Cells[j,i]);
         end;
     res:=AMatrix.Determinante(AMatrix);
     AMatrix.destroy;
     Resultados.Append('det='+FloatToStr(res));

end;

procedure TForm1.btnDivClick(Sender: TObject);
var
  AMatrix,BMatrix,CMatrix: TMatrices;
  i,j,fil,cola,colb: integer;
begin
     fil:=StrToInt(ediMultFilasA.Text);
     cola:=StrToInt(ediMultColsA.Text);
     colb:=StrToInt(ediMultColsB.Text);
     if(fil<>cola) then begin
     showmessage('Las matrices deben ser cuadradas y de mismo orden');
     exit;
     end;
     if(cola<>colb) then begin
     showmessage('Las matrices deben ser cuadradas y de mismo orden');
     exit;
     end;
     if(fil<>colb)  then begin
     showmessage('Las matrices deben ser cuadradas y de mismo orden');
     exit;
     end;
     AMatrix:=TMatrices.Create(fil,cola);
     BMatrix:=TMatrices.Create(cola,colb);
     CMatrix:=TMatrices.Create(fil,colb);
     for i:=0 to fil-1 do
         for j:=0 to cola-1 do  begin
             if(stgMultMatrixA.Cells[j,i]='') then AMatrix.A[i,j]:=0
             else AMatrix.A[i,j]:=StrToInt(stgMultMatrixA.Cells[j,i]);
         end;
     for i:=0 to cola-1 do
         for j:=0 to colb-1 do  begin
             if(stgMultMatrixB.Cells[j,i]='') then BMatrix.A[i,j]:=0
             else BMatrix.A[i,j]:=StrToInt(stgMultMatrixB.Cells[j,i]);
         end;
     CMatrix:=AMatrix.Division(BMatrix);

     for i:=0 to fil-1 do
              for j:=0 to colb-1 do  begin
                  stgMultMatrixC.Cells[j,i]:=FloatToStr(CMatrix.A[i,j]);
              end;
     Amatrix.Destroy;
     BMatrix.DEstroy;
     CMatrix.Destroy;

end;


end.

