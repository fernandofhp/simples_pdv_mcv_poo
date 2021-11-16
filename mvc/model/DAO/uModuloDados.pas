unit uModuloDados;

interface

uses
  SysUtils, Classes, WideStrings, DBXMySql, DB, SqlExpr;

type
  TDataModule1 = class(TDataModule)
    Conexao: TSQLConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  try
    with Conexao do
    begin
      Params.Values['HostName'] := 'localhost';
      Params.Values['Server Port'] := '3306';
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Conexão Falhou:' + sLineBreak + e.Message);
    end;
  end;

end;

end.
