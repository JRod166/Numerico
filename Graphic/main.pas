unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TAChartCombos, TAStyles, TAIntervalSources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Types;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGraph: TButton;
    btnPoint: TButton;
    btnIntersec: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    ChartToolset1: TChartToolset;
    chkProportional: TCheckBox;
    ediPointX: TEdit;
    ediPointY: TEdit;
    ediPresicion: TEdit;
    Label1: TLabel;
    pnlRight: TPanel;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    procedure btnIntersecClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool;
      APoint: TPoint);
    procedure chkProportionalChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);
begin
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= True;
end;

procedure TfrmMain.btnIntersecClick(Sender: TObject);
var MaxX, MinX, Presicion,a: Double;
begin
  MaxX:=trbMax.Position;
  MinX:=trbMin.Position;
  Presicion:=StrToFloat(ediPresicion.Text);
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  while(MinX<=MaxX) do begin
    if (abs(sin(MinX))<Presicion) then begin
    chartGraphicsLineSeries1.AddXY(MinX,0);
    end;
    MinX:=MinX+Presicion;
  end;
end;

procedure TfrmMain.btnPointClick(Sender: TObject);
var x, y: Real;
begin
  x:= StrToFloat(ediPointX.Text);
  y:= StrToFloat( ediPointY.Text );
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.AddXY( x, y );
end;

procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY:= sin( AX );
end;

procedure TfrmMain.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var
  x, y: Double;
begin
(*  with ATool as TDatapointClickTool do
    if (Series is TFuncSeries) then
      with TFuncSeries(Series) do begin
        x := GetXValue(PointIndex);
        y := GetYValue(PointIndex);
        ShowMessage('Click!');
        ShowMessage(FloatToStr(x)+','+FloatToStr(y));
      end;
 *)
end;

procedure TfrmMain.chkProportionalChange(Sender: TObject);
begin
  chartGraphics.Proportional:= not chartGraphics.Proportional;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
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

