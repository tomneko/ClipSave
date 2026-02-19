unit ClipSaveCreateUDef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, LIB_ClipSave_UDef;

type
  TCreateUDefForm = class(TForm)
    Panel1: TPanel;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    Btn_Prefix: TButton;
    Btn_Year: TButton;
    Btn_Month: TButton;
    Btn_Day: TButton;
    Btn_Hour: TButton;
    Btn_Min: TButton;
    Btn_Sec: TButton;
    Btn_MSec: TButton;
    Btn_Ext: TButton;
    Edit_UDef: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Btn_Confirm: TButton;
    Edit_CreatedFName: TEdit;
    Label3: TLabel;
    Btn_Delimiter: TButton;
    Edit_Prefix: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    CMB_Delimiter: TComboBox;
    procedure Btn_PrefixClick(Sender: TObject);
    procedure Btn_YearClick(Sender: TObject);
    procedure Btn_MonthClick(Sender: TObject);
    procedure Btn_DayClick(Sender: TObject);
    procedure Btn_ExtClick(Sender: TObject);
    procedure Btn_HourClick(Sender: TObject);
    procedure Btn_MinClick(Sender: TObject);
    procedure Btn_SecClick(Sender: TObject);
    procedure Btn_MSecClick(Sender: TObject);
    procedure Btn_ConfirmClick(Sender: TObject);
    procedure Btn_DelimiterClick(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  CreateUDefForm: TCreateUDefForm;

implementation

uses ClipSaveConfig;

{$R *.DFM}

procedure TCreateUDefForm.Btn_PrefixClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + StrEsc + ArEscChar[Ord(ecPrefix)];
end;

procedure TCreateUDefForm.Btn_YearClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'yyyy';
end;

procedure TCreateUDefForm.Btn_MonthClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'mm';
end;

procedure TCreateUDefForm.Btn_DayClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'dd';
end;

procedure TCreateUDefForm.Btn_ExtClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + StrEsc + ArEscChar[Ord(ecExt)];
end;

procedure TCreateUDefForm.Btn_HourClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'hh';
end;

procedure TCreateUDefForm.Btn_MinClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'nn';
end;

procedure TCreateUDefForm.Btn_SecClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + 'ss';
end;

procedure TCreateUDefForm.Btn_MSecClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + '\i';
end;

procedure TCreateUDefForm.Btn_DelimiterClick(Sender: TObject);
begin
  Edit_Udef.Text := Edit_Udef.Text + StrEsc + ArEscChar[Ord(ecDelimiter)];
end;

procedure TCreateUDefForm.Btn_ConfirmClick(Sender: TObject);
begin
  Edit_CreatedFName.Text:= CreateFileName(Edit_Udef.Text,
                                          Edit_Prefix.Text,
                                          CMB_Delimiter.Text,
                                          '001');
end;

procedure TCreateUDefForm.Btn_OKClick(Sender: TObject);
begin

  if (Edit_Udef.Text = '') then
  begin
    ShowMessage('ユーザー定義文字列が空です');
    Exit;
  end else
  if (CheckUdefString(Edit_UDef.Text, Edit_Prefix.Text, CMB_Delimiter.Text) = False) then
  begin
    ShowMessage('ユーザー定義文字列が不正です');
    Exit;
  end;

  ModalResult := mrOK;
end;

end.
