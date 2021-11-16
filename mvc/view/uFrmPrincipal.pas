unit uFrmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, dxGDIPlusClasses, MidasLib, ComCtrls;

type
  TFrmPrincipal = class(TForm)
    Panel1: TPanel;
    btnPedidosVendas: TBitBtn;
    btSemearProdutos: TBitBtn;
    imgLogo: TImage;
    pnRodape: TPanel;
    btnFechar: TBitBtn;
    Shape1: TShape;
    btnSemearClientes: TBitBtn;
    ProgBarra: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSemearClientesClick(Sender: TObject);
    procedure btSemearProdutosClick(Sender: TObject);
    procedure btnPedidosVendasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses Model.Cliente, Model.Produto, Controlador.Clientes, Controlador.Produtos,
  uFrmPedidosVendas;
{$R *.dfm}

procedure TFrmPrincipal.btnFecharClick(Sender: TObject);
begin
  if (fsModal in FormState) then
  begin
    ModalResult := mrClose;
  end
  else
  begin
    Close;
  end;
end;

procedure TFrmPrincipal.btnPedidosVendasClick(Sender: TObject);
var
  Form: TFrmPedidoVendas;
begin
  Form := TFrmPedidoVendas.Create(nil);
  try
    if (Form.ShowModal = mrOk) then
    begin
      Beep;
    end;
  finally
    FreeAndNil(Form);
  end;
end;

procedure TFrmPrincipal.btnSemearClientesClick(Sender: TObject);
var
  Msg: string;
  Motor: TControladorCliente;
  Cliente: TCliente;
begin
  Msg := 'Tem certeza que quer limpar e ' + sLineBreak + 'Semear 20 Clientes?';
  if (MessageDlg(Msg, mtConfirmation, mbYesNo, 0) = IDYES) then
  begin
    Motor := TControladorCliente.Create;
    Cliente := TCliente.Create;
    ProgBarra.Position := 1;
    try
      // Limpar todos os clientes
      Motor.LimparTudo;
      // Semear 20 registros
      with Cliente do
      begin
        Nome := 'Cliente Padrao';
        Cidade := 'Rio Claro';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Ana Catarina';
        Cidade := 'Sao Carlos';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Juliano Enrico "Irmaodo Jorel"';
        Cidade := 'Araraquara';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Nicolau Henrico "Nico"';
        Cidade := 'Capetinga';
        UF := 'MG';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Giovana "Gigi"';
        Cidade := 'Rio de Janeiro';
        UF := 'RJ';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Juliana "Juju"';
        Cidade := 'Santos';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Lara Tomiko';
        Cidade := 'Aracatu';
        UF := 'BA';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Jhonny Bravo';
        Cidade := 'Parintins';
        UF := 'AM';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Billy ';
        Cidade := 'EndsVile';
        UF := 'MS';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Mandy';
        Cidade := 'Rio Claro';
        UF := 'SP';
        Motor.Inserir(Cliente);
        // --
        Nome := 'Grim Reaper "Puro Osso" ';
        Cidade := 'Ibate';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Eris GoldenApple';
        Cidade := 'Avalon';
        UF := 'ES';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Dexter Tartakovisky';
        Cidade := 'Londrina';
        UF := 'PR';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Didi Tartakovisky';
        Cidade := 'Londrina';
        UF := 'PR';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Mandark Astronomanov';
        Cidade := 'Ribeirao Preto';
        UF := 'SP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Shaggy Rogers';
        Cidade := 'Guarapari';
        UF := 'ES';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Fred Jones';
        Cidade := 'Rondonopolis';
        UF := 'MT';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Jessica Wray';
        Cidade := 'Cutias';
        UF := 'AP';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Futura Ghostbuster';
        Cidade := 'Penedo';
        UF := 'AL';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
        // --
        Nome := 'Evil-Lyn "Maligna"';
        Cidade := 'Bajuli';
        UF := 'AC';
        Motor.Inserir(Cliente);
        ProgBarra.Position := ProgBarra.Position + 1;
      end;
    finally
      FreeAndNil(Motor);
      FreeAndNil(Cliente);
    end;
    ProgBarra.Position := 1;
  end;
end;

procedure TFrmPrincipal.btSemearProdutosClick(Sender: TObject);
var
  Msg: string;
  Motor: TControladorProduto;
  Produto: TProduto;
begin
  Msg := 'Tem certeza que deseja limpar e' + sLineBreak + 'Semear 20 Produtos?';
  if (MessageDlg(Msg, mtConfirmation, mbYesNo, 0) = IDYES) then
  begin
    Motor := TControladorProduto.Create;
    Produto := TProduto.Create;
    ProgBarra.Position := 1;
    try
      // Limpa tabela de Produtos
      Motor.LimparTudo;
      // Semeia a tabela Produtos com 20 registros
      Produto.Descricao := 'Detergente';
      Produto.PrecoVenda := 1.89;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Sabonete';
      Produto.PrecoVenda := 3.99;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Palha de Aco';
      Produto.PrecoVenda := 1.49;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Arroz';
      Produto.PrecoVenda := 24;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Feijao';
      Produto.PrecoVenda := 7.82;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Manteiga';
      Produto.PrecoVenda := 9.9;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Margarina';
      Produto.PrecoVenda := 5.9;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Papel toalha';
      Produto.PrecoVenda := 4.19;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Sabao em Po';
      Produto.PrecoVenda := 15.03;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Amaciente de Roupas';
      Produto.PrecoVenda := 12.9;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Oleo de Soja';
      Produto.PrecoVenda := 7.43;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Macarrao';
      Produto.PrecoVenda := 3.09;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Molho de Tomate';
      Produto.PrecoVenda := 2.45;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Papel higienico';
      Produto.PrecoVenda := 17.8;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Sardinha';
      Produto.PrecoVenda := 2.49;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Leite em Po';
      Produto.PrecoVenda := 11.98;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Acucar 1Kg';
      Produto.PrecoVenda := 3.99;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Cafe';
      Produto.PrecoVenda := 12.9;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Creme de Leite';
      Produto.PrecoVenda := 2.5;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
      Produto.Descricao := 'Leite de Coco';
      Produto.PrecoVenda := 3.99;
      Motor.Inserir(Produto);
      ProgBarra.Position := ProgBarra.Position + 1;
      // --
    finally
      FreeAndNil(Motor);
      FreeAndNil(Produto);
    end;
    ProgBarra.Position := 1;
  end;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  imgLogo.Picture.LoadFromFile('logo.png');
end;

end.
