# ClipSave - Windows Screen Capture Utility

[![Delphi Version](https://img.shields.io/badge/Delphi-12.3-blue.svg)](https://www.embarcadero.com/products/delphi)
[![Platform](https://img.shields.io/badge/Platform-Win64-blue.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#license)
[![Version](https://img.shields.io/badge/Version-2.0.0-blue.svg)](https://github.com/tomneko/ClipSave/releases)

**ClipSave** は、Windows 画面キャプチャユーティリティです。ホットキー 1 つでスクリーンショットを撮影し、自動的に連番ファイル名で保存します。

## 🎯 Features / 主な機能

### Core Features / 基本機能
- **画面キャプチャ**: ホットキー (`Ctrl+Shift+C`) で即座にキャプチャ
- **3 つのキャプチャモード**:
  - 🖥️ **フルスクリーン**: 仮想スクリーン全体（マルチモニタ対応）
  - 🪟 **アクティブウィンドウ**: フォアグラウンドウィンドウのみ
  - 📄 **クライアント領域**: ウィンドウのクライアント部分のみ
- **3 つの保存形式**: JPEG / BMP / PNG
- **DPI スケーリング完全対応**: Windows 10/11 の 125%/150% 表示でも正確
- **カーソル描画**: カーソルを含めたキャプチャが可能

### Advanced Features / 高度な機能
- **自動ファイル名生成**: `yyyymmdd.nnn.ext` 形式で自動連番
- **カスタムファイル名**: 接頭辞やユーザー定義パターン対応
- **クリップボード連携**: クリップボード監視で自動保存
- **テキストメモ**: タスクトレイアイコン左クリックで簡易メモ入力
- **効果音**: キャプチャ時に WAV ファイル再生
- **タスクトレイ常駐**: 最小限のリソース使用

## 🏗️ Project History / プロジェクト履歴

- **1998年**: Delphi 6 で開発開始（28年前！）
- **2005年**: Vector で v1.0.5 公開
- **2025年**: Delphi 12.3 / RAD Studio 23.0 へ移行
- **2026年**: GitHub で v2.0.0 公開 - Windows 11 完全対応、MIT ライセンス採用
- **開発言語**: Object Pascal (Delphi)
- **ターゲット**: Win64 Release

### Recent Updates / 最近の更新
- **DPI 対応**: Windows 11 の DWM 拡張フレーム、物理解像度取得で完全対応
- **カーソル描画**: 論理座標→物理座標変換で正確なカーソル位置描画
- **ホットキー変更**: `PrintScreen` → `Ctrl+Shift+C` (左手操作対応、"C" for ClipSave)
- **メモ機能修正**: 相対パス対応、ディレクトリ自動作成
- **コードクリーンアップ**: 外部依存削減、URLLabel 削除

## 📦 Installation / インストール

### Binary (Executable) / 実行ファイル
1. `EXE\ClipSave.exe` を任意のフォルダにコピー
2. `ClipSave.exe` を実行
3. タスクトレイにアイコンが表示されます

### Build from Source / ソースからビルド
**前提条件**:
- Delphi 12.3 / RAD Studio 23.0
- Windows 11 (64bit)

**ビルド手順**:
```powershell
# コマンドライン
call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
msbuild ClipSave.dproj /t:Build /p:Config=Release /p:Platform=Win64
```

**出力**: `.\EXE\ClipSave.exe`

## 🚀 Usage / 使い方

### Basic Usage / 基本的な使い方
1. **起動**: `ClipSave.exe` を実行するとタスクトレイに常駐
2. **キャプチャ**: `Ctrl+Shift+C` キーを押す
3. **保存**: 自動的に設定フォルダに保存（デフォルト: `.\clipfiles\`）

### Tray Icon Menu / タスクトレイメニュー
- **左クリック**: メモ入力ダイアログ表示
- **右クリック**: 設定メニュー表示
  - キャプチャモード選択（フルスクリーン/アクティブウィンドウ/クライアント領域）
  - 保存形式選択（JPEG/BMP/PNG）
  - カーソルを含める ON/OFF
  - クリップボード連携 ON/OFF
  - 設定ダイアログ
  - 保存フォルダを開く
  - 終了

### Configuration / 設定
右クリックメニュー → 「設定」 で詳細設定ダイアログを開きます。

**保存設定**:
- 保存先フォルダ
- ファイル名パターン（日付ベース/接頭辞付き/ユーザー定義）
- 保存形式（JPEG/BMP/PNG）
- JPEG 画質（0-100）

**キャプチャ設定**:
- キャプチャ範囲（フルスクリーン/アクティブウィンドウ/クライアント領域）
- カラーモード（24bit BMP）
- カーソルを含める
- 効果音（WAV ファイル）

**クリップボード連携**:
- 画像を保存
- テキストを保存
- テキスト追記モード

**メモ機能**:
- メモ保存ファイル名設定

## 🔧 Technical Details / 技術詳細

### DPI Awareness / DPI 対応
Windows 10/11 の高 DPI 環境（125%/150% 表示）で正確なキャプチャを実現：

- **フルスクリーン**: `GetDeviceCaps(DESKTOPHORZRES/DESKTOPVERTRES)` で物理解像度取得
- **アクティブウィンドウ**: `DwmGetWindowAttribute(DWMWA_EXTENDED_FRAME_BOUNDS)` で正確な境界取得
- **クライアント領域**: `GetSystemMetricsForDpi` + 6px 非公開マージン補正
- **カーソル描画**: 論理座標→物理座標変換（`Physical = Logical × (PhysicalRes / LogicalRes)`）

### Windows APIs / 使用 API
- `BitBlt` - 画面キャプチャ
- `DwmGetWindowAttribute` - DWM 拡張フレーム境界取得
- `GetCursorInfo` / `DrawIconEx` - カーソル描画
- `GetSystemMetricsForDpi` - DPI 対応メトリクス取得
- `RegisterHotKey` - グローバルホットキー登録

### File Structure / ファイル構成
```
ClipSave/
├── ClipSave.dpr           # プログラムエントリーポイント
├── ClipSave.dproj         # プロジェクトファイル
├── ClipSaveMain.pas/dfm   # メインフォーム、キャプチャロジック
├── ClipSaveConfig.pas/dfm # 設定ダイアログ
├── Form_Memo.pas/dfm      # メモ入力フォーム
├── LIB_*.pas              # ユーティリティライブラリ
├── urllabel/              # サードパーティコンポーネント
├── EXE/                   # 実行ファイル出力先
└── DCU/                   # コンパイル済みユニット
```

## 📝 Configuration Files / 設定ファイル

### ClipSave.ini
設定は `ClipSave.ini` に保存されます（実行ファイルと同じフォルダ）。

```ini
[Directory]
SaveFileDir=.\clipfiles
SaveImgType=0              ; 0:JPEG, 1:BMP, 2:PNG
JpegQuality=75             ; 0-100
SaveFileNameType=0         ; 0:yyyymmdd.nnn, 1:Prefix+yyyymmdd.nnn, 2:ユーザー定義
Prefix=                    ; 接頭辞

[Capture]
ClipbrdAssociated=False    ; クリップボード連携
CaptureType=0              ; 0:FullScreen, 1:ActiveWindow, 2:ClientArea
ColorMode=True             ; 24bit BMP モード
WavEnabled=True            ; 効果音
WavFile=C:\Windows\Media\Windows Notify System Generic.wav
IncludeCursor=False        ; カーソルを含める
AppendText=False           ; テキスト追記モード

[Etc]
TextFileSave=True          ; テキスト保存（連携時）
PictureSave=True           ; 画像保存（連携時）
ClipSaveMemoFileName=ClipSaveMemo.txt  ; メモファイル名
```

## 🤝 Credits / クレジット

**開発者**: Tomneko (Hayashi Tsutomu)  
**GitHub**: https://github.com/tomneko/ClipSave  
**不具合報告**: https://github.com/tomneko/ClipSave/issues

### Special Thanks / 謝辞
- **NiftyServe FDELPHI** の皆様
- **のぐ**さん - アイコンデザイン
- ClipSave をご利用いただいている全てのユーザーの皆様

## 📄 License / ライセンス

**MIT License**

Copyright (c) 1998-2026 Tomneko (Hayashi Tsutomu)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🐛 Known Issues / 既知の問題

- 一部の DirectX フルスクリーンアプリケーションではキャプチャできない場合があります
- リモートデスクトップ環境では、一部制限があります

## 🔮 Future Plans / 今後の予定

- [ ] ホットキーのカスタマイズ機能
- [ ] 矩形選択キャプチャモード

---

**ClipSave for Windows** - Since 1998, Still Evolving! 🚀

**v2.0.0 (2026)** - Powered by Delphi 12.3, MIT Licensed, Open Source on GitHub
