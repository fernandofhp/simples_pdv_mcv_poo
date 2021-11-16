unit Model.Produto;

interface

type
  TProduto = class
  private
    FDescricao: string;
    FCodigo: Integer;
    FPrecoVenda: Currency;
    procedure SetCodigo(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetPrecoVenda(const Value: Currency);
  published
  public
    property Codigo: Integer read FCodigo write SetCodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property PrecoVenda: Currency read FPrecoVenda write SetPrecoVenda;
  end;

implementation

{ TProduto }

procedure TProduto.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TProduto.SetPrecoVenda(const Value: Currency);
begin
  FPrecoVenda := Value;
end;

end.
