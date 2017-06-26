unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, UTF8Process, LR_DBSet,
  LR_Class, fphttpclient, Graphics, Dialogs, DBGrids, DbCtrls, StdCtrls,
  LCLProc, LazHelpHTML, LR_DSet;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DataSource1: TDataSource;
    Dbf1: TDbf;
    Dbf1BASE: TStringField;
    Dbf1COD: TStringField;
    Dbf1CODLOTA: TStringField;
    Dbf1DIFERENCA: TFloatField;
    Dbf1DTENT: TDateField;
    Dbf1DTNASC: TDateField;
    Dbf1EXONERADO: TStringField;
    Dbf1FF: TStringField;
    Dbf1FORA: TFloatField;
    Dbf1INSSANT: TFloatField;
    Dbf1INSSATU: TFloatField;
    Dbf1ISENTO: TStringField;
    Dbf1LOTACAO: TStringField;
    Dbf1MATR: TStringField;
    Dbf1MVINC: TStringField;
    Dbf1NOME: TStringField;
    Dbf1PASEP: TStringField;
    Dbf1REFER: TStringField;
    Dbf1TOTAL1: TFloatField;
    Dbf1VALOR: TFloatField;
    Dbf1VLRFALTA: TFloatField;
    Dbf1VLRFERANT: TFloatField;
    Dbf1VLRSALFAM: TFloatField;
    Dbf1VLRSALMAT: TFloatField;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    frase: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.DataSource1DataChange(Sender: TObject; Field: TField);
begin

end;

procedure TForm1.frDBDataSet1CheckEOF(Sender: TObject; var Eof: Boolean);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  v: THTMLBrowserHelpViewer;
  BrowserPath, BrowserParams: string;
  p: LongInt;
  URL: String;
  BrowserProcess: TProcessUTF8;
begin
//  v:=THTMLBrowserHelpViewer.Create(nil);
  try
    v:=THTMLBrowserHelpViewer.Create(nil);
    v.FindDefaultBrowser(BrowserPath,BrowserParams);
    URL:='http://www.lazarus.freepascal.org';
    p:=System.Pos('%s', BrowserParams);
    System.Delete(BrowserParams,p,2);
    System.Insert(URL,BrowserParams,p);
    // start browser
 //   BrowserProcess:=TProcessUTF8.Create(nil);
    try
      BrowserProcess:=TProcessUTF8.Create(nil);
      BrowserProcess.CommandLine:=BrowserPath+' '+BrowserParams;
      BrowserProcess.Execute;
    finally
      BrowserProcess.Free;
    end;
  finally
    v.Free;
  end;
  Memo1.Clear;
  Memo1.Lines.Add(BrowserPath);
  Memo1.Lines.Add(BrowserParams);
//  v.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  resposta : TStringlist;
begin
  try
    resposta := TStringlist.create;
    try
      With TFPHTTPClient.create(nil) do
      Begin
       Get('http://www.seusite.com.br/acao.php?nome=Leones&senha=12345678', Resposta );
       Free;
      end;
    finally
      free;
    end;
    showmessage(resposta.text);
  finally
    resposta.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//  Dbf1.Open;
  Dbf1.First;
  Memo1.Clear;
  while not dbf1.eof do
  begin
     Memo1.Lines.Add(AnsiUpperCase(Dbf1.FieldByName('NOME').AsString));
     Memo1.Lines.Add(AnsiLowerCase(Dbf1.FieldByName('NOME').AsString));
     Dbf1.Next;
  end;
end;

end.

