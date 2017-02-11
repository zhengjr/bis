unit BisKrieltReportsBuy;

interface

uses Controls, BisProvider, BisKrieltReportsUtils, BisFilterGroups, SysUtils,
  BisKrieltReportsFm;

procedure ExportBuyShareResidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyShareResidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyShareUnresidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyShareUnresidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyHousesCottagesTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyHousesCottagesTownHousesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyOutsideHouses(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyDatchasInPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyDatchasOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyLandKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyLandOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyLandOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyUnresidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
procedure ExportBuyUnresidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);

implementation

procedure ExportBuyShareResidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_SHARE_RESIDENTIAL_KRS_EXPORT';

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
    AddInvisible('��������');
    AddInvisible('����');
    AddInvisible('����������');
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

  XLSNew:=CopyExcelDocToNew('buy_share_residential_krs.xls','�����_�������_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� ������� �����';
  Sheet.Range['C1']:='� �. ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyShareResidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_SHARE_RESIDENTIAL_OTHERS_EXPORT';      

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
    AddInvisible('����');               
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_share_residential_others.xls','�����_�������_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� ������� �����';
  Sheet.Range['C1']:='� ��. ���������� �������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyShareUnresidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_SHARE_UNRESIDENTIAL_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_share_unresidential_krs.xls','�����_�������_�������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� ������� �������';
  Sheet.Range['C1']:='� �. ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyShareUnresidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_SHARE_UNRESIDENTIAL_OTHERS_EXPORT';      

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
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_share_unresidential_others.xls','�����_�������_�������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� ������� �������';
  Sheet.Range['C1']:='� ��. ���������� �������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyApartmentsKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_APARTMENTS_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����');               
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_apartments_krs.xls','�����_��������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['E1']:='��������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A3']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,3,3,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyApartmentsOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_APARTMENTS_OTHERS_EXPORT';      

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
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_apartments_others.xls','�����_��������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['E1']:='��������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyHousesCottagesTownHousesKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_HOUSES_COTTAGES_TOWN_HOUSES_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����');               
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_houses_cottages_town_houses_krs.xls','�����_����,_��������,_���������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['E1']:='����, ��������, ���������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A3']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,3,3,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyHousesCottagesTownHousesOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_HOUSES_COTTAGES_TOWN_HOUSES_OTHERS_EXPORT';      

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
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_houses_cottages_town_houses_others.xls','�����_����,_��������,_���������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['C1']:='����, ��������, ���������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyOutsideHouses(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_OUTSIDE_HOUSES_EXPORT';      

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
    AddInvisible('�����������');        
    AddInvisible('����������');         
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('buy_outside_houses.xls','�����_����������_����');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['C1']:='���������� ����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyDatchasInPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_DATCHAS_IN_POINT_EXPORT';      

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
    AddInvisible('����������');         
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('buy_datchas_in_point.xls','�����_����_�_���������� ������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['B1']:='����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyDatchasOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_DATCHAS_OUT_POINT_EXPORT';      

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
    AddInvisible('�����������');        
    AddInvisible('����������');         
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('buy_datchas_out_point.xls','�����_����_��_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='�����, ������� �����';
  Sheet.Range['C1']:='����';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyLandKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_LAND_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('����������');         
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_land_krs.xls','�����_�����_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� �����';
  Sheet.Range['D1']:='� �. ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyLandOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_LAND_OTHERS_EXPORT';      

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
    AddInvisible('����������');         
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_land_others.xls','�����_�����_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� �����';
  Sheet.Range['C1']:='� ��. ���������� �������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyLandOutPoint(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_LAND_OUT_POINT_EXPORT';      

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
    AddInvisible('�����������');        
    AddInvisible('����������');         
    AddInvisible('����������');         
  end;

  with Provider, FilterGroups do begin
    Add(foAnd);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualGreater,SDateBegin);
    Items[0].Filters.Add('DATE_BEGIN',fcEqualLess,SDateEnd);
  end;

  with Provider, Orders do begin
    Add('DATE_BEGIN');              
  end;

  Provider.Open;
  Provider.First;
  BisKrieltReportsForm.Height:=463;
  SetProgressBarToNull(BisKrieltReportsForm, Provider);

  XLSNew:=CopyExcelDocToNew('buy_land_out_point.xls','�����_�����_��_�����������_��������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� �����';
  Sheet.Range['C1']:='�� ����������� ��������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyUnresidentialKrs(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  Region, XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_UNRESIDENTIAL_KRS_EXPORT';      

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
    AddInvisible('�����');              
    AddInvisible('��������');           
    AddInvisible('������ ��������');    
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_unresidential_krs.xls','�����_�������_�_�.����������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� �������';
  Sheet.Range['D1']:='� �. ����������';

  Region:=Provider.FieldByName('�����').AsString;
  Sheet.Range['A4']:=Region;
  LastRow:=6;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('��������').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('������ ��������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    if (Provider.FieldByName('�����').AsString<>Region) then Begin
      Region:=Provider.FieldByName('�����').AsString;
      InsertExcelRows(Sheet,4,4,'L',LastRow);
      Sheet.Range['A'+IntToStr(LastRow)]:=Region;
      LastRow:=LastRow+1;
    End;
    InsertExcelRows(Sheet,5,5,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

procedure ExportBuyUnresidentialOthers(BisKrieltReportsForm: TBisKrieltReportsForm; DateBegin, DateEnd: TDate);
var Provider: TBisProvider;
  LastRow: Integer;
  Excel, Sheet: Variant;
  XLSNew, SDateBegin, SDateEnd: String;
begin

  SDateBegin:=ConvertDateTime(DateBegin,'Begin');
  SDateEnd:=ConvertDateTime(DateEnd,'End');

  Provider:=TBisProvider.Create(nil);
  Provider.ProviderName:='_BUY_UNRESIDENTIAL_OTHERS_EXPORT';      

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
    AddInvisible('������ ��������');    
    AddInvisible('����������');         
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

  XLSNew:=CopyExcelDocToNew('buy_unresidential_others.xls','�����_�������_�_������_����������_�������');
  Excel:=OpenExcelDoc(XLSNew);
  Sheet:=Excel.ActiveSheet;

  Sheet.Range['A1']:='����� �������';
  Sheet.Range['D1']:='� ��. ���������� �������';

  LastRow:=5;

  Repeat
    Sheet.Range['A'+IntToStr(LastRow-1)]:=Provider.FieldByName('���������� �����').AsString;
    Sheet.Range['B'+IntToStr(LastRow-1)]:=Provider.FieldByName('�����').AsString;
    Sheet.Range['C'+IntToStr(LastRow-1)]:=Provider.FieldByName('������ ��������').AsString;
    Sheet.Range['D'+IntToStr(LastRow-1)]:=Provider.FieldByName('����������').AsString;
    Sheet.Range['E'+IntToStr(LastRow-1)]:=Provider.FieldByName('PHONE').AsString;
    ExtendPosProgressBar(BisKrieltReportsForm);
    Provider.Next;
    if Provider.Eof=True then Break;

    InsertExcelRows(Sheet,4,4,'L',LastRow);
    Sheet.Rows[LastRow]:='';
    LastRow:=LastRow+1;
  Until False;

  Excel.Visible:=True;
  Provider.Close;

  Provider.Free;

end;

end.