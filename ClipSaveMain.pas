unit ClipSaveMain;

interface

uses
  WinAPI.Windows, WinAPI.Messages, WinAPI.ShellAPI, 
  System.SysUtils, System.Classes, 
  System.IniFiles, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ExtCtrls, 
  Vcl.Imaging.Jpeg, Vcl.Imaging.PngImage, 
  // Vcl.ImgList,  
  System.ImageList, // Vcl.ImgList は古いユニットで、System.ImageList に統合された
  WinApi.mmSystem,  // PlaySound のため
  LIB_ClipSave_UDef;

type
  TCaptureType = (capFS = 0, capAW = 1, capCA = 2);
  TSaveImgType = (sitJpg = 0, sitBmp = 1, sitPng = 2);

  TClipSaveMainForm = class(TForm)
    TrayIcon: TTrayIcon;
    LBPopupMenu: TPopupMenu;
    MenuItemExit: TMenuItem;
    MenuItemConfig: TMenuItem;
    MenuItemVersion: TMenuItem;
    MenuItemHelp: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    MenuItemJpg: TMenuItem;
    MenuItemBmp: TMenuItem;
    N3: TMenuItem;
    MenuItemFS: TMenuItem;
    MenuItemAW: TMenuItem;
    MenuItemCA: TMenuItem;
    N4: TMenuItem;
    MenuItemClipBoard: TMenuItem;
    IconList: TImageList;
    N6: TMenuItem;
    MenuItemCursor: TMenuItem;
    MenuItemOpenFolder: TMenuItem;
    MenuItemPng: TMenuItem;
    procedure MenuItemExitClick(Sender: TObject);
    procedure MenuItemConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItemVersionClick(Sender: TObject);
    procedure MenuItemHelpClick(Sender: TObject);
    procedure MenuItemImgTypeClick(Sender: TObject);
    procedure MenuItemCapTypeClick(Sender: TObject);
    procedure MenuItemClipBoardClick(Sender: TObject);
    procedure MenuItemCursorClick(Sender: TObject);
    procedure MenuItemOpenFolderClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure ClipboardTimerTimer(Sender: TObject);
  private
    { Private 宣言 }
    AppendText: Boolean;
    SaveFileExt: Integer;
    SaveFileDir: string;
    DefaultDir : string;
    HookMsg: string;
    msgHooking: integer;
    hDll: THandle;
    ClipbrdAssociated: Boolean;
    TextFileSave: Boolean;     //テキストを保存する(連携中)
    PictureSave: Boolean;      //画像を保存する(連携中)
    CaptureType: TCaptureType; // 0:FullScreen 1:ActiveWindow 2:ClientArea
    SaveImgType: TSaveImgType; // 0:Jpeg 1:Bmp 2:Png Default=1
    JpegQuality: Integer;      // 0から100の間　大きいほど画質がよい=ファイル大
    ColorMode:Boolean;         //True:24bitBMPにする False:画面Modeに依存する
    SaveFileNameType: Integer; // 0:yyyymmdd.nnn.Ext
                               // 1:Prefix+yyyymmdd.nnn.Ext
                               // 2:ユーザー定義
    Prefix:String;//接頭辞
    FUDef:String;//ユーザー定義文字列
    FDelimiter:String;//ユーザー定義文字列のデリミタ
    WavEnabled: Boolean;//音を鳴らす
    WavFile: String;//Waveファイル名
    IncludeCursor: Boolean;//カーソルを含める
    FClipSaveMemoFileName:String;
    LastTick: Cardinal;
    LastBitmap: TBitmap;
    LastText: string;
    ClipboardTimer: TTimer;
    function  BitmapsAreEqual(B1, B2: TBitmap): Boolean;
    function  SaveFileNameCreate(ExtStr:String):string;
    function  TryOpenClipboard: Integer;
    procedure ClipboardSaveToFile(cfType: Integer);
    procedure RecieveHotKey;
    procedure WndProc(var Message: TMessage);override;
    procedure IniSave;
    procedure IniLoad;
    procedure RecMemo;
    procedure UpdateTrayIcon;
  protected
    procedure WMClipboardUpdate(var Msg: TMessage);
                message WM_CLIPBOARDUPDATE;
  public
   { Public 宣言 }
  end;

const
  C_MAX_SaveFileExt = 99999;
  DWMWA_EXTENDED_FRAME_BOUNDS = 9;
  USER_DEFAULT_SCREEN_DPI = 96;
  CURSOR_SHOWING = $00000001;  // カーソル表示フラグ
  // System metrics indices
  SM_CXBORDER = 5;         // ウィンドウ境界線の幅（横）
  SM_CYBORDER = 6;         // ウィンドウ境界線の高さ（縦）
  SM_CYCAPTION = 4;        // タイトルバーの高さ
  SM_CXSIZEFRAME = 32;     // リサイズ可能枠の幅（横）
  SM_CYSIZEFRAME = 33;     // リサイズ可能枠の高さ（縦）
  SM_CXPADDEDBORDER = 92;  // Windows 10+ パディング境界
  // GetDeviceCaps indices
  HORZRES = 8;             // 論理水平解像度
  VERTRES = 10;            // 論理垂直解像度
  DESKTOPHORZRES = 118;    // 物理水平解像度 (DPI調整前)
  DESKTOPVERTRES = 117;    // 物理垂直解像度 (DPI調整前)
  LOGPIXELSX = 88;         // 論理DPI (横)
  LOGPIXELSY = 90;         // 論理DPI (縦)

type
  // カーソル情報構造体
  TCursorInfo = record
    cbSize: DWORD;       // 構造体のサイズ
    flags: DWORD;        // カーソルの状態フラグ
    hCursor: HCURSOR;    // カーソルハンドル
    ptScreenPos: TPoint; // スクリーン座標でのカーソル位置
  end;

// DWM API for Windows 10/11 accurate window bounds
function DwmGetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; 
  pvAttribute: Pointer; cbAttribute: DWORD): HRESULT; stdcall; 
  external 'dwmapi.dll';

// Get DPI for a window (Windows 10 1607+)
function GetDpiForWindow(hwnd: HWND): UINT; stdcall; 
  external 'user32.dll';

// Get system DPI (Windows 10 1607+)
function GetDpiForSystem(): UINT; stdcall; 
  external 'user32.dll';

// Get system metrics adjusted for DPI (Windows 10 1607+)
function GetSystemMetricsForDpi(nIndex: Integer; dpi: UINT): Integer; stdcall; 
  external 'user32.dll';

// Get cursor information (position, handle, visibility)
function GetCursorInfo(var pci: TCursorInfo): BOOL; stdcall; 
  external 'user32.dll';

var
  ClipSaveMainForm: TClipSaveMainForm;
  LastSaveTick: Cardinal = 0;

implementation

uses ClipSaveConfig, ClipSaveVersion, Form_Memo;

{$R *.DFM}

//指定された領域をキャプチャーしてファイルに保存する
procedure TClipSaveMainForm.RecieveHotKey;
var
  SaveFile  : String;
  TempJpeg  : TJpegImage;
  TempBitmap: TBitmap;
  TempPng   : TPNGObject;
  DesktopDC: HDC;
  Wnd: HWnd;
  rc: TRect;
  w, h: Integer;
  OriginalRect: TRect;
  ClientRect: TRect;
  ClientOffsetX, ClientOffsetY: Integer;
  ClientWidth, ClientHeight: Integer;
  NeedCrop: Boolean; // 切り出しが必要か（全モード統一）
  CaptureRect: TRect; // 実際にキャプチャする領域（常にフルスクリーン）
  FinalBitmap: TBitmap;
  dpi: UINT;
  titleBarHeight, frameWidth, frameHeight, paddedBorder, borderWidth, borderHeight: Integer;
  //wn: array[0??:20] of char;
  //ws: String;
begin
  // Get desktop DC for entire virtual screen (0 = full desktop including all monitors)
  DesktopDC := GetDC(0);
  if (DesktopDC = 0) then raise Exception.Create('OS Error:GetDC');
  
  OriginalRect := Rect(0, 0, 0, 0);
  NeedCrop := False;
  
  // 常にフルスクリーン全体をキャプチャ（カーソル座標系と一致）
  CaptureRect := Rect(
    GetSystemMetrics(SM_XVIRTUALSCREEN), 
    GetSystemMetrics(SM_YVIRTUALSCREEN),
    GetSystemMetrics(SM_XVIRTUALSCREEN) + GetDeviceCaps(DesktopDC, DESKTOPHORZRES),
    GetSystemMetrics(SM_YVIRTUALSCREEN) + GetDeviceCaps(DesktopDC, DESKTOPVERTRES)
  );
  
  try
    // 切り出す領域を設定（実際のキャプチャは常にフルスクリーン）
    Case CaptureType of
    capFS:begin
      // Full screen: 切り出し不要
      rc := CaptureRect;
      NeedCrop := False;
      end;
    capAW:begin
      Wnd := GetForegroundWindow;
      // Windows 10/11: Get accurate window bounds excluding DWM extended frame
      if DwmGetWindowAttribute(Wnd, DWMWA_EXTENDED_FRAME_BOUNDS, @rc, SizeOf(TRect)) <> 0 then
        GetWindowRect(Wnd, rc);  // Fallback if DWM fails
      OriginalRect := rc;  // Save for crop
      NeedCrop := True;
      //GetClassName(Wnd,@wn,21);
      //ws := wn;
      end;
    capCA:begin
      Wnd := GetForegroundWindow;
      
      // Get DPI for target window
      dpi := GetDpiForWindow(Wnd);
      if dpi = 0 then dpi := USER_DEFAULT_SCREEN_DPI;  // Fallback to 96 DPI
      
      // Capture full window (DWM aware - already pixel perfect)
      if DwmGetWindowAttribute(Wnd, DWMWA_EXTENDED_FRAME_BOUNDS, @rc, SizeOf(TRect)) <> 0 then
        GetWindowRect(Wnd, rc);
      OriginalRect := rc;
      
      // Get system metrics (DPI aware) to calculate client area position
      borderWidth := GetSystemMetricsForDpi(SM_CXBORDER, dpi);        // 境界線幅
      borderHeight := GetSystemMetricsForDpi(SM_CYBORDER, dpi);       // 境界線高さ
      titleBarHeight := GetSystemMetricsForDpi(SM_CYCAPTION, dpi);    // タイトルバー高さ
      frameWidth := GetSystemMetricsForDpi(SM_CXSIZEFRAME, dpi);      // 枠の幅（横）
      frameHeight := GetSystemMetricsForDpi(SM_CYSIZEFRAME, dpi);     // 枠の高さ（縦）
      paddedBorder := GetSystemMetricsForDpi(SM_CXPADDEDBORDER, dpi); // Windows 10+ パディング
      
      // Windows 10+: フレームサイズにパディングと境界線を加える
      frameWidth := frameWidth + paddedBorder + borderWidth;
      frameHeight := frameHeight + paddedBorder + borderHeight;
      
      // Calculate client area offset from window top-left
      ClientOffsetX := frameWidth;
      // +6 for Windows 10/11 undocumented margins (DWM shadow, theme spacing, rounding errors)
      ClientOffsetY := titleBarHeight + frameHeight + 6;
      
      // Calculate client area size
      ClientWidth := (rc.Right - rc.Left) - (frameWidth * 2);
      ClientHeight := (rc.Bottom - rc.Top) - titleBarHeight - (frameHeight * 2) - 6;
      
      // Setup crop rectangle
      ClientRect := Rect(0, 0, ClientWidth, ClientHeight);
      NeedCrop := True;
      end;
    end;
    
    // 実際のキャプチャサイズはフルスクリーン
    w := CaptureRect.right - CaptureRect.left;
    h := CaptureRect.bottom - CaptureRect.top;

    //保存用Bitmapの作成
    TempBitmap := TBitmap.Create;
    try
      TempBitmap.PixelFormat := pf24bit;  // PixelFormat を明示的に設定
      TempBitmap.Width := w;
      TempBitmap.Height := h;

      //キャプチャーする領域をBitmapに転送（常にフルスクリーン）
      if BitBlt(TempBitmap.Canvas.Handle, 0, 0, w, h, DesktopDC, CaptureRect.left, CaptureRect.top, SRCCOPY) then
      begin
        //カーソルを含めるとき
        if IncludeCursor then
        begin
          var CursorInfo: TCursorInfo;
          var IconInfo: TIconInfo;
          var cp: TPoint;
          begin
            // システム全体のカーソル情報を取得
            CursorInfo.cbSize := SizeOf(TCursorInfo);
            if GetCursorInfo(CursorInfo) then
            begin
              // カーソルが表示されている場合のみ描画
              if (CursorInfo.flags and CURSOR_SHOWING) <> 0 then
              begin
                cp := CursorInfo.ptScreenPos;
                
                // カーソルのホットスポット情報を取得
                if GetIconInfo(CursorInfo.hCursor, IconInfo) then
                begin
                  try
                    // GetCursorInfo の座標は論理座標なので物理座標に変換
                    var PhysicalX, PhysicalY: Integer;
                    var ScaleFactorX, ScaleFactorY: Double;
                    var LogicalWidth, LogicalHeight: Integer;
                    var PhysicalWidth, PhysicalHeight: Integer;
                    begin
                      // 実際のスケールファクターを物理解像度/論理解像度で計算
                      LogicalWidth := GetSystemMetrics(SM_CXVIRTUALSCREEN);
                      LogicalHeight := GetSystemMetrics(SM_CYVIRTUALSCREEN);
                      PhysicalWidth := GetDeviceCaps(DesktopDC, DESKTOPHORZRES);
                      PhysicalHeight := GetDeviceCaps(DesktopDC, DESKTOPVERTRES);
                      
                      if LogicalWidth > 0 then
                        ScaleFactorX := PhysicalWidth / LogicalWidth
                      else
                        ScaleFactorX := 1.0;
                      
                      if LogicalHeight > 0 then
                        ScaleFactorY := PhysicalHeight / LogicalHeight
                      else
                        ScaleFactorY := 1.0;
                      
                      // 論理座標→物理座標
                      PhysicalX := Round(cp.x * ScaleFactorX);
                      PhysicalY := Round(cp.y * ScaleFactorY);
                      
                      // フルスクリーン基準なので CaptureRect.Left/Top を引くだけ
                      if ((CaptureRect.Left <= PhysicalX) and (PhysicalX <= CaptureRect.Right)) and
                         ((CaptureRect.Top  <= PhysicalY) and (PhysicalY <= CaptureRect.Bottom)) then
                      begin
                        var DrawX, DrawY: Integer;
                        const DI_NORMAL = $0003;  // DI_MASK or DI_IMAGE
                        begin
                          DrawX := PhysicalX - CaptureRect.Left - Integer(IconInfo.xHotspot);
                          DrawY := PhysicalY - CaptureRect.Top - Integer(IconInfo.yHotspot);
                          
                          // Canvas のピクセルデータに確実に反映
                          TempBitmap.Canvas.Lock;
                          try
                            DrawIconEx(TempBitmap.Canvas.Handle, DrawX, DrawY, 
                                      CursorInfo.hCursor, 0, 0, 0, 0, DI_NORMAL);
                          finally
                            TempBitmap.Canvas.Unlock;
                          end;
                        end;
                      end;
                    end;
                  finally
                    // IconInfo のビットマップハンドルを解放
                    if IconInfo.hbmMask <> 0 then
                      DeleteObject(IconInfo.hbmMask);
                    if IconInfo.hbmColor <> 0 then
                      DeleteObject(IconInfo.hbmColor);
                  end;
                end;
              end;
            end;
          end;
        end;

        // Crop to final area (Active Window or Client Area)
        if NeedCrop then
        begin
          FinalBitmap := TBitmap.Create;
          try
            if CaptureType = capCA then
            begin
              // ClientArea: crop to client area
              FinalBitmap.Width := ClientWidth;
              FinalBitmap.Height := ClientHeight;
              FinalBitmap.PixelFormat := TempBitmap.PixelFormat;
              // Copy client area portion from full screen
              BitBlt(FinalBitmap.Canvas.Handle, 0, 0, 
                     FinalBitmap.Width, FinalBitmap.Height, 
                     TempBitmap.Canvas.Handle, 
                     OriginalRect.Left - CaptureRect.Left + ClientOffsetX,
                     OriginalRect.Top - CaptureRect.Top + ClientOffsetY,
                     SRCCOPY);
            end
            else if CaptureType = capAW then
            begin
              // ActiveWindow: crop to window bounds
              FinalBitmap.Width := OriginalRect.Right - OriginalRect.Left;
              FinalBitmap.Height := OriginalRect.Bottom - OriginalRect.Top;
              FinalBitmap.PixelFormat := TempBitmap.PixelFormat;
              // Copy window portion from full screen
              BitBlt(FinalBitmap.Canvas.Handle, 0, 0, 
                     FinalBitmap.Width, FinalBitmap.Height, 
                     TempBitmap.Canvas.Handle, 
                     OriginalRect.Left - CaptureRect.Left,
                     OriginalRect.Top - CaptureRect.Top,
                     SRCCOPY);
            end;
            // Replace TempBitmap
            TempBitmap.Assign(FinalBitmap);
          finally
            FinalBitmap.Free;
          end;
        end;

        //32bitモードにする
        if ColorMode then TempBitmap.PixelFormat := pf32bit;

        //Clipbrdと連携しないときだけ保存する
        if not ClipbrdAssociated then
        begin

          //保存形式によって保存方法を変える
          Case SaveImgType of
            sitJpg:
            begin
              //Jpegでファイルに保存
              TempBitmap.PixelFormat := pf24bit; // JPEG保存前に必ず24bitに
              SaveFile := SaveFileNameCreate('.jpg');
              TempJpeg := TJpegImage.Create;
              try
                TempJpeg.Assign(TempBitmap);
                TempJpeg.CompressionQuality := JpegQuality;
                TempJpeg.Compress;
                TempJpeg.SaveToFile(SaveFile);
              finally
                TempJpeg.Free;
              end;
            end;
            sitBmp:
            begin
              //Bitmapでファイルに保存
              SaveFile := SaveFileNameCreate('.bmp');
              TempBitmap.SaveToFile(SaveFile);
            end;
            sitPng:
            begin
              //Pngでファイルに保存
              SaveFile := SaveFileNameCreate('.png');
              TempPng := TPNGObject.Create;
              try
                TempPng.Assign(TempBitmap);
                //TempPng.CompressionLevel := 9;
                TempPng.SaveToFile(SaveFile);
              finally
                TempPng.Free;
              end;
            end;
          end;  //End Case
        end else
        begin
          //ClipBrdに画像を転送する
          OpenClipboard(0);
          try
            EmptyClipboard;
            SetClipboardData(CF_BITMAP,
              CopyImage(TempBitmap.Handle, IMAGE_BITMAP, 0, 0, LR_COPYRETURNORG));
          finally
            CloseClipboard;
          end;
        end;
      end;

      //後始末
    finally
      TempBitmap.Free;
    end;
  finally
    ReleaseDC(0, DesktopDC);
  end;

  //音を鳴らす
  if WavEnabled then
    try
      PlaySound(PChar(WavFile),0,SND_ASYNC)
    except
      raise Exception.Create('Wave File Error');
    end;

end;

function TClipSaveMainForm.TryOpenClipboard: Integer;
var
  i: Integer;
  fmt: UINT;
begin
  Result := 0;
  for i := 1 to 10 do  // 最大 200ms
  begin
    if OpenClipboard(0) then
    begin
      try
        fmt := EnumClipboardFormats(0);
        while fmt <> 0 do
        begin
          if (fmt = CF_BITMAP) or (fmt = CF_UNICODETEXT) then
            Exit(fmt);
          fmt := EnumClipboardFormats(fmt);
        end;
      finally
        CloseClipboard;
      end;
      Exit(0);
    end;

    Sleep(20);
  end;
end;

function TClipSaveMainForm.BitmapsAreEqual(B1, B2: TBitmap): Boolean;
var
  y: Integer;
  LineSize: Integer;
begin
  Result := False;

  if (B1.Width <> B2.Width) or (B1.Height <> B2.Height) then
    Exit;

  LineSize := B1.Width * 4; // 32bit 固定

  for y := 0 to B1.Height - 1 do
  begin
    if not CompareMem(B1.ScanLine[y], B2.ScanLine[y], LineSize) then
      Exit;
  end;

  Result := True;
end;

procedure TClipSaveMainForm.ClipboardTimerTimer(Sender: TObject);
var
  cfType: Integer;
begin
  ClipboardTimer.Enabled := False;
  cfType := TryOpenClipboard;
  if cfType = 0 then Exit; // エラーを出さず静かに諦める

  // ここで従来の ClipboardSaveToFile を呼ぶ
  ClipboardSaveToFile(cfType);
end;

//クリップボードの内容をファイルに保存する
procedure TClipSaveMainForm.ClipboardSaveToFile(cfType: Integer);
var
  SaveFile  : String;
  TempBitmap: TBitmap;
  TempJpeg  : TJpegImage;
  TempPng   : TPngObject;
  TempText  : String;
  fText     : TextFile;
  ms        : TMemoryStream;
  h         : THandle;
  p         : Pointer;
begin
  if (cfType = CF_BITMAP) and PictureSave then
  begin
    //一時保存用Bitmapの生成
    TempBitmap := TBitmap.Create;
    try
      //クリップボードの中身を保存
      OpenClipboard(0);
      try
        h := GetClipboardData(CF_BITMAP);
        TempBitmap.Handle := CopyImage(h, IMAGE_BITMAP, 0, 0, LR_COPYRETURNORG);
      finally
        CloseClipboard;
      end;

      // DIB 形式はピクセルフォーマットが不明なことがあるため、常に32bitに変換して比較する
      TempBitmap.PixelFormat := pf32bit;

      //連続呼び出し防止
      // 直前の保存から1秒以内なら内容比較
      if (GetTickCount - LastTick < 1000) and
         (BitmapsAreEqual(TempBitmap, LastBitmap) = True) then
        begin
          Exit; // 同じ内容なのでスキップ
        end;

      // ここまで来たら保存すべき内容
      LastTick := GetTickCount;

      // 今回のデータを LastBitmap に保持
      LastBitmap.Assign(TempBitmap);
      // 連続呼び出し防止処理終了

      //保存形式によって保存方法を変更する
      Case SaveImgType of
        sitJpg:begin
          SaveFile := SaveFileNameCreate('.jpg');
          TempJpeg   := TJpegImage.Create;
          try
            TempJpeg.Assign(TempBitmap);
            TempJpeg.CompressionQuality := JpegQuality;
            TempJpeg.Compress;
            TempJpeg.SaveToFile(SaveFile);
          finally
            TempJpeg.Free;
          end;
        end;
        sitBmp:begin
          //Bitmapをファイルに保存
          SaveFile := SaveFileNameCreate('.bmp');
          TempBitmap.SaveToFile(SaveFile);
        end;
        sitPng:begin
          SaveFile := SaveFileNameCreate('.png');
          TempPng   := TPngObject.Create;
          try
            TempPng.Assign(TempBitmap);
            TempPng.SaveToFile(SaveFile);
          finally
            TempPng.Free;
          end;
        end;
      end;
    finally
      TempBitmap.Free;
    end;
  end else
  if (cfType = CF_UNICODETEXT) and TextFileSave then
  begin
    //クリップボードの中身を保存
    OpenClipboard(0);
    try
      h := GetClipboardData(CF_UNICODETEXT);
      p := GlobalLock(h);
      try
        TempText := PChar(p);  // UTF-16LE で格納されているはずなので PChar で直接読み取る
      finally
        GlobalUnlock(h);
      end;
    finally
      CloseClipboard;
    end;

    //連続呼び出し防止
    // 直前の保存から1秒以内なら内容比較
    if (GetTickCount - LastTick < 1000) and
        (TempText = LastText) then
      begin
        Exit; // 同じ内容なのでスキップ
      end;

    // ここまで来たら保存すべき内容
    LastTick := GetTickCount;

    // 今回のデータを LastText に保持
    LastText := TempText;
    // 連続呼び出し防止処理終了

    //保存用ファイル名の作成
    SaveFile := SaveFileNameCreate('.txt');

    if TFile.Exists(SaveFile) then
      TFile.AppendAllText(SaveFile, TempText + sLineBreak, TEncoding.UTF8)
    else
      TFile.WriteAllText(SaveFile, TempText + sLineBreak, TEncoding.UTF8);

    //追記の場合は日時を記録する
    if (AppendText = True) then
    begin
      TempText := '----- Saved from Clipboard at ' +
                  formatdatetime('yyyy/mm/dd hh:mm:ss', now) +
                  ' -----'+#13#10;
      TFile.AppendAllText(SaveFile, TempText + sLineBreak, TEncoding.UTF8);
    end;
  end;

  //音を鳴らす
  if WavEnabled then try PlaySound(PChar(WavFile),0,SND_ASYNC) except end;

end;

//WndProcのOverride、キーボードフックメッセージの処理
procedure TClipSaveMainForm.WndProc(var Message: TMessage);
begin
  //ホットキーメッセージがやってきた場合の処理
  if (Message.Msg = WM_HOTKEY) and
     (Message.wparam = GlobalFindAtom('ClipSaveAtom'))
  then
  begin
    RecieveHotKey;
  end;

  //デフォルトの処理
  inherited WndProc(Message);
end;

//保存用のファイル名を作成する手続き
function TClipSaveMainForm.SaveFileNameCreate(ExtStr:String):string;
var
  SaveFile: String;

  function SaveFileNameCreateEx:String;
  var
    StrNum : String;
  begin

    //保存用ナンバーの修正
    StrNum := format('%3.3d',[SaveFileExt]);

    //SaveFileNameTypeによってファイル名を変える
    Case SaveFileNameType of
      0:begin
        if (ClipbrdAssociated and TextFileSave and AppendText) then
          Result := FormatDateTime('yyyymmdd',Date) + ExtStr
        else
          Result := FormatDateTime('yyyymmdd',Date) +'.'+ StrNum + ExtStr;
      end;
      1:begin
        if (ClipbrdAssociated and TextFileSave and AppendText) then
          Result := Prefix + FormatDateTime('yyyymmdd',Date) + ExtStr
        else
          Result := Prefix + FormatDateTime('yyyymmdd',Date) +'.'+ StrNum + ExtStr;
      end;
      2:begin
        try
          if (ClipbrdAssociated and TextFileSave and AppendText) then
            Result := CreateFileName(FUDef, Prefix, FDelimiter, '---') + ExtStr
          else
            Result := CreateFileName(FUdef, Prefix, FDelimiter, StrNum) + ExtStr;
        except
          on E:ECreateFileNameErr do
          begin
            ShowMessage(E.Message);
            exit;
          end else
            raise;
        end;
      end;
    end;
  end;
begin

//  //保存形式によって拡張子を変更する
// Case SaveFileType of
//    0:ExtStr := '.jpg';
//    1:ExtStr := '.bmp';
//  end;

  repeat
    //保存用ファイル名の作成
    SaveFile := SaveFileNameCreateEx;

    if (ClipbrdAssociated and TextFileSave and AppendText) then Break;

    //保存用ナンバーを増やす
    Inc(SaveFileExt);

    if (SaveFileExt = C_MAX_SaveFileExt) then
      raise Exception.Create( 'ファイル保存用ナンバーが ' +
                              IntToStr(C_MAX_SaveFileExt) +
                              ' を超えました');
  until (FileExists(SaveFile) = false);

  //ルートディレクトリを考慮した処理
  if Copy(SaveFileDir,Length(SaveFileDir),1) = '\' then
    SaveFile := SaveFileDir + SaveFile
  else
    SaveFile := SaveFileDir + '\' + SaveFile;

  Result := SaveFile;
end;

//フォーム生成時の処理
procedure TClipSaveMainForm.FormCreate(Sender: TObject);
var
  FindResult: Integer;
  SearchRec: TSearchRec;
begin
  //クリップボードビュアーチェーンに自分を登録する
  //戻り値は次のCBVのハンドル
  AddClipboardFormatListener(Handle);

  //ホットキーを設定する
  // Changed to Ctrl+Shift+C (left-hand friendly, "C" for ClipSave)
  // Silent failure if hotkey registration fails (already in use, etc.)
  RegisterHotKey(Handle, GlobalAddAtom('ClipSaveAtom'), MOD_CONTROL or MOD_SHIFT, Ord('C'));

  //各初期設定値
  SaveFileExt := 0;

  //INIファイルからの設定情報の復元
  IniLoad;

  //右クリックメニューのClipBoard連携を設定する
  MenuItemClipBoard.Checked := ClipBrdAssociated;

  //TrayIconにIconsを設定
  TrayIcon.Icons := IconList;

  //アイコンを設定する
  UpdateTrayIcon;


  //右クリックメニュー画像とテキスト保存を設定する（内部的にのみ使用）
  // 画像は必ず保存する
  PictureSave := True;

  //右クリックメニューのキャプチャーエリアを設定する
  MenuItemFS.Checked := (CaptureType = capFS);
  MenuItemAW.Checked := (CaptureType = capAW);
  MenuItemCA.Checked := (CaptureType = capCA);

  //右クリックメニューのファイルタイプを設定する
  MenuItemJpg.Checked := (SaveImgType = sitJpg);
  MenuItemBmp.Checked := (SaveImgType = sitBmp);
  MenuItemPng.Checked := (SaveImgType = sitPng);

  //右クリックメニューのカーソルを含めるを設定する
  MenuItemCursor.Checked := IncludeCursor;

  //JpegQualityの値をチェックする
  if JpegQuality > 100 then JpegQuality := 100;
  if JpegQuality < 0 then JpegQuality := 0;

  //保存用ディレクトリが存在しなければ作成する
  if not SetCurrentDir(SaveFiledir) then
  begin
    if not CreateDir(SaveFileDir) then
    begin
      CreateDir(DefaultDir);
      SaveFiledir := DefaultDir;
    end;

    SetCurrentDir(SaveFileDir);
  end;

  //前回保存したファイルの次の保存用ナンバーまですすめる
  FindResult := FindFirst(SaveFileDir + '????????.???.*', faAnyFile, SearchRec);
  try
    While (FindResult = 0) do
    begin
      Inc(SaveFileExt);

      if (SaveFileExt = C_MAX_SaveFileExt) then
        raise Exception.Create('ファイル保存用ナンバーが99999を超えました');

      FindResult := FindNext(SearchRec);
    end;
  finally
    FindClose(SearchRec);
  end;

  LastBitmap := TBitmap.Create;
  ClipboardTimer := TTimer.Create(Self);
  ClipboardTimer.Enabled := False;
  ClipboardTimer.Interval := 50; // 50?80ms が最適
  ClipboardTimer.OnTimer := ClipboardTimerTimer;
end;

//フォームが破棄されるときの処理
procedure TClipSaveMainForm.FormDestroy(Sender: TObject);
begin
  try
    //iniファイルへの保存処理
    IniSave;

    // ClipboardFormatListener から自分を外す
    RemoveClipboardFormatListener(Handle);

    //ホットキーを解除する
    try
      if (Win32Check(UnRegisterHotKey(Handle, GlobalFindAtom('ClipSaveAtom'))) = False) then
        RaiseLastOSError;
    except
      on E:Exception do
        ShowMessage('OSの例外：' + E.Message);
    end;

  finally
    GlobalDeleteAtom(GlobalFindAtom('ClipSaveAtom'));
  end;

  LastBitmap.Free;
  ClipboardTimer.Free;
end;

procedure TClipSaveMainForm.WMClipboardUpdate(var Msg: TMessage);
begin
  if GetTickCount - LastSaveTick < 120 then
    Exit;

  LastSaveTick := GetTickCount;

  // 遅延実行
  ClipboardTimer.Enabled := False;
  ClipboardTimer.Interval := 50; // 50?80ms が最適
  ClipboardTimer.Enabled := True;
end;

//メニュー・終了する
procedure TClipSaveMainForm.MenuItemExitClick(Sender: TObject);
begin
  Close;
end;

//メニュー・設定用のダイアログボックスを表示する
procedure TClipSaveMainForm.MenuItemConfigClick(Sender: TObject);
var
   ClipSaveConfigForm: TClipSaveConfigForm;
begin
  ClipSaveConfigForm := TClipSaveConfigForm.Create(Application);
  try
    //ダイアログボックスを設定する
    with ClipSaveConfigForm do
    begin
      PageControl1.ActivePageIndex := 0;
      
      //保存先ディレクトリ
      BuckupDirEdit.Text := SaveFileDir;

      //クリップボード連携
      CaptureCheck1.Checked := ClipbrdAssociated;

      //テキストを保存する
      TextFileSaveCheck.Enabled := CaptureCheck1.Checked;
      TextFileSaveCheck.Checked := TextFileSave;

      //画像を保存する
      PictureSaveCheck.Enabled := CaptureCheck1.Checked;
      PictureSaveCheck.Checked := PictureSave;

      //キャプチャ範囲の設定
      RG_CaptureType.ItemIndex := Ord(CaptureType);

      //保存ファイル形式
      RG_SaveImgType.ItemIndex := Ord(SaveImgType);

      //保存ファイル名形式
      RG_SaveFileNameType.ItemIndex := SaveFileNameType;

      //保存ファイル名のPrefix
      Edit_Prefix.Text := Prefix;

      //ユーザー定義文字列
      Edit_UDef.Text := FUdef;
      ClipSaveConfigForm.FDelimiter := Self.FDelimiter;

      //Jpeg画質
      SpinEditJpegQ.Value := JpegQuality;

      //24bitモード
      Case SaveImgType of
      sitJpg:begin
          ColorModeCheck.Enabled := False;
          SpinEditJpegQ.Enabled := True;
          LabelJpegQ.Enabled := True;
        end;
      sitBmp,sitPng:begin
          ColorModeCheck.Enabled := True;
          SpinEditJpegQ.Enabled := False;
          LabelJpegQ.Enabled := False;
        end;
      end;
      ColorModeCheck.Checked := ColorMode;

      //音を鳴らす
      WavEnabledCheck.Checked := WavEnabled;
      WavFileEdit.Text := WavFile;
      OpenDlg.FileName := WavFile;
      OpenDlg.Filter := 'Wav files (*.wav)|*.WAV';

      //カーソルを含める
      IncludeCursorCheck.Checked := IncludeCursor;

      //#### 20040512 add Tomneko
      //テキストは追記する
      CB_AppendText.Enabled := TextFileSaveCheck.Checked and CaptureCheck1.Checked;
      CB_AppendText.Checked := AppendText;

      //記録用メモファイル名
      Edit_Memo.Text := FClipSaveMemoFileName;
    end;

    if ClipSaveConfigForm.ShowModal = mrOK then
    begin
      with ClipSaveConfigForm do
      begin
        //保存用ディレクトリの設定
        if not DirectoryExists(BuckupDirEdit.Text) then
        begin
          if MessageDlg('ディレクトリが存在しません。新しく作成しますか?',
                        mtWarning,[mbYes,mbNo],0) = mrYes then
          begin
            //ディレクトリがないので新しく作る
            if not CreateDir(BuckupDirEdit.Text) then
            begin
              ShowMessage('ディレクトリを作成できません');
                          ShowMessage('保存ディレクトリは変更されませんでした');
              BuckupDirEdit.Text := ClipSaveMainForm.SaveFileDir;
            end;
          end else
          begin
            //ディレクトリが無く、作成しないので元のまま
            ShowMessage('保存ディレクトリは変更されませんでした');
            BuckupDirEdit.Text := ClipSaveMainForm.SaveFileDir;
          end;
        end;

        //その他の設定を保存
        //保存先ディレクトリ
        SaveFileDir := BuckupDirEdit.Text;

        //クリップボード連携
        ClipBrdAssociated := CaptureCheck1.Checked;
        //関連するメニューを設定する
        MenuItemClipBoard.Checked := ClipbrdAssociated;
//        MenuItemTextSave.Enabled := ClipbrdAssociated;

        //テキストを保存する
        TextFileSave := TextFileSaveCheck.Checked;

        //画像を保存する（必ず保存）
        PictureSave := True;

        //キャプチャー範囲
        CaptureType := TCaptureType(RG_CaptureType.ItemIndex);

        //メニューを設定する
        MenuItemFS.Checked := (RG_CaptureType.ItemIndex = Ord(capFS));
        MenuItemAW.Checked := (RG_CaptureType.ItemIndex = Ord(capAW));
        MenuItemCA.Checked := (RG_CaptureType.ItemIndex = Ord(capCA));

        //保存ファイル形式
        SaveImgType := TSaveImgType(RG_SaveImgType.ItemIndex);
               
        //画像形式メニューを設定する
        MenuItemJpg.Checked := (RG_SaveImgType.ItemIndex = Ord(sitJpg));
        MenuItemBmp.Checked := (RG_SaveImgType.ItemIndex = Ord(sitBmp));
        MenuItemPng.Checked := (RG_SaveImgType.ItemIndex = Ord(sitPng));

        //保存ファイル名形式
        SaveFileNameType := RG_SaveFileNameType.ItemIndex;

        //接頭辞
        Prefix := Edit_Prefix.Text;

        //ユーザー定義文字列
        FUDef := Edit_UDef.Text;
        Self.FDelimiter := ClipSaveConfigForm.FDelimiter;

        //Jpeg画質
        JpegQuality := SpinEditJpegQ.Value;

        //24bitモード
        ColorMode := ColorModeCheck.Checked;

        //音を鳴らす
        WavEnabled := WavEnabledCheck.Checked;
        if LowerCase(ExtractFileExt(WavFileEdit.Text)) = '.wav' then
          WavFile := WavFileEdit.Text
        else ShowMessage('音を鳴らすファイルがWave形式ではありません');

        //カーソルを含める
        IncludeCursor := IncludeCursorCheck.Checked;
        MenuItemCursor.Checked := IncludeCursor;

        //テキストファイルは追記する
        AppendText := CB_AppendText.Checked;

        //記録用メモファイル名
        FClipSaveMemoFileName := Edit_Memo.Text;
      end;

      //タスクトレイのアイコンを設定する
      UpdateTrayIcon;
    end;
  finally
    ClipSaveConfigForm.Free;
  end;

  IniSave;
end;

//メニュー・バージョン情報の処理
procedure TClipSaveMainForm.MenuItemVersionClick(Sender: TObject);
var
  VersionDlg: TVersionDlg;
begin
  VersionDlg := TVersionDlg.Create(Application);
  try
    VersionDlg.ShowModal;
  finally
    VersionDlg.Free;
  end;
end;

//メニュー・ヘルプの処理
procedure TClipSaveMainForm.MenuItemHelpClick(Sender: TObject);
var
  HelpFile: String;
begin
  // ヘルプファイルのパスを取得（実行ファイルと同じフォルダ）
  HelpFile := ExtractFilePath(Application.ExeName) + 'help.html';
  
  // ファイルが存在するか確認
  if FileExists(HelpFile) then
  begin
    // デフォルトブラウザでヘルプを開く
    ShellExecute(Handle, 'open', PChar(HelpFile), nil, nil, SW_SHOW);
  end
  else
  begin
    ShowMessage('ヘルプファイルが見つかりません:' + #13#10 + HelpFile);
  end;
end;

//メニュー・ImgTypeの処理
procedure TClipSaveMainForm.MenuItemImgTypeClick(Sender: TObject);
var
  idx:Integer;
begin
  idx := (Sender as TComponent).tag;
  MenuItemJpg.Checked := (idx = Ord(sitJpg));
  MenuItemBmp.Checked := (idx = Ord(sitBmp));
  MenuItemPng.Checked := (idx = Ord(sitPng));
  SaveImgType := TSaveImgType(idx);

  IniSave;
end;

//メニュー・CaptureTypeの処理
procedure TClipSaveMainForm.MenuItemCapTypeClick(Sender: TObject);
var
  idx:Integer;
begin
  idx := (Sender as TComponent).tag;
  MenuItemFS.Checked := (idx = Ord(capFS));
  MenuItemAW.Checked := (idx = Ord(capAW));
  MenuItemCA.Checked := (idx = Ord(capCA));
  CaptureType := TCaptureType(idx);

  IniSave;
end;

//メニュー・クリップボードと連携するの処理
procedure TClipSaveMainForm.MenuItemClipBoardClick(Sender: TObject);
begin
  MenuItemClipBoard.Checked := not MenuItemClipBoard.Checked;
  ClipbrdAssociated := MenuItemClipBoard.Checked;

  //連携時の処理
//  MenuItemTextSave.Enabled := ClipbrdAssociated;

  UpdateTrayIcon;

  IniSave;
end;

//メニュー・カーソルを含める
procedure TClipSaveMainForm.MenuItemCursorClick(Sender: TObject);
begin
  MenuItemCursor.Checked := not MenuItemCursor.Checked;
  IncludeCursor := MenuItemCursor.Checked;

  IniSave;
end;

//保存先フォルダを開く処理
procedure TClipSaveMainForm.MenuItemOpenFolderClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',Pchar(SaveFileDir) ,nil,nil,SW_SHOW)
end;

//Iniファイルへの設定情報保存処理
procedure TClipSaveMainForm.IniSave;
var
   IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    IniFile.WriteString('Directory','SaveFileDir',SaveFileDir);
    IniFile.WriteBool('Capture','ClipbrdAssociated',ClipbrdAssociated);
    IniFile.WriteBool('Etc','TextFileSave',TextFileSave);
    IniFile.WriteBool('Etc','PictureSave',PictureSave);
    IniFile.WriteInteger('Capture','CaptureType',Ord(CaptureType));
    IniFile.WriteInteger('Directory','SaveImgType',Ord(SaveImgType));
    IniFile.WriteInteger('Directory','JpegQuality',JpegQuality);
    IniFile.WriteBool('Capture','ColorMode',ColorMode);
    IniFile.WriteInteger('Directory','SaveFileNameType',SaveFileNameType);
    IniFile.WriteString('Directory','Prefix',Prefix);
    IniFile.WriteString('Directory','UDef',FUDef);
    IniFile.WriteString('Directory','Delimiter',FDelimiter);
    IniFile.WriteBool('Capture','WavEnabled',WavEnabled);
    IniFile.WriteString('Capture','WavFile',WavFile);
    IniFile.WriteBool('Capture','IncludeCursor',IncludeCursor);
    IniFile.WriteBool('Capture', 'AppendText', AppendText);
    IniFile.WriteString('Etc', 'ClipSaveMemoFileName', FClipSaveMemoFileName);
  finally
    IniFile.Free;
  end;
end;

//Iniファイルからの設定情報復元処理
procedure TClipSaveMainForm.IniLoad;
var
  IniFile: TIniFile;
begin
  DefaultDir := ExtractFileDir(Application.ExeName)+'\clipfiles';

  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    SaveFileDir := IniFile.ReadString('Directory','SaveFileDir',DefaultDir);
    ClipbrdAssociated := IniFile.ReadBool('Capture','ClipbrdAssociated',False);
    TextFileSave := IniFile.ReadBool('Etc','TextFileSave',True);
    PictureSave := True;  // クリップボード連携時、画像は必ず保存する
    CaptureType := TCaptureType(IniFile.ReadInteger('Capture','CaptureType',0));
    SaveImgType := TSaveImgType(IniFile.ReadInteger('Directory','SaveImgType',0));
    JpegQuality := IniFile.ReadInteger('Directory','JpegQuality',75);
    ColorMode := IniFile.ReadBool('Capture','ColorMode',true);
    SaveFileNameType := IniFile.ReadInteger('Directory','SaveFileNameType',0);
    Prefix := IniFile.ReadString('Directory','Prefix','');
    FUDef  := IniFile.ReadString('Directory','UDef','');
    FDelimiter:=IniFile.ReadString('Directory','Delimiter','');
    WavEnabled := IniFile.ReadBool('Capture','WavEnabled',True);
    // Default WAV file path for Windows 10/11
    WavFile := IniFile.ReadString('Capture','WavFile','C:\Windows\Media\Windows Notify System Generic.wav');
    // Check file existence and set Enabled
    WavEnabled := FileExists(WavFile);
    IncludeCursor := IniFile.ReadBool('Capture','IncludeCursor',False);

    //#### 20040512 add Tomneko #####
    AppendText := IniFile.ReadBool('Capture', 'AppendText', False);

    FClipSaveMemoFileName := IniFile.ReadString('Etc', 'ClipSaveMemoFileName', C_ClipSaveMemoFileName);
  finally
    IniFile.Free;
  end;

end;

//記録用メモの保存処理
procedure TClipSaveMainForm.RecMemo;
var
  SaveFile  : String;
  SaveDir   : String;
  fText     : TextFile;
  TempText  : String;
begin
  //保存用ファイル名の作成
  SaveFile := FClipSaveMemoFileName;
  
  // 相対パスの場合は絶対パスに変換
  SaveDir := ExtractFilePath(SaveFile);
  if SaveDir = '' then
  begin
    // ファイル名のみの場合は、画像保存フォルダを使用
    SaveFile := IncludeTrailingPathDelimiter(SaveFileDir) + SaveFile;
    SaveDir := SaveFileDir;
  end;

  //保存用ファイルで指定されたディレクトリが存在しない場合は作成
  if not DirectoryExists(SaveDir) then
  begin
    if not CreateDir(SaveDir) then Exit;  // ディレクトリ作成失敗時は終了
  end;

  //1行あける
  if TFile.Exists(SaveFile) then
    TFile.AppendAllText(SaveFile, sLineBreak, TEncoding.UTF8);

  //日時を記録する
  TFile.AppendAllText(SaveFile,
          '----- Start ClipSave Memo at ' +
          formatdatetime('yyyy/mm/dd hh:mm:ss', now) +
          ' -----' + sLineBreak, TEncoding.UTF8);

  //内容を記録
  TFile.AppendAllText(SaveFile, F_Memo.Memo.Text + sLineBreak, TEncoding.UTF8);

  //日時を記録する
  TFile.AppendAllText(SaveFile,
          '----- Finish ClipSave Memo' +
            ' -----' + sLineBreak, TEncoding.UTF8);

end;

//タスクトレイアイコンを更新する
procedure TClipSaveMainForm.UpdateTrayIcon;
begin
  if ClipBrdAssociated then
    TrayIcon.IconIndex := 1
  else
    TrayIcon.IconIndex := 0;
end;

//トレイアイコンがクリック（左ボタン）された時の処理
procedure TClipSaveMainForm.TrayIconClick(Sender: TObject);
begin
  F_Memo.MEMO.Clear;

  if (F_Memo.ShowModal = mrOK) then RecMemo;
end;

end.
