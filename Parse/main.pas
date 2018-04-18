unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, ParseMath, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnEvaluateSlow: TButton;
    EvaluateFaster: TButton;
    ediFunc: TEdit;
    ediX: TEdit;
    ediY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memResult: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    procedure btnEvaluateSlowClick(Sender: TObject);
    procedure EvaluateFasterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);

  private
    Parse: TParseMath;
    Xvalue,
    YValue: Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnEvaluateSlowClick(Sender: TObject);
var MyParse: TParseMath;
    x,
    y,
    fxy: Real;
begin
   (* Usually this way is because we evaluate one time. *)
   x:= StrToFloat( ediX.Text );
   y:= StrToFloat( ediY.Text );
   MyParse:= TParseMath.create();
   MyParse.Expression:= ediFunc.Text;
   MyParse.AddVariable( 'x', x );
   MyParse.AddVariable( 'y', y );
   fxy:= MyParse.Evaluate();
   memResult.Lines.Add( 'f(' + ediX.Text + ', ' + ediY.Text + ') = ' + FloatToStr( fxy ) );
   MyParse.destroy;
end;

procedure TForm1.EvaluateFasterClick(Sender: TObject);
var fxy: REal;
begin
  (* Usually this way is because we evaluate several times *)
  Parse.Expression:= ediFunc.Text;
  Xvalue:= StrToFloat( ediX.Text );
  YValue:= StrToFloat( ediY.Text );
  Parse.NewValue( 'x', Xvalue );
  Parse.NewValue( 'y', YValue );
  fxy:= Parse.Evaluate();
  memResult.Lines.Add( 'f(' + ediX.Text + ', ' + ediY.Text + ') = ' + FloatToStr( fxy ) );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  (* This parse its for several times. (faster) *)
  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);
  Parse.AddVariable( 'y', 0 );

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;



end.

