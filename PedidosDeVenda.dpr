program PedidosDeVenda;

uses
  Forms,
  uFrmPrincipal in 'mvc\view\uFrmPrincipal.pas' {FrmPrincipal},
  DAO.ModuloDados in 'mvc\model\DAO\DAO.ModuloDados.pas' {DM: TDataModule},
  Model.Cliente in 'mvc\model\Model.Cliente.pas',
  Model.Produto in 'mvc\model\Model.Produto.pas',
  Controlador.Clientes in 'mvc\control\Controlador.Clientes.pas',
  Model.Pedido in 'mvc\model\Model.Pedido.pas',
  Model.Item in 'mvc\model\Model.Item.pas',
  DBXMySQL in 'mvc\model\DAO\DBXMySQL.pas',
  Controlador.Produtos in 'mvc\control\Controlador.Produtos.pas',
  Controlador.Pedidos in 'mvc\control\Controlador.Pedidos.pas',
  Controlador.Itens in 'mvc\control\Controlador.Itens.pas',
  uFrmPedidosVendas in 'mvc\view\uFrmPedidosVendas.pas' {FrmPedidoVendas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Controle de Vendas';
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
