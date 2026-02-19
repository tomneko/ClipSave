unit LIB_ClipSave_UDef;

interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TEscChar = (ecPrefix,ecDelimiter,ecExt,ecMsec);
  ECreateFileNameErr = class(Exception);

const
  ArEscChar:array[0..3] of char = ('p','r','e','i');
  StrEsc='\';
  MaxItem=6; //0オーダー
  ArItem:array[0..MaxItem] of char=('y','m','d','h','n','s','i');


function ReplaceEscChar
  (EscChar:TEscChar;StrRepl,StrUDef:String):String;
function ReplaceEscChars(StrUdef:String;ArRepl:array of String):String;
function CreateFileName(StrUDef,StrPrefix,StrDelimiter,StrNum:String):String;
function CheckUdefString(StrUdef, StrPrefix, StrDelimiter:String):Boolean;

implementation

//エスケープキャラクターを置換する関数
function ReplaceEscChar
  (EscChar:TEscChar;StrRepl,StrUDef:String):String;
var
  StrTmp:String;
  intEsc:Integer;
begin
  while Pos(StrEsc+ArEscChar[Ord(EscChar)],StrUdef) > 0 do
  begin
    intEsc:=Pos(StrEsc+ArEscChar[Ord(EscChar)],StrUdef);
    StrTmp:=Copy(StrUDef,0,intEsc -1);
    if StrRepl<>'' then
      StrTmp:=StrTmp+'"'+StrRepl+'"';
    StrTmp:=StrTmp+Copy(StrUDef,intEsc+Length(StrEsc+ArEscChar[Ord(EscChar)]),
      Length(StrUdef));
    StrUdef:=StrTmp;
  end;

  Result:=StrUdef;

end;

//エスケープキャラクタを置換する関数の元関数
function ReplaceEscChars(StrUdef:String;ArRepl:array of String):String;
begin
  StrUdef:=ReplaceEscChar(ecPrefix,ArRepl[Ord(ecPrefix)],StrUdef);
  StrUdef:=ReplaceEscChar(ecDelimiter,ArRepl[Ord(ecDelimiter)],StrUdef);
  StrUdef:=ReplaceEscChar(ecExt,ArRepl[Ord(ecExt)],StrUdef);
  StrUdef:=ReplaceEscChar(ecMSec,ArRepl[Ord(ecMSec)],StrUdef);
  Result:=StrUdef;
end;

//ユーザー定義文字列からファイル名を作成する関数
function CreateFileName(StrUDef,StrPrefix,StrDelimiter,StrNum:String):String;
var
  i,j:Integer;
  blItem:Boolean;
  wHour, wMin, wSec, wMs: Word;
begin
  Result := '';

  //設定されたユーザー定義文字列を初期化する
  //すべて小文字に変換し、前後の空白を取り除く
  StrUDef := AnsiLowerCase(Trim(StrUDef));

  //ユーザー定義文字列のチェック
  //有効な文字以外が入力されていないか確認する
  For i:=1 to Length(StrUdef) do
  begin
    if not IsDelimiter('\',StrUdef,i) then
    begin

      blItem:=False;

      //エスケープキャラクタチェック
      For j:=0 to High(ArEscChar) do
      begin
        if StrUdef[i] = ArEscChar[j] then blItem:=True;
      end;//Next j

      //形式文字列チェック
      For j:=0 to High(ArItem) do
      begin
        if StrUdef[i] = ArItem[j] then blItem:=True;
      end;//Next j

      //ArEscChar,ArItemのどれともマッチしない文字がある場合False
      if blItem=False then
      begin
        Application.MessageBox('無効な文字が含まれています','警告',MB_OK);
        Exit;
      end;
    end;
  end;//Next i

  //EscCharsを置換する
  // Get milliseconds from current time
  DecodeTime(Now, wHour, wMin, wSec, wMs);
  StrUdef:=ReplaceEscChars(StrUdef,[StrPrefix,
                                    StrDelimiter,
                                    StrNum,
                                    IntToStr(wMs)]);

  //StrUdefが空文字の場合エラーになるからねぇ
  if (StrUdef <> '') then
    Result:=formatDateTime(StrUDef,Now())
  else
    raise ECreateFileNameErr.Create('ファイ名が生成できません');
end;

function CheckUdefString(StrUdef, StrPrefix, StrDelimiter:String):Boolean;
begin
  Result := True;

  if (StrUdef = '') then
  begin
    ShowMessage('ユーザー定義文字列が空です');
    Result := False;
    Exit;
  end;

  try
    CreateFileName(StrUdef, StrPrefix, StrDelimiter, '001');
  except
    on E:ECreateFileNameErr do
    begin
      ShowMessage('不正なユーザー定義文字列です');
      Result := False;
      Exit;
    end;
  end;
end;
end.
