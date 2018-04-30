unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids, Menus,
  ComCtrls, StdCtrls, ExtCtrls, mResult, mOpenMethod;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    newton: TPageControl;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// power(2.71828182845904523536,x)-power(x,-1)
// power(2.71828182845904523536,x)+power(x,-2)

// power(2.71828182845904523536,x)-(1/x)
// power(2.71828182845904523536,x)+(1/power(x,2))

procedure TForm1.Button1Click(Sender: TObject);
var
  funExp, funDExp: string;
  xn, e: double;
  res : TResult;
  open: TOpenMethod;
  i,j: integer;
begin
    funExp:= Edit1.Text;
    funDExp:= Edit2.Text;
    xn := StrToFloat(Edit3.Text);
    e := StrToFloat(Edit4.Text);

    //StringGrid1.RowCount:=StringGrid1.RowCount+1;

    if RadioButton1.Checked then
      res := open.newton(xn,funExp,funDExp,e);
    if RadioButton2.Checked then
      res := open.secante(xn,funExp,e);


    Memo1.Lines.Add( res.result );
    //Memo1.Lines.Add( IntToStr(Length(res.matrix)) + ' '+ IntToStr(Length(res.matrix[0])));
    //Memo1.Lines.Add( res.matrix[1,1] +' '+ res.matrix[1,2] );

    for i:= 0 to Length(res.matrix)-1 do
    begin
        StringGrid1.RowCount:=StringGrid1.RowCount + 1;
        for j:=0 to Length(res.matrix[0])-1 do
            StringGrid1.Cells[j,i+1] := res.matrix[i,j];
    end;



end;



end.

