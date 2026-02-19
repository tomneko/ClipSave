unit Form_Memo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TF_Memo = class(TForm)
    Panel1: TPanel;
    MEMO: TMemo;
    BTN_Commit: TButton;
    BTN_Cancel: TButton;
  private
    { Private éŒ¾ }
  public
    { Public éŒ¾ }
  end;

var
  F_Memo: TF_Memo;

implementation

{$R *.dfm}

{ TF_Memo }

end.
