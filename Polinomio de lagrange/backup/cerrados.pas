unit Cerrados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,math,Dialogs;


type
  TCerrados = class
    constructor create();
    destructor Destroy; override;
    function biseccion(a,b,error: Double;asequence,bsequence:TStringList; FExpression: String):TStringList;
    function falsaposicion(a,b,error: Double;asequence,bsequence:TStringList; FExpression: String):TStringList;
    private
      sequence: TStringList;
      func: TParseMath;
  end;

implementation

constructor TCerrados.create();
begin
  sequence:=TStringList.Create;
end;

destructor TCerrados.Destroy();
begin
end;

function TCerrados.biseccion(a,b,error: Double;asequence,bsequence:TStringList;FExpression: string):TStringList;
var
  i: integer;
  fa,fb,fxn,bolzano,xn,erroractual: Double;
begin
  func:=TParseMath.create();
  func.Expression:=FExpression;
  func.AddVariable('x',0);
  sequence:=TStringList.Create;
  sequence.add('Xn');
  //Bolzano
  func.NewValue('x',a);
  fa:=func.Evaluate();
  func.NewValue('x',b);
  fb:=func.Evaluate();
  bolzano:=fa*fb;
  xn:=((a+b)/2);
  func.NewValue('x',xn);
  fxn:=func.Evaluate();
  if(fa=Infinity) or (fxn=infinity) then begin
    ShowMessage('Funcion no continua');
    Result:=sequence;
    exit;
  end;


  if(bolzano>0) then begin
    ShowMessage('a y b no cumplen teorema de bolzano');
    Result:=sequence;
    exit;
  end;
  if(bolzano=0) then begin
    if(fa=0) then
    sequence.Add(FloatToStr(a));
    if(fb=0) then
    sequence.Add(FloatToStr(b));
    Result:=sequence;
    exit;
  end;
  i:=1;
  repeat
    asequence.Add(FloatToStr(a));
    bsequence.Add(FloatToStr(b));
    sequence.add(FloatToStr(xn));
    if(fa*fxn>0) then begin
    a:=xn;
    fa:=fxn;
    end
    else begin
    b:=xn;
    fb:=fxn;
    end;
    xn:=((a+b)/2);
    func.NewValue('x',xn);
    fxn:=func.Evaluate();
    erroractual:=(b-a)/(power(2,i));
    i:=i+1;
  until(erroractual<=error) ;
  Result:=sequence;
end;

function TCerrados.falsaposicion(a,b,error: Double;asequence,bsequence:TStringList; FExpression: String):TStringList;
var
  fa,fb,fxn,bolzano,xn,temp,erroractual: Double;
begin
  func:=TParseMath.create();
  func.Expression:=FExpression;
  func.AddVariable('x',0);
  sequence:=TStringList.Create;
  sequence.add('Xn');
  //Bolzano
  func.NewValue('x',a);
  fa:=func.Evaluate();
  func.NewValue('x',b);
  fb:=func.Evaluate();
  bolzano:=fa*fb;
  xn:= (a-( (fa*(b-a))/(fb-fa) ) );
  func.NewValue('x',xn);
  fxn:=func.Evaluate();
  if(fa=Infinity) or (fxn=infinity) then begin
    ShowMessage('Funcion no continua');
    Result:=sequence;
    exit;
  end;


  if(bolzano>0) then begin
    //ShowMessage('a y b no cumplen teorema de bolzano');
    Result:=sequence;
    exit;
  end;
  if(bolzano=0) then begin
    if(fa=0) then
    sequence.Add(FloatToStr(a));
    if(fb=0) then
    sequence.Add(FloatToStr(b));
    Result:=sequence;
    exit;
  end;

  repeat
    asequence.Add(FloatToStr(a));
    bsequence.Add(FloatToStr(b));
    sequence.Add(FloatToStr(Xn));
    if(fa*fxn>0) then begin
      a:=xn;
      fa:=fxn;
    end
    else begin
      b:=xn;
      fb:=xn;
    end;
    temp:=xn;
    xn:= (a-( (fa*(b-a))/(fb-fa) ) );
    func.NewValue('x',xn);
    fxn:=func.Evaluate();
    erroractual:=abs(xn-temp);
  until (erroractual<=error) ;
  Result:=sequence;
end;

end.

