unit sedo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,Dialogs,math;
type
  arrayDouble = array of Double;

type
  TSedo=class
    function execute():string;

    private
      procedure findks1;
      procedure findks2;
      procedure findks3;
      procedure findks4;
      procedure rungekutta;
      function f: Double;

    public
      initialvallist, functionlist: TStringList;
      xf,h,x: Double;
      iter: integer;
      ks1,ks2,ks3,ks4: array of Double;
      resultlist: array of arrayDouble;
      Parse: TParseMath;
      constructor create(Input: String);
  end;

implementation

procedure TSedo.findks1;
var
   i: Integer;
begin
  for i:=1 to initialvallist.Count-1 do begin
    Parse.Expression:=functionlist[i-1];
    ks1[i-1]:=f;
  end;
end;

procedure TSedo.findks2;
var
   i: Integer;
begin
  SetLength(resultlist,Length(resultlist)+1);
  SetLength(resultlist[Length(resultlist)-1],initialvallist.Count);
  resultlist[Length(resultlist)-1][0]:= resultlist[Length(resultlist)-2][0]+h/2;
  for i:=1 to initialvallist.Count-1 do begin
    resultlist[Length(resultlist)-1][i]:=resultlist[Length(resultlist)-2][i]+ks1[i-1]*h/2;
  end;
  for i:=1 to initialvallist.Count-1 do begin
    Parse.Expression:=functionlist[i-1];
    ks2[i-1]:=f
  end;
end;

procedure TSedo.findks3;
var
   i:Integer;
begin
  SetLength(resultlist,Length(resultlist)+1);
  SetLength(resultlist[Length(resultlist)-1],initialvallist.count);
  resultlist[Length(resultlist)-1][0]:= resultlist[Length(resultlist)-1][0];

  for i:=1 to initialvallist.Count-1 do begin
    resultlist[Length(resultlist)-1][i]:=resultlist[Length(resultlist)-3][i]+ks2[i-1]*h/2;
  end;

  for i:=1 to initialvallist.Count-1 do begin
    Parse.Expression:=functionlist[i-1];
    ks3[i-1]:=f;
  end;
end;

procedure TSedo.findks4;
var
   i:Integer;
begin
  SetLength(resultlist,Length(resultlist)+1);
  SetLength(resultlist[Length(resultlist)-1],initialvallist.Count);
  resultlist[Length(resultlist)-1][0]:=resultlist[Length(resultlist)-1][0];

  for i:=1 to initialvallist.Count-1 do begin
    resultlist[Length(resultlist)-1][i]:=resultlist[Length(resultlist)-4][i]+ks3[i-1]*h/2;
  end;

  for i:=1 to initialvallist.Count-1 do begin
    Parse.Expression:=functionlist[i-1];
    ks4[i-1]:=f;
  end;
end;

procedure TSedo.rungekutta;
var
   ks,j:Double;
   i:Integer;
begin
  while (resultlist[Length(resultlist)-1][0] <> xf ) do begin
        j:=resultlist[Length(resultlist)-1][0];
      findks1;
      findks2;
      findks3;
      findks4;

      SetLength(resultlist,Length(resultlist)+1);
      SetLength(resultlist[Length(resultlist)-1],initialvallist.Count);
      resultlist[Length(resultlist)-1][0]:=j+h;

      for i:=1 to initialvallist.Count-1 do begin
        ks:=ks1[i-1]+2*(ks2[i-1]+ks3[i-1])+ks4[i-1];
        resultlist[Length(resultlist)-1][i]:=resultlist[Length(resultlist)-5][i]+ks/6*h;
      end;
  end;
end;

function TSedo.execute():string;
var
   i,j: Integer;
   aux: string;
   matrixres: array of array of string;
begin
  SetLength(resultlist[0],initialvallist.Count);
  for i:=0 to initialvallist.Count-1 do begin
      resultlist[0][i]:=StrToInt(initialvallist[i]);
  end;
  rungekutta;
  aux:='';
  SetLength(matrixres,iter+1);
  for i:=0 to iter do begin
    SetLength(matrixres[i],length(resultlist[i]));
    for j:=0 to Length(resultlist[i])-1 do begin
      matrixres[i][j]:=Floattostr(roundto(resultlist[i*4][j],-6));
    end;
    //aux:='';
  end;
  for j:=1 to Length(resultlist[i])-1 do begin
    for i:=0 to iter do begin
      aux:=aux+'('+matrixres[i][0]+','+matrixres[i][j]+');';
    end;
    aux:=aux+#13#10;
  end;

  ShowMessage(aux);
  Result:=aux;

end;

function TSedo.f: Double;
var
   i: Integer;
begin
  Parse.NewValue('x',x);
  for i:=1 to initialvallist.Count-1 do
      Parse.NewValue('y'+IntToStr(i),resultlist[Length(resultlist)-1][i]);

  Result:=Parse.Evaluate();
end;

constructor TSedo.create(Input:string);
var
   i: integer;
   poscomilla: integer;
   poscoma: integer;
   aux:string;
begin
  initialvallist:=TStringList.Create;
  functionlist:=TStringList.Create;
  Parse:=TParseMath.create();
  //parsear input
  poscomilla:=Pos('''',Input);
  poscoma:=Pos(',',Input);
  while poscomilla<>0 do begin
    aux:=Copy(Input,poscomilla+1,poscoma-3);
//    ShowMessage('function: '+aux);
    Input:=Copy(Input,poscoma+1,Length(Input)-poscoma);
//    ShowMessage('queda -> '+Input);
    poscomilla:=Pos('''',Input);
    poscoma:=Pos(',',Input);
    functionlist.Add(aux);
    //secdifo('-0.5*y1','4-0.3*y2-0.1*y1',0,4,6,2,4)
  end;
  for i:=0 to functionlist.Count do begin
    aux:=Copy(Input,0,poscoma-1);
    Input:=Copy(Input,poscoma+1,Length(Input)-poscoma);
//    ShowMessage('added->'+aux);
//    ShowMessage('string->' +Input);
    poscoma:=Pos(',',Input);
    initialvallist.Add(aux);
  end;
//  ShowMessage('queda '+Input);
  aux:=Copy(Input,0,poscoma-1);
  Input:=Copy(Input,poscoma+1,Length(Input)-1);
//  showmessage('xf: '+aux);
  xf:=StrToFloat(aux);
  ShowMessage('iter: '+Input);
  iter:=StrToInt(Input);
  Parse.AddVariable('x',0.0);
  x:=StrToFloat(initialvallist[0]);
  h:=abs(x-xf)/iter;

  for i:=1 to initialvallist.Count-1 do begin
      Parse.AddVariable('y'+IntToStr(i),0.0);
//      ShowMessage('added variable y'+IntToStr(i));
  end;
  i:=initialvallist.count-1;
  SetLength(ks1,i);
//  ShowMessage('set ks1: '+IntToStr(Length(ks1)));
  SetLength(ks2,i);
//  ShowMessage('set ks2: '+IntToStr(Length(ks2)));
  SetLength(ks3,i);
//  ShowMessage('set ks3: '+IntToStr(Length(ks3)));
  SetLength(ks4,i);
//  ShowMessage('set ks4: '+IntToStr(Length(ks4)));
  SetLength(resultlist,1);
//  ShowMessage('created');
end;

end.

