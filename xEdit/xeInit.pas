{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License,
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit xeInit;

{$I xeDefines.inc}
{$R 'xEdit\xeIcons.res'}

interface

uses
  Classes;

var
  xeScriptToRun            : string;
  xeSettingsFileName       : string;
  xePluginToUse            : string;          // Passed a specific plugin as parameter
  xeLogFile                : string;          // Optional log file for this session
  xeMyProfileName          : string;

  xeIconResource           : string;

  xeMasterUpdateDone       : Boolean;
  xeDontBackup             : Boolean = False;
  xeRemoveTempPath         : Boolean = True;
  xeQuickShowConflicts     : Boolean;
  xeVeryQuickShowConflicts : Boolean;
  xeQuickClean             : Boolean;
  xeQuickEdit              : Boolean;
  xeQuickCleanAutoSave     : Boolean;
  xeAutoLoad               : Boolean;
  xeAutoExit               : Boolean;
  xeAutoGameLink           : Boolean;

  xeParamIndex             : Integer = 1;     // First unused parameter
  xeModulesToUse           : TStringList;

  xeSortGroupsByFullName   : Boolean = True;

const
  xeDefaultScriptHost = 'JvI';

function xeFindNextValidCmdLineModule(var aStartIndex  : Integer;
                                      out aValue       : string;
                                    const aDefaultPath : string)
                                                       : Boolean;

function xeLoadMOHookFile: Boolean;
procedure xeSwitchToCoSave;

function xeDoInit: Boolean;
procedure xeInitStyles;

implementation

uses
  System.UITypes,
  SysUtils,
  Windows,
  Registry,
  ShellApi,
  Dialogs,
  ShlObj,
  IOUtils,
  IniFiles,
  Vcl.Themes,
  Vcl.Styles,
  wbHelpers,
  wbInterface,
  wbImplementation,
  wbCommandLine,
  wbLocalization,
  wbDefinitionsCommon,
  wbDefinitionsFNV,
  wbDefinitionsFNVSaves,
  wbDefinitionsFO3,
  wbDefinitionsFO3Saves,
  wbDefinitionsFO4,
  wbDefinitionsFO4Saves,
  wbDefinitionsFO76,
  wbDefinitionsTES3,
  wbDefinitionsTES4,
  wbDefinitionsTES4Saves,
  wbDefinitionsTES5,
  wbDefinitionsTES5Saves,
  wbDefinitionsSF1,
  wbSteamVDFParser,
  xeScriptHost;

function xeCheckForValidExtension(const aFilePath : string): Boolean;
begin
  Result := wbIsModule(aFilePath) or wbIsSave(aFilePath);
end;

function xeFindNextValidCmdLineFileName(var aStartIndex  : Integer;
                                        out aValue       : string;
                                      const aDefaultPath : string = '')
                                                         : Boolean;
begin
  Result := wbFindCmdLineParam(aStartIndex, SwitchChars, aValue);
  if Result and not FileExists(aValue) then
    if (aDefaultPath<>'') then
      if FileExists(aDefaultPath+'\'+aValue) then
        aValue := ExpandFileName(aDefaultPath+'\'+aValue)
      else
        Result := False
    else
      Result := False;
end;

function xeFindNextValidCmdLineModule(var aStartIndex  : Integer;
                                      out aValue       : string;
                                    const aDefaultPath : string)
                                                       : Boolean;
begin
  repeat
    Result := xeFindNextValidCmdLineFileName(aStartIndex, aValue, aDefaultPath);
  until not Result or wbIsModule(aValue);
  if Result  then
    if (AnsiCompareText(ExtractFilePath(ExpandFileName(aValue)), ExpandFileName(aDefaultPath)) = 0) then begin
      aValue := ExtractFileName(aValue);
      if not Assigned(xeModulesToUse) then
        xeModulesToUse := TStringList.Create;
      xeModulesToUse.Add(aValue);
    end else
      Result := False;
end;

// several ini settings should be read before record definitions
// they may affect definitions like wbSimpleRecords
// and should be overridden by command line parameters
function ReadSettings: Boolean;
var
  ResetSettings: Boolean;
  Settings: TMemIniFile;
  Shift,Ctrl,Alt: Boolean;
  s : string;
  sl: TStringList;
  i: Integer;
begin
  Result := True;

  if FileExists(xeSettingsFileName) then begin
    ResetSettings := FindCmdLineSwitch('resetsettings');
    if not ResetSettings then begin
      Shift := GetAsyncKeyState(VK_SHIFT) < 0;
      Ctrl := GetAsyncKeyState(VK_CONTROL) < 0;
      Alt := GetAsyncKeyState(VK_MENU) < 0;
      if Shift and Ctrl and Alt then
        ResetSettings := MessageDlg('Reset ALL settings? (Existing settings file will be backed up.)',
          mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrYes;
    end;

    if ResetSettings then begin
      s := xeSettingsFileName + '.backup.' + FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now);

      if not RenameFile(PChar(xeSettingsFileName), PChar(s)) then begin
        ShowMessage(Format('Could not rename existing settings file to "%s".', [s]));
        Exit(False);
      end else
        ShowMessage(Format('ALL settings have been reset. Existing settings file has been renamed to "%s".', [s]));
    end;
  end;

  if FileExists(xeSettingsFileName) then try
    Settings := TMemIniFile.Create(xeSettingsFileName);
    try
      wbLoadBSAs := Settings.ReadBool('Options', 'LoadBSAs', wbLoadBSAs);
      wbSimpleRecords := Settings.ReadBool('Options', 'SimpleRecords', wbSimpleRecords);
      wbDecodeTextureHashes := Settings.ReadBool('Options', 'DecodeTextureHashes2', wbDecodeTextureHashes); {changed name to enforce new default value}
      wbShowFlagEnumValue := Settings.ReadBool('Options', 'ShowFlagEnumValue', wbShowFlagEnumValue);
      wbTrackAllEditorID := Settings.ReadBool('Options', 'TrackAllEditorID', wbTrackAllEditorID);
      wbAllowDirectSave := Settings.ReadBool('Options', 'AllowDirectSave', wbAllowDirectSave);
      wbSortINFO := Settings.ReadBool('Options', 'SortINFO', wbSortINFO);
      wbFillPNAM := Settings.ReadBool('Options', 'FillPNAM', wbFillPNAM);
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
      sl := TStringList.Create;
      try
        Settings.ReadSection('cpoverride', sl);
        for i := 0 to Pred(sl.Count) do try
          s := sl[i];
          wbAddLEncodingIfMissing(s, Settings.ReadString('cpoverride', s, ''), False);
        except
          on E:Exception do
            ShowMessage('Could not add code page override "'+sl[i]+'" from wbSettingsFileName: ['+E.ClassName+'] ' + E.Message);
        end;
      finally
        sl.Free;
      end;

      if not Settings.ReadBool('Init', 'FirstStart', False) then try
        Settings.WriteBool('Init', 'FirstStart', True);
        if VersionString.Minor mod 2 = 0 then begin
          wbNoGitHubCheck := True;
          Settings.WriteBool('Options', 'NoGitHubCheck', wbNoGitHubCheck);
        end;
        Settings.UpdateFile;
      except end;
    finally
      Settings.Free;
    end;
  except end;
end;

function GetCSIDLShellFolder(CSIDLFolder: Integer): string;
begin
  SetLength(Result, MAX_PATH);
  SHGetSpecialFolderPath(0, PChar(Result), CSIDLFolder, True);
  SetLength(Result, StrLen(PChar(Result)));
  if (Result <> '') then
    Result := IncludeTrailingBackslash(Result);
end;

const
  DataName : array[Boolean] of string = (
    'Data',
    'Data Files'   // gmTES3
  );

function CheckAppPath: string;

  function CheckPath(const aStartFrom: string): string;
  var
    s: string;
  begin
    Result := '';
    s := aStartFrom;
    while Length(s) > 3 do begin
      if FileExists(s + wbGameExeName) and DirectoryExists(s + DataName[wbGameMode = gmTES3]) then begin
        Result := s;
        Exit;
      end;
      s := ExtractFilePath(ExcludeTrailingPathDelimiter(s));
    end;
  end;

var
  CurrentDir, ExeDir: string;
begin
  CurrentDir := IncludeTrailingPathDelimiter(GetCurrentDir);
  Result := CheckPath(CurrentDir);
  if (Result = '') then begin
    ExeDir := ExtractFilePath(ParamStr(0));
    if not SameText(CurrentDir, ExeDir) then
      Result := CheckPath(ExeDir);
  end;
end;

function PathRelativeToFull(const BasePath: string; const AddPath: string) : string;
var CDir : string;
begin
  CDir := GetCurrentDir;
  try
    SetCurrentDir(BasePath);
    Result := ExpandFileName(AddPath);
  finally
    SetCurrentDir(CDir);
  end
end;

{===SafeLoadLibrary============================================================}
{$IFDEF CPUX86}
function TestAndClearFPUExceptions(AExceptionMask: Word): Boolean;
asm
      PUSH    ECX
      MOV     CX, AX
      FSTSW   AX
      TEST    AX, CX
      JNE     @@bad
      XOR     EAX, EAX
      INC     EAX
      JMP     @@exit
@@bad:
      XOR     EAX, EAX
@@exit:
      POP     ECX
      FCLEX
      RET
end;
{------------------------------------------------------------------------------}
function SafeLoadLibrary(const Filename: string; ErrorMode: UINT): HMODULE;
var
  OldMode: UINT;
  FPUControlWord: Word;
begin
  OldMode := SetErrorMode(ErrorMode);
  try
    FPUControlWord := Get8087CW();
    Result := LoadLibrary(PChar(Filename));
    TestAndClearFPUExceptions(0);
    Set8087CW(FPUControlWord);
  finally
    SetErrorMode(OldMode);
  end;
end;
{==============================================================================}
{$ENDIF CPUX86}


function xeLoadMOHookFile: Boolean;
var
  HookDll : HMODULE;
  Init    : function(logLevel: Integer; profileName: LPCWSTR): BOOL; cdecl;
begin
  if not wbShouldLoadMOHookFile then
    Exit(True);
  Result := False;
  if not FileExists(wbMOHookFile) then
    Exit;

  HookDll := SafeLoadLibrary(wbMOHookFile, SEM_NOOPENFILEERRORBOX);
  if HookDll <> 0 then begin
    Pointer(@Init) := GetProcAddress(HookDll, 'Init');
    if Assigned(Pointer(@Init)) then
      Result := Init(0, PWideChar(UnicodeString(wbMOProfile)));
  end;
end;

procedure DoInitPath(const ParamIndex: Integer);
const
  sBethRegKey             = '\SOFTWARE\Bethesda Softworks\';
  sUninstallRegKey        = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\';
  sSureAIRegKey           = '\Software\SureAI\';

var
  s, regPath, regKey, client: string;
  isEpicNV : Boolean;
  IniFile : TMemIniFile;
begin
  wbModGroupFileName := wbProgramPath + wbAppName + wbToolName + '.modgroups';
  isEpicNV := false;

  if not wbFindCmdLineParam('S', wbScriptsPath) then
    wbScriptsPath := wbProgramPath + 'Edit Scripts\';

  if not wbFindCmdLineParam('T', wbTempPath) then
    wbTempPath := IncludeTrailingPathDelimiter(TPath.GetTempPath + wbAppName + 'Edit')
  else
    xeRemoveTempPath := not DirectoryExists(wbTempPath);

  if not wbFindCmdLineParam('D', wbDataPath) then begin
    wbDataPath := CheckAppPath;

    if (wbDataPath = '') then
      for var lID in wbGameSteamID.Split([',']) do
        begin
          wbDataPath := GetInstallPathBySteamID(lID);
          if wbDataPath <> '' then
            break;
        end;

    if (wbDataPath = '') then with TRegistry.Create do try
      Access  := KEY_READ or KEY_WOW64_32KEY;
      RootKey := HKEY_LOCAL_MACHINE;
      client  := 'Steam';

      case wbGameMode of
        gmTES3, gmTES4, gmFO3, gmFNV, gmTES5, gmFO4, gmSSE, gmTES5VR, gmFO4VR: begin
          regPath := sBethRegKey + wbGameNameReg + '\';
        end;
        gmEnderal, gmEnderalSE: begin
          RootKey := HKEY_CURRENT_USER;
          regPath := sSureAIRegKey + wbGameNameReg + '\';
        end;
        gmFO76, gmSF1: begin
          regPath := sUninstallRegKey + wbGameNameReg + '\';
        end;
      end;

      if not OpenKey(regPath, False) then begin
        Access := KEY_READ or KEY_WOW64_64KEY;
        if not OpenKey(regPath, False) then begin
          s := 'Fatal: Could not open registry key: ' + regPath;
          ShowMessage(Format('%s'#13#10'This can happen after %s updates, run the game''s launcher to restore registry settings', [s, client]));
          wbDontSave := True;
          Exit;
        end;
      end;

      case wbGameMode of
      gmTES3, gmTES4, gmFO3, gmFNV, gmTES5, gmFO4, gmSSE, gmTES5VR, gmFO4VR:
                  regKey := 'Installed Path';
      gmEnderal, gmEnderalSE:  regKey := 'Install_Path';
      gmFO76, gmSF1:     regKey := 'InstallLocation';
      end;

      wbDataPath := ReadString(regKey);
      wbDataPath := StringReplace(wbDataPath, '"', '', [rfReplaceAll]);

      if (wbDataPath = '') then begin
        s := Format('Fatal: Could not determine %s installation path, no "%s" registry key', [wbGameName2, regKey]);
        ShowMessage(Format('%s'#13#10'This can happen after %s updates, run the game''s launcher to restore registry settings', [s, client]));
        wbDontSave := True;
      end;
    finally
      Free;
    end;

    if wbDataPath <> '' then
      wbDataPath := IncludeTrailingPathDelimiter(wbDataPath) + DataName[wbGameMode = gmTES3] + '\';
  end else
    wbDataPath := IncludeTrailingPathDelimiter(wbDataPath);

  wbOutputPath := wbDataPath;

  if wbFindCmdLineParam('O', s) and (Length(s) > 0) then
    if s[1] = '.' then
      //assume relative path
      wbOutputPath := IncludeTrailingPathDelimiter(wbOutputPath + s)
    else
      //assume absolute path
      wbOutputPath := IncludeTrailingPathDelimiter(s);

  wbMOHookFile := wbDataPath + '..\Mod Organizer\hook.dll';

  if not wbFindCmdLineParam('M', wbMyGamesTheGamePath) then begin
    xeMyProfileName := GetCSIDLShellFolder(CSIDL_PERSONAL);
    if xeMyProfileName = '' then begin
      ShowMessage('Fatal: Could not determine my documents folder');
      Exit;
    end;

    case wbGameMode of
      gmTES3:
        wbMyGamesTheGamePath := IncludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(wbDataPath)));
    else
      wbMyGamesTheGamePath := xeMyProfileName + 'My Games\' + wbGameName2 + '\';
    end;

    if (wbGameMode in [gmFNV]) and FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(ExcludeTrailingPathDelimiter(wbDataPath))) + 'EOSSDK-Win32-Shipping.dll') then begin
        wbMyGamesTheGamePath := xeMyProfileName + 'My Games\FalloutNV_Epic\';
        isEpicNV := true;
    end;
  end;

  if not wbFindCmdLineParam('I', wbTheGameIniFileName) then begin
    if wbGameMode in [gmFO3, gmFNV] then
      wbTheGameIniFileName := wbMyGamesTheGamePath + 'Fallout.ini'
    else
      wbTheGameIniFileName := wbMyGamesTheGamePath + wbGameName + '.ini';

    // VR games don't create ini file in My Games by default, use the one in the game folder
    if (wbGameMode in [gmTES5VR, gmFO4VR, gmSF1]) and not FileExists(wbTheGameIniFileName) then
      wbTheGameIniFileName := ExtractFilePath(ExcludeTrailingPathDelimiter(wbDataPath)) + '\' + ExtractFileName(wbTheGameIniFileName);
  end;

  if not wbFindCmdLineParam('CustomIni', wbCustomIniFileName) then begin
    if wbGameMode in [gmFO3, gmFNV] then
      wbCustomIniFileName := wbMyGamesTheGamePath + 'FalloutCustom.ini'
    else
      wbCustomIniFileName := wbMyGamesTheGamePath + wbGameName + 'Custom.ini';
  end;

  if not wbFindCmdLineParam('G', wbSavePath) then begin
    if wbMyGamesTheGamePath = '' then
      wbMyGamesTheGamePath := ExtractFilePath(wbTheGameIniFileName);

    s := 'Saves\';
    if FileExists(wbTheGameIniFileName) then begin
      IniFile := TMemIniFile.Create(wbTheGameIniFileName);
      try
        s := IniFile.ReadString('General', 'SLocalSavePath', s);
      finally
        FreeAndNil(IniFile);
      end;
    end;

    if FileExists(wbCustomIniFileName) then begin
      with TMemIniFile.Create(wbCustomIniFileName) do try
        if ValueExists('General', 'SLocalSavePath') then
          s := ReadString('General', 'SLocalSavePath', s);
      finally
        Free;
      end;
    end;
    
    wbSavePath := PathRelativeToFull(wbMyGamesTheGamePath, s);
  end;
  wbSavePath := IncludeTrailingPathDelimiter(wbSavePath);

  xeParamIndex := ParamIndex;
  if not wbFindCmdLineParam('P', wbPluginsFileName) then
    if not (xeFindNextValidCmdLineFileName(xeParamIndex, wbPluginsFileName) and SameText(ExtractFileExt(wbPluginsFileName), '.txt'))
       or xeCheckForValidExtension(wbPluginsFileName)
    then begin
      xeParamIndex := ParamIndex;
      wbPluginsFileName := GetCSIDLShellFolder(CSIDL_LOCAL_APPDATA);
      if wbPluginsFileName = '' then begin
        ShowMessage('Fatal: Could not determine the local application data folder');
        Exit;
      end;

      if wbGameMode = gmFO76 then
        wbPluginsFileName := wbPluginsFileName + wbGameName + '\Plugins.txt'
      else if (wbGameMode = gmFNV) and isEpicNV then
        wbPluginsFileName := wbPluginsFileName + wbGameName + '_Epic' + '\Plugins.txt'
      else
        wbPluginsFileName := wbPluginsFileName + wbGameName2 + '\Plugins.txt';
    end;
  if ExtractFilePath(wbPluginsFileName) = '' then
    wbPluginsFileName := ExpandFileName(wbPluginsFileName);

  // settings in the ini file next to app, or in the same folder with plugins.txt
  xeSettingsFileName := wbProgramPath + wbAppName + wbToolName + '.ini';
  if not FileExists(xeSettingsFileName) then
    xeSettingsFileName := ChangeFileExt(wbPluginsFileName, '.'+LowerCase(wbAppName)+'viewsettings');

  wbBackupPath := '';
  if not (wbDontSave or wbFindCmdLineParam('B', wbBackupPath)) then
    wbBackupPath := wbDataPath + wbAppName + 'Edit Backups\';

  wbCachePath := '';
  if not (wbDontCache or wbFindCmdLineParam('C', wbCachePath)) then
    if wbDataPath <> '' then
      wbCachePath := wbDataPath + wbAppName + 'Edit Cache\';
  if wbCachePath = '' then
    wbDontCache := True;
  if not wbDontCache then
    if not DirectoryExists(wbCachePath) then
      if not ForceDirectories(wbCachePath) then
        wbDontCache := True;
  if wbDontCache then
    wbCachePath := '';

  wbFindCmdLineParam('R', xeLogFile);
end;

var
  wbForcedModes: string;
  AppGameMode, AppToolMode, AppSourceMode: string;

procedure DetectAppMode;
const
  SourceModes : array of string = ['plugins', 'saves'];
  GameModes: array of string = ['tes5vr', 'fo4vr', 'tes3', 'tes4', 'tes5', 'enderalse', 'enderal', 'sse', 'fo3', 'fnv', 'fo4', 'fo76', 'sf1'];
  ToolModes: array of string = [
    'edit', 'view', 'lodgen', 'script', 'translate', 'onamupdate', 'masterupdate', 'masterrestore',
    'setesm', 'clearesm', 'sortandclean', 'sortandcleanmasters',
    'checkforerrors', 'checkforitm', 'checkfordr'];
var
  s, p: string;
begin
  // Detecting game mode
  // check command line params first for mode overrides
  // they should take precedence over application name detection
  // AppSourceMode := SourceModes[1];
  for s in SourceModes do
    if FindCmdLineSwitch(s) or wbFindCmdLineParam(s, p) or (Pos(s, wbForcedModes) <> 0) then begin
      AppSourceMode := s;
      Break;
    end;
  // if no overrrides, then check by executable name
  if AppSourceMode = '' then
    for s in SourceModes do
      if (Pos(s, LowerCase(ExtractFileName(ParamStr(0)))) <> 0) or (Pos(s, wbForcedModes) <> 0) then begin
        AppSourceMode := s;
        Break;
      end;
  // if still nothing, then default value
  if AppSourceMode = '' then
    AppSourceMode := 'plugins';

  for s in GameModes do
    if FindCmdLineSwitch(s) or wbFindCmdLineParam(s, p) or (Pos(s, wbForcedModes) <> 0) then begin
      AppGameMode := s;
      Break;
    end;
  // if no overrrides, then check by executable name
  if AppGameMode = '' then
    for s in GameModes do
      if (Pos(s, LowerCase(ExtractFileName(ParamStr(0)))) <> 0) or (Pos(s, wbForcedModes) <> 0) then begin
        AppGameMode := s;
        Break;
      end;
  // if still nothing, then default value
  if AppGameMode = '' then
    AppGameMode := 'fo4';

  // the same for tool mode
  for s in ToolModes do
    if FindCmdLineSwitch(s) or wbFindCmdLineParam(s, p) or (Pos(s, wbForcedModes) <> 0) then begin
      AppToolMode := s;
      Break;
    end;
  if AppToolMode = '' then
    for s in ToolModes do
      if (Pos(s, LowerCase(ExtractFileName(ParamStr(0)))) <> 0) or (Pos(s, wbForcedModes) <> 0) then begin
        AppToolMode := s;
        Break;
      end;
  if AppToolMode = '' then
    AppToolMode := 'edit';
end;

function isMode(aMode: String): Boolean;
begin
  aMode := LowerCase(aMode);
  Result := (AppGameMode = aMode) or (AppToolMode = aMode) or (AppSourceMode = aMode);
end;

// Force app modes
function CheckForcedMode: Boolean;
var
  s: string;
  i: Integer;
begin
  Result := False;
  // there is a game specific script provided to execute
  // go into 'script' tool mode and detect game mode by script's extension
  i := 1;
  if wbFindCmdLineParam('script', s) or xeFindNextValidCmdLineFileName(i, s) then begin
    xeScriptToRun := s;
    s := ExtractFileExt(s);
    i := Pos(UpperCase('pas'), UpperCase(s));
    if (i > 0) and (i = Length(s) - 2) then begin
      wbForcedModes := Copy(s, 2, Length(s) - 4) + ',script';
      Result := True;
    end;
  end;
end;

function _DoInit: Boolean;
var
  s: string;
  ToolModes: TwbSetOfMode;
  ToolSources: TwbSetOfSource;
  i: Integer;
  ExeName: string;
begin
  ExeName := ChangeFileExt(ExtractFileName(ParamStr(0)), '').ToLowerInvariant;

  if not wbIsAeroEnabled then
    wbThemesSupported := False;

  Result        := True;
  wbReportMode  := False;
  wbEditAllowed := True;
  wbDontSave    := False;
  wbDevMode     := FindCmdLineSwitch('devmode');

  CheckForcedMode;
  DetectAppMode;

  if isMode('Saves') then begin
    wbToolSource := tsSaves;
    wbSourceName := 'Saves';
    wbUseFalsePlugins := True;
  end else begin // defaults to plugin
    wbToolSource := tsPlugins;
    wbSourceName := 'Plugins';
  end;

  if isMode('View') then begin
    wbToolMode    := tmView;
    wbToolName    := 'View';
    wbEditAllowed := False;
    wbDontSave    := True;
  end else if isMode('MasterUpdate') then begin
    wbToolMode    := tmMasterUpdate;
    wbToolName    := 'MasterUpdate';
  end else if isMode('OnamUpdate') then begin
    wbToolMode    := tmOnamUpdate;
    wbToolName    := 'OnamUpdate';
  end else if isMode('MasterRestore') then begin
    wbToolMode    := tmMasterRestore;
    wbToolName    := 'MasterRestore';
  end else if isMode('LODGen') then begin
    wbToolMode    := tmLODgen;
    wbToolName    := 'LODGen';
    wbEditAllowed := False;
    wbDontSave    := True;
  end else if isMode('Script') then begin
    wbToolMode    := tmScript;
    wbToolName    := 'Script';
  end else if isMode('Translate') then begin
    wbToolMode    := tmTranslate;
    wbToolName    := 'Trans';
  end else if isMode('setESM') then begin
    wbToolMode    := tmESMify;
    wbToolName    := 'SettingESMflag';
  end else if isMode('clearESM') then begin
    wbToolMode    := tmESPify;
    wbToolName    := 'ClearingESMflag';
  end else if isMode('SortAndClean') then begin
    wbToolMode    := tmSortAndCleanMasters;
    wbToolName    := 'SortAndCleanMasters';
  end else if isMode('CheckForErrors') then begin
    wbToolMode    := tmCheckForErrors;
    wbToolName    := 'CheckForErrors';
  end else if isMode('CheckForITM') then begin
    wbToolMode    := tmCheckForITM;
    wbToolName    := 'CheckForITM';
  end else if isMode('CheckForDR') then begin
    wbToolMode    := tmCheckForDR;
    wbToolName    := 'CheckForDR';
  end else if isMode('Edit') then begin
    wbToolMode    := tmEdit;
    wbToolName    := 'Edit';
  end else begin
    ShowMessage('Application name must contain Edit, View, LODGen, OnamUpdate, MasterUpdate, MasterRestore, setESM, clearESM, sortAndCleanMasters, CheckForITM, CheckForDR or CheckForErrors to select mode.');
    Exit(False);
  end;

  if not (wbToolMode in [tmView, tmEdit]) then
    wbPrettyFormID := False;

  wbLanguage := 'English';

  wbGameExeName        := '';
  if isMode('FNV') then begin
    wbGameMode         := gmFNV;
    wbAppName          := 'FNV';
    wbGameName         := 'FalloutNV';
    wbGameSteamID      := '22380,22490';
    ToolModes          := wbAlwaysMode + [tmMasterUpdate, tmMasterRestore];
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('FO3') then begin
    wbGameMode         := gmFO3;
    wbAppName          := 'FO3';
    wbGameName         := 'Fallout3';
    wbGameSteamID      := '22370,22300';
    ToolModes          := wbAlwaysMode + [tmMasterUpdate, tmMasterRestore];
    ToolSources        := [tsPlugins];
  end

  else if isMode('TES3') then begin
    wbGameMode         := gmTES3;
    wbAppName          := 'TES3';
    wbGameName         := 'Morrowind';
    wbGameSteamID      := '22320';
    (**)
    ToolModes          := (**)[tmView];(** )wbAlwaysMode - [tmLODgen];(**)
    ToolSources        := [tsPlugins];
    (**)
  end

  else if isMode('TES4') then begin
    wbGameMode         := gmTES4;
    wbAppName          := 'TES4';
    wbGameName         := 'Oblivion';
    wbGameSteamID      := '22330,900883';
    ToolModes          := wbAlwaysMode;
    ToolSources        := [tsPlugins];
  end

  else if isMode('TES5') then begin
    wbGameMode         := gmTES5;
    wbAppName          := 'TES5';
    wbGameName         := 'Skyrim';
    wbGameExeName      := 'TESV';
    wbGameSteamID      := '72850';
    ToolModes          := wbAlwaysMode + [tmOnamUpdate];
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('EnderalSE') then begin
    wbGameMode         := gmEnderalSE;
    wbAppName          := 'EnderalSE';
    wbGameName         := 'Enderal';
    wbGameExeName      := 'SkyrimSE';
    wbGameName2        := 'Enderal Special Edition';
    wbGameNameReg      := 'EnderalSE';
    wbGameMasterEsm    := 'Skyrim.esm';
    wbGameSteamID      := '976620';
    ToolModes          := wbAlwaysMode + [tmOnamUpdate];
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('Enderal') then begin
    wbGameMode         := gmEnderal;
    wbAppName          := 'Enderal';
    wbGameName         := 'Enderal';
    wbGameExeName      := 'TESV';
    wbGameMasterEsm    := 'Skyrim.esm';
    wbGameSteamID      := '933480';
    ToolModes          := wbAlwaysMode + [tmOnamUpdate];
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('TES5VR') then begin
    wbGameMode         := gmTES5VR;
    wbAppName          := 'TES5VR';
    wbGameName         := 'Skyrim';
    wbGameName2        := 'Skyrim VR';
    wbGameExeName      := 'SkyrimVR';
    wbGameSteamID      := '611670';
    ToolModes          := wbAlwaysMode + [tmOnamUpdate];
    ToolSources        := [tsPlugins];
  end

  else if isMode('SSE') then begin
    wbGameMode         := gmSSE;
    wbAppName          := 'SSE';
    wbGameName         := 'Skyrim';
    wbGameExeName      := 'SkyrimSE';
    wbGameName2        := 'Skyrim Special Edition';
    wbGameSteamID      := '489830';
    ToolModes          := wbAlwaysMode + [tmOnamUpdate];
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('FO4') then begin
    wbGameMode         := gmFO4;
    wbAppName          := 'FO4';
    wbGameName         := 'Fallout4';
    wbArchiveExtension := '.ba2';
    wbLanguage         := 'En';
    wbGameSteamID      := '377160';
    ToolModes          := wbAlwaysMode;
    ToolSources        := [tsPlugins, tsSaves];
  end

  else if isMode('FO4VR') then begin
    wbGameMode         := gmFO4VR;
    wbAppName          := 'FO4VR';
    wbGameName         := 'Fallout4';
    wbGameExeName      := 'Fallout4VR';
    wbGameName2        := 'Fallout4VR';
    wbGameNameReg      := 'Fallout 4 VR';
    wbLanguage         := 'En';
    wbArchiveExtension := '.ba2';
    wbGameSteamID      := '611660';
    ToolModes          := wbAlwaysMode;
    ToolSources        := [tsPlugins];
  end

  else if isMode('FO76') then begin
    wbGameMode         := gmFO76;
    wbAppName          := 'FO76';
    wbGameName         := 'Fallout76';
    wbGameName2        := 'Fallout 76';
    wbGameNameReg      := 'Steam App 1151340';
    wbGameMasterEsm    := 'SeventySix.esm';
    wbLanguage         := 'En';
    wbArchiveExtension := '.ba2';
    wbGameSteamID      := '1151340';
    ToolModes          := wbAlwaysMode;
    ToolSources        := [tsPlugins];
  end

  else if isMode('SF1') then begin
    wbGameMode         := gmSF1;
    wbAppName          := 'SF1';
    wbGameName         := 'Starfield';
    wbGameNameReg      := 'Steam App 1716740';
    wbArchiveExtension := '.ba2';
    wbLanguage         := 'En';
    wbGameSteamID      := '1716740';
    ToolModes          := wbAlwaysMode - [tmESMify, tmESPify, tmLODgen];
    ToolSources        := [tsPlugins];
    wbLightName        := 'Small';

    if    wbStarfieldIsABugInfestedHellhole
      and FindCmdLineSwitch('ItJustWorksTM')
      and FindCmdLineSwitch('ThisIsFine')
      and FindCmdLineSwitch('GiveMeTheRedPill')
    then begin
      VersionString.Title := 'ItJustWorks[TM] Edition';
      wbRedPill := True;
      wbStarfieldIsABugInfestedHellhole := False; //you wish... but lets pretend
    end;
  end

  else begin
    ShowMessage('Application name must contain FNV, FO3, FO4, FO4VR, FO76, SSE, TES4, TES5, TES5VR, Enderal, or EnderalSE, SF1 to select game.');
    Exit(False);
  end;

  if wbGameExeName = '' then
    wbGameExeName := wbGameName;

  wbGameExeName := wbGameExeName + csDotExe;

  if wbGameMode in [gmFO3, gmFNV] then begin
    wbUDRSetZ := False;
    wbUDRSetZValue := -15000;
  end;

  if not (wbToolMode in ToolModes) then begin
    ShowMessage('Application ' + wbGameName + ' does not currently support ' + wbToolName);
    Exit(False);
  end;

  if not (wbToolSource in ToolSources) then begin
    ShowMessage('Application ' + wbGameName + ' does not currently support ' + wbSourceName);
    Exit(False);
  end;

  if (wbToolSource = tsSaves) and (wbToolMode = tmEdit) then begin
    ShowMessage('Application ' + wbGameName + ' does not currently support ' + wbSourceName + ' in ' + wbToolName + ' mode.');
    Exit(False);
  end;

  if wbGameName2 = '' then
    wbGameName2 := wbGameName;

  if wbGameNameReg = '' then
    wbGameNameReg := wbGameName2;

  if wbGameMasterEsm = '' then
    wbGameMasterEsm := wbGameName + csDotEsm;

  if FindCmdLineSwitch('DontCache') then
    wbDontCache := True;
  if wbDontCache or FindCmdLineSwitch('DontCacheLoad') then
    wbDontCacheLoad := True;
  if wbDontCache or FindCmdLineSwitch('DontCacheSave') then
    wbDontCacheSave := True;
  if wbDontCacheLoad and wbDontCacheSave then
    wbDontCache := True;

  DoInitPath(xeParamIndex);

  // specific Game settings
  case wbGameMode of
    gmFNV: begin
      wbVWDInTemporary      := True;
      wbLoadBSAs            := False;
      wbCanSortINFO         := True;
    end;
    gmFO3: begin
      wbVWDInTemporary      := True;
      wbLoadBSAs            := False;
      wbCanSortINFO         := True;
    end;
    gmTES3: begin
      wbLoadBSAs            := False;
      wbAllowInternalEdit   := false;
      wbDontCache           := True;
      wbDontCacheLoad       := True;
      wbDontCacheSave       := True;
      wbBuildRefs           := False;
      wbVWDInTemporary      := True;
      wbCreateContainedIn   := False;
    end;
    gmTES4: begin
      if (not FileExists(wbDataPath + 'Oblivion.esm')) and FileExists(wbDataPath + 'Nehrim.esm') then begin
        wbAppName           := 'Nehrim';
        wbGameMasterEsm     := 'Nehrim.esm';
      end;
      wbLoadBSAs            := True;
      wbAllowInternalEdit   := false;
      wbCanSortINFO         := True;
    end;
    gmTES5, gmEnderal, gmTES5VR, gmSSE, gmEnderalSE: begin
      wbVWDInTemporary      := True;
      wbLoadBSAs            := True;  // localization won't work otherwise
      wbHideIgnored         := False; // to show Form Version
      wbCanSortINFO         := True;
      wbHasAddedLightSupport := (wbGameMode = gmTES5VR) and FileExists(wbDataPath + 'SKSE\Plugins\skyrimvresl.dll');
    end;
    gmFO4, gmFO4VR: begin
      wbVWDInTemporary      := True;
      wbVWDAsQuestChildren  := True;
      wbLoadBSAs            := True;  // localization won't work otherwise
      wbHideIgnored         := False; // to show Form Version
      wbAlwaysSaveOnam      := True;
      wbAlwaysSaveOnamForce := True;
    end;
    gmFO76: begin
      wbVWDInTemporary      := True;
      wbVWDAsQuestChildren  := True;
      wbLoadBSAs            := True;  // localization won't work otherwise
      wbHideIgnored         := False; // to show Form Version
      wbAlwaysSaveOnam      := True;
      wbAlwaysSaveOnamForce := True;
    end;
    gmSF1: begin
	  wbComplexFileFileID   := True;
      wbVWDInTemporary      := True;
      wbVWDAsQuestChildren  := True;
      wbLoadBSAs            := True;  // localization won't work otherwise
      wbHideIgnored         := False; // to show Form Version
      wbAlwaysSaveOnam      := True;
      wbAlwaysSaveOnamForce := True;
      wbDecodeTextureHashes := True;
    end;
  else
    ShowMessage('Unknown GameMode');
    Exit(False);
  end;

  wbSortINFO := wbCanSortINFO;

  if not ReadSettings then
    Exit(False);

  if wbGameMode = gmSF1 then
    wbDecodeTextureHashes := True;

  if wbCanSortINFO then begin
    if FindCmdLineSwitch('sortinfo') then
      wbSortINFO := True;

    if FindCmdLineSwitch('nosortinfo') then
      wbSortINFO := False;

    if FindCmdLineSwitch('FillPNAM') then
      wbFillPNAM := True;

    if FindCmdLineSwitch('NoFillPNAM') then
      wbFillPNAM := False;
  end;

  // Was gmTES5, but is now gmEnderal
  if wbGameMode <= gmEnderal then
    wbAddDefaultLEncodingsIfMissing(False)
  else begin
    wbLEncodingDefault[False] := TEncoding.UTF8;
    case wbGameMode of
    gmSSE, gmTES5VR, gmEnderalSE:
      wbAddLEncodingIfMissing('english', '1252', False);
    else {FO4, FO76}
      wbAddLEncodingIfMissing('en', '1252', False);
    end;
  end;

  wbAddDefaultLEncodingsIfMissing(True);

  if wbFindCmdLineParam('AllowDirectSaves', s) then begin
    wbAllowDirectSaveFor := TStringList.Create;
    wbAllowDirectSaveFor.Sorted := True;
    wbAllowDirectSaveFor.Duplicates := dupIgnore;
    wbAllowDirectSaveFor.AddStrings(s.Split([',']).ForEach(Trim).RemoveEmpty);
    if wbAllowDirectSaveFor.Count < 1 then begin
      FreeAndNil(wbAllowDirectSaveFor);
      wbAllowDirectSave := True;
    end;
  end else
    if FindCmdLineSwitch('AllowDirectSaves') then
      wbAllowDirectSave := True;

  if FindCmdLineSwitch('IKnowWhatImDoing') then
  begin
    wbIKnowWhatImDoing := True;

    if FindCmdLineSwitch('AllowMakePartial') then
      wbAllowMakePartial := True;

    if FindCmdLineSwitch('AllowMasterFilesEdit') then
      wbAllowMasterFilesEdit := True;

    if FindCmdLineSwitch('StripEmptyMasters') then
      wbStripEmptyMasters := True;

    if wbFindCmdLineParam('StripMasters', s) then
    begin
      wbStripMasters := True;

      wbStripMastersFileNames := TStringList.Create;
      wbStripMastersFileNames.Sorted := True;
      wbStripMastersFileNames.Duplicates := dupIgnore;
      wbStripMastersFileNames.AddStrings(s.Split([',']).ForEach(Trim).RemoveEmpty);

      if wbStripMastersFileNames.Count < 1 then
      begin
        FreeAndNil(wbStripMastersFileNames);
        wbStripMasters := False;
      end;
    end;
  end;

  if wbToolMode = tmEdit then begin
    if   FindCmdLineSwitch('quickshowconflicts') or FindCmdLineSwitch('qsc')
      or ExeName.Contains('quickshowconflicts') or ExeName.Contains('qsc') then
      xeQuickShowConflicts := True;

    if   FindCmdLineSwitch('veryquickshowconflicts') or FindCmdLineSwitch('vqsc')
      or ExeName.Contains('veryquickshowconflicts') or ExeName.Contains('vqsc') then begin
      xeQuickShowConflicts := True;
      xeVeryQuickShowConflicts := True;
      xeAutoLoad := True;
    end;

    if FindCmdLineSwitch('autoload') then
      xeAutoLoad := True;

    if FindCmdLineSwitch('autoexit') then
      xeAutoExit := True;

    if   FindCmdLineSwitch('autogamelink') or FindCmdLineSwitch('agl')
      or ExeName.Contains('autogamelink') or ExeName.Contains('agl') then begin
      xeAutoLoad := True;
      xeAutoGameLink := True;
    end;

    if xeAutoLoad then
      if xeQuickShowConflicts then
        xeVeryQuickShowConflicts := True;

    if (FindCmdLineSwitch('quickclean') or FindCmdLineSwitch('qc')
      or ExeName.Contains('quickclean') or ExeName.Contains('qc')) and (wbToolSource in [tsPlugins]) then
      xeQuickClean := True;

    if (FindCmdLineSwitch('quickautoclean') or FindCmdLineSwitch('qac')
      or ExeName.Contains('quickautoclean') or ExeName.Contains('qac')) and (wbToolSource in [tsPlugins]) then begin
      xeQuickClean := True;
      xeQuickCleanAutoSave := xeQuickClean;
    end;
  end;

  if FindCmdLineSwitch('dontremoveoffsetdata') then
    wbRemoveOffsetData := False;

  if xeQuickClean then
    wbRemoveOffsetData := True;

  i := 0;
  if xeQuickShowConflicts then
    Inc(i);
  if xeQuickClean then
    Inc(i);
  if xeAutoGameLink then
    Inc(i);

  if i > 1 then begin
    ShowMessage('Can''t activate more than one out of Quick Clean, Quick Show Conflicts, or Auto GameLink modes same time.');
    Exit(False);
  end;

  if xeQuickClean then begin
    wbIKnowWhatImDoing := True;
    wbFillINOM := False;
    wbFillINOA := False;
  end;

  if FindCmdLineSwitch('fixup') then
    wbAllowInternalEdit := True
  else if FindCmdLineSwitch('nofixup') then
    wbAllowInternalEdit := False;

  if FindCmdLineSwitch('skipbsa') then
    wbLoadBSAs := False
  else if FindCmdLineSwitch('forcebsa') then
    wbLoadBSAs := True;

  if FindCmdLineSwitch('skipInternalEditing') then
    wbAllowInternalEdit := False
  else if FindCmdLineSwitch('forceInternalEditing') then
    wbAllowInternalEdit := True;

  if FindCmdLineSwitch('showfixup') then
    wbShowInternalEdit := True
  else if FindCmdLineSwitch('hidefixup') then
    wbShowInternalEdit := False;

  if FindCmdLineSwitch('IgnoreWorldMHDT') then
    wbIgnoreWorldMHDT := True;

  if xeQuickClean then begin
    wbFixupPGRD := True;
    wbAllowInternalEdit := True;
    wbSimpleRecords := False;
  end;

  if wbFindCmdLineParam('l', s) then begin
    wbLanguage := s;
  end else begin
    if FileExists(wbTheGameIniFileName) then begin
      with TMemIniFile.Create(wbTheGameIniFileName) do try
        case wbGameMode of
          gmTES4: case ReadInteger('Controls', 'iLanguage', 0) of
            1: s := 'German';
            2: s := 'French';
            3: s := 'Spanish';
            4: s := 'Italian';
          else
            s := 'English';
          end;
        else
          s := Trim(ReadString('General', 'sLanguage', '')).ToLower;
        end;
      finally
        Free;
      end;
    end;

    if FileExists(wbCustomIniFileName) then begin
       with TMemIniFile.Create(wbCustomIniFileName) do try
        case wbGameMode of
          gmTES4: begin
            if ValueExists('Controls', 'iLanguage') then
              case ReadInteger('Controls', 'iLanguage', 0) of
                1: s := 'German';
                2: s := 'French';
                3: s := 'Spanish';
                4: s := 'Italian';
              else
                s := 'English';
              end;
          end else begin
            if ValueExists('General', 'sLanguage') then
              s := Trim(ReadString('General', 'sLanguage', '')).ToLower;
          end;
        end;
      finally
        Free;
      end;
    end;

    if (s <> '') and not SameText(s, wbLanguage) then
      wbLanguage := s;
  end;

  wbEncodingTrans := wbEncodingForLanguage(wbLanguage, False);

  if wbFindCmdLineParam('cp-general', s) then
    wbEncoding :=  wbMBCSEncoding(s);

  if wbFindCmdLineParam('cp', s) or wbFindCmdLineParam('cp-trans', s) then
    wbEncodingTrans :=  wbMBCSEncoding(s);

  // definitions
  case wbGameMode of
    gmFNV: case wbToolSource of
      tsSaves:   DefineFNVSaves;
      tsPlugins: DefineFNV;
    end;
    gmFO3: case wbToolSource of
      tsSaves:   DefineFO3Saves;
      tsPlugins: DefineFO3;
    end;
    gmFO4, gmFO4VR: case wbToolSource of
      tsSaves:   DefineFO4Saves;
      tsPlugins: DefineFO4;
    end;
    gmFO76: case wbToolSource of
      tsPlugins: DefineFO76;
    end;
    gmTES3: case wbToolSource of
      tsPlugins: DefineTES3;
    end;
    gmTES4: case wbToolSource of
      tsSaves:   DefineTES4Saves;
      tsPlugins: DefineTES4;
    end;
    gmTES5, gmTES5VR, gmEnderal, gmSSE, gmEnderalSE: case wbToolSource of
      tsSaves:   DefineTES5Saves;
      tsPlugins: DefineTES5;
    end;
    gmSF1: case wbToolSource of
      tsPlugins: DefineSF1;
    end;
  end;

  if FindCmdLineSwitch('reportinjected') then
    wbReportInjected := True;
  if FindCmdLineSwitch('noreportinjected') then
    wbReportInjected := False;

  if FindCmdLineSwitch('speed') then
    wbSpeedOverMemory := True;
  if FindCmdLineSwitch('memory') then
    wbSpeedOverMemory := False;

  if FindCmdLineSwitch('report') then
    wbReportMode := (DebugHook <> 0);
  if FindCmdLineSwitch('MoreInfoForIndex') then
    wbMoreInfoForIndex := true;

  if not (wbIsStarfield and wbStarfieldIsABugInfestedHellhole) then
    if wbIKnowWhatImDoing and FindCmdLineSwitch('IKnowIllBreakMyGameWithThis') then
      wbAllowEditGameMaster := True;

  if FindCmdLineSwitch('TrackAllEditorID') then
    wbTrackAllEditorID := True;


  if FindCmdLineSwitch('IgnoreESL') or FindCmdLineSwitch('IgnoreLight') or FindCmdLineSwitch('IgnoreSmall') then
    wbIgnoreLight := True
  else
    if FindCmdLineSwitch('PseudoESL') or FindCmdLineSwitch('PseudoLight') or FindCmdLineSwitch('PseudoSmall') then
      wbPseudoLight := True;

  if FindCmdLineSwitch('IgnoreMedium') then
    wbIgnoreMedium := True
  else
    if FindCmdLineSwitch('PseudoMedium') then
      wbPseudoMedium := True;

  if FindCmdLineSwitch('IgnoreOverlay') then
    wbIgnoreOverlay := True
  else
    if FindCmdLineSwitch('PseudoOverlay') then
      wbPseudoOverlay := True;
	  
  if wbComplexFileFileID then begin
    wbIgnoreLight := False;
	wbPseudoLight := False;
	wbIgnoreMedium := False;
	wbPseudoMedium := False;
	wbIgnoreOverlay := False;
    wbPseudoOverlay := False;
  end;

  if FindCmdLineSwitch('SimpleFormIDs') then
    wbPrettyFormID := False;

  if wbFindCmdLineParam('quickedit', xePluginToUse) then begin
    if not (wbToolMode = tmEdit) then
      ShowMessage(wbToolName+' is incompatible with quickedit request!')
    else
      xeQuickEdit := True;
  end;

  if wbToolMode in wbPluginModes then // look for the file name
    if not xeFindNextValidCmdLineModule(xeParamIndex, xePluginToUse, wbDataPath) then begin
      ShowMessage(wbToolName+' mode requires a valid plugin name!');
      Exit(False);
    end;

  // specific Tool Mode settings overrides
  case wbToolMode of
    tmLODgen: begin
      wbIKnowWhatImDoing       := True;
      wbAllowInternalEdit      := False;
      wbShowInternalEdit       := False;
      wbLoadBSAs               := True;
      wbBuildRefs              := False;
    end;
    tmScript: begin
      wbIKnowWhatImDoing       := True;
      wbLoadBSAs               := True;
      wbBuildRefs              := True;
    end;
    tmOnamUpdate, tmMasterUpdate, tmESMify: begin
      wbIKnowWhatImDoing       := True;
      wbAllowInternalEdit      := False;
      wbShowInternalEdit       := False;
      wbLoadBSAs               := False;
      wbBuildRefs              := False;
      wbMasterUpdateFilterONAM := wbToolMode in [tmESMify];
      if wbToolMode = tmOnamUpdate then begin
        wbAlwaysSaveOnam       := True;
        wbAlwaysSaveOnamForce  := True;
      end;
    end;
    tmMasterRestore, tmESPify, tmCheckForDR, tmCheckForITM, tmCheckForErrors: begin
      wbIKnowWhatImDoing       := True;
      wbAllowInternalEdit      := False;
      wbShowInternalEdit       := False;
      wbLoadBSAs               := False;
      wbBuildRefs              := False;
    end;
    tmTranslate: begin
      if wbGameMode >= gmTES5 then
        wbLoadBSAs             := True; //needed for localization
      wbTranslationMode        := True;
      wbHideUnused             := True;
      wbHideIgnored            := True;
      wbHideNeverShow          := True;
    end;
  end;

  if FindCmdLineSwitch('alwayssaveonam') then
    wbAlwaysSaveOnam := True;

  if FindCmdLineSwitch('filteronam') then
    wbMasterUpdateFilterONAM := True
  else if FindCmdLineSwitch('noFilteronam') then
    wbMasterUpdateFilterONAM := False;

  if FindCmdLineSwitch('FixPersistence') then
    wbMasterUpdateFixPersistence := True
  else if FindCmdLineSwitch('NoFixPersistence') then
    wbMasterUpdateFixPersistence := False;

  if xeVeryQuickShowConflicts then
    wbSubMode := 'Very Quick Show Conflicts'
  else if xeQuickShowConflicts then
    wbSubMode := 'Quick Show Conflicts'
  else if xeQuickCleanAutoSave then
    wbSubMode := 'Quick Auto Clean'
  else if xeQuickClean then
    wbSubMode := 'Quick Clean'
  else if xeAutoGameLink then
    wbSubMode := 'Auto Game Link';

  if not wbFindCmdLineParam('scripthost', s) then
    s := xeDefaultScriptHost;
  TxeScriptHost.Init(s);

  wbApplicationTitle := wbAppName + wbToolName + ' ' + VersionString;
  {$IFDEF LiteVersion}
  wbApplicationTitle := wbApplicationTitle + ' Lite';
  {$ENDIF}
  {$IFDEF WIN64}
  wbApplicationTitle := wbApplicationTitle + ' x64';
  {$ENDIF WIN64}
  if wbSubMode <> '' then
    wbApplicationTitle := wbApplicationTitle + ' (' + wbSubMode + ')';

  if xeAutoLoad then
    wbApplicationTitle := wbApplicationTitle + ' [Auto Load]';

  if xeAutoExit then
    wbApplicationTitle := wbApplicationTitle + ' [Auto Exit]';

  if FindCmdLineSwitch('nobuildrefs') then
    wbBuildRefs := False;

  if FindCmdLineSwitch('fixuppgrd') then
    wbFixupPGRD := True;

  wbShouldLoadMOHookFile := wbFindCmdLineParam('moprofile', wbMOProfile);

  if FindCmdLineSwitch('moreunknown') then
    wbMoreInfoForUnknown := True;

  try
    if (wbToolMode = tmEdit) and not wbIsAssociatedWithExtension('.' + wbAppName + 'pas') then
      wbAssociateWithExtension('.' + wbAppName + 'pas', wbAppName + 'Script', wbAppName + wbToolName + ' script');
  except end;

  case wbGameMode of
    gmTES3, gmTES4,  gmTES5, gmEnderal, gmSSE, gmTES5VR, gmEnderalSE:
      xeIconResource := 'xTESICON';
    gmFO3, gmFNV, gmFO4, gmFO4VR, gmFO76:
      xeIconResource := 'xFOICON';
    gmSF1:
      xeIconResource := 'xSFICON';
  end;
end;

function xeDoInit: Boolean;
begin
  try
    Result := _DoInit;
  except
    on E: Exception do begin
      Result := False;
      if not (E is EAbort) then
        ShowMessage('Initialization failed: [' + E.ClassName + '] ' + E.Message);
    end;
  end;
end;

procedure xeSwitchToCoSave;
begin
  case wbGameMode of
    gmFNV:  SwitchToFNVCoSave;
    gmFO3:  SwitchToFO3CoSave;
    gmTES4: SwitchToTES4CoSave;
    gmTES5, gmTES5VR, gmEnderal, gmSSE, gmEnderalSE:  SwitchToTES5CoSave;
  end;
end;

procedure xeInitStyles;
begin
  var Path := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Themes';
  if TDirectory.Exists(Path) then
    for var s in TDirectory.GetFiles(Path, '*.vsf' ) do try
      TStyleManager.LoadFromFile(s);
    except
      on E: Exception do
        ShowMessage(Format('Error loading theme file "%s": %s', [s, E.Message]));
    end;
end;

initialization
end.
