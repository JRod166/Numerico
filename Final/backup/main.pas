unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, ComCtrls, Mediator,grafico,Framevariables, Frame3;
type
  t_matrix= array of array of real;
type

  { TForm1 }

  TForm1 = class(TForm)
    CmdBox1: TCmdBox;
    HistoryList: TListBox;
    PageControl1: TPageControl;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    Variables: TTabSheet;
    TabSheet2: TTabSheet;
    ActualFrame: TFrame;
    ActualVarible: TFrame;
    procedure CmdBox1Input(ACmdBox: TCmdBox; Input: string);
    procedure FormCreate(Sender: TObject);
    procedure InstantFrame;

  private
    Mediator: TMediator;
    ListVar: TStringList;
    FrameSelected: Integer;
    h:Real;
    procedure StartCommand();
    procedure ShowCommands();


  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  CmdBox1.TextColor(clWhite);
  CmdBox1.Writeln('Bienvenido');
  CmdBox1.Writeln('Escriba help si necesita ayuda');
  CmdBox1.StartRead( clWhite, clBlack, '>>  ', clwhite, clBlack);
  h:=0.1;
  ListVar:=TStringList.Create;
  Mediator:=TMediator.create(StringGrid1);
end;

procedure TForm1.ShowCommands();
begin
  cmdBox1.Writeln('Comandos');
  cmdBox1.Writeln('Matrices: (es necesario declarar las matrices)');
  cmdBox1.Writeln('suma(A,B)');
  cmdBox1.Writeln('resta(A,B)');
  cmdBox1.Writeln('mult(A,B)');
  cmdBox1.Writeln('mulEscalar(A,numero)');
  cmdBox1.Writeln('powerMatrix(A,numero)');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('evaluarfuncion("funcion",punto_a_evaluar');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Area');
  cmdBox1.Writeln('area("funcion1","funcion2",min,max');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Graficar funciones');
  cmdBox1.Writeln('plot("funcion",min,max');
  cmdBox1.Writeln('intersection("funcion1","funcion2",min,max');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Raiz de una funcion');
  cmdBox1.Writeln('rootC("funcion",inicio_intervalo,fin_intervalo,error,"metodo"');
  cmdBox1.Writeln('1. biseccion   2.newton ');
  cmdBox1.Writeln('rootA("funcion",valor_inicial,error,"metodo"');
  cmdBox1.Writeln('1. newton      2.secante');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Integrales');
  cmdBox1.Writeln('integrar("funcion",inicio,fin,#Iteraciones,"metodo"');
  cmdBox1.Writeln('1. trapecio    2. simpson13    3.simpson38');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Ecuaciones Diferenciales Ordinarias');
  cmdBox1.Writeln('edo("funcion_derivada",X_0,X_f,Y_0,#Iteraciones,"metodo"');
  cmdBox1.Writeln('1. euler     2. RungeKutta4    3.dormandPrince');
  cmdBox1.Writeln('');
  cmdBox1.Writeln('Sistema de ecuaciones diferenciales');
  cmdBox1.Writeln('secdifo("y1'' ","y2'' ",...,"yn'' ",y1(0),y2(0),...yn(0),x0,xf,#iter');
  cmdBox1.Writeln('Lagrange');
  cmdBox1.Writeln('lagrange(x1,y1,x2,y2,...,xn,yn)');
end;

procedure TForm1.CmdBox1Input(ACmdBox: TCmdBox; Input: string);
var
  final,raiz: string;
  i:integer;
begin
  try
    Input:=Trim(Input);
    case input of
         'help': ShowCommands();
         'exit': Application.Terminate;
         'clear': begin
           CmdBox1.Clear;
           StartCommand();
           end;
         'clearhistory':CmdBox1.ClearHistory;

         else begin
           final:=StringReplace(Input,' ','',[ rfReplaceAll ]); //Eliminamos los espacios en blanco
           if (Pos( '=', final ) > 0 ) then begin  //si hay = es una asignacion
             FrameSelected:=1;
             if(Pos('lagrange',final)>0)then begin
               Mediator.grafica:=TFrame1(ActualFrame);
             end;
             InstantFrame;
             Mediator.addVariable(final);
           end
           else if Input<>'' then begin     //si la cadena no esta vacia es un metodo
             FrameSelected:=1;
             InstantFrame;
             Mediator.grafica:=TFrame1(ActualFrame);
             raiz:=Mediator.execute(Input);
             CmdBox1.Writeln(raiz);
           end;
         end;
    end;
  finally
    StartCommand();
    HistoryList.Clear;
    for i:=0 to CmdBox1.HistoryCount-1 do HistoryList.Items.Add(CmdBox1.History[i]);
  end;

end;

///Esta funcion sirve para cargar el Frame que queremos en los paneles
procedure TForm1.InstantFrame;
begin
   case FrameSelected of
       1: begin
            if Assigned(ActualFrame) then
                ActualFrame.Free;
            ActualFrame:=TFrame1.Create(Panel4);ActualFrame.Parent:= Panel4;ActualFrame.Align:= alClient;
          end;
       2: begin
            if Assigned(ActualVarible) then
                ActualVarible.Free;
            ActualVarible:=TFrame2.Create(Variables);ActualVarible.Parent:=Variables;ActualVarible.Align:= alClient;
          end;
       3: begin
            if Assigned(ActualFrame) then
                ActualFrame.Free;
            ActualFrame:=TFrame3.Create(Panel4);ActualFrame.Parent:=Panel4;ActualFrame.Align:= alClient;
          end;

   end;

end;


procedure TForm1.StartCommand();
begin
  CmdBox1.StartRead(clWhite,clBlack,'>>  ',clWhite,clBlack);
end;

end.

