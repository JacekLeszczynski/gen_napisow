program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, datetimectrls, zcomponent, uecontrols, main, serwis;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Generator Napisów';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFGenNapisow, FGenNapisow);
  Application.Run;
end.

