unit BisAudioFormatFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  WaveACMDrivers,
  BisDialogFm,
  BisAudioWave;                                                                                          

type
  TBisAudioFormatForm = class(TBisDialogForm)
    LabelDriver: TLabel;
    ComboBoxDrivers: TComboBox;
    ListBoxFormats: TListBox;
    RadioButtonBoth: TRadioButton;
    RadioButtonMono: TRadioButton;
    RadioButtonStereo: TRadioButton;
    procedure ComboBoxDriversChange(Sender: TObject);
    procedure ListBoxFormatsClick(Sender: TObject);
    procedure ComboBoxDriversCloseUp(Sender: TObject);
    procedure CheckBoxMonoClick(Sender: TObject);
    procedure RadioButtonBothClick(Sender: TObject);
  private
    FDrivers: TBisAudioACMDrivers;
    FOldIndex: Integer;
    procedure RefreshDrivers;
    function GetFormatDescription(Format: TWaveACMDriverFormat): String;
    procedure RefreshFormats;
    function GetDriver: TWaveACMDriver;
    function GetFormat: TWaveACMDriverFormat;
    function GetDriverIndex(AFormat: TWaveACMDriverFormat): Integer;
    function GetFormatIndex(AFormat: TWaveACMDriverFormat): Integer;
    procedure UpdateButtonOk;
    procedure SetFormat(const Value: TWaveACMDriverFormat);
    procedure SetDrivers(const Value: TBisAudioACMDrivers);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

    property Drivers: TBisAudioACMDrivers read FDrivers write SetDrivers; 
    property Format: TWaveACMDriverFormat read GetFormat write SetFormat;
  end;

  TBisAudioFormatFormIface=class(TBisDialogFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisAudioFormatForm: TBisAudioFormatForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisAudioFormatFormIface }

constructor TBisAudioFormatFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisAudioFormatForm;
end;

{ TBisAudioFormatForm }

constructor TBisAudioFormatForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SizesStored:=true;
  SizeGrip.Visible:=true;
  FOldIndex:=-1;
end;

destructor TBisAudioFormatForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisAudioFormatForm.CheckBoxMonoClick(Sender: TObject);
begin
  RefreshFormats;
end;

procedure TBisAudioFormatForm.ComboBoxDriversChange(Sender: TObject);
begin
  if FOldIndex<>ComboBoxDrivers.ItemIndex then begin
    RefreshFormats;
    UpdateButtonOk;
    FOldIndex:=ComboBoxDrivers.ItemIndex;
  end;
end;

procedure TBisAudioFormatForm.ComboBoxDriversCloseUp(Sender: TObject);
begin
  ListBoxFormats.SetFocus;
end;

function TBisAudioFormatForm.GetDriver: TWaveACMDriver;
begin
  Result:=nil;
  if ComboBoxDrivers.ItemIndex<>-1 then
    Result:=TWaveACMDriver(ComboBoxDrivers.Items.Objects[ComboBoxDrivers.ItemIndex]);
end;

function TBisAudioFormatForm.GetDriverIndex(AFormat: TWaveACMDriverFormat): Integer;
var
  i: Integer;
  Driver: TWaveACMDriver;
begin
  Result:=-1;
  if Assigned(AFormat) then begin
    for i:=0 to ComboBoxDrivers.Items.Count-1 do begin
      Driver:=TWaveACMDriver(ComboBoxDrivers.Items.Objects[i]);
      if Driver.ID=AFormat.Driver.ID then begin
        Result:=i;
        exit;
      end;
    end;
  end;
end;

function TBisAudioFormatForm.GetFormatIndex(AFormat: TWaveACMDriverFormat): Integer;
var
  i: Integer;
  Format: TWaveACMDriverFormat;
begin
  Result:=-1;
  if Assigned(AFormat) then begin
    for i:=0 to ListBoxFormats.Items.Count-1 do begin
      Format:=TWaveACMDriverFormat(ListBoxFormats.Items.Objects[i]);
      if AnsiSameText(Format.Name,AFormat.Name) and
         (Format.Index=AFormat.Index) and
         (Format.Tag=AFormat.Tag) then begin
        Result:=i;
        exit;
      end;
    end;
  end;
end;

procedure TBisAudioFormatForm.ListBoxFormatsClick(Sender: TObject);
begin
  UpdateButtonOk;
end;

function TBisAudioFormatForm.GetFormat: TWaveACMDriverFormat;
begin
  Result:=nil;
  if ListBoxFormats.ItemIndex<>-1 then
    Result:=TWaveACMDriverFormat(ListBoxFormats.Items.Objects[ListBoxFormats.ItemIndex]);
end;

procedure TBisAudioFormatForm.RadioButtonBothClick(Sender: TObject);
begin
  RefreshFormats;
end;

procedure TBisAudioFormatForm.RefreshDrivers;
var
  i: Integer;
  Driver: TWaveACMDriver;
  S: String;
begin
  ComboBoxDrivers.Items.BeginUpdate;
  try
    ComboBoxDrivers.Items.Clear;
    for i:=0 to FDrivers.Count-1 do begin
      Driver:=FDrivers.Items[i];
      S:=FormatEx('%s - %s',[Driver.ShortName,Driver.LongName]);
      ComboBoxDrivers.Items.AddObject(S,Driver);
    end;
  finally
    ComboBoxDrivers.Items.EndUpdate;
  end;
end;

function TBisAudioFormatForm.GetFormatDescription(Format: TWaveACMDriverFormat): String;
const
  Channels: array[1..2] of String = ('����', '������');
begin
  Result:='�� ��������������';
  if Assigned(Format) and Assigned(Format.WaveFormat) then begin
    with Format.WaveFormat^ do begin
      if wBitsPerSample <> 0 then
        if nChannels in [1..2] then
          Result := FormatEx('%.3f ���; %d ���; %s', [nSamplesPerSec / 1000, wBitsPerSample, Channels[nChannels]])
        else
          Result := FormatEx('%.3f ���; %d ���; %d ������(��)', [nSamplesPerSec / 1000, wBitsPerSample, nChannels])
      else
        if nChannels in [1..2] then
          Result := FormatEx('%.3f ���; %s', [nSamplesPerSec / 1000, Channels[nChannels]])
        else
          Result := FormatEx('%.3f ���; %d ������(��)', [nSamplesPerSec / 1000, nChannels]);
      Result:=FormatEx('%s: %s | %s',[Format.Name,Result,Format.Description]);
    end;
  end;
end;

procedure TBisAudioFormatForm.RefreshFormats;
var
  i: Integer;
  Driver: TWaveACMDriver;
  Format: TWaveACMDriverFormat;
  S: String;
  Flag: Boolean;
begin
  Driver:=GetDriver;
  if Assigned(Driver) then begin
    ListBoxFormats.Items.BeginUpdate;
    try
      ListBoxFormats.Items.Clear;
      for i:=0 to Driver.Formats.Count-1 do begin
        Format:=Driver.Formats.Items[i];
        Flag:=true;
        if RadioButtonMono.Checked then
          Flag:=Format.WaveFormat.nChannels=1;
        if RadioButtonStereo.Checked then
          Flag:=Format.WaveFormat.nChannels=2;
        if Flag then begin
          S:=GetFormatDescription(Format);
          ListBoxFormats.Items.AddObject(S,Format);
        end;
      end;
    finally
      ListBoxFormats.Items.EndUpdate;
    end;
  end;
end;

procedure TBisAudioFormatForm.SetDrivers(const Value: TBisAudioACMDrivers);
begin
  FDrivers := Value;
  RefreshDrivers;
end;

procedure TBisAudioFormatForm.SetFormat(const Value: TWaveACMDriverFormat);
begin
  if Assigned(Value) and Assigned(Value.WaveFormat) then begin
    RadioButtonMono.Checked:=Value.WaveFormat.nChannels=1;
    RadioButtonStereo.Checked:=Value.WaveFormat.nChannels=2;
  end;
  ComboBoxDrivers.ItemIndex:=GetDriverIndex(Value);
  RefreshFormats;
  ListBoxFormats.ItemIndex:=GetFormatIndex(Value);
  UpdateButtonOk;
end;

procedure TBisAudioFormatForm.UpdateButtonOk;
var
  Format: TWaveACMDriverFormat;
begin
  Format:=GetFormat;
  ButtonOk.Enabled:=Assigned(Format);
end;

procedure TBisAudioFormatForm.BeforeShow;
begin
  inherited BeforeShow;
end;

end.