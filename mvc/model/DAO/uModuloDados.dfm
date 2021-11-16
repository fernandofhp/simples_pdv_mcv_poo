object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 413
  object Conexao: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=localhost'
      'Database=pedidosvendas'
      'User_Name=root'
      'ConnectTimeout=60'
      'ServerPort=3306')
    VendorLib = 'libmysql.dll'
    Left = 112
    Top = 88
  end
end
