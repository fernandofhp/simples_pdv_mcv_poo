unit Model.Pedido;

interface

type
  TPedido = class
  private
    FNumero: Integer;
    FValorTotal: Currency;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FGravado: Integer;
    procedure SetCodigoCliente(const Value: Integer);
    procedure SetDataEmissao(const Value: TDateTime);
    procedure SetNumero(const Value: Integer);
    procedure SetValorTotal(const Value: Currency);
    procedure SetGravado(const Value: Integer);

  public
    property Numero: Integer read FNumero write SetNumero;
    property DataEmissao: TDateTime read FDataEmissao write SetDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write SetCodigoCliente;
    property ValorTotal: Currency read FValorTotal write SetValorTotal;
    property Gravado: Integer read FGravado write SetGravado;
  end;

implementation

{ TPedido }

procedure TPedido.SetCodigoCliente(const Value: Integer);
begin
  FCodigoCliente := Value;
end;

procedure TPedido.SetDataEmissao(const Value: TDateTime);
begin
  FDataEmissao := Value;
end;

procedure TPedido.SetGravado(const Value: Integer);
begin
  FGravado := Value;
end;

procedure TPedido.SetNumero(const Value: Integer);
begin
  FNumero := Value;
end;

procedure TPedido.SetValorTotal(const Value: Currency);
begin
  FValorTotal := Value;
end;

end.
