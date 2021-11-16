unit Controlador.Clientes;

interface

uses Model.Cliente, DAO.ModuloDados, SysUtils, DB, SqlExpr;

type
  TControladorCliente = class
  private

  public
    function Inserir(Cliente: TCliente): Integer;
    procedure CarregarDados(Codigo: Integer; Cliente: TCliente); overload;
    procedure CarregarDados(Nome: string; Cliente: TCliente); overload;
    procedure LimparTudo();
  end;

implementation

{ TcontroladorCliente }

procedure TControladorCliente.CarregarDados(Codigo: Integer; Cliente: TCliente);
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
      SQL.Add(' SELECT                  ');
      SQL.Add('     CODIGO,             ');
      SQL.Add('     NOME,               ');
      SQL.Add('     CIDADE,             ');
      SQL.Add('     UF                  ');
      SQL.Add(' FROM                    ');
      SQL.Add('     CLIENTES            ');
      SQL.Add(' WHERE                   ');
      SQL.Add('   (CODIGO = :CODIGO);   ');
      ParamByName('CODIGO').AsInteger := Codigo;
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Cliente.Codigo := QRY.FieldByName('CODIGO').AsInteger;;
      Cliente.Nome := QRY.FieldByName('NOME').AsString;
      Cliente.Cidade := QRY.FieldByName('CIDADE').AsString;
      Cliente.UF := QRY.FieldByName('UF').AsString;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Cliente ' + IntToStr(Codigo);
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorCliente.CarregarDados(Nome: string; Cliente: TCliente);
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
      SQL.Add(' SELECT                  ');
      SQL.Add('     CODIGO,             ');
      SQL.Add('     NOME,               ');
      SQL.Add('     CIDADE,             ');
      SQL.Add('     UF                  ');
      SQL.Add(' FROM                    ');
      SQL.Add('     CLIENTES            ');
      SQL.Add(' WHERE                   ');
      SQL.Add('   (NOME LIKE :NOME);    ');
      ParamByName('NOME').AsString := '%' + Nome + '%';
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Cliente.Codigo := QRY.FieldByName('CODIGO').AsInteger;
      Cliente.Nome := QRY.FieldByName('NOME').AsString;
      Cliente.Cidade := QRY.FieldByName('CIDADE').AsString;
      Cliente.UF := QRY.FieldByName('UF').AsString;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Cliente ' + Nome;
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

function TControladorCliente.Inserir(Cliente: TCliente): Integer;
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
      SQL.Add(' INSERT INTO CLIENTES (  ');
      SQL.Add('     NOME,               ');
      SQL.Add('     CIDADE,             ');
      SQL.Add('     UF                  ');
      SQL.Add(' ) VALUES (              ');
      SQL.Add('     :NOME,              ');
      SQL.Add('     :CIDADE,            ');
      SQL.Add('     :UF                 ');
      SQL.Add(' );                      ');
      ParamByName('NOME').AsString := Cliente.Nome;
      ParamByName('CIDADE').AsString := Cliente.Cidade;
      ParamByName('UF').AsString := Cliente.UF;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
      with QRY do
      begin
        SQL.Clear;
        SQL.Add(' SELECT MAX(CODIGO) AS NOVOID FROM CLIENTES;  ');
        Open;
        Cliente.Codigo := FieldByName('NOVOID').AsInteger;
      end;
    except
      on E: Exception do
      begin
        Cliente.Codigo := -1;
        DM.TransRollBack;
        msgERRO := 'Falha ao Inserir Cliente';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
  Result := Cliente.Codigo;
end;

procedure TControladorCliente.LimparTudo;
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
      SQL.Add(' DELETE FROM CLIENTES; ');
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);

      QRY.SQL.Clear;
      QRY.SQL.Add(' ALTER TABLE CLIENTES AUTO_INCREMENT = 1; ');
      QRY.ExecSQL(False);
      // por cascata ...
      QRY.SQL.Clear;
      QRY.SQL.Add(' ALTER TABLE PEDIDOS AUTO_INCREMENT = 1; ');
      QRY.ExecSQL(False);
      // ...
      QRY.SQL.Clear;
      QRY.SQL.Add(' ALTER TABLE ITENS AUTO_INCREMENT = 1; ');
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao excluir todos os Clientes: ';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

end.
