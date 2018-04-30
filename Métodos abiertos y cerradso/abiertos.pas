unit Abiertos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,Dialogs,math;

type
  TAbiertos = class
    constructor create;
    destructor Destroy; override;
    function Newton(error:double;FExpression: string): TStringList;
    function Secante(error:double;FExpression: string): TStringList;
    function Puntofijo(error:double;FExpression: string): TStringList;
    public
      pmath: TParseMath;
      sequence: TStringList;
  end;


implementation

constructor TAbiertos.create;
begin
end;

destructor TAbiertos.Destroy;
begin
end;

function TAbiertos.Newton(error: double; FExpression: String): TStringList;
begin
  pmath:=TParseMath.create();

end;

function TAbiertos.Secante(error: double; FExpression: String): TStringList;
begin
end;

function TAbiertos.Puntofijo(error: double; FExpression: String): TStringList;
begin
end;

end.

