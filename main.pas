unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  Buttons, ExtCtrls, XMLPropStorage, AsyncProcess, DBGrids, DBCtrls, Menus,
  DBExtCtrls, Spin, DBDateTimePicker, TplGaugeUnit, TplSliderUnit, ueled,
  MPlayerCtrl, Presentation, NetSynHTTP, DBGridPlus, ExtMessage, memds, DB;

type

  { TFGenNapisow }

  TFGenNapisow = class(TForm)
    Bevel1: TBevel;
    BitBtn4: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DBDateTimePicker1: TDBDateTimePicker;
    DBDateTimePicker2: TDBDateTimePicker;
    DBGridPlus1: TDBGridPlus;
    DBMemo1: TDBMemo;
    dsLinie: TDataSource;
    mess: TExtMessage;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    http: TNetSynHTTP;
    ImageList1: TImageList;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    linie: TMemDataset;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    postep: TplGauge;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    test1: TTimer;
    uELED1: TuELED;
    uELED2: TuELED;
    widmo: TAsyncProcess;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    mplayer: TMPlayerControl;
    Panel2: TPanel;
    pilot: TPresentation;
    plik: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    propstorage: TXMLPropStorage;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure DBMemo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mplayerPlaying(ASender: TObject; APosition, ADuration: single);
    procedure mplayerStop(Sender: TObject);
    procedure plikChange(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure MinusTime(Sender: TObject);
    procedure PlusTime(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure test1StartTimer(Sender: TObject);
    procedure test1StopTimer(Sender: TObject);
    procedure test1Timer(Sender: TObject);
    procedure widmoReadData(Sender: TObject);
  private
    srt: string;
    aa,bb,ll: integer;
    mplayer_pause: boolean;
    mplayer_t2_pause: single;
    procedure OpenDB;
    procedure CloseDB;
    procedure linie_clear;
    function StrDurationToTimeInteger(aStr: string): longint;
    function StrFrameTimeToTimeInteger(aStr: string): longint;
    function StrSilenceToTimeInteger(start_end: integer; aStr: string): longint;
    procedure przelicz;
    procedure dopisz;
    procedure WczytajPlik(aFileName: string);
    procedure ZapiszPlik;
    procedure play_record(aStart,aStop: TTime);
    procedure play_record(aPercent: integer = 0);
    function wstaw_linie(aStart,aStop: TTime): integer;
    function RenameExt(aFilename,aNewExt: string): string;
  public

  end;

var
  FGenNapisow: TFGenNapisow;

implementation

uses
  ecode, lcltype;

{$R *.lfm}

var
  nowa_linia: record
    b: boolean;
    start,stop: TTime;
  end;

function IntToCString(a: integer; len: integer): string;
var
  s: string;
  l,i: integer;
begin
  s:=IntToStr(a);
  l:=length(s);
  for i:=l to len-1 do s:='0'+s;
  result:=s;
end;

{ TFGenNapisow }

procedure TFGenNapisow.BitBtn1Click(Sender: TObject);
var
  fs: TFormatSettings;
begin
  linie_clear;
  //mplayer.Filename:=plik.FileName;
  //mplayer.Play;
  fs.DecimalSeparator:='.';
  aa:=0;
  bb:=0;
  ll:=0;
  Label5.Caption:=IntToCString(ll,4);
  //ss.Clear;
  widmo.Executable:='ffmpeg';
  widmo.CurrentDirectory:=ExtractFileDir(plik.FileName);
  widmo.Parameters.Clear;
  widmo.Parameters.Add('-i');
  widmo.Parameters.Add(ExtractFileName(plik.FileName));
  widmo.Parameters.Add('-af');
  widmo.Parameters.Add('silencedetect=noise='+IntToStr(SpinEdit1.Value)+'dB:d='+FormatFloat('0.0',FloatSpinEdit1.Value,fs));
  widmo.Parameters.Add('-f');
  widmo.Parameters.Add('null');
  widmo.Parameters.Add('-');
  widmo.Execute;
  test1.Enabled:=true;
end;

procedure TFGenNapisow.BitBtn2Click(Sender: TObject);
begin
  if widmo.Running then widmo.Terminate(0);
end;

function wStrToTime(aStr: string): TTime; //00:00:00.000
var
  h,m,s,ms: word;
begin
  h:=StrToInt(copy(aStr,1,2));
  m:=StrToInt(copy(aStr,4,2));
  s:=StrToInt(copy(aStr,7,2));
  ms:=StrToInt(copy(aStr,10,3));
  result:=EncodeTime(h,m,s,ms);
end;

procedure TFGenNapisow.BitBtn3Click(Sender: TObject);
begin
  WczytajPlik(plik.FileName);
end;

procedure TFGenNapisow.BitBtn4Click(Sender: TObject);
begin
  ZapiszPlik;
end;

procedure TFGenNapisow.CheckBox1Change(Sender: TObject);
begin
  if CheckBox1.Checked then
    DBGridPlus1.Options:=[dgTitles,dgIndicator,dgColLines,dgRowLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit,dgMultiselect,dgDisableDelete,dgDisableInsert,dgDisplayMemoText]
  else
    DBGridPlus1.Options:=[dgTitles,dgIndicator,dgColLines,dgRowLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit,dgDisableDelete,dgDisableInsert,dgDisplayMemoText];
end;

procedure TFGenNapisow.DBMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  a: TPoint;
begin
  if Key=VK_RETURN then
  begin
    if ssShift in Shift then
    begin
      //DBMemo1.Text:=DBMemo1.Text+#10;
      //a:=DBMemo1.CaretPos;
      //a.Y:=a.Y+1;
      //DBMemo1.CaretPos:=a;
      //DBMemo1.Lines.Add('');
      Key:=VK_RETURN;
    end else begin
      Key:=0;
    end;
  end;
end;

procedure TFGenNapisow.FloatSpinEdit1Change(Sender: TObject);
begin
  if (FloatSpinEdit1.Value>0.19) and (FloatSpinEdit1.Value<0.21) then FloatSpinEdit1.Font.Color:=clBlack else FloatSpinEdit1.Font.Color:=clRed;
end;

procedure TFGenNapisow.FormCreate(Sender: TObject);
begin
  SetConfDir('PiStudio');
  propstorage.FileName:=MyConfDir('GenNapisow.xml');
  propstorage.Active:=true;
  mplayer_pause:=false;
  OpenDB;
  nowa_linia.b:=false;
end;

procedure TFGenNapisow.FormDestroy(Sender: TObject);
begin
  mplayer.Stop;
  CloseDB;
end;

procedure TFGenNapisow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssShift in Shift then
  begin
    case Key of
      VK_DOWN: begin linie.Next; play_record; end;
      VK_UP: begin linie.Prior; play_record; end;
    end;
  end else begin
    case Key of
      VK_F1: play_record;
      VK_F2: play_record(30);
      VK_F3: play_record(50);
      VK_F4: play_record(75);
      VK_F5: if mplayer.Running then if mplayer.Paused then mplayer.Replay else mplayer.Pause;
      VK_RETURN: begin linie.Next; play_record; end;
    end;
  end;
end;

procedure TFGenNapisow.MenuItem2Click(Sender: TObject);
var
  i: integer;
  t: TBookmark;
begin
  if linie.IsEmpty then exit;
  if CheckBox1.Checked then
  begin
    for i:=DBGridPlus1.SelectedRows.Count-1 downto 0 do
    begin
      t:=DBGridPlus1.SelectedRows.Items[i];
      linie.GotoBookmark(t);
      linie.Delete;
    end;
  end else linie.Delete;
  przelicz;
end;

procedure TFGenNapisow.MenuItem4Click(Sender: TObject);
var
  b: TBookMark;
  lp1,lp2: integer;
  t: TTime;
  s: string;
  ss: TStringList;
begin
  if linie.IsEmpty then exit;
  b:=linie.GetBookmark;
  lp1:=linie.FieldByName('lp').AsInteger;
  linie.Next;
  lp2:=linie.FieldByName('lp').AsInteger;
  if lp2=lp1+1 then
  begin
    t:=linie.FieldByName('t2').AsDateTime;
    s:=linie.FieldByName('text').AsString;
    linie.Delete;
    linie.GotoBookmark(b);
    linie.Edit;
    linie.FieldByName('t2').AsDateTime:=t;
    ss:=TStringList.Create;
    try
      ss.AddText(linie.FieldByName('text').AsString);
      ss.AddText(s);
      linie.FieldByName('text').AsString:=trim(ss.Text);
    finally
      ss.Free;
    end;
    linie.Post;
  end;
  przelicz;
end;

procedure TFGenNapisow.MenuItem6Click(Sender: TObject);
var
  lp: integer;
  s: string;
begin
  linie.DisableControls;
  lp:=linie.FieldByName('lp').AsInteger;
  linie.First;
  while not linie.EOF do
  begin
    s:=trim(linie.FieldByName('text').AsString);
    if s='' then linie.Delete else linie.Next;
  end;
  linie.First;
  linie.Locate('lp',lp,[]);
  linie.EnableControls;
  przelicz;
end;

procedure TFGenNapisow.MenuItem7Click(Sender: TObject);
var
  t: TBookMark;
  a1,a2: integer;
  n1,n2: TTime;
begin
  linie.DisableControls;
  t:=linie.GetBookmark;
  a2:=linie.FieldByName('lp').AsInteger;
  n2:=linie.FieldByName('t1').AsDateTime;
  linie.Prior;
  a1:=linie.FieldByName('lp').AsInteger;
  if a1=a2 then n1:=0 else n1:=linie.FieldByName('t2').AsDateTime;
  linie.GotoBookmark(t);
  linie.EnableControls;
  play_record(n1,n2);
  SpeedButton3.Enabled:=true;
  SpeedButton4.Enabled:=true;
end;

procedure TFGenNapisow.MenuItem9Click(Sender: TObject);
var
  t: TBookMark;
  a1,a2: integer;
  n1,n2: TTime;
begin
  linie.DisableControls;
  t:=linie.GetBookmark;
  a1:=linie.FieldByName('lp').AsInteger;
  n1:=linie.FieldByName('t2').AsDateTime;
  linie.Next;
  a2:=linie.FieldByName('lp').AsInteger;
  if a1=a2 then n2:=mplayer.Duration/1000 else n2:=linie.FieldByName('t1').AsDateTime;
  linie.GotoBookmark(t);
  linie.EnableControls;
  play_record(n1,n2);
  SpeedButton3.Enabled:=true;
  SpeedButton4.Enabled:=true;
end;

procedure TFGenNapisow.mplayerPlaying(ASender: TObject; APosition,
  ADuration: single);
begin
  if mplayer_pause then
  begin
    mplayer_pause:=false;
    mplayer.Pause;
  end;
  if mplayer.Playing and (mplayer_t2_pause>0) then
  begin
    if APosition>=mplayer_t2_pause then
    begin
      mplayer.Pause;
      if SpeedButton3.Enabled then
      begin
        SpeedButton3.Enabled:=false;
        SpeedButton4.Enabled:=false;
        if nowa_linia.b then
        begin
          nowa_linia.stop:=IntegerToTime(round(mplayer_t2_pause*1000));
          nowa_linia.b:=false;
          uELED2.Active:=false;
          wstaw_linie(nowa_linia.start,nowa_linia.stop);
        end;
      end;
    end;
  end;
end;

procedure TFGenNapisow.mplayerStop(Sender: TObject);
begin
  if SpeedButton3.Enabled then
  begin
    SpeedButton3.Enabled:=false;
    SpeedButton4.Enabled:=false;
    nowa_linia.b:=false;
    uELED2.Active:=false;
  end;
end;

procedure TFGenNapisow.plikChange(Sender: TObject);
begin
  srt:=RenameExt(plik.FileName,'srt');
  WczytajPlik(plik.FileName);
end;

procedure TFGenNapisow.SpeedButton10Click(Sender: TObject);
begin
  DBMemo1.Text:=DBMemo1.Text+'π';
end;

procedure TFGenNapisow.SpeedButton11Click(Sender: TObject);
var
  przerwa: integer;
  lp: integer;
  s1,s2: string;
  b1: boolean;
  a,b,c: integer;
begin
  if not mess.ShowConfirmationYesNo('Napisy oddalone od siebie w maximum podanym zakresie zostaną połączone.^^Kontynuować?') then exit;
  a:=0;
  b:=0;
  b1:=false;
  przerwa:=SpinEdit2.Value;
  linie.DisableControls;
  lp:=linie.FieldByName('lp').AsInteger;
  linie.First;

  while not linie.EOF do
  begin
    if b1 then
    begin
      (* pobieram początek czasu linii jako drugiej *)
      b:=TimeToInteger(linie.FieldByName('t1').AsDateTime);
      c:=TimeToInteger(linie.FieldByName('t2').AsDateTime);
      s2:=trim(linie.FieldByName('text').AsString);
      (* sprawdzam czy przerwa zawiera się w żądanych granicach *)
      if b-a<=przerwa then
      begin
        (* zawiera się - łączę napisy *)
        s1:=s1+#10+s2;
        linie.Prior;
        linie.Edit;
        linie.FieldByName('text').AsString:=s1;
        linie.FieldByName('t2').AsDateTime:=IntegerToTime(c);
        linie.Post;
        linie.Next;
        linie.Delete;
      end else begin
        (* nie zawiera się - pzechodzę do kolejnej linii *)
        s1:=s2;
        a:=TimeToInteger(linie.FieldByName('t2').AsDateTime);
        linie.Next;
      end;
    end else begin
      (* pierwszy rekord - pobieram tylko dane końca czasu *)
      s1:=trim(linie.FieldByName('text').AsString);
      a:=TimeToInteger(linie.FieldByName('t2').AsDateTime);
      b1:=true;
      linie.Next;
    end;
    //if s='' then linie.Delete else linie.Next;
  end;

  linie.First;
  linie.Locate('lp',lp,[]);
  linie.EnableControls;
  przelicz;
end;

procedure TFGenNapisow.SpeedButton1Click(Sender: TObject);
begin
  FloatSpinEdit1.Value:=0.2;
  SpinEdit1.Value:=-50;
end;

procedure TFGenNapisow.SpeedButton2Click(Sender: TObject);
begin
  linie.Last;
  while not linie.BOF do
  begin
    if trim(linie.FieldByName('text').AsString)<>'' then break;
    linie.Prior;
  end;
end;

procedure TFGenNapisow.SpeedButton3Click(Sender: TObject);
begin
  if nowa_linia.b then
  begin
    nowa_linia.stop:=IntegerToTime(round((mplayer.Position+FloatSpinEdit2.Value)*1000));
    nowa_linia.b:=false;
    wstaw_linie(nowa_linia.start,nowa_linia.stop);
  end else begin
    nowa_linia.b:=true;
    nowa_linia.start:=IntegerToTime(round((mplayer.Position+FloatSpinEdit2.Value)*1000));
  end;
  uELED2.Active:=nowa_linia.b;
end;

procedure TFGenNapisow.SpeedButton4Click(Sender: TObject);
begin
  mplayer.Pause;
  nowa_linia.b:=false;
  SpeedButton3.Enabled:=false;
  SpeedButton4.Enabled:=false;
  uELED2.Active:=false;
end;

procedure TFGenNapisow.MinusTime(Sender: TObject);
var
  a: integer;
begin
  case TDBDateTimePicker(Sender).Tag of
    1: a:=TimeToInteger(linie.FieldByName('t1').AsDateTime);
    2: a:=TimeToInteger(linie.FieldByName('t2').AsDateTime);
  end;
  case TDBDateTimePicker(Sender).Tag of
    1: linie.FieldByName('t1').AsDateTime:=IntegerToTime(a-100);
    2: linie.FieldByName('t2').AsDateTime:=IntegerToTime(a-100);
  end;
end;

procedure TFGenNapisow.PlusTime(Sender: TObject);
var
  a: integer;
begin
  case TDBDateTimePicker(Sender).Tag of
    1: a:=TimeToInteger(linie.FieldByName('t1').AsDateTime);
    2: a:=TimeToInteger(linie.FieldByName('t2').AsDateTime);
  end;
  case TDBDateTimePicker(Sender).Tag of
    1: linie.FieldByName('t1').AsDateTime:=IntegerToTime(a+100);
    2: linie.FieldByName('t2').AsDateTime:=IntegerToTime(a+100);
  end;
end;

procedure TFGenNapisow.SpeedButton9Click(Sender: TObject);
begin
  DBMemo1.Text:=DBMemo1.Text+'©';
end;

procedure TFGenNapisow.SpinEdit1Change(Sender: TObject);
begin
  if SpinEdit1.Value=-50 then SpinEdit1.Font.Color:=clBlack else SpinEdit1.Font.Color:=clRed;
end;

procedure TFGenNapisow.test1StartTimer(Sender: TObject);
begin
  linie.DisableControls;
  uELED1.Active:=true;
  BitBtn2.Enabled:=true;
end;

procedure TFGenNapisow.test1StopTimer(Sender: TObject);
begin
  linie.EnableControls;
  uELED1.Active:=false;
  BitBtn2.Enabled:=false;
end;

procedure TFGenNapisow.test1Timer(Sender: TObject);
begin
  if (not widmo.Running) or (widmo.ExitStatus=0) then
  begin
    test1.Enabled:=false;
    if widmo.Running then widmo.Terminate(0);
    //if ss.Count>0 then
    //begin
    //  ss.SaveToFile(srt);
    //  ss.Clear;
    //end;
  end;
end;

procedure TFGenNapisow.widmoReadData(Sender: TObject);
var
  i: integer;
  str: TStringList;
  s: string;
  a,b,c,d: integer;
  e: integer;
begin
  if widmo.Output.NumBytesAvailable>0 then
  begin
    str:=TStringList.Create;
    try
      str.LoadFromStream(widmo.Output);
      for i:=0 to str.Count-1 do
      begin
        s:=trim(str[i]);
        if s='' then continue;
        a:=pos('Duration:',s);
        b:=pos('frame=',s);
        c:=pos('silence_start:',s);
        d:=pos('silence_end:',s);
        if (a=0) and (b=0) and (c=0) and (d=0) then continue;
        try
          if a=1 then
          begin
            e:=1;
            postep.MaxValue:=StrDurationToTimeInteger(s);
            postep.Progress:=0;
          end else
          if b=1 then
          begin
            e:=2;
            postep.Progress:=StrFrameTimeToTimeInteger(s);
          end else
          if c>0 then
          begin
            e:=3;
            bb:=StrSilenceToTimeInteger(1,s);
            postep.Progress:=bb;
            dopisz;
          end else
          if d>0 then
          begin
            e:=4;
            aa:=StrSilenceToTimeInteger(2,s);
            postep.Progress:=aa;
          end;
        except
          on E: Exception do if CheckBox2.Checked then
          begin
            writeln('Wystąpił błąd w analizie tej linii:');
            writeln(s);
            writeln('Oto komunikat tego błędu:');
            writeln(E.Message);
            writeln('Przerywam.');
            widmo.Terminate(0);
          end;
        end;
      end;
    finally
      str.Free;
    end;
  end;
end;

procedure TFGenNapisow.OpenDB;
begin
end;

procedure TFGenNapisow.CloseDB;
begin
end;

procedure TFGenNapisow.linie_clear;
begin
  linie.DisableControls;
  linie.First;
  while not linie.IsEmpty do linie.Delete;
  linie.EnableControls;
end;

function TFGenNapisow.StrDurationToTimeInteger(aStr: string): longint;
var
  s,s1,s2,reszta: string;
  a: integer;
begin
  // ->   "Duration: 00:51:22.05, ..."
  s:=aStr;
  s1:=GetLineToStr(s,2,' '); //00:51:22.05,
  s1:=StringReplace(s1,',','',[]); //00:51:22.05
  a:=0;
  a:=StrToInt(GetLineToStr(s1,1,':'))*60*60*1000;
  a:=a+StrToInt(GetLineToStr(s1,2,':'))*60*1000;
  s2:=GetLineToStr(s1,3,':');
  a:=a+trunc(StrToD(s2,reszta)*1000);
  result:=a;
end;

function TFGenNapisow.StrFrameTimeToTimeInteger(aStr: string): longint;
var
  s,s1,s2,reszta: string;
  a: integer;
begin
  // ->   "frame= 5002 fps=764 q=-0.0 size=N/A time=00:02:46.73 bitrate=N/A speed=25.5x"
  s:=aStr;
  a:=pos('time=',s);
  delete(s,1,a+5-1);
  a:=pos(' ',s);
  delete(s,a,maxint);
  s1:=trim(s);
  a:=0;
  a:=StrToInt(GetLineToStr(s1,1,':'))*60*60*1000;
  a:=a+StrToInt(GetLineToStr(s1,2,':'))*60*1000;
  s2:=GetLineToStr(s1,3,':');
  a:=a+trunc(StrToD(s2,reszta)*1000);
  result:=a;
end;

function TFGenNapisow.StrSilenceToTimeInteger(start_end: integer; aStr: string
  ): longint;
var
  s,reszta: string;
begin
  //1 = "[silencedetect @ 0x5585f0969d00] silence_start: 41.401"
  //2 = "[silencedetect @ 0x5585f0969d00] silence_end: 42.5291 | silence_duration: 1.12819"
  s:=aStr;
  if start_end=1 then
  begin
    http.StrDeleteStart(s,'silence_start:');
    s:=trim(s);
    http.StrDeleteEnd(s,' ');
    s:=trim(s);
  end else begin
    http.StrDeleteStart(s,'silence_end:');
    s:=trim(s);
    http.StrDeleteEnd(s,'|');
    s:=trim(s);
  end;
  result:=round(StrToD(s,reszta)*1000);
end;

procedure TFGenNapisow.przelicz;
var
  t: tbookmark;
  a,l: integer;
begin
  t:=linie.GetBookmark;
  l:=1;
  linie.DisableControls;
  linie.First;
  while not linie.EOF do
  begin
    a:=linie.FieldByName('lp').AsInteger;
    if a<>l then
    begin
      linie.Edit;
      linie.FieldByName('lp').AsInteger:=l;
      linie.Post;
    end;
    linie.Next;
    inc(l);
  end;
  linie.GotoBookmark(t);
  linie.EnableControls;
end;

procedure TFGenNapisow.dopisz;
var
  a: integer;
  c1,c2: TTime;
begin
  a:=bb-aa;
  if a<400 then exit;
  inc(ll);
  if aa>100 then aa-=100;
  bb+=100;
  c1:=IntegerToTime(aa);
  c2:=IntegerToTime(bb);

  linie.Append;
  linie.FieldByName('lp').AsInteger:=ll;
  linie.FieldByName('t1').AsDateTime:=c1;
  linie.FieldByName('t2').AsDateTime:=c2;
  linie.Post;

  //ss.Add(IntToStr(ll));
  //ss.Add(FormatDateTime('HH:NN:SS,ZZZ',c1)+' --> '+FormatDateTime('HH:NN:SS,ZZZ',c2)); //czas: "00:00:00,000 --> 00:00:00,000"
  //ss.Add('');
  Label5.Caption:=IntToCString(ll,4);
end;

procedure TFGenNapisow.WczytajPlik(aFileName: string);
var
  ss: TStringList;
  tt: TStringList;
  i: integer;
  s,s1,s2,reszta: string;
  t1,t2: TTime;
  lp,a: integer;
begin
  (* video *)
  if mplayer.Running then mplayer.Stop;
  mplayer_pause:=true;
  mplayer.Filename:=aFileName;
  mplayer.Play;
  (* napisy *)
  linie_clear;
  if not FileExists(srt) then exit;
  if (dsLinie.State=dsEdit) or (dsLinie.State=dsInsert) then linie.Cancel;
  linie_clear;
  ss:=TStringList.Create;
  tt:=TStringList.Create;
  try
    ss.LoadFromFile(srt);
    linie.DisableControls;
    a:=1;
    for i:=0 to ss.Count-1 do
    begin
      s:=trim(ss[i]);
      if a=1 then
      begin
        tt.Clear;
        lp:=StrToL(s,reszta,0);
        inc(a);
      end else
      if a=2 then
      begin
        s1:=GetLineToStr(s,1,' ');
        s2:=GetLineToStr(s,3,' ');
        t1:=wStrToTime(s1);
        t2:=wStrToTime(s2);
        inc(a);
      end else begin
        if s='' then
        begin
          linie.Append;
          linie.FieldByName('lp').AsInteger:=lp;
          linie.FieldByName('t1').AsDateTime:=t1;
          linie.FieldByName('t2').AsDateTime:=t2;
          linie.FieldByName('text').AsString:=trim(tt.Text);
          linie.Post;
          a:=1;
        end else begin
          tt.Add(s);
        end;
      end;
    end;
    linie.First;
    linie.EnableControls;
  finally
    ss.Free;
    tt.Free;
  end;
end;

procedure TFGenNapisow.ZapiszPlik;
var
  ss: TStringList;
  f: TFileStream;
  lp: integer;
  c1,c2: TTime;
  s: string;
  t: TBookmark;
begin
  if (dsLinie.State=dsEdit) or (dsLinie.State=dsInsert) then linie.Post;
  ss:=TStringList.Create;
  try
    linie.DisableControls;
    t:=linie.GetBookmark;
    linie.First;
    while not linie.EOF do
    begin
      lp:=linie.FieldByName('lp').AsInteger;
      c1:=linie.FieldByName('t1').AsDateTime;
      c2:=linie.FieldByName('t2').AsDateTime;
      s:=trim(linie.FieldByName('text').AsString);
      ss.Add(IntToStr(lp));
      ss.Add(FormatDateTime('HH:NN:SS,ZZZ',c1)+' --> '+FormatDateTime('HH:NN:SS,ZZZ',c2)); //czas: "00:00:00,000 --> 00:00:00,000"
      if s<>'' then ss.Add(trim(s));
      ss.Add('');
      linie.Next;
    end;
    f:=TFileStream.Create(srt,fmCreate);
    try
      f.WriteByte($EF);
      f.WriteByte($BB);
      f.WriteByte($BF);
      ss.SaveToStream(f);
    finally
      f.Free;
    end;
    linie.GotoBookmark(t);
    linie.EnableControls;
  finally
    ss.Free;
  end;
end;

procedure TFGenNapisow.play_record(aStart, aStop: TTime);
begin
  mplayer_t2_pause:=TimeToInteger(aStop)/1000;
  mplayer.Position:=TimeToInteger(aStart)/1000;
  if mplayer.Running then
  begin
    if mplayer.Paused then mplayer.Replay;
  end else mplayer.Play;
  if linie.State=dsBrowse then linie.Edit;
  DBMemo1.SetFocus;
end;

procedure TFGenNapisow.play_record(aPercent: integer);
var
  t1,t2,len,x: TTime;
begin
  t1:=linie.FieldByName('t1').AsDateTime;
  t2:=linie.FieldByName('t2').AsDateTime;
  len:=t2-t1;
  x:=len*aPercent/100;
  play_record(t1+x,t2);
end;

function TFGenNapisow.wstaw_linie(aStart, aStop: TTime): integer;
var
  x: boolean;
  t: TBookmark;
  lp: integer;
  a,b: TTime;
  s: string;
begin
  t:=linie.GetBookmark;
  linie.DisableControls;
  linie.Last;
  lp:=linie.FieldByName('lp').AsInteger;
  a:=linie.FieldByName('t1').AsDateTime;
  b:=linie.FieldByName('t2').AsDateTime;
  s:=linie.FieldByName('text').AsString;

  linie.Append;
  linie.FieldByName('lp').AsInteger:=lp+1;
  linie.FieldByName('t1').AsDateTime:=a;
  linie.FieldByName('t2').AsDateTime:=b;
  linie.FieldByName('text').AsString:=s;
  linie.Post;
  linie.Prior;

  while not linie.BOF do
  begin
    linie.Prior;
    lp:=linie.FieldByName('lp').AsInteger;
    a:=linie.FieldByName('t1').AsDateTime;
    b:=linie.FieldByName('t2').AsDateTime;
    s:=linie.FieldByName('text').AsString;
    linie.Next;
    linie.Edit;
    linie.FieldByName('lp').AsInteger:=lp+1;
    linie.FieldByName('t1').AsDateTime:=a;
    linie.FieldByName('t2').AsDateTime:=b;
    linie.FieldByName('text').AsString:=s;
    linie.Post;
    linie.Prior;
    writeln('lp=',lp,', aStop=',FormatDateTime('hh:nn:ss.zzz',aStop),', a=',FormatDateTime('hh:nn:ss.zzz',a));
    if (lp=1) or (aStop>a) then break;
  end;
  if aStop>a then
  begin
    linie.Next;
    inc(lp);
  end;

  linie.Edit;
  linie.FieldByName('lp').AsInteger:=lp;
  linie.FieldByName('t1').AsDateTime:=aStart;
  linie.FieldByName('t2').AsDateTime:=aStop;
  linie.FieldByName('text').Clear;
  linie.Post;
  linie.EnableControls;
  result:=linie.FieldByName('lp').AsInteger;
end;

function TFGenNapisow.RenameExt(aFilename, aNewExt: string): string;
var
  s: string;
  i: integer;
begin
  s:=aFileName;
  for i:=length(s) downto 1 do
  begin
    if s[i]='.' then
    begin
      delete(s,i,maxint);
      s:=s+'.'+aNewExt;
      break;
    end else
    if s[i]=_FF then
    begin
      s:=s+'.'+aNewExt;
      break;
    end;
  end;
  result:=s;
end;

end.

