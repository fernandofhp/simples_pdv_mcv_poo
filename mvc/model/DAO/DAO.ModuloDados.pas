unit DAO.ModuloDados;

interface

uses
  SysUtils, Classes, WideStrings, DBXMySql, DB, SqlExpr, FMTBcd, MidasLib,
  DBXCommon;

type
  TDM = class(TDataModule)
    FConexao: TSQLConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    Trans: TTransactionDesc;

  public
    procedure TransStart;
    procedure TransCommit;
    procedure TransRollBack;
  published
    function Conexao: TSQLConnection;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

function TDM.Conexao: TSQLConnection;
begin
  // SINGLETON
  if (not Assigned(FConexao)) then
    FConexao := TSQLConnection.Create(Self);
  Result := FConexao;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  try
    with Conexao do
    begin
      Close;
      Open;
      Trans.IsolationLevel := xilREADCOMMITTED;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Conexão Falhou:' + sLineBreak + E.Message);
    end;
  end;

end;

procedure TDM.TransCommit;
begin
  Conexao.Commit(Trans);
end;

procedure TDM.TransRollBack;
begin
  Conexao.Rollback(Trans);
end;

procedure TDM.TransStart;
begin
  Conexao.StartTransaction(Trans);
end;

end.
