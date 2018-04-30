unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TAChartCombos, TAStyles, TAIntervalSources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids ,math, met_num;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGraph: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    chkProportional: TCheckBox;
    error: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    metodosInput: TComboBox;
    ediPointX: TEdit;
    pnlRight: TPanel;
    tableOutput: TStringGrid;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    //procedure btnPointClick(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure chkProportionalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private
    metodoNum : MetodosNumericos;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);

var
  temp : Real;
  procedure fillGrid;
  var i : Integer;
  begin
    with tableOutput do
    for i:=1 to RowCount -1 do begin
      Cells[0,i]:= IntToStr(i);
      if i >=2 then
         Cells[2,i] := FloatToStr(abs(StrToFloat(metodoNum.sequence[i]) - StrToFloat(metodoNum.sequence[i-1])));
    end;
  end;

begin
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= True;

  metodoNum:= MetodosNumericos.Create;
  metodoNum.numericMethod := metodosInput.ItemIndex;
  metodoNum.errorAllowed:= StrToFloat(error.Text);
  //writeLn(metodoNum.errorAllowed);
  metodoNum.xo := StrToFloat(ediPointX.Text);
  //metodoNum.b := StrToFloat( ediPointY.Text );
  temp:= metodoNum.execute();
  //resultado.Caption:= FloatToStr(temp);
  if not isNan(Temp) then begin
    chartGraphicsLineSeries1.ShowLines:=false;
    chartGraphicsLineSeries1.ShowPoints:=true;
    chartGraphicsLineSeries1.AddXY(temp, metodoNum.f(temp));
  end;
  with tableOutput do begin
    RowCount:=MetodoNum.sequence.Count;
    cols[1].Assign(metodoNum.sequence);
  end;

  fillGrid;


end;
{
procedure TfrmMain.btnPointClick(Sender: TObject);
var x, y: Real;
begin
  x:= StrToFloat(ediPointX.Text);
  y:= StrToFloat( ediPointY.Text );
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.AddXY( x, y );
end;
}
procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY:= metodoNum.f( AX );
end;

procedure TfrmMain.chkProportionalChange(Sender: TObject);
begin
  chartGraphics.Proportional:= not chartGraphics.Proportional;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  chartGraphics.Extent.XMin:=TrbMin.Position;
  chartGraphics.Extent.XMax:= TrbMax.Position;
  metodoNum:= MetodosNumericos.create;
  metodosInput.Items.Assign(metodoNum.metodosList);
end;

procedure TfrmMain.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TfrmMain.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;

end.

