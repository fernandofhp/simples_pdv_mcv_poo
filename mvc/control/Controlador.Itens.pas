unit Controlador.Itens;

interface

uses Model.Item, Model.Pedido, DAO.ModuloDados, SysUtils, DB, SqlExpr, DBClient;

type
  TControladorItens = class
  public
    function Inserir(Item: TItem): Integer;
    procedure CarregarDados(Numero: Integer; Item: TItem);
    procedure Alterar(Item: TItem);
    procedure Excluir(Numero: Integer);
    procedure Listar(NumeroPedido: Integer; CD: TClientDataSet);
  end;

implementation

uses Classes, Controlador.Pedidos;

{ TControladorItens }

procedure TControladorItens.Alterar(Item: TItem);
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
      SQL.Add(' UPDATE ITENS SET                      ');
      SQL.Add('     NUMEROPEDIDO = :PEDIDO,           ');
      SQL.Add('     CODIGOPRODUTO = :PRODUTO,         ');
      SQL.Add('     QUANTIDADE = :QUANTIDADE,         ');
      SQL.Add('     VALORUNITARIO = :UNITARIO,        ');
      SQL.Add('     VALORTOTALITEM = :TOTAL           ');
      SQL.Add(' WHERE                                 ');
      SQL.Add('     (NUMEROITEM = :NUMERO);           ');
      ParamByName('NUMERO').AsInteger := Item.Numero;
      ParamByName('PEDIDO').AsInteger := Item.NumeroPedido;
      ParamByName('PRODUTO').AsInteger := Item.CodigoProduto;
      ParamByName('QUANTIDADE').AsCurrency := Item.Quantidade;
      ParamByName('UNITARIO').AsCurrency := Item.ValorUnitario;
      ParamByName('TOTAL').Value := Item.ValorTotalItem;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
    except
      on E: Exception do
      begin
        DM.TransRollBack;
        msgERRO := 'Falha ao Alterar o Item ' + IntToStr(Item.Numero);
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorItens.CarregarDados(Numero: Integer; Item: TItem);
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
      SQL.Add('     NUMEROITEM AS NUMERO,         ');
      SQL.Add('     NUMEROPEDIDO,                 ');
      SQL.Add('     CODIGOPRODUTO,                ');
      SQL.Add('     QUANTIDADE,                   ');
      SQL.Add('     VALORUNITARIO,                ');
      SQL.Add('     VALORTOTALITEM                ');
      SQL.Add(' FROM                              ');
      SQL.Add('     ITENS                         ');
      SQL.Add(' WHERE                             ');
      SQL.Add('   (NUMEROITEM = :NUMERO);         ');
      ParamByName('NUMERO').AsInteger := Numero;
    end;
    try
      DM.TransStart;
      DM.TransCommit;
      QRY.Open;
      Item.Numero := QRY.FieldByName('NUMERO').AsInteger;
      Item.NumeroPedido := QRY.FieldByName('NUMEROPEDIDO').AsInteger;
      Item.CodigoProduto := QRY.FieldByName('CODIGOPRODUTO').AsInteger;
      Item.Quantidade := QRY.FieldByName('QUANTIDADE').AsFloat;
      Item.ValorUnitario := QRY.FieldByName('VALORUNITARIO').AsCurrency;
      Item.ValorTotalItem := QRY.FieldByName('VALORTOTALITEM').AsCurrency;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Carregar Dados do Item (produto) do Pedido ';
        msgERRO := msgERRO + IntToStr(Numero) + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

procedure TControladorItens.Excluir(Numero: Integer);
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
      SQL.Add(' DELETE FROM                 ');
      SQL.Add('     ITENS                   ');
      SQL.Add(' WHERE                       ');
      SQL.Add('     (NUMEROITEM = :NUMERO); ');
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
        msgERRO := 'Falha ao Excluir o Item';
        msgERRO := msgERRO + sLineBreak + E.Message;
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
end;

function TControladorItens.Inserir(Item: TItem): Integer;
var
  msgERRO: string;
  QRY: TSQLQuery;
  Pedido: TPedido;
  MotorPed: TControladorPedido;
  TotalPedido: Currency;
begin
  QRY := TSQLQuery.Create(nil);
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' INSERT INTO ITENS (       ');
      SQL.Add('     NUMEROPEDIDO,         ');
      SQL.Add('     CODIGOPRODUTO,        ');
      SQL.Add('     QUANTIDADE,           ');
      SQL.Add('     VALORUNITARIO,        ');
      SQL.Add('     VALORTOTALITEM        ');
      SQL.Add(' ) VALUES (                ');
      SQL.Add('     :NUMEROPEDIDO,        ');
      SQL.Add('     :CODIGOPRODUTO,       ');
      SQL.Add('     :QUANTIDADE,          ');
      SQL.Add('     :VALORUNITARIO,       ');
      SQL.Add('     :VALORTOTAL           ');
      SQL.Add(' );                        ');
      ParamByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
      ParamByName('CODIGOPRODUTO').AsInteger := Item.CodigoProduto;
      ParamByName('QUANTIDADE').AsFloat := Item.Quantidade;
      ParamByName('VALORUNITARIO').AsCurrency := Item.ValorUnitario;
      ParamByName('VALORTOTAL').AsCurrency := Item.ValorTotalItem;
    end;
    try
      DM.TransStart;
      QRY.ExecSQL(False);
      DM.TransCommit;
      with QRY do
      begin
        SQL.Clear;
        SQL.Add(' SELECT MAX(NUMEROITEM) AS NOVOID FROM ITENS;  ');
        Open;
        Item.Numero := FieldByName('NOVOID').AsInteger;
      end;
    except
      on E: Exception do
      begin
        Item.Numero := -1;
        DM.TransRollBack;
        msgERRO := 'Falha ao Adicionar Item ao Carrinho/Pedido';
        msgERRO := msgERRO + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
  end;
  Result := Item.Numero;
end;

procedure TControladorItens.Listar(NumeroPedido: Integer; CD: TClientDataSet);
var
  msgERRO, Descricao: string;
  QRY: TSQLQuery;
  Item: TItem;
  i: Integer;
begin
  QRY := TSQLQuery.Create(nil);
  Item := TItem.Create;
  try
    with QRY do
    begin
      SQLConnection := DM.Conexao;
      Close;
      SQL.Clear;
      SQL.Add(' SELECT                              ');
      SQL.Add('     I.NUMEROITEM AS NUMERO,         ');
      SQL.Add('     I.NUMEROPEDIDO,                 ');
      SQL.Add('     I.CODIGOPRODUTO,                ');
      SQL.Add('     P.DESCRICAO,                    ');
      SQL.Add('     I.QUANTIDADE,                   ');
      SQL.Add('     I.VALORUNITARIO,                ');
      SQL.Add('     I.VALORTOTALITEM                ');
      // SQL.Add('     (SELECT                         ');
      // SQL.Add(',SUM(X.VALORUNITARIO * X.QUANTIDADE) ');
      // SQL.Add(' FROM ITENS X                        ');
      // SQL.Add(' WHERE I.NUMEROPEDIDO = 3)           ');
      // SQL.Add('     AS VALORTOTALPEDIDO             ');
      SQL.Add(' FROM                                ');
      SQL.Add('     ITENS I                         ');
      SQL.Add(' INNER JOIN PRODUTOS P               ');
      SQL.Add('     ON (I.CODIGOPRODUTO = P.CODIGO) ');
      SQL.Add(' WHERE                               ');
      SQL.Add('   (I.NUMEROPEDIDO = :PEDIDO);       ');
      ParamByName('PEDIDO').AsInteger := NumeroPedido;
    end;
    try
      QRY.Open;
      // QRY.Last;
      // QRY.First;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Consultar Listagem de Itens do Pedido ';
        msgERRO := msgERRO + IntToStr(NumeroPedido) + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
    try
      QRY.DisableControls;
      CD.Close;
      CD.FieldDefs.Clear;
      { | } CD.FieldDefs.Add('NUMERO', ftInteger);
      { | } CD.FieldDefs.Add('ITEMSEQ', ftInteger);
      { | } CD.FieldDefs.Add('NUMEROPEDIDO', ftInteger);
      { | } CD.FieldDefs.Add('CODIGOPRODUTO', ftInteger);
      { | } CD.FieldDefs.Add('DESCRICAO', ftString, 50);
      { | } CD.FieldDefs.Add('QUANTIDADE', ftFloat);
      { | } CD.FieldDefs.Add('VALORUNITARIO', ftCurrency);
      { | } CD.FieldDefs.Add('VALORTOTALITEM', ftCurrency);
      CD.CreateDataSet;
      CD.FieldByName('NUMERO').Visible := False; // taRightJustify, taCenter
      CD.FieldByName('NUMERO').Alignment := taCenter;
      CD.FieldByName('NUMEROPEDIDO').Visible := False;
      CD.FieldByName('ITEMSEQ').DisplayLabel := 'Item '#13'Nº';
      CD.FieldByName('ITEMSEQ').DisplayWidth := 3;
      CD.FieldByName('ITEMSEQ').Alignment := taCenter;
      CD.FieldByName('CODIGOPRODUTO').DisplayLabel := 'Código '#13'Produto';
      CD.FieldByName('CODIGOPRODUTO').DisplayWidth := 3;
      CD.FieldByName('CODIGOPRODUTO').Alignment := taCenter;
      CD.FieldByName('DESCRICAO').DisplayLabel := 'Descrição do Produto';
      CD.FieldByName('DESCRICAO').DisplayWidth := 30;
      CD.FieldByName('QUANTIDADE').DisplayLabel := 'Qtde';
      CD.FieldByName('QUANTIDADE').Alignment := taRightJustify;
      TFloatField(CD.FieldByName('QUANTIDADE')).EditMask := '#,###.00';
      CD.FieldByName('VALORUNITARIO').DisplayLabel := 'Vlr. Unitário';
      CD.FieldByName('VALORUNITARIO').Alignment := taRightJustify;
      CD.FieldByName('VALORTOTALITEM').DisplayLabel := 'Total do Item';
      CD.FieldByName('VALORTOTALITEM').Alignment := taRightJustify;

      i := 1;
      while (not QRY.Eof) do
      begin
        Item.Numero := QRY.FieldByName('NUMERO').AsInteger;
        Item.NumeroPedido := QRY.FieldByName('NUMEROPEDIDO').AsInteger;
        Item.CodigoProduto := QRY.FieldByName('CODIGOPRODUTO').AsInteger;
        Descricao := QRY.FieldByName('DESCRICAO').AsString;
        Item.Quantidade := QRY.FieldByName('QUANTIDADE').AsFloat;
        Item.ValorUnitario := QRY.FieldByName('VALORUNITARIO').AsCurrency;
        Item.ValorTotalItem := QRY.FieldByName('VALORTOTALITEM').AsCurrency;
        CD.Append;
        { } CD.FieldByName('NUMERO').AsInteger := Item.Numero;
        { } CD.FieldByName('NUMEROPEDIDO').AsInteger := Item.NumeroPedido;
        { } CD.FieldByName('ITEMSEQ').AsInteger := i;
        { } CD.FieldByName('CODIGOPRODUTO').AsInteger := Item.CodigoProduto;
        { } CD.FieldByName('DESCRICAO').AsString := Descricao;
        { } CD.FieldByName('QUANTIDADE').AsFloat := Item.Quantidade;
        { } CD.FieldByName('VALORUNITARIO').AsCurrency := Item.ValorUnitario;
        { } CD.FieldByName('VALORTOTALITEM').AsCurrency := Item.ValorTotalItem;
        CD.Post;
        Inc(i);        QRY.Next;
      end;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Crarregar Itens do Pedido na Tela ';
        msgERRO := msgERRO + IntToStr(NumeroPedido) + sLineBreak + E.Message;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(QRY);
    FreeAndNil(Item);
  end;
end;

end.
