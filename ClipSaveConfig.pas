unit ClipSaveConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, FileCtrl, Vcl.Samples.Spin, LIB_ClipSave_UDef, Vcl.Imaging.pngimage;


type
  TClipSaveConfigForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    LabelJpegQ: TLabel;
    Label3: TLabel;
    BuckupDirEdit: TEdit;
    BuckupDirButton: TButton;
    SpinEditJpegQ: TSpinEdit;
    RG_SaveImgType: TRadioGroup;
    ColorModeCheck: TCheckBox;
    TabSheet2: TTabSheet;
    CaptureCheck1: TCheckBox;
    RG_CaptureType: TRadioGroup;
    TextFileSaveCheck: TCheckBox;
    PictureSaveCheck: TCheckBox;
    RG_SaveFileNameType: TRadioGroup;
    WavEnabledCheck: TCheckBox;
    WavFileEdit: TEdit;
    OpenDlg: TOpenDialog;
    WavFileButton: TButton;
    IncludeCursorCheck: TCheckBox;
    Edit_Prefix: TEdit;
    Label2: TLabel;
    Edit_UDef: TEdit;
    Btn_Create: TButton;
    CB_AppendText: TCheckBox;
    Label4: TLabel;
    Edit_Memo: TEdit;
    procedure BuckupDirButtonClick(Sender: TObject);
    procedure RG_SaveImgTypeClick(Sender: TObject);
    procedure CaptureCheck1Click(Sender: TObject);
    procedure WavFileButtonClick(Sender: TObject);
    procedure Btn_CreateClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TextFileSaveCheckClick(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
    FDelimiter:String;//���[�U�[��`������̃f���~�^
  end;

const
  C_ClipSaveMemoFileName = 'ClipSaveMemo.txt';

var
  ClipSaveConfigForm: TClipSaveConfigForm;

implementation

uses ClipSaveMain, ClipSaveCreateUDef;

{$R *.DFM}

//バックアップディレクトリの参照ボタンの処理
procedure TClipSaveConfigForm.BuckupDirButtonClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := BuckupdirEdit.Text;
  if SelectDirectory('保存先ディレクトリを選択してください', '', SelectedDir, [sdNewUI, sdNewFolder]) then
    BuckupdirEdit.Text := SelectedDir;
end;


//�N���b�v�{�[�h�A�g�̃`�F�b�NBox�̏���
procedure TClipSaveConfigForm.CaptureCheck1Click(Sender: TObject);
begin
  //�A�g���Ɏg�p�ɂ������
  TextFileSaveCheck.Enabled := CaptureCheck1.Checked;
  PictureSaveCheck.Enabled := CaptureCheck1.Checked;

  //#### 20040512 add Tomneko
  CB_AppendText.Enabled := CaptureCheck1.Checked;
end;

//�ۑ��t�@�C���^�C�v�̃`�F�b�N�̏���
procedure TClipSaveConfigForm.RG_SaveImgTypeClick(Sender: TObject);
var
  idx:Integer;
begin
  idx := RG_SaveImgType.ItemIndex;
  ColorModeCheck.Enabled := (idx = Ord(sitBmp));
  SpinEditJpegQ.Enabled :=  (idx = Ord(sitJpg));
end;


//����炷�t�@�C���̑I���{�^���̏���
procedure TClipSaveConfigForm.WavFileButtonClick(Sender: TObject);
begin
  if (OpenDlg.Execute = True) then
  begin
    if FileExists(OpenDlg.FileName) then
      WavFileEdit.Text := OpenDlg.FileName
    else
      WavFileEdit.Text := '';
    Self.WavEnabledCheck.Checked:=False;
  end;
end;

//���[�U�[��`������쐬�t�H�[����\������
procedure TClipSaveConfigForm.Btn_CreateClick(Sender: TObject);
var
  CreateUDefForm:TCreateUDefForm;
begin
  CreateUDefForm := TCreateUdefForm.Create(Application);
  try
    CreateUdefForm.Edit_Prefix.Text := Edit_Prefix.Text;
    CreateUdefForm.Edit_Udef.Text := Edit_Udef.Text;
    CreateUdefForm.CMB_Delimiter.Text:=FDelimiter;

    if CreateUdefForm.ShowModal = mrOK then
    begin
      Edit_Udef.Text:=CreateUdefForm.Edit_Udef.Text;
      if (Edit_Prefix.Text <> CreateUDefForm.Edit_Prefix.Text) then
        Edit_Prefix.Text := CreateUDefForm.Edit_Prefix.Text;
      FDelimiter := CreateUdefForm.CMB_Delimiter.Text;
    end;
  finally
    CreateUdefForm.Free;
  end;
end;

procedure TClipSaveConfigForm.OKBtnClick(Sender: TObject);
begin
  //���[�U�[��`��������g�p����ꍇ���e���`�F�b�N����
  Case RG_SaveFileNameType.ItemIndex of
    1:
    begin
      if (Edit_Prefix.Text = '') then
      begin
        ShowMessage('Prefix����ł�');
        Exit;
      end;
    end;
    2:
    begin
      if (Edit_Udef.Text = '') then
      begin
        ShowMessage('���[�U�[��`�����񂪋�ł�');
        Exit;
      end else
      if (CheckUdefString(Edit_UDef.Text, Edit_Prefix.Text, FDelimiter) = False) then
      begin
        ShowMessage('���[�U�[��`�����񂪕s���ł�');
        Exit;
      end;
    end;
  end;

  ModalResult := mrOK;

end;

//�e�L�X�g�ۑ��ƒǋL�̘A�g����
procedure TClipSaveConfigForm.TextFileSaveCheckClick(Sender: TObject);
begin
  //#### 20040512 add Tomneko
  CB_AppendText.Enabled := TextFileSaveCheck.Checked;
end;

end.

