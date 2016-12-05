unit osFilterInspectorFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, wwDataInspector, Vcl.Samples.Spin, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin;

type
  TFilterInspectorFrame = class(TFrame)
    DataInspector: TwwDataInspector;
    PesquisarButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtLimit: TSpinEdit;
    MainImageList: TImageList;
    tbrSkip: TToolBar;
    SkipButton: TToolButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
