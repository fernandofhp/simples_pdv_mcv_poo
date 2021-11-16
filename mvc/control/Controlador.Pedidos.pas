unit Controlador.Pedidos;

interface

uses Model.Pedido, DAO.ModuloDados, SysUtils, DB, SqlExpr;

type
  TControladorPedido = class
  private
    procedure AtualizarTotal(Numero: Integer);
  public
    function Inserir(Pedido: TPedido): Integer;
    procedure CarregarDados(Numero: Integer; Pedido: TPedido);
    procedure Alterar(Pedido: TPedido);
    procedure Excluir(Numero: Integer);
  end;

implementation

{ TControladorPedido }

procedure TControladorPedido.Alterar(Pedido: TPedido);
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
      SQL.Add(' UPDATE PEDIDOS SET                ');
      SQL.Add('     DATAEMISSAO = :EMISSAO,       ');
      SQL.Add('     CODIGOCLIENTE = :CLIENTE,     ');
      SQL.Add('     VALORTOTAL = :TOTAL,          ');
      SQL.Add('     GRAVADO = :GRAVADO            ');
      SQL.Add(' WHERE                             ');
      SQL.Add('     (NUMERO = :NUMERO);           ');
      ParamByName('NUMERO').AsInteger := Pedido.Numero;
      ParamByName('EMISSAO').AsDateTime := Pedido.DataEmissao;
      ParamByName('CLIENTE').AsInteger := Pedido.CodigoCliente;
      ParamByName('TOTAL').AsCurrency := Pedido.ValorTotal;
      ParamByName('GRAVADO').AsInteger := Pedido.Gravado;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao Alterar o Pedido ' + IntToStr(Pedido.Numero);
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorPedido.AtualizarTotal(Numero: Integer);
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
      SQL.Add(' UPDATE PEDIDOS SET                            ');
      SQL.Add('     VALORTOTAL =                              ');
      SQL.Add('     (SELECT                                   ');
      SQL.Add('           SUM(QUANTIDADE * VALORUNITARIO)     ');
      SQL.Add('        FROM ITENS                             ');
      SQL.Add('           WHERE (NUMEROPEDIDO = :NUMERO)      ');
      SQL.Add('      )                                        ');
      SQL.Add(' WHERE                                         ');
      SQL.Add('     (NUMERO = :NUMERO);                       ');
      SQL.Add('  ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao Recalcular o Valor Total do Pedido [';
        msgERRO := msgERRO + IntToStr(Numero) + ']';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorPedido.CarregarDados(Numero: Integer; Pedido: TPedido);
var
  msgERRO: string;
  QRY: TSQLQuery;
begin
  // Recaldula total
  AtualizarTotal(Numero);
  // Carrega Dados
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT                            ');
      SQL.Add('     NUMERO,                       ');
      SQL.Add('     DATAEMISSAO,                  ');
      SQL.Add('     CODIGOCLIENTE,                ');
      SQL.Add('     VALORTOTAL,                   ');
      SQL.Add('     GRAVADO                       ');
      SQL.Add(' FROM                              ');
      SQL.Add('     PEDIDOS                       ');
      SQL.Add(' WHERE                             ');
      SQL.Add('   (NUMERO = :NUMERO);             ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Pedido.Numero := QRY.FieldByName('NUMERO').AsInteger;
      Pedido.DataEmissao := QRY.FieldByName('DATAEMISSAO').AsDateTime;
      Pedido.CodigoCliente := QRY.FieldByName('CODIGOCLIENTE').AsInteger;
      Pedido.ValorTotal := QRY.FieldByName('VALORTOTAL').AsCurrency;
      Pedido.Gravado := QRY.FieldByName('GRAVADO').AsInteger;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Pedido ' + IntToStr(Numero);
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorPedido.Excluir(Numero: Integer);
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
      SQL.Add(' DELETE FROM PEDIDOS ');
      SQL.Add(' WHERE  ');
      SQL.Add(' (NUMERO = :NUMERO); ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao Excluir Pedido ' + IntToStr(Numero);
        msgERRO := msgERRO + sLineBreak + E.Message;
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

function TControladorPedido.Inserir(Pedido: TPedido): Integer;
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
      SQL.Add(' INSERT INTO PEDIDOS (     ');
      SQL.Add('     DATAEMISSAO,          ');
      SQL.Add('     CODIGOCLIENTE,        ');
      SQL.Add('     VALORTOTAL            ');
      SQL.Add(' ) VALUES (                ');
      SQL.Add('     :DATAEMISSAO,         ');
      SQL.Add('     :CODIGOCLIENTE,       ');
      SQL.Add('     :VALORTOTAL           ');
      SQL.Add(' );                        ');
      ParamByName('DATAEMISSAO').AsDateTime := Pedido.DataEmissao;
      ParamByName('CODIGOCLIENTE').AsInteger := Pedido.CodigoCliente;
      ParamByName('VALORTOTAL').AsCurrency := Pedido.ValorTotal;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
      with QRY do
      begin
        SQL.Clear;
        SQL.Add(' SELECT MAX(NUMERO) AS NOVOID FROM PEDIDOS;  ');
        Open;
        Pedido.Numero := FieldByName('NOVOID').AsInteger;
      end;
    except
      on E: Exception do
      begin
        Pedido.Numero := -1;
        DM.TransRollBack;
        msgERRO := 'Falha ao Inserir o Pedido';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

end.
