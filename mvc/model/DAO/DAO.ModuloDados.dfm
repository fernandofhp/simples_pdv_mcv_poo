object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 413
  object FConexao: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MySQL'
      'HostName=localhost'
      'Database=pedidosvendas'
      'User_Name=mysqlweb'
      'ConnectTimeout=60'
      'Port=3306'
      'password=123'
      'ServerPort=3306'
      'charset=utf8'
      'collation=utf8_genaeral_ci'
      'collate=utf8_genaeral_ci')
    VendorLib = 'libmysql.dll'
    Left = 32
    Top = 16
  end
end
