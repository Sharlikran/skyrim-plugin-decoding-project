{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License,
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit xeMainForm;

{$I xeDefines.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  CommCtrl,
  ExtCtrls,
  ComCtrls,
  StdCtrls,
  Menus,
  Math,
  IniFiles,
  ClipBrd,
  TypInfo,
  ActiveX,
  Buttons,
  ActnList,
  ShellAPI,
  IOUtils,
  Actions,
  System.Generics.Defaults,
  System.Generics.Collections,
{$IFDEF USE_PARALLEL_BUILD_REFS}
  System.Threading,
  System.SyncObjs,
{$ENDIF}
  System.Diagnostics,
  pngimage,
  RegularExpressionsCore,
  VirtualTrees,
  VTEditors,
  VirtualEditTree,
  JvComponentBase,
  ImagingTypes,
  ImagingFormats,
  ImagingCanvases,
  Imaging,
  wbDataFormat,
  wbInterface,
  wbImplementation,
  wbLoadOrder,
  wbBSA,
  wbNifScanner,
  wbLOD,
  wbHelpers,
  xeInit,
  wbLocalization,
  wbModGroups,
  wbHardcoded,
  xeScriptHost,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Styles.Utils.SystemMenu,
  Vcl.Styles.Ext,
  JvBalloonHint, JvExStdCtrls, JvRichEdit, FileContainer, JvExControls,
  JvButton, JvTransparentButton,
  SynEdit, SynMemo, SynEditKeyCmds, Vcl.Mask;

type
  TMemo = class(TSynMemo);

const
  DefaultInterval             = 1 / 24 / 6; // 10 minutes
  MaxSaveListCount            = 5;
  ScriptSelfTerminated        = 'Script terminated itself, Result=';

type
  TDynBooleans = array of Boolean;

  TNavNodeFlag = (
    nnfInjected,
    nnfNotReachable,
    nnfReferencesInjected,
    nnfFilterChecked
  );

  TNavNodeFlags = set of TNavNodeFlag;

  PNavNodeData = ^TNavNodeData;
  TNavNodeData = record
    Element         : IwbElement;
    Container       : IwbContainer;
    ConflictAll     : TConflictAll;
    ConflictThis    : TConflictThis;
    OrgConflictAll  : TConflictAll;
    OrgConflictThis : TConflictThis;
    ElementGen      : Integer;
    ContainerGen    : Integer;
    MissingElements : TDynElements;
    Flags           : TNavNodeFlags;
  end;

  TViewNodeFlag = (
    vnfDontShow,
    vnfIgnore,
    vnfUseSortOrder,
    vnfIsSorted,
    vnfIsAligned,
    vnfIsPartialForm
  );
  TViewNodeFlags = set of TViewNodeFlag;

  PViewNodeData = ^TViewNodeData;
  TViewNodeData = record
    Element: IwbElement;
    Container: IwbContainerElementRef;
    ConflictAll: TConflictAll;
    ConflictThis: TConflictThis;
    ElementGen   : Integer;
    ContainerGen : Integer;
    MissingElements : TDynElements;
    ViewNodeFlags: TViewNodeFlags;
    procedure UpdateRefs;
  end;

  PSpreadSheetNodeData = ^TSpreadSheetNodeData;
  TSpreadSheetNodeData = record
    Element: IwbElement;
  end;

  TViewNodeDatas = array[Word] of TViewNodeData;
  PViewNodeDatas = ^TViewNodeDatas;

  TDynViewNodeDatas = array of TViewNodeData;

  TSpreadSheetNodeDatas = array[Word] of TSpreadSheetNodeData;
  PSpreadSheetNodeDatas = ^TSpreadSheetNodeDatas;

  TDynSpreadSheetNodeDatas = array of TSpreadSheetNodeData;

  TAfterCopyCallback = procedure(const aElement: IwbElement);

  TwbPluggyLinkState = (
    plsNone,
    plsReference,
    plsBase,
    plsInventory,
    plsEnchantment,
    plsSpell
  );

  TPluggyLinkThread = class;

  TwbThread = class(TThread);

  TwbCheckGitHubReleaseThread = class(TwbThread)
    procedure Execute; override;
  end;

  TwbCheckNexusModsReleaseThread = class(TwbThread)
    procedure Execute; override;
  end;

  TLOOTPluginInfo = record
    Plugin: string;
    CRC32: TwbCRC32;
    ITM, UDR, NAV: integer;
  end;
  PLOOTPluginInfo = ^TLOOTPluginInfo;

  TwbSaveResult = (srAllDone, srNothingToDo, srAbort, srError);

  TfrmMain = class(TForm)
    vstNav: TVirtualEditTree;
    splElements: TSplitter;
    pgMain: TPageControl;
    tbsView: TTabSheet;
    tbsMessages: TTabSheet;
    mmoMessages: TMemo;
    tmrStartup: TTimer;
    tmrMessages: TTimer;
    vstView: TVirtualEditTree;
    stbMain: TStatusBar;
    pnlClient: TPanel;
    pnlRight: TPanel;
    pmuNav: TPopupMenu;
    mniNavFilterRemove: TMenuItem;
    mniNavFilterApply: TMenuItem;
    mniNavFilterApplySelected: TMenuItem;
    tbsInfo: TTabSheet;
    Memo1: TMemo;
    mniNavCheckForErrors: TMenuItem;
    tbsReferencedBy: TTabSheet;
    lvReferencedBy: TListView;
    N1: TMenuItem;
    mniNavChangeFormID: TMenuItem;
    pmuView: TPopupMenu;
    mniViewEdit: TMenuItem;
    mniNavChangeReferencingRecords: TMenuItem;
    mniViewRemove: TMenuItem;
    mniViewClear: TMenuItem;
    N2: TMenuItem;
    mniNavBuildRef: TMenuItem;
    mniViewAdd: TMenuItem;
    mniNavRemove: TMenuItem;
    pnlTop: TPanel;
    bnBack: TSpeedButton;
    bnForward: TSpeedButton;
    lblPath: TEdit;
    ActionList1: TActionList;
    acBack: TAction;
    acForward: TAction;
    N3: TMenuItem;
    mniNavCompareTo: TMenuItem;
    mniNavCreateDeltaPatch: TMenuItem;
    odModule: TOpenDialog;
    tbsWEAPSpreadsheet: TTabSheet;
    vstSpreadSheetWeapon: TVirtualEditTree;
    tbsARMOSpreadsheet: TTabSheet;
    tbsAMMOSpreadsheet: TTabSheet;
    vstSpreadsheetArmor: TVirtualEditTree;
    vstSpreadSheetAmmo: TVirtualEditTree;
    pmuSpreadsheet: TPopupMenu;
    mniSpreadsheetRebuild: TMenuItem;
    mniNavAdd: TMenuItem;
    mniNavAddMasters: TMenuItem;
    pmuViewHeader: TPopupMenu;
    mniViewHeaderCopyAsOverride: TMenuItem;
    mniViewHeaderCopyAsOverrideWithOverwriting: TMenuItem;
    mniViewHeaderDeepCopyAsOverride: TMenuItem;
    mniViewHeaderDeepCopyAsOverrideWithOverwriting: TMenuItem;
    mniViewHeaderCopyAsNewRecord: TMenuItem;
    mniNavCopyAsOverride: TMenuItem;
    mniNavCopyAsOverrideWithOverwrite: TMenuItem;
    mniNavDeepCopyAsOverrideWithOverwriting: TMenuItem;
    mniNavCopyAsNewRecord: TMenuItem;
    mniViewHeaderRemove: TMenuItem;
    mniViewHeaderCopyAsWrapper: TMenuItem;
    mniViewHeaderUnhideAll: TMenuItem;
    mniNavCopyAsWrapper: TMenuItem;
    mniViewCopyToSelectedRecords: TMenuItem;
    mniViewCopyMultipleToSelectedRecords: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    mniNavCompareSelected: TMenuItem;
    mniViewSort: TMenuItem;
    tmrCheckUnsaved: TTimer;
    mniViewRemoveFromSelected: TMenuItem;
    pnlNav: TPanel;
    pnlNavContent: TPanel;
    pnlSearch: TPanel;
    pnlNavTopFormID: TPanel;
    edFormIDSearch: TLabeledEdit;
    pnlNavTopEditorID: TPanel;
    edEditorIDSearch: TLabeledEdit;
    mniSpreadsheetCompareSelected: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    mniViewHideNoConflict: TMenuItem;
    mniNavSortMasters: TMenuItem;
    mniNavCleanMasters: TMenuItem;
    ColumnWidths1: TMenuItem;
    mniViewColumnWidthStandard: TMenuItem;
    mniViewColumnWidthFitAll: TMenuItem;
    mniViewColumnWidthFitText: TMenuItem;
    mniViewColumnWidthFitSmart: TMenuItem;
    N10: TMenuItem;
    mniNavHidden: TMenuItem;
    N11: TMenuItem;
    mniViewHeaderHidden: TMenuItem;
    mniViewCompareReferencedRow: TMenuItem;
    mniNavBuildReachable: TMenuItem;
    mniNavCleanupInjected: TMenuItem;
    pmuNavHeaderPopup: TPopupMenu;
    mniNavHeaderFiles: TMenuItem;
    mniNavHeaderFilesDefault: TMenuItem;
    mniNavHeaderFilesLoadOrder: TMenuItem;
    mniNavHeaderFilesFileName: TMenuItem;
    N12: TMenuItem;
    mniViewMoveUp: TMenuItem;
    mniViewMoveDown: TMenuItem;
    mniNavBatchChangeReferencingRecords: TMenuItem;
    odCSV: TOpenDialog;
    mniNavDeepCopyAsOverride: TMenuItem;
    TabSheet2: TTabSheet;
    DisplayPanel: TPanel;
    N5: TMenuItem;
    mniNavCellChildPers: TMenuItem;
    mniNavCellChildTemp: TMenuItem;
    mniNavCellChildNotVWD: TMenuItem;
    mniNavCellChildVWD: TMenuItem;
    pmuRefBy: TPopupMenu;
    mniRefByNotVWD: TMenuItem;
    mniRefByVWD: TMenuItem;
    mniNavRemoveIdenticalToMaster: TMenuItem;
    mniNavRemoveIdenticalToMasterObsolete: TMenuItem;
    N14: TMenuItem;
    mniRefByCopyOverrideInto: TMenuItem;
    mniRefByCopyOverrideIntoWithOverwriting: TMenuItem;
    mniRefByDeepCopyOverrideInto: TMenuItem;
    mniRefByDeepCopyOverrideIntoWithOverwriting: TMenuItem;
    mniRefByCopyAsNewInto: TMenuItem;
    mniNavSetVWDAuto: TMenuItem;
    mniNavSetVWDAutoInto: TMenuItem;
    N15: TMenuItem;
    mniNavGenerateLOD: TMenuItem;
    N16: TMenuItem;
    mniNavTest: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    mniNavCheckForCircularLeveledLists: TMenuItem;
    mniMainPluggyLink: TMenuItem;
    mniMainPluggyLinkDisabled: TMenuItem;
    mniMainPluggyLinkReference: TMenuItem;
    mniMainPluggyLinkBaseObject: TMenuItem;
    mniMainPluggyLinkInventory: TMenuItem;
    mniMainPluggyLinkSpell: TMenuItem;
    mniMainPluggyLinkEnchantment: TMenuItem;
    mniNavBanditFix: TMenuItem;
    N20: TMenuItem;
    mniRefByRemove: TMenuItem;
    mniNavRaceLVLIs: TMenuItem;
    mniRefByCopyDisabledOverrideInto: TMenuItem;
    mniNavCopyAsSpawnRateOverride: TMenuItem;
    pmuNavAdd: TPopupMenu;
    mniNavUndeleteAndDisableReferences: TMenuItem;
    mniNavUndeleteAndDisableReferencesObsolete: TMenuItem;
    mniNavMarkModified: TMenuItem;
    mniNavCreateMergedPatch: TMenuItem;
    mniNavCopyIdle: TMenuItem;
    mniNavRenumberFormIDsFrom: TMenuItem;
    mniNavCompactFormIDs: TMenuItem;
    mniNavRenumberFormIDsInject: TMenuItem;
    tmrGenerator: TTimer;
    mniNavLocalizationSwitch: TMenuItem;
    mniNavLocalization: TMenuItem;
    mniMainLocalizationEditor: TMenuItem;
    mniMainLocalization: TMenuItem;
    mniMainLocalizationLanguage: TMenuItem;
    mniNavFilterForCleaning: TMenuItem;
    mniNavFilterForCleaningSelected: TMenuItem;
    mniNavFilterForCleaningObsolete: TMenuItem;
    mniNavFilterForCleaningSelectedObsolete: TMenuItem;
    mniNavCreateSEQFile: TMenuItem;
    mniNavApplyScript: TMenuItem;
    mniNavOptions: TMenuItem;
    mniNavLogAnalyzer: TMenuItem;
    mniNavOther: TMenuItem;
    N13: TMenuItem;
    mniRefByMarkModified: TMenuItem;
    mniViewNextMember: TMenuItem;
    mniViewPreviousMember: TMenuItem;
    mniViewHeaderJumpTo: TMenuItem;
    acScript: TAction;
    mniNavFilterConflicts: TMenuItem;
    mniNavFilterConflictsSelected: TMenuItem;
    mniModGroups: TMenuItem;
    mniModGroupsEnabled: TMenuItem;
    mniModGroupsDisabled: TMenuItem;
    mniMasterAndLeafs: TMenuItem;
    mniMasterAndLeafsEnabled: TMenuItem;
    mniMasterAndLeafsDisabled: TMenuItem;
    mniNavOtherCodeSiteLogging: TMenuItem;
    mniNavLOManagersDirtyInfo: TMenuItem;
    N19: TMenuItem;
    mniViewStick: TMenuItem;
    mniViewStickAuto: TMenuItem;
    mniViewStickSelected: TMenuItem;
    mniViewSetToDefault: TMenuItem;
    mniRefByCompareSelected: TMenuItem;
    N33: TMenuItem;
    mniRefByApplyScript: TMenuItem;
    pmuMessages: TPopupMenu;
    mniMessagesAutoscroll: TMenuItem;
    mniMessagesClear: TMenuItem;
    N21: TMenuItem;
    mniMessagesSaveSelected: TMenuItem;
    pnlNavBottom: TPanel;
    edFileNameFilter: TLabeledEdit;
    pnlViewTop: TPanel;
    lblFilterHint: TLabel;
    N22: TMenuItem;
    mniViewModGroupsReload: TMenuItem;
    N23: TMenuItem;
    mniNavCreateModGroup: TMenuItem;
    mniNavUpdateCRCModGroups: TMenuItem;
    N24: TMenuItem;
    mniViewCreateModGroup: TMenuItem;
    mniNavEditModGroup: TMenuItem;
    mniNavDeleteModGroups: TMenuItem;
    tmrUpdateColumnWidths: TTimer;
    tmrPendingSetActive: TTimer;
    fpnlViewFilter: TFlowPanel;
    lblViewFilterName: TLabel;
    edViewFilterName: TEdit;
    cobViewFilter: TComboBox;
    lblViewFilterValue: TLabel;
    edViewFilterValue: TEdit;
    fpnlViewFilterKeep: TFlowPanel;
    lblViewFilterKeep: TLabel;
    cbViewFilterKeepChildren: TCheckBox;
    cbViewFilterKeepSiblings: TCheckBox;
    cbViewFilterKeepParentsSiblings: TCheckBox;
    pnlViewTopLegend: TPanel;
    bnLegend: TSpeedButton;
    bnMainMenu: TSpeedButton;
    bnHelp: TSpeedButton;
    bnVideos: TSpeedButton;
    bnNexusMods: TSpeedButton;
    bnGitHub: TSpeedButton;
    bnDiscord: TSpeedButton;
    bnPatreon: TSpeedButton;
    bnKoFi: TSpeedButton;
    bnPayPal: TSpeedButton;
    jbhPatreon: TJvBalloonHint;
    jbhGitHub: TJvBalloonHint;
    jbhNexusMods: TJvBalloonHint;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    tbsWhatsNew: TTabSheet;
    pmuMain: TPopupMenu;
    mniMainOptions: TMenuItem;
    N30: TMenuItem;
    fcWhatsNew: TFileContainer;
    N31: TMenuItem;
    mniMainSave: TMenuItem;
    jbhSave: TJvBalloonHint;
    tmrShutdown: TTimer;
    mniMarkallfileswithoutONAMasmodified: TMenuItem;
    mniNavHeaderINFO: TMenuItem;
    mniNavHeaderINFObyFormID: TMenuItem;
    mniNavHeaderINFObyPreviousINFO: TMenuItem;
    pnlBtn: TPanel;
    pmuBtnMenu: TPopupMenu;
    mniBtnShrinkButtons: TMenuItem;
    mniViewClipboard: TMenuItem;
    mniViewClipboardSeparator: TMenuItem;
    mniCopyPathToClipboard: TMenuItem;
    mniCopyFullPathToClipboard: TMenuItem;
    mniCopyIndexedPathToClipboard: TMenuItem;
    mniClipboardSeparator: TMenuItem;
    mniCopyNameToClipboard: TMenuItem;
    mniCopyDisplayNameToClipboard: TMenuItem;
    mniCopyShortNameToClipboard: TMenuItem;
    mniCopySignatureToClipboard: TMenuItem;
    mniCopyPathNameToClipboard: TMenuItem;
    N32: TMenuItem;
    mniCreateNewFile: TMenuItem;
    pnlCancel: TPanel;
    btnCancel: TButton;
    bnPinned: TSpeedButton;

    {--- Form ---}
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure splElementsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    {--- pgMain ---}
    procedure tbsMessagesShow(Sender: TObject);
    procedure tbsViewShow(Sender: TObject);
    procedure tbsSpreadsheetShow(Sender: TObject);

    {--- Timer ---}
    procedure tmrStartupTimer(Sender: TObject);
    procedure tmrMessagesTimer(Sender: TObject);
    procedure tmrCheckUnsavedTimer(Sender: TObject);

    {--- lvReferencedBy ---}
    procedure lvReferencedByDblClick(Sender: TObject);
    procedure lvReferencedByKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    {--- edFormIDSearch ---}
    procedure edFormIDSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edFormIDSearchChange(Sender: TObject);
    procedure edFormIDSearchEnter(Sender: TObject);

    {--- edEditorIDSearch ---}
    procedure edEditorIDSearchChange(Sender: TObject);
    procedure edEditorIDSearchEnter(Sender: TObject);
    procedure edEditorIDSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    {--- vstNav ---}
    procedure vstNavBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure vstNavChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstNavCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstNavDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstNavDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure vstNavExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure vstNavFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vstNavFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstNavGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstNavHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure vstNavIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure vstNavInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstNavInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstNavKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstNavPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);

    {--- pmuNavPopup ---}
    procedure pmuNavPopup(Sender: TObject);
    procedure mniNavAddClick(Sender: TObject);
    procedure mniNavAddMastersClick(Sender: TObject);
    procedure mniNavCleanMastersClick(Sender: TObject);
    procedure mniNavSortMastersClick(Sender: TObject);
    procedure mniNavBatchChangeReferencingRecordsClick(Sender: TObject);
    procedure mniNavBuildReachableClick(Sender: TObject);
    procedure mniNavBuildRefClick(Sender: TObject);
    procedure mniNavChangeFormIDClick(Sender: TObject);
    procedure mniNavChangeReferencingRecordsClick(Sender: TObject);
    procedure mniNavCheckForErrorsClick(Sender: TObject);
    procedure mniNavCleanupInjectedClick(Sender: TObject);
    procedure mniNavCellChild(Sender: TObject);
    procedure mniNavCompareSelectedClick(Sender: TObject);
    procedure mniNavCompareToClick(Sender: TObject);
    procedure mniNavCreateDeltaPatchClick(Sender: TObject);
    procedure mniNavCopyIntoClick(Sender: TObject);
    procedure mniNavFilterApplyClick(Sender: TObject);
    procedure mniNavFilterRemoveClick(Sender: TObject);
    procedure mniNavGenerateLODClick(Sender: TObject);
    procedure mniNavHiddenClick(Sender: TObject);
    procedure mniNavRemoveClick(Sender: TObject);
    procedure mniNavRemoveIdenticalToMasterClick(Sender: TObject);
    procedure mniNavSetVWDAutoClick(Sender: TObject);
    procedure mniNavSetVWDAutoIntoClick(Sender: TObject);

    {--- pmuNavHeaderPopup ---}
    procedure mniNavHeaderFilesClick(Sender: TObject);

    {--- vstView ---}
    procedure vstViewAdvancedHeaderDraw(Sender: TVTHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
    procedure vstViewBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstViewBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure vstViewCheckHotTrack(Sender: TBaseVirtualTree; HotNode: PVirtualNode; HotColumn: TColumnIndex; var Allow: Boolean);
    procedure vstViewClick(Sender: TObject);
    procedure vstViewCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure vstViewDblClick(Sender: TObject);
    procedure vstViewDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstViewDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstViewDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure vstViewEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstViewFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vstViewFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure vstViewFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstViewGetEditText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var CellText: string);
    procedure vstViewGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstViewHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure vstViewHeaderDropped(Sender: TVTHeader; SourceColumn, TargetColumn: TColumnIndex; var Handled: Boolean);
    procedure vstViewHeaderDrawQueryElements(Sender: TVTHeader; var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
    procedure vstViewHeaderMouseDown(Sender: TVTHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vstViewHeaderMouseMove(Sender: TVTHeader; Shift: TShiftState; X, Y: Integer);
    procedure vstViewInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure vstViewInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstViewNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstViewPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstViewResize(Sender: TObject);
    procedure vstViewCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstViewKeyPress(Sender: TObject; var Key: Char);
    procedure vstViewDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; var CellRect: TRect; var DefaultDraw: Boolean);
    procedure vstViewMeasureTextWidth(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; var Extent: Integer);
    procedure vstViewShortenString(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;  Column: TColumnIndex; const S: string; TextSpace: Integer; var Result: string; var Done: Boolean);

    {--- pmuViewPopup ---}
    procedure pmuViewPopup(Sender: TObject);
    procedure mniViewAddClick(Sender: TObject);
    procedure mniViewColumnWidthClick(Sender: TObject);
    procedure mniViewCompareReferencedRowClick(Sender: TObject);
    procedure mniViewCopyToSelectedRecordsClick(Sender: TObject);
    procedure mniViewCopyMultipleToSelectedRecordsClick(Sender: TObject);
    procedure mniViewEditClick(Sender: TObject);
    procedure mniViewHideNoConflictClick(Sender: TObject);
    procedure mniViewMoveUpClick(Sender: TObject);
    procedure mniViewMoveDownClick(Sender: TObject);
    procedure mniViewRemoveClick(Sender: TObject);
    procedure mniViewClearClick(Sender: TObject);
    procedure mniViewRemoveFromSelectedClick(Sender: TObject);
    procedure mniViewSortClick(Sender: TObject);

    {--- pmuViewHeaderPopup ---}
    procedure pmuViewHeaderPopup(Sender: TObject);
    procedure mniViewHeaderJumpToClick(Sender: TObject);
    procedure mniViewHeaderCopyIntoClick(Sender: TObject);
    procedure mniViewHeaderRemoveClick(Sender: TObject);
    procedure mniViewHeaderHiddenClick(Sender: TObject);
    procedure mniViewHeaderUnhideAllClick(Sender: TObject);

    {--- pmuRefByPopup ---}
    procedure pmuRefByPopup(Sender: TObject);
    procedure mniRefByVWDClick(Sender: TObject);
    procedure mniRefByCopyIntoClick(Sender: TObject);
    procedure mniRefByRemoveClick(Sender: TObject);

    {--- vstSpreadSheet ---}
    procedure vstSpreadSheetWeaponInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSpreadsheetArmorInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vstSpreadSheetAmmoInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);

    procedure vstSpreadSheetCheckHotTrack(Sender: TBaseVirtualTree; HotNode: PVirtualNode; HotColumn: TColumnIndex; var Allow: Boolean);
    procedure vstSpreadSheetClick(Sender: TObject);
    procedure vstSpreadSheetCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstSpreadSheetDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSpreadSheetDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstSpreadSheetDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure vstSpreadSheetEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstSpreadSheetFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstSpreadSheetGetEditText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var CellText: string);
    procedure vstSpreadSheetGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstSpreadSheetIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure vstSpreadSheetNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstSpreadSheetPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);

    {--- pmuSpreadSheet ---}
    procedure pmuSpreadsheetPopup(Sender: TObject);
    procedure mniSpreadsheetCompareSelectedClick(Sender: TObject);
    procedure mniSpreadsheetRebuildClick(Sender: TObject);

    {--- actions ---}
    function GetFocusedViewElementSafely: IwbElement;
    function GetFocusedNavElementSafely: IwbElement;

    procedure TryViewOrCompareSelectedRecords(aElement: IwbElement);

    procedure acBackUpdate(Sender: TObject);
    procedure acBackExecute(Sender: TObject);

    procedure acForwardUpdate(Sender: TObject);
    procedure acForwardExecute(Sender: TObject);
    procedure mniNavCheckForCircularLeveledListsClick(Sender: TObject);
    procedure mniMainPluggyLinkClick(Sender: TObject);
    procedure mniNavBanditFixClick(Sender: TObject);
    procedure mniNavRaceLVLIsClick(Sender: TObject);
    procedure mniRefByCopyDisabledOverrideIntoClick(Sender: TObject);
    procedure lvReferencedByColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvReferencedByCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure mniNavUndeleteAndDisableReferencesClick(Sender: TObject);
    procedure mniNavMarkModifiedClick(Sender: TObject);
    procedure mniNavCreateMergedPatchClick(Sender: TObject);
    procedure mniNavTestClick(Sender: TObject);
    procedure mniNavCopyIdleClick(Sender: TObject);
    procedure mniNavRenumberFormIDsFromClick(Sender: TObject);
    procedure tmrGeneratorTimer(Sender: TObject);
    procedure mmoMessagesDblClick(Sender: TObject);
    procedure mniMainLocalizationEditorClick(Sender: TObject);
    procedure mniNavLocalizationSwitchClick(Sender: TObject);
    procedure mniMainLocalizationLanguageClick(Sender: TObject);
    procedure mniNavFilterForCleaningClick(Sender: TObject);
    procedure mniNavCleaningObsoleteClick(Sender: TObject);
    procedure mniNavFilterForOnlyOneClick(Sender: TObject);
    procedure mniNavCreateSEQFileClick(Sender: TObject);
    procedure mniNavApplyScriptClick(Sender: TObject);
    procedure mniNavOptionsClick(Sender: TObject);
    procedure mniNavLogAnalyzerClick(Sender: TObject);
    procedure mniRefByMarkModifiedClick(Sender: TObject);
    procedure mniViewNextMemberClick(Sender: TObject);
    procedure mniViewPreviousMemberClick(Sender: TObject);
    procedure acScriptExecute(Sender: TObject);
    procedure mniNavFilterConflictsClick(Sender: TObject);
    procedure mniModGroupsAbleClick(Sender: TObject);
    procedure mniMasterAndLeafsClick(Sender: TObject);
    procedure vstSpreadSheetCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure mniNavOtherCodeSiteLoggingClick(Sender: TObject);
    procedure mniNavLOManagersDirtyInfoClick(Sender: TObject);
    procedure mniViewStickAutoClick(Sender: TObject);
    procedure mniViewStickSelectedClick(Sender: TObject);
    procedure mniViewSetToDefaultClick(Sender: TObject);
    procedure mniRefByCompareSelectedClick(Sender: TObject);
    procedure mniMessagesClearClick(Sender: TObject);
    procedure mniMessagesSaveSelectedClick(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure edFileNameFilterChange(Sender: TObject);
    procedure edFileNameFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstNavKeyPress(Sender: TObject; var Key: Char);
    procedure edViewFilterChange(Sender: TObject);
    procedure edViewFilterNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlNavResize(Sender: TObject);
    procedure mniViewModGroupsReloadClick(Sender: TObject);
    procedure mniModGroupsClick(Sender: TObject);
    procedure mniNavCreateModGroupClick(Sender: TObject);
    procedure mniNavUpdateCRCModGroupsClick(Sender: TObject);
    procedure mniNavEditModGroupClick(Sender: TObject);
    procedure mniNavDeleteModGroupsClick(Sender: TObject);
    procedure edFilterNoBeepOnEnterKeyPress(Sender: TObject; var Key: Char);
    procedure tmrUpdateColumnWidthsTimer(Sender: TObject);
    procedure vstViewScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: Integer);
    procedure bnHelpClick(Sender: TObject);
    procedure bnVideosClick(Sender: TObject);
    procedure bnNexusModsClick(Sender: TObject);
    procedure bnGitHubClick(Sender: TObject);
    procedure bnDiscordClick(Sender: TObject);
    procedure bnPatreonClick(Sender: TObject);
    procedure bnKoFiClick(Sender: TObject);
    procedure bnPayPalClick(Sender: TObject);
    procedure tmrPendingSetActiveTimer(Sender: TObject);
    procedure bnLegendClick(Sender: TObject);
    procedure vstViewCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstViewExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure fpnlViewFilterResize(Sender: TObject);
    procedure jbhPatreonBalloonClick(Sender: TObject);
    procedure jbhGitHubBalloonClick(Sender: TObject);
    procedure jbhNexusModsBalloonClick(Sender: TObject);
    procedure jbhPatreonCloseBtnClick(Sender: TObject; var CanClose: Boolean);
    procedure jbhGitHubCloseBtnClick(Sender: TObject; var CanClose: Boolean);
    procedure jbhNexusModsCloseBtnClick(Sender: TObject; var CanClose: Boolean);
    procedure pmuMainPopup(Sender: TObject);
    procedure bnMainMenuMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bnPinnedClick(Sender: TObject);
    procedure mniMainSaveClick(Sender: TObject);
    procedure jbhSaveBalloonClick(Sender: TObject);
    procedure jbhSaveCloseBtnClick(Sender: TObject; var CanClose: Boolean);
    procedure tmrShutdownTimer(Sender: TObject);
    procedure mniMarkallfileswithoutONAMasmodifiedClick(Sender: TObject);
    procedure mniNavHeaderINFOClick(Sender: TObject);
    procedure pmuNavHeaderPopupPopup(Sender: TObject);
    procedure pmuBtnMenuPopup(Sender: TObject);
    procedure mniBtnShrinkButtonsClick(Sender: TObject);
    procedure mniViewClipboardClick(Sender: TObject);
    procedure mniCopyPathToClipboardClick(Sender: TObject);
    procedure mniCopyFullPathToClipboardClick(Sender: TObject);
    procedure mniCopyIndexedPathToClipboardClick(Sender: TObject);
    procedure mniCopyNameToClipboardClick(Sender: TObject);
    procedure mniCopyDisplayNameToClipboardClick(Sender: TObject);
    procedure mniCopyShortNameToClipboardClick(Sender: TObject);
    procedure mniCopySignatureToClipboardClick(Sender: TObject);
    procedure mniCopyPathNameToClipboardClick(Sender: TObject);
    procedure mniCreateNewFileClick(Sender: TObject);

    procedure btnCancelClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    OverrideViewFocusedNode: PVirtualNode;
    function GetViewFocusedNode: PVirtualNode;
    procedure SetViewFocusedNode(aNode: PVirtualNode);
    property vstViewFocusedNode: PVirtualNode
      read GetViewFocusedNode
      write SetViewFocusedNode;
  protected
    function IsViewNodeFiltered(aNode: PVirtualNode): Boolean;
    procedure ApplyViewFilter;
    procedure SetSaveInterval;

    procedure ExpandButtons;
    procedure ShrinkButtons;
  public
    BackHistory: IInterfaceList;
    ForwardHistory: IInterfaceList;
  protected
    EditWarnOk: Boolean;
    SaveInterval: TDateTime;
    LastViewColumn: TColumnIndex;
    HideNoConflict: Boolean;
    UserWasActive: Boolean;
    TotalUsageTime: TDateTime;
    RateNoticeGiven: Integer;
    ReachableBuild: Boolean;
    ReferencedBySortColumn: TListColumn;

    FocusedColumnOverride : Integer;

    EditInfoCacheLGeneration: Integer;
    EditInfoCache: TArray<string>;
    EditInfoCacheID: Pointer;

    vstNavInitChildrenGeneration: UInt64;
    vstNavLastCollapsedChildrenCleanup: UInt64;
    vstNavLastChangeNode: Pointer;

    vstNavLastCheckedForChanges : UInt64;
    vstNavReInit : Boolean;
    NavFocusedElement : IwbElement;

    HideRemoveMessage : Boolean;

    GitHubVersion  : TwbVersion;
    ShowGitHubHint : TDateTime;

    NexusModsVersion  : TwbVersion;
    ShowNexusModsHint : TDateTime;

    function GetRefBySelectionAsMainRecords: TDynMainRecords;
    function GetRefBySelectionAsElements: TDynElements;

    procedure DoGenerateLOD;
    procedure DoRunScript;

    function CopyInto(AsNew, AsWrapper, AsSpawnRate, DeepCopy, AllowOverwrite: Boolean; const aElements: TDynElements; aAfterCopyCallback: TAfterCopyCallback = nil): TDynElements;
    procedure AddNewFileWithDialog;

    procedure BuildAllRef;
    procedure ResetAllTags;

    procedure UpdatePnlCancelPosition;
    procedure UpdatePnlCancelVisible;
  public
    procedure ConflictLevelForMainRecord(const aMainRecord: IwbMainRecord; out aConflictAll: TConflictAll; out aConflictThis: TConflictThis);
    procedure ConflictLevelForContainer(const aContainer: IwbDataContainer; out aConflictAll: TConflictAll; out aConflictThis: TConflictThis);
    function ConflictLevelForChildNodeDatas(const aNodeDatas: TDynViewNodeDatas; aSiblingCompare, aInjected: Boolean): TConflictAll;
    function ConflictLevelForNodeDatas(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer; aSiblingCompare, aInjected: Boolean): TConflictAll;
  protected

    function GetUniqueLinksTo(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer): TDynMainRecords;

    procedure InitChildren(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer; var aChildCount: Cardinal);
    procedure InitNodes(const aNode: PVirtualNode; const aNodeDatas, aParentDatas: PViewNodeDatas; aNodeCount: Integer; aIndex: Cardinal; var aInitialStates: TVirtualNodeInitStates);
    procedure InitConflictStatus(aNode: PVirtualNode; aInjected: Boolean; aNodeDatas: PViewNodeDatas = nil);
    procedure InheritStateFromChildren(Node: PVirtualNode; NodeData: PNavNodeData);

    function NodeDatasForMainRecord(const aMainRecord: IwbMainRecord): TDynViewNodeDatas;
    function NodeDatasForContainer(const aContainer: IwbDataContainer): TDynViewNodeDatas;

    procedure ShowChangeReferencedBy(OldFormID: TwbFormID; NewFormID: TwbFormID; const ReferencedBy: TDynMainRecords; aSilent: Boolean);
    function GetTargetElement(Target: TBaseVirtualTree; var TargetNode: PVirtualNode; TargetColumn: Integer; out TargetIndex: Integer; out TargetElement: IwbElement): Boolean;
    function PerformDrop(TargetTree: TBaseVirtualTree; TargetNode: PVirtualNode; TargetColumn: Integer; const SourceElement: IwbElement): Boolean;
    function GetSourceElement(Source: TObject; out SourceElement: IwbElement): Boolean;

    function GetAddElement(out TargetNode: PVirtualNode; out TargetIndex: Integer; out TargetElement: IwbElement): Boolean;

    procedure ClearConflict(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);

    procedure InvalidateElementsTreeView(aNodes: TNodeArray); overload;
    procedure InvalidateElementsTreeView; overload;
    procedure ResetAllConflict;
    procedure ResetActiveTree;
    procedure ExpandView;
    function CollectViewContainers: TwbContainerElementRefs;
    procedure NavCleanupCollapsedNodeChildren;
    function NavCheckForChanges: Boolean;

    procedure NavUpdate(aForce: Boolean);

  public
    function AddRequiredMaster(const aMasterFile: IwbFile; const aTargetFile: IwbFile): Boolean;
    function AddRequiredMasters(const aSourceElement: IwbElement; const aTargetFile: IwbFile; aAsNew: Boolean; aSilent: Boolean = False): Boolean; overload;
    function AddRequiredMasters(aMasters: TStrings; const aTargetFile: IwbFile; aSilent: Boolean = False): Boolean; overload;
  protected

    function CheckForErrorsLinear(const aElement: IwbElement; LastRecord: IwbMainRecord): IwbMainRecord;
    function CheckForErrors(const aIndent: Integer; const aElement: IwbElement): Boolean;

  public
    function AddNewFileName(aFileName: string; aIsLight, aIsMedium: Boolean): IwbFile; overload;
    function AddNewFileName(aFileName: string; aTemplate: PwbModuleInfo): IwbFile; overload;
    function AddNewFile(out aFile: IwbFile; aIsLight, aIsMedium: Boolean): Boolean; overload;
    function AddNewFile(out aFile: IwbFile; aTemplate: PwbModuleInfo): Boolean; overload;

    function SaveChanged(aSilent: Boolean = False; aShowMessageIfNothing: Boolean = False): TwbSaveResult;
    procedure JumpTo(aInterface: IInterface; aBackward: Boolean);
    function FindNodeForElement(const aElement: IwbElement): PVirtualNode;
    function FindNodeOrAncestorForElement(const aElement: IwbElement): PVirtualNode;
    function FindNodeForElementIn(aParent: PVirtualNode; const aElement: IwbElement): PVirtualNode;
    function EditWarn: Boolean;
    function RemovableSelection(ContainsChilds: PBoolean): TNodeArray;
    function EditableSelection(ContainsChilds: PBoolean): TNodeArray;

    function SelectionIncludesNonCopyNewRecords: Boolean;
    function SelectionIncludesAnyDeepCopyRecords: Boolean;
    function SelectionIncludesOnlyDeepCopyRecords: Boolean;

    function ByRefSelectionIncludesNonCopyNewRecords(aSelection: TDynMainRecords): Boolean;
    function ByRefSelectionIncludesAnyDeepCopyRecords(aSelection: TDynMainRecords): Boolean;
    function ByRefSelectionIncludesOnlyDeepCopyRecords(aSelection: TDynMainRecords): Boolean;

    function SelectionIncludesOnlyREFR(Selection: TNodeArray): Boolean;
    function SelectionIncludesAnyNotVWD(Selection: TNodeArray): Boolean;
    function SelectionIncludesAnyVWD(Selection: TNodeArray): Boolean;
    procedure CheckHistoryRemove(const aList: IInterfaceList; const aMainRecord: IwbMainRecord);
  protected
    procedure UpdateColumnWidths;
    procedure SetDefaultNodeHeight(aHeight: Integer);

    function SetAllToMaster: Boolean;
    function UpdateAllOnam: Boolean;
    function RestorePluginsFromMaster: Boolean;
    procedure ApplyScriptToSelection(aSelection: TNodeArray; aCount: Cardinal; const abShowMessages: boolean); overload;
    procedure ApplyScriptToSelection(aSelection: TDynElements; aCount: Cardinal; const abShowMessages: boolean); overload;
    procedure ApplyScript(const aScriptName: string; aScript: string; aRefByMode: Boolean = False);
    procedure CreateActionsForScripts;
    function LOOTDirtyInfo(const aInfo: TLOOTPluginInfo; aFileChanged: Boolean): string;
    function BOSSDirtyInfo(const aInfo: TLOOTPluginInfo): string;

    procedure PerformLongAction(const aDesc, aProgress: string; const aAction: TProc);
    procedure PerformActionOnSelectedFiles(const aDesc: string; const aAction: TProc<IwbFile>);

    procedure LoadModGroupsSelection(const aModGroups: TwbModGroupPtrs);
    procedure SaveModGroupsSelection(const aModGroups: TwbModGroupPtrs);

    function FindColors(const s: string; out aColors: TArray<TColor>): Boolean;
  private
    procedure WMUser(var Message: TMessage); message WM_USER;
    procedure WMUser1(var Message: TMessage); message WM_USER + 1;
    procedure WMUserLoaderDone(var Message: TMessage); message WM_USER + 2;
    procedure WMUser3(var Message: TMessage); message WM_USER + 3;
    procedure WMUser4(var Message: TMessage); message WM_USER + 4;
    procedure WMUser5(var Message: TMessage); message WM_USER + 5;
    procedure WndProc(var Message: TMessage); override;
    procedure UpdateTreeLineColor;
  public
    Files: TwbFiles;
  private
    NewMessages: TStringList;
    ActiveIndex: TColumnIndex;
    ActiveRecordLock: Integer;
    ActiveRecord: IwbMainRecord;
    ActiveMaster: IwbMainRecord;
    ActiveRecords: TDynViewNodeDatas;
    ActiveContainer: IwbDataContainer;
    ViewFocusedElement : IwbElement;
    EditAddedElement: Boolean;
    EditFocusedViewElement: Boolean;
    NodeForViewFocusedElement: PVirtualNode;
    ColumnForViewFocusedElement: Integer;
    LoaderStarted: Boolean;
    ModGroupsExist : Boolean;
    ModGroupsEnabled : Boolean;
    NewModGroupName: string;
    OnlyShowMasterAndLeafs: Boolean;
    ShowUnsavedHint: Boolean;
    ScriptRunning: Boolean;
    ParentedGroupRecordType: set of Byte;
    RebuildingViewTree: Boolean;
    DelayedExpandView: Boolean;

  public
    FilterPreset: Boolean; // new: flag to skip filter window
    FilterScripted: Boolean; // new: flag to use scripted filtering function
    FilterApplied: Boolean;
    FilterNoGameMaster: Boolean;
    FilterConflictOnly: Boolean;
    FilterOnlyOne: Boolean;

    FilterConflictAll: Boolean;
    FilterConflictAllSet: TConflictAllSet;

    FilterConflictThis: Boolean;
    FilterConflictThisSet: TConflictThisSet;

    FilterByInjectStatus: Boolean;
    FilterInjectStatus: Boolean;

    FilterByNotReachableStatus: Boolean;
    FilterNotReachableStatus: Boolean;

    FilterByReferencesInjectedStatus: Boolean;
    FilterReferencesInjectedStatus: Boolean;

    FilterByEditorID: Boolean;
    FilterEditorID: string;

    FilterByElementValue: Boolean;
    FilterElementValue: string;

    FilterByName: Boolean;
    FilterName: string;

    FilterByBaseEditorID: Boolean;
    FilterBaseEditorID: string;

    FilterByBaseName: Boolean;
    FilterBaseName: string;

    FilterScaledActors: Boolean;

    FilterBySignature: Boolean;
    FilterSignatures: string;

    FilterByBaseSignature: Boolean;
    FilterBaseSignatures: string;

    FilterByPersistent: Boolean;
    FilterPersistent: Boolean;
    FilterUnnecessaryPersistent: Boolean;
    FilterMasterIsTemporary: Boolean;
    FilterIsMaster: Boolean;
    FilterPersistentPosChanged: Boolean;
    FilterDeleted: Boolean;

    FilterByVWD: Boolean;
    FilterVWD: Boolean;

    FilterByHasVWDMesh: Boolean;
    FilterHasVWDMesh: Boolean;

    FilterByHasPrecombinedMesh: Boolean;
    FilterHasPrecombinedMesh: Boolean;

    FlattenBlocks: Boolean;
    FlattenCellChilds: Boolean;
    AssignPersWrldChild: Boolean;
    InheritConflictByParent: Boolean;
  private
    InitStarted: Boolean;
    GeneratorStarted: Boolean;
    GeneratorDone: Boolean;

    ComparingSiblings: Boolean;
    CompareRecords: TDynMainRecords;

    Script: IxeScript;
  public
    ScriptProcessElements: TwbElementTypes;
    MonospaceFontName: string;
  private
    ScriptHotkeys: TStringList;

//    STATsWithWindows: TStringList;

    PluggyLinkState: TwbPluggyLinkState;
    PluggyFormID: TwbFormID;
    PluggyBaseFormID: TwbFormID;
    PluggyInventoryFormID: TwbFormID;
    PluggyEnchantmentFormID: TwbFormID;
    PluggySpellFormID: TwbFormID;
    PluggyLinkThread: TwbThread;

    CheckGitHubReleaseThread: TwbCheckGitHubReleaseThread;
    CheckNexusModsReleaseThread: TwbCheckNexusModsReleaseThread;

    FileCRCs: TwbFastStringListIC;

    CheckedCount: Cardinal;
    ErrorsCount : Cardinal;
    ITMcount    : Cardinal;
    DRcount     : Cardinal;
    CheckResult : Byte;
    AutoDone    : Boolean;
    ColumnWidth : Integer;
    RowHeight   : Integer;

    LOOTPluginInfos: array of TLOOTPluginInfo;
    StickViewNodeLabel: string;
    FoundViewLabelNode: PVirtualNode;

    PendingContainer: IwbDataContainer;
    PendingMainRecords: TDynMainRecords;

    PendingResetActiveTree: Boolean;

    btnNexusModsNewVersion: boolean;
    btnGithubNewVersion: boolean;

    LockOutPinnedCount : Integer;

    procedure DoInit;
    procedure SetDoubleBuffered(aWinControl: TWinControl);
    procedure CleanupRefCache;
    procedure ShowDeveloperMessage(aForce: Boolean = False);

  public
    procedure SetActiveRecord(const aMainRecord: IwbMainRecord); overload;
    procedure SetActiveRecord(const aMainRecords: TDynMainRecords); overload;
    procedure SetActiveContainer(const aContainer: IwbDataContainer); overload;

    procedure DoSetActiveRecord(const aMainRecord: IwbMainRecord); overload;
    procedure DoSetActiveRecord(const aMainRecords: TDynMainRecords); overload;
    procedure DoSetActiveContainer(const aContainer: IwbDataContainer); overload;
  protected

    procedure ClearActiveContainer; overload;
    function GetViewNodePositionLabel(aNode: PVirtualNode = nil): string;
    procedure SetViewNodePositionLabel(aViewLabel: string);

    function ValidateCRC(const aFileName  : string;
                         const aValidCRCs : TDynCardinalArray;
                           out aFileCRC   : Cardinal)
                                          : Boolean;

    procedure UpdateActions; override;

    procedure ApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    procedure vstCreateEditor(const aElement: IwbElement; out EditLink: IVTEditLink);

    procedure SaveLog(const s: string; aAllowReplace: Boolean);
    procedure SaveLogs(aAllowReplace: Boolean);
    procedure UpdateActiveFromPluggyLink;
  public
    Settings: TMemIniFile;
    destructor Destroy; override;

    procedure PostResetActiveTree;
    procedure CheckViewForChange;

    procedure LockOutPinned;
    procedure UnLockOutPinned;
    function IsPinned: Boolean;

    procedure AddMessage(const s: string);
    procedure ScrollToTheLastMessage;
    procedure AddFile(const aFile: IwbFile);
    procedure AddFileInternal(const aFile: IwbFile);

    procedure ReInitTree(aNoGameMaster: Boolean; aFiles: TwbFiles);

    procedure PostAddMessage(const s: string);
    procedure SendAddFile(const aFile: IwbFile);
    procedure SendLoaderDone(const aStartTime: TDateTime; aLoadOrder: Integer);

    procedure PostPluggyChange(aFormID, aBaseFormID, aInventoryFormID, aEnchantmentFormID, aSpellFormID: TwbFormID);
  end;

  TLoaderThread = class(TThread)
  protected
    ltLoadOrderOffset: Integer;
    ltLoadList: TStringList;
    ltDataPath: string;
    ltMaster: string;
    ltFiles: array of IwbFile;
    ltStates: TwbFileStates;

    procedure Execute; override;
  public
    constructor Create(var aList: TStringList; aFileStates: TwbFileStates = []); overload;
    constructor Create(aFileName: string; aMaster: string; aLoadOrder: Integer; aFileStates: TwbFileStates = []); overload;
    destructor Destroy; override;
  end;

  TPluggyLinkThread = class(TwbThread)
  private
    plFolder                : string;
    plLastFormID            : TwbFormID;
    plLastBaseFormID        : TwbFormID;
    plLastInventoryFormID   : TwbFormID;
    plLastEnchantmentFormID : TwbFormID;
    plLastSpellFormID       : TwbFormID;
  protected
    procedure Execute; override;
    procedure ChangeDetected;
  end;

  TGameLinkThread = class(TwbThread)
  private
    glFolder         : string;
    glLastFormID     : TwbFormID;
    glLastBaseFormID : TwbFormID;
  protected
    procedure Execute; override;
    procedure ChangeDetected;
  end;

  IHistoryEntry = interface
    ['{C15C6B99-F25D-4CF3-8E60-ED26A42D6BFB}']
    function Remove(const aMainRecord: IwbMainRecord): Boolean;
    procedure Show;
  end;

  THistoryEntry = class(TInterfacedObject, IHistoryEntry)
  protected
    {--- IHistoryEntry ---}
    function Remove(const aMainRecord: IwbMainRecord): Boolean; virtual;
    procedure Show; virtual; abstract;
  end;

  TTabHistoryEntry = class(THistoryEntry)
  private
    tiTabSheet: TTabSheet;
  protected
    {--- IHistoryEntry ---}
    procedure Show; override;
  public
    constructor Create(aTabSheet: TTabSheet);
  end;

  TCompareRecordsHistoryEntry = class(THistoryEntry)
  private
    crRecords: TDynMainRecords;
    crRecordsChanged: Boolean;
  protected
    {--- IHistoryEntry ---}
    function Remove(const aMainRecord: IwbMainRecord): Boolean; override;
    procedure Show; override;
  public
    constructor Create(const aCompareRecords: TDynMainRecords);
  end;

  TCompareRecordsPosHistoryEntry = class(TCompareRecordsHistoryEntry)
  private
    crpOffsetXY: TPoint;
    crpFocusNode: PVirtualNode;                             {only use for if Assigned check!}
    crpFocusRect: TRect;
    crpFocusColumn: TColumnIndex;
    crpColumnWidths: array of Integer;
  protected
    {--- IHistoryEntry ---}
    procedure Show; override;
  public
    constructor Create(const aCompareRecords: TDynMainRecords);
  end;

  TMainRecordHistoryEntry = class(THistoryEntry)
  private
    mrRecord: IwbMainRecord;
  protected
    function GetTabSheet: TTabSheet; virtual;

    {--- IHistoryEntry ---}
    function Remove(const aMainRecord: IwbMainRecord): Boolean; override;
    procedure Show; override;
  public
    constructor Create(const aMainRecord: IwbMainRecord);
  end;

  TMainRecordElementHistoryEntry = class(TMainRecordHistoryEntry)
  private
    mreElement: IwbElement;
  protected
    {--- IHistoryEntry ---}
    procedure Show; override;
  public
    constructor Create(const aMainRecord: IwbMainRecord; const aElement: IwbElement);
  end;


  TMainRecordRefByHistoryEntry = class(TMainRecordHistoryEntry)
  protected
    function GetTabSheet: TTabSheet; override;
  end;

  TMainRecordPosHistoryEntry = class(TMainRecordHistoryEntry)
  private
    mrpOffsetXY: TPoint;
    mrpFocusNode: PVirtualNode;                             {only use for if Assigned check!}
    mrpFocusRect: TRect;
    mrpFocusColumn: TColumnIndex;
    mrpColumnWidths: array of Integer;
  protected
    {--- IHistoryEntry ---}
    procedure Show; override;
  public
    constructor Create(const aMainRecord: IwbMainRecord);
  end;

var
  frmMain                     : TfrmMain;
  FilesToRename               : TStringList;

procedure DoRename;

function LockProcessMessages: Integer;
function UnLockProcessMessages: Integer;
procedure DoProcessMessages;

procedure xeApplyFontAndScale(aForm: TForm);

function IsPositionChanged(MainRecord: IwbMainRecord): Boolean;

implementation

{$R *.dfm}

uses
  JsonDataObjects,
  DDetours,
  {$IFNDEF LiteVersion}
  cxVTEditors,
  {$ENDIF}
  ShlObj,
  Registry,
  StrUtils,
  Types,
  {$IFNDEF VER220}
  UITypes,
  {$ENDIF VER220}
  Diff,
  wbSort,
  wbStreams,
  wbBetterStringList,
  xeFilterOptionsForm,
  xeFileSelectForm,
  xeViewElementsForm,
  xeEditWarningForm,
  xeLocalizationForm,
  xeLocalizePluginForm,
  xeScriptForm,
  xeLogAnalyzerForm,
  xeLODGenForm,
  xeOptionsForm,
  xeTipForm,
  xeModuleSelectForm,
  xeModGroupSelectForm,
  xeModGroupEditForm,
  xeLegendForm,
  xeRichEditForm,
  xeDeveloperMessageForm,
  WinInet;

function wbFormatElapsedTime(aElapsed: double): string;
var
  Hours: Integer;
begin
  Result := FormatDateTime('nn:ss', aElapsed);
  Hours := Trunc(aElapsed / (1/24));
  if Hours > 0 then
    Result := IntToStr(Hours) + ':' + Result;
end;

function GetUrlContent(const Url: string): UTF8String;
var
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Buffer: array[0..1023] of byte;
  BytesRead: dWord;
  StrBuffer: UTF8String;
begin
  Result := '';
  NetHandle := InternetOpen('xEdit', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(NetHandle) then try
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Url), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if Assigned(UrlHandle) then try
      repeat
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
        SetString(StrBuffer, PAnsiChar(@Buffer[0]), BytesRead);
        Result := Result + StrBuffer;
      until BytesRead = 0;
    finally
      InternetCloseHandle(UrlHandle);
    end else
      raise Exception.CreateFmt('Cannot open URL %s', [Url]);
  finally
    InternetCloseHandle(NetHandle);
  end else
    raise Exception.Create('Unable to initialize Wininet');
end;

threadvar
  LastUpdate               : UInt64;
  ProcessMessagesLockCount : Integer;

function LockProcessMessages: Integer;
begin
  Result := ProcessMessagesLockCount;
  Inc(ProcessMessagesLockCount);
end;

function UnLockProcessMessages: Integer;
begin
  Result := ProcessMessagesLockCount;
  Dec(ProcessMessagesLockCount);
end;

procedure DoProcessMessages;
begin
  if ProcessMessagesLockCount < 1 then begin
    LockProcessMessages;
    try
      Application.ProcessMessages;
    finally
      UnLockProcessMessages;
    end;
  end;
end;

procedure UpdateCaption;
var
  t: string;
  lStartTime: TDateTime;

begin
  if wbShowCaption > 0 then
    if (wbCurrentAction <> '') or (wbCurrentProgress <> '') or (wbShowStartTime > 0) then begin
      t := wbCurrentProgress;
      if wbShowStartTime > 0 then begin
        if t <> '' then
          t := t + ', ';
        lStartTime := wbLocalStartTime;
        if lStartTime = 0 then
          lStartTime := wbStartTime;
        t := t + 'Elapsed Time: ' + wbFormatElapsedTime( Now - lStartTime);
        if wbLocalStartTime <> wbStartTime then
          t := t + ', Total Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime);
      end;

      if wbCurrentAction <> '' then begin
        if t <> '' then
          t := ' ' + t;
        t := '['+wbCurrentAction+']' + t;
      end;

      if t <> '' then
        frmMain.Caption := t;
    end;
end;

procedure GeneralProgressNoAbortCheck(const s: string);
var
  CurrentTick        : UInt64;
  MaxMessageInterval : UInt64;
  CurrentAction      : string;
begin
  if s <> '' then begin
    if (wbShowStartTime > 0) and (wbHideStartTime < 1) then
      frmMain.PostAddMessage('[' + wbFormatElapsedTime(Now - wbStartTime) + '] ' + s)
    else
      frmMain.PostAddMessage(s);
    if wbLastMessageAt <> 0 then
      wbLastMessageAt := GetTickCount64;
  end;

  CurrentTick := GetTickCount64;
  if LastUpdate + 500 < CurrentTick then begin
    if s = '' then
      if wbLastMessageAt <> 0 then
        if wbCurrentAction <> '' then begin

          MaxMessageInterval := wbMaxMessageInterval;
          if MaxMessageInterval < 1 then
            MaxMessageInterval := 10000;

          if wbLastMessageAt + MaxMessageInterval < CurrentTick then begin

            CurrentAction := wbCurrentAction;
            if CurrentAction[1] in ['A'..'Z'] then
              CurrentAction[1] := Char(Word(CurrentAction[1]) or $0020);

            GeneralProgressNoAbortCheck('still ' + CurrentAction);
            Exit;

          end;

        end;
    UpdateCaption;
    DoProcessMessages;
    LastUpdate := GetTickCount64;
  end;
end;

procedure GeneralProgress(const s: string);
begin
  GeneralProgressNoAbortCheck(s);
  if wbForceTerminate then
    Abort;
end;


var
  NoNodes                     : TNodeArray;

function Displayable(aSignature: TwbSignature): String;
var
  Sig : TwbSignature;
  i   : Integer;
begin
  Sig := aSignature;
  for i := Low(Sig) to High(Sig) do
    if Ord(Sig[i]) < 32 then
      Sig[i] := AnsiChar( Ord('a') + Ord(Sig[i]) );

  Result := Sig;
end;

function GetFormIDCallback(const aElement: IwbElement): TwbFormID;
var
  s        : string;
  ObjectID : Cardinal;
begin
  Result := TwbFormID.Null;
  ObjectID := 0;

  if Assigned(aElement) then begin
    ObjectID := aElement._File.NextObjectID; // remember ID
    s := aElement._File.FileFormIDtoLoadOrderFormID(aElement._File.NewFormID, True).ToString(False);
  end;

  try
    if InputQuery('New FormID', 'Please enter the new FormID in hex. e.g. 0404CC43. The FormID needs to be a load order corrected form ID.', s) then try
      Result := TwbFormID.FromStr(s);
    except
      on E: Exception do
        Application.HandleException(E);
    end;
  finally
    // restore Next Object ID if failed
    if (Result.IsNull) and (ObjectID <> 0) then
      aElement._File.NextObjectID := ObjectID;
  end;
end;

function DoRenameModule(const aFrom, aTo: string; aSilent: Boolean): Boolean;
var
  lFrom       : string;
  lTo         : string;
  lBackup     : string;
  s           : string;
  OldDateTime : TDateTime;
  i           : Integer;
begin
  Result := False;

  if wbDontSave then
    Exit;

  if not xeDontBackup and not DirectoryExists(wbBackupPath) then
    if not ForceDirectories(wbBackupPath) then
      wbBackupPath := wbDataPath;

  lFrom := wbDataPath + aFrom;
  if not FileExists(lFrom) then begin
    s := 'Could not rename "'+lFrom+'". File not found.';
    wbProgress(s);
    if not aSilent then
      MessageBox(0, PChar(s), 'Error', 0);
    Exit;
  end;

  // create backup file
  lTo := wbDataPath + aTo;
  OldDateTime := 0;
  if FileExists(lTo) then begin
    try
      OldDateTime := wbGetLastWriteTime(lTo);
    except
      s := 'Could not get last modified time of "' + lTo + '".';
      wbProgress(s);
      if not aSilent then
        MessageBox(0, PChar(s), 'Error', 0);
    end;
    lBackup := wbBackupPath + ExtractFileName(aTo) + '.backup.' + FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now);
    s := lBackup;
    i := 1;
    while FileExists(lBackup) and (i < 1000) do begin
      lBackup := s + '_' + i.ToString;
      Inc(i);
    end;
    if not xeDontBackup then begin
      // backup original file
      wbProgress('Renaming "' + lTo + '" to "' + lBackup + '".');
      if not RenameFile(lTo, lBackup) then begin
        s := 'Could not rename "' + lTo + '" to "' + lBackup + '".';
        wbProgress(s);
        if not aSilent then
          MessageBox(0, PChar(s), 'Error', 0);
        Exit;
      end;
    end else begin
      // remove original file
      wbProgress('Deleting "' + lTo + '".');
      if not SysUtils.DeleteFile(lTo) then begin
        s := 'Could not delete "' + lTo + '".';
        wbProgress(s);
        if not aSilent then
          MessageBox(0, PChar(s), 'Error', 0);
        Exit;
      end;
    end;
  end;

  // rename temp save file to original
  wbProgress('Renaming "' + lFrom + '" to "' + lTo + '".');
  if not RenameFile(lFrom, lTo) then begin
    s := 'Could not rename "' + lFrom + '" to "' + lTo + '".';
    wbProgress(s);
    if not aSilent then
      MessageBox(0, PChar('Could not rename "' + lFrom + '" to "' + lTo + '".'), 'Error', 0);
    Exit;
  end;

  if not (wbGameMode in wbOrderFromPluginsTxt) then
    if OldDateTime <> 0 then
      if wbIsModule(lTo) then try
      TFile.SetLastWriteTime(lTo, OldDateTime);
    except
      s := 'Could not set last modified time of "' + lTo + '".';
      wbProgress(s);
      if not aSilent then
        MessageBox(0, PChar(s), 'Error', 0);
    end;

  Result := True;
end;

function DoBackupModule(const aFrom, aOriginal: string; aSilent: Boolean): Boolean;
var
  lFrom       : string;
  lBackup     : string;
  s           : string;
  i           : Integer;
begin
  Result := False;

  Assert(not wbDontSave);
  Assert(not xeDontBackup);

  if not xeDontBackup and not DirectoryExists(wbBackupPath) then
    if not ForceDirectories(wbBackupPath) then
      wbBackupPath := wbDataPath;

  lFrom := wbDataPath + aFrom;
  if not FileExists(lFrom) then begin
    s := 'Could not rename "'+lFrom+'". File not found.';
    wbProgress(s);
    if not aSilent then
      MessageBox(0, PChar(s), 'Error', 0);
    Exit;
  end;

  lBackup := wbBackupPath + aFrom.Replace('.save.', '.backup.');
  s := lBackup;
  i := 1;
  while FileExists(lBackup) and (i < 1000) do begin
    lBackup := s + '_' + i.ToString;
    Inc(i);
  end;

  wbProgress('Renaming "' + lFrom + '" to "' + lBackup + '".');
  if not RenameFile(lFrom, lBackup) then begin
    s := 'Could not rename "' + lFrom + '" to "' + lBackup + '".';
    wbProgress(s);
    if not aSilent then
      MessageBox(0, PChar(s), 'Error', 0);
    Exit;
  end;

  Result := True;
end;

var
  _SaveProgress: Boolean;

procedure SaveProgress(const s: string);
begin
  _SaveProgress := True;
  if Assigned(frmMain) then
    GeneralProgress(s);
end;

procedure DoRename;
var
  i        : Integer;
  AnyError : Boolean;
begin
  wbForceTerminate := False;
  _wbProgressCallback := SaveProgress;
  wbShowStartTime := 1;
  wbStartTime := Now;
  wbCurrentTick := GetTickCount64;
  wbCurrentAction := 'Closing files';
  if Assigned(frmMain) then
    frmMain.mmoMessages.Clear;
  wbProgress(wbCurrentAction);

  wbFileForceClosed;

  if wbDontSave then
    Exit;

  if not Assigned(FilesToRename) then
    Exit;

  if not xeDontBackup and not DirectoryExists(wbBackupPath) then
    if not ForceDirectories(wbBackupPath) then
      wbBackupPath := wbDataPath;

  wbCurrentAction := 'Renaming previously saved files';
  wbProgress(wbCurrentAction);

  _SaveProgress := False;
  AnyError := False;
  for i := 0 to Pred(FilesToRename.Count) do
    if not DoRenameModule(FilesToRename.ValueFromIndex[i], FilesToRename.Names[i], False) then
      AnyError := True;

  if AnyError then begin
    MessageBox(0, PChar('One or more errors occured during renaming of saved modules.'+#13#13+
    'Please check the files in your data path: ' + wbDataPath), 'Error', 0);
    if _SaveProgress and Assigned(frmMain) then
      frmMain.SaveLogs(False);
  end;

  wbCurrentAction := '';
end;

procedure TfrmMain.acBackExecute(Sender: TObject);
var
  Intf                        : IInterface;
begin
  if Assigned(BackHistory) and (BackHistory.Count > 0) then begin
    Intf := BackHistory.Last;
    BackHistory.Remove(Intf);
    JumpTo(Intf, True);
  end;
end;

procedure TfrmMain.acBackUpdate(Sender: TObject);
begin
  acBack.Enabled := Assigned(BackHistory) and (BackHistory.Count > 0);
end;

procedure TfrmMain.acForwardExecute(Sender: TObject);
var
  Intf                        : IInterface;
begin
  if Assigned(ForwardHistory) and (ForwardHistory.Count > 0) then begin
    Intf := ForwardHistory.Last;
    ForwardHistory.Remove(Intf);
    JumpTo(Intf, False);
  end;
end;

procedure TfrmMain.acForwardUpdate(Sender: TObject);
begin
  acForward.Enabled := Assigned(ForwardHistory) and (ForwardHistory.Count > 0);
end;

procedure TfrmMain.acScriptExecute(Sender: TObject);
var
  i: integer;
  s, t: string;
begin
  if not Assigned(Sender) then
    Exit;

  i := Pred((Sender as TAction).Tag);
  if i >= ScriptHotkeys.Count then
    Exit;

  t := ScriptHotkeys[i];
  with TStringList.Create do try
    LoadFromFile(t);
    s := Text;
  finally
    Free;
  end;

  t := ChangeFileExt(ExtractFileName(t), '');
  ApplyScript(t, s);
end;

procedure TfrmMain.AddFile(const aFile: IwbFile);
var
  i, j, k: Integer;
  Present : Boolean;
begin
  if not wbrequireLoadorder then begin
    k := aFile.LoadOrder;
    if k >= 0 then
      for i := 0 to Pred(aFile.MasterCount[True]) do begin
        Present := False;
        for j := Low(Files) to high(Files) do
          if sameText(Files[j].FileName, aFile.Masters[i, True].FileName) then begin
            Present := True;
            Break;
          end;
        if not Present then
          begin
            if aFile.Masters[i, True].LoadOrder = -1 then begin
              aFile.Masters[i, True].ForceLoadOrder(k);
              Inc(k);
            end;

            AddFileInternal(aFile.Masters[i, True]);
          end;
      end;
    if k <> aFile.LoadOrder then
      aFile.ForceLoadOrder(k);
  end;

  AddFileInternal(aFile);
end;

procedure TfrmMain.AddFileInternal(const aFile: IwbFile);
begin
  SetLength(Files, Succ(Length(Files)));
  Files[High(Files)] := aFile;

  vstNav.AddChild(nil, Pointer(aFile));
  aFile._AddRef;
end;

procedure TfrmMain.ScrollToTheLastMessage;
begin
  if mniMessagesAutoscroll.Checked then
    mmoMessages.CaretY := mmoMessages.Lines.Count;
end;

procedure TfrmMain.AddMessage(const s: string);
begin
  var Strs := s.Split(CRLF);
  if Length(Strs) < 1 then
    SetLength(Strs, 1);
  for var t in Strs do begin
    mmoMessages.Lines.Add(t);
    stbMain.Panels[0].Text := t;
  end;

  ScrollToTheLastMessage;

  if pgMain.ActivePage <> tbsMessages then
    tbsMessages.Highlighted := True;
end;

function TfrmMain.AddNewFileName(aFileName: string; aIsLight, aIsMedium: Boolean): IwbFile;
var
  LoadOrder : Integer;
begin
  Result := nil;

  if FileExists(wbDataPath + aFileName) then begin
    ShowMessage('A file of that name exists already.');
    Exit;
  end;

  LoadOrder := 0;
  if Length(Files) > 0 then
    LoadOrder := Succ(Files[High(Files)].LoadOrder);
{
  if LoadOrder > 254 then begin
    ShowMessage('Maximum plugins count already reached. Adding 1 more would exceed the maximum index of 254');
    Exit;
  end;
}
  Result := wbNewFile(wbDataPath + aFileName, LoadOrder, aIsLight, aIsMedium);
  SetLength(Files, Succ(Length(Files)));
  Files[High(Files)] := Result;
  vstNav.AddChild(nil, Pointer(Result));
  Result._AddRef;
end;

function TfrmMain.AddNewFileName(aFileName: string; aTemplate: PwbModuleInfo): IwbFile;
var
  LoadOrder : Integer;
  i: Integer;
begin
  Result := nil;

  if FileExists(wbDataPath + aFileName) then begin
    ShowMessage('A file of that name exists already.');
    Exit;
  end;

  LoadOrder := 0;
  if Length(Files) > 0 then begin
    for i := Low(Files) to High(Files) do
      if Files[i].LoadOrder > LoadOrder then
        LoadOrder := Files[i].LoadOrder;
    LoadOrder := Succ(LoadOrder);
  end;

  Result := wbNewFile(wbDataPath + aFileName, LoadOrder, aTemplate);
  SetLength(Files, Succ(Length(Files)));
  Files[High(Files)] := Result;
  vstNav.AddChild(nil, Pointer(Result));
  Result._AddRef;
end;

function TfrmMain.AddNewFile(out aFile: IwbFile; aIsLight, aIsMedium: Boolean): Boolean;
var
  s: string;
begin
  aFile := nil;
  Result := False;
  s := '';
  if InputQuery('New Module File', 'Filename without extension:', s) then begin
    if s = '' then
      Exit;
    if aIsLight then
      s := s + '.esl'
    else
      s := s + '.esp';
    aFile := AddNewFileName(s, aIsLight, aIsMedium);
    Result := Assigned(aFile);
  end;
end;

function TfrmMain.AddNewFile(out aFile: IwbFile; aTemplate: PwbModuleInfo): Boolean;
var
  s: string;
begin
  aFile := nil;
  Result := False;
  s := '';
  if InputQuery('New Module File', 'Filename without extension:', s) then begin
    s := Trim(s);
    if s = '' then
      Exit;
    s := s + aTemplate.miExtension.ToString;
    aFile := AddNewFileName(s, aTemplate);
    Result := Assigned(aFile);
  end;
end;


function CompareLoadOrder(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if Index1 = Index2 then begin
    Result := 0;
    Exit;
  end;

  Result := CmpI32(
    IwbFile(Pointer(List.Objects[Index1])).LoadOrder,
    IwbFile(Pointer(List.Objects[Index2])).LoadOrder);
end;

function TfrmMain.AddRequiredMaster(const aMasterFile: IwbFile; const aTargetFile: IwbFile): Boolean;
var
  sl: TStringList;
begin
  if Assigned(aMasterFile) then begin
    sl := TStringList.Create;
    try
      sl.AddObject(aMasterFile.FileName, Pointer(aMasterFile));
      Result := AddRequiredMasters(sl, aTargetFile);
    finally
      sl.Free;
    end;
  end else
    Result := True;
end;

function TfrmMain.AddRequiredMasters(aMasters: TStrings; const aTargetFile: IwbFile; aSilent: Boolean = False): Boolean;
var
  sl                          : TStringList;
  i, j                        : Integer;
  WasEnabled                  : Boolean;
  PrevAction                  : string;
begin
  Result := True;

  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  try
    sl.AddStrings(aMasters);

    for i := 0 to Pred(aTargetFile.MasterCount[True]) do
      if sl.Find(aTargetFile.Masters[i, True].FileName, j) then
        sl.Delete(j);
    if sl.Find(aTargetFile.FileName, j) then
      sl.Delete(j);

    if sl.Count > 0 then begin

      for i := 0 to Pred(sl.Count) do
        if IwbFile(Pointer(sl.Objects[i])).LoadOrder >= aTargetFile.LoadOrder then
          raise Exception.Create('The required master "' + sl[i] + '" can not be added to "' + aTargetFile.FileName + '" as it has a higher load order');

      Result := aSilent;
      if not Result then
        Result := MessageDlg('To continue the following files need to be added to "' +
          aTargetFile.FileName + '" as masters:'#13#13 + sl.Text +
          #13'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;

      sl.Sorted := False;
      sl.CustomSort(CompareLoadOrder);

      if Result then begin
        WasEnabled := pnlClient.Enabled;
        pnlClient.Enabled := False;
        UpdatePnlCancelVisible;
        try
          if WasEnabled then
            wbStartTime := Now;
          PrevAction := wbCurrentAction;
          if sl.Count = 1 then
            wbCurrentAction := 'Adding '+IwbFile(Pointer(sl.Objects[0])).Name+' as new master to ' + aTargetFile.Name
          else
            wbCurrentAction := 'Adding '+sl.Count.ToString+' new masters to ' + aTargetFile.Name;
          AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] ' + wbCurrentAction);
          DoProcessMessages;
          aTargetFile.AddMasters(sl);
          wbCurrentAction := 'Sorting masters for ' + aTargetFile.Name;
          DoProcessMessages;
          aTargetFile.SortMasters;
          AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Done adding and sorting masters.');
        finally
          wbCurrentAction := PrevAction;
          if WasEnabled then
            Caption := Application.Title;
          pnlClient.Enabled := WasEnabled;
          UpdatePnlCancelVisible;
        end;
      end;
    end else
      Result := True;
  finally
    sl.Free;
  end;
end;

function TfrmMain.AddRequiredMasters(const aSourceElement: IwbElement; const aTargetFile: IwbFile; aAsNew: Boolean; aSilent: Boolean = False): Boolean;
begin
  Result := True;
  var lRequiredMasters := TStringList.Create;
  try
    lRequiredMasters.Sorted := True;
    lRequiredMasters.Duplicates := dupIgnore;

    var lDict := TwbFilesDictionary.Create;
    try
      aSourceElement.ReportRequiredMasters(lDict, aAsNew);
      for var lFile in lDict.Keys do
        lRequiredMasters.AddObject(lFile.FileName, Pointer(lFile));
    finally
      lDict.Free;
    end;

    var lFindIdx: Integer;
    for var lTargetMasterIdx := 0 to Pred(aTargetFile.MasterCount[True]) do
      if lRequiredMasters.Find(aTargetFile.Masters[lTargetMasterIdx, True].FileName, lFindIdx) then
        lRequiredMasters.Delete(lFindIdx);
    if lRequiredMasters.Find(aTargetFile.FileName, lFindIdx) then
      lRequiredMasters.Delete(lFindIdx);

    if lRequiredMasters.Count > 0 then begin

      for var lRequiredMasterIdx := 0 to Pred(lRequiredMasters.Count) do
        if IwbFile(Pointer(lRequiredMasters.Objects[lRequiredMasterIdx])).LoadOrder >= aTargetFile.LoadOrder then
          raise Exception.Create('The required master "' + lRequiredMasters[lRequiredMasterIdx] + '" can not be added to "' + aTargetFile.FileName + '" as it has a higher load order');

      Result := aSilent or (MessageDlg('To continue the following files need to be added to "' +
        aTargetFile.FileName + '" as masters:'#13#13 + lRequiredMasters.Text +
        #13'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);

      lRequiredMasters.Sorted := False;
      lRequiredMasters.CustomSort(CompareLoadOrder);

      if Result then
        aTargetFile.AddMasters(lRequiredMasters);
    end else
      Result := True;
  finally
    lRequiredMasters.Free;
  end;
end;

procedure TfrmMain.ApplicationMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = 524 {WM_XBUTTONUP} then
    {$IFDEF WIN32}
    case LongRec(Msg.wParam).Hi of
    {$ENDIF WIN32}
    {$IFDEF WIN64}
    case LongRec(Int64Rec(Msg.wParam).Lo).Hi of
    {$ENDIF WIN64}
      1: Handled := acBack.Execute;
      2: Handled := acForward.Execute;
    end;
end;

procedure TfrmMain.mniMainPluggyLinkClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;

  if mniMainPluggyLinkReference.Checked then
    PluggyLinkState := plsReference
  else if mniMainPluggyLinkBaseObject.Checked then
    PluggyLinkState := plsBase
  else if mniMainPluggyLinkInventory.Checked then
    PluggyLinkState := plsInventory
  else if mniMainPluggyLinkEnchantment.Checked then
    PluggyLinkState := plsEnchantment
  else if mniMainPluggyLinkSpell.Checked then
    PluggyLinkState := plsSpell
  else
    PluggyLinkState := plsNone;

  if (PluggyLinkState = plsNone) or Assigned(PluggyLinkThread) and (PluggyLinkThread.Terminated) then
    FreeAndNil(PluggyLinkThread);

  if (PluggyLinkState <> plsNone) then
    if not Assigned(PluggyLinkThread) then begin
      if wbGameMode = gmTES4 then
        PluggyLinkThread := TPluggyLinkThread.Create(False)
      else
        PluggyLinkThread := TGameLinkThread.Create(False);
    end else
      UpdateActiveFromPluggyLink;
end;

procedure TfrmMain.BuildAllRef;
var
  i     : Integer;
  _File : IwbFile;
begin
  wbStartTime := Now;
  pgMain.ActivePage := tbsMessages;

  pnlClient.Enabled := False;
  UpdatePnlCancelVisible;
  try
    for i := Low(Files) to High(Files) do begin
      _File := Files[i];
      if not (csRefsBuild in _File.ContainerStates) then begin
        pgMain.ActivePage := tbsMessages;
        wbCurrentAction := 'Building reference information for ' + _File.Name;
        AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] ' + wbCurrentAction);
        DoProcessMessages;
        _File.BuildRef;
      end;
    end;
    AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] All done!');
  finally
    wbCurrentAction := '';
    Caption := Application.Title;
    pnlClient.Enabled := True;
    UpdatePnlCancelVisible;
  end;
end;

procedure TfrmMain.mniNavHeaderINFOClick(Sender: TObject);
var
  i: Integer;
begin
  UserWasActive := True;

  if mniNavHeaderINFObyFormID.Checked then
    i := 1
  else
    i := 0;
  Settings.WriteInteger('Nav','INFOSort', i);
  Settings.UpdateFile;
  vstNav.Header.SortTree;
  vstNav.ScrollIntoView(vstNav.FocusedNode, True);
end;

function TfrmMain.ByRefSelectionIncludesAnyDeepCopyRecords(aSelection: TDynMainRecords): Boolean;
var
  i                           : Integer;
  MainRecord                  : IwbMainRecord;
begin
  Result := True;
  if Length(aSelection) < 1 then
    aSelection := GetRefBySelectionAsMainRecords;
  if Length(aSelection) < 1 then
    Exit;
  for i := Low(aSelection) to High(aSelection) do begin
    MainRecord := aSelection[i];
    if Assigned(MainRecord.ChildGroup) then
      Exit;
  end;
  Result := False;
end;

function TfrmMain.ByRefSelectionIncludesNonCopyNewRecords(aSelection: TDynMainRecords): Boolean;
var
  i                           : Integer;
  MainRecord                  : IwbMainRecord;
  Signature                   : TwbSignature;
begin
  Result := True;
  if Length(aSelection) < 1 then
    aSelection := GetRefBySelectionAsMainRecords;
  if Length(aSelection) < 1 then
    Exit;
  for i := Low(aSelection) to High(aSelection) do begin
    MainRecord := aSelection[i];
    Signature := MainRecord.Signature;
    if (Signature = 'CELL') or (Signature = 'WRLD') or (Signature = 'ROAD') or (Signature = 'LAND') or (Signature = 'PGRD') or (Signature = 'NAVM') or (Signature = 'NAVI') then
      Exit;
  end;
  Result := False;
end;

function TfrmMain.ByRefSelectionIncludesOnlyDeepCopyRecords(aSelection: TDynMainRecords): Boolean;
begin
  Result := False;
end;

procedure TfrmMain.ConflictLevelForMainRecord(const aMainRecord: IwbMainRecord; out aConflictAll: TConflictAll; out aConflictThis: TConflictThis);

  procedure Fix(const aMainRecord: IwbMainRecord);
  begin
    with aMainRecord do begin
      ConflictAll := aConflictAll;
      if ConflictThis = ctUnknown then begin
        ConflictThis := ctHiddenByModGroup;
      end;
    end;
  end;

var
  NodeDatas                   : TDynViewNodeDatas;

  function IsCompareToSame: Boolean;
  var
    MainRecordMaster, MainRecordOverride: IwbMainRecord;
    FileMaster, FileOverride: IwbFile;
  begin
    Result := False;

    if Length(NodeDatas) <> 2 then
      Exit;

    if not Supports(NodeDatas[0].Element, IwbMainRecord, MainRecordMaster) then
      Exit;
    if MainRecordMaster.Modified then
      Exit;

    if not Supports(NodeDatas[1].Element, IwbMainRecord, MainRecordOverride) then
      Exit;
    if MainRecordOverride.Modified then
      Exit;

    FileOverride := MainRecordOverride._File;
    if not Assigned(FileOverride) then
      Exit;

    if not (fsCompareToHasSameMasters in FileOverride.FileStates) then
      Exit;

    FileMaster := MainRecordMaster._File;
    if not Assigned(FileMaster) then
      Exit;

    if not FileMaster.Equals(FileOverride.CompareToFile) then
      Exit;

    Result := MainRecordMaster.ContentEquals(MainRecordOverride);
  end;

var
  i                           : Integer;
  Master                      : IwbMainRecord;
  KeepAliveRoot               : IwbKeepAliveRoot;
begin
  KeepAliveRoot := wbCreateKeepAliveRoot;

  aConflictAll := aMainRecord.ConflictAll;
  aConflictThis := aMainRecord.ConflictThis;

  if aConflictAll > caUnknown then
    Exit;

  Master := aMainRecord.MasterOrSelf;
  if (Master.OverrideCount = 0) and not wbTranslationMode and not ((Master.Signature = 'GMST') or (Master.Signature = 'DFOB')) then begin
    aConflictAll := caOnlyOne;
    aConflictThis := ctOnlyOne;
    aMainRecord.ConflictAll := aConflictAll;
    aMainRecord.ConflictThis := aConflictThis;
  end else begin
    NodeDatas := NodeDatasForMainRecord(aMainRecord);
    if (Length(NodeDatas) = 1) and not wbTranslationMode then begin
      aConflictAll := caOnlyOne;
      NodeDatas[0].ConflictAll := caOnlyOne;
      NodeDatas[0].ConflictThis := ctOnlyOne;
    end else if Length(NodeDatas) = 2 then begin
      if xeQuickShowConflicts then begin
        aConflictAll := caOverride;
        NodeDatas[0].ConflictAll := caOverride;
        NodeDatas[1].ConflictAll := caOverride;
        NodeDatas[0].ConflictThis := ctMaster;
        NodeDatas[1].ConflictThis := ctOverride;
      end else if IsCompareToSame then begin
        aConflictAll := caNoConflict;
        NodeDatas[0].ConflictAll := caNoConflict;
        NodeDatas[1].ConflictAll := caNoConflict;
        NodeDatas[0].ConflictThis := ctMaster;
        NodeDatas[1].ConflictThis := ctIdenticalToMaster;
      end else begin
        aConflictAll := ConflictLevelForChildNodeDatas(NodeDatas, False, (aMainRecord.MasterOrSelf.IsInjected and not ((aMainRecord.Signature = 'GMST') or (aMainRecord.Signature = 'DFOB')) ) );
        if aConflictAll = caNoConflict then
          IsCompareToSame;
      end
    end else
      aConflictAll := ConflictLevelForChildNodeDatas(NodeDatas, False, (aMainRecord.MasterOrSelf.IsInjected and not ((aMainRecord.Signature = 'GMST') or (aMainRecord.Signature = 'DFOB')) ) );

    for i := Low(NodeDatas) to High(NodeDatas) do
      with NodeDatas[i] do
        if Assigned(Element) then
          with (Element as IwbMainRecord) do begin
            ConflictAll := aConflictAll;
            ConflictThis := NodeDatas[i].ConflictThis;
          end;

    Fix(Master);
    for i := 0 to Pred(Master.OverrideCount) do
      Fix(Master.Overrides[i]);

    aConflictThis := aMainRecord.ConflictThis;
  end;
end;

procedure TfrmMain.ConflictLevelForContainer(const aContainer: IwbDataContainer; out aConflictAll: TConflictAll; out aConflictThis: TConflictThis);

  procedure Fix(const aMainRecord: IwbMainRecord);
  begin
    with aMainRecord do begin
      ConflictAll := aConflictAll;
      if ConflictThis = ctUnknown then begin
        ConflictThis := ctHiddenByModGroup;
      end;
    end;
  end;

var
  NodeDatas     : TDynViewNodeDatas;
  i             : Integer;
  KeepAliveRoot : IwbKeepAliveRoot;
  MainRecord    : IwbMainRecord;
begin
  KeepAliveRoot := wbCreateKeepAliveRoot;

  Mainrecord := aContainer as IwbMainrecord;

  if Assigned(Mainrecord) then begin
    ConflictLevelForMainRecord(MainRecord, aConflictAll, aConflictThis);
  end else begin
    NodeDatas := NodeDatasForContainer(aContainer);
    if Length(NodeDatas) = 1 then begin
      aConflictAll := caOnlyOne;
      NodeDatas[0].ConflictAll := caOnlyOne;
      NodeDatas[0].ConflictThis := ctOnlyOne;
    end else if xeQuickShowConflicts and (Length(NodeDatas) = 2) then begin
      aConflictAll := caOverride;
      NodeDatas[0].ConflictAll := caOverride;
      NodeDatas[1].ConflictAll := caOverride;
      NodeDatas[0].ConflictThis := ctMaster;
      NodeDatas[1].ConflictThis := ctOverride;
    end else
      aConflictAll := ConflictLevelForChildNodeDatas(NodeDatas, False, False );

    for i := Low(NodeDatas) to High(NodeDatas) do
      with NodeDatas[i] do
        if Assigned(Element) and (Element as IwbDataContainer = aContainer) then
          aConflictThis := NodeDatas[i].ConflictThis;
  end;
end;

function TfrmMain.ConflictLevelForNodeDatas(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer; aSiblingCompare, aInjected: Boolean): TConflictAll;
var
  Element                : IwbElement;
  CompareElement         : IwbElement;
  i, j                   : Integer;
  UniqueValues           : TwbFastStringListCS;

  MasterPosition         : Integer;
  FirstElement           : IwbElement;
  FirstElementNotIgnored : IwbElement;
  LastElement            : IwbElement;
  SameAsLast             : Boolean;
  SameAsFirst            : Boolean;
  OverallConflictThis    : TConflictThis;
  Priority               : TwbConflictPriority;
  ThisPriority           : TwbConflictPriority;
  FoundAny               : Boolean;

  ElementTypes           : TwbElementTypes;
  DefTypes               : TwbDefTypes;
  OptionalAndMissing     : Boolean;
begin
//  if aSiblingCompare then
//    Priority := cpBenign
//  else
//    Priority := cpNormal;
//  IgnoreConflicts := False;
  FoundAny := False;
  MasterPosition := 0;
  OverallConflictThis := ctUnknown;

  var lNodeCount := 0;
  var lFirstNode := PViewNodeData(nil);

  if aNodeCount = 1 then begin
    lNodeCount := 1;
    lFirstNode := @aNodeDatas[0];
  end else
    for i := 0 to Pred(aNodeCount) do
      if aNodeDatas[i].ViewNodeFlags * [vnfDontShow, vnfIgnore] <> [] then with aNodeDatas[i] do begin
        ConflictThis := ctNotDefined;
        if Assigned(Element) and (vnfIgnore in ViewNodeFlags) then
          ConflictThis := ctIgnored;
      end else begin
        Inc(lNodeCount);
        if not Assigned(lFirstNode) then
          lFirstNode := @aNodeDatas[i];
      end;

  case lNodeCount of
    0: Result := caUnknown;
    1: begin
        Element := lFirstNode^.Element;
        if Assigned(Element) then begin
          if Element.ConflictPriority = cpIgnore then
            lFirstNode^.ConflictThis := ctIgnored
          else
            lFirstNode^.ConflictThis := ctOnlyOne;
        end else
          lFirstNode^.ConflictThis := ctNotDefined;
        Result := caOnlyOne;
      end
  else
    var lLastIndex := Pred(aNodeCount);

    LastElement := aNodeDatas[lLastIndex].Element;
    while not Assigned(LastElement) and (vnfIsPartialForm in aNodeDatas[lLastIndex].ViewNodeFlags) and (lLastIndex > 0) do begin
      Dec(lLastIndex);
      LastElement := aNodeDatas[lLastIndex].Element;
    end;
    FirstElement := lFirstNode.Element;

    UniqueValues := TwbFastStringListCS.Create;
    UniqueValues.Sorted := True;
    UniqueValues.Duplicates := dupIgnore;
    Priority := cpNormal;
    try
      for i := 0 to Pred(aNodeCount) do begin
        Element := aNodeDatas[i].Element;
        if Assigned(Element) then begin
          FoundAny := True;
          Priority := Element.ConflictPriority;
          if Priority = cpNormalIgnoreEmpty then begin
            FirstElement := Element;
            MasterPosition := i;
            for j := Pred(aNodeCount) downto i do begin
              LastElement := aNodeDatas[j].Element;
              if Assigned(LastElement) then
                Break;
            end;
          end;
          if Element.ConflictPriorityCanChange then begin
            for j := Succ(i) to Pred(aNodeCount) do begin
              Element := aNodeDatas[j].Element;
              if Assigned(Element) then begin
                ThisPriority := Element.ConflictPriority;
                if ThisPriority > Priority then
                  Priority := ThisPriority;
              end;
            end;
          end;
          Break;
        end;
      end;

      if aSiblingCompare then
        if Priority > cpBenign then
          Priority := cpBenign;
      if aInjected and (Priority >= cpNormal) then
        Priority := cpCritical;

      if (Priority > cpIgnore) and (not Assigned(FirstElement) or (FirstElement.ConflictPriority = cpIgnore)) then
        FirstElementNotIgnored := nil
      else
        FirstElementNotIgnored := FirstElement;

      ElementTypes := [];
      DefTypes := [];
      OptionalAndMissing := False;

      for i := 0 to Pred(aNodeCount) do begin
        Element := aNodeDatas[i].Element;
        if Assigned(Element) then begin
          Include(ElementTypes, Element.ElementType);
          if Assigned(Element.ValueDef) then
            Include(DefTypes, Element.ValueDef.DefType)
          else
            Include(DefTypes, dtEmpty);
          OptionalAndMissing := OptionalAndMissing or (esOptionalAndMissing in Element.ElementStates);

          ThisPriority := Element.ConflictPriority;
          if ThisPriority <> cpIgnore then
            UniqueValues.Add(Element.DisplaySortKey[True]);
        end else if (vnfIsPartialForm in aNodeDatas[i].ViewNodeFlags) then begin
          ThisPriority := cpIgnore;
        end else begin
          Include(DefTypes, dtEmpty);
          ThisPriority := Priority;
          if not (vnfIgnore in aNodeDatas[i].ViewNodeFlags) then
            if Priority <> cpNormalIgnoreEmpty then
              UniqueValues.Add('');
        end;

        if (ThisPriority = cpNormalIgnoreEmpty) and not Assigned(Element) then
          aNodeDatas[i].ConflictThis := ctIgnored
        else if ThisPriority = cpIgnore then
          aNodeDatas[i].ConflictThis := ctIgnored
        else if aSiblingCompare then
          aNodeDatas[i].ConflictThis := ctOnlyOne
        else if i = MasterPosition then begin

          if Assigned(Element) then
            aNodeDatas[i].ConflictThis := ctMaster
          else
            aNodeDatas[i].ConflictThis := ctUnknown;

        end else begin
          SameAsLast := (i = Pred(aNodeCount)) or not (
            (Assigned(Element) <> Assigned(LastElement)) or
            (Assigned(Element) and not SameStr(Element.DisplaySortKey[True], LastElement.DisplaySortKey[True]))
            );

          SameAsFirst := not (
            (Assigned(Element) <> Assigned(FirstElementNotIgnored)) or
            (Assigned(Element) and not SameStr(Element.DisplaySortKey[True], FirstElementNotIgnored.DisplaySortKey[True]))
            );

          if not SameAsFirst and
             (ThisPriority = cpBenignIfAdded) and
             SameAsLast and  // We are not overriden later
             not Assigned(FirstElementNotIgnored) then begin // The master did not have that element
            ThisPriority := cpBenign;
            Priority := cpBenign;
            SameAsFirst := True;
          end;

          if SameAsFirst then
            aNodeDatas[i].ConflictThis := ctIdenticalToMaster
          else if SameAsLast then
            aNodeDatas[i].ConflictThis := ctConflictWins
          else
            aNodeDatas[i].ConflictThis := ctConflictLoses;
        end;

        if (ThisPriority = cpBenign) and (aNodeDatas[i].ConflictThis > ctConflictBenign) then
          aNodeDatas[i].ConflictThis := ctConflictBenign;
        if (ThisPriority = cpOverride) and (aNodeDatas[i].ConflictThis > ctOverride) then
          aNodeDatas[i].ConflictThis := ctOverride;

        if aNodeDatas[i].ConflictThis > OverallConflictThis then
          OverallConflictThis := aNodeDatas[i].ConflictThis;
      end;

      case UniqueValues.Count of
        0: Result := caNoConflict;
        1: Result := caNoConflict;
        2: begin
            Element := aNodeDatas[0].Element;
            var lCompareIndex := Pred(aNodeCount);
            CompareElement := aNodeDatas[lCompareIndex].Element;
            while not Assigned(CompareElement) and (vnfIsPartialForm in aNodeDatas[lCompareIndex].ViewNodeFlags) and (lCompareIndex > 0) do begin
              Dec(lCompareIndex);
              CompareElement := aNodeDatas[lCompareIndex].Element;
            end;
            if (Assigned(Element) <> Assigned(CompareElement)) or
              (Assigned(Element) and not SameStr(Element.DisplaySortKey[True], CompareElement.DisplaySortKey[True])) then
              Result := caOverride
            else if (UniqueValues.IndexOf('') >= 0) and Assigned(CompareElement) and (CompareElement.DisplaySortKey[True] <> '') then
              Result := caOverride
            else
              Result := caConflict;
          end
      else
        Result := caConflict;
      end;

      if aSiblingCompare and (Result > caConflictBenign) then
        Result := caConflictBenign;

      if not FoundAny then
        for i := 0 to Pred(aNodeCount) do
          aNodeDatas[i].ConflictThis := ctNotDefined;

      if Result > caNoConflict then
        case Priority of
          cpBenign: Result := caConflictBenign;
          cpOverride: Result := caOverride;
          cpCritical: begin
              if UniqueValues.Find('', i) then
                UniqueValues.Delete(i);
              if UniqueValues.Count > 1 then
                Result := caConflictCritical;
            end;
        end;

      if Priority > cpBenign then
        if OverallConflictThis > ctOverride then
          with aNodeDatas[Pred(aNodeCount)] do
            if ConflictThis < ctOverride then
              if ConflictThis = ctIdenticalToMaster then
                ConflictThis := ctIdenticalToMasterWinsConflict
              else
                ConflictThis := ctConflictWins;

      if Result in [caNoConflict, caOverride, caConflict] then
        for i := 0 to Pred(aNodeCount) do begin
          case aNodeDatas[i].ConflictThis of
            ctIdenticalToMaster: case Result of
                caNoConflict: ;
                caOverride, caConflict: if i = Pred(aNodeCount) then
                  aNodeDatas[i].ConflictThis := ctIdenticalToMasterWinsConflict
              end;
            ctConflictWins: case Result of
              caNoConflict: aNodeDatas[i].ConflictThis := ctIdenticalToMaster;
              caOverride: aNodeDatas[i].ConflictThis := ctOverride;
              caConflict: ;
            end;
          end;
        end;

      if Result < caConflict then
        for i := 0 to Pred(aNodeCount) do
          if aNodeDatas[i].ConflictThis >= ctIdenticalToMasterWinsConflict then begin
            Result := caConflict;
            Break;
          end;

      if    (Result > caNoConflict)
        and OptionalAndMissing
        and (ElementTypes <= [etArray, etStruct, etValue])
        and (dtEmpty in DefTypes)
        and ((DefTypes - [dtEmpty]).Count = 1)
        and ((DefTypes - [dtEmpty, dtString..dtInteger, dtFloat, dtArray, dtStruct]).Count = 0) then begin

        for i := 0 to Pred(aNodeCount) do
          if Assigned(aNodeDatas[i].Element) then
            if not aNodeDatas[i].Element.ContentIsAllZero then
              Exit;

        Result := caNoConflict;

        for i := 0 to Pred(aNodeCount) do begin
          if aNodeDatas[i].ConflictThis > ctIdenticalToMaster then
            aNodeDatas[i].ConflictThis := ctIdenticalToMaster;
          if aNodeDatas[i].ConflictAll > caNoConflict then
            aNodeDatas[i].ConflictAll := caNoConflict;
        end;

      end;

    finally
      FreeAndNil(UniqueValues);
    end;
  end;
end;

procedure AfterCopyAdjustSpawnRate(const aElement: IwbElement);
var
  MainRecord         : IwbMainRecord;
  LeveledListEntries : IwbContainerElementRef;
  LeveledListEntry   : IwbContainerElementRef;
  Entries            : array of IwbContainerElementRef;
  i, j               : Integer;
const
  Counts : array [0..8] of Integer = (1,1,2,2,2,2,2,3,3);
begin
  if Supports(aElement, IwbMainRecord, MainRecord) then begin

    LeveledListEntries := MainRecord.ElementByName['Leveled List Entries'] as IwbContainerElementRef;
    Assert(Assigned(LeveledListEntries));

    for i := 0 to Pred(LeveledListEntries.ElementCount) do
      if Supports(LeveledListEntries.Elements[i], IwbContainerElementRef, LeveledListEntry) and
        SameText(LeveledListEntry.Name, 'LVLO - Leveled List Entry') then begin
          SetLength(Entries, Succ(Length(Entries)));
          Entries[High(Entries)] := LeveledListEntry;
        end;

    for i := Low(Entries) to High(Entries) do
      for j := Low(Counts) to High(Counts) do begin
        LeveledListEntry := LeveledListEntries.Assign(Low(Integer), Entries[i], False) as IwbContainerElementRef;
        LeveledListEntry.ElementByName['Count'].NativeValue := Counts[j];
      end;
  end;
end;

var
  _PreviousCopyIntoSelectedModules: TwbModuleInfos;

function TfrmMain.CopyInto(AsNew, AsWrapper, AsSpawnRate, DeepCopy, AllowOverwrite: Boolean; const aElements: TDynElements; aAfterCopyCallback: TAfterCopyCallback): TDynElements;
var
  Elements             : TDynElements;
  MainRecord           : IwbMainRecord;
  MainRecord2          : IwbMainRecord;
  Master               : IwbMainRecord;
  GroupRecord          : IwbGroupRecord;
  TargetFile           : IwbFile;
  sl                   : TStringList;
  i, j                 : Integer;
  EditorID             : string;
  EditorIDPrefixRemove : string;
  EditorIDSuffixRemove : string;
  EditorIDPrefix       : string;
  EditorIDSuffix       : string;
  Multiple             : Boolean;
  LeveledListEntries   : IwbContainerElementRef;
  LeveledListEntry     : IwbContainerElementRef;
  CopiedElement        : IwbElement;
  Container            : IwbContainer;
  PrevOverwriteResult  : TModalResult;
  PrevDeleteResult     : TModalResult;
  lResult              : TDynElements;
  Operation            : string;
begin
  Result := nil;
  lResult := nil;
  Elements := aElements;

  if Assigned(aAfterCopyCallback) then begin
    Assert(not AsNew);
    Assert(not AsWrapper);
    Assert(not AsSpawnRate);
    Assert(not DeepCopy);
  end;

  if AsSpawnRate then begin
    Assert(not AsNew);
    Assert(not AsWrapper);
    Assert(not DeepCopy);
    aAfterCopyCallback := AfterCopyAdjustSpawnRate;
  end;

  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  try
    j := -1;

    begin
      var lDict := TwbFilesDictionary.Create;
      try
        for i := Low(Elements) to High(Elements) do begin
          if not Elements[i].CanCopy then begin
            if j < 0 then begin
              Elements := Copy(Elements);
              j := i;
            end;
          end else begin
            Elements[i].ReportRequiredMasters(lDict, AsNew);
            if DeepCopy then
              if Supports(Elements[i], IwbMainRecord, MainRecord) and Supports(MainRecord.ChildGroup, IwbGroupRecord, GroupRecord) then
                GroupRecord.ReportRequiredMasters(lDict, AsNew);
            Container := Elements[i].Container;
            while Assigned(Container) do begin
              Container.ReportRequiredMasters(lDict, AsNew, False, True);
              if Container.ElementType = etGroupRecord then
                with Container as IwbGroupRecord do begin
                  MainRecord := ChildrenOf;
                  if Assigned(MainRecord) then
                    MainRecord.ReportRequiredMasters(lDict, AsNew);
                end;

              Container := Container.Container;
            end;
            if j >= 0 then begin
              Elements[j] := Elements[i];
              Inc(j);
            end;
          end;
        end;

        for var lFile in lDict.Keys do
          sl.AddObject(lFile.FileName, Pointer(lFile));
      finally
        FreeAndNil(lDict);
      end;
    end;

    if j >= 0 then
      SetLength(Elements, j);

    if Length(Elements) < 1 then
      Exit;

    j := 0;
    for i := 0 to Pred(sl.Count) do
      with IwbFile(Pointer(sl.Objects[i])) do
        if LoadOrder > j then
          j := LoadOrder;

    AllowOverwrite := AllowOverwrite and (not (AsNew or AsWrapper or AsSpawnRate));

    PrevOverwriteResult := mrNone;
    PrevDeleteResult := mrNone;

    if AllowOverwrite then
      _wbCanOverwriteCallback := function (const aTarget, aSource: IwbElement): TwbCanOverwriteAction
      var
        MainRecord: IwbMainRecord;
        s: string;
      begin
        if Assigned(aTarget) then begin
          case PrevOverwriteResult of
            mrYesToAll: Result := coCopy;
            mrNoToAll: Result := coSkip;
          else
            PrevOverwriteResult := MessageDlg('Do you want to overwrite:' + CRLF + CRLF +
              aTarget.FullPath + CRLF + CRLF +
              'with' + CRLF + CRLF +
              aSource.FullPath + '?',
              mtConfirmation, mbYesNo + mbYesAllNoAllCancel, 0, mbNo);
            if PrevOverwriteResult in [mrYes, mrYesToAll] then
              Result := coCopy
            else
              Result := coSkip;
            if PrevOverwriteResult = mrCancel then begin
              wbProgress('Aborting...');
              Abort;
            end;
          end;
        end else
          Result := coCopy;

        if Result = coCopy then begin
          if Supports(aSource, IwbMainRecord, MainRecord) then
            if MainRecord.IsDeleted then begin
              case PrevDeleteResult of
                mrYesToAll: Result := coDelete;
                mrNoToAll: Result := coCopy;
              else
                if Assigned(aTarget) then
                  s := 'The source' + CRLF + CRLF +
                    aSource.FullPath + CRLF + CRLF +
                   'is flagged as deleted. Do you want to remove the target ' + CRLF + CRLF +
                    aTarget.FullPath + CRLF + CRLF +
                    'instead of copying the deleted record?'
                else
                  s := 'The source' + CRLF + CRLF +
                    aSource.FullPath + CRLF + CRLF +
                   'is flagged as deleted, and the target doesn''t exist.' + CRLF + CRLF +
                   'Do you want to skip copying this record?';
                PrevDeleteResult := MessageDlg(s,
                  mtConfirmation, mbYesNo + mbYesAllNoAllCancel, 0, mbNo);
                if PrevDeleteResult in [mrYes, mrYesToAll] then
                  Result := coDelete;
                if PrevDeleteResult = mrCancel then begin
                  wbProgress('Aborting...');
                  Abort;
                end;
              end;
            end;
        end;

        if (Result = coDelete) and not Assigned(aTarget) then
          Result := coSkip;

        case Result of
          coCopy:
            if Assigned(aTarget) then
              wbProgress('Overwriting "%s" with "%s"', [aTarget.FullPath, aSource.FullPath]);
          coDelete:
            if Assigned(aTarget) then
              wbProgress('Removing "%s"', [aTarget.FullPath]);
          coSkip:
            wbProgress('Skipping "%s"', [aSource.FullPath]);
        end;

      end;
    try
      with TfrmModuleSelect.Create(Self) do try

        AllModules := wbModulesByLoadOrder(True).FilteredByFlag(mfValid).FilteredBy(function(a: PwbModuleInfo): Boolean
          begin
            Result := mfTemplate in a.miFlags;
            if not Result then begin
              Result := Assigned(a.miFile) and a._File.IsEditable;
              if Result then
                Result := a._File.LoadOrder >= j;
            end;
            if Result and AsNew then begin
              if mfHasOverlayFlag in a.miFlags then
                Exit(False);
              if Assigned(a.miFile) and a._File.IsOverlay then
                Exit(False);
            end;
          end);

        Multiple := (Length(Elements) > 1) or (Elements[0].ElementType <> etMainRecord);
        EditorID := '';
        EditorIDPrefixRemove := '';
        EditorIDSuffixRemove := '';
        EditorIDPrefix := '';
        EditorIDSuffix := '';

        if not (AsNew or AsWrapper) then
          AllModules := AllModules.FilteredBy(function(a: PwbModuleInfo): Boolean
            begin
              Result := mfTemplate in a.miFlags;
              if not Result then
                for var lElementIdx := Low(Elements) to High(Elements) do begin
                  Result := not a._File.Equals(Elements[lElementIdx]._File);
                  if not Result then
                    Exit;
                end;
            end);

        if not Multiple then begin
          MainRecord := (Elements[0] as IwbMainRecord);
          Master := MainRecord.MasterOrSelf;
          if not (AsNew or AsWrapper) then begin
            if not AllowOverwrite then
              AllModules := AllModules.FilteredBy(function(a: PwbModuleInfo): Boolean
                var
                  i: Integer;
                begin
                  Result := mfTemplate in a.miFlags;
                  if not Result then begin
                    Result := not a._File.Equals(Master._File);
                    if Result then
                      for i := 0 to Pred(Master.OverrideCount) do begin
                        Result := not a._File.Equals(Master.Overrides[i]._File);
                        if not Result then
                          Exit;
                      end;
                  end;
                end);
          end else begin
            EditorID := MainRecord.EditorID;
            repeat
              if AsWrapper then begin
                if not InputQuery('EditorID', 'Please enter the EditorID for the wrapped copy', EditorID) then
                  Exit;
              end
              else begin
                if not InputQuery('EditorID', 'Please change the EditorID', EditorID) then
                  Exit;
              end;
              if EditorID = '' then
                Break;
              if not SameText(EditorID, MainRecord.EditorID) then
                Break;
              if AsWrapper then
                ShowMessage('You need to specify a different EditorID for the wrapped copy.')
              else if MessageDlg('Are you sure you don''t want to change the EditorID?' +
                ' EditorID conflicts will cause error messages in CS when loading.',
                mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then
                Break;
            until False;
          end;
        end
        else begin
          if AsWrapper then
            if Elements[0].ElementType <> etMainRecord then
              raise Exception.Create('Can not wrap complete groups');

          if AsNew or AsWrapper then
            repeat
              if not InputQuery('EditorID Prefix', 'Please enter the prefix that should be removed from the EditorIDs if present', EditorIDPrefixRemove) then
                Exit;
              if not InputQuery('EditorID Suffix', 'Please enter the suffix that should be removed from the EditorIDs if present', EditorIDSuffixRemove) then
                Exit;
              if not InputQuery('EditorID Prefix', 'Please enter the prefix that should be added to EditorIDs', EditorIDPrefix) then
                Exit;
              if not InputQuery('EditorID Suffix', 'Please enter the suffix that should be added to EditorIDs', EditorIDSuffix) then
                Exit;
              if (EditorIDPrefix <> '') or (EditorIDSuffix <> '') then
                Break;
              if AsWrapper then
                ShowMessage('You need to specify a prefix or suffix.')
              else if MessageDlg('Are you sure you don''t want to change the EditorID?' +
                ' EditorID conflicts will cause error messages in CS when loading.',
                mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes then
                Break;
            until False;
        end;


        if Multiple then
          Caption := 'Which files do you want to add these records to?'
        else
          Caption := 'Which files do you want to add this record to?';

        FilterFlag := mfValid;
        SelectFlag := mfTagged;
        AllModules.ExcludeAll(mfTagged);
        _PreviousCopyIntoSelectedModules.IncludeAll(mfTagged);
        MinSelect := 1;
        AllowCancel;

        if ShowModal <> mrOK then
          Exit;

        if Length(SelectedModules) < 1 then
          Exit;

        _PreviousCopyIntoSelectedModules := Copy(SelectedModules);

        Operation := 'Copying ';
        if AsNew then
          Operation := Operation + 'as new record'
        else if AsWrapper then
          Operation := Operation + 'as wrapper'
        else if AsSpawnRate then
          Operation := Operation + 'as spawn rate adjuster'
        else begin
          Operation := Operation + 'as override';
          if AllowOverwrite then
            Operation := Operation + ' (with overwrite)';
        end;

        SetLength(lResult, Length(Elements));

        PerformLongAction(Operation, '', procedure
        var
          i, j: Integer;
        begin
          for i := Low(SelectedModules) to High(SelectedModules) do
            begin
              if mfTemplate in SelectedModules[i].miFlags then begin
                TargetFile := nil;
                while not Assigned(TargetFile) do
                  if not AddNewFile(TargetFile, SelectedModules[i]) then
                    Break;
                if Assigned(TargetFile) then
                  _PreviousCopyIntoSelectedModules[i] := TargetFile.ModuleInfo;
              end else
                TargetFile := SelectedModules[i]._File;

              if Assigned(TargetFile) then begin
                sl.Clear;
                var lDict2 := TwbFilesDictionary.Create;
                try
                  for j := Low(Elements) to High(Elements) do begin
                    Elements[j].ReportRequiredMasters(lDict2, AsNew);
                    if DeepCopy then
                      if Supports(Elements[j], IwbMainRecord, MainRecord) and Supports(MainRecord.ChildGroup, IwbGroupRecord, GroupRecord) then
                        GroupRecord.ReportRequiredMasters(lDict2, AsNew);
                    Container := Elements[j].Container;
                    while Assigned(Container) do begin
                      Container.ReportRequiredMasters(lDict2, AsNew, False, True);
                      if Container.ElementType = etGroupRecord then
                        with Container as IwbGroupRecord do begin
                          MainRecord := ChildrenOf;
                          if Assigned(MainRecord) then begin
                            MainRecord := MainRecord.HighestOverrideVisibleForFile[TargetFile];
                            MainRecord.ReportRequiredMasters(lDict2, AsNew);
                          end;
                        end;

                      Container := Container.Container;
                    end;
                  end;
                  for var lFile in lDict2.Keys do
                    sl.AddObject(lFile.FileName, Pointer(lFile));
                finally
                  FreeAndNil(lDict2);
                end;
              end;

              if Assigned(TargetFile) and AddRequiredMasters(sl, TargetFile,
                mfTemplate in SelectedModules[i].miFlags) then begin

                if AsWrapper then begin

                  for j := Low(Elements) to High(Elements) do begin
                    MainRecord := Elements[j] as IwbMainRecord;
                    wbCurrentProgress := Format('[%s] into [%s]', [MainRecord.FullPath, TargetFile.FullPath]);
                    wbProgress(Operation + ' ' + wbCurrentProgress);

                    MainRecord2 := wbCopyElementToFile(MainRecord, TargetFile, True, True, EditorIDPrefixRemove, EditorIDSuffixRemove, EditorIDPrefix, EditorIDSuffix, False) as IwbMainRecord;
                    wbProgress('');

                    Assert(Assigned(MainRecord2));
                    if not Multiple then
                      MainRecord2.EditorID := EditorID;

                    EditorID := MainRecord.EditorID;
                    MainRecord := wbCopyElementToFile(MainRecord, TargetFile, False, False, '', '', '', '', AllowOverwrite) as IwbMainRecord;
                    wbProgress('');
                    Assert(Assigned(MainRecord));
                    MainRecord.Assign(Low(Integer), nil, False);
                    LeveledListEntries := MainRecord.ElementByName['Leveled List Entries'] as IwbContainerElementRef;
                    Assert(Assigned(LeveledListEntries));
                    Assert(LeveledListEntries.ElementCount = 1);
                    LeveledListEntry := LeveledListEntries.Elements[0] as IwbContainerElementRef;
                    Assert(Assigned(LeveledListEntry));
                    LeveledListEntry.ElementByName['Reference'].EditValue := MainRecord2.EditValue;
                    LeveledListEntry.ElementByName['Count'].EditValue := '1';
                    LeveledListEntry.ElementByName['Level'].EditValue := '1';
                    MainRecord.EditorID := EditorID;
                    lResult[j] := MainRecord;
                    wbProgress('');
                  end;

                end
                else if Multiple then begin
                  for j := Low(Elements) to High(Elements) do
                    try
                      if DeepCopy and Supports(Elements[j], IwbMainRecord, MainRecord) and Assigned(MainRecord.ChildGroup) then begin
                        wbProgress(Operation + ' ' + wbCurrentProgress);
                        lResult[j] := wbCopyElementToFile(MainRecord.ChildGroup, TargetFile, AsNew, True, EditorIDPrefixRemove, EditorIDSuffixRemove, EditorIDPrefix, EditorIDSuffix, AllowOverwrite);
                        wbProgress('');
                      end else begin
                        wbCurrentProgress := Format('[%s] into [%s]', [Elements[j].FullPath, TargetFile.FullPath]);
                        wbProgress(Operation + ' ' + wbCurrentProgress);
                        CopiedElement := wbCopyElementToFile(Elements[j], TargetFile, AsNew, True, EditorIDPrefixRemove, EditorIDSuffixRemove, EditorIDPrefix, EditorIDSuffix, AllowOverwrite);
                        wbProgress('');
                        if Assigned(CopiedElement) then begin
                          if Assigned(aAfterCopyCallback) then
                            aAfterCopyCallback(CopiedElement);
                        end;
                        lResult[j] := CopiedElement;
                        wbProgress('');
                      end;
                    except
                      on E: EAbort do
                        raise;
                      on E: Exception do
                        wbProgress('Error while copying [%s]: [%s] %s', [Elements[j].FullPath, E.ClassName, E.Message]);
                    end;
                end else begin
                  MainRecord := nil;
                  if DeepCopy and Supports(Elements[0], IwbMainRecord, MainRecord) and Assigned(MainRecord.ChildGroup) then begin
                    wbCurrentProgress := Format('[%s] into [%s]', [MainRecord.ChildGroup.FullPath, TargetFile.FullPath]);
                    wbProgress(Operation + ' ' + wbCurrentProgress);
                    lResult[0] := wbCopyElementToFile(MainRecord.ChildGroup, TargetFile, AsNew, True, '', '', '', '', AllowOverwrite);
                    wbProgress('');
                  end else begin
                    wbCurrentProgress := Format('[%s] into [%s]', [Elements[0].FullPath, TargetFile.FullPath]);
                    wbProgress(Operation + ' ' + wbCurrentProgress);
                    CopiedElement := wbCopyElementToFile(Elements[0], TargetFile, AsNew, True, '', '', '', '', AllowOverwrite);
                    wbProgress('');
                    if Assigned(CopiedElement) then begin
                      if Assigned(aAfterCopyCallback) then
                        aAfterCopyCallback(CopiedElement);
                    end;
                    wbProgress('');
                    lResult[0] := CopiedElement;
                    if not Supports(CopiedElement, IwbMainRecord, MainRecord) then
                      MainRecord := nil;
                  end;
                  if AsNew and Assigned(MainRecord) then
                    MainRecord.EditorID := EditorID;
                end;
              end;
            end;
          wbCurrentProgress := '';
        end);
        Result := lResult;
      finally
        Free;
      end;
    finally
      _wbCanOverwriteCallback := nil;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.AddNewFileWithDialog;
begin
  with TfrmModuleSelect.Create(Self) do try
    AllModules := wbModulesByLoadOrder(True).FilteredByFlag(mfValid).FilteredByFlag(mfTemplate);
    Caption := 'What type of module do you want to create?';

    FilterFlag := mfValid;
    SelectFlag := mfTagged;
    AllModules.ExcludeAll(mfTagged);
    MinSelect := 1;
    AllowCancel;

    if ShowModal <> mrOK then
      Exit;

    if Length(SelectedModules) <> 1 then
      Exit;

    if not (mfTemplate in SelectedModules[0].miFlags) then
      Exit;

    var NewFile: IwbFile := nil;
    AddNewFile(NewFile, SelectedModules[0]);

  finally
    Free;
  end;
end;

procedure TfrmMain.mniNavChangeReferencingRecordsClick(Sender: TObject);
var
  s                           : string;
  i                           : Integer;
  NewFormID                   : TwbFormID;
  OldFormID                   : TwbFormID;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  ReferencedBy                : TDynMainRecords;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  MainRecord := NodeData.Element as IwbMainRecord;

  if not EditWarn then
    Exit;

  SetLength(ReferencedBy, ActiveMaster.ReferencedByCount);
  for i := 0 to Pred(ActiveMaster.ReferencedByCount) do
    ReferencedBy[i] := ActiveMaster.ReferencedBy[i];

  if InputQuery('New FormID', 'Please enter the new FormID in hex. e.g. 0404CC43. The FormID needs to be a load order corrected form ID.', s) then try
    NewFormID := TwbFormID.FromStr(s);
    if NewFormID.IsNull then
      raise Exception.Create('00000000 is not a valid FormID');
    if NewFormID.IsPlayer then
      raise Exception.Create('00000014 is not a valid FormID');

    OldFormID := MainRecord.LoadOrderFormID;
    if NewFormID = OldFormID then begin
      ShowMessage('Old and new FormID are identical');
      Exit;
    end;

    if Length(ReferencedBy) > 0 then
      ShowChangeReferencedBy(OldFormID, NewFormID, ReferencedBy, False)
    else
      raise Exception.Create('No other records reference this record');
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

function TfrmMain.CheckForErrorsLinear(const aElement: IwbElement; LastRecord: IwbMainRecord): IwbMainRecord;
var
  Error                       : string;
  Container                   : IwbContainerElementRef;
  i                           : Integer;
begin
  Error := aElement.Check;
  if Error <> '' then begin
    Result := aElement.ContainingMainRecord;
    // first error in this record - show record's name
    if Assigned(Result) and (Result <> LastRecord) then begin
      Inc(ErrorsCount);
      wbCurrentProgress := Format('Processed Records: %d, Errors found: %d', [CheckedCount, ErrorsCount]);
      wbProgress(Result.Name);
    end;
    wbProgress('    ' + aElement.Path + ' -> ' + Error);
  end else begin
    // passing through last record with error
    Result := LastRecord;
    wbTick;
  end;

  if Supports(aElement, IwbContainerElementRef, Container) then
    for i := 0 to Pred(Container.ElementCount) do
      Result := CheckForErrorsLinear(Container.Elements[i], Result);

  if aElement.ElementType = etMainRecord then begin
    Inc(CheckedCount);
    wbCurrentProgress := Format('Processed Records: %d, Errors found: %d', [CheckedCount, ErrorsCount]);
  end;
end;

function TfrmMain.CheckForErrors(const aIndent: Integer; const aElement: IwbElement): Boolean;
var
  Error                       : string;
  Container                   : IwbContainerElementRef;
  i                           : Integer;
begin
  Error := aElement.Check;
  Result := Error <> '';
  if Result then begin
    Error := aElement.Check;
    wbProgress(StringOfChar(' ', aIndent * 2) + aElement.Name + ' -> ' + Error);
  end else
    wbProgress('');
//!!!!
  if Supports(aElement, IwbContainerElementRef, Container) then
    for i := Pred(Container.ElementCount) downto 0 do
      Result := CheckForErrors(aIndent + 1, Container.Elements[i]) or Result;

  if Result and (Error = '') then begin
    wbProgress(StringOfChar(' ', aIndent * 2) + 'Above errors were found in :' + aElement.Name);
  end;
end;

procedure TfrmMain.CheckHistoryRemove(const aList: IInterfaceList; const aMainRecord: IwbMainRecord);
var
  i                           : Integer;
  Intf                        : IInterface;
  HistoryEntry                : IHistoryEntry;
begin
  if not Assigned(aList) then
    Exit;
  if not Assigned(aMainRecord) then
    Exit;
  for i := Pred(aList.Count) downto 0 do begin
    Intf := aList[i];
    if Supports(Intf, IHistoryEntry, HistoryEntry) then
      if HistoryEntry.Remove(aMainRecord) then
        aList.Remove(Intf);
  end;
end;

procedure TfrmMain.CheckViewForChange;

  function Changed: Boolean;
  var
    i       : Integer;
  begin
    Result := False;
    for i := Low(ActiveRecords) to High(ActiveRecords) do
      with ActiveRecords[i] do begin
        if Assigned(Element) then
          if ElementGen <> Element.ElementGeneration then
            Exit(True);
        if Assigned(Container) then
          if ContainerGen <> Container.ElementGeneration then
            Exit(True);
      end;
  end;

begin
  if Changed then
    PostResetActiveTree;
end;

procedure TfrmMain.mniNavCheckForCircularLeveledListsClick(Sender: TObject);

  procedure CheckGroup(const aGroup: IwbGroupRecord);
  var
    i          : Integer;
    MainRecord : IwbMainRecord;
  begin
    if not Assigned(aGroup) then
      Exit;
    for i := 0 to Pred(aGroup.ElementCount) do
      if Supports(aGroup.Elements[i], IwbMainRecord, MainRecord) then try
        wbLeveledListCheckCircular(MainRecord.WinningOverride, nil);
      except
        on e: Exception do
          PostAddMessage(E.Message);
      end;
  end;

var
  i     : Integer;
  _File : IwbFile;
begin
  ResetAllTags;
  for i := Low(Files) to High(Files) do begin
    _File := Files[i];
    CheckGroup(_File.GroupBySignature['LVLI']);
    CheckGroup(_File.GroupBySignature['LVLC']);
    CheckGroup(_File.GroupBySignature['LVLN']);
    CheckGroup(_File.GroupBySignature['LVSP']);
  end;
end;

procedure TfrmMain.mniNavCheckForErrorsClick(Sender: TObject);
begin
  UserWasActive := True;

  PerformLongAction('Checking for Errors', '', procedure
  var
    Nodes                       : TNodeArray;
    NodeData                    : PNavNodeData;
    i                           : Integer;
  begin
    ErrorsCount := 0;
    CheckedCount := 0;

    Nodes := vstNav.GetSortedSelection(True);
    for i := Low(Nodes) to High(Nodes) do begin
      NodeData := vstNav.GetNodeData(Nodes[i]);
      if Assigned(NodeData) then begin
        if Assigned(NodeData.Element) then begin
          wbCurrentAction := 'Checking for Errors in ' + NodeData.Element.Name;
          wbProgress(wbCurrentAction);
          CheckForErrorsLinear(NodeData.Element, nil)
        end;
        if Assigned(NodeData.Container) and
           not NodeData.Container.Equals(NodeData.Element)
        then begin
          wbCurrentAction := 'Checking for Errors in ' + NodeData.Container.Name;
          wbProgress(wbCurrentAction);
          CheckForErrorsLinear(NodeData.Container, nil)
        end;
      end;
    end;
  end);
end;

procedure TfrmMain.mniNavCleaningObsoleteClick(Sender: TObject);
begin
  ShowMessage('This function has been made obsolete by the introduction of Quick Auto Clean mode.' + CRLF + CRLF +
    'If you have used this function because you were following a guide, please be aware that the guide is outdated and no longer applies.' + CRLF + CRLF +
    'For more information about Quick Auto Clean mode, please check the What''s New document or the online help (press the help button in the top right corner of the main form).' + CRLF + CRLF +
    'You can hide this function by checking the "Hide Manual Cleaning functions" Option.');
end;

procedure TfrmMain.mniNavCleanMastersClick(Sender: TObject);
begin
  DoSetActiveRecord(nil);
  PerformActionOnSelectedFiles('cleaning masters', procedure(aFile: IwbFile)
  begin
    aFile.CleanMasters;
  end);
end;

procedure TfrmMain.mniNavCompareSelectedClick(Sender: TObject);
var
  SelectedNodes               : TNodeArray;
  NodeData                    : PNavNodeData;
  MainRecords                 : TDynMainRecords;
  i                           : Integer;
begin
  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 2 then
    Exit;

  SetLength(MainRecords, Length(SelectedNodes));
  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    NodeData := vstNav.GetNodeData(SelectedNodes[i]);
    MainRecords[i] := NodeData.Element as IwbMainRecord;
  end;

  DoSetActiveRecord(MainRecords);
end;

procedure TfrmMain.mniNavCompareToClick(Sender: TObject);
var
  _File        : IwbFile;
  NodeData     : PNavNodeData;
  CompareFile  : string;
  fPath        : string;
  s            : String;
  i            : Integer;
  States       : TwbFileStates;
begin
  States := [];
  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if not Assigned(NodeData) then
    Exit;
  if not Supports(NodeData.Element, IwbFile, _File) then
    Exit;

  with odModule do begin
    Title := 'Please select the file you want to compare to "'+_File.FileName+'"...';
    FileName := '';
    InitialDir := Settings.ReadString('CompareTo', 'InitialDir', wbDataPath);
    if not Execute then
      Exit;

    CompareFile := FileName;
    Settings.WriteString('CompareTo', 'InitialDir', ExtractFilePath(CompareFile));
    Settings.UpdateFile;
    if wbIsModule(CompareFile) then
      fPath := wbDataPath
    else
      fPath := wbSavePath;

    // copy selected file to Data directory without overwriting an existing file
    if not SameText(ExtractFilePath(CompareFile), fPath) or (mfHasFile in wbModuleByName(ExtractFileName(CompareFile)).miFlags) then begin
      s := fPath + ExtractFileName(CompareFile);
      if FileExists(s) or (mfHasFile in wbModuleByName(ExtractFileName(s)).miFlags) then // Finds a unique name
        for i := 0 to 255 do begin
          s := fPath + ChangeFileExt(ChangeFileExt(ExtractFileName(CompareFile),'') + IntToHex(i, 3), ExtractFileExt(CompareFile));
          if not (FileExists(s) or (mfHasFile in wbModuleByName(ExtractFileName(s)).miFlags)) then
            break;
        end;
      if FileExists(s) or (mfHasFile in wbModuleByName(ExtractFileName(s)).miFlags) then begin
        wbProgress('Could not copy '+FileName+' into '+fPath);
        Exit;
      end;
      CompareFile := s;
      CopyFile(PChar(FileName), PChar(CompareFile), false);
      // We need to propagate a flag to mark the copy temporary, so it can be deleted on close
      Include(States, fsIsTemporary);
    end;
  end;

  vstNav.PopupMenu := nil;
  bnMainMenu.Enabled := False;
  wbLoaderDone := False;
  wbLoaderError := False;
  DoSetActiveRecord(nil);
  mniNavFilterRemoveClick(Sender);
  wbStartTime := Now;
  TLoaderThread.Create(CompareFile, _File.FileName, _File.LoadOrder, States);
end;

procedure TfrmMain.mniNavCreateDeltaPatchClick(Sender: TObject);
var
  _File        : IwbFile;
  NodeData     : PNavNodeData;
  CompareFile  : string;
  s            : String;
  i            : Integer;
begin
  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if not Assigned(NodeData) then
    Exit;
  if not Supports(NodeData.Element, IwbFile, _File) then
    Exit;
  if _File.IsNotPlugin then begin
    ShowMessage('Delta patch can only be created for modules');
    Exit;
  end;

  with odModule do begin
    Title := 'Please select a newer verion of "'+_File.FileName+'" to create a delta patch...';
    FileName := '';
    InitialDir := Settings.ReadString('CreateDeltaPatch', 'InitialDir', wbDataPath);
    if not Execute then
      Exit;

    CompareFile := FileName;
    Settings.WriteString('CreateDeltaPatch', 'InitialDir', ExtractFilePath(CompareFile));
    Settings.UpdateFile;

    if not wbIsModule(CompareFile) then begin
      ShowMessage('Delta patch can only be created for modules');
      Exit;
    end;

    s := ChangeFileExt(ExtractFileName(CompareFile), '');

    repeat
      if not InputQuery('Delta Patch Filename', 'Please specify the name of the delta patch (without extension)', s) then
        Exit;
      CompareFile := wbDataPath + s + '.esu';
      if FileExists(CompareFile) then
        ShowMessage('A module called "' + s + '.esu" already exists.')
      else
        Break;
    until False;

    CopyFile(PChar(FileName), PChar(CompareFile), false);
  end;

  vstNav.PopupMenu := nil;
  bnMainMenu.Enabled := False;
  wbLoaderDone := False;
  wbLoaderError := False;
  DoSetActiveRecord(nil);
  mniNavFilterRemoveClick(Sender);
  wbStartTime := Now;
  DoSetActiveRecord(nil);
  pgMain.ActivePage := tbsMessages;
  TLoaderThread.Create(CompareFile, _File.FileName, _File.LoadOrder, [fsIsDeltaPatch]);
end;

procedure TfrmMain.mniNavCopyIdleClick(Sender: TObject);
var
  i, j, k        : Integer;
  Container      : IwbContainerElementRef;
  MainRecord     : IwbMainRecord;
  MainRecords    : TDynMainRecords;
  s              : string;
  sl             : TwbFastStringListIC;
  List           : TList;
  OldElements    : TDynElements;
  NewElements    : TDynElements;
  OldModelPrefix : string;
  NewModelPrefix : string;
  OldFormIDs     : TwbFormIDs;
  NewFormIDs     : TwbFormIDs;
  OldMainRecord  : IwbMainRecord;
  NewMainRecord  : IwbMainRecord;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  ResetAllTags;

  sl := TwbFastStringListIC.CreateSorted;
  try
    for i := Low(Files) to High(Files) do
      if Supports(Files[i].GroupBySignature['IDLE'], IwbContainerElementRef, Container) then begin
        for j := 0 to Pred(Container.ElementCount) do
          if Supports(Container.Elements[j], IwbMainRecord, MainRecord) then begin
            MainRecord := MainRecord.WinningOverride;
            if not MainRecord.IsTagged then begin
              MainRecord.Tag;
              s := Trim(LowerCase((MainRecord.ElementEditValues['MODL\MODL'])));
              if ExtractFileExt(s) <> '' then
                s := ExtractFilePath(s);
              s := ExcludeTrailingPathDelimiter(s);

              if not sl.Find(s, k) then
                k := sl.AddObject(s, TList.Create);

              TList(sl.Objects[k]).Add(Pointer(MainRecord));

              SetLength(MainRecords, Succ(Length(MainRecords)));
              MainRecords[High(MainRecords)] := MainRecord;
            end;
          end;
      end;

      with TfrmFileSelect.Create(nil) do try

        CheckListBox1.Items.Assign(sl);
        Caption := 'Which Idles do you want to copy?';

        if ShowModal <> mrOK then
          Exit;

        for i := 0 to Pred(CheckListBox1.Items.Count) do
          if CheckListBox1.Selected[i] then begin
            List := CheckListBox1.Items.Objects[i] as TList;
            SetLength(OldElements, List.Count);
            for j := 0 to Pred(List.Count) do
              Supports(IInterface(List[j]), IwbElement, OldElements[j]);

            OldModelPrefix := CheckListBox1.Items[i];
            NewModelPrefix := OldModelPrefix;

            repeat
              if not InputQuery('Model Prefix', 'Please change the model prefix', NewModelPrefix) then
                Exit;
            until not SameText(OldModelPrefix, NewModelPrefix);

            NewElements := CopyInto(True, False, False, True, False, OldElements);
            Assert(Length(NewElements) = Length(OldElements));

            SetLength(OldFormIDs, Length(NewElements));
            SetLength(NewFormIDs, Length(NewElements));

            for j := Low(NewElements) to High(NewElements) do begin
              if not Supports(OldElements[j], IwbMainRecord, OldMainRecord) then
                Assert(False);
              if not Supports(NewElements[j], IwbMainRecord, NewMainRecord) then
                Assert(False);

              OldFormIDs[j] := OldMainRecord.LoadOrderFormID;
              NewFormIDs[j] := NewMainRecord.LoadOrderFormID;
            end;

            for j := Low(NewElements) to High(NewElements) do begin
              if not Supports(NewElements[j], IwbMainRecord, NewMainRecord) then
                Assert(False);

              s := Trim(LowerCase((NewMainRecord.ElementValues['MODL\MODL'])));
              s := NewModelPrefix + Copy(s, Succ(Length(OldModelPrefix)), High(Integer));
              NewMainRecord.ElementEditValues['MODL\MODL'] := s;

              for k := Low(OldFormIDs) to High(OldFormIDs) do
                NewMainRecord.CompareExchangeFormID(OldFormIDs[k], NewFormIDs[k]);
            end;
          end;
      finally
        Free;
      end;

  finally
    for i := 0 to Pred(sl.Count) do
      sl.Objects[i].Free;
    sl.Free;
  end;
end;

procedure TfrmMain.mniNavCopyIntoClick(Sender: TObject);
var
  SelectedNodes               : TNodeArray;
  NodeData                    : PNavNodeData;
  Elements                    : TDynElements;
  i, j                        : Integer;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 1 then
    Exit;

  SetLength(Elements, Length(SelectedNodes));
  j := 0;
  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    NodeData := vstNav.GetNodeData(SelectedNodes[i]);
    if NodeData.Element.CanCopy then begin
      Elements[j] := NodeData.Element;
      Inc(j);
    end;
  end;
  SetLength(Elements, j);
  if j < 1 then
    Exit;

  CopyInto(
    Sender = mniNavCopyAsNewRecord,
    Sender = mniNavCopyAsWrapper,
    Sender = mniNavCopyAsSpawnRateOverride,
    (Sender = mniNavDeepCopyAsOverride) or (Sender = mniNavDeepCopyAsOverrideWithOverwriting),
    (Sender = mniNavCopyAsOverrideWithOverwrite) or (Sender = mniNavDeepCopyAsOverrideWithOverwriting),
    Elements);

  for i := Low(SelectedNodes) to High(SelectedNodes) do
    vstNav.IterateSubtree(SelectedNodes[i], ClearConflict, nil);
  InvalidateElementsTreeView(SelectedNodes);
  PostResetActiveTree;
  if (Length(Elements) > 1) or (Elements[0].ElementType <> etMainRecord) then
    vstNav.Invalidate;
end;

procedure TfrmMain.mniNavCreateMergedPatchClick(Sender: TObject);
var
  KeepAlive       : array of IwbContainerElementRef;
  TargetFile      : IwbFile;

  procedure UpdateOrderedTargetList(LeftList, RightList, TargetList: TStringList);
  var
    i: Integer;
  begin
    for i := LeftList.Count to Pred(RightList.Count) do
      TargetList.AddObject(RightList[i], RightList.Objects[i]);
  end;

  procedure UpdateTargetList(LeftList, RightList, TargetList: TStringList);
  var
    Left, Right : Integer;
    Index       : Integer;
  begin
    Left := 0;
    Right := 0;

    while (Left < LeftList.Count) and (Right < RightList.Count) do
      case CompareText(LeftList[Left], RightList[Right]) of
        Low(Integer)..-1: begin
          if TargetList.Find(LeftList[Left], Index) then
            TargetList.Delete(Index);
          Inc(Left);
        end;
        0: begin
          if TargetList.Find(LeftList[Left], Index) then
            TargetList.Objects[Index] := RightList.Objects[Right];
          Inc(Left);
          Inc(Right);
        end;
        1..High(Integer): begin
          if not TargetList.Find(RightList[Right], Index) then
            TargetList.AddObject(RightList[Right], RightList.Objects[Right]);
          Inc(Right);
        end;
      end;

    while (Left < LeftList.Count) do begin
      if TargetList.Find(LeftList[Left], Index) then
        TargetList.Delete(Index);
      Inc(Left);
    end;

    while (Right < RightList.Count) do begin
      if not TargetList.Find(RightList[Right], Index) then
        TargetList.AddObject(RightList[Right], RightList.Objects[Right]);
      Inc(Right);
    end;
  end;

  function ListsEqual(Left, Right: TStringList; ForOrderedList: Boolean = False): Boolean;
  var
    i: Integer;
  begin
    if ForOrderedList then
      Result := Left.Count <= Right.Count
    else
      Result := Left.Count = Right.Count;

    if Result then
      for i := 0 to Pred(Left.Count) do
        if not SameText(Left[i], Right[i]) then begin
          Result := False;
          Exit;
        end;
  end;

  procedure CheckGroup(const aGroup: IwbGroupRecord; const aListNames: array of string;
                       const aCntNames: array of string; aAsSet: Boolean = False);
  var
    IsOrderedList: Boolean;

    function BuildList(const aEntries: IwbElement): TStringList;
    var
      i       : Integer;
      Entries : IwbContainerElementRef;
      Entry   : IwbContainerElementRef;
      Last    : string;
      Count   : Integer;
    begin
      Result := TStringList.Create;
      try
        if aAsSet and not IsOrderedList then begin
          Result.Sorted := True;
          Result.Duplicates := dupIgnore;
        end;
        if not Supports(aEntries, IwbContainerElementRef, Entries) then
          Exit;
        for i := 0 to Pred(Entries.ElementCount) do
          if Supports(Entries.Elements[i], IwbContainerElementRef, Entry) then begin
            SetLength(KeepAlive, Succ(Length(KeepAlive)));
            KeepAlive[High(KeepAlive)] := Entry;
            Result.AddObject(Entry.DisplaySortKey[True], Pointer(Entry));
          end;
        if not aAsSet then begin
          Result.Sort;
          Last := '';
          Count := 0;
          for i := 0 to Pred(Result.Count) do begin
            if Result[i] = Last then
              Inc(Count)
            else begin
              Count := 0;
              Last := Result[i];
            end;
            Result[i] := Result[i] + '#' + IntToHex64(Count, 4);
          end;
          Result.Sorted := True;
        end;
      except
        FreeAndNil(Result);
        raise;
      end;
    end;

  var
    i, j, k, l         : Integer;
    MainRecord         : IwbMainRecord;
    TargetRecord       : IwbMainRecord;
    Master             : IwbMainRecord;
    TargetLists        : array of TStringList;
    WinningLists       : array of TStringList;
    CurrentList        : TStringList;
    CurrentMasterList  : TStringList;
    CurrentMasters     : TDynMainRecords;
    CurrentMaster      : IwbMainRecord;
    EditorID           : string;
    SortableContainer  : IwbSortableContainer;
    IsFaultyOrderedList: Boolean;
    CountElement       : IwbElement;
    Entries            : IwbContainerElementRef;
  const
    OrderedList = 'OrderedList';
  begin
    if not Assigned(aGroup) then
      Exit;
    for i := 0 to Pred(aGroup.ElementCount) do
      if Supports(aGroup.Elements[i], IwbMainRecord, MainRecord) then try
        IsFaultyOrderedList := False;
        Master := MainRecord.MasterOrSelf;
        if Master.IsTagged then
          Continue;
        Master.Tag;
        if Master.OverrideCount < 2 then
          Continue;

        SetLength(TargetLists, Length(aListNames));
        SetLength(WinningLists, Length(aListNames));

        for l := Low(aListNames) to High(aListNames) do begin
          IsOrderedList := False;
          if Supports(Master.ElementByName[aListNames[l]], IwbSortableContainer, SortableContainer) then
            if not SortableContainer.Sorted then begin
              EditorID := Master.EditorID;
              if Length(EditorID) > Length(OrderedList) then
                Delete(EditorID, 1, Length(EditorID)-Length(OrderedList));
              IsOrderedList := SameText(EditorID, OrderedList);
              if not IsOrderedList then
                Continue;
            end;

          TargetLists[l] := BuildList(Master.ElementByName[aListNames[l]]);
          for j := 0 to Pred(Master.OverrideCount) do begin
            MainRecord := Master.Overrides[j];
            CurrentList := BuildList(MainRecord.ElementByName[aListNames[l]]);
            CurrentMasters := MainRecord.MasterRecordsFromMasterFilesAndSelf;
            CurrentMaster := nil;
            for k := High(CurrentMasters) downto Low(CurrentMasters) do
              if not MainRecord.Equals(CurrentMasters[k]) then begin
                CurrentMaster := CurrentMasters[k];
                Break;
              end;
            if not Assigned(CurrentMaster) then
              Continue;
            CurrentMasterList := BuildList(CurrentMaster.ElementByName[aListNames[l]]);

            if IsOrderedList then begin
              if not ListsEqual(CurrentMasterList, CurrentList, True) then begin
                ListsEqual(CurrentMasterList, CurrentList, True);
                IsFaultyOrderedList := True
              end else
                UpdateOrderedTargetList(CurrentMasterList, CurrentList, TargetLists[l]);
            end else
              UpdateTargetList(CurrentMasterList, CurrentList, TargetLists[l]);

            CurrentList.Free;
            CurrentMasterList.Free;
            if IsFaultyOrderedList then
              Break;
          end;
          if IsFaultyOrderedList then
            Break;
          MainRecord := Master.WinningOverride;
          WinningLists[l] := BuildList(MainRecord.ElementByName[aListNames[l]]);
        end;

        if IsFaultyOrderedList then begin
          PostAddMessage('Error: Can''t merge faulty ordered list ' + Master.Name);
        end else begin
          TargetRecord := nil;
          for l := Low(aListNames) to High(aListNames) do
            if Assigned(TargetLists[l]) and Assigned(WinningLists[l]) then
              if not ListsEqual(TargetLists[l], WinningLists[l]) then begin
                if not Assigned(TargetRecord) then
                  TargetRecord := wbCopyElementToFile(MainRecord, TargetFile, False, True, '', '', '', '', False) as IwbMainRecord;

                TargetRecord.RemoveElement(aListNames[l]);
                for j := 0 to Pred(TargetLists[l].Count) do
                  wbCopyElementToRecord(IwbElement(Pointer(TargetLists[l].Objects[j])), TargetRecord, True, True);

                // update counts
                if (l <= High(aCntNames)) and (aCntNames[l] <> '') then begin
                  TargetRecord.Add(aCntNames[l], True);
                  CountElement := TargetRecord.ElementByPath[aCntNames[l]];
                  if Assigned(CountElement) then
                    if Supports(TargetRecord.ElementByName[aListNames[l]], IwbContainerElementRef, Entries) then
                      CountElement.NativeValue := Entries.ElementCount
                    else
                      CountElement.Remove;
                end;

              end;
        end;

        for l := Low(aListNames) to High(aListNames) do begin
          FreeAndNil(WinningLists[l]);
          FreeAndNil(TargetLists[l]);
        end;
        KeepAlive := nil;
      except
        on e: Exception do
          PostAddMessage(E.Message);
      end;
  end;

var
  sl              : TStringList;
  LastLoadOrder   : Integer;
  i               : Integer;
  EditState       : Boolean;
begin
  if wbIsSkyrim or wbIsFallout4 or wbIsFallout76 or wbIsStarfield then begin
    if MessageDlg('Merged patch is unsupported for ' + wbGameName2 +
      '. Create it only if you know what you are doing and can troubleshoot possible issues yourself. ' +
      'Do you want to continue?',
      mtWarning, mbYesNo, 0) <> mrYes
    then
      Exit;
  end;

  TargetFile := nil;

  while not Assigned(TargetFile) do
    if not AddNewFile(TargetFile, False, False) then
      Exit;

  sl := TStringList.Create;
  try
    LastLoadOrder := -1;
    for i := Low(Files) to Pred(High(Files)) do
      with Files[i] do
        if LoadOrder > LastLoadOrder then begin
          LastLoadOrder := LoadOrder;
          sl.Add(FileName);
        end;
    TargetFile.AddMasters(sl);
  finally
    FreeAndNil(sl);
  end;

  ResetAllTags;

  EditState := wbAllowInternalEdit;
  try
    // do not dynamically update counter fields, they are set by merging code
    wbAllowInternalEdit := False;

    for i := Succ(Low(Files)) to Pred(High(Files)) do with Files[i] do begin
      CheckGroup(GroupBySignature['LVLI'], ['Leveled List Entries'], ['LLCT']);
      CheckGroup(GroupBySignature['LVLC'], ['Leveled List Entries'], ['LLCT']);
      CheckGroup(GroupBySignature['LVLN'], ['Leveled List Entries'], ['LLCT']);
      CheckGroup(GroupBySignature['LVSP'], ['Leveled List Entries'], ['LLCT']);
      CheckGroup(GroupBySignature['CONT'], ['Items'], ['COCT']);
      CheckGroup(GroupBySignature['FACT'], ['Relations'], []);
      CheckGroup(GroupBySignature['RACE'], ['HNAM - Hairs', 'ENAM - Eyes', 'Actor Effects'], ['', '', 'SPCT']);
      CheckGroup(GroupBySignature['FLST'], ['FormIDs'], [], True);
      CheckGroup(GroupBySignature['CREA'], ['Items', 'Factions'], ['COCT']);
      // FNV doesn't merge DIAL quests properly at runtime
      if wbGameMode in [gmFNV] then
        CheckGroup(GroupBySignature['DIAL'], ['Added Quests'], []);
      // exclude Head Parts for Skyrim, causes issues
      if wbGameMode >= gmTES5 then
        CheckGroup(GroupBySignature['NPC_'], ['Items', 'Factions', 'Actor Effects', 'Perks', 'KWDA - Keywords'], ['COCT', '', 'SPCT', 'PRKZ', 'KSIZ'])
      else
        CheckGroup(GroupBySignature['NPC_'], ['Items', 'Factions', 'Head Parts', 'Actor Effects'], []);
      // keywords
      if wbGameMode >= gmTES5 then begin
        CheckGroup(GroupBySignature['ALCH'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['ARMO'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['AMMO'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['BOOK'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['FLOR'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['FURN'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['INGR'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['MGEF'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['MISC'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['SCRL'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['SLGM'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['SPEL'], ['KWDA - Keywords'], ['KSIZ']);
        CheckGroup(GroupBySignature['WEAP'], ['KWDA - Keywords'], ['KSIZ']);
      end;
    end;

  finally
    wbAllowInternalEdit := EditState;
  end;

  TargetFile.CleanMasters;
end;

procedure TfrmMain.mniNavCreateModGroupClick(Sender: TObject);
var
  SelectedNodes  : TNodeArray;
  NodeData       : PNavNodeData;
  lModGroup      : TwbModGroup;
  i, j           : Integer;
  _File          : IwbFile;
  Modules        : TwbModuleInfos;
  FileName       : string;
  AddCRCs        : Boolean;
  CRC32          : TwbCRC32;
begin
  FillChar(lModGroup, SizeOf(TwbModGroup), 0);

  Modules := nil;
  if Sender = mniViewCreateModGroup then begin
    if Length(ActiveRecords) < 3 then
      Exit;
    with TfrmModuleSelect.Create(Self) do try
      AllModules := nil;
      SetLength(AllModules, Length(ActiveRecords));
      j := 0;
      for i := 1 {Ignore Master} to High(ActiveRecords) do
        if Assigned(ActiveRecords[i].Element) then begin
          _File := ActiveRecords[i].Element._File;
          if Assigned(_File) then
            if Assigned(_File.ModuleInfo) then begin
              AllModules[j] := _File.ModuleInfo;
              Inc(j);
            end;
        end;
      SetLength(AllModules, j);
      if j < 2 then
        Exit;
      AllModules.IncludeAll(mfTagged);

      SelectFlag := mfTagged;
      FilterFlag := mfHasFile;
      AllowCancel;
      MinSelect := 2;
      Caption := 'What modules should be included in the ModGroup?';

      if ShowModal <> mrOk then
        Exit;

      Modules := SelectedModules;
    finally
      Free;
    end;
  end else begin
    SelectedNodes := vstNav.GetSortedSelection(True);
    if Length(SelectedNodes) < 2 then
      Exit;
    SetLength(Modules, Length(SelectedNodes));
    j := 0;
    for i := Low(SelectedNodes) to High(SelectedNodes) do begin
      NodeData := vstNav.GetNodeData(SelectedNodes[i]);
      if Supports(NodeData.Element, IwbFile, _File) then
        if Assigned(_File.ModuleInfo) then begin
          Modules[j] := _File.ModuleInfo;
          Inc(j);
        end;
    end;
    SetLength(Modules, j);
  end;

  j := Length(Modules);
  if j < 2 then
    Exit;

  AddCRCs := MessageDlg('Do you want to include the current CRC32s?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
  SetLength(lModGroup.mgItems, j);
  for i := Low(Modules) to High(Modules) do
    with lModGroup.mgItems[i] do begin
      mgiModule := Modules[i];
      mgiFileName := mgiModule.miName;
      mgiFlags := [];
      if i > Low(Modules) then
        Include(mgiFlags, mgifIsSource);
      if i < High(Modules) then
        Include(mgiFlags, mgifIsTarget);
      if AddCRCs and mgiModule.GetCRC32(CRC32) then
        mgiCRC32s := [CRC32];
    end;

  with TfrmModGroupEdit.Create(Self) do try
    ModGroup := @lModGroup;
    AllowCancel;
    Caption := 'Create ModGroup...';
    if ShowModal <> mrOk then
      Exit;
  finally
    Free;
  end;

  with TfrmModuleSelect.Create(Self) do try
    AllModules := Modules;
    SelectFlag := mfTagged;
    FilterFlag := mfHasFile;
    AllowCancel;
    Caption := 'In which module''s .modgroups file should the new ModGroup be stored?';
    MaxSelect := 1;
    MinSelect := 1;
    repeat
      AllModules.ExcludeAll(mfTagged);

      if ShowModal <> mrOK then
        Exit;

      if Length(SelectedModules) = 1 then
        Break;

      ShowMessage('Please select exactly 1 module');
    until False;

    FileName := wbDataPath + ChangeFileExt(SelectedModules[0].miName, '.modgroups');
    with TStringList.Create do try
      if FileExists(FileName) then
        LoadFromFile(FileName);

      if (Count > 0) and (Strings[Pred(Count)] <> '') then
        Add('');

      AddStrings(lModGroup.ToStrings);

      SaveToFile(FileName);
    finally
      Free;
    end;

  finally
    Free;
  end;
  NewModGroupName := lModGroup.mgName;
  try
    mniViewModGroupsReloadClick(Self);
  finally
    NewModGroupName := '';
  end;
end;

procedure TfrmMain.mniNavCreateSEQFileClick(Sender: TObject);
var
  SelectedNodes  : TNodeArray;
  NodeData       : PNavNodeData;
  _File          : IwbFile;
  Group          : IwbGroupRecord;
  i, n, j, Count : Integer;
  MainRecord     : IwbMainRecord;
  QustFlags      : IwbElement;
  FormIDs        : TwbFormIDs;
  FileStream     : TBufferedFileStream;
  p, s           : string;
begin
  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 1 then
    Exit;

  Count := 0;
  j := 0;

  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    NodeData := vstNav.GetNodeData(SelectedNodes[i]);

    if Assigned(NodeData.Element) and (NodeData.Element.ElementType = etFile) then begin
      SetLength(FormIDs, 0);

      if not Supports(NodeData.Element, IwbFile, _File) then
        Continue;

      if _File.LoadOrder = 0 then
        Continue;

      Group := _File.GroupBySignature['QUST'];

      if Assigned(Group) then begin
        for n := 0 to Pred(Group.ElementCount) do
          if Supports(Group.Elements[n], IwbMainRecord, MainRecord) then begin
            QustFlags := MainRecord.ElementByPath['DNAM - General\Flags'];
            // include SGE (start game enabled) quests which are new or set SGE flag on master quest
            if Assigned(QustFlags) and (QustFlags.NativeValue and 1 > 0) then
              if not Assigned(MainRecord.Master) or (MainRecord.Master.ElementNativeValues['DNAM\Flags'] and 1 = 0) then begin
                SetLength(FormIDs, Succ(Length(FormIDs)));
                FormIDs[High(FormIDs)] := MainRecord.FixedFormID;
              end;
          end;
      end;

      if Length(FormIDs) = 0 then
        PostAddMessage('Skipped: ' + _File.FileName + ' doesn''t need sequence file')
      else try
        try
          p := wbDataPath + 'Seq\';
          if not DirectoryExists(p) then
            if not ForceDirectories(p) then
              raise Exception.Create('Unable to create SEQ directory in game''s Data');
          s := p + ChangeFileExt(_File.FileName, '.seq');
          FileStream := TBufferedFileStream.Create(s, fmCreate);
          FileStream.WriteBuffer(FormIDs[0], Length(FormIDs)*SizeOf(Cardinal));
          PostAddMessage('Created: ' + s);
          Inc(j);
        finally
          if Assigned(FileStream) then
            FreeAndNil(FileStream);
        end;
      except
        on e: Exception do begin
          PostAddMessage('Error: Can''t create ' + s + ', ' + E.Message);
          Exit;
        end;
      end;

      Inc(Count);
    end;
  end;
  PostAddMessage('[Create SEQ file done] Processed Plugins: ' + IntToStr(Count) + ', Sequence Files Created: ' + IntToStr(j));
end;

procedure TfrmMain.mniNavDeleteModGroupsClick(Sender: TObject);
var
  i            : Integer;
begin
  wbReloadModGroups;

  with TfrmModGroupSelect.Create(Self) do try
    AllModGroups := wbModGroupsByName(False);
    AllModGroups.ExcludeAll(mgfTagged);
    SelectFlag := mgfTagged;
    FilterFlag := mgfNone;
    MinSelect := 1;
    AllowCancel;
    Caption := 'Which ModGroups do you want to delete?';
    if ShowModal <> mrOk then
      Exit;

    if MessageDlg('Are you sure you want to delete the following ModGroups?' + CRLF + CRLF +
    SelectedModGroups.ToString + CRLF + CRLF +
    'This can not be undone!' , mtConfirmation, mbYesNo, 0, mbNo) <> mrYes then
      Exit;

    for i := Low(SelectedModGroups) to High(SelectedModGroups) do
      with SelectedModGroups[i]^ do
        with TMemIniFile.Create(mgModGroupsFile.mgfFileName) do try
          EraseSection(mgName);
          UpdateFile;
        finally
          Free;
        end;
  finally
    Free;
  end;

  mniViewModGroupsReloadClick(Self);
end;

procedure TfrmMain.mniNavEditModGroupClick(Sender: TObject);
var
  pModGroup    : PwbModGroup;
  lModGroup    : TwbModGroup;
  sl           : TStringList;
begin
  wbReloadModGroups;

  with TfrmModGroupSelect.Create(Self) do try
    AllModGroups := wbModGroupsByName(False);
    AllModGroups.ExcludeAll(mgfTagged);
    SelectFlag := mgfTagged;
    FilterFlag := mgfNone;
    MinSelect := 1;
    MaxSelect := 1;
    AllowCancel;
    Caption := 'Which ModGroup do you want to edit?';
    if ShowModal <> mrOk then
      Exit;
    pModGroup := SelectedModGroups[0];
  finally
    Free;
  end;

  lModGroup := pModGroup^;
  with TfrmModGroupEdit.Create(Self) do try
    ModGroup := @lModGroup;
    AllowCancel;
    Caption := 'Editing ModGroup "'+ModGroup.mgName+'" from "'+ModGroup.mgModGroupsFile.mgfFileName+'"...';
    if ShowModal <> mrOk then
      Exit;
  finally
    Free;
  end;

  sl := TStringList.Create;
  try
    with TMemIniFile.Create(pModGroup.mgModGroupsFile.mgfFileName) do try
      EraseSection(pModGroup.mgName);
      GetStrings(sl);
    finally
      Free;
    end;
    sl.AddStrings(lModGroup.ToStrings);
    sl.SaveToFile(pModGroup.mgModGroupsFile.mgfFileName);
  finally
    sl.Free;
  end;

  mniViewModGroupsReloadClick(Self);
end;

procedure TfrmMain.mniNavCleanupInjectedClick(Sender: TObject);
var
  SelectedNodes               : TNodeArray;
  NodeData                    : PNavNodeData;
  Elements                    : array of IwbElement;
  ReferenceFile               : IwbFile;
  Container                   : IwbContainer;
  InjectionSourceFiles        : TwbFiles;
  sl                          : TStringList;
  i, j                        : Integer;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 1 then
    Exit;

  j := 0;
  SetLength(Elements, Length(SelectedNodes));
  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    NodeData := vstNav.GetNodeData(SelectedNodes[i]);
    if Assigned(NodeData.Element) and (NodeData.Element.ElementType = etMainRecord) then begin
      InjectionSourceFiles := NodeData.Element.InjectionSourceFiles;
      if Length(InjectionSourceFiles) = 1 then begin
        if not Assigned(ReferenceFile) then
          ReferenceFile := InjectionSourceFiles[0]
        else
          if not ReferenceFile.Equals(InjectionSourceFiles[0]) then
            Continue;
        Elements[j] := NodeData.Element;
        Inc(j);
      end;
    end;
  end;
  if j < 1 then
    Exit;
  SetLength(Elements, j);

  sl := TStringList.Create;
  sl.Sorted := True;
  sl.Duplicates := dupIgnore;
  try
    var lDict := TwbFilesDictionary.Create;
    try
      for i := Low(Elements) to High(Elements) do begin
        Elements[i].ReportRequiredMasters(lDict, False);
        Container := Elements[i].Container;
        while Assigned(Container) do begin
          Container.ReportRequiredMasters(lDict, False, False);
          Container := Container.Container;
        end;
      end;
      for var lFile in lDict.Keys do
        sl.AddObject(lFile.FileName, Pointer(lFile));
    finally
      FreeAndNil(lDict);
    end;

    if AddRequiredMasters(sl, ReferenceFile) then
      for j := Low(Elements) to High(Elements) do begin
        wbCopyElementToFile(Elements[j], ReferenceFile, False, True, '', '', '', '', False);
        if Elements[j].RemoveInjected(False) then begin
          pgMain.ActivePage := tbsMessages;
          AddMessage('Injected references in '+Elements[j].Name+' could not all be removed automatically.');
        end;
      end;
  finally
    sl.Free;
  end;

  for i := Low(SelectedNodes) to High(SelectedNodes) do
    vstNav.IterateSubtree(SelectedNodes[i], ClearConflict, nil);
  InvalidateElementsTreeView(SelectedNodes);
  PostResetActiveTree;
  vstNav.Invalidate;
end;

function TfrmMain.NavCheckForChanges: Boolean;
var
  Node            : PVirtualNode;
  NodeData        : PNavNodeData;
  FocusedElements : TDynElements;
  i               : Integer;
  _File           : IwbFile;
begin
  Result := False;
  if not (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then
    Exit;
  vstNav.BeginUpdate;
  try
    FocusedElements := nil;
    if Assigned(NavFocusedElement) then begin
      FocusedElements.Add(NavFocusedElement);
      NavFocusedElement := nil;
    end;
    Node := vstNav.FocusedNode;
    while Assigned(Node) do begin
      NodeData := vstNav.GetNodeData(Node);
      if Assigned(NodeData) then
        if Assigned(NodeData.Element) then
          FocusedElements.Add(NodeData.Element);
      Node := Node.NextSibling;
    end;
    Node := vstNav.FocusedNode;
    if Assigned(Node) then
      Node := Node.PrevSibling;
    while Assigned(Node) do begin
      NodeData := vstNav.GetNodeData(Node);
      if Assigned(NodeData) then
        if Assigned(NodeData.Element) then
          FocusedElements.Add(NodeData.Element);
      Node := Node.PrevSibling;
    end;
    Node := vstNav.FocusedNode;
    if Assigned(Node) then
      Node := vstNav.NodeParent[Node];
    while Assigned(Node) do begin
      NodeData := vstNav.GetNodeData(Node);
      if Assigned(NodeData) then
        if Assigned(NodeData.Element) then
          FocusedElements.Add(NodeData.Element);
      Node := vstNav.NodeParent[Node];
    end;

    Node := vstNav.GetFirstInitialized;
    while Assigned(Node) do begin
      vstNavReInit := False;
      NodeData := vstNav.GetNodeData(Node);
      with NodeData^ do begin
        if Assigned(Element) and (Element.ElementGeneration <> ElementGen) or
           Assigned(Container) and (Container.ElementGeneration <> ContainerGen) then begin

          ConflictAll := caUnknown;
          ConflictThis := ctUnknown;
          OrgConflictAll := caUnknown;
          OrgConflictThis := ctUnknown;

          vstNavReInit := True;

          _File := nil;

          if Assigned(Element) then
            _File := Element._File
          else
            _File := Container._File;

          if _File.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
            vstNav.ReinitNode(Node, True);

          vstNav.InvalidateNode(Node);
        end;
      end;

     if vstNavReInit then
        Node := vstNav.GetNextSiblingNoInit(Node)
      else
        Node := vstNav.GetNextInitialized(Node);
    end;

    NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
    for i := Low(FocusedElements) to High(FocusedElements) do begin
      if Assigned(NodeData) then
        if FocusedElements[i].Equals(NodeData.Element) then
          Exit;
      Node := FindNodeForElement(FocusedElements[i]);
      if Assigned(Node) then begin
        vstNav.ClearSelection;
        vstNav.FullyVisible[Node] := True;
        vstNav.FocusedNode := Node;
        vstNav.Selected[Node] := True;
        Result := True;
        Exit;
      end;
    end;

  finally
    vstNav.EndUpdate;
    NavCleanupCollapsedNodeChildren;
    vstNavLastCollapsedChildrenCleanup := vstNavInitChildrenGeneration;
  end;
end;

procedure TfrmMain.NavCleanupCollapsedNodeChildren;
var
  Node     : PVirtualNode;
  //NodeData : PNavNodeData;
begin
  if not (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then
    Exit;
  vstNav.BeginUpdate;
  try
    Node := vstNav.GetFirstInitialized;
    while Assigned(Node) do begin
      if (Node.ChildCount > 0) and not vstNav.Expanded[Node] then begin
        //NodeData := vstNav.GetNodeData(Node);
        vstNav.DeleteChildren(Node);
      end;
      Node := vstNav.GetNextInitialized(Node);
    end;
  finally
    vstNav.EndUpdate;
  end;
end;

procedure TfrmMain.NavUpdate(aForce: Boolean);
var
  CheckFocusedNode: Boolean;
begin
  CheckFocusedNode := False;
  if (wbToolMode in [tmEdit, tmTranslate]) or aForce then begin
    if Assigned(vstNav) and
       (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then begin

      if aForce or (wbLoaderDone and ((vstNavLastCollapsedChildrenCleanup <> vstNavInitChildrenGeneration) or (vstNavLastCheckedForChanges <> wbGlobalModifedGeneration))) then begin
        vstNav.BeginUpdate;
        try
          if aForce or (vstNavLastCollapsedChildrenCleanup <> vstNavInitChildrenGeneration) or (vstNavLastCheckedForChanges <> wbGlobalModifedGeneration) then begin
            NavCleanupCollapsedNodeChildren;
            vstNavLastCollapsedChildrenCleanup := vstNavInitChildrenGeneration;
          end;
          if aForce or (vstNavLastCheckedForChanges <> wbGlobalModifedGeneration) then begin
            CheckFocusedNode := NavCheckForChanges;
            vstNavLastCheckedForChanges := wbGlobalModifedGeneration;
          end;
        finally
          vstNav.EndUpdate;
        end;
      end;
      if CheckFocusedNode then
        if Assigned(vstNav.FocusedNode) then
          vstNav.ScrollIntoView(vstNav.FocusedNode, False);
    end;
  end;
end;

procedure TfrmMain.CleanupRefCache;
var
  Files : TStringDynArray
  ;
  i     : Integer;
begin
  if not wbBuildRefs then
    Exit;
  if wbDontCache then
    Exit;
  if wbDontCacheSave then
    Exit;
  if not (wbToolMode in [tmView, tmEdit, tmTranslate]) then
    Exit;

  if not TDirectory.Exists(wbCachePath) then
    Exit;

  if Length(TDirectory.GetFiles(wbCachePath, IntToHex64(wbCRC32App, 8) + '_*' + wbRefCacheExt)) > 0 then
    Exit;

  Files := TDirectory.GetFiles(wbCachePath, '*' + wbRefCacheExt);

  i := Length(Files);
  if i < 1 then
    Exit;

  if MessageDlg('The Reference Cache contains ' + i.ToString +
    ' files from a different version of ' + wbAppName + wbToolName +
    '. Do you want to remove them?', mtConfirmation, mbYesNo, 0) = mrYes then
    for i := Low(Files) to High(Files) do try
      TFile.Delete(Files[i]);
    except end;
end;

procedure TfrmMain.ClearActiveContainer;
var
  aMainrecords : TDynMainRecords;
begin
  UserWasActive := True;

  if Length(aMainRecords) < 2 then begin
    if Length(aMainRecords) = 1 then
      if Supports(aMainRecords[0], IwbMainrecord) then
        SetActiveRecord(aMainRecords[0] as IwbMainRecord)
      else
        SetActiveContainer(aMainRecords[0])
    else
      SetActiveContainer(IwbDataContainer(nil));
    Exit;
  end;
  if Supports(aMainRecords[0], IwbMainrecord) then begin
    SetLength(aMainRecords, 0);
    SetActiveRecord(aMainRecords);
    Exit;
  end;

  ComparingSiblings := True;
  CompareRecords := aMainRecords;
  lvReferencedBy.Items.BeginUpdate;
  try
    vstView.BeginUpdate;
    try
      lvReferencedBy.Items.Clear;
      vstView.Clear;
      vstView.NodeDataSize := 0;
      SetLength(ActiveRecords, 0);
      ActiveMaster := nil;
      ActiveRecord := nil;
      ActiveIndex := NoColumn;

      SetLength(ActiveRecords, 0);

      with vstView.Header.Columns do begin
        BeginUpdate;
        try
          Clear;
          with Add do begin
            Text := '';
            Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
            Options := Options - [coDraggable, coShowDropMark];
            Options := Options + [coFixed, coFiller];
          end;
        finally
          EndUpdate;
        end;
      end;

      vstView.NodeDataSize := SizeOf(TViewNodeData) * Length(ActiveRecords);
      vstView.RootNodeCount := 0;
      pgMain.ActivePage := tbsView;
    finally
      vstView.EndUpdate;
    end;
    tbsReferencedBy.TabVisible := False;
  finally
    lvReferencedBy.Items.EndUpdate;
  end;
end;

procedure TfrmMain.ClearConflict(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  NodeData                    : PNavNodeData;
begin
  NodeData := vstNav.GetNodeData(Node);
  if Assigned(NodeData) then begin
    with NodeData^ do begin
      ConflictAll := caUnknown;
      ConflictThis := ctUnknown;
      if Assigned(Element) then
        Element.ResetConflict;
    end;
    Sender.InvalidateNode(Node);
  end;
end;

function TfrmMain.CollectViewContainers: TwbContainerElementRefs;
var
  Node      : PVirtualNode;
  NodeDatas : PViewNodeDatas;
  i, j      : Integer;
begin
  SetLength(Result, vstView.TotalCount * Length(ActiveRecords));

  j := 0;
  Node := vstView.GetLastChild(nil);
  while Assigned(Node) do begin
    NodeDatas := vstView.GetNodeData(Node);
    if Assigned(NodeDatas) then
      for i := Low(ActiveRecords) to High(ActiveRecords) do
        if Assigned(NodeDatas[i].Container) then begin
          Result[j] := NodeDatas[i].Container;
          Inc(j);
        end;
    Node := vstView.GetPrevious(Node);
  end;
  SetLength(Result, j);
end;

function TfrmMain.ConflictLevelForChildNodeDatas(const aNodeDatas: TDynViewNodeDatas; aSiblingCompare, aInjected: Boolean): TConflictAll;
var
  ChildCount    : Cardinal;
  i, j          : Integer;
  NodeDatas     : TDynViewNodeDatas;
  InitialStates : TVirtualNodeInitStates;
  ConflictAll   : TConflictAll;
  ConflictThis  : TConflictThis;
  Element       : IwbElement;
  ElementCount  : Integer;
begin
  case Length(aNodeDatas) of
    0: Result := caUnknown;
    1: begin
      Result := caOnlyOne;
      if not wbTranslationMode then
        aNodeDatas[0].ConflictThis := ctOnlyOne;
    end;
  else
    Result := caNoConflict;
  end;

  if wbTranslationMode then begin
    if Result < caOnlyOne then
      Exit;
  end
  else begin
    if Result < caNoConflict then
      Exit;
  end;

  ChildCount := 0;
  InitChildren(@aNodeDatas[0], Length(aNodeDatas), ChildCount);
  if ChildCount > 0 then
    for i := 0 to Pred(ChildCount) do begin
      NodeDatas := nil;
      SetLength(NodeDatas, Length(aNodeDatas));
      InitialStates := [];
      InitNodes(nil, @NodeDatas[0], @aNodeDatas[0], Length(aNodeDatas), i, InitialStates);
      if not (ivsDisabled in InitialStates) then begin

        if ivsHasChildren in InitialStates then
          ConflictAll := ConflictLevelForChildNodeDatas(NodeDatas, aSiblingCompare, aInjected)
        else
          ConflictAll := ConflictLevelForNodeDatas(@NodeDatas[0], Length(NodeDatas), aSiblingCompare, aInjected);

        if ConflictAll > Result then
          Result := ConflictAll;

        for j := Low(aNodeDatas) to High(aNodeDatas) do
          if NodeDatas[j].ConflictThis > aNodeDatas[j].ConflictThis then
            aNodeDatas[j].ConflictThis := NodeDatas[j].ConflictThis;

      end
      else begin

        ConflictThis := ctNotDefined;

        for j := Low(aNodeDatas) to High(aNodeDatas) do begin
          Element := aNodeDatas[j].Container;
          if Assigned(Element) then
            Break;
        end;

        if Assigned(Element) and (Element.ElementType in [etMainRecord, etSubRecordStruct]) then begin
          ElementCount := (Element.Def as IwbRecordDef).MemberCount;
          j := (Element as IwbContainer).AdditionalElementCount;
          if (i >= j) and (i-j < ElementCount) then
            with (Element.Def as IwbRecordDef).Members[i - j] do
              if (wbTranslationMode and (not (dfTranslatable in DefFlags))) or
                (wbTranslationMode and (ConflictPriority[nil] = cpIgnore)) then
                ConflictThis := ctIgnored;
        end;

        if not Assigned(Element) then
          if wbTranslationMode then
            ConflictThis := ctIgnored;

        for j := Low(aNodeDatas) to High(aNodeDatas) do
          if ConflictThis > aNodeDatas[j].ConflictThis then
            aNodeDatas[j].ConflictThis := ConflictThis;
      end;
    end;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
  FreeAndNil(NewMessages);
  FreeAndNil(ScriptHotkeys);
  FreeAndNil(Settings);
  FreeAndNil(FileCRCs);
end;

procedure TfrmMain.DoGenerateLOD;
var
  i, j        : Integer;
  _File       : IwbFile;
  Group       : IwbContainerElementRef;
  MainRecord  : IwbMainRecord;
  Worldspaces : TDynMainRecords;
begin
  // xLODGen: selective lodgenning, no need to regenerate lod for all worldspaces like in Oblivion
  if wbIsSkyrim or wbIsFallout3 or wbIsFallout4 or wbIsStarfield then begin
    try
      mniNavGenerateLODClick(nil);
    finally
      frmMain.PostAddMessage('LOD Generator: finished (you can close this application now)');
      GeneratorDone := True;
    end;
    Exit;
  end;

  // TES4LODGen, rebuild for all worldspaces
  if wbGameMode = gmTES4 then try
    frmMain.PostAddMessage('[' + wbFormatElapsedTime(Now - wbStartTime) + '] LOD Generator: starting');

    Worldspaces := nil;
    for i := Low(Files) to High(Files) do begin
      _File := Files[i];
      if Supports(_File.GroupBySignature['WRLD'], IwbContainerElementRef, Group) then begin
        for j := 0 to Pred(Group.ElementCount) do
          if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then begin
            if Mainrecord.Signature = 'WRLD' then begin
              SetLength(Worldspaces, Succ(Length(Worldspaces)));
              Worldspaces[High(Worldspaces)] := MainRecord;
            end;
          end;
      end;
    end;

    if Length(WorldSpaces) > 1 then begin
      wbMergeSortPtr(@WorldSpaces[0], Length(WorldSpaces), CompareElementsFormIDAndLoadOrder);

      j := 0;
      for i := Succ(Low(WorldSpaces)) to High(WorldSpaces) do begin
        if WorldSpaces[j].LoadOrderFormID <> WorldSpaces[i].LoadOrderFormID then
          Inc(j);
        if j <> i then
          WorldSpaces[j] := WorldSpaces[i];
      end;
      SetLength(WorldSpaces, Succ(j));
    end;

    if Length(Worldspaces) = 0 then
      Exit;

    try
      try
        for i := Low(WorldSpaces) to High(WorldSpaces) do begin
          wbGenerateLODTES4(WorldSpaces[i], Settings);
          if wbForceTerminate then
            Abort;
        end;
      except
        on E: Exception do begin
          frmMain.PostAddMessage('[' + wbFormatElapsedTime(Now - wbStartTime) + '] LOD Generator: <Error: '+E.Message+'>');
          raise;
        end;
      end;
      frmMain.PostAddMessage('[' + wbFormatElapsedTime(Now - wbStartTime) + '] LOD Generator: finished (you can close this application now)');
    finally
      Self.Caption := Application.Title;
    end;
  finally
    GeneratorDone := True;
  end;
end;

procedure TfrmMain.DoRunScript;

  procedure SelectRootNodes(AVirtualTree: TBaseVirtualTree);
  var
    Node: PVirtualNode;
  begin
    AVirtualTree.BeginUpdate;
    try
      Node := AVirtualTree.GetFirst;
      while Assigned(Node) do begin
        AVirtualTree.Selected[Node] := True;
        Node := AVirtualTree.GetNextSibling(Node);
      end;
    finally
      AVirtualTree.EndUpdate;
    end;
  end;

begin
  if xeScriptToRun = '' then
    xeScriptToRun := wbProgramPath + wbAppName + 'Script.pas'
  else if not TPath.IsPathRooted(ExtractFilePath(xeScriptToRun)) then
    xeScriptToRun := wbScriptsPath + xeScriptToRun;

  if not FileExists(xeScriptToRun) then
    with TOpenDialog.Create(Self) do try
      Title := 'Select a script to execute';
      Filter := 'Script files (*.pas)|*.pas';
      InitialDir := wbProgramPath;
      if Execute then
        xeScriptToRun := FileName;
    finally
      Free;
    end;

  if FileExists(xeScriptToRun) then begin
    wbScriptsPath := ExtractFilePath(xeScriptToRun);
    with TStringList.Create do try
      LoadFromFile(xeScriptToRun);
      SelectRootNodes(vstNav);
      ApplyScript(ChangeFileExt(ExtractFileName(xeScriptToRun),''), Text);
    finally
      Free;
    end;
  end else
    PostAddMessage('Could not open script: ' + xeScriptToRun);

  PostAddMessage('You can close this application now.');
end;

function dfResourceOpenData(const aContainerName, aFileName: string): TBytes;
begin
  Result := wbContainerHandler.OpenResourceData(aContainerName, aFileName);
end;

procedure TfrmMain.DoInit;
var
  i, j, k, l, m : Integer;
  e             : Boolean;
  s             : string;
  sl, sl2, sl3  : TStringList;
  ConflictAll   : TConflictAll;
  ConflictThis  : TConflictThis;

  ModGroupFile  : string;
  MessagePrefix : string;
  IsOptional    : Boolean;
  IsRequired    : Boolean;
  MessageGiven  : Boolean;
  ValidCRCs     : TDynCardinalArray;
  FileCRC       : Cardinal;
  FoundAll      : Boolean;
  saveExt       : string;
  coSaveExt     : string;
  R             : TSearchRec;
  Rect          : TRect;
  frmFileSelect : TfrmFileSelect;
  Modules       : TwbModuleInfos;
  Module        : PwbModuleInfo;
  AgeDateTime   : TDateTime;

  Stream        : TStream;
begin
  {$IFDEF USE_PARALLEL_BUILD_REFS}
  TThread.CreateAnonymousThread(procedure begin
    var ThreadCount := TThread.ProcessorCount;
    ThreadCount := (ThreadCount * 7) div 8;
    if ThreadCount < 3 then
      ThreadCount := 3;
    if ThreadCount > 16 then
      ThreadCount := 16;
    with TThreadPool.Default do begin
      SetMaxWorkerThreads(ThreadCount);
      SetMinWorkerThreads(ThreadCount);
    end;

    TTask.Run(procedure begin
      Sleep(1);
    end).Wait;
  end).Start;
  {$ENDIF}

  AutoDone := False;
  ErrorsCount := 0;
  ITMcount := 0;
  DRcount := 0;

  SetDoubleBuffered(Self);
  SaveInterval := DefaultInterval;
  TfrmMain(splElements).OnMouseDown := splElementsMouseDown;

  wbGetFormIDCallback := GetFormIDCallback;

  tbsView.TabVisible := False;
  tbsWEAPSpreadsheet.TabVisible := False;
  tbsARMOSpreadsheet.TabVisible := False;
  tbsAMMOSpreadsheet.TabVisible := False;

  pgMain.ActivePage := tbsMessages;
  Application.OnMessage := ApplicationMessage;
  lblPath.DoubleBuffered := True;

  wbDisplayLoadOrderFormID := True;
  wbSortSubRecords := True;
  wbDisplayShorterNames := True;
  wbHideUnused := True;
  wbFlagsAsArray := True;
  wbRequireLoadOrder := not wbUseFalsePlugins;
  ShowUnsavedHint := True;
  ParentedGroupRecordType := [1, 6, 7];
  if wbVWDAsQuestChildren then
    Include(ParentedGroupRecordType, 10);

  vstNav.NodeDataSize := SizeOf(TNavNodeData);
  vstView.DragImageKind := diDragColumnOnly;
  vstView.LineMode := lmSeparateTopNodes;
  vstView.TreeOptions.PaintOptions := vstView.TreeOptions.PaintOptions + [toAdvHotTrack];
  vstView.OnGetEditText := vstViewGetEditText;
  vstView.OnCheckHotTrack := vstViewCheckHotTrack;
  vstView.OnHeaderDropped := vstViewHeaderDropped;
  vstView.OnDrawText := vstViewDrawText;
  vstView.OnMeasureTextWidth := vstViewMeasureTextWidth;
  vstView.OnShortenString := vstViewShortenString;

  vstSpreadSheetWeapon.OnGetEditText := vstSpreadSheetGetEditText;
  vstSpreadSheetWeapon.OnCheckHotTrack := vstSpreadSheetCheckHotTrack;
  vstSpreadSheetWeapon.TreeOptions.PaintOptions := vstSpreadSheetWeapon.TreeOptions.PaintOptions + [toZebra, toAdvHotTrack];

  vstSpreadSheetArmor.OnGetEditText := vstSpreadSheetGetEditText;
  vstSpreadSheetArmor.OnCheckHotTrack := vstSpreadSheetCheckHotTrack;
  vstSpreadSheetArmor.TreeOptions.PaintOptions := vstSpreadSheetArmor.TreeOptions.PaintOptions + [toZebra, toAdvHotTrack];

  vstSpreadSheetAmmo.OnGetEditText := vstSpreadSheetGetEditText;
  vstSpreadSheetAmmo.OnCheckHotTrack := vstSpreadSheetCheckHotTrack;
  vstSpreadSheetAmmo.TreeOptions.PaintOptions := vstSpreadSheetAmmo.TreeOptions.PaintOptions + [toZebra, toAdvHotTrack];

  AddMessage(wbApplicationTitle + ' ('+IntToHex64(wbCRC32App, 8)+') starting session ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
  AddMessage('');
  AddMessage('The Source Code Form of this program is subject to the terms of the Mozilla Public License, v. 2.0');
  AddMessage('If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.');
  AddMessage('');
  AddMessage('The Source Code Form is available at https://github.com/TES5Edit/TES5Edit');
  AddMessage('');

  if wbShouldLoadMOHookFile then begin
    AddMessage('Using Mod Organizer Profile: ' + wbMOProfile);
    if not xeLoadMOHookFile then begin
      AddMessage('Error: Failed to load Mod Organizer Profile');
      Exit;
    end;
  end;

  AddMessage('Using '+wbGameName2+' Data Path: ' + wbDataPath);

  if not (wbDontSave or xeDontBackup) then
    AddMessage('Using Backup Path: ' + wbBackupPath);

  AddMessage('Using Scripts Path: ' + wbScriptsPath);

  if not wbDontCache then
    AddMessage('Using Cache Path: ' + wbCachePath);

  AddMessage('Using ini: ' + wbTheGameIniFileName);
  if not FileExists(wbTheGameIniFileName) then begin
    AddMessage('Fatal: Could not find ini');
    Exit;
  end;

  if FileExists(wbCustomIniFileName) then begin
    AddMessage('Using custom ini: ' + wbCustomIniFileName);
  end;

  if wbSavePath <> '' then begin
    AddMessage('Using save path: ' + wbSavePath);
    if not DirectoryExists(wbSavePath) then begin
      if wbToolSource in [tsSaves] then begin
        AddMessage('Fatal: Could not find save path');
        Exit;
      end else
        AddMessage('Warning: Could not find save path');
    end;
  end else
    if wbToolSource in [tsSaves] then begin
      AddMessage('Fatal: No save path specified');
      Exit;
    end;

  if wbCreationClubContentFileName <> '' then begin
    wbCreationClubContentFileName := ExtractFilePath(ExcludeTrailingPathDelimiter(wbDataPath)) + wbCreationClubContentFileName;
    if FileExists(wbCreationClubContentFileName) then begin
      with TStringList.Create do try
        LoadFromFile(wbCreationClubContentFileName);
        SetLength(wbCreationClubContent, Count);
        for i := 0 to Pred(Count) do
          wbCreationClubContent[i] := Strings[i];
      finally
        Free;
      end;
      AddMessage('Using Creation Club Content list: ' + wbCreationClubContentFileName);
    end;
  end;

  AddMessage('Using plugin list: ' + wbPluginsFileName);
  if not FileExists(wbPluginsFileName) then begin
    // plugins file could be missing in Fallout 4 and SSE since DLCs are loaded automatically
{    if (wbToolSource in [tsPlugins]) and not (wbGameMode in [gmFO4, gmFO4VR, gmTES5VR, gmSSE]) then begin
      AddMessage('Fatal: Could not find plugin list');
      Exit;
    end else}
      AddMessage('Warning: Could not find plugin list');
  end;

  AddMessage('Using settings file: ' + xeSettingsFileName);

  if not Assigned(Settings) and (xeSettingsFileName <> '') then
    if ForceDirectories(ExtractFilePath(xeSettingsFileName)) then
      Settings := TMemIniFile.Create(xeSettingsFileName);

  if not Assigned(Settings) then begin
    ShowMessage('Could not open or create the settings file.');
    AddMessage('Could not open or create the settings file.');
    Exit;
  end;

  AddMessage('Using language: ' + wbLanguage);
  AddMessage('Using general string encoding: ' + wbEncoding.EncodingName);
  AddMessage('Using translatable string encoding: ' + wbEncodingTrans.EncodingName);
  if wbGameMode >= gmTES5 then
    AddMessage('Using VMAD string encoding: ' + wbEncodingVMAD.EncodingName);

  i := Settings.ReadInteger(Name, 'pnlNavWidth', pnlNav.Width);
  if i < 50 then i := 50;
  if i >= ClientWidth then i := ClientWidth - 50;
  pnlNav.Width := i;

  for i := 0 to Pred(vstNav.Header.Columns.Count) do
    vstNav.Header.Columns[i].Width := Settings.ReadInteger(Name, 'vstNavColumnWidth' + IntToStr(i), vstNav.Header.Columns[i].Width);

  if wbToolSource in [tsSaves] then
    AddMessage('Loading saves list from : ' + wbSavePath)
  else if wbToolSource in [tsPlugins] then
    AddMessage('Loading active plugin list: ' + wbPluginsFileName)
  else begin
    AddMessage('Fatal: No source specified');
    Exit;
  end;

  if wbToolMode in [tmEdit, tmView, tmTranslate] then begin

    {$IFDEF WIN64}
    if not wbIsStarfield then
      if Settings.ReadBool('Init', 'First64Start', True) then begin
        if MessageDlg('You have started the 64bit version.' + CRLF + CRLF +
          'The only reason to use the 64bit version is if you are getting an out of memory ' +
          'error while using the 32bit version.' + CRLF + CRLF +
          'The 32bit version is generally faster and uses less memory than the 64bit version.' + CRLF + CRLF +
          'Are you sure you want to continue?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes then begin
          tmrShutdown.Enabled := True;
          Exit;
          end;
        Settings.WriteBool('Init', 'First64Start', False);
        Settings.UpdateFile;
      end;
    {$ELSE}
    if wbIsStarfield then
      if Settings.ReadBool('Init', 'First32StarfieldStart', True) then begin
        if MessageDlg('You have started the 32bit version for Starfield.' + CRLF + CRLF +
          'Given the size of Starfield.esm, it is very likely that you will run out ' +
          'of memory quickly while using the 32bit version.' + CRLF + CRLF +
          'While the 32bit version is generally faster and uses less memory than the 64bit version, in case of Starfield, the use of the 64bit version is preferred.' + CRLF + CRLF +
          'Are you sure you want to continue?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes then begin
          tmrShutdown.Enabled := True;
          Exit;
          end;
        Settings.WriteBool('Init', 'First32StarfieldStart', False);
        Settings.UpdateFile;
      end;
    {$ENDIF WIN64}

    i := Settings.ReadInteger('WhatsNew', 'Version', 0);
    with TfrmRichEdit.Create(Self) do begin
      Caption := 'What''s New?';
      try
        Stream := fcWhatsNew.CreateReadStream;
        try
          reMain.Lines.LoadFromStream(Stream);
          if wbThemesSupported then begin
            reMain.SelectAll;
            reMain.SelAttributes.Color := clWindowText;
            reMain.SelStart := 0;
            reMain.SelLength := 0;
          end;
        finally
          Stream.Free;
        end;
        if (i < wbWhatsNewVersion) and not xeAutoLoad then begin
          ShowModal;
          if cbDontShowAgain.Checked then begin
            Settings.WriteInteger('WhatsNew', 'Version', wbWhatsNewVersion);
            Settings.UpdateFile;
          end;
        end;
        Parent := tbsWhatsNew;
        Align := alClient;
        Visible := True;
        BorderStyle := bsNone;
        btnOk.Visible := False;
        cbDontShowAgain.Visible := False;
        pnlMain.Margins.Top := edSearch.Top + edSearch.Height + reMain.Margins.Left;
        pnlMain.Align := alClient;
        tbsWhatsNew.TabVisible := True;
      except end;
    end;

    wbPatron := Settings.ReadBool('Options', 'Patron', wbPatron);
    if not wbPatron or not xeAutoLoad then
      ShowDeveloperMessage;
  end;

  try
    sl := TStringList.Create;
    try
      frmFileSelect := TfrmFileSelect.Create(nil);
      with frmFileSelect do try
        case wbToolSource of
          tsSaves: begin
            case wbGameMode of
              gmFO3:  begin saveExt := '.fos'; coSaveExt := '.fose'; end;
              gmFO4, gmFO4VR:  begin saveExt := '.fos'; coSaveExt := '';      end;
              gmFO76:  begin saveExt := '.fos'; coSaveExt := '';      end;
              gmFNV:  begin saveExt := '.fos'; coSaveExt := '.nvse'; end;
              gmTES3: begin saveExt := '.ess'; coSaveExt := '';      end;
              gmTES4: begin saveExt := '.ess'; coSaveExt := '.obse'; end;
              gmTES5, gmEnderal, gmTES5VR, gmSSE, gmEnderalSE: begin saveExt := '.ess'; coSaveExt := '.skse'; end;
            end;

            if FindFirst(ExpandFileName(wbSavePath+'\*'+saveExt), faAnyfile, R)=0 then try
              repeat
                if R.Attr and faDirectory <> faDirectory then begin
                  CheckListBox1.Items.Add(R.Name);
                  s := ChangeFileExt(R.Name, coSaveExt);
                  if (coSaveExt<>'') and FileExists(ExpandFileName(wbSavePath+'\'+s)) then
                    CheckListBox1.Items.Add(s);
                end;
              until 0 <> FindNext(R);
            finally
              FindClose(R);
            end;
            if (coSaveExt<>'') then
              if FindFirst(ExpandFileName(wbSavePath+'\*'+coSaveExt), faAnyfile, R)=0 then try
                repeat
                  if R.Attr and faDirectory <> faDirectory then
                    if CheckListBox1.Items.IndexOf(R.Name) = -1 then
                      CheckListBox1.Items.Add(R.Name);
                until 0 <> FindNext(R);
              finally
                FindClose(R);
              end;
          end;
          tsPlugins: begin
            Modules := wbModulesByLoadOrder;
            CheckListBox1.Items.BeginUpdate;
            try
              CheckListBox1.Items.Clear;
              CheckListBox1.Items.AddStrings(Modules.ToStrings(True));
            finally
              CheckListBox1.Items.EndUpdate;
            end;

            if (wbToolMode in [tmMasterUpdate, tmMasterRestore]) and (Length(Modules)>1) and wbIsFallout3 then begin
              AgeDateTime := Modules[0].miDateTime;
              for i := 1 to High(Modules) do begin
                AgeDateTime := AgeDateTime + (1/24/60);
                TFile.SetLastWriteTime(wbDataPath + Modules[i].miOriginalName, AgeDateTime);
              end;
            end;
          end;
        end;

        if ((wbToolMode in wbPluginModes) or xeQuickClean or xeQuickEdit) and (wbGameMode in [gmTES4, gmFO3, gmFO4, gmFO4VR, gmFO76, gmFNV, gmTES5, gmTES5VR, gmSSE, gmEnderal, gmEnderalSE, gmSF1]) then begin
          Modules.DeactivateAll;

          if (xePluginToUse <> '') or not xeQuickClean then
            with wbModuleByName(xePluginToUse)^ do
              if IsValid then begin
                Activate;
                Include(miFlags, mfTaggedForPluginMode);
              end else begin
                ShowMessage('Selected plugin "' + xePluginToUse + '" does not exist');  // which we checked previously anyway :(
                frmMain.Close;
                Exit;
              end;

          // More plugins requested ?
          while xeFindNextValidCmdLineModule(xeParamIndex, s, wbDataPath) do begin
            with wbModuleByName(s)^ do
              if IsValid then begin
                Activate;
                Include(miFlags, mfTaggedForPluginMode);
              end else begin
                ShowMessage('Selected plugin "' + xePluginToUse + '" does not exist');  // which we checked previously anyway :(
                frmMain.Close;
                Exit;
              end;
          end;
        end;

        sl.Clear;
        if wbToolSource in [tsPlugins] then begin
          if (wbToolMode in wbPluginModes) or (xeAutoLoad and (GetAsyncKeyState(VK_CONTROL) >= 0)) then try
            if xeQuickClean then
              if Length(wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)) <> 1 then begin
                ShowMessage('Exactly one module must be selected for Quick Clean mode.');
                frmMain.Close;
                Exit;
              end;

            sl.AddStrings(wbModulesByLoadOrder.SimulateLoad.ToStrings(False));
          except end;

          if sl.Count < 1 then
            with TfrmModuleSelect.Create(Self) do try
              if xeQuickClean then begin
                MinSelect := 1;
                MaxSelect := 1;
                HideFlag := mfIsGameMaster;
                AllModules := wbModulesByLoadOrder(False).FilteredByFlag(mfValid);
                Caption := 'Please check or double click the module that you want to ' + wbSubMode;
              end else
                PresetCategory := 'ActiveModules';

              if ShowModal = mrOk then begin
                FilteredModules.IncludeAll(mfTaggedForPluginMode);
                sl.AddStrings(SelectedModules.ToStrings(False));
              end;
              if sl.Count < 1 then begin
                if Length(AllModules) < 1 then
                  ShowMessage('There are no modules in the data folder.');
                frmMain.Close;
                Exit;
              end;
            finally
              Free;
            end;
        end else begin
          if not (wbToolMode in wbAutoModes) then
            if ShowModal = mrOk then
              for i := 0 to Pred(CheckListBox1.Count) do
                if CheckListBox1.Checked[i] then
                  sl.Add(CheckListBox1.Items[i]);
        end;
      finally
        Free;
      end;

      if sl.Count < 1 then begin
        frmMain.Close;
        Exit;
      end;

      if xeQuickClean then begin
        if Length(wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)) <> 1 then begin
          MessageDlg('Exactly one plugin must be selected in QuickClean mode', mtError, [mbAbort], 0);
          frmMain.Close;
          Exit;
        end;
      end else if (wbToolSource in [tsSaves]) then
        if sl.Count <> 1 then begin
          MessageDlg('Exactly one plugin must be selected with this source', mtError, [mbAbort], 0);
          frmMain.Close;
          Exit;
        end;

      if wbToolSource = tsSaves then begin
        s := sl[0];
        case wbGameMode of
          gmFNV:  if SameText(ExtractFileExt(s), coSaveExt) then xeSwitchToCoSave;
          gmFO3:  if SameText(ExtractFileExt(s), coSaveExt) then xeSwitchToCoSave
            else begin
              MessageDlg('Save are not supported yet "'+s+'". Please check the selection.', mtError, [mbAbort], 0);
              frmMain.Close;
              Exit;
            end;
          gmFO4:  if SameText(ExtractFileExt(s), coSaveExt) then xeSwitchToCoSave;
          gmTES4: if SameText(ExtractFileExt(s), coSaveExt) then xeSwitchToCoSave
            else begin
              MessageDlg('Save are not supported yet "'+s+'". Please check the selection.', mtError, [mbAbort], 0);
              frmMain.Close;
              Exit;
            end;
          gmTES5,
          gmTES5VR,
          gmEnderal,
          gmEnderalSE,
          gmSSE:  if SameText(ExtractFileExt(s), coSaveExt) then xeSwitchToCoSave;
        else
          MessageDlg('CoSave are not supported yet "'+s+'". Please check the the selection.', mtError, [mbAbort], 0);
          frmMain.Close;
          Exit;
        end;
        sl.Clear;
        //assumption: for a savegame, we should load exactly the listed masters in the listed order, followed by the savegame
        wbMastersForFile(wbSavePath + s, sl);
        sl.Add(s);
      end else {wbToolSource = tsPlugins} begin
        Modules.ActivateMasters;         //Activate all required masters in their current load order position first
        Modules := Modules.SimulateLoad; //Simulate a load, which might re-order masters
        sl.Clear;
        sl.AddStrings(Modules.ToStrings(False));
      end;

      {make sure messages for the memo have been processed}
      DoProcessMessages;
      tmrMessagesTimer(nil);

      if not (wbToolMode in wbAutoModes) then
      case wbToolSource of
        tsSaves: { to be done };
        tsPlugins: with TfrmFileSelect.Create(nil) do try
          {
          if (not wbEditAllowed) or wbTranslationMode then begin
            Caption := 'Skip these records:';

            sl2 := TStringList.Create;
            try
              sl2.Sorted := True;
              sl2.Duplicates := dupIgnore;
              sl2.CommaText := Settings.ReadString('RecordsToSkip', 'Selection', 'LAND,ROAD,PGRD,REGN,NAVI,NAVM,IMAD');

              for i := Low(wbRecordDefs) to High(wbRecordDefs) do
                with wbRecordDefs[i].rdeDef do begin
                  j := CheckListBox1.Items.Add(DefaultSignature + ' - ' + GetName);
                  if sl2.IndexOf(DefaultSignature) >= 0 then
                    CheckListBox1.Checked[j] := True;
                end;
              CheckListBox1.Sorted := True;

              ShowModal;

              sl2.Clear;
              for i := 0 to Pred(CheckListBox1.Count) do
                if CheckListBox1.Checked[i] then begin
                  RecordToSkip.Add(Copy(CheckListBox1.Items[i], 1, 4));
                  sl2.Add(Copy(CheckListBox1.Items[i], 1, 4));
                end;
              Settings.WriteString('RecordsToSkip', 'Selection', sl2.CommaText);
              Settings.UpdateFile;
            finally
              FreeAndNil(sl2);
            end;
          end;
          }
        finally
          Free;
        end;
      end;

      mniMasterAndLeafs.Visible := True;
      mniMasterAndLeafsEnabled.Checked := OnlyShowMasterAndLeafs;
      mniMasterAndLeafsDisabled.Checked := not OnlyShowMasterAndLeafs;

      // hold shift to skip building references
      if (GetKeyState(VK_SHIFT) < 0) then begin
        wbBuildRefs := False;
        AddMessage('The SHIFT key is pressed, skip building references for all plugins!');
      end;

      if xeQuickClean or xeQuickShowConflicts then
        wbBuildRefs := False;

      CleanupRefCache;

      wbShowTip := Settings.ReadBool('Options', 'ShowTip', wbShowTip);
      if wbShowTip and (wbToolMode in [tmEdit]) then
        ShowTip;

      wbStartTime := Now;

      wbPatron := Settings.ReadBool('Options', 'Patron', wbPatron);
      wbNoGitHubCheck := Settings.ReadBool('Options', 'NoGitHubCheck', wbNoGitHubCheck);
      wbNoNexusModsCheck := Settings.ReadBool('Options', 'NoNexusModsCheck', wbNoNexusModsCheck);

      TLoaderThread.Create(sl);
    finally
      FreeAndNil(sl);
    end;
  except
    on E: Exception do begin
      AddMessage('Fatal: Error loading plugin list: <' + E.ClassName + ': ' + E.Message + '>');
      Exit;
    end;
  end;

  TotalUsageTime := Settings.ReadFloat('Usage', 'TotalTime', 0);
  RateNoticeGiven := Settings.ReadInteger('Usage', 'RateNoticeGiven', 0);
  ShowUnsavedHint := Settings.ReadBool('Options', 'ShowUnsavedHint', ShowUnsavedHint);
  if not wbTranslationMode then begin
    wbHideUnused := Settings.ReadBool('Options', 'HideUnused', wbHideUnused);
    wbHideIgnored := Settings.ReadBool('Options', 'HideIgnored', wbHideIgnored);
    wbHideNeverShow := Settings.ReadBool('Options', 'HideNeverShow', wbHideNeverShow);
  end;
  wbActorTemplateHide := Settings.ReadBool('Options', 'ActorTemplateHide', wbActorTemplateHide);
  ColumnWidth := Settings.ReadInteger('Options', 'ColumnWidth', ColumnWidth);
  RowHeight := Settings.ReadInteger('Options', 'RowHeight', RowHeight);
  SetDefaultNodeHeight(Trunc(RowHeight * (GetCurrentPPIScreen / PixelsPerInch)));
  wbSortFLST := Settings.ReadBool('Options', 'SortFLST2', wbSortFLST);
  //wbSortINFO := Settings.ReadBool('Options', 'SortINFO', wbSortINFO); read in wbInit
  //wbFillPNAM := Settings.ReadBool('Options', 'FillPNAM', wbFillPNAM); read in wbInit
  wbFocusAddedElement := Settings.ReadBool('Options', 'FocusAddedElement', wbFocusAddedElement);
  wbRequireCtrlForDblClick := Settings.ReadBool('Options', 'RequireCtrlForDblClick', wbRequireCtrlForDblClick);
  wbShowGroupRecordCount := Settings.ReadBool('Options', 'ShowGroupRecordCount', wbShowGroupRecordCount);
  wbShowFileFlags := Settings.ReadBool('Options', 'ShowFileFlags', wbShowFileFlags);
  wbAutoCompareSelectedLimit := Settings.ReadInteger('Options', 'AutoCompareSelectedLimit', wbAutoCompareSelectedLimit);
  tmrPendingSetActive.Interval := Settings.ReadInteger('Options', 'NavChangeDelay', tmrPendingSetActive.Interval);
  wbClampFormID := Settings.ReadBool('Options', 'ClampFormID', wbClampFormID);
  wbResetModifiedOnSave := Settings.ReadBool('Options', 'ResetModifiedOnSave', wbResetModifiedOnSave);
  wbAlwaysSaveOnam := Settings.ReadBool('Options', 'AlwaysSaveOnam', wbAlwaysSaveOnam) or wbAlwaysSaveOnamForce;
  wbAlignArrayElements := Settings.ReadBool('Options', 'AlignArrayElements', wbAlignArrayElements);
  wbManualCleaningHide := Settings.ReadBool('Options', 'ManualCleaningHide', wbManualCleaningHide);
  wbManualCleaningAllow := Settings.ReadBool('Options', 'ManualCleaningAllow', wbManualCleaningAllow);
  wbConvertIntFormID := Settings.ReadBool('Options', 'ConvertIntFormID', wbConvertIntFormID);
  wbCollapseRecordHeader := Settings.ReadBool('Options', 'CollapseRecordHeader', wbCollapseRecordHeader);
  wbCollapseObjectBounds := Settings.ReadBool('Options', 'CollapseObjectBounds', wbCollapseObjectBounds);
  wbCollapseModels := Settings.ReadBool('Options', 'CollapseModels', wbCollapseModels);
  wbCollapseFactions := Settings.ReadBool('Options', 'CollapseFactions', wbCollapseFactions);
  wbCollapseFactionRelations := Settings.ReadBool('Options', 'CollapseFactionRelations', wbCollapseFactionRelations);
  wbCollapseFragments := Settings.ReadBool('Options', 'CollapseFragments', wbCollapseFragments);
  wbCollapseItems := Settings.ReadBool('Options', 'CollapseItems', wbCollapseItems);
  wbCollapseLeveledItems := Settings.ReadBool('Options', 'CollapseLeveledItems', wbCollapseLeveledItems);
  wbCollapseEquipSlots := Settings.ReadBool('Options', 'CollapseEquipSlots', wbCollapseEquipSlots);
  wbCollapseObjectProperties := Settings.ReadBool('Options', 'CollapseObjectProperties', wbCollapseObjectProperties);
  wbCollapseScriptProperties := Settings.ReadBool('Options', 'CollapseScriptProperties', wbCollapseScriptProperties);
  wbCollapseConditions := Settings.ReadBool('Options', 'CollapseConditions', wbCollapseConditions);
  wbCollapseBenignArray := Settings.ReadBool('Options', 'CollapseBenignArray', wbCollapseBenignArray);
  wbCollapseRGBA := Settings.ReadBool('Options', 'CollapseRGBA', wbCollapseRGBA);
  wbCollapseVec3 := Settings.ReadBool('Options', 'CollapseVec3', wbCollapseVec3);
  wbCollapseHeadParts := Settings.ReadBool('Options', 'CollapseHeadParts', wbCollapseHeadParts);
  wbCollapseBodyParts := Settings.ReadBool('Options', 'CollapseBodyParts', wbCollapseBodyParts);
  wbShrinkButtons := Settings.ReadBool('Options', 'ShrinkButtons', wbShrinkButtons);
  //wbIKnowWhatImDoing := Settings.ReadBool('Options', 'IKnowWhatImDoing', wbIKnowWhatImDoing);
  wbUDRSetXESP := Settings.ReadBool('Options', 'UDRSetXESP', wbUDRSetXESP);
  wbUDRSetScale := Settings.ReadBool('Options', 'UDRSetScale', wbUDRSetScale);
  wbUDRSetScaleValue := Settings.ReadFloat('Options', 'UDRSetScaleValue', wbUDRSetScaleValue);
  wbUDRSetZ := Settings.ReadBool('Options', 'UDRSetZ', wbUDRSetZ);
  wbUDRSetZValue := Settings.ReadFloat('Options', 'UDRSetZValue', wbUDRSetZValue);
  wbUDRSetMSTT := Settings.ReadBool('Options', 'UDRSetMSTT', wbUDRSetMSTT);
  wbUDRSetMSTTValue := Settings.ReadInteger('Options', 'UDRSetMSTTValue', wbUDRSetMSTTValue);
  for ConflictThis := Low(TConflictThis) to High(TConflictThis) do
    wbColorConflictThis[ConflictThis] := Settings.ReadInteger('ColorConflictThis', GetEnumName(TypeInfo(TConflictThis), Integer(ConflictThis)), Integer(wbColorConflictThis[ConflictThis]));
  for ConflictAll := Low(TConflictAll) to High(TConflictAll) do
    wbColorConflictAll[ConflictAll] := Settings.ReadInteger('ColorConflictAll', GetEnumName(TypeInfo(TConflictAll), Integer(ConflictAll)), Integer(wbColorConflictAll[ConflictAll]));

  HideNoConflict := Settings.ReadBool('View', 'HodeNoConflict', False);
  mniViewHideNoConflict.Checked := HideNoConflict;

  StickViewNodeLabel := Settings.ReadString('View', 'StickViewNodeLabel', '');

  case Settings.ReadInteger('View', 'ColumnWidth', 0) of
    1: mniViewColumnWidthFitAll.Checked := True;
    2: mniViewColumnWidthFitText.Checked := True;
    3: mniViewColumnWidthFitSmart.Checked := True;
  else
    mniViewColumnWidthStandard.Checked := True;
  end;

  case Settings.ReadInteger('Nav', 'FilesSort', 0) of
    1: mniNavHeaderFilesLoadOrder.Checked := True;
    2: mniNavHeaderFilesFileName.Checked := True;
  else
    mniNavHeaderFilesDefault.Checked := True;
  end;

  case Settings.ReadInteger('Nav', 'INFOSort', 0) of
    1: mniNavHeaderINFObyFormID.Checked := True;
  else
    mniNavHeaderINFObyPreviousINFO.Checked := True;
  end;

  CreateActionsForScripts;
  wbDataFormat.dfResourceGetDataCallback := @dfResourceOpenData;

  if wbToolMode in [tmEdit, tmView, tmTranslate] then begin
    i := Settings.ReadInteger('Patreon', 'SnoozeCounter', 0);
    if i > 0 then begin
      Settings.WriteInteger('Patreon', 'SnoozeCounter', Pred(i));
      Settings.UpdateFile;
    end else
      if Settings.ReadInteger('Patreon', 'SnoozeDate', 0) <> Trunc(Now) then
        if wbPatron then begin
          jbhPatreon.ActivateHint(bnPatreon, 'Thanks!', '', 3000);
          Settings.WriteInteger('Patreon', 'SnoozeCounter', 15);
          Settings.WriteInteger('Patreon', 'SnoozeDate', Trunc(Now));
          Settings.UpdateFile;
        end else
          jbhPatreon.ActivateHint(bnPatreon, 'Please consider supporting further xEdit development.', 'Patreon', 15000);

    if not wbNoNexusModsCheck then
      CheckNexusModsReleaseThread := TwbCheckNexusModsReleaseThread.Create;
    if not wbNoGitHubCheck then
      CheckGitHubReleaseThread := TwbCheckGitHubReleaseThread.Create;
  end;
end;

procedure TfrmMain.edEditorIDSearchChange(Sender: TObject);
begin
  edEditorIDSearch.Color := clWindow;
end;

procedure TfrmMain.edEditorIDSearchEnter(Sender: TObject);
begin
  edEditorIDSearch.SelectAll;
end;

procedure TfrmMain.edEditorIDSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  EditorID                    : string;
  Node                        : PVirtualNode;
  NodeData                    : PNavNodeData;
begin
  if (Key = VK_RETURN) and (Shift = []) then begin
    Key := 0;
    EditorID := Trim(edEditorIDSearch.Text);
    if EditorID = '' then begin
      edEditorIDSearch.Color := wbLighter(clRed, 0.85);
      edEditorIDSearch.SelectAll;
      Exit;
    end;

    Node := vstNav.FocusedNode;
    if Assigned(Node) then
      if not StartsWith(vstNav.Text[Node, 1, False], EditorID) then
        Node := nil;

    if Assigned(Node) then
      Node := vstNav.GetNext(Node)
    else
      Node := vstNav.GetFirst;

    while Assigned(Node) do begin
      // don't search in hidden elements
      NodeData := vstNav.GetNodeData(Node);
      if Assigned(NodeData) and Assigned(NodeData.Element) and not NodeData.Element.IsHidden then
        if StartsWith(vstNav.Text[Node, 1, False], EditorID) then begin
          if not vstNav.FullyVisible[Node] then begin
            vstNav.FullyVisible[Node] := True;
            Node := vstNav.NodeParent[Node];
          end
          else begin
            edEditorIDSearch.Color := wbLighter(clLime, 0.85);
            vstNav.ClearSelection;
            vstNav.FocusedNode := Node;
            vstNav.Selected[vstNav.FocusedNode] := True;
            edEditorIDSearch.SelectAll;
            Exit;
          end;
        end;
      Node := vstNav.GetNext(Node)
    end;

    if edEditorIDSearch.Color = wbLighter(clLime, 0.85) then
      edEditorIDSearch.Color := wbLighter(clYellow, 0.85)
    else
      edEditorIDSearch.Color := wbLighter(clRed, 0.85);
    edEditorIDSearch.SelectAll;
    Exit;
  end;
end;

procedure TfrmMain.edFileNameFilterChange(Sender: TObject);
var
  SearchText : string;
  Node       : PVirtualNode;
begin
  SearchText := edFileNameFilter.Text;
  SearchText := SearchText.ToLowerInvariant;
  with vstNav do begin
    BeginUpdate;
    try
      Node := GetFirst;
      while Assigned(Node) do begin
        IsVisible[Node] := not ((SearchText <> '') and
          not Text[Node, 0, False].ToLowerInvariant.Contains(SearchText));
        Node := GetNextSibling(Node);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmMain.edFileNameFilterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  FocusedNode: PVirtualNode;
  Node : PVirtualNode;
begin
  case Key of
    VK_RETURN, VK_UP: begin
      vstNav.SetFocus;
      FocusedNode := vstNav.FocusedNode;
      if Assigned(FocusedNode) then
        for Node in vstNav.VisibleNodes(nil) do begin
          if Node = FocusedNode then
            Exit;
        end;
      vstNav.FocusedNode := vstNav.GetFirstVisible;
    end;
  end;
end;

procedure TfrmMain.edFilterNoBeepOnEnterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#13, #27] then
    Key := #0;
end;

procedure TfrmMain.edFormIDSearchChange(Sender: TObject);
begin
  edFormIDSearch.Color := clWindow;
end;

procedure TfrmMain.edFormIDSearchEnter(Sender: TObject);
begin
  edFormIDSearch.SelectAll;
end;

procedure TfrmMain.edFormIDSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  s                           : string;
  FormID                      : TwbFormID;
  FileID                      : TwbFileID;
  _File                       : IwbFile;
  MainRecord                  : IwbMainRecord;
  Node                        : PVirtualNode;
  i, j, tmp                   : Integer;

begin
  if (Key = VK_RETURN) and (Shift = []) then begin
    Key := 0;

    s := Trim(edFormIDSearch.Text);

    if wbConvertIntFormID then
      if not StartsText('0', s) and not StartsText('0x', s) then
        if TryStrToInt(s, tmp) then
        begin
          s := IntToHex(tmp, 8);
          edFormIDSearch.Text := s;
        end else
          s := '00000000';

    if StartsText('0x', s) then
      s := ReplaceText(s, '0x', '');

    FormID := TwbFormID.FromStrDef(s, 0);
    FileID := FormID.FileID;
    if not FormID.IsNull then begin
      _File := nil;
      j := Low(Files);
      while (j <= High(Files)) and not Assigned(_File) do begin
        if Files[j].LoadOrderFileID = FileID then
          _File := Files[j];
        Inc(j);
      end;
      while Assigned(_File) do begin
        FormID.FileID := TwbFileID.CreateFull(_File.MasterCount[True]);
        MainRecord := _File.RecordByFormID[FormID, True, True];
        if Assigned(MainRecord) then begin
          Node := FindNodeForElement(MainRecord);
          if not Assigned(Node) then
            for i := 0 to Pred(MainRecord.OverrideCount) do begin
              // don't search in hidden elements
              if MainRecord.Overrides[i].IsHidden then
                Continue;
              Node := FindNodeForElement(MainRecord.Overrides[i]);
              if Assigned(Node) then
                Break;
            end;
          if Assigned(Node) then begin
            edFormIDSearch.Color := wbLighter(clLime, 0.85);
            JumpTo(MainRecord, False);
  //          vstNav.ClearSelection;
  //          vstNav.FocusedNode := FindNodeForElement(MainRecord);
  //          vstNav.Selected[vstNav.FocusedNode] := True;
  //          SetActiveRecord(MainRecord);
          end
          else begin
            edFormIDSearch.Color := wbLighter(clYellow, 0.85);
            JumpTo(MainRecord, False);
  //          SetActiveRecord(MainRecord);
          end;
          edFormIDSearch.SelectAll;
          Exit;
        end;
        _File := nil;
        while (j <= High(Files)) and not Assigned(_File) do begin
          if Files[j].LoadOrderFileID = FileID then
            _File := Files[j];
          Inc(j);
        end;
      end;
    end;
    edFormIDSearch.Color := wbLighter(clRed, 0.85);
    edFormIDSearch.SelectAll;
  end;
end;

function TfrmMain.EditableSelection(ContainsChilds: PBoolean): TNodeArray;
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  i, j                        : Integer;
begin
  SetLength(Result, 0);
  if Assigned(ContainsChilds) then
    ContainsChilds^ := False;

  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  Result := vstNav.GetSortedSelection(True);
  j := Low(Result);
  for i := Low(Result) to High(Result) do begin
    NodeData := vstNav.GetNodeData(Result[i]);
    if not Assigned(NodeData) then
      Continue;
    Element := NodeData.Element;
    if not Assigned(Element) then
      Continue;
    if not Element.IsEditable then
      Continue;

    if Assigned(ContainsChilds) then
      ContainsChilds^ := ContainsChilds^ or
        (Assigned(NodeData.Container) and (NodeData.Container.ElementCount > 0));

    if i <> j then
      Result[j] := Result[i];
    Inc(j);
  end;
  SetLength(Result, j);
end;

function TfrmMain.EditWarn: Boolean;
var
  EditWarnCount: Integer;
begin
  if not wbLoaderDone then
    Exit(False);

  Result :=
    EditWarnOk or
    (DebugHook <> 0) or
    wbIKnowWhatImDoing;

  if not Result then
    with TfrmEditWarning.Create(Self) do try
      EditWarnCount := Settings.ReadInteger('Usage', 'EditWarnCount', 0);

      TimerCount := TimerCount - (EditWarnCount div 10);

      Result := ShowModal = mrOk;
      if Result then begin
        Inc(EditWarnCount);
        Settings.WriteInteger('Usage', 'EditWarnCount', EditWarnCount);
        Settings.UpdateFile;
      end;

    finally
      Free;
    end;

  if Result then
    EditWarnOk := True;
end;

procedure TfrmMain.edViewFilterChange(Sender: TObject);
begin
  with vstView do begin
    BeginUpdate;
    try
      ApplyViewFilter;
      UpdateColumnWidths;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmMain.edViewFilterNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  procedure FocusTreeView;
  var
    FocusedNode: PVirtualNode;
    Node : PVirtualNode;
  begin
    vstView.SetFocus;
    FocusedNode := vstViewFocusedNode;
    if Assigned(FocusedNode) then
      for Node in vstView.VisibleNodes(nil) do begin
        if Node = FocusedNode then
          Exit;
      end;
    vstViewFocusedNode := vstView.GetFirstVisible;
  end;

begin
  case Key of
    VK_RETURN:
      if (ssCtrl in Shift) or (Sender = edViewFilterValue) then
        FocusTreeView
      else if Sender = edViewFilterName then
        cobViewFilter.SetFocus
      else if Sender = cobViewFilter then
        edViewFilterValue.SetFocus;
    VK_DOWN:
      FocusTreeView;
  end;
end;

procedure TfrmMain.ExpandButtons;
var
  i: Integer;
begin
  with pnlBtn do
    for i := Pred(ControlCount) downto 0 do
      if Controls[i] is TSpeedButton then
        with TSpeedButton(Controls[i]) do
          if Tag = 0 then begin
            Caption := Hint;
            Hint := HelpKeyword;
            Width := Constraints.MaxWidth;
            ShowHint := not Hint.IsEmpty;
            Flat := True;
          end;
end;

procedure TfrmMain.ExpandView;
var
  Node      : PVirtualNode;
  NodeDatas : PViewNodeDatas;
  i         : Integer;
begin
  RebuildingViewTree := True;
  vstView.BeginUpdate;
  try
    vstView.FullExpand;
    Node := vstView.GetLast(nil);
    while Assigned(Node) do begin
      NodeDatas := vstView.GetNodeData(Node);
      if Assigned(NodeDatas) then
        for i := Low(ActiveRecords) to High(ActiveRecords) do
          with NodeDatas[i] do
            if Assigned(Container) and (Container.Collapsed = tbTrue) then begin
              vstView.Expanded[Node] := False;
              Break;
            end;
      Node := vstView.GetPrevious(Node);
    end;
    ApplyViewFilter;
    UpdateColumnWidths;
  finally
    vstView.EndUpdate;
    if vstView.FocusedColumn > NoColumn then
      vstView.ScrollIntoView(vstView.FocusedColumn, False);
    RebuildingViewTree := False;
  end;
end;

function NormalizeRotation(const aRot: TwbVector): TwbVector;

  function NormalizeAxis(const aValue: Single): Single;
  begin
    Result := aValue;
    while Result < (-Pi) do
      Result := Result + (2*Pi);
    while Result > Pi do
      Result := Result - (2*Pi);
  end;

begin
  Result.x := NormalizeAxis(aRot.x);
  Result.y := NormalizeAxis(aRot.y);
  Result.z := NormalizeAxis(aRot.z);
end;

{function MainRecordToRefInfo(const aMainRecord: IwbMainRecord; out aRefInfo: TRefInfo): Boolean;
var
  MainRecord : IwbMainRecord;
  NameRec    : IwbContainerElementRef;
  DataRec    : IwbContainerElementRef;
begin
  Result := False;
  if Supports(aMainRecord.RecordBySignature['NAME'], IwbContainerElementRef, NameRec) and
     Supports(NameRec.LinksTo, IwbMainRecord, MainRecord) and
     Supports(aMainRecord.RecordBySignature['DATA'], IwbContainerElementRef, DataRec) and
     (DataRec.ElementCount = 2) then begin
    try
      with aRefInfo do begin
        FormID := MainRecord.LoadOrderFormID;

        with Pos, (DataRec.Elements[0] as IwbContainerElementRef) do begin
          if ElementCount >= 1 then
            X := StrToFloatDef(Elements[0].Value, 0);
          if ElementCount >= 2 then
            Y := StrToFloatDef(Elements[1].Value, 0);
          if ElementCount >= 3 then
            Z := StrToFloatDef(Elements[2].Value, 0);
        end;
        with Rot, (DataRec.Elements[1] as IwbContainerElementRef) do begin
          if ElementCount >= 1 then
            X := StrToFloatDef(Elements[0].Value, 0);
          if ElementCount >= 2 then
            Y := StrToFloatDef(Elements[1].Value, 0);
          if ElementCount >= 3 then
            Z := StrToFloatDef(Elements[2].Value, 0);
        end;
        Rot := NormalizeRotation(Rot);
        if Supports(aMainRecord.RecordBySignature['XSCL'], IwbContainerElementRef, DataRec) then
          Scale := StrToFloatDef(DataRec.Value, 1)
        else
          Scale := 1;
      end;
      Result := True;
    except
      on E: Exception do
//        AddMessage('Error while processing ' + aMainRecord.Name+': '+E.Message);
    end;
  end;
end;}

{function RotDistance(a, b: TCoords): Single;
begin
  a := NormalizeRotation(a);
  b := NormalizeRotation(b);
  if a.x < 0 then
    a.x := a.x + (2*Pi);
  if a.y < 0 then
    a.y := a.y + (2*Pi);
  if a.z < 0 then
    a.z := a.z + (2*Pi);
  if b.x < 0 then
    b.x := b.x + (2*Pi);
  if b.y < 0 then
    b.y := b.y + (2*Pi);
  if b.z < 0 then
    b.z := b.z + (2*Pi);
  Result := wbDistance(a, b);
end;}

function StrRight(const s: String; Len: Integer): string;
begin
  Result := s;
  while Length(Result)<Len do
    Result := ' ' + Result;
end;

function SnapRot(s: Single): Single;
begin
  if (s > -2) and (s < 2) then
    Result := 0
  else if (s > 88) and (s < 92) then
    Result := 90
  else if (s > 178) or (s < -178) then
    Result := 180
  else if (s > -92) and (s < -88) then
    Result := -90
  else
    Result := s;
end;

var
  _ColorsCache : record
    ccString  : String;
    ccColors : TArray<TColor>;
  end;

function TfrmMain.FindColors(const s: string; out aColors: TArray<TColor>): Boolean;
type
  TColorBytes = array[0..2] of Integer;
begin
  with _ColorsCache do
  if ccString = s then
    aColors := ccColors
  else begin
    aColors := nil;
    var i := Pos('RGB', s);
    while i > 0 do begin
      Inc(i, 3);
      var j := Pos('(', s, i);
      if j > 0 then begin
        if (j = i) or ((j = Succ(i)) and (s[i] = 'A')) then begin
          i := Pos(')', s, j);
          if i > 0 then begin
            var Elements := Copy(s, Succ(j), Pred(i - j)).Split([',']).ForEach(Trim);
            if Length(Elements) in [3, 4] then begin
              var Valid := False;
              var ColorBytes: TColorBytes;
              for var k := 0 to 2 do begin
                Valid := TryStrToInt(Elements[k], ColorBytes[k]) and InRange(ColorBytes[k], 0, 255);
                if not Valid then
                  Break;
              end;
              if Valid then begin
                SetLength(aColors, Succ(Length(aColors)));
                aColors[High(aColors)] := RGB(ColorBytes[0], ColorBytes[1], ColorBytes[2]);
              end;
            end;
          end;
        end;
        i := Pos('RGB', s, i);
      end else
        i := 0;
    end;
    ccString := s;
    ccColors := aColors;
  end;
  Result := Length(aColors) > 0;
end;

function TfrmMain.FindNodeForElement(const aElement: IwbElement): PVirtualNode;
var
  Node                        : PVirtualNode;
  NodeData                    : PNavNodeData;

  REFR                        : IwbMainRecord;
  Position                    : TwbVector;
  CellGRUP                    : IwbGroupRecord;
  CELL                        : IwbMainRecord;
  WorldGRUP                   : IwbGroupRecord;
  WRLD                        : IwbMainRecord;
  GridCell                    : TwbGridCell;
begin
  if not Assigned(aElement) then
    Exit(nil);

  Node := FindNodeOrAncestorForElement(aElement);
  NodeData := vstNav.GetNodeData(Node);
  if Assigned(NodeData) then
    if aElement.Equals(NodeData.Element) or aElement.Equals(NodeData.Container) then
      Exit(Node);

  if FilterApplied and AssignPersWrldChild then
    //may be a persistent reference that has been assigned to a
    //temporary world CELL by the filter
    if Supports(aElement, IwbMainRecord, REFR) then
      if REFR.GetPosition(Position) then
        if Supports(REFR.Container, IwbGroupRecord, CellGRUP) then
          if Supports(CellGRUP.ChildrenOf, IwbMainRecord, CELL) then
            if CELL.Signature = 'CELL' then
              if CELL.IsPersistent then
                if Supports(CELL.Container, IwbGroupRecord, WorldGRUP) then
                  if Supports(WorldGRUP.ChildrenOf, IwbMainRecord, WRLD) then
                    if WRLD.Signature = 'WRLD' then begin
                      GridCell := wbPositionToGridCell(Position);
                      CELL := WRLD.ChildByGridCell[GridCell];
                      if Assigned(CELL) then begin
                        Node := FindNodeForElement(CELL);
                        if Assigned(Node) then
                          Exit(FindNodeForElementIn(Node, aElement));
                      end;
                    end;

  Result := nil;
end;

function TfrmMain.FindNodeForElementIn(aParent: PVirtualNode; const aElement: IwbElement): PVirtualNode;
var
  NodeData                    : PNavNodeData;
begin
  if not Assigned(aElement) then
    Exit(nil);
  Result := vstNav.GetFirstChild(aParent);
  while Assigned(Result) do begin
    NodeData := vstNav.GetNodeData(Result);
    if Assigned(NodeData) then
      if aElement.Equals(NodeData.Element) or aElement.Equals(NodeData.Container) then
        Exit;
    Result := vstNav.GetNextSibling(Result);
  end;
end;

function TfrmMain.FindNodeOrAncestorForElement(const aElement: IwbElement): PVirtualNode;
var
  Container                   : IwbContainer;
  Node                        : PVirtualNode;
begin
  if not Assigned(aElement) then
    Exit(nil);

  Container := aElement.Container;
  if Assigned(Container) then
    Node := FindNodeOrAncestorForElement(Container)
  else
    Node := vstNav.RootNode;

  if Assigned(Node) then begin
    Result := FindNodeForElementIn(Node, aElement);
    if not Assigned(Result) then
      Result := Node;
  end else
    Result := nil;
end;

procedure TfrmMain.SaveLog(const s: string; aAllowReplace: Boolean);
var
  txt      : AnsiString;
  fs       : TBufferedFileStream;
begin
  fs := nil;
  try
    try
      if FileExists(s) then begin
        fs := TBufferedFileStream.Create(s, fmOpenReadWrite);
        fs.Seek(0, soFromEnd);
      end else
        fs := TBufferedFileStream.Create(s, fmCreate);
      if aAllowReplace then
        if fs.Size > 3 * 1024 * 1024 then // truncate log file at 3MB
          fs.Size := 0;
      txt := AnsiString(mmoMessages.Lines.Text) + #13#10;
      fs.WriteBuffer(txt[1], Length(txt));
    // suppress log saving errors, it is not critical for xEdit
    except end;
  finally
    if Assigned(fs) then
      FreeAndNil(fs);
  end;
end;

procedure TfrmMain.SaveLogs(aAllowReplace: Boolean);
begin
  SaveLog(wbProgramPath + wbAppName + wbToolName + '_log.txt', aAllowReplace);
  if xeLogFile <> '' then
    SaveLog(xeLogFile, aAllowReplace);
end;

procedure TfrmMain.SaveModGroupsSelection(const aModGroups: TwbModGroupPtrs);
var
  i  : Integer;
begin
  with TStringList.Create do try
    for i := Low(aModGroups) to High(aModGroups) do
      with aModGroups[i]^ do
        if mgfTagged in mgFlags then
          Add(mgName);

    Settings.WriteString('ModGroups', 'Selection', CommaText);
    Settings.UpdateFile;
  finally
    Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);

var
  i: Integer;

begin
  Action := caFree;
  if LoaderStarted and not wbLoaderDone then begin
    wbForceTerminate := True;
    Caption := 'Waiting for Background Loader to terminate...';
    pnlClient.Enabled := False;
    try
      while not wbLoaderDone do begin
        DoProcessMessages;
        Sleep(100);
      end;
    finally
      pnlClient.Enabled := True;
      UpdatePnlCancelVisible;
    end;
  end;

  if Assigned(PluggyLinkThread) then
    PluggyLinkThread.Terminate;
  FreeAndNil(PluggyLinkThread);

  if Assigned(CheckGitHubReleaseThread) then begin
    if CheckGitHubReleaseThread.Finished then
      FreeAndNil(CheckGitHubReleaseThread)
    else
      TerminateThread(CheckGitHubReleaseThread.Handle, 0);
  end;

  if Assigned(CheckNexusModsReleaseThread) then begin
    if CheckNexusModsReleaseThread.Finished then
      FreeAndNil(CheckNexusModsReleaseThread)
    else
      TerminateThread(CheckNexusModsReleaseThread.Handle, 0);
  end;

  if SaveChanged >= srAbort then begin
    Action := caNone;
    Exit;
  end;

  if Assigned(Settings) then begin
    if Assigned(pnlNav) then
      Settings.WriteInteger(Name, 'pnlNavWidth', pnlNav.Width);
    if Assigned(vstNav) then
      for i := 0 to Pred(vstNav.Header.Columns.Count) do
        Settings.WriteInteger(Name, 'vstNavColumnWidth' + IntToStr(i), vstNav.Header.Columns[i].Width);

      Settings.WriteInteger(Name, 'WindowState', Integer(WindowState));
      Settings.WriteInteger(Name, 'Left', Left);
      Settings.WriteInteger(Name, 'Top', Top);
      Settings.WriteInteger(Name, 'Width', Width);
      Settings.WriteInteger(Name, 'Height', Height);
    Settings.UpdateFile;
  end;

  SaveLogs(True);

  if DirectoryExists(wbTempPath) and xeRemoveTempPath then
    DeleteDirectory(wbTempPath); // remove temp folder unless it existed

  tmrCheckUnsaved.Enabled := False;

  LockWindowUpdate(Handle);
  try
    BackHistory := nil;
    ForwardHistory := nil;
    tmrPendingSetActive.Enabled := False;
    DoSetActiveRecord(nil);
    vstNav.Free;
    vstView.Free;
    vstSpreadSheetWeapon.Free;
    vstSpreadSheetArmor.Free;
    vstSpreadSheetAmmo.Free;
    pnlNav.Free;
    pnlTop.Visible := False;
    for i := 0 to Pred(pgMain.PageCount) do
      pgMain.Pages[i].TabVisible := tbsMessages = pgMain.Pages[i];
  finally
    LockWindowUpdate(0);
  end;

  Files := nil;
  _wbProgressCallback := nil;
  ExitCode := CheckResult;
end;

procedure xeApplyFontAndScale(aForm: TForm);
var
  OldSize : Integer;
  Font    : TFont;
begin
  OldSize := aForm.Font.Size;
  if Screen.IconFont.Size <> OldSize then begin
    Font := TFont.Create;
    try
      Font.Assign(Screen.IconFont);
      Font.Size := OldSize;
      aForm.Font := Font;
    finally
      Font.Free;
    end;
    aForm.ScaleBy(Abs(Screen.IconFont.Size), Abs(OldSize));
  end else
    aForm.Font := Screen.IconFont;

  if aForm.BorderStyle <> bsSizeable then begin
    if aForm.Height > Screen.WorkAreaHeight then
      aForm.ScaleBy(Screen.WorkAreaHeight, aForm.Height);
    if aForm.Width > Screen.WorkAreaWidth then
      aForm.ScaleBy(Screen.WorkAreaWidth, aForm.Width);
  end;
end;

type
  TWinControlHacker=class(TWinControl);

procedure xeSetDoubleBuffered(aControl: TWinControl);
var
  i: Integer;
begin
  TWinControlHacker(aControl).DoubleBuffered := True;
  for i := 0 to Pred(aControl.ControlCount) do
    if aControl.Controls[i] is TWinControl then
      xeSetDoubleBuffered(TWinControl(aControl.Controls[i]));
end;

procedure xeLoadAndApplyFontAndScale(aIni: TMemIniFile; aSection, aName: string; aWinControl: TWinControl);
var
  OldSize : Integer;
  NewSize : Integer;
  lFont   : TFont;
  cFont   : TFont;
begin
  cFont := TWinControlHacker(aWinControl).Font;
  OldSize := cFont.Size;
  lFont := TFont.Create;
  try
    lFont.Assign(cFont);
    LoadFont(aIni, aSection, aName, lFont);
    if
      (lFont.Name <> cFont.Name) or
      (lFont.CharSet <> cFont.CharSet) or
      (lFont.Color <> cFont.Color) or
      (lFont.Size <> cFont.Size) or
      (lFont.Style <> cFont.Style) then begin
      NewSize := lFont.Size;
      lFont.Size := OldSize;
      cFont.Assign(lFont);
      TWinControlHacker(aWinControl).ScaleBy(NewSize, OldSize);
    end;
  finally
    lFont.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i, j, k, l: Integer;
  Rect: TRect;
begin
  FocusedColumnOverride := -1;

  if wbThemesSupported then try
    if not Assigned(Settings) and (xeSettingsFileName <> '')  then
      if ForceDirectories(ExtractFilePath(xeSettingsFileName)) then
        Settings := TMemIniFile.Create(xeSettingsFileName);
    if Assigned(Settings) then begin
      TStyleManager.TrySetStyle(Settings.ReadString('UI', 'Theme', TStyleManager.ActiveStyle.Name), False);
      Graphics.PaletteChanged;
    end;
  except end;

  xeApplyFontAndScale(Self);
  bnMainMenu.StyleElements := bnMainMenu.StyleElements - [seFont];
  bnMainMenu.Font.Style := bnMainMenu.Font.Style + [fsBold];
  bnMainMenu.Font.Size := Trunc(bnMainMenu.Font.Size * 1.5);
  if Screen.Fonts.IndexOf('Segoe MDL2 Assets') >= 0 then begin
    bnMainMenu.Font.Name := 'Segoe MDL2 Assets';
    bnMainMenu.Caption := Chr($E700);

    bnBack.StyleElements := bnBack.StyleElements - [seFont];
    bnBack.Glyph := nil;
    bnBack.Font.Style := bnBack.Font.Style + [fsBold];
    //bnBack.Font.Size := Trunc(bnBack.Font.Size * 1.5);
    bnBack.Font.Name := 'Segoe MDL2 Assets';
    bnBack.Caption := Chr($E00E);

    bnForward.StyleElements := bnForward.StyleElements - [seFont];
    bnForward.Glyph := nil;
    bnForward.Font.Style := bnForward.Font.Style + [fsBold];
//    bnForward.Font.Size := Trunc(bnForward.Font.Size * 1.5);
    bnForward.Font.Name := 'Segoe MDL2 Assets';
    bnForward.Caption := Chr($E00F);
  end;

  xeSetDoubleBuffered(Self);

  //try to set the style and window position as early as possible to reduce flicker
  try
    if not Assigned(Settings) and (xeSettingsFileName <> '')  then
      if ForceDirectories(ExtractFilePath(xeSettingsFileName)) then
        Settings := TMemIniFile.Create(xeSettingsFileName);
    if Assigned(Settings) then begin
      xeLoadAndApplyFontAndScale(Settings, 'UI', 'FontRecords', vstNav);
      xeLoadAndApplyFontAndScale(Settings, 'UI', 'FontRecords', vstView);
      xeLoadAndApplyFontAndScale(Settings, 'UI', 'FontRecords', pnlTop);
      xeLoadAndApplyFontAndScale(Settings, 'UI', 'FontMessages', mmoMessages);

      // skip reading main form position if Shift is pressed
      if GetKeyState(VK_SHIFT) >= 0 then begin
        i := Settings.ReadInteger(Name, 'Left', 0);
        j := Settings.ReadInteger(Name, 'Top', 0);
        k := Settings.ReadInteger(Name, 'Width', 0);
        l := Settings.ReadInteger(Name, 'Height', 0);
        if (k > 100) and (l > 100) then begin
          Rect := Screen.DesktopRect;
          if (i+16 >= Rect.Left) and
             (j+16 >= Rect.Top) and
             ((i + k)-16 <= Rect.Right) and
             ((j + l)-16 <= Rect.Bottom)
          then begin
            Left := i;
            Top := j;
            Width := k;
            Height := l;
            Position := poDesigned;
          end;
        end;
        WindowState := TWindowState(Settings.ReadInteger(Name, 'WindowState', Integer(WindowState)));
        if WindowState = wsMinimized then
          WindowState := wsNormal;
        if WindowState = wsMaximized then
          Position := poDesigned;
      end;
    end;
  except end;

  if wbThemesSupported then
    with TVclStylesSystemMenu.Create(Self) do begin
      ShowNativeStyle := True;
      MenuCaption := 'Theme';
    end;

  wbDarkMode := wbIsDarkMode;
  //_BlockInternalEdit := True;
  _wbProgressCallback := GeneralProgress;
  LastUpdate := GetTickCount64;
  UpdateTreeLineColor;

  Caption := Application.Title;
  ColumnWidth := 200;
  RowHeight := vstNav.DefaultNodeHeight;

  if Screen.Fonts.IndexOf('Consolas') >= 0 then
    MonospaceFontName := 'Consolas'
  else if Screen.Fonts.IndexOf('Courier New') >= 0 then
    MonospaceFontName := 'Courier New'
  else //give up
    MonospaceFontName := '';

  if MonospaceFontName <> '' then begin
    Memo1.Font.Name := MonospaceFontName;
    mmoMessages.Font.Name := MonospaceFontName;
  end;
  Memo1.WordWrap := True;

  try
    if not Assigned(Settings) and (xeSettingsFileName <> '')  then
      if ForceDirectories(ExtractFilePath(xeSettingsFileName)) then
        Settings := TMemIniFile.Create(xeSettingsFileName);
    if Assigned(Settings) then begin
      ColumnWidth := Settings.ReadInteger('Options', 'ColumnWidth', ColumnWidth);
      RowHeight := Settings.ReadInteger('Options', 'RowHeight', RowHeight);
      SetDefaultNodeHeight(Trunc(RowHeight * (GetCurrentPPIScreen / PixelsPerInch)));
      wbShrinkButtons := Settings.ReadBool('Options', 'ShrinkButtons', wbShrinkButtons);
    end;
  except end;

  if wbShrinkButtons then
    ShrinkButtons;

  if wbToolMode in wbAutoModes then begin
    mmoMessages.Parent := Self;
    pnlNav.Visible := False;
    pnlTop.Visible := False;
    tbsView.TabVisible := False;
    tbsInfo.TabVisible := False;
    stbMain.Visible := False;
    pgMain.Visible := False;
    splElements.Visible := False;
  end;
  CheckResult := 0;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  OffsetXY                    : TPoint;
  Column                      : TColumnIndex;
  FocusFile                   : IwbFile;
  _File                       : IwbFile;
  NavNode                     : PVirtualNode;
  ViewNode                    : PVirtualNode;
  r                           : TRect;
  i                           : Integer;
begin
  if wbLoaderDone then begin
    if (Key = Ord('S')) and (Shift = [ssCtrl]) then begin
      jbhSave.CancelHint;
      SaveChanged(False, True);
    end;
    if (Key = Ord('O')) and (Shift = [ssCtrl]) then
      mniMainOptions.Click;
  end;
  if Assigned(vstSpreadSheetWeapon) then vstSpreadSheetWeapon.UpdateHotTrack;
  if Assigned(vstSpreadsheetArmor) then vstSpreadsheetArmor.UpdateHotTrack;
  if Assigned(vstSpreadSheetAmmo) then vstSpreadSheetAmmo.UpdateHotTrack;

  if Assigned(vstView) then begin
    vstView.UpdateHotTrack;
    if Key = VK_SHIFT then
      vstView.Header.Options := vstView.Header.Options + [hoAutoSpring];
  end;

  if Assigned(vstNav) then begin
    vstNav.UpdateHotTrack;
    if Key = VK_SHIFT then
      vstNav.Header.Options := vstNav.Header.Options + [hoAutoSpring];
  end;

  if (Shift = [ssAlt]) and (Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT])then begin
    if not Assigned(vstView) then
      Exit;
    if not Assigned(vstNav) then
      Exit;
    if pgMain.ActivePage <> tbsView then
      Exit;
    if Assigned(vstView.EditLink) then
      Exit;

    vstView.BeginUpdate;
    try
      FoundViewLabelNode := nil;
      OffsetXY := vstView.OffsetXY;
      Column := vstView.FocusedColumn;
      FocusFile := nil;
      if (Pred(Column) >= Low(ActiveRecords)) and (Pred(Column) <= High(ActiveRecords)) then
        with ActiveRecords[Pred(Column)] do
          if Assigned(Element) then
            FocusFile := Element._File;

      ViewNode := vstViewFocusedNode;
      if Assigned(ViewNode) then
        r := vstView.GetDisplayRect(ViewNode, Column, False);
      case Key of
        VK_UP: begin
          NavNode := vstNav.FocusedNode;
          if not Assigned(NavNode) then
            NavNode := vstNav.GetLast
          else
            NavNode := vstNav.GetPreviousVisible(NavNode);
          if Assigned(NavNode) then begin
            vstNav.ClearSelection;
            vstNav.FocusedNode := NavNode;
            vstNav.Selected[vstNav.FocusedNode] := True;
          end;
        end;
        VK_DOWN: begin
          NavNode := vstNav.FocusedNode;
          if not Assigned(NavNode) then
            NavNode := vstNav.GetFirst
          else
            NavNode := vstNav.GetNextVisible(NavNode);
          if Assigned(NavNode) then begin
            vstNav.ClearSelection;
            vstNav.FocusedNode := NavNode;
            vstNav.Selected[vstNav.FocusedNode] := True;
          end;
        end;
        VK_LEFT: begin
          NavNode := vstNav.FocusedNode;
          if Assigned(NavNode) then
            NavNode := vstNav.NodeParent[NavNode];
          if Assigned(NavNode) then begin
            vstNav.ClearSelection;
            vstNav.FocusedNode := NavNode;
            vstNav.Selected[vstNav.FocusedNode] := True;
            vstNav.Expanded[vstNav.FocusedNode] := False;
          end;
        end;
        VK_RIGHT: begin
          NavNode := vstNav.FocusedNode;
          if Assigned(NavNode) then begin
            vstNav.Expanded[NavNode] := True;
            NavNode := vstNav.GetFirstVisibleChild(NavNode);
          end;
          if Assigned(NavNode) then begin
            vstNav.ClearSelection;
            vstNav.FocusedNode := NavNode;
            vstNav.Selected[vstNav.FocusedNode] := True;
          end;
        end;
      else
        Exit;
      end;
      if Assigned(NavNode) then begin
        if tmrPendingSetActive.Enabled then
          tmrPendingSetActiveTimer(tmrPendingSetActive);
        vstView.UpdateScrollBars(False);
        if (StickViewNodeLabel = '*') or not Assigned(FoundViewLabelNode) then begin
          if StickViewNodeLabel = '' then
            vstView.OffsetXY := OffsetXY;
          if Assigned(ViewNode) then begin
            ViewNode := vstView.GetNodeAt(r.Left + 2, r.Top + 2);
            if Assigned(ViewNode) then
              vstViewFocusedNode := ViewNode;
          end;
        end else
          vstViewFocusedNode := FoundViewLabelNode;

        Column := Min(Max(1, Column), Pred(vstView.Header.Columns.Count));

        { Try to find exact file }
        if Assigned(FocusFile) then
          for i := Low(ActiveRecords) to High(ActiveRecords) do
            with ActiveRecords[i] do
              if Assigned(Element) and FocusFile.Equals(Element._File) then begin
                Column := Succ(i);
                FocusFile := nil;
                Break;
              end;

        { Try to find the lowest one with same or higher load order }
        if Assigned(FocusFile) then
          if FocusFile.LoadOrder >= 0 then
            for i := Low(ActiveRecords) to High(ActiveRecords) do
              with ActiveRecords[i] do
                if Assigned(Element) then begin
                  _File := Element._File;
                  if Assigned(_File) and (_File.LoadOrder >= FocusFile.LoadOrder) then begin
                    Column := Succ(i);
                    FocusFile := nil;
                    Break;
                  end;
                end;

        { Go to the right most column }
        if Assigned(FocusFile) then
          for i := High(ActiveRecords) downto Low(ActiveRecords) do
            with ActiveRecords[i] do
              if Assigned(Element) then begin
                Column := Succ(i);
                FocusFile := nil;
                Break;
              end;

        vstView.FocusedColumn := Column;

        if StickViewNodeLabel = '' then
          if not Assigned(FoundViewLabelNode) then
            vstView.OffsetXY := OffsetXY;
      end;
    finally
      vstView.EndUpdate;
    end;
  end;
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(vstSpreadSheetWeapon) then vstSpreadSheetWeapon.UpdateHotTrack;
  if Assigned(vstSpreadsheetArmor) then vstSpreadsheetArmor.UpdateHotTrack;
  if Assigned(vstSpreadSheetAmmo) then vstSpreadSheetAmmo.UpdateHotTrack;
  if Assigned(vstView) then begin
    vstView.UpdateHotTrack;
    if Key = VK_SHIFT then
      vstView.Header.Options := vstView.Header.Options - [hoAutoSpring];
  end;
  if Assigned(vstNav) then begin
    vstNav.UpdateHotTrack;
    if Key = VK_SHIFT then
      vstNav.Header.Options := vstNav.Header.Options - [hoAutoSpring];
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if pnlCancel.Visible then
    UpdatePnlCancelPosition;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  tmrStartup.Enabled := True;
end;

procedure TfrmMain.fpnlViewFilterResize(Sender: TObject);
begin
  pnlViewTop.Height := fpnlViewFilterKeep.Top + fpnlViewFilterKeep.Height + 8;
  bnPinned.Height := fpnlViewFilterKeep.Height;
  bnPinned.Width := fpnlViewFilterKeep.Height;
end;

function TfrmMain.GetAddElement(out TargetNode: PVirtualNode; out TargetIndex: Integer;
  out TargetElement: IwbElement): Boolean;
var
  NodeDatas                   : PViewNodeDatas;
  Container                   : IwbContainerElementRef;
begin
  TargetIndex := High(Integer);
  Result := False;

  if Pred(vstView.FocusedColumn) > High(ActiveRecords) then
    Exit;

  TargetNode := vstViewFocusedNode;
  while Assigned(TargetNode) do begin
    if TargetNode = vstView.RootNode then
      NodeDatas := @ActiveRecords[0]
    else
      NodeDatas := vstView.GetNodeData(TargetNode);
    if Assigned(NodeDatas) then begin
      TargetElement := NodeDatas[Pred(vstView.FocusedColumn)].Element;
      if Assigned(TargetElement) then begin
        if (TargetIndex < High(Integer)) and Supports(TargetElement, IwbContainerElementRef, Container) then
          Dec(TargetIndex, Container.AdditionalElementCount);
        Break;
      end;
    end;
    TargetIndex := TargetNode.Index;
    if TargetNode = vstView.RootNode then
      Break;
    TargetNode := TargetNode.Parent;
  end;
  if not Assigned(TargetElement) then
    Exit;

  Result := True;
end;

function TfrmMain.GetTargetElement(Target: TBaseVirtualTree;
  var TargetNode: PVirtualNode; TargetColumn: Integer; out TargetIndex: Integer; out TargetElement: IwbElement): Boolean;
var
  NodeDatas                   : PViewNodeDatas;
  Container                   : IwbContainerElementRef;
begin
  TargetIndex := Low(Integer);
  TargetElement := nil;
  Result := False;

  if TargetColumn < 1 then
    Exit;
  if Pred(TargetColumn) > High(ActiveRecords) then
    Exit;

  while Assigned(TargetNode) do begin
    if TargetNode = Target.RootNode then
      NodeDatas := @ActiveRecords[0]
    else
      NodeDatas := Target.GetNodeData(TargetNode);
    if Assigned(NodeDatas) then begin
      TargetElement := NodeDatas[Pred(TargetColumn)].Element;
      if Assigned(TargetElement) then begin
        if (TargetIndex >= 0) and Supports(TargetElement, IwbContainerElementRef, Container) then
          Dec(TargetIndex, Container.AdditionalElementCount);
        Break;
      end;
    end;
    TargetIndex := TargetNode.Index;
    if TargetNode = Target.RootNode then
      Break;
    TargetNode := TargetNode.Parent;
  end;
  if not Assigned(TargetElement) then
    Exit;

  Result := True;
end;

function TfrmMain.GetRefBySelectionAsElements: TDynElements;
var
  i, j: Integer;
  ListItem                    : TListItem;
begin
  j := 0;
  Result := nil;
  SetLength(Result, lvReferencedBy.Items.Count);
  for i := 0 to Pred(lvReferencedBy.Items.Count) do begin
    ListItem := lvReferencedBy.Items[i];
    if Assigned(ListItem) and Assigned(ListItem.Data) and ListItem.Selected then begin
      Result[j] := IwbMainRecord(ListItem.Data);
      Inc(j);
    end;
  end;
  SetLength(Result, j);
end;

function TfrmMain.GetRefBySelectionAsMainRecords: TDynMainRecords;
var
  i, j: Integer;
  ListItem                    : TListItem;
begin
  j := 0;
  Result := nil;
  SetLength(Result, lvReferencedBy.Items.Count);
  for i := 0 to Pred(lvReferencedBy.Items.Count) do begin
    ListItem := lvReferencedBy.Items[i];
    if Assigned(ListItem) and Assigned(ListItem.Data) and ListItem.Selected then begin
      Result[j] := IwbMainRecord(ListItem.Data);
      Inc(j);
    end;
  end;
  SetLength(Result, j);
end;

function TfrmMain.GetSourceElement(Source: TObject; out SourceElement: IwbElement): Boolean;
begin
  Result := False;
  SourceElement := nil;

  if not (Source is TVirtualEditTree) then
    Exit;
  var lSourceTree := TVirtualEditTree(Source);

  if lSourceTree = vstView then begin
    if Length(lSourceTree.DragSelection) <> 1 then
      Exit;

    if lSourceTree.DragColumn < 1 then
      Exit;
    if Pred(lSourceTree.DragColumn) > High(ActiveRecords) then
      Exit;

    var lSourceViewNodeDatas: PViewNodeDatas := lSourceTree.GetNodeData(lSourceTree.DragSelection[0]);
    if not Assigned(lSourceViewNodeDatas) then
      Exit;

    SourceElement := lSourceViewNodeDatas[Pred(lSourceTree.DragColumn)].Element as IwbElement;
    if not Assigned(SourceElement) then
      Exit;

    Result := True;
  end else if lSourceTree = vstNav then begin
    var lDragSelection := lSourceTree.DragSelection;
    var lDragSelectionLength := Length(lDragSelection);

    if lDragSelectionLength < 1 then
      Exit;

    var lElements: IwbElements;
    SetLength(lElements, lDragSelectionLength);
    var lElementCount := 0;
    for var lDragSelectionIdx := 0 to Pred(lDragSelectionLength) do begin
      var lSourceNavNodeData: PNavNodeData := lSourceTree.GetNodeData(lSourceTree.DragSelection[lDragSelectionIdx]);
      if not Assigned(lSourceNavNodeData) then
        Continue;
      lElements[lElementCount] := lSourceNavNodeData.Element as IwbElement;
      if Assigned(lElements[lElementCount]) then
        Inc(lElementCount);
    end;
    if lElementCount < 1 then
      Exit;

    if lElementCount = 1 then
      SourceElement := lElements[0]
    else begin
      SetLength(lElements, lElementCount);
      SourceElement := wbMultipleElements(lElements);
    end;

    Result := True;
  end;
end;

function CompareElementID(Item1, Item2: Pointer): Integer;
begin
  if Item1 = Item2 then begin
    Result := 0;
    Exit;
  end;

  Result := CmpPtr(
    IwbElement(Item1).ElementID,
    IwbElement(Item2).ElementID);
end;

function TfrmMain.GetUniqueLinksTo(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer): TDynMainRecords;
var
  i, j, k : Integer;
  Element : IwbElement;
  LastID  : Pointer;
begin
  SetLength(Result, aNodeCount);
  j := 0;
  for i := 0 to Pred(aNodeCount) do begin
    Element := aNodeDatas[i].Element;
    if Assigned(Element) and Supports(Element.LinksTo, IwbMainRecord, Result[j]) then begin
      Result[j] := Result[j].MasterOrSelf;
      if Result[j].OverrideCount > 0 then
        Result[j] := Result[j].Overrides[Pred(Result[j].OverrideCount)];
      Inc(j);
    end;
  end;
  case j of
    0: Result := nil;
    1: SetLength(Result, 1);
  else
    wbMergeSortPtr(@Result[0], j, CompareElementID);
    k := 1;
    LastID := Result[0].ElementID;
    for i := 1 to Pred(j) do
      if Result[i].ElementID <> LastID then begin
        LastID := Result[i].ElementID;
        if i <> k then
          Result[k] := Result[i];
        Inc(k);
      end;
    SetLength(Result, k);
  end;
end;

procedure TfrmMain.InheritStateFromChildren(Node: PVirtualNode; NodeData: PNavNodeData);
var
  ChildNode                   : PVirtualNode;
  ChildData                   : PNavNodeData;
begin
  ChildNode := vstNav.GetFirstChild(Node);
  while Assigned(ChildNode) do begin
    ChildData := vstNav.GetNodeData(ChildNode);

    if ChildData.ConflictAll > NodeData.ConflictAll then
      NodeData.ConflictAll := ChildData.ConflictAll;

    if ChildData.ConflictThis > NodeData.ConflictThis then
      NodeData.ConflictThis := ChildData.ConflictThis;

    if (nnfInjected in ChildData.Flags) then
      Include(NodeData.Flags, nnfInjected);
    if (nnfNotReachable in ChildData.Flags) then
      Include(NodeData.Flags, nnfNotReachable);
    if (nnfReferencesInjected in ChildData.Flags) then
      Include(NodeData.Flags, nnfReferencesInjected);

    ChildNode := vstNav.GetNextSibling(ChildNode);
  end;
end;

procedure TfrmMain.InitChildren(const aNodeDatas: PViewNodeDatas; aNodeCount: Integer;
  var aChildCount: Cardinal);
var
  NodeData                    : PViewNodeData;
  Container                   : IwbContainerElementRef;
  FirstContainer              : IwbContainerElementRef;
  SortableContainer           : IwbSortableContainer;
  Element                     : IwbElement;
  i, j, k                     : Integer;
  SortedCount                 : Integer;
  AlignableCount              : Integer;
  NonSortedCount              : Integer;
  SortedKeys                  : array of TwbFastStringListCS;
  Sortables                   : array of IwbSortableContainer;
  SortKey                     : string;
  LastSortKey                 : string;
  DupCounter                  : Integer;

  AllKeys                     : TwbFastStringListCS;
  LeftKeys,RightKeys          : array of integer;
  KeyedElements               : array of array of Pointer;{skip the ref counting}
begin
  SortedCount := 0;
  NonSortedCount := 0;
  AlignableCount := 0;
  FirstContainer := nil;
  for i := 0 to Pred(aNodeCount) do begin
    NodeData := @aNodeDatas[i];
    Container := NodeData.Container;
    if not Assigned(FirstContainer) then
      FirstContainer := Container;
    if Assigned(Container) then
      if Supports(Container, IwbSortableContainer, SortableContainer) then begin
        if SortableContainer.Sorted then
          Inc(SortedCount)
        else if SortableContainer.Alignable then
          Inc(AlignableCount)
      end else
        Inc(NonSortedCount);
  end;

  i := 0;
  if SortedCount > 0 then
    Inc(i);
  if AlignableCount > 0 then
    Inc(i);
  if NonSortedCount > 0 then
    Inc(i);
  if i > 1 then begin
    if Assigned(FirstContainer) then
      PostAddMessage('Warning: Comparing a mix of sorted, unsorted, and/or alignable entries for "' + FirstContainer.Path + '" in "'+FirstContainer.ContainingMainRecord.Name+'"');
    SortedCount := 0;
    AlignableCount := 0;
  end;

  if SortedCount > 0 then begin
//    Assert(NonSortedCount = 0);

    SetLength(SortedKeys, Succ(aNodeCount));
    for i := Low(SortedKeys) to High(SortedKeys) do begin
      SortedKeys[i] := TwbFastStringListCS.Create;
      SortedKeys[i].Sorted := True;
      SortedKeys[i].Duplicates := dupError;
    end;

    try
      SortedKeys[aNodeCount].Duplicates := dupIgnore;

      SetLength(Sortables, aNodeCount);

      for i := 0 to Pred(aNodeCount) do begin
        NodeData := @aNodeDatas[i];
        Include(NodeData.ViewNodeFlags, vnfIsSorted);
        if Supports(NodeData.Container, IwbSortableContainer, Sortables[i]) then begin
          SortableContainer := Sortables[i];
          DupCounter := 0;
          LastSortKey := '';
          for j := 0 to Pred(SortableContainer.ElementCount) do begin
            Element := SortableContainer.Elements[j];
            SortKey := Element.DisplaySortKey[False];
            if SameStr(LastSortKey, SortKey) then
              Inc(DupCounter)
            else begin
              DupCounter := 0;
              LastSortKey := SortKey;
            end;

            SortKey := SortKey + '<' + IntToHex64(DupCounter, 4) + '>';

            SortedKeys[i].AddObject(SortKey, Pointer(Element));
            SortedKeys[aNodeCount].Add(SortKey);
          end;
        end;
      end;

      aChildCount := SortedKeys[aNodeCount].Count;

      for j := 0 to Pred(aChildCount) do begin
        SortKey := SortedKeys[aNodeCount].Strings[j];
        for i := 0 to Pred(aNodeCount) do
          if SortedKeys[i].Find(SortKey, k) then
            IwbElement(Pointer(SortedKeys[i].Objects[k])).SortOrder := j;
      end;

      for i := 0 to Pred(aNodeCount) do begin
        NodeData := @aNodeDatas[i];
        if Assigned(NodeData.Container) then
          NodeData.Container.SetIsSortedBySortOrder(False);
      end;

    finally

      for i := Low(SortedKeys) to High(SortedKeys) do
        FreeAndNil(SortedKeys[i]);

    end;

  end else begin
    if wbAlignArrayElements and (AlignableCount > 1) then
      AllKeys := TwbFastStringListCS.Create
    else
      AllKeys := nil;
    try
      for i := 0 to Pred(aNodeCount) do begin
        NodeData := @aNodeDatas[i];
        Container := NodeData.Container;

        if Assigned(Container) then begin
          case Container.ElementType of
            etMainRecord, etSubRecordStruct: begin
                aChildCount := (Container.Def as IwbRecordDef).MemberCount;
                Inc(aChildCount, Container.AdditionalElementCount);
                if Cardinal(Container.ElementCount) > aChildCount then begin
                  PostAddMessage('Error: Container.ElementCount {'+IntToStr(Container.ElementCount)+'} > aChildCount {'+IntToStr(aChildCount)+'} for ' + Container.Path + ' in ' + Container.ContainingMainRecord.Name);
                  for j := 0 to Pred(Container.ElementCount) do
                  PostAddMessage('  #'+IntToStr(j)+': ' + Container.Elements[j].Name);
                  //Assert(Cardinal(Container.ElementCount) <= aChildCount);
                end;
              end;
            etSubRecordArray, etSubRecord, etArray: begin

              with aNodeDatas[i].Container do begin
                if ElementCount > wbAlignArrayLimit then
                  FreeAndNil(AllKeys);
                if Assigned(AllKeys) then
                  for j := 0 to Pred(ElementCount) do
                    AllKeys.Add(Elements[j].DisplaySortKey[False]);
              end;
              if aChildCount < Cardinal(Container.ElementCount) then
                aChildCount := Container.ElementCount;
            end;
            etStruct, etValue, etUnion, etStructChapter:
              if aChildCount < Cardinal(Container.ElementCount) then
                aChildCount := Container.ElementCount;
          end;
        end;
      end;
      if Assigned(AllKeys) then begin
        AllKeys.Sorted := True;
        AllKeys.RemoveDuplicates;
        if AllKeys.Count > 1 then begin
          KeyedElements := nil;
          SetLength(KeyedElements, aNodeCount);
          FirstContainer := nil;
          if AllKeys.Count > 0 then begin
            for i := 0 to Pred(aNodeCount) do begin
              NodeData := @aNodeDatas[i];
              Container := NodeData.Container;
              if Assigned(Container) and (Container.ElementCount > 0) then begin
                if not Assigned(FirstContainer) then begin
                  FirstContainer := Container;
                  with Container do begin
                    SetLength(LeftKeys, ElementCount);
                    SetLength(KeyedElements[i], ElementCount);
                    for j := 0 to Pred(ElementCount) do begin
                      if not AllKeys.Find(Elements[j].DisplaySortKey[False], LeftKeys[j]) then
                        Assert(False);
                      KeyedElements[i, j] := Elements[j];
                    end;
                  end;
                end else begin
                  with Container do begin
                    SetLength(RightKeys, ElementCount);
                    for j := 0 to Pred(ElementCount) do
                      if not AllKeys.Find(Elements[j].DisplaySortKey[False], RightKeys[j]) then
                        Assert(False);
                  end;

                  with TDiff.Create(nil) do try
                    AllowModify := False;
                    if not Execute(PInteger(@LeftKeys[0]), PInteger(@RightKeys[0]), Length(LeftKeys), Length(RightKeys)) then
                      Assert(False);

                    for j := Pred(i) downto 0 do
                      if Length(KeyedElements[j]) > 0 then begin
                        SetLength(KeyedElements[j], Count);
                        for k := Pred(Count) downto 0 do
                          with Compares[k] do
                            if Kind in [ckNone, ckDelete] then
                              if oldIndex1 <> k then begin
                                KeyedElements[j, k] := KeyedElements[j, oldIndex1];
                                KeyedElements[j, oldIndex1] := nil;
                              end;
                      end;

                    with Container do begin
                      SetLength(KeyedElements[i], Count);
                      SetLength(LeftKeys, Count);
                      RightKeys := nil;
                      for k := Pred(Count) downto 0 do
                        with Compares[k] do begin
                          if Kind in [ckNone, ckAdd] then begin
                            KeyedElements[i, k] := Elements[oldIndex2];
                            LeftKeys[k] := int2;
                          end else
                            LeftKeys[k] := int1;
                        end;
                      if aChildCount < Count then
                        aChildCount := Count;
                    end;

                  finally
                    Free;
                  end;

                end;

              end;
            end;
            for i := 0 to Pred(aNodeCount) do begin
              NodeData := @aNodeDatas[i];
              Include(NodeData.ViewNodeFlags, vnfUseSortOrder);
              Include(NodeData.ViewNodeFlags, vnfIsAligned);
              for j := Low(KeyedElements[i]) to High(KeyedElements[i]) do
                if Assigned(KeyedElements[i, j]) then
                  IwbElement(KeyedElements[i, j]).SortOrder := j;
              if Assigned(NodeData.Container) then
                NodeData.Container.SetIsSortedBySortOrder(True);
            end;
          end;
        end;
      end;

    finally
      AllKeys.Free;
    end;
  end;
end;

procedure TfrmMain.InitConflictStatus(aNode: PVirtualNode; aInjected: Boolean; aNodeDatas: PViewNodeDatas = nil);

  procedure InheritConflict(Parent, Child: PViewNodeData);
  begin
    if Child.ConflictAll > Parent.ConflictAll then
      Parent.ConflictAll := Child.ConflictAll;
    if Child.ConflictThis > Parent.ConflictThis then
      Parent.ConflictThis := Child.ConflictThis;
  end;

var
  ChildNode      : PVirtualNode;
  ChildNodeDatas : PViewNodeDatas;
  NodeDatas      : PViewNodeDatas;
  i,j,k          : Integer;
  ConflictAll    : TConflictAll;
  ConflictThis   : TConflictThis;
  ConflictThisLmt: TConflictThis;
  Element        : IwbElement;
  ElementCount   : Integer;
  HasElement     : Boolean;
  lDontShow      : Boolean;
begin
  HasElement := False;
  lDontShow := False;
  if not Assigned(aNodeDatas) then begin
    aNodeDatas := vstView.GetNodeData(aNode);
    if Assigned(ActiveMaster) then
      aInjected := ActiveMaster.IsInjected;
  end;

  ChildNode := vstView.GetFirstChild(aNode);
  if not Assigned(ChildNode) then
    aNodeDatas[0].ConflictAll := ConflictLevelForNodeDatas(aNodeDatas, Length(ActiveRecords), ComparingSiblings, aInjected)
  else
    while Assigned(ChildNode) do begin
      ChildNodeDatas := vstView.GetNodeData(ChildNode);
      InitConflictStatus(ChildNode, aInjected, ChildNodeDatas);
      for i := Low(ActiveRecords) to High(ActiveRecords) do
        InheritConflict(@aNodeDatas[i], @ChildNodeDatas[i]);
      ChildNode := vstView.GetNextSibling(ChildNode);
    end;

  ConflictAll := caUnknown;
  ConflictThis := ctUnknown;
  for i := Low(ActiveRecords) to High(ActiveRecords) do begin
    HasElement := HasElement or Assigned(aNodeDatas[i].Element);
    if aNodeDatas[i].ConflictAll > ConflictAll then
      ConflictAll := aNodeDatas[i].ConflictAll;
    if aNodeDatas[i].ConflictThis > ConflictThis then
      ConflictThis := aNodeDatas[i].ConflictThis;
  end;

  if not HasElement then
    if wbTranslationMode then
      ConflictThis := ctIgnored;

  if (ConflictAll in [caUnknown, caOnlyOne]) and ComparingSiblings then
    ConflictAll := caNoConflict;

  for i := Low(ActiveRecords) to High(ActiveRecords) do
    aNodeDatas[i].ConflictAll := ConflictAll;

  if aNode <> vstView.RootNode then begin

    for i := Low(ActiveRecords) to High(ActiveRecords) do begin
      if vnfDontShow in aNodeDatas[i].ViewNodeFlags then
        lDontShow := True;
      if Assigned(aNodeDatas[i].Container) then begin
        lDontShow := False;
        Break;
      end;
    end;

    case ConflictThis of
      ctUnknown: vstView.IsVisible[aNode] := not lDontShow and not wbTranslationMode;
      ctIgnored: vstView.IsVisible[aNode] := not wbHideIgnored;
      ctNotDefined: begin
          if aNode.Parent = vstView.RootNode then
            ChildNodeDatas := @ActiveRecords[0]
          else
            ChildNodeDatas := vstView.GetNodeData(aNode.Parent);

          Element := nil;
          for i := Low(ActiveRecords) to High(ActiveRecords) do begin
            Element := ChildNodeDatas[i].Container;
            if Assigned(Element) then
              Break;
          end;

          if Assigned(Element) and (Element.ElementType in [etMainRecord, etSubRecordStruct]) then begin
            ElementCount := (Element.Def as IwbRecordDef).MemberCount;
            i := (Element as IwbContainer).AdditionalElementCount;
            j := Integer(aNode.Index);
            if (j >= i) and ((j-i) < ElementCount) then
              with (Element.Def as IwbRecordDef).Members[j - i] do begin
                if (wbTranslationMode and (not (dfTranslatable in DefFlags))) or
                  (wbTranslationMode and (ConflictPriority[nil] = cpIgnore)) then begin
                  ConflictThis := ctIgnored;
                  for k := Low(ActiveRecords) to High(ActiveRecords) do
                    aNodeDatas[k].ConflictThis := ConflictThis;
                end;

                if (ConflictThis <> ctIgnored) and HasDontShow then begin
                  lDontShow := True;
                  for k := Low(ActiveRecords) to High(ActiveRecords) do begin
                    Element := ChildNodeDatas[k].Container;
                    if Assigned(Element) then begin
                      lDontShow := DontShow[Element];
                      if not lDontShow then
                        Break;
                    end;
                  end;
                end;
              end;
          end;

          if not Assigned(Element) then
            if wbTranslationMode then
              ConflictThis := ctIgnored;

          if ConflictThis = ctNotDefined then begin
            NodeDatas := vstView.GetNodeData(aNode.Parent);
            if not Assigned(NodeDatas) then
              NodeDatas := @ActiveRecords[0];
            for i := Low(ActiveRecords) to High(ActiveRecords) do begin
              Element := NodeDatas[i].Container;
              if Assigned(Element) then
                Break;
            end;
            if Assigned(Element) and (Element.ElementType in [etMainRecord, etSubRecordStruct]) then begin
              ElementCount := (Element.Def as IwbRecordDef).MemberCount;
              i := (Element as IwbContainer).AdditionalElementCount;
              j := Integer(aNode.Index);
              if (j >= i) and ((j-i) < ElementCount) then
                with (Element.Def as IwbRecordDef).Members[Integer(aNode.Index) - i] do
                  if ConflictPriority[nil] = cpIgnore then
                    ConflictThis := ctIgnored;
            end;
          end;

          vstView.IsVisible[aNode] := ((ConflictThis <> ctIgnored) or not wbHideIgnored) and not lDontShow;
        end;
    else
      vstView.IsVisible[aNode] := not lDontShow;
    end;

    if vstView.IsVisible[aNode] then
      if HideNoConflict then
        if Length(ActiveRecords) > 1 then begin
          if ComparingSiblings then begin
            if ConflictAll < caConflictBenign then
              vstView.IsVisible[aNode] := False;
          end else begin
            if ConflictThis < ctOverride then
              vstView.IsVisible[aNode] := False;
          end;
        end else
          if not HasElement then
            vstView.IsVisible[aNode] := False;
  end;

  for i := Low(ActiveRecords) to High(ActiveRecords) do
    with aNodeDatas[i] do begin
      if Assigned(Element) then
        ElementGen := Element.ElementGeneration
      else
        ElementGen := 0;
      if Assigned(Container) then
        ContainerGen := Container.ElementGeneration
      else
        ContainerGen := 0;
    end;
end;

procedure TfrmMain.InitNodes(const aNode: PVirtualNode; const aNodeDatas: PViewNodeDatas;
  const aParentDatas: PViewNodeDatas;
  aNodeCount: Integer;
  aIndex: Cardinal;
  var aInitialStates: TVirtualNodeInitStates);
var
  NodeData                    : PViewNodeData;
  ParentData                  : PViewNodeData;
  Container                   : IwbContainerElementRef;
  SortableContainer           : IwbSortableContainer;
  i                           : Integer;
begin
  for i := 0 to Pred(aNodeCount) do begin
    NodeData := @aNodeDatas[i];
    ParentData := @aParentDatas[i];

    Container := ParentData.Container;
    if Assigned(Container) then begin
      if (vnfUseSortOrder in ParentData.ViewNodeFlags) or (Supports(Container, IwbSortableContainer, SortableContainer) and SortableContainer.Sorted) then
        NodeData.Element := Container.ElementBySortOrder[aIndex]
      else
        case Container.ElementType of
          etMainRecord, etSubRecordStruct:
            NodeData.Element := Container.ElementBySortOrder[aIndex];
          etSubRecordArray, etArray, etStruct, etSubRecord, etValue, etUnion, etStructChapter:
            if aIndex < Cardinal(Container.ElementCount) then
              NodeData.Element := Container.Elements[aIndex];
        end;
    end;
    if Assigned(NodeData.Element) then begin
      if Assigned(aNode) and Assigned(ViewFocusedElement) and not Assigned(NodeForViewFocusedElement) then
        if ViewFocusedElement.Equals(NodeData.Element) then begin
          NodeForViewFocusedElement := aNode;
          ColumnForViewFocusedElement := Succ(i);
        end;
      if NodeData.Element.DontShow then begin
        NodeData.Element := nil;
        Include(NodeData.ViewNodeFlags, vnfDontShow);
      end;
    end;

    if not Assigned(NodeData.Element) and
       Assigned(Container) and
       (Container.ElementType = etMainRecord) and
       (Container as IwbMainRecord).IsPartialForm
    then begin
      Include(NodeData.ViewNodeFlags, vnfIgnore);
      Include(NodeData.ViewNodeFlags, vnfIsPartialForm);
    end;
  end;

  aInitialStates := [ivsDisabled];
  for i := 0 to Pred(aNodeCount) do
    with aNodeDatas[i] do begin
      if Assigned(Element) then
        Exclude(aInitialStates, ivsDisabled)
      else begin
        if Assigned(aParentDatas) and ((vnfIgnore in aParentDatas[i].ViewNodeFlags) or (Assigned(aParentDatas[i].Element) and (aParentDatas[i].Element.ConflictPriority in [cpIgnore, cpNormalIgnoreEmpty]))) then
          Include(ViewNodeFlags, vnfIgnore);
        if Assigned(aParentDatas) and (vnfIsPartialForm in aParentDatas[i].ViewNodeFlags) then
          Include(ViewNodeFlags, vnfIsPartialForm);
      end;

      if not Assigned(Container) then
        if Supports(Element, IwbContainerElementRef, Container) then begin
          //          if Container.ElementCount = 0 then
          //            Container := nil;
        end;

      if Assigned(Container) then
        if Container.ElementCount > 0 then
          Include(aInitialStates, ivsHasChildren)
        else if Supports(Container, IwbSubRecordStruct) then
          Include(aInitialStates, ivsHasChildren);
    end;
end;

procedure TfrmMain.InvalidateElementsTreeView;
var
  Node                        : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
begin
  Exit; //should be handled by NavUpdate

  Node := vstNav.GetLastInitialized;
  while Assigned(Node) do begin
    NodeData := vstNav.GetNodeData(Node);
    if Assigned(NodeData) then begin
      with NodeData^ do begin
        ConflictAll := caUnknown;
        ConflictThis := ctUnknown;
        Flags := [];
      end;

      if Assigned(NodeData.Element) and (NodeData.Element.ElementType = etMainRecord) then begin
        MainRecord := (NodeData.Element as IwbMainRecord);
        with MainRecord do begin
          ConflictAll := caUnknown;
          ConflictThis := ctUnknown;
        end;
        ConflictLevelForMainRecord(MainRecord, NodeData.ConflictAll, NodeData.ConflictThis);
        with NodeData^ do begin
          OrgConflictAll  := ConflictAll;
          OrgConflictThis := ConflictThis;
        end;
        if MainRecord.IsInjected then
          Include(NodeData.Flags, nnfInjected);
        if MainRecord.IsNotReachable then
          Include(NodeData.Flags, nnfNotReachable);
        if MainRecord.ReferencesInjected then
          Include(NodeData.Flags, nnfReferencesInjected);
      end;

      if InheritConflictByParent and (Node.ChildCount > 0) then
        InheritStateFromChildren(Node, NodeData);

      vstNav.InvalidateNode(Node);
    end;
    Node := vstNav.GetPreviousInitialized(Node);
  end;
end;


function TfrmMain.IsPinned: Boolean;
begin
  Result := bnPinned.Down and (LockOutPinnedCount < 1);
end;

function TfrmMain.IsViewNodeFiltered(aNode: PVirtualNode): Boolean;
var
  NameFilter  : string;
  ValueFilter : string;

  function FoundName: Boolean;
  var
    CellText    : string;
    i           : Integer;
  begin
    if NameFilter = '' then
      Exit(True);

    Result := False;
    try
      for i := 1 to Pred(vstView.Header.Columns.Count) do begin
        CellText := '';
        FocusedColumnOverride := i;
        vstViewGetText(vstView, aNode, 0, ttNormal, CellText);
        Result := CellText.ToLowerInvariant.Contains(NameFilter);
        if Result then
          Break;
      end;
    finally
      FocusedColumnOverride := -1;
    end;
  end;

  function FoundValue: Boolean;
  var
    CellText    : string;
    i           : Integer;
  begin
    if ValueFilter = '' then
      Exit(True);

    Result := False;
    for i := 1 to Pred(vstView.Header.Columns.Count) do begin
      CellText := '';
      vstViewGetText(vstView, aNode, i, ttNormal, CellText);
      Result := CellText.ToLowerInvariant.Contains(ValueFilter);
      if Result then
        Break;
    end;
  end;

begin
  NameFilter := edViewFilterName.Text;
  NameFilter := NameFilter.ToLowerInvariant;
  ValueFilter := edViewFilterValue.Text;
  ValueFilter := ValueFilter.ToLowerInvariant;

  if NameFilter <> '' then
    if ValueFilter <> '' then
      if cobViewFilter.ItemIndex = 0 then
        Exit(not (FoundName and FoundValue))
      else
        Exit(not (FoundName or FoundValue))
    else
      Exit(not FoundName)
  else
    if ValueFilter <> '' then
      Exit(not FoundValue)
    else
      Exit(False);
end;

procedure TfrmMain.jbhGitHubBalloonClick(Sender: TObject);
begin
  bnGitHub.Click;
  jbhGitHub.CancelHint;
end;

procedure TfrmMain.jbhNexusModsBalloonClick(Sender: TObject);
begin
  bnNexusMods.Click;
  jbhNexusMods.CancelHint;
end;

procedure TfrmMain.jbhGitHubCloseBtnClick(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Settings) and (GitHubVersion.Major > 0) then begin
    Settings.WriteString('GitHub', 'SnoozeVersion', GitHubVersion.ToString);
    Settings.WriteInteger('GitHub', 'SnoozeDate', Trunc(Now));
    Settings.UpdateFile;
  end;
end;

procedure TfrmMain.jbhNexusModsCloseBtnClick(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Settings) and (NexusModsVersion.Major > 0) then begin
    Settings.WriteString('NexusMods', 'SnoozeVersion', NexusModsVersion.ToString);
    Settings.WriteInteger('NexusMods', 'SnoozeDate', Trunc(Now));
    Settings.UpdateFile;
  end;
end;

procedure TfrmMain.jbhPatreonBalloonClick(Sender: TObject);
begin
  bnPatreon.Click;
  jbhPatreon.CancelHint;
end;

procedure TfrmMain.jbhPatreonCloseBtnClick(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(Settings) then begin
    Settings.WriteInteger('Patreon', 'SnoozeCounter', 10);
    Settings.WriteInteger('Patreon', 'SnoozeDate', Trunc(Now));
    Settings.UpdateFile;
  end;
end;

procedure TfrmMain.jbhSaveBalloonClick(Sender: TObject);
begin
  SaveChanged(False, True);
end;

procedure TfrmMain.jbhSaveCloseBtnClick(Sender: TObject; var CanClose: Boolean);
begin
  SetSaveInterval;
end;

procedure TfrmMain.InvalidateElementsTreeView(aNodes: TNodeArray);
var
  Node                        : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  i                           : Integer;
begin
  Exit; //should be handled by NavUpdate

  if not Assigned(vstNav) then
    Exit;

  if Length(aNodes) = 0 then
    aNodes := vstNav.GetSortedSelection(True);
  for i := -1 to High(aNodes) do begin
    if i < 0 then
      Node := vstNav.FocusedNode
    else
      Node := aNodes[i];

    while Assigned(Node) and (Node <> vstNav.RootNode) do begin
      NodeData := vstNav.GetNodeData(Node);
      if Assigned(NodeData) then begin
        with NodeData^ do begin
          ConflictAll := caUnknown;
          ConflictThis := ctUnknown;
          Flags := [];
        end;

        if Assigned(NodeData.Element) and (NodeData.Element.ElementType = etMainRecord) then begin
          MainRecord := (NodeData.Element as IwbMainRecord);
          with MainRecord do begin
            ConflictAll := caUnknown;
            ConflictThis := ctUnknown;
          end;
          ConflictLevelForMainRecord(MainRecord, NodeData.ConflictAll, NodeData.ConflictThis);
          with NodeData^ do begin
            OrgConflictAll  := ConflictAll;
            OrgConflictThis := ConflictThis;
          end;
          if MainRecord.IsInjected then
            Include(NodeData.Flags, nnfInjected);
          if MainRecord.IsNotReachable then
            Include(NodeData.Flags, nnfNotReachable);
          if MainRecord.ReferencesInjected then
            Include(NodeData.Flags, nnfReferencesInjected);
        end;

        if InheritConflictByParent and (Node.ChildCount > 0) then
          InheritStateFromChildren(Node, NodeData);

        vstNav.InvalidateNode(Node);
      end;
      Node := Node.Parent;
    end;
  end;
end;

procedure TfrmMain.JumpTo(aInterface: IInterface; aBackward: Boolean);
var
  Current                     : IInterface;
  MainRecord                  : IwbMainRecord;
  Element                     : IwbElement;
  HistoryEntry                : IHistoryEntry;
begin
  UserWasActive := True;

  if (pgMain.ActivePage = tbsView) or (pgMain.ActivePage = tbsReferencedBy) then begin
    if Assigned(ActiveRecord) then begin
      if pgMain.ActivePage = tbsView then
        Current := TMainRecordPosHistoryEntry.Create(ActiveRecord)
      else
        Current := TMainRecordRefByHistoryEntry.Create(ActiveRecord);
    end else if (Length(CompareRecords) > 0) then
      Current := TCompareRecordsPosHistoryEntry.Create(CompareRecords);
  end
  else
    Current := TTabHistoryEntry.Create(pgMain.ActivePage);

  if Assigned(Current) then begin
    if aBackward then begin
      if not Assigned(ForwardHistory) then
        ForwardHistory := TInterfaceList.Create;
      ForwardHistory.Add(Current);
    end
    else begin
      if not Assigned(BackHistory) then
        BackHistory := TInterfaceList.Create;
      BackHistory.Add(Current);
    end;
  end;

  MainRecord := nil;
  Element := nil;
  if not Supports(aInterface, IwbMainRecord, MainRecord) then
    if Supports(aInterface, IwbElement, Element) then
      MainRecord := Element.ContainingMainRecord;

  if Assigned(MainRecord) then
    if Assigned(Element) then
      aInterface := TMainRecordElementHistoryEntry.Create(MainRecord, Element)
    else
      aInterface := TMainRecordHistoryEntry.Create(MainRecord);

  if Supports(aInterface, IHistoryEntry, HistoryEntry) then
    HistoryEntry.Show;
end;

procedure TfrmMain.lvReferencedByColumnClick(Sender: TObject; Column: TListColumn);
begin
  ReferencedBySortColumn := Column;
  lvReferencedBy.AlphaSort;
end;

procedure TfrmMain.lvReferencedByCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not Assigned(ReferencedBySortColumn) or (ReferencedBySortColumn.Index = 0) then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    Compare := CompareText(Item1.SubItems[Pred(ReferencedBySortColumn.Index)], Item2.SubItems[Pred(ReferencedBySortColumn.Index)])
end;

procedure TfrmMain.lvReferencedByDblClick(Sender: TObject);
var
  ListItem                    : TListItem;
begin
  ListItem := lvReferencedBy.Selected;
  if Assigned(ListItem) and Assigned(ListItem.Data) then
    JumpTo(IwbMainRecord(ListItem.Data), False);
end;

procedure TfrmMain.lvReferencedByKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Nodes      : TDynMainRecords;
  MainRecord : IwbMainRecord;
  s, t       : string;
  i          : integer;
begin
  Nodes := GetRefBySelectionAsMainRecords;

  case Key of
    VK_DELETE: begin
      pmuRefByPopup(nil);
      if mniRefByRemove.Enabled and mniRefByRemove.Visible then
        mniRefByRemove.Click;
    end;
  end;

  if ssCtrl in Shift then begin
    case Key of
      Ord('C'): begin
        Key := 0;
        s := '';
        Nodes := GetRefBySelectionAsMainRecords;
        for i := Low(Nodes) to High(Nodes) do begin
          MainRecord := Nodes[i] as IwbMainRecord;
          t := '';
          if Assigned(MainRecord) then
            if Shift * [ssShift, ssAlt] = [ssAlt] then
              t := MainRecord.Name
            else
              t := IntToHex64(Cardinal(MainRecord.FixedFormID), 8);
          if t <> '' then begin
            if s <> '' then
              s := s + CRLF;
            s := s + t;
          end;
        end;
        if s <> '' then
          Clipboard.AsText := s;
        Exit;
      end;
    else
      Exit;
    end;
  end;
end;

procedure TfrmMain.mniViewAddClick(Sender: TObject);
var
  TargetNode                  : PVirtualNode;
  TargetIndex                 : Integer;
  TargetElement               : IwbElement;
  NewElement                  : IwbElement;
  Control                     : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if GetAddElement(TargetNode, TargetIndex, TargetElement) then begin
    if not EditWarn then
      Exit;

    LockProcessMessages;
    try
      //    vstView.BeginUpdate;
      try
        var lTemplate: IwbElement := nil;
        if TMenuItem(Sender).Tag >= 0 then begin
          var lTemplates := TargetElement.GetAssignTemplates(TargetIndex);
          var lTemplateIdx := TMenuItem(Sender).Tag;
          if (lTemplateIdx >= Low(lTemplates)) and (lTemplateIdx <= High(lTemplates)) then
            lTemplate := lTemplates[lTemplateIdx];
        end;

        NewElement := TargetElement.Assign(TargetIndex, lTemplate, False);
        if Assigned(NewElement) then
          NewElement.SetToDefaultIfAsCreatedEmpty;

        ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
        TargetElement := nil;
        Control := GetKeyState(VK_CONTROL) < 0;
        if EditAddedElement or (wbFocusAddedElement xor Control) then begin
          ViewFocusedElement := NewElement;
          EditFocusedViewElement := EditAddedElement;
        end;
        PostResetActiveTree;
      finally
        //      vstView.EndUpdate;
      end;

      InvalidateElementsTreeView(NoNodes);
    finally
      UnLockProcessMessages;
    end;
  end;
end;

procedure TfrmMain.mniViewClipboardClick(Sender: TObject);

  procedure SetupCopyMni(aMni: TMenuItem; const aName, aValue: string);
  begin
    if not Assigned(aMni) then
      Exit;
    aMni.Visible := aValue <> '';
    if aMni.Visible then
      aMni.Caption := aName + ' <' + ShortenText(aValue) + '>';
  end;

var
  Element                     : IwbElement;
begin
  Element := GetFocusedViewElementSafely;
  if not Assigned(Element) then
    Exit;

  SetupCopyMni(mniCopyPathToClipboard, 'Copy path', Element.Path);
  SetupCopyMni(mniCopyPathNameToClipboard, 'Copy full path (short names)', Element.PathName);
  SetupCopyMni(mniCopyFullPathToClipboard, 'Copy full path', Element.FullPath);
  SetupCopyMni(mniCopyIndexedPathToClipboard, 'Copy indexed path', Element.IndexedPath[False]);

  var lHasSignature: IwbHasSignature;
  if Supports(Element, IwbHasSignature, lHasSignature) then
    SetupCopyMni(mniCopySignatureToClipboard, 'Copy signature', lHasSignature.Signature)
  else
    mniCopySignatureToClipboard.Visible := False;

  var lName := Element.Name;
  SetupCopyMni(mniCopyNameToClipboard, 'Copy name', lName);

  var lDisplayName := Element.DisplayName[True];
  if lName <> lDisplayName then
    SetupCopyMni(mniCopyDisplayNameToClipboard, 'Copy display name', lDisplayName)
  else
    mniCopyDisplayNameToClipboard.Visible := False;

  var lShortName := Element.ShortName;
  if lName <> lShortName then
    SetupCopyMni(mniCopyShortNameToClipboard, 'Copy short name', lShortName)
  else
    mniCopyShortNameToClipboard.Visible := False;
end;

procedure TfrmMain.mniViewColumnWidthClick(Sender: TObject);
var
  i: Integer;
begin
  UserWasActive := True;

  if mniViewColumnWidthFitAll.Checked then
    i := 1
  else if mniViewColumnWidthFitText.Checked then
    i := 2
  else if mniViewColumnWidthFitSmart.Checked then
    i := 3
  else
    i := 0;
  Settings.WriteInteger('View','ColumnWidth', i);
  Settings.UpdateFile;
  UpdateColumnWidths;
end;

procedure TfrmMain.mniViewCompareReferencedRowClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Records                     : TDynMainRecords;
begin
  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if not Assigned(NodeDatas) then
    Exit;
  Records := GetUniqueLinksTo(NodeDatas, Length(ActiveRecords));
  JumpTo(TCompareRecordsHistoryEntry.Create(Records), False);
end;

procedure TfrmMain.mniViewCopyToSelectedRecordsClick(Sender: TObject);
var
  Node             : PVirtualNode;
  NodeDatas        : PViewNodeDatas;
  SourceColumn     : Integer;
  SourceElement    : IwbElement;
  i, j             : Integer;
  TargetColumns    : array of Integer;
begin
  if not wbEditAllowed then
    Exit;

  Node := vstViewFocusedNode;
  if not Assigned(Node) then
    Exit;

  SourceColumn := vstView.FocusedColumn;
  if (SourceColumn < 1) or (Pred(SourceColumn) > High(ActiveRecords)) then
    Exit;

  NodeDatas := vstView.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  SourceElement := NodeDatas[Pred(SourceColumn)].Element;

  if not Assigned(SourceElement) then
    Exit;

  with TfrmFileSelect.Create(Self) do try

    Caption := 'Which records should this value be copied to?';

    for i := Low(ActiveRecords) to High(ActiveRecords) do
      if i <> Pred(SourceColumn) then
        if Assigned(ActiveRecords[i].Element) then
          CheckListBox1.AddItem(ActiveRecords[i].Element.Name, Pointer(i));
    CheckListBox1.CheckAll(cbChecked);

    if ShowModal <> mrOk then
      Exit;

    j := 0;
    SetLength(TargetColumns, CheckListBox1.Count);
    for i := 0 to Pred(CheckListBox1.Count) do
      if CheckListBox1.Checked[i] then begin
        TargetColumns[j] := Integer(CheckListBox1.Items.Objects[i]) + 1;
        Inc(j);
      end;

  finally
    Free;
  end;

  SetLength(TargetColumns, j);
  if j < 1 then
    Exit;
  if not EditWarn then
    Exit;

  for i := Low(TargetColumns) to High(TargetColumns) do
    PerformDrop(vstView, Node, TargetColumns[i], SourceElement);

  InvalidateElementsTreeView(NoNodes);
  ViewFocusedElement := SourceElement;
  EditFocusedViewElement := False;
  PostResetActiveTree;
  vstNav.Invalidate;
end;


procedure TfrmMain.mniViewCopyMultipleToSelectedRecordsClick(Sender: TObject);
var
  AllNodeDatas                : array of PViewNodeDatas;
  NodeDatas                   : PViewNodeDatas;
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  Names                       : array of string;
  MainRecords                 : array of IwbMainRecord;
  MainRecordIndices           : array of Integer;
  SourceMainRecord            : IwbMainRecord;
  TargetMainRecord            : IwbMainRecord;
  SelectedNodes               : TNodeArray;
  i, j, k                     : Integer;
  Node                        : PVirtualNode;
begin
  if not wbEditAllowed then
    Exit;

  SourceMainRecord := nil;
  SetLength(AllNodeDatas, 0);
  SetLength(Names, 0);
  for Node in vstView.LevelNodes(0) do begin
    NodeDatas := vstView.GetNodeData(Node);
    if Assigned(NodeDatas) then begin
      Element := nil;
      if (vstView.FocusedColumn > 0) and (Pred(vstView.FocusedColumn) <= High(ActiveRecords)) then begin
        Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
        if Assigned(Element) and not Assigned(SourceMainRecord) then
          SourceMainRecord := Element.ContainingMainRecord;
      end;
      if not Assigned(Element) then
        for i := Low(ActiveRecords) to High(ActiveRecords) do begin
          Element := NodeDatas[i].Element;
          if Assigned(Element) then
            Break;
        end;

      if Assigned(Element) and (Element.Name <> 'Record Header') and not Element.Name.StartsWith('EDID') then begin
        SetLength(AllNodeDatas, Succ(Length(AllNodeDatas)));
        SetLength(Names, Length(AllNodeDatas));
        AllNodeDatas[High(AllNodeDatas)] := NodeDatas;
        Names[High(Names)] := Element.Name;
      end;
    end;
  end;
  if Length(AllNodeDatas) < 1 then
    Exit;

  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 2 then
    Exit;
  SetLength(MainRecords, Length(SelectedNodes));
  SetLength(MainRecordIndices, Length(SelectedNodes));
  j := 0;
  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    NodeData := vstNav.GetNodeData(SelectedNodes[i]);
    if Assigned(NodeData) and not SourceMainRecord.Equals(NodeData.Element) and
      Supports(NodeData.Element, IwbMainRecord, MainRecords[j]) then begin
        MainRecordIndices[j] := i;
        Inc(j);
      end;
  end;
  SetLength(MainRecords, j);
  SetLength(MainRecordIndices, j);
  if Length(MainRecords) < 1 then
    Exit;

  with TfrmFileSelect.Create(Self) do try

    Caption := 'What subrecords do you want to copy?';

    for i := Low(AllNodeDatas) to High(AllNodeDatas) do begin
      CheckListBox1.AddItem(Names[i], nil);
      CheckListBox1.Checked[Pred(CheckListBox1.Items.Count)] := True;
    end;

    if ShowModal <> mrOk then
      Exit;

    j := 0;
    for i := 0 to Pred(CheckListBox1.Items.Count) do
      if CheckListBox1.Checked[i] then begin
        if j <> i then
          AllNodeDatas[j] := AllNodeDatas[i];
        Inc(j);
      end;
    SetLength(AllNodeDatas, j);
    Names := nil; //not valid anymore
  finally
    Free;
  end;
  if Length(AllNodeDatas) < 1 then
    Exit;

  with TfrmFileSelect.Create(Self) do try

    Caption := 'Which records should this value be copied to?';

    for i := Low(MainRecords) to High(MainRecords) do begin
      CheckListBox1.AddItem(MainRecords[i].Name, nil);
      CheckListBox1.Checked[i] := True;
    end;

    if ShowModal <> mrOk then
      Exit;

    try
      for j := Low(AllNodeDatas) to High(AllNodeDatas) do begin
        NodeDatas := AllNodeDatas[j];

        Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
        if Assigned(Element) then begin
          for i := Low(MainRecords) to High(MainRecords) do begin
            if CheckListBox1.Checked[i] then begin
              if not EditWarn then
                Exit;

              wbCopyElementToRecord(Element, MainRecords[i], False, True)
            end;
          end;
        end else begin
          for k := Low(MainRecords) to High(MainRecords) do begin
            if CheckListBox1.Checked[k] then begin
              for i := Low(ActiveRecords) to High(ActiveRecords) do begin
                Element := NodeDatas[i].Element;
                if Assigned(Element) then begin
                  TargetMainRecord := Element.ContainingMainRecord;
                  if Assigned(TargetMainRecord) and MainRecords[k].Equals(TargetMainRecord) then begin
                    if Element.IsRemovable then begin
                      if not EditWarn then
                        Exit;
                      Element.Remove;
                      Element := nil;
                      NodeDatas[i].Element := nil;
                    end;
                    Break;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      for i := Low(MainRecords) to High(MainRecords) do
        if CheckListBox1.Checked[i] then
          MainRecords[i].UpdateRefs;
    finally
      for i := Low(SelectedNodes) to High(SelectedNodes) do
        vstNav.IterateSubtree(SelectedNodes[i], ClearConflict, nil);
      InvalidateElementsTreeView(SelectedNodes);
      PostResetActiveTree;
      vstNav.Invalidate;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.mniNavAddMastersClick(Sender: TObject);
var
  NodeData                    : PNavNodeData;
  _File                       : IwbFile;
  sl                          : TStringList;
  s                           : string;
begin
  UserWasActive := True;

  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if Assigned(NodeData) and Supports(NodeData.Element, IwbFile, _File) then begin
    sl := TStringList.Create;
    try
      if not _File.IsEditable then
        Exit;

      with TfrmModuleSelect.Create(Self) do try
        _File.GetMasters(sl);
        sl.Sorted := True;
        AllModules := wbModulesByLoadOrder.FilteredByFlag(mfValid).FilteredBy(function(a: PwbModuleInfo): Boolean
          begin
            Result := Assigned(a.miFile);
            if Result then begin
              Result := a._File.LoadOrder < _File.LoadOrder;
              if Result then
                Result := sl.IndexOf(a._File.FileName) < 0;
            end;
          end);
        if Length(AllModules) < 1 then
          Exit;
        sl.Clear;
        sl.Sorted := False;
        FilterFlag := mfHasFile;
        SelectFlag := mfTagged;
        AllModules.ExcludeAll(mfTagged);
        AllowCancel;
        Caption := 'Which masters do you want to add?';
        if ShowModal = mrOk then
          sl.AddStrings(SelectedModules.ToStrings);
      finally
        Free;
      end;

      if sl.Count > 0 then begin
        if not EditWarn then
          Exit;

        DoSetActiveRecord(nil);

        if sl.Count = 1 then
          s := 'Add '+sl[0]+' as new master to ' + _File.Name
        else
          s := 'Add '+sl.Count.ToString+' new masters to ' + _File.Name;
        PerformLongAction(s, '', procedure begin
          _File.AddMasters(sl);
        end);
      end;
    finally
      sl.Free;
    end;
  end;
end;

procedure TfrmMain.ApplyScriptToSelection(aSelection: TNodeArray; aCount: Cardinal; const abShowMessages: boolean);
var
  Node        : PVirtualNode;
begin
  for var i := Low(aSelection) to High(aSelection) do
  begin
    var StartNode: PVirtualNode := aSelection[i];

    if Assigned(StartNode) then
    begin
      Node := vstNav.GetLast(StartNode);

      if not Assigned(Node) then
        Node := StartNode;
    end
    else
      Node := nil;

    while Assigned(Node) do
    begin
      var NextNode: PVirtualNode := vstNav.GetPrevious(Node);
      var NodeData: PNavNodeData := vstNav.GetNodeData(Node);

      if Assigned(NodeData.Element) then
        if NodeData.Element.ElementType in ScriptProcessElements then
        begin
          var Result: Variant;

          if not abShowMessages then
            wbProgressUnlock;

          try
            Inc(wbHideStartTime);

            try
              Result := Script.CallFunction('Process', [NodeData.Element]);
            finally
              Dec(wbHideStartTime);
            end;
          finally
            if not abShowMessages then
              wbProgressLock;
          end;

          if Result <> 0 then
          begin
            wbProgress(ScriptSelfTerminated + IntToStr(Result));
            Exit;
          end;

          Inc(aCount);

          wbCurrentProgress := 'Processed Records: ' + aCount.ToString;
        end;

      if Node = StartNode then
        Node := nil
      else
        Node := NextNode;

      wbTick;
    end;
  end;
end;

procedure TfrmMain.ApplyScriptToSelection(aSelection: TDynElements; aCount: Cardinal; const abShowMessages: boolean);
begin
  for var i := Low(aSelection) to High(aSelection) do
  begin
    var Element: IwbElement := aSelection[i];

    if Element.ElementType in ScriptProcessElements then
    begin
      var Result: Variant;

      if not abShowMessages then
        wbProgressUnlock;

      try
        Inc(wbHideStartTime);

        try
          Result := Script.CallFunction('Process', [Element]);
        finally
          Dec(wbHideStartTime);
        end;
      finally
        if not abShowMessages then
          wbProgressLock;
      end;

      if Result <> 0 then begin
        wbProgress(ScriptSelfTerminated + IntToStr(Result));
        Exit;
      end;

      Inc(aCount);

      wbCurrentProgress := 'Processed Records: ' + aCount.ToString;
    end;

    wbTick;
  end;
end;

procedure TfrmMain.ApplyScript(const aScriptName: string; aScript: string; aRefByMode: Boolean);
const
  sJustWait                   = 'Applying script. Please wait...';
var
  SelectedNodes               : TNodeArray;
  SelectedElements            : TDynElements;
  Count                       : Cardinal;
  p                           : Integer;
  s                           : string;
  bShowMessages               : Boolean;
  PrevMaxMessageInterval      : UInt64;
begin
  // prevent execution of new scripts if already executing
  if Assigned(Script) then begin
    PostAddMessage('Script is already running');
    Exit;
  end;

  if Trim(aScript) = '' then
    Exit;

  // check for the Silent mode keyword
  p := Pos('Mode:', aScript);
  bShowMessages := not ContainsText(Copy(aScript, p, PosEx(#10, aScript, p) - p), 'Silent');

  Count := 0;
  ScriptProcessElements := [etMainRecord];

  Script := TxeScriptHost.CreateScript(aScriptName, aScript);
  try
    ScriptRunning := True;
    UserWasActive := True;

    if bShowMessages then
      pgMain.ActivePage := tbsMessages;

    if not aRefByMode then
      SelectedNodes := vstNav.GetSortedSelection(True)
    else
      SelectedElements := GetRefBySelectionAsElements;

    PrevMaxMessageInterval := wbMaxMessageInterval;
    wbMaxMessageInterval := High(Integer);
    if not bShowMessages then
      wbProgressLock;
    try
      if aScriptName <> '' then
        s := 'Applying script "'+aScriptName+'"'
      else
        s := 'Applying script';
      PerformLongAction(s, '', procedure
      begin
        vstNav.BeginUpdate;
        NavCleanupCollapsedNodeChildren;
        try
          try
            if Script.FunctionExists('Initialize') then begin
              var Result: Variant;
              Inc(wbHideStartTime);
              try
                Result := Script.CallFunction('Initialize', []);
              finally
                Dec(wbHideStartTime);
              end;
              if Result <> 0 then begin
                wbProgress(ScriptSelfTerminated + IntToStr(Result));
                Exit;
              end;
            end;

            // skip selected records iteration if Process() function doesn't exist
            if Script.FunctionExists('Process') then
              if not aRefByMode then
                ApplyScriptToSelection(SelectedNodes, Count, bShowMessages)
              else
                ApplyScriptToSelection(SelectedElements, Count, bShowMessages);

            if Script.FunctionExists('Finalize') then begin
              var Result: Variant;
              Inc(wbHideStartTime);
              try
                Result := Script.CallFunction('Finalize', []);
              finally
                Dec(wbHideStartTime);
              end;
              if Result <> 0 then begin
                wbProgress(ScriptSelfTerminated + IntToStr(Result));
                Exit;
              end;
            end;

          except
            on E: Exception do begin
              var LastErrorLocation := Script.GetLastErrorLocation;
              if LastErrorLocation <> '' then
                LastErrorLocation := ' in ' + LastErrorLocation;
              wbProgress('Exception' + LastErrorLocation + ': [' + E.ClassName + '] ' + E.Message, True);
              //raise; crashes, with Access Violation in delphi exception handling code even though it shouldn't...
              Abort;
            end;
          end;

        finally
          NavCleanupCollapsedNodeChildren;
          vstNav.EndUpdate;
        end;
      end);
    finally
      wbMaxMessageInterval := PrevMaxMessageInterval;
      if not bShowMessages then
        wbProgressUnlock;
    end;

    InvalidateElementsTreeView(NoNodes);
    vstNav.Invalidate;
    if pgMain.ActivePage = tbsView then
      CheckViewForChange;
  finally
    Script := nil;
    ScriptRunning := False;
  end;
end;

procedure TfrmMain.ApplyViewFilter;
var
  Node         : PVirtualNode;
  Unfiltered   : array of PVirtualNode;
  i            : Integer;
begin
  with vstView do begin
    Unfiltered := nil;
    Node := GetFirst;
    while Assigned(Node) do begin
      IsFiltered[Node] := IsViewNodeFiltered(Node);
      if not IsFiltered[Node] then begin
        SetLength(Unfiltered, Succ(Length(Unfiltered)));
        Unfiltered[High(Unfiltered)] := Node;
      end;
      Node := GetNext(Node);
    end;
    for i := Low(Unfiltered) to High(Unfiltered) do begin
      Node := NodeParent[Unfiltered[i]];
      while Assigned(Node) do begin
        IsFiltered[Node] := False;
        Node := NodeParent[Node];
      end;

      if cbViewFilterKeepChildren.Checked then begin
        Node := GetLast(Unfiltered[i]);
        while Assigned(Node) and (Node <> Unfiltered[i]) do begin
          IsFiltered[Node] := False;
          Node := GetPrevious(Node);
        end;
      end;

      if cbViewFilterKeepSiblings.Checked then begin
        Node := Unfiltered[i];
        if Assigned(Node.Parent) then begin
          Node := Node.Parent.FirstChild;
          while Assigned(Node) do begin
            IsFiltered[Node] := False;
            Node := GetNextSibling(Node);
          end;
        end;
      end;

      if cbViewFilterKeepParentsSiblings.Checked then begin
        Node := NodeParent[Unfiltered[i]];
        if Assigned(Node) and Assigned(Node.Parent) then begin
          Node := Node.Parent.FirstChild;
          while Assigned(Node) do begin
            IsFiltered[Node] := False;
            Node := GetNextSibling(Node);
          end;
        end;
      end;
    end;
  end;
end;

var
  LastHelpClick: TDateTime;

procedure TfrmMain.bnHelpClick(Sender: TObject);
begin
  if Now - LastHelpClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbHelpUrl), '', '', SW_SHOWNORMAL);
    LastHelpClick := Now;
  end;
end;

var
  LastVideosClick: TDateTime;

procedure TfrmMain.bnVideosClick(Sender: TObject);
begin
  if Now - LastVideosClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbVideosUrl), '', '', SW_SHOWNORMAL);
    LastVideosClick := Now;
  end;
end;

procedure TfrmMain.bnLegendClick(Sender: TObject);
begin
  if Assigned(frmLegend) then
    frmLegend.Visible := bnLegend.Down
  else if bnLegend.Down then begin
    Application.CreateForm(TfrmLegend, frmLegend);
    frmLegend.Show;
  end;
end;

procedure TfrmMain.bnMainMenuMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
begin
  if Button = mbLeft then
    with Sender as TSpeedButton do begin
      p.X := 0;
      p.Y := Height;
      p := ClientToScreen(p);
      Down := True;
      pmuMain.Popup(p.X, p.Y);
      Abort;
    end;
end;

var
  LastNexusModsClick: TDateTime;

procedure TfrmMain.bnNexusModsClick(Sender: TObject);
var
  Dummy: Boolean;
begin
  if Now - LastNexusModsClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbNexusModsUrl), '', '', SW_SHOWNORMAL);
    LastNexusModsClick := Now;
  end;
  jbhNexusModsCloseBtnClick(Sender, Dummy);
end;

var
  LastGitHubClick: TDateTime;

procedure TfrmMain.bnGitHubClick(Sender: TObject);
var
  Dummy: Boolean;
begin
  if Now - LastGitHubClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbGitHubUrl), '', '', SW_SHOWNORMAL);
    LastGitHubClick := Now;
  end;
  jbhGitHubCloseBtnClick(Sender, Dummy);
end;

var
  LastDiscordClick: TDateTime;

procedure TfrmMain.bnDiscordClick(Sender: TObject);
begin
  if Now - LastDiscordClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbDiscordUrl), '', '', SW_SHOWNORMAL);
    LastDiscordClick := Now;
  end;
end;

var
  LastPatreonClick: TDateTime;

procedure TfrmMain.bnPatreonClick(Sender: TObject);
begin
  if Now - LastPatreonClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbPatreonUrl), '', '', SW_SHOWNORMAL);
    LastPatreonClick := Now;
  end;
  if Assigned(Settings) then begin
    Settings.WriteInteger('Patreon', 'SnoozeCounter', 30);
    Settings.WriteInteger('Patreon', 'SnoozeDate', Trunc(Now));
    Settings.UpdateFile;
  end;
end;

var
  LastKoFiClick: TDateTime;

procedure TfrmMain.bnKoFiClick(Sender: TObject);
begin
  if Now - LastKoFiClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbKoFiUrl), '', '', SW_SHOWNORMAL);
    LastKoFiClick := Now;
  end;
  if Assigned(Settings) then begin
    Settings.WriteInteger('KoFi', 'SnoozeCounter', 30);
    Settings.WriteInteger('KoFi', 'SnoozeDate', Trunc(Now));
    Settings.UpdateFile;
  end;
end;

var
  LastPayPalClick: TDateTime;

procedure TfrmMain.bnPayPalClick(Sender: TObject);
begin
  if Now - LastPayPalClick > 1/24/60/60 then begin
    ShellExecute(Handle, 'open', PChar(wbPayPalUrl), '', '', SW_SHOWNORMAL);
    LastPayPalClick := Now;
  end;
end;

procedure TfrmMain.mniNavApplyScriptClick(Sender: TObject);
var
  ScriptName: string;
  Scr: string;
begin
  with TfrmScript.Create(Self) do try
    Path := wbScriptsPath;
    LastUsedScript := Settings.ReadString('View', 'LastUsedScript', '');
    chkScriptsSubDir.Checked := Settings.ReadBool('View', 'IncludeScriptsFromSubDir', False);
    if ShowModal <> mrOK then
      Exit;
    Scr := Script;
    ScriptName := LastUsedScript;
    Settings.WriteString('View', 'LastUsedScript', LastUsedScript);
    Settings.WriteBool('View', 'IncludeScriptsFromSubDir', chkScriptsSubDir.Checked);
    Settings.UpdateFile;
    CreateActionsForScripts;
  finally
    Free;
  end;
  ApplyScript(ScriptName, Scr, Sender = mniRefByApplyScript);
end;

procedure TfrmMain.CreateActionsForScripts;
const
  HotkeyToken = 'Hotkey: ';
var
  scr, s               : string;
  F                    : TSearchRec;
  slScript             : TStringList;
  i                    : integer;
  ShortCut             : TShortCut;
  Action               : TAction;
begin
  if not Assigned(ScriptHotkeys) then
    ScriptHotkeys := TStringList.Create;

  ScriptHotkeys.Clear;
  for i := Pred(ActionList1.ActionCount) downto 0 do
    if ActionList1.Actions[i].Tag > 0 then
      ActionList1.Actions[i].Free;

  if FindFirst(wbScriptsPath + '*.pas', faAnyFile, F) = 0 then try
    slScript := TStringList.Create;
    repeat
      scr := wbScriptsPath + F.Name;
      slScript.LoadFromFile(scr);
      for i := 0 to Pred(slScript.Count) do begin
        s := Trim(slScript[i]);
        if SameText(Copy(s, 1, Length(HotkeyToken)), HotkeyToken) then begin
          s := Copy(s, Succ(Length(HotkeyToken)), Length(s));
          ShortCut := TextToShortCut(s);
          if (ShortCut <> 0) and (ScriptHotkeys.IndexOfObject(TObject(ShortCut)) = -1) then begin
            Action := TAction.Create(Self);
            Action.ActionList := ActionList1;
            Action.OnExecute := acScriptExecute;
            Action.ShortCut := ShortCut;
            ScriptHotkeys.AddObject(scr, TObject(ShortCut));
            Action.Tag := ScriptHotkeys.Count;
          end;
          Break;
        end;
      end;
    until FindNext(F) <> 0;
  finally
    FindClose(F);
    FreeAndNil(slScript);
  end;
end;

procedure TfrmMain.mniViewHideNoConflictClick(Sender: TObject);
begin
  mniViewHideNoConflict.Checked := not mniViewHideNoConflict.Checked;
  HideNoConflict := mniViewHideNoConflict.Checked;
  ResetActiveTree;
  Settings.WriteBool('View', 'HodeNoConflict', HideNoConflict);
  Settings.UpdateFile;
end;

procedure TfrmMain.mniViewStickAutoClick(Sender: TObject);
begin
  if not mniViewStickAuto.Checked then
    StickViewNodeLabel := '*'
  else
    StickViewNodeLabel := '';

  Settings.WriteString('View', 'StickViewNodeLabel', StickViewNodeLabel);
  Settings.UpdateFile;
end;

procedure TfrmMain.mniViewStickSelectedClick(Sender: TObject);
begin
  if not mniViewStickSelected.Checked then
    StickViewNodeLabel := GetViewNodePositionLabel(vstViewFocusedNode)
  else
    StickViewNodeLabel := '';

  Settings.WriteString('View', 'StickViewNodeLabel', StickViewNodeLabel);
  Settings.UpdateFile;
end;

procedure TfrmMain.mniViewModGroupsReloadClick(Sender: TObject);
var
  WasModGroupsExist: Boolean;
begin
  with TfrmModGroupSelect.Create(Self) do try
    wbReloadModGroups;
    wbModGroupsByName(False).ShowValidationMessages;
    AllModGroups := wbModGroupsByName;
    LoadModGroupsSelection(AllModGroups);
    Caption := 'Reloading ModGroups - Which ModGroups do you want to activate?';
    PresetCategory := 'ActiveModGroups';
    if (Length(AllModGroups) < 1) or (ShowModal = mrOk) then begin
      SaveModGroupsSelection(SelectedModGroups);
      WasModGroupsExist := ModGroupsExist;
      ModGroupsExist := SelectedModGroups.Activate;
      if WasModGroupsExist or ModGroupsExist then begin
        ModGroupsEnabled := ModGroupsExist;
        ResetAllConflict;
        PostResetActiveTree;
        InvalidateElementsTreeView(NoNodes);
      end;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.mniViewMoveDownClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      LockProcessMessages;
      try
        Element.MoveDown;
        ViewFocusedElement := Element;
        EditFocusedViewElement := False;
        ResetActiveTree;
      finally
        UnLockProcessMessages;
      end;
    end;
  end;
end;

procedure TfrmMain.mniViewMoveUpClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      LockProcessMessages;
      try
        Element.MoveUp;
        ViewFocusedElement := Element;
        EditFocusedViewElement := False;
        ResetActiveTree;
      finally
        UnlockProcessMessages;
      end;
    end;
  end;
end;

procedure AfterCopyDisable(const aElement: IwbElement);
var
  MainRecord: IwbMainRecord;
begin
  if Supports(aElement, IwbMainRecord, MainRecord) then
    MainRecord.IsInitiallyDisabled := True;
end;

procedure TfrmMain.mniRefByCompareSelectedClick(Sender: TObject);
var
  MainRecords: TDynMainRecords;
begin
  MainRecords := GetRefBySelectionAsMainRecords;

  if Length(MainRecords) < 2 then
    Exit;

  pgMain.ActivePage := tbsView;
  DoProcessMessages;
  DoSetActiveRecord(MainRecords);
end;

procedure TfrmMain.mniRefByCopyDisabledOverrideIntoClick(Sender: TObject);
var
  Elements                    : TDynElements;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  Elements := GetRefBySelectionAsElements;

  CopyInto(
    False,
    False,
    False,
    False,
    False,
    Elements,
    AfterCopyDisable);

  vstNav.Invalidate;
end;

procedure TfrmMain.mniRefByCopyIntoClick(Sender: TObject);
var
  Elements                    : TDynElements;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  Elements := GetRefBySelectionAsElements;

  CopyInto(
    Sender = mniRefByCopyAsNewInto,
    False,
    False,
    (Sender = mniRefByDeepCopyOverrideInto) or (Sender = mniRefByDeepCopyOverrideIntoWithOverwriting),
    (Sender = mniRefByCopyOverrideIntoWithOverwriting) or (Sender = mniRefByDeepCopyOverrideIntoWithOverwriting),
    Elements);

  vstNav.Invalidate;
end;

procedure TfrmMain.mniRefByMarkModifiedClick(Sender: TObject);
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;
  if not EditWarn then
    Exit;

  UserWasActive := True;

  PerformLongAction('Mark Modified', '', procedure
  var
    MainRecords                 : TDynMainRecords;
    i                           : Integer;
  begin
    MainRecords := GetRefBySelectionAsMainRecords;
    for i := Low(MainRecords) to High(MainRecords) do
      MainRecords[i].MarkModifiedRecursive(AllElementTypes);
    MainRecords := nil;
  end);

  vstNav.Invalidate;
end;

procedure TfrmMain.mniRefByRemoveClick(Sender: TObject);
var
  MainRecords                 : TDynMainRecords;
  MainRecord                  : IwbMainRecord;
  GroupRecord                 : IwbGroupRecord;
  i                           : Integer;
  lActiveRecord               : IwbMainRecord;
  Container                   : IwbContainerElementRef;
  Node                        : PVirtualNode;
  DialogResult                : Integer;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  MainRecords := GetRefBySelectionAsMainRecords;

  if Length(MainRecords) < 1 then
    Exit;

  if Length(MainRecords) = 1 then
    DialogResult := MessageDlg('Are you sure you want to permanently remove ' + MainRecords[0].Name + ' from file "' + MainRecords[0]._File.FileName + '"?', mtConfirmation, [mbYes, mbNo], 0)
  else
    DialogResult := MessageDlg('Are you sure you want to permanently remove the '+Length(MainRecords).ToString+' selected records from their containing file(s)?', mtConfirmation, [mbYes, mbNo], 0);

  if DialogResult <> mrYes then
    Exit;

  lActiveRecord := ActiveRecord;

  vstNav.BeginUpdate;
  try
    for i := Low(MainRecords) to High(MainRecords) do begin
      MainRecord := MainRecords[i];
      if Assigned(MainRecord) then begin
        if not Supports(MainRecord.Container, IwbContainerElementRef, Container) then
          Container := nil;

        CheckHistoryRemove(BackHistory, MainRecord);
        CheckHistoryRemove(ForwardHistory, MainRecord);

        if MainRecord.Equals(lActiveRecord) then
          lActiveRecord := nil;

        GroupRecord := MainRecord.ChildGroup;

        if not (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then begin
          Node := FindNodeForElement(MainRecord);
          if Assigned(Node) then
            vstNav.DeleteNode(Node);
          if Assigned(GroupRecord) then begin
            Node := FindNodeForElement(GroupRecord);
            if Assigned(Node) then
              vstNav.DeleteNode(Node);
          end;
        end;

        MainRecord.Remove;
        if Assigned(GroupRecord) then
          GroupRecord.Remove;
        MainRecord := nil;
      end;
    end;

    NavUpdate(True);

  finally
    vstNav.EndUpdate;
  end;

  MainRecords := nil;

  ActiveRecord := nil;
  DoSetActiveRecord(lActiveRecord);

  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mmoMessagesDblClick(Sender: TObject);
var
  i: Integer;
  s: string;
  Key: Word;
begin
  s := Trim(mmoMessages.SelText);
  if Length(s) < 8 then
    Exit;

  i := Pos('[', s);
  if i > 1 then
    Delete(s, 1, Pred(i));

  i := Pos(']', s);
  if i > 0 then
    Delete(s, Succ(i), High(Integer));

  if (s[1] = '[') and (s[Length(s)] = ']') then
    s := Copy(s, 2, Length(s) - 2);
  if Length(s) < 8 then
    Exit;
  if s[5] = ':' then
    s := Copy(s, 6, High(Integer));
  if Length(s) <> 8 then
    Exit;
  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;
  edFormIDSearch.Text := s;
  Key := VK_RETURN;
  edFormIDSearchKeyDown(edFormIDSearch, Key, []);
end;

procedure TfrmMain.mniMessagesClearClick(Sender: TObject);
begin
  mmoMessages.Clear;
end;

procedure TfrmMain.mniMessagesSaveSelectedClick(Sender: TObject);
var
  s: string;
begin
  s := Trim(mmoMessages.SelText);
  if s = '' then
    Exit;

  with TStringList.Create do try
    Text := s;
    with TSaveDialog.Create(nil) do try
      Title := 'Save selected text';
      Filter := 'Text files (*.txt)|*.txt';
      InitialDir := wbProgramPath;
      if Execute then begin
        s := FileName;
        if ExtractFileExt(s) = '' then
          s := s + '.txt';
        SaveToFile(FileName);
      end;
    finally
      Free;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.mniModGroupsAbleClick(Sender: TObject);
var
  WasModGroupsEnabled: Boolean;
begin
  (Sender as TMenuItem).Checked := True;
  WasModGroupsEnabled := ModGroupsEnabled;
  ModGroupsEnabled := ModGroupsExist and mniModGroupsEnabled.Checked;
  if WasModGroupsEnabled <> ModGroupsEnabled then begin
    ResetAllConflict;
    PostResetActiveTree;
    InvalidateElementsTreeView(NoNodes);
  end;
end;

procedure TfrmMain.mniModGroupsClick(Sender: TObject);
begin
  mniModGroupsEnabled.Visible := ModGroupsExist;
  mniModGroupsDisabled.Visible := ModGroupsExist;
  mniModGroupsEnabled.Checked := ModGroupsEnabled and ModGroupsExist;
  mniModGroupsDisabled.Checked := not mniModGroupsEnabled.Checked;
end;

procedure TfrmMain.mniMasterAndLeafsClick(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  if OnlyShowMasterAndLeafs <> mniMasterAndLeafsEnabled.Checked then begin
    OnlyShowMasterAndLeafs := mniMasterAndLeafsEnabled.Checked;
    ResetAllConflict;
    PostResetActiveTree;
    InvalidateElementsTreeView(NoNodes);
  end;
end;

procedure TfrmMain.mniNavAddClick(Sender: TObject);
var
  FocusedNode                 : PVirtualNode;
  NodeData                    : PNavNodeData;
  Container                   : IwbContainerElementRef;
  Element                     : IwbElement;
  MainRecord                  : IwbMainRecord;
begin
  FocusedNode := vstNav.FocusedNode;
  NodeData := vstNav.GetNodeData(FocusedNode);
  if Assigned(NodeData) and Supports(NodeData.Element, IwbContainerElementRef, Container) then begin
    Element := Container.Add(StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]), False);
    if Assigned(Element) then begin
      NavFocusedElement := Element;
      NavUpdate(True);
      if Supports(Element, IwbMainRecord, MainRecord) then
        DoSetActiveRecord(MainRecord)
      else
        DoSetActiveRecord(nil);
    end;
  end;
end;

function StrContaines(const aStr, aSubStr: string) : Boolean;
begin
  Result := (Pos(AnsiUpperCase(aSubStr), AnsiUpperCase(aStr)) > 0);
end;

procedure TfrmMain.mniNavBanditFixClick(Sender: TObject);
var
  i, j              : Integer;
  MMMESM            : Integer;
  CSNPC             : IwbMainRecord;
  CSNPCBoss         : IwbMainRecord;
  CSNPCBandit       : IwbMainRecord;
  CSNPCBanditBoss   : IwbMainRecord;
  CSNPCID           : string;
  CSNPCBossID       : string;
  CSNPCBanditID     : string;
  CSNPCBanditBossID : string;
  Group             : IwbContainerElementRef;
  MainRecord        : IwbMainRecord;
  MainRecordRef     : IwbContainerElementRef;
  s                 : string;
begin
  MMMESM := -1;
  for i := Low(Files) to High(Files) do
    if SameText(Files[i].FileName, 'Mart''s Monster Mod.esm') then begin
      MMMESM := i;
      Break
    end;
  if MMMESM < 1 then
    raise Exception.Create('Can''t find Mart''s Monster Mod.esm');

  if Supports(Files[MMMESM].GroupBySignature['SCPT'], IwbContainerElementRef, Group) then
    for j := 0 to Pred(Group.ElementCount) do
      if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then
        if SameText(MainRecord.EditorID,'CSNPC') then
          CSNPC := MainRecord
        else if SameText(MainRecord.EditorID,'CSNPCBoss') then
          CSNPCBoss := MainRecord
        else if SameText(MainRecord.EditorID,'CSNPCBandit') then
          CSNPCBandit := MainRecord
        else if SameText(MainRecord.EditorID,'CSNPCBanditBoss') then
          CSNPCBanditBoss := MainRecord;

  if not Assigned(CSNPC) then
    raise Exception.Create('Can''t find CSNPC script');
  if not Assigned(CSNPC) then
    raise Exception.Create('Can''t find CSNPCBoss script');
  if not Assigned(CSNPC) then
    raise Exception.Create('Can''t find CSNPCBandit script');
  if not Assigned(CSNPC) then
    raise Exception.Create('Can''t find CSNPCBanditBoss script');

  CSNPCID           := CSNPC.LoadOrderFormID.ToString(False);
  CSNPCBossID       := CSNPCBoss.LoadOrderFormID.ToString(False);
  CSNPCBanditID     := CSNPCBandit.LoadOrderFormID.ToString(False);
  CSNPCBanditBossID := CSNPCBanditBoss.LoadOrderFormID.ToString(False);

  for i := MMMESM to High(Files) do
    if (i = MMMESM) or Files[i].HasMaster('Mart''s Monster Mod.esm') then
      if Supports(Files[i].GroupBySignature['NPC_'], IwbContainerElementRef, Group) then
        for j := 0 to Pred(Group.ElementCount) do
          if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then
            if not StrContaines(MainRecord.EditorID, 'Adven') and
               (
                 StrContaines(MainRecord.EditorID, 'Bandit') or
                 StrContaines(MainRecord.EditorID, 'Maraud') or
                 StrContaines(MainRecord.EditorID, 'Raider')
               ) then begin
              MainRecordRef := MainRecord as IwbContainerElementRef;

              s := Trim(MainRecordRef.ElementEditValues['SCRI']);
              if s = '' then
                if StrContaines(MainRecord.EditorID, 'Boss') then
                  s := CSNPCBanditBossID
                else
                  s := CSNPCBanditID
              else if s = CSNPCID then
                s := CSNPCBanditID
              else if s = CSNPCBossID then
                s := CSNPCBanditBossID
              else
                Continue;

              MainRecordRef.ElementEditValues['SCRI'] := s;
            end;
end;

procedure TfrmMain.mniNavBatchChangeReferencingRecordsClick(Sender: TObject);

  function FindFile(const s: String): IwbFile;
  var
    i: Integer;
  begin
    for i := Low(Files) to High(Files) do
      if AnsiSameText(Files[i].FileName, s) then begin
        Result := Files[i];
        Exit;
      end;
    Result := nil;
  end;

var
  _File                       : IwbFile;
  NodeData                    : PNavNodeData;
  CSV, Line                   : TStringList;
  i, j, k, l                  : Integer;
  s                           : string;
  OldMaster                   : IwbFile;
  NewMaster                   : IwbFile;
  OldRecord                   : IwbMainRecord;
  NewRecord                   : IwbMainRecord;
  RefRecord                   : IwbMainRecord;
  ReferencedBy                : TDynMainRecords;
  NewMasters                  : TStringList;
  ReplaceList                 : array of record
    rlOldRecord: IwbMainRecord;
    rlNewRecord: IwbMainRecord;
    rlReferencedBy : TDynMainRecords;
  end;
begin
  ReplaceList := nil;
  l := 0;

  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if not Assigned(NodeData) then
    Exit;
  if not Supports(NodeData.Element, IwbFile, _File) then
    Exit;

  with odCSV do begin
    FileName := '';
    InitialDir := wbDataPath;
    if not Execute then
      Exit;
  end;

  NewMasters := TStringList.Create;
  try
    NewMasters.Sorted := True;
    NewMasters.Duplicates := dupError;

    CSV := TStringList.Create;
    try
      CSV.LoadFromFile(odCSV.FileName);
      Line := TStringList.Create;
      try
        SetLength(ReplaceList, CSV.Count);
        for i := 1 to Pred(CSV.Count) do begin //ignore first line
          Line.CommaText := CSV[i];
          if Line.Count <> 7 then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': 7 values expected but '+IntToStr(Line.Count)+' found.');
            Continue;
          end;

          s := Trim(Line[1]);
          OldMaster := FindFile(s);
          if not Assigned(OldMaster) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old Master "'+s+'" is not loaded.');
            Continue;
          end else if OldMaster.LoadOrder < 0 then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old Master "'+s+'" does not have a load order assigned.');
            Continue;
          end;

          s := Trim(Line[5]);
          NewMaster := FindFile(s);
          if not Assigned(NewMaster) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': New Master "'+s+'" is not loaded.');
            Continue;
          end else if NewMaster.LoadOrder < 0 then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': New Master "'+s+'" does not have a load order assigned.');
            Continue;
          end;

          s := Trim(Line[2]);
          j := StrToIntDef(s, -1);
          if (j < 0) or (j > $FFFFFF) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old FormID "'+s+'" is not in the valid range.');
            Continue;
          end;
          OldRecord := OldMaster.RecordByFormID[TwbFormID.FromCardinal(j).ChangeFileID(OldMaster.FileFileID[True]), True, True];
          if not Assigned(OldRecord) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old Record with FormID "'+s+'" was not found in old Master "'+OldMaster.FileName+'".');
            Continue;
          end;

          s := Trim(Line[6]);
          j := StrToIntDef(s, -1);
          if (j < 0) or (j > $FFFFFF) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': New FormID "'+s+'" is not in the valid range.');
            Continue;
          end;
          NewRecord := NewMaster.RecordByFormID[TwbFormID.FromCardinal(j).ChangeFileID(NewMaster.FileFileID[True]), True, True];
          if not Assigned(NewRecord) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': New Record with FormID "'+s+'" was not found in new Master "'+NewMaster.FileName+'".');
            Continue;
          end;

          if OldRecord.Equals(NewRecord) then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old and new Record are identical".');
            Continue;
          end;

          s := Trim(Line[0]);
          if not SameText(OldRecord.Signature, s) then
            AddMessage('Warning line '+IntToStr(i+1)+': Old Record do not have expected Signature ("'+OldRecord.Signature+'" vs. "'+s+'")".');
          if not SameText(NewRecord.Signature, s) then
            AddMessage('Warning line '+IntToStr(i+1)+': New Record do not have expected Signature ("'+NewRecord.Signature+'" vs. "'+s+'")".');

          s := Trim(Line[3]);
          if not SameText(OldRecord.EditorID, s) then
            AddMessage('Warning line '+IntToStr(i+1)+': Old Record does not have expected EditorID ("'+OldRecord.EditorID+'" vs. "'+s+'")".');

          s := Trim(Line[4]);
          if not SameText(NewRecord.EditorID, s) then
            AddMessage('Warning line '+IntToStr(i+1)+': New Record does not have expected EditorID ("'+NewRecord.EditorID+'" vs. "'+s+'")".');

          ReferencedBy := nil;
          SetLength(ReferencedBy, OldRecord.ReferencedByCount);
          k := 0;

          for j := 0 to Pred(OldRecord.ReferencedByCount) do begin
            RefRecord := OldRecord.ReferencedBy[j];
            if _File.Equals(RefRecord._File) then begin
              ReferencedBy[k] := RefRecord;
              Inc(k);
            end;
          end;

          SetLength(ReferencedBy, k);

          if k < 1 then begin
            AddMessage('Skipping line '+IntToStr(i+1)+': Old Record "'+OldRecord.Name+'" is not referenced by any record in file "'+_File.Name+'".');
            Continue;
          end;

          with ReplaceList[l] do begin
            rlOldRecord := OldRecord;
            rlNewRecord := NewRecord;
            rlReferencedBy := ReferencedBy;
            OldRecord := nil;
            NewRecord := nil;
            RefRecord := nil;
            ReferencedBy := nil;
          end;
          Inc(l);

          if not NewMaster.Equals(_File) then
            if not NewMasters.Find(NewMaster._File.FileName, k) then
              NewMasters.AddObject(NewMaster._File.FileName, Pointer(NewMaster._File));
        end;
      finally
        FreeAndNil(Line);
      end;
    finally
      FreeAndNil(CSV);
    end;
    SetLength(ReplaceList, l);

    if l > 0 then
      if not EditWarn then
        Exit;

    if AddRequiredMasters(NewMasters, _File) then
      for i := 0 to Pred(l) do with ReplaceList[i] do begin
        ShowChangeReferencedBy(rlOldRecord.LoadOrderFormID, rlNewRecord.LoadOrderFormID, rlReferencedBy, True);
        RefRecord := _File.RecordByFormID[rlOldRecord.LoadOrderFormID, False, True];
        if Assigned(RefRecord) and _File.Equals(RefRecord._File) then begin
          AddMessage('Changing FormID ['+RefRecord.LoadOrderFormID.ToString(True)+'] to ['+rlNewRecord.LoadOrderFormID.ToString(True)+']');
          RefRecord.LoadOrderFormID := rlNewRecord.LoadOrderFormID;
        end;
      end;
  finally
    NewMasters.Free;
  end;
end;

procedure TfrmMain.mniNavBuildReachableClick(Sender: TObject);
begin
  PerformLongAction('Building reachable information', '', procedure
  var
    i       : Integer;
    _File   : IwbFile;
    Modules : TwbModuleInfos;
  begin
    Modules := wbModulesByLoadOrder.FilteredByFlag(mfHasFile);
    for i := Low(Modules) to High(Modules) do begin
      _File := Modules[i]._File;
      if not (csRefsBuild in _File.ContainerStates) then begin
        wbCurrentAction := 'Building reference information for ' + _File.Name;
        wbProgress(wbCurrentAction);
        DoProcessMessages;
        _File.BuildRef;
      end;
    end;
    for i := Low(Modules) to High(Modules) do begin
      _File := Modules[i]._File;
      _File.ResetReachable;
    end;
    for i := Low(Modules) to High(Modules) do begin
      _File := Modules[i]._File;
      wbCurrentAction := 'Building reachable information for ' + _File.Name;
      wbProgress(wbCurrentAction);
      DoProcessMessages;
      _File.BuildReachable;
    end;
    ReachableBuild := True;
  end);
end;

procedure TfrmMain.mniNavBuildRefClick(Sender: TObject);
begin
  with TfrmModuleSelect.Create(nil) do try
    Caption := 'Build reference information for:';

    AllModules := wbModulesByLoadOrder.FilteredByFlag(mfValid).FilteredBy(function(a: PwbModuleInfo): Boolean
      begin
        Result := Assigned(a.miFile);
        if Result then
          Result := not (csRefsBuild in a._File.ContainerStates);
      end);

    if Length(AllModules) < 1 then begin
      ShowMessage('There are no files without reference information');
      Exit;
    end;

    FilterFlag := mfHasFile;
    SelectFlag := mfTagged;
    AllModules.ExcludeAll(mfTagged);
    AllowCancel;

    if ShowModal <> mrOK then
      Exit;

    if Length(SelectedModules) < 1 then
      Exit;

    PerformLongAction('Building reference information', '', procedure
    var
      i: Integer;
      _File                       : IwbFile;
    begin
      for i := Low(SelectedModules) to High(SelectedModules) do begin
        _File := SelectedModules[i]._File;
        wbCurrentAction := 'Building reference information for ' + _File.Name;
        wbProgress(wbCurrentAction);
        DoProcessMessages;
        _File.BuildRef;
      end;
    end);

  finally
    Free;
  end;
end;

procedure TfrmMain.mniNavCellChild(Sender: TObject);
var
  SelectedNodes               : TNodeArray;
  CellNodes                   : TNodeArray;
  Node                        : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecords                 : array of IwbMainRecord;
  MainRecord                  : IwbMainRecord;
  i, j ,k                     : Integer;
  FoundIt                     : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  SelectedNodes := vstNav.GetSortedSelection(True);
  if Length(SelectedNodes) < 1 then
    Exit;

  CellNodes := nil;
  k := 0;
  SetLength(MainRecords, Length(SelectedNodes));
  for i := Low(SelectedNodes) to High(SelectedNodes) do begin
    Node := SelectedNodes[i];
    NodeData := vstNav.GetNodeData(Node);
    if not Assigned(NodeData) then
      Continue;
    if not Supports(NodeData.Element, IwbMainRecord, MainRecords[k]) then
      Continue;
    if (MainRecords[k].Signature <> 'REFR') then
      Continue;

    Inc(k);

    if Node = vstNav.RootNode then
      Continue;
    Node := Node.Parent;
    if Node = vstNav.RootNode then
      Continue;
    Node := Node.Parent;
    if Node = vstNav.RootNode then
      Continue;
    NodeData := vstNav.GetNodeData(Node);
    if not Assigned(NodeData) then
      Continue;
    if not Supports(NodeData.Element, IwbMainRecord, MainRecord) then
      Continue;
    if MainRecord.Signature <> 'CELL' then
      Continue;

    FoundIt := False;
    for j := Low(CellNodes) to High(CellNodes) do
      if CellNodes[j] = Node then begin
        FoundIt := True;
        Break;
      end;
    if FoundIt then
      Continue;
    SetLength(CellNodes, Succ(Length(CellNodes)));
    CellNodes[High(CellNodes)] := Node;
  end;
  SetLength(MainRecords, k);

  for i := Low(MainRecords) to High(MainRecords) do begin
    MainRecord := MainRecords[i];
    if Sender = mniNavCellChildTemp then
      MainRecord.IsPersistent := False
    else if Sender = mniNavCellChildPers then
      MainRecord.IsPersistent := True
    else if Sender = mniNavCellChildNotVWD then
      MainRecord.IsVisibleWhenDistant := False
    else if Sender = mniNavCellChildVWD then
      MainRecord.IsVisibleWhenDistant := True;
  end;

  vstNav.ClearSelection;
  vstNav.BeginUpdate;
  try
    InvalidateElementsTreeView(SelectedNodes);
    SelectedNodes := nil;
    for i := Low(CellNodes) to High(CellNodes) do begin
      vstNav.Expanded[CellNodes[i]] := False;
      vstNav.FullExpand(CellNodes[i]);
    end;
    for i := Low(MainRecords) to High(MainRecords) do begin
      Node := FindNodeForElement(MainRecords[i]);
      if not Assigned(Node) then
        Continue;
      vstNav.FocusedNode := Node;
      vstNav.Selected[Node] := True;
    end;
    SelectedNodes := vstNav.GetSortedSelection(True);
    if Length(SelectedNodes) < 1 then
      Exit;
    vstNav.FocusedNode := SelectedNodes[0];
  finally
    vstNav.EndUpdate;
  end;
end;

procedure TfrmMain.mniNavChangeFormIDClick(Sender: TObject);
var
  s                           : string;
  i, j, k                     : Integer;
  NewFormID                   : TwbFormID;
  OldFormID                   : TwbFormID;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  ReferencedBy, Overrides     : TDynMainRecords;
  Nodes                       : TNodeArray;
  OldFileID                   : TwbFileID;
  NewFileID                   : TwbFileID;
  AnyErrors                   : Boolean;
  Master                      : IwbMainRecord;
  _File                       : IwbFile;
  _OldFile                    : IwbFile;
  _NewMasterFile              : IwbFile;
  FoundNone                   : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  AnyErrors := False;
  _File := nil;
  NewFormID := TwbFormID.Null;
  Nodes := vstNav.GetSortedSelection(True);

  // renumber to destination file if several records were selected or Shift is pressed
  if (Length(Nodes) > 1) or (GetKeyState(VK_SHIFT) < 0) then begin
    NodeData := vstNav.GetNodeData(Nodes[0]);
    if not Assigned(NodeData) then
      Exit;
    if not Assigned(NodeData.Element) then
      Exit;

    if not EditWarn then
      Exit;

    with TfrmModuleSelect.Create(Self) do try
      Caption := 'Select a single target file';

      _File := NodeData.Element._File;

      AllModules := Copy(PwbModuleInfo(_File.ModuleInfo).miMasters);
      SetLength(AllModules, Succ(Length(AllModules)));
      AllModules[High(AllModules)] := _File.ModuleInfo;

      FilterFlag := mfHasFile;
      SelectFlag := mfTagged;
      AllModules.ExcludeAll(mfTagged);
      MaxSelect := 1;
      AllowCancel;

      if ShowModal <> mrOK then
        Exit;
      Assert(Length(SelectedModules)=1);
      _File := SelectedModules[0]^._File;
    finally
      Free;
    end;
  end;

  for j := Low(Nodes) to High(Nodes) do begin
    NodeData := vstNav.GetNodeData(Nodes[j]);
    if not Assigned(NodeData) then
      Continue;
    if not Assigned(NodeData.Element) then
      Continue;
    if not Supports(NodeData.Element, IwbMainRecord, MainRecord) then
      Continue;

    OldFormID := MainRecord.LoadOrderFormID;
    if not Assigned(_File) then begin

      s := OldFormID.ToString(False);
      if InputQuery('New FormID', 'Please enter the new FormID in hex. e.g. 0404CC43. The FormID needs to be a load order corrected form ID.', s) then begin

        if s = '' then begin
          s := MainRecord._File.FileFormIDtoLoadOrderFormID(MainRecord._File.NewFormID, True).ToString(False);
          if not InputQuery('New FormID generated', 'Please verify the newly generated FormID. The FormID needs to be a load order corrected form ID.', s) then
            Exit;
        end;
        NewFormID := TwbFormID.FromStr(s);
        if NewFormID.IsNull then
          raise Exception.Create('00000000 is not a valid FormID');
        if NewFormID.IsPlayer then
          raise Exception.Create('00000014 is not a valid FormID');
      end else
        Exit;

    end else begin

      OldFileID := OldFormID.FileID;
      if OldFileID = _File.LoadOrderFileID then
        Continue;
      NewFormID := _File.FileFormIDtoLoadOrderFormID(_File.NewFormID, True);

    end;

    if NewFormID = OldFormID then
      Continue;

    pgMain.ActivePage := tbsMessages;

    AddMessage('Changing FormID ['+OldFormID.ToString(True)+'] in file "'+MainRecord._File.FileName+'" to ['+NewFormID.ToString(True)+']');

    try
      MainRecord._File.LoadOrderFormIDtoFileFormID(NewFormID, True);
    except
      NewFileID := NewFormID.FileID;
      _OldFile := MainRecord._File;
      _NewMasterFile := nil;
      for i := Low(Files) to High(Files) do begin
        if Files[i].LoadOrder >= _OldFile.LoadOrder then
          Break;
        if Files[i].LoadOrderFileID = NewFileID then begin
          _NewMasterFile := Files[i];
          Break;
        end;
      end;
      if not Assigned(_NewMasterFile) then
        raise;
      if not AddRequiredMaster(_NewMasterFile, _OldFile) then
        raise;
    end;

    Master := MainRecord.MasterOrSelf;
    SetLength(ReferencedBy, Master.ReferencedByCount);
    for i := 0 to Pred(Master.ReferencedByCount) do
      ReferencedBy[i] := Master.ReferencedBy[i];

    k := -1;
    AddMessage('Record is referenced by '+IntToStr(Length(ReferencedBy))+' other record(s)');
    try
      if Master.OverrideCount <> 0 then begin
        // store overrides since they change on the go when renumbering FormIDs
        SetLength(Overrides, Master.OverrideCount);
        for i := 0 to Pred(Master.OverrideCount) do begin
          Overrides[i] := Master.Overrides[i];
          // index of the focused record in overrides list
          if Overrides[i].Equals(MainRecord) then k := i;
        end;
        // if it is not the last override and user confirms
        if (k < Pred(Length(Overrides))) and (MessageDlg('Record '+MainRecord.Name+' has later overrides, update them too?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
          // happens when master record is selected which is not in the list of overrides, renumber all overrides
          if k = -1 then k := 0;
        end else
          k := -1;
      end;

      if MainRecord.LoadOrderFormID <> NewFormID then begin
        MainRecord.LoadOrderFormID := NewFormID;
        AddMessage('Renumbered ' + MainRecord.FullPath);

        if k >= 0 then
          for i := k to Pred(Length(Overrides)) do try
             Overrides[i].LoadOrderFormID := NewFormID;
             AddMessage('Renumbered ' + Overrides[i].FullPath);
          except
            on E: Exception do begin
              AddMessage('Error renumbering ' + Overrides[i].FullPath + ': ' + E.Message);
              AnyErrors := True;
            end;
          end;
      end;

      NodeData.ConflictAll := caUnknown;
      NodeData.ConflictThis := ctUnknown;
      NodeData.Flags := [];
      vstNav.InvalidateNode(vstNav.FocusedNode);

      if Length(ReferencedBy) > 0 then
        ShowChangeReferencedBy(OldFormID, NewFormID, ReferencedBy, Assigned(_File) );
    except
      on E: Exception do begin
        AddMessage('Error: ' + E.Message);
        AnyErrors := True;
      end;
    end;
  end;
  if AnyErrors then begin
    pgMain.ActivePage := tbsMessages;
    AddMessage('!!! Errors have occured. It is highly recommended to exit without saving as partial changes might have occured !!!');
  end;
end;

procedure TfrmMain.mniViewEditClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  EditValue                   : string;
  NamedDef                    : IwbNamedDef;
  IntegerDef                  : IwbIntegerDef;
  Flags                       : IwbFlagsDef;
  i, StringID                 : Integer;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      EditValue := Element.EditValue;

      // for Flags, try to get the enclosed value
      if Supports(Element.Def, IwbSubRecordDef) then
        NamedDef := (Element.Def as IwbSubrecordDef).Value
      else
        NamedDef := Element.Def;

      // flags editor
      if Supports(NamedDef, IwbIntegerDef, IntegerDef) and
        Supports(IntegerDef.Formater[Element], IwbFlagsDef, Flags) then begin

        with TfrmFileSelect.Create(Self) do try
          Caption := 'Edit Value';

          for i := 0 to Pred(Flags.FlagCount) do begin
            if Flags.FlagDontShow[Element, i] then
              CheckListBox1.AddItem('', nil)
            else
              CheckListBox1.AddItem(Flags.Flags[i, False], nil);
            CheckListBox1.Checked[i] := (i < Length(EditValue)) and (EditValue[i+1] = '1');
          end;

          if ShowModal = mrOK then begin
            EditValue := StringOfChar('0', CheckListBox1.Items.Count);
            for i := 0 to Pred(CheckListBox1.Items.Count) do begin
              if CheckListBox1.Checked[i] then
                EditValue[i+1] := '1';
            end;
          end;
        finally
          Free;
        end;

      end

      // localization editor
      else if Element._File.IsLocalized and Assigned(Element.ValueDef) and (Element.ValueDef.DefType = dtLString) then begin
        with TfrmLocalization.Create(Self) do try
          wbLocalizationHandler.NoTranslate := true;
          StringID := StrToInt64Def('$' + Element.Value, 0);
          wbLocalizationHandler.NoTranslate := false;
          EditValue(Element._File.FileName, StringID);
          ShowModal;
        finally
          wbLocalizationHandler.NoTranslate := false;
          Free;
        end;
        vstView.Invalidate;
        Exit;
      end

      // string editor
      else if not InputQuery('Edit Value', 'Please change the value:', EditValue) then
        Exit;

      if wbConvertIntFormID and Element.CanContainFormIDs then
      begin
        var tmp: Integer;
        if not StartsText('0', EditValue) and not StartsText('0x', EditValue) then
          if TryStrToInt(EditValue, tmp) then
            EditValue := IntToHex(tmp, 8);

        if StartsText('0x', EditValue) then
          EditValue := ReplaceText(EditValue, '0x', '');
      end;

      Element.EditValue := EditValue;
      ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
      ViewFocusedElement := Element;
      EditFocusedViewElement := False;
      Element := nil;
      PostResetActiveTree;
      InvalidateElementsTreeView(NoNodes);
    end;
  end;
end;

procedure TfrmMain.mniViewSetToDefaultClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      Element.SetToDefault;
      ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
      ViewFocusedElement := Element;
      EditFocusedViewElement := False;
      Element := nil;
      PostResetActiveTree;
      InvalidateElementsTreeView(NoNodes);
    end;
  end;
end;

procedure TfrmMain.mniViewHeaderCopyIntoClick(Sender: TObject);
var
  Column                      : TColumnIndex;
  MainRecord                  : IwbMainRecord;
  Master                      : IwbMainRecord;
  AsNew                       : Boolean;
  AsWrapper                   : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  AsNew := Sender = mniViewHeaderCopyAsNewRecord;
  AsWrapper := Sender = mniViewHeaderCopyAsWrapper;

  Column := vstView.Header.Columns.PopupIndex;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  if not Supports(ActiveRecords[Column].Element, IwbMainRecord, MainRecord) then
    Exit;
  if not MainRecord.CanCopy then
    Exit;

  Master := MainRecord.MasterOrSelf;

  CopyInto(
    AsNew,
    AsWrapper,
    False,
    (Sender = mniViewHeaderDeepCopyAsOverride) or (Sender = mniViewHeaderDeepCopyAsOverrideWithOverwriting),
    (Sender = mniViewHeaderCopyAsOverrideWithOverwriting) or (Sender = mniViewHeaderDeepCopyAsOverrideWithOverwriting),
    [MainRecord]
  );

  Master.ResetConflict;
  PostResetActiveTree;
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniViewHeaderHiddenClick(Sender: TObject);
var
  Column                      : TColumnIndex;
  Element                     : IwbElement;
  MainRecord                  : IwbMainRecord;
begin
  Column := vstView.Header.Columns.PopupIndex;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  Element := ActiveRecords[Column].Element;
  if not Supports(Element, IwbMainRecord, MainRecord) then
    Exit;
  if mniViewHeaderHidden.Checked then
    MainRecord.Hide
  else
    MainRecord.Show;
  PostResetActiveTree;
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniViewHeaderJumpToClick(Sender: TObject);
var
  Column                      : TColumnIndex;
  Element                     : IwbElement;
  MainRecord                  : IwbMainRecord;
begin
  Column := vstView.Header.Columns.PopupIndex;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  Element := ActiveRecords[Column].Element;
  if not Supports(Element, IwbMainRecord, MainRecord) then
    Exit;
  JumpTo(MainRecord, True);
end;

procedure TfrmMain.mniViewHeaderRemoveClick(Sender: TObject);
var
  Column                      : TColumnIndex;
  Node                        : PVirtualNode;
  Element                     : IwbElement;
  DialogResult                : Integer;
  MainRecord                  : IwbMainRecord;
  GroupRecord                 : IwbGroupRecord;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  Column := vstView.Header.Columns.PopupIndex;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  Element := ActiveRecords[Column].Element;
  if not Supports(Element, IwbMainRecord, MainRecord) then
    Exit;

  if not EditWarn then
    Exit;

  DialogResult := MessageDlg('Are you sure you want to permanently remove ' + Element.Name + ' from file "' + Element._File.FileName + '"?', mtConfirmation, [mbYes, mbNo], 0);

  if DialogResult <> mrYes then
    Exit;

  vstNav.BeginUpdate;
  try
    CheckHistoryRemove(BackHistory, MainRecord);
    CheckHistoryRemove(ForwardHistory, MainRecord);

    GroupRecord := MainRecord.ChildGroup;

    if not (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then begin
      Node := FindNodeForElement(MainRecord);
      if Assigned(Node) then
        vstNav.DeleteNode(Node);
      if Assigned(GroupRecord) then begin
        Node := FindNodeForElement(GroupRecord);
        if Assigned(Node) then
          vstNav.DeleteNode(Node);
      end;
    end;

    Element.Remove;
    if Assigned(GroupRecord) then
      GroupRecord.Remove;

    NavUpdate(True);
  finally
    vstNav.EndUpdate;
  end;

  MainRecord := ActiveRecord;
  if Element.Equals(MainRecord) then
    MainRecord := nil;
  DoSetActiveRecord(nil);

  Element := nil;

  DoSetActiveRecord(MainRecord);
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniNavGenerateLODClick(Sender: TObject);

  function IndexOf(Items: TStrings; const Item: string): integer;
  begin
    Result := Max(Items.IndexOf(item), 0);
  end;

  function ImageFormatToStr(aFormat: TImageFormat): string;
  begin
    case aFormat of
      ifR8G8B8: Result := '888';
      ifA8R8G8B8: Result := '8888';
      ifR5G6B5: Result := '565';
      ifDXT1: Result := 'DXT1';
      ifDXT3: Result := 'DXT3';
      ifDXT5: Result := 'DXT5';
      ifATI1n: Result := 'BC4';
      ifATI2n: Result := 'BC5';
    else
      Result := 'DXT5';
    end;
  end;

  function StrToImageFormat(const aName: string): TImageFormat;
  begin
    if aName = '888' then Result := ifR8G8B8 else
    if aName = '8888' then Result := ifA8R8G8B8 else
    if aName = '565' then Result := ifR5G6B5 else
    if aName = 'DXT1' then Result := ifDXT1 else
    if aName = 'DXT3' then Result := ifDXT3 else
    if aName = 'DXT5' then Result := ifDXT5 else
    if aName = 'BC4' then Result := ifATI1n else
    if aName = 'BC5' then Result := ifATI2n else
    Result := ifDXT5;
  end;

var
  Selection   : TNodeArray;
  i, j        : Integer;
  NodeData    : PNavNodeData;
  _File       : IwbFile;
  Group       : IwbContainerElementRef;
  MainRecord  : IwbMainRecord;
  Worldspaces : TDynMainRecords;
  lodTypes    : TLODTypes;
  Section     : string;
begin
  if wbIsFallout76 or wbIsStarfield then begin
    Application.MessageBox('LOD generation not supported.', 'Warning', MB_ICONINFORMATION + MB_OK);
    Exit;
  end;
  
  // called from menu, xEdit mode, worldspaces from selection
  if Assigned(Sender) then begin
    Selection := vstNav.GetSortedSelection(True);
    if Length(Selection) < 1 then
      Exit;

    Worldspaces := nil;
    for i := Low(Selection) to High(Selection) do begin
      NodeData := vstNav.GetNodeData(Selection[i]);
      if Supports(NodeData.Element, IwbFile, _File) then begin
        if Supports(_File.GroupBySignature['WRLD'], IwbContainerElementRef, Group) then begin
          for j := 0 to Pred(Group.ElementCount) do
            if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then begin
              // TES5LODGen works only for worldspaces with lodsettings file
              if (wbIsSkyrim or wbIsFallout3 or wbIsFallout4 or wbIsStarfield) and not wbContainerHandler.ResourceExists(wbLODSettingsFileName(MainRecord.EditorID)) then
                Continue;
              if Mainrecord.Signature = 'WRLD' then begin
                // do not list worldspace if Use LOD Data flag of parent world is set - FO4 has a orphaned LOD data for Diamond City
                if Mainrecord.ElementExists['Parent\WNAM'] and (Mainrecord.ElementNativeValues['Parent\PNAM\Flags'] and $2 = $2) then
                  Continue;
                SetLength(Worldspaces, Succ(Length(Worldspaces)));
                Worldspaces[High(Worldspaces)] := MainRecord;
              end;
            end;
        end;
      end;
    end;
  end

  // called manually, LODGen mode, worldspaces from all loaded plugins
  else begin
    Worldspaces := nil;
    for i := Low(Files) to High(Files) do begin
      _File := Files[i];
      if Supports(_File.GroupBySignature['WRLD'], IwbContainerElementRef, Group) then begin
        for j := 0 to Pred(Group.ElementCount) do
          if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then begin
            if Mainrecord.Signature = 'WRLD' then begin
              // TES5LODGen works only for worldspaces with lodsettings file
              if (wbIsSkyrim or wbIsFallout3 or wbIsFallout4 or wbIsStarfield) and not wbContainerHandler.ResourceExists(wbLODSettingsFileName(MainRecord.EditorID)) then
                Continue;
              // do not list worldspace if Use LOD Data flag of parent world is set - FO4 has a orphaned LOD data for Diamond City
              if Mainrecord.ElementExists['Parent\WNAM'] and (Mainrecord.ElementNativeValues['Parent\PNAM\Flags'] and $2 = $2) then
                Continue;
              SetLength(Worldspaces, Succ(Length(Worldspaces)));
              Worldspaces[High(Worldspaces)] := MainRecord;
            end;
          end;
      end;
    end;
  end;

  if Length(WorldSpaces) > 1 then begin
    wbMergeSortPtr(@WorldSpaces[0], Length(WorldSpaces), CompareElementsFormIDAndLoadOrder);

    j := 0;
    for i := Succ(Low(WorldSpaces)) to High(WorldSpaces) do begin
      if WorldSpaces[j].LoadOrderFormID <> WorldSpaces[i].LoadOrderFormID then
        Inc(j);
      if j <> i then
        WorldSpaces[j] := WorldSpaces[i];
    end;
    SetLength(WorldSpaces, Succ(j));
  end;

  if Length(Worldspaces) = 0 then
    Exit;

  // TES4LODGen
  if wbGameMode = gmTES4 then begin
    with TfrmFileSelect.Create(Self) do try
      Width := 450;
      for i := Low(WorldSpaces) to High(WorldSpaces) do
        CheckListBox1.AddItem(WorldSpaces[i].Name, TObject(Pointer(WorldSpaces[i])));
      CheckListBox1.Sorted := True;
      Caption := 'Select Worldspaces';
      if ShowModal <> mrOK then
        Exit;

      wbStartTime := Now;
      pnlClient.Enabled := False;
      UpdatePnlCancelVisible;
      try
        for i := 0 to Pred(CheckListBox1.Count) do
          if CheckListBox1.Checked[i] then
            wbGenerateLODTES4(IwbMainRecord(Pointer(CheckListBox1.Items.Objects[i])), Settings)
      finally
        pnlClient.Enabled := True;
        UpdatePnlCancelVisible;
        Self.Caption := Application.Title
      end;
    finally
      Free;
    end;
  end;

  // xLODGen
  if wbIsSkyrim or wbIsFallout3 or wbIsFallout4 or wbIsStarfield then begin
    with TfrmLODGen.Create(Self) do try
      j := -1;
      for i := Low(WorldSpaces) to High(WorldSpaces) do begin
        clbWorldspace.AddItem(WorldSpaces[i].Name, TObject(Pointer(WorldSpaces[i])));
        // default selected worldspace at the top
        if (WorldSpaces[i].LoadOrderFormID.ToCardinal = $0000003C) or ((wbGameMode = gmFNV) and (WorldSpaces[i].LoadOrderFormID.ToCardinal = $000DA726)) then
          j := i;
      end;

      if j >= 0 then begin
        clbWorldspace.Items.Move(j, 0);
        clbWorldspace.Checked[0] := True;
      end;

      // if only a single worldspace available - check it
      if clbWorldspace.Items.Count = 1 then
        clbWorldspace.Checked[0] := True;

      Section := wbAppName + ' LOD Options';

      // FO4 settings
      if wbIsFallout4 or wbIsStarfield then begin
        iDefaultAtlasWidth := 4096;
        iDefaultAtlasHeight := 4096;
        fDefaultUVRange := 1.1;
        iDefaultAtlasDiffuseFormat := ifDXT5; //DXT5 generally seems better with tree LOD
        iDefaultAtlasNormalFormat := ifATI2n;
      end;

      if Assigned(Sender) and (wbGameMode in [gmSSE, gmTES5VR, gmEnderalSE]) then begin
        cbObjectsLOD.Checked := False;
        cbObjectsLOD.Enabled := False;
        Application.MessageBox(
          'Objects LOD generation for Skyrim Special Edition and Skyrim VR is possible only in xLODGen mode either ' +
          'by renaming executable to SSELODGen.exe or running with -lodgen command line parameter.',
          'Warning',
          MB_ICONINFORMATION + MB_OK
        );
      end else
        cbObjectsLOD.Checked := Settings.ReadBool(Section, 'ObjectsLOD', True);

      cbBuildAtlas.Checked := Settings.ReadBool(Section, 'BuildAtlas', True);
      cmbAtlasWidth.ItemIndex := IndexOf(cmbAtlasWidth.Items, Settings.ReadString(Section, 'AtlasWidth', IntToStr(iDefaultAtlasWidth)));
      cmbAtlasHeight.ItemIndex := IndexOf(cmbAtlasHeight.Items, Settings.ReadString(Section, 'AtlasHeight', IntToStr(iDefaultAtlasHeight)));
      cmbAtlasTextureSize.ItemIndex := IndexOf(cmbAtlasTextureSize.Items, Settings.ReadString(Section, 'AtlasTextureSize', '512'));
      cmbAtlasTextureUVRange.ItemIndex := IndexOf(cmbAtlasTextureUVRange.Items, Settings.ReadString(Section, 'AtlasTextureUVRange', FloatToStrF(fDefaultUVRange, ffFixed, 99, 1)));
      cmbCompDiffuse.ItemIndex := IndexOf(cmbCompDiffuse.Items, ImageFormatToStr(TImageFormat(Settings.ReadInteger(Section, 'AtlasDiffuseFormat', Integer(iDefaultAtlasDiffuseFormat)))));
      cmbCompDiffuseChange(nil);
      cmbCompNormal.ItemIndex := IndexOf(cmbCompNormal.Items, ImageFormatToStr(TImageFormat(Settings.ReadInteger(Section, 'AtlasNormalFormat', Integer(iDefaultAtlasNormalFormat)))));
      cmbCompSpecular.ItemIndex := IndexOf(cmbCompSpecular.Items, ImageFormatToStr(TImageFormat(Settings.ReadInteger(Section, 'AtlasSpecularFormat', Integer(iDefaultAtlasSpecularFormat)))));
      cmbDefaultAlphaThreshold.ItemIndex := IndexOf(cmbDefaultAlphaThreshold.Items, Settings.ReadString(Section, 'DefaultAlphaThreshold', IntToStr(iDefaultAlphaThreshold)));
      cbNoTangents.Checked := Settings.ReadBool(Section, 'ObjectsNoTangents', False);
      cbNoVertexColors.Checked := Settings.ReadBool(Section, 'ObjectsNoVertexColors', False);
      cbUseAlphaThreshold.Checked := Settings.ReadBool(Section, 'ObjectsUseAlphaThreshold', False);
      cbUseBacklightPower.Checked := Settings.ReadBool(Section, 'ObjectsUseBacklightPower', False);
      cbChunk.Checked := Settings.ReadBool(Section, 'Chunk', False);
      cmbLODLevel.ItemIndex := IndexOf(cmbLODLevel.Items, Settings.ReadString(Section, 'LODLevel', ''));
      edLODX.Text := Settings.ReadString(Section, 'LODX', '');
      edLODY.Text := Settings.ReadString(Section, 'LODY', '');
      edLODX2.Text := Settings.ReadString(Section, 'LODX2', '');
      edLODY2.Text := Settings.ReadString(Section, 'LODY2', '');
      cbTreesLOD.Checked := Settings.ReadBool(Section, 'TreesLOD', True);
      cbTrees3D.Checked := Settings.ReadBool(Section, 'Trees3D', False {wbGameMode in [gmSSE]});
      cmbTreesLODBrightness.ItemIndex := IndexOf(cmbTreesLODBrightness.Items, Settings.ReadString(Section, 'TreesBrightness', '0'));
      if wbIsFallout4 or wbIsStarfield then begin
        cbTreesLOD.Checked := False;
        cbTreesLOD.Enabled := False;
        cbUseAlphaThreshold.Visible := True;
        cbUseBacklightPower.Visible := True;
      end else
      // hidden option to split trees lod atlases when Shift is pressed
      if GetKeyState(VK_SHIFT) < 0 then begin
        _Files := @Files;
        btnSplitTreesLOD.Visible := True;
      end;

      if ShowModal <> mrOk then
        Exit;

      Settings.WriteBool(Section, 'ObjectsLOD', cbObjectsLOD.Checked);
      Settings.WriteBool(Section, 'BuildAtlas', cbBuildAtlas.Checked);
      Settings.WriteString(Section, 'AtlasWidth', cmbAtlasWidth.Text);
      Settings.WriteString(Section, 'AtlasHeight', cmbAtlasHeight.Text);
      Settings.WriteString(Section, 'AtlasTextureSize', cmbAtlasTextureSize.Text);
      Settings.WriteString(Section, 'AtlasTextureUVRange', cmbAtlasTextureUVRange.Text);
      Settings.WriteInteger(Section, 'AtlasDiffuseFormat', Integer(StrToImageFormat(cmbCompDiffuse.Text)));
      Settings.WriteInteger(Section, 'AtlasNormalFormat', Integer(StrToImageFormat(cmbCompNormal.Text)));
      Settings.WriteInteger(Section, 'AtlasSpecularFormat', Integer(StrToImageFormat(cmbCompSpecular.Text)));
      Settings.WriteString(Section, 'DefaultAlphaThreshold', cmbDefaultAlphaThreshold.Text);
      Settings.WriteBool(Section, 'ObjectsNoTangents', cbNoTangents.Checked);
      Settings.WriteBool(Section, 'ObjectsNoVertexColors', cbNoVertexColors.Checked);
      Settings.WriteBool(Section, 'ObjectsUseAlphaThreshold', cbUseAlphaThreshold.Checked);
      Settings.WriteBool(Section, 'ObjectsUseBacklightPower', cbUseBacklightPower.Checked);
      Settings.WriteBool(Section, 'Chunk', cbChunk.Checked);
      Settings.WriteString(Section, 'LODLevel', cmbLODLevel.Text);
      Settings.WriteString(Section, 'LODX', edLODX.Text);
      Settings.WriteString(Section, 'LODY', edLODY.Text);
      // Fallouts can have only a single atlas, so no options here
      if wbIsFallout3 then begin
        Settings.WriteBool(Section, 'BuildAtlas', True);
        Settings.WriteString(Section, 'AtlasTextureSize', '1024');
        Settings.WriteString(Section, 'AtlasTextureUVRange', '10000');
        Settings.WriteBool(Section, 'ObjectsNoTangents', False);
        Settings.WriteBool(Section, 'ObjectsNoVertexColors', True);
        // area settings are for FO3/FNV only
        Settings.WriteString(Section, 'LODX2', edLODX2.Text);
        Settings.WriteString(Section, 'LODY2', edLODY2.Text);
      end;
      Settings.WriteBool(Section, 'TreesLOD', cbTreesLOD.Checked);
      Settings.WriteBool(Section, 'Trees3D', cbTreesLOD.Checked and cbTrees3D.Checked);
      Settings.WriteString(Section, 'TreesBrightness', cmbTreesLODBrightness.Text);
      Settings.UpdateFile;

      lodTypes := [];
      if cbObjectsLOD.Checked then lodTypes := lodTypes + [lodObjects];
      if cbTreesLOD.Checked then lodTypes := lodTypes + [lodTrees];

      pgMain.ActivePage := tbsMessages;
      wbStartTime := Now;
      pnlClient.Enabled := False;
      UpdatePnlCancelVisible;
      try
        for i := 0 to Pred(clbWorldspace.Count) do
          if clbWorldspace.Checked[i] then
            if wbIsSkyrim or wbIsFallout3 then
              wbGenerateLODTES5(IwbMainRecord(Pointer(clbWorldspace.Items.Objects[i])), lodTypes, Files, Settings)
            else if wbIsFallout4 or wbIsStarfield then
              wbGenerateLODFO4(IwbMainRecord(Pointer(clbWorldspace.Items.Objects[i])), Files, Settings);
      finally
        pnlClient.Enabled := True;
        UpdatePnlCancelVisible;
        Self.Caption := Application.Title
      end;
    finally
      Free;
    end;
  end;

end;

procedure TfrmMain.mniNavRaceLVLIsClick(Sender: TObject);
var
  LVLIs       : TStringList;
  i, j, k, l  : Integer;
  Group       : IwbContainerElementRef;
  MainRecord  : IwbMainRecord;
  MainRecord2 : IwbMainRecord;
  Container   : IwbContainerElementRef;
  Container2  : IwbContainerElementRef;
  Race        : string;
  FormIDs     : array of record
                           FormID    : TwbFormID;
                           LoadOrder : Integer;
                         end;
begin
  LVLIs := TStringList.Create;
  LVLIs.Sorted := True;
  LVLIs.Duplicates := dupIgnore;

  FormIDs := nil;
  for i := Low(Files) to High(Files) do
    if Supports(Files[i].GroupBySignature['LVLI'], IwbContainerElementRef, Group) then
      for j := 0 to Pred(Group.ElementCount) do
        if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then
          if MainRecord.IsMaster and (MainRecord.EditorID <> '') then begin
            SetLength(FormIDs, Succ(Length(FormIDs)));
            with FormIDs[High(FormIDs)] do begin
              FormID := MainRecord.LoadOrderFormID;
              LoadOrder := MainRecord._File.LoadOrder;
            end;
            LVLIs.AddObject(MainRecord.EditorID, Pointer(High(FormIDs)));
          end;

  for i := Low(Files) to High(Files) do
    if Supports(Files[i].GroupBySignature['NPC_'], IwbContainerElementRef, Group) then
      for j := 0 to Pred(Group.ElementCount) do
        if Supports(Group.Elements[j], IwbMainRecord, MainRecord) then begin

          Race := '';
          if Supports(MainRecord.RecordBySignature['RNAM'], IwbContainerElementRef, Container) then
            if Supports(Container.LinksTo, IwbMainRecord, MainRecord2) then
              Race := MainRecord2.EditorID;

          if Race = '' then
            Continue;

          if Supports(MainRecord.ElementByName['Items'], IwbContainerElementRef, Container) then
            for k := 0 to Pred(Container.ElementCount) do
              if Supports(Container.Elements[k], IwbContainerElementRef, Container2) then
                if Container2.ElementCount = 2 then begin
                  if Supports(Container2.Elements[0].LinksTo, IwbMainRecord, MainRecord2) then begin
                    if MainRecord2.Signature = 'LVLI' then
                      if LVLIs.Find(MainRecord2.EditorID+Race, l) then begin
                        with FormIDs[Cardinal(LVLIs.Objects[l])] do
                          if LoadOrder <= Files[i].LoadOrder then try
                            Container2.Elements[0].EditValue := FormID.ToString(False)
                          except
                            on E: Exception do
                              PostAddMessage('Error updating Item '+MainRecord2.Name+' for '+MainRecord.Name+': '+ E.Message);
                        end;
                      end;
                  end;
                end;
        end;
end;

procedure TfrmMain.mniNavRemoveClick(Sender: TObject);
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  DialogResult                : Integer;
  MainRecord                  : IwbMainRecord;
  GroupRecord                 : IwbGroupRecord;
  Selection                   : TNodeArray;
  i                           : Integer;
  ContainsChilds              : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := RemovableSelection(@ContainsChilds);

  if Length(Selection) < 1 then
    Exit;

  if not EditWarn then
    Exit;

  if Length(Selection) = 1 then begin
    NodeData := vstNav.GetNodeData(Selection[0]);
    Element := NodeData.Element;
    if ContainsChilds then
      DialogResult := MessageDlg('Are you sure you want to permanently remove ' + Element.Name + ' and all other records it contains?', mtWarning, [mbYes, mbNo], 0)
    else
      DialogResult := MessageDlg('Are you sure you want to permanently remove ' + Element.Name + '?', mtConfirmation, [mbYes, mbNo], 0);
  end
  else begin
    if ContainsChilds then
      DialogResult := MessageDlg('Are you sure you want to permanently remove the ' + IntToStr(Length(Selection)) + ' removable selected records and all other records they contain?', mtWarning, [mbYes, mbNo], 0)
    else
      DialogResult := MessageDlg('Are you sure you want to permanently remove the ' + IntToStr(Length(Selection)) + ' removable selected records?', mtConfirmation, [mbYes, mbNo], 0);
  end;

  if DialogResult <> mrYes then
    Exit;

  vstNav.BeginUpdate;
  try
    for i := Low(Selection) to High(Selection) do begin
      NodeData := vstNav.GetNodeData(Selection[i]);
      Element := NodeData.Element;

      GroupRecord := nil;
      if Supports(Element, IwbMainRecord, MainRecord) then begin
        CheckHistoryRemove(BackHistory, MainRecord);
        CheckHistoryRemove(ForwardHistory, MainRecord);
        GroupRecord := MainRecord.ChildGroup;
      end;

      DoSetActiveRecord(nil);
      Element.Remove;
      if Assigned(GroupRecord) then
        GroupRecord.Remove;
      if not (toAutoFreeOnCollapse in vstNav.TreeOptions.AutoOptions) then
        vstNav.DeleteNode(Selection[i]);
    end;
    NavUpdate(True);
  finally
    vstNav.EndUpdate;
  end;

  InvalidateElementsTreeView(NoNodes);
end;

function IsExterior(aElement: IwbElement): Boolean;
var
  GroupRecord: IwbGroupRecord;
begin
  Result := False;
  if not Assigned(aElement) then
    Exit;
  if Supports(aElement, IwbGroupRecord, GroupRecord) then
    case GroupRecord.GroupType of
      0: begin
        Result := TwbSignature(GroupRecord.GroupLabel) = 'WRLD';
        Exit;
      end;
      1, 4, 5: begin
        Result := True;
        Exit;
      end;
      2, 3: Exit;
    end;
  Result := IsExterior(aElement.Container);
end;

procedure TfrmMain.mniNavSetVWDAutoClick(Sender: TObject);
const
  sJustWait                   = 'Setting VWD for all REFR with VWD Mesh. Please wait...';
var
  Selection                   : TNodeArray;
  StartNode, Node, NextNode   : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  MainRecord2                 : IwbMainRecord;
  NameRec                     : IwbContainerElementRef;
  Count                       : Cardinal;
  ChangeCount                 : Cardinal;
  StartTick                   : UInt64;
  i                           : Integer;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := vstNav.GetSortedSelection(True);

  if Length(Selection) < 1 then
    Exit;

  if not EditWarn then
    Exit;

  vstNav.BeginUpdate;
  try
    StartTick := GetTickCount64;
    wbStartTime := Now;

    pnlClient.Enabled := False;
    UpdatePnlCancelVisible;

    ChangeCount := 0;
    Count := 0;
    for i := Low(Selection) to High(Selection) do try
      StartNode := Selection[i];
      if Assigned(StartNode) then
        Node := vstNav.GetLast(StartNode)
      else
        Node := nil;

      while Assigned(Node) do begin
        NextNode := vstNav.GetPrevious(Node);
        NodeData := vstNav.GetNodeData(Node);

        if Supports(NodeData.Element, IwbMainRecord, MainRecord) and
          (MainRecord.Signature = 'REFR') and
          not MainRecord.IsVisibleWhenDistant and
          IsExterior(MainRecord) and
          Supports(MainRecord.RecordBySignature['NAME'], IwbContainerElementRef, NameRec) and
          Supports(NameRec.LinksTo, IwbMainRecord, MainRecord2) and
          MainRecord2.HasVisibleWhenDistantMesh then begin

          if not MainRecord.IsEditable then
            AddMessage('Can''t change: ' + MainRecord.Name)
          else begin
            AddMessage('Setting VWD: ' + MainRecord.Name);
            MainRecord.IsVisibleWhenDistant := True;
            Inc(ChangeCount);
            vstNav.DeleteNode(Node);
          end;

        end;

        Node := NextNode;
        Inc(Count);
        if StartTick + 500 < GetTickCount64 then begin
          Caption := sJustWait + ' Processed Records: ' + IntToStr(Count) +
            ' Change Records: ' + IntToStr(ChangeCount) +
            ' Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime);
          DoProcessMessages;
          StartTick := GetTickCount64;
        end;
        if Node = StartNode then
          Node := nil;
      end;

    finally
      pnlClient.Enabled := True;
      UpdatePnlCancelVisible;
    end;

    AddMessage('[Setting VWD for all REFR with VWD Mesh] ' + ' Processed Records: ' + IntToStr(Count) +
      ' Change Records: ' + IntToStr(ChangeCount) +
      ' Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime));
    vstNav.Invalidate;
  finally
    vstNav.EndUpdate;
    Caption := Application.Title;
  end;
end;

procedure SetVWDCallback(const aElement: IwbElement);
var
  MainRecord: IwbMainRecord;
begin
  if Supports(aElement, IwbMainRecord, MainRecord) then
    MainRecord.IsVisibleWhenDistant := True;
end;

procedure TfrmMain.mniNavSetVWDAutoIntoClick(Sender: TObject);
const
  sJustWaitScan               = 'Scanning for REFR without VWD Flag but with VWD Mesh';
var
  Selection                   : TNodeArray;
  StartNode, Node, NextNode   : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  MainRecord2                 : IwbMainRecord;
  NameRec                     : IwbContainerElementRef;
  Elements                    : TDynElements;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := vstNav.GetSortedSelection(True);

  if Length(Selection) < 1 then
    Exit;

  if not EditWarn then
    Exit;

  vstNav.BeginUpdate;
  try
    PerformLongAction(sJustWaitScan, '', procedure
    var
      i, j : Integer;
    begin
      j := 0;
      Elements := nil;
      SetLength(Elements, 1024);
      try
        for i := Low(Selection) to High(Selection) do begin
          StartNode := Selection[i];
          if Assigned(StartNode) then
            Node := vstNav.GetLast(StartNode)
          else
            Node := nil;

          while Assigned(Node) do begin
            NextNode := vstNav.GetPrevious(Node);
            NodeData := vstNav.GetNodeData(Node);

            if Supports(NodeData.Element, IwbMainRecord, MainRecord) and
              (MainRecord.Signature = 'REFR') and IsExterior(MainRecord) then begin

                if j > High(Elements) then
                  SetLength(Elements, Length(Elements)*2);
                Elements[j] := MainRecord;
                Inc(j);

              end;

            Node := NextNode;
            if Node = StartNode then
              Node := nil;
          end;
        end;
      finally
        pnlClient.Enabled := True;
        UpdatePnlCancelVisible;
      end;

      SetLength(Elements, j);

      if Length(Elements) > 1 then begin
        wbMergeSortPtr(@Elements[0], Length(Elements), CompareElementsFormIDAndLoadOrder);

        j := 0;
        for i := Succ(Low(Elements)) to High(Elements) do begin
          if (Elements[j] as IwbMainRecord).LoadOrderFormID <> (Elements[i] as IwbMainRecord).LoadOrderFormID then
            Inc(j);
          if j <> i then
            Elements[j] := Elements[i];
        end;
        SetLength(Elements, Succ(j));
      end;

      if Length(Elements) > 0 then begin

        j := 0;
        for i := Low(Elements) to High(Elements) do begin
          MainRecord := Elements[i] as IwbMainRecord;
          if not MainRecord.IsVisibleWhenDistant and
            Supports(MainRecord.RecordBySignature['NAME'], IwbContainerElementRef, NameRec) and
            Supports(NameRec.LinksTo, IwbMainRecord, MainRecord2) and
            MainRecord2.HasVisibleWhenDistantMesh then begin

            if MainRecord.HasErrors then
              AddMessage('[Setting VWD for all REFR with VWD Mesh] Skipping: ' + MainRecord.Name)
            else begin
              if j <> i then
                Elements[j] := Elements[i];
              Inc(j);
            end;

          end;
        end;
        SetLength(Elements, j);

      end;

      if Length(Elements) > 0 then
        CopyInto(False, False, False, False, False, Elements, SetVWDCallback);
    end);

    vstNav.Invalidate;
  finally
    vstNav.EndUpdate;
    Caption := Application.Title;
  end;
end;

procedure TfrmMain.mniNavSortMastersClick(Sender: TObject);
begin
  DoSetActiveRecord(nil);
  PerformActionOnSelectedFiles('sorting masters', procedure(aFile: IwbFile)
  begin
    aFile.SortMasters;
  end);
end;
{
procedure TfrmMain.mniNavTestClick(Sender: TObject);
var
  MainRecord : IwbMainRecord;
  AddOnsList : TDynMainRecords;

  Kits       : TDynMainRecords;
  FromWeapon : TDynMainRecords;
  ToWeapon   : TDynMainRecords;
  KitConfigs : TDynMainRecords;

  i          : Integer;
begin
  MainRecord := wbFindWinningMainRecordByEditorID('FLST', 'FO3EditAddOnsOrderedList');
  if not Assigned(MainRecord) then
    raise Exception.Create('Can''t find FO3EditAddOnsOrderedList');

  AddOnsList := wbFormListToArray(MainRecord, 'FLST');
  if Length(AddOnsList) <> 3 then
    raise Exception.Create('FO3EditAddOnsOrderedList must have exactly 3 entries of type FLST');

  Kits := wbFormListToArray(AddOnsList[0], 'MISC');
  FromWeapon := wbFormListToArray(AddOnsList[1], 'FLST');
  ToWeapon := wbFormListToArray(AddOnsList[2], 'FLST');

  if (Length(Kits) <> Length(FromWeapon)) or (Length(Kits) <> Length(ToWeapon)) then
    raise Exception.Create('The 3 FormLists from FO3EditAddOnsOrderedList must have the same number of entries');

  SetLength(KitConfigs, Length(Kits));
  for i := Low(Kits) to High(Kits) do begin
    KitConfigs[i] := wbFindWinningMainRecordByEditorID('BOOK', 'FO3EditAddOns' + Kits[i].EditorID + 'Config');
    if not Assigned(KitConfigs[i]) then
      raise Exception.Create('Could not find the Config record for ' + Kits[i].EditorID);
  end;

  //!!!
end;
}
{
procedure TfrmMain.mniNavTestClick(Sender: TObject);
var
  Group: IwbGroupRecord;
  GroupSP: IwbGroupRecord;
  i: Integer;
  MainRecord: IwbMainRecord;
  MainRecordSP: IwbMainRecord;
  sl : TStringList;
begin
  sl := TStringList.Create;
  Group := Files[0].GroupBySignature['STAT'];
  GroupSP := Files[2].GroupBySignature['MSTT'];
  for i := 0 to Pred(GroupSP.ElementCount) do
    if Supports(GroupSP.Elements[i], IwbMainRecord, MainRecordSP) then begin
      MainRecord := Group.MainRecordByEditorID[Copy(MainRecordSP.EditorID, 3, High(Integer))];
      if Assigned(MainRecord) then begin
        sl.Add('# ' + MainRecord.EditorID + ' -> ' + MainRecordSP.EditorID);
        sl.Add('MATCH REFR WHERE NAME = Fallout3.esm:' + IntToHex64(MainRecord.FormID and $FFFFFF, 6) );
        sl.Add('  SET NAME TO "SP_Destruction_MASTER.esm:'+IntToHex64(MainRecordSP.FormID and $FFFFFF, 6)+'"');
        sl.Add('END MATCH');
      end else
        sl.Add('# !!!' + MainRecordSP.EditorID + ' -> ' + MainRecord.EditorID + ' !!!');
      sl.Add('');
    end;
  sl.SaveToFile('D:\Program Files (x86)\Bethesda Softworks\Fallout 3\Data\SP_Destruction_MASTER.fo3editscript');
  sl.Free;

  sl := TStringList.Create;
  Group := Files[0].GroupBySignature['STAT'];
  GroupSP := Files[2].GroupBySignature['ACTI'];
  for i := 0 to Pred(GroupSP.ElementCount) do
    if Supports(GroupSP.Elements[i], IwbMainRecord, MainRecordSP) then begin
      MainRecord := Group.MainRecordByEditorID[Copy(MainRecordSP.EditorID, 3, High(Integer))];
      if Assigned(MainRecord) then begin
        sl.Add('# ' + MainRecord.EditorID + ' -> ' + MainRecordSP.EditorID);
        sl.Add('MATCH REFR WHERE NAME = Fallout3.esm:' + IntToHex64(MainRecord.FormID and $FFFFFF, 6) );
        sl.Add('  SET NAME TO "SP_Destruction_MASTER.esm:'+IntToHex64(MainRecordSP.FormID and $FFFFFF, 6)+'"');
        sl.Add('END MATCH');
      end else
        sl.Add('# !!! ' + MainRecordSP.EditorID+ ' !!!');
      sl.Add('');
    end;
  sl.SaveToFile('D:\Program Files (x86)\Bethesda Softworks\Fallout 3\Data\SP_Destruction - last - Lights.fo3editscript');
  sl.Free;
end;
}

procedure TfrmMain.mniNavTestClick(Sender: TObject);
var
  _File   : IwbFile;
  Records : array of IwbMainRecord;
  i {, j} : Integer;
  s       : string;
  Allowed : TStringList;
  Silent  : TStringList;
//  BaseRecord: IwbMainRecord;
//  FormID, FileID: Cardinal;
//  ContainerRef : IwbContainerElementRef;
begin
  _File := Files[2];
  SetLength(Records, _File.RecordCount);
  for i := low(Records) to high(Records) do
    Records[i] := _File.Records[i];

  {
  for i := low(Records) to high(Records) do begin
    FormID := Records[i].LoadOrderFormID;
    FileID := FormID shr 24;
    FormID := FormID and $00FFFFFF;
    if (FileID = 0) and (FormID <> 0) then begin
      FileID := 1;
      FileID := FileID shl 24;
      FormID := FormID or FileID;
      Records[i].LoadOrderFormID := FormID;
    end;
  end;
  }

  {
  for i := low(Records) to high(Records) do begin
    s := Records[i].Signature;
    if s = 'WRLD' then
      Continue;
    if s = 'CELL' then
      Continue;
    if s = 'LAND' then
      Continue;
    if s = 'REFR' then
      Continue;
    if s = 'TES4' then
      Continue;
    Records[i].Remove;
  end;
  }

  for i := low(Records) to high(Records) do begin
    s := Records[i].EditorID;
    if s <> '' then begin
      s := 'Hummer' + s;
      Records[i].EditorID := s;
    end;
  end;

  {
  for i := low(Records) to high(Records) do begin
    BaseRecord := Records[i].BaseRecord;
    if Assigned(BaseRecord) then begin
      s := BaseRecord.Signature;
      if s = 'IDLM' then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove
      end else if BaseRecord.FixedFormID < $800 then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end else if not BaseRecord.HasMesh then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end;
    end;
  end;
  }

  Allowed := TStringList.Create;
  Allowed.Sorted := True;
  Allowed.Add('DATA - Position/Rotation');
  Allowed.Add('NAME - Base');
  Allowed.Add('Record Header');
  Allowed.Add('Cell');
  Allowed.Add('XSCL - Scale');
  Allowed.Add('XRGD - Ragdoll Data');
  Allowed.Add('XEMI - Emittance');
  Allowed.Add('XSED - SpeedTree Seed');
  Allowed.Add('EDID - Editor ID');
  Allowed.Add('XESP - Enable Parent');

  Silent := TStringList.Create;
  Silent.Sorted := True;
  Silent.Add('Reflected/Refracted By');
  Silent.Add('XLOD - Distant LOD Data');
  Silent.Add('Ownership');
  Silent.Add('XNDP - Navigation Door Link');
  Silent.Add('XTEL - Teleport Destination');
  Silent.Add('XLOC - Lock Data');
  Silent.Add('XLKR - Linked Reference');
  Silent.Add('Patrol Data');
  Silent.Add('Activate Parents');
  Silent.Add('ONAM - Open by Default');
  Silent.Add('XACT - Action Flag');
  {
  for i := low(Records) to high(Records) do begin
    BaseRecord := Records[i].BaseRecord;
    if Assigned(BaseRecord) then begin
      s := BaseRecord.Signature;
      if s = 'WEAP' then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end else if s = 'ARMO' then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end else if s = 'AMMO' then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end else if s = 'TACT' then begin
        PostAddMessage('Removing: ' + Records[i].Name);
        Records[i].Remove;
      end
    end;
  end;}

  {
  for i := low(Records) to high(Records) do begin
    s := Records[i].Signature;
    if s = 'REFR' then
      if Supports(Records[i], IwbContainerElementRef, ContainerRef) then begin
        if Assigned(Records[i].RecordBySignature['XMBO']) then begin
          PostAddMessage('Removing: ' + Records[i].Name);
          Records[i].Remove;
        end else if Assigned(Records[i].RecordBySignature['XPRM']) then begin
          PostAddMessage('Removing: ' + Records[i].Name);
          Records[i].Remove;
        end else
          for j := Pred(ContainerRef.ElementCount) downto 0 do begin
            s := ContainerRef.Elements[j].Name;
            if Allowed.IndexOf(s) < 0 then begin
              if Silent.IndexOf(s) < 0 then
                PostAddMessage('Removing: ' + s);
              ContainerRef.Elements[j].Remove;
            end;
          end;
      end;
  end;
  }                        {
  for i := low(Records) to high(Records) do begin
    s := Records[i].Signature;
    if s = 'REFR' then
      if Records[i].IsPersistent then try
        Records[i].IsPersistent := False;
      except end;
  end;

  }
  PostAddMessage('Done');
end;

procedure TfrmMain.mniRefByVWDClick(Sender: TObject);
var
  Selected   : TDynMainRecords;
  Cells      : TDynMainRecords;
  MainRecord : IwbMainRecord;
  GroupRecord: IwbGroupRecord;
  FoundIt    : Boolean;
  i, j, k    : Integer;
  Node       : PVirtualNode;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if not EditWarn then
    Exit;

  Cells := nil;
  Selected := GetRefBySelectionAsMainRecords;
  k := 0;
  SetLength(Cells, Length(Selected));
  for i := Low(Selected) to High(Selected) do
    if (Selected[i].Signature = 'REFR') and Selected[i].IsEditable then begin
      if Sender = mniRefByNotVWD then
        Selected[i].IsVisibleWhenDistant := False
      else
        Selected[i].IsVisibleWhenDistant := True;

      if not Assigned(Selected[i].Container) then
        Continue;
      if not Assigned(Selected[i].Container.Container) then
        Continue;
      if not Supports(Selected[i].Container.Container, IwbGroupRecord, GroupRecord) then
        Continue;
      if GroupRecord.GroupType <> 6 then
        Continue;
      MainRecord := GroupRecord.ChildrenOf;
      if not Assigned(MainRecord) then
        Continue;
      if MainRecord.Signature <> 'CELL' then
        Continue;

      FoundIt := False;
      for j := Low(Cells) to Pred(k) do
        if MainRecord.Equals(Cells[i]) then begin
          FoundIt := True;
          Break;
        end;
      if FoundIt then
        Continue;

      Cells[k] := MainRecord;
      Inc(k);
    end;
  SetLength(Cells, k);
  for i := Low(Cells) to High(Cells) do begin
    Node := FindNodeForElement(Cells[i]);
    if not Assigned(Node) then
      Continue;
    vstNav.Expanded[Node] := False;
    InvalidateElementsTreeView(TNodeArray.Create(Node));
  end;
end;

procedure TfrmMain.LoadModGroupsSelection(const aModGroups: TwbModGroupPtrs);
var
  i, j : Integer;
begin
  with TStringList.Create do try
    CommaText := Settings.ReadString('ModGroups', 'Selection', '');
    Duplicates := dupIgnore;
    Sorted := True;
    if NewModGroupName <> '' then
      Add(NewModGroupName);
    for i := Low(aModGroups) to High(aModGroups) do
      with aModGroups[i]^ do
        if Find(mgName, j) then
          Include(mgFlags, mgfTagged)
        else
          Exclude(mgFlags, mgfTagged);
  finally
    Free;
  end;
end;

procedure TfrmMain.LockOutPinned;
begin
  Inc(LockOutPinnedCount);
end;

function TfrmMain.LOOTDirtyInfo(const aInfo: TLOOTPluginInfo; aFileChanged: Boolean): string;
// LOOT dirty entry example
{
  - name: 'DLCRobot.esm'
    dirty:
      - <<: *dirtyPlugin
        crc: 0xD69027EA
        util: 'FO4Edit v3.2.1'
        itm: 45
        udr: 38
        nav: 1
}
// LOOT clean entry example
{
  - name: 'BetterSettlers.esp'
    clean:
      - crc: 0x6A5FC68B
        util: 'FO4Edit v3.2'
}
begin
  Result := '';
  if (aInfo.ITM <> 0) or (aInfo.UDR <> 0) or (aInfo.NAV <> 0) then begin
    if aFileChanged then begin
      Result := CRLF + Format(StringOfChar(' ', 2) + '- name: ''%s''', [aInfo.Plugin.Replace('''', '''''', [rfReplaceAll])]) + CRLF;
      Result := Result + StringOfChar(' ', 4) + 'dirty:' + CRLF;
    end;
    if aInfo.NAV <> 0 then
      Result := Result + StringOfChar(' ', 6) + '- <<: *reqManualFix'
    else
      Result := Result + StringOfChar(' ', 6) + '- <<: *quickClean';
    Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'crc: 0x%s', [IntToHex(aInfo.CRC32, 8)]);
    Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'util: ''[%sEdit v%s](%s)''', [wbAppName, VersionString.ToString, wbNexusModsUrl]);
    if aInfo.ITM <> 0 then Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'itm: %d', [aInfo.ITM]);
    if aInfo.UDR <> 0 then Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'udr: %d', [aInfo.UDR]);
    if aInfo.NAV <> 0 then Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'nav: %d', [aInfo.NAV]);
  end
  else if (aInfo.ITM = 0) and (aInfo.UDR = 0) and (aInfo.NAV = 0) then begin
    if aFileChanged then
      Result := CRLF + Format(StringOfChar(' ', 2) + '- name: ''%s''', [aInfo.Plugin.Replace('''', '''''', [rfReplaceAll])]) + CRLF;
    Result := Result + StringOfChar(' ', 4) + 'clean:';
    Result := Result + CRLF + Format(StringOfChar(' ', 6) + '- crc: 0x%s', [IntToHex(aInfo.CRC32, 8)]);
    Result := Result + CRLF + Format(StringOfChar(' ', 8) + 'util: ''%sEdit v%s''', [wbAppName, VersionString.ToString]);
  end;
end;

function TfrmMain.BOSSDirtyInfo(const aInfo: TLOOTPluginInfo): string;
// BOSS entry example
{
WAC - NoMapMarker.esp
  IF CHECKSUM("WAC - NoMapMarker.esp", 9BD8F9C2) DIRTY: 16 ITM, 0 UDR records. Needs TES4Edit cleaning: "http://cs.elderscrolls.com/index.php?title=TES4Edit_Cleaning_Guide"
}
begin
  Result := '';
  if (aInfo.ITM <> 0) or (aInfo.UDR <> 0) then begin
    Result := Result + CRLF + aInfo.Plugin;
    Result := Result + CRLF + Format('  IF CHECKSUM("%s", %s) DIRTY: %d ITM, %d UDR records. Needs %sEdit cleaning: "http://cs.elderscrolls.com/index.php?title=TES4Edit_Cleaning_Guide"', [
      aInfo.Plugin,
      IntToHex(aInfo.CRC32, 8),
      aInfo.ITM,
      aInfo.UDR,
      wbAppName
    ]);
  end;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to request to force cancel the current operation?' + sLineBreak + sLineBreak +
    'Canceling the operation might leave xEdit in an inconsistent state.', mtConfirmation, mbYesNo, 0, mbNo) = mrYes then
    wbForceTerminate := True;
end;

procedure TfrmMain.mniNavUndeleteAndDisableReferencesClick(Sender: TObject);
const
  sJustWait                   = 'Undeleting and Disabling References. Please wait...';
var
  Selection                   : TNodeArray;
  StartNode, Node, NextNode   : PVirtualNode;
  NodeData                    : PNavNodeData;
  Count                       : Cardinal;
  UndeletedCount              : Cardinal;
  NotDeletedCount             : Cardinal;
  DeletedNAVM                 : Cardinal;
  StartTick                   : UInt64;
  i {, n}                     : Integer;
  MainRecord, LinksToRecord   : IwbMainRecord;
  Element                     : IwbElement;
  Position                    : TwbVector;
  Cntr {, Cntr2}              : IwbContainerElementRef;
  AutoModeCheckForDR          : Boolean;
  Operation, Plugin           : String;
  PluginCRC32                 : Cardinal;
  DirtyInfo                   : PLOOTPluginInfo;

  function canUndelete: Boolean;
  begin
    Result := True;
    LinksToRecord := MainRecord.MasterOrSelf.BaseRecord;
    // skip navmeshes
    if MainRecord.Signature = 'NAVM' then begin
      Result := False;
      Inc(DeletedNAVM);
    end
    // skip injected or bad refs (crashes after cleaning TES4 Battlehorn DLC)
    else if MainRecord.IsInjected or (not Assigned(LinksToRecord)) then begin
      Result := False;
      Inc(notDeletedCount);
    end
    // skip refs of TREEs with LOD in FNV
    else if (wbGameMode in [gmFNV]) and (LinksToRecord.Signature = 'TREE') and LinksToRecord.Flags.HasLODtree then begin
      Result := False;
      Inc(notDeletedCount);
    end;
    if not Result then
      PostAddMessage('Skipping: ' + MainRecord.Name);
  end;

begin
  AutoModeCheckForDR := wbToolMode in [tmCheckForDR];
  if AutoModeCheckForDR then Operation := 'Count' else Operation := 'Undelet';

  if not AutoModeCheckForDR and not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := vstNav.GetSortedSelection(True);

  if Length(Selection) < 1 then
    Exit;

  if not FilterApplied or
    FilterConflictAll or
    FilterConflictThis or
    FilterByInjectStatus or
    FilterByPersistent or
    FilterByVWD or
    (FilterByNotReachableStatus and ReachableBuild) or
    FilterByReferencesInjectedStatus or
    FilterByEditorID or
    FilterByName or
    FilterByElementValue or
    FilterBySignature or
    FilterByBaseEditorID or
    FilterByBaseName or
    FilterScaledActors or
    FilterByBaseSignature or
    FlattenBlocks or
    FlattenCellChilds or
    AssignPersWrldChild or
    ModGroupsEnabled or
    OnlyShowMasterAndLeafs or
    xeQuickShowConflicts or
    not InheritConflictByParent then begin

    MessageDlg('To use this function you need to apply a filter with *only* the option "Conflict status inherited by parent" active and ModGroups, "Show Master and Leafs", and "Quick Show Conflict" mode disabled.', mtError, [mbOk], 0);
    Exit;
  end;

  if not AutoModeCheckForDR and not EditWarn then
    Exit;

  vstNav.BeginUpdate;
  try
    StartTick := GetTickCount64;
    wbStartTime := Now;

    pnlClient.Enabled := False;
    UpdatePnlCancelVisible;

    Plugin := '';
    PluginCRC32 := 0;
    UndeletedCount := 0;
    NotDeletedCount := 0;
    DeletedNAVM := 0;
    Count := 0;
    for i := Low(Selection) to High(Selection) do try
      StartNode := Selection[i];
      if Assigned(StartNode) then
        Node := vstNav.GetLast(StartNode)
      else
        Node := nil;
      while Assigned(Node) do begin
        NextNode := vstNav.GetPrevious(Node);
        NodeData := vstNav.GetNodeData(Node);

        if Supports(NodeData.Element, IwbMainRecord, MainRecord) then with MainRecord do begin
          if Assigned(MainRecord._File) then
            with MainRecord._File do begin
              Plugin := FileName;
              PluginCRC32 := CRC32;
            end;
          if IsEditable and
             (IsDeleted {or (GetPosition(Position) and (Position.z = -30000.0)) and (MainRecord.ElementNativeValues['XESP\Reference'] <> $14)} ) and
             (
               (Signature = 'REFR') or
               (Signature = 'PGRE') or
               (Signature = 'PMIS') or
               (Signature = 'ACHR') or
               (Signature = 'ACRE') or
               (Signature = 'NAVM') or
               (Signature = 'PARW') or {>>> Skyrim <<<}
               (Signature = 'PBAR') or {>>> Skyrim <<<}
               (Signature = 'PBEA') or {>>> Skyrim <<<}
               (Signature = 'PCON') or {>>> Skyrim <<<}
               (Signature = 'PFLA') or {>>> Skyrim <<<}
               (Signature = 'PHZD')    {>>> Skyrim <<<}
             ) then
          //begin
          if canUndelete then begin
            PostAddMessage(Operation+'ing: ' + MainRecord.Name);
            if not AutoModeCheckForDR then begin
              IsDeleted := True;
              IsDeleted := False;
              if (wbIsSkyrim or wbIsFallout3 or wbIsFallout4 or wbIsFallout76 or wbIsStarfield) and ((Signature = 'ACHR') or (Signature = 'ACRE')) then
                IsPersistent := True
              else if wbGameMode = gmTES4 then
                IsPersistent := False;
              if not IsPersistent then
                if wbUDRSetZ and GetPosition(Position) then begin
                  Position.z := wbUDRSetZValue;
                  SetPosition(Position);
                end;
              RemoveElement('Enable Parent');
              RemoveElement('XTEL');
              IsInitiallyDisabled := True;
              if wbUDRSetXESP and Supports(Add('XESP', True), IwbContainerElementRef, Cntr) then begin
                Cntr.ElementNativeValues['Reference'] := $14;
                Cntr.ElementNativeValues['Flags'] := 1;
              end;

              if wbUDRSetScale then begin
                if not Assigned(ElementBySignature['XSCL']) then
                  Element := Add('XSCL', True);
                  if Assigned(Element) then
                    Element.NativeValue := wbUDRSetScaleValue;
              end;

              if wbUDRSetMSTT and wbIsFallout3 then begin
                Element := ElementBySignature['NAME'];
                if Assigned(Element) then
                  if Supports(Element.LinksTo, IwbMainRecord, LinksToRecord) then
                    if LinksToRecord.Signature = 'MSTT' then
                      Element.NativeValue := wbUDRSetMSTTValue;
              end;

            end;
            Inc(UndeletedCount);
          end;
        end;

        Node := NextNode;
        Inc(Count);
        if StartTick + 500 < GetTickCount64 then begin
          Caption := sJustWait + ' Processed Records: ' + IntToStr(Count) +
            ' '+Operation+'ed Records: ' + IntToStr(UndeletedCount) +
            ' Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime);
          DoProcessMessages;
          StartTick := GetTickCount64;
        end;
        if Node = StartNode then
          Node := nil;
      end;

    finally
      pnlClient.Enabled := True;
      UpdatePnlCancelVisible;
    end;

    PostAddMessage('['+Operation+'ing and Disabling References done] ' + ' Processed Records: ' + IntToStr(Count) +
      ', '+Operation+'ed Records: ' + IntToStr(UndeletedCount) +
      ', Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime));
    if DeletedNAVM > 0 then
      PostAddMessage('<Warning: Plugin contains ' + IntToStr(DeletedNAVM) + ' deleted NavMeshes which can not be undeleted>');
    if NotDeletedCount > 0 then
      PostAddMessage('<Warning: Plugin contains ' + IntToStr(NotDeletedCount) + ' deleted references which can not be undeleted>');

    // store dirty information
    if Plugin <> '' then begin
      DirtyInfo := nil;
      for i := Low(LOOTPluginInfos) to High(LOOTPluginInfos) do
        if (LOOTPluginInfos[i].Plugin = Plugin) and (LOOTPluginInfos[i].CRC32 = PluginCRC32) then begin
          DirtyInfo := @LOOTPluginInfos[i];
          Break;
        end;
      if not Assigned(DirtyInfo) then begin
        SetLength(LOOTPluginInfos, Succ(Length(LOOTPluginInfos)));
        DirtyInfo := @LOOTPluginInfos[Pred(Length(LOOTPluginInfos))];
      end;
      DirtyInfo.Plugin := Plugin;
      DirtyInfo.CRC32 := PluginCRC32;
      DirtyInfo.UDR := UndeletedCount;
      DirtyInfo.NAV := DeletedNAVM;
    end;

    if AutomodeCheckForDR then DRcount := UndeletedCount;
  finally
    vstNav.EndUpdate;
    Caption := Application.Title;
  end;
end;

procedure TfrmMain.mniNavUpdateCRCModGroupsClick(Sender: TObject);
var
  MissingAny       : TwbModuleInfos;
  MissingCurrent   : TwbModuleInfos;
  lSelectedModules : TwbModuleInfos;
  UpdatedCount     : Integer;
begin
  with TfrmModuleSelect.Create(Self) do try
    AllModules := wbModulesByLoadOrder.FilteredByFlag(mfValid);
    AllModules.ExcludeAll(mfTagged);
    AllModules.ExcludeAll(mfModGroupMissingAnyCRC);
    AllModules.ExcludeAll(mfModGroupMissingCurrentCRC);
    wbModGroupsByName(False).FlagFilesMissingCRC;

    MissingAny := AllModules.FilteredByFlag(mfModGroupMissingAnyCRC);
    MissingCurrent := AllModules.FilteredByFlag(mfModGroupMissingCurrentCRC);

    if (Length(MissingAny) > 0) and (Length(MissingCurrent) > 0) then begin
      if MessageDlg('Do you wish to add CRCs to ModGroup Items which currently do not contain any CRCs?', mtConfirmation, mbYesNo, 0) <> mrYes then
        MissingAny := nil
      else if MessageDlg('Do you wish to update CRCs in ModGroup Items which already contain CRCs, but are missing the current one?', mtConfirmation, mbYesNo, 0) <> mrYes then
        MissingCurrent := nil;
    end;

    if Length(MissingAny) > 0 then begin
      if Length(MissingCurrent) > 0 then begin
        Caption := 'Please select the modules for which you want to add or update the current CRC to/in ModGroup Items...';
        AllModules := AllModules.FilteredBy(function(aModule: PwbModuleInfo): Boolean begin
          Result := aModule.miFlags * [mfModGroupMissingAnyCRC, mfModGroupMissingCurrentCRC] <> [];
        end);
      end else begin
        Caption := 'Please select the modules for which you want to add the current CRC to ModGroups';
        AllModules := MissingAny;
      end;
    end else begin
      if Length(MissingCurrent) > 0 then begin
        Caption := 'Please select the modules for which you want to update the current CRC in ModGroups...';
        AllModules := MissingCurrent;
      end else begin
        ShowMessage('No ModGroups need updating.');
        Exit;
      end;
    end;

    SelectFlag := mfTagged;
    MinSelect := 1;
    AllowCancel;

    if ShowModal <> mrOK then
      Exit;

    lSelectedModules := SelectedModules;
  finally
    Free;
  end;

  with TfrmModGroupSelect.Create(Self) do try
    AllModGroups := wbModGroupsByName(False);
    AllModGroups.ExcludeAll(mgfTagged);
    AllModGroups.FlagModGroupsNeedingCRCUpdateForTaggedFiles(Length(MissingAny) > 0, Length(MissingCurrent) > 0);
    AllModGroups := AllModGroups.FilteredByFlag(mgfNeedCRCUpdate);

    if Length(AllModGroups) < 1 then begin
      ShowMessage('Nothing to do.');
      Exit;
    end;

    Caption := 'Please select the ModGroups you wish to update...';
    SelectFlag := mgfTagged;
    FilterFlag := mgfNone;
    AllowCancel;

    MinSelect := 1;

    if ShowModal < mrOK then
      Exit;

    UpdatedCount := SelectedModGroups.UpdateCRC(Length(MissingAny) > 0, Length(MissingCurrent) > 0);
    case UpdatedCount of
      0: ShowMessage('No ModGroups have been updated.');
      1: ShowMessage('One ModGroup has been updated.');
    else
      ShowMessage(UpdatedCount.ToString + ' ModGroups have been updated.');
    end;
  finally
    Free;
  end;

  mniViewModGroupsReloadClick(Self);
end;

procedure TfrmMain.mniNavRemoveIdenticalToMasterClick(Sender: TObject);
const
  sJustWait                   = 'Removing "Identical to Master" records. Please wait...';
var
  Selection                   : TNodeArray;
  StartNode, Node, NextNode   : PVirtualNode;
  NodeData                    : PNavNodeData;
  Count                       : Cardinal;
  RemovedCount                : Cardinal;
  StartTick                   : UInt64;
  i                           : Integer;
  MainRecord                  : IwbMainRecord;
  GroupRecord                 : IwbGroupRecord;
  AutoModeCheckForITM         : Boolean;
  Operation, Plugin           : String;
  PluginCRC32                 : Cardinal;
  DirtyInfo                   : PLOOTPluginInfo;

begin
  PluginCRC32 := 0;

  AutoModeCheckForITM := wbToolMode in [tmCheckForITM];
  if AutoModeCheckForITM then Operation := 'Count' else Operation := 'Remov';

  if not wbEditAllowed and not AutoModeCheckForITM then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := vstNav.GetSortedSelection(True);

  if Length(Selection) < 1 then
    Exit;

  if not FilterApplied or
    FilterConflictAll or
    FilterConflictThis or
    FilterByInjectStatus or
    FilterByPersistent or
    FilterByVWD or
    (FilterByNotReachableStatus and ReachableBuild) or
    FilterByReferencesInjectedStatus or
    FilterByEditorID or
    FilterByName or
    FilterByElementValue or
    FilterBySignature or
    FilterByBaseEditorID or
    FilterByBaseName or
    FilterScaledActors or
    FilterByBaseSignature or
    FlattenBlocks or
    FlattenCellChilds or
    AssignPersWrldChild or
    ModGroupsEnabled or
    OnlyShowMasterAndLeafs or
    xeQuickShowConflicts or
    not InheritConflictByParent then begin

    MessageDlg('To use this function you need to apply a filter with *only* the option "Conflict status inherited by parent" active and ModGroups, "Show Master and Leafs", and "Quick Show Conflict" mode disabled.', mtError, [mbOk], 0);
    Exit;
  end;

  if not AutoModeCheckForITM and not EditWarn then
    Exit;

  vstNav.BeginUpdate;
  try
    StartTick := GetTickCount64;
    wbStartTime := Now;

    pnlClient.Enabled := False;
    UpdatePnlCancelVisible;

    RemovedCount := 0;
    Count := 0;
    for i := Low(Selection) to High(Selection) do try
      StartNode := Selection[i];
      if Assigned(StartNode) then
        Node := vstNav.GetLast(StartNode)
      else
        Node := nil;
      while Assigned(Node) do begin
        NextNode := vstNav.GetPrevious(Node);
        NodeData := vstNav.GetNodeData(Node);

        if Assigned(NodeData.Element) then begin
          if (
               (Node.ChildCount = 0) or
               (
                 wbAllowMakePartial and
                 Supports(NodeData.Element, IwbMainRecord, MainRecord) and
                 not MainRecord.IsPartialForm and
                 MainRecord.CanBePartial
               )
             ) and
            (
              (NodeData.ConflictThis = ctIdenticalToMaster) or
              (
                (NodeData.ConflictThis = ctConflictBenign) and
                Supports(NodeData.Element, IwbMainRecord, MainRecord) and
                (MainRecord.Signature = 'NAVM')
              ) or
              (
                (NodeData.OrgConflictThis = ctIdenticalToMaster) and
                wbAllowMakePartial and
                (Node.ChildCount > 0)
              ) or
              (
                Supports(NodeData.Element, IwbGroupRecord, GroupRecord)
              ) or
              (
                (Node.ChildCount = 0) and
                wbAllowMakePartial and
                Supports(NodeData.Element, IwbMainRecord, MainRecord) and
                MainRecord.IsPartialForm and
                (not Assigned(MainRecord.ChildGroup) or (MainRecord.ChildGroup.ElementCount = 0))
              )
            ) and
              not (Supports(NodeData.Element, IwbMainRecord, MainRecord) and MainRecord.MasterOrSelf.IsInjected)
            then begin
              MainRecord := nil;

              if Assigned(NodeData.Element._File) then
                with NodeData.Element._File do begin
                  Plugin := FileName;
                  PluginCRC32 := CRC32;
                end;

              if not NodeData.Element.IsRemovable then
                PostAddMessage('Can''t remove: ' + NodeData.Element.Name)
              else begin
                if not AutoModeCheckForITM then begin
                  if Node.ChildCount > 0 then begin
                    if wbAllowMakePartial and
                       Supports(NodeData.Element, IwbMainRecord, MainRecord)
                    then begin
                      if not HideRemoveMessage then
                        PostAddMessage('Making Partial Form: ' + NodeData.Element.Name);
                      MainRecord.MakePartialForm;
                    end;
                  end else begin
                    if not HideRemoveMessage then
                      PostAddMessage(Operation+'ing: ' + NodeData.Element.Name);

                    if Assigned(NodeData.Container) and not NodeData.Container.Equals(NodeData.Element) then
                        NodeData.Container.Remove;
                    NodeData.Element.Remove;
                    NodeData.Container := nil;
                    NodeData.Element := nil;
                    vstNav.DeleteNode(Node);
                  end;
                end else
                  if not HideRemoveMessage then
                    PostAddMessage(Operation+'ing: ' + NodeData.Element.Name);
                Inc(RemovedCount);
              end;
            end;
        end;

        Node := NextNode;
        Inc(Count);
        if StartTick + 500 < GetTickCount64 then begin
          Caption := sJustWait + ' Processed Records: ' + IntToStr(Count) +
            ' '+Operation+'ed Records: ' + IntToStr(RemovedCount) +
            ' Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime);
          DoProcessMessages;
          StartTick := GetTickCount64;
        end;
        if Node = StartNode then
          Node := nil;
      end;

    finally
      pnlClient.Enabled := True;
      UpdatePnlCancelVisible;
    end;

    PostAddMessage('['+Operation+'ing "Identical to Master" records done] ' + ' Processed Records: ' + IntToStr(Count) +
      ', '+Operation+'ed Records: ' + IntToStr(RemovedCount) +
      ', Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime)); // Does not show up if handling "a lot" of records !

    // store dirty information
    if Plugin <> '' then begin
      DirtyInfo := nil;
      for i := Low(LOOTPluginInfos) to High(LOOTPluginInfos) do
        if (LOOTPluginInfos[i].Plugin = Plugin) and (LOOTPluginInfos[i].CRC32 = PluginCRC32) then begin
          DirtyInfo := @LOOTPluginInfos[i];
          Break;
        end;
      if not Assigned(DirtyInfo) then begin
        SetLength(LOOTPluginInfos, Succ(Length(LOOTPluginInfos)));
        DirtyInfo := @LOOTPluginInfos[Pred(Length(LOOTPluginInfos))];
      end;
      DirtyInfo.Plugin := Plugin;
      DirtyInfo.CRC32 := PluginCRC32;
      DirtyInfo.ITM := RemovedCount;
    end;

    if AutoModeCheckForITM then ITMcount := RemovedCount;

  finally
    vstNav.EndUpdate;
    Caption := Application.Title;
  end;
end;

procedure TfrmMain.mniNavLOManagersDirtyInfoClick(Sender: TObject);
var
  i           : Integer;
  BOSS        : Boolean;
  FileChanged : Boolean;
begin
  if Length(LOOTPluginInfos) < 1 then
    Exit;

  BOSS := False;
  pgMain.ActivePage := tbsMessages;

  // There will always be a LOOT message,
  // since a plugin will always either be clean or it will be dirty
  PostAddMessage('');
  PostAddMessage('LOOT Masterlist Entries');
  for i := Low(LOOTPluginInfos) to High(LOOTPluginInfos) do begin
    FileChanged := (i=0) or not SameText(LOOTPluginInfos[i].Plugin, LOOTPluginInfos[Pred(i)].Plugin);
    PostAddMessage(LOOTDirtyInfo(LOOTPluginInfos[i], FileChanged));
    if (LOOTPluginInfos[i].ITM <> 0) or (LOOTPluginInfos[i].UDR <> 0) then
      BOSS := wbGameMode = gmTES4;
  end;
  PostAddMessage('');

  if BOSS then begin
    PostAddMessage('BOSS Masterlist Entries');
    for i := Low(LOOTPluginInfos) to High(LOOTPluginInfos) do
      PostAddMessage(BOSSDirtyInfo(LOOTPluginInfos[i]));
  end;
end;

procedure TfrmMain.mniSpreadsheetCompareSelectedClick(Sender: TObject);
var
  vstSpreadsheet              : TVirtualEditTree;
  Nodes                       : TNodeArray;
  NodeDatas                   : PSpreadSheetNodeDatas;
  Records                     : TDynMainRecords;
  i                           : Integer;
begin
  vstSpreadsheet := pmuSpreadsheet.PopupComponent as TVirtualEditTree;
  Nodes := vstSpreadsheet.GetSortedSelection(True);
  SetLength(Records, Length(Nodes));
  for i := Low(Nodes) to High(Nodes) do begin
    NodeDatas := vstSpreadsheet.GetNodeData(Nodes[i]);
    Records[i] := NodeDatas[0].Element as IwbMainRecord;
  end;
  JumpTo(TCompareRecordsHistoryEntry.Create(Records), False);
end;

procedure TfrmMain.mniSpreadsheetRebuildClick(Sender: TObject);
var
  vstSpreadsheet              : TVirtualEditTree;
begin
  vstSpreadsheet := pmuSpreadsheet.PopupComponent as TVirtualEditTree;
  vstSpreadsheet.Clear;
  vstSpreadsheet.NodeDataSize := 0;
  tbsSpreadsheetShow(vstSpreadsheet.Parent);
end;

procedure TfrmMain.mniViewHeaderUnhideAllClick(Sender: TObject);
var
  i, j       : Integer;
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
begin
  for i := Low(ActiveRecords) to High(ActiveRecords) do begin
    Element := ActiveRecords[i].Element;
    if Supports(Element, IwbMainRecord, MainRecord) then begin
      MainRecord := MainRecord.MasterOrSelf;
      MainRecord.Show;
      for j := 0 to Pred(MainRecord.OverrideCount) do
        MainRecord.Overrides[j].Show;
      Break;
    end;
  end;
  PostResetActiveTree;
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniViewRemoveClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  NextNode                    : PVirtualNode;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;
    if not EditWarn then
      Exit;

  LockProcessMessages;
  try
    NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
    NextNode := vstView.GetNextVisibleSibling(vstViewFocusedNode);
    if not Assigned(NextNode) then
      NextNode := vstView.GetPreviousVisibleSibling(vstViewFocusedNode);
    if not Assigned(NextNode) then begin
      NextNode := vstViewFocusedNode.Parent;
      if vstView.RootNode = NextNode then
        NextNode := nil;
    end;

    if Assigned(NodeDatas) then begin
      Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
      if Assigned(Element) then begin

        if Assigned(NextNode) then begin
          NodeDatas := vstView.GetNodeData(NextNode);
          ViewFocusedElement := NodeDatas[Pred(vstView.FocusedColumn)].Element;
          EditFocusedViewElement := False;
        end;

        Element.Remove;
        ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
        Element := nil;
        PostResetActiveTree;
        InvalidateElementsTreeView(NoNodes);
      end;
    end;
  finally
    UnLockProcessMessages;
  end;
end;

procedure TfrmMain.mniViewClearClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  NextNode                    : PVirtualNode;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;
    if not EditWarn then
      Exit;

  LockProcessMessages;
  try
    NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
    NextNode := vstView.GetNextVisibleSibling(vstViewFocusedNode);
    if not Assigned(NextNode) then
      NextNode := vstView.GetPreviousVisibleSibling(vstViewFocusedNode);
    if not Assigned(NextNode) then begin
      NextNode := vstViewFocusedNode.Parent;
      if vstView.RootNode = NextNode then
        NextNode := nil;
    end;

    if Assigned(NodeDatas) then begin
      Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
      if Assigned(Element) then begin

        if Assigned(NextNode) then begin
          NodeDatas := vstView.GetNodeData(NextNode);
          ViewFocusedElement := NodeDatas[Pred(vstView.FocusedColumn)].Element;
          EditFocusedViewElement := False;
        end;

        Element.Clear;
        ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
        Element := nil;
        PostResetActiveTree;
        InvalidateElementsTreeView(NoNodes);
      end;
    end;
  finally
    UnLockProcessMessages;
  end;
end;

procedure TfrmMain.mniViewRemoveFromSelectedClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  i                           : Integer;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then
    for i := Low(ActiveRecords) to High(ActiveRecords) do begin
      Element := NodeDatas[i].Element;
      if Assigned(Element) and Element.IsRemovable then begin
        if not EditWarn then
          Exit;
        Element.Remove;
        (ActiveRecords[i].Element as IwbMainRecord).UpdateRefs;
        Element := nil;
      end;
    end;
  PostResetActiveTree;
  InvalidateElementsTreeView(NoNodes);
end;

function CompareViewRow(List: TStringList; Index1, Index2: Integer): Integer;
var
  SortKey1, SortKey2          : string;
  Order1, Order2              : Integer;
begin
  SortKey1 := List[Index1];
  SortKey2 := List[Index2];

  if SortKey1 = '' then begin
    if SortKey2 = '' then begin
      Result := 0;
    end
    else begin
      Result := 1;
    end;
  end
  else begin
    if SortKey2 = '' then begin
      Result := -1;
    end
    else begin
      Result := CompareStr(SortKey1, SortKey2);
    end;
  end;

  if Result = 0 then begin
    Order1 := Integer(List.Objects[Index1]);
    Order2 := Integer(List.Objects[Index2]);
    Result := CmpI32(Order1, Order2);
  end;
end;

procedure TfrmMain.mniViewSortClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  sl                          : TStringList;
  i                           : integer;
  Element                     : IwbElement;
  Recs                        : TDynMainRecords;
  OffsetXY                    : TPoint;
begin
  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);

  sl := TStringList.Create;
  try
    Assert(Length(ActiveRecords) = Length(CompareRecords));

    for i := Low(ActiveRecords) to High(ActiveRecords) do begin
      Element := NodeDatas[i].Element;
      if Assigned(Element) then
        sl.AddObject(Element.DisplaySortKey[True], Pointer(i))
      else
        sl.AddObject('', Pointer(i));
    end;

    Assert(Length(ActiveRecords) = sl.Count);

    sl.CustomSort(CompareViewRow);
    SetLength(Recs, Length(CompareRecords));
    for i := 0 to Pred(sl.Count) do
      Recs[i] := CompareRecords[Integer(sl.Objects[i])];
  finally
    sl.Free;
  end;

  vstView.BeginUpdate;
  try
    OffsetXY := vstView.OffsetXY;
    DoSetActiveRecord(Recs);
    vstView.OffsetXY := OffsetXY;
  finally
    vstView.EndUpdate;
  end;
end;

procedure TfrmMain.mniNavFilterRemoveClick(Sender: TObject);
begin
  vstNav.BeginUpdate;
  try
    ReInitTree(False, nil);
    vstNav.TreeOptions.AutoOptions := vstNav.TreeOptions.AutoOptions + [toAutoFreeOnCollapse];
  finally
    vstNav.EndUpdate;
  end;
end;

procedure TfrmMain.mniNavHeaderFilesClick(Sender: TObject);
var
  i: Integer;
begin
  UserWasActive := True;

  if mniNavHeaderFilesLoadOrder.Checked then
    i := 1
  else if mniNavHeaderFilesFileName.Checked then
    i := 2
  else
    i := 0;
  Settings.WriteInteger('Nav','FilesSort', i);
  Settings.UpdateFile;
  vstNav.Header.SortTree;
  vstNav.ScrollIntoView(vstNav.FocusedNode, True);
end;

procedure TfrmMain.mniNavHiddenClick(Sender: TObject);
var
  Nodes                       : TNodeArray;
  NodeData                    : PNavNodeData;
  i                           : Integer;
begin
  UserWasActive := True;

  Nodes := vstNav.GetSortedSelection(True);
  for i := Low(Nodes) to High(Nodes) do begin
    NodeData := vstNav.GetNodeData(Nodes[i]);
    if Assigned(NodeData) and Assigned(NodeData.Element) then begin
      if mniNavHidden.Checked then
        NodeData.Element.Hide
      else
        NodeData.Element.Show;
      NodeData.ConflictAll := caUnknown;
      NodeData.ConflictThis := ctUnknown;
      vstNav.InvalidateNode(Nodes[i]);
    end;
  end;
  PostResetActiveTree;
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniBtnShrinkButtonsClick(Sender: TObject);
begin
  wbShrinkButtons := not wbShrinkButtons;

  if (Settings <> nil) then begin
    Settings.WriteBool('Options', 'ShrinkButtons', wbShrinkButtons);
    Settings.UpdateFile;
  end;

  if wbShrinkButtons then ShrinkButtons else ExpandButtons;
end;

function TfrmMain.GetFocusedNavElementSafely: IwbElement;
begin
  Result := nil;

  var NodeData: PNavNodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if not Assigned(NodeData) then
    Exit;

  Result := NodeData.Element;
end;

function TfrmMain.GetFocusedViewElementSafely: IwbElement;
begin
  Result := nil;

  var NodeDatas: PViewNodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if not Assigned(NodeDatas) then
    Exit;

  var FocusedColumn := FocusedColumnOverride;
  if FocusedColumn < 0 then
    FocusedColumn := vstView.FocusedColumn;
  if Length(ActiveRecords) = 1 then
    FocusedColumn := 1;

  Result := nil;
  if (FocusedColumn > 0) and (Pred(FocusedColumn) <= High(ActiveRecords)) then
    Result := NodeDatas[Pred(FocusedColumn)].Element;

  if not Assigned(Result) then
    for var i := Low(ActiveRecords) to High(ActiveRecords) do
    begin
      Result := NodeDatas[i].Element;
      if Assigned(Result) then
        Break;
    end;
end;

procedure TfrmMain.mniCopyDisplayNameToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.DisplayName[True];
end;

procedure TfrmMain.mniCopyFullPathToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.FullPath;
end;

procedure TfrmMain.mniCopyIndexedPathToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.IndexedPath[False];
end;

procedure TfrmMain.mniCopyNameToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.Name;
end;

procedure TfrmMain.mniCopyPathNameToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.PathName;
end;

procedure TfrmMain.mniCopyPathToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.Path;
end;

procedure TfrmMain.mniCopyShortNameToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if Assigned(Element) then
    Clipboard.AsText := Element.ShortName;
end;

procedure TfrmMain.mniCopySignatureToClipboardClick(Sender: TObject);
begin
  var Element := GetFocusedViewElementSafely;
  if not Assigned(Element) then
    Exit;

  var SubRecord: IwbSubRecord := nil;
  if Supports(Element, IwbSubRecord, SubRecord) then
    Clipboard.AsText := string(SubRecord.Signature);
end;

procedure TfrmMain.mniCreateNewFileClick(Sender: TObject);
begin
  AddNewFileWithDialog;
end;

procedure TfrmMain.mniMainLocalizationEditorClick(Sender: TObject);
begin
  if not Assigned(wbLocalizationHandler) then
    Exit;

  with TfrmLocalization.Create(Self) do try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmMain.mniMainLocalizationLanguageClick(Sender: TObject);
var
  i: integer;
  s: string;
begin
  if not Assigned(wbLocalizationHandler) then
    Exit;

  s := StringReplace(TMenuItem(Sender).Caption, '&', '', []);

  if wbLanguage = s then
    Exit;

  wbLanguage := s;

  wbLocalizationHandler.Clear;
  for i := Low(Files) to High(Files) do
    if Files[i].IsLocalized then
      wbLocalizationHandler.LoadForFile(Files[i].FileName);

  vstNav.Invalidate;
  vstView.Invalidate;
end;

procedure TfrmMain.mniNavLocalizationSwitchClick(Sender: TObject);

  procedure GatherLStrings(const aElement: IwbElement; var lst: TDynElements);
  var
    Container  : IwbContainerElementRef;
    i          : Integer;
  begin
    if Assigned(aElement.ValueDef) and (aElement.ValueDef.DefType = dtLString) then begin
      SetLength(lst, Succ(Length(lst)));
      lst[High(lst)] := aElement;
      //wbProgress('LString found in : ' + aElement.FullPath);
    end;
    if Supports(aElement, IwbContainerElementRef, Container) then
      for i := Pred(Container.ElementCount) downto 0 do
        GatherLStrings(Container.Elements[i], lst);
  end;

var
  NodeData            : PNavNodeData;
  _File               : IwbFile;
  i, j, Translated    : integer;
  ID                  : Cardinal;
  StartTick           : UInt64;
  Element             : IwbElement;
  lstrings            : TDynElements;
  fLocalize, ok       : boolean;
  fTranslate          : boolean;
  s                   : string;
  lFiles              : TStringList;
  lFrom, lTo          : TwbFastStringList;
  wblf                : TwbLocalizationFile;
begin
  if not wbEditAllowed then
    Exit;

  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);

  if not Assigned(NodeData) then
    Exit;

  if not Supports(NodeData.Element, IwbFile, _File) then
    Exit;

  lFiles := TStringList.Create;
  try
    fLocalize := not _File.IsLocalized;
    fTranslate := false;
    Translated := 0;

    if fLocalize then begin

      with TfrmLocalizePlugin.Create(Self) do try

        wbLocalizationHandler.AvailableLocalizationFiles(lFiles);
        clbFrom.Items.AddStrings(lFiles);
        clbTo.Items.AddStrings(lFiles);

        if ShowModal <> mrOk then
          Exit;

        fTranslate := cbTranslation.Checked;

        if fTranslate then
          for i := 0 to Pred(lFiles.Count) do begin
            j := 0;
            if clbFrom.Checked[i] then j := j or 1;
            if clbTo.Checked[i] then j := j or 2;
            lFiles.Objects[i] := Pointer(j);
          end;

      finally
        Free;
      end;

    end;

    if not EditWarn then
      Exit;

    ok := false;

    try
      if fLocalize then
        Caption := 'Localizing Records. Please wait...'
      else
        Caption := 'Delocalizing Records. Please wait...';
      pgMain.ActivePage := tbsMessages;

      StartTick := GetTickCount64;
      wbStartTime := Now;
      pnlClient.Enabled := false;
      UpdatePnlCancelVisible;

      if fTranslate then begin
        PostAddMessage('[Processing] Building translation index...');

        lFrom := TwbFastStringList.Create;
        lTo := TwbFastStringList.Create;

        for i := 0 to Pred(lFiles.Count) do begin
          if Integer(lFiles.Objects[i]) and 1 > 0 then begin
            wblf := TwbLocalizationFile.Create(wbLocalizationHandler.StringsPath + lFiles[i]);
            for j := 0 to Pred(wblf.Count) do
              lFrom.Add(AnsiLowerCase(wblf.Items[j]));
            wblf.Destroy;
          end;

          if Integer(lFiles.Objects[i]) and 2 > 0 then begin
            wblf := TwbLocalizationFile.Create(wbLocalizationHandler.StringsPath + lFiles[i]);
            lTo.AddStrings(wblf.Items);
            wblf.Destroy;
          end;
        end;

        if lFrom.Count <> lTo.Count then begin
          PostAddMessage('[Error] Number of strings in vocabulary does not match. Check parameters and run again.');
          Exit;
        end;
      end;

      PostAddMessage('[Processing] Collecting localizable values...');
      GatherLStrings(_File, lstrings);

      PostAddMessage('[Processing] Performing operation...');
      for i := Low(lstrings) to High(lstrings) do begin

        Element := lstrings[i];
        if fLocalize then begin
          s := Element.EditValue;
          if fTranslate then begin
            j := lFrom.IndexOf(AnsiLowerCase(s));
            if j <> -1 then begin
              s := lTo[j];
              Inc(Translated);
            end else
              // count empty strings as translated too
              if s = '' then Inc(Translated);
          end;
          ID := wbLocalizationHandler.AddValue(s, Element);
          Element.EditValue := sStringID + IntToHex(ID, 8);
        end else begin
          s := Element.EditValue;
          wbLocalizationHandler.NoTranslate := true;
          Element.EditValue := s;
          wbLocalizationHandler.NoTranslate := false;
        end;

        if StartTick + 500 < GetTickCount64 then begin
          DoProcessMessages;
          StartTick := GetTickCount64;
        end;

      end;

      _File.IsLocalized := not _File.IsLocalized;

      vstNav.Invalidate;
      ok := true;

    finally
      if fLocalize and fTranslate then begin
        FreeAndNil(lFrom);
        FreeAndNil(lTo);
      end;

      wbLocalizationHandler.NoTranslate := false;
      pnlClient.Enabled := true;
      UpdatePnlCancelVisible;
      PostAddMessage('[Processing done] ' +
        ' Localizable Strings: ' + IntToStr(Length(lstrings)) +
        ' Translated: ' + IntToStr(Translated) +
        ' Elapsed Time: ' + wbFormatElapsedTime( Now - wbStartTime));
      Caption := Application.Title;

      // that "(de)localization" is a very dirty hack which can probably lead
      // to problems if user continues to work with a plugin, so
      // immediately force a "save changes" window and quit.
      if ok then Close;
    end;
  finally
    lFiles.Free;
  end;
end;

procedure TfrmMain.mniNavLogAnalyzerClick(Sender: TObject);
begin
  with TfrmLogAnalyzer.Create(Self) do begin
    Caption := StringReplace((Sender as TMenuItem).Caption, '&', '', [rfReplaceAll]);
    lDataPath := wbDataPath;
    lMyGamesTheGamePath := wbMyGamesTheGamePath;
    PFiles := @Files;
    JumpTo := frmMain.JumpTo;
    ltLog := TLogType(TMenuItem(Sender).Tag);
    Show;
  end;
end;

procedure TfrmMain.mniNavMarkModifiedClick(Sender: TObject);
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  Selection                   : TNodeArray;
  ContainsChilds              : Boolean;
begin
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  UserWasActive := True;

  Selection := EditableSelection(@ContainsChilds);

  if Length(Selection) < 1 then
    Exit;

  if not EditWarn then
    Exit;

  PerformLongAction('Mark Modified', '', procedure
  var
    i                           : Integer;
  begin
    for i := Low(Selection) to High(Selection) do begin
      NodeData := vstNav.GetNodeData(Selection[i]);
      Element := NodeData.Element;
      if Assigned(Element) then
        Element.MarkModifiedRecursive(AllElementTypes);
    end;
  end);
  InvalidateElementsTreeView(NoNodes);
end;

procedure TfrmMain.mniNavRenumberFormIDsFromClick(Sender: TObject);

var
  SourceFile    : IwbFile;
  TargetFile    : IwbFile;
  MainRecords   : TDynMainRecords;
  TargetFormIDs : TArray<TwbFormID>;
  HighFormID    : TwbFormID;

  function Prepare: Boolean;
  var
    s            : string;
    Nodes        : TNodeArray;
    NodeData     : PNavNodeData;

    StartFormID  : TwbFormID;
    EndFormID    : TwbFormID;
    TakenFormIDs : array of Boolean;
    i, j, k      : Integer;
    c            : Cardinal;

    lMainRecords     : TDynMainRecords;
    MainRecord       : IwbMainRecord;
    TargetMainRecord : IwbMainRecord;

    NewFormID    : TwbFormID;
    OldFormID    : TwbFormID;

    PreserveObjectID : Boolean;
    AllOrNothing     : Boolean;
    AnyDelayed       : Boolean;
    TargetIsLight      : Boolean;
    PreservedCount   : Integer;

    Signatures       : TStringList;

    LowestFormID     : Cardinal;
  begin
    LowestFormID := $800;

    Result := False;

    if not wbEditAllowed then
      Exit;
    if wbTranslationMode then
      Exit;

    SourceFile := nil;

    Nodes := vstNav.GetSortedSelection(True);
    if (Length(Nodes) <> 1) then
      Exit;

    NodeData := vstNav.GetNodeData(Nodes[0]);
    if not Assigned(NodeData) then
      Exit;
    if not Assigned(NodeData.Element) then
      Exit;
    if not Supports(NodeData.Element, IwbFile, SourceFile) then
      Exit;

    if lblFilterHint.Visible then begin
      ShowMessage('Please ensure the treeview is not fossilized (remove the filter) before using this function.');
      Exit;
    end;

    if not EditWarn then
      Exit;

    PreserveObjectID := False;
    AllOrNothing := False;

    if Sender = mniNavRenumberFormIDsInject then begin
      with TfrmModuleSelect.Create(Self) do try
        AllModules := wbModulesByLoadOrder.FilteredByFlag(mfValid);
        AllModules.ExcludeAll(mfTagged);
        for i := 0 to Pred(SourceFile.MasterCount[True]) do
          with SourceFile.Masters[i, True] do
            include(PwbModuleInfo(ModuleInfo).miFlags, mfTagged);
        AllModules := AllModules.FilteredByFlag(mfTagged);
        AllModules.ExcludeAll(mfTagged);
        SelectFlag := mfTagged;
        FilterFlag := mfHasFile;
        MinSelect := 1;
        MaxSelect := 1;
        AllowCancel;
        Caption := 'Please select the master you want to inject new records into...';
        if ShowModal <> mrOk then
          Exit;
        TargetFile := SelectedModules[0]._File;

        if MessageDlg('Do you want to try and preserve ObjectIDs?', mtConfirmation, mbYesNo, 0, mbNo) = mrYes then
          PreserveObjectID := True;
        if PreserveObjectID then
          if MessageDlg('Do you want to abort if not all ObjectIDs can be preserved?', mtConfirmation, mbYesNo, 0, mbYes) = mrYes then
            AllOrNothing := True;
      finally
        Free;
      end;


    end else
      TargetFile := SourceFile;

    if TargetFile.IsOverlay then begin
      ShowMessage('"'+TargetFile.Name+'" is an overlay module and can''t own any records.');
      Exit;
    end;

    if TargetFile.AllowHardcodedRangeUse then
      LowestFormID := 1;

    if AllOrNothing or (Sender = mniNavCompactFormIDs) then
      StartFormID := TwbFormID.FromCardinal(LowestFormID)
    else begin
      s := '';
      TargetIsLight := TargetFile.IsLight or TargetFile.LoadOrderFileID.IsLightSlot;
      repeat
        if s <> '' then
          ShowMessage('"'+s+'" is not a valid start FormID.')
        else begin
          c := TargetFile.NextObjectID and $FFFFFF;
          if TargetIsLight then
            c := c and $FFF;
          if c < LowestFormID then
            c := LowestFormID;
          if TargetIsLight then
            s := IntToHex(c, 3)
          else
            s := IntToHex(c, 6);
        end;

        if TargetIsLight then begin
          if not InputQuery('Start from...', 'Please enter the new module specific start FormID in hex. e.g. 800. Specify only the last 3 digits. (Target is Light)', s) then
            Exit;
        end else begin
          if not InputQuery('Start from...', 'Please enter the new module specific start FormID in hex. e.g. 200000. Specify only the last 6 digits.', s) then
            Exit;
        end;

        StartFormID := TwbFormID.FromStrDef(s, 0);
      until (StartFormID.FileID.FullSlot = 0) and not (StartFormID.ToCardinal < LowestFormID) and (not TargetIsLight or (StartFormID.ObjectID <= $FFF));
    end;

    SetLength(MainRecords, SourceFile.RecordCount);
    j := 0;
    for i := Pred(SourceFile.RecordCount) downto 0 do begin
      MainRecords[j] := SourceFile.Records[i];
      if MainRecords[j].LoadOrderFormID.FileID = SourceFile.LoadOrderFileID then
        Inc(j);
    end;
    if j < 1 then begin
      ShowMessage('Nothing to do.');
      Exit;
    end;

    SetLength(MainRecords, j);

    TakenFormIDs := nil;
    SetLength(TakenFormIDs, j);

    StartFormID.FileID := TargetFile.LoadOrderFileID;
    HighFormID := StartFormID;
    if Sender = mniNavCompactFormIDs then
      EndFormID := TwbFormID.FromCardinal($FFF).ChangeFileID(TargetFile.LoadOrderFileID)
    else if not TargetFile.Equals(SourceFile) then begin
      if TargetFile.IsLight then
        EndFormID := TwbFormID.FromCardinal($FFF).ChangeFileID(TargetFile.LoadOrderFileID)
      else
        EndFormID := TwbFormID.FromCardinal($FFFFFF).ChangeFileID(TargetFile.LoadOrderFileID);
    end else begin
      EndFormID := StartFormID + j;
      HighFormID := EndFormID;
    end;

    if TargetFile.Equals(SourceFile) then
      for i := Low(MainRecords) to High(MainRecords) do begin
        OldFormID := MainRecords[i].LoadOrderFormID;
        if (OldFormID >= StartFormID) and (OldFormID <= EndFormID) then begin
          j := OldFormID - StartFormID;
          if j > High(TakenFormIDs) then
            SetLength(TakenFormIDs, Succ(j));
          TakenFormIDs[j] := True;
        end;
      end;

    Signatures := TStringList.Create;
    try
      Signatures.Sorted := True;
      Signatures.Duplicates := dupIgnore;
      Signatures.Delimiter := ' ';

      AnyDelayed := False;
      PreservedCount := 0;
      SetLength(lMainRecords, Length(MainRecords));
      SetLength(TargetFormIDs, Length(MainRecords));
      j := 0;
      i := 0;
      for k := High(MainRecords) downto Low(MainRecords) do begin
        MainRecord := MainRecords[k];
        OldFormID := MainRecord.LoadOrderFormID;

        if TargetFile.Equals(SourceFile) then begin
          if (OldFormID >= StartFormID) and (OldFormID <= EndFormID) then
            Continue;

          while (j <= High(TakenFormIDs)) and TakenFormIDs[j] do
            Inc(j);
          NewFormID := StartFormID + j;
          Inc(j);
        end else begin
          NewFormID := TwbFormID.Null;
          TargetMainRecord := nil;
          repeat
            if PreserveObjectID then begin
              if NewFormID.IsNull then
                NewFormID := OldFormID.ChangeFileID(TargetFile.LoadOrderFileID)
              else
                if AllOrNothing then begin
                  ShowMessage(Format('The FormID [%s] which should be assigned to: ' + CRLF + CRLF +
                    '%s' + CRLF + CRLF +
                    'is already in use by:' + CRLF + CRLF +
                    '%s' + CRLF + CRLF +
                    'Operation aborted.', [NewFormID.ToString, MainRecord.Name, TargetMainRecord.Name]));
                  Exit;
                end else begin
                  NewFormID := TwbFormID.Null;
                  AnyDelayed := True;
                  Break;
                end;
            end else begin
              NewFormID := StartFormID + j;
              Inc(j);
            end;
            TargetMainRecord := TargetFile.ContainedRecordByLoadOrderFormID[NewFormID, True];
          until not Assigned(TargetMainRecord);
          TargetMainRecord := nil;
        end;

        if NewFormID > EndFormID then begin
          ShowMessage('The file contains too many new records for this operation.');
          Exit;
        end;

        if NewFormID > HighFormID then
          HighFormID := NewFormID;

        if NewFormID = OldFormID then
          Continue;

        if PreserveObjectID and not NewFormID.IsNull then
          Inc(PreservedCount);

        lMainRecords[i] := MainRecord;
        TargetFormIDs[i] := NewFormID;
        if Assigned(MainRecord) then
          Signatures.Add(MainRecord.Signature);
        Inc(i);
      end;

      SetLength(lMainRecords, i);
      SetLength(TargetFormIDs, i);
      MainRecords := lMainRecords;

      if AnyDelayed then
        for k := Low(MainRecords) to High(MainRecords) do begin
          if not TargetFormIDs[k].IsNull then
            Continue;

          repeat
            NewFormID := StartFormID + j;
            Inc(j);
          until not Assigned(TargetFile.ContainedRecordByLoadOrderFormID[NewFormID, True]);

          if NewFormID > EndFormID then begin
            ShowMessage('The file contains too many new records for this operation.');
            Exit;
          end;

          if NewFormID > HighFormID then
            HighFormID := NewFormID;
          TargetFormIDs[k] := NewFormID;
        end;

      Result := i > 0;
      if not Result then
        ShowMessage('Nothing to do.')
      else begin
        s := '';
        if PreserveObjectID and not AllOrNothing then begin
          case PreservedCount of
            0 : s := ' No ObjectIDs could be preserved.';
            1 : s := ' 1 ObjectID could be preserved.';
          else
            if PreservedCount = Length(MainRecords) then
              s := ' All ObjectIDs could be preserved.'
            else
              s := ' ' + PreservedCount.ToString + ' ObjectIDs could be preserved.';
          end;
        end;
        Result := MessageDlg('This operation will modify the FormID of '+i.ToString+' record(s).' + s + CRLF +
          'Record(s) with the following signature(s) are affected: ' + Signatures.DelimitedText + CRLF + CRLF +
          'WARNING: This will break existing save games that contain these FormID(s) and any module which uses "'+ SourceFile.FileName +'" as master and references them.' + CRLF + CRLF +
          'Are you sure you wish to continue?', mtWarning, mbYesNo, 0, mbNo) = mrYes;
      end;

      if Result then
        vstNav.Expanded[Nodes[0]] := False;
    finally
      Signatures.Free;
    end;
  end;

  procedure UpdateNextObjectID;
  begin
    if TargetFile.IsEditable then begin
      Inc(HighFormID);
      TargetFile.NextObjectID := HighFormID.ObjectID;
    end;
  end;

begin
  if Prepare then begin
    SourceFile.BuildOrLoadRef(False);
    PerformLongAction('Changing FormIDs', 'Processed Records: 0', procedure
    var
      AnyErrors                   : Boolean;
      i,  k, l                    : Integer;
      MainRecord                  : IwbMainRecord;
      ReferencedBy                : TDynMainRecords;
      Master                      : IwbMainRecord;
      Overrides                   : TDynMainRecords;
      NewFormID                   : TwbFormID;
      OldFormID                   : TwbFormID;
    begin
      AnyErrors := False;
      for k := Low(MainRecords) to High(MainRecords) do begin
        MainRecord := MainRecords[k];
        OldFormID := MainRecord.LoadOrderFormID;
        NewFormID := TargetFormIDs[k];

        wbProgress('Changing FormID ['+OldFormID.ToString(True)+'] in file "'+MainRecord._File.FileName+'" to ['+NewFormID.ToString(True)+']');

        Master := MainRecord.MasterOrSelf;
        SetLength(ReferencedBy, Master.ReferencedByCount);
        for i := 0 to Pred(Master.ReferencedByCount) do
          ReferencedBy[i] := Master.ReferencedBy[i];

        try
          SetLength(Overrides, MainRecord.OverrideCount);
          for l := 0 to Pred(MainRecord.OverrideCount) do
            Overrides[l] := MainRecord.Overrides[l];

          MainRecord.LoadOrderFormID := NewFormID;
          if Length(Overrides) > 0 then begin
            wbProgress('Record has '+Length(Overrides).ToString+' override(s)');
            for l := Low(Overrides) to High(Overrides) do
              Overrides[l].LoadOrderFormID := NewFormID;
          end;

          Overrides := nil;

          wbTick;

          if Length(ReferencedBy) > 0 then begin
            wbProgress('Record is referenced by '+Length(ReferencedBy).ToString+' other record(s)');
            ShowChangeReferencedBy(OldFormID, NewFormID, ReferencedBy, True );
          end;
        except
          on E: Exception do begin
            wbProgress('Error: ' + E.Message);
            AnyErrors := True;
          end;
        end;

        wbCurrentProgress := 'Processed Records: ' + k.ToString;
      end;
      if AnyErrors then begin
        pgMain.ActivePage := tbsMessages;
        wbProgress('!!! Errors have occured. It is highly recommended to exit without saving as partial changes might have occured !!!');
      end;
    end);
    UpdateNextObjectID;
    vstNav.Invalidate;
  end;
end;

function IsMasterTemporary(MainRecord: IwbMainRecord): Boolean;
begin
  Result :=
    not MainRecord.IsMaster and
    not MainRecord.Master.IsPersistent;
end;

function IsPositionChanged(MainRecord: IwbMainRecord): Boolean;
var
  Master    : IwbMainRecord;
  MasterPos : IwbRecord;
  ThisPos   : IwbRecord;
begin
  Result := False;
  if MainRecord.ConflictThis in [ctMaster, ctIdenticalToMaster] then
    Exit;
  if MainRecord.IsMaster then
    Exit;
  if MainRecord.Flags.IsDeleted then
    Exit;
  Master := MainRecord.Master;
  if not Assigned(Master) then
    Exit;
  MasterPos := Master.RecordBySignature['DATA'];
  ThisPos := MainRecord.RecordBySignature['DATA'];

  if Assigned(MasterPos) <> Assigned(ThisPos) then begin
    Result := True;
    Exit;
  end;

  if not Assigned(MasterPos) then
    Exit;

  Result := MasterPos.DisplaySortKey[True] <> ThisPos.DisplaySortKey[True];
end;

function IsUnnecessaryPersistent(MainRecord: IwbMainRecord): Boolean;
var
  NAME       : IwbRecord;
  BaseRecord : IwbMainRecord;
begin
  if MainRecord.Flags.IsDeleted then begin
    Result := IsMasterTemporary(MainRecord);
    Exit;
  end;

  Result := False;
  if MainRecord.Signature <> 'REFR' then
    Exit;
  if MainRecord.EditorID <> '' then
    Exit;
  if MainRecord.ReferencedByCount > 0 then
    Exit;

  if Assigned(MainRecord.RecordBySignature['XESP']) then
    Exit;
  if Assigned(MainRecord.RecordBySignature['XLOC']) then
    Exit;
  if Assigned(MainRecord.ElementByName['Map Marker']) then
    Exit;
  if Assigned(MainRecord.RecordBySignature['XRTM']) then
    Exit;
  if Assigned(MainRecord.RecordBySignature['XTEL']) then
    Exit;


  NAME := MainRecord.RecordBySignature['NAME'];
  if not Assigned(NAME) then
    Exit;

  if not Supports(NAME.LinksTo, IwbMainRecord, BaseRecord) then
    Exit;

  if Assigned(BaseRecord.RecordBySignature['SCRI']) then
    Exit;

  if BaseRecord.Signature = 'CONT' then
    Exit;

  if BaseRecord.Signature = 'SBSP' then
    Exit;

  Result := True;
end;

procedure TfrmMain.mniNavFilterApplyClick(Sender: TObject);
type
  TCheckFilterNode = reference to function(aCheckConflict: Boolean): Boolean;
var
  Node, NextNode              : PVirtualNode;
  FileNode, NextFileNode      : PVirtualNode;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  BaseRecord                  : IwbMainRecord;
  _File                       : IwbFile;
  MainRecordCount             : Cardinal;
  StartTick                   : UInt64;
  Signatures                  : TStringList;
  SignaturesCreated           : Boolean;
  BaseSignatures              : TStringList;

  TopLevelGroups              : TStringList;

  FilterByBaseFormID          : Boolean;
  FilterBaseFormID            : TwbFormID;

  Dummy                       : Integer;
  Rec                         : IwbRecord;
  GroupRecord                 : IwbGroupRecord;
  i, j                        : Integer;

  PersCellChecked             : Boolean;
  PersCellNode                : PVirtualNode;

  Node2, NextNode2            : PVirtualNode;
  NodeData2                   : PNavNodeData;
  MainRecord2                 : IwbMainRecord;
  FoundAny                    : Boolean;
  GridCell                    : TwbGridCell;
  Position                    : TwbVector;

  Cells                       : array of array of array of PVirtualNode;
  FileFiltered                : array of Integer;

  PotentiallyUnfilteredRefs : Boolean;

  FilterRequiresMainRecord    : Boolean;
  FilterRequiresBaseRecord    : Boolean;
  FilterRequiresReference     : Boolean;
  FilterByStatus              : Boolean;
  FilterByAnythingNotConflict : Boolean;

  CheckFilterNode             : TCheckFilterNode;

  MainRecordDef: PwbMainRecordDef;
  HasACHR, HasACRE, HasREFR: Boolean;

  FilterFiles : TwbFiles;
begin
  Signatures := nil;
  BaseSignatures := nil;
  TopLevelGroups := nil;
  FilterFiles := nil;

  PersCellNode := nil;
  PersCellChecked := False;

  if not FilterPreset then begin

    with TfrmFilterOptions.Create(nil) do try
      SetSettings(Settings);

      cbByNotReachableStatus.Enabled := ReachableBuild;

      if ShowModal <> mrOk then
        Exit;

      FilterConflictAll := cbConflictAll.Checked;
      FilterConflictThis := cbConflictThis.Checked;

      FilterByInjectStatus := cbByInjectionStatus.Checked;
      FilterInjectStatus := cbInjected.Checked;

      FilterByNotReachableStatus := cbByNotReachableStatus.Checked;
      FilterNotReachableStatus := cbNotReachable.Checked;

      FilterByReferencesInjectedStatus := cbByReferencesInjectedStatus.Checked;
      FilterReferencesInjectedStatus := cbReferencesInjected.Checked;

      FilterByEditorID := cbByEditorID.Checked;
      FilterEditorID := edEditorID.Text;

      FilterByElementValue := cbByElementValue.Checked;
      FilterElementValue := edElementValue.Text;

      FilterByName := cbByName.Checked;
      FilterName := edName.Text;

      FilterByBaseEditorID := cbByBaseEditorID.Checked;
      FilterBaseEditorID := edBaseEditorID.Text;

      FilterByBaseName := cbByBaseName.Checked;
      FilterBaseName := edBaseName.Text;

      FilterScaledActors := cbScaledActors.Checked;

      FilterByPersistent := cbByPersistent.Checked;
      FilterPersistent := cbPersistent.Checked;
      FilterUnnecessaryPersistent := cbUnnecessaryPersistent.Checked;
      FilterMasterIsTemporary := cbMasterIsTemporary.Checked;
      FilterIsMaster := cbIsMaster.Checked;
      FilterPersistentPosChanged := cbPersistentPosChanged.Checked;

      FilterDeleted := cbDeleted.Checked;

      FilterByVWD := cbByVWD.Checked;
      FilterVWD := cbVWD.Checked;

      FilterByHasVWDMesh := cbByHasVWDMesh.Checked;
      FilterHasVWDMesh := cbHasVWDMesh.Checked;

      FilterByHasPrecombinedMesh := cbByHasPrecombinedMesh.Checked;
      FilterHasPrecombinedMesh := cbHasPrecombinedMesh.Checked;

      FilterBySignature := cbRecordSignature.Checked;
      FilterSignatures := RecordSignatures;

      FilterByBaseSignature := cbBaseRecordSignature.Checked;
      FilterBaseSignatures := BaseRecordSignatures;

      FilterConflictAllSet := [];
      for i := 0 to Pred(clbConflictAll.Items.Count) do
        if clbConflictAll.Checked[i] then
          Include(FilterConflictAllSet, TConflictAll(Succ(i)));

      FilterConflictThisSet := [];
      for i := 0 to Pred(clbConflictThis.Items.Count) do
        if clbConflictThis.Checked[i] then
          Include(FilterConflictThisSet, TConflictThis(i + 2));

      FlattenBlocks := cbFlattenBlocks.Checked;
      FlattenCellChilds := cbFlattenCellChilds.Checked;
      AssignPersWrldChild := cbAssignPersWrldChild.Checked;
      InheritConflictByParent := cbInherit.Checked;
    finally
      Free;
    end;

  end;

  if FilterConflictAll then
    if FilterConflictAllSet = [Low(TConflictAll)..High(TConflictAll)] then
      FilterConflictAll := False;

  if FilterConflictThis then
    if FilterConflictThisSet = [Low(TConflictThis)..High(TConflictThis)] then
      FilterConflictThis := False;

  SetLength(FileFiltered, Length(Files));

  if FilterByPersistent and FilterPersistent and FilterUnnecessaryPersistent then
    BuildAllRef;

  if FilterBySignature then begin
    Signatures := TStringList.Create;
    Signatures.CommaText := FilterSignatures;
    Signatures.Sorted := True;
    Signatures.Duplicates := dupIgnore;
  end;

  if FilterByBaseSignature then begin
    BaseSignatures := TStringList.Create;
    BaseSignatures.CommaText := FilterBaseSignatures;
    BaseSignatures.Sorted := True;
    BaseSignatures.Duplicates := dupIgnore;
  end;

  FilterByBaseFormID := False;
  if FilterByBaseEditorID  then begin
    FilterBaseFormID := TwbFormID.Null;
    if Length(FilterBaseEditorID) in [8,9] then try
      FilterBaseFormID := TwbFormID.FromStr(FilterBaseEditorID);
      // passed conversion, filter by base FormID
      FilterByBaseFormID := True;
      FilterByBaseEditorID := False;
    except
      // suppress conversion error
    end;
  end;

  if FilterScaledActors then
    if Assigned(BaseSignatures) then begin
      HasACHR := BaseSignatures.Find('ACHR', Dummy);
      HasACRE := BaseSignatures.Find('ACRE', Dummy);
      BaseSignatures.Clear;
      if HasACHR then
        BaseSignatures.Add('ACHR');
      if HasACRE then
        BaseSignatures.Add('ACRE');
    end else begin
      BaseSignatures := TStringList.Create;
      BaseSignatures.Add('ACHR');
      BaseSignatures.Add('ACRE');
      BaseSignatures.Sorted := True;
      BaseSignatures.Duplicates := dupIgnore;
    end;

  if FilterByHasVWDMesh then
    if Assigned(BaseSignatures) then begin
      HasREFR := BaseSignatures.Find('REFR', Dummy);
      BaseSignatures.Clear;
      if HasREFR then
        BaseSignatures.Add('REFR');
    end else begin
      BaseSignatures := TStringList.Create;
      BaseSignatures.Add('REFR');
      BaseSignatures.Sorted := True;
      BaseSignatures.Duplicates := dupIgnore;
    end;

  if Assigned(Signatures) or Assigned(BaseSignatures) then begin
    PotentiallyUnfilteredRefs := False;
    TopLevelGroups := TStringList.Create;
    TopLevelGroups.Sorted := True;
    TopLevelGroups.Duplicates := dupIgnore;

    if Assigned(BaseSignatures) then begin
      SignaturesCreated := not Assigned(Signatures);
      if SignaturesCreated then begin
        Signatures := TStringList.Create;
        Signatures.Sorted := True;
        Signatures.Duplicates := dupIgnore;
        for i := Pred(BaseSignatures.Count) downto 0 do
          if wbFindRecordDef(BaseSignatures[i], MainRecordDef) then
            for j := 0 to Pred(MainRecordDef^.ReferenceSignatureCount) do
              Signatures.Add(MainRecordDef^.ReferenceSignatures[j]);
      end else
        for i := Pred(Signatures.Count) downto 0 do begin
          FoundAny := False;
          if wbFindRecordDef(Signatures[i], MainRecordDef) then
            for j := 0 to Pred(MainRecordDef^.BaseSignatureCount) do
              if BaseSignatures.Find(MainRecordDef^.BaseSignatures[j], Dummy) then begin
                FoundAny := True;
                Break;
              end;
          if not FoundAny then
            Signatures.Delete(i);
        end;

      if Signatures.Count > 0 then begin
        PotentiallyUnfilteredRefs := True;
        TopLevelGroups.Add('CELL');
        TopLevelGroups.Add('WRLD');
      end;
    end else {Signatures must be assigned} begin
      TopLevelGroups.Assign(Signatures);

      //this could be done nicer if information about what groups contain which records is added to the definitions
      if not TopLevelGroups.Find('CELL', Dummy) then
        if TopLevelGroups.Find('LAND', Dummy) or
           TopLevelGroups.Find('PGRD', Dummy) or
           TopLevelGroups.Find('NAVM', Dummy) or
           TopLevelGroups.Find('REFR', Dummy) or
           TopLevelGroups.Find('PGRE', Dummy) or
           TopLevelGroups.Find('PMIS', Dummy) or
           TopLevelGroups.Find('ACRE', Dummy) or
           TopLevelGroups.Find('ACHR', Dummy) or
           TopLevelGroups.Find('PHZD', Dummy) or
           TopLevelGroups.Find('PARW', Dummy) or
           TopLevelGroups.Find('PBAR', Dummy) or
           TopLevelGroups.Find('PBEA', Dummy) or
           TopLevelGroups.Find('PCON', Dummy) or
           TopLevelGroups.Find('PFLA', Dummy) then
          TopLevelGroups.Add('CELL');

      if not TopLevelGroups.Find('WRLD', Dummy) then
        if TopLevelGroups.Find('ROAD', Dummy) or
           TopLevelGroups.Find('CELL', Dummy) then
          TopLevelGroups.Add('WRLD');

      if not TopLevelGroups.Find('DIAL', Dummy) then
        if TopLevelGroups.Find('INFO', Dummy) then
          TopLevelGroups.Add('DIAL');

      if wbVWDAsQuestChildren and not TopLevelGroups.Find('QUST', Dummy) then
        if TopLevelGroups.Find('DIAL', Dummy) or
           TopLevelGroups.Find('DLBR', Dummy) or
           TopLevelGroups.Find('SCEN', Dummy) then
          TopLevelGroups.Add('QUST');
    end;

    for i := Pred(TopLevelGroups.Count) downto 0 do
      if wbFindRecordDef(TopLevelGroups[i], MainRecordDef) then begin
        if MainRecordDef^.IsReference then
          PotentiallyUnfilteredRefs := True;
        //remove entries here that don't occur in top level groups, will require definitions update to have that information
      end;
  end else
    PotentiallyUnfilteredRefs := True;

  if not PotentiallyUnfilteredRefs then
    AssignPersWrldChild := False;

  FilterRequiresBaseRecord :=
    FilterByBaseEditorID or
    FilterByBaseName or
    FilterByHasVWDMesh;

  FilterRequiresReference :=
    FilterByBaseFormID or
    FilterRequiresBaseRecord or
    FilterScaledActors or
    FilterByPersistent or
    FilterByVWD or
    FilterByHasPrecombinedMesh or
    Assigned(BaseSignatures);

  FilterRequiresMainRecord :=
    FilterRequiresReference or
    FilterByEditorID or
    FilterByName or
    FilterByElementValue or
    Assigned(Signatures) or
    FilterDeleted or
    FilterScripted;

  FilterByStatus :=
    FilterByInjectStatus or
    FilterByReferencesInjectedStatus or
    FilterByNotReachableStatus;

  FilterByAnythingNotConflict :=
    FilterByStatus or
    FilterRequiresMainRecord;

  CheckFilterNode := function(aCheckConflict: Boolean): Boolean

    function CustomScriptFilter(MainRecord: IwbMainRecord): Boolean;
    begin
      Result :=
        Assigned(Script) and
        Script.FunctionExists('Filter') and
        Boolean(Script.CallFunction('Filter', [MainRecord]));
    end;

    function CheckContainerForElementValue(const aElement: IwbElement; const aValue: string): Boolean;
    var
      Container: IwbContainerElementRef;
      i: integer;
    begin
      Result := False;
      if not Assigned(aElement) then Exit;

      if not Supports(aElement, IwbContainerElementRef, Container) then Exit;

      if Container.ElementCount = 0 then
      begin
        if Pos(aValue, UpperCase(aElement.Value)) > 0 then
          Result := True;
      end
      else
        for i := 0 to Pred(Container.ElementCount) do
        begin
          Result := CheckContainerForElementValue(Container.Elements[i], aValue);
          if Result then Break;
        end;
    end;
  var
    i: Integer;
  begin
    Result := False;
    if Node.ChildCount = 0 then begin
      if nnfFilterChecked in NodeData.Flags then
        Exit;
      Include(NodeData.Flags, nnfFilterChecked);
      if
        (aCheckConflict and
          (
            (FilterConflictAll and not (NodeData.ConflictAll in FilterConflictAllSet)) or
            (FilterConflictThis and not (NodeData.ConflictThis in FilterConflictThisSet))
          )
        ) or
        (FilterByAnythingNotConflict and
          (
            (FilterByStatus and
              (
                (FilterByInjectStatus and ((nnfInjected in NodeData.Flags) <> FilterInjectStatus)) or
                (FilterByReferencesInjectedStatus and ((nnfReferencesInjected in NodeData.Flags) <> FilterReferencesInjectedStatus)) or
                (FilterByNotReachableStatus and ReachableBuild and ((nnfNotReachable in NodeData.Flags) <> FilterNotReachableStatus))
              )
            ) or

            (FilterRequiresMainRecord and
              (
                not Supports(NodeData.Element, IwbMainRecord, MainRecord) or
                (FilterRequiresReference and not MainRecord.Def.IsReference) or
                (FilterRequiresBaseRecord and not Supports(MainRecord.BaseRecord, IwbMainRecord, BaseRecord)) or

                (FilterDeleted and not MainRecord.IsDeleted) or
                (Assigned(Signatures) and not Signatures.Find(MainRecord.Signature, Dummy)) or
                (FilterByEditorID and (Pos(AnsiUpperCase(FilterEditorID), AnsiUpperCase(MainRecord.EditorID)) < 1)) or
                (FilterByName and (Pos(AnsiUpperCase(FilterName), AnsiUpperCase(MainRecord.DisplayName[True])) < 1)) or
                (FilterByElementValue and not CheckContainerForElementValue(MainRecord, UpperCase(FilterElementValue))) or

                (FilterRequiresReference and
                  (
                    (FilterByVWD and (MainRecord.IsVisibleWhenDistant <> FilterVWD)) or
                    (FilterByBaseFormID and (MainRecord.BaseRecordID <> FilterBaseFormID)) or
                    (Assigned(BaseSignatures) and not BaseSignatures.Find(MainRecord.BaseRecordSignature, Dummy)) or
                    (FilterScaledActors and //BaseSignatures will have been set that only actors get this far
                      (
                        not Supports(MainRecord.RecordBySignature['XSCL'], IwbRecord, Rec) or
                        SameValue(Rec.NativeValue, 1)
                      )
                    ) or

                    (FilterRequiresBaseRecord and
                      (
                        (FilterByBaseEditorID and (Pos(AnsiUpperCase(FilterBaseEditorID), AnsiUpperCase(BaseRecord.EditorID)) < 1)) or
                        (FilterByBaseName and (Pos(AnsiUpperCase(FilterBaseName), AnsiUpperCase(BaseRecord.DisplayName[True])) < 1)) or
                        (FilterByHasVWDMesh and (BaseRecord.HasVisibleWhenDistantMesh <> FilterHasVWDMesh))
                      )
                    ) or

                    (FilterByPersistent and
                      (
                        (MainRecord.IsPersistent <> FilterPersistent) or
                        (
                          FilterUnnecessaryPersistent and
                          (
                            not IsUnnecessaryPersistent(MainRecord) or
                            (
                              FilterMasterIsTemporary and
                              (
                                not IsMasterTemporary(MainRecord) and
                                not (FilterIsMaster and MainRecord.IsMaster)
                              )
                            )
                          )
                        ) or
                        (
                          FilterPersistentPosChanged and
                          not IsPositionChanged(MainRecord)
                        )
                      )
                    ) or
                    (FilterByHasPrecombinedMesh and (MainRecord.HasPrecombinedMesh <> FilterHasPrecombinedMesh))
                  )
                ) or
                (FilterScripted and not CustomScriptFilter(MainRecord))
              )
            )
          )
        )
        then begin
        vstNav.DeleteNode(Node);
        Result := True;
      end;
    end;
  end;

  vstNav.Visible:= False;
  try
    if (FilterConflictAll and (FilterConflictAllSet = [])) or
       (FilterConflictThis and (FilterConflictThisSet = [])) or
       (FilterRequiresBaseRecord and not PotentiallyUnfilteredRefs) or
       (Assigned(Signatures) and (Signatures.Count < 1)) or
       (Assigned(BaseSignatures) and (BaseSignatures.Count < 1)) or
       (Assigned(TopLevelGroups) and (TopLevelGroups.Count < 1)) then begin
      vstNav.Clear
    end else begin
      if (Sender = mniNavFilterApplySelected) or
         (Sender = mniNavFilterForCleaningSelected) or
         (Sender = mniNavFilterConflictsSelected) then begin

        with TfrmFileSelect.Create(Self) do try
          for i := Low(Files) to High(Files) do begin
            _File := Files[i];
            CheckListBox1.Items.AddObject(_File.Name, Pointer(_File));
            _File.ResetTags;
          end;

          wbCodeBlock(procedure
          var
            SelectedNodes : TNodeArray;
            NodeData      : PNavNodeData;
            i             : Integer;
          begin
            SelectedNodes := vstNav.GetSortedSelection(True);
            for i := Low(SelectedNodes) to High(SelectedNodes) do begin
              NodeData := vstNav.GetNodeData(SelectedNodes[i]);
              if Assigned(NodeData.Element) then
                NodeData.Element._File.Tag;
            end;
          end);

          for i := 0 to Pred(CheckListBox1.Items.Count) do
            CheckListBox1.Checked[i] := IwbFile(Pointer(CheckListBox1.Items.Objects[i])).IsTagged;

          Caption := 'What files should be added to the navigation treeview before applying the filter?';

          if ShowModal <> mrOk then
            Exit;

          for i := 0 to Pred(CheckListBox1.Items.Count) do
            if CheckListBox1.Checked[i] then
              FilterFiles.Add(IwbFile(Pointer(CheckListBox1.Items.Objects[i])));
        finally
          Free;
        end;

      end;
      PerformLongAction('Applying Filter', '[Pass 1] Processed Records: 0', procedure
      var
        i, j   : Integer;
        Count  : Cardinal;
        Count2 : Cardinal;
        CountUnfiltered : Cardinal;
        Master : IwbMainRecord;
      begin
        vstNav.BeginUpdate;
        try
          ReInitTree(FilterNoGameMaster or wbTranslationMode, FilterFiles);

          Count := 0;
          vstNav.TreeOptions.AutoOptions := vstNav.TreeOptions.AutoOptions - [toAutoFreeOnCollapse];

          if Assigned(TopLevelGroups) then begin
            FileNode := vstNav.GetLastChild(nil);
            while Assigned(FileNode) do begin
              NextFileNode := vstNav.GetPreviousSibling(FileNode);
              NodeData := vstNav.GetNodeData(FileNode);
              if Assigned(NodeData) and Assigned(NodeData.Element) and (NodeData.Element.ElementType = etFile) then begin
                Node := vstNav.GetLastChild(FileNode);
                while Assigned(Node) do begin
                  NextNode := vstNav.GetPreviousSibling(Node);
                  NodeData := vstNav.GetNodeData(Node);
                  if Assigned(NodeData) and Assigned(NodeData.Element) and (NodeData.Element.ElementType = etGroupRecord) then begin
                    GroupRecord := NodeData.Element as IwbGroupRecord;
                    if GroupRecord.GroupType = 0 then begin
                      if not TopLevelGroups.Find(GroupRecord.GroupLabelSignature, Dummy) then
                        vstNav.DeleteNode(Node);
                    end;
                  end;
                  Node := NextNode;
                end;
              end;
              FileNode := NextFileNode;
            end;
          end;

          Node := vstNav.GetLast(nil);
          while Assigned(Node) do begin
            wbCurrentProgress := '[Pass 1] Processed Records: ' + Count.ToString;
            Inc(Count);
            wbTick;

            NextNode := vstNav.GetPrevious(Node);
            NodeData := vstNav.GetNodeData(Node);
            FoundAny := False;

            if Assigned(NodeData.Element) then begin

              if NodeData.Element.ElementType = etMainRecord then begin
                MainRecord := NodeData.Element as IwbMainRecord;

                if FilterConflictOnly then
                  if (MainRecord.MasterOrSelf.OverrideCount < 2) and (Node.ChildCount = 0) then begin
                    //filter early, can't possibly have a conflict
                    vstNav.DeleteNode(Node);
                    Node := NextNode;
                    Continue;
                  end;

                if FilterOnlyOne and (Node.ChildCount = 0) then begin
                  Master := MainRecord.MasterOrSelf;
                  if Master.OverrideCount > 0 then begin
                    j := 0;
                    if not Master.IsHidden then
                      Inc(j);
                    for i := 0 to Pred(Master.OverrideCount) do
                      if not Master.Overrides[i].IsHidden then begin
                        Inc(j);
                        if j > 1 then
                          Break;
                      end;
                    if j > 1 then begin
                      //filter early, can't possibly have a conflict
                      vstNav.DeleteNode(Node);
                      Node := NextNode;
                      Continue;
                    end;
                  end;
                end;

                if MainRecord.IsInjected then
                  Include(NodeData.Flags, nnfInjected);
                if MainRecord.IsNotReachable then
                  Include(NodeData.Flags, nnfNotReachable);
                if MainRecord.ReferencesInjected then
                  Include(NodeData.Flags, nnfReferencesInjected);

                Exclude(NodeData.Flags, nnfFilterChecked);

                if not (FlattenCellChilds and AssignPersWrldChild and (MainRecord.Signature = 'CELL')) then
                  if CheckFilterNode(False) then begin
                    //filter early
                    Node := NextNode;
                    Continue;
                  end;

                if FilterConflictAll or FilterConflictThis or InheritConflictByParent then begin
                  ConflictLevelForMainRecord(MainRecord, NodeData.ConflictAll, NodeData.ConflictThis);
                  with NodeData^ do begin
                    OrgConflictAll  := ConflictAll;
                    OrgConflictThis := ConflictThis;
                  end;
                  if not (FlattenCellChilds and AssignPersWrldChild and (MainRecord.Signature = 'CELL')) then
                    if Node.ChildCount = 0 then
                      if (FilterConflictAll and not (NodeData.ConflictAll in FilterConflictAllSet)) or
                         (FilterConflictThis and not (NodeData.ConflictThis in FilterConflictThisSet)) then begin
                        //filter early
                        vstNav.DeleteNode(Node);
                        Node := NextNode;
                        Continue;
                      end;
                end;

                if FlattenCellChilds and AssignPersWrldChild then
                  if (MainRecord.Signature = 'WRLD') then begin
                    Cells := nil;
                    PersCellChecked := False;
                    PersCellNode := nil;
                  end else if (MainRecord.Signature = 'CELL') and
                    Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
                    case GroupRecord.GroupType of
                      5: begin {exterior cell}
                        if not PersCellChecked then begin
                          PersCellChecked := True;
                          PersCellNode := nil;
                          Cells := nil;

                          Node2 := Node.Parent;
                          if Assigned(Node2) then begin
                            NodeData2 := vstNav.GetNodeData(Node2);
                            if Assigned(NodeData2) and
                              Supports(NodeData2.Element, IwbGroupRecord, GroupRecord) and
                              (GroupRecord.GroupType = 5) then begin

                              Node2 := Node2.Parent;
                              if Assigned(Node2) then begin
                                NodeData2 := vstNav.GetNodeData(Node2);
                                if Assigned(NodeData2) and
                                  Supports(NodeData2.Element, IwbGroupRecord, GroupRecord) and
                                  (GroupRecord.GroupType = 4) then begin

                                  Node2 := Node2.Parent;
                                  if Assigned(Node2) then begin
                                    NodeData2 := vstNav.GetNodeData(Node2);
                                    if Assigned(NodeData2) and
                                      Supports(NodeData2.Element, IwbMainRecord, MainRecord2) and
                                      (MainRecord2.Signature = 'WRLD') then begin

                                      Node2 := vstNav.GetFirstChild(Node2);

                                      while Assigned(Node2) and not Assigned(PersCellNode) do begin
                                        NodeData2 := vstNav.GetNodeData(Node2);
                                        if Assigned(NodeData2) and
                                          Supports(NodeData2.Element, IwbMainRecord, MainRecord2) and
                                          (MainRecord2.Signature = 'CELL') then
                                          PersCellNode := Node2;

                                        Node2 := vstNav.GetNextSibling(Node2);
                                      end;

                                      if Assigned(PersCellNode) then begin
                                        Node2 := vstNav.GetFirstChild(PersCellNode);
                                        PersCellNode := nil;

                                        while Assigned(Node2) and not Assigned(PersCellNode) do begin
                                          NodeData2 := vstNav.GetNodeData(Node2);
                                          if Assigned(NodeData2) and
                                            Supports(NodeData2.Element, IwbGroupRecord, GroupRecord) and
                                            (GroupRecord.GroupType = 8) then begin
                                            PersCellNode := Node2;
                                            end;

                                          Node2 := vstNav.GetNextSibling(Node2);
                                        end;

                                        SetLength(Cells, 1000, 1000);

                                        Node2 := vstNav.GetLastChild(PersCellNode);
                                        while Assigned(Node2) do begin
                                          NextNode2 := vstNav.GetPreviousSibling(Node2);

                                          NodeData2 := vstNav.GetNodeData(Node2);
                                          if Assigned(NodeData2) and
                                            Supports(NodeData2.Element, IwbMainRecord, MainRecord2) and
                                            MainRecord2.GetPosition(Position) then begin

                                            GridCell := wbPositionToGridCell(Position);
                                            with GridCell do begin
                                              Inc(x, 500);
                                              Inc(y, 500);

                                              if (x >= Low(Cells)) and (x <= High(Cells)) and
                                                (y >= Low(Cells[x])) and (y <= High(Cells[x])) then begin

                                                SetLength(Cells[x,y], Succ(Length(Cells[x,y])));
                                                Cells[x,y, High(Cells[x,y])] := Node2;

                                              end;

                                            end;

                                          end;

                                          Node2 := NextNode2;
                                        end;
                                      end;
                                    end;
                                  end;
                                end;
                              end;
                            end;
                          end;
                        end;

                        if Assigned(PersCellNode) and MainRecord.GetGridCell(GridCell) then begin

                          with GridCell do begin
                            Inc(x, 500);
                            Inc(y, 500);

                            if (x >= Low(Cells)) and (x <= High(Cells)) and
                              (y >= Low(Cells[x])) and (y <= High(Cells[x])) then begin

                              for i := Low(Cells[x,y]) to High(Cells[x,y]) do begin

                                Node2 := Cells[x,y,i];
                                {NodeData2 :=} vstNav.GetNodeData(Node2);
                                vstNav.MoveTo(Node2, Node, amAddChildFirst, False);
                                if not FoundAny then begin
                                  FoundAny := True;
                                  NextNode := Node2;
                                end;
                              end;
                              Cells[x,y] := nil;

                            end;

                          end;
                        end;

                      end;
                  end;
              end else if NodeData.Element.ElementType = etGroupRecord then
                if Supports(NodeData.Element, IwbGroupRecord, GroupRecord) then
                  if GroupRecord.GroupType = 1 then begin
                    if Assigned(PersCellNode) then begin
                      PersCellChecked := False;
                      PersCellNode := nil;
                      Cells := nil;
                    end;
                  end;

              if FoundAny then begin
                Node := NextNode;
                Continue;
              end;

              if not (vsVisible in Node.States) then begin
                vstNav.DeleteNode(Node)
              end else if Node.ChildCount > 0 then begin
                if
                  (FlattenBlocks or FlattenCellChilds) and
                  Supports(NodeData.Element, IwbGroupRecord, GroupRecord) and
                  (
                    (FlattenBlocks and (GroupRecord.GroupType in [2..5])) or
                    (FlattenCellChilds and (GroupRecord.GroupType in [8..10]))
                  ) then begin

                  vstNav.MoveTo(Node, Node, amInsertBefore, True);
                  vstNav.DeleteNode(Node);

                end else
                  if InheritConflictByParent and (PersCellNode <> Node) then
                    InheritStateFromChildren(Node, NodeData);
              end else if NodeData.Element.Skipped then begin
                vstNav.DeleteNode(Node)
              end else if (FlattenBlocks or FlattenCellChilds) and
                      Supports(NodeData.Element, IwbGroupRecord, GroupRecord) and
                      (
                        (FlattenBlocks and (GroupRecord.GroupType in [2..5])) or
                        (FlattenCellChilds and (GroupRecord.GroupType in [8..10]))
                      ) then
                        vstNav.DeleteNode(Node);
            end else
              vstNav.DeleteNode(Node);

            Node := NextNode;
          end;


          Count2 := 0;
          CountUnfiltered := 0;
          MainRecordCount := 0;

          vstNav.TreeOptions.AutoOptions := vstNav.TreeOptions.AutoOptions - [toAutoFreeOnCollapse];
          Node := vstNav.GetLast(nil);
          while Assigned(Node) do begin
            NextNode := vstNav.GetPrevious(Node);
            NodeData := vstNav.GetNodeData(Node);
            if Assigned(NodeData) and Assigned(NodeData.Element) and (NodeData.Element.ElementType = etFile) then begin
              if MainRecordCount > 0 then begin
                _File := NodeData.Element._File;
                for i := Low(Files) to High(Files) do
                  if Files[i].Equals(_File) then
                    Break;
                FileFiltered[i] := _File.RecordCount - MainRecordCount;
              end;
              MainRecordCount := 0;
            end;
            if not CheckFilterNode(True) then begin
              if Assigned(NodeData) and Assigned(NodeData.Element) and (NodeData.Element.ElementType = etMainRecord) then
                Inc(MainRecordCount);
              Inc(CountUnfiltered);
            end;
            Node := NextNode;
            Inc(Count2);
            wbCurrentProgress := '[Pass 2] Processed Records: ' + Count2.ToString;
            wbTick;
          end;

          wbCurrentProgress := '[Pass 1] Processed Records: ' + Count.ToString + ', [Pass 2] Processed Records: ' + Count2.ToString + ', Remaining unfiltered nodes: ' + CountUnfiltered.ToString;

          for i := Low(Files) to High(Files) do
            if (FileFiltered[i] > 0) and (FileFiltered[i] < Files[i].RecordCount) then
              wbProgress(Format('[%s] Filtered %.0n of %.0n records',
                [Files[i].FileName, Min(Files[i].RecordCount, FileFiltered[i]) + 0.0, Files[i].RecordCount + 0.0]));

          FilterApplied := True;
          lblFilterHint.Visible := True;
        finally
          vstNav.EndUpdate;
        end;
      end);
    end;
  finally
    Signatures.Free;
    BaseSignatures.Free;
    TopLevelGroups.Free;
    vstNav.Visible:= True;
    FilterScripted := False;
  end;
end;

procedure TfrmMain.mniNavFilterConflictsClick(Sender: TObject);
begin
  FilterConflictAll := False;
  FilterConflictThis := True;

  FilterByInjectStatus := False;
  FilterInjectStatus := False;

  FilterByNotReachableStatus := False;
  FilterNotReachableStatus := False;

  FilterByReferencesInjectedStatus := False;
  FilterReferencesInjectedStatus := False;

  FilterByEditorID := False;
  FilterEditorID := '';

  FilterByName := False;
  FilterName := '';

  FilterByBaseEditorID := False;
  FilterBaseEditorID := '';

  FilterByBaseName := False;
  FilterBaseName := '';

  FilterScaledActors := False;

  FilterByPersistent := False;
  FilterPersistent := False;
  FilterUnnecessaryPersistent := False;
  FilterMasterIsTemporary := False;
  FilterIsMaster := False;
  FilterPersistentPosChanged := False;

  FilterDeleted := False;

  FilterByVWD := False;
  FilterVWD := False;

  FilterByHasVWDMesh := False;
  FilterHasVWDMesh := False;

  FilterByHasPrecombinedMesh := False;
  FilterHasPrecombinedMesh := False;

  FilterBySignature := False;
  FilterSignatures := '';

  FilterByBaseSignature := False;
  FilterBaseSignatures := '';

  FilterConflictAllSet := [];
  FilterConflictThisSet := [ctIdenticalToMasterWinsConflict, ctConflictWins, ctConflictLoses];

  FlattenBlocks := True;
  FlattenCellChilds := True;
  AssignPersWrldChild := True;
  InheritConflictByParent := True;

  FilterPreset := True;
  FilterNoGameMaster := xeVeryQuickShowConflicts;
  FilterConflictOnly := xeVeryQuickShowConflicts;
  try
    mniNavFilterApplyClick(Sender);
  finally
    FilterNoGameMaster := False;
    FilterConflictOnly := False;
    FilterPreset := False;
  end;
end;

procedure TfrmMain.mniNavFilterForCleaningClick(Sender: TObject);
begin
  FilterConflictAll := False;
  FilterConflictThis := False;

  FilterByInjectStatus := False;
  FilterInjectStatus := False;

  FilterByNotReachableStatus := False;
  FilterNotReachableStatus := False;

  FilterByReferencesInjectedStatus := False;
  FilterReferencesInjectedStatus := False;

  FilterByEditorID := False;
  FilterEditorID := '';

  FilterByName := False;
  FilterName := '';

  FilterByBaseEditorID := False;
  FilterBaseEditorID := '';

  FilterByBaseName := False;
  FilterBaseName := '';

  FilterScaledActors := False;

  FilterByPersistent := False;
  FilterPersistent := False;
  FilterUnnecessaryPersistent := False;
  FilterMasterIsTemporary := False;
  FilterIsMaster := False;
  FilterPersistentPosChanged := False;

  FilterDeleted := False;

  FilterByVWD := False;
  FilterVWD := False;

  FilterByHasVWDMesh := False;
  FilterHasVWDMesh := False;

  FilterByHasPrecombinedMesh := False;
  FilterHasPrecombinedMesh := False;

  FilterBySignature := False;
  FilterSignatures := '';

  FilterByBaseSignature := False;
  FilterBaseSignatures := '';

  FilterConflictAllSet := [];
  FilterConflictThisSet := [];

  FlattenBlocks := False;
  FlattenCellChilds := False;
  AssignPersWrldChild := False;
  InheritConflictByParent := True;

  if ModGroupsEnabled or OnlyShowMasterAndLeafs or xeQuickShowConflicts then begin
    if ModGroupsEnabled then
      wbProgress('Disabling ModGroups');
    if OnlyShowMasterAndLeafs then
      wbProgress('Disabling "Only Show Master and Leafs"');
    if xeQuickShowConflicts then
      wbProgress('Disabling "Quick Show Conflict" mode');
    ModGroupsEnabled := False;
    OnlyShowMasterAndLeafs := False;
    xeQuickShowConflicts := False;
    ResetAllConflict;
  end;

  FilterPreset := True;
  try
    mniNavFilterApplyClick(Sender);
  finally
    FilterPreset := False;
  end;
end;

procedure TfrmMain.mniNavFilterForOnlyOneClick(Sender: TObject);
begin
  FilterConflictAll := False;
  FilterConflictThis := False;

  FilterByInjectStatus := False;
  FilterInjectStatus := False;

  FilterByNotReachableStatus := False;
  FilterNotReachableStatus := False;

  FilterByReferencesInjectedStatus := False;
  FilterReferencesInjectedStatus := False;

  FilterByEditorID := False;
  FilterEditorID := '';

  FilterByName := False;
  FilterName := '';

  FilterByBaseEditorID := False;
  FilterBaseEditorID := '';

  FilterByBaseName := False;
  FilterBaseName := '';

  FilterScaledActors := False;

  FilterByPersistent := False;
  FilterPersistent := False;
  FilterUnnecessaryPersistent := False;
  FilterMasterIsTemporary := False;
  FilterIsMaster := False;
  FilterPersistentPosChanged := False;

  FilterDeleted := False;

  FilterByVWD := False;
  FilterVWD := False;

  FilterByHasVWDMesh := False;
  FilterHasVWDMesh := False;

  FilterByHasPrecombinedMesh := False;
  FilterHasPrecombinedMesh := False;

  FilterBySignature := False;
  FilterSignatures := '';

  FilterByBaseSignature := False;
  FilterBaseSignatures := '';

  FilterConflictAllSet := [];
  FilterConflictThisSet := [];

  FlattenBlocks := False;
  FlattenCellChilds := False;
  AssignPersWrldChild := False;
  InheritConflictByParent := True;

  if ModGroupsEnabled or OnlyShowMasterAndLeafs or xeQuickShowConflicts then begin
    if ModGroupsEnabled then
      wbProgress('Disabling ModGroups');
    if OnlyShowMasterAndLeafs then
      wbProgress('Disabling "Only Show Master and Leafs"');
    if xeQuickShowConflicts then
      wbProgress('Disabling "Quick Show Conflict" mode');
    ModGroupsEnabled := False;
    OnlyShowMasterAndLeafs := False;
    xeQuickShowConflicts := False;
    ResetAllConflict;
  end;

  FilterPreset := True;
  FilterOnlyOne := True;
  try
    mniNavFilterApplyClick(Sender);
  finally
    FilterOnlyOne := False;
    FilterPreset := False;
  end;
end;

procedure TfrmMain.mniNavOptionsClick(Sender: TObject);
var
  ct: TConflictThis;
  ca: TConflictAll;
  PatronSet: Boolean;
begin
  with TfrmOptions.Create(Self) do try
    pnlFontRecords.Font := vstNav.Font;
    pnlFontMessages.Font := mmoMessages.Font;
    pnlFontViewer.Font := Self.Font; LoadFont(Settings, 'UI', 'FontViewer', pnlFontViewer.Font);
    if wbTranslationMode then begin
      cbHideUnused.Visible := False;
      cbHideIgnored.Visible := False;
      cbHideNeverShow.Visible := False;
    end else begin
      cbHideUnused.Checked := wbHideUnused;
      cbHideIgnored.Checked := wbHideIgnored;
      cbHideNeverShow.Checked := wbHideNeverShow;
    end;
    cbActorTemplateHide.Checked := wbActorTemplateHide;
    cbLoadBSAs.Checked := wbLoadBSAs;
    cbSortFLST.Checked := wbSortFLST;
    cbSortINFO.Checked := wbSortINFO;
    cbFillPNAM.Checked := wbFillPNAM;
    cbFocusAddedElement.Checked := wbFocusAddedElement;
    cbRequireCtrlForDblClick.Checked := wbRequireCtrlForDblClick;
    cbShowFlagEnumValue.Checked := wbShowFlagEnumValue;
    cbShowGroupRecordCount.Checked := wbShowGroupRecordCount;
    cbShowFileFlags.Checked := wbShowFileFlags;
    sedAutoCompareSelectedLimit.Value := wbAutoCompareSelectedLimit;
    sedNavChangeDelay.Value := tmrPendingSetActive.Interval;
    cbSimpleRecords.Checked := wbSimpleRecords;
    cbDecodeTexture.Checked := wbDecodeTextureHashes;
    cbClampFormID.Checked := wbClampFormID;
    cbResetModifiedOnSave.Checked := wbResetModifiedOnSave;
    cbAlwaysSaveOnam.Checked := wbAlwaysSaveOnam or wbAlwaysSaveOnamForce;
    if wbAlwaysSaveOnamForce then
      cbAlwaysSaveOnam.Enabled := False;
    cbAlignArrayElements.Checked := wbAlignArrayElements;
    cbManualCleaningHide.Checked := wbManualCleaningHide;
    cbManualCleaningAllow.Checked := wbManualCleaningAllow;
    cbConvertIntFormID.Checked := wbConvertIntFormID;
    cbCollapseRecordHeader.Checked := wbCollapseRecordHeader;
    cbCollapseObjectBounds.Checked := wbCollapseObjectBounds;
    cbCollapseModels.Checked := wbCollapseModels;
    cbCollapseFactions.Checked := wbCollapseFactions;
    cbCollapseFactionRelations.Checked := wbCollapseFactionRelations;
    cbCollapseItems.Checked := wbCollapseItems;
    cbCollapseLeveledItems.Checked := wbCollapseLeveledItems;
    cbCollapseEquipSlots.Checked := wbCollapseEquipSlots;
    cbCollapseObjectProperties.Checked := wbCollapseObjectProperties;
    cbCollapseScriptProperties.Checked := wbCollapseScriptProperties;
    cbCollapseConditions.Checked := wbCollapseConditions;
    cbCollapseBenignArray.Checked := wbCollapseBenignArray;
    cbCollapseRGBA.Checked := wbCollapseRGBA;
    cbCollapseVec3.Checked := wbCollapseVec3;
    cbShrinkButtons.Checked := wbShrinkButtons;
    edColumnWidth.Text := IntToStr(ColumnWidth);
    edRowHeight.Text := IntToStr(RowHeight);
    cbShowUnsavedHint.Checked := ShowUnsavedHint;
    //cbIKnow.Checked := wbIKnowWhatImDoing;
    cbShowTip.Checked := wbShowTip;
    cbPatron.Checked := wbPatron;
    cbNoGitHubCheck.Checked := wbNoGitHubCheck;
    cbNoNexusModsCheck.Checked := wbNoNexusModsCheck;
    cbTrackAllEditorID.Checked := wbTrackAllEditorID;
    cbUDRSetXESP.Checked := wbUDRSetXESP;
    cbUDRSetScale.Checked := wbUDRSetScale;
    edUDRSetScaleValue.Text := FloatToStrF(wbUDRSetScaleValue, ffFixed, 99, wbFloatDigits);
    cbUDRSetZ.Checked := wbUDRSetZ;
    edUDRSetZValue.Text := FloatToStrF(wbUDRSetZValue, ffFixed, 99, wbFloatDigits);
    cbUDRSetMSTT.Checked := wbUDRSetMSTT;
    edUDRSetMSTTValue.Text := IntToHex(wbUDRSetMSTTValue, 8);
    _Files := @Files;

    if ShowModal <> mrOK then
      Exit;

    if wbThemesSupported then
      TStyleManager.TrySetStyle(GetSelectedTheme, False);

    vstNav.Font := pnlFontRecords.Font;
    vstView.Font := pnlFontRecords.Font;
    lblPath.Font := pnlFontRecords.Font;
    //pnlTop.Height := Abs(lblPath.Font.Height) + Trunc(20 * (GetCurrentPPIScreen/PixelsPerInch));
    mmoMessages.Font := pnlFontMessages.Font;
    if not wbTranslationMode then begin
      wbHideUnused := cbHideUnused.Checked;
      wbHideIgnored := cbHideIgnored.Checked;
      wbHideNeverShow := cbHideNeverShow.Checked;
    end;
    wbActorTemplateHide := cbActorTemplateHide.Checked;
    wbLoadBSAs := cbLoadBSAs.Checked;
    wbSortFLST := cbSortFLST.Checked;
    wbSortINFO := cbSortINFO.Checked;
    wbFillPNAM := cbFillPNAM.Checked;
    wbFocusAddedElement := cbFocusAddedElement.Checked;
    wbRequireCtrlForDblClick := cbRequireCtrlForDblClick.Checked;
    wbShowFlagEnumValue := cbShowFlagEnumValue.Checked;
    wbShowGroupRecordCount := cbShowGroupRecordCount.Checked;
    wbShowFileFlags := cbShowFileFlags.Checked;
    wbAutoCompareSelectedLimit := sedAutoCompareSelectedLimit.Value;
    tmrPendingSetActive.Interval := sedNavChangeDelay.Value;
    wbSimpleRecords := cbSimpleRecords.Checked;
    wbDecodeTextureHashes := cbDecodeTexture.Checked;
    wbClampFormID := cbClampFormID.Checked;
    wbResetModifiedOnSave := cbResetModifiedOnSave.Checked;
    wbAlwaysSaveOnam := cbAlwaysSaveOnam.Checked or wbAlwaysSaveOnamForce;
    wbAlignArrayElements := cbAlignArrayElements.Checked;
    wbManualCleaningHide := cbManualCleaningHide.Checked;
    wbManualCleaningAllow := cbManualCleaningAllow.Checked;
    wbConvertIntFormID := cbConvertIntFormID.Checked;
    wbCollapseRecordHeader := cbCollapseRecordHeader.Checked;
    wbCollapseObjectBounds := cbCollapseObjectBounds.Checked;
    wbCollapseModels := cbCollapseModels.Checked;
    wbCollapseFactions := cbCollapseFactions.Checked;
    wbCollapseFactionRelations := cbCollapseFactionRelations.Checked;
    wbCollapseItems := cbCollapseItems.Checked;
    wbCollapseLeveledItems := cbCollapseLeveledItems.Checked;
    wbCollapseEquipSlots := cbCollapseEquipSlots.Checked;
    wbCollapseObjectProperties := cbCollapseObjectProperties.Checked;
    wbCollapseScriptProperties := cbCollapseScriptProperties.Checked;
    wbCollapseConditions := cbCollapseConditions.Checked;
    wbCollapseBenignArray := cbCollapseBenignArray.Checked;
    wbCollapseRGBA := cbCollapseRGBA.Checked;
    wbCollapseVec3 := cbCollapseVec3.Checked;
    if (wbShrinkButtons <> cbShrinkButtons.Checked) then
      if cbShrinkButtons.Checked then ShrinkButtons else ExpandButtons;
    wbShrinkButtons := cbShrinkButtons.Checked;
    ColumnWidth := StrToIntDef(edColumnWidth.Text, ColumnWidth);
    RowHeight := StrToIntDef(edRowHeight.Text, RowHeight);
    SetDefaultNodeHeight(Trunc(RowHeight * (GetCurrentPPIScreen / PixelsPerInch)));
    ShowUnsavedHint := cbShowUnsavedHint.Checked;
    //wbIKnowWhatImDoing := cbIKnow.Checked;
    wbShowTip := cbShowTip.Checked;
    PatronSet := cbPatron.Checked and not wbPatron;
    wbPatron := cbPatron.Checked;
    wbNoGitHubCheck := cbNoGitHubCheck.Checked;
    wbNoNexusModsCheck := cbNoNexusModsCheck.Checked;
    wbTrackAllEditorID := cbTrackAllEditorID.Checked;
    wbUDRSetXESP := cbUDRSetXESP.Checked;
    wbUDRSetScale := cbUDRSetScale.Checked;
    wbUDRSetScaleValue := StrToFloatDef(edUDRSetScaleValue.Text, wbUDRSetScaleValue);
    wbUDRSetZ := cbUDRSetZ.Checked;
    wbUDRSetZValue := StrToFloatDef(edUDRSetZValue.Text, wbUDRSetZValue);
    wbUDRSetMSTT := cbUDRSetMSTT.Checked;
    wbUDRSetMSTTValue := StrToInt64Def('$' + edUDRSetMSTTValue.Text, wbUDRSetMSTTValue);

    if PatronSet then
      ShowDeveloperMessage(True);

    SaveFont(Settings, 'UI', 'FontRecords', vstNav.Font);
    SaveFont(Settings, 'UI', 'FontMessages', mmoMessages.Font);
    SaveFont(Settings, 'UI', 'FontViewer', pnlFontViewer.Font);
    Settings.WriteBool('Options', 'ShowUnsavedHint', ShowUnsavedHint);
    if not wbTranslationMode then begin
      Settings.WriteBool('Options', 'HideUnused', wbHideUnused);
      Settings.WriteBool('Options', 'HideIgnored', wbHideIgnored);
      Settings.WriteBool('Options', 'HideNeverShow', wbHideNeverShow);
    end;
    Settings.WriteBool('Options', 'ActorTemplateHide', wbActorTemplateHide);
    Settings.WriteBool('Options', 'LoadBSAs', wbLoadBSAs);
    Settings.WriteBool('Options', 'SortFLST2', wbSortFLST);
    Settings.WriteBool('Options', 'SortINFO', wbSortINFO);
    Settings.WriteBool('Options', 'FillPNAM', wbFillPNAM);
    Settings.WriteBool('Options', 'FocusAddedElement', wbFocusAddedElement);
    Settings.WriteBool('Options', 'RequireCtrlForDblClick', wbRequireCtrlForDblClick);
    Settings.WriteBool('Options', 'ShowFlagEnumValue', wbShowFlagEnumValue);
    Settings.WriteBool('Options', 'ShowGroupRecordCount', wbShowGroupRecordCount);
    Settings.WriteBool('Options', 'ShowFileFlags', wbShowFileFlags);
    Settings.WriteInteger('Options', 'AutoCompareSelectedLimit', wbAutoCompareSelectedLimit);
    Settings.WriteInteger('Options', 'NavChangeDelay', tmrPendingSetActive.Interval);
    Settings.WriteBool('Options', 'SimpleRecords', wbSimpleRecords);
    Settings.WriteBool('Options', 'DecodeTextureHashes2', wbDecodeTextureHashes);{changed name to enforce new default value}
    Settings.WriteBool('Options', 'ClampFormID', wbClampFormID);
    Settings.WriteBool('Options', 'ResetModifiedOnSave', wbResetModifiedOnSave);
    Settings.WriteBool('Options', 'AlwaysSaveOnam', wbAlwaysSaveOnam or wbAlwaysSaveOnamForce);
    Settings.WriteBool('Options', 'AlignArrayElements', wbAlignArrayElements);
    Settings.WriteBool('Options', 'ManualCleaningHide', wbManualCleaningHide);
    Settings.WriteBool('Options', 'ManualCleaningAllow', wbManualCleaningAllow);
    Settings.WriteBool('Options', 'ConvertIntFormID', wbConvertIntFormID);
    Settings.WriteBool('Options', 'CollapseRecordHeader', wbCollapseRecordHeader);
    Settings.WriteBool('Options', 'CollapseObjectBounds', wbCollapseObjectBounds);
    Settings.WriteBool('Options', 'CollapseModels', wbCollapseModels);
    Settings.WriteBool('Options', 'CollapseFactions', wbCollapseFactions);
    Settings.WriteBool('Options', 'CollapseFactionRelations', wbCollapseFactionRelations);
    Settings.WriteBool('Options', 'CollapseFragments', wbCollapseFragments);
    Settings.WriteBool('Options', 'CollapseItems', wbCollapseItems);
    Settings.WriteBool('Options', 'CollapseLeveledItems', wbCollapseLeveledItems);
    Settings.WriteBool('Options', 'CollapseEquipSlots', wbCollapseEquipSlots);
    Settings.WriteBool('Options', 'CollapseObjectProperties', wbCollapseObjectProperties);
    Settings.WriteBool('Options', 'CollapseScriptProperties', wbCollapseScriptProperties);
    Settings.WriteBool('Options', 'CollapseConditions', wbCollapseConditions);
    Settings.WriteBool('Options', 'CollapseBenignArray', wbCollapseBenignArray);
    Settings.WriteBool('Options', 'CollapseRGBA', wbCollapseRGBA);
    Settings.WriteBool('Options', 'CollapseVec3', wbCollapseVec3);
    Settings.WriteBool('Options', 'CollapseHeadParts', wbCollapseHeadParts);
    Settings.WriteBool('Options', 'CollapseBodyParts', wbCollapseBodyParts);
    Settings.WriteBool('Options', 'ShrinkButtons', wbShrinkButtons);
    Settings.WriteInteger('Options', 'ColumnWidth', ColumnWidth);
    Settings.WriteInteger('Options', 'RowHeight', RowHeight);
    //Settings.WriteBool('Options', 'IKnowWhatImDoing', wbIKnowWhatImDoing);
    Settings.WriteBool('Options', 'TrackAllEditorID', wbTrackAllEditorID);
    Settings.WriteBool('Options', 'ShowTip', wbShowTip);
    Settings.WriteBool('Options', 'Patron', wbPatron);
    Settings.WriteBool('Options', 'NoGitHubCheck', wbNoGitHubCheck);
    Settings.WriteBool('Options', 'NoNexusModsCheck', wbNoNexusModsCheck);
    Settings.WriteBool('Options', 'UDRSetXESP', wbUDRSetXESP);
    Settings.WriteBool('Options', 'UDRSetScale', wbUDRSetScale);
    Settings.WriteFloat('Options', 'UDRSetScaleValue', wbUDRSetScaleValue);
    Settings.WriteBool('Options', 'UDRSetZ', wbUDRSetZ);
    Settings.WriteFloat('Options', 'UDRSetZValue', wbUDRSetZValue);
    Settings.WriteBool('Options', 'UDRSetMSTT', wbUDRSetMSTT);
    Settings.WriteInteger('Options', 'UDRSetMSTTValue', wbUDRSetMSTTValue);
    for ct := Low(TConflictThis) to High(TConflictThis) do
      Settings.WriteInteger('ColorConflictThis', GetEnumName(TypeInfo(TConflictThis), Integer(ct)), Integer(wbColorConflictThis[ct]));
    for ca := Low(TConflictAll) to High(TConflictAll) do
      Settings.WriteInteger('ColorConflictAll', GetEnumName(TypeInfo(TConflictAll), Integer(ca)), Integer(wbColorConflictAll[ca]));

    Settings.UpdateFile;
  finally
    Free;
  end;
end;

procedure TfrmMain.mniNavOtherCodeSiteLoggingClick(Sender: TObject);
begin
  {$IFDEF USE_CODESITE}
  mniNavOtherCodeSiteLogging.Checked := not mniNavOtherCodeSiteLogging.Checked;
  if mniNavOtherCodeSiteLogging.Checked then
    wbBeginCodeSiteLogging
  else
    wbEndCodeSiteLogging;
  {$ELSE}
  mniNavOtherCodeSiteLogging.Visible := False;
  mniNavOtherCodeSiteLogging.Enabled := False;
  {$ENDIF}
end;

procedure TfrmMain.mniViewNextMemberClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      ViewFocusedElement := Element.NextMember;
      EditFocusedViewElement := False;
      PostResetActiveTree;
    end;
  end;
end;

function TfrmMain.NodeDatasForContainer(const aContainer: IwbDataContainer): TDynViewNodeDatas;
var
  i, l    : Integer;
  p       : string;
  Element : IwbElement;
begin
  Assert(wbLoaderDone);

  SetLength(Result, 0);
  l := 0;
  p := Copy(aContainer.Path, Succ(Length(aContainer.GetFile.Path + ' \ ')));
  repeat
    i := Pos(' \ ', p);
    if i>0 then begin
      Delete(p, i, 1);
      Delete(p, i+1, 1);
    end;
  until i = 0;  // Convert GetPath to ByPath

  for i := 0 to pred(Length(Files)) do
    if Files[i].IsNotPlugin then begin
      Element := Files[i].ElementByPath[p];
      if Assigned(Element) then begin
        SetLength(Result, Succ(l));
        Result[l].Element := Element;
        Result[l].Container := Element as IwbContainerElementRef;
        if Result[l].Container.ElementCount < 1 then
          Result[l].Container := nil;
        Inc(l);
      end;
    end;
  Assert(Length(Result)>0); // At least there should be ourself
end;

function TfrmMain.NodeDatasForMainRecord(const aMainRecord: IwbMainRecord): TDynViewNodeDatas;
var
  Master        : IwbMainRecord;
  Rec           : IwbMainRecord;
  i, j, k       : Integer;
  MadeChanges   : Boolean;
  EditorID      : string;
  FormID        : TwbFormID;
  LoadOrder     : Integer;
  Group         : IwbGroupRecord;
  Signature     : TwbSignature;
  MasterAndLeafs: TDynMainRecords;
  MainRecords   : TDynMainRecords;
  Modules       : TwbModuleInfos;
  FirstModule   : PwbModuleInfo;
  LastModule    : PwbModuleInfo;
begin
  Assert(wbLoaderDone);
  MainRecords := nil;
  Result := nil;

  if (aMainRecord.Signature = 'GMST') or (aMainRecord.Signature = 'DFOB') then begin
    EditorID := aMainRecord.EditorID;
    SetLength(MainRecords, Length(Files));
    Master := nil;
    j := 0;
    for i := Low(Files) to High(Files) do begin
      Group := Files[i].GroupBySignature[aMainRecord.Signature];
      if Assigned(Group) then begin
        Rec := Group.MainRecordByEditorID[EditorID];
        if Assigned(Rec) then begin
          if not Assigned(Master) then
            Master := Rec;
          MainRecords[j] := Rec;
          Inc(j);
        end;
      end;
    end;
    SetLength(MainRecords, j);

  end else if (aMainRecord.Signature = 'NAVI') (* or (aMainRecord.Signature = 'TES4') *) then begin
    Signature := aMainRecord.Signature;
    FormID := aMainRecord.FormID;
    LoadOrder := aMainRecord.GetFile.LoadOrder;
    SetLength(MainRecords, Length(Files));
    Master := nil;
    j := 0;
    for i := Low(Files) to High(Files) do
      if Files[i].LoadOrder = LoadOrder then begin
        Group := Files[i].GroupBySignature[Signature];
        if Assigned(Group) then begin
          Rec := Group.MainRecordByFormID[FormID];
          if Assigned(Rec) then begin
            if not Assigned(Master) then
              Master := Rec;
            MainRecords[j] := Rec;
            Inc(j);
          end;
        end;
      end;
    SetLength(MainRecords, j);

  end else if (aMainRecord.Signature = 'TES4') then begin
    Signature := aMainRecord.Signature;
    LoadOrder := aMainRecord.GetFile.LoadOrder;
    SetLength(MainRecords, Length(Files));
    Master := nil;
    j := 0;
    for i := Low(Files) to High(Files) do
      if Files[i].LoadOrder = LoadOrder then begin
        // header of .exe file, show only itself
        if SameText(ExtractFileExt(aMainRecord.GetFile.FileName), csDotExe) and not SameText(ExtractFileExt(Files[i].FileName), csDotExe) then
          Continue;
        // skip .exe file header by default
        if not SameText(ExtractFileExt(aMainRecord.GetFile.FileName), csDotExe) and SameText(ExtractFileExt(Files[i].FileName), csDotExe) then
          Continue;
        Rec := Files[i].Elements[0] as IwbMainRecord;
        if Assigned(Rec) then begin
          if not Assigned(Master) then
            Master := Rec;
          MainRecords[j] := Rec;
          Inc(j);
        end;
      end;
    SetLength(MainRecords, j);

  end else begin
    Master := aMainRecord.MasterOrSelf;

    if OnlyShowMasterAndLeafs then begin
      MainRecords := Master.MasterAndLeafs;
    end else begin
      SetLength(MainRecords, Succ(Master.OverrideCount));
      MainRecords[0] := Master;
      for i := 0 to Pred(Master.OverrideCount) do
        MainRecords[Succ(i)] := Master.Overrides[i];
    end;
  end;

  if ModGroupsEnabled and (Length(MainRecords) > 2) then begin
    SetLength(Modules, Length(MainRecords));
    for i := Low(MainRecords) to High(MainRecords) do begin
      Modules[i] := MainRecords[i]._File.ModuleInfo;
      if Assigned(Modules[i]) then
        Exclude(Modules[i].miFlags, mfEphemeralModGroupTagged);
    end;
    FirstModule := nil;
    LastModule := nil;
    for i := Low(Modules) to High(Modules) do
      if Assigned(Modules[i]) then begin
        if not Assigned(FirstModule) then
          FirstModule := Modules[i];
        with Modules[i]^ do
          for j := Low(miModGroupTargets) to High(miModGroupTargets) do
            Include(miModGroupTargets[j].miFlags, mfEphemeralModGroupTagged);
        LastModule := Modules[i];
      end;

    if Assigned(FirstModule) then
      Exclude(FirstModule.miFlags, mfEphemeralModGroupTagged);
    if Assigned(LastModule) then
      Exclude(LastModule.miFlags, mfEphemeralModGroupTagged);

    j := 0;
    for i := Low(Modules) to High(Modules) do
      if not Assigned(Modules[i]) or not (mfEphemeralModGroupTagged in Modules[i].miFlags) then begin
        if i <> j then
          MainRecords[j] := MainRecords[i];
        Inc(j);
      end;
    SetLength(MainRecords, j);
  end;

  j := 0;
  for i := Low(MainRecords) to High(MainRecords) do
    if not MainRecords[i].IsHidden then begin
      if i <> j then
        MainRecords[j] := MainRecords[i];
      Inc(j);
    end;
  SetLength(MainRecords, j);

  if Length(MainRecords) < 1 then
    MainRecords := [aMainRecord];

  SetLength(Result, Length(MainRecords));
  for i := Low(MainRecords) to High(MainRecords) do
    with Result[i] do begin
      Rec := MainRecords[i];
      if i = 0 then
        Master := Rec;

      Container := Rec as IwbContainerElementRef;
      Element := Container;
      if (Container.ElementCount = 0) or (Rec.Signature <> Master.Signature) then
        Container := nil;
    end;
end;

procedure TfrmMain.PerformActionOnSelectedFiles(const aDesc: string; const aAction: TProc<IwbFile>);
var
  Nodes                       : TNodeArray;
  NodeData                    : PNavNodeData;
  _File                       : IwbFile;
  i, j                        : Integer;
  Files                       : TwbFiles;
begin
  UserWasActive := True;

  Nodes := vstNav.GetSortedSelection(True);
  SetLength(Files, Length(Nodes));
  j := 0;
  for i := Low(Nodes) to High(Nodes) do begin
    NodeData := vstNav.GetNodeData(Nodes[i]);
    if Assigned(NodeData) and Supports(NodeData.Element, IwbFile, _File) then
      if _File.IsEditable then begin
        Files[j] := _File;
        Inc(j);
      end;
  end;
  SetLength(Files, j);

  if Length(Files) > 0 then begin
    if not EditWarn then
      Exit;
    PerformLongAction(aDesc, '', procedure
    var
      i: Integer;
    begin
      for i := Low(Files) to High(Files) do
        aAction(Files[i]);
    end);
  end;
end;

function TfrmMain.PerformDrop(TargetTree    : TBaseVirtualTree;
                              TargetNode    : PVirtualNode;
                              TargetColumn  : Integer;
                        const SourceElement : IwbElement)
                                            : Boolean;
var
  TargetIndex     : Integer;
  TargetElement   : IwbElement;
  NewElement      : IwbElement;
  TargetNodeDatas : PViewNodeDatas;
  TargetNodeData  : PViewNodeData;
  TargetContainer : IwbContainerElementRef;
begin
  Result := False;

  if GetTargetElement(TargetTree, TargetNode, TargetColumn, TargetIndex, TargetElement) then begin

    if SourceElement.Equals(TargetElement) then
      Exit;

    if not EditWarn then
      Exit;

    if not AddRequiredMasters(SourceElement, TargetElement._File, False) then
      Exit;

    vstView.BeginUpdate;
    try
      NewElement := TargetElement.Assign(TargetIndex, SourceElement, False);
      if Assigned(NewElement) and (TargetIndex >= 0) and (TargetIndex < High(Integer)) then begin
        TargetNodeDatas := vstView.GetNodeData(TargetNode);
        if Assigned(TargetNodeDatas) then begin
          TargetNodeData := @TargetNodeDatas[Pred(TargetColumn)];
          if vnfIsAligned in TargetNodeData.ViewNodeFlags then
            if Supports(TargetElement, IwbContainerElementRef, TargetContainer) then begin
              NewElement.SortOrder := TargetIndex;
              TargetContainer.SortBySortOrder;
              TargetContainer.ResetMemoryOrder;
            end;
        end;
      end;

      ActiveRecords[Pred(TargetColumn)].UpdateRefs;
      ViewFocusedElement := NewElement;
      EditFocusedViewElement := False;
      NewElement := nil;
      TargetElement := nil;
      Result := True;
    finally
      vstView.EndUpdate;
    end;
  end;
end;

procedure TfrmMain.PerformLongAction(const aDesc, aProgress: string; const aAction: TProc);
var
  HadTick      : Boolean;
  HadLastMsg   : Boolean;
  WasEnabled   : Boolean;
  PrevCaption  : string;
  PrevAction   : string;
  PrevProgress : string;
  PrevLocalStartTime   : TDateTime;
  s: string;
begin
  PrevLocalStartTime := wbLocalStartTime;
  wbLocalStartTime := Now;
  if wbShowStartTime < 1 then
    wbStartTime := wbLocalStartTime;
  WasEnabled := pnlClient.Enabled;
  HadTick := wbCurrentTick > 0;
  HadLastMsg := wbLastMessageAt > 0;

  wbCurrentTick := GetTickCount64;
  if not HadLastMsg then
    wbLastMessageAt := wbCurrentTick;
  Inc(wbShowStartTime);
  UpdateCaption;
  PrevCaption := Caption;
  Inc(wbShowCaption);
  PrevAction := wbCurrentAction;
  PrevProgress := wbCurrentProgress;
  pnlClient.Enabled := False;
  UpdatePnlCancelVisible;
  try
    pgMain.ActivePage := tbsMessages;
    if aDesc <> '' then
      wbCurrentAction := aDesc;
    if aProgress <> '' then
      wbCurrentProgress := aProgress;
    if aDesc <> '' then
      wbProgress('Start: ' + aDesc);
    try
      aAction;
    except
      on E: EAbort do begin
        if aDesc <> '' then
          wbProgress('Aborted: ' + aDesc);
        raise;
      end;
      on E: Exception do begin
        if wbCurrentAction <> '' then
          wbProgress('Error during ' + wbCurrentAction + ': ' + E.Message)
        else if aDesc <> '' then
          wbProgress('Error during ' + aDesc + ': ' + E.Message)
        else
          wbProgress('Error: ' + E.Message);
        raise;
      end;
    end;
    if aDesc <> '' then begin
      s := 'Done: ' + aDesc;
      if wbCurrentProgress <> '' then
        s := s + ', ' + wbCurrentProgress;
      s := s + ', Elapsed Time: ' + wbFormatElapsedTime( Now - wbLocalStartTime);
      wbProgress(s);
    end;
  finally
    pnlClient.Enabled := WasEnabled;
    UpdatePnlCancelVisible;
    wbCurrentAction := PrevAction;
    wbCurrentProgress := PrevProgress;
    Dec(wbShowStartTime);
    Dec(wbShowCaption);
    if HadTick then
      wbCurrentTick := GetTickCount64
    else
      wbCurrentTick := 0;
    if not HadLastMsg then
      wbLastMessageAt := 0;
    wbLocalStartTime := PrevLocalStartTime;
    if wbShowCaption = 0 then
      Caption := Application.Title
    else
      UpdateCaption;
      //Caption := PrevCaption;
  end;
end;

procedure TfrmMain.pgMainChange(Sender: TObject);
var
  i: Integer;
begin
  if not ((pgMain.ActivePage = tbsWEAPSpreadsheet) or
      (pgMain.ActivePage = tbsAMMOSpreadsheet) or
      (pgMain.ActivePage = tbsARMOSpreadsheet)) then
        pnlNav.Show;
  if pgMain.ActivePage = tbsReferencedBy then begin
    if lvReferencedBy.Tag <> lvReferencedBy.Items.Count then begin
      lvReferencedBy.Items.BeginUpdate;
      try
        lvReferencedBy.Items.Clear;
        if Assigned(ActiveMaster) then begin
          lvReferencedBy.Tag := ActiveMaster.ReferencedByCount;
           begin
            for i := 0 to Pred(ActiveMaster.ReferencedByCount) do
              with lvReferencedBy.Items.Add do begin
                Caption := ActiveMaster.ReferencedBy[i].Name;
                SubItems.Add(ActiveMaster.ReferencedBy[i].Signature);
                SubItems.Add(ActiveMaster.ReferencedBy[i]._File.Name);
                Data := Pointer(ActiveMaster.ReferencedBy[i]);
              end;
          end;
        end else
          lvReferencedBy.Tag := 0;
      finally
        lvReferencedBy.Items.EndUpdate;
      end;
    end;
  end else if pgMain.ActivePage = tbsView then
    CheckViewForChange;
end;

procedure TfrmMain.pmuBtnMenuPopup(Sender: TObject);
begin
  mniBtnShrinkButtons.Checked := wbShrinkButtons;
end;

procedure TfrmMain.pmuMainPopup(Sender: TObject);
var
  sl       : TStringList;
  i        : Integer;
  MenuItem : TMenuItem;
begin
  jbhSave.CancelHint;

  mniMainLocalization.Visible := (wbIsSkyrim or wbIsFallout4 or wbIsFallout76 or wbIsStarfield);

  if wbIsSkyrim or wbIsFallout4 or wbIsFallout76 or wbIsStarfield then begin
    mniMainLocalizationLanguage.Clear;
    sl := TStringList.Create;
    try
      wbLocalizationHandler.AvailableLanguages(sl);
      for i := 0 to Pred(sl.Count) do begin
        MenuItem := TMenuItem.Create(mniMainLocalizationLanguage);
        MenuItem.Caption := sl[i];
        MenuItem.RadioItem := true;
        if SameText(sl[i], wbLanguage) then
          MenuItem.Checked := true;
        MenuItem.OnClick := mniMainLocalizationLanguageClick;
        mniMainLocalizationLanguage.Add(MenuItem);
      end;
    finally
      sl.Free;
    end;
  end;

  mniMainPluggyLink.Visible := (wbGameMode = gmTES4) or FileExists(wbDataPath + 'xEdit\xEditLink.ini');
  if wbGameMode <> gmTES4 then
    mniMainPluggyLink.Caption := 'GameLink';
  mniMainPluggyLink.Checked := PluggyLinkState <> plsNone;

  mniMainPluggyLinkDisabled.Visible := mniMainPluggyLink.Visible;
  mniMainPluggyLinkReference.Visible := mniMainPluggyLink.Visible;
  mniMainPluggyLinkBaseObject.Visible := mniMainPluggyLink.Visible;
  mniMainPluggyLinkInventory.Visible := mniMainPluggyLink.Visible and (wbGameMode = gmTES4);
  mniMainPluggyLinkSpell.Visible := mniMainPluggyLink.Visible and (wbGameMode = gmTES4);
  mniMainPluggyLinkEnchantment.Visible := mniMainPluggyLink.Visible and (wbGameMode = gmTES4);

  mniMainSave.Visible := wbEditAllowed and not wbDontSave;
end;

procedure TfrmMain.pmuNavHeaderPopupPopup(Sender: TObject);
begin
  mniNavHeaderINFO.Visible := wbSortINFO;
end;

procedure TfrmMain.pmuNavPopup(Sender: TObject);
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  Container                   : IwbContainerElementRef;
  AddList                     : TDynStrings;
  MenuItem                    : TMenuItem;
  MainRecord                  : IwbMainRecord;
  _File                       : IwbFile;
  i                           : Integer;
  Nodes                       : TNodeArray;
  sl                          : TStringList;
begin
  mniNavTest.Visible := DebugHook <> 0;

  {$IFNDEF USE_CODESITE}
  mniNavOtherCodeSiteLogging.Visible := False;
  mniNavOtherCodeSiteLogging.Enabled := False;
  {$ENDIF}

  NodeData := vstNav.GetNodeData(vstNav.FocusedNode);
  if Assigned(NodeData) then
    Element := NodeData.Element;

  mniNavHidden.Visible := Assigned(Element);
  mniNavHidden.Checked := Assigned(Element) and (esHidden in Element.ElementStates);

  mniNavChangeFormID.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    Assigned(Element) and
    (Element.ElementType = etMainRecord) and
    ((Element as IwbMainRecord).Signature <> 'TES4') and
    Element.IsEditable;
//  if mniNavChangeFormID.Visible then
//    with Element as IwbMainRecord do
//      mniNavChangeFormID.Visible :=
//        {(Signature <> 'CELL') and (Signature <> 'WRLD') {and (Signature <> 'DIAL')};

  mniNavRenumberFormIDsFrom.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    Assigned(Element) and
    (Element.ElementType = etFile) and
    Element.IsEditable;

  mniNavCompactFormIDs.Visible :=
    mniNavRenumberFormIDsFrom.Visible and
    wbIsLightSupported and
    Supports(Element, IwbFile, _File) and
    not (_File.IsLight or _File.IsOverlay);

  mniNavRenumberFormIDsInject.Visible :=
    mniNavRenumberFormIDsFrom.Visible and
    Supports(Element, IwbFile, _File) and
    (_File.MasterCount[True] > 0);

  mniNavChangeReferencingRecords.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    Assigned(Element) and
    (Element.ElementType = etMainRecord) and
    ((Element as IwbMainRecord).MasterOrSelf.ReferencedByCount > 0);

  mniNavCheckForErrors.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    Assigned(Element);

  mniNavCheckForCircularLeveledLists.Visible :=
    mniNavCheckForErrors.Visible;

  mniNavSetVWDAuto.Visible := mniNavCheckForErrors.Visible and (wbGameMode = gmTES4);
  mniNavSetVWDAutoInto.Visible := mniNavCheckForErrors.Visible and (wbGameMode = gmTES4);
  mniNavLOManagersDirtyInfo.Visible := mniNavCheckForErrors.Visible and (Length(LOOTPluginInfos) <> 0);

  if wbManualCleaningAllow then begin
    mniNavFilterForCleaning.Visible := True;
    mniNavFilterForCleaningSelected.Visible := True;
    mniNavRemoveIdenticalToMaster.Visible := mniNavCheckForErrors.Visible;
    mniNavUndeleteAndDisableReferences.Visible := mniNavCheckForErrors.Visible;

    mniNavFilterForCleaningObsolete.Visible := False;
    mniNavFilterForCleaningSelectedObsolete.Visible := False;
    mniNavRemoveIdenticalToMasterObsolete.Visible := False;
    mniNavUndeleteAndDisableReferencesObsolete.Visible := False;
  end else begin
    mniNavFilterForCleaning.Visible := False;
    mniNavFilterForCleaningSelected.Visible := False;
    mniNavRemoveIdenticalToMaster.Visible := False;
    mniNavUndeleteAndDisableReferences.Visible := False;

    mniNavFilterForCleaningObsolete.Visible := not wbManualCleaningHide;
    mniNavFilterForCleaningSelectedObsolete.Visible := not wbManualCleaningHide;
    mniNavRemoveIdenticalToMasterObsolete.Visible := (not wbManualCleaningHide) and mniNavCheckForErrors.Visible;
    mniNavUndeleteAndDisableReferencesObsolete.Visible := (not wbManualCleaningHide) and mniNavCheckForErrors.Visible;
  end;

  mniNavRemove.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    (Length(RemovableSelection(nil)) > 0);
  mniNavMarkModified.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    (Length(EditableSelection(nil)) > 0);

  mniNavCompareTo.Visible := Supports(Element, IwbFile);
  mniNavCreateDeltaPatch.Visible := not wbTranslationMode and Supports(Element, IwbFile);
  mniNavAddMasters.Visible := mniNavCheckForErrors.Visible and Supports(Element, IwbFile);
  mniNavSortMasters.Visible := mniNavAddMasters.Visible;
  mniNavCleanMasters.Visible := mniNavAddMasters.Visible;
  mniNavBatchChangeReferencingRecords.Visible := mniNavAddMasters.Visible;
  mniNavApplyScript.Visible := mniNavCheckForErrors.Visible;
  mniNavGenerateLOD.Visible := mniNavCompareTo.Visible and (wbGameMode in [gmTES4, gmFO3, gmFNV, gmTES5, gmEnderal, gmTES5VR, gmSSE, gmEnderalSE, gmFO4, gmFO4VR, gmSF1]);

  mniNavAdd.Clear;
  pmuNavAdd.Items.Clear;

  var lItemCount := 0;
  var lAddToMni := mniNavAdd;
  if not wbTranslationMode and wbEditAllowed then
    if Supports(Element, IwbContainerElementRef, Container) then
      if Container.IsElementEditable(nil) then begin
        AddList := Container.GetAddList;
        for i := Low(AddList) to High(AddList) do begin
          MenuItem := TMenuItem.Create(lAddToMni);
          MenuItem.Caption := AddList[i];
          MenuItem.OnClick := mniNavAddClick;
          lAddToMni.Add(MenuItem);
          Inc(lItemCount);
          if (lItemCount > 29) and ((High(AddList)-i) > 1) then begin
            MenuItem := TMenuItem.Create(lAddToMni);
            MenuItem.Caption := 'More...';
            lAddToMni.Insert(0, MenuItem);
            lAddToMni := MenuItem;
            lItemCount := 0;
          end;
        end;
      end;

  mniNavAdd.Visible := mniNavAdd.Count > 0;

  var IsMainRecord := Supports(Element, IwbMainRecord, MainRecord);

  mniNavCopyAsOverride.Visible := mniNavCheckForErrors.Visible and not mniNavAddMasters.Visible;

  if IsMainRecord and MainRecord.ContainsReflection then
    mniNavCopyAsOverride.Visible := False;

  mniNavCopyAsOverrideWithOverwrite.Visible := mniNavCopyAsOverride.Visible;
  mniNavDeepCopyAsOverride.Visible := mniNavCopyAsOverride.Visible and SelectionIncludesAnyDeepCopyRecords;
  mniNavDeepCopyAsOverrideWithOverwriting.Visible := mniNavDeepCopyAsOverride.Visible;
  mniNavCopyAsNewRecord.Visible := mniNavCopyAsOverride.Visible and not SelectionIncludesNonCopyNewRecords;

  if mniNavDeepCopyAsOverride.Visible and SelectionIncludesOnlyDeepCopyRecords then begin
    mniNavCopyAsOverride.Visible := False;
    mniNavCopyAsOverrideWithOverwrite.Visible := False;
  end;

  mniNavCopyAsWrapper.Visible := False;
  if (wbGameMode <= gmFNV) and mniNavCopyAsOverride.Visible and IsMainRecord then
    mniNavCopyAsWrapper.Visible :=
      (MainRecord.Signature = 'LVLN') or
      (MainRecord.Signature = 'LVLC') or
      (MainRecord.Signature = 'LVLI') or
      (MainRecord.Signature = 'LVSP');
  mniNavCopyAsSpawnRateOverride.Visible :=
    mniNavCopyAsWrapper.Visible;

  mniNavCopyIdle.Visible := (wbGameMode <= gmFNV) and mniNavCheckForErrors.Visible and not mniNavAddMasters.Visible;

  mniNavCleanupInjected.Visible :=
    mniNavCopyAsOverride.Visible and
    IsMainRecord and
    MainRecord.ReferencesInjected;

  mniNavCompareSelected.Visible := False;
  if IsMainRecord then begin
    Nodes := vstNav.GetSortedSelection(True);
    for i := Low(Nodes) to High(Nodes) do begin
      NodeData := vstNav.GetNodeData(Nodes[i]);
      if not Assigned(NodeData) then begin
        Nodes := nil;
        Break;
      end;
      Element := NodeData.Element;
      if Element.ElementType <> etMainRecord then begin
        Nodes := nil;
        Break;
      end;
      if (Element as IwbMainRecord).Signature <> MainRecord.Signature then begin
        Nodes := nil;
        Break;
      end;
    end;
    mniNavCompareSelected.Visible := Length(Nodes) > 1;
    mniNavCompareSelected.Caption := 'Compare Selected ('+Length(Nodes).ToString+')';
  end;

  mniNavCreateModGroup.Visible := False;
  if Supports(Element, IwbFile, _File) then begin
    Nodes := vstNav.GetSortedSelection(True);
    for i := Low(Nodes) to High(Nodes) do begin
      NodeData := vstNav.GetNodeData(Nodes[i]);
      if not Assigned(NodeData) then begin
        Nodes := nil;
        Break;
      end;
      Element := NodeData.Element;
      if Element.ElementType <> etFile then begin
        Nodes := nil;
        Break;
      end;
    end;
    mniNavCreateModGroup.Visible := Length(Nodes) > 1;
  end;

  mniNavEditModGroup.Visible := Length(wbModGroupsByName(False)) > 0;
  mniNavDeleteModGroups.Visible := mniNavEditModGroup.Visible;
  mniNavUpdateCRCModGroups.Visible := mniNavEditModGroup.Visible;

  mniNavCellChildPers.Visible := False;
  mniNavCellChildTemp.Visible := False;
  mniNavCellChildNotVWD.Visible := mniNavCheckForErrors.Visible and SelectionIncludesOnlyREFR(NoNodes);
  mniNavCellChildVWD.Visible := mniNavCellChildNotVWD.Visible;
  if mniNavCellChildNotVWD.Visible then begin
    mniNavCellChildNotVWD.Checked := SelectionIncludesAnyNotVWD(NoNodes);
    mniNavCellChildVWD.Checked := SelectionIncludesAnyVWD(NoNodes);
  end;

  mniNavCreateSEQFile.Visible := wbIsSkyrim and
     Assigned(Element) and
    (Element.ElementType = etFile);

  mniNavLocalization.Visible := (wbIsSkyrim or wbIsFallout4 or wbIsFallout76 or wbIsStarfield);
  mniNavLocalizationSwitch.Visible :=
     Assigned(Element) and
    (Element.ElementType = etFile) and
    (Element._File.LoadOrder > 0);
  if mniNavLocalizationSwitch.Visible then
    if Element._File.IsLocalized then
      mniNavLocalizationSwitch.Caption := 'Delocalize plugin'
    else
      mniNavLocalizationSwitch.Caption := 'Localize plugin';

  mniNavLogAnalyzer.Visible := (wbGameMode in [gmTES4, gmFO3, gmFNV]) or wbIsSkyrim;
  mniNavLogAnalyzer.Clear;
  if wbIsSkyrim then begin
    MenuItem := TMenuItem.Create(mniNavLogAnalyzer);
    MenuItem.OnClick := mniNavLogAnalyzerClick;
    MenuItem.Caption := 'Papyrus Log';
    MenuItem.Tag := Integer(ltTES5Papyrus);
    mniNavLogAnalyzer.Add(MenuItem);
  end else
  if wbGameMode in [gmTES4, gmFO3, gmFNV] then begin
    MenuItem := TMenuItem.Create(mniNavLogAnalyzer);
    MenuItem.OnClick := mniNavLogAnalyzerClick;
    MenuItem.Caption := 'RuntimeScriptProfiler xSE Extension Log';
    MenuItem.Tag := Integer(ltTES4RuntimeScriptProfiler);
    mniNavLogAnalyzer.Add(MenuItem);
  end;

  mniNavCreateMergedPatch.Visible := not wbTranslationMode and wbEditAllowed;
end;

procedure TfrmMain.pmuRefByPopup(Sender: TObject);
var
  Selected  : TDynMainRecords;
  AnyVWD    : Boolean;
  AnyNotVWD : Boolean;
  i         : Integer;
  Rec       : IwbMainRecord;
  sig       : TwbSignature;
begin
  Selected := GetRefBySelectionAsMainRecords;

  mniRefByCopyOverrideInto.Visible :=
    not wbTranslationMode and
    wbEditAllowed and
    (Length(Selected) > 0);
  mniRefByCopyOverrideIntoWithOverwriting.Visible := mniRefByCopyOverrideInto.Visible;
  mniRefByDeepCopyOverrideInto.Visible := mniRefByCopyOverrideInto.Visible and ByRefSelectionIncludesAnyDeepCopyRecords(Selected);
  mniRefByDeepCopyOverrideIntoWithOverwriting.Visible := mniRefByDeepCopyOverrideInto.Visible;

  mniRefByCopyAsNewInto.Visible := mniRefByCopyOverrideInto.Visible and not ByRefSelectionIncludesNonCopyNewRecords(Selected);
  mniRefByCopyDisabledOverrideInto.Visible := mniRefByCopyOverrideInto.Visible;
  mniRefByRemove.Visible := mniRefByCopyOverrideInto.Visible;
  mniRefByMarkModified.Visible := mniRefByCopyOverrideInto.Visible;

  if mniRefByDeepCopyOverrideInto.Visible and ByRefSelectionIncludesOnlyDeepCopyRecords(Selected) then
    mniRefByCopyOverrideInto.Visible := False;

  mniRefByVWD.Visible := False;
  mniRefByNotVWD.Visible := False;

  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  if Length(Selected) < 1 then
    Exit;

  mniRefByCompareSelected.Visible := False;

  if Length(Selected) > 1 then begin
    mniRefByCompareSelected.Visible := True;
    sig := Selected[Low(Selected)].Signature;
    for i := Succ(Low(Selected)) to High(Selected) do begin
      Rec := Selected[i];
      if sig <> Rec.Signature then begin
        mniRefByCompareSelected.Visible := False;
        Break;
      end else
        sig := Rec.Signature;
    end;
  end;

  mniRefByApplyScript.Visible := Length(Selected) > 0;

  AnyVWD    := False;
  AnyNotVWD := False;

  for i := Low(Selected) to High(Selected) do begin
    Rec := Selected[i];
    if Rec.Signature <> 'REFR' then
      Exit;
    if not Rec.IsEditable then
      Exit;
    if Rec.IsVisibleWhenDistant then
      AnyVWD := True
    else
      AnyNotVWD := True;
  end;

  mniRefByVWD.Visible := AnyNotVWD;
  mniRefByNotVWD.Visible := AnyVWD;
end;

procedure TfrmMain.pmuSpreadsheetPopup(Sender: TObject);
begin
  mniSpreadsheetCompareSelected.Visible :=
    Length((pmuSpreadsheet.PopupComponent as TVirtualEditTree).
    GetSortedSelection(True)) > 1;
end;

procedure TfrmMain.pmuViewHeaderPopup(Sender: TObject);
var
  Column     : TColumnIndex;
  MainRecord : IwbMainRecord;
  AnyHidden  : Boolean;
  i          : Integer;
begin
  mniViewCreateModGroup.Visible := Length(ActiveRecords) > 2;

  mniViewHeaderCopyAsOverride.Visible := False;
  mniViewHeaderCopyAsOverrideWithOverwriting.Visible := False;
  mniViewHeaderDeepCopyAsOverride.Visible := False;
  mniViewHeaderDeepCopyAsOverrideWithOverwriting.Visible := False;
  mniViewHeaderCopyAsNewRecord.Visible := False;
  mniViewHeaderCopyAsWrapper.Visible := False;
  mniViewHeaderRemove.Visible := False;
  mniViewHeaderHidden.Visible := False;
  mniViewHeaderJumpTo.Visible := False;
  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;
  Column := vstView.Header.Columns.PopupIndex;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  if not Supports(ActiveRecords[Column].Element, IwbMainRecord, MainRecord) then
    Exit;

  mniViewHeaderCopyAsOverride.Visible := True;
  mniViewHeaderCopyAsOverrideWithOverwriting.Visible := True;
  if Assigned(MainRecord.ChildGroup) then begin
    mniViewHeaderDeepCopyAsOverride.Visible := True;
    mniViewHeaderDeepCopyAsOverrideWithOverwriting.Visible := True;
  end;

  mniViewHeaderCopyAsNewRecord.Visible := not(
    (MainRecord.Signature = 'CELL') or
    (MainRecord.Signature = 'WRLD') or
    (MainRecord.Signature = 'PGRD') or
    (MainRecord.Signature = 'NAVM') or
    (MainRecord.Signature = 'NAVI') or
    (MainRecord.Signature = 'LAND') or
    (MainRecord.Signature = 'ROAD')
  );
  mniViewHeaderCopyAsWrapper.Visible := (MainRecord.Signature = 'LVLC') or (MainRecord.Signature = 'LVLI') or (MainRecord.Signature = 'LVSP') or (MainRecord.Signature = 'LVLN');

  mniViewHeaderJumpTo.Visible := True;
  mniViewHeaderHidden.Visible := True;
  mniViewHeaderHidden.Checked := esHidden in MainRecord.ElementStates;

  MainRecord := MainRecord.MasterOrSelf;
  AnyHidden := MainRecord.IsHidden;
  if not AnyHidden then
    for i := 0 to Pred(MainRecord.OverrideCount) do
      if MainRecord.Overrides[i].IsHidden then begin
        AnyHidden := True;
        Break;
      end;
  mniViewHeaderUnhideAll.Visible := AnyHidden;

  if not ActiveRecords[Column].Element._File.IsEditable then
    Exit;
  mniViewHeaderRemove.Visible := True;
end;

procedure TfrmMain.pmuViewPopup(Sender: TObject);
var
  NodeDatas     : PViewNodeDatas;
  Element       : IwbElement;
  StructDef     : IwbStructDef;
  TargetNode    : PVirtualNode;
  TargetIndex   : Integer;
  TargetElement : IwbElement;
  NodeLabel     : String;
begin
  Element := GetFocusedViewElementSafely;
  mniViewClipboard.Visible := Assigned(Element);

  mniViewHideNoConflict.Visible := True;
  mniViewStick.Visible := False;
  mniViewEdit.Visible := False;
  mniViewSetToDefault.Visible := False;
  mniViewAdd.Visible := False;
  mniViewNextMember.Visible := False;
  mniViewPreviousMember.Visible := False;
  mniViewRemove.Visible := False;
  mniViewClear.Visible := False;
  mniViewMoveUp.Visible := False;
  mniViewMoveDown.Visible := False;
  mniViewRemoveFromSelected.Visible := False;
  mniViewSort.Visible := ComparingSiblings;
  mniViewCopyToSelectedRecords.Visible := False;
  mniViewCopyMultipleToSelectedRecords.Visible := False;
  mniViewCompareReferencedRow.Visible := False;

  if not wbEditAllowed then
    Exit;

  if Length(ActiveRecords) < 1 then
    Exit;

  mniViewStick.Visible := True;
  NodeLabel := GetViewNodePositionLabel(vstViewFocusedNode);
  if StickViewNodeLabel = '*' then begin
    mniViewStickAuto.Checked := True;
    mniViewStickSelected.Checked := False;
    mniViewStickSelected.Visible := NodeLabel <> '';
    mniViewStickSelected.Caption := NodeLabel;
  end
  else if StickViewNodeLabel <> '' then begin
    mniViewStickAuto.Checked := False;
    mniViewStickSelected.Checked := True;
    mniViewStickSelected.Caption := StickViewNodeLabel;
  end
  else begin
    mniViewStickAuto.Checked := False;
    mniViewStickSelected.Checked := False;
    mniViewStickSelected.Visible := NodeLabel <> '';
    mniViewStickSelected.Caption := NodeLabel;
  end;

  if vstView.FocusedColumn > 0 then begin
    NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
    if Assigned(NodeDatas) then begin
      Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
      mniViewEdit.Visible := Assigned(Element) and Element.IsEditable;
      mniViewSetToDefault.Visible := not wbTranslationMode and Assigned(Element) and Element._File.IsEditable and
        (Supports(Element.ValueDef, IwbStructDef, StructDef) and (StructDef.OptionalFromElement <> -1));
      mniViewRemove.Visible := not wbTranslationMode and Assigned(Element) and Element.IsRemovable;
      mniViewClear.Visible := not wbTranslationMode and Assigned(Element) and Element.IsClearable;
      mniViewMoveUp.Enabled := not wbTranslationMode and Assigned(Element) and Element.CanMoveUp;
      mniViewMoveDown.Enabled := not wbTranslationMode and Assigned(Element) and Element.CanMoveDown;
      mniViewMoveUp.Visible := mniViewMoveUp.Enabled or mniViewMoveDown.Enabled;
      mniViewMoveDown.Visible := mniViewMoveUp.Visible;
      mniViewRemoveFromSelected.Visible := not wbTranslationMode and mniViewRemove.Visible and ComparingSiblings;
      mniViewCopyMultipleToSelectedRecords.Visible := not wbTranslationMode and ComparingSiblings;
      mniViewCopyToSelectedRecords.Visible := mniViewCopyMultipleToSelectedRecords.Visible and Assigned(Element);
      mniViewCompareReferencedRow.Visible := not wbTranslationMode and (Length(GetUniqueLinksTo(NodeDatas, Length(ActiveRecords))) > 1);
      mniViewNextMember.Visible := not wbTranslationMode and Assigned(Element) and Element.CanChangeMember;
      mniViewPreviousMember.Visible := not wbTranslationMode and Assigned(Element) and Element.CanChangeMember;
    end;
    mniViewAdd.Visible := not wbTranslationMode and GetAddElement(TargetNode, TargetIndex, TargetElement) and
      TargetElement.CanAssign(TargetIndex, nil, True) and not (esNotSuitableToAddTo in TargetElement.ElementStates);
  end;

  mniViewAdd.Tag := -1;
  mniViewAdd.Caption := 'Add';
  if mniViewAdd.Visible then begin
    while mniViewAdd.Count > 0 do
      mniViewAdd.Items[Pred(mniViewAdd.Count)].Free;
    mniViewAdd.OnClick := mniViewAddClick;

    var lTemplates := TargetElement.GetAssignTemplates(TargetIndex);
    if Length(lTemplates) > 1 then begin
      for var lTemplateIdx := Low(lTemplates) to High(lTemplates) do begin
        var lMenuItem := mniViewAdd.GetParentMenu.CreateMenuItem;
        lMenuItem.Caption := lTemplates[lTemplateIdx].Name;
        lMenuItem.Tag := lTemplateIdx;
        lMenuItem.OnClick := mniViewAddClick;
        mniViewAdd.Add(lMenuItem);
      end;
      mniViewAdd.OnClick := nil;
    end else if Length(lTemplates) = 1 then begin
      mniViewAdd.Tag := 0;
      mniViewAdd.Caption := 'Add "' + lTemplates[0].Name + '"';
    end;
  end;
end;

procedure TfrmMain.pnlNavResize(Sender: TObject);
begin
  if lblFilterHint.Visible then begin
    LockWindowUpdate(pnlNav.Handle);
    try
      lblFilterHint.AutoSize := False;
      vstNav.Align := alNone;
      lblFilterHint.AutoSize := True;
      vstNav.Align := alClient;
    finally
      LockWindowUpdate(0);
    end;
  end;
end;

procedure TfrmMain.PostAddMessage(const s: string);
var
  t                           : string;
  p                           : Pointer;
begin
  t := s;
  UniqueString(t);
  p := Pointer(t);
  Pointer(t) := nil;
  PostMessage(Handle, WM_USER, UInt64(p), 0);
end;

procedure TfrmMain.PostPluggyChange(aFormID, aBaseFormID, aInventoryFormID, aEnchantmentFormID, aSpellFormID: TwbFormID);
begin
  PluggyFormID := aFormID;
  PluggyBaseFormID := aBaseFormID;
  PluggyInventoryFormID := aInventoryFormID;
  PluggyEnchantmentFormID := aEnchantmentFormID;
  PluggySpellFormID := aSpellFormID;
  PostMessage(Handle, WM_USER + 4, 0, 0);
end;

procedure TfrmMain.UpdateTreeLineColor;
begin
  if wbIsDarkMode then
  begin
    vstNav.Colors.TreeLineColor := Darker(clWindowText);
    vstView.Colors.TreeLineColor := Darker(clWindowText);
    vstNav.SelectionBlendFactor := 80;
  end
  else
  begin
    vstNav.Colors.TreeLineColor := clBtnShadow;
    vstView.Colors.TreeLineColor := clBtnShadow;
    vstNav.SelectionBlendFactor := 64;
  end;
end;

procedure TfrmMain.PostResetActiveTree;
begin
  if Length(PendingMainRecords) < 1 then begin
    PendingResetActiveTree := True;
    PostMessage(Handle, WM_USER + 3, 0, 0);
  end;
end;

procedure TfrmMain.mniViewPreviousMemberClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(vstView.FocusedColumn)].Element;
    if Assigned(Element) then begin
      if not EditWarn then
        Exit;

      ViewFocusedElement := Element.PreviousMember;
      EditFocusedViewElement := False;
      PostResetActiveTree;
    end;
  end;
end;

procedure TfrmMain.ReInitTree(aNoGameMaster: Boolean; aFiles: TwbFiles);
var
  i                           : Integer;
  _File                       : IwbFile;
begin
  if xeQuickClean then begin
    aFiles := nil;
    wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode).FilteredBy(function(aModule: PwbModuleInfo): Boolean
    begin
      Result := False;
      if Assigned(aModule.miFile) then
        aFiles.Add(aModule._File);
    end);
  end else
    if Length(aFiles) < 1 then
      aFiles := Files;

  FilterApplied := False;
  lblFilterHint.Visible := False;
  vstNav.BeginUpdate;
  try
    vstNav.Clear;
    for i := Low(aFiles) to High(aFiles) do begin
      _File := aFiles[i];
      if aNoGameMaster and (_File.FileStates * [fsIsGameMaster, fsIsHardcoded] <> []) then
        Continue;
      vstNav.AddChild(nil, Pointer(_File));
      _File._AddRef;
    end;
  finally
    vstNav.EndUpdate;
  end;
end;

function TfrmMain.RemovableSelection(ContainsChilds: PBoolean): TNodeArray;
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  i, j                        : Integer;
begin
  SetLength(Result, 0);
  if Assigned(ContainsChilds) then
    ContainsChilds^ := False;

  if not wbEditAllowed then
    Exit;
  if wbTranslationMode then
    Exit;

  Result := vstNav.GetSortedSelection(True);
  j := Low(Result);
  for i := Low(Result) to High(Result) do begin
    NodeData := vstNav.GetNodeData(Result[i]);
    if not Assigned(NodeData) then
      Continue;
    Element := NodeData.Element;
    if not Assigned(Element) then
      Continue;
    if not Element.IsRemovable then
      Continue;

    if Assigned(ContainsChilds) then
      ContainsChilds^ := ContainsChilds^ or
        (Assigned(NodeData.Container) and (NodeData.Container.ElementCount > 0));

    if i <> j then
      Result[j] := Result[i];
    Inc(j);
  end;
  SetLength(Result, j);
end;

procedure TfrmMain.ResetActiveTree;
var
  OffsetXY                    : TPoint;
  RootNodeCount               : Integer;
  MainRecord                  : IwbMainRecord;
  Column                      : TColumnIndex;
  Node                        : PVirtualNode;
  NodeDatas                   : PViewNodeDatas;
  r                           : TRect;
  ColumnWidths                : array of Integer;
  i                           : Integer;
  sw                          : TStopwatch;
  Containers                  : TwbContainerElementRefs;
begin
  sw := TStopwatch.StartNew;
  LockWindowUpdate(vstView.Handle);
  vstView.BeginUpdate;
  try
    repeat
      PendingResetActiveTree := False;
      with vstView.Header, Columns do begin
        SetLength(ColumnWidths, Count);
        for i := 0 to Pred(Count) do
          ColumnWidths[i] := Columns[i].Width;
      end;
      OffsetXY := vstView.OffsetXY;
      Column := vstView.FocusedColumn;
      Node := vstViewFocusedNode;
      if Assigned(Node) then begin
        r := vstView.GetDisplayRect(Node, Column, False);
        if not Assigned(ViewFocusedElement) then
          if (Column > 0) and (Pred(Column) <= High(ActiveRecords)) then begin
            NodeDatas := vstView.GetNodeData(Node);
            ViewFocusedElement := NodeDatas[Pred(Column)].Element;
            EditFocusedViewElement := False;
          end;
      end;
      NodeForViewFocusedElement := nil;

      Containers := CollectViewContainers;
      if Assigned(ActiveRecord) then begin
        MainRecord := ActiveRecord;
        DoSetActiveRecord(nil);
        DoSetActiveRecord(MainRecord);
      end
      else if Length(ActiveRecords) > 0 then begin
        RootNodeCount := vstView.RootNodeCount;
        vstView.Clear;
        vstView.RootNodeCount := RootNodeCount;
        InitConflictStatus(vstView.RootNode, False, @ActiveRecords[0]);
        ExpandView;
      end;
      Containers := nil;

      vstView.UpdateScrollBars(False);
      vstView.OffsetXY := OffsetXY;
      if Assigned(Node) then begin
        if Assigned(NodeForViewFocusedElement) then begin
          Node := NodeForViewFocusedElement;
          Column := ColumnForViewFocusedElement;
        end else
          Node := vstView.GetNodeAt(r.Left + 2, r.Top + 2);
        if Assigned(Node) then
          vstViewFocusedNode := Node;
      end;
      vstView.FocusedColumn := Column;
  //    vstView.OffsetXY := OffsetXY;
      if mniViewColumnWidthFitText.Checked or mniViewColumnWidthFitSmart.Checked then
        UpdateColumnWidths
      else
        with vstView.Header, Columns do begin
          if Length(ColumnWidths) = Count then
            for i := 0 to Pred(Count) do
              Columns[i].Width := ColumnWidths[i];
        end;
      if EditFocusedViewElement then begin
        EditFocusedViewElement := False;
        ViewFocusedElement := nil;
        NodeForViewFocusedElement := nil;
        vstView.EditNode(vstViewFocusedNode, vstView.FocusedColumn);
      end;
    until not PendingResetActiveTree;
  finally
    ViewFocusedElement := nil;
    EditFocusedViewElement := False;
    NodeForViewFocusedElement := nil;
    vstView.EndUpdate;
    if vstView.FocusedColumn > NoColumn then
      vstView.ScrollIntoView(vstView.FocusedColumn, False);
    LockWindowUpdate(0);
  end;
  sw.Stop;
  if sw.ElapsedMilliseconds > 1000 then
    wbProgress('ResetActiveTree took %d msec', [sw.ElapsedMilliseconds]);
end;

procedure TfrmMain.ResetAllConflict;
var
  i     : Integer;
  _File : IwbFile;
begin
  wbStartTime := Now;

  pnlClient.Enabled := False;
  UpdatePnlCancelVisible;
  try
    for i := Low(Files) to High(Files) do begin
      _File := Files[i];
      wbCurrentAction := 'Resetting conflict status for ' + _File.Name;
      DoProcessMessages;
      _File.ResetConflict;
    end;
  finally
    wbCurrentAction := '';
    Caption := Application.Title;
    pnlClient.Enabled := True;
    UpdatePnlCancelVisible;
  end;
end;

procedure TfrmMain.ResetAllTags;
var
  i     : Integer;
  _File : IwbFile;
begin
  wbStartTime := Now;

  pnlClient.Enabled := False;
  UpdatePnlCancelVisible;
  try
    for i := Low(Files) to High(Files) do begin
      _File := Files[i];
      wbCurrentAction := 'Resetting tags for ' + _File.Name;
      DoProcessMessages;
      _File.ResetTags;
    end;
  finally
    wbCurrentAction := '';
    Caption := Application.Title;
    pnlClient.Enabled := True;
    UpdatePnlCancelVisible;
  end;
end;

function TfrmMain.RestorePluginsFromMaster: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Files) to High(Files) do with Files[i] do
    if IsESM and (not (fsIsHardcoded in FileStates)) and SameText(ExtractFileExt(FileName), '.esp') then begin
      AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Removing ESM Flag: ' + FileName);
      IsESM := False;
      Result := True;
    end;
end;

procedure TfrmMain.mniMainSaveClick(Sender: TObject);
begin
  jbhSave.CancelHint;
  SaveChanged(False, True);
end;

procedure TfrmMain.mniMarkallfileswithoutONAMasmodifiedClick(Sender: TObject);
var
  i: Integer;
begin
  if not EditWarn then
    Exit;
  for i := Low(Files) to High(Files) do
    with Files[i] do
      if IsEditable then
        if not HasONAM then
          MarkHeaderModified;
  vstNav.Invalidate;
end;

function TfrmMain.SaveChanged(aSilent: Boolean = False; aShowMessageIfNothing: Boolean = False): TwbSaveResult;
var
  i, j                        : Integer;
  FileStream                  : TBufferedFileStream;
  FileType                    : array of Byte;
  _File                       : IwbFile;
  _LFile                      : TwbLocalizationFile;
  NeedsRename                 : Boolean;
  u                           : string;
  s                           : string;
  t                           : string;
  SavedAny                    : Boolean;
  SavedThisOne                : Boolean;
  AnyErrors                   : Boolean;
  TryDirectRename             : Boolean;
  FoundSomething              : Boolean;
  CRC                         : TwbCRC32;
  BackupWarningGiven          : Boolean;

const
  ResetModifiedFromBool : array[Boolean] of TwbResetModified =
    (rmNo, rmSetInternal);
begin
  Result := srNothingToDo;

  if wbDontSave then
    Exit;

  FoundSomething := False;
  BackupWarningGiven := False;
  SavedAny := False;

  pgMain.ActivePage := tbsMessages;

  with TfrmFileSelect.Create(nil) do try
    try
      for i := Low(Files) to High(Files) do
        if (Files[i].IsEditable) and (esUnsaved in Files[i].ElementStates) or wbTestWrite then begin
          CheckListBox1.AddItem(Files[i].FileNameOnDisk, Pointer(Files[i]));
          CheckListBox1.Checked[Pred(CheckListBox1.Count)] := esUnsaved in Files[i].ElementStates;
          SetLength(FileType, Succ(Length(FileType))); FileType[High(FileType)] := 0;
        end;

      if Assigned(wbLocalizationHandler) then try
        for i := 0 to Pred(wbLocalizationHandler.Count) do try
          if wbLocalizationHandler[i].Modified or wbTestWrite then begin
            CheckListBox1.AddItem(wbLocalizationHandler[i].Name, Pointer(wbLocalizationHandler[i]));
            CheckListBox1.Checked[Pred(CheckListBox1.Count)] := wbLocalizationHandler[i].Modified;
            SetLength(FileType, Succ(Length(FileType))); FileType[High(FileType)] := 1;
          end;
        except
          on E: Exception do
            wbProgress('Error while trying to access wbLocalizationHandler[%d]: [%s] %s', [i, E.ClassName, E.Message]);
        end;
      except
        on E: Exception do
          wbProgress('Error while trying to iterate over wbLocalizationHandler: [%s] %s', [E.ClassName, E.Message]);
      end;

      Caption := 'Save changed files:';
      cbBackup.Visible := True;
      if Assigned(Settings) then
        cbBackup.Checked := not Settings.ReadBool(frmMain.Name, 'DontBackup', not cbBackup.Checked);

      if (CheckListBox1.Count > 0) then begin
        FoundSomething := True;
        if (not (wbToolMode in wbAutoModes)) then begin
          if not aSilent then
            if ShowModal <> mrOk then
              Exit(srAbort);
          xeDontBackup := not cbBackup.Checked;
          if Assigned(Settings) then begin
            Settings.WriteBool(frmMain.Name, 'DontBackup', xeDontBackup);
            Settings.UpdateFile;
          end;
          wbStartTime := Now;
        end;
      end;

      Inc(wbShowStartTime);
      try
        SavedAny := False;
        AnyErrors := False;
        t := '.save.' + FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now);

        for i := 0 to Pred(CheckListBox1.Items.Count) do
          if CheckListBox1.Checked[i] then begin
            FoundSomething := True;
            TryDirectRename := False;
            SavedThisOne := False;

            // localization file
            if FileType[i] = 1 then begin
              _LFile := TwbLocalizationFile(CheckListBox1.Items.Objects[i]);
              s := _LFile.FileName;
              NeedsRename := FileExists(s);
              s := Copy(s, length(wbDataPath) + 1, length(s)); // relative path to string file from Data folder
              u := s;
              if NeedsRename then
                s := s + t;

              try
                ForceDirectories(ExtractFilePath(wbDataPath + s));
                if NeedsRename then begin
                  j := 0;
                  while FileExists(wbDataPath + s) do begin
                    Inc(j);
                    s := u + t + '_' + j.ToString;
                  end;
                end;
                FileStream := TBufferedFileStream.Create(wbDataPath + s, fmCreate, 1024*1024);
                try
                  PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Saving: ' + s);
                  _LFile.WriteToStream(FileStream);
                  SavedAny := True;
                  SavedThisOne := True;
                  TryDirectRename := True; //TODO: make sure this is ok?
                  _LFile.Modified := False;
                finally
                  FileStream.Free;
                end;

              except
                on E: Exception do begin
                  AnyErrors := True;
                  NeedsRename := False;
                  SavedThisOne := False;
                  PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Error saving ' + s + ': ' + E.Message);
                end;
              end;

            end else

            // plugin file
            begin

              _File := IwbFile(Pointer(CheckListBox1.Items.Objects[i]));

              s := CheckListBox1.Items[i];
              u := s;
              NeedsRename := FileExists(wbDataPath + CheckListBox1.Items[i]);
              if NeedsRename then begin
                s := s + t;
                j := 0;
                while FileExists(wbDataPath + s) do begin
                  Inc(j);
                  s := u + t + '_' + j.ToString;
                end;
              end;

              CRC := _File.CRC32;
              FileStream := TBufferedFileStream.Create(wbDataPath + s, fmCreate, 1024 * 1024);
              try
                try
                  PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Saving: ' + s);
                  _File.WriteToStream(FileStream, ResetModifiedFromBool[wbResetModifiedOnSave]);
                  SavedThisOne := True;
                  if not (fsMemoryMapped in _File.FileStates) then
                    TryDirectRename := True;
                finally
                  FileStream.Free;
                end;

                if NeedsRename then
                  if CRC = _File.CRC32 then begin
                    DeleteFile(wbDataPath + s);
                    NeedsRename := False;
                    TryDirectRename := False;
                    SavedThisOne := False;
                    PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] File has not changed, removing: ' + s);
                  end;

                if SavedThisOne then
                  SavedAny := True;
              except
                on E: Exception do begin
                  DeleteFile(wbDataPath + s);
                  AnyErrors := True;
                  NeedsRename := False;
                  PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Error saving ' + s + ': ' + E.Message);
                end;
              end;

            end;

            if SavedThisOne then begin
              if NeedsRename and TryDirectRename then try
                if not DoRenameModule(s, u, True) then begin
                  AnyErrors := True;
                  wbProgress('Direct save failed. Will queue save for renaming on shutdown.');
                end else
                  NeedsRename := False;
              except end;

              if NeedsRename then begin
                if not Assigned(FilesToRename) then
                  FilesToRename := TStringList.Create;
                // s - rename from, relative to DataPath
                // u - rename to, relative to DataPath
                FilesToRename.AddPair(u, s);
                wbProgress('Queued renaming of save "' + wbDataPath + s + '" to "' + wbDataPath + u + '" on shutdown.');
              end else begin
                if Assigned(FilesToRename) then
                  for j := Pred(FilesToRename.Count) downto 0 do begin
                    if SameText(u, FilesToRename.KeyNames[j]) then begin
                      s := FilesToRename.ValueFromIndex[j];
                      if xeDontBackup then begin
                        if not BackupWarningGiven then begin
                          wbProgress('******** WARNING ********');
                          wbProgress('* Backups are disabled! *');
                          wbProgress('******** WARNING ********');
                        end;
                        wbProgress('Removing previously queued save "' + wbDataPath + s + '" as a direct save to "' + wbDataPath + u + '" has succeeded.');
                        DeleteFile(wbDataPath + s);
                      end else begin
                        wbProgress('Backing up previously queued save "' + wbDataPath + s + '" as a direct save to "' + wbDataPath + u + '" has succeeded.');
                        DoBackupModule(s, u, aSilent);
                      end;
                      FilesToRename.Delete(j);
                    end;
                  end;
              end;
            end;

            DoProcessMessages;
            tmrMessagesTimer(nil);
          end;

      finally
        DoProcessMessages;
        tmrMessagesTimer(nil);
        Dec(wbShowStartTime);
      end;
    except
      on E: Exception do begin
        if not (E is EAbort) then
          AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Error "' + E.ClassName + '": "' + E.Message + '"');
        AnyErrors := True;
      end;
    end;

    if AnyErrors then
      AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Errors have occured. At least one file was not saved.');
    if SavedAny then begin
      AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Done saving.');
      Result := srAllDone;
    end;
    if AnyErrors then
      Exit(srError);
  finally
    Free;
    InvalidateElementsTreeView(NoNodes);
  end;

  if aShowMessageIfNothing and not FoundSomething then
    ShowMessage('No unsaved changes.');

  if SavedAny then
    SetSaveInterval;
end;

function TfrmMain.SelectionIncludesAnyDeepCopyRecords: Boolean;
var
  Selection                   : TNodeArray;
  i                           : Integer;
  NodeData                    : PNavNodeData;
  GroupRecord                 : IwbGroupRecord;
  MainRecord                  : IwbMainRecord;
begin
  Result := True;
  Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if Supports(NodeData.Element, IwbGroupRecord, GroupRecord) then
        Exit;
      if Supports(NodeData.Element, IwbMainRecord, MainRecord) then
        if Assigned(MainRecord.ChildGroup) then
          Exit;
    end;
  end;
  Result := False;
end;

function TfrmMain.SelectionIncludesAnyNotVWD(Selection: TNodeArray): Boolean;
var
  i                           : Integer;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
begin
  Result := False;
  if Length(Selection) = 0 then
    Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if Supports(NodeData.Element, IwbMainRecord, MainRecord) then begin
        if not MainRecord.IsVisibleWhenDistant then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
end;

function TfrmMain.SelectionIncludesAnyVWD(Selection: TNodeArray): Boolean;
var
  i                           : Integer;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
begin
  Result := False;
  if Length(Selection) = 0 then
    Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if Supports(NodeData.Element, IwbMainRecord, MainRecord) then begin
        if MainRecord.IsVisibleWhenDistant then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
end;

function TfrmMain.SelectionIncludesNonCopyNewRecords: Boolean;
var
  Selection                   : TNodeArray;
  i                           : Integer;
  NodeData                    : PNavNodeData;
  GroupRecord                 : IwbGroupRecord;
  MainRecord                  : IwbMainRecord;
  Signature                   : TwbSignature;
begin
  Result := True;
  Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if Supports(NodeData.Element, IwbMainRecord, MainRecord) then begin
        Signature := MainRecord.Signature;
        if (Signature = 'CELL') or (Signature = 'WRLD') or (Signature = 'ROAD') or (Signature = 'LAND') or (Signature = 'PGRD') or (Signature = 'NAVM') or (Signature = 'NAVI') then
          Exit;
      end;

      if Supports(NodeData.Element, IwbGroupRecord, GroupRecord) then
        case GroupRecord.GroupType of
        0: begin
          Signature := TwbSignature(GroupRecord.GroupLabel);
          if (Signature = 'CELL') or (Signature = 'WRLD') then
            Exit;
        end;
        1..6, 9:
          Exit;
        end;

    end;
  end;
  Result := False;
end;

function TfrmMain.SelectionIncludesOnlyDeepCopyRecords: Boolean;
var
  Selection                   : TNodeArray;
  i                           : Integer;
  NodeData                    : PNavNodeData;
  GroupRecord                 : IwbGroupRecord;
begin
  Result := False;
  Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if Supports(NodeData.Element, IwbGroupRecord, GroupRecord) then
        Continue;
      Exit;
    end;
  end;
  Result := True;
end;

function TfrmMain.SelectionIncludesOnlyREFR(Selection: TNodeArray): Boolean;
var
  i                           : Integer;
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
  Signature                   : TwbSignature;
begin
  Result := False;
  if Length(Selection) = 0 then
    Selection := vstNav.GetSortedSelection(True);
  if Length(Selection) < 1 then
    Exit;
  for i := Low(Selection) to High(Selection) do begin
    NodeData := vstNav.GetNodeData(Selection[i]);
    if Assigned(NodeData) then begin
      if not Supports(NodeData.Element, IwbMainRecord, MainRecord) then
        Exit;
      Signature := MainRecord.Signature;
      if (Signature <> 'REFR') then
          Exit;
    end;
  end;
  Result := True;
end;

procedure TfrmMain.SendAddFile(const aFile: IwbFile);
begin
  SendMessage(Handle, WM_USER + 1, UInt64(Pointer(aFile)), 0);
end;

procedure TfrmMain.SendLoaderDone(const aStartTime: TDateTime; aLoadOrder: Integer);
begin
  SendMessage(Handle, WM_USER + 2, NativeUInt(@aStartTime), aLoadOrder);
end;

procedure TfrmMain.DoSetActiveContainer(const aContainer: IwbDataContainer);
var
  i                           : Integer;
begin
  PendingContainer := nil;
  PendingMainRecords := nil;
  PendingResetActiveTree := False;

  UserWasActive := True;

  ComparingSiblings := False;
  CompareRecords := nil;

  if (ActiveContainer = aContainer) and (Assigned(ActiveContainer) = (Length(ActiveRecords) > 0)) then
    Exit;

  lvReferencedBy.Items.BeginUpdate;
  try
    vstView.BeginUpdate;
    try
      lvReferencedBy.Items.Clear;
      vstView.Clear;
      vstView.NodeDataSize := 0;
      SetLength(ActiveRecords, 0);
      ActiveMaster := nil;
      ActiveIndex := NoColumn;
      ActiveContainer := aContainer;

      if Assigned(ActiveContainer) then begin
        bnPinned.Enabled := True;
        ActiveMaster := nil;

        if wbLoaderDone then begin
          ActiveRecords := NodeDatasForContainer(ActiveContainer);
        end else begin
          SetLength(ActiveRecords, 1);
          ActiveRecords[0].Element := ActiveContainer;
          ActiveRecords[0].Container := ActiveContainer as IwbContainerElementRef;
        end;

        vstView.ShowHint := True;
        vstView.Header.Options := vstView.Header.Options + [hoShowHint];
        with vstView.Header.Columns do begin
          BeginUpdate;
          try
            Clear;

            with Add do begin
              Text := '';
              Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
              Options := Options - [coDraggable, coShowDropMark];
              Options := Options + [coFixed];
            end;
            for I := Low(ActiveRecords) to High(ActiveRecords) do
              with Add do begin
                Text := ActiveRecords[i].Element._File.Name;
                Hint := ActiveRecords[i].Element._File.Name;
                Style := vsOwnerDraw;
                Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
                MinWidth := Width div 2;
                MaxWidth := Screen.DesktopWidth;
                Options := Options - [coAllowclick, coShowDropMark];
                Options := Options + [coAutoSpring, coDraggable];
                if ActiveContainer.Equals(ActiveRecords[i].Element) then
                  ActiveIndex := i;
              end;
            if Length(ActiveRecords) > 1 then
              with Add do begin
                Text := '';
                Width := 0;
                MinWidth := 0;
                MaxWidth := Screen.DesktopWidth;
                Options := Options - [coAllowclick, coDraggable, coShowDropMark, coAllowFocus];
                Options := Options + [coFiller];
              end;
          finally
            EndUpdate;
          end;
        end;
        vstView.NodeDataSize := SizeOf(TViewNodeData) * Length(ActiveRecords);
        if Supports(ActiveContainer.Def, IwbStructDef) then
          vstView.RootNodeCount := (ActiveContainer.Def as IwbStructDef).MemberCount + ActiveContainer.AdditionalElementCount
        else
          vstView.RootNodeCount := 1;
        InitConflictStatus(vstView.RootNode, False, @ActiveRecords[0]);
        ExpandView;
        UpdateColumnWidths;
        if pgMain.ActivePage <> tbsReferencedBy then
          pgMain.ActivePage := tbsView;
      end
      else begin
        if not bnPinned.Down then
          bnPinned.Enabled := False;

        with vstView.Header.Columns do begin
          BeginUpdate;
          try
            Clear;
            with Add do begin
              Text := '';
              Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
              Options := Options + [coFiller];
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    finally
      vstView.EndUpdate;
      if vstView.FocusedColumn > NoColumn then
        vstView.ScrollIntoView(vstView.FocusedColumn, False);
    end;

    tbsReferencedBy.TabVisible := wbLoaderDone and (lvReferencedBy.Items.Count > 0);
    if tbsReferencedBy.TabVisible then
      tbsReferencedBy.Caption := Format('Referenced By (%d)', [lvReferencedBy.Items.Count]);
  finally
    lvReferencedBy.Items.EndUpdate;
  end;
end;

procedure TfrmMain.DoSetActiveRecord(const aMainRecords: TDynMainRecords);
begin
  PendingContainer := nil;
  PendingMainRecords := nil;
  PendingResetActiveTree := False;

  UserWasActive := True;

  if Length(aMainRecords) < 2 then begin
    if Length(aMainRecords) = 1 then
      DoSetActiveRecord(aMainRecords[0])
    else
      DoSetActiveRecord(IwbMainRecord(nil));
    Exit;
  end;

  bnPinned.Enabled := True;

  if Length(aMainRecords) = Length(ActiveRecords) then
  begin
    var FoundDifferent: Boolean := False;

    for var i := Low(ActiveRecords) to High(ActiveRecords) do
      with ActiveRecords[i] do
      begin
        FoundDifferent := (Assigned(Element) <> Assigned(aMainRecords[i])) or
                          (Assigned(Element) and not Element.Equals(aMainRecords[i]));
        if FoundDifferent then
          Break;
      end;

    if not FoundDifferent then
      Exit;
  end;

  ComparingSiblings := True;
  CompareRecords := aMainRecords;
  lvReferencedBy.Items.BeginUpdate;
  try
    vstView.BeginUpdate;
    try
      lvReferencedBy.Items.Clear;
      vstView.Clear;
      vstView.NodeDataSize := 0;
      SetLength(ActiveRecords, 0);
      ActiveMaster := nil;
      ActiveRecord := nil;
      ActiveIndex := NoColumn;

      SetLength(ActiveRecords, Length(aMainRecords));
      for var i := Low(ActiveRecords) to High(ActiveRecords) do
        with ActiveRecords[i] do begin
          Element := aMainRecords[i];
          Container := aMainRecords[i] as IwbContainerElementRef;
        end;

      vstView.ShowHint := True;
      vstView.Header.Options := vstView.Header.Options + [hoShowHint];
      with vstView.Header.Columns do begin
        BeginUpdate;
        try
          Clear;
          with Add do begin
            Text := '';
            Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
            Options := Options - [coDraggable, coShowDropMark];
            Options := Options + [coFixed];
          end;
          for var i := Low(ActiveRecords) to High(ActiveRecords) do
            with Add do begin
              Text := (ActiveRecords[i].Element as IwbMainRecord).EditorID;
              Hint := (ActiveRecords[i].Element as IwbMainRecord).EditorID;
              Style := vsOwnerDraw;
              Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
              MinWidth := Width div 2;
              MaxWidth := Screen.DesktopWidth;
              Options := Options - [coAllowclick, coShowDropMark];
              Options := Options + [coAutoSpring, coDraggable];
            end;
          if Length(ActiveRecords) > 1 then
            with Add do begin
              Text := '';
              Width := 0;
              MinWidth := 0;
              MaxWidth := Screen.DesktopWidth;
              Options := Options - [coAllowclick, coDraggable, coShowDropMark];
              Options := Options + [coFiller];
            end;
        finally
          EndUpdate;
        end;
      end;

      vstView.NodeDataSize := SizeOf(TViewNodeData) * Length(ActiveRecords);
      vstView.RootNodeCount := (aMainRecords[0].Def as IwbRecordDef).MemberCount + aMainRecords[0].AdditionalElementCount;
      InitConflictStatus(vstView.RootNode, False, @ActiveRecords[0]);
      ExpandView;
      UpdateColumnWidths;
    finally
      vstView.EndUpdate;
      if vstView.FocusedColumn > NoColumn then
        vstView.ScrollIntoView(vstView.FocusedColumn, False);
    end;
    pgMain.ActivePage := tbsView;
    tbsReferencedBy.TabVisible := False;
  finally
    lvReferencedBy.Items.EndUpdate;
  end;
end;

procedure TfrmMain.SetActiveContainer(const aContainer: IwbDataContainer);
begin
  UserWasActive := True;
  if Assigned(aContainer) and (tmrPendingSetActive.Interval > 0) then begin
    PendingContainer := aContainer;
    PendingMainRecords := nil;
    tmrPendingSetActive.Enabled := False;
    tmrPendingSetActive.Enabled := True;
  end else
    DoSetActiveContainer(aContainer);
end;

procedure TfrmMain.SetActiveRecord(const aMainRecord: IwbMainRecord);
begin
  UserWasActive := True;
  if Assigned(aMainRecord) and (tmrPendingSetActive.Interval > 0) then begin
    PendingContainer := nil;
    PendingMainRecords := [aMainRecord];
    tmrPendingSetActive.Enabled := False;
    tmrPendingSetActive.Enabled := True;
  end else
    DoSetActiveRecord(aMainRecord);
end;

procedure TfrmMain.SetActiveRecord(const aMainRecords: TDynMainRecords);
begin
  UserWasActive := True;
  if (Length(aMainRecords) > 0) and (tmrPendingSetActive.Interval > 0) then begin
    PendingContainer := nil;
    PendingMainRecords := aMainRecords;
    tmrPendingSetActive.Enabled := False;
    tmrPendingSetActive.Enabled := True;
  end else
    DoSetActiveRecord(aMainRecords);
end;

function TfrmMain.SetAllToMaster: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Files) to High(Files) do with Files[i] do
    if (not IsESM) and (not (fsIsHardcoded in FileStates)) then begin
      AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Setting ESM Flag: ' + FileName);
      IsESM := True;
      Result := True;
    end else begin
      if wbMasterUpdateFilterONAM and (MasterCount[True] > 0) then
        Elements[0].MarkModifiedRecursive(AllElementTypes);
    end;
end;

function TfrmMain.UpdateAllOnam: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Files) to High(Files) do with Files[i] do
    if IsEditable and (FileStates * [fsIsGameMaster, fsIsHardcoded, fsIsOfficial] = []) then begin
      if MasterCount[True] > 0 then begin
        Elements[0].MarkModifiedRecursive(AllElementTypes);
        AddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Updating ONAM in: ' + FileName);
        Result := True;
      end;
    end;
end;

procedure TfrmMain.SetDoubleBuffered(aWinControl: TWinControl);
var
  i                           : Integer;
begin
  aWinControl.DoubleBuffered := True;
  for i := Pred(aWinControl.ControlCount) downto 0 do
    if aWinControl.Controls[i] is TWinControl then
      SetDoubleBuffered(TWinControl(aWinControl.Controls[i]))
    else
      Exit;
end;

procedure TfrmMain.SetSaveInterval;
var
  MinUnsavedSince : TDateTime;
  j               : Integer;
begin
  MinUnsavedSince := MaxDouble;

  for j := Low(Files) to High(Files) do
    if esUnsaved in Files[j].ElementStates then
      if Files[j].UnsavedSince < MinUnsavedSince then
        MinUnsavedSince := Files[j].UnsavedSince;

  if MinUnsavedSince < Now then
    SaveInterval := (Now - MinUnsavedSince) + DefaultInterval
  else
    SaveInterval := DefaultInterval;
end;

function TfrmMain.GetViewNodePositionLabel(aNode: PVirtualNode = nil): string;
var
  Node: PVirtualNode;
begin
  if Assigned(aNode) then
    Node := aNode
  else
    Node := vstView.TopNode;

  while Assigned(Node) and (Node <> vstView.RootNode) do begin
    Result := '\' + vstView.Text[Node, 0, False] + Result;
    Node := Node.Parent;
  end;

  if Length(Result) <> 0 then
    Delete(Result, 1, 1);
end;

procedure TfrmMain.SetViewFocusedNode(aNode: PVirtualNode);
begin
  OverrideViewFocusedNode := nil;
  vstView.FocusedNode := aNode;
end;

procedure TfrmMain.SetViewNodePositionLabel(aViewLabel: string);
var
  Node, LabelNode: PVirtualNode;
  s, DefName: string;
  i: integer;
  bFound: Boolean;
begin
  if aViewLabel = '' then
    Exit;

  Node := vstView.GetFirst;

  if not Assigned(Node) then
    Exit;

  LabelNode := nil;

  with TStringList.Create do try
    Delimiter := '\';
    StrictDelimiter := True;
    DelimitedText := aViewLabel;

    for i := 0 to Pred(Count) do begin
      DefName := Strings[i];
      bFound := False;
      while Assigned(Node) do begin
        s := vstView.Text[Node, 0, False];
        if s = DefName then begin
          LabelNode := Node;
          Node := Node.FirstChild;
          bFound := True;
          Break;
        end;
        Node := vstView.GetNextSibling(Node);
      end;

      if not Assigned(Node) or not bFound then
        Break;
    end;
  finally
    Free;
  end;

  if Assigned(LabelNode) then begin
    vstView.TopNode := LabelNode;
    if StickViewNodeLabel <> '*' then
      vstViewFocusedNode := LabelNode;
    FoundViewLabelNode := LabelNode;
  end;
end;

procedure TfrmMain.DoSetActiveRecord(const aMainRecord: IwbMainRecord);
var
  i                           : Integer;
  ViewLabel: string;
begin
  PendingContainer := nil;
  PendingMainRecords := nil;
  PendingResetActiveTree := False;

  UserWasActive := True;

  ComparingSiblings := False;
  CompareRecords := nil;

  if (ActiveRecord = aMainRecord) and (Assigned(ActiveRecord) = (Length(ActiveRecords) > 0)) then
    Exit;

  Inc(ActiveRecordLock);
  lvReferencedBy.Items.BeginUpdate;
  try
    vstView.BeginUpdate;
    try
      // automatic sticking to the current top visible node
      if StickViewNodeLabel = '*' then
        ViewLabel := GetViewNodePositionLabel
      // manual to the stored node label
      else if StickViewNodeLabel <> '' then
        ViewLabel := StickViewNodeLabel
      // no sticking
      else
        ViewLabel := '';

      lvReferencedBy.Items.Clear;
      vstView.Clear;
      vstView.NodeDataSize := 0;
      SetLength(ActiveRecords, 0);
      ActiveMaster := nil;
      ActiveIndex := NoColumn;
      ActiveRecord := aMainRecord;
      NodeForViewFocusedElement := nil;
      ColumnForViewFocusedElement := NoColumn;

      if Assigned(ActiveRecord) then begin
        bnPinned.Enabled := True;
        ActiveMaster := nil;
        if wbLoaderDone then
          ActiveMaster := ActiveRecord.MasterOrSelf
        else
          ActiveMaster := ActiveRecord;

        if wbLoaderDone then begin
          ActiveRecords := NodeDatasForMainRecord(ActiveRecord);
        end else begin
          SetLength(ActiveRecords, 1);
          ActiveRecords[0].Element := ActiveRecord;
          ActiveRecords[0].Container := ActiveRecord as IwbContainerElementRef;
        end;

        vstView.ShowHint := True;
        vstView.Header.Options := vstView.Header.Options + [hoShowHint];
        with vstView.Header.Columns do begin
          BeginUpdate;
          try
            Clear;
            with Add do begin
              Text := '';
              Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
              Options := Options - [coDraggable, coShowDropMark];
              Options := Options + [coFixed];
            end;
            for I := Low(ActiveRecords) to High(ActiveRecords) do
              with Add do begin
                Text := ActiveRecords[i].Element._File.Name;
                Hint := ActiveRecords[i].Element._File.Name;
                Style := vsOwnerDraw;
                Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
                MinWidth := Width div 2;
                MaxWidth := Screen.DesktopWidth;
                Options := Options - [coAllowclick, coShowDropMark];
                Options := Options + [coAutoSpring, coDraggable];
                if ActiveRecord.Equals(ActiveRecords[i].Element) then
                  ActiveIndex := i;
              end;
            if Length(ActiveRecords) > 1 then
              with Add do begin
                Text := '';
                Width := 0;
                MinWidth := 0;
                MaxWidth := Screen.DesktopWidth;
                Options := Options - [coAllowclick, coDraggable, coShowDropMark];
                Options := Options + [coFiller];
              end;
          finally
            EndUpdate;
          end;
        end;
        vstView.NodeDataSize := SizeOf(TViewNodeData) * Length(ActiveRecords);
        if Assigned(ActiveMaster) and Assigned(ActiveMaster.Def) then begin
          vstView.RootNodeCount := (ActiveMaster.Def as IwbRecordDef).MemberCount + ActiveMaster.AdditionalElementCount;
          InitConflictStatus(vstView.RootNode, ActiveMaster.IsInjected and not ((ActiveMaster.Signature = 'GMST') or (ActiveMaster.Signature = 'DFOB')), @ActiveRecords[0]);
          ExpandView;
        end;

        SetViewNodePositionLabel(ViewLabel);
        if (vstView.FocusedColumn < 1) and (ColumnForViewFocusedElement < 1) and (ActiveIndex > NoColumn) then
          vstView.FocusedColumn := ActiveIndex + 1;
        UpdateColumnWidths;
        if vstView.FocusedColumn > NoColumn then
          vstView.ScrollIntoView(vstView.FocusedColumn, False);

        if pgMain.ActivePage <> tbsReferencedBy then
          pgMain.ActivePage := tbsView;
      end
      else begin
        if not bnPinned.Down then
          bnPinned.Enabled := False;
        with vstView.Header.Columns do begin
          BeginUpdate;
          try
            Clear;
            with Add do begin
              Text := '';
              Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
              Options := Options + [coFiller];
            end;
          finally
            EndUpdate;
          end;
        end;
      end;
    finally
      vstView.EndUpdate;
      if vstView.FocusedColumn > NoColumn then
        vstView.ScrollIntoView(vstView.FocusedColumn, False);
    end;

    if wbLoaderDone and Assigned(ActiveMaster) {$IFDEF USE_PARALLEL_BUILD_REFS}and not wbBuildingRefsParallel{$ENDIF} then begin
      lvReferencedBy.Tag := ActiveMaster.ReferencedByCount;
      if pgMain.ActivePage = tbsReferencedBy then begin
        for i := 0 to Pred(ActiveMaster.ReferencedByCount) do
          with lvReferencedBy.Items.Add do begin
            Caption := ActiveMaster.ReferencedBy[i].Name;
            SubItems.Add(ActiveMaster.ReferencedBy[i].Signature);
            SubItems.Add(ActiveMaster.ReferencedBy[i]._File.Name);
            Data := Pointer(ActiveMaster.ReferencedBy[i]);
          end;
      end;
    end else
      lvReferencedBy.Tag := 0;

    var lCurrentPage := pgMain.ActivePage;
    tbsReferencedBy.TabVisible := wbLoaderDone and (lvReferencedBy.Tag > 0);
    if lCurrentPage = tbsReferencedBy then
      pgMain.ActivePage := tbsReferencedBy;
    if tbsReferencedBy.TabVisible then
      tbsReferencedBy.Caption := Format('Referenced By (%d)', [lvReferencedBy.Tag]);
  finally
    lvReferencedBy.Items.EndUpdate;
    Dec(ActiveRecordLock);
  end;

  if Assigned(pgMain.ActivePage) then
    pgMain.ActivePage.Visible := True;
end;

procedure TfrmMain.ShowChangeReferencedBy(OldFormID, NewFormID: TwbFormID; const ReferencedBy: TDynMainRecords; aSilent: Boolean);
var
  Counter    : Integer;
  i          : Integer;
  Error      : Boolean;
  s          : string;
begin
  with TfrmFileSelect.Create(nil) do try
    Caption := 'Please select records to update';

    Counter := 0;
    for i := Low(ReferencedBy) to High(ReferencedBy) do begin
      CheckListBox1.AddItem(ReferencedBy[i].Name + ' - ' + ReferencedBy[i]._File.Name, Pointer(ReferencedBy[i]));
      if ReferencedBy[i].IsEditable then begin
        CheckListBox1.ItemEnabled[i] := True;
        Inc(Counter)
      end else
        CheckListBox1.ItemEnabled[i] := False;
    end;

    if Counter <= 0 then begin
      if not aSilent then
        ShowMessage('There are ' + IntToStr(Length(ReferencedBy)) + ' records referencing FormID ' + OldFormID.ToString(True) + ' but none of them are in editable files.');
      Exit;
    end;

    if not aSilent then begin
      if ShowModal <> mrOk then
        Exit;

      for i := Pred(CheckListBox1.Count) downto 0 do
        if not CheckListBox1.Checked[i] then
          CheckListBox1.Items.Delete(i)
        else
          CheckListBox1.Checked[i] := False;
    end;

    if CheckListBox1.Count > 0 then begin

      if wbCurrentAction = '' then
        s := 'Updating referencing records'
      else
        s := '';

      PerformLongAction(s, '', procedure
      var
        i       : Integer;
        Counter : Integer;
      begin
        Counter := 0;
        Error := False;
        for i := 0 to Pred(CheckListBox1.Count) do try
          CheckListBox1.Checked[i] := IwbMainRecord(Pointer(CheckListBox1.Items.Objects[i])).CompareExchangeFormID(OldFormID, NewFormID);
          if CheckListBox1.Checked[i] then
            Inc(Counter);
          wbTick;
        except
          on E: Exception do begin
            wbProgress('Error updating FormID for ' + CheckListBox1.Items[i] + ': ' + E.Message);
            Error := True;
          end;
        end;

        wbProgress(IntToStr(Counter) + ' records out of '+IntToStr(Length(ReferencedBy))+' total records which reference FormID [' + OldFormID.ToString(True) + '] have been updated to [' + NewFormID.ToString(True) + ']');
      end);

      if not aSilent then begin
        if Error then
          ShowMessage('At least one record could not be updated. Check the message log for detailed error messages');

        Caption := 'These records have been successfully updated:';

        ShowModal;
      end;

    end;

  finally
    Free;
  end;
end;

procedure TfrmMain.ShowDeveloperMessage(aForce: Boolean);
var
  i           : Integer;
  LastShownOn : Int64;
begin
  i := Settings.ReadInteger('DeveloperMessage', 'Version', 0);

  if not aForce then
    if not wbPatron then begin
      LastShownOn := Settings.ReadInteger('DeveloperMessage', 'LastShownOn', 0);
      if LastShownOn + 14 <= Trunc(Date) then
        aForce := True;
    end;

  if aForce or (i < wbDeveloperMessageVersion) then
    with TfrmDeveloperMessage.Create(Self) do try

      if wbPatron then begin
        btnCancel.Cancel := True;
        btnCancel.Default := True;
        btnCancel.Enabled := True;
        btnCancel.Caption := 'Close';
        btnOK.Visible := False;
        btnOK.Default := False;
        btnOK.Enabled := False;
        btnKoFi.Visible := False;
        btnKoFi.Default := False;
        btnKoFi.Enabled := False;
        btnPayPal.Visible := False;
        btnKoFi.Default := False;
        btnKoFi.Enabled := False;
        ActiveControl := btnCancel;
        tmrEnableButton.Interval := 1;
      end;

      if i > 0 then
        cbDontShowAgain.Checked := True;

      if ShowModal = mrOk then
        if not wbPatron then
          case Choice of
            dmcKoFi:
              bnKoFi.Click;
            dmcPayPal:
              bnPayPal.Click;
          else
            bnPatreon.Click;
          end;

      Settings.WriteInteger('DeveloperMessage', 'LastShownOn', Trunc(Date));

      if cbDontShowAgain.Checked then
        Settings.WriteInteger('DeveloperMessage', 'Version', wbDeveloperMessageVersion)
      else
        Settings.WriteInteger('DeveloperMessage', 'Version', 0);

      Settings.UpdateFile;
    finally
      Free;
    end;

end;

procedure TfrmMain.ShrinkButtons;
var
  i: Integer;
begin
  with pnlBtn do
    for i := Pred(ControlCount) downto 0 do
      if Controls[i] is TSpeedButton then
        with TSpeedButton(Controls[i]) do
          if Tag = 0 then begin
            HelpKeyword := Hint;
            Hint := Caption;
            Caption := '';
            Constraints.MaxWidth := Width;
            Width := (Height - Glyph.Height) + Glyph.Width;
            ShowHint := not Hint.IsEmpty;
          end;

  bnNexusMods.Flat := not btnNexusModsNewVersion;
  bnGithub.Flat := not btnGithubNewVersion;
end;

procedure TfrmMain.splElementsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    pnlNav.Visible := not pnlNav.Visible;
end;

procedure TfrmMain.tbsMessagesShow(Sender: TObject);
begin
  ScrollToTheLastMessage;
  tbsMessages.Highlighted := False;
end;

procedure TfrmMain.tbsSpreadsheetShow(Sender: TObject);
var
  Signature                   : TwbSignature;

  procedure CollectKeywords(const aElement: IwbElement; slKeywords: TwbFastStringListCS; var arKeywords: TDynMainRecords);
  var
    MainRecord : IwbMainRecord;
    CER1       : IwbContainerElementRef;
    Keywords   : IwbContainerElementRef;
    Keyword    : IwbMainRecord;
    i          : Integer;
    s          : string;
  begin
    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    Supports(MainRecord, IwbContainerElementRef, CER1);

    if not Supports(MainRecord.ElementBySignature['KWDA'], IwbContainerElementRef, Keywords) then
      Exit;

    for i := 0 to Pred(Keywords.ElementCount) do
      if Supports(Keywords.Elements[i].LinksTo, IwbMainRecord, Keyword) then begin
        s := Keyword.LoadOrderFormID.ToString(False);
        if slKeywords.IndexOf(s) < 0 then begin
          SetLength(arKeywords, Succ(Length(arKeywords)));
          arKeywords[High(arKeywords)] := Keyword;
          slKeywords.AddObject(s, Pointer(Keyword)); //uncounted ref, kept alive via arKeywords reference
        end;
      end;
  end;

  function CheckHasKeywords(const aElement: IwbElement; aKeywords: TwbFastStringListCS): Boolean;
  var
    slItemKeywords : TwbFastStringListCS;
    arItemKeywords : TDynMainRecords;
    i, j           : Integer;
    FoundIt        : Boolean;
  begin
    Result := True;

    slItemKeywords := TwbFastStringListCS.CreateSorted;
    try
      CollectKeywords(aElement, slItemKeywords, arItemKeywords);
      if slItemKeywords.Count < aKeywords.Count then
        Exit(False); //no chance for slItemKeywords to include all of aKeywords;

      { Both slItemKeywords and aKeywords are sorted here. slItemKeywords must
        include all of aKeywords, but can contain more. }
      j := 0;
      for i := 0 to Pred(aKeywords.Count) do begin
        FoundIt := False;
        while j < slItemKeywords.Count do begin
          Inc(j);
          case CompareStr(aKeywords[i], slItemKeywords[Pred(j)]) of
            {aKeywords < slItemKeywords}
            Low(Integer)..-1: Exit(False); //a required keyword is missing, exit function
            {identical}
            0: begin
              FoundIt := True;
              Break;                      //exit the while loop
            end;
            {aKeywords > slItemKeywords}
            1..High(Integer): ;            //additional keyword in slItemKeywords, keep looping
          end;
        end;
        if not FoundIt then
          Exit(False);
      end;
    finally
      FreeAndNil(slItemKeywords);
    end;
  end;

  procedure ShowKeywordSelection(slKeywords: TwbFastStringListCS; var arKeywords: TDynMainRecords);
  var
    i           : Integer;
    NewKeywords : TDynMainRecords;
    sl2         : TwbFastStringListIC;
  begin
    sl2 := TwbFastStringListIC.CreateSorted(dupIgnore);
    try
      sl2.CommaText := Settings.ReadString(Signature + ' Spreadsheet', 'Keywords', '');

      with TfrmFileSelect.Create(nil) do try
        Caption := 'Select Keywords to filter on';

        for i := Low(arKeywords) to High(arKeywords) do begin
          CheckListBox1.AddItem(arKeywords[i].Name, Pointer(arKeywords[i]));
          if sl2.IndexOf(arKeywords[i].EditorID) >= 0 then
            CheckListBox1.Checked[Pred(CheckListBox1.Count)] := True;
        end;
        CheckListBox1.Sorted := True;

        slKeywords.Clear;
        slKeywords.Sorted := False;
        NewKeywords := nil;

        if ShowModal = mrOK then
          with CheckListBox1 do
            for i := 0 to Pred(Count) do
              if Checked[i] then
                slKeywords.AddObject(IwbMainRecord(Pointer(Items.Objects[i])).LoadOrderFormID.ToString(False), Items.Objects[i]);

        slKeywords.Sorted := True;

        sl2.Clear;
        with slKeywords do begin
          SetLength(NewKeywords, Count);
          for i := 0 to Pred(Count) do begin
            NewKeywords[i] := IwbMainRecord(Pointer(Objects[i]));
            sl2.Add(NewKeywords[i].EditorID);
          end;
        end;

        arKeywords := NewKeywords;
      finally
        Free;
      end;

      Settings.WriteString(Signature + ' Spreadsheet', 'Keywords', sl2.CommaText);
      Settings.UpdateFile;
    finally
      sl2.Free;
    end;
  end;

var
  i                           : Integer;
  j                           : Integer;
  _File                       : IwbFile;
  Group                       : IwbGroupRecord;
  Element                     : IwbElement;
  vstSpreadSheet              : TVirtualEditTree;
  sl2                         : TStringList;
  slKeywords                  : TwbFastStringListCS;
  arKeywords                  : TDynMainRecords;
begin
  if not wbLoaderDone then
    Exit;

  arKeywords := nil;
  slKeywords := nil;
  try
    pnlNav.Hide;
    lblPath.Visible := False;

    vstSpreadSheet := ((Sender as TTabSheet).Controls[0] as TVirtualEditTree);
    if vstSpreadSheet.NodeDataSize > 0 then
      Exit;

    Signature := StrToSignature(Copy((Sender as TComponent).Name, 4, 4));
    //!!!
    with TfrmFileSelect.Create(nil) do try

      Caption := 'Select files to compare';

      sl2 := TStringList.Create;
      try
        sl2.Sorted := True;
        sl2.Duplicates := dupIgnore;
        sl2.CommaText := Settings.ReadString(Signature + ' Spreadsheet', 'Selection', '');

        for i := Low(Files) to High(Files) do
          if Files[i].HasGroup(Signature) then begin
            CheckListBox1.AddItem(Files[i].FileName, Pointer(Files[i]));
            if sl2.IndexOf(Files[i].FileName) >= 0 then
              CheckListBox1.Checked[Pred(CheckListBox1.Items.Count)] := True;
          end;
        CheckListBox1.Sorted := True;

        sl2.Clear;
        if ShowModal = mrOK then begin
          for i := 0 to Pred(CheckListBox1.Count) do
            if CheckListBox1.Checked[i] then
              sl2.Add(CheckListBox1.Items[i]);

          Settings.WriteString(Signature + ' Spreadsheet', 'Selection', sl2.CommaText);
          Settings.UpdateFile;
        end else
          for i := 0 to Pred(CheckListBox1.Count) do
            CheckListBox1.Checked[i] := False;
      finally
        FreeAndNil(sl2);
      end;

      if wbIsSkyrim then begin
        slKeywords := TwbFastStringListCS.CreateSorted;
        for i := 0 to Pred(CheckListBox1.Count) do
          if CheckListBox1.Checked[i] then begin
            _File := IwbFile(Pointer(CheckListBox1.Items.Objects[i]));
            Group := _File.GroupBySignature[Signature];
            for j := 0 to Pred(Group.ElementCount) do begin
              Element := Group.Elements[j];
              CollectKeywords(Element, slKeywords, arKeywords);
            end;
          end;
        if slKeywords.Count > 0 then
          ShowKeywordSelection(slKeywords, arKeywords);

        if slKeywords.Count < 1 then
          FreeAndNil(slKeywords);
      end;

      vstSpreadSheet.BeginUpdate;
      try
        vstSpreadSheet.Clear;
        vstSpreadSheet.NodeDataSize := vstSpreadSheet.Header.Columns.Count * SizeOf(TSpreadSheetNodeData);

        for i := 0 to Pred(CheckListBox1.Count) do
          if CheckListBox1.Checked[i] then begin
            _File := IwbFile(Pointer(CheckListBox1.Items.Objects[i]));
            Group := _File.GroupBySignature[Signature];
            for j := 0 to Pred(Group.ElementCount) do begin
              Element := Group.Elements[j];
              if not Assigned(slKeywords) or CheckHasKeywords(Element, slKeywords) then begin
                vstSpreadSheet.AddChild(nil, Pointer(Element));
                Element._AddRef;
              end;
            end;
          end;

        with vstSpreadSheet.Header.Columns do
          for i := 0 to Pred(Count) do
            with Items[i] do
              MaxWidth := 250;
        vstSpreadSheet.Header.AutoFitColumns(False);
        with vstSpreadSheet.Header.Columns do
          for i := 0 to Pred(Count) do
            with Items[i] do
              MaxWidth := 1000;
      finally
        vstSpreadSheet.EndUpdate;
      end;
    finally
      Free;
    end;
  finally
    FreeAndNil(slKeywords);
    arKeywords := nil;
  end;
end;

procedure TfrmMain.tbsViewShow(Sender: TObject);
begin
  tbsView.TabVisible := True;
  pnlNav.Show;
  var lNode := vstNav.FocusedNode;
  if vstNavLastChangeNode <> lNode then
    vstNavChange(vstNav, lNode);
end;

procedure TfrmMain.tmrShutdownTimer(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.tmrStartupTimer(Sender: TObject);
begin
  tmrStartup.Enabled := False;
  if InitStarted then
    Exit;
  InitStarted := True;

  DoInit;
end;

procedure TfrmMain.tmrUpdateColumnWidthsTimer(Sender: TObject);
begin
  tmrUpdateColumnWidths.Enabled := False;
  UpdateColumnWidths;
end;

procedure TfrmMain.UpdateColumnWidths;
var
  i              : Integer;
  ColWidth       : Integer;
  AvailableWidth : Integer;
  NewWidth       : Integer;
  MinWidth       : Integer;
  ClientWidth    : Integer;
begin
  if vstView.Header.Columns.Header.States * [
    hsAutoSizing,              // auto size chain is in progess, do not trigger again on WM_SIZE
    hsDragging,                // header dragging is in progress (only if enabled)
    hsColumnWidthTracking,     // column resizing is in progress
    hsColumnWidthTrackPending, // left button is down, user might want to start resize a column
    hsResizing                 // multi column resizing in progress
  ] <> [] then
    Exit;

  vstView.BeginUpdate(True);
  vstView.Header.Columns.BeginUpdate;
  try
    with vstView.Header, Columns do begin
      if Count < 1 then
        Exit;

      if mniViewColumnWidthFitText.Checked or mniViewColumnWidthFitSmart.Checked then
        AutoFitColumns(False, smaAllColumns, 0, 0)
      else
        Columns[0].Width := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));

      if Count > 2 then begin

        repeat
          ClientWidth := vstView.ClientWidth;

          if mniViewColumnWidthFitAll.Checked or mniViewColumnWidthFitSmart.Checked then begin
            MinWidth := 0;
            for i := 1 to (Count - 2) do
              Inc(MinWidth, Columns[i].MinWidth);
            AvailableWidth := ClientWidth - Columns[0].Width;
            if MinWidth >= AvailableWidth then begin
              for i := 1 to (Count - 2) do
                Columns[i].Width := Columns[i].MinWidth;
              Break;
            end;
          end;

          if mniViewColumnWidthFitText.Checked or mniViewColumnWidthFitSmart.Checked then begin
            AutoFitColumns(False, smaAllColumns, 1);
            if mniViewColumnWidthFitSmart.Checked then
              for i := 1 to (Count - 2) do
                Columns[i].Width := Max(Columns[i].MinWidth, Min(Columns[i].Width, ClientWidth));
          end;

          ColWidth := 0;
          MinWidth := 0;
          if mniViewColumnWidthFitSmart.Checked then begin
            for i := 0 to (Count - 2) do begin
              Inc(ColWidth, Columns[i].Width);
              Inc(MinWidth, Columns[i].MinWidth);
            end;
            if MinWidth  > ClientWidth then
              ClientWidth := MinWidth;
            if ColWidth > ClientWidth then begin
              Dec(ColWidth, Columns[0].Width);
              AvailableWidth := ClientWidth - Columns[0].Width;
              if AvailableWidth > 0 then begin
                NewWidth := 0;
                for i := 1 to (Count - 3) do
                  with Columns[i] do begin
                    Width := Max(MulDiv(Width, AvailableWidth, ColWidth), MinWidth);
                    Inc(NewWidth, Width);
                  end;
                Columns[Count-2].Width := Pred(AvailableWidth - NewWidth);
              end;
            end;
            Break;
          end else if mniViewColumnWidthFitText.Checked then
            Break;

          if mniViewColumnWidthFitAll.Checked then begin
            ColWidth := (vstView.ClientWidth - Columns[0].Width) div (Count - 2);
            for i := 1 to (Count - 2) do
              Columns[i].Width := ColWidth;
          end else begin
            ColWidth := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
            for i := 1 to Pred(Count) do
              Columns[i].Width := ColWidth;
          end;

        until True;

      end;

      if Count = 2 then begin
        if mniViewColumnWidthFitText.Checked or mniViewColumnWidthFitSmart.Checked then begin
          AutoFitColumns(False, smaAllColumns, 1);
          ColWidth := (vstView.ClientWidth - Columns[0].Width);
          with Columns[1] do
            Width := Min(Width, ColWidth);
        end else
          with Columns[1] do
            Width := Pred(vstView.ClientWidth - Columns[0].Width);
      end;
    end;
  finally
    vstView.Header.Columns.EndUpdate;
    vstView.EndUpdate;
  end;
end;

procedure TfrmMain.UpdatePnlCancelPosition;
begin
  pnlCancel.SetBounds(
    (ClientWidth - pnlCancel.Width) div 2,
    (ClientHeight - pnlCancel.Height) div 2,
    pnlCancel.Width,
    pnlCancel.Height
  );
end;

procedure TfrmMain.UpdatePnlCancelVisible;
var
  WasVisible : Boolean;
begin
  UpdatePnlCancelPosition;
  WasVisible := pnlCancel.Visible;
  pnlCancel.Visible := not pnlClient.Enabled;
  if pnlCancel.Visible <> WasVisible then
    wbForceTerminate := False;
  if pnlCancel.Visible then
    pnlCancel.BringToFront;
end;

procedure TfrmMain.SetDefaultNodeHeight(aHeight: Integer);
begin
  vstNav.DefaultNodeHeight := aHeight;
  vstNav.Header.Height := aHeight + 3;
  vstView.DefaultNodeHeight := aHeight;
  vstView.Header.Height := aHeight + 3;
  vstSpreadSheetWeapon.DefaultNodeHeight := aHeight;
  vstSpreadSheetWeapon.Header.Height := aHeight + 3;
  vstSpreadSheetArmor.DefaultNodeHeight := aHeight;
  vstSpreadSheetArmor.Header.Height := aHeight + 3;
  vstSpreadSheetAmmo.DefaultNodeHeight := aHeight;
  vstSpreadSheetAmmo.Header.Height := aHeight + 3;
end;

function TfrmMain.ValidateCRC(const aFileName  : string;
                              const aValidCRCs : TDynCardinalArray;
                                out aFileCRC   : Cardinal)
                                               : Boolean;
var
  i: Integer;
begin
  aFileCRC := 0;
  Result := Length(aValidCRCs) < 1;
  if not Result then begin
    if Assigned(FileCRCs) and FileCRCs.Find(aFileName, i) then
      aFileCRC := Cardinal(FileCRCs.Objects[i])
    else begin
      try
        aFileCRC := wbCRC32File(wbDataPath + aFileName);
      except
        aFileCRC := 0;
      end;
      if not Assigned(FileCRCs) then
        FileCRCs := TwbFastStringListIC.CreateSorted;
      FileCRCs.AddObject(aFileName, TObject(aFileCRC));
    end;
    for i := Low(aValidCRCs) to High(aValidCRCs) do
      if aValidCRCs[i] = aFileCRC then
        Exit(True);
  end;
end;

procedure TfrmMain.tmrCheckUnsavedTimer(Sender: TObject);
var
  i, j                        : Integer;
  sl                          : TStringList;
  FoundExpired                : Boolean;
begin
  if not wbLoaderDone then
    Exit;

  if UserWasActive then begin
    if not ScriptRunning then //count running script as user activity
      UserWasActive := False;
    TotalUsageTime := TotalUsageTime + 1 / 24 / 60 / 2;
    Settings.WriteFloat('Usage', 'TotalTime', TotalUsageTime);
    Settings.UpdateFile;
    {
    if (RateNoticeGiven < 2) and (TotalUsageTime > 1 / 8) then begin
      RateNoticeGiven := 2;
      Settings.WriteInteger('Usage', 'RateNoticeGiven', RateNoticeGiven);
      Settings.UpdateFile;
      ShowMessage('You''ve been actively using this program for a while now.'#13#13 +
        'If you should find this program useful I would greatly appreciate it if you ' +
        'would go to the download page at '+SiteName[wbGameMode]+' Nexus and give it an endorsement.'#13#13 +
        'If you have already endorsed this program I would like to thank you for your support and '+
        'if you have any suggestions how to improve this program please don''t hesitate to let me know about '+
        'them via the release topic on the Bethesda Game Studios Forums.');
    end;
    }
  end;

  if not Enabled then
    Exit;

  if not pnlClient.Enabled then
    Exit;

  if not wbEditAllowed then
    Exit;

  if wbToolMode in wbAutoModes then
    Exit;

  if not ShowUnsavedHint then
    Exit;

  // skip if Left mouse button is pressed, could be indication of active drag&drop or other action in progress
  if GetAsyncKeyState(VK_LBUTTON) and $8000 <> 0 then
    Exit;

  if not Assigned(vstView) then
    Exit;
  if not Assigned(vstNav) then
    Exit;

  if vstView.IsEditing then
    Exit;

  if jbhSave.Active then
    Exit;

  if not Assigned(bnMainMenu) then
    Exit;

  FoundExpired := False;
  sl := TStringList.Create;
  try
    sl.TrailingLineBreak := False;
    j := 0;
    for i := Low(Files) to High(Files) do
      if esUnsaved in Files[i].ElementStates then begin
        if Files[i].UnsavedSince < Now - SaveInterval then
          FoundExpired := True;

        if Files[i].UnsavedSince < Now then begin
          if sl.Count >= MaxSaveListCount then
            Inc(j)
          else
            sl.Add(Files[i].Name + ' ('+FormatDateTime('hh:nn', Now - Files[i].UnsavedSince)+')');
        end;
      end;
    if j > 0 then
      sl.Add('(+'+j.ToString+' more)');

    if FoundExpired then begin
      jbhSave.ActivateHint(bnMainMenu, sl.Text, 'You have unsaved changes. Do you want to save now?', 30000);
      SetSaveInterval;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmMain.tmrGeneratorTimer(Sender: TObject);
begin
  tmrGenerator.Enabled := False;
  if GeneratorStarted then
    Exit;
  GeneratorStarted := True;
  if wbToolMode = tmLODGen then
    DoGenerateLOD
  else if wbToolMode = tmScript then
    DoRunScript;

  if xeAutoExit then
    tmrShutdown.Enabled := True;
end;

procedure TfrmMain.tmrMessagesTimer(Sender: TObject);
var
  ChangesMade : Boolean;
  i, dummy: Integer;
begin
  if (ShowNexusModsHint <> 0) and (ShowNexusModsHint < Now) then
    if NexusModsVersion > VersionString then begin
      if not (jbhPatreon.Active or jbhGitHub.Active) then begin
        bnNexusMods.ShowHint := True;

        if wbShrinkButtons then begin
          bnNexusMods.HelpKeyword := 'A newer version is available on NexusMods: ' + NexusModsVersion;
          bnNexusMods.Flat := False;
        end else bnNexusMods.Hint := 'A newer version is available on NexusMods: ' + NexusModsVersion;

        if Settings.ReadInteger('NexusMods', 'SnoozeDate', 0) <> Trunc(Now) then
        //if NexusModsVersion > TwbVersion(Settings.ReadString('NexusMods', 'SnoozeVersion', '')) then
          if wbShrinkButtons then
            jbhNexusMods.ActivateHint(bnNexusMods, bnNexusMods.HelpKeyword, '', 20000)
          else jbhNexusMods.ActivateHint(bnNexusMods, bnNexusMods.Hint, '', 20000);
        ShowNexusModsHint := 0;
      end;

      bnNexusMods.Font.Style := bnNexusMods.Font.Style + [fsBold, fsUnderline];
      btnNexusModsNewVersion := true;

    end else begin
      bnNexusMods.ShowHint := True;
      if wbShrinkButtons then
        bnNexusMods.HelpKeyword := 'Current version on NexusMods: ' + NexusModsVersion
      else bnNexusMods.Hint := 'Current version on NexusMods: ' + NexusModsVersion;
      ShowNexusModsHint := 0;
    end;

  if (ShowGitHubHint <> 0) and (ShowGitHubHint < Now) then
    if GitHubVersion > VersionString then begin
      if not (jbhPatreon.Active or jbhNexusMods.Active) then begin
        bnGitHub.ShowHint := True;

        if wbShrinkButtons then begin
          bnGitHub.HelpKeyword := 'A newer version is available on GitHub: ' + GitHubVersion;
          bnGitHub.Flat := False;
        end else bnGitHub.Hint := 'A newer version is available on GitHub: ' + GitHubVersion;

        if Settings.ReadInteger('GitHub', 'SnoozeDate', 0) <> Trunc(Now) then
        //if GitHubVersion > TwbVersion(Settings.ReadString('GitHub', 'SnoozeVersion', '')) then
          if wbShrinkButtons then
            jbhGitHub.ActivateHint(bnGitHub, bnGitHub.HelpKeyword, '', 20000)
          else jbhGitHub.ActivateHint(bnGitHub, bnGitHub.Hint, '', 20000);
        ShowGitHubHint := 0;
      end;

      bnGitHub.Font.Style := bnGitHub.Font.Style + [fsBold, fsUnderline];
      btnGithubNewVersion := true;

    end else begin
      bnGitHub.ShowHint := True;
      if wbShrinkButtons then
        bnGitHub.HelpKeyword := 'Current version on GitHub: ' + GitHubVersion
      else bnGitHub.Hint := 'Current version on GitHub: ' + GitHubVersion;
      ShowGitHubHint := 0;
    end;

  if Assigned(NewMessages) and (NewMessages.Count > 0) then begin
    mmoMessages.Lines.AddStrings(NewMessages);
    NewMessages.Clear;
    ScrollToTheLastMessage;
    stbMain.Panels[0].Text := mmoMessages.Lines[Pred(mmoMessages.Lines.Count)];
    if pgMain.ActivePage <> tbsMessages then
      tbsMessages.Highlighted := True;
  end;

  if AutoDone then begin
    AutoDone := False;
    frmMain.Close;   // Wait until NewMessages are processed.
  end;

  if (wbToolMode in [tmOnamUpdate, tmMasterUpdate, tmMasterRestore, tmESMify, tmESPify, tmSortAndCleanMasters, tmCheckForITM,
        tmCheckForDR, tmCheckForErrors]) and wbLoaderDone and not xeMasterUpdateDone then begin
    xeMasterUpdateDone := True;
    ChangesMade := False;
    if wbLoaderError then begin
      wbDontSave := True;
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] --= Error =--');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] An error occured while loading your active modules.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Please look at the log above to determine which of your modules caused that problem.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] The most likely reason for this is a module file that contains structural errors.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + ']');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] !!! No changes have been made to any of your active modules.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] !!! You have to resolve the problem and run this program again.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + ']');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Loading and saving the problematic module in CS/GECK/CK can sometimes produce');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] a working version. But it is recommended to contact the author of the module');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] to get the original fixed.');
    end else try
      if (wbToolMode = tmSortAndCleanMasters) then begin
        for i := Low(Files) to High(Files) do
          if xeModulesToUse.Find(Files[i].FileName, dummy) and Files[i].IsEditable then begin
            Files[i].SortMasters;
            Files[i].CleanMasters;
            ChangesMade := ChangesMade or Files[i].Modified;
          end
      end else if (wbToolMode in [tmMasterRestore, tmESPify]) then
        ChangesMade := RestorePluginsFromMaster
      else if (wbToolMode in [tmCheckForErrors, tmCheckForITM, tmCheckForDR]) then begin
        if (wbToolMode in [tmCheckForITM, tmCheckForDR]) then
          mniNavFilterForCleaning.Click;
        JumpTo(Files[High(Files)].Header, False);
        vstNav.ClearSelection;
        vstNav.FocusedNode := vstNav.FocusedNode.Parent;
        vstNav.Selected[vstNav.FocusedNode] := True;
        DoSetActiveRecord(nil);
        pgMain.ActivePage := tbsMessages;
        try
          if wbToolMode = tmCheckForErrors then begin
            mniNavCheckForErrorsClick(Nil);
            if ErrorsCount>126 then
              CheckResult := 127
            else
              CheckResult := ErrorsCount;
          end else if wbToolMode = tmCheckForITM then begin
            mniNavRemoveIdenticalToMasterClick(Nil);
            if ITMcount>126 then
              CheckResult := 127
            else
              CheckResult := ITMcount;
          end else if wbToolMode = tmCheckForDR then begin
            mniNavUndeleteAndDisableReferencesClick(Nil);
            if DRcount>126 then
              CheckResult := 127
            else
              CheckResult := DRcount;
          end else
            CheckResult := 255;
        finally
          wbDontSave := True;
        end;
      end else if wbToolMode = tmMasterUpdate then
        ChangesMade := SetAllToMaster
      else if wbToolMode = tmOnamUpdate then begin
        ChangesMade := UpdateAllOnam;
        if ChangesMade then begin
          Settings.WriteBool('Options', 'AlwaysSaveOnam', True);
          Settings.UpdateFile;
        end;
      end;

      if SaveChanged = srNothingToDo then
        ChangesMade := False;

      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] --= All Done =--');
      if ChangesMade then begin
        PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] You have to close this program to finalize renaming of the .save files.');
        PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] It is still possible for the renaming to fail if any of your original module files is still open by another process.')
      end else begin
        PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] None of your active modules required changes.');
      end;
      if (wbToolMode in [tmOnamUpdate, tmMasterUpdate]) then begin
        PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + ']');
        PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] !!! Remember to run this program again any time you make changes to your active mods. !!!.');
      end else
        if (wbToolMode in wbPluginModes) then
          AutoDone := true;

    except
      wbDontSave := True;
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] --= Error =--');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] An error occured while trying to modify the file or saving the modified files.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Please look at the log above to determine which of your modules caused that problem.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] The most likely reason for this is a module file that contains structural errors.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + ']');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] !!! No changes have been made to any of your active modules.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] !!! You have to resolve the problem and run this program again.');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + ']');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] Loading and saving the problematic module in CS/GECK/CK can sometimes produce');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] a working version. But it is recommended to contact the author of the module');
      PostAddMessage('[' + wbFormatElapsedTime( Now - wbStartTime) + '] to get the original fixed.');
    end;
  end;
end;

procedure TfrmMain.tmrPendingSetActiveTimer(Sender: TObject);
begin
  tmrPendingSetActive.Enabled := False;
  if Assigned(PendingContainer) then
    DoSetActiveContainer(PendingContainer)
  else if Assigned(PendingMainRecords) then
    DoSetActiveRecord(Copy(PendingMainRecords));
end;

procedure TfrmMain.vstSpreadSheetAmmoInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  MainRecord                  : IwbMainRecord;
  Rec                         : IwbRecord;
begin
  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  if not Supports(NodeDatas[0].Element, IwbMainRecord, MainRecord) then
    Exit;

  NodeDatas[2].Element := MainRecord.RecordBySignature['EDID'];
  NodeDatas[3].Element := MainRecord.RecordBySignature['FULL'];

  if wbGameMode = gmTES4 then begin
    NodeDatas[4].Element := MainRecord.RecordBySignature['ENAM'];

    Rec := MainRecord.RecordBySignature['DATA'];
    if Assigned(Rec) then begin
      NodeDatas[5].Element := Rec.ElementByName['Speed'];
      NodeDatas[6].Element := Rec.ElementByName['Value'];
      NodeDatas[7].Element := Rec.ElementByName['Weight'];
      NodeDatas[8].Element := Rec.ElementByName['Damage'];
    end;
  end else begin
    Rec := MainRecord.RecordBySignature['DATA'];
    if Assigned(Rec) then begin
      NodeDatas[4].Element := Rec.ElementByName['Projectile'];
      NodeDatas[6].Element := Rec.ElementByName['Value'];
      NodeDatas[8].Element := Rec.ElementByName['Damage'];
      NodeDatas[9].Element := Rec.ElementByName['Flags'];
    end;
  end;
end;

procedure TfrmMain.vstSpreadsheetArmorInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  MainRecord                  : IwbMainRecord;
  Rec                         : IwbRecord;
begin
  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  if not Supports(NodeDatas[0].Element, IwbMainRecord, MainRecord) then
    Exit;

  NodeDatas[2].Element := MainRecord.RecordBySignature['EDID'];
  NodeDatas[3].Element := MainRecord.RecordBySignature['FULL'];

  if wbGameMode = gmTES4 then begin
    NodeDatas[4].Element := MainRecord.RecordBySignature['ENAM'];

    Rec := MainRecord.RecordBySignature['BMDT'];
    if Assigned(Rec) then begin
      NodeDatas[5].Element := Rec.Elements[0];
      NodeDatas[6].Element := Rec.Elements[1];
    end;

    Rec := MainRecord.RecordBySignature['DATA'];
    if Assigned(Rec) then begin
      NodeDatas[7].Element := Rec.Elements[0];
      NodeDatas[8].Element := Rec.Elements[1];
      NodeDatas[9].Element := Rec.Elements[2];
      NodeDatas[10].Element := Rec.Elements[3];
    end;
  end else begin
    {Enchantment}
    NodeDatas[4].Element := MainRecord.RecordBySignature['EITM'];

    Rec := MainRecord.RecordBySignature['BODT'];
    if not Assigned(Rec) then
      Rec := MainRecord.RecordBySignature['BOD2'];

    if Assigned(Rec) then begin
      {Slots}
      NodeDatas[5].Element := Rec.Elements[0];
      {Type}
      NodeDatas[6].Element := Rec.Elements[3];
    end;

    {Armor}
    NodeDatas[7].Element := MainRecord.RecordBySignature['DNAM'];

    Rec := MainRecord.RecordBySignature['DATA'];
    if Assigned(Rec) then begin
      {Value}
      NodeDatas[8].Element := Rec.Elements[0];
      {Weight}
      NodeDatas[10].Element := Rec.Elements[1];
    end;

    NodeDatas[11].Element := MainRecord.RecordBySignature['ETYP'];
    NodeDatas[12].Element := MainRecord.RecordBySignature['TNAM'];
  end;
end;

procedure TfrmMain.vstViewAdvancedHeaderDraw(Sender: TVTHeader; var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
begin
  //...
end;

procedure TfrmMain.vstViewBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  NodeDatas                   : PViewNodeDatas;
  Factor                      : Double;
begin
  NodeDatas := Sender.GetNodeData(Node);
  Dec(Column);
  if Column > High(ActiveRecords) then
    Column := High(ActiveRecords);
  if Column >= 0 then begin
    if not Assigned(NodeDatas[Column].Element) or (Column = ActiveIndex) then begin

      Factor := 0.85;

      if not Assigned(NodeDatas[Column].Element) then
        Factor := Factor + 0.08;

      if Column = ActiveIndex then begin
        Factor := Factor - 0.04;
        if not Assigned(NodeDatas[Column].Element) then
          Factor := Factor + 0.015;
      end;

      if NodeDatas[Column].ConflictAll >= caNoConflict then
        TargetCanvas.Brush.Color := wbLighter(ConflictAllToColor(NodeDatas[Column].ConflictAll), Factor)
      else
        Exit;

      TargetCanvas.FillRect(CellRect);

    end;
  end;
end;

procedure TfrmMain.vstViewBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  NodeDatas                   : PViewNodeDatas;
begin
  NodeDatas := Sender.GetNodeData(Node);
  if NodeDatas[0].ConflictAll >= caNoConflict then
    ItemColor := wbLighter(ConflictAllToColor(NodeDatas[0].ConflictAll), 0.85)
  else
    Exit;

  EraseAction := eaColor;
end;

procedure TfrmMain.vstViewCheckHotTrack(Sender: TBaseVirtualTree;
  HotNode: PVirtualNode; HotColumn: TColumnIndex; var Allow: Boolean);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  Allow := False;

  if HotColumn < 1 then
    Exit;
  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;

  Dec(HotColumn);

  if (HotColumn < Low(ActiveRecords)) or (HotColumn > High(ActiveRecords)) then
    Exit;

  NodeDatas := vstView.GetNodeData(HotNode);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[HotColumn].Element;
  if not Assigned(Element) then
    Exit;

  var lLinksTo := Element.LinksTo;
  if not Assigned(lLinksTo) then
    lLinksTo := Element.SummaryLinksTo;

  Allow := Assigned(lLinksTo) and not lLinksTo.Equals(ActiveRecord);
end;

procedure TfrmMain.vstViewClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if vstView.HotColumn < 1 then
    Exit;
  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;
  if not vstView.HotTrack then
    Exit;

  if (Pred(vstView.HotColumn) < Low(ActiveRecords)) or (Pred(vstView.HotColumn) > High(ActiveRecords)) then
    Exit;

  NodeDatas := vstView.GetNodeData(vstView.HotNode);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Pred(vstView.HotColumn)].Element;
  if not Assigned(Element) then
    Exit;

  var lLinksTo := Element.LinksTo;
  if not Assigned(lLinksTo) then
    lLinksTo := Element.SummaryLinksTo;

  if Assigned(lLinksTo) and not lLinksTo.Equals(ActiveRecord) then begin
    ForwardHistory := nil;
    JumpTo(lLinksTo, False);
  end;
end;

procedure TfrmMain.vstViewCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeDatas                   : PViewNodeDatas;
  i                           : Integer;
  Shift                       : Boolean;
begin
  if RebuildingViewTree then
    Exit;

  Shift := GetKeyState(VK_CONTROL) < 0;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;
  for i := Low(ActiveRecords) to High(ActiveRecords) do
    if Assigned(NodeDatas[i].Container) then begin
      if Shift and Assigned(NodeDatas[i].Container.Def) then begin
        NodeDatas[i].Container.Def.Collapsed := True;
        NodeDatas[i].Container.Collapsed := tbUnknown;
        DelayedExpandView := True;
        PostMessage(Handle, WM_USER + 5, 0, 0);
      end else begin
        NodeDatas[i].Container.Collapsed := tbTrue;
        UpdateColumnWidths;
      end;
    end;
end;

procedure TfrmMain.vstViewCollapsing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var Allowed: Boolean);
begin
  //Allowed := False;
end;

Type
  TwbComboEditLink = class(TComboEditLink)
    procedure SetBounds(R: TRect); override;
  end;

  TwbCheckComboEditLink = class(TcheckComboEditLink)
  end;

procedure TfrmMain.vstViewCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if Column < 1 then
    Exit;
  if GetKeyState(VK_SHIFT) < 0 then
    Exit;

  Dec(Column);

  if (Column < Low(ActiveRecords)) or (Column > High(ActiveRecords)) then
    Exit;

  NodeDatas := vstView.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Column].Element;
  if not Assigned(Element) then
    Exit;

  vstCreateEditor(Element, EditLink);
end;

type
  {WARNING: This is correct for Delphi 10.2 Tokyo. Might need to be adjusted for other Delphi versions. Still valid like this up to Delphi 12}
  TStringListPrivateHacker = class(TStrings)
  protected
    FList: TStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
  end;

procedure TfrmMain.vstCreateEditor(const aElement: IwbElement; out EditLink: IVTEditLink);
var
  {$IFNDEF LiteVersion}
  i                           : Integer;
  TextLink                    : TcxTextEditLink;
  ComboLink                   : TcxComboEditLink;
  CheckComboLink              : TcxCheckComboEditLink;
  {$ELSE}
  ComboLink                   : TwbComboEditLink;
  CheckComboLink              : TwbCheckComboEditLink;
  {$ENDIF}
begin
  if EditInfoCacheLGeneration <> wbLocalizationHandler.Generation then begin
    EditInfoCacheID := nil;
    EditInfoCache := nil;
    EditInfoCacheLGeneration := wbLocalizationHandler.Generation;
  end;

  case aElement.EditType of
  {$IFNDEF LiteVersion}
    etDefault: begin
      TextLink := TcxTextEditLink.Create;
      EditLink := TextLink;
    end;
    etComboBox: begin
      ComboLink := TcxComboEditLink.Create;
      EditLink := ComboLink;
      if aElement.ElementID <> EditInfoCacheID then begin
        EditInfoCacheID := aElement.ElementID;
        EditInfoCache := aElement.EditInfo;
      end;
      with ComboLink.Properties do begin
        with Items do begin
          Clear;
          AddStrings(EditInfoCache);
        end;
        if LookupItems.Count > 1000 then
          {Bound to be a FormID list, they are guaranteed to be sorted already}
          TStringListPrivateHacker(LookupItems).FSorted := True
        else
          Sorted := True;
        DropDownRows := 16;
      end;
    end;
    etCheckComboBox: begin
      CheckComboLink := TcxCheckComboEditLink.Create;
      EditLink := CheckComboLink;
      if aElement.ElementID <> EditInfoCacheID then begin
        EditInfoCacheID := aElement.ElementID;
        EditInfoCache := aElement.EditInfo;
      end;

      with CheckComboLink.Properties do begin
        with Items do begin
          Clear;
          for i := Low(EditInfoCache) to High(EditInfoCache) do
            AddCheckItem(EditInfoCache[i]);
        end;
        DropDownRows := Length(EditInfoCache);
        if DropDownRows > 32 then
          DropDownRows := 32;
        Delimiter := ', ';
        ShowEmptyText := False;
        DropDownAutoWidth := True;
      end;
    end;
    {$ELSE}
    etComboBox: begin
      ComboLink := TwbComboEditLink.Create(Self);
      EditLink := ComboLink;
      if aElement.ElementID <> EditInfoCacheID then begin
        EditInfoCacheID := aElement.ElementID;
        EditInfoCache := aElement.EditInfo;
      end;
      with ComboLink.PickList do begin
        Clear;
        AddStrings(EditInfoCache);
      end;
    end;
    etCheckComboBox: begin
      CheckComboLink := TwbCheckComboEditLink.Create;
      EditLink := CheckComboLink;
      if aElement.ElementID <> EditInfoCacheID then begin
        EditInfoCacheID := aElement.ElementID;
        EditInfoCache := aElement.EditInfo;
      end;
      with CheckComboLink.PickList do begin
        Clear;
        AddStrings(EditInfoCache);
      end;
    end;
  {$ENDIF}
  end;
end;

procedure TfrmMain.vstViewDblClick(Sender: TObject);
var
  NodeDatas                   : PViewNodeDatas;
  i                           : Integer;
  ModalEdit                   : Boolean;
  ViewFocusedElement              : IwbElement;
  Element                     : IwbElement;
  Def                         : IwbNamedDef;
begin
  UserWasActive := True;

  if (vstView.FocusedColumn = 0) then begin
    if ComparingSiblings then
      mniViewSort.Click
    else begin
      vstView.ToggleNode(vstViewFocusedNode);
      if DelayedExpandView then begin
        DelayedExpandView := False;
        ExpandView;
      end;
    end;
    Exit;
  end;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then begin

    if vstView.FocusedColumn > 0 then
      ViewFocusedElement := NodeDatas[Pred(vstView.FocusedColumn)].Element
    else
      ViewFocusedElement := nil;
    EditFocusedViewElement := False;
    Element := ViewFocusedElement;
    if not Assigned(Element) then
      for i := Low(ActiveRecords) to High(ActiveRecords) do begin
        Element := NodeDatas[i].Element;
        if Assigned(Element) then
          Break;
      end;

    if Assigned(Element) then begin
      Def := Element.ResolvedValueDef;

      if Assigned(ViewFocusedElement) and Assigned(Def) and ViewFocusedElement.IsEditable then
        if Def.DefType in [dtInteger, dtFlag, dtFloat] then begin
          vstView.EditNode(vstViewFocusedNode, vstView.FocusedColumn);
          Exit;
        end;
    end;

    with TfrmViewElements.Create(nil) do begin
      Caption := vstView.Path(vstViewFocusedNode, 0,{ ttNormal,} '\');
      Settings := Self.Settings;
      if Assigned(ActiveMaster) then
        Caption := ActiveMaster.Name + '\' + Caption;

      ModalEdit := wbIKnowWhatImDoing or (GetKeyState(VK_SHIFT) < 0);

      for i := Low(ActiveRecords) to High(ActiveRecords) do
        AddElement(NodeDatas[i].Element, vstView.FocusedColumn = Succ(i),
          ModalEdit and Assigned(NodeDatas[i].Element) and NodeDatas[i].Element.IsEditable);
      if not ModalEdit then
        Show
      else begin
        ShowModal;
      end;
    end;
  end;
end;

procedure TfrmMain.vstViewDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  NodeDatas                   : PViewNodeDatas;
begin
  Allowed := False;
  if not wbEditAllowed then
    Exit;
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;
  NodeDatas := vstView.GetNodeData(Node);
  Allowed := Assigned(NodeDatas[Column].Element);
end;

procedure TfrmMain.vstViewDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  SourceElement               : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  UserWasActive := True;

  if GetSourceElement(Source, SourceElement) and PerformDrop(Sender, Sender.DropTargetNode, Sender.DropTargetColumn, SourceElement) then begin
    PostResetActiveTree;
    InvalidateElementsTreeView(NoNodes);
  end;
end;

procedure TfrmMain.vstViewDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  TargetNode                  : PVirtualNode;
  TargetColumn                : Integer;
  TargetIndex                 : Integer;
  TargetElement               : IwbElement;
  SourceElement               : IwbElement;
begin
  Accept := False;

  if not wbEditAllowed then
    Exit;

  TargetNode := Sender.DropTargetNode;
  TargetColumn := Sender.DropTargetColumn;

  Accept := GetSourceElement(Source, SourceElement) and GetTargetElement(Sender, TargetNode, TargetColumn, TargetIndex, TargetElement) and
    (TargetElement <> SourceElement) and
    TargetElement.CanAssign(TargetIndex, SourceElement, True);
end;

procedure TfrmMain.vstViewDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; var CellRect: TRect; var DefaultDraw: Boolean);
var
  Colors : TArray<TColor>;
begin
  Dec(Column);
  if InRange(Column, Low(ActiveRecords), High(ActiveRecords)) then begin
    if FindColors(Text, Colors) then begin
      if wbDontDrawColorText then
        DefaultDraw := False;

      var OldBrushColor := TargetCanvas.Brush.Color;
      try
        var r := CellRect;
        var Width := Min(CellRect.Width div Length(Colors), Node.NodeHeight);
        r.Width := Width;
        InflateRect(r, 0, -vstView.TextMargin);
        for var i := Low(Colors) to High(Colors) do begin
          if r.Right > CellRect.Right then
            r.Right := CellRect.Right;
          TargetCanvas.Brush.Color := Colors[i];
          TargetCanvas.FillRect(r);
          Inc(CellRect.Left, Width);
          OffsetRect(r, Width, 0);
          if r.Left >= CellRect.Right then begin
            DefaultDraw := False;
            Break;
          end;
        end;
      finally
        TargetCanvas.Brush.Color := OldBrushColor;
      end;
      Inc(CellRect.Left, vstView.TextMargin);

      if TargetCanvas.TextFlags and ETO_OPAQUE = 0 then
        SetBkMode(TargetCanvas.Handle, TRANSPARENT)
      else
        SetBkMode(TargetCanvas.Handle, OPAQUE);
    end;

    if DefaultDraw then begin
      var NodeDatas : PViewNodeDatas := vstView.GetNodeData(Node);
      with NodeDatas[Column] do
        if Assigned(Element) and (dfHideText in Element.Def.DefFlags) then
          DefaultDraw := False;
    end;
  end;
end;

procedure TfrmMain.vstViewEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := False;

  if not wbEditAllowed then
    Exit;

  if Column < 1 then
    Exit;
  var lColumn := Pred(Column);

  if lColumn > High(ActiveRecords) then
    Exit;

  var NodeDatas: PViewNodeDatas := vstView.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  var Element := NodeDatas[lColumn].Element;

  if not Assigned(Element) then begin
    if not EditFocusedViewElement then begin
      OverrideViewFocusedNode := Node;
      try
        pmuViewPopup(Self);
        if mniViewAdd.Visible and mniViewAdd.Enabled then begin
          EditAddedElement := True;
          try
            if mniViewAdd.Count > 0 then begin
              //...
            end else begin
              mniViewAdd.Click;
            end;
          finally
            EditAddedElement := False;
          end;
        end;
      finally
        OverrideViewFocusedNode := nil;
      end;
    end;
    Exit;
  end;

  if Element.IsEditable then begin
    Allowed := EditWarn;
  end else begin
    for var lChildNode in vstView.ChildNodes(Node) do begin
      var lAllowed := False;
      vstViewEditing(Sender, lChildNode, Column, lAllowed);
      if EditFocusedViewElement then
        Exit;
      if lAllowed then begin
        NodeDatas := vstView.GetNodeData(lChildNode);
        if not Assigned(NodeDatas) then
          Exit;

        Element := NodeDatas[lColumn].Element;
        if not Assigned(Element) then
          Continue;

        var lDef := Element.Def;
        if not Assigned(lDef) then
          Continue;

        if dfSkipImplicitEdit in lDef.DefFlags then
          Continue;

        ViewFocusedElement := Element;
        EditFocusedViewElement := True;
        PostResetActiveTree;

        Exit;
      end;
    end;

    if not EditFocusedViewElement then begin
      OverrideViewFocusedNode := Node;
      try
        pmuViewPopup(Self);
        if mniViewAdd.Visible and mniViewAdd.Enabled then begin
          EditAddedElement := True;
          try
            if mniViewAdd.Count > 0 then begin
              //...
            end else begin
              mniViewAdd.Click;
            end;
          finally
            EditAddedElement := False;
          end;
        end;
      finally
        OverrideViewFocusedNode := nil;
      end;
    end;
  end;
end;

procedure TfrmMain.vstViewExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeDatas                   : PViewNodeDatas;
  i                           : Integer;
  Shift                       : Boolean;
begin
  if RebuildingViewTree then
    Exit;

  Shift := GetKeyState(VK_CONTROL) < 0;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;
  for i := Low(ActiveRecords) to High(ActiveRecords) do
    if Assigned(NodeDatas[i].Container) then begin
      if Shift and Assigned(NodeDatas[i].Container.Def) then begin
        NodeDatas[i].Container.Def.Collapsed := False;
        NodeDatas[i].Container.Collapsed := tbUnknown;
        DelayedExpandView := True;
        PostMessage(Handle, WM_USER + 5, 0, 0);
      end else begin
        NodeDatas[i].Container.Collapsed := tbFalse;
        UpdateColumnWidths;
      end;
    end;
end;

procedure TfrmMain.vstViewFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  NodeDatas                   : PViewNodeDatas;
begin
  if Column <> LastViewColumn then begin
    if ComparingSiblings then
      vstView.Invalidate
    else
      vstView.InvalidateColumn(0);

    LastViewColumn := Column;
  end;

  Dec(Column);

  if not Assigned(frmLegend) then
    Exit;
  if (Column < Low(ActiveRecords)) or (Column > High(ActiveRecords)) then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  with NodeDatas[Column] do begin
    if Ord(ConflictAll) > 0 then
      frmLegend.dgLegend.Row := Ord(ConflictAll);
    if Ord(ConflictThis) > 0 then
      frmLegend.dgLegend.Col := Ord(ConflictThis)
    else if Column = 0 then
      frmLegend.dgLegend.Col := Ord(ctMaster);
  end;
end;

procedure TfrmMain.vstViewFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := False;
  //  if NewColumn < 1 then
  //    Exit;
  if (NewColumn = Pred(TVirtualEditTree(Sender).Header.Columns.Count)) and (Length(ActiveRecords) > 1) then
    Exit;
  Allowed := True;
end;

function TfrmMain.GetViewFocusedNode: PVirtualNode;
begin
  if Assigned(OverrideViewFocusedNode) then
    Exit(OverrideViewFocusedNode);
  Result := vstView.FocusedNode;
end;

procedure TfrmMain.vstViewFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NodeDatas                   : PViewNodeDatas;
  i                           : integer;
begin
  NodeDatas := Sender.GetNodeData(Node);

  for i := Low(ActiveRecords) to High(ActiveRecords) do begin
    NodeDatas[i].Element := nil;
    NodeDatas[i].Container := nil;
  end;
end;

procedure TfrmMain.vstViewGetEditText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var CellText: string);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  CellText := '';
  if Column < 1 then
    Exit;
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Column].Element;
  if Assigned(Element) and Element.IsEditable then
    CellText := Element.EditValue;
end;

procedure TfrmMain.vstViewGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodeDatas    : PViewNodeDatas;
  Element      : IwbElement;
  ElementCount : Integer;
  i,j          : Integer;
  UseSuffix    : Boolean;
  FocusedColumn: TColumnIndex;
begin
  CellText := '';
  NodeDatas := Sender.GetNodeData(Node);

  if Pred(Column) > High(ActiveRecords) then
    Exit;

  UseSuffix := False;
  Element := nil;

  if Column < 1 then begin

    FocusedColumn := FocusedColumnOverride;
    if FocusedColumn < 0 then
      FocusedColumn := vstView.FocusedColumn;
    if Length(ActiveRecords) = 1 then
      FocusedColumn := 1;

    if (FocusedColumn > 0) and (Pred(FocusedColumn) <= High(ActiveRecords)) then
      Element := NodeDatas[Pred(FocusedColumn)].Element;

    UseSuffix := Assigned(Element);

    if not UseSuffix then
      for i := Low(ActiveRecords) to High(ActiveRecords) do begin
        Element := NodeDatas[i].Element;
        if Assigned(Element) then
          Break;
      end;

  end else
    Element := NodeDatas[Pred(Column)].Element;

  if Assigned(Element) then begin
    if TextType = ttNormal then begin
      if Column < 1 then begin
        CellText := Element.DisplayName[UseSuffix];
        if vnfIsSorted in NodeDatas[0].ViewNodeFlags then
          CellText := CellText + ' (sorted)'
        else if vnfIsAligned in NodeDatas[0].ViewNodeFlags then
          CellText := CellText + ' (aligned)';
      end else begin
        CellText := '';
        if wbShowRawData then
          CellText := Element.RawDataAsString;
        if CellText = '' then
          if (Element.ConflictPriority <> cpIgnore) or not wbHideIgnored then begin
            CellText := Element.Value;
            if (CellText = '') and not (vsExpanded in Node.States) then
              CellText := Element.Summary;
          end;
      end;
    end
  end else if TextType = ttNormal then
    if Column < 1 then begin
      NodeDatas := Sender.GetNodeData(Node.Parent);
      if not Assigned(NodeDatas) then
        NodeDatas := @ActiveRecords[0];
      for i := Low(ActiveRecords) to High(ActiveRecords) do begin
        Element := NodeDatas[i].Container;
        if Assigned(Element) then
          Break;
      end;
      if Assigned(Element) and (Element.ElementType in [etMainRecord, etSubRecordStruct]) then begin
        ElementCount := (Element.Def as IwbRecordDef).MemberCount;
        i := (Element as IwbContainer).AdditionalElementCount;
        j := Integer(Node.Index);
        if (j >= i) and ((j-i) < ElementCount) then
          with (Element.Def as IwbRecordDef).Members[j - i] do begin
            if DefType = dtSubRecord then
              CellText := Displayable(DefaultSignature) + ' - ' + GetName
            else
              CellText := GetName;
          end
        else
          CellText := Element.Name;
      end;
    end;
end;

procedure TfrmMain.vstViewHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
var
  i        : Integer;
  ColWidth : Integer;
begin
  with HitInfo do begin
    if vstView.Header.Columns.Count < 3 then
      Exit;
    if Column = 0 then
      if Shift = [ssShift] then begin
        ColWidth := Trunc(ColumnWidth * (GetCurrentPPIScreen / PixelsPerInch));
        for i := 0 to Pred(vstView.Header.Columns.Count) do
          vstView.Header.Columns[i].Width := ColWidth;
      end else case Button of
        mbLeft: begin
          ColWidth := (vstView.ClientWidth - vstView.Header.Columns[0].Width) div (vstView.Header.Columns.Count - 2);
          for i := 1 to (vstView.Header.Columns.Count - 2) do
            vstView.Header.Columns[i].Width := ColWidth;
        end;
        mbRight:
          vstView.Header.AutoFitColumns(False);
      end;
  end;
end;

procedure TfrmMain.vstViewHeaderDropped(Sender: TVTHeader; SourceColumn, TargetColumn: TColumnIndex; var Handled: Boolean);
var
  TargetElement               : IwbElement;
  SourceElement               : IwbElement;
begin
  Handled := True;

  if not wbEditAllowed then
    Exit;

  UserWasActive := True;

  if SourceColumn < 1 then
    Exit;
  if TargetColumn < 1 then
    Exit;

  if SourceColumn > Length(ActiveRecords) then
    Exit;
  if TargetColumn > Length(ActiveRecords)then
    Exit;

  SourceElement := ActiveRecords[Pred(SourceColumn)].Element;
  TargetElement := ActiveRecords[Pred(TargetColumn)].Element;

  if not Assigned(SourceElement) then
    Exit;
  if not Assigned(TargetElement) then
    Exit;

  if TargetElement.CanAssign(Low(Integer), SourceElement, False) then begin

    if not EditWarn then
      Exit;

    if not AddRequiredMasters(SourceElement, TargetElement._File, False) then
      Exit;

    vstView.BeginUpdate;
    try
      TargetElement.Assign(Low(Integer), SourceElement, False);
      ActiveRecords[Pred(TargetColumn)].UpdateRefs;
      TargetElement := nil;
      SourceElement := nil;
      PostResetActiveTree;
    finally
      vstView.EndUpdate;
    end;
    InvalidateElementsTreeView(NoNodes);
  end;
end;

procedure TfrmMain.vstViewHeaderMouseDown(Sender: TVTHeader; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Column     : Integer;
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
begin
  if (Shift = [ssCtrl]) and (Button = mbLeft) then begin
    Column := vstView.Header.Columns.ColumnFromPosition(Point(X, Y));
    Dec(Column);
    if (Column >= Low(ActiveRecords)) and (Column <= High(ActiveRecords)) then begin
      Element := ActiveRecords[Column].Element;
      if not Supports(Element, IwbMainRecord, MainRecord) then
        Exit;
      JumpTo(MainRecord, True);
    end;
  end;
end;

procedure TfrmMain.vstViewHeaderMouseMove(Sender: TVTHeader; Shift: TShiftState; X, Y: Integer);
var
  Column     : Integer;
begin
  Column := vstView.Header.Columns.ColumnFromPosition(Point(X, Y));
  Dec(Column);
  if (Column >= Low(ActiveRecords)) and (Column <= High(ActiveRecords)) then
    vstView.Header.PopupMenu := pmuViewHeader
  else
    vstView.Header.PopupMenu := nil;
end;

procedure TfrmMain.vstViewHeaderDrawQueryElements(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
begin
  if Assigned(PaintInfo.Column) and
    (PaintInfo.Column.Index > 0) and
    (PaintInfo.Column.Index <= Length(ActiveRecords)) then begin

    with PaintInfo.TargetCanvas.Font do begin
      if ActiveRecords[Pred(PaintInfo.Column.Index)].Element.Modified then
        Style := [fsBold]
      else
        Style := [];

      if ActiveRecords[Pred(PaintInfo.Column.Index)].Element.IsInjected then
        Style := Style + [fsItalic]
      else
        Style := Style - [fsItalic];

      if ActiveRecords[Pred(PaintInfo.Column.Index)].Element.IsNotReachable then
        Style := Style + [fsStrikeOut]
      else
        Style := Style - [fsStrikeOut];

      if ActiveRecords[Pred(PaintInfo.Column.Index)].Element.ReferencesInjected then
        Style := Style + [fsUnderline]
      else
        Style := Style - [fsUnderline];
    end;

    if ActiveRecords[0].ConflictAll >= caNoConflict then
      Sender.Background := wbLighter(ConflictAllToColor(ActiveRecords[0].ConflictAll), 0.85);
    PaintInfo.TargetCanvas.Brush.Color := Sender.Background;
    Sender.Font.Color := wbDarker(ConflictThisToColor(
      ActiveRecords[Pred(PaintInfo.Column.Index)].ConflictThis));
  end;
end;

procedure TfrmMain.vstViewInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  InitChildren(Sender.GetNodeData(Node), Length(ActiveRecords), ChildCount);
end;

procedure TfrmMain.vstViewInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeDatas                   : PViewNodeDatas;
  ParentDatas                 : PViewNodeDatas;
begin
  NodeDatas := Sender.GetNodeData(Node);
  ParentDatas := Sender.GetNodeData(ParentNode);
  if not Assigned(ParentDatas) then
    ParentDatas := @ActiveRecords[0];
  InitNodes(Node, NodeDatas, ParentDatas, Length(ActiveRecords), Node.Index, InitialStates);
end;

procedure TfrmMain.vstViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  Column                      : TColumnIndex;
begin
  UserWasActive := True;

  Column := Pred(vstView.FocusedColumn);

  if Column > High(ActiveRecords) then
    Exit;
  if Column < Low(ActiveRecords) then
    Exit;

  NodeDatas := vstView.GetNodeData(vstViewFocusedNode);
  if Assigned(NodeDatas) then
    Element := NodeDatas[Column].Element;

  if Shift = [ssCtrl] then begin
    case Key of
      Ord('M'): begin
        pmuViewHeaderPopup(nil);
        if mniViewCreateModGroup.Visible then
          mniViewCreateModGroup.Click;
        Exit;
      end;
    end;

    if not Assigned(Element) then
      Exit;

    case Key of
      VK_INSERT: begin
        if not wbEditAllowed then
          Exit;

        pmuViewPopup(nil);
        Key := 0;
        if mniViewAdd.Visible and mniViewAdd.Enabled then begin
          mniViewAdd.Click;
          PostResetActiveTree;
        end;
      end;
      VK_UP: begin
        if not wbEditAllowed then
          Exit;

        LockProcessMessages;
        try
          if not Element.CanMoveUp then
            Exit;
          Key := 0;
          Element.MoveUp;
          ViewFocusedElement := Element;
          EditFocusedViewElement := False;
          ResetActiveTree;
          Exit;
        finally
          UnLockProcessMessages;
        end;
      end;
      VK_DOWN: begin
        if not wbEditAllowed then
          Exit;

        LockProcessMessages;
        try
          if not Element.CanMoveDown then
            Exit;
          Key := 0;
          Element.MoveDown;
          ViewFocusedElement := Element;
          EditFocusedViewElement := False;
          ResetActiveTree;
          Exit;
        finally
          UnLockProcessMessages;
        end;
      end;
      // Ctrl+C = Copy
      Ord('C'): begin
        if Element.EditValue = '' then
          Clipboard.AsText := Element.Summary
        else
          Clipboard.AsText := Element.EditValue;
        Exit;
      end;
    end;

    if not Element.IsEditable then
      Exit;

    if not wbEditAllowed then
      Exit;

    case Key of
      // Ctrl+X = Cut
      Ord('X'): begin
        LockProcessMessages;
        try
          if not (Element.EditValue = '') then
          begin
            Clipboard.AsText := Element.EditValue;
            Element.EditValue := '';
            ResetActiveTree;
            Exit;
          end;
        finally
          UnLockProcessMessages;
        end;
      end;
      // Ctrl+V = Paste
      Ord('V'): begin
        LockProcessMessages;
        try
          if not (Clipboard.AsText = '') then
          begin
            Element.EditValue := Clipboard.AsText;
            ResetActiveTree;
            Exit;
          end;
        finally
          UnLockProcessMessages;
        end;
      end;
    else
      Exit;
    end;

  end else if Shift = [] then begin

    case Key of
      VK_INSERT: begin
        pmuViewPopup(nil);
        Key := 0;
        if mniViewAdd.Visible and mniViewAdd.Enabled then
          mniViewAdd.Click;
      end;
      VK_DELETE: begin
        pmuViewPopup(nil);
        Key := 0;
        if mniViewRemove.Visible and mniViewRemove.Enabled then
          mniViewRemove.Click
        else if mniViewClear.Visible and mniViewClear.Enabled then
          mniViewClear.Click;
      end;
    else
      Exit;
    end;

    PostResetActiveTree;

  end;

end;

procedure TfrmMain.vstViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '?' then begin
    Key := #0;
    edViewFilterName.SetFocus;
  end;
end;

procedure TfrmMain.vstViewMeasureTextWidth(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; var Extent: Integer);
begin
  Dec(Column);
  if InRange(Column, Low(ActiveRecords), High(ActiveRecords)) then begin
    var NodeDatas : PViewNodeDatas := vstView.GetNodeData(Node);
    with NodeDatas[Column] do
      if Assigned(Element) and (dfHideText in Element.Def.DefFlags) then
        Extent := 0;
    var Colors : TArray<TColor>;
    if FindColors(Text, Colors) then
      Inc(Extent, (Length(Colors) * Node.NodeHeight) + vstView.TextMargin );
  end;
end;

procedure TfrmMain.vstViewNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  UserWasActive := True;

  if Pred(Column) > High(ActiveRecords) then
    Exit;

  NodeDatas := vstView.GetNodeData(Node);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Pred(Column)].Element;
    if Assigned(Element) and Element.IsEditable then begin

      if not EditWarn then
        Exit;

      //      vstView.BeginUpdate;
      LockProcessMessages;
      try
        Element.EditValue := NewText;
        ActiveRecords[Pred(vstView.FocusedColumn)].UpdateRefs;
        ViewFocusedElement := Element;
        EditFocusedViewElement := False;
        Element := nil;
        PostResetActiveTree;
      finally
        UnLockProcessMessages;
        //        vstView.EndUpdate;
      end;

      InvalidateElementsTreeView(NoNodes);

    end;
  end;
end;

procedure TfrmMain.vstViewPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeDatas                   : PViewNodeDatas;
  Element                     : IwbElement;
  i                           : Integer;
  ConflictThis                : TConflictThis;
  Modified                    : Boolean;
  ReferencesInjected          : Boolean;
  SortKeyFocus                : string;
  SortKeyThis                 : string;
  FocusedColumn               : TColumnIndex;
begin
  NodeDatas := Sender.GetNodeData(Node);
  Dec(Column);
  if Column > High(ActiveRecords) then
    Exit;

  Modified := False;
  ReferencesInjected := False;
  if Column >= 0 then begin
    Element := NodeDatas[Column].Element;
    if Assigned(Element) then begin
      Modified := Element.Modified;
      ReferencesInjected := Element.ReferencesInjected;
    end;
    ConflictThis := NodeDatas[Column].ConflictThis
  end
  else begin
    ConflictThis := ctUnknown;
    for i := Low(ActiveRecords) to High(ActiveRecords) do begin
      if NodeDatas[i].ConflictThis > ConflictThis then
        ConflictThis := NodeDatas[i].ConflictThis;
      if not Modified then begin
        Element := NodeDatas[i].Element;
        if Assigned(Element) then
          Modified := Element.Modified;
      end;
      if not ReferencesInjected then begin
        Element := NodeDatas[i].Element;
        if Assigned(Element) then
          ReferencesInjected := Element.ReferencesInjected;
      end;
    end;
  end;

  FocusedColumn := Pred(vstView.FocusedColumn);

  if ComparingSiblings and (Column >= 0) and (FocusedColumn >= 0) and (Column <= High(ActiveRecords)) and (FocusedColumn <= High(ActiveRecords)) then
    if Column = FocusedColumn then
      ConflictThis := ctMaster
    else begin

      Element := NodeDatas[FocusedColumn].Element;
      if Assigned(Element) then
        SortKeyFocus := Element.DisplaySortKey[True]
      else
        SortKeyFocus := '';

      Element := NodeDatas[Column].Element;
      if Assigned(Element) then
        SortKeyThis := Element.DisplaySortKey[True]
      else
        SortKeyThis := '';

      if SameStr(SortKeyFocus, SortKeyThis) then
        ConflictThis := ctOverride
      else
        ConflictThis := ctConflictLoses;

    end;

  TargetCanvas.Font.Color := wbDarker(ConflictThisToColor(ConflictThis));

  if Modified then
    TargetCanvas.Font.Style := [fsBold];
  if ReferencesInjected then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
end;

procedure TfrmMain.vstViewResize(Sender: TObject);
begin
  if mniViewColumnWidthFitAll.Checked or mniViewColumnWidthFitSmart.Checked  then
    UpdateColumnWidths;
end;

procedure TfrmMain.vstViewScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: Integer);
begin
  if DeltaY <> 0 then
    if mniViewColumnWidthFitText.Checked or mniViewColumnWidthFitSmart.Checked then begin
      tmrUpdateColumnWidths.Enabled := False;
      tmrUpdateColumnWidths.Enabled := True;
    end;
end;

procedure TfrmMain.vstViewShortenString(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const S: string; TextSpace: Integer; var Result: string; var Done: Boolean);
begin
  Result := s;
  Dec(Column);
  if InRange(Column, Low(ActiveRecords), High(ActiveRecords)) then begin
    var NodeDatas : PViewNodeDatas := vstView.GetNodeData(Node);
    with NodeDatas[Column] do
      if Assigned(Element) and (dfHideText in Element.Def.DefFlags) then
        Done := True;
    if not Done then begin
      var Colors: TArray<TColor>;
      Done := FindColors(s, Colors);
    end;
  end;
end;

procedure TfrmMain.vstNavBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
var
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
begin
  if wbLoaderDone then begin
    NodeData := Sender.GetNodeData(Node);

    if Assigned(NodeData) and Assigned(NodeData.Element) and
      (NodeData.Element.ElementType = etMainRecord) then begin
      MainRecord := NodeData.Element as IwbMainRecord;

      if (NodeData.ConflictAll = caUnknown) or (MainRecord.ElementGeneration <> NodeData.ElementGen) then begin
        ConflictLevelForMainRecord(MainRecord, NodeData.ConflictAll, NodeData.ConflictThis);
        with NodeData^ do begin
          OrgConflictAll  := ConflictAll;
          OrgConflictThis := ConflictThis;
        end;
        NodeData.ElementGen := MainRecord.ElementGeneration;
        if MainRecord.IsInjected then
          Include(NodeData.Flags, nnfInjected)
        else
          Exclude(NodeData.Flags, nnfInjected);
        if MainRecord.IsNotReachable then
          Include(NodeData.Flags, nnfNotReachable)
        else
          Exclude(NodeData.Flags, nnfNotReachable);
        if MainRecord.ReferencesInjected then
          Include(NodeData.Flags, nnfReferencesInjected)
        else
          Exclude(NodeData.Flags, nnfReferencesInjected);
      end;
    end;

    if NodeData.ConflictAll >= caNoConflict then
      ItemColor := wbLighter(ConflictAllToColor(NodeData.ConflictAll), 0.85)
    else
      Exit;

    EraseAction := eaColor;
  end;
end;

procedure TfrmMain.vstNavChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeData                    : PNavNodeData;
  Element                     : IwbElement;
  s, t, u                     : string;

  HeaderType                  : TwbElementType;
begin
  HeaderType := etValue;
  vstNavLastChangeNode := Node;
  NodeData := Sender.GetNodeData(Sender.FocusedNode);
  if Assigned(NodeData) then begin
    Element := NodeData.Element;
    if Assigned(Element) then begin
      HeaderType := Element.ElementType;
      if not (Element.ElementType in [etFile, etMainRecord, etStructChapter]) and not Element.TreeHead then
        Element := nil;
    end;

    if not IsPinned then begin
      if NodeData.ConflictAll >= caNoConflict then
        lblPath.Color := wbLighter(ConflictAllToColor(NodeData.ConflictAll), 0.85)
      else
        lblPath.Color := vstNav.Color;

      lblPath.Font.Color := wbDarker(ConflictThisToColor(NodeData.ConflictThis));

      s := '';
      while Assigned(Node) do begin
        if s <> '' then
          s := ' \ ' + s;
        t := vstNav.Text[Node, 0, False];
        NodeData := Sender.GetNodeData(Node);
        if Assigned(NodeData.Element) and (NodeData.Element.ElementType = etFile) then begin
          u := vstNav.Text[Node, 2, False];
          if u <> '' then
            u := ' (' + u + ')';
        end else begin
          u := vstNav.Text[Node, 1, False];
          if u <> '' then
            u := ' <' + u + '>';
        end;
        s := t + u + s;
        Node := vstNav.NodeParent[Node];
      end;
      s := ' ' + s;
      lblPath.Text := s;
      lblPath.Visible := True;
    end;
  end
  else begin
    if not IsPinned then
      lblPath.Visible := False;
  end;

  if not IsPinned then
    TryViewOrCompareSelectedRecords(Element);

  if not wbShowGroupRecordCount then
    if HeaderType = etGroupRecord then
      HeaderType := etValue;

  case HeaderType of
    etFile: begin
      if wbShowFileFlags then
        Sender.Header.Columns[1].Text := 'Flags'
      else
        Sender.Header.Columns[1].Text := '';
      Sender.Header.Columns[2].Text := 'CRC32';
    end;
    etGroupRecord: begin
      Sender.Header.Columns[1].Text := '';
      Sender.Header.Columns[2].Text := 'Child Count';
    end;
    etStructChapter: begin
      Sender.Header.Columns[1].Text := 'Type';
      Sender.Header.Columns[2].Text := 'Name';
    end;
  else
    Sender.Header.Columns[1].Text := 'EditorID';
    Sender.Header.Columns[2].Text := 'Name';
  end;

  if tmrPendingSetActive.Interval < 1 then begin
    vstNav.Repaint;
    vstView.Repaint;
    Sleep(10);
  end;
end;

function FindSortElement(const aElement: IwbElement): IwbElement;
var
  GroupRecord                 : IwbGroupRecord;
begin
  if Supports(aElement, IwbGroupRecord, GroupRecord) then begin
    Result := GroupRecord.ChildrenOf;
    if Assigned(Result) then
      Exit;
  end;
  Result := aElement;
end;

procedure TfrmMain.bnPinnedClick(Sender: TObject);
begin
  if not IsPinned then
    vstNavChange(vstNav, vstNav.FocusedNode);
end;

procedure TfrmMain.vstNavCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Element1     : IwbElement;
  Element2     : IwbElement;
  Container    : IwbContainerElementRef;
  SortElement1 : IwbElement;
  SortElement2 : IwbElement;
  GroupRecord1 : IwbGroupRecord;
  GroupRecord2 : IwbGroupRecord;
  MainRecord1  : IwbMainRecord;
  MainRecord2  : IwbMainRecord;
begin
  Element1 := PNavNodeData(Sender.GetNodeData(Node1)).Element;
  Element2 := PNavNodeData(Sender.GetNodeData(Node2)).Element;
  Result := 0;

  if Element1 = Element2 then begin
    Result := 0;
    Exit;
  end;

  if Assigned(Element1) <> Assigned(Element2) then begin
    if Assigned(Element1) then
      Result := -1
    else
      Result := 1;
    Exit;
  end
  else if not Assigned(Element1) then begin
    Result := 0;
    Exit;
  end;

  if Element1.TreeHead then begin
    Result := -1;
    Exit;
  end else if Element2.TreeHead then begin
    Result := 1;
    Exit;
  end;

  {"ChildrenOf" groups always sort like their owner}
  SortElement1 := FindSortElement(Element1);
  SortElement2 := FindSortElement(Element2);

  if Assigned(SortElement1) <> Assigned(SortElement2) then begin
    if Assigned(SortElement1) then
      Result := -1
    else
      Result := 1;
    Exit;
  end
  else if not Assigned(SortElement1) then begin
    Result := 0;
    Exit;
  end;

  Result := CmpI32(Ord(SortElement1.ElementType), Ord(SortElement2.ElementType));
  if Result = 0 then
    case SortElement1.ElementType of
      etFile: begin
          Assert(SortElement2.ElementType = etFile);

          if mniNavHeaderFilesLoadOrder.Checked then
            Column := 0
          else if mniNavHeaderFilesFileName.Checked then
            Column := 1;

          case Column of
            1, 2: Result := CompareText((SortElement1 as IwbFile).FileName, (SortElement2 as IwbFile).FileName);
          else
            Result := CmpI32((SortElement1 as IwbFile).LoadOrder, (SortElement2 as IwbFile).LoadOrder);
          end;

          Exit;
        end;
      etGroupRecord: begin
          Assert(SortElement2.ElementType = etGroupRecord);
          GroupRecord1 := SortElement1 as IwbGroupRecord;
          GroupRecord2 := SortElement2 as IwbGroupRecord;
          Result := CmpW32(GroupRecord1.GroupType, GroupRecord2.GroupType);
          if Result = 0 then
            case GroupRecord1.GroupType of
              0: begin
                var lLabel1 := TwbSignature(GroupRecord1.GroupLabel);
                var lLabel2 := TwbSignature(GroupRecord2.GroupLabel);
                var lName1: string := lLabel1;
                var lName2: string := lLabel2;
                if xeSortGroupsByFullName then begin
                  var lRecordDef: PwbMainRecordDef;
                  if wbFindRecordDef(lLabel1, lRecordDef) then
                    lName1 := lRecordDef.Name;
                  if wbFindRecordDef(lLabel2, lRecordDef) then
                    lName2 := lRecordDef.Name;
                end;
                Result := CompareText(
                  lName1,
                  lName2);
              end;
              2, 3: Result := CmpI32(
                  Integer(GroupRecord1.GroupLabel),
                  Integer(GroupRecord2.GroupLabel));
              4, 5: begin
                  Result := CmpI32(
                    LongRecSmall(GroupRecord1.GroupLabel).Hi,
                    LongRecSmall(GroupRecord2.GroupLabel).Hi);
                  if Result = 0 then
                    Result := CmpI32(
                      LongRecSmall(GroupRecord1.GroupLabel).Lo,
                      LongRecSmall(GroupRecord2.GroupLabel).Lo);
                end;
              1, 6..10: Result := CmpW32(GroupRecord1.GroupLabel, GroupRecord2.GroupLabel);
            else
              Assert(False);
            end;
        end;
      etMainRecord: begin
          Assert(SortElement2.ElementType = etMainRecord);
          MainRecord1 := SortElement1 as IwbMainRecord;
          MainRecord2 := SortElement2 as IwbMainRecord;
          Result := 0;
          case Column of
            1: Result := CompareText(MainRecord1.EditorID, MainRecord2.EditorID);
            2: Result := CompareText(MainRecord1.DisplayNameKey, MainRecord2.DisplayNameKey);
          end;
          if Result = 0 then begin
            Result := CmpI32(MainRecord1.SortPriority, MainRecord2.SortPriority);
            if wbSortINFO and mniNavHeaderINFObyPreviousINFO.Checked and (MainRecord1.Signature = 'INFO') and (MainRecord2.Signature = 'INFO') then begin
              if Supports(MainRecord1.Container, IwbGroupRecord, GroupRecord1) then
                GroupRecord1.Sort;
              Result := CmpW32(MainRecord1.SortOrder, MainRecord2.SortOrder);
            end;
            if Result = 0 then begin
              Result := TwbFormID.Compare(MainRecord1.LoadOrderFormID, MainRecord2.LoadOrderFormID);
              if Result = 0 then
                Result := CmpW32(Cardinal(Pointer(MainRecord1)), Cardinal(Pointer(MainRecord2)));
            end;
          end;
        end
    else
      Result := CmpI32(Element1.SortPriority, Element2.SortPriority);
      if Result = 0 then
        Result := CmpI32(Element1.SortOrder, Element2.SortOrder);
      if (Result = 0) and Assigned(Element1.Container) and Assigned(Element2.Container) and
         (Element1.Container = Element2.Container) then begin
        Container := Element1.Container as IwbContainerElementRef;
        if Container.ElementType = etArray then
          Result := CmpI32(Container.IndexOf(Element1), Container.IndexOf(Element2));
      end;

      if Result = 0 then
        Result := CmpW32(Cardinal(Pointer(Element1)), Cardinal(Pointer(Element2)));
      Exit;
    end;

  if Result = 0 then
    if Element1 <> SortElement1 then begin
      if Element2 <> SortElement2 then begin
        {both are groups of the same element }
        GroupRecord1 := Element1 as IwbGroupRecord;
        GroupRecord2 := Element2 as IwbGroupRecord;
        Result := CmpI32(GroupRecord1.GroupType, GroupRecord2.GroupType);
        if Result = 0 then
          Result := CmpW32(GroupRecord1.GroupLabel, GroupRecord2.GroupLabel);
      end
      else begin
        {element1 is a group of element2}
        Result := 1;
      end;
    end
    else begin
      if Element2 <> SortElement2 then begin
        {element2 is a group of element1}
        Result := -1;
      end
      else begin
        {really seems to be the same}
      end;
    end;
end;

procedure TfrmMain.vstNavExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var Allowed: Boolean);
begin
  // Fullexpand when Alt is pressed
  // No fullexpand if script is running because it can be hotkeyed to Alt+...
  // and use JumpTo() command which expands the navigation tree
  if (GetKeyState(VK_MENU) < 0) and not Assigned(Script) then
    Sender.FullExpand(Node);
end;

procedure TfrmMain.vstNavFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if vstNavLastChangeNode <> Node then
    vstNavChange(Sender, Node);
end;

procedure TfrmMain.vstNavFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with PNavNodeData(Sender.GetNodeData(Node))^ do begin
    MissingElements := nil;
    Element := nil;
    Container := nil;
    ConflictAll := caUnknown;
    ConflictThis := ctUnknown;
    OrgConflictAll := caUnknown;
    OrgConflictThis := ctUnknown;
    ElementGen := 0;
    ContainerGen := 0;
  end;
end;

procedure TfrmMain.vstNavGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Element      : IwbElement;
  MainRecord   : IwbMainRecord;
  GroupRecord  : IwbGroupRecord;
  Chapter      : IwbChapter;
  _File        : IwbFile;
  s            : string;
begin
  CellText := '';

  Element := PNavNodeData(Sender.GetNodeData(Node)).Element;

  if Assigned(Element) then begin
    if TextType = ttNormal then begin
      if Element.ElementType = etGroupRecord then begin
        GroupRecord := Element as IwbGroupRecord;
        if Column < 1 then
          CellText := GroupRecord.ShortName;
        if wbShowGroupRecordCount and (Column = 2) then
          if GroupRecord.ElementCount <> 0 then
            CellText := IntToStr(GroupRecord.ElementCount);
        Exit;
      end
      else if Element.ElementType = etMainRecord then begin
        MainRecord := Element as IwbMainRecord;
        case Column of
          -1, 0: begin
              if MainRecord.Signature = wbHeaderSignature then
                CellText := 'File Header'
              else begin
                CellText := MainRecord.LoadOrderFormID.ToString(True);
              end;
            end;
          1: CellText := MainRecord.EditorID;
          2: CellText := MainRecord.DisplayName[True];
        end;
        Exit;
      end
      else if Element.ElementType = etStructChapter then begin
        Chapter := Element as IwbChapter;
        case Column of
          -1, 0: CellText := Element.Name;
          1: CellText := Chapter.ChapterTypeName;
          2: CellText := Chapter.ChapterName;
        end;
        Exit;
      end else if Element.ElementType = etFile then begin
        _File := Element as IwbFile;
        case Column of
          -1, 0: CellText := _File.Name;
          1: begin
            s := '';
            if wbShowFileFlags and Assigned(_File.Header) then begin
              if _File.Header.IsESM then
                s := '<ESM>';
              if _File.Header.IsLight then
                s := s + '<' + wbLightName + '>';
              if _File.Header.IsMedium then
                s := s + '<Medium>';
              if _File.Header.IsOverlay then
                s := s + '<Overlay>';
              if _File.Header.IsLocalized then
                s := s + '<Localized>';
            end;
            CellText := s;
          end;
          2: if not (fsIsHardcoded in _File.FileStates) then
               if _File.CRC32.IsValid then
                  CellText := _File.CRC32.ToString;
        end;
        Exit;
      end;

      if Column < 1 then
        CellText := Element.Name
      else
        CellText := Element.Value;
    end
    else begin
      if (Column < 1) and (Element.ElementType = etMainRecord) then begin
        if Supports(Element.Container, IwbGroupRecord, GroupRecord) and (GroupRecord.GroupType in [1, 8..10]) then begin
          MainRecord := Element as IwbMainRecord;
          if Assigned(MainRecord.Def) then begin
            if MainRecord.HasPrecombinedMesh then
              CellText := '[' + MainRecord.Def.GetName + ']'
            else
              CellText := MainRecord.Def.GetName;
          end else
            CellText := MainRecord.Signature;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.vstNavHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with HitInfo do begin
    UserWasActive := True;

    if Button <> mbLeft then
      Exit;

    if Sender.SortColumn = Column then
      if Sender.SortDirection = sdAscending then
        Sender.SortDirection := sdDescending
      else
        Sender.SortDirection := sdAscending
    else begin
      Sender.SortColumn := Column;
    end;
    vstNav.ScrollIntoView(vstNav.FocusedNode, True);
  end;
end;

procedure TfrmMain.vstNavIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  Element                     : IwbElement;
  MainRecord                  : IwbMainRecord;
  GroupRecord                 : IwbGroupRecord;
  _File                       : IwbFile;
  CompareText                 : string;
  s                           : string;
  i                           : Integer;
begin
  UserWasActive := True;

  Result := 1;

  CompareText := '';

  Element := PNavNodeData(Sender.GetNodeData(Node)).Element;
  if Assigned(Element) then
    if Element.ElementType = etGroupRecord then begin
      GroupRecord := Element as IwbGroupRecord;
      if GroupRecord.GroupType = 0 then
        CompareText := GroupRecord.ShortName;
    end
    else if Element.ElementType = etMainRecord then begin
      MainRecord := Element as IwbMainRecord;
      case vstNav.Header.SortColumn of
        -1, 0: begin
            if MainRecord.Signature = 'TES4' then
              CompareText := 'File Header'
            else
              CompareText := MainRecord.LoadOrderFormID.ToString(True);
          end;
        1: CompareText := MainRecord.EditorID;
        2: CompareText := MainRecord.DisplayName[True];
      end;
    end
    else if Element.ElementType = etFile then begin
      _File := Element as IwbFile;
      CompareText := _File.FileName;
    end;

  s := SearchText;

  if Length(s) > Length(CompareText) then
    Exit;

  for i := 1 to Length(s) do
    if UpCase(s[i]) <> UpCase(CompareText[i]) then
      Exit;

  Result := 0;
end;

procedure TfrmMain.vstNavInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var
  Container                   : IwbContainerElementRef;
  NodeData                    : PNavNodeData;
  ChildNode                   : PVirtualNode;
  ChildNodeData               : PNavNodeData;
  i, j                        : Integer;
begin
  NodeData := Sender.GetNodeData(Node);

  if Assigned(NodeData) and Supports(NodeData.Container, IwbContainerElementRef, Container) then begin
    Inc(vstNavInitChildrenGeneration);
    ChildCount := Container.ElementCount;
    NodeData.MissingElements := nil;

    ChildNode := Node.FirstChild;
    if Assigned(ChildNode) then begin
      for i := 0 to Pred(Integer(ChildCount)) do
        Container.Elements[i].Found := False;
      while Assigned(ChildNode) do begin
        ChildNodeData := Sender.GetNodeData(ChildNode);
        if Assigned(ChildNodeData) then begin
          if Assigned(ChildNodeData.Element) then begin
            if not Container.Equals(ChildNodeData.Element.Container) then begin
              Sender.DeleteChildren(ChildNode);
              vstNavFreeNode(Sender, ChildNode);
              ChildNode.States := ChildNode.States - [vsInitialized, vsChecking,
                vsCutOrCopy, vsDeleting, vsHasChildren, vsExpanded, vsHeightMeasured];
            end else
              ChildNodeData.Element.Found := True;
          end else begin
            vstNavFreeNode(Sender, ChildNode);
            ChildNode.States := ChildNode.States - [vsInitialized, vsChecking,
              vsCutOrCopy, vsDeleting, vsHasChildren, vsExpanded, vsHeightMeasured];
          end;
        end;
        ChildNode := ChildNode.NextSibling;
      end;
      SetLength(NodeData.MissingElements, ChildCount);
      j := 0;
      for i := 0 to Pred(Integer(ChildCount)) do
        if not Container.Elements[i].Found then begin
          NodeData.MissingElements[j] := Container.Elements[i];
          Inc(j);
        end;
      SetLength(NodeData.MissingElements, j);
    end;
  end else
    ChildCount := 0;
end;

procedure TfrmMain.vstNavInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeData       : PNavNodeData;
  ParentNodeData : PNavNodeData;
  Element        : IwbElement;
  Container      : IwbContainerElementRef;
  Container2     : IwbContainerElementRef;
  GroupRecord    : IwbGroupRecord;
  MainRecord     : IwbMainRecord;
  i              : Integer;
  FoundGroup     : Boolean;
  SiblingNode    : PVirtualNode;
  SiblingNodeData: PNavNodeData;
  AdditionalWorkReq : Boolean;
begin
  AdditionalWorkReq := ivsReInit in InitialStates;

  GroupRecord := nil;
  NodeData := PNavNodeData(Sender.GetNodeData(Node));
  with NodeData^ do begin
    ElementGen := 0;
    ContainerGen := 0;
    ConflictAll := caUnknown;
    ConflictThis := ctUnknown;
    OrgConflictAll := caUnknown;
    OrgConflictThis := ctUnknown;
  end;

  GroupRecord := nil;
  Element := NodeData.Element;
  ParentNodeData := Sender.GetNodeData(Node.Parent);
  if Assigned(ParentNodeData) then
    Container := ParentNodeData.Container as IwbContainerElementRef;
  if not Assigned(Element) then begin
    if Assigned(ParentNodeData) then begin
      i := Length(ParentNodeData.MissingElements);
      if i > 0 then begin
        Dec(i);
        Element := ParentNodeData.MissingElements[i];
        SetLength(ParentNodeData.MissingElements, i);
        AdditionalWorkReq := True;
      end else
        if Assigned(Container) and (Node.Index < Cardinal(Container.ElementCount)) then begin
          Element := Container.Elements[Node.Index];
          if Assigned(Element) and (Element.ElementType = etMainRecord) then
            if Integer(Succ(Node.Index)) < Container.ElementCount then begin
              if Supports(Container.Elements[Succ(Node.Index)], IwbGroupRecord, GroupRecord) then begin
                if (not (GroupRecord.GroupType in ParentedGroupRecordType)) or
                  ((Element as IwbMainRecord).FormID.ToCardinal <> GroupRecord.GroupLabel) then
                  GroupRecord := nil;
              end;
            end;
        end;
      NodeData.Element := Element;
    end;
  end;

  if not Assigned(Element) then begin
    Include(InitialStates, ivsHidden);
    Exit;
  end;

  if AdditionalWorkReq then
    if not Assigned(GroupRecord) then
      if Supports(Element, IwbMainRecord, MainRecord) then begin
        GroupRecord := MainRecord.ChildGroup;
        if Assigned(GroupRecord) then begin
          FoundGroup := False;
          SiblingNode := Node.PrevSibling;
          while not FoundGroup and Assigned(SiblingNode) do begin
            SiblingNodeData := Sender.GetNodeData(SiblingNode);
            if GroupRecord.Equals(SiblingNodeData.Element) then
              FoundGroup := True;
            SiblingNode := SiblingNode.PrevSibling;
          end;
          if not FoundGroup then begin
            SiblingNode := Node.NextSibling;
            while not FoundGroup and Assigned(SiblingNode) do begin
              SiblingNodeData := Sender.GetNodeData(SiblingNode);
              if GroupRecord.Equals(SiblingNodeData.Element) then begin
                FoundGroup := True;
                Break;
              end;
              SiblingNode := SiblingNode.NextSibling;
            end;
          end;
          if FoundGroup and Assigned(SiblingNode) then begin
            Sender.IsVisible[SiblingNode] := False;
            Sender.HasChildren[SiblingNode] := False;
            vstNavFreeNode(Sender, SiblingNode);
          end;
        end;
      end;

  if not (Element.ElementType in [etMainRecord, etStructChapter]) and not Element.TreeHead then begin
    if Supports(Element, IwbContainerElementRef, Container) and (Container.ElementCount > 0) then begin
      Include(InitialStates, ivsHasChildren);
      NodeData.Container := IInterface(Container) as IwbContainer;
    end
  end else if Assigned(GroupRecord) then begin
    if GroupRecord.ElementCount > 0 then
      Include(InitialStates, ivsHasChildren);
    NodeData.Container := GroupRecord;
  end else if Element.ElementType = etStructChapter then
    if Supports(Element, IwbContainerElementRef, Container) and (Container.ElementCount > 0) then
      for i := 0 to Pred(Container.ElementCount) do
        if (Container.Elements[i].TreeBranch) and
            Supports(Container.Elements[i], IwbContainerElementRef, Container2) and (Container2.ElementCount > 0) then begin
          Include(InitialStates, ivsHasChildren);
          NodeData.Container := Container.Elements[i] as IwbContainer;
          Break;
        end;

  if Supports(Element, IwbGroupRecord, GroupRecord) and (GroupRecord.GroupType in ParentedGroupRecordType) then begin
    FoundGroup := False;
    if Node.Index > 0 then begin
      Container := PNavNodeData(Sender.GetNodeData(Node.Parent)).Container as IwbContainerElementRef;
      if Assigned(Container) and (Integer(Node.Index) < Container.ElementCount) then begin
        Element := Container.Elements[Pred(Node.Index)];
        if (Element.ElementType = etMainRecord) and
          ((Element as IwbMainRecord).FormID.ToCardinal = GroupRecord.GroupLabel) then begin
          FoundGroup := True;
        end;
      end;
    end;
    if AdditionalWorkReq then begin
      if not FoundGroup then begin
        MainRecord := GroupRecord.ChildrenOf;
        if Assigned(MainRecord) then begin
          SiblingNode := Node.PrevSibling;
          while not FoundGroup and Assigned(SiblingNode) do begin
            SiblingNodeData := Sender.GetNodeData(SiblingNode);
            if MainRecord.Equals(SiblingNodeData.Element) then
              FoundGroup := True;
            SiblingNode := SiblingNode.PrevSibling;
          end;
          if not FoundGroup then begin
            SiblingNode := Node.NextSibling;
            while not FoundGroup and Assigned(SiblingNode) do begin
              SiblingNodeData := Sender.GetNodeData(SiblingNode);
              if MainRecord.Equals(SiblingNodeData.Element) then
                FoundGroup := True;
              SiblingNode := SiblingNode.NextSibling;
            end;
          end;
        end;
      end;
      if not FoundGroup then begin
        if Assigned(MainRecord) and Assigned(ParentNodeData) then begin
          for i := High(ParentNodeData.MissingElements) downto Low(ParentNodeData.MissingElements) do
            if MainRecord.Equals(ParentNodeData.MissingElements[i]) then
              FoundGroup := True;
        end;
      end;
    end;
    if FoundGroup then begin
      Include(InitialStates, ivsHidden);
      Exclude(InitialStates, ivsHasChildren);
      NodeData.Container := nil;
      NodeData.Element := nil;
      NodeData.MissingElements := nil;
    end;
  end;

  with NodeData^ do begin
    if Assigned(Element) then
      ElementGen := Element.ElementGeneration;
    if Assigned(Container) then
      ContainerGen := Container.ElementGeneration;

    if wbLoaderDone and
      wbTranslationMode and
      Assigned(Element) and
      (InitialStates * [ivsHidden, ivsHasChildren] = []) and
      (Element.ElementType = etMainRecord) then begin

      if ConflictThis = ctUnknown then begin
        MainRecord := Element as IwbMainRecord;
        ConflictLevelForMainRecord(MainRecord, ConflictAll, ConflictThis);
        OrgConflictAll  := ConflictAll;
        OrgConflictThis := ConflictThis;
        if MainRecord.IsInjected then
          Include(NodeData.Flags, nnfInjected)
        else
          Exclude(NodeData.Flags, nnfInjected);
        if MainRecord.IsNotReachable then
          Include(NodeData.Flags, nnfNotReachable)
        else
          Exclude(NodeData.Flags, nnfNotReachable);
        if MainRecord.ReferencesInjected then
          Include(NodeData.Flags, nnfReferencesInjected)
        else
          Exclude(NodeData.Flags, nnfReferencesInjected);
      end;

      if ConflictThis < ctIdenticalToMaster then
        Include(InitialStates, ivsHidden);
    end;
  end;
end;

procedure TfrmMain.vstNavKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  r          : TRect;
  p          : TPoint;
  i          : Integer;
  s, t       : string;
  Nodes      : TNodeArray;
  NodeData   : PNavNodeData;
  MainRecord : IwbMainRecord;
  Chapter    : IwbChapter;
  _File      : IwbFile;
begin
  if wbLoaderDone then
    case Key of
      VK_DELETE: begin
        pmuNavPopup(nil);
        if mniNavRemove.Enabled and mniNavRemove.Visible then
          mniNavRemove.Click;
      end;
      VK_INSERT: begin
        pmuNavPopup(nil);
        if mniNavAdd.Enabled and mniNavAdd.Visible then begin
          if mniNavAdd.Count = 1 then
            mniNavAdd.Items[0].Click
          else begin
            r := vstNav.GetDisplayRect(vstNav.FocusedNode, 0, True);
            p := vstNav.ClientToScreen(Point(r.Left, r.Bottom));
            pmuNavAdd.Popup(p.X, p.Y);
          end;
        end;
      end;
      VK_F2: begin
        pmuNavPopup(nil);
        if mniNavChangeFormID.Enabled and mniNavChangeFormID.Visible then
          mniNavChangeFormID.Click;
      end;
      Ord('M'): if Shift = [ssCtrl] then begin
        pmuNavPopup(nil);
        if mniNavCreateModGroup.Visible then
          mniNavCreateModGroupClick(nil);
      end;
    end;

  if ssCtrl in Shift then begin
    case Key of
      Ord('C'): begin
        Key := 0;
        s := '';
        Nodes := vstNav.GetSortedSelection(True);
        for i := Low(Nodes) to High(Nodes) do begin
          NodeData := vstNav.GetNodeData(Nodes[i]);
          t := '';
          if Assigned(NodeData.Element) then
            with NodeData^ do
              case Element.ElementType of
                etMainRecord: begin
                  MainRecord := Element as IwbMainRecord;
                  if Shift * [ssShift, ssAlt] = [ssAlt] then
                    t := MainRecord.Name
                  else
                    vstNavGetText(vstNav, Nodes[i], 0, ttNormal, t);
                end;
                etStructChapter: begin
                  Chapter := Element as IwbChapter;
                  if Shift * [ssShift, ssAlt] = [ssAlt] then
                    t := Chapter.ChapterName
                  else
                    vstNavGetText(vstNav, Nodes[i], 0, ttNormal, t);
                end;
                etFile: begin
                  _File := Element as IwbFile;
                  if Shift * [ssShift, ssAlt] = [ssAlt] then
                    t := _File.CRC32.ToString
                  else
                    t := _File.FileName;
                end;
              else
                vstNavGetText(vstNav, Nodes[i], 0, ttNormal, t);
              end;
          if t <> '' then begin
            if s <> '' then
              s := s + CRLF;
            s := s + t;
          end;


        end;

        if s <> '' then
          Clipboard.AsText := s;
        Exit;
      end;
    else
      Exit;
    end;
  end;
end;

procedure TfrmMain.vstNavKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = '?' then begin
    Key := #0;
    edFileNameFilter.SetFocus;
  end;
end;

procedure TfrmMain.TryViewOrCompareSelectedRecords(aElement: IwbElement);
var
  _File                       : IwbFile;
  MainRecord                  : IwbMainRecord;
begin
  var MainRecords: TDynMainRecords := nil;

  var SelectedNodes: TNodeArray := vstNav.GetSortedSelection(True);
  var SelectedNodesCount: Integer := Length(SelectedNodes);

  var Ctrl: Boolean := GetAsyncKeyState(VK_CONTROL) < 0;

  if InRange(SelectedNodesCount, 2, wbAutoCompareSelectedLimit) or (Ctrl and ComparingSiblings) then
  begin
    SetLength(MainRecords, SelectedNodesCount);

    var FirstNode: PVirtualNode := nil;
    var j: Integer := 0;

    for var i := Low(SelectedNodes) to High(SelectedNodes) do
    begin
      var NodeData: PNavNodeData := vstNav.GetNodeData(SelectedNodes[i]);

      if not Assigned(NodeData.Element) or not (NodeData.Element.ElementType = etMainRecord) then
        Continue;

      MainRecords[j] := NodeData.Element as IwbMainRecord;

      if not Assigned(FirstNode) then
      begin
        FirstNode := SelectedNodes[i];
        Inc(j);
      end
      else if FirstNode.Parent = SelectedNodes[i].Parent then
        Inc(j);
    end;

    SetLength(MainRecords, j);
  end;

  if Length(MainRecords) > 1 then
    SetActiveRecord(MainRecords)
  else if Supports(aElement, IwbMainRecord, MainRecord) then
    SetActiveRecord(MainRecord)
  else if Supports(aElement, IwbFile, _File) and (_File.ElementCount > 0) and Supports(_File.Elements[0], IwbMainRecord, MainRecord) then
    SetActiveRecord(MainRecord)
  else if Supports(aElement, IwbDataContainer) then
    SetActiveContainer(aElement as IwbDataContainer)
  else if ActiveRecordLock < 1 then
    ClearActiveContainer;
end;

procedure TfrmMain.vstNavPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeData                    : PNavNodeData;
  MainRecord                  : IwbMainRecord;
begin
  TargetCanvas.Font.Color := clWindowText;
  NodeData := Sender.GetNodeData(Node);
  MainRecord := nil;
  if Assigned(NodeData) and Assigned(NodeData.Element) then begin
    if NodeData.Element.ElementType = etMainRecord then begin
      MainRecord := NodeData.Element as IwbMainRecord;

      if wbLoaderDone then
        if (NodeData.ConflictThis = ctUnknown) or (MainRecord.ElementGeneration <> NodeData.ElementGen) then begin
          ConflictLevelForMainRecord(MainRecord, NodeData.ConflictAll, NodeData.ConflictThis);
          with NodeData^ do begin
            OrgConflictAll  := ConflictAll;
            OrgConflictThis := ConflictThis;
          end;
          NodeData.ElementGen := MainRecord.ElementGeneration;
          if MainRecord.IsInjected then
            Include(NodeData.Flags, nnfInjected)
          else
            Exclude(NodeData.Flags, nnfInjected);
          if MainRecord.IsNotReachable then
            Include(NodeData.Flags, nnfNotReachable)
          else
            Exclude(NodeData.Flags, nnfNotReachable);
          if MainRecord.ReferencesInjected then
            Include(NodeData.Flags, nnfReferencesInjected)
          else
            Exclude(NodeData.Flags, nnfReferencesInjected);
        end;

      if Column = 0 then
        if MainRecord.Signature <> wbHeaderSignature then
          if MonospaceFontName <> '' then
            TargetCanvas.Font.Name := MonospaceFontName;
    end else if NodeData.Element.ElementType = etFile then begin
      if Column = 2 then
        if MonospaceFontName <> '' then
          TargetCanvas.Font.Name := MonospaceFontName;
    end;

    if wbLoaderDone then begin
      if NodeData.Element.Modified then
        TargetCanvas.Font.Style := [fsBold];
      if nnfInjected in NodeData.Flags then
        TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic]
      else
        TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsItalic];
      if nnfNotReachable in NodeData.Flags then
        TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsStrikeOut]
      else
        TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsStrikeOut];
      if nnfReferencesInjected in NodeData.Flags then
        TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsUnderline]
      else
        TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsUnderline];
    end;
  end;

  if wbLoaderDone then
    TargetCanvas.Font.Color := wbDarker(ConflictThisToColor(NodeData.ConflictThis));
end;

procedure TfrmMain.vstSpreadSheetCheckHotTrack(Sender: TBaseVirtualTree; HotNode: PVirtualNode; HotColumn: TColumnIndex; var Allow: Boolean);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
begin
  Allow := False;

  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;

  if (HotColumn < 1) or (HotColumn >= TVirtualEditTree(Sender).Header.Columns.Count) then
    Exit;

  NodeDatas := Sender.GetNodeData(HotNode);
  if not Assigned(NodeDatas) then
    Exit;

  if HotColumn = 1 then begin
    Element := NodeDatas[0].Element
  end
  else begin
    Element := NodeDatas[HotColumn].Element;

    if not Assigned(Element) then
      Exit;

    Element := Element.LinksTo;
    while Assigned(Element) and (Element.ElementType <> etMainRecord) do
      Element := Element.Container;
  end;

  Allow := Assigned(Element);
end;

procedure TfrmMain.vstSpreadSheetCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeDatas1                  : PSpreadSheetNodeDatas;
  NodeDatas2                  : PSpreadSheetNodeDatas;

  Element1                    : IwbElement;
  Element2                    : IwbElement;
begin
  NodeDatas1 := PSpreadSheetNodeDatas(Sender.GetNodeData(Node1));
  NodeDatas2 := PSpreadSheetNodeDatas(Sender.GetNodeData(Node2));

  if NodeDatas1 = NodeDatas2 then begin
    Result := 0;
    Exit;
  end;

  if Column < 2 then begin
    Element1 := NodeDatas1[0].Element;
    Element2 := NodeDatas2[0].Element;
  end
  else begin
    Element1 := NodeDatas1[Column].Element;
    Element2 := NodeDatas2[Column].Element;
  end;

  if Assigned(Element1) <> Assigned(Element2) then begin
    if Assigned(Element1) then
      Result := -1
    else
      Result := 1;
    Exit;
  end
  else if not Assigned(Element1) then begin
    Result := 0;
    Exit;
  end;

  case Column of
    0: Result := CompareText(Element1._File.FileName, Element2._File.FileName);
    1: Result := TwbFormID.Compare((Element1 as IwbMainRecord).LoadOrderFormID, (Element2 as IwbMainRecord).LoadOrderFormID);
  else
    Result := CompareStr(Element1.DisplaySortKey[True], Element2.DisplaySortKey[True]);
  end;
end;

procedure TfrmMain.vstSpreadSheetDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
begin
  Allowed := False;
  if not wbEditAllowed then
    Exit;
  if Column < Sender.Tag then
    Exit;
  NodeDatas := Sender.GetNodeData(Node);
  Allowed := Assigned(NodeDatas[Column].Element);
end;

procedure TfrmMain.vstSpreadSheetDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  TargetElement               : IwbElement;
  SourceElement               : IwbElement;
begin
  if not wbEditAllowed then
    Exit;
  if Source <> Sender then
    Exit;

  UserWasActive := True;

  if Sender.DropTargetColumn < Sender.Tag then
    Exit;
  NodeDatas := Sender.GetNodeData(Sender.DropTargetNode);
  TargetElement := NodeDatas[Sender.DropTargetColumn].Element;
  if not Assigned(TargetElement) then
    Exit;

  if TVirtualEditTree(Sender).DragColumn < Sender.Tag then
    Exit;
  if Length(TVirtualEditTree(Sender).DragSelection) <> 1 then
    Exit;

  NodeDatas := Sender.GetNodeData(TVirtualEditTree(Sender).DragSelection[0]);
  SourceElement := NodeDatas[TVirtualEditTree(Sender).DragColumn].Element;
  if not Assigned(SourceElement) then
    Exit;

  if TargetElement.Equals(SourceElement) then
    Exit;

  if not TargetElement.CanAssign(Low(Integer), SourceElement, True) then
    Exit;

  if not EditWarn then
    Exit;

  TargetElement.Assign(Low(Integer), SourceElement, False);
end;

procedure TfrmMain.vstSpreadSheetDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  TargetElement               : IwbElement;
  SourceElement               : IwbElement;
begin
  Accept := True;
  if not wbEditAllowed then
    Exit;
  if Source <> Sender then
    Exit;

  if Sender.DropTargetColumn < Sender.Tag then
    Exit;
  NodeDatas := Sender.GetNodeData(Sender.DropTargetNode);
  TargetElement := NodeDatas[Sender.DropTargetColumn].Element;
  if not Assigned(TargetElement) then
    Exit;

  if TVirtualEditTree(Sender).DragColumn < Sender.Tag then
    Exit;
  if Length(TVirtualEditTree(Sender).DragSelection) <> 1 then
    Exit;

  NodeDatas := Sender.GetNodeData(TVirtualEditTree(Sender).DragSelection[0]);
  SourceElement := NodeDatas[TVirtualEditTree(Sender).DragColumn].Element;
  if not Assigned(SourceElement) then
    Exit;

  if TargetElement.Equals(SourceElement) then
    Exit;

  if not TargetElement.CanAssign(Low(Integer), SourceElement, True) then
    Exit;

  Accept := True;
end;

procedure TfrmMain.vstSpreadSheetEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
begin
  Allowed := False;

  if not wbEditAllowed then
    Exit;

  if Column < Sender.Tag then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Column].Element;

  if not Assigned(Element) then
    Exit;

  Allowed := Element.IsEditable and EditWarn;
end;

procedure TfrmMain.vstSpreadSheetFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  i                           : integer;
begin
  NodeDatas := Sender.GetNodeData(Node);
  for i := 0 to Pred(TVirtualEditTree(Sender).Header.Columns.Count) do
    NodeDatas[i].Element := nil;
end;

procedure TfrmMain.vstSpreadSheetGetEditText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var CellText: string);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
begin
  CellText := '';
  if Column < Sender.Tag then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Column].Element;
  if Assigned(Element) and Element.IsEditable then
    CellText := Element.EditValue;
end;

procedure TfrmMain.vstSpreadSheetGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  Element                     : IwbElement;
  MainRecord                  : IwbMainRecord;
begin
  CellText := '';

  if (Column < 0) or (Column >= TVirtualEditTree(Sender).Header.Columns.Count) then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;
  Element := NodeDatas[0].Element;
  if not Assigned(Element) then
    Exit;

  case Column of
    0: CellText := Element._File.Name;
    1: CellText := (Element as IwbMainRecord).LoadOrderFormID.ToString(True);
  else
    Element := NodeDatas[Column].Element;
    if not Assigned(Element) then
      Exit;
    if Element.CanContainFormIDs then begin
      Element := Element.LinksTo;
      if Supports(Element, IwbMainRecord, MainRecord) then begin
        CellText := MainRecord.EditorID;
        if CellText = '' then
          CellText := MainRecord.LoadOrderFormID.ToString(True);
      end;
    end else
      CellText := Element.Value;
  end;
end;

procedure TfrmMain.vstSpreadSheetClick(Sender: TObject);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
  HotColumn                   : TColumnIndex;
begin
  if GetKeyState(VK_CONTROL) >= 0 then
    Exit;

  HotColumn := TVirtualEditTree(Sender).HotColumn;

  if (HotColumn < 1) or (HotColumn >= TVirtualEditTree(Sender).Header.Columns.Count) then
    Exit;

  NodeDatas := TVirtualEditTree(Sender).GetNodeData(TVirtualEditTree(Sender).HotNode);
  if not Assigned(NodeDatas) then
    Exit;

  if HotColumn = 1 then begin
    Element := NodeDatas[0].Element
  end
  else begin
    Element := NodeDatas[HotColumn].Element;

    if not Assigned(Element) then
      Exit;

    Element := Element.LinksTo;
    while Assigned(Element) and (Element.ElementType <> etMainRecord) do
      Element := Element.Container;
  end;

  if Assigned(Element) then begin
    ForwardHistory := nil;
    JumpTo(Element as IwbMainRecord, False);
  end;
end;

procedure TfrmMain.vstSpreadSheetIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  CompareText                 : string;
  s                           : string;
  i                           : Integer;
begin
  UserWasActive := True;

  Result := 1;

  CompareText := TVirtualEditTree(Sender).
    Text[Node, Sender.FocusedColumn, False];

  s := SearchText;

  if Length(s) > Length(CompareText) then
    Exit;

  for i := 1 to Length(s) do
    if UpCase(s[i]) <> UpCase(CompareText[i]) then
      Exit;

  Result := 0;
end;

procedure TfrmMain.vstSpreadSheetCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  if Column < Sender.Tag then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  Element := NodeDatas[Column].Element;

  if not Assigned(Element) then
    Exit;

  vstCreateEditor(Element, EditLink);
end;

procedure TfrmMain.vstSpreadSheetWeaponInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  MainRecord                  : IwbMainRecord;
  Rec                        : IwbRecord;
begin
  NodeDatas := Sender.GetNodeData(Node);
  if not Assigned(NodeDatas) then
    Exit;

  if not Supports(NodeDatas[0].Element, IwbMainRecord, MainRecord) then
    Exit;

  {EditorID}
  NodeDatas[2].Element := MainRecord.RecordBySignature['EDID'];

  {Weapon Name}
  NodeDatas[3].Element := MainRecord.RecordBySignature['FULL'];

  if wbGameMode = gmTES4 then begin
    {Enchantment}
    NodeDatas[4].Element := MainRecord.RecordBySignature['ENAM'];

    Rec := MainRecord.RecordBySignature['DATA'];
    if Assigned(Rec) then begin
      NodeDatas[5].Element := Rec.Elements[0];
      NodeDatas[6].Element := Rec.Elements[1];
      NodeDatas[7].Element := Rec.Elements[2];
      NodeDatas[8].Element := Rec.Elements[4];
      NodeDatas[9].Element := Rec.Elements[5];
      NodeDatas[10].Element := Rec.Elements[6];
      NodeDatas[11].Element := Rec.Elements[7];
    end;
  end else begin
    {Enchantment}
    NodeDatas[4].Element := MainRecord.RecordBySignature['EITM'];
    {Amount}
    NodeDatas[12].Element := MainRecord.RecordBySignature['EAMT'];

    {Type}
    NodeDatas[5].Element := MainRecord.RecordBySignature['ETYP'];

      Rec := MainRecord.RecordBySignature['DATA'];
      if Assigned(Rec) then begin
        {Value}
        NodeDatas[8].Element := Rec.Elements[0];

        {Weight}
        NodeDatas[10].Element := Rec.Elements[1];

        {Damage}
        NodeDatas[11].Element := Rec.Elements[2];
      end;

    Rec := MainRecord.RecordBySignature['DNAM'];
    if Assigned(Rec) then begin
      {Speed}
      NodeDatas[6].Element := Rec.Elements[2];

      {Reach}
      NodeDatas[7].Element := Rec.Elements[3];

      {Skill}
      NodeDatas[13].Element := Rec.ElementByName['Skill'];

      {Stagger}
      NodeDatas[14].Element := Rec.ElementByName['Stagger'];

        {Range Min}
        NodeDatas[17].Element := Rec.ElementByName['Range Min'];

        {Range Max}
        NodeDatas[18].Element := Rec.ElementByName['Range Max'];
      end;

    Rec := MainRecord.RecordBySignature['CRDT'];
    if Assigned(Rec) then begin
        {CritDamage}
        NodeDatas[15].Element := Rec.ElementByName['Damage'];

      {Range Max}
        NodeDatas[16].Element := Rec.ElementByName['% Mult'];
      end;

      {Detection Sound}
      NodeDatas[19].Element := MainRecord.RecordBySignature['VNAM'];

    {Detection Sound}
    NodeDatas[20].Element := MainRecord.RecordBySignature['CNAM'];
  end;
end;

procedure TfrmMain.vstSpreadSheetPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  NodeDatas                   : PSpreadsheetNodeDatas;
  Element                     : IwbElement;
begin
  TargetCanvas.Font.Color := clWindowText;

  if (Column < 0) or (Column >= TVirtualEditTree(Sender).Header.Columns.Count) then
    Exit;

  Element := nil;
  if Column >= Sender.Tag then begin
    NodeDatas := Sender.GetNodeData(Node);
    if Assigned(NodeDatas) then
      Element := NodeDatas[Column].Element;
  end;

  if Assigned(Element) then begin

    if Element.Modified then
      TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold]
    else
      TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsBold];

    if Element.IsInjected then
      TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic]
    else
      TargetCanvas.Font.Style := TargetCanvas.Font.Style - [fsItalic];
  end;
end;

procedure TfrmMain.vstSpreadSheetNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  NodeDatas                   : PSpreadSheetNodeDatas;
  Element                     : IwbElement;
begin
  if not wbEditAllowed then
    Exit;

  UserWasActive := True;

  if Column < Sender.Tag then
    Exit;

  NodeDatas := Sender.GetNodeData(Node);
  if Assigned(NodeDatas) then begin
    Element := NodeDatas[Column].Element;
    if Assigned(Element) and Element.IsEditable then begin

      if not EditWarn then
        Exit;

      Element.EditValue := NewText;
    end;
  end;
end;

procedure TfrmMain.WMUser(var Message: TMessage);
var
  t : string;
begin
  Pointer(t) := Pointer(Message.WParam);
  if not Assigned(NewMessages) then
    NewMessages := TStringList.Create;

  var Strs := t.Split(CRLF);
  if Length(Strs) < 1 then
    SetLength(Strs, 1);

  for var s in Strs do
    NewMessages.Add(s);
end;

procedure TfrmMain.WMUser1(var Message: TMessage);
begin
  AddFile(IwbFile(Pointer(Message.WParam)));
end;

procedure TfrmMain.WMUserLoaderDone(var Message: TMessage);

  procedure SetupTreeView(aTreeView: TVirtualEditTree);
  var
    j: Integer;
  begin
    with aTreeView.Header.Columns do
      for j := 0 to Pred(Count) do
        with Items[j] do begin
          if Options * [coVisible, coEnabled] = [coVisible, coEnabled] then
            Options := Options + [coAllowFocus]
          else
            Options := Options - [coAllowFocus];
          if j < 3 then
            Options := Options + [coFixed];
        end;
  end;

var
  i         : Integer;
  ModGroups : TwbModGroupPtrs;
  LoadOrder : Integer;
  NewFile   : IwbFile;
  MasterFile: IwbFile;
  WasUnsaved: Boolean;
  Worldspaces: IwbElement;
begin
  try
    wbLoaderDone := True;
    wbStartTime := PDateTime(Message.WParam)^;
    LoadOrder := Message.LParam;
    if LoadOrder < 0 then begin
      Inc(wbShowStartTime);
      try
        if wbToolMode in [tmEdit] then begin
          // unchecked Show Tip checkbox, update setting
          if Assigned(frmTip) and not wbShowTip then begin
            Settings.WriteBool('Options', 'ShowTip', wbShowTip);
            Settings.UpdateFile;
          end;
          HideTip;
        end;

        if wbLoaderError then begin
          ShowMessage('An error occured while loading modules. Editing is disabled. Check the message log and correct the error.');
          Exit;
        end;

        _BlockInternalEdit := False;

        if (wbToolMode in [tmLODgen, tmScript]) then begin
          if not wbForceTerminate then
            tmrGenerator.Enabled := True;
          Exit;
        end;

          if wbIsSkyrim then begin
          with vstSpreadSheetWeapon.Header.Columns[9] do
            Options := Options - [coVisible];
          for i := 12 to 20 do
            with vstSpreadSheetWeapon.Header.Columns[i] do
              Options := Options + [coVisible];

          with vstSpreadsheetArmor.Header.Columns[9] do
            Options := Options - [coVisible];
          with vstSpreadsheetArmor.Header.Columns[6] do
            Text := 'Armor Type';
          for i := 11 to 12 do
            with vstSpreadsheetArmor.Header.Columns[i] do
              Options := Options + [coVisible];

          with vstSpreadSheetAmmo.Header.Columns[5] do
            Options := Options - [coVisible];
          with vstSpreadSheetAmmo.Header.Columns[7] do
            Options := Options - [coVisible];
          with vstSpreadSheetAmmo.Header.Columns[4] do
            Text := 'Projectile';
          with vstSpreadSheetAmmo.Header.Columns[9] do
            Options := Options + [coVisible];
        end;

        SetupTreeView(vstSpreadSheetWeapon);
        SetupTreeView(vstSpreadsheetArmor);
        SetupTreeView(vstSpreadSheetAmmo);

        tbsWEAPSpreadsheet.TabVisible := (wbGameMode = gmTES4) or wbIsSkyrim;
        tbsARMOSpreadsheet.TabVisible := (wbGameMode = gmTES4) or wbIsSkyrim;
        tbsAMMOSpreadsheet.TabVisible := (wbGameMode = gmTES4) or wbIsSkyrim;

        if wbForceTerminate then begin
          GeneralProgressNoAbortCheck('Loading of modules got terminated early. Editing is disabled.');
          Exit;
        end;

        tmrCheckUnsaved.Enabled := True;

        if wbFirstLoadComplete then
          Exit;

        wbFirstLoadComplete := True;

        ModGroups := nil;

        if not (xeQuickClean or (wbToolMode in wbAutoModes)) then
          if xeQuickShowConflicts or xeAutoLoad then begin
            ModGroups := wbModGroupsByName;
            wbModGroupsByName(False).ShowValidationMessages;
          end else
            if wbToolMode in [tmView, tmEdit] then begin
              with TfrmModGroupSelect.Create(Self) do try
                AllModGroups := wbModGroupsByName;
                wbModGroupsByName(False).ShowValidationMessages;
                LoadModGroupsSelection(AllModGroups);
                Caption := 'Which ModGroups do you want to activate?';
                PresetCategory := 'ActiveModGroups';
                if ShowModal = mrOk then begin
                  SaveModGroupsSelection(SelectedModGroups);
                  ModGroups := SelectedModGroups;
                end;
              finally
                Free;
              end;
            end;

        ModGroupsExist := ModGroups.Activate;
        ModGroupsEnabled := ModGroupsExist;
        mniModGroupsEnabled.Checked := ModGroupsEnabled;
        mniModGroupsDisabled.Checked := not ModGroupsEnabled;

        if xeQuickShowConflicts then
          mniNavFilterConflicts.Click;

        if xeQuickClean then begin
          pnlNavContent.Visible := False;
          try
            mniNavFilterForCleaning.Click;
            JumpTo(wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)[0]._File.Header, False);
            vstNav.ClearSelection;
            vstNav.FocusedNode := vstNav.FocusedNode.Parent;
            vstNav.Selected[vstNav.FocusedNode] := True;
            DoSetActiveRecord(nil);
            pgMain.ActivePage := tbsMessages;
            mniNavUndeleteAndDisableReferences.Click;
            mniNavRemoveIdenticalToMaster.Click;

            WasUnsaved := False;
            with wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)[0]._File do
              if esUnsaved in ElementStates then
                WasUnsaved := True;

            if xeQuickCleanAutoSave then begin
              if SaveChanged(True) >= srAbort then
                Exit;

              if WasUnsaved then begin
                ResetAllConflict;

                mniNavFilterForCleaning.Click;
                JumpTo(wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)[0]._File.Header, False);
                vstNav.ClearSelection;
                vstNav.FocusedNode := vstNav.FocusedNode.Parent;
                vstNav.Selected[vstNav.FocusedNode] := True;
                DoSetActiveRecord(nil);
                pgMain.ActivePage := tbsMessages;
                mniNavUndeleteAndDisableReferences.Click;
                mniNavRemoveIdenticalToMaster.Click;

                WasUnsaved := False;
                with wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)[0]._File do
                  if esUnsaved in ElementStates then
                    WasUnsaved := True;

                if xeQuickCleanAutoSave then begin
                  if SaveChanged(True) >= srAbort then
                    Exit;

                  if WasUnsaved then begin
                    mniNavFilterForCleaning.Click;
                    JumpTo(wbModulesByLoadOrder.FilteredByFlag(mfTaggedForPluginMode)[0]._File.Header, False);
                    vstNav.ClearSelection;
                    vstNav.FocusedNode := vstNav.FocusedNode.Parent;
                    vstNav.Selected[vstNav.FocusedNode] := True;
                    DoSetActiveRecord(nil);
                    pgMain.ActivePage := tbsMessages;
                    mniNavUndeleteAndDisableReferences.Click;
                    mniNavRemoveIdenticalToMaster.Click;
                  end;
                end;
              end;
              mniNavLOManagersDirtyInfoClick(mniNavLOManagersDirtyInfo);
            end;
          finally
            pnlNavContent.Visible := True;
            vstNav.Invalidate;
            xeQuickClean := False;
            wbProgress('Quick Clean mode finished.');
          end;
          if xeAutoExit then
            tmrShutdown.Enabled := True;
        end;

        if xeAutoGameLink then begin
          pmuMainPopup(Self);
          if mniMainPluggyLinkReference.Visible then begin
            mniMainPluggyLinkReference.Checked := True;
            mniMainPluggyLinkReference.Click;
            wbProgress('Auto GameLink mode activated.');
          end else
            wbProgress('Auto GameLink mode could not be activated.');
        end;
      finally
        Dec(wbShowStartTime);
      end;
    end else begin
      NewFile := nil;
      MasterFile := nil;
      for i := High(Files) downto Low(Files) do
        if Files[i].LoadOrder = LoadOrder then begin
          NewFile := Files[i];
          Break;
        end;
      for i := Low(Files) to High(Files) do
        if Files[i].LoadOrder = LoadOrder then begin
          MasterFile := Files[i];
          Break;
        end;
      if Assigned(NewFile) and Assigned(MasterFile) and not MasterFile.Equals(NewFile) then begin
        if fsIsDeltaPatch in NewFile.FileStates then try

          PerformLongAction('Creating Delta Patch', '', procedure
          var
            i          : Integer;
            Node       : PVirtualNode;
            NodeData   : PNavNodeData;
            MainRecord : IwbMainRecord;
          begin
            HideRemoveMessage := True;
            xeQuickClean := True;

            for i := High(Files) downto Low(Files) do
              Files[i].Hide;

            MasterFile.Show;
            NewFile.Show;

            DoSetActiveRecord(nil);
            pgMain.ActivePage := tbsMessages;

            wbModulesByLoadOrder.ExcludeAll(mfTaggedForPluginMode);
            Include(PwbModuleInfo(MasterFile.ModuleInfo).miFlags, mfTaggedForPluginMode);
            mniNavFilterForOnlyOneClick(Self);

            Node := vstNav.GetFirst;
            while Assigned(Node) do begin
              NodeData := vstNav.GetNodeData(Node);
              if Assigned(NodeData) then
                if Supports(NodeData.Element, IwbMainRecord, MainRecord) then
                  if MainRecord.Signature <> 'TES4' then
                    if not MainRecord.IsDeleted then
                      if NodeData.ConflictThis = ctOnlyOne then
                        if Supports(wbCopyElementToFile(NodeData.Element, NewFile, False, False, '', '', '', '', False), IwbMainRecord, MainRecord) then
                          MainRecord.IsDeleted := True;
              Node := vstNav.GetNext(Node);
            end;

            NewFile.RemoveIdenticalDeltaFast;

            wbModulesByLoadOrder.ExcludeAll(mfTaggedForPluginMode);
            Include(PwbModuleInfo(NewFile.ModuleInfo).miFlags, mfTaggedForPluginMode);
            mniNavFilterForCleaning.Click;
            JumpTo(NewFile.Header, False);
            vstNav.ClearSelection;
            vstNav.FocusedNode := vstNav.FocusedNode.Parent;
            vstNav.Selected[vstNav.FocusedNode] := True;
            DoSetActiveRecord(nil);
            pgMain.ActivePage := tbsMessages;
            mniNavRemoveIdenticalToMaster.Click;

            for i := High(Files) downto Low(Files) do
              Files[i].Show;

            wbModulesByLoadOrder.ExcludeAll(mfTaggedForPluginMode);
            Include(PwbModuleInfo(NewFile.ModuleInfo).miFlags, mfTaggedForPluginMode);
            xeQuickClean := True;
            mniNavFilterForCleaning.Click;
            JumpTo(NewFile.Header, False);
            vstNav.ClearSelection;
            vstNav.FocusedNode := vstNav.FocusedNode.Parent;
            vstNav.Selected[vstNav.FocusedNode] := True;
            DoSetActiveRecord(nil);
            pgMain.ActivePage := tbsMessages;
          end);

        finally
          xeQuickClean := False;
          HideRemoveMessage := False;
        end;
      end;
    end;
  finally
    if wbFirstLoadComplete then begin
      vstNav.PopupMenu := pmuNav;
      bnMainMenu.Enabled := True;
    end;
  end;
end;

procedure TfrmMain.WMUser3(var Message: TMessage);
begin
  if tmrPendingSetActive.Enabled then
    tmrPendingSetActiveTimer(tmrPendingSetActive)
  else
    if PendingResetActiveTree then
      ResetActiveTree;
end;

procedure TfrmMain.WMUser4(var Message: TMessage);
begin
  UpdateActiveFromPluggyLink;
end;

procedure TfrmMain.WMUser5(var Message: TMessage);
begin
  if DelayedExpandView then begin
    DelayedExpandView := False;
    ExpandView;
  end;
end;

procedure TfrmMain.UnLockOutPinned;
begin
  Dec(LockOutPinnedCount);
end;

procedure TfrmMain.UpdateActions;
var
  HintMode: TVTHintMode;
begin
  if DelayedExpandView then begin
    DelayedExpandView := False;
    ExpandView;
  end;
  if Enabled and pnlClient.Enabled then
    NavUpdate(False);
  inherited;

  if GetAsyncKeyState(VK_SHIFT) and $8000 <> 0 then
    HintMode := hmTooltip
  else
    HintMode := hmDefault;

  if HintMode <> vstView.HintMode then begin
    vstView.HintMode := HintMode;
    vstSpreadSheetWeapon.HintMode := HintMode;
    vstSpreadsheetArmor.HintMode := HintMode;
    vstSpreadSheetAmmo.HintMode := HintMode;
  end;
end;

procedure TfrmMain.UpdateActiveFromPluggyLink;
var
  FormID                      : TwbFormID;
  FileID                      : TwbFileID;
  _File                       : IwbFile;
  MainRecord                  : IwbMainRecord;
  Node                        : PVirtualNode;
  i                           : Integer;
begin
  case PluggyLinkState of
    plsReference: begin
      FormID := PluggyFormID;
      if FormID.FileID.FullSlot = $FF then
        FormID := PluggyBaseFormID;
    end;
    plsBase:
      FormID := PluggyBaseFormID;
    plsInventory:
      FormID := PluggyInventoryFormID;
    plsEnchantment:
      FormID := PluggyEnchantmentFormID;
    plsSpell:
      FormID := PluggySpellFormID;
  else
    Exit;
  end;

  if FormID.IsNull then
    Exit;

  FileID := FormID.FileID;
  if wbIsLightSupported or wbPseudoLight or wbPseudoOverlay then begin
    _File := nil;
    for i := Low(Files) to High(Files) do
      if Files[i].LoadOrderFileID = FileID then begin
        _File := Files[i];
        break;
      end;
    if not Assigned(_File) then
      Exit;
  end else begin
    if (FileID.FullSlot < Low(Files)) or (FileID.FullSlot > High(Files)) then
      Exit;
    _File := Files[FileID.FullSlot];
  end;

  FormID.FileID := _File.FileFileID[True];
  MainRecord := _File.RecordByFormID[FormID, True, True];
  if Assigned(MainRecord) then begin
    MainRecord := MainRecord.WinningOverride;

    if MainRecord.Equals(ActiveRecord) then
      Exit;

    Node := FindNodeForElement(MainRecord);
    if not Assigned(Node) then begin
      MainRecord := MainRecord.MasterOrSelf;
      for i := 0 to Pred(MainRecord.OverrideCount) do begin
        Node := FindNodeForElement(MainRecord.Overrides[i]);
        if Assigned(Node) then
          Break;
      end;
    end;
    if Assigned(Node) then begin
      vstNav.ClearSelection;
      vstNav.FocusedNode := Node;
      vstNav.Selected[vstNav.FocusedNode] := True;
      SetActiveRecord(MainRecord);
    end else
      SetActiveRecord(MainRecord);
  end;
end;

procedure TfrmMain.vstNavDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := False;
  if not Assigned(Node) then
    Exit;
  var lNodeData: PNavNodeData := Sender.GetNodeData(Node);
  if not Assigned(lNodeData) then
    Exit;
  if not Supports(lNodeData.Element, IwbMainRecord) then
    Exit;
  Allowed := True;
end;

procedure TfrmMain.vstNavDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := False;
end;

procedure TfrmMain.WndProc(var Message: TMessage);
var
  StyleName: string;
begin
  if Message.Msg = CM_CUSTOMSTYLECHANGED then begin
    wbDarkMode := wbIsDarkMode;
    StyleName := TStyleManager.ActiveStyle.Name;
    if Assigned(Settings) then
      if Settings.ReadString('UI', 'Theme', '') <> StyleName then begin
        Settings.WriteString('UI', 'Theme', StyleName);
        Settings.UpdateFile;
      end;
    UpdateTreeLineColor;
  end;
  inherited;
end;

{ TLoaderThread }

constructor TLoaderThread.Create(var aList: TStringList; aFileStates: TwbFileStates = []);
begin
  ltDataPath := wbDataPath;
  ltMaster := '';
  ltLoadList := aList;
  aList := nil;
  ltStates := aFileStates;
  inherited Create(False);
  FreeOnTerminate := True;
end;

constructor TLoaderThread.Create(aFileName: string; aMaster: string; aLoadOrder: Integer; aFileStates: TwbFileStates = []);
begin
  ltLoadOrderOffset := aLoadOrder;
  ltDataPath := '';
  ltLoadList := TStringList.Create;
  ltLoadList.Add(aFileName);
  ltMaster := aMaster;
  ltStates := aFileStates;
  inherited Create(False);
  FreeOnTerminate := True;
end;

destructor TLoaderThread.Destroy;
begin
  inherited;
  FreeAndNil(ltLoadList);
end;

var
  _LoaderProgressLock      : TRTLCriticalSection;
  _LoaderProgressLastShown : TDateTime;
  _LoaderProgressAction    : string;

procedure LoaderProgressNoAbortCheck(const s: string);
var
  t: string;
  lNow: TDateTime;
begin
  {$IFDEF USE_PARALLEL_BUILD_REFS}
  _LoaderProgressLock.Enter;
  try
  {$ENDIF}
    lNow := Now;
    if _LoaderProgressLastShown = 0 then
      _LoaderProgressLastShown := lNow;

    t := s;
    if (t = '') and (_LoaderProgressAction <> '') and ((lNow - _LoaderProgressLastShown) > 1/24/60/6 {10 seconds} ) then
      t := 'still ' + _LoaderProgressAction + '...';

    if t <> '' then begin
      frmMain.PostAddMessage('[' + wbFormatElapsedTime( lNow - wbStartTime) + '] Background Loader: ' + t);
      _LoaderProgressLastShown := lNow;
    end;
  {$IFDEF USE_PARALLEL_BUILD_REFS}
  finally
    _LoaderProgressLock.Leave;
  end;
  {$ENDIF}
end;

procedure LoaderProgress(const s: string);
begin
  LoaderProgressNoAbortCheck(s);
  if wbForceTerminate then
    Abort;
end;

procedure TLoaderThread.Execute;
var
  dummy                       : Integer;
  bsaCount                    : Integer;
  _File                       : IwbFile;
  s,t                         : string;
  b                           : TBytes;
//  F                           : TSearchRec;
  StartTime                   : TDateTime;
  {$IFNDEF USE_PARALLEL_BUILD_REFS}
  OnlyLoad: Boolean;
  {$ENDIF}
begin
  StartTime := Now;
  wbStartTime := StartTime;
  LoaderProgress('starting...');
  try
    frmMain.LoaderStarted := True;
    _wbProgressCallback := LoaderProgress;
    wbCurrentTick := GetTickCount64;
    try
      {if ltLoadOrderOffset + ltLoadList.Count >= 255 then begin
        LoaderProgress('Too many plugins selected. Adding '+IntToStr(ltLoadList.Count)+' files would exceed the maximum index of 254');
        wbLoaderError := True;
      end else} begin
        if not Assigned(wbContainerHandler) then begin
          wbContainerHandler := wbCreateContainerHandler;

          _LoaderProgressLastShown := Now;
          _LoaderProgressAction := 'loading resources';

          // Load archives defined in the game ini
          var lFoundArchives := TStringList.Create;
          try
            var lNotFoundArchives := TStringList.Create;
            try
              bsaCount := 0;
              if FileExists(wbTheGameIniFileName) then begin
                if FileExists(wbCustomIniFileName) then
                  bsaCount := FindBSAs(wbTheGameIniFileName, wbCustomIniFileName, ltDataPath, lFoundArchives, lNotFoundArchives)
                else
                  bsaCount := FindBSAs(wbTheGameIniFileName, ltDataPath, lFoundArchives, lNotFoundArchives);
              end;

              if (bsaCount > 0) then begin
                for var lFoundIdx := 0 to Pred(lFoundArchives.Count) do
                  if wbLoadBSAs then begin
                    LoaderProgress('[' + lFoundArchives[lFoundIdx] + '] Loading Resources.');
                    if wbArchiveExtension = '.bsa' then
                      wbContainerHandler.AddBSA(MakeDataFileName(lFoundArchives[lFoundIdx], ltDataPath))
                    else if wbArchiveExtension = '.ba2' then begin
                      var lContainer := wbContainerHandler.AddBA2(MakeDataFileName(lFoundArchives[lFoundIdx], ltDataPath));
                      var lBA2File: IwbBA2File;
                      if Supports(lContainer, IwbBA2File, lBA2File) then
                        LoaderProgress('[' + lFoundArchives[lFoundIdx] + '] Version: ' + lBA2File.Version.ToString);
                    end
                  end else
                    LoaderProgress('[' + lFoundArchives[lFoundIdx] + '] Skipped.');
                for var lNotFoundIdx := 0 to Pred(lNotFoundArchives.Count) do
                  LoaderProgress('Warning: <Can''t find ' + lNotFoundArchives[lNotFoundIdx] + '>')
              end;
            finally
              FreeAndNil(lNotFoundArchives);
            end;
          finally
            FreeAndNil(lFoundArchives);
          end;

          // Load archives associated with plugins
          for var lLoadListIdx := 0 to Pred(ltLoadList.Count) do begin
            var lFoundPluginArchives := TStringList.Create;
            try
              var lNotFoundPluginArchives := TStringList.Create;
              try
                // all games except old Skyrim load BSA files with partial matching, Skyrim requires exact names match
                // and can use a private ini to specify the bsa to use.
                if HasBSAs(ChangeFileExt(ltLoadList[lLoadListIdx], ''), ltDataPath,
                    wbGameMode in [gmTES5, gmEnderal], wbIsSkyrim, lFoundPluginArchives, lNotFoundPluginArchives)>0 then begin
                      for var lFoundPluginIdx := 0 to Pred(lFoundPluginArchives.Count) do
                        if wbLoadBSAs then begin
                          LoaderProgress('[' + lFoundPluginArchives[lFoundPluginIdx] + '] Loading Resources.');
                          try
                            if wbArchiveExtension = '.bsa' then
                              wbContainerHandler.AddBSA(MakeDataFileName(lFoundPluginArchives[lFoundPluginIdx], ltDataPath))
                            else if wbArchiveExtension = '.ba2' then begin
                              var lContainer := wbContainerHandler.AddBA2(MakeDataFileName(lFoundPluginArchives[lFoundPluginIdx], ltDataPath));
                              var lBA2File: IwbBA2File;
                              if Supports(lContainer, IwbBA2File, lBA2File) then
                                LoaderProgress('[' + lFoundPluginArchives[lFoundPluginIdx] + '] Version: ' + lBA2File.Version.ToString);
                            end;
                          except
                            on E: Exception do
                              LoaderProgress(Format('[%s] Could not be loaded. <Error: [%s] %s>', [lFoundPluginArchives[lFoundPluginIdx], E.ClassName, E.Message]));
                          end;
                        end else
                          LoaderProgress('[' + lFoundPluginArchives[lFoundPluginIdx] + '] Skipped.');
                      for var lNotFoundPluginIdx := 0 to Pred(lNotFoundPluginArchives.Count) do
                        LoaderProgress('Warning: <Can''t find ' + lNotFoundPluginArchives[lNotFoundPluginIdx] + '>');
                end;
              finally
                FreeAndNil(lNotFoundPluginArchives);
              end;
            finally
              FreeAndNil(lFoundPluginArchives);
            end;

          end;
          LoaderProgress('[' + ltDataPath + '] Setting Resource Path.');
          wbContainerHandler.AddFolder(ltDataPath);
        end;

        if wbDecodeTextureHashes then begin
          LoaderProgress('Start building resources cache...');
          wbContainerHandler.EnsureCache;
          LoaderProgress('...resources cache finished building');
        end;

        wbResourcesLoaded;

        _LoaderProgressAction := 'loading modules';

        for var
        lLoadListIdx := 0 to Pred(ltLoadList.Count) do begin

          if wbGameMode = gmTES3 then
            if (lLoadListIdx = 0) and (ltMaster = '') and (ltLoadOrderOffset = 0) and (ltLoadList.Count > 0) and SameText(ltLoadList[0], wbGameMasterEsm) then begin
              b := TwbHardcodedContainer.GetHardCodedDat;
              if Length(b) > 0 then begin
                t := wbGameExeName;
                LoaderProgress('loading "' + t + '"...');
                _File := wbFile(t, 0, '', [fsIsHardcoded], b);
                SetLength(ltFiles, Succ(Length(ltFiles)));
                ltFiles[High(ltFiles)] := _File;
                frmMain.SendAddFile(_File);
                if wbForceTerminate then
                  Exit;
                Inc(ltLoadOrderOffset);
              end else
                Assert(False, 'Can''t find Hardcoded module.')
            end;

          LoaderProgress('loading "' + ltLoadList[lLoadListIdx] + '"...');
          if FileExists(ltLoadList[lLoadListIdx]) then
            s := ltLoadList[lLoadListIdx]
          else begin
            s := ltDataPath + ltLoadList[lLoadListIdx];
            if not wbIsModule(ltLoadList[lLoadListIdx]) then
              if wbToolSource in [tsSaves] then
                if not FileExists(s) then // Assume its a save in the save path
                  s := wbSavePath + ltLoadList[lLoadListIdx];
          end;
          _File := wbFile(s, lLoadListIdx + ltLoadOrderOffset, ltMaster, ltStates);
          SetLength(ltFiles, Succ(Length(ltFiles)));
          ltFiles[High(ltFiles)] := _File;
          frmMain.SendAddFile(_File);

          if wbForceTerminate then
            Exit;

          if (lLoadListIdx = 0) and (ltMaster = '') and (ltLoadOrderOffset = 0) and (ltLoadList.Count > 0) and SameText(ltLoadList[0], wbGameMasterEsm) then begin
            b := TwbHardcodedContainer.GetHardCodedDat;
            if Length(b) > 0 then begin
              t := wbGameExeName;
              LoaderProgress('loading "' + t + '"...');
              _File := wbFile(t, 0, ltDataPath + ltLoadList[lLoadListIdx], [fsIsHardcoded], b);
              SetLength(ltFiles, Succ(Length(ltFiles)));
              ltFiles[High(ltFiles)] := _File;
              frmMain.SendAddFile(_File);
              if wbForceTerminate then
                Exit;

              t := wbGameName + '.Hardcoded.esp';
              s := wbProgramPath + t;
              if FileExists(s) then
                DeleteFile(s);
            end;
          end;
        end;

        if wbBuildRefs then begin
          _LoaderProgressAction := 'building references';
          {$IFDEF USE_PARALLEL_BUILD_REFS}
          wbBuildingRefsParallel := True;
          try
            TParallel.&For(Low(ltFiles), High(ltFiles), procedure(lLoadListIdx: Integer)
            var
              OnlyLoad : Boolean;
              _File    : IwbFile;
            begin
              wbStartTime := StartTime;
              _wbProgressCallback := LoaderProgress;
              wbCurrentTick := GetTickCount64;
              try
                {$ELSE}
                for {$IFNDEF USE_PARALLEL_BUILD_REFS}var {$ENDIF}lLoadListIdx := Low(ltFiles) to High(ltFiles) do
                {$ENDIF}
                begin
                  _File := ltFiles[lLoadListIdx];
                  if (fsIsHardcoded in _File.FileStates) or not _File.IsNotPlugin then begin
                    try
                      OnlyLoad := False;
                      if (wbGameMode = gmSF1) and
                         (SizeOf(Pointer) = 4) and
                         (fsIsGameMaster in _File.FileStates)
                      then
                        OnlyLoad := True;
                      if not (OnlyLoad and (wbDontCache or wbDontCacheLoad)) then begin
                        if OnlyLoad then
                          s := 'loading'
                        else begin
                          s := 'building';
                          if not (wbDontCache or wbDontCacheLoad) then
                            s := 'loading or ' + s;
                        end;
                        LoaderProgress('[' + _File.FileName + '] Start ' + s + ' reference info.');
                        case _File.BuildOrLoadRef(OnlyLoad) of
                          blrBuilt:
                            s := 'Done building reference info.';
                          blrBuiltAndSaved:
                            s := 'Done building and saving reference info.';
                          blrLoaded:
                            s := 'Done loading reference info.';
                        else {blrNone:}
                          if OnlyLoad then
                            s := 'No cached reference info available.'
                          else
                            s := 'No reference info built or loaded.';
                        end;
                        LoaderProgress('[' + _File.FileName + '] ' + s);
                      end;
                    except
                      on E: EAbort do
                        wbForceTerminate := True;
                      on E: Exception do begin
                        LoaderProgressNoAbortCheck('Fatal: <' + e.ClassName + ': ' + e.Message + '>');
                        wbLoaderError := True;
                      end;
                    end;
                    if wbLoaderError or wbForceTerminate then
                      Exit;
                  end;
                end;
                  {$IFDEF USE_PARALLEL_BUILD_REFS}
              finally
                _wbProgressCallback := nil;
                wbCurrentTick := 0;
              end;
            end);
          finally
            wbBuildingRefsParallel := False;
          end;
          {$ENDIF}
        end;
      end;

    except
      on E: EAbort do
        wbForceTerminate := True;
      on E: Exception do begin
        LoaderProgressNoAbortCheck('Fatal: <' + e.ClassName + ': ' + e.Message + '>');
        wbLoaderError := True;
      end;
    end;
  finally
    wbCurrentTick := 0;
    _LoaderProgressAction := '';
    if ltMaster = '' then
      ltLoadOrderOffset := -1;
    frmMain.SendLoaderDone(wbStartTime, ltLoadOrderOffset);
    LoaderProgress('finished');
    _wbProgressCallback := nil;
  end;
  {
    CELLList.Sorted := False;
    for i := 0 to Pred(CELLList.Count) do begin
      CELLList[i] := CELLList[i] + ' ('+IntToStr(Integer(CELLList.Objects[i]))+')';
    end;
    CELLList.SaveToFile('scptlist.txt');
  }
end;

{ TViewNodeData }

procedure TViewNodeData.UpdateRefs;
begin
  if Assigned(Element) and (Element.ElementType = etMainRecord) then
    (Element as IwbMainRecord).UpdateRefs;
end;

{ TTabHistoryEntry }

constructor TTabHistoryEntry.Create(aTabSheet: TTabSheet);
begin
  tiTabSheet := aTabSheet;
  inherited Create;
end;

procedure TTabHistoryEntry.Show;
begin
  frmMain.pgMain.ActivePage := tiTabSheet;
  frmMain.pgMainChange(frmMain.pgMain);
end;

{ TCompareRecordsHistoryEntry }

constructor TCompareRecordsHistoryEntry.Create(const aCompareRecords: TDynMainRecords);
begin
  crRecords := aCompareRecords;
  inherited Create;
end;

function TCompareRecordsHistoryEntry.Remove(const aMainRecord: IwbMainRecord): Boolean;
var
  i, j                        : Integer;
begin
  j := 0;
  SetLength(crRecords, Length(crRecords));
  for i := Low(crRecords) to High(crRecords) do
    if not crRecords[i].Equals(aMainRecord) then begin
      if i <> j then
        crRecords[j] := crRecords[i];
      Inc(j);
    end;
  if j <> Length(crRecords) then begin
    SetLength(crRecords, j);
    crRecordsChanged := True;
  end;
  Result := Length(crRecords) < 2;
end;

procedure TCompareRecordsHistoryEntry.Show;
var
  i                           : Integer;
begin
  with frmMain do begin
    LockOutPinned;
    try
      vstNav.ClearSelection;
      for i := Low(crRecords) to High(crRecords) do begin
        vstNav.FocusedNode := FindNodeForElement(crRecords[i]);
        vstNav.Selected[vstNav.FocusedNode] := True;
      end;
      DoSetActiveRecord(crRecords);
      pgMain.ActivePage := tbsView;
      pgMainChange(pgMain);
    finally
      UnLockOutPinned;
    end;
  end;
end;

{ THistoryEntry }

function THistoryEntry.Remove(const aMainRecord: IwbMainRecord): Boolean;
begin
  Result := False;
end;

{ TCompareRecordsPosHistoryEntry }

constructor TCompareRecordsPosHistoryEntry.Create(const aCompareRecords: TDynMainRecords);
var
  i                           : Integer;
begin
  inherited;
  with frmMain, vstView, Header, Columns do begin
    crpOffsetXY := OffsetXY;
    crpFocusNode := FocusedNode;
    crpFocusColumn := FocusedColumn;
    if Assigned(crpFocusNode) then
      crpFocusRect := GetDisplayRect(crpFocusNode, crpFocusColumn, False);
    SetLength(crpColumnWidths, Count);
    for i := 0 to Pred(Count) do
      crpColumnWidths[i] := Items[i].Width;
  end;
end;

procedure TCompareRecordsPosHistoryEntry.Show;
var
  i                           : Integer;
  Node                        : PVirtualNode;
begin
  with frmMain, vstView, Header, Columns do begin
    LockOutPinned;
    try
      inherited;

      if not crRecordsChanged then begin

        if Count <> Length(crpColumnWidths) then
          Exit;

        for i := 0 to Pred(Count) do
          Items[i].Width := crpColumnWidths[i];

        UpdateScrollBars(False);

        OffsetXY := crpOffsetXY;

        if Assigned(crpFocusNode) then begin
          Node := vstView.GetNodeAt(crpFocusRect.Left + 2, crpFocusRect.Top + 2);
          if Assigned(Node) then
            FocusedNode := Node;
        end;
        FocusedColumn := crpFocusColumn;

        OffsetXY := crpOffsetXY;
      end;
    finally
      UnLockOutPinned;
    end;
  end;
end;

{ TMainRecordPosHistoryEntry }

constructor TMainRecordPosHistoryEntry.Create(const aMainRecord: IwbMainRecord);
var
  i                           : Integer;
begin
  inherited;
  with frmMain, vstView, Header, Columns do begin
    mrpOffsetXY := OffsetXY;
    mrpFocusNode := FocusedNode;
    mrpFocusColumn := FocusedColumn;
    if Assigned(mrpFocusNode) then
      mrpFocusRect := GetDisplayRect(mrpFocusNode, mrpFocusColumn, False);
    SetLength(mrpColumnWidths, Count);
    for i := 0 to Pred(Count) do
      mrpColumnWidths[i] := Items[i].Width;
  end;
end;

procedure TMainRecordPosHistoryEntry.Show;
var
  i                           : Integer;
  Node                        : PVirtualNode;
begin
  with frmMain, vstView, Header, Columns do begin
    LockOutPinned;
    try
      inherited;

      if Count <> Length(mrpColumnWidths) then
        Exit;

      for i := 0 to Pred(Count) do
        Items[i].Width := mrpColumnWidths[i];

      UpdateScrollBars(False);

      OffsetXY := mrpOffsetXY;

      if Assigned(mrpFocusNode) then begin
        Node := vstView.GetNodeAt(mrpFocusRect.Left + 2, mrpFocusRect.Top + 2);
        if Assigned(Node) then
          FocusedNode := Node;
      end;
      FocusedColumn := mrpFocusColumn;

      OffsetXY := mrpOffsetXY;
    finally
      UnLockOutPinned;
    end;
  end;
end;

{ TMainRecordHistoryEntry }

constructor TMainRecordHistoryEntry.Create(const aMainRecord: IwbMainRecord);
begin
  mrRecord := aMainRecord;
  inherited Create;
end;

function TMainRecordHistoryEntry.GetTabSheet: TTabSheet;
begin
  Result := frmMain.tbsView;
end;

function TMainRecordHistoryEntry.Remove(const aMainRecord: IwbMainRecord): Boolean;
begin
  Result := mrRecord.Equals(aMainRecord);
end;

procedure TMainRecordHistoryEntry.Show;
begin
  with frmMain do begin
    LockOutPinned;
    try
      vstNav.ClearSelection;
      vstNav.FocusedNode := FindNodeForElement(mrRecord);
      vstNav.Selected[vstNav.FocusedNode] := True;
      DoSetActiveRecord(mrRecord);
      pgMain.ActivePage := GetTabSheet;
      pgMainChange(pgMain);
    finally
      UnLockOutPinned;
    end;
  end;
end;

{ TMainRecordRefByHistoryEntry }

function TMainRecordRefByHistoryEntry.GetTabSheet: TTabSheet;
begin
  Result := frmMain.tbsReferencedBy;
end;

{ TPluggyLinkThread }

procedure TPluggyLinkThread.ChangeDetected;
var
  s                                                : string;
  FormID, BaseFormID, InventoryFormID, EnchantmentFormID, SpellFormID : TwbFormID;
begin
  with TBufferedFileStream.Create(plFolder + 'Pluggy'+wbAppName+'ViewWorld.csv', fmOpenRead or fmShareDenyNone) do try
    Position := Size - 2024;
    SetLength(s, 64 * 1024);
    SetLength(s, Read(s[1], 64 * 1024));
  finally
    Free;
  end;
  with TStringList.Create do try
    Text := s;
    if Count < 2 then
      Exit;
    CommaText := Strings[Pred(Count)];
    if Count < 2 then
      Exit;
    FormID := TwbFormID.FromStr(Strings[0]);
    BaseFormID := TwbFormID.FromStr(Strings[1]);
  finally
    Free;
  end;
  with TBufferedFileStream.Create(plFolder + 'Pluggy'+wbAppName+'ViewInventory.csv', fmOpenRead or fmShareDenyNone) do try
    Position := Size - 2024;
    SetLength(s, 64 * 1024);
    SetLength(s, Read(s[1], 64 * 1024));
  finally
    Free;
  end;
  with TStringList.Create do try
    Text := s;
    if Count < 2 then
      Exit;
    CommaText := Strings[Pred(Count)];
    if Count < 2 then
      Exit;
    InventoryFormID := TwbFormID.FromStr(Strings[0]);
    EnchantmentFormID := TwbFormID.FromStr(Strings[1]);
  finally
    Free;
  end;
  with TBufferedFileStream.Create(plFolder + 'Pluggy'+wbAppName+'ViewSpells.csv', fmOpenRead or fmShareDenyNone) do try
    Position := Size - 2024;
    SetLength(s, 64 * 1024);
    SetLength(s, Read(s[1], 64 * 1024));
  finally
    Free;
  end;
  with TStringList.Create do try
    Text := s;
    if Count < 2 then
      Exit;
    CommaText := Strings[Pred(Count)];
    if Count < 1 then
      Exit;
    SpellFormID := TwbFormID.FromStr(Strings[0]);
  finally
    Free;
  end;


  if (FormID <> plLastFormID) or
     (BaseFormID <> plLastBaseFormID) or
     (InventoryFormID <> plLastBaseFormID) or
     (EnchantmentFormID <> plLastBaseFormID) or
     (SpellFormID <> plLastBaseFormID) then begin

    plLastFormID := FormID;
    plLastBaseFormID := BaseFormID;
    plLastInventoryFormID := InventoryFormID;
    plLastEnchantmentFormID := EnchantmentFormID;
    plLastSpellFormID := SpellFormID;

    frmMain.PostPluggyChange(FormID, BaseFormID, InventoryFormID, EnchantmentFormID, SpellFormID);
  end;
end;

procedure TPluggyLinkThread.Execute;
var
  WaitHandle : THandle;
begin
  plFolder := wbMyGamesTheGamePath + 'Pluggy\User Files\';
  frmMain.PostAddMessage('[PluggyLink] Starting for: ' + plFolder);
  ChangeDetected;
  try
    WaitHandle := FindFirstChangeNotification(
      PChar(plFolder),
      False,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_LAST_WRITE
    );
    if WaitHandle = INVALID_HANDLE_VALUE then
      RaiseLastOSError;
    try
      repeat
        case WaitForSingleObject(WaitHandle, 1000) of
          WAIT_OBJECT_0: begin
            ChangeDetected;
            if not FindNextChangeNotification(WaitHandle) then
              RaiseLastOSError;
          end;
          WAIT_FAILED:
            RaiseLastOSError;
        end;
      until Terminated or wbForceTerminate;
    finally
      if not FindCloseChangeNotification(WaitHandle) then
        RaiseLastOSError;
    end;
  except
    on E: Exception do
      frmMain.PostAddMessage('[PluggyLink] Error: ' + E.Message);
  end;
  frmMain.PostAddMessage('[PluggyLink] terminated');
end;


{ TwbComboEditLink }

procedure TwbComboEditLink.SetBounds(R: TRect);
var
  H : Integer;
begin  // Let's show from 1 to 32 lines to pick from
  H := PickList.Count;
  if H > 32 then
    H := 32
   else if H < 1 then
     H := 1;
  H := H * TComboBox(FEdit).Font.Height ;
  R.Bottom := R.Bottom + Abs(H);

  inherited;
end;

type
  TWinControlProtectedHacker = class(TWinControl);
  TMainWndProc = procedure(var Message: TMessage) of object;

var
  CodePointer_TWinControl_MainWndProc : TMainWndProc;
  Trampoline_TWinControl_MainWndProc : procedure(Self: TWinControlProtectedHacker; var Message: TMessage);

procedure Detour_TWinControl_MainWndProc(Self: TWinControlProtectedHacker; var Message: TMessage);
begin
  case Message.Msg of
    WM_PAINT: begin
      LockProcessMessages;
      try
        Trampoline_TWinControl_MainWndProc(Self, Message);
      finally
        UnLockProcessMessages;
      end;
    end;
  else
    Trampoline_TWinControl_MainWndProc(Self, Message);
  end;
end;


{ TGameLinkThread }

procedure TGameLinkThread.ChangeDetected;
var
  Stream : TBufferedFileStream;
  sl     : TStringList;

  SelectedRefID: TwbFormID;
  SelectedBaseID: TwbFormID;
begin
  Stream := TBufferedFileStream.Create(glFolder + 'xEditLink.ini', fmOpenRead or fmShareDenyNone);
  try
    sl := TStringList.Create;
    try
      sl.LoadFromStream(Stream);
      with TMemIniFile.Create('') do try
        SetStrings(sl);
        SelectedRefID := TwbFormID.FromStrDef(ReadString('Console', 'selectedRefID', '00000000'));
        SelectedBaseID := TwbFormID.FromStrDef(ReadString('Console', 'selectedBaseID', '00000000'));
      finally
        Free;
      end;
    finally
      sl.Free;
    end;
  finally
    Stream.Free;
  end;

  if not SelectedRefID.IsNull then
    if (SelectedRefID <> glLastFormID) or
       (SelectedBaseID <> glLastBaseFormID) then begin

      glLastFormID := SelectedRefID;
      glLastBaseFormID := SelectedBaseID;

      frmMain.PostPluggyChange(SelectedRefID, SelectedBaseID, TwbFormID.Null, TwbFormID.Null, TwbFormID.Null);
    end;
end;

procedure TGameLinkThread.Execute;
var
  WaitHandle : THandle;
begin
  glFolder := wbDataPath + 'xEdit\';
  frmMain.PostAddMessage('[GameLink] Starting for: ' + glFolder);
  ChangeDetected;
  try
    WaitHandle := FindFirstChangeNotification(
      PChar(glFolder),
      False,
      FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_LAST_WRITE
    );
    if WaitHandle = INVALID_HANDLE_VALUE then
      RaiseLastOSError;
    try
      repeat
        case WaitForSingleObject(WaitHandle, 1000) of
          WAIT_OBJECT_0: begin
            ChangeDetected;
            if not FindNextChangeNotification(WaitHandle) then
              RaiseLastOSError;
          end;
          WAIT_FAILED:
            RaiseLastOSError;
        end;
      until Terminated or wbForceTerminate;
    finally
      if not FindCloseChangeNotification(WaitHandle) then
        RaiseLastOSError;
    end;
  except
    on E: Exception do
      frmMain.PostAddMessage('[GameLink] Error: ' + E.Message);
  end;
  frmMain.PostAddMessage('[GameLink] terminated');

end;

{ TMainRecordElementHistoryEntry }

constructor TMainRecordElementHistoryEntry.Create(const aMainRecord: IwbMainRecord; const aElement: IwbElement);
begin
  inherited Create(aMainRecord);
  mreElement := aElement;
end;

procedure TMainRecordElementHistoryEntry.Show;
begin
  with frmMain do begin
    LockOutPinned;
    try
      ViewFocusedElement := mreElement;
      EditFocusedViewElement := False;
      NodeForViewFocusedElement := nil;
      ColumnForViewFocusedElement := NoColumn;

      inherited;

      if not Assigned(NodeForViewFocusedElement) and Assigned(ViewFocusedElement) and ViewFocusedElement.Equals(mreElement) then
        ResetActiveTree;

      ViewFocusedElement := nil;
      EditFocusedViewElement := False;
      if Assigned(NodeForViewFocusedElement) then begin
        vstViewFocusedNode := NodeForViewFocusedElement;
        if ColumnForViewFocusedElement <> NoColumn then
          vstView.FocusedColumn := ColumnForViewFocusedElement;
        vstView.TopNode := vstViewFocusedNode;
        vstView.ScrollIntoView(vstView.FocusedColumn, True, vstViewFocusedNode);
      end;
    finally
      UnLockOutPinned;
    end;
  end;
end;

{ TwbCheckGitHubReleaseThread }

procedure TwbCheckGitHubReleaseThread.Execute;
var
  J: TJsonBaseObject;
  A: TJsonArray;
  i: Integer;
  s: string;

  v, vmax: TwbVersion;
begin
  vmax := '';
  try
    J := TJsonBaseObject.ParseUtf8(GetUrlContent('https://api.github.com/repos/TES5Edit/TES5Edit/releases'));
    try
      if J is TJsonArray then begin
        A := J as TJsonArray;
        for i := 0 to Pred(A.Count) do try
          s := A.O[i].S['tag_name'];
          if s.StartsWith('xedit-') then try
            v := Copy(s, Succ(Length('xedit-')), High(Integer));
            if v > vmax then
              vmax := v;
          except
          end;
        except
        end;
      end;
    finally
      J.Free;
    end;
  except end;
  Synchronize(procedure begin
    if Assigned(frmMain) then begin
      frmMain.GitHubVersion := vmax;
      frmMain.ShowGitHubHint := Now + (1/24/60/6); // 10 seconds
    end;
  end);
end;

{ TwbCheckNexusModsReleaseThread }

procedure TwbCheckNexusModsReleaseThread.Execute;
var
  i: Integer;
  s: string;
  vmax: TwbVersion;
const
  csCheckFor = 'property="twitter:label1" content="version"';
  csExtractAfter = 'property="twitter:data1" content="';
begin
  if wbNexusModsUrl = '' then
    Exit;

  vmax := '';
  try
    s := GetUrlContent(wbNexusModsUrl);
    s := s.ToLowerInvariant;
    if s.Contains(csCheckFor) then begin
      i := Pos(csExtractAfter, s);
      if i > 0 then begin
        Delete(s, 1, i + Pred(Length(csExtractAfter)));
        i := Pos('"', s);
        if i > 0 then begin
          Delete(s, i, High(Integer));
          vmax := s;
        end;
      end;
    end;
  except end;
  Synchronize(procedure begin
    if Assigned(frmMain) then begin
      frmMain.NexusModsVersion := vmax;
      frmMain.ShowNexusModsHint := Now + (1/24/60/6); // 10 seconds
    end;
  end);
end;

type
  TDoDrawIcon = function (DC: HDC; Details: TThemedElementDetails; const R: TRect; himl: HIMAGELIST; Index: Integer; DPI: Integer = 0): Boolean of object;
  TUxThemeStyleHack = class(TUxThemeStyle);
  TCustomStyleHack = class(TCustomStyle);

var
  Trampoline_TUxThemeStyle_DoDrawIcon : function(Self: TUxThemeStyleHack; DC: HDC; Details: TThemedElementDetails; const R: TRect; himl: HIMAGELIST; Index: Integer; DPI: Integer = 0): Boolean;
  CodePointer_TUxThemeStyle_DoDrawIcon : TDoDrawIcon;

function Detour_TUxThemeStyle_DoDrawIcon(Self: TUxThemeStyleHack; DC: HDC;
  Details: TThemedElementDetails; const R: TRect; himl: HIMAGELIST;
  Index: Integer; DPI: Integer = 0): Boolean;
var
  Icon: HICON;
  IW, IH: Integer;
begin
  if Details.Element = teButton then begin
    if not ImageList_GetIconSize(himl, IW, IH) then
      Exit(False);
    Icon := ImageList_GetIcon(himl, Index, LR_DEFAULTCOLOR);
    Result := DrawIconEx(DC, R.Left, R.Top, Icon, IW, IH, 0, 0, DI_NORMAL);
    DestroyIcon(Icon);
  end else
    Result := Trampoline_TUxThemeStyle_DoDrawIcon(Self, DC, Details, R, himl, Index, DPI)
end;

initialization
  wbLockProcessMessages := LockProcessMessages;
  wbUnLockProcessMessages := UnLockProcessMessages;

  {$IFDEF USE_PARALLEL_BUILD_REFS}
  _LoaderProgressLock.Initialize;
  {$ENDIF}

  with TWinControlProtectedHacker(TWinControl.Create(nil)) do try
    CodePointer_TWinControl_MainWndProc := MainWndProc;
  finally
    Free;
  end;

  with TUxThemeStyleHack(TUxThemeStyle.Create) do try
    CodePointer_TUxThemeStyle_DoDrawIcon := DoDrawIcon;
  finally
    Free;
  end;

  var Handle := BeginTransaction;
  try

    @Trampoline_TWinControl_MainWndProc := InterceptCreate(@CodePointer_TWinControl_MainWndProc, @Detour_TWinControl_MainWndProc);
    @Trampoline_TUxThemeStyle_DoDrawIcon := InterceptCreate(@CodePointer_TUxThemeStyle_DoDrawIcon, @Detour_TUxThemeStyle_DoDrawIcon);

  finally
    EndTransaction(Handle);
  end;


finalization
  {$IFDEF USE_PARALLEL_BUILD_REFS}
  _LoaderProgressLock.Free;
  {$ENDIF}

  var Handle := BeginTransaction;
  try

    InterceptRemove(@Trampoline_TWinControl_MainWndProc);
    InterceptRemove(@Trampoline_TUxThemeStyle_DoDrawIcon);

  finally
    EndTransaction(Handle);
  end;
end.


