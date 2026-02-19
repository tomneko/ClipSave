program ClipSave;

// $define debug}

uses
//  memcheck,
  Forms,
  Windows,
  Messages,
  SysUtils,
  ClipSaveMain in 'ClipSaveMain.pas' {ClipSaveMainForm},
  ClipSaveVersion in 'ClipSaveVersion.pas' {VersionDlg},
  ClipSaveConfig in 'ClipSaveConfig.pas' {ClipSaveConfigForm},
  ClipSaveCreateUDef in 'ClipSaveCreateUDef.pas' {CreateUDefForm},
  LIB_Tom_DateTime in 'LIB_Tom_DateTime.pas',
  LIB_ClipSave_UDef in 'LIB_ClipSave_UDef.pas',
  Form_Memo in 'Form_Memo.pas' {F_Memo};

{$R *.RES}

var
   bufWT : array[0..255] of char; //ウィンドウタイトル用のバッファ
   bufCN : array[0..255] of char; //クラス名用のバッファ
   bufTMP: array[0..255] of char; //作業用ディレクトリ用のバッファ
   FTemp_Path: String;
   FCShwnd_File: TextFile;
   CShwnd: hwnd;
   p:pointer;
const
     Mutex_Name = 'ClipSaveMutex';
     CRLF = #13#10;

begin

  GetTempPath(SizeOf(bufTMP),bufTMP);
  FTemp_Path := StrPas(bufTMP);

  //clipsave.pidが存在するか確認する
  if FileExists(FTemp_Path + '\clipsave.pid') then
  begin
    //ファイルが存在したらCShwndを取得する
    AssignFile(FCShwnd_File,FTemp_Path + '\clipsave.pid');
    Reset(FCShwnd_File);
    try
      Readln(FCShwnd_File,CShwnd);
    finally
      CloseFile(FCShwnd_File);
    end;

    //CShwndの情報を取得する
    if ((GetWindowText(CShwnd, BufWT, 255) > 0) and  //ウィンドウタイトルがあれば
        (GetClassName(CShwnd, BufCN, 255) > 0)  and  //クラス名も取得して
        (BufWT = 'ClipSave') and
        (BufCN = 'TApplication')) then
      Exit
    else
    begin
      //pidファイルが存在するが、不正である場合削除
      try
        DeleteFile(FTemp_Path + '\clipsave.pid');
      except
        raise Exception.Create(
          '二重起動防止ファイルを削除できません:' +
          CRLF +
          FTemp_Path + '\clipsave.pid'
          );
      end;
    end;
  end;

  //二重起動防止のファイルを作成する
  AssignFile(FCShwnd_File,FTemp_Path + '\clipsave.pid');
  ReWrite(FCShwnd_File);
  try
    Writeln(FCShwnd_File,Application.Handle);
  finally
    CloseFile(FCShwnd_File);
  end;

  try
    { 以下は通常通りの処理を行う }
    Application.Initialize;
    Application.ShowMainForm := False;  // ← 追加
    SetWindowLong(Application.Handle,
      GWL_EXSTYLE,
      GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW
      ); //←追加
    Application.Title := 'ClipSave';
    Application.HelpFile := '';
    Application.CreateForm(TClipSaveMainForm, ClipSaveMainForm);
    Application.CreateForm(TCreateUDefForm, CreateUDefForm);
    Application.CreateForm(TF_Memo, F_Memo);
    ShowWindow(Application.Handle, SW_HIDE);  // ← 追加
    Application.Run;
  finally
    //終了時に二重起動防止ファイルを削除
    if (FileExists(FTemp_Path + '\clipsave.pid') = True) then
    try
      DeleteFile(FTemp_Path + '\clipsave.pid');
    except
      raise Exception.Create(
        '二重起動防止ファイルを削除できません:' +
        CRLF +
        FTemp_Path + '\clipsave.pid'
        );
    end;
  end;
end.
