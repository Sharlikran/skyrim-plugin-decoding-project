{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License,
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbDefinitionsFO76;

{$I wbDefines.inc}

interface

uses
  wbInterface;

var
  wbBipedObjectFlags: IwbFlagsDef;
  wbEquipType: IwbFlagsDef;
  wbFurnitureEntryTypeFlags: IwbFlagsDef;
  wbPKDTFlags: IwbFlagsDef;
  wbPKDTInterruptFlags: IwbFlagsDef;
  wbSMNodeFlags: IwbFlagsDef;
  wbXALGFlags: IwbFlagsDef;
  wbPHSTFlags: IwbFlagsDef;
  wbXFLGFlags: IwbFlagsDef;

  wbActorPropertyEnum: IwbEnumDef;
  wbAdvanceActionEnum: IwbEnumDef;
  wbStaggerEnum: IwbEnumDef;
  wbArmorPropertyEnum: IwbEnumDef;
  wbBipedObjectEnum: IwbEnumDef;
  wbBodyPartIndexEnum: IwbEnumDef;
  wbCastEnum: IwbEnumDef;
  wbCastingSourceEnum: IwbEnumDef;
  wbCrimeTypeEnum: IwbEnumDef;
  wbCriticalStageEnum: IwbEnumDef;
  wbEmotionTypeEnum: IwbEnumDef;
  wbEntryPointsEnum: IwbEnumDef;
  wbEventFunctionEnum: IwbEnumDef;
  wbEventMemberEnum: IwbEnumDef;
  wbConditionFormTypeEnum: IwbEnumDef;
  wbFormTypeEnum: IwbEnumDef;
  wbFurnitureAnimTypeEnum: IwbEnumDef;
  wbLocationEnum: IwbEnumDef;
  wbMiscStatEnum: IwbEnumDef;
  wbObjectModProperties: IwbArrayDef;
  wbObjectTypeEnum: IwbEnumDef;
  wbPropTypeEnum: IwbEnumDef;
  wbSkillEnum: IwbEnumDef;
  wbSoundLevelEnum: IwbEnumDef;
  wbTargetEnum: IwbEnumDef;
  wbVatsValueFunctionEnum: IwbEnumDef;
  wbWardStateEnum: IwbEnumDef;
  wbWeaponAnimTypeEnum: IwbEnumDef;
  wbWeaponPropertyEnum: IwbEnumDef;
  wbZTestFuncEnum: IwbEnumDef;
  wbDialogueSubtypeEnum: IwbEnumDef;
  wbStatNameEnum: IwbEnumDef;
  wbKeywordTypeEnum: IwbEnumDef;
  wbReverbClassEnum: IwbEnumDef;
  wbHitBehaviourEnum: IwbEnumDef;
  wbSpecialTypeEnum: IwbEnumDef;
  wbLGDIStarSlot: IwbEnumDef;
  wbMapMarkerEnum: IwbEnumDef;
  wbPrefixEnum: IwbEnumDef;
  wbSuffixEnum: IwbEnumDef;
  wbCellFlags: IwbFlagsDef;
  wbLVLFFlags : IwbFlagsDef;
  wbLVLNLVLFFlags : IwbFlagsDef;

procedure DefineFO76;

implementation

uses
  Types,
  Classes,
  SysUtils,
  Math,
  Variants,
  IOUtils,
  wbHelpers,
  wbDefinitionsCommon,
  wbDefinitionsSignatures;

type
  TVarRecs = array of TVarRec;

const
    // signatures of reference records
  sigReferences : TwbSignatures = [
    'NULL', 'PLYR', 'ACHR', 'REFR', 'PGRE', 'PHZD',
    'PMIS', 'PARW', 'PBAR', 'PBEA', 'PCON', 'PFLA'
  ];

  // signatures of referenceable records (placed by references or constructable)
  sigBaseObjects : TwbSignatures = [
    'NULL', 'ACTI', 'ADDN', 'ALCH', 'AMMO', 'ARMO',
    'ARTO', 'ASPC', 'BNDS', 'BOOK', 'CMPO', 'CNCY',
    'COBJ', 'CONT', 'DEBR', 'DOOR', 'EXPL', 'FLST',
    'FLOR', 'FURN', 'HAZD', 'IDLM', 'INGR', 'KEYM',
    'LGDI', 'LIGH', 'LVLI', 'LVLN', 'LVSP', 'MISC',
    'MSTT', 'NOTE', 'NPC_', 'OMOD', 'PACH', 'PKIN',
    'PPAK', 'PROJ', 'SCOL', 'SCRL', 'SECH', 'SOUN',
    'SPEL', 'STAT', 'TACT', 'TERM', 'TREE', 'TXST',
    'UTIL', 'WATR', 'WEAP'
  ];

var
  wbPKDTSpecificFlagsUnused : Boolean;
  wbEDID: IwbSubRecordDef;
  wbDURL: IwbSubRecordDef;
  wbCOED: IwbSubRecordDef;
  wbXLCM: IwbSubRecordDef;
  wbEITM: IwbSubRecordDef;
  wbOPDS: IwbSubRecordDef;
  wbOPDSs: IwbSubRecordArrayDef;
  wbFTAGs: IwbSubRecordArrayDef;
  wbDEFL: IwbSubRecordDef;
  wbDIQO: IwbSubRecordDef;
  wbBEVA: IwbSubRecordDef;
  wbFEVA: IwbSubRecordDef;
  wbNTWK: IwbSubRecordDef;
  wbDEST: IwbRecordMemberDef;
  wbDESTActor: IwbSubRecordStructDef;
  wbDODT: IwbSubRecordDef;
  wbXRGD: IwbSubRecordDef;
  wbXRGB: IwbSubRecordDef;
  wbSPLO: IwbSubRecordDef;
  wbSPLOs: IwbSubRecordArrayDef;
  wbCNTO: IwbRecordMemberDef;
  wbCNTOs: IwbSubRecordArrayDef;
  wbAIDT: IwbSubRecordDef;
  wbFULL: IwbSubRecordDef;
  wbFULLActor: IwbSubRecordDef;
  wbFULLReq: IwbSubRecordDef;
  wbDESC: IwbSubRecordDef;
  wbDESCReq: IwbSubRecordDef;
  wbXSCL: IwbSubRecordDef;
  wbMODC: IwbSubRecordDef;
  wbMODD: IwbSubRecordDef;
  wbMODF: IwbSubRecordDef;
  wbMODS: IwbSubRecordDef;
  wbMO2S: IwbSubRecordDef;
  wbMO3S: IwbSubRecordDef;
  wbMO4S: IwbSubRecordDef;
  wbMO2F: IwbSubRecordDef;
  wbMO3F: IwbSubRecordDef;
  wbMO4F: IwbSubRecordDef;
  wbMO5F: IwbSubRecordDef;
  wbMO2C: IwbSubRecordDef;
  wbMO3C: IwbSubRecordDef;
  wbMO4C: IwbSubRecordDef;
  wbMO5C: IwbSubRecordDef;
  wbComponent: IwbValueDef;
  wbComponents: IwbSubRecordDef;
  wbCTDA: IwbRecordMemberDef;
  wbCTDAs: IwbSubRecordArrayDef;
  wbCNDCs: IwbSubRecordArrayDef;
  wbCTDAsReq: IwbSubRecordArrayDef;
  wbCTDAsCount: IwbSubRecordArrayDef;
  wbXESP: IwbSubRecordDef;
  wbXLWT: IwbSubRecordDef;
  wbICON: IwbSubRecordDef;
  wbMICO: IwbSubRecordDef;
  wbActorValue: IwbUnionDef;
  wbETYP: IwbSubRecordDef;
  wbETYPReq: IwbSubRecordDef;
  wbEFID: IwbSubRecordDef;
  wbEFIT: IwbSubRecordDef;
  wbEffectsReq: IwbSubRecordArrayDef;
  wbFirstPersonFlagsU32: IwbIntegerDef;
  wbBOD2: IwbSubRecordDef;
  wbScriptEntry: IwbStructDef;
  wbScriptFlags: IwbIntegerDef;
  wbScriptPropertyObject: IwbUnionDef;
  wbScriptPropertyStruct: IwbArrayDef;
  wbScriptProperty: IwbValueDef;
  wbScriptProperties: IwbArrayDef;
  wbScriptFragments: IwbStructDef;
  wbScriptFragmentsQuest: IwbValueDef;
  wbScriptFragmentsInfo: IwbStructDef;
  wbScriptFragmentsPack: IwbStructDef;
  wbScriptFragmentsScen: IwbStructDef;
  wbPLDT: IwbSubRecordDef;
  wbPLVD: IwbSubRecordDef;
  wbTargetData: IwbStructDef;
  wbAttackData: IwbSubRecordStructDef;
  wbLLCT: IwbSubRecordDef;
  wbLVLD: IwbRecordMemberDef;
  wbVMAD: IwbSubRecordDef;
  wbVMADFragmentedPERK: IwbSubRecordDef;
  wbVMADFragmentedPACK: IwbSubRecordDef;
  wbVMADFragmentedQUST: IwbSubRecordDef;
  wbVMADFragmentedSCEN: IwbSubRecordDef;
  wbVMADFragmentedINFO: IwbSubRecordDef;
  wbCOCT: IwbSubRecordDef;
  wbCNDC: IwbSubRecordDef;
  wbCITC: IwbSubRecordDef;
  wbCITCReq: IwbSubRecordDef;
  wbMGEFData: IwbSubRecordStructDef;
  wbMGEFType: IwbIntegerDef;
  wbSPIT: IwbSubRecordDef;
  wbMIID: IwbSubRecordDef;
  wbDMDC: IwbSubRecordDef;
  wbDMDS: IwbSubRecordDef;
  wbMO5S: IwbSubRecordDef;
  wbSPCT: IwbSubRecordDef;
  wbXOWN: IwbSubRecordDef;
  wbXRNK: IwbSubRecordDef;
  wbPhonemeTargets: IwbSubRecordDef;
  wbPHWT: IwbSubRecordStructDef;
  wbQUSTAliasFlags: IwbSubRecordDef;
  wbQUSTAliasFlagsActual: IwbFlagsDef;
  wbPDTO: IwbSubRecordDef;
  wbPDTOs: IwbSubRecordArrayDef;
  wbUNAMs: IwbSubRecordArrayDef;
  wbNull: IwbValueDef;
  wbIMADUnknown1: IwbStructDef;
  wbYNAM: IwbSubRecordDef;
  wbZNAM: IwbSubRecordDef;
  wbZNAMArray: IwbSubRecordDef;
  wbSPED: IwbSubRecordDef;
  wbCUSD: IwbSubRecordDef;
  wbINRD: IwbSubRecordDef;
  wbEILV: IwbSubRecordDef;
  wbIBSD: IwbSubRecordDef;
  wbPTRN: IwbSubRecordDef;
  wbSTCP: IwbSubRecordDef;
  wbNTRM: IwbSubRecordDef;
  wbPRPS: IwbSubRecordDef;
  wbObjectProperty: IwbValueDef;
  wbCVPA: IwbSubRecordDef;
  wbESCR: IwbSubRecordDef;
  wbREPR: IwbSubRecordDef;
  wbAVMG: IwbSubRecordDef;
  wbDAMS: IwbSubRecordDef;
  wbFLTR: IwbSubRecordDef;
  wbAPPR: IwbSubRecordDef;
  wbStorefrontData: IwbRecordMemberDef;
  wbObjectTemplate: IwbSubRecordStructDef;
  wbBSMPSequence: IwbSubRecordArrayDef;
  wbArmorAddonBSMPSequence: IwbSubRecordArrayDef;
  wbFTYP: IwbSubRecordDef;
  wbATTX: IwbSubRecordDef;
  wbMNAMFurnitureMarker: IwbSubRecordDef;
  wbSNAMMarkerParams: IwbSubRecordDef;
  wbZNAMMarkerParams: IwbSubRecordDef;
  wbOBTSReq: IwbSubRecordDef;
  //wbTintTemplateGroups: IwbSubrecordArrayDef;
  //wbMorphGroups: IwbSubrecordArrayDef;
  //wbRaceFRMI: IwbSubrecordArrayDef;
  wbRaceRBPC: IwbSubRecordDef;
  wbNVNM: IwbSubRecordDef;
  wbNVNMRecordVal: IwbStructDef;
  wbENLM: IwbSubRecordDef;
  wbENLT: IwbRecordMemberDef;
  wbENLS: IwbSubRecordDef;
  wbAUUV: IwbRecordMemberDef;
  wbSNTP: IwbSubRecordDef;
  wbXALG: IwbRecordMemberDef;
  wbXFLG: IwbRecordMemberDef;
  wbModelXFLG: IwbSubRecordDef;
  wbXFLGLong: IwbRecordMemberDef;
  wbXEZN: IwbRecordMemberDef;
  wbXLCN: IwbRecordMemberDef;
  wbNAM1: IwbSubRecordDef;
  wbLODP: IwbSubRecordDef;
  wbNAM1LODP: IwbSubRecordStructDef;
  wbNAMMarkerParam: IwbStructDef;
  wbPHST: IwbRecordMemberDef;
  wbDOFA: IwbSubRecordDef;
  wbQSTI: IwbSubRecordDef;
  wbLVIV: IwbSubRecordDef;
  wbLVIT: IwbSubRecordDef;
  wbLVMV: IwbSubRecordDef;
  wbLVCV: IwbSubRecordDef;
  wbLVMG: IwbSubRecordDef;
  wbLVMT: IwbSubRecordDef;
  wbLVOV: IwbSubRecordDef;
  wbLVLV: IwbSubRecordDef;
  wbLVOT: IwbSubRecordDef;
  wbLVOG: IwbSubRecordDef;
  wbLVLG: IwbSubRecordDef;
  wbLVLT: IwbSubRecordDef;
  wbLVCT: IwbSubRecordDef;
  wbLVOC: IwbSubRecordDef;
  wbLVIG: IwbSubRecordDef;
  wbXPCK: IwbSubRecordDef;
  wbVCRY: IwbSubRecordDef;
  wbXCHG: IwbSubRecordDef;
  wbWTFG: IwbSubRecordDef;
  wbXLKR: IwbSubRecordArrayDef;
  wbXATP: IwbSubRecordDef;
  wbXWPK: IwbSubRecordStructDef;
  wbWaterData: IwbSubRecordStructDef;
  wbPERKData: IwbSubRecordDef;
  wbPerkEffect: IwbSubRecordStructDef;
  wbReward: IwbRecordMemberDef;
  wbCTRN: IwbSubRecordDef;
  wbUITE, wbUITO : IwbEnumDef;
  wbBlendOperationEnum: IwbEnumDef;
  s: String;
  a, b, c : TVarRecs;

function wbGenericModel(aRequired: Boolean = False; aDontShow: TwbDontShowCallback = nil): IwbRecordMemberDef;
begin
  Result :=
    wbRStructSK([0], 'Model', [
      wbString(MODL, 'Model FileName'),
      wbMODT,
      wbMODC,
      wbMODS,
      wbMODF,
      wbENLM,
      wbModelXFLG,
      wbENLT,
      wbENLS,
      wbAUUV,
      wbMODD
    ], [], cpNormal, aRequired, aDontShow)
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseModels)
    .IncludeFlag(dfAllowAnyMember);
end;

function wbTexturedModel(aSubRecordName: string; const aSignatures: TwbSignatures; const aTextureSubRecords: array of IwbRecordMemberDef): IwbRecordMemberDef;
var
  Members: array of IwbRecordMemberDef;
begin
  SetLength(Members, Length(aTextureSubRecords) + 2);
  Members[0] := wbString(aSignatures[0], 'Model FileName');
  Members[1] := wbModelInfo(aSignatures[1]);
  for var i := Low(aTextureSubRecords) to High(aTextureSubRecords) do
    Members[2 + i] := aTextureSubRecords[i];

  Result :=
    wbRStruct(aSubRecordName, Members, [])
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseModels)
    .IncludeFlag(dfAllowAnyMember);
end;

{ function wbACTIBase(aRequired: Boolean = False; aDontShow: TwbDontShowCallback = nil): IwbRecordMemberDef;
begin
  Result :=
    wbRStructSK([0], 'Model', [
      wbString(MODL, 'Model FileName', 0, cpNormal, True),
      wbMODT,
      wbMODC,
      wbMODS,
      wbMODF,
      wbENLM,
      wbModelXFLG,
      wbENLT,
      wbENLS,
      wbAUUV,
      wbMODD
    ], [], cpNormal, aRequired, aDontShow, True)
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseModels)
    .IncludeFlag(dfAllowAnyMember);
end; //WIP }

function wbDamageTypeArray(aItemName: string): IwbSubRecordDef;
begin
    Result := wbArrayS(DAMA, aItemName+'s', wbStructSK([0], aItemName, [
      wbFormIDCk('Damage Type', [DMGT]),
      wbInteger('Value', itU32),
      wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
    ]))
end;

function wbEPFDActorValueToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  AsCardinal : Cardinal;
  AsFloat    : Single;
begin
  AsCardinal := aInt;
  AsFloat := PSingle(@AsCardinal)^;
  aInt := Round(AsFloat);
  case aType of
    ctToStr, ctToSummary: Result := wbActorValueEnum.ToString(aInt, aElement, aType = ctToSummary);
    ctToSortKey: Result := wbActorValueEnum.ToSortKey(aInt, aElement);
    ctCheck: Result := wbActorValueEnum.Check(aInt, aElement);
    ctToEditValue: Result := wbActorValueEnum.ToEditValue(aInt, aElement);
    ctEditType: Result := 'ComboBox';
    ctEditInfo: Result := wbActorValueEnum.EditInfo[aElement].ToCommaText;
  end;
end;

function wbEPFDActorValueToInt(const aString: string; const aElement: IwbElement): Int64;
var
  AsCardinal : Cardinal;
  AsFloat    : Single;
begin
  AsFloat := wbActorValueEnum.FromEditValue(aString, aElement);
  PSingle(@AsCardinal)^ := AsFloat;
  Result := AsCardinal;
end;

function wbAVIFValueToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
  rFNAM      : IwbElement;
  i          : Integer;
  s          : string;
begin
  i := 0;
  Container := aElement.Container;
  if Assigned(Container) then begin
    rFNAM := Container.ElementBySignature['FNAM'];
    if Assigned(rFNAM) then
      i := rFNAM.NativeValue;
  end;

  if i and 2 <> 0 then
    s := FloatToStrF(PSingle(@aInt)^, ffFixed, 99, wbFloatDigits)
  else
    s := 'rgba(' + IntToStr(aInt and $FF) + ', ' +
                   IntToStr(aInt shr 8 and $FF) + ', ' +
                   IntToStr(aInt shr 16 and $FF) + ', ' +
                   IntToStr(aInt shr 24 and $FF) + ')';

  case aType of
    ctToStr, ctToSummary: Result := s;
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctToEditValue: Result := s;
  end;
end;

function wbAVIFValueToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
  value: Single;
begin
  if SameText(Copy(aString, 1, 5), 'rgba(') then begin
    s := Copy(aString, 6, Pos(')', aString) - 6);
    with TStringList.Create do try
      Delimiter := ',';
      StrictDelimiter := True;
      DelimitedText := s;
      Result := 0;
      if Count = 4 then begin
        PByte(@Result)[0] := StrToIntDef(Strings[0], 0);
        PByte(@Result)[1] := StrToIntDef(Strings[1], 0);
        PByte(@Result)[2] := StrToIntDef(Strings[2], 0);
        PByte(@Result)[3] := StrToIntDef(Strings[3], 0);
      end;
    finally
      Free;
    end;
    Exit;
  end;

  try
    value := StrToFloat(aString)
  except
    value := 0.0
  end;

  Result := PInteger(@value)^;
end;

function wbCTDAParam2QuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
  Objectives : IwbContainerElementRef;
  Objective  : IwbContainerElementRef;
  i, j       : Integer;
  s, t       : string;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Parameter 1>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Param1 := Container.ElementByName['Parameter #1'];
  if not wbTryGetMainRecord(Param1, MainRecord) then
    Exit;

  // get winning quest override except for partial forms
  if MainRecord.WinningOverride.Flags._Flags and $00004000 = 0 then
    MainRecord := MainRecord.WinningOverride
  else if MainRecord.Flags._Flags and $00004000 <> 0 then
    MainRecord := MainRecord.MasterOrSelf;

  if MainRecord.Signature <> QUST then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;
  try
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          j := Stage.ElementNativeValues['INDX\Stage Index'];
          s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    if Supports(MainRecord.ElementByName['Objectives'], IwbContainerElementRef, Objectives) then begin
      for i := 0 to Pred(Objectives.ElementCount) do
        if Supports(Objectives.Elements[i], IwbContainerElementRef, Objective) then begin
          j := Objective.ElementNativeValues['QOBJ'];
          s := Trim(Objective.ElementValues['NNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbCTDAParam1QuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
  Objectives : IwbContainerElementRef;
  Objective  : IwbContainerElementRef;
  i, j       : Integer;
  s, t       : string;
  GroupRecord: IwbGroupRecord;
  Element    : IwbElement;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Quest>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Quest>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not Assigned(aElement) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  Element := nil;
  if (MainRecord.Signature = ACTI) or (MainRecord.Signature = TACT) or (MainRecord.Signature = FURN) then
    Element := MainRecord.ElementBySignature[QSTI]
  else if MainRecord.Signature = SCEN then
    Element := MainRecord.ElementBySignature[PNAM]
  else if (MainRecord.Signature = PACK) or (MainRecord.Signature = TERM) then
    Element := MainRecord.ElementBySignature[QNAM]
  else if (MainRecord.Signature = GMRW) then
    Element := MainRecord.ElementBySignature[ANAM]
  else if (MainRecord.Signature = INFO) then begin
    // get DIAL for INFO
    if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
      if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then
        if MainRecord.Signature = DIAL then
          Element := MainRecord.ElementBySignature[QNAM];
  end;

  if Assigned(Element) then
    Supports(Element.LinksTo, IwbMainRecord, MainRecord);

  if not Assigned(MainRecord) then
    Exit;

  if MainRecord.Signature <> QUST then
    Exit;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;
  try
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          j := Stage.ElementNativeValues['INDX\Stage Index'];
          s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    if Supports(MainRecord.ElementByName['Objectives'], IwbContainerElementRef, Objectives) then begin
      for i := 0 to Pred(Objectives.ElementCount) do
        if Supports(Objectives.Elements[i], IwbContainerElementRef, Objective) then begin
          j := Objective.ElementNativeValues['QOBJ'];
          s := Trim(Objective.ElementValues['NNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbPerkDATAQuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
  Objectives : IwbContainerElementRef;
  Objective  : IwbContainerElementRef;
  i, j       : Integer;
  s, t       : string;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if aType = ctToStr then
        Result := Result + ' <Warning: Could not resolve Quest>';
    end;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve Quest>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Param1 := Container.ElementByName['Quest'];
  if not wbTryGetMainRecord(Param1, MainRecord) then
    Exit;

  // get winning quest override except for partial forms
  if MainRecord.WinningOverride.Flags._Flags and $00004000 = 0 then
    MainRecord := MainRecord.WinningOverride
  else if MainRecord.Flags._Flags and $00004000 <> 0 then
    MainRecord := MainRecord.MasterOrSelf;

  if MainRecord.Signature <> QUST then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" is not a Quest record>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;
  try
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          j := Stage.ElementNativeValues['INDX\Stage Index'];
          s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    if Supports(MainRecord.ElementByName['Objectives'], IwbContainerElementRef, Objectives) then begin
      for i := 0 to Pred(Objectives.ElementCount) do
        if Supports(Objectives.Elements[i], IwbContainerElementRef, Objective) then begin
          j := Objective.ElementNativeValues['QOBJ'];
          s := Trim(Objective.ElementValues['NNAM']);
          t := IntToStr(j).PadLeft(3,'0');
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(j))
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Stage/Objective not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbQuestStageToInt(const aString: string; const aElement: IwbElement): Int64;
var
  i    : Integer;
  s    : string;
begin
  i := 1;
  s := Trim(aString);
  while (i <= Length(s)) and (s[i] in ['0'..'9']) do
    Inc(i);
  s := Copy(s, 1, Pred(i));

  Result := StrToInt(s);
end;

function wbCTDAParamQuestOverlay(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): Int64;

  procedure ResolveOverlay;
  var
    MainRecord : IwbMainRecord;
    GroupRecord: IwbGroupRecord;
    Element    : IwbElement;
  begin
    if not Assigned(aElement) then
      Exit;

    MainRecord := aElement.ContainingMainRecord;
    if not Assigned(MainRecord) then
      Exit;

    if MainRecord.Signature = QUST then
      Result := MainRecord.FixedFormID.ToCardinal
    else if (MainRecord.Signature = ACTI) or (MainRecord.Signature = TACT) then begin
      Element := MainRecord.ElementBySignature[QSTI];
      if Assigned(Element) then
        Result := Element.NativeValue;
    end else if MainRecord.Signature = SCEN then begin
      Element := MainRecord.ElementBySignature[PNAM];
      if Assigned(Element) then
        Result := Element.NativeValue;
    end else if (MainRecord.Signature = PACK) or (MainRecord.Signature = TERM) then begin
      Element := MainRecord.ElementBySignature[QNAM];
      if Assigned(Element) then
        Result := Element.NativeValue;
    end else if MainRecord.Signature = INFO then begin
      // get DIAL for INFO
      if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
        if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then
          if MainRecord.Signature = DIAL then begin
            Element := MainRecord.ElementBySignature[QNAM];
            if Assigned(Element) then
              Result := Element.NativeValue;
          end;
    end;
  end;

begin
  Result := aInt;
  if (aInt = 0) and (aType in [ctCheck, ctToStr, ctToSummary, ctToSortKey, ctLinksTo]) then
    ResolveOverlay;
end;

function wbStringToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := StrToIntDef(aString, 0);
end;

function wbLGDIFiltersLinksTo(const aElement: IwbElement): IwbElement;
var
  LegendaryIndex : Integer;
  Filter         : IwbContainerElementRef;
  MainRecord     : IwbMainRecord;
  LegendaryMods  : IwbContainerElementRef;
  LegendaryMod   : IwbContainerElementRef;
  BaseStarSlot   : Integer;
  ModIndex       : Integer;
  ModBase        : IwbContainerElementRef;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Filter := aElement.Container as IwbContainerElementRef;
  if not Assigned(Filter) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementBySignature[BNAM], IwbContainerElementRef, LegendaryMods) then
    Exit;

  BaseStarSlot := Filter.Elements[0].NativeValue;
  ModIndex := aElement.NativeValue;
  LegendaryIndex := -1;

  for var i := 0 to Pred(LegendaryMods.ElementCount) do
  begin
    LegendaryMod := LegendaryMods.Elements[i] as IwbContainerElementRef;
    if LegendaryMod[0].NativeValue = BaseStarSlot then
    begin
       LegendaryIndex := i + ModIndex;
       Break;
    end
  end;

  if LegendaryIndex = -1 then
    Exit;
    
  if not Supports(LegendaryMods.Elements[LegendaryIndex], IwbContainerElementRef, ModBase) then
    Exit;
  

  Result := ModBase.Elements[1].LinksTo;
end;

function wbLGDIFiltersToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  LegendaryIndex : Integer;
  Filter         : IwbContainerElementRef;
  MainRecord     : IwbMainRecord;
  LegendaryMods  : IwbContainerElementRef;
  LegendaryMod   : IwbContainerElementRef;
  BaseStarSlot   : Integer;
  ModIndex       : Integer;
begin
  Result := 'Unknown Ref';
  if not Assigned(aElement) then
    Exit;

  Filter := aElement.Container as IwbContainerElementRef;
  if not Assigned(Filter) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementBySignature[BNAM], IwbContainerElementRef, LegendaryMods) then
    Exit;

  BaseStarSlot := Filter.Elements[0].NativeValue;
  ModIndex := aElement.NativeValue;
  LegendaryIndex := -1;

  for var i := 0 to Pred(LegendaryMods.ElementCount) do
  begin
    LegendaryMod := LegendaryMods.Elements[i] as IwbContainerElementRef;
    if LegendaryMod[0].NativeValue = BaseStarSlot then
    begin
       LegendaryIndex := i + ModIndex;
       Break;
    end
  end;
  if LegendaryIndex = -1 then
    Exit;

  LegendaryMod := LegendaryMods.Elements[LegendaryIndex] as IwbContainerElementRef;

  Result := LegendaryMod[1].EditValue;
end;

{function wbXRTIFiltersToStr(const aElement: IwbElement): IwbElement;
var
  LegendaryIndex : Integer;
  Filter         : IwbContainerElementRef;
  MainRecord     : IwbMainRecord;
  LegendaryMods  : IwbContainerElementRef;
  LegendaryMod   : IwbContainerElementRef;
  BaseStarSlot   : Integer;
  ModIndex       : Integer;
  ModBase        : IwbContainerElementRef;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Filter := aElement.Container as IwbContainerElementRef;
  if not Assigned(Filter) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementBySignature[BNAM], IwbContainerElementRef, LegendaryMods) then
    Exit;

  BaseStarSlot := Filter.Elements[0].NativeValue;
  ModIndex := aElement.NativeValue;
  LegendaryIndex := -1;

  for var i := 0 to Pred(LegendaryMods.ElementCount) do
  begin
    LegendaryMod := LegendaryMods.Elements[i] as IwbContainerElementRef;
    if LegendaryMod[0].NativeValue = BaseStarSlot then
    begin
       LegendaryIndex := i + ModIndex;
       Break;
    end
  end;

  if LegendaryIndex = -1 then
    Exit;

  if not Supports(LegendaryMods.Elements[LegendaryIndex], IwbContainerElementRef, ModBase) then
    Exit;


  Result := ModBase.Elements[1].LinksTo;
end;

function wbXRTIFiltersToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  LegendaryIndex : Integer;
  Filter         : IwbContainerElementRef;
  MainRecord     : IwbMainRecord;
  LegendaryMods  : IwbContainerElementRef;
  LegendaryMod   : IwbContainerElementRef;
  BaseStarSlot   : Integer;
  ModIndex       : Integer;
begin
  Result := 'Unknown Ref';
  if not Assigned(aElement) then
    Exit;

  Filter := aElement.Container as IwbContainerElementRef;
  if not Assigned(Filter) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementBySignature[BNAM], IwbContainerElementRef, LegendaryMods) then
    Exit;

  BaseStarSlot := Filter.Elements[0].NativeValue;
  ModIndex := aElement.NativeValue;
  LegendaryIndex := -1;

  for var i := 0 to Pred(LegendaryMods.ElementCount) do
  begin
    LegendaryMod := LegendaryMods.Elements[i] as IwbContainerElementRef;
    if LegendaryMod[0].NativeValue = BaseStarSlot then
    begin
       LegendaryIndex := i + ModIndex;
       Break;
    end
  end;
  if LegendaryIndex = -1 then
    Exit;

  LegendaryMod := LegendaryMods.Elements[LegendaryIndex] as IwbContainerElementRef;

  Result := LegendaryMod[1].EditValue;
end;    }

{ Alias to string conversion, requires quest reference or quest record specific to record that references alias }
function wbAliasToStr(aInt: Int64; const aQuestRef: IwbElement; aType: TwbCallbackType): string;
var
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Aliases    : IwbContainerElementRef;
  Alias      : IwbContainerElementRef;
  i, j       : Integer;
  s, t       : string;
begin
  case aType of
    ctToStr, ctToSummary: if aInt = -1 then
        Result := 'None'
      else if aInt = -2 then
        Result := 'Player'
      else begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Could not resolve alias>';
      end;
    ctToEditValue: if aInt = -1 then Result := 'None' else
      Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: if (aInt = -1) or (aInt = -2) then Result := '' else
      Result := '<Warning: Could not resolve alias>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if ((aInt = -1) or (aInt = -2)) and (aType <> ctEditType) and (aType <> ctEditInfo) then
    Exit;

  if not Assigned(aQuestRef) then
    Exit;

  // aQuestRef can be a QUST record or reference to QUST record
  if not Supports(aQuestRef, IwbMainRecord, MainRecord) then
    if not Supports(aQuestRef.LinksTo, IwbMainRecord, MainRecord) then
      Exit;

  // get winning quest override except for partial forms
  if MainRecord.WinningOverride.Flags._Flags and $00004000 = 0 then
    MainRecord := MainRecord.WinningOverride
  else if MainRecord.Flags._Flags and $00004000 <> 0 then
    MainRecord := MainRecord.MasterOrSelf;

  if MainRecord.Signature <> QUST then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "' + MainRecord.ShortName + '" is not a Quest record>';
      end;
      ctCheck: Result := '<Warning: "' + MainRecord.ShortName + '" is not a Quest record>';
    end;
    Exit;
  end;

  case aType of
    ctEditType: begin
      Result := 'ComboBox';
      Exit;
    end;
    ctEditInfo:
      EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;

  try
    if Supports(MainRecord.ElementByName['Aliases'], IwbContainerElementRef, Aliases) then begin
      for i := 0 to Pred(Aliases.ElementCount) do
        if Supports(Aliases.Elements[i], IwbContainerElementRef, Alias) then begin
          // skip alias collection
          if Assigned(Alias.ElementBySignature['ALCS']) then
            Continue;
          j := Alias.Elements[0].NativeValue;
          s := Alias.ElementEditValues['ALID'];
          t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.Add(t)
          else if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Alias not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Alias not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Add('None');
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbStrToAlias(const aString: string; const aElement: IwbElement): Int64;
var
  i    : Integer;
  s    : string;
begin
  Result := -1;

  if aString = 'None' then
    Exit;

  if aString = 'Player' then begin
    Result := -2;
    Exit;
  end;

  i := 1;
  s := Trim(aString);
  while (i <= Length(s)) and (s[i] in ['-', '0'..'9']) do
    Inc(i);
  s := Copy(s, 1, Pred(i));

  Result := StrToIntDef(s, -1);
end;

function wbScriptObjectAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
begin
  if not wbResolveAlias then begin
    case aType of
      ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
      ctToSortKey: Result := IntToHex64(aInt, 8);
    else
      Result := '';
    end;
    Exit;
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Result := wbAliasToStr(aInt, Container.ElementByName['FormID'], aType);
end;

function wbPackageLocationAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
begin
  if not wbResolveAlias then begin
    case aType of
      ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
      ctToSortKey: Result := IntToHex64(aInt, 8);
    else
      Result := '';
    end;
    Exit;
  end;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  while Assigned(Container) and (Container.ElementType <> etMainRecord) do
    Container := Container.Container;

  if not Assigned(Container) then
    Exit;

  Result := wbAliasToStr(aInt, Container.ElementBySignature['QNAM'], aType);
end;

function wbQuestAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
begin
  if not wbResolveAlias then begin
    case aType of
      ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
      ctToSortKey: Result := IntToHex64(aInt, 8);
    else
      Result := '';
    end;
    Exit;
  end;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  while Assigned(Container) and (Container.ElementType <> etMainRecord) do
    Container := Container.Container;

  if not Assigned(Container) then
    Exit;

  Result := wbAliasToStr(aInt, Container, aType);
end;

function wbQuestExternalAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
begin
  if not wbResolveAlias then begin
    case aType of
      ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
      ctToSortKey: Result := IntToHex64(aInt, 8);
    else
      Result := '';
    end;
    Exit;
  end;

  if not Assigned(aElement) then
    Exit;

  Container := aElement.Container;
  if not Assigned(Container) then
    Exit;

  Result := wbAliasToStr(aInt, Container.ElementBySignature['ALEQ'] , aType);
end;

function wbCTDAParam1StringToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container  : IwbContainerElementRef;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
  if not Assigned(Container) then
    Exit;

  Container.ElementEditValues['..\CIS1'] := aString
end;

function wbCTDAParam1StringToString(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
begin
  case aType of
    ctToStr, ctToSummary, ctToSortKey, ctToEditValue, ctToNativeValue: begin
      Result := '';

      if not Assigned(aElement) then
        Exit;

      Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
      if not Assigned(Container) then
        Exit;

      case aType of
        ctToSummary:
          Result := Container.ElementEditValues['..\CIS1'];
        ctToEditValue, ctToNativeValue:
          Result := Container.ElementEditValues['..\CIS1'];
      else
        Result := Container.ElementValues['..\CIS1'];
      end;
    end;
    ctCheck, ctEditType, ctEditInfo, ctLinksTo:
      Result := '';
  else
    Result := aInt.ToString;
  end;
end;

function wbCTDAParam2StringToInt(const aString: string; const aElement: IwbElement): Int64;
var
  Container  : IwbContainerElementRef;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
  if not Assigned(Container) then
    Exit;

  Container.ElementEditValues['..\CIS2'] := aString
end;

function wbCTDAParam2StringToString(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
begin
  case aType of
    ctToStr, ctToSummary, ctToSortKey, ctToEditValue, ctToNativeValue: begin
      Result := '';

      if not Assigned(aElement) then
        Exit;

      Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
      if not Assigned(Container) then
        Exit;

      case aType of
        ctToSummary:
          Result := Container.ElementEditValues['..\CIS2'];
        ctToEditValue, ctToNativeValue:
          Result := Container.ElementEditValues['..\CIS2'];
      else
        Result := Container.ElementValues['..\CIS2'];
      end;
    end;
    ctCheck, ctEditType, ctEditInfo, ctLinksTo:
      Result := '';
  else
    Result := aInt.ToString;
  end;
end;

function wbConditionAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
  MainRecord : IwbMainRecord;
  GroupRecord : IwbGroupRecord;
begin
  if not wbResolveAlias then begin
    case aType of
      ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
      ctToSortKey: Result := IntToHex64(aInt, 8);
    else
      Result := '';
    end;
    Exit;
  end;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  while Assigned(Container) and (Container.ElementType <> etMainRecord) do
    Container := Container.Container;

  if not Assigned(Container) then
    Exit;

  if not Supports(Container, IwbMainRecord, MainRecord) then
    Exit;

  if MainRecord.Signature = QUST then
    Result := wbAliasToStr(aInt, Container, aType)
  else if MainRecord.Signature = SCEN then
    Result := wbAliasToStr(aInt, Container.ElementBySignature['PNAM'], aType)
  else if (MainRecord.Signature = PACK) or (MainRecord.Signature = TERM) then
    Result := wbAliasToStr(aInt, Container.ElementBySignature['QNAM'], aType)
  else if MainRecord.Signature = INFO then begin
    // get DIAL for INFO
    if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
      if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then
        Result := wbAliasToStr(aInt, MainRecord.ElementBySignature['QNAM'], aType);
  end else
  // this should never be called since aliases in conditions can be in the forms above only
  // but just in case
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
    ctToSortKey: Result := IntToHex64(aInt, 8);
  else
    Result := '';
  end;
end;

function wbClmtMoonsPhaseLength(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  PhaseLength : Byte;
  Masser      : Boolean;
  Secunda     : Boolean;
begin
  Result := '';
  if aType = ctToSortKey then begin
    Result := IntToHex64(aInt, 2);
    Exit;
  end;

  if aType in [ctToStr, ctToSummary] then begin
    PhaseLength := aInt mod 64;
    Masser := (aInt and 64) <> 0;
    Secunda := (aInt and 128) <> 0;
    if Masser then
      if Secunda then
        Result := 'Masser, Secunda / '
      else
        Result := 'Masser / '
    else
      if Secunda then
        Result := 'Secunda / '
      else
        Result := 'No Moon / ';
    Result := Result + IntToStr(PhaseLength);
  end;
end;

function wbClmtTime(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  if aType = ctToSortKey then
    Result := IntToHex64(aInt, 4)
  else if aType in [ctToStr, ctToSummary] then
    Result := TimeToStr( EncodeTime(aInt div 6, (aInt mod 6) * 10, 0, 0) )
  else
    Result := '';
end;


var
  wbCtdaTypeFlags : IwbFlagsDef;

function wbCtdaTypeToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  s: string;
begin
  Result := '';

  if not Assigned(wbCtdaTypeFlags) then
    wbCtdaTypeFlags := wbFlags([
      {0x01} 'Or',
      {0x02} 'Use aliases',
      {0x04} 'Use global',
      {0x08} 'Use packdata',
      {0x10} 'Swap Subject and Target'
    ]);
{
    Compare operator (upper 3 bits)
    LGE
    000    0=Equal to
    001    1=Not equal to
    010    2=Greater than
    011    3=Greater than or equal to
    100    4=Less than
    101    5=Less than or equal to

    Flags (lower 5 bits)
        0x01=OR (default is to AND conditions together)
        0x02=Parameters (use aliases) : Force function parameters to use quest alias data (exclusive with "use pack data")
        0x04=Use global
        0x08=Use Pack Data : Force function parameters to use pack data (exclusive with "use aliases")
        0x10=Swap Subject and Target
}
  case aType of
    ctEditType:
      Result := 'CheckComboBox';
    ctEditInfo:
      Result := 'Equal,Greater,Lesser,Or,"Use Aliases","Use Global","Use Packdata","Swap Subject and Target"';
    ctToEditValue: begin
      Result := '00000000';
      case aInt and $E0 of
        $00 : Result[1] := '1';
        $40 : Result[2] := '1';
        $60 : begin
                Result[1] := '1';
                Result[2] := '1';
              end;
        $80 : Result[3] := '1';
        $A0 : begin
                Result[1] := '1';
                Result[3] := '1';
              end;
      end;
      if (aInt and $01) <> 0 then // Or
        Result[4] := '1';
      if (aInt and $02) <> 0 then // Use aliases
        Result[5] := '1';
      if (aInt and $04) <> 0 then // Use global
        Result[6] := '1';
      if (aInt and $08) <> 0 then // Use packdata
        Result[7] := '1';
      if (aInt and $10) <> 0 then // Swap Subject and Target
        Result[8] := '1';
    end;
    ctToStr, ctToSummary: begin
      case aInt and $E0 of
        $00 : Result := 'Equal to';
        $20 : Result := 'Not equal to';
        $40 : Result := 'Greater than';
        $60 : Result := 'Greater than or equal to';
        $80 : Result := 'Less than';
        $A0 : Result := 'Less than or equal to';
      else
        Result := '<Unknown Compare operator>'
      end;
      s := wbCtdaTypeFlags.ToString(aInt and $1F, aElement, aType = ctToSummary);
      if s <> '' then
        Result := Result + ' / ' + s;
    end;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
      Exit;
    end;
    ctCheck: begin
      case aInt and $E0 of
        $00, $20, $40, $60, $80, $A0 : Result := '';
      else
        Result := '<Unknown Compare operator>'
      end;
      s := wbCtdaTypeFlags.Check(aInt and $1F, aElement);
      if s <> '' then
        Result := Result + ' / ' + s;
    end;
  end;
end;

function wbCtdaTypeToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
begin
  s := aString + '00000000';
  if s[1] = '1' then begin
    if s[2] = '1' then begin
      if s[3] = '1' then begin
        Result := $00;
      end else begin
        Result := $60;
      end;
    end else begin
      if s[3] = '1' then begin
        Result := $A0;
      end else begin
        Result := $00;
      end;
    end;
  end else begin
    if s[2] = '1' then begin
      if s[3] = '1' then begin
        Result := $20;
      end else begin
        Result := $40;
      end;
    end else begin
      if s[3] = '1' then begin
        Result := $80;
      end else begin
        Result := $20;
      end;
    end;
  end;
  // Or
  if s[4] = '1' then
    Result := Result or $01;
  // Use aliases
  if s[5] = '1' then
    Result := Result or $02;
  // Use global
  if s[6] = '1' then
    Result := Result or $04;
  // Use packdata
  if s[7] = '1' then
    Result := Result or $08;
  // Swap Subject and Target
  if s[8] = '1' then
    Result := Result or $10;
end;

var
  wbEventFunctionAndMemberEditInfo: string;

function wbEventFunctionAndMemberToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  EventFunction, EventMember: Integer;
  i, j: Integer;
  s1, s2: string;
  slMember: TStringList;
begin
  Result := '';
  EventFunction := aInt and $FFFF;
  EventMember := aInt shr 16;
  case aType of
    ctToStr, ctToSummary, ctToEditValue: begin
      Result := wbEventFunctionEnum.ToEditValue(EventFunction, nil);
      Result := Result + ':' + wbEventMemberEnum.ToEditValue(EventMember, nil);
    end;
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctCheck: begin
      s1 := wbEventFunctionEnum.Check(EventFunction, nil);
      if s1 <> '' then
        s1 := 'EventFunction' + s1;
      s2 := wbEventMemberEnum.Check(EventMember, nil);
      if s2 <> '' then
        s2 := 'EventMember' + s2;
      if (s1 <> '') or (s2 <> '') then
        Result := s1 + ':' + s2;
    end;
    ctEditType:
      Result := 'ComboBox';
    ctEditInfo: begin
      Result := wbEventFunctionAndMemberEditInfo;
      if Result = '' then try
        slMember := TStringList.Create;
        slMember.AddStrings(wbEventMemberEnum.EditInfo[nil]);
        with TStringList.Create do try
          for i := 0 to Pred(wbEventFunctionEnum.NameCount) do
            for j := 0 to Pred(slMember.Count) do
              Add(wbEventFunctionEnum.Names[i] + ':' + slMember[j]);
          Sort;
          Result := CommaText;
        finally
          Free;
        end;
        wbEventFunctionAndMemberEditInfo := Result;
      finally
        FreeAndNil(slMember);
      end
    end;
  end;
end;

function wbEventFunctionAndMemberToInt(const aString: string; const aElement: IwbElement): Int64;
var
  EventFunction, EventMember, i: Integer;
begin
  i := Pos(':', aString);
  if i > 0 then begin
    EventFunction := wbEventFunctionEnum.FromEditValue(Copy(aString, 1, i-1), nil);
    EventMember := wbEventMemberEnum.FromEditValue(Copy(aString, i+1, Length(aString)), nil);
  end
  else begin
    EventFunction := 0;
    EventMember := 0;
  end;
  Result := EventMember shl 16 + EventFunction;
end;

function wbOBTEAddonIndexToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  MainRecord, OMOD: IwbMainRecord;
  Includes, Include: IwbContainer;
  Entries, Entry: IwbContainerElementRef;
  i, j, AddonIndex: Integer;
  bFoundOverride: Boolean;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
    ctCheck: begin

      AddonIndex := aInt;

      // check index override from "AddonIndex" property of Includes
      bFoundOverride := False;
      if Assigned(aElement.Container) and Supports(aElement.Container.ElementByName['Includes'], IwbContainer, Includes) then
        for i := 0 to Pred(Includes.ElementCount) do begin
          if not Supports(Includes.Elements[i], IwbContainer, Include) then
            Continue;
          if not Supports(Include.ElementLinksTo['Mod'], IwbMainRecord, OMOD) then
            Continue;
          if not Supports(OMOD.ElementByPath['DATA\Properties'], IwbContainerElementRef, Entries) then
            Continue;
          for j := 0 to Pred(Entries.ElementCount) do
            if Supports(Entries.Elements[j], IwbContainerElementRef, Entry) then
              if Entry.ElementEditValues['Property'] = 'AddonIndex' then begin
                AddonIndex := Entry.ElementNativeValues['Value 1 - Int'];
                bFoundOverride := True;
                Break;
              end;

          if bFoundOverride then
            Break;
        end;

      if AddonIndex = -1 then
        Exit;

      MainRecord := aElement.ContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit;

      if Supports(MainRecord.ElementByName['Models'], IwbContainerElementRef, Entries) then
        for i := 0 to Pred(Entries.ElementCount) do
          if Supports(Entries.Elements[i], IwbContainerElementRef, Entry) then
            if Entry.ElementNativeValues['INDX'] = AddonIndex then
              Exit;

      Result := '<Warning: Invalid Addon Index ' + IntToStr(AddonIndex) + '>';
    end;
  end;
end;

procedure wbMESGDNAMAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue : Integer;
  Container          : IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := Integer(aOldValue) and 1;
  NewValue := Integer(aNewValue) and 1;

  if NewValue = OldValue then
    Exit;

  if NewValue = 1 then
    Container.RemoveElement('TNAM')
  else
    Container.Add('TNAM', True);
end;

procedure wbGMSTEDIDAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue : string;
  Container          : IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := aOldValue;
  NewValue := aNewValue;

  if (Length(OldValue) < 1) or (Length(OldValue) < 1) or (OldValue[1] <> NewValue[1]) then begin
    Container.RemoveElement('DATA');
    Container.Add('DATA', True);
  end;
end;

procedure wbFLSTEDIDAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue     : string;
  OldOrdered, NewOrdered : Boolean;
  Container              : IwbContainerElementRef;
const
  OrderedList = 'OrderedList';
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  OldValue := aOldValue;
  NewValue := aNewValue;

  if Length(OldValue) > Length(OrderedList) then
    Delete(OldValue, 1, Length(OldValue)-Length(OrderedList));

  if Length(NewValue) > Length(OrderedList) then
    Delete(NewValue, 1, Length(NewValue)-Length(OrderedList));

  OldOrdered := SameText(OldValue, OrderedList);
  NewOrdered := SameText(NewValue, OrderedList);

  if OldOrdered <> NewOrdered then
    Container.RemoveElement('FormIDs');
end;

procedure wbCtdaTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue: Integer;
  Container: IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  // reset value if "use global" has changed
  OldValue := aOldValue and $04;
  NewValue := aNewValue and $04;

  if OldValue <> NewValue then
    Container.ElementNativeValues['..\Comparison Value'] := 0;

  {>>> "run on target", no such flag in Skyrim <<<}
//  if aNewValue and $02 then begin
//    Container.ElementNativeValues['..\Run On'] := 1;
//    if Integer(Container.ElementNativeValues['..\Run On']) = 1 then
//      aElement.NativeValue := Byte(aNewValue) and not $02;
//  end;
end;

procedure wbAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  Exit;
end;

{procedure wbLVLOAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  MainRecord: IwbMainRecord;
begin

  if not Supports(aElement, IwbMainRecord, MainRecord) then
    Exit;

  if MainRecord.FixedFormID.ToCardinal < 69 then
    aElement.NativeValue := 0;

  Exit;
end; // WIP }

{>>> Needs revision for Skyrim <<<}
//function wbIdleAnam(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
//begin
//  Result := '';
//  case aType of
//    ctToStr, ctToSummary: begin
//      case aInt and not $C0 of
//        0: Result := 'Idle';
//        1: Result := 'Movement';
//        2: Result := 'Left Arm';
//        3: Result := 'Left Hand';
//        4: Result := 'Weapon';
//        5: Result := 'Weapon Up';
//        6: Result := 'Weapon Down';
//        7: Result := 'Special Idle';
//       20: Result := 'Whole Body';
//       21: Result := 'Upper Body';
//      else
//        Result := '<Unknown: '+IntToStr(aInt and not $C0)+'>';
//      end;
//
//      if (aInt and $80) = 0 then
//        Result := Result + ', Must return a file';
//      if (aInt and $40) = 1 then
//        Result := Result + ', Unknown Flag';
//    end;
//    ctToSortKey: begin
//      Result := IntToHex64(aInt, 2);
//    end;
//    ctCheck: begin
//      case aInt and not $C0 of
//        0..7, 20, 21: Result := '';
//      else
//        Result := '<Unknown: '+IntToStr(aInt and not $C0)+'>';
//      end;
//    end;
//  end;
//end;

function wbShortXYtoStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  x, y: SmallInt;
begin
  y := aInt and $FFFF;
  x := aInt shr 16 and $FFFF;
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := Format('%d, %d', [x, y]);
    ctCheck: Result := '';
  end;
end;

function wbStrToShortXY(const aString: string; const aElement: IwbElement): Int64;
var
  x, y: SmallInt;
  Value: Cardinal;
begin
  y := StrToIntDef(Copy(aString, 1, Pred(Pos(', ', aString))), 0);
  x := StrToIntDef(Copy(aString, Pos(', ', aString) + 2, Length(aString)), 0);
  PWord(@Value)^ := x;
  PWord(Cardinal(@Value) + SizeOf(SmallInt))^ := y;
  Result := Value;
end;

function wbPlacedAddInfo(const aMainRecord: IwbMainRecord): string;
var
  Rec: IwbRecord;
  Container: IwbContainer;
  s: string;
  Cell: IwbMainRecord;
  Position: TwbVector;
  Grid: TwbGridCell;
begin
  Result := '';

  Rec := aMainRecord.RecordBySignature['NAME'];
  if Assigned(Rec) then begin
    s := Trim(Rec.Value);
    if s <> '' then
      Result := 'places ' + s;
  end;

  Container := aMainRecord.Container;
  while Assigned(Container) and (Container.ElementType <> etGroupRecord) do
    Container := Container.Container;

  if not Assigned(Container) then
    Exit;

  s := Trim(Container.Name);
  if s <> '' then begin
    if Result <> '' then
      Result := Result + ' ';

    Result := Result + 'in ' + s;

    // grid position of persistent reference in exterior persistent cell (interior cells are not persistent)
    if Supports(aMainRecord.Container, IwbGroupRecord, Container) then
      Cell := IwbGroupRecord(Container).ChildrenOf;

    if Assigned(Cell) and Cell.IsPersistent and (Cell.Signature = 'CELL') then
      if aMainRecord.GetPosition(Position) then begin
        Grid := wbPositionToGridCell(Position);
        Result := Result + ' at ' + IntToStr(Grid.x) + ',' + IntToStr(Grid.y);
      end;

    // in precombined mesh
    if aMainRecord.HasPrecombinedMesh then
      Result := Result + ' in ' + aMainRecord.PrecombinedMesh;
  end;
end;

function wbINFOAddInfo(const aMainRecord: IwbMainRecord): string;
var
  Container: IwbContainer;
  s: string;
begin
  Result := Trim(aMainRecord.ElementValues['Responses\Response\NAM1']);
  if Result <> '' then
    Result := '''' + Result + '''';

  Container := aMainRecord.Container;
  while Assigned(Container) and (Container.ElementType <> etGroupRecord) do
    Container := Container.Container;

  if Assigned(Container) then begin
    s := Trim(Container.Name);
    if s <> '' then begin
      if Result <> '' then
        Result := Result + ' ';
      Result := Result + 'in ' + s;
    end;
  end;

  s := Trim(aMainRecord.ElementValues['QNAM']);
  if s <> '' then begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + 'for ' + s;
  end;
end;

function wbNPCLevelDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
  i: Int64;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  i := Container.ElementByName['Flags'].NativeValue;
  if i and $00000080 <> 0 then
    Result := 1;
end;

function wbMGEFAssocItemDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
  Archtype      : Variant;
  DataContainer : IwbDataContainer;
  Element       : IwbElement;
const
  OffsetArchtype = 56;

begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  VarClear(ArchType);
  Element := Container.ElementByName['Archetype'];

  if Assigned(Element) then
    ArchType := Element.NativeValue
  else if Supports(Container, IwbDataContainer, DataContainer) and
          DataContainer.IsValidOffset(aBasePtr, aEndPtr, OffsetArchtype) then begin // we are part a proper structure
      aBasePtr := PByte(aBasePtr) + OffsetArchtype;
      ArchType := PCardinal(aBasePtr)^;
    end;

  if VarIsEmpty(ArchType) then
    Exit;

  case Integer(ArchType) of
    00: Result := 9;  //Value Modifier
    01: Result := 0;
    04: Result := 0;
    05: Result := 0;
    06: Result := 0;
    07: Result := 0;
    08: Result := 0;
    09: Result := 0;
    11: Result := 0;
    12: Result := 1;  // Light
    17: Result := 2;  // Bound Item
    18: Result := 3;  // Summon Creature
    20: Result := 11; // Telekinesis
    21: Result := 0;
    25: Result := 4;  // Guide
    28: Result := 0;
    31: Result := 0;
    33: Result := 0;
    34: Result := 8;  // Peak Mod
    35: Result := 5;  // Cloak
    36: Result := 6;  // Werewolf
    37: Result := 0;
    39: Result := 7;  // Enhance Weapon
    40: Result := 4;  // Spawn Hazard
    45: Result := 10; // Damage
    46: Result := 6;  // Vampire Lord
    47: Result := 0;
    48: Result := 0;
    49: Result := 0;
    50: Result := 12; // Grow Flora
  else
    if wbReportMode then
      wbProgress('Unknown ArchType: ' + Integer(ArchType).ToString);
  end;
end;

procedure wbMGEFAssocItemAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  Element   : IwbElement;
begin
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if not (aNewValue <> 0) then
    Exit;

  Element := Container.ElementByName['Archetype'];
  if Assigned(Element) and (Element.NativeValue = 0) then
      Element.NativeValue := $FF; // Signals ArchType that it should not mess with us on the next change!
        // I assume this will alo protect Second AV Weight (The two actor values are after ArchType)
end;

procedure wbMGEFAV2WeightAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  Element   : IwbElement;
begin
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if not (aNewValue <> 0.0) then
    Exit;

  Element := Container.ElementByName['Archetype'];
  if Assigned(Element) and (Element.NativeValue = 0) then
      Element.NativeValue := $FF; // Signals ArchType that it should not mess with us on the next change!
end;

procedure wbMGEFArchtypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container: IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if (aNewValue < $FF) and (aOldValue < $FF) then begin
    Container.ElementNativeValues['..\Assoc. Item'] := 0;
    case Integer(aNewValue) of
      06: Container.ElementNativeValues['..\Actor Value'] := 00;//Agression
      07: Container.ElementNativeValues['..\Actor Value'] := 01;//Confidence
      08: Container.ElementNativeValues['..\Actor Value'] := 00;//Agression
      11: Container.ElementNativeValues['..\Actor Value'] := 54;//Invisibility
      21: Container.ElementNativeValues['..\Actor Value'] := 53;//Paralysis
      24: Container.ElementNativeValues['..\Actor Value'] := 01;//Confidence
      38: Container.ElementNativeValues['..\Actor Value'] := 01;//Confidence
      42: Container.ElementNativeValues['..\Actor Value'] := 01;//Confidence
    else
      Container.ElementNativeValues['..\Actor Value'] := -1;
    end;
    Container.ElementNativeValues['..\Second Actor Value'] := -1;
    Container.ElementNativeValues['..\Second AV Weight'] := 0.0;
  end;
end;

function wbSubrecordSizeDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  SubRecord : IwbSubRecord;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement, IwbSubRecord, SubRecord) then
    Exit;

  if SubRecord.DataSize > 0 then
    Result := 1;
end;

function wbCOEDOwnerDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  LinksTo    : IwbElement;
  MainRecord : IwbMainRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  LinksTo := Container.ElementLinksTo['Owner'];
  if not Supports(LinksTo, IwbMainRecord, MainRecord) then
    Exit;

  if MainRecord.Signature = 'NPC_' then
    Result := 1
  else if MainRecord.Signature = 'FACT' then
    Result := 2;
end;

function wbGMSTUnionDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rEDID: IwbRecord;
  s: string;
begin
  Result := 1;
  if not Assigned(aElement) then
    Exit;
  rEDID := aElement.Container.RecordBySignature[EDID];
  if not Assigned(rEDID) then
    Exit;

  s := rEDID.Value;
  if Length(s) > 0 then
    case s[1] of
      's': Result := 0; {String} {>>> Localization Strings <<<}
      'i': Result := 1; {intS32}
      'f': Result := 2; {Float}
      'b': Result := 3; {Boolean}
      'u': Result := 4; {Uint32}
    end;
end;

function wbFLSTLNAMIsSorted(const aContainer: IwbContainer): Boolean;
var
  rEDID      : IwbRecord;
  s          : string;
const
  OrderedList = 'OrderedList';
begin
  Result := False; {>>> Should not be sorted according to Arthmoor and JustinOther <<<}
  rEDID := aContainer.RecordBySignature[EDID];
  if not Assigned(rEDID) then
    Exit;

  s := rEDID.Value;
  if Length(s) > Length(OrderedList) then
    Delete(s, 1, Length(s)-Length(OrderedList));

  if SameText(s, OrderedList) then
    Result := False;
end;

function wbPerkEffectDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rPRKE: IwbRecord;
  eType: IwbElement;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;
  rPRKE := aElement.Container.RecordBySignature[PRKE];
  if not Assigned(rPRKE) then
    Exit;

  eType := rPRKE.ElementByName['Type'];
  if not Assigned(eType) then
    Exit;

  Result := eType.NativeValue;
end;

function wbPerkDATADecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rDATA: IwbRecord;
begin
  Result := 2;
  if not Assigned(aElement) then
    Exit;
  rDATA := aElement.Container.RecordBySignature[DATA];
  if Assigned(rDATA) then begin
    if rDATA.DataSize = 3 then begin
      Result := 0;
    end else if rDATA.DataSize = 5 then
      Result := 1;
  end;
end;

function wbEPFDDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  Result := Container.ElementNativeValues['EPFT'];

  if Result = 2 then
    case Integer(Container.ElementNativeValues['..\DATA\Entry Point\Function']) of
      5, 12, 13, 14: Result := 8;
    end;
end;

function wbEPFDAVDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
    Result := 0;
  if not Assigned(aElement) then
    Exit;
    if aElement.DataSize < 8 then Result := 1;
end;

function wbEPF2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
    Result := 0;
    if not Assigned(aElement) then
      Exit;
    if not Supports(aElement.Container, IwbContainerElementRef, Container) then
      Exit;
    if Container.ElementNativeValues['EPFT'] = 1 then Result := 1;
end;

function wbEPF3Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
    Result := 0;
    if not Assigned(aElement) then
      Exit;
    if not Supports(aElement.Container, IwbContainerElementRef, Container) then
      Exit;
    if Container.ElementNativeValues['EPFT'] = 8 then Result := 1;
end;

function wbSceneActionSoundDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  if Container.ElementNativeValues['ANAM'] <> 4 then
    Result := 1;
end;

function wbSceneActionRadioDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  if Container.ElementNativeValues['ANAM'] <> 6 then
    Result := 1;
end;


function wbDeciderCELLFlags(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  if (NativeUInt(aEndPtr) - NativeUInt(aBasePtr)) = 2 then
    Result := 0
  else
    Result := wbFormVersionDecider(187)(aBasePtr, aEndPtr, aElement);
end;

function wbAECHDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  rKNAM      : IwbElement;
  s: string;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  rKNAM := Container.ElementBySignature['KNAM'];
  if not Assigned(rKNAM) then Exit;

  s := rKNAM.EditValue;

  // TODO: is using EditValue the best way to do this?
  if s = 'BSOverdrive' then
    Result := 0
  else if s = 'BSStateVariableFilter' then
    Result := 1
  else if s = 'BSDelayEffect' then
    Result := 2;
end;

function wbCLFMColorToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
  rFNAM      : IwbElement;
  i          : Integer;
  s          : string;
begin
  i := 0;
  Container := aElement.Container;
  if Assigned(Container) then begin
    rFNAM := Container.ElementBySignature['FNAM'];
    if Assigned(rFNAM) then
      i := rFNAM.NativeValue;
  end;

   if i and 2 <> 0 then
    s := FloatToStrF(PSingle(@aInt)^, ffFixed, 99, wbFloatDigits)
  else
    s := 'rgba(' + IntToStr(aInt and $FF) + ', ' +
                   IntToStr(aInt shr 8 and $FF) + ', ' +
                   IntToStr(aInt shr 16 and $FF) + ', ' +
                   IntToStr(aInt shr 24 and $FF) + ')';

  case aType of
    ctToStr, ctToSummary: Result := s;
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctToEditValue: Result := s;
  end;
end;

function wbCLFMColorToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
  value: Single;
begin
  if SameText(Copy(aString, 1, 5), 'rgba(') then begin
    s := Copy(aString, 6, Pos(')', aString) - 6);
    with TStringList.Create do try
      Delimiter := ',';
      StrictDelimiter := True;
      DelimitedText := s;
      Result := 0;
      if Count = 4 then begin
        PByte(@Result)[0] := StrToIntDef(Strings[0], 0);
        PByte(@Result)[1] := StrToIntDef(Strings[1], 0);
        PByte(@Result)[2] := StrToIntDef(Strings[2], 0);
        PByte(@Result)[3] := StrToIntDef(Strings[3], 0);
      end;
    finally
      Free;
    end;
    Exit;
  end;

  try
    value := StrToFloat(aString)
  except
    value := 0.0
  end;

  Result := PInteger(@value)^;
end;

function wbSNDRDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  rCNAM      : IwbElement;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  rCNAM := Container.ElementBySignature['CNAM'];
  if not Assigned(rCNAM) then
    Exit;

  if rCNAM.NativeValue = Int64($ED157AE3) then  // 'AutoWeapon'
    Result := 1;
end;

function wbRDOTCountCallback(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container  : IwbContainer;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  Result := Container.DataSize div 76;
end;

{>>> For VMAD <<<}
function wbScriptPropertyDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  case Integer(Container.ElementNativeValues['Type']) of
     1: Result := 1;
     2: Result := 2;
     3: Result := 3;
     4: Result := 4;
     5: Result := 5;
     6: Result := 6;
     7: Result := 7;
    11: Result := 8;
    12: Result := 9;
    13: Result := 10;
    14: Result := 11;
    15: Result := 12;
    17: Result := 13;
  end;
end;

function wbScriptPropertyStructMemberDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  case Integer(Container.ElementNativeValues['Type']) of
     1: Result := 1;
     2: Result := 2;
     3: Result := 3;
     4: Result := 4;
     5: Result := 5;
    11: Result := 6;
    12: Result := 7;
    13: Result := 8;
    14: Result := 9;
    15: Result := 10;
  end;
end;

procedure wbScriptPropertyTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainerElementRef;
begin
  if aOldValue <> aNewValue then
    if Supports(aElement.Container, IwbContainerElementRef, Container) then
      Container.ElementByName['Value'].SetToDefault;
end;

procedure wbScriptFragmentsQuestScriptNameAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainerElementRef;
begin
  if aOldValue <> aNewValue then
    if (aOldValue = '') <> (aNewValue = '') then
      if Supports(aElement.Container, IwbContainerElementRef, Container) then
        Container.ElementByName['Script'].SetToDefault;
end;

procedure wbAECHTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container      : IwbContainerElementRef;
  ValueContainer : IwbContainerElementRef;
begin
  if aOldValue <> aNewValue then
    if Supports(aElement.Container, IwbContainerElementRef, Container) then
      if Supports(Container.ElementByPath['DNAM\Value'], IwbContainerElementRef, ValueContainer) then
        ValueContainer.SetToDefault;
end;


{>>> For VMAD <<<}
function wbScriptFragmentsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  MainRecord : IwbMainRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  while Assigned(Container) and (Container.ElementType <> etMainRecord) do
    Container := Container.Container;

  if not Assigned(Container) then
    Exit;

  // TODO: should this assume there's a MainRecord?'
  Supports(Container, IwbMainRecord, MainRecord);

  if MainRecord.Signature = PERK then
    Result := 1
  else if MainRecord.Signature = TERM then
    Result := 1
  else if MainRecord.Signature = INFO then
    Result := 2
  else if MainRecord.Signature = PACK then
    Result := 3
  else if MainRecord.Signature = QUST then
    Result := 4
  else if MainRecord.Signature = SCEN then
    Result := 5;
end;

{>>> For VMAD <<<}
function wbScriptFragmentsInfoCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container     : IwbContainer;
  F             : Integer;
  i             : Integer;
begin
  Result := 0;
  if aElement.ElementType = etValue then
    Container := aElement.Container
  else
    Container := aElement as IwbContainer;
  if not Assigned(Container) then
    Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  F := Container.ElementByName['Flags'].NativeValue;
  for i := 0 to 2 do begin
    if (F and 1) = 1 then
      Inc(Result);
    F := F shr 1;
  end;

  for i := 3 to 7 do begin
    if (F and 1) = 1 then begin
      Inc(Result);
    if wbHasProgressCallback then
      wbProgressCallback('==='+aElement.Name+'       ['+Container.Name+':'+Container.Path+'] = unknown info VMAD flag bit '+IntToStr(i));
  end;
    F := F shr 1;
  end;
end;

{>>> For VMAD <<<}
function wbScriptFragmentsSceneCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container     : IwbContainer;
  F             : Integer;
  i             : Integer;
begin
  Result := 0;
  if aElement.ElementType = etValue then
    Container := aElement.Container
  else
    Container := aElement as IwbContainer;
  if not Assigned(Container) then
    Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  F := Container.ElementByName['Flags'].NativeValue;
  for i := 0 to 2 do begin
    if (F and 1) = 1 then
      Inc(Result);
    F := F shr 1;
  end;

  for i := 3 to 7 do begin
    if (F and 1) = 1 then begin
      Inc(Result);
  if wbHasProgressCallback then
      wbProgressCallback('==='+aElement.Name+'       ['+Container.Name+':'+Container.Path+'] = unknown scene VMAD flag bit '+IntToStr(i));
  end;
    F := F shr 1;
  end;
end;

{>>> For VMAD <<<}
function wbScriptFragmentsPackCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container     : IwbContainer;
  F             : Integer;
  i             : Integer;
begin
  Result := 0;
  if aElement.ElementType = etValue then
    Container := aElement.Container
  else
    Container := aElement as IwbContainer;
  if not Assigned(Container) then
    Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  F := Container.ElementByName['Flags'].NativeValue;
  for i := 0 to 7 do begin
    if (F and 1) = 1 then
      Inc(Result);
    F := F shr 1;
  end;
end;

{>>> For VMAD <<<}
function wbScriptFragmentsEmptyScriptDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Container.ElementEditValues['ScriptName'] = '' then
    Result := 1;
end;

function wbBOOKTeachesDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
  i: Int64;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  i := Container.ElementByName['Flags'].NativeValue;
  if i and $01 <> 0 then
    Result := 1
  else if i and $04 <> 0 then
    Result := 2
  else if i and $10 <> 0 then
    Result := 3
  else
    Result := 0;
end;

type
  TCTDAFunctionParamType = (
    { 0} ptNone,
    { 1} ptString,
    { 2} ptInteger,
    { 3} ptFloat,
    { 4} ptActor,              // ACHR
    { 5} ptActorBase,          // NPC_
    { 6} ptActorValue,         // AVIF?
    { 7} ptAdvanceAction,      // ?? Enum
    { 8} ptAlias,              // index into QUST quest aliases
    { 9} ptAlignment,          // ?? Enum
    {10} ptAssociationType,    // ASTP
    {11} ptAxis,               // ?? Char
    {12} ptCastingSource,      // ?? Enum
    {13} ptCell,               // CELL
    {14} ptClass,              // CLAS
    {15} ptCrimeType,          // ?? Enum
    {16} ptCriticalStage,      // ?? Enum
    {17} ptEncounterZone,      // ECZN
    {18} ptEquipType,          // ?? Enum
    {19} ptEvent,              // Struct
    {20} ptEventData,          // LCTN, KYWD or FLST
    {21} ptFaction,            // FACT
    {22} ptFormList,           // FLST
    {23} ptFormType,           // ?? Enum
    {24} ptFurniture,          // FURN
    {25} ptFurnitureAnim,      // enum
    {26} ptFurnitureEntry,     // flags
    {27} ptGlobal,             // GLOB
    {28} ptIdleForm,           // IDLE
    {29} ptInventoryObject,    // ARMO, BOOK, MISC, WEAP, AMMO, KEYM, ALCH, ARMA, LIGH, LVLI, COBJ
    {30} ptKeyword,            // KYWD
    {31} ptLocation,           // LCTN
    {32} ptMagicEffect,        // MGEF
    {33} ptMagicItem,          // SPEL
    {34} ptMiscStat,           // ?? Enum
    {35} ptObjectReference,    // REFR, ACHR
    {36} ptOwner,              // FACT, NPC_
    {37} ptPackage,            // PACK
    {38} ptPackdata,           // index into PACK package data inputs
    {39} ptPerk,               // PERK
    {40} ptQuest,              // QUST
    {41} ptQuestStage,         // ?? Integer
    {42} ptRace,               // RACE
    {43} ptReferencableObject,
    {44} ptRefType,            // LCRT
    {45} ptRegion,             // REGN
    {46} ptScene,              // SCEN
    {47} ptSex,                // Enum: Male, Female
    {48} ptShout,              // SHOU
    {49} ptVariableName,       // Integer
    {50} ptVATSValueFunction,  //
    {51} ptVATSValueParam,     //
    {52} ptVoiceType,          // VTYP
    {53} ptWardState,          // enum
    {54} ptWeather,            // WTHR
    {55} ptWorldspace,         // WRLD
    {56} ptDamageType,         // DMGT
    {57} ptConditionForm,      // CNDF
    {58} ptEntitlement,        // ENTM
    {59} ptPerkCard,           // PCRD
    {60} ptAcousticSpace,      // ASPC
    {61} ptCurrency,           // CNCY
    {62} ptConstructibleObject,// COBJ
    {63} ptRegionOpt,          // REGN optional
    {64} ptActorValueEnum,     // Enum: wbActorValue
    {65} ptChallenge,          // CHAL
    {66} ptAttackData,         // Unsure. Defaulting to int
    {67} ptLegendaryItem,      // Unsure. Possibly formid?
    {68} ptDailyContentGroup,  // DailyContentGroup or Quest formid
    {69} ptSpell,
    {70} ptFactionOpt          // FACT
  );

  PCTDAFunction = ^TCTDAFunction;
  TCTDAFunction = record
    Index: Integer;
    Name: string;
    Desc: string;
    ParamType1: TCTDAFunctionParamType;
    ParamType2: TCTDAFunctionParamType;
    ParamType3: TCTDAFunctionParamType;
  end;

const
  wbCTDAFunctions : array[0..617] of TCTDAFunction = (
    (Index:   0; Name: 'GetWantBlocking'),
    (Index:   1; Name: 'GetDistance'; ParamType1: ptObjectReference),
    (Index:   2; Name: 'AddItem'), { ObjID (Form ID), Count, Flag (Opt), Level (Opt), Equip (Opt) }
    (Index:   3; Name: 'SetEssential'),
    (Index:   5; Name: 'GetLocked'),
    (Index:   6; Name: 'GetPos'; ParamType1: ptAxis),
    (Index:   8; Name: 'GetAngle'; ParamType1: ptAxis),
    (Index:  10; Name: 'GetStartingPos'; ParamType1: ptAxis),
    (Index:  11; Name: 'GetStartingAngle'; ParamType1: ptAxis),
    (Index:  12; Name: 'GetSecondsPassed'),
    (Index:  14; Name: 'GetValue'; Desc: 'Get a reference''s value for the given property. [player.getvalue luck]'; ParamType1: ptActorValue{Enum}),
    (Index:  18; Name: 'GetCurrentTime'),
    (Index:  24; Name: 'GetScale'),
    (Index:  25; Name: 'IsMoving'; Desc: 'Is the actor moving?'),
    (Index:  26; Name: 'IsTurning'; Desc: 'Is the actor turning?'),
    (Index:  27; Name: 'GetLineOfSight'; ParamType1: ptObjectReference),
    (Index:  32; Name: 'GetInSameCell'; ParamType1: ptObjectReference),
    (Index:  35; Name: 'GetDisabled'),
    (Index:  36; Name: 'MenuPaused'),
    (Index:  39; Name: 'GetDisease'),
    (Index:  41; Name: 'GetClothingValue'),
    (Index:  42; Name: 'SameFaction'; ParamType1: ptActor),
    (Index:  43; Name: 'SameRace'; ParamType1: ptActor),
    (Index:  44; Name: 'SameSex'; ParamType1: ptActor),
    (Index:  45; Name: 'GetDetected'; ParamType1: ptActor),
    (Index:  46; Name: 'GetDead'),
    (Index:  47; Name: 'GetItemCount'; ParamType1: ptReferencableObject),
    (Index:  48; Name: 'GetGold'),
    (Index:  49; Name: 'GetSleeping'),
    (Index:  50; Name: 'GetTalkedToPC'),
    (Index:  56; Name: 'GetQuestRunning'; ParamType1: ptQuest),
    (Index:  58; Name: 'GetStageCurrentInstance'; Desc: 'Get the stage of the current quest instance'),
    (Index:  59; Name: 'GetStageDoneCurrentInstance';  Desc: 'Is the current quest instance''s stage done'; ParamType1: ptQuestStage),
    (Index:  60; Name: 'GetFactionRankDifference'; ParamType1: ptFaction; Paramtype2: ptActor),
    (Index:  61; Name: 'GetAlarmed'),
    (Index:  62; Name: 'IsRaining'; ParamType1: ptRegionOpt),
    (Index:  63; Name: 'GetAttacked'),
    (Index:  64; Name: 'GetIsCreature'),
    (Index:  65; Name: 'GetLockLevel'),
    (Index:  66; Name: 'GetShouldAttack'; ParamType1: ptActor),
    (Index:  67; Name: 'GetInCell'; ParamType1: ptCell),
    (Index:  68; Name: 'GetIsClass'; ParamType1: ptClass),
    (Index:  69; Name: 'GetIsRace'; ParamType1: ptRace),
    (Index:  70; Name: 'GetIsSex'; ParamType1: ptSex),
    (Index:  71; Name: 'GetInFaction'; ParamType1: ptFaction),
    (Index:  72; Name: 'GetIsID'; ParamType1: ptReferencableObject),
    (Index:  73; Name: 'GetFactionRank'; ParamType1: ptFaction),
    (Index:  74; Name: 'GetGlobalValue'; ParamType1: ptGlobal),
    (Index:  75; Name: 'IsSnowing'; ParamType1: ptRegionOpt),
    (Index:  77; Name: 'GetRandomPercent'),
    (Index:  79; Name: 'WouldBeStealing'; ParamType1: ptObjectReference),
    (Index:  80; Name: 'GetLevel'),
    (Index:  81; Name: 'IsRotating'),
    (Index:  84; Name: 'GetDeadCount'; ParamType1: ptActorBase),
    (Index:  91; Name: 'GetIsAlerted'),
    (Index:  98; Name: 'GetPlayerControlsDisabled'; Desc: '10 optional (0/1) values. movement|fighting|pov|looking|sneaking|menu|activate|journal|vats'; ParamType1: ptInteger; Paramtype2: ptInteger; Paramtype3: ptInteger),
    (Index:  99; Name: 'GetHeadingAngle'; ParamType1: ptObjectReference),
    (Index: 101; Name: 'IsWeaponMagicOut'),
    (Index: 102; Name: 'IsTorchOut'),
    (Index: 103; Name: 'IsShieldOut'),
    (Index: 105; Name: 'IsActionRef'; ParamType1: ptObjectReference),
    (Index: 106; Name: 'IsFacingUp'),
    (Index: 107; Name: 'GetKnockedState'),
    (Index: 108; Name: 'GetWeaponAnimType'),
    (Index: 109; Name: 'IsWeaponSkillType'; ParamType1: ptActorValue),
    (Index: 110; Name: 'GetCurrentAIPackage'),
    (Index: 111; Name: 'IsWaiting'),
    (Index: 112; Name: 'IsIdlePlaying'),
    (Index: 116; Name: 'IsIntimidatedbyPlayer'),
    (Index: 117; Name: 'IsPlayerInRegion'; ParamType1: ptRegion),
    (Index: 118; Name: 'GetActorAggroRadiusViolated'),
    (Index: 122; Name: 'GetCrime'; ParamType1: ptActor; ParamType2: ptCrimeType),
    (Index: 123; Name: 'IsGreetingPlayer'),
    (Index: 125; Name: 'IsGuard'),
    (Index: 127; Name: 'HasBeenEaten'),
    (Index: 128; Name: 'GetStaminaPercentage'),
    (Index: 129; Name: 'HasBeenRead'; ParamType1: ptInventoryObject),
    (Index: 130; Name: 'GetDying'),
    (Index: 131; Name: 'GetSceneActionPercent'; ParamType1: ptScene; ParamType2: ptInteger),
    (Index: 132; Name: 'WouldRefuseCommand'; ParamType1: ptObjectReference),
    (Index: 133; Name: 'SameFactionAsPC'),
    (Index: 134; Name: 'SameRaceAsPC'),
    (Index: 135; Name: 'SameSexAsPC'),
    (Index: 136; Name: 'GetIsReference'; ParamType1: ptObjectReference),
    (Index: 141; Name: 'IsTalking'),
    (Index: 142; Name: 'GetComponentCount'; ParamType1: ptReferencableObject),
    (Index: 143; Name: 'GetCurrentAIProcedure'),
    (Index: 144; Name: 'GetTrespassWarningLevel'),
    (Index: 145; Name: 'IsTrespassing'),
    (Index: 146; Name: 'IsInMyOwnedCell'),
    (Index: 147; Name: 'GetWindSpeed'),
    (Index: 148; Name: 'GetCurrentWeatherPercent'; ParamType1: ptRegionOpt),
    (Index: 149; Name: 'GetIsCurrentWeather'; ParamType1: ptWeather; ParamType2: ptRegionOpt),
    (Index: 150; Name: 'IsContinuingPackagePCNear'),
    (Index: 152; Name: 'GetIsCrimeFaction'; ParamType1: ptFaction),
    (Index: 153; Name: 'CanHaveFlames'),
    (Index: 154; Name: 'HasFlames'),
    (Index: 157; Name: 'GetOpenState'),
    (Index: 159; Name: 'GetSitting'),
    (Index: 161; Name: 'GetIsCurrentPackage'; ParamType1: ptPackage),
    (Index: 162; Name: 'IsCurrentFurnitureRef'; ParamType1: ptObjectReference),
    (Index: 163; Name: 'IsCurrentFurnitureObj'; ParamType1: ptFurniture),
    (Index: 170; Name: 'GetDayOfWeek'),
    (Index: 172; Name: 'GetTalkedToPCParam'; ParamType1: ptActor),
    (Index: 175; Name: 'IsPCSleeping'),
    (Index: 176; Name: 'IsPCAMurderer'),
    (Index: 180; Name: 'HasSameEditorLocationAsRef'; ParamType1: ptObjectReference; ParamType2: ptKeyword),
    (Index: 181; Name: 'HasSameEditorLocationAsRefAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 182; Name: 'GetEquipped'; ParamType1: ptReferencableObject),
    (Index: 185; Name: 'IsSwimming'),
    (Index: 190; Name: 'GetAmountSoldStolen'),
    (Index: 192; Name: 'GetIgnoreCrime'),
    (Index: 193; Name: 'GetPCExpelled'; ParamType1: ptFaction),
    (Index: 195; Name: 'GetPCFactionMurder'; ParamType1: ptFaction),
    (Index: 197; Name: 'GetPCEnemyofFaction'; ParamType1: ptFaction),
    (Index: 199; Name: 'GetPCFactionAttack'; ParamType1: ptFaction),
    (Index: 203; Name: 'GetDestroyed'),
    (Index: 214; Name: 'HasMagicEffect'; ParamType1: ptMagicEffect),
    (Index: 215; Name: 'GetDefaultOpen'),
    (Index: 223; Name: 'IsSpellTarget'; ParamType1: ptMagicItem),
    (Index: 224; Name: 'GetVATSMode'),
    (Index: 225; Name: 'GetPersuasionNumber'),
    (Index: 226; Name: 'GetVampireFeed'),
    (Index: 227; Name: 'GetCannibal'),
    (Index: 228; Name: 'GetIsClassDefault'; ParamType1: ptClass),
    (Index: 229; Name: 'GetClassDefaultMatch'),
    (Index: 230; Name: 'GetInCellParam'; ParamType1: ptCell; ParamType2: ptObjectReference),
    (Index: 231; Name: 'GetPlayerDialogueInput'),
    (Index: 235; Name: 'GetVatsTargetHeight'),
    (Index: 237; Name: 'GetIsGhost'),
    (Index: 242; Name: 'GetUnconscious'),
    (Index: 244; Name: 'GetRestrained'),
    (Index: 246; Name: 'GetIsUsedItem'; ParamType1: ptReferencableObject),
    (Index: 247; Name: 'GetIsUsedItemType'; ParamType1: ptFormType),
    (Index: 248; Name: 'IsScenePlaying'; ParamType1: ptScene),
    (Index: 249; Name: 'IsInDialogueWithPlayer'),
    (Index: 250; Name: 'GetLocationCleared'; ParamType1: ptLocation),
    (Index: 254; Name: 'GetIsPlayableRace'),
    (Index: 255; Name: 'GetOffersServicesNow'),
    (Index: 258; Name: 'HasAssociationType'; ParamType1: ptActor; Paramtype2: ptAssociationType),
    (Index: 259; Name: 'HasFamilyRelationship'; ParamType1: ptActor),
    (Index: 261; Name: 'HasParentRelationship'; ParamType1: ptActor),
    (Index: 262; Name: 'IsWarningAbout'; ParamType1: ptFormList),
    (Index: 263; Name: 'IsWeaponOut'),
    (Index: 264; Name: 'HasSpell'; ParamType1: ptMagicItem),
    (Index: 265; Name: 'IsTimePassing'),
    (Index: 266; Name: 'IsPleasant'; ParamType1: ptRegionOpt),
    (Index: 267; Name: 'IsCloudy'; ParamType1: ptRegionOpt),
    (Index: 274; Name: 'IsSmallBump'),
    (Index: 276; Name: 'IsInInteriorAcousticSpace'),
    (Index: 277; Name: 'GetBaseValue'; ParamType1: ptActorValue),
    (Index: 278; Name: 'IsOwner'; ParamType1: ptOwner),
    (Index: 280; Name: 'IsCellOwner'; ParamType1: ptCell; ParamType2: ptOwner),
    (Index: 282; Name: 'IsHorseStolen'),
    (Index: 285; Name: 'IsLeftUp'),
    (Index: 286; Name: 'IsSneaking'),
    (Index: 287; Name: 'IsRunning'),
    (Index: 288; Name: 'GetFriendHit'),
    (Index: 289; Name: 'IsInCombat'; ParamType1: ptInteger),
    (Index: 300; Name: 'IsInInterior'),
    (Index: 304; Name: 'IsWaterObject'),
    (Index: 305; Name: 'GetPlayerAction'),
    (Index: 306; Name: 'IsActorUsingATorch'),
    (Index: 309; Name: 'IsXBox'),
    (Index: 310; Name: 'GetInWorldspace'; ParamType1: ptWorldSpace),
    (Index: 312; Name: 'GetPCMiscStat'; ParamType1: ptMiscStat),
    (Index: 313; Name: 'GetPairedAnimation'),
    (Index: 314; Name: 'IsActorAVictim'),
    (Index: 315; Name: 'GetTotalPersuasionNumber'),
    (Index: 318; Name: 'GetIdleDoneOnce'),
    (Index: 320; Name: 'GetNoRumors'),
    (Index: 323; Name: 'GetCombatState'),
    (Index: 325; Name: 'GetWithinPackageLocation'; ParamType1: ptPackdata),
    (Index: 327; Name: 'IsRidingMount'),
    (Index: 329; Name: 'IsFleeing'),
    (Index: 332; Name: 'IsInDangerousWater'),
    (Index: 338; Name: 'GetIgnoreFriendlyHits'),
    (Index: 339; Name: 'IsPlayersLastRiddenMount'),
    (Index: 353; Name: 'IsActor'),
    (Index: 354; Name: 'IsEssential'),
    (Index: 358; Name: 'IsPlayerMovingIntoNewSpace'),
    (Index: 359; Name: 'GetInCurrentLocation'; ParamType1: ptLocation),
    (Index: 360; Name: 'GetInCurrentLocationAlias'; ParamType1: ptAlias),
    (Index: 361; Name: 'GetTimeDead'),
    (Index: 362; Name: 'HasLinkedRef'; ParamType1: ptKeyword),
    (Index: 365; Name: 'IsChild'),
    (Index: 366; Name: 'GetStolenItemValueNoCrime'; ParamType1: ptFaction),
    (Index: 367; Name: 'GetLastPlayerAction'),
    (Index: 368; Name: 'IsPlayerActionActive'; ParamType1: ptInteger),
    (Index: 370; Name: 'IsTalkingActivatorActor'; ParamType1: ptActor),
    (Index: 371; Name: 'IsOnChems'),
    (Index: 372; Name: 'IsInList'; ParamType1: ptFormList),
    (Index: 373; Name: 'GetStolenItemValue'; ParamType1: ptFaction),
    (Index: 375; Name: 'GetCrimeGoldViolent'; ParamType1: ptFactionOpt),
    (Index: 376; Name: 'GetCrimeGoldNonviolent'; ParamType1: ptFactionOpt),
    (Index: 378; Name: 'IsOwnedBy'; ParamType1: ptActor),
    (Index: 380; Name: 'GetCommandDistance'),
    (Index: 381; Name: 'GetCommandLocationDistance'),
    (Index: 390; Name: 'GetHitLocation'),
    (Index: 391; Name: 'IsPC1stPerson'),
    (Index: 396; Name: 'GetCauseofDeath'),
    (Index: 397; Name: 'IsLimbGone'; ParamType1: ptInteger),
    (Index: 398; Name: 'IsWeaponInList'; ParamType1: ptFormList),
    (Index: 402; Name: 'IsBribedbyPlayer'),
    (Index: 403; Name: 'GetRelationshipRank'; ParamType1: ptActor),
    (Index: 407; Name: 'GetVATSValue'; ParamType1: ptInteger; ParamType2: ptInteger),
    (Index: 408; Name: 'IsKiller'; ParamType1: ptActor),
    (Index: 409; Name: 'IsKillerObject'; ParamType1: ptFormList),
    (Index: 410; Name: 'GetFactionCombatReaction'; ParamType1: ptFaction; Paramtype2: ptFaction),
    (Index: 414; Name: 'Exists'; ParamType1: ptObjectReference),
    (Index: 415; Name: 'GetGroupMemberCount'),
    (Index: 416; Name: 'GetGroupTargetCount'),
    (Index: 426; Name: 'GetIsVoiceType'; ParamType1: ptVoiceType),
    (Index: 427; Name: 'GetPlantedExplosive'),
    (Index: 429; Name: 'IsScenePackageRunning'),
    (Index: 430; Name: 'GetHealthPercentage'),
    (Index: 432; Name: 'GetIsObjectType'; ParamType1: ptFormType),
    (Index: 434; Name: 'PlayerVisualDetection'),
    (Index: 435; Name: 'PlayerAudioDetection'),
    (Index: 437; Name: 'GetIsCreatureType'; ParamType1: ptInteger),
    (Index: 438; Name: 'HasKey'; ParamType1: ptObjectReference),
    (Index: 439; Name: 'IsFurnitureEntryType'; ParamType1: ptFurnitureEntry),
    (Index: 444; Name: 'GetInCurrentLocationFormList'; ParamType1: ptFormList),
    (Index: 445; Name: 'GetInZone'; ParamType1: ptEncounterZone),
    (Index: 446; Name: 'GetVelocity'; ParamType1: ptAxis),
    (Index: 447; Name: 'GetGraphVariableFloat'; ParamType1: ptString),
    (Index: 448; Name: 'HasPerk'; ParamType1: ptPerk),
    (Index: 449; Name: 'GetFactionRelation'; ParamType1: ptActor),
    (Index: 450; Name: 'IsLastIdlePlayed'; ParamType1: ptIdleForm),
    (Index: 453; Name: 'GetPlayerTeammate'),
    (Index: 454; Name: 'GetPlayerTeammateCount'),
    (Index: 458; Name: 'GetActorCrimePlayerEnemy'),
    (Index: 459; Name: 'GetCrimeGold'; ParamType1: ptFactionOpt),
    (Index: 463; Name: 'IsPlayerGrabbedRef'; ParamType1: ptObjectReference),
    (Index: 465; Name: 'GetKeywordItemCount'; ParamType1: ptKeyword),
    (Index: 470; Name: 'GetDestructionStage'),
    (Index: 473; Name: 'GetIsAlignment'; ParamType1: ptAlignment),
    (Index: 476; Name: 'IsProtected'),
    (Index: 477; Name: 'GetThreatRatio'; ParamType1: ptActor),
    (Index: 479; Name: 'GetIsUsedItemEquipType'; ParamType1: ptEquipType),
    (Index: 483; Name: 'GetPlayerActivated'),
    (Index: 485; Name: 'GetFullyEnabledActorsInHigh'),
    (Index: 487; Name: 'IsCarryable'),
    (Index: 488; Name: 'GetConcussed'),
    (Index: 491; Name: 'GetMapMarkerVisible'),
    (Index: 493; Name: 'PlayerKnows'; ParamType1: ptReferencableObject),
    (Index: 494; Name: 'GetPermanentValue'; ParamType1: ptActorValue),
    (Index: 495; Name: 'GetKillingBlowLimb'),
    (Index: 497; Name: 'CanPayCrimeGold'; ParamType1: ptFaction),
    (Index: 499; Name: 'GetDaysInJail'),
    (Index: 500; Name: 'EPAlchemyGetMakingPoison'),
    (Index: 501; Name: 'EPAlchemyEffectHasKeyword'; ParamType1: ptKeyword),
    (Index: 503; Name: 'GetAllowWorldInteractions'),
    (Index: 506; Name: 'DialogueGetAv'; ParamType1: ptActorValue),
    (Index: 507; Name: 'DialogueHasPerk'; ParamType1: ptPerk),
    (Index: 508; Name: 'GetLastHitCritical'),
    (Index: 510; Name: 'DialogueGetItemCount'; ParamType1: ptReferencableObject),
    (Index: 511; Name: 'LastCrippledCondition'; ParamType1: ptActorValue),
    (Index: 512; Name: 'HasSharedPowerGrid'; ParamType1: ptObjectReference),
    (Index: 513; Name: 'IsCombatTarget'; ParamType1: ptActor),
    (Index: 515; Name: 'GetVATSRightAreaFree'; ParamType1: ptObjectReference),
    (Index: 516; Name: 'GetVATSLeftAreaFree'; ParamType1: ptObjectReference),
    (Index: 517; Name: 'GetVATSBackAreaFree'; ParamType1: ptObjectReference),
    (Index: 518; Name: 'GetVATSFrontAreaFree'; ParamType1: ptObjectReference),
    (Index: 519; Name: 'GetIsLockBroken'),
    (Index: 520; Name: 'IsPS3'),
    (Index: 521; Name: 'IsWindowsPC'),
    (Index: 522; Name: 'GetVATSRightTargetVisible'; ParamType1: ptObjectReference),
    (Index: 523; Name: 'GetVATSLeftTargetVisible'; ParamType1: ptObjectReference),
    (Index: 524; Name: 'GetVATSBackTargetVisible'; ParamType1: ptObjectReference),
    (Index: 525; Name: 'GetVATSFrontTargetVisible'; ParamType1: ptObjectReference),
    (Index: 528; Name: 'IsInCriticalStage'; ParamType1: ptCriticalStage),
    (Index: 530; Name: 'GetXPForNextLevel'),
    (Index: 533; Name: 'GetInfamy'; ParamType1: ptFaction),
    (Index: 534; Name: 'GetInfamyViolent'; ParamType1: ptFaction),
    (Index: 535; Name: 'GetInfamyNonViolent'; ParamType1: ptFaction),
    (Index: 536; Name: 'GetTypeCommandPerforming'),
    (Index: 543; Name: 'GetQuestCompleted'; ParamType1: ptQuest),
    (Index: 544; Name: 'GetSpeechChallengeSuccessLevel'),
    (Index: 547; Name: 'IsGoreDisabled'),
    (Index: 550; Name: 'IsSceneActionComplete'; ParamType1: ptScene; ParamType2: ptInteger),
    (Index: 552; Name: 'GetSpellUsageNum'; ParamType1: ptMagicItem),
    (Index: 554; Name: 'GetActorsInHigh'),
    (Index: 555; Name: 'HasLoaded3D'),
    (Index: 560; Name: 'HasKeyword'; ParamType1: ptKeyword),
    (Index: 561; Name: 'HasRefType'; ParamType1: ptRefType),
    (Index: 562; Name: 'LocationHasKeyword'; ParamType1: ptKeyword),
    (Index: 563; Name: 'LocationHasRefType'; ParamType1: ptRefType),
    (Index: 565; Name: 'GetIsEditorLocation'; ParamType1: ptLocation),
    (Index: 566; Name: 'GetIsAliasRef'; ParamType1: ptAlias),
    (Index: 567; Name: 'GetIsEditorLocationAlias'; ParamType1: ptAlias),
    (Index: 568; Name: 'IsSprinting'),
    (Index: 569; Name: 'IsBlocking'),
    (Index: 570; Name: 'HasEquippedSpell'; ParamType1: ptCastingSource),
    (Index: 571; Name: 'GetCurrentCastingType'; ParamType1: ptCastingSource),
    (Index: 572; Name: 'GetCurrentDeliveryType'; ParamType1: ptCastingSource),
    (Index: 574; Name: 'GetAttackState'),
    (Index: 576; Name: 'GetEventData'; ParamType1: ptEvent; ParamType2: ptEventData; ParamType3: ptString), // fireundubh: Event Function, Event Member, Data (FO4)
    (Index: 577; Name: 'IsCloserToAThanB'; ParamType1: ptObjectReference; ParamType2: ptObjectReference),
    (Index: 578; Name: 'LevelMinusPCLevel'),
    (Index: 579; Name: 'EditorLocationHasKeyword'; ParamType1: ptKeyword),
    (Index: 580; Name: 'IsBleedingOut'),
    (Index: 584; Name: 'GetRelativeAngle'; ParamType1: ptObjectReference; ParamType2: ptAxis),
    (Index: 589; Name: 'GetMovementDirection'),
    (Index: 590; Name: 'IsInScene'),
    (Index: 591; Name: 'GetRefTypeDeadCount'; ParamType1: ptLocation; Paramtype2: ptRefType),
    (Index: 592; Name: 'GetRefTypeAliveCount'; ParamType1: ptLocation; Paramtype2: ptRefType),
    (Index: 594; Name: 'GetIsFlying'),
    (Index: 595; Name: 'IsCurrentSpell'; ParamType1: ptMagicItem; ParamType2: ptCastingSource),
    (Index: 596; Name: 'SpellHasKeyword'; ParamType1: ptKeyword),
    (Index: 597; Name: 'GetEquippedItemType'; ParamType1: ptCastingSource),
    (Index: 598; Name: 'GetLocationAliasCleared'; ParamType1: ptAlias),
    (Index: 600; Name: 'GetLocationAliasRefTypeDeadCount'; ParamType1: ptAlias; ParamType2: ptRefType),
    (Index: 601; Name: 'GetLocationAliasRefTypeAliveCount'; ParamType1: ptAlias; ParamType2: ptRefType),
    (Index: 602; Name: 'IsWardState'; ParamType1: ptWardState),
    (Index: 603; Name: 'IsInSameCurrentLocationAsRef'; ParamType1: ptObjectReference; ParamType2: ptKeyword),
    (Index: 604; Name: 'IsInSameCurrentLocationAsRefAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 605; Name: 'LocationAliasIsLocation'; ParamType1: ptAlias; ParamType2: ptLocation),
    (Index: 606; Name: 'GetKeywordDataForLocation'; ParamType1: ptLocation; Paramtype2: ptKeyword),
    (Index: 608; Name: 'GetKeywordDataForAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 610; Name: 'LocationAliasHasKeyword'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 611; Name: 'IsNullPackageData'; ParamType1: ptPackdata),
    (Index: 612; Name: 'GetNumericPackageData'; ParamType1: ptPackdata),
    (Index: 613; Name: 'IsPlayerRadioOn'),
    (Index: 614; Name: 'GetPlayerRadioFrequency'),
    (Index: 615; Name: 'GetHighestRelationshipRank'),
    (Index: 616; Name: 'GetLowestRelationshipRank'),
    (Index: 617; Name: 'HasAssociationTypeAny'; ParamType1: ptAssociationType),
    (Index: 618; Name: 'HasFamilyRelationshipAny'),
    (Index: 619; Name: 'GetPathingTargetOffset'; ParamType1: ptAxis),
    (Index: 620; Name: 'GetPathingTargetAngleOffset'; ParamType1: ptAxis),
    (Index: 621; Name: 'GetPathingTargetSpeed'),
    (Index: 622; Name: 'GetPathingTargetSpeedAngle'; ParamType1: ptAxis),
    (Index: 623; Name: 'GetMovementSpeed'),
    (Index: 624; Name: 'GetInContainer'; ParamType1: ptObjectReference),
    (Index: 625; Name: 'IsLocationLoaded'; ParamType1: ptLocation),
    (Index: 626; Name: 'IsLocationAliasLoaded'; ParamType1: ptAlias),
    (Index: 627; Name: 'IsDualCasting'),
    (Index: 629; Name: 'GetVMQuestVariable'; ParamType1: ptQuest; ParamType2: ptString),
    (Index: 630; Name: 'GetCombatAudioDetection'),
    (Index: 631; Name: 'GetCombatVisualDetection'),
    (Index: 632; Name: 'IsCasting'),
    (Index: 633; Name: 'GetFlyingState'),
    (Index: 635; Name: 'IsInFavorState'),
    (Index: 636; Name: 'HasTwoHandedWeaponEquipped'),
    (Index: 637; Name: 'IsFurnitureExitType'; ParamType1: ptFurnitureEntry),
    (Index: 638; Name: 'IsInFriendStatewithPlayer'),
    (Index: 639; Name: 'GetWithinDistance'; ParamType1: ptObjectReference; ParamType2: ptFloat),
    (Index: 640; Name: 'GetValuePercent'; ParamType1: ptActorValue),
    (Index: 641; Name: 'IsUnique'),
    (Index: 642; Name: 'GetLastBumpDirection'),
    (Index: 644; Name: 'GetInfoChallangeSuccess'),
    (Index: 645; Name: 'GetIsInjured'),
    (Index: 646; Name: 'GetIsCrashLandRequest'),
    (Index: 647; Name: 'GetIsHastyLandRequest'),
    (Index: 650; Name: 'IsLinkedTo'; ParamType1: ptObjectReference; ParamType2: ptKeyword),
    (Index: 651; Name: 'GetKeywordDataForCurrentLocation'; ParamType1: ptKeyword),
    (Index: 652; Name: 'GetInSharedCrimeFaction'; ParamType1: ptObjectReference),
    (Index: 654; Name: 'GetBribeSuccess'),
    (Index: 655; Name: 'GetIntimidateSuccess'),
    (Index: 656; Name: 'GetArrestedState'),
    (Index: 657; Name: 'GetArrestingActor'),
    (Index: 659; Name: 'HasVMScript'; ParamType1: ptString),
    (Index: 660; Name: 'GetVMScriptVariable'; ParamType1: ptString; ParamType2: ptString),
    (Index: 661; Name: 'GetWorkshopResourceDamage'; ParamType1: ptActorValue),
    (Index: 664; Name: 'HasValidRumorTopic'; ParamType1: ptQuest),
    (Index: 672; Name: 'IsAttacking'),
    (Index: 673; Name: 'IsPowerAttacking'),
    (Index: 674; Name: 'IsLastHostileActor'),
    (Index: 675; Name: 'GetGraphVariableInt'; ParamType1: ptString),
    (Index: 678; Name: 'ShouldAttackKill'; ParamType1: ptActor),
    (Index: 680; Name: 'GetActivationHeight'),
    (Index: 682; Name: 'WornHasKeyword'; ParamType1: ptKeyword),
    (Index: 683; Name: 'GetPathingCurrentSpeed'),
    (Index: 684; Name: 'GetPathingCurrentSpeedAngle'; ParamType1: ptAxis),
    (Index: 691; Name: 'GetWorkshopObjectCount'; ParamType1: ptReferencableObject),
    (Index: 692; Name: 'GetStrongestEnemyHasKeyword'; ParamType1: ptKeyword),
    (Index: 693; Name: 'EPMagic_SpellHasKeyword'; ParamType1: ptKeyword),
    (Index: 694; Name: 'GetNoBleedoutRecovery'),
    (Index: 696; Name: 'EPMagic_SpellHasSkill'; ParamType1: ptActorValue),
    (Index: 697; Name: 'IsAttackType'; ParamType1: ptKeyword),
    (Index: 698; Name: 'IsAllowedToFly'),
    (Index: 699; Name: 'HasMagicEffectKeyword'; ParamType1: ptKeyword),
    (Index: 700; Name: 'IsCommandedActor'),
    (Index: 701; Name: 'IsStaggered'),
    (Index: 702; Name: 'IsRecoiling'),
    (Index: 703; Name: 'HasScopeWeaponEquipped'),
    (Index: 704; Name: 'IsPathing'),
    (Index: 705; Name: 'GetShouldHelp'; ParamType1: ptActor),
    (Index: 706; Name: 'HasBoundWeaponEquipped'; ParamType1: ptCastingSource),
    (Index: 707; Name: 'GetCombatTargetHasKeyword'; ParamType1: ptKeyword),
    (Index: 709; Name: 'GetCombatGroupMemberCount'),
    (Index: 710; Name: 'IsIgnoringCombat'),
    (Index: 711; Name: 'GetLightLevel'),
    (Index: 713; Name: 'SpellHasCastingPerk'; ParamType1: ptPerk),
    (Index: 714; Name: 'IsBeingRidden'),
    (Index: 715; Name: 'IsUndead'),
    (Index: 716; Name: 'GetRealHoursPassed'),
    (Index: 718; Name: 'IsUnlockedDoor'),
    (Index: 719; Name: 'IsHostileToActor'; ParamType1: ptActor),
    (Index: 720; Name: 'GetTargetHeight'; ParamType1: ptObjectReference),
    (Index: 721; Name: 'IsPoison'),
    (Index: 722; Name: 'WornApparelHasKeywordCount'; ParamType1: ptKeyword),
    (Index: 723; Name: 'GetItemHealthPercent'),
    (Index: 724; Name: 'EffectWasDualCast'),
    (Index: 725; Name: 'GetKnockStateEnum'),
    (Index: 726; Name: 'DoesNotExist'),
    (Index: 728; Name: 'GetPlayerWalkAwayFromDialogueScene'),
    (Index: 729; Name: 'GetActorStance'),
    (Index: 730; Name: 'HasAnyMutatedTeammates'),
    (Index: 734; Name: 'CanProduceForWorkshop'),
    (Index: 735; Name: 'CanFlyHere'),
    (Index: 736; Name: 'EPIsDamageType'; ParamType1: ptDamageType),
    (Index: 737; Name: 'GetCurrentWeatherHasKeyword'; ParamType1: ptKeyword),
    (Index: 738; Name: 'GetActorGunState'),
    (Index: 739; Name: 'GetVoiceLineLength'),
    (Index: 741; Name: 'ObjectTemplateItem_HasKeyword'; ParamType1: ptKeyword),
    (Index: 742; Name: 'ObjectTemplateItem_HasUniqueKeyword'; ParamType1: ptKeyword),
    (Index: 743; Name: 'ObjectTemplateItem_GetLevel'),
    (Index: 744; Name: 'MovementIdleMatches'; ParamType1: ptInteger; ParamType2: ptInteger), // TODO: determine correct param types (2)
    (Index: 745; Name: 'GetActionData'),
    (Index: 746; Name: 'GetActionDataShort'; ParamType1: ptInteger),
    (Index: 747; Name: 'GetActionDataByte'; ParamType1: ptInteger),
    (Index: 748; Name: 'GetActionDataFlag'; ParamType1: ptInteger),
    (Index: 749; Name: 'ModdedItemHasKeyword'; ParamType1: ptKeyword),
    (Index: 750; Name: 'GetAngryWithPlayer'),
    (Index: 751; Name: 'IsCameraUnderWater'),
    (Index: 753; Name: 'IsActorRefOwner'; ParamType1: ptActor),
    (Index: 754; Name: 'HasActorRefOwner'; ParamType1: ptActor),
    (Index: 756; Name: 'GetLoadedAmmoCount'),
    (Index: 757; Name: 'IsTimeSpanSunrise'),
    (Index: 758; Name: 'IsTimeSpanMorning'),
    (Index: 759; Name: 'IsTimeSpanAfternoon'),
    (Index: 760; Name: 'IsTimeSpanEvening'),
    (Index: 761; Name: 'IsTimeSpanSunset'),
    (Index: 762; Name: 'IsTimeSpanNight'),
    (Index: 763; Name: 'IsTimeSpanMidnight'),
    (Index: 764; Name: 'IsTimeSpanAnyDay'),
    (Index: 765; Name: 'IsTimeSpanAnyNight'),
    (Index: 766; Name: 'CurrentFurnitureHasKeyword'; ParamType1: ptKeyword),
    (Index: 767; Name: 'GetWeaponEquipIndex'),
    (Index: 769; Name: 'IsOverEncumbered'),
    (Index: 770; Name: 'IsPackageRequestingBlockedIdles'),
    (Index: 771; Name: 'GetActionDataInt'),
    (Index: 772; Name: 'GetVATSRightMinusLeftAreaFree'; ParamType1: ptObjectReference),
    (Index: 773; Name: 'GetInIronSights'; ParamType1: ptObjectReference),
    (Index: 774; Name: 'GetActorStaggerDirection'),
    (Index: 775; Name: 'GetActorStaggerMagnitude'),
    (Index: 776; Name: 'WornCoversBipedSlot'; ParamType1: ptInteger),
    (Index: 777; Name: 'GetInventoryValue'),
    (Index: 778; Name: 'IsPlayerInConversation'; Desc: 'True if Player is in the current conversation'),
    (Index: 779; Name: 'IsInDialogueCamera'; Desc: 'True if in the DialogueCamera state'),
    (Index: 780; Name: 'IsMyDialogueTargetPlayer'),
    (Index: 781; Name: 'IsMyDialogueTargetActor'),
    (Index: 782; Name: 'GetMyDialogueTargetDistance'; Desc: 'True if in the DialogueCamera stat'),
    (Index: 783; Name: 'IsSeatOccupied'; Desc: 'True if the seat is occupied'; ParamType1: ptKeyword),
    (Index: 784; Name: 'IsPlayerRiding'; Desc: 'True if the player is riding the subject'),
    (Index: 785; Name: 'IsTryingEventCamera'; Desc: 'True if trying to find/play an event camera'),
    (Index: 786; Name: 'UseLeftSideCamera'; Desc: 'True if we want a left side camera'),
    (Index: 787; Name: 'GetNoteType'),
    (Index: 788; Name: 'LocationHasPlayerOwnedWorkshop'),
    (Index: 789; Name: 'IsStartingAction'),
    (Index: 790; Name: 'IsMidAction'),
    (Index: 791; Name: 'IsWeaponChargeAttack'),
    (Index: 792; Name: 'IsInWorkshopMode'),
    (Index: 793; Name: 'IsWeaponChargingHoldAttack'),
    (Index: 794; Name: 'IsEncounterAbovePlayerLevel'),
    (Index: 795; Name: 'IsMeleeAttacking'),
    (Index: 796; Name: 'GetVATSQueuedTargetsUnique'),
    (Index: 797; Name: 'GetCurrentLocationCleared'),
    (Index: 798; Name: 'IsPowered'),
    (Index: 799; Name: 'GetTransmitterDistance'),
    (Index: 800; Name: 'GetCameraPlaybackTime'),
    (Index: 801; Name: 'IsInWater'),
    (Index: 802; Name: 'GetWithinActivateDistance'; ParamType1: ptObjectReference),
    (Index: 803; Name: 'IsUnderWater'),
    (Index: 804; Name: 'IsInSameSpace'; ParamType1: ptObjectReference),
    (Index: 805; Name: 'LocationAllowsReset'),
    (Index: 806; Name: 'GetVATSBackRightAreaFree'; ParamType1: ptObjectReference),
    (Index: 807; Name: 'GetVATSBackLeftAreaFree'; ParamType1: ptObjectReference),
    (Index: 808; Name: 'GetVATSBackRightTargetVisible'; ParamType1: ptObjectReference),
    (Index: 809; Name: 'GetVATSBackLeftTargetVisible'; ParamType1: ptObjectReference),
    (Index: 810; Name: 'GetVATSTargetLimbVisible'; ParamType1: ptObjectReference),
    (Index: 811; Name: 'IsPlayerListening'; ParamType1: ptFloat),
    (Index: 812; Name: 'GetPathingRequestedQuickTurn'),
    (Index: 813; Name: 'EPIsCalculatingBaseDamage'),
    (Index: 814; Name: 'GetReanimating'),
    (Index: 817; Name: 'IsInRobotWorkbench'),
    (Index: 818; Name: 'IsActorsTurfActive'; Desc: 'True if this actor''s EMS turf is active'),
    (Index: 828; Name: 'GetIsPlayer'),
    (Index: 832; Name: 'GetStageUniqueQuest'; Desc: 'Get the stage of the a unique quest instance'; ParamType1: ptQuest),
    (Index: 833; Name: 'GetStageDoneUniqueQuest'; Desc: 'Get the stage done of a unique quest instance'; ParamType1: ptQuest; ParamType2: ptQuestStage),
    (Index: 834; Name: 'GetVMQuestVariableUnique'; ParamType1: ptQuest; ParamType2: ptString),
    (Index: 835; Name: 'IsWorkshopOwner'; ParamType1: ptObjectReference),
    (Index: 836; Name: 'IsWorkshopClaimant'; ParamType1: ptObjectReference),
    (Index: 837; Name: 'IsActivePlayer'; Desc: 'Test if player is in current quest instance''s active array'),
    (Index: 839; Name: 'IsMemberOfAPlayerTeam'; Desc: 'Test if player is in a player team'),
    (Index: 840; Name: 'IsWaterConsumeSpell'; Desc: 'Test if a spell is the consume spell for a water object'; ParamType1: ptMagicItem), //off_1443EAFC0
    (Index: 841; Name: 'IsWaterContactSpell'; Desc: 'Test if a spell is the contact spell for a water object'; ParamType1: ptMagicItem),
    (Index: 842; Name: 'IsPlayerInFriendlyWorkshop'; Desc: 'Test if a player is inside a friendly workshop or camp'),
    (Index: 843; Name: 'GetJunkItemCount'; Desc: 'Get the number of junk items in the refrs inventory'),
    (Index: 844; Name: 'GetIsCurrentLocationExact'; ParamType1: ptLocation),
    (Index: 845; Name: 'GetIsEditorLocationExact'; ParamType1: ptLocation),
    (Index: 846; Name: 'GetActorValueForCurrentLocation'; ParamType1: ptActorValue; ParamType2: ptKeyword),
    (Index: 849; Name: 'GetIsInRegion'; ParamType1: ptRegion),
    (Index: 850; Name: 'GetInAcousticSpace'; ParamType1: ptAcousticSpace),
    (Index: 851; Name: 'IsPowerArmorOwner'; Desc: 'Check if a Power Armor furniture reference is owned by player'),
    (Index: 852; Name: 'GetCurrency'; ParamType1: ptCurrency),
    (Index: 853; Name: 'HasLearnedRecipe'; Desc: 'Check if the player has learned the given recipe'; ParamType1: ptConstructibleObject),
    (Index: 854; Name: 'HasActiveMagicEffect'; ParamType1: ptMagicEffect),
    (Index: 855; Name: 'HasBeenSearched'; Desc: 'Check if the refrs container has been searched'),
    (Index: 856; Name: 'GetQuestRunningUnique'; ParamType1: ptQuest),
    (Index: 857; Name: 'GetNumTimesCompletedQuest'; ParamType1: ptQuest),
    (Index: 858; Name: 'WorkshopOwnerHasPerk'; Desc: 'Check if the refs workshop owner has a perk'; ParamType1: ptPerk),
    (Index: 859; Name: 'HasEntitlement'; Desc: 'Check if the player has the specified premium entitlement'; ParamType1: ptEntitlement),
    (Index: 860; Name: 'IsQuickplayer'; Desc: 'Test if player is a quickplayer'),
    (Index: 861; Name: 'IsVisitor'; Desc: 'Test if player is a visitor'),
    (Index: 862; Name: 'IsInWorkshop'; Desc: 'Test if a ref is inside the closest workshop boundaries'),
    (Index: 863; Name: 'IsInWorkshopOwned'; Desc: 'Test if a ref is inside the closest workshop boundaries owned by passed player or teammate'; ParamType1: ptObjectReference),
    (Index: 864; Name: 'IsJunkItem'; Desc: 'Test if an item is considered junk'),
    (Index: 865; Name: 'IsInWeather'; Desc: 'Test if a ref is in a given weather'; ParamType1: ptWeather),
    (Index: 867; Name: 'GetQuickplayModeLoadingInto'; Desc: 'Gets the quickplay mode on the client the player is loading into'),
    (Index: 868; Name: 'IsInitiatingFastTravel'),
    (Index: 869; Name: 'GetQuickplayKeywordLoadingInto'; Desc: 'Gets the quickplay keyword on the client the player is loading into'; ParamType1: ptKeyword),
    (Index: 870; Name: 'GetNumActiveEffectsWithKeyword'; ParamType1: ptKeyword),
    (Index: 871; Name: 'GetNumActiveSpellsWithKeyword'; ParamType1: ptKeyword),
    (Index: 872; Name: 'GatLastHitHealthDamageAmount'),
    (Index: 873; Name: 'GatLastHitTotalDamageAmount'),
    (Index: 874; Name: 'GatLastHitDamageSourceType'),
    (Index: 875; Name: 'IsTrueForConditionForm'; ParamType1: ptConditionForm),
    (Index: 876; Name: 'IsActiveQuest'; Desc: 'Test if the quest scope matches the provided quest'; ParamType1: ptQuest),
    (Index: 877; Name: 'IsFullHealth'),
    (Index: 878; Name: 'CHAL_IsTargetWeaponMelee'),
    (Index: 879; Name: 'CHAL_IsTargetWeaponRanged'),
    (Index: 880; Name: 'CHAL_IsTargetWeaponThrown'),
    (Index: 881; Name: 'CHAL_GetTargetWeaponDamageType'; ParamType1: ptDamageType),
    (Index: 882; Name: 'CHAL_DoesTargetWeaponHaveKeyword'; ParamType1: ptKeyword),
    (Index: 884; Name: 'CHAL_IsTargetWorkshopRecipeInCategory'; ParamType1: ptKeyword),
    (Index: 885; Name: 'GetLastFallDamage'),
    (Index: 886; Name: 'IsPlayerInCamp'),
    (Index: 887; Name: 'GetLastHitLethal'),
    (Index: 888; Name: 'IsPlayerTeammate'),
    (Index: 889; Name: 'IsPlayerCombatOpponent'),
    (Index: 890; Name: 'HasPerkCardEquipped'; ParamType1: ptPerkCard; ParamType2: ptInteger),
    (Index: 891; Name: 'HasPerkCardFromListEquipped'; ParamType1: ptFormList),
    (Index: 892; Name: 'GetLastCompletedCheckpointStage'),
    (Index: 893; Name: 'IsPreviousMeleeAttackEvent'; ParamType1: ptAttackData), //Has data that I still need to figure out
    (Index: 894; Name: 'HasCompletedCheckpointStage'; ParamType1: ptQuestStage),
    (Index: 895; Name: 'DoesRecipeContainObject'; ParamType1: ptReferencableObject),
    (Index: 896; Name: 'IsDailyCooldownExpired'; ParamType1: ptActorValue),
    (Index: 897; Name: 'GetRandomUInt'; Desc: 'Get a random unsigned integer between Param1 and Param2'; ParamType1: ptInteger; ParamType2: ptInteger),
    (Index: 898; Name: 'GetWorldType'; Desc: 'Gets the integer identifier for world type'),
    (Index: 899; Name: 'IsEngagedInPvP'),
    (Index: 900; Name: 'IsAggresive'),
    (Index: 901; Name: 'IsInWorkshopPublic'),
    (Index: 902; Name: 'IsPlayerInCampOwned'),
    (Index: 903; Name: 'IsPlayerInCampTeam'),
    (Index: 904; Name: 'CHAL_IsTargetWorkshopRecipe'; ParamType1: ptConstructibleObject),
    (Index: 905; Name: 'DoesModApplyKeyword'; ParamType1: ptKeyword),
    (Index: 906; Name: 'HasCompletedChallenge'; ParamType1: ptChallenge),
    (Index: 907; Name: 'GetNumElementsInRefCollection'; Desc: 'Gets the number of elements in a ref collection'; ParamType1: ptAlias),
    (Index: 908; Name: 'IsTeamLeader'; Desc: 'Test if player is in a leader of a team (or not on a team).'),
    (Index: 909; Name: 'ActorPackageHasRandomConversationsFlagOn'; Desc: 'Is this ref allowed random conversation'),
    (Index: 910; Name: 'IsInInstancedLocation'; Desc: 'Is this ref in an instanced location?'),
    (Index: 911; Name: 'IsInstanceOwner'; Desc: 'Is this player an owner of the given ref''s instanced location?'; ParamType1: ptReferencableObject),
    (Index: 914; Name: 'IsQuestTracked'; Desc: 'Does the player have the given base quest tracked?'; ParamType1: ptQuest),
    (Index: 915; Name: 'IsPlayerFO1Member'; Desc: 'Is the selected player a FO1 Member?'),
    (Index: 916; Name: 'IsServerOverEWSActorBudget'; Desc: 'Is the server over the actor budget used by the EWS?'),
    (Index: 917; Name: 'GetStageDonePlayerInstance'; Desc: 'Get if the stage is done on a player''s quest instance'; ParamType1: ptQuest; ParamType2: ptQuestStage),
    (Index: 918; Name: 'IsAuthoritativeOverMovement'; Desc: 'Returns true if the refr is authoritative over it''s movement'),
    (Index: 919; Name: 'IsWeaponMinChargeTimeElapsed'; Desc: 'Returns true if the current weapon''s min charge time has elapsed'),
    (Index: 920; Name: 'IsOccupiedFurnitureRef'; ParamType1: ptObjectReference),
    (Index: 921; Name: 'IsOccupiedFurnitureObj'; ParamType1: ptFurniture),
    (Index: 922; Name: 'GetTeammateBondScore'),
    (Index: 923; Name: 'GetTeamType'),
    (Index: 924; Name: 'GetNumPlayersInSameInterior'),
    (Index: 925; Name: 'GetQuestFormType'),
    (Index: 926; Name: 'GetPlayerSeasonRank'),
    (Index: 927; Name: 'IsInWorkshopFreeCameraMode'),
    (Index: 928; Name: 'IsVendor'),
    (Index: 929; Name: 'GetLanguage'),
    (Index: 930; Name: 'IsNextClipLastShot'),
    (Index: 931; Name: 'WornInOrOutOfPowerArmorHasKeyword'; ParamType1: ptKeyword),
    (Index: 932; Name: 'IsPlayerInBestBuildCamp'),
    (Index: 5000; Name: 'IsInAirOrFloating'; Desc: 'Is the Havok state InAir or IsFloating?'),
    (Index: 5001; Name: 'GetIsForm'),
    (Index: 5002; Name: 'GetIsInDailyOps'),
    (Index: 5003; Name: 'GetRadsHealthPercentage'),
    (Index: 5004; Name: 'PlayerHasQuest'; ParamType1: ptQuest),
    (Index: 5005; Name: 'IsBackpackVisible'),
    (Index: 5006; Name: 'GetIsInExpedition'),
    (Index: 6000; Name: 'GetSecondsSinceLastAttack'),
    (Index: 8000; Name: 'IsDailyContentAvailable'), //Param1: ptDailyContentGroup
    (Index: 8001; Name: 'StartDailyContent'),   //Param1: ptDailyContentGroup //Does nothing on the client
    (Index: 8002; Name: 'GetRemainingQuestTimeSeconds'),
    (Index: 8003; Name: 'IsCaravanAvailable'; ParamType1: ptFormList),
    (Index: 9000; Name: 'RemoveAchievement'; ParamType1: ptInteger),
    (Index: 9001; Name: 'IsPlayerInShelterOwned'),
    (Index: 9002; Name: 'IsPlayerInShelter'),
    (Index: 9003; Name: 'IsInShelterLocation'; Desc: 'Is this ref in a shelter location?'),
    (Index: 9004; Name: 'StopAllPublicEvents'),    //Does nothing on the client
    (Index: 9005; Name: 'IsFalloutWorlds'; Desc: 'Are we on a Fallout World?'),
    (Index: 10000; Name: 'IsChallengeTypeDaily'; Desc: 'Is the target challenge a Daily challenge?'),
    (Index: 10001; Name: 'IsChallengeTypeWeekly'; Desc: 'Is the target challenge a Weekly challenge?'),
    (Index: 10002; Name: 'IsChallengeTypeLifetime'; Desc: 'Is the target challenge a Lifetime challenge?'),
    (Index: 10003; Name: 'IsStealthed'),
    (Index: 10004; Name: 'HasExpeditionInProgress'),
    (Index: 10005; Name: 'IsExpeditionInProgress'; ParamType1: ptQuest),
    (Index: 10006; Name: 'AbandonExpedition'),     //Does nothing on the client
    (Index: 10007; Name: 'StartExpedition'; ParamType1: ptQuest),    //Does nothing on the client
    (Index: 10008; Name: 'GetExpeditionsInstanceNumOptbjectivesCompleted'),
    (Index: 10009; Name: 'ResetExpedition'; ParamType1: ptQuest),    //Does nothing on the client
    (Index: 10010; Name: 'StartNewExpedition'; ParamType1: ptQuest),    //Does nothing on the client
    (Index: 10011; Name: 'ResumeExpedition'; ParamType1: ptQuest),    //Does nothing on the client
    (Index: 10012; Name: 'JoinExpedition'),    //Does nothing on the client
    (Index: 10013; Name: 'GetPublicEventHasMutation'; ParamType1: ptSpell),
    (Index: 10014; Name: 'IsUsingAltCurveTable'),
    (Index: 12000; Name: 'IsFOWPersonalEWSEnabled'; Desc: 'Is the personal EWS enabled?')
  );

var
  wbCTDAFunctionEditInfo: string;

function wbCTDAParamDescFromIndex(aIndex: Integer): PCTDAFunction;
var
  L, H, I, C: Integer;
begin
  Result := nil;

  L := Low(wbCTDAFunctions);
  H := High(wbCTDAFunctions);

  while L <= H do begin
    I := (L + H) shr 1;
    C := CmpW32(wbCTDAFunctions[I].Index, aIndex);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        L := I;
        Result := @wbCTDAFunctions[L];
      end;
    end;
  end;
end;

function wbCTDACompValueDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  // "use global" flag
  if Integer(Container.ElementByName['Type'].NativeValue) and $04 <> 0 then
    Result := 1;
end;

function wbCTDAParam1Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Desc: PCTDAFunction;
  Container: IwbContainer;
  ParamFlag: Byte;
  ParamType: TCTDAFunctionParamType;
  MainRecord: IwbMainRecord;
  GroupRecord: IwbGroupRecord;
  Element    : IwbElement;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Desc := wbCTDAParamDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if not Assigned(Desc) then
    Exit;

  if (Desc.Index = 59 {GetStageDone}) {and (Container.ElementByName['Run On'].EditValue = 'Subject')} then begin
    MainRecord := aElement.ContainingMainRecord;
    if Assigned(MainRecord) then begin

      Element := nil;
      if (MainRecord.Signature = ACTI) or (MainRecord.Signature = TACT) then
        Element := MainRecord.ElementBySignature[QSTI]
      else if MainRecord.Signature = SCEN then
        Element := MainRecord.ElementBySignature[PNAM]
      else if (MainRecord.Signature = PACK) or (MainRecord.Signature = TERM) then
        Element := MainRecord.ElementBySignature[QNAM]
      else if (MainRecord.Signature = INFO) then begin
        // get DIAL for INFO
        if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
          if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then
            if MainRecord.Signature = DIAL then
              Element := MainRecord.ElementBySignature[QNAM];
      end;

      if Assigned(Element) then
        Supports(Element.LinksTo, IwbMainRecord, MainRecord);

      if Assigned(MainRecord) and (MainRecord.Signature = QUST) then begin
        ParamType := ptQuestStage;
        Exit(Succ(Integer(ParamType)));
      end;
    end;
  end;

  ParamType := Desc.ParamType1;
  ParamFlag := Container.ElementByName['Type'].NativeValue;

  if ParamType in [ptObjectReference, ptActor, ptPackage] then begin
    if ParamFlag and $02 > 0 then begin
      // except for this func when Run On = Quest Alias, then alias is param3 and package is param1
      // [INFO:00020D3C]
      if not ((Container.ElementByName['Run On'].NativeValue = 5) and (Desc.Name = 'GetIsCurrentPackage')) then
        ParamType := ptAlias    {>>> 'use aliases' is set <<<}
    end
    else if ParamFlag and $08 > 0 then
      ParamType := ptPackdata;  {>>> 'use packdata' is set <<<}
  end;

  Result := Succ(Integer(ParamType));
end;

function wbCTDAParam2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Desc: PCTDAFunction;
  Container: IwbContainer;
  ParamFlag: Byte;
  ParamType: TCTDAFunctionParamType;
  MainRecord: IwbMainRecord;
  GroupRecord: IwbGroupRecord;
  Element    : IwbElement;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Desc := wbCTDAParamDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if not Assigned(Desc) then
    Exit;

  if (Desc.Index = 59 {GetStageDone}) {and (Container.ElementByName['Run On'].EditValue = 'Subject')} then begin
    MainRecord := aElement.ContainingMainRecord;
    if Assigned(MainRecord) then begin

      Element := nil;
      if (MainRecord.Signature = ACTI) or (MainRecord.Signature = TACT) then
        Element := MainRecord.ElementBySignature[QSTI]
      else if MainRecord.Signature = SCEN then
        Element := MainRecord.ElementBySignature[PNAM]
      else if (MainRecord.Signature = PACK) or (MainRecord.Signature = TERM) then
        Element := MainRecord.ElementBySignature[QNAM]
      else if (MainRecord.Signature = INFO) then begin
        // get DIAL for INFO
        if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
          if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then
            if MainRecord.Signature = DIAL then
              Element := MainRecord.ElementBySignature[QNAM];
      end;

      if Assigned(Element) then
        Supports(Element.LinksTo, IwbMainRecord, MainRecord);

      if Assigned(MainRecord) and (MainRecord.Signature = QUST) then begin
        ParamType := ptNone;
        Exit(Succ(Integer(ParamType)));
      end;
    end;
  end;

  ParamType := Desc.ParamType2;
  ParamFlag := Container.ElementByName['Type'].NativeValue;

  if ParamType in [ptObjectReference, ptActor, ptPackage] then begin
    if ParamFlag and $02 > 0 then ParamType := ptAlias else {>>> 'use aliases' is set <<<}
    if ParamFlag and $08 > 0 then ParamType := ptPackdata;  {>>> 'use packdata' is set <<<}
  end;

  Result := Succ(Integer(ParamType));
end;

function wbCTDAParam2VATSValueParamDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Result := Container.ElementByName['Parameter #1'].NativeValue;
end;

function wbCTDAFunctionToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Desc : PCTDAFunction;
  i    : Integer;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: begin
      Desc := wbCTDAParamDescFromIndex(aInt);
      if Assigned(Desc) then
        Result := Desc.Name
      else if aType in [ctToSummary, ctToEditValue] then
        Result := aInt.ToString
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctCheck: begin
      Desc := wbCTDAParamDescFromIndex(aInt);
      if Assigned(Desc) then
        Result := ''
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctEditType:
      Result := 'ComboBox';
    ctEditInfo: begin
      Result := wbCTDAFunctionEditInfo;
      if Result = '' then begin
        with TStringList.Create do try
          for i := Low(wbCTDAFunctions) to High(wbCTDAFunctions) do
            Add(wbCTDAFunctions[i].Name);
          Sort;
          Result := CommaText;
        finally
          Free;
        end;
        wbCTDAFunctionEditInfo := Result;
      end;
    end;
  end;
end;

function wbCTDAFunctionToInt(const aString: string; const aElement: IwbElement): Int64;
var
  i: Integer;
begin
  for i := Low(wbCTDAFunctions) to High(wbCTDAFunctions) do
    with wbCTDAFunctions[i] do
      if SameText(Name, aString) then begin
        Result := Index;
        Exit;
      end;

  Result := StrToInt64(aString);
end;

function wbMESGTNAMDontShow(const aElement: IwbElement): Boolean;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  Result := False;
  if not Supports(aElement, IwbMainRecord, MainRecord) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if Integer(Container.ElementNativeValues['DNAM']) and 1 <> 0 then
    Result := True;
end;

function wbEPFDDontShow(const aElement: IwbElement): Boolean;
var
  Container: IwbContainerElementRef;
begin
  Result := False;
  if aElement.Name <> 'Entry Point Function Parameters' then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if not (Integer(Container.ElementNativeValues['EPFT']) in [1..3]) then
    Result := True;
end;

function wbTES4ONAMDontShow(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  if not Assigned(aElement) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not MainRecord.IsESM then
    Result := True;
end;

function wbEPF2DontShow(const aElement: IwbElement): Boolean;
var
  Container: IwbContainerElementRef;
begin
  Result := False;
  if aElement.Name <> 'Entry Point Function Parameters' then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if not (Integer(Container.ElementNativeValues['EPFT']) in [4]) then
    Result := True;
end;

procedure wbDOBJObjectsAfterLoad(const aElement: IwbElement);
var
  ObjectsContainer : IwbContainerElementRef;
  i                : Integer;
  ObjectContainer  : IwbContainerElementRef;
begin
  if wbBeginInternalEdit then try

    if not Supports(aElement, IwbContainerElementRef, ObjectsContainer) then
      Exit;

    for i := Pred(ObjectsContainer.ElementCount) downto 0 do
      if Supports(ObjectsContainer.Elements[i], IwbContainerElementRef, ObjectContainer) then
        if ObjectContainer.ElementNativeValues['Use'] = 0 then
          ObjectsContainer.RemoveElement(i, True);
  finally
    wbEndInternalEdit;
  end;
end;

function wbActorTemplateUseTraits(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000001) <> 0;
end;

function wbActorTemplateUseStats(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000002) <> 0;
end;

function wbActorAutoCalcDontShow(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Flags'];
  Result := (i and $00000010) <> 0;
end;

function wbActorTemplateUseStatsAutoCalc(const aElement: IwbElement): Boolean;
begin
  Result := wbActorTemplateUseStats(aElement) or wbActorAutoCalcDontShow(aElement);
end;

function wbActorTemplateUseFactions(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000004) <> 0;
end;

function wbActorTemplateUseActorEffectList(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000008) <> 0;
end;

function wbActorTemplateUseAIData(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000010) <> 0;
end;

function wbActorTemplateUseAIPackages(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000020) <> 0;
end;

function wbActorTemplateUseModelAnimation(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000040) <> 0;
end;

function wbActorTemplateUseBaseData(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000080) <> 0;
end;

function wbActorTemplateUseInventory(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000100) <> 0;
end;

function wbActorTemplateUseScript(const aElement: IwbElement): Boolean;
var
  Element    : IwbElement;
  MainRecord : IwbMainRecord;
  i          : Int64;
begin
  Result := False;
  Element := aElement;
  MainRecord := nil;

  while Assigned(Element) and not Supports(Element, IwbMainRecord, MainRecord) do
    Element := Element.Container;

  if not Assigned(MainRecord) then
    Exit;

  i := MainRecord.ElementNativeValues['ACBS\Template Flags'];
  Result := (i and $00000200) <> 0;
end;

function wbActorTemplatesUseTemplate0(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 0 and 1) = 0;
end;

function wbActorTemplatesUseTemplate1(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 1 and 1) = 0;
end;

function wbActorTemplatesUseTemplate2(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 2 and 1) = 0;
end;

function wbActorTemplatesUseTemplate3(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 3 and 1) = 0;
end;

function wbActorTemplatesUseTemplate4(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 4 and 1) = 0;
end;

function wbActorTemplatesUseTemplate5(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 5 and 1) = 0;
end;

function wbActorTemplatesUseTemplate6(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 6 and 1) = 0;
end;

function wbActorTemplatesUseTemplate7(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 7 and 1) = 0;
end;

function wbActorTemplatesUseTemplate8(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 8 and 1) = 0;
end;

function wbActorTemplatesUseTemplate9(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 9 and 1) = 0;
end;

function wbActorTemplatesUseTemplate10(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 10 and 1) = 0;
end;

function wbActorTemplatesUseTemplate11(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 11 and 1) = 0;
end;

function wbActorTemplatesUseTemplate12(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 12 and 1) = 0;
end;

function wbActorTemplatesUseTemplate13(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;
  Result := (Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) shr 13 and 1) = 0;
end;

function wbActorTemplatesUseTemplateAny(const aElement: IwbElement): Boolean;
var
  MainRecord : IwbMainRecord;
begin
  Result := False;
  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;
  Result := Cardinal(MainRecord.ElementNativeValues['ACBS\Use Template Actors']) = 0;
end;

procedure wbReplaceBODTwithBOD2(const aElement: IwbElement);
var
  MainRecord    : IwbMainRecord;
  ContainerBOD2 : IwbContainerElementRef;
  ContainerBODT : IwbContainerElementRef;
begin
  Exit; {>>> Looks like causes problems with Dawnguard.esm <<<}

  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    if not Supports(MainRecord.ElementBySignature[BODT], IwbContainerElementRef, ContainerBODT) then
      Exit;

    if not Supports(MainRecord.Add('BOD2', True), IwbContainerElementRef, ContainerBOD2) then
      Exit;

    ContainerBOD2.ElementNativeValues['First Person Flags'] := ContainerBODT.ElementNativeValues['First Person Flags'];
    ContainerBOD2.ElementNativeValues['Armor Type'] := ContainerBODT.ElementNativeValues['Armor Type'];
    MainRecord.RemoveElement(BODT);
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbARMOAfterLoad(const aElement: IwbElement);
begin
  wbReplaceBODTwithBOD2(aElement);
end;

procedure wbARMAAfterLoad(const aElement: IwbElement);
{var
  MainRecord    : IwbMainRecord;}
begin
  wbReplaceBODTwithBOD2(aElement);
  {if wbBeginInternalEdit then try
    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;
    if MainRecord.ElementNativeValues['DNAM\Weight slider - Male'] = 0 then
      MainRecord.ElementNativeValues['DNAM\Weight slider - Male'] := 2;
    if MainRecord.ElementNativeValues['DNAM\Weight slider - Female'] = 0 then
      MainRecord.ElementNativeValues['DNAM\Weight slider - Female'] := 2;
  finally
    wbEndInternalEdit;
  end;}
end;

procedure wbCheckMorphKeyOrder(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Master     : IwbMainRecord;
  MasterContainer : IwbContainerElementRef;
  lKeys       : IwbContainerElementRef;
  lMasterKeys : IwbContainerElementRef;
  lValues     : IwbContainerElementRef;
  i, j, k    : Integer;
  NeedsSort  : Boolean;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    Master := MainRecord.Master;
    if not Assigned(Master) then
      Exit;

    if not Supports(Master, IwbContainerElementRef, MasterContainer) then
      Exit;

    if not Supports(Container.ElementBySignature['MSDK'], IwbContainerElementRef, lKeys) then
      Exit;

    if not Supports(MasterContainer.ElementBySignature['MSDK'], IwbContainerElementRef, lMasterKeys) then
      Exit;

    if lKeys.ElementCount < lMasterKeys.ElementCount then
      Exit;

    if not Supports(Container.ElementBySignature['MSDV'], IwbContainerElementRef, lValues) then
      Exit;

    if lKeys.ElementCount <> lValues.ElementCount then
      Exit;

    with TStringList.Create do try
      for i := 0 to Pred(lMasterKeys.ElementCount) do
        AddObject(lMasterKeys.Elements[i].SortKey[True], Pointer(i));
      Sorted := True;

      NeedsSort := False;
      j := lMasterKeys.ElementCount;
      for i := 0 to Pred(lKeys.ElementCount) do
        if Find(lKeys.Elements[i].SortKey[True], k) then begin
          k := Integer(Objects[k]);
          if k <> i then
            NeedsSort := True;
          lKeys.Elements[i].SortOrder := k;
          lValues.Elements[i].SortOrder := k;
        end else begin
          lKeys.Elements[i].SortOrder := j;
          lValues.Elements[i].SortOrder := j;
          Inc(j);
        end;

      if not NeedsSort then
        Exit;

      if j <> lKeys.ElementCount then
        Exit;

      lKeys.SortBySortOrder;
      lValues.SortBySortOrder;
    finally
      Free;
    end;
  finally
    wbEndInternalEdit;
  end;
end;


procedure wbNPCAfterLoad(const aElement: IwbElement);
begin
  wbCheckMorphKeyOrder(aElement);
end;

procedure wbREFRAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Container.ElementExists['XLOC'] then
      Exit;

    if Container.ElementNativeValues['XLOC - Lock Data\Level'] = 0 then
      Container.ElementNativeValues['XLOC - Lock Data\Level'] := 1;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbWEAPAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Flags      : Cardinal;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    if MainRecord.IsDeleted then
      Exit;

    // clear IronSights flags which are randomly assigned in CK
    if not Container.ElementExists['DNAM'] then
      Exit;

    Flags := Container.ElementNativeValues['DNAM - Data\Flags'];
    Flags := Flags and ($FFFF xor $0040);
    Container.ElementNativeValues['DNAM - Data\Flags'] := Flags;

    Flags := Container.ElementNativeValues['DNAM - Data\Flags2'];
    Flags := Flags and ($FFFFFFFF xor $0100);
    Container.ElementNativeValues['DNAM - Data\Flags2'] := Flags;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbCELLXCLWGetConflictPriority(const aElement: IwbElement; var aCP: TwbConflictPriority);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  DataRec    : IwbElement;
  Flags      : Cardinal;
begin
  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  if Container.ElementCount < 1 then
    Exit;

  if not Supports(Container, IwbMainRecord, MainRecord) then
    Exit;

  if MainRecord.IsDeleted then
    Exit;

  DataRec := MainRecord.ElementBySignature[DATA];
  if not Assigned(DataRec) then
    Exit;

  Flags := DataRec.NativeValue;

  {0x0001 Is Interior Cell}
  if (Flags and 1) = 1 then
    {Interior cells don't use water level in Skyrim at all}
    aCP := cpIgnore;
end;

procedure wbCELLDATAAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
begin
  if not Assigned(aElement) then
    Exit;

  Container := aElement.Container;

  while Assigned(Container) and not (Container.Def.DefType = dtRecord) do
    Container := Container.Container;

  if Assigned(Container) then
    Container.ResetConflict;
end;

procedure wbCELLAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
//  Container2   : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  DataSubRec   : IwbSubrecord;
  Flags        : Byte;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if Supports(Container.ElementBySignature['DATA'] , IwbSubRecord, DataSubRec) then begin
      // expand itU8 flags to itU16
      if DataSubRec.SubRecordHeaderSize = 1 then begin
        Flags := PByte(DataSubRec.DataBasePtr)^;
        DataSubRec.SetToDefault;
        DataSubRec.NativeValue := Flags;
      end;
      // 'Default' water height for exterior cells if not set (so water height will be taken from WRLD by game)
      if (not Container.ElementExists['XCLW']) and ((Integer(DataSubRec.NativeValue) and $02) <> 0) then begin
        Container.Add('XCLW', True);
        Container.ElementEditValues['XCLW'] := 'Default';
      end;
    end;

    // Min (-0 as in CK) water height is set to 0 when saving in CK
    if Container.ElementEditValues['XCLW'] = 'Min' then
      Container.ElementEditValues['XCLW'] := '0.0';

//    if Supports(Container.ElementBySignature[XCLR], IwbContainerElementRef, Container2) then begin
//      for i := Pred(Container2.ElementCount) downto 0 do
//        if not Supports(Container2.Elements[i].LinksTo, IwbMainRecord, MainRecord) or (MainRecord.Signature <> 'REGN') then
//          Container2.RemoveElement(i);
//      if Container2.ElementCount < 1 then
//        Container2.Remove;
//    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbMESGAfterLoad(const aElement: IwbElement);
var
  Container    : IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
  IsMessageBox : Boolean;
  HasTimeDelay : Boolean;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    IsMessageBox := (Integer(Container.ElementNativeValues['DNAM']) and 1) = 1;
    HasTimeDelay := Container.ElementExists['TNAM'];

    if not (IsMessageBox = HasTimeDelay) then
      Exit;

    if IsMessageBox then
      Container.RemoveElement('TNAM')
    else begin
      if not Container.ElementExists['DNAM'] then
        Container.Add('DNAM', True);
      Container.ElementNativeValues['DNAM'] := Integer(Container.ElementNativeValues['DNAM']) or 1;
    end;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbLIGHAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainerElementRef;
  MainRecord   : IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not wbTryGetContainerWithValidMainRecord(aElement, Container, MainRecord) then
      Exit;

    if not Container.ElementExists['FNAM'] then begin
      Container.Add('FNAM', True);
      Container.ElementNativeValues['FNAM'] := 1.0;
    end;

    if not Container.ElementExists['DATA'] then
      Exit;

    if SameValue(Container.ElementNativeValues['DATA\Falloff Exponent'], 0.0) then
      Container.ElementNativeValues['DATA\Falloff Exponent'] := 1.0;

    if SameValue(Container.ElementNativeValues['DATA\FOV'], 0.0) then
      Container.ElementNativeValues['DATA\FOV'] := 90.0;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbEFITAfterLoad(const aElement: IwbElement);
var
  Container : IwbContainerElementRef;
  Element   : IwbElement;
  ActorValue: Variant;
  MainRecord: IwbMainRecord;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    MainRecord := Container.ContainingMainRecord;
    if not Assigned(MainRecord) or MainRecord.IsDeleted then
      Exit;

    Element := Container.ElementByPath['..\EFID'];
    if not wbTryGetMainRecord(Element, MainRecord, 'MGEF') then
      Exit;

    ActorValue := MainRecord.ElementNativeValues['DATA - Data\Actor Value'];
    if VarIsNull(ActorValue) or VarIsClear(ActorValue) then
      Exit;

    if VarCompareValue(ActorValue, Container.ElementNativeValues['Actor Value']) <> vrEqual then
      Container.ElementNativeValues['Actor Value'] := ActorValue;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbRPLDAfterLoad(const aElement: IwbElement);
var
  Container: IwbContainer;
  a, b: Single;
  NeedsFlip: Boolean;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainer, Container) then
      Exit;

    NeedsFlip := False;

    if Container.ElementCount > 1 then begin
      a := StrToFloat((Container.Elements[0] as IwbContainer).Elements[0].Value);
      b := StrToFloat((Container.Elements[Pred(Container.ElementCount)] as IwbContainer).Elements[0].Value);

      case CompareValue(a, b) of
        EqualsValue: begin
          a := StrToFloat((Container.Elements[0] as IwbContainer).Elements[1].Value);
          b := StrToFloat((Container.Elements[Pred(Container.ElementCount)] as IwbContainer).Elements[1].Value);
          NeedsFlip := CompareValue(a, b) = GreaterThanValue;
        end;
        GreaterThanValue:
          NeedsFlip := True;
      end;
    end;

    if NeedsFlip then
      Container.ReverseElements;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbLLEAfterLoad(const aElement: IwbElement);
var
  Container  : IwbContainerElementRef;
  Entries    : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  i          : integer;
begin
  if wbBeginInternalEdit then try
    // zero entries' Chance None if Form Version < 69
    if wbFormVersionDecider(69)(nil, nil, aElement) = 1 then
      Exit;

    if not Supports(aElement, IwbContainerElementRef, Container) then
      Exit;

    if Container.ElementCount < 1 then
      Exit;

    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    if MainRecord.IsDeleted then
      Exit;

    if not Supports(MainRecord.ElementByName['Leveled List Entries'], IwbContainerElementRef, Entries) then
      Exit;

    for i := 0 to Pred(Entries.ElementCount) do begin
      if not Supports(Entries.Elements[i], IwbContainerElementRef, Container) then
        Exit;
      Container.ElementNativeValues['LVLO\Chance None'] := 0;
    end;
  finally
    wbEndInternalEdit;
  end;
end;

function wbPubPackCNAMDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  rANAM: IwbRecord;
  ctype: string;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  rANAM := aElement.Container.RecordBySignature[ANAM];
  if not Assigned(rANAM) then
    Exit;

  ctype := rANAM.NativeValue;
  if ctype = 'Bool' then Result := 1 else
  if ctype = 'Int' then Result := 2 else
  if ctype = 'Float' then Result := 3 else
  if ctype = 'ObjectList' then Result := 3;
end;

function wbTypeDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
  Element   : IwbElement;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Element := Container.ElementByName['Type'];

  if Assigned(Element) then
    Result := Element.NativeValue
  else if wbMoreInfoForDecider then
    wbProgressCallback('"'+Container.Name+'" does not contain an element named Type');
end;

procedure wbIDLAsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Element         : IwbElement;
  Container       : IwbContainer;
  SelfAsContainer : IwbContainer;
begin
  if wbBeginInternalEdit then try
    if wbCounterAfterSet('IDLC - Animation Count', aElement) then
      Exit;

    if not Supports(aElement.Container, IwbContainer, Container) then
      Exit;

    Element := Container.ElementByPath['IDLC'];
    if Assigned(Element) and Supports(aElement, IwbContainer, SelfAsContainer) and
      (Element.GetNativeValue<>SelfAsContainer.GetElementCount) then
      Element.SetNativeValue(SelfAsContainer.GetElementCount);
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbAnimationsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Element         : IwbElement;
  Elems           : IwbElement;
  Container       : IwbContainer;
begin
  if wbBeginInternalEdit then try
    if wbCounterContainerAfterSet('IDLC - Animation Count', 'IDLA - Animations', aElement) then
      Exit;

    if not Supports(aElement, IwbContainer, Container) then
      Exit;

    Element := Container.ElementByPath['IDLC\Animation Count'];
    Elems   := Container.ElementByName['IDLA - Animations'];

    if Assigned(Element) and not Assigned(Elems) then
      if Element.GetNativeValue <> 0 then
        Element.SetNativeValue(0);
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbPackageDataInputValueTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainerElementRef;
  Value     : IwbElement;
begin
  if aOldValue <> aNewValue then
    if Supports(aElement.Container, IwbContainerElementRef, Container) then begin
      Value := Container.ElementByPath['CNAM'];
      if Assigned(Value) then
        if (aNewValue = 'Bool') or (aNewValue = 'Int') or (aNewValue = 'Float') or (aNewValue = 'ObjectList') then
          Value.SetToDefault
        else
          Value.Remove
      else
        if (aNewValue = 'Bool') or (aNewValue = 'Int') or (aNewValue = 'Float') or (aNewValue = 'ObjectList') then
          Container.Add('CNAM');
    end;
end;

procedure wbOMODpropertyAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('Property Count', aElement);
end;

procedure wbOMODincludeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('Include Count', aElement);
end;

procedure wbOMODdataAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerAfterSet('Property Count', 'Properties', aElement);
  wbCounterContainerAfterSet('Include Count', 'Includes', aElement);
end;

function wbOMODDataIncludeCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container       : IwbContainer;
begin
  Result := 0;
  if Supports(aElement.Container, IwbContainer, Container) then
    Result := Container.ElementNativeValues['Include Count'];
end;

function wbOMODDataPropertyCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container       : IwbContainer;
begin
  Result := 0;
  if Supports(aElement.Container, IwbContainer, Container) then
    Result := Container.ElementNativeValues['Property Count'];
end;

function GetObjectModPropertyEnum(const aElement: IwbElement): IwbEnumDef;
var
  MainRecord: IwbMainRecord;
  rDATA: IwbContainer;
  Signature: TwbSignature;
  FormType: Cardinal;
begin
  Result := nil;

  MainRecord := aElement.ContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;

  Signature := MainRecord.Signature;

  if Signature = OMOD then
    if Supports(MainRecord.ElementBySignature['DATA'], IwbContainer, rDATA) then begin
      FormType := rDATA.ElementNativeValues['Form Type'];
      Signature := PwbSignature(@FormType)^;
    end;

  if Signature = ARMO then
    Result := wbArmorPropertyEnum
  else if Signature = WEAP then
    Result := wbWeaponPropertyEnum
  else if Signature = NPC_ then
    Result := wbActorPropertyEnum;
end;

function wbObjectModPropertyToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  PropEnum: IwbEnumDef;
begin
  Result := '';

  PropEnum := GetObjectModPropertyEnum(aElement);

  if not Assigned(PropEnum) then begin
    case aType of
      ctToStr, ctToSummary, ctToSortKey, ctToEditValue: Result := aInt.ToString;
    end;
    Exit;
  end;

  case aType of
    ctToStr, ctToSummary: Result := PropEnum.ToString(aInt, aElement, aType = ctToSummary);
    ctToSortKey: Result := PropEnum.ToSortKey(aInt, aElement);
    ctCheck: Result := PropEnum.Check(aInt, aElement);
    ctToEditValue: Result := PropEnum.ToEditValue(aInt, aElement);
    ctEditType: Result := 'ComboBox';
    ctEditInfo: Result := PropEnum.EditInfo[aElement].ToCommaText;
  end;
end;

function wbObjectModPropertyToInt(const aString: string; const aElement: IwbElement): Int64;
var
  PropEnum: IwbEnumDef;
begin
  PropEnum := GetObjectModPropertyEnum(aElement);

  if not Assigned(PropEnum) then begin
    Result := StrToIntDef(aString, 0);
    Exit;
  end;

  Result := PropEnum.FromEditValue(aString, aElement);
end;

function wbOMODDataFunctionTypeDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
  ValueType      : Integer;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  ValueType := Container.ElementNativeValues['Value Type'];

  case ValueType of
    0: Result := 0;
    1: Result := 0;
    2: Result := 1;
    4: Result := 3;
    5: Result := 2;
    6: Result := 0;
  end;
end;

function wbOMODDataPropertyValue1Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
  ValueType     : Integer;
  PropName      : string;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  ValueType := Container.ElementNativeValues['Value Type'];
  PropName := Container.ElementEditValues['Property'];

  case ValueType of
    0: Result := 1;
    1: Result := 2;
    2: Result := 3;
    4, 6: Result := 4;
    5: begin
      if PropName = 'SoundLevel'    then Result := 6 else
      if PropName = 'StaggerValue'  then Result := 7 else
      if PropName = 'HitBehaviour'  then Result := 8 else
      Result := 5;
    end;
  end;
end;

function wbOMODDataPropertyValue2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container     : IwbContainer;
  ValueType      : Integer;
begin
  Result := 0;

  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  ValueType := Container.ElementNativeValues['Value Type'];

  case ValueType of
    0: Result := 1;
    1: Result := 2;
    2: Result := 3;
    4: Result := 1;
    6: Result := 2;
  end;
end;

procedure wbOBTSCombinationsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('OBTE - Count', aElement);
end;

procedure wbINNRAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('VNAM - Count', aElement);
end;

function wbCELLCombinedMeshesCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container       : IwbContainer;
begin
  Result := 0;
  if Supports(aElement.Container, IwbContainer, Container) then
    Result := Container.ElementNativeValues['Meshes Count'];
end;

procedure wbCELLCombinedMeshesAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('Meshes Count', aElement);
end;

function wbCELLCombinedRefsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container       : IwbContainer;
begin
  Result := 0;
  // the counter is double of entries (each member of struct is counted)
  if Supports(aElement.Container, IwbContainer, Container) then
    Result := Container.ElementNativeValues['References Count'] div 2;
end;

procedure wbCELLCombinedRefsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Element         : IwbElement;
  Container       : IwbContainer;
  SelfAsContainer : IwbContainer;
begin
  // the counter is double of entries (each member of struct is counted)
  if wbBeginInternalEdit then try
    if not Supports(aElement.Container, IwbContainer, Container) then
      Exit;

    if not Supports(aElement, IwbContainer, SelfAsContainer) then
      Exit;

    Element := Container.ElementByName['References Count'];
    if Assigned(Element) then try
      if (Element.GetNativeValue <> (SelfAsContainer.GetElementCount * 2)) then
        Element.SetNativeValue(SelfAsContainer.GetElementCount * 2);
    except
      // TODO: yikes, suppressing exceptions?
    end;
  finally
    wbEndInternalEdit;
  end;
end;

function wbCombinedMeshIDToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Cell: IwbMainRecord;
  MasterFolder: string;
begin
  Result := IntToHex(aInt, 8);

  case aType of
    ctToStr, ctToSummary, ctToEditValue: begin
      Cell := aElement.ContainingMainRecord;
      if not Assigned(Cell) then
        Exit;

      Cell := Cell.MasterOrSelf;
      MasterFolder := '';
      if Assigned(Cell._File) and (Cell._File.LoadOrder > 0) then
        MasterFolder := Cell._File.FileName + '\';

      Result := 'Precombined\' + MasterFolder + Cell.FormID.ChangeFileID(TwbFileID.CreateFull(0)).ToString(False) + '_' + Result + '_OC.nif';
    end;
    ctCheck: Result := '';
  end;
end;

function wbCombinedMeshIDToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s, f: string;
  i: Integer;
begin
  Result := 0;

  // hex number between first and second underscore in the file name
  f := ExtractFileName(aString);
  i := Pos('_', f);
  if not (i <> 0) then
    Exit;

  s := Copy(f, i + 1, Length(f) - i);
  i := Pos('_', s);
  if not (i <> 0) then
    Exit;

  s := Copy(s, 1, i - 1);
  if Length(s) = 8 then try
    Result := StrToInt64('$' + s);
  except
    // TODO: yikes, suppressing exceptions?
  end;
end;

function wbREFRRecordFlagsDecider(const aElement: IwbElement): Integer;
var
  MainRecord : IwbMainRecord;
  NameRec    : IwbElement;
begin
  Result := 0;

  if not wbTryGetContainingMainRecord(aElement, MainRecord) then
    Exit;

  NameRec := MainRecord.ElementBySignature[NAME];
  if not wbTryGetMainRecord(NameRec, MainRecord) then
    Exit;

  if (MainRecord.Signature = ACTI) or
     (MainRecord.Signature = STAT) or
     (MainRecord.Signature = SCOL) or
     (MainRecord.Signature = TREE)
  then
    Result := 1
  else if
     (MainRecord.Signature = CONT) or
     (MainRecord.Signature = TERM)
  then
    Result := 2
  else if MainRecord.Signature = DOOR then
    Result := 3
  else if MainRecord.Signature = LIGH then
    Result := 4
  else if MainRecord.Signature = MSTT then
    Result := 5
  else if MainRecord.Signature = ADDN then
    Result := 6
  else if
     (MainRecord.Signature = SCRL) or
     (MainRecord.Signature = AMMO) or
     (MainRecord.Signature = ARMO) or
     (MainRecord.Signature = BOOK) or
     (MainRecord.Signature = INGR) or
     (MainRecord.Signature = KEYM) or
     (MainRecord.Signature = MISC) or
     (MainRecord.Signature = FURN) or
     (MainRecord.Signature = WEAP) or
     (MainRecord.Signature = ALCH) or
     (MainRecord.Signature = LVLI)
  then
    Result := 7;
end;

function wbIntToHexStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  case aType of
    ctToStr, ctToSummary, ctToSortKey, ctToEditValue: Result := IntToHex(aInt, 8);
  else
    Result := '';
  end;
end;

function wbHexStrToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
  i: integer;
begin
  // ignore anything after space or :
  i := Pos(' ', aString);
  if i = 0 then
    i := Pos(':', aString);

  if i <> 0 then
    s := Copy(aString, 1, i - 1)
  else
    s := aString;

  try
    Result := StrToInt64('$' + s)
  except
    Result := 0;
  end;
end;

type
  TFaceGenFeature = record
    RaceID  : String;
    Female  : Boolean;
    Entries : array of record
      Index: Cardinal;
      Name : String;
    end;
  end;
  PFaceGenFeature = ^TFaceGenFeature;

var
  // cache of race specific face morphs
  FaceMorphs: array of TFaceGenFeature;
  // cache of race specific tint layers
  TintLayers: array of TFaceGenFeature;
  // cache of race specific morph groups/presets and values
  MorphValues: array of TFaceGenFeature;


function wbMorphValueToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;

  function GetCached(const aRaceID: string; aFemale: boolean): PFaceGenFeature;
  var
    i: integer;
  begin
    Result := nil;
    if Length(MorphValues) <> 0 then
      for i := Low(MorphValues) to High(MorphValues) do
        if (MorphValues[i].Female = aFemale) and (MorphValues[i].RaceID = aRaceID) then begin
          Result := @MorphValues[i];
          Break;
        end;
  end;

var
  Actor, Race       : IwbMainRecord;
  Element           : IwbElement;
  Container, Entry  : IwbContainerElementRef;
  Container2, Entry2: IwbContainerElementRef;
  Female, Female2   : Boolean;
  RaceID, EntryName : string;
  Cache             : PFaceGenFeature;
  Index             : Cardinal;
  i, j, k           : integer;
  slList            : TStringList;
begin
  // defaults
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := IntToHex64(aInt, 8);
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve morph index ' + IntToHex64(aInt, 8) + '>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  Actor := aElement.ContainingMainRecord;
  if not Assigned(Actor) then
    Exit;

  Female := Actor.ElementEditValues['ACBS\Flags\Female'] = '1';

  Element := Actor.ElementBySignature['RNAM'];
  if not Assigned(Element) then
    Exit;

  Element := Element.LinksTo;
  if not Supports(Element, IwbMainRecord, Race) then
    Exit;

  Race := Race.WinningOverride;
  RaceID := Race.EditorID;

  Cache := GetCached(RaceID, Female);

  // cache not found, fill with data from RACE
  if not Assigned(Cache) then begin

    slList := TStringList.Create;

    for i := 0 to 1 do begin

      Female2 := i = 1;
      SetLength(MorphValues, Succ(Length(MorphValues)));
      Cache := @MorphValues[Pred(Length(MorphValues))];
      Cache.RaceID := RaceID;
      Cache.Female := Female2;

      slList.Clear;

      if not Female2 then
        Element := Race.ElementByPath['Head Datas\Male Head Data\Male Morph Groups']
      else
        Element := Race.ElementByPath['Head Datas\Female Head Data\Female Morph Groups'];

      // iterate over morph groups
      if Supports(Element, IwbContainerElementRef, Container) then
        for j := 0 to Pred(Container.ElementCount) do begin
          if not Supports(Container.Elements[j], IwbContainerElementRef, Entry) then
            Break;

          // group name
          EntryName := Entry.ElementEditValues['MPGN'];

          // iterate over morph group presets
          if not Supports(Entry.ElementByName['Morph Presets'], IwbContainerElementRef, Container2) then
            Continue;

          for k := 0 to Pred(Container2.ElementCount) do
            if Supports(Container2.Elements[k], IwbContainerElementRef, Entry2) then
              slList.AddObject(
                EntryName + ' - ' + Entry2.ElementEditValues['MPPN'],
                TObject(Cardinal(Entry2.ElementNativeValues['MPPI']))
              );
        end;

      // append morph values, same for both sexes
      if Supports(Race.ElementByName['Morph Values'], IwbContainerElementRef, Container) then
        for j := 0 to Pred(Container.ElementCount) do
          if Supports(Container.Elements[j], IwbContainerElementRef, Entry) then
            slList.AddObject(
              Entry.ElementEditValues['MSM0'] + '/' + Entry.ElementEditValues['MSM1'],
              TObject(Cardinal(Entry.ElementNativeValues['MSID']))
            );

      SetLength(Cache.Entries, slList.Count);

      for j := 0 to Pred(slList.Count) do begin
        Cache.Entries[j].Index := Cardinal(slList.Objects[j]);
        Cache.Entries[j].Name := slList[j];
      end;

    end;

    slList.Free;

    Cache := GetCached(RaceID, Female);
  end;

  if not Assigned(Cache) then
    Exit;

  EntryName := '';
  Index := Cardinal(aInt);
  if Length(Cache.Entries) <> 0 then
    for i := Low(Cache.Entries) to High(Cache.Entries) do
      if Cache.Entries[i].Index = Index then begin
        EntryName := Cache.Entries[i].Name;
        Break;
      end;

  case aType of
    ctToStr, ctToSummary: begin
      if EntryName <> '' then
        Result := IntToHex64(aInt, 8) + ' ' + EntryName
      else begin
        Result := IntToHex64(aInt, 8);
        if aType = ctToStr then
          Result := Result + ' <Morph index not found in ' + Race.Name + '>';
      end;
    end;
    ctCheck: begin
      if EntryName = '' then
        Result := '<Morph index ' + IntToHex(aInt, 8) + ' not found in ' + Race.Name + '>'
      else
        Result := '';
    end;
    ctEditType: Result := 'ComboBox';
    ctEditInfo: begin
      Result := '';
      if Length(Cache.Entries) <> 0 then
        for i := Low(Cache.Entries) to High(Cache.Entries) do begin
          if Result <> '' then Result := Result + ',';
          Result := Result +  '"' + IntToHex(Cache.Entries[i].Index, 8) + ' ' + Cache.Entries[i].Name + '"';
        end;
    end;
  end;
end;

function wbFaceMorphToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
  function GetCached(const aRaceID: string; aFemale: boolean): PFaceGenFeature;
  var
    i: integer;
  begin
    Result := nil;
    if Length(FaceMorphs) <> 0 then
      for i := Low(FaceMorphs) to High(FaceMorphs) do
        if (FaceMorphs[i].Female = aFemale) and (FaceMorphs[i].RaceID = aRaceID) then begin
          Result := @FaceMorphs[i];
          Break;
        end;
  end;

var
  Actor, Race           : IwbMainRecord;
  Element               : IwbElement;
  Container, Entry      : IwbContainerElementRef;
  Female, Female2       : Boolean;
  RaceID, EntryName     : string;
  Cache                 : PFaceGenFeature;
  Index                 : Cardinal;
  i, j                  : integer;
begin
  // defaults
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := IntToHex64(aInt, 8);
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve face morph index ' + IntToHex64(aInt, 8) + '>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  Actor := aElement.ContainingMainRecord;
  if not Assigned(Actor) then
    Exit;

  Female := Actor.ElementEditValues['ACBS\Flags\Female'] = '1';

  Element := Actor.ElementBySignature['RNAM'];
  if not Assigned(Element) then
    Exit;

  Element := Element.LinksTo;
  if not Supports(Element, IwbMainRecord, Race) then
    Exit;

  Race := Race.WinningOverride;
  RaceID := Race.EditorID;

  Cache := GetCached(RaceID, Female);

  // cache not found, fill with data from RACE
  if not Assigned(Cache) then begin

    for i := 0 to 1 do begin

      Female2 := i = 1;
      SetLength(FaceMorphs, Succ(Length(FaceMorphs)));
      Cache := @FaceMorphs[Pred(Length(FaceMorphs))];
      Cache.RaceID := RaceID;
      Cache.Female := Female2;

      if not Female2 then
        Element := Race.ElementByPath['Head Datas\Male Head Data\Male Face Morphs']
      else
        Element := Race.ElementByPath['Head Datas\Female Head Data\Female Face Morphs'];

      if not Supports(Element, IwbContainerElementRef, Container) then
        Continue;

      SetLength(Cache.Entries, Container.ElementCount);

      for j := 0 to Pred(Container.ElementCount) do begin
        if not Supports(Container.Elements[j], IwbContainerElementRef, Entry) then
          Break;
        Cache.Entries[j].Index := Entry.ElementNativeValues['FMRI'];
        Cache.Entries[j].Name := Entry.ElementEditValues['FMRN'];
      end;
    end;

    Cache := GetCached(RaceID, Female);
  end;

  if not Assigned(Cache) then
    Exit;

  EntryName := '';
  Index := Cardinal(aInt);
  if Length(Cache.Entries) <> 0 then
    for i := Low(Cache.Entries) to High(Cache.Entries) do
      if Cache.Entries[i].Index = Index then begin
        EntryName := Cache.Entries[i].Name;
        Break;
      end;

  if EntryName = '' then
  begin
    Cache := GetCached(RaceID, (not Female));

    if not Assigned(Cache) then
      Exit;

    if Length(Cache.Entries) <> 0 then
      for i := Low(Cache.Entries) to High(Cache.Entries) do
        if Cache.Entries[i].Index = Index then begin
          EntryName := Cache.Entries[i].Name;
          Break;
        end;
  end;

  case aType of
    ctToStr, ctToSummary: begin
      if EntryName <> '' then
        Result := IntToHex64(aInt, 8) + ' ' + EntryName
      else begin
        Result := IntToHex64(aInt, 8);
        if aType = ctToStr then
          Result := Result + ' <Face morph index not found in ' + Race.Name + '>';
      end;
    end;
    ctCheck: begin
      if EntryName = '' then
        Result := '<Face morph index ' + IntToHex(aInt, 8) + ' not found in ' + Race.Name + '>'
      else
        Result := '';
    end;
    ctEditType: Result := 'ComboBox';
    ctEditInfo: begin
      Result := '';
      if Length(Cache.Entries) <> 0 then
        for i := Low(Cache.Entries) to High(Cache.Entries) do begin
          if Result <> '' then Result := Result + ',';
          Result := Result +  '"' + IntToHex(Cache.Entries[i].Index, 8) + ' ' + Cache.Entries[i].Name + '"';
        end;
    end;
  end;
end;

function wbTintLayerToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;

  function GetCached(const aRaceID: string; aFemale: boolean): PFaceGenFeature;
  var
    i: integer;
  begin
    Result := nil;
    if Length(TintLayers) <> 0 then
      for i := Low(TintLayers) to High(TintLayers) do
        if (TintLayers[i].Female = aFemale) and (TintLayers[i].RaceID = aRaceID) then begin
          Result := @TintLayers[i];
          Break;
        end;
  end;

var
  Actor, Race       : IwbMainRecord;
  Element           : IwbElement;
  Container, Entry  : IwbContainerElementRef;
  Container2, Entry2: IwbContainerElementRef;
  Female, Female2   : Boolean;
  RaceID, EntryName : string;
  Cache             : PFaceGenFeature;
  Index             : Cardinal;
  i, j, k           : integer;
  slList            : TStringList;
begin
  // defaults
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '<Warning: Could not resolve tint layer index ' + aInt.ToString + '>';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  Actor := aElement.ContainingMainRecord;
  if not Assigned(Actor) then
    Exit;

  Female := Actor.ElementEditValues['ACBS\Flags\Female'] = '1';

  Element := Actor.ElementBySignature['RNAM'];
  if not Assigned(Element) then
    Exit;

  Element := Element.LinksTo;
  if not Supports(Element, IwbMainRecord, Race) then
    Exit;

  Race := Race.WinningOverride;
  RaceID := Race.EditorID;

  Cache := GetCached(RaceID, Female);

  // cache not found, fill with data from RACE
  if not Assigned(Cache) then begin

    slList := TStringList.Create;

    for i := 0 to 1 do begin
      Female2 := i = 1;
      SetLength(TintLayers, Succ(Length(TintLayers)));
      Cache := @TintLayers[Pred(Length(TintLayers))];
      Cache.RaceID := RaceID;
      Cache.Female := Female2;

      if not Female2 then
        Element := Race.ElementByPath['Head Datas\Male Head Data\Male Tint Layers']
      else
        Element := Race.ElementByPath['Head Datas\Female Head Data\Female Tint Layers'];

      if not Supports(Element, IwbContainerElementRef, Container) then
        Continue;

      slList.Clear;

      // iterate over tint groups
      for j := 0 to Pred(Container.ElementCount) do begin
        if not Supports(Container.Elements[j], IwbContainerElementRef, Entry) then
          Continue;

        // iterate over tint group options
        if not Supports(Entry.ElementByName['Options'], IwbContainerElementRef, Container2) then
          Continue;

        for k := 0 to Pred(Container2.ElementCount) do
          if Supports(Container2.Elements[k], IwbContainerElementRef, Entry2) then
            slList.AddObject(
              Entry.ElementEditValues['TTGP'] + ' - ' + Entry2.ElementEditValues['TTGP'],
              TObject(Cardinal(Entry2.ElementNativeValues['TETI\Index']))
            );
      end;

      SetLength(Cache.Entries, slList.Count);

      for j := 0 to Pred(slList.Count) do begin
        Cache.Entries[j].Index := Cardinal(slList.Objects[j]);
        Cache.Entries[j].Name := slList[j];
      end;
    end;

    slList.Free;

    Cache := GetCached(RaceID, Female);
  end;

  if not Assigned(Cache) then
    Exit;

  EntryName := '';
  Index := Cardinal(aInt);
  if Length(Cache.Entries) <> 0 then
    for i := Low(Cache.Entries) to High(Cache.Entries) do
      if Cache.Entries[i].Index = Index then begin
        EntryName := Cache.Entries[i].Name;
        Break;
      end;

  case aType of
    ctToStr, ctToSummary: begin
      if EntryName <> '' then
        Result := aInt.ToString + ' ' + EntryName
      else begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Tint layer index not found in ' + Race.Name + '>';
      end;
    end;
    ctCheck: begin
      if EntryName = '' then
        Result := '<Tint layer index ' + aInt.ToString + ' not found in ' + Race.Name + '>'
      else
        Result := '';
    end;
    ctEditType: Result := 'ComboBox';
    ctEditInfo: begin
      Result := '';
      if Length(Cache.Entries) <> 0 then
        for i := Low(Cache.Entries) to High(Cache.Entries) do begin
          if Result <> '' then Result := Result + ',';
          Result := Result + '"' + IntToStr(Cache.Entries[i].Index) + ' ' + Cache.Entries[i].Name + '"';
        end;
    end;
  end;
end;

  function wbTintTemplateGroups(const aName: string): IwbSubRecordArrayDef;
  var
    wbTintTemplateGroup: IwbSubRecordStructDef;
    wbTintTemplateOption: IwbSubRecordStructDef;
  begin
    wbTintTemplateOption :=
      wbRStruct('Option', [
        wbStruct(TETI, 'Index', [
          wbInteger('Slot', itU16, wbEnum([
            'Forehead Mask',
            'Eyes Mask',
            'Nose Mask',
            'Ears Mask',
            'Cheeks Mask',
            'Mouth Mask',
            'Neck Mask',
            'Lip Color',
            'Cheek Color',
            'Eyeliner',
            'Eye Socket Upper',
            'Eye Socket Lower',
            'Skin Tone',
            'Paint',
            'Laugh Lines',
            'Cheek Color Lower',
            'Nose',
            'Chin',
            'Neck',
            'Forehead',
            'Dirt',
            'Scars',
            'Face Detail',
            'Brows',
            'Wrinkles',
            'Beards'
          ])),
          wbInteger('Index', itU16)
        ]),
        wbLString(TTGP, 'Name', 0, cpTranslate),
        wbInteger(TTEF, 'Flags', itU16, wbFlags([
          'On/Off only',
          'Chargen Detail',
          'Takes Skin Tone',
          'Unknown 3' { Added in patch 1.2.5.8 }
        ])),
        wbCTDAs,
        wbRArray('Textures', wbString(TTET, 'Texture')),
        wbInteger(TTEB, 'Blend Operation', itU32, wbBlendOperationEnum),
        wbArray(TTEC, 'Template Colors', wbStruct('Template Color', [
          wbFormIDCk('Color', [CLFM]),
          wbFloat('Alpha'),
          wbInteger('Template Index', itU16),
          wbInteger('Blend Operation', itU32, wbBlendOperationEnum)
        ])),
        wbFloat(TTED, 'Default')
      ], []);

    wbTintTemplateGroup :=
      wbRStruct('Group', [
        wbLString(TTGP, 'Group Name', 0, cpTranslate),
        wbRArray('Options', wbTintTemplateOption),
        wbInteger(TTGE, 'Category Index', itU32)
      ], []);

    Result := wbRArray(aName, wbTintTemplateGroup);
  end;

  function wbMorphGroups(const aName: string): IwbSubRecordArrayDef;
  begin
    Result :=
      wbRArray(aName,
        wbRStruct('Morph Group', [
          wbString(MPGN, 'Name'),
          wbInteger(MPPC, 'Count', itU32, nil, cpBenign),
          wbRArray('Morph Presets',
            wbRStruct('Morph Preset', [
              wbInteger(MPPI, 'Index', itU32, wbIntToHexStr, wbHexStrToInt),
              wbLString(MPPN, 'Name', 0, cpTranslate),
              wbString(MPPM, 'Morph Type'),
              wbFormIDCk(MPPT, 'Texture', [TXST]),
              wbInteger(MPPF, 'Playable', itU8, wbBoolEnum)
            ], []),
            cpNormal, False, nil, wbMorphPresetsAfterSet
          ),
          wbInteger(MPPK, 'Tint Layer Face Region Index', itU16),
          wbArray(MPGS, 'Morph Value Indexs', wbInteger('Index', itU32, wbIntToHexStr, wbHexStrToInt))
        ], [])
      );
  end;

  function wbFaceMorphs(const aName: string): IwbSubRecordArrayDef;
  begin
    Result :=
      wbRArray(aName,
        wbRStruct('Face Morph', [
          wbInteger(FMRI, 'Index', itU32, wbIntToHexStr, wbHexStrToInt),
          wbLString(FMRN, 'Name')
        ], [])
      );
  end;

function CombineVarRecs(const a, b : array of const)
                                   : TVarRecs;
begin
  SetLength(Result, Length(a) + Length(b));
  if Length(a) > 0 then
    Move(a[0], Result[0], SizeOf(TVarRec) * Length(a));
  if Length(b) > 0 then
    Move(b[0], Result[Length(a)], SizeOf(TVarRec) * Length(b));
end;

function MakeVarRecs(const a : array of const)
                             : TVarRecs;
begin
  SetLength(Result, Length(a));
  if Length(a) > 0 then
    Move(a[0], Result[0], SizeOf(TVarRec) * Length(a));
end;

  procedure ReferenceRecord(aSignature: TwbSignature; const aName: string);
  begin
    wbRefRecord(aSignature, aName,
      wbFlags(wbFlagsList([
        {0x00000080}  7, 'Turn Off Fire',
        {0x00000400} 10, 'Persistent',
        {0x00000800} 11, 'Initially Disabled',
        {0x10000000} 28, 'Reflected By Auto Water',
        {0x20000000} 29, 'Don''t Havok Settle',
        {0x40000000} 30, 'No Respawn'
      ], True, True)), [
      wbEDID,
      wbVMAD,
      wbXALG,
      wbFormIDCk(NAME, 'Projectile', [PROJ, HAZD]),
      wbXEZN,
      wbFloat(XHTW, 'Head-Tracking Weight'),
      wbFloat(XFVC, 'Favor Cost'),
      wbRArrayS('Reflected/Refracted By',
        wbFormIDCk(XPWR, 'Reflector Reference', [REFR])
      ),
      wbXLKR,
      wbRStruct('Activate Parents', [
        wbInteger(XAPD, 'Flags', itU8, wbFlags([
          'Parent Activate Only'
        ], True)),
        wbRArrayS('Activate Parent Refs',
          wbStructSK(XAPR, [0], 'Activate Parent Ref', [
            wbFormIDCk('Reference', sigReferences),
            wbFloat('Delay')
          ])
        )
      ], []),

      wbFormIDCk(XASP, 'Acoustic Parent', [REFR]),
      wbXATP,
      wbInteger(XAMC, 'Ammo Count', itU32),
      wbEmpty(XLKT, 'Linked Ref Transient'),
      wbXRGD,
      wbFormIDCk(XLYR, 'Layer', [LAYR]),
      wbFormIDCk(XMSP, 'Material Swap', [MSWP]),
      wbXLWT,
      wbFormIDCk(XRFG, 'Reference Group', [RFGP]),
      wbStruct(XCVR,'Water Current Zone Data', [
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown')
      ]),
      wbXESP,
      wbXOWN,
      wbXRNK,
      wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),
      wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),
      wbEmpty(XIS2, 'Ignored by Sandbox'),
      wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),
      wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),
      wbXWPK,
      wbXPCK,
      wbXSCL,
      wbXLOD,
      wbDataPosRot,
      wbString(MNAM, 'Comments')
    ], True, wbPlacedAddInfo);
  end;

procedure DefineFO76;
begin
  DefineCommon;

  wbRecordFlags := wbInteger('Record Flags', itU32, wbFlags(wbFlagsList([])));

  wbMainRecordHeader := wbRecordHeader(wbRecordFlags);

  wbSizeOfMainRecordStruct := 24;

  wbNull := wbByteArray('Unused', -255);
  wbLLCT := wbInteger(LLCT, 'Count', itU8, nil, cpBenign);
  wbCNDC := wbInteger(CNDC, 'Condition Position', itU32, nil, cpBenign);
  wbCITC := wbInteger(CITC, 'Condition Count', itU32, nil, cpBenign);
  wbCITCReq := wbInteger(CITC, 'Condition Count', itU32, nil, cpBenign, True);
  wbDIQO := wbFormIDCk(DIQO, 'Quest', [QUST]);
  wbLVLD := wbBelowVersion(174, LVLD, wbInteger('Chance None', itU8, nil, cpNormal, True));

  wbLVMV  := wbFloat(LVMV, 'Max Value');
  wbLVMG  := wbFormIDCk(LVMG, 'Max Global', [GLOB]);
  wbLVMT  := wbFormIDCk(LVMT, 'Max Curve Table', [CURV]);

  wbLVOV  := wbFloat(LVOV, 'Chance None Value');
  wbLVOC  := wbFormIDCk(LVOC, 'Chance None Global', [GLOB]);
  wbLVOT  := wbFormIDCk(LVOT, 'Chance None Curve Table', [CURV]);

  wbLVLV  := wbFloat(LVLV, 'Minimum Level');
  wbLVOG  := wbFormIDCk(LVOG, 'Minimum Level Global', [GLOB]);
  wbLVLT  := wbFormIDCk(LVLT, 'Minimim Level Curve Table', [CURV]);

  wbLVIV  := wbFloat(LVIV, 'Quantity');
  wbLVIG  := wbFormIDCk(LVIG, 'Quantity Global', [GLOB]);
  wbLVIT  := wbFormIDCk(LVIT, 'Quantity Curve Table', [CURV]);

  wbLVCV  := wbFloat(LVCV, 'Chance None Value');
  wbLVLG  := wbFormIDCk(LVLG, 'Chance None Global', [GLOB]);
  wbLVCT  := wbFormIDCk(LVCT, 'Chance None Curve Table', [CURV]);

  wbSPCT := wbInteger(SPCT, 'Count', itU32, nil, cpBenign);
  wbSPLO := wbFormIDCk(SPLO, 'Actor Effect', [SPEL, LVSP]);
  wbSPLOs := wbRArrayS('Actor Effects', wbSPLO, cpNormal, False, nil, wbSPLOsAfterSet, nil{wbActorTemplateUseActorEffectList});

  wbXPCK := wbFormIDCk(XPCK, 'Reference Group', [RFGP]);

  //wbActorValue := wbInteger('Actor Value', itS32, wbActorValueEnum);
  wbActorValue := wbUnion('Actor Value', wbFormVersionDecider(77), [
    wbInteger('Actor Value', itU32, wbActorValueEnum),
    wbFormIDCkNoReach('Actor Value', [AVIF, NULL])
  ]);

  wbPERKData :=
    wbStruct(DATA, 'Data', [
      wbFromSize(5, wbInteger('Trait', itU8, wbBoolEnum)),
      wbFromSize(5, wbInteger('Level', itU8)),
      wbFromSize(5, wbInteger('Num Ranks', itU8)),
      wbInteger('Playable', itU8, wbBoolEnum),
      wbInteger('Hidden', itU8, wbBoolEnum),
      wbByteArray('Unknown', 1)
    ], cpNormal, True, nil, 6);

  wbCOED := wbStructExSK(COED, [2], [0, 1], 'Extra Data', [
    {00} wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
    {04} wbUnion('', wbCOEDOwnerDecider, [
           wbByteArray('Unused', 4, cpIgnore),
           wbFormIDCk('Global Variable', [GLOB, NULL]),
           wbInteger('Required Rank', itS32)
         ]),
    {08} wbFloat('Item Condition'),
         wbStruct('Curve Tables', [
           wbFormIDCk('Min', [CURV, NULL]),
           wbFormIDCk('Max', [CURV, NULL])
         ])
  ]);

  wbCNTO :=
    wbRStructExSK([0], [1], 'Item', [
      wbStructExSK(CNTO, [0], [1], 'Item', [
        wbFormIDCk('Item', sigBaseObjects),
        wbInteger('Count', itS32)
      ]),
      wbCOED
    ], []).SetToStr(wbItemToStr).IncludeFlag(dfCollapsed, wbCollapseItems);
  wbCOCT := wbInteger(COCT, 'Count', itU32, nil, cpBenign);
  wbCNTOs := wbRArrayS('Items', wbCNTO, cpNormal, False, nil, wbCNTOsAfterSet);

  {>>> When NAME is user defined these will be incorrect <<<}
  wbBipedObjectEnum := wbEnum([
    '30 - Hair Top',
    '31 - Hair Long',
    '32 - FaceGen Head',
    '33 - BODY',
    '34 - L Hand',
    '35 - R Hand',
    '36 - [U] Torso',
    '37 - [U] L Arm',
    '38 - [U] R Arm',
    '39 - [U] L Leg',
    '40 - [U] R Leg',
    '41 - [A] Torso',
    '42 - [A] L Arm',
    '43 - [A] R Arm',
    '44 - [A] L Leg',
    '45 - [A] R Leg',
    '46 - Headband',
    '47 - Eyes',
    '48 - Beard',
    '49 - Mouth',
    '50 - Neck',
    '51 - Ring',
    '52 - Scalp',
    '53 - Decapitation',
    '54 - Backpack',
    '55 - EyeOfRa',
    '56 - Unnamed',
    '57 - Coverall',
    '58 - Unnamed',
    '59 - Shield',
    '60 - Pipboy',
    '61 - FX'
  ], [
    -1, 'None'
  ]);

  wbBipedObjectFlags := wbFlags([
    {0x00000001} '30 - Hair Top',
    {0x00000002} '31 - Hair Long',
    {0x00000004} '32 - FaceGen Head',
    {0x00000008} '33 - BODY',
    {0x00000010} '34 - L Hand',
    {0x00000020} '35 - R Hand',
    {0x00000040} '36 - [U] Torso',
    {0x00000080} '37 - [U] L Arm',
    {0x00000100} '38 - [U] R Arm',
    {0x00000200} '39 - [U] L Leg',
    {0x00000400} '40 - [U] R Leg',
    {0x00000800} '41 - [A] Torso',
    {0x00001000} '42 - [A] L Arm',
    {0x00002000} '43 - [A] R Arm',
    {0x00004000} '44 - [A] L Leg',
    {0x00008000} '45 - [A] R Leg',
    {0x00010000} '46 - Headband',
    {0x00020000} '47 - Eyes',
    {0x00040000} '48 - Beard',
    {0x00080000} '49 - Mouth',
    {0x00100000} '50 - Neck',
    {0x00200000} '51 - Ring',
    {0x00400000} '52 - Scalp',
    {0x00800000} '53 - Decapitation',
    {0x01000000} '54 - Backpack',
    {0x02000000} '55 - EyeOfRa',
    {0x04000000} '56 - Unnamed',
    {0x08000000} '57 - Coverall',
    {0x10000000} '58 - Unnamed',
    {0x20000000} '59 - Shield',
    {0x40000000} '60 - Pipboy',
    {0x80000000} '61 - FX'
  ], True);

  wbFirstPersonFlagsU32 := wbInteger('First Person Flags', itU32, wbBipedObjectFlags);

  wbBOD2 := wbStruct(BOD2, 'Biped Body Template', [
    wbFirstPersonFlagsU32
  ], cpNormal, False);

  wbDODT := wbUnion(DODT, 'Decal Data', wbFormVersionDecider(136) , [
    wbStructSK([], 'Decal Data', [
      { 0} wbFloat('Min Width'),
      { 1} wbFloat('Max Width'),
      { 2} wbFloat('Min Height'),
      { 3} wbFloat('Max Height'),
      { 4} wbFloat('Depth'),
      { 5} wbFloat('Shininess'),
      { 6} wbFloat('Parallax - Scale'),
      { 7} wbInteger('Parallax - Passes', itU8), { >>> This can't be higher than 72 <<< }
      { 8} wbInteger('Flags', itU8, wbFlags([
        {0x01} 'POM Shadows',
        {0x02} 'Alpha - Blending',
        {0x04} 'Alpha - Testing',
        {0x08} 'No Subtextures',
        {0x10} 'Multiplicative Blending',
        {0x20} 'No G-Buffer Normals'
        ], True)),
      { 9} wbInteger('Alpha Threshold?', itU16),
      {10} wbByteColors('Color')
    ]),
    wbStructSK([], 'Decal Data', [
      { 0} wbFloat('Min Width'),
      { 1} wbFloat('Max Width'),
      { 2} wbFloat('Min Height'),
      { 3} wbFloat('Max Height'),
      { 4} wbFloat('Depth'),
      { 5} wbEmpty('Unused'), //Shininess
      { 6} wbFloat('Parallax - Scale'),
      { 7} wbInteger('Flags', itU8, wbFlags([  //XOR by 0xF0
        {0x01} 'POM Shadows',
        {0x02} 'No Subtextures',
        {0x04} 'Multiplicative Blending',
        {0x08} 'No G-Buffer Normals'
        ], True)),
      { 8} wbByteArray('Unknown', 1),
      { 9} wbInteger('Parallax - Passes', itU8), { >>> This can't be higher than 72 <<< }
      {10} wbByteArray('Unknown', 1),
      {11} wbEmpty('Unused'), //Alpha Threshold?
      {12} wbEmpty('Unused') //Color
    ], [0, 1, 2, 3, 4, 5, 6, 9, 7, 11, 12, 8, 10])
  ]);

  wbIgnoreRecords.Add(XXXX);

//  wbXRGD := wbByteArray(XRGD, 'Ragdoll Data');
  wbXRGD := wbArray(XRGD, 'Ragdoll Data', wbStruct('Ragdoll Data', [
    wbInteger('Bone Id', itU8),
    wbByteArray('Unknown/Unused', 3),
    wbPosRot
  ]));

  wbXRGB := wbStruct(XRGB, 'Ragdoll Biped Rotation', [
    wbFloat('X'),
    wbFloat('Y'),
    wbFloat('Z')
  ]);

  wbSoundLevelEnum := wbEnum([
     'Loud',
     'Normal',
     'Silent',
     'Very Loud',
     'Quiet'
    ]);

  wbEntryPointsEnum := wbEnum([
    { 0} 'Mod Breath Timer',
    { 1} 'Mod My Critical Hit Chance',
    { 2} 'Mod My Critical Hit Damage Mult',
    { 3} 'Mod Mine Explode Chance',
    { 4} 'Mod Incoming Limb Damage',
    { 5} 'Mod Book Actor Value Bonus',
    { 6} 'Mod Recovered Health',
    { 7} 'Set Should Attack',
    { 8} 'Mod Buy Prices',
    { 9} 'Add Leveled List On Death',
    {10} 'Set Max Carry Weight',
    {11} 'Mod Addiction Chance',
    {12} 'Mod Addiction Duration',
    {13} 'Mod Positive Chem Duration',
    {14} 'Activate',
    {15} 'Ignore Running During Detection',
    {16} 'Ignore Broken Lock',
    {17} 'Mod Enemy Critical Hit Chance',
    {18} 'Mod Sneak Attack Mult',
    {19} 'Mod Max Placeable Mines',
    {20} 'Mod Bow Zoom',
    {21} 'Mod Recover Arrow Chance',
    {22} 'Mod Exp',
    {23} 'Mod Move Camp Cost',
    {24} 'Mod Shuffle Cost',
    {25} 'Mod Workshop Build Cost',
    {26} 'Mod Bashing Damage',
    {27} 'Mod Power Attack Action Points',
    {28} 'Mod Power Attack Damage',
    {29} 'Mod Spell Magnitude',
    {30} 'Mod Spell Duration',
    {31} 'Mod Secondary Value Weight',
    {32} 'Mod Armor Weight',
    {33} 'Mod Incoming Stagger',
    {34} 'Mod Target Stagger',
    {35} 'Mod Weapon Attack Damage',
    {36} 'Mod Incoming Weapon Damage',
    {37} 'Mod Target Damage Resistance',
    {38} 'Mod Spell Cost',
    {39} 'Mod Percent Blocked',
    {40} 'Mod Shield Deflect Arrow Chance',
    {41} 'Mod Incoming Spell Magnitude',
    {42} 'Mod Incoming Spell Duration',
    {43} 'Mod Player Intimidation',
    {44} 'Mod Ricochet Chance',
    {45} 'Mod Ricochet Damage',
    {46} 'Mod Bribe Amount',
    {47} 'Mod Detection Light',
    {48} 'Mod Detection Movement',
    {49} 'Mod Scrap Reward Mult',
    {50} 'Set Sweep Attack',
    {51} 'Apply Combat Hit Spell',
    {52} 'Apply Bashing Spell',
    {53} 'Apply Reanimate Spell',
    {54} 'Set Boolean Graph Variable',
    {55} 'Mod Spell Casting Sound Event',
    {56} 'Mod VATS Critical Cost',
    {57} 'Mod Detection Sneak Skill',
    {58} 'Mod Falling Damage',
    {59} 'Mod Lockpick Sweet Spot',
    {60} 'Mod Sell Prices',
    {61} 'Mod VATS Attacker Accuracy',
    {62} 'Set Player Gate Lockpick',
    {63} 'Set Lockpick Starting Arc',
    {64} 'Set Progression Picking',
    {65} 'Set Lockpicks Unbreakable',
    {66} 'Mod Alchemy Effectiveness',
    {67} 'Apply Weapon Swing Spell',
    {68} 'Mod Commanded Actor Limit',
    {69} 'Apply Sneaking Spell',
    {70} 'Mod Player Magic Slowdown',
    {71} 'Mod Ward Magicka Absorption Pct',
    {72} 'Mod Initial Ingredient Effects Learned',
    {73} 'Purify Alchemy Ingredients',
    {74} 'Set Filter Activation',
    {75} 'Set Dual Cast',
    {76} 'Mod Outgoing Explosion Limb Damage',
    {77} 'Mod Enchantment Power',
    {78} 'Mod Soul Pct Captured to Weapon',
    {79} 'Mod VATS Attack Action Points',
    {80} 'Mod Reflect Damage Chance',
    {81} 'Set Activate Label',
    {82} 'Mod Kill Experience',
    {83} 'Mod Poison Dose Count',
    {84} 'Set Apply Placed Item',
    {85} 'Mod Armor Rating',
    {86} 'Mod lockpicking crime chance',
    {87} 'Mod ingredients harvested',
    {88} 'Mod Spell Range (Target Loc.)',
    {89} 'Mod Critical Charge Mult on Ricochet',
    {90} 'Mod lockpicking key reward chance',
    {91} 'Mod Auto Lockpicking Chance',
    {92} 'Mod Auto Hacking Chance',
    {93} 'Mod Typed Weapon Attack Damage',
    {94} 'Mod Typed Incoming Weapon Damage',
    {95} 'Mod Charisma Challenge Chance',
    {96} 'Mod Sprint AP Drain Rate',
    {97} 'Mod Drawn Weapon Weight Speed Effect',
    {98} 'Set Player Gate Hacking',
    {99} 'Mod Player Explosion Damage',
   {100} 'Mod Player Explosion Scale',
   {101} 'Set Rads To Health Mult',
   {102} 'Mod Actor Scope Stability',
   {103} 'Mod Actor Grenade Speed Mult',
   {104} 'Mod Explosion Force',
   {105} 'Mod VATS Penetration Min Visibility',
   {106} 'Mod Rads for Rad Health Max',
   {107} 'Mod VATS Player AP On Kill Chance',
   {108} 'Set VATS Fill Critical Bar On Hit',
   {109} 'Mod VATS Concentrated Fire Chance Bonus',
   {110} 'Mod Crafting Dupe Chance',
   {111} 'Mod VATS Hold Em Steady Bonus',
   {112} 'Mod Typed Spell Magnitude',
   {113} 'Mod Typed Incoming Spell Magnitude',
   {114} 'Set VATS Gun-Fu',
   {115} 'Mod Outgoing Limb Damage',
   {116} 'Mod Restore Action Cost Value',
   {117} 'Mod VATS Splash Damage',
   {118} 'Mod Incoming Battery Damage',
   {119} 'Mod VATS Critical Charge',
   {120} 'Mod Exp Location',
   {121} 'Mod Exp Speech',
   {122} 'Mod VATS Head Shot Chance',
   {123} 'Mod VATS Hit Chance',
   {124} 'Mod Incoming Explosion Damage',
   {125} 'Mod Ammo Health Mult',
   {126} 'Mod Hacking Guesses',
   {127} 'Mod Terminal Lockout Time',
   {128} 'Set Undetectable',
   {129} 'Invest In Vendor',
   {130} 'Mod Outgoing Limb Bash Damage',
   {131} 'Set Run While Over Encumbered',
   {132} 'Get Component Radar Distance',
   {133} 'Show Grenade Trajectory',
   {134} 'Mod Cone-of-fire Mult',
   {135} 'Mod VATS Concentrated Fire Damage Mult',
   {136} 'Apply Bloody Mess Spell',
   {137} 'Iron-Sights Activate',
   {138} 'Mod VATS Critical Fill Chance On Use',
   {139} 'Set VATS Critical Fill On AP Reward',
   {140} 'Set VATS Critical Fill On Stranger',
   {141} 'Mod Gun Range Mult',
   {142} 'Mod Scope Hold Breath AP Drain Mult',
   {143} 'Set Force Decapitate',
   {144} 'Mod VATS Shoot Explosive Damage Mult',
   {145} 'Mod Scrounger Fill Ammo Chance',
   {146} 'Set Can Explode Pants',
   {147} 'Set VATS Penetration Full Damage',
   {148} 'Mod VATS Gun-Fu 2nd Target Dmg Mult',
   {149} 'Mod VATS Gun-Fu 3rd Target Dmg Mult',
   {150} 'Mod VATS Gun-Fu 4th+ Target Dmg Mult',
   {151} 'Mod VATS Blitz Max Distance',
   {152} 'Set VATS Blitz Max Dmg Mult',
   {153} 'Mod VATS Blitz Dmg Bonus Dist',
   {154} 'Mod Bash Critical Chance',
   {155} 'Mod Evasion Chance',
   {156} 'Mod Fatigue for Fatigue AP Max',
   {157} 'Set Fatigue to AP Mult',
   {158} 'Mod Item Weight',
   {159} 'Set Alt Revive Item',
   {160} 'Mod VATS Splash Damage Radius',
   {161} 'Apply VATS Splash Damage Spell',
   {162} 'Mod Bleedout Time ',
   {163} 'Mod Item Condition Loss',
   {164} 'Mod Crafting Creation Recipe Level',
   {165} 'Mod Workshop Repair Cost',
   {166} 'Mod Item Repair Mult',
   {167} 'Mod Weapon DMG Bonus Mult',
   {168} 'Mod Mysterious Stranger Chance',
   {169} 'Mod Item Spawn Count',
   {170} 'Apply Weapon Attack Spell',
   {171} 'Mod Item Condition Curve Ratio',
   {172} 'Mod Ammo Used Count',
   {173} 'Apply Combat Melee Spell',
   {174} 'Mod Barter Charisma',
   {175} 'Mod Mysterious Savior Chance',
   {176} 'Mod Item Repair Condition',
   {177} 'Mod Crafting Return Quantity',
   {178} 'Mod Damaged Condition Regen Delay',
   {179} 'Set Consume Revive Item',
   {180} 'Set Consume Travel Ticket',
   {181} 'Mod Wanted Timer Mult',
   {182} 'Auto Fill Weapon Clip',
   {183} 'Mod Fast Travel Cost',
   {184} 'Apply Friendly Hit Spell',
   {185} 'Set VATS Target Limbs',
   {186} 'Set Team Medic',
   {187} 'Apply On Kill Spell',
   {188} 'Set Damage on Consecutive Hits',
   {189} 'Mod Damage on Consecutive Hits',
   {190} 'Mod Max Consecutive Hits Allowed',
   {191} 'Mod Crafted Item Bonus Health',
   {192} 'Set Cheat Death',
   {193} 'Apply Combat Hit Spell Taken',
   {194} 'Apply On Death Spell',
   {195} 'Mod Max Barter Currency',
   {196} 'Mod Body Part Damage Mult',
   {197} 'Apply On Kill Participation Spell',
   {198} 'Is Next Clip Last Shot'
  ]);

  wbEquipType := wbFlags([
    {0x00000001} 'Hand To Hand Melee',
    {0x00000002} 'One Hand Sword',
    {0x00000004} 'One Hand Dagger',
    {0x00000008} 'One Hand Axe',
    {0x00000010} 'One Hand Mace',
    {0x00000020} 'Two Hand Sword',
    {0x00000040} 'Two Hand Axe',
    {0x00000080} 'Bow',
    {0x00000100} 'Staff',
    {0x00000200} 'Gun',
    {0x00000400} 'Grenade',
    {0x00000800} 'Mine',
    {0x00001000} 'Spell',
    {0x00002000} 'Shield',
    {0x00004000} 'Torch'
  ], True);

  wbEmotionTypeEnum := wbEnum([
    {0} 'Neutral',
    {1} 'Anger',
    {2} 'Disgust',
    {3} 'Fear',
    {4} 'Sad',
    {5} 'Happy',
    {6} 'Surprise',
    {7} 'Puzzled'
  ]);

  wbFurnitureAnimTypeEnum := wbEnum([
    {0} 'Unknown 0',
    {1} 'Sit',
    {2} 'Lay',
    {3} '',
    {4} 'Lean'
  ]);

  wbFurnitureEntryTypeFlags := wbFlags([
    {0x01} 'Front',
    {0x02} 'Behind',
    {0x04} 'Right',
    {0x08} 'Left',
    {0x10} 'Up'
  ]);

  wbWardStateEnum := wbEnum([
    'None',
    'Absorb',
    'Break'
  ]);

  wbEventFunctionEnum := wbEnum([
    'GetIsID',
    'IsInList',
    'GetValue',
    'HasKeyword',
    'GetItemValue'
  ]);

  // Event member names and availability are different depending on event type
  // Using generic names for the last 3 of them: Form, Value1, Value2
  wbEventMemberEnum := wbEnum([], [
    $0000, 'None',
    $3146, 'Form',          { F1: ObjectForm, SpellForm, Infection, pCrimeGroup, Weapon Aimed, Voice Power }
    $3147, 'Global',        { G1: GlobalValue }
    $3149, 'Identifier',    { I1: QuestID }
    $314B, 'Keyword1',      { K1: GameModeKeyword, Keyword }
    $324B, 'Keyword2',      { K2: (Exists but unused) }
    $334B, 'Keyword3',      { K3: (Exists but unused) }
    $314C, 'Location1',     { L1: Location, Old Location, BenchLocation, EncounterPointA }
    $324C, 'Location2',     { L2: New Location, EncounterPointB }
    $334C, 'Location3',     { L3: EncounterPointC }
    $314F, 'CreatedObject', { O1: CreatedObject }
    $3150, 'Player1',       { P1: Player, Victim }
    $3250, 'Player2',       { P2: Criminal }
    $3251, 'Quest1',        { Q1: Quest }
    $3152, 'Reference1',    { R1: Victim, OwnerRef, ArrestingGuard, ActorSeesObject, Actor, CastingActor, Workbench, Actor 1, Actor , Computer, Transmitting Actor, Actor in Ironsights, hGuard, hCriminal, RootObject, NPC 1, Ref 1, OwningActor }
    $3252, 'Reference2',    { R2: Attacker, Killer, Mine, OriginalContainer, Criminal, Object, SpellTarget, Actor 2, Dead Actor, hGuard, Lock Object, NPC 2, ItemRef, Ref 2, Trespasser }
    $3352, 'Reference3',    { R3: Workshop, Player }
    $3156, 'Value1',        { V1: Crime, Crime Status, AquireType, iCrimeType, iCommanded, iBountyAmount, Gold Value, Success, New Level, Crime Gold, Is Crime, Connected, Old Relationship, RemoveType, Value 1 }
    $3256, 'Value2',        { V2: Relationship Rank to Killer Before Death, ItemValue, iBountyReason, New Relationship, Value 2, Days Jail }
    $7FFFFFFF, 'All'
  ]);

  wbWeaponAnimTypeEnum := wbEnum([
    {0} 'HandToHandMelee',
    {1} 'OneHandSword',
    {2} 'OneHandDagger',
    {3} 'OneHandAxe',
    {4} 'OneHandMace',
    {5} 'TwoHandSword',
    {6} 'TwoHandAxe',
    {7} 'Bow',
    {8} 'Staff',
    {9} 'Gun',
    {10}'Grenade',
    {11}'Mine'
  ]);

  wbReverbClassEnum := wbEnum([
    'Default',
    'Class A',
    'Class B',
    'Class C',
    'Class D',
    'Class E'
  ]);

  wbHitBehaviourEnum := wbEnum([
    'Normal formula behaviour',
    'Dismember only',
    'Explode only',
    'No dismember or explode'
  ]);

  wbLGDIStarSlot := wbEnum([
    'First Star Slot',
    'Second Star Slot',
    'Third Star Slot',
    'Fourth Star Slot',
    'Fifth Star Slot'
  ]);

  wbPrefixEnum := wbEnum([

  ]);

  wbSuffixEnum := wbEnum([

  ]);

  wbEDID := wbStringKC(EDID, 'Editor ID', 0, cpOverride);
  wbFULL := wbLStringKC(FULL, 'Name', 0, cpTranslate);
  wbFULLActor := wbLStringKC(FULL, 'Name', 0, cpTranslate, False, nil{wbActorTemplateUseBaseData});
  wbFULLReq := wbLStringKC(FULL, 'Name', 0, cpTranslate, True);
  wbDESC := wbLStringKC(DESC, 'Description', 0, cpTranslate);
  wbDESCReq := wbLStringKC(DESC, 'Description', 0, cpTranslate, True);
  wbXSCL := wbFloat(XSCL, 'Scale');

  wbDURL := wbString(DURL);

  wbOPDS := wbStruct(OPDS, 'Object Placement Default', [
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown')
  ]);

  wbDEFL := wbFormIDCk(DEFL, 'Default Layer', [LAYR]);

  wbBEVA := wbInteger(BEVA,'Boolean Value', itU8, wbBoolEnum);
  wbFEVA := wbFloat(FEVA, 'Float Value');

  wbOPDSs:= wbRArray('Object Placement Defaults', wbOPDS);
  wbFTAGs:= wbRArray('Form Tags', wbString(FTAG, 'Form Tag'));

  wbNTWK := wbEmpty(NTWK, 'Network? Marker');

  wbENLM := wbUnknown(ENLM);

  wbENLT := wbByteRGBA(ENLT, 'Unknown');

  wbENLS := wbFloat(ENLS, 'Enlighten Scale');

  wbAUUV := wbStruct(AUUV, 'Unknown (Ignored in EXE)', [
    { 0} wbByteArray('Unknown', 1).IncludeFlag(dfNoReport),
    { 1} wbByteArray('Padding?', 3, cpIgnore).IncludeFlag(dfNoReport),
    { 4} wbFloat('Unknown'),
    { 8} wbFloat('Unknown'),
    {12} wbFloat('Unknown'),
    {16} wbFloat('Unknown'),
    {20} wbFloat('Unknown'),
    {24} wbByteArray('Unknown', 1).IncludeFlag(dfNoReport),
    {25} wbByteArray('Padding?', 3, cpIgnore).IncludeFlag(dfNoReport)
  ]).IncludeFlag(dfCollapsed);  // Entirely unused or processed, always collapsed

  wbSNTP := wbFormIDCk(SNTP, 'Snap Template', [STMP]);

  wbXALGFlags := wbFlags([
    {0x00000001} 'Unknown 1 (No Havok??)',
    {0x00000002} 'Unknown 2',
    {0x00000004} 'Unknown 3 (Reference??)',
    {0x00000008} 'Unknown 4',
    {0x00000010} 'Unknown 5',
    {0x00000020} 'Unknown 6', //Unused
    {0x00000040} 'Unknown 7',
    {0x00000080} 'Unknown 8',
    {0x00000100} 'Atom Shop Item',
    {0x00000200} 'Unknown 10',
    {0x00000400} 'Unknown 11',
    {0x00000800} 'Fallout 1st',
    {0x00001000} 'Unknown 13',
    {0x00002000} 'Unknown 14',
    {0x00004000} 'Unknown 15', //Unused
    {0x00008000} 'Unknown 16', //Unused
    {0x00010000} 'Unknown 17', //Unused
    {0x00020000} 'Unknown 18', //Unused
    {0x00040000} 'Unknown 19', //Unused
    {0x00080000} 'Unknown 20', //Unused
    {0x00100000} 'Unknown 21', //Unused
    {0x00200000} 'Unknown 22', //Unused
    {0x00400000} 'Unknown 23', //Unused
    {0x00800000} 'Unknown 24', //Unused
    {0x01000000} 'Unknown 25', //Unused
    {0x02000000} 'Unknown 26', //Unused
    {0x04000000} 'Unknown 27', //Unused
    {0x08000000} 'Unknown 28', //Unused
    {0x10000000} 'Unknown 29', //Unused
    {0x20000000} 'Unknown 30', //Unused
    {0x40000000} 'Unknown 31', //Unused
    {0x80000000} 'Unknown 32'  //Unused
  ]);

  wbXFLGFlags := wbFlags([
    {0x0000000000000001} 'Unknown 1',
    {0x0000000000000002} 'Unknown 2',
    {0x0000000000000004} 'Unknown 3',
    {0x0000000000000008} 'Unknown 4',
    {0x0000000000000010} 'Unknown 5',
    {0x0000000000000020} 'Unknown 6',
    {0x0000000000000040} 'Unknown 7',
    {0x0000000000000080} 'Unknown 8',
    {0x0000000000000100} 'Unknown 9',
    {0x0000000000000200} 'Unknown 10',
    {0x0000000000000400} 'Unknown 11',
    {0x0000000000000800} 'Unknown 12',
    {0x0000000000001000} 'Unknown 13',
    {0x0000000000002000} 'Unknown 14',
    {0x0000000000004000} 'Unknown 15',
    {0x0000000000008000} 'Unknown 16',
    {0x0000000000010000} 'Unknown 17',
    {0x0000000000020000} 'Unknown 18',
    {0x0000000000040000} 'Unknown 19',
    {0x0000000000080000} 'Unknown 20',
    {0x0000000000100000} 'Unknown 21',
    {0x0000000000200000} 'Unknown 22',
    {0x0000000000400000} 'Unknown 23',
    {0x0000000000800000} 'Unknown 24',
    {0x0000000001000000} 'Unknown 25',
    {0x0000000002000000} 'Unknown 26',
    {0x0000000004000000} 'Unknown 27',
    {0x0000000008000000} 'Unknown 28',
    {0x0000000010000000} 'Unknown 29',
    {0x0000000020000000} 'Unknown 30',
    {0x0000000040000000} 'Unknown 31',
    {0x0000000080000000} 'Unknown 32',
    {0x0000000100000000} 'Unknown 33',
    {0x0000000200000000} 'Unknown 34',
    {0x0000000400000000} 'Unknown 35',
    {0x0000000800000000} 'Unknown 36',
    {0x0000001000000000} 'Unknown 37',
    {0x0000002000000000} 'Unknown 38',
    {0x0000004000000000} 'Unknown 39',
    {0x0000008000000000} 'Unknown 40',
    {0x0000010000000000} 'Unknown 41',
    {0x0000020000000000} 'Unknown 42',
    {0x0000040000000000} 'Unknown 43',
    {0x0000080000000000} 'Unknown 44',
    {0x0000100000000000} 'Unknown 45',
    {0x0000200000000000} 'Unknown 46',
    {0x0000400000000000} 'Unknown 47',
    {0x0000800000000000} 'Unknown 48',
    {0x0001000000000000} 'Unknown 49',
    {0x0002000000000000} 'Unknown 50',
    {0x0004000000000000} 'Unknown 51',
    {0x0008000000000000} 'Unknown 52',
    {0x0010000000000000} 'Unknown 53',
    {0x0020000000000000} 'Unknown 54',
    {0x0040000000000000} 'Unknown 55',
    {0x0080000000000000} 'Unknown 56',
    {0x0100000000000000} 'Unknown 57',
    {0x0200000000000000} 'Unknown 58',
    {0x0400000000000000} 'Unknown 59',
    {0x0800000000000000} 'Unknown 60',
    {0x1000000000000000} 'Unknown 61',
    {0x2000000000000000} 'Unknown 62',
    {0x4000000000000000} 'Unknown 63',
    {0x8000000000000000} 'Unknown 64'
  ]);
  wbModelXFLG := wbInteger(XFLG, 'Flags', itU8, wbXFLGFlags);
  wbXFLG := wbInteger(XFLG, 'Flags', itU32, wbXFLGFlags);
  wbXFLGLong := wbInteger(XFLG, 'Flags', itU64, wbXFLGFlags);
  wbXALG := wbInteger(XALG, 'Flags', itU64, wbXALGFlags);
  wbXEZN := wbFormIDCk(XEZN, 'Encounter Zone', [LCTN]); // Encounter zones in FO76 are locations
  wbXLCN := wbFormIDCk(XLCN, 'Location', [LCTN]);

  wbNAM1 := wbUnknown(NAM1);
  wbLODP := wbUnknown(LODP);

  wbWTFG := wbInteger(WTFG, 'World Type', itU32, wbFlags([ {Based on 1 << world type enum value. For WTFG of 0 or not existing it sets it to 0x3E which is everything except invalid }
      {0x00000001} 'Invalid',
      {0x00000002} 'Adventure',
      {0x00000004} 'Survival',
      {0x00000008} 'NWTemp',
      {0x00000010} 'Nuclear Winter',
      {0x00000020} 'Private'
      ]));

  wbVCRY := wbFormIDCk(VCRY, 'Value Currency', [NULL, CNCY]);

  wbXCHG := wbByteArray(XCHG, 'Charge', 4);

  wbXLKR := wbRArrayS('Linked References', wbStructSK(XLKR, [0], 'Linked Reference', [
    wbFormIDCk('Keyword/Ref', [KYWD, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
    wbFromSize(8, wbFormIDCk('Ref', sigReferences))
  ], cpNormal, False, nil, 1));

  wbXATP := wbEmpty(XATP, 'Activation Point');
  wbXWPK := wbRStruct('Workshop Pack-in', [
    wbEmpty(XWPK, 'Start Marker'),
    wbFormID(GNAM, 'Pack-in'),
    wbFormID(HNAM, 'Reference'),
    wbInteger(INAM, 'Unknown Bool', itU16, wbBoolEnum),
    wbEmpty(XWPK, 'End Marker')
  ], []);

  wbWaterData := wbRStruct('Water Data', [
      wbInteger(XWCN, 'Data Count', itU32),
      wbArray(XWCU, 'Water Velocities', wbStruct('Water Velocity', [
        wbFloat('X Offset'),
        wbFloat('Y Offset'),
        wbFloat('Z Offset'),
        wbFloat('Unknown')
      ]), ['Linear','Angular','Unknown'])
    ], []);

  wbNAM1LODP := wbRStruct('Unknown', [
    wbNAM1,
    wbLODP
  ], []);

  wbPHSTFlags := wbFlags([
    {0x00000001} 'Unknown 1',
    {0x00000002} 'Unknown 2',
    {0x00000004} 'Unknown 3',
    {0x00000008} 'Unknown 4',
    {0x00000010} 'Unknown 5',
    {0x00000020} 'Unknown 6',
    {0x00000040} 'Unknown 7',
    {0x00000080} 'Unknown 8',
    {0x00000100} 'Unknown 9',
    {0x00000200} 'Unknown 10',
    {0x00000400} 'Unknown 11',
    {0x00000800} 'Unknown 12',
    {0x00001000} 'Unknown 13',
    {0x00002000} 'Unknown 14',
    {0x00004000} 'Unknown 15',
    {0x00008000} 'Unknown 16',
    {0x00010000} 'Unknown 17',
    {0x00020000} 'Unknown 18',
    {0x00040000} 'Unknown 19',
    {0x00080000} 'Unknown 20',
    {0x00100000} 'Unknown 21',
    {0x00200000} 'Unknown 22',
    {0x00400000} 'Unknown 23',
    {0x00800000} 'Unknown 24',
    {0x01000000} 'Unknown 25',
    {0x02000000} 'Unknown 26',
    {0x04000000} 'Unknown 27',
    {0x08000000} 'Unknown 28',
    {0x10000000} 'Unknown 29',
    {0x20000000} 'Unknown 30',
    {0x40000000} 'Unknown 31',
    {0x80000000} 'Unknown 32'
  ], True);

  wbPHST := wbInteger(PHST, 'Unknown Flags', itU32, wbPHSTFlags);

  wbDOFA := wbStruct(DOFA, 'Destructible Object Faction', [
    wbFormIDCk('Faction', [FACT]),
    wbInteger('Rank', itS8)
  ]);

  wbQSTI := wbFormIDCk(QSTI, 'Quest', [QUST]);

  wbPropTypeEnum := wbEnum([
    {00} 'None',
    {01} 'Object',
    {02} 'String',
    {03} 'Int32',
    {04} 'Float',
    {05} 'Bool',
    {06} 'Variable',
    {07} 'Struct',
    {08} '',
    {09} '',
    {10} '',
    {11} 'Array of Object',
    {12} 'Array of String',
    {13} 'Array of Int32',
    {14} 'Array of Float',
    {15} 'Array of Bool',
    {16} 'Array of Variable',
    {17} 'Array of Struct'
  ]);

  wbScriptFlags := wbInteger('Flags', itU8, wbEnum([
    {0x00} 'Local',
    {0x01} 'Inherited',
    {0x02} 'Removed',
    {0x03} 'Inherited and Removed'
  ]));

  wbScriptPropertyObject := wbUnion('Object Union', wbScriptObjFormatDecider, [
    wbStructSK([1], 'Object v2', [
      wbInteger('Unused', itU16, nil, cpIgnore, False, wbNeverShow),
      wbInteger('Alias', itS16, wbScriptObjectAliasToStr, wbStrToAlias).SetDefaultEditValue('None'),
      wbFormID('FormID').IncludeFlag(dfNoReport)
    ], [2, 1, 0])
      .SetSummaryKey([2, 1])
      .SetSummaryMemberPrefixSuffix(2, '', '')
      .SetSummaryMemberPrefixSuffix(1, ', Alias[', ']')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey),
    wbStructSK([1], 'Object v1', [
      wbFormID('FormID'),
      wbInteger('Alias', itS16, wbScriptObjectAliasToStr, wbStrToAlias),
      wbInteger('Unused', itU16, nil, cpIgnore)
    ])
      .SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '', '')
      .SetSummaryMemberPrefixSuffix(1, ', Alias[', ']')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
  ]);

  wbScriptPropertyStruct :=
    wbArrayS('Struct', wbStructSK([0], 'Member', [
      wbLenString('memberName', 2),
      wbInteger('Type', itU8, wbPropTypeEnum, cpNormal, False, nil, wbScriptPropertyTypeAfterSet),
      wbInteger('Flags', itU8, wbEnum([
        {0x00} '',
        {0x01} 'Edited',
        {0x02} '',
        {0x03} 'Removed'
      ])).SetDefaultEditValue('Edited'),
      wbUnion('Value', wbScriptPropertyDecider, [
        {00} wbNull,
        {01} wbScriptPropertyObject,
        {02} wbLenString('String', 2).OverrideEncoding(wbEncodingVMAD),
        {03} wbInteger('Int32', itS32),
        {04} wbFloat('Float'),
        {05} wbInteger('Bool', itU8, wbBoolEnum),
        {06} wbRecursive('Struct', 3), // Variable. No idea if possible or how to decode, leaving like that for the moment
        {07} wbRecursive('Struct', 3),
        {11} wbArray('Array of Object', wbScriptPropertyObject, -1),
        {12} wbArray('Array of String', wbLenString('Element', 2).OverrideEncoding(wbEncodingVMAD), -1),
        {13} wbArray('Array of Int32', wbInteger('Element', itS32), -1),
        {14} wbArray('Array of Float', wbFloat('Element'), -1),
        {15} wbArray('Array of Bool', wbInteger('Element', itU8, wbBoolEnum), -1),
        {17} wbArray('Array of Struct', wbRecursive('Struct', 4), -1)
      ])
    ]), -1, cpNormal, False);

  wbScriptProperty :=
    wbStructSK([0], 'Property', [
      wbLenString('propertyName', 2),
      wbInteger('Type', itU8, wbPropTypeEnum, cpNormal, False, nil, wbScriptPropertyTypeAfterSet),
      wbInteger('Flags', itU8, wbEnum([
        {0x00} '',
        {0x01} 'Edited',
        {0x02} '',
        {0x03} 'Removed'
      ])).SetDefaultEditValue('Edited'),
      wbUnion('Value', wbScriptPropertyDecider, [
       {00} wbNull,
       {01} wbScriptPropertyObject,
       {02} wbLenString('String', 2).OverrideEncoding(wbEncodingVMAD),
       {03} wbInteger('Int32', itS32),
       {04} wbFloat('Float'),
       {05} wbInteger('Bool', itU8, wbBoolEnum),
       {06} wbScriptPropertyStruct, // Variable. No idea if possible or how to decode, leaving like that for the moment
       {07} wbScriptPropertyStruct,
       {11} wbArray('Array of Object', wbScriptPropertyObject, -1),
       {12} wbArray('Array of String', wbLenString('Element', 2).OverrideEncoding(wbEncodingVMAD), -1),
       {13} wbArray('Array of Int32', wbInteger('Element', itS32), -1),
       {14} wbArray('Array of Float', wbFloat('Element'), -1),
       {15} wbArray('Array of Bool', wbInteger('Element', itU8, wbBoolEnum), -1),
       {17} wbArray('Array of Struct', wbScriptPropertyStruct, -1)
      ])
    ])
    .SetSummaryKey([1, 3])
    .SetSummaryMemberPrefixSuffix(0, '', ':')
    .SetSummaryMemberPrefixSuffix(3, '= ', '')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseScriptProperties);

  wbScriptProperties :=
    wbArrayS('Properties', wbScriptProperty, -2, cpNormal, False, nil, nil, nil, wbCanAddScriptProperties);

  wbScriptEntry := wbStructSK([0], 'Script', [
    wbLenString('ScriptName', 2),
    wbScriptFlags,
    wbScriptProperties
  ]);

  wbScriptFragmentsInfo := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(4),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd'
    ])),
    wbScriptEntry,
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ]), [], wbScriptFragmentsInfoCounter)
  ]);

  wbScriptFragmentsPack := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(4),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd',
      {4} 'OnChange'
    ])),
    wbScriptEntry,
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd, OnChange
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ]), [], wbScriptFragmentsPackCounter)
  ]);

  wbScriptFragmentsQuest := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(4),
    wbInteger('FragmentCount', itU16, nil, cpBenign),
    wbLenString('ScriptName', 2).SetAfterSet(wbScriptFragmentsQuestScriptNameAfterSet),
    // if ScriptName = "" then no Flags and Properties
    wbUnion('Script', wbScriptFragmentsEmptyScriptDecider, [
      wbStruct('Script Data', [
        wbScriptFlags,
        wbScriptProperties
      ]),
//       Quest [000179EF] <DialogueGenericPlayer>
//       Quest [000792CA] <DialogueGenericMerchants> "Merchant Dialogue System"
//       Quest [00091FE1] <DialogueDiamondCityChapel>
//       MQ101KelloggSequence "Kellogg Sequence in Vault 111" [QUST:000D3997]
//       DialogueGlowingSeaAtom "Children of the Atom Dialogue" [QUST:0012DB31]
//       BoSIdleHandlerQuest [QUST:00157460]
      wbNull
    ]),
    wbArrayS('Fragments',
      wbStructSK([0, 2], 'Fragment', [
        wbInteger('Quest Stage', itU16),
        wbInteger('Unknown', itS16),
        wbInteger('Quest Stage Index', itS32),
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
    ).SetCountPath('FragmentCount', True)
  ]);

  wbScriptFragmentsScen := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(4),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd'
    ])),
    wbScriptEntry,
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ]), [], wbScriptFragmentsSceneCounter),
    wbArray('Phase Fragments',
      wbStructSK([0, 1], 'Phase Fragment', [
        wbInteger('Phase Flag', itU8, wbFlags([
          {1} 'OnStart',
          {2} 'OnCompletion'
        ])),
        wbInteger('Phase Index', itU8),
        wbInteger('Unknown', itS16),
        wbInteger('Unknown', itS8),
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ]), -2)
  ]);

  wbScriptFragments := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(4),
    wbScriptEntry,
    wbArrayS('Fragments',
      wbStructSK([0], 'Fragment', [
        wbInteger('Fragment Index', itU16),
        wbInteger('Unused', itS16, nil, cpIgnore, False, wbNeverShow),
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ]), -2)
  ]);

  {>>> http://www.uesp.net/wiki/Tes5Mod:Mod_File_Format/VMAD_Field <<<}

  wbVMAD := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts)
  ]);

  wbVMADFragmentedPERK := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts),
    wbScriptFragments,
    wbUnknown
  ], cpNormal, False, nil, 3);

  wbVMADFragmentedPACK := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts),
    wbScriptFragmentsPack
  ], cpNormal, False, nil, 3);

  wbVMADFragmentedQUST := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts),
    wbScriptFragmentsQuest,
    wbArrayS('Aliases', wbStructSK([0], 'Alias', [
      wbScriptPropertyObject,
      wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
      wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
      wbArrayS('Alias Scripts', wbScriptEntry, -2)
    ]), -2)
  ], cpNormal, False, nil, 3);

  wbVMADFragmentedSCEN := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts),
    wbScriptFragmentsScen
  ], cpNormal, False, nil, 3);

  wbVMADFragmentedINFO := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(6),
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2),
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts),
    wbScriptFragmentsInfo
  ], cpNormal, False, nil, 3);

  wbLocationEnum := wbEnum([
    {0} 'Near reference', // string dump: '%s' in '%s' radius %u
    {1} 'In cell', // string dump: In cell '%s'
    {2} 'Near package start location', // string dump: Near package start location, radius %u
    {3} 'Near editor location', // string dump: Near editor location, radius %u
    {4} 'Object ID',
    {5} 'Object Type',
    {6} 'Near linked reference', // string dump: Near linked reference, radius %u%s%s
    {7} 'At package location', // string dump: At package location, radius %u
    {8} 'Alias (reference)', // string dump: Alias: %s [item #%u], radius %u
    {9} 'Alias (location)', // string dump: Alias: %s, radius %u
   {10} 'Target', // string dump: <Target>
   {11} 'Target (location)', // string dump: Target: %s, radius %u
   {12} 'Near self', // Near Self, radius %u
   {13} 'Near Editor Location Cell',
   {14} 'Alias (ref collection)'
  ]);

  wbObjectTypeEnum := wbEnum([
    { 0} 'NONE',
    { 1} 'Activators',
    { 2} 'Armor',
    { 3} 'Books',
    { 4} 'Containers',
    { 5} 'Doors',
    { 6} 'Ingredients',
    { 7} 'Lights',
    { 8} 'Miscellaneous',
    { 9} 'Flora',
    {10} 'Furniture',
    {11} 'Weapons: Any',
    {12} 'Ammo',
    {13} 'Keys',
    {14} 'Alchemy',
    {15} 'Food',
    {16} 'Clothing',
    {17} 'All: Wearable',
    {18} 'Weapons: NONE',
    {19} 'Weapons: Melee',
    {20} 'Weapons: Ranged',
    {21} 'Spells: Any',
    {22} 'Spells: Range Target',
    {23} 'Spells: Range Touch',
    {24} 'Spells: Range Self',
    {25} 'Actors: Any',
    {26} 'Furniture: Beds',
    {27} 'Furniture: Chairs',
    {28} 'Shouts',
    {29} 'Headtrack Markers',
    {30} 'Players: Any'
  ]);

  wbPLDT := wbStruct(PLDT, 'Location', [
    wbInteger('Type', itS32, wbLocationEnum),
    wbUnion('Location Value', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', sigReferences),
      {1} wbFormIDCkNoReach('Cell', [NULL, CELL]),
      {2} wbByteArray('Near Package Start Location', 4, cpIgnore),
      {3} wbByteArray('Near Editor Location', 4, cpIgnore),
      {4} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, OMOD, BOOK, NOTE, KEYM, ALCH, INGR, LIGH, FACT, FLST, IDLM, TXST, PROJ]),
      {5} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {6} wbFormIDCk('Keyword', [NULL, KYWD]),
      {7} wbByteArray('Unused', 4, cpIgnore),
      {8} wbInteger('Ref Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {9} wbInteger('Loc Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
     {10} wbInteger('Interrupt Data', itU32),
     {11} wbInteger('Packdata Target', itU32),
     {12} wbByteArray('Unknown', 4, cpIgnore),
     {13} wbByteArray('Unknown', 4),
     {14} wbInteger('Ref Collection Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias)
    ]),
    wbInteger('Radius', itS32),
    wbInteger('Collection Index', itU32)
  ], cpNormal, False, nil, 3);

  wbPLVD := wbStruct(PLVD, 'Location', [
    wbInteger('Type', itS32, wbLocationEnum),
    wbUnion('Location Value', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', sigReferences),
      {1} wbFormIDCkNoReach('Cell', [NULL, CELL]),
      {2} wbByteArray('Near Package Start Location', 4, cpIgnore),
      {3} wbByteArray('Near Editor Location', 4, cpIgnore),
      {4} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, OMOD, BOOK, NOTE, KEYM, ALCH, INGR, LIGH, FACT, FLST, IDLM, TXST, PROJ]),
      {5} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {6} wbFormIDCk('Keyword', [NULL, KYWD]),
      {7} wbByteArray('Unused', 4, cpIgnore),
      {8} wbInteger('Ref Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {9} wbInteger('Loc Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
     {10} wbInteger('Interrupt Data', itU32),
     {11} wbInteger('Packdata Target', itU32),
     {12} wbByteArray('Unknown', 4, cpIgnore),
     {13} wbByteArray('Unknown', 4),
     {14} wbInteger('Ref Collection Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias)
    ]),
    wbInteger('Radius', itS32),
    wbInteger('Collection Index', itU32)
  ], cpNormal, False, nil, 3);

  wbTargetData := wbStruct('Target Data', [
    wbInteger('Type', itS32, wbEnum([
      {0} 'Specific Reference',
      {1} 'Object ID',
      {2} 'Object Type',
      {3} 'Linked Reference',
      {4} 'Ref Alias',
      {5} 'Interrupt Data',
      {6} 'Self',
      {7} 'Keyword',
      {8} 'Unknown 8'
    ]), cpNormal, False, nil, nil, 2),
    wbUnion('Target', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', sigReferences, True),
      {1} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, OMOD, BOOK, NOTE, KEYM, ALCH, INGR, LIGH, FACT, FLST, IDLM, TXST, PROJ]),
      {2} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {3} wbFormIDCk('Keyword', [KYWD, NULL]),
      {4} wbInteger('Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {5} wbInteger('Interrupt Data', itU32),
      {6} wbByteArray('Unknown', 4, cpIgnore),
      {7} wbFormIDCk('Keyword', [KYWD, NULL]),
      {8} wbByteArray('Unknown', 4, cpIgnore)
    ]),
    wbInteger('Count / Distance', itS32)
  ]);

  wbEITM := wbFormIDCk(EITM, 'Object Effect', [ENCH, SPEL]);

  wbMODS := wbFormIDCk(MODS, 'Material Swap', [MSWP]);
  wbMO2S := wbFormIDCk(MO2S, 'Material Swap', [MSWP]);
  wbMO3S := wbFormIDCk(MO3S, 'Material Swap', [MSWP]);
  wbMO4S := wbFormIDCk(MO4S, 'Material Swap', [MSWP]);
  wbMO5S := wbFormIDCk(MO5S, 'Material Swap', [MSWP]);

  wbMODF := wbUnknown(MODF);
  wbMO2F := wbUnknown(MO2F);
  wbMO3F := wbUnknown(MO3F);
  wbMO4F := wbUnknown(MO4F);
  wbMO5F := wbUnknown(MO5F);

  wbMODC := wbFloat(MODC, 'Color Remapping Index');
  wbMO2C := wbFloat(MO2C, 'Color Remapping Index');
  wbMO3C := wbFloat(MO3C, 'Color Remapping Index');
  wbMO4C := wbFloat(MO4C, 'Color Remapping Index');
  wbMO5C := wbFloat(MO5C, 'Color Remapping Index');

  wbMODD := wbByteArray(MODD, 'Unknown', 1);

  wbDMDS := wbFormIDCk(DMDS, 'Material Swap', [MSWP]);
  wbDMDC := wbFloat(DMDC, 'Color Remapping Index');

  wbXESP := wbStruct(XESP, 'Enable Parent', [
    wbFormIDCk('Reference', sigReferences),
    wbInteger('Flags', itU8, wbFlags([
      'Set Enable State to Opposite of Parent',
      'Pop In'
    ])),
    wbByteArray('Unused', 3, cpIgnore)
  ]);

  wbXLWT := wbFloat(XLWT, 'Light Weight');

  wbPDTO :=
    wbStruct(PDTO, 'Topic Data', [
      wbInteger('Type', itU32, wbEnum([
        'Topic Ref',
        'Topic Subtype'
      ])),
      wbUnion('Data', wbTypeDecider, [
        wbFormIDCk('Topic', [DIAL, NULL]),
        wbString('Subtype', 4)
      ])
    ]);

  wbPDTOs := wbRArray('Topic', wbPDTO, cpNormal, False, nil);

  wbXLCM := wbInteger(XLCM, 'Leveled Creature Modifier', itS32, wbEnum([
    'Easy',
    'Medium',
    'Hard',
    'Very Hard'
  ]));

  wbXOWN := wbStruct(XOWN, 'Owner', [
    wbFormIDCkNoReach('Owner', [FACT, ACHR, NPC_]),
    wbFromVersion(84, wbByteArray('Unknown', 4)),
    wbFromVersion(84, wbInteger('Flags', itU8, wbFlags(['No Crime']))),
    wbFromVersion(84, wbByteArray('Unused', 3))
  ]);

  wbXRNK := wbInteger(XRNK, 'Owner Faction Rank', itS32);

	wbNVNM :=  wbUnion(NVNM, '', wbRecordSizeDecider([0]), [
    wbEmpty('Navmesh Marker'),
    wbNVNMRecordVal
  ]);

	wbNVNMRecordVal :=
    wbStruct('Navmesh Geometry', [
	    wbInteger('Version', itU32).SetDefaultNativeValue(15),
	    wbStruct('Pathing Cell', [
        wbInteger('CRC Hash', itU32, wbCRCValuesEnum).SetDefaultEditValue('PathingCell'),
        wbFormIDCk('Parent World', [WRLD, NULL]).IncludeFlag(dfSummaryExcludeNULL),
        wbUnion('Parent', wbNVNMParentDecider, [
          wbStruct('Coordinates', [
            wbInteger('Grid Y', itS16),
            wbInteger('Grid X', itS16)
          ]),
          wbFormIDCk('Parent Cell', [CELL])
        ])
	    ]).SetSummaryKey([2,1])
        .IncludeFlag(dfSummaryMembersNoName),
	    IfThen(wbSimpleRecords,
        wbArray('Vertices',
          wbByteArray('Vertex', 12),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Vertices',
			    wbVec3('Vertex'),
        -1).IncludeFlag(dfNotAlignable)
      ),
	    IfThen(wbSimpleRecords,
        wbArray('Triangles',
          wbByteArray('Triangle', 21),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Triangles',
			    wbStruct('Triangle', [
				    wbInteger('Vertex 0', itU16, wbVertexToStr0, wbVertexToInt0).SetLinksToCallback(wbVertexLinksTo),
				    wbInteger('Vertex 1', itU16, wbVertexToStr1, wbVertexToInt1).SetLinksToCallback(wbVertexLinksTo),
				    wbInteger('Vertex 2', itU16, wbVertexToStr2, wbVertexToInt2).SetLinksToCallback(wbVertexLinksTo),
				    wbInteger('Edge 0-1', itS16, wbEdgeToStr0, wbEdgeToInt0).SetLinksToCallback(wbEdgeLinksTo0),
				    wbInteger('Edge 1-2', itS16, wbEdgeToStr1, wbEdgeToInt1).SetLinksToCallback(wbEdgeLinksTo1),
				    wbInteger('Edge 2-0', itS16, wbEdgeToStr2, wbEdgeToInt2).SetLinksToCallback(wbEdgeLinksTo2),
				    wbFloat('Height'),
            wbInteger('Unknown', itU8),
				    wbInteger('Flags', itU16, wbNavmeshTriangleFlags)
              .IncludeFlag(dfCollapsed, wbCollapseFlags),
            wbInteger('Cover Flags', itU16, wbNavmeshCoverFlags)
              .IncludeFlag(dfCollapsed, wbCollapseFlags)
			    ]),
        -1).IncludeFlag(dfNotAlignable)
      ),
	    wbArray('Edge Links',
		    wbStruct('Edge Link', [
			    wbInteger('Type', itU32, wbNavmeshEdgeLinkEnum),
			    wbFormIDCk('Navmesh', [NAVM], False, cpIgnore),
			    wbInteger('Triangle', itS16, nil, cpIgnore),
			    wbByteArray('Edge Index', 1, cpIgnore)
		    ], cpIgnore),
      -1, cpIgnore).IncludeFlag(dfNotAlignable),
	    wbArrayS('Door Links',
		    wbStructSK([0, 2], 'Door Link', [
			    wbInteger('Triangle', itU16).SetLinksToCallback(wbTriangleLinksTo),
 			    wbInteger('CRC Hash', itU32, wbCRCValuesEnum).SetDefaultEditValue('PathingDoor'),
			    wbFormIDCk('Door Ref', [REFR])
		    ]),
      -1),
	    IfThen(wbSimpleRecords,
        wbArray('Cover Array',
          wbByteArray('Cover', 8),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Cover Array',
			    wbStruct('Cover', [
				    wbInteger('Vertex 1', itU16).SetLinksToCallback(wbVertexLinksTo),
				    wbInteger('Vertex 2', itU16).SetLinksToCallback(wbVertexLinksTo),
				    wbByteArray('Data', 4)
			    ]),
        -1).IncludeFlag(dfNotAlignable)
      ),
	    IfThen(wbSimpleRecords,
        wbArray('Cover Triangle Mappings',
          wbByteArray('Cover Triangle', 4),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Cover Triangle Mappings',
			    wbStruct('Cover Triangle Map', [
				    wbInteger('Cover', itU16).SetLinksToCallback(wbCoverLinksTo),
				    wbInteger('Triangle', itU16).SetLinksToCallback(wbTriangleLinksTo)
			    ]),
        -1).IncludeFlag(dfNotAlignable)
      ),
	    IfThen(wbSimpleRecords,
        wbArray('Waypoints',
          wbByteArray('Waypoint', 18),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Waypoints',
			    wbStruct('Waypoint', [
				    wbFloat('X'),
				    wbFloat('Y'),
				    wbFloat('Z'),
				    wbInteger('Triangle', itU16).SetLinksToCallback(wbTriangleLinksTo),
				    wbInteger('Flags', itU32)
			    ]),
        -1).IncludeFlag(dfNotAlignable)
      ),
      wbStruct('Navmesh Grid', [
        wbInteger('Divisor', itU32),
        wbStruct('Grid Size', [
          wbFloat('X'),
          wbFloat('Y')
        ]),
        wbVec3('Min'),
        wbVec3('Max'),
        IfThen(wbSimpleRecords,
          wbArray('Cells',
            wbArray('Cell',
              wbByteArray('Triangle', 2),
            -1).SetSummaryName('Triangles')
               .IncludeFlag(dfNotAlignable),
          wbNavmeshGridCounter).IncludeFlag(dfNotAlignable),
          wbArray('Cells',
            wbArray('Cell',
              wbInteger('Triangle', itS16).SetLinksToCallback(wbTriangleLinksTo),
            -1).SetSummaryName('Triangles')
               .IncludeFlag(dfNotAlignable),
          wbNavmeshGridCounter).IncludeFlag(dfNotAlignable)
        )
      ])
	  ]);

  wbRefRecord(ACHR, 'Placed NPC',
    wbFlags(wbFlagsList([
      {0x00000200}  9, 'Starts Dead',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00002000} 13, 'Starts Unconscious',
      {0x02000000} 25, 'No AI Acquire',
      {0x20000000} 29, 'Don''t Havok Settle'
    ], True, True)), [
    wbEDID,
    wbVMAD,
    wbXALG,
    wbFormIDCk(NAME, 'Base', [NPC_], False, cpNormal, True),
    wbKWDAs,
    wbXEZN,

    {--- Ragdoll ---}
    wbXRGD,
    wbXRGB,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time', cpNormal, True),
      wbEmpty(XPPA, 'Patrol Script Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbPDTOs,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL], False, cpNormal)
    ], []),

    {--- Leveled Actor ----}
    wbXLCM,

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbInteger(XHLT, 'Health %', itU32),

    wbXLKR,

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', sigReferences),
          wbFloat('Delay')
        ])
      )
    ], []),
    wbEmpty(XATP, 'Activation Point'),

    wbEmpty(XLKT, 'Linked Ref Transient'),
    wbFormIDCk(XRFG, 'Reference Group', [RFGP]),
    wbFormIDCk(XLYR, 'Layer', [LAYR]),
    wbFormIDCk(XMSP, 'Material Swap', [MSWP]),

    wbXLWT,

    wbFormIDCk(XLCN, 'Persist Location', [LCTN]),
    wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),
    wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),

    wbEmpty(XIS2, 'Ignored by Sandbox'),
    wbRArray('Power Links', wbStruct(XPLK, 'Link', [
      wbFormIDCk('Ref', [REFR, ACHR]),
      wbUnknown  // always 00 00 00 00 so far in DLCWorkshop03.esm
    ])),
    wbFloat(XHTW, 'Head-Tracking Weight'),
    wbFloat(XFVC, 'Favor Cost'),

    {--- Enable Parent ---}
    wbXESP,

    {--- Ownership ---}
    wbXOWN,
    wbXRNK,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', sigReferences),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot,
    wbString(MNAM, 'Comments')
  ], True, wbPlacedAddInfo);

  wbVatsValueFunctionEnum :=
    wbEnum([
      { 0} 'Weapon Is',
      { 1} 'Weapon In List',
      { 2} 'Target Is',
      { 3} 'Target In List',
      { 4} 'Target Distance',
      { 5} 'Target Part',
      { 6} 'VATS Action',
      { 7} 'Is Success',
      { 8} 'Is Critical',
      { 9} 'Critical Effect Is',
      {10} 'Critical Effect In List',
      {11} 'Is Fatal',
      {12} 'Explode Part',
      {13} 'Dismember Part',
      {14} 'Cripple Part',
      {15} 'Weapon Type Is',
      {16} 'Is Stranger',
      {17} 'Is Paralyzing Palm',
      {18} 'Projectile Type Is',
      {19} 'Delivery Type Is',
      {20} 'Casting Type Is',
      {21} 'Is Synced Anim'
    ]);

  wbActorValueEnum :=
    wbEnum([
    {00} 'Aggression',
    {01} 'Confidence',
    {02} 'Energy',
    {03} 'Morality',
    {04} 'Mood',
    {05} 'Assistance',
    {06} 'Strength',
    {07} 'Perception',
    {08} 'Endurance',
    {09} 'Charisma',
    {10} 'Intelligence',
    {11} 'Agility',
    {12} 'Luck',
    {13} 'Experience',
    {14} 'AttackConditionAlt1',
    {15} 'AttackConditionAlt2',
    {16} 'IdleChatterTimeMin',
    {17} 'IdleChatterTimeMax',
    {18} 'Alteration',
    {19} 'AttackConditionAlt3',
    {20} 'Workshop Power Connection',
    {21} 'WorkshopID',
    {22} 'Animation Mult',
    {23} 'Weap Reload Speed Mult',
    {24} 'Health',
    {25} 'Action Points',
    {26} 'Unused Stamina',
    {27} 'Heal Rate',
    {28} 'Action Points Rate',
    {29} 'Condition Rate',
    {30} 'Speed Mult',
    {31} 'Rads Rate',
    {32} 'Carry Weight',
    {33} 'Critical Chance',
    {34} 'Melee Damage',
    {35} 'Unarmed Damage',
    {36} 'Mass',
    {37} 'Rads',
    {38} 'Voice Rate',
    {39} 'Damage Resist',
    {40} 'Poison Resist',
    {41} 'Resist Fire',
    {42} 'Resist Shock',
    {43} 'Resist Frost',
    {44} 'Resist Magic',
    {45} 'Resist Rad Ingestion',
    {46} 'Resist Rad Exposure',
    {47} 'Resist Energy',
    {48} 'Suspicious',
    {49} 'BloodyMess',
    {50} 'RadHealthMax',
    {51} 'Power Armor Head Condition',
    {52} 'Power Armor Torso Condition',
    {53} 'Power Armor Left Arm Condition',
    {54} 'Paralysis',
    {55} 'Invisibility',
    {56} 'Night Eye',
    {57} 'Workshop State',
    {58} 'Water Breathing',
    {59} 'Water Walking',
    {60} 'IgnoreCrippledLimbs',
    {61} 'Fame',
    {62} 'Infamy',
    {63} 'Workshop State Transition',
    {64} 'Ward Power',
    {65} 'Right Item Charge',
    {66} 'Armor Perks',
    {67} 'Shield Perks',
    {68} 'Workshop State Timeout',
    {69} 'Variable01',
    {70} 'Variable02',
    {71} 'Variable03',
    {72} 'Variable04',
    {73} 'Variable05',
    {74} 'Variable06',
    {75} 'Variable07',
    {76} 'Variable08',
    {77} 'Variable09',
    {78} 'Variable10',
    {79} 'Bow Speed Bonus',
    {80} 'Favor Active',
    {81} 'Favors Per Day',
    {82} 'Favors Per Day Timer',
    {83} 'Left Item Charge',
    {84} 'Absorb Chance',
    {85} 'Blindness',
    {86} 'Weapon Speed Mult',
    {87} 'Shout Recovery Mult',
    {88} 'Free Camp Placement',
    {89} 'Fall Speed Mult',
    {90} 'Favor Points Bonus',
    {91} 'Last Bribed Intimidated',
    {92} 'Last Flattered',
    {93} 'Movement Noise Mult',
    {94} 'Bypass Vendor Stolen Check',
    {95} 'Bypass Vendor Keyword Check',
    {96} 'Waiting For Player',
    {97} 'SkillMagAV01',
    {98} 'SkillMagAV02',
    {99} 'SkillMagAV03',
   {100} 'SkillMagAV04',
   {101} 'SkillMagAV05',
   {102} 'SkillMagAV06',
   {103} 'SkillMagAV07',
   {104} 'SkillMagAV08',
   {105} 'SkillMagAV09',
   {106} 'SkillMagAV10',
   {107} 'SkillMagAV11',
   {108} 'SkillMagAV12',
   {109} 'SkillMagAV13',
   {110} 'SkillMagAV14',
   {111} 'SkillMagAV15',
   {112} 'Player Level',
   {113} 'Deafness',
   {114} 'Power Generated',
   {115} 'Power Radiation',
   {116} 'Power Required',
   {117} 'Food',
   {118} 'Water',
   {119} 'Safety',
   {120} 'Bed',
   {121} 'Happiness',
   {122} 'Artillery',
   {123} 'Workshop Item Overlap',
   {124} 'Logic Operation',
   {125} 'Workshop Item Clamp Direction',
   {126} 'Workshop Item Z Offset',
   {127} 'Workshop Actor Wounded',
   {128} 'Workshop Player Owned',
   {129} 'Workshop Stackable Item',
   {130} 'Workshop Snap Point Radius',
   {131} 'Workshop Anything Is Ground',
   {132} 'Ignore Player While Frenzied',
   {133} 'Left Weapon Speed Multiply',
   {134} 'Produce Uses',
   {135} 'Combat Health Regen Mult',
   {136} 'Two-Handed Power Modifier',
   {137} 'Marksman Power Modifier',
   {138} 'Block Power Modifier',
   {139} 'Smithing Power Modifier',
   {140} 'Workshop Current Triangles',
   {141} 'Workshop Max Triangles',
   {142} 'Workshop Current Draws',
   {143} 'Workshop Max Draws',
   {144} 'Sneaking Power Modifier',
   {145} 'Workshop Ignore Simple Intersections',
   {146} 'Workshop Allow Unsupported Stacking',
   {147} 'Fatigue',
   {148} 'Fatigue AP Max',
   {149} 'Fatigue Rate',
   {150} 'Fatigue Rate Mult',
   {151} 'Logic Output',
   {152} 'Workshop Snap Transmits Power',
   {153} 'Rads Rate Mult',
   {154} 'Dragon Rend',
   {155} 'Attack Damage Mult',
   {156} 'Heal Rate Mult',
   {157} 'Action Points Rate Mult',
   {158} 'Condition Rate Mult',
   {159} 'Aim Stability',
   {160} 'Power Armor Battery',
   {161} 'Power Armor Right Arm Condition',
   {162} 'Power Armor Left Leg Condition',
   {163} 'Reflect Damage',
   {164} 'Crafting Ability General',
   {165} 'Crafting Ability Explosives',
   {166} 'Crafting Ability Guns',
   {167} 'Crafting Ability Mechanics',
   {168} 'Crafting Ability Medicine',
   {169} 'Crafting Ability Melee',
   {170} 'Crafting Ability Science',
   {171} 'Crafting Ability Survival',
   {172} 'Component Usage Mult Chemical',
   {173} 'Component Usage Mult Metallic',
   {174} 'Component Usage Mult Organic',
   {175} 'Component Usage Mult Technical',
   {176} 'Perception Condition',
   {177} 'Endurance Condition',
   {178} 'Left Attack Condition',
   {179} 'Right Attack Condition',
   {180} 'Left Mobility Condition',
   {181} 'Right Mobility Condition',
   {182} 'Brain Condition',
   {183} 'AvailableCondition1',
   {184} 'AvailableCondition2',
   {185} 'AvailableCondition3',
   {186} 'One Handed Weapons',
   {187} 'Two Handed Weapons',
   {188} 'Marksman',
   {189} 'Block',
   {190} 'Smithing',
   {191} 'Heavy Armor',
   {192} 'Light Armor',
   {193} 'PickPocket',
   {194} 'Lockpicking',
   {195} 'Sneak',
   {196} 'Alchemy',
   {197} 'Speechcraft',
   {198} 'Alteration',
   {199} 'Conjuration',
   {200} 'Destruction',
   {201} 'Illusion',
   {202} 'Restoration',
   {203} 'Enchanting',
   {204} 'Power Armor Right Leg Condition',
   {205} 'VANSPerk',
   {206} 'Workshop Level Object',
   {207} 'Workshop Level',
   {208} 'Workshop Level Health Percent',
   {209} 'Workshop Current Budget',
   {210} 'Workshop Flag Status',
   {211} 'Damage Resist PVP',
   {212} 'FreeQuickCampPlacement'
      ], [
        -1, 'None'
      ]);

  wbSkillEnum :=
    wbEnum([
      'Unknown 1',
      'Unknown 2',
      'Unknown 3',
      'Unknown 4',
      'Unknown 5',
      'Unknown 6',
      'One Handed',
      'Two Handed',
      'Marksman',
      'Block',
      'Smithing',
      'Heavy Armor',
      'Light Armor',
      'Pickpocket',
      'Lockpicking',
      'Sneak',
      'Alchemy',
      'Speech',
      'Alteration',
      'Conjuration',
      'Destruction',
      'Illusion',
      'Restoration',
      'Enchanting'
    ], [
    -1, 'None'
    ]);

  wbCastEnum := wbEnum([
    {0} 'Constant Effect',
    {1} 'Fire and Forget',
    {2} 'Concentration',
    {3} 'Scroll'
  ]);

  wbTargetEnum := wbEnum([
    {0} 'Self',
    {1} 'Contact',
    {2} 'Aimed',
    {3} 'Target Actor',
    {4} 'Target Location'
  ]);

  wbCastingSourceEnum := wbEnum([
    'Left',
    'Right',
    'Voice',
    'Instant'
  ]);

  wbCrimeTypeEnum :=
    wbEnum([
      'Steal',
      'Pickpocket',
      'Trespass',
      'Attack',
      'Murder',
      'Escape Jail'
    ], [
      -1, 'None'
    ]);

  wbKeywordTypeEnum :=
    wbEnum([
      {00} 'None',
      {01} 'Component Tech Level',
      {02} 'Attach Point',
      {03} 'Component Property',
      {04} 'Instantiation Filter',
      {05} 'Mod Association',
      {06} 'Sound',
      {07} 'Anim Archetype',
      {08} 'Function Call',
      {09} 'Recipe Filter',
      {10} 'Attraction Type',
      {11} 'Dialogue Subtype',
      {12} 'Quest Target',
      {13} 'Anim Flavor',
      {14} 'Anim Gender',
      {15} 'Anim Face',
      {16} 'Quest Group',
      {17} 'Anim Injured',
      {18} 'Dispel Effect',
      {19} 'Mod Attribute Name',
      {20} 'Mod Attribute Descriptor',
      {21} 'Icon',
      {22} 'Crafting Function',
      {23} 'Item Quality',
      {24} 'Component Quantity',
      {25} 'Atomic Shop Category',
      {26} 'Photomode Category',
      {27} 'Atomic Shop Filter',
      {28} 'Event Header',
      {29} 'Loot Bag',
      {30} 'Item Rarity'
    ]);

  wbETYP := wbFormIDCk(ETYP, 'Equipment Type', [EQUP, NULL]);
  wbETYPReq := wbFormIDCk(ETYP, 'Equipment Type', [EQUP, NULL], False, cpNormal, True);
  wbConditionFormTypeEnum := wbEnum([
    'Activator',
    'Armor',
    'Book',
    'Container',
    'Door',
    'Ingredient',
    'Light',
    'Misc Item',
    'Static Object',
    'Grass',
    'Tree',
    'Unknown 11',
    'Weapon',
    'Non-Player Character',
    'Leveled NPC',
    'Spell',
    'Enchantment',
    'Ingestible',
    'Leveled Item',
    'Key',
    'Ammunition',
    'Flora',
    'Furniture',
    'Sound Marker',
    'Land Texture',
    'Combat Style',
    'Load Screen',
    'Leveled Spell',
    'Animated Object',
    'Water',
    'Idle Marker',
    'Effect Shader',
    'Projectile',
    'Talking Activator',
    'Explosion',
    'Texture Set',
    'Debris',
    'Menu Icon',
    'List Form',
    'Perk',
    'Perk Card',
    'Body Part Data',
    'Addon Node',
    'Movable Static',
    'Camera Shot',
    'Impact Data',
    'Impact Data Set',
    'Quest',
    'Unknown 48',
    'Voice Type',
    'Class',
    'Race',
    'Eyes',
    'Head Part',
    'Faction',
    'Holotape',
    'Weather',
    'Climate',
    'Armor Addon',
    'Global',
    'Image Space',
    'Image Space Modifier',
    'Unknown 62',
    'Message',
    'Constructible Object',
    'Acoustic Space',
    'Unknown 66',
    'Script',
    'Effect Setting',
    'Music Type',
    'Static Collection',
    'Keyword',
    'Location',
    'Location Ref Type',
    'Footstep',
    'Footstep Set',
    'Material Type',
    'Action',
    'Music Track Form Helper',
    'Word Of Power',
    'Shout',
    'Relationship',
    'Equip Slot',
    'Association Type',
    'Outfit',
    'Art Object',
    'Material Object',
    'Unknown 87',
    'Lighting Template',
    'Shader Particle Geometry Data',
    'Reference Effect',
    'Unknown 91',
    'Movement Type',
    'Hazard',
    'Story Manager Event Node',
    'Sound Descriptor',
    'Dual Cast Data',
    'Sound Category',
    'Soul Gem',
    'Sound Output',
    'Collision Layer',
    'Scroll',
    'Color Form',
    'Reverb Parameters',
    'Pack-In',
    'Leveled Pack-In',
    'Reference Group',
    'Bendable Spline',
    'Unknown 108',
    'Unknown 109',
    'Aim Model',
    'Component',
    'Object Mod',
    'Material Swap',
    'Transform',
    'Zoom Data',
    'Instance Naming Rules',
    'Sound Keyword Mapping',
    'Terminal',
    'Audio Effect Chain',
    'Damage Type',
    'Actor Value',
    'Attraction Rule',
    'Sound Category Snapshot',
    'Sound Tag Set',
    'Lens Flare',
    'Unknown 126',
    'Snap Template Node',
    'Snap Template',
    'Ground Cover',
    'Emote',
    'Spell Threshold Data',
    'Resource',
    'Sound Echo',
    'Currency',
    'Unknown 135',
    'Perk Card Pack',
    'Leveled Perk Card',
    'Volumetric Lighting',
    'Curve Table Form',
    'Emote Category',
    'Workshop Permission',
    'Entitlement',
    'Power Armor Chasis',
    'Unknown 144',
    'Aim Assist Pose Data',
    'PhotoMode Feature',
    'Consumable Entitlement',
    'Crate Service Entitlement',
    'Challenge',
    'Avatar',
    'Region',
    'Condition Form',
    'Unknown 153',
    'Legendary Item',
    'Utility Item',
    'Model Swap',
    'Event Quest Widget',
    'Aim Assist Model',
    'Challenge Pass Reward Data',
    'Event Playlist',
    'Gameplay Reward',
    'Unknown 163',
    'Daily Content Group',
    'Idle Form'
  ], []);

  wbFormTypeEnum := wbEnum([
    'None',
    'Header',
    'Group',
    'Game Setting',
    'Keyword',
    'Entitlement',
    'Consumable Entitlement',
    'Crate Service Entitlement',
    'Emote Category',
    'Emote',
    'Avatar',
    'Challenge Pass Reward Data',
    'Location Reference Type',
    'Action',
    'Transform',
    'Component',
    'Texture Set',
    'Menu Icon',
    'Global',
    'Damage Type',
    'Class',
    'Faction',
    'Head Part',
    'Eyes',
    'Race',
    'Sound Marker',
    'Sound Echo Marker',
    'Acoustic Space',
    'Resource',
    'Magic Effect',
    'Script',
    'Landscape Texture',
    'Enchantment',
    'Spell',
    'Scroll',
    'Activator',
    'Talking Activator',
    'Curve Table',
    'Armor',
    'Book',
    'Container',
    'Door',
    'Ingredient',
    'Light',
    'Misc Item',
    'Misc Item Spawner',
    'Misc Item Spawner Instance',
    'Currency',
    'Static',
    'Static Collection',
    'Movable Static',
    'Grass',
    'Tree',
    'Flora',
    'Furniture',
    'Weapon',
    'Ammunition',
    'Non-Player Character (Actor)',
    'Leveled NPC',
    'Leveled Pack In',
    'Key',
    'Ingestible',
    'Utility',
    'Idle Marker',
    'Holotape',
    'Projectile',
    'Hazard',
    'Bendable Spline',
    'Soul Gem',
    'Terminal',
    'Perk Card Pack',
    'Power Armor Chasis',
    'Leveled Item',
    'Weather',
    'Climate',
    'Shader Particle Geometry',
    'Visual Effect',
    'Region',
    'Navmesh Info Map',
    'Cell',
    'Reference',
    'Placed NPC',
    'Projectile Missile',
    'Projectile Arrow',
    'Projectile Projectile',
    'Projectile Beam',
    'Projectile Flame',
    'Projectile Cone/Voice',
    'Projectile Barrier',
    'Projectile Hazard',
    'Worldspace',
    'Landscape',
    'Navmesh',
    'Unknown - TLOD',
    'Dialog Topic',
    'Dialog Response',
    'Quest',
    'Idle Animation',
    'Package',
    'Combat Style',
    'Load Screen',
    'Leveled Spell',
    'Animated Object',
    'Water',
    'Effect Shader',
    'Unknown - TOFT',
    'Explosion',
    'Debris',
    'Image Space',
    'Image Space Adapter',
    'FormID List',
    'Perk',
    'Perk Card',
    'Leveled Perk Card',
    'Body Part Data',
    'Addon Node',
    'Actor Value Info',
    'Camera Shot',
    'Camera Path',
    'Voice Type',
    'Material Type',
    'Impact',
    'Impact Data Set',
    'Armor Addon',
    'Location',
    'Message',
    'Ragdoll',
    'Default Object Manager',
    'Default Object',
    'Lighting Template',
    'Music Type',
    'Footstep',
    'Footstep Set',
    'Story Manager Branch Node',
    'Story Manager Quest Node',
    'Story Manager Event Node',
    'Dialog Branch',
    'Music Track',
    'Dialog View',
    'Word of Power',
    'Shout',
    'Equip Type',
    'Relationship',
    'Scene',
    'Association Type',
    'Outfit',
    'Art Object',
    'Material Object',
    'Movement Type',
    'Sound Descriptor',
    'Dual Cast Data',
    'Sound Category',
    'Sound Output Model',
    'Collision Layer',
    'Color',
    'Reverb Parameters',
    'Pack-In',
    'Reference Group',
    'Aim Model',
    'Aim Assist Model',
    'Layer',
    'Constructible Object',
    'Object Modification',
    'Material Swap',
    'Model Swap',
    'Zoom',
    'Instance Naming Rules',
    'Sound Keyword Mapping',
    'Audio Effect Chain',
    'Scene Collection',
    'Attraction Rule',
    'Sound Category Snapshot',
    'Animation Sound Tag Set',
    'Navmesh Obstacle Manager',
    'Lens Flare',
    'Unknown - LSPR',
    'Object Visibility Manager',
    'Unknown - DLYR',
    'Snap Template Node',
    'Snap Template',
    'Ground Cover',
    'Player Reference',
    'Spell Threshold Data',
    'Volumetric Lighting',
    'Workshop Permissions',
    'Wave Encounter',
    'Aim Assist Pose Data',
    'Photo Mode Feature',
    'Challenge',
    'Condition Form',
    'Unknown - AUVF',
    'Legendary Item',
    'Event Quest Widget'
], []);

  wbMiscStatEnum := wbEnum([], [
    Int64($1EE71DBC), 'Animals Friended',
    Int64($FCDD5011), 'Animals Killed',
    Int64($366D84CF), 'Armor Improved',
    Int64($8E20D7C9), 'Assaults',
    Int64($B9B50725), 'Backstabs',
    Int64($EA01A954), 'Bobbleheads Collected',
    Int64($6932624D), 'Bright Ideas',
    Int64($7FF0CC3B), 'Brotherhood of Steel Quests Completed',
    Int64($FEA920AA), 'Buildings',
    Int64($1F84743B), 'Caps Found',
    Int64($9360004C), 'Chems Crafted',
    Int64($B2A78B7A), 'Chems Taken',
    Int64($53D9E9B5), 'Chests Looted',
    Int64($1E258BEE), 'Computers Hacked',
    Int64($3DE99B41), 'Cores Ejected',
    Int64($737EAA97), 'Corpses Eaten',
    Int64($40B11EFE), 'Creatures Killed',
    Int64($4C4B8DF3), 'Creatures Killed DLC03',
    Int64($22D5BA38), 'Critical Strikes',
    Int64($3C626A90), 'Days Passed',
    Int64($C5A52FD0), 'Days Survived',
    Int64($45FDBB1C), 'DLC01 Quests Completed',
    Int64($FA7CC7F9), 'DLC03 Locations Discovered',
    Int64($AA444695), 'Dungeons Cleared',
    Int64($F4E8FFD6), 'Fatman Deaths',
    Int64($66DAF3CF), 'Fits of Rage',
    Int64($554E59D5), 'Food',
    Int64($E1EB3490), 'Food Cooked',
    Int64($9311B22B), 'Food Eaten',
    Int64($F947D866), 'Four Leaf Clovers',
    Int64($7C586E7A), 'Fusion Cores Consumed',
    Int64($2826309E), 'Game Difficulty',
    Int64($A5EA7ABC), 'Grand Slams',
    Int64($F5A36770), 'Grim Reaper Sprints',
    Int64($52984AA4), 'Happiness',
    Int64($FA024018), 'Hours Slept',
    Int64($CAD2ECA1), 'Hours Waiting',
    Int64($8CC5DAB6), 'HSAtomicCommand',
    Int64($A2E4C1F2), 'HSAutomatron',
    Int64($20F9993D), 'HSGrognak',
    Int64($8D882844), 'HSJangles',
    Int64($910B02C0), 'HSPipfall',
    Int64($860E0723), 'HSRedMenace',
    Int64($3FFA8658), 'HSZetaInvaders',
    Int64($40CA9C83), 'Institute Quests Completed',
    Int64($7D2E57C0), 'Intimidations',
    Int64($FFE8010B), 'Investments Made',
    Int64($9AF17D9D), 'Items Crafted DLC03',
    Int64($CF48C0B9), 'Items Scrapped',
    Int64($82F190C2), 'Items Stolen',
    Int64($6D8671DD), 'Junk Collected',
    Int64($110B8D2F), 'Legendary Enemies Killed',
    Int64($8A24FDE2), 'Locations Discovered',
    Int64($5829CC2E), 'Locks Picked',
    Int64($7EA26C2D), 'Main Quests Completed',
    Int64($493B803C), 'Mines Disarmed',
    Int64($B1511B82), 'Minuteman Quests Completed',
    Int64($98EE55DC), 'Misc Objectives Completed',
    Int64($0F3315AC), 'Money Shots',
    Int64($5E457DAC), 'Most Caps Carried',
    Int64($D37C6909), 'Murders',
    Int64($B91253A4), 'Mysterious Stranger Visits',
    Int64($1DEEA18A), 'Nuka Cola Flavors Created',
    Int64($9CE72536), 'Nuka World Creatures Killed',
    Int64($EB0D60AC), 'Objects Built',
    Int64($73AD915B), 'Pants Exploded',
    Int64($53706A04), 'Paralyzing Punches',
    Int64($9E78CEB3), 'People',
    Int64($F22A8133), 'People Killed',
    Int64($D3F632FF), 'Plants Harvested',
    Int64($856FA4C1), 'PlayedFutureRetroHolotape',
    Int64($F2BAC234), 'Pockets Picked',
    Int64($AC69D9B9), 'Power',
    Int64($0D7B8B16), 'Quests Completed',
    Int64($0580BB9F), 'RadAway Taken',
    Int64($D2960073), 'Rad-X Taken',
    Int64($FDE20426), 'Railroad Quests Completed',
    Int64($3CBF7E59), 'Ricochets',
    Int64($01E1BC85), 'Robots Disabled',
    Int64($2CA4ECC0), 'Robots Improved',
    Int64($C8BC93BE), 'Robots Killed',
    Int64($98D5710C), 'Sandman Kills',
    Int64($B1AE4792), 'Side Quests Completed',
    Int64($ACE470D7), 'Skill Books Read',
    Int64($B556CC52), 'Sneak Attacks',
    Int64($32D1B38F), 'Speach Successes',
    Int64($5D6B18F1), 'Stimpaks Taken',
    Int64($C5321BC5), 'Supply Lines Created',
    Int64($3869002E), 'Survival Denied',
    Int64($F9DEC209), 'Survival Level-Ups',
    Int64($69AF5B9A), 'Synths Killed',
    Int64($0A872FA3), 'Times Addicted',
    Int64($7AEA9C2B), 'Trespasses',
    Int64($13752285), 'Turrets Killed',
    Int64($0B479511), 'Wasteland Whispers',
    Int64($FCD0CCC3), 'Water',
    Int64($61A5C5A9), 'Weapons Disarmed',
    Int64($1D3BA844), 'Weapons Improved',
    Int64($60A11697), 'Workshops Unlocked'
  ]);

  wbDialogueSubtypeEnum := wbEnum([],[
    Sig2Int('CUST'), 'Custom',
    Sig2Int('PFGT'), 'Force Greet',
    Sig2Int('RUMO'), 'Rumors',
    Sig2Int('FVDL'), 'Custom',
    Sig2Int('INTI'), 'Call',
    Sig2Int('FLAT'), 'Follow',
    Sig2Int('BRIB'), 'Move',
    Sig2Int('ASKG'), 'Attack',
    Sig2Int('GIFF'), 'Inspect',
    Sig2Int('ASKF'), 'Retrieve',
    Sig2Int('STAY'), 'Stay',
    Sig2Int('RELE'), 'Release',
    Sig2Int('SHRE'), 'Show Relationships',
    Sig2Int('FRJT'), 'Reject',
    Sig2Int('HEAL'), 'Heal',
    Sig2Int('ASSI'), 'Assign',
    Sig2Int('ENTE'), 'Enter',
    Sig2Int('SCEN'), 'Custom',
    Sig2Int('SHOW'), 'Show',
    Sig2Int('AGRE'), 'Agree',
    Sig2Int('REFU'), 'Refuse',
    Sig2Int('FEXT'), 'Exit Favor State',
    Sig2Int('MREF'), 'Moral Refusal',
    Sig2Int('TRAD'), 'Trade',
    Sig2Int('PRJT'), 'Pathing Refusal',
    Sig2Int('ATCK'), 'Attack',
    Sig2Int('POAT'), 'Power Attack',
    Sig2Int('BASH'), 'Bash',
    Sig2Int('HIT_'), 'Hit',
    Sig2Int('FLEE'), 'Flee',
    Sig2Int('BLED'), 'Bleed Out',
    Sig2Int('AVTH'), 'Avoid Threat',
    Sig2Int('DETH'), 'Death',
    Sig2Int('BLOC'), 'Block',
    Sig2Int('TAUT'), 'Taunt',
    Sig2Int('THGR'), 'Throw Grenade',
    Sig2Int('ALKL'), 'Ally Killed',
    Sig2Int('ORFB'), 'Order Fallback',
    Sig2Int('ORAV'), 'Order Move Up',
    Sig2Int('ORFL'), 'Order Flank',
    Sig2Int('ORTC'), 'Order Take Cover',
    Sig2Int('FLBK'), 'Retreat',
    Sig2Int('RQST'), 'Cover Me',
    Sig2Int('BGST'), 'Suppressive Fire',
    Sig2Int('CRIL'), 'Crippled Limb',
    Sig2Int('PATT'), 'Paired Attack',
    Sig2Int('STEA'), 'Steal',
    Sig2Int('YIEL'), 'Yield',
    Sig2Int('ACYI'), 'Accept Yield',
    Sig2Int('PICC'), 'Pickpocket Combat',
    Sig2Int('ASSA'), 'Assault',
    Sig2Int('MURD'), 'Murder',
    Sig2Int('ASNC'), 'Assault NC',
    Sig2Int('MUNC'), 'Murder NC',
    Sig2Int('PICN'), 'Pickpocket NC',
    Sig2Int('STFN'), 'Steal From NC',
    Sig2Int('TRAN'), 'Trespass Against NC',
    Sig2Int('TRES'), 'Trespass',
    Sig2Int('WTCR'), 'UNUSED01',
    Sig2Int('VPSS'), 'Voice Power Start Short',
    Sig2Int('VPSL'), 'Voice Power Start Long',
    Sig2Int('VPES'), 'Voice Power End Short',
    Sig2Int('VPEL'), 'Voice Power End Long',
    Sig2Int('ALIL'), 'Alert Idle',
    Sig2Int('LOIL'), 'Lost Idle',
    Sig2Int('NOTA'), 'Normal To Alert',
    Sig2Int('NOTC'), 'Normal To Combat',
    Sig2Int('NOTL'), 'Normal To Lost',
    Sig2Int('ALTN'), 'Alert To Normal',
    Sig2Int('ALTC'), 'Alert To Combat',
    Sig2Int('COTN'), 'Combat To Normal',
    Sig2Int('COLO'), 'Combat To Lost',
    Sig2Int('LOTN'), 'Lost To Normal',
    Sig2Int('LOTC'), 'Lost To Combat',
    Sig2Int('DFDA'), 'Detect Friend Die',
    Sig2Int('SERU'), 'Service Refusal',
    Sig2Int('REPA'), 'Repair',
    Sig2Int('TRAV'), 'Travel',
    Sig2Int('TRAI'), 'Training',
    Sig2Int('BAEX'), 'Barter Exit',
    Sig2Int('REEX'), 'Repair Exit',
    Sig2Int('RECH'), 'Recharge',
    Sig2Int('RCEX'), 'Recharge Exit',
    Sig2Int('TREX'), 'Training Exit',
    Sig2Int('OBCO'), 'Observe Combat',
    Sig2Int('NOTI'), 'Notice Corpse',
    Sig2Int('TITG'), 'Time To Go',
    Sig2Int('GBYE'), 'Goodbye',
    Sig2Int('HELO'), 'Hello',
    Sig2Int('SWMW'), 'Swing Melee Weapon',
    Sig2Int('FIWE'), 'Shoot Bow',
    Sig2Int('ZKEY'), 'Z Key Object',
    Sig2Int('JUMP'), 'Jump',
    Sig2Int('KNOO'), 'Knock Over Object',
    Sig2Int('DEOB'), 'Destroy Object',
    Sig2Int('STOF'), 'Standon Furniture',
    Sig2Int('LOOB'), 'Locked Object',
    Sig2Int('PICT'), 'Pickpocket Topic',
    Sig2Int('PURS'), 'Pursue Idle Topic',
    Sig2Int('IDAT'), 'Shared Info',
    Sig2Int('SCCH'), 'Scene Choice',
    Sig2Int('PCPS'), 'Player Cast Projectile Spell',
    Sig2Int('PCSS'), 'Player Cast Self Spell',
    Sig2Int('PCSH'), 'Player Shout',
    Sig2Int('IDLE'), 'Idle',
    Sig2Int('BREA'), 'Enter Sprint Breath',
    Sig2Int('ENBZ'), 'Enter Bow Zoom Breath',
    Sig2Int('EXBZ'), 'Exit Bow Zoom Breath',
    Sig2Int('ACAC'), 'Actor Collidewith Actor',
    Sig2Int('PIRN'), 'Playerin Iron Sights',
    Sig2Int('OUTB'), 'Outof Breath',
    Sig2Int('GRNT'), 'Combat Grunt',
    Sig2Int('LWBS'), 'Leave Water Breath',
    Sig2Int('IMPT'), 'Impatient Positive',
    Sig2Int('IMNG'), 'Impatient Negative',
    Sig2Int('IMNU'), 'Impatient Neutral',
    Sig2Int('IMQU'), 'Impatient Question',
    Sig2Int('WFPI'), 'Waiting For Player Input',
    Sig2Int('GREE'), 'Greeting',
    Sig2Int('PADR'), 'Player Activate Door',
    Sig2Int('PATR'), 'Player Activate Terminals',
    Sig2Int('PAFU'), 'Player Activate Furniture',
    Sig2Int('PAAC'), 'Player Activate Activators',
    Sig2Int('PACO'), 'Player Activate Container',
    Sig2Int('PAFI'), 'Player Aquire Featured Item'
]);

  wbAdvanceActionEnum := wbEnum([
    'Normal Usage',
    'Power Attack',
    'Bash',
    'Lockpick Success',
    'Lockpick Broken'
  ]);

  wbCriticalStageEnum :=
    wbEnum([
      'None',
      'Goo Start',
      'Goo End',
      'Disintegrate Start',
      'Disintegrate End'
    ]);

  wbStaggerEnum := wbEnum([
    'None',
    'Small',
    'Medium',
    'Large',
    'Extra Large'
  ]);

  wbEFID := wbFormIDCk(EFID, 'Base Effect', [MGEF]);

  wbEFIT :=
    wbStruct(EFIT, '', [
      wbFromVersion(166, wbInteger('Effect ID', itU32)),
      wbFloat('Magnitude'),
      wbInteger('Area', itU32),
      wbInteger('Duration', itU32),
      wbUnknown { If form version is less than 154 or greater than 182 this is empty. If form version is between 154 and 165 then its a 12 byte value. If form version is between 166 and 182 then this is an 8 byte value. }
    ], cpNormal, True, nil, -1, wbEFITAfterLoad);

  wbCTDA := wbRStructSK([0], 'Condition', [
    wbStructSK(CTDA, [3, 5, 6], '', [
   {0}wbInteger('Type', itU8, wbCtdaTypeToStr, wbCtdaTypeToInt, cpNormal, False, nil, wbCtdaTypeAfterSet),
   {1}wbByteArray('Unused', 3, cpIgnore, False, wbNeverShow),
   {2}wbUnion('Comparison Value', wbCTDACompValueDecider, [
        wbFloat('Comparison Value - Float'),
        wbFormIDCk('Comparison Value - Global', [GLOB])
      ]),
   {3}wbInteger('Function', itU16, wbCTDAFunctionToStr, wbCTDAFunctionToInt),
   {4}wbByteArray('Unused', 2, cpIgnore, False, wbNeverShow),
   {5}wbUnion('Parameter #1', wbCTDAParam1Decider, [
        { unknown }
        wbByteArray('Unknown', 4).IncludeFlag(dfZeroSortKey),
        { 0 ptNone}
        wbByteArray('None', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
        { 1 ptString}
        wbInteger('String', itU32, wbCTDAParam1StringToString, wbCTDAParam1StringToInt),
        { 2 ptInteger}
        wbInteger('Integer', itS32),
        { 3 ptFloat}
        wbFloat('Float'),
        { 4 ptActor}
        wbFormIDCkNoReach('Actor', [NULL, PLYR, ACHR, REFR]),
        { 5 ptActorBase}
        wbFormIDCkNoReach('Actor Base', [NPC_]),
        { 6 ptActorValue}
        wbActorValue,
        { 7 ptAdvanceAction}
        wbInteger('Player Action', itU32, wbAdvanceActionEnum),
        { 8 ptAlias}
        wbInteger('Alias', itS32, wbConditionAliasToStr, wbStrToAlias),
        { 9 ptAlignment}
        wbInteger('Alignment', itU32, wbAlignmentEnum),
        {10 ptAssociationType}
        wbFormIDCk('Association Type', [ASTP]),
        {11 ptAxis}
        wbInteger('Axis', itU32, wbAxisEnum),
        {12 ptCastingSource}
        wbInteger('Casting Type', itU32, wbCastingSourceEnum),
        {13 ptCell}
        wbFormIDCkNoReach('Cell', [CELL]),
        {14 ptClass}
        wbFormIDCkNoReach('Class', [CLAS]),
        {15 ptCrimeType}
        wbInteger('Crime Type', itU32, wbCrimeTypeEnum),
        {16 ptCriticalStage}
        wbInteger('Critical Stage', itU32, wbCriticalStageEnum),
        {17 ptEncounterZone}
        wbFormIDCkNoReach('Encounter Zone', [ECZN]),
        {18 ptEquipType}
        wbFormIDCkNoReach('Equip Type', [EQUP]),
        {19 ptEvent}
        wbInteger('Event', itU32, wbEventFunctionAndMemberToStr, wbEventFunctionAndMemberToInt),
        {20 ptEventData}
        wbFormID('Event Data'),
        {21 ptFaction}
        wbFormIDCkNoReach('Faction', [FACT]),
        {22 ptFormList}
        wbFormIDCkNoReach('Form List', [FLST]),
        {23 ptFormType}
        wbInteger('Form Type', itU32, wbConditionFormTypeEnum),
        {24 ptFurniture}
        wbFormIDCkNoReach('Furniture', [FURN, FLST]),
        {25 ptFurnitureAnim}
        wbInteger('Furniture Anim', itU32, wbFurnitureAnimTypeEnum),
        {26 ptFurnitureEntry}
        wbInteger('Furniture Entry', itU32, wbFurnitureEntryTypeFlags),
        {27 ptGlobal}
        wbFormIDCkNoReach('Global', [GLOB]),
        {28 ptIdleForm}
        wbFormIDCkNoReach('Idle', [IDLE]),
        {29 ptInventoryObject}
        wbFormIDCkNoReach('Inventory Object', sigBaseObjects),
        {30 ptKeyword}
        wbFormIDCkNoReach('Keyword', [KYWD, FLST, NULL]),
        {31 ptLocation}
        wbFormIDCkNoReach('Location', [LCTN]),
        {32 ptMagicEffect}
        wbFormIDCkNoReach('Base Effect', [MGEF]),
        {33 ptMagicItem}
        wbFormIDCkNoReach('Effect Item', [SPEL, ENCH, ALCH, INGR, SCRL]),
        {34 ptMiscStat}
        wbInteger('Misc Stat', itU32, wbMiscStatEnum),
        {35 ptObjectReference}
        wbFormIDCkNoReach('Object Reference', sigReferences),
        {36 ptOwner}
        wbFormIDCkNoReach('Owner', [NULL, FACT, NPC_]),
        {37 ptPackage}
        wbFormIDCkNoReach('Package', [PACK]),
        {38 ptPackdata}
        wbInteger('Packdata ID', itU32),
        {39 ptPerk}
        wbFormIDCkNoReach('Perk', [PERK]),
        {40 ptQuest}
        wbFormIDCkNoReach('Quest', [QUST]).AddOverlay(wbCTDAParamQuestOverlay),
        {41 ptQuestStage}
        wbInteger('Quest Stage', itU32, wbCTDAParam1QuestStageToStr, wbQuestStageToInt),
        {42 ptRace}
        wbFormIDCkNoReach('Race', [RACE]),
        {43 ptReferencableObject}
        wbFormIDCkNoReach('Referenceable Object', sigBaseObjects),
        {44 ptRefType}
        wbFormIDCkNoReach('Location Ref Type', [LCRT]),
        {45 ptRegion}
        wbFormIDCkNoReach('Region', [REGN]),
        {46 ptScene}
        wbFormIDCk('Scene', [NULL, SCEN]),
        {47 ptSex}
        wbInteger('Sex', itU32, wbSexEnum),
        {48 ptShout}
        wbFormIDCkNoReach('Shout', [SHOU]),
        {49 ptVariableName}
        wbByteArray('Variable Name (unused)', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
        {50 ptVATSValueFunction}
        wbInteger('VATS Value Function', itU32, wbVATSValueFunctionEnum),
        {51 ptVATSValueParam}
        wbInteger('VATS Value Param (unused)', itU32).IncludeFlag(dfZeroSortKey),
        {52 ptVoiceType}
        wbFormIDCkNoReach('Voice Type', [VTYP, FLST]),
        {53 ptWardState}
        wbInteger('Ward State', itU32, wbWardStateEnum),
        {54 ptWeather}
        wbFormIDCkNoReach('Weather', [WTHR]),
        {55 ptWorldspace}
        wbFormIDCkNoReach('Worldspace', [WRLD, FLST]),
        {56 ptDamageType}
        wbFormIDCkNoReach('Damage Type', [DMGT, FLST]),
        {57 ptConditionForm}
        wbFormIDCkNoReach('Condition Form', [CNDF]),
        {58 ptEntitlement}
        wbFormIDCkNoReach('Entitlement', [ENTM]),
        {59 ptPerkCard}
        wbFormIDCkNoReach('Perk Card', [PCRD]),
        {60 ptAcousticSpace }
        wbFormIDCkNoReach('Acoustic Space', [ASPC]),
        {61 ptCurrency }
        wbFormIDCkNoReach('Currency', [CNCY]),
        {62 ptConstructibleObject }
        wbFormIDCkNoReach('Constructible Object', [COBJ, NULL]),
        {63 ptRegionOpt }
        wbFormIDCkNoReach('Region', [REGN, NULL]),
        {64 ptActorValueEnum }
        wbInteger('Actor Value', itS32, wbActorValueEnum),
        {65 ptChallenge }
        wbFormIDCkNoReach('Challenge', [CHAL, NULL]),
        {66 ptAttackData }
        wbInteger('Attack Data', itU32),
        {67 ptLegendaryItem }
        wbFormIDCkNoReach('Legendary Item', [LGDI]),
        {68 ptDailyContentGroup }
        wbFormIDCkNoReach('Daily Content Group', [DCGF, QUST]),
        {69 ptSpell }
        wbFormIDCkNoReach('Spell (Optional)', [SPEL, NULL]),
        {70 ptFactionOpt}
        wbFormIDCkNoReach('Faction', [NULL, FACT])
      ]),

      wbUnion('Parameter #2', wbCTDAParam2Decider, [
        { unknown }
        wbByteArray('Unknown', 4).IncludeFlag(dfZeroSortKey),
        { 0 ptNone}
        wbByteArray('None', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
        { 1 ptString}
        wbInteger('String', itU32, wbCTDAParam2StringToString, wbCTDAParam2StringToInt),
        { 2 ptInteger}
        wbInteger('Integer', itS32),
        { 3 ptFloat}
        wbFloat('Float'),
        { 4 ptActor}
        wbFormIDCkNoReach('Actor', [NULL, PLYR, ACHR, REFR]),
        { 5 ptActorBase}
        wbFormIDCkNoReach('Actor Base', [NPC_]),
        { 6 ptActorValue}
        wbActorValue,
        { 7 ptAdvanceAction}
        wbInteger('Player Action', itU32, wbAdvanceActionEnum),
        { 8 ptAlias}
        wbInteger('Alias', itS32, wbConditionAliasToStr, wbStrToAlias),
        { 9 ptAlignment}
        wbInteger('Alignment', itU32, wbAlignmentEnum),
        {10 ptAssociationType}
        wbFormIDCk('Association Type', [ASTP]),
        {11 ptAxis}
        wbInteger('Axis', itU32, wbAxisEnum),
        {12 ptCastingSource}
        wbInteger('Casting Type', itU32, wbCastingSourceEnum),
        {13 ptCell}
        wbFormIDCkNoReach('Cell', [CELL]),
        {14 ptClass}
        wbFormIDCkNoReach('Class', [CLAS]),
        {15 ptCrimeType}
        wbInteger('Crime Type', itU32, wbCrimeTypeEnum),
        {16 ptCriticalStage}
        wbInteger('Critical Stage', itU32, wbCriticalStageEnum),
        {17 ptEncounterZone}
        wbFormIDCkNoReach('Encounter Zone', [ECZN]),
        {18 ptEquipType}
        wbFormIDCkNoReach('Equip Type', [EQUP]),
        {19 ptEvent}
        wbInteger('Event', itU32, wbEventFunctionAndMemberToStr, wbEventFunctionAndMemberToInt),
        {20 ptEventData}
        wbFormID('Event Data'),
        {21 ptFaction}
        wbFormIDCkNoReach('Faction', [FACT]),
        {22 ptFormList}
        wbFormIDCkNoReach('Form List', [FLST]),
        {23 ptFormType}
        wbInteger('Form Type', itU32, wbConditionFormTypeEnum),
        {24 ptFurniture}
        wbFormIDCkNoReach('Furniture', [FURN, FLST]),
        {25 ptFurnitureAnim}
        wbInteger('Furniture Anim', itU32, wbFurnitureAnimTypeEnum),
        {26 ptFurnitureEntry}
        wbInteger('Furniture Entry', itU32, wbFurnitureEntryTypeFlags),
        {27 ptGlobal}
        wbFormIDCkNoReach('Global', [GLOB]),
        {28 ptIdleForm}
        wbFormIDCkNoReach('Idle', [IDLE]),
        {29 ptInventoryObject}
        wbFormIDCkNoReach('Inventory Object', sigBaseObjects),
        {30 ptKeyword}
        wbFormIDCkNoReach('Keyword', [KYWD, FLST, NULL]),
        {31 ptLocation}
        wbFormIDCkNoReach('Location', [LCTN]),
        {32 ptMagicEffect}
        wbFormIDCkNoReach('Base Effect', [MGEF]),
        {33 ptMagicItem}
        wbFormIDCkNoReach('Effect Item', [SPEL, ENCH, ALCH, INGR, SCRL]),
        {34 ptMiscStat}
        wbInteger('Misc Stat', itU32, wbMiscStatEnum),
        {35 ptObjectReference}
        wbFormIDCkNoReach('Object Reference', sigReferences),
        {36 ptOwner}
        wbFormIDCkNoReach('Owner', [NULL, FACT, NPC_]),
        {37 ptPackage}
        wbFormIDCkNoReach('Package', [PACK]),
        {38 ptPackdata}
        wbInteger('Packdata ID', itU32),
        {39 ptPerk}
        wbFormIDCkNoReach('Perk', [PERK]),
        {40 ptQuest}
        wbFormIDCkNoReach('Quest', [QUST]),
        {41 ptQuestStage}
        wbInteger('Quest Stage', itU32, wbCTDAParam2QuestStageToStr, wbQuestStageToInt),
        {42 ptRace}
        wbFormIDCkNoReach('Race', [RACE]),
        {43 ptReferencableObject}
        wbFormIDCkNoReach('Referenceable Object', sigBaseObjects),
        {44 ptRefType}
        wbFormIDCkNoReach('Location Ref Type', [LCRT]),
        {45 ptRegion}
        wbFormIDCkNoReach('Region', [REGN]),
        {46 ptScene}
        wbFormIDCk('Scene', [NULL, SCEN]),
        {47 ptSex}
        wbInteger('Sex', itU32, wbSexEnum),
        {48 ptShout}
        wbFormIDCkNoReach('Shout', [SHOU]),
        {49 ptVariableName}
        wbByteArray('Variable Name (unused)', 4, cpIgnore),
        {50 ptVATSValueFunction}
        wbInteger('VATS Value Function', itU32, wbVATSValueFunctionEnum),
        {51 ptVATSValueParam}
        wbUnion('VATS Value Param', wbCTDAParam2VATSValueParamDecider, [
         { 0} wbFormIDCkNoReach('Weapon', [WEAP]),
         { 1} wbFormIDCkNoReach('Weapon List', [FLST], [WEAP]),
         { 2} wbFormIDCkNoReach('Target', [NPC_]),
         { 3} wbFormIDCkNoReach('Target List', [FLST], [NPC_]),
         { 4} wbInteger('Target Distance', itU32),
         { 5} wbInteger('Target Part', itS32, wbActorValueEnum),
         { 6} wbInteger('VATS Action', itU32, wbEnum([
                'Unarmed Attack',
                'One Hand Melee Attack',
                'Two Hand Melee Attack',
                'Magic Attack',
                'Ranged Attack',
                'Reload',
                'Crouch',
                'Stand',
                'Switch Weapon',
                'Toggle Weapon Drawn',
                'Heal',
                'Player Death'
          ])),
         { 7} wbByteArray('Is Success', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         { 8} wbByteArray('Is Critical', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         { 9} wbFormIDCkNoReach('Critical Effect', [SPEL]),
         {10} wbFormIDCkNoReach('Critical Effect List', [FLST], [SPEL]),
         {11} wbByteArray('Is Fatal', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {12} wbByteArray('Explode Part', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {13} wbByteArray('Dismember Part', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {14} wbByteArray('Cripple Part', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {15} wbInteger('Weapon Type', itU32, wbWeaponAnimTypeEnum),
         {16} wbByteArray('Is Stranger', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {17} wbByteArray('Is Paralyzing Palm', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
         {18} wbInteger('Projectile Type', itU32, wbEnum([
                'Missile',
                'Lobber',
                'Beam',
                'Flame',
                'Cone',
                'Barrier',
                'Arrow'
              ])),
         {19} wbInteger('Delivery Type', itU32, wbTargetEnum),
         {20} wbInteger('Casting Type', itU32, wbCastEnum)
        ]),
        {52 ptVoiceType}
        wbFormIDCkNoReach('Voice Type', [VTYP, FLST]),
        {53 ptWardState}
        wbInteger('Ward State', itU32, wbWardStateEnum),
        {54 ptWeather}
        wbFormIDCkNoReach('Weather', [WTHR]),
        {55 ptWorldspace}
        wbFormIDCkNoReach('Worldspace', [WRLD, FLST]),
        {56 ptDamageType}
        wbFormIDCkNoReach('Damage Type', [DMGT, FLST]),
        {57 ptConditionForm}
        wbFormIDCkNoReach('Condition Form', [CNDF]),
        {58 ptEntitlement}
        wbFormIDCkNoReach('Entitlement', [ENTM]),
        {59 ptPerkCard}
        wbFormIDCkNoReach('Perk Card', [PCRD]),
        {60 ptAcousticSpace }
        wbFormIDCkNoReach('Acoustic Space', [ASPC]),
        {61 ptCurrency }
        wbFormIDCkNoReach('Currency', [CNCY]),
        {62 ptConstructibleObject }
        wbFormIDCkNoReach('Constructible Object', [COBJ]),
        {63 ptRegionOpt}
        wbFormIDCkNoReach('Region', [REGN, NULL]),
        {64 ptActorValueEnum}
        wbInteger('Actor Value', itS32, wbActorValueEnum),
        {65 ptChallenge }
        wbFormIDCkNoReach('Challenge', [CHAL, NULL]),
        {66 ptAttackData }
        wbInteger('Attack Data', itU32),
        {67 ptLegendaryItem }
        wbFormIDCkNoReach('Legendary Item', [LGDI]),
        {68 ptDailyContentGroup }
        wbFormIDCkNoReach('Daily Content Group', [DCGF, QUST]),
        {69 ptSpell }
        wbFormIDCkNoReach('Spell (Optional)', [SPEL, NULL]),
        {70 ptFactionOpt}
        wbFormIDCkNoReach('Faction', [NULL, FACT])
      ]),
      wbInteger('Run On', itU32, wbEnum([
        { 0} 'Subject',
        { 1} 'Target',
        { 2} 'Reference',
        { 3} 'Combat Target',
        { 4} 'Linked Reference',
        { 5} 'Quest Alias',
        { 6} 'Package Data',
        { 7} 'Event Data',
        { 9} 'Command Target',
        {10} 'Event Camera Ref',
        {11} 'My Killer',
        {12} 'Active Players',
        {13} 'Potential Players',
        {14} 'Player Teammates',
        {15} 'Target List',
        {16} 'Instance Owner'
      ]), cpNormal, False, nil, wbCTDARunOnAfterSet),
      wbUnion('Reference', wbCTDAReferenceDecider, [
        wbInteger('Unused', itU32, nil, cpIgnore),
        wbFormIDCkNoReach('Reference', sigReferences, False)
      ]),
      wbInteger('Parameter #3', itS32, nil, cpNormal, False, nil, nil, -1)
    ], cpNormal, False{, nil, 0, wbCTDAAfterLoad}),
    wbString(CIS1, 'Parameter #1'),
    wbString(CIS2, 'Parameter #2')
  ], [], cpNormal).SetToStr(wbConditionToStr).IncludeFlag(dfCollapsed, wbCollapseConditions);

  wbCTDAs := wbRArray('Conditions', wbCTDA, cpNormal, False);
  wbCTDAsCount := wbRArray('Conditions', wbCTDA, cpNormal, False, nil, wbCTDAsAfterSet);
  wbCTDAsReq := wbRArray('Conditions', wbCTDA, cpNormal, True);

  wbCNDCs :=
    wbRArray('Condition Infos',
      wbRUnion('', [
        wbRStruct('Condition Info', [
          wbCNDC.IncludeFlag(dfNoReport),
          wbCITC,
          wbCTDAsCount
        ], []),
        wbRStruct('Condition Info', [
          wbCITC,
          wbCTDAsCount
        ], [])
      ], [])
    );

  wbDEST := wbRStruct('Destructible', [
    wbStruct(DEST, 'Header', [
      wbInteger('Health', itS32),
      wbInteger('DEST Count', itU8),
      wbByteArray('Unused',3),
      wbInteger('Flags', itU32, wbFlags([
      { 0x0001 } 'VATS Targetable',
      { 0x0002 } 'Large Actor Destroys',
      { 0x0004 } 'Unknown 3',
      { 0x0008 } 'Unknown 4',
      { 0x0010 } 'Unknown 5',
      { 0x0020 } 'Unknown 6',
      { 0x0040 } 'Unknown 7',
      { 0x0080 } 'Unknown 8',
      { 0x0100 } 'Unknown 9',
      { 0x0200 } 'Unknown 10',
      { 0x0400 } 'Unknown 11',
      { 0x0800 } 'Unknown 12',
      { 0x1000 } 'Has Conditions',
      { 0x2000 } 'Unknown 14',
      { 0x4000 } 'Unknown 15',
      { 0x8000 } 'Unknown 16'
      ])),
      wbFromSize(16, wbFloat('Unknown'))
    ], cpNormal, True),
    wbCTDAs,
    wbUnknown(DSCF),
    wbFormIDCk(HGLB, 'Health Global', [GLOB]),
    wbArrayS(DAMC, 'Resistances', wbStructSK([0], 'Resistance', [
      wbFormIDCk('Damage Type', [DMGT]),
      wbInteger('Value', itU32),
      wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
    ])),
    wbRArray('Stages',
      wbRStruct('Stage', [
        wbStruct(DSTD, 'Destruction Stage Data', [
          wbInteger('Health %', itU8),
          wbInteger('Index', itU8),
          wbInteger('Model Damage Stage', itU8),
          wbInteger('Flags', itU8, wbFlags([
            {0x01} 'Cap Damage',
            {0x02} 'Disable',
            {0x04} 'Destroy',
            {0x08} 'Ignore External Damage',
            {0x10} 'Becomes Dynamic',
            {0x20} 'Unknown 5',
            {0x40} 'Disable Collision',
            {0x80} 'Unknown 7'
          ])),
          wbInteger('Self Damage per Second', itS32),
          wbFormIDCk('Explosion', [EXPL, NULL]),
          wbFormIDCk('Debris', [DEBR, NULL]),
          wbInteger('Debris Count', itS32),
          wbFormIDCk('Material Swap', [MSWP, NULL]),
          wbFloat
        ], cpNormal, True),
        wbString(DSTA, 'Sequence Name'),
        wbRArray('Models',
          wbRStructSK([0], 'Model', [
            wbString(DMDL, 'Model FileName', 0, cpNormal, True),
            wbDMDT,
            wbDMDC,
            wbDMDS,
            wbENLM,
            wbENLT,
            wbENLS,
            wbAUUV
          ], []).IncludeFlag(dfAllowAnyMember)
        ),
        wbEmpty(DSTF, 'End Marker', cpNormal, True)
      ], [], cpNormal, False, nil)
    )
  ], [], cpNormal, False, nil, True).IncludeFlag(dfAllowAnyMember);

  wbReward := wbRStruct('Reward', [
    wbUnknown(CTRG),
    wbFormIDCk(NAM7, 'XP Amount Global', [GLOB, NULL]),
    wbFormIDCk(NAM8, 'Currency Amount Global', [GLOB, NULL]),
    wbFormIDCk(QRCO, 'Quest Reward Currency Object', [NULL, CNCY]),
    wbFormIDCk(NAM9, 'Unknown Global', [GLOB, NULL]),
    wbFormID(QRLI, 'Legendary Item Reward List'),
    wbFormID(QRCX, 'SCORE Reward Amount'),
    wbFloat(ESRE, 'XP Amount'),
    wbInteger(QRLR, 'Legendary Item Reward Rank', itU32),
    wbUnion(QRRI, '', wbRecordSizeDecider(1), [
      wbEmpty('Legendary Item Rank Random'),
      wbInteger('Legendary Item Rank Random', itU8, wbBoolEnum)
    ]),
    wbRArray('Rewarded Items',
      wbStruct(QSRD, 'Rewarded Item', [
        wbFormID('Item'),
        wbInteger('Count', itU32)
      ])
    ),
    wbFormIDCk(CENT, 'Entitlement', [ENTM, NULL]),
    wbCTDAs,
    wbFormIDCk(DNAM, 'Reward Record', [GMRW]),
    wbEmpty(ITME, 'Reward End Marker')
  ], [], cpNormal, False, nil, True).IncludeFlag(dfAllowAnyMember);

  wbDESTActor := wbRStruct('Destructible', [
    wbStruct(DEST, 'Header', [
      wbInteger('Health', itS32),
      wbInteger('Count', itU8),
      wbInteger('VATS Targetable', itU8, wbBoolEnum),
      wbByteArray('Unknown', 2)
    ]),
    wbRArray('Stages',  // Begin Stage Array
      wbRStruct('Stage', [ // Begin Stage RStruct
        wbStruct(DSTD, 'Destruction Stage Data', [ // Begin DSTD
          wbInteger('Health %', itU8),
          wbInteger('Index', itU8),
          wbInteger('Damage Stage', itU8),
          wbInteger('Flags', itU8, wbFlags([
            {0x01} 'Cap Damage',
            {0x02} 'Disable',
            {0x04} 'Destroy',
            {0x08} 'Ignore External Damage',
            {0x10} 'Becomes Dynamic',
            {0x20} 'Unknown 5',
            {0x40} 'Disable Collision'
          ])),
          wbInteger('Self Damage per Second', itS32),
          wbFormIDCk('Explosion', [EXPL, NULL]),
          wbFormIDCk('Debris', [DEBR, NULL]),
          wbInteger('Debris Count', itS32)
        ], cpNormal, True), // End DSTD
        wbRStructSK([0], 'Model', [ // Begin DMDL
          wbString(DMDL, 'Model FileName')
        ], []), // End DMDL
        wbDMDT,
        wbDMDC,
        wbDMDS,
        wbENLM,
        wbENLT,
        wbENLS,
        wbAUUV,
        wbEmpty(DSTF, 'End Marker', cpNormal, True)
      ], []) // Begin Stage RStruct
    ) // End Stage Array
  ], [], cpNormal, False, nil{wbActorTemplateUseModelAnimation});

  wbAttackData := wbRStructSK([1], 'Attack', [
    wbStruct(ATKD, 'Attack Data', [
      wbFloat('Damage Mult'),
      wbFloat('Attack Chance'),
      wbFormIDCk('Attack Spell', [SPEL, NULL]),
      wbInteger('Attack Flags', itU32, wbFlags([
        {0x00000001} 'Ignore Weapon',
        {0x00000002} 'Bash Attack',
        {0x00000004} 'Power Attack',
        {0x00000008} 'Charge Attack',
        {0x00000010} 'Rotating Attack',
        {0x00000020} 'Continuous Attack',
        {0x00000040} 'Unknown 6',
        {0x00000080} 'Unknown 7',
        {0x00000100} 'Unknown 8',
        {0x00000200} 'Unknown 9',
        {0x00000400} 'Unknown 10',
        {0x00000800} 'Unknown 11',
        {0x00001000} 'Unknown 12',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'Unknown 14',
        {0x00008000} 'Unknown 15',
        {0x00010000} 'Unknown 16',
        {0x00020000} 'Unknown 17',
        {0x00040000} 'Unknown 18',
        {0x00080000} 'Unknown 19',
        {0x00100000} 'Unknown 20',
        {0x00200000} 'Unknown 21',
        {0x00400000} 'Unknown 22',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'Unknown 27',
        {0x10000000} 'Unknown 28',
        {0x20000000} 'Unknown 29',
        {0x40000000} 'Unknown 30',
        {0x80000000} 'Override Data'
      ])),
      wbFloat('Attack Angle'),
      wbFloat('Strike Angle'),
      wbFloat('Stagger'),
      wbFloat('Knockdown'),
      wbFloat('Recovery Time'),
      wbFloat('Action Points Mult'),
      wbInteger('Stagger Offset', itS32),
      wbFromVersion(185, wbFloat('Unknown')),
      wbUnknown
    ]),
    wbString(ATKE, 'Attack Event'),
    wbFormIDCk(ATKW, 'Weapon Slot', [EQUP]),
    wbFormIDCk(ATKS, 'Required Slot', [EQUP]),
    wbString(ATKT, 'Description'),
    wbCTDAs
  ], []);

  wbICON := wbString(ICON, 'Inventory Image');
  wbMICO := wbString(MICO, 'Message Icon');
  wbPTRN := wbFormIDCk(PTRN, 'Preview Transform', [TRNS]);
  wbSTCP := wbFormIDCk(STCP, 'Animation Sound', [STAG]);
  wbNTRM := wbFormIDCk(NTRM, 'Native Terminal', [TERM]);
  wbYNAM := wbFormIDCk(YNAM, 'Sound - Pick Up', [SNDR]);
  wbZNAM := wbFormIDCk(ZNAM, 'Sound - Put Down', [SNDR]);
  wbCUSD := wbFormIDCk(CUSD, 'Sound - Crafting', [SNDR]);
  wbINRD := wbFormIDCk(INRD, 'Instance Naming', [INNR]);
  wbEILV := wbArray(EILV, 'Eligible Levels', wbInteger('Level', itU32));
  wbIBSD := wbFormIDCk(IBSD, 'Break Sound', [SNDR]);

  wbZNAMArray := wbArray(ZNAM, 'Unknown', wbStruct('Unknown', [
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFormIDCk('Keyword', [KYWD,NULL]),
    wbByteArray('Unknown', 4)
  ]));

  wbObjectProperty :=
    wbStructSK([0], 'Property', [
      wbActorValue,
      wbFloat('Value'),
      wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
    ]).SetToStr(wbObjectPropertyToStr).IncludeFlag(dfCollapsed, wbCollapseObjectProperties);

  wbPRPS := wbArrayS(PRPS, 'Properties', wbObjectProperty);

  wbCVPA := wbArrayS(CVPA, 'Junk Scrap Quantities', wbStructSK([0], 'Scrap Component Quantity', [
    wbFormIDCk('Scrap Count Keyword', [KYWD]),
    wbInteger('Scrap Component Count', itU32),
    wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
  ]));

  wbESCR := wbArrayS(ESCR, 'Scrap Recieved', wbStructSK([0], 'Scrap Recieved', [
    wbFormID('Item Type'),
    wbInteger('Count', itU32),
    wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
  ]));

  wbREPR := wbArrayS(REPR, 'Repair', wbStructSK([0], 'Component', [
    wbFormIDCkNoReach('Component', sigBaseObjects),
    wbInteger('Count', itU32),
    wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
  ]));

  wbAVMG := wbArrayS(AVMG, 'Unknown', wbStructSK([0], 'Unknown', [
    wbFormID('Unknown'),
    wbByteArray('Unknown', 4),
    wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
  ]));

  wbDAMS := wbArrayS(DAMS, 'Damage Type Condition Scalings', wbStructSK([0], 'Damage Type Condition Scaling', [
    wbFormIDCk('Type', [DMGT]),
    wbInteger('Amount', itU32),
    wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
  ]));
  wbFLTR := wbString(FLTR, 'Filter');
  wbAPPR := wbArray(APPR, 'Attach Parent Slots', wbFormIDCk('Keyword', [KYWD]));
  wbFTYP := wbArray(FTYP, 'Forced Loc Ref Types', wbFormIDCk('Forced Loc Ref Type', [LCRT]));
  wbATTX := wbLStringKC(ATTX, 'Activate Text Override', 0, cpTranslate);

  wbMNAMFurnitureMarker := wbInteger(MNAM, 'Active Markers / Flags', itU32, wbFlags([
    {0x00000001} 'Interaction Point 0',
    {0x00000002} 'Interaction Point 1',
    {0x00000004} 'Interaction Point 2',
    {0x00000008} 'Interaction Point 3',
    {0x00000010} 'Interaction Point 4',
    {0x00000020} 'Interaction Point 5',
    {0x00000040} 'Interaction Point 6',
    {0x00000080} 'Interaction Point 7',
    {0x00000100} 'Interaction Point 8',
    {0x00000200} 'Interaction Point 9',
    {0x00000400} 'Interaction Point 10',
    {0x00000800} 'Interaction Point 11',
    {0x00001000} 'Interaction Point 12',
    {0x00002000} 'Interaction Point 13',
    {0x00004000} 'Interaction Point 14',
    {0x00008000} 'Interaction Point 15',
    {0x00010000} 'Interaction Point 16',
    {0x00020000} 'Interaction Point 17',
    {0x00040000} 'Interaction Point 18',
    {0x00080000} 'Interaction Point 19',
    {0x00100000} 'Interaction Point 20',
    {0x00200000} 'Interaction Point 21',
    {0x00400000} 'Allow Awake Sound',
    {0x00800000} 'Enter With Weapon Drawn',
    {0x01000000} 'Play Anim When Full',
    {0x02000000} 'Disables Activation',
    {0x04000000} 'Is Perch',
    {0x08000000} 'Must Exit to Talk',
    {0x10000000} 'Use Static Avoid Node',
    {0x20000000} 'Unknown 29',   {Unused}
    {0x40000000} 'Has Model?',
    {0x80000000} 'Is Sleep Furniture'
  ]));

  wbNAMMarkerParam := wbStruct('Marker', [
      wbFloat('Offset X'),
      wbFloat('Offset Y'),
      wbFloat('Offset Z'),
      wbFloatAngle('Rotation Z'),
      wbFormIDCk('Keyword', [KYWD, NULL]),
      wbFromVersion(125, wbInteger('Entry Types', itU8, wbFlags([
        'Front',
        'Rear',
        'Right',
        'Left',
        'Other',
        'Unused 5',
        'Unused 6',
        'Unused 7'
      ]))),
      wbFromVersion(125, wbByteArray('Unused',3))
    ], cpNormal, False, nil, 4);

  wbSNAMMarkerParams := wbArray(SNAM, 'Marker Parameters', wbNAMMarkerParam);
  wbZNAMMarkerParams := wbArray(ZNAM, 'Marker Parameters', wbNAMMarkerParam);

  wbArmorPropertyEnum := wbEnum([
    { 0} 'Enchantments',
    { 1} 'Bash Impact Data Set',
    { 2} 'Block Material',
    { 3} 'Keywords',
    { 4} 'Weight',
    { 5} 'Value',
    { 6} 'Rating',
    { 7} 'Addon Index',
    { 8} 'Body Part',
    { 9} 'Damage Type Value',
    {10} 'Actor Values',
    {11} 'Health',
    {12} 'Color Remapping Index',
    {13} 'Material Swaps',
    {14} 'Durability',
    {15} 'Biped World Model',
    {16} 'Model Swap',
    {17} 'Weight Mult'
  ]);

  wbActorPropertyEnum := wbEnum([
    { 0} 'Keywords',
    { 1} 'Forced Inventory',
    { 2} 'XP Offset',
    { 3} 'Enchantments',
    { 4} 'Color Remapping Index',
    { 5} 'Material Swaps'
  ]);

  wbWeaponPropertyEnum := wbEnum([
    { 0} 'Speed',
    { 1} 'Reach',
    { 2} 'MinRange',
    { 3} 'MaxRange',
    { 4} 'AttackDelaySec',
    { 5} 'Unused 5',
    { 6} 'OutOfRangeDamageMult',
    { 7} 'SecondaryDamage',
    { 8} 'CriticalChargeBonus',
    { 9} 'HitBehaviour',
    {10} 'Rank',
    {11} 'Unknown 11',
    {12} 'AmmoCapacity',
    {13} 'Unknown 13',
    {14} 'Unknown 14',
    {15} 'Type',
    {16} 'IsPlayerOnly',
    {17} 'NPCsUseAmmo',
    {18} 'HasChargingReload',
    {19} 'IsMinorCrime',
    {20} 'IsFixedRange',
    {21} 'HasEffectOnDeath',
    {22} 'HasAlternateRumble',
    {23} 'IsNonHostile',
    {24} 'IgnoreResist',
    {25} 'IsAutomatic',
    {26} 'CantDrop',
    {27} 'IsNonPlayable',
    {28} 'AttackDamage',
    {29} 'Value',
    {30} 'Weight',
    {31} 'Keywords',
    {32} 'AimModel',
    {33} 'AimModelMinConeDegrees',
    {34} 'AimModelMaxConeDegrees',
    {35} 'AimModelConeIncreasePerShot',
    {36} 'AimModelConeDecreasePerSec',
    {37} 'AimModelConeDecreaseDelayMs',
    {38} 'AimModelConeSneakMultiplier',
    {39} 'AimModelRecoilDiminishSpringForce',
    {40} 'AimModelRecoilDiminishSightsMult',
    {41} 'AimModelRecoilMaxDegPerShot',
    {42} 'AimModelRecoilMinDegPerShot',
    {43} 'AimModelRecoilHipMult',
    {44} 'AimModelRecoilShotsForRunaway',
    {45} 'AimModelRecoilArcDeg',
    {46} 'AimModelRecoilArcRotateDeg',
    {47} 'AimModelConeIronSightsMultiplier',
    {48} 'HasScope',
    {49} 'ZoomDataFOVMult',
    {50} 'FireSeconds',
    {51} 'NumProjectiles',
    {52} 'AttackSound',
    {53} 'AttackSound2D',
    {54} 'AttackLoop',
    {55} 'AttackFailSound',
    {56} 'IdleSound',
    {57} 'EquipSound',
    {58} 'UnEquipSound',
    {59} 'SoundLevel',
    {50} 'ImpactDataSet',
    {61} 'Ammo',
    {62} 'CritEffect',
    {63} 'BashImpactDataSet',
    {64} 'BlockMaterial',
    {65} 'Enchantments',
    {66} 'AimModelBaseStability',
    {67} 'ZoomData',
    {68} 'ZoomDataOverlay',
    {69} 'ZoomDataImageSpace',
    {70} 'ZoomDataCameraOffsetX',
    {71} 'ZoomDataCameraOffsetY',
    {72} 'ZoomDataCameraOffsetZ',
    {73} 'EquipSlot',
    {74} 'SoundLevelMult',
    {75} 'NPCAmmoList',
    {76} 'ReloadSpeed',
    {77} 'DamageTypeValues',
    {78} 'AccuracyBonus',
    {79} 'AttackActionPointCost',
    {80} 'OverrideProjectile',
    {81} 'HasBoltAction',
    {82} 'StaggerValue',
    {83} 'SightedTransitionSeconds',
    {84} 'FullPowerSeconds',
    {85} 'HoldInputToPower',
    {86} 'HasRepeatableSingleFire',
    {87} 'MinPowerPerShot',
    {88} 'ColorRemappingIndex',
    {89} 'MaterialSwaps',
    {90} 'CriticalDamageMult',
    {91} 'FastEquipSound',
    {92} 'DisableShells',
    {93} 'HasChargingAttack',
    {94} 'ActorValues',
    {95} 'ReachEngagementMult',
    {96} 'Health',
    {97} 'Durability',
    {98} 'NPCReloadDelay',
    {99} 'ZoomDataFOVMultB',
   {100} 'ZoomDataFOVMultC',
   {101} 'UnsightedTransitionSeconds',
   {102} 'MinWeaponDrawTime',
   {103} 'ModelSwap',
   {104} 'MinChargeTime',
   {105} 'PowerAffectsProjectileSpeed',
   {106} 'DamageBonusMult',
   {107} 'AimAssistModel',
   {108} 'WeightMult',
   {109} 'AmmoConsumption',
   {110} 'Overheating',
   {111} 'OverheatRateUp',
   {112} 'OverheatRateDown'
  ]);

  wbStorefrontData :=
    wbRStruct('Storefront Data', [
      wbString(ETIP, 'Storefront Image Path'),
      wbString(ETDI, 'Storefront Preview Image'),
      wbFormID(ETLG, 'Entitlement Loadout Reference'),
      wbRArray('Storefront Confirm Image List', wbString(ECIL, 'Image'))
    ], []).IncludeFlag(dfAllowAnyMember);

  wbObjectModProperties :=
    wbArrayS('Properties', wbStructSK([4], 'Property', [
      wbInteger('Value Type', itU8, wbEnum([
        {0} 'Int',
        {1} 'Float',
        {2} 'Bool',
        {3} 'String',
        {4} 'FormID,Int',
        {5} 'Enum',
        {6} 'FormID,Float'
      ])),
      wbByteArray('Unused', 3, cpIgnore),
      wbUnion('Function Type', wbOMODDataFunctionTypeDecider, [
        { Float }  wbInteger('Function Type', itU8, wbEnum(['SET', 'MUL+ADD', 'ADD'])),
        { Bool }   wbInteger('Function Type', itU8, wbEnum(['SET', 'AND', 'OR'])),
        { Enum }   wbInteger('Function Type', itU8, wbEnum(['SET'])),
        { FormID } wbInteger('Function Type', itU8, wbEnum(['SET', 'REM', 'ADD']))
      ]),
      wbByteArray('Unused', 3, cpIgnore),
      wbInteger('Property', itU16, wbObjectModPropertyToStr, wbObjectModPropertyToInt),
      wbByteArray('Unused', 2, cpIgnore),
      wbUnion('Value 1', wbOMODDataPropertyValue1Decider, [
        { 0} wbByteArray('Value 1 - Unknown', 4),
        { 1} wbInteger('Value 1 - Int', itS32),
        { 2} wbFloat('Value 1 - Float'),
        { 3} wbInteger('Value 1 - Bool', itU32, wbBoolEnum),
        { 4} wbFormID('Value 1 - FormID'),
        { 5} wbInteger('Value 1 - Enum', itU32),
        { 6} wbInteger('Sound Level', itU32, wbSoundLevelEnum),
        { 7} wbInteger('Stagger Value', itU32, wbStaggerEnum),
        { 8} wbInteger('Hit Behaviour', itU32, wbHitBehaviourEnum)
      ]),
      wbUnion('Value 2', wbOMODDataPropertyValue2Decider, [
        wbByteArray('Unused', 4, cpIgnore),
        wbInteger('Value 2 - Int', itU32),
        wbFloat('Value 2 - Float'),
        wbInteger('Value 2 - Bool', itU32, wbBoolEnum)
      ]),
      wbUnion('Step', wbFormVersionDecider(192), [
        wbFloat('Step'),
        wbFormIDCk('Curve Table', [CURV, NULL])
      ])
    ]), wbOMODDataPropertyCounter, cpNormal, False, nil, wbOMODpropertyAfterSet);

  wbOBTSReq := wbStruct(OBTS, 'Object Mod Template Item', [
    wbInteger('Include Count', itU32),  // fixed name for wbOMOD* handlers
    wbInteger('Property Count', itU32), // fixed name for wbOMOD* handlers
    wbInteger('Level Min', itU8),
    wbByteArray('Unused', 1),
    wbInteger('Level Max', itU8),
    wbByteArray('Unused', 1),
    wbInteger('Addon IndexParent Combination Index', itS16{, wbOBTEAddonIndexToStr, nil, cpNormal, True, nil, nil, -1}),
    wbInteger('Default', itU8, wbBoolEnum),
    wbArray('Keywords', wbFormIDCk('Keyword', [KYWD, NULL]), -4),
    wbInteger('Min Level For Ranks', itU8),
    wbInteger('Alt Levels Per Tier', itU8),
    wbArray('Includes', wbStruct('Include', [
      wbFormIDCk('Mod', [OMOD]),
      wbInteger('Attach Point Index', itU8),
      wbInteger('Optional', itU8, wbBoolEnum),
      wbInteger('Don''t Use All', itU8, wbBoolEnum)
    ]), wbOMODDataIncludeCounter, cpNormal, False, nil, wbOMODincludeAfterSet),
    wbObjectModProperties
  ], cpNormal, True);

  wbObjectTemplate := wbRStruct('Object Template', [
    wbInteger(OBTE, 'Count', itU32, nil, cpBenign),
    wbRArray('Combinations',
      wbRStruct('Combination', [
        wbEmpty(OBTF, 'Editor Only'),
        wbFULL,
        wbOBTSReq
      ], [], cpNormal, False, nil, True),
      cpNormal, False, nil, wbOBTSCombinationsAfterSet),
    wbEmpty(STOP, 'Marker', cpNormal, True)
  ], []);

  // Forwarded from FO4 defs
  var wbBoneDataItem :=
      wbRStruct('Bone Data Set', [
        wbRStruct('Bone Weight Scale Data', [
          wbInteger(BSMP, 'Weight Scale Target Gender', itU32, wbEnum(['Male', 'Female'])),
          wbRArrayS('Bone Weight Scales',
            wbRStructSK([0], 'Bone Weight Scale Set', [
              wbString(BSMB, 'Name'),
              wbStruct(BSMS, 'Scale Set', [
                wbVec3('Thin'),
                wbVec3('Muscular'),
                wbVec3('Fat')
              ])
              .SetSummaryKeyOnValue([0,1,2])
              .SetSummaryPrefixSuffixOnValue(0, 'Thin: ', '')
              .SetSummaryPrefixSuffixOnValue(1, 'Muscular: ', '')
              .SetSummaryPrefixSuffixOnValue(2, 'Fat: ', '')
              .SetSummaryDelimiterOnValue(', ')
              .SetRequired
            ], [])
            .SetSummaryKey([1])
            .IncludeFlag(dfCollapsed, wbCollapseRACEBoneData)
          )
        ],[]),
        wbRStruct('Bone Range Modifier Data', [
          wbInteger(BMMP, 'Range Modifier Target Gender', itU32, wbEnum(['Male', 'Female'])),
          wbRArrayS('Bone Range Modifiers',
            wbRStructSK([0], 'Bone Range Modifier', [
              wbString(BSMB, 'Name'),
              wbStruct(BSMS, 'Range', [
                wbFloat('Min Y'),
                wbFloat('Min Z'),
                wbFloat('Max Y'),
                wbFloat('Max Z')
              ])
              .SetSummaryKeyOnValue([0,2,1,3])
              .SetSummaryPrefixSuffixOnValue(0, 'Y: [', '')
              .SetSummaryPrefixSuffixOnValue(2, 'to ', '],')
              .SetSummaryPrefixSuffixOnValue(1, 'Z: [', '')
              .SetSummaryPrefixSuffixOnValue(3, 'to ', ']')
              .IncludeFlag(dfCollapsed, wbCollapseRange)
              .SetRequired
            ], [])
            .SetSummaryKey([1])
            .IncludeFlag(dfCollapsed, wbCollapseRACEBoneData)
          )
        ],[])
      ], []);

  var wbArmorAddonBoneDataItem :=
      wbRStruct('Bone Scale Modifier Set', [
        wbInteger(BSMP, 'Target Gender', itU32, wbEnum(['Male', 'Female'])),
        wbRArrayS('Bone Scale Modifiers',
          wbRStructSK([0], 'Bone Scale Modifier', [
            wbString(BSMB, 'Bone Name'),
            wbStruct(BSMS, 'Bone Scale Delta', [
              wbFloat('X'),
              wbFloat('Y'),
              wbFloat('Z')
            ])
            .SetSummaryKeyOnValue([0,1,2])
            .SetSummaryPrefixSuffixOnValue(0, '[', '')
            .SetSummaryPrefixSuffixOnValue(1, ' ', '')
            .SetSummaryPrefixSuffixOnValue(2, ' ', ']')
            .SetSummaryDelimiterOnValue(',')
            .IncludeFlag(dfSummaryNoName)
            .includeFlag(dfCollapsed, wbCollapseVec3)
            .SetRequired
          ], [])
          .SetSummaryKey([1])
          .IncludeFlag(dfCollapsed, wbCollapseARMABoneData)
        )
      ], []);

  wbBSMPSequence := wbRArray('Bone Scale Data', wbBoneDataItem);

  wbArmorAddonBSMPSequence := wbRArray('Sculpt Data', wbArmorAddonBoneDataItem);

  wbCTRN := wbByteArray(CTRN, 'Unknown CTRN', 13);

  var wbEffect :=
    wbRStruct('Effect', [
      wbEFID,
      wbEFIT,
      wbFormIDCk(CVT0, 'Curve Table', [CURV]),
      wbFormIDCk(MAGA, 'Actor Value', [AVIF]),
      wbInteger(MAGF, 'Effect Flags', itU32, wbFlags([
        {0x00000001} { 0} 'Unknown 0',
        {0x00000002} { 1} 'Unknown 1',
        {0x00000004} { 2} 'Unknown 2',
        {0x00000008} { 3} 'Unknown 3',
        {0x00000010} { 4} 'Unknown 4',
        {0x00000020} { 4} 'Unknown 5',
        {0x00000040} { 6} 'Unknown 6',
        {0x00000080} { 7} 'Unknown 7',
        {0x00000100} { 8} 'Unknown 8',
        {0x00000200} { 9} 'Unknown 9',
        {0x00000400} {10} 'Unknown 10',
        {0x00000800} {11} 'Unknown 11',
        {0x00001000} {12} 'Unknown 12',
        {0x00002000} {13} 'Unknown 13',
        {0x00004000} {14} 'Unknown 14',
        {0x00008000} {15} 'Unknown 15',
        {0x00010000} {16} 'Unknown 16',
        {0x00020000} {17} 'Unknown 17',
        {0x00040000} {18} 'Unknown 18',
        {0x00080000} {19} 'Unknown 19',
        {0x00100000} {20} 'Unknown 20',
        {0x00200000} {21} 'Unknown 21',
        {0x00400000} {22} 'Unknown 22',
        {0x00800000} {23} 'Unknown 23',
        {0x01000000} {24} 'Unknown 24',
        {0x02000000} {25} 'Unknown 25',
        {0x04000000} {26} 'Unknown 26',
        {0x08000000} {27} 'Unknown 27',
        {0x10000000} {28} 'Unknown 28',
        {0x20000000} {29} 'Unknown 29',
        {0x40000000} {30} 'Unknown 30',
        {0x80000000} {31} 'Unknown 31'
      ])),
      wbCTDAs,
      wbFormIDCk(DURG, 'Duration', [GLOB]),
      wbFormIDCk(MAGG, 'Magnitude', [GLOB]),
      wbFormIDCk(EIES, 'Next Stage', [SPEL]),
      wbInteger(CODV, 'Cooldown Duration', itU32)
    ], [], cpNormal, True);

  wbEffectsReq :=
    wbRArray('Effects', wbEffect, cpNormal); { Change this before pushing }

  wbRecord(ACTI, 'Activator',
    wbFlags(wbFlagsList([
       2, 'Never Fades',
       4, 'Non Occluder',
       6, 'Unknown 6',
       7, 'Heading Marker',
       8, 'Must Update Anims',
       9, 'Hidden From Local Map',
      10, 'Headtrack Marker',
      11, 'Used as Platform',
      13, 'Pack-In Use Only',
      15, 'Has Distant LOD',
      16, 'Random Anim Start',
      17, 'Dangerous',
      19, 'Unknown 19',
      20, 'Ignore Object Interaction',
      23, 'Is Marker',
      25, 'Obstacle',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      29, 'Child Can Use',
      30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSTCP,
    wbOPDSs,
    wbDEFL,
    wbSNTP,
    wbOPDSs,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbRArray('Factions', wbDOFA, cpNormal),
    wbKeywords,
    wbPRPS,
    wbNTRM,
    wbFTYP,
    wbNTRM,
    wbUnknown(MNAM),
    wbNAM1LODP,
    wbByteRGBA(PNAM, 'Marker Color'),
    wbFormIDCk(SNAM, 'Sound - Looping', [SNDR]),
    wbFormIDCk(VNAM, 'Sound - Activation', [SNDR]),
    wbFormIDCk(WNAM, 'Water Type', [WATR]),
    wbQSTI,
    wbUnknown(AIID),
    wbATTX,
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      'No Displacement',
      'Ignored by Sandbox',
      'Unknown 2', {Only used on DefaultProceduralWater [ACTI:00000019]}
      'Unknown 3', {Currently Unused}
      'Is a Radio',
      'Is a Lookat Trigger',
      'Unknown 6' {Currently Unused}
    ])),
    wbInteger(LAVT, 'Lookat Value', itU32),
    wbInteger(LAMN, 'Lookat Minimum', itU32),
    wbInteger(LAMX, 'Lookat Maximum', itU32),
    wbFormIDCk(KNAM, 'Interaction Keyword', [KYWD]),
    wbStruct(RADR, 'Radio Receiver', [
      wbFromVersion(92, wbFormIDCk('Sound Model', [SOPM, NULL])),
      wbFloat('Frequency'),
      wbFloat('Volume'),
      wbInteger('Starts Active', itU8, wbBoolEnum),
      wbFromVersion(121, wbInteger('No Signal Static', itU8, wbBoolEnum))
    ], cpNormal, False, nil, 4),
    wbCNDCs,
    wbFormIDCk(GCDA, 'Global Cooldown Timer', [GLOB]),
    wbArray(VEND, 'Vendable Item Datas',
      wbStruct('Vendable Item Data', [
        wbFormID('Allowed Item List'),
        wbFromVersion(191, wbFormID('Excluded Item List')),
        wbInteger('Unknown', itU32),
        wbInteger('Max Amount', itU32)
      ])
    ),
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN,
    wbFromSize(1, NVNM, wbNVNMRecordVal, False),
    wbUnknown(MNAM),
    wbNAM1LODP
  ]);

  { Inherits from ACTI }
  wbRecord(TACT, 'Talking Activator',
    wbFlags(wbFlagsList([
      {0x00000200}  9, 'Hidden From Local Map',
      {0x00010000} 16, 'Random Anim Start',
      {0x00020000} 17, 'Radio Station'
    ]), [17]), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbNAM1LODP,
    wbByteRGBA(PNAM, 'Marker Color'),
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR]),
    wbQSTI,
    wbUnknown(AIID),
    wbInteger(FNAM, 'Flags (Unused)', itU16),
    wbCNDCs,
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN,
    wbFormIDCk(GCDA, 'Clobal Cooldown Timer', [GLOB]),
    wbFormIDCk(VNAM, 'Voice Type', [VTYP]),
    wbFormIDCk(FNAM, 'Faction', [FACT])
  ]);

  wbMIID := wbInteger(MIID, 'Max Item ID', itU32);

  wbRecord(ALCH, 'Ingestible',
    wbFlags(wbFlagsList([
      {0x00000002}  2, 'Unknown 1',
      {0x20000000} 29, 'Medicine'
    ])), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbPHST,
    wbXALG,
    wbFULL,
    wbKeywords,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbYNAM,
    wbZNAM,
    wbETYP,
    wbCUSD,
    wbDEST,
    wbDESC,
    wbFloat(DATA, 'Weight', cpNormal, True),
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'No Auto-Calc',
        {0x00000002} 'Food Item',
        {0x00000004} 'Unknown 2',  //Unused
        {0x00000008} 'Unknown 3',
        {0x00000010} 'Persists on World Change',
        {0x00000020} 'Unknown 5',  //Unused
        {0x00000040} 'Unknown 6',  //Unused
        {0x00000080} 'Unknown 7',  //Unused
        {0x00000100} 'Unknown 8',  //Unused
        {0x00000200} 'Unknown 9', //Unused
        {0x00000400} 'Unknown 10', //Unused
        {0x00000800} 'Unknown 11', //Unused
        {0x00001000} 'Unknown 12', //Unused
        {0x00002000} 'Unknown 13', //Unused
        {0x00004000} 'Unknown 14', //Unused
        {0x00008000} 'Unknown 15', //Unused
        {0x00010000} 'Medicine',
        {0x00020000} 'Poison',
        {0x00040000} 'Unknown 18',  //Unused
        {0x00080000} 'Unknown 19'
      ])),
      wbFormIDCk('Addiction', [SPEL, NULL]),
      wbFloat('Addiction Chance'),
      wbFormIDCk('Sound - Consume', [SNDR, NULL]),
      wbFromVersion(171, wbFormIDCk('Health', [CURV, NULL])),
      wbFromVersion(176, wbFormIDCk('Spoiled', [ALCH, NULL]))
    ], cpNormal, True),
    wbLStringKC(DNAM, 'Addiction Name', 0, cpTranslate),
    wbEffectsReq,
    wbMIID
  ]);

  wbRecord(AMMO, 'Ammunition',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbPHST,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbDESC,
    wbKeywords,
    wbVCRY,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True, nil, 1),
    wbStruct(DNAM, '', [
      wbFormIDCk('Projectile', [PROJ, NULL]),
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Ignores Normal Weapon Resistance',
        {0x02} 'Non-Playable',
        {0x04} 'Has Count Based 3D'
      ])),
      wbByteArray('Unused', 3),
      wbFloat('Damage'),
      wbInteger('Health', itU32)
    ], cpNormal, True),
    wbLStringKC(ONAM, 'Short Name', 0, cpTranslate),
    wbString(NAM1, 'Casing Model'),
    wbModelInfo(NAM2)
  ]);

  wbRecord(ANIO, 'Animated Object',
    wbFlags(wbFlagsList([
      {0x00000200}  9, 'Unknown 9'
    ]), [9]), [
    wbEDID,
    wbGenericModel,
    wbString(BNAM, 'Unload Event')
  ]);

  wbRecord(ARMO, 'Armor',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable',
      {0x00000040}  6, 'Shield',
      {0x00000200}  9, 'Unknown 9',
      {0x00000400} 10, 'Unknown 10',
      {0x00008000} 15, 'Unknown 15'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbRArray('Unknown ENLM', wbENLM),
    wbOPDSs,
    wbPTRN,
    wbPHST,
    wbSNTP,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbEITM,
    wbTexturedModel('Male World Model', [MOD2, MO2T], [wbMODC, wbMO2S, wbENLT, wbENLS, wbAUUV]),
    wbString(ICON, 'Male Inventory Image'),
    wbString(MICO, 'Male Message Icon'),
    wbTexturedModel('Female World Model', [MOD4, MO4T], [wbMODC, wbMO4S, wbENLT, wbENLS, wbAUUV]),
    wbString(ICO2, 'Female Inventory Image'),
    wbString(MIC2, 'Female Message Icon'),
    wbBOD2,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbETYP,
    wbFormIDCk(BIDS, 'Block Bash Impact Data Set', [IPDS, NULL]),
    wbFormIDCk(BAMT, 'Alternate Block Material', [MATT, NULL]),
    wbFormIDCk(RNAM, 'Race', [RACE]),
    wbKeywords,
    wbDESC,
    wbINRD,
    wbEILV,
    wbIBSD,
    wbRArray('Models',
      wbRStruct('Model', [
        wbInteger(INDX, 'Addon Index', itU16),
        wbFormIDCk(MODL, 'Armor Addon', [ARMA])
      ], [])
    ),
    wbStruct(DATA, 'Armor Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight'),
      wbFromVersion(109, wbInteger('Health', itU32))
    ], cpNormal, True),
    wbStruct(FNAM, 'Rating Addon Data', [
      wbInteger('Armor Rating', itU16),
      wbInteger('Base Addon Index', itU16),
      wbFromVersion(99, wbInteger('Stagger Rating', itU32, wbStaggerEnum)),
      wbFromVersion(192, wbByteArray('Unknown',4))
    ]),
    wbDamageTypeArray('Resistance'),
    wbFormIDCk(TNAM, 'Template Armor', [ARMO]),
    wbAPPR,
    wbObjectTemplate,
    wbFormIDCk(CVT0, 'DR', [CURV]),
    wbFormIDCk(CVT1, 'Durability Min', [CURV]),
    wbFormIDCk(CVT2, 'Condition Damage Scale Factor', [CURV]),
    wbFormIDCk(CVT3, 'Durability Max', [CURV]),
    wbFormIDCk(ABPO, 'Armor Backpack Position Offset', [NULL, TRNS]),
    wbDIQO,
    wbVCRY
  ], False, nil, cpNormal, False, wbARMOAfterLoad);

  wbRecord(ARMA, 'Armor Addon',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000040}  6, 'No Underarmor Scaling',
      {0x00000200}  9, 'Unknown 9',
      {0x40000000} 30, 'Hi-Res 1st Person Only'
    ])), [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbBOD2,
    wbFormIDCk(RNAM, 'Race', [RACE]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Male Priority', itU8),
      wbInteger('Female Priority', itU8),
      // essentialy a number of world models for different weights (Enabled = 2 models _0.nif and _1.nif)
      wbInteger('Weight slider - Male', itU8, wbFlags([
        {0x01} 'Unknown 0',
        {0x02} 'Enabled'
      ])),
      wbInteger('Weight slider - Female', itU8, wbFlags([
        {0x01} 'Unknown 0',
        {0x02} 'Enabled'
      ])),
      wbByteArray('Unknown', 2),
      wbInteger('Detection Sound Value', itU8),
      wbByteArray('Unknown', 1),
      wbFloat('Weapon Adjust')
    ], cpNormal, True),
    wbTexturedModel('Male Biped Model', [MOD2, MO2T], [wbMO2C, wbMO2S, wbModelXFLG, wbENLT, wbENLS, wbAUUV, wbMO2F]),
    wbTexturedModel('Female Biped Model', [MOD3, MO3T], [wbMO3C, wbMO3S, wbModelXFLG, wbENLT, wbENLS, wbAUUV, wbMO3F]),
    wbTexturedModel('Male 1st Person', [MOD4, MO4T], [wbMO4C, wbMO4S, wbENLT, wbENLS, wbAUUV, wbMO4F]),
    wbTexturedModel('Female 1st Person', [MOD5, MO5T], [wbMO5C, wbMO5S, wbENLT, wbENLS, wbAUUV, wbMO5F]),
    wbFormIDCK(NAM0, 'Male Skin Texture', [TXST, NULL]),
    wbFormIDCK(NAM1, 'Female Skin Texture', [TXST, NULL]),
    wbFormIDCK(NAM2, 'Male Skin Texture Swap List', [FLST, NULL]),
    wbFormIDCK(NAM3, 'Female Skin Texture Swap List', [FLST, NULL]),
    wbRArrayS('Additional Races', wbFormIDCK(MODL, 'Race', [RACE, NULL])),
    wbFormIDCk(SNDD, 'Footstep Sound', [FSTS, NULL]),
    wbFormIDCk(ONAM, 'Art Object', [ARTO]),
    wbArmorAddonBSMPSequence,
    wbInteger(VONL, 'Unknown Bool', itU8, wbBoolEnum)
  ], False, nil, cpNormal, False, wbARMAAfterLoad);

  wbRecord(BOOK, 'Book', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbDEFL,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbDESCreq,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbFormIDCk(FIMD, 'Featured Item Message', [MESG]),
    wbVCRY,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbStruct(DNAM, '', [
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Advance Actor Value',
        {0x02} 'Can''t be Taken',
        {0x04} 'Add Spell',
        {0x08} 'Unknown 3',
        {0x10} 'Add Perk',
        {0x20} 'Is Recipe'//???
      ])),
      wbUnion('Teaches', wbBOOKTeachesDecider, [
        wbByteArray('Unused', 4),
        wbFormIDCk('Actor Value', [AVIF, NULL]),
        wbFormIDCk('Spell', [SPEL, NULL]),
        wbFormIDCk('Perk', [PERK, NULL])
      ]),
      wbStruct('Text Offset' , [
        wbInteger('X', itS32),
        wbInteger('Y', itS32)
      ])
    ], cpNormal, True),
    wbLStringKC(CNAM, 'Description', 0, cpTranslate),
    wbFormIDCk(INAM, 'Inventory Art', [STAT]),
    wbDIQO,
    wbInteger(BTOF, 'Book Take Flags', itU32, wbFlags([
        {0x01} 'Unknown 1',
        {0x02} 'Can''t be Taken',
        {0x04} 'Unknown 3',
        {0x08} 'Unknown 4',
        {0x10} 'Unknown 5',
        {0x20} 'Unknown 6'
      ])),
    wbFormId(BVGO, 'Gold Bullion Value')
  ]);

{>>>
  Skrim has its own ref record for every projectile type
  PARW 'Arrow'
  PBEA 'Beam'
  PFLA 'Flame'
  PCON 'Cone' (voice)
  PBAR 'Barrier'
  PGRE 'Traps'
  PHZD 'Hazards'
  I guess all of them have the same structure
<<<}
  ReferenceRecord(PARW, 'Placed Arrow');
  ReferenceRecord(PBAR, 'Placed Barrier');
  ReferenceRecord(PBEA, 'Placed Beam');
  ReferenceRecord(PCON, 'Placed Cone/Voice');
  ReferenceRecord(PFLA, 'Placed Flame');
  ReferenceRecord(PGRE, 'Placed Projectile');
  ReferenceRecord(PHZD, 'Placed Hazard');
  ReferenceRecord(PMIS, 'Placed Missile');

  wbCellFlags := wbFlags([
      {0x000001} 'Is Interior Cell',
      {0x000002} 'Has Water',
      {0x000004} 'Can Travel From Here',
      {0x000008} 'No LOD Water',
      {0x000010} 'Entry disallowed',
      {0x000020} 'Public Area',
      {0x000040} 'Hand Changed',
      {0x000080} 'Show Sky',
      {0x000100} 'Use Sky Lighting',
      {0x000200} 'Unknown 9',
      {0x000400} 'Hidden from Interior Cell List',
      {0x000800} 'Sunlight Shadows',
      {0x001000} 'Distant LOD only',
      {0x002000} 'Player Followers Can''t Travel Here',
      {0x004000} 'Unknown 14',
      {0x008000} 'Is Instanced',
      {0x010000} 'NWTemp entry disallowed',
      {0x020000} 'Adventure entry disallowed',
      {0x040000} 'Survival entry disallowed',
      {0x080000} 'Nuclear Winter entry disallowed',
      {0x100000} 'Unknown 20',
      {0x200000} 'Unknown 21'
    ]);

  wbRecord(CELL, 'Cell',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Is Instancable',
      {0x00000040}  6, 'Unknown 6',
      {0x00000080}  7, 'No Pre Vis',
      {0x00000400} 10, 'Persistent',
      {0x00004000} 14, 'Partial Form',
      {0x00020000} 17, 'Off Limits',
      {0x00040000} 18, 'Compressed',
      {0x00080000} 19, 'Can''t Wait'
    ]), [14, 18])
      .SetFlagHasDontShow(14, wbFlagPartialFormDontShow),
  [
    wbEDID,
    wbDURL,
    wbXALG,
    wbFULL,
    wbUnion(DATA, 'Flags', wbDeciderCELLFlags, [
      wbInteger('', itU16, wbCELLFlags),
      wbInteger('', itU32, wbCELLFlags)
    ], cpNormal, True).SetAfterSet(wbCELLDATAAfterSet),

    wbByteArray(VISI, 'PreVis File Hash', 4),//.SetToStr(wbTimeStampToString),
    wbFormIDCk(RVIS, 'In PreVis File Of', [CELL]),
    wbByteArray(PCMB, 'PreCombined Files Timestamp', 2).SetToStr(wbTimeStampToString),

    wbCellGrid,

    wbStruct(XCLL, 'Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color Near'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade'),
      wbFloat('Fog Clip Distance'),
      wbFloat('Fog Power'),
      wbAmbientColors('Ambient Colors'),
      wbByteColors('Fog Color Far'),
      wbFloat('Fog Max'),
      wbFloat('Light Fade Begin'),
      wbFloat('Light Fade End'),
      wbInteger('Inherits', itU32, wbFlags([
        {0x00000001} 'Ambient Color',
        {0x00000002} 'Directional Color',
        {0x00000004} 'Fog Color',
        {0x00000008} 'Fog Near',
        {0x00000010} 'Fog Far',
        {0x00000020} 'Directional Rotation',
        {0x00000040} 'Directional Fade',
        {0x00000080} 'Clip Distance',
        {0x00000100} 'Fog Power',
        {0x00000200} 'Fog Max',
        {0x00000400} 'Light Fade Distances',
        {0x00000800} 'Unknown 11',
        {0x00001000} 'Unknown 12',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'Unknown 14',
        {0x00008000} 'Unknown 15',
        {0x00010000} 'Unknown 16',
        {0x00020000} 'Unknown 17',
        {0x00040000} 'Unknown 18',
        {0x00080000} 'Unknown 19',
        {0x00100000} 'Unknown 20',
        {0x00200000} 'Unknown 21',
        {0x00400000} 'Unknown 22',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'Unknown 27',
        {0x10000000} 'Unknown 28',
        {0x20000000} 'Unknown 29',
        {0x40000000} 'Unknown 30'
      ])),
      wbFloat('Near Height Mid'),
      wbFloat('Near Height Range'),
      wbByteColors('Fog Color High Near'),
      wbByteColors('Fog Color High Far'),
      wbFloat('High Density Scale'),
      wbFloat('Fog Near Scale'),
      wbFloat('Fog Far Scale'),
      wbFloat('Fog High Near Scale'),
      wbFloat('Fog High Far Scale'),
      wbFloat('Far Height Mid'),
      wbFloat('Far Height Range'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown')
    ], cpNormal, False, nil, 11),

    wbInteger(CNAM, 'Precombined Object Level XY', itU8),
    wbInteger(ZNAM, 'Precombined Object Level Z', itU8),
    wbByteArray(TVDT, 'Unknown', 0, cpNormal),
    wbMHDTCELL
    .IncludeFlag(dfCollapsed),
    wbFormIDCk(LTMP, 'Lighting Template', [LGTM, NULL], False, cpNormal, True),

    {>>> XCLW sometimes has $FF7FFFFF and causes invalid floation point <<<}
    wbFloat(XCLW, 'Water Height', cpNormal, False, 1, -1, nil, nil, 0, wbCELLXCLWGetConflictPriority),
    wbFloat(XILS),
    wbFormIDCk(RDES, 'Unknown Reference', [REFR]),
    wbUnknown(NAVH),
    wbFormIDCk(XCWT, 'Water Type', [WATR]),
    wbArrayS(XCLR, 'Regions', wbFormIDCk('Region', [REGN])),
    wbXLCN,
    wbWaterData,

    {--- Ownership ---}
    wbXOWN,
    wbXRNK,

    wbFormIDCk(XILL, 'Lock List', [FLST, NPC_]),

    wbStruct(XILW, 'Interior LOD', [
      wbFormIDCk('Worldspace', [WRLD]),
      wbFloat('Offset X'),
      wbFloat('Offset Y'),
      wbFloat('Offset Z')
    ]),
    wbString(XWEM, 'Water Environment Map'),
    wbFormIDCk(XCCM, 'Sky/Weather from Region', [REGN]),
    wbFormIDCk(XCAS, 'Acoustic Space', [ASPC]),
    wbXEZN,
    wbFormIDCk(XCMO, 'Music Type', [MUSC]),
    wbFormIDCk(XCIM, 'Image Space', [IMGS]),
    wbFormIDCk(XGDR, 'God Rays', [GDRY]),

    // those can be sorted I think, but makes copying records very slow since some cells have over 22000+ entries
    // DLC01Lair01 "The Mechanist's Lair" [CELL:010008A3]
    wbArrayS(XPRI, 'Physics References', wbFormIDCk('Reference', [REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA])),
    wbStruct(XCRI, 'Combined References', [
      wbInteger('Meshes Count', itU64),
      wbInteger('References Count', itU64),
      wbArrayS('Meshes', wbStruct('Mesh', [
        wbInteger('Combined Mesh', itU32, wbCombinedMeshIDToStr, wbCombinedMeshIDToInt),
        wbByteArray('Unknown', 4)
      ]), wbCELLCombinedMeshesCounter, cpNormal, False, nil, wbCELLCombinedMeshesAfterSet),
      wbArrayS('References',  wbStructSK([0], 'Reference', [
        wbFormIDCk('Reference', [REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
        wbByteArray('Unknown', 4),
        wbInteger('Combined Mesh', itU32, wbCombinedMeshIDToStr, wbCombinedMeshIDToInt),
        wbByteArray('Unknown', 4)
      ]), wbCELLCombinedRefsCounter, cpNormal, False, nil, wbCELLCombinedRefsAfterSet)
    ]),
    wbStruct(XCRP, 'Enable State Parents', [
      wbInteger('Unknown Int', itU32),
      wbArray('References', wbFormID('Reference'))
    ]),
    wbByteArray(XCPF, 'Combined Physics', 4),
    wbStruct(XISR, 'Interior Sky Override', [
      wbFormID('Weather'),
      wbFloat('Unknown float')
    ]),
    wbFloat(CII0),
    wbFloat(CIDH)
  ], True, wbCellAddInfo, cpNormal, False{, wbCELLAfterLoad});

  wbRecord(CLAS, 'Class', [
    wbEDID,
    wbFULLReq,
    wbDESCReq,
    wbICON,
    wbPRPS,
    wbStruct(DATA, 'Data', [
      wbByteArray('Unknown', 4),
      wbFloat('Bleedout Default')
    ])
  ]);

  wbRecord(CLMT, 'Climate', [
    wbEDID,
    wbArrayS(WLST, 'Weather Types', wbStructSK([0], 'Weather Type', [
      wbFormIDCk('Weather', [WTHR, NULL]),
      wbInteger('Chance', itS32),
      wbFormIDCk('Global', [GLOB, NULL])
    ])),
    wbString(FNAM, 'Sun Texture'),
    wbString(GNAM, 'Sun Glare Texture'),
    wbGenericModel,
    wbClimateTiming(wbClmtTime, wbClmtMoonsPhaseLength)
  ]);

  wbRecord(SPGD, 'Shader Particle Geometry', [
    wbEDID,
    wbStruct(DATA, 'Data', [
      wbFloat('Gravity Velocity'),
      wbUnused(4),
      wbFloat('Rotation Velocity'),
      wbUnused(4),
      wbFloat('Particle Size X'),
      wbUnused(4),
      wbFloat('Particle Size Y'),
      wbUnused(4),
      wbFloat('Center Offset Min'),
      wbUnused(4),
      wbFloat('Center Offset Max'),
      wbUnused(4),
      wbFloat('Initial Rotation'),
      wbUnused(4),
      wbInteger('# of Subtextures X', itU32),
      wbUnused(4),
      wbInteger('# of Subtextures Y', itU32),
      wbUnused(4),
      wbInteger('Type', itU32, wbEnum([
        'Rain',
        'Snow'
      ])),
      wbUnused(4),
      wbInteger('Box Size', itU32),
      wbUnused(4),
      wbFloat('Particle Density'),
      wbUnused(4)
    ], cpNormal, True, nil, 10),
    wbString(MNAM, 'Particle Texture')
  ]);

  wbRecord(RFCT, 'Visual Effect', [
    wbEDID,
    wbStruct(DATA, 'Effect Data', [
      wbFormIDCK('Effect Art', [ARTO, NULL]),
      wbBelowVersion(134, wbFormIDCK('Unused', [EFSH, NULL])),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Rotate to Face Target',
        {0x00000002} 'Attach to Camera',
        {0x00000004} 'Inherit Rotation',
        {0x00000008} 'Unknown 4',
        {0x00000010} 'Unknown 5',
        {0x00000020} 'Unknown 6',
        {0x00000040} 'Unknown 7',
        {0x00000080} 'Unknown 8',
        {0x00000100} 'Unknown 9',
        {0x00000200} 'Unknown 10',
        {0x00000400} 'Unknown 11',
        {0x00000800} 'Unknown 12',
        {0x00001000} 'Unknown 13',
        {0x00002000} 'Unknown 14',
        {0x00004000} 'Unknown 15',
        {0x00008000} 'Unknown 14',
        {0x00010000} 'Unknown 17',
        {0x00020000} 'Unknown 18',
        {0x00040000} 'Unknown 19'
      ]))
    ], cpNormal, True)
  ]);

  wbRecord(CONT, 'Container',
    wbFlags(wbFlagsList([
      15, 'Has Distant LOD',
      16, 'Random Anim Start',
      25, 'Obstacle',
      26, 'NavMesh - Filter',
      27, 'NavMesh - Bounding Box',
      30, 'NavMesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbPHST,
    wbSTCP,
    wbSNTP,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbCOCT,
    wbCNTOs,
    wbDEST,
    wbDOFA,
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Allow Sounds When Animation',
        {0x02} 'Respawns',
        {0x04} 'Show Owner',
        {0x08} 'Unknown 4',
        {0x10} 'Unknown 5',
        {0x20} 'Unknown 6'
      ])),
      wbFloat('Weight')
    ], cpNormal, True),
    wbKeywords,
    wbFTYP,
    wbPRPS,
    wbNTRM,
    wbFormIDCk(SNAM, 'Sound - Open', [SNDR]),
    wbFormIDCk(QNAM, 'Sound - Close', [SNDR]),
    wbFormIDCk(TNAM, 'Sound - Take All', [SNDR]),
    wbFormIDCk(ONAM, 'Filter List', [FLST]),
    wbUnknown(CMIC)
  ], True, nil, cpNormal, False, nil, wbContainerAfterSet);

  wbAIDT :=
    wbStruct(AIDT, 'AI Data', [
     {00} wbInteger('Aggression', itU8, wbAggressionEnum),
     {01} wbInteger('Confidence', itU8, wbConfidenceEnum),
     {02} wbInteger('Energy Level', itU8),
     {03} wbInteger('Morality', itU8, wbEnum([
            'Any crime',
            'Violence against enemies',
            'Property crime only',
            'No crime'
          ])),
     {04} wbInteger('Mood', itU8, wbEnum([
            'Neutral',
            'Angry',
            'Fear',
            'Happy',
            'Sad',
            'Surprised',
            'Puzzled',
            'Disgusted'
          ])),
          wbInteger('Assistance', itU8, wbAssistanceEnum),
          wbStruct('Aggro', [
            wbInteger('Aggro Radius Behavior', itU8, wbBoolEnum),
            wbInteger('Unused', itU8),
            wbInteger('Warn', itU32),
            wbInteger('Warn/Attack', itU32),
            wbInteger('Attack', itU32)
          ]),
          wbFromVersion(29, wbInteger('No Slow Approach', itU32, wbBoolEnum))
    ], cpNormal, True, nil{wbActorTemplateUseAIData});

  wbRecord(CSTY, 'Combat Style',
    wbFlags(wbFlagsList([
      {0x00080000} 19, 'Allow Dual Wielding'
    ])), [
    wbEDID,
    wbStruct(CSGD, 'General', [
      wbFloat('Offensive Mult'),
      wbFloat('Defensive Mult'),
      wbFloat('Group Offensive Mult'),
      wbFloat('Equipment Score Mult - Melee'),
      wbFloat('Equipment Score Mult - Magic'),
      wbFloat('Equipment Score Mult - Ranged'),
      wbFloat('Equipment Score Mult - Shout'),
      wbFloat('Equipment Score Mult - Unarmed'),
      wbFloat('Equipment Score Mult - Staff'),
      wbFloat('Avoid Threat Chance'),
      wbFloat('Dodge Threat Chance'),
      wbFloat('Evade Threat Chance')
    ], cpNormal, True),
    wbUnknown(CSMD, cpIgnore),
    wbStruct(CSME, 'Melee', [
      wbFloat('Attack Staggered Mult'),
      wbFloat('Power Attack Staggered Mult'),
      wbFloat('Power Attack Blocking Mult'),
      wbFloat('Bash Mult'),
      wbFloat('Bash Recoiled Mult'),
      wbFloat('Bash Attack Mult'),
      wbFloat('Bash Power Attack Mult'),
      wbFloat('Special Attack Mult'),
      wbFloat('Block When Staggered Mult'),
      wbFloat('Attack When Staggered Mult')
    ], cpNormal, True, nil, 9),
    wbFloat(CSRA, 'Ranged Accuracy Mult', cpNormal, True),
    wbStruct(CSCR, 'Close Range', [
      wbFloat('Dueling - Circle Mult'),
      wbFloat('Dueling - Fallback Mult'),
      wbFloat('Flanking - Flank Distance'),
      wbFloat('Flanking - Stalk Time'),
      wbFloat('Charging - Charge Distance'),
      wbFloat('Charging - Throw Probability'),
      wbFloat('Charging - Sprint Fast Probability'),
      wbFloat('Charging - Sideswipe Probability'),
      wbFloat('Charging - Disengage Probability'),
      wbInteger('Charging - Throw Max Targets', itU32),
      wbFloat('Flanking - Flank Variance')
    ], cpNormal, True),
    wbStruct(CSLR, 'Long Range', [
      wbFloat('Strafe Mult'),
      wbFloat('Adjust Range Mult'),
      wbFloat('Crouch Mult'),
      wbFloat('Wait Mult'),
      wbFloat('Range Mult')
    ], cpNormal, True, nil, 3),
    wbFloat(CSCV, 'Cover Search Distance Mult', cpNormal, True),
    wbStruct(CSFL, 'Flight', [
      wbFloat('Hover Chance'),
      wbFloat('Dive Bomb Chance'),
      wbFloat('Ground Attack Chance'),
      wbFloat('Hover Time'),
      wbFloat('Ground Attack Time'),
      wbFloat('Perch Attack Chance'),
      wbFloat('Perch Attack Time'),
      wbFloat('Flying Attack Chance'),
      wbFloat('Unknown 1'),
      wbInteger('Flying Strafe Attack Altitude Min', itU32),
      wbInteger('Flying Strafe Attack Altitude Max', itU32)
    ], cpNormal, True, nil, 7),
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      {0x01} 'Dueling',
      {0x02} 'Flanking',
      {0x04} 'Allow Dual Wielding',
      {0x08} 'Charging',
      {0x10} 'Retarget Any Nearby Melee Target',
      {0x20} 'Unknown 5',   //006A063C
      {0x40} 'Unknown 6'    //006FB700
    ]), cpNormal, True),
    wbStruct(CSTG, '', [
      wbFloat,
      wbFloat,
      wbFloat
    ])
  ]);

  wbRecord(DIAL, 'Dialog Topic',
    wbFlags(wbFlagsList([
      {0x00004000} 14, 'Partial Form'
    ]), [14]), [
    wbEDID,
    wbFULL,
    wbFloat(PNAM, 'Priority', cpNormal, True, 1, -1, nil, nil, 50.0),
    wbFormIDCkNoReach(BNAM, 'Branch', [DLBR]),
    wbFormIDCkNoReach(QNAM, 'Quest', [QUST], False, cpNormal, False),
    wbFormIDCk(KNAM, 'Keyword', [KYWD]),
    wbStruct(DATA, 'Data', [
      // this should not be named Flags since TwbFile.BuildReachable
      // expects Top-Level flag here from FNV
      wbInteger('Topic Flags', itU8, wbFlags([
        'Do All Before Repeating',
        'Unknown 1',
        'Unknown 2'
      ]), cpNormal, True),
      wbInteger('Category', itU8, wbEnum([
        {0} 'Player',
        {1} 'Command',
        {2} 'Scene',
        {3} 'Combat',
        {4} 'Detection',
        {5} 'Miscellaneous',
        {6} 'Unknown 6',
        {7} 'Unknown 7'
      ])),
      wbInteger('Subtype', itU16, wbEnum([
        { 0} 'Custom',
        { 1} 'Force Greet',
        { 2} 'Rumors',
        { 3} 'Custom',
        { 4} 'Call',
        { 5} 'Follow',
        { 6} 'Move',
        { 7} 'Attack',
        { 8} 'Inspect',
        { 9} 'Retrieve',
        {10} 'Stay',
        {11} 'Release',
        {12} 'Show Relationships',
        {13} 'Reject',
        {14} 'Heal',
        {15} 'Assign',
        {16} 'Enter',
        {17} 'Custom',
        {18} 'Show',
        {19} 'Agree',
        {20} 'Refuse',
        {21} 'Exit Favor State',
        {22} 'Moral Refusal',
        {23} 'Trade',
        {24} 'Pathing Refusal',
        {25} 'Attack',
        {26} 'Power Attack',
        {27} 'Bash',
        {28} 'Hit',
        {29} 'Flee',
        {30} 'Bleed Out',
        {31} 'Avoid Threat',
        {32} 'Death',
        {33} 'Block',
        {34} 'Taunt',
        {35} 'Throw Grenade',
        {36} 'Ally Killed',
        {37} 'Order Fallback',
        {38} 'Order Move Up',
        {39} 'Order Flank',
        {40} 'Order Take Cover',
        {41} 'Retreat',
        {42} 'Cover Me',
        {43} 'Suppressive Fire',
        {44} 'Crippled Limb',
        {45} 'Paired Attack',
        {46} 'Steal',
        {47} 'Yield',
        {48} 'Accept Yield',
        {49} 'Pickpocket Combat',
        {50} 'Assault',
        {51} 'Murder',
        {52} 'Assault NC',
        {53} 'Murder NC',
        {54} 'Pickpocket NC',
        {55} 'Steal From NC',
        {56} 'Trespass Against NC',
        {57} 'Trespass',
        {58} 'UNUSED01',
        {59} 'Voice Power Start Short',
        {60} 'Voice Power Start Long',
        {61} 'Voice Power End Short',
        {62} 'Voice Power End Long',
        {63} 'Alert Idle',
        {64} 'Lost Idle',
        {65} 'Normal To Alert',
        {66} 'Normal To Combat',
        {67} 'Normal To Lost',
        {68} 'Alert To Normal',
        {69} 'Alert To Combat',
        {70} 'Combat To Normal',
        {71} 'Combat To Lost',
        {72} 'Lost To Normal',
        {73} 'Lost To Combat',
        {74} 'Detect Friend Die',
        {75} 'Service Refusal',
        {76} 'Repair',
        {77} 'Travel',
        {78} 'Training',
        {79} 'Barter Exit',
        {80} 'Repair Exit',
        {81} 'Recharge',
        {82} 'Recharge Exit',
        {83} 'Training Exit',
        {84} 'Observe Combat',
        {85} 'Notice Corpse',
        {86} 'Time To Go',
        {87} 'Goodbye',
        {88} 'Hello',
        {89} 'Swing Melee Weapon',
        {90} 'Shoot Bow',
        {91} 'Z Key Object',
        {92} 'Jump',
        {93} 'Knock Over Object',
        {94} 'Destroy Object',
        {95} 'Standon Furniture',
        {96} 'Locked Object',
        {97} 'Pickpocket Topic',
        {98} 'Pursue Idle Topic',
        {99} 'Shared Info',
       {100} 'Scene Choice',
       {101} 'Player Cast Projectile Spell',
       {102} 'Player Cast Self Spell',
       {103} 'Player Shout',
       {104} 'Idle',
       {105} 'Enter Sprint Breath',
       {106} 'Enter Bow Zoom Breath',
       {107} 'Exit Bow Zoom Breath',
       {108} 'Actor Collidewith Actor',
       {109} 'Playerin Iron Sights',
       {110} 'Outof Breath',
       {111} 'Combat Grunt',
       {112} 'Leave Water Breath',
       {113} 'Impatient Positive',
       {114} 'Impatient Negative',
       {115} 'Impatient Neutral',
       {116} 'Impatient Question',
       {117} 'Waiting For Player Input',
       {118} 'Greeting',
       {119} 'Player Activate Door',
       {120} 'Player Activate Terminals',
       {121} 'Player Activate Furniture',
       {122} 'Player Activate Activators',
       {123} 'Player Activate Container',
       {124} 'Player Aquire Featured Item'
      ]))
    ]),
    wbInteger(SNAM, 'Subtype Name', itU32, wbDialogueSubtypeEnum),
    wbInteger(TIFC, 'Info Count', itU32, nil, cpIgnore),
    wbINOM,
    wbINOA
  ]);

  wbRecord(DOOR, 'Door',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000010}  4, 'Non Occluder',
      {0x00000200}  9, 'Unknown 9',
      {0x00008000} 15, 'Has Distant LOD',
      {0x00010000} 16, 'Random Anim Start',
      {0x00800000} 23, 'Is Marker'
    ])), [
    wbEDID,
    wbDURL,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbDEFL,
    wbSNTP,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbNTRM,
    wbAPPR,
    wbFormIDCk(SNAM, 'Sound - Open', [SNDR]),
    wbFormIDCk(ANAM, 'Sound - Close', [SNDR]),
    wbFormIDCk(BNAM, 'Sound - Loop', [SNDR]),
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      '',
      'Automatic',
      'Hidden',
      'Minimal Use',
      'Sliding',
      'Do Not Open in Combat Search',
      'No "To" Text'
    ]), cpNormal, True),
    wbLStringKC(ONAM, 'Alternate Text - Open', 0, cpTranslate),
    wbLStringKC(CNAM, 'Alternate Text - Close', 0, cpTranslate),
    wbUnknown(PAHD),
    wbRArrayS('Random teleport destinations', wbFormIDCk(TNAM, 'Destination', [CELL, WRLD]))
  ]);

  wbRecord(EFSH, 'Effect Shader', [
    wbEDID,
    wbString(ICON, 'Fill Texture'),
    wbString(ICO2, 'Particle Shader Texture'),
    wbString(NAM7, 'Holes Texture'),
    wbString(NAM8, 'Membrane Palette Texture'),
    wbString(NAM9, 'Particle Palette Texture'),
    wbUnknown(DATA),  // if form version < 62, ignored otherwise
    // format depends on Form Version (appear with form version 62, changed in form version 106), different for older records starting from the first field
    wbStruct(DNAM, 'Data', [
      wbBelowVersion(107, wbByteArray('Unused', 1)),
      wbInteger('Membrane Shader - Source Blend Mode', itU32, wbBlendModeEnum),
      wbInteger('Membrane Shader - Blend Operation', itU32, wbBlendOpEnum),
      wbInteger('Membrane Shader - Z Test Function', itU32, wbZTestFuncEnum),
      wbByteColors('Fill/Texture Effect - Color Key 1'),
      wbFloat('Fill/Texture Effect - Alpha Fade In Time'),
      wbFloat('Fill/Texture Effect - Full Alpha Time'),
      wbFloat('Fill/Texture Effect - Alpha Fade Out Time'),
      wbFloat('Fill/Texture Effect - Presistent Alpha Ratio'),
      wbFloat('Fill/Texture Effect - Alpha Pulse Amplitude'),
      wbFloat('Fill/Texture Effect - Alpha Pulse Frequency'),
      wbFloat('Fill/Texture Effect - Texture Animation Speed (U)'),
      wbFloat('Fill/Texture Effect - Texture Animation Speed (V)'),
      wbFloat('Edge Effect - Fall Off'),
      wbByteColors('Edge Effect - Color'),
      wbFloat('Edge Effect - Alpha Fade In Time'),
      wbFloat('Edge Effect - Full Alpha Time'),
      wbFloat('Edge Effect - Alpha Fade Out Time'),
      wbFloat('Edge Effect - Persistent Alpha Ratio'),
      wbFloat('Edge Effect - Alpha Pulse Amplitude'),
      wbFloat('Edge Effect - Alpha Pulse Frequency'),
      wbFloat('Fill/Texture Effect - Full Alpha Ratio'),
      wbFloat('Edge Effect - Full Alpha Ratio'),
      wbInteger('Membrane Shader - Dest Blend Mode', itU32, wbBlendModeEnum),
      wbBelowVersion(107, wbByteArray('Unused', 152)),
      wbFloat('Holes Animation - Start Time'),
      wbFloat('Holes Animation - End Time'),
      wbFloat('Holes Animation - Start Value'),
      wbFloat('Holes Animation - End Value'),
      wbBelowVersion(107, wbByteArray('Unused', 44)),
      wbFormIDCk('Ambient Sound', [SNDR, NULL]),
      wbByteColors('Fill/Texture Effect - Color Key 2'),
      wbByteColors('Fill/Texture Effect - Color Key 3'),
      wbFromVersion(106, wbInteger('Bone Depth', itU8)),
      wbStruct('Fill/Texture Effect - Color Key Scale/Time', [
        wbFloat('Color Key 1 - Scale'),
        wbFloat('Color Key 2 - Scale'),
        wbFloat('Color Key 3 - Scale'),
        wbFloat('Color Key 1 - Time'),
        wbFloat('Color Key 2 - Time'),
        wbFloat('Color Key 3 - Time')
      ]),
      wbBelowVersion(107, wbByteArray('Unused', 40)),
      wbInteger('Flags', itU32, wbFlags([
        'No Membrane Shader',
        'Membrane Grayscale Color',
        'Membrane Grayscale Alpha',
        'No Particle Shader',
        'Edge Effect - Inverse',
        'Affect Skin Only',
        'Texture Effect - Ignore Alpha',
        'Texture Effect - Project UVs',
        'Ignore Base Geometry Alpha',
        'Texture Effect - Lighting',
        'Texture Effect - No Weapons',
        'Use Alpha Sorting',
        'Prefer Dismembered Limbs',
        'Unknown 13',
        'Unknown 14',
        'Particle Animated',
        'Particle Grayscale Color',
        'Particle Grayscale Alpha',
        'Unknown 18',
        'Unknown 19',
        'Unknown 20',
        'Unknown 21',
        'Unknown 22',
        'Unknown 23',
        'Use Blood Geometry (Weapons Only)'
      ])),
      wbFloat('Fill/Texture Effect - Texture Scale (U)'),
      wbFloat('Fill/Texture Effect - Texture Scale (V)'),
      wbBelowVersion(107, wbByteArray('Unused', 2)),
      wbFromVersion(196, wbUnknown())
    ], cpNormal, True),
    wbGenericModel
  ]);

  wbRecord(ENCH, 'Object Effect', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbFULL,
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Enchantment Cost', itS32),
      wbInteger('Flags', itU32, wbFlags([
        'No Auto-Calc',
        '',
        'Extend Duration On Recast'
      ])),
      wbInteger('Cast Type', itU32, wbCastEnum),
      wbInteger('Enchantment Amount', itS32),
      wbInteger('Target Type', itU32, wbTargetEnum),
      wbInteger('Enchant Type', itU32, wbEnum([], [
        $06, 'Enchantment',
        $0C, 'Staff Enchantment'
      ])),
      wbFloat('Charge Time'),
      wbFormIDCk('Base Enchantment', [ENCH, NULL]),
      wbFormIDCk('Worn Restrictions', [FLST, NULL])
    ], cpNormal, True, nil, 8),
    wbEffectsReq,
    wbMIID
  ]);

  wbRecord(EYES, 'Eyes',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbFULLReq,
    wbString(ICON, 'Texture', 0, cpNormal, True),
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      {0x01}'Playable',
      {0x02}'Not Male',
      {0x04}'Not Female',
      {0x08}'Unknown 4',
      {0x10}'Unknown 5',
      {0x20}'Unknown 6',
      {0x40}'Unknown 7',
      {0x80}'Unknown 8'
    ]), cpNormal, True)
  ]);

  var wbFactionRank :=
    wbRStructSK([0], 'Rank', [
      wbInteger(RNAM, 'Rank#', itU32),
      wbLString(MNAM, 'Male Title', 0, cpTranslate),
      wbLString(FNAM, 'Female Title', 0, cpTranslate),
      wbString(INAM, 'Insignia (unused)')
    ], []);

  wbRecord(FACT, 'Faction', [
    wbEDID,
    wbFULL,
    wbFactionRelations,
    wbStruct(DATA, 'Flags', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Hidden From NPC',
        {0x00000002} 'Special Combat',
        {0x00000004} 'Unknown 3',
        {0x00000008} 'Unknown 4',
        {0x00000010} 'Unknown 5',
        {0x00000020} 'Unknown 6',
        {0x00000040} 'Track Crime',
        {0x00000080} 'Ignore Crimes: Murder',
        {0x00000100} 'Ignore Crimes: Assault',
        {0x00000200} 'Ignore Crimes: Stealing',
        {0x00000400} 'Ignore Crimes: Trespass',
        {0x00000800} 'Do Not Report Crimes Against Members',
        {0x00001000} 'Crime Gold - Use Defaults',
        {0x00002000} 'Ignore Crimes: Pickpocket',
        {0x00004000} 'Vendor',
        {0x00008000} 'Can Be Owner',
        {0x00010000} 'Ignore Crimes: Werewolf (unused)'
      ]))
    ], cpNormal, True, nil, 1),
    wbFormIDCk(JAIL, 'Exterior Jail Marker', [REFR]),
    wbFormIDCk(WAIT, 'Follower Wait Marker', [REFR]),
    wbFormIDCk(STOL, 'Stolen Goods Container', [REFR]),
    wbFormIDCk(PLCN, 'Player Inventory Container', [REFR]),
    wbFormIDCk(CRGR, 'Shared Crime Faction List', [FLST]),
    wbFormIDCk(JOUT, 'Jail Outfit', [OTFT]),
    wbFormIDCk(QSTI, 'Quest', [QUST]),
    wbStruct(CRVA, 'Crime Values', [
      wbInteger('Arrest', itU8, wbBoolEnum),
      wbInteger('Attack On Sight', itU8, wbBoolEnum),
      wbInteger('Murder', itU16),
      wbInteger('Assault', itU16),
      wbInteger('Trespass', itU16),
      wbInteger('Pickpocket', itU16),
      wbInteger('Unknown', itU16),
      wbFloat('Steal Multiplier'),
      wbInteger('Escape', itU16),
      wbInteger('Werewolf (unused)', itU16)
    ], cpNormal, False, nil, 7),
    wbRArrayS('Ranks', wbFactionRank),
    wbFormIDCk(VEND, 'Vendor Buy/Sell List', [FLST]),
    wbFormIDCk(VENC, 'Merchant Container', [REFR]),
    wbFormIDCk(VENR, 'Vendor Reset', [GLOB]),
    wbFormIDCk(VENG, 'Vendor Caps Balance', [AVIF]),
    wbFormIDCk(VBCY, 'Vendor Buy Currency', [NULL, CNCY]),
    wbEmpty(VREN, 'Unknown'),
    wbStruct(VENP, 'Vendor Values', [
      wbInteger('Start Hour', itU16),
      wbInteger('End Hour', itU16),
      wbInteger('Radius', itU32),
      wbInteger('Buys Stolen Items', itU8, wbBoolEnum),
      wbInteger('Buy/Sell Everything Not In List?', itU8, wbBoolEnum),
      wbInteger('Buys NonStolen Items', itU8, wbBoolEnum),
      wbUnknown
    ]),
    wbStruct(VENV, 'Vendor Values', [
      wbInteger('Start Hour', itU16),
      wbInteger('End Hour', itU16),
      wbInteger('Radius', itU32),
      wbInteger('Buys Stolen Items', itU8, wbBoolEnum),
      wbInteger('Buy/Sell Everything Not In List?', itU8, wbBoolEnum),
      wbInteger('Buys NonStolen Items', itU8, wbBoolEnum),
      wbUnknown
    ]),
    wbPLVD,
    wbCITC,
    wbCTDAsCount
  ], False, nil, cpNormal, False, nil {wbFACTAfterLoad}, wbConditionsAfterSet);

  wbRecord(FURN, 'Furniture',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Has Container',
      {0x00000010}  4, 'Unknown 4',
      {0x00000080}  7, 'Is Perch',
      {0x00000200}  9, 'Unknown 9',
      {0x00000400} 10, 'Unknown 10',
      {0x00002000} 13, 'Unknown 13',
      {0x00008000} 15, 'Has Distant LOD',
      {0x00010000} 16, 'Random Anim Start',
      {0x00800000} 23, 'Is Marker',
      {0x02000000} 25, 'Power Armor',
      {0x08000000} 27, 'Unknown 27',
      {0x10000000} 28, 'Must Exit To Talk',
      {0x20000000} 29, 'Child Can Use'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbSTCP,
    wbOPDSs,
    wbPTRN,
    wbDEFL,
    wbSNTP,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbRArray('Factions', wbDOFA, cpNormal),
    wbKeywords,
    wbPRPS,
    wbNTRM,
    wbFTYP,
    wbNAM1LODP,
    wbByteRGBA(PNAM, 'Marker Color'),
    wbFormIDCk(WNAM, 'Water Type', [WATR]),
    wbQSTI,
    wbUnknown(AIID),
    wbATTX,
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      'No Displacement',
      'Ignored by Sandbox',
      'Unknown 2', {Only used on DefaultProceduralWater [ACTI:00000019]}
      'Unknown 3', {Currently Unused}
      'Is a Radio',
      'Is a Lookat Trigger',
      'Unknown 6' {Currently Unused}
    ])),
    wbCNDCs,
    wbStruct(RADR, 'Radio Receiver', [
      wbFormIDCk('Sound Model', [SOPM, NULL]),
      wbFloat('Frequency'),
      wbFloat('Volume'),
      wbInteger('Starts Active', itU8, wbBoolEnum),
      wbInteger('No Signal Static', itU8, wbBoolEnum)
    ], cpNormal, False, nil, 4),
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN,
    wbCOCT,
    wbCNTOs,
    wbInteger(LAVT, 'Lookat Value', itU32),
    wbInteger(LAMN, 'Lookat Minimum', itU32),
    wbInteger(LAMX, 'Lookat Maximum', itU32),
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN, //Temporary fix. Figure out how to do this in a way that isn't just duplication
    wbMNAMFurnitureMarker,
    wbStruct(WBDT, 'Workbench Data', [
      wbInteger('Bench Type', itU8, wbEnum([
        {0} 'None',
        {1} 'Create Object', // used only for MS11Workbench [FURN:00091FD5]
        {2} 'Weapons', // used for the Weapons (plural) workbench
        {3} 'Enchanting (unused)', // not used
        {4} 'Enchanting Experiment (unused)', // not used
        {5} 'Alchemy', // used for Chemistry and Cooking, so Alchemy is probably okay
        {6} 'Alchemy Experiment (unused)', // not used
        {7} 'Armor', // FO4 calls this the Armor workbench, no mention of Smithing
        {8} 'Power Armor', // used for Power Armor stations
        {9} 'Robot Mod' // used for Robot stations
      ])),
      wbInteger('Uses Skill', itS8, wbBoolEnum)
    ], cpNormal, True, nil, 1),
    wbFormIDCk(NAM1, 'Associated Form', [ARMO, WEAP, PERK, SPEL, HAZD]),
    wbRArray('Markers', wbRStruct('Marker', [
      wbInteger(ENAM, 'Marker Index', itS32),
      wbStruct(NAM0, 'Disabled Entry Points', [
        wbByteArray('Unknown', 2),
        wbInteger('Disabled Points', itU16, wbFurnitureEntryTypeFlags)
      ])
      //wbFormIDCk(FNMK, 'Marker Keyword', [KYWD, NULL])
    ], [])),
    wbRArray('Marker Entry Points', wbStruct(FNPR, 'Marker', [
      wbInteger('Type', itU16, wbFurnitureAnimTypeEnum),
      wbInteger('Entry Points', itU16, wbFurnitureEntryTypeFlags)
    ])),
    wbStruct(FNMU, 'Music Instrument', [
      wbFormIDCk('Intro', [SNDR, NULL]),
      wbFormIDCk('Rhythm', [SNDR]),
      wbFormIDCk('Lead', [SNDR]),
      wbFormIDCk('Outro', [SNDR, NULL])
    ]),
    wbString(XMRK, 'Marker Model'),
    wbSNAMMarkerParams,
    wbZNAMMarkerParams,
    wbRStruct('Keypad Data', [
      wbFloat(CNAM, 'Default Code'),
      wbInteger(LNAM, 'Default Code Length', itU8)
    ], []),
    wbAPPR,
    wbObjectTemplate,
    wbUnknown(FFEF),
    wbUnknown(NVNM)
  ]);

  wbRecord(GLOB, 'Global',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000040}  6, 'Constant',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbFTAGs,
    wbXALG,
    wbInteger(FNAM, 'Type', itU8, wbEnum([], [
      Ord('s'), 'Short',
      Ord('l'), 'Long',
      Ord('f'), 'Float',
      Ord('b'), 'Boolean'
    ]){, cpNormal, True}).SetDefaultEditValue('Float'),
    wbFloat(FLTV, 'Value', cpNormal, True),
    wbNTWK
  ]);

  wbRecord(GMST, 'Game Setting', [
    wbString(EDID, 'Editor ID', 0, cpCritical, True, nil, wbGMSTEDIDAfterSet),
    wbUnion(DATA, 'Value', wbGMSTUnionDecider, [
      wbLString('Name', 0, cpTranslate),
      wbInteger('Int', itS32),
      wbFloat('Float'),
      wbInteger('Bool', itU32, wbBoolEnum),
      wbInteger('UInt', itU32)
    ], cpNormal, True)
  ])
  .IncludeFlag(dfIndexEditorID);

  wbRecord(KYWD, 'Keyword',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000010}  4, 'Unknown 4',
      {0x00000200}  9, 'Unknown 9',
      {0x00000800} 11, 'Unknown 11', //AnimFaceArchetype*
      {0x00080000} 15, 'Restricted'
    ])), [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbCNAM,
    wbString(DNAM, 'Notes'),
    wbUnknown(FNAM),
    wbInteger(TNAM, 'Type', itU32, wbKeywordTypeEnum),
    wbString(ENAM, 'Icon Name'),
    wbFormIDCk(DATA, 'Attraction Rule', [AORU]),
    wbNTWK,
    wbFULL,
    wbString(NNAM, 'Display Name') {Legacy record replaced with FULL}
  ]);

  wbRecord(LCRT, 'Location Reference Type',
    wbFlags(wbFlagsList([
      {0x00000010} { 4}  4, 'Unknown 4'
    ])), [
    wbEDID,
    wbCNAM,
    wbUnknown(FNAM),
    wbUnknown(TNAM),
    wbGenericModel,
    wbUnknown(FNAM)
  ]);

  wbRecord(AACT, 'Action',
    wbFlags(wbFlagsList([
      {0x00080000} {15} 15, 'Restricted'
    ])), [
    wbEDID,
    wbCNAM,
    wbString(DNAM, 'Notes'),
    wbByteArray(FNAM, 'Unknown FNAM', 4),
    wbInteger(TNAM, 'Type', itU32, wbKeywordTypeEnum),
    wbFormIDCk(DATA, 'Attraction Rule', [AORU]),
    wbFULL
  ]);

  wbRecord(TXST, 'Texture Set', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbFLTR,
    wbRStruct('Textures (RGB/A)', [
      wbString(TX00, 'Diffuse'),
      wbString(TX01, 'Normal/Gloss'),
      wbString(TX03, 'Glow'),
      wbString(TX04, 'Height'),
      wbString(TX05, 'Environment'),
      wbString(TX02, 'Wrinkles'), {TX05 TX02 TX06 Yes this has to go here}
      wbString(TX06, 'Multilayer'),
      wbString(TX07, 'Smooth Spec'),
      wbString(TX08, 'Specular'),
      wbString(TX09, 'Lighting'),
      wbString(TX10, 'Flow')
    ], []),
    wbDODT,
    wbInteger(DNAM, 'Flags', itU16, wbFlags([
      {0x0001} 'No Specular Map',
      {0x0002} 'Facegen Textures',
      {0x0004} 'Has Model Space Normal Map',
      {0x0008} 'Unknown 3'
    ]), cpNormal, True),
    wbString(MNAM, 'Material')
  ]);

  wbRecord(HDPT, 'Head Part',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      {0x01} 'Playable',
      {0x02} 'Male',
      {0x04} 'Female',
      {0x10} 'Is Extra Part',
      {0x20} 'Use Solid Tint',
      {0x40} 'Uses Body Texture'
    ]), cpNormal, True),
    wbInteger(PNAM, 'Type', itU32, wbEnum([
      'Misc',
      'Face',
      'Eyes',
      'Hair',
      'Facial Hair',
      'Scar',
      'Eyebrows',
      'Meatcaps',
      'Teeth',
      'Head Rear'
    ])),
    wbRArrayS('Extra Parts',
      wbFormIDCk(HNAM, 'Part', [HDPT])
    ),
    wbRArray('Parts', wbRStruct('Part', [
      wbInteger(NAM0, 'Part Type', itU32, wbEnum([
        'Race Morph',
        'Tri',
        'Chargen Morph'
      ])),
      wbString(NAM1, 'FileName', 0, cpTranslate, True)
    ], [])),
    wbFormIDCk(TNAM, 'Texture Set', [TXST]),
    wbFormIDCk(CNAM, 'Color', [CLFM]),
    wbFormIDCk(RNAM, 'Valid Races', [FLST]),
    wbCTDAs
  ]);

  wbRecord(ASPC, 'Acoustic Space', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbDEFL,
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR]),
    wbFormIDCk(RDAT, 'Use Sound from Region (Interiors Only)', [REGN]),
    wbFormIDCk(BNAM, 'Environment Type', [REVB]),
    wbInteger(XTRI, 'Is Interior', itU8, wbBoolEnum),
    wbUnknown(FNAM),
    wbInteger(WNAM, 'Weather Attenuation (dB)', itU16, wbDiv(100)),
    wbBEVA,
    wbFEVA
  ]);

  wbRecord(MSTT, 'Moveable Static',
    wbFlags(wbFlagsList([
       8, 'Must Update Anims',
       9, 'Hidden From Local Map',
      11, 'Used As Platform',
      13, 'Pack-In Use Only',
      15, 'Has Distant LOD',
      16, 'Random Anim Start',
      19, 'Has Currents',
      25, 'Obstacle',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbPHST,
    wbSTCP,
    wbDEFL,
    wbSNTP,
    wbOPDSs,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbDOFA,
    wbKeywords,
    wbPRPS,
    wbAPPR,
    wbInteger(DATA, 'On Local Map', itU8, wbBoolEnum, cpNormal, True),
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR])
  ]);

  wbRecord(IDLM, 'Idle Marker',
    wbFlags(wbFlagsList([
      {0x20000000} 29, 'Child Can Use'
    ])), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbDEFL,
    wbKeywords,
    wbInteger(IDLF, 'Flags', itU8, wbFlags([
      'Run in Sequence',
      'Old Pick Conditions',
      'Do Once',
      'Loose Only',
      'Ignored by Sandbox',
      'Unknown 5'
    ]), cpNormal, False),
    wbInteger(IDLC, 'Animation Count', itU8, nil, cpBenign),
    wbFloat(IDLT, 'Idle Timer Setting', cpNormal, False),
    wbArray(IDLA, 'Animations', wbFormIDCk('Animation', [IDLE]), 0, nil, wbIDLAsAfterSet, cpNormal, False),
    wbFormIDCk(QNAM, 'Animation Flavor Keyword', [KYWD]),
    wbGenericModel
  ], False, nil, cpNormal, False, nil, wbAnimationsAfterSet);

  wbRecord(PROJ, 'Projectile', [
    wbEDID,
    wbOBND(True),
    wbPHST,
    wbKeywords,
    wbOPDSs,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbByteArray(DATA, 'Unused', 0, cpIgnore),
    wbStruct(DNAM, 'Data', [
      wbInteger('Flags', itU16, wbFlags([
        {0x00001} 'Hitscan',
        {0x00002} 'Explosion',
        {0x00004} 'Alt. Trigger',
        {0x00008} 'Muzzle Flash',
        {0x00010} 'Unknown 4',
        {0x00020} 'Can Be Disabled',
        {0x00040} 'Can Be Picked Up',
        {0x00080} 'Supersonic',
        {0x00100} 'Pins Limbs',
        {0x00200} 'Pass Through Small Transparent',
        {0x00400} 'Disable Combat Aim Correction',
        {0x00800} 'Penetrates Geometry',
        {0x01000} 'Continuous Update',
        {0x02000} 'Seeks Target',
        {0x04000} 'Unknown 14',
        {0x08000} 'Unknown 15'
      ])),
      wbInteger('Type', itU16, wbEnum([], [
        $01, 'Missile',
        $02, 'Lobber',
        $04, 'Beam',
        $08, 'Flame',
        $10, 'Cone',
        $20, 'Barrier',
        $40, 'Arrow'
      ])),
      wbFloat('Gravity'),
      wbFloat('Speed'),
      wbFloat('Range'),
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFormIDCk('Muzzle Flash - Light', [LIGH, NULL]),
      wbFloat('Explosion - Alt. Trigger - Proximity'),
      wbFloat('Explosion - Alt. Trigger - Timer'),
      wbFormIDCk('Explosion', [EXPL, NULL]),
      wbFormIDCk('Sound', [SNDR, NULL]),
      wbFloat('Muzzle Flash - Duration'),
      wbFloat('Fade Duration'),
      wbFloat('Impact Force'),
      wbFormIDCk('Sound - Countdown', [SNDR, NULL]),
      wbFormIDCk('Sound - Disable', [SNDR, NULL]),
      wbFormIDCk('Default Weapon Source', [WEAP, NULL]),
      wbFloat('Cone Spread'),
      wbFloat('Collision Radius'),
      wbFloat('Lifetime'),
      wbFloat('Relaunch Interval'),
      wbFormIDCk('Decal Data', [TXST, NULL]),
      wbFormIDCk('Collision Layer', [COLL, NULL]),
      wbInteger('Tracer Frequency', itU8),
      wbFormIDCk('VATS Projectile', [PROJ, NULL])
    ]),
    wbRStructSK([0], 'Muzzle Flash Model', [
      wbString(NAM1, 'Model FileName'),
      wbModelInfo(NAM2)
    ], [], cpNormal, True),
    wbInteger(VNAM, 'Sound Level', itU32, wbSoundLevelEnum, cpNormal, True),
    wbFormIDCk(PSCT, 'Speed Curve Table', [CURV, NULL]),
    wbFormIDCk(PSSC, 'Seek Strength Curve Table', [CURV, NULL]),
    wbFloat(PFDX, 'X-Axis Drag'),
    wbFloat(PFDZ, 'Z-Axis Drag')
  ]);

  wbRecord(HAZD, 'Hazard', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbDEFL,
    wbFULL,
    wbGenericModel,
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD, NULL]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Limit', itU32),
      wbFloat('Radius'),
      wbFloat('Lifetime'),
      wbFloat('Image Space Radius'),
      wbFloat('Target Interval'),
      wbInteger('Flags', itU32, wbFlags([
        {0x01} 'Affects Player Only',
        {0x02} 'Inherit Duration from Spawn Spell',
        {0x04} 'Align to Impact Normal',
        {0x08} 'Inherit Radius from Spawn Spell',
        {0x10} 'Drop to Ground',
        {0x20} 'Taper Effectiveness by Proximity',
        {0x40} 'Unknown 6'
      ])),
      wbFormIDCk('Effect', [SPEL, ENCH, NULL]),
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFormIDCk('Impact Data Set', [IPDS, NULL]),
      wbFormIDCk('Sound', [SNDR, NULL]),
      wbStruct('Taper Effectiveness', [
        wbFloat('Full Effect Radius'),
        wbFloat('Taper Weight'),
        wbFloat('Taper Curse')
      ])
    ])
  ]);

  wbRecord(NAVM, 'Navmesh',
    wbFlags(wbFlagsList([
      11, 'Initially Disabled',
      18, 'Compressed',
      26, 'AutoGen',
      31, 'Navmesh Gen Cell'
    ]), [18]), [
    wbEDID,
    wbNVNM,
    wbArray(ONAM,'Base Objects',
      wbFormID('Base Object')),
    wbArray(PNAM, 'Preferred Connectors',
      wbInteger('Vertex', itU16)),
    wbArray(NNAM, 'Non Connectors',
      wbInteger('Vertex', itU16)),
    IfThen(wbSimpleRecords,
      wbByteArray(MNAM, 'PreCut Map Entries'),
      wbArrayS(MNAM, 'PreCut Map Entries',
        wbStructSK([0], 'PreCut Map Entry', [
          wbFormID('Reference'),
          wbArrayS('Triangles',
            wbInteger('Triangle', itU16).SetLinksToCallback(wbTriangleLinksTo),
          -2).IncludeFlag(dfCollapsed)
        ]).IncludeFlag(dfCollapsed)
      ).IncludeFlag(dfCollapsed)
    )
  ], False, wbNAVMAddInfo);

  wbRecord(NAVI, 'Navmesh Info Map', [
    wbEDID,
    wbInteger(NVER, 'Version', itU32),
    wbRArrayS('Navmesh Infos',
      wbStructSK(NVMI, [0], 'Navmesh Info', [
        wbFormIDCk('Navmesh', [NAVM])
          .IncludeFlag(dfSummaryNoName),
        wbInteger('Category', itU32,
          wbEnum([], [
            0, 'Is Edited',
           32, 'Is Island',
           64, 'Not Edited'
          ])
        ),
        wbArray('Unknown', wbFloat, 4),
        wbArrayS('Edge Links',
          wbFormIDCk('Navmesh', [NAVM]),
        -1).IncludeFlag(dfCollapsed),
        wbArrayS('Preferred Edge Links',
          wbFormIDCk('Navmesh', [NAVM]),
        -1).IncludeFlag(dfCollapsed),
        wbArrayS('Door Links',
          wbStructSK([1], 'Door Link', [
            wbInteger('CRC Hash', itU32, wbCRCValuesEnum)
              .SetDefaultEditValue('PathingDoor'),
            wbFormIDCk('Door Ref', [REFR])
          ]).SetSummaryKey([1])
            .IncludeFlag(dfCollapsed)
            .IncludeFlag(dfSummaryMembersNoName),
        -1).IncludeFlag(dfCollapsed),
        wbStruct('Optional Island Data', [
          wbInteger('Has Island Data', itU8, wbBoolEnum)
            .SetAfterSet(wbUpdateSameParentUnions),
          wbUnion('Island Data', wbNAVIIslandDataDecider, [
            wbEmpty('Island Data'),
            wbStruct('Island Data', [
              wbVec3('Min'),
              wbVec3('Max'),
              wbArray('Triangles',
                wbStruct('Triangle', [
                  wbInteger('Vertex 0', itU16),
                  wbInteger('Vertex 1', itU16),
                  wbInteger('Vertex 2', itU16)
                ]).IncludeFlag(dfCollapsed),
              -1).IncludeFlag(dfCollapsed),
              wbArray('Vertices',
                wbVec3('Vertex'),
              -1).IncludeFlag(dfCollapsed)
            ]).SetSummaryKey([2])
              .IncludeFlag(dfCollapsed)
              .IncludeFlag(dfSummaryMembersNoName)
          ]).IncludeFlag(dfCollapsed)
        ]).SetSummaryKey([1])
          .IncludeFlag(dfCollapsed)
          .IncludeFlag(dfSummaryMembersNoName),
        wbStruct('Pathing Cell', [
          wbInteger('CRC Hash', itU32, wbCRCValuesEnum)
            .SetDefaultEditValue('PathingCell'),
          wbFormIDCk('Parent World', [WRLD, NULL])
            .IncludeFlag(dfSummaryExcludeNull),
          wbUnion('', wbNAVIParentDecider, [
            wbStruct('Coordinates', [
              wbInteger('Grid Y', itS16),
              wbInteger('Grid X', itS16)
            ]).SetSummaryKey([0, 1])
              .SetSummaryMemberPrefixSuffix(0, '<X: ', '')
              .SetSummaryMemberPrefixSuffix(1, 'Y: ', '>')
              .SetSummaryDelimiter(', ')
              .IncludeFlag(dfCollapsed)
              .IncludeFlag(dfSummaryMembersNoName),
            wbFormIDCk('Parent Cell', [CELL])
          ]).IncludeFlag(dfCollapsed)
        ]).SetSummaryKey([1, 2])
          .IncludeFlag(dfCollapsed)
          .IncludeFlag(dfSummaryMembersNoName)
      ]).SetSummaryKeyOnValue([0, 7, 6])
        .SetSummaryPrefixSuffixOnValue(0, '', '')
        .SetSummaryPrefixSuffixOnValue(7, 'in ', '')
        .SetSummaryPrefixSuffixOnValue(6, 'is island with ', '')
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfSummaryMembersNoName)
    ).IncludeFlag(dfCollapsed),
    wbStruct(NVPP, 'Precomputed Pathing', [
      wbArray('Precomputed Paths',
        wbArray('Path',
          wbFormIDCk('Navmesh', [NAVM]),
        -1).IncludeFlag(dfCollapsed),
      -1).IncludeFlag(dfCollapsed),
      wbArrayS('Road Marker Index',
        wbStructSK([1], 'Road Marker', [
          wbFormIDCk('Navmesh', [NAVM]),
          wbInteger('Index', itU32)
        ]).IncludeFlag(dfCollapsed),
      -1).IncludeFlag(dfCollapsed)
    ]).IncludeFlag(dfCollapsed),
    wbArrayS(NVSI, 'Deleted Navmeshes',
      wbFormIDCk('Navmesh', [NAVM])
    ).IncludeFlag(dfCollapsed)
  ]);

   wbRecord(EXPL, 'Explosion', [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbDESC,
    wbPHST,
    wbOPDSs,
    wbFULL,
    wbGenericModel,
    wbEITM,
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD]),
    wbStruct(DATA, 'Data', [
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFormIDCk('Sound 1', [SNDR, NULL]),
      wbFormIDCk('Sound 2', [SNDR, NULL]),
      wbFormIDCk('Impact Data Set', [IPDS, NULL]),
      wbFormID('Placed Object'),
      wbFormIDCk('Spawn Projectile', [PROJ, NULL]),
      wbFromVersion(150, wbFormIDCk('Damage Curve Table', [CURV, NULL])),
      wbFloat('Force'),
      wbFloat('Damage'),
      wbFromVersion(97, wbFloat('Inner Radius')),
      wbFloat('Outer Radius'),
      wbFloat('IS Radius'),
      wbFloat('Vertical Offset Mult'),
      wbInteger('Flags1', itU32, wbFlags([
        {0x0000000000000001} 'Unknown 0',
        {0x0000000000000002} 'Always Uses World Orientation',
        {0x0000000000000004} 'Knock Down - Always',
        {0x0000000000000008} 'Knock Down - By Formula',
        {0x0000000000000010} 'Ignore LOS Check',
        {0x0000000000000020} 'Push Explosion Source Ref Only',
        {0x0000000000000040} 'Ignore Image Space Swap',
        {0x0000000000000080} 'Chain',
        {0x0000000000000100} 'No Controller Vibration',
        {0x0000000000000200} 'Placed Object Persists',
        {0x0000000000000400} 'Skip Underwater Tests',
        {0x0000000000000400} 'Unknown 11',
        {0x0000000000000800} 'Unknown 12',
        {0x0000000000001000} 'Unknown 13',
        {0x0000000000002000} 'Unknown 14',
        {0x0000000000004000} 'Unknown 15',
        {0x0000000000008000} 'Unknown 16',
        {0x0000000000010000} 'Unknown 17',
        {0x0000000000020000} 'Unknown 18',
        {0x0000000000040000} 'Unknown 19',
        {0x0000000000080000} 'Unknown 20',
        {0x0000000000100000} 'Unknown 21',
        {0x0000000000200000} 'Unknown 22',
        {0x0000000000400000} 'Unknown 23',
        {0x0000000000800000} 'Unknown 24',
        {0x0000000001000000} 'Unknown 25',
        {0x0000000002000000} 'Unknown 26',
        {0x0000000004000000} 'Unknown 27',
        {0x0000000008000000} 'Unknown 28',
        {0x0000000010000000} 'Unknown 29',
        {0x0000000020000000} 'Unknown 30',
        {0x0000000040000000} 'Unknown 31',
        {0x0000000080000000} 'Unknown 32'
      ])),
      wbInteger('Sound Level', itU32, wbSoundLevelEnum),
      wbFromVersion(70, wbFloat('Placed Object AutoFade Delay')),
      wbFromVersion(91, wbInteger('Stagger', itU32, wbEnum([
        'None',
        'Small',
        'Medium',
        'Large',
        'Extra Large'
      ]))),
      wbFromVersion(112, wbStruct('Spawn', [
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z'),
        wbFloat('Spread Degrees'),
        wbInteger('Count', itU32)
      ])),
      wbFromVersion(173, wbFloat('Base Weapon Damage Mult'))
    ], cpNormal, True, nil, 13),
    wbDamageTypeArray('Damage Type')
  ]);

  wbRecord(DEBR, 'Debris', [
    wbEDID,
    wbRArray('Models', wbDebrisModel(wbMODT))
  ]);

  wbRecord(IMGS, 'Image Space', [
    wbEDID,
    wbStruct(ENAM, 'HDR', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Tonemap E'),
      wbFloat('Bloom Threshold'),
      wbFloat('Bloom Scale'),
      wbFloat('Auto Exposure Max'),
      wbFloat('Auto Exposure Min'),
      wbFloat('Sunlight Scale'),
      wbFloat('Sky Scale'),
      wbFloat('Middle Gray'),
      wbFloat('Fog Scale'),
      wbFloat('Tonemap White Point'),
      wbUnknown
    ], cpNormal),
    wbStruct(HNAM, 'HDR', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Tonemap E'),
      wbFloat('Bloom Threshold'),
      wbFloat('Bloom Scale'),
      wbFloat('Auto Exposure Max'),
      wbFloat('Auto Exposure Min'),
      wbFloat('Sunlight Scale'),
      wbFloat('Sky Scale'),
      wbFloat('Middle Gray')
    ], cpNormal),
    wbStruct(FNAM, 'HDR', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Tonemap E'),
      wbFloat('Bloom Threshold'),
      wbFloat('Bloom Scale'),
      wbFloat('Auto Exposure Max'),
      wbFloat('Auto Exposure Min'),
      wbFloat('Sunlight Scale'),
      wbFloat('Sky Scale'),
      wbFloat('Middle Gray'),
      wbFloat('Fog Scale'),
      wbFloat('Tonemap White Point')
    ], cpNormal),
    wbStruct(GNAM, 'HDR', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Tonemap E'),
      wbFloat('Bloom Threshold'),
      wbFloat('Bloom Scale'),
      wbFloat('Auto Exposure Max'),
      wbFloat('Auto Exposure Min'),
      wbFloat('Sunlight Scale'),
      wbFloat('Sky Scale'),
      wbFloat('Middle Gray'),
      wbFromVersion(155, wbFloat('Fog Scale')),
      wbFromVersion(155, wbFloat('Tonemap White Point'))
    ], cpNormal),
    wbStruct(CNAM, 'Cinematic', [
      wbFloat('Saturation'),
      wbFloat('Brightness'),
      wbFloat('Contrast')
    ], cpNormal, True),
    wbStruct(TNAM, 'Tint', [
      wbFloat('Amount'),
      wbFloatColors('Color')
    ], cpNormal, True),
    wbStruct(DNAM, 'Depth of Field', [
      wbFloat('Strength'),
      wbFloat('Distance'),
      wbFloat('Range'),
      wbByteArray('Unused', 2, cpIgnore),
      wbInteger('Sky / Blur Radius', itU16, wbEnum([], [
            0, 'None',
        16384, 'Radius 0',
        16672, 'Radius 1',
        16784, 'Radius 2',
        16848, 'Radius 3',
        16904, 'Radius 4',
        16936, 'Radius 5',
        16968, 'Radius 6',
        17000, 'Radius 7',
        16576, 'No Sky, Radius 0',
        16736, 'No Sky, Radius 1',
        16816, 'No Sky, Radius 2',
        16880, 'No Sky, Radius 3',
        16920, 'No Sky, Radius 4',
        16952, 'No Sky, Radius 5',
        16984, 'No Sky, Radius 6',
        17016, 'No Sky, Radius 7'
      ])),
      wbFloat('Vignette Radius'),
      wbFloat('Vignette Strength')
    ], cpNormal, True, nil, 5),
    wbStruct(XNAM, 'Camera Parameters', [
      wbFloat('Exposure Value'),
      wbFloat('UnknownFloat2'),
      wbFloat('Aperture'),
      wbFloat('Shutter Time'),
      wbFloat('ISO')
    ]),
    wbFloat(INAM),
    wbInteger(YNAM, 'Exposure Mode', itU32, wbEnum([
      'Auto',
      'Fixed Ev100',
      'Camera parameters'
    ],[])),
    wbUnknown(ZNAM), {TODO}
    wbString(TX00, 'LUT')
  ]);

  wbIMADUnknown1 := wbStruct('Unknown', [
    wbByteArray('Unknown', 4), //may be a float too, can't confirm
    wbFloat('Unknown'),
    wbFloat('Unknown'),
    wbFloat('Unknown')
  ]);


  wbRecord(IMAD, 'Image Space Adapter',
    wbFlags(wbFlagsList([
          {0x00000800} 11, 'Unknown' // something to do with Photo Mode
        ])), [
    wbEDID,
    wbStruct(DNAM, 'Data', [
      wbInteger('Animatable', itU32, wbBoolEnum),
      wbFloat('Duration'),
      wbStruct('HDR', [
        wbInteger('Eye Adapt Speed Mult Count', itU32),
        wbInteger('Eye Adapt Speed Add Count', itU32),
        wbInteger('Bloom Blur Radius Mult Count', itU32),
        wbInteger('Bloom Blur Radius Add Count', itU32),
        wbInteger('Bloom Threshold Mult Count', itU32),
        wbInteger('Bloom Threshold Add Count', itU32),
        wbInteger('Bloom Scale Mult Count', itU32),
        wbInteger('Bloom Scale Add Count', itU32),
        wbInteger('Target Lum Min Mult Count', itU32),
        wbInteger('Target Lum Min Add Count', itU32),
        wbInteger('Target Lum Max Mult Count', itU32),
        wbInteger('Target Lum Max Add Count', itU32),
        wbInteger('Sunlight Scale Mult Count', itU32),
        wbInteger('Sunlight Scale Add Count', itU32),
        wbInteger('Sky Scale Mult Count', itU32),
        wbInteger('Sky Scale Add Count', itU32)
      ]),
      wbInteger('Unused08 Mult Count', itU32),
      wbInteger('Unused48 Add Count', itU32),
      wbInteger('Unused09 Mult Count', itU32),
      wbInteger('Unused49 Add Count', itU32),
      wbInteger('Unused0A Mult Count', itU32),
      wbInteger('Unused4A Add Count', itU32),
      wbInteger('Unused0B Mult Count', itU32),
      wbInteger('Unused4B Add Count', itU32),
      wbInteger('Unused0C Mult Count', itU32),
      wbInteger('Unused4C Add Count', itU32),
      wbInteger('Unused0D Mult Count', itU32),
      wbInteger('Unused4D Add Count', itU32),
      wbInteger('Unused0E Mult Count', itU32),
      wbInteger('Unused4E Add Count', itU32),
      wbInteger('Unused0F Mult Count', itU32),
      wbInteger('Unused4F Add Count', itU32),
      wbInteger('Unused10 Mult Count', itU32),
      wbInteger('Unused50 Add Count', itU32),
      wbStruct('Cinematic', [
        wbInteger('Saturation Mult Count', itU32),
        wbInteger('Saturation Add Count', itU32),
        wbInteger('Brightness Mult Count', itU32),
        wbInteger('Brightness Add Count', itU32),
        wbInteger('Contrast Mult Count', itU32),
        wbInteger('Contrast Add Count', itU32),
        wbInteger('Unused14 Mult Count', itU32),
        wbInteger('Unused54 Add Count', itU32)
      ]),
      wbInteger('Tint Color Count', itU32),
      wbInteger('Blur Radius Count', itU32),
      wbInteger('Double Vision Strength Count', itU32),
      wbInteger('Radial Blur Strength Count', itU32),
      wbInteger('Radial Blur Ramp Up Count', itU32),
      wbInteger('Radial Blur Start Count', itU32),
      wbInteger('Radial Blur Use Target', itU32, wbBoolEnum),
      wbFloat('Radial Blur Center X'),
      wbFloat('Radial Blur Center Y'),
      wbInteger('DoF Strength Count', itU32),
      wbInteger('DoF Distance Count', itU32),
      wbInteger('DoF Range Count', itU32),
      wbInteger('DoF Use Target', itU8, wbBoolEnum),
      wbInteger('DoF Flags', itU8, wbFlags([
        {0x00000001} 'Mode - Front',
        {0x00000002} 'Mode - Back',
        {0x00000004} 'No Sky',
        {0x00000008} 'Blur Radius Bit 2',
        {0x00000010} 'Blur Radius Bit 1',
        {0x00000020} 'Blur Radius Bit 0'
      ])),
      wbInteger('Unused', itU16),
      wbInteger('Radial Blur Ramp Down Count', itU32),
      wbInteger('Radial Blur Down Start Count', itU32),
      wbInteger('Fade Coloe Count', itU32),
      wbInteger('Motion Blur Strength Count', itU32),
      wbFromSize(248, wbInteger('Vignette Radius Count', itU32)),
      wbFromSize(252, wbInteger('Vignette Strength Count', itU32))
    ]),
    wbString(LNAM, 'Texture'),
    wbTimeInterpolators(BNAM, 'Blur Radius'),
    wbTimeInterpolators(VNAM, 'Double Vision Strength'),
    wbArray(TNAM, 'Tint Color', wbColorInterpolator),
    wbArray(NAM3, 'Fade Color', wbColorInterpolator),
    wbRStruct('Radial Blur', [
      wbTimeInterpolators(RNAM, 'Strength'),
      wbTimeInterpolators(SNAM, 'Ramp Up'),
      wbTimeInterpolators(UNAM, 'Start'),
      wbTimeInterpolators(NAM1, 'Ramp Down'),
      wbTimeInterpolators(NAM2, 'Down Start')
    ], []),
    wbRStruct('Depth of Field', [
      wbTimeInterpolators(WNAM, 'Strength'),
      wbTimeInterpolators(XNAM, 'Distance'),
      wbTimeInterpolators(YNAM, 'Range'),
      wbTimeInterpolators(NAM5, 'Vignette Radius'),
      wbTimeInterpolators(NAM6, 'Vignette Strength')
    ], []),
    wbTimeInterpolators(NAM4, 'Motion Blur Strength'),
    wbRStruct('HDR', [
      wbTimeInterpolatorsMultAdd(_00_IAD, _40_IAD, 'Eye Adapt Speed'),
      wbTimeInterpolatorsMultAdd(_01_IAD, _41_IAD, 'Bloom Blur Radius'),
      wbTimeInterpolatorsMultAdd(_02_IAD, _42_IAD, 'Bloom Threshold'),
      wbTimeInterpolatorsMultAdd(_03_IAD, _43_IAD, 'Bloom Scale'),
      wbTimeInterpolatorsMultAdd(_04_IAD, _44_IAD, 'Target Lum Min'),
      wbTimeInterpolatorsMultAdd(_05_IAD, _45_IAD, 'Target Lum Max'),
      wbTimeInterpolatorsMultAdd(_06_IAD, _46_IAD, 'Sunlight Scale'),
      wbTimeInterpolatorsMultAdd(_07_IAD, _47_IAD, 'Sky Scale')
    ], []),
    wbTimeInterpolatorsMultAdd(_08_IAD, _48_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_09_IAD, _49_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0A_IAD, _4A_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0B_IAD, _4B_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0C_IAD, _4C_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0D_IAD, _4D_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0E_IAD, _4E_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_0F_IAD, _4F_IAD, 'Unused'),
    wbTimeInterpolatorsMultAdd(_10_IAD, _50_IAD, 'Unused'),
    wbCinematicIMAD,
    wbString(FULL, 'Name')
  ]);

  wbRecord(FLST, 'FormID List',
    wbFlags(wbFlagsList([
          {0x00000002} 2, 'Unknown 2',   //0066CD08
          {0x00000200} 9, 'Unknown 9'    //0066CD08
    ])), [
    wbString(EDID, 'Editor ID', 0, cpBenign, True, nil, wbFLSTEDIDAfterSet),
    wbXALG,
    wbFULL,
    wbRArrayS('FormIDs', wbFormID(LNAM, 'FormID').IncludeFlag(dfNoReport), cpNormal, False, nil, nil, nil, wbFLSTLNAMIsSorted)
  ]);

  var wbPerkConditions :=
    wbRStructSK([0], 'Perk Condition', [
      wbInteger(PRKC, 'Run On (Tab Index)', itS8{, wbPRKCToStr, wbPRKCToInt}),
      wbCTDAsReq
    ], [], cpNormal, False{, nil, nil, wbPERKPRKCDontShow});

  wbPerkEffect :=
    wbRStructSK([0, 1], 'Effect', [
      wbStructSK(PRKE, [1, {2,} 0], 'Header', [
        wbPerkEffectType(wbPERKPRKETypeAfterSet),
        wbInteger('Rank', itU8),
        wbBelowVersion(181, wbUnknown)
      ]),
      wbUnion(DATA, 'Effect Data', wbPerkEffectDataDecider, [
        wbStructSK([0, 1], 'Quest + Stage', [
          wbFormIDCk('Quest', [QUST]),
          wbInteger('Quest Stage', itU16, wbPerkDATAQuestStageToStr, wbQuestStageToInt)
        ]),
        wbFormIDCk('Ability', [SPEL]),
        wbStructSK([0, 1], 'Entry Point', [
          wbInteger('Entry Point', itU8, wbEntryPointsEnum, cpNormal, True, nil{, wbPERKEntryPointAfterSet}),
          wbInteger('Function', itU8, wbEnum([
            {0} 'Null Function',
            {1} 'Set Value', // EPFT=1
            {2} 'Add Value', // EPFT=1
            {3} 'Multiply Value', // EPFT=1
            {4} 'Add Range To Value', // EPFT=2
            {5} 'Add Actor Value Mult', // EPFT=2
            {6} 'Absolute Value', // no params
            {7} 'Negative Absolute Value', // no params
            {8} 'Add Leveled List', // EPFT=3
            {9} 'Add Activate Choice', // EPFT=4
           {10} 'Select Spell', // EPFT=5
           {11} 'Select Text', // EPFT=6
           {12} 'Set to Actor Value Mult', // EPFT=2
           {13} 'Multiply Actor Value Mult', // EPFT=2
           {14} 'Multiply 1 + Actor Value Mult', // EPFT=2
           {15} 'Set Text', // EPFT=7
           {16} 'Select Item', // EPFT=?
           {17} 'Unknown 17' // EPFT=?
          ])),
          wbInteger('Perk Condition Tab Count', itU8, nil, cpIgnore),
          wbUnknown
          //wbInteger('Has
        ])
      ], cpNormal, True),
      (**)

      wbRArrayS('Perk Conditions', wbPerkConditions),

      wbRStruct('Function Parameters', [
        wbInteger(EPFT, 'Type', itU8, wbEnum([
          {0} 'None',
          {1} 'Float',
          {2} 'Float/AV,Float',
          {3} 'Leveled List',
          {4} 'Activate Choice',
          {5} 'Spell Item',
          {6} 'Boolean Graph Variable',
          {7} 'Text',
          {8} 'Actor Value and Value',
          {9} 'Item'
        ])),
        // case(EPFT) of
        // 1: EPFD=float
        // 2: EPFD=float,float
        // 3: EPFD=LVLI
        // 4: EPFD=SPEL, EPF2=lstring, EPF3=int32 flags
        // 5: EPFD=SPEL, EPF2=unknown int
        // 6: EPFD=string
        // 7: EPFD=lstring
        // 8: EPFD=AVIF,float || float EPF3=AVIF
        // 9: EPFD=ALCH

        wbInteger(EPFB, 'Perk Entry ID (unique)', itU16),
        wbUnion(EPF2, '', wbEPF2Decider, [
          wbLString('Button Label', 0, cpTranslate),
          wbFormID('Curve Table')
        ]),
        // keeping as struct to be similar to tes5 format
        wbUnion(EPF3, '', wbEPF3Decider, [
          wbStruct('Script Flags', [
            wbInteger('Script Flags', itU16, wbFlags([
              'Run Immediately',
              'Replace Default'
            ])),
            wbUnion('Unused', wbFormVersionDecider(34, 126), [
              wbUnused(),
              wbByteArray('Unused', 2)
            ])
          ]),
          wbActorValue
        ]),
        wbUnion(EPFD, 'Data', wbEPFDDecider, [
          {0} wbByteArray('Unknown'),
          {1} wbFloat('Float'),
          {2} wbStruct('Float, Float', [
                wbFloat('Float 1'),
                wbFloat('Float 2')
              ]),
          {3} wbFormIDCk('Leveled Item', [LVLI]),
          {4} wbFormIDCk('Spell', [SPEL]),
          {5} wbFormIDCk('Spell', [SPEL]),
          {6} wbString('Text', 0, cpTranslate),
          {7} wbLString('Text', 0, cpTranslate),
          {8} wbUnion('', wbEPFDAVDataDecider, [
                wbStruct('Actor Value, Float', [
                  wbActorValue, // wbInteger('Actor Value', itU32, wbEPFDActorValueToStr, wbEPFDActorValueToInt),
                  wbFloat('Float')
                ]),
                wbFloat('Float')
              ]),
          {9} wbFormIDCk('Ingestible', [ALCH,KYWD])
        ], cpNormal, False{, wbEPFDDontShow}),
        wbInteger(EPF2, 'Unknown Spell Value', itU32),
        wbFormIdCk(EPF4, 'Actor value 2', [AVIF]),
        // keeping as struct to be similar to tes5 format
        wbUnion(EPF3, '', wbEPF3Decider, [           //ECKToDo: Fix this to be seperate structures based on the type.
          wbStruct('Script Flags', [
            wbInteger('Script Flags', itU16, wbFlags([
              'Run Immediately',
              'Replace Default'
            ])),
            wbUnion('Unused', wbFormVersionDecider(34, 126), [
              wbUnused(),
              wbByteArray('Unused', 2)
            ])
          ]),
          wbActorValue
        ])
      ], [], cpNormal, False{, wbPERKPRKCDontShow}),
      wbEmpty(PRKF, 'End Marker', cpIgnore, True)
    ], []);

  wbRecord(PERK, 'Perk',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbDURL,
    wbVMADFragmentedPERK,
    wbFULL,
    wbDESCReq,
    wbString(ICON, 'Image'),
    wbCTDAs,
    wbPERKData,
    wbFormIDCk(SNAM, 'Sound', [SNDR]),
    wbFormIDCk(PRFS, 'Perk Activation Sound', [SNDR]),
    wbFormIDCK(NNAM, 'Next Perk', [PERK, NULL]),
    wbString(FNAM, 'SWF Sprite Name'),
    wbString(PRFI, 'Perk Activation Icon'),
    wbFormIDCk(PFAC, 'Perk Added Faction', [FACT]),
    wbRArrayS('Effects', wbPerkEffect)
  ]);
  var wbBodyPartNodeData := wbStruct(BPND, 'Body Part Node Data', [
          wbFloat('Damage Mult'),
          wbFormIDCk('Explodable - Debris', [DEBR, NULL]),
          wbFormIDCk('Explodable - Explosion', [EXPL, NULL]),
          wbFloat('Explodable - Debris Scale'),
          wbFormIDCk('Severable - Debris', [DEBR, NULL]),
          wbFormIDCk('Severable - Explosion', [EXPL, NULL]),
          wbFloat('Severable - Debris Scale'),
          wbFloat('Cut - Min'),
          wbFloat('Cut - Max'),
          wbFloat('Cut - Radius'),
          wbFloatAngle('Gore Effects - Local Rotate X'),
          wbFloatAngle('Gore Effects - Local Rotate Y'),
          wbFloat('Cut - Tesselation'),
          wbFormIDCk('Severable - Impact DataSet', [IPDS, NULL]),
          wbFormIDCk('Explodable - Impact DataSet', [IPDS, NULL]),
          wbFloat('Explodable - Limb Replacement Scale'),
          wbInteger('Flags', itU8, wbFlags([
            {0x01} 'Severable',
            {0x02} 'Hit Reaction',
            {0x04} 'Hit Reaction - Default',
            {0x08} 'Explodable',
            {0x10} 'Cut - Meat Cap Sever',
            {0x20} 'On Cripple',
            {0x40} 'Explodable - Absolute Chance',
            {0x80} 'Show Cripple Geometry'
          ])),
          wbInteger('Part Type', itU8, wbEnum([
            { 0} 'Torso',
            { 1} 'Head1',
            { 2} 'Eye',
            { 3} 'LookAt',
            { 4} 'Fly Grab',
            { 5} 'Head2',
            { 6} 'LeftArm1',
            { 7} 'LeftArm2',
            { 8} 'RightArm1',
            { 9} 'RightArm2',
            {10} 'LeftLeg1',
            {11} 'LeftLeg2',
            {12} 'LeftLeg3',
            {13} 'RightLeg1',
            {14} 'RightLeg2',
            {15} 'RightLeg3',
            {16} 'Brain',
            {17} 'Weapon',
            {18} 'Root',
            {19} 'COM',
            {20} 'Pelvis',
            {21} 'Camera',
            {22} 'Offset Root',
            {23} 'Left Foot',
            {24} 'Right Foot',
            {25} 'Face Target Source'
          ])),
          wbInteger('Health Percent', itU8),
          wbUnion('Actor Value', wbFormVersionDecider(78), [
            wbInteger('Actor Value', itU8, wbActorValueEnum),
            wbFormIDCk('Actor Value', [AVIF, NULL])
          ]),
          wbInteger('To Hit Chance', itU8),
          wbInteger('Explodable - Explosion Chance %', itU8),
          wbFromVersion(100, wbInteger('Non-Lethal Dismemberment Chance', itU8)),
          wbInteger('Severable - Debris Count', itU8),
          wbInteger('Explodable - Debris Count', itU8),
          wbInteger('Severable - Decal Count', itU8),
          wbInteger('Explodable - Decal Count', itU8),
          wbInteger('Geometry Segment Index', itU8),
          wbBelowVersion(78, wbByteArray('Unused',1)),
          wbFromVersion(95, wbStruct('On Cripple', [
            wbFormIDCk('On Cripple - Art Object', [ARTO, NULL]),
            wbFormIDCk('On Cripple - Debris', [DEBR, NULL]),
            wbFormIDCk('On Cripple - Explosion', [EXPL, NULL]),
            wbFormIDCk('On Cripple - Impact DataSet', [IPDS, NULL]),
            wbFloat('On Cripple - Debris Scale'),
            wbInteger('On Cripple - Debris Count', itU8),
            wbInteger('On Cripple - Decal Count', itU8)
          ])),
          wbFromVersion(168, wbFloat('Unknown'))
        ], cpNormal, True);

  wbRecord(BPTD, 'Body Part Data', [
    wbEDID,
    wbGenericModel,
    wbRArrayS('Body Parts',
      wbRStructSK([1], 'Body Part', [
        wbString(BPVB, 'Bone Name', 0, cpNormal, True),
        wbLString(BPTN, 'Part Name', 0, cpTranslate), // optional
        wbString(BPNN, 'Part Node', 0, cpNormal, True),
        wbString(BPNT, 'VATS Target', 0, cpNormal, True),
        wbBodyPartNodeData,
        wbString(NAM1, 'Limb Replacement Model', 0, cpNormal, True),
        wbString(NAM4, 'Gore Effects - Target Bone', 0, cpNormal, True),
        wbModelInfo(NAM5),
        wbString(ENAM, 'Hit Reaction - Start'),
        wbString(FNAM, 'Hit Reaction - End'),
        wbFormIDCk(BNAM, 'Gore Effects - Dismember Blood Art', [ARTO]),
        wbFormIDCk(INAM, 'Gore Effects - Blood Impact Material Type', [MATT]),
        wbFormIDCk(JNAM, 'On Cripple - Blood Impact Material Type', [MATT]),
        wbFormIDCk(CNAM, 'Meat Cap TextureSet', [TXST]),
        wbFormIDCk(NAM2, 'Collar TextureSet', [TXST]),
        wbString(DNAM, 'Twist Variable Prefix')
      ], [], cpNormal, False, nil, True)
    )
  ]);

  wbRecord(ADDN, 'Addon Node', [
    wbEDID,
    wbOBND(True),
    wbXALG,
    wbFTAGs,
    wbOPDSs,
    wbGenericModel,
    wbRUnion('Node Index', [
      wbInteger(DATA, 'Node Index', itS32, nil, cpNormal, True),
      wbInteger(IKEK, 'Node Index', itS32, nil, cpNormal, True)
    ], []),
    wbFormIDCk(SNAM, 'Sound', [SNDR]),
    wbFormIDCk(LNAM, 'Light', [LIGH]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Master Particle System Cap', itU16),
      wbInteger('Flags', itU16, wbEnum([
        'No Master Particle System',
        'Master Particle System',
        'Always Loaded',
        'Master Particle System and Always Loaded'
      ]))
    ], cpNormal, True)
  ]);

  wbRecord(AVIF, 'Actor Value Information' ,
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbDURL,
    wbFULL,
    wbDESCReq,
    wbLString(ANAM, 'Abbreviation', 0, cpTranslate),
    wbFloat(NAM0, 'Default Value'), // Prior to form version 81, it was either 0.0, 1.0 or 100.0, so scale or multiplier ?
    wbFloat(NAM5, 'Minimum Value'),
    wbFloat(NAM6, 'Maximum Value'),
    wbInteger(AVFL, 'Flags', itU32, wbFlags([ // 32 bits Flags, it used to impact NAM0 loading (bits 10, 11, 12) (even though it loads later :) )
      {0x00000001} 'Unknown 0',
      {0x00000002} 'Skill',
      {0x00000004} 'Uses Enum',
      {0x00000008} 'Don''t allow Script edits',
      {0x00000010} 'Is Full AV Cached',
      {0x00000020} 'Is Permanant AV Cached',
      {0x00000040} 'No Modifiers',
      {0x00000080} 'Unknown 7',
      {0x00000100} 'Unknown 8',
      {0x00000200} 'Unknown 9',
      {0x00000400} 'Default to 0',
      {0x00000800} 'Default to 1.0',
      {0x00001000} 'Default to 100.0',
      {0x00002000} 'Ignore Default Value',
      {0x00004000} 'Unknown 14',
      {0x00008000} 'Contains List',
      {0x00010000} 'Unknown 16',
      {0x00020000} 'Unknown 17',
      {0x00040000} 'Unknown 18',
      {0x00080000} 'Boolean',
      {0x00100000} 'Minimum 1',
      {0x00200000} 'Maximum 10',
      {0x00400000} 'Maximum 100',
      {0x00800000} 'Multiply By 100',
      {0x01000000} 'Percentage',
      {0x02000000} 'Condition',
      {0x04000000} 'Damage Is Positive',
      {0x08000000} 'God Mode Immune',
      {0x10000000} 'Applies to Armor',
      {0x20000000} 'Unknown 29',
      {0x40000000} 'Unknown 30',
      {0x80000000} 'Hardcoded'
    ])),
    wbInteger(NAM1, 'Type', itU32, wbEnum([
      'Derived Attribute',
      'Special (Attribute)',
      'Skill',
      'AI Attribute',
      'Resistance',
      'Condition',
      'Charge',
      'Int Value',
      'Variable',
      'Resource',
      'Aggregate',
      'Reputation',
      'Unknown'
    ])),
    wbInteger(NAM2, 'Networking Flags', itU32,
      wbFlags(wbFlagsList([
        0, 'Unknown 0',
        1, 'Replicate all',
        2, 'Replicate one',
        3, 'Network Float Value',
        4, 'Only Modified Value',
        5, 'Unknown 5',
        6, 'Only Base Value',
        7, 'Low Priority'
      ]))),
    wbFormIDCk(NAM3, 'Actor Value Keyword', [KYWD]), // always a KYWD
    wbFormIDCk(NAM4, 'Associated List', [FLST]),
    wbString(CNAM, 'Description')
  ]); // S.P.E.C.I.A.L start at index 5, so FormID 0x2bc+5 to 0x2bc+11, RadResistIngestion at index 0x29

  wbRecord(CAMS, 'Camera Shot', [
    wbEDID,
    wbGenericModel,
    wbCTDAs,
    wbStruct(DATA, 'Data', [
      wbInteger('Action', itU32, wbEnum([
        {0} 'Shoot',
        {1} 'Fly',
        {2} 'Hit',
        {3} 'Zoom'
      ])),
      wbInteger('Location', itU32, wbEnum([
        {0} 'Attacker',
        {1} 'Projectile',
        {2} 'Target',
        {3} 'Lead Actor'
      ])),
      wbInteger('Target', itU32, wbEnum([
        {0} 'Attacker',
        {1} 'Projectile',
        {2} 'Target',
        {3} 'Lead Actor'
      ])),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Position Follows Location',
        {0x00000002} 'Rotation Follows Target',
        {0x00000004} 'Don''t Follow Bone',
        {0x00000008} 'First Person Camera',
        {0x00000010} 'No Tracer',
        {0x00000020} 'Start At Time Zero',
        {0x00000040} 'Don''t Reset Location Spring',
        {0x00000080} 'Don''t Reset Target Spring'
      ])),
      wbStruct('Time Multipliers', [
        wbFloat('Player'),
        wbFloat('Target'),
        wbFloat('Global')
      ]),
      wbFloat('Max Time'),
      wbFloat('Min Time'),
      wbFloat('Target % Between Actors'),
      wbFloat('Near Target Distance'),
      wbFloat('Location Spring'),
      wbFloat('Target Spring'),
      wbStruct('Rotation Offset', [
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z')
      ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3)
    ], cpNormal, True, nil, 9),
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD])
  ]);

  wbRecord(CPTH, 'Camera Path', [
    wbEDID,
    wbCTDAs,
    wbArray(ANAM, 'Related Camera Paths', wbFormIDCk('Related Camera Path', [CPTH, NULL]), ['Parent', 'Previous Sibling'], cpNormal, True),
    wbInteger(DATA, 'Camera Zoom / Flags', itU8, wbFlags([
      {0x01} 'Disable',
      {0x02} 'Shot List',
      {0x04} 'Dynamic Camera Times',
      {0x08} 'Unknown 3',
      {0x10} 'Unknown 4',
      {0x20} 'Unknown 5',
      {0x40} 'Randomize Paths',
      {0x80} 'Not Must Have Camera Shots'
    ]), cpNormal, True),
    wbRArray('Camera Shots', wbFormIDCk(SNAM, 'Camera Shot', [CAMS]))
  ]);

  wbRecord(VTYP, 'Voice Type', [
    wbEDID,
    wbFULL,
    wbInteger(DNAM, 'Flags', itU8, wbFlags([
      'Allow Default Dialog',
      'Female'
    ]), cpNormal, True),
    wbString(ENAM, 'TTS voice name')
  ]);

  wbRecord(MATT, 'Material Type', [
    wbEDID,
    wbFormIDCk(PNAM, 'Material Parent', [MATT, NULL]),
    wbString(MNAM, 'Material Name'),
    wbStruct(CNAM, 'Havok Display Color', [
      wbFloat('Red', cpNormal, True, 255, 0),
      wbFloat('Green', cpNormal, True, 255, 0),
      wbFloat('Blue', cpNormal, True, 255, 0)
    ]).SetToStr(wbRGBAToStr).IncludeFlag(dfCollapsed, wbCollapseRGBA),
    wbFloat(BNAM, 'Buoyancy'),
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      'Stair Material',
      'Arrows Stick',
      'Can Tunnel'
    ], False)),
    wbFormIDCk(HNAM, 'Havok Impact Data Set', [IPDS]),
    wbString(ANAM, 'Breakable FX'),
    wbMODT
  ]);

  wbRecord(IPCT, 'Impact', [
    wbEDID,
    wbGenericModel,
    wbStruct(DATA, '', [
      wbFloat('Effect - Duration'),
      wbInteger('Effect - Orientation', itU32, wbEnum([
        'Surface Normal',
        'Projectile Vector',
        'Projectile Reflection'
      ])),
      wbFloat('Angle Threshold'),
      wbFloat('Placement Radius'),
      wbInteger('Sound Level', itU32, wbSoundLevelEnum),
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'No Decal Data'
      ])),
      wbInteger('Impact Result', itU8, wbEnum([
         {0} 'Default',
         {1} 'Destroy',
         {2} 'Bounce',
         {3} 'Impale',
         {4} 'Stick'
      ])),
      wbByteArray('Unknown', 2)
    ], cpNormal, True),
    wbDODT,
    wbFormIDCk(DNAM, 'Texture Set', [TXST]),
    wbFormIDCk(ENAM, 'Secondary Texture Set', [TXST]),
    wbFormIDCk(SNAM, 'Sound 1', [SNDR]),
    wbFormIDCk(NAM1, 'Sound 2', [SNDR]),
    wbFormIDCk(NAM3, 'Footstep Explosion', [EXPL]),
    wbFormIDCk(NAM2, 'Hazard', [HAZD]),
    wbFormIDCk(NAM4, 'Sound 3', [SNDR]),
    wbFloat(FNAM, 'Footstep Particle Max Dist')
  ]);

  wbRecord(IPDS, 'Impact Data Set', [
    wbEDID,
    wbRArrayS('Data', wbStructSK(PNAM, [0], '', [
      wbFormIDCk('Material', [MATT]),
      wbFormIDCk('Impact', [IPCT])
    ]))
  ]);

  wbRecord(ECZN, 'Encounter Zone', [
    wbEDID,
    wbStruct(DATA, '', [
      wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
      wbFormIDCk('Location', [LCTN, NULL]),
      wbInteger('Rank', itS8),
      wbInteger('Min Level', itS8),
      wbInteger('Flags', itU8, wbFlags([
        'Never Resets',
        'Match PC Below Minimum Level',
        'Disable Combat Boundary',
        'Workshop'
      ])),
      wbInteger('Max Level', itS8)
    ], cpNormal, True)
  ]);

  wbRecord(LCTN, 'Location',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Interior Location',
      {0x00000100}  8, 'Unknown 8',
      {0x00000800} 11, 'Interior Cells Use Ref Location for world map player marker',
      {0x00004000} 14, 'Unknown 14'
    ])), [
    wbEDID,
    wbDURL,

    wbArray(ACPR, 'Actor Cell Persistent Reference', wbStruct('', [
      wbFormIDCk('Actor', sigReferences, False, cpBenign),
      wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),
    wbArray(LCPR, 'Location Cell Persistent Reference', wbStruct('', [
      wbFormIDCk('Actor', sigReferences, False, cpBenign),
      wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),
    wbArray(RCPR, 'Reference Cell Persistent Reference', wbFormIDCk('Ref', [ACHR, REFR], False, cpBenign)),

    wbArray(ACUN, 'Actor Cell Unique', wbStruct('', [
      wbFormIDCk('Actor', [NPC_], False, cpBenign),
      wbFormIDCk('Ref', [ACHR], False, cpBenign),
      wbFormIDCk('Location', [LCTN, NULL], False, cpBenign)
    ])),
    wbArray(LCUN, 'Location Cell Unique', wbStruct('', [
      wbFormIDCk('Actor', [NPC_], False, cpBenign),
      wbFormIDCk('Ref', [ACHR], False, cpBenign),
      wbFormIDCk('Location', [LCTN, NULL], False, cpBenign)
    ])),
    wbArray(RCUN, 'Reference Cell Unique', wbFormIDCk('Actor', [NPC_], False, cpBenign)),

    wbArray(ACSR, 'Actor Cell Static Reference', wbStruct('', [
      wbFormIDCk('Loc Ref Type', [LCRT], False, cpBenign),
      wbFormIDCk('Marker', sigReferences, False, cpBenign),
      wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),
    wbArray(LCSR, 'Location Cell Static Reference', wbStruct('', [
      wbFormIDCk('Loc Ref Type', [LCRT], False, cpBenign),
      wbFormIDCk('Marker', sigReferences, False, cpBenign),
      wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),
    wbArray(RCSR, 'Reference Cell Static Reference', wbFormIDCk('Ref', [ACHR, REFR], False, cpBenign)),

    wbRArray('Actor Cell Encounter Cell',
      wbStruct(ACEC, 'Unknown', [
        wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
        wbArray('Coordinates', wbStruct('', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]))
      ])
    ),
    wbRArray('Location Cell Encounter Cell',
      wbStruct(LCEC, 'Unknown', [
        wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
        wbArray('Coordinates', wbStruct('', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]))
      ])
    ),
    wbRArray('Reference Cell Encounter Cell',
      wbStruct(RCEC, 'Unknown', [
        wbFormIDCk('Location', [WRLD, CELL], False, cpBenign),
        wbArray('Coordinates', wbStruct('', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]))
      ])
    ),

    wbArray(ACID, 'Actor Cell Marker Reference', wbFormIDCk('Ref', sigReferences, False, cpBenign)),
    wbArray(LCID, 'Location Cell Marker Reference', wbFormIDCk('Ref', sigReferences, False, cpBenign)),

    wbArray(ACEP, 'Actor Cell Enable Point', wbStruct('', [
      wbFormIDCk('Actor', sigReferences, False, cpBenign),
      wbFormIDCk('Ref', sigReferences, False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),
    wbArray(LCEP, 'Location Cell Enable Point', wbStruct('', [
      wbFormIDCk('Actor', sigReferences, False, cpBenign),
      wbFormIDCk('Ref', sigReferences, False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ])),

    wbFULL,
    wbKeywords,
    wbPRPS,
    wbStruct(DATA, 'Location Data', [
      wbInteger('Unknown Int', itU32),
      wbInteger('Unknown Byte', itU8),
      wbInteger('Min Location Level', itU8),
      wbInteger('Location Type', itU8, wbEnum([],[
        0, 'None',
        1, 'Raid',
        8, 'Power Plant',
        9, 'Workshop'
      ])),
      wbInteger('Max Location Level', itU8)
    ]),
    wbFormIDCk(PNAM, 'Parent Location', [LCTN, NULL]),
    wbFormIDCk(NAM1, 'Music', [MUSC, NULL]),
    wbFormIDCk(FNAM, 'Unreported Crime Faction', [FACT]),
    wbFormIDCk(MNAM, 'World Location Marker Ref', [REFR, ACHR]),
    wbFloat(RNAM, 'World Location Radius'),
    //wbFormIDCk(NAM0, 'Horse Marker Ref', [REFR]),
    wbFloat(ANAM, 'Actor Fade Mult'),
    wbUnknown(NAM5),
    wbUnknown(NAM6),
    wbCNAM
  ]);

  var wbMenuButton :=
    wbRStruct('Menu Button', [
      wbLStringKC(ITXT, 'Button Text', 0, cpTranslate),
      wbCTDAs,
      wbEmpty(MBNR, 'No Response')
    ], []);

  wbRecord(MESG, 'Message', [
    wbEDID,
    wbDESCReq,
    wbFULL,
    wbFormIDCk(INAM, 'Icon (unused)', [NULL], False, cpIgnore, True), // leftover
    wbFormIDCk(QNAM, 'Owner Quest', [QUST]),
    wbInteger(DNAM, 'Flags', itU32, wbFlags([
      'Message Box',
      'Delay Initial Display'
    ]), cpNormal, True, False, nil, wbMESGDNAMAfterSet),
    wbXFLGLong,
    wbInteger(TNAM, 'Display Time', itU32, nil, cpNormal, False, False, wbMESGTNAMDontShow),
    wbString(SNAM, 'SWF'),
    wbLStringKC(NNAM, 'Short Title', 0, cpTranslate),
    wbRArray('Menu Buttons', wbMenuButton)
  ], False, nil, cpNormal, False, wbMESGAfterLoad);

  a := MakeVarRecs([
                  0, 'None',
    Sig2Int('AAAC'), 'Action Activate',
    Sig2Int('AAB1'), 'Action Bleedout Start',
    Sig2Int('AAB2'), 'Action Bleedout Stop',
    Sig2Int('AABA'), 'Action Block Anticipate',
    Sig2Int('AABH'), 'Action Block Hit',
    Sig2Int('AABI'), 'Action Bumped Into',
    Sig2Int('AADA'), 'Action DualAttack',
    Sig2Int('AADE'), 'Action Death',
    Sig2Int('AADL'), 'Action DualRelease',
    Sig2Int('AADR'), 'Action Draw',
    Sig2Int('AADW'), 'Action Death Wait',
    Sig2Int('AAF1'), 'Action Fly Start',
    Sig2Int('AAF2'), 'Action Fly Stop',
    Sig2Int('AAF3'), 'Action Flying Strafe Attack',
    Sig2Int('AAFA'), 'Action Fall',
    Sig2Int('AAFQ'), 'Action Force Equip',
    Sig2Int('AAGU'), 'Action Get Up',
    Sig2Int('AAH1'), 'Action Hover Start',
    Sig2Int('AAH2'), 'Action Hover Stop',
    Sig2Int('AAID'), 'Action Idle',
    Sig2Int('AAIS'), 'Action Idle Stop',
    Sig2Int('AAJP'), 'Action Jump',
    Sig2Int('AALA'), 'Action LeftAttack',
    Sig2Int('AALD'), 'Action LeftReady',
    Sig2Int('AALI'), 'Action LeftInterrupt',
    Sig2Int('AALK'), 'Action Look',
    Sig2Int('AALM'), 'Action Large Movement Delta',
    Sig2Int('AALN'), 'Action Land',
    Sig2Int('AALR'), 'Action LeftRelease',
    Sig2Int('AALS'), 'Action Left Sync Attack',
    Sig2Int('AAMT'), 'Action Mantle',
    Sig2Int('AAOE'), 'Action - AoE Attack',
    Sig2Int('AAPA'), 'Action Right Power Attack',
    Sig2Int('AAPE'), 'Action Path End',
    Sig2Int('AAPS'), 'Action Path Start',
    Sig2Int('AAR2'), 'Action Large Recoil',
    Sig2Int('AARA'), 'Action RightAttack',
    Sig2Int('AARC'), 'Action Recoil',
    Sig2Int('AARD'), 'Action RightReady',
    Sig2Int('AARI'), 'Action RightInterrupt',
    Sig2Int('AARR'), 'Action RightRelease',
    Sig2Int('AARS'), 'Action Right Sync Attack',
    Sig2Int('AAS1'), 'Action Stagger Start',
    Sig2Int('AASC'), 'Action Shield Change',
    Sig2Int('AASH'), 'Action Sheath',
    Sig2Int('AASN'), 'Action Sneak',
    Sig2Int('AASP'), 'Action Sprint Stop',
    Sig2Int('AASS'), 'Action Summoned Start',
    Sig2Int('AAST'), 'Action Sprint Start',
    Sig2Int('AASW'), 'Action Swim State Change',
    Sig2Int('AAVC'), 'Action Voice',
    Sig2Int('AAVD'), 'Action VoiceReady',
    Sig2Int('AAVI'), 'Action VoiceInterrupt',
    Sig2Int('AAVR'), 'Action VoiceRelease',
    Sig2Int('AAWH'), 'Action Ward Hit',
    Sig2Int('ABLA'), 'Action - Begin Looping Activate',
    Sig2Int('ABOL'), 'Action Bolt Charge',
    Sig2Int('ABSE'), 'Art Object - Absorb Effect',
    Sig2Int('ACHI'), 'Action Hide',
    Sig2Int('ACSS'), 'Action Cover Sprint Start',
    Sig2Int('ACTN'), 'Action Tunnel',
    Sig2Int('ACWR'), 'Action Cower',
    Sig2Int('ADGE'), 'Action Dodge',
    Sig2Int('ADPA'), 'Action Dual Power Attack',
    Sig2Int('AECL'), 'Action Enter Cover',
    Sig2Int('AELA'), 'Action - End Looping Activate',
    Sig2Int('AENC'), 'Action Enter Combat',
    Sig2Int('AENI'), 'Action Dialogue Enter',
    Sig2Int('AEVD'), 'Action Evade',
    Sig2Int('AEXC'), 'Action Exit Cover',
    Sig2Int('AEXI'), 'Action Dialogue Exit ',
    Sig2Int('AEXT'), 'Action Exit Combat',
    Sig2Int('AFCH'), 'Action Fire Charge',
    Sig2Int('AFCO'), 'Action Fire Charge Hold',
    Sig2Int('AFEM'), 'Action Fire Empty',
    Sig2Int('AFIA'), 'Action Fire Auto',
    Sig2Int('AFIS'), 'Action Fire Single',
    Sig2Int('AFLT'), 'Action Flip-Throw',
    Sig2Int('AFNP'), 'Keyword - Activator Furniture No Player',
    Sig2Int('AGAL'), 'Action Gun Alert',
    Sig2Int('AGCS'), 'Action Gun Charge Start',
    Sig2Int('AGDN'), 'Action Gun Down',
    Sig2Int('AGRX'), 'Action Gun Relaxed',
    Sig2Int('AGRY'), 'Action Gun Ready',
    Sig2Int('AIDW'), 'Action Idle Warn',
    Sig2Int('AIEN'), 'Action Interaction Enter',
    Sig2Int('AIEQ'), 'Action Interaction Exit Quick',
    Sig2Int('AIEX'), 'Action Interaction Exit',
    Sig2Int('AILN'), 'Action Dialogue Listen Negative',
    Sig2Int('AILp'), 'Action Dialogue Listen Positive',
    Sig2Int('AILQ'), 'Action Dialogue Listen Question',
    Sig2Int('AINT'), 'Action Intimidate',
    Sig2Int('AIVC'), 'Verlet Cape',
    Sig2Int('AIXA'), 'Action Interaction Exit Alternate',
    Sig2Int('AKDN'), 'Action Knockdown',
    Sig2Int('ALIC'), 'Action Limb Critical',
    Sig2Int('ALIK'), 'Alcohol item keyword',
    Sig2Int('ALPA'), 'Action Left Power Attack',
    Sig2Int('ALTI'), 'Action Dialogue Listen',
    Sig2Int('AMBK'), 'Action Move Backward',
    Sig2Int('AMEL'), 'Action Melee',
    Sig2Int('AMFD'), 'Action Move Forward',
    Sig2Int('AMLT'), 'Action Move Left',
    Sig2Int('AMRT'), 'Action Move Right',
    Sig2Int('AMSP'), 'Action Move Stop',
    Sig2Int('AMST'), 'Action Move Start',
    Sig2Int('ANML'), 'Keyword - Animal',
    Sig2Int('ANSC'), 'Action NonSupport Contact',
    Sig2Int('AODA'), 'Keyword - Armor Material Daedric',
    Sig2Int('AODB'), 'Keyword - Armor Material Dragonbone',
    Sig2Int('AODP'), 'Keyword - Armor Material Dragonplate',
    Sig2Int('AODS'), 'Keyword - Armor Material Dragonscale',
    Sig2Int('AODW'), 'Keyword - Armor Material Dwarven',
    Sig2Int('AOEB'), 'Keyword - Armor Material Ebony',
    Sig2Int('AOEL'), 'Keyword - Armor Material Elven',
    Sig2Int('AOES'), 'Keyword - Armor Material ElvenSplinted',
    Sig2Int('AOFE'), 'Keyword - Armor Material Iron',
    Sig2Int('AOFL'), 'Keyword - Armor Material FullLeather',
    Sig2Int('AOGL'), 'Keyword - Armor Material Glass',
    Sig2Int('AOHI'), 'Keyword - Armor Material Hide',
    Sig2Int('AOIB'), 'Keyword - Armor Material IronBanded',
    Sig2Int('AOIH'), 'Keyword - Armor Material ImperialHeavy',
    Sig2Int('AOIM'), 'Keyword - Armor Material Imperial',
    Sig2Int('AOIR'), 'Keyword - Armor Material ImperialReinfo',
    Sig2Int('AOOR'), 'Keyword - Armor Material Orcish',
    Sig2Int('AOSC'), 'Keyword - Armor Material Scaled',
    Sig2Int('AOSD'), 'Keyword - Armor Material Studded',
    Sig2Int('AOSK'), 'Keyword - Armor Material Stormcloak',
    Sig2Int('AOSP'), 'Keyword - Armor Material SteelPlate',
    Sig2Int('AOST'), 'Keyword - Armor Material Steel',
    Sig2Int('APIC'), 'Action Pipboy Close',
    Sig2Int('APID'), 'Action Pipboy Data',
    Sig2Int('APII'), 'Action Pipboy Inventory',
    Sig2Int('APIM'), 'Action Pipboy Map',
    Sig2Int('APIN'), 'Action Pipboy Inspect',
    Sig2Int('APIP'), 'Action Pipboy',
    Sig2Int('APIS'), 'Action Pipboy Stats',
    Sig2Int('APIT'), 'Action Pipboy Tab',
    Sig2Int('APIZ'), 'Action Pipboy Zoom',
    Sig2Int('APLH'), 'Action Pipboy Load Holotape',
    Sig2Int('APLN'), 'Action Dialogue Listen Neutral',
    Sig2Int('APNC'), 'Action Panic',
    Sig2Int('APPS'), 'Action Pipboy Select',
    Sig2Int('APR0'), 'Action Pipboy Radio Off',
    Sig2Int('APR1'), 'Action Pipboy Radio On',
    Sig2Int('APSH'), 'Allow Player Shout',
    Sig2Int('APTP'), 'Action Pipboy Tab Previous',
    Sig2Int('AREL'), 'Action Reload',
    Sig2Int('ARGI'), 'Action Ragdoll Instant',
    Sig2Int('ARTL'), 'Armor Material List',
    Sig2Int('ASFL'), 'Action Shuffle',
    Sig2Int('ASID'), 'Action Idle Stop Instant',
    Sig2Int('ASIR'), 'Action Sighted Release',
    Sig2Int('ASIT'), 'Action Sighted',
    Sig2Int('ATHR'), 'Action Throw',
    Sig2Int('ATKI'), 'Action Dialogue Talking',
    Sig2Int('ATLE'), 'Action Turn Left',
    Sig2Int('ATRI'), 'Action Turn Right',
    Sig2Int('ATSP'), 'Action Turn Stop',
    Sig2Int('AVVP'), 'Vampire Available Perks',
    Sig2Int('AVWP'), 'Unused',
    Sig2Int('AWWS'), 'Action Waterwalk Start',
    Sig2Int('AWWW'), 'Bunny Faction',
    Sig2Int('BAPO'), 'Base Potion',
    Sig2Int('BAPS'), 'Base Poison',
    Sig2Int('BEEP'), 'Keyword - Robot',
    Sig2Int('BENA'), 'Base Armor Enchantment',
    Sig2Int('BENW'), 'Base Weapon Enchantment',
    Sig2Int('BTMS'), 'Battle Music',
    Sig2Int('CACA'), 'Commanded Actor Ability',
    Sig2Int('CHIK'), 'Chem item keyword',
    Sig2Int('CLIK'), 'Clothes item keyword',
    Sig2Int('CMPX'), 'Complex Scene Object',
    Sig2Int('CNMK'), 'Keyword - nullptr MOD',
    Sig2Int('COEX'), 'Keyword - Conditional Explosion',
    Sig2Int('COOK'), 'Keyword: Cooking Pot',
    Sig2Int('CSTY'), 'Combat Style',
    Sig2Int('CWNE'), 'Keyword - Civil War Neutral',
    Sig2Int('CWOK'), 'Keyword - Civil War Owner',
    Sig2Int('DAED'), 'Keyword - Daedra',
    Sig2Int('DBHF'), 'Dark Brotherhood Faction',
    Sig2Int('DCMS'), 'Dungeon Cleared Music',
    Sig2Int('DCZM'), 'Dragon Crash Zone Marker',
    Sig2Int('DDSC'), 'Dialogue Voice Category',
    Sig2Int('DEIS'), 'Drug Wears Off Image Space',
    Sig2Int('DFTS'), 'Footstep Set',
    Sig2Int('DGFL'), 'DialogueFollower Quest',
    Sig2Int('DIEN'), 'Keyword - Disallow Enchanting',
    Sig2Int('DLMT'), 'Landscape Material',
    Sig2Int('DLZM'), 'Dragon Land Zone Marker',
    Sig2Int('DMFL'), 'Default MovementType: Fly',
    Sig2Int('DMSN'), 'Default MovementType: Sneak',
    Sig2Int('DMSW'), 'Default MovementType: Swim',
    Sig2Int('DMWL'), 'Default MovementType: Default',
    Sig2Int('DOP2'), 'Dialogue Output Model (3D)',
    Sig2Int('DOP3'), 'Dialogue Output Model (2D)',
    Sig2Int('DRAK'), 'Keyword - Dragon',
    Sig2Int('DTMS'), 'Death Music',
    Sig2Int('EACA'), 'Every Actor Ability',
    Sig2Int('EPDF'), 'Eat Package Default Food',
    Sig2Int('FFFP'), 'Keyword - Furniture Forces 1st Person',
    Sig2Int('FFTP'), 'Keyword - Furniture Forces 3rd Person',
    Sig2Int('FOIK'), 'Food item keyword',
    Sig2Int('FORG'), 'Keyword: Forge',
    Sig2Int('FTEL'), 'Male Face Texture Set: Eyes',
    Sig2Int('FTGF'), 'Fighters'' Guild Faction',
    Sig2Int('FTHD'), 'Male Face Texture Set: Head',
    Sig2Int('FTHF'), 'Female Face Texture Set: Head',
    Sig2Int('FTMF'), 'Female Face Texture Set: Mouth',
    Sig2Int('FTML'), 'Favor travel marker location',
    Sig2Int('FTMO'), 'Male Face Texture Set: Mouth',
    Sig2Int('FTNP'), 'Furniture Test NPC',
    Sig2Int('FTRF'), 'Female Face Texture Set: Eyes'
  ]);

  b := MakeVarRecs([
    Sig2Int('GCK1'), 'Keyword - Generic Craftable Keyword 01',
    Sig2Int('GCK2'), 'Keyword - Generic Craftable Keyword 02',
    Sig2Int('GCK3'), 'Keyword - Generic Craftable Keyword 03',
    Sig2Int('GCK4'), 'Keyword - Generic Craftable Keyword 04',
    Sig2Int('GCK5'), 'Keyword - Generic Craftable Keyword 05',
    Sig2Int('GCK6'), 'Keyword - Generic Craftable Keyword 06',
    Sig2Int('GCK7'), 'Keyword - Generic Craftable Keyword 07',
    Sig2Int('GCK8'), 'Keyword - Generic Craftable Keyword 08',
    Sig2Int('GCK9'), 'Keyword - Generic Craftable Keyword 09',
    Sig2Int('GCKX'), 'Keyword - Generic Craftable Keyword 10',
    Sig2Int('GFAC'), 'Guard Faction',
    Sig2Int('GLIK'), 'Gloves item keyword',
    Sig2Int('GOLD'), 'Gold',
    Sig2Int('GRIK'), 'Grenade item keyword',
    Sig2Int('HBAL'), 'Help - Basic Alchemy',
    Sig2Int('HBBR'), 'Help - Barter',
    Sig2Int('HBCO'), 'Help - Basic Cooking',
    Sig2Int('HBEC'), 'Help - Basic Enchanting',
    Sig2Int('HBFG'), 'Help - Basic Forging',
    Sig2Int('HBFS'), 'Help - Favorites',
    Sig2Int('HBFT'), 'Help - Teamate Favor',
    Sig2Int('HBHJ'), 'Help - Jail',
    Sig2Int('HBJL'), 'Help - Journal',
    Sig2Int('HBLH'), 'Help - Low Health',
    Sig2Int('HBLK'), 'Help - Basic Lockpicking (PC)',
    Sig2Int('HBLM'), 'Help - Low Magicka',
    Sig2Int('HBLS'), 'Help - Low Stamina',
    Sig2Int('HBLU'), 'Help - Leveling up',
    Sig2Int('HBLX'), 'Help - Basic Lockpicking (Console)',
    Sig2Int('HBML'), 'Help - Basic Smelting',
    Sig2Int('HBMM'), 'Help - Map Menu',
    Sig2Int('HBOC'), 'Help - Basic Object Creation',
    Sig2Int('HBSA'), 'Help - Basic Smithing Armor',
    Sig2Int('HBSK'), 'Help - Skills Menu',
    Sig2Int('HBSM'), 'Help - Basic Smithing Weapon',
    Sig2Int('HBTA'), 'Help - Basic Tanning',
    Sig2Int('HBWC'), 'Help - Weapon Charge',
    Sig2Int('HCLL'), 'FormList - Hair Color List',
    Sig2Int('HEIK'), 'Helmet item keyword',
    Sig2Int('HFSD'), 'Heartbeat Sound Fast',
    Sig2Int('HMPC'), 'Help Manual PC',
    Sig2Int('HMXB'), 'Help Manual XBox',
    Sig2Int('HRSK'), 'Keyword - Horse',
    Sig2Int('HSSD'), 'Heartbeat Sound Slow',
    Sig2Int('HVFS'), 'Harvest Failed Sound',
    Sig2Int('HVSS'), 'Harvest Sound',
    Sig2Int('HWIK'), 'Heavy Weapon item keyword',
    Sig2Int('IMDI'), 'Dialogue Imagespace',
    Sig2Int('IMID'), 'ImageSpaceModifier for inventory menu.',
    Sig2Int('IMLH'), 'Imagespace: Low Health',
    Sig2Int('IMPP'), 'ImageSpaceModifier for Pipboy menu in Power Armor',
    Sig2Int('IOPM'), 'Interface Output Model',
    Sig2Int('JRLF'), 'Jarl Faction',
    Sig2Int('JWLR'), 'Keyword - Jewelry',
    Sig2Int('KHFL'), 'Kinect Help FormList',
    Sig2Int('KNAD'), 'Keyword - Network Activation - Disable',
    Sig2Int('KTRW'), 'Teammate Ready Weapon',
    Sig2Int('KWBR'), 'UNUSED02',
    Sig2Int('KWCU'), 'Keyword - Cuirass',
    Sig2Int('KWDM'), 'Keyword - DummyObject',
    Sig2Int('KWDO'), 'Keyword - ClearableLocation',
    Sig2Int('KWGE'), 'Keyword - UseGeometryEmitter',
    Sig2Int('KWMS'), 'Keyword - MustStop',
    Sig2Int('LGH1'), 'Default Light 1',
    Sig2Int('LGH2'), 'Default Light 2',
    Sig2Int('LGH3'), 'Default Light 3',
    Sig2Int('LGH4'), 'Default Light 4',
    Sig2Int('LGHP'), 'Pipboy Light',
    Sig2Int('LGPS'), 'Pipboy Small Light',
    Sig2Int('LKHO'), 'Keyword - Hold Location',
    Sig2Int('LKPK'), 'Lockpick',
    Sig2Int('LMHP'), 'Local Map Hide Plane',
    Sig2Int('LRRD'), 'LocRefType - Resource Destructible',
    Sig2Int('LRSO'), 'LocRefType - Civil War Soldier',
    Sig2Int('LSIS'), 'Imagespace: Load screen',
    Sig2Int('MBIK'), 'Med bag item keyword',
    Sig2Int('MDSC'), 'Music Sound Category',
    Sig2Int('MFSN'), 'Magic Fail Sound',
    Sig2Int('MGGF'), 'Mages'' Guild Faction',
    Sig2Int('MIIK'), 'Mine item keyword',
    Sig2Int('MMCL'), 'Main Menu Cell',
    Sig2Int('MMSD'), 'Map Menu Looping Sound',
    Sig2Int('MNTK'), 'Keyword - Mount',
    Sig2Int('MTSC'), 'Master Sound Category',
    Sig2Int('MVBL'), 'Keyword - Movable',
    Sig2Int('NASD'), 'No-Activation Sound',
    Sig2Int('NDSC'), 'Non-Dialogue Voice Category',
    Sig2Int('NMRD'), 'Road Marker',
    Sig2Int('NPCK'), 'Keyword - Humanoid',
    Sig2Int('NRNT'), 'Keyword - Nirnroot',
    Sig2Int('P3OM'), 'Player''s Output Model (3rd Person)',
    Sig2Int('PDLC'), 'Pause During Loading Menu Category',
    Sig2Int('PDMC'), 'Pause During Menu Category (Fade)',
    Sig2Int('PDSA'), 'Putdown Sound Armor',
    Sig2Int('PDSB'), 'Putdown Sound Book',
    Sig2Int('PDSG'), 'Putdown Sound Generic',
    Sig2Int('PDSI'), 'Putdown Sound Ingredient',
    Sig2Int('PDSW'), 'Putdown Sound Weapon',
    Sig2Int('PFAC'), 'Player Faction',
    Sig2Int('PIMC'), 'Pause During Menu Category (Immediate)',
    Sig2Int('PIVV'), 'Player Is Vampire Variable',
    Sig2Int('PIWV'), 'UNUSED03',
    Sig2Int('PLOC'), 'PersistAll Location',
    Sig2Int('PLST'), 'Default Pack List',
    Sig2Int('POEQ'), 'Potion Equip',
    Sig2Int('POPM'), 'Player''s Output Model (1st Person)',
    Sig2Int('PTEM'), 'Package template',
    Sig2Int('PTFR'), 'PotentialFollower Faction',
    Sig2Int('PTNP'), 'Pathing Test NPC',
    Sig2Int('PUSA'), 'Pickup Sound Armor',
    Sig2Int('PUSB'), 'Pickup Sound Book',
    Sig2Int('PUSG'), 'Pickup Sound Generic',
    Sig2Int('PUSI'), 'Pickup Sound Ingredient',
    Sig2Int('PUSW'), 'Pickup Sound Weapon',
    Sig2Int('PVFA'), 'Player Voice (Female)',
    Sig2Int('PVFC'), 'Player Voice (Female Child)',
    Sig2Int('PVMA'), 'Player Voice (Male)',
    Sig2Int('PVMC'), 'Player Voice (Male Child)',
    Sig2Int('PWFD'), 'Wait-For-Dialogue Package',
    Sig2Int('QMEA'), 'Quest Marker Enemy Above',
    Sig2Int('QMEB'), 'Quest Marker Enemy Below',
    Sig2Int('QMEN'), 'Quest Marker Enemy',
    Sig2Int('QMFO'), 'Quest Marker Follower',
    Sig2Int('QMLO'), 'Quest Marker Location',
    Sig2Int('RIVR'), 'Vampire Race',
    Sig2Int('RIVS'), 'Vampire Spells',
    Sig2Int('RIWR'), 'Unused',
    Sig2Int('RKIK'), 'Repair kit item keyword',
    Sig2Int('RUSG'), 'Keyword - Reusable SoulGem',
    Sig2Int('RVBT'), 'Reverb Type',
    Sig2Int('SALT'), 'Sitting Angle Limit',
    Sig2Int('SAT1'), 'Keyword: Scale Actor To 1.0',
    Sig2Int('SCSD'), 'Soul Captured Sound',
    Sig2Int('SFDC'), 'SFX To Fade In Dialogue Category',
    Sig2Int('SFSN'), 'Shout Fail Sound',
    Sig2Int('SKLK'), 'SkeletonKey',
    Sig2Int('SLDM'), 'Snow LOD Material',
    Sig2Int('SLHD'), 'Snow LOD Material (HD)',
    Sig2Int('SMLT'), 'Keyword: Smelter',
    Sig2Int('SMSC'), 'Stats Mute Category',
    Sig2Int('SPFK'), 'Keyword - Special Furniture',
    Sig2Int('SSSC'), 'Stats Music',
    Sig2Int('TANN'), 'Keyword: Tanning Rack',
    Sig2Int('TKAM'), 'Keyword - Type Ammo',
    Sig2Int('TKAR'), 'Keyword - Type Armor',
    Sig2Int('TKBK'), 'Keyword - Type Book',
    Sig2Int('TKGS'), 'UNUSED06',
    Sig2Int('TKIG'), 'Keyword - Type Ingredient',
    Sig2Int('TKKY'), 'Keyword - Type Key',
    Sig2Int('TKMS'), 'Keyword - Type Misc',
    Sig2Int('TKPT'), 'Keyword - Type Potion',
    Sig2Int('TKSG'), 'Keyword - Type SoulGem',
    Sig2Int('TKTS'), 'UNUSED07',
    Sig2Int('TKWP'), 'Keyword - Type Weapon',
    Sig2Int('TVGF'), 'Thieves'' Guild Faction',
    Sig2Int('UNDK'), 'Keyword - Undead',
    Sig2Int('URVT'), 'Underwater Reverb Type',
    Sig2Int('UWLS'), 'Underwater Loop Sound',
    Sig2Int('VAMP'), 'Keyword: Vampire',
    Sig2Int('VLOC'), 'Virtual Location',
    Sig2Int('VOEQ'), 'Voice Equip',
    Sig2Int('WASN'), 'Ward Absorb Sound',
    Sig2Int('WBSN'), 'Ward Break Sound',
    Sig2Int('WDSN'), 'Ward Deflect Sound',
    Sig2Int('WEML'), 'Weapon Material List',
    Sig2Int('WMDA'), 'Keyword - Weapon Material Daedric',
    Sig2Int('WMDH'), 'Keyword - Weapon Material DraugrHoned',
    Sig2Int('WMDR'), 'Keyword - Weapon Material Draugr',
    Sig2Int('WMDW'), 'Keyword - Weapon Material Dwarven',
    Sig2Int('WMEB'), 'Keyword - Weapon Material Ebony',
    Sig2Int('WMEL'), 'Keyword - Weapon Material Elven',
    Sig2Int('WMFA'), 'Keyword - Weapon Material Falmer',
    Sig2Int('WMFH'), 'Keyword - Weapon Material FalmerHoned',
    Sig2Int('WMGL'), 'Keyword - Weapon Material Glass',
    Sig2Int('WMIK'), 'Workshop misc item keyword',
    Sig2Int('WMIM'), 'Keyword - Weapon Material Imperial',
    Sig2Int('WMIR'), 'Keyword - Weapon Material Iron',
    Sig2Int('WMOR'), 'Keyword - Weapon Material Orcish',
    Sig2Int('WMST'), 'Keyword - Weapon Material Steel',
    Sig2Int('WMWE'), 'World Map Weather',
    Sig2Int('WMWO'), 'Keyword - Weapon Material Wood',
    Sig2Int('WPOK'), 'Workshop player ownership',
    Sig2Int('WTBA'), 'Keyword - WeaponTypeBoundArrow',
    Sig2Int('WWSP'), 'UNUSED01'
  ]);

  c := CombineVarRecs(a, b);

  if wbGameMode = gmFO4VR then begin
    b := MakeVarRecs([
      Sig2Int('TUSW'), 'TUSW',
      Sig2Int('HMVW'), 'HMVW'
    ]);

    c := CombineVarRecs(c, b);
  end;

  wbRecord(DOBJ, 'Default Object Manager', [
    wbEDID,
    wbArrayS(DNAM, 'Objects',
      wbStructSK([0], 'Object', [
        wbInteger('Use', itU32, wbEnum([], c), cpNormalIgnoreEmpty),
        wbFormID('Object ID', cpNormalIgnoreEmpty).IncludeFlag(dfNoReport)
      ]), 0, cpNormalIgnoreEmpty, True, wbDOBJObjectsAfterLoad
    )
  ]);

  wbRecord(LGTM, 'Lighting Template', [
    wbEDID,
    wbStruct(DATA, 'Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color Near'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade'),
      wbFloat('Fog Clip Distance'),
      wbFloat('Fog Power'),
      wbUnused(32),
      wbByteColors('Fog Color Far'),
      wbFloat('Fog Max'),
      wbFloat('Light Fade Begin'),
      wbFloat('Light Fade End'),
      wbUnused(4),
      wbFloat('Near Height Mid'),
      wbFloat('Near Height Range'),
      wbByteColors('Fog Color High Near'),
      wbByteColors('Fog Color High Far'),
      wbFloat('High Density Scale'),
      wbFloat('Fog Near Scale'),
      wbFloat('Fog Far Scale'),
      wbFloat('Fog High Near Scale'),
      wbFloat('Fog High Far Scale'),
      wbFloat('Far Height Mid'),
      wbFloat('Far Height Range'),
      wbUnknown
    ], cpNormal, True, nil, 15),
    wbAmbientColors(DALC),
    wbFormIDCk(WGDR, 'God Rays', [GDRY])
  ]);

  wbRecord(MUSC, 'Music Type', [
    wbEDID,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      {0x01} 'Plays One Selection',
      {0x02} 'Abrupt Transition',
      {0x04} 'Cycle Tracks',
      {0x08} 'Maintain Track Order',
      {0x10} 'Unknown 5',
      {0x20} 'Ducks Current Track',
      {0x40} 'Doesn''t Queue'
    ]), cpNormal, True),
    wbStruct(PNAM, 'Data', [
      wbInteger('Priority', itU16),
      wbInteger('Ducking (dB)', itU16, wbDiv(100))
    ]),
    wbFloat(WNAM, 'Fade Duration'),
    wbUnknown(VNAM),
    wbUnknown(UNAM),
    wbArray(TNAM, 'Music Tracks', wbFormIDCk('Track', [MUST, NULL]))
  ]);

  wbRecord(FSTP, 'Footstep', [
    wbEDID,
    wbFormIDCk(DATA, 'Impact Data Set', [IPDS, NULL], False, cpNormal, True),
    wbString(ANAM, 'Tag', 0, cpNormal, True)
  ]);

  wbRecord(FSTS, 'Footstep Set', [
    wbEDID,
    wbStruct(XCNT, 'Count', [
      wbInteger('Walking', itU32),
      wbInteger('Running', itU32),
      wbInteger('Sprinting', itU32),
      wbInteger('Sneaking', itU32),
      wbInteger('Swimming', itU32)
    ], cpNormal, True),
    wbArray(DATA, 'Footstep Sets', wbFormIDCk('Footstep', [FSTP]), 0, nil, nil, cpNormal, True)
  ]);

  wbSMNodeFlags := wbFlags([
    'Random',
    'Warn if no child quest started'
  ]);

  wbRecord(SMBN, 'Story Manager Branch Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent ', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Sibling ', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbCTDAsCount,
    wbInteger(DNAM, 'Flags', itU32, wbSMNodeFlags),
    wbInteger(XNAM, 'Max concurrent quests', itU32)
  ], False, nil, cpNormal, False, nil, wbConditionsAfterSet);

  wbRecord(SMQN, 'Story Manager Quest Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent ', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Sibling ', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbCTDAsCount,
    wbStruct(DNAM, 'Flags', [
      wbInteger('Node Flags', itU16, wbSMNodeFlags),
      wbInteger('Quest Flags', itU16, wbFlags([
        'Do all before repeating',
        'Shares event',
        'Num quests to run'
      ]))
    ]),
    wbInteger(XNAM, 'Max concurrent quests', itU32),
    wbInteger(MNAM, 'Num quests to run', itU32),
    wbFloat(HNAM, 'Hours until reset'),
    wbInteger(QNAM, 'Quest Count', itU32, nil, cpBenign, True),
    wbRArray('Quests', wbRStructSK([0], 'Quest', [
      wbFormIDCk(NNAM, 'Quest', [QUST]),
      wbInteger(FNAM, 'Flags', itU32, wbFlags(wbSparseFlags([]))),
      wbFloat(RNAM, 'Hours until reset', cpNormal, False, 1/24),
      wbInteger(UNAM, 'Priority', itU32)
    ], []), cpNormal, False, nil, wbSMQNQuestsAfterSet)
  ], False, nil, cpNormal, False, nil, wbConditionsAfterSet);

  wbRecord(SMEN, 'Story Manager Event Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent ', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Sibling ', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbCTDAsCount,
    wbInteger(DNAM, 'Flags', itU32, wbSMNodeFlags),
    wbInteger(XNAM, 'Max concurrent quests', itU32),
    wbInteger(ENAM, 'Type', itU32, wbQuestEventEnum)
  ], False, nil, cpNormal, False, nil, wbConditionsAfterSet)
    .SetSummaryKey([7]);

  wbRecord(DLBR, 'Dialog Branch', [
    wbEDID,
    wbFormIDCk(QNAM, 'Quest', [QUST], False, cpNormal, True),
    wbInteger(TNAM, 'Category', itU32, wbEnum([
        {0} 'Player',
        {1} 'Command'
    ])),
    wbInteger(DNAM, 'Flags', itU32, wbFlags([
      {0x01} 'Top-Level',
      {0x02} 'Blocking',
      {0x04} 'Exclusive'
    ])),
    wbFormIDCk(SNAM, 'Starting Topic', [DIAL], False, cpNormal, True)
  ]);

  wbRecord(MUST, 'Music Track', [
    wbEDID,
    wbInteger(CNAM, 'Track Type', itU32, wbEnum([], [
      Int64($23F678C3), 'Palette',
      Int64($6ED7E048), 'Single Track',
      Int64($A1A9C4D5), 'Silent Track'
    ]), cpNormal, True),
    wbFloat(FLTV, 'Duration'),
    wbFloat(DNAM, 'Fade-Out'),
    wbString(ANAM, 'Track FileName'),
    wbString(BNAM, 'Finale FileName'),
    wbStruct(LNAM, 'Loop Data', [
      wbFloat('Loop Begins'),
      wbFloat('Loop Ends'),
      wbInteger('Loop Count', itU32)
    ]),
    wbArray(FNAM, 'Cue Points', wbFloat('Point')).IncludeFlag(dfNotAlignable),
    wbCITC,
    wbCTDAsCount,
    wbArray(SNAM, 'Tracks', wbFormIDCk('Track', [MUST, NULL]))
  ], False, nil, cpNormal, False, nil, wbConditionsAfterSet);

  //still exists in game code, but not in Fallout76.esm
  wbRecord(DLVW, 'Dialog View', []);

  {wbRecord(WOOP, 'Word of Power', [
    wbEDID
  ]);}

  {wbRecord(SHOU, 'Shout', [
    wbEDID
  ]);}

  wbRecord(EQUP, 'Equip Type', [
    wbEDID,
    wbArray(PNAM, 'Slot Parents', wbFormIDCk('Parent', [EQUP])),
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      'Use All Parents',
      'Parents Optional',
      'Item Slot'
    ])),
    wbUnion(ANAM, '', wbFormVersionDecider(78), [
      wbInteger('Condition Actor Value', itS32, wbActorValueEnum),
      wbFormIDCk('Condition Actor Value', [AVIF, NULL, FFFF])
    ])
  ]);

  wbRecord(RELA, 'Relationship', [
    wbEDID,
    wbStruct(DATA, 'Data', [
      wbFormIDCk('Parent', [NPC_, NULL]),
      wbFormIDCk('Child', [NPC_, NULL]),
      wbInteger('Rank', itU8, wbEnum([
        'Lover',
        'Ally',
        'Confidant',
        'Friend',
        'Acquaintance',
        'Rival',
        'Foe',
        'Enemy',
        'Archnemesis'
      ])),
      wbByteArray('Unknown', 2),
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Unknown 1',
        {0x02} 'Unknown 2',
        {0x04} 'Unknown 3',
        {0x08} 'Unknown 4',
        {0x10} 'Unknown 5',
        {0x20} 'Unknown 6',
        {0x40} 'Unknown 7',
        {0x80} 'Secret'
      ])),
      wbFormIDCk('Association Type', [ASTP, NULL])
    ])
  ]);

  var wbStartScene :=
    wbRStruct('Start Scene', [
      wbFormIDCk(LCEP, 'Scene', [SCEN]),
      wbInteger(INTT, 'Phase Index', itU16),
      wbString(SSPN, 'Start Phase for Scene'),
      wbCITC,
      wbCTDAs
    ], []);

  var wbSceneDialogueAction :=
    wbRStruct('Dialogue', [
      wbFloat(DMAX, 'Looping - Max'),
      wbFloat(DMIN, 'Looping - Min'),
      wbStruct(CRIS, 'Camera', [
        wbFloat('FOV On Player Camera'),
        wbFloat('Rate Of Camera Change')
      ]),
      wbArray(HTID, 'Player Headtracking', wbInteger('Actor ID', itS32)),
      wbFormIDCk(VENC, 'Dialogue Subtype', [KYWD]),
      wbFormIDCk(PNAM, 'AnimArchType', [KYWD]),
      wbFormIDCk(ONAM, 'Audio Output Override', [SOPM])
    ], []);

  var wbScenePackageAction :=
    wbRStruct('Package', [
      wbRArray('Packages', wbFormIDCk(PNAM, 'Package', [PACK]))
    ], []);

  var wbSceneStartSceneActionAlt :=
    wbRStruct('Start Scene', [
      wbRArray('Scenes', wbStartScene),
      wbEmpty(HTID, 'End Scene Say Greeting')
    ], []);
  var wbSceneStartSceneAction :=
    wbRStruct('Start Scene', [
      wbFormIDCk(STSC, 'Start Scene Marker', [SCEN,NULL]),
      wbRArray('Scenes', wbStartScene),
      wbEmpty(HTID, 'End Scene Say Greeting')
    ], []);

  var wbSceneNPCResponseDialogue :=
    wbRStruct('NPC Response Dialogue', [
      wbFormIDCk(ONAM, 'Sound Output', [SOPM])
    ], []);

  var wbSceneRadioAction :=
    wbRStruct('Radio', [
      wbFormIDCk(HTID, 'Play Sound', [SNDR, NULL]),
      wbFormIDCk(DMAX, 'Sound Output', [SOPM, NULL]),
      wbFormIDCk(VENC, 'Dialogue Subtype', [KYWD])
    ], []);

  var wbSceneTimerAction :=
    wbRStruct('Timer',[
      wbFloat(SNAM, 'Timer - Max Seconds'),
      wbInteger(SCQS, 'Set Parent Quest Stage', itS16),
      wbFloat(TNAM, 'Timer - Min Seconds')
    ], []);

  var wbScenePlayerDialogueAction :=
    wbRStruct('Player Dialogue', [
      wbInteger(DTGT, 'Dialogue Target Actor', itS32),
      wbRArray('Dialogue Choices', wbRStruct('Dialogue Choice', [
        wbFormId(ESCE, 'Dialogue Exit'),
        wbFormId(ESCS, 'Choice')
      ], [])),
      wbRStruct('Prior Action Info', [
        wbInteger(ATTR, 'Action to Follow', itU32),
        wbEmpty(ACBS, 'Action Comes Before Start')
      ],[])
    ], []);

  var wbScenePlayerDialogueActionOld :=
    wbRStruct('Player Dialogue Responses', [
      wbFormIDCk(PTOP, 'Player Positive Response', [DIAL]),
      wbFormIDCk(NTOP, 'Player Negative Response', [DIAL]),
      wbFormIDCk(NETO, 'Player Neutral Response', [DIAL]),
      wbFormIDCk(QTOP, 'Player Question Response', [DIAL]),
      wbFormIDCk(VENC, 'Player Positive Dialogue Subtype', [KYWD]),
      wbFormIDCk(PLVD, 'Player Negative Dialogue Subtype', [KYWD]),
      wbFormIDCk(JOUT, 'Player Neutral Dialogue Subtype', [KYWD]),
      wbFormIDCk(DALC, 'Player Question Dialogue Subtype', [KYWD]),
      wbFormIDCk(NPOT, 'NPC Positive Response', [DIAL]),
      wbFormIDCk(NNGT, 'NPC Negative Response', [DIAL]),
      wbFormIDCk(NNUT, 'NPC Neutral Response', [DIAL]),
      wbFormIDCk(NQUT, 'NPC Question Response', [DIAL]),
      wbFormIDCk(NPOS, 'NPC Positive Dialogue Subtype', [KYWD]),
      wbFormIDCk(NNGS, 'NPC Negative Dialogue Subtype', [KYWD]),
      wbFormIDCk(NNUS, 'NPC Neutral Dialogue Subtype', [KYWD]),
      wbFormIDCk(NQUS, 'NPC Question Dialogue Subtype', [KYWD]),
      wbScenePlayerDialogueAction
    ], []).IncludeFlag(dfAllowAnyMember);

  var wbSceneRadioDialogueAction :=
    wbRStruct('Radio and Dialogue', [
      wbFormIDCk(DATA, 'Topic', [DIAL, NULL]),
      wbRUnion('',[
        wbSceneDialogueAction,
        wbSceneRadioAction
      ],[])
    ], []);

  wbRecord(SCEN, 'Scene', [
    wbEDID,
    wbVMADFragmentedSCEN,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      {0x00000001} 'Begin on Quest Start',
      {0x00000002} 'Stop on Quest End',
      {0x00000004} 'Show All Text',
      {0x00000008} 'Repeat Conditions While True',
      {0x00000010} 'Interruptible',
      {0x00000020} 'Unknown 5',
      {0x00000040} 'Prevent Player Exit Dialogue',
      {0x00000080} 'Unknown 7',
      {0x00000100} 'Unknown 8',
      {0x00000200} 'Unknown 9',
      {0x00000400} 'Unknown 10',
      {0x00000800} 'Disable Dialogue Camera',
      {0x00001000} 'No Follower Idle Chatter',
      {0x00002000} 'Unknown 13',
      {0x00004000} 'Unknown 14'
    ])),
    wbRArray('Phases',
      wbRStruct('Phase', [
        wbEmpty(HNAM, 'Marker Phase Start', cpNormal, True),
        wbString(NAM0, 'Name', 0, cpNormal, True),
        wbRStruct('Start Conditions', [wbCTDAs], []),
        wbEmpty(NEXT, 'Marker Start Conditions', cpNormal, True),
        wbRStruct('Completion Conditions', [wbCTDAs], []),
        wbEmpty(NEXT, 'Marker Completion Conditions', cpNormal, True),
        wbInteger(WNAM, 'Editor Width', itU32, nil, cpNormal, True, false, nil, nil, 350),
        wbUnknown(SPPI),
        wbUnknown(SPPT),
        wbUnknown(SPCT),// Might actually be SDCT but they messed up. Kept since it's used in previous versions
        wbUnknown(SDCT),
        wbInteger(FNAM, 'Flags', itU16, wbFlags([
          {0x0001} 'Start - WalkAway Phase',
          {0x0002} 'Don''t Run End Scripts on Scene Jump',
          {0x0004} 'Start - Inherit In Templated Scenes',
          {0x0008} 'Unknown 3'
        ])),
        wbStruct(SCQS, 'Set Parent Quest Stage', [
          wbInteger('On Start', itS16),
          wbInteger('On Completion', itS16)
        ]),
        wbEmpty(HNAM, 'Marker Phase End', cpNormal, True)
      ], [])
    ),
    wbRArray('Actors', wbRStruct('Actor', [
      wbInteger(ALID, 'Alias ID', itS32, nil, cpNormal, True),
      wbInteger(LNAM, 'Flags', itU32, wbFlags([
        'No Player Activation',
        'Optional',
        'Run Only Scene Packages',
        'No Command State'
      ]), cpNormal, True),
      wbInteger(DNAM, 'Behaviour Flags', itU32, wbFlags([
        'Death Pause',
        'Death End',
        'Combat Pause',
        'Combat End',
        'Dialogue Pause',
        'Dialogue End',
        'OBS_COM Pause',
        'OBS_COM End'
      ]), cpNormal, True, false, nil, nil, 26)
    ], [])),
    wbRArray('Actions', wbRStruct('Action', [
      wbInteger(ANAM, 'Type', itU16, wbEnum([
        {0} 'Dialogue',
        {1} 'Package',
        {2} 'Timer',
        {3} 'Player Dialogue',
        {4} 'Start Scene',
        {5} 'NPC Response Dialogue',
        {6} 'Radio'
      ]), cpNormal, True),
      wbString(NAM0, 'Name'),
      wbInteger(ALID, 'Alias ID', itS32),
      wbUnknown(ALSO),
      wbInteger(INAM, 'Index', itU32),
      wbInteger(FNAM, 'Flags', itU32, wbFlags([
        {0x00000001} 'Unknown 0',
        {0x00000002} 'Unknown 1',
        {0x00000004} 'Unknown 2',
        {0x00000008} 'Unknown 3',
        {0x00000010} 'Unknown 4',
        {0x00000020} 'Unknown 5',
        {0x00000040} 'Unknown 6',
        {0x00000080} 'Player Positive Use Dialogue Subtype / Hold Into Next Scene',
        {0x00000100} 'Player Negative Use Dialogue Subtype',
        {0x00000200} 'Player Neutral Use Dialogue Subtype',
        {0x00000400} 'Use Dialogue Subtype',
        {0x00000800} 'Player Question Use Dialogue Subtype',
        {0x00001000} 'Keep/Clear Target on Action End',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'Started Talking',
        {0x00008000} 'Face Target',
        {0x00010000} 'Looping',
        {0x00020000} 'Headtrack Player',
        {0x00040000} 'Unknown 18',
        {0x00080000} 'Ignore For Completion',
        {0x00100000} 'Unknown 20',
        {0x00200000} 'Camera Speaker Target',
        {0x00400000} 'Complete Face Target',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'NPC Positive Use Dialogue Subtype',
        {0x10000000} 'NPC Negative Use Dialogue Subtype',
        {0x20000000} 'NPC Neutral Use Dialogue Subtype',
        {0x40000000} 'NPC Question Use Dialogue Subtype'
      ])),
      wbInteger(SNAM, 'Start Phase', itU32),
      wbInteger(ENAM, 'End Phase', itU32),
      wbRUnion('Scene Action Data', [
        wbScenePackageAction,
        wbSceneTimerAction,
        wbScenePlayerDialogueAction,
        //wbScenePlayerDialogueActionOld,
        wbSceneStartSceneAction,
        wbSceneStartSceneActionAlt,
        wbSceneNPCResponseDialogue,
        wbSceneRadioDialogueAction
      ], []),
      wbEmpty(ANAM, 'End Marker', cpNormal, True)
    ], [])),
    wbFormIDCk(PNAM, 'Parent Quest', [QUST]),
    wbInteger(INAM, 'Last Action Index', itU32),
    wbUnknown(VNAM),
    wbFloat(CNAM, 'Camera Distance Override'),
    wbFloat(ACTV, 'Dialogue Distance Override'),
    wbFloat(CRIS, 'FOV Override'),
    wbKeywords,
    wbCTDAs,
    wbStruct(SCQS, 'Set Parent Quest Stage', [
      wbInteger('On Begin', itS16),
      wbInteger('On End', itS16)
    ]),
    wbString(NNAM, 'Notes'),
    wbFormIDCk(TNAM, 'Template Scene', [SCEN]),
    wbInteger(XNAM, 'Index', itU32),
    wbFormIDCk(ONAM, 'Sound Output', [SOPM])
  ]);

  wbRecord(ASTP, 'Association Type', [
    wbEDID,
    wbString(MPRT, 'Male Parent Title'),
    wbString(FPRT, 'Female Parent Title'),
    wbString(MCHT, 'Male Child Title'),
    wbString(FCHT, 'Female Child Title'),
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      'Family Association'
    ]))
  ]);

  wbSPED := wbUnion(SPED, 'Movement Data', wbFormVersionDecider([28, 60, 104]), [
 {0}wbStruct('', [
      wbStruct('Left', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Right', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Forward', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Back', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),

      wbStruct('Pitch, Roll, Yaw', [
        wbUnused,
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbUnused
      ]),

      wbStruct('Unused', [
        wbUnused,
        wbUnused,
        wbUnused,
        wbUnused
      ]),

      wbStruct('Unused', [
        wbUnused,
        wbUnused,
        wbUnused,
        wbUnused
      ]),

      wbUnused,
      wbUnused,
      wbUnused
    ], cpNormal, True),
 {1}wbStruct('', [
      wbStruct('Left', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Right', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Forward', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Back', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),

      wbStruct('Pitch, Roll, Yaw', [
        wbUnused,
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbUnused
      ]),

      wbStruct('Unused', [
        wbUnused,
        wbUnused,
        wbUnused,
        wbUnused
      ]),

      wbStruct('Unused', [
        wbUnused,
        wbUnused,
        wbUnused,
        wbUnused
      ]),

      wbFloatAngle,
      wbUnused,
      wbUnused
    ], cpNormal, True),
 {2}wbStruct('', [
      wbStruct('Left', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Right', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Forward', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),
      wbStruct('Back', [
        wbUnused,
        wbFloat('Walk'),
        wbFloat('Run'),
        wbUnused
      ]),

      wbStruct('Pitch', [
        wbUnused,
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbUnused
      ]),

      wbStruct('Roll', [
        wbUnused,
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbUnused
      ]),

      wbStruct('Yaw', [
        wbUnused,
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbUnused
      ]),

      wbFloatAngle,
      wbFloatAngle,
      wbFloatAngle
    ], cpNormal, True),
 {3}wbStruct('', [
      wbStruct('Left', [
        wbFloat('Standing'),
        wbFloat('Walk'),
        wbFloat('Run'),
        wbFloat('Sprint')
      ]),

      wbStruct('Right', [
        wbFloat('Standing'),
        wbFloat('Walk'),
        wbFloat('Run'),
        wbFloat('Sprint')
      ]),

      wbStruct('Forward', [
        wbFloat('Standing'),
        wbFloat('Walk'),
        wbFloat('Run'),
        wbFloat('Sprint')
      ]),

      wbStruct('Back', [
        wbFloat('Standing'),
        wbFloat('Walk'),
        wbFloat('Run'),
        wbFloat('Sprint')
      ]),

      wbStruct('Pitch', [
        wbFloatAngle('Standing'),
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbFloatAngle('Sprint')
      ]),

      wbStruct('Roll', [
        wbFloatAngle('Standing'),
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbFloatAngle('Sprint')
      ]),

      wbStruct('Yaw', [
        wbFloatAngle('Standing'),
        wbFloatAngle('Walk'),
        wbFloatAngle('Run'),
        wbFloatAngle('Sprint')
      ]),

      wbUnused,
      wbUnused,
      wbUnused
    ], cpNormal, True)
  ]);

  wbRecord(OTFT, 'Outfit', [
    wbEDID,
    wbArrayS(INAM, 'Items', wbFormIDCk('Item', [ARMO, LVLI]))
  ]);

  wbRecord(ARTO, 'Art Object',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbXALG,
    wbFTAGs,
    wbKeywords,
    wbGenericModel,
    wbInteger(DNAM, 'Art Type', itU32, wbEnum([
      'Magic Casting',
      'Magic Hit Effect',
      'Enchantment Effect'
    ]))
  ]);

  wbRecord(MATO, 'Material Object', [
    wbEDID,
    wbGenericModel,
    wbRArray('Property Data',
      wbByteArray(DNAM, 'Data', 0, cpIgnore, False, False, wbNeverShow)
    ),
    wbStruct(DATA, 'Directional Material Data', [
      wbFloat('Falloff Scale'),
      wbFloat('Falloff Bias'),
      wbFloat('Noise UV Scale'),
      wbFloat('Material UV Scale'),
      wbStruct('Projection Vector', [
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z')
      ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
      wbFloat('Normal Dampener'),
      wbFloatColors('Single Pass Color'),
      wbInteger('Flags', itU32, wbFlags(['Single Pass']))
    ], cpNormal, True, nil, 5)
  ]);

  wbRecord(MOVT, 'Movement Type', [
    wbEDID,
    wbString(MNAM, 'Name'),
    wbSPED,
    wbStruct(INAM, 'Anim Change Thresholds (unused)', [
      wbFloat('Directional', cpNormal, True, 180/Pi),
      wbFloat('Movement Speed'),
      wbFloat('Rotation Speed', cpNormal, True, 180/Pi)
    ]),
    wbFloat(JNAM, 'Float Height'),
    wbFloat(LNAM, 'Flight - Angle Gain')
  ]);

  wbRecord(SNDR, 'Sound Descriptor', [
    wbEDID,
    wbXALG,
    wbString(NNAM, 'Notes'),
    wbInteger(CNAM, 'Descriptor Type', itU32, wbEnum([], [
      Int64($1EEF540A), 'Standard',
      Int64($54651A43), 'Compound',
      Int64($ED157AE3), 'AutoWeapon'
    ])),
    wbFormIDCk(GNAM, 'Category', [SNCT]),
    wbFormIDCk(SNAM, 'Alternate Sound For', [SNDR]),
    wbSoundDescriptorSounds,
    wbFormIDCk(ONAM, 'Output Model', [SOPM]),
    wbCTDAs,
    wbStruct(LNAM, 'Values', [
      wbByteArray('Unknown', 1),
      wbInteger('Looping', itU8, wbEnum([], [
        $00, 'None',
        $08, 'Loop',
        $10, 'Envelope Fast',
        $20, 'Envelope Slow',
        $80, 'Unknown 128',
        $88, 'Unknown 136'
      ])),
      wbInteger('Sidechain', itU8),
      wbInteger('Rumble Send Value = (Small / 7) + ((Big / 7) * 16)', itU8)
    ]),
    wbUnion(BNAM, 'Data', wbSNDRDataDecider, [
      wbStruct('Values', [
        wbInteger('% Frequency Shift', itS8),
        wbInteger('% Frequency Variance', itS8),
        wbInteger('Priority', itU8),
        wbInteger('db Variance', itU8),
        wbInteger('Static Attenuation (db)', itU16, wbDiv(100))
      ]),
      wbFormIDCk('Base Descriptor', [SNDR])
    ]),
    wbInteger(HNAM, 'Unknown', itU32),
    wbInteger(INAM, 'Unknown', itU32),
    wbRArray('Descriptors', wbFormIDCk(DNAM, 'Descriptor', [SNDR])),
    wbInteger(ITMC, 'Count', itU32, nil, cpBenign),
    wbRArrayS('Rates of Fire',
      wbRStructSK([1], 'Sound', [
        wbEmpty(ITMS, 'Marker Start'),
        wbInteger(INTV, 'RoF (RPM)', itU32),
        wbRArray('Files', wbString(FNAM, 'File')),
        wbEmpty(ITME, 'Marker End')
      ], []),
      cpNormal, False, nil, wbSNDRRatesOfFireAfterSet
    ),
    wbUnknown(PNAM),
    wbUnknown(QNAM)
  ]);

  wbRecord(DUAL, 'Dual Cast Data', [
    wbEDID
  ]);

  wbRecord(SNCT, 'Sound Category', [
    wbEDID,
    wbFULL,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      {0x0000001} 'Mute When Submerged',
      {0x0000002} 'Should Appear on Menu',
      {0x0000004} 'Immune to Time Speedup',
      {0x0000008} 'Pause During Menus (Immed)',
      {0x0000010} 'Pause During Menus (Fade)',
      {0x0000020} 'Exclude from Player OPM Override',
      {0x0000040} 'Pause During Start Menu'
    ]), cpNormal, True),
    wbFormIDCk(PNAM, 'Parent Category', [SNCT]),
    wbFormIDCk(ONAM, 'Menu Slider Category', [SNCT]),
    wbInteger(VNAM, 'Static Volume Multiplier', itU16, wbDiv(65535)),
    wbInteger(UNAM, 'Default Menu Value', itU16, wbDiv(65535)),
    wbFloat(MNAM, 'Min Frequency Multiplier'),
    wbFloat(CNAM, 'Sidechain Target Multiplier')
  ]);

  wbRecord(SOPM, 'Sound Output Model', [
    wbEDID,
    wbStruct(NAM1, 'Data', [
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Attenuates With Distance',
        {0x02} 'Allows Rumble',
        {0x04} 'Applies Doppler',
        {0x08} 'Applies Distance Delay',
        {0x10} 'Player Output Model',
        {0x20} 'Try Play on Controller',
        {0x40} 'Causes Ducking',
        {0x80} 'Avoids Ducking'
      ])),
      wbByteArray('Unknown', 2),
      wbInteger('Reverb Send %', itU8)
    ]),
    wbInteger(MNAM, 'Type', itU32, wbEnum([
      'Uses HRTF',
      'Defined Speaker Output'
    ])),
    wbInteger(VNAM, 'Static Attenuation', itS16, wbDiv(100)),
    wbFloat(WNAM),
    wbStruct(ONAM, 'Output Values', [
      wbArray('Channels', wbStruct('', [
        wbInteger('FL', itU8),
        wbInteger('FR', itU8),
        wbInteger('C', itU8),
        wbInteger('LFE', itU8),
        wbInteger('RL', itU8),
        wbInteger('RR', itU8),
        wbInteger('SL', itU8),
        wbInteger('SR', itU8)
      ]), [
        'Channel 0',
        'Channel 1',
        'Channel 2? (unused)'
      ])
    ]),
    wbFormIDCk(ENAM, 'Effect', [AECH]),
    wbStruct(ATTN, 'Dynamic Attenuation Values', [
      wbFloat('Fade In Distance - Start'),
      wbFloat('Fade In Distance - End'),
      wbFloat('Fade Out Distance - Start'),
      wbFloat('Fade Out Distance - End'),
      wbStruct('Fade In Curve', [
        wbInteger('Value 1', itU8),
        wbInteger('Value 2', itU8),
        wbInteger('Value 3', itU8),
        wbInteger('Value 4', itU8)
      ]),
      wbStruct('Fade Out Curve', [
        wbInteger('Value 1', itU8),
        wbInteger('Value 2', itU8),
        wbInteger('Value 3', itU8),
        wbInteger('Value 4', itU8)
      ])
    ]),
    wbFormIDCk(ENAM, 'Effect Chain', [AECH])
  ]);

  wbRecord(COLL, 'Collision Layer', [
    wbEDID,
    wbDESCReq,
    wbInteger(BNAM, 'Index', itU32, nil, cpNormal, True),
    wbStruct(FNAM, 'Debug Color', [
      wbInteger('Red', itU8),
      wbInteger('Green', itU8),
      wbInteger('Blue', itU8),
      wbInteger('Unused', itU8)
    ], cpNormal, True).SetToStr(wbRGBAToStr).IncludeFlag(dfCollapsed, wbCollapseRGBA),
    wbInteger(GNAM, 'Flags', itU32, wbFlags([
      {0x00000001} 'Trigger Volume',
      {0x00000002} 'Sensor',
      {0x00000004} 'Navmesh Obstacle'
    ]), cpNormal, True),
    wbString(MNAM, 'Name', 0, cpNormal, True),
    wbInteger(INTV, 'Interactables Count', itU32, nil, cpNormal, True),
    wbArrayS(CNAM, 'Collides With', wbFormIDCk('Forms', [COLL]), 0, cpNormal, False)
  ]);

  wbRecord(CLFM, 'Color',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbFULL,
    // union decider doesn't work during copying since decision data FNAM is located after it
    // workaround using integer formatters
    wbInteger(CNAM, 'Color/Index', itU32, wbCLFMColorToStr, wbCLFMColorToInt),
    {wbUnion(CNAM, 'Value', wbCLFMColorDecider, [
      wbByteColors('Color'),
      wbFloat('Remapping Index')
    ]),}
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      'Playable',
      'Remapping Index',
      'Extended LUT'
    ]), cpNormal, True),
    wbCTDAs
  ]);

  wbRecord(REVB, 'Reverb Parameters', [
    wbEDID,
    wbStruct(DATA, 'Data', [
      wbInteger('Decay Time (ms)', itU16),
      wbInteger('HF Reference (Hz)', itU16),
      wbInteger('Room Filter', itS8),
      wbInteger('Room HF Filter', itS8),
      wbInteger('Reflections', itS8),
      wbInteger('Reverb Amp', itS8),
      wbInteger('Decay HF Ratio', itU8, wbDiv(100)),
      wbInteger('Reflect Delay (ms), scaled', itU8),
      wbInteger('Reverb Delay (ms)', itU8),
      wbInteger('Diffusion %', itU8),
      wbInteger('Density %', itU8),
      wbInteger('Unknown', itU8)
    ], cpNormal, True),
    wbInteger(ANAM, 'Reverb Class', itU32, wbReverbClassEnum, cpNormal, True)
  ]);

  wbRecord(GRAS, 'Grass',
    wbFlags(wbFlagsList([
      {0x00008000}  15, 'Unknown 15'
    ])), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbPHST,
    wbGenericModel,
    {
    wbStruct(DATA, '', [
      wbInteger('Density', itU8),
      wbInteger('Min Slope', itU8),
      wbInteger('Max Slope', itU8),
      wbByteArray('Unknown', 1),
      wbInteger('Units From Water', itU16),
      wbByteArray('Unknown', 2),
      wbInteger('Units From Water Type', itU32, wbEnum([
        'Above - At Least',
        'Above - At Most',
        'Below - At Least',
        'Below - At Most',
        'Either - At Least',
        'Either - At Most',
        'Either - At Most Above',
        'Either - At Most Below'
      ])),
      wbFloat('Position Range'),
      wbFloat('Height Range'),
      wbFloat('Color Range'),
      wbFloat('Wave Period'),
      wbInteger('Flags', itU8, wbFlags([
        'Vertex Lighting',
        'Uniform Scaling',
        'Fit to Slope'
      ])),
      wbByteArray('Unknown', 3)
    ], cpNormal, True),            }
    wbStruct(DNAM, '', [  //WIP - Names could be
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Height Range'),
      wbFloat('Color Range'),
      wbFloat('Wave Period'),
      wbByteArray('Unknown', 4),
      wbInteger('Density', itU8),
      wbInteger('Min Slope', itU8),
      wbInteger('Max Slope', itU8),
      wbInteger('Flags', itU8, wbFlags([
        'Vertex Lighting',
        'Uniform Scaling',
        'Fit to Slope',
        'Billboard',
        'LOD Land Blend'
      ])),
      wbFromVersion(137, wbFloat('Unknown')),
      wbFromVersion(175, wbFloat('Position Range'))
    ], cpNormal, True, nil, 7)
  ]);

  wbRecord(IDLE, 'Idle Animation',
    wbFlags(wbFlagsList([
      11, 'Photomode'
    ], True, True)), [
    wbEDID,
    wbXALG,
    wbCTDAs,
    wbString(DNAM, 'Behavior Graph'),
    wbString(ENAM, 'Animation Event'),
    wbArray(ANAM, 'Related Idle Animations', wbFormIDCk('Related Idle Animation', [AACT, IDLE, NULL]),
      ['Parent', 'Previous Sibling'], cpNormal, True),
    wbStruct(DATA, '', [
      wbStruct('Looping seconds (both 255 forever)', [
        wbInteger('Min', itU8),
        wbInteger('Max', itU8)
      ]),
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Parent',
        {0x02} 'Sequence',
        {0x04} 'No Attacking',
        {0x04} 'Blocking'
      ], True)),
      wbInteger('Animation Group Section', itU8{, wbIdleAnam}),
      wbInteger('Replay Delay', itU16)
    ], cpNormal, True),
    wbString(GNAM, 'Animation File'),
    wbFormIDCk(PNAM, 'Photomode Category Keyword', [KYWD]),
    wbFULL
  ]);

  wbRecord(INFO, 'Dialog response',
    wbFlags(wbFlagsList([
      {0x00000040}  6, 'Info Group',
      {0x00000080}  7, 'Exclude From Export',
      {0x00002000} 13, 'Actor Changed'
    ])), [
    wbEDID,
    wbVMADFragmentedINFO,
    wbStruct(ENAM, 'Response flags', [
    wbUnion('', wbFormVersionDecider(153), [
        wbInteger('Flags', itU16, wbFlags([
          {0x0001} 'Start Scene on End',
          {0x0002} 'Random',
          {0x0004} 'Say Once',
          {0x0008} 'Requires Player Activation',
          {0x0010} 'Info Refusal',
          {0x0020} 'Random End',
          {0x0040} 'End Running Scene',
          {0x0080} 'ForceGreet Hello',
          {0x0100} 'Player Address',
          {0x0200} 'Force Subtitle',
          {0x0400} 'Can Move While Greeting',
          {0x0800} 'No LIP File',
          {0x1000} 'Requires post-processing',
          {0x2000} 'Audio Output Override',
          {0x4000} 'Has Capture',
          {0x8000} 'Unknown 15'
        ])),
        wbInteger('Flags', itU32, wbFlags([
          {0x000001} 'Start Scene on End',
          {0x000002} 'Random',
          {0x000004} 'Say Once',
          {0x000008} 'Requires Player Activation',
          {0x000010} 'Info Refusal',
          {0x000020} 'Random End',
          {0x000040} 'End Running Scene',
          {0x000080} 'ForceGreet Hello',
          {0x000100} 'Player Address',
          {0x000200} 'Force Subtitle',
          {0x000400} 'Can Move While Greeting',
          {0x000800} 'No LIP File',
          {0x001000} 'Requires post-processing',
          {0x002000} 'Audio Output Override',
          {0x004000} 'Has Capture',
          {0x008000} 'Unknown 15',
          {0x010000} 'Unknown 16',
          {0x020000} 'Unknown 17',
          {0x040000} 'Unknown 18',
          {0x080000} 'Unknown 19',
          {0x100000} 'Unknown 20'
        ]))
      ]),
      wbInteger('Reset Hours', itU16, wbDiv(2730)),
      wbFromVersion(153,wbByteArray('Unknown',2))
    ]),
    wbFormIDCk(TPIC, 'Topic', [DIAL]),
    wbFormIDCkNoReach(PNAM, 'Previous INFO', [INFO, NULL], False, cpBenign),
    wbFormIDCk(DNAM, 'Shared INFO', [INFO]),
    wbFormIDCk(GNAM, 'INFO group', [INFO]),
    wbString(IOVR, 'Override FileName'),

    wbRArray('Responses', wbRStruct('Response', [
     wbStruct(TRDA, 'Response Data', [
        wbFromVersion(86, wbFormIDCk('Emotion', [KYWD, FFFF])),
        wbBelowVersion(119, wbByteArray('Unused', 4)),
        wbInteger('Response number', itU8),
        wbFormIDCk('Sound File', [SNDR, NULL]),
        wbByteArray('Unknown', 1),
        wbInteger('Interrupt Percentage', itU16),
        wbFromVersion(116, wbInteger('Camera Target Alias', itS32)),
        wbFromVersion(116, wbInteger('Camera Location Alias', itS32))
      ]),
      wbUnknown(TRAE),
      wbLStringKC(BNAM, 'Comment?'),
      wbLStringKC(NAM1, 'Response Text', 0, cpTranslate, True),
      wbString(NAM2, 'Script Notes', 0, cpNormal, True),
      wbString(NAM3, 'Edits', 0, cpNormal, True),
      wbString(NAM4, 'Alternate LIP Text', 0, cpNormal, True),
      wbFormIDCk(SNAM, 'Idle Animations: Speaker', [IDLE]),
      wbFormIDCk(LNAM, 'Idle Animations: Listener', [IDLE]),
      wbInteger(TNAM, 'Interrupt Percentage', itU16),
      wbByteArray(NAM9, 'Text Hash'),
      wbFormIDCk(SRAF, 'Camera Path', [CPTH]),
      wbEmpty(WZMD, 'Stop on Scene End')
    ], [])),

    wbCTDAs,
    wbLStringKC(RNAM, 'Prompt', 0, cpTranslate),
    wbFormIDCk(ANAM, 'Speaker', [NPC_, VTYP]),
    wbFormIDCk(TSCE, 'Start Scene', [SCEN]),
    wbInteger(ALFT, 'Unknown Int32 1', itU32),
    wbInteger(INTV, 'Unknown Int32 2', itU32),
    wbInteger(ALFA, 'Forced Alias', itS32),
    wbFormIDCk(ONAM, 'Audio Output Override', [SOPM]),
    wbInteger(GREE, 'Greet Distance', itU32),
    wbStruct(TIQS, 'Set Parent Quest Stage', [
      wbInteger('On Begin', itS16),
      wbInteger('On End', itS16)
    ]),
    wbString(NAM0, 'Start Scene Phase'),
    wbInteger(INCC, 'Challenge', itU32, wbEnum([
      {0} 'None',
      {1} 'Easy',
      {2} 'Medium',
      {3} 'Hard',
      {4} 'Always Succeeds',
      {5} 'Easy Repeatable',
      {6} 'Medium Repeatable',
      {7} 'Hard Repeatable'
    ])),
    wbFormIDCk(MODQ, 'Reset Global', [GLOB]),
    wbInteger(INAM, 'Subtitle Priority', itU32, wbEnum([
      'Low',
      'Normal',
      'Unknown 2',
      'Force'
    ])),
    wbUnknown(NAM8)
  ], False, wbINFOAddInfo, cpNormal, False, nil{wbINFOAfterLoad});

  wbRecord(INGR, 'Ingredient', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbFULL,
    wbKeywords,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbDEST,
    wbETYP,
    wbYNAM,
    wbZNAM,
    wbVCRY,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Ingredient Value', itS32),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'No auto-calculation',
        {0x00000002} 'Food item',
        {0x00000004} 'Unknown 3',
        {0x00000008} 'Unknown 4',
        {0x00000010} 'Unknown 5',
        {0x00000020} 'Unknown 6',
        {0x00000040} 'Unknown 7',
        {0x00000080} 'Unknown 8',
        {0x00000100} 'References Persist'
      ]))
    ], cpNormal, True),
    wbEffectsReq,
    wbMIID
  ]);

  wbRecord(KEYM, 'Key',
    wbFlags(wbFlagsList([
      {0x00000800} 11, 'Calc Value From Components',
      {0x00002000} 13, 'Pack-In Use Only'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbXALG,
    wbFULLReq,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbVCRY,
    wbDESC,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbUnknown(AQIC),
    wbDIQO
  ]);

  wbRecord(LAND, 'Landscape',
    wbFlags(wbFlagsList([
      {0x40000} 18, 'Compressed'
    ]), [18]), [
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      {0x001} 'Has Vertex Normals/Height Map',
      {0x002} 'Has Vertex Colours',
      {0x004} 'Has Layers',
      {0x008} 'Unknown 4',
      {0x010} 'Auto-Calc Normals',
      {0x020} 'Has Hi-Res Heightfield',
      {0x040} '',
      {0x080} '',
      {0x100} '',
      {0x200} '',
      {0x400} 'Ignored'
    ])),
    wbLandNormals,
    wbLandHeights,
    wbLandColors,
    wbLandLayers,
    wbRArray('Hi-Res Heightfield',
      wbByteArray(MPCD, 'Heightfield Data'))
  ]);

  wbRecord(LIGH, 'Light',
    wbFlags(wbFlagsList([
      {0x00010000} 16, 'Random Anim Start',
      {0x00020000} 17, 'Unknown 17',
      {0x00020000} 25, 'Obstacle',
      {0x00020000} 28, 'Portal-strict'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbGenericModel,
    wbKeywords,
    wbDEST,
    wbPRPS,
    wbFULL,
    wbICON,
    wbMICO,
    wbVCRY,
    wbStruct(DATA, '', [
      wbInteger('Time', itS32),
      wbInteger('Radius', itU32),
      wbByteColors('Color'),
      // Omnidirectional is the default type
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Unknown 0',
        {0x00000002} 'Can be Carried',
        {0x00000004} 'Unknown 2',
        {0x00000008} 'Flicker',
        {0x00000010} 'Unknown 4',
        {0x00000020} 'Off By Default',
        {0x00000040} 'Unknown 6',
        {0x00000080} 'Pulse',
        {0x00000100} 'Unknown 8',
        {0x00000200} 'Unknown 9',
        {0x00000400} 'Shadow Spotlight',
        {0x00000800} 'Shadow Hemisphere',
        {0x00001000} 'Shadow OmniDirectional',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'NonShadow Spotlight',
        {0x00008000} 'Non Specular',
        {0x00010000} 'Attenuation Only',
        {0x00020000} 'NonShadow Box',
        {0x00040000} 'Ignore Roughness',
        {0x00080000} 'No Rim Lighting',
        {0x00100000} 'Ambient Only',
        {0x00200000} 'Unknown 21', // only in [001C7F0C] <RandomSpot01GR>
        {0x00400000} 'Unknown 22',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25'
      ])),
      wbFloat('Falloff Exponent'),
      wbFloat('FOV'),
      wbFloat('Near Clip'),
      wbStruct('Flicker Effect', [
        wbFloat('Period'),
        wbFloat('Intensity Amplitude'),
        wbFloat('Movement Amplitude')
      ]),
      wbFloat('Constant'),
      wbFloat('Scalar'),
      wbFloat('Exponent'),
      wbFloat('God Rays - Near Clip'),
      wbInteger('Value', itU32),
      wbFloat('Weight'),
      wbUnknown
    ], cpNormal, True, nil, 10),
    wbFloat(LILS),  // float suggested by xDump - all current 76 records are 0.0f or 1.0f
    wbString(NAM0, 'Gobo'),
    wbFormIDCk(LNAM, 'Lens', [LENS]),
    wbFormIDCk(WGDR, 'God Rays', [GDRY]),
    wbFormIDCk(SNAM, 'Sound', [SNDR])
  ], False, nil, cpNormal, False, wbLIGHAfterLoad);

  wbRecord(LSCR, 'Load Screen',
    wbFlags(wbFlagsList([
      {0x00000400} 10, 'Displays In Main Menu',
      {0x00008000} 15, 'No Rotation'
    ])), [
    wbEDID,
    wbDESCReq,
    wbCTDAs,
    wbString(BNAM, 'Background Image'),
    wbFormIDCk(NNAM, 'Loading Screen NIF', [STAT, SCOL, NULL], False, cpNormal),
    wbFormIDCk(TNAM, 'Transform', [TRNS]),
    wbStruct(ONAM, 'Rotation', [
      wbInteger('Min', itS16),
      wbInteger('Max', itS16)
    ]),
    wbStruct(ZNAM, 'Zoom', [
      wbFloat('Min'),
      wbFloat('Max')
    ]),
    wbString(MOD2, 'Camera Path', 0, cpNormal, False),
    wbUnknown(PNAM),
    wbLStringKC(LSST, 'Loading Screen Text', 0, cpTranslate)
  ]);

  wbRecord(LTEX, 'Landscape Texture', [
    wbEDID,
    wbString(BNAM, 'Texture'),
    wbFormIDCk(TNAM, 'Unused', [TXST], False, cpIgnore, False),
    wbFormIDCk(MNAM, 'Material Type', [MATT, NULL], False, cpNormal, True),
    wbFormIDCk(ONAM, 'Ground Cover', [GCVR], False, cpNormal, False),
    wbStruct(HNAM, 'Havok Data', [
      wbInteger('Friction', itU8),
      wbInteger('Restitution', itU8)
    ], cpNormal, True),
    wbInteger(SNAM, 'Unused', itU8, nil, cpIgnore, False),
    wbRArray('Unused', wbFormIDCk(GNAM, 'Unused', [GRAS,REFR], False, cpIgnore).IncludeFlag(dfNoReport), cpIgnore)
  ]);

  var wbLeveledListEntryItem :=
    wbRStruct('Leveled List Entry', [
      wbUnion(LVLO, '', wbFormVersionDecider(174), [
        wbUnion('', wbFormVersionDecider(69), [
          wbStructExSK([0, 2], [3], 'Base Data', [
            wbInteger('Level', itU16),
            wbByteArray('Unused', 2, cpIgnore, false, wbNeverShow),
            wbFormIDCk('Reference', sigBaseObjects),
            wbInteger('Count', itU16),
            wbEmpty('Chance None'),
            wbByteArray('Unused', 2, cpIgnore, false, wbNeverShow)
          ])
          .SetSummaryKey([0, 3, 2])
          .SetSummaryMemberPrefixSuffix(0, '[', ']')
          .SetSummaryMemberPrefixSuffix(3, '', 'x')
          .SetSummaryMemberPrefixSuffix(2, '', '')
          .IncludeFlag(dfSummaryMembersNoName),
          wbStructExSK([0, 2], [3], 'Base Data', [
            wbInteger('Level', itU16),
            wbByteArray('Unused', 2, cpIgnore, false, wbNeverShow),
            wbFormIDCk('Reference', sigBaseObjects),
            wbInteger('Count', itU16),
            wbInteger('Chance None', itU8),
            wbByteArray('Unused', 1, cpIgnore, false, wbNeverShow)
          ])
          .SetSummaryKey([0, 3, 2, 4])
          .SetSummaryMemberPrefixSuffix(0, '[', ']')
          .SetSummaryMemberPrefixSuffix(3, '', 'x')
          .SetSummaryMemberPrefixSuffix(2, '', '')
          .SetSummaryMemberPrefixSuffix(4, '{Chance None = ', '%}')
          .IncludeFlag(dfSummaryMembersNoName)
        ]),
        wbFormIDCk('Reference', sigBaseObjects)
      ]),
      wbCOED,
      wbCTDAs,
      wbLVOV,
      wbLVOC,
      wbLVOT,
      wbLVIV,
      wbLVIT,
      wbLVIG,
      wbLVLV,
      wbLVOG,
      wbLVLT
    ], [])
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseLeveledItems);

  var wbLeveledListEntryNPC :=
    wbRStruct('Leveled List Entry', [
      wbUnion(LVLO, '', wbFormVersionDecider(174), [
        wbStructExSK([0, 2], [3], 'Base Data', [
          wbInteger('Level', itU16),
          wbByteArray('Unused', 2, cpIgnore, false, wbNeverShow),
          wbFormIDCk('Reference', [NPC_, LVLN]),
          wbInteger('Count', itS16),
          wbInteger('Chance None', itU8),
          wbByteArray('Unused', 1, cpIgnore, false, wbNeverShow)
        ])
        .SetSummaryKey([0, 3, 2, 4])
        .SetSummaryMemberPrefixSuffix(0, '[', ']')
        .SetSummaryMemberPrefixSuffix(3, '', 'x')
        .SetSummaryMemberPrefixSuffix(2, '', '')
        .SetSummaryMemberPrefixSuffix(4, '{Chance None = ', '%}')
        .IncludeFlag(dfSummaryMembersNoName),
        wbFormIDCk('Reference', [NPC_, LVLN])
      ]),
      wbCOED,
      wbCTDAs,
      wbLVOV,
      wbLVIV,
      wbLVLV,
      wbLVOG,
      wbLVLT
    ], [])
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseLeveledItems);

  var wbLeveledListEntryPackIn :=
    wbRStructExSK([0], [1], 'Leveled List Entry', [
      wbFormIDCk(LVLO, 'Reference', sigBaseObjects),
      //wbCOED,
      //wbCTDAs,
      wbLVOV,
      //wbLVOC,
      //wbLVOT,
      wbLVIV,
      //wbLVIG,
      wbLVLV
      //wbLVOG,
      //wbLVLT
    ], [])
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseLeveledItems);

  wbLVLNLVLFFlags := wbFlags([
      {0x00000001} 'Calculate from all levels <= player''s level',
      {0x00000002} 'Calculate for each item in count',
      {0x00000004} 'Calculate All', {Still picks just one for LVLN}
      {0x00000008} 'Unknown 3',
      {0x00000010} 'Unknown 4',
      {0x00000020} 'Unknown 5',
      {0x00000040} 'Use first object that matches all conditions',
      {0x00000080} 'Unknown 7',
      {0x00000100} 'Unknown 8' {Only workshop turrets}
    ]);

  wbLVLFFlags := wbFlags([
      {0x00000001} 'Calculate from all levels <= player''s level',
      {0x00000002} 'Calculate for each item in count',
      {0x00000004} 'Use All',
      {0x00000008} 'Unknown 3', { Use special formula in skyrim }
      {0x00000010} 'Is a reference spawn object',
      {0x00000020} 'Unknown 5',
      {0x00000040} 'Use first object that matches all conditions',
      {0x00000080} 'Unknown 7'
    ]);

  wbRecord(LVLN, 'Leveled NPC', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbLVLD,
    wbLStringKC(ONAM, 'Display Name', 0, cpTranslate),
    wbLVMV,
    wbLVCV,
    wbInteger(LVLM, 'Max Count', itU8), { Always 00 } {Unavailable}
    wbFormIDCk(LVLG, 'Use Global', [GLOB]),
    wbUnion(LVLF, 'Flags', wbFormVersionDecider(185), [
      wbInteger('', itU8, wbLVLNLVLFFlags),
      wbInteger('', itU16, wbLVLNLVLFFlags)
    ], cpNormal, True),
    wbCTDAs,
    wbLLCT,
    wbRArrayS('Leveled List Entries', wbLeveledListEntryNPC, cpNormal, False, nil, wbLVLOsAfterSet),
    wbArrayS(LLKC, 'Filter Keyword Chances',
      wbStructSK([0], 'Filter', [
        wbFormIDCk('Keyword', [KYWD]),
        wbInteger('Chance', itU32),
        wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
      ])
    ),
    wbGenericModel
  ], False, nil, cpNormal, False, wbLLEAfterLoad, wbLLEAfterSet);

  wbRecord(LVLI , 'Leveled Item',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbOBND(True),
    wbPTRN,
    wbOPDSs,
    wbDEFL,
    wbXALG,
    wbFTAGs,
    wbLVLD,
    wbLStringKC(ONAM, 'Override Name', 0, cpTranslate),
    wbLVMV,
    wbLVMG,
    wbLVMT,
    wbInteger(LVLM, 'Max Count', itU8),
    wbLVCV,
    wbLVLG,
    wbLVCT,
    wbUnion(LVLF, 'Flags', wbFormVersionDecider(185), [
      wbInteger('', itU8, wbLVLFFlags),
      wbInteger('', itU16, wbLVLFFlags)
    ], cpNormal, True),
    wbCTDAs,
    wbLLCT,
    wbRArrayS('Leveled List Entries', wbLeveledListEntryItem, cpNormal, False, nil, wbLVLOsAfterSet),
    wbArrayS(LLKC, 'Filter Keyword Chances',
      wbStructSK([0], 'Filter', [
        wbFormIDCk('Keyword', [KYWD]),
        wbInteger('Chance', itU32),
        wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
      ])
    ),
    wbFormIDCk(LVSG, 'Epic Loot Chance', [GLOB]),
    wbDIQO,
    wbByteRGBA(LIMC, 'Marker Color'),
    wbGenericModel
  ], True, nil, cpNormal, False, wbLLEAfterLoad, wbLLEAfterSet);

  wbRecord(LVLP, 'Leveled Pack In', [
    wbEDID,
    wbOBND(True),
    //wbOPDSs,
    //wbDEFL,
    //wbXALG,
    wbLVLD,
    wbLVMV,
    //wbLVMG,
    //wbLVMT,
    wbLVCV,
    //wbInteger(LVLM, 'Max Count', itU8), { Always 00 }
    //wbFormIDCk(LVLG, 'Use Global', [GLOB]),
    //wbLVCT,
    wbUnion(LVLF, 'Flags', wbFormVersionDecider(185), [
      wbInteger('', itU8, wbLVLFFlags),
      wbInteger('', itU16, wbLVLFFlags)
    ], cpNormal, True),
    //wbCTDAs,
    //wbFormIDCk(LVLG, 'Use Global', [GLOB]),
    wbLLCT,
    wbRArrayS('Leveled List Entries', wbLeveledListEntryPackIn, cpNormal, False, nil, wbLVLOsAfterSet),
    {
    wbArrayS(LLKC, 'Filter Keyword Chances',
      wbStructSK([0], 'Filter', [
        wbFormIDCk('Keyword', [KYWD]),
        wbInteger('Chance', itU32),
        wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
      ])
    ),
    }
    //wbFormIDCk(LVSG, 'Epic Loot Chance', [GLOB]),
    //wbDIQO,
    //wbUnknown(LIMC),
    wbGenericModel
    //wbLStringKC(ONAM, 'Override Name', 0, cpTranslate)
  ], False, nil, cpNormal, False, wbLLEAfterLoad, wbLLEAfterSet);

  wbRecord(LVSP, 'Leveled Spell', [
    wbEDID
  ]);

  wbMGEFType := wbInteger('Archetype', itU32, wbEnum([
    {00} 'Value Modifier',
    {01} 'Script',
    {02} 'Dispel',
    {03} 'Cure Disease',
    {04} 'Absorb',
    {05} 'Dual Value Modifier',
    {06} 'Calm',
    {07} 'Demoralize',
    {08} 'Frenzy',
    {09} 'Disarm',
    {10} 'Command Summoned',
    {11} 'Invisibility',
    {12} 'Light',
    {13} 'Darkness',
    {14} 'Nighteye',
    {15} 'Lock',
    {16} 'Open',
    {17} 'Bound Weapon',
    {18} 'Summon Creature',
    {19} 'Detect Life',
    {20} 'Player Fear',
    {21} 'Paralysis',
    {22} 'Reanimate',
    {23} 'Soul Trap',
    {24} 'Turn Undead',
    {25} 'Guide',
    {26} 'Damage Item',
    {27} 'Cure Paralysis',
    {28} 'Cure Addiction',
    {29} 'Cure Poison',
    {30} 'Concussion',
    {31} 'Stimpak',
    {32} 'Accumulate Magnitude',
    {33} 'Stagger',
    {34} 'Peak Value Modifier',
    {35} 'Cloak',
    {36} 'Unknown 36',
    {37} 'Slow Time',
    {38} 'Rally',
    {39} 'Enhance Weapon',
    {40} 'Spawn Hazard',
    {41} 'Etherealize',
    {42} 'Banish',
    {43} 'Spawn Scripted Ref',
    {44} 'Disguise',
    {45} 'Damage',
    {46} 'Immunity',
    {47} 'Permanent Reanimate',
    {48} 'Jetpack',
    {49} 'Chameleon',
    {50} 'Grow Flora',
    {51} 'Corpse Highlight',
    {52} 'Stunned'
  ]), cpNormal, False, nil, wbMGEFArchtypeAfterSet);

  wbMGEFData := wbRStruct('Magic Effect Data', [
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001}  'Hostile',
        {0x00000002}  'Recover',
        {0x00000004}  'Detrimental',
        {0x00000008}  'Snap to Navmesh',
        {0x00000010}  'No Hit Event',
        {0x00000020}  'Unknown 5',
        {0x00000040}  'Unknown 6',
        {0x00000080}  'Unknown 7',
        {0x00000100}  'Dispel with Keywords',
        {0x00000200}  'No Duration',
        {0x00000400}  'No Magnitude',
        {0x00000800}  'No Area',
        {0x00001000}  'FX Persist',
        {0x00002000}  'Unknown 13',
        {0x00004000}  'Gory Visuals',
        {0x00008000}  'Hide in UI',
        {0x00010000}  'Unknown 16',
        {0x00020000}  'No Recast',
        {0x00040000}  'Unknown 18',
        {0x00080000}  'Difficulty Affects Magnitude',
        {0x00100000}  'Difficulty Affects Duration',
        {0x00200000}  'Power Affects Magnitude',
        {0x00400000}  'Power Affects Duration',
        {0x00800000}  'Unknown 23',
        {0x01000000}  'Unknown 24',
        {0x02000000}  'Unknown 25',
        {0x04000000}  'Painless',
        {0x08000000}  'No Hit Effect',
        {0x10000000}  'No Death Dispel',
        {0x20000000}  'Unknown 29',
        {0x40000000}  'Unknown 30',
        {0x80000000}  'Unknown 31'
      ])),
      wbFromVersion(164, wbInteger('Flags 2', itU32, wbFlags([
        {0x00000001} { 0} 'Unknown 0',
        {0x00000002} { 1} 'Unknown 1',
        {0x00000004} { 2} 'Unknown 2',
        {0x00000008} { 3} 'Unknown 3',
        {0x00000010} { 4} 'Unknown 4',
        {0x00000020} { 4} 'Unknown 5',
        {0x00000040} { 6} 'Unknown 6',
        {0x00000080} { 7} 'Unknown 7',
        {0x00000100} { 8} 'Unknown 8',
        {0x00000200} { 9} 'Unknown 9',
        {0x00000400} {10} 'Unknown 10',
        {0x00000800} {11} 'Unknown 11',
        {0x00001000} {12} 'Unknown 12',
        {0x00002000} {13} 'Unknown 13',
        {0x00004000} {14} 'Unknown 14',
        {0x00008000} {15} 'Unknown 15',
        {0x00010000} {16} 'Unknown 16',
        {0x00020000} {17} 'Unknown 17',
        {0x00040000} {18} 'Unknown 18',
        {0x00080000} {19} 'Unknown 19',
        {0x00100000} {20} 'Unknown 20',
        {0x00200000} {21} 'Unknown 21',
        {0x00400000} {22} 'Unknown 22',
        {0x00800000} {23} 'Unknown 23',
        {0x01000000} {24} 'Unknown 24',
        {0x02000000} {25} 'Unknown 25',
        {0x04000000} {26} 'Unknown 26',
        {0x08000000} {27} 'Unknown 27',
        {0x10000000} {28} 'Unknown 28',
        {0x20000000} {29} 'Unknown 29',
        {0x40000000} {30} 'Unknown 30',
        {0x80000000} {31} 'Unknown 31'
      ]))),
      wbFloat('Base Cost'),
      wbUnion('Assoc. Item', wbMGEFAssocItemDecider, [
        wbFormIDCk('Unused', [NULL], False, cpIgnore),
        wbFormIDCk('Assoc. Item', [LIGH, NULL]),
        wbFormIDCk('Assoc. Item', [WEAP, ARMO, NULL]),
        wbFormIDCk('Assoc. Item', [NPC_, NULL]),
        wbFormIDCk('Assoc. Item', [HAZD, NULL]),
        wbFormIDCk('Assoc. Item', [SPEL, NULL]),
        wbFormIDCk('Assoc. Item', [RACE, NULL]),
        wbFormIDCk('Assoc. Item', [ENCH, NULL]),
        wbFormIDCk('Assoc. Item', [KYWD, NULL]),
        wbFormIDCk('Assoc. Item', [STHD, NULL]),
        wbFormIDCk('Assoc. Item', [DMGT, NULL]),
        wbFormIDCk('Assoc. Item', [EMOT, NULL]),
        wbFormIDCk('Assoc. Item', [FLST, NULL])
      ], cpNormal, False, nil, wbMGEFAssocItemAfterSet),
      wbByteArray('Magic Skill (unused)', 4),
      wbFormIDCk('Resist Value', [AVIF, NULL]),
      wbInteger('Counter Effect count', itU16),
      wbByteArray('Unused', 2),
      wbFormIDCk('Casting Light', [LIGH, NULL]),
      wbFloat('Taper Weight'),
      wbFormIDCk('Hit Shader', [EFSH, NULL]),
      wbFormIDCk('Enchant Shader', [EFSH, NULL]),
      wbInteger('Minimum Skill Level', itU32),
      wbStruct('Spellmaking', [
        wbInteger('Area', itU32),
        wbFloat('Casting Time')
      ]),
      wbFloat('Taper Curve'),
      wbFloat('Taper Duration'),
      wbFloat('Second AV Weight', cpNormal, False, nil, wbMGEFAV2WeightAfterSet),
      wbMGEFType,
      wbActorValue,
      wbFormIDCk('Projectile', [PROJ, NULL]),
      wbFormIDCk('Explosion', [EXPL, NULL]),
      wbInteger('Casting Type', itU32, wbCastEnum),
      wbInteger('Delivery', itU32, wbTargetEnum),
      wbActorValue, //wbInteger('Second Actor Value', itS32, wbActorValueEnum),
      wbFormIDCk('Casting Art', [ARTO, NULL]),
      wbFormIDCk('Hit Effect Art', [ARTO, NULL]),
      wbFormIDCk('Impact Data', [IPDS, NULL]),
      wbFloat('Skill Usage Multiplier'),
      wbStruct('Dual Casting', [
        wbFormIDCk('Art', [DUAL, NULL]),
        wbFloat('Scale')
      ]),
      wbFormIDCk('Enchant Art', [ARTO, NULL]),
      wbFormIDCk('Hit Visuals', [RFCT, NULL]),
      wbFormIDCk('Enchant Visuals', [RFCT, NULL]),
      wbFormIDCk('Equip Ability', [SPEL, NULL]),
      wbFormIDCk('Image Space Modifier', [IMAD, NULL]),
      wbFormIDCk('Perk to Apply', [PERK, NULL]),
      wbInteger('Casting Sound Level', itU32, wbSoundLevelEnum),
      wbStruct('Script Effect AI', [
        wbFloat('Score'),
        wbFloat('Delay Time')
      ]),
      wbUnknown
    ], cpNormal, True)
  ], []);

  wbRecord(MGEF, 'Magic Effect', [
    wbEDID,
    wbVMAD,
    wbFULL,
    wbMDOB,
    wbKeywords,
    wbMGEFData,
    wbRArrayS('Counter Effects', wbFormIDCk(ESCE, 'Effect', [MGEF]), cpNormal, False, nil, wbCounterEffectsAfterSet),
    wbMagicEffectSounds,
    wbLStringKC(DNAM, 'Magic Item Description', 0, cpTranslate),
    wbCTDAs
  ], False, nil, cpNormal, False, nil {wbMGEFAfterLoad}, wbMGEFAfterSet);

  wbRecord(MISC, 'Misc. Item',
    wbFlags(wbFlagsList([
      {0x00000800}  11, 'Calc From Components',
      {0x00002000}  13, 'Pack-In Use Only',
      {0x00008000}  15, 'Unknown 15'
    ])), [
    wbEDID,
    wbVMAD,
    wbFULL,
    wbOBND(True),
    wbOPDSs,
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbPHST,
    wbOPDSs,
    wbXALG,
    wbFULL,
    wbCUSD,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbFormIDCk(FIMD, 'Featured Item Message', [MESG]),
    wbVCRY,
    wbDESC,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbStructs(MCQP, 'Components', 'Component', [  // MCQP probably replaced CVPA
      wbFormIDCk('Component', sigBaseObjects),
      wbFormIDCk('Component Count Keyword', [KYWD])
    ]),
    wbUnknown(AQIC),
    wbFormIDCk(DIQO, 'Quest', [QUST]),
    // the amount of components is the same as size of CDIX, so should not be sorted probably
    wbStructs(CVPA, 'Components', 'Component', [
      wbFormIDCk('Component', sigBaseObjects), // CK allows only CMPO
      wbInteger('Count', itU32),
      wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
    ]),
    wbArray(CDIX, 'Component Display Indices', wbInteger('Display Index', itU8))
  ]);

  wbComponent :=
    wbStructSK([0], 'Component', [
      wbFormIDCkNoReach('Component', sigBaseObjects),
      wbInteger('Count', itU32),
      wbFromVersion(152, wbFormIDCk('Curve Table', [CURV, NULL]))
    ]).SetToStr(wbItemToStr).IncludeFlag(dfCollapsed, wbCollapseItems);

  wbComponents := wbArrayS(FVPA, 'Components', wbComponent);

  var wbLRNM := wbEnum([
        'Learned when picked up or by script',
        'Learned by scrapping',
        'Learned when ingested',
        'Known by default or when conditions are met',
        'Learned from plan'
      ]);

  wbRecord(COBJ, 'Constructible Object',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9',
      {0x00000800} 11, 'Unknown 11',
      {0x04000000} 26, 'Show as build variants'
    ])), [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbYNAM,
    wbZNAM,
    wbComponents,
    wbREPR,
    wbInteger(REPM, 'Repair Method', itU8),
    wbInteger(LRNM, 'Learn Method', itU8, wbLRNM),
    wbESCR,
    wbDESC,
    wbCTDAs,
    wbFormIDCk(CNAM, 'Created Object', sigBaseObjects),
    wbFormIDCkNoReach(BNAM, 'Workbench Keyword', [KYWD]),
    wbByteArray(NAM1, 'Unused', 0, cpIgnore, False, False, wbNeverShow), // co_PA_FusionCore01
    wbByteArray(NAM2, 'Unused', 0, cpIgnore, False, False, wbNeverShow), // co_PA_FusionCore01
    wbByteArray(NAM3, 'Unused', 0, cpIgnore, False, False, wbNeverShow), // co_PA_FusionCore01
    wbFormIDCk(ANAM, 'Menu Art Object', [ARTO]),
    wbFormIDCk(GNAM, 'Learn Recipe from', [ALCH,AMMO,ARMO,BOOK,MISC,WEAP]),
    wbFormIDCk(INAM, 'Camp Maximum', [GLOB]),
    wbFormIDCk(JNAM, 'Workshop Maximum', [GLOB]),
    wbFormIDCk(CVT0, 'Scrap Bonus', [CURV]),
    wbFormIDCk(LRNC, 'Learn Chance', [GLOB]),
    wbFormIDCk(RCND, 'Repair Condition', [CNDF]),
    wbArrayS(FNAM, 'Category', wbFormIDCk('Keyword', [KYWD])),
    wbLString(HNAM, 'Build Group Name'),
    wbStruct(DNAM, 'Data', [
      wbFloat('Unknown'),
      wbInteger('Created Object Count', itU16),
      wbInteger('Priority', itU16)
    ], cpNormal, False, nil, 1),
    wbFormIDCk(CIFK, 'Constructible Instantiation Filter Keyword', [KYWD]),
    wbUnknown(RECF), // only cares about 0x1 and 0x2 and 0x3
    wbStruct(INTV, 'Data', [
      wbInteger('Created Object Count', itU16),
      wbInteger('Priority', itU16)
    ], cpNormal, False, nil, 1)
  ]);

  wbRecord(NPC_, 'Non-Player Character (Actor)',
    wbFlags(wbFlagsList([
      {0x00000400} 10, 'Unknown 10',
      {0x00040000} 18, 'Compressed',
      {0x00080000} 19, 'Unknown 19',
      {0x20000000} 29, 'Bleedout Override'
    ]), [18]), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSTCP,
    wbSNTP,
    wbDEFL,
    wbPHST,
    wbXALG,
    wbFTAGs,
    wbStruct(ACBS, 'Configuration', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Female',
        {0x00000002} 'Essential',
        {0x00000004} 'Is CharGen Face Preset',
        {0x00000008} 'Respawn',
        {0x00000010} 'Auto-calc stats',
        {0x00000020} 'Unique',
        {0x00000040} 'Doesn''t affect stealth meter',
        {0x00000080} 'PC Level Mult',
        {0x00000100} 'Has Actor Sounds',
        {0x00000200} 'Calc For Each Template',
        {0x00000400} 'Unknown 10',
        {0x00000800} 'Protected',
        {0x00001000} 'Unknown 12',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'Summonable',
        {0x00008000} 'Unknown 15',
        {0x00010000} 'Doesn''t bleed',
        {0x00020000} 'Immobile',
        {0x00040000} 'Bleedout Override',
        {0x00080000} 'Opposite Gender Anims',
        {0x00100000} 'Simple Actor',
        {0x00200000} 'Unknown 21',
        {0x00400000} 'Unknown 22',
        {0x00800000} 'No Activation/Hellos',
        {0x01000000} 'Diffuse Alpha Test',
        {0x02000000} 'Ghosted To Teammates',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'Unknown 27',
        {0x10000000} 'Unknown 28',
        {0x20000000} 'Is Ghost',
        {0x40000000} 'Unknown 30',
        {0x80000000} 'Invulnerable'
      ])),
      wbInteger('XP Value Offset', itS16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbUnion('Level', wbNPCLevelDecider, [
        wbInteger('Level', itS16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
        wbInteger('Level Mult', itS16, wbDiv(1000), cpNormal, True, nil{wbActorTemplateUseStats})
      ], cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Calc min level', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Calc max level', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Disposition Base', itS16),
      wbInteger('Use Template Actors', itU16, wbFlags([
        {0x0001} 'Traits',
        {0x0002} 'Stats',
        {0x0004} 'Factions',
        {0x0008} 'Actor Effects',
        {0x0010} 'AI Data',
        {0x0020} 'AI Packages',
        {0x0040} 'Model/Animation',
        {0x0080} 'Base Data',
        {0x0100} 'Inventory',
        {0x0200} 'Script',
        {0x0400} 'Def Pack List',
        {0x0800} 'Attack Data',
        {0x1000} 'Keywords',
        {0x2000} 'Gender'
      ])),
      wbInteger('Bleedout Override', itU16),
      wbByteArray('Unknown', 2)
    ], cpNormal, True),
    wbRStruct('Actor Scaling Info', [
      wbInteger(AJLN, 'Level Min', itU32),
      wbInteger(AJLX, 'Level Max', itU32),
      wbInteger(AJLO, 'Level Offset', itU32),
      wbFormIDCk(AJNG, 'Level Min Global', [GLOB]),
      wbFormIDCk(AJXG, 'Level Max Global', [GLOB]),
      wbFormIDCk(AJOG, 'Level Offset Global', [GLOB])
    ],[]).IncludeFlag(dfAllowAnyMember),
    wbRArrayS('Factions', wbFaction, cpNormal, False, nil, nil, nil{wbActorTemplateUseFactions}),
    wbFormIDCk(INAM, 'Death item', [LVLI], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(VTCK, 'Voice', [VTYP], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(TPLT, 'Default Template', [LVLN, NPC_]),
    wbFormIDCk(LTPT, 'Legendary Template', [LVLN, NPC_]),
    wbFormIDCk(LTPC, 'Legendary Chance', [GLOB]),
    wbStruct(TPTA, 'Template Actors', [
      wbFormIDCk('Traits', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate0),
      wbFormIDCk('Stats', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate1),
      wbFormIDCk('Factions', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate2),
      wbFormIDCk('Spell List', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate3),
      wbFormIDCk('AI Data', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate4),
      wbFormIDCk('AI Packages', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate5),
      wbFormIDCk('Model/Animation', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate6),
      wbFormIDCk('Base Data', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate7),
      wbFormIDCk('Inventory', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate8),
      wbFormIDCk('Script', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate9),
      wbFormIDCk('Def Pack List', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate10),
      wbFormIDCk('Attack Data', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate11),
      wbFormIDCk('Keywords', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate12),
      wbFormIDCk('Gender', [LVLN, NPC_, NULL], False, cpNormal, False, wbActorTemplatesUseTemplate13)
    ], cpNormal, False, wbActorTemplatesUseTemplateAny, 13),
    wbFormIDCk(RNAM, 'Race', [RACE], False, cpNormal, True, nil{wbActorTemplateUseTraits}),
    wbSPCT,
    wbSPLOs,
    wbDEST,
    wbFormIDCk(WNAM, 'Skin', [ARMO], False, cpNormal, False),
    wbFormIDCk(ANAM, 'Far away model', [ARMO], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(ATKR, 'Attack Race', [RACE], False, cpNormal, False),
    wbRArrayS('Attacks', wbAttackData),
    wbFormIDCk(SPOR, 'Spectator Override Package List', [FLST]),
    wbFormIDCk(OCOR, 'Observe Dead Body Override Package List', [FLST]),
    wbFormIDCk(GWOR, 'Guard Warn Override Package List', [FLST]),
    wbFormIDCk(ECOR, 'Combat Override Package List', [FLST]),
    wbFormIDCk(FCPL, 'Follower Command Package List', [FLST]),
    wbFormIDCk(RCLR, 'Follower Elevator Package List', [FLST]),
    wbInteger(PRKZ, 'Perk Count', itU32, nil, cpBenign),
    wbRArrayS('Perks',
      wbStructSK(PRKR, [0], 'Perk', [
        wbFormIDCk('Perk', [PERK]),
        wbBelowVersion(181, wbInteger('Rank', itU8))
      ]), cpNormal, False, nil, wbPRKRsAfterSet
    ),
    wbPRPS,
    wbFTYP,
    wbNTRM,
    wbINRD,
    wbRStruct('Inventory', [
      wbCOCT,
      wbCNTOs
    ],[]),
    wbAIDT,
    wbRArray('Packages', wbFormIDCk(PKID, 'Package', [PACK]), cpNormal, False, nil{wbActorTemplateUseAIPackages}),
    wbKeywords,
    wbAPPR,
    wbObjectTemplate,
    wbFormIDCk(CNAM, 'Class', [CLAS], False, cpNormal),
    wbFULL,
    wbLStringKC(SHRT, 'Short Name', 0, cpTranslate),
    wbEmpty(DATA, 'Marker', cpNormal, True),
    wbStruct(DNAM, '', [
      wbInteger('Calculated Health', itU16),
      wbInteger('Calculated Action Points', itU16),
      wbInteger('Far Away Model Distance', itU16),
      wbInteger('Geared Up Weapons', itU8),
      wbByteArray('Unused', 1, cpIgnore)
    ]),
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY], False, cpNormal, False),
    wbFormIDCk(GNAM, 'Gift Filter', [FLST], False, cpNormal, False),
    wbFormIDCk(HCLF, 'Hair Color (old FormVersion only)', [CLFM], False, cpNormal, False), // in a few records, it's still up here
    wbByteArray(NAM5, 'Unused', 2, cpNormal),
    wbFloat(NAM6, 'Height Min', cpNormal, True),
    wbFloat(NAM4, 'Height Max'),
    wbStruct(MWGT, 'Weight (old FormVersion only)', [
       wbFloat('Thin'),
       wbFloat('Muscular'),
       wbFloat('Fat')
    ]),
    wbInteger(NAM8, 'Sound Level', itU32, wbSoundLevelEnum, cpNormal, True),
    wbRStruct('Actor Sounds', [
      wbInteger(CS2H, 'Count', itU32, nil, cpBenign, True),
      wbActorSounds,
      wbEmpty(CS2E, 'End Marker', cpNormal, True),
      wbByteArray(CS2F, 'Finalize', 1, cpNormal, True)
    ], []),
    wbFormIDCk(CSCR, 'Inherits Sounds From', [NPC_], False, cpNormal, False),
    wbFormIDCk(PFRN, 'Power Armor Stand', [FURN]),
    wbFormIDCk(DOFT, 'Default Outfit', [OTFT], False, cpNormal, False),
    wbFormIDCk(SOFT, 'Sleeping Outfit', [OTFT], False, cpNormal, False),
    wbFormIDCk(DPLT, 'Default Package List', [FLST], False, cpNormal, False),
    wbFormIDCk(CRIF, 'Crime Faction', [FACT], False, cpNormal, False),
    wbRArrayS('Head Parts', wbFormIDCk(PNAM, 'Head Part', [HDPT]), cpNormal, False, nil, nil, nil{wbActorTemplateUseModelAnimation}),
    wbFormIDCk(HCLF, 'Hair Color', [CLFM], False, cpNormal, False),
    wbFormIDCk(BCLF, 'Facial Hair Color', [CLFM], False, cpNormal, False),
    wbStruct(MWGT, 'Weight', [
       wbFloat('Thin'),
       wbFloat('Muscular'),
       wbFloat('Fat')
    ]),
    wbFormIDCk(FTST, 'Head Texture', [TXST], False, cpNormal, False),
    wbStruct(QNAM, 'Texture lighting', [
      wbFloat('Red', cpNormal, True, 255, 0),
      wbFloat('Green', cpNormal, True, 255, 0),
      wbFloat('Blue', cpNormal, True, 255, 0),
      wbFloat('Alpha')
    ]).SetToStr(wbRGBAToStr).IncludeFlag(dfCollapsed, wbCollapseRGBA),
    wbArray(MSDK, 'Morph Keys', wbInteger('Key', itU32, wbMorphValueToStr, wbHexStrToInt)),
    wbArray(MSDV, 'Morph Values', wbFloat('Value')),
    wbRArrayS('Face Tinting Layers',
      wbRStructSK([0], 'Layer', [
        wbStructSK(TETI, [1], 'Index', [
          wbInteger('Data Type', itU16, wbEnum(['', 'Value/Color', 'Value'])),
          wbInteger('Index', itU16, wbTintLayerToStr, wbStrToInt)
        ]),
        //wbByteArray(TEND, 'Data')
        wbStruct(TEND, 'Data', [
          wbInteger('Value', itU8, wbDiv(100)),
          wbByteColors('Color'),
          wbInteger('Template Color Index', itS16)
        ], cpNormal, True, nil, 1)
      ], [])
    ),
    wbStruct(MRSV, 'Body Morph Region Values', [
      wbFloat('Head'),
      wbFloat('Upper Torso'),
      wbFloat('Arms'),
      wbFloat('Lower Torso'),
      wbFloat('Legs')
    ]),
    // reported to cause issues when sorted
    wbRArrayS('Face Morphs',
      wbRStructSK([0], 'Face Morph', [
        wbInteger(FMRI, 'Index', itU32, wbFaceMorphToStr, wbHexStrToInt),
        //wbArray(FMRS, 'Unknown', wbFloat('Unknown'))
        wbStruct(FMRS, 'Values', [
          wbFloat('Position - X'),
          wbFloat('Position - Y'),
          wbFloat('Position - Z'),
          wbFloat('Rotation - X'),
          wbFloat('Rotation - Y'),
          wbFloat('Rotation - Z'),
          wbFloat('Scale'),
          wbByteArray('Unknown')
        ])
      ], [])
    ),
    wbFloat(FMIN, 'Facial Morph Intensity'),
    wbATTX,
    wbFormIDCk(CVT0, 'Health Curve Table', [CURV]),
    wbFormIDCk(CVT1, 'Tier Curve Table', [CURV]),
    wbFormIDCk(CVT2, 'XP Curve Table', [CURV]),
    wbFormIDCk(CVT3, 'EWS Actor Cost Curve Table', [CURV]),
    wbFormIDCk(UNWP, 'Unarmed Weapon', [WEAP])
  ], False, nil, cpNormal, False, wbNPCAfterLoad, wbNPCAfterSet);

  wbPKDTSpecificFlagsUnused := False;

  wbPKDTFlags := wbFlags([
    {0x00000001} 'Offers Services',
    {0x00000002} 'Unknown 1',
    {0x00000004} 'Must complete',
    {0x00000008} 'Maintain Speed at Goal',
    {0x00000010} 'Treat As Player Follower',
    {0x00000020} 'Unknown 5',
    {0x00000040} 'Unlock doors at package start',
    {0x00000080} 'Unlock doors at package end',
    {0x00000100} 'Request Block Idles',
    {0x00000200} 'Continue if PC Near',
    {0x00000400} 'Once per day',
    {0x00000800} 'Unknown 11',
    {0x00001000} 'Skip Load Into Furniture',
    {0x00002000} 'Preferred Speed',
    {0x00004000} 'Unknown 14',
    {0x00008000} 'Unknown 15',
    {0x00010000} 'Unknown 16',
    {0x00020000} 'Always Sneak',
    {0x00040000} 'Allow Swimming',
    {0x00080000} 'Unknown 19',
    {0x00100000} 'Ignore Combat',
    {0x00200000} 'Weapons Unequipped',
    {0x00400000} 'Unknown 22',
    {0x00800000} 'Weapon Drawn',
    {0x01000000} 'Unknown 24',
    {0x02000000} 'Unknown 25',
    {0x04000000} 'Unknown 26',
    {0x08000000} 'No Combat Alert',
    {0x10000000} 'Unknown 28',
    {0x20000000} 'Wear Sleep Outfit',
    {0x40000000} 'Unknown 30',
    {0x80000000} 'Unknown 31'
  ], [29]);

  wbPKDTInterruptFlags := wbFlags([
    {0x0001} 'Hellos to player',
    {0x0002} 'Random conversations',
    {0x0004} 'Observe combat behavior',
    {0x0008} 'Greet corpse behavior',
    {0x0010} 'Reaction to player actions',
    {0x0020} 'Friendly fire comments',
    {0x0040} 'Aggro Radius Behavior',
    {0x0080} 'Allow Idle Chatter',
    {0x0100} 'Unknown 8',
    {0x0200} 'World Interactions',
    {0x0400} 'Off For Important Scene',
    {0x0800} 'Unknown 11',
    {0x1000} 'Unknown 12',
    {0x2000} 'Unknown 13',
    {0x4000} 'Unknown 14',
    {0x8000} 'Unknown 15'
  ]);

  s := ExtractFilePath(ParamStr(0)) + wbAppName + 'MapMarkers.txt';
  if FileExists(s) then try
    wbMapMarkerEnum := wbEnum(TFile.ReadAllLines(s));
  except end;

  if not Assigned(wbMapMarkerEnum) then
    wbMapMarkerEnum := wbEnum([
      {000} 'CaveMarker',
      {001} 'CityMarker',
      {002} 'EncampmentMarker',
      {003} 'FactoryMarker',
      {004} 'MonumentMarker',
      {005} 'MetroMarker',
      {006} 'MilitaryBaseMarker',
      {007} 'LandmarkMarker',
      {008} 'OfficeMarker',
      {009} 'TownRuinsMarker',
      {010} 'UrbanRuinsMarker',
      {011} 'SancHillsMarker',
      {012} 'SettlementMarker',
      {013} 'SewerMarker',
      {014} 'VaultMarker',
      {015} 'AirfieldMarker',
      {016} 'CamperMarker',
      {017} 'CarMarker',
      {018} 'ChurchMarker',
      {019} 'CountryClubMarker',
      {020} 'CustomHouseMarker',
      {021} 'DriveInMarker',
      {022} 'ElevatedHighwayMarker',
      {023} 'FarmMarker',
      {024} 'FillingStationMarker',
      {025} 'ForestedMarker',
      {026} 'GoodneighborMarker',
      {027} 'GraveyardMarker',
      {028} 'HospitalMarker',
      {029} 'IndustrialDomeMarker',
      {030} 'IndustrialStacksMarker',
      {031} 'InstituteMarker',
      {032} 'IrishPrideMarker',
      {033} 'JunkyardMarker',
      {034} 'ObservatoryMarker',
      {035} 'PierMarker',
      {036} 'PondLakeMarker',
      {037} 'QuarryMarker',
      {038} 'RadioactiveAreaMarker',
      {039} 'RadioTowerMarker',
      {040} 'SalemMarker',
      {041} 'SchoolMarker',
      {042} 'ShipwreckMarker',
      {043} 'SubmarineMarker',
      {044} 'SwanPondMarker',
      {045} 'TownMarker',
      {046} 'BoSMarker',
      {047} 'BrownstoneMarker',
      {048} 'BunkerMarker',
      {049} 'CastleMarker',
      {050} 'SkyscraperMarker',
      {051} 'LibertaliaMarker',
      {052} 'LowRiseMarker',
      {053} 'MinutemenMarker',
      {054} 'PoliceStationMarker',
      {055} 'RailroadFactionMarker',
      {056} 'RailroadMarker',
      {057} 'SatelliteMarker',
      {058} 'SentinelMarker',
      {059} 'USSConstitutionMarker',
      {060} 'MechanistMarker',
      {061} 'RaiderSettlementMarker',
      {062} 'VassalSettlementMarker',
      {063} 'PotentialVassalSettlementMarker',
      {064} 'TrainStationMarker',
      {065} 'ElectricalSubstationMarker',
      {066} 'FissureMarker',
      {067} 'Vault63Marker',
      {068} 'Vault76Marker',
      {069} 'Vault94Marker',
      {070} 'Vault96Marker',
      {071} 'AmusementParkMarker',
      {072} 'MansionMarker',
      {073} 'ArktosPharmaMarker',
      {074} 'PowerPlantMarker',
      {075} 'SkiResortMarker',
      {076} 'AppalachianAntiquesMarker',
      {077} 'TeapotMarker',
      {078} 'AgriculturalCenterMarker',
      {079} 'WoodShackMarker',
      {080} 'HouseTrailerMarker',
      {081} 'LookoutTowerMarker',
      {082} 'OverlookMarker',
      {083} 'PumpkinMarker',
      {084} 'CowSpotsCreameryMarker',
      {085} 'CabinMarker',
      {086} 'TrainTrackMark',
      {087} 'CapitalBuildingMarker',
      {088} 'HighTechBuildingMarker',
      {089} 'LighthouseMarker',
      {090} 'ExcavatorMarker',
      {091} 'SpaceStationMarker',
      {092} 'PalaceWindingPathMarker',
      {093} 'TopOfTheWorldMarker',
      {094} 'DamMarker',
      {095} 'MonorailMarker',
      {096} 'WhitespringResort',
      {097} 'NukaColaQuantumPlant',
      {098} 'MysteriousGuidestoneMarker',
      {099} 'SkullRingMarker',
      {100} 'HammerWingMarker',
      {101} 'CultistMarker',
      {102} 'BloodEagleMarker',
      {103} 'Vault79Marker',
      {104} 'BoSBaseMarker',
      {105} 'LegendaryPurveyorMarker',
      {106} 'PublicWorkshopMarker', {ECKTODO: Look into when these changed and add checking for it. Used to be number 099}
      {107} 'DoorMarker', {Used to be number 100}
      {108} 'QuestMarker', {Used to be number 101}
      {109} 'DoorMarker', {Used to be number 102}
      {110} 'QuestMarker', {Used to be number 103}
      {111} 'PlayerSetMarker', {Used to be number 104}
      {112} 'PlayerLocMarker', {Used to be number 105}
      {113} 'PowerArmorLocMarker', {Used to be number 106}
      {114} 'TeammateMarker', {Used to be number 107}
      {115} 'LastCorpseMarker', {Used to be number 108}
      {116} 'YourCampMarker', {Used to be number 109}
      {117} 'YourQuickCampMarker',
      {118} 'InWorldEventMarker', {Used to be number 110}
      {119} 'InWorldPublicEventMarker',
      {120} 'MasterFissureMarker', {Used to be number 111}
      {121} 'NukedZoneMarker', {Used to be number 112}
      {122} 'WaypointMarker', {Used to be number 113}
      {123} 'StrangerCorpseMarker',
      {124} 'BabylonTextMarker',
      {125} 'BabylonSpawnMarkerPlayer',
      {126} 'BabylonSpawnMarkerTeam',
      {127} 'StormZoneMarker',
      {128} 'BabylonTerminalMarker',
      {129} 'NuclearBriefcaseMarker',
      {130} 'StormCenterMarker',
      {131} 'WarningZoneMarker',
      {132} 'EnemyPlayerMarker',
      {133} 'BabylonAIMarker',
      {134} 'TeamAliveMarker',
      {135} 'TeamDeadMarker',
      {136} 'TeammateDownMarker',
      {137} 'TeammateLeaderMarker'
    ]);

  wbBlendOperationEnum := wbEnum([
            'Default',
            'Multiply',
            'Overlay',
            'Soft Light',
            'Hard Light'
          ]);

  wbUNAMs := wbRArray('Data Inputs', wbRStruct('Data Input', [
    wbInteger(UNAM, 'Index', itS8),
    wbString(BNAM, 'Name'),
    wbInteger(PNAM, 'Flags', itU32, wbFlags([
      'Public'
    ]))
  ], []));

  wbRecord(PACK, 'Package', [
    wbEDID,
    wbVMADFragmentedPACK,
    wbFTAGs,

    wbStruct(PKDT, 'Pack Data', [
      wbInteger('General Flags', itU32, wbPKDTFlags),
      wbInteger('Type', itU8, wbEnum ([], [
         1, 'Follow',
         6, 'Travel',
        10, 'Flee Not Combat',
        14, 'Guard',
        15, 'Dialogue',
        18, 'Package',
        19, 'Package Template',
        20, 'Activate',
        21, 'Alarm',
        22, 'Flee',
        23, 'Trespass',
        24, 'Spectator',
        25, 'ReactToDead',
        26, 'GetUp from Chair/Bed',
        27, 'Do Nothing',
        28, 'In Game Dialogue',
        29, 'Surface',
        30, 'Search For Attacker',
        31, 'Avoid Player',
        32, 'Bump Reaction',
        33, 'React to Grenade or Mine',
        34, 'Steal Warning',
        35, 'Pickpocket Warning',
        36, 'Movement Blocked',
        37, 'Feed',
        38, 'Cannibal',
        39, 'Land',
        41, 'Mount Actor',
        42, 'Dismount Actor',
        43, 'Clear Mount Position',
        44, 'Clear Power Armor Exit'
      ])).SetDefaultEditValue('Package'),
      wbInteger('Interrupt Override', itU8, wbEnum([
        {0} 'Spectator: Threat Ref',
        {1} 'ObserveDead: Dead Ref',
        {2} 'GuardWarn: Guarded Ref',
        {3} 'GuardWarn: Trespasser Ref',
        {4} 'Combat: Target Ref',
        {5} 'Command Travel: Destination',
        {6} 'Command Activate: Target Ref',
        {7} 'Leave Workstation'
      ])),
      wbInteger('Preferred Speed', itU8, wbEnum([
        'Walk',
        'Jog',
        'Run',
        'Fast Walk'
      ])),
      wbByteArray('Unknown', 1),
      wbInteger('Interrupt Flags', itU16, wbPKDTInterruptFlags),
      wbInteger('Package Specific Flags', itU16)
    ], cpNormal, True),

    wbStruct(PSDT, 'Schedule', [
      wbInteger('Month', itS8),
      wbInteger('Day of week', itS8, wbEnum([
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Weekdays',
        'Weekends',
        'Monday, Wednesday, Friday',
        'Tuesday, Thursday'
      ], [
        -1, 'Any'
      ])),
      wbInteger('Date', itU8),
      wbInteger('Hour', itS8),
      wbInteger('Minute', itS8),
      wbByteArray('Unused', 3, cpIgnore),
      wbInteger('Duration (minutes)', itS32)
    ], cpNormal, True),

    wbCTDAs,

    wbRStruct('Idle Animations', [
      wbInteger(IDLF, 'Flags', itU8, wbEnum([], [
         0, 'Unknown',
         8, 'Random',
         9, 'Run in Sequence',
        12, 'Random, Do Once',
        13, 'Run in Sequence, Do Once'
      ]), cpNormal, True),
      wbInteger(IDLC, 'Animation Count', itU8, nil, cpBenign),
      wbFloat(IDLT, 'Idle Timer Setting', cpNormal, True),
      wbArray(IDLA, 'Animations', wbFormIDCk('Animation', [IDLE]), 0, nil, wbIDLAsAfterSet, cpNormal, True),
      wbByteArray(IDLB, 'Unknown', 4, cpIgnore)
    ], [], cpNormal, False, nil, False, nil {cannot be totally removed , wbAnimationsAfterSet}),

    wbFormIDCk(CNAM, 'Combat Style', [CSTY]),
    wbFormIDCk(QNAM, 'Owner Quest', [QUST]),
    wbStruct(PKCU, 'Counter', [
      wbInteger('Data Input Count', itU32),
      wbFormIDCk('Package Template', [PACK, NULL]),
      wbInteger('Version Counter (autoincremented)', itU32)
    ], cpNormal, True),

    wbRStruct('Package Data', [
      wbRArray('Data Input Values', wbRStruct('Value', [
        wbString(ANAM, 'Type').SetAfterSet(wbPackageDataInputValueTypeAfterSet),
        wbUnion(CNAM, 'Value', wbPubPackCNAMDecider, [
          {0} wbByteArray('Unknown'),
          {1} wbInteger('Bool', itU8, wbBoolEnum),
          {2} wbInteger('Integer', itU32),
          {3} wbFloat('Float')
        ]),
        wbUnknown(BNAM),
        wbPDTOs,
        wbPLDT,
        wbStruct(PTDA, 'Target', [wbTargetData]),
        wbUnknown(TPIC)
      ], [], cpNormal, False)),
      wbUNAMs
    ], []),
    wbByteArray(XNAM, 'Marker', 0, cpNormal, True),

    wbRStruct('Procedure Tree', [
      wbRArray('Branches', wbRStruct('Branch', [
        wbString(ANAM, 'Branch Type'),
        wbCITCReq,
        wbCTDAsCount,
        wbStruct(PRCB, 'Root', [
          wbInteger('Branch Count', itU32),
          wbInteger('Flags', itU32, wbFlags([
            'Repeat when Complete',
            'Unknown 1'
          ]))
        ]),
        wbString(PNAM, 'Procedure Type'),
        wbInteger(FNAM, 'Flags', itU32, wbFlags(['Success Completes Package'])),
        wbRArray('Data Input Indexes', wbInteger(PKC2, 'Index', itU8)),
        {>>> PFO2 should be single, there is only 1 PACK [00095F46] <PatrolAndHunt> in Skyrim.esm with 2xPFO2 <<<}
        wbRArray('Flags Override',
          wbStruct(PFO2, 'Data', [
            wbInteger('Set General Flags', itU32, wbPKDTFlags),
            wbInteger('Clear General Flags', itU32, wbPKDTFlags),
            wbInteger('Set Interrupt Flags', itU16, wbPKDTInterruptFlags),
            wbInteger('Clear Interrupt Flags', itU16, wbPKDTInterruptFlags),
            wbInteger('Preferred Speed Override', itU8, wbEnum([
              'Walk',
              'Jog',
              'Run',
              'Fast Walk'
            ])),
            wbByteArray('Unknown', 3)
          ])
        ),
        wbRArray('Flags Override',
          wbStruct(PFOR, 'Data', [
            wbInteger('Set General Flags', itU32, wbPKDTFlags),
            wbInteger('Clear General Flags', itU32, wbPKDTFlags),
            wbInteger('Set Interrupt Flags', itU16, wbPKDTInterruptFlags),
            wbInteger('Clear Interrupt Flags', itU16, wbPKDTInterruptFlags)
          ])
        )
      ], [], cpNormal, False, nil, False, nil, wbConditionsAfterSet))
    ], []),
    wbUNAMs,
    wbRStruct('OnBegin', [
      wbEmpty(POBA, 'OnBegin Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbPDTOs
    ], [], cpNormal, True),
    wbRStruct('OnEnd', [
      wbEmpty(POEA, 'OnEnd Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbPDTOs
    ], [], cpNormal, True),
    wbRStruct('OnChange', [
      wbEmpty(POCA, 'OnChange Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbPDTOs
    ], [], cpNormal, True)
  ], False, nil, cpNormal, False, nil {wbPACKAfterLoad});

  wbQUSTAliasFlagsActual := wbFlags([
    {0x00000000001} { 0} 'Reserves Location/Reference',
    {0x00000000002} { 1} 'Optional',
    {0x00000000004} { 2} 'Quest Object',
    {0x00000000008} { 3} 'Allow Reuse in Quest',
    {0x00000000010} { 4} 'Allow Dead',
    {0x00000000020} { 5} 'Matching Ref - In Loaded Area',
    {0x00000000040} { 6} 'Essential',
    {0x00000000080} { 7} 'Allow Disabled',
    {0x00000000100} { 8} 'Stores Text',
    {0x00000000200} { 9} 'Allow Reserved',
    {0x00000000400} {10} 'Protected',
    {0x00000000800} {11} 'Forced by Aliases',
    {0x00000001000} {12} 'Allow Destroyed',
    {0x00000002000} {13} 'Matching Ref - Closest',
    {0x00000004000} {14} 'Uses Stored Text',
    {0x00000008000} {15} 'Initially Disabled',
    {0x00000010000} {16} 'Allow Cleared',
    {0x00000020000} {17} 'Clear Names When Removed',
    {0x00000040000} {18} 'Matching Ref - Actors Only',
    {0x00000080000} {19} 'Create Ref - Temp',
    {0x00000100000} {20} 'External Alias - Linked',
    {0x00000200000} {21} 'No Pickpocket',
    {0x00000400000} {22} 'Can Apply Data To Non-Aliased Refs',
    {0x00000800000} {23} 'Is Companion',
    {0x00001000000} {24} 'Optional All Scenes',
    {0x00002000000} {25} 'Unknown 25',
    {0x00004000000} {26} 'Unknown 26',
    {0x00008000000} {27} 'Unknown 27',
    {0x00010000000} {28} 'Unknown 28',
    {0x00020000000} {29} 'Unknown 29',
    {0x00040000000} {30} 'Unknown 30',
    {0x00080000000} {31} 'Unknown 31',
    {0x00100000000} {32} 'Unknown 32',
    {0x00200000000} {33} 'Unknown 33',
    {0x00400000000} {34} 'Unknown 34',
    {0x00800000000} {35} 'Unknown 35',
    {0x01000000000} {36} 'Unknown 36',
    {0x02000000000} {37} 'Unknown 37',
    {0x04000000000} {38} 'Unknown 38',
    {0x08000000000} {39} 'Unknown 39',
    {0x10000000000} {40} 'Unknown 40',
    {0x20000000000} {41} 'Unknown 41'
  ]);

  wbQUSTAliasFlags :=
    wbUnion(FNAM, 'Flags', wbRecordSizeDecider(8), [
      wbInteger('Flags', itU32, wbQUSTAliasFlagsActual),
      wbInteger('Flags', itU64, wbQUSTAliasFlagsActual)
    ], cpNormal, True);

  wbRecord(QUST, 'Quest',
    wbFlags(wbFlagsList([
      {0x00004000} 14, 'Partial Form'
    ]), [14]), [
    wbEDID,
    wbDURL,
    wbVMADFragmentedQUST,
    wbFULL,
    wbDESC,
    wbPRPS,
    wbRUnion('General', [
      wbStruct(DATA, 'General', [  //0xE4
        wbInteger('Flags', itU32, wbFlags([
          {0x00000001} 'Start Game Enabled',
          {0x00000002} 'Completed',
          {0x00000004} 'Add Idle Topic To Hello',
          {0x00000008} 'Allow repeated stages',
          {0x00000010} 'Starts Enabled',
          {0x00000020} 'Displayed In HUD',
          {0x00000040} 'Failed',
          {0x00000080} 'Stage Wait',
          {0x00000100} 'Run Once',
          {0x00000200} 'Exclude from dialogue export',
          {0x00000400} 'Warn on alias fill failure',
          {0x00000800} 'Active',
          {0x00001000} 'Repeats Conditions',
          {0x00002000} 'Keep Instance',
          {0x00004000} 'Want Dormant',
          {0x00008000} 'Has Dialogue Data',
          {0x00010000} 'Instanced Quest',
          {0x00020000} 'Unknown 17',
          {0x00040000} 'Unknown 18',
          {0x00080000} 'Holotape Container Quest',
          {0x00100000} 'Unknown 20',
          {0x00200000} 'Unknown 21',
          {0x00400000} 'Unknown 22',
          {0x00800000} 'Unknown 23',
          {0x01000000} 'Unknown 24',
          {0x02000000} 'Uses Default Quest Expire Timer',
          {0x04000000} 'Unknown 26',
          {0x08000000} 'Event Quest',
          {0x10000000} 'Raid Quest',
          {0x20000000} 'Unknown 29',
          {0x40000000} 'Unknown 30',
          {0x80000000} 'Unknown 31'
        ])),
        wbInteger('Priority',itU8), //0xE8
        wbByteArray('Unused',3),
        wbFloat('Delay Time'), //0xE0
        wbInteger('Quest Type',itU8, wbEnum([
          'None',
          'Primary',
          'Secondary',
          'Side Quest',
          'Server',
          'Daily',
          'Public Event',
          'Miscellaneous',
          'Event',
          'Daily Ops',
          'Expedition',
          'Module',
          'Caravan'
        ])),  //0xE9
        wbByteArray('Unused',3)
      ]),
      wbStruct(DNAM, 'General', [
        wbInteger('Flags', itU16, wbFlags([
          {0x0001} 'Start Game Enabled',
          {0x0002} 'Unknown 2',
          {0x0004} 'Add Idle Topic To Hello',
          {0x0008} 'Allow repeated stages',
          {0x0010} 'Unknown 5',
          {0x0020} 'Unknown 6',
          {0x0040} 'Unknown 7',
          {0x0080} 'Unknown 8',
          {0x0100} 'Run Once',
          {0x0200} 'Exclude from dialogue export',
          {0x0400} 'Warn on alias fill failure',
          {0x0800} 'Unknown 12',
          {0x1000} 'Unknown 13'
        ])),
        wbInteger('Priority', itU8),
        wbByteArray('Unused', 1),
        wbFloat('Delay Time'),
        wbInteger('Quest Type',itU8, wbEnum([
          'None',
          'Primary',
          'Secondary',
          'Side Quest',
          'Server',
          'Daily',
          'Public Event',
          'Miscellaneous',
          'Event',
          'Daily Ops',
          'Expedition',
          'Module',
          'Caravan'
        ])),  //0xE9
        wbByteArray('Unused',3)
      ])
    ], []),
    wbInteger(ENAM, 'Event', itU32, wbQuestEventEnum),
    wbFormIDCk(LNAM, 'Location', [LCTN]),
    wbFormIDCk(XNAM, 'Quest Completion XP', [GLOB]),
    wbUnknown(QMCI),
    wbFormIDCk(QTLM, 'Quest Timer Length Max', [GLOB]),
    wbFormIDCk(QETL, 'Quest Expire Timer Length', [GLOB, NULL]),
    wbFormIDCk(QSSK, 'Start Keyword', [KYWD]),
    wbFormIDCk(QSLC, 'Quest Start Location', [LCTN]),
    wbFormIDCk(QECV, 'Enable Keyword', [KYWD]),
    wbUnknown(QSDD),
    wbInteger(QETE, 'Quest Event Type', itU8, wbEnum([
      'Co-op',
      'Versus',
      'Free For All',
      'Defense',
      'Waves',
      'Boss',
      'Special',
      'Collection',
      'Escort',
      'Multi'
    ])),
    wbRArray('Text Display Globals', wbFormIDCk(QTGL, 'Global', [GLOB])),
    wbRArray('Quest Variables', wbString(QTVR, 'Quest Variable')),
    wbFLTR,
    wbRStruct('Quest Dialogue Conditions', [wbCTDAs], [], cpNormal, False),
    wbRStruct('More Conditions', [
      wbEmpty(NEXT, 'Marker', cpNormal, True),
      wbCTDAs,
      wbRStruct('More Conditions', [
        wbEmpty(NEXT, 'Marker', cpNormal, True),
        wbCTDAs,
        wbRStruct('More Conditions', [
          wbEmpty(NEXT, 'Marker', cpNormal, True),
          wbCTDAs
        ], [])
      ], [])
    ], []),

    wbRArrayS('Stages', wbRStructSK([0], 'Stage', [
      wbStructSK(INDX, [0], 'Stage Index', [
        wbInteger('Stage Index', itU16),
        wbInteger('Flags', itU8, wbFlags([
          {0x01} 'Unknown 1',
          {0x02} 'Run On Start',
          {0x04} 'Run On Stop',
          {0x08} 'Keep Instance Data From Here On',
          {0x10} 'Unknown 4',
          {0x20} 'Unknown 5',
          {0x40} 'Unknown 6'
        ])),
        wbInteger('Unknown', itU8)
      ]),
      wbRArray('Log Entries', wbRStruct('Log Entry', [
        wbInteger(QSDT, 'Stage Flags', itU8, wbFlags([
          {0x01} 'Complete Quest',
          {0x02} 'Fail Quest'
        ])),
        wbCTDAs,
        wbString(NAM2, 'Note'),
        wbString(SCFC, 'Comments'),
        wbLStringKC(CNAM, 'Log Entry', 0, cpTranslate),
        wbFormIDCk(NAM0, 'Next Quest', [QUST]),
        wbRArray('Rewards', wbReward),
        wbFormID(QRWD, 'Quest Reward'),
        wbFormID(QUIM, 'Message')
      ], []))
    ], [])),
    wbRArray('Objectives', wbRStruct('Objective', [
      wbInteger(QOBJ, 'Objective Index', itU16),
      wbInteger(FNAM, 'Flags', itU32, wbFlags([
        {0x01} 'ORed With Previous',
        {0x02} 'No Stats Tracking',
        {0x04} 'Unknown 3',
        {0x08} 'Uses Timer'
      ])),
      wbFormIDCk(QOTM, 'Quest Objective Timer', [GLOB]),
      wbInteger(SNAM, 'Stage to set', itU16),
      wbLString(NAM1, 'Quest Notes'),
      wbString(SCCM, 'Comments'),
      wbLStringKC(PBLT, 'Unknown PBLT', 0, cpTranslate),
      wbLStringKC(PBRT, 'Unknown PBRT', 0, cpTranslate),
      wbLStringKC(NNAM, 'Display Text', 0, cpTranslate, True),
      wbRArray('Targets', wbRStruct('Target', [
        wbStruct(QSTA, 'Target', [
          wbInteger('Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbFromVersion(158, wbInteger('Target Flags', itU8, wbFlags([
            {0x0001} 'Compass Marker Ignores Locks',
            {0x0002} 'Hostile',
            {0x0004} 'Use Straight Line Pathing'
          ]))),
          wbFromVersion(158, wbInteger('Area Flags', itU8, wbFlags([
            {0x0001} 'Use Global',
            {0x0002} 'Unknown 1'
          ]))),
          wbFromVersion(82, wbFormIDCk('Keyword', [KYWD, NULL])),
          wbFromVersion(151, wbByteArray('Area',4))
        ]),
        wbCTDAs
      ], []))
    ], [])),

    wbInteger(ANAM, 'Next Alias ID', itU32),

    wbRArray('Aliases',
      wbRUnion('Alias', [

        // Reference Alias
        wbRStructSK([0], 'Alias', [
          wbInteger(ALST, 'Reference Alias ID', itU32, nil, cpNormal, True),
          wbString(ALID, 'Alias Name', 0, cpNormal, True),
          wbFloat(ESAV, 'Unknown'),
          wbFloat(ESDA, 'Unknown'),
          wbFloat(ESRV, 'Unknown'),
          wbFloat(ESRP, 'Unknown'),
          wbQUSTAliasFlags,
          wbInteger(ALFI, 'Force Into Alias When Filled', itS32, wbQuestAliasToStr, wbStrToAlias),
          //wbFormIDCk(ALFL, 'Specific Location', [LCTN]),
          wbFormIDCk(ALFR, 'Forced Reference', [ACHR, REFR, PLYR, NULL]),
          wbFormIDCk(ALUA, 'Unique Actor', [NPC_]),
          wbRStruct('Location Alias Reference', [
            wbInteger(ALFA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbFormIDCk(KNAM, 'Keyword', [KYWD]),
            wbFormIDCk(ALRT, 'Ref Type', [LCRT])
          ], []),
          wbRStruct('External Alias Reference', [
            wbFormIDCk(ALEQ, 'Quest', [QUST]),
            wbInteger(ALEA, 'Alias', itS32, wbQuestExternalAliasToStr, wbStrToAlias)
          ], []),
          wbRStruct('Create Reference to Object', [
            wbFormIDCk(ALCO, 'Object', sigBaseObjects),
            wbStruct(ALCA, 'Alias', [
              wbInteger('Alias', itS16, wbQuestAliasToStr, wbStrToAlias),
              wbInteger('Create', itU16, wbEnum([] ,[
                $0000, 'At',
                $8000, 'In'
              ]))
            ]),
            wbInteger(ALCL, 'Level', itU32, wbEnum([
              'Easy',
              'Medium',
              'Hard',
              'Very Hard',
              'None'
            ]))
          ], []),
          wbRStruct('Find Matching Reference Near Alias', [
            wbInteger(ALNA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbInteger(ALNT, 'Type', itU32, wbEnum([
              'Linked From',
              'Linked Ref'
            ]))
          ], []),
          wbRStruct('Find Matching Reference From Event', [
            wbInteger(ALFE, 'From Event', itU32, wbQuestEventEnum),
            wbInteger(ALFD, 'Event Data', itU32, wbEventMemberEnum)
          ], []),
          wbInteger(ALCC, 'Closest To Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbCTDAs,
          wbKeywords,
          wbCOCT,
          wbCNTOs,
          wbFormIDCk(SPOR, 'Spectator override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(OCOR, 'Observe dead body override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(GWOR, 'Guard warn override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(ECOR, 'Combat override package list', [FLST], False, cpNormal, False),
          wbArray(ALLA, 'Linked Aliases', wbStruct('Linked Alias', [
            wbFormIDCk('Keyword', [KYWD, NULL]),
            wbInteger('Alias', itS32, wbQuestAliasToStr, wbStrToAlias)
          ])),
          wbFormIDCk(ALDN, 'Display Name', [MESG]),
          wbFormIDCk(ALFV, 'Forced Voice', [VTYP]),
          wbFormIDCk(ALDI, 'Death Item', [LVLI]),
          wbRArrayS('Alias Spells', wbFormIDCk(ALSP, 'Spell', [SPEL])),
          wbRArrayS('Alias Factions', wbFormIDCk(ALFC, 'Faction', [FACT])),
          wbFormIDCk(ALFF, 'Alias Location Ref Type', [KYWD, LCRT]),
          wbRArray('Alias Package Data', wbFormIDCk(ALPC, 'Package', [PACK])),
          wbFormIDCk(NAM7, 'Terminal', [TERM]),
          wbString(SCCM, 'Comments'),
          wbFormIDCk(VTCK, 'Voice Types', [NPC_, FACT, FLST, VTYP, NULL]),
          wbEmpty(ALED, 'Alias End', cpNormal, True)
        ], [], cpNormal, False, nil, False, nil, wbContainerAfterSet),

        // Location Alias
        wbRStructSK([0], 'Alias', [
          wbInteger(ALLS, 'Location Alias ID', itU32),
          wbString(ALID, 'Alias Name'),
          wbFloat(ESAV, 'Unknown'),
          wbFloat(ESDA, 'Unknown'),
          wbFloat(ESRV, 'Unknown'),
          wbFloat(ESRP, 'Unknown'),
          wbQUSTAliasFlags,
          wbInteger(ALFI, 'Force Into Alias When Filled', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbFormIDCk(ALFL, 'Specific Location', [LCTN]),
          wbRStruct('Reference Alias Location', [
            wbInteger(ALFA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbFormIDCk(KNAM, 'Keyword', [KYWD])
          ], []),
          wbRStruct('External Alias Location', [
            wbFormIDCk(ALEQ, 'Quest', [QUST]),
            wbInteger(ALEA, 'Alias', itS32, wbQuestExternalAliasToStr, wbStrToAlias)
          ], []),
          wbRStruct('Find Matching Location From Event', [
            wbInteger(ALFE, 'From Event', itU32, wbQuestEventEnum),
            wbInteger(ALFD, 'Event Data', itU32, wbEventMemberEnum)
          ], []),
          wbCTDAs,
          wbInteger(ALCC, 'Closest To Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbEmpty(ALED, 'Alias End', cpNormal, True)
        ], []),

        // Ref Collection Alias
        wbRStructSK([0], 'Alias', [
          wbInteger(ALCS, 'Collection Alias ID', itU32),
          wbInteger(ALMI, 'Max Initial Fill Count', itU8)
        ], [])

      ], [])
    ),

    wbString(NNAM, 'Description', 0, cpTranslate, False),
    wbFormIDCk(GNAM, 'Quest Group', [KYWD]),
    wbString(SNAM, 'SWF File'),
    wbString(SCCM, 'Comments'),
    wbLString(QRWT, 'Reward Text'),
    wbUnknown(QARV),
    wbUnknown(QARF),
    wbRStruct('Public Event Data', [
      wbInteger(PEDF, 'Public Event Difficulty', itU32, wbEnum([
        'Very Easy',
        'Easy',
        'Medium',
        'Hard',
        'Very Hard',
        'Nuclear'
      ])),
      wbString(PEPI, 'Public Event Popup Info'),
      wbUnknown(PERM),
      wbUnknown(PERT),
      wbRArray('Possible Rewards',
        wbRStruct('Possible Reward', [
          wbString(PEWI, 'Icon'),
          wbLStringKC(PEWR, 'Description')
        ], [])
      )
    ], []),
    wbByteArray(QQSD, 'QQSD - Unknown 4 bytes', 4),
    wbRArray('QQS Structs',
      wbRStruct('QQS Struct', [
        wbString(QQSK, 'Key'),
        wbString(QQSV, 'Value')
      ],[])
    ),
    wbByteArray(QTFS, 'QTFS - Unknown 2 bytes', 2),
    wbUnknown(QMDE)
  ]);

  wbBodyPartIndexEnum := wbEnum([
    'Body Texture'
  ]);

  wbPhonemeTargets := wbStruct(PHWT, 'Phoneme Target Weight', [
    wbFloat('Aah / LipBigAah'),
    wbFloat('BigAah / LipDST'),
    wbFloat('BMP / LipEee'),
    wbFloat('ChJsh / LipFV'),
    wbFloat('DST / LipK'),
    wbFloat('Eee / LipL'),
    wbFloat('Eh / LipR'),
    wbFloat('FV / LipTh'),
    wbFloat('I'),
    wbFloat('K'),
    wbFloat('N'),
    wbFloat('Oh'),
    wbFloat('OohQ'),
    wbFloat('R'),
    wbFloat('TH'),
    wbFloat('W'),
    wbUnknown
  ], cpNormal, False, nil, 1); // only a single value in HandyRace

  wbPHWT := wbRStruct('FaceFX Phonemes', [
    wbRStruct('IY', [wbPhonemeTargets], []),
    wbRStruct('IH', [wbPhonemeTargets], []),
    wbRStruct('EH', [wbPhonemeTargets], []),
    wbRStruct('EY', [wbPhonemeTargets], []),
    wbRStruct('AE', [wbPhonemeTargets], []),
    wbRStruct('AA', [wbPhonemeTargets], []),
    wbRStruct('AW', [wbPhonemeTargets], []),
    wbRStruct('AY', [wbPhonemeTargets], []),
    wbRStruct('AH', [wbPhonemeTargets], []),
    wbRStruct('AO', [wbPhonemeTargets], []),
    wbRStruct('OY', [wbPhonemeTargets], []),
    wbRStruct('OW', [wbPhonemeTargets], []),
    wbRStruct('UH', [wbPhonemeTargets], []),
    wbRStruct('UW', [wbPhonemeTargets], []),
    wbRStruct('ER', [wbPhonemeTargets], []),
    wbRStruct('AX', [wbPhonemeTargets], []),
    wbRStruct('S',  [wbPhonemeTargets], []),
    wbRStruct('SH', [wbPhonemeTargets], []),
    wbRStruct('Z',  [wbPhonemeTargets], []),
    wbRStruct('ZH', [wbPhonemeTargets], []),
    wbRStruct('F',  [wbPhonemeTargets], []),
    wbRStruct('TH', [wbPhonemeTargets], []),
    wbRStruct('V',  [wbPhonemeTargets], []),
    wbRStruct('DH', [wbPhonemeTargets], []),
    wbRStruct('M',  [wbPhonemeTargets], []),
    wbRStruct('N',  [wbPhonemeTargets], []),
    wbRStruct('NG', [wbPhonemeTargets], []),
    wbRStruct('L',  [wbPhonemeTargets], []),
    wbRStruct('R',  [wbPhonemeTargets], []),
    wbRStruct('W',  [wbPhonemeTargets], []),
    wbRStruct('Y',  [wbPhonemeTargets], []),
    wbRStruct('HH', [wbPhonemeTargets], []),
    wbRStruct('B',  [wbPhonemeTargets], []),
    wbRStruct('D',  [wbPhonemeTargets], []),
    wbRStruct('JH', [wbPhonemeTargets], []),
    wbRStruct('G',  [wbPhonemeTargets], []),
    wbRStruct('P',  [wbPhonemeTargets], []),
    wbRStruct('T',  [wbPhonemeTargets], []),
    wbRStruct('K',  [wbPhonemeTargets], []),
    wbRStruct('CH', [wbPhonemeTargets], []),
    wbRStruct('SIL', [wbPhonemeTargets], []),
    wbRStruct('SHOTSIL', [wbPhonemeTargets], []),
    wbRStruct('FLAP', [wbPhonemeTargets], [])
  ], []);

  wbRaceRBPC :=
    wbArray(RBPC, 'Biped Object Condition AVs',
      wbUnion('Slot 30+', wbFormVersionDecider(78), [
        wbInteger('Slot 30+', itU32),
        wbFormIDCk('Slot 30+', [AVIF, NULL])
      ])
    );
    // since version 78: array of pair of AVIF FormID, before array of AVIF index. Similar to DamageType (and MGEF also somehow).
    {wbUnion(RBPC, 'Biped Object Conditions', wbFormVersionDecider(78), [
      wbArray('Biped Object Conditions', wbInteger('Condition AV', itU32)),
      wbArray('Biped Object Conditions', wbStruct('Condition AV', [
        wbFormIDck('AVIF 1', [AVIF, NULL]),
        wbFormIDck('AVIF 2', [AVIF, NULL])
      ]))
    ]);}

  var wbEquipSlot :=
    wbRStruct('Equip Slot', [
      wbFormIDCk(QNAM, 'Equip Slot', [EQUP]),
      wbString(ZNAM, 'Node')
    ], [])
    .SetSummaryKey([1, 0])
    .SetSummaryDelimiter(' = ')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseEquipSlots);

  var wbBodyParts :=
    wbRArrayS('Parts',
      wbRStructSK([0], 'Part', [
        wbInteger(INDX, 'Index', itU32, wbBodyPartIndexEnum),
        wbGenericModel
      ], [])
      .SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '[', ']')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfCollapsed, wbCollapseBodyParts)
    , cpNormal, True);

  wbRecord(RACE, 'Race',
    wbFlags(wbFlagsList([
      {0x00080000} 19, 'Unknown 19'
    ])), [
    wbEDID,
    wbString(DURL, 'Group Name'),
    wbSTCP,
    wbFULL,
    wbFTAGs,
    wbDESCReq,
    wbSPCT,
    wbSPLOs,
    wbFormIDCk(WNAM, 'Skin', [ARMO, NULL]),
    wbBOD2,
    wbKeywords,
    wbPRPS,
    wbAPPR,
    wbStruct(DATA, 'Data', [
      wbFloat('Male Height'),
      wbFloat('Female Height'),
      wbFromVersion(109, wbStruct('Male Default Weight', [
        wbFloat('Thin'),
        wbFloat('Muscular'),
        wbFloat('Fat')
      ])),
      wbFromVersion(109, wbStruct('Female Default Weight', [
        wbFloat('Thin'),
        wbFloat('Muscular'),
        wbFloat('Fat')
      ])),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Playable',
        {0x00000002} 'FaceGen Head',
        {0x00000004} 'Child',
        {0x00000008} 'Tilt Front/Back',
        {0x00000010} 'Tilt Left/Right',
        {0x00000020} 'No Shadow',
        {0x00000040} 'Swims',
        {0x00000080} 'Flies',
        {0x00000100} 'Walks',
        {0x00000200} 'Immobile',
        {0x00000400} 'Not Pushable',
        {0x00000800} 'No Combat In Water',
        {0x00001000} 'No Rotating to Head-Track',
        {0x00002000} 'Don''t Show Blood Spray',
        {0x00004000} 'Don''t Show Blood Decal',
        {0x00008000} 'Uses Head Track Anims',
        {0x00010000} 'Spells Align w/Magic Node',
        {0x00020000} 'Use World Raycasts For FootIK',
        {0x00040000} 'Allow Ragdoll Collision',
        {0x00080000} 'Regen HP In Combat',
        {0x00100000} 'Can''t Open Doors',
        {0x00200000} 'Allow PC Dialogue',
        {0x00400000} 'No Knockdowns',
        {0x00800000} 'Allow Pickpocket',
        {0x01000000} 'Always Use Proxy Controller',
        {0x02000000} 'Don''t Show Weapon Blood',
        {0x04000000} 'Overlay Head Part List', {>>>Only one can be active<<<}
        {0x08000000} 'Override Head Part List', {>>>Only one can be active<<<}
        {0x10000000} 'Can Pickup Items',
        {0x20000000} 'Allow Multiple Membrane Shaders',
        {0x40000000} 'Can Dual Wield',
        {0x80000000} 'Avoids Roads'
      ])),
      wbFloat('Acceleration Rate'),
      wbFloat('Deceleration Rate'),
      wbInteger('Size', itU32, wbEnum([
        'Small',
        'Medium',
        'Large',
        'Extra Large'
      ])),
      wbByteArray('Unknown Bytes1', 4),
      wbByteArray('Unknown Bytes2', 4),
      wbFloat('Injured Health Pct'),
      wbInteger('Shield Biped Object', itS32, wbBipedObjectEnum),
      wbFromVersion(124, wbInteger('Beard Biped Object', itS32, wbBipedObjectEnum)),
      wbInteger('Body Biped Object', itS32, wbBipedObjectEnum),
      wbFloat('Aim Angle Tolerance'),
      wbFloat('Flight Radius'),
      wbFromVersion(143, wbFloat('Unknown Float1')),
      wbFromVersion(143, wbFloat('Unknown Float2')),
      wbFromVersion(143, wbFloat('Unknown Float3')),
      wbFloat('Angular Acceleration Rate'),
      wbFloat('Angular Tolerance'),
      wbInteger('Flags 2', itU32, wbFlags([
        {0x00000001} 'Use Advanced Avoidance',
        {0x00000002} 'Non-Hostile',
        {0x00000004} 'Floats',
        {0x00000008} 'Unknown 3',
        {0x00000010} 'Unknown 4',
        {0x00000020} 'Head Axis Bit 0',
        {0x00000040} 'Head Axis Bit 1',
        {0x00000080} 'Can Melee When Knocked Down',
        {0x00000100} 'Use Idle Chatter During Combat',
        {0x00000200} 'Ungendered',
        {0x00000400} 'Can Move When Knocked Down',
        {0x00000800} 'Use Large Actor Pathing',
        {0x00001000} 'Use Subsegmented Damage',
        {0x00002000} 'Flight - Defer Kill',
        {0x00004000} 'Unknown 14',
        {0x00008000} 'Flight - Allow Procedural Crash Land',
        {0x00010000} 'Disable Weapon Culling',
        {0x00020000} 'Use Optimal Speeds',
        {0x00040000} 'Has Facial Rig',
        {0x00080000} 'Can Use Crippled Limbs',
        {0x00100000} 'Use Quadruped Controller',
        {0x00200000} 'Low Priority Pushable',
        {0x00400000} 'Cannot Use Playable Items',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'Unknown 27',
        {0x10000000} 'Unknown 28',
        {0x20000000} 'Unknown 29'
      ])),
      (**)
      wbFloat('Unknown Float4'),
      wbFloat('Unknown Float5'),
      wbByteArray('Unknown Bytes3',4),
      wbByteArray('Unknown Bytes4',4),
      wbByteArray('Unknown Bytes5',4),
      wbByteArray('Unknown Bytes6',4),
      wbByteArray('Unknown Bytes7',4),
      wbFloat('Unknown Float6'),
      wbByteArray('Unknown Bytes8',4),
      wbInteger('Pipboy Biped Object', itS32, wbBipedObjectEnum),
      wbInteger('XP Value', itS16),
      wbFloat('Severable - Debris Scale'),
      wbInteger('Severable - Debris Count', itU8),
      wbInteger('Severable - Decal Count', itU8),
      wbFloat('Explodable - Debris Scale'),
      wbInteger('Explodable - Debris Count', itU8),
      wbInteger('Explodable - Decal Count', itU8),
      wbFormIDCk('Severable - Explosion', [EXPL, NULL]),
      wbFormIDCk('Severable - Debris', [DEBR, NULL]),
      wbFormIDCk('Severable - Impact DataSet', [IPDS, NULL]),
      wbFormIDCk('Explodable - Explosion', [EXPL, NULL]),
      wbFormIDCk('Explodable - Debris', [DEBR, NULL]),
      wbFormIDCk('Explodable - Impact DataSet', [IPDS, NULL]),
      wbFromVersion(96, wbStruct('OnCripple', [
        wbFloat('Debris Scale'),
        wbInteger('Debris Count', itU8),
        wbInteger('Decal Count', itU8),
        wbFormIDCk('Explosion', [EXPL, NULL]),
        wbFormIDCk('Debris', [DEBR, NULL]),
        wbFormIDCk('Impact DataSet', [IPDS, NULL])
      ])),
      wbFromVersion(118, wbFormIDCk('Explodable - Subsegment Explosion', [EXPL, NULL])),
      wbFromVersion(98, wbFloat('Orientation Limits - Pitch')),
      wbFromVersion(101, wbFloat('Orientation Limits - Roll')),
      wbFromVersion(188, wbInteger('Backpack Biped Object', itS32, wbBipedObjectEnum))
    ], cpNormal, True),

    wbRStruct('Skeletal Data', [
      wbEmpty(MNAM, 'Male Marker'),
      wbRStruct('Male Skeletal Data', [
        wbString(ANAM, 'Male Skeletal Model'),
        wbMODT
      ],[]),
      wbEmpty(FNAM, 'Female Marker'),
      wbRStruct('Female Skeletal Data', [
        wbString(ANAM, 'Female Skeletal Model'),
        wbMODT
      ],[])
    ],[]),
    wbRArrayS('Movement Type Names', wbString(MTNM, 'Name', 4)),
    wbArray(VTCK, 'Voices', wbFormIDCk('Voice', [VTYP]), ['Male', 'Female'], cpNormal, True),
    //wbArray(DNAM, 'Decapitate Armors', wbFormIDCk('Decapitate Armor', [NULL, ARMO]), ['Male', 'Female'], cpNormal, False),
    wbArray(HCLF, 'Default Hair Colors', wbFormIDCk('Default Hair Color', [NULL, CLFM]), ['Male', 'Female'], cpNormal, False),
    wbInteger(TINL, 'Total Number of Tints in List', itU16, nil, nil, cpNormal, False), {>>> Needs Count Updated <<<}
    wbFloat(PNAM, 'FaceGen - Main clamp', cpNormal, True),
    wbFloat(UNAM, 'FaceGen - Face clamp', cpNormal, True),

    wbFormIDCk(ATKR, 'Attack Race', [RACE], False, cpNormal, False),
    wbRArrayS('Attacks', wbAttackData),

    wbRStruct('Body Data', [
      wbEmpty(NAM1, 'Body Data Marker', cpNormal, True),
      wbRStruct('Male Body Data', [
        wbEmpty(MNAM, 'Male Data Marker'),
        wbBodyParts
      ], [], cpNormal, True),
      wbRStruct('Female Body Data', [
        wbEmpty(FNAM, 'Female Data Marker', cpNormal, True),
        wbBodyParts
      ], [], cpNormal, True)
    ], [], cpNormal, True),
    wbFormIDCk(GNAM, 'Body Part Data', [BPTD]),
    wbFormIDCk(DNAM, 'Aim Assist Pose Data', [AAPD]),
    wbRStruct('Behavior Graph Data', [
      wbEmpty(NAM3, 'Behavior Graph Marker', cpNormal, True),
      wbRStruct('Male Behavior Graph', [
        wbEmpty(MNAM, 'Male Data Marker'),
        wbGenericModel
      ], [], cpNormal, True)
      .SetSummaryKey([1])
      .IncludeFlag(dfCollapsed, wbCollapseModels),
      wbRStruct('Female Behavior Graph', [
        wbEmpty(FNAM, 'Female Data Marker', cpNormal, True),
        wbGenericModel
      ], [], cpNormal, True)
      .SetSummaryKey([1])
      .IncludeFlag(dfCollapsed, wbCollapseModels)
    ],[]),
    wbFormIDCk(NAM4, 'Impact Material Type', [MATT]),
    wbFormIDCk(NAM5, 'Impact Data Set', [IPDS]),
    wbFormIDCk(NAM7, 'Dismember Blood Art', [ARTO]),
    wbFormIDCk(CNAM, 'Meat Cap TextureSet', [TXST]),
    wbFormIDCk(NAM2, 'Collar TextureSet', [TXST]),
    wbFormIDCk(ONAM, 'Sound - Open Corpse', [SNDR]),
    wbFormIDCk(LNAM, 'Sound - Close Corpse', [SNDR]),
    wbRArray('Biped Object Names', wbString(NAME, 'Name')),
    wbRaceRBPC,
    wbRArrayS('Movement Data Overrides', wbRStructSK([0], 'Override', [
      wbFormIDCk(MTYP, 'Movement Type', [MOVT]),
      wbSPED
    ], [])),
    wbInteger(VNAM, 'Equipment Flags', itU32, wbEquipType),
    wbRArray('Equip Slots', wbEquipSlot),
    wbFormIDCk(UNWP, 'Unarmed Weapon', [WEAP]),
    wbFormIDCk(RLBC, 'Loot Bag', [CONT]),

    wbRArray('Phoneme Target Names', wbString(PHTN, 'Name')),
    wbPHWT,

    wbFormIDCk(WKMV, 'Base Movement Defaults - Default', [MOVT]),
    wbFormIDCk(SWMV, 'Base Movement Defaults - Swim', [MOVT]),
    wbFormIDCk(FLMV, 'Base Movement Defaults - Fly', [MOVT]),
    wbFormIDCk(SNMV, 'Base Movement Defaults - Sneak', [MOVT]),

    //Head Data
    wbRStruct('Head Datas', [
      wbEmpty(NAM0, 'Head Data Marker'),
      // Male head
      wbRStruct('Male Head Data',[
        wbEmpty(MNAM, 'Male Data Marker'),
        wbStruct(NNAM, 'Male Neck Fat Adjustments Scale', [
          wbByteArray('Unknown', 4),
          wbFloat('X'),
          wbFloat('Y')
        ]),
        wbRArrayS('Male Head Parts', wbHeadPart),
        wbRArray('Male Race Presets', wbFormIDCk(RPRM, 'Preset NPC', [NPC_, NULL])),
        wbRArray('Male Hair Colors', wbFormIDCk(AHCM, 'Hair Color', [CLFM, NULL])),
        wbRArrayS('Male Face Details', wbFormIDCk(FTSM, 'Texture Set', [TXST, NULL])),
        wbFormIDCk(DFTM, 'Male Default Face Texture', [TXST]),
        wbTintTemplateGroups('Male Tint Layers'),
        wbMorphGroups('Male Morph Groups'),
        wbFaceMorphs('Male Face Morphs'),
        wbString(WMAP, 'Male Wrinkle Map Path')
      ],[]),

      // Female head
      wbEmpty(NAM0, 'Head Data Marker'),
      wbRStruct('Female Head Data', [
        wbEmpty(FNAM, 'Female Data Marker'),
        wbStruct(NNAM, 'Female Neck Fat Adjustments Scale', [
          wbByteArray('Unknown', 4),
          wbFloat('X'),
          wbFloat('Y')
        ]),
        wbRArrayS('Female Head Parts', wbHeadPart),
        wbRArray('Female Race Presets', wbFormIDCk(RPRF, 'Preset NPC', [NPC_, NULL])),
        wbRArray('Female Hair Colors', wbFormIDCk(AHCF, 'Hair Color', [CLFM, NULL])),
        wbRArrayS('Female Face Details', wbFormIDCk(FTSF, 'Texture Set', [TXST, NULL])),
        wbFormIDCk(DFTF, 'Female Default Face Texture', [TXST]),
        wbTintTemplateGroups('Female Tint Layers'),
        wbMorphGroups('Female Morph Groups'),
        wbFaceMorphs('Female Face Morphs'),
        wbString(WMAP, 'Female Wrinkle Map Path')
      ],[])
    ],[]),
    wbFormIDCk(NAM8, 'Morph Race', [RACE]),
    wbFormIDCk(RNAM, 'Armor Race', [RACE]),
    wbFormIDCk(CVT1, 'EWS Actor Cost Curve', [CURV]),
    wbFormIDCk(SRAC, 'Subgraph Template Race', [RACE]),
    wbFormIDCk(SADD, 'Subgraph Additive Race', [RACE]),
    wbRArray('Subgraph Data',
      wbRStruct('Data', [
        wbRArray('Actor Keywords', wbFormIDCk(SAKD, 'Keyword', [KYWD])),
        wbString(SGNM, 'Behaviour Graph'),
        wbRArray('Animation Paths', wbString(SAPT, 'Path'), cpNormal, True),
        wbRArray('Target Keywords', wbFormIDCk(STKD, 'Keyword', [KYWD])),
        // Values greater than $10000 sets a bool. Reading this "closes" the current record.
        wbStruct(SRAF, 'Flags', [
          wbInteger('Role', itU16, wbEnum([
            {0} 'MT',
            {1} 'Weapon',
            {2} 'Furniture',
            {3} 'Linking Only',
            {4} 'Pipboy'
          ])),
          wbInteger('Perspective', itU16, wbEnum([
            '3rd',
            '1st'
          ]))
        ], cpNormal, True)
        .SetSummaryKeyOnValue([0, 1])
        .IncludeFlag(dfTerminator)
      ], [], cpNormal, False, nil, True)
    ),
    wbFloat(PTOP, 'Idle Chatter Time Min'),
    wbFloat(NTOP, 'Idle Chatter Time Max'),
    wbRArray('Morph Values',
      wbRStruct('Value', [
        wbInteger(MSID, 'Index', itU32, wbIntToHexStr, wbHexStrToInt),
        wbString(MSM0, 'Min Name'),
        wbString(MSM1, 'Max Name')
      ], [])
    ),
    wbInteger(MLSI, 'Morph Last Index', itU32, wbIntToHexStr, wbHexStrToInt),
    wbString(HNAM, 'Hair Color Lookup Texture'),
    wbString(HLTX, 'Hair Color Extended Lookup Texture'),
    wbFormIDCk(QSTI, 'Dialogue Quest', [QUST]),
    wbBSMPSequence,
    wbLString(SNAM, 'Comments'),
    wbUnknown(TSLT)
  ], False, nil, cpNormal, False, nil, wbRACEAfterSet);


  wbRefRecord(REFR, 'Placed Object', wbFormaterUnion(wbREFRRecordFlagsDecider, [
    wbFlags(wbFlagsList([
      {0x00000010}  4, 'Ground Piece',
      {0x00000100}  8, 'LOD Respects Enable State',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x04000000} 26, 'Filter (Collision Geometry)',
      {0x08000000} 27, 'Bounding Box (Collision Geometry)',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x40000000} 30, 'Ground',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {ACTI STAT SCOL TREE} wbFlags(wbFlagsList([
      {0x00000010}  4, 'Ground Piece',
      {0x00000100}  8, 'LOD Respects Enable State',
      {0x00000200}  9, 'Hidden From Local Map',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00008000} 15, 'Visible when distant',
      {0x00010000} 16, 'Is Full LOD',
      {0x04000000} 26, 'Filter (Collision Geometry)',
      {0x08000000} 27, 'Bounding Box (Collision Geometry)',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {CONT TERM} wbFlags(wbFlagsList([
      {0x00000010}  4, 'Ground Piece',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x02000000} 25, 'No AI Acquire',
      {0x04000000} 26, 'Filter (Collision Geometry)',
      {0x08000000} 27, 'Bounding Box (Collision Geometry)',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'Ground',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {DOOR} wbFlags(wbFlagsList([
      {0x00000004}  2, 'Minimal Use Door',
      {0x00000040}  6, 'Hidden From Local Map',
      {0x00000100}  8, 'Inaccessible',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x04000000} 26, 'Filter (Collision Geometry)',
      {0x08000000} 27, 'Bounding Box (Collision Geometry)',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {LIGH} wbFlags(wbFlagsList([
      {0x00000100}  8, 'Doesn''t Light Water',
      {0x00000200}  9, 'Casts Shadows',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Never Fades',
      {0x00020000} 17, 'Doesn''t Light Landscape',
      {0x02000000} 25, 'No AI Acquire',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {MSTT} wbFlags(wbFlagsList([
      {0x00000010}  4, 'Ground Piece',
      {0x00000200}  9, 'Motion Blur',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x04000000} 26, 'Filter (Collision Geometry)',
      {0x08000000} 27, 'Bounding Box (Collision Geometry)',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {ADDN} wbFlags(wbFlagsList([
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True)),
    {ALCH BOOK SCRL AMMO ARMO INGR KEYM MISC FURN WEAP}
    wbFlags(wbFlagsList([
      {0x00000010}  4, 'Ground Piece',
      {0x00000400} 10, 'Persistent',
      {0x00000800} 11, 'Initially Disabled',
      {0x00010000} 16, 'Is Full LOD',
      {0x02000000} 25, 'No AI Acquire',
      {0x10000000} 28, 'Reflected By Auto Water',
      {0x20000000} 29, 'Don''t Havok Settle',
      {0x40000000} 30, 'No Respawn',
      {0x80000000} 31, 'Multibound'
    ], True, True))
  ]), [
    wbEDID,
    wbVMAD,
    wbXALG,
    wbFormIDCk(NAME, 'Base', sigBaseObjects, False, cpNormal, True),
    wbKWDAs,
    {--- Bound Contents ---}
    {--- Bound Data ---}
    wbStruct(XMBO, 'Bound Half Extents', [
      wbFloat('X'),
      wbFloat('Y'),
      wbFloat('Z')
    ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),

    {--- Primitive ---}
    wbStruct(XPRM, 'Primitive', [
      wbStruct('Bounds', [
        wbFloat('X', cpNormal, True, 2, 4),
        wbFloat('Y', cpNormal, True, 2, 4),
        wbFloat('Z', cpNormal, True, 2, 4)
      ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
      wbFloatRGBA('Color'),
      wbInteger('Type', itU32, wbEnum([
        'None',
        'Box',
        'Sphere',
        'Plane',
        'Line',
        'Ellipsoid'
      ]))
    ]),

    wbArray(XPOD, 'Portal Data', wbStruct('References', [
      wbFormIDCk('Origin', [REFR, NULL]),
      wbFormIDCk('Destination', [REFR, NULL])
    ])),

    // not seen in FO4 vanilla files, but can be added in CK
    wbSizePosRot(XPTL, 'Room Portal'),

    // Copied from FO3; assuming that the order is the same
    wbArray(XORD, 'Linked Occlusion References', wbFormIDCk('Reference', [REFR, NULL]), [
      'Right',
      'Left',
      'Bottom',
      'Top'
    ]),

    wbSizePosRot(XOCP, 'Occlusion Plane Data'),

    wbRStruct('Bound Data', [
      wbStruct(XRMR, 'Header', [
        wbInteger('Linked Rooms Count', itU8),
        wbInteger('Flags', itU8, wbFlags([
          'Unknown 1',
          'Unknown 2',
          'Unknown 3',
          'Unknown 4',
          'Unknown 5',
          'Unknown 6',
          'Has Image Space',
          'Has Lighting Template'
        ])),
        wbByteArray('Unknown', 2)
      ]),
      wbFormIDCk(LNAM, 'Lighting Template', [LGTM]),
      wbFormIDCk(INAM, 'Image Space', [IMGS]),
      wbRArrayS('Linked Rooms',
        wbFormIDCk(XLRM, 'Linked Room', [REFR])
      ).SetCountPath('XRMR\Linked Rooms Count')
    ], []),
    wbEmpty(XMBP, 'MultiBound Primitive Marker', cpIgnore),

    {--- Ragdoll ---}
    wbXRGD,
    wbXRGB,

    wbFloat(XRDS, 'Radius'),
    wbXSCL,

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),
    wbStruct(XLIG, 'Light Data', [
      wbFloat('FOV 90+/-'),
      wbFloat('Fade 1.0+/-'),
      wbFloat('End Distance Cap'),
      wbFloat('Shadow Depth Bias'),
      wbFloat('Near Clip'),
      wbFloat('Volumetric Intensity')
    ], cpNormal, False, nil, 4),
    {--- Lit Water ---}
    wbRArrayS('Lit Water',
      wbFormIDCk(XLTW, 'Water', [REFR])
    ),
    wbStruct(XALP, 'Alpha', [
      wbInteger('Cutoff', itU8),
      wbInteger('Base', itU8)
    ]),

    {--- Teleport ---}
    wbStruct(XTEL, 'Teleport Destination', [
      wbFormIDCk('Door', [REFR], True),
      wbPosRot,
      wbInteger('Flags', itU32, wbFlags([
        'No Alarm',
        'No Load Screen',
        'Relative Position'
      ])),
      wbFormIDCk('Transition Interior', [CELL, NULL])
    ]),
    wbFormIDCk(XTNM, 'Teleport Loc Name', [MESG]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    {--- Placed Water ---}
    wbWaterData,

    wbFormIDCk(XASP, 'Acoustic Restriction', [REFR]),
    wbEmpty(XATP, 'Activation Point'),
    wbInteger(XAMC, 'Ammo Count', itU32),
    wbEmpty(XLKT, 'Linked Ref Transient'),
    wbFormIDCk(XLYR, 'Layer', [LAYR]),
    wbStruct(XRLL, 'Lighting Volume - Lighting', [
      wbByteColors('Ambient Color'),
      wbByteColors('Directional Color'),
      wbByteColors('Fog Color Near'),
      wbFloat('Fog Near'),
      wbFloat('Fog Far'),
      wbInteger('Directional Rotation XY', itS32),
      wbInteger('Directional Rotation Z', itS32),
      wbFloat('Directional Fade'),
      wbFloat('Fog Clip Distance'),
      wbFloat('Fog Power'),
      wbUnused(32),
      wbByteColors('Fog Color Far'),
      wbFloat('Fog Max'),
      wbFloat('Light Fade Begin'),
      wbFloat('Light Fade End'),
      wbUnused(4),
      wbFloat('Near Height Mid'),
      wbFloat('Near Height Range'),
      wbByteColors('Fog Color High Near'),
      wbByteColors('Fog Color High Far'),
      wbFloat('High Density Scale'),
      wbFloat('Fog Near Scale'),
      wbFloat('Fog Far Scale'),
      wbFloat('Fog High Near Scale'),
      wbFloat('Fog High Far Scale'),
      wbFloat('Far Height Mid'),
      wbFloat('Far Height Range'),
      wbStruct('Skybox Bounds', [
        wbVec3('Center'),
        wbVec3('Radius')
      ])
    ], cpNormal, False, nil, 15).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbFormIDCk(XRL2, 'Lighting Volume - Lighting Template', [LGTM]),
    wbFormIDCk(XMSP, 'Material Swap', [MSWP]),
    wbXLWT,
    wbFormIDCk(XRFG, 'Reference Group', [RFGP]),
    wbStruct(XRDO, 'Radio', [
      wbFloat('Frequency'),
      wbFloat('Min Weak Distance'),
      wbFloat('Max Weak Distance'),
      wbInteger('Flags', itU32,
        wbFlags(wbFlagsList([
          1, 'Ignores Distance Checks',
          8, 'Unknown 8',
         16, 'Unknown 16'
        ], True, True))
      )
    ]),
    wbXFLG,
    wbByteArray(XKPD, 'Keypad Data', 5),
    wbStruct(XBSD, 'Bendable Spline Data', [
      wbFloat('Slack'),
      wbFloat('Thickness'),
      wbStruct('Half Extents', [
        wbFloat('X'),
        wbFloat('Y'),
        wbFloat('Z')
      ]),
      wbInteger('Wind - Detached End', itU8, wbBoolEnum),
      wbByteArray('Unused', 3), // junk data?
      wbBelowVersion(131, wbFloat('Unknown')), // not shown in editor
      wbBelowVersion(131, wbFloat('Unknown')) // not shown in editor
    ], cpNormal, False, nil, 5),
    wbStruct(XPDD, 'Projected Decal Data', [
      wbFloat('Width Scale'),
      wbFloat('Height Scale'),
      wbFromSize(12, wbByteRGBA('Color'))
      // "Uses Box Primitive" checkbox does the following:
      // 1. "Rounds" above floats (probably due to floating point precision)  [DIRTY EDITS?]
      // 2. "Rounds" DATA\Position floats (probably due to floating point precision)  [DIRTY EDITS?]
      // 3. Creates an XPRM subrecord (this is the "Primitive" tab in the editor)
      // 4. Fills out Primitive data:
      //    4a. Primitive type: Box
      //    4b. Collision layer: XTRI subrecord = 15
      //    4c. Bounds (XYZ): 256.0, 215.0, 256.0
      //    4d. Color (RGB): 0, 128, 128
      //    4e. Unknown: 0.4
    ]),
    wbFormIDCk(XSPC, 'Spawn Container', [REFR]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', sigReferences),
          wbFloat('Delay')
        ])
      )
    ], []),

    wbFormIDCk(XLIB, 'Leveled Item Base Object', [LVLI]),
    wbXLCM,
    wbFormIDCk(XLCN, 'Persist Location', [LCTN]),

    {>>> COLL form Index value <<<}
    wbInteger(XTRI, 'Collision Layer', itU32),

    {--- Lock ---}
    wbStruct(XLOC, 'Lock Data', [
      wbInteger('Level', itU8, wbEnum([], [
         0, 'None',
         1, 'Opens Door',
        25, 'Novice (Level 0)',
        50, 'Advanced (Level 1)',
        75, 'Expert (Level 2)',
       100, 'Master (Level 3)',
       250, 'Unknown',
       251, 'Barred',
       252, 'Chained',
       253, 'Requires Terminal',
       254, 'Inaccessible',
       255, 'Requires Key'
      ])),
      wbByteArray('Unused', 3, cpIgnore),
      wbFormIDCkNoReach('Key', [KEYM, NULL]),
      wbInteger('Flags', itU8, wbFlags(['', '', 'Leveled Lock'])),
      wbByteArray('Unused', 3, cpIgnore),
      wbInteger('Unknown', itU8), { Exe does an |= 1 on this byte }
      wbByteArray('Unused', 3, cpIgnore)
    ], cpNormal, False, nil, 4),

    wbXEZN,

    {--- Generated Data ---}
    wbStruct(XNDP, 'Navmesh Door Link', [
      wbFormIDCk('Navmesh', [NAVM]),
      wbInteger('Triangle', itS16, wbREFRNavmeshTriangleToStr, wbStringToInt),
      wbByteArray('Unused', 2, cpIgnore)
    ]),

    wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),
    wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),
    wbEmpty(XIS2, 'Ignored by Sandbox'),

    {--- Ownership ---}
    wbXOWN,
    wbXRNK,

    wbInteger(XCNT, 'Item Count', itS32),
    wbInteger(XHLT, 'Health %', itU32),

    wbXESP,
    wbRArray('Linked References', wbStruct(XLKR, 'Linked Reference', [
      wbFormIDCk('Keyword/Ref', [KYWD, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
      wbFormIDCk('Ref', sigReferences)
    ], cpNormal, False, nil, 1)),

    wbRArray('Patrol', wbRStruct('Data', [
      wbFloat(XPRD, 'Idle Time', cpNormal, True),
      wbEmpty(XPPA, 'Patrol Script Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbPDTOs
    ], [])),

    {--- Flags ---}
    wbActionFlag,

    wbFloat(XHTW, 'Head-Tracking Weight'),
    wbFloat(XFVC, 'Favor Cost'),

    wbEmpty(ONAM, 'Open by Default'),

    {--- Map Data ---}
    wbRStruct('Map Marker', [
      wbEmpty(XMRK, 'Map Marker Data'),
      wbInteger(FNAM, 'Map Flags', itU8, wbFlags([
        {0x01} 'Visible',
        {0x02} 'Can Travel To',
        {0x04} '"Show All" Hidden',
        {0x08} 'Use Location Name'
      ]), cpNormal, True),
      wbFULLReq,
      wbStruct(TNAM, '', [
        wbInteger('Type', itU16, wbEnum([], [
          0, 'CaveMarker',
          1, 'CityMarker',
          2, 'EncampmentMarker',
          3, 'FactoryMarker',
          4, 'MonumentMarker',
          5, 'MetroMarker',
          6, 'MilitaryBaseMarker',
          7, 'LandmarkMarker',
          8, 'OfficeMarker',
          9, 'TownRuinsMarker',
          10, 'UrbanRuinsMarker',
          11, 'SancHillsMarker',
          12, 'SettlementMarker',
          13, 'SewerMarker',
          14, 'VaultMarker',
          15, 'AirfieldMarker',
          16, 'CamperMarker',
          17, 'CarMarker',
          18, 'ChurchMarker',
          19, 'CountryClubMarker',
          20, 'CustomHouseMarker',
          21, 'DriveInMarker',
          22, 'ElevatedHighwayMarker',
          23, 'FarmMarker',
          24, 'FillingStationMarker',
          25, 'ForestedMarker',
          26, 'GoodneighborMarker',
          27, 'GraveyardMarker',
          28, 'HospitalMarker',
          29, 'IndustrialDomeMarker',
          30, 'IndustrialStacksMarker',
          31, 'InstituteMarker',
          32, 'IrishPrideMarker',
          33, 'JunkyardMarker',
          34, 'ObservatoryMarker',
          35, 'PierMarker',
          36, 'PondLakeMarker',
          37, 'QuarryMarker',
          38, 'RadioactiveAreaMarker',
          39, 'RadioTowerMarker',
          40, 'SalemMarker',
          41, 'SchoolMarker',
          42, 'ShipwreckMarker',
          43, 'SubmarineMarker',
          44, 'SwanPondMarker',
          45, 'TownMarker',
          46, 'BoSMarker',
          47, 'BrownstoneMarker',
          48, 'BunkerMarker',
          49, 'CastleMarker',
          50, 'SkyscraperMarker',
          51, 'LibertaliaMarker',
          52, 'LowRiseMarker',
          53, 'MinutemenMarker',
          54, 'PoliceStationMarker',
          55, 'RailroadFactionMarker',
          56, 'RailroadMarker',
          57, 'SatelliteMarker',
          58, 'SentinelMarker',
          59, 'USSConstitutionMarker',
          60, 'MechanistMarker',
          61, 'RaiderSettlementMarker',
          62, 'VassalSettlementMarker',
          63, 'PotentialVassalSettlementMarker',
          64, 'TrainStationMarker',
          65, 'ElectricalSubstationMarker',
          66, 'FissureMarker',
          67, 'Vault63Marker',
          68, 'Vault76Marker',
          69, 'Vault94Marker',
          70, 'Vault96Marker',
          71, 'AmusementParkMarker',
          72, 'MansionMarker',
          73, 'ArktosPharmaMarker',
          74, 'PowerPlantMarker',
          75, 'SkiResortMarker',
          76, 'AppalachianAntiquesMarker',
          77, 'TeapotMarker',
          78, 'AgriculturalCenterMarker',
          79, 'WoodShackMarker',
          80, 'HouseTrailerMarker',
          81, 'LookoutTowerMarker',
          82, 'OverlookMarker',
          83, 'PumpkinMarker',
          84, 'CowSpotsCreameryMarker',
          85, 'CabinMarker',
          86, 'TrainTrackMark',
          87, 'CapitalBuildingMarker',
          88, 'HighTechBuildingMarker',
          89, 'LighthouseMarker',
          90, 'ExcavatorMarker',
          91, 'SpaceStationMarker',
          92, 'PalaceWindingPathMarker',
          93, 'TopOfTheWorldMarker',
          94, 'DamMarker',
          95, 'MonorailMarker',
          96, 'WhitespringResort',
          97, 'NukaColaQuantumPlant',
          98, 'MysteriousGuidestoneMarker',
          99, 'PublicWorkshopMarker',
          100, 'DoorMarker',
          101, 'QuestMarker',
          102, 'DoorMarker',
          103, 'QuestMarker',
          104, 'PlayerSetMarker',
          105, 'PlayerLocMarker',
          106, 'PowerArmorLocMarker',
          107, 'TeammateMarker',
          108, 'LastCorpseMarker',
          109, 'YourCampMarker',
          110, 'InWorldEventMarker',
          111, 'MasterFissureMarker',
          112, 'NukedZoneMarker',
          113, 'WaypointMarker'
        ]))
      ], cpNormal, True)
    ], []),

    {--- Attach reference ---}
    wbFormIDCk(XATR, 'Attach Ref', [REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, ACHR]),

    wbRArray('Spline Connection', wbStruct(XPLK, 'Link', [
      wbFormIDCk('Ref', [REFR, ACHR]),
      wbFromSize(5, wbByteArray('Link Type', 4))
    ])),

    wbRStruct('Power Grid', [
      wbInteger(XWPG, 'Count', itU32),
      wbRArray('Connections', wbStruct(XWPN, 'Connection', [
        wbFormIDCk('Node 1', [REFR, ACHR, NULL]),
        wbFormIDCk('Node 2', [REFR, ACHR, NULL]),
        wbFormIDCk('Line', [REFR, NULL]) // BNDS ref
      ]))
    ], []),

    wbStruct(XCVR,'Water Current Zone Data', [
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown')
    ]),
    wbStruct(XCVL,'Water Current Zone Data', [
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown')
    ]),
    wbFormIDCk(XCZR, 'Current Zone Reference', sigReferences),
    wbUnknown(XCZA),
    wbFormIDCk(XCZC, 'Current Zone Cell', [CELL, NULL]),

    wbXLOD, // not seen in FO4 vanilla files

    wbStruct(XCMD,'Cube Map Volume Data', [
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFromVersion(161, wbStruct('X+', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbFromVersion(161, wbStruct('X-', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbFromVersion(161, wbStruct('Y+', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbFromVersion(161, wbStruct('Y-', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbFromVersion(161, wbStruct('Z+', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbFromVersion(161, wbStruct('Z-', [
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbBelowVersion(170, wbFloat('Unknown')),
        wbFloat('Unknown')
      ])),
      wbUnion('Unknown',wbFormVersionDecider([161, 170]), [
        wbEmpty('Unused'),
        wbInteger('Unknown',itU8),
        wbInteger('Unknown',itU32)
      ])
    ]),
    wbXWPK,
    wbArrayS(XPPS, 'Property Sheet', wbObjectProperty),
    wbRArray('Workshop Resource Capacities',
      wbStruct(XWRC, 'Resource', [
        wbFormIDCk('Resource', [RESO]),
        wbFloat('Capacity')
      ])
    ),
    wbXPCK,
    wbFormID(XLLV, 'Cube Map Volume Data Pointer'),
    wbDataPosRot,
    wbFormIDCk(SRGN, 'Sub-Region', [REGN]),
    wbString(MNAM, 'Comments')
  ], True, wbPlacedAddInfo, cpNormal, False, wbREFRAfterLoad);

  wbRecord(REGN, 'Region',
    wbFlags(wbFlagsList([
      {0x00000040}  6, 'Border Region',
      {0x00000080}  7, 'Unknown 7 ',
      {0x00000400} 10, 'Unknown 10'
    ])), [
    wbEDID,
    wbByteRGBA(RCLR, 'Map Color'),
    wbFormIDCkNoReach(WNAM, 'Worldspace/Reference', [WRLD, REFR]),
    wbFormIDCkNoReach(LNAM, 'Location', [LCTN]),
    wbInteger(LCPR, 'Location Priority', itU8),
    wbRArray('Region Areas', wbRStruct('Region Area', [
      wbInteger(RPLI, 'Edge Fall-off', itU32),
      wbArray(RPLD, 'Points', wbStruct('Point', [
        wbFloat('X'),
        wbFloat('Y')
      ]).SetSummaryKey([1]).IncludeFlag(dfSummaryMembersNoName), 0, wbRPLDAfterLoad),
      wbUnknown(ANAM)
    ], [])),
    wbRArrayS('Region Data Entries', wbRStructSK([0], 'Region Data Entry', [
      {always starts with an RDAT}
      wbStructSK(RDAT, [0], 'Data Header', [
        wbInteger('Type', itU32, wbEnum([
          {0} 'Unknown 0',
          {1} 'Unknown 1',
          {2} 'Objects',
          {3} 'Weather',
          {4} 'Map',
          {5} 'Workshop',
          {6} 'Grass',
          {7} 'Sound',
          {8} 'Imposter',
          {9} 'Unknown 10',
          {10}'Unknown 11',
          {11}'Unknown 12',
          {12}'Unknown 13',
          {13}'Unknown 14',
          {14}'Unknown 15',
          {15}'Unknown 16'
        ])),
        wbInteger('Flags', itU8, wbFlags([
          'Override'
        ])),
        wbInteger('Priority', itU8),
        wbByteArray('Unknown')
      ], cpNormal, True),

      {--- Icon ---}
      wbICON,

      {--- Sound ---}
      wbFormIDCk(RDMO, 'Music', [MUSC], False, cpNormal, False, wbREGNSoundDontShow),
      wbRegionSounds,
      wbRArray('Sounds', wbStruct(RDSN, 'Sound', [
        wbFormIDCk('Sound', [SNDR, NULL]),
        wbArray('Keywords', wbFormIDCk('Keyword', [KYWD]), -1),
        wbFloat('Chance')
      ])),

            {--- Map ---}
      wbLString(RDMP, 'Map Name', 0, cpTranslate, False, wbREGNMapDontShow),

      {followed by one of these: }

      {--- Objects ---}
      wbStruct(RDOT, 'Region Data Object', [
        wbArray('Unknown', wbStruct('Unknown', [
          {00} wbByteArray('Unknown', 4),
          {04} wbFloat('Unknown'),
          {08} wbFloat('Unknown'),
          {12} wbFloat('Unknown'),
          {16} wbFloat('Unknown'),
          {20} wbByteArray('Unknown', 24),
          {44} wbFloat('Unknown'),
          {48} wbFloat('Unknown'),
          {52} wbFloat('Unknown'),
          {56} wbByteArray('Unknown', 8),
          {64} wbInteger('Clustering', itU8),
          {65} wbInteger('Min Slope', itU8),
          {66} wbInteger('Max Slope', itU8),
          {67} wbInteger('Flags', itU8, wbFlags([
                 {0}'Conform to slope',
                 {1}'Paint Vertices',
                 {2}'Size Variance +/-',
                 {3}'X +/-',
                 {4}'Y +/-',
                 {5}'Z +/-',
                 {6}'Tree',
                 {7}'Huge Rock'
               ])),
          {68} wbFormIDCk('Object', [TREE, FLOR, STAT, LTEX, MSTT, PKIN, SCOL]),
          {72} wbByteArray('Unknown', 2)
        ]), wbRDOTCountCallback),
        wbArray('Unknown', wbByteArray('Unknown', 2), wbRDOTCountCallback)
      ]),

       (** )
      wbStruct(RDOT, 'Unknown', [
        wbByteArray('Unknown', 68),
        wbArray('Unknown', wbStruct('Unknown', [
          {00} wbFormIDCk('Pack-In', [PKIN]),
          {04} wbInteger('Parent Index', itU16, wbHideFFFF),
          {06} wbByteArray('Unknown', 40),
          {46} wbFloat('Unknown'),
          {50} wbFloat('Unknown'),
          {54} wbFloat('Unknown'),
          {58} wbByteArray('Unknown', 16)
        ]))
      ]),
       (** )
       (** )
      wbStruct('Object', [
        wbUnknown
        (** )
        wbFormIDCk('Object', [TREE, FLOR, STAT, LTEX, MSTT]),
        wbInteger('Parent Index', itU16, wbHideFFFF),
        wbByteArray('Unknown', 2),
        wbFloat('Density'),
        wbInteger('Clustering', itU8),
        wbInteger('Min Slope', itU8),
        wbInteger('Max Slope', itU8),
        wbInteger('Flags', itU8, wbFlags([
          {0}'Conform to slope',
          {1}'Paint Vertices',
          {2}'Size Variance +/-',
          {3}'X +/-',
          {4}'Y +/-',
          {5}'Z +/-',
          {6}'Tree',
          {7}'Huge Rock'
        ])),
        wbInteger('Radius wrt Parent', itU16),
        wbInteger('Radius', itU16),
        wbFloat('Min Height'),
        wbFloat('Max Height'),
        wbFloat('Sink'),
        wbFloat('Sink Variance'),
        wbFloat('Size Variance'),
        wbStruct('Angle Variance', [
          wbInteger('X', itU16),
          wbInteger('Y', itU16),
          wbInteger('Z', itU16)
        ]),
        wbByteArray('Unknown', 2),
        wbByteArray('Unknown', 4)
      ]), 0, nil, nil, cpNormal, False, wbREGNObjectsDontShow),
        (**)


      {--- Grass ---}
      wbArrayS(RDGS, 'Grasses', wbStructSK([0], 'Grass', [
        wbFormIDCk('Grass', [GRAS]),
        wbByteArray('Unknown',4)
      ]), 0, cpNormal, False, nil, nil, wbREGNGrassDontShow),

      {--- Weather ---}
      wbArrayS(RDWT, 'Weather Types', wbStructSK([0], 'Weather Type', [
        wbFormIDCk('Weather', [WTHR]),
        wbInteger('Chance', itU32),
        wbFormIDCk('Global', [GLOB, NULL])
      ]), 0, cpNormal, False, nil, nil, wbREGNWeatherDontShow),

      wbFloat(RLDM, 'LOD Display Distance Multiplier'),
      wbFloat(ANAM, 'Occlusion Accuracy Dist'),

      {--- Unknown ---}
      wbStruct(RDWK, 'Workshop', [
        wbFloat('Unknown'),
        wbFloat('Unknown')
      ])
    ], [])),
    wbUnknown(RCBN)
  ], True);

  wbRecord(SOUN, 'Sound Marker', [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbFormIDCk(SDSC, 'Sound Descriptor', [SNDR, NULL]),
    wbStruct(REPT, 'Repeat', [
      wbFloat('Min Time'),
      wbFloat('Max Time'),
      wbInteger('Stackable', itU8, wbBoolEnum)
    ], cpNormal, False, nil, 2),
    wbBEVA,
    wbFEVA
  ]);

  wbSPIT := wbStruct(SPIT, 'Data', [
    wbInteger('Base Cost', itU32),
    wbInteger('Flags', itU32, wbFlags([
      {0x00000001} 'Manual Cost Calc',
      {0x00000002} 'Unknown 2',
      {0x00000004} 'Unknown 3',
      {0x00000008} 'Unknown 4',
      {0x00000010} 'Unknown 5',
      {0x00000020} 'Unknown 6',
      {0x00000040} 'Unknown 7',
      {0x00000080} 'Unknown 8',
      {0x00000100} 'Unknown 9',
      {0x00000200} 'Unknown 10',
      {0x00000400} 'Unknown 11',
      {0x00000800} 'Unknown 12',
      {0x00001000} 'Unknown 13',
      {0x00002000} 'Unknown 14',
      {0x00004000} 'Unknown 15',
      {0x00008000} 'Unknown 16',
      {0x00010000} 'Unknown 17',
      {0x00020000} 'PC Start Spell',
      {0x00040000} 'Instant Cast',
      {0x00080000} 'Area Effect Ignores LOS',
      {0x00100000} 'Ignore Resistance',
      {0x00200000} 'No Absorb/Reflect',
      {0x00400000} 'Unknown 23',
      {0x00800000} 'No Dual Cast Modification',
      {0x01000000} 'Unknown 25',
      {0x02000000} 'Unknown 26',
      {0x04000000} 'Unknown 27',
      {0x08000000} 'Unknown 28',
      {0x10000000} 'Unknown 29',
      {0x20000000} 'Unknown 30',
      {0x40000000} 'Unknown 31',
      {0x80000000} 'Unknown 32'
    ])),
    wbInteger('Type', itU32, wbEnum([
      {0} 'Spell',
      {1} 'Disease',
      {2} 'Power',
      {3} 'Lesser Power',
      {4} 'Ability',
      {5} 'Poison',
      {6} 'Enchantment',
      {7} 'Potion',
      {8} 'Wortcraft',
      {9} 'Levelled',
     {10} 'Addiction',
     {11} 'Voice',
     {12} 'Staff Enchantment',
     {13} 'Scroll'
    ])),
    wbFloat('Charge Time'),
    wbInteger('Cast Type', itU32, wbCastEnum),
    wbInteger('Target Type', itU32, wbTargetEnum),
    wbFloat('Cast Duration'),
    wbFloat('Range'),
    wbFormIDCk('Casting Perk', [NULL, PERK])
  ], cpNormal, True);

  wbRecord(SPEL, 'Spell',
    wbFlags(wbFlagsList([
      {0x00008000} 15, 'Unknown 15'
    ])), [
    wbEDID,
    wbOBND(True),
    wbPHST,
    wbOPDSs,
    wbDEFL,
    wbFULL,
    wbKeywords,
    wbMDOB,
    wbETYP,
    wbDESCReq,
    wbSPIT,
    wbEffectsReq,
    wbMIID
  ]);

  {wbRecord(SCRL, 'Scroll', [
    wbEDID
  ]);}

  wbRecord(STAT, 'Static',
    wbFlags(wbFlagsList([
      2, 'Heading Marker',
      4, 'Non Occluder',
      6, 'Has Tree LOD', // Used in Fallout 4 ?
      7, 'Add-On LOD Object',
      9, 'Hidden From Local Map',
     10, 'Headtrack Marker',
     11, 'Used as Platform',
     13, 'Pack-In Use Only',
     15, 'Has Distant LOD',
     17, 'Uses HD LOD Texture',
     19, 'Has Currents',
     23, 'Is Marker',
     25, 'Obstacle',
     26, 'Navmesh - Filter',
     27, 'Navmesh - Bounding Box',
     28, 'Show In World Map (Sky Cell Only)',
     30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPHST,
    wbPTRN,
    wbDEFL,
    wbSNTP,
    wbXALG,
    wbFTAGs,
    wbFTYP,
    wbGenericModel,
    wbPRPS,
    wbFULL,
    wbDEST,
    wbDOFA,
    wbNAM1LODP,
    wbStruct(DNAM, 'Direction Material', [
      wbFloat('Max Angle (30-120)'),
      wbFormIDCk('Material', [MATO, NULL]),
      wbFloat('Leaf Amplitude'),
      wbFloat('Leaf Frequency')
    ], cpNormal, True, nil, 2),
    wbInteger(STXF, 'Unknown Bool', itU8, wbBoolEnum),
    wbNVNM,
    wbArray(MNAM, 'Distant LOD',
      wbStruct('LOD', [
        {>>> Contains null-terminated mesh FileName followed by random data up to 260 bytes <<<}
        wbString(True, 'Mesh', 260)
        //wbByteArray('Mesh', 260, cpIgnore)
      ]), [
        'Level 0',
        'Level 1',
        'Level 2',
        'Level 3'
      ],
      cpNormal, False
    )
  ], True);  // unordered, NVNM can be before or after MNAM

  wbRecord(TES4, 'Main File Header',
    wbFlags(wbFlagsList([
      {0x00000001}  0, 'ESM',
      {0x00000010}  4, 'Optimized File',
      {0x00000080}  7, 'Localized',
      {0x00000100}  8, 'Pre-calc Data Only',
      {0x00000200}  9, 'ESL'
    ], False), True), [
    wbHEDR,
    wbUnknown(MMSB),   //Added in 1.2.0.15
    //wbByteArray(OFST, 'Unknown', 0, cpIgnore), {unused in FO76}
    //wbByteArray(DELE, 'Unknown', 0, cpIgnore), {unused in FO76}
    wbString(CNAM, 'Author', 0, cpTranslate, True),
    wbString(SNAM, 'Description', 0, cpTranslate),
    wbRArray('Master Files', wbRStruct('Master File', [
      wbStringForward(MAST, 'FileName', 0, cpNormal, True),
      // wbInteger(DATA, 'Filesize', itU64, nil, nil, cpIgnore, True)  // Should be set by CK but usually null
      wbByteArray(DATA, 'Unknown', 8, cpIgnore, True)
    ], [ONAM])).IncludeFlag(dfInternalEditOnly, not wbAllowMasterFilesEdit),
    wbArray(ONAM, 'Overridden Forms',                     // Valid in CK
      wbFormIDCk('Form', [ACHR, LAND, NAVM, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, DLBR, DIAL, INFO, SCEN]),
      0, nil, nil, cpNormal, False{, wbTES4ONAMDontShow}),
    //wbByteArray(SCRN, 'Screenshot'), {unused in FO76}
    wbRArray('Transient Types (CK only)', wbStruct(TNAM, 'Transient Type', [
      wbInteger('FormType', itU32, wbFormTypeEnum), // seen TESTopic 78 (array of DIAL) and BGSScene 126 (array of SCEN)
      wbArray('References', wbFormIDCk('Reference', [DIAL, SCEN]))
    ])),          // Ignored by the runtime
    wbInteger(INTV, 'Unknown', itU32),                    // Ignored by the runtime, 4 bytes loaded in CK   Possibly a version
    wbInteger(INCC, 'Interior Cell Count', itU32)                     // Size of some array of 12 bytes elements
  ], True, nil, cpNormal, True);

  wbRecord(PLYR, 'Player Reference', [
    wbEDID,
    wbFormID(PLYR, 'Player', cpNormal, True).SetDefaultNativeValue($7)
  ]).IncludeFlag(dfInternalEditOnly);

  wbRecord(TREE, 'Tree',
    wbFlags(wbFlagsList([
      {0x00008000} 15, 'Has Distant LOD'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbGenericModel,
    wbFormIDCK(PFIG, 'Ingredient', sigBaseObjects),
    wbFormIDCK(SNAM, 'Harvest Sound', [SNDR, NULL]),
    wbStruct(PFPC, 'Ingredient Production', [
      wbInteger('Spring', itU8),
      wbInteger('Summer', itU8),
      wbInteger('Fall', itU8),
      wbInteger('Winter', itU8)
    ]),
    wbFULL,
    wbStruct(CNAM, 'Tree Data', [
      wbFloat('Trunk Flexibility'),
      wbFloat('Branch Flexibility'),
      //wbByteArray('Unknown', 32),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Unknown'),
      wbFloat('Leaf Amplitude'),
      wbFloat('Leaf Frequency')
    ], cpNormal, True)
  ]);

  wbRecord(FLOR, 'Flora', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbOPDSs,
    wbDEFL,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbPRPS,
    wbNAM1LODP,
    wbByteRGBA(PNAM, 'Marker Color'),
    wbQSTI,
    wbUnknown(AIID),
    wbATTX,
    wbLStringKC(RNAM, 'Activate Text Override', 0, cpTranslate),
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      'No Displacement',
      'Ignored by Sandbox',
      'Unknown 2', {Only used on DefaultProceduralWater [ACTI:00000019]}
      'Unknown 3', {Currently Unused}
      'Is a Radio',
      'Is a Lookat Trigger',
      'Unknown 6' {Currently Unused}
    ])),
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN,
    wbFormIDCk(PFIG, 'Ingredient', sigBaseObjects),
    wbFormIDCK(SNAM, 'Harvest Sound', [SNDR]),
    wbStruct(PFPC, 'Ingredient Production', [
      wbInteger('Spring', itU8),
      wbInteger('Summer ', itU8),
      wbInteger('Fall', itU8),
      wbInteger('Winter', itU8)
    ], cpNormal),
    wbUnknown(CITC),
    wbInteger(FLFG, 'Flora Flags', itU32, wbFlags([
      {0x00000001} 'Unknown 0'
    ]), cpNormal),
    wbFloat(FMAH, 'Max Harvest'),
    wbFloat(FMIH, 'Min Harvest'),
    wbFormIDCk(FMAG, 'Max Harvest Global', [GLOB]),
    wbFormIDCk(FMIG, 'Min Harvest Global', [GLOB])
  ]);

  {wbRecord(SCPT, 'SCPT', [
    wbEDID
  ]);}

{>>> Start of new Fallout 4 Records <<<}

  wbRecord(AECH, 'Audio Effect Chain', [
    wbEDID,
    wbRArray('Effects',
      wbRStruct('Effect', [
        wbInteger(KNAM, 'Type', itU32, wbEnum([], [
          Int64($864804BE), 'BSOverdrive',
          Int64($EF575F7F), 'BSStateVariableFilter',
          Int64($18837B4F), 'BSDelayEffect'
        ]), cpNormal, False, False, nil, nil, Int64($864804BE)).SetAfterSet(wbAECHTypeAfterSet),
        wbStruct(DNAM, 'Data', [
          wbInteger('Enabled', itU32, wbBoolEnum),
          wbUnion('Value', wbAECHDataDecider, [
            wbStruct('Overdrive', [
              wbFloat('Input Gain'), // exponentially(?) normalized from 0..10 to -80..20
              wbFloat('Output Gain'), // exponentially(?) normalized from 0..10 to -80..20
              wbFloat('Upper Threshold'), // exponentially(?) normalized from 0..1 to -74..0
              wbFloat('Lower Threshold') // exponentially(?) normalized from 0..1 to -80..0
            ]),
            wbStruct('State Variable Filter', [
              wbFloat('Center Freq'),
              wbFloat('Q Value'),
              wbInteger('Filter Mode', itU32, wbEnum([
                'High Pass',
                'Low Pass',
                'Band Pass',
                'Notch'
              ]))
            ]),
            wbStruct('Delay Effect', [
              wbFloat('Feedback %'),
              wbFloat('Wet Mix %'),
              wbInteger('Delay MS', itU32)
            ])
          ])
        ])
      ], [])
    )
  ]);

  wbRecord(AMDL, 'Aim Model', [
    wbEDID,
    wbStruct(DNAM, 'Data', [
      wbFloat('Cone of Fire - Min Angle'),
      wbFloat('Cone of Fire - Max Angle'),
      wbFloat('Cone of Fire - Increase Per Shot'),
      wbFloat('Cone of Fire - Decrease Per Sec'),
      wbInteger('Cone of Fire - Decrease Delay MS', itU32),
      wbFloat('Cone of Fire - Sneak Mult'),
      wbFloat('Recoil - Diminish Spring Force'),
      wbFloat('Recoil - Diminish Sights Mult'),
      wbFloat('Recoil - Max Per Shot'),
      wbFloat('Recoil - Min Per Shot'),
      wbFloat('Recoil - Hip Mult'),
      wbInteger('Runaway - Recoil Shots', itU32),
      wbFloat('Recoil - Arc'),
      wbFloat('Recoil - Arc Rotate'),
      wbFloat('Cone of Fire - Iron Sights Mult'),
      wbFloat('Stability - Base Stability')
    ]),
    wbUnknown(AMMR),
    wbFloat(AMRS, 'Unknown')
  ]);

  wbRecord(AORU, 'Attraction Rule', [
    wbEDID,
    wbStruct(AOR2, 'Data', [
      wbFloat('Radius'),
      wbFloat('Min Delay'),
      wbFloat('Max Delay'),
      wbInteger('Requires Line of Sight', itU8, wbBoolEnum),
      wbInteger('Combat Target', itU8, wbBoolEnum),
      wbByteArray('Unused', 2)
    ], cpNormal, True)
  ]);

  wbRecord(BNDS, 'Bendable Spline', [
    wbEDID,
    wbOBND,
    wbStruct(DNAM, 'Data', [
      wbFloat('Default Number of Tiles'),
      wbInteger('Default Number of Slices', itU16),
      wbInteger('Default Number of Tiles - Relative to Length', itU16, wbBoolEnum),
      wbFloatColors('Default Color'),
      wbFloat('Wind Settings - Sensibility'),
      wbFloat('Wind Settings - Flexibility')
    ]),
    wbFormIDCk(TNAM, 'Texture', [TXST])
  ]);

  wbRecord(CMPO, 'Component', [
    wbEDID,
    wbOBND,
    wbFULL,
    wbCUSD,
    wbVCRY,
    wbInteger(DATA, 'Auto Calc Value', itU32),
    wbFormIDCk(MNAM, 'Scrap Item', [MISC]),
    wbFormIDCk(GNAM, 'Mod Scrap Scalar', [GLOB]),
    wbCVPA,
    wbArray(ILAC, 'Item Scrap Quantities', wbStruct('Item Scrap Quantity', [
      wbInteger('Record Signature', itU32, wbEnum([], [
        Sig2Int(ARMO), 'ARMO',
        Sig2Int(WEAP), 'WEAP'
      ])),
      wbFormIDCk('Curve Table', [CURV])
    ]))
  ]);

  wbRecord(DFOB, 'Default Object', [
    wbEDID,
    wbFormID(DATA, 'Object')
  ])
  .IncludeFlag(dfIndexEditorID);

  wbRecord(DMGT, 'Damage Type', [
    wbEDID,
    wbFULL,
    wbStruct(DNAM,'Damage Type', [
      wbUnion('Actor Value', wbFormVersionDecider(78), [
        wbInteger('Actor Value Index', itU32, wbActorValueEnum),
        wbFormIDck('Actor Value', [AVIF, NULL])
      ]),
      wbFormIDck('Spell', [SPEL, NULL])
    ])
  ]);

  wbRecord(GDRY, 'God Rays', [
    wbEDID,
    wbStruct(DATA, 'Data', [
      wbFloatColors('Back Color'),
      wbFloatColors('Fwd Color'),
      wbFloat('Intensity'),
      wbFloat('Air Color - Scale'),
      wbFloat('Back Color - Scale'),
      wbFloat('Fwd Color - Scale'),
      wbFloat('Back Phase'),
      wbFloatColors('Air Color'),
      wbFloat('Fwd Phase')
    ])
  ]);

  wbRecord(INNR, 'Instance Naming Rules',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbString(INRF, 'Instance Naming Filter'),
    wbInteger(UNAM, 'Target', itU32, wbEnum([], [
        0, 'None',
      $1D, 'Armor',
      $2D, 'Actor',
      $2A, 'Furniture',
      $2B, 'Weapon'
    ])),
    wbRArray('Ruleset Names', wbString(ZNAM, 'Ruleset Name')),
    wbRArray('Naming Rules',
      wbRStruct('Ruleset', [
        wbInteger(VNAM, 'Count', itU32),
        // should not be sorted, but can be aligned
        wbRArray('Names',
          wbRStructSK([3, 0], 'Name', [
            wbLStringKC(WNAM, 'Text', 0, cpTranslate),
            wbKeywords,
            wbStruct(XNAM, 'Property', [
              wbFloat('Value'),
              wbInteger('Target', itU8, wbEnum([
                { 0} 'Enchantments',
                { 1} 'BashImpactDataSet',
                { 2} 'BlockMaterial',
                { 3} 'Keywords',
                { 4} 'Weight',
                { 5} 'Value',
                { 6} 'Rating',
                { 7} 'AddonIndex',
                { 8} 'BodyPart',
                { 9} 'DamageTypeValues',
                {10} 'ActorValues',
                {11} 'Health',
                {12} 'ColorRemappingIndex',
                {13} 'MaterialSwaps'
              ])),
              wbInteger('Op', itU8, wbEnum([
                {0} '>=',
                {1} '>',
                {2} '<=',
                {3} '<',
                {4} '='
              ]))
            ]),
            wbInteger(YNAM, 'Priority', itU16)
          ], []),
          cpNormal, False, nil, wbINNRAfterSet
        )
      ], [])
    )
  ]);

  wbRecord(KSSM, 'Sound Keyword Mapping', [
    wbEDID,
    wbFormIDCk(DNAM, 'Primary Descriptor', [SNDR]),
    wbFormIDCk(FNAM, 'Trigger Sound', [SNDR]),
    wbFormIDCk(ENAM, 'Exterior Tail', [SNDR]),
    wbFormIDCk(VNAM, 'VATS Descriptor', [SNDR]),
    wbFloat(TNAM, 'VATS Threshold'),
    wbRArray('Keywords', wbFormIDCk(KNAM, 'Keyword', [KYWD])),
    wbRArrayS('Sounds', wbStructSK(RNAM, [0], 'Sound', [
      wbInteger('Reverb Class', itU32, wbReverbClassEnum),
      wbFormIDCk('Descriptor', [SNDR])
    ]))
  ]);

  wbRecord(LAYR, 'Layer',
    wbFlags(wbFlagsList([
      {0x08000000} 27, 'Unknown 27'
    ])), [
    wbEDID,
    wbFormIDCk(PNAM, 'Parent', [LAYR]),
    wbByteRGBA(XCLP, 'Color')
  ]);

  wbRecord(LENS, 'Lens Flare', [
    wbEDID,
    wbFloat(CNAM, 'Color Influence'),
    wbFloat(DNAM, 'Fade Distance Radius Scale'),
    wbInteger(LFSP, 'Count', itU32, nil, cpBenign),
    wbRArrayS('Lens Flare Sprites',
      wbRStructSK([0], 'Flare', [
        wbString(DNAM, 'Lens Flare Sprite ID'),
        wbString(FNAM, 'Texture'),
        wbStruct(LFSD, 'Lens Flare Data', [
          wbFloatColors('Tint'),
          wbFloat('Width'),
          wbFloat('Height'),
          wbFloat('Position'),
          wbFloat('Angular Fade'),
          wbFloat('Opacity'),
          wbInteger('Flags', itU32, wbFlags([
            {0x01} 'Rotates',
            {0x02} 'Shrinks When Occluded'
          ]))
        ])
      ], []),
      cpNormal, False, nil, wbLENSAfterSet
    )
  ]);

  {wbRecord(LSPR, 'LSPR', [
    wbEDID
  ]);

  wbRecord(MICN, 'Menu Icon', [
    wbEDID
  ]); }

  wbRecord(MSWP, 'Material Swap',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9',
      {0x00010000} 16, 'Custom Swap',
      {0x00020000} 17, 'Unknown 17'
    ])), [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbString(FNAM, 'Tree Folder'), {First FNAM}
    wbRArrayS('Material Substitutions',
      wbRStructSK([0], 'Substitution', [
        wbString(BNAM, 'Original Material'),
        wbString(SNAM, 'Replacement Material'),
        wbString(FNAM, 'Tree Folder (obsolete)'), {Unused, will be moved up to First FNAM}
        wbFloat(CNAM, 'Color Remapping Index')
      ], [])
    )
  ]);

  wbRecord(NOCM, 'Navmesh Obstacle Manager', [
    wbRArray('Unknown',
      wbRStruct('Unknown', [
        wbInteger(INDX, 'Index', itU32),
        wbRArray('Unknown datas',
          wbStruct(DATA, 'Unknown data', [
            wbByteArray('Unknown 1',2),
            wbByteArray('Unknown 2',2),
            wbByteArray('Unknown 4',4)
          ])
        ),
        wbUnknown(INTV),
        wbString(NAM1, 'Model')
      ], [])
    )
  ]);

  wbUITE := wbEnum([
    'Repair',
    'Scrap & Stash'
  ]);

  wbUITO := wbEnum([
    'Set',
    'Add',
    'None'
  ]);

  wbRecord(UTIL, 'Utility', [
    wbEDID,
    wbOBND,
    wbPTRN,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbVCRY,
    wbDESC,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbUnknown(AQIC),
    wbRStruct('Utility Effect', [
      wbInteger(UITE, 'Utility Item Effect', itU32, wbUITE),
      wbInteger(UITO, 'Utility Effect Operator', itU32, wbUITO),
      wbFloat(UITV, 'Utility Effect Value'),
      wbInteger(UIFL, 'Unknown Flags', itU32, wbFlags([
        {0x00000001} 'Unknown 1',
        {0x00000002} 'Unknown 2'
      ])),
      wbFormIDCk(UIUS, 'Sound - Consume', [SNDR])
    ],[])
  ]);

  wbRecord(LGDI, 'Legendary Item', [
    wbEDID,
    wbOBND,
    wbPTRN,
    wbGenericModel,
    wbENLT,
    wbENLS,
    wbAUUV,
    wbFULL,
    wbVCRY,
    wbInteger(DATA, 'Scrip Cost', itU32),
    wbFormID(ANAM, 'Applicable Item List'),
    wbArray(BNAM, 'Legendary Mods', wbStruct('Legendary Mod', [
      wbInteger('Star Slot', itU32, wbLGDIStarSlot),
      wbFormID('Legendary Modifier')
    ])),

    wbArray(CNAM, 'Include Filters', wbStruct('Include Filter', [
      wbInteger('Star Slot', itU32, wbLGDIStarSlot),
      wbInteger('Referenced Mod', itU32, wbLGDIFiltersToStr).SetLinksToCallback(wbLGDIFiltersLinksTo),
      wbFormIDCk('Keyword', [KYWD])
    ])),

    wbArray(DNAM, 'Exclude Filters', wbStruct('Exclude Filter', [
      wbInteger('Star Slot', itU32, wbLGDIStarSlot),
      wbInteger('Referenced Mod', itU32, wbLGDIFiltersToStr).SetLinksToCallback(wbLGDIFiltersLinksTo),
      wbFormIDCk('Keyword', [KYWD])
    ])),
    wbFormID(ENAM, 'Legendary Template List')
  ]);

  wbRecord(NOTE, 'Note', [
    wbEDID,
    wbVMAD,
    wbOBND,
    wbPTRN,
    wbSNTP,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbICON,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbVCRY,
    wbInteger(DNAM, 'Type', itU8,
      wbEnum([
        'Sound',
        'Voice',
        'Program',
        'Terminal'
      ])
    ).SetRequired,
    wbStruct(DATA, 'Attributes', [      // was DNAM before form version 65. Now holds value and weight
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ]),
    wbUnion(SNAM, '', wbNoteTypeDecider, [
      wbUnused(4),
      wbFormIDCk('Sound', [SNDR]),
      wbFormIDCk('Scene', [SCEN]),
      wbFormIDCk('Terminal', [TERM])
    ]),
    wbDIQO,
    wbString(PNAM, 'Program File')
  ]);

  wbRecord(OMOD, 'Object Modification',
    wbFlags(wbFlagsList([
      {0x00000004} 2, 'Unknown 2',
      {0x00000010} 4, 'Legendary Mod',
      {0x00000040} 6, 'Unknown 6',
      {0x00000080} 7, 'Mod Collection',
      {0x00000100} 8, 'Mod Template',
      {0x00000200} 9, 'Mod Selector'
    ])), [
    wbEDID,
    wbDURL,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbDESC,
    wbGenericModel,
    wbInteger(INDX, 'Model Attach Index', itU8),
    wbStruct(DATA, 'Data', [
      wbInteger('Include Count', itU32),
      wbInteger('Property Count', itU32),
      wbInteger('Unknown Bool 1', itU8, wbBoolEnum),
      wbInteger('Unknown Bool 2', itU8, wbBoolEnum),
      wbInteger('Form Type', itU32, wbEnum([], [
        Sig2Int(ARMO), 'Armor',
        Sig2Int(NPC_), 'Non-player character',
        Sig2Int(WEAP), 'Weapon',
        Sig2Int(MSTT), 'Movable Static',
        Sig2Int(NONE), 'None'
      ])).SetDefaultEditValue('None'),
      wbFromVersion(90, wbInteger('Max Rank', itU8)),
      wbFromVersion(107, wbInteger('Level Tier Scaled Offset', itU8)),
      wbFormIDCk('Attach Point', [KYWD, NULL]),
      wbArray('Attach Parent Slots', wbFormIDCk('Keyword', [KYWD, NULL]), -1),
      // no way to change these in CK, legacy data leftover?
      wbArray('Items', wbStruct('Item', [
        wbByteArray('Value 1', 4),
        wbByteArray('Value 2', 4)
      ]), -1),
      // should not be sorted
      wbArray('Includes', wbStruct('Include', [
        wbFormIDCk('Mod', [OMOD]),
        wbInteger('Minimum Level', itU8),
        wbInteger('Optional', itU8, wbBoolEnum),
        wbInteger('Don''t Use All', itU8, wbBoolEnum)
      ]), wbOMODDataIncludeCounter, cpNormal, False, nil, wbOMODincludeAfterSet),
      wbObjectModProperties
    ], cpNormal, False, nil, -1, nil, wbOMODdataAfterSet),
    wbArray(MNAM, 'Target OMOD Keywords', wbFormIDCk('Keyword', [KYWD])),
    wbArray(FNAM, 'Filter Keywords', wbFormIDCk('Keyword', [KYWD])),
    wbFormIDCk(LNAM, 'Loose Mod', sigBaseObjects),
    wbFormIDCk(DNAM, 'Dependant Mod', [OMOD,NULL]),
    wbFormIDCk(ENAM, 'Condition Form', [CNDF]),
    wbFormID(XNAM, 'Possible Mod List'),
    wbInteger(NAM1, 'Priority', itU8),
    wbFormIDCk(ARTC, 'Art Object', [ARTO]),
    wbByteArray(NAM2, 'Unused', 0),
    wbArray(NAM3, 'Attribute Descriptor Keywords', wbFormIDCk('Keyword', [KYWD])),
    wbFLTR,
    wbString(OBST, 'Obstacle')
  ]);

  wbRecord(OVIS, 'Object Visibility Manager', [
    wbRArray('Static Objects',
      wbRStruct('Static Object', [
        wbFormIDCk(INDX, 'Object', [STAT]),
        wbStruct(DATA, 'Object Bounds', [
          wbFloat('X1'),
          wbFloat('Y1'),
          wbFloat('Z1'),
          wbFloat('X2'),
          wbFloat('Y2'),
          wbFloat('Z2')
        ])
        .SetSummaryKeyOnValue([0, 1, 2, 3, 4, 5])
        .SetSummaryPrefixSuffixOnValue(0, '(', '')
        .SetSummaryPrefixSuffixOnValue(2, '', ')')
        .SetSummaryPrefixSuffixOnValue(3, '(', '')
        .SetSummaryPrefixSuffixOnValue(5, '', ')')
        .SetSummaryDelimiterOnValue(', ')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed, wbCollapseObjectBounds)
      ], [])
    )
  ]);

  wbRecord(PKIN, 'Pack-In',
    wbFlags(wbFlagsList([
      {0x00000200}  9, 'Prefab',
      {0x00000400}  10, 'Unknown 10'
    ])), [
    wbEDID,
    wbOBND,
    wbOPDSs,
    wbVMAD,
    wbPTRN,
    wbSNTP,
    wbXALG,
    wbFLTR,
    wbOPDSs,
    wbFormIDCk(CNAM, 'Cell', [CELL]),
    wbInteger(VNAM, 'Version', itU32),
    wbUnknown(FNAM),
    wbRStruct('Child Pack-In', [
      wbInteger(GNAM, 'Child Pack-In Count', itU32),
      wbFormIDCk(HNAM, 'Child Pack-In', [PKIN]),
      wbArray(INAM, 'References', wbFormIDCk('Reference', [REFR]))
    ], []),
    wbKeywords,
    wbPRPS,
    wbLString(FULL, 'Name')
  ]);

  wbRecord(RFGP, 'Reference Group', [
    wbEDID,
    wbString(NNAM, 'Name'),
    wbFormIDCk(RNAM, 'Reference', sigReferences),
    wbFormID(PNAM, 'Pack-In Name'),
    wbFormID(LNAM, 'Connected Reference')
  ]);

  {wbRecord(RGDL, 'RGDL', [
    wbEDID
  ]);}

  wbRecord(SCCO, 'Scene Collection', [
    wbEDID,
    wbFormIDCk(QNAM, 'Quest', [QUST]),
    wbRArray('Scene Layout',
      wbRStruct('Scene', [
        wbFormIDCk(SNAM, 'Scene', [SCEN]),
        wbStruct(XNAM, 'Coordinates', [
          wbInteger('X', itS32),
          wbInteger('Y', itS32)
        ])
        .SetSummaryKeyOnValue([0, 1])
        .SetRequired
      ], [])
      .SetSummaryKey([0, 1])
      .IncludeFlag(dfCollapsed)
    ),
    wbUnknown(VNAM, cpNormal, True),
    wbRArray('Original Coordinates?',
      wbStruct(XNAM, 'Coordinates', [
        wbInteger('X', itS32),
        wbInteger('Y', itS32)
      ])
      .SetSummaryKeyOnValue([0, 1])
      .IncludeFlag(dfCollapsed)
    ),
    wbUnknown(VNAM, cpNormal, True)
  ]);

  var wbStaticPart :=
    wbRStruct('Part', [
      wbStruct(ONAM, 'Static', [
        wbFormIDCk('Static', [ACTI, ALCH, AMMO, BOOK, CONT, DOOR, FURN, MISC, MSTT, STAT, TERM, WEAP, CNCY, SCOL, FLOR]),
        wbFromSize(8, wbFormIDCK('Material Swap', [MSWP, REFR, NULL]))
      ]),
      wbStaticPartPlacements
    ], [], cpNormal);

  wbRecord(SCOL, 'Static Collection',
    wbFlags(wbFlagsList([
       4, 'Non Occluder',
       9, 'Hidden From Local Map',
      10, 'Unknown 10',
      11, 'Used as Platform',
      15, 'Has Distant LOD',
      25, 'Obstacle',
      26, 'Navmesh - Filter',
      27, 'Navmesh - Bounding Box',
      30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbSNTP,
    wbPHST,
    wbDEFL,
    wbXALG,
    wbGenericModel,
    wbFULL,
    wbUnknown(MNAM),
    wbNAM1LODP,
    wbPRPS,
    wbFLTR,
    wbRArray('Parts', wbStaticPart)
  ]);

  wbRecord(SCSN, 'Sound Category Snapshot', [
    wbEDID,
    wbInteger(PNAM, 'Priority', itU16),
    wbRArray('Category Multipliers', wbStruct(CNAM, 'Category Multiplier', [
      wbFormIDCk('Category', [SNCT]),
      wbFloat('Multiplier')
    ]))
  ]);

  {wbRecord(SKIL, 'SKIL', [
    wbEDID
  ]);}

  wbRecord(STAG, 'Animation Sound Tag Set', [
    wbEDID,
    wbXALG,
    wbRArray('Sounds', wbStruct(TNAM, 'Sound', [
      wbFormIDCk('Sound', [SNDR, NULL]),
      wbString('Action')
    ]))
  ]);

  wbRecord(TERM, 'Terminal',
    wbFlags(wbFlagsList([
      {0x00000004}  4, 'Non Occluder',
      {0x00002000} 13, 'Pack-In Use Only',
      {0x00008000} 15, 'Has Distant LOD',
      {0x00010000} 16, 'Random Anim Start'
    ])), [
    wbEDID,
    wbVMADFragmentedPERK, // same fragments format as in PERK
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbWTFG,
    wbSNTP,
    wbXALG,
    wbLStringKC(NAM0, 'Header Text'),
    wbLStringKC(WNAM, 'Welcome Text'),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbNAM1LODP,
    wbPRPS,
    wbByteRGBA(PNAM, 'Marker Color'),
    wbUnknown(AIID),
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR]),
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      'Unknown 0',
      'Unknown 1',
      'Unknown 2',
      'Unknown 3', {Currently Unused}
      'Unknown 4',
      'Unknown 5',
      'Unknown 6' {Currently Unused}
    ])),
    wbFloat(PAHD, 'Unknown Float'),
    wbCTRN,
    wbInteger(COCT, 'Holds Holotape (Count)', itU32),
    wbRArray('Holotapes',
      wbStruct(CNTO, 'Holotape', [
        wbFormIDCk('Item', [NULL, NOTE]),
        wbInteger('Count', itS32, nil, cpNormal, False, nil, nil, 1)
      ]),
      cpNormal, False, nil, wbTERMCNTOsAfterSet
    ),
    wbMNAMFurnitureMarker,
    wbByteArray(WBDT, 'Workbench Data (unused)', 0),
    wbString(XMRK, 'Marker Model'),
    wbSNAMMarkerParams,
    wbZNAMMarkerParams,
    wbUnknown(FFEF),
    wbInteger(BSIZ, 'Count', itU32, nil, cpBenign),
    wbRArray('Body Text',
      wbRStruct('Item', [
        wbLStringKC(BTXT, 'Text', 0, cpTranslate),
        wbCTDAs
      ], []),
      cpNormal, False, nil, wbTERMDisplayItemsAfterSet
    ),
    wbFormIDCk(QNAM, 'Quest', [QUST]),
    wbUnknown(TDAT),
    wbInteger(ISIZ, 'Count', itU32, nil, cpBenign),
    wbRArray('Menu Items',
      wbRStruct('Menu Item', [
        wbLStringKC(ITXT, 'Item Text', 0, cpTranslate),
        wbLStringKC(RNAM, 'Response Text', 0, cpTranslate),
        wbInteger(ANAM, 'Type', itU8, wbEnum([], [
           0, 'Unknown 0',
           1, 'Unknown 1',
           2, 'Unknown 2',
           3, 'Unknown 3',
           4, 'Submenu - Terminal',
           5, 'Submenu - Return to Top Level',
           6, 'Submenu - Force Redraw',
           7, 'Unknown 7',
           8, 'Display Text',
           9, 'Unknown 9',
          10, 'Unknown 10',
          11, 'Unknown 11',
          12, 'Unknown 12',
          13, 'Unknown 13',
          14, 'Unknown 14',
          15, 'Unknown 15',
          16, 'Display Image',
          68, 'Unknown 68',
          69, 'Unknown 69',
          70, 'Unknown 70',
          71, 'Unknown 71',
          72, 'Unknown 72'
        ]), cpNormal, True),
        wbInteger(ITID, 'Item ID', itU16),
        wbLStringKC(UNAM, 'Display Text', 0, cpTranslate),
        wbString(VNAM, 'Show Image'),
        wbFormIDCk(TNAM, 'Submenu', [TERM]),
        wbCTDAs
      ], []),
      cpNormal, False, nil, wbTERMMenuItemsAfterSet
    ),
    wbString(SCFC, 'Comments')
  ]);

  {wbRecord(TLOD, 'TLOD', [
    wbEDID
  ]);

  wbRecord(TOFT, 'TOFT', [
    wbEDID
  ]);}

  wbRecord(TRNS, 'Transform',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9',
      {0x00008000} 16, 'Around Origin'
    ])), [
    wbEDID,
    wbXALG,
    wbStruct(DATA, 'Data', [
      wbPosRot,
      wbFloat('Scale'),
      wbFloat('Zoom Min'),
      wbFloat('Zoom Max')
    ], cpNormal, True, nil, 2)
  ]);

{>>> Start of new Fallout 76 Records <<<}

// AAPD\RADR starts with two 0 bytes, a multiple of 16 (or 0xC8), and then either 0x40 or 0x41.
// AAPD\WTMX is always either 00 00 00 00 or 00 00 80 3F

  wbRecord(AAPD, 'Aim Assist Pose Data', [
    wbEDID,
    wbRStruct('Attach Point', [
      wbEmpty(AAAP, 'Attach Point Marker'),
      wbString(ANAM, 'Part'),
      wbString(BNAM, 'Part'),
      wbFloat(RADR),
      wbFloat(WTMX)
    ], []),
    wbInteger(AAPS, 'Count', itU64),
    wbRStructS('Connections', 'Connection', [
      wbString(ANAM, 'Part'),
      wbString(BNAM, 'Part'),
      wbFloat(RADR),
      wbFloat(WTMX)
    ], [])
  ]);

  wbRecord(AAMD, 'Aim Assist Model Data', [
    wbEDID,
    wbFloat(ANAM, 'Inner Cone Angle Degrees'),
    wbFloat(BNAM, 'Outer Cone Angle Degrees'),
    wbFloat(CNAM, 'Steering Degrees Per Sec'),
    wbFloat(DNAM, 'Pitch Scale'),
    wbFloat(ENAM, 'Inner Steering Ring'),
    wbFloat(FNAM, 'Outer Steering Ring'),
    wbFloat(GNAM, 'Friction'),
    wbFloat(HNAM, 'Move Follow Degrees Per Sec'),
    wbFloat(INAM, 'ADS Snap Steering Mult'),
    wbFloat(JNAM, 'ADS Snap Seconds'),
    wbFloat(KNAM, 'ADS Snap Cone Angle Degrees'),
    wbFloat(LNAM, 'No Steering'),
    wbFloat(MNAM, 'Bullet Bending Cone Angle Degrees'),
    wbFloat(NNAM, 'ADS Snap Steering Mutliplier Inner Ring'),
    wbFloat(ONAM, 'ADS Snap Steering Mutliplier Outer Ring'),
    wbFloat(PNAM, 'ADS Multiplier Inner Cone Angle Degrees'),
    wbFloat(QNAM, 'ADS Multiplier Outer Cone Angle Degrees'),
    wbFloat(RNAM, 'ADS Multiplier Inner Steering Ring'),
    wbFloat(SNAM, 'ADS Multiplier Outer Steering Ring'),
    wbFloat(TNAM, 'ADS Multiplier Friction'),
    wbFloat(UNAM, 'ADS Multiplier Steering Degrees Per Sec'),
    wbFloat(VNAM, 'Aim Assist Enabled')
  ]);

  wbRecord(SECH, 'Sound Echo Marker', [
    wbEDID,
    wbOBND,
    wbString(NNAM, 'Description'),
    wbRArray('Echos',
      wbRStruct('Echo', [
        wbRUnion('Echo Marker', [
          wbEmpty(ECHO, 'Echo Start Marker'),
          wbEmpty(ECHD, 'Echo Default Start Marker')
        ], []),
        wbFormIDCk(ETRG, 'Trigger', [SNDR]),
        wbFormIDCk(SDSC, 'Sound', [SNDR]),
        wbUnknown(ANAM),
        wbFloat(BNAM),
        wbUnknown(CNAM),
        wbUnknown(DNAM),
        wbUnknown(ENAM),
        wbString(NNAM, 'Description'),
        wbEmpty(ECHE, 'Echo End Marker')
      ], [])
    )
  ]);

  wbRecord(RESO, 'Resource',
    wbFlags(wbFlagsList([
       2, 'Unknown 2',
       9, 'Unknown 9',
      28, 'Unknown 28'
    ])), [
    wbEDID,
    wbFormIDCk(NAM1, 'Actor Value', [AVIF]),
    wbFormIDCk(NAM2, 'Produce', [LVLI, NULL]),
    wbFormIDCK(NAM4, 'Interval', [GLOB])
  ]);

  wbRecord(CURV, 'Curve Table', [
    wbEDID,
    wbString(CRVE, 'JSON File Path'),
    wbString(JASF, 'JSON File Path')
  ]);

  wbRecord(MSCS, 'Misc Item Spawner', [
    wbEDID,
    wbOBND,
    wbUnknown(DATA),
    wbRArray('Spawns', wbFormIDCk(SPWN, 'Spawn', [MISC]))
  ]);

  wbRecord(CNCY, 'Currency', [
    wbEDID,
    wbString(DURL, 'Singular Name'),
    wbOBND,
    wbPTRN,
    wbFULL,
    wbGenericModel,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbVCRY,
    wbDESC,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbUnknown(AQIC),
    wbInteger(MXCT, 'Max Currency', itU32),
    wbLString(SNAM, 'Plural Name'),
    wbInteger(CRTY, 'Collections Order', itU16),
    wbInteger(FNAM, 'Unknown Int', itU32)
  ]);

  wbRecord(PPAK, 'Perk Card Pack',
    wbFlags(wbFlagsList([
      {0x00000002} 2, 'Unknown: 2'
    ])), [
    wbEDID,
    wbOBND,
    wbPTRN,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True, nil, 1),
    wbFULL,
    wbGenericModel,
    wbDESC,
    wbKeywords,
    wbRArrayS('Perk Cards', wbRStruct('Perk Card', [
       wbEmpty(PRKE,'Perk Card Start'),
       wbByteArray(DATA, 'Unknown', 4),
       wbFormIDCk(PCDP, 'Perk Card', [PCRD]),
       wbEmpty(PRKF, 'Perk Card End')
    ],[])),
    wbVCRY,
    wbFormIDCk(PPRL, 'Roll Chances', [FLST]),
    wbFormIDCk(PPFC, 'Gold Roll Chances', [FLST]),
    wbFormIDCk(PPCL, 'Rarity Tables', [FLST]),
    wbFormIDCk(PPLO, 'Level Offsets', [FLST, CURV]),
    wbUnknown(PPAD)
  ]);

  wbRecord(PACH, 'Power Armor Chassis', [
    wbEDID,
    wbOBND,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True, nil, 1),
    wbFULL,
    wbVCRY,
    wbFormIDCk(PAEQ, 'Default Power Armor Equipment', [LVLI])
  ]);

  wbSpecialTypeEnum := wbEnum([
    {0} 'Strength',
    {1} 'Perception',
    {2} 'Endurance',
    {3} 'Charisma',
    {4} 'Intelligence',
    {5} 'Agility',
    {6} 'Luck',
    {7} 'Unknown'
  ]);

  wbRecord(PCRD, 'Perk Card',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable'
    ])), [
    wbEDID,
    wbDESC,
    wbStruct(DATA, 'Unknown', [
      wbByteArray('Unknown', 4),
      wbInteger('Min Level', itU8),
      wbInteger('Special', itU8, wbSpecialTypeEnum),
      wbByteArray('Unknown', 2)
    ]),
    wbFormIDCk(PCDV, 'Perk Card Value', [GLOB]),
    wbFormIDCk(SNAM, 'Sound', [SNDR]),
    wbString(MNAM, 'Male Name'),
    wbString(FNAM, 'Female Name'),
    wbInteger(ANAM, 'Perk Card Flags', itU32, wbFlags([
      {0x1} 'Legendary Perk'
    ])),
    wbRArray('Perks',
      wbRStruct('Perk', [
        wbEmpty(PRKE, 'Start Marker'),
        wbInteger(DATA, 'Card Rank Cost', itU8),
        wbFormIDCk(MNAM, 'Male Perk', [PERK]),
        wbFormIDCk(FNAM, 'Female Perk', [PERK]),
        wbEmpty(PRKF, 'End Marker')
      ], [])
    )
  ]);

  var wbLeveledListEntryPerkCard :=
    wbRStructExSK([0], [1], 'Leveled List Entry', [
      wbUnion(LVLO, '', wbFormVersionDecider(174), [
        wbStructExSK([0, 2], [3], 'Base Data', [
          wbInteger('Level', itU16),
          wbByteArray('Unused', 2, cpIgnore, false, wbNeverShow),
          wbFormIDCk('Reference', [PCRD]),
          wbInteger('Count', itS16),
          wbInteger('Chance None', itU8),
          wbByteArray('Unused', 1, cpIgnore, false, wbNeverShow)
        ])
        .SetSummaryKey([0, 3, 2, 4])
        .SetSummaryMemberPrefixSuffix(0, '[', ']')
        .SetSummaryMemberPrefixSuffix(3, '', 'x')
        .SetSummaryMemberPrefixSuffix(2, '', '')
        .SetSummaryMemberPrefixSuffix(4, '{Chance None = ', '%}')
        .IncludeFlag(dfSummaryMembersNoName),
        wbFormIDCk('Reference', [PCRD])
      ]),
      wbCOED,
      wbCTDAs,
      wbUnknown(LVUD),
      wbLVOV,
      wbLVIV,
      wbLVLV,
      wbLVOG,
      wbLVLT
    ], [])
    .SetSummaryKey([0])
    .IncludeFlag(dfCollapsed, wbCollapseLeveledItems);

  wbRecord(LVPC, 'Leveled Perk Card', [
    wbEDID,
    wbLVLD,
    wbLStringKC(ONAM, 'Display Name', 0, cpTranslate),
    wbLVMV,
    wbLVCV,
    wbUnion(LVLF, 'Flags', wbFormVersionDecider(185), [
      wbInteger('', itU8, wbLVLFFlags),
      wbInteger('', itU16, wbLVLFFlags)
    ], cpNormal, True),
    wbLLCT,
    wbRArrayS('Leveled List Entries', wbLeveledListEntryPerkCard, cpNormal, False, nil, wbLVLOsAfterSet),
    wbUnknown(LVCL),
    wbUnknown(LVUO)
  ]);

  wbRecord(STND, 'Snap Template Node', [
    wbEDID,
    wbOBND,
    wbGenericModel,
    wbKeywords,
    wbByteRGBA(CNAM, 'Unknown Colors'),
    wbInteger(FNAM, 'Unknown Flags', itU32, wbFlags([
      {0x00000001} 'Unknown 0',
      {0x00000002} 'Unknown 1',
      {0x00000004} 'Unknown 2',
      {0x00000008} 'Unknown 3',
      {0x00000010} 'Unknown 4',
      {0x00000020} 'Unknown 5',
      {0x00000040} 'Unknown 6',
      {0x00000080} 'Unknown 7',
      {0x00000100} 'Unknown 8',
      {0x00000200} 'Unknown 9',
      {0x00000400} 'Unknown 10',
      {0x00000800} 'Unknown 11',
      {0x00001000} 'Unknown 12',
      {0x00002000} 'Unknown 13',
      {0x00004000} 'Unknown 14',
      {0x00008000} 'Unknown 15',
      {0x00010000} 'Unknown 16',
      {0x00020000} 'Unknown 17',
      {0x00040000} 'Unknown 18',
      {0x00080000} 'Unknown 19',
      {0x00100000} 'Unknown 20',
      {0x00200000} 'Unknown 21',
      {0x00400000} 'Unknown 22',
      {0x00800000} 'Unknown 23',
      {0x01000000} 'Unknown 24',
      {0x02000000} 'Unknown 25',
      {0x04000000} 'Unknown 26',
      {0x08000000} 'Unknown 27',
      {0x10000000} 'Unknown 28',
      {0x20000000} 'Unknown 29',
      {0x40000000} 'Unknown 30',
      {0x80000000} 'Unknown 31'
    ])),
    wbInteger(SNST, 'Unknown', itU32),
    wbRArray('Adjacent Snap Nodes', wbFormID(NNAM, 'Adjacent Snap Node')),
    wbRArray('Snap Angles', wbFloat(FLTV, 'Snap Angle'))
  ]);

  wbRecord(STMP, 'Snap Template', [
    wbEDID,
    wbPTRN,
    wbFormIDCk(PNAM, 'Parent', [STMP]),
    wbRArray('Nodes', wbStruct(ENAM, 'Node', [
      wbInteger('Node ID', itU32),
      wbFormIDCk('Node', [STND]),
      wbArray('Unknown', wbFloat('Unknown'), 4),
      wbFromVersion(187, wbFloat('Unknown')),
      wbFromVersion(187, wbFloat('Unknown')),
      wbFromVersion(187, wbInteger('Unknown', itU32))
   ])),
    wbRArray('Parent Nodes', wbRStruct('Parent Node', [
      wbInteger(ONAM, 'Node ID', itU32),
      wbStruct(TNAM, 'Unknown', [
        wbArray('Unknown', wbFloat('Unknown'), 4),
        wbFromVersion(187, wbFloat('Unknown')),
        wbFromVersion(187, wbFloat('Unknown'))
      ])
    ], [])),
    wbArray(BNAM, 'Unknown', wbFloat('Unknown'), 6),
    wbArray(GNAM, 'Unknown', wbFloat('Unknown'), 3),
    wbByteArray(UNAM, 'Unknown', 1),
    wbInteger(INAM, 'Next Node ID', itU32),
    wbUnknown(STPT),
    wbUnknown(SNFG)
  ]);

  wbRecord(GCVR, 'Ground Cover', [
    wbEDID,
    wbRArray('Grasses', wbRStruct('Grass', [
      wbFormID(GNAM, 'Grass Texture'),
      wbInteger(DNAM, 'Unknown Int', itU16)
    ], [])),
    wbRArray('Landscape Textures', wbFormID(LNAM, 'Landscape Texture')),
    wbFloat(YNAM),
    wbFloat(ZNAM, 'Unused Float')
  ]);

  wbRecord(EMOT, 'Emote', [
    wbEDID,
    wbOBND,
    wbXALG,
    wbFULL,
    wbFormID(RENT, 'Required Entitlement'),
    wbString(SNAM, 'Swf Class Name'),
    wbXFLG,
    wbFormID(CNAM, 'Category'),
    wbFormID(DNAM, 'Animation'),
    wbLStringKC(ACTV, 'Chat Box Text', 0, cpTranslate),
    wbKeywords
  ]);

  wbRecord(STHD, 'Spell Threshold Data', [
    wbEDID,
    wbFormID(SPIT, 'Spell Item'),
    wbFormID(SPLO, 'Spell Magic Effect'),
    wbArray(NAM0, 'Stages', wbStruct('Stage', [
      //wbByteArray('Unknown', 4),
      wbFloat('Unknown'),
      wbFormID('Message'),
      wbFromVersion(165, wbFormID('Secondary Message')),
      wbFromVersion(160, wbFormID('Global'))
    ]))
  ]);

  wbRecord(VOLI, 'Volumetric Lighting', [
    wbEDID,
    wbFloat(CNAM, 'Intensity'),
    wbFloat(DNAM, 'Custom Color - Contribution'),
    wbRFloatColors('Colors', [ENAM, FNAM, GNAM]),
    wbFloat(HNAM, 'Density - Contribution'),
    wbFloat(INAM, 'Density - Size'),
    wbFloat(JNAM, 'Density - Wind Speed'),
    wbFloat(KNAM, 'Density - Falling Speed'),
    wbFloat(LNAM, 'Phase Function - Contribution'),
    wbFloat(MNAM, 'Phase Function - Scattering'),
    wbFloat(NNAM, 'Sampling Repartition - Range Factor') { max 1.0 }
  ]);

  wbRecord(ECAT, 'Emote Category', [
    wbEDID,
    wbFULL,
    wbKeywords,
    wbString(SNAM, 'SWF Class Name')
  ]);

  wbRecord(ENTM, 'Entitlement',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbDESC,
    wbKeywords,
    wbString(SWFI, 'SWF Image'),
    wbLString(NNAM, 'Display Name'),
    wbEmpty(BEVA, 'Has SWF Image'),
    wbStorefrontData
  ]);

  wbRecord(COEN, 'Consumable Entitlement', [
    wbEDID,
    wbXALG,
    wbFULL,
    wbDESC,
    wbKeywords,
    wbFormID(CENT, 'Linked Object'),
    wbUnknown(FNAM),
    wbLStringKC(NNAM, 'Display Name', 0, cpTranslate),
    wbStorefrontData
  ]);

  wbRecord(CSEN, 'Crate Service Entitlement', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbKeywords
  ]);

  wbRecord(PMFT, 'Photo Mode Feature', [
    wbEDID,
    wbXALG,
    wbFTAGs,
    wbFULL,
    wbICON,
    wbCTDAs,
    wbUnknown(FNAM),
    //wbStruct(FNAM, 'Unknown', [
    //  wbInteger('Unknown 1', itU32),
    //  wbFloat('Unknown 2'),
    //  wbFloat('Unknown 3'),
    //  wbByteArray('Unknown 4', 4),
    //  wbByteArray('Unknown 5', 4),
    //  wbByteArray('Unknown 6', 4),
    //  wbByteArray('Unknown 7', 4),
    //  wbByteArray('Unknown 8', 4)
    //]),
    wbFormIDCk(INAM, 'Image Space', [IMAD]),
    wbFormIDCk(KNAM, 'Keyword', [KYWD])
  ]);

  wbRecord(CHAL, 'Challenge',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])),[
    wbEDID,
    wbWTFG,
    wbFTAGs,
    wbFULL,
    wbString(SNAM, 'Tracked Stat Used'),
    wbString(NNAM, 'Comment'),
    wbInteger(FNAM, 'Challenge Flags', itU32, wbFlags([
      {0x00000001} 'Repeatable',
      {0x00000002} 'Unknown 1',
      {0x00000004} 'Unknown 2',
      {0x00000008} 'Unknown 3'
    ])),
    wbInteger(TNAM, 'Required Count', itU32),
    wbXFLGLong, //Unused?
    wbFormIDCk(HNAM, 'Required Count Global', [GLOB]),
    wbInteger(CNAM, 'Challenge Frequency', itU32, wbEnum([
      'Daily',
      'Weekly',
      'Lifetime',
      'Monthly',
      'Event',
      'Seasonal'
    ])),
    wbInteger(ENAM, 'Challenge Category', itU32, wbEnum([
      'Character',
      'Survival',
      'Exploration',
      'Pets',
      'Combat',
      'Social',
      'World',
      'Tracker',
      'Sub Challenge (Unsorted)'
    ])),
    wbRArray('Pre-Requisites', wbFormIDCk(ANAM, 'Challenge', [CHAL])),
    wbCTDAs,
    wbRStruct('More Conditions', [
      wbEmpty(NEXT, 'Marker', cpNormal, True),
      wbCTDAs
    ],[]),
    wbRArray('Rewards', wbReward),
    wbString(JASF, 'Associated Json File'),
    wbFormIDCk(SCFL, 'SubChallenge Completion List', [FLST]),
    wbLStringKC(MNAM, 'Reward Display', 0, cpTranslate),
//    wbString(MNAM, 'Reward Display'), TODO: Prior to esm version 155
    wbString(RNAM, 'Reward Icon')
  ]);

  wbRecord(AVTR, 'Avatar', [
    wbEDID,
    wbXALG,
    wbFULL,
    wbString(SWFI, 'SWF Image'),
    wbFormID(RENT, 'Required Entitlement')
  ]);

  wbRecord(CNDF, 'Condition Form', [
    wbEDID,
    wbCTDAs
  ]);

  wbRecord(AUVF, 'AUVF - Unknown', [
    wbEDID,
    wbAUUV
  ]);

  wbRecord(MDSP, 'Model Swap' ,
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbXALG,
    wbRArray('Model Swaps', wbRStruct('Model Swap', [
      wbString(BNAM, 'Initial Model'),
      wbString(SNAM, 'New Model')
    ],[]))
  ]);

  wbRecord(EQWG, 'Event Quest Widget', [
  ]);

  wbRecord(CPRD, 'Challenge Pass Reward Data', [
    wbEDID,
    wbXALG,
    wbDESC,
    wbFULL,
    wbString(ANAM, 'Icon'),
    wbString(BNAM, 'Reward Rarity'),
    wbString(CNAM, 'Storefront Image Path'),
    wbString(DNAM, 'Storefront Preview Image'),
    wbRArray('Item Storefront Images',
      wbString(ENAM, 'Item Storefront Image')
    )
  ]);

  wbRecord(ASTM, 'Unknown - ASTM', [
    wbEDID,
    wbDESC,
    wbByteArray(ATAT, 'Unknown', 4),
    wbByteArray(ATSI, 'Unknown', 4)
  ]);

  wbRecord(GMRW, 'Gameplay Reward',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbFTAGs,
    wbFormIDCk(ANAM, 'Parent Quest', [QUST]),
    wbInteger(RWDS, 'Rewards Count', itU32),
    wbRArray('Rewards List', wbReward)
  ]);

  wbRecord(PEPF, 'Event Playlist' ,
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbFormID(EPEG, 'Playlist Enabled Global'),
    wbInteger(EPCD, 'Cooldown', itU32),
    wbInteger(EPPR, 'Priority', itU32),
    wbInteger(EPNQ, 'Unknown Int', itU32),
    wbRArray('Playlist Quests',
      wbRStruct('Quest Info', [
        wbFormID(EPQA, 'Quest'),
        wbFormIDCk(EPSI, 'Spell Modifier', [SPEL])
      ], [])
    ),
    wbInteger(EPFL, 'Unknown Byte', itU8)
  ]);

  wbRecord(QMDL, 'Quest Module' ,
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbVMAD,
    wbInteger(QMDI, 'Index', itU16),
    wbFormID(QMDQ, 'Associated Quest'),
    wbFormID(QMDP, 'Parent Quest'),
    wbInteger(QMDT, 'Unknown Timer', itU16),
    wbString(QMDN, 'Notes'),
    wbInteger(QMPO, 'Unknown Objective', itU16),
    wbInteger(QMOD, 'Objective Count', itU32),
    wbRArray('Module Objectives',
      wbRStruct('Module Objective', [
        wbInteger(QMOI, 'Index', itU16),
        wbLStringKC(QMOT, 'Text'),
        wbByteArray(QMTT, 'QMTT - Unknown 4 Bytes', 4),
        wbByteArray(QMTR, 'QMTR - Unknown 4 Bytes', 4)
      ],[])
    ),
    wbInteger(QMAD, 'Alias Count', itU32),
    wbRArray('Module Aliases',
      wbRStruct('Module Alias', [
        wbInteger(QMAI, 'Index', itU32),
        wbInteger(QMAO, 'Parent Quest Alias', itU32)
      ],[])
    ),
    wbInteger(QMSD, 'Stage Count', itU32),
    wbRArray('Module Stages',
      wbRStruct('Module Stage', [
        wbInteger(QMSI, 'Index', itU16),
        wbInteger(QMSO, 'Parent Quest Stage', itU16)
      ],[])
    )
  ]);

  wbRecord(LOUT, 'Loadout', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbSPCT,
    wbSPLOs,
    wbFormID(LIPC, 'Bonus Cards'),
    wbFormID(LEPC, 'Perk Card List'),
    wbFormID(LINV, 'Inventory'),
    wbStruct(LSPC, 'SPECIAL Values', [
      wbInteger('Strength', itU8),
      wbInteger('Perception', itU8),
      wbInteger('Endurance', itU8),
      wbInteger('Charisma', itU8),
      wbInteger('Intelligence', itU8),
      wbInteger('Agility', itU8),
      wbInteger('Luck', itU8)
    ]),
    wbInteger(LLVL, 'Loadout Level', itU16),
    wbUnknown(NAM0)
  ]);

  wbRecord(ATXO, 'ATX Default Object', [
    wbEDID,
    wbFormID(DATA, 'Object')
  ]);

  wbRecord(DCGF, 'Daily Content Group',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Unknown 2',
      {0x00000200}  9, 'Unknown 9'
    ])), [
    wbEDID,
    wbRArray('Quest List',
      wbFormID(DCGQ, 'Quest')
    ),
    wbByteArray(DCGS, 'DCGS - Unknown 4 bytes', 4),
    wbFormID(DCGL, 'Location'),
    wbByteArray(DCGB, 'DCGB - Unknown 4 bytes', 4)
  ]);

  wbRecord(DIST, 'District', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbFormID(DPRT, 'Parent District'),
    wbFormID(DQST, 'Quest'),
    wbFormID(DCLL, 'Cell'),
    wbString(DIMG, 'Image'),
    wbStruct(DPOS, 'Position', [
      wbFloat,
      wbFloat
    ]),
    wbUnknown(DICO)
  ]);

  wbRecord(WATR, 'Water', [
    wbEDID,
    wbFULL,
    wbInteger(ANAM, 'Opacity (unused)', itU8),
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      {0x01} 'Dangerous',
      {0x02} 'Unknown 1',
      {0x04} 'Directional Sound',
      {0x08} 'Unknown 3',
      {0x10} 'Unknown 4',
      {0x20} 'Unknown 5',
      {0x40} 'Unknown 6'
    ]), cpNormal, True),
    wbFormIDCk(TNAM, 'Material', [MATT]),
    wbFormIDCk(SNAM, 'Open Sound', [SNDR, NULL]),
    wbFormIDCk(XNAM, 'Consume Spell', [SPEL, ALCH]),
    wbFormIDCk(YNAM, 'Contact Spell', [SPEL]),
    wbFormIDCk(INAM, 'Image Space', [IMGS]),
    wbEmpty(DATA, 'Unused'),
    wbStruct(DNAM, 'Visual Data', [
      wbStruct('Fog Properties', [
        wbFloat('Depth Amount'),
        wbByteColors('Shallow Color'),
        wbByteColors('Deep Color'),
        wbFloat('Color Shallow Range'),
        wbFloat('Color Deep Range'),
        wbFloat('Shallow Alpha'),
        wbFloat('Deep Alpha'),
        wbFloat('Alpha Shallow Range'),
        wbFloat('Alpha Deep Range'),
        wbByteColors('Underwater Color'),
        wbFloat('Underwater Fog Amount'),
        wbFloat('Underwater Near Fog'),
        wbFloat('Underwater Far Fog')
      ]),
      wbStruct('Physical Properties', [
        wbFloat('Normal Magnitude'),
        wbFloat('Shallow Normal Falloff'),
        wbFloat('Deep Normal Falloff'),
        wbFloat('Reflectivity Amount'),
        wbFloat('Fresnel Amount'),
        wbFloat('Surface Effect Falloff'),
        wbStruct('Displacement Simulator', [
          wbFloat('Force'),
          wbFloat('Velocity'),
          wbFloat('Falloff'),
          wbFloat('Dampener'),
          wbFloat('Starting Size')
        ]),
        wbByteColors('Reflection Color')
      ]),
      wbStruct('Specular Properties', [
        wbFloat('Sun Specular Power'),
        wbFloat('Sun Specular Magnitude'),
        wbFloat('Sun Sparkle Power'),
        wbFloat('Sun Sparkle Magnitude'),
        wbFloat('Interior Specular Radius'),
        wbFloat('Interior Specular Brightness'),
        wbFloat('Interior Specular Power')
      ]),
      wbFloat('Unknown 1'),
      wbFloat('Unknown 2'),
      wbFloat('Unknown 3'),
      wbFloat('Unknown 4'),
      wbFloat('Unknown 5')
    ], cpNormal, True, nil, 4),
    wbUnknown(AWSD),
    wbByteArray(GNAM, 'Unused', 0),
    wbStruct(NAM0, 'Linear Velocity', [
      wbFloat('X'),
      wbFloat('Y'),
      wbFloat('Z')
    ], cpNormal, False).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
    wbStruct(NAM1, 'Angular Velocity', [
      wbFloat('X'),
      wbFloat('Y'),
      wbFloat('Z')
    ], cpNormal, False).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
    wbString(NAM2, 'Layer 1 Noise Texture'),
    wbString(NAM3, 'Layer 2 Noise Texture'),
    wbString(NAM4, 'Layer 3 Noise Texture'),
    wbString(NAM5, 'Flow Normals Noise Texture'),
    wbUnknown(NAM6),
    wbUnknown(NAM7)
  ]);

  wbRecord(WAVE, 'Wave Encounter', [
    wbEDID,
    wbKeywords,
    wbArray(WAVD, 'Wave Encounter Definitions', wbStruct('Wave Encounter Definition', [
      wbInteger('Spawn Order', itU32),
      wbFormID('Spawn Reference'),
      wbInteger('Unknown', itU32)
    ])),
    wbUnknown(DNAM)
  ]);

  wbRecord(WEAP, 'Weapon',
    wbFlags(wbFlagsList([
      {0x00000004}  2, 'Non-Playable',
      {0x20000000} 30, 'High-Res 1st Person Only'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbOPDSs,
    wbPTRN,
    wbOPDSs,
    wbSTCP,
    wbSNTP,
    wbPHST,
    wbXALG,
    wbFULL,
    wbGenericModel,
    wbICON,
    wbMICO,
    wbEITM,
    wbInteger(EAMT, 'Enchantment Amount', itU16),
    wbDEST,
    wbETYP,
    wbFormIDCk(BIDS, 'Block Bash Impact Data Set', [IPDS, NULL]),
    wbFormIDCk(BAMT, 'Alternate Block Material', [MATT, NULL]),
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbDESC,
    wbFormIDCk(INRD, 'Instance Naming', [INNR]),
    wbEILV,
    wbIBSD,
    wbAPPR,
    wbObjectTemplate,
    wbFromVersion(76, NNAM, wbFormIDCk('Embedded Weapon Mod', [OMOD])),
    wbRStruct('1st Person Model', [
      wbString(MOD4, 'Model FileName'),
      wbModelInfo(MO4T),
      wbMO4S,
      wbMO4C,
      wbMO4F,
      wbENLT,
      wbENLS,
      wbAUUV
    ], []).IncludeFlag(dfAllowAnyMember),
    wbStruct(DNAM, 'Data', [
      wbFormIDCk('Ammo', [AMMO, NULL]),
      wbFloat('Speed'),
      wbFromVersion(61, wbFloat('Reload Speed')),
      wbFromVersion(177, wbFloat('NPC Reload Delay')),
      wbFloat('Reach'),
      wbFromVersion(140,  wbFloat('Reach Engagement Mult')),
      wbFloat('Min Range'),
      wbFloat('Max Range'),
      wbFromVersion(139, wbFloat('Unknown')),
      wbFloat('Attack Delay Seconds'),
      wbFloat('Unused'),
      wbFloat('Damage - OutOfRangeMult'),
      wbInteger('On Hit', itU32, wbHitBehaviourEnum),
      wbFormIDCk('Skill', [AVIF, NULL]),
      wbFormIDCk('Resist', [AVIF, NULL]),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Player Only',
        {0x00000002} 'NPCs Use Ammo',
        {0x00000004} 'No Jam After Reload',
        {0x00000008} 'Charging Reload',
        {0x00000010} 'Minor Crime',
        {0x00000020} 'Fixed Range',
        {0x00000040} 'Not Used In Normal Combat',
        {0x00000080} 'Unknown 8',
        {0x00000100} 'Crit Effect - on Death',
        {0x00000200} 'Charging Attack',
        {0x00000400} 'Alternate Rumble',
        {0x00000800} 'Hold Input To Power',
        {0x00001000} 'Non Hostile',
        {0x00002000} 'Bound Weapon',
        {0x00004000} 'Ignores Normal Weapon Resistance',
        {0x00008000} 'Automatic',
        {0x00010000} 'Repeatable Single Fire',
        {0x00020000} 'Can''t Drop',
        {0x00040000} 'Hide Backpack',
        {0x00080000} 'Embedded Weapon',
        {0x00100000} 'Not Playable',
        {0x00200000} 'Has Scope',
        {0x00400000} 'Bolt Action',
        {0x00800000} 'Secondary Weapon',
        {0x01000000} 'Disable Shells',
        {0x02000000} 'Unknown 26',
        {0x04000000} 'Unknown 27',
        {0x08000000} 'Unknown 28',
        {0x10000000} 'Unknown 29',
        {0x20000000} 'Unknown 30',
        {0x40000000} 'Unknown 31',
        {0x80000000} 'Unknown 32'
      ])),
      wbInteger('Capacity', itU16),
      wbFromVersion(200, wbInteger('Ammo used per shot', itU16)),
      wbInteger('Weapon Type', itU8, wbEnum([
        'HandToHandMelee',
        'OneHandSword',
        'OneHandDagger',
        'OneHandAxe',
        'OneHandMace',
        'TwoHandSword',
        'TwoHandAxe',
        'Bow',
        'Staff',
        'Gun',
        'Grenade',
        'Mine'
      ])),
      wbFloat('Secondary Damage'),
      wbFromVersion(54, wbFloat('Weight')),
      wbFromVersion(54, wbInteger('Value', itU32)),
      wbFromVersion(54, wbInteger('Base Damage', itU16)),
      wbFromVersion(55, wbStruct('Sound Data', [
        wbInteger('Sound Level', itU32, wbSoundLevelEnum),
        wbFormIDCk('Sound - Attack', [SNDR, NULL]),
        wbFormIDCk('Sound - Throwable Primed', [SNDR, NULL]),
        wbFormIDCk('Sound - Attack Loop', [SNDR, NULL]),
        wbFormIDCk('Sound - Attack Fail', [SNDR, NULL]),
        wbFormIDCk('Sound - Idle', [SNDR, NULL]),
        wbFormIDCk('Sound - Equip Sound', [SNDR, NULL]),
        wbFormIDCk('Sound - UnEquip Sound', [SNDR, NULL]),
        wbFromVersion(123, wbFormIDCk('Sound - Fast Equip Sound', [SNDR, NULL]))
      ])),

      wbFromVersion(67, wbUnion('AccuracyBonus', wbFormVersionDecider(108), [
        wbInteger('Accuracy Bonus', itU32),
        wbInteger('Accuracy Bonus', itU8)
      ])),
      wbFromVersion(74, wbFloat('Animation Attack Seconds')),
      wbFromVersion(75, wbInteger('Rank', itU16)),
      wbFromVersion(77, wbFloat('Action Point Cost')),
      wbFromVersion(103, wbFloat('Full Power Seconds')),
      wbFromVersion(105, wbFloat('Min Power Per Shot')),
      wbFromVersion(87, wbInteger('Stagger', itU32, wbStaggerEnum)),
      wbUnion('', wbFormVersionDecider(146), [
        wbByteArray('Unused', 4),
        wbFloat('Color Remapping Index')
      ]),
      wbFromVersion(146, wbInteger('Health',itU32)),
      wbFromVersion(201, wbUnknown)
    ]),
    wbStruct(FNAM, '', [
      wbFloat('Animation Fire Seconds'),
      wbFloat('Rumble - Left Motor Strength'),
      wbFloat('Rumble - Right Motor Strength'),
      wbFloat('Rumble - Duration'),
      wbFloat('Animation Reload Seconds'),
      wbFromVersion(55, wbFloat('Bolt Anim Seconds')),
      wbFromVersion(66, wbFloat('Sighted Transition Seconds')),
      wbInteger('# Projectiles', itU8),
      wbFromVersion(80, wbFormIDCk('Override Projectile', [PROJ, NULL])),
      wbFromVersion(126, wbInteger('Rumble Pattern', itU32, wbEnum([
        'Constant',
        'Square',
        'Triangle',
        'Sawtooth'
      ]))),
      wbFromVersion(126, wbInteger('Rumble - Period (ms)', itU32))
    ]),
    wbStruct(RGW2, '', [
      wbFormIDCk('Override Projectile', [PROJ, NULL]),
      wbFloat('Animation Fire Seconds'),
      wbFloat('Rumble - Left Motor Strength'),
      wbFloat('Rumble - Right Motor Strength'),
      wbFloat('Rumble - Duration'),
      wbFloat('Animation Reload Seconds'),
      wbFloat('Bolt Anim Seconds'),
      wbFloat('Sighted Transition Seconds'),
      wbFloat('Unsighted Transition Seconds'),
      wbFloat('Min Weapon Draw Time'),
      wbInteger('Rumble - Period (ms)', itU32),
      wbInteger('Rumble Pattern', itU32, wbEnum([
        'Constant',
        'Square',
        'Triangle',
        'Sawtooth'
      ])),
      wbInteger('# Projectiles', itU8)
    ]),
    wbStruct(RGW3, '', [
      wbFormIDCk('Override Projectile', [PROJ, NULL]),
      wbFloat('Animation Fire Seconds'),
      wbFloat('Rumble - Left Motor Strength'),
      wbFloat('Rumble - Right Motor Strength'),
      wbFloat('Rumble - Duration'),
      wbFloat('Animation Reload Seconds'),
      wbFloat('Bolt Draw Speed'),
      wbFloat('Sighted Transition Seconds'),
      wbFloat('Unsighted Transition Seconds'),
      wbFloat('Min Weapon Draw Time'),
      wbFloat('Damage Bonus Multiplier'),
      wbInteger('Rumble - Period (ms)', itU32),
      wbInteger('Rumble Pattern', itU32, wbEnum([
        'Constant',
        'Square',
        'Triangle',
        'Sawtooth'
      ])),
      wbInteger('# Projectiles', itU8)
    ]),
    wbStruct(CRDT, 'Critical Data', [
      wbFloat('Crit Damage Mult'),
      wbFloat('Crit Charge Bonus'),
      wbFormIDCk('Crit Effect', [SPEL, NULL])
    ]),
    wbFormIDCk(INAM, 'Impact Data Set', [IPDS]),
    wbFormIDCk(LNAM, 'NPC Add Ammo List', [LVLI]),
    wbFormIDCk(WAMD, 'Aim Model', [AMDL]),
    wbFormIDCk(WAAM, 'Aim Assist Model', [AAMD]),
    wbFormIDCk(WZMD, 'Zoom', [ZOOM]),
    wbFormIDCk(CNAM, 'Template', [WEAP]),
    wbDamageTypeArray('Damage Type'),
    wbFLTR,
    wbVCRY,
    wbFloat(WMCT, 'Minimum Charge Time'),
    wbFormIDCk(CVT0, 'Damage Curve', [CURV]),
    wbFormIDCk(CVT1, 'Min Durability Curve', [CURV]),
    wbFormIDCk(CVT2, 'Condition Loss Scale', [CURV]),
    wbFormIDCk(CVT3, 'Bash Condition Loss Scale', [CURV]),
    wbFormIDCk(CVT4, 'Max Durability Curve', [CURV]),
    wbFormIDCk(CVT5, 'Unknown Curve', [CURV]),
    wbInteger(MASE, 'Melee Speed', itU32, wbEnum([
      'Very Slow',
      'Slow',
      'Medium',
      'Fast',
      'Very Fast'
    ])),
    wbDAMS,
    wbFloat(WTDT, 'Telegraphed Time'),
    wbFormIDCk(WTDA, 'Telegraghed Art Object', [RFCT]),
    wbFormIDCk(WTDS, 'Telegraphed Sound Effect', [SNDR]),
    wbFloat(WSAM, 'Telegraphed Sound Amplitude')
  ], False, nil, cpNormal, False, nil{wbWEAPAfterLoad});

  wbRecord(WTHR, 'Weather',
    wbFlags(wbFlagsList([
      9, 'Unknown 9'
    ])), [
    wbEDID,
    wbKeywords,
    wbWeatherCloudTextures,
    wbInteger(LNAM, 'Max Cloud Layers', itU32)
      .SetDefaultNativeValue(16)
      .SetRequired,
    wbFormIDCK(MNAM, 'Precipitation Type', [SPGD, NULL])
      .SetRequired,
    wbFormIDCK(NNAM, 'Visual Effect', [RFCT, NULL])
      .SetRequired,
    wbWeatherCloudSpeed,
    wbWeatherCloudColors,
    wbWeatherCloudAlphas,
    wbWeatherColors,
    wbArray(NAM4, 'Unknown',
      wbFloat('Unknown')
        .SetDefaultNativeValue(1),
    32).IncludeFlag(dfNotAlignable)
       .SetRequired,
    wbWeatherFogDistance,
    wbStruct(DATA, 'Data', [
      wbInteger('Wind Speed', itU8), // scaled 0..1
      wbUnused(2),
      wbInteger('Trans Delta', itU8), // scaled 0..0,25
      wbInteger('Sun Glare', itU8), // scaled 0..1
      wbInteger('Sun Damage', itU8), // scaled 0..1
      wbInteger('Precipitation - Begin Fade In', itU8), // scaled 0..1
      wbInteger('Precipitation - End Fade Out', itU8), // scaled 0..1
      wbInteger('Thunder/Lightning - Begin Fade In', itU8),
      wbInteger('Thunder/Lightning - End Fade Out', itU8),
      wbInteger('Thunder/Lightning - Frequency', itU8)
        .SetDefaultNativeValue(255),
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Weather - Pleasant',
          1, 'Weather - Cloudy',
          2, 'Weather - Rainy',
          3, 'Weather - Snow',
          4, 'Aurora - Always Visible',
          5, 'Aurora - Follows Sun Position',
          6, 'Rain Occlusion',
          7, 'HUD Rain Effects'
        ], False, 8))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbWeatherLightningColor,
      wbInteger('Visual Effect - Begin', itU8), // scaled 0..1
      wbInteger('Visual Effect - End', itU8), // scaled 0..1
      wbInteger('Wind Direction', itU8), // scaled 0..360
      wbInteger('Wind Direction Range', itU8), // scaled 0..180
      wbFromVersion(119, wbInteger('Wind Turbulance', itU8))
    ]).SetRequired,
    wbWeatherDisabledLayers,
    wbWeatherSounds,
    wbRArrayS('Sky Statics',
      wbFormIDCk(TNAM, 'Static', [STAT, NULL])
    ),
    wbWeatherImageSpaces,
    wbWeatherGodRays,
    wbWeatherVolumetricLighting,
    wbWeatherDirectionalLighting,
    wbRStruct('Aurora', [
      wbGenericModel
    ], []),
    wbFormIDCk(GNAM, 'Sun Glare Lens Flare', [LENS]),
    wbWeatherMagic,
    wbFloat(VNAM, 'Volatility Mult')
      .SetDefaultNativeValue(1)
      .SetRequired,
    wbFloat(WNAM, 'Visibility Mult')
      .SetDefaultNativeValue(1)
      .SetRequired,
    wbFloat(XNAM),
    wbFloat(ZNAM),
    wbFloat(YNAM),
    wbFloat(KNAM),
    wbFloat(INAM)
  ]);

  wbRecord(WSPR, 'Workshop Permissions', [
    wbEDID,
    wbFULL,
    wbDESC,
    wbStruct(DATA, 'Workshop Permissions', [
      wbInteger('PermissionFlags', itU32, wbFlags([
        'ACCESS_LOCKED_CONTAINERS',
        'ACCESS_LOCKED_DOORS',
        'ACCESS_LOCKED_TERMINALS',
        'ACCESS_WORKSHOP_INVENTORY_WHEN_BUILDING',
        'ACCESS_WORKSHOP_INVENTORY_WHEN_CRAFTING',
        'ACCESS_WORKSHOP_INVENTORY_IN_TRANSFER_MENU',
        'ACCESS_STORED_ITEMS_FOR_BUILDING',
        'BUILD',
        'LOCK_OWNED',
        'LOCK_UNOWNED',
        'MOVE_OWNED',
        'MOVE_UNOWNED',
        'REPAIR_OWNED',
        'REPAIR_UNOWNED',
        'SCRAP_OWNED',
        'SCRAP_UNOWNED',
        'STORE_OWNED',
        'STORE_UNOWNED',
        'REPLACE_OWNED',
        'REPLACE_UNOWNED',
        'WORKSHOP_AI_ARE_ALLIES',
        'WORKSHOP_TRAPS_ARE_ALLIES'
      ])),
      wbByteArray('Unused', 4)
    ])
  ]);

  wbRecord(WRLD, 'Worldspace',
    wbFlags(wbFlagsList([
      14, 'Partial Form',
      19, 'Can''t Wait'
    ]), [14]), [
    wbEDID,
    wbWorldLargeRefs,
    wbWorldMaxHeight,
    wbFULL,
    wbWorldFixedCenter,
    wbFormIDCk(LTMP, 'Interior Lighting', [LGTM])
      .SetDefaultNativeValue(196834),
    wbXEZN,
    wbXLCN,
    wbRStruct('Parent Worldspace', [
      wbFormIDCk(WNAM, 'World', [WRLD]),
      wbInteger(PNAM, 'Flags', itU16,
        wbFlags(wbSparseFlags([
          0, 'Use Land Data',
          1, 'Use LOD Data',
          2, 'Use Map Data',
          3, 'Use Water Data',
          4, 'Use Climate Data',
          6, 'Use Sky Cell'
        ], False, 7), True)
      ).SetRequired
       .IncludeFlag(dfCollapsed, wbCollapseFlags)
    ], []),
    wbFormIDCk(CNAM, 'Climate', [CLMT])
      .SetDefaultNativeValue(351)
      .SetIsRemovable(wbWorldClimateIsRemovable),
    wbFormIDCk(NAM2, 'Water', [WATR])
      .SetDefaultNativeValue(24)
      .SetIsRemovable(wbWorldWaterIsRemovable),
    wbWorldLODData,
    wbWorldLandData,
    wbString(ICON, 'Map Image'),
    wbRStruct('Cloud Model', [
      wbGenericModel
    ], []),
    wbWorldMapData,
    wbWorldMapOffset,
    wbFloat(NAMA, 'Distant LOD Multiplier')
      .SetDefaultNativeValue(1)
      .SetRequired,
    wbInteger(DATA, 'Flags', itU8,
      wbFlags(wbSparseFlags([
        0, 'Small World',
        1, 'Can''t Fast Travel',
        3, 'No LOD Water',
        4, 'No Landscape',
        5, 'No Sky',
        6, 'Fixed Dimensions',
        7, 'No Grass'
      ], False, 8), True)
    ).SetDefaultNativeValue(1)
     .SetRequired
     .IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbWorldObjectBounds,
    wbRArray('Ordered Lands Textures',
      wbFormIDCk(LNAM, 'Land Texture', [LTEX])
    ).IncludeFlag(dfNotAlignable),
    wbWorldRegionEditorMap,
    wbFormIDCk(ZNAM, 'Music', [MUSC]),
    wbString(NNAM, 'Canopy Shadow (unused)', 0, cpIgnore),
    wbString(XWEM, 'Water Environment Map'),
    wbString(TNAM, 'HD LOD Diffuse Texture'),
    wbString(UNAM, 'HD LOD Normal Texture'),
    wbWorldWaterHeightData,
    wbWorldLevelData,
    wbWorldOffsetData,
    wbWorldCellSizeData,
    wbWorldVisibleCellsData
  ]).SetAfterLoad(wbWorldAfterLoad)
    .SetAfterSet(wbWorldAfterSet);

  wbRecord(ZOOM, 'Zoom', [
    wbEDID,
    wbStruct(GNAM, 'Data', [
      wbFloat('FOV Mult')
        .SetDefaultNativeValue(1),
      wbInteger('Overlay', itU32, wbZoomOverlayEnum),
      wbFormIDCk('Imagespace Modifier', [IMAD, NULL]),
      wbVec3('Camera Offset'),
      wbFromVersion(187, wbFloat('FOVMultB')
        .SetDefaultNativeValue(1)),
      wbFromVersion(187, wbFloat('FOVMultC')
        .SetDefaultNativeValue(1))
    ]).SetRequired
  ]);

  wbRecord(PLYT, 'Player Title', [
    wbEDID,
    wbXALG,
    wbLStringKC(ANAM, 'Prefix', 0, cpTranslate),
    wbLStringKC(BNAM, 'Suffix', 0, cpTranslate),
    wbInteger(PTPR, 'Is Prefix', itU8, wbBoolEnum),
    wbInteger(PTSU, 'Is Suffix', itU8, wbBoolEnum),
    wbInteger(PTDS, 'Is Default Title', itU8, wbBoolEnum),
    wbConditions
  ]);

  wbAddGroupOrder(GMST);
  wbAddGroupOrder(KYWD);
  wbAddGroupOrder(ENTM); //new in Fallout 76
  wbAddGroupOrder(COEN); //new in Fallout 76
  wbAddGroupOrder(PCEN); //Unused after 1.0.0.2
  wbAddGroupOrder(CSEN); //new in Fallout 76
  wbAddGroupOrder(ECAT); //new in Fallout 76
  wbAddGroupOrder(EMOT); //new in Fallout 76
  wbAddGroupOrder(AVTR); //new in Fallout 76
  wbAddGroupOrder(CPRD); //new in Fallout 76
  wbAddGroupOrder(ASTM);
  wbAddGroupOrder(ATXO); //new in Fallout 76
  wbAddGroupOrder(LCRT);
  wbAddGroupOrder(AACT);
  wbAddGroupOrder(TRNS);
  wbAddGroupOrder(CMPO);
  wbAddGroupOrder(TXST);
  wbAddGroupOrder(MICN); //new in Fallout 76. Currently unused in esm
  wbAddGroupOrder(GLOB);
  wbAddGroupOrder(DMGT);
  wbAddGroupOrder(CLAS);
  wbAddGroupOrder(FACT);
  wbAddGroupOrder(HDPT);
  wbAddGroupOrder(EYES); //Unused in ESM. Used in EXE
  wbAddGroupOrder(RACE);
  wbAddGroupOrder(SOUN);
  wbAddGroupOrder(SECH); //new in Fallout 76
  wbAddGroupOrder(ASPC);
  wbAddGroupOrder(RESO); //new in Fallout 76
  wbAddGroupOrder(MGEF);
  wbAddGroupOrder(SCPT); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(LTEX);
  wbAddGroupOrder(ENCH);
  wbAddGroupOrder(SPEL);
  wbAddGroupOrder(SCRL); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(ACTI);
  wbAddGroupOrder(TACT);
  wbAddGroupOrder(CURV); //new in Fallout 76
  wbAddGroupOrder(ARMO);
  wbAddGroupOrder(BOOK);
  wbAddGroupOrder(CONT);
  wbAddGroupOrder(DOOR);
  wbAddGroupOrder(INGR);
  wbAddGroupOrder(LIGH);
  wbAddGroupOrder(MISC);
  wbAddGroupOrder(MSCS); //new in Fallout 76
  wbAddGroupOrder(MISI); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(CNCY); //new in Fallout 76
  wbAddGroupOrder(STAT);
  wbAddGroupOrder(SCOL);
  wbAddGroupOrder(MSTT);
  wbAddGroupOrder(GRAS);
  wbAddGroupOrder(TREE); // Currently an empty GRUP record
  wbAddGroupOrder(FLOR);
  wbAddGroupOrder(FURN);
  wbAddGroupOrder(WEAP);
  wbAddGroupOrder(AMMO);
  wbAddGroupOrder(NPC_);
  wbAddGroupOrder(LVLN);
  wbAddGroupOrder(LVLP); //new in Fallout 76
  wbAddGroupOrder(KEYM);
  wbAddGroupOrder(ALCH);
  wbAddGroupOrder(UTIL); //new in Fallout 76
  wbAddGroupOrder(IDLM);
  wbAddGroupOrder(NOTE);
  wbAddGroupOrder(PROJ);
  wbAddGroupOrder(HAZD);
  wbAddGroupOrder(BNDS);
  wbAddGroupOrder(SLGM); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(TERM);
  wbAddGroupOrder(PPAK); //new in Fallout 76
  wbAddGroupOrder(PACH); //new in Fallout 76
  wbAddGroupOrder(LVLI);
  wbAddGroupOrder(WTHR);
  wbAddGroupOrder(CLMT);
  wbAddGroupOrder(SPGD);
  wbAddGroupOrder(RFCT);
  wbAddGroupOrder(REGN);
  wbAddGroupOrder(NAVI);
  wbAddGroupOrder(CELL);
  wbAddGroupOrder(REFR); //new in Fallout 76
  wbAddGroupOrder(ACHR); //new in Fallout 76
  wbAddGroupOrder(PMIS); //new in Fallout 76
  wbAddGroupOrder(PARW); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(PGRE); //new in Fallout 76
  wbAddGroupOrder(PBEA); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(PFLA); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(PCON); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(PBAR); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(PHZD); //new in Fallout 76
  wbAddGroupOrder(WRLD);
  wbAddGroupOrder(LAND); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(NAVM); //new in Fallout 76
  wbAddGroupOrder(TLOD); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(DIAL); //new in Fallout 76
  wbAddGroupOrder(INFO); //new in Fallout 76
  wbAddGroupOrder(QUST);
  wbAddGroupOrder(IDLE);
  wbAddGroupOrder(PACK);
  wbAddGroupOrder(CSTY);
  wbAddGroupOrder(LSCR);
  wbAddGroupOrder(LVSP); //not contained in ESM but exists in exe load order
  wbAddGroupOrder(ANIO);
  wbAddGroupOrder(WATR);
  wbAddGroupOrder(EFSH);
  wbAddGroupOrder(TOFT); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(EXPL);
  wbAddGroupOrder(DEBR);
  wbAddGroupOrder(IMGS);
  wbAddGroupOrder(IMAD);
  wbAddGroupOrder(FLST);
  wbAddGroupOrder(PERK);
  wbAddGroupOrder(PCRD); //new in Fallout 76
  wbAddGroupOrder(LVPC); //new in Fallout 76
  wbAddGroupOrder(BPTD);
  wbAddGroupOrder(ADDN);
  wbAddGroupOrder(AVIF);
  wbAddGroupOrder(CAMS);
  wbAddGroupOrder(CPTH);
  wbAddGroupOrder(VTYP);
  wbAddGroupOrder(MATT);
  wbAddGroupOrder(IPCT);
  wbAddGroupOrder(IPDS);
  wbAddGroupOrder(ARMA);
  wbAddGroupOrder(ECZN); //not contained in ESM but exists in exe load order
  wbAddGroupOrder(LCTN);
  wbAddGroupOrder(MESG);
  wbAddGroupOrder(RGDL); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(DOBJ);
  wbAddGroupOrder(DFOB);
  wbAddGroupOrder(LGTM);
  wbAddGroupOrder(MUSC);
  wbAddGroupOrder(FSTP);
  wbAddGroupOrder(FSTS);
  wbAddGroupOrder(SMBN);
  wbAddGroupOrder(SMQN);
  wbAddGroupOrder(SMEN);
  wbAddGroupOrder(DLBR);
  wbAddGroupOrder(MUST);
  wbAddGroupOrder(DLVW); // Currently an empty GRUP record
  wbAddGroupOrder(WOOP); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(SHOU); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(EQUP);
  wbAddGroupOrder(RELA);
  wbAddGroupOrder(SCEN);
  wbAddGroupOrder(ASTP);
  wbAddGroupOrder(OTFT);
  wbAddGroupOrder(ARTO);
  wbAddGroupOrder(MATO);
  wbAddGroupOrder(MOVT);
  wbAddGroupOrder(SNDR);
  wbAddGroupOrder(DUAL); //not contained in ESM but exists in exe load order
  wbAddGroupOrder(SNCT);
  wbAddGroupOrder(SOPM);
  wbAddGroupOrder(COLL);
  wbAddGroupOrder(CLFM);
  wbAddGroupOrder(REVB);
  wbAddGroupOrder(PKIN);
  wbAddGroupOrder(RFGP);
  wbAddGroupOrder(AMDL);
  wbAddGroupOrder(AAMD); //not contained in ESM but exists in exe load order. Added in version 1.2.7.27
  wbAddGroupOrder(LAYR);
  wbAddGroupOrder(COBJ);
  wbAddGroupOrder(OMOD);
  wbAddGroupOrder(MSWP);
  wbAddGroupOrder(MDSP); //new in Fallout 76. Added in version 1.2.3.9
  wbAddGroupOrder(ZOOM);
  wbAddGroupOrder(INNR);
  wbAddGroupOrder(KSSM);
  wbAddGroupOrder(AECH);
  wbAddGroupOrder(SCCO);
  wbAddGroupOrder(AORU);
  wbAddGroupOrder(SCSN);
  wbAddGroupOrder(STAG);
  wbAddGroupOrder(NOCM);
  wbAddGroupOrder(LENS);
  wbAddGroupOrder(LSPR); //Currently unused in ESM
  wbAddGroupOrder(GDRY); //Currently empty GRUP in ESM and unused in exe load order
  wbAddGroupOrder(OVIS);
  wbAddGroupOrder(DLYR); //new in Fallout 76. Currently unused in ESM
  wbAddGroupOrder(STND); //new in Fallout 76
  wbAddGroupOrder(STMP); //new in Fallout 76
  wbAddGroupOrder(GCVR); //new in Fallout 76
  wbAddGroupOrder(PLYR); //Currently unused in ESM
  wbAddGroupOrder(STHD); //new in Fallout 76
  wbAddGroupOrder(VOLI); //new in Fallout 76
  wbAddGroupOrder(WSPR); //new in Fallout 76
  wbAddGroupOrder(WAVE); //new in Fallout 76
  wbAddGroupOrder(AAPD); //new in Fallout 76
  wbAddGroupOrder(PMFT); //new in Fallout 76
  wbAddGroupOrder(CHAL); //new in Fallout 76
  wbAddGroupOrder(CNDF); //new in Fallout 76
  wbAddGroupOrder(AUVF); //new in Fallout 76
  wbAddGroupOrder(LGDI); //new in Fallout 76
  wbAddGroupOrder(EQWG); //new in Fallout 76
  wbAddGroupOrder(PEPF); //new in Fallout 76 0.2.782.0
  wbAddGroupOrder(GMRW); //new in Fallout 76 0.2.782.0
  wbAddGroupOrder(DCGF); //new in Fallout 76
  wbAddGroupOrder(QMDL); //new in Fallout 76
  wbAddGroupOrder(LOUT); //new in Fallout 76
  wbAddGroupOrder(DIST); //new in Fallout 76
  wbAddGroupOrder(PLYT); //new in Fallout 76 1.7.17.9 //This is indeed tacked onto the end of the group order in the exe.
  wbNexusModsUrl := 'https://www.nexusmods.com/fallout76/mods/30';
  {if wbToolMode = tmLODgen then
    wbNexusModsUrl := '';}
  wbHEDRVersion := 224.0;
end;

initialization
end.

