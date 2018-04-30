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
  end;


implementation

end.

