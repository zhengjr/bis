unit BisMessageServerGsmConsts;

interface

uses BisServerModules;

const
  DefaultTypeMessage=0;

resourcestring

  SParamMode='Mode';
  SParamModems='Modems';

  SFieldPort='PORT';
  SFieldInterval='INTERVAL';
  SFieldBaudRate='BAUD_RATE';
  SFieldDataBits='DATA_BITS';
  SFieldStopBits='STOP_BITS';
  SFieldParityBits='PARITY_BITS';
  SFieldMode='MODE';
  SFieldImei='IMEI';
  SFieldImsi='IMSI';
  SFieldStorages='STORAGES';
  SFieldMaxCount='MAX_COUNT';
  SFieldTimeOut='TIME_OUT';
  SFieldUnknownSender='UNKNOWN_SENDER';
  SFieldUnknownCode='UNKNOWN_CODE';
  SFieldPeriod='PERIOD';
  SFieldDestPort='DEST_PORT';
  SFieldSrcPort='SRC_PORT';
  SFieldOperatorId='OPERATOR_ID';

  SParamOnlyOneModem='OnlyOneModem';

var
  ServerModule: TBisServerModule=nil;  

implementation

end.