unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Grids, Cerrados, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnExecCerrados: TButton;
    cboCerrados: TComboBox;
    ediBCerrados: TEdit;
    ediErrorCerrados: TEdit;
    ediFunCerrados: TEdit;
    ediACerrados: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    PageControl1: TPageControl;
    stgCerrados: TStringGrid;
    TabSheet1: TTabSheet;
    OpenM, CloseM: TStringList;
    procedure btnExecCerradosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
    sequence,asequence,bsequence: TStringList;

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  CloseM:=TStringList.Create;
  CloseM.AddObject('Bisección',TObject(1));
  CloseM.AddObject('Falsa posición',TObject(2));
  cboCerrados.Items.Assign(CloseM);
  cboCerrados.ItemIndex:=0;
end;

procedure TForm1.btnExecCerradosClick(Sender: TObject);
var
  func,i: integer;
  cerrados: TCerrados;
  a,b,error,Error2: Double;
  fx: String;
begin
  func:=Int64( cboCerrados.Items.Objects[ cboCerrados.ItemIndex ] );
  cerrados:=TCerrados.create();
  a:=StrToFloat(ediACerrados.Text);
  b:=StrToFloat(ediBCerrados.Text);
  sequence:=TStringList.Create;
  asequence:=TStringList.Create;
  bsequence:=TStringList.Create;
  asequence.Add('a');
  bsequence.Add('b');
  error:=StrToFloat(ediErrorCerrados.Text);
  fx:=ediFunCerrados.Text;
  if(func=1) then begin
    sequence:=cerrados.biseccion(a,b,error,asequence,bsequence,fx);
  end;
  if (func=2) then begin
  sequence:=cerrados.falsaposicion(a,b,error,asequence,bsequence,fx);
  end;
  with stgCerrados do begin
  RowCount:=sequence.Count;
  Cols[1].Assign(asequence);
  Cols[2].Assign(bsequence);
  Cols[3].Assign(sequence);
  for i:=1 to RowCount-1 do begin
      if (func=1) then Error2:=abs(( StrToFloat(Cells[2,i])-StrToFloat(Cells[1,i]) ) / power(2,i))
      else begin
           if (i=1) then Error2:=1
           else begin
                Error2:=abs(StrToFloat(Cells[3,i-1])-StrToFloat(Cells[3,i]));
           end;
      end;
      Cells[0,i]:=IntToStr(i);
      Cells[4,i]:=FloatTostr(Error2);
  end;
  end;
  sequence.Destroy;
  asequence.Destroy;
  bsequence.Destroy;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
end;

end.

