unit ArrStr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type TArrString = class
    public
      lista:TList;
      Constructor Create();
      procedure push(val : String);
//      procedure push();
      function get(i : Integer): String;
      function get(): String;
      function size_arr():Integer;
end;

implementation

Constructor TArrString.Create();
begin
      lista:=TList.Create;

end;

procedure TArrString.push(val: String);
var
   pInt:^String;
begin
   new(pInt);
   pInt^:=val;
   lista.Add(pInt);
end;


function TArrString.get(i : Integer): String;
var
   ptop : ^String;
begin
   ptop := lista.Items[i];
   //WriteLn('aqui');
   //ReadLn;
   get := ptop^;
end;



function TArrString.get(): String;  //imprime desde la base al top
var
   contenido : String;
   ptr_str : ^String;
   i : Integer;
begin
   new (ptr_str);
   for i:=0 to lista.Count-1 do
   begin
     ptr_str:=lista.Items[i];
     //contenido := ptr_str^+ contenido;
     contenido := contenido + ptr_str^;
   end;
   get :=contenido;
end;


function TArrString.size_arr():Integer;
begin
         size_arr:= lista.Capacity;

end;

end.

