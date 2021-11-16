unit Model.Item;

interface

type
  TItem = class
  private
    FValorTotalItem: Currency;
    FCodigoProduto: Integer;
    FValorUnitario: Currency;
    FNumero: Integer;
    FQuantidade: Single;
    FNumeroPedido: Integer;
    procedure SetCodigoProduto(const Value: Integer);
    procedure SetNumero(const Value: Integer);
    procedure SetNumeroPedido(const Value: Integer);
    procedure SetQuantidade(const Value: Single);
    procedure SetValorTotalItem(const Value: Currency);
    procedure SetValorUnitario(const Value: Currency);
  published
  public
    property Numero: Integer read FNumero write SetNumero;
    property NumeroPedido: Integer read FNumeroPedido write SetNumeroPedido;
    property CodigoProduto: Integer read FCodigoProduto write SetCodigoProduto;
    property Quantidade: Single read FQuantidade write SetQuantidade;
    property ValorUnitario: Currency read FValorUnitario write SetValorUnitario;
    property ValorTotalItem
      : Currency read FValorTotalItem write SetValorTotalItem;
  end;

implementation

{ TItem }

procedure TItem.SetCodigoProduto(const Value: Integer);
begin
  FCodigoProduto := Value;
end;

procedure TItem.SetNumero(const Value: Integer);
begin
  FNumero := Value;
end;

procedure TItem.SetNumeroPedido(const Value: Integer);
begin
  FNumeroPedido := Value;
end;

procedure TItem.SetQuantidade(const Value: Single);
begin
  FQuantidade := Value;
end;

procedure TItem.SetValorTotalItem(const Value: Currency);
begin
  //FValorTotalItem := Value;
  FValorTotalItem := FValorUnitario * FQuantidade
end;

procedure TItem.SetValorUnitario(const Value: Currency);
begin
  FValorUnitario := Value;
end;

end.
