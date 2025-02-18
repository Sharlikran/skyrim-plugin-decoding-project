{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License,
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit xejviScriptHost;

{$I xeDefines.inc}

interface

implementation

uses
  Classes,
  SysUtils,
  StrUtils,
  System.Generics.Collections,
  Variants,
  Forms,
  System.RegularExpressionsCore,
  wbInterface,
  xeInit,
  xeScriptHost,
  VirtualTrees,
  xeMainForm,
  xeFileSelectForm,
  wbLOD,
  wbHelpers,
  wbDataFormat,
  JvInterpreter;

type
  TxejviScript = class(TInterfacedObject, IxeScript)
  protected {private}
    FScriptName : string;
    FScript     : string;
    FProgram    : TJvInterpreterProgram;

    procedure JvInterpreterProgramGetValue(Sender: TObject; Identifier: string; var Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure JvInterpreterProgramGetUnitSource(UnitName: string; var Source: string; var Done: Boolean);
    procedure JvInterpreterProgramStatement(Sender: TObject);
    procedure JvInterpreterProgramSetValue(Sender: TObject; Identifier: string; const Value: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
  protected
    constructor Create(const aScriptName: string; aScript: string);

    { IxeScript }
    function CallFunction(const aName: string; const aParams: array of Variant): Variant;
    function FunctionExists(const aName: string): Boolean;
    function GetLastErrorLocation: string;
  public
    destructor Destroy; override;
  end;

  TxejviScriptHost = class(TxeScriptHost)
  protected
    class function GetName: string; override;
    function CreateScriptInternal(const aScriptName, aScript: string): IxeScript; override;
  public
    constructor Create; override;
  end;

procedure TxejviScript.JvInterpreterProgramGetValue(Sender: TObject;
  Identifier: string; var Value: Variant; Args: TJvInterpreterArgs;
  var Done: Boolean);
var
  Element             : IwbElement;
  MainRecord          : IwbMainRecord;
  Container           : IwbContainerElementRef;
  _File               : IwbFile;
  NodeDatas           : TDynViewNodeDatas;
  ConflictThis        : TConflictThis;
  ConflictAll         : TConflictAll;
  List                : TList;
  i                   : Integer;
begin
  with frmMain do
  if SameText(Identifier, 'wbGameMode') and (Args.Count = 0) then begin
    Value := wbGameMode;
    Done := True;
  end
  else if SameText(Identifier, 'wbGameName') and (Args.Count = 0) then begin
    Value := wbGameName;
    Done := True;
  end
  else if SameText(Identifier, 'wbGameMasterEsm') and (Args.Count = 0) then begin
    Value := wbGameMasterEsm;
    Done := True;
  end
  else if SameText(Identifier, 'wbGameName2') and (Args.Count = 0) then begin
    Value := wbGameName2;
    Done := True;
  end
  else if SameText(Identifier, 'wbAppName') and (Args.Count = 0) then begin
    Value := wbAppName;
    Done := True;
  end
  else if SameText(Identifier, 'wbLoadBSAs') and (Args.Count = 0) then begin
    Value := wbLoadBSAs;
    Done := True;
  end
  else if SameText(Identifier, 'wbSimpleRecords') and (Args.Count = 0) then begin
    Value := wbSimpleRecords;
    Done := True;
  end
  else if SameText(Identifier, 'wbDecodeTextureHashes') and (Args.Count = 0) then begin
    Value := wbDecodeTextureHashes;
    Done := True;
  end
  else if SameText(Identifier, 'wbTrackAllEditorID') and (Args.Count = 0) then begin
    Value := wbTrackAllEditorID;
    Done := True;
  end
  else if SameText(Identifier, 'wbRecordDefMap') and (Args.Count = 0) then begin
    Value := O2V(_wbRecordDefMap);
    Done := True;
  end
  else if (SameText(Identifier,   'ProgramPath') and (Args.Count = 0)) or
     (SameText(Identifier, 'wbProgramPath') and (Args.Count = 0)) then begin
    Value := wbProgramPath;
    Done := True;
  end
  else if (SameText(Identifier,   'ScriptsPath') and (Args.Count = 0)) or
     (SameText(Identifier, 'wbScriptsPath') and (Args.Count = 0)) then begin
    Value := wbScriptsPath;
    Done := True;
  end
  else if (SameText(Identifier, 'wbDataPath') and (Args.Count = 0)) or
     (SameText(Identifier, 'DataPath') and (Args.Count = 0)) then begin
    Value := wbDataPath;
    Done := True;
  end
  else if (SameText(Identifier, 'wbTempPath') and (Args.Count = 0)) or
     (SameText(Identifier, 'TempPath') and (Args.Count = 0)) then begin
    Value := wbTempPath;
    Done := True;
  end
  else if SameText(Identifier, 'wbOutputPath') and (Args.Count = 0) then begin
    Value := wbOutputPath;
    Done := True;
  end
  else if (SameText(Identifier, 'wbSettingsFileName') and (Args.Count = 0)) then begin
    Value := xeSettingsFileName;
    Done := True;
  end
  else if (SameText(Identifier, 'wbSettings') and (Args.Count = 0)) then begin
    Value := O2V(Settings);
    Done := True;
  end
  else if SameText(Identifier, 'FilterApplied') and (Args.Count = 0) then begin
    Value := FilterApplied;
    Done := True;
  end
  else if SameText(Identifier, 'frmMain') and (Args.Count = 0) then begin
    Value := O2V(frmMain);
    Done := True;
  end
  else if SameText(Identifier, 'AddMessage') then begin
    if (Args.Count = 1) and VarIsStr(Args.Values[0]) then begin
      wbProgress(Args.Values[0]);
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ClearMessages') and (Args.Count = 0) then begin
    mmoMessages.Clear;
    Done := True;
    DoProcessMessages;
  end
  else if SameText(Identifier, 'FileCount') and (Args.Count = 0) then begin
    Value := Length(Files);
    Done := True;
  end
  else if SameText(Identifier, 'FileByIndex') then begin
    if (Args.Count = 1) and VarIsNumeric(Args.Values[0]) and (Args.Values[0] < Length(Files)) then begin
      Value := Files[Integer(Args.Values[0])];
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0); // or  ieNotEnoughParams, ieIncompatibleTypes or others.
  end
  else if SameText(Identifier, 'FileByLoadOrderFileID') then begin
    if (Args.Count = 1) and VarIsNumeric(Args.Values[0]) and (Args.Values[0] < Length(Files)) then begin
      var aLoadOrderFileID := TwbFileID.CreateFull(Integer(Args.Values[0]));
      for i := Low(Files) to High(Files) do
        if Files[i].LoadOrderFileID = aLoadOrderFileID then begin
          Value := Files[i];
          Break;
        end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'FileByLoadOrder') then begin
    if (Args.Count = 1) and VarIsNumeric(Args.Values[0]) and (Args.Values[0] < Length(Files)) then begin
      for i := Low(Files) to High(Files) do
        if Files[i].LoadOrder = Integer(Args.Values[0]) then begin
          Value := Files[i];
          Break;
        end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'FileByName') then begin
    if (Args.Count = 1) and VarIsStr(Args.Values[0]) then begin
      Value := Null;
      for i := Low(Files) to High(Files) do
        if SameText(Args.Values[0], Files[i].FileName) then begin
          Value := Files[i];
          Break;
        end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0); // or  ieNotEnoughParams, ieIncompatibleTypes or others.
  end
  else if SameText(Identifier, 'RecordByHexFormID') then begin
    if (Args.Count = 1) and VarIsStr(Args.Values[0]) then begin
      Value := Null;
      var aFormID: TwbFormID := TwbFormID.FromStr(string(Args.Values[0]));
      for i := Low(Files) to High(Files) do
        if Files[i].LoadOrderFileID = aFormID.FileID then begin
          Value := Files[i].RecordByFormID[aFormID, True, True];
          Break;
        end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0); // or  ieNotEnoughParams, ieIncompatibleTypes or others.
  end
  else if SameText(Identifier, 'IsPositionChanged') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      Value := IsPositionChanged(MainRecord);
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'AddNewFile') and (Args.Count = 0) then begin
    AddNewFile(_File, False, False);
    Value := _File;
    Done := True;
  end
  else if SameText(Identifier, 'AddNewFile') and (Args.Count = 1) then begin
    AddNewFile(_File, Args.Values[0], False);
    Value := _File;
    Done := True;
  end
  else if SameText(Identifier, 'AddNewFile') and (Args.Count = 2) then begin
    AddNewFile(_File, Args.Values[0], Args.Values[1]);
    Value := _File;
    Done := True;
  end
  else if SameText(Identifier, 'AddNewFileName') and (Args.Count = 1) then begin
    Value := AddNewFileName(Args.Values[0], False, False);
    Done := True;
  end
  else if SameText(Identifier, 'AddNewFileName') and (Args.Count = 2) then begin
    Value := AddNewFileName(Args.Values[0], Args.Values[1], False);
    Done := True;
  end
  else if SameText(Identifier, 'AddNewFileName') and (Args.Count = 3) then begin
    Value := AddNewFileName(Args.Values[0], Args.Values[1], Args.Values[2]);
    Done := True;
  end
  else if SameText(Identifier, 'AddRequiredElementMasters') and (Args.Count in [3, 4]) then begin
    Value := false;
    if Supports(IInterface(Args.Values[0]), IwbElement, Element) then
      if Supports(IInterface(Args.Values[1]), IwbFile, _File) then begin
        var Silent := False;
        if Args.Count >= 4 then
          Silent := Args.Values[3];
        Value := AddRequiredMasters(Element, _File, Args.Values[2], Silent);
      end;
    Done := True;
  end
  else if SameText(Identifier, 'RemoveNode') and (Args.Count = 1) then begin
    Value := False;
    if Supports(IInterface(Args.Values[0]), IwbElement, Element) then begin
      var Node: PVirtualNode := FindNodeForElement(Element);
      if Assigned(Node) then begin
        var NodeData: PNavNodeData := vstNav.GetNodeData(Node);
        if Supports(Element, IwbMainRecord, MainRecord) then begin
          CheckHistoryRemove(BackHistory, MainRecord);
          CheckHistoryRemove(ForwardHistory, MainRecord);
        end;
        DoSetActiveRecord(nil);
        if Element.Equals(NodeData.Container) then
          NodeData.Container := nil;
        if Assigned(NodeData.Container) then
          NodeData.Container.Remove;
        Element.Remove;
        NodeData.Element := nil;
        NodeData.Container := nil;
        Element := nil;
        vstNav.DeleteNode(Node);
        Value := True;
      end;
    end;
    Done := True;
  end
  else if SameText(Identifier, 'ConflictThisForMainRecord') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      ConflictLevelForMainRecord(MainRecord, ConflictAll, ConflictThis);
      Value := ConflictThis;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ConflictAllForMainRecord') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      ConflictLevelForMainRecord(MainRecord, ConflictAll, ConflictThis);
      Value := ConflictAll;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ConflictThisForNode') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbElement, Element) then begin
      var Node: PVirtualNode := FindNodeForElement(Element);
      if Assigned(Node) then begin
        var NodeData: PNavNodeData := vstNav.GetNodeData(Node);
        Value := NodeData.ConflictThis;
      end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ConflictAllForNode') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbElement, Element) then begin
      var Node: PVirtualNode := FindNodeForElement(Element);
      if Assigned(Node) then begin
        var NodeData: PNavNodeData := vstNav.GetNodeData(Node);
        Value := NodeData.ConflictAll;
      end;
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ConflictAllForElements') and ((Args.Count = 3) or (Args.Count = 4)) then begin
    if Args.Count = 3 then begin
      Value := caNone;
      List := TList(V2O(Args.Values[0]));
      if Assigned(List) then
      for i := 0 to Pred(List.Count) do begin
        if not Supports(IInterface(Pointer(List[i])), IwbElement, Element) then
          Continue;
        SetLength(NodeDatas, Succ(Length(NodeDatas)));
        NodeDatas[Pred(Length(NodeDatas))].Element := Element;
        if Supports(Element, IwbContainerElementRef, Container) and (Container.ElementCount > 0) then
          NodeDatas[Pred(Length(NodeDatas))].Container := Container;
      end;
      i := 0;
    end
    else if Args.Count = 4 then begin
      for i := 0 to 1 do begin
        if not Supports(IInterface(Args.Values[i]), IwbElement, Element) then
          Continue;
        SetLength(NodeDatas, Succ(Length(NodeDatas)));
        NodeDatas[Pred(Length(NodeDatas))].Element := Element;
        if Supports(Element, IwbContainerElementRef, Container) and (Container.ElementCount > 0) then
          NodeDatas[Pred(Length(NodeDatas))].Container := Container;
      end;
      i := 1;
    end else
      i := 0;
    Value := caNone;
    if Length(NodeDatas) > 0 then
      if Assigned(NodeDatas[0].Container) then
        Value := ConflictLevelForChildNodeDatas(NodeDatas, Args.Values[i+1], Args.Values[i+2])
      else
        Value := ConflictLevelForNodeDatas(@NodeDatas[0], Length(NodeDatas), Args.Values[i+1], Args.Values[i+2]);
    Done := True;
  end
  else if SameText(Identifier, 'JumpTo') and (Args.Count = 2) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      vstNav.EndUpdate;
      if not vstNav.Enabled then vstNav.Enabled := True;
      JumpTo(MainRecord, Boolean(Args.Values[1]));
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'ApplyFilter') and (Args.Count = 0) then begin
    FilterPreset := True; // skip filter dialog
    try
      mniNavFilterApplyClick(Sender);
    finally
      FilterPreset := False;
      Done := True;
    end;
  end
  else if SameText(Identifier, 'RemoveFilter') and (Args.Count = 0) then begin
    DoSetActiveRecord(nil);
    mniNavFilterRemoveClick(nil);
    Done := True;
  end
  else if SameText(Identifier, 'frmFileSelect') and (Args.Count = 0) then begin
    Value := O2V(TfrmFileSelect.Create(nil));
    Done := True;
  end
  else if SameText(Identifier, 'ExecuteCaptureConsoleOutput') and (Args.Count = 1) then begin
    Value := ExecuteCaptureConsoleOutput(Args.Values[0]);
    Done := True;
  end
  else if SameText(Identifier, 'GenerateLODTES4') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      if wbGameMode = gmTES4 then
        wbGenerateLODTES4(MainRecord, Settings);
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'GenerateLODTES5Trees') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      if wbIsSkyrim then
        wbGenerateLODTES5(MainRecord, [lodTrees], Files, Settings);
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'GenerateLODTES5Objects') and (Args.Count = 1) then begin
    if Supports(IInterface(Args.Values[0]), IwbMainRecord, MainRecord) then begin
      if wbIsSkyrim then
        wbGenerateLODTES5(MainRecord, [lodObjects], Files, Settings);
      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0);
  end
  else if SameText(Identifier, 'wbGetUVRangeTexturesList') and (Args.Count = 3) then begin
    wbGetUVRangeTexturesList(
      TStrings(V2O(Args.Values[0])),  // TStrings list of meshes
      TStrings(V2O(Args.Values[1])),  // TStrings list of textures, output
      Single(Args.Values[2])          // UVRange
    );
    Done := True;
  end
  else if SameText(Identifier, 'wbBuildAtlasFromTexturesList') and (Args.Count = 7) then begin
    wbBuildAtlasFromTexturesList(
      TStrings(V2O(Args.Values[0])),  // TStrings list of textures
      Args.Values[1], // max texture size
      Args.Values[2], // max tile size
      Args.Values[3], // atlas width
      Args.Values[4], // atlas height
      Args.Values[5], // atlas file name
      Args.Values[6], // atlas map file name
      Settings
    );
    Done := True;
  end
  else if SameText(Identifier, 'wbBuildAtlasFromAtlasMap') and (Args.Count = 5) then begin
    wbBuildAtlasFromAtlasMap(
      TStrings(V2O(Args.Values[0])),  // TStrings atlas map
      Args.Values[1],                // brightness
      Args.Values[2],                // GammaR
      Args.Values[3],                // GammaG
      Args.Values[4],                // GammaB
      Settings
    );
    Done := True;
  end
  else if SameText(Identifier, 'dfFloatDecimalDigits') and (Args.Count = 0) then begin
    Value := dfFloatDecimalDigits;
    Done := True;
  end
  else if SameText(Identifier, 'wbSelectedFilesToFileNames') then begin
    if (Args.Count = 1) then
    begin
      var Nodes: TNodeArray := vstNav.GetSortedSelection(True);

      for i := Low(Nodes) to High(Nodes) do begin
        var NodeData: PNavNodeData := vstNav.GetNodeData(Nodes[i]);
        if not Assigned(NodeData) then
          Continue;
        Element := NodeData.Element;
        if Supports(Element, IwbFile, _File) then
          if TStrings(V2O(Args.Values[0])).IndexOf(_File.FileName) = -1 then
            TStrings(V2O(Args.Values[0])).Add(_File.FileName)
        else if Supports(Element, IwbMainRecord, MainRecord) then
          if TStrings(V2O(Args.Values[0])).IndexOf(MainRecord._File.FileName) = -1 then
            TStrings(V2O(Args.Values[0])).Add(MainRecord._File.FileName);
      end;

      Done := True;
    end else
      JvInterpreterError(ieDirectInvalidArgument, 0); // or  ieNotEnoughParams, ieIncompatibleTypes or others.
  end;
end;

procedure TxejviScript.JvInterpreterProgramSetValue(Sender: TObject;
  Identifier: string; const Value: Variant; Args: TJvInterpreterArgs;
  var Done: Boolean);
var
  i, v: Integer;
begin
  with frmMain do
  if SameText(Identifier, 'ScriptProcessElements') then begin
    ScriptProcessElements := [];
    v := V2S(Value);
    for i := Integer(Low(TwbElementType)) to Integer(High(TwbElementType)) do
      if (v and (1 shl i)) > 0 then
        Include(ScriptProcessElements, TwbElementType(i));
    if ScriptProcessElements = [] then
      ScriptProcessElements := [etMainRecord];
    Done := True;
  end else
  if SameText(Identifier, 'wbOutputPath') then begin
    wbOutputPath := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterScripted') then begin
    FilterScripted := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterConflictAll') then begin
    FilterConflictAll := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterConflictAllSet') then begin
    FilterConflictAllSet := [];
    v := V2S(Value);
    for i := Integer(Low(TConflictAll)) to Integer(High(TConflictAll)) do
      if (v and (1 shl i)) > 0 then
        Include(FilterConflictAllSet, TConflictAll(i));
    Done := True;
  end else
  if SameText(Identifier, 'FilterConflictThis') then begin
    FilterConflictThis := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterConflictThisSet') then begin
    FilterConflictThisSet := [];
    v := V2S(Value);
    for i := Integer(Low(TConflictThis)) to Integer(High(TConflictThis)) do
      if (v and (1 shl i)) > 0 then
        Include(FilterConflictThisSet, TConflictThis(i));
    Done := True;
  end else
  if SameText(Identifier, 'FilterByInjectStatus') then begin
    FilterByInjectStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterInjectStatus') then begin
    FilterInjectStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByNotReachableStatus') then begin
    FilterByNotReachableStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterNotReachableStatus') then begin
    FilterNotReachableStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByReferencesInjectedStatus') then begin
    FilterByReferencesInjectedStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterReferencesInjectedStatus') then begin
    FilterReferencesInjectedStatus := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByEditorID') then begin
    FilterByEditorID := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterEditorID') then begin
    FilterEditorID := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByName') then begin
    FilterByName := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterName') then begin
    FilterName := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByElementValue') then begin
    FilterByElementValue := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterElementValue') then begin
    FilterElementValue := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByBaseEditorID') then begin
    FilterByBaseEditorID := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterBaseEditorID') then begin
    FilterBaseEditorID := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByBaseName') then begin
    FilterByBaseName := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterBaseName') then begin
    FilterBaseName := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterScaledActors') then begin
    FilterScaledActors := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterBySignature') then begin
    FilterBySignature := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterSignatures') then begin
    FilterSignatures := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByBaseSignature') then begin
    FilterByBaseSignature := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterBaseSignatures') then begin
    FilterBaseSignatures := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByPersistent') then begin
    FilterByPersistent := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterPersistent') then begin
    FilterPersistent := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterUnnecessaryPersistent') then begin
    FilterUnnecessaryPersistent := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterMasterIsTemporary') then begin
    FilterMasterIsTemporary := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterIsMaster') then begin
    FilterIsMaster := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterPersistentPosChanged') then begin
    FilterPersistentPosChanged := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterDeleted') then begin
    FilterDeleted := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByVWD') then begin
    FilterByVWD := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterVWD') then begin
    FilterVWD := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByHasVWDMesh') then begin
    FilterByHasVWDMesh := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterHasVWDMesh') then begin
    FilterHasVWDMesh := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterByHasPrecombinedMesh') then begin
    FilterByHasPrecombinedMesh := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FilterHasPrecombinedMesh') then begin
    FilterHasPrecombinedMesh := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FlattenBlocks') then begin
    FlattenBlocks := Value;
    Done := True;
  end else
  if SameText(Identifier, 'FlattenCellChilds') then begin
    FlattenCellChilds := Value;
    Done := True;
  end else
  if SameText(Identifier, 'AssignPersWrldChild') then begin
    AssignPersWrldChild := Value;
    Done := True;
  end else
  if SameText(Identifier, 'InheritConflictByParent') then begin
    InheritConflictByParent := Value;
    Done := True;
  end
  else if SameText(Identifier, 'dfFloatDecimalDigits') then begin
    Assert(dfFloatDecimalDigits > 0, 'dfFloatDecimalDigits must be greater than 0');
    dfFloatDecimalDigits := Value;
    Done := True;
  end;
end;


procedure TxejviScript.JvInterpreterProgramStatement(Sender: TObject);
begin
  wbTick;
end;

type
  PUnitInfo = ^TUnitInfo;
  TUnitInfo = record
    UnitName: string;
    Found: PBoolean;
  end;

procedure HasUnitProc(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
var
  s: string;
begin
  case NameType of
    ntContainsUnit:
      with PUnitInfo(Param)^ do begin
        s := Name;
        s := StringReplace(s, 'system.', '', [rfReplaceAll, rfIgnoreCase]);
        s := StringReplace(s, 'vcl.',    '', [rfReplaceAll, rfIgnoreCase]);
        s := StringReplace(s, 'winapi.', '', [rfReplaceAll, rfIgnoreCase]);
        s := StringReplace(s, 'data.',   '', [rfReplaceAll, rfIgnoreCase]);
        s := StringReplace(s, 'web.',    '', [rfReplaceAll, rfIgnoreCase]);
        if SameText(s, UnitName) then
          Found^ := True;
      end;
  end;
end;

function IsUnitCompiledIn(Module: HMODULE; const UnitName: string): Boolean;
var
  Info: TUnitInfo;
  Flags: Integer;
begin
  Result := False;
  Info.UnitName := UnitName;
  Info.Found := @Result;
  GetPackageInfo(Module, @Info, Flags, HasUnitProc);
end;

function TxejviScript.CallFunction(const aName: string; const aParams: array of Variant): Variant;
begin
  FProgram.CallFunction(aName, nil, aParams);
  Result := FProgram.VResult;
end;

constructor TxejviScript.Create(const aScriptName: string; aScript: string);
begin
  inherited Create;
  // Try to remove namespaces from unit names in uses clause if script is written in newer Delphi version
  // jvInterpreter doesn't support them (causes syntax error)
  with TPerlRegEx.Create do try
    Subject := aScript;
    RegEx := '^\s*uses\s+(.+?);';
    Options := [preCaseLess, preSingleLine, preMultiLine];
    while MatchAgain do begin
      var i := MatchedOffset;
      var s := MatchedText;
      s := StringReplace(s, 'system.', '', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s, 'vcl.',    '', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s, 'winapi.', '', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s, 'data.',   '', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s, 'web.',    '', [rfReplaceAll, rfIgnoreCase]);
      if s <> MatchedText then begin
        aScript := Copy(aScript, 1, i-1) + s + Copy(aScript, i + Length(MatchedText), Length(aScript));
        Subject := aScript;
      end;
      Start := i + Length(s);
    end;
  finally
    Free;
  end;

  FScriptName := aScriptName;
  FScript := aScript;

  FProgram := TJvInterpreterProgram.Create(nil);
  FProgram.OnGetValue := JvInterpreterProgramGetValue;
  FProgram.OnSetValue := JvInterpreterProgramSetValue;
  FProgram.OnGetUnitSource := JvInterpreterProgramGetUnitSource;
  FProgram.OnStatement := JvInterpreterProgramStatement;
  FProgram.Pas.Text := FScript;
  FProgram.Compile;
end;

destructor TxejviScript.Destroy;
begin
  inherited;
  FreeAndNil(FProgram);
end;

function TxejviScript.FunctionExists(const aName: string): Boolean;
begin
  Result := FProgram.FunctionExists('', aName);
end;

function TxejviScript.GetLastErrorLocation: string;
begin
  var LastError := FProgram.LastError;
  if Assigned(LastError) then
    Result := 'unit ' + LastError.ErrUnitName + ' line ' + IntToStr(LastError.ErrLine)
  else
    Result := '';
end;

procedure TxejviScript.JvInterpreterProgramGetUnitSource(UnitName: string; var Source: string; var Done: Boolean);
var
  UnitFile: string;
begin
  // return empty unit source code if the standard one is used
  if SameText(UnitName, 'xEditAPI') or SameText(UnitName, 'UITypes') or IsUnitCompiledIn(HInstance, UnitName) then begin
    Source := 'unit ' + UnitName + '; end.';
    Done := True;
    Exit;
  end;

  UnitFile := wbScriptsPath + UnitName + '.pas';
  with TStringList.Create do try
    LoadFromFile(UnitFile);
    Source := Text;
    Done := True;
  finally
    Free;
  end;
end;


{ TxejviScriptHost }

constructor TxejviScriptHost.Create;
begin
  inherited;
  wbVarPointer := varPointer;
end;

function TxejviScriptHost.CreateScriptInternal(const aScriptName, aScript: string): IxeScript;
begin
  Result := TxejviScript.Create(aScriptName, aScript);
end;

class function TxejviScriptHost.GetName: string;
begin
  Result := 'JvI';
end;

initialization
  TxejviScriptHost.Register;
end.
