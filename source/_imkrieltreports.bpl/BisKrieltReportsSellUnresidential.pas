unit BisKrieltReportsSellUnresidential;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportSellOfficesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellOfficesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellTradePremisesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellTradePremisesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellBasesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellBasesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellRestaurantsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellRestaurantsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellProductionsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellProductionsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellGaragesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellGaragesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellFreePurposeKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellFreePurposeOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellBuildingsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportSellBuildingsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportSellOfficesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_OFFICES_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_offices_krs.xls','������_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='�����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellOfficesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_OFFICES_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_offices_others.xls','������_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='�����';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellTradePremisesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_TRADE_PREMISES_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_trade_premises_krs.xls','������_��������_���������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='�������� ���������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellTradePremisesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_TRADE_PREMISES_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('����');               
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_trade_premises_others.xls','������_�������� ���������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='�������� ���������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellBasesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_BASES_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_bases_krs.xls','������_������,_����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������, ����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellBasesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_BASES_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_bases_others.xls','������_������,_����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������, ����';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellRestaurantsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_RESTAURANTS_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_restaurants_krs.xls','������_���������,_����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='���������, ����';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellRestaurantsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_RESTAURANTS_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_restaurants_others.xls','������_���������,_����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='���������, ����';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellProductionsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_PRODUCTIONS_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_productions_krs.xls','������_������������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellProductionsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_PRODUCTIONS_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_productions_others.xls','������_������������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellGaragesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_GARAGES_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_garages_krs.xls','������_������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellGaragesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_GARAGES_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_garages_others.xls','������_������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellFreePurposeKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_FREE_PURPOSE_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_free_purpose_krs.xls','������_����������_����������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='��������� ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellFreePurposeOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_FREE_PURPOSE_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_free_purpose_others.xls','������_����������_����������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['D1']:='��������� ����������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellBuildingsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_BUILDINGS_KRS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('�����');              
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
    AddInvisible('���������� �����');   
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('�����');              
    Add('DATE_BEGIN');         
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_buildings_krs.xls','������_������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=7;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
      InsertExcelRows(Sheet,4,4,'L',LastRow-1);
      Sheet.Range['A'+IntToStr(LastRow-1)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,5,5,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportSellBuildingsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_SELL_BUILDINGS_OTHERS_EXPORT';      

  with Provider, FieldNames do begin
    AddInvisible('OBJECT_ID');          
    AddInvisible('VIEW_ID');            
    AddInvisible('TYPE_ID');            
    AddInvisible('OPERATION_ID');       
    AddInvisible('DATE_BEGIN');         
    AddInvisible('ACCOUNT_ID');         
    AddInvisible('USER_NAME');          
    AddInvisible('PHONE');              
    AddInvisible('���������� �����');   
    AddInvisible('�����');              
    AddInvisible('��������� ����');     
    AddInvisible('���');                
    AddInvisible('����� �������');      
    AddInvisible('����������');         
    AddInvisible('����');               
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
    Items[0].Filters.Add('���������� �����',fcNotEqual,'���������� �.');   
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('sell_buildings_others.xls','������_������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='������, �������';
  Sheet.Range['E1']:='������';

  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-2)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-2)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-2)]:=Provider.FieldByName('��������� ����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-2)]:=Provider.FieldByName('���').AsString;
    Sheet.Range['E'+IntToStr(LastRow-2)]:=Provider.FieldByName('����� �������').AsString;
    Sheet.Range['F'+IntToStr(LastRow-2)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['G'+IntToStr(LastRow-2)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['H'+IntToStr(LastRow-2)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,LastRow-1,LastRow-1,'L',LastRow);
    InsertExcelRows(Sheet,4,4,'L',LastRow-1);
    Sheet.Rows[LastRow-1]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

end.