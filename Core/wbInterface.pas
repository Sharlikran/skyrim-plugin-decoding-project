
{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License,
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbInterface;

{$I wbDefines.inc}

interface

uses
  System.Types,
  System.Classes,
  System.SysUtils,
  System.UITypes,
  VCL.Graphics,
  System.Generics.Defaults,
  System.Generics.Collections,
  System.RegularExpressions,
  wbStreams;

type
  TwbNothing = wbStreams.TwbNothing;

const
  wbNothing: TwbNothing = ();
  wbIgnoreStringValue = '<<<Ignore>>>';

type
  TwbVersion = record
    Major   : Integer;
    Minor   : Integer;
    Release : Integer;
    Build   : string;
    Title   : string;

    class operator Equal(const A, B: TwbVersion): Boolean; static;
    class operator NotEqual(const A, B: TwbVersion): Boolean; static;
    class operator GreaterThan(const A, B: TwbVersion): Boolean; static;
    class operator GreaterThanOrEqual(const A, B: TwbVersion): Boolean; static;
    class operator LessThan(const A, B: TwbVersion): Boolean; static;
    class operator LessThanOrEqual(const A, B: TwbVersion): Boolean; static;

    class operator Implicit(const aVersion: TwbVersion): string; static;
    class operator Implicit(const s: string): TwbVersion; static;

    function ToString: string;
    function ToCardinal: Cardinal;
  end;

var
  VersionString : TwbVersion = (
    Major   : 4;
    Minor   : 1;
    Release : 5;
    Build   : 'm';
    Title   : '';
  );

const
  wbWhatsNewVersion : Integer = 04010511;
  wbDeveloperMessageVersion : Integer = 04010507;
  wbDevCRC32App : Cardinal = $FFFFFFE4;

  clOrange       = $004080FF;
  wbFloatDigits  = 6;
  wbRefCacheExt  = '.refcache';

var
  CRLF: string = #13#10;

const
  csDotExe   = '.exe';

  csDotGhost = '.ghost';
  csDotEsm   = '.esm';
  csDotEsl   = '.esl';
  csDotEsp   = '.esp';
  csDotEsu   = '.esu';

  csDotFos   = '.fos';
  csDotEss   = '.ess';

var
  wbLightName: string = 'Light';

type
  TwbProgressCallback = procedure(const aStatus: string);

  TwbPointerArray = array [0..Pred(High(Integer) div SizeOf(Pointer))] of Pointer;
  PwbPointerArray = ^TwbPointerArray;       {General array of pointer}

  TwbCardinalArray = array [0..Pred(High(Integer) div SizeOf(Cardinal))] of Cardinal;
  PwbCardinalArray = ^TwbCardinalArray;     {General array of Cardinal}

  TwbUInt64Array = array [0..Pred(High(Integer) div SizeOf(UInt64))] of UInt64;
  PwbUInt64Array = ^TwbUInt64Array;         {General array of UInt64}

  TwbTwoPtr = record
    A, B: Pointer;
  end;
  PwbTwoPtr = ^TwbTwoPtr;

  TwbTwoPtrArray = array [0..Pred(High(Integer) div SizeOf(TwbTwoPtr))] of TwbTwoPtr;
  PwbTwoPtrArray = ^TwbTwoPtrArray;         {General array of TwbTwoPtr}

  TwbStringArray = TArray<string>;
  PwbStringArray = ^TwbStringArray;

threadvar
  _wbProgressCallback                : TwbProgressCallback;
  wbCurrentTick                      : UInt64;
  wbCurrentAction                    : string;
  wbCurrentProgress                  : string;
  wbStartTime                        : TDateTime;
  wbLocalStartTime                   : TDateTime;
  wbShowStartTime                    : Integer;
  wbShowCaption                      : Integer;
  wbHideStartTime                    : Integer;
  wbLastMessageAt                    : UInt64;
  wbMaxMessageInterval               : UInt64;

var
  wbForceTerminate                   : Boolean;

var
  wbDisplayLoadOrderFormID           : Boolean    = False;
  wbPrettyFormID                     : Boolean    = False;
  wbSimpleRecords                    : Boolean    = True;
  wbDecodeTextureHashes              : Boolean    = True;
  wbFixupPGRD                        : Boolean    = False;
  wbIKnowWhatImDoing                 : Boolean    = False;
  wbHideUnused                       : Boolean    = True;
  wbHideIgnored                      : Boolean    = True;
  wbHideNeverShow                    : Boolean    = True;
  wbShowFormVersion                  : Boolean    = False;
  wbShowFlagEnumValue                : Boolean    = False;
  wbShowGroupRecordCount             : Boolean    = False;
  wbShowFileFlags                    : Boolean    = False;
  wbDisplayShorterNames              : Boolean    = False;
  wbSortSubRecords                   : Boolean    = False;
  wbSortFLST                         : Boolean    = False;
  wbCanSortINFO                      : Boolean    = False;
  wbSortINFO                         : Boolean    = False;
  wbFillPNAM                         : Boolean    = False;
  wbFillINOM                         : Boolean    = True;
  wbFillINOA                         : Boolean    = True;
  wbRemoveOffsetData                 : Boolean    = True;
  wbEditAllowed                      : Boolean    = False;
  wbFlagsAsArray                     : Boolean    = False;
  wbDelayLoadRecords                 : Boolean    = True;
  wbExtendedIntUnknowns              : Boolean    = True;
  wbMoreInfoForUnknown               : Boolean    = False;
  wbMoreInfoForIndex                 : Boolean    = False;
  wdMakeUnknownElementsUnique        : Boolean    = False;
  wbTranslationMode                  : Boolean    = False;
  wbTestWrite                        : Boolean    = False;
  wbForceNewHeader                   : Boolean    = False;          // add wbNewHeaderAddon value to the headers of mainrecords and GRUP records
  wbNewHeaderAddon                   : Cardinal   = 40;             // 4 additional bytes, 40 - new form version field
  wbRequireLoadOrder                 : Boolean    = False;
  wbCreateContainedIn                : Boolean    = True;
  wbVWDInTemporary                   : Boolean    = False;
  wbVWDAsQuestChildren               : Boolean    = False;
  wbResolveAlias                     : Boolean    = True;
  wbActorTemplateHide                : Boolean    = True;
  wbClampFormID                      : Boolean    = True;
  wbAlignArrayElements               : Boolean    = True;
  wbAlignArrayLimit                  : Integer    = 5000;
  wbCopyIsRunning                    : Integer    = 0;
  wbIgnoreLight                      : Boolean    = False;
  wbPseudoLight                      : Boolean    = False;
  wbIgnoreMedium                     : Boolean    = False;
  wbPseudoMedium                     : Boolean    = False;
  wbHasAddedLightSupport             : Boolean    = False;
  wbHasAddedMediumSupport            : Boolean    = False;
  wbIgnoreOverlay                    : Boolean    = False;
  wbPseudoOverlay                    : Boolean    = False;
  wbAllowEditGameMaster              : Boolean    = False;
  wbAllowDirectSave                  : Boolean    = False;
  wbAllowDirectSaveFor               : TStringList;
  wbAllowMasterFilesEdit             : Boolean    = False;          //must be set before DefineDefs
  wbCanAddScripts                    : Boolean    = True;
  wbCanAddScriptProperties           : Boolean    = True;
  wbEditInfoUseShortName             : Boolean    = False;
  wbDevMode                          : Boolean    = False;
  wbStripEmptyMasters                : Boolean    = False;
  wbStripMasters                     : Boolean    = False;
  wbStripMastersFileNames            : TStringList;
  wbAlwaysSorted                     : Boolean    = False;
  wbNeverSorted                      : Boolean    = False;
  wbThemesSupported                  : Boolean    = True;
  wbReportModGroups                  : Boolean    = False;
  wbRequireCtrlForDblClick           : Boolean    = False;
  wbFocusAddedElement                : Boolean    = True;
  wbCheckNonCPNChars                 : Boolean    = False;
  wbShowStringBytes                  : Boolean    = False;
  wbResetModifiedOnSave              : Boolean    = True;
  wbAlwaysSaveOnam                   : Boolean    = False;
  wbAlwaysSaveOnamForce              : Boolean    = False;
  wbManualCleaningAllow              : Boolean    = False;
  wbManualCleaningHide               : Boolean    = False;
  wbConvertIntFormID                 : Boolean    = False;
  wbShrinkButtons                    : Boolean    = False;
  wbCollapseRecordHeader             : Boolean    = True;
  wbCollapseObjectBounds             : Boolean    = True;
  wbCollapseModels                   : Boolean    = True;
  wbCollapseFactions                 : Boolean    = True;
  wbCollapseFactionRelations         : Boolean    = True;
  wbCollapseFragments                : Boolean    = True;
  wbCollapseItems                    : Boolean    = True;
  wbCollapseLeveledItems             : Boolean    = True;
  wbCollapseEquipSlots               : Boolean    = True;
  wbCollapseObjectProperties         : Boolean    = True;
  wbCollapseScriptProperties         : Boolean    = True;
  wbCollapseConditions               : Boolean    = True;
  wbCollapseBenignArray              : Boolean    = True;
  wbCollapseRGBA                     : Boolean    = True;
  wbCollapseVec3                     : Boolean    = True;
  wbCollapsePosRot                   : Boolean    = True;
  wbCollapseRange                    : Boolean    = True;
  wbCollapseARMABoneData             : Boolean    = True;
  wbCollapseRACEBoneData             : Boolean    = True;
  wbCollapseScriptData               : Boolean    = True;
  wbCollapseHeadParts                : Boolean    = True;
  wbCollapseBodyParts                : Boolean    = True;
  wbCollapseModelInfoTexture         : Boolean    = True;
  wbCollapseModelInfoTextures        : Boolean    = True;
  wbCollapseModelInfoAddons          : Boolean    = True;
  wbCollapseModelInfoMaterial        : Boolean    = True;
  wbCollapseModelInfoMaterials       : Boolean    = True;
  wbCollapseModelInfo                : Boolean    = True;
  wbCollapseModelInfoHeader          : Boolean    = True;
  wbCollapseTimeInterpolator         : Boolean    = True;
  wbCollapseTimeInterpolators        : Boolean    = True;
  wbCollapseTimeInterpolatorsMultAdd : Boolean    = True;
  wbCollapseBluePrintItem            : Boolean    = True;
  wbCollapsePlacement                : Boolean    = True;
  wbCollapseVertices                 : Boolean    = True;
  wbCollapseRDSA                     : Boolean    = True;
  wbCollapseFlags                    : Boolean    = True;
  wbCollapseTransforms               : Boolean    = True;
  wbCollapseSounds                   : Boolean    = True;
  wbCollapseDestruction              : Boolean    = True;
  wbCollapseLocations                : Boolean    = True;
  wbCollapseNavmesh                  : Boolean    = True;
  wbDontDrawColorText                : Boolean    = True;
  wbReportInjected                   : Boolean    = True;
  wbNoFullInShortName                : Boolean    = True;
  wbNoIndexInAliasSummary            : Boolean    = True;
  wbExtendedLight                    : Boolean    = False;
  wbAlwaysFastAssign                 : Boolean    = False;
  wbShowRawData                      : Boolean    = False;
  wbCompareRawData                   : Boolean    = False;
  wbDisableFormIDCheck               : Boolean    = False;
  wbComplexFileFileID                : Boolean    = False;

  wbAllowMakePartial                 : Boolean    = False;

  wbHEDRVersion                      : Double     = 1.0;
  wbHEDRNextObjectID                 : Integer    = $800;

  wbCellSizeFactor                   : Single     = 4096.0;

  wbGlobalModifedGeneration          : UInt64;

  wbPluginsFileName                  : string;
  wbModGroupFileName                 : string;

  wbDontSave                         : Boolean;

  wbDontCache                        : Boolean    = False;
  wbDontCacheLoad                    : Boolean    = False;
  wbDontCacheSave                    : Boolean    = False;

  wbCacheRecordsThreshold            : Integer    = 500;
  wbCacheTimeThreshold               : TDateTime  = 2 * 1/24/60/60; //2 seconds

  wbAutoCompareSelectedLimit         : Integer    = 5;

  wbUDRSetXESP                       : Boolean    = True;
  wbUDRSetScale                      : Boolean    = False;
  wbUDRSetScaleValue                 : Single     = 0.0;
  wbUDRSetZ                          : Boolean    = True;
  wbUDRSetZValue                     : Single     = -30000;
  wbUDRSetMSTT                       : Boolean    = True;
  wbUDRSetMSTTValue                  : Int64      = $0000001B; { AshPile01 }

  wbMasterUpdateFilterONAM           : Boolean    = False;
  wbMasterUpdateFixPersistence       : Boolean    = True;

  wbAllowInternalEdit                : Boolean    = True;
  wbShowInternalEdit                 : Boolean    = False;

  wbIgnoreWorldMHDT                  : Boolean    = False;

  wbReportMode                       : Boolean    = False;
  wbReportUnused                     : Boolean    = False;
  wbReportRequired                   : Boolean    = False;
  wbReportUnusedData                 : Boolean    = True;
  wbReportUnknownFormIDs             : Boolean    = True;
  wbReportUnknownHalfs               : Boolean    = False;
  wbReportUnknownFloats              : Boolean    = True;
  wbReportUnknownDoubles             : Boolean    = True;
  wbReportUnknownStrings             : Boolean    = True;
  wbReportUnknownLStrings            : Boolean    = True;
  wbReportEmpty                      : Boolean    = True;
  wbReportSometimesEmpty             : Boolean    = True;
  wbReportFormIDs                    : Boolean    = True;
  wbReportNotFoundButAllowedFormIDs  : Boolean    = False;
  wbReportUnknownFlags               : Boolean    = True;
  wbReportUnknownEnums               : Boolean    = True;
  wbReportFormIDNotAllowedReferences : Boolean    = True;
  wbReportUnknown                    : Boolean    = False;

  wbShowDataSizeInValue              : Boolean    = False;

  wbSubRecordErrorsOnly              : Boolean    = False;

  wbReportUnknownStep                : Integer    = 1;

  wbMoreInfoForRequired              : Boolean    = False;
  wbMoreInfoForDecider               : Boolean    = False;
  wbTrackAllEditorID                 : Boolean    = False;
  wbShowTip                          : Boolean    = True;
  wbPatron                           : Boolean    = False;
  wbNoGitHubCheck                    : Boolean    = False;
  wbNoNexusModsCheck                 : Boolean    = False;

  wbCheckExpectedBytes               : Boolean    = True;

  wbRadiansToDegreesScale            : Extended   = 180/Pi;
  wbAngleDigits                      : Integer    = 4;

  wbDumpOffset                       : Integer    = 0;              // 1= starting offset, 2 = Count, 3 = Offsets, size and count
  wbBaseOffset                       : NativeUInt = 0;

  wbProgramPath                      : string;
  wbDataPath                         : string;
  wbOutputPath                       : string;
  wbScriptsPath                      : string;
  wbBackupPath                       : string;
  wbCachePath                        : string;
  wbTempPath                         : string;
  wbSavePath                         : string;
  wbMyGamesTheGamePath               : string;
  wbTheGameIniFileName               : string;
  wbCustomIniFileName                : string;

  wbCreationClubContentFileName      : string;
  wbCreationClubContent              : array of string;
  wbOfficialDLC                      : array of string;

  wbShouldLoadMOHookFile             : Boolean;
  wbMOProfile                        : string;
  wbMOHookFile                       : string;

  wbStarfieldIsABugInfestedHellhole  : Boolean    = True;
  wbRedPill                          : Boolean    = False;
  wbAlwaysLoadGameMaster             : Boolean    = True;

  wbSpeedOverMemory                  : Boolean    = False;

  wbDarkMode                         : Boolean    = False;

  wbHelpUrl                          : string     = 'https://tes5edit.github.io/docs';
  wbVideosUrl                        : string     = 'https://www.youtube.com/playlist?list=PLlN8weLk86XiGXJI4DaRa1QIq1zhDpD8V';
  wbNexusModsUrl                     : string;
  wbGitHubUrl                        : string     = 'https://github.com/TES5Edit/TES5Edit/releases';
  wbDiscordUrl                       : string     = 'https://discord.gg/5t8RnNQ';
  wbPatreonUrl                       : string     = 'https://www.patreon.com/ElminsterAU';
  wbKoFiUrl                          : string     = 'https://www.ko-fi.com/ElminsterAU';
  wbPayPalUrl                        : string     = 'https://paypal.me/ElminsterAU';

{$IFDEF USE_CODESITE}
type
  TwbLoggingArea = (
    laAddIfMissing,
    laElementAssign,
    laElementCanAssign,
    laElementSetToDefault,
    laElementWriteToStream,
    laElementMergeStorage,
    laSortInfo,

    laDummy
  );
  TwbLoggingAreas = set of TwbLoggingArea;

var
  wbLoggingAreas : TwbLoggingAreas = [

    //laAddIfMissing,
    //laElementAssign,
    //laElementCanAssign,
    //laElementSetToDefault,
    //laElementWriteToStream,
    //laElementMergeStorage,
    laSortInfo,

    laDummy
  ];

function wbCodeSiteLoggingEnabled: Boolean;
function wbBeginCodeSiteLogging: Integer;
function wbEndCodeSiteLogging: Integer;
{$ENDIF}

type
  TwbMessageType = (
    wbmtDebug,
    wbmtInfo,
    wbmtHint,
    wbmtWarning,
    wbmtError
  );

const
  wbMessageTypeString : array[TwbMessageType] of string = (
    'Debug',
    'Info',
    'Hint',
    'Warning',
    'Error'
  );

type
  TwbMessageTypeHelper = record helper for TwbMessageType
    function ToString: string;
  end;

  PwbMessage = ^TwbMessage;
  TwbMessage = record
    msgType    : TwbMessageType;
    msgMessage : string;

    function ToString: string;
  end;
  TwbMessages = TArray<TwbMessage>;
  TwbMessagePtrs = TArray<PwbMessage>;

  TwbMessagesHelper = record helper for TwbMessages
    procedure Clear;
    procedure AddMessage(aType: TwbMessageType; const aMessage: string);
    function ToPtrs: TwbMessagePtrs;
  end;

  TwbMessagePtrsHelper = record helper for TwbMessagePtrs
    procedure AddMessages(const aMessages: TwbMessagePtrs); overload;
    procedure AddMessages(const aMessages: TwbMessages); overload;
    function ToStrings: TwbStringArray;
  end;

  TConflictAll = (
    caUnknown,
    caOnlyOne,
    caNoConflict,
    caConflictBenign,
    caOverride,
    caConflict,
    caConflictCritical
    );

  TByteSet = set of Byte;
  TConflictAllSet = set of TConflictAll;
  TConflictAllColors = array[TConflictAll] of TColor;
  TConflictAllNames = array[TConflictAll] of string;

  TConflictThis = (
    ctUnknown,
    ctIgnored,
    ctNotDefined,
    ctIdenticalToMaster,
    ctOnlyOne,
    ctHiddenByModGroup,
    ctMaster,
    ctConflictBenign,
    ctOverride,
    ctIdenticalToMasterWinsConflict,
    ctConflictWins,
    ctConflictLoses
    );

  TConflictThisSet = set of TConflictThis;
  TConflictThisColors = array[TConflictThis] of TColor;
  TConflictThisNames = array[TConflictThis] of string;

var
  wbColorConflictAll: TConflictAllColors = (
    clDefault, // caUnknown
    clDefault, // caOnlyOne
    clLime,    // caNoConflict
    TColors.Greenyellow,  // caConflictBenign
    clYellow,  // caOverride
    clRed,     // caConflict
    clFuchsia  // caConflictCritical
  );

  wbColorConflictThis: TConflictThisColors = (
    clWindowText, // ctUnknown
    clWindowText, // ctIgnored
    clMedGray,    // ctNotDefined
    clDkGray,     // ctIdenticalToMaster
    clWindowText, // ctOnlyOne
    clLtGray,     // ctHiddenByModGroup
    clPurple,     // ctMaster
    clWindowText, // ctConflictBenign
    clGreen,      // ctOverride
    clOlive,      // ctIdenticalToMasterWinsConflict
    clOrange,     // ctConflictWins
    clRed         // ctConflictLoses
  );

  wbNameConflictAll: TConflictAllNames = (
    '',
    'Single Record',
    'Multiple but no conflict',
    'Benign Conflict',
    'Override without conflict',
    'Conflict',
    'Critical Conflict'
  );

  wbNameConflictThis: TConflictThisNames = (
    '',
    'Ignored',
    'Not Defined',
    'Identical to Master',
    'Single Record',
    'Hidden by Mod Group',
    'Master',
    'Benign conflict',
    'Override without conflict',
    'Identical to Master but conflict winner',
    'Conflict winner',
    'Conflict loser'
  );

type
  TwbConflictPriority = (
    cpIgnore,
    cpBenignIfAdded,
    cpBenign,
    cpOverride,
    cpTranslate,
    cpNormal,
    cpNormalIgnoreEmpty,
    cpCritical,
    cpFormID
  );

  LongRecSmall = packed record
    Lo, Hi: Smallint;
  end;

  PwbSignature = ^TwbSignature;
  TwbSignature = array[0..3] of AnsiChar;
  TwbSignatures = array of TwbSignature;

  TwbKnownSubRecord = (
    ksrEditorID,
    ksrFullName,
    ksrBaseRecord,
    ksrGridCell,
    ksrBaseFormComponents
  );

  PwbKnownSubRecordSignatures = ^TwbKnownSubRecordSignatures;
  TwbKnownSubRecordSignatures = array[TwbKnownSubRecord] of TwbSignature;

  TwbKnownSubRecordIndices = array[TwbKnownSubRecord] of Integer;

var
  wbKnownSubRecordSignatures: TwbKnownSubRecordSignatures = (
    'EDID',
    'FULL',
    'NAME',
    'XCLC',
    '____'
  );

type
  TwbFileMagic = string;

  TwbIntType = (
    it0,
    itU8,
    itS8,
    itU16,
    itS16,
    itU32,
    itS32,
    itU64,
    itS64,
    itU24,
    itU6to30
  );

  TwbDefType = (
    dtRecord,
    dtSubRecord,
    dtSubRecordArray,
    dtSubRecordStruct,
    dtSubRecordUnion,
    dtString,
    dtLString,
    dtLenString,
    dtByteArray,
    dtReflection,
    dtInteger,
    dtIntegerFormater,
    dtIntegerFormaterUnion,
    dtFlag,
    dtFloat,
    dtGuid,
    dtArray,
    dtStruct,
    dtUnion,
    dtResolvable,
    dtEmpty,
    dtStructChapter
  );

  TwbDefTypes = set of TwbDefType;

const
  dtArrays : TwbDefTypes = [
    dtSubRecordArray,
    dtArray
  ];

type
  TwbDefTypesHelper = record helper for TwbDefTypes
    function Count: Integer;
  end;

  TwbGroupTypes = set of Byte;

type
  TwbDefFlag = (
    dfAllowAnyMember,
    dfArrayCanBeEmpty,
    dfArrayStaticSize,
    dfCollapsed,
    dfDontAssign,
    dfDontSave,
    dfExcludeFromBuildRef,
    dfFastAssign,
    dfFloatSometimesBroken,
    dfHideText,
    dfIncludeValueInDisplaySignature,
    dfIndexEditorID,
    dfInternalEditOnly,
    dfIsRecordFlags,
    dfMergeIfMultiple,
    dfMustBeUnion,
    dfNoCopyAsOverride,
    dfNoMove,
    dfNoReport,
    dfNotAlignable,
    dfRemoveLastOnly,
    dfSkipImplicitEdit,
    dfStructFirstNotRequired,
    dfSummaryExcludeNULL,
    dfSummaryMembersNoName,
    dfSummaryMembersShowIgnore,
    dfSummaryNoName,
    dfSummaryNoPassthrough,
    dfSummaryNoSortKey,
    dfSummarySelfAsShortName,
    dfSummaryShowIgnore,
    dfTemplate,
    dfTranslatable,
    dfUnionStaticResolve,
    dfUseLoadOrder,
    dfZeroSortKey, // not implemented for all Defs!!!

    dfTerminator,
    dfHasZeroTerminator,
    dfNoZeroTerminator,

    dfCanContainFormID,
    dfCanContainReflection,
    dfCanContainUnmappedFormID,
    dfUnmappedFormID
  );

  TwbDefFlags = set of TwbDefFlag;

const
  _DefFlagsInheritUp:TwbDefFlags   = [dfNoReport, dfExcludeFromBuildRef, dfDontSave, dfDontAssign, dfSummaryExcludeNULL, dfInternalEditOnly, dfUnmappedFormID, dfUseLoadOrder, dfIsRecordFlags];
  _DefFlagsInheritDown:TwbDefFlags = [dfCanContainFormID, dfCanContainReflection, dfCanContainUnmappedFormID];
  _DefFlagsDontClone:TwbDefFlags   = [dfTemplate];

var
  dtNonValues : set of TwbDefType = [
    dtRecord,
    dtSubRecord,
    dtSubRecordArray,
    dtSubRecordStruct,
    dtSubRecordUnion,
    dtArray,
    dtStruct,
    dtUnion,
    dtStructChapter
  ];

const
  wbAssignThis = Low(Integer);
  wbAssignAdd = High(Integer);

type
  IwbDef = interface;

  TwbDefs = array of IwbDef;
  TwbDefPath = array of record
    Def   : IwbDef;
    Index : Integer;
  end;

  IwbElement = interface;
  IwbTemplateElement = interface;

  IwbInterface = IInvokable;

  IwbContainerElementRef = interface;

  IwbDef = interface(IwbInterface)
    ['{C7739FBD-3B58-48A2-9DD0-8057D3496892}']
    function GetDefType: TwbDefType;
    function GetDefTypeName: string;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
    function GetDefID: NativeUInt;
    function Equals(const aDef: IwbDef): Boolean;
    function GetConflictPriority(const aElement: IwbElement): TwbConflictPriority;
    function GetConflictPriorityCanChange: Boolean;
    function GetRequired: Boolean;
    function GetDontShow(const aElement: IwbElement): Boolean;
    function GetHasDontShow: Boolean;
    function GetRoot: IwbDef;
    function GetNoReach: Boolean;
    function GetParent: IwbDef;
    function GetDefFlags: TwbDefFlags;
    function GetCollapsed: Boolean;
    procedure SetCollapsed(const aValue: Boolean);
    function GetCollapsedGen: Integer;
    function GetChildPos(const aChild: IwbDef): Integer;

    procedure Report(const aParents: TwbDefPath);
    procedure Used(const aElement: IwbElement = nil; const s: string = '');
    procedure PossiblyRequired;
    procedure NotRequired;
    function IsNotRequired: Boolean;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbDef{Self};
    function IncludeFlagNoClone(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbDef{Self};

    property DefType: TwbDefType
      read GetDefType;
    property DefTypeName: string
      read GetDefTypeName;
    property DefID: NativeUInt
      read GetDefID;
    property DefFlags: TwbDefFlags
      read GetDefFlags;
    property Collapsed: Boolean
      read GetCollapsed
      write SetCollapsed;
    property CollapsedGen: Integer
      read GetCollapsedGen;
    property ConflictPriority[const aElement: IwbElement]: TwbConflictPriority
      read GetConflictPriority;
    property ConflictPriorityCanChange: Boolean
      read GetConflictPriorityCanChange;
    property Required: Boolean
      read GetRequired;
    property DontShow[const aElement: IwbElement]: Boolean
      read GetDontShow;
    property HasDontShow: Boolean
      read GetHasDontShow;
    property Root: IwbDef
      read GetRoot;
    property NoReach: Boolean
      read GetNoReach;
    property Parent: IwbDef
      read GetParent;
    property ChildPos[const aChild: IwbDef]: Integer
      read GetChildPos;
  end;

  TwbElementType = (
    etFile,
    etMainRecord,
    etGroupRecord,
    etSubRecord,
    etSubRecordStruct,
    etSubRecordArray,
    etSubRecordUnion,
    etArray,
    etStruct,
    etValue,
    etFlag,
    etStringListTerminator,
    etUnion,
    etStructChapter,
    etTemplate
  );

  TwbElementTypes = set of TwbElementType;

  TwbElementTypesHelper = record helper for TwbElementTypes
    function Count: Integer;
  end;

  IwbContainer = interface;
  IwbFile = interface;
  IwbNamedDef = interface;
  IwbValueDef = interface;
  IwbMainRecord = interface;

  TwbElementState = (
    esModified,
    esInternalModified,
    esUnsaved,
    esSortKeyValid,
    esExtendedSortKeyValid,
    esHidden,
    esParentHidden,
    esParentHiddenChecked,
    esNotReachable,
    esReachable,
    esTagged,
    esResolving,
    esNotSuitableToAddTo,
    esDummy, {Used in wbScriptAdapter as a default value}
    esConstructionComplete,
    esDestroying,
    esChangeNotified,
    esModifiedUpdated,
    esSorting,
    esFound,
    esLocalized,
    esNotLocalized,
    esOptionalAndMissing,
    esEndingUpdate,

    //the following entries must match TwbElementErrorType:
    esReportedErrorReading,
    esReportedErrorUnusedData
  );

  TwbElementStates = set of TwbElementState;

  TwbEditType = (
    etDefault,
    etComboBox,
    etCheckComboBox
  );

  TwbFiles = TArray<IwbFile>;
  PwbFiles = ^TwbFiles;
  TwbFilesDictionary = TDictionary<IwbFile, TwbNothing>;

  TwbFilesHelper = record helper for TwbFiles
    procedure Add(const aFile: IwbFile);
    procedure SortByLoadOrder;
    procedure SortByReverseLoadOrder;
  end;

  TwbModuleType = (
    mtFull,
    mtMedium,
    mtLight
  );

  TwbFileID = record
  private
    _LightSlot : SmallInt;
    _MediumSlot : SmallInt;
    _FullSlot  : SmallInt;
  public
    class function CreateFull(aFullSlot: SmallInt): TwbFileID; inline; static;
    class function CreateMedium(aMediumSlot: SmallInt): TwbFileID; inline; static;
    class function CreateLight(aLightSlot: SmallInt): TwbFileID; inline; static;

    class function CreateFromFormID(aFormID: Cardinal): TwbFileID; inline; static;

    class function Null: TwbFileID; static; inline;
    class function Invalid: TwbFileID; static; inline;

    class function MaxFullSlot: SmallInt; static;
    class function MaxMediumSlot: SmallInt; static;
    class function MaxLightSlot: SmallInt; static;

    class function LightFullSlot: SmallInt; static; inline;
    class function MediumFullSlot: SmallInt; static; inline;

    class operator Equal(const A, B: TwbFileID): Boolean; inline;
    class operator NotEqual(const A, B: TwbFileID): Boolean; inline;

    function ToString: string;

    function IsLightSlot: Boolean; inline;
    function IsMediumSlot: Boolean; inline;
    function IsFullSlot: Boolean; inline;
    function IsValid: Boolean; inline;
    function GetModuleType: TwbModuleType;

    function BaseFormID: Cardinal;

    property FullSlot: SmallInt read _FullSlot;
    property MediumSlot: SmallInt read _MediumSlot;
    property LightSlot: SmallInt read _LightSlot;

    property ModuleType: TwbModuleType read GetModuleType;
  end;

  TwbFileIDs = array of TwbFileID;

  PwbFormID = ^TwbFormID;
  TwbFormID = record
  private
    //Can not have any other fields and field must remain Cardinal.
    //There are implicit dependencies on this in multiple places in the code
    //which will not cause compiler errors, but result in runtime failures
    //if this is not observed.
    _FormID: Cardinal;

    function GetFileID: TwbFileID;
    procedure SetFileID(const Value: TwbFileID);

    function GetObjectID: Cardinal;
    procedure SetObjectID(const Value: Cardinal); overload; inline;
  public
    class function FromCardinal(const aValue: Cardinal): TwbFormID; static; inline;
    class function FromStr(aValue: string): TwbFormID; static;
    class function FromStrDef(aValue: string; aDef: Cardinal = 0): TwbFormID; static;
    class function FromVar(const aValue: Variant): TwbFormID; static;

    class function Null: TwbFormID; static; inline;
    class function None: TwbFormID; static; inline;

    class function Compare(const A, B: TwbFormID): Integer; static; inline;

    class operator Equal(const A, B: TwbFormID): Boolean; inline;
    class operator NotEqual(const A, B: TwbFormID): Boolean; inline;
    class operator GreaterThan(const A, B: TwbFormID): Boolean; inline;
    class operator GreaterThanOrEqual(const A, B: TwbFormID): Boolean; inline;
    class operator LessThan(const A, B: TwbFormID): Boolean; inline;
    class operator LessThanOrEqual(const A, B: TwbFormID): Boolean; inline;

    class operator Inc(const A: TwbFormID): TwbFormID;
    class operator Add(const A: TwbFormID; B: Int64): TwbFormID; inline;
    class operator Subtract(const A: TwbFormID; B: Int64): TwbFormID; inline;
    class operator Subtract(const A: TwbFormID; const B: TwbFormID): Int64; inline;

    function ChangeFileID(aFileID: TwbFileID): TwbFormID; inline;
    function ToString(aForDisplay: Boolean = False): string;

    function IsNull   : Boolean; inline;
    function IsPlayer : Boolean; inline;
    function IsNone   : Boolean; inline;

    function IsHardcoded: Boolean; inline;

    procedure SetObjectID(const Value: Cardinal; aSilent: Boolean); overload;

    property ToCardinal: Cardinal
      read _FormID;
    property FileID: TwbFileID
      read GetFileID
      write SetFileID;
    property ObjectID: Cardinal
      read GetObjectID
      write SetObjectID;
  end;

  TwbFormIDs = TArray<TwbFormID>;
  TwbFormIDDictionary = TDictionary<TwbFormID, TwbNothing>;

  PwbCRC32 = ^TwbCRC32;
  TwbCRC32 = type Cardinal;
  TwbCRC32s = array of TwbCRC32;

  TwbCRC32Helper = record helper for TwbCRC32
    function AssignFromString(const s: string): Boolean;
    function ToString: string;
    function IsNull: Boolean;
    function IsNone: Boolean;
    function IsValid: Boolean;
  end;

  TwbCRC32sHelper = record helper for TwbCRC32s
    function Contains(aCRC32: TwbCRC32): Boolean;
    procedure Add(aCRC32: TwbCRC32);
  end;

  TwbElementErrorType = (
    eeReading,
    eeUnusedData
  );

  TwbResetModified = (
    rmNo,
    rmYes,
    rmSetInternal
  );

  TwbTriBool = (
    tbUnknown,
    tbFalse,
    tbTrue
  );

  TwbTemplateElements = TArray<IwbTemplateElement>;

  IwbElement = interface(IwbInterface)
    ['{F4B4637D-C794-415F-B5C7-587EAA4095B3}']

    function GetElementID: Pointer;
    function GetElementStates: TwbElementStates;
    procedure SetElementState(aState: TwbElementState; Clear: Boolean = False);
    function Equals(const aElement: IwbElement): Boolean;

    function GetValue: string;
    function GetSummary: string;
    function GetCheck: string;
    function GetSortKey(aExtended: Boolean): string;
    function GetDisplaySortKey(aExtended: Boolean): string;
    function GetRawDataAsString: string;
    function GetSortPriority: Integer;
    function GetName: string;
    function GetBaseName: string;
    function GetDisplayName(aUseSuffix: Boolean): string;
    function GetShortName: string;
    function GetPath: string;
    function GetIndexedPath(aIndexFromFile: Boolean = True): string;
    function GetFullPath: string;
    function GetPathName: string;
    function GetSkipped: Boolean;
    procedure SetSkipped(aValue: Boolean);
    function GetDef: IwbNamedDef;
    function GetValueDef: IwbValueDef;
    function GetResolvedValueDef: IwbValueDef;
    function GetElementType: TwbElementType;
    function GetContainer: IwbContainer;
    function GetContainingMainRecord: IwbMainRecord;
    function GetFile: IwbFile;
    function GetReferenceFile: IwbFile;
    function GetSortOrder: Integer;
    procedure SetSortOrder(aSortOrder: Integer);
    function GetMemoryOrder: Integer;
    procedure SetMemoryOrder(aSortOrder: Integer);
    procedure BuildRef;
    function CompareExchangeFormID(aOldFormID: TwbFormID; aNewFormID: TwbFormID): Boolean;
    function GetEditValue: string;
    procedure SetEditValue(const aValue: string);
    function GetNativeValue: Variant;
    procedure SetNativeValue(const aValue: Variant);
    function GetIsEditable: Boolean;
    function GetIsRemovable: Boolean;
    function GetIsClearable: Boolean;
    procedure RequestStorageChange(var aBasePtr, aEndPtr: Pointer; aNewSize: Cardinal);
    function GetConflictPriority: TwbConflictPriority;
    function GetConflictPriorityCanChange: Boolean;
    function GetCollapsed: TwbTriBool;
    function GetModified: Boolean;
    function GetElementGeneration: Integer;
    procedure MarkModifiedRecursive(const aElementTypes: TwbElementTypes);
    function GetIsInjected: Boolean;
    function GetReferencesInjected: Boolean;
    function GetInjectionSourceFiles: TwbFiles;
    function GetIsNotReachable: Boolean;
    function GetIsReachable: Boolean;
    function GetDataSize: Integer;
    procedure SetDataSize(aSize: Integer);
    procedure MergeStorage(var aBasePtr: Pointer; aEndPtr: Pointer);
    procedure InformStorage(var aBasePtr: Pointer; aEndPtr: Pointer);
    procedure AddReferencedFromID(aFormID: TwbFormID);
    function CanContainFormIDs: Boolean;
    function ContainsReflection: Boolean;
    function ContainsUnmappedFormID: Boolean;
    function GetLinksTo: IwbElement;
    procedure SetLinksTo(const aElement: IwbElement);
    function GetSummaryLinksTo: IwbElement;
    function GetNoReach: Boolean;
    procedure ReportRequiredMasters(aDict: TwbFilesDictionary; aAsNew: Boolean; recursive: Boolean = True; initial: Boolean = False);
    function AddIfMissing(const aElement: IwbElement; aAsNew, aDeepCopy : Boolean; const aPrefixRemove, aSuffixRemove, aPrefix, aSuffix: string; aAllowOverwrite: Boolean): IwbElement;
    procedure ResetConflict;
    procedure ResetReachable;
    function RemoveInjected(aCanRemove: Boolean): Boolean;
    function GetEditType: TwbEditType;
    function GetEditInfo: TwbStringArray;
    function GetDontShow: Boolean;
    procedure SetToDefault;
    procedure SetToDefaultIfAsCreatedEmpty;
    function ResetLeafFirst: Boolean;
    function ContentIsAllZero: Boolean;

    function ShouldReportError(aErrorType: TwbElementErrorType): Boolean;

    function BeginUpdate: Integer;
    function EndUpdate: Integer;

    procedure NotifyChanged(aContainer: Pointer);

    function CanAssign(aIndex: Integer; const aElement: IwbElement; aCheckDontShow: Boolean): Boolean;
    function GetAssignTemplates(aIndex: Integer): TwbTemplateElements;
    function Assign(aIndex: Integer; const aElement: IwbElement; aOnlySK: Boolean): IwbElement;
    procedure Remove;
    procedure Clear;

    function HasErrors: Boolean;

    procedure Hide;
    procedure Show;
    function GetIsHidden: Boolean;

    procedure MoveUp;
    procedure MoveDown;
    function CanMoveUp: Boolean;
    function CanMoveDown: Boolean;

    function CanCopy: Boolean;

    function NextMember: IwbElement;
    function PreviousMember: IwbElement;
    function CanChangeMember: Boolean;

    procedure Tag;
    procedure ResetTags;
    function IsTagged: Boolean;

    function GetFound: Boolean;
    procedure SetFound(const aValue: Boolean);

    function GetLocalized: TwbTriBool;
    procedure SetLocalized(const aValue: TwbTriBool);

    property Found: Boolean
      read GetFound
      write SetFound;

    property IsHidden: Boolean
      read GetIsHidden;

    procedure WriteToStream(aStream: TStream; aResetModified: TwbResetModified);

    function CopyInto(const aFile: IwbFile; AsNew, DeepCopy: Boolean; const aPrefixRemove, aSuffixRemove, aPrefix, aSuffix: string): IwbElement;

    function GetTreeHead: Boolean;              // Is the element expected to be a "header record" in the tree navigator
    function GetTreeBranch: Boolean;            // Is the element expected to show in the tree navigator

    function GetMastersUpdated: Boolean;

    function MergeMultiple(const aElement: IwbElement): Boolean;

    property ElementID: Pointer
      read GetElementID;
    property ElementStates: TwbElementStates
      read GetElementStates;

    property Container: IwbContainer
      read GetContainer;
    property ContainingMainRecord: IwbMainRecord
      read GetContainingMainRecord;
    property _File: IwbFile
      read GetFile;
    property ReferenceFile: IwbFile
      read GetReferenceFile;
    property InjectionSourceFiles: TwbFiles
      read GetInjectionSourceFiles;

    property ElementType: TwbElementType
      read GetElementType;
    property Name: string
      read GetName;
    property BaseName: string
      read GetBaseName;
    property DisplayName[aUseSuffix: Boolean]: string
      read GetDisplayName;
    property ShortName: string
      read GetShortName;
    property Path: string
      read GetPath;
    property IndexedPath[aIndexFromFile: Boolean]: string
      read GetIndexedPath;
    property FullPath: string
      read GetFullPath;
    property PathName: string
      read GetPathName;
    property Skipped: Boolean
      read GetSkipped
      write SetSkipped;

    property Value: string
      read GetValue;
    property Summary: string
      read GetSummary;
    property SortKey[aExtended: Boolean]: string
      read GetSortKey;
    property DisplaySortKey[aExtended: Boolean]: string
      read GetDisplaySortKey;
    property Check: string
      read GetCheck;
    property RawDataAsString: string
      read GetRawDataAsString;

    property Collapsed: TwbTriBool
      read GetCollapsed;

    property Modified: Boolean
      read GetModified;
    property ElementGeneration: Integer
      read GetElementGeneration;
    property IsInjected: Boolean
      read GetIsInjected;
    property IsNotReachable: Boolean
      read GetIsNotReachable;
    property IsReachable: Boolean
      read GetIsReachable;
    property ReferencesInjected: Boolean
      read GetReferencesInjected;

    property IsEditable: Boolean
      read GetIsEditable;
    property EditValue: string
      read GetEditValue
      write SetEditValue;
    property NativeValue: Variant
      read GetNativeValue
      write SetNativeValue;

    property IsRemovable: Boolean
      read GetIsRemovable;
    property IsClearable: Boolean
      read GetIsClearable;


    property Def: IwbNamedDef
      read GetDef;
    property ValueDef: IwbValueDef
      read GetValueDef;
    property ResolvedValueDef: IwbValueDef
      read GetResolvedValueDef;

    property MemoryOrder: Integer
      read GetMemoryOrder
      write SetMemoryOrder;
    property SortPriority: Integer
      read GetSortPriority;
    property SortOrder: Integer
      read GetSortOrder
      write SetSortOrder;

    property ConflictPriority: TwbConflictPriority
      read GetConflictPriority;
    property ConflictPriorityCanChange: Boolean
      read GetConflictPriorityCanChange;

    property DataSize: Integer
      read GetDataSize
      write SetDataSize;

    property LinksTo: IwbElement
      read GetLinksTo
      write SetLinksTo;
    property SummaryLinksTo: IwbElement
      read GetSummaryLinksTo;
    property NoReach: Boolean
      read GetNoReach;

    property EditType: TwbEditType
      read GetEditType;
    property EditInfo: TwbStringArray
      read GetEditInfo;

    property DontShow: Boolean
      read GetDontShow;

    property TreeHead: Boolean
      read GetTreeHead;

    property TreeBranch: Boolean
      read GetTreeBranch;

    property Localized: TwbTriBool
      read GetLocalized
      write SetLocalized;

    property MastersUpdated: Boolean
      read GetMastersUpdated;
  end;

  IwbTemplateElement = interface(IwbElement)
    ['{200EE482-1FD5-4CB8-AEF8-7612F2A3D928}']
  end;

  IwbMultipleElements = interface(IwbElement)
    ['{1FB6EAB9-7301-49C5-90AA-1C3D13192230}']
    function GetElement(aIndex: Integer): IwbElement;
    function GetElementCount: Integer;

    property Elements[aIndex: Integer]: IwbElement
      read GetElement; default;
    property ElementCount: Integer
      read GetElementCount;
  end;

  IwbElements = TArray<IwbElement>;

  IwbStringListTerminator = interface(IwbInterface)
    ['{0D8ED4AA-1AFE-4283-87D7-2B66C5496227}']
  end;

  IwbRecord = interface;

  TwbContainerState = (
    csInit,
    csInitOnce,
    csInitDone,
    csInitializing,
    csReseting,
    csRefsBuild,
    csAsCreatedEmpty,
    csSortedBySortOrder,
    csCollapsed,
    csExpanded,
    csConstructionCompleted
  );

  TwbContainerStates = set of TwbContainerState;

  TDynStrings = TwbStringArray;

  IwbContainerBase = interface(IwbElement)
    ['{1484D26A-0F67-41FA-9044-8772E68CBA56}']

    function GetElement(aIndex: Integer): IwbElement;
    function GetAnyElement: IwbElement;
    function GetElementCount: Integer;
    function GetElementByName(const aName: string): IwbElement;
    function GetRecordBySignature(const aSignature: TwbSignature): IwbRecord;
    function GetElementByMemoryOrder(aSortOrder: Integer): IwbElement;
    function GetElementBySignature(const aSignature: TwbSignature): IwbElement;
    function GetElementBySortOrder(aSortOrder: Integer): IwbElement;
    function GetAdditionalElementCount: Integer;
    function GetContainerStates: TwbContainerStates;
    procedure SetCollapsed(const aValue: TwbTriBool);
    function GetElementByPath(const aPath: string): IwbElement;
    function GetElementValue(const aName: string): string;
    function GetElementSummary(const aName: string): string;
    function GetElementExists(const aName: string): Boolean;
    function GetElementEditValue(const aName: string): string;
    procedure SetElementEditValue(const aName, aValue: string);
    function GetElementNativeValue(const aName: string): Variant;
    procedure SetElementNativeValue(const aName: string; const aValue: Variant);
    function GetElementLinksTo(const aName: string): IwbElement;
    function GetElementSortKey(const aName: string; aExtended: Boolean): string;

    procedure AddElement(const aElement: IwbElement);
    procedure InsertElement(aPos: Integer; const aElement: IwbElement);
    function RemoveElement(aPos: Integer; aMarkModified: Boolean = False): IwbElement; overload;
    function RemoveElement(const aElement: IwbElement; aMarkModified: Boolean = False): IwbElement; overload;
    function RemoveElement(const aName: string): IwbElement; overload;
    procedure ReverseElements;

    function LastElement: IwbElement;

    function IsElementRemovable(const aElement: IwbElement): Boolean;
    function IsElementEditable(const aElement: IwbElement): Boolean;

    function IndexOf(const aElement: IwbElement): Integer;

    function CanElementReset: Boolean;

    function GetAddList: TDynStrings;
    function Add(const aName: string; aSilent: Boolean = True): IwbElement;

    property Elements[aIndex: Integer]: IwbElement
      read GetElement; default;
    property AnyElement: IwbElement
      read GetAnyElement;
    property ElementCount: Integer
      read GetElementCount;
    property AdditionalElementCount: Integer
      read GetAdditionalElementCount;

    procedure ResetMemoryOrder(aFrom: Integer = 0; aTo: Integer = High(Integer));
    procedure SortBySortOrder;
    procedure SetIsSortedBySortOrder(aForce: Boolean);

    property ElementByPath[const aPath: string]: IwbElement
      read GetElementByPath;
    property ElementValues[const aName: string]: string
      read GetElementValue;
    property ElementSummaries[const aName: string]: string
      read GetElementSummary;
    property ElementEditValues[const aName: string]: string
      read GetElementEditValue
      write SetElementEditValue;
    property ElementNativeValues[const aName: string]: Variant
      read GetElementNativeValue
      write SetElementNativeValue;
    property ElementLinksTo[const aName: string]: IwbElement
      read GetElementLinksTo;
    property ElementExists[const aName: string]: Boolean
      read GetElementExists;
    property ElementSortKeys[const aName: string; aExtended: Boolean]: string
      read GetElementSortKey;


    property ContainerStates: TwbContainerStates
      read GetContainerStates;
    property Collapsed: TwbTriBool
      read GetCollapsed
      write SetCollapsed;

    property ElementByName[const aName: string]: IwbElement
      read GetElementByName;
    property RecordBySignature[const aSignature: TwbSignature]: IwbRecord
      read GetRecordBySignature;
    property ElementByMemoryOrder[aSortOrder: Integer]: IwbElement
      read GetElementByMemoryOrder;
    property ElementBySignature[const aSignature: TwbSignature]: IwbElement
      read GetElementBySignature;
    property ElementBySortOrder[aSortOrder: Integer]: IwbElement
      read GetElementBySortOrder;
  end;

  IwbContainer = interface(IwbContainerBase)
    ['{4C4FCDD0-C885-458A-B8F2-EA3EFF8B5EEE}']
    procedure Bar;
  end;

  IwbContainerElementRef = interface(IwbContainerBase)
    ['{4066BCCF-01AA-4638-9C3D-3475CD8D5749}']
    function ReleaseKeepAlive: IwbContainerElementRef;
  end;

  TwbContainerElementRefs = TArray<IwbContainerElementRef>;

  PwbKeepAliveRoot = ^IwbKeepAliveRoot;
  IwbKeepAliveRoot = interface(IwbInterface)
    ['{D1D2C080-CE73-428F-B88F-BF9503CB8619}']
    procedure Done;
    function IsRoot: Boolean;
  end;

  IwbSortableContainer = interface(IwbContainer)
    ['{A8A65D99-507C-4D2D-86EF-57BC99E09964}']
    function GetSorted: Boolean;
    function GetAlignable: Boolean;

    property Sorted: Boolean
      read GetSorted;

    property Alignable: Boolean
      read GetAlignable;
  end;

  IwbGroupRecord = interface;

  TwbFileState = (
    fsIsNew,
    fsIsCompareLoad,
    fsIsDeltaPatch,
    fsOnlyHeader,
    fsIsHardcoded,
    fsIsGameMaster,
    fsIsTemporary,
    fsHasNoFormID,
    fsRefsBuild,
    fsRefsBuilding,
    fsIsGhost,
    fsMemoryMapped,
    fsScanning,
    fsPseudoLight,
    fsLightCompatible,
    fsPseudoMedium,
    fsMediumCompatible,
    fsPseudoOverlay,
    fsOverlayCompatible,
    fsIsOfficial,
    fsCompareToHasSameMasters,
    fsAddToMap,
    fsMastersUpdating
  );

  TwbFileStates = set of TwbFileState;
  TwbModuleExtensions = TDynStrings;
  TwbSaveExtensions = TDynStrings;

  TwbBuildOrLoadRefResult = (blrNone, blrBuilt, blrBuiltAndSaved, blrLoaded);

  TwbNamedIndex = type Integer;

  IwbFile = interface(IwbContainer)
    ['{38AA15A6-F652-45C7-B875-9CB502E5DA92}']
    function GetFileName: string;
    function GetFileNameOnDisk: string;
    function GetModuleInfo: Pointer;
    function GetModuleType: TwbModuleType;
    function GetUnsavedSince: TDateTime;

    function GetMaster(aIndex: Integer; aNew: Boolean): IwbFile;
    function GetMasterCount(aNew: Boolean): Integer;
    function GetAllMasters: TwbFiles;

    function GetFullMaster(aIndex: Integer; aNew: Boolean): IwbFile;
    function GetFullMasterCount(aNew: Boolean): Integer;

    function GetMediumMaster(aIndex: Integer; aNew: Boolean): IwbFile;
    function GetMediumMasterCount(aNew: Boolean): Integer;

    function GetLightMaster(aIndex: Integer; aNew: Boolean): IwbFile;
    function GetLightMasterCount(aNew: Boolean): Integer;

    function GetMasterForFileID(const aFileID: TwbFileID; aNew, aAllowSelf: Boolean): IwbFile;
    function GetMasterIndexForFileID(const aFileID: TwbFileID; aNew: Boolean): Integer;

    function GetRecordByFormID(aFormID: TwbFormID; aAllowInjected, aNewMasters: Boolean): IwbMainRecord;
    function GetRecordByEditorID(const aEditorID: string): IwbMainRecord;
    function GetContainedRecordByLoadOrderFormID(aFormID: TwbFormID; aAllowInjected: Boolean): IwbMainRecord;
    function GetRecordFromIndexByKey(aIndex: TwbNamedIndex; const aKey: string): IwbMainRecord;
    function GetLoadOrder: Integer;
    function GetLoadOrderFileID: TwbFileID;
    function GetResolvedLoadOrderFileID(aNewMasters : Boolean): TwbFileID;
    function GetFileFileID(aNewMasters : Boolean): TwbFileID;
    procedure ForceLoadOrder(aValue: Integer);
    function GetGroupBySignature(const aSignature: TwbSignature): IwbGroupRecord;
    function HasGroup(const aSignature: TwbSignature): Boolean;
    function GetFileStates: TwbFileStates;
    function GetCRC32: TwbCRC32;
    procedure BuildReachable;
    function BuildOrLoadRef(aOnlyLoad: Boolean): TwbBuildOrLoadRefResult;

    function LoadOrderFormIDtoFileFormID(aFormID: TwbFormID; aNew: Boolean): TwbFormID;
    function FileFormIDtoLoadOrderFormID(aFormID: TwbFormID; aNew: Boolean): TwbFormID;

    function LoadOrderFileIDtoFileFileID(aFileID: TwbFileID; aNew: Boolean): TwbFileID;
    function FileFileIDtoLoadOrderFileID(aFileID: TwbFileID; aNew: Boolean): TwbFileID;

    function NewFormID: TwbFormID;

    procedure GetMasters(aMasters: TStrings);
    procedure AddMasters(aMasters: TStrings; aSilent: Boolean = False);
    procedure AddMasterIfMissing(const aMaster: string; aSortMasters: Boolean = True; aSilent: Boolean = False);
    procedure AddMastersIfMissing(const aMasters: TStrings; aSortMasters: Boolean = True; aSilent: Boolean = False);
    procedure SortMasters;
    procedure CleanMasters;

    function GetRecord(aIndex: Integer): IwbMainRecord;
    function GetRecordCount: Integer;
    function GetInjectedRecord(aIndex: Integer): IwbMainRecord;
    function GetInjectedRecordCount: Integer;
    function GetHighObjectID: Cardinal;
    function GetHeader: IwbMainRecord;

    function GetCachedEditInfo(aIdent: Integer; var aEditInfo: TwbStringArray): Boolean;
    procedure SetCachedEditInfo(aIdent: Integer; const aEditInfo: TwbStringArray);

    function GetIsESM: Boolean;
    procedure SetIsESM(Value: Boolean);

    function GetIsFull: Boolean;
    function GetIsFullDirect: Boolean;

    function GetIsLight: Boolean;
    function GetIsLightDirect: Boolean;
    procedure SetIsLight(Value: Boolean);

    function GetIsMedium: Boolean;
    function GetIsMediumDirect: Boolean;
    procedure SetIsMedium(Value: Boolean);

    function GetIsOverlay: Boolean;
    function GetIsOverlayDirect: Boolean;
    procedure SetIsOverlay(Value: Boolean);

    function GetIsLocalized: Boolean;
    procedure SetIsLocalized(Value: Boolean);

    function GetNextObjectID: Cardinal;
    procedure SetNextObjectID(aObjectID: Cardinal);

    function GetAllowHardcodedRangeUse: Boolean;

    function HasONAM: Boolean;
    procedure MarkHeaderModified;

    function GetIsNotPlugin: Boolean;
    function GetHasNoFormID: Boolean;
    procedure SetHasNoFormID(Value: Boolean);

    function GetEncoding(aTranslatable: Boolean): TEncoding;

    function GetCompareToFile: IwbFile;

    procedure RemoveIdenticalDeltaFast;

    function IsNewRecord(const aFileID: TwbFileID; aNew: Boolean): Boolean; overload;
    function IsNewRecord(const aFormID: TwbFormID; aNew: Boolean): Boolean; overload;

    property FileName: string
      read GetFileName;
    property FileNameOnDisk: string
      read GetFileNameOnDisk;

    property ModuleInfo: Pointer
      read GetModuleInfo;
    property ModuleType: TwbModuleType
      read GetModuleType;

    property UnsavedSince: TDateTime
      read GetUnsavedSince;

    function HasMaster(const aFileName: string): Boolean;
    property Masters[aIndex: Integer; aNew: Boolean]: IwbFile
      read GetMaster;
    property MasterCount[aNew: Boolean]: Integer
      read GetMasterCount;
    property AllMasters: TwbFiles
      read GetAllMasters;

    property FullMasters[aIndex: Integer; aNew: Boolean]: IwbFile
      read GetFullMaster;
    property FullMasterCount[aNew: Boolean]: Integer
      read GetFullMasterCount;

    property MediumMasters[aIndex: Integer; aNew: Boolean]: IwbFile
      read GetMediumMaster;
    property MediumMasterCount[aNew: Boolean]: Integer
      read GetMediumMasterCount;

    property LightMasters[aIndex: Integer; aNew: Boolean]: IwbFile
      read GetLightMaster;
    property LightMasterCount[aNew: Boolean]: Integer
      read GetLightMasterCount;

    property RecordByFormID[aFormID: TwbFormID; aAllowInjected, aNewMasters: Boolean]: IwbMainRecord
      read GetRecordByFormID;
    property RecordByEditorID[const aEditorID: string]: IwbMainRecord
      read GetRecordByEditorID;
     property GroupBySignature[const aSignature: TwbSignature]: IwbGroupRecord
      read GetGroupBySignature;
    property ContainedRecordByLoadOrderFormID[aFormID: TwbFormID; aAllowInjected: Boolean]: IwbMainRecord
      read GetContainedRecordByLoadOrderFormID;
    property RecordFromIndexByKey[aIndex: TwbNamedIndex; const aKey: string]: IwbMainRecord
      read GetRecordFromIndexByKey;

    property Records[aIndex: Integer]: IwbMainRecord
      read GetRecord;
    property RecordCount: Integer
      read GetRecordCount;
    property InjectedRecords[aIndex: Integer]: IwbMainRecord
      read GetInjectedRecord;
    property InjectedRecordCount: Integer
      read GetInjectedRecordCount;
    property HighObjectID: Cardinal
      read GetHighObjectID;

    property Header: IwbMainRecord
      read GetHeader;

    property LoadOrder: Integer //do NOT use this to build FormIDs, use FileID instead
      read GetLoadOrder;
    property LoadOrderFileID: TwbFileID
      read GetLoadOrderFileID;
    property ResolvedLoadOrderFileID[aNewMasters: Boolean]: TwbFileID
      read GetResolvedLoadOrderFileID;
    property FileFileID[aNewMasters: Boolean]: TwbFileID
      read GetFileFileID;

    property FileStates: TwbFileStates
      read GetFileStates;

    property CRC32: TwbCRC32
      read GetCRC32;

    property IsESM: Boolean
      read GetIsESM
      write SetIsESM;

    property IsLight: Boolean
      read GetIsLight
      write SetIsLight;

    property IsMedium: Boolean
      read GetIsMedium
      write SetIsMedium;

    property IsOverlay: Boolean
      read GetIsOverlay
      write SetIsOverlay;

    property IsLocalized: Boolean
      read GetIsLocalized
      write SetIsLocalized;

    property NextObjectID: Cardinal
      read GetNextObjectID
      write SetNextObjectID;

    property IsNotPlugin: Boolean   // Save or other file to display.
      read GetIsNotPlugin;
    property HasNoFormID: Boolean   // Like Morrowind for example. Also true for save/coSave.
      read GetHasNoFormID
      write SetHasNoFormID;

    property Encoding[aTranslatable: Boolean]: TEncoding
      read GetEncoding;

    property CompareToFile: IwbFile
      read GetCompareToFile;

    property AllowHardcodedRangeUse: Boolean
      read GetAllowHardcodedRangeUse;
  end;

  IwbDataContainer = interface(IwbContainer)
    ['{6E547F7C-87E4-4917-8F43-4D3CEE5AFE8C}']
    function GetDataBasePtr: Pointer;
    function GetDataEndPtr: Pointer;
    function GetDataSize: Integer;
    function GetDontCompare: Boolean;
    function GetDontSave: Boolean;
    function IsValidOffset(aBasePtr, aEndPtr: Pointer; anOffset: Integer): Boolean;
    function IsLocalOffset(anOffset: Integer): Boolean;

    procedure CopyFrom(aSource: Pointer; aSize: Integer);

    property DataBasePtr: Pointer
      read GetDataBasePtr;
    property DataEndPtr: Pointer
      read GetDataEndPtr;
    property DataSize: Integer
      read GetDataSize;

    property DontCompare: Boolean
      read GetDontCompare;
    property DontSave: Boolean
      read GetDontSave;
  end;

  IwbValueBase = interface(IwbDataContainer)
    ['{BF7CC22E-5577-4502-A7CC-5B258B77957F}']
  end;

  IwbArray = interface(IwbValueBase)
    ['{D1044612-41D0-4CAC-A6C5-C4C88FC0CE2F}']
  end;

  IwbStruct = interface(IwbValueBase)
    ['{3FA46212-8B64-41C0-89FC-7B7A6E6EE72D}']
  end;

  IwbUnion = interface(IwbValueBase)
    ['{CA57AB59-2186-4A5E-9C9D-ECA8581C70B5}']
    procedure RecheckDecider;
  end;

  IwbRecordHeaderStruct = interface(IwbStruct)
    ['{E4E49F77-970B-419E-842D-9D6A841B7CF4}']
  end;

  TDynDataContainers = array of IwbDataContainer;

  IwbRecord = interface(IwbDataContainer)
    ['{4FC53881-25E2-421D-8AF6-F589979767E6}']
    function GetSignature: TwbSignature;
    function GetDisplaySignature: string;

    property Signature: TwbSignature
      read GetSignature;
    property DisplaySignature: string
      read GetDisplaySignature;
  end;

  IwbHasSignature = interface(IwbElement)
    ['{DF563D7C-A441-4864-B47A-49F3A96508F7}']
    function GetSignature: TwbSignature;

    property Signature: TwbSignature
      read GetSignature;
  end;

  PwbMainRecordStructFlags = ^TwbMainRecordStructFlags;
  TwbMainRecordStructFlags = packed record
    _Flags: Cardinal;
    function IsESM: Boolean; inline;
    function IsDeleted: Boolean; inline;
    function IsPartialForm: Boolean; inline;
    function IsLocalized: Boolean; inline;
    function CastsShadows: Boolean; inline;
    function IsPersistent: Boolean; inline;
    function IsInitiallyDisabled: Boolean; inline;
    function IsIgnored: Boolean; inline;
    function IsVisibleWhenDistant: Boolean; inline;
    function IsDangerous: Boolean; inline;
    function IsCompressed: Boolean; inline;
    function IsLight: Boolean; inline;
    function IsMedium: Boolean; inline;
    function IsOverlay: Boolean; inline;
    function CantWait: Boolean; inline;
    function HasLODtree: Boolean; inline;

    procedure SetESM(aValue: Boolean);
    procedure SetDeleted(aValue: Boolean);
    procedure SetPartialForm(aValue: Boolean);
    procedure SetLocalized(aValue: Boolean);
    procedure SetPersistent(aValue: Boolean);
    procedure SetCompressed(aValue: Boolean);
    procedure SetInitiallyDisabled(aValue: Boolean);
    procedure SetVisibleWhenDistant(aValue: Boolean);
    procedure SetLight(aValue: Boolean);
    procedure SetMedium(aValue: Boolean);
    procedure SetOverlay(aValue: Boolean);
  end;

  PwbMainRecordStructFlags3 = ^TwbMainRecordStructFlags3;
  TwbMainRecordStructFlags3 = packed record
    _Flags: Cardinal;
  end;

  TwbVector = packed record
    x: Single;
    y: Single;
    z: Single;
  end;

  TwbGridCell = record
    x, y: Integer;
    class operator Equal(const a, b: TwbGridCell): Boolean; static;
    function SortKey: string;
  end;

  TDynMainRecords = TArray<IwbMainRecord>;

  TDynMainRecordsHelper = record helper for TDynMainRecords
    procedure Add(const aMainRecord: IwbMainRecord);
  end;

  EwbSkipLoad = class(EAbort);

  IwbNamedIndexEqualityComparer = IEqualityComparer<string>;

  TwbChangedKey = record
    ckIndex  : TwbNamedIndex;
    ckOldKey : string;
    ckNewKey : string;
  end;

  TwbChangedKeys = TArray<TwbChangedKey>;

  TwbDefinedKey = record
    dkIndex : TwbNamedIndex;
    dkKey   : string;
  end;

  TwbDefinedKeys = TArray<TwbDefinedKey>;

  TwbIndexKeys = record
  private
    ikKeys: array of string;

    function GetKey(aIndex: TwbNamedIndex): string;
    procedure SetKey(aIndex: TwbNamedIndex; const aValue: string);
    function GetContains(aIndex: TwbNamedIndex): Boolean;
  public
    procedure Clear;
    function IsEmpty: Boolean;

    function GetDefinedKeys: TwbDefinedKeys;
    function GetChangedKeys(const aOldKeys: TwbIndexKeys): TwbChangedKeys;

    property Keys[aIndex : TwbNamedIndex]: string
      read GetKey
      write SetKey;
    property Contains[aIndex : TwbNamedIndex]: Boolean
      read GetContains;
  end;

  IwbMainRecordDef = interface;
  IwbMainRecord = interface(IwbRecord)
    ['{F06FD5E2-621D-4422-BA00-CB3CA72B3691}']
    function GetMainRecordDef: IwbMainRecordDef;
    function GetFormID: TwbFormID;
    function GetFixedFormID: TwbFormID;
    function GetLoadOrderFormID: TwbFormID;
    procedure SetLoadOrderFormID(aFormID: TwbFormID);
    function GetEditorID: string;
    function GetCanHaveEditorID: Boolean;
    function GetCanHaveFullName: Boolean;
    function GetCanHaveBaseRecord: Boolean;
    procedure SetEditorID(const aValue: string);
    function GetFullName: string;
    function GetDisplayNameKey: string;
    function GetMaster: IwbMainRecord;
    function GetIsMaster: Boolean;
    function GetMasterOrSelf: IwbMainRecord;
    function GetOverride(aIndex: Integer): IwbMainRecord;
    function GetOverrideCount: Integer;
    procedure AddReferencedBy(const aMainRecord: IwbMainRecord);
    procedure RemoveReferencedBy(const aMainRecord: IwbMainRecord);
    function GetReferencedBy(aIndex: Integer): IwbMainRecord;
    function GetReferencedByCount: Integer;
    function GetReference(aIndex: Integer): IwbMainRecord;
    function GetReferencesCount: Integer;
    function GetExternalReferencesCount: Integer;
    function GetIsWinningOverride: Boolean;
    function GetWinningOverride: IwbMainRecord;
    function GetHighestOverrideOrSelf(aMaxLoadOrder: Integer): IwbMainRecord;
    function GetHighestOverrideVisibleForFile(const aFile: IwbFile): IwbMainRecord;
    function GetAllVisibleForFile(const aFile: IwbFile): TDynMainRecords;
    function GetChildBySignature(const aSignature: TwbSignature): IwbMainRecord;
    function GetChildByGridCell(const aGridCell: TwbGridCell): IwbMainRecord;
    function GetFlags: TwbMainRecordStructFlags;
    function GetChildGroup: IwbGroupRecord;
    function EnsureChildGroup: IwbGroupRecord;
    function GetBaseRecord: IwbMainRecord;
    function GetBaseRecordID: TwbFormID;
    function GetBaseRecordSignature: TwbSignature;
    function GetMasterAndLeafs: TDynMainRecords;

    function GetConflictAll: TConflictAll;
    procedure SetConflictAll(aValue: TConflictAll);
    function GetConflictThis: TConflictThis;
    procedure SetConflictThis(aValue: TConflictThis);

    function GetIsESM: Boolean;
    procedure SetIsESM(aValue: Boolean);
    function GetIsPersistent: Boolean;
    procedure SetIsPersistent(aValue: Boolean);
    function GetIsDeleted: Boolean;
    procedure SetIsDeleted(aValue: Boolean);
    function GetIsPartialForm: Boolean;
    procedure SetIsPartialForm(aValue: Boolean);
    function GetCanBePartial: Boolean;
    function GetIsLocalized: Boolean;
    procedure SetIsLocalized(aValue: Boolean);
    function GetIsCompressed: Boolean;
    procedure SetIsCompressed(aValue: Boolean);
    function GetIsVisibleWhenDistant: Boolean;
    procedure SetIsVisibleWhenDistant(aValue: Boolean);
    function GetHasVisibleWhenDistantMesh: Boolean;
    function GetHasMesh: Boolean;
    function GetHasPrecombinedMesh: Boolean;
    function GetPrecombinedMesh: string;
    function GetIsInitiallyDisabled: Boolean;
    procedure SetIsInitiallyDisabled(aValue: Boolean);
    function GetIsLight: Boolean;
    procedure SetIsLight(aValue: Boolean);
    function GetIsMedium: Boolean;
    procedure SetIsMedium(aValue: Boolean);
    function GetIsOverlay: Boolean;
    procedure SetIsOverlay(aValue: Boolean);

    procedure UpdateRefs;

    function GetPosition(out aPosition: TwbVector): Boolean;
    function SetPosition(const aPosition: TwbVector): Boolean;
    function GetRotation(out aRotation: TwbVector): Boolean;
    function GetScale(out aScale: Single): Boolean;

    function GetGridCell(out aGridCell: TwbGridCell): Boolean;
    function SetGridCell(const aGridCell: TwbGridCell): Boolean;

    procedure Delete;
    procedure DeleteInto(const aFile: IwbFile);

    procedure MakePartialForm;

    function MasterRecordsFromMasterFilesAndSelf: TDynMainRecords;

    function GetFormVersion: Cardinal;
    procedure SetFormVersion(aFormVersion: Cardinal);
    function GetFormVCS1: Cardinal;
    procedure SetFormVCS1(aVCS: Cardinal);
    function GetFormVCS2: Cardinal;
    procedure SetFormVCS2(aVCS: Cardinal);

    procedure ChangeFormSignature(aSignature: TwbSignature);
    procedure ClampFormID(aIndex: Byte);

    function ContentEquals(const aMainRecord: IwbMainRecord): Boolean;

    function ActivateIndexKeys: TwbDefinedKeys;
    function DeactivateIndexKeys: TwbDefinedKeys;

    property Def: IwbMainRecordDef
      read GetMainRecordDef;

    property Version: Cardinal
      read GetFormVersion
      write SetFormVersion;
    property VCS1: Cardinal
      read GetFormVCS1
      write SetFormVCS1;
    property VCS2: Cardinal
      read GetFormVCS2
      write SetFormVCS2;

    property BaseRecord: IwbMainRecord
      read GetBaseRecord;
    property BaseRecordID: TwbFormID
      read GetBaseRecordID;
    property BaseRecordSignature: TwbSignature
      read GetBaseRecordSignature;
    property CanHaveBaseRecord: Boolean
      read GetCanHaveBaseRecord;
    property FormID: TwbFormID
      read GetFormID;
    property FixedFormID: TwbFormID
      read GetFixedFormID;
    property LoadOrderFormID: TwbFormID
      read GetLoadOrderFormID
      write SetLoadOrderFormID;
    property EditorID: string
      read GetEditorID
      write SetEditorID;
    property CanHaveEditorID: Boolean
      read GetCanHaveEditorID;
    property FullName: string
      read GetFullName;
    property CanHaveFullName: Boolean
      read GetCanHaveFullName;
    property DisplayNameKey: string
      read GetDisplayNameKey;

    property Flags: TwbMainRecordStructFlags
      read GetFlags;

    property Master: IwbMainRecord
      read GetMaster;
    property MasterOrSelf: IwbMainRecord
      read GetMasterOrSelf;
    property IsMaster: Boolean
      read GetIsMaster;

    property ChildGroup: IwbGroupRecord
      read GetChildGroup;

    property Overrides[aIndex: Integer]: IwbMainRecord
      read GetOverride;
    property OverrideCount: Integer
      read GetOverrideCount;
    property IsWinningOverride: Boolean
      read GetIsWinningOverride;
    property WinningOverride: IwbMainRecord
      read GetWinningOverride;
    property HighestOverrideOrSelf[aMaxLoadOrder: Integer]: IwbMainRecord
      read GetHighestOverrideOrSelf;
    property HighestOverrideVisibleForFile[const aFile: IwbFile]: IwbMainRecord
      read GetHighestOverrideVisibleForFile;
    property AllVisibleForFile[const aFile: IwbFile]: TDynMainRecords
      read GetAllVisibleForFile;
    property ChildBySignature[const aSignature: TwbSignature]: IwbMainRecord
      read GetChildBySignature;
    property ChildByGridCell[const aGridCell: TwbGridCell]: IwbMainRecord
      read GetChildByGridCell;
    property MasterAndLeafs: TDynMainRecords
      read GetMasterAndLeafs;

    property ReferencedBy[aIndex: Integer]: IwbMainRecord
      read GetReferencedBy;
    property ReferencedByCount: Integer
      read GetReferencedByCount;

    property References[aIndex: Integer]: IwbMainRecord
      read GetReference;
    property ReferencesCount: Integer
      read GetReferencesCount;
    property ExternalReferencesCount: Integer
      read GetExternalReferencesCount;

    property IsESM: Boolean
      read GetIsESM
      write SetIsESM;
    property IsPersistent: Boolean
      read GetIsPersistent
      write SetIsPersistent;
    property IsDeleted: Boolean
      read GetIsDeleted
      write SetIsDeleted;
    property IsPartialForm: Boolean
      read GetIsPartialForm
      write SetIsPartialForm;
    property CanBePartial: Boolean
      read GetCanBePartial;
    property IsCompressed: Boolean
      read GetIsCompressed
      write SetIsCompressed;
    property IsLocalized: Boolean
      read GetIsLocalized
      write SetIslocalized;
    property IsVisibleWhenDistant: Boolean
      read GetIsVisibleWhenDistant
      write SetIsVisibleWhenDistant;
    property HasVisibleWhenDistantMesh: Boolean
      read GetHasVisibleWhenDistantMesh;
    property HasMesh: Boolean
      read GetHasMesh;
    property HasPrecombinedMesh: Boolean
      read GetHasPrecombinedMesh;
    property PrecombinedMesh: string
      read GetPrecombinedMesh;
    property IsInitiallyDisabled: Boolean
      read GetIsInitiallyDisabled
      write SetIsInitiallyDisabled;
    property IsLight: Boolean
      read GetIsLight
      write SetIsLight;
    property IsMedium: Boolean
      read GetIsMedium
      write SetIsMedium;
    property IsOverlay: Boolean
      read GetIsOverlay
      write SetIsOverlay;

    property ConflictAll: TConflictAll
      read GetConflictAll
      write SetConflictAll;
    property ConflictThis: TConflictThis
      read GetConflictThis
      write SetConflictThis;
  end;

  IwbFileHeader = interface(IwbDataContainer)
    ['{E309EEE2-C20E-4506-BF46-B63F903706C9}']
    function GetFileMagic: TwbFileMagic;

    property FileMagic: TwbFileMagic
      read GetFileMagic;
  end;

  IwbChapter = interface(IwbStruct)
    ['{3E575648-EF6F-4e9f-956F-D2E184B670E4}']
    function GetChapterType: Integer;
    function GetChapterTypeName: string;
    function GetChapterName: string;
    property ChapterType: Integer
      read GetChapterType;
    property ChapterTypeName: string
      read GetChapterTypeName;
    property ChapterName: string
      read GetChapterName;
  end;

  TDynElements = array of IwbElement;
  {$IFDEF WIN32}
  TDynCardinalArray = array of Cardinal;
  {$ENDIF WIN32}
  {$IFDEF WIN64}
  TDynCardinalArray = array of UInt64;
  {$ENDIF WIN32}

  TDynElementsHelper = record helper for TDynElements
    procedure Add(const aElement: IwbElement);
  end;

  IwbSubRecord = interface(IwbRecord)
    ['{CDE36A3D-64F6-4B8E-980E-FBAB8D9FCAF7}']
    function GetSubRecordHeaderSize: Integer;
    property SubRecordHeaderSize: Integer
      read GetSubRecordHeaderSize;
  end;

  TDynGroupRecords = array of IwbGroupRecord;

  IwbGroupRecord = interface(IwbRecord)
    ['{BFF16E47-4E66-4EAD-9BEF-364728AE0A6B}']
    function GetGroupType: Integer;
    function GetGroupLabel: Cardinal;
    function GetGroupLabelSignature: string;
    procedure SetGroupLabel(aLabel: Cardinal);
    function GetChildrenOf: IwbMainRecord;

    function FindChildGroup(aType: Integer; const aMainRecord: IwbMainRecord): IwbGroupRecord; overload;
    function FindChildGroup(aType: Integer; const aLabel : Cardinal): IwbGroupRecord; overload;

    function GetMainRecordByEditorID(const aEditorID: string): IwbMainRecord;
    function GetMainRecordByFormID(const aFormID: TwbFormID): IwbMainRecord;

    procedure AddElement(const aElement: IwbElement);

    procedure Sort(aForce: Boolean = False);

    property GroupType: Integer
      read GetGroupType;
    property GroupLabel: Cardinal
      read GetGroupLabel
      write SetGroupLabel;
    property GroupLabelSignature: string
      read GetGroupLabelSignature;

    property ChildrenOf: IwbMainRecord
      read GetChildrenOf;

    property MainRecordByEditorID[const aEditorID: string]: IwbMainRecord
      read GetMainRecordByEditorID;
    property MainRecordByFormID[const aFormID: TwbFormID]: IwbMainRecord
      read GetMainRecordByFormID;
  end;

  IwbSubRecordArray = interface(IwbContainer)
    ['{26937F7A-5F31-4D65-932F-038BD0FA9FEF}']
  end;

  IwbSubRecordStruct = interface(IwbContainer)
    ['{E8C496D3-D396-4685-87EC-82E1FD2588B8}']
  end;

  IwbSubRecordUnion = interface(IwbContainer)
    ['{11959F58-B396-4449-9D9D-5DF1251C3E76}']
  end;

  TwbCallbackType = (
    ctToStr,
    ctToSortKey,
    ctCheck,
    ctToEditValue,
    ctEditType,
    ctEditInfo,
    ctLinksTo,
    ctBuildRef,
    ctFromEditValue,
    ctFromInt,
    ctFromNativeValue,
    ctToInt,
    ctToNativeValue,
    ctToSummary
  );

  TwbAddInfoCallback                = reference to function(const aMainRecord: IwbMainRecord): string;
  TwbAfterLoadCallback              = reference to procedure(const aElement: IwbElement);
  TwbAfterSetCallback               = reference to procedure(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
  TwbBuildIndexKeysCallback         = reference to procedure(const aMainRecord: IwbMainRecord; var aIndexKeys: TwbIndexKeys);
  TwbCountCallback                  = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
  TwbDontShowCallback               = reference to function(const aElement: IwbElement): Boolean;
  TwbFloatNormalizer                = reference to function(const aElement: IwbElement; aFloat: Extended): Extended;
  TwbGetChapterNameCallback         = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string;
  TwbGetChapterTypeCallback         = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
  TwbGetChapterTypeNameCallback     = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string;
  TwbGetConflictPriority            = reference to procedure(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
  TwbIntegerDefFormaterUnionDecider = reference to function(const aElement: IwbElement): Integer;
  TwbIntOverlayCallback             = reference to function(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): Int64;
  TwbIntToStrCallback               = reference to function(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
  TwbIsRemovableCallback           = reference to function(const aElement: IwbElement): Boolean;
  TwbIsSortedCallback               = reference to function(const aContainer: IwbContainer): Boolean;
  TwbLinksToCallback                = reference to function(const aElement: IwbElement): IwbElement;
  TwbSetToDefaultCallback           = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Boolean;
  TwbShouldIncludeCallback          = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aArray: IwbElement): Boolean;//aBasePtr is for next array element. aArray is the array element that is currently parsing the next element
  TwbSizeCallback                   = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; var CompressedSize: Integer): Cardinal;
  TwbStrToIntCallback               = reference to function(const aString: string; const aElement: IwbElement): Int64;
  TwbStructSizeCallback             = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
  TwbToStrCallback                  = reference to procedure(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
  TwbUnionDecider                   = reference to function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
  TwbRUnionDecider                  = reference to function(const aContainer: IwbContainerElementRef): Integer;

  IwbNamedDef = interface(IwbDef)
    ['{F8FEDE89-C089-42C5-B587-49A7D87055F0}']
    function GetName: string;
    function GetSummaryName: string;
    function GetFullName: string;
    function GetSingularName: string;
    function GetSummarySingularName: string;
    function GetPath: string;
    function GetFullPath: string;
    procedure AfterLoad(const aElement: IwbElement);
    procedure AfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);

    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbNamedDef;
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbNamedDef;
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbNamedDef;
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbNamedDef;

    function GetTreeHead: Boolean;              // Is the element expected to be a "header record" in the tree navigator
    procedure SetTreeHead(aValue: Boolean);     // Make the element a "header record" in the tree navigator;
    function GetTreeBranch: Boolean;            // Is the element included in a "leaf" expected to be displayed in the view pane
    procedure SetTreeBranch(aValue: Boolean);   // Make the element included in a "leaf" visible in the tree navigator;

    procedure ToString(var Result : string; const aElement: IwbElement; aType: TwbCallbackType);
    function GetSummaryLinksTo(const aElement: IwbElement): IwbElement;

    function IsRemovable(const aElement: IwbElement): Boolean;

    function SetSummaryName(const aName: string): IwbNamedDef;

    property Name: string
      read GetName;
    property SummaryName: string
      read GetSummaryName;
    property FullName: string
      read GetFullName;
    property Path: string
      read GetPath;
    property FullPath: string
      read GetFullPath;

    property TreeHead: Boolean
      read GetTreeHead write SetTreeHead;

    property TreeBranch: Boolean
      read GetTreeBranch write SetTreeBranch;
  end;

  IwbSignatureDef = interface(IwbNamedDef)
    ['{EF20E1A2-8719-4934-AC36-C91DC72C3F70}']
    function GetDefaultSignature: TwbSignature;

    function GetSignature(const aIndex: Integer): TwbSignature;
    function GetSignatureCount: Integer;

    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean;

    property DefaultSignature: TwbSignature
      read GetDefaultSignature;

    property Signatures[const aIndex: Integer]: TwbSignature
      read GetSignature;
    property SignatureCount: Integer
      read GetSignatureCount;
  end;

  IwbRecordMemberDef = interface;

  IwbStructDef = interface;

  IwbRecordDef = interface(IwbSignatureDef)
    ['{89FE380F-7A0B-493C-AA9E-08957A4C167B}']
    function ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Boolean;
    function GetMemberFor(const aContainer     : IwbContainerElementRef;
                                aSignature     : TwbSignature;
                          const aDataContainer : IwbDataContainer)
                                               : IwbRecordMemberDef;
    function GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Integer;

    function AllowUnordered: Boolean;
    function AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;

    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;

    function GetSkipSignature(const aSignature: TwbSignature): Boolean;

    function GetRecordHeaderStruct: IwbStructDef;

    property Members[aIndex: Integer]: IwbRecordMemberDef read GetMember;
    property MemberCount: Integer read GetMemberCount;

    property SkipSignature[const aSignature: TwbSignature]: Boolean
      read GetSkipSignature;

    property RecordHeaderStruct: IwbStructDef
      read GetRecordHeaderStruct;
  end;

  TwbMainRecordGetFormIDCallback = reference to function(const aMainRecord: IwbMainRecord; out aFormID: TwbFormID): Boolean;
  TwbMainRecordIdentityCallback = reference to function(const aMainRecord: IwbMainRecord): string;
  TwbMainRecordGetEditorIDCallback = reference to function(const aSubRecord: IwbSubRecord): string;
  TwbMainRecordSetEditorIDCallback = reference to procedure(const aSubRecord: IwbSubRecord; const aEditorID: string);
  TwbMainRecordGetGridCellCallback = reference to function(const aSubRecord: IwbSubRecord; out aGridCell: TwbGridCell): Boolean;

  PwbMainRecordDef = ^IwbMainRecordDef;
  IwbMainRecordDef = interface(IwbRecordDef)
    ['{B9559BE2-705B-43BF-A1B2-5B7829F65B53}']
    function GetIsReference: Boolean;

    function GetQuickInitLimit: Integer;

    function GetContainsKnownSubRecord(aKnownSubRecord: TwbKnownSubRecord): Boolean;
    function GetKnownSubRecordMemberIndex(aKnownSubRecord: TwbKnownSubRecord): Integer;
    function GetKnownSubRecordMember(aKnownSubRecord: TwbKnownSubRecord): IwbRecordMemberDef;

    function GetCanBePartial: Boolean;

    function GetBaseSignature(const aIndex: Integer): TwbSignature;
    function GetBaseSignatureCount: Integer;
    function IsValidBaseSignature(const aSignature: TwbSignature): Boolean;

    function GetReferenceSignature(const aIndex: Integer): TwbSignature;
    function GetReferenceSignatureCount: Integer;
    function IsValidReferenceSignature(const aSignature: TwbSignature): Boolean;

    function GetFormIDBase: Byte;
    function SetFormIDBase(aBase: Byte): IwbMainRecordDef;

    function GetFormIDNameBase: Byte;
    function SetFormIDNameBase(aBase: Byte): IwbMainRecordDef;

    function GetFormID(const aMainRecord: IwbMainRecord; out aFormID: TwbFormID): Boolean;
    function SetGetFormIDCallback(const aCallback: TwbMainRecordGetFormIDCallback): IwbMainRecordDef;

    function KnownSubRecordSignatures: PwbKnownSubRecordSignatures;
    function GetIdentity(const aMainRecord: IwbMainRecord): string;
    function SetIdentityCallback(const aCallback: TwbMainRecordIdentityCallback): IwbMainRecordDef;

    function GetEditorID(const aSubRecord: IwbSubRecord): string;
    procedure SetEditorID(const aSubRecord: IwbSubRecord; const aEditorID: string);
    function SetGetEditorIDCallback(const aCallback: TwbMainRecordGetEditorIDCallback): IwbMainRecordDef;
    function SetSetEditorIDCallback(const aCallback: TwbMainRecordSetEditorIDCallback): IwbMainRecordDef;

    function GetGridCell(const aSubRecord: IwbSubRecord; out aGridCell: TwbGridCell): Boolean;
    function SetGetGridCellCallback(const aCallback: TwbMainRecordGetGridCellCallback): IwbMainRecordDef;

    function SetAddInfo(const aAddInfo: TwbAddInfoCallback): IwbMainRecordDef;
    function SetToStr(const aToStr : TwbToStrCallback): IwbMainRecordDef{Self};
    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbMainRecordDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbMainRecordDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbMainRecordDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbMainRecordDef;

    function ToSummary(aDepth: Integer; const aMainRecord: IwbMainRecord; var aLinksTo: IwbElement): string;

    function SetIgnoreList(const aSignatures: array of TwbSignature): {Self}IwbMainRecordDef;
    function ShouldIgnore(const aSignature: TwbSignature): Boolean;

    function SetBuildIndexKeys(const aCallback: TwbBuildIndexKeysCallback): {Self}IwbMainRecordDef;
    function BuildIndexKeys(const aMainRecord: IwbMainRecord; var aIndexKeys: TwbIndexKeys): Boolean;

    property IsReference: Boolean
      read GetIsReference;

    property QuickInitLimit: Integer
      read GetQuickInitLimit;

    property ContainsKnownSubRecord[aKnownSubRecord: TwbKnownSubRecord]: Boolean
      read GetContainsKnownSubRecord;
    property KnownSubRecordMemberIndex[aKnownSubRecord: TwbKnownSubRecord]: Integer
      read GetKnownSubRecordMemberIndex;
    property KnownSubRecordMember[aKnownSubRecord: TwbKnownSubRecord]: IwbRecordMemberDef
      read GetKnownSubRecordMember;

    property CanBePartial: Boolean
      read GetCanBePartial;

    property BaseSignatures[const aIndex: Integer]: TwbSignature
      read GetBaseSignature;
    property BaseSignatureCount: Integer
      read GetBaseSignatureCount;

    property ReferenceSignatures[const aIndex: Integer]: TwbSignature
      read GetReferenceSignature;
    property ReferenceSignatureCount: Integer
      read GetReferenceSignatureCount;
  end;

  IwbHasSortKeyDef = interface(IwbRecordDef)
    ['{877FEF58-72B1-4735-9E08-166B5F4043F3}']
    function GetSortKey(aIndex: Integer; aExtended: Boolean): Integer;
    function GetSortKeyCount(aExtended: Boolean): Integer;
    function IsInSK(aIndex: Integer): Boolean;

    property SortKeys[aIndex: Integer; aExtended: Boolean]: Integer
      read GetSortKey;
    property SortKeyCount[aExtended: Boolean]: Integer
      read GetSortKeyCount;
  end;

  IwbRecordMemberDef = interface(IwbSignatureDef)
    ['{259F3F08-F4ED-439D-8C1A-48137C84E52A}']
    function ToSummary(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbRecordMemberDef{Self};
    function SetSummaryName(const aName: string): IwbRecordMemberDef{Self};

    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbRecordMemberDef{Self};
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbRecordMemberDef{Self};
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbRecordMemberDef{Self};
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbRecordMemberDef;
    function SetToStr(const aToStr : TwbToStrCallback): IwbRecordMemberDef{Self};
    function SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbRecordMemberDef{Self};

    function SetRequired(const aRequired : Boolean = True): IwbRecordMemberDef{Self};
  end;

  TwbUsedMasters = array[Byte] of Boolean;
  PwbUsedMasters = ^TwbUsedMasters;

  IwbValueDef = interface(IwbNamedDef)
    ['{BBF684A6-0EE5-4EF6-83DD-D323A0D2919A}']
    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbValueDef;
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbValueDef;
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbValueDef;

    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
    function GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement;
    procedure SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: IwbElement);
    procedure BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
    function GetIsVariableSize: Boolean;
    function GetCanBeZeroSize: Boolean;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbValueDef{Self};
    function SetSummaryName(const aName: string): IwbValueDef;

    function MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean;
    procedure FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters);
    function CompareExchangeFormID(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aOldFormID: TwbFormID; aNewFormID: TwbFormID): Boolean;

    function GetElementMap: TDynCardinalArray;

    function SetDefaultEditValue(const aValue: string): IwbValueDef{Self};
    function SetDefaultNativeValue(const aValue: Variant): IwbValueDef{Self};
    function SetLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef{Self};
    function SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef{Self};
    function SetToStr(const aToStr : TwbToStrCallback): IwbValueDef{Self};
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbValueDef{Self};
    function SetStaticEditInfo(aEditInfo: PwbStringArray): IwbValueDef{Self};

    function SetSetToDefault(const aCallback: TwbSetToDefaultCallback): IwbValueDef{Self};

    property Size[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: Integer
      read GetSize;
    property DefaultSize[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: Integer
      read GetDefaultSize;
    property IsVariableSize: Boolean
      read GetIsVariableSize;
    property CanBeZeroSize: Boolean
      read GetCanBeZeroSize;
    property IsEditable[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: Boolean
      read GetIsEditable;
    property EditValue[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: string
      read ToEditValue
      write FromEditValue;
    property NativeValue[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: Variant
      read ToNativeValue
      write FromNativeValue;
    property LinksTo[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: IwbElement
      read GetLinksTo
      write SetLinksTo;

    property EditType[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: TwbEditType
      read GetEditType;
    property EditInfo[aBasePtr, aEndPtr: Pointer; const aElement: IwbElement]: TwbStringArray
      read GetEditInfo;
  end;

  IwbGuidDef = interface(IwbValueDef)
    ['{DC03A774-B1F9-45C1-8EF5-53F7DE6FE80A}']

  end;

  TwbSubRecordForValueCallback = reference to procedure(const v: IwbValueDef);

  IwbSubRecordDef = interface(IwbRecordMemberDef)
    ['{D848E426-8768-45F4-B192-4DEFBE34D40A}']
    function GetValue: IwbValueDef;
    procedure HasUnusedData;

    function IncludeFlagOnValue(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbSubRecordDef{Self};

    function SetDefaultEditValue(const aValue: string): IwbSubRecordDef{Self};
    function SetDefaultNativeValue(const aValue: Variant): IwbSubRecordDef{Self};
    function SetDefaultEditValues(const aValues: array of string): IwbRecordMemberDef{Self};

    function ForValue(const aCallback: TwbSubRecordForValueCallback): IwbSubRecordDef{Self};

    function SetLinksToCallbackOnValue(const aCallback: TwbLinksToCallback): IwbSubRecordDef{Self};

    property Value: IwbValueDef read GetValue;
  end;

  IwbSubRecordWithStructDef = interface(IwbSubRecordDef)
    ['{CE0BDAB8-F4FB-42B8-8013-AE7176C0FCD1}']
    function SetSummaryKeyOnValue(const aSummaryKey: array of Integer): IwbSubRecordWithStructDef{Self};
    function SetSummaryPrefixSuffixOnValue(aIndex: Integer; const aPrefix, aSuffix: string): IwbSubRecordWithStructDef{Self};
    function SetSummaryMemberMaxDepthOnValue(aIndex, aMaxDepth: Integer): IwbSubRecordWithStructDef{Self};
    function SetSummaryDelimiterOnValue(const aDelimiter: string): IwbSubRecordWithStructDef{Self};
  end;

  IwbEnumDef = interface;

  IwbSubRecordWithArrayDef = interface(IwbSubRecordDef)
    ['{67E87022-6250-494F-B34B-DA058CF916E3}']

    function SetSummaryPassthroughMaxCountOnValue(aCount: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryPassthroughMaxLengthOnValue(aLength: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryPassthroughMaxDepthOnValue(aDepth: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryDelimiterOnValue(const aDelimiter: string): IwbSubRecordWithArrayDef;
    function SetDefaultEditValuesOnValue(const aValues: array of string): IwbSubRecordWithArrayDef;
    function SetCountPathOnValue(const aValue: string; aUseForCountCallback: Boolean): IwbSubRecordWithArrayDef;
    function SetCountFromEnumOnValue(const aEnum: IwbEnumDef): IwbSubRecordWithArrayDef;
    function SetWronglyAssumedFixedSizePerElementOnValue(aSize: Integer): IwbSubRecordWithArrayDef;
  end;

  IwbStringDefFormater = interface;

  IwbSubRecordWithBaseStringDef = interface(IwbSubRecordDef)
    ['{D3D85C9C-1E5C-4F14-A001-D65659262AC1}']

    function SetFormaterOnValue(const aFormater: IwbStringDefFormater): IwbSubRecordWithBaseStringDef;
  end;

  IwbSubRecordArrayDef = interface(IwbRecordMemberDef)
    ['{67943BAC-B558-4112-8DBC-C94A44E0B1D1}']
    function GetElement: IwbRecordMemberDef;
    function GetSorted(const aContainer: IwbContainer): Boolean;
    function GetCountPath: string;
    function GetCount: Integer;

    function SetCountPath(const aValue: string): IwbSubRecordArrayDef;

    function SetDefaultEditValues(const aValues: array of string): IwbSubRecordArrayDef;
    function GetDefaultEditValues: TwbStringArray;

    property Element: IwbRecordMemberDef read GetElement;
    property Count: Integer read GetCount; //fixed number of elementes if > 0
    property Sorted[const aContainer: IwbContainer]: Boolean read GetSorted;
    property CountPath: string read GetCountPath;
    property DefaultEditValues: TwbStringArray read GetDefaultEditValues;
  end;

  IwbSubRecordStructDef = interface(IwbRecordMemberDef)
    ['{B5441812-5229-488B-AEA6-C182CEBED441}']
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbSubRecordStructDef;
    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbSubRecordStructDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbSubRecordStructDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbSubRecordStructDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbSubRecordStructDef;

    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;

    property Members[aIndex: Integer]: IwbRecordMemberDef read GetMember;
    property MemberCount: Integer read GetMemberCount;
  end;

  IwbSubRecordUnionDef = interface(IwbRecordMemberDef)
    ['{BC66ABFF-3108-4C64-B416-674A2A8F297D}']
    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;

    property Members[aIndex: Integer]: IwbRecordMemberDef read GetMember;
    property MemberCount: Integer read GetMemberCount;
  end;

  IwbResolvableDef = interface(IwbValueDef)
    ['{2EB12125-5E21-4A55-902F-CC245510AC58}']
    function NeedsElementToResolve: Boolean;
    function ResolveDef(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef;
    function ResolveDefAndElement(aBasePtr: Pointer; aEndPtr: Pointer; var aElement: IwbElement): IwbValueDef;
  end;

  IwbRecursiveDef = interface(IwbResolvableDef)
    ['{6BE62954-70CC-4833-BA1D-2F38605F06C9}']
  end;

  IwbUnionDef = interface(IwbResolvableDef)
    ['{04D6B7BA-B457-4E43-9910-592395FEA0D6}']
    function GetMember(aIndex: Integer): IwbValueDef;
    function GetMemberCount: Integer;
    function GetMemberTypes:TwbDefTypes;

    property Members[aIndex: Integer]: IwbValueDef read GetMember;
    property MemberCount: Integer read GetMemberCount;
    property MemberTypes: TwbDefTypes
      read GetMemberTypes;
  end;

  IwbBaseStringDef = interface(IwbValueDef)
    ['{06632243-538C-48EC-9074-7BB72142CAB8}']
    function OverrideEncoding(aEncoding: TEncoding): IwbBaseStringDef;

    function SetFormater(const aFormater: IwbStringDefFormater): IwbBaseStringDef;
  end;

  IwbStringDef = interface(IwbBaseStringDef)
    ['{37B02D28-EDB4-41C6-B933-9F56C013A88A}']
    function GetStringSize: Integer;

    function SetFormater(const aFormater: IwbStringDefFormater): IwbStringDef;

    property StringSize: Integer
      read GetStringSize;
  end;

  IwbLenStringDef = interface(IwbBaseStringDef)
    ['{1AD7FAE2-DAA7-4651-B78D-10E138EDF48B}']

    function SetFormater(const aFormater: IwbStringDefFormater): IwbLenStringDef;
  end;

  IwbByteArrayDef = interface(IwbValueDef)
    ['{3069E1AC-4307-421B-93E4-797E18075EF9}']
  end;

  IwbReflectionDef = interface(IwbByteArrayDef)
    ['{46330B2B-78BB-4787-BA61-19CF986D2484}']
  end;

  IwbEmptyDef = interface(IwbValueDef)
    ['{0A858744-947B-4B6E-9972-D8BF5398C87C}']
    function GetSorted: Boolean;

    property Sorted: Boolean
      read GetSorted;
  end;

  IwbIntegerDefFormater = interface;

  IwbIntegerDef = interface(IwbValueDef)
    ['{00A270B0-ACFC-444C-A7E8-A577BD40704E}']
    function ToInt(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Int64;
    procedure FromInt(aValue: Int64; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);

    function GetFormater(const aElement: IwbElement): IwbIntegerDefFormater;
    function GetFormaterCanChange: Boolean;
    function GetIntType: TwbIntType;
    function GetExpectedLength(aValue: Int64 = 0): Integer;

    function AddOverlay(const aCallback: TwbIntOverlayCallback): IwbIntegerDef;

    property Formater[const aElement: IwbElement]: IwbIntegerDefFormater
      read GetFormater;
    property FormaterCanChange: Boolean
      read GetFormaterCanChange;
    property IntType: TwbIntType
      read GetIntType;

    property ExpectedLength[aValue: Int64 = 0]: Integer
      read GetExpectedLength;
  end;

  TwbFloatKind = (
    fkHalf,
    fkSingle,
    fkDouble
  );

  IwbFloatDef = interface(IwbValueDef)
    ['{29F116C6-0208-4D55-ACA7-2A9BB17BF80B}']
    function GetKind: TwbFloatKind;

    property Kind: TwbFloatKind
      read GetKind;
  end;

  IwbArrayDef = interface(IwbValueDef)
    ['{BD195F99-4AC3-4BD0-9193-267332E97D79}']
    function GetElement: IwbValueDef;
    function GetCount: Integer;
    function GetElementLabel(aIndex: Integer): string;
    function GetElementNameSuffix(aIndex: Integer): string;
    function GetSorted: Boolean;
    function GetCanAddTo: Boolean;
    function GetCountCallBack: TwbCountCallback;
    function GetPrefixSize(aBasePtr: Pointer): Integer;
    function GetPrefixLength(aBasePtr: Pointer): Integer;
    function GetPrefixCount(aBasePtr: Pointer): Cardinal;
    procedure SetPrefixCount(aBasePtr: Pointer; aCount: Cardinal);

    function SetSummaryPassthroughMaxCount(aCount: Integer): IwbArrayDef;
    function SetSummaryPassthroughMaxLength(aLength: Integer): IwbArrayDef;
    function SetSummaryPassthroughMaxDepth(aDepth: Integer): IwbArrayDef;
    function SetSummaryDelimiter(const aDelimiter: string): IwbArrayDef;

    function SetDefaultEditValues(const aValues: array of string): IwbArrayDef;
    function GetDefaultEditValues: TwbStringArray;

    function GetCountPath: string;
    function SetCountPath(const aValue: string; aUseForCountCallback: Boolean): IwbArrayDef;

    function SetShouldInclude(const aCallback: TwbShouldIncludeCallback): IwbArrayDef;
    function ShouldInclude(aBasePtr: Pointer; aEndPtr: Pointer; const aArray: IwbElement): Boolean;

    function SetCountFromEnum(const aEnum: IwbEnumDef): IwbArrayDef;

    function SetWronglyAssumedFixedSizePerElement(aSize: Integer): IwbArrayDef;
    function GetWronglyAssumedFixedSizePerElement: Integer;

    property Element: IwbValueDef
      read GetElement;
    property ElementCount: Integer
      read GetCount;

    property ElementLabel[aIndex: Integer]: string
      read GetElementLabel;
    property ElementNameSuffix[aIndex: Integer]: string
      read GetElementNameSuffix;

    property Sorted: Boolean
      read GetSorted;

    property CountCallBack: TwbCountCallback
      read GetCountCallback;
    property WronglyAssumedFixedSizePerElement: Integer
      read GetWronglyAssumedFixedSizePerElement;

    property CanAddTo: Boolean
      read GetCanAddTo;

    property PrefixSize[aBasePtr: Pointer]: Integer    // how many bytes of storage for the prefix
      read GetPrefixSize;
    property PrefixLength[aBasePtr: Pointer]: Integer  // Integer size of the prefix
      read GetPrefixLength;
    property PrefixCount[aBasePtr: Pointer]: Cardinal  // Value stored in the prefix
      read GetPrefixCount write SetPrefixCount;

    property CountPath: string
      read GetCountPath;
  end;

  IwbStructDef = interface(IwbValueDef)
    ['{9B20A03C-BC3F-433A-9781-E46BD5C660A9}']

    function GetMemberCount: Integer;
    function GetMember(aIndex: Integer): IwbValueDef;
    function GetMemberByName(const aName: string): IwbValueDef;
    function GetOptionalFromElement: Integer;

    property MemberCount: Integer read GetMemberCount;
    property Members[aIndex: Integer]: IwbValueDef read GetMember;
    property MembersByName[const aName: string]: IwbValueDef read GetMemberByName;
    property OptionalFromElement: Integer read GetOptionalFromElement;

    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbStructDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbStructDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbStructDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbStructDef;

    function SetSizeCallback(const aCallback: TwbStructSizeCallback): {Self}IwbStructDef;
  end;

  IwbStructCDef = interface(IwbStructDef)
    ['{B72FD1AD-018D-47D3-91E7-5028C5E0E759}']
    function GetSizing(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement;var CompressedSize: Integer): Cardinal;
    function GetChapterType(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
    function GetChapterTypeName(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string;
    function GetChapterName(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string;
  end;

  TwbStructCompression = (
    scNone,
    scZComp,
    scLZComp
  );

  IwbStructZDef = interface(IwbStructCDef) // Compressible structure !!! NOT SAFE FOR EDIT AT THE MOMEMNT !!!
    ['{8ED8E461-E4BB-494E-8A3B-B352A245B9A0}']
  end;

  IwbStructLZDef = interface(IwbStructZDef) // Compressible structure using LZ4 !!! NOT SAFE FOR EDIT AT THE MOMEMNT !!!
    ['{A5AB100F-83CA-4B53-B3CD-2BF926210900}']
  end;

  IwbIntegerDefFormater = interface(IwbDef)
    ['{56A6EB7B-3A90-4F09-8E80-D7399569DFCC}']
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string;
    function Check(aInt: Int64; const aElement: IwbElement): string;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement);

    function GetEditType(const aElement: IwbElement): TwbEditType;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
    function GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement;
    function FromLinksTo(const aValue, aElement: IwbElement): Int64;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;

    function MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64;
    procedure FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement);
    function CompareExchangeFormID(var aInt: Int64; aOldFormID: TwbFormID; aNewFormID: TwbFormID; const aElement: IwbElement): Boolean;

    function GetRequiresKey: Boolean;

    property IsEditable[aInt: Int64; const aElement: IwbElement]: Boolean
      read GetIsEditable;
    property LinksTo[aInt: Int64; const aElement: IwbElement]: IwbElement
      read GetLinksTo;

    property EditType[const aElement: IwbElement]: TwbEditType
      read GetEditType;
    property EditInfo[const aElement: IwbElement]: TwbStringArray
      read GetEditInfo;

    property RequiresKey: Boolean
      read GetRequiresKey;
  end;

  IwbIntegerDefFormaterUnion = interface(IwbIntegerDefFormater)
    ['{C04B1181-A570-41AE-A31E-7977B722EE0A}']
    function Decide(const aElement: IwbElement): IwbIntegerDefFormater;

    function GetMember(aIndex: Integer): IwbIntegerDefFormater;
    function GetMemberCount: Integer;

    property Members[aIndex: Integer]: IwbIntegerDefFormater read GetMember;
    property MemberCount: Integer read GetMemberCount;
  end;

  IwbDumpIntegerDefFormater = interface(IwbIntegerDefFormater)
    ['{9767F3EF-0E6F-45FB-AC9F-31A9B4312760}']
  end;

  IwbFormID = interface(IwbIntegerDefFormater)
    ['{71C4A255-B983-488C-9837-0A720132348A}']
    function GetMainRecord(aInt: Int64; const aElement: IwbElement): IwbMainRecord;
  end;

  IwbRefID = interface(IwbFormID)
    ['{F6EEAFDD-5AD7-4DB3-BF45-5D5DB53465D4}']
  end;

  IwbFormIDChecked = interface(IwbFormID)
    ['{DC7CBC9F-07EC-430B-94EE-ECE1867A2660}']
    function IsValid(const aSignature: TwbSignature): Boolean;
    function IsValidFlst(const aSignature: TwbSignature): Boolean;
    function CheckFlst(const aMainRecord: IwbMainRecord): Boolean;
    function IsValidMainRecord(const aMainRecord: IwbMainRecord): Boolean;

    function GetSignature(aIndex: Integer): TwbSignature;
    function GetSignatureCount: Integer;

    property Signatures[aIndex: Integer]: TwbSignature
      read GetSignature;
    property SignatureCount: Integer
      read GetSignatureCount;
  end;

  IwbChar4 = interface(IwbIntegerDefFormater)
    ['{CF657B3A-E7A6-48FE-AC68-8DF15962A531}']
  end;

  IwbStr4 = interface(IwbIntegerDefFormater)  // 4 bytes strings stored as itU32
    ['{2DC5200E-C1F1-47e7-A927-3D110D59F55A}']
  end;  // The interface handles swaping the character in readable order

  IwbStringDefFormater = interface(IwbDef)
    ['{56E03535-E34C-4AAC-B5C9-2ACB4E59B085}']
    function ToString(const aString: string; const aElement: IwbElement; aForSummary: Boolean): string;
    function ToSortKey(const aString: string; const aElement: IwbElement): string;
    function Check(const aString: string; const aElement: IwbElement): string;

    function GetEditType(const aElement: IwbElement): TwbEditType;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray;

    function ToEditValue(const aString: string; const aElement: IwbElement): string;
    function FromEditValue(const aValue: string; const aElement: IwbElement): string;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;

    property EditType[const aElement: IwbElement]: TwbEditType
      read GetEditType;
    property EditInfo[const aElement: IwbElement]: TwbStringArray
      read GetEditInfo;
  end;

  IwbFlagsDef = interface;

  IwbFlagDef = interface(IwbValueDef)
    ['{CCD4FBC4-D1CA-4B91-9E2F-6EE6118D5D07}']
    function GetFlagsDef: IwbFlagsDef;
    function GetFlagIndex: Integer;

    property FlagsDef: IwbFlagsDef
      read GetFlagsDef;
    property FlagIndex: Integer
      read GetFlagIndex;
  end;

  IwbFlagsDef = interface(IwbIntegerDefFormater)
    ['{EF564466-A671-453A-88CF-42A0AA32D849}']
    function GetBaseFlagsDef: IwbFlagsDef;
    function GetFlag(aIndex: Integer; aForSummary: Boolean): string;
    function GetFlagCount: Integer;
    function GetFlagIgnoreConflict(aIndex: Integer): Boolean;
    function GetFlagDontShow(const aElement: IwbElement; aIndex: Integer): Boolean;
    function GetFlagHasDontShow(aIndex: Integer): Boolean;
    procedure FlagGetCP(const aElement: IwbElement; aIndex: Integer; var aCP: TwbConflictPriority);
    function GetFlagHasGetCP(aIndex: Integer): Boolean;
    function GetFlagDef(aIndex : Integer): IwbFlagDef;
    function FindFlag(aName: string; out aFlagDef: IwbFlagDef): Boolean;

    function SetDontShowMaskPath(const aPath: string; aInvert: Boolean): IwbFlagsDef;
    function SetFlagHasDontShow(aIndex: Integer; const aDontShow: TwbDontShowCallback): IwbFlagsDef;

    property BaseFlagsDef: IwbFlagsDef
      read GetBaseFlagsDef;

    property Flags[aIndex: Integer; aForSummary: Boolean] : string
      read GetFlag;
    property FlagCount: Integer
      read GetFlagCount;

    property FlagIgnoreConflict[aIndex: Integer] : Boolean
      read GetFlagIgnoreConflict;

    property FlagDontShow[const aElement: IwbElement; aIndex: Integer]: Boolean
      read GetFlagDontShow;
    property FlagHasDontShow[aIndex: Integer]: Boolean
      read GetFlagHasDontShow;
    property FlagHasGetCP[aIndex: Integer]: Boolean
      read GetFlagHasGetCP;

    property FlagDef[aIndex: Integer]: IwbFlagDef
      read GetFlagDef;
  end;

  IwbEnumDef = interface(IwbIntegerDefFormater)
    ['{A3AFE02E-F72D-4E0E-BC56-219F7EE2B564}']

    function GetName(aIndex: Int64): string;
    function GetNameCount: Integer;

    function FindName(const aName: string; out aIndex: Int64): Boolean;

    property Names[aIndex: Int64]: string
      read GetName;
    property NameCount: Integer
      read GetNameCount;
  end;

  IwbKey2Data6EnumDef = interface(IwbEnumDef)
    ['{A74C58CC-6280-4143-B72B-4AD4F68A9957}']
  end;

  IwbData6Key2EnumDef = interface(IwbEnumDef)
    ['{AC7F99C9-9DF1-43BB-9052-6AD4B69E706F}']
  end;

  IwbCallbackDef = interface(IwbIntegerDefFormater)
    ['{BF6A0830-F981-4E0A-B4F2-2A09D575CD19}']
    function GetCallback: TwbIntToStrCallback;

    property Callback: TwbIntToStrCallback
      read GetCallback;
  end;

  IwbResourceContainer = interface;

  IwbResource = interface(IwbInterface)
    ['{B626E8BF-D2E3-40D1-8F3A-E6001D76B97B}']
    function GetContainer: IwbResourceContainer;
    function GetData: TBytes;

    property Container: IwbResourceContainer
      read GetContainer;
  end;

  TwbResourceDict = TDictionary<string, TwbNothing>;

  IwbResourceContainer = interface(IwbInterface)
    ['{023EA9C4-19B5-4587-B298-559EEF8F224E}']
    function GetName: string;
    function OpenResource(const aFileName: string): IwbResource;
    function ResourceExists(const aFileName: string): Boolean;
    procedure ResourceList(const aList: TStrings; aFolder: string = '');
    procedure ResourceDict(const aDict: TwbResourceDict; aFolder: string = '');

    property Name: string
      read GetName;
  end;

  IwbFolder = interface(IwbResourceContainer)
    ['{E71981ED-3C0C-4334-8476-116AEB0EEA1E}']
    function GetPathName: string;

    property PathName: string
      read GetPathName;
  end;

  IwbBSAFile = interface(IwbResourceContainer)
    ['{DC987017-9F5C-42D2-BAD2-E1A622E99081}']
    function GetFileName: string;

    property FileName: string
      read GetFileName;
  end;

  IwbBA2File = interface(IwbBSAFile)
    ['{D05EAAEC-8A23-4CDD-83E4-7593AC846CE3}']
    function GetVersion: Cardinal;

    property Version: Cardinal
      read GetVersion;
  end;

  TDynResources = array of IwbResource;

  IwbContainerHandler = interface(IwbInterface)
    ['{0CC80043-EADC-4C7D-8677-8719735582C7}']
    function AddFolder(const aPath: string): IwbResourceContainer;
    function AddBSA(const aFileName: string): IwbResourceContainer;
    function AddBA2(const aFileName: string): IwbResourceContainer;

    function OpenResource(const aFileName: string): TDynResources;
    function OpenResourceData(const aContainerName, aFileName: string): TBytes;

    function ContainerExists(aContainerName: string): Boolean;
    procedure ContainerList(const aList: TStrings);
    procedure ContainerResourceList(const aContainerName: string; const aList: TStrings; const aFolder: string = '');
    procedure ContainerResourceDict(const aContainerName: string; const aDict: TwbResourceDict; const aFolder: string = '');

    function ResourceExists(const aFileName: string): Boolean;
    function ResourceCount(const aFileName: string; aContainers: TStrings = nil): Integer;
    procedure ResourceCopy(const aContainerName, aFileName, aPathOut: string);

    procedure EnsureCache;

    function ResolveFolderHash(const aHash: Int64): string;
    function ResolveFileHash(const aHash: Int64): string;
  end;

const
  arcU32 = -1;
  arcU16 = -2;
  arcU8  = -4;

var
  SortedElementTypes : set of TwbElementType = [
    etFile,
    etMainRecord,
    etGroupRecord,
    etSubRecord,
    etSubRecordArray,
    etArray
  ];
  wbModuleExtensions : TwbModuleExtensions;
  wbSaveExtensions : TwbSaveExtensions;

const
  AllElementTypes = [Low(TwbElementType)..High(TwbElementType)];

var
  wbIdxEditorID: TwbNamedIndex;

function wbNamedIndex(const aName          : string;
                            aCaseSensitive : Boolean)
                                           : TwbNamedIndex;

function wbNamedIndexName(aIndex : TwbNamedIndex)
                                 : string;


function wbNamedIndexComparer(aIndex: TwbNamedIndex): IwbNamedIndexEqualityComparer;

function wbRecord(const aSignature      : TwbSignature;
                  const aName           : string;
                  const aMembers        : array of IwbRecordMemberDef;
                        aAllowUnordered : Boolean = False;
                        aAddInfoCallback: TwbAddInfoCallback = nil;
                        aPriority       : TwbConflictPriority = cpNormal;
                        aRequired       : Boolean = False;
                        aAfterLoad      : TwbAfterLoadCallback = nil;
                        aAfterSet       : TwbAfterSetCallback = nil)
                                        : IwbMainRecordDef; overload;

function wbRecord(const aSignature      : TwbSignature;
                  const aName           : string;
                  const aRecordFlags    : IwbIntegerDefFormater;
                  const aMembers        : array of IwbRecordMemberDef;
                        aAllowUnordered : Boolean = False;
                        aAddInfoCallback: TwbAddInfoCallback = nil;
                        aPriority       : TwbConflictPriority = cpNormal;
                        aRequired       : Boolean = False;
                        aAfterLoad      : TwbAfterLoadCallback = nil;
                        aAfterSet       : TwbAfterSetCallback = nil)
                                        : IwbMainRecordDef; overload;

function wbRecord(const aSignature      : TwbSignature;
                  const aName           : string;
                  const aKnownSRs       : PwbKnownSubRecordSignatures;
                  const aMembers        : array of IwbRecordMemberDef;
                        aAllowUnordered : Boolean = False;
                        aAddInfoCallback: TwbAddInfoCallback = nil;
                        aPriority       : TwbConflictPriority = cpNormal;
                        aRequired       : Boolean = False;
                        aAfterLoad      : TwbAfterLoadCallback = nil;
                        aAfterSet       : TwbAfterSetCallback = nil)
                                        : IwbMainRecordDef; overload;

function wbRecord(const aSignature      : TwbSignature;
                  const aName           : string;
                  const aKnownSRs       : PwbKnownSubRecordSignatures;
                  const aRecordFlags    : IwbIntegerDefFormater;
                  const aMembers        : array of IwbRecordMemberDef;
                        aAllowUnordered : Boolean = False;
                        aAddInfoCallback: TwbAddInfoCallback = nil;
                        aPriority       : TwbConflictPriority = cpNormal;
                        aRequired       : Boolean = False;
                        aAfterLoad      : TwbAfterLoadCallback = nil;
                        aAfterSet       : TwbAfterSetCallback = nil)
                                        : IwbMainRecordDef; overload;

function wbRefRecord(const aSignature      : TwbSignature;
                     const aName           : string;
                     const aMembers        : array of IwbRecordMemberDef;
                           aAllowUnordered : Boolean = False;
                           aAddInfoCallback: TwbAddInfoCallback = nil;
                           aPriority       : TwbConflictPriority = cpNormal;
                           aRequired       : Boolean = False;
                           aAfterLoad      : TwbAfterLoadCallback = nil;
                           aAfterSet       : TwbAfterSetCallback = nil)
                                           : IwbMainRecordDef; overload;

function wbRefRecord(const aSignature      : TwbSignature;
                     const aName           : string;
                     const aRecordFlags    : IwbIntegerDefFormater;
                     const aMembers        : array of IwbRecordMemberDef;
                           aAllowUnordered : Boolean = False;
                           aAddInfoCallback: TwbAddInfoCallback = nil;
                           aPriority       : TwbConflictPriority = cpNormal;
                           aRequired       : Boolean = False;
                           aAfterLoad      : TwbAfterLoadCallback = nil;
                           aAfterSet       : TwbAfterSetCallback = nil)
                                           : IwbMainRecordDef; overload;

function wbSubRecord(const aSignature : TwbSignature;
                     const aName      : string;
                     const aValue     : IwbValueDef;
                           aAfterLoad : TwbAfterLoadCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aSizeMatch : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;

function wbSubRecord(const aSignatures : TwbSignatures;
                     const aName       : string;
                     const aValue      : IwbValueDef;
                           aAfterLoad  : TwbAfterLoadCallback = nil;
                           aAfterSet   : TwbAfterSetCallback = nil;
                           aPriority   : TwbConflictPriority = cpNormal;
                           aRequired   : Boolean = False;
                           aSizeMatch  : Boolean = False;
                           aDontShow   : TwbDontShowCallback = nil;
                           aGetCP      : TwbGetConflictPriority = nil)
                                       : IwbSubRecordDef; overload;

function wbString(const aSignature : TwbSignature;
                  const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithBaseStringDef; overload;

function wbString(const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbStringDef; overload;

function wbStringForward(const aSignature : TwbSignature;           // When the editor can leave chars after the ending #0
                         const aName      : string = 'Unknown';
                               aSize      : Integer = 0;
                               aPriority  : TwbConflictPriority = cpNormal;
                               aRequired  : Boolean = False;
                               aDontShow  : TwbDontShowCallback = nil;
                               aAfterSet  : TwbAfterSetCallback = nil;
                               aGetCP     : TwbGetConflictPriority = nil)
                                          : IwbSubRecordWithBaseStringDef; overload;

function wbString(      aForward   : Boolean = False;
                  const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbStringDef; overload;

function wbStringT(const aSignature : TwbSignature;
                   const aName      : string = 'Unknown';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithBaseStringDef; overload;

function wbStringT(const aName      : string = 'Unknown';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbStringDef; overload;

function wbStringScript(const aSignature : TwbSignature;
                        const aName      : string;
                              aSize      : Integer = 0;
                              aPriority  : TwbConflictPriority = cpNormal;
                              aRequired  : Boolean = False;
                              aDontShow  : TwbDontShowCallback = nil;
                              aAfterSet  : TwbAfterSetCallback = nil;
                              aGetCP     : TwbGetConflictPriority = nil)
                                         : IwbSubRecordWithBaseStringDef; overload;

function wbStringScript(const aName      : string;
                              aSize      : Integer = 0;
                              aPriority  : TwbConflictPriority = cpNormal;
                              aRequired  : Boolean = False;
                              aDontShow  : TwbDontShowCallback = nil;
                              aAfterSet  : TwbAfterSetCallback = nil;
                              aGetCP     : TwbGetConflictPriority = nil)
                                         : IwbStringDef; overload;

function wbStringLC(const aSignature : TwbSignature;
                    const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordWithBaseStringDef; overload;

function wbStringLC(const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbStringDef; overload;

function wbStringKC(const aSignature : TwbSignature;
                    const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordWithBaseStringDef; overload;

function wbStringKC(const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbStringDef; overload;

function wbLString(const aSignature : TwbSignature;
                   const aName      : string = '';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithBaseStringDef; overload;

function wbLString(const aName      : string;
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbStringDef; overload;

function wbLStringKC(const aSignature : TwbSignature;
                     const aName      : string;
                           aSize      : Integer = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithBaseStringDef; overload;

function wbLStringKC(const aName      : string;
                           aSize      : Integer = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbStringDef; overload;

function wbStringMgefCode(const aSignature : TwbSignature;
                          const aName      : string;
                                aSize      : Integer = 0;
                                aPriority  : TwbConflictPriority = cpNormal;
                                aRequired  : Boolean = False;
                                aDontShow  : TwbDontShowCallback = nil;
                                aAfterSet  : TwbAfterSetCallback = nil;
                                aGetCP     : TwbGetConflictPriority = nil)
                                           : IwbSubRecordWithBaseStringDef; overload;

function wbStringMgefCode(const aName      : string;
                                aSize      : Integer = 0;
                                aPriority  : TwbConflictPriority = cpNormal;
                                aRequired  : Boolean = False;
                                aDontShow  : TwbDontShowCallback = nil;
                                aAfterSet  : TwbAfterSetCallback = nil;
                                aGetCP     : TwbGetConflictPriority = nil)
                                           : IwbStringDef; overload;

function wbLenString(const aSignature : TwbSignature;
                     const aName      : string = 'Unknown';
                           aPrefix    : Integer = 4;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithBaseStringDef; overload;

function wbLenString(const aName      : string = 'Unknown';
                           aPrefix    : Integer = 4;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbLenStringDef; overload;

function wbLenStringT(const aSignature : TwbSignature;
                      const aName      : string;
                            aPrefix    : Integer = 4;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbSubRecordWithBaseStringDef; overload;

function wbLenStringT(const aName      : string;
                            aPrefix    : Integer = 4;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbLenStringDef; overload;
function wbUnion(const aSignature : TwbSignature;
                 const aName      : string;
                       aDecider   : TwbUnionDecider;
                 const aMembers   : array of IwbValueDef;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef; overload;

function wbUnion(const aName     : string;
                       aDecider  : TwbUnionDecider;
                 const aMembers  : array of IwbValueDef;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aAfterSet : TwbAfterSetCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbUnionDef; overload;

function wbRecursive(const aName     : string;
                           aLevelsUp : Integer;
                           aPriority : TwbConflictPriority = cpNormal;
                           aRequired : Boolean = False;
                           aDontShow : TwbDontShowCallback = nil;
                           aAfterSet : TwbAfterSetCallback = nil;
                           aGetCP    : TwbGetConflictPriority = nil)
                                     : IwbRecursiveDef;

function wbByteArray(const aSignature : TwbSignature;
                     const aName      : string = 'Unknown';
                           aSize      : Int64 = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aSizeMatch : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;

function wbByteArray(const aName      : string = 'Unknown';
                           aSize      : Int64 = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbByteArrayDef; overload;

function wbByteArrayT(const aName      : string = 'Unknown';
                            aSize      : Int64 = 0;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbByteArrayDef; overload;

function wbByteArray(const aName          : string;
                           aCountCallback : TwbCountCallback;
                           aPriority      : TwbConflictPriority = cpNormal;
                           aRequired      : Boolean = False;
                           aDontShow      : TwbDontShowCallback = nil;
                           aGetCP         : TwbGetConflictPriority = nil)
                                          : IwbByteArrayDef; overload;

function wbReflection(const aSignature : TwbSignature;
                      const aName      : string = 'Unknown Reflection';
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired      : Boolean = False)
                                       : IwbSubRecordDef; overload;

function wbReflection(const aName      : string = 'Unknown Reflection';
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired      : Boolean = False)
                                       : IwbReflectionDef; overload;

function wbUnknown(const aSignature : TwbSignature;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbUnknown(aPriority : TwbConflictPriority = cpNormal;
                   aRequired : Boolean = False;
                   aDontShow : TwbDontShowCallback = nil;
                   aGetCP    : TwbGetConflictPriority = nil)
                             : IwbByteArrayDef; overload;

function wbUnknown(const aSignature : TwbSignature;
                         aSize      : Integer;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbUnknown(aSize     : Integer;
                   aPriority : TwbConflictPriority = cpNormal;
                   aRequired : Boolean = False;
                   aDontShow : TwbDontShowCallback = nil;
                   aGetCP    : TwbGetConflictPriority = nil)
                             : IwbByteArrayDef; overload;

function wbNeverShow(const aElement: IwbElement): Boolean;

function wbUnused(const aSignature : TwbSignature;
                        aRequired  : Boolean = False)
                                   : IwbSubRecordDef; overload;

function wbUnused(aRequired : Boolean = False)
                            : IwbValueDef; overload;

function wbUnused(const aSignature : TwbSignature;
                        aSize      : Integer;
                        aRequired  : Boolean = False)
                                   : IwbSubRecordDef; overload;

function wbUnused(aSize     : Integer;
                  aRequired : Boolean = False)
                            : IwbValueDef; overload;

function wbInteger(const aSignature : TwbSignature;
                   const aName      : string;
                   const aIntType   : TwbIntType;
                   const aFormater  : IwbIntegerDefFormater = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aMatchSize : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDefault   : Int64 = 0;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbInteger(const aName     : string;
                   const aIntType  : TwbIntType;
                   const aFormater : IwbIntegerDefFormater = nil;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aAfterSet : TwbAfterSetCallback = nil;
                         aDefault  : Int64 = 0;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;

function wbInteger(const aSignature : TwbSignature;
                   const aName      : string;
                   const aIntType   : TwbIntType;
                   const aToStr     : TwbIntToStrCallback;
                   const aToInt     : TwbStrToIntCallback = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDefault   : Int64 = 0;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbInteger(const aName     : string;
                   const aIntType  : TwbIntType;
                   const aToStr    : TwbIntToStrCallback;
                   const aToInt    : TwbStrToIntCallback = nil;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aAfterSet : TwbAfterSetCallback = nil;
                         aDefault  : Int64 = 0;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;


function wbIntegerT(const aSignature : TwbSignature;
                    const aName      : string;
                    const aIntType   : TwbIntType;
                    const aFormater  : IwbIntegerDefFormater = nil;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aMatchSize : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aDefault   : Int64 = 0;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;

function wbIntegerT(const aName     : string;
                    const aIntType  : TwbIntType;
                    const aFormater : IwbIntegerDefFormater = nil;
                          aPriority : TwbConflictPriority = cpNormal;
                          aRequired : Boolean = False;
                          aDontShow : TwbDontShowCallback = nil;
                          aAfterSet : TwbAfterSetCallback = nil;
                          aDefault  : Int64= 0;
                          aGetCP    : TwbGetConflictPriority = nil)
                                    : IwbIntegerDef; overload;

function wbIntegerT(const aSignature : TwbSignature;
                    const aName      : string;
                    const aIntType   : TwbIntType;
                    const aToStr     : TwbIntToStrCallback;
                    const aToInt     : TwbStrToIntCallback = nil;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aDefault   : Int64 = 0;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;

function wbIntegerT(const aName     : string;
                    const aIntType  : TwbIntType;
                    const aToStr    : TwbIntToStrCallback;
                    const aToInt    : TwbStrToIntCallback = nil;
                          aPriority : TwbConflictPriority = cpNormal;
                          aRequired : Boolean = False;
                          aDontShow : TwbDontShowCallback = nil;
                          aAfterSet : TwbAfterSetCallback = nil;
                          aDefault  : Int64 = 0;
                          aGetCP    : TwbGetConflictPriority = nil)
                                    : IwbIntegerDef; overload;

function wbHalf(const aSignature  : TwbSignature;
                const aName       : string = 'Unknown';
                      aPriority   : TwbConflictPriority = cpNormal;
                      aRequired   : Boolean = False;
                      aScale      : Extended = 1.0;
                      aDigits     : Integer = -1;
                      aDontShow   : TwbDontShowCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef; overload;

function wbHalf(const aName       : string = 'Unknown';
                      aPriority   : TwbConflictPriority = cpNormal;
                      aRequired   : Boolean = False;
                      aScale      : Extended = 1.0;
                      aDigits     : Integer = -1;
                      aDontShow   : TwbDontShowCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbFloatDef; overload;

function wbHalf(const aName       : string;
                      aPriority   : TwbConflictPriority;
                      aRequired   : Boolean;
                      aDontShow   : TwbDontShowCallback;
                      aAfterSet   : TwbAfterSetCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbFloatDef; overload;

function wbFloat(const aSignature  : TwbSignature;
                 const aName       : string = 'Unknown';
                       aPriority   : TwbConflictPriority = cpNormal;
                       aRequired   : Boolean = False;
                       aScale      : Extended = 1.0;
                       aDigits     : Integer = -1;
                       aDontShow   : TwbDontShowCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef; overload;

function wbFloat(const aName       : string = 'Unknown';
                       aPriority   : TwbConflictPriority = cpNormal;
                       aRequired   : Boolean = False;
                       aScale      : Extended = 1.0;
                       aDigits     : Integer = -1;
                       aDontShow   : TwbDontShowCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbFloatDef; overload;

function wbFloat(const aName       : string;
                       aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                       aDontShow   : TwbDontShowCallback;
                       aAfterSet   : TwbAfterSetCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbFloatDef; overload;

function wbFloatAngle(const aSignature  : TwbSignature;
                      const aName       : string = 'Unknown Angle';
                            aPriority   : TwbConflictPriority = cpNormal;
                            aRequired   : Boolean = False;
                            aDontShow   : TwbDontShowCallback = nil;
                            aDefault    : Extended = 0.0;
                            aGetCP      : TwbGetConflictPriority = nil)
                                        : IwbSubRecordDef; overload;

function wbFloatAngle(const aName       : string = 'Unknown Angle';
                            aPriority   : TwbConflictPriority = cpNormal;
                            aRequired   : Boolean = False;
                            aDontShow   : TwbDontShowCallback = nil;
                            aDefault    : Extended = 0.0;
                            aGetCP      : TwbGetConflictPriority = nil)
                                        : IwbFloatDef; overload;

function wbDouble(const aSignature  : TwbSignature;
                  const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbDouble(const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;

function wbDouble(const aName       : string;
                        aPriority   : TwbConflictPriority;
                        aRequired   : Boolean;
                        aDontShow   : TwbDontShowCallback;
                        aAfterSet   : TwbAfterSetCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;

function wbFloatT(const aSignature  : TwbSignature;
                  const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;

function wbFloatT(const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;

function wbFloatT(const aName       : string;
                        aPriority   : TwbConflictPriority;
                        aRequired   : Boolean;
                        aDontShow   : TwbDontShowCallback;
                        aAfterSet   : TwbAfterSetCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;

function wbDoubleT(const aSignature  : TwbSignature;
                   const aName       : string = 'Unknown';
                         aPriority   : TwbConflictPriority = cpNormal;
                         aRequired   : Boolean = False;
                         aScale      : Extended = 1.0;
                         aDigits     : Integer = -1;
                         aDontShow   : TwbDontShowCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;

function wbDoubleT(const aName       : string = 'Unknown';
                         aPriority   : TwbConflictPriority = cpNormal;
                         aRequired   : Boolean = False;
                         aScale      : Extended = 1.0;
                         aDigits     : Integer = -1;
                         aDontShow   : TwbDontShowCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbFloatDef; overload;

function wbDoubleT(const aName       : string;
                         aPriority   : TwbConflictPriority;
                         aRequired   : Boolean;
                         aDontShow   : TwbDontShowCallback;
                         aAfterSet   : TwbAfterSetCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbFloatDef; overload;

{--- wbArray - list of identical elements -------------------------------------}
function wbArray(const aSignature : TwbSignature;
                 const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer = 0;
                       aAfterLoad : TwbAfterLoadCallback = nil;
                       aAfterSet  : TwbAfterSetCallback = nil;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordWithArrayDef; overload;

function wbArray(const aName     : string;
                 const aElement  : IwbValueDef;
                       aCount    : Integer = 0;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbArrayDef; overload;

function wbArray(const aName     : string;
                 const aElement  : IwbValueDef;
                       aCount    : Integer;
                 const aLabels   : array of string;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbArrayDef; overload;

function wbArray(const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer;
                       aAfterLoad : TwbAfterLoadCallback;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbArrayDef; overload;

function wbArray(const aSignature : TwbSignature;
                 const aName      : string;
                 const aElement   : IwbValueDef;
                 const aLabels    : array of string;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordWithArrayDef; overload;

function wbArray(const aSignature     : TwbSignature;
                 const aName          : string;
                 const aElement       : IwbValueDef;
                 const aLabels        : array of string;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithArrayDef; overload;

function wbArray(const aName     : string;
                 const aElement  : IwbValueDef;
                 const aLabels   : array of string;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbArrayDef; overload;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                 const aLabels        : array of string;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;

function wbArrayPT(const aSignature : TwbSignature;   // case where the prefix is terminated.
                   const aName      : string;
                   const aElement   : IwbValueDef;
                         aCount     : Integer = 0;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithArrayDef; overload;

function wbArrayPT(const aName     : string;
                   const aElement  : IwbValueDef;
                         aCount    : Integer = 0;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;

function wbArrayPT(const aName      : string;
                   const aElement   : IwbValueDef;
                         aCount     : Integer;
                         aAfterLoad : TwbAfterLoadCallback;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbArrayDef; overload;

function wbArrayT(const aName      : string;   // case where members are not terminated, but the array itself yes
                  const aElement   : IwbValueDef;
                        aCount     : Integer;
                  const aLabels    : array of string;
                        aAfterLoad : TwbAfterLoadCallback;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;

function wbArrayPT(const aSignature : TwbSignature;
                   const aName      : string;
                   const aElement   : IwbValueDef;
                   const aLabels    : array of string;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithArrayDef; overload;

function wbArrayPT(const aSignature     : TwbSignature;
                   const aName          : string;
                   const aElement       : IwbValueDef;
                   const aLabels        : array of string;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbSubRecordWithArrayDef; overload;

function wbArrayPT(const aName     : string;
                   const aElement  : IwbValueDef;
                   const aLabels   : array of string;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;

function wbArrayPT(const aName          : string;
                   const aElement       : IwbValueDef;
                   const aLabels        : array of string;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbArrayDef; overload;

function wbArrayT(const aName          : string;   // case where members are not terminated, but the array itself yes
                  const aElement       : IwbValueDef;
                  const aLabels        : array of string;
                        aCountCallback : TwbCountCallback;
                        aPriority      : TwbConflictPriority = cpNormal;
                        aRequired      : Boolean = False;
                        aDontShow      : TwbDontShowCallback = nil;
                        aGetCP         : TwbGetConflictPriority = nil)
                                       : IwbArrayDef; overload;

function wbArrayPT(const aName          : string;
                   const aElement       : IwbValueDef;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbArrayDef; overload;

function wbRArray(const aName      : string;
                  const aElement   : IwbRecordMemberDef;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordArrayDef; overload;

function wbRArray(const aName      : string;
                  const aElement   : IwbRecordMemberDef;
                        aCount     : Integer; //fixed count
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordArrayDef; overload;


function wbArrayS(const aSignature : TwbSignature;
                  const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithArrayDef; overload;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aCanAddTo  : Boolean = True;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer;
                        aAfterLoad : TwbAfterLoadCallback;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;

function wbArrayS(const aName          : string;
                  const aElement       : IwbValueDef;
                        aCountCallback : TwbCountCallback;
                        aPriority      : TwbConflictPriority = cpNormal;
                        aRequired      : Boolean = False;
                        aAfterLoad     : TwbAfterLoadCallback = nil;
                        aAfterSet      : TwbAfterSetCallback = nil;
                        aDontShow      : TwbDontShowCallback = nil;
                        aGetCP         : TwbGetConflictPriority = nil)
                                       : IwbArrayDef; overload;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority;
                       aRequired      : Boolean;
                       aAfterLoad     : TwbAfterLoadCallback;
                       aAfterSet      : TwbAfterSetCallback;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;

function wbArrayS(const aSignature : TwbSignature;
                  const aName      : string;
                  const aElement   : IwbValueDef;
                  const aLabels    : array of string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithArrayDef; overload;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                  const aLabels    : array of string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;


function wbRArrayS(const aName      : string;
                   const aElement   : IwbRecordMemberDef;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDontShow  : TwbDontShowCallback = nil;
                         aIsSorted  : TwbIsSortedCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordArrayDef; overload;

function wbRArrayS(const aName      : string;
                   const aElement   : IwbRecordMemberDef;
                         aCount     : Integer;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDontShow  : TwbDontShowCallback = nil;
                         aIsSorted  : TwbIsSortedCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordArrayDef; overload;


{--- wbStruct - ordered list of members ----------------------------------------}
function wbStructSK(const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;

function wbStructSK(const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                    {$IFDEF WIN32}
                    const aElementMap          : array of Cardinal;
                    {$ENDIF WIN32}
                    {$IFDEF WIN64}
                    const aElementMap          : array of UInt64;
                    {$ENDIF WIN64}
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;

function wbStructSK(const aSignature           : TwbSignature;
                    const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbSubRecordWithStructDef; overload;

function wbMultiStructSK(const aSignatures          : TwbSignatures;
                         const aSortKey             : array of Integer;
                         const aName                : string;
                         const aMembers             : array of IwbValueDef;
                               aPriority            : TwbConflictPriority = cpNormal;
                               aRequired            : Boolean = False;
                               aDontShow            : TwbDontShowCallback = nil;
                               aOptionalFromElement : Integer = -1;
                               aAfterLoad           : TwbAfterLoadCallback = nil;
                               aAfterSet            : TwbAfterSetCallback = nil;
                               aGetCP               : TwbGetConflictPriority = nil)
                                                    : IwbSubRecordWithStructDef;

function wbStructExSK(const aSortKey             : array of Integer;
                      const aExSortKey           : array of Integer;
                      const aName                : string;
                      const aMembers             : array of IwbValueDef;
                            aPriority            : TwbConflictPriority = cpNormal;
                            aRequired            : Boolean = False;
                            aDontShow            : TwbDontShowCallback = nil;
                            aOptionalFromElement : Integer = -1;
                            aAfterLoad           : TwbAfterLoadCallback = nil;
                            aAfterSet            : TwbAfterSetCallback = nil;
                            aGetCP               : TwbGetConflictPriority = nil)
                                                 : IwbStructDef; overload;

function wbStructExSK(const aSignature           : TwbSignature;
                      const aSortKey             : array of Integer;
                      const aExSortKey           : array of Integer;
                      const aName                : string;
                      const aMembers             : array of IwbValueDef;
                            aPriority            : TwbConflictPriority = cpNormal;
                            aRequired            : Boolean = False;
                            aDontShow            : TwbDontShowCallback = nil;
                            aOptionalFromElement : Integer = -1;
                            aAfterLoad           : TwbAfterLoadCallback = nil;
                            aAfterSet            : TwbAfterSetCallback = nil;
                            aGetCP               : TwbGetConflictPriority = nil)
                                                 : IwbSubRecordWithStructDef; overload;

function wbStruct(const aSignature           : TwbSignature;
                  const aName                : string;
                  const aMembers             : array of IwbValueDef;
                        aPriority            : TwbConflictPriority = cpNormal;
                        aRequired            : Boolean = False;
                        aDontShow            : TwbDontShowCallback = nil;
                        aOptionalFromElement : Integer = -1;
                        aAfterLoad           : TwbAfterLoadCallback = nil;
                        aAfterSet            : TwbAfterSetCallback = nil;
                        aGetCP               : TwbGetConflictPriority = nil)
                                             : IwbSubRecordWithStructDef; overload;

function wbStruct(const aName                : string;
                  const aMembers             : array of IwbValueDef;
                        aPriority            : TwbConflictPriority = cpNormal;
                        aRequired            : Boolean = False;
                        aDontShow            : TwbDontShowCallback = nil;
                        aOptionalFromElement : Integer = -1;
                        aAfterLoad           : TwbAfterLoadCallback = nil;
                        aAfterSet            : TwbAfterSetCallback = nil;
                        aGetCP               : TwbGetConflictPriority = nil)
                                             : IwbStructDef; overload;

function wbStructC(const aName                : string;
                         aSizing              : TwbSizeCallback;
                         aGetChapterType      : TwbGetChapterTypeCallback;
                         aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                         aGetChapterName      : TwbGetChapterNameCallback;
                   const aMembers             : array of IwbValueDef;
                         aPriority            : TwbConflictPriority = cpNormal;
                         aRequired            : Boolean = False;
                         aDontShow            : TwbDontShowCallback = nil;
                         aOptionalFromElement : Integer = -1;
                         aAfterLoad           : TwbAfterLoadCallback = nil;
                         aAfterSet            : TwbAfterSetCallback = nil;
                         aGetCP               : TwbGetConflictPriority = nil)
                                              : IwbStructDef; overload;

function wbStructZ(const aName                : string;
                         aSizing              : TwbSizeCallback;
                         aGetChapterType      : TwbGetChapterTypeCallback;
                         aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                         aGetChapterName      : TwbGetChapterNameCallback;
                   const aMembers             : array of IwbValueDef;
                         aPriority            : TwbConflictPriority = cpNormal;
                         aRequired            : Boolean = False;
                         aDontShow            : TwbDontShowCallback = nil;
                         aOptionalFromElement : Integer = -1;
                         aAfterLoad           : TwbAfterLoadCallback = nil;
                         aAfterSet            : TwbAfterSetCallback = nil;
                         aGetCP               : TwbGetConflictPriority = nil)
                                              : IwbStructDef; overload;

function wbStructLZ(const aName                : string;
                          aSizing              : TwbSizeCallback;
                          aGetChapterType      : TwbGetChapterTypeCallback;
                          aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                          aGetChapterName      : TwbGetChapterNameCallback;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;

function wbRStruct(const aName           : string;
                   const aMembers        : array of IwbRecordMemberDef;
                   const aSkipSigs       : TwbSignatures = nil;
                         aPriority       : TwbConflictPriority = cpNormal;
                         aRequired       : Boolean = False;
                         aDontShow       : TwbDontShowCallback = nil;
                         aAllowUnordered : Boolean = False;
                         aAfterLoad      : TwbAfterLoadCallback = nil;
                         aAfterSet       : TwbAfterSetCallback = nil;
                         aGetCP          : TwbGetConflictPriority = nil)
                                         : IwbSubRecordStructDef; overload;

function wbRStructSK(const aSortKey        : array of Integer;
                     const aName           : string;
                     const aMembers        : array of IwbRecordMemberDef;
                     const aSkipSigs       : TwbSignatures = nil;
                           aPriority       : TwbConflictPriority = cpNormal;
                           aRequired       : Boolean = False;
                           aDontShow       : TwbDontShowCallback = nil;
                           aAllowUnordered : Boolean = False;
                           aAfterLoad      : TwbAfterLoadCallback = nil;
                           aAfterSet       : TwbAfterSetCallback = nil;
                           aGetCP          : TwbGetConflictPriority = nil)
                                           : IwbSubRecordStructDef; overload;

function wbRStructExSK(const aSortKey        : array of Integer;
                       const aExSortKey      : array of Integer;
                       const aName           : string;
                       const aMembers        : array of IwbRecordMemberDef;
                       const aSkipSigs       : TwbSignatures = nil;
                             aPriority       : TwbConflictPriority = cpNormal;
                             aRequired       : Boolean = False;
                             aDontShow       : TwbDontShowCallback = nil;
                             aAllowUnordered : Boolean = False;
                             aAfterLoad      : TwbAfterLoadCallback = nil;
                             aAfterSet       : TwbAfterSetCallback = nil;
                             aGetCP          : TwbGetConflictPriority = nil)
                                             : IwbSubRecordStructDef; overload;

function wbRUnion(const aName     : string;
                  const aMembers  : array of IwbRecordMemberDef;
                  const aSkipSigs : TwbSignatures = nil;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aGetCP    : TwbGetConflictPriority = nil)
                                  : IwbSubRecordUnionDef; overload;

function wbRUnion(const aName     : string;
                  const aDecider  : TwbRUnionDecider; //called with the container of the RUnion
                  const aMembers  : array of IwbRecordMemberDef;
                  const aSkipSigs : TwbSignatures = nil;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aGetCP    : TwbGetConflictPriority = nil)
                                  : IwbSubRecordUnionDef; overload;


{--- wbStructS - array of struct ----------------------------------------------}
function wbStructs(const aSignature   : TwbSignature;
                   const aName        : string;
                   const aElementName : string;
                   const aMembers     : array of IwbValueDef;
                         aPriority    : TwbConflictPriority = cpNormal;
                         aRequired    : Boolean = False;
                         aDontShow    : TwbDontShowCallback = nil;
                         aGetCP       : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;

function wbStructs(const aName        : string;
                   const aElementName : string;
                   const aMembers     : array of IwbValueDef;
                         aPriority    : TwbConflictPriority = cpNormal;
                         aRequired    : Boolean = False;
                         aDontShow    : TwbDontShowCallback = nil;
                         aGetCP       : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;

function wbRStructs(const aName        : string;
                    const aElementName : string;
                    const aMembers     : array of IwbRecordMemberDef;
                    const aSkipSigs    : TwbSignatures = nil;
                          aPriority    : TwbConflictPriority = cpNormal;
                          aRequired    : Boolean = False;
                          aDontShow    : TwbDontShowCallback = nil;
                          aGetCP       : TwbGetConflictPriority = nil)
                                       : IwbSubRecordArrayDef; overload;

function wbRStructsSK(const aName        : string;
                      const aElementName : string;
                      const aSortKey     : array of Integer;
                      const aMembers     : array of IwbRecordMemberDef;
                      const aSkipSigs    : TwbSignatures = nil;
                            aPriority    : TwbConflictPriority = cpNormal;
                            aRequired    : Boolean = False;
                            aAfterLoad   : TwbAfterLoadCallback = nil;
                            aAfterSet    : TwbAfterSetCallback = nil;
                            aDontShow    : TwbDontShowCallback = nil;
                            aGetCP       : TwbGetConflictPriority = nil)
                                         : IwbSubRecordArrayDef; overload;

function wbEmpty(const aSignature : TwbSignature;
                 const aName      : string = 'Unknown';
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef; overload;

function wbEmpty(const aName      : string = 'Unknown';
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aSorted    : Boolean = False;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbValueDef; overload;

function wbMarker(const aSignature : TwbSignature;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef; overload;

function wbMarker(aPriority  : TwbConflictPriority = cpNormal;
                  aRequired  : Boolean = False;
                  aDontShow  : TwbDontShowCallback = nil;
                  aSorted    : Boolean = False;
                  aGetCP     : TwbGetConflictPriority = nil)
                             : IwbValueDef; overload;

function wbMarkerReq(const aSignature : TwbSignature;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;

function wbMarkerReq(aPriority  : TwbConflictPriority = cpNormal;
                     aDontShow  : TwbDontShowCallback = nil;
                     aSorted    : Boolean = False;
                     aGetCP     : TwbGetConflictPriority = nil)
                                : IwbValueDef; overload;

function wbGUID(const aSignature : TwbSignature;
                const aName      : string = 'Unknown';
                      aPriority  : TwbConflictPriority = cpNormal;
                      aRequired  : Boolean = False;
                      aDontShow  : TwbDontShowCallback = nil;
                      aGetCP     : TwbGetConflictPriority = nil)
                                 : IwbSubRecordDef; overload;

function wbGUID(const aName      : string = 'Unknown';
                      aPriority  : TwbConflictPriority = cpNormal;
                      aRequired  : Boolean = False;
                      aDontShow  : TwbDontShowCallback = nil;
                      aGetCP     : TwbGetConflictPriority = nil)
                                 : IwbGuidDef; overload;

function wbRefID: IwbRefID; overload;

function wbRefID(const aName      : string;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aAfterSet  : TwbAfterSetCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbIntegerDef; overload;

function wbRefIDT(const aName      : string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;

function wbDumpInteger : IwbIntegerDefFormater; overload;

function wbKey2Data6Enum(const aNames : array of string)
                                      : IwbKey2Data6EnumDef; overload;

function wbData6Key2Enum(const aNames : array of string)
                                      : IwbData6Key2EnumDef; overload;

function wbFormID: IwbFormID; overload;

function wbFormID(const aValidRefs : TwbSignatures;
                        aPersistent: Boolean)
                                   : IwbFormID; overload;

function wbFormIDNoReach(const aValidRefs  : TwbSignatures;
                               aPersistent : Boolean)
                                           : IwbFormID; overload;

function wbFormID(const aValidRefs     : TwbSignatures;
                  const aValidFlstRefs : TwbSignatures;
                        aPersistent    : Boolean)
                                       : IwbFormID; overload;

function wbFormIDNoReach(const aValidRefs     : TwbSignatures;
                         const aValidFlstRefs : TwbSignatures;
                               aPersistent    : Boolean)
                                              : IwbFormID; overload;

function wbFormID(const aSignature : TwbSignature;
                  const aName      : string = 'Unknown';
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef; overload;

function wbFormID(const aName      : string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil)
                                   : IwbIntegerDef; overload;

function wbFormIDT(const aName      : string;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbIntegerDef; overload;

function wbFormIDCk(const aSignature : TwbSignature;
                    const aName      : string;
                    const aValidRefs : TwbSignatures;
                          aPersistent: Boolean = False;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;

function wbFormIDCkST(const aSignature : TwbSignature;
                      const aName      : string;
                      const aValidRefs : TwbSignatures;
                            aPersistent: Boolean = False;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbSubRecordDef; overload;


function wbFormIDCkNoReach(const aSignature : TwbSignature;
                           const aName      : string;
                           const aValidRefs : TwbSignatures;
                                 aPersistent: Boolean = False;
                                 aPriority  : TwbConflictPriority = cpNormal;
                                 aRequired  : Boolean = False;
                                 aDontShow  : TwbDontShowCallback = nil;
                                 aGetCP     : TwbGetConflictPriority = nil)
                                            : IwbSubRecordDef; overload;

function wbFormIDCk(const aName      : string;
                    const aValidRefs : TwbSignatures;
                          aPersistent: Boolean = False;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil)
                                     : IwbIntegerDef; overload;

function wbFormIDCkNoReach(const aName      : string;
                           const aValidRefs : TwbSignatures;
                                 aPersistent: Boolean = False;
                                 aPriority  : TwbConflictPriority = cpNormal;
                                 aRequired  : Boolean = False;
                                 aDontShow  : TwbDontShowCallback = nil;
                                 aGetCP     : TwbGetConflictPriority = nil)
                                            : IwbIntegerDef; overload;

function wbFormIDCk(const aSignature     : TwbSignature;
                    const aName          : string;
                    const aValidRefs     : TwbSignatures;
                    const aValidFlstRefs : TwbSignatures;
                          aPersistent    : Boolean = False;
                          aPriority      : TwbConflictPriority = cpNormal;
                          aRequired      : Boolean = False;
                          aDontShow      : TwbDontShowCallback = nil;
                          aGetCP         : TwbGetConflictPriority = nil)
                                         : IwbSubRecordDef; overload;

function wbFormIDCk(const aName          : string;
                    const aValidRefs     : TwbSignatures;
                    const aValidFlstRefs : TwbSignatures;
                          aPersistent    : Boolean = False;
                          aPriority      : TwbConflictPriority = cpNormal;
                          aRequired      : Boolean = False;
                          aDontShow      : TwbDontShowCallback = nil;
                          aGetCP         : TwbGetConflictPriority = nil)
                                         : IwbIntegerDef; overload;

function wbFormIDCkNoReach(const aName          : string;
                           const aValidRefs     : TwbSignatures;
                           const aValidFlstRefs : TwbSignatures;
                                 aPersistent    : Boolean = False;
                                 aPriority      : TwbConflictPriority = cpNormal;
                                 aRequired      : Boolean = False;
                                 aDontShow      : TwbDontShowCallback = nil;
                                 aGetCP         : TwbGetConflictPriority = nil)
                                                : IwbIntegerDef; overload;

function wbChar4: IwbChar4;

function wbStr4: IwbStr4;

function wbFlags(const aNames           : array of string;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
function wbFlags(const aNames           : array of string;
                 const aFlagsToIgnore   : array of integer)
                                        : IwbFlagsDef; overload;
function wbFlags(const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;

function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aFlagsToIgnore   : array of integer)
                                        : IwbFlagsDef; overload;
function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;

function wbFlagsSummary(const aNames           : array of string;
                              aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
function wbFlagsSummary(const aNames           : array of string;
                        const aFlagsToIgnore   : array of integer)
                                               : IwbFlagsDef; overload;
function wbFlagsSummary(const aNames           : array of string;
                        const aDontShows       : array of TwbDontShowCallback;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef; overload;

function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                        const aNames           : array of string;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef; overload;
function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                        const aNames           : array of string;
                        const aFlagsToIgnore   : array of integer)
                                               : IwbFlagsDef; overload;
function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                        const aNames           : array of string;
                        const aDontShows       : array of TwbDontShowCallback;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef; overload;


function wbEnum(const aNames : array of string)
                             : IwbEnumDef; overload;
function wbEnum(const aNames       : array of string;
                const aSparseNames : array of const)
                                   : IwbEnumDef; overload;

function wbEnumSummary(const aNames   : array of string)
                                      : IwbEnumDef; overload;
function wbEnumSummary(const aNames       : array of string;
                       const aSparseNames : array of const)
                                          : IwbEnumDef; overload;


function wbStringEnum(const aNames : array of string)
                                   : IwbStringDefFormater; overload;

function wbStringEnum(const aNames       : array of string;
                      const aSparseNames : array of const)
                                         : IwbStringDefFormater; overload;

function wbStringEnumSummary(const aNames : array of string)
                                          : IwbStringDefFormater; overload;

function wbStringEnumSummary(const aNames       : array of string;
                             const aSparseNames : array of const)
                                                : IwbStringDefFormater; overload;


function wbDiv(aValue : Integer)
                      : IwbIntegerDefFormater;
function wbMul(aValue : Integer)
                      : IwbIntegerDefFormater;
function wbCallback(const aToStr : TwbIntToStrCallback;
                    const aToInt : TwbStrToIntCallback)
                                 : IwbIntegerDefFormater;

function wbFormaterUnion(aDecider : TwbIntegerDefFormaterUnionDecider;
                         aMembers : array of IwbIntegerDefFormater)
                                  : IwbIntegerDefFormaterUnion;

function wbIsModule(aFileName: string): Boolean;
function wbIsSave(aFileName: string): Boolean;

function wbStr4ToString(aInt: Int64): string;

type
  PwbRecordDefEntry = ^TwbRecordDefEntry;
  TwbRecordDefEntry = record
    rdeSignature : TwbSignature;
    rdeHash      : Integer;
    rdeDef       : IwbMainRecordDef;
    rdeNext      : Integer;
  end;

  TwbRecordDefEntries = array of TwbRecordDefEntry;

  TwbMainRecordDefs = TArray<IwbMainRecordDef>;

  TwbMainRecordDefsHelper = record helper for TwbMainRecordDefs
    procedure Add(const aMainRecordDef: IwbMainRecordDef);
  end;

const
  RecordDefHashMapSize = 1546;

var
  wbRecordDefs       : TwbRecordDefEntries;
  wbRefRecordDefs    : TwbMainRecordDefs;
  wbRecordDefHashMap : array[0..Pred(RecordDefHashMapSize)] of Integer;

  wbIgnoreRecords    : TStringList;
  wbGroupOrder       : TStringList;
  wbLoadBSAs         : Boolean{} = True{};
  wbLoadAllBSAs      : Boolean{} = False{};
  wbArchiveExtension : string = '.bsa';
  wbBuildRefs        : Boolean{} = True{};
  wbContainerHandler : IwbContainerHandler;
  wbLoaderDone       : Boolean;
  wbLoaderError      : Boolean;
  wbFirstLoadComplete: Boolean;

{$IFDEF USE_PARALLEL_BUILD_REFS}
  wbBuildingRefsParallel : Boolean = False;
{$ENDIF}

procedure wbAddGroupOrder(const aSignature: TwbSignature);
function wbGetGroupOrder(const aSignature: TwbSignature): Integer;

function IntToHex64(Value: Int64; Digits: Integer): string; inline;
function CmpB8(a, b: Byte): Integer;
function CmpI32(a, b : Integer) : Integer;
function CmpW32(a, b: Cardinal): Integer;
function CmpI64(const a, b : Int64) : Integer;
function CmpW64(const a, b : UInt64) : Integer;
function CmpPtr(a, b: Pointer): Integer;
function CompareElementsFormIDAndLoadOrder(Item1, Item2: Pointer): Integer;
function CmpDouble(const a, b : Double) : Integer;


function ConflictAllToColor(aConflictAll: TConflictAll): TColor;
function ConflictThisToColor(aConflictThis: TConflictThis): TColor;

var
  wbGetFormIDCallback : function(const aElement: IwbElement): TwbFormID;
  wbGetCellDetailsForWorldspaceCallback : function (aWorldspace: IwbMainRecord; var aPersistent: Boolean; var aGridCell: TwbGridCell): Boolean;

function wbFlagsList(aFlags: array of const; aDeleted : Boolean = True; aUnknowns: Boolean = False): TDynStrings;
function wbSparseFlags(aFlags: array of const; aUnknowns: Boolean = False; aSize: Cardinal = 32): TDynStrings;
function wbGetFormID(const aElement: IwbElement): TwbFormID;

function wbGetCellDetailsForWorldspace(aWorldspace: IwbMainRecord; var aPersistent: Boolean; var aGridCell: TwbGridCell): Boolean;
function wbPositionToGridCell(const aPosition: TwbVector): TwbGridCell;
function wbSubBlockFromGridCell(const aGridCell: TwbGridCell): TwbGridCell;
function wbBlockFromSubBlock(const aSubBlock: TwbGridCell): TwbGridCell;
function wbGridCellToGroupLabel(const aGridCell: TwbGridCell): Cardinal;
function wbIsInGridCell(const aPosition: TwbVector; const aGridCell: TwbGridCell): Boolean;
function wbGridCellToCenterPosition(const aGridCell: TwbGridCell): TwbVector;

var
  wbRecordFlags            : IwbIntegerDef;
  wbMainRecordHeader       : IwbValueDef;
  wbSizeOfMainRecordStruct : Integer;

type
  //keep ordered by release date
  TwbGameMode   = (gmTES3, gmTES4, gmFO3, gmFNV, gmTES5, gmEnderal, gmFO4, gmSSE, gmTES5VR, gmEnderalSE, gmFO4VR, gmFO76, gmSF1);
  TwbGameModes  = set of TwbGameMode;

  TwbToolMode   = (tmView, tmEdit, tmDump, tmExport, tmOnamUpdate, tmMasterUpdate, tmMasterRestore, tmLODgen, tmScript,
                    tmTranslate, tmESMify, tmESPify, tmSortAndCleanMasters,
                    tmCheckForErrors, tmCheckForITM, tmCheckForDR);
  TwbToolSource = (tsPlugins, tsSaves);
  TwbSetOfMode  = set of TwbToolMode;
  TwbSetOfSource  = set of TwbToolSource;

var
  wbGameMode         : TwbGameMode;
  wbToolMode         : TwbToolMode;
  wbToolSource       : TwbToolSource;
  wbSubMode          : string;
  wbAppName          : string;
  wbApplicationTitle : string;
  wbGameName         : string; //name of the exe, usually also name of the game master
  wbGameExeName      : string;
  wbGameMasterEsm    : string; // name of the GameMaster.esm, usually wbGameName + csDotEsm, different for Fallout 76
  wbGameName2        : string; // game title name used for AppData and MyGames folders
  wbGameNameReg      : string; // registry name
  wbToolName         : string;
  wbSourceName       : string;
  wbLanguage         : string;
  wbGameSteamID      : string;

  wbAutoModes: TwbSetOfMode = [ // Tool modes that run without user interaction until final status
    tmOnamUpdate,
    tmMasterUpdate,
    tmMasterRestore,
    tmLODgen,
    tmESMify,
    tmESPify,
    tmSortAndCleanMasters,
    tmScript,
    tmCheckForErrors,
    tmCheckForITM,
    tmCheckForDR
  ];

  wbPluginModes: TwbSetOfMode = [ // Auto modes that require a specific plugin to be provided.
    tmESMify,
    tmESPify,
    tmSortAndCleanMasters,
    tmCheckForErrors,
    tmCheckForITM,
    tmCheckForDR
  ];

  wbAlwaysMode: TwbSetOfMode = [ // Modes available to all decoded games
    tmView,
    tmEdit,
    tmTranslate,
    tmESMify,
    tmESPify,
    tmSortAndCleanMasters,
    tmLODgen,
    tmScript,
    tmCheckForITM,
    tmCheckForDR,
    tmCheckForErrors
  ];

  wbSimplePluginsTxt: TwbGameModes = [ //plugins.txt contains only the active plugins
    gmTES3,
    gmTES4,
    gmFO3,
    gmFNV,
    gmTES5,
    gmEnderal];

  wbOrderFromPluginsTxt: TwbGameModes = [ //load order given by order in plugins.txt
    gmTES5,
    gmEnderal,
    gmSSE,
    gmEnderalSE,
    gmTES5VR,
    gmFO4,
    gmFO4VR,
    gmFO76,
    gmSF1
  ];

function wbDefToName(const aDef: IwbDef): string;
function wbDefsToPath(const aDefs: TwbDefPath): string;

function wbIsMorrowind: Boolean; inline;
function wbIsOblivion: Boolean; inline;
function wbIsFallout3: Boolean; inline;
function wbIsFalloutNV: Boolean; inline;
function wbIsSkyrim: Boolean; inline;
function wbIsSkyrimSE: Boolean; inline;
function wbIsFallout4: Boolean; inline;
function wbIsFallout76: Boolean; inline;
function wbIsStarfield: Boolean; inline;
function wbIsLightSupported: Boolean; inline;
function wbIsMediumSupported: Boolean; inline;
function wbIsOverlaySupported: Boolean; inline;

procedure ReportDefs;

type
  IwbProgress = interface
    ['{054006B0-096D-43CD-A92A-3095B525C854}']

    procedure UpdateStatus(aPosition: Integer; const aStatus: string);
  end;

  IwbWaitForm = interface
    ['{185C220C-3135-4A8A-8E0E-8001759F3C85}']
    function GetIsCanceled: Boolean;

    function CreateProgress(const aCaption : string;
                            const aStatus  : string;
                                  aMax     : Integer)
                                           : IwbProgress;

    property IsCanceled: Boolean
      read GetIsCanceled;
  end;

  TwbCreateWaitForm = function(const aCaption     : string;
                               const aMessage     : string;
                                     aCanCancel   : Boolean;
                                     aShowDelay   : Integer = 0;
                                     aUpdateDelay : Integer = 0)
                                                  : IwbWaitForm;

function NullCreateWaitForm(const aCaption     : string;
                            const aMessage     : string;
                                  aCanCancel   : Boolean;
                                  aShowDelay   : Integer = 0;
                                  aUpdateDelay : Integer = 0)
                                               : IwbWaitForm;

var
  wbCreateWaitForm : TwbCreateWaitForm = NullCreateWaitForm;

type
  TwbFastStringList = class(TStringList)
  public
    procedure AfterConstruction; override;
    constructor CreateSorted(aDups : TDuplicates = dupError);

    procedure Clear(aFreeObjects: Boolean = False); reintroduce;
  end;

  TwbFastStringListCS = class(TwbFastStringList)
  public
    procedure AfterConstruction; override;
  end;

  TwbFastStringListIC = class(TwbFastStringList)
  end;

function wbNormalizeRadians(const aElement: IwbElement; aFloat: Extended): Extended;
function wbNormalizeToRange(aMin, aMax: Extended): TwbFloatNormalizer;

function wbBeginInternalEdit(aForce: Boolean = False): Boolean;
procedure wbEndInternalEdit;
function wbIsInternalEdit: Boolean;

function StrToSignature(const s: string): TwbSignature;
function IntToSignature(aInt: Cardinal): TwbSignature; inline;

function FixupFormID(aFormID: TwbFormID; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; aAllowHardcodedRangeUse: Boolean): TwbFormID;

threadvar
  _InternalEditCount: Integer;
  _BlockInternalEdit: Boolean;

var
  wbActorValueEnum: IwbEnumDef;

function GetContainerFromUnion(const aElement: IwbElement): IwbContainer;
function GetContainerRefFromUnionOrValue(const aElement: IwbElement): IwbContainerElementRef;
function GetElementFromUnion(const aElement: IwbElement): IwbElement;

var
  wbHeaderSignature   : TwbSignature = 'TES4';
  wbNullSignature     : TwbSignature = #0#0#0#0;
  wbFileMagic         : TwbFileMagic;
  wbFilePlugins       : string = 'Master Files';
  wbUseFalsePlugins   : Boolean = False;
  wbFileHeader        : IwbStructDef;
  wbFileChapters      : IwbStructDef;
  wbBytesToSkip       : Cardinal = 0;
  wbBytesToDump       : Cardinal = $FFFFFFFF;
  wbBytesToGroup      : Cardinal = 4;
  wbExtractInfo       : ^TByteSet;
  wbTerminator        : Byte = Ord('|');
  wbPlayerRefID       : Cardinal = $14;
  wbChangedFormOffset : Integer = 10000;

type
  {$IFDEF WIN32}
  TwbRefIDArray = array of Cardinal;
  {$ENDIF WIN32}
  {$IFDEF WIN64}
  TwbRefIDArray = array of UInt64;
  {$ENDIF WIN64}

function wbReadInteger24(aBasePtr: pointer): Int64;
procedure InitializeRefIDArray(anArray: TwbRefIDArray);

function wbFindRecordDef(const aSignature : TwbSignature;
                           out aRecordDef : PwbMainRecordDef)
                                          : Boolean; overload;

function wbFindRecordDef(const aSignature : AnsiString;
                           out aRecordDef : PwbMainRecordDef)
                                          : Boolean; overload;

function _wbRecordDefMap: TStringList;

function wbProgressLock: Integer;
function wbProgressUnlock: Integer;
function wbHasProgressCallback(aForce: Boolean = False): Boolean;
procedure wbProgressCallback(const aStatus: string = ''; aForce: Boolean = False);
procedure wbProgress(const aStatus: string = ''; aForce: Boolean = False); overload;
procedure wbProgress(const aStatus: string; const aArgs: array of const; aForce: Boolean = False); overload;
procedure wbTick;

type
  TIntegerFunction = function: Integer;

function DummyIntegerFunction: Integer;

var
  wbLockProcessMessages: TIntegerFunction = DummyIntegerFunction;
  wbUnLockProcessMessages: TIntegerFunction = DummyIntegerFunction;

function Lighter(Color: TColor; Amount: Double = 0.5): TColor;
function Darker(Color: TColor; Amount: Double = 0.5): TColor;
function wbLighter(Color: TColor; Amount: Double = 0.5): TColor;
function wbDarker(Color: TColor; Amount: Double = 0.25): TColor;
function wbIsDarkMode: Boolean;

type
  TwbCanOverwriteAction = (coCopy, coDelete, coSkip);
  TwbCanOverwriteCallback = reference to function(const aTarget, aSource: IwbElement) : TwbCanOverwriteAction;

threadvar
  _wbCanOverwriteCallback : TwbCanOverwriteCallback;

function wbCanOverwrite(const aTarget, aSource: IwbElement): TwbCanOverwriteAction;

var
  wbVarPointer: TVarType = $7FF;

function wbFormIDErrorCheckLock: Integer;
function wbFormIDErrorCheckUnlock: Integer;

function wbNextObjectIDToString(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbNextObjectIDToInt(const aString: string; const aElement: IwbElement): Int64;

var
  wbEncoding         : TEncoding;
  wbEncodingTrans    : TEncoding;
  wbEncodingVMAD     : TEncoding;

  wbLEncodingDefault : array[Boolean] of TEncoding;
  wbLEncoding        : array[Boolean] of TStringList;

procedure wbAddDefaultLEncodingsIfMissing(aFallback: Boolean);
procedure wbAddLEncodingIfMissing(const aLanguage: string; aEncoding: TEncoding; aFallback: Boolean); overload;
procedure wbAddLEncodingIfMissing(const aLanguage: string; const aEncoding: string; aFallback: Boolean); overload;
function wbEncodingForLanguage(const aLanguage: string; aFallback: Boolean): TEncoding;

function wbMBCSEncoding(aCP: Cardinal): TEncoding; overload;
function wbMBCSEncoding(s: string): TEncoding; overload;

procedure wbVCI1ToStrBeforeFO4(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbVCI1ToStrAfterFO4(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbTimeStampToString(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);

/// <summary>Collapse and truncate the given text to fit in the given width.</summary>
function ShortenText(const aText: string; const aWidth: Integer = 64; const aPlaceholder: string = '…'): string;

procedure wbInitRecords;

function wbGetUnknownIntString(aInt: Int64): string;

procedure wbResourcesLoaded;
procedure wbRegisterResourcesLoadedHandler(const aHandler: TProc);

var
  wbFileBySortOrderComparer        : IComparer<IwbFile>;
  wbFileByReverseSortOrderComparer : IComparer<IwbFile>;

implementation

uses
  Windows,
  Variants,
  Math,
  TypInfo,
  wbSort,
  wbLocalization,
  wbImplementation,
  wbHalfFloat;

type
  IwbIntegerDefInternal = interface(IwbIntegerDef)
    ['{16A15EF7-6295-4817-BA94-CDD7E8C1CF8B}']
    procedure ReplaceFormater(const aFormater: IwbIntegerDefFormater);
  end;

  IwbMainRecordDefInternal = interface(IwbMainRecordDef)
    ['{4EC86F13-A1B7-4FDF-B073-84DC6FA00158}']
  end;

function wbCanOverwrite(const aTarget, aSource: IwbElement): TwbCanOverwriteAction;
begin
  if Assigned(_wbCanOverwriteCallback) then
    Result := _wbCanOverwriteCallback(aTarget, aSource)
  else
    Result := coCopy;
end;

function RGBTripleToCol(aCol: TRGBTriple ): TColor;
begin
  Result := aCol.rgbtRed * 65536;
  Result := Result + aCol.rgbtGreen * 256;
  Result := Result + aCol.rgbtBlue;
end;

function ColToRGBTriple(aCol: TColor): TRGBTriple;
begin
  aCol := ColorToRGB(aCol);
  Result.rgbtRed := (aCol shr 16) and $000000FF;
  Result.rgbtGreen := (aCol shr 8) and $000000FF;
  Result.rgbtBlue := aCol and $000000FF;
end;

procedure RGBtoHSL(rgb : TRGBTriple; var H, S, L : extended);
var
  delta, r, g, b, cmax, cmin: extended;
begin
  r := rgb.rgbtRed / 255;
  g := rgb.rgbtGreen / 255;
  b := rgb.rgbtBlue / 255;
  if (r > b) and (r > g) then
    cmax := r
  else if g > b then
    cmax := g
  else
    cmax := b;
  if (r < b) and (r < g) then
    cmin := r
  else if g < b then
    cmin := g
  else
    cmin := b;
  L := (cmax+cmin) / 2.0;

  if cmax=cmin then begin
    S := 0;
    H := 0; //sarebbe indefinita
  end else begin
    delta := cmax - cmin;
    if L <= 0.5 then
      s := delta / (cmax + cmin)
    else
      s := delta / (2.0 - cmax - cmin);
    if r = cmax then
      H := (g - b) / delta
    else if g = cmax then
      H := 2.0 + (b - r) / delta
    else
      H := 4.0 + (r - g) / delta;
    H := H / 6.0;
    if H < 0 then
      H := H + 1;
    end;
end;

procedure HSLtoRGB(H, S, L : extended; var rgb : TRGBTriple);
var
  r, g, b, m1, m2 : double;

  function HuetoRGB(m1,m2, h: double): double;
    begin
    if h < 0 then
      h := h + 1.0
    else if h > 1 then
      h := h - 1.0;
    if 6.0*h < 1 then
      result := (m1+(m2-m1)*h*6.0)
    else if 2.0*h < 1 then
      result := m2
    else if 3.0*h < 2.0 then
      result := (m1+(m2-m1)*((2.0/3.0)-h)*6.0)
    else
      result := m1;
    end;

begin
  if S = 0 then
    begin
    r := L;
    g := L;
    b := L;
    end
  else
    begin
    if L <= 0.5 then
      m2 := L*(1.0+S)
    else
      m2 := L+S-L*S;
    m1 := 2.0*L-m2;
    r := HuetoRGB(m1,m2,H+1.0/3.0);
    g := HuetoRGB(m1,m2,H);
    b := HuetoRGB(m1,m2,H-1.0/3.0);
    end;
  rgb.rgbtBlue := round(b * 255);
  rgb.rgbtGreen := round(g * 255);
  rgb.rgbtRed := round(r * 255);
end;

function Lighter(Color: TColor; Amount: Double = 0.5): TColor;
var
  h, s, l: Extended;
  rgb:TRGBTriple;
begin
  RGBtoHSL(ColToRGBTriple(Color), h, s, l);

  l := Min(l + (1.0 - l) * Amount, 1.0);

  HSLtoRGB(h, s, l, rgb);
  Result := RGBTripleToCol(rgb);
end;

function Darker(Color: TColor; Amount: Double = 0.5): TColor;
var
  h, s, l: Extended;
  rgb:TRGBTriple;
begin
  RGBtoHSL(ColToRGBTriple(Color), h, s, l);

  l := Max(l - l * Amount, 0.0);

  HSLtoRGB(h, s, l, rgb);
  Result := RGBTripleToCol(rgb);
end;

function wbLighter(Color: TColor; Amount: Double = 0.5): TColor;
begin
  if wbDarkMode then
    Result := Darker(Color, Amount * 0.95)
  else
    Result := Lighter(Color, Amount);
end;

function wbDarker(Color: TColor; Amount: Double = 0.25): TColor;
begin
  if wbDarkMode then
    Result := Lighter(Color, Amount)
  else
    Result := Color;
end;

function wbIsDarkMode: Boolean;
var
  H, S, BkL, TxL: extended;
begin
  RGBtoHSL(ColToRGBTriple(clWindow), H, S, BkL);
  RGBtoHSL(ColToRGBTriple(clWindowText), H, S, TxL);;
  Result := BkL < TxL;
end;


threadvar
  _ProgressLockCount : Integer;

function wbProgressLock: Integer;
begin
  Result := _ProgressLockCount;
  Inc(_ProgressLockCount);
end;

function wbProgressUnlock: Integer;
begin
  Result := _ProgressLockCount;
  Dec(_ProgressLockCount);
end;

function wbHasProgressCallback(aForce: Boolean = False): Boolean;
begin
  Result := ((_ProgressLockCount < 1) or aForce) and Assigned(_wbProgressCallback);
end;

procedure wbProgressCallback(const aStatus: string; aForce: Boolean);
begin
  if wbHasProgressCallback(aForce) then
    _wbProgressCallback(aStatus);
end;

procedure wbProgress(const aStatus: string = ''; aForce: Boolean = False);
begin
  if wbHasProgressCallback(aForce) then
    _wbProgressCallback(aStatus);
end;

procedure wbProgress(const aStatus: string; const aArgs: array of const; aForce: Boolean = False);
begin
  if wbHasProgressCallback(aForce) then
    _wbProgressCallback(Format(aStatus, aArgs));
end;


procedure wbTick;
begin
  if (wbCurrentTick>0) and (wbCurrentTick+500<GetTickCount64) then begin
    wbProgressCallback;
    wbCurrentTick := GetTickCount64;
  end;
end;


function StrToSignature(const s: string): TwbSignature;
var
  t: AnsiString;
begin
  t := AnsiString(s);
  if Length(t) >= 4 then
    Result := PwbSignature(@t[1])^
  else
    raise Exception.Create('"'+t+'" is not a valid signature');
end;

function IntToSignature(aInt: Cardinal): TwbSignature; inline;
begin
  Result := PwbSignature(@aInt)^;
end;

function wbBeginInternalEdit(aForce: Boolean): Boolean;
begin
  Result := wbEditAllowed or ((wbAllowInternalEdit or aForce) and not _BlockInternalEdit);
  if Result then
    Inc(_InternalEditCount);
end;

procedure wbEndInternalEdit;
begin
  Dec(_InternalEditCount);
end;

function wbIsInternalEdit: Boolean;
begin
  Result := _InternalEditCount > 0;
end;

var
  OnePi : Single = 3.1415927;//(2!) 653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067;
  TwoPi : Extended;

function RoundToEx(const AValue: Extended; const ADigit: TRoundToRange): Extended;
var
  LFactor: Extended;
begin
  LFactor := IntPower(10, ADigit);
  Result := Round(AValue / LFactor) * LFactor;
end;

function DoSingleSameValue(const A, B: Single): Boolean;
const
  SingleResolution : Single = 0.000000499999999999999999999;
begin
  Result := Abs(A - B) <= Max(Min(Abs(A), Abs(B)) * SingleResolution, SingleResolution)
end;

function SingleSameValue(const A, B: Extended): Boolean;
var
  sA, sB: Single;
begin
  sA := A;
  sB := B;
  Result := DoSingleSameValue(sA, sB);
end;

function wbNormalizeRadians(const aElement: IwbElement; aFloat: Extended): Extended;
begin
  Result := aFloat;

  if Abs(Result/TwoPi) > 100.0 then begin
    Result := Result - Sign(Result)*TwoPi*Trunc(Abs(Result/TwoPi) - 100.0);
    if Abs(Result/TwoPi) > 101.0 then
      Exit(NaN);
  end;

  while Result < 0.0 do
    Result := Result + TwoPi;
  while Result > TwoPi do
    Result := Result - TwoPi;
  if SingleSameValue(Result, 0.0) or (Result < 0.0) then
    Result := 0.0;
  if SingleSameValue(Result, TwoPi) or (Result > TwoPi) then
    Result := 0.0;
end;

function wbNormalizeToRange(aMin, aMax: Extended): TwbFloatNormalizer;
begin
  Result := function(const aElement: IwbElement; aFloat: Extended): Extended
  begin
    if aFloat < aMin then
      Result := aMin
    else if aFloat > aMax then
      Result := aMax
    else
      Result := aFloat;
  end;
end;

type
  TwbNullWaitForm = class(TInterfacedObject, IwbWaitForm)
  protected
    {--- IwbWaitForm ---}
    function GetIsCanceled: Boolean;

    function CreateProgress(const aCaption : string;
                            const aStatus  : string;
                                  aMax     : Integer)
                                           : IwbProgress;
  end;

  TwbNullProgress = class(TInterfacedObject, IwbProgress)
  protected
    {--- IwbProgress ---}
    procedure UpdateStatus(aPosition: Integer; const aStatus: string);
  end;

{ TwbNullWaitForm }

function TwbNullWaitForm.CreateProgress(const aCaption, aStatus: string; aMax: Integer): IwbProgress;
begin
  Result := TwbNullProgress.Create;
end;

function TwbNullWaitForm.GetIsCanceled: Boolean;
begin
  Result := False;
end;

{ TwbNullProgress }

procedure TwbNullProgress.UpdateStatus(aPosition: Integer; const aStatus: string);
begin
end;

function NullCreateWaitForm(const aCaption     : string;
                            const aMessage     : string;
                                  aCanCancel   : Boolean;
                                  aShowDelay   : Integer = 0;
                                  aUpdateDelay : Integer = 0)
                                               : IwbWaitForm;
begin
  Result := TwbNullWaitForm.Create;
end;

procedure ReportDefs;
var
  i: Integer;
begin
  for i:= Low(wbRecordDefs) to High(wbRecordDefs) do
    wbRecordDefs[i].rdeDef.Report(nil);
end;

function wbIsMorrowind: Boolean; inline;
begin
  Result := wbGameMode in [gmTES3];
end;

function wbIsOblivion: Boolean; inline;
begin
  Result := wbGameMode in [gmTES4];
end;

function wbIsFallout3: Boolean; inline;
begin
  Result := wbGameMode in [gmFO3, gmFNV];
end;

function wbIsFalloutNV: Boolean; inline;
begin
  Result := wbGameMode in [gmFNV];
end;

function wbIsSkyrim: Boolean; inline;
begin
  Result := wbGameMode in [gmTES5, gmEnderal, gmTES5VR, gmSSE, gmEnderalSE];
end;

function wbIsSkyrimSE: Boolean; inline;
begin
  Result := wbGameMode in [gmTES5VR, gmSSE, gmEnderalSE];
end;

function wbIsFallout4: Boolean; inline;
begin
  Result := wbGameMode in [gmFO4, gmFO4VR];
end;

function wbIsFallout76: Boolean; inline;
begin
  Result := wbGameMode in [gmFO76];
end;

function wbIsStarfield: Boolean; inline;
begin
  Result := wbGameMode in [gmSF1];
end;

function wbIsLightSupported: Boolean; inline;
begin
  Result := (wbGameMode in [gmSSE, gmEnderalSE, gmFO4, gmSF1]) or wbHasAddedLightSupport;
end;

function wbIsMediumSupported: Boolean; inline;
begin
  Result := (wbGameMode in [gmSF1]) or wbHasAddedMediumSupport;
end;

function wbIsOverlaySupported: Boolean; inline;
begin
  Result := wbGameMode in [gmSF1];
end;

function wbDefToName(const aDef: IwbDef): string;
var
  SignatureDef : IwbSignatureDef;
  Signature    : TwbSignature;
  NamedDef     : IwbNamedDef;
  i            : Integer;
begin
  if Supports(aDef, IwbSignatureDef, SignatureDef) then begin
    Signature := SignatureDef.DefaultSignature;
    if Signature[0]=#0 then
      Result := '$(00)'+Signature[1]+Signature[2]+Signature[3] + ' - ' + SignatureDef.Name
    else
      Result := Signature + ' - ' + SignatureDef.Name;
  end else if Supports(aDef, IwbNamedDef, NamedDef) then begin
    Result := NamedDef.Name;
  end else if Assigned(aDef) then begin
    Result := '<'+GetEnumName(TypeInfo(TwbDefType), Ord(aDef.DefType))+'>';
  end else
    Result := '<nil>';
  for i := Length(Result) downto 1 do
    if Result[i]<' ' then begin
      Insert('$('+IntToHex(Ord(Result[i]), 2)+')', Result, i);
      Delete(Result, i + 5, 1);
    end;
end;

function wbDefsToPath(const aDefs: TwbDefPath): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(aDefs) to High(aDefs) do begin
    Result := Result + wbDefToName(aDefs[i].Def) + ' \ ';
    if aDefs[i].Index >= 0 then
      Result := Result + '['+IntToStr(aDefs[i].Index)+'] ';
  end;
end;

function wbIsInGridCell(const aPosition: TwbVector; const aGridCell: TwbGridCell): Boolean;
var
  GridCell : TwbGridCell;
begin
  GridCell := wbPositionToGridCell(aPosition);
  Result := (GridCell.x = aGridCell.x) and (GridCell.y = aGridCell.y);
end;

function wbPositionToGridCell(const aPosition: TwbVector): TwbGridCell;
begin
  Result.x := Trunc(aPosition.x / wbCellSizeFactor);
  if (aPosition.x < 0) and (Frac(aPosition.x / wbCellSizeFactor) <> 0) then
    Dec(Result.x);

  Result.y := Trunc(aPosition.y / wbCellSizeFactor);
  if (aPosition.y < 0) and (Frac(aPosition.y / wbCellSizeFactor) <> 0) then
    Dec(Result.y);
end;

function wbGridCellToCenterPosition(const aGridCell: TwbGridCell): TwbVector;
begin
  Result.z := 0;
  if aGridCell.x >= 0 then
    Result.x := (Succ(aGridCell.x) * wbCellSizeFactor) - (wbCellSizeFactor/2)
  else
    Result.x := (aGridCell.x * wbCellSizeFactor) + (wbCellSizeFactor/2);
  if aGridCell.y >= 0 then
    Result.y := (Succ(aGridCell.y) * wbCellSizeFactor) - (wbCellSizeFactor/2)
  else
    Result.y := (aGridCell.y * wbCellSizeFactor) + (wbCellSizeFactor/2);
end;

function wbSubBlockFromGridCell(const aGridCell: TwbGridCell): TwbGridCell;
begin
  Result.x := aGridCell.x div 8;
  if (aGridCell.x < 0) and ((aGridCell.x mod 8) <> 0) then
    Dec(Result.x);
  Result.y := aGridCell.y div 8;
  if (aGridCell.y < 0) and ((aGridCell.y mod 8) <> 0) then
    Dec(Result.y);
end;

function wbBlockFromSubBlock(const aSubBlock: TwbGridCell): TwbGridCell;
begin
  Result.x := aSubBlock.x div 4;
  if (aSubBlock.x < 0) and ((aSubBlock.x mod 4) <> 0) then
    Dec(Result.x);
  Result.y := aSubBlock.y div 4;
  if (aSubBlock.y < 0) and ((aSubBlock.y mod 4) <> 0) then
    Dec(Result.y);
end;

function wbGridCellToGroupLabel(const aGridCell: TwbGridCell): Cardinal;
var
  x, y: Smallint;
  xx,yy: Word;
begin
  x := aGridCell.x;
  y := aGridCell.y;
  xx := PWord(@x)^;
  yy := PWord(@y)^;
  Result := Cardinal(yy) or (Cardinal(xx) shl 16);
end;

function wbGetFormID(const aElement: IwbElement): TwbFormID;
begin
  if Assigned(wbGetFormIDCallback) then
    Result := wbGetFormIDCallback(aElement)
  else
    Result := TwbFormID.Null;
end;

function wbGetCellDetailsForWorldspace(aWorldspace: IwbMainRecord; var aPersistent: Boolean; var aGridCell: TwbGridCell): Boolean;
begin
  Result :=
    Assigned(wbGetCellDetailsForWorldspaceCallback) and
    wbGetCellDetailsForWorldspaceCallback(aWorldspace, aPersistent, aGridCell);
end;

function ConflictAllToColor(aConflictAll: TConflictAll): TColor;
begin
  Result := wbColorConflictAll[aConflictAll];
end;

function ConflictThisToColor(aConflictThis: TConflictThis): TColor;
begin
  Result := wbColorConflictThis[aConflictThis];
end;

procedure wbAddGroupOrder(const aSignature: TwbSignature);
begin
  if not Assigned(wbGroupOrder) then
    wbGroupOrder := TwbFastStringListCS.CreateSorted;
  wbGroupOrder.AddObject(aSignature, Pointer(wbGroupOrder.Count));
end;

function wbGetGroupOrder(const aSignature: TwbSignature): Integer;
begin
  if Assigned(wbGroupOrder) then begin
    Result := wbGroupOrder.IndexOf(aSignature);
    if Result >= 0 then
      Result := Integer(wbGroupOrder.Objects[Result]);
  end else
    Result := -1;
end;

function CompareElementsFormIDAndLoadOrder(Item1, Item2: Pointer): Integer;
var
  MainRecord1, MainRecord2: IwbMainRecord;
begin
  if Item1 = Item2 then begin
    Result := 0;
    Exit;
  end;

  MainRecord1 := IwbElement(Item1) as IwbMainRecord;
  MainRecord2 := IwbElement(Item2) as IwbMainRecord;

  Result := TwbFormID.Compare(
    MainRecord1.LoadOrderFormID,
    MainRecord2.LoadOrderFormID);
  if Result = 0 then
    Result := CmpI32(
      MainRecord1._File.LoadOrder,
      MainRecord2._File.LoadOrder);
end;

function wbSparseFlags(aFlags: array of const; aUnknowns: Boolean = False; aSize: Cardinal = 32): TDynStrings;
var
  e: IwbEnumDef;
  i: integer;
  s: string;
begin
  e := wbEnum([], aFlags);
  SetLength(Result, aSize);
  for i := 0 to Pred(aSize) do
    begin
      s := e.ToString(i, nil, False);
      if Pos('<', s) <> 1 then
        Result[i] := s
      else if aUnknowns then
        Result[i] := 'Unknown ' + IntToStr(i);
    end
end;

function wbFlagsList(aFlags: array of const; aDeleted : Boolean = True; aUnknowns: Boolean = False): TDynStrings;
var
  e: IwbEnumDef;
  i: integer;
  s: string;
begin
  e := wbEnum([], aFlags);
  SetLength(Result, 32);
  for i := 0 to 31 do
    if (i = 12) and (wbGameMode > gmTES3) then
      Result[i] := 'Ignored'
    else if aDeleted and (i = 5) and (wbGameMode > gmTES3) then
      Result[i] := 'Deleted'
    else begin
      s := e.ToString(i, nil, False);
      if Pos('<', s) <> 1 then
        Result[i] := s
      else if aUnknowns then
        Result[i] := 'Unknown ' + IntToStr(i);
    end
end;

type
  TwbDef = class;

  IwbDefInternal = interface(IwbDef)
    ['{8EBA62A9-AF6B-4377-B52C-A1CEBF5B3ED6}']
    function SetParent(const aParent: TwbDef; aForceDuplicate: Boolean): IwbDef;
    procedure InitFromParent(aParent: TwbDef);
  end;

  TwbDefClass = class of TwbDef;
  TwbDef = class(TInterfacedObject, IInterface, IwbDef, IwbDefInternal)
  private
    defSource           : IwbDef;
    defParent           : TwbDef;

    defPriority         : TwbConflictPriority;
    defGetCP            : TwbGetConflictPriority;
    defFlags            : TwbDefFlags;
    defCollapsedGen     : Integer;

    defRequired         : Boolean;

    defUsed             : Boolean;
    defReported         : Boolean;
    defPossiblyRequired : Boolean;
    defNotRequired      : Boolean;

    IsUnknown           : Boolean;
    IsUnknownChecked    : Boolean;
    UnknownValues       : TStringList;


    function defInternalEditOnly: Boolean;
  protected
    constructor Clone(const aSource: TwbDef); virtual;
    constructor Create(aPriority: TwbConflictPriority; aRequired: Boolean; aGetCP: TwbGetConflictPriority);
    procedure AfterClone(const aSource: TwbDef); virtual;
    procedure AfterConstruction; override;

    function defIsLocked: Boolean;

    {---IInterface---}
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;

    {---IwbDef---}
    function GetDefType: TwbDefType; virtual; abstract;
    function GetDefTypeName: string; virtual; abstract;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; virtual;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; virtual;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; virtual;
    function GetDefID: NativeUInt;
    function Equals(const aDef: IwbDef): Boolean; reintroduce; virtual;
    function GetConflictPriority(const aElement: IwbElement): TwbConflictPriority; virtual;
    function GetConflictPriorityCanChange: Boolean; virtual;
    function GetRequired: Boolean;
    function GetDontShow(const aElement: IwbElement): Boolean; virtual;
    function GetHasDontShow: Boolean; virtual;
    function GetRoot: IwbDef;
    function GetParent: IwbDef;
    function GetDefFlags: TwbDefFlags;
    function GetCollapsed: Boolean;
    procedure SetCollapsed(const aValue: Boolean);
    function GetCollapsedGen: Integer;
    function GetChildPos(const aChild: IwbDef): Integer; virtual;

    procedure Report(const aParents: TwbDefPath); virtual;
    procedure Used(const aElement: IwbElement; const s: string);
    procedure PossiblyRequired;
    procedure NotRequired;
    function IsNotRequired: Boolean;
    function GetNoReach: Boolean; virtual;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbDef{Self};
    function IncludeFlagNoClone(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbDef{Self};

    {--- IwbDefInternal ---}
    function SetParent(const aParent: TwbDef; aForceDuplicate: Boolean): IwbDef; virtual;
    procedure ParentSet; virtual;
    procedure InitFromParent(aParent: TwbDef); virtual;
    procedure InitFromParentBeforeChildren; virtual;
    procedure InitFromParentDoChildren; virtual;
    procedure InitFromParentAfterChildren; virtual;

    function Duplicate: TwbDef;
  end;

  TwbNamedDef = class(TwbDef, IwbNamedDef)
  private
    ndName                   : string;
    ndSummaryName            : string;
    ndSingularName           : string;
    ndSummarySingularName    : string;
    ndAfterLoad              : TwbAfterLoadCallback;
    ndAfterSet               : TwbAfterSetCallback;
    ndToStr                  : TwbToStrCallback;
    ndDontShow               : TwbDontShowCallback;
    ndIsRemovable           : TwbIsRemovableCallback;
    ndTerminator             : Boolean;
    ndUnused                 : Boolean;
    ndTreeHead               : Boolean;
    ndTreeBranch             : Boolean;
    ndSummaryLinksToCallback : TwbLinksToCallback;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean); virtual;
    procedure AfterClone(const aSource: TwbDef); override;
    {--- IwbDef ---}
    function GetDontShow(const aElement: IwbElement): Boolean; override;
    function GetHasDontShow: Boolean; override;

    {--- IwbDefInternal ---}
    procedure InitFromParentBeforeChildren; override;

    {---IwbNamedDef---}
    function GetName: string;
    function GetSummaryName: string;
    function GetFullName: string; virtual;
    function MakeSingularName(const aName: string): string;
    function GetSingularName: string;
    function GetSummarySingularName: string;
    function GetPath: string;
    function GetFullPath: string;
    procedure AfterLoad(const aElement: IwbElement); virtual;
    procedure AfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);

    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbNamedDef;
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbNamedDef;
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbNamedDef;
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbNamedDef;

    function GetTreeHead: Boolean;              // Is the element expected to be a "header record" in the tree navigator
    procedure SetTreeHead(aValue: Boolean);     // Make the element a "header record" in the tree navigator;
    function GetTreeBranch: Boolean;            // Is the element included in a "leaf" expected to be displayed in the view pane
    procedure SetTreeBranch(aValue: Boolean);   // Make the element included in a "leaf" visible in the tree navigator;

    procedure ToString(var Result : string; const aElement: IwbElement; aType: TwbCallbackType); reintroduce; virtual;
    function GetSummaryLinksTo(const aElement: IwbElement): IwbElement; virtual;

    function IsRemovable(const aElement: IwbElement): Boolean; virtual;

    function SetSummaryName(const aName: string): IwbNamedDef;
  end;

  TwbBaseSignatureDef = class(TwbNamedDef, IwbSignatureDef)
  protected
    {---IwbNamedDef---}
    function GetFullName: string; override;

    {---IwbSignatureDef---}
    function GetDefaultSignature: TwbSignature; virtual;

    function GetSignature(const aIndex: Integer): TwbSignature; virtual;
    function GetSignatureCount: Integer; virtual;

    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean; virtual;
  end;

  TwbSignatureDef = class(TwbBaseSignatureDef)
  private
    soSignatures : TwbSignatures;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority  : TwbConflictPriority;
                       aRequired  : Boolean;
                 const aSignature : TwbSignature;
                       aName      : string;
                       aAfterLoad : TwbAfterLoadCallback;
                       aAfterSet  : TwbAfterSetCallback;
                       aDontShow  : TwbDontShowCallback;
                       aGetCP     : TwbGetConflictPriority); reintroduce; overload;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aSignatures : TwbSignatures;
                       aName       : string;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority); reintroduce; overload;

    {---IwbSignatureDef---}
    function GetDefaultSignature: TwbSignature; override;

    function GetSignature(const aIndex: Integer): TwbSignature; override;
    function GetSignatureCount: Integer; override;
  end;

  TwbRecordDefFlag = (
    rdfAllowUnordered,
    rdfIsReference,
    rdfCanBePartial
  );
  TwbRecordDefFlags = set of TwbRecordDefFlag;

  TwbMainRecordDef = class(TwbSignatureDef, IwbRecordDef, IwbMainRecordDef, IwbMainRecordDefInternal)
  private
    recRecordFlags        : IwbIntegerDefFormater;
    recRecordHeaderStruct : IwbStructDef;
    recMembers            : array of IwbRecordMemberDef;
    recSignatures         : TStringList;
    recAddInfoCallback    : TwbAddInfoCallback;
    recQuickInitLimit     : Integer;
    recDefFlags           : TwbRecordDefFlags;
    recBaseRecordFormID   : IwbFormIDChecked;
    recReferences         : TStringList;
    recKnownSRs           : PwbKnownSubRecordSignatures;
    recKnownSRMembers     : TwbKnownSubRecordIndices;
    recGetFormIDCallback  : TwbMainRecordGetFormIDCallback;
    recIdentityCallback   : TwbMainRecordIdentityCallback;
    recGetEditorIDCallback: TwbMainRecordGetEditorIDCallback;
    recSetEditorIDCallback: TwbMainRecordSetEditorIDCallback;
    recGetGridCellCallback: TwbMainRecordGetGridCellCallback;
    recFormIDBase         : Byte;
    recFormIDNameBase     : Byte;
    recSummaryKey         : array of Integer;
    recSummaryPrefix      : TwbStringArray;
    recSummarySuffix      : TwbStringArray;
    recSummaryMaxDepth    : TArray<Integer>;
    recSummaryDelimiter   : string;
    recIgnoreList         : TwbSignatures;
    recBuildIndexKeys     : TwbBuildIndexKeysCallback;

    procedure recBuildReferences;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority        : TwbConflictPriority;
                       aRequired        : Boolean;
                 const aSignature       : TwbSignature;
                 const aName            : string;
                 const aKnownSRs        : PwbKnownSubRecordSignatures;
                 const aRecordFlags     : IwbIntegerDefFormater;
                 const aMembers         : array of IwbRecordMemberDef;
                       aAllowUnordered  : Boolean;
                       aAddInfoCallback : TwbAddInfoCallback;
                       aAfterLoad       : TwbAfterLoadCallback;
                       aAfterSet        : TwbAfterSetCallback;
                       aIsReference     : Boolean);
    procedure AfterClone(const aSource: TwbDef); override;
    destructor Destroy; override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetChildPos(const aChild: IwbDef): Integer; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbRecordDef---}
    function ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Boolean; virtual;
    function GetMemberFor(const aContainer     : IwbContainerElementRef;
                                aSignature     : TwbSignature;
                          const aDataContainer : IwbDataContainer)
                                               : IwbRecordMemberDef;
    function GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Integer;
    function AllowUnordered: Boolean;
    function AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;

    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;
    function GetSkipSignature(const aSignature: TwbSignature): Boolean; virtual;
    function GetRecordHeaderStruct: IwbStructDef;

    procedure AfterLoad(const aElement: IwbElement); override;

    {--- IwbMainRecordDef ---}
    function GetIsReference: Boolean;

    function GetQuickInitLimit: Integer;

    function GetContainsKnownSubRecord(aKnownSubRecord: TwbKnownSubRecord): Boolean;
    function GetKnownSubRecordMemberIndex(aKnownSubRecord: TwbKnownSubRecord): Integer;
    function GetKnownSubRecordMember(aKnownSubRecord: TwbKnownSubRecord): IwbRecordMemberDef;

    function GetCanBePartial: Boolean;

    function GetBaseSignature(const aIndex: Integer): TwbSignature;
    function GetBaseSignatureCount: Integer;
    function IsValidBaseSignature(const aSignature: TwbSignature): Boolean;

    function GetReferenceSignature(const aIndex: Integer): TwbSignature;
    function GetReferenceSignatureCount: Integer;
    function IsValidReferenceSignature(const aSignature: TwbSignature): Boolean;

    function GetFormIDBase: Byte;
    function SetFormIDBase(aBase: Byte): IwbMainRecordDef;
    function GetFormIDNameBase: Byte;
    function SetFormIDNameBase(aBase: Byte): IwbMainRecordDef;

    function GetFormID(const aMainRecord: IwbMainRecord; out aFormID: TwbFormID): Boolean;
    function SetGetFormIDCallback(const aCallback: TwbMainRecordGetFormIDCallback): IwbMainRecordDef;

    function KnownSubRecordSignatures: PwbKnownSubRecordSignatures;
    function GetIdentity(const aMainRecord: IwbMainRecord): string;
    function SetIdentityCallback(const aCallback: TwbMainRecordIdentityCallback): IwbMainRecordDef;

    function GetEditorID(const aSubRecord: IwbSubRecord): string;
    procedure SetEditorID(const aSubRecord: IwbSubRecord; const aEditorID: string);
    function SetGetEditorIDCallback(const aCallback: TwbMainRecordGetEditorIDCallback): IwbMainRecordDef;
    function SetSetEditorIDCallback(const aCallback: TwbMainRecordSetEditorIDCallback): IwbMainRecordDef;

    function GetGridCell(const aSubRecord: IwbSubRecord; out aGridCell: TwbGridCell): Boolean;
    function SetGetGridCellCallback(const aCallback: TwbMainRecordGetGridCellCallback): IwbMainRecordDef;

    function SetAddInfo(const aAddInfo: TwbAddInfoCallback): IwbMainRecordDef;
    function SetToStr(const aToStr : TwbToStrCallback): IwbMainRecordDef{Self};
    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbMainRecordDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbMainRecordDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbMainRecordDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbMainRecordDef;

    function ToSummary(aDepth: Integer; const aMainRecord: IwbMainRecord; var aLinksTo: IwbElement): string;

    function SetIgnoreList(const aSignatures: array of TwbSignature): {Self}IwbMainRecordDef;
    function ShouldIgnore(const aSignature: TwbSignature): Boolean;

    function SetBuildIndexKeys(const aCallback: TwbBuildIndexKeysCallback): {Self}IwbMainRecordDef;
    function BuildIndexKeys(const aMainRecord: IwbMainRecord; var aIndexKeys: TwbIndexKeys): Boolean;
    {--- IwbMainRecordDefInternal ---}
  end;

  TwbSubRecordDef = class(TwbSignatureDef, IwbRecordMemberDef, IwbSubRecordDef, IwbSubRecordWithStructDef, IwbSubRecordWithArrayDef, IwbSubRecordWithBaseStringDef)
  private
    srValue     : IwbValueDef;
    srSizeMatch : Boolean;

    srHasUnusedData: Boolean;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority  : TwbConflictPriority;
                       aRequired  : Boolean;
                 const aSignature : TwbSignature;
                 const aName      : string;
                 const aValue     : IwbValueDef;
                       aAfterLoad : TwbAfterLoadCallback;
                       aAfterSet  : TwbAfterSetCallback;
                       aSizeMatch : Boolean;
                       aDontShow  : TwbDontShowCallback;
                       aGetCP     : TwbGetConflictPriority); overload;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aSignatures : TwbSignatures;
                 const aName       : string;
                 const aValue      : IwbValueDef;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aSizeMatch  : Boolean;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority); overload;

    {---IInterface---}
    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbRecordMemberDef---}
    function ToSummary(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string; virtual;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbRecordMemberDef{Self};
    function SetSummaryName(const aName: string): IwbRecordMemberDef{Self};

    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbRecordMemberDef{Self};
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbRecordMemberDef{Self};
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbRecordMemberDef{Self};
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbRecordMemberDef;
    function SetToStr(const aToStr : TwbToStrCallback): IwbRecordMemberDef{Self};
    function SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbRecordMemberDef{Self};
    function SetRequired(const aRequired : Boolean = True): IwbRecordMemberDef{Self};

    {---IwbSubRecordDef---}
    function GetValue: IwbValueDef;
    procedure HasUnusedData;
    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean; override;

    function IncludeFlagOnValue(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbSubRecordDef{Self};

    function SetDefaultEditValue(const aValue: string): IwbSubRecordDef;
    function SetDefaultNativeValue(const aValue: Variant): IwbSubRecordDef;
    function SetDefaultEditValues(const aValues: array of string): IwbRecordMemberDef;

    function ForValue(const aCallback: TwbSubRecordForValueCallback): {Self}IwbSubRecordDef;

    function SetLinksToCallbackOnValue(const aCallback: TwbLinksToCallback): IwbSubRecordDef{Self};
    function SetSummaryLinksToCallbackOnValue(const aCallback: TwbLinksToCallback): IwbSubRecordDef{Self};

    {---IwbSubRecordWithStructDef---}
    function SetSummaryKeyOnValue(const aSummaryKey: array of Integer): {Self}IwbSubRecordWithStructDef;
    function SetSummaryPrefixSuffixOnValue(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbSubRecordWithStructDef;
    function SetSummaryMemberMaxDepthOnValue(aIndex, aMaxDepth: Integer): {Self}IwbSubRecordWithStructDef;
    function SetSummaryDelimiterOnStruct(const aDelimiter: string): {Self}IwbSubRecordWithStructDef;
    function IwbSubRecordWithStructDef.SetSummaryDelimiterOnValue = SetSummaryDelimiterOnStruct;

    {---IwbSubRecordWithArrayDef---}
    function SetSummaryPassthroughMaxCountOnValue(aCount: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryPassthroughMaxLengthOnValue(aLength: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryPassthroughMaxDepthOnValue(aDepth: Integer): IwbSubRecordWithArrayDef;
    function SetSummaryDelimiterOnArray(const aDelimiter: string): IwbSubRecordWithArrayDef;
    function IwbSubRecordWithArrayDef.SetSummaryDelimiterOnValue = SetSummaryDelimiterOnArray;
    function SetDefaultEditValuesOnValue(const aValues: array of string): IwbSubRecordWithArrayDef;
    function SetCountPathOnValue(const aValue: string; aUseForCountCallback: Boolean): IwbSubRecordWithArrayDef;
    function SetCountFromEnumOnValue(const aEnum: IwbEnumDef): IwbSubRecordWithArrayDef;
    function SetWronglyAssumedFixedSizePerElementOnValue(aSize: Integer): IwbSubRecordWithArrayDef;

    {---IwbSubRecordWithBaseStringDef---}
    function SetFormaterOnValue(const aFormater: IwbStringDefFormater): IwbSubRecordWithBaseStringDef;
  end;

  TwbRecordMemberDef = class(TwbBaseSignatureDef, IwbRecordMemberDef)
    {---IwbRecordMemberDef---}
    function ToSummary(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
    function ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string; virtual;

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbRecordMemberDef{Self};
    function SetSummaryName(const aName: string): IwbRecordMemberDef{Self};

    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbRecordMemberDef{Self};
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbRecordMemberDef{Self};
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbRecordMemberDef{Self};
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbRecordMemberDef;
    function SetToStr(const aToStr : TwbToStrCallback): IwbRecordMemberDef{Self};
    function SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbRecordMemberDef{Self};
    function SetRequired(const aRequired : Boolean = True): IwbRecordMemberDef{Self};
  end;

  TwbSubRecordArrayDef = class(TwbRecordMemberDef, IwbSubRecordArrayDef)
  private
    sraElement           : IwbRecordMemberDef;
    sraCount             : Integer;
    sraSorted            : Boolean;
    sraIsSorted          : TwbIsSortedCallback;
    sraDefaultEditValues : TwbStringArray;
    sraCountPath         : string;
  public
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority  : TwbConflictPriority;
                       aRequired: Boolean;
                 const aName      : string;
                 const aElement   : IwbRecordMemberDef;
                       aCount     : Integer;
                       aSorted    : Boolean;
                       aAfterLoad : TwbAfterLoadCallback;
                       aAfterSet  : TwbAfterSetCallback;
                       aDontShow  : TwbDontShowCallback;
                       aIsSorted  : TwbIsSortedCallback;
                       aGetCP     : TwbGetConflictPriority); reintroduce;
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbNamedDef---}
    procedure AfterLoad(const aElement: IwbElement); override;

    {---IwbSignatureDef---}
    function GetDefaultSignature: TwbSignature; override;

    function GetSignature(const aIndex: Integer): TwbSignature; override;
    function GetSignatureCount: Integer; override;

    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean; override;

    {---IwbRecordMemberDef---}
    function ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;

    {---IwbSubRecordArrayDef---}
    function GetElement: IwbRecordMemberDef;
    function GetSorted(const aContainer: IwbContainer): Boolean;
    function GetCountPath: string;
    function GetCount: Integer;

    function SetDefaultEditValues(const aValues: array of string): IwbSubRecordArrayDef;
    function GetDefaultEditValues: TwbStringArray;

    function SetCountPath(const aValue: string): IwbSubRecordArrayDef;
  end;

  TwbSubRecordStructDef = class(TwbRecordMemberDef, IwbSubRecordStructDef, IwbRecordDef)
  private
    srsMembers           : array of IwbRecordMemberDef;
    srsSignatures        : TStringList;
    srsSkipSignatures    : TStringList;
    srsAllowUnordered    : Boolean;
    srsSummaryKey        : array of Integer;
    srsSummaryPrefix     : TwbStringArray;
    srsSummarySuffix     : TwbStringArray;
    srsSummaryMaxDepth   : TArray<Integer>;
    srsSummaryDelimiter  : string;
  public
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority       : TwbConflictPriority;
                       aRequired       : Boolean;
                 const aName           : string;
                 const aMembers        : array of IwbRecordMemberDef;
                 const aSkipSigs       : TwbSignatures;
                       aDontShow       : TwbDontShowCallback;
                       aAllowUnordered : Boolean;
                       aAfterLoad      : TwbAfterLoadCallback;
                       aAfterSet       : TwbAfterSetCallback;
                       aGetCP          : TwbGetConflictPriority); reintroduce;
    procedure AfterClone(const aSource: TwbDef); override;
    destructor Destroy; override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetChildPos(const aChild: IwbDef): Integer; override;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbNamedDef---}
    procedure AfterLoad(const aElement: IwbElement); override;

    {---IwbSignatureDef---}
    function GetDefaultSignature: TwbSignature; override;

    function GetSignature(const aIndex: Integer): TwbSignature; override;
    function GetSignatureCount: Integer; override;

    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean; override;

    {---IwbRecordDef---}
    function ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Boolean; virtual;
    function GetMemberFor(const aContainer     : IwbContainerElementRef;
                                aSignature     : TwbSignature;
                          const aDataContainer : IwbDataContainer)
                                               : IwbRecordMemberDef;
    function GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Integer;
    function AllowUnordered: Boolean;
    function AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;

    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;
    function GetSkipSignature(const aSignature: TwbSignature): Boolean; virtual;
    function GetRecordHeaderStruct: IwbStructDef;

    {---IwbRecordMemberDef---}
    function ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;

    {---IwbSubRecordStructDef---}
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbSubRecordStructDef;
    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbSubRecordStructDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbSubRecordStructDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbSubRecordStructDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbSubRecordStructDef;
  end;

  TwbSubRecordUnionDef = class(TwbRecordMemberDef, IwbSubRecordUnionDef, IwbRecordDef)
  private
    sruMembers           : array of IwbRecordMemberDef;
    sruSignatures        : TStringList;
    sruSkipSignatures    : TStringList;
    sruDecider           : TwbRUnionDecider;
  public
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority : TwbConflictPriority;
                       aRequired : Boolean;
                 const aName     : string;
                 const aMembers  : array of IwbRecordMemberDef;
                 const aSkipSigs : TwbSignatures;
                 const aDontShow : TwbDontShowCallback;
                 const aGetCP    : TwbGetConflictPriority;
                 const aDecider  : TwbRUnionDecider); reintroduce;
    destructor Destroy; override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetChildPos(const aChild: IwbDef): Integer; override;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbSignatureDef---}
    function GetDefaultSignature: TwbSignature; override;

    function GetSignature(const aIndex: Integer): TwbSignature; override;
    function GetSignatureCount: Integer; override;

    function CanHandle(const aContainer     : IwbContainerElementRef;
                             aSignature     : TwbSignature;
                       const aDataContainer : IwbDataContainer)
                                            : Boolean; override;

    {---IwbRecordDef---}
    function ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Boolean; virtual;
    function GetMemberFor(const aContainer     : IwbContainerElementRef;
                                aSignature     : TwbSignature;
                          const aDataContainer : IwbDataContainer)
                                               : IwbRecordMemberDef;
    function GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                     aSignature     : TwbSignature;
                               const aDataContainer : IwbDataContainer)
                                                    : Integer;
    function AllowUnordered: Boolean;
    function AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;

    function GetMember(aIndex: Integer): IwbRecordMemberDef;
    function GetMemberCount: Integer;
    function GetSkipSignature(const aSignature: TwbSignature): Boolean; virtual;
    function GetRecordHeaderStruct: IwbStructDef;
  end;

  TwbSubRecordStructSKDef = class(TwbSubRecordStructDef, IwbHasSortKeyDef)
  private
    srsSortKey    : array of Integer;
    srsExSortKey  : array of Integer;
    srsMemberInSK : array of Boolean;
  public
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority       : TwbConflictPriority;
                       aRequired       : Boolean;
                 const aName           : string;
                 const aMembers        : array of IwbRecordMemberDef;
                 const aSkipSigs       : TwbSignatures;
                 const aSortKey        : array of Integer;
                 const aExSortKey      : array of Integer;
                       aDontShow       : TwbDontShowCallback;
                       aAllowUnordered : Boolean;
                       aAfterLoad      : TwbAfterLoadCallback;
                       aAfterSet       : TwbAfterSetCallback;
                       aGetCP          : TwbGetConflictPriority);

    {---IwbHasSortKeyDef---}
    function GetSortKey(aIndex: Integer; aExtended: Boolean): Integer;
    function GetSortKeyCount(aExtended: Boolean): Integer;
    function IsInSK(aIndex: Integer): Boolean;

    {---IwbRecordMemberDef---}
    function ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
  end;

  TwbValueDefState = (
    vdsIsVariableSize,
    vdsIsVariableSizeChecked,
    vdsHasDefaultEditValue,
    vdsHasDefaultNativeValue
  );
  TwbValueDefStates = set of TwbValueDefState;

  TwbValueDef = class(TwbNamedDef, IwbValueDef)
  protected
    vdStates                 : TwbValueDefStates;
    vdDefaultEditValue       : string;
    vdDefaultNativeValue     : Variant;
    vdLinksToCallback        : TwbLinksToCallback;
    vdEditInfo               : PwbStringArray;
    vdSetToDefault           : TwbSetToDefaultCallback;
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbValueDef---}
    function SetAfterLoad(const aAfterLoad : TwbAfterLoadCallback): IwbValueDef;
    function SetAfterSet(const aAfterSet : TwbAfterSetCallback): IwbValueDef;
    function SetDontShow(const aDontShow : TwbDontShowCallback): IwbValueDef;

    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; reintroduce; virtual; abstract;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; virtual;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; virtual;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; virtual; abstract;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; virtual; abstract;
    function GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement; virtual;
    procedure SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: IwbElement); virtual;
    procedure BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement); virtual;
    function GetIsVariableSize: Boolean;
    function GetIsVariableSizeInternal: Boolean; virtual;
    function GetCanBeZeroSize: Boolean; virtual;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); virtual;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; virtual;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); virtual;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; virtual;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; virtual;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; virtual;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; virtual;
    function GetElementMap: TDynCardinalArray; virtual;

    function SetDefaultEditValue(const aValue: string): IwbValueDef; virtual;
    function SetDefaultNativeValue(const aValue: Variant): IwbValueDef; virtual;
    function SetLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef; virtual;
    function SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef; virtual;
    function SetToStr(const aToStr : TwbToStrCallback): IwbValueDef; virtual;
    function SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbValueDef; virtual;
    function SetStaticEditInfo(aEditInfo: PwbStringArray): IwbValueDef{Self};

    function SetSetToDefault(const aCallback: TwbSetToDefaultCallback): IwbValueDef{Self};

    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbValueDef{Self}; virtual;
    function SetSummaryName(const aName: string): IwbValueDef;

    function MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean; virtual;
    procedure FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters); virtual;
    function CompareExchangeFormID(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aOldFormID: TwbFormID; aNewFormID: TwbFormID): Boolean; virtual;
  end;

  TwbGuidDef = class(TwbValueDef, IwbGuidDef)
  protected
    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
    procedure FromStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); virtual;
    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
  end;

  TwbResolvableDef = class(TwbValueDef, IwbResolvableDef)
    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---IwbDefInternal---}
    procedure InitFromParentBeforeChildren; override;
    procedure InitFromParentAfterChildren; override;
    procedure InitFromResolvedDef;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement; override;
    procedure SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: IwbElement); override;
    procedure BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement); override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;

    {---IwbResolvableDef---}
    function NeedsElementToResolve: Boolean; virtual;
    function ResolveDef(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef; virtual; abstract;
    function ResolveDefAndElement(aBasePtr: Pointer; aEndPtr: Pointer; var aElement: IwbElement): IwbValueDef; virtual;
  end;

  TwbRecursiveDef = class(TwbResolvableDef, IwbRecursiveDef)
  protected {private}
    rdLevelsUp: Integer;
    rdCached: IwbValueDef;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority : TwbConflictPriority;
                       aRequired : Boolean;
                 const aName     : string;
                       aLevelsUp : Integer;
                       aDontShow : TwbDontShowCallback;
                       aAfterSet : TwbAfterSetCallback;
                       aGetCP    : TwbGetConflictPriority); reintroduce;

    {---IwbResolvableDef---}
    function ResolveDef(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef; override;
  end;

  TwbUnionDef = class(TwbResolvableDef, IwbUnionDef)
  protected {private}
    udDecider: TwbUnionDecider;
    udMembers: array of IwbValueDef;
    udMemberTypes: TwbDefTypes;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority : TwbConflictPriority;
                       aRequired : Boolean;
                 const aName     : string;
                       aDecider  : TwbUnionDecider;
                 const aMembers  : array of IwbValueDef;
                       aDontShow : TwbDontShowCallback;
                       aAfterSet : TwbAfterSetCallback;
                       aGetCP    : TwbGetConflictPriority); reintroduce;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetChildPos(const aChild: IwbDef): Integer; override;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbValueDef---}
    function GetIsVariableSizeInternal: Boolean; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;

    {---IwbResolvableDef---}
    function NeedsElementToResolve: Boolean; override;
    function ResolveDef(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef; override;
    function ResolveDefAndElement(aBasePtr: Pointer; aEndPtr: Pointer; var aElement: IwbElement): IwbValueDef; override;

    {---IwbUnionDef---}
    function GetMember(aIndex: Integer): IwbValueDef;
    function GetMemberCount: Integer;
    function GetMemberTypes: TwbDefTypes;
  end;

  TwbStringTransformType = (
    ttToString,
    ttToSortKey,
    ttCheck,
    ttToEditValue,
    ttFromEditValue,
    ttToNativeValue,
    ttFromNativeValue
  );

  TwbBaseStringDef = class(TwbValueDef, IwbBaseStringDef)
  protected
    bsdEncodingOverride : TEncoding;
    bsdFormater         : IwbStringDefFormater;
    function bsdGetEncoding(const aElement: IwbElement): TEncoding;
  protected
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbValueDef---}
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; override;

    {---IwbBaseStringDef---}
    function OverrideEncoding(aEncoding: TEncoding): IwbBaseStringDef;
    function SetFormater(const aFormater: IwbStringDefFormater): IwbBaseStringDef;
  public
    constructor Create(aPriority: TwbConflictPriority; aRequired: Boolean;
      const aName: string; aAfterLoad: TwbAfterLoadCallback;
      aAfterSet: TwbAfterSetCallback; aDontShow: TwbDontShowCallback;
      aGetCP: TwbGetConflictPriority; aTerminator: Boolean); reintroduce;
  end;

  TwbStringDef = class(TwbBaseStringDef, IwbStringDef)
  protected
    sdSize     : Integer;
    sdForward  : Boolean;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aSize       : Integer;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean;
                       aForward    : Boolean = False); virtual;
    procedure AfterClone(const aSource: TwbDef); override;

    function ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string; virtual;
    function ToStringTransform(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string;

    procedure FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType); virtual;
    procedure FromStringTransform(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType);

    function TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string; virtual;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;

    {---IwbStringDef---}
    function GetStringSize: Integer;
    function SetFormater(const aFormater: IwbStringDefFormater): IwbStringDef;
  end;

  TwbStringScriptDef = class(TwbStringDef)
  protected
    function TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string; override;
  end;

  TwbStringLCDef = class(TwbStringDef)
  protected
    function TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string; override;
  end;

  TwbStringKCDef = class(TwbStringDef)  // Keep Case
  protected
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
  end;

  TwbStringMgefCodeDef = class(TwbStringDef)
  protected
    function ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string; override;
    procedure FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType); override;

    {---IwbValueDef---}
    function GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement; override;
    procedure SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: IwbElement); override;
    procedure BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement); override;

    function MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean; override;
    procedure FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters); override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
  public
    procedure AfterConstruction; override;
  end;

  TwbLStringDef = class(TwbStringDef)
  protected
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aSize       : Integer;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean;
                       aForward    : Boolean = False); override;
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string; override;
    procedure FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType); override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
  end;

  TwbLStringKCDef = class(TwbLStringDef)
  protected
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
  end;

  TwbLenStringDef = class(TwbBaseStringDef, IwbLenStringDef)
  protected
    Prefix: Integer;
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aPrefix     : integer;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean);

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---TwbLenStringDef---}
    function ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
    function SetFormater(const aFormater: IwbStringDefFormater): IwbLenStringDef;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;

    function GetPrefixLen: Integer;
    function GetPrefixOffset: Integer;
    function GetPrefixValue(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
    procedure SetPrefixValue(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aValue: Cardinal);
  end;

  TwbByteArrayDef = class(TwbValueDef, IwbByteArrayDef)
  protected {private}
    badSize                : Int64;

    FoundReflection        : Boolean;

    FoundFormIDAtOffSet    : array of Integer;
    NotFoundFormIDAtOffSet : array of Integer;
    SignaturesAtOffSet     : array of TStringList;
    FormIDsAtOffSetFoundIn : array of TStringList;

    FoundDoubleAtOffSet     : array of Integer;
    NotFoundDoubleAtOffSet  : array of Integer;
    DoublesAtOffSet         : array of TStringList;

    FoundFloatAtOffSet     : array of Integer;
    NotFoundFloatAtOffSet  : array of Integer;
    FloatsAtOffSet         : array of TStringList;

    FoundHalfAtOffSet     : array of Integer;
    NotFoundHalfAtOffSet  : array of Integer;
    HalfsAtOffSet         : array of TStringList;

    FoundString            : Integer;
    NotFoundString         : Integer;
    Strings                : TStringList;

    FoundLStringAtOffSet     : array of Integer;
    NotFoundLStringAtOffSet  : array of Integer;
    LStringsAtOffSet         : array of TStringList;

    IsEmpty                 : Integer;
    IsNotEmpty              : Integer;

    badCountCallback        : TwbCountCallBack;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority      : TwbConflictPriority;
                       aRequired      : Boolean;
                 const aName          : string;
                       aSize          : Int64;
                       aDontShow      : TwbDontShowCallback;
                       aCountCallback : TwbCountCallback;
                       aGetCP         : TwbGetConflictPriority;
                       aTerminator    : Boolean); reintroduce;
    procedure AfterClone(const aSource: TwbDef); override;

    function ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    procedure Report(const aParents: TwbDefPath); override;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
  end;

  TwbReflectionDef = class(TwbByteArrayDef, IwbReflectionDef)
  protected
    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
  public
    procedure AfterConstruction; override;
  end;

  TwbEmptyDef = class(TwbValueDef, IwbEmptyDef)
  protected {private}
    edSorted: Boolean;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority  : TwbConflictPriority;
                       aRequired  : Boolean;
                 const aName      : string;
                       aAfterLoad : TwbAfterLoadCallback; aAfterSet : TwbAfterSetCallback;
                       aDontShow  : TwbDontShowCallback;
                       aSorted    : Boolean;
                       aGetCP     : TwbGetConflictPriority); reintroduce;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetCanBeZeroSize: Boolean; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;

    {--- IwbEmptyDef ---}
    function GetSorted: Boolean;
  end;

  TwbIntegerDef = class(TwbValueDef, IwbIntegerDef, IwbIntegerDefInternal)
  private
    inType            : TwbIntType;
    inFormater        : IwbIntegerDefFormater;
    inDefault         : Int64;
    inOverlayCallback : TwbIntOverlayCallback;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                 const aIntType    : TwbIntType;
                 const aFormater   : IwbIntegerDefFormater;
                       aDontShow   : TwbDontShowCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDefault    : Int64;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean); reintroduce;
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; override;
    procedure Report(const aParents: TwbDefPath); override;
    function GetNoReach: Boolean; override;
    function IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbValueDef{Self}; override;

    function GetConflictPriority(const aElement: IwbElement): TwbConflictPriority; override;
    function GetConflictPriorityCanChange: Boolean; override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement; override;
    procedure SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: IwbElement); override;
    procedure BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement); override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;

    function SetDefaultNativeValue(const aValue: Variant): IwbValueDef; override;

    function MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean; override;
    procedure FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters); override;
    function CompareExchangeFormID(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aOldFormID: TwbFormID; aNewFormID: TwbFormID): Boolean; override;

    {---IwbIntegerDef---}
    function ToInt(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Int64;
    procedure FromInt(aValue: Int64; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
    function GetFormater(const aElement: IwbElement): IwbIntegerDefFormater;
    function GetFormaterCanChange: Boolean;
    function GetIntType: TwbIntType;
    function GetExpectedLength(aValue: Int64 = 0): Integer;

    function AddOverlay(const aCallback: TwbIntOverlayCallback): IwbIntegerDef;

    {---IwbIntegerDefInternal---}
    procedure ReplaceFormater(const aFormater: IwbIntegerDefFormater);
  end;

  TwbFloatDef = class(TwbValueDef, IwbFloatDef)
  private
    fdDefault    : Extended;
    fdScale      : Extended;
    fdDigits     : Integer;
    fdNormalizer : TwbFloatNormalizer;
    fdKind       : TwbFloatKind;
  protected
    constructor Clone(const aSource: TwbDef); override;
    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---IwbValueDef---}
    function ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aIncludeWarnings: Boolean): string;
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    procedure FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string); override;
    function ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant; override;
    procedure FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant); override;
    function GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean; override;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; override;

    function SetDefaultNativeValue(const aValue: Variant): IwbValueDef; override;

    function ToValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Extended;
    procedure FromValue(aValue: Extended; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);

    {---IwbFloatDef---}
    function GetKind: TwbFloatKind;
  public
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aScale      : Extended;
                       aDigits     : Integer;
                       aDontShow   : TwbDontShowCallback;
                       aNormalizer : TwbFloatNormalizer;
                       aDefault    : Extended;
                       aGetCP      : TwbGetConflictPriority;
                       aKind       : TwbFloatKind;
                       aTerminator : Boolean); reintroduce;
  end;

  TwbArrayDef = class(TwbValueDef, IwbArrayDef)
  private
    arCount             : Integer;
    arCountCallback     : TwbCountCallback;
    arElement           : IwbValueDef;
    arLabels            : array of string;
    arSorted            : Boolean;
    arCanAddTo          : Boolean;
    arTerminated        : Boolean;
    arDefaultEditValues : TwbStringArray;
    arCountPath         : string;
    arShouldInclude     : TwbShouldIncludeCallback;
    arWronglyAssumedFixedSizePerElement: Integer;

    arSummaryDelimiter            : string;
    arSummaryPassthroughMaxCount  : Integer;
    arSummaryPassthroughMaxLength : Integer;
    arSummaryPassthroughMaxDepth  : Integer;
  protected
    constructor Clone(const aSource: TwbDef); override;

    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                 const aElement    : IwbValueDef;
                       aCount      : Integer;
                 const aLabels     : array of string;
                       aSorted     : Boolean;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aCanAddTo   : Boolean;
                       aTerminator : Boolean;
                       aTerminated : Boolean); reintroduce; overload;

    constructor Create(aPriority      : TwbConflictPriority;
                       aRequired      : Boolean;
                 const aName          : string;
                 const aElement       : IwbValueDef;
                       aCountCallback : TwbCountCallback;
                 const aLabels        : array of string;
                       aSorted        : Boolean;
                       aAfterLoad     : TwbAfterLoadCallback;
                       aAfterSet      : TwbAfterSetCallback;
                       aDontShow      : TwbDontShowCallback;
                       aGetCP         : TwbGetConflictPriority;
                       aCanAddTo      : Boolean;
                       aTerminator    : Boolean;
                       aTerminated    : Boolean); reintroduce; overload;
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbValueDef---}
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function GetCanBeZeroSize: Boolean; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---IwbArrayDef---}
    function GetElement: IwbValueDef;
    function GetCount: Integer;
    function GetElementLabel(aIndex: Integer): string;
    function GetElementNameSuffix(aIndex: Integer): string;
    function GetSorted: Boolean;
    function GetCanAddTo: Boolean;
    function GetCountCallBack: TwbCountCallback;
    function GetPrefixSize(aBasePtr: Pointer): Integer;
    function GetPrefixLength(aBasePtr: Pointer): Integer;
    function GetPrefixCount(aBasePtr: Pointer): Cardinal;
    procedure SetPrefixCount(aBasePtr: Pointer; aValue: Cardinal);

    function SetSummaryPassthroughMaxCount(aCount: Integer): IwbArrayDef;
    function SetSummaryPassthroughMaxLength(aLength: Integer): IwbArrayDef;
    function SetSummaryDelimiter(const aDelimiter: string): IwbArrayDef;
    function SetSummaryPassthroughMaxDepth(aCount: Integer): IwbArrayDef;

    function SetDefaultEditValues(const aValues: array of string): IwbArrayDef;
    function GetDefaultEditValues: TwbStringArray;

    function GetCountPath: string;
    function SetCountPath(const aValue: string; aUseForCountCallback: Boolean): IwbArrayDef;

    function SetShouldInclude(const aCallback: TwbShouldIncludeCallback): IwbArrayDef;
    function ShouldInclude(aBasePtr: Pointer; aEndPtr: Pointer; const aArray: IwbElement): Boolean;

    function SetCountFromEnum(const aEnum: IwbEnumDef): IwbArrayDef;

    function SetWronglyAssumedFixedSizePerElement(aSize: Integer): IwbArrayDef;
    function GetWronglyAssumedFixedSizePerElement: Integer;
  end;

  TwbStructDef = class(TwbValueDef, IwbStructDef)
  private
    stMembers             : array of IwbValueDef;
    stSortKey             : array of Integer;
    stExSortKey           : array of Integer;
    stSummaryKey          : array of Integer;
    stElementMap          : TDynCardinalArray;
    stOptionalFromElement : Integer;
    stSummaryPrefix       : TwbStringArray;
    stSummarySuffix       : TwbStringArray;
    stSummaryMaxDepth     : TArray<Integer>;
    stSummaryDelimiter    : string;
    stSizeCallback        : TwbStructSizeCallback;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority            : TwbConflictPriority;
                       aRequired            : Boolean;
                 const aName                : string;
                 const aMembers             : array of IwbValueDef;
                 const aSortKey             : array of Integer;
                 const aExSortKey           : array of Integer;
                 {$IFDEF WIN32}
                 const aElementMap          : array of Cardinal;
                 {$ENDIF WIN32}
                 {$IFDEF WIN64}
                 const aElementMap          : array of UInt64;
                 {$ENDIF WIN64}
                       aOptionalFromElement : Integer;
                       aDontShow            : TwbDontShowCallback;
                       aAfterLoad           : TwbAfterLoadCallback;
                       aAfterSet            : TwbAfterSetCallback;
                       aGetCP               : TwbGetConflictPriority); reintroduce;
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetChildPos(const aChild: IwbDef): Integer; override;

    procedure Report(const aParents: TwbDefPath); override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbValueDef---}
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string; override;
    function ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string; override;
    function GetIsVariableSizeInternal: Boolean; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetElementMap: TDynCardinalArray; override;

    {---IwbStructDef---}
    function GetMemberCount: Integer;
    function GetMember(aIndex: Integer): IwbValueDef;
    function GetMemberByName(const aName: string): IwbValueDef;
    function GetOptionalFromElement: Integer;

    function SetSummaryKey(const aSummaryKey: array of Integer): {Self}IwbStructDef;
    function SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): {Self}IwbStructDef;
    function SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): {Self}IwbStructDef;
    function SetSummaryDelimiter(const aDelimiter: string): {Self}IwbStructDef;

    function SetSizeCallback(const aCallback: TwbStructSizeCallback): {Self}IwbStructDef;
  end;

  TwbStructCDef = class(TwbStructDef, IwbStructCDef)
  private
    scSizeCallback       : TwbSizeCallback;
    scGetChapterType     : TwbGetChapterTypeCallback;
    scGetChapterTypeName : TwbGetChapterTypeNameCallback;
    scGetChapterName     : TwbGetChapterNameCallback;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority            : TwbConflictPriority;
                       aRequired            : Boolean;
                 const aName                : string;
                 const aMembers             : array of IwbValueDef;
                 const aSortKey             : array of Integer;
                 const aExSortKey           : array of Integer;
                       aOptionalFromElement : Integer;
                       aDontShow            : TwbDontShowCallback;
                       aAfterLoad           : TwbAfterLoadCallback;
                       aAfterSet            : TwbAfterSetCallback;
                       aSizeCallBack        : TwbSizeCallback;
                       aGetChapterType      : TwbGetChapterTypeCallback;
                       aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                       aGetChapterName      : TwbGetChapterNameCallback;
                       aGetCP               : TwbGetConflictPriority);
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
  public
    function GetSizing(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement;var CompressedSize: Integer): Cardinal; virtual;
    function GetChapterType(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer; virtual;
    function GetChapterTypeName(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
    function GetChapterName(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): string; virtual;
  end;

  TwbStructZDef = class(TwbStructCDef, IwbStructZDef)
  end;

  TwbStructLZDef = class(TwbStructCDef, IwbStructLZDef)
  end;

  TwbIntegerDefFormater = class(TwbNamedDef, IwbIntegerDefFormater)
  protected
    constructor Create; reintroduce;
    constructor Clone(const aSource: TwbDef); override;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; reintroduce; virtual; abstract;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; virtual; abstract;
    function Check(aInt: Int64; const aElement: IwbElement): string; virtual;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement); virtual;

    function GetEditType(const aElement: IwbElement): TwbEditType; virtual;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; virtual;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; virtual;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; virtual;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; virtual;
    function GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement; virtual;
    function FromLinksTo(const aValue, aElement: IwbElement): Int64; virtual;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64; virtual;
    procedure FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement); virtual;
    function CompareExchangeFormID(var aInt: Int64; aOldFormID: TwbFormID; aNewFormID: TwbFormID; const aElement: IwbElement): Boolean; virtual;

    function GetRequiresKey: Boolean; virtual;
  end;

  TwbIntegerDefFormaterUnion = class(TwbIntegerDefFormater, IwbIntegerDefFormaterUnion)
  private
    idfuDecider: TwbIntegerDefFormaterUnionDecider;
    idfuMembers: array of IwbIntegerDefFormater;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aDecider  : TwbIntegerDefFormaterUnionDecider;
                 const aMembers  : array of IwbIntegerDefFormater);

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    procedure Report(const aParents: TwbDefPath); override;
    function GetNoReach: Boolean; override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function Check(aInt: Int64; const aElement: IwbElement): string; override;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement); override;

    function GetEditType(const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
    function GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement; override;
    function FromLinksTo(const aValue, aElement: IwbElement): Int64; override;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; override;

    function MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64; override;
    procedure FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement); override;
    function CompareExchangeFormID(var aInt: Int64; aOldFormID: TwbFormID; aNewFormID: TwbFormID; const aElement: IwbElement): Boolean; override;

    {---IwbIntegerDefFormaterUnion---}
    function Decide(const aElement: IwbElement): IwbIntegerDefFormater;

    function GetMember(aIndex: Integer): IwbIntegerDefFormater;
    function GetMemberCount: Integer;

    property Members[aIndex: Integer]: IwbIntegerDefFormater read GetMember;
    property MemberCount: Integer read GetMemberCount;
  end;

  TwbDumpIntegerDefFormater = class(TwbIntegerDefFormater, IwbDumpIntegerDefFormater)
  protected
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
  end;

  TwbFormIDDefFormater = class(TwbIntegerDefFormater, IwbFormID)
  private
    {reporting mode only}
    FoundSignatures: TStringList;
    FoundNotAllowedReferences: TStringList;
    NotResolved: TStringList;
  protected
    fidExactIdent: Integer;

    constructor Clone(const aSource: TwbDef); override;

    function IsValid(const aSignature: TwbSignature): Boolean; virtual;
    function IsValidFlst(const aSignature: TwbSignature): Boolean; virtual;
    function CheckFlst(const aMainRecord: IwbMainRecord): Boolean; virtual;
    function IsValidMainRecord(const aMainRecord: IwbMainRecord): Boolean; virtual;

    function GetExactIdentString: string; virtual;
    function GetExactIdent: Integer;

    function FindRecordForAVCode(aInt: Int64; const aElement: IwbElement): IwbMainRecord;

    {---IwbDef---}
    procedure Report(const aParents: TwbDefPath); override;

    {---IwbIntegerDefFormater---}
    function Check(aInt: Int64; const aElement: IwbElement): string; override;
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement); override;

    function GetEditType(const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
    function GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement; override;
    function FromLinksTo(const aValue, aElement: IwbElement): Int64; override;

    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; override;

    function MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64; override;
    procedure FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement); override;
    function CompareExchangeFormID(var aInt: Int64; aOldFormID: TwbFormID; aNewFormID: TwbFormID; const aElement: IwbElement): Boolean; override;

    {---IwbFormID---}
    function GetMainRecord(aInt: Int64; const aElement: IwbElement): IwbMainRecord; virtual;
  public
    procedure AfterConstruction; override;
  end;

  TwbRefID = class(TwbFormIDDefFormater, IwbRefID)
  protected
    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement); override;
  end;

  TwbFormIDChecked = class(TwbFormIDDefFormater, IwbFormIDChecked)
  protected {private}
    fidcValidRefsArr     : TwbSignatures;
    fidcValidRefs        : TStringList;
    fidcValidFlstRefsArr : TwbSignatures;
    fidcValidFlstRefs    : TStringList;
    fidcPersistent       : Boolean;
    fidcNoReach          : Boolean;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(const aValidRefs     : TwbSignatures;
                       const aValidFlstRefs : TwbSignatures;
                             aPersistent    : Boolean;
                             aNoReach       : Boolean = False);
    destructor Destroy; override;

    function IsValid(const aSignature: TwbSignature): Boolean; override;
    function IsValidFlst(const aSignature: TwbSignature): Boolean; override;
    function CheckFlst(const aMainRecord: IwbMainRecord): Boolean; override;
    function IsValidMainRecord(const aMainRecord: IwbMainRecord): Boolean; override;

    function GetExactIdentString: string; override;

    {---IwbDef---}
    procedure Report(const aParents: TwbDefPath); override;
    function GetNoReach: Boolean; override;

    {---IwbIntegerDefFormater---}
    function Check(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    {---IwbFormIDChecked---}
    function GetSignature(aIndex: Integer): TwbSignature;
    function GetSignatureCount: Integer;
  end;

  TwbFormIDCheckedST = class(TwbFormIDChecked)
  end;

  TwbChar4 = class(TwbIntegerDefFormater, IwbChar4)
  protected
    constructor Clone(const aSource: TwbDef); override;

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    procedure BuildRef(aInt: Int64; const aElement: IwbElement); override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement; override;
    function FromLinksTo(const aValue, aElement: IwbElement): Int64; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
  public
    procedure AfterConstruction; override;
  end;

  TwbStr4 = class(TwbIntegerDefFormater, IwbStr4)
  protected
    constructor Clone(const aSource: TwbDef); override;

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
  end;

  TwbFlagsDef = class(TwbIntegerDefFormater, IwbFlagsDef)
  private
    flgBaseFlagsDef    : IwbFlagsDef;
    flgNames           : TwbStringArray;
    flgSummaries       : TwbStringArray;
    flgDontShows       : TArray<TwbDontShowCallback>;
    flgHasDontShows    : Boolean;
    flgUnusedMask      : Int64;
    flgIgnoreMask      : Int64;
    flgUnknownIsUnused : Boolean;
    flgGetCPs          : TArray<TwbGetConflictPriority>;
    flgHasGetCPs       : Boolean;
    flgFlagDefs        : TArray<IwbFlagDef>;
    flgDontShowPath    : string;
    flgDontShowInvert  : Boolean;
    flgDeletedIndex    : ShortInt;
    flgPartialFormIndex: ShortInt;

    UnknownFlags       : array[0..63] of Integer;
    HasUnknownFlags    : Boolean;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aHasSummary      : Boolean;
                 const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean;
                       aIgnoreMask      : Int64;
                 const aGetCPs          : array of TwbGetConflictPriority);
    procedure AfterClone(const aSource: TwbDef); override;

    {---IwbDef---}
    procedure Report(const aParents: TwbDefPath); override;
    function GetChildPos(const aChild: IwbDef): Integer; override;

    function GetConflictPriority(const aElement: IwbElement): TwbConflictPriority; override;
    function GetConflictPriorityCanChange: Boolean; override;

    function GetDefTypeName: string; override;

    {---IwbDefInternal---}
    procedure InitFromParentDoChildren; override;

    {---IwbIntegerDefFormater---}
    function Check(aInt: Int64; const aElement: IwbElement): string; override;
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;
    function Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement; override;
    function GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs; override;

    function GetEditType(const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;

    function GetRequiresKey: Boolean; override;

    {---IwbFlagsDef---}
    function GetBaseFlagsDef: IwbFlagsDef;
    function GetFlag(aIndex: Integer; aForSummary: Boolean): string;
    function GetFlagCount: Integer;
    function GetFlagIgnoreConflict(aIndex: Integer): Boolean;
    function GetFlagDontShow(const aElement: IwbElement; aIndex: Integer): Boolean;
    function GetFlagHasDontShow(aIndex: Integer): Boolean;
    procedure FlagGetCP(const aElement: IwbElement; aIndex: Integer; var aCP: TwbConflictPriority);
    function GetFlagHasGetCP(aIndex: Integer): Boolean;
    function GetFlagDef(aIndex : Integer): IwbFlagDef;
    function FindFlag(aName: string; out aFlagDef: IwbFlagDef): Boolean;

    function SetDontShowMaskPath(const aPath: string; aInvert: Boolean): IwbFlagsDef;
    function SetFlagHasDontShow(aIndex: Integer; const aDontShow: TwbDontShowCallback): IwbFlagsDef;
  end;

  TwbFlagDef = class(TwbValueDef, IwbFlagDef)
  private
    fdFlagIndex : Integer;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                 const aName       : string;
                       aAfterLoad  : TwbAfterLoadCallback;
                       aAfterSet   : TwbAfterSetCallback;
                       aDontShow   : TwbDontShowCallback;
                       aGetCP      : TwbGetConflictPriority;
                       aTerminator : Boolean;
                       aFlagIndex  : Integer); reintroduce;

    {---IwbDef---}
    function GetDefType: TwbDefType; override;
    function GetDefTypeName: string; override;
    function GetHasDontShow: Boolean; override;
    function GetDontShow(const aElement: IwbElement): Boolean; override;
    function GetConflictPriority(const aElement: IwbElement): TwbConflictPriority; override;
    function GetConflictPriorityCanChange: Boolean; override;
    function GetCanBeZeroSize: Boolean; override;

    {---IwbValueDef---}
    function ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string; override;
    function GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;
    function GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer; override;

    {---IwbFlagDef---}
    function GetFlagsDef: IwbFlagsDef;
    function GetFlagIndex: Integer;
  end;

  PwbSparseName = ^TwbSparseName;
  TwbSparseName = record
    snIndex   : Int64;
    snName    : string;
    snSummary : string;
  end;

  TwbEnumDictionary = TDictionary<string, Int64>;

  TwbEnumDef = class(TwbIntegerDefFormater, IwbEnumDef, IwbStringDefFormater)
  private
    enNames          : array of string;
    enSummaries      : array of string;
    enSparseNames    : array of TwbSparseName;
    enSparseNamesMap : array of PwbSparseName;
    enEditInfo       : TwbStringArray;
    enDictionary     : TwbEnumDictionary;

    UnknownEnums: TStringList;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aHasSummary  : Boolean;
                 const aNames       : array of string;
                 const aSparseNames : array of const);
    destructor Destroy; override;

    function FindSparseName(aSearchIndex: Int64; var Index: Integer): Boolean;

    {---IwbDef---}
    procedure Report(const aParents: TwbDefPath); override;
    function GetDefTypeName: string; override;

    {---IwbIntegerDefFormater---}
    function Check(aInt: Int64; const aElement: IwbElement): string; overload; override;
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; overload; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; overload; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function GetEditType(const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; overload; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; overload; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;

    {---IwbStringDefFormater---}
    function Check(const aString: string; const aElement: IwbElement): string; overload;
    function ToString(const aString: string; const aElement: IwbElement; aForSummary: Boolean): string; overload;
    function ToSortKey(const aString: string; const aElement: IwbElement): string; overload;

    function ToEditValue(const aString: string; const aElement: IwbElement): string; overload;
    function StringFromEditValue(const aValue: string; const aElement: IwbElement): string; overload;
    function IwbStringDefFormater.FromEditValue = StringFromEditValue;

    {---IwbEnumDef---}
    function GetName(aIndex: Int64): string;
    function GetNameCount: Integer;

    function FindName(const aName: string; out aIndex: Int64): Boolean;
  end;

  TwbKey2Data6EnumDef = class(TwbEnumDef, IwbKey2Data6EnumDef)
  protected
    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
  end;

  TwbData6Key2EnumDef = class(TwbEnumDef, IwbData6Key2EnumDef)
  protected
    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
  end;

  TwbDivDef = class(TwbIntegerDefFormater)
  private
    ddValue: Integer;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aValue: Integer);

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
  end;

  TwbMulDef = class(TwbIntegerDefFormater)
  private
    mdValue: Integer;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(aValue: Integer);

    {---IwbIntegerDefFormater---}
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;
  end;

  TwbCallbackDef = class(TwbIntegerDefFormater, IwbCallbackDef)
  private
    cdToStr: TwbIntToStrCallback;
    cdToInt: TwbStrToIntCallback;
  protected
    constructor Clone(const aSource: TwbDef); override;
    constructor Create(const aToStr : TwbIntToStrCallback;
                       const aToInt : TwbStrToIntCallback);

    {---IwbIntegerDefFormater---}
    function Check(aInt: Int64; const aElement: IwbElement): string; override;
    function ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string; override;
    function ToSortKey(aInt: Int64; const aElement: IwbElement): string; override;
    function CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean; override;

    function GetEditType(const aElement: IwbElement): TwbEditType; override;
    function GetEditInfo(const aElement: IwbElement): TwbStringArray; override;

    function ToEditValue(aInt: Int64; const aElement: IwbElement): string; override;
    function FromEditValue(const aValue: string; const aElement: IwbElement): Int64; override;
    function GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean; override;

    {---IwbCallbackDef---}
    function GetCallback: TwbIntToStrCallback;
  end;

var
  _NamedIndices: TStringList;
  _NamedIndicesNames: TwbStringArray;
  _NamedIndicesCaseSensitive: set of Byte;

function wbNamedIndex(const aName: string; aCaseSensitive: Boolean): TwbNamedIndex;
begin
  if not Assigned(_NamedIndices) then
    _NamedIndices := TwbFastStringListIC.CreateSorted(dupIgnore);

  var lIndex: Integer;
  if _NamedIndices.Find(aName, lIndex) then
    Exit(TwbNamedIndex(_NamedIndices.Objects[lIndex]));

  Result := _NamedIndices.Count;
  _NamedIndices.AddObject(aName, TObject(Result));
  if aCaseSensitive then
    Include(_NamedIndicesCaseSensitive, Result);
  SetLength(_NamedIndicesNames, Succ(Result));
  _NamedIndicesNames[Result] := aName;
end;

function wbNamedIndexName(aIndex : TwbNamedIndex)
                                 : string;
begin
  if (aIndex >= Low(_NamedIndicesNames)) and (aIndex <= High(_NamedIndicesNames)) then
    Exit(_NamedIndicesNames[aIndex]);
  Result := '';
end;

function wbNamedIndexComparer(aIndex: TwbNamedIndex): IwbNamedIndexEqualityComparer;
begin
  if (aIndex >=0) and (aIndex < _NamedIndices.Count) and not (aIndex in _NamedIndicesCaseSensitive) then
    Result := TIStringComparer.Ordinal
  else
    Result := TStringComparer.Ordinal;
end;

function wbRecord(const aSignature       : TwbSignature;
                  const aName            : string;
                  const aKnownSRs        : PwbKnownSubRecordSignatures;
                  const aMembers         : array of IwbRecordMemberDef;
                        aAllowUnordered  : Boolean = False;
                        aAddInfoCallback : TwbAddInfoCallback = nil;
                        aPriority        : TwbConflictPriority = cpNormal;
                        aRequired        : Boolean = False;
                        aAfterLoad       : TwbAfterLoadCallback = nil;
                        aAfterSet        : TwbAfterSetCallback = nil)
                                         : IwbMainRecordDef;
begin
  Result := wbRecord(aSignature, aName, aKnownSRs, nil, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet);
end;

function wbRecord(const aSignature       : TwbSignature;
                  const aName            : string;
                  const aMembers         : array of IwbRecordMemberDef;
                        aAllowUnordered  : Boolean = False;
                        aAddInfoCallback : TwbAddInfoCallback = nil;
                        aPriority        : TwbConflictPriority = cpNormal;
                        aRequired        : Boolean = False;
                        aAfterLoad       : TwbAfterLoadCallback = nil;
                        aAfterSet        : TwbAfterSetCallback = nil)
                                         : IwbMainRecordDef;
begin
  Result := wbRecord(aSignature, aName, nil, nil, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet);
end;

function wbRecord(const aSignature       : TwbSignature;
                  const aName            : string;
                  const aKnownSRs        : PwbKnownSubRecordSignatures;
                  const aRecordFlags     : IwbIntegerDefFormater;
                  const aMembers         : array of IwbRecordMemberDef;
                        aAllowUnordered  : Boolean;
                        aAddInfoCallback : TwbAddInfoCallback;
                        aPriority        : TwbConflictPriority;
                        aRequired        : Boolean;
                        aAfterLoad       : TwbAfterLoadCallback;
                        aAfterSet        : TwbAfterSetCallback;
                        aIsReference     : Boolean)
                                         : IwbMainRecordDef; overload;
var
  Hash     : Integer;
  Index    : Integer;
  RDE      : PwbRecordDefEntry;
  NewIndex : Integer;
begin
  Hash := Cardinal(aSignature) mod RecordDefHashMapSize;
  Index := Pred(wbRecordDefHashMap[Hash]);
  if Index >= 0 then begin
    RDE := @wbRecordDefs[Index];
    while Assigned(RDE) do begin
      if Cardinal(RDE.rdeSignature) = Cardinal(aSignature) then
        raise Exception.CreateFmt('Duplicated record definition for signature %s', [string(aSignature)]);
      if RDE.rdeNext >= 0 then
        RDE := @wbRecordDefs[RDE.rdeNext]
      else
        RDE := nil;
    end;
  end;

  Result := TwbMainRecordDef.Create(aPriority, aRequired, aSignature, aName, aKnownSRs, aRecordFlags, aMembers, aAllowUnordered, aAddInfoCallback, aAfterLoad, aAfterSet, aIsReference);
  NewIndex := Length(wbRecordDefs);
  SetLength(wbRecordDefs, Succ(NewIndex));
  with wbRecordDefs[NewIndex] do begin
    rdeDef := Result;
    rdeSignature := aSignature;
    rdeHash := Hash;
    rdeNext := Index;
  end;
  wbRecordDefHashMap[Hash] := Succ(NewIndex);
end;

function wbRecord(const aSignature       : TwbSignature;
                  const aName            : string;
                  const aRecordFlags     : IwbIntegerDefFormater;
                  const aMembers         : array of IwbRecordMemberDef;
                        aAllowUnordered  : Boolean = False;
                        aAddInfoCallback : TwbAddInfoCallback = nil;
                        aPriority        : TwbConflictPriority = cpNormal;
                        aRequired        : Boolean = False;
                        aAfterLoad       : TwbAfterLoadCallback = nil;
                        aAfterSet        : TwbAfterSetCallback = nil)
                                         : IwbMainRecordDef;
begin
  Result := wbRecord(aSignature, aName, nil, aRecordFlags, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet, False);
end;

function wbRecord(const aSignature       : TwbSignature;
                  const aName            : string;
                  const aKnownSRs        : PwbKnownSubRecordSignatures;
                  const aRecordFlags     : IwbIntegerDefFormater;
                  const aMembers         : array of IwbRecordMemberDef;
                        aAllowUnordered  : Boolean = False;
                        aAddInfoCallback : TwbAddInfoCallback = nil;
                        aPriority        : TwbConflictPriority = cpNormal;
                        aRequired        : Boolean = False;
                        aAfterLoad       : TwbAfterLoadCallback = nil;
                        aAfterSet        : TwbAfterSetCallback = nil)
                                         : IwbMainRecordDef;
begin
  Result := wbRecord(aSignature, aName, aKnownSRs, aRecordFlags, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet, False);
end;

function wbRefRecord(const aSignature       : TwbSignature;
                     const aName            : string;
                     const aMembers         : array of IwbRecordMemberDef;
                           aAllowUnordered  : Boolean = False;
                           aAddInfoCallback : TwbAddInfoCallback = nil;
                           aPriority        : TwbConflictPriority = cpNormal;
                           aRequired        : Boolean = False;
                           aAfterLoad       : TwbAfterLoadCallback = nil;
                           aAfterSet        : TwbAfterSetCallback = nil)
                                            : IwbMainRecordDef;
begin
  Result := wbRefRecord(aSignature, aName, nil, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet);
end;

function wbRefRecord(const aSignature       : TwbSignature;
                     const aName            : string;
                     const aRecordFlags     : IwbIntegerDefFormater;
                     const aMembers         : array of IwbRecordMemberDef;
                           aAllowUnordered  : Boolean = False;
                           aAddInfoCallback : TwbAddInfoCallback = nil;
                           aPriority        : TwbConflictPriority = cpNormal;
                           aRequired        : Boolean = False;
                           aAfterLoad       : TwbAfterLoadCallback = nil;
                           aAfterSet        : TwbAfterSetCallback = nil)
                                            : IwbMainRecordDef;
begin
  Result := wbRecord(aSignature, aName, nil, aRecordFlags, aMembers, aAllowUnordered, aAddInfoCallback, aPriority, aRequired, aAfterLoad, aAfterSet, True);
  wbRefRecordDefs.Add(Result);
end;

function wbSubRecord(const aSignature : TwbSignature;
                     const aName      : string;
                     const aValue     : IwbValueDef;
                           aAfterLoad : TwbAfterLoadCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aSizeMatch : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef;
begin
  Result := TwbSubRecordDef.Create(aPriority, aRequired, aSignature, aName, aValue, aAfterLoad, aAfterSet, aSizeMatch, aDontShow, aGetCP);
end;

function wbSubRecord(const aSignatures : TwbSignatures;
                     const aName       : string;
                     const aValue      : IwbValueDef;
                           aAfterLoad  : TwbAfterLoadCallback = nil; aAfterSet: TwbAfterSetCallback = nil;
                           aPriority   : TwbConflictPriority = cpNormal;
                           aRequired   : Boolean = False;
                           aSizeMatch  : Boolean = False;
                           aDontShow   : TwbDontShowCallback = nil;
                           aGetCP      : TwbGetConflictPriority = nil)
                                       : IwbSubRecordDef;
begin
  Result := TwbSubRecordDef.Create(aPriority, aRequired, aSignatures, aName, aValue, aAfterLoad, aAfterSet, aSizeMatch, aDontShow, aGetCP);
end;


function wbString(const aSignature : TwbSignature;
                  const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbString('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbString(const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbStringDef; overload;
begin
  Result := TwbStringDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbStringForward(const aSignature : TwbSignature;           // When the editor can leave chars after the ending #0
                         const aName      : string = 'Unknown';
                               aSize      : Integer = 0;
                               aPriority  : TwbConflictPriority = cpNormal;
                               aRequired  : Boolean = False;
                               aDontShow  : TwbDontShowCallback = nil;
                               aAfterSet  : TwbAfterSetCallback = nil;
                               aGetCP     : TwbGetConflictPriority = nil)
                                          : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbString(True, '', aSize, aPriority, aRequired, aDontShow, aAfterSet), nil, aAfterSet, aPriority, aRequired, False, aDontShow) as IwbSubRecordWithBaseStringDef;
end;

function wbString(      aForward   : Boolean = False;
                  const aName      : string = 'Unknown';
                        aSize      : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbStringDef; overload;
begin
  Result := TwbStringDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False, aForward);
end;

function wbStringT(const aSignature : TwbSignature;
                   const aName      : string = 'Unknown';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStringT('', aSize, aPriority, aRequired, aDontShow, aAfterSet, aGetCP), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbStringT(const aName      : string = 'Unknown';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbStringDef; overload;
begin
  Result := TwbStringDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, True);
end;

function wbStringScript(const aSignature : TwbSignature;
                        const aName      : string;
                              aSize      : Integer = 0;
                              aPriority  : TwbConflictPriority = cpNormal;
                              aRequired  : Boolean = False;
                              aDontShow  : TwbDontShowCallback = nil;
                              aAfterSet  : TwbAfterSetCallback = nil;
                              aGetCP     : TwbGetConflictPriority = nil)
                                         : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStringScript('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbStringScript(const aName      : string;
                              aSize      : Integer = 0;
                              aPriority  : TwbConflictPriority = cpNormal;
                              aRequired  : Boolean = False;
                              aDontShow  : TwbDontShowCallback = nil;
                              aAfterSet  : TwbAfterSetCallback = nil;
                              aGetCP     : TwbGetConflictPriority = nil)
                                         : IwbStringDef; overload;
begin
  Result := TwbStringScriptDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbStringLC(const aSignature : TwbSignature;
                    const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStringLC('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbStringLC(const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbStringDef; overload;
begin
  Result := TwbStringLCDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbStringKC(const aSignature : TwbSignature;
                    const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStringKC('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbStringKC(const aName      : string;
                          aSize      : Integer = 0;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbStringDef; overload;
begin
  Result := TwbStringKCDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbLString(const aSignature : TwbSignature;
                   const aName      : string = '';
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbLString('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbLString(const aName      : string;
                         aSize      : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbStringDef; overload;
begin
  Result := TwbLStringDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbLStringKC(const aSignature : TwbSignature;
                     const aName      : string;
                           aSize      : Integer = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbLStringKC('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbLStringKC(const aName      : string;
                           aSize      : Integer = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aAfterSet  : TwbAfterSetCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbStringDef; overload;
begin
  Result := TwbLStringKCDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbStringMgefCode(const aSignature : TwbSignature;
                          const aName      : string;
                                aSize      : Integer = 0;
                                aPriority  : TwbConflictPriority = cpNormal;
                                aRequired  : Boolean = False;
                                aDontShow  : TwbDontShowCallback = nil;
                                aAfterSet  : TwbAfterSetCallback = nil;
                                aGetCP     : TwbGetConflictPriority = nil)
                                           : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStringMgefCode('', aSize, aPriority), nil, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbStringMgefCode(const aName      : string;
                                aSize      : Integer = 0;
                                aPriority  : TwbConflictPriority = cpNormal;
                                aRequired  : Boolean = False;
                                aDontShow  : TwbDontShowCallback = nil;
                                aAfterSet  : TwbAfterSetCallback = nil;
                                aGetCP     : TwbGetConflictPriority = nil)
                                           : IwbStringDef; overload;
begin
  Result := TwbStringMgefCodeDef.Create(aPriority, aRequired, aName, aSize, nil, aAfterSet, aDontShow, aGetCP, False);
end;

function wbLenString(const aSignature : TwbSignature;
                     const aName      : string = 'Unknown';
                           aPrefix    : Integer = 4;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbLenString('', aPrefix, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbLenString(const aName      : string = 'Unknown';
                           aPrefix    : Integer = 4;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbLenStringDef; overload;
begin
  Result := TwbLenStringDef.Create(aPriority, aRequired, aName, aPrefix, nil, nil, aDontShow, aGetCP, False);
end;

function wbLenStringT(const aSignature : TwbSignature;
                      const aName      : string;
                            aPrefix    : Integer = 4;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbSubRecordWithBaseStringDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbLenStringT('', aPrefix, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithBaseStringDef;
end;

function wbLenStringT(const aName      : string;
                            aPrefix    : Integer = 4;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbLenStringDef; overload;
begin
  Result := TwbLenStringDef.Create(aPriority, aRequired, aName, aPrefix, nil, nil, aDontShow, aGetCP, True);
end;

function wbUnion(const aSignature : TwbSignature;
                 const aName      : string;
                       aDecider   : TwbUnionDecider;
                 const aMembers   : array of IwbValueDef;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbUnion('', aDecider, aMembers, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordDef;
end;

function wbUnion(const aName     : string;
                       aDecider  : TwbUnionDecider;
                 const aMembers  : array of IwbValueDef;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aAfterSet : TwbAfterSetCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbUnionDef; overload;
begin
  Result := TwbUnionDef.Create(aPriority, aRequired, aName, aDecider, aMembers, aDontShow, aAfterSet, aGetCP);
end;

function wbRecursive(const aName     : string;
                           aLevelsUp : Integer;
                           aPriority : TwbConflictPriority = cpNormal;
                           aRequired : Boolean = False;
                           aDontShow : TwbDontShowCallback = nil;
                           aAfterSet : TwbAfterSetCallback = nil;
                           aGetCP    : TwbGetConflictPriority = nil)
                                     : IwbRecursiveDef;
begin
  Result := TwbRecursiveDef.Create(aPriority, aRequired, aName, aLevelsUp, aDontShow, aAfterSet, aGetCP);
end;

function wbByteArray(const aSignature : TwbSignature;
                     const aName      : string = 'Unknown';
                           aSize      : Int64 = 0;
                           aPriority  : TwbConflictPriority = cpNormal;
                           aRequired  : Boolean = False;
                           aSizeMatch : Boolean = False;
                           aDontShow  : TwbDontShowCallback = nil;
                           aGetCP     : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbByteArray('', aSize, aPriority), nil, nil, aPriority, aRequired, aSizeMatch, aDontShow, aGetCP);
end;

function wbByteArray(const aName     : string = 'Unknown';
                           aSize     : Int64 = 0;
                           aPriority : TwbConflictPriority = cpNormal;
                           aRequired : Boolean = False;
                           aDontShow : TwbDontShowCallback = nil;
                           aGetCP    : TwbGetConflictPriority = nil)
                                     : IwbByteArrayDef; overload;
begin
  Result := TwbByteArrayDef.Create(aPriority, aRequired, aName, aSize, aDontShow, nil, aGetCP, False);
end;

function wbByteArrayT(const aName     : string = 'Unknown';
                            aSize     : Int64 = 0;
                            aPriority : TwbConflictPriority = cpNormal;
                            aRequired : Boolean = False;
                            aDontShow : TwbDontShowCallback = nil;
                            aGetCP    : TwbGetConflictPriority = nil)
                                      : IwbByteArrayDef; overload;
begin
  Result := TwbByteArrayDef.Create(aPriority, aRequired, aName, aSize, aDontShow, nil, aGetCP, True);
end;

function wbByteArray(const aName          : string;
                           aCountCallback : TwbCountCallback;
                           aPriority      : TwbConflictPriority = cpNormal;
                           aRequired      : Boolean = False;
                           aDontShow      : TwbDontShowCallback = nil;
                           aGetCP         : TwbGetConflictPriority = nil)
                                          : IwbByteArrayDef; overload;
begin
  Result := TwbByteArrayDef.Create(aPriority, aRequired, aName, 0, aDontShow, aCountCallback, aGetCP, False);
end;

function wbReflection(const aSignature : TwbSignature;
                      const aName      : string = 'Unknown Reflection';
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False)
                                       : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbReflection('', aPriority), nil, nil, aPriority, aRequired, False, nil, nil);
end;

function wbReflection(const aName     : string = 'Unknown Reflection';
                            aPriority : TwbConflictPriority = cpNormal;
                            aRequired : Boolean = False)
                                      : IwbReflectionDef; overload;
begin
  Result := TwbReflectionDef.Create(aPriority, aRequired, aName, 0, nil, nil, nil, False);
end;

function wbUnknown(const aSignature : TwbSignature;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef;
begin
  Result := wbByteArray(aSignature, 'Unknown', 0, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbUnknown(aPriority : TwbConflictPriority = cpNormal;
                   aRequired : Boolean = False;
                   aDontShow : TwbDontShowCallback = nil;
                   aGetCP    : TwbGetConflictPriority = nil)
                             : IwbByteArrayDef;
begin
  Result := wbByteArray('Unknown', 0, aPriority, aRequired, aDontShow, aGetCP);
end;

function wbUnknown(const aSignature : TwbSignature;
                         aSize      : Integer;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef;
begin
  Result := wbByteArray(aSignature, 'Unknown', aSize, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbUnknown(aSize     : Integer;
                   aPriority : TwbConflictPriority = cpNormal;
                   aRequired : Boolean = False;
                   aDontShow : TwbDontShowCallback = nil;
                   aGetCP    : TwbGetConflictPriority = nil)
                             : IwbByteArrayDef;
begin
  Result := wbByteArray('Unknown', aSize, aPriority, aRequired, aDontShow, aGetCP);
end;

function wbUnused(const aSignature : TwbSignature;
                        aRequired  : Boolean = False)
                                   : IwbSubRecordDef;
begin
  Result := wbEmpty(aSignature, 'Unused', cpIgnore, aRequired, wbNeverShow);
  Result.IncludeFlag(dfNoReport);
end;

function wbUnused(aRequired : Boolean = False)
                            : IwbValueDef;
begin
  Result := wbEmpty('Unused', cpIgnore, aRequired, wbNeverShow, False);
  Result.IncludeFlag(dfNoReport);
end;

function wbUnused(const aSignature : TwbSignature;
                        aSize      : Integer;
                        aRequired  : Boolean = False)
                                   : IwbSubRecordDef;
begin
  Result := wbByteArray(aSignature, 'Unused', aSize, cpIgnore, aRequired, False, wbNeverShow);
  Result.IncludeFlag(dfNoReport);
end;

function wbUnused(aSize     : Integer;
                  aRequired : Boolean = False)
                            : IwbValueDef;
begin
  Result := wbByteArray('Unused', aSize, cpIgnore, aRequired, wbNeverShow);
  Result.IncludeFlag(dfNoReport);
end;

function wbInteger(const aSignature : TwbSignature;
                   const aName      : string;
                   const aIntType   : TwbIntType;
                   const aFormater  : IwbIntegerDefFormater = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aMatchSize : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDefault   : Int64 = 0;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbInteger('', aIntType, aFormater, aPriority, False, nil, nil, aDefault), nil, aAfterSet, aPriority, aRequired, aMatchSize, aDontShow, aGetCP);
end;

function wbIntegerT(const aSignature : TwbSignature;
                    const aName      : string;
                    const aIntType   : TwbIntType;
                    const aFormater  : IwbIntegerDefFormater = nil;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aMatchSize : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aDefault   : Int64 = 0;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbIntegerT('', aIntType, aFormater, aPriority, False, nil, nil, aDefault), nil, aAfterSet, aPriority, aRequired, aMatchSize, aDontShow, aGetCP);
end;

function wbInteger(const aName     : string;
                   const aIntType  : TwbIntType;
                   const aFormater : IwbIntegerDefFormater = nil;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aAfterSet : TwbAfterSetCallback = nil;
                         aDefault  : Int64 = 0;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;
begin
  Result := TwbIntegerDef.Create(aPriority, aRequired, aName, aIntType, aFormater, aDontShow, aAfterSet, aDefault, aGetCP, False);
end;

function wbIntegerT(const aName     : string;
                    const aIntType  : TwbIntType;
                    const aFormater : IwbIntegerDefFormater = nil;
                          aPriority : TwbConflictPriority = cpNormal;
                          aRequired : Boolean = False;
                          aDontShow : TwbDontShowCallback = nil;
                          aAfterSet : TwbAfterSetCallback = nil;
                          aDefault  : Int64 = 0;
                          aGetCP    : TwbGetConflictPriority = nil)
                                    : IwbIntegerDef; overload;
begin
  Result := TwbIntegerDef.Create(aPriority, aRequired, aName, aIntType, aFormater, aDontShow, aAfterSet, aDefault, aGetCP, True);
end;

function wbInteger(const aSignature : TwbSignature;
                   const aName      : string;
                   const aIntType   : TwbIntType;
                   const aToStr     : TwbIntToStrCallback;
                   const aToInt     : TwbStrToIntCallback = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDefault   : Int64 = 0;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;
var
  Callback: IwbIntegerDefFormater;
begin
  if Assigned(aToStr) then
    Callback := wbCallback(aToStr, aToInt);
  Result := wbInteger(aSignature, aName, aIntType, Callback, aPriority, aRequired, False, aDontShow, aAfterSet, aDefault);
end;

function wbIntegerT(const aSignature : TwbSignature;
                    const aName      : string;
                    const aIntType   : TwbIntType;
                    const aToStr     : TwbIntToStrCallback;
                    const aToInt     : TwbStrToIntCallback = nil;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil;
                          aDefault   : Int64 = 0;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;
var
  Callback: IwbIntegerDefFormater;
begin
  if Assigned(aToStr) then
    Callback := wbCallback(aToStr, aToInt);
  Result := wbIntegerT(aSignature, aName, aIntType, Callback, aPriority, aRequired, False, aDontShow, aAfterSet, aDefault, aGetCP);
end;

function wbInteger(const aName     : string;
                   const aIntType  : TwbIntType;
                   const aToStr    : TwbIntToStrCallback;
                   const aToInt    : TwbStrToIntCallback = nil;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aAfterSet : TwbAfterSetCallback = nil;
                         aDefault  : Int64 = 0;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;
var
  Callback: IwbIntegerDefFormater;
begin
  if Assigned(aToStr) then
    Callback := wbCallback(aToStr, aToInt);
  Result := wbInteger(aName, aIntType, Callback, aPriority, aRequired, aDontShow, aAfterSet, aDefault);
end;

function wbIntegerT(const aName     : string;
                    const aIntType  : TwbIntType;
                    const aToStr    : TwbIntToStrCallback;
                    const aToInt    : TwbStrToIntCallback = nil;
                          aPriority : TwbConflictPriority = cpNormal;
                          aRequired : Boolean = False;
                          aDontShow : TwbDontShowCallback = nil;
                          aAfterSet : TwbAfterSetCallback = nil;
                          aDefault  : Int64 = 0;
                          aGetCP    : TwbGetConflictPriority = nil)
                                    : IwbIntegerDef; overload;
var
  Callback: IwbIntegerDefFormater;
begin
  if Assigned(aToStr) then
    Callback := wbCallback(aToStr, aToInt);
  Result := wbIntegerT(aName, aIntType, Callback, aPriority, aRequired, aDontShow, aAfterSet, aDefault, aGetCP);
end;

function wbHalf(const aSignature  : TwbSignature;
                const aName       : string = 'Unknown';
                      aPriority   : TwbConflictPriority = cpNormal;
                      aRequired   : Boolean = False;
                      aScale      : Extended = 1.0;
                      aDigits     : Integer = -1;
                      aDontShow   : TwbDontShowCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbHalf('', aPriority, False, aScale, aDigits, nil, aNormalizer, aDefault), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbFloat(const aSignature  : TwbSignature;
                 const aName       : string = 'Unknown';
                       aPriority   : TwbConflictPriority = cpNormal;
                       aRequired   : Boolean = False;
                       aScale      : Extended = 1.0;
                       aDigits     : Integer = -1;
                       aDontShow   : TwbDontShowCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbFloat('', aPriority, False, aScale, aDigits, nil, aNormalizer, aDefault, aGetCP), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbFloatAngle(const aSignature  : TwbSignature;
                      const aName       : string = 'Unknown Angle';
                            aPriority   : TwbConflictPriority = cpNormal;
                            aRequired   : Boolean = False;
                            aDontShow   : TwbDontShowCallback = nil;
                            aDefault    : Extended = 0.0;
                            aGetCP      : TwbGetConflictPriority = nil)
                                        : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbFloat('', aPriority, False, wbRadiansToDegreesScale, wbAngleDigits, nil, wbNormalizeRadians, aDefault, aGetCP), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbDouble(const aSignature  : TwbSignature;
                  const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbDouble('', aPriority, False, aScale, aDigits, nil, aNormalizer, aDefault), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbHalf(const aName       : string = 'Unknown';
                      aPriority   : TwbConflictPriority = cpNormal;
                      aRequired   : Boolean = False;
                      aScale      : Extended = 1.0;
                      aDigits     : Integer = -1;
                      aDontShow   : TwbDontShowCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, aScale, aDigits, aDontShow, aNormalizer, aDefault, aGetCP, fkHalf, False);
end;

function wbFloat(const aName       : string = 'Unknown';
                       aPriority   : TwbConflictPriority = cpNormal;
                       aRequired   : Boolean = False;
                       aScale      : Extended = 1.0;
                       aDigits     : Integer = -1;
                       aDontShow   : TwbDontShowCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, aScale, aDigits, aDontShow, aNormalizer, aDefault, aGetCP, fkSingle, False);
end;

function wbFloatAngle(const aName       : string = 'Unknown Angle';
                            aPriority   : TwbConflictPriority = cpNormal;
                            aRequired   : Boolean = False;
                            aDontShow   : TwbDontShowCallback = nil;
                            aDefault    : Extended = 0.0;
                            aGetCP      : TwbGetConflictPriority = nil)
                                        : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, wbRadiansToDegreesScale, wbAngleDigits, aDontShow, wbNormalizeRadians, aDefault, aGetCP, fkSingle, False);
end;


function wbDouble(const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, aScale, aDigits, aDontShow, aNormalizer, aDefault, aGetCP, fkDouble, False);
end;

function wbHalf(const aName       : string;
                      aPriority   : TwbConflictPriority;
                      aRequired   : Boolean;
                      aDontShow   : TwbDontShowCallback;
                      aAfterSet   : TwbAfterSetCallback = nil;
                      aNormalizer : TwbFloatNormalizer = nil;
                      aDefault    : Extended = 0.0;
                      aGetCP      : TwbGetConflictPriority = nil)
                                  : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, aAfterSet, 1.0, -1, aDontShow, aNormalizer, aDefault, aGetCP, fkHalf, False);
end;

function wbFloat(const aName       : string;
                       aPriority   : TwbConflictPriority;
                       aRequired   : Boolean;
                       aDontShow   : TwbDontShowCallback;
                       aAfterSet   : TwbAfterSetCallback = nil;
                       aNormalizer : TwbFloatNormalizer = nil;
                       aDefault    : Extended = 0.0;
                       aGetCP      : TwbGetConflictPriority = nil)
                                   : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, aAfterSet, 1.0, -1, aDontShow, aNormalizer, aDefault, aGetCP, fkSingle, False);
end;


function wbDouble(const aName       : string;
                        aPriority   : TwbConflictPriority;
                        aRequired   : Boolean;
                        aDontShow   : TwbDontShowCallback;
                        aAfterSet   : TwbAfterSetCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, aAfterSet, 1.0, -1, aDontShow, aNormalizer, aDefault, aGetCP, fkDouble, False);
end;

function wbFloatT(const aSignature  : TwbSignature;
                  const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbFloatT('', aPriority, False, aScale, aDigits, nil, aNormalizer, aDefault), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbDoubleT(const aSignature  : TwbSignature;
                   const aName       : string = 'Unknown';
                         aPriority   : TwbConflictPriority = cpNormal;
                         aRequired   : Boolean = False;
                         aScale      : Extended = 1.0;
                         aDigits     : Integer = -1;
                         aDontShow   : TwbDontShowCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbDoubleT('', aPriority, False, aScale, aDigits, nil, aNormalizer, aDefault), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbFloatT(const aName       : string = 'Unknown';
                        aPriority   : TwbConflictPriority = cpNormal;
                        aRequired   : Boolean = False;
                        aScale      : Extended = 1.0;
                        aDigits     : Integer = -1;
                        aDontShow   : TwbDontShowCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, aScale, aDigits, aDontShow, aNormalizer, aDefault, aGetCP, fkSingle, True);
end;

function wbDoubleT(const aName       : string = 'Unknown';
                         aPriority   : TwbConflictPriority = cpNormal;
                         aRequired   : Boolean = False;
                         aScale      : Extended = 1.0;
                         aDigits     : Integer = -1;
                         aDontShow   : TwbDontShowCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, nil, aScale, aDigits, aDontShow, aNormalizer, aDefault, aGetCP, fkDouble, True);
end;

function wbFloatT(const aName       : string;
                        aPriority   : TwbConflictPriority;
                        aRequired   : Boolean;
                        aDontShow   : TwbDontShowCallback;
                        aAfterSet   : TwbAfterSetCallback = nil;
                        aNormalizer : TwbFloatNormalizer = nil;
                        aDefault    : Extended = 0.0;
                        aGetCP      : TwbGetConflictPriority = nil)
                                    : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, aAfterSet, 1.0, -1, aDontShow, aNormalizer, aDefault, aGetCP, fkSingle, True);
end;

function wbDoubleT(const aName       : string;
                         aPriority   : TwbConflictPriority;
                         aRequired   : Boolean;
                         aDontShow   : TwbDontShowCallback;
                         aAfterSet   : TwbAfterSetCallback = nil;
                         aNormalizer : TwbFloatNormalizer = nil;
                         aDefault    : Extended = 0.0;
                         aGetCP      : TwbGetConflictPriority = nil)
                                     : IwbFloatDef; overload;
begin
  Result := TwbFloatDef.Create(aPriority, aRequired, aName, nil, aAfterSet, 1.0, -1, aDontShow, aNormalizer, aDefault, aGetCP, fkDouble, True);
end;

{--- wbArray - list of identical elements -------------------------------------}
function wbArray(const aSignature : TwbSignature;
                 const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer = 0;
                       aAfterLoad : TwbAfterLoadCallback = nil;
                       aAfterSet  : TwbAfterSetCallback = nil;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArray('', aElement, aCount, aPriority), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArray(const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer = 0;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], False, nil, nil, aDontShow, aGetCP, True, False, False);
end;

function wbArray(const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer;
                 const aLabels    : array of string;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, aLabels, False, nil, nil, aDontShow, aGetCP, True, False, False);
end;


function wbArray(const aName      : string;
                 const aElement   : IwbValueDef;
                       aCount     : Integer;
                       aAfterLoad : TwbAfterLoadCallback;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], False, aAfterLoad, nil, aDontShow, aGetCP, True, False, False);
end;

function wbArrayPT(const aSignature : TwbSignature;
                   const aName      : string;
                   const aElement   : IwbValueDef;
                         aCount     : Integer = 0;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArrayPT('', aElement, aCount, aPriority), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArrayPT(const aName      : string;
                   const aElement   : IwbValueDef;
                         aCount     : Integer = 0;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], False, nil, nil, aDontShow, aGetCP, True, True, False);
end;

function wbArrayPT(const aName      : string;
                   const aElement   : IwbValueDef;
                         aCount     : Integer;
                         aAfterLoad : TwbAfterLoadCallback;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], False, aAfterLoad, nil, aDontShow, aGetCP, True, True, False);
end;

function wbArrayT(const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer;
                  const aLabels    : array of string;
                        aAfterLoad : TwbAfterLoadCallback;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, aLabels, False, aAfterLoad, nil, aDontShow, aGetCP, True, True, True);
end;

function wbRArray(const aName      : string;
                  const aElement   : IwbRecordMemberDef;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordArrayDef; overload;
begin
  Result := TwbSubRecordArrayDef.Create(aPriority, aRequired, aName, aElement, 0, False, aAfterLoad, aAfterSet, aDontShow, nil, aGetCP);
end;

function wbRArray(const aName      : string;
                  const aElement   : IwbRecordMemberDef;
                        aCount     : Integer;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordArrayDef; overload;
begin
  Result := TwbSubRecordArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, False, aAfterLoad, aAfterSet, aDontShow, nil, aGetCP);
end;


function wbArray(const aSignature : TwbSignature;
                 const aName      : string;
                 const aElement   : IwbValueDef;
                 const aLabels    : array of string;
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArray('', aElement, aLabels, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArray(const aSignature     : TwbSignature;
                 const aName          : string;
                 const aElement       : IwbValueDef;
                 const aLabels        : array of string;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArray('', aElement, aLabels, aCountCallback, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArray(const aName     : string;
                 const aElement  : IwbValueDef;
                 const aLabels   : array of string;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, Length(aLabels), aLabels, False, nil, nil, aDontShow, aGetCP, True, False, False);
end;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                 const aLabels        : array of string;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, aLabels, False, nil, nil, aDontShow, aGetCP, True, False, False);
end;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority = cpNormal;
                       aRequired      : Boolean = False;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, [], False, nil, nil, aDontShow, aGetCP, True, False, False);
end;

function wbArrayPT(const aSignature : TwbSignature;
                   const aName      : string;
                   const aElement   : IwbValueDef;
                   const aLabels    : array of string;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aDontShow  : TwbDontShowCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArrayPT('', aElement, aLabels, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArrayPT(const aSignature     : TwbSignature;
                   const aName          : string;
                   const aElement       : IwbValueDef;
                   const aLabels        : array of string;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArrayPT('', aElement, aLabels, aCountCallback, aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArrayPT(const aName     : string;
                   const aElement  : IwbValueDef;
                   const aLabels   : array of string;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, Length(aLabels), aLabels, False, nil, nil, aDontShow, aGetCP, True, True, False);
end;

function wbArrayPT(const aName          : string;
                   const aElement       : IwbValueDef;
                   const aLabels        : array of string;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, aLabels, False, nil, nil, aDontShow, aGetCP, True, True, False);
end;

function wbArrayT(const aName          : string;
                  const aElement       : IwbValueDef;
                  const aLabels        : array of string;
                        aCountCallback : TwbCountCallback;
                        aPriority      : TwbConflictPriority = cpNormal;
                        aRequired      : Boolean = False;
                        aDontShow      : TwbDontShowCallback = nil;
                        aGetCP         : TwbGetConflictPriority = nil)
                                       : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, aLabels, False, nil, nil, aDontShow, aGetCP, True, True, True);
end;

function wbArrayPT(const aName          : string;
                   const aElement       : IwbValueDef;
                         aCountCallback : TwbCountCallback;
                         aPriority      : TwbConflictPriority = cpNormal;
                         aRequired      : Boolean = False;
                         aDontShow      : TwbDontShowCallback = nil;
                         aGetCP         : TwbGetConflictPriority = nil)
                                        : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, [], False, nil, nil, aDontShow, aGetCP, True, True, False);
end;

{--- wbArrayS - list of identical elements - gets sorted ----------------------}
function wbArrayS(const aSignature : TwbSignature;
                  const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArrayS('', aElement, aCount, aPriority, False, aAfterLoad, aAfterSet), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer = 0;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aCanAddTo  : Boolean = True;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], True, aAfterLoad, aAfterSet, aDontShow, aGetCP, aCanAddTo, False, False);
end;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                        aCount     : Integer;
                        aAfterLoad : TwbAfterLoadCallback;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, [], True, aAfterLoad, aAfterSet, aDontShow, aGetCP, True, False, False);
end;

function wbArrayS(const aName          : string;
                  const aElement       : IwbValueDef;
                        aCountCallback : TwbCountCallback;
                        aPriority      : TwbConflictPriority = cpNormal;
                        aRequired      : Boolean = False;
                        aAfterLoad     : TwbAfterLoadCallback = nil;
                        aAfterSet      : TwbAfterSetCallback = nil;
                        aDontShow      : TwbDontShowCallback = nil;
                        aGetCP         : TwbGetConflictPriority = nil)
                                       : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, [], True, aAfterLoad, aAfterSet, aDontShow, aGetCP, True, False, False);
end;

function wbArray(const aName          : string;
                 const aElement       : IwbValueDef;
                       aCountCallback : TwbCountCallback;
                       aPriority      : TwbConflictPriority;
                       aRequired      : Boolean;
                       aAfterLoad     : TwbAfterLoadCallback;
                       aAfterSet      : TwbAfterSetCallback;
                       aDontShow      : TwbDontShowCallback = nil;
                       aGetCP         : TwbGetConflictPriority = nil)
                                       : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, aCountCallback, [], False, aAfterLoad, aAfterSet, aDontShow, aGetCP, True, False, False);
end;

function wbRArrayS(const aName      : string;
                   const aElement   : IwbRecordMemberDef;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDontShow  : TwbDontShowCallback = nil;
                         aIsSorted  : TwbIsSortedCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordArrayDef; overload;
begin
  Result := TwbSubRecordArrayDef.Create(aPriority, aRequired, aName, aElement, 0, True, aAfterLoad, aAfterSet, aDontShow, aIsSorted, aGetCP);
end;

function wbRArrayS(const aName      : string;
                   const aElement   : IwbRecordMemberDef;
                         aCount     : Integer;
                         aPriority  : TwbConflictPriority = cpNormal;
                         aRequired  : Boolean = False;
                         aAfterLoad : TwbAfterLoadCallback = nil;
                         aAfterSet  : TwbAfterSetCallback = nil;
                         aDontShow  : TwbDontShowCallback = nil;
                         aIsSorted  : TwbIsSortedCallback = nil;
                         aGetCP     : TwbGetConflictPriority = nil)
                                    : IwbSubRecordArrayDef; overload;
begin
  Result := TwbSubRecordArrayDef.Create(aPriority, aRequired, aName, aElement, aCount, True, aAfterLoad, aAfterSet, aDontShow, aIsSorted, aGetCP);
end;

function wbArrayS(const aSignature : TwbSignature;
                  const aName      : string;
                  const aElement   : IwbValueDef;
                  const aLabels    : array of string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordWithArrayDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbArrayS('', aElement, aLabels, aPriority, False, aAfterLoad), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithArrayDef;
end;

function wbArrayS(const aName      : string;
                  const aElement   : IwbValueDef;
                  const aLabels    : array of string;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aAfterLoad : TwbAfterLoadCallback = nil;
                        aAfterSet  : TwbAfterSetCallback = nil;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbArrayDef; overload;
begin
  Result := TwbArrayDef.Create(aPriority, aRequired, aName, aElement, Length(aLabels), aLabels, True, aAfterLoad, aAfterSet, aDontShow, aGetCP, True, False, False);
end;

{--- wbStruct - ordered list of members ----------------------------------------}
function wbStructSK(const aSignature           : TwbSignature;
                    const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbSubRecordWithStructDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStructSK(aSortKey, '', aMembers, aPriority, False, nil, aOptionalFromElement), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithStructDef;
end;

function wbMultiStructSK(const aSignatures          : TwbSignatures;
                         const aSortKey             : array of Integer;
                         const aName                : string;
                         const aMembers             : array of IwbValueDef;
                               aPriority            : TwbConflictPriority = cpNormal;
                               aRequired            : Boolean = False;
                               aDontShow            : TwbDontShowCallback = nil;
                               aOptionalFromElement : Integer = -1;
                               aAfterLoad           : TwbAfterLoadCallback = nil;
                               aAfterSet            : TwbAfterSetCallback = nil;
                               aGetCP               : TwbGetConflictPriority = nil)
                                                    : IwbSubRecordWithStructDef;
begin
  Result := wbSubRecord(aSignatures, aName, wbStructSK(aSortKey, '', aMembers, aPriority, False, nil, aOptionalFromElement), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithStructDef;
end;

function wbStructSK(const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;
begin
  Result := TwbStructDef.Create(aPriority, aRequired, aName, aMembers, aSortKey, [], [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aGetCP);
end;

function wbStructSK(const aSortKey             : array of Integer;
                    const aName                : string;
                    const aMembers             : array of IwbValueDef;
                    {$IFDEF WIN32}
                    const aElementMap          : array of Cardinal;
                    {$ENDIF WIN32}
                    {$IFDEF WIN64}
                    const aElementMap          : array of UInt64;
                    {$ENDIF WIN64}
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;
begin
  Result := TwbStructDef.Create(aPriority, aRequired, aName, aMembers, aSortKey, [], aElementMap, aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aGetCP);
end;


function wbStructExSK(const aSignature           : TwbSignature;
                      const aSortKey             : array of Integer;
                      const aExSortKey           : array of Integer;
                      const aName                : string;
                      const aMembers             : array of IwbValueDef;
                            aPriority            : TwbConflictPriority = cpNormal;
                            aRequired            : Boolean = False;
                            aDontShow            : TwbDontShowCallback = nil;
                            aOptionalFromElement : Integer = -1;
                            aAfterLoad           : TwbAfterLoadCallback = nil;
                            aAfterSet            : TwbAfterSetCallback = nil;
                            aGetCP               : TwbGetConflictPriority = nil)
                                                 : IwbSubRecordWithStructDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStructExSK(aSortKey, aExSortKey, '', aMembers, aPriority, False, nil, aOptionalFromElement), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithStructDef;
end;

function wbStructExSK(const aSortKey             : array of Integer;
                      const aExSortKey           : array of Integer;
                      const aName                : string;
                      const aMembers             : array of IwbValueDef;
                            aPriority            : TwbConflictPriority = cpNormal;
                            aRequired            : Boolean = False;
                            aDontShow            : TwbDontShowCallback = nil;
                            aOptionalFromElement : Integer = -1;
                            aAfterLoad           : TwbAfterLoadCallback = nil;
                            aAfterSet            : TwbAfterSetCallback = nil;
                            aGetCP               : TwbGetConflictPriority = nil)
                                                 : IwbStructDef; overload;
begin
  Result := TwbStructDef.Create(aPriority, aRequired, aName, aMembers, aSortKey, aExSortKey, [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aGetCP);
end;

function wbStruct(const aSignature           : TwbSignature;
                  const aName                : string;
                  const aMembers             : array of IwbValueDef;
                        aPriority            : TwbConflictPriority = cpNormal;
                        aRequired            : Boolean = False;
                        aDontShow            : TwbDontShowCallback = nil;
                        aOptionalFromElement : Integer = -1;
                        aAfterLoad           : TwbAfterLoadCallback = nil;
                        aAfterSet            : TwbAfterSetCallback = nil;
                        aGetCP               : TwbGetConflictPriority = nil)
                                             : IwbSubRecordWithStructDef; overload;
begin
  Result := wbSubRecord(aSignature, aName, wbStruct('', aMembers, aPriority, False, nil, aOptionalFromElement), aAfterLoad, aAfterSet, aPriority, aRequired, False, aDontShow, aGetCP) as IwbSubRecordWithStructDef;
end;

function wbStruct(const aName                : string;
                  const aMembers             : array of IwbValueDef;
                        aPriority            : TwbConflictPriority = cpNormal;
                        aRequired            : Boolean = False;
                        aDontShow            : TwbDontShowCallback = nil;
                        aOptionalFromElement : Integer = -1;
                        aAfterLoad           : TwbAfterLoadCallback = nil;
                        aAfterSet            : TwbAfterSetCallback = nil;
                        aGetCP               : TwbGetConflictPriority = nil)
                                             : IwbStructDef; overload;
begin
  Result := TwbStructDef.Create(aPriority, aRequired, aName, aMembers, [], [], [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aGetCP);
end;

function wbStructC(const aName                : string;
                         aSizing              : TwbSizeCallback;
                         aGetChapterType      : TwbGetChapterTypeCallback;
                         aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                         aGetChapterName      : TwbGetChapterNameCallback;
                   const aMembers             : array of IwbValueDef;
                         aPriority            : TwbConflictPriority = cpNormal;
                         aRequired            : Boolean = False;
                         aDontShow            : TwbDontShowCallback = nil;
                         aOptionalFromElement : Integer = -1;
                         aAfterLoad           : TwbAfterLoadCallback = nil;
                         aAfterSet            : TwbAfterSetCallback = nil;
                         aGetCP               : TwbGetConflictPriority = nil)
                                              : IwbStructDef; overload;
begin
  Result := TwbStructCDef.Create(aPriority, aRequired, aName, aMembers, [], [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aSizing, aGetChapterType, aGetChapterTypeName, aGetChapterName, aGetCP);
end;

function wbStructZ(const aName                : string;
                         aSizing              : TwbSizeCallback;
                         aGetChapterType      : TwbGetChapterTypeCallback;
                         aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                         aGetChapterName      : TwbGetChapterNameCallback;
                   const aMembers             : array of IwbValueDef;
                         aPriority            : TwbConflictPriority = cpNormal;
                         aRequired            : Boolean = False;
                         aDontShow            : TwbDontShowCallback = nil;
                         aOptionalFromElement : Integer = -1;
                         aAfterLoad           : TwbAfterLoadCallback = nil;
                         aAfterSet            : TwbAfterSetCallback = nil;
                         aGetCP               : TwbGetConflictPriority = nil)
                                              : IwbStructDef; overload;
begin
  Result := TwbStructZDef.Create(aPriority, aRequired, aName, aMembers, [], [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aSizing, aGetChapterType, aGetChapterTypeName, agetChapterName, aGetCP);
end;

function wbStructLZ(const aName                : string;
                          aSizing              : TwbSizeCallback;
                          aGetChapterType      : TwbGetChapterTypeCallback;
                          aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                          aGetChapterName      : TwbGetChapterNameCallback;
                    const aMembers             : array of IwbValueDef;
                          aPriority            : TwbConflictPriority = cpNormal;
                          aRequired            : Boolean = False;
                          aDontShow            : TwbDontShowCallback = nil;
                          aOptionalFromElement : Integer = -1;
                          aAfterLoad           : TwbAfterLoadCallback = nil;
                          aAfterSet            : TwbAfterSetCallback = nil;
                          aGetCP               : TwbGetConflictPriority = nil)
                                               : IwbStructDef; overload;
begin
  Result := TwbStructLZDef.Create(aPriority, aRequired, aName, aMembers, [], [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aSizing, aGetChapterType, aGetChapterTypeName, agetChapterName, aGetCP);
end;

function wbRStruct(const aName           : string;
                   const aMembers        : array of IwbRecordMemberDef;
                   const aSkipSigs       : TwbSignatures = nil;
                         aPriority       : TwbConflictPriority = cpNormal;
                         aRequired       : Boolean = False;
                         aDontShow       : TwbDontShowCallback = nil;
                         aAllowUnordered : Boolean = False;
                         aAfterLoad      : TwbAfterLoadCallback = nil;
                         aAfterSet       : TwbAfterSetCallback = nil;
                         aGetCP          : TwbGetConflictPriority = nil)
                                         : IwbSubRecordStructDef; overload;
begin
  Result := TwbSubRecordStructDef.Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aDontShow, aAllowUnordered, aAfterLoad, aAfterSet, aGetCP);
end;

function wbRStructSK(const aSortKey        : array of Integer;
                     const aName           : string;
                     const aMembers        : array of IwbRecordMemberDef;
                     const aSkipSigs       : TwbSignatures = nil;
                           aPriority       : TwbConflictPriority = cpNormal;
                           aRequired       : Boolean = False;
                           aDontShow       : TwbDontShowCallback = nil;
                           aAllowUnordered : Boolean = False;
                           aAfterLoad      : TwbAfterLoadCallback = nil;
                           aAfterSet       : TwbAfterSetCallback = nil;
                           aGetCP          : TwbGetConflictPriority = nil)
                                           : IwbSubRecordStructDef; overload;
begin
  Result := TwbSubRecordStructSKDef.Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aSortKey, [], aDontShow, aAllowUnordered, aAfterLoad, aAfterSet, aGetCP);
end;

function wbRStructExSK(const aSortKey        : array of Integer;
                       const aExSortKey      : array of Integer;
                       const aName           : string;
                       const aMembers        : array of IwbRecordMemberDef;
                       const aSkipSigs       : TwbSignatures = nil;
                             aPriority       : TwbConflictPriority = cpNormal;
                             aRequired       : Boolean = False;
                             aDontShow       : TwbDontShowCallback = nil;
                             aAllowUnordered : Boolean = False;
                             aAfterLoad      : TwbAfterLoadCallback = nil;
                             aAfterSet       : TwbAfterSetCallback = nil;
                             aGetCP          : TwbGetConflictPriority = nil)
                                             : IwbSubRecordStructDef; overload;
begin
  Result := TwbSubRecordStructSKDef.Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aSortKey, aExSortKey, aDontShow, aAllowUnordered, aAfterLoad, aAfterSet, aGetCP);
end;

function wbRUnion(const aName     : string;
                  const aMembers  : array of IwbRecordMemberDef;
                  const aSkipSigs : TwbSignatures = nil;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aGetCP    : TwbGetConflictPriority = nil)
                                  : IwbSubRecordUnionDef; overload;
begin
  Result := TwbSubRecordUnionDef.Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aDontShow, aGetCP, nil);
end;

function wbRUnion(const aName     : string;
                  const aDecider  : TwbRUnionDecider; //called with the container of the RUnion
                  const aMembers  : array of IwbRecordMemberDef;
                  const aSkipSigs : TwbSignatures = nil;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aGetCP    : TwbGetConflictPriority = nil)
                                  : IwbSubRecordUnionDef; overload;
begin
  Result := TwbSubRecordUnionDef.Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aDontShow, aGetCP, aDecider);
end;


{--- wbStructS - array of struct ----------------------------------------------}
function wbStructs(const aSignature   : TwbSignature;
                   const aName        : string;
                   const aElementName : string;
                   const aMembers     : array of IwbValueDef;
                         aPriority    : TwbConflictPriority = cpNormal;
                         aRequired    : Boolean = False;
                         aDontShow    : TwbDontShowCallback = nil;
                         aGetCP       : TwbGetConflictPriority = nil)
                                      : IwbSubRecordDef; overload;
begin
  Result := wbArray(aSignature, aName, wbStruct(aElementName, aMembers, aPriority), 0, nil, nil, aPriority, aRequired, aDontShow, aGetCP);
end;

function wbStructs(const aName        : string;
                   const aElementName : string;
                   const aMembers     : array of IwbValueDef;
                         aPriority    : TwbConflictPriority = cpNormal;
                         aRequired    : Boolean = False;
                         aDontShow    : TwbDontShowCallback = nil;
                         aGetCP       : TwbGetConflictPriority = nil)
                                      : IwbArrayDef; overload;
begin
  Result := wbArray(aName, wbStruct(aElementName, aMembers, aPriority), 0, aPriority, aRequired, aDontShow, aGetCP);
end;

function wbRStructs(const aName        : string;
                    const aElementName : string;
                    const aMembers     : array of IwbRecordMemberDef;
                    const aSkipSigs    : TwbSignatures = nil;
                          aPriority    : TwbConflictPriority = cpNormal;
                          aRequired    : Boolean = False;
                          aDontShow    : TwbDontShowCallback = nil;
                          aGetCP       : TwbGetConflictPriority = nil)
                                       : IwbSubRecordArrayDef; overload;
begin
  Result := wbRArray(aName, wbRStruct(aElementName, aMembers, aSkipSigs ,aPriority), aPriority, aRequired, nil, nil, aDontShow, aGetCP);
end;

function wbRStructsSK(const aName        : string;
                      const aElementName : string;
                      const aSortKey     : array of Integer;
                      const aMembers     : array of IwbRecordMemberDef;
                      const aSkipSigs    : TwbSignatures = nil;
                            aPriority    : TwbConflictPriority = cpNormal;
                            aRequired    : Boolean = False;
                            aAfterLoad   : TwbAfterLoadCallback = nil;
                            aAfterSet    : TwbAfterSetCallback = nil;
                            aDontShow    : TwbDontShowCallback = nil;
                            aGetCP       : TwbGetConflictPriority = nil)
                                         : IwbSubRecordArrayDef; overload;
begin
  Result := wbRArrayS(aName, wbRStructSK(aSortKey, aElementName, aMembers, aSkipSigs, aPriority), aPriority, aRequired, aAfterLoad, aAfterSet, aDontShow, nil, aGetCP);
end;

function wbEmpty(const aSignature : TwbSignature;
                 const aName      : string = 'Unknown';
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbSubRecordDef;
begin
  Result := wbSubRecord(aSignature, aName, wbEmpty('', aPriority, aRequired), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbEmpty(const aName      : string = 'Unknown';
                       aPriority  : TwbConflictPriority = cpNormal;
                       aRequired  : Boolean = False;
                       aDontShow  : TwbDontShowCallback = nil;
                       aSorted    : Boolean = False;
                       aGetCP     : TwbGetConflictPriority = nil)
                                  : IwbValueDef;
begin
  Result := TwbEmptyDef.Create(aPriority, aRequired, aName, nil, nil, aDontShow, aSorted, aGetCP);
end;

function wbMarker(const aSignature : TwbSignature;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef;
begin
  Result := wbEmpty(aSignature, 'Marker', aPriority, aRequired, aDontShow, aGetCP);
end;

function wbMarker(aPriority  : TwbConflictPriority = cpNormal;
                  aRequired  : Boolean = False;
                  aDontShow  : TwbDontShowCallback = nil;
                  aSorted    : Boolean = False;
                  aGetCP     : TwbGetConflictPriority = nil)
                             : IwbValueDef;
begin
  Result := wbEmpty('Marker', aPriority, aRequired, aDontShow, aSorted, aGetCP);
end;

function wbMarkerReq(const aSignature : TwbSignature;
                        aPriority  : TwbConflictPriority = cpNormal;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef;
begin
  Result := wbMarker(aSignature, aPriority, True, aDontShow, aGetCP);
end;

function wbMarkerReq(aPriority  : TwbConflictPriority = cpNormal;
                  aDontShow  : TwbDontShowCallback = nil;
                  aSorted    : Boolean = False;
                  aGetCP     : TwbGetConflictPriority = nil)
                             : IwbValueDef;
begin
  Result := wbMarker(aPriority, True, aDontShow, aSorted, aGetCP);
end;

function wbGUID(const aSignature : TwbSignature;
                const aName      : string = 'Unknown';
                      aPriority  : TwbConflictPriority = cpNormal;
                      aRequired  : Boolean = False;
                      aDontShow  : TwbDontShowCallback = nil;
                      aGetCP     : TwbGetConflictPriority = nil)
                                 : IwbSubRecordDef;
begin
  Result := wbSubRecord(aSignature, aName, wbGUID('', aPriority), nil, nil, aPriority, aRequired, False, aDontShow, aGetCP);
end;

function wbGUID(const aName      : string = 'Unknown';
                      aPriority  : TwbConflictPriority = cpNormal;
                      aRequired  : Boolean = False;
                      aDontShow  : TwbDontShowCallback = nil;
                      aGetCP     : TwbGetConflictPriority = nil)
                                 : IwbGuidDef;
begin
  Result := TwbGuidDef.Create(aPriority, aRequired, aName, nil, nil, aDontShow, aGetCP, False);
end;

function wbDumpInteger : IwbIntegerDefFormater;
begin
  Result := TwbDumpIntegerDefFormater.Create;
end;

function wbKey2Data6Enum(const aNames : array of string) : IwbKey2Data6EnumDef;
begin
  Result := TwbKey2Data6EnumDef.Create(False,aNames, []);
end;

function wbData6Key2Enum(const aNames : array of string) : IwbData6Key2EnumDef;
begin
  Result := TwbData6Key2EnumDef.Create(False, aNames, []);
end;

var
  _RefID: IwbRefID;

function wbRefID: IwbRefID;
begin
  if wbReportMode then
    Result := TwbRefID.Create
  else begin
    if not Assigned(_RefID) then
      _RefID := TwbRefID.Create;
    Result := _RefID;
  end;
end;

function wbRefID(const aName     : string;
                       aPriority : TwbConflictPriority = cpNormal;
                       aRequired : Boolean = False;
                       aDontShow : TwbDontShowCallback = nil;
                       aAfterSet : TwbAfterSetCallback = nil;
                       aGetCP    : TwbGetConflictPriority = nil)
                                 : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU24, wbRefID, aPriority, aRequired, aDontShow, aAfterSet, 0, aGetCP);
end;

function wbRefIDT(const aName     : string;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aAfterSet : TwbAfterSetCallback = nil;
                        aGetCP    : TwbGetConflictPriority = nil)
                                  : IwbIntegerDef; overload;
begin
  Result := wbIntegerT(aName, itU24, wbRefID, aPriority, aRequired, aDontShow, aAfterSet, 0, aGetCP);
end;

var
  _FormID: IwbFormID;

function wbFormID: IwbFormID;
begin
  if wbReportMode then
    Result := TwbFormIDDefFormater.Create
  else begin
    if not Assigned(_FormID) then
      _FormID := TwbFormIDDefFormater.Create;
    Result := _FormID;
  end;
end;

function wbFormID(const aValidRefs : TwbSignatures;
                        aPersistent: Boolean)
                                   : IwbFormID;
begin
  Result := TwbFormIDChecked.Create(aValidRefs, [], aPersistent);
end;

function wbFormIDST(const aValidRefs : TwbSignatures;
                          aPersistent: Boolean)
                                     : IwbFormID;
begin
  Result := TwbFormIDCheckedST.Create(aValidRefs, [], aPersistent);
end;

function wbFormID(const aValidRefs     : TwbSignatures;
                  const aValidFlstRefs : TwbSignatures;
                        aPersistent    : Boolean)
                                       : IwbFormID;
begin
  Result := TwbFormIDChecked.Create(aValidRefs, aValidFlstRefs, aPersistent);
end;

function wbFormIDNoReach(const aValidRefs : TwbSignatures;
                               aPersistent: Boolean)
                                          : IwbFormID;
begin
  Result := TwbFormIDChecked.Create(aValidRefs, [], aPersistent, True);
end;

function wbFormIDNoReach(const aValidRefs     : TwbSignatures;
                         const aValidFlstRefs : TwbSignatures;
                               aPersistent    : Boolean)
                                              : IwbFormID;
begin
  Result := TwbFormIDChecked.Create(aValidRefs, aValidFlstRefs, aPersistent, True);
end;


function wbChar4: IwbChar4;
begin
  Result := TwbChar4.Create;
end;

function wbStr4: IwbStr4;
begin
  Result := TwbStr4.Create;
end;

function wbFormID(const aSignature : TwbSignature;
                  const aName      : string = 'Unknown';
                        aPriority  : TwbConflictPriority = cpNormal;
                        aRequired  : Boolean = False;
                        aDontShow  : TwbDontShowCallback = nil;
                        aGetCP     : TwbGetConflictPriority = nil)
                                   : IwbSubRecordDef; overload;
begin
  Result := wbInteger(
              aSignature,
              aName,
              itU32,
              wbFormID,
              aPriority,
              aRequired,
              False,
              aDontShow,
              nil,
              0,
              aGetCP);
end;

function wbFormID(const aName     : string;
                        aPriority : TwbConflictPriority = cpNormal;
                        aRequired : Boolean = False;
                        aDontShow : TwbDontShowCallback = nil;
                        aAfterSet : TwbAfterSetCallback = nil)
                                  : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU32, wbFormID, aPriority, aRequired, aDontShow, aAfterSet);
end;

function wbFormIDT(const aName     : string;
                         aPriority : TwbConflictPriority = cpNormal;
                         aRequired : Boolean = False;
                         aDontShow : TwbDontShowCallback = nil;
                         aAfterSet : TwbAfterSetCallback = nil;
                         aGetCP    : TwbGetConflictPriority = nil)
                                   : IwbIntegerDef; overload;
begin
  Result := wbIntegerT(aName, itU32, wbFormID, aPriority, aRequired, aDontShow, aAfterSet, 0, aGetCP);
end;

function wbFormIDCk(const aSignature : TwbSignature;
                    const aName      : string;
                    const aValidRefs : TwbSignatures;
                          aPersistent: Boolean = False;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aGetCP     : TwbGetConflictPriority = nil)
                                     : IwbSubRecordDef; overload;
begin
  Result := wbInteger(aSignature, aName, itU32, wbFormID(aValidRefs, aPersistent), aPriority, aRequired, False, aDontShow, nil, 0, aGetCP);
end;

function wbFormIDCkST(const aSignature : TwbSignature;
                      const aName      : string;
                      const aValidRefs : TwbSignatures;
                            aPersistent: Boolean = False;
                            aPriority  : TwbConflictPriority = cpNormal;
                            aRequired  : Boolean = False;
                            aDontShow  : TwbDontShowCallback = nil;
                            aGetCP     : TwbGetConflictPriority = nil)
                                       : IwbSubRecordDef; overload;
begin
  Result := wbInteger(aSignature, aName, itU32, wbFormIDST(aValidRefs, aPersistent), aPriority, aRequired, False, aDontShow, nil, 0, aGetCP);
end;


function wbFormIDCkNoReach(const aSignature : TwbSignature;
                           const aName      : string;
                           const aValidRefs : TwbSignatures;
                                 aPersistent: Boolean = False;
                                 aPriority  : TwbConflictPriority = cpNormal;
                                 aRequired  : Boolean = False;
                                 aDontShow  : TwbDontShowCallback = nil;
                                 aGetCP     : TwbGetConflictPriority = nil)
                                            : IwbSubRecordDef; overload;
begin
  Result := wbInteger(aSignature, aName, itU32, wbFormIDNoReach(aValidRefs, aPersistent), aPriority, aRequired, False, aDontShow, nil, 0, aGetCP);
end;

function wbFormIDCk(const aName      : string;
                    const aValidRefs : TwbSignatures;
                          aPersistent: Boolean = False;
                          aPriority  : TwbConflictPriority = cpNormal;
                          aRequired  : Boolean = False;
                          aDontShow  : TwbDontShowCallback = nil;
                          aAfterSet  : TwbAfterSetCallback = nil)
                                     : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU32, wbFormID(aValidRefs, aPersistent), aPriority, aRequired, aDontShow, aAfterSet);
end;

function wbFormIDCkNoReach(const aName      : string;
                           const aValidRefs : TwbSignatures;
                                 aPersistent: Boolean = False;
                                 aPriority  : TwbConflictPriority = cpNormal;
                                 aRequired  : Boolean = False;
                                 aDontShow  : TwbDontShowCallback = nil;
                                 aGetCP     : TwbGetConflictPriority = nil)
                                            : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU32, wbFormIDNoReach(aValidRefs, aPersistent), aPriority, aRequired, aDontShow, nil, 0, aGetCP);
end;


function wbFormIDCk(const aSignature     : TwbSignature;
                    const aName          : string;
                    const aValidRefs     : TwbSignatures;
                    const aValidFlstRefs : TwbSignatures;
                          aPersistent    : Boolean = False;
                          aPriority      : TwbConflictPriority = cpNormal;
                          aRequired      : Boolean = False;
                          aDontShow      : TwbDontShowCallback = nil;
                          aGetCP         : TwbGetConflictPriority = nil)
                                         : IwbSubRecordDef; overload;
begin
  Result := wbInteger(aSignature, aName, itU32, wbFormID(aValidRefs, aValidFlstRefs, aPersistent), aPriority, aRequired, False, aDontShow, nil, 0, aGetCP);
end;

function wbFormIDCk(const aName          : string;
                    const aValidRefs     : TwbSignatures;
                    const aValidFlstRefs : TwbSignatures;
                          aPersistent    : Boolean = False;
                          aPriority      : TwbConflictPriority = cpNormal;
                          aRequired      : Boolean = False;
                          aDontShow      : TwbDontShowCallback = nil;
                          aGetCP         : TwbGetConflictPriority = nil)
                                         : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU32, wbFormID(aValidRefs, aValidFlstRefs, aPersistent), aPriority, aRequired, aDontShow, nil, 0, aGetCP);
end;

function wbFormIDCkNoReach(const aName          : string;
                           const aValidRefs     : TwbSignatures;
                           const aValidFlstRefs : TwbSignatures;
                                 aPersistent    : Boolean = False;
                                 aPriority      : TwbConflictPriority = cpNormal;
                                 aRequired      : Boolean = False;
                                 aDontShow      : TwbDontShowCallback = nil;
                                 aGetCP         : TwbGetConflictPriority = nil)
                                                : IwbIntegerDef; overload;
begin
  Result := wbInteger(aName, itU32, wbFormIDNoReach(aValidRefs, aValidFlstRefs, aPersistent), aPriority, aRequired, aDontShow, nil, 0, aGetCP);
end;


function wbFlags(const aNames           : array of string;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef;
begin
  Result := wbFlags(nil, aNames, aUnknownIsUnused);
end;

function wbFlags(const aNames           : array of string;
                 const aFlagsToIgnore   : array of integer)
                                        : IwbFlagsDef; overload;
begin
  Result := wbFlags(nil, aNames, aFlagsToIgnore);
end;


function wbFlags(const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
begin
  Result := wbFlags(nil, aNames, aDontShows, aUnknownIsUnused);
end;

function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef;
begin
  Result := TwbFlagsDef.Create(False, aBaseFlagsDef, aNames, [], aUnknownIsUnused, 0, []);
end;

function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aFlagsToIgnore   : array of integer)
                                        : IwbFlagsDef; overload;
var
  IgnoreMask : Int64;
  i          : Integer;
  Index      : Int64;
begin
  IgnoreMask := 0;
  for i := Low(aFlagsToIgnore) to High(aFlagsToIgnore) do begin
    Index := aFlagsToIgnore[i];
    if (Index >= 0) and (Index <= High(aNames)) then
      IgnoreMask := IgnoreMask or (Int64(1) shl Int64(Index));
  end;
  Result := TwbFlagsDef.Create(False, aBaseFlagsDef, aNames, [], False, IgnoreMask, []);
end;


function wbFlags(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
begin
  Result := TwbFlagsDef.Create(False, aBaseFlagsDef, aNames, aDontShows, aUnknownIsUnused, 0, []);
end;

function wbFlagsSummary(const aNames           : array of string;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef;
begin
  Result := wbFlagsSummary(nil, aNames, aUnknownIsUnused);
end;

function wbFlagsSummary(const aNames           : array of string;
                        const aFlagsToIgnore   : array of integer)
                                               : IwbFlagsDef; overload;
begin
  Result := wbFlagsSummary(nil, aNames, aFlagsToIgnore);
end;


function wbFlagsSummary(const aNames           : array of string;
                        const aDontShows       : array of TwbDontShowCallback;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef; overload;
begin
  Result := wbFlagsSummary(nil, aNames, aDontShows, aUnknownIsUnused);
end;

function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                        const aNames           : array of string;
                              aUnknownIsUnused : Boolean = False)
                                               : IwbFlagsDef;
begin
  Result := TwbFlagsDef.Create(True, aBaseFlagsDef, aNames, [], aUnknownIsUnused, 0, []);
end;

function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                        const aNames           : array of string;
                        const aFlagsToIgnore   : array of integer)
                                               : IwbFlagsDef; overload;
var
  IgnoreMask : Int64;
  i          : Integer;
  Index      : Int64;
begin
  IgnoreMask := 0;
  for i := Low(aFlagsToIgnore) to High(aFlagsToIgnore) do begin
    Index := aFlagsToIgnore[i];
    if (Index >= 0) and (Index <= High(aNames)) then
      IgnoreMask := IgnoreMask or (Int64(1) shl Int64(Index));
  end;
  Result := TwbFlagsDef.Create(True, aBaseFlagsDef, aNames, [], False, IgnoreMask, []);
end;


function wbFlagsSummary(const aBaseFlagsDef    : IwbFlagsDef;
                 const aNames           : array of string;
                 const aDontShows       : array of TwbDontShowCallback;
                       aUnknownIsUnused : Boolean = False)
                                        : IwbFlagsDef; overload;
begin
  Result := TwbFlagsDef.Create(True, aBaseFlagsDef, aNames, aDontShows, aUnknownIsUnused, 0, []);
end;


function wbEnum(const aNames : array of string)
                             : IwbEnumDef;
begin
  Result := TwbEnumDef.Create(False, aNames, []);
end;

function wbEnum(const aNames       : array of string;
                const aSparseNames : array of const)
                                   : IwbEnumDef; overload;
begin
  Result := TwbEnumDef.Create(False, aNames, aSparseNames);
end;

function wbEnumSummary(const aNames : array of string)
                                    : IwbEnumDef;
begin
  Result := TwbEnumDef.Create(True, aNames, []);
end;

function wbEnumSummary(const aNames       : array of string;
                       const aSparseNames : array of const)
                                          : IwbEnumDef; overload;
begin
  Result := TwbEnumDef.Create(True, aNames, aSparseNames);
end;

function wbStringEnum(const aNames : array of string)
                                   : IwbStringDefFormater;
begin
  Result := TwbEnumDef.Create(False, aNames, []);
end;

function wbStringEnum(const aNames       : array of string;
                      const aSparseNames : array of const)
                                         : IwbStringDefFormater; overload;
begin
  Result := TwbEnumDef.Create(False, aNames, aSparseNames);
end;

function wbStringEnumSummary(const aNames : array of string)
                                          : IwbStringDefFormater;
begin
  Result := TwbEnumDef.Create(True, aNames, []);
end;

function wbStringEnumSummary(const aNames       : array of string;
                             const aSparseNames : array of const)
                                                : IwbStringDefFormater; overload;
begin
  Result := TwbEnumDef.Create(True, aNames, aSparseNames);
end;

function wbDiv(aValue : Integer)
                      : IwbIntegerDefFormater;
begin
  Result := TwbDivDef.Create(aValue);
end;

function wbMul(aValue : Integer)
                      : IwbIntegerDefFormater;
begin
  Result := TwbMulDef.Create(aValue);
end;

function wbCallback(const aToStr : TwbIntToStrCallback;
                    const aToInt : TwbStrToIntCallback)
                                 : IwbIntegerDefFormater;
begin
  Result := TwbCallbackDef.Create(aToStr, aToInt);
end;

function wbFormaterUnion(aDecider : TwbIntegerDefFormaterUnionDecider;
                         aMembers : array of IwbIntegerDefFormater)
                                  : IwbIntegerDefFormaterUnion;
begin
  Result := TwbIntegerDefFormaterUnion.Create(aDecider, aMembers);
end;

{ TwbDef }

procedure TwbDef.AfterClone(const aSource: TwbDef);
begin
  defSource := aSource;
  defFlags := aSource.defFlags - _DefFlagsDontClone;
end;

procedure TwbDef.AfterConstruction;
begin
  inherited;
  if wbCollapseBenignArray and (GetDefType in [dtSubRecord, dtSubRecordArray, dtArray]) then
    if (defPriority = cpBenign) and not Assigned(defGetCP) then
      Include(defFlags, dfCollapsed);
end;

function TwbDef.Assign(const aTarget : IwbElement;
                             aIndex  : Integer;
                       const aSource : IwbElement;
                             aOnlySK : Boolean)
                                     : IwbElement;
begin
  Result := nil;
  aTarget.SetEditValue(aSource.EditValue);
end;

function TwbDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  Result := False;
end;

constructor TwbDef.Clone(const aSource: TwbDef);
begin
  with aSource do
    Self.Create(defPriority, defRequired, defGetCP).AfterClone(aSource);
end;

constructor TwbDef.Create(aPriority: TwbConflictPriority; aRequired: Boolean; aGetCP: TwbGetConflictPriority);
begin
  if aPriority = cpTranslate then begin
    Include(defFlags, dfTranslatable);
    aPriority := cpNormal;
  end;
  defPriority := aPriority;
  defRequired := aRequired;
  defGetCP := aGetCP;
  inherited Create;
end;

function TwbDef.defInternalEditOnly: Boolean;
begin
  Result := dfInternalEditOnly in defFlags;
end;

function TwbDef.defIsLocked: Boolean;
begin
  Result := Assigned(defParent) or (dfTemplate in defFlags);
end;

function TwbDef.Duplicate: TwbDef;
begin
  Result := TwbDefClass(ClassType).Clone(Self);
end;

function TwbDef.Equals(const aDef: IwbDef): Boolean;
begin
  Result := Assigned(aDef) and (aDef.DefID = GetDefID);
end;

function TwbDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  Result := nil;
  if dfDontAssign in defFlags then
    Exit;
  if aIndex = wbAssignThis then
    Result := [Self];
end;

function TwbDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := -1;
end;

function TwbDef.GetCollapsed: Boolean;
begin
  Result := dfCollapsed in defFlags;
end;

function TwbDef.GetCollapsedGen: Integer;
begin
  Result := defCollapsedGen;
end;

function TwbDef.GetConflictPriority(const aElement: IwbElement): TwbConflictPriority;
begin
  Result := defPriority;
  if Assigned(defGetCP) then
    defGetCP(aElement, Result);
end;

function TwbDef.GetConflictPriorityCanChange: Boolean;
begin
  Result := Assigned(defGetCP);
end;

function TwbDef.GetDefFlags: TwbDefFlags;
begin
  Result := defFlags;
end;

function TwbDef.GetDefID: NativeUInt;
begin
  Result := NativeUInt(Self);
end;

function TwbDef.GetDontShow(const aElement: IwbElement): Boolean;
begin
  Result := False;
end;

function TwbDef.GetHasDontShow: Boolean;
begin
  Result := False;
end;

function TwbDef.GetNoReach: Boolean;
begin
  Result := False;
end;

function TwbDef.GetParent: IwbDef;
begin
  Result := defParent;
end;

function TwbDef.GetRequired: Boolean;
begin
  Result := defRequired;
end;

function TwbDef.GetRoot: IwbDef;
begin
  Result := defSource;
  if not Assigned(Result) then
    Result := Self
  else
    Result := Result.GetRoot;
end;

function TwbDef.IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbDef;
begin
  if defIsLocked and aOnlyWhenTrue and not (aFlag in defFlags) then
    Exit(TwbDef(Duplicate).IncludeFlag(aFlag, aOnlyWhenTrue));

  Result := Self;
  if aOnlyWhenTrue then
    Include(defFlags, aFlag);
end;

function TwbDef.IncludeFlagNoClone(aFlag: TwbDefFlag; aOnlyWhenTrue: Boolean): IwbDef;
begin
  Result := Self;
  if aOnlyWhenTrue then
    Include(defFlags, aFlag);
end;

procedure TwbDef.InitFromParent(aParent: TwbDef);
begin
  if aParent <> defParent then
    Assert(aParent = defParent);

  InitFromParentBeforeChildren;
  InitFromParentDoChildren;
  InitFromParentAfterChildren;
end;

procedure TwbDef.InitFromParentAfterChildren;
begin
  if Assigned(defParent) then
    defParent.defFlags := defParent.defFlags + (defFlags * _DefFlagsInheritDown);
end;

procedure TwbDef.InitFromParentBeforeChildren;
begin
  if Assigned(defParent) then
    defFlags := defFlags + (defParent.defFlags * _DefFlagsInheritUp);

  if dfIsRecordFlags in defFlags then
    Include(defFlags, dfIsRecordFlags);

  if dfUnmappedFormID in defFlags then
   Include(defFlags, dfCanContainUnmappedFormID);

  if not defRequired then begin
    var lRUnion: IwbSubRecordUnionDef;
    if Supports(defParent, IwbSubRecordUnionDef, lRUnion) then
      if lRUnion.Required then
        defRequired := True;
  end;

  if not defRequired then begin
    var lUnion: IwbSubRecordUnionDef;
    if Supports(defParent, IwbUnionDef, lUnion) then
      if lUnion.Required then
        defRequired := True;
  end;
end;

procedure TwbDef.InitFromParentDoChildren;
begin
  {can be overriden}
end;

function TwbDef.IsNotRequired: Boolean;
begin
  Result := defNotRequired;
end;

procedure TwbDef.NotRequired;
begin
  defNotRequired := True;
end;

procedure TwbDef.ParentSet;
begin
  {can be overriden}
end;

procedure TwbDef.PossiblyRequired;
begin
  defPossiblyRequired := True;
end;

function TwbDef.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := inherited;
end;

procedure TwbDef.Report(const aParents: TwbDefPath);
var
  i, j : Integer;
  sl   : TStringList;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  if wbReportUnused then
    if not defUsed then
      WriteLn('Unused: ', wbDefsToPath(aParents), wbDefToName(Self));

  if wbReportRequired and defPossiblyRequired then
    if defNotRequired = defRequired then
      if defNotRequired then
        WriteLn('Not Required: ', wbDefsToPath(aParents), wbDefToName(Self))
      else
        WriteLn('Required: ', wbDefsToPath(aParents), wbDefToName(Self));

  if wbReportUnknown then
    if Assigned(UnknownValues) then begin
      WriteLn('Unknown Field: ', wbDefsToPath(aParents), wbDefToName(Self), ' (', UnknownValues.Count ,')');
      for i := 0 to Pred(UnknownValues.Count) do begin
        sl := UnknownValues.Objects[i] as TStringList;
        WriteLn('  ', UnknownValues[i], ' (', sl.Count ,')');
        for j := 0 to Pred(sl.Count) do
          WriteLn('    ', sl[j]);
      end;
    end else
      if IsUnknown then
        WriteLn('Unknown Field: ', wbDefsToPath(aParents), wbDefToName(Self));

  defReported := True;
end;

procedure TwbDef.SetCollapsed(const aValue: Boolean);
begin
  if aValue <> GetCollapsed then
    Inc(defCollapsedGen);

  if aValue then
    Include(defFlags, dfCollapsed)
  else
    Exclude(defFlags, dfCollapsed);
end;

function TwbDef.SetParent(const aParent: TwbDef; aForceDuplicate: Boolean): IwbDef;
begin
  Assert(Assigned(aParent));
  if aParent = defParent then
    Exit(Self);

  if defIsLocked or aForceDuplicate then
    Result := Duplicate.SetParent(aParent, False)
  else begin
    Result := Self;
    defParent := aParent;
    ParentSet;
  end;
end;

procedure TwbDef.Used(const aElement: IwbElement; const s: string);
var
  i: Integer;
  NamedDef: IwbNamedDef;
begin
  if not wbReportMode then
    Exit;

  defUsed := True;

  if not IsUnknown then
    if not IsUnknownChecked then begin
      IsUnknownChecked := True;
      if Supports(defParent, IwbNamedDef, NamedDef) then
        if Pos('unknown', LowerCase(NamedDef.Name)) > 0 then
          IsUnknown := True;
    end;

  if wbReportUnknown then
    if IsUnknown and Assigned(aElement) and (s <> '') then begin

      if not Assigned(UnknownValues) then
        UnknownValues := TwbFastStringListCS.CreateSorted;

      if UnknownValues.Count < 20 then begin
        if not UnknownValues.Find(s, i) then
          i := UnknownValues.AddObject(s, TwbFastStringListCS.CreateSorted(dupIgnore));

        with UnknownValues.Objects[i] as TStringList do
          if Count < 20 then
            Add(aElement.FullPath);
      end;
    end;
end;

{ TwbNamedDef }

procedure TwbNamedDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbNamedDef do begin
    Self.ndTreeHead := GetTreeHead;
    Self.ndTreeBranch := GetTreeBranch;
    Self.ndToStr := ndToStr;
    Self.ndIsRemovable := ndIsRemovable;
    Self.ndSummaryLinksToCallback := ndSummaryLinksToCallback;
    Self.ndSummaryName := ndSummaryName;
  end;
end;

procedure TwbNamedDef.AfterLoad(const aElement: IwbElement);
begin
  Used(nil, '');
  if Assigned(ndAfterLoad) then
    ndAfterLoad(aElement);
end;


procedure TwbNamedDef.AfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  if Assigned(ndAfterSet) then
    ndAfterSet(aElement, aOldValue, aNewValue);
end;

constructor TwbNamedDef.Clone(const aSource: TwbDef);
begin
  with (aSource as TwbNamedDef) do
    Self.Create(defPriority, defRequired, ndName, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP, ndTerminator).AfterClone(aSource);
end;

constructor TwbNamedDef.Create(aPriority   : TwbConflictPriority;
                               aRequired   : Boolean;
                         const aName       : string;
                               aAfterLoad  : TwbAfterLoadCallback;
                               aAfterSet   : TwbAfterSetCallback;
                               aDontShow   : TwbDontShowCallback;
                               aGetCP      : TwbGetConflictPriority;
                               aTerminator : Boolean);
begin
  ndName := aName;
  ndDontShow := aDontShow;
  ndAfterLoad := aAfterLoad;
  ndAfterSet := aAfterSet;
  ndTerminator := aTerminator;
  ndTreeHead := False;
  ndTreeBranch := False;
  if aName = 'Unused' then begin
    ndUnused := True;
    if aPriority = cpNormal then
      aPriority := cpIgnore;
  end;
  inherited Create(aPriority, aRequired, aGetCP);

  if Pos('unknown', LowerCase(aName)) > 0 then
    IsUnknown := True;
end;

function TwbNamedDef.GetDontShow(const aElement: IwbElement): Boolean;
begin
  if Assigned(ndDontShow) then
    Result := ndDontShow(aElement)
  else
    Result := wbHideUnused and ndUnused;
end;

function TwbNamedDef.GetFullName: string;
begin
  Result := GetName;
end;

function TwbNamedDef.GetFullPath: string;
var
  Child    : IwbDef;
  Parent   : IwbDef;
  NamedDef : IwbNamedDef;
begin
  Result := GetFullName;
  Parent := defParent;
  Child := Self;
  while Assigned(Parent) do begin
    var lPos := Parent.ChildPos[Child];
    var lPosStr := '';
    if lPos >= 0 then
      lPosStr := '[' + lPos.ToString + '] ';
    if Supports(Parent, IwbNamedDef, NamedDef) then
      Result := NamedDef.FullName + ' \ ' + lPosStr + Result
    else
      Result := Parent.DefTypeName + ' \ ' + lPosStr + Result;

    Child := Parent;
    Parent := Child.Parent;
  end;
end;

function TwbNamedDef.GetHasDontShow: Boolean;
begin
  Result := Assigned(ndDontShow) or (wbHideUnused and ndUnused);
end;

function TwbNamedDef.GetName: string;
begin
  Result := ndName;
end;

function TwbNamedDef.GetPath: string;
var
  Parent: IwbDef;
  NamedDef: IwbNamedDef;
begin
  Result := GetName;
  Parent := defParent;
  while Assigned(Parent) do begin
    if Supports(Parent, IwbNamedDef, NamedDef) then
      Result := NamedDef.Name + ' \ ' + Result
    else
      Result := Parent.DefTypeName + ' \ ' + Result;
    Parent := Parent.Parent;
  end;
end;

function TwbNamedDef.GetSingularName: string;
begin
  if ndSingularName = '' then
    ndSingularName := MakeSingularName(GetName);
  Result := ndSingularName;
end;

function TwbNamedDef.GetSummaryLinksTo(const aElement: IwbElement): IwbElement;
begin
  if Assigned(ndSummaryLinksToCallback) then
    Exit(ndSummaryLinksToCallback(aElement));
  Result := nil;
end;

function TwbNamedDef.GetSummaryName: string;
begin
  Result := ndSummaryName;
  if Result = '' then
    Result := GetName;
end;

function TwbNamedDef.GetSummarySingularName: string;
begin
  if ndSummarySingularName = '' then
    ndSummarySingularName := MakeSingularName(GetSummaryName);
  Result := ndSummarySingularName;
end;

function TwbNamedDef.GetTreeBranch: Boolean;
begin
  Result := ndTreeBranch;
end;

function TwbNamedDef.GetTreeHead: Boolean;
begin
  Result := ndTreeHead;
end;

procedure TwbNamedDef.InitFromParentBeforeChildren;
begin
  if not (IsUnknown or ndUnused) and (ndName = '') then begin
    var lParent: IwbNamedDef;
    if Supports(defParent, IwbNamedDef, lParent) then begin
      IsUnknown := IsUnknown or (Pos('unknown', LowerCase(lParent.Name)) > 0);
      ndUnused := ndUnused or (lParent.Name = 'Unused');
    end;
  end;

  if wdMakeUnknownElementsUnique then
    if Assigned(defParent) and IsUnknown and not Supports(Self, IwbSignatureDef) and not ndName.Contains('@') then begin
      var lPos := defParent.GetChildPos(Self);
      if lPos >= 0 then
        ndName := ndName + '@' + lPos.ToString;
    end;

  inherited;
end;

function TwbNamedDef.IsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := not Assigned(ndIsRemovable) or ndIsRemovable(aElement);
end;

function TwbNamedDef.MakeSingularName(const aName: string): string;
begin
  Result := aName;
  if Result.EndsWith('ies') then begin
    SetLength(Result, Length(Result) - 3);
    Result := Result + 'y';
  end else if Result.EndsWith('s') then
    SetLength(Result, Length(Result) - 1);
end;

function TwbNamedDef.SetAfterLoad(const aAfterLoad: TwbAfterLoadCallback): IwbNamedDef;
begin
  if defIsLocked then
    Exit(TwbNamedDef(Duplicate).SetAfterLoad(aAfterLoad));

  Result := Self;
  ndAfterLoad := aAfterLoad;
end;

function TwbNamedDef.SetAfterSet(const aAfterSet: TwbAfterSetCallback): IwbNamedDef;
begin
  if defIsLocked then
    Exit(TwbNamedDef(Duplicate).SetAfterSet(aAfterSet));

  Result := Self;
  ndAfterSet := aAfterSet;
end;

function TwbNamedDef.SetDontShow(const aDontShow: TwbDontShowCallback): IwbNamedDef;
begin
  if defIsLocked then
    Exit(TwbNamedDef(Duplicate).SetDontShow(aDontShow));

  Result := Self;
  ndDontShow := aDontShow;
end;

function TwbNamedDef.SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbNamedDef;
begin
  if defIsLocked then
    Exit(TwbNamedDef(Duplicate).SetIsRemovable(aCallback));

  Result := Self;
  ndIsRemovable := aCallback;
end;

function TwbNamedDef.SetSummaryName(const aName: string): IwbNamedDef;
begin
  if defIsLocked then
    Exit(TwbNamedDef(Duplicate).SetSummaryName(aName));

  Result := Self;

  ndSummaryName := aName;
  ndSummarySingularName := '';
end;

procedure TwbNamedDef.SetTreeBranch(aValue: Boolean);
begin
  ndTreeBranch := avalue;
end;

procedure TwbNamedDef.SetTreeHead(aValue: Boolean);
begin
  ndTreeHead := aValue;
end;

procedure TwbNamedDef.ToString(var Result: string; const aElement: IwbElement; aType: TwbCallbackType);
begin
  if Assigned(ndToStr) then
    ndToStr(Result, nil, nil, aElement, aType);
end;

{ TwbSignatureDef }

constructor TwbSignatureDef.Create(aPriority  : TwbConflictPriority;
                                   aRequired  : Boolean;
                             const aSignature : TwbSignature;
                                   aName      : string;
                                   aAfterLoad : TwbAfterLoadCallback;
                                   aAfterSet  : TwbAfterSetCallback;
                                   aDontShow  : TwbDontShowCallback;
                                   aGetCP     : TwbGetConflictPriority);
begin
  SetLength(soSignatures, 1);
  soSignatures[0] := aSignature;

  if aName = '' then
    aName := aSignature;

  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;

constructor TwbSignatureDef.Clone(const aSource: TwbDef);
begin
  with (aSource as TwbSignatureDef) do
    Self.Create(defPriority, defRequired, soSignatures, ndName, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP).AfterClone(aSource);
end;

constructor TwbSignatureDef.Create(aPriority   : TwbConflictPriority;
                                   aRequired   : Boolean;
                             const aSignatures : TwbSignatures;
                                   aName       : string;
                                   aAfterLoad  : TwbAfterLoadCallback;
                                   aAfterSet   : TwbAfterSetCallback;
                                   aDontShow   : TwbDontShowCallback;
                                   aGetCP      : TwbGetConflictPriority);
var
  i: Integer;
begin
  Assert(Length(aSignatures) >= 1);
  SetLength(soSignatures, Length(aSignatures));
  for i := Low(soSignatures) to High(soSignatures) do
    soSignatures[i] := aSignatures[i];

  if aName = '' then
    if Length(soSignatures) > 0 then
    aName := soSignatures[0];

  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;


function TwbSignatureDef.GetDefaultSignature: TwbSignature;
begin
  Result := soSignatures[0];
end;

function TwbSignatureDef.GetSignatureCount: Integer;
begin
  Result := Length(soSignatures);
end;

function TwbSignatureDef.GetSignature(const aIndex: Integer): TwbSignature;
begin
  Result := soSignatures[aIndex];
end;

{ TwbMainRecordDef }

function TwbMainRecordDef.AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;
begin
  if (wbCopyIsRunning = 0) and Assigned(recAddInfoCallback) then
    Result := recAddInfoCallback(aMainRecord)
  else
    Result := '';
end;

procedure TwbMainRecordDef.AfterClone(const aSource: TwbDef);
begin
  inherited;
  recGetFormIDCallback := (aSource as TwbMainRecordDef).recGetFormIDCallback;
  recIdentityCallback := (aSource as TwbMainRecordDef).recIdentityCallback;
  recGetEditorIDCallback := (aSource as TwbMainRecordDef).recGetEditorIDCallback;
  recSetEditorIDCallback := (aSource as TwbMainRecordDef).recSetEditorIDCallback;
  recGetGridCellCallback := (aSource as TwbMainRecordDef).recGetGridCellCallback;
  recFormIDBase := (aSource as TwbMainRecordDef).recFormIDBase;
  recFormIDNameBase := (aSource as TwbMainRecordDef).recFormIDNameBase;
  recSummaryKey := Copy((aSource as TwbMainRecordDef).recSummaryKey);
  recSummaryPrefix := Copy((aSource as TwbMainRecordDef).recSummaryPrefix);
  recSummarySuffix := Copy((aSource as TwbMainRecordDef).recSummarySuffix);
  recSummaryDelimiter := (aSource as TwbMainRecordDef).recSummaryDelimiter;
  recBuildIndexKeys := (aSource as TwbMainRecordDef).recBuildIndexKeys;
end;

procedure TwbMainRecordDef.AfterLoad(const aElement: IwbElement);
var
  Found     : Boolean;
  Container : IwbContainerElementRef;
  Element   : IwbElement;
  i, j      : Integer;
begin
  inherited;
  if wbReportMode and wbReportRequired and Supports(aElement, IwbContainerElementRef, Container) then begin
    for i := Low(recMembers) to High(recMembers) do if not recMembers[i].IsNotRequired then begin
      Found := False;
      for j := 0 to Pred(Container.ElementCount) do begin
        Element := Container.Elements[j];
        if recMembers[i].Equals(Element.Def) or recMembers[i].Equals(Element.ValueDef) then begin
          Found := True;
          Break;
        end;
      end;
      recMembers[i].PossiblyRequired;
      if not Found then
        recMembers[i].NotRequired;
    end;
  end;
end;

function TwbMainRecordDef.AllowUnordered: Boolean;
begin
  Result := rdfAllowUnordered in recDefFlags;
end;

function TwbMainRecordDef.BuildIndexKeys(const aMainRecord: IwbMainRecord; var aIndexKeys: TwbIndexKeys): Boolean;
begin
  Result := Assigned(recBuildIndexKeys);
  if Result then
    recBuildIndexKeys(aMainRecord, aIndexKeys);
end;

constructor TwbMainRecordDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbMainRecordDef do
    Self.Create(defPriority, defRequired, GetDefaultSignature, ndName, recKnownSRs, recRecordFlags, recMembers,
      AllowUnordered, recAddInfoCallback, ndAfterLoad, ndAfterSet, rdfIsReference in recDefFlags).AfterClone(aSource);
end;

function TwbMainRecordDef.ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                                  aSignature     : TwbSignature;
                                            const aDataContainer : IwbDataContainer)
                                                                 : Boolean;
var
  Dummy: Integer;
begin
  Result := recSignatures.Find(aSignature, Dummy);
end;

constructor TwbMainRecordDef.Create(aPriority        : TwbConflictPriority;
                                    aRequired        : Boolean;
                              const aSignature       : TwbSignature;
                              const aName            : string;
                              const aKnownSRs        : PwbKnownSubRecordSignatures;
                              const aRecordFlags     : IwbIntegerDefFormater;
                              const aMembers         : array of IwbRecordMemberDef;
                                    aAllowUnordered  : Boolean;
                                    aAddInfoCallback : TwbAddInfoCallback;
                                    aAfterLoad       : TwbAfterLoadCallback;
                                    aAfterSet        : TwbAfterSetCallback;
                                    aIsReference     : Boolean);
begin
  recSummaryDelimiter := ' ';

  for var lKnownSubRecordInitIdx := Low(TwbKnownSubRecord) to High(TwbKnownSubRecord) do
    recKnownSRMembers[lKnownSubRecordInitIdx] := -1;

  if Assigned(aKnownSRs) then
    recKnownSRs := aKnownSRs
  else
    recKnownSRs := @wbKnownSubRecordSignatures;

  if aIsReference then
    Include(recDefFlags, rdfIsReference);

  recRecordFlags := aRecordFlags;
  recQuickInitLimit := -1;
  if aAllowUnordered then
    Include(recDefFlags, rdfAllowUnordered);

  recAddInfoCallback := aAddInfoCallback;

  if Assigned(recRecordFlags) and Assigned(wbRecordFlags) and Assigned(wbMainRecordHeader) then begin
    recRecordHeaderStruct := (wbMainRecordHeader as IwbDefInternal).SetParent(Self, True) as IwbStructDef;
    (recRecordHeaderStruct.MembersByName[wbRecordFlags.Name] as IwbIntegerDefInternal).ReplaceFormater(recRecordFlags);
  end;

  recSignatures := TwbFastStringListCS.CreateSorted(dupAccept);
  if aAllowUnordered then
    recSignatures.Duplicates := dupError;

  SetLength(recMembers, Length(aMembers));
  var NewLength : Integer := 0;
  for var lMemberIdx := Low(aMembers) to High(aMembers) do begin
    if Assigned(aMembers[lMemberIdx]) then begin
      recMembers[NewLength] := (aMembers[lMemberIdx] as IwbDefInternal).SetParent(Self, False) as IwbRecordMemberDef;
      for var lSigIdx := 0 to Pred(aMembers[lMemberIdx].SignatureCount) do begin
        var Sig := aMembers[lMemberIdx].Signatures[lSigIdx];
        if (Sig = recKnownSRs[ksrEditorID]) or
           (Sig = recKnownSRs[ksrFullName]) or
           (Sig = recKnownSRs[ksrGridCell]) or
           (
             (Sig = recKnownSRs[ksrBaseRecord]) and
             (rdfIsReference in recDefFlags)
           ) then begin

          recQuickInitLimit := NewLength;

          for var lKnownSubRecordIdx := Low(TwbKnownSubRecord) to High(TwbKnownSubRecord) do
            if Sig = recKnownSRs[lKnownSubRecordIdx] then
              recKnownSRMembers[lKnownSubRecordIdx] := lMemberIdx;

          if Sig = recKnownSRs[ksrBaseRecord] then begin
            var sRec : IwbSubRecordDef;
            var iDef : IwbIntegerDef;
            if not Supports(aMembers[lMemberIdx], IwbSubRecordDef, sRec) then
              Assert(False);
            if not Supports(sRec.Value, IwbIntegerDef, iDef) then
              Assert(False);
            if iDef.FormaterCanChange then
              Assert(False);
            if not Supports(iDef.Formater[nil], IwbFormIDChecked, recBaseRecordFormID) then
              Assert(False);
          end;
        end;
        try
          recSignatures.AddObject(Sig, Pointer(NewLength) );
        except
          on E: Exception do
            raise Exception.Create('Duplicate definition ' + Sig + ' in allow unordered record ' + aSignature);
        end;
      end;
      Inc(NewLength);
    end;
  end;
  SetLength(recMembers, NewLength);

  if aIsReference and not Assigned(recBaseRecordFormID) then
    raise Exception.Create('Reference MainRecord must have BaseRecordFormID');

  var lRecordFlags: IwbFlagsDef;
  var lPartialFormFlag: IwbFlagDef;
  if Assigned(recRecordFlags) and
     Supports(recRecordFlags, IwbFlagsDef, lRecordFlags) and
     lRecordFlags.FindFlag('Partial Form', lPartialFormFlag)
  then begin
    Include(recDefFlags, rdfCanBePartial);
  end;

  inherited Create(aPriority, aRequired, aSignature, aName, aAfterLoad, aAfterSet, nil, nil);
end;

function TwbMainRecordDef.GetMember(aIndex: Integer): IwbRecordMemberDef;
begin
  Result := recMembers[aIndex];
end;

function TwbMainRecordDef.GetMemberCount: Integer;
begin
  Result := Length(recMembers);
end;

function TwbMainRecordDef.GetMemberFor(const aContainer     : IwbContainerElementRef;
                                             aSignature     : TwbSignature;
                                       const aDataContainer : IwbDataContainer)
                                                            : IwbRecordMemberDef;
var
  i: Integer;
begin
  if recSignatures.Find(aSignature, i) then
    Result := recMembers[Integer(recSignatures.Objects[i])]
  else
    Result := nil;
end;

function TwbMainRecordDef.GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                                  aSignature     : TwbSignature;
                                            const aDataContainer : IwbDataContainer)
                                                                 : Integer;
var
  i: Integer;
begin
  if recSignatures.Find(aSignature, i) then
    Result := Integer(recSignatures.Objects[i])
  else
    Result := -1;
end;

function TwbMainRecordDef.GetQuickInitLimit: Integer;
begin
  Result := recQuickInitLimit;
end;

function TwbMainRecordDef.GetRecordHeaderStruct: IwbStructDef;
begin
  if Assigned(recRecordHeaderStruct) then
    Result := recRecordHeaderStruct as IwbStructDef
  else
    Result := wbMainRecordHeader as IwbStructDef;
end;

function TwbMainRecordDef.GetReferenceSignature(const aIndex: Integer): TwbSignature;
begin
  recBuildReferences;
  Result := StrToSignature(recReferences[aIndex]);
end;

function TwbMainRecordDef.GetReferenceSignatureCount: Integer;
begin
  recBuildReferences;
  Result := recReferences.Count;
end;

function TwbMainRecordDef.GetSkipSignature(const aSignature: TwbSignature): Boolean;
begin
  Result := False;
end;

procedure TwbMainRecordDef.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(recMembers) to High(recMembers) do
    if Assigned(recMembers[lMemberIdx]) then
      (recMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
  if Assigned(recRecordHeaderStruct) then
    (recRecordHeaderStruct as IwbDefInternal).InitFromParent(Self);
end;

function TwbMainRecordDef.IsValidBaseSignature(const aSignature: TwbSignature): Boolean;
begin
  Result := Assigned(recBaseRecordFormID) and recBaseRecordFormID.IsValid(aSignature);
end;

function TwbMainRecordDef.IsValidReferenceSignature(const aSignature: TwbSignature): Boolean;
var
  Dummy: Integer;
begin
  recBuildReferences;
  Result := recReferences.Find(aSignature, Dummy);
end;

function TwbMainRecordDef.KnownSubRecordSignatures: PwbKnownSubRecordSignatures;
begin
  Result := recKnownSRs;
end;

procedure TwbMainRecordDef.recBuildReferences;
var
  i: Integer;
begin
  if Assigned(recReferences) then
    Exit;

  recReferences := TStringList.Create;
  recReferences.Sorted := True;
  recReferences.Duplicates := dupIgnore;

  for i := Low(wbRefRecordDefs) to High(wbRefRecordDefs) do
    if wbRefRecordDefs[i].IsValidBaseSignature(soSignatures[0]) then
      recReferences.Add(wbRefRecordDefs[i].DefaultSignature);
end;

procedure TwbMainRecordDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
  i       : Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  Parents := aParents;
  SetLength(Parents, Succ(Length(Parents)));
  Parents[High(Parents)].Def := Self;
  for i := Low(recMembers) to High(recMembers) do
    if Assigned(recMembers[i]) then begin
      Parents[High(Parents)].Index := i;
      recMembers[i].Report(Parents);
    end;

  defReported := True;
end;

function TwbMainRecordDef.SetAddInfo(const aAddInfo: TwbAddInfoCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetAddInfo(aAddInfo));

  Result := Self;
  recAddInfoCallback := aAddInfo;
end;

function TwbMainRecordDef.SetBuildIndexKeys(const aCallback: TwbBuildIndexKeysCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetBuildIndexKeys(aCallback));

  Result := Self;
  recBuildIndexKeys := aCallback;
end;

procedure TwbMainRecordDef.SetEditorID(const aSubRecord: IwbSubRecord; const aEditorID: string);
begin
  if Assigned(recSetEditorIDCallback) then
    recSetEditorIDCallback(aSubRecord, aEditorID)
  else if aEditorID = '' then
    aSubRecord.Remove
  else
    aSubRecord.EditValue := aEditorID;
end;

function TwbMainRecordDef.SetFormIDBase(aBase: Byte): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetFormIDBase(aBase));

  Result := Self;
  recFormIDBase := aBase;
end;

function TwbMainRecordDef.SetFormIDNameBase(aBase: Byte): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetFormIDNameBase(aBase));

  Result := Self;
  recFormIDNameBase := aBase;
end;

function TwbMainRecordDef.SetGetEditorIDCallback(const aCallback: TwbMainRecordGetEditorIDCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetGetEditorIDCallback(aCallback));

  recGetEditorIDCallback := aCallback;
  Result := Self;
end;

function TwbMainRecordDef.SetGetFormIDCallback(const aCallback: TwbMainRecordGetFormIDCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetGetFormIDCallback(aCallback));

  recGetFormIDCallback := aCallback;
  Result := Self;
end;

function TwbMainRecordDef.SetGetGridCellCallback(const aCallback: TwbMainRecordGetGridCellCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetGetGridCellCallback(aCallback));

  recGetGridCellCallback := aCallback;
  Result := Self;
end;

function TwbMainRecordDef.SetIdentityCallback(const aCallback: TwbMainRecordIdentityCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetIdentityCallback(aCallback));

  recIdentityCallback := aCallback;
  Result := Self;
end;

function TwbMainRecordDef.SetIgnoreList(const aSignatures: array of TwbSignature): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetIgnoreList(aSignatures));

  Result := Self;
  SetLength(recIgnoreList, Length(aSignatures));
  for var lIdx := Low(aSignatures) to High(aSignatures) do
    recIgnoreList[lIdx] := aSignatures[lIdx];
end;

function TwbMainRecordDef.SetSetEditorIDCallback(const aCallback: TwbMainRecordSetEditorIDCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetSetEditorIDCallback(aCallback));

  recSetEditorIDCallback := aCallback;
  Result := Self;
end;

function TwbMainRecordDef.SetSummaryDelimiter(const aDelimiter: string): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetSummaryDelimiter(aDelimiter));

  Result := Self;
  recSummaryDelimiter := aDelimiter;
end;

function TwbMainRecordDef.SetSummaryKey(const aSummaryKey: array of Integer): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetSummaryKey(aSummaryKey));

  Result := Self;
  recSummaryKey := nil;
  SetLength(recSummaryKey, Length(aSummaryKey));
  for var i := Low(recSummaryKey) to High(recSummaryKey) do
    recSummaryKey[i] := aSummaryKey[i];
end;

procedure wbSetPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string; var arrPrefix, arrSuffix: TwbStringArray);

  procedure SetArrayEntry(const aValue: string; var aArray: TwbStringArray);
  begin
    if aValue <> '' then
      if Length(aArray) < Succ(aIndex) then
        SetLength(aArray, Succ(aIndex));
    if High(aArray) >= aIndex then
      aArray[aIndex] := aValue;
  end;

begin
  SetArrayEntry(aPrefix, arrPrefix);
  SetArrayEntry(aSuffix, arrSuffix);
end;

procedure wbSetMaxDepth(aIndex: Integer; aMaxDepth: Integer; var arrMaxDepth: TArray<Integer>);

  procedure SetArrayEntry(const aValue: Integer; var aArray: TArray<Integer>);
  begin
    if aValue <> 0 then
      if Length(aArray) < Succ(aIndex) then
        SetLength(aArray, Succ(aIndex));
    if High(aArray) >= aIndex then
      aArray[aIndex] := aValue;
  end;

begin
  SetArrayEntry(aMaxDepth, arrMaxDepth);
end;


function TwbMainRecordDef.SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetSummaryMemberMaxDepth(aIndex, aMaxDepth));

  Result := Self;
  Assert(InRange(aIndex, Low(recMembers), High(recMembers)), '[TwbMainRecordDef.SetSummaryMemberMaxDepth] not InRange(aIndex, Low(recMembers), High(recMembers))');
  wbSetMaxDepth(aIndex, aMaxDepth, recSummaryMaxDepth);
end;

function TwbMainRecordDef.SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetSummaryMemberPrefixSuffix(aIndex, aPrefix, aSuffix));

  Result := Self;
  Assert(InRange(aIndex, Low(recMembers), High(recMembers)), '[TwbMainRecordDef.SetSummaryMemberPrefixSuffix] not InRange(aIndex, Low(recMembers), High(recMembers))');
  wbSetPrefixSuffix(aIndex, aPrefix, aSuffix, recSummaryPrefix, recSummarySuffix);
end;

function TwbMainRecordDef.SetToStr(const aToStr: TwbToStrCallback): IwbMainRecordDef;
begin
  if defIsLocked then
    Exit(TwbMainRecordDef(Duplicate).SetToStr(aToStr));

  Result := Self;
  ndToStr := aToStr;
end;

function TwbMainRecordDef.ShouldIgnore(const aSignature: TwbSignature): Boolean;
begin
  for var lIdx := Low(recIgnoreList) to High(recIgnoreList) do
    if recIgnoreList[lIdx] = aSignature then
      Exit(True);
  Result := False;
end;

type
  TFromArray<T> = class
  public
    class function Get(const aArray: array of T; aIndex: Integer): T; static;
  end;

class function TFromArray<T>.Get(const aArray: array of T; aIndex: Integer): T;
begin
  if InRange(aIndex, Low(aArray), High(aArray)) then
    Result := aArray[aIndex]
  else
    Result := Default(T);
end;

procedure StructKeysToSummary(aDepth     : Integer;
                          var Result     : string;
                        const aElement   : IwbElement;
                        const aMembers   : array of IwbRecordMemberDef;
                        const aKeys      : array of integer;
                        const aPrefix    : array of string;
                        const aSuffix    : array of string;
                        const aMaxDepth  : array of integer;
                        const aDelimiter : string;
                          var aLinksTo   : IwbElement);


begin
  var l := Length(aKeys);
  if l > 0 then begin
    var DelayedName := '';
    var CER: IwbContainerElementRef;
    if Supports(aElement, IwbContainerElementRef, CER) then begin
      var MembersNoName := (dfSummaryMembersNoName in CER.Def.DefFlags);
      var MembersShowIgnore := (dfSummaryMembersShowIgnore in CER.Def.DefFlags);
      for var i := 0 to Pred(l) do begin
        var SortOrder := aKeys[i];
        if (SortOrder >= Low(aMembers)) and (SortOrder <= High(aMembers)) then begin
          var MaxDepth := TFromArray<Integer>.Get(aMaxDepth, SortOrder);
          if (MaxDepth = 0) or (aDepth < MaxDepth) then begin
            var Member := CER.ElementBySortOrder[SortOrder + CER.AdditionalElementCount];
            var MemberCER: IwbContainerElementRef;
            if not Supports(Member, IwbContainerElementRef, MemberCER) then
              MemberCER := nil;
            var RMD: IwbRecordMemberDef;
            if Assigned(Member) and
               not Member.DontShow and
               Supports(Member.Def, IwbRecordMemberDef, RMD) and
               (MembersShowIgnore or (dfSummaryShowIgnore in RMD.DefFlags) or not wbHideIgnored or (Member.ConflictPriority > cpIgnore))
            then begin
              var lMemberSummary := RMD.ToSummary(Succ(aDepth), Member, aLinksTo).Trim;
              if lMemberSummary <> '' then begin
                var Prefix := TFromArray<string>.Get(aPrefix, SortOrder);
                var Suffix := TFromArray<string>.Get(aSuffix, SortOrder);
                var HasFix := (Prefix <> '') or (Suffix <> '');
                var NoName := MembersNoName or (dfSummaryNoName in RMD.DefFlags);

                if Result <> '' then begin
                  if DelayedName <> '' then begin
                    Result := DelayedName + ':(' + Result + ')';
                    DelayedName := '';
                  end;
                  Result := Result + aDelimiter;
                end;

                var lMemberSummaryName := RMD.SummaryName;
                if (MemberCER.ElementType = etSubRecordArray) and (MemberCER.ElementCount = 1) then
                  lMemberSummaryName := RMD.GetSummarySingularName;

                if NoName or HasFix or lMemberSummary.StartsWith(lMemberSummaryName + ':(', True) then
                  Result := Result + Prefix + lMemberSummary + Suffix
                else begin
                  if Result = '' then begin
                    DelayedName := lMemberSummaryName;
                    Result := lMemberSummary;
                  end else
                    Result := Result + lMemberSummaryName + ':(' + lMemberSummary + ')';
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TwbMainRecordDef.ToSummary(aDepth: Integer; const aMainRecord: IwbMainRecord; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    // don't access DataBasePtr for IwbMainRecord, it forces a Merge which isn't properly implmented
    ndToStr(Result, nil {aMainRecord.DataBasePtr}, nil{aMainRecord.DataEndPtr}, aMainRecord, ctToSummary);

  if Result = '' then
    StructKeysToSummary(aDepth, Result, aMainRecord, recMembers, recSummaryKey, recSummaryPrefix, recSummarySuffix, recSummaryMaxDepth, recSummaryDelimiter, aLinksTo);

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aMainRecord) then
    aLinksTo := aMainRecord.LinksTo;
end;

destructor TwbMainRecordDef.Destroy;
begin
  inherited;
  FreeAndNil(recSignatures);
  FreeAndNil(recReferences);
end;

function TwbMainRecordDef.GetBaseSignature(const aIndex: Integer): TwbSignature;
begin
  if Assigned(recBaseRecordFormID) then
    Result := recBaseRecordFormID.Signatures[aIndex]
  else
    raise Exception.Create('Invalid index');
end;

function TwbMainRecordDef.GetBaseSignatureCount: Integer;
begin
  if Assigned(recBaseRecordFormID) then
    Result := recBaseRecordFormID.SignatureCount
  else
    Result := 0;
end;

function TwbMainRecordDef.GetCanBePartial: Boolean;
begin
  Result := rdfCanBePartial in recDefFlags;
end;

function TwbMainRecordDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(recMembers) to High(recMembers) do
      if aChild.Equals(recMembers[lIdx]) then
        Exit(lIdx);
end;

function TwbMainRecordDef.GetContainsKnownSubRecord(aKnownSubRecord: TwbKnownSubRecord): Boolean;
begin
  Result := recKnownSRMembers[aKnownSubRecord] >= 0;
end;

function TwbMainRecordDef.GetDefType: TwbDefType;
begin
  Result := dtRecord;
end;

function TwbMainRecordDef.GetDefTypeName: string;
begin
  Result := 'Record';
end;

function TwbMainRecordDef.GetEditorID(const aSubRecord: IwbSubRecord): string;
begin
  if Assigned(recGetEditorIDCallback) then
    Result := recGetEditorIDCallback(aSubRecord)
  else
    Result := aSubRecord.EditValue;
end;

function TwbMainRecordDef.GetFormID(const aMainRecord: IwbMainRecord; out aFormID: TwbFormID): Boolean;
begin
  Result := Assigned(recGetFormIDCallback) and recGetFormIDCallback(aMainRecord, aFormID);
end;

function TwbMainRecordDef.GetFormIDBase: Byte;

  procedure RaiseAssert;
  begin
    Assert(False, GetName + ' has no FormID Base');
  end;

begin
  Result := recFormIDBase;
  if Result < 1 then
    RaiseAssert;
end;

function TwbMainRecordDef.GetFormIDNameBase: Byte;
begin
  Result := recFormIDNameBase;
  if Result < 1 then
    Result := GetFormIDBase;
end;

function TwbMainRecordDef.GetGridCell(const aSubRecord: IwbSubRecord; out aGridCell: TwbGridCell): Boolean;
begin
  if Assigned(recGetGridCellCallback) then
    Result := recGetGridCellCallback(aSubRecord, aGridCell)
  else begin
    Result := True;
    with aGridCell, aSubRecord do begin
      X := ElementNativeValues['X'];
      Y := ElementNativeValues['Y'];
    end;
  end;
end;

function TwbMainRecordDef.GetIdentity(const aMainRecord: IwbMainRecord): string;
begin
  if Assigned(recIdentityCallback) then
    Result := recIdentityCallback(aMainRecord)
  else
    Result := aMainRecord.EditorID;
end;

function TwbMainRecordDef.GetIsReference: Boolean;
begin
  Result := rdfIsReference in recDefFlags;
end;

function TwbMainRecordDef.GetKnownSubRecordMember(aKnownSubRecord: TwbKnownSubRecord): IwbRecordMemberDef;
begin
  Result := nil;
  var lIndex := recKnownSRMembers[aKnownSubRecord];
  if lIndex >= 0 then
    Result := recMembers[lIndex];
end;

function TwbMainRecordDef.GetKnownSubRecordMemberIndex(aKnownSubRecord: TwbKnownSubRecord): Integer;
begin
  Result := recKnownSRMembers[aKnownSubRecord];
end;

{ TwbSubRecordDef }

function TwbSubRecordDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  SubRecordDef : IwbSubRecordDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if Supports(aDef, IwbSubRecordDef, SubRecordDef) then
    Result := Equals(aDef) or Assigned(srValue) and srValue.CanAssign(aElement, aIndex, SubRecordDef.Value)
  else
    Result := Assigned(srValue) and srValue.CanAssign(aElement, aIndex, aDef);
end;

function TwbSubRecordDef.CanHandle(const aContainer     : IwbContainerElementRef;
                                         aSignature     : TwbSignature;
                                   const aDataContainer : IwbDataContainer)
                                                        : Boolean;

begin
  Result := inherited CanHandle(aContainer, aSignature, aDataContainer);
  if Result and srSizeMatch and Assigned(aDataContainer) and Assigned(srValue) then
    Result := aDataContainer.DataSize = srValue.DefaultSize[nil, nil, nil];
end;

constructor TwbSubRecordDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbSubRecordDef do
    Self.Create(defPriority, defRequired, soSignatures, ndName, srValue, ndAfterLoad, ndAfterSet, srSizeMatch, ndDontShow, defGetCP).AfterClone(aSource);
end;

constructor TwbSubRecordDef.Create(aPriority  : TwbConflictPriority;
                                   aRequired  : Boolean;
                             const aSignature : TwbSignature;
                             const aName      : string;
                             const aValue     : IwbValueDef;
                                   aAfterLoad : TwbAfterLoadCallback;
                                   aAfterSet  : TwbAfterSetCallback;
                                   aSizeMatch : Boolean;
                                   aDontShow  : TwbDontShowCallback;
                                   aGetCP     : TwbGetConflictPriority);
begin
  srSizeMatch := aSizeMatch;
  if Assigned(aValue) then
    srValue := (aValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  inherited Create(aPriority, aRequired, aSignature, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP);
end;

constructor TwbSubRecordDef.Create(aPriority   : TwbConflictPriority;
                                   aRequired   : Boolean;
                             const aSignatures : TwbSignatures;
                             const aName       : string;
                             const aValue      : IwbValueDef;
                                   aAfterLoad  : TwbAfterLoadCallback;
                                   aAfterSet   : TwbAfterSetCallback;
                                   aSizeMatch  : Boolean;
                                   aDontShow   : TwbDontShowCallback;
                                   aGetCP      : TwbGetConflictPriority);
begin
  srSizeMatch := aSizeMatch;
  if Assigned(aValue) then
    srValue := (aValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  inherited Create(aPriority, aRequired, aSignatures, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP);
end;

function TwbSubRecordDef.ForValue(const aCallback: TwbSubRecordForValueCallback): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).ForValue(aCallback));

  Result := Self;
  aCallback(GetValue);
end;

function TwbSubRecordDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  {
  Exit(nil);

  Result := nil;
  if dfDontAssign in defFlags then
    Exit;

  if Assigned(srValue) then
    Exit(srValue.GetAssignTemplates(aContainer, aIndex));
  }
  Result := inherited;
end;

function TwbSubRecordDef.GetDefType: TwbDefType;
begin
  Result := dtSubRecord;
end;

function TwbSubRecordDef.GetDefTypeName: string;
begin
  Result := 'SubRecord of ' + GetValue.GetDefTypeName;
end;

function TwbSubRecordDef.GetValue: IwbValueDef;
begin
  Result := srValue;
end;

procedure TwbSubRecordDef.HasUnusedData;
begin
  srHasUnusedData := True;
end;

function TwbSubRecordDef.IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue : Boolean = True): IwbRecordMemberDef;
begin
  Result := inherited IncludeFlag(aFlag, aOnlyWhenTrue) as IwbRecordMemberDef;
end;

function TwbSubRecordDef.IncludeFlagOnValue(aFlag: TwbDefFlag; aOnlyWhenTrue: Boolean): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).IncludeFlagOnValue(aFlag, aOnlyWhenTrue));

  Result := Self;
  srValue := srValue.IncludeFlag(aFlag, aOnlyWhenTrue);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

procedure TwbSubRecordDef.InitFromParentDoChildren;
begin
  inherited;
  if Assigned(srValue) then
    (srValue as IwbDefInternal).InitFromParent(Self);
end;

function TwbSubRecordDef.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IID = IwbSubRecordWithStructDef then
    if not Supports(srValue, IwbStructDef) then
      Exit(E_NOINTERFACE);

  if IID = IwbSubRecordWithArrayDef then
    if not Supports(srValue, IwbArrayDef) then
      Exit(E_NOINTERFACE);

  if IID = IwbSubRecordWithBaseStringDef then
    if not Supports(srValue, IwbBaseStringDef) then
      Exit(E_NOINTERFACE);

  Result := inherited;
end;

procedure TwbSubRecordDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if Assigned(srValue) then begin
    Parents := aParents;
    SetLength(Parents, Succ(Length(Parents)));
    Parents[High(Parents)].Def := Self;
    Parents[High(Parents)].Index := -1;
    srValue.Report(Parents);
  end;
  if wbReportUnusedData then
    if srHasUnusedData then
      WriteLn('Has Unused Data: ', wbDefsToPath(aParents), wbDefToName(Self));

  defReported := True;
end;

function TwbSubRecordDef.SetAfterLoad(const aAfterLoad: TwbAfterLoadCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetAfterLoad(aAfterLoad));

  Result := Self;
  ndAfterLoad := aAfterLoad;
end;

function TwbSubRecordDef.SetAfterSet(const aAfterSet: TwbAfterSetCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetAfterSet(aAfterSet));

  Result := Self;
  ndAfterSet := aAfterSet;
end;

function TwbSubRecordDef.SetCountFromEnumOnValue(const aEnum: IwbEnumDef): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetCountFromEnumOnValue(aEnum));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetCountFromEnum(aEnum);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetCountPathOnValue(const aValue: string; aUseForCountCallback: Boolean): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetCountPathOnValue(aValue, aUseForCountCallback));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetCountPath(aValue, aUseForCountCallback);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetDefaultEditValue(const aValue: string): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetDefaultEditValue(aValue));

  if Assigned(srValue) then begin
    srValue := srValue.SetDefaultEditValue(aValue);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end;

  Result := Self;
end;

function TwbSubRecordDef.SetDefaultEditValues(const aValues: array of string): IwbRecordMemberDef;
var
  a: IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetDefaultEditValues(aValues));

  if Supports(srValue, IwbArrayDef, a) then begin
    srValue := a.SetDefaultEditValues(aValues);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end;
  Result := Self;
end;

function TwbSubRecordDef.SetDefaultEditValuesOnValue(const aValues: array of string): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetDefaultEditValuesOnValue(aValues));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetDefaultEditValues(aValues);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetDefaultNativeValue(const aValue: Variant): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetDefaultNativeValue(aValue));

  if Assigned(srValue) then begin
    srValue := srValue.SetDefaultNativeValue(aValue);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end;
  Result := Self;
end;

function TwbSubRecordDef.SetDontShow(const aDontShow: TwbDontShowCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetDontShow(aDontShow));

  Result := Self;
  ndDontShow := aDontShow;
end;

function TwbSubRecordDef.SetFormaterOnValue(const aFormater: IwbStringDefFormater): IwbSubRecordWithBaseStringDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetFormaterOnValue(aFormater));

  Result := Self;
  srValue := (srValue as IwbBaseStringDef).SetFormater(aFormater);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetIsRemovable(aCallback));

  Result := Self;
  ndIsRemovable := aCallback;
end;

function TwbSubRecordDef.SetLinksToCallbackOnValue(const aCallback: TwbLinksToCallback): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetLinksToCallbackOnValue(aCallback));

  if Assigned(srValue) then begin
    srValue := srValue.SetLinksToCallback(aCallback);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end;
  Result := Self;
end;

function TwbSubRecordDef.SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryLinksToCallback(aCallback));

  Result := Self;
  ndSummaryLinksToCallback := aCallback;
end;

function TwbSubRecordDef.SetSummaryLinksToCallbackOnValue(const aCallback: TwbLinksToCallback): IwbSubRecordDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryLinksToCallbackOnValue(aCallback));

  if Assigned(srValue) then begin
    srValue := srValue.SetSummaryLinksToCallback(aCallback);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end;
  Result := Self;
end;

function TwbSubRecordDef.SetSummaryDelimiterOnArray(const aDelimiter: string): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryDelimiterOnArray(aDelimiter));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetSummaryDelimiter(aDelimiter);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryDelimiterOnStruct(const aDelimiter: string): IwbSubRecordWithStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryDelimiterOnStruct(aDelimiter));

  Result := Self;
  srValue := (srValue as IwbStructDef).SetSummaryDelimiter(aDelimiter);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryKeyOnValue(const aSummaryKey: array of Integer): IwbSubRecordWithStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryKeyOnValue(aSummaryKey));

  Result := Self;
  srValue := (srValue as IwbStructDef).SetSummaryKey(aSummaryKey);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryMemberMaxDepthOnValue(aIndex, aMaxDepth: Integer): IwbSubRecordWithStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryMemberMaxDepthOnValue(aIndex, aMaxDepth));

  Result := Self;
  srValue := (srValue as IwbStructDef).SetSummaryMemberMaxDepth(aIndex, aMaxDepth);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryName(const aName: string): IwbRecordMemberDef;
begin
  Result := inherited SetSummaryName(aName) as IwbRecordMemberDef;
end;

function TwbSubRecordDef.SetSummaryPassthroughMaxCountOnValue(aCount: Integer): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryPassthroughMaxCountOnValue(aCount));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetSummaryPassthroughMaxCount(aCount);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryPassthroughMaxDepthOnValue(aDepth: Integer): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryPassthroughMaxDepthOnValue(aDepth));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetSummaryPassthroughMaxDepth(aDepth);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryPassthroughMaxLengthOnValue(aLength: Integer): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryPassthroughMaxLengthOnValue(aLength));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetSummaryPassthroughMaxLength(aLength);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetSummaryPrefixSuffixOnValue(aIndex: Integer; const aPrefix, aSuffix: string): IwbSubRecordWithStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetSummaryPrefixSuffixOnValue(aIndex, aPrefix, aSuffix));

  Result := Self;
  srValue := (srValue as IwbStructDef).SetSummaryMemberPrefixSuffix(aIndex, aPrefix, aSuffix);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.SetRequired(const aRequired: Boolean): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetRequired(aRequired));

  Result := Self;
  defRequired := aRequired;
end;

function TwbSubRecordDef.SetToStr(const aToStr: TwbToStrCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetToStr(aToStr));

  Result := Self;
  if Assigned(srValue) then begin
    srValue := srValue.SetToStr(aToStr);
    srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  end else
    ndToStr := aToStr;
end;

function TwbSubRecordDef.SetWronglyAssumedFixedSizePerElementOnValue(aSize: Integer): IwbSubRecordWithArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordDef(Duplicate).SetWronglyAssumedFixedSizePerElementOnValue(aSize));

  Result := Self;
  srValue := (srValue as IwbArrayDef).SetWronglyAssumedFixedSizePerElement(aSize);
  srValue := (srValue as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
end;

function TwbSubRecordDef.ToSummary(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, nil, nil, aElement, ctToSummary);
  if (Result = '') and Assigned(aElement) and Assigned(srValue) then begin
    var DataContainer: IwbDataContainer;
    if Supports(aElement, IwbDataContainer, DataContainer) then
      Result := srValue.ToSummary(aDepth, DataContainer.DataBasePtr, DataContainer.DataEndPtr, aElement, aLinksTo);
  end;
  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

{ TwbSubRecordArrayDef }

procedure TwbSubRecordArrayDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbSubRecordArrayDef do begin
    Self.sraDefaultEditValues := sraDefaultEditValues;
    Self.sraCountPath := sraCountPath;
  end;
end;

procedure TwbSubRecordArrayDef.AfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
begin
  inherited;
  if wbReportMode and wbReportRequired and Supports(aElement, IwbContainerElementRef, Container) then begin
    sraElement.PossiblyRequired;
    if Container.ElementCount < 1 then
      sraElement.NotRequired;
  end;
end;

function TwbSubRecordArrayDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  SubRecordArrayDef : IwbSubRecordArrayDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if aIndex = Low(Integer) then
    Result := Supports(aDef, IwbSubRecordArrayDef, SubRecordArrayDef) and
      GetElement.CanAssign(aElement, aIndex, SubRecordArrayDef.Element)
  else if aIndex = High(Integer) then
    Result := GetElement.CanAssign(aElement, Low(Integer), aDef)
  else
    Result := False;
end;

function TwbSubRecordArrayDef.CanHandle(const aContainer     : IwbContainerElementRef;
                                              aSignature     : TwbSignature;
                                        const aDataContainer : IwbDataContainer)
                                                             : Boolean;
begin
  Result := sraElement.CanHandle(aContainer, aSignature, aDataContainer);
end;

constructor TwbSubRecordArrayDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbSubRecordArrayDef do
    Self.Create(defPriority, defRequired, ndName, sraElement, sraCount, sraSorted,
      ndAfterLoad, ndAfterSet, ndDontShow, sraIsSorted, defGetCP).AfterClone(aSource);
end;

constructor TwbSubRecordArrayDef.Create(aPriority  : TwbConflictPriority; aRequired: Boolean;
                                  const aName      : string;
                                  const aElement   : IwbRecordMemberDef;
                                        aCount     : Integer;
                                        aSorted    : Boolean;
                                        aAfterLoad : TwbAfterLoadCallback;
                                        aAfterSet  : TwbAfterSetCallback;
                                        aDontShow  : TwbDontShowCallback;
                                        aIsSorted  : TwbIsSortedCallback;
                                        aGetCP     : TwbGetConflictPriority);
begin
  if wbNeverSorted then
    aSorted := False;

  if Assigned(aElement) then
    sraElement := (aElement as IwbDefInternal).SetParent(Self, False) as IwbRecordMemberDef;
  sraSorted := aSorted;
  sraIsSorted := aIsSorted;
  sraCount := aCount;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;

function TwbSubRecordArrayDef.GetElement: IwbRecordMemberDef;
begin
  Result := sraElement;
end;

function TwbSubRecordArrayDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  Result := nil;
  if dfDontAssign in defFlags then
    Exit;

  if (aIndex = wbAssignAdd) and Assigned(sraElement) then
    Exit(sraElement.GetAssignTemplates(aContainer, wbAssignThis));

  Result := inherited;
end;

function TwbSubRecordArrayDef.GetCount: Integer;
begin
  Result := sraCount;
end;

function TwbSubRecordArrayDef.GetCountPath: string;
begin
  Result := sraCountPath;
end;

function TwbSubRecordArrayDef.GetDefaultEditValues: TwbStringArray;
begin
  Result := Copy(sraDefaultEditValues);
end;

function TwbSubRecordArrayDef.GetDefaultSignature: TwbSignature;
begin
  Result := sraElement.GetDefaultSignature;
end;

function TwbSubRecordArrayDef.GetSignatureCount: Integer;
begin
  Result := sraElement.GetSignatureCount;
end;

function TwbSubRecordArrayDef.GetSignature(const aIndex: Integer): TwbSignature;
begin
  Result := sraElement.GetSignature(aIndex);
end;

function TwbSubRecordArrayDef.GetSorted(const aContainer: IwbContainer): Boolean;
begin
  if Assigned(sraIsSorted) then
    Result := sraIsSorted(aContainer)
  else
    Result := sraSorted;
end;

procedure TwbSubRecordArrayDef.InitFromParentDoChildren;
begin
  inherited;
  if Assigned(sraElement) then
    (sraElement as IwbDefInternal).InitFromParent(Self);
end;

procedure TwbSubRecordArrayDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if Assigned(sraElement) then begin
    Parents := aParents;
    SetLength(Parents, Succ(Length(Parents)));
    Parents[High(Parents)].Def := Self;
    Parents[High(Parents)].Index := -1;
    sraElement.Report(Parents);
  end;

  defReported := True;
end;

function TwbSubRecordArrayDef.SetCountPath(const aValue: string): IwbSubRecordArrayDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordArrayDef(Duplicate).SetCountPath(aValue));

  Result := Self;
  sraCountPath := aValue;
end;

function TwbSubRecordArrayDef.ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  var CER: IwbContainerElementRef;
  if Supports(aElement, IwbContainerElementRef, CER) then begin
    var l := CER.ElementCount;
    if l > 0 then begin
      if l = 1 then begin
        var Element := CER.Elements[0];
        var RMD: IwbRecordMemberDef;
        if Supports(Element.Def, IwbRecordMemberDef, RMD) then
          Result := RMD.ToSummary(Succ(aDepth), Element, aLinksTo).Trim;
        if Result <> '' then
          Exit(Result);
      end;
      var s: string;
      if l = 1 then
        s := GetSummarySingularName
      else
        s := GetSummaryName;
      Result := '<' + l.ToString + ' ' + s.ToLower + '>';
    end;
  end;

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

function TwbSubRecordArrayDef.SetDefaultEditValues(const aValues: array of string): IwbSubRecordArrayDef;
var
  i: Integer;
begin
  if defIsLocked then
    Exit(TwbSubRecordArrayDef(Duplicate).SetDefaultEditValues(aValues));

  Result := Self;
  SetLength(sraDefaultEditValues, Length(aValues));
  for i := Low(aValues) to High(aValues) do
    sraDefaultEditValues[i] := aValues[i];
end;

function TwbSubRecordArrayDef.GetDefType: TwbDefType;
begin
  Result := dtSubRecordArray;
end;

function TwbSubRecordArrayDef.GetDefTypeName: string;
begin
  Result := 'SubRecordArray of '+GetElement.GetDefTypeName;
end;

{ TwbSubRecordStructDef }

function TwbSubRecordStructDef.AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;
begin
  Result := '';
end;

procedure TwbSubRecordStructDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbSubRecordStructDef do begin
    Self.srsSummaryKey := Copy(srsSummaryKey);
    Self.srsSummaryPrefix := Copy(srsSummaryPrefix);
    Self.srsSummarySuffix := Copy(srsSummarySuffix);
    Self.srsSummaryMaxDepth := Copy(srsSummaryMaxDepth);
    Self.srsSummaryDelimiter := srsSummaryDelimiter;
  end;
end;

procedure TwbSubRecordStructDef.AfterLoad(const aElement: IwbElement);
var
  Found     : Boolean;
  Container : IwbContainerElementRef;
  Element   : IwbElement;
  i, j      : Integer;
begin
  inherited;
  if wbReportMode and wbReportRequired and  Supports(aElement, IwbContainerElementRef, Container) then begin
    for i := 1 to High(srsMembers) do  if not srsMembers[i].IsNotRequired then begin
      Found := False;
      for j := 0 to Pred(Container.ElementCount) do begin
        Element := Container.Elements[j];
        if srsMembers[i].Equals(Element.Def) or srsMembers[i].Equals(Element.ValueDef) then begin
          Found := True;
          Break;
        end;
      end;
      srsMembers[i].PossiblyRequired;
      if not Found then
        srsMembers[i].NotRequired;
    end;
  end;
end;

function TwbSubRecordStructDef.AllowUnordered: Boolean;
begin
  Result := srsAllowUnordered;
end;

function TwbSubRecordStructDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  SubRecordStructDef : IwbSubRecordStructDef;
  RecordDef          : IwbRecordDef;
  i                  : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if Supports(aDef, IwbSubRecordStructDef, SubRecordStructDef) then begin
    Result := Equals(aDef);
    if not Result and
      Supports(aDef, IwbRecordDef, RecordDef) and
      (GetMemberCount = RecordDef.MemberCount)then begin
      Result := True;
      for i := 0 to Pred(GetMemberCount) do
        if not srsMembers[i].CanAssign(aElement, aIndex, RecordDef.Members[i]) then begin
          Result := False;
          Break;
        end;
    end;
  end else
    Result := False;
end;

function TwbSubRecordStructDef.CanHandle(const aContainer     : IwbContainerElementRef;
                                               aSignature     : TwbSignature;
                                         const aDataContainer : IwbDataContainer)
                                                              : Boolean;
begin
  if srsAllowUnordered or (dfAllowAnyMember in defFlags) then
    Result := ContainsMemberFor(aContainer, aSignature, aDataContainer)
  else
    Result := srsMembers[0].CanHandle(aContainer, aSignature, aDataContainer);
end;

constructor TwbSubRecordStructDef.Clone(const aSource: TwbDef);
var
  SkipSigs : TwbSignatures;
  i        : Integer;
begin
  with aSource as TwbSubRecordStructDef do begin
    if Assigned(srsSkipSignatures) then begin
      SetLength(SkipSigs, srsSkipSignatures.Count);
      for i := 0 to Pred(srsSkipSignatures.Count) do
        SkipSigs[i] := StrToSignature(srsSkipSignatures[i]);
    end;
    Self.Create(defPriority, defRequired, ndName, srsMembers, SkipSigs, ndDontShow, srsAllowUnordered, ndAfterLoad, ndAfterSet, defGetCP).AfterClone(aSource);
  end;
end;

function TwbSubRecordStructDef.ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                                       aSignature     : TwbSignature;
                                                 const aDataContainer : IwbDataContainer)
                                                                      : Boolean;
var
  Dummy: Integer;
begin
  Result := srsSignatures.Find(aSignature, Dummy);
end;

constructor TwbSubRecordStructDef.Create(aPriority       : TwbConflictPriority;
                                         aRequired       : Boolean;
                                   const aName           : string;
                                   const aMembers        : array of IwbRecordMemberDef;
                                   const aSkipSigs       : TwbSignatures;
                                         aDontShow       : TwbDontShowCallback;
                                         aAllowUnordered : Boolean;
                                         aAfterLoad      : TwbAfterLoadCallback;
                                         aAfterSet       : TwbAfterSetCallback;
                                         aGetCP          : TwbGetConflictPriority);
var
  FoundRequired : Boolean;
begin
  srsSummaryDelimiter := ' ';
  srsAllowUnordered := aAllowUnordered;
  srsSignatures := TwbFastStringListCS.CreateSorted(dupIgnore);

  FoundRequired := False;
  SetLength(srsMembers, Length(aMembers));
  var NewLength := 0;
  for var i := Low(aMembers) to High(aMembers) do
    if Assigned(aMembers[i]) then begin
      srsMembers[NewLength] := (aMembers[i] as IwbDefInternal).SetParent(Self, False) as IwbRecordMemberDef;
      FoundRequired := FoundRequired or (Assigned(srsMembers[i]) and srsMembers[i].Required);
      for var j := 0 to Pred(aMembers[i].SignatureCount) do
        srsSignatures.AddObject(aMembers[i].Signatures[j], Pointer(NewLength) );
      Inc(NewLength);
    end;
  SetLength(srsMembers, NewLength);

  if Length(aSkipSigs) > 0 then begin
    srsSkipSignatures := TwbFastStringListCS.CreateSorted(dupIgnore);
    for var i := Low(aSkipSigs) to High(aSkipSigs) do
      srsSkipSignatures.Add(aSkipSigs[i]);
  end;

  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;

destructor TwbSubRecordStructDef.Destroy;
begin
  inherited;
  FreeAndNil(srsSignatures);
  FreeAndNil(srsSkipSignatures);
end;

function TwbSubRecordStructDef.GetDefType: TwbDefType;
begin
  Result := dtSubRecordStruct;
end;

function TwbSubRecordStructDef.GetDefTypeName: string;
begin
  Result := 'SubRecordStruct';
end;

function TwbSubRecordStructDef.GetMember(aIndex: Integer): IwbRecordMemberDef;
begin
  Result := srsMembers[aIndex];
end;

function TwbSubRecordStructDef.GetMemberCount: Integer;
begin
  Result := Length(srsMembers);
end;

function TwbSubRecordStructDef.GetMemberFor(const aContainer     : IwbContainerElementRef;
                                                  aSignature     : TwbSignature;
                                            const aDataContainer : IwbDataContainer)
                                                                 : IwbRecordMemberDef;
var
  i: Integer;
begin
  if srsSignatures.Find(aSignature, i) then
    Result := srsMembers[Integer(srsSignatures.Objects[i])]
  else
    Result := nil;
end;

function TwbSubRecordStructDef.GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                                       aSignature     : TwbSignature;
                                                 const aDataContainer : IwbDataContainer)
                                                                      : Integer;
var
  i: Integer;
begin
  if srsSignatures.Find(aSignature, i) then
    Result := Integer(srsSignatures.Objects[i])
  else
    Result := -1;
end;

function TwbSubRecordStructDef.GetRecordHeaderStruct: IwbStructDef;
begin
  Result := wbMainRecordHeader as IwbStructDef;
end;

function TwbSubRecordStructDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  Result := nil;
  if dfDontAssign in defFlags then
    Exit;

  if (aIndex >= Low(srsMembers)) and (aIndex <= High(srsMembers)) then
    Exit(srsMembers[aIndex].GetAssignTemplates(aContainer, wbAssignThis));

  Result := inherited;
end;

function TwbSubRecordStructDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(srsMembers) to High(srsMembers) do
      if aChild.Equals(srsMembers[lIdx]) then
        Exit(lIdx);
end;

function TwbSubRecordStructDef.GetDefaultSignature: TwbSignature;
begin
  Result := srsMembers[0].GetDefaultSignature;
end;

function TwbSubRecordStructDef.GetSignatureCount: Integer;
begin
  if srsAllowUnordered or (dfAllowAnyMember in defFlags) then
    Result := srsSignatures.Count
  else
    Result := srsMembers[0].GetSignatureCount;
end;

function TwbSubRecordStructDef.GetSignature(const aIndex: Integer): TwbSignature;
begin
  if srsAllowUnordered or (dfAllowAnyMember in defFlags) then
    Result := StrToSignature(srsSignatures[aIndex])
  else
    Result := srsMembers[0].GetSignature(aIndex);
end;

function TwbSubRecordStructDef.GetSkipSignature(const aSignature: TwbSignature): Boolean;
var
  Dummy: Integer;
begin
  Result := Assigned(srsSkipSignatures) and srsSkipSignatures.Find(aSignature, Dummy);
end;

procedure TwbSubRecordStructDef.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(srsMembers) to High(srsMembers) do
    if Assigned(srsMembers[lMemberIdx]) then
      (srsMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
end;

procedure TwbSubRecordStructDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
  i       : Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  Parents := aParents;
  SetLength(Parents, Succ(Length(Parents)));
  Parents[High(Parents)].Def := Self;
  for i := Low(srsMembers) to High(srsMembers) do
    if Assigned(srsMembers[i]) then begin
      Parents[High(Parents)].Index := i;
      srsMembers[i].Report(Parents);
    end;

  defReported := True;
end;

function TwbSubRecordStructDef.SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbSubRecordStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordStructDef(Duplicate).SetIsRemovable(aCallback));

  Result := Self;
  ndIsRemovable := aCallback;
end;

function TwbSubRecordStructDef.SetSummaryDelimiter(const aDelimiter: string): IwbSubRecordStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordStructDef(Duplicate).SetSummaryDelimiter(aDelimiter));

  Result := Self;
  srsSummaryDelimiter := aDelimiter;
end;

function TwbSubRecordStructDef.SetSummaryKey(const aSummaryKey: array of Integer): IwbSubRecordStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordStructDef(Duplicate).SetSummaryKey(aSummaryKey));

  Result := Self;
  srsSummaryKey := nil;
  SetLength(srsSummaryKey, Length(aSummaryKey));
  for var i := Low(srsSummaryKey) to High(srsSummaryKey) do
    srsSummaryKey[i] := aSummaryKey[i];
end;

function TwbSubRecordStructDef.SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): IwbSubRecordStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordStructDef(Duplicate).SetSummaryMemberMaxDepth(aIndex, aMaxDepth));

  Result := Self;
  Assert(InRange(aIndex, Low(srsMembers), High(srsMembers)), '[TwbSubRecordStructDef.SetSummaryMemberMaxDepth] not InRange(aIndex, Low(srsMembers), High(srsMembers))');
  wbSetMaxDepth(aIndex, aMaxDepth, srsSummaryMaxDepth);
end;

function TwbSubRecordStructDef.SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): IwbSubRecordStructDef;
begin
  if defIsLocked then
    Exit(TwbSubRecordStructDef(Duplicate).SetSummaryMemberPrefixSuffix(aIndex, aPrefix, aSuffix));

  Result := Self;
  Assert(InRange(aIndex, Low(srsMembers), High(srsMembers)), '[TwbSubRecordStructDef.SetSummaryMemberPrefixSuffix] not InRange(aIndex, Low(srsMembers), High(srsMembers))');
  wbSetPrefixSuffix(aIndex, aPrefix, aSuffix, srsSummaryPrefix, srsSummarySuffix);
end;

function TwbSubRecordStructDef.ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  StructKeysToSummary(aDepth, Result, aElement, srsMembers, srsSummaryKey, srsSummaryPrefix, srsSummarySuffix, srsSummaryMaxDepth, srsSummaryDelimiter, aLinksTo);
end;

{ TwbSubRecordUnionDef }

function TwbSubRecordUnionDef.AdditionalInfoFor(const aMainRecord: IwbMainRecord): string;
begin
  Result := '';
end;

function TwbSubRecordUnionDef.AllowUnordered: Boolean;
begin
  Result := True;
end;

function TwbSubRecordUnionDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  SubRecordUnionDef : IwbSubRecordUnionDef;
  RecordDef         : IwbRecordDef;
  i                 : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if Assigned(sruDecider) then begin
    //???
  end;

  for i := Low(sruMembers) to High(sruMembers) do begin
    Result := sruMembers[i].CanAssign(aElement, aIndex, aDef);
    if Result = True then
      Exit;
  end;

  if Supports(aDef, IwbSubRecordUnionDef, SubRecordUnionDef) then begin
    Result := Equals(aDef);
    if not Result and
      Supports(aDef, IwbRecordDef, RecordDef) and
      (GetMemberCount = RecordDef.MemberCount)then begin
      Result := True;
      for i := 0 to Pred(GetMemberCount) do
        if not sruMembers[i].CanAssign(aElement, aIndex, RecordDef.Members[i]) then begin
          Result := False;
          Break;
        end;
    end;
  end else
    Result := False;
end;

function TwbSubRecordUnionDef.CanHandle(const aContainer     : IwbContainerElementRef;
                                              aSignature     : TwbSignature;
                                        const aDataContainer : IwbDataContainer)
                                                             : Boolean;
begin
  if Assigned(sruDecider) then begin
    var lDecidedMemberIdx := sruDecider(aContainer);
    if (lDecidedMemberIdx >= Low(sruMembers)) and
       (lDecidedMemberIdx <= High(sruMembers)) and
       sruMembers[lDecidedMemberIdx].CanHandle(aContainer, aSignature, aDataContainer)
    then
      Exit(True);
  end else
    for var lMemberIndx := Low(sruMembers) to High(sruMembers) do
      if sruMembers[lMemberIndx].CanHandle(aContainer, aSignature, aDataContainer) then
        Exit(True);
  Result := False;
end;

constructor TwbSubRecordUnionDef.Clone(const aSource: TwbDef);
var
  SkipSigs : TwbSignatures;
  i        : Integer;
begin
  with aSource as TwbSubRecordUnionDef do begin
    if Assigned(sruSkipSignatures) then begin
      SetLength(SkipSigs, sruSkipSignatures.Count);
      for i := 0 to Pred(sruSkipSignatures.Count) do
        SkipSigs[i] := StrToSignature(sruSkipSignatures[i]);
    end;
    Self.Create(defPriority, defRequired, ndName, sruMembers, SkipSigs, ndDontShow, defGetCP, sruDecider).AfterClone(aSource);
  end;
end;

function TwbSubRecordUnionDef.ContainsMemberFor(const aContainer     : IwbContainerElementRef;
                                                      aSignature     : TwbSignature;
                                                const aDataContainer : IwbDataContainer)
                                                                     : Boolean;
begin
  Result := CanHandle(aContainer, aSignature, aDataContainer);
end;

constructor TwbSubRecordUnionDef.Create(aPriority : TwbConflictPriority;
                                        aRequired : Boolean;
                                  const aName     : string;
                                  const aMembers  : array of IwbRecordMemberDef;
                                  const aSkipSigs : TwbSignatures;
                                  const aDontShow : TwbDontShowCallback;
                                  const aGetCP    : TwbGetConflictPriority;
                                  const aDecider  : TwbRUnionDecider);
var
  i,j: Integer;
begin
  sruSignatures := TwbFastStringListCS.CreateSorted(dupIgnore);
  sruDecider := aDecider;

  SetLength(sruMembers, Length(aMembers));
  for i := Low(sruMembers) to High(sruMembers) do begin
    sruMembers[i] := (aMembers[i] as IwbDefInternal).SetParent(Self, False) as IwbRecordMemberDef;
    for j := 0 to Pred(aMembers[i].SignatureCount) do
      sruSignatures.AddObject(aMembers[i].Signatures[j], Pointer(i));
  end;

  if Length(aSkipSigs) > 0 then begin
    sruSkipSignatures := TwbFastStringListCS.CreateSorted(dupIgnore);
    for i := Low(aSkipSigs) to High(aSkipSigs) do
      sruSkipSignatures.Add(aSkipSigs[i]);
  end;

  inherited Create(aPriority, aRequired, aName, nil, nil, aDontShow, aGetCP, False);
end;

destructor TwbSubRecordUnionDef.Destroy;
begin
  inherited;
  FreeAndNil(sruSignatures);
end;

function TwbSubRecordUnionDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  Result := nil;

  if dfDontAssign in defFlags then
    Exit(nil);

  if aIndex = wbAssignThis then begin
    if Assigned(sruDecider) then begin
      var lDecidedMemberIdx := sruDecider(aContainer);
      if (lDecidedMemberIdx >= Low(sruMembers)) and (lDecidedMemberIdx <= High(sruMembers)) then
        Result := [sruMembers[lDecidedMemberIdx]];
      Exit;
    end;

    SetLength(Result, Length(sruMembers));
    for var lMemberIndx := Low(sruMembers) to High(sruMembers) do
      Result[lMemberIndx] := sruMembers[lMemberIndx];
  end;
end;

function TwbSubRecordUnionDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(sruMembers) to High(sruMembers) do
      if aChild.Equals(sruMembers[lIdx]) then
        Exit(lIdx);
end;

function TwbSubRecordUnionDef.GetDefaultSignature: TwbSignature;
begin
  if Assigned(sruDecider) then begin
    //???
  end;

  Result := sruMembers[0].GetDefaultSignature;
end;

function TwbSubRecordUnionDef.GetDefType: TwbDefType;
begin
  Result := dtSubRecordUnion;
end;

function TwbSubRecordUnionDef.GetDefTypeName: string;
begin
  Result := 'SubRecordUnion';
end;

function TwbSubRecordUnionDef.GetMember(aIndex: Integer): IwbRecordMemberDef;
begin
  Result := sruMembers[aIndex];
end;

function TwbSubRecordUnionDef.GetMemberCount: Integer;
begin
  Result := Length(sruMembers);
end;

function TwbSubRecordUnionDef.GetMemberFor(const aContainer     : IwbContainerElementRef;
                                                 aSignature     : TwbSignature;
                                           const aDataContainer : IwbDataContainer)
                                                                : IwbRecordMemberDef;
begin
  if Assigned(sruDecider) then begin
    var lDecidedMemberIdx := sruDecider(aContainer);
    if (lDecidedMemberIdx >= Low(sruMembers)) and
       (lDecidedMemberIdx <= High(sruMembers)) and
       sruMembers[lDecidedMemberIdx].CanHandle(aContainer, aSignature, aDataContainer)
    then
      Exit(sruMembers[lDecidedMemberIdx]);
  end else
    for var lMemberIndx := Low(sruMembers) to High(sruMembers) do
      if sruMembers[lMemberIndx].CanHandle(aContainer, aSignature, aDataContainer) then
        Exit(sruMembers[lMemberIndx]);
  Result := nil;
end;

function TwbSubRecordUnionDef.GetMemberIndexFor(const aContainer     : IwbContainerElementRef;
                                                      aSignature     : TwbSignature;
                                                const aDataContainer : IwbDataContainer)
                                                                     : Integer;
begin
  if Assigned(sruDecider) then begin
    var lDecidedMemberIdx := sruDecider(aContainer);
    if (lDecidedMemberIdx >= Low(sruMembers)) and
       (lDecidedMemberIdx <= High(sruMembers)) and
       sruMembers[lDecidedMemberIdx].CanHandle(aContainer, aSignature, aDataContainer)
    then
      Exit(lDecidedMemberIdx);
  end else
    for var lMemberIndx := Low(sruMembers) to High(sruMembers) do
      if sruMembers[lMemberIndx].CanHandle(aContainer, aSignature, aDataContainer) then
        Exit(lMemberIndx);
  Result := -1;
end;

function TwbSubRecordUnionDef.GetRecordHeaderStruct: IwbStructDef;
begin
  Result := wbMainRecordHeader as IwbStructDef;
end;

function TwbSubRecordUnionDef.GetSignatureCount: Integer;
var
  i: Integer;
begin
  if Assigned(sruDecider) then begin
    //???
  end;

  Result := 0;
  for i := Low(sruMembers) to High(sruMembers) do
    Inc(Result, sruMembers[i].GetSignatureCount);
end;

function TwbSubRecordUnionDef.GetSignature(const aIndex: Integer): TwbSignature;
var
  i, j, k: Integer;
begin
  if Assigned(sruDecider) then begin
    //???
  end;

  j := aIndex;
  for i := Low(sruMembers) to High(sruMembers) do begin
    k := sruMembers[i].GetSignatureCount;
    if k > 0 then begin
      if j >= k then
        Dec(j, k)
      else begin
        Result := sruMembers[i].GetSignature(j);
        Exit;
      end;
    end;
  end;
  raise Exception.Create('Invalid index');
end;

function TwbSubRecordUnionDef.GetSkipSignature(const aSignature: TwbSignature): Boolean;
var
  Dummy: Integer;
begin
  Result := Assigned(sruSkipSignatures) and sruSkipSignatures.Find(aSignature, Dummy);
end;

procedure TwbSubRecordUnionDef.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(sruMembers) to High(sruMembers) do
    if Assigned(sruMembers[lMemberIdx]) then
      (sruMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
end;

procedure TwbSubRecordUnionDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
  i       : Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  Parents := aParents;
  SetLength(Parents, Succ(Length(Parents)));
  Parents[High(Parents)].Def := Self;
  for i := Low(sruMembers) to High(sruMembers) do
    if Assigned(sruMembers[i]) then begin
      Parents[High(Parents)].Index := i;
      sruMembers[i].Report(Parents);
    end;

  defReported := True;
end;

function wbReadInteger24(aBasePtr: pointer): Int64;
var
  Buffer : array[0..3] of Byte;
begin
  Result := 0;
  Buffer[3] := 0;
  Buffer[2] := PByte(aBasePtr)^; aBasePtr := PByte(aBasePtr) + 1;
  Buffer[1] := PByte(aBasePtr)^; aBasePtr := PByte(aBasePtr) + 1;
  Buffer[0] := PByte(aBasePtr)^;
  Move(Buffer, Result, SizeOf(Result));
end;

procedure WriteInteger24(aBasePtr: pointer; aValue: Int64);
var
  Buffer : array[0..3] of Byte;
begin
  Move(aValue, Buffer, SizeOf(aValue));
  PByte(aBasePtr)^ := Buffer[2]; aBasePtr := PByte(aBasePtr) + 1;
  PByte(aBasePtr)^ := Buffer[1]; aBasePtr := PByte(aBasePtr) + 1;
  PByte(aBasePtr)^ := Buffer[0];
end;

function ReadIntegerCounterSize(aBasePtr: pointer): Int64;
var
  Key : Byte;
begin
  if Assigned(aBasePtr) then begin
    Key := $3 and PByte(aBasePtr)^; // The counter length is coded into the 2 least significant bits
    case key of
      0: Result := 1;
      1: Result := 2;
      2: Result := 4;
    else
      Result := 1;
    end
  end else
    Result := 1; // Minimum size
end;

function ReadIntegerCounter(aBasePtr: pointer): Int64;
var
  Key    : Byte;
begin
  Result := 0;
  if Assigned(aBasePtr) then begin
    Key := $3 and PByte(aBasePtr)^; // The counter length is coded into the 2 least significant bits
    case key of
      0: Move(PByte(aBasePtr)^,     Result, 1); // The 6 remaining bits are the count.
      1: Move(PWord(aBasePtr)^,     Result, 2); // 6 + 8 bits of count
      2: Move(PCardinal(aBasePtr)^, Result, 4); // 6 + 24 bits of count
      3: ; // Not supposed to exist : zeroed out by the engine
    end;
    Result := Result shr 2;
  end;
end;

procedure WriteIntegerCounter(aBasePtr: pointer; aValue: Int64);
var
  Buffer : array[0..3] of Byte;
begin
  if Assigned(aBasePtr) then begin
    Move(aValue, Buffer, SizeOf(aValue));
    if Buffer[3] > 0 then begin // 4 bytes counter
      Buffer[3] := (Buffer[3] shl 2 ) or 3;
      PByte(aBasePtr)^ := Buffer[3]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[2]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[1]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[0];
    end else if Buffer[2] > 0 then begin
      Buffer[2] := (Buffer[3] shl 2 ) or 2;
      PByte(aBasePtr)^ := Buffer[2]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[1]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[0];
    end else if Buffer[1] > 0 then begin
      Buffer[1] := (Buffer[1] shl 2 ) or 1;
      PByte(aBasePtr)^ := Buffer[1]; aBasePtr := PByte(aBasePtr) + 1;
      PByte(aBasePtr)^ := Buffer[0];
    end else begin
      Buffer[0] := (Buffer[0] shl 2 ) or 0;
      PByte(aBasePtr)^ := Buffer[0];
    end;
  end;
end;

{ TwbIntegerDef }

function TwbIntegerDef.AddOverlay(const aCallback: TwbIntOverlayCallback): IwbIntegerDef;
begin
  if defIsLocked then
    Exit(TwbIntegerDef(Duplicate).AddOverlay(aCallback));

  Result := Self;
  inOverlayCallback := aCallback;
end;

procedure TwbIntegerDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  inOverlayCallback := TwbIntegerDef(aSource).inOverlayCallback;
end;

function TwbIntegerDef.Assign(const aTarget : IwbElement;
                                    aIndex  : Integer;
                              const aSource : IwbElement;
                                    aOnlySK : Boolean)
                                            : IwbElement;
begin
  if Assigned(inFormater) then
    Result := inFormater.Assign(aTarget, aIndex, aSource, aOnlySK)
  else
    Result := inherited Assign(aTarget, aIndex, aSource, aOnlySK)
end;

procedure TwbIntegerDef.BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
var
  Value       : Int64;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  if Assigned(inFormater) then
    if Int64(NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) >= GetExpectedLength then begin
      case inType of
        itU8:  Value := PByte(aBasePtr)^;
        itS8:  Value := PShortInt(aBasePtr)^;
        itU16: Value := PWord(aBasePtr)^;
        itS16: Value := PSmallInt(aBasePtr)^;
        itU24: Value := wbReadInteger24(aBasePtr);
        itU32: Value := PCardinal(aBasePtr)^;
        itS32: Value := PLongInt(aBasePtr)^;
        itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
        itS64: Value := PInt64(aBasePtr)^;
        itU6to30: Value := ReadIntegerCounter(aBasePtr);
      else
        {it0:}  Value := 0;
      end;

      if Assigned(inOverlayCallback) then
        Value := inOverlayCallback(Value, aElement, ctBuildRef);

      inFormater.BuildRef(Value, aElement);
    end;
end;

function TwbIntegerDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  IntegerDef : IwbIntegerDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbIntegerDef, IntegerDef);
  if Result then begin
    if Assigned(inFormater) then
      Result := inFormater.CanAssign(aElement, aIndex, IntegerDef.Formater[aElement])
    else if Assigned(IntegerDef.Formater[aElement]) then
      Result := IntegerDef.Formater[aElement].CanAssign(aElement, aIndex, GetFormater(aElement));
  end else
    if Assigned(inFormater) then
      Result := inFormater.CanAssign(aElement, aIndex, aDef);
end;

function TwbIntegerDef.Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  Len         : Int64;
  Value       : Int64;
begin
  Result := '';
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len < GetExpectedLength then begin
    if wbCheckExpectedBytes then
      Result := Format('Expected %d bytes of data, found %d', [GetExpectedLength , Len])
  end else begin
    case inType of
      itU8:  Value := PByte(aBasePtr)^;
      itS8:  Value := PShortInt(aBasePtr)^;
      itU16: Value := PWord(aBasePtr)^;
      itS16: Value := PSmallInt(aBasePtr)^;
      itU24: Value := wbReadInteger24(aBasePtr);
      itU32: Value := PCardinal(aBasePtr)^;
      itS32: Value := PLongInt(aBasePtr)^;
      itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
      itS64: Value := PInt64(aBasePtr)^;
      itU6to30: Value := ReadIntegerCounter(aBasePtr);
    else
      {itU0:}  Value := 0;
    end;

    if Assigned(inOverlayCallback) then
      Value := inOverlayCallback(Value, aElement, ctCheck);

    if Assigned(inFormater) then
      Result := inFormater.Check(Value, aElement)
    else
      Result := '';
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctCheck);
end;

constructor TwbIntegerDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbIntegerDef do
    Self.Create(defPriority, defRequired, ndName, inType, inFormater, ndDontShow, ndAfterSet, inDefault, defGetCP, ndTerminator).AfterClone(aSource);
end;

function TwbIntegerDef.CompareExchangeFormID(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aOldFormID, aNewFormID: TwbFormID): Boolean;
var
  i: Int64;
begin
  if Assigned(inFormater) then begin
    i := ToInt(aBasePtr, aEndPtr, aElement);
    Result := inFormater.CompareExchangeFormID(i, aOldFormID, aNewFormID, aElement);
    if Result then
      FromInt(i, aBasePtr, aEndPtr, aElement);
  end else
    Result := inherited CompareExchangeFormID(aBasePtr, aEndPtr, aElement, aOldFormID, aNewFormID);
end;

constructor TwbIntegerDef.Create(aPriority   : TwbConflictPriority;
                                 aRequired   : Boolean;
                           const aName       : string;
                           const aIntType    : TwbIntType;
                           const aFormater   : IwbIntegerDefFormater;
                                 aDontShow   : TwbDontShowCallback;
                                 aAfterSet   : TwbAfterSetCallback;
                                 aDefault    : Int64;
                                 aGetCP      : TwbGetConflictPriority;
                                 aTerminator : Boolean);
begin
  inDefault := aDefault;
  inType := aIntType;
  if Assigned(aFormater) then
    inFormater := (aFormater as IwbDefInternal).SetParent(Self, False) as IwbIntegerDefFormater;
  inherited Create(aPriority, aRequired, aName, nil, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

procedure TwbIntegerDef.FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters);
begin
  if Assigned(inFormater) then
    inFormater.FindUsedMasters(ToInt(aBasePtr, aEndPtr, aElement), aMasters, aElement)
  else
    inherited FindUsedMasters(aBasePtr, aEndPtr, aElement, aMasters);
end;

procedure TwbIntegerDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
var
  i: Int64;
begin
  if aValue = '' then
    i := 0
  else if Assigned(inFormater) then
    i := inFormater.FromEditValue(aValue, aElement)
  else
    i := StrToInt64(aValue);

  if Assigned(inOverlayCallback) then
    i := inOverlayCallback(i, aElement, ctFromEditValue);

  FromInt(i, aBasePtr, aEndPtr, aElement);
end;

procedure TwbIntegerDef.FromInt(aValue: Int64; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
var
  Value: Int64;
begin
  if Assigned(inOverlayCallback) then
    Value := inOverlayCallback(aValue, aElement, ctFromInt)
  else
    Value := aValue;

  aElement.RequestStorageChange(aBasePtr, aEndPtr, GetExpectedLength(aValue));
  case inType of
    itU8:  PByte(aBasePtr)^ := Value;
    itS8:  PShortInt(aBasePtr)^ := Value;
    itU16: PWord(aBasePtr)^ := Value;
    itS16: PSmallInt(aBasePtr)^ := Value;
    itU24: WriteInteger24(aBasePtr, Value);
    itU32: PCardinal(aBasePtr)^ := Value;
    itS32: PLongInt(aBasePtr)^ := Value;
    itU64: PUInt64(aBasePtr)^ := Value;
    itS64: PInt64(aBasePtr)^ := Value;
    itU6to30: WriteIntegerCounter(aBasePtr, Value);
  else
    {it0: }
  end;
end;

procedure TwbIntegerDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
var
  Value: Variant;
begin
  if Assigned(inOverlayCallback) then
    Value := inOverlayCallback(aValue, aElement, ctFromNativeValue)
  else
    Value := aValue;

  aElement.RequestStorageChange(aBasePtr, aEndPtr, GetExpectedLength(Value));

  case inType of
    itS8:  PShortInt(aBasePtr)^ := Value;
    itU16: PWord(aBasePtr)^ := Value;
    itS16: PSmallInt(aBasePtr)^ := Value;
    itU24: WriteInteger24(aBasePtr, Value);
    itU32: PCardinal(aBasePtr)^ := Value;
    itS32: PLongInt(aBasePtr)^ := Value;
    itU64: PUInt64(aBasePtr)^ := Value;
    itS64: PInt64(aBasePtr)^ := Value;
    itU6to30: WriteIntegerCounter(aBasePtr, Value);
  else
    PByte(aBasePtr)^ := Value;
  end;
end;

function TwbIntegerDef.GetDefType: TwbDefType;
begin
  Result := dtInteger;
end;

function TwbIntegerDef.GetDefTypeName: string;
begin
  if Assigned(inFormater) then
    Result := inFormater.GetDefTypeName
  else case inType of
    itS8:  Result := 'Signed Byte';
    itU16: Result := 'Unsigned Word';
    itS16: Result := 'Signed Word';
    itU24: Result := 'RefID';
    itU32: Result := 'Unsigned DWord';
    itS32: Result := 'Signed DWord';
    itU64: Result := 'Unsigned QWord';
    itS64: Result := 'Signed QWord';
    itU6to30: Result := 'Counter';
  else
    Result := 'Unsigned Byte';
  end;
end;

function TwbIntegerDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
begin
  if Assigned(inFormater) then
    Result := inFormater.EditInfo[aElement]
  else
    Result := inherited GetEditInfo(aBasePtr, aEndPtr, aElement);
end;

function TwbIntegerDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
begin
  if Assigned(inFormater) then
    Result := inFormater.EditType[aElement]
  else
    Result := inherited GetEditType(aBasePtr, aEndPtr, aElement);
end;

function TwbIntegerDef.GetExpectedLength(aValue: Int64 = 0): Integer;
const
  ExpectedLen : array[TwbIntType] of Integer = (
    0, 1, 1, 2, 2, 4, 4, 8, 8, 3, 1
  );
begin
  if inType = it0  then
    Result := 0
  else begin
    Result := ExpectedLen[inType]+Ord(ndTerminator);
    if (inType=itU6to30) and (aValue<>0) then
      case (aValue and 3) of
        0 : Result := 1 + Ord(ndTerminator);
        1 : Result := 2 + Ord(ndTerminator);
        2 : Result := 4 + Ord(ndTerminator);
      end;
  end;
end;

function TwbIntegerDef.GetFormater(const aElement: IwbElement): IwbIntegerDefFormater;
var
  Union: IwbIntegerDefFormaterUnion;
begin
  Result := inFormater;
  while Supports(Result, IwbIntegerDefFormaterUnion, Union) do
    Result := Union.Decide(aElement);
end;

function TwbIntegerDef.GetFormaterCanChange: Boolean;
begin
  Result := Supports(inFormater, IwbIntegerDefFormaterUnion);
end;

function TwbIntegerDef.GetIntType: TwbIntType;
begin
  Result := inType;
end;

function TwbIntegerDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := wbIsInternalEdit or (not Assigned(inFormater) or inFormater.IsEditable[ToInt(aBasePtr, aEndPtr, aElement), aElement]);
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbIntegerDef.GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement;
var
  Value       : Int64;
begin
  if Assigned(vdLinksToCallback) then
    Exit(vdLinksToCallback(aElement));

  Result := nil;
  if Assigned(inFormater) then
    if Int64(NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) >= GetExpectedLength then begin
      case inType of
        itU8:  Value := PByte(aBasePtr)^;
        itS8:  Value := PShortInt(aBasePtr)^;
        itU16: Value := PWord(aBasePtr)^;
        itS16: Value := PSmallInt(aBasePtr)^;
        itU24: Value := wbReadInteger24(aBasePtr);
        itU32: Value := PCardinal(aBasePtr)^;
        itS32: Value := PLongInt(aBasePtr)^;
        itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
        itS64: Value := PInt64(aBasePtr)^;
        itU6to30: Value := ReadIntegerCounter(aBasePtr);
      else
        {it0:}  Value := 0;
      end;

      if Assigned(inOverlayCallback) then
        Value := inOverlayCallback(Value, aElement, ctLinksTo);

      Result := inFormater.LinksTo[Value, aElement];
    end;
end;

function TwbIntegerDef.GetNoReach: Boolean;
begin
  Result := Assigned(inFormater) and inFormater.NoReach;
end;

function TwbIntegerDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if inType = it0 then
    Result := 0
  else if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aBasePtr) < NativeUInt(aEndPtr)) then
    case inType of
      itU8:  Result := SizeOf(Byte)+Ord(ndTerminator);
      itS8:  Result := SizeOf(ShortInt)+Ord(ndTerminator);
      itU16: Result := SizeOf(Word)+Ord(ndTerminator);
      itS16: Result := SizeOf(SmallInt)+Ord(ndTerminator);
      itU24: Result := 3*SizeOf(Byte)+Ord(ndTerminator);
      itU32: Result := SizeOf(Cardinal)+Ord(ndTerminator);
      itS32: Result := SizeOf(LongInt)+Ord(ndTerminator);
      itU64: Result := SizeOf(UInt64)+Ord(ndTerminator);
      itS64: Result := SizeOf(Int64)+Ord(ndTerminator);
      itU6to30: Result := ReadIntegerCounterSize(aBasePtr)+Ord(ndTerminator);
    else
      Result := 0;
    end
  else
    Result := GetDefaultSize(aBasePtr, aEndPtr, aElement);
end;

function TwbIntegerDef.IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue: Boolean): IwbValueDef;
begin
  if Assigned(inFormater) then
    inFormater.IncludeFlag(aFlag, aOnlyWhenTrue);
  Result := inherited IncludeFlag(aFlag, aOnlyWhenTrue);
end;

procedure TwbIntegerDef.InitFromParentDoChildren;
begin
  inherited;
  if Assigned(inFormater) then
    (inFormater as IwbDefInternal).InitFromParent(Self);
end;

function TwbIntegerDef.GetConflictPriority(const aElement: IwbElement): TwbConflictPriority;
begin
  if Assigned(inFormater) then
    if inFormater.ConflictPriorityCanChange then
      Exit(inFormater.GetConflictPriority(aElement));

  Result := inherited;
end;

function TwbIntegerDef.GetConflictPriorityCanChange: Boolean;
begin
  Result := inherited;
  if not Result and Assigned(inFormater) then
    Result := inFormater.ConflictPriorityCanChange;
end;

function TwbIntegerDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  case inType of
    itU8:  Result := SizeOf(Byte)+Ord(ndTerminator);
    itS8:  Result := SizeOf(ShortInt)+Ord(ndTerminator);
    itU16: Result := SizeOf(Word)+Ord(ndTerminator);
    itS16: Result := SizeOf(SmallInt)+Ord(ndTerminator);
    itU24: Result := 3*SizeOf(Byte)+Ord(ndTerminator);
    itU32: Result := SizeOf(Cardinal)+Ord(ndTerminator);
    itS32: Result := SizeOf(LongInt)+Ord(ndTerminator);
    itU64: Result := SizeOf(UInt64)+Ord(ndTerminator);
    itS64: Result := SizeOf(Int64)+Ord(ndTerminator);
    itU6to30: Result := 1+Ord(ndTerminator);
  else
    {it0:} Result := 0;
  end;
end;

function TwbIntegerDef.MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean;
var
  OldValue : Int64;
  NewValue : Int64;
begin
  if Assigned(inFormater) then begin
    OldValue := ToInt(aBasePtr, aEndPtr, aElement);
    NewValue := inFormater.MastersUpdated(OldValue, aOld, aNew, aOldCount, aNewCount, aElement);
    Result := OldValue <> NewValue;
    if Result then
      FromInt(NewValue, aBasePtr, aEndPtr, aElement)
  end else
    Result := inherited MastersUpdated(aBasePtr, aEndPtr, aElement, aOld, aNew, aOldCount, aNewCount);
end;

procedure TwbIntegerDef.ReplaceFormater(const aFormater: IwbIntegerDefFormater);
begin
  defSource := nil;
  if Assigned(aFormater) then
    inFormater := (aFormater as IwbDefInternal).SetParent(Self, True) as IwbIntegerDefFormater
  else
    inFormater := nil
end;

procedure TwbIntegerDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if Assigned(inFormater) then begin
    Parents := aParents;
    SetLength(Parents, Succ(Length(Parents)));
    Parents[High(Parents)].Def := Self;
    Parents[High(Parents)].Index := -1;
    inFormater.Report(aParents);
  end;

  defReported := True;
end;

function TwbIntegerDef.SetDefaultNativeValue(const aValue: Variant): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbIntegerDef(Duplicate).SetDefaultNativeValue(aValue));

  Result := Self;
  inDefault := aValue;
end;

procedure TwbIntegerDef.SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement, aValue: IwbElement);
var
  i: Int64;
begin
  i := 0;
  if Assigned(inFormater) then
    i := inFormater.FromLinksTo(aValue, aElement)
  else if Assigned(aValue) then begin
    inherited; //raises exception
    Exit;
  end;

  if Assigned(inOverlayCallback) then
    i := inOverlayCallback(i, aElement, ctFromEditValue);

  FromInt(i, aBasePtr, aEndPtr, aElement);
end;

function TwbIntegerDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultEditValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToEditValue(aBasePtr, aEndPtr, aElement) <> vdDefaultEditValue);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, vdDefaultEditValue);
  end else begin
    Result := not Assigned(aBasePtr) or (ToInt(aBasePtr, aEndPtr, aElement) <> inDefault);
    if Result then
      FromInt(inDefault, aBasePtr, aEndPtr, aElement);
  end;
end;

function IntToHex64(Value: Int64; Digits: Integer): string;
begin
  Result := IntToHex(Value, Digits);
end;


function TwbIntegerDef.ToEditValue(aBasePtr, aEndPtr: Pointer;
  const aElement: IwbElement): string;
var
  Len   : Int64;
  Value : Int64;
const
  PlusMinus : array[Boolean] of string = ('+', '-');
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if (Len < GetExpectedLength) or (inType = it0) then
    Result := ''
  else begin
    case inType of
      itU8:  Value := PByte(aBasePtr)^;
      itS8:  Value := PShortInt(aBasePtr)^;
      itU16: Value := PWord(aBasePtr)^;
      itS16: Value := PSmallInt(aBasePtr)^;
      itU24: Value := wbReadInteger24(aBasePtr);
      itU32: Value := PCardinal(aBasePtr)^;
      itS32: Value := PLongInt(aBasePtr)^;
      itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
      itS64: Value := PInt64(aBasePtr)^;
      itU6to30: Value := ReadIntegerCounter(aBasePtr);
    else
      {it0:}  Value := 0;
    end;

    if Assigned(inOverlayCallback) then
      Value := inOverlayCallback(Value, aElement, ctToEditValue);

    Result := '';
    if Assigned(inFormater) then
      Result := inFormater.ToEditValue(Value, aElement);

    if Result = '' then
      Result := IntToStr(Value);
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbIntegerDef.ToInt(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Int64;
var
  Len         : Int64;
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len < GetExpectedLength then
    Result := 0
  else
    case inType of
      itU8:  Result := PByte(aBasePtr)^;
      itS8:  Result := PShortInt(aBasePtr)^;
      itU16: Result := PWord(aBasePtr)^;
      itS16: Result := PSmallInt(aBasePtr)^;
      itU24: Result := wbReadInteger24(aBasePtr);
      itU32: Result := PCardinal(aBasePtr)^;
      itS32: Result := PLongInt(aBasePtr)^;
      itU64: Result := PUInt64(aBasePtr)^; //no U64 in delphi...
      itS64: Result := PInt64(aBasePtr)^;
      itU6to30: Result := ReadIntegerCounter(aBasePtr);
    else
      {it0:}  Result := 0;
    end;

  if Assigned(inOverlayCallback) then
    Result := inOverlayCallback(Result, aElement, ctToInt);
end;

function TwbIntegerDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
var
  i: Int64;
begin
  if Int64(NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) < GetExpectedLength then
    VarClear(Result)
  else
    if Assigned(inOverlayCallback) then begin

      case inType of
        itU8:  i := PByte(aBasePtr)^;
        itS8:  i := PShortInt(aBasePtr)^;
        itU16: i := PWord(aBasePtr)^;
        itS16: i := PSmallInt(aBasePtr)^;
        itU24: i := wbReadInteger24(aBasePtr);
        itU32: i := PCardinal(aBasePtr)^;
        itS32: i := PLongInt(aBasePtr)^;
        itU64: i := PUInt64(aBasePtr)^; //no U64 in delphi...
        itS64: i := PInt64(aBasePtr)^;
        itU6to30: i := ReadIntegerCounter(aBasePtr);
      else
        {it0:}  i := 0;
      end;

      i := inOverlayCallback(i, aElement, ctToNativeValue);

      case inType of
        itU8:  Result := Byte(i);
        itS8:  Result := ShortInt(i);
        itU16: Result := Word(i);
        itS16: Result := SmallInt(i);
        itU24: Result := i;
        itU32: Result := Cardinal(i);
        itS32: Result := LongInt(i);
        itU64: Result := UInt64(i); //no U64 in delphi...
        itS64: Result := Int64(i);
        itU6to30: Result := i;
      else
        {it0:}  Result := 0;
      end;

    end else
      case inType of
        itU8:  Result := PByte(aBasePtr)^;
        itS8:  Result := PShortInt(aBasePtr)^;
        itU16: Result := PWord(aBasePtr)^;
        itS16: Result := PSmallInt(aBasePtr)^;
        itU24: Result := wbReadInteger24(aBasePtr);
        itU32: Result := PCardinal(aBasePtr)^;
        itS32: Result := PLongInt(aBasePtr)^;
        itU64: Result := PUInt64(aBasePtr)^; //no U64 in delphi...
        itS64: Result := PInt64(aBasePtr)^;
        itU6to30: Result := ReadIntegerCounter(aBasePtr);
      else
        {it0:}  Result := 0;
      end;
end;

function TwbIntegerDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
var
  Len   : Int64;
  Value : Int64;
const
  PlusMinus : array[Boolean] of string = ('+', '-');
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len < GetExpectedLength then
    if Assigned(inFormater) and inFormater.RequiresKey then
      Result := inFormater.ToSortKey(0, aElement)
    else
      Result := ''
  else begin
    case inType of
      itU8:  Value := PByte(aBasePtr)^;
      itS8:  Value := PShortInt(aBasePtr)^;
      itU16: Value := PWord(aBasePtr)^;
      itS16: Value := PSmallInt(aBasePtr)^;
      itU24: Value := wbReadInteger24(aBasePtr);
      itU32: Value := PCardinal(aBasePtr)^;
      itS32: Value := PLongInt(aBasePtr)^;
      itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
      itS64: Value := PInt64(aBasePtr)^;
      itU6to30: Value := ReadIntegerCounter(aBasePtr);
    else
      {it0:}  Value := 0;
    end;

    if Assigned(inOverlayCallback) then
      Value := inOverlayCallback(Value, aElement, ctToSortKey);

    Result := '';
    if Assigned(inFormater) then
      Result := inFormater.ToSortKey(Value, aElement);

    if Result = '' then begin
      case inType of
        itS8:  Value := Value + Abs(Int64(Low(ShortInt)));
        itS16: Value := Value + Abs(Int64(Low(SmallInt)));
        itS32: Value := Value + Abs(Int64(Low(LongInt)));
        itS64: Value := Value + Abs(Int64(Low(Int64)));
      end;
      Result := Result + IntToHex64(Value, Succ(GetExpectedLength(Value) * 2));
    end;
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbIntegerDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  Len         : Int64;
  Value       : Int64;
begin
  Result := '';

  if inType = it0 then
    Exit;

  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len < GetExpectedLength then begin
    if wbCheckExpectedBytes then
      Result := Format('<Error: Expected %d bytes of data, found %d>', [GetExpectedLength, Len])
  end else begin
    case inType of
      itU8:  Value := PByte(aBasePtr)^;
      itS8:  Value := PShortInt(aBasePtr)^;
      itU16: Value := PWord(aBasePtr)^;
      itS16: Value := PSmallInt(aBasePtr)^;
      itU24: Value := wbReadInteger24(aBasePtr);
      itU32: Value := PCardinal(aBasePtr)^;
      itS32: Value := PLongInt(aBasePtr)^;
      itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
      itS64: Value := PInt64(aBasePtr)^;
      itU6to30: Value := ReadIntegerCounter(aBasePtr);
    else
      {it0:}  Value := 0;
    end;

    if Assigned(inOverlayCallback) then
      Value := inOverlayCallback(Value, aElement, ctToStr);

    if Assigned(inFormater) then
      Result := inFormater.ToString(Value, aElement, False)
    else
      Result := IntToStr(Value);

    if (Len > GetExpectedLength) and not (inType in [itU6to30]) then begin
      if wbCheckExpectedBytes then
        Result := Result + Format(' <Warning: Expected %d bytes of data, found %d>', [GetExpectedLength , Len])
    end;
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);

  Used(aElement, Result);
end;

function TwbIntegerDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
var
  Len         : Int64;
  Value       : Int64;
begin
  Result := '';

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);

  if Result = '' then begin
    if inType = it0 then
      Exit;

    Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
    if Len < GetExpectedLength then begin
      if wbCheckExpectedBytes then
        Result := Format('<Error: Expected %d bytes of data, found %d>', [GetExpectedLength, Len])
    end else begin
      case inType of
        itU8:  Value := PByte(aBasePtr)^;
        itS8:  Value := PShortInt(aBasePtr)^;
        itU16: Value := PWord(aBasePtr)^;
        itS16: Value := PSmallInt(aBasePtr)^;
        itU24: Value := wbReadInteger24(aBasePtr);
        itU32: Value := PCardinal(aBasePtr)^;
        itS32: Value := PLongInt(aBasePtr)^;
        itU64: Value := PUInt64(aBasePtr)^; //no U64 in delphi...
        itS64: Value := PInt64(aBasePtr)^;
        itU6to30: Value := ReadIntegerCounter(aBasePtr);
      else
        {it0:}  Value := 0;
      end;

      if Assigned(inOverlayCallback) then
        Value := inOverlayCallback(Value, aElement, ctToSummary);

      if Assigned(inFormater) then
        Result := inFormater.ToString(Value, aElement, True)
      else
        Result := IntToStr(Value);

      if (Len > GetExpectedLength) and not (inType in [itU6to30]) then begin
        if wbCheckExpectedBytes then
          Result := Result + Format(' <Warning: Expected %d bytes of data, found %d>', [GetExpectedLength , Len])
      end;
    end;
  end;

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;

  Used(aElement, Result);
end;

{ TwbArrayDef }

constructor TwbArrayDef.Create(aPriority   : TwbConflictPriority;
                               aRequired   : Boolean;
                         const aName       : string;
                         const aElement    : IwbValueDef;
                               aCount      : Integer;
                         const aLabels     : array of string;
                               aSorted     : Boolean;
                               aAfterLoad  : TwbAfterLoadCallback;
                               aAfterSet   : TwbAfterSetCallback;
                               aDontShow   : TwbDontShowCallback;
                               aGetCP      : TwbGetConflictPriority;
                               aCanAddTo   : Boolean;
                               aTerminator : Boolean;
                               aTerminated : Boolean);
var
  i: Integer;
begin
  if wbNeverSorted then
    aSorted := False;

  arSummaryPassthroughMaxCount := -1;
  arSummaryPassthroughMaxLength := -1;
  arSummaryPassthroughMaxDepth := -1;
  arSummaryDelimiter := ', ';

  Assert((not aSorted) or (Length(aLabels) < 1));

  SetLength(arLabels, Length(aLabels));
  for i := Low(arLabels) to High(arLabels) do
    arLabels[i] := aLabels[i];

  arCount := aCount;
  if Assigned(aElement) then
    arElement := (aElement as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
  arSorted := aSorted;
  arCanAddTo := aCanAddTo;
  arTerminated := aTerminated;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

procedure TwbArrayDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbArrayDef do begin
    Self.arSummaryDelimiter := arSummaryDelimiter;
    Self.arSummaryPassthroughMaxCount := arSummaryPassthroughMaxCount;
    Self.arSummaryPassthroughMaxLength := arSummaryPassthroughMaxLength;
    Self.arSummaryPassthroughMaxDepth := arSummaryPassthroughMaxDepth;
    Self.arDefaultEditValues := arDefaultEditValues;
    Self.arCountPath := arCountPath;
    Self.arShouldInclude := arShouldInclude;
    Self.arWronglyAssumedFixedSizePerElement := arWronglyAssumedFixedSizePerElement;
  end;
end;

function TwbArrayDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  ArrayDef: IwbArrayDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := (aIndex = Low(Integer)) and
    Supports(aDef, IwbArrayDef, ArrayDef) and
    ( ( arCount <= 0 ) or (arCount = ArrayDef.ElementCount) ) and
    arElement.CanAssign(aElement, aIndex, ArrayDef.Element);
end;

constructor TwbArrayDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbArrayDef do
    if Assigned(arCountCallback) then
      Self.Create(defPriority, defRequired, ndName, arElement, arCountCallback,
        arLabels, arSorted, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP, arCanAddTo, ndTerminator, arTerminated).AfterClone(aSource)
    else
      Self.Create(defPriority, defRequired, ndName, arElement, arCount,
        arLabels, arSorted, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP, arCanAddTo, ndTerminator, arTerminated).AfterClone(aSource);
end;

constructor TwbArrayDef.Create(aPriority      : TwbConflictPriority;
                               aRequired      : Boolean;
                         const aName          : string;
                         const aElement       : IwbValueDef;
                               aCountCallback : TwbCountCallback;
                         const aLabels        : array of string;
                               aSorted        : Boolean;
                               aAfterLoad     : TwbAfterLoadCallback;
                               aAfterSet      : TwbAfterSetCallback;
                               aDontShow      : TwbDontShowCallback;
                               aGetCP         : TwbGetConflictPriority;
                               aCanAddTo      : Boolean;
                               aTerminator    : Boolean;
                               aTerminated    : Boolean);
begin
  arCountCallback := aCountCallback;
  Create(aPriority, aRequired, aName, aElement, 0, aLabels, aSorted, aAfterLoad, aAfterSet, aDontShow, aGetCP, aCanAddTo, aTerminator, aTerminated);
end;

function TwbArrayDef.GetCanAddTo: Boolean;
begin
  Result := arCanAddTo
    and not (dfArrayStaticSize in DefFlags);
end;

function TwbArrayDef.GetCanBeZeroSize: Boolean;
begin
  Result := True;
end;

function TwbArrayDef.GetCount: Integer;
begin
  Result := arCount;
end;

function TwbArrayDef.GetCountCallBack: TwbCountCallback;
begin
  Result := arCountCallBack;
end;

function TwbArrayDef.GetCountPath: string;
begin
  Result := arCountPath;
end;

function TwbArrayDef.GetDefType: TwbDefType;
begin
  Result := dtArray;
end;

function TwbArrayDef.GetDefTypeName: string;
var
  Prefix: Integer;
begin
  if arCount < 0 then begin
    if arCount < -1 then
      if arCount < -2 then
        Prefix := 1
      else
        Prefix := 2
    else
      Prefix := 4;
    if ndTerminator then
      Result := 'Separated Array with '+IntToStr(Prefix)+' Bytes Counter of '
    else
      Result := 'Array with '+IntToStr(Prefix)+' Bytes Counter of ';
  end else begin
    if (arCount < 1) and Assigned(arCountCallback) then
      if ndTerminator then
        Result := 'Separated Variable Count Array'
      else
        Result := 'Variable Count Array'
    else if arCount > 0 then
      if ndTerminator then
        Result := 'Separated Array of '+IntToStr(arCount)+' '
      else
        Result := 'Array of '+IntToStr(arCount)+' '
    else
      if ndTerminator then
          Result := 'Separated Array of '
      else
        Result := 'Array of ';
  end;
  Result := Result + GetElement.GetDefTypeName;
end;

function TwbArrayDef.GetElement: IwbValueDef;
begin
  Result := arElement;
end;

function TwbArrayDef.GetElementLabel(aIndex: Integer): string;
begin
  if (aIndex >= Low(arLabels)) and (aIndex <= High(arLabels)) then
    Result := arLabels[aIndex]
  else
    Result := '';
end;

function TwbArrayDef.GetElementNameSuffix(aIndex: Integer): string;
begin
  Result := GetElementLabel(aIndex);
  if Result <> '' then begin
    if arElement.Name = '' then
      Exit;
    Result := ' (' + Result + ')';
  end;
  Result := '#' + aIndex.ToString + Result;
end;

function TwbArrayDef.GetIsVariableSizeInternal: Boolean;
begin
  Result :=
    not (dfArrayStaticSize in DefFlags)
    and (
            (arCount <= 0)
         or arElement.IsVariableSize
        );
end;

function TwbArrayDef.GetPrefixCount(aBasePtr: Pointer): Cardinal;
var
  Count : int64;
begin
  Result := 0;
  if arCount = -255 then
    Result := 0
  else if arCount = -254 then
    Result := ReadIntegerCounter(aBasePtr)
  else if arCount = -253 then begin  // Matrix of count * count
    Count := ReadIntegerCounter(aBasePtr);
    Result := Count * Count;
  end
  else if arCount = -241 then begin  // Matrix of cardinal * cardinal
    Count := PCardinal(aBasePtr)^;
    Result := Count * Count;
  end
  else if Assigned(aBasePtr) then
    case GetPrefixlength(aBasePtr) of
      1: Result := PByte(aBasePtr)^;
      2: Result := PWord(aBasePtr)^;
      4: Result := PCardinal(aBasePtr)^;
    end;
end;

function TwbArrayDef.GetPrefixLength(aBasePtr: Pointer): Integer;
begin
  Result := 0;
  if arCount < 0 then
    if arCount = -1 then
      Result := 4
    else if arCount = -2 then
      Result := 2
    else if arCount = -4 then
      Result := 1
    else if arCount = -241 then
      Result := 4
    else if arCount = -253 then
      Result := ReadIntegerCounterSize(aBasePtr)
    else if arCount = -254 then
      Result := ReadIntegerCounterSize(aBasePtr);
end;

function TwbArrayDef.GetPrefixSize(aBasePtr: Pointer): Integer;
begin
  Result := GetPrefixLength(aBasePtr);
  if (Result>0) and ndTerminator then
    Inc(Result);
end;

function TwbArrayDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Prefix           : Integer;
  Count            : Int64;
  Index            : Integer; // Used instead of count for easier debugging output.
  Size             : Int64;
  BasePtr          : Pointer;
  CheckedContainer : Boolean;
  ArrayContainer   : IwbContainerElementRef;
  Element          : IwbElement;
  DataContainer    : IwbDataContainer;
  KnownSize        : Boolean;
//  aName            : string;

  function CheckContainer: IwbContainerElementRef;
  begin
    if Assigned(aElement) and (aElement.ValueDef.DefID = GetDefID) then
      Supports(aElement, IwbContainerElementRef, ArrayContainer);
    Result := ArrayContainer;
    CheckedContainer := True;
  end;

  function Container: IwbContainerElementRef;
  begin
    if CheckedContainer then
      Result := ArrayContainer
    else
      Result := CheckContainer;
  end;

begin
  Result := 0;
  CheckedContainer := False;
  ArrayContainer := nil;

  if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr)) then begin
//    wbProgressCallback('Found an array with a negative size! (1) '+IntToHex64(Cardinal(aBasePtr), 8)+
//      ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
    Exit;
  end;

  Prefix := GetPrefixSize(aBasePtr);
  BasePtr := aBasePtr;
  Count := arCount;
  if Count < 0 then begin
    Count := GetPrefixCount(aBasePtr);
    Result := Prefix;
  end else begin
    if arWronglyAssumedFixedSizePerElement > 0 then begin
      if Count = 0 then begin
        var lArrayElementCount := ArrayContainer.ElementCount;
        if lArrayElementCount > 0 then
          Count := lArrayElementCount
        else
          Count := Int64(NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) div arWronglyAssumedFixedSizePerElement;
      end;
      Exit(Count * arWronglyAssumedFixedSizePerElement);
    end;

    if (Count < 1) and Assigned(arCountCallback) and not (Container=nil) then
      Count := arCountCallback(BasePtr, aEndPtr, ArrayContainer);

    if not Assigned(BasePtr) and (Count < 1) and not Assigned(arCountCallback) then // EXPERIMENT: Probably should not be done
      Count := 1;

    if (Count < 1) and not Assigned(arCountCallback) and not Assigned(arShouldInclude) and not (arWronglyAssumedFixedSizePerElement > 0) then begin
      Result := High(Integer);
      Exit;
    end;
  end;

  if Assigned(arShouldInclude) then
    Assert(Count = 0);

  if Assigned(BasePtr) then
    Inc(PByte(BasePtr), Prefix);

  if (Count > 0) or Assigned(arShouldInclude) then
    if arElement.IsVariableSize or Assigned(arShouldInclude) then begin
      if Container = nil then begin // Make sure it won't be used if unassigned, and still delay FindOurself until it is effectivly required
        if not Assigned(BasePtr) then
          Result := arElement.DefaultSize[nil, nil, aElement]
        else
          Result := High(Integer);
        Exit;
      end;

      if (Count > 0) and (ArrayContainer.ElementCount = Count) then begin
        KnownSize := True;
        for Index := 0 to Pred(Count) do begin
          Element := ArrayContainer.Elements[Index];
          if Supports(Element, IwbDataContainer, DataContainer) then begin
            Size := NativeUInt(DataContainer.DataEndPtr) - NativeUInt(DataContainer.DataBasePtr);
            Inc(Result, Size);
          end else begin
            KnownSize := False;
            Break;
          end;
        end;
      end else
        KnownSize := False;

      Index := 0;
      if not KnownSize then begin
        if not Assigned(BasePtr) or (NativeUInt(BasePtr) = NativeUInt(aEndPtr)) and (ArrayContainer.ElementCount < 1) and (Count > 0) then begin
          // we have a variable sized array, with a static count of elements, and no existing data to read. Assume all elements are their default size
          Result := arElement.DefaultSize[nil, nil, aElement] * Count
        end else begin
          if (Count = 0) and Assigned(arShouldInclude) then
            Count := High(Integer);

          while (Count > Index) and (NativeUInt(BasePtr) < NativeUInt(aEndPtr)) do begin
            Element := ArrayContainer.Elements[Index];
            if not Assigned(Element) then begin
              if wbMoreInfoForIndex and (DebugHook <> 0) and wbHasProgressCallback then
                wbProgressCallback('Debug: ['+ ArrayContainer.Path +'] Index ' + IntToStr(Index) + ' of ' + IntToStr(Count) + ' greater than max '+
                  IntToStr(ArrayContainer.ElementCount-1));
              Element := aElement; // If it is too soon, revert to previous way of doing things
            end;
            if Assigned(arShouldInclude) and not arShouldInclude(BasePtr, aEndPtr, ArrayContainer) then
              Break;

            Size := arElement.Size[BasePtr, aEndPtr, Element];
            if Size = High(Integer) then begin
              Result := High(Integer);
              Exit;
            end;
            Inc(Result, Size);
            if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr) + Result) then begin
  //            if Assigned(aBasePtr) and Assigned(aEndPtr) and (aEndPtr<>aBasePtr) then
  //              wbProgressCallback('Found an array with a negative size! (2) '+IntToHex64(Cardinal(aBasePtr)+Result, 8)+
  //                ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
              Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr) + Result;
              Exit;
            end;
            if Assigned(BasePtr) then
              Inc(PByte(BasePtr), Size);
            Inc(Index);
          end;
        end;
      end;
    end else begin

      Element := nil;

      if Container <> nil then
        Element := ArrayContainer.AnyElement;

      if not Assigned(Element) then
        Element := aElement;

      Size := arElement.Size[BasePtr, aEndPtr, Element];
      if Size >= High(Integer) then begin
        Result := High(Integer);
        Exit;
      end;
      // I am assuming size greater than High(Integer) come from decoding errors
      Size  := (Count * Size) + Prefix;
      if Size >= High(Integer) then begin
        Result := High(Integer);
        Exit;
      end;
      Result := Size;
      if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr) + Result) then begin
//        if Assigned(aBasePtr) and Assigned(aEndPtr) and (aEndPtr<>aBasePtr) then
//          wbProgressCallback('Found a static array with a negative size! (3) '+IntToHex64(Cardinal(aBasePtr)+Result, 8)+
//            ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
        Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
        Exit;
      end;
    end;
  Inc(Result, Ord(arTerminated));
end;

function TwbArrayDef.GetDefaultEditValues: TwbStringArray;
begin
  Result := Copy(arDefaultEditValues);
end;

function TwbArrayDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if ((arCount = 0) and not Assigned(arCountCallback)) then begin
    if dfArrayCanBeEmpty in defFlags then
      Result := 0
    else
      Result := arWronglyAssumedFixedSizePerElement;
  end else begin
    if dfArrayCanBeEmpty in defFlags then
      Result := GetPrefixSize(aBasePtr)
    else
      Result := GetSize(aBasePtr, aEndPtr, aElement);
  end;
end;

function TwbArrayDef.GetSorted: Boolean;
begin
  if wbCopyIsRunning = 0 then
    Result := arSorted
  else
    Result := False;
end;

function TwbArrayDef.GetWronglyAssumedFixedSizePerElement: Integer;
begin
  Result := arWronglyAssumedFixedSizePerElement;
end;

procedure TwbArrayDef.InitFromParentDoChildren;
begin
  inherited;
  if Assigned(arElement) then
    (arElement as IwbDefInternal).InitFromParent(Self);
end;

procedure TwbArrayDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if Assigned(arElement) then begin
    Parents := aParents;
    SetLength(Parents, Succ(Length(Parents)));
    Parents[High(Parents)].Def := Self;
    Parents[High(Parents)].Index := -1;
    arElement.Report(aParents);
  end;

  defReported := True;
end;

function _GetCountCallbackForPath(const aPath: string): TwbCountCallback;
begin
  Result :=
    function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal
    begin
      Result := 0;
      if not Assigned(aBasePtr) then
        Exit;

      if not Assigned(aElement) then
        Exit;

      var lContainer: IwbContainerElementRef;
      if not Supports(aElement.Container, IwbContainerElementRef, lContainer) then
        Exit;

      var lCount := lContainer.ElementNativeValues[aPath];
      if not VarIsOrdinal(lCount) then
        Exit;

      Result := lCount;
    end;
end;

function TwbArrayDef.SetCountFromEnum(const aEnum: IwbEnumDef): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetCountFromEnum(aEnum));

  Result := Self;
  arCount := aEnum.NameCount;
  SetLength(arLabels, arCount);
  for var lIdx := 0 to Pred(arCount) do
    arLabels[lIdx] := aEnum.Names[lIdx];
end;

function TwbArrayDef.SetCountPath(const aValue: string; aUseForCountCallback: Boolean): IwbArrayDef;
begin
  if arCountPath = aValue then
    Exit(Self);

  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetCountPath(aValue, aUseForCountCallback));

  Result := Self;
  arCountPath := aValue;
  if (arCountPath <> '') and aUseForCountCallback then
    arCountCallback := _GetCountCallbackForPath(arCountPath);
end;

function TwbArrayDef.SetDefaultEditValues(const aValues: array of string): IwbArrayDef;
var
  i: Integer;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetDefaultEditValues(aValues));

  Result := Self;
  SetLength(arDefaultEditValues, Length(aValues));
  for i := Low(aValues) to High(aValues) do
    arDefaultEditValues[i] := aValues[i];
end;

procedure TwbArrayDef.SetPrefixCount(aBasePtr: Pointer; aValue: Cardinal);
begin
  if arCount = -255 then
  else if arCount = -254 then
    WriteIntegerCounter(aBasePtr, aValue)
  else if Assigned(aBasePtr) then
    case GetPrefixlength(aBasePtr) of
      1: PByte(aBasePtr)^ := aValue;
      2: PWord(aBasePtr)^ := aValue;
      4: PCardinal(aBasePtr)^ := aValue;
    end;
end;

function TwbArrayDef.SetShouldInclude(const aCallback: TwbShouldIncludeCallback): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetShouldInclude(aCallback));

  Result := Self;
  arShouldInclude := aCallback;
end;

function TwbArrayDef.SetSummaryDelimiter(const aDelimiter: string): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetSummaryDelimiter(aDelimiter));

  Result := Self;
  arSummaryDelimiter := aDelimiter;
end;

function TwbArrayDef.SetSummaryPassthroughMaxCount(aCount: Integer): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetSummaryPassthroughMaxCount(aCount));

  Result := Self;
  arSummaryPassthroughMaxCount := aCount;
end;

function TwbArrayDef.SetSummaryPassthroughMaxDepth(aCount: Integer): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetSummaryPassthroughMaxDepth(aCount));

  Result := Self;
  arSummaryPassthroughMaxDepth := aCount;
end;

function TwbArrayDef.SetSummaryPassthroughMaxLength(aLength: Integer): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetSummaryPassthroughMaxLength(aLength));

  Result := Self;
  arSummaryPassthroughMaxLength := aLength;
end;

function TwbArrayDef.SetWronglyAssumedFixedSizePerElement(aSize: Integer): IwbArrayDef;
begin
  if defIsLocked then
    Exit(TwbArrayDef(Duplicate).SetWronglyAssumedFixedSizePerElement(aSize));

  Result := Self;
  arWronglyAssumedFixedSizePerElement := aSize;
end;

function TwbArrayDef.ShouldInclude(aBasePtr, aEndPtr: Pointer; const aArray: IwbElement): Boolean;
begin
  if not Assigned(arShouldInclude) then
    Exit(True);
  Result := Assigned(aBasePtr) and Assigned(aEndPtr) and arShouldInclude(aBasePtr, aEndPtr, aArray);
end;

function TwbArrayDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
  Used(aElement, Result);
end;

function TwbArrayDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);
  if Result = '' then begin
    var CER: IwbContainerElementRef;
    if Supports(aElement, IwbContainerElementRef, CER) then begin
      var lElementCount := CER.ElementCount;
      if lElementCount > 0 then begin
        if Supports(CER.Elements[Pred(lElementCount)], IwbStringListTerminator) then
          Dec(lElementCount);

        var MaxCount := arSummaryPassthroughMaxCount;
        var MaxLength := arSummaryPassthroughMaxLength;

        if (lElementCount = 1) and (MaxCount < 0) then
          MaxCount := 1;

        if (MaxCount < 0) and (MaxLength > 0) then
          MaxCount := lElementCount;
        if MaxLength = 0 then
          MaxCount := 0;

        if (dfSummaryNoPassthrough in defFlags) or
           ((arSummaryPassthroughMaxDepth >= 0) and (aDepth >= arSummaryPassthroughMaxDepth)) then begin
          MaxCount := 0;
          MaxLength := 0;
        end;

        var CurrentCount := 0;

        while (lElementCount > 0) and (CurrentCount < MaxCount) do begin
          var Element := CER.Elements[CurrentCount];
          var DC: IwbDataContainer;
          var MemberCER: IwbContainerElementRef;
          if Supports(Element, IwbContainerElementRef, MemberCER) and Supports(Element, IwbDataContainer, DC) and (Element.ConflictPriority > cpIgnore) then begin
            var s := DC.ValueDef.ToSummary(Succ(aDepth), DC.DataBasePtr, DC.DataEndPtr, DC, aLinksTo).Trim;
            if s <> '' then begin

              var NeedDelimiter := Length(Result) > 0;
              var Len := Length(Result) + Length(s);
              if NeedDelimiter then
                Inc(Len, Length(arSummaryDelimiter));

              if (MaxLength > 0) and (Len > MaxLength) then
                Break;

              if NeedDelimiter then
                Result := Result + arSummaryDelimiter;

              Result := Result + s;
            end;
          end;
          Inc(CurrentCount);
          Dec(lElementCount);
        end;

        if lElementCount > 0 then begin
          var Glue := ' more ';
          if Result = '' then
            Glue := ' '
          else
            Result := Result + arSummaryDelimiter;

          var lName: string;
          if lElementCount = 1 then
            lName := GetSummarySingularName
          else
            lName := GetSummaryName;
          if lName = '' then
            if lElementCount = 1 then
              lName := aElement.Def.GetSummarySingularName
            else
              lName := aElement.Def.GetSummaryName;
          Result := Result + '<'+ lElementCount.ToString + Glue + lName.ToLower + '>';
        end;
      end;
    end;
  end;

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

{ TwbStructDef }

procedure TwbStructDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbStructDef do begin
    Self.stSummaryKey := Copy(stSummaryKey);
    Self.stSummaryPrefix := Copy(stSummaryPrefix);
    Self.stSummarySuffix := Copy(stSummarySuffix);
    Self.stSummaryMaxDepth := Copy(stSummaryMaxDepth);
    Self.stSummaryDelimiter := stSummaryDelimiter;
    Self.stSizeCallback := stSizeCallback;
  end;
end;

function TwbStructDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  StructDef : IwbStructDef;
  i         : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := (aIndex = Low(Integer)) and
    Supports(aDef, IwbStructDef, StructDef) and
    ( GetMemberCount = StructDef.MemberCount);
  if Result and not Equals(aDef) then
    for i := 0 to Pred(GetMemberCount) do
      if not stMembers[i].CanAssign(aElement, Low(Integer), StructDef.Members[i]) then begin
        Result := False;
        Exit;
      end;
end;

constructor TwbStructDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbStructDef do
    Self.Create(defPriority, defRequired, ndName, stMembers, stSortKey,
      stExSortKey, stElementMap, stOptionalFromElement, ndDontShow, ndAfterLoad, ndAfterSet, defGetCP).AfterClone(aSource);
end;

constructor TwbStructDef.Create(aPriority            : TwbConflictPriority;
                                aRequired            : Boolean;
                          const aName                : string;
                          const aMembers             : array of IwbValueDef;
                          const aSortKey             : array of Integer;
                          const aExSortKey           : array of Integer;
                          {$IFDEF WIN32}
                          const aElementMap          : array of Cardinal;
                          {$ENDIF WIN32}
                          {$IFDEF WIN64}
                          const aElementMap          : array of UInt64;
                          {$ENDIF WIN64}
                                aOptionalFromElement : Integer;
                                aDontShow            : TwbDontShowCallback;
                                aAfterLoad           : TwbAfterLoadCallback;
                                aAfterSet            : TwbAfterSetCallback;
                                aGetCP               : TwbGetConflictPriority);
begin
  stSummaryDelimiter := ' ';
  stOptionalFromElement := aOptionalFromElement;
  SetLength(stMembers, Length(aMembers));
  var NewLength := 0;
  for var i := Low(aMembers) to High(aMembers) do
    if Assigned(aMembers[i]) then begin
      stMembers[NewLength] := (aMembers[i] as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
      Inc(NewLength);
    end;
  SetLength(stMembers, NewLength);
  SetLength(stSortKey, Length(aSortKey));
  for var i := Low(stSortKey) to High(stSortKey) do
    stSortKey[i] := aSortKey[i];
  SetLength(stExSortKey, Length(aExSortKey));
  for var i := Low(stExSortKey) to High(stExSortKey) do
    stExSortKey[i] := aExSortKey[i];
  SetLength(stElementMap, Length(aElementMap));
  for var i := Low(stElementMap) to High(stElementMap) do
    stElementMap[i] := aElementMap[i];
  if Length(stElementMap) > 0 then begin
    Assert(Length(stElementMap) = Length(stMembers));
    // should really check that the element map only contains valid values
    // and that there are no optional elements...
  end;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;

function TwbStructDef.GetDefType: TwbDefType;
begin
  Result := dtStruct;
end;

function TwbStructDef.GetDefTypeName: string;
begin
  Result := 'Structure';
end;

function TwbStructDef.GetElementMap: TDynCardinalArray;
begin
  Result := stElementMap;
end;

function TwbStructDef.GetMember(aIndex: Integer): IwbValueDef;
begin
  Result := stMembers[aIndex];
end;

function TwbStructDef.GetMemberByName(const aName: string): IwbValueDef;
var
  i: Integer;
begin
  for i := Low(stMembers) to High(stMembers) do
    if SameText(stMembers[i].Name, aName) then
      Exit(stMembers[i]);
  Result := nil;
end;

function TwbStructDef.GetMemberCount: Integer;
begin
  Result := Length(stMembers);
end;

function TwbStructDef.GetOptionalFromElement: Integer;
begin
  Result := stOptionalFromElement;
end;

function TwbStructDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  i         : Integer;
  Size      : Integer;
  scDef     : IwbStructCDef;
  BasePtr   : Pointer;
  Container : IwbContainerElementRef;
  Element   : IwbElement;
begin
  Result := 0;
  if Assigned(stSizeCallback) then
    Exit(stSizeCallback(aBasePtr, aEndPtr, aElement));
  if Supports(Self, IwbStructCDef, scDef) then begin
    scDef.GetSizing(aBasePtr, aEndPtr, aElement, Size);
    if Size>0 then begin
      Inc(Result, Size);
      Exit;
    end;
  end;
  if (NativeUInt(aBasePtr) > NativeUInt(aEndPtr)) then begin // if aBasePtr >= aEndPtr then no allocation (or error)
//    wbProgressCallback('Found a struct with a negative size! (1) '+IntToHex64(Cardinal(aBasePtr), 8)+
//      ' > '+IntToHex64(Cardinal(aEndPtr), 8)+' for '+ ndName);
  end else if (not Assigned(aBasePtr) or (NativeUInt(aBasePtr) = NativeUInt(aEndPtr))) and (GetIsVariableSizeInternal) then begin
    Result := 0; // assuming we would have called GetDefaultSize otherwise... GetDefaultSize(aBasePtr, aEndPtr, aElement);
  end else begin
    BasePtr := aBasePtr;
    if GetIsVariableSize and Supports(aElement, IwbContainerElementRef, Container) and Equals(Container.ValueDef) and
        (Container.ElementCount > 0) then begin
      for i := 0 to Pred(Container.ElementCount) do begin
        Element := Container.Elements[i];
        Size := Element.ValueDef.Size[BasePtr, aEndPtr, Element];
        if Size = High(Integer) then begin
          Result := High(Integer);
          Break;
        end;
        Inc(Result, Size);
        if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr)+Result) then begin
//          if Assigned(aBasePtr) and Assigned(aEndPtr) and (aEndPtr<>aBasePtr) then
//          wbProgressCallback('Found a struct with a negative size! (2) '+IntToHex64(Cardinal(aBasePtr)+Size, 8)+
//            ' < '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
          Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
          Break;
        end;
        if Assigned(BasePtr) then
          Inc(PByte(BasePtr), Size);
      end;
    end else
      for i := Low(stMembers) to High(stMembers) do begin
        Size := stMembers[i].Size[BasePtr, aEndPtr, aElement];
        if Size = High(Integer) then begin
          Result := High(Integer);
          Break;
        end;
        Inc(Result, Size);
        if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr)+Result) then begin
//          if Assigned(aBasePtr) and Assigned(aEndPtr) and (aEndPtr<>aBasePtr) then
//            wbProgressCallback('Found a struct with a negative size! (2) '+IntToHex64(Cardinal(aBasePtr)+Result, 8)+
//              ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
          Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
          Break;
        end;
        if Assigned(BasePtr) then
          Inc(PByte(BasePtr), Size);
      end;
  end;
end;

procedure TwbStructDef.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(stMembers) to High(stMembers) do
    if Assigned(stMembers[lMemberIdx]) then
      (stMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
end;

function TwbStructDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(stMembers) to High(stMembers) do
      if aChild.Equals(stMembers[lIdx]) then
        Exit(lIdx);
end;

function TwbStructDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  i     : Integer;
  Size  : Integer;
begin
  if Assigned(stSizeCallback) then
    Exit(stSizeCallback(aBasePtr, aEndPtr, aElement));

  Result := 0;
  for i := Low(stMembers) to High(stMembers) do begin
    Size := stMembers[i].DefaultSize[aBasePtr, aEndPtr, aElement];
    if Size = High(Integer) then begin
      Result := High(Integer);
      Break;
    end;
    if Assigned(aBasePtr) then
      Inc(PByte(aBasePtr), Size);
    Inc(Result, Size);
  end;
end;

function TwbStructDef.GetIsVariableSizeInternal: Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := Low(stMembers) to High(stMembers) do
    if stMembers[i].IsVariableSize then begin
      Result := True;
      Break;
    end;
end;

procedure TwbStructDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
  i       : Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  Parents := aParents;
  SetLength(Parents, Succ(Length(Parents)));
  Parents[High(Parents)].Def := Self;
  for i := Low(stMembers) to High(stMembers) do
    if Assigned(stMembers[i]) then begin
      Parents[High(Parents)].Index := i;
      stMembers[i].Report(Parents);
    end;

  defReported := True;
end;

function TwbStructDef.SetSizeCallback(const aCallback: TwbStructSizeCallback): IwbStructDef;
begin
  if defIsLocked then
    Exit(TwbStructDef(Duplicate).SetSizeCallback(aCallback));

  Result := Self;
  stSizeCallback := aCallback;
end;

function TwbStructDef.SetSummaryDelimiter(const aDelimiter: string): IwbStructDef;
begin
  if defIsLocked then
    Exit(TwbStructDef(Duplicate).SetSummaryDelimiter(aDelimiter));

  Result := Self;
  stSummaryDelimiter := aDelimiter;
end;

function TwbStructDef.SetSummaryKey(const aSummaryKey: array of Integer): IwbStructDef;
begin
  if defIsLocked then
    Exit(TwbStructDef(Duplicate).SetSummaryKey(aSummaryKey));

  Result := Self;
  stSummaryKey := nil;
  SetLength(stSummaryKey, Length(aSummaryKey));
  for var i := Low(stSummaryKey) to High(stSummaryKey) do
    stSummaryKey[i] := aSummaryKey[i];
end;

function TwbStructDef.SetSummaryMemberMaxDepth(aIndex, aMaxDepth: Integer): IwbStructDef;
begin
  if defIsLocked then
    Exit(TwbStructDef(Duplicate).SetSummaryMemberMaxDepth(aIndex, aMaxDepth));

  Result := Self;
  Assert(InRange(aIndex, Low(stMembers), High(stMembers)), '[TwbStructDef.SetSummaryMemberMaxDepth] not InRange(aIndex, Low(stMembers), High(stMembers))');
  wbSetMaxDepth(aIndex, aMaxDepth, stSummaryMaxDepth);
end;

function TwbStructDef.SetSummaryMemberPrefixSuffix(aIndex: Integer; const aPrefix, aSuffix: string): IwbStructDef;
begin
  if defIsLocked then
    Exit(TwbStructDef(Duplicate).SetSummaryMemberPrefixSuffix(aIndex, aPrefix, aSuffix));

  Result := Self;
  Assert(InRange(aIndex, Low(stMembers), High(stMembers)), '[TwbStructDef.SetSummaryMemberPrefixSuffix] not InRange(aIndex, Low(stMembers), High(stMembers))');
  wbSetPrefixSuffix(aIndex, aPrefix, aSuffix, stSummaryPrefix, stSummarySuffix);
end;

function TwbStructDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
var
  i, j        : Integer;
  SortMember  : Integer;
  BasePtr     : Pointer;
  EndPtr      : Pointer;
begin
  Result := '';
  if (Length(stSortKey) > 0) or (aExtended and (Length(stExSortKey) > 0)) then begin
    for i := Low(stSortKey) to High(stSortKey) do begin
      SortMember := stSortKey[i];
      if SortMember <= High(stMembers) then begin
        BasePtr := aBasePtr;
        for j := Low(stMembers) to Pred(SortMember) do begin
          Inc(PByte(BasePtr), stMembers[j].Size[BasePtr, aEndPtr, aElement]);
          if NativeUInt(BasePtr) > NativeUInt(aEndPtr) then
            BasePtr := aEndPtr;
        end;

        EndPtr := PByte(BasePtr) + stMembers[SortMember].Size[BasePtr, aEndPtr, aElement];

        if NativeUInt(BasePtr) > NativeUInt(aEndPtr) then
          BasePtr := aEndPtr;
        if NativeUInt(EndPtr) > NativeUInt(aEndPtr) then
          EndPtr := aEndPtr;

        Result := Result + stMembers[SortMember].ToSortKey(BasePtr, EndPtr, aElement, aExtended);
      end;

      if i < High(stSortKey) then
        Result := Result + '|';
    end;
    if aExtended then begin
      if (Length(stSortKey) > 0) and (Length(stExSortKey) > 0) then
        Result := Result + '|';

      for i := Low(stExSortKey) to High(stExSortKey) do begin
        SortMember := stExSortKey[i];
        if SortMember <= High(stMembers) then begin
          BasePtr := aBasePtr;
          for j := Low(stMembers) to Pred(SortMember) do begin
            Inc(PByte(BasePtr), stMembers[j].Size[BasePtr, aEndPtr, aElement]);
            if NativeUInt(BasePtr) > NativeUInt(aEndPtr) then
              BasePtr := aEndPtr;
          end;

          EndPtr := PByte(BasePtr) + stMembers[SortMember].Size[BasePtr, aEndPtr, aElement];

          if NativeUInt(BasePtr) > NativeUInt(aEndPtr) then
            BasePtr := aEndPtr;
          if NativeUInt(EndPtr) > NativeUInt(aEndPtr) then
            EndPtr := aEndPtr;

          Result := Result + stMembers[SortMember].ToSortKey(BasePtr, EndPtr, aElement, aExtended);
        end;

        if i < High(stExSortKey) then
          Result := Result + '|';
      end;
    end;
  end else begin
    BasePtr := aBasePtr;
    for j := Low(stMembers) to High(stMembers) do begin
      EndPtr := PByte(BasePtr) + stMembers[j].Size[BasePtr, aEndPtr, aElement];

      if NativeUInt(BasePtr) > NativeUInt(aEndPtr) then
        BasePtr := aEndPtr;
      if NativeUInt(EndPtr) > NativeUInt(aEndPtr) then
        EndPtr := aEndPtr;

      Result := Result + stMembers[j].ToSortKey(BasePtr, EndPtr, aElement, aExtended);

      BasePtr := EndPtr;

      if j < High(stMembers) then
        Result := Result + '|';
    end;
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbStructDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
  Used(aElement, Result);
end;

function TwbStructDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
var
  CER               : IwbContainerElementRef;
  MemberUsed        : array of Boolean;
  DelayedName       : string;
  MembersNoName     : Boolean;
  MembersShowIgnore : Boolean;

  procedure Process(const Keys: array of integer);

  begin
    for var i := Low(Keys) to High(Keys) do begin
      var SortMember := Keys[i];
      if SortMember <= High(stMembers) then begin
        if Length(MemberUsed) < 1 then
          SetLength(MemberUsed, Length(stMembers));
        if MemberUsed[SortMember] then
          Continue;
        MemberUsed[SortMember] := True;

        var MaxDepth := TFromArray<Integer>.Get(stSummaryMaxDepth, SortMember);
        if (MaxDepth = 0) or (aDepth < MaxDepth) then begin
          var Element := CER.ElementBySortOrder[SortMember + CER.AdditionalElementCount];
          var DC: IwbDataContainer;
          var MemberCER: IwbContainerElementRef;
          if Supports(Element, IwbContainerElementRef, MemberCER) and
             Supports(Element, IwbDataContainer, DC) and
             (MembersShowIgnore or (dfSummaryShowIgnore in Element.Def.DefFlags) or not wbHideIgnored or (Element.ConflictPriority > cpIgnore)) and
             not Element.DontShow
          then begin
            var MemberDef := stMembers[SortMember];
            if not MemberDef.Equals(DC.Def) then
              if MemberDef.DefType = dtUnion then
                MemberDef := DC.Def as IwbValueDef
              else if DC.Def.DefType = dtEmpty then
                MemberDef := DC.Def as IwbValueDef
              else
                Assert(MemberDef.Equals(DC.Def), 'TwbStructDef.ToSummary for ['+Element.FullPath+']: ['+MemberDef.Path+'] is not equal to ['+DC.Def.Path+']');
            var lMemberSummary:= MemberDef.ToSummary(Succ(aDepth), DC.DataBasePtr, DC.DataEndPtr, DC, aLinksTo).Trim;
            if lMemberSummary <> '' then begin
              var Prefix := TFromArray<string>.Get(stSummaryPrefix, SortMember);
              var Suffix := TFromArray<string>.Get(stSummarySuffix, SortMember);
              var HasFix := (Prefix <> '') or (Suffix <> '');
              var NoName := MembersNoName or (dfSummaryNoName in MemberDef.DefFlags);

              if Result <> '' then begin
                if DelayedName <> '' then begin
                  Result := DelayedName + ':(' + Result + ')';
                  DelayedName := '';
                end;
                Result := Result + stSummaryDelimiter;
              end;

              var lMemberSummaryName := MemberDef.SummaryName;
              if (MemberCER.ElementType = etArray) and (MemberCER.ElementCount = 1) then
                lMemberSummaryName := MemberDef.GetSummarySingularName;

              if NoName or HasFix or lMemberSummary.StartsWith(lMemberSummaryName + ':(', True) then
                Result := Result + Prefix + lMemberSummary + Suffix
              else begin
                if Result = '' then begin
                  DelayedName := lMemberSummaryName;
                  Result := lMemberSummary;
                end else
                  Result := Result + lMemberSummaryName + ':(' + lMemberSummary + ')';
              end;

            end;
          end;
        end;
      end;
    end;
  end;

begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);
  if (Result = '') and Supports(aElement, IwbContainerElementRef, CER) then begin
    MemberUsed := nil;
    DelayedName := '';
    MembersNoName := dfSummaryMembersNoName in defFlags;
    MembersShowIgnore := dfSummaryMembersShowIgnore in defFlags;
    if not (dfSummaryNoSortKey in defFlags) then begin
      Process(stSortKey);
      Process(stExSortKey);
    end;
    Process(stSummaryKey);
  end;

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

{ TwbFlagsDef }

procedure TwbFlagsDef.AfterClone(const aSource: TwbDef);
begin
  inherited;
  with aSource as TwbFlagsDef do begin
    Self.flgSummaries := Copy(flgSummaries);
    Self.flgDontShowPath := flgDontShowPath;
    Self.flgDontShowInvert := flgDontShowInvert;
  end;
end;

function TwbFlagsDef.Assign(const aTarget : IwbElement;
                                  aIndex  : Integer;
                            const aSource : IwbElement;
                                  aOnlySK : Boolean)
                                          : IwbElement;
var
  FlagDef : IwbFlagDef;
  i       : Int64;
begin
  if Supports(aSource.ValueDef, IwbFlagDef, FlagDef) then begin
    i := aTarget.NativeValue;
    i := i or (Int64(1) shl Int64(FlagDef.FlagIndex));
    aTarget.NativeValue := i;
  end else
    if not aOnlySK then
      Result := inherited Assign(aTarget, aIndex, aSource, aOnlySK);
end;

function TwbFlagsDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  FlagsDef : IwbFlagsDef;
  FlagDef  : IwbFlagDef;
  i        : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if Supports(aDef, IwbFlagsDef, FlagsDef) then begin
    Result := FlagsDef.FlagCount = GetFlagCount;
    if Result and not GetRoot.Equals(FlagsDef.Root) then
      for i := 0 to Pred(GetFlagCount) do
        if not SameStr(FlagsDef.Flags[i, False], GetFlag(i, False)) then begin
          Result := False;
          Exit;
        end;
  end else if Supports(aDef, IwbFlagDef, FlagDef) then begin
    FlagsDef := FlagDef.FlagsDef;
    Result := GetBaseFlagsDef.Equals(FlagsDef.BaseFlagsDef);
    if Result then begin
      i := FlagDef.FlagIndex;
      Result := SameStr(FlagsDef.Flags[i, False], GetFlag(i, False));
    end;
  end else
    Result := False;
end;

function TwbFlagsDef.Check(aInt: Int64; const aElement: IwbElement): string;
var
  i: Integer;
  s: string;
begin
  Result := '';
  if not flgUnknownIsUnused then begin
    for i := 0 to 63 do
      if (aInt and (Int64(1) shl i)) <> 0 then begin
        s := '';
        if i <= High(flgNames) then
          s := flgNames[i];
        if s = '' then begin
          s :=  wbGetUnknownIntString(i);
          Result := Result + s + ', ';
        end;
      end;
    SetLength(Result, Length(Result)-2);
  end;
end;

constructor TwbFlagsDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbFlagsDef do
    Self.Create(False,
    flgBaseFlagsDef, flgNames, flgDontShows, flgUnknownIsUnused, flgIgnoreMask, flgGetCPs).AfterClone(aSource);
end;

constructor TwbFlagsDef.Create(aHasSummary      : Boolean;
                         const aBaseFlagsDef    : IwbFlagsDef;
                         const aNames           : array of string;
                         const aDontShows       : array of TwbDontShowCallback;
                               aUnknownIsUnused : Boolean;
                               aIgnoreMask      : Int64;
                         const aGetCPs          : array of TwbGetConflictPriority);
var
  i: Integer;
begin
  flgDeletedIndex    := -1;
  flgPartialFormIndex := -1;

  var StepSize := 1;
  var l := Length(aNames);

  if aHasSummary then begin
    StepSize := 2;
    Assert(l mod StepSize = 0);
    l := l div StepSize;
  end;

  if Assigned(aBaseFlagsDef) then
    flgBaseFlagsDef := aBaseFlagsDef.Root as IwbFlagsDef;
  flgIgnoreMask := aIgnoreMask;
  flgUnknownIsUnused := aUnknownIsUnused;
  flgUnusedMask := 0;
  if flgUnknownIsUnused then
    flgUnusedMask := not flgUnusedMask;
  SetLength(flgNames, l);
  SetLength(flgSummaries, l);
  for i := Low(flgNames) to High(flgNames) do begin
    flgNames[i] := aNames[i * StepSize];
    if SameText(flgNames[i], 'Unused') then
      flgUnusedMask := flgUnusedMask or (Int64(1) shl i)
    else if flgUnknownIsUnused and (flgNames[i] <> '') then
      flgUnusedMask := flgUnusedMask and not (Int64(1) shl i);

    if aHasSummary then
      flgSummaries[i] := aNames[Succ(i * StepSize)];
    if flgSummaries[i] = '' then
      flgSummaries[i] := flgNames[i];
  end;
  SetLength(flgFlagDefs, Length(flgNames));

  SetLength(flgDontShows, Length(aDontShows));
  for i := Low(flgDontShows) to High(flgDontShows) do begin
    flgDontShows[i] := aDontShows[i];
    flgHasDontShows := flgHasDontShows or Assigned(flgDontShows[i]);
  end;

  SetLength(flgGetCPs, Length(aGetCPs));
  for i := Low(flgGetCPs) to High(flgGetCPs) do begin
    flgGetCPs[i] := aGetCPs[i];
    flgHasGetCPs := flgHasGetCPs or Assigned(flgGetCPs[i]);
  end;

  inherited Create;
end;

function TwbFlagsDef.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(aValue) do
    case aValue[i] of
      '0': {do nothing};
      '1': Result := Result or (Int64(1) shl Pred(i));
    else
      raise Exception.Create('"'+aValue[i]+'" is not a valid character for a flag');
    end;
  Result := Result and not flgUnusedMask;
end;

function TwbFlagsDef.GetAssignTemplates(const aContainer: IwbContainerElementRef; aIndex: Integer): TwbDefs;
begin
  {Result := [];
  if aIndex >= 0 then begin
    if aIndex = wbAssignAdd then begin
      SetLength(Result, Length(flgFlagDefs));
      for var lFlagIdx := Low(Result) to High(Result) do
        Result[lFlagIdx] := GetFlagDef(lFlagIdx);
    end else begin
      var lFlagDef := GetFlagDef(aIndex);
      if Assigned(lFlagDef) then
        Result := [lFlagDef];
    end;
  end else}
    Result := inherited;
end;

function TwbFlagsDef.GetBaseFlagsDef: IwbFlagsDef;
begin
  if Assigned(flgBaseFlagsDef) then
    Result := flgBaseFlagsDef
  else
    Result := GetRoot as IwbFlagsDef;
end;

function TwbFlagsDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(flgFlagDefs) to High(flgFlagDefs) do
      if aChild.Equals(flgFlagDefs[lIdx]) then
        Exit(lIdx);
end;

function TwbFlagsDef.GetConflictPriority(const aElement: IwbElement): TwbConflictPriority;
begin
  Result := inherited;

  if not Assigned(aElement) then
    Exit;

  if aElement.ElementType = etFlag then begin
    var lFlagDef: IwbFlagDef;
    if not Supports(aElement.Def, IwbFlagDef, lFlagDef) then
      Exit;
    Assert(Equals(lFlagDef.FlagsDef));
    FlagGetCP(aElement, lFlagDef.FlagIndex, Result);
    Exit;
  end;

  if (dfIsRecordFlags in defFlags) and (Result = cpNormal) and Assigned(aElement) then begin
    var lNativeValue := aElement.NativeValue;
    if not VarIsOrdinal(lNativeValue) then
      Exit;
    var lFlagsValue: Int64 := lNativeValue;

    if ((flgDeletedIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgDeletedIndex))) <> 0)) or
       ((flgPartialFormIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgPartialFormIndex))) <> 0))
    then
      Result := cpNormalIgnoreEmpty;
  end;
end;

function TwbFlagsDef.GetConflictPriorityCanChange: Boolean;
begin
  Result := inherited GetConflictPriorityCanChange or (dfIsRecordFlags in defFlags);
end;

function TwbFlagsDef.GetDefTypeName: string;
var
  i: Integer;
begin
  if Length(flgNames)=0 then
    inherited
  else begin
    Result := '('+flgNames[Low(flgNames)];
    for i := 1 to High(flgNames) do
      Result := Result+','+flgNames[i];
    Result := Result+')'
  end;
end;

function TwbFlagsDef.GetEditInfo(const aElement: IwbElement): TwbStringArray;
var
  FlagCount  : Integer;
  IntegerDef : IwbIntegerDef;
  i          : Integer;
  s          : string;
begin
  FlagCount := 64;
  if Assigned(aElement) and (Supports(aElement.Def, IwbIntegerDef, IntegerDef) or Supports(aElement.ValueDef, IwbIntegerDef, IntegerDef)) then
    case IntegerDef.IntType of
      it0: FlagCount := 0;
      itU8, itS8: FlagCount := 8;
      itU16, itS16: FlagCount := 16;
      itU32, itS32: FlagCount := 32;
    end;

  with TStringList.Create do try
    for i := 0 to Pred(FlagCount) do begin
      s := '';
      if i <= High(flgNames) then
        s := flgNames[i];
      if s = '' then
        if flgUnknownIsUnused then
          s := 'Unused'
        else
          s :=  wbGetUnknownIntString(i);
      if GetFlagDontShow(aElement, i) then
        s := '<Unknown: ' + IntToStr(i) + '>';
      if wbShowFlagEnumValue then
        s := s + ' (0x' + IntToHex(Int64(1) shl i, 8) + ')';
      Add(s);
    end;
    Result := ToStringArray;
  finally
    Free;
  end;
end;

function TwbFlagsDef.GetEditType(const aElement: IwbElement): TwbEditType;
begin
  Result := etCheckComboBox;
end;

function TwbFlagsDef.GetFlag(aIndex: Integer; aForSummary: Boolean): string;
begin
  if aForSummary then
    Exit(flgSummaries[aIndex]);

  Result := flgNames[aIndex];
  if wbShowFlagEnumValue then
    Result := Result + ' (0x' + IntToHex(Int64(1) shl aIndex, 8) + ')';
end;

function TwbFlagsDef.GetFlagCount: Integer;
begin
  Result := Length(flgNames);
end;

function TwbFlagsDef.GetFlagDef(aIndex: Integer): IwbFlagDef;
begin
  if (aIndex < Low(flgFlagDefs)) or (aIndex > High(flgFlagDefs)) then
    Exit(nil);

  Result := flgFlagDefs[aIndex];
  if not Assigned(Result) then begin
    var lFlagDef: IwbFlagDef := TwbFlagDef.Create(defPriority, False, flgNames[aIndex], nil, nil,
      nil, nil, False, aIndex).SetParent(Self, False) as IwbFlagDef;

    var lExchanged: Boolean;
    AtomicCmpExchange(Pointer(flgFlagDefs[aIndex]), Pointer(lFlagDef), nil, lExchanged);
    if lExchanged then
      //we've transfered ownership to the array, make sure the reference count doesn't get wrongly decremented
      Pointer(lFlagDef) := nil;

    Result := flgFlagDefs[aIndex];
  end;
end;

function TwbFlagsDef.GetFlagDontShow(const aElement: IwbElement; aIndex: Integer): Boolean;
begin
  Result := False;
  if flgHasDontShows and (aIndex <= High(flgDontShows)) and Assigned(flgDontShows[aIndex]) then
    Result := flgDontShows[aIndex](aElement);

  if flgDontShowPath <> '' then begin
    var lContainer: IwbContainer;
    if not Supports(aElement, IwbContainer, lContainer) then
      if not Assigned(aElement) or
         not Supports(aElement.Container, IwbContainer, lContainer)
      then
        Exit;

    var lMaskValue := lContainer.ElementNativeValues[flgDontShowPath];
    if not VarIsOrdinal(lMaskValue) then
      Exit;

    var lMask: Int64 := lMaskValue;
    Result := (lMask and (Int64(1) shl Int64(aIndex))) <> 0;
    if flgDontShowInvert then
      Result := not Result;
  end;
{
  if (dfIsRecordFlags in defFlags) and
     Assigned(aElement) and
     (aIndex <> flgDeletedIndex) and
     (aIndex <> flgPartialFormIndex)
  then begin
    var lContainer: IwbContainer;
    if not Supports(aElement, IwbContainer, lContainer) then
      if not Assigned(aElement) or
         not Supports(aElement.Container, IwbContainer, lContainer)
      then
        Exit;

    var lNativeValue := lContainer.NativeValue;
    if not VarIsOrdinal(lNativeValue) then
      Exit;
    var lFlagsValue: Int64 := lNativeValue;

    if ((flgDeletedIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgDeletedIndex))) <> 0)) or
       ((flgPartialFormIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgPartialFormIndex))) <> 0))
    then
      Result := True;
  end;
}
end;

function TwbFlagsDef.FindFlag(aName: string; out aFlagDef: IwbFlagDef): Boolean;
var
  i: Integer;
  j: Int64;
begin
  Result := False;
  aFlagDef := nil;

  if aName = '' then
    Exit;

  for i := Low(flgNames) to High(flgNames) do
    if SameText(aName, flgNames[i]) then begin
      aFlagDef := GetFlagDef(i);
      Exit(Assigned(aFlagDef));
    end;


  if aName.StartsWith('0x') then
    aName := '$' + Copy(aName, 3);

  if aName.StartsWith('$') then begin
    j := StrToIntDef(aName, 0);
    i := 0;
    while (j <> 0) and (i < GetFlagCount) do begin
      if j = 1 then begin
        aFlagDef := GetFlagDef(i);
        Exit(Assigned(aFlagDef));
      end;
      Inc(i);
      j := j shr 1;
    end;
  end;

  i := StrToIntDef(aName, -1);
  if (i >= 0) and (i < GetFlagCount) then begin
    aFlagDef := GetFlagDef(i);
    Exit(Assigned(aFlagDef));
  end;
end;

procedure TwbFlagsDef.FlagGetCP(const aElement : IwbElement;
                                      aIndex   : Integer;
                                  var aCP      : TwbConflictPriority);
begin
  if flgHasGetCPs and (aIndex <= High(flgGetCPs)) and Assigned(flgGetCPs[aIndex]) then
    flgGetCPs[aIndex](aElement, aCP);

  if (dfIsRecordFlags in defFlags) and
     Assigned(aElement) and
     (aIndex <> flgDeletedIndex) and
     (aIndex <> flgPartialFormIndex)
  then begin
    var lContainer: IwbContainer;
    if not Supports(aElement, IwbContainer, lContainer) then
      if not Assigned(aElement) or
         not Supports(aElement.Container, IwbContainer, lContainer)
      then
        Exit;

    var lNativeValue := lContainer.NativeValue;
    if not VarIsOrdinal(lNativeValue) then
      Exit;
    var lFlagsValue: Int64 := lNativeValue;

    if ((flgDeletedIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgDeletedIndex))) <> 0)) or
       ((flgPartialFormIndex >= 0) and ((lFlagsValue and (Int64(1) shl Int64(flgPartialFormIndex))) <> 0))
    then
      aCP := cpIgnore;
  end;
end;

function TwbFlagsDef.GetFlagHasDontShow(aIndex: Integer): Boolean;
begin
  Result := flgHasDontShows and (aIndex <= High(flgDontShows)) and Assigned(flgDontShows[aIndex]){ or (dfIsRecordFlags in defFlags)};
end;

function TwbFlagsDef.GetFlagHasGetCP(aIndex: Integer): Boolean;
begin
  Result := flgHasGetCPs and (aIndex <= High(flgGetCPs)) and Assigned(flgGetCPs[aIndex]) or (dfIsRecordFlags in defFlags);
end;

function TwbFlagsDef.GetFlagIgnoreConflict(aIndex: Integer): Boolean;
begin
  Result := (flgIgnoreMask and (Int64(1) shl Int64(aIndex))) <> 0;
end;

function TwbFlagsDef.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

procedure TwbFlagsDef.Report(const aParents: TwbDefPath);
var
  i: Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if wbReportMode and wbReportUnknownFlags and HasUnknownFlags then begin
    WriteLn('Unknown Flags in: ', wbDefsToPath(aParents), wbDefToName(Self));
    for i := 0 to 63 do
      if UnknownFlags[i] > 0 then
        WriteLn('  ', i,' (',UnknownFlags[i],')');
  end;

  defReported := True;
end;

function TwbFlagsDef.SetDontShowMaskPath(const aPath: string; aInvert: Boolean): IwbFlagsDef;
begin
  if defIsLocked then
    Exit(TwbFlagsDef(Duplicate).SetDontShowMaskPath(aPath, aInvert));

  Result := Self;
  flgDontShowPath := aPath;
  flgDontShowInvert := aInvert;
end;

function TwbFlagsDef.SetFlagHasDontShow(aIndex: Integer; const aDontShow: TwbDontShowCallback): IwbFlagsDef;
begin
  if defIsLocked then
    Exit(TwbFlagsDef(Duplicate).SetFlagHasDontShow(aIndex, aDontShow));

  Result := Self;
  if Assigned(aDontShow) then begin
    if Length(flgDontShows) <= aIndex then
      SetLength(flgDontShows, Succ(aIndex));
    flgDontShows[aIndex] := aDontShow;
  end else begin
    if High(flgDontShows) >= aIndex then
      flgDontShows[aIndex] := aDontShow;
  end;

  flgHasDontShows := False;
  for var lIndex := Low(flgDontShows) to High(flgDontShows) do
    if Assigned(flgDontShows[lIndex]) then begin
      flgHasDontShows := True;
      Break;
    end;
  if not flgHasDontShows then
    flgDontShows := nil;
end;

function TwbFlagsDef.GetRequiresKey: Boolean;
begin
  Result := True;
end;

procedure TwbFlagsDef.InitFromParentDoChildren;
begin
  inherited;
  for var lFlagIdx := Low(flgFlagDefs) to High(flgFlagDefs) do
    if Assigned(flgFlagDefs[lFlagIdx]) then
      (flgFlagDefs[lFlagIdx] as IwbDefInternal).InitFromParent(Self);

  if dfIsRecordFlags in defFlags then begin
    var lFlagDef: IwbFlagDef;
    if FindFlag('Deleted', lFlagDef) then
      flgDeletedIndex := lFlagDef.FlagIndex;
    if FindFlag('Partial Form', lFlagDef) then
      flgPartialFormIndex := lFlagDef.FlagIndex;
  end;
end;

function TwbFlagsDef.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
var
  i: Integer;
begin
  aInt := aInt and not flgUnusedMask;
  Result := StringOfChar('0', 64);
  for i := 0 to 63 do
    if (aInt and (Int64(1) shl i)) <> 0 then begin
      Result[Succ(i)] := '1';
      aInt := aInt and not (Int64(1) shl i);
      if aInt = 0 then begin
        SetLength(Result, Succ(i));
        Exit;
      end;
    end;
end;

function TwbFlagsDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
var
  i: Integer;
begin
  aInt := aInt and not flgUnusedMask;
  Result := StringOfChar('0', 64);
  for i := 0 to 63 do
    if (aInt and (Int64(1) shl i)) <> 0 then
      if not GetFlagDontShow(aElement, i) then
        Result[Succ(i)] := '1';
end;

function TwbFlagsDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  i: Integer;
  s: string;
begin
  Result := '';
  aInt := aInt and not flgUnusedMask;
  for i := 0 to 63 do
    if (aInt and (Int64(1) shl i)) <> 0 then begin
      s := '';
      if i <= High(flgNames) then
        if aForSummary then
          s := flgSummaries[i]
        else
          s := flgNames[i];
      if s = '' then begin
        if aForSummary then
          s := '<'+IntToStr(i)+'>'
        else
          s :=  wbGetUnknownIntString(i);
        if wbReportMode and wbReportUnknownFlags then begin
          Inc(UnknownFlags[i]);
          HasUnknownFlags := True;
        end;
      end;
      if not aForSummary and wbShowFlagEnumValue then
        s := s + ' (0x' + IntToHex(Int64(1) shl i, 8) + ')';
      if not GetFlagDontShow(aElement, i) then
        Result := Result + s + ', ';
    end;
  SetLength(Result, Length(Result)-2);
  Used(aElement, Result);
end;

{ TwbEnumDef }

function TwbEnumDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  EnumDef: IwbEnumDef;
  i: Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbEnumDef, EnumDef) and (EnumDef.NameCount = GetNameCount);
  if Result and not Equals(EnumDef) then
    for i := 0 to Pred(GetNameCount) do
      if not SameStr(EnumDef.Names[i], GetName(i)) then begin
        Result := False;
        Exit;
      end;
end;

function TwbEnumDef.Check(aInt: Int64; const aElement: IwbElement): string;
var
  i: Integer;
begin
  Result := '';

  if (aInt >= Low(enNames)) and (aInt <= High(enNames)) then
    Result := enNames[aInt];

  if Result = '' then
    if FindSparseName(aInt, i) then
      Result := enSparseNamesMap[i].snName;

  if Result = '' then
    Result := wbGetUnknownIntString(aInt)
  else
    Result := '';
end;

function CompareSparseName(Item1, Item2: Pointer): Integer;
var
  Index1, Index2: Int64;
begin
  Index1 := PwbSparseName(Item1).snIndex;
  Index2 := PwbSparseName(Item2).snIndex;

  if Index1 < Index2 then
    Result := -1
  else if Index1 = Index2 then
    Result := 0
  else
    Result := 1;
end;

constructor TwbEnumDef.Clone(const aSource: TwbDef);
var
  i: Integer;
begin
  with aSource as TwbEnumDef do begin
    inherited Create;
    Self.enNames := Copy(enNames, 0, Length(enNames));
    Self.enSummaries := Copy(enSummaries, 0, Length(enSummaries));
    Self.enSparseNames := Copy(enSparseNames, 0, Length(enSparseNames));
    Self.enEditInfo := enEditInfo;

    Self.enDictionary := TwbEnumDictionary.Create(enDictionary.Capacity, TIStringComparer.Ordinal);
    for var lPair in enDictionary.ToArray do
      Self.enDictionary.Add(lPair.Key, lPair.Value);
  end;

  SetLength(enSparseNamesMap, Length(enSparseNames));
  for i := Low(enSparseNames) to High(enSparseNames) do
    enSparseNamesMap[i] := @enSparseNames[i];
  if Length(enSparseNames) > 0 then
    wbMergeSortPtr(@enSparseNamesMap[0], Length(enSparseNames), CompareSparseName);

  Self.AfterClone(aSource);
end;

constructor TwbEnumDef.Create(aHasSummary  : Boolean;
                        const aNames: array of string;
                        const aSparseNames : array of const);
var
  i        : Integer;
  EditInfo : TStringList;
begin
  var StepSize := 1;
  var l := Length(aNames);

  if aHasSummary then begin
    StepSize := 2;
    Assert(l mod StepSize = 0);
    l := l div StepSize;
  end;

  enDictionary := TwbEnumDictionary.Create(l + (Length(aSparseNames) div 2), TIStringComparer.Ordinal);

  EditInfo := TwbFastStringListIC.Create;
  try
    SetLength(enNames, l);
    SetLength(enSummaries, l);
    for i := Low(enNames) to High(enNames) do begin
      var lName := aNames[i*StepSize];
      enNames[i] := lName;
      if lName <> '' then begin
        if not enDictionary.TryAdd(lName, i) then begin
          lName := lName + '@' + i.ToString;
          enDictionary.Add(lName, i);
          enNames[i] := lName;
        end;

        if wbShowFlagEnumValue then
          EditInfo.Add(lName + ' (' + IntToStr(i) + ')')
        else
          EditInfo.Add(lName);
      end;

      var lSummary := '';
      if aHasSummary then
        lSummary := aNames[Succ(i*StepSize)];
      if lSummary = '' then
        lSummary := lName;

      enSummaries[i] := lSummary;
    end;

    Inc(StepSize);
    Assert(Length(aSparseNames) mod StepSize = 0);
    SetLength(enSparseNames, Length(aSparseNames) div StepSize);
    for i := Low(enSparseNames) to High(enSparseNames) do begin
      Assert(aSparseNames[ i * StepSize ].VType in [vtInteger, vtInt64]);
      Assert(aSparseNames[(i * StepSize) + 1].VType in [vtAnsiString, vtChar, vtUnicodeString, vtWideChar]);
      if aHasSummary then
        Assert(aSparseNames[(i * StepSize) + 2].VType in [vtAnsiString, vtChar, vtUnicodeString, vtWideChar]);

      with enSparseNames[i] do begin

        if aSparseNames[i * StepSize].VType = vtInteger then
          snIndex := aSparseNames[i * StepSize ].VInteger
        else
          snIndex := aSparseNames[i * StepSize ].VInt64^;

        if aSparseNames[(i * StepSize) + 1].VType = vtAnsiString then
          snName  := AnsiString(aSparseNames[(i * StepSize) + 1].VAnsiString)
        else if aSparseNames[(i * StepSize) + 1].VType = vtChar then
          snName  := aSparseNames[(i * StepSize) + 1].VChar
        else if aSparseNames[(i * StepSize) + 1].VType = vtUnicodeString then
          snName  := UnicodeString(aSparseNames[(i * StepSize) + 1].VUnicodeString)
        else if aSparseNames[(i * StepSize) + 1].VType = vtWideChar then
          snName  := aSparseNames[(i * StepSize) + 1].VWideChar;

        if aHasSummary then begin
          if aSparseNames[(i * StepSize) + 2].VType = vtAnsiString then
            snSummary  := AnsiString(aSparseNames[(i * StepSize) + 2].VAnsiString)
          else if aSparseNames[(i * StepSize) + 2].VType = vtChar then
            snSummary  := aSparseNames[(i * StepSize) + 2].VChar
          else if aSparseNames[(i * StepSize) + 2].VType = vtUnicodeString then
            snSummary  := UnicodeString(aSparseNames[(i * StepSize) + 2].VUnicodeString)
          else if aSparseNames[(i * StepSize) + 2].VType = vtWideChar then
            snSummary  := aSparseNames[(i * StepSize) + 2].VWideChar;
        end;

        if snSummary = '' then
          snSummary := snName;

        if snName <> '' then begin
          if not enDictionary.TryAdd(snName, snIndex) then begin
            snName := snName  + '@' + snIndex.ToString;
            enDictionary.Add(snName, snIndex);
          end;

          if wbShowFlagEnumValue then
            EditInfo.Add(snName + ' (' + IntToStr(snIndex) + ')')
          else
            EditInfo.Add(snName);
        end;
      end;
    end;
    EditInfo.Sort;
    enEditInfo := EditInfo.ToStringArray;
  finally
    FreeAndNil(EditInfo);
  end;

  SetLength(enSparseNamesMap, Length(enSparseNames));
  for i := Low(enSparseNames) to High(enSparseNames) do
    enSparseNamesMap[i] := @enSparseNames[i];
  if Length(enSparseNames) > 0 then
    wbMergeSortPtr(@enSparseNamesMap[0], Length(enSparseNames), CompareSparseName);

  inherited Create;
end;

destructor TwbEnumDef.Destroy;
begin
  inherited;
  FreeAndNil(enDictionary);
end;

function CmpB8(a, b: Byte): Integer;
asm
{$IFDEF WIN32}
  xor ecx, ecx
  cmp al, dl
  ja @@GT
  je @@EQ
@@LT:
  dec ecx
  dec ecx
@@GT:
  inc ecx
@@EQ:
  mov eax, ecx
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor eax, eax
  cmp ecx, edx
  ja @@GT
  je @@EQ
@@LT:
  dec eax
  dec eax
@@GT:
  inc eax
@@EQ:
{$ENDIF WIN64}
end;

function CmpI32(a, b : Integer) : Integer;
asm
{$IFDEF WIN32}
  xor ecx, ecx
  cmp eax, edx
  jg @@GT
  je @@EQ
@@LT:
  dec ecx
  dec ecx
@@GT:
  inc ecx
@@EQ:
  mov eax, ecx
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor eax, eax
  cmp ecx, edx
  jg @@GT
  je @@EQ
@@LT:
  dec eax
  dec eax
@@GT:
  inc eax
@@EQ:
{$ENDIF WIN64}
end;

function CmpW32(a, b: Cardinal): Integer;
asm
{$IFDEF WIN32}
  xor ecx, ecx
  cmp eax, edx
  ja @@GT
  je @@EQ
@@LT:
  dec ecx
  dec ecx
@@GT:
  inc ecx
@@EQ:
  mov eax, ecx
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor eax, eax
  cmp ecx, edx
  ja @@GT
  je @@EQ
@@LT:
  dec eax
  dec eax
@@GT:
  inc eax
@@EQ:
{$ENDIF WIN64}
end;

function CmpI64(const a, b : Int64) : Integer;
asm
{$IFDEF WIN32}
  xor eax, eax
  mov edx, [ebp+20]
  cmp edx, [ebp+12]
  jg @@GT
  jl @@LT
  mov edx, [ebp+16]
  cmp edx, [ebp+8]
  ja @@GT
  je @@EQ
@@LT:
  dec eax
  dec eax
@@GT:
  inc eax
@@EQ:
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor rax, rax
  cmp rcx, rdx
  jg @@GT
  je @@EQ
@@LT:
  dec rax
  dec rax
@@GT:
  inc rax
@@EQ:
{$ENDIF WIN64}
end;

function CmpW64(const a, b : UInt64) : Integer;
asm
{$IFDEF WIN32}
  xor eax, eax
  mov edx, [ebp+20]
  cmp edx, [ebp+12]
  ja @@GT
  jb @@LT
  mov edx, [ebp+16]
  cmp edx, [ebp+8]
  ja @@GT
  je @@EQ
@@LT:
  dec eax
  dec eax
@@GT:
  inc eax
@@EQ:
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor rax, rax
  cmp rcx, rdx
  ja @@GT
  je @@EQ
@@LT:
  dec rax
  dec rax
@@GT:
  inc rax
@@EQ:
{$ENDIF WIN64}
end;

function CmpPtr(a, b: Pointer): Integer;
asm
{$IFDEF WIN32}
  xor ecx, ecx
  cmp eax, edx
  ja @@GT
  je @@EQ
@@LT:
  dec ecx
  dec ecx
@@GT:
  inc ecx
@@EQ:
  mov eax, ecx
{$ENDIF WIN32}
{$IFDEF WIN64}
  xor rax, rax
  cmp rcx, rdx
  ja @@GT
  je @@EQ
@@LT:
  dec rax
  dec rax
@@GT:
  inc rax
@@EQ:
{$ENDIF WIN64}
end;

function CmpDouble(const a, b : Double) : Integer;
begin
  if      a > b then Result := 1
  else if a < b then Result := -1
  else               Result := 0;
end;


function TwbEnumDef.FindName(const aName: string; out aIndex: Int64): Boolean;
begin
  Result := enDictionary.TryGetValue(aName, aIndex);
end;

function TwbEnumDef.FindSparseName(aSearchIndex: Int64; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;

  L := Low(enSparseNamesMap);
  H := High(enSparseNamesMap);
  while L <= H do begin
    I := (L + H) shr 1;
    C := CmpI64(enSparseNamesMap[I].snIndex, aSearchIndex);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function TwbEnumDef.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
begin
  if aValue = '' then
    Result := 0
  else begin
    var lValue := aValue;

    if wbShowFlagEnumValue and (lValue[Length(lValue)] = ')') then begin
      // remove an integer value of enum from enum string value
      var lOpenParensIdx := LastDelimiter('(', lValue);
      var lDummy: Integer;
      if (lOpenParensIdx > 0) and TryStrToInt(Copy(lValue, Succ(lOpenParensIdx), Length(lValue) - Succ(lOpenParensIdx)), lDummy) then
        Delete(lValue, Pred(lOpenParensIdx), Length(lValue));
    end;

    if enDictionary.TryGetValue(lValue, Result) then
      Exit;

    (*
    {Try exact match first}
    for i := Low(enNames) to High(enNames) do
      if SameStr(enNames[i], Value) then begin
        Result := i;
        Exit;
      end;
    for i := Low(enSparseNames) to High(enSparseNames) do with enSparseNames[i] do
      if SameStr(snName, Value) then begin
        Result := snIndex;
        Exit;
      end;
    {Now try case insensitive}
    for i := Low(enNames) to High(enNames) do
      if SameText(enNames[i], Value) then begin
        Result := i;
        Exit;
      end;
    for i := Low(enSparseNames) to High(enSparseNames) do with enSparseNames[i] do
      if SameText(snName, Value) then begin
        Result := snIndex;
        Exit;
      end;
    *)

    Result := StrToInt64(lValue);
  end;
end;

function TwbEnumDef.GetDefTypeName: string;
var
  i: Integer;
begin
  if Length(enNames)=0 then
    inherited
  else begin
    Result := '('+enNames[Low(enNames)];
    for i := 1 to High(enNames) do
      Result := Result+','+enNames[i];
    Result := Result+')'
  end;
end;

function TwbEnumDef.GetEditInfo(const aElement: IwbElement): TwbStringArray;
begin
  Result := Copy(enEditInfo);
end;

function TwbEnumDef.GetEditType(const aElement: IwbElement): TwbEditType;
begin
  Result := etComboBox;
end;

function TwbEnumDef.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbEnumDef.GetName(aIndex: Int64): string;
begin
  if (aIndex >= Low(enNames)) and (aIndex <= High(enNames)) then
    Result := enNames[aIndex]
  else
    Result := '';

  if Result = '' then begin
    var lSparseIdx := -1;
    if FindSparseName(aIndex, lSparseIdx) then
      Result := enSparseNamesMap[lSparseIdx].snName;
  end;
end;

function TwbEnumDef.GetNameCount: Integer;
begin
  Result := Length(enNames);
end;

procedure TwbEnumDef.Report(const aParents: TwbDefPath);
var
  i, j: Integer;
  sl: TStringList;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if wbReportMode and wbReportUnknownEnums and Assigned(UnknownEnums) then begin
    WriteLn('Unknown Enums in: ', wbDefsToPath(aParents), wbDefToName(Self));
    for i := 0 to Pred(UnknownEnums.Count) do begin
      sl := UnknownEnums.Objects[i] as TStringList;
      WriteLn('  ', UnknownEnums[i], ' (',sl.Count,')' );
      for j := 0 to Pred(sl.Count) do
        WriteLn('    ', sl[j], ' (',Integer(sl.Objects[j]),')' );
    end;
  end;

  defReported := True;
end;

function TwbEnumDef.StringFromEditValue(const aValue: string; const aElement: IwbElement): string;
begin
  if aValue = '' then
    Exit(aValue);

  var lIndex: Int64;
  if FindName(aValue, lIndex) then
    Exit(GetName(lIndex));

  Result := aValue;
end;

function TwbEnumDef.Check(const aString: string; const aElement: IwbElement): string;
begin
  if aString = '' then
    Exit(aString);

  var lIndex: Int64;
  if FindName(aString, lIndex) then
    Exit('');

  Result := '<Unknown: ' + aString + '>';
end;

function TwbEnumDef.ToSortKey(const aString: string; const aElement: IwbElement): string;
begin
  if aString = '' then
    Exit(aString);

  var lIndex: Int64;
  if FindName(aString, lIndex) then
    Exit(GetName(lIndex));

  Result := aString;
end;

function TwbEnumDef.ToString(const aString: string; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  if aString = '' then
    Exit(aString);

  var lIndex: Int64;
  if FindName(aString, lIndex) then
    Exit(GetName(lIndex));

  Result := '<Unknown: ' + aString + '>';

  if wbReportMode and wbReportUnknownEnums then begin
    if not Assigned(UnknownEnums) then
      UnknownEnums := TwbFastStringListIC.CreateSorted;
    var lUnknownIndex: Integer;
    if not UnknownEnums.Find(Result, lUnknownIndex) then
      lUnknownIndex := UnknownEnums.AddObject(Result, TwbFastStringListIC.CreateSorted);
    with UnknownEnums.Objects[lUnknownIndex] as TStringList do begin
      if Count < 10 then begin
        var lPath := aElement.FullPath;
        var lPathIndex: Integer;
        if not Find(lPath, lPathIndex) then
          lPathIndex := Add(lPath);
        Objects[lPathIndex] := TObject(Succ(Integer(Objects[lPathIndex])));
      end;
    end;
  end;
end;

function TwbEnumDef.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
var
  i: Integer;
begin
  Result := '';

  if (aInt >= Low(enNames)) and (aInt <= High(enNames)) then begin
    Result := enNames[aInt];
    if wbShowFlagEnumValue then
      Result := Result + ' (' + IntToStr(aInt) + ')';
  end;

  if Result = '' then
    if FindSparseName(aInt, i) then begin
      Result := enSparseNamesMap[i].snName;
      if wbShowFlagEnumValue then
        Result := Result + ' (' + IntToStr(enSparseNamesMap[i].snIndex) + ')';
    end;

  if Result = '' then begin
    Result := IntToStr(aInt);
    if wbShowFlagEnumValue then
      Result := Result + ' (' + IntToStr(aInt) + ')';
  end;
end;

function TwbEnumDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := ''; {handled by IntegerDef}
end;

function TwbEnumDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  s: string;
  i: Integer;
begin
  Result := '';

  if (aInt >= Low(enNames)) and (aInt <= High(enNames)) then begin
    if aForSummary then
      Result := enSummaries[aInt]
    else
      Result := enNames[aInt];
    if wbShowFlagEnumValue and (Result <> '') then
      Result := Result + ' (' + IntToStr(aInt) + ')';
  end;

  if Result = '' then begin
    if FindSparseName(aInt, i) then begin

      if aForSummary then
        Result := enSparseNamesMap[i].snSummary
      else
        Result := enSparseNamesMap[i].snName;

      if wbShowFlagEnumValue then
        Result := Result + ' (' + IntToStr(enSparseNamesMap[i].snIndex) + ')';
    end else begin
      Result := wbGetUnknownIntString(aInt);
      if wbReportMode and wbReportUnknownEnums then begin
        if not Assigned(UnknownEnums) then
          UnknownEnums := TwbFastStringListIC.CreateSorted;
        if not UnknownEnums.Find(Result, i) then
          i := UnknownEnums.AddObject(Result, TwbFastStringListIC.CreateSorted);
        with UnknownEnums.Objects[i] as TStringList do begin
          if Count < 10 then begin
            s := aElement.FullPath;
            if not Find(s, i) then
              i := Add(s);
            Objects[i] := TObject(Succ(Integer(Objects[i])));
          end;
        end;
      end;
    end;
  end;
  Used(aElement, Result);
end;

function TwbEnumDef.ToEditValue(const aString: string; const aElement: IwbElement): string;
begin
  if aString = '' then
    Exit(aString);

  var lIndex: Int64;
  if FindName(aString, lIndex) then
    Exit(GetName(lIndex));

  Result := aString;
end;

{ TwbStringDef }

procedure TwbStringDef.AfterClone(const aSource: TwbDef);
begin
  inherited;
end;

function TwbStringDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  StringDef: IwbStringDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbStringDef, StringDef) and
    ((sdSize = 0) or (StringDef.StringSize = 0) or (sdSize <= StringDef.StringSize));
end;

function TwbStringDef.Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttCheck);

  if Assigned(bsdFormater) then
    Result := bsdFormater.Check(Result, aElement);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctCheck);
end;

constructor TwbStringDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbStringDef do
    Self.Create(defPriority, defRequired, ndName, sdSize, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP, ndTerminator).AfterClone(aSource);
end;

constructor TwbStringDef.Create(aPriority   : TwbConflictPriority;
                                aRequired   : Boolean;
                          const aName       : string;
                                aSize       : Integer;
                                aAfterLoad  : TwbAfterLoadCallback;
                                aAfterSet   : TwbAfterSetCallback;
                                aDontShow   : TwbDontShowCallback;
                                aGetCP      : TwbGetConflictPriority;
                                aTerminator : Boolean;
                                aForward    : Boolean);
begin
  sdSize := aSize;
  sdForward := aForward;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

procedure TwbStringDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
  var lValue := aValue;

  if Assigned(bsdFormater) then
    lValue := bsdFormater.FromEditValue(lValue, aElement);

  FromStringTransform(aBasePtr, aEndPtr, aElement, aValue, ttFromEditValue);
end;

procedure TwbStringDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
begin
  FromStringTransform(aBasePtr, aEndPtr, aElement, aValue, ttFromNativeValue);
end;

procedure TwbStringDef.FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType);
var
  NewSize : Integer;
  b       : TBytes;
begin
  b := bsdGetEncoding(aElement).GetBytes(aValue);

  if sdSize > 0 then
    NewSize := sdSize
  else begin
    NewSize := Length(b);
    if not (dfNoZeroTerminator in defFlags) then
      Inc(NewSize);
  end;

  aElement.RequestStorageChange(aBasePtr, aEndPtr, NewSize + Ord(ndTerminator));

  if sdSize > 0 then begin
    FillChar(aBasePtr^, sdSize, 0);
    NewSize := Length(b);
    if NewSize > sdSize then
      NewSize := sdSize;
    if NewSize > 0 then
      Move(b[0], aBasePtr^, NewSize);
  end else begin
    if NewSize > 1 then
      Move(b[0], aBasePtr^, Length(b));

    if not (dfNoZeroTerminator in defFlags) then
      PByte(aBasePtr)[Pred(NewSize)] := 0;
  end;
  if ndTerminator then
    PAnsiChar(aBasePtr)[NewSize] := AnsiChar(wbTerminator);
end;

procedure TwbStringDef.FromStringTransform(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType);
begin
  FromStringNative(aBasePtr, aEndPtr, aElement, TransformString(aValue, aTransformType, aElement), aTransformType);
end;

function TwbStringDef.GetDefType: TwbDefType;
begin
  Result := dtString;
end;

function TwbStringDef.GetDefTypeName: string;
begin
  Result := 'Terminated string';
end;

function TwbStringDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbStringDef.GetIsVariableSizeInternal: Boolean;
begin
  Result := sdSize = 0;
end;

function TwbStringDef.GetStringSize: Integer;
begin
  Result := sdSize;
end;

function TwbStringDef.SetFormater(const aFormater: IwbStringDefFormater): IwbStringDef;
begin
  if defIsLocked then
    Exit(TwbStringDef(Duplicate).SetFormater(aFormater));

  Result := Self;

  if Assigned(aFormater) then
    bsdFormater := (aFormater as IwbDefInternal).SetParent(Self, False) as IwbStringDefFormater;
end;

function TwbStringDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultNativeValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToNativeValue(aBasePtr, aEndPtr, aElement) <> vdDefaultNativeValue);
    if Result then
      FromNativeValue(aBasePtr, aEndPtr, aElement, vdDefaultNativeValue);
  end else begin
    Result := not Assigned(aBasePtr) or (ToEditValue(aBasePtr, aEndPtr, aElement) <> vdDefaultEditValue);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, vdDefaultEditValue);
  end;
end;

function TwbStringDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if sdSize > 0 then
    Result := sdSize + Ord(ndTerminator)
  else begin
    if aBasePtr = nil then
      Result := 1 + Ord(ndTerminator)
    else begin
      Result := Ord(ndTerminator);
      while NativeUInt(aBasePtr) < NativeUInt(aEndPtr) do begin
        Inc(Result);
        if PAnsiChar(aBasePtr)^ = #0 then
          Exit;

        Inc(PByte(aBasePtr));
      end;
    end;
  end;
end;

function TwbStringDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if sdSize > 0 then
    Result := sdSize + Ord(ndTerminator)
  else
    Result := 1 + Ord(ndTerminator);
end;

function TwbStringDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToEditValue);

  if Assigned(bsdFormater) then
    Result := bsdFormater.ToEditValue(Result, aElement);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbStringDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToNativeValue);
  if Assigned(ndToStr) then begin
    var s: string := Result;
    ndToStr(s, aBasePtr, aEndPtr, aElement, ctToNativeValue);
    Result := s;
  end;
end;

function TwbStringDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := UpperCase(ToStringTransform(aBasePtr, aEndPtr, aElement, ttToSortKey));
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbStringDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToString);

  if Assigned(bsdFormater) then
    Result := bsdFormater.ToString(Result, aElement, False);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
end;

function TwbStringDef.ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string;
var
  lLen, Len  : NativeUInt;
  b          : TBytes;
  i          : Integer;
  s          : string;
  MainRecord : IwbMainRecord;
begin
  Result := '';
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if (Len > 0) and ndTerminator then
    if PByte(aBasePtr)[Pred(Len)] = wbTerminator then
      Dec(Len);

  if sdSize > 0 then begin
    if Len > Cardinal(sdSize) then
      Len := sdSize;
  end;

  if sdForward then begin
    lLen := 0;
    while lLen < Len do begin
      if PByte(aBasePtr)[lLen] = 0 then
        Break;
      Inc(lLen);
    end;
    Len := lLen;
  end else
    while (Len > 0) and (PByte(aBasePtr)[Pred(Len)] = 0) do
      Dec(Len);

  if Len > 0 then begin
    b := BytesOf(aBasePtr, Len);
    try
      Result := bsdGetEncoding(aElement).GetString(b);
      if aTransformType = ttCheck then
        Result := '';
      {
      i := Length(Result);
      j := i;
      while (i > 0) and (Result[i] = #0) do
        Dec(i);
      if i <> j then
        SetLength(Result, i);
      }
    except
      on E: Exception do begin
        Result := '';
        if aTransformType <> ttCheck then
          for i := Low(b) to High(b) do begin
            Result := Result + IntToHex64(b[i], 2);
            if i < High(b) then
              Result := Result + ' ';
          end;

        if aTransformType = ttToString then
          Result := Result + ' <Error: ';

        if aTransformType in [ttToString, ttCheck] then
          Result := Result + Format('Can''t read string: [%s] %s', [E.ClassName, E.Message]);

        if aTransformType = ttToString then
          Result := Result + '>';

        if aTransformType <> ttCheck then begin
          s := '';
          MainRecord := aElement.ContainingMainRecord;
          if Assigned(MainRecord) then
            s := MainRecord.LoadOrderFormID.ToString;
          wbProgress('[%s] [%s] <Error reading string: [%s] %s>', [s, aElement.Path, E.ClassName, E.Message]);
        end
      end;
    end;
    if wbCheckNonCPNChars then
      if aTransformType in [ttToString, ttCheck] then
        if not (dfTranslatable in defFlags) then
          for i := Low(b) to High(b) do
            if not (b[i] in [10, 13, 32..126]) then begin
              if aTransformType = ttToString then
                Result := Result + ' <Warning: ';

              Result := Result + 'non-code page neutral character in non-translatable string';

              if aTransformType = ttToString then
                Result := Result + '>';
              Break;
            end;
  end;

  Used(aElement, Result);
end;

function TwbStringDef.ToStringTransform(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string;
begin
  Result := TransformString(ToStringNative(aBasePtr, aEndPtr, aElement, aTransformType), aTransformType, aElement);
end;

function TwbStringDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToString);

  if Assigned(bsdFormater) then
    Result := bsdFormater.ToString(Result, aElement, True);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

function TwbStringDef.TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string;
var
  i: Integer;
begin
  Result := s;
  if wbShowStringBytes then begin
    if aTransformType = ttToString then begin
      Result := Result + ' [';
      for i := 1 to Length(s) do begin
        Result := Result + IntToHex(Ord(s[i]), 4);
        if i < Length(s) then
          Result := Result + ' ';
      end;
      Result := Result + ']';
    end;
  end;
end;

{ TwbFloatDef }

const
  SingleNaN : Single = 0.0/0.0;
  DoubleNaN : Double = 0.0/0.0;
  SingleInf : Single = 1.0/0.0;
  DoubleInf : Double = 1.0/0.0;

function TwbFloatDef.Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement;
var
  aTargetDataContainer: IwbDataContainer;
  aSourceDataContainer: IwbDataContainer;
begin
  if Supports(aTarget, IwbDataContainer, aTargetDataContainer) and
     Supports(aSource, IwbDataContainer, aSourceDataContainer) and
     Equals(aTarget.ValueDef) and
     Equals(aSource.ValueDef)
  then begin
    var lSourceBasePtr := aSourceDataContainer.DataBasePtr;
    if Assigned(lSourceBasePtr) then begin
      var lSize: Integer;
      case fdKind of
        fkHalf  : lSize := SizeOf(THalfFloat)+Ord(ndTerminator);
        fkSingle: lSize := SizeOf(Single)+Ord(ndTerminator);
      else
        {fkDouble:} lSize := SizeOf(Double)+Ord(ndTerminator);
      end;
      if aSource.DataSize = lSize then begin
        aTargetDataContainer.CopyFrom(lSourceBasePtr, lSize);
        Exit;
      end;
    end;
  end;
  Result := inherited;
end;

function TwbFloatDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  FloatDef: IwbFloatDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbFloatDef, FloatDef);
end;

constructor TwbFloatDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbFloatDef do
    Self.Create(defPriority, defRequired, ndName, ndAfterLoad, ndAfterSet, fdScale, fdDigits, ndDontShow,
      fdNormalizer, fdDefault, defGetCP, fdKind, ndTerminator).AfterClone(aSource);
end;

constructor TwbFloatDef.Create(aPriority   : TwbConflictPriority;
                               aRequired   : Boolean;
                         const aName       : string;
                               aAfterLoad  : TwbAfterLoadCallback;
                               aAfterSet   : TwbAfterSetCallback;
                               aScale      : Extended;
                               aDigits     : Integer;
                               aDontShow   : TwbDontShowCallback;
                               aNormalizer : TwbFloatNormalizer;
                               aDefault    : Extended;
                               aGetCP      : TwbGetConflictPriority;
                               aKind       : TwbFloatKind;
                               aTerminator : Boolean);
begin
  fdDefault := aDefault;
  fdScale := aScale;
  fdDigits := aDigits;
  fdNormalizer := aNormalizer;
  fdKind := aKind;
  if fdDigits <> Low(Integer) then
    if fdDigits < 0 then begin
      fdDigits := wbFloatDigits;
      case fdKind of
        fkHalf: fdDigits := fdDigits div 2;
        fkDouble: fdDigits := fdDigits * 2;
      end;
    end;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

procedure TwbFloatDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
  var lSize: Integer;
  case fdKind of
    fkHalf  : lSize := SizeOf(THalfFloat)+Ord(ndTerminator);
    fkSingle: lSize := SizeOf(Single)+Ord(ndTerminator);
  else
    {fkDouble:} lSize := SizeOf(Double)+Ord(ndTerminator);
  end;
  aElement.RequestStorageChange(aBasePtr, aEndPtr, lSize);

  var lValueString := aValue;
  if Assigned(ndToStr) then
    ndToStr(lValueString, aBasePtr, aEndPtr, aElement, ctFromEditValue);

  lValueString := lValueString.Trim;

  if lValueString = wbIgnoreStringValue then begin
    //do nothing
  end else if lValueString = '' then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := 0;
      fkSingle: PSingle(aBasePtr)^ := 0.0;
      fkDouble: PDouble(aBasePtr)^ := 0.0;
    end;
  end else if SameText(lValueString, 'NaN') then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := HalfNaN;
      fkSingle: PSingle(aBasePtr)^ := SingleNaN;
      fkDouble: PDouble(aBasePtr)^ := DoubleNaN;
    end;
  end else if SameText(lValueString, 'Inf') or SameText(lValueString, '+Inf') then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := HalfPosInf;
      fkSingle: PSingle(aBasePtr)^ := SingleInf;
      fkDouble: PDouble(aBasePtr)^ := DoubleInf;
    end;
  end else if SameText(lValueString, '-Inf') then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := HalfNegInf;
      fkSingle: PSingle(aBasePtr)^ := Single.NegativeInfinity;
      fkDouble: PDouble(aBasePtr)^ := Double.NegativeInfinity;
    end;
  end else if SameText(lValueString, 'Default') or SameText(lValueString, 'Max') then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := HalfPosMax;
      fkSingle: PCardinal(aBasePtr)^ := $7F7FFFFF;
      fkDouble: PInt64(aBasePtr)^ := $7FEFFFFFFFFFFFFF;
    end;
  end else if SameText(lValueString, 'Min') then begin
    case fdKind of
      fkHalf  : PHalfFloat(aBasePtr)^ := HalfNegMax;
      fkSingle: PCardinal(aBasePtr)^ := $FF7FFFFF;
      fkDouble: PInt64(aBasePtr)^ := -$10000000000001 // $FFEFFFFFFFFFFFFF
    end;
  end else begin
    var lValue := StrToFloat(lValueString);
    FromValue(lValue, aBasePtr, aEndPtr, aElement);
    Exit;
  end;

  if ndTerminator then
    PByte(aBasePtr)[Pred(lSize)] := wbTerminator;
end;

procedure TwbFloatDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
var
  lValue : Extended;
begin
  if VarIsClear(aValue) or VarIsNull(aValue) then
    lValue := NaN
  else
    lValue := aValue;
  FromValue(lValue, aBasePtr, aEndPtr, aElement);
end;

procedure TwbFloatDef.FromValue(aValue: Extended; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
begin
  var lSize: Integer;
  case fdKind of
    fkHalf  : lSize := SizeOf(THalfFloat)+Ord(ndTerminator);
    fkSingle: lSize := SizeOf(Single)+Ord(ndTerminator);
  else
    {fkDouble:} lSize := SizeOf(Double)+Ord(ndTerminator);
  end;
  aElement.RequestStorageChange(aBasePtr, aEndPtr, lSize);
  if Assigned(aBasePtr) then begin
    case aValue.SpecialType of
      fsZero, fsNZero, fsDenormal, fsNDenormal: case fdKind of
        fkHalf  : PHalfFloat(aBasePtr)^ := 0;
        fkSingle: PSingle(aBasePtr)^ := 0;
        fkDouble: PDouble(aBasePtr)^ := 0;
      end;
      fsInf: case fdKind of
        fkHalf  : PHalfFloat(aBasePtr)^ := HalfPosInf;
        fkSingle: PSingle(aBasePtr)^ := Single.PositiveInfinity;
        fkDouble: PDouble(aBasePtr)^ := DoubleNaN.PositiveInfinity;
      end;
      fsNInf: case fdKind of
        fkHalf  : PHalfFloat(aBasePtr)^ := HalfNegInf;
        fkSingle: PSingle(aBasePtr)^ := Single.NegativeInfinity;
        fkDouble: PDouble(aBasePtr)^ := Double.NegativeInfinity;
      end;
      fsNaN: case fdKind of
        fkHalf  : PHalfFloat(aBasePtr)^ := HalfNaN;
        fkSingle: PSingle(aBasePtr)^ := SingleNaN;
        fkDouble: PDouble(aBasePtr)^ := DoubleNaN;
      end;
    else
      repeat
        case fdKind of
          fkHalf  : begin
            if (SingleSameValue(aValue, MaxHalf) or (aValue > MaxHalf)) then begin
              PHalfFloat(aBasePtr)^ := HalfPosMax;
              Break;
            end else if (SingleSameValue(aValue, -MaxHalf) or (aValue < -MaxHalf)) then begin
              PHalfFloat(aBasePtr)^ := HalfNegMax;
              Break;
            end;
          end;
          fkSingle: begin
            if (SingleSameValue(aValue, MaxSingle) or (aValue > MaxSingle)) then begin
              PCardinal(aBasePtr)^ := $7F7FFFFF;
              Break;
            end else if (SingleSameValue(aValue, -MaxSingle) or (aValue < -MaxSingle)) then begin
              PCardinal(aBasePtr)^ := $FF7FFFFF;
              Break;
            end;
          end;
          fkDouble:
            if (SameValue(aValue, MaxDouble) or (aValue > MaxDouble)) then begin
              PInt64(aBasePtr)^ := $7FEFFFFFFFFFFFFF;
              Break;
            end else if (SameValue(aValue, -MaxDouble) or (aValue < -MaxDouble)) then begin
              PInt64(aBasePtr)^ := -$10000000000001; // $FFEFFFFFFFFFFFFF
              Break;
            end;
        end;

        if fdDigits >= 0 then
          aValue := RoundToEx(aValue, -fdDigits);

        if fdScale <> 1.0 then
          aValue := aValue / fdScale;

        if Assigned(fdNormalizer) then
          aValue := fdNormalizer(aElement, aValue);

        case fdKind of
          fkHalf  : PHalfFloat(aBasePtr)^ := FloatToHalf(aValue);
          fkSingle: PSingle(aBasePtr)^ := aValue;
          fkDouble: PDouble(aBasePtr)^ := aValue;
        end;
      until True;

      if ndTerminator then
        PByte(aBasePtr)[Pred(lSize)] := wbTerminator;
    end;
  end;
end;

function TwbFloatDef.GetDefType: TwbDefType;
begin
  Result := dtFloat;
end;

function TwbFloatDef.GetDefTypeName: string;
begin
  Result := 'Float';
end;

function TwbFloatDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbFloatDef.GetKind: TwbFloatKind;
begin
  Result := fdKind;
end;

function TwbFloatDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aBasePtr) >= NativeUInt(aEndPtr)) then
    Result := Ord(ndTerminator)
  else
    Result := GetDefaultSize(aBasePtr, aEndPtr, aElement)
end;

function TwbFloatDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
  case fdKind of
    fkHalf  : Result := SizeOf(THalfFloat)+Ord(ndTerminator);
    fkSingle: Result := SizeOf(Single)+Ord(ndTerminator);
    fkDouble: Result := SizeOf(Double)+Ord(ndTerminator);
  end;
end;

function TwbFloatDef.SetDefaultNativeValue(const aValue: Variant): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbFloatDef(Duplicate).SetDefaultNativeValue(aValue));

  Result := Self;
  fdDefault := aValue;
end;

function TwbFloatDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
var
  Value: Extended;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultEditValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToEditValue(aBasePtr, aEndPtr, aElement) <> vdDefaultEditValue);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, vdDefaultEditValue);
  end else begin
    Value := ToNativeValue(aBasePtr, aEndPtr, aElement);
    case fdKind of
      fkHalf  : Result := not Assigned(aBasePtr) or not SingleSameValue(Value, fdDefault); //!!!
      fkSingle: Result := not Assigned(aBasePtr) or not SingleSameValue(Value, fdDefault);
      fkDouble: Result := not Assigned(aBasePtr) or not SameValue(Value, fdDefault);
    end;
    if Result then
      FromNativeValue(aBasePtr, aEndPtr, aElement, fdDefault);
  end;
end;

function TwbFloatDef.ToValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Extended;
var
  Len   : Cardinal;
  Value : Extended;
  ExceptionMask : TArithmeticExceptionMask;
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len < GetDefaultSize(aBasePtr, aEndPtr, aElement) then
    Exit(NaN)
  else begin
    Result := NaN;
    ClearExceptions(False);
    ExceptionMask := GetExceptionMask;
    try
      try
        SetExceptionMask(exAllArithmeticExceptions);
        case fdKind of
          fkHalf: begin
            if PHalfFloat(aBasePtr)^ = HalfPosMax then
              Exit(MaxHalf)
            else if PHalfFloat(aBasePtr)^ = HalfNegMax then
              Exit(-MaxHalf)
            else begin
              Value := HalfToFloat(PHalfFloat(aBasePtr)^);
            end;
          end;
          fkSingle: begin
            if (PCardinal(aBasePtr)^ = $FF7F7FFF) and (dfFloatSometimesBroken in defFlags) then
              Exit(maxSingle)
            else if PCardinal(aBasePtr)^ = $7F7FFFFF then
              Exit(maxSingle)
            else if PCardinal(aBasePtr)^ = $FF7FFFFF then
              Exit(-maxSingle)
            else
              Value := PSingle(aBasePtr)^;
          end;
        else
          {fkDouble:} begin
            if PInt64(aBasePtr)^ = $7FEFFFFFFFFFFFFF then
              Exit(maxDouble)
            else if PInt64(aBasePtr)^ = $FFEFFFFFFFFFFFFF then
              Exit(maxDouble)
            else
              Value := PDouble(aBasePtr)^;
          end;
        end;

        if IsInfinite(Value) or IsNan(Value) then
          Exit(Value)
        else
          if Value <> 0.0 then
            case fdKind of
              fkHalf:   if SingleSameValue(Value, 0.0) then Value := 0.0;
              fkSingle: if SingleSameValue(Value, 0.0) then Value := 0.0;
              fkDouble: if SameValue(Value, 0.0) then Value := 0.0;
            end;

        if SetExceptions([]) * DefaultExceptionFlags <> [] then begin
          if aElement.ShouldReportError(eeReading) then begin
            case fdKind of
              fkHalf:   wbProgress('<Error reading half in "%s": %s>',   [aElement.FullPath, IntToHex(PHalfFloat(aBasePtr)^) ]);
              fkSingle: wbProgress('<Error reading float in "%s": %s>',  [aElement.FullPath, IntToHex(PCardinal(aBasePtr)^)  ]);
              fkDouble: wbProgress('<Error reading double in "%s": %s>', [aElement.FullPath, IntToHex(PInt64(aBasePtr)^)     ]);
            end;
          end;
          Exit(NaN);
        end;

        var lOrgValue := Value;

        if Assigned(fdNormalizer) then
          Value := fdNormalizer(aElement, Value);
        if fdScale <> 1.0 then
          Value := Value * fdScale;
        if fdDigits >= 0 then
          Result := RoundToEx(Value, -fdDigits)
        else
          Result := Value;

        if SetExceptions([]) * DefaultExceptionFlags <> [] then begin
          if aElement.ShouldReportError(eeReading) then begin
            var lOrgValueStr := '';
            try
              lOrgValueStr := FloatToStr(lOrgValue);
            except
              on E: Exception do
                lOrgValueStr := E.ClassName + ': ' + E.Message;
            end;

            case fdKind of
              fkHalf:   wbProgress('<Error scaling/rounding half in "%s": %s %s>',   [aElement.FullPath, IntToHex(PHalfFloat(aBasePtr)^), lOrgValueStr]);
              fkSingle: wbProgress('<Error scaling/rounding float in "%s": %s %s>',  [aElement.FullPath, IntToHex(PCardinal(aBasePtr)^) , lOrgValueStr]);
              fkDouble: wbProgress('<Error scaling/rounding double in "%s": %s %s>', [aElement.FullPath, IntToHex(PInt64(aBasePtr)^)    , lOrgValueStr]);
            end;
          end;
          Exit(NaN);
        end;
      finally
        ClearExceptions(False);
        SetExceptionMask(ExceptionMask);
      end;
    except
      on e: Exception do begin
        Result := NaN;
        if aElement.ShouldReportError(eeReading) then
          wbProgress('<Error reading float in "%s": [%s] %s>', [aElement.FullPath, E.ClassName, E.Message]);
      end;
    end;
  end;
end;

function TwbFloatDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement, False);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbFloatDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
var
  Value: Extended;
begin
  Value := ToValue(aBasePtr, aEndPtr, aElement);
  if IsNaN(Value) then
    VarClear(Result)
  else if Value = MaxHalf then
    Result := MaxHalf
  else if Value = maxDouble then
    Result := maxDouble
  else if Value = maxSingle then
    Result := maxSingle
  else
    Result := Value;
end;

function TwbFloatDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
const
  PlusMinus : array[Boolean] of string = ('+', '-');
begin
  Result := '';
  var lValue := ToValue(aBasePtr, aEndPtr, aElement);
  case lValue.SpecialType of
    fsZero, fsNZero, fsDenormal, fsNDenormal:
      lValue := 0;
    fsNaN:
      Result := StringOfChar(' ', 40);
    fsInf:
      Result := StringOfChar('+', 40);
    fsNInf:
      Result := StringOfChar('-', 40);
  else
    if ((fdKind = fkHalf) and (lValue = MaxHalf)) or
       ((fdKind = fkSingle) and (lValue = maxSingle)) or
       ((fdKind = fkHalf) and (lValue = maxDouble))
    then
      Result := '+' + StringOfChar('9', 39)
    else if ((fdKind = fkHalf) and (lValue = -MaxHalf)) or
            ((fdKind = fkSingle) and (lValue = -maxSingle)) or
            ((fdKind = fkHalf) and (lValue = -maxDouble))
    then
      Result := '-' + StringOfChar('9', 39);

    if Result = '' then begin
      var lEpsilon := Extended.Epsilon;
      case fdKind of
        fkHalf:   lEpsilon := HalfEpsilon;
        fkSingle: lEpsilon := Single.Epsilon;
        fkDouble: lEpsilon := Double.Epsilon;
      end;
      if IsZero(lValue, lEpsilon) then
        lValue := 0;
    end;
  end;

  if Result = '' then begin
    var lAbs := Abs(lValue);
    if fdDigits >= 0 then
      Result := FloatToStrF(lAbs, ffFixed, 40, fdDigits)
    else
      Result := FloatToStrF(lAbs, ffFixed, 40, 19);

    if Length(Result) < 39 then
      Result := StringOfChar('0', 39 - Length(Result)) + Result;

    Result := PlusMinus[lValue < 0] + Result;
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbFloatDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement, True);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
end;

function TwbFloatDef.ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aIncludeWarnings: Boolean): string;
var
  Len   : Cardinal;
  Value : Extended;
begin
  Result := '';
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  var lDefaultSize := GetDefaultSize(aBasePtr, aEndPtr, aElement);
  if Len < lDefaultSize then begin
    if aIncludeWarnings then
      if wbCheckExpectedBytes then
        Result := Format('<Error: Expected %d bytes of data, found %d>', [lDefaultSize, Len])
  end else begin
    Value := ToValue(aBasePtr, aEndPtr, aElement);
    if IsNan(Value) then
      Result := 'NaN'
    else if Value.IsPositiveInfinity then
      Result := 'Inf'
    else if Value.IsNegativeInfinity then
      Result := '-Inf'
    else if
      ((fdKind = fkHalf) and (Value = MaxHalf))
      or
      ((fdKind = fkSingle) and (Value = maxSingle))
      or
      ((fdKind = fkHalf) and (Value = maxDouble))
    then
      Result := 'Default' // 'Max' ??
    else if
      ((fdKind = fkHalf) and (Value = -MaxHalf))
      or
      ((fdKind = fkSingle) and (Value = -maxSingle))
      or
      ((fdKind = fkHalf) and (Value = -maxDouble))
    then
      Result := 'Min'
    else
      if fdDigits >= 0 then
        Result := FloatToStrF(Value, ffFixed, 99, fdDigits)
      else
        Result := FloatToStr(Value);

    if aIncludeWarnings then
      if Len > lDefaultSize then
        if wbCheckExpectedBytes then
          Result := Result + Format(' <Warning: Expected %d bytes of data, found %d>', [lDefaultSize, Len]);
  end;
  Used(aElement, Result);
end;

function TwbFloatDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement, False);
  if Pos('.', Result) > 0 then begin
    var l := Length(Result);
    while l > 1 do
      if AnsiChar(Result[l]) in ['0','.'] then begin
        if Result[l] = '.' then begin
          Dec(l);
          Break;
        end;
        Dec(l);
      end else
        Break;

    SetLength(Result, l);
  end;

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);

  Result := ShortenText(Result);

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

{ TwbChar4 }

procedure TwbChar4.AfterConstruction;
begin
  inherited;
  Include(defFlags, dfCanContainFormID);
end;

procedure TwbChar4.BuildRef(aInt: Int64; const aElement: IwbElement);
var
  U32: Cardinal;
  _File: IwbFile;
  Rec: IwbMainRecord;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  U32 := aInt;

  _File := aElement._File;
  if Assigned(_File) then begin
    Rec := _File.RecordByEditorID[PwbSignature(@U32)^];
    if Assigned(Rec) then
      aElement.AddReferencedFromID(Rec.LoadOrderFormID); // should always be 00, these are only defined in Oblivion.esm
  end;
end;

function TwbChar4.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbChar4);
end;

constructor TwbChar4.Clone(const aSource: TwbDef);
begin
  with aSource as TwbChar4 do
    Self.Create.AfterClone(aSource);
end;

function TwbChar4.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
const
  Empty : TwbSignature = '    ';
var
  s     : AnsiString;
begin
  if aValue = '' then
    Result := Cardinal(Empty)
  else begin
    s := AnsiString(aValue);
    if Length(s) <> 4 then
      raise Exception.Create('The value must be exactly 4 characters');

    Result := PCardinal(@s[1])^;
  end;
end;

function TwbChar4.FromLinksTo(const aValue, aElement: IwbElement): Int64;
begin
  Result := inherited FromLinksTo(aValue, aElement);
  //!!!
end;

function TwbChar4.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbChar4.GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement;
var
  U32: Cardinal;
  _File: IwbFile;
begin
  Result := nil;
  U32 := aInt;
  _File := aElement._File;
  if Assigned(_File) then
    Result := _File.RecordByEditorID[PwbSignature(@U32)^];
end;

function TwbChar4.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := ToSortKey(aInt, aElement);
end;

function TwbChar4.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
var
  U32: Cardinal;
begin
  U32 := aInt;
  Result := PwbSignature(@U32)^;
end;

function TwbChar4.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  U32: Cardinal;
  _File: IwbFile;
  Rec: IwbRecord;
begin
  U32 := aInt;
  Result := PwbSignature(@U32)^;

  _File := aElement._File;
  if Assigned(_File) then begin
    Rec := _File.RecordByEditorID[Result];
    if Assigned(Rec) then begin
      Result := Rec.Name;
      Used(aElement, Result);
      Exit;
    end;
  end;

  if U32 <> 0 then
    Result := Result + ' <Warning: could not be resolved>';
  Used(aElement, Result);
end;

{ TwbStr4 }

function TwbStr4.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbStr4);
end;

constructor TwbStr4.Clone(const aSource: TwbDef);
begin
  with aSource as TwbStr4 do
    Self.Create.AfterClone(aSource);
end;

function TwbStr4.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
const
  Empty : TwbSignature = '    ';
var
  s     : AnsiString;
  Temp  : AnsiString;
  i     : Integer;
begin
  if aValue = '' then
    Result := Cardinal(Empty)
  else begin
    s := AnsiString(aValue);
    if Length(s) <> 4 then
      raise Exception.Create('The value must be exactly 4 characters');
    Temp := s;
    for i := 1 to 4 do s[i] := Temp[5-i];

    Result := PCardinal(@s[1])^;
  end;
end;

function TwbStr4.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbStr4.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := ToSortKey(aInt, aElement);
end;

function TwbStr4.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := wbStr4ToString(aInt);
end;

function TwbStr4.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  Result := ToSortKey(aInt, aElement);
  Used(aElement, Result);
end;

{ TwbFormIDDefFormater }

procedure TwbFormIDDefFormater.AfterConstruction;
begin
  inherited;
  Include(defFlags, dfCanContainFormID);
end;

function TwbFormIDDefFormater.Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement;
var
  NativeValue : Int64;
  FormID      : TwbFormID;
begin
  Result := nil;
  if not Assigned(aTarget) then
    Exit;

  if Assigned(aSource) then begin
    var lMainRecord: IwbMainRecord;
    if Supports(aSource, IwbMainRecord, lMainRecord) then begin
      if not IsValidMainRecord(lMainRecord) then
        Exit;

      FormID := lMainRecord.LoadOrderFormID;
      //NativeValue := FormID.ToCardinal;
    end else begin
      NativeValue := aSource.NativeValue;
      FormID := TwbFormID.FromCardinal(NativeValue);

      if not (FormID.IsHardcoded or FormID.IsNone) then begin
        var SourceFile := aSource._File;
        if Assigned(SourceFile) then
          FormID := SourceFile.FileFormIDtoLoadOrderFormID(FormID, aSource.MastersUpdated)
        else
          raise Exception.Create('Source has no File');
      end;
    end;

    if not (dfUseLoadOrder in defFlags) then
      if not (FormID.IsHardcoded or FormID.IsNone) then begin
        var TargetFile := aTarget._File;
        if Assigned(TargetFile) then begin
          if dfUnmappedFormID in defFlags then begin
            if FormID.FileID.FullSlot <> 0 then
              raise Exception.Create('Unmapped FormIDs must belong to File ID [00]');
            if TargetFile.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
              if (TargetFile.MasterCount[True] < 1) or (TargetFile.Masters[0, True].FileStates * [fsIsGameMaster] = []) then
                raise Exception.Create('Unmapped FormIDs can only be different from 00000000 in modules which have the game master as their first master.');
          end;

          FormID := TargetFile.LoadOrderFormIDtoFileFormID(FormID, aTarget.MastersUpdated);
        end else
          raise Exception.Create('Target has no File');
      end;

    NativeValue := FormID.ToCardinal;
  end else
    NativeValue := 0;

  aTarget.NativeValue := NativeValue;
end;

procedure TwbFormIDDefFormater.BuildRef(aInt: Int64; const aElement: IwbElement);
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  if ((aInt < $800) or (aInt = $FFFFFFFF)) and IsValid('ACVA') then
    Exit;

  if dfUseLoadOrder in defFlags then
    Exit;

  if aInt <> 0 then
    aElement.AddReferencedFromID(TwbFormID.FromCardinal(aInt));
end;

function TwbFormIDDefFormater.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbFormID) or Supports(aDef, IwbMainRecordDef);
end;

function TwbFormIDDefFormater.Check(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := '';

  if dfUseLoadOrder in defFlags then
    Exit;

  var lFormID := TwbFormID.FromCardinal(aInt);

  if Assigned(aElement) then begin
    var lFile := aElement._File;
    if Assigned(lFile) then begin
      try
        if (dfUnmappedFormID in defFlags) and not lFormID.IsNull then begin
          if lFile.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
            if (lFile.MasterCount[True] < 1) or (lFile.Masters[0, True].FileStates * [fsIsGameMaster] = []) then
              Exit('['+lFormID.ToString(False)+'] <Error: Unmapped FormIDs can only be different from 00000000 in modules which have the game master as their first master>');
        end;

        if lFormID.ObjectID < $800 then
          if not lFile.AllowHardcodedRangeUse then
            lFormID.FileID := TwbFileID.Null;

        var lMainRecord: IwbMainRecord;
        if lFormID.IsHardcoded then
          lMainRecord := wbGetGameMasterFile.RecordByFormID[lFormID, True, False]
        else
          lMainRecord := lFile.RecordByFormID[lFormID, True, aElement.MastersUpdated];

        if Assigned(lMainRecord) then
          Exit;

        if wbDisplayLoadOrderFormID then
          lFormID := lFile.FileFormIDtoLoadOrderFormID(lFormID, aElement.MastersUpdated);
      except
        on E: Exception do begin
          Result := E.Message;
          Exit;
        end;
      end;
    end;
  end;

  if dfUnmappedFormID in defFlags then begin
    if lFormID.FileID.FullSlot <> 0 then
      Exit('['+lFormID.ToString(False)+'] <Error: Unmapped FormIDs must belong to File ID [00]>');
  end;

  if not lFormID.IsHardcoded then
    Result := '['+lFormID.ToString(False)+'] <Error: Could not be resolved>';
end;

function TwbFormIDDefFormater.CheckFlst(const aMainRecord: IwbMainRecord): Boolean;
begin
  Result := True;
end;

constructor TwbFormIDDefFormater.Clone(const aSource: TwbDef);
begin
  with aSource as TwbFormIDDefFormater do
    Self.Create.AfterClone(aSource);
end;

function TwbFormIDDefFormater.CompareExchangeFormID(var aInt: Int64; aOldFormID: TwbFormID; aNewFormID: TwbFormID; const aElement: IwbElement): Boolean;
var
  _File     : IwbFile;
begin
  Result := False;

  if {(aInt < $800) or} (aInt = $FFFFFFFF) and IsValid('ACVA') then // Allows source to be reserverd as this does NOT change the record itself
    Exit;

  if aOldFormID = aNewFormID then
    Exit;

  if dfUseLoadOrder in defFlags then begin
    if aInt = aOldFormID.ToCardinal then
      aInt := aNewFormID.ToCardinal;
  end else
    if Assigned(aElement) then begin
      _File := aElement._File;
      if Assigned(_File) then begin
        //aInt is a file specific FormID
        //aOldFormID and aNewFormID are load order specific
        if _File.FileFormIDtoLoadOrderFormID(TwbFormID.FromCardinal(aInt), aElement.MastersUpdated) = aOldFormID then begin
          aInt := _File.LoadOrderFormIDtoFileFormID(aNewFormID, aElement.MastersUpdated).ToCardinal;
          Result := True;
        end;
      end;
    end;
end;

function TwbFormIDDefFormater.FindRecordForAVCode(aInt: Int64; const aElement: IwbElement): IwbMainRecord;
var
  CheckedFiles : TList;
  MaxLoadOrder : Integer;

  function CheckFile(aFile: IwbFile): IwbMainRecord;
  var
    Group : IwbContainerElementRef;
    i     : Integer;
    AV    : Variant;
  begin
    if CheckedFiles.IndexOf(Pointer(aFile)) >= 0 then
      Exit(nil);
    CheckedFiles.Add(Pointer(aFile));

    if Supports(aFile.GroupBySignature['MISC'], IwbContainerElementRef, Group) then begin
      for i := 0 to Pred(Group.ElementCount) do
        if Supports(Group.Elements[i], IwbMainRecord, Result) then begin
          Result := Result.HighestOverrideOrSelf[MaxLoadOrder];
          if (Result.Flags._Flags and $000000C0) = $000000C0 then begin
            AV := Result.ElementNativeValues['DATA\Actor Value'];
            if not (VarIsNull(AV) or VarIsEmpty(AV)) then begin
              if AV = aInt then
                Exit;
            end;
          end;
        end;
    end;
    Result := nil;
    for i := Pred(aFile.MasterCount[aElement.MastersUpdated]) downto 0 do begin
      Result := CheckFile(aFile.Masters[i, aElement.MastersUpdated]);
      if Assigned(Result) then
        Exit;
    end;
  end;

var
  _File : IwbFile;
begin
  Result := nil;

  if not Assigned(aElement) then
    Exit;

  _File := aElement._File;
  if not Assigned(_File) then
    Exit;

  if aInt < $800 then begin
    CheckedFiles := TList.Create;
    try
      MaxLoadOrder := _File.LoadOrder;
      Result := CheckFile(_File);
    finally
      CheckedFiles.Free;
    end;
  end else try
    Result := _File.RecordByFormID[TwbFormID.FromCardinal(aInt), True, aElement.MastersUpdated];
  except end;
end;

procedure TwbFormIDDefFormater.FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement);
var
  OldValue   : Cardinal;
  FileID     : Integer;
begin
  if dfUseLoadOrder in defFlags then
    Exit;
  if (aInt < $800) or (aInt = $FFFFFFFF) and IsValid('ACVA') then
    Exit;

  OldValue := aInt;
  if OldValue <> 0 then begin
    FileID := OldValue shr 24;
    aMasters[FileID] := True;
  end;
end;

function TwbFormIDDefFormater.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
var
  _File     : IwbFile;
  i, j      : Integer;
  s, t      : string;
begin
  s := '';
  t := aValue;
  if wbPrettyFormID then
    t := StringReplace(t, ' ', '', [rfReplaceAll]);
  i := Pos('[', t);
  j := Pos('"', t);
  if i > 0 then begin
    while i > 0 do begin
      if (j > 0) and (j < i) then begin
        Inc(j);
        if t[j] <> '"' then
          while j < Pred(Length(t)) do begin
            if t[j] = '"' then
              if t[Succ(j)] = '"' then
                Inc(j)
              else
                Break;
            Inc(j);
          end;
        Delete(t, 1, j);
        i := Pos('[', t);
        j := Pos('"', t);
        Continue;
      end;
      Delete(t, 1, i);
      i := Pos(']', t);
      if i > 0 then begin
        s := Copy(t, 1, Pred(i));
        Delete(t, 1, i);
        if (Length(s) in [13,14]) and (s[5] = ':') then
          Delete(s, 1, 5);
      end;

      try
        StrToInt64('$' + s);
        if Length(s) in [8, 9] then
          i := 0
        else
          i := Pos('[', t);
      except
        i := Pos('[', t);
      end;
      j := Pos('"', t);
    end;
  end else begin
    s := Trim(t);
    if (Length(s) in [13,14]) and (s[5] = ':') then
      Delete(s, 1, 5);
  end;

  if Length(s) in [8,9] then
    Result := StrToInt64('$' + s)
  else begin
    if IsValid('ACVA') and SameText(Trim(aValue), 'None') then begin
      Result := $FF;
      Exit;
    end else begin
      if SameText(aValue.Trim, 'Self') and Assigned(aElement) then begin
        var lContainingMainRecord := aElement.ContainingMainRecord;
        if not Assigned(lContainingMainRecord) then
          raise Exception.Create('Can not resolve Self without a ContainingMainRecord');
        Result := lContainingMainRecord.LoadOrderFormID.ToCardinal;
      end else
        Result := StrToInt64('$' + aValue);
    end;
  end;

  if (Result <> 0) and (dfUnmappedFormID in defFlags) then begin
    var lFormID := TwbFormID.FromCardinal(Result);
    if lFormID.FileID.FullSlot <> 0 then
      raise Exception.Create('Unmapped FormIDs must belong to File ID [00]');
  end;

  if dfUseLoadOrder in defFlags then
    Exit;

  if not wbDisplayLoadOrderFormID then
    Exit;

  if Result = $FFFFFFFF then
    Exit;

  if Assigned(aElement) then begin
    _File := aElement._File;
    if Assigned(_File) then begin

      if (Result <> 0) and (dfUnmappedFormID in defFlags) then begin
        if _File.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
          if (_File.MasterCount[True] < 1) or (_File.Masters[0, True].FileStates * [fsIsGameMaster] = []) then
            raise Exception.Create('Unmapped FormIDs can only be different from 00000000 in modules which have the game master as their first master.');
      end;

      if not _File.AllowHardcodedRangeUse then
        if Result < $800 then
          Exit;

      //Result is a load order FormID right now, we need to store a file specific FormID
      Result := _File.LoadOrderFormIDtoFileFormID(TwbFormID.FromCardinal(Result), aElement.MastersUpdated).ToCardinal;
    end;
  end;
end;

function TwbFormIDDefFormater.FromLinksTo(const aValue, aElement: IwbElement): Int64;
var
  MainRecord : IwbMainRecord;
  _File      : IwbFile;
  FormID     : TwbFormID;
begin
  Result := 0;

  if not Assigned(aValue) then
    Exit;
  if not Assigned(aElement) then
    Exit;
  if not Supports(aValue, IwbMainRecord, MainRecord) then
    Exit;
  _File := aElement._File;
  if not Assigned(_File) then
    Exit;
  FormID := MainRecord.LoadOrderFormID;
  if not (dfUseLoadOrder in defFlags) then
    FormID := _File.LoadOrderFormIDtoFileFormID(FormID, aElement.MastersUpdated);

  if not FormID.IsNull and (dfUnmappedFormID in defFlags) then begin
    if FormID.FileID.FullSlot <> 0 then
      raise Exception.Create('Unmapped FormIDs must belong to File ID [00]');
    if _File.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
      if (_File.MasterCount[True] < 1) or (_File.Masters[0, True].FileStates * [fsIsGameMaster] = []) then
        raise Exception.Create('Unmapped FormIDs can only be different from 00000000 in modules which have the game master as their first master.');
  end;

  Result := FormID.ToCardinal;
end;

function TwbFormIDDefFormater.GetEditInfo(const aElement: IwbElement): TwbStringArray;
var
  ACVAIsValid : Boolean;
  Strings     : TStringList;
  CheckAll    : Boolean;
  Wait        : IwbWaitForm;
  FilesProg   : IwbProgress;
  ProcessedGM : Boolean;
  PlayerAdded : Boolean;

  procedure Process(const aFile: IwbFile; aHardcodedOnly: Boolean);
  var
    i, j        : Integer;
    s           : string;
    MainRecord  : IwbMainRecord;
    GroupRecord : IwbGroupRecord;
    GroupsProg  : IwbProgress;
    RecordsProg : IwbProgress;
  begin
    ProcessedGM := ProcessedGM or (fsIsGameMaster in aFile.FileStates);

    if aHardcodedOnly or CheckAll then begin
      for i := 0 to Pred(aFile.RecordCount) do begin
        MainRecord := aFile.Records[i];
        if aHardcodedOnly and not MainRecord.FixedFormID.IsHardcoded then
          Break;

        if IsValid(MainRecord.Signature) and IsValidMainRecord(MainRecord) then begin
          if MainRecord.CanHaveEditorID and (MainRecord.EditorID = '') then
            Continue;

          if wbEditInfoUseShortName then
            s := Trim(MainRecord.ShortName)
          else
            s := Trim(MainRecord.Name);
          if s <> '' then begin
            if s[1] = '<' then
              Delete(s, 1, 1);

            if CheckFlst(MainRecord) then begin
              PlayerAdded := PlayerAdded or MainRecord.FixedFormID.IsPlayer;
              Strings.Add(s);
            end;

            if not Assigned(RecordsProg) then
              RecordsProg := Wait.CreateProgress('Records', s, Pred(aFile.RecordCount) )
            else
              RecordsProg.UpdateStatus(i, s);
          end;
        end;

        if Wait.IsCanceled then
          Exit;
      end;
    end else
      for i := 0 to Pred(aFile.ElementCount) do begin

        if not Assigned(GroupsProg) then
          GroupsProg := Wait.CreateProgress('Groups', aFile.Elements[i].Name, Pred(aFile.ElementCount) )
        else
          GroupsProg.UpdateStatus(i, aFile.Elements[i].Name);

        if Supports(aFile.Elements[i], IwbGroupRecord, GroupRecord) then
          if GroupRecord.GroupType = 0 then
            if IsValid(TwbSignature(GroupRecord.GroupLabel)) then
              for j := 0 to Pred(GroupRecord.ElementCount) do begin

                if Supports(GroupRecord.Elements[j], IwbMainRecord, MainRecord) then begin
                  if IsValid(MainRecord.Signature) and IsValidMainRecord(MainRecord) then begin
                    if MainRecord.CanHaveEditorID and (MainRecord.EditorID = '') then
                      Continue;

                    if wbEditInfoUseShortName then
                      s := Trim(MainRecord.ShortName)
                    else
                      s := Trim(MainRecord.Name);
                    if s <> '' then begin
                      if s[1] = '<' then
                        Delete(s, 1, 1);

                      if CheckFlst(MainRecord) then begin
                        PlayerAdded := PlayerAdded or MainRecord.FixedFormID.IsPlayer;
                        Strings.Add(s);
                      end;

                      if not Assigned(RecordsProg) then
                        RecordsProg := Wait.CreateProgress('Records', s, Pred(GroupRecord.ElementCount) )
                      else
                        RecordsProg.UpdateStatus(j, s);

                    end;
                  end;
                end;

                if Wait.IsCanceled then
                  Exit;
              end;

        if Wait.IsCanceled then
          Exit;
      end;

    for i := 0 to Pred(aFile.InjectedRecordCount) do begin
      MainRecord := aFile.InjectedRecords[i];
      if aHardcodedOnly and not MainRecord.FixedFormID.IsHardcoded then
        Break;

      if IsValid(MainRecord.Signature) and IsValidMainRecord(MainRecord) then begin
        if MainRecord.CanHaveEditorID and (MainRecord.EditorID = '') then
          Continue;

        if wbEditInfoUseShortName then
          s := Trim(MainRecord.ShortName)
        else
          s := Trim(MainRecord.Name);
        if s <> '' then begin
          if s[1] = '<' then
            Delete(s, 1, 1);

          if CheckFlst(MainRecord) then begin
            PlayerAdded := PlayerAdded or MainRecord.FixedFormID.IsPlayer;
            Strings.Add(s);
          end;

          if not Assigned(RecordsProg) then
            RecordsProg := Wait.CreateProgress('Injected Records', s, Pred(aFile.InjectedRecordCount) )
          else
            RecordsProg.UpdateStatus(i, s);
        end;
      end;

      if Wait.IsCanceled then
        Exit;
    end;
  end;

var
  _File : IwbFile;
  i     : Integer;
  s     : string;
begin
  Result := nil;

  if not wbDisplayLoadOrderFormID then
    Exit;

  ACVAIsValid := IsValid('ACVA');

  if Assigned(aElement) then begin
    _File := aElement._File;
    if Assigned(_File) then begin
      if _File.GetCachedEditInfo(GetExactIdent, Result) then
        Exit;

      Strings := TwbFastStringListIC.Create;
      try
        CheckAll :=
          IsValid('CELL') or
          IsValid('LAND') or
          IsValid('ROAD') or
          IsValid('REFR') or
          IsValid('ACHR') or
          IsValid('ACRE') or
          IsValid('PGRE') or
          IsValid('PGRD') or
          IsValid('PARW') or {>>> Skyrim <<<}
          IsValid('PBAR') or {>>> Skyrim <<<}
          IsValid('PBEA') or {>>> Skyrim <<<}
          IsValid('PFLA') or {>>> Skyrim <<<}
          IsValid('PCON') or {>>> Skyrim <<<}
          IsValid('PHZD') or {>>> Skyrim <<<}
          IsValid('NAVM') or
          IsValid('INFO');

        Wait := wbCreateWaitForm('Building DropDownList', 'The DropDown list is being built. Please Wait...', True, 2000, 500);

        ProcessedGM := False;
        PlayerAdded := False;
        FilesProg := Wait.CreateProgress('Files', _File.Name, _File.MasterCount[aElement.MastersUpdated]);
        Process(_File, False);
        for i := Pred(_File.MasterCount[aElement.MastersUpdated]) downto 0 do if not Wait.IsCanceled then begin
          FilesProg.UpdateStatus( _File.MasterCount[aElement.MastersUpdated] - i, _File.Masters[i, aElement.MastersUpdated].Name );
          Process(_File.Masters[i, aElement.MastersUpdated], False);
        end;
        if not ProcessedGM then
          Process(wbGetGameMasterFile, True);

        Wait := nil;
        FilesProg := nil;

        if ACVAIsValid then begin
          for i := 0 to Pred(wbActorValueEnum.NameCount) do
            Strings.Add(wbActorValueEnum.Names[i] + ' [ACVA:' + IntToHex64(i, 8) + ']');
          Strings.Add(' None [ACVA:000000FF]');
          Strings.Add(' Invalid [ACVA:00000048]');
        end else begin
          if IsValid('NULL') then
            Strings.Add('NULL - Null Reference [00000000]');
          if IsValid('FFFF') then
            Strings.Add('FFFF - None Reference [FFFFFFFF]');
          if IsValid('TRGT') then
            Strings.Add('TARGET - Target Reference [00000000]');
          if not PlayerAdded and IsValid('PLYR') then
            Strings.Add('PlayerRef [00000014]');
        end;

        {WARNING: always ensure the returned strings are sorted. Code in other
                  places depends on it!}
        Strings.Sort;
        s := '';
        for i := Pred(Strings.Count) downto 0 do
          if Strings[i] <> s then
            s := Strings[i]
          else
            Strings.Delete(i);

        Result := Strings.ToStringArray;
        _File.SetCachedEditInfo(GetExactIdent, Result);
      finally
        FreeAndNil(Strings);
      end;
    end;
  end;
end;

function TwbFormIDDefFormater.GetEditType(const aElement: IwbElement): TwbEditType;
begin
  Result := etComboBox;
end;

var
  _ExactIdentMap: TStringList;

function TwbFormIDDefFormater.GetExactIdent: Integer;
var
  ExactIdentString : string;
  i                : Integer;
begin
  if fidExactIdent > 0 then
    Exit(Pred(fidExactIdent));

  if not Assigned(_ExactIdentMap) then begin
    _ExactIdentMap := TStringList.Create;
    _ExactIdentMap.Duplicates := dupError;
    _ExactIdentMap.Sorted := True;
  end;
  ExactIdentString := GetExactIdentString;
  if _ExactIdentMap.Find(ExactIdentString, i) then
    Result := Integer(_ExactIdentMap.Objects[i])
  else begin
    Result := _ExactIdentMap.Count;
    _ExactIdentMap.AddObject(ExactIdentString, Pointer(Result));
  end;
  fidExactIdent := Succ(Result);
end;

function TwbFormIDDefFormater.GetExactIdentString: string;
begin
  Result := ClassName;
end;

function TwbFormIDDefFormater.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbFormIDDefFormater.GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement;
begin
  Result := nil;

  if aInt = 0 then
    Exit;
  if (aInt = $FFFFFFFF) and IsValid('FFFF') then
    Exit;

  if (aInt < $800) and IsValid('ACVA') then
    Exit;

  if dfUseLoadOrder in defFlags then begin
    var lFile: IwbFile;
    if Assigned(aElement) then
      lFile := aElement._File;
    Result := wbRecordByLoadOrderFormID(TwbFormID.FromCardinal(aInt), lFile)
  end else if Assigned(aElement) then begin
    var lFile := aElement._File;
    if Assigned(lFile) then try
      var lFormID := TwbFormID.FromCardinal(aInt);

      if lFormID.ObjectID < $800 then
        if not lFile.AllowHardcodedRangeUse then
          lFormID.FileID := TwbFileID.Null;

      if lFormID.IsHardcoded then
        Result := wbGetGameMasterFile.RecordByFormID[lFormID, True, False]
      else
        Result := lFile.RecordByFormID[lFormID, True, aElement.MastersUpdated];
    except end;

    if Assigned(Result) and (Result.ElementType = etMainRecord) then begin
      var lMainRecord: IwbMainRecord;
      if Supports(Result, IwbMainRecord, lMainRecord) and lMainRecord.IsPartialForm then
        Result := lMainRecord.HighestOverrideVisibleForFile[lFile];
    end;
  end;
end;

function TwbFormIDDefFormater.GetMainRecord(aInt: Int64; const aElement: IwbElement): IwbMainRecord;
begin
  Result := nil;
  if dfUseLoadOrder in defFlags then begin
    var lFile: IwbFile;
    if Assigned(aElement) then
      lFile := aElement._File;
    Result := wbRecordByLoadOrderFormID(TwbFormID.FromCardinal(aInt), lFile)
  end else begin
    if Assigned(aElement) then begin
      var lFile := aElement._File;
      if Assigned(lFile) then try
        var lFormID := TwbFormID.FromCardinal(aInt);

        if lFormID.ObjectID < $800 then
          if not lFile.AllowHardcodedRangeUse then
            lFormID.FileID := TwbFileID.Null;

        if lFormID.IsHardcoded then
          Result := wbGetGameMasterFile.RecordByFormID[lFormID, True, False]
        else
          Result := lFile.RecordByFormID[lFormID, True, aElement.MastersUpdated];

      except end;
    end;
  end;
end;

function TwbFormIDDefFormater.IsValid(const aSignature: TwbSignature): Boolean;
begin
  Result := aSignature <> 'ACVA';
end;

function TwbFormIDDefFormater.IsValidFlst(const aSignature: TwbSignature): Boolean;
begin
  Result := True;
end;

function TwbFormIDDefFormater.IsValidMainRecord(const aMainRecord: IwbMainRecord): Boolean;
begin
  Result := True;
end;

function FixupFormID(aFormID: TwbFormID; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; aAllowHardcodedRangeUse: Boolean): TwbFormID;
var
  FileID : TwbFileID;
  i      : Integer;
begin
  Result := aFormID;

  if Result.IsNull or Result.IsPlayer or Result.IsNone then
    Exit;

  if Result.ObjectID < $800 then
    if aAllowHardcodedRangeUse then begin
      if Result.IsHardcoded then
        Exit;
    end else begin
      Result.FileID := TwbFileID.Null;
      Exit;
    end;

  FileID := Result.FileID;

  if aNewCount > aOldCount then
    if FileID.FullSlot >= aOldCount then begin
      FileID := TwbFileID.CreateFull(aNewCount);
      Result.FileID := FileID;
      Exit;
    end;

  for i := Low(aOld) to High(aOld) do
    if aOld[i] = FileID then begin
      Result.FileID := aNew[i];
      Exit;
    end;

  if aNewCount < aOldCount then
    if FileID.FullSlot >= aOldCount then begin
      FileID := TwbFileID.CreateFull(aNewCount);
      Result.FileID := FileID;
      Exit;
    end;
end;

function TwbFormIDDefFormater.MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64;
begin
  Result := aInt;
  if dfUseLoadOrder in defFlags then
    Exit;
  if (aInt = $FFFFFFFF) and (IsValid('ACVA') or IsValid('FFFF')) then
    Exit;

  var lAllowHardcodedRangeUse := False;
  if Assigned(aElement) then begin
    var lFile := aElement._File;
    if Assigned(lFile) then
      lAllowHardcodedRangeUse := lFile.AllowHardcodedRangeUse;
  end;

  if aInt <> 0 then
    Result := FixupFormID(TwbFormID.FromCardinal(aInt), aOld, aNew, aOldCount, aNewCount, lAllowHardcodedRangeUse).ToCardinal;
end;

procedure TwbFormIDDefFormater.Report(const aParents: TwbDefPath);
var
  i: Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if wbReportMode and not (dfNoReport in defFlags) then
    if wbReportFormIDs then begin
      if Assigned(FoundSignatures) then
        if ClassType = TwbFormIDDefFormater then begin
          WriteLn('Unchecked FormID Formatter: ', wbDefsToPath(aParents), wbDefToName(Self));
          WriteLn('  ', FoundSignatures.CommaText);
          for i := 0 to Pred(FoundSignatures.Count) do
            WriteLn('  ', FoundSignatures.Strings[i], ' (', Integer(FoundSignatures.Objects[i]),')');
        end;
      if Assigned(NotResolved) then begin
        WriteLn('FormID contains unresolvable values: ', wbDefsToPath(aParents), wbDefToName(Self));
        for i := 0 to Pred(NotResolved.Count) do
          WriteLn('  ', NotResolved.Strings[i], ' (', Integer(NotResolved.Objects[i]),')');
      end;
      if Assigned(FoundNotAllowedReferences) then begin
        WriteLn('FormID contains not allowed references: ', wbDefsToPath(aParents), wbDefToName(Self));
        for i := 0 to Pred(FoundNotAllowedReferences.Count) do
          WriteLn('  ', FoundNotAllowedReferences.Strings[i], ' (', Integer(FoundNotAllowedReferences.Objects[i]),')');
      end;
    end;

  defReported := True;
end;

function TwbFormIDDefFormater.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  if wbDisplayLoadOrderFormID then begin
    Result := ToString(aInt, aElement, False);
    if (Length(Result) > 0) and (Result[1] = '<') then
      Delete(Result, 1, 1);
  end else
    Result := IntToHex64(aInt, 8);
end;

function TwbFormIDDefFormater.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
var
  FormID     : TwbFormID;
  MainRecord : IwbMainRecord;
  _File      : IwbFile;
  Sig        : TwbSignature;
  i, j       : Integer;
begin
  FormID := TwbFormID.FromCardinal(aInt);

  if not (dfUseLoadOrder in defFlags) then
    if not (FormID.IsHardcoded or FormID.IsNone) then begin
      MainRecord := GetMainRecord(aInt, aElement);
      if Assigned(MainRecord) then
        try
          FormID := MainRecord.LoadOrderFormID;
        except
          MainRecord := nil;
        end;

      if not Assigned(MainRecord) then
        if wbDisplayLoadOrderFormID then
          if Assigned(aElement) then begin
            _File := aElement._File;
            if Assigned(_File) then
              FormID := _File.FileFormIDtoLoadOrderFormID(FormID, aElement.MastersUpdated);
          end;

    end;

  Result := FormID.ToString(False);

  if Self is TwbFormIDCheckedST then with TwbFormIDCheckedST(Self) do begin
    j := -1;
    if Assigned(MainRecord) then begin
      Sig := MainRecord.Signature;
      for i := Low(fidcValidRefsArr) to High(fidcValidRefsArr) do
        if Sig = fidcValidRefsArr[i] then begin
          j := i;
          Break;
        end;
    end;
    if j >= 0 then
      Result := IntToHex(j, 2) + ':' + Result
    else
      Result := 'XX:' + Result;
  end;
end;

function TwbFormIDDefFormater.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  _File      : IwbFile;
  i          : Integer;
  s          : string;
  FormID     : TwbFormID;
  MainRecord : IwbMainRecord;
begin
  FormID := TwbFormID.FromCardinal(aInt);

  if (FormID.IsHardcoded or FormID.IsNone) and IsValid('ACVA') then begin
    if (aInt = -1) or (aInt = $FF) or (aInt = $FFFFFFFF) then
      Result := ' None [ACVA:000000FF]'
    else if aInt = $48 then
      Result := ' Invalid [ACVA:00000048]'
    else begin
      MainRecord := FindRecordForAVCode(aInt, aElement);
      if Assigned(MainRecord) then
        Result := MainRecord.FullName
      else
        Result := wbActorValueEnum.ToString(aInt, aElement, aForSummary);
      Result := Result + ' [ACVA:' + FormID.ToString(False) + ']';
    end;
    Exit;
  end;

  if aInt = 0 then begin
    if IsValid('TRGT') and not IsValid('NULL') then begin
      if aForSummary then
        Result := 'TARGET'
      else
        Result := 'TARGET - Target Reference ['+FormID.ToString(False)+']';
      if wbReportMode and not (dfNoReport in defFlags) then
        if wbReportFormIDs then begin
          if not Assigned(FoundSignatures) then
            FoundSignatures := TwbFastStringListCS.CreateSorted;
          if not FoundSignatures.Find('TRGT', i) then
            i := FoundSignatures.Add('TRGT');
          FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));
        end;
    end else begin
      if aForSummary then begin
        if dfSummaryExcludeNULL in defFlags then
          Result := ''
        else
          Result := 'NULL'
      end else
        Result := 'NULL - Null Reference ['+FormID.ToString(False)+']';
      if wbReportMode and not (dfNoReport in defFlags) then
        if wbReportFormIDs then begin
          if not Assigned(FoundSignatures) then
            FoundSignatures := TwbFastStringListCS.CreateSorted;
          if not FoundSignatures.Find('NULL', i) then
            i := FoundSignatures.Add('NULL');
          FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));
        end;
    end;
    Used(aElement, Result);
    Exit;
  end else if FormID.IsNone then begin
      if aForSummary then
        Result := 'FFFF'
      else
        Result := 'FFFF - None Reference ['+FormID.ToString(False)+']';
    if wbReportMode and not (dfNoReport in defFlags) then
      if wbReportFormIDs then begin
        if not Assigned(FoundSignatures) then
          FoundSignatures := TwbFastStringListCS.CreateSorted;
        if not FoundSignatures.Find('FFFF', i) then
          i := FoundSignatures.Add('FFFF');
        FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));
      end;
    Used(aElement, Result);
    Exit;
  end;

  if Assigned(aElement) then begin
    _File := aElement._File;
    if Assigned(_File) then begin
      try
        if dfUseLoadOrder in defFlags then begin
          {stored FormID is already a LoadOrder FormID}
          FormID := TwbFormID.FromCardinal(aInt);
          MainRecord := wbRecordByLoadOrderFormID(FormID, _File);
        end else begin
          if FormID.ObjectID < $800 then
            if not _File.AllowHardcodedRangeUse then
              FormID.FileID := TwbFileID.Null;

          if FormID.IsHardcoded then
            MainRecord := wbGetGameMasterFile.RecordByFormID[FormID, True, False]
          else begin
            MainRecord := _File.RecordByFormID[FormID, True, aElement.MastersUpdated];
            if wbDisplayLoadOrderFormID then
              if Assigned(MainRecord) then
                FormID := MainRecord.LoadOrderFormID
              else
                FormID := _File.FileFormIDtoLoadOrderFormID(FormID, aElement.MastersUpdated);
          end;
        end;

        if dfUnmappedFormID in defFlags then begin
          if FormID.FileID.FullSlot <> 0 then
            Exit('['+FormID.ToString(False)+'] <Error: Unmapped FormIDs must belong to File ID [00]>');
          if _File.FileStates * [fsIsGameMaster, fsIsHardcoded] = [] then
            if (_File.MasterCount[True] < 1) or (_File.Masters[0, True].FileStates * [fsIsGameMaster] = []) then
              Exit('['+FormID.ToString(False)+'] <Error: Unmapped FormIDs can only be different from 00000000 in modules which have the game master as their first master>');
        end;

        if Assigned(MainRecord) then begin
          if aForSummary then begin
            if Assigned(aElement) and MainRecord.Equals(aElement.ContainingMainRecord)
              and not (dfSummarySelfAsShortName in aElement.ValueDef.DefFlags)
              and not (dfSummarySelfAsShortName in MainRecord.Def.DefFlags) then
              Result := 'Self'
            else
              Result := MainRecord.ShortName;
          end else
            Result := MainRecord.Name;
          if wbReportMode and not (dfNoReport in defFlags) then
            if wbReportFormIDs then begin
              if not Assigned(FoundSignatures) then
                FoundSignatures := TwbFastStringListCS.CreateSorted;
              if not FoundSignatures.Find(MainRecord.Signature, i) then
                i := FoundSignatures.Add(MainRecord.Signature);
              FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));
            end;

          if wbReportFormIDNotAllowedReferences and (ClassType = TwbFormIDChecked) then with TwbFormIDChecked(Self) do begin
              if fidcValidRefs.IndexOf(MainRecord.Signature) < 0 then begin
                if not Assigned(FoundNotAllowedReferences) then
                  FoundNotAllowedReferences := TwbFastStringListCS.CreateSorted;
                if not FoundNotAllowedReferences.Find(MainRecord.Name, i) then
                  i := FoundNotAllowedReferences.Add(MainRecord.Name);
                FoundNotAllowedReferences.Objects[i] := TObject(Succ(Integer(FoundNotAllowedReferences.Objects[i])));
              end;
          end;

          Used(aElement, Result);
          Exit;
        end;
      except
        on E: Exception do begin
          Result := '['+FormID.ToString(False)+'] <Error: '+E.Message+'>';
          if wbReportMode and not (dfNoReport in defFlags) then
            if wbReportFormIDs then begin
              if not Assigned(FoundSignatures) then
                FoundSignatures := TwbFastStringListCS.CreateSorted;
              if not FoundSignatures.Find('Error', i) then
                i := FoundSignatures.Add('Error');
              FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));
            end;
          Used(aElement, Result);
          Exit;
        end;
      end;
    end;
  end;

  if FormID.IsHardcoded then begin
    s := FormID.ToString(False);
    Result := '['+s+'] <Warning: Could not be resolved, but is possibly hardcoded in the engine>';
    if wbReportMode and not (dfNoReport in defFlags) then
      if wbReportFormIDs then begin
        if not Assigned(FoundSignatures) then
          FoundSignatures := TwbFastStringListCS.CreateSorted;
        if not FoundSignatures.Find('Hardcoded', i) then
          i := FoundSignatures.Add('Hardcoded');
        FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));

        if not Assigned(NotResolved) then
          NotResolved := TwbFastStringListCS.CreateSorted;
        if NotResolved.Count < 50 then begin
          if not NotResolved.Find(s, i) then
            i := NotResolved.Add(s);
          NotResolved.Objects[i] := TObject(Succ(Integer(NotResolved.Objects[i])));
        end;
      end;
  end else begin
    s := FormID.ToString(False);
    Result := '['+s+'] <Error: Could not be resolved>';
    if wbReportMode and not (dfNoReport in defFlags) then
      if wbReportFormIDs then begin
        if not Assigned(FoundSignatures) then
          FoundSignatures := TwbFastStringListCS.CreateSorted;
        if not FoundSignatures.Find('NotResolved', i) then
          i := FoundSignatures.Add('NotResolved');
        FoundSignatures.Objects[i] := TObject(Succ(Integer(FoundSignatures.Objects[i])));

        if not Assigned(NotResolved) then
          NotResolved := TwbFastStringListCS.CreateSorted;
        if NotResolved.Count < 50 then begin
          if not NotResolved.Find(s, i) then
            i := NotResolved.Add(s);
          NotResolved.Objects[i] := TObject(Succ(Integer(NotResolved.Objects[i])));
        end;
      end;
  end;
  Used(aElement, Result);
end;

{ TwbByteArrayDef }

procedure TwbByteArrayDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
end;

function TwbByteArrayDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  ByteArrayDef: IwbByteArrayDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbByteArrayDef, ByteArrayDef);
  if Result and (badSize > 0) then begin
    Result := ByteArrayDef.IsVariableSize or (ByteArrayDef.DefaultSize[nil, nil, nil] <= Integer(badSize));
  end;
end;

constructor TwbByteArrayDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbByteArrayDef do
    Self.Create(defPriority, defRequired, ndName, badSize, ndDontShow,
      badCountCallBack, defGetCP, ndTerminator).AfterClone(aSource);
end;

constructor TwbByteArrayDef.Create(aPriority      : TwbConflictPriority;
                                   aRequired      : Boolean;
                             const aName          : string;
                                   aSize          : Int64;
                                   aDontShow      : TwbDontShowCallback;
                                   aCountCallback : TwbCountCallback;
                                   aGetCP         : TwbGetConflictPriority;
                                   aTerminator    : Boolean);
begin
  Include(defFlags, dfSkipImplicitEdit);
  
  badSize := aSize;
  badCountCallback := aCountCallback;
  inherited Create(aPriority, aRequired, aName, nil, nil, aDontShow, aGetCP, aTerminator);
end;

procedure TwbByteArrayDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
var
  Bytes  : array of Byte;
  i, j   : Integer;
  Prefix : Integer;
begin
  SetLength(Bytes, Length(aValue) div 2);
  i := 1;
  j := 0;
  while i <= Length(aValue) do begin
    case aValue[i] of
      ' ', ',', ';': {allowed whitespace}
        Inc(i);
      '0'..'9', 'a'..'f', 'A'..'F': begin
        if i = Length(aValue) then
          raise Exception.Create('Unexpected end of value. Single digit in hexadecimal pair');
        if aValue[Succ(i)] in ['0'..'9', 'a'..'f', 'A'..'F'] then begin
          Bytes[j] := StrToInt('$'+Copy(aValue,i, 2));
          Inc(j);
          Inc(i, 2);
        end else
          raise Exception.Create('"'+aValue[Succ(i)]+'" at position '+IntToStr(Succ(i))+' is not a valid character for ' + GetName);
      end;
    else
      raise Exception.Create('"'+aValue[i]+'" at position '+IntToStr(i)+' is not a valid character for ' + GetName);
    end;
  end;

  SetLength(Bytes, j);

  case badSize of
    -1 : Prefix := SizeOf(Cardinal);
    -2 : Prefix := SizeOf(Word);
    -4 : Prefix := SizeOf(Byte);
  else
    Prefix := 0;
  end;
  if (badSize > 0) then
    SetLength(Bytes, badSize);

  aElement.RequestStorageChange(aBasePtr, aEndPtr, Length(Bytes)+Prefix);

  if Length(Bytes) > 0 then
    Move(Bytes[0], (PByte(aBasePtr) + Prefix)^, Length(Bytes));
end;

procedure TwbByteArrayDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
var
  Bytes  : TBytes;
  Prefix : Integer;
begin
  Bytes := aValue;

  case badSize of
    -1 : Prefix := SizeOf(Cardinal);
    -2 : Prefix := SizeOf(Word);
    -4 : Prefix := SizeOf(Byte);
  else
    Prefix := 0;
  end;
  if (badSize > 0) then
    SetLength(Bytes, badSize);

  aElement.RequestStorageChange(aBasePtr, aEndPtr, Length(Bytes)+Prefix);

  if Length(Bytes) > 0 then
    Move(Bytes[0], (PByte(aBasePtr) + Prefix)^, Length(Bytes));
end;

function TwbByteArrayDef.GetDefType: TwbDefType;
begin
  Result := dtByteArray;
end;

function TwbByteArrayDef.GetDefTypeName: string;
begin
  if badSize > 0 then
    Result := IntToStr(badSize)+' Bytes Array'
  else if Assigned(badCountCallback) then
    Result := 'Variable Size Byte Array'
  else case badSize of
        -1 : Result := 'Variable Size Byte Array with four bytes length';
        -2 : Result := 'Variable Size Byte Array with two bytes length';
        -4 : Result := 'Variable Size Byte Array with one byte length';
      -255 : Result := 'Null';
         0 : Result := 'Filler for remaining data';
      end
end;

function TwbByteArrayDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
var
  s: string;
begin
  if Assigned(vdEditInfo) then
    Exit(vdEditInfo^);

  Result := nil;
  if Assigned(ndToStr) then
    with TStringList.Create do try
      s := '';
      ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditInfo);
      CommaText := s;
      Result := ToStringArray;
    finally
      Free;
    end;
end;

function TwbByteArrayDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
var
  s: string;
begin
  Result := etDefault;
  if Assigned(ndToStr) then begin
    s := '';
    ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditType);
    if SameText(s, 'ComboBox') then
      Result := etComboBox
    else if SameText(s, 'CheckComboBox') then
      Result := etCheckComboBox
    else begin
      Assert(s = '', 'Invalid result from ToStr ctEditType callback for ' + GetFullPath);
      Result := etDefault;
    end;
  end;
end;

function TwbByteArrayDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbByteArrayDef.GetIsVariableSizeInternal: Boolean;
begin
  Result := badSize <= 0;
end;

function TwbByteArrayDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aBasePtr) >= NativeUInt(aEndPtr)) then
    Result := 0
  else if Assigned(badCountCallback) then
    Result := badCountCallback(aBasePtr, aEndPtr, aElement)
  else begin
    Result := badSize;
    if Assigned(aBasePtr) then
      case Result of
        -1 : Result := PCardinal(aBasePtr)^+SizeOf(Cardinal);
        -2 : Result := PWord(aBasePtr)^+SizeOf(Word);
        -4 : Result := PByte(aBasePtr)^+SizeOf(Byte);
      -255 : Result := 0; // Explicitly null for wbNull (displays better in unions)
         0 : Result := High(Integer);
      end
    else if Result < 0 then Result := 0;
  end;
  if Result>0 then Inc(Result, Ord(ndTerminator));
end;

function TwbByteArrayDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if badSize>=0 then
    Result := badSize
  else
    case badSize of
      -1 : Result := SizeOf(Cardinal);
      -2 : Result := SizeOf(Word);
      -4 : Result := SizeOf(Byte);
    -255 : Result := 0; // Explicitly null for wbNull (displays better in unions)
    else
      Result := 0;
    end;
  if Result>0 then Inc(Result, Ord(ndTerminator));
end;

procedure TwbByteArrayDef.Report(const aParents: TwbDefPath);
var
  FoundOne: Boolean;
  {i,} j, k, l : Integer;
  s: string;
  sl: TStringList;
  BA: TwbByteArrayDef;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  BA := Self;

  s := wbDefsToPath(aParents) + wbDefToName(Self);

  if FoundReflection then begin
    WriteLn('Found Reflection: ', s);
    defReported := True;
    Exit;
  end;

  if (Pos('Hashes', s) < 1) and
     (Pos('SCDA', s) < 1) and
     (Pos('SCTX', s) < 1) and
     (Pos('MODT', s) < 1) and
     (Pos('MO2T', s) < 1) and
     (Pos('MO3T', s) < 1) and
     (Pos('MO4T', s) < 1) and
     (Pos('DMDT', s) < 1) and
     (Pos('NIFT', s) < 1) and
     (Pos('XRGD', s) < 1) and
     (Pos('XCLP', s) < 1) and
     (Pos('RCLR', s) < 1) then begin

    if wbReportUnknownFormIDs then begin
      FoundOne := False;
      with BA do begin
        for j := Low(FoundFormIDAtOffSet) to High(FoundFormIDAtOffSet) do
          if (FoundFormIDAtOffSet[j] > 2) and (NotFoundFormIDAtOffSet[j] = 0) then begin
            if not FoundOne then begin
              FoundOne := True;
              WriteLn('Found FormIDs: ', s);
            end;
            with SignaturesAtOffSet[j] do begin
              WriteLn('  Offset ', j, ': ', Count, ' (', FoundFormIDAtOffSet[j],')');
              for k := 0 to Pred(Count) do begin
                sl := Objects[k] as TStringList;
                WriteLn('    ', Strings[k], ' (', sl.Count,')');
                with sl do
                  for l := 0 to Pred(Count) do
                    WriteLn('      ', Strings[l],' (',Integer(Objects[l]),') ');
              end;
              if Assigned(FormIDsAtOffSetFoundIn[j]) then with FormIDsAtOffSetFoundIn[j] do
                for k := 0 to Pred(Count) do
                  WriteLn('    ', Strings[k]);
            end;
          end;

      end;
    end;

    if wbReportUnknownDoubles then begin
      FoundOne := False;
      with BA do begin
        for j := Low(FoundDoubleAtOffSet) to High(FoundDoubleAtOffSet) do
          if (FoundDoubleAtOffSet[j] > 2) and (NotFoundDoubleAtOffSet[j] = 0) then begin
            if not FoundOne then begin
              FoundOne := True;
              WriteLn('Found Doubles: ', s);
            end;
            with DoublesAtOffSet[j] do begin
              WriteLn('  Offset ', j, ': ', Count, ' (', FoundDoubleAtOffSet[j],')');
              for k := 0 to Pred(Count) do
                WriteLn('    ', Strings[k], ' (', Integer(Objects[k]),')');
            end;
          end;
      end;
    end;

    if wbReportUnknownFloats then begin
      FoundOne := False;
      with BA do begin
        for j := Low(FoundFloatAtOffSet) to High(FoundFloatAtOffSet) do
          if (FoundFloatAtOffSet[j] > 2) and (NotFoundFloatAtOffSet[j] = 0) then begin
            if not FoundOne then begin
              FoundOne := True;
              WriteLn('Found Floats: ', s);
            end;
            with FloatsAtOffSet[j] do begin
              WriteLn('  Offset ', j, ': ', Count, ' (', FoundFloatAtOffSet[j],')');
              for k := 0 to Pred(Count) do
                WriteLn('    ', Strings[k], ' (', Integer(Objects[k]),')');
            end;
          end;
      end;
    end;

    if wbReportUnknownHalfs then begin
      FoundOne := False;
      with BA do begin
        for j := Low(FoundHalfAtOffSet) to High(FoundHalfAtOffSet) do
          if (FoundHalfAtOffSet[j] > 2) and (NotFoundHalfAtOffSet[j] = 0) then begin
            if not FoundOne then begin
              FoundOne := True;
              WriteLn('Found Halfs: ', s);
            end;
            with HalfsAtOffSet[j] do begin
              WriteLn('  Offset ', j, ': ', Count, ' (', FoundHalfAtOffSet[j],')');
              for k := 0 to Pred(Count) do
                WriteLn('    ', Strings[k], ' (', Integer(Objects[k]),')');
            end;
          end;
      end;
    end;

    if wbReportUnknownLStrings then begin
      FoundOne := False;
      with BA do begin
        for j := Low(FoundLStringAtOffSet) to High(FoundLStringAtOffSet) do
          if (FoundLStringAtOffSet[j] > 2) and (NotFoundLStringAtOffSet[j] = 0) then begin
            if not FoundOne then begin
              FoundOne := True;
              WriteLn('Found LStrings: ', s);
            end;
            with LStringsAtOffSet[j] do begin
              WriteLn('  Offset ', j, ': ', Count, ' (', FoundLStringAtOffSet[j],')');
              for k := 0 to Pred(Count) do
                WriteLn('    ', Strings[k], ' (', Integer(Objects[k]),')');
            end;
          end;
      end;
    end;

  end;

  if wbReportUnknownStrings then
    if (FoundString > 0) and (NotFoundString < 1) then begin
      WriteLn('Found Strings: ', s, ': ',Strings.Count,' (', FoundString, ')');
      with Strings do
        for k := 0 to Pred(Count) do
          WriteLn('  ', Strings[k], ' (', Integer(Objects[k]),')');
    end;

  if wbReportEmpty then
    if IsEmpty > 0 then
      if IsNotEmpty > 0 then begin
        if wbReportSometimesEmpty then
          WriteLn('Sometimes Empty: ', s, ': ', IsEmpty, ' (Empty) vs. ', IsNotEmpty, ' (not Empty)')
      end else
        WriteLn('Always Empty: ', s, ': ', IsEmpty, ' (Empty) vs. ', IsNotEmpty, ' (not Empty)');

  defReported := True;
end;

function TwbByteArrayDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
var
  Size : Integer;
  Default : string;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultNativeValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToNativeValue(aBasePtr, aEndPtr, aElement) <> vdDefaultNativeValue);
    if Result then
      FromNativeValue(aBasePtr, aEndPtr, aElement, vdDefaultNativeValue);
  end else begin
    if vdsHasDefaultEditValue in vdStates then
      Default := vdDefaultEditValue
    else begin
      Size := GetSize(aBasePtr, aEndPtr, aElement);
      if (Size > 0) and (Size < High(Integer))  then begin
        Default := '00';
        while Length(Default)<(Size*3-1) do
          Default := Default + ' 00';
      end else
        Default := '';
    end;

    Result := not Assigned(aBasePtr) or (ToString(aBasePtr, aEndPtr, aElement) <> Default);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, Default);
  end;
end;

function TwbByteArrayDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbByteArrayDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
var
  Bytes: TBytes;
begin
  case badSize of
    -1 : aBasePtr := PByte(aBasePtr) + SizeOf(Cardinal);
    -2 : aBasePtr := PByte(aBasePtr) + SizeOf(Word);
    -4 : aBasePtr := PByte(aBasePtr) + SizeOf(Byte);
  end;
  SetLength(Bytes, NativeUInt(aEndPtr) - NativeUInt(aBasePtr));
  if Length(Bytes) > 0 then
    Move(aBasePtr^, Bytes[0], Length(Bytes));
  Result := Bytes;
end;

function CountBits(aCardinal: Cardinal): Integer;
var
  i: Integer;
begin
  Result := 0;
  for I := 0 to 31 do
    if (aCardinal shr i) and 1 = 1 then
      Inc(Result);
end;

function TwbByteArrayDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if dfZeroSortKey in defFlags then begin
    if Length(Result) > 0 then
      Result := StringOfChar('0', Length(Result));
  end else
    if Assigned(ndToStr) then
      ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbByteArrayDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
end;

function TwbByteArrayDef.ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  p: PByte;
{}  _File: IwbFile;
  MainRecord: IwbMainRecord;
  OffSet: Integer;
  aInt: Cardinal;

// Path : string;
  s: string;
  i: Integer;
  f, f2: Single;
begin
  Result := '';
  case badSize of
    -1 : aBasePtr := PByte(aBasePtr) + SizeOf(Cardinal);
    -2 : aBasePtr := PByte(aBasePtr) + SizeOf(Word);
    -4 : aBasePtr := PByte(aBasePtr) + SizeOf(Byte);
  end;
  p := aBasePtr;
  while NativeUInt(p) < NativeUInt(aEndPtr) do begin
    Result := Result + IntToHex64(p^, 2) + ' ';
    Inc(p);
  end;
  SetLength(Result, Length(Result) - 1);

  if wbReportMode and not (dfNoReport in defFlags) then begin
    if Assigned(aElement) and (Self.ndName <> 'Unused') then begin
      _File := aElement._File;

      if wbReportUnknownFormIDs then begin
        p := aBasePtr;
        OffSet := 0;
        while (NativeUInt(p)+3) < NativeUInt(aEndPtr) do begin
          if (OffSet = 0) and (PwbSignature(p)^ = 'BETH') then begin
            FoundReflection := True;
            Exit;
          end;

          aInt := PCardinal(p)^;
          if (aInt <> $0) and (aInt <> $14) and ((Length(NotFoundFormIDAtOffSet) < Succ(OffSet)) or (NotFoundFormIDAtOffSet[Offset] < 1)) then begin
            MainRecord := nil;
            try
              MainRecord := _File.RecordByFormID[TwbFormID.FromCardinal(aInt), True, aElement.MastersUpdated];
            except
              on E: Exception do begin
                MainRecord := nil;
              end;
            end;
            if Length(FoundFormIDAtOffSet) < Succ(Offset) then
              SetLength(FoundFormIDAtOffSet, Succ(Offset));
            if Length(NotFoundFormIDAtOffSet) < Succ(Offset) then
              SetLength(NotFoundFormIDAtOffSet, Succ(Offset));
            if Length(SignaturesAtOffSet) < Succ(Offset) then
              SetLength(SignaturesAtOffSet, Succ(Offset));
            if Length(FormIDsAtOffSetFoundIn) < Succ(Offset) then
              SetLength(FormIDsAtOffSetFoundIn, Succ(Offset));
            if Assigned(MainRecord) then begin
              if (aInt > $14) and (CountBits(aInt) > 4) then begin
                Inc(FoundFormIDAtOffSet[Offset]);
                if not Assigned(SignaturesAtOffSet[Offset]) then
                  SignaturesAtOffSet[Offset] := TwbFastStringListCS.CreateSorted;
                s := MainRecord.Signature;
                if not SignaturesAtOffSet[Offset].Find(s, i) then
                  i := SignaturesAtOffSet[Offset].AddObject(s, TwbFastStringListCS.CreateSorted);
                s := MainRecord.Name;
                with TStringList(SignaturesAtOffSet[Offset].Objects[i]) do
                  if Find(s, i) then
                    Objects[i] := TObject(Succ(Integer(Objects[i])))
                  else
                    if Count < 10 then
                      AddObject(s, TObject(1));

                if not Assigned(FormIDsAtOffSetFoundIn[Offset]) then
                  FormIDsAtOffSetFoundIn[Offset] := TwbFastStringListCS.CreateSorted(dupIgnore);
                if FormIDsAtOffSetFoundIn[Offset].Count < 50 then
                  FormIDsAtOffSetFoundIn[Offset].Add(aElement.FullPath);
              end;
            end else
              Inc(NotFoundFormIDAtOffSet[Offset]);
          end;
          Inc(p,wbReportUnknownStep);
          Inc(OffSet,wbReportUnknownStep);
        end;
      end;

      if wbReportUnknownFloats then begin
        p := aBasePtr;
        OffSet := 0;
        while (NativeUInt(p)+3) < NativeUInt(aEndPtr) do begin
          aInt := PCardinal(p)^;
          f := PSingle(p)^;
          if (aInt <> $0) and ((Length(NotFoundFloatAtOffSet) < Succ(OffSet)) or (NotFoundFloatAtOffSet[Offset] < 1)) then begin

            if Length(FoundFloatAtOffSet) < Succ(Offset) then
              SetLength(FoundFloatAtOffSet, Succ(Offset));
            if Length(NotFoundFloatAtOffSet) < Succ(Offset) then
              SetLength(NotFoundFloatAtOffSet, Succ(Offset));
            if Length(FloatsAtOffSet) < Succ(Offset) then
              SetLength(FloatsAtOffSet, Succ(Offset));

            try
              f2 := RoundToEx(f, -3); {>>> Floating Point Violation <<<}
              if (f2 <> 0) and (Abs(f-f2) < 0.0002) then begin
                if (f2 > -1000000) and (f2 < 1000000) then begin
                  Inc(FoundFloatAtOffSet[Offset]);

                  if not Assigned(FloatsAtOffSet[Offset]) then
                    FloatsAtOffSet[Offset] := TwbFastStringListCS.CreateSorted;

                  s := FloatToStr(RoundToEx(f,-7));
                  var lDotPos := Pos('.', s);
                  if lDotPos > 0 then begin
                    Inc(lDotPos, 7);
                    if Length(s) > lDotPos then
                      SetLength(s, lDotPos);
                  end;

                  with FloatsAtOffSet[Offset] do if Count < 15 then begin
                    if not Find(s, i) then
                      i := AddObject(s, TObject(0));
                    Objects[i] := TObject(Succ(Integer(Objects[i])));
                  end;
                end;

              end else
                Inc(NotFoundFloatAtOffSet[Offset]);
            except
              Inc(NotFoundFloatAtOffSet[Offset]);
            end;

          end;
          Inc(p,wbReportUnknownStep);
          Inc(OffSet,wbReportUnknownStep);
        end;
      end;

      if wbReportUnknownDoubles then begin
        p := aBasePtr;
        OffSet := 0;
        while (NativeUInt(p)+7) < NativeUInt(aEndPtr) do begin
          var lInt64 := PInt64(p)^;
          var d := PDouble(p)^;
          if (lInt64 <> $0) and ((Length(NotFoundDoubleAtOffSet) < Succ(OffSet)) or (NotFoundDoubleAtOffSet[Offset] < 1)) then begin

            if Length(FoundDoubleAtOffSet) < Succ(Offset) then
              SetLength(FoundDoubleAtOffSet, Succ(Offset));
            if Length(NotFoundDoubleAtOffSet) < Succ(Offset) then
              SetLength(NotFoundDoubleAtOffSet, Succ(Offset));
            if Length(DoublesAtOffSet) < Succ(Offset) then
              SetLength(DoublesAtOffSet, Succ(Offset));

            try
              var d2: Double := RoundToEx(d, -6);
              if (d2 <> 0) and (Abs(d-d2) < 0.0000002) then begin
                if (d2 > -100000000000) and (d2 < 100000000000) then begin
                  Inc(FoundDoubleAtOffSet[Offset]);

                  if not Assigned(DoublesAtOffSet[Offset]) then
                    DoublesAtOffSet[Offset] := TwbFastStringListCS.CreateSorted;

                  s := FloatToStr(RoundToEx(d,-10));
                  var lDotPos := Pos('.', s);
                  if lDotPos > 0 then begin
                    Inc(lDotPos, 10);
                    if Length(s) > lDotPos then
                      SetLength(s, lDotPos);
                  end;

                  with DoublesAtOffSet[Offset] do if Count < 15 then begin
                    if not Find(s, i) then
                      i := AddObject(s, TObject(0));
                    Objects[i] := TObject(Succ(Integer(Objects[i])));
                  end;
                end;

              end else
                Inc(NotFoundDoubleAtOffSet[Offset]);
            except
              Inc(NotFoundDoubleAtOffSet[Offset]);
            end;

          end;
          Inc(p,wbReportUnknownStep);
          Inc(OffSet,wbReportUnknownStep);
        end;
      end;


      if wbReportUnknownHalfs then begin
        p := aBasePtr;
        OffSet := 0;
        while (NativeUInt(p)+1) < NativeUInt(aEndPtr) do begin
          var lHalfFloat := PHalfFloat(p)^;
          if (lHalfFloat <> $0) and ((Length(NotFoundHalfAtOffSet) < Succ(OffSet)) or (NotFoundHalfAtOffSet[Offset] < 1)) then begin

            if Length(FoundHalfAtOffSet) < Succ(Offset) then
              SetLength(FoundHalfAtOffSet, Succ(Offset));
            if Length(NotFoundHalfAtOffSet) < Succ(Offset) then
              SetLength(NotFoundHalfAtOffSet, Succ(Offset));
            if Length(HalfsAtOffSet) < Succ(Offset) then
              SetLength(HalfsAtOffSet, Succ(Offset));

            try
              f := HalfToFloat(lHalfFloat);
              f2 := RoundToEx(f, -3);
              if (f2 <> 0) and (Abs(f-f2) < 0.02) then begin
                if (f2 > -High(Word) ) and (f2 < High(Word)) then begin
                  Inc(FoundHalfAtOffSet[Offset]);

                  if not Assigned(HalfsAtOffSet[Offset]) then
                    HalfsAtOffSet[Offset] := TwbFastStringListCS.CreateSorted;

                  s := FloatToStr(RoundToEx(f,-4));
                  var lDotPos := Pos('.', s);
                  if lDotPos > 0 then begin
                    Inc(lDotPos, 4);
                    if Length(s) > lDotPos then
                      SetLength(s, lDotPos);
                  end;

                  with HalfsAtOffSet[Offset] do if Count < 15 then begin
                    if not Find(s, i) then
                      i := AddObject(s, TObject(0));
                    Objects[i] := TObject(Succ(Integer(Objects[i])));
                  end;
                end;

              end else
                Inc(NotFoundHalfAtOffSet[Offset]);
            except
              Inc(NotFoundHalfAtOffSet[Offset]);
            end;

          end;
          Inc(p,wbReportUnknownStep);
          Inc(OffSet,wbReportUnknownStep);
        end;
      end;

      if wbReportUnknownLStrings then
        if Assigned(aElement) and Assigned(aElement._File) and aElement._File.IsLocalized then begin
          p := aBasePtr;
          OffSet := 0;
          while (NativeUInt(p)+3) < NativeUInt(aEndPtr) do begin
            aInt := PCardinal(p)^;
            if (aInt <> $0) and ((Length(NotFoundLStringAtOffSet) < Succ(OffSet)) or (NotFoundLStringAtOffSet[Offset] < 1)) then begin

              if Length(FoundLStringAtOffSet) < Succ(Offset) then
                SetLength(FoundLStringAtOffSet, Succ(Offset));
              if Length(NotFoundLStringAtOffSet) < Succ(Offset) then
                SetLength(NotFoundLStringAtOffSet, Succ(Offset));
              if Length(LStringsAtOffSet) < Succ(Offset) then
                SetLength(LStringsAtOffSet, Succ(Offset));

              try
                if wbLocalizationHandler.GetValue(aInt, aElement, s) then begin
                  Inc(FoundLStringAtOffSet[Offset]);

                  if not Assigned(LStringsAtOffSet[Offset]) then
                    LStringsAtOffSet[Offset] := TwbFastStringListCS.CreateSorted;

                  s := '[' + IntToHex(aInt, 8) + '] ' + s;

                  with LStringsAtOffSet[Offset] do if Count < 15 then begin
                    if not Find(s, i) then
                      i := AddObject(s, TObject(0));
                    Objects[i] := TObject(Succ(Integer(Objects[i])));
                  end;
                end else
                  Inc(NotFoundLStringAtOffSet[Offset]);
              except
                Inc(NotFoundLStringAtOffSet[Offset]);
              end;

            end;
            Inc(p,wbReportUnknownStep);
            Inc(OffSet,wbReportUnknownStep);
          end;
        end;

      if wbReportUnknownStrings then begin
        if (badSize < 1) and (NotFoundString < 1) then begin
          p := aBasePtr;
          while (NativeUInt(p)) < NativeUInt(aEndPtr) do begin
            if p^ < 32 then
              if (Succ(NativeUInt(p)) = NativeUInt(aEndPtr)) and (p^ = 0) then begin
                s := PAnsiChar(aBasePtr);
                if Length(s) > 4 then begin
                  Inc(FoundString);

                  if not Assigned(Strings) then
                    Strings := TwbFastStringListCS.CreateSorted;

                  with Strings do if Count < 15 then begin
                    if not Find(s, i) then
                      i := AddObject(s, TObject(0));
                    Objects[i] := TObject(Succ(Integer(Objects[i])));
                  end;
                end;
              end else begin
                Inc(NotFoundString);
                Break;
              end;

            Inc(p);
          end;
        end;
      end;

      if wbReportEmpty then begin
        if (NativeUInt(aBasePtr)) < NativeUInt(aEndPtr) then
          Inc(IsNotEmpty)
        else
          Inc(IsEmpty);
      end;

    end;
  end;
  Used(aElement, Result);
end;

{ TwbDivDef }

function TwbDivDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := True;
end;

constructor TwbDivDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbDivDef do
    Self.Create(ddValue).AfterClone(aSource);
end;

constructor TwbDivDef.Create(aValue: Integer);
begin
  ddValue := aValue;
  inherited Create;
end;

function TwbDivDef.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
begin
  Result := Round(StrToFloat(aValue) * ddValue);
end;

function TwbDivDef.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbDivDef.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := FloatToStrF(aInt / ddValue, ffFixed, 99, wbFloatDigits);
end;

function TwbDivDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
const
  PlusMinus : array[Boolean] of string = ('+', '-');
begin
  Result := PlusMinus[aInt < 0] + IntToHex64(Abs(aInt), 16);
end;

function TwbDivDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  Result := FloatToStrF(aInt / ddValue, ffFixed, 99, wbFloatDigits);
  Used(aElement, Result);
end;

{ TwbMulDef }

function TwbMulDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := True;
end;

constructor TwbMulDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbMulDef do
    Self.Create(mdValue).AfterClone(aSource);
end;

constructor TwbMulDef.Create(aValue: Integer);
begin
  mdValue := aValue;
  inherited Create;
end;

function TwbMulDef.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
begin
  Result := StrToInt64(aValue) div mdValue;
end;

function TwbMulDef.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbMulDef.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := IntToStr(aInt * mdValue);
end;

function TwbMulDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := ''; {handled by integer def}
end;

function TwbMulDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  Result := IntToStr(aInt * mdValue);
  Used(aElement, Result);
end;

{ TwbCallbackDef }

function TwbCallbackDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  CallbackDef: IwbCallbackDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := Supports(aDef, IwbCallbackDef, CallbackDef) and
    (Pointer(CallbackDef.Callback) = Pointer(GetCallback));
end;

function TwbCallbackDef.Check(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := cdToStr(aInt, aElement, ctCheck);
end;

constructor TwbCallbackDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbCallbackDef do
    Self.Create(cdToStr, cdToInt).AfterClone(aSource);
end;

constructor TwbCallbackDef.Create(const aToStr : TwbIntToStrCallback;
                                  const aToInt : TwbStrToIntCallback);
begin
  cdToStr := aToStr;
  cdToInt := aToInt;
  inherited Create;
end;

function TwbCallbackDef.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
begin
  if Assigned(cdToInt) then
    Result := cdToInt(aValue, aElement)
  else
    Result := StrToInt64(aValue)
end;

function TwbCallbackDef.GetCallback: TwbIntToStrCallback;
begin
  Result := cdToStr;
end;

function TwbCallbackDef.GetEditInfo(const aElement: IwbElement): TwbStringArray;
begin
  with TStringList.Create do try
    CommaText := cdToStr(0, aElement, ctEditInfo);
    Result := ToStringArray;
  finally
    Free;
  end;
end;

function TwbCallbackDef.GetEditType(const aElement: IwbElement): TwbEditType;
var
  s: string;
begin
  //Result := etDefault;
  s := cdToStr(0, aElement, ctEditType);
  if SameText(s, 'ComboBox') then
    Result := etComboBox
  else if SameText(s, 'CheckComboBox') then
    Result := etCheckComboBox
  else begin
    Assert(s = '', 'Invalid result from ToStr ctEditType callback for ' + GetFullPath);
    Result := etDefault;
  end;
end;

function TwbCallbackDef.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbCallbackDef.ToEditValue(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := cdToStr(aInt, aElement, ctToEditValue);
  if Result = '' then
    Result := IntToStr(aInt);
end;

function TwbCallbackDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := cdToStr(aInt, aElement, ctToSortKey);
end;

function TwbCallbackDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  if aForSummary then
    Result := cdToStr(aInt, aElement, ctToSummary)
  else
    Result := cdToStr(aInt, aElement, ctToStr);
  Used(aElement, Result);
end;

{ TwbValueDef }

procedure TwbValueDef.AfterClone(const aSource: TwbDef);
begin
  inherited AfterClone(aSource);
  with aSource as TwbValueDef do begin
    Self.vdStates := Self.vdStates + (vdStates * [vdsHasDefaultEditValue, vdsHasDefaultNativeValue]);
    Self.vdDefaultEditValue := vdDefaultEditValue;
    Self.vdDefaultNativeValue := vdDefaultNativeValue;
    Self.vdLinksToCallback := vdLinksToCallback;
    Self.ndToStr := ndToStr;
    Self.vdEditInfo := vdEditInfo;
    Self.vdSetToDefault := vdSetToDefault;
  end;
end;

procedure TwbValueDef.BuildRef;
begin
  {nothing}
end;

function TwbValueDef.Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctCheck);
end;

function TwbValueDef.CompareExchangeFormID(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aOldFormID, aNewFormID: TwbFormID): Boolean;
begin
  {can be overriden}
  Result := False;
end;

procedure TwbValueDef.FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters);
begin
  {can be overriden}
end;

procedure TwbValueDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
  raise Exception.Create(GetName + ' is not editable.');
end;

procedure TwbValueDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
begin
  raise Exception.Create(GetName + ' is not editable.');
end;

function TwbValueDef.GetCanBeZeroSize: Boolean;
begin
  Result := False;
end;

function TwbValueDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
begin
  if Assigned(vdEditInfo) then
    Exit(vdEditInfo^);
  Result := nil;
end;

function TwbValueDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
begin
  Result := etDefault;
end;

function TwbValueDef.GetElementMap: TDynCardinalArray;
begin
  Result := nil;
end;

function TwbValueDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := wbIsInternalEdit;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbValueDef.GetIsVariableSize: Boolean;
begin
  if not (vdsIsVariableSizeChecked in vdStates) then begin
    if GetIsVariableSizeInternal then
      Include(vdStates, vdsIsVariableSize)
    else
      Exclude(vdStates, vdsIsVariableSize);
    Include(vdStates, vdsIsVariableSizeChecked)
  end;
  Result := vdsIsVariableSize in vdStates;
end;

function TwbValueDef.GetIsVariableSizeInternal: Boolean;
begin
  Result := False;
end;

function TwbValueDef.GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement;
begin
  if Assigned(vdLinksToCallback) then
    Exit(vdLinksToCallback(aElement));

  Result := nil;
end;

function TwbValueDef.IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue: Boolean): IwbValueDef;
begin
  Result := inherited IncludeFlag(aFlag, aOnlyWhenTrue) as IwbValueDef;
end;

function TwbValueDef.MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean;
begin
  Result := False;
  {can be overriden}
end;

function TwbValueDef.SetAfterLoad(const aAfterLoad: TwbAfterLoadCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetAfterLoad(aAfterLoad));

  Result := Self;
  ndAfterLoad := aAfterLoad;
end;

function TwbValueDef.SetAfterSet(const aAfterSet: TwbAfterSetCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetAfterSet(aAfterSet));

  Result := Self;
  ndAfterSet := aAfterSet;
end;

function TwbValueDef.SetDefaultEditValue(const aValue: string): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetDefaultEditValue(aValue));

  vdDefaultEditValue := aValue;
  Include(vdStates, vdsHasDefaultEditValue);
  Result := Self;
end;

function TwbValueDef.SetDefaultNativeValue(const aValue: Variant): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetDefaultNativeValue(aValue));

  vdDefaultNativeValue := aValue;
  Include(vdStates, vdsHasDefaultNativeValue);
  Result := Self;
end;

function TwbValueDef.SetDontShow(const aDontShow: TwbDontShowCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetDontShow(aDontShow));

  Result := Self;
  ndDontShow := aDontShow;
end;

function TwbValueDef.SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetIsRemovable(aCallback));

  Result := Self;
  ndIsRemovable := aCallback;
end;

procedure TwbValueDef.SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement, aValue: IwbElement);
begin
  raise Exception.Create(GetName + ' is not editable.');
end;

function TwbValueDef.SetLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetLinksToCallback(aCallback));

  Result := Self;
  vdLinksToCallback := aCallback;
end;

function TwbValueDef.SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetSummaryLinksToCallback(aCallback));

  Result := Self;
  ndSummaryLinksToCallback := aCallback;
end;

function TwbValueDef.SetSummaryName(const aName: string): IwbValueDef;
begin
  Result := inherited SetSummaryName(aName) as IwbValueDef;
end;

function TwbValueDef.SetSetToDefault(const aCallback: TwbSetToDefaultCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetSetToDefault(aCallback));

  Result := Self;
  vdSetToDefault := aCallback;
end;

function TwbValueDef.SetStaticEditInfo(aEditInfo: PwbStringArray): IwbValueDef;
begin
  Result := Self;

  if vdEditInfo = aEditInfo then
    Exit;

  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetStaticEditInfo(aEditInfo));

  vdEditInfo := aEditInfo;
end;

function TwbValueDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  {can be overriden}
end;

function TwbValueDef.SetToStr(const aToStr: TwbToStrCallback): IwbValueDef;
begin
  if defIsLocked then
    Exit(TwbValueDef(Duplicate).SetToStr(aToStr));

  Result := Self;
  ndToStr := aToStr;
end;

function TwbValueDef.ToEditValue(aBasePtr, aEndPtr: Pointer;
  const aElement: IwbElement): string;
begin
  Result := '';
end;

function TwbValueDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
begin
  VarClear(Result);
end;

function TwbValueDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := UpperCase(ToString(aBasePtr, aEndPtr, aElement));
  if dfZeroSortKey in defFlags then
    if Length(Result) > 0 then
      Result := StringOfChar('0', Length(Result));
end;

function TwbValueDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);
  if Result = '' then
    Result := ShortenText(ToString(aBasePtr, aEndPtr, aElement));

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

{ TwbSubRecordStructSKDef }

constructor TwbSubRecordStructSKDef.Clone(const aSource: TwbDef);
var
  SkipSigs : TwbSignatures;
  i        : Integer;
begin
  with aSource as TwbSubRecordStructSKDef do begin
    if Assigned(srsSkipSignatures) then begin
      SetLength(SkipSigs, srsSkipSignatures.Count);
      for i := 0 to Pred(srsSkipSignatures.Count) do
        SkipSigs[i] := StrToSignature(srsSkipSignatures[i]);
    end;
    Self.Create(defPriority, defRequired, ndName, srsMembers, SkipSigs, srsSortKey, srsExSortKey, ndDontShow, srsAllowUnordered, ndAfterLoad, ndAfterSet, defGetCP).AfterClone(aSource);
  end;
end;

constructor TwbSubRecordStructSKDef.Create(aPriority       : TwbConflictPriority;
                                           aRequired       : Boolean;
                                     const aName           : string;
                                     const aMembers        : array of IwbRecordMemberDef;
                                     const aSkipSigs       : TwbSignatures;
                                     const aSortKey        : array of Integer;
                                     const aExSortKey      : array of Integer;
                                           aDontShow       : TwbDontShowCallback;
                                           aAllowUnordered : Boolean;
                                           aAfterLoad      : TwbAfterLoadCallback;
                                           aAfterSet       : TwbAfterSetCallback;
                                           aGetCP          : TwbGetConflictPriority);
var
  i: Integer;
begin
  SetLength(srsMemberInSK, Length(aMembers));

  SetLength(srsSortKey, Length(aSortKey));
  for i := Low(srsSortKey) to High(srsSortKey) do begin
    Assert( not srsMemberInSK[aSortKey[i]] );
    srsMemberInSK[aSortKey[i]] := True;

    srsSortKey[i] := aSortKey[i];
  end;

  SetLength(srsExSortKey, Length(aExSortKey));
  for i := Low(srsExSortKey) to High(srsExSortKey) do
    srsExSortKey[i] := aExSortKey[i];

  inherited Create(aPriority, aRequired, aName, aMembers, aSkipSigs, aDontShow, aAllowUnordered, aAfterLoad, aAfterSet, aGetCP);
end;

function TwbSubRecordStructSKDef.GetSortKey(aIndex: Integer; aExtended: Boolean): Integer;
begin
  if aIndex <= High(srsSortKey) then
    Result := srsSortKey[aIndex]
  else
    Result := srsExSortKey[aIndex-Length(srsSortKey)];
end;

function TwbSubRecordStructSKDef.GetSortKeyCount(aExtended: Boolean): Integer;
begin
  Result := Length(srsSortKey);
  if aExtended then
    Inc(Result, Length(srsExSortKey));
end;

function TwbSubRecordStructSKDef.IsInSK(aIndex: Integer): Boolean;
begin
  Result := (aIndex >= Low(srsMemberInSK)) and (aIndex <= High(srsMemberInSK)) and srsMemberInSK[aIndex];
end;

function TwbSubRecordStructSKDef.ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if not (dfSummaryNoSortKey in defFlags) then begin
    StructKeysToSummary(aDepth, Result, aElement, srsMembers, srsSortKey, srsSummaryPrefix, srsSummarySuffix, srsSummaryMaxDepth, srsSummaryDelimiter, aLinksTo);
    StructKeysToSummary(aDepth, Result, aElement, srsMembers, srsExSortKey, srsSummaryPrefix, srsSummarySuffix, srsSummaryMaxDepth, srsSummaryDelimiter, aLinksTo);
  end;
  var s := inherited ToSummaryInternal(aDepth, aElement, aLinksTo);
  if s <> '' then begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + s;
  end;
end;

{ TwbFormIDChecked }

function TwbFormIDChecked.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  FormIDChecked : IwbFormIDChecked;
  i             : Integer;
  Dummy         : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if not wbDisableFormIDCheck then begin
    var lMainRecordDef: IwbMainRecordDef;
    if Supports(aDef, IwbMainRecordDef, lMainRecordDef)then begin
      Exit(IsValid(lMainRecordDef.DefaultSignature));
    end else if Supports(aDef, IwbFormIDChecked, FormIDChecked) and not wbDisableFormIDCheck then begin
      Result := False;
      for i := 0 to Pred(FormIDChecked.SignatureCount) do
        if (FormIDChecked.Signatures[i] <> 'NULL') and (FormIDChecked.Signatures[i] <> 'TRGT') then
          if fidcValidRefs.Find(FormIDChecked.Signatures[i], Dummy) then begin
            Result := True;
            Exit;
          end;
      Exit;
    end;
  end;

  Result := inherited CanAssign(aElement, aIndex, aDef);
end;

function TwbFormIDChecked.Check(aInt: Int64; const aElement: IwbElement): string;
var
  FormID: TwbFormID;
  _File: IwbFile;
  MainRecord: IwbMainRecord;
  Found: TwbSignature;
begin
  Result := '';
  if wbDisableFormIDCheck then
    Exit;

  {>>> No ACVA errors <<<}
  if IsValid('ACVA') then
    Exit;

  if dfUseLoadOrder in defFlags then
    Exit;

  FormID := TwbFormID.FromCardinal(aInt);

  if FormID.IsNull then begin
    if IsValid('TRGT') and not IsValid('NULL') then begin
      Found := 'TRGT';
      if fidcValidRefs.IndexOf(Found) < 0 then
        Result := 'Found a TRGT reference, expected: ' + fidcValidRefs.CommaText;
    end else begin
      Found := 'NULL';
      if fidcValidRefs.IndexOf(Found) < 0 then
        Result := 'Found a NULL reference, expected: ' + fidcValidRefs.CommaText;
    end;
    Exit;
  end else if FormID.IsNone then begin
    Found := 'FFFF';
    if fidcValidRefs.IndexOf(Found) < 0 then
      Result := 'Found a None (FFFFFFFF) reference, expected: ' + fidcValidRefs.CommaText;
    Exit;
  end else if FormID.IsPlayer then begin
    Found := 'PLYR';
    if fidcValidRefs.IndexOf(Found) < 0 then
      Result := 'Found a PLYR reference, expected: ' + fidcValidRefs.CommaText;
    Exit;
  end;

  if Assigned(aElement) then begin
    _File := aElement._File;
    if Assigned(_File) then begin
      try
        if FormID.ObjectID < $800 then
          if not _File.AllowHardcodedRangeUse then
            FormID.FileID := TwbFileID.Null;

        if FormID.IsHardcoded then
          MainRecord := wbGetGameMasterFile.RecordByFormID[FormID, True, False]
        else begin
          MainRecord := _File.RecordByFormID[FormID, True, aElement.MastersUpdated];
          if wbDisplayLoadOrderFormID then
            if Assigned(MainRecord) then
              FormID := MainRecord.LoadOrderFormID
            else
              FormID := _File.FileFormIDtoLoadOrderFormID(FormID, aElement.MastersUpdated);
        end;

        if Assigned(MainRecord) then begin
          Found := MainRecord.Signature;
          if fidcValidRefs.IndexOf(Found) < 0 then
            Result := 'Found a '+Found+' reference, expected: ' + fidcValidRefs.CommaText
          else begin
            if fidcPersistent then
              if not MainRecord.WinningOverride.Flags.IsPersistent then begin
                Result := 'Target is not persistent';
                Exit;
              end;
            if not CheckFlst(MainRecord) then
              Result := 'Referenced FLST contains invalid entry';
          end;
          Exit;
        end;
      except
        on E: Exception do begin
          Result := E.Message;
          Exit;
        end;
      end;
    end;
  end;

  if aInt >= $800 then
    Result := '['+FormID.ToString+'] <Error: Could not be resolved>';
end;

function TwbFormIDChecked.CheckFlst(const aMainRecord: IwbMainRecord): Boolean;
var
  Container  : IwbContainerElementRef;
  i, j       : Integer;
  MainRecord : IwbMainRecord;
begin
  Result := True;

  if wbDisableFormIDCheck then
    Exit;

  if fidcValidFlstRefs.Count < 1 then
    Exit;

  if aMainRecord.Signature <> 'FLST' then
    Exit;

  if Supports(aMainRecord.ElementByName['FormIDs'], IwbContainerElementRef, Container) then
    for i := 0 to Pred(Container.ElementCount) do
      if Supports(Container.Elements[i].LinksTo, IwbMainRecord, MainRecord) then
        if not fidcValidFlstRefs.Find(MainRecord.Signature, j) then begin
          Result := False;
          Exit;
        end;
end;

constructor TwbFormIDChecked.Clone(const aSource: TwbDef);
begin
  with aSource as TwbFormIDChecked do
    Self.Create(fidcValidRefsArr, fidcValidFlstRefsArr, fidcPersistent, fidcNoReach).AfterClone(aSource);
end;

constructor TwbFormIDChecked.Create(const aValidRefs     : TwbSignatures;
                                    const aValidFlstRefs : TwbSignatures;
                                          aPersistent    : Boolean;
                                          aNoReach       : Boolean);
var
  i: Integer;
begin
  fidcPersistent := aPersistent;
  fidcNoReach := aNoReach;

  fidcValidRefs := TwbFastStringListCS.CreateSorted(dupIgnore);
  SetLength(fidcValidRefsArr, Length(aValidRefs));
  for i := Low(aValidRefs) to High(aValidRefs) do begin
    fidcValidRefsArr[i] := aValidRefs[i];
    fidcValidRefs.Add(aValidRefs[i]);
  end;

  fidcValidFlstRefs := TwbFastStringListCS.CreateSorted(dupIgnore);
  SetLength(fidcValidFlstRefsArr, Length(aValidFlstRefs));
  for i := Low(aValidFlstRefs) to High(aValidFlstRefs) do begin
    fidcValidFlstRefsArr[i] := aValidFlstRefs[i];
    fidcValidFlstRefs.Add(aValidFlstRefs[i]);
  end;

  inherited Create;
end;

destructor TwbFormIDChecked.Destroy;
begin
  FreeAndNil(fidcValidRefs);
  FreeAndNil(fidcValidFlstRefs);
  inherited;
end;

threadvar
  _FormIDErrorCheckLockCount: Integer;

function wbFormIDErrorCheckLock: Integer;
begin
  Inc(_FormIDErrorCheckLockCount);
  Result := _FormIDErrorCheckLockCount;
end;

function wbFormIDErrorCheckUnlock: Integer;
begin
  Dec(_FormIDErrorCheckLockCount);
  Result := _FormIDErrorCheckLockCount;
end;

function TwbFormIDChecked.FromEditValue(const aValue: string; const aElement: IwbElement): Int64;
var
  Error: string;
begin
  Result := inherited FromEditValue(aValue, aElement);
  if _FormIDErrorCheckLockCount < 1 then begin
    Error := Check(Result, aElement);
    if Error <> '' then
      raise Exception.Create(Error);
  end;
end;

function TwbFormIDChecked.GetExactIdentString: string;
begin
  Result := inherited GetExactIdentString + '|' + fidcValidRefs.CommaText + '|' + fidcValidFlstRefs.CommaText;
end;

function TwbFormIDChecked.GetNoReach: Boolean;
begin
  Result := fidcNoReach;
end;

function TwbFormIDChecked.GetSignature(aIndex: Integer): TwbSignature;
begin
  Result := StrToSignature(fidcValidRefs[aIndex]);
end;

function TwbFormIDChecked.GetSignatureCount: Integer;
begin
  Result := fidcValidRefs.Count;
end;

function TwbFormIDChecked.IsValid(const aSignature: TwbSignature): Boolean;
begin
  if wbDisableFormIDCheck then
    Exit(inherited);

  Result := fidcValidRefs.IndexOf(aSignature) >= 0;
end;

function TwbFormIDChecked.IsValidFlst(const aSignature: TwbSignature): Boolean;
begin
  Result := (fidcValidFlstRefs.Count = 0) or (fidcValidFlstRefs.IndexOf(aSignature) >= 0) or wbDisableFormIDCheck;
end;

function TwbFormIDChecked.IsValidMainRecord(const aMainRecord: IwbMainRecord): Boolean;
begin
  Result :=  wbDisableFormIDCheck;

  if Result then
    Exit;

  Result := IsValid(aMainRecord.Signature) and CheckFlst(aMainRecord);

  if not Result then
    Exit;

  Result := not fidcPersistent or aMainRecord.IsPersistent;
end;

procedure TwbFormIDChecked.Report(const aParents: TwbDefPath);
var
  i, j : Integer;
  s    : string;
  Sigs : TStringList;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if wbReportMode and not (dfNoReport in defFlags) then
    if wbReportFormIDs and Assigned(FoundSignatures) and (FoundSignatures.Count > 0) then begin
      s := '';

      Sigs := TwbFastStringListCS.CreateSorted;
      try
        Sigs.AddStrings(FoundSignatures);

        for i := 0 to Pred(fidcValidRefs.Count) do
          if Sigs.Find(fidcValidRefs[i], j) then
            Sigs.Delete(j)
          else
            s := s + fidcValidRefs[i] + ',';
        SetLength(s, Pred(Length(s)));

        if not wbReportNotFoundButAllowedFormIDs then
          s := '';

        if (s <> '') or (Sigs.Count > 0) then begin
          WriteLn('Differences in Checked FormID Formater: ', wbDefsToPath(aParents), wbDefToName(Self));
          if s <> '' then
            WriteLn('  Not found but allowed: ', s);
          if Sigs.Count > 0 then begin
            WriteLn('  Found but not allowed: ', Sigs.CommaText);
            for i := 0 to Pred(Sigs.Count) do
              WriteLn('    ', Sigs.Strings[i], ' (', Integer(Sigs.Objects[i]),')');
          end;
        end;
      finally
        Sigs.Free;
      end;
    end;

  defReported := True;
end;

{ TwbIntegerDefFormater }

procedure TwbIntegerDefFormater.BuildRef(aInt: Int64;
  const aElement: IwbElement);
begin
  { nothing }
end;

function TwbIntegerDefFormater.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  Result := False;
end;

function TwbIntegerDefFormater.Check(aInt: Int64;
  const aElement: IwbElement): string;
begin
  Result := '';
end;

constructor TwbIntegerDefFormater.Clone(const aSource: TwbDef);
begin
  with (aSource as TwbIntegerDefFormater) do
    Self.Create.AfterClone(aSource);
end;

function TwbIntegerDefFormater.CompareExchangeFormID(var aInt: Int64;
  aOldFormID, aNewFormID: TwbFormID; const aElement: IwbElement): Boolean;
begin
  Result := False; // ? Should be overriden
end;

constructor TwbIntegerDefFormater.Create;
begin
  inherited Create(cpNormal, False, ClassName, nil, nil, nil, nil, False);
end;

procedure TwbIntegerDefFormater.FindUsedMasters(aInt: Int64; aMasters: PwbUsedMasters; const aElement: IwbElement);
begin
  {can be overriden}
end;

function TwbIntegerDefFormater.FromEditValue(const aValue: string;
  const aElement: IwbElement): Int64;
begin
  raise Exception.Create(Classname + ' does not support editing');
end;

function TwbIntegerDefFormater.FromLinksTo(const aValue, aElement: IwbElement): Int64;
begin
  raise Exception.Create(Classname + ' does not support editing');
end;

function TwbIntegerDefFormater.GetDefType: TwbDefType;
begin
  Result := dtIntegerFormater;
end;

function TwbIntegerDefFormater.GetDefTypeName: string;
begin
  Result := ClassName;
end;

function TwbIntegerDefFormater.GetEditInfo(const aElement: IwbElement): TwbStringArray;
begin
  Result := nil;
end;

function TwbIntegerDefFormater.GetEditType(const aElement: IwbElement): TwbEditType;
begin
  Result := etDefault;
end;

function TwbIntegerDefFormater.GetIsEditable(aInt: Int64; const aElement: IwbElement): Boolean;
begin
  Result := wbIsInternalEdit;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbIntegerDefFormater.GetLinksTo(aInt: Int64; const aElement: IwbElement): IwbElement;
begin
  Result := nil;
end;

function TwbIntegerDefFormater.GetRequiresKey: Boolean;
begin
  Result := False;
end;

function TwbIntegerDefFormater.MastersUpdated(aInt: Int64; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte; const aElement: IwbElement): Int64;
begin
  Result := aInt;
end;

function TwbIntegerDefFormater.ToEditValue(aInt: Int64;
  const aElement: IwbElement): string;
begin
  Result := '';
end;

{ TwbResolvableDef }

procedure TwbResolvableDef.BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
var
  ValueDef : IwbValueDef;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  inherited;
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    ValueDef.BuildRef(aBasePtr, aEndPtr, aElement);
end;

function TwbUnionDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  UnionDef : IwbUnionDef;
  i        : Integer;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  if Supports(aDef, IwbUnionDef, UnionDef) then begin
    Result := Equals(aDef);
    if not Result then
      for i := 0 to Pred(UnionDef.MemberCount) do begin
        Result := CanAssign(aElement, aIndex, UnionDef.Members[i]);
        if Result then
          Exit;
      end;

  end else begin
    Result := False;
    for i := 0 to Pred(GetMemberCount) do begin
      Result := udMembers[i].CanAssign(aElement, aIndex, aDef);
      if Result then
        Exit;
    end;
  end;
end;

function TwbResolvableDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
var
  SelfValueDef: IwbValueDef;
  SourceDef: IwbDef;
  SourceResolvableDef: IwbResolvableDef;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  SelfValueDef := ResolveDef(nil, nil, aElement);

  SourceDef := aDef;
  if Supports(SourceDef, IwbRecursiveDef, SourceResolvableDef) then
    SourceDef := SourceResolvableDef.ResolveDef(nil, nil, aElement);

  if Assigned(SelfValueDef) then
    Result := SelfValueDef.CanAssign(aElement, aIndex, SourceDef)
  else
    Result := False;
end;

function TwbResolvableDef.Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  var lResolvedDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(lResolvedDef) then
    Result := lResolvedDef.Check(aBasePtr, aEndPtr, aElement)
  else
    Result := 'Union could not be resolved';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctCheck);
end;

constructor TwbUnionDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbUnionDef do
    Self.Create(defPriority, defRequired, ndName, udDecider, udMembers, ndDontShow, ndAfterSet, defGetCP).AfterClone(aSource);
end;

constructor TwbUnionDef.Create(aPriority : TwbConflictPriority;
                               aRequired : Boolean;
                         const aName     : string;
                               aDecider  : TwbUnionDecider;
                         const aMembers  : array of IwbValueDef;
                               aDontShow : TwbDontShowCallback;
                               aAfterSet : TwbAfterSetCallback;
                               aGetCP    : TwbGetConflictPriority);
begin
  inherited Create(aPriority, aRequired, aName, nil, aAfterSet, aDontShow, aGetCP, False);
  udDecider := aDecider;
  SetLength(udMembers, Length(aMembers));
  var l := 0;
  for var i := Low(udMembers) to High(udMembers) do
    if Assigned(aMembers[i]) then begin
      udMembers[l] := (aMembers[i] as IwbDefInternal).SetParent(Self, False) as IwbValueDef;
      Inc(l);
    end;
  SetLength(udMembers, l);
end;

function TwbUnionDef.ResolveDef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef;
var
  aMemberIndex : Integer;
begin
  aMemberIndex := udDecider(aBasePtr, aEndPtr, aElement);
  if (aMemberIndex>=0) and (aMemberIndex<Length(udMembers))then
    Result := udMembers[aMemberIndex]
  else
    Result := nil;
  Used(nil, '');
end;

function TwbUnionDef.ResolveDefAndElement(aBasePtr, aEndPtr: Pointer; var aElement: IwbElement): IwbValueDef;
begin
  Result := inherited ResolveDefAndElement(aBasePtr, aEndPtr, aElement);
  if Assigned(Result) then
    if aElement.ElementType = etUnion then begin
      var CER: IwbContainerElementRef;
      if Supports(aElement, IwbContainerElementRef, CER) then
        if CER.ElementCount = 1 then begin
          var Element := CER.Elements[0];
          if Result.Equals(Element.ValueDef) then
            aElement := Element;
        end;
    end;
end;

procedure TwbResolvableDef.FromEditValue(aBasePtr, aEndPtr: Pointer;
  const aElement: IwbElement; const aValue: string);
begin
  ResolveDef(aBasePtr, aEndPtr, aElement).
    EditValue[aBasePtr, aEndPtr, aElement] := aValue;
end;

procedure TwbResolvableDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
begin
  ResolveDef(aBasePtr, aEndPtr, aElement).
    NativeValue[aBasePtr, aEndPtr, aElement] := aValue;
end;

function TwbUnionDef.GetChildPos(const aChild: IwbDef): Integer;
begin
  Result := inherited;
  if not Assigned(aChild) or (Result < 0) then
    for var lIdx := Low(udMembers) to High(udMembers) do
      if aChild.Equals(udMembers[lIdx]) then
        Exit(lIdx);
end;

function TwbUnionDef.GetDefType: TwbDefType;
begin
  Result := dtUnion;
end;

function TwbUnionDef.GetDefTypeName: string;
begin
  Result := 'Union';
end;

function TwbResolvableDef.GetDefType: TwbDefType;
begin
  Result := dtResolvable;
end;

function TwbResolvableDef.GetDefTypeName: string;
begin
  Result := 'Resolvable';
end;

function TwbResolvableDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
var
  ValueDef: IwbValueDef;
begin
  if Assigned(vdEditInfo) then
    Exit(vdEditInfo^);

  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.EditInfo[aBasePtr, aEndPtr, aElement]
  else
    Result := nil;
end;

function TwbResolvableDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.EditType[aBasePtr, aEndPtr, aElement]
  else
    Result := etDefault;
end;

function TwbResolvableDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
var
  ValueDef: IwbValueDef;
begin
  Result := wbIsInternalEdit;
  if not Result then
  begin
    ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
    if Assigned(ValueDef) then
      Result := ValueDef.IsEditable[aBasePtr, aEndPtr, aElement]
    else
      Result := False;
  end;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbResolvableDef.GetIsVariableSizeInternal: Boolean;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(nil, nil, nil);
  if Assigned(ValueDef) then
    Result := ValueDef.IsVariableSize
  else
    Result := True; {we don't know, better assume yes}
end;

function TwbUnionDef.GetIsVariableSizeInternal: Boolean;
var
  i, j: Integer;
begin
  Result := False;
  for i := Low(udMembers) to High(udMembers) do begin
    Result := udMembers[i].IsVariableSize;
    if Result then
      Break;
  end;

  if not Result then begin
    j := udMembers[0].DefaultSize[nil, nil, nil];
    for i := 1 to High(udMembers) do
      if udMembers[i].DefaultSize[nil, nil, nil] <> j then begin
        j := -1;
        break;
      end;
    Result := j = -1;
  end;
end;

function TwbResolvableDef.GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement;
var
  ValueDef: IwbValueDef;
begin
  if Assigned(vdLinksToCallback) then
    Exit(vdLinksToCallback(aElement));

  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.LinksTo[aBasePtr, aEndPtr, aElement]
  else
    Result := nil;
end;

function TwbResolvableDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.GetSize(aBasePtr, aEndPtr, aElement)
  else
    Result := 0;
end;

procedure TwbResolvableDef.InitFromParentAfterChildren;
begin
  InitFromResolvedDef;
  inherited;
  InitFromResolvedDef;
end;

procedure TwbResolvableDef.InitFromParentBeforeChildren;
begin
  InitFromResolvedDef;
  inherited;
  InitFromResolvedDef;
end;

procedure TwbResolvableDef.InitFromResolvedDef;
begin
  var lValueDef := ResolveDef(nil, nil, nil);
  if Assigned(lValueDef) then begin
    var lDefObj := lValueDef as TwbDef;
    defFlags := defFlags + (lDefObj.defFlags * _DefFlagsInheritDown);
    lDefObj.defFlags := lDefObj.defFlags + (defFlags * _DefFlagsInheritUp);
  end;
end;

function TwbResolvableDef.NeedsElementToResolve: Boolean;
begin
  Result := False;
end;

function TwbResolvableDef.ResolveDefAndElement(aBasePtr, aEndPtr: Pointer; var aElement: IwbElement): IwbValueDef;
begin
  Result := ResolveDef(aBasePtr, aEndPtr, aElement);
end;

function TwbUnionDef.GetMember(aIndex: Integer): IwbValueDef;
begin
  Result := udMembers[aIndex];
end;

function TwbUnionDef.GetMemberCount: Integer;
begin
  Result := Length(udMembers);
end;

function TwbUnionDef.GetMemberTypes: TwbDefTypes;
var
  i        : Integer;
begin
  if udMemberTypes = [] then begin
    for i := Low(udMembers) to High(udMembers) do
      Include(udMemberTypes, udMembers[i].DefType);
  end;
  Result := udMemberTypes;
end;

function TwbUnionDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  i           : Integer;
  Size        : Integer;
  aMember     : IwbValueDef;
  Container   : IwbContainerElementRef;
  Element     : IwbElement;
  Resolveable : IwbResolvableDef;
begin
//  if Assigned(aBasePtr) and Assigned(aEndPtr) and (Cardinal(aEndPtr)<Cardinal(aBasePtr)) then begin
//    wbProgressCallback('Found a union with a negative size! (1) '+IntToHex64(Cardinal(aBasePtr), 8)+
//      ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
//  end;
  if GetIsVariableSize then
    aMember := ResolveDef(aBasePtr, aEndPtr, aElement)
  else
    aMember := nil;;
  if not Assigned(aMember) then begin
    if Length(udMembers)>0 then
      Result := udMembers[0].Size[aBasePtr, aEndPtr, aElement]
    else
      Result := Low(Integer);
    if (Result > 0) and GetIsVariableSize then
      for i := 1 to High(udMembers) do
        if Result <> High(Integer) then begin
          Size := udMembers[i].Size[aBasePtr, aEndPtr, aElement];
          if Size = 0 then begin // No valid value can be found
            Result := 0;
            Break;
          end else if Result < Size then
            Result := Size;
        end else
          break;
  end else begin
    if GetIsVariableSize and Supports(aElement, IwbContainerElementRef, Container) and Equals(Container.ValueDef) and (Container.ElementCount = 1) then begin
      Element := Container.Elements[0];
      while not aMember.Equals(Element.ValueDef) and Supports(aMember, IwbResolvableDef, Resolveable) do
        aMember := Resolveable.ResolveDefAndElement(aBasePtr, aEndPtr, Element);
      if not aMember.Equals(Element.ValueDef) then
        Element := nil;
    end;
    if not Assigned(Element) then
      Element := aElement;
    Result := aMember.Size[aBasePtr, aEndPtr, Element];
    if Result = High(Integer) then Exit;
    if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aEndPtr) < NativeUInt(aBasePtr)+Result) then begin
//      if Assigned(aBasePtr) and Assigned(aEndPtr) and (aEndPtr<>aBasePtr) then
//        wbProgressCallback('Found a union with a negative size! (2) '+IntToHex64(Cardinal(aBasePtr)+Result, 8)+
//          ' > '+IntToHex64(Cardinal(aEndPtr), 8)+'  for '+ndName);
      Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
    end;
  end;
end;

procedure TwbUnionDef.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(udMembers) to High(udMembers) do
    if Assigned(udMembers[lMemberIdx]) then
      (udMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
end;

function TwbUnionDef.NeedsElementToResolve: Boolean;
begin
  Result := True;
end;

function TwbResolvableDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  aMember : IwbValueDef;
begin
  aMember := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(aMember) then
    Result := aMember.DefaultSize[aBasePtr, aEndPtr, aElement]
  else
    Result := 0;
end;

procedure TwbUnionDef.Report(const aParents: TwbDefPath);
var
  Parents : TwbDefPath;
  i       : Integer;
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  Parents := aParents;
  SetLength(Parents, Succ(Length(Parents)));
  Parents[High(Parents)].Def := Self;
  for i := Low(udMembers) to High(udMembers) do
    if Assigned(udMembers[i]) then begin
      Parents[High(Parents)].Index := i;
      udMembers[i].Report(Parents);
    end;

  defReported := True;
end;

procedure TwbResolvableDef.SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement, aValue: IwbElement);
begin
  ResolveDef(aBasePtr, aEndPtr, aElement).
    LinksTo[aBasePtr, aEndPtr, aElement] := aValue;
end;

function TwbResolvableDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
var
  ValueDef: IwbValueDef;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.SetToDefault(aBasePtr, aEndPtr, aElement)
  else
    Result := False;
end;

function TwbResolvableDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.EditValue[aBasePtr, aEndPtr, aElement]
  else
    Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbResolvableDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.NativeValue[aBasePtr, aEndPtr, aElement]
  else
    Result := '';
end;

function TwbResolvableDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.ToSortKey(aBasePtr, aEndPtr, aElement, aExtended)
  else
    Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbResolvableDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  ValueDef: IwbValueDef;
begin
  ValueDef := ResolveDef(aBasePtr, aEndPtr, aElement);
  if Assigned(ValueDef) then
    Result := ValueDef.ToString(aBasePtr, aEndPtr, aElement)
  else
    Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
  Used(aElement, Result);
end;

function TwbResolvableDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
var
  ValueDef : IwbValueDef;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);

  if Result = '' then begin
    var Element := aElement;
    ValueDef := ResolveDefAndElement(aBasePtr, aEndPtr, Element);
    if Assigned(ValueDef) then
      Result := ValueDef.ToSummary(aDepth, aBasePtr, aEndPtr, Element, aLinksTo);
  end;

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;

  Used(aElement, Result);
end;

{ TwbEmptyDef }

constructor TwbEmptyDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbEmptyDef do
    Self.Create(defPriority, defRequired, ndName, ndAfterLoad, ndAfterSet, ndDontShow, edSorted, defGetCP).AfterClone(aSource);
end;

constructor TwbEmptyDef.Create(aPriority  : TwbConflictPriority;
                               aRequired  : Boolean;
                         const aName      : string;
                               aAfterLoad : TwbAfterLoadCallback; aAfterSet : TwbAfterSetCallback;
                               aDontShow  : TwbDontShowCallback;
                               aSorted    : Boolean;
                               aGetCP     : TwbGetConflictPriority);
begin
  Include(defFlags, dfSkipImplicitEdit);

  if wbNeverSorted then
    aSorted := False;

  edSorted := aSorted;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, False);
end;

procedure TwbEmptyDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
end;

function TwbEmptyDef.GetCanBeZeroSize: Boolean;
begin
  Result := True;
end;

function TwbEmptyDef.GetDefType: TwbDefType;
begin
  Result := dtEmpty;
end;

function TwbEmptyDef.GetDefTypeName: string;
begin
  Result := 'Place holder for optional elements';
end;

function TwbEmptyDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbEmptyDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
end;

function TwbEmptyDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
end;

function TwbEmptyDef.GetSorted: Boolean;
begin
  Result := edSorted;
end;

function TwbEmptyDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := '<Empty>';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

function TwbEmptyDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
  Used(aElement, Result);
end;

{ TwbMainRecordStructFlags }

function TwbMainRecordStructFlags.CantWait: Boolean;
begin
  Result := (_Flags and $00080000) <> 0;
end;

function TwbMainRecordStructFlags.CastsShadows: Boolean;
begin
  Result := (_Flags and $00000200) <> 0;
end;

function TwbMainRecordStructFlags.HasLODtree: Boolean;
begin
  Result := (_Flags and $00000040) <> 0;
end;

function TwbMainRecordStructFlags.IsCompressed: Boolean;
begin
  Result := (_Flags and $00040000) <> 0;
end;

function TwbMainRecordStructFlags.IsDangerous: Boolean;
begin
  Result := (_Flags and $00020000) <> 0;
end;

function TwbMainRecordStructFlags.IsDeleted: Boolean;
begin
  Result := (_Flags and $00000020) <> 0;
end;

function TwbMainRecordStructFlags.IsLocalized: Boolean;
begin
  Result := (_Flags and $00000080) <> 0;
end;

function TwbMainRecordStructFlags.IsMedium: Boolean;
begin
  Result := wbIsMediumSupported and
    ((_Flags and $00000400) <> 0);
end;

function TwbMainRecordStructFlags.IsLight: Boolean;
begin
  if wbIsStarfield then
    Result := wbIsLightSupported and
      ((_Flags and $00000100) <> 0)
  else
    Result := wbIsLightSupported and
      ((_Flags and $00000200) <> 0);
end;

function TwbMainRecordStructFlags.IsOverlay: Boolean;
begin
  Result := wbIsOverlaySupported and
    ((_Flags and $00000200) <> 0);
end;

function TwbMainRecordStructFlags.IsESM: Boolean;
begin
  Result := (_Flags and $00000001) <> 0;
end;

function TwbMainRecordStructFlags.IsIgnored: Boolean;
begin
  Result := (_Flags and $00001000) <> 0;
end;

function TwbMainRecordStructFlags.IsInitiallyDisabled: Boolean;
begin
  Result := (_Flags and $00000800) <> 0;
end;

function TwbMainRecordStructFlags.IsPartialForm: Boolean;
begin
  Result := (_Flags and $00004000) <> 0;
end;

function TwbMainRecordStructFlags.IsPersistent: Boolean;
begin
  Result := (_Flags and $00000400) <> 0;
end;

function TwbMainRecordStructFlags.IsVisibleWhenDistant: Boolean;
begin
  Result := (_Flags and $00008000) <> 0;
end;

procedure TwbMainRecordStructFlags.SetCompressed(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00040000
  else
    _Flags := _Flags and not $00040000;
end;

procedure TwbMainRecordStructFlags.SetDeleted(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00000020
  else
    _Flags := _Flags and not $00000020;
end;

procedure TwbMainRecordStructFlags.SetMedium(aValue: Boolean);
begin
  if wbIsMediumSupported then
    if aValue then begin
      _Flags := _Flags or $00000400;
      SetLight(False);
      SetOverlay(False);
    end else
      _Flags := _Flags and not $00000400;
end;

procedure TwbMainRecordStructFlags.SetLight(aValue: Boolean);
begin
  if wbIsLightSupported then
    if wbIsStarfield then begin
      if aValue then begin
        _Flags := _Flags or $00000100;
        SetMedium(False);
        SetOverlay(False);
      end else
        _Flags := _Flags and not $00000100;
    end else
      if aValue then
        _Flags := _Flags or $00000200
      else
        _Flags := _Flags and not $00000200;
end;

procedure TwbMainRecordStructFlags.SetOverlay(aValue: Boolean);
begin
  if wbIsOverlaySupported then
    if aValue then begin
      _Flags := _Flags or $00000200;
      SetLight(False);
      SetMedium(False);
    end else
      _Flags := _Flags and not $00000200;
end;

procedure TwbMainRecordStructFlags.SetESM(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00000001
  else
    _Flags := _Flags and not $00000001;
end;

procedure TwbMainRecordStructFlags.SetLocalized(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00000080
  else
    _Flags := _Flags and not $00000080
end;

procedure TwbMainRecordStructFlags.SetInitiallyDisabled(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00000800
  else
    _Flags := _Flags and not $00000800;
end;

procedure TwbMainRecordStructFlags.SetPartialForm(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00004000
  else
    _Flags := _Flags and not $00004000;
end;

procedure TwbMainRecordStructFlags.SetPersistent(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00000400
  else
    _Flags := _Flags and not $00000400;
end;

procedure TwbMainRecordStructFlags.SetVisibleWhenDistant(aValue: Boolean);
begin
  if aValue then
    _Flags := _Flags or $00008000
  else
    _Flags := _Flags and not $00008000;
end;

{ TwbLenStringDef }

function TwbLenStringDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef) : Boolean;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  Result := aDef.DefType in [dtString, dtLString, dtLenString];
end;

function TwbLenStringDef.Check(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;

  procedure Inner;
  var
    Size : Cardinal;
    Len  : Cardinal;
  begin
    Result := '';

    Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
    if Len < GetPrefixOffset then begin
      if wbCheckExpectedBytes then
        Result := Format('Expected at least %d bytes of data, found %d', [Abs(Prefix) , Len]);
      Exit;
    end;
    Size := GetPrefixValue(aBasePtr, aEndPtr, aElement) + GetPrefixOffset;
    if Len < Size then begin
      if wbCheckExpectedBytes then
        Result := Format('Expected %d bytes of data, found %d', [Size , Len]);
    end;
  end;

begin
  Inner;
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctCheck);
end;

constructor TwbLenStringDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbLenStringDef do
    Self.Create(defPriority, defRequired, ndName, Prefix, ndAfterLoad, ndAfterSet, ndDontShow, defGetCP, ndTerminator).AfterClone(aSource);
end;

constructor TwbLenStringDef.Create(aPriority    : TwbConflictPriority;
                                   aRequired    : Boolean;
                             const aName        : string;
                                   aPrefix      : Integer;
                                   aAfterLoad   : TwbAfterLoadCallback;
                                   aAfterSet    : TwbAfterSetCallback;
                                   aDontShow    : TwbDontShowCallback;
                                   aGetCP       : TwbGetConflictPriority;
                                   aTerminator  : Boolean);
begin
  Prefix := aPrefix;
  if not (Abs(Prefix) in [1, 2, 3, 4, 5]) then
    Prefix := 4;

  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

procedure TwbLenStringDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
var
  Len     : Cardinal;
  NewSize : Cardinal;
  p       : Pointer;
  b       : TBytes;
begin
  var lValue := aValue;
  if Assigned(bsdFormater) then
    lValue := bsdFormater.FromEditValue(lValue, aElement);

  b := bsdGetEncoding(aElement).GetBytes(lValue);
  if (dfHasZeroTerminator in defFlags) and ((Length(b) < 1) or (b[High(b)] <> 0)) then
    SetLength(b, Succ(Length(b))); //new byte automatically 0

  Len := Length(b);
  NewSize := Len + GetPrefixOffset;
  aElement.RequestStorageChange(aBasePtr, aEndPtr, NewSize + Ord(ndTerminator));
  SetPrefixValue(aBasePtr, aEndPtr, aElement, Len);
  p := PByte(aBasePtr) + GetPrefixOffset;
  if Len > 0 then
    Move(b[0], p^, Len);
  if ndTerminator then begin
    Inc(PByte(p), Len+1);
    PByte(p)^ := wbTerminator;
  end;
end;

procedure TwbLenStringDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
begin
  FromEditValue(aBasePtr, aEndPtr, aElement, aValue);
end;

function TwbLenStringDef.GetDefType: TwbDefType;
begin
  Result := dtLenString;
end;

function TwbLenStringDef.GetDefTypeName: string;
begin
  if Prefix > 0 then
    Result := 'string with length of '+IntToStr(Prefix)+' bytes'
  else
    Result := 'Separated string with length of '+IntToStr(GetPrefixLen)+' bytes'
end;

function TwbLenStringDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbLenStringDef.GetIsVariableSizeInternal: Boolean;
begin
  Result := True;
end;

function TwbLenStringDef.GetPrefixLen: Integer;
begin
  case Prefix of
    1, -2: Result := 1;
    2, -3: Result := 2;
    4, -5: Result := 4;
  else
    Result := 0;
  end;
end;

function TwbLenStringDef.GetPrefixOffset: Integer;
begin
    Result := Abs(Prefix);
end;

function TwbLenStringDef.GetPrefixValue(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  case Prefix of
    1, -2: Result := PByte(aBasePtr)^;
    2, -3: Result := PWord(aBasePtr)^;
    4, -5: Result := PCardinal(aBasePtr)^;
  else
    Result := 0;
  end;
end;

function TwbLenStringDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Len : Integer;
begin
  if Assigned(aBasePtr) and Assigned(aEndPtr) then
    if (NativeUInt(aBasePtr) >= NativeUInt(aEndPtr)) then
      Result := 0
    else begin
      Result := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
      Len := GetPrefixValue(aBasePtr, aEndPtr, aElement);
      if Len>0 then
        Len := Len+GetPrefixOffset+Ord(ndTerminator)
      else
        Len := GetPrefixOffset;
      if Len>Result then
        Exit;
      if Len < Result then
        Result := Len;
    end
  else
    Result := GetPrefixOffset;
end;

function TwbLenStringDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := GetPrefixOffset+Ord(ndTerminator);
end;

function TwbLenStringDef.SetFormater(const aFormater: IwbStringDefFormater): IwbLenStringDef;
begin
  if defIsLocked then
    Exit(TwbLenStringDef(Duplicate).SetFormater(aFormater));

  Result := Self;
  if Assigned(aFormater) then
    bsdFormater := (aFormater as IwbDefInternal).SetParent(Self, False) as IwbStringDefFormater;
end;

procedure TwbLenStringDef.SetPrefixValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aValue: Cardinal);
begin
  case Prefix of
    1, -2: PByte(aBasePtr)^ := aValue;
    2, -3: PWord(aBasePtr)^ := aValue;
    4, -5: PCardinal(aBasePtr)^ := aValue;
  end;
end;

function TwbLenStringDef.SetToDefault(aBasePtr, aEndPtr: Pointer;
  const aElement: IwbElement): Boolean;
begin
  Result := not Assigned(aBasePtr) or (ToString(aBasePtr, aEndPtr, aElement) <> '');
  if Result then
    FromEditValue(aBasePtr, aEndPtr, aElement, '');
end;

function TwbLenStringDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbLenStringDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
begin
  var s := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if Assigned(ndToStr) then
    ndToStr(s, aBasePtr, aEndPtr, aElement, ctToNativeValue);
  Result := s;
end;

function TwbLenStringDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
end;

function TwbLenStringDef.ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
var
  Size : Cardinal;
  Len  : Cardinal;
  b    : TBytes;
  i    : Integer;
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if Len<GetPrefixOffset+Ord(ndTerminator) then
    Exit;

  Size := GetPrefixValue(aBasePtr, aEndPtr, aElement);
  Inc(PByte(aBasePtr), GetPrefixOffset);

  if Len > Size then
    Len := Size;

  if Len > 0 then begin
    b := BytesOf(aBasePtr, Len);
    try
      if (dfHasZeroTerminator in defFlags) and (b[High(b)] = 0) then
        SetLength(b, Pred(Length(b)));
      Result := bsdGetEncoding(aElement).GetString(b);
    except
      on E: Exception do begin
        Result := '';
        for i := Low(b) to High(b) do begin
          Result := Result + IntToHex64(b[i], 2);
          if i < High(b) then
            Result := Result + ' ';
        end;
        Result := Result + ' <Error: ';
        Result := Result + Format('Can''t read string: [%s] %s', [E.ClassName, E.Message]);
        Result := Result + '>';
        wbProgress('[%s] <Error reading string: [%s] %s>', [aElement.FullPath, E.ClassName, E.Message]);
      end;
    end;
  end else
    Result := '';

  Used(aElement, Result);
end;

{ TwbFastStringList }

procedure TwbFastStringList.AfterConstruction;
begin
  inherited;
  UseLocale := False;
end;

procedure TwbFastStringList.Clear(aFreeObjects: Boolean);
var
  i: Integer;
begin
  if aFreeObjects then
    for i := 0 to Pred(Count) do
      Objects[i].Free;
  inherited Clear;
end;

{ replaced by wbBetterStringList
function TwbFastStringList.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := CompareStr(S1, S2)
  else
    Result := CompareText(S1, S2);
end;}

constructor TwbFastStringList.CreateSorted(aDups: TDuplicates);
begin
  Create;
  Duplicates := aDups;
  Sorted := True;
end;

{ TwbFastStringListCS }

procedure TwbFastStringListCS.AfterConstruction;
begin
  inherited;
  CaseSensitive := True;
end;

{ TwbStringLCDef }

function TwbStringLCDef.TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string;
begin
  if aTransformType = ttCheck then
    Result := s
  else
    Result := LowerCase(s);
end;

{ TwbLString }

function TwbLStringDef.GetDefType: TwbDefType;
begin
  Result := dtLString;
end;

function TwbLStringDef.GetDefTypeName: string;
begin
  Result := 'Localized string';
end;

constructor TwbLStringDef.Create(aPriority   : TwbConflictPriority;
                                 aRequired   : Boolean;
                           const aName       : string;
                                 aSize       : Integer;
                                 aAfterLoad  : TwbAfterLoadCallback;
                                 aAfterSet   : TwbAfterSetCallback;
                                 aDontShow   : TwbDontShowCallback;
                                 aGetCP      : TwbGetConflictPriority;
                                 aTerminator : Boolean;
                                 aForward    : Boolean = False);
begin
  Include(defFlags, dfTranslatable);
  inherited;
end;

procedure TwbLStringDef.FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType);
var
  ID: Cardinal;
begin
  if aValue.StartsWith(sStringID) then begin
    aElement.RequestStorageChange(aBasePtr, aEndPtr, SizeOf(Cardinal));
    PCardinal(aBasePtr)^ := StrToInt64Def('$' + Copy(aValue, Succ(Length(sStringID)), Length(aValue)), 0);
    aElement.Localized := tbTrue;
    Exit;
  end;

  if aElement._File.IsLocalized then
    if wbLocalizationHandler.NoTranslate then begin
      // assign a string when delocalizing and NoTranslate is true
      inherited FromStringNative(aBasePtr, aEndPtr, aElement, aValue, aTransformType);
      aElement.Localized := tbFalse;
    end else begin
      // set localized string's value
      ID := wbLocalizationHandler.SetValue(PCardinal(aBasePtr)^, aElement, aValue);
      aElement.RequestStorageChange(aBasePtr, aEndPtr, SizeOf(Cardinal));
      PCardinal(aBasePtr)^ := ID;
      aElement.Localized := tbTrue;
      //raise Exception.Create('Can not assign to a localized string')
    end
  else begin
    inherited FromStringNative(aBasePtr, aEndPtr, aElement, aValue, aTransformType);
    aElement.Localized := tbFalse;
  end;
end;

function TwbLStringDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Localized : Boolean;
  _File     : IwbFile;
begin
  case aElement.Localized of
    tbFalse: Localized := False;
    tbTrue: Localized := True;
  else
    _File := aElement._File;
    Localized := Assigned(_File) and _File.IsLocalized;
  end;

  if Assigned(aBasePtr) and Assigned(aEndPtr) and (NativeUInt(aBasePtr) >= NativeUInt(aEndPtr)) then
    Result := 0
  else if Assigned(aBasePtr) and Assigned(aEndPtr) and Localized then
    Result := Min(4, NativeUInt(aEndPtr) - NativeUInt(aBasePtr))
  else
    Result := inherited GetSize(aBasePtr, aEndPtr, aElement);
end;

function TwbLStringDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Localized : Boolean;
  _File     : IwbFile;
begin
  case aElement.Localized of
    tbFalse: Localized := False;
    tbTrue: Localized := True;
  else
    _File := aElement._File;
    Localized := Assigned(_File) and _File.IsLocalized;
  end;

  if Localized then
    Result := 4
  else
    Result := inherited GetDefaultSize(aBasePtr, aEndPtr, aElement);
end;

function TwbLStringDef.ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string;
var
  Localized : Boolean;
  _File     : IwbFile;
  Found     : Boolean;
begin
  case aElement.Localized of
    tbFalse: Localized := False;
    tbTrue: Localized := True;
  else
    _File := aElement._File;
    Localized := Assigned(_File) and _File.IsLocalized;
  end;

  if Localized then begin
    if (NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) <> 4 then begin
      if aTransformType = ttCheck then
        Result := 'lstring ID is not Int32'
      else
        Result := '<Error: lstring ID is not Int32>'
    end else begin
      Found := wbLocalizationHandler.GetValue(PCardinal(aBasePtr)^, aElement, Result);
      if aTransformType = ttCheck then
        if Found then
          Result := ''
        else
          Result := 'lstring ID [' + IntToHex(PCardinal(aBasePtr)^, 8) + '] could not be resolved';
    end;
  end else
    Result := inherited ToStringNative(aBasePtr, aEndPtr, aElement, aTransformType);
end;

{ TwbStringScriptDef }

function TwbStringScriptDef.TransformString(const s: string; aTransformType: TwbStringTransformType; const aElement: IwbElement): string;
var
  i: Integer;
begin
  if aTransformType = ttToSortKey then begin
    with TStringList.Create do try
      Text := s;
      for i := Pred(Count) downto 0 do begin
        Strings[i] := Trim(Strings[i]);
        if Strings[i] = '' then
          Delete(i);
      end;
      Result := Text;
    finally
      Free;
    end;
  end else
    Result := s;
end;

{ TwbStringMgefCodeDef }

procedure TwbStringMgefCodeDef.AfterConstruction;
begin
  inherited;
  Include(defFlags, dfCanContainFormID);
end;

procedure TwbStringMgefCodeDef.BuildRef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement);
var
  _File : IwbFile;
  Rec   : IwbMainRecord;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  _File := aElement._File;
  if Assigned(_File) then begin
    Rec := _File.RecordByEditorID[ToStringTransform(aBasePtr, aEndPtr, aElement, ttToSortKey)];
    if Assigned(Rec) then
      aElement.AddReferencedFromID(Rec.LoadOrderFormID);
  end;
end;

procedure TwbStringMgefCodeDef.FindUsedMasters(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aMasters: PwbUsedMasters);
var
  lLen, Len      : NativeUInt;
  MgefCode : PCardinal;
begin
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if sdSize > 0 then begin
    if Len > Cardinal(sdSize) then
      Len := sdSize;
  end;

  if sdForward then begin
    lLen := 0;
    while lLen < Len do begin
      if PByte(aBasePtr)[lLen] = 0 then
        Break;
      Inc(lLen);
    end;
    Len := lLen;
  end else
    while (Len > 0) and (PByte(aBasePtr)[Pred(Len)] = 0) do
      Dec(Len);

  if Len <> 4 then
    Exit;

  MgefCode := PCardinal(aBasePtr);

  if (MgefCode^ and $80000000) <> 0 then
    { yes, it's a dynamic code }
    aMasters[(MgefCode^ and $000000FF)] := True;
end;

procedure TwbStringMgefCodeDef.FromStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string; aTransformType: TwbStringTransformType);
var
  Value    : string;
  s        : string;
  t        : AnsiString;
  MgefCode : Cardinal;
  IsAlpha  : Boolean;
  i, j     : Integer;
  _File    : IwbFile;
  FileID   : Cardinal;
  NewSize  : Integer;
  b        : TBytes;
begin
  b := nil;
  SetLength(b, 4);

  Value := aValue.Trim;

  i := Pos(':', Value);
  if i > 0 then begin
    s := Copy(Value, 1, Pred(i));

    FileID := $FF;

    if Assigned(aElement) then begin
      _File := aElement._File;
      if Assigned(_File) then begin
        if SameText(s, _File.FileName) then
          FileID := _File.MasterCount[aElement.MastersUpdated]
        else if SameText(s, _File.Name) then
          FileID := _File.MasterCount[aElement.MastersUpdated]
        else begin
          for j := 0 to Pred(_File.MasterCount[aElement.MastersUpdated]) do
            if SameText(t, _File.Masters[j, aElement.MastersUpdated].Name) then begin
              FileID := j;
              break;
            end;
          if FileID = $FF then
            for j := 0 to Pred(_File.MasterCount[aElement.MastersUpdated]) do
              if SameText(s, _File.Masters[j, aElement.MastersUpdated].FileName) then begin
                FileID := j;
                break;
              end;
        end;
      end;
    end;

    if FileID = $FF then begin
      if i > 1 then
        FileID := StrToInt('$' + s);

      if Assigned(aElement) then begin
        _File := aElement._File;
        if Assigned(_File) then
          if FileID = $FF then
            FileID := _File.MasterCount[aElement.MastersUpdated]
          else
            FileID := _File.LoadOrderFileIDtoFileFileID(TwbFileID.CreateFull(FileID), aElement.MastersUpdated).FullSlot;
      end;
    end;

    s := Copy(Value, Succ(i), High(Integer));
    MgefCode := StrToInt(s);
    if MgefCode > $7FFFFF then
      raise Exception.Create('"'+s+'" exceeds the maximum value for a dynamic magic effect code');
    MgefCode := (MgefCode shl 8) or $80000000;

    MgefCode := MgefCode or FileID;

  end else if Length(Value) = 8 then begin

    MgefCode := StrToInt('$' + Value);
    if (MgefCode and $80000000) <> 0 then
      raise Exception.Create('"'+Value+'" is not a valid magic effect code');

  end else if Length(Value) = 4 then begin

    IsAlpha := True;
    for i := 1 to 4 do
      if not(Value[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_']) then begin
        IsAlpha := False;
        break;
      end;
    if not IsAlpha then
      raise Exception.Create('"'+Value+'" is not a valid magic effect code');

    t := AnsiString(Value);
    MgefCode := PCardinal(@t[1])^;

  end else
    raise Exception.Create('"'+Value+'" is not a valid magic effect code');

  PCardinal(@b[0])^ := MgefCode;

  if sdSize > 0 then
    NewSize := sdSize
  else
    NewSize := Succ(Length(b));

  aElement.RequestStorageChange(aBasePtr, aEndPtr, NewSize + Ord(ndTerminator));

  if sdSize > 0 then begin
    FillChar(aBasePtr^, sdSize, 0);
    NewSize := Length(b);
    if NewSize > sdSize then
      NewSize := sdSize;
    if NewSize > 0 then
      Move(b[0], aBasePtr^, NewSize);
  end else begin
    if NewSize > 1 then
      Move(b[0], aBasePtr^, Length(b));

    PByte(aBasePtr)[Pred(NewSize)] := 0;
  end;
  if ndTerminator then
    PAnsiChar(aBasePtr)[NewSize] := AnsiChar(wbTerminator);
end;

function TwbStringMgefCodeDef.GetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbElement;
var
  _File : IwbFile;
begin
  if Assigned(vdLinksToCallback) then
    Exit(vdLinksToCallback(aElement));

  Result := nil;
  _File := aElement._File;
  if Assigned(_File) then
    Result := _File.RecordByEditorID[ToStringTransform(aBasePtr, aEndPtr, aElement, ttToSortKey)];
end;

function TwbStringMgefCodeDef.MastersUpdated(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aOld, aNew: TwbFileIDs; aOldCount, aNewCount: Byte): Boolean;
var
  lLen, Len : NativeUInt;
  MgefCode  : PCardinal;
  i         : Integer;
begin
  Result := False;

  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if sdSize > 0 then begin
    if Len > Cardinal(sdSize) then
      Len := sdSize;
  end;

  if sdForward then begin
    lLen := 0;
    while lLen < Len do begin
      if PByte(aBasePtr)[lLen] = 0 then
        Break;
      Inc(lLen);
    end;
    Len := lLen;
  end else
    while (Len > 0) and (PByte(aBasePtr)[Pred(Len)] = 0) do
      Dec(Len);

  if Len <> 4 then
    Exit;

  MgefCode := PCardinal(aBasePtr);

  //aOld and aNew are file specific, so we only need to look at FullSlot part.

  Assert(Length(aOld) = Length(aNew));
  if (MgefCode^ and $80000000) <> 0 then begin
    { yes, it's a dynamic code }

    if aNewCount > aOldCount then
      if (MgefCode^ and $000000FF) >= aOldCount then begin
        MgefCode^ := (MgefCode^ and $FFFFFF00) or Cardinal(aNewCount);
        Result := True;
        Exit;
      end;

    for i := Low(aOld) to High(aOld) do
      if (MgefCode^ and $000000FF) = aOld[i].FullSlot then begin
        { yes, it refers to this file }
        MgefCode^ := (MgefCode^ and $FFFFFF00) or aNew[i].FullSlot;
        Result := True;
        Exit;
      end;

    if aNewCount < aOldCount then
      if (MgefCode^ and $000000FF) >= aOldCount then begin
        MgefCode^ := (MgefCode^ and $FFFFFF00) or Cardinal(aNewCount);
        Result := True;
        Exit;
      end;
  end;
end;

procedure TwbStringMgefCodeDef.SetLinksTo(aBasePtr, aEndPtr: Pointer; const aElement, aValue: IwbElement);
begin
  inherited;
  //!!!
end;

function TwbStringMgefCodeDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
var
  Default: string;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultNativeValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToNativeValue(aBasePtr, aEndPtr, aElement) <> vdDefaultNativeValue);
    if Result then
      FromNativeValue(aBasePtr, aEndPtr, aElement, vdDefaultNativeValue);
  end else begin
    if vdsHasDefaultEditValue in vdStates then
      Default := vdDefaultEditValue
    else
      Default := '____';
    Result := not Assigned(aBasePtr) or (ToEditValue(aBasePtr, aEndPtr, aElement) <> Default);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, Default);
  end;
end;

function TwbStringMgefCodeDef.ToStringNative(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aTransformType: TwbStringTransformType): string;
var
  lLen, Len : NativeUInt;
  IsAlpha   : Boolean;
  i         : Integer;
  MgefCode  : Cardinal;
  _File     : IwbFile;
  FileID    : Cardinal;
begin
  Result := '';
  Len := NativeUInt(aEndPtr) - NativeUInt(aBasePtr);
  if sdSize > 0 then begin
    if Len > Cardinal(sdSize) then
      Len := sdSize;
  end;

  if sdForward then begin
    lLen := 0;
    while lLen < Len do begin
      if PByte(aBasePtr)[lLen] = 0 then
        Break;
      Inc(lLen);
    end;
    Len := lLen;
  end else
    while (Len > 0) and (PByte(aBasePtr)[Pred(Len)] = 0) do
      Dec(Len);

  if Len = 4 then begin
    IsAlpha := True;
    for i := 0 to 3 do
      if not(PAnsiChar(aBasePtr)^ in ['a'..'z', 'A'..'Z', '0'..'9', '_']) then begin
        IsAlpha := False;
        break;
      end;
    if not IsAlpha then begin
      MgefCode := PCardinal(aBasePtr)^;
      if (MgefCode and $80000000) <> 0 then begin
        if Assigned(aElement) then begin
          _File := aElement._File;
          if Assigned(_File) then begin
            FileID := MgefCode and $000000FF;

            if aTransformType <> ttCheck then begin
              if FileID >= _File.MasterCount[aElement.MastersUpdated] then
                Result := _File.FileName
              else
                Result := _File.Masters[FileID, aElement.MastersUpdated].FileName;

              Result := Result + ':' + IntToStr((MgefCode and not $800000FF) shr 8);
            end;
            Exit;
          end;
        end;
      end;

      if aTransformType = ttCheck then
        Exit('Effect Code is neither alphanumeric nor dynamic');

      Result := IntToHex(MgefCode, 8);
      if aTransformType =  ttToString then
        Result := Result + ' <Warning: Effect Code is neither alphanumeric nor dynamic>';

      Exit;
    end;
  end;

  Result := inherited ToStringNative(aBasePtr, aEndPtr, aElement, aTransformType);
  i := Length(Result);

  if aTransformType = ttCheck then
    if i = 0 then begin
      Result := inherited ToStringNative(aBasePtr, aEndPtr, aElement, ttToString);
      i := Length(Result);
    end else
      Exit;

  if i <> 4 then
    case aTransformType of
      ttToString:
        Result := Result + ' <Warning: Expected 4 bytes but found ' + i.ToString + '>';
      ttCheck:
        Exit('Expected 4 bytes but found ' + i.ToString + ': ' + Result);
    end;

  if aTransformType = ttCheck then
    Result := '';
end;

function GetContainerFromUnion(const aElement: IwbElement): IwbContainer;
begin  // Should change the name to GetContainerFromUnionOrValue :)
  if (aElement.ElementType = etUnion) or (aElement.ElementType = etValue) then begin
    Result := aElement.Container;
    while Result.ElementType = etUnion do
      Result := Result.Container
  end else
    Result := aElement as IwbContainer;
end;

function GetContainerRefFromUnionOrValue(const aElement: IwbElement): IwbContainerElementRef;
begin
  Result := nil;
  if (aElement.ElementType = etUnion) or (aElement.ElementType = etValue) then begin
    Supports(aElement.Container, IwbContainerElementRef, Result);
    while Assigned(Result) and (Result.ElementType = etUnion) do
      Supports(Result.Container, IwbContainerElementRef, Result);
  end else
    Supports(aElement, IwbContainerElementRef, Result);
end;

function GetElementFromUnion(const aElement: IwbElement): IwbElement;
begin
  if (aElement.ElementType = etUnion) then begin
    Result := aElement.Container;
    while Assigned(Result) and (Result.ElementType = etUnion) do
      Result := Result.Container;
  end else
    Result := aElement;
end;

{ TwbStringKCDef }

function TwbStringKCDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToSortKey);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

{ TwbLStringKCDef }

function TwbLStringKCDef.ToSortKey(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; aExtended: Boolean): string;
begin
  Result := ToStringTransform(aBasePtr, aEndPtr, aElement, ttToSortKey);
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSortKey);
end;

{ TwbRefID }

var
  wbRefIDArray : TwbRefIDArray = nil;

procedure InitializeRefIDArray(anArray: TwbRefIDArray);
begin
  wbRefIDArray := anArray;
end;

procedure TwbRefID.BuildRef(aInt: Int64; const aElement: IwbElement);
var
  key        : Integer;
  val        : Integer;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  // First two bits are the key:
  key := aInt shr 22;
  val := aInt and $003FFFFF;
  case key of
    0: if (val > 0) and (val < Length(wbRefIDArray)) then
         inherited BuildRef(wbRefIDArray[val - 1], aElement);
    1: inherited BuildRef(val, aElement); // '['+IntToHex64(val, 8)+'] Skyrim.esm FormID';
  end;
end;

function TwbRefID.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  key        : Integer;
  val        : Int64;
begin
  // First two bits are the key:
  key := aInt shr 22;
  val := aInt and $003FFFFF;
  case key of
    0: if val = 0 then
         Result := '[00000000] NULL'
       else if val < Length(wbRefIDArray) then begin
         val := wbRefIDArray[val - 1];
         Result := inherited ToString(val, aElement, aForSummary);
         Result := Copy(Result, 1, Pos('[', Result)) + IntToHex64(val, 8) + Copy(Result, Pos(']', Result), Length(Result));
       end else
         Result := '['+IntToHex64(val-1, 8)+'] Index in FormID Array';
    1: Result := inherited ToString(val, aElement, aForSummary);
    2: Result := '[FF'+IntToHex64(val, 6)+'] Created FormID';
    else
      Result := '['+IntToHex64(aInt, 8)+']  <Error: bad key for RefID '+IntToStr(key)+'>';
  end;
  Result := IntToStr(aInt)+' '+Result;
  Used(aElement, Result);
end;

{ TwbDumpIntegerDefFormater }

function TwbDumpIntegerDefFormater.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := IntToHex64(aInt, 8);
end;

function TwbDumpIntegerDefFormater.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
begin
  Result := IntToStr(aInt) + ' [' + IntToHex64(aInt, 8) + '] ['+IntToStr(aInt and $03)+':'+IntToStr(aInt shr 2)+']';
end;

{ TwbStructCDef }

constructor TwbStructCDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbStructCDef do
    Self.Create(defPriority, defRequired, ndName, stMembers, stSortKey,
      stExSortKey, stOptionalFromElement, ndDontShow, ndAfterLoad, ndAfterSet,
      scSizeCallback, scGetChapterType, scGetChapterTypeName, scGetChapterName, defGetCP).AfterClone(aSource);
end;

constructor TwbStructCDef.Create(aPriority: TwbConflictPriority;
                                 aRequired            : Boolean;
                           const aName                : string;
                           const aMembers             : array of IwbValueDef;
                           const aSortKey, aExSortKey : array of Integer;
                                 aOptionalFromElement : Integer;
                                 aDontShow            : TwbDontShowCallback;
                                 aAfterLoad           : TwbAfterLoadCallback;
                                 aAfterSet            : TwbAfterSetCallback;
                                 aSizeCallBack        : TwbSizeCallback;
                                 aGetChapterType      : TwbGetChapterTypeCallback;
                                 aGetChapterTypeName  : TwbGetChapterTypeNameCallback;
                                 aGetChapterName      : TwbGetChapterNameCallback;
                                 aGetCP               : TwbGetConflictPriority);
begin
  scSizeCallback := aSizeCallback;
  scGetChapterType := aGetChapterType;
  scGetChapterTypeName := aGetChapterTypeName;
  scGetChapterName := aGetChapterName;
  inherited Create(aPriority, aRequired, aName, aMembers, aSortKey, aExSortKey, [], aOptionalFromElement, aDontShow, aAfterLoad, aAfterSet, aGetCP);
  ndTreeBranch := False;
end;

function TwbStructCDef.GetDefType: TwbDefType;
begin
  Result := dtStructChapter;
end;

function TwbStructCDef.GetDefTypeName: string;
begin
  Result := 'Chapter';
end;

function TwbStructCDef.GetSizing(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var CompressedSize: Integer): Cardinal;
begin
  if Assigned(scSizeCallback) then
    Result := scSizeCallback(aBasePtr, aEndPtr, aElement, CompressedSize)
  else begin
    CompressedSize := -1;
    Result := 0;
  end;
end;

function TwbStructCDef.GetChapterName(aBasePtr, aEndPtr: Pointer;
  const aElement: IwbElement): string;
begin
  if Assigned(scGetChapterName) then
    Result := scGetChapterName(aBasePtr, aEndPtr, aElement)
  else if Assigned(scGetChapterTypeName) then
    Result := scGetChapterTypeName(aBasePtr, aEndPtr, aElement)
  else
    Result := GetName;
end;

function TwbStructCDef.GetChapterType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if Assigned(scGetChapterType) then
    Result := scGetChapterType(aBasePtr, aEndPtr, aElement)
  else
    Result := -1;
end;

function TwbStructCDef.GetChapterTypeName(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  if Assigned(scGetChapterTypeName) then
    Result := scGetChapterTypeName(aBasePtr, aEndPtr, aElement)
  else
    Result := IntToStr(GetChapterType(aBasePtr, aEndPtr, aElement));
end;

{ TwbKey2Data6EnumDef }

function TwbKey2Data6EnumDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := IntToHex64(aInt, 2);
end;

function TwbKey2Data6EnumDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  key : Integer;
  val : Integer;
begin
  key := aInt shr 6;
  val := aInt and $3f;
  if val>=Length(enNames) then
    Result := 'Bad enum index: ' + IntToStr(val) + ' [' + IntToHex64(val, 2) + ']'
  else
    Result := enNames[val];
  case key of
    0: Result := Result + ' Small size';
    1: Result := Result + ' Medium size';
    2: Result := Result + ' Large size';
  end;
end;

{ TwbData6Key2EnumDef }

function TwbData6Key2EnumDef.ToSortKey(aInt: Int64; const aElement: IwbElement): string;
begin
  Result := IntToHex64(aInt, 2);
end;

function TwbData6Key2EnumDef.ToString(aInt: Int64; const aElement: IwbElement; aForSummary: Boolean): string;
var
  key : Integer;
begin
  if aInt < Power(2, 6) then
    key := 0
  else if aInt < Power(2, 14) then
    key := 1
  else if aInt < Power(2, 22) then
    key := 2
  else
    key := 3;
  Result := IntToStr(aInt);
  case key of
    0: Result := Result + ' Small size';
    1: Result := Result + ' Medium size';
    2: Result := Result + ' Large size';
    3: Result := '0' + ' Null size';
  end;
end;

{ TwbIntegerDefFormaterUnion }

function TwbIntegerDefFormaterUnion.Assign(const aTarget: IwbElement; aIndex: Integer; const aSource: IwbElement; aOnlySK: Boolean): IwbElement;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aTarget);
  if Assigned(IntegerDef) then
    Result := IntegerDef.Assign(aTarget, aIndex, aSource, aOnlySK)
  else
    Result := nil;
end;

procedure TwbIntegerDefFormaterUnion.BuildRef(aInt     : Int64;
                                        const aElement : IwbElement);
var
  IntegerDef: IwbIntegerDefFormater;
begin
  if dfExcludeFromBuildRef in defFlags then
    Exit;

  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    IntegerDef.BuildRef(aInt, aElement);
end;

function TwbIntegerDefFormaterUnion.CanAssign(const aElement : IwbElement;
                                                    aIndex   : Integer;
                                              const aDef     : IwbDef)
                                                             : Boolean;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  if dfDontAssign in defFlags then
    Exit(False);

  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.CanAssign(aElement, aIndex, aDef)
  else
    Result := False;
end;

function TwbIntegerDefFormaterUnion.Check(aInt     : Int64;
                                    const aElement : IwbElement)
                                                   : string;
begin
  Result := Decide(aElement).Check(aInt, aElement);
end;

constructor TwbIntegerDefFormaterUnion.Clone(const aSource: TwbDef);
begin
  with aSource as TwbIntegerDefFormaterUnion do
    Self.Create(idfuDecider, idfuMembers).AfterClone(aSource);
end;

function TwbIntegerDefFormaterUnion.CompareExchangeFormID(var aInt       : Int64;
                                                              aOldFormID : TwbFormID;
                                                              aNewFormID : TwbFormID;
                                                        const aElement   : IwbElement)
                                                                         : Boolean;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.CompareExchangeFormID(aInt, aOldFormID, aNewFormID, aElement)
  else
    Result := False;
end;

constructor TwbIntegerDefFormaterUnion.Create(aDecider  : TwbIntegerDefFormaterUnionDecider;
                                        const aMembers  : array of IwbIntegerDefFormater);
var
  i: Integer;
begin
  inherited Create;
  idfuDecider := aDecider;
  SetLength(idfuMembers, Length(aMembers));
  for i := Low(aMembers) to High(aMembers) do
    idfuMembers[i] := (aMembers[i] as IwbDefInternal).SetParent(Self, False) as IwbIntegerDefFormater;
end;

function TwbIntegerDefFormaterUnion.Decide(const aElement : IwbElement)
                                                          : IwbIntegerDefFormater;
var
  i: Integer;
begin
  i := idfuDecider(aElement);
  if (i>=0) and (i<Length(idfuMembers)) then
    Result := idfuMembers[i]
  else
    Result := nil;
end;

procedure TwbIntegerDefFormaterUnion.FindUsedMasters(aInt     : Int64;
                                                     aMasters : PwbUsedMasters;
                                               const aElement : IwbElement);
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    IntegerDef.FindUsedMasters(aInt, aMasters, aElement);
end;

function TwbIntegerDefFormaterUnion.FromEditValue(const aValue   : string;
                                                  const aElement : IwbElement)
                                                                 : Int64;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.FromEditValue(aValue, aElement)
  else
    Result := 0;
end;

function TwbIntegerDefFormaterUnion.FromLinksTo(const aValue, aElement: IwbElement): Int64;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.FromLinksTo(aValue, aElement)
  else
    Result := 0;
end;

function TwbIntegerDefFormaterUnion.GetDefType: TwbDefType;
begin
  Result := dtIntegerFormaterUnion;
end;

function TwbIntegerDefFormaterUnion.GetEditInfo(const aElement: IwbElement): TwbStringArray;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.GetEditInfo(aElement)
  else
    Result := nil;
end;

function TwbIntegerDefFormaterUnion.GetEditType(const aElement : IwbElement): TwbEditType;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.GetEditType(aElement)
  else
    Result := etDefault;
end;

function TwbIntegerDefFormaterUnion.GetIsEditable(aInt     : Int64;
                                            const aElement : IwbElement)
                                                           : Boolean;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.GetIsEditable(aInt, aElement)
  else
    Result := False;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbIntegerDefFormaterUnion.GetLinksTo(aInt     : Int64;
                                         const aElement : IwbElement)
                                                        : IwbElement;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.GetLinksTo(aInt, aElement)
  else
    Result := nil;
end;

function TwbIntegerDefFormaterUnion.GetMember(aIndex: Integer): IwbIntegerDefFormater;
begin
  if (aIndex>=0) and (aIndex<Length(idfuMembers)) then
    Result := idfuMembers[aIndex];
end;

function TwbIntegerDefFormaterUnion.GetMemberCount: Integer;
begin
  Result := Length(idfuMembers);
end;

function TwbIntegerDefFormaterUnion.GetNoReach: Boolean;
var
  i: Integer;
begin
  for i := Low(idfuMembers) to High(idfuMembers) do
    if idfuMembers[i].NoReach then
      Exit(True);
  Result := False;
end;

procedure TwbIntegerDefFormaterUnion.InitFromParentDoChildren;
begin
  inherited;
  for var lMemberIdx := Low(idfuMembers) to High(idfuMembers) do
    if Assigned(idfuMembers[lMemberIdx]) then
      (idfuMembers[lMemberIdx] as IwbDefInternal).InitFromParent(Self);
end;

function TwbIntegerDefFormaterUnion.MastersUpdated(aInt      : Int64;
                                             const aOld      : TwbFileIDs;
                                             const aNew      : TwbFileIDs;
                                                   aOldCount : Byte;
                                                   aNewCount : Byte;
                                             const aElement  : IwbElement)
                                                             : Int64;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.MastersUpdated(aInt, aOld, aNew, aOldCount, aNewCount, aElement)
  else
    Result := 0;
end;

procedure TwbIntegerDefFormaterUnion.Report(const aParents: TwbDefPath);
begin
  inherited;

end;

function TwbIntegerDefFormaterUnion.ToEditValue(aInt     : Int64;
                                          const aElement : IwbElement)
                                                         : string;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.ToEditValue(aInt, aElement)
  else
    Result := '';
end;

function TwbIntegerDefFormaterUnion.ToSortKey(aInt     : Int64;
                                        const aElement : IwbElement)
                                                       : string;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.ToSortKey(aInt, aElement)
  else
    Result := '';
end;

function TwbIntegerDefFormaterUnion.ToString(aInt        : Int64;
                                       const aElement    : IwbElement;
                                             aForSummary : Boolean)
                                                         : string;
var
  IntegerDef: IwbIntegerDefFormater;
begin
  IntegerDef := Decide(aElement);
  if Assigned(IntegerDef) then
    Result := IntegerDef.ToString(aInt, aElement, aForSummary)
  else
    Result := '';
end;

function wbFindRecordDef(const aSignature : TwbSignature;
                           out aRecordDef : PwbMainRecordDef)
                                          : Boolean;
var
  Hash     : Integer;
  Index    : Integer;
  RDE      : PwbRecordDefEntry;

begin
  Hash := Cardinal(aSignature) mod RecordDefHashMapSize;
  Index := Pred(wbRecordDefHashMap[Hash]);
  if Index >= 0 then begin
    RDE := @wbRecordDefs[Index];
    while Assigned(RDE) do begin
      if Cardinal(RDE.rdeSignature) = Cardinal(aSignature) then begin
        aRecordDef := @RDE.rdeDef;
        Exit(True);
      end;
      if RDE.rdeNext >= 0 then
        RDE := @wbRecordDefs[RDE.rdeNext]
      else
        RDE := nil;
    end;
  end;
  aRecordDef := nil;
  Result := False;
end;

function wbFindRecordDef(const aSignature : AnsiString;
                           out aRecordDef : PwbMainRecordDef)
                                          : Boolean;
begin
  Result := (Length(aSignature) = 4) and
    wbFindRecordDef(PwbSignature(@aSignature[1])^, aRecordDef);
end;

var
  wbRecordDefMap: TStringList;

function _wbRecordDefMap: TStringList;
var
  i: Integer;
begin
  if not Assigned(wbRecordDefMap) then begin
    wbRecordDefMap := TwbFastStringList.Create;
    for i := Low(wbRecordDefs) to High(wbRecordDefs) do
      with wbRecordDefs[i] do
        wbRecordDefMap.AddObject(rdeSignature, Pointer(rdeDef));
    wbRecordDefMap.Sorted := True;
  end;
  Result := wbRecordDefMap;
end;

{$IFDEF USE_CODESITE}
threadvar
  wbCodeSiteLoggingCount: Integer;

function wbCodeSiteLoggingEnabled: Boolean;
begin
  Result := wbCodeSiteLoggingCount > 0;
end;

function wbBeginCodeSiteLogging: Integer;
begin
  Result := Succ(wbCodeSiteLoggingCount);
  wbCodeSiteLoggingCount := Result;
end;

function wbEndCodeSiteLogging: Integer;
begin
  Result := Pred(wbCodeSiteLoggingCount);
  wbCodeSiteLoggingCount := Result;
end;
{$ENDIF}

{ TwbFlagDef }

constructor TwbFlagDef.Clone(const aSource: TwbDef);
begin
  with (aSource as TwbFlagDef) do
    Self.Create(defPriority, defRequired, ndName, ndAfterLoad, ndAfterSet,
      ndDontShow, defGetCP, ndTerminator, fdFlagIndex).AfterClone(aSource);
end;

constructor TwbFlagDef.Create(aPriority   : TwbConflictPriority;
                              aRequired   : Boolean;
                        const aName       : string;
                              aAfterLoad  : TwbAfterLoadCallback;
                              aAfterSet   : TwbAfterSetCallback;
                              aDontShow   : TwbDontShowCallback;
                              aGetCP      : TwbGetConflictPriority;
                              aTerminator : Boolean;
                              aFlagIndex  : Integer);
begin
  fdFlagIndex := aFlagIndex;
  inherited Create(aPriority, aRequired, aName, aAfterLoad, aAfterSet, aDontShow, aGetCP, aTerminator);
end;

function TwbFlagDef.GetCanBeZeroSize: Boolean;
begin
  Result := True;
end;

function TwbFlagDef.GetConflictPriority(const aElement: IwbElement): TwbConflictPriority;
begin
  with GetFlagsDef do begin
    if FlagIgnoreConflict[GetFlagIndex] then
      Result := cpIgnore
    else
      Result := cpNormal;
    FlagGetCP(aElement, GetFlagIndex, Result);
  end;
end;

function TwbFlagDef.GetConflictPriorityCanChange: Boolean;
begin
  Result := GetFlagsDef.FlagHasGetCP[GetFlagIndex];
end;

function TwbFlagDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
end;

function TwbFlagDef.GetDefType: TwbDefType;
begin
  Result := dtFlag;
end;

function TwbFlagDef.GetDefTypeName: string;
begin
  Result := 'FlagDef';
end;

function TwbFlagDef.GetDontShow(const aElement: IwbElement): Boolean;
begin
  Result := GetFlagsDef.FlagDontShow[aElement, GetFlagIndex];
end;

function TwbFlagDef.GetFlagIndex: Integer;
begin
  Result := fdFlagIndex;
end;

function TwbFlagDef.GetFlagsDef: IwbFlagsDef;
begin
  Result := defParent as IwbFlagsDef;
end;

function TwbFlagDef.GetHasDontShow: Boolean;
begin
  Result := GetFlagsDef.FlagHasDontShow[GetFlagIndex];
end;

function TwbFlagDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
end;

function TwbFlagDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Assert(False);
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
end;

function wbIsModule(aFileName: string): Boolean;
begin
  Result := SameText(aFileName, wbGameExeName);
  if not Result then
    for var i := Low(wbModuleExtensions) to High(wbModuleExtensions) do
      if aFileName.EndsWith(wbModuleExtensions[i], True) or aFileName.EndsWith(wbModuleExtensions[i] + csDotGhost, True) then
        Exit(True);
end;

function wbIsSave(aFileName: string): Boolean;
begin
  Result := False;
  for var i := Low(wbSaveExtensions) to High(wbSaveExtensions) do
    if aFileName.EndsWith(wbSaveExtensions[i], True) or aFileName.EndsWith(wbSaveExtensions[i] + csDotGhost, True) then
      Exit(True);
end;


function wbStr4ToString(aInt: Int64): string;
var
  U32  : Cardinal;
  Temp : string;
  i    : Integer;
begin
  if aInt=0 then
    Result := '    '
  else begin
    U32 := aInt;
    Result := PwbSignature(@U32)^;
    if Length(Result)=4 then begin
      Temp := Result;
      for i := 1 to 4 do Result[i] := Temp[5-i];
    end else begin
      Result := '    ';
      // wbProgressCallback('Found a str4 that does not have 4 characters! (1) '+IntToHex64(aInt, 8));
    end;
  end;
end;

{ TwbFormID }

class operator TwbFormID.Add(const A: TwbFormID; B: Int64): TwbFormID;
begin
  Result := A;
  Result.ObjectID := Result.ObjectID + B;
end;

function TwbFormID.ChangeFileID(aFileID: TwbFileID): TwbFormID;
begin
  Result := Self;
  Result.FileID := aFileID;
end;

class function TwbFormID.Compare(const A, B: TwbFormID): Integer;
begin
  Result := CmpW32(A._FormID, B._FormID);
end;

class function TwbFormID.FromVar(const aValue: Variant): TwbFormID;
begin
  if VarIsOrdinal(aValue) then begin
    var lInt64 := Int64(aValue);
    if (lInt64 < -1) and (lInt64 >= Low(Integer)) then begin
      var lInteger: Integer := lInt64;
      lInt64 := Cardinal(lInteger);
    end;
    if lInt64 > High(Cardinal) then
      lInt64 := -1;
    if lInt64 >= 0 then
      Result._FormID := lInt64;
  end else with FindVarData(aValue)^ do
    if VType = wbVarPointer then
      Result._FormID := NativeUInt(VPointer)
    else
      Result._FormID := StrToInt64('$' + string(aValue));
end;

class function TwbFormID.FromStrDef(aValue: string; aDef: Cardinal): TwbFormID;
begin
  if wbPrettyFormID then
    aValue := StringReplace(aValue, ' ', '', [rfReplaceAll]);
  Result._FormID := StrToInt64Def('$' + aValue, aDef);
end;

class function TwbFormID.FromStr(aValue: string): TwbFormID;
begin
  if wbPrettyFormID then
    aValue := StringReplace(aValue, ' ', '', [rfReplaceAll]);
  Result._FormID := StrToInt64('$' + aValue);
end;

class function TwbFormID.FromCardinal(const aValue: Cardinal): TwbFormID;
begin
  Result._FormID := aValue;
end;

class operator TwbFormID.Equal(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID = B._FormID;
end;

function TwbFormID.GetFileID: TwbFileID;
begin
  Result := TwbFileID.CreateFromFormID(_FormID);
end;

function TwbFormID.GetObjectID: Cardinal;
begin
  if FileID.IsLightSlot then
    Result := _FormID and $FFF
  else if FileID.IsMediumSlot then
    Result := _FormID and $FFFF
  else
    Result := _FormID and $FFFFFF;
end;

class operator TwbFormID.GreaterThan(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID > B._FormID;
end;

class operator TwbFormID.GreaterThanOrEqual(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID >= B._FormID;
end;

class operator TwbFormID.Inc(const A: TwbFormID): TwbFormID;
var
  Mask: Cardinal;
begin
  var lFileID := a.FileID;

  if lFileID.IsLightSlot then
    Mask := $FFF
  else if lFileID.IsMediumSlot then
    Mask := $FFFF
  else
    Mask := $FFFFFF;

  Result._FormID := (A._FormID and (not Mask)) or Max(Succ(A._FormID and Mask) and Mask, 2048);
end;

function TwbFormID.IsHardcoded: Boolean;
begin
  Result := _FormID < $800;
end;

function TwbFormID.IsNone: Boolean;
begin
  Result := _FormID = $FFFFFFFF;
end;

function TwbFormID.IsNull: Boolean;
begin
  Result := _FormID = 0;
end;

function TwbFormID.IsPlayer: Boolean;
begin
  Result := _FormID = $00000014;
end;

class operator TwbFormID.LessThan(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID < B._FormID;
end;

class operator TwbFormID.LessThanOrEqual(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID <= B._FormID;
end;

class function TwbFormID.None: TwbFormID;
begin
  Result := TwbFormID.FromCardinal($FFFFFFFF);
end;

class operator TwbFormID.NotEqual(const A, B: TwbFormID): Boolean;
begin
  Result := A._FormID <> B._FormID;
end;

class function TwbFormID.Null: TwbFormID;
begin
  Result := TwbFormID.FromCardinal(0);
end;

procedure TwbFormID.SetFileID(const Value: TwbFileID);
begin
  var lFormID := _FormID;
  try
    var lObjectID := ObjectID;

    _FormID := Value.BaseFormID;

    SetObjectID(lObjectID, True);
  except
    _FormID := lFormID;
    raise;
  end;
end;

procedure TwbFormID.SetObjectID(const Value: Cardinal);
begin
  SetObjectID(Value, False);
end;

procedure TwbFormID.SetObjectID(const Value: Cardinal; aSilent: Boolean);
var
  Mask: Cardinal;
begin
  var lFileID := FileID;

  if lFileID.IsLightSlot then
    Mask := $FFF
  else if lFileID.IsMediumSlot then
    Mask := $FFFF
  else
    Mask := $FFFFFF;

  if not aSilent then
    if Value <> (Value and Mask) then
      raise ERangeError.Create('ObjectID out of bounds');

  _FormID := (_FormID and (not Mask)) or Value;
end;

class operator TwbFormID.Subtract(const A, B: TwbFormID): Int64;
begin
  Result := A._FormID - B._FormID;
end;

class operator TwbFormID.Subtract(const A: TwbFormID; B: Int64): TwbFormID;
begin
  Result := A;
  Result.ObjectID := Result.ObjectID - B;
end;

function TwbFormID.ToString(aForDisplay: Boolean): string;
begin
  Result := IntToHex64(_FormID, 8);

  if wbPrettyFormID and aForDisplay then begin
    Insert(' ', Result, 3);

    var lFileID := FileID;
    if lFileID.IsLightSlot then
      Insert(' ', Result, 7)
    else if lFileID.IsMediumSlot then
      Insert(' ', Result, 6);
  end;
end;

{ TwbFileID }

function TwbFileID.BaseFormID: Cardinal;
begin
  if IsLightSlot then
    Result := (Cardinal(LightFullSlot) shl 24) or (Cardinal(_LightSlot) shl 12)
  else if IsMediumSlot then
    Result := (Cardinal(MediumFullSlot) shl 24) or (Cardinal(_MediumSlot) shl 16)
  else if IsFullSlot then
    Result := Cardinal(_FullSlot) shl 24
  else
    Result := $FFFFFFFF;
end;

class function TwbFileID.CreateFromFormID(aFormID: Cardinal): TwbFileID;
begin
  Result._FullSlot := aFormID shr 24;

  if (Result._FullSlot = LightFullSlot) and (wbPseudoLight or wbIsLightSupported) then
    Result._LightSlot := (aFormID shr 12) and $FFF
  else
    Result._LightSlot := -1;

  if (Result._FullSlot = MediumFullSlot) and (wbPseudoMedium or wbIsMediumSupported) then
    Result._MediumSlot := (aFormID shr 16) and $FF
  else
    Result._MediumSlot := -1;
end;

class function TwbFileID.CreateFull(aFullSlot: SmallInt): TwbFileID;
begin
  with Result do begin
    _FullSlot := aFullSlot;
    _MediumSlot := -1;
    _LightSlot := -1;
  end;
end;

class function TwbFileID.CreateMedium(aMediumSlot: SmallInt): TwbFileID;
begin
  Assert(wbIsMediumSupported or wbPseudoMedium);
  with Result do begin
    _FullSlot := MediumFullSlot;
    _MediumSlot := aMediumSlot;
    _LightSlot := -1;
  end;
end;

class function TwbFileID.CreateLight(aLightSlot: SmallInt): TwbFileID;
begin
  Assert(wbIsLightSupported or wbPseudoLight);
  with Result do begin
    _FullSlot := LightFullSlot;
    _MediumSlot := -1;
    _LightSlot := aLightSlot;
  end;
end;

class operator TwbFileID.Equal(const A, B: TwbFileID): Boolean;
begin
  Result := (A._FullSlot = B._FullSlot)
        and (A._MediumSlot = B._MediumSlot)
        and (A._LightSlot = B._LightSlot);
end;

function TwbFileID.GetModuleType: TwbModuleType;
begin
  if _LightSlot >= 0 then
    Result := mtLight
  else if _MediumSlot >= 0 then
    Result := mtMedium
  else
    Result := mtFull;
end;

class function TwbFileID.MediumFullSlot: SmallInt;
begin
  if wbPseudoMedium or wbIsMediumSupported then
    Result := $FD
  else
    Result := -1;
end;

function TwbFileID.IsLightSlot: Boolean;
begin
  Result := _LightSlot >= 0;
end;

function TwbFileID.IsValid: Boolean;
begin
  Result := (_LightSlot >= 0) or (_MediumSlot >= 0) or (_FullSlot >= 0);
end;

class function TwbFileID.LightFullSlot: SmallInt;
begin
  if wbPseudoLight or wbIsLightSupported then
    Result := $FE
  else
    Result := -1;
end;

class function TwbFileID.MaxFullSlot: SmallInt;
begin
  Result := $FE;
  if wbPseudoLight or wbIsLightSupported then begin
    Dec(Result); //$FD
    if wbPseudoMedium or wbIsMediumSupported then
      Dec(Result); //$FC
  end;
end;

class function TwbFileID.MaxMediumSlot: SmallInt;
begin
 if wbPseudoMedium or wbIsMediumSupported then
   Result := $FF
 else
   Result := -1;
end;

class function TwbFileID.MaxLightSlot: SmallInt;
begin
 if wbPseudoLight or wbIsLightSupported then
   Result := $FFF
 else
   Result := -1;
end;

class function TwbFileID.Invalid: TwbFileID;
begin
  Result._LightSlot := -1;
  Result._MediumSlot := -1;
  Result._FullSlot := -1;
end;

function TwbFileID.IsFullSlot: Boolean;
begin
  Result := (not IsLightSlot) and (not IsMediumSlot) and (_FullSlot >= 0);
end;

function TwbFileID.IsMediumSlot: Boolean;
begin
  Result := _MediumSlot >= 0;
end;

class operator TwbFileID.NotEqual(const A, B: TwbFileID): Boolean;
begin
  Result := (A._FullSlot <> B._FullSlot)
         or (A._MediumSlot <> B._MediumSlot)
         or (A._LightSlot <> B._LightSlot);
end;

class function TwbFileID.Null: TwbFileID;
begin
  Result._LightSlot := -1;
  Result._MediumSlot := -1;
  Result._FullSlot := 0;
end;

function TwbFileID.ToString: string;
begin
  if _LightSlot >= 0 then
    Result := 'FE ' + IntToHex(_LightSlot, 3)
  else
    if _MediumSlot >= 0 then
      Result := 'FD ' + IntToHex(_MediumSlot, 2)
    else
      if _FullSlot >= 0 then
        Result := IntToHex(_FullSlot, 2)
      else
        Result := 'XX';
end;

{ TwbCRC32Helper }

function TwbCRC32Helper.AssignFromString(const s: string): Boolean;
begin
  Result := Length(s) = 8;
  if Result then try
    Self := StrToInt64('$' + s);
  except
    Exit(False);
  end;
end;

function TwbCRC32Helper.IsNone: Boolean;
begin
  Result := Self = $FFFFFFFF;
end;

function TwbCRC32Helper.IsNull: Boolean;
begin
  Result := Self = 0;
end;

function TwbCRC32Helper.IsValid: Boolean;
begin
  Result := not (IsNull or IsNone);
end;

function TwbCRC32Helper.ToString: string;
begin
  Result := IntToHex(Self, 8);
end;

{ TwbCRC32sHelper }

procedure TwbCRC32sHelper.Add(aCRC32: TwbCRC32);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  Self[Len] := aCRC32;
end;

function TwbCRC32sHelper.Contains(aCRC32: TwbCRC32): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := Low(Self) to High(Self) do
    if Self[i] = aCRC32 then
      Exit(True);
end;

{ TwbMessageTypeHelper }

function TwbMessageTypeHelper.ToString: string;
begin
  Result := wbMessageTypeString[Self];
end;

{ TwbMessage }

function TwbMessage.ToString: string;
begin
  Result := msgType.ToString + ': ' + msgMessage;
end;

{ TwbMessagesHelper }

procedure TwbMessagesHelper.AddMessage(aType: TwbMessageType; const aMessage: string);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  with Self[Len] do begin
    msgType := aType;
    msgMessage := aMessage;
  end;
end;

procedure TwbMessagesHelper.Clear;
begin
  Self := nil;
end;

function TwbMessagesHelper.ToPtrs: TwbMessagePtrs;
var
  i: Integer;
begin
  SetLength(Result, Length(Self));
  for i := Low(Self) to High(Self) do
    Result[i] := @Self[i];
end;

{ TwbMessagePtrsHelper }

procedure TwbMessagePtrsHelper.AddMessages(const aMessages: TwbMessagePtrs);
var
  Len: Integer;
  i: Integer;
begin
  if Length(aMessages) < 1 then
    Exit;
  Len := Length(Self);
  SetLength(Self, Len + Length(aMessages));
  for i := Low(aMessages) to High(aMessages) do
    Self[Len+i] := aMessages[i];
end;

procedure TwbMessagePtrsHelper.AddMessages(const aMessages: TwbMessages);
var
  Len: Integer;
  i: Integer;
begin
  if Length(aMessages) < 1 then
    Exit;
  Len := Length(Self);
  SetLength(Self, Len + Length(aMessages));
  for i := Low(aMessages) to High(aMessages) do
    Self[Len+i] := @aMessages[i];
end;

function TwbMessagePtrsHelper.ToStrings: TwbStringArray;
var
  i: Integer;
begin
  Result := nil;
  SetLength(Result, Length(Self));
  for i := Low(Self) to High(Self) do
    Result[i] := Self[i].ToString;
end;

{ TwbRecordDefsHelper }

procedure TwbMainRecordDefsHelper.Add(const aMainRecordDef: IwbMainRecordDef);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  Self[Len] := aMainRecordDef;
end;

{ TDynMainRecordsHelper }

procedure TDynMainRecordsHelper.Add(const aMainRecord: IwbMainRecord);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  Self[Len] := aMainRecord;
end;

{ TDynElementsHelper }

procedure TDynElementsHelper.Add(const aElement: IwbElement);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  Self[Len] := aElement;
end;


{ TwbRecursiveDef }

constructor TwbRecursiveDef.Clone(const aSource: TwbDef);
begin
  with aSource as TwbRecursiveDef do
    Self.Create(defPriority, defRequired, ndName, rdLevelsUp, ndDontShow, ndAfterSet, defGetCP).AfterClone(aSource);
end;

constructor TwbRecursiveDef.Create(aPriority : TwbConflictPriority;
                                   aRequired : Boolean;
                             const aName     : string;
                                   aLevelsUp : Integer;
                                   aDontShow : TwbDontShowCallback;
                                   aAfterSet : TwbAfterSetCallback;
                                   aGetCP    : TwbGetConflictPriority);
begin
  inherited Create(aPriority, aRequired, aName, nil, aAfterSet, aDontShow, aGetCP, False);
  rdLevelsUp := aLevelsUp;
end;

function TwbRecursiveDef.ResolveDef(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): IwbValueDef;
var
  i : Integer;
begin
  if Assigned(rdCached) then
    Exit(rdCached);

  Result := nil;
  for i := 1 to rdLevelsUp do
    if i = 1 then begin
      if not Supports(defParent, IwbValueDef, Result) then
        Exit(nil);
    end else
      if not Supports(Result.Parent, IwbValueDef, Result) then
        Exit(nil);

  rdCached := Result;
end;

{ TwbRecordMemberDef }

function TwbRecordMemberDef.IncludeFlag(aFlag: TwbDefFlag; aOnlyWhenTrue: Boolean): IwbRecordMemberDef;
begin
  Result := inherited IncludeFlag(aFlag, aOnlyWhenTrue) as IwbRecordMemberDef;
end;

function TwbRecordMemberDef.SetAfterLoad(const aAfterLoad: TwbAfterLoadCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetAfterLoad(aAfterLoad));

  Result := Self;
  ndAfterLoad := aAfterLoad;
end;

function TwbRecordMemberDef.SetAfterSet(const aAfterSet: TwbAfterSetCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetAfterSet(aAfterSet));

  Result := Self;
  ndAfterSet := aAfterSet;
end;

function TwbRecordMemberDef.SetDontShow(const aDontShow: TwbDontShowCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetDontShow(aDontShow));

  Result := Self;
  ndDontShow := aDontShow;
end;

function TwbRecordMemberDef.SetIsRemovable(const aCallback: TwbIsRemovableCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetIsRemovable(aCallback));

  Result := Self;
  ndIsRemovable := aCallback;
end;

function TwbRecordMemberDef.SetRequired(const aRequired: Boolean): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetRequired(aRequired));

  Result := Self;
  defRequired := aRequired;
end;

function TwbRecordMemberDef.SetSummaryLinksToCallback(const aCallback: TwbLinksToCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetSummaryLinksToCallback(aCallback));

  Result := Self;
  ndSummaryLinksToCallback := aCallback;
end;

function TwbRecordMemberDef.SetSummaryName(const aName: string): IwbRecordMemberDef;
begin
  Result := inherited SetSummaryName(aName) as IwbRecordMemberDef;
end;

function TwbRecordMemberDef.SetToStr(const aToStr: TwbToStrCallback): IwbRecordMemberDef;
begin
  if defIsLocked then
    Exit(TwbRecordMemberDef(Duplicate).SetToStr(aToStr));

  Result := Self;
  ndToStr := aToStr;
end;

function TwbRecordMemberDef.ToSummary(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
  if Assigned(ndToStr) then
    ndToStr(Result, nil, nil, aElement, ctToSummary);
  if Result = '' then
    Result := ToSummaryInternal(aDepth, aElement, aLinksTo);

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

function TwbRecordMemberDef.ToSummaryInternal(aDepth: Integer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := '';
end;

{ TwbBaseSignatureDef }

function TwbBaseSignatureDef.CanHandle(const aContainer     : IwbContainerElementRef;
                                             aSignature     : TwbSignature;
                                       const aDataContainer : IwbDataContainer)
                                                            : Boolean;
begin
  Result := aSignature = GetDefaultSignature;
end;

function TwbBaseSignatureDef.GetDefaultSignature: TwbSignature;
begin
  Result := #0#0#0#0;
end;

function TwbBaseSignatureDef.GetFullName: string;
begin
  Result := inherited;
  if GetSignatureCount > 0 then
    Result := GetSignature(0) + ' - ' + Result;
end;

function TwbBaseSignatureDef.GetSignature(const aIndex: Integer): TwbSignature;
begin
  Result := GetDefaultSignature;
end;

function TwbBaseSignatureDef.GetSignatureCount: Integer;
begin
  if GetDefaultSignature <> #0#0#0#0 then
    Result := 1
  else
    Result := 0;
end;

{ TwbGridCell }

class operator TwbGridCell.Equal(const a, b: TwbGridCell): Boolean;
begin
  Result :=
    (a.x = b.x) and
    (a.y = b.y);
end;

function TwbGridCell.SortKey: string;
begin
  Result := IntToHex(Int64(x) + Abs(Low(Integer)), 8) + '|' + IntToHex(Int64(y) + Abs(Low(Integer)), 8);
end;

{ TwbVersion }

class operator TwbVersion.Equal(const A, B: TwbVersion): Boolean;
begin
  Result :=
    (A.Major = B.Major) and
    (A.Minor = B.Minor) and
    (A.Release = B.Release) and
    SameText(A.Build, B.Build);
end;

class operator TwbVersion.GreaterThan(const A, B: TwbVersion): Boolean;
begin
  Result :=
    (A.Major > B.Major) or
    (
      (A.Major = B.Major) and
      (
        (A.Minor > B.Minor) or
        (
          (A.Minor = B.Minor) and
          (
            (A.Release > B.Release) or
            (
              (A.Release = B.Release) and
              (CompareText(A.Build, B.Build) > 0)
            )
          )
        )
      )
    );
end;

class operator TwbVersion.GreaterThanOrEqual(const A, B: TwbVersion): Boolean;
begin
  Result := (A > B) or (A = B);
end;

class operator TwbVersion.Implicit(const s: string): TwbVersion;
var
  t  : string;
  i  : Integer;
  sl : TwbStringArray;
begin
  with Result do begin
    t := s;
    i := Pos(' ', t);
    if i > 0 then begin
      Title := Copy(t, Succ(i), High(Integer));
      Delete(t, i, High(Integer));
    end else
      Title := '';

    sl := t.Split(['.']);

    Major := 0;
    Minor := 0;
    Release := 0;
    Build := '';
    if Length(sl) >= 1 then begin
      Major := StrToInt(sl[0]);
      if Length(sl) >= 2 then begin
        Minor := StrToInt(sl[1]);
        if Length(sl) >= 3 then begin
          t := sl[2];
          i := 1;
          while (i <= Length(t)) and (t[i] in ['0'..'9']) do
            Inc(i);
          if i <= Length(t) then begin
            Build := Copy(t, i, High(Integer));
            Delete(t, i, High(Integer));
          end;
          Release := StrToInt(t);
        end;
      end;
    end;
  end;
end;

class operator TwbVersion.LessThan(const A, B: TwbVersion): Boolean;
begin
  Result := not (A >= B);
end;

class operator TwbVersion.LessThanOrEqual(const A, B: TwbVersion): Boolean;
begin
  Result := (A < B) or (A = B);
end;

class operator TwbVersion.NotEqual(const A, B: TwbVersion): Boolean;
begin
  Result := not (A = B);
end;

function TwbVersion.ToCardinal: Cardinal;
begin
  Result :=
    (Cardinal(VersionString.Major   and $000000FF) shl 24) or
    (Cardinal(VersionString.Minor   and $000000FF) shl 16) or
    (Cardinal(VersionString.Release and $000000FF) shl  8);
  if (Length(Build) = 1) and (Build[1] in ['a'..'z']) then
    Result := Result + Succ(Ord(Build[1]) -  Ord('a'));
end;

function TwbVersion.ToString: string;
begin
  Result := Self;
end;

class operator TwbVersion.Implicit(const aVersion: TwbVersion): string;
begin
  with aVersion do begin
    Result := Major.ToString + '.' +
              Minor.ToString + '.' +
              Release.ToString +
              Build;
    if Title <> '' then
      Result := Result + ' ' + Title;
  end;
end;

function wbNextObjectIDToString(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  if aType in [ctToStr, ctToSortKey, ctToEditValue] then begin
    Result := IntToHex(aInt, 8);
    if aType = ctToEditValue then
      Result := '$' + Result;
  end else
    Result := '';
end;

function wbNextObjectIDToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s     : string;
  _File : IwbFile;
begin
  Result := 2048;
  s := Trim(aString);
  if Length(s) > 0 then
    if s = '?' then begin
      if not Assigned(aElement) then
        Exit;
      _File := aElement._File;
      if not Assigned(_File) then
        Exit;
      Result := _File.HighObjectID + 1;
    end else
      Result := StrToInt(s);
end;

procedure TwbFilesHelper.Add(const aFile: IwbFile);
var
  Len: Integer;
begin
  Len := Length(Self);
  SetLength(Self, Succ(Len));
  Self[Len] := aFile;
end;

{ TwbBaseStringDef }

procedure TwbBaseStringDef.AfterClone(const aSource: TwbDef);
begin
  inherited;
  with aSource as TwbBaseStringDef do begin
    Self.bsdEncodingOverride := bsdEncodingOverride;
    if Assigned(bsdFormater) then
      Self.bsdFormater := (bsdFormater as IwbDefInternal).SetParent(Self, False) as IwbStringDefFormater;
  end;
end;

function TwbBaseStringDef.bsdGetEncoding(const aElement: IwbElement): TEncoding;
var
  _File: IwbFile;
begin
  Result := bsdEncodingOverride;
  if not Assigned(Result) then begin
    if Assigned(aElement) then begin
      _File := aElement._File;
      if Assigned(_File) then
        Exit(_File.Encoding[dfTranslatable in defFlags]);
    end;
    if dfTranslatable in defFlags then
      Result := wbEncodingTrans
    else
      Result := wbEncoding;
  end;
end;

constructor TwbBaseStringDef.Create(aPriority   : TwbConflictPriority;
                                    aRequired   : Boolean;
                              const aName       : string;
                                    aAfterLoad  : TwbAfterLoadCallback;
                                    aAfterSet   : TwbAfterSetCallback;
                                    aDontShow   : TwbDontShowCallback;
                                    aGetCP      : TwbGetConflictPriority;
                                    aTerminator : Boolean);
begin
  inherited;
end;

function TwbBaseStringDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
begin
  if Assigned(vdEditInfo) then
    Exit(vdEditInfo^);

  inherited;
  if Assigned(bsdFormater) then
    Result := bsdFormater.EditInfo[aElement];

  if Assigned(ndToStr) then
    with TStringList.Create do try
      if Length(Result) > 0 then
        AddStrings(Result);
      var s := CommaText;
      ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditInfo);
      CommaText := s;
      Result := ToStringArray;
    finally
      Free;
    end;
end;

function TwbBaseStringDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
begin
  inherited;
  if Assigned(bsdFormater) then
    Result := bsdFormater.EditType[aElement]
  else
    Result := etDefault;

  if Assigned(ndToStr) then begin
    var s := '';
    if Result = etComboBox then
      s := 'ComboBox'
    else if Result = etCheckComboBox then
      s := 'CheckComboBox';
    ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditType);
    if SameText(s, 'ComboBox') then
      Result := etComboBox
    else if SameText(s, 'CheckComboBox') then
      Result := etCheckComboBox
    else begin
      Assert(s = '', 'Invalid result from ToStr ctEditType callback for ' + GetFullPath);
      Result := etDefault;
    end;
  end;
end;

procedure TwbBaseStringDef.InitFromParentDoChildren;
begin
  inherited;
  if Assigned(bsdFormater) then
    (bsdFormater as IwbDefInternal).InitFromParent(Self);
end;

function TwbBaseStringDef.OverrideEncoding(aEncoding: TEncoding): IwbBaseStringDef;
begin
  if defIsLocked then
    Exit(TwbBaseStringDef(Duplicate).OverrideEncoding(aEncoding));

  Result := Self;
  bsdEncodingOverride := aEncoding;
end;

procedure TwbBaseStringDef.Report(const aParents: TwbDefPath);
begin
  if defReported or (dfNoReport in defFlags) then
    Exit;

  inherited;
  if Assigned(bsdFormater) then begin
    var Parents := aParents;
    SetLength(Parents, Succ(Length(Parents)));
    Parents[High(Parents)].Def := Self;
    Parents[High(Parents)].Index := -1;
    bsdFormater.Report(aParents);
  end;

  defReported := True;
end;

function TwbBaseStringDef.SetFormater(const aFormater: IwbStringDefFormater): IwbBaseStringDef;
begin
  if defIsLocked then
    Exit(TwbBaseStringDef(Duplicate).SetFormater(aFormater));

  Result := Self;
  if Assigned(aFormater) then
    bsdFormater := (aFormater as IwbDefInternal).SetParent(Self, False) as IwbStringDefFormater;
end;

procedure wbAddLEncodingIfMissing(const aLanguage: string; aEncoding: TEncoding; aFallback: Boolean); overload;
var
  i: Integer;
begin
  if aLanguage = '' then
    Exit;
  if not Assigned(aEncoding) then
    Exit;
  if not wbLEncoding[aFallback].Find(aLanguage, i) then
    wbLEncoding[aFallback].AddObject(aLanguage, aEncoding);
end;

procedure wbAddLEncodingIfMissing(const aLanguage: string; const aEncoding: string; aFallback: Boolean); overload;
var
  i: Integer;
begin
  if aLanguage = '' then
    Exit;
  if aEncoding = '' then
    Exit;
  if not wbLEncoding[aFallback].Find(aLanguage, i) then try
    wbLEncoding[aFallback].AddObject(aLanguage, wbMBCSEncoding(aEncoding));
  except end;
end;

procedure wbAddDefaultLEncodingsIfMissing(aFallback: Boolean);
begin
  wbAddLEncodingIfMissing('english', '1252', aFallback);
  wbAddLEncodingIfMissing('french', '1252', aFallback);
  wbAddLEncodingIfMissing('polish', '1250', aFallback);
  wbAddLEncodingIfMissing('czech', '1250', aFallback);
  wbAddLEncodingIfMissing('danish', '1252', aFallback);
  wbAddLEncodingIfMissing('finnish', '1252', aFallback);
  wbAddLEncodingIfMissing('german', '1252', aFallback);
  wbAddLEncodingIfMissing('greek', '1253', aFallback);
  wbAddLEncodingIfMissing('italian', '1252', aFallback);
  wbAddLEncodingIfMissing('japanese', TEncoding.UTF8, aFallback);
  wbAddLEncodingIfMissing('norwegian', '1252', aFallback);
  wbAddLEncodingIfMissing('portuguese', '1252', aFallback);
  wbAddLEncodingIfMissing('spanish', '1252', aFallback);
  wbAddLEncodingIfMissing('swedish', '1252', aFallback);
  wbAddLEncodingIfMissing('turkish', '1254', aFallback);
  wbAddLEncodingIfMissing('russian', '1251', aFallback);
  wbAddLEncodingIfMissing('chinese', TEncoding.UTF8, aFallback);
  wbAddLEncodingIfMissing('hungarian', '1250', aFallback);
  wbAddLEncodingIfMissing('arabic', '1256', aFallback);
end;

function wbEncodingForLanguage(const aLanguage: string; aFallback: Boolean): TEncoding;
var
  i: Integer;
begin
  Result := wbLEncodingDefault[aFallback];
  if wbLEncoding[aFallback].Find(aLanguage, i) then
    Result := wbLEncoding[aFallback].Objects[i] as TEncoding;
end;

var
  _MBCSEncodings: TStringList;

function wbMBCSEncoding(aCP: Cardinal): TEncoding;
var
  s: string;
  i: Integer;
begin
  s := aCP.ToString;
  if _MBCSEncodings.Find(s, i) then
    Result := _MBCSEncodings.Objects[i] as TEncoding
  else begin
    Result := TMBCSEncoding.Create(aCP);
    _MBCSEncodings.AddObject(s, Result);
  end;
end;

function wbMBCSEncoding(s: string): TEncoding; overload;
var
  CP: Cardinal;
begin
  if SameText(s, 'utf-8') or SameText(s, 'utf8') then
    Result := TEncoding.UTF8
  else begin
    if s.StartsWith('windows-') then
      Delete(s, 1, Length('windows-'));
    CP := StrToInt(s);
    if CP = 65001 then
      Result := TEncoding.UTF8
    else
      Result := wbMBCSEncoding(CP);
  end;
end;

procedure wbVCI1ToStrBeforeFO4(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  c       : Cardinal;
  Day,
  Month,
  Year,
  User,
  Index   : Integer;
begin
  if aType = ctToStr then begin
    c := PCardinal(aBasePtr)^;

    if c <> 0 then begin
      Day := c and $FF;
      c := c shr 8;

      Year := c and $FF;
      c := c shr 8;
      Dec(Year);
      Month := Succ(Year mod 12);
      Year := Year div 12;
      Inc(Year, 2003);

      User := c and $FF;
      c := c shr 8;

      Index := c and $FF;

      aValue := Format('%.4d-%.2d-%.2d User: %d Index: %d', [Year, Month, Day, User, Index]);
    end else
      aValue := 'None';
  end;
end;

procedure wbVCI1ToStrAfterFO4(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  c       : Cardinal;
  Day,
  Month,
  Year,
  User,
  Index   : Integer;
begin
  if aType = ctToStr then begin
    c := PCardinal(aBasePtr)^;

    if c <> 0 then begin
      Day := c and $1F;
      c := c shr 5;

      Month := c and $0F;
      c := c shr 4;

      Year := c and $7F;
      Inc(Year, 2000);
      c := c shr 7;

      User := c and $FF;
      c := c shr 8;

      Index := c and $FF;

      aValue := Format('%.4d-%.2d-%.2d User: %d Index: %d', [Year, Month, Day, User, Index]);
    end else
      aValue := 'None';
  end;
end;

procedure wbTimeStampToString(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  c       : Cardinal;
  Day,
  Month,
  Year    : Integer;
begin
  if aType = ctToStr then begin
    c := PWord(aBasePtr)^;

    if c <> 0 then begin
      Day := c and $1F;
      c := c shr 5;

      Month := c and $0F;
      c := c shr 4;

      Year := c and $7F;
      Inc(Year, 2000);
      //c := c shr 7;

      aValue := Format('%.4d-%.2d-%.2d', [Year, Month, Day]);
    end else
      aValue := 'None';
  end;
end;

function ShortenText(const aText: string; const aWidth: Integer; const aPlaceholder: string): string;
begin
  // collapse whitespace (all whitespace is replaced by single spaces)
  Result := TRegEx.Replace(aText, '\t\n\v\f\r', ' ');

  if Length(Result) > aWidth then
  begin
    SetLength(Result, aWidth - Length(aPlaceholder));
    Result := Result + aPlaceholder;
  end;
end;

function DummyIntegerFunction: Integer;
begin
  Result := 0;
end;

{ TwbDefTypesHelper }

function TwbDefTypesHelper.Count: Integer;
begin
  Result := 0;
  for var i:= Low(TwbDefType) to High(TwbDefType) do
    if i in Self then
      Inc(Result);
end;

{ TwbElementTypesHelper }

function TwbElementTypesHelper.Count: Integer;
begin
  Result := 0;
  for var i:= Low(TwbElementType) to High(TwbElementType) do
    if i in Self then
      Inc(Result);
end;

{ TwbIndexKeys }

procedure TwbIndexKeys.Clear;
begin
  ikKeys := nil;
end;

function TwbIndexKeys.GetChangedKeys(const aOldKeys: TwbIndexKeys): TwbChangedKeys;
begin
  var lNewHigh := High(ikKeys);
  var lOldHigh := High(aOldKeys.ikKeys);

  var lMinHigh := Min(lNewHigh, lOldHigh);
  var lMaxHigh := Max(lNewHigh, lOldHigh);

  SetLength(Result, Succ(lMaxHigh));
  var lResultIdx := 0;
  for var lIdx := 0 to lMinHigh do
    if (
         (lIdx in _NamedIndicesCaseSensitive) and
         (ikKeys[lIdx] <> aOldKeys.ikKeys[lIdx])
       ) or (
         (not (lIdx in _NamedIndicesCaseSensitive)) and
         (not SameText(ikKeys[lIdx], aOldKeys.ikKeys[lIdx]))
       )
    then begin
      Result[lResultIdx].ckIndex  := lIdx;
      Result[lResultIdx].ckOldKey := aOldKeys.ikKeys[lIdx];
      Result[lResultIdx].ckNewKey := ikKeys[lIdx];
      Inc(lResultIdx);
    end;
  if lNewHigh > lOldHigh then begin
    for var lNewIdx := Succ(lMinHigh) to lNewHigh do
      if ikKeys[lNewIdx] <> '' then begin
        Result[lResultIdx].ckIndex := lNewIdx;
        Result[lResultIdx].ckOldKey := '';
        Result[lResultIdx].ckNewKey := ikKeys[lNewIdx];
        Inc(lResultIdx);
      end;
  end else if lOldHigh > lNewHigh then begin
    for var lOldIdx := Succ(lMinHigh) to lOldHigh do
      if aOldKeys.ikKeys[lOldIdx] <> '' then begin
        Result[lResultIdx].ckIndex := lOldIdx;
        Result[lResultIdx].ckOldKey := aOldKeys.ikKeys[lOldIdx];
        Result[lResultIdx].ckNewKey := '';
        Inc(lResultIdx);
      end;
  end;
  SetLength(Result, lResultIdx);
end;

function TwbIndexKeys.GetContains(aIndex: TwbNamedIndex): Boolean;
begin
  Result :=
    (aIndex >= 0) and
    (High(ikKeys) >= aIndex) and
    (ikKeys[aIndex] <> '');
end;

function TwbIndexKeys.GetDefinedKeys: TwbDefinedKeys;
begin
  var lHigh := High(ikKeys);
  SetLength(Result, Succ(lHigh));
  var lResultIdx := 0;
  for var lIdx := 0 to lHigh do
    if ikKeys[lIdx] <> '' then begin
      Result[lResultIdx].dkIndex := lIdx;
      Result[lResultIdx].dkKey := ikKeys[lIdx];
      Inc(lResultIdx);
    end;
  SetLength(Result, lResultIdx);
end;

function TwbIndexKeys.GetKey(aIndex: TwbNamedIndex): string;
begin
  if (aIndex >= 0) and
     (High(ikKeys) >= aIndex)
  then
    Result := ikKeys[aIndex]
  else
    Result := '';
end;

function TwbIndexKeys.IsEmpty: Boolean;
begin
  var lHigh := High(ikKeys);
  for var lIdx := 0 to lHigh do
    if ikKeys[lIdx] <> '' then
      Exit(False);
  if lHigh >= 0 then
    Clear;
  Result := True;
end;

procedure TwbIndexKeys.SetKey(aIndex: TwbNamedIndex; const aValue: string);
begin
  if (aIndex < 0) or (aIndex >= _NamedIndices.Count) then
    Exit;
  var lHigh := High(ikKeys);
  if lHigh < aIndex then
    if aValue = '' then
      Exit
    else
      SetLength(ikKeys, Succ(aIndex));
  ikKeys[aIndex] := aValue;
end;

var
  _RecordsInit: Boolean = False;

procedure wbInitRecords;
begin
  if _RecordsInit then
    Exit;
  _RecordsInit := True;

  for var Looped := False to True do begin
    for var lRecordIdx := Low(wbRecordDefs) to High(wbRecordDefs) do begin
      var lDef: IwbDefInternal;
      if Supports(wbRecordDefs[lRecordIdx].rdeDef, IwbDefInternal, lDef) then
        lDef.InitFromParent(nil);
    end;
    if Assigned(wbMainRecordHeader) then
      (wbMainRecordHeader as IwbDefInternal).InitFromParent(nil);
  end;
end;

function wbGetUnknownIntString(aInt: Int64): string;
begin
  Result := '<Unknown: ' + aInt.ToString;
  if wbExtendedIntUnknowns then begin
    var lHex := IntToHex(aInt).TrimLeft(['0']);
    if Length(lHex) > 0 then
      Result := Result + ' $' + lHex;
    if Length(lHex) = 8 then begin
      var lCardinal := aInt;
      var s: string := PwbSignature(@lCardinal)^;
      var t := s.ToUpperInvariant;
      if s = t then
        Result := Result + ' ' + t;
    end;
  end;
  Result := Result + '>';
end;

function wbNeverShow(const aElement: IwbElement): Boolean;
begin
  Result := wbHideNeverShow;
end;

var
  _ResourcesLoadedHandlers: TArray<TProc>;

procedure wbResourcesLoaded;
begin
  for var lIdx := Low(_ResourcesLoadedHandlers) to High(_ResourcesLoadedHandlers) do
    _ResourcesLoadedHandlers[lIdx]();
end;

procedure wbRegisterResourcesLoadedHandler(const aHandler: TProc);
begin
  SetLength(_ResourcesLoadedHandlers, Succ(Length(_ResourcesLoadedHandlers)));
  _ResourcesLoadedHandlers[High(_ResourcesLoadedHandlers)] := aHandler;
end;

{ TwbGuidDef }

function TwbGuidDef.CanAssign(const aElement: IwbElement; aIndex: Integer; const aDef: IwbDef): Boolean;
begin
  Result := Supports(aDef, IwbGuidDef);
end;

procedure TwbGuidDef.FromEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
  if Assigned(ndToStr) then begin
    var lValue := aValue;
    ndToStr(lValue, aBasePtr, aEndPtr, aElement, ctFromEditValue);
    if lValue = wbIgnoreStringValue then
      Exit;
    FromStringInternal(aBasePtr, aEndPtr, aElement, lValue);
  end else
    FromStringInternal(aBasePtr, aEndPtr, aElement, aValue);
end;

procedure TwbGuidDef.FromNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: Variant);
begin
  var lValue: string := aValue;

  if Assigned(ndToStr) then begin
    ndToStr(lValue, aBasePtr, aEndPtr, aElement, ctFromNativeValue);
    if lValue = wbIgnoreStringValue then
      Exit;
 end;

  FromStringInternal(aBasePtr, aEndPtr, aElement, lValue);
end;

procedure TwbGuidDef.FromStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; const aValue: string);
begin
  //var lLength := 0;
  //if Assigned(aBasePtr) and Assigned(aEndPtr) then
  //  lLength := NativeInt(aEndPtr) - NativeInt(aBasePtr);

  aElement.RequestStorageChange(aBasePtr, aEndPtr, 16);

  var lValue := aValue;

  if aValue = '' then begin
    var pInt: PInt64 := PInt64(aBasePtr);
    pInt^ := 0;
    Inc(pInt);
    pInt^ := 0;
    Exit;
  end;

  if Length(aValue) <> 38 then
    raise Exception.Create('Not a valid GUID: ' + aValue);

  if (aValue[1] <> '{') or
     (aValue[10] <> '-') or
     (aValue[15] <> '-') or
     (aValue[20] <> '-') or
     (aValue[25] <> '-') or
     (aValue[38] <> '}')
  then
    raise Exception.Create('Not a valid GUID: ' + aValue);

  Delete(lValue, 38, 1);
  Delete(lValue, 25, 1);
  Delete(lValue, 20, 1);
  Delete(lValue, 15, 1);
  Delete(lValue, 10, 1);
  Delete(lValue,  1, 1);

  var lIntA:PInt64 := PInt64(aBasePtr);
  var lIntB := lIntA;
  Inc(lIntB);

  if not (TryStrToInt64('$'+Copy(lValue, 1, 16), lIntA^) and TryStrToInt64('$'+Copy(lValue, 17, 16), lIntB^)) then
    raise Exception.Create('Not a valid GUID: ' + aValue);
end;

function TwbGuidDef.GetDefaultSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 16;
end;

function TwbGuidDef.GetDefType: TwbDefType;
begin
  Result := dtGuid;
end;

function TwbGuidDef.GetDefTypeName: string;
begin
  Result := 'GUID';
end;

function TwbGuidDef.GetEditInfo(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbStringArray;
begin
  if Assigned(vdEditInfo) then
    Exit(vdEditInfo^);

  Result := nil;
  if Assigned(ndToStr) then
    with TStringList.Create do try
      var s := '';
      ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditInfo);
      CommaText := s;
      Result := ToStringArray;
    finally
      Free;
    end;
end;

function TwbGuidDef.GetEditType(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): TwbEditType;
begin
  Result := etDefault;
  if Assigned(ndToStr) then begin
    var s := '';
    ndToStr(s, aBasePtr, aEndPtr, aElement, ctEditType);
    if SameText(s, 'ComboBox') then
      Result := etComboBox
    else if SameText(s, 'CheckComboBox') then
      Result := etCheckComboBox
    else begin
      Assert(s = '', 'Invalid result from ToStr ctEditType callback for ' + GetFullPath);
      Result := etDefault;
    end;
  end;
end;

function TwbGuidDef.GetIsEditable(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := True;
  if defInternalEditOnly then
    if not wbIsInternalEdit then
      Result := False;
end;

function TwbGuidDef.GetSize(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 16;
end;

function TwbGuidDef.SetToDefault(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Boolean;
begin
  Result := Assigned(vdSetToDefault) and vdSetToDefault(aBasePtr, aEndPtr, aElement);
  if Result then
    Exit;

  if vdsHasDefaultNativeValue in vdStates then begin
    Result := not Assigned(aBasePtr) or (ToNativeValue(aBasePtr, aEndPtr, aElement) <> vdDefaultNativeValue);
    if Result then
      FromNativeValue(aBasePtr, aEndPtr, aElement, vdDefaultNativeValue);
  end else begin
    Result := not Assigned(aBasePtr) or (ToEditValue(aBasePtr, aEndPtr, aElement) <> vdDefaultEditValue);
    if Result then
      FromEditValue(aBasePtr, aEndPtr, aElement, vdDefaultEditValue);
  end;
end;

function TwbGuidDef.ToEditValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToEditValue);
end;

function TwbGuidDef.ToNativeValue(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): Variant;
begin
  var lString := ToStringInternal(aBasePtr, aEndPtr, aElement);

  if Assigned(ndToStr) then
    ndToStr(lString, aBasePtr, aEndPtr, aElement, ctToNativeValue);

  Result := lString;
end;

function TwbGuidDef.ToString(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToStr);
  Used(aElement, Result);
end;

function TwbGuidDef.ToStringInternal(aBasePtr, aEndPtr: Pointer; const aElement: IwbElement): string;
begin
  Result := '';

  var lLength := 0;
  if Assigned(aBasePtr) and Assigned(aEndPtr) then
    lLength := NativeInt(aEndPtr) - NativeInt(aBasePtr);
  if lLength < 16 then
    Exit;

  var pInt := PInt64(aBasePtr);
  Result := IntToHex(pInt^);
  Inc(pInt);
  Result := '{' + Result + IntToHex(pInt^) + '}';
  //         11111111112222222222333333333
  //12345678901234567890123456789012345678
  //{25182999-A018-45AC-856A-C8DB4FD7C97F}
  Insert('-', Result, 10);
  Insert('-', Result, 15);
  Insert('-', Result, 20);
  Insert('-', Result, 25);
end;

function TwbGuidDef.ToSummary(aDepth: Integer; aBasePtr, aEndPtr: Pointer; const aElement: IwbElement; var aLinksTo: IwbElement): string;
begin
  Result := ToStringInternal(aBasePtr, aEndPtr, aElement);

  if Assigned(ndToStr) then
    ndToStr(Result, aBasePtr, aEndPtr, aElement, ctToSummary);

  if not Assigned(aLinksTo) and (Result <> '') and Assigned(aElement) then
    aLinksTo := aElement.LinksTo;
end;

procedure TwbFilesHelper.SortByLoadOrder;
begin
  TArray.Sort<IwbFile>(Self, wbFileBySortOrderComparer);
end;

procedure TwbFilesHelper.SortByReverseLoadOrder;
begin
  TArray.Sort<IwbFile>(Self, wbFileByReverseSortOrderComparer);
end;

procedure MakeComparers;
begin
  wbFileBySortOrderComparer :=
    TComparer<IwbFile>.Construct(function(const Left, Right: IwbFile): Integer
    begin
      Result := Left.LoadOrder - Right.LoadOrder;
    end);

  wbFileByReverseSortOrderComparer :=
    TComparer<IwbFile>.Construct(function(const Left, Right: IwbFile): Integer
    begin
      Result := Right.LoadOrder - Left.LoadOrder;
    end);
end;

{ TwbReflectionDef }

procedure TwbReflectionDef.AfterConstruction;
begin
  inherited;
  Include(defFlags, dfNoReport);
  Include(defFlags, dfDontAssign);
  Include(defFlags, dfInternalEditOnly);
  Include(defFlags, dfCanContainReflection);
  Include(defFlags, dfCanContainFormID);
end;

function TwbReflectionDef.GetDefType: TwbDefType;
begin
  Result := dtReflection;
end;

function TwbReflectionDef.GetDefTypeName: string;
begin
  Result := 'Reflection';
end;

initialization
  MakeComparers;

  wbIdxEditorID := wbNamedIndex('EditorID', False);

  _MBCSEncodings := TStringList.Create;
  _MBCSEncodings.CaseSensitive := False;
  _MBCSEncodings.Sorted := True;
  _MBCSEncodings.Duplicates := dupError;
  _MBCSEncodings.OwnsObjects := True;

  wbEncoding := wbMBCSEncoding(1252);
  wbEncodingTrans := wbEncoding;
  wbEncodingVMAD := TEncoding.UTF8;

  wbLEncodingDefault[False] := TEncoding.UTF8;
  wbLEncodingDefault[True] := wbMBCSEncoding(1252);

  wbLEncoding[False] := TStringList.Create;
  wbLEncoding[False].CaseSensitive := False;
  wbLEncoding[False].Sorted := True;
  wbLEncoding[False].Duplicates := dupError;

  wbLEncoding[True] := TStringList.Create;
  wbLEncoding[True].CaseSensitive := False;
  wbLEncoding[True].Sorted := True;
  wbLEncoding[True].Duplicates := dupError;

  TwoPi := 2 * OnePi;

  if (DebugHook = 0) then
    wbReportMode := False;

  wbIgnoreRecords := TStringList.Create;
  wbIgnoreRecords.Sorted := True;
  wbIgnoreRecords.Duplicates := dupIgnore;

  wbProgramPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

  SetLength(wbModuleExtensions, 4);
  wbModuleExtensions[0] := csDotEsp;
  wbModuleExtensions[1] := csDotEsm;
  wbModuleExtensions[2] := csDotEsl;
  wbModuleExtensions[3] := csDotEsu;

  SetLength(wbSaveExtensions, 2);
  wbSaveExtensions[0] := csDotFos;
  wbSaveExtensions[1] := csDotEss;
finalization
  FreeAndNil(wbIgnoreRecords);
  FreeAndNil(wbGroupOrder);
  FreeAndNil(wbRecordDefMap);
  wbRecordDefs := nil;
  wbContainerHandler := nil;
  FreeAndNil(wbLEncoding[True]);
  FreeAndNil(wbLEncoding[False]);
  FreeAndNil(_MBCSEncodings);
  FreeAndNil(_NamedIndices);
end.
