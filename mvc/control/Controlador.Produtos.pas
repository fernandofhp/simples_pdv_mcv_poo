unit Controlador.Produtos;

interface

uses Model.Produto, DAO.ModuloDados, SysUtils, DB, SqlExpr;

type
  TControladorProduto = class
  public
    function Inserir(Produto: TProduto): Integer;
    procedure CarregarDados(Codigo: Integer; Produto: TProduto); overload;
    procedure CarregarDados(Descr: string; Produto: TProduto); overload;
    procedure LimparTudo();
  end;

implementation

{ TConroladorProduto }

procedure TControladorProduto.CarregarDados(Codigo: Integer; Produto: TProduto);
var
  msgERRO: string;
  QRY: TSQLQuery;
begin
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT                            ');
      SQL.Add('     CODIGO,                       ');
      SQL.Add('     DESCRICAO,                    ');
      SQL.Add('     PRECOVENDA                    ');
      SQL.Add(' FROM                              ');
      SQL.Add('     PRODUTOS                      ');
      SQL.Add(' WHERE                             ');
      SQL.Add('   (CODIGO = :CODIGO);             ');
      ParamByName('CODIGO').AsInteger := Codigo;
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Produto.Codigo := QRY.FieldByName('CODIGO').AsInteger;
      Produto.Descricao := QRY.FieldByName('DESCRICAO').AsString;
      Produto.PrecoVenda := QRY.FieldByName('PRECOVENDA').AsCurrency;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Produto ' + IntToStr(Codigo);
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorProduto.CarregarDados(Descr: string; Produto: TProduto);
var
  msgERRO: string;
  QRY: TSQLQuery;
begin
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      // DM.Conexao.Commit();
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT                            ');
      SQL.Add('     CODIGO,                       ');
      SQL.Add('     DESCRICAO,                    ');
      SQL.Add('     PRECOVENDA                    ');
      SQL.Add(' FROM                              ');
      SQL.Add('     PRODUTOS                      ');
      SQL.Add(' WHERE                             ');
      SQL.Add('   (DESCRICAO LIKE :DESCRICAO);    ');
      ParamByName('DESCRICAO').AsString := '%' + Descr + '%';
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Produto.Codigo := QRY.FieldByName('CODIGO').AsInteger;
      Produto.Descricao := QRY.FieldByName('DESCRICAO').AsString;
      Produto.PrecoVenda := QRY.FieldByName('PRECOVENDA').AsCurrency;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Produto ' + Descr;
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

function TControladorProduto.Inserir(Produto: TProduto): Integer;
var
  msgERRO: string;
  QRY: TSQLQuery;
begin
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' INSERT INTO PRODUTOS (  ');
      SQL.Add('     DESCRICAO,          ');
      SQL.Add('     PRECOVENDA          ');
      SQL.Add(' ) VALUES (              ');
      SQL.Add('     :DESCRICAO,         ');
      SQL.Add('     :PRECOVENDA         ');
      SQL.Add(' );                      ');
      ParamByName('DESCRICAO').AsString := Produto.Descricao;
      ParamByName('PRECOVENDA').AsCurrency := Produto.PrecoVenda;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
      with QRY do
      begin
        SQL.Clear;
        SQL.Add(' SELECT MAX(CODIGO) AS NOVOID FROM PRODUTOS;  ');
        Open;
        Produto.Codigo := FieldByName('NOVOID').AsInteger;
      end;
    except
      on E: Exception do
      begin
        Produto.Codigo := -1;
        DM.TransRollBack;
        msgERRO := 'Falha ao Inserir Produto';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
  Result := Produto.Codigo;
end;

procedure TControladorProduto.LimparTudo;
var
  msgERRO: string;
  QRY: TSQLQuery;
begin
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' DELETE FROM PRODUTOS; ');
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);

      QRY.SQL.Clear;
      QRY.SQL.Add(' ALTER TABLE PRODUTOS AUTO_INCREMENT = 1; ');
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao excluir todos os Produtos: ';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

end.
