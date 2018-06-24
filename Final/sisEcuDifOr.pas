unit sisEcuDifOr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath, dialogs, Math;


  // set parser expression
  //before create set initial initialValues
  //initialValues[0] = x
  //starts y1

  type
    arrayDouble = array of Double;

  type
    sedo = class
    initialValues: array of Double;
    answers: array of arrayDouble;
    askedVal, stepSize: Double;
    ks1, ks2, ks3, ks4: array of Double;
    parser: TParseMath;
    derivadas: array of String;
    procedure execute;
    private
      procedure calculateK1s;
      procedure calculateK2s;
      procedure calculateK3s;
      procedure calculateK4s;
      procedure rungeKutta;
      function f: Double;
    public
      constructor create;
    end;

implementation


procedure sedo.calculateK1s;
var
  i: Integer;
begin

  for i:=1 to Length(initialValues)-1 do begin
    parser.Expression:= derivadas[i-1];
    ks1[i-1]:= f;
  end;
end;

procedure sedo.calculateK2s;
var
  i: Integer;
begin
  setLength(answers, length(answers)+1);
  setLength(answers[Length(answers)-1], length(initialValues));
  answers[length(answers)-1][0]:= answers[length(answers)-2][0] + stepSize/2;

  for i:= 1 to length(initialValues)-1 do begin
    answers[length(answers)-1][i]:= answers[Length(answers)-2][i] + ks1[i-1]*stepSize/2;
  end;

  for i:=1 to Length(initialValues)-1 do begin
    parser.Expression:= derivadas[i-1];
    ks2[i-1]:= f;
  end;
end;

procedure sedo.calculateK3s;
var
  i: Integer;
begin

  setLength(answers, length(answers)+1);
  setLength(answers[Length(answers)-1], length(initialValues));
  answers[length(answers)-1][0]:= answers[length(answers)-1][0];

  for i:= 1 to length(initialValues)-1 do begin
    answers[length(answers)-1][i]:= answers[Length(answers)-3][i] + ks2[i-1]*stepSize/2;
  end;

  for i:=1 to Length(initialValues)-1 do begin
    parser.Expression:= derivadas[i-1];
    ks3[i-1]:= f;
  end;

end;

procedure sedo.calculateK4s;
var
  i: Integer;

begin

  setLength(answers, length(answers)+1);
  setLength(answers[Length(answers)-1], length(initialValues));
  answers[length(answers)-1][0]:= answers[length(answers)-1][0];

  for i:= 1 to length(initialValues)-1 do begin
    answers[length(answers)-1][i]:= answers[Length(answers)-4][i] + ks3[i-1]*stepSize/2;
  end;

  for i:=1 to Length(initialValues)-1 do begin
    parser.Expression:= derivadas[i-1];
    ks4[i-1]:= f;
  end;


end;

procedure sedo.rungeKutta;
var
  pendiente: Double;
  i,j: Integer;
begin

  while (answers[Length(answers) -1][0] <> askedVal) do begin
    calculateK1s;
    calculateK2s;
    calculateK3s;
    calculateK4s;

    setLength(answers, length(answers)+1);
    setLength(answers[length(answers)-1], length(initialValues));
    answers[length(answers)-1][0]:= length(answers);

    for i:= 1 to length(initialValues)-1 do begin
      pendiente:=ks1[i-1] + 2*(ks2[i-1] + ks3[i-1]) + ks4[i-1];
      answers[length(answers)-1][i]:= answers[Length(answers)-5][i] + pendiente/6*stepSize;
    end;
  end;
end;


procedure sedo.execute;
var
  i: Integer;
begin

  setLength(answers[0], length(initialValues));
  for i:=0 to length(initialValues)-1 do
    answers[0][i] := initialValues[i];
  rungeKutta;
end;

function sedo.f: Double;
var
  i: Integer;
begin

  parser.newValue('x', x);
  for i:=1 to length(initialValues)-1 do
      parser.newValue('y' + IntToStr(i), answers[length(answers)-1][i]);

  Result:= parser.evaluate();
end;

constructor sedo.create;
var
  i: Integer;
begin
     parser := TParseMath.create;
     parser.AddVariable('x', 0.0);


     for i:=1 to length(initialValues)-1 do
       parser.AddVariable('y'+ IntToStr(i), 0.0);
     setLength(ks1, length(initialValues)-1);
     setLength(ks2, length(initialValues)-1);
     setLength(ks3, length(initialValues)-1);
     setLength(ks4, length(initialValues)-1);
     setLength(answers, 1);

end;

end.
