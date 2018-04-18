unit Hessiana;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,ParseMath,Matrices,ArrStr,ArrReal;

type THessiana = Class
  uniq_fx: String;
  var_list: TArrStr;
  val_list: TArrReal;
  tam: Integer;
  constructor create();

implementation

end.

