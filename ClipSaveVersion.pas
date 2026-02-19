unit ClipSaveVersion;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ShellAPI;

type
  TVersionDlg = class(TForm)
    OKBtn: TButton;
    Label4: TLabel;
    Panel1: TPanel;
    URLLabel1: TLabel;
    URLLabel2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Lbl_Version: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure URLLabel1Click(Sender: TObject);
    procedure URLLabel2Click(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  VersionDlg: TVersionDlg;

implementation

{$R *.DFM}

procedure TVersionDlg.OKBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TVersionDlg.FormCreate(Sender: TObject);
var
  aVersion, MajorVersion, MinorVersion: Cardinal;
begin
  aVersion := SysUtils.GetFileVersion(Application.ExeName);
  MajorVersion := aVersion shr 16;
  MinorVersion := aVersion and $FFFF;

  Lbl_Version.Caption := Format('%d.%d', [MajorVersion, MinorVersion]);
end;

procedure TVersionDlg.URLLabel1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://github.com/tomneko/ClipSave', nil, nil, SW_SHOWNORMAL);
end;

procedure TVersionDlg.URLLabel2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://github.com/tomneko/ClipSave/issues', nil, nil, SW_SHOWNORMAL);
end;

end.
