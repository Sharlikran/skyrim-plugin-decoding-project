{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License, 
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain 
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbDefinitionsCommon;

{$I wbDefines.inc}

interface
uses
  Variants,
  wbInterface,
  wbDefinitionsSignatures;

  type
  TwbVarRecs = TArray<TVarRec>;

var
  _FlagDeciders : array of TwbUnionDecider;
  _FormVersionDeciders : array of TwbUnionDecider;
  _RecordSizeDeciders : array of TwbUnionDecider;

  wbActorImpactMaterialEnum: IwbEnumDef;
  wbAggressionEnum: IwbEnumDef;
  wbAlignmentEnum: IwbEnumDef;
  wbArchtypeEnum: IwbEnumDef;
  wbAssistanceEnum: IwbEnumDef;
  wbAttackAnimationEnum: IwbEnumDef;
  wbAxisEnum: IwbEnumDef;
  wbBlendModeEnum: IwbEnumDef;
  wbBlendOpEnum: IwbEnumDef;
  wbBodyLocationEnum: IwbEnumDef;
  wbBodyPartIndexEnum: IwbEnumDef;
  wbBoolEnum: IwbEnumDef;
  wbConfidenceEnum: IwbEnumDef;
  wbCRCValuesEnum: IwbEnumDef;
  wbCriticalStageEnum: IwbEnumDef;
  wbCrimeTypeEnum: IwbEnumDef;
  wbCreatureTypeEnum: IwbEnumDef;
  wbEffectTypeEnum: IwbEnumDef;
  wbEquipTypeEnum: IwbEnumDef;
  wbMenuModeEnum: IwbEnumDef;
  wbMoodEnum: IwbEnumDef;
  wbMoralityEnum: IwbEnumDef;
  wbMusicEnum: IwbEnumDef;
  wbPackageTypeEnum: IwbEnumDef;
  wbQuadrantEnum: IwbEnumDef;
  wbQuestEventEnum: IwbEnumDef;
  wbSexEnum: IwbEnumDef;
  wbSoulGemEnum: IwbEnumDef;
  wbWorldImpactMaterialEnum: IwbEnumDef;
  wbZoomOverlayEnum: IwbEnumDef;
  wbZTestFuncEnum: IwbEnumDef;

  wbPackageFlags: IwbFlagsDef;
  wbServiceFlags: IwbFlagsDef;
  wbTemplateFlags: IwbFlagsDef;

  wbActionFlag: IwbRecordMemberDef;
  wbActorSounds: IwbRecordMemberDef;
  wbCellGrid: IwbRecordMemberDef;
  wbCinematicIMAD: IwbRecordMemberDef;
  wbDATAPosRot: IwbRecordMemberDef;
  wbDMDT: IwbRecordMemberDef;
  wbFaction: IwbRecordMemberDef;
  wbFactionRelations: IwbRecordMemberDef;
  wbHEDR: IwbRecordMemberDef;
  wbINOA: IwbRecordMemberDef;
  wbINOM: IwbRecordMemberDef;
  wbKWDAs: IwbRecordMemberDef;
  wbKeywords :IwbRecordMemberDef;
  wbMagicEffectSounds: IwbRecordMemberDef;
  wbMDOB: IwbRecordMemberDef;
  wbMHDTCELL: IwbRecordMemberDef;
  wbMODT: IwbRecordMemberDef;
  wbRagdoll: IwbRecordMemberDef;
  wbRegionSounds: IwbRecordMemberDef;
  wbSeasons: IwbRecordMemberDef;
  wbSoundDescriptorSounds: IwbRecordMemberDef;
  wbSoundTypeSounds: IwbRecordMemberDef;
  wbStaticPartPlacements: IwbRecordMemberDef;
  wbXLOD: IwbRecordMemberDef;

  wbAlternateTexture: IwbValueDef;
  wbColorInterpolator: IwbValueDef;
  wbNextSpeaker: IwbValueDef;
  wbPosRot: IwbValueDef;
  wbTimeInterpolator: IwbValueDef;

  wbLandNormals: IwbRecordMemberDef;
  wbLandHeights: IwbRecordMemberDef;
  wbLandColors: IwbRecordMemberDef;
  wbLandLayers: IwbRecordMemberDef;

  wbNavmeshTriangleFlags: IwbFlagsDef;
  wbNavmeshCoverFlags: IwbFlagsDef;
  wbNavmeshEdgeLinkEnum: IwbEnumDef;

  wbRegionAreas: IwbRecordMemberDef;

  wbWeatherCloudTextures: IwbRecordMemberDef;
  wbWeatherCloudSpeed: IwbRecordMemberDef;
  wbWeatherCloudColors: IwbRecordMemberDef;
  wbWeatherCloudAlphas: IwbRecordMemberDef;
  wbWeatherColors: IwbRecordMemberDef;
  wbWeatherFogDistance: IwbRecordMemberDef;
  wbWeatherLightningColor: IwbValueDef;
  wbWeatherDisabledLayers: IwbRecordMemberDef;
  wbWeatherSounds: IwbRecordMemberDef;
  wbWeatherImageSpaces: IwbRecordMemberDef;
  wbWeatherGodRays: IwbRecordMemberDef;
  wbWeatherVolumetricLighting: IwbRecordMemberDef;
  wbWeatherDirectionalLighting: IwbRecordMemberDef;
  wbWeatherMagic: IwbRecordMemberDef;

  wbWorldLargeRefs: IwbRecordMemberDef;
  wbWorldMaxHeight: IwbRecordMemberDef;
  wbWorldFixedCenter: IwbRecordMemberDef;
  wbWorldLODData: IwbRecordMemberDef;
  wbWorldLandData: IwbRecordMemberDef;
  wbWorldMapData: IwbRecordMemberDef;
  wbWorldMapOffset: IwbRecordMemberDef;
  wbWorldObjectBounds: IwbRecordMemberDef;
  wbWorldSwapsImpactData: IwbRecordMemberDef;
  wbWorldRegionEditorMap: IwbRecordMemberDef;
  wbWorldWaterHeightData: IwbRecordMemberDef;
  wbWorldLevelData: IwbRecordMemberDef;
  wbWorldOffsetData: IwbRecordMemberDef;
  wbWorldCellSizeData: IwbRecordMemberDef;
  wbWorldVisibleCellsData: IwbRecordMemberDef;

procedure DefineCommon;

{>>> Add Info Callbacks <<<} //10
function wbCellAddInfo(const aMainRecord: IwbMainRecord): string;
function wbDIALAddInfo(const aMainRecord: IwbMainRecord): string;
function wbDLBRAddInfo(const aMainRecord: IwbMainRecord): string;
function wbINFOAddInfo(const aMainRecord: IwbMainRecord): string;
function wbLANDAddInfo(const aMainRecord: IwbMainRecord): string;
function wbNAVMAddInfo(const aMainRecord: IwbMainRecord): string;
function wbPGRDAddInfo(const aMainRecord: IwbMainRecord): string;
function wbPlacedAddInfo(const aMainRecord: IwbMainRecord): string;
function wbROADAddInfo(const aMainRecord: IwbMainRecord): string;
function wbSCENAddInfo(const aMainRecord: IwbMainRecord): string;

{>>> After Load Callbacks <<<} //3
procedure wbAVIFSkillAfterLoad(const aElement: IwbElement);
procedure wbRPLDAfterLoad(const aElement: IwbElement);
procedure wbWorldAfterLoad(const aElement: IwbElement);

{>>> After Set Callbacks <<<} //28
procedure wbATANsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbBODCsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbBODSsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbCNTOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbConditionsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbConditionTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbContainerAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbCounterEffectsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbCTDAsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbConditionRunOnAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbLENSAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbMGEFAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbModelInfoAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbMorphPresetsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbNPCAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbNPCActorSoundsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbPERKPRKETypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbPRKRsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbRaceAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbSDLTListAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbSNDRRatesOfFireAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbSPLOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbTERMCNTOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbTERMDisplayItemsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbTERMMenuItemsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbUpdateSameParentUnions(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbWorldAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
procedure wbWwiseKeywordMappingTemplateAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);

{>>> Count Callbacks <<<} //8
function wbMHDTColumnsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbModelInfoAddonCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbModelInfoMaterialFileCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbModelInfoTextureFileCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbNavmeshGridCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbWeatherCloudColorsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbWorldColumnsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
function wbWorldRowsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;

{>>> Flag Don't Show Callbacks <<<} //6
function wbFlagNavmeshFilterDontSHow(const aElement: IwbElement): Boolean;
function wbFlagNavmeshBoundingBoxDontSHow(const aElement: IwbElement): Boolean;
function wbFlagNavmeshOnlyCutDontSHow(const aElement: IwbElement): Boolean;
function wbFlagNavmeshIgnoreErosionDontSHow(const aElement: IwbElement): Boolean;
function wbFlagNavmeshGroundDontSHow(const aElement: IwbElement): Boolean;
function wbFlagPartialFormDontShow(const aElement: IwbElement): Boolean;

{>>> Don't Show Callbacks <<<} //10
function wbCellInteriorDontShow(const aElement: IwbElement): Boolean;
function wbCellExteriorDontShow(const aElement: IwbElement): Boolean;
function wbModelInfoDontShow(const aElement: IwbElement): Boolean;
function wbREGNGrassDontShow(const aElement: IwbElement): Boolean;
function wbREGNImposterDontShow(const aElement: IwbElement): Boolean;
function wbREGNLandDontShow(const aElement: IwbElement): Boolean;
function wbREGNMapDontShow(const aElement: IwbElement): Boolean;
function wbREGNObjectsDontShow(const aElement: IwbElement): Boolean;
function wbREGNSoundDontShow(const aElement: IwbElement): Boolean;
function wbREGNWeatherDontShow(const aElement: IwbElement): Boolean;

{>>> Float Normalizers <<<} //1
function wbNormalizeToRange(aMin, aMax: Extended): TwbFloatNormalizer;

{>>> Get Functions <<<} //4
function wbGetItemStr(const aContainer: IwbContainerElementRef): string;
function wbGetPropertyValueArrayItems(const aContainer: IwbContainerElementRef): string;
function wbGetREGNType(aElement: IwbElement): Integer;
function wbGetScriptObjFormat(const aElement: IwbElement): Integer;

{>>> Get Conflict Priority Callbacks <<<} //3
procedure wbLandNormalsGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
procedure wbModelInfoGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
procedure wbModelInfoUnknownGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);

{>>> Integer Formaters <<<} //1
function wbBoolEnumSummary(const aTrueSummary: string; const aFalseSummary: string = ''): IwbEnumDef;

{>>> Is Removable Callbacks <<<} //9
function wbCellGridIsRemovable(const aElement: IwbElement): Boolean;
function wbCellLightingIsRemovable(const aElement: IwbElement): Boolean;
function wbModelInfoHeaderIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldLandDataIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldLODDataIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldMapDataIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldWaterIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldClimateIsRemovable(const aElement: IwbElement): Boolean;
function wbWorldImageSpaceIsRemovable(const aElement: IwbElement): Boolean;

{>>> Links To Callbacks <<<} //8
function wbConditionSummaryLinksTo(const aElement: IwbElement): IwbElement;
function wbCoverLinksTo(const aElement: IwbElement): IwbElement;
function wbEdgeLinksTo(aEdge: Integer; const aElement: IwbElement): IwbElement;
function wbEdgeLinksTo0(const aElement: IwbElement): IwbElement;
function wbEdgeLinksTo1(const aElement: IwbElement): IwbElement;
function wbEdgeLinksTo2(const aElement: IwbElement): IwbElement;
function wbTriangleLinksTo(const aElement: IwbElement): IwbElement;
function wbVertexLinksTo(const aElement: IwbElement): IwbElement;

{>>> Try Functions <<<} //6
function wbTryGetContainerFromUnion(const aElement: IwbElement; out aContainer: IwbContainer): Boolean;
function wbTryGetContainerRefFromUnionOrValue(const aElement: IwbElement; out aContainer: IwbContainerElementRef): Boolean;
function wbTryGetContainerWithValidMainRecord(const aElement: IwbElement; out aContainer: IwbContainerElementRef; out aMainRecord: IwbMainRecord): Boolean;
function wbTryGetContainingMainRecord(const aElement: IwbElement; out aMainRecord: IwbMainRecord): Boolean;
function wbTryGetMainRecord(const aElement: IwbElement; out aMainRecord: IwbMainRecord; aSignature: string = ''): Boolean;
function wbTrySetContainer(const aElement: IwbElement; aType: TwbCallbackType; out aContainer: IwbContainerElementRef): Boolean;

{>>> To Integer Callbacks <<<} //15
function Sig2Int(aSignature: TwbSignature): Cardinal; inline;
function wbConditionTypeToInt(const aString: string; const aElement: IwbElement): Int64;
function wbQuestStageToInt(const aString: string; const aElement: IwbElement): Int64;
function wbEdgeToInt(aEdge: Integer; const aString: string; const aElement: IwbElement): Int64;
function wbEdgeToInt0(const aString: string; const aElement: IwbElement): Int64;
function wbEdgeToInt1(const aString: string; const aElement: IwbElement): Int64;
function wbEdgeToInt2(const aString: string; const aElement: IwbElement): Int64;
function wbNVTREdgeToInt(const aString: string; const aElement: IwbElement): Int64;
function wbScaledInt4ToInt(const aString: string; const aElement: IwbElement): Int64;
function wbStrToInt(const aString: string; const aElement: IwbElement): Int64;
function wbVertexToInt(aVertex: Integer; const aString: string; const aElement: IwbElement): Int64;
function wbVertexToInt0(const aString: string; const aElement: IwbElement): Int64;
function wbVertexToInt1(const aString: string; const aElement: IwbElement): Int64;
function wbVertexToInt2(const aString: string; const aElement: IwbElement): Int64;
function wbWeatherCloudSpeedToInt(const aString: string; const aElement: IwbElement): Int64;

{>>> To String Callbacks <<<} //35
procedure wbABGRToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbAliasToStr(aInt: Int64; const aQuestRef: IwbElement; aType: TwbCallbackType): string;
procedure wbBGRAToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbClmtMoonsPhaseLength(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbClmtTime(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbConditionToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbConditionTypeToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbCrowdPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbEdgeToStr(aEdge: Integer; aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbEdgeToStr0(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbEdgeToStr1(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbEdgeToStr2(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbFactionRelationToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbFileHashCallback(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbFolderHashCallback(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbHideFFFF(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbItemToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbNVTREdgeToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbObjectPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbREFRNavmeshTriangleToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbRGBAToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbScaledInt4ToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
procedure wbScriptToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbScriptPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbScriptPropertyArrayToStr(const aContainer: IwbContainerElementRef; var PropertyType: string; var PropertyValue: string);
procedure wbScriptPropertyObjectToStr(const aContainer: IwbContainerElementRef; var PropertyName: string; var PropertyType: string; var PropertyValue: string);
procedure wbToStringFromLinksToSummary(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbToStringFromLinksToMainRecordName(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
procedure wbVec3ToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
function wbVertexToStr(aVertex: Integer; aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbVertexToStr0(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbVertexToStr1(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbVertexToStr2(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbVTXTPosition(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
function wbWeatherCloudSpeedToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;

{>>> Union Deciders <<<} //21
function wbCOEDOwnerDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbConditionCompValueDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbConditionParam3Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbConditionReferenceDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbFlagDecider(aFlag: Byte): TwbUnionDecider;
function wbFormVersionDecider(aVersion: Integer): TwbUnionDecider; overload;
function wbFormVersionDecider(aMinVersion, aMaxVersion: Integer): TwbUnionDecider; overload;
function wbFormVersionDecider(const aVersions: array of Integer): TwbUnionDecider; overload;
function wbGMSTUnionDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbModelInfoDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbNoFlagsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbNoteTypeDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbNAVIIslandDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbNAVIParentDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbNVNMParentDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbPxDTLocationDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbRecordSizeDecider(aSize: Integer): TwbUnionDecider; overload;
function wbRecordSizeDecider(aMinSize, aMaxSize: Integer): TwbUnionDecider; overload;
function wbRecordSizeDecider(const aSizes: array of Integer): TwbUnionDecider; overload;
function wbScriptObjFormatDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
function wbWwiseKeywordMappingSoundDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;

{>>> VarRecs <<<} //2
function wbCombineVarRecs(const a, b : array of const): TwbVarRecs;
function wbMakeVarRecs(const a : array of const): TwbVarRecs;

{>>> Common Function Definitions <<<}

{>>> IfThens Defs <<<} //4
function IfThen(aBoolean: Boolean; const aTrue: IwbRecordMemberDef; const aFalse: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IfThen(aBoolean: Boolean; const aTrue: IwbValueDef; const aFalse: IwbValueDef): IwbValueDef; overload;
function IfThen(aBoolean: Boolean; const aTrue: TwbSignature; const aFalse: TwbSignature): TwbSignature; overload;
function IfThen(aBoolean: Boolean; const aTrue: TwbToStrCallback; const aFalse: TwbToStrCallback): TwbToStrCallback; overload;

{>>> Flag IfThen Defs <<<} //6
function wbHasNoFlags(const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef; overload;
function wbHasNoFlags(const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef; overload;
function wbIsFlag(aFlag: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef; overload;
function wbIsFlag(aFlag: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef; overload;
function wbIsNotFlag(aFlag: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef; overload;
function wbIsNotFlag(aFlag: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef; overload;

{>>> Game Mode IfThen Defs <<<} //31
function IsTES3(const aDef1, aDef2: String): string; overload;
function IsTES4(const aDef1, aDef2: Integer): Integer; overload;
function IsTES4(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsTES4(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsTES4(const aDef1, aDef2: String): string; overload;
function IsTES4(const aDef1, aDef2: TwbSignature): TwbSignature; overload;
function IsTES4FO3(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsTES4FO3(const aDef1, aDef2: String): string; overload;
function IsFO3(const aDef1, aDef2: Integer): Integer; overload;
function IsFO3(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsFO3(const aDef1, aDef2: string): string; overload;
function IsFNV(const aDef1, aDef2: string): string; overload;
function IsFNV(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsFNV(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsTES5(const aDef1, aDef2: String): string; overload;
function IsTES5(const aDef1, aDef2: Cardinal): Cardinal; overload;
function IsTES5(const aDef1, aDef2: Integer): Integer; overload;
function IsTES5(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsTES5(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsSSE(const aDef1, aDef2: string): string; overload;
function IsSSE(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsSSE(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsFO4Plus(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsFO4Plus(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsFO4Plus(const aDef1, aDef2: string): string; overload;
function IsFO76(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsFO76(const aDef1, aDef2: string): string; overload;
function IsSF1(const aDef1, aDef2: Integer): Integer; overload;
function IsSF1(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef; overload;
function IsSF1(const aDef1, aDef2: IwbValueDef): IwbValueDef; overload;
function IsSF1(const aDef1, aDef2: string): string; overload;

{>>> Size IfThen Defs <<<} //4
function wbBelowSize(aSize: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef; overload;
function wbBelowSize(aSize: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef; overload;
function wbFromSize(aSize: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef; overload;
function wbFromSize(aSize: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef; overload;

{>>> Version IfThen Defs <<<} //4
function wbBelowVersion(aVersion: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef): IwbRecordMemberDef; overload;
function wbBelowVersion(aVersion: Integer; const aValue: IwbValueDef): IwbValueDef; overload;
function wbFromVersion(aVersion: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef): IwbRecordMemberDef; overload;
function wbFromVersion(aVersion: Integer; const aValue: IwbValueDef): IwbValueDef; overload;

{>>> Vec3 Defs <<<} //11
function wbVec3(const aName: string = 'Unknown'; const aPrefix: string = ''): IwbValueDef; overload;
function wbVec3(const aSignature: TwbSignature; const aName: string = 'Unknown'; const aPrefix: string = ''): IwbRecordMemberDef; overload;
function wbVec3Pos(const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbValueDef; overload;
function wbVec3PosTES3(const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbValueDef; overload;
function wbVec3Pos(const aSignature: TwbSignature; const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbRecordMemberDef; overload;
function wbVec3Rot(const aName: string = 'Rotation'; const aPrefix: string = 'Rot'): IwbValueDef; overload;
function wbVec3Rot(const aSignature: TwbSignature; const aName: string = 'Rotation'; const aPrefix: string = 'Rot'): IwbRecordMemberDef; overload;
function wbVec3PosRot(const aCombinedName: string = 'Position/Rotation'; const aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbValueDef; overload;
function wbVec3PosRot(const aSignature: TwbSignature; const aCombinedName: string = 'Position/Rotation'; aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbRecordMemberDef; overload;
function wbVec3PosRotDegrees(const aCombinedName: string = 'Position/Rotation'; const aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbValueDef; overload;
function wbVec3PosRotDegrees(const aSignature: TwbSignature; const aCombinedName: string = 'Position/Rotation'; aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string ='Pos'; const aRotPrefix: string = 'Rot'): IwbRecordMemberDef; overload;
function wbSizePosRot(aSignature: TwbSignature; aName: string; aPriority: TwbConflictPriority = cpNormal): IwbSubRecordDef; overload;

{>>> Color Defs <<<} //16
function wbAmbientColors(const aSignature: TwbSignature; const aName: string = 'Directional Ambient Lighting Colors'): IwbSubRecordDef; overload;
function wbAmbientColors(const aName: string = 'Directional Ambient Lighting Colors'): IwbStructDef; overload;
function wbByteColors(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbByteColors(const aName: string = 'Color'): IwbValueDef; overload;
function wbByteColorsTES3(const aName: string = 'Color'): IwbValueDef; overload;
function wbByteABGR(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbByteABGR(const aName: string = 'Color'): IwbValueDef; overload;
function wbByteRGBA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbByteRGBA(const aName: string = 'Color'): IwbValueDef; overload;
function wbByteBGRA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbByteBGRA(const aName: string = 'Color'): IwbValueDef; overload;
function wbCNAM(aRequired: Boolean = False): IwbRecordMemberDef;
function wbFloatColors(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbFloatColors(const aName: string = 'Color'): IwbValueDef; overload;
function wbRFloatColors(const aName: string = 'Color'; const aSigs: TwbSignatures = []): IwbRecordMemberDef;
function wbFloatRGBA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef; overload;
function wbFloatRGBA(const aName: string = 'Color'): IwbValueDef; overload;

{>>> Many Record Defs <<<} //2
function wbModelInfo(aSignature: TwbSignature; aName: string = ''): IwbRecordMemberDef;
function wbOBND(aRequired: Boolean = False): IwbRecordMemberDef;

{>>> Multiple Record Defs <<<} //3
function wbEnchantment(aCapacity: Boolean = False): IwbRecordMemberDef;
function wbLeveledListEntry(aObjectName: string; aSigs: TwbSignatures): IwbRecordMemberDef;
function wbOwnership(aSkipSigs: TwbSignatures = nil): IwbRecordMemberDef;
function wbTexturedModel(aSubRecordName     : string;
                         aSignatures        : TwbSignatures;
                         aTextureSubRecords : array of IwbRecordMemberDef)
                                            : IwbRecordMemberDef;

{>>> Record Header Def <<<} //1
function wbRecordHeader(aRecordFlags: IwbIntegerDef): IwbValueDef;

{>>> Climate Function Defs <<<} //1
function wbClimateTiming(aTimeCallback: TwbIntToStrCallback; aPhaseCallback: TwbIntToStrCallback): IwbRecordMemberDef;

{>>> Creature Function Defs <<<} //1
function wbModelInfos(aSignature: TwbSignature; aName: string = ''; aDontShow  : TwbDontShowCallback = nil): IwbRecordMemberDef;

{>>> Debris Function Defs <<<} //1
function wbDebrisModel(aTextureFileHashes: IwbRecordMemberDef): IwbRecordMemberDef;

{>>> Image Space Adapater Defs <<<} //1
function wbTimeInterpolators(const aSignature: TwbSignature; const aName: string): IwbRecordMemberDef;
function wbTimeInterpolatorsMultAdd(const aSignatureMult, aSignatureAdd: TwbSignature; const aName: string): IwbRecordMemberDef;

{>>> Perk Defs <<<} //1
function wbPerkEffectType(aAfterSetCallback: TwbAfterSetCallback): IwbValueDef;

{>>> Race Defs <<<} //1
function wbHeadPart(aHeadPartIndexEnum: IwbEnumDef = nil; aModel: IwbRecordMemberDef = nil; aHeadPartsAfterSet: TwbAfterSetCallback = nil): IwbRecordMemberDef;

{>>> Weather Defs <<<} //1
function wbWeatherTimeOfDay(const aName: string): IwbValueDef;


implementation

uses
  Classes,
  Math,
  StrUtils,
  SysUtils,
  System.Types,
  wbHelpers;

{>>> Add Info Callbacks <<<} //10

function wbCellAddInfo(const aMainRecord: IwbMainRecord): string;
var
  Rec : IwbRecord;
begin
  Result := aMainRecord.ElementEditValues['Worldspace'];
  if Result <> '' then
    Result := ' in ' + Result;

  if not aMainRecord.IsPersistent then begin
    Rec := aMainRecord.RecordBySignature['XCLC'];
    if Assigned(Rec) then
      Result := Result + ' at ' + Rec.Elements[0].Value + ',' + Rec.Elements[1].Value;
  end;
end;

function wbDIALAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  if wbIsSkyrim then
    Result := aMainRecord.ElementEditValues['QNAM']
  else
    Result := aMainRecord.ElementEditValues['Quest'];

  if Result <> '' then begin
    Result := ' in ' + Result;
  end;
end;

function wbDLBRAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Quest'];
  if Result <> '' then begin
    Result := ' in ' + Result;
  end;
end;

function wbINFOAddInfo(const aMainRecord: IwbMainRecord): string;
var
  Response : string;
begin
  Result := aMainRecord.ElementEditValues['Topic'];
  if Result <> '' then begin
    Result := ' in ' + Result;
  end;

  if wbGameMode in [gmTES4, gmFO3, gmFNV] then begin
    Result := Result + ' in ' + aMainRecord.ElementEditValues['QSTI'];
  end;

  if Result <> '' then begin
    Response := Trim(aMainRecord.ElementValues['Responses\Response\NAM1']);
    if Response <> '' then
      Result := '''''' + Response + '''''' + Result;
  end;
end;

function wbLANDAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Cell'];
  if Result <> '' then begin
    Result := ' in ' + Result;
  end;
end;

function wbNAVMAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Cell'];
  if Result <> '' then
    Result := ' in ' + Result;
end;

function wbPGRDAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Cell'];
  if Result <> '' then
    Result := ' in ' + Result;
end;

function wbPlacedAddInfo(const aMainRecord: IwbMainRecord): string;
var
  Cell      : IwbMainRecord;
  Container : IwbContainer;
  Grid      : TwbGridCell;
  Position  : TwbVector;
begin
  Result := aMainRecord.ElementEditValues['Cell'];
  if Result <> '' then
    Result := ' in ' + Result;

  if not aMainRecord.IsDeleted then begin
    Result := 'Places ' + Trim(aMainRecord.RecordBySignature['NAME'].Value) + Result;
    if Supports(aMainRecord.Container, IwbGroupRecord, Container) then
      Cell := IwbGroupRecord(Container).ChildrenOf;

    if Cell.IsPersistent and aMainRecord.GetPosition(Position) then begin
      Grid := wbPositionToGridCell(Position);
      Result := Result + ' at ' + IntToStr(Grid.X) + ',' + IntToStr(Grid.Y);
    end;

    if aMainRecord.HasPrecombinedMesh then
      Result := Result + ' in ' + aMainRecord.PrecombinedMesh;
  end;
end;

function wbROADAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Worldspace'];
  if Result <> '' then
    Result := ' in ' + Result;
end;

function wbSCENAddInfo(const aMainRecord: IwbMainRecord): string;
begin
  Result := aMainRecord.ElementEditValues['Quest'];
  if Result <> '' then begin
    Result := ' in ' + Result;
  end;
end;

{>>> After Load Callbacks <<<} //3

procedure wbAVIFSkillAfterLoad(const aElement: IwbElement);
begin
  if not Assigned(aElement) then
    Exit;

  if wbBeginInternalEdit then try
    if aElement.NativeValue > 3 then
      aElement.NativeValue := 0;
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbRPLDAfterLoad(const aElement: IwbElement);
var
  Container : IwbContainer;
  a, b      : Single;
  NeedsFlip : Boolean;
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

procedure wbWorldAfterLoad(const aElement: IwbElement);
  function OutOfRange(aValue: Integer; aRange: Integer = 256): Boolean;
    begin
      Result := (aValue < -aRange) or (aValue > aRange);
    end;
var
  MainRecord : IwbMainRecord;
  Container  : IwbContainer;
  rCLSZ      : IwbRecord;
  rVISI      : IwbRecord;
begin
  wbWorldAfterSet(aElement, 0, 0);

  if wbBeginInternalEdit then try

    if not Supports(aElement, IwbMainRecord, MainRecord) then
      Exit;

    if wbRemoveOffsetData then
      if not wbIsStarfield then
        if MainRecord._File.LoadOrder = 0 then
	        MainRecord.RemoveElement('Large References');

    // large values in worldspace bounds cause stutter and performance issues in game (reported by Arthmoor)
    // CK can occasionally set them wrong, so make a warning
    if Supports(MainRecord.ElementByName['Worldspace Bounds'], IwbContainer, Container) then
      if OutOfRange(StrToIntDef(Container.ElementEditValues['NAM0\X'], 0)) or
         OutOfRange(StrToIntDef(Container.ElementEditValues['NAM0\Y'], 0)) or
         OutOfRange(StrToIntDef(Container.ElementEditValues['NAM9\X'], 0)) or
         OutOfRange(StrToIntDef(Container.ElementEditValues['NAM9\Y'], 0))
      then
        wbProgressCallback('<Warning: Worldspace Bounds in ' + MainRecord.Name + ' are abnormally large and can cause performance issues in game>');
  finally
    wbEndInternalEdit;
  end;

  if wbBeginInternalEdit then try

    if not wbRemoveOffsetData then
      Exit;

    if not Supports(aElement, IwbContainer, Container) then
      Exit;

    Container.RemoveElement(CLSZ);
    Container.RemoveElement(VISI);
  finally
    wbEndInternalEdit;
  end else begin
    rCLSZ := Container.RecordBySignature[CLSZ];
    rVISI := Container.RecordBySignature[VISI];
    if Assigned(rCLSZ) then
      Container.RemoveElement(rCLSZ);
    if Assigned(rVISI) then
      Container.RemoveElement(rVISI);
  end;
end;

{>>> After Set Callbacks <<<} //28

procedure wbATANsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('ATCP - Activity Count', aElement);
end;

procedure wbBODCsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('BODM - Count', aElement);
end;

procedure wbBODSsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('BODC - Count', aElement);
end;

procedure wbCNTOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('COCT - Count', aElement);
end;

procedure wbConditionsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerAfterSet('CITC - Condition Count', 'Conditions', aElement);
end;

procedure wbConditionTypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  OldValue, NewValue : Integer;
  Container          : IwbContainerElementRef;
begin
  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  // reset value if "use global" has changed
  OldValue := aOldValue and 4;
  NewValue := aNewValue and 4;

  if OldValue <> NewValue then
    Container.ElementNativeValues['..\Comparison Value'] := 0;

  if (aNewValue and 2) and wbIsFallout3 then begin
    Container.ElementNativeValues['..\Run On'] := 1;
    if Integer(Container.ElementNativeValues['..\Run On']) = 1 then
      aElement.NativeValue := Byte(aNewValue) and not 2;
  end;
end;


procedure wbContainerAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerAfterSet('COCT - Count', 'Items', aElement);
end;

procedure wbCounterEffectsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  // if it is really possible to have both counter effects and multiple data, this is going to be tricky.
  wbCounterByPathAfterSet('Magic Effect Data\DATA - Data\Counter effect count', aElement);
end;

procedure wbCTDAsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('CITC - Condition Count', aElement);
end;

procedure wbConditionRunOnAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  if aOldValue <> aNewValue then
    if aNewValue <> 2 then
      aElement.Container.ElementNativeValues['Reference'] := 0;
end;

procedure wbLENSAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('LFSP - Count', aElement);
end;

procedure wbMGEFAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerByPathAfterSet('Magic Effect Data\DATA - Data\Counter effect count', 'Counter Effects', aElement);
end;

procedure wbModelInfoAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Addons    : IwbContainerElementRef;
  Container : IwbContainerElementRef;
  Headers   : IwbContainerElementRef;
  Materials : IwbContainerElementRef;
  Textures  : IwbContainerElementRef;
begin
  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  if Container.ElementCount < 4 then
    Exit;

  Container.BeginUpdate;
  try
    if not Supports(Container.Elements[0], IwbContainerElementRef, Headers) then
      Exit;
    if not Supports(Container.Elements[1], IwbContainerElementRef, Textures) then
      Exit;
    if not Supports(Container.Elements[2], IwbContainerElementRef, Addons) then
      Exit;
    if not Supports(Container.Elements[3], IwbContainerElementRef, Materials) then
      Exit;

    var MinHeaders := 0;
    if Materials.ElementCount > 0 then
      MinHeaders := 4
    else if Addons.ElementCount > 0 then
      MinHeaders := 2
    else if Textures.ElementCount > 0 then
      MinHeaders := 1;

    while Headers.ElementCount < MinHeaders do
      Headers.Add('');

    if Headers.ElementCount > 0 then
      if Headers.Elements[0].NativeValue <> Textures.ElementCount then
        Headers.Elements[0].NativeValue := Textures.ElementCount;
    if Headers.ElementCount > 1 then
      if Headers.Elements[1].NativeValue <> Addons.ElementCount then
        Headers.Elements[1].NativeValue := Addons.ElementCount;
    if Headers.ElementCount > 3 then
      if Headers.Elements[3].NativeValue <> Materials.ElementCount then
        Headers.Elements[3].NativeValue := Materials.ElementCount;
  finally
    Container.EndUpdate;
  end;
end;

procedure wbMorphPresetsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('MPPC - Count', aElement);
end;

procedure wbNPCAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerAfterSet('COCT - Count', 'Items', aElement);
  wbCounterContainerAfterSet('SPCT - Count', 'Actor Effects', aElement);
  wbCounterContainerAfterSet('LLCT - Count', 'Leveled List Entries', aElement);
  wbCounterContainerAfterSet('PRKZ - Perk Count', 'Perks', aElement);
end;

procedure wbNPCActorSoundsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('CS2H - Count', aElement);
end;

procedure wbPERKPRKETypeAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container: IwbContainerElementRef;
begin
  if not (aOldValue <> aNewValue) then
    Exit;

  if not Supports(aElement.Container, IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Container, IwbContainerElementRef, Container) then
    Exit;

  Container.RemoveElement('DATA');
  Container.Add('DATA', True);
  Container.RemoveElement('Perk Conditions');
  Container.RemoveElement('Entry Point Function Parameters');

  if not (aNewValue = 2) then
    Exit;

  Container.Add('EPFT', True);
  Container.ElementNativeValues['DATA\Entry Point\Function'] := 2;
end;

procedure wbPRKRsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('PRKZ - Perk Count', aElement);
end;

procedure wbRaceAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterContainerAfterSet('SPCT - Count', 'Actor Effects', aElement);
end;

procedure wbSDLTListAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('ITMC - Secondary List Count', aElement);
end;

procedure wbSNDRRatesOfFireAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('ITMC - Count', aElement);
end;

procedure wbSPLOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('SPCT - Count', aElement);
end;

procedure wbTERMCNTOsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('COCT - Holds Holotape (Count)', aElement);
end;

procedure wbTERMDisplayItemsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('BSIZ - Count', aElement);
end;

procedure wbTERMMenuItemsAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  wbCounterAfterSet('ISIZ - Count', aElement);
end;

procedure wbUpdateSameParentUnions(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  lContainer: IwbContainerElementRef;
begin
  if not Assigned(aElement) or not Supports(aElement.Container, IwbContainerElementRef, lContainer) then
    Exit;
  for var lElementIdx := 0 to Pred(lContainer.ElementCount) do
    //will trigger Unions to re-evaluate their type and fix themselves
    var lResolvedDef := lContainer.Elements[lElementIdx].ResolvedValueDef;
end;

procedure wbWorldAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  PNAM      : Variant;
begin
  if wbBeginInternalEdit then try
    if not Supports(aElement, IwbContainer, Container) then
      Exit;
    if wbIsOblivion then begin
	    if Assigned(Container.RecordBySignature[WNAM]) then begin
	      Container.RemoveElement(CNAM);
		    Container.RemoveElement(NAM2);
		    Container.RemoveElement(ICON);
		    Container.RemoveElement(MNAM);
	    end else begin
        Container.Add(CNAM);
	      Container.Add(NAM2);
		    Container.Add(MNAM);
	    end;
    end else begin
      if Assigned(Container.ElementByName['Parent Worldspace']) then begin
      PNAM := Container.ElementNativeValues['Parent Worldspace\PNAM'];
        if PNAM and $01 = 1 then begin
          Container.RemoveElement(DNAM)
        end else begin
          Container.Add(DNAM)
        end;
        if PNAM and $02 = 2 then begin
          Container.RemoveElement('LOD Data')
        end else begin
          Container.Add('LOD Data')
        end;
        if PNAM and $04 = 4 then begin
          if wbIsFallout3 then
            Container.RemoveElement('Icon')
          else
            Container.RemoveElement(ICON);
          Container.RemoveElement(MNAM)
        end else begin
          Container.Add(MNAM)
        end;
        if PNAM and $08 = 8 then begin
          Container.RemoveElement(NAM2)
        end else begin
          Container.Add(NAM2)
        end;
        if PNAM and $10 = 16 then begin
          Container.RemoveElement(CNAM)
        end else begin
          Container.Add(CNAM)
        end;
        if wbIsFallout3 then begin
          if PNAM and $20 = 32 then begin
            Container.RemoveElement(INAM)
          end else begin
            Container.Add(INAM)
          end;
        end;
      end else begin
        Container.Add(DNAM);
        Container.Add('LOD Data');
        Container.Add(MNAM);
        Container.Add(NAM2);
        Container.Add(CNAM);
        if wbIsFallout3 then
          Container.Add(INAM);
      end;
    end;
  finally
    wbEndInternalEdit
  end;
end;

procedure wbWwiseKeywordMappingTemplateAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  Sounds    : IwbElement;
begin
  if not Assigned(aElement) then
    Exit;
  if aOldValue = aNewValue then
    Exit;
  Container := aElement.Container;
  Sounds := Container.ElementByPath['Sound Mappings'];
  if Assigned(Sounds) then
    Sounds.Remove;
end;

{>>> Count Callbacks <<<} //8

function wbMHDTColumnsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container  : IwbDataContainer;
  Element    : IwbElement;
  MinX, MaxX : Integer;
begin
  Result := 0;

  if not Supports(aElement.Container, IwbDataContainer, Container) then
    Exit;

  if not Supports(Container.Container, IwbDataContainer, Container) then
    Exit;

  if not Assigned(Container.ElementByPath['Dimensions\Min\X']) then
    if not Supports(Container.Container, IwbDataContainer, Container) then
      Exit;

  Element := Container.ElementByPath['Dimensions\Min\X'];
  if not Assigned(Element) then
    Exit;
  MinX := Element.NativeValue;

  Element := Container.ElementByPath['Dimensions\Max\X'];
  if not Assigned(Element) then
    Exit;
  MaxX := Element.NativeValue;

  Result := MaxX - MinX + 1;
end;

function wbModelInfoAddonCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container : IwbContainerElementRef;
  Headers   : IwbContainerElementRef;
begin
  Result := 0;

  if not Supports(GetContainerFromUnion(aElement), IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Container, IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Elements[0], IwbContainerElementRef, Headers) then
    Exit;

  if Headers.ElementCount < 2 then
    Exit;

  Result := Headers.Elements[1].NativeValue;
end;

function wbModelInfoMaterialFileCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container : IwbContainerElementRef;
  Headers   : IwbContainerElementRef;
begin
  Result := 0;

  if not Supports(GetContainerFromUnion(aElement), IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Container, IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Elements[0], IwbContainerElementRef, Headers) then
    Exit;

  if Headers.ElementCount < 4 then
    Exit;

  Result := Headers.Elements[3].NativeValue;
end;

function wbModelInfoTextureFileCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container : IwbContainerElementRef;
  Headers   : IwbContainerElementRef;
begin
  Result := 0;

  if not Supports(GetContainerFromUnion(aElement), IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Container, IwbContainerElementRef, Container) then
    Exit;

  if not Supports(Container.Elements[0], IwbContainerElementRef, Headers) then
    Exit;

  if Headers.ElementCount < 1 then
    Exit;

  Result := Headers.Elements[0].NativeValue;
end;

function wbNavmeshGridCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
begin
  var lContainer := aElement.Container;
  if not Assigned(lContainer) then
    Exit(0);

  var lGridSizeElement := lContainer.ElementByName['Divisor'];
  if not Assigned(lGridSizeElement) then
    Exit(0);

  var lGridSize: Integer := lGridSizeElement.NativeValue;
  if (lGridSize < 0) or (lGridSize > 12) then
    Exit(0);

  Result := lGridSize * lGridSize;
end;


function wbWeatherCloudColorsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  MainRecord : IwbMainRecord;
  Version    : Cardinal;
begin
  Result := 0;
  if Assigned(aElement) then begin
    MainRecord := aElement.ContainingMainRecord;
    if Assigned(MainRecord) then begin
      Version := MainRecord.Version;
      if Version >= 35 then begin
        Result := 32
      end else begin
        Result := 4
      end;
    end;
  end;
end;

function wbWorldColumnsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container  : IwbDataContainer;
  Element    : IwbElement;
  MinX, MaxX : Single;
begin
  Result := 0;

  if not Supports(aElement.Container, IwbDataContainer, Container) then
    Exit;

  if not Supports(Container.Container, IwbDataContainer, Container) then
    Exit;

  if not Assigned(Container.ElementByPath['Worldspace Bounds\NAM0\X']) then
    if not Supports(Container.Container, IwbDataContainer, Container) then
      Exit;

  Element := Container.ElementByPath['Worldspace Bounds\NAM0\X'];
  if not Assigned(Element) then
    Exit;

  MinX := Element.NativeValue;

  if (MinX = Single.MaxValue) or (MinX = Single.MinValue) then
     MinX := 0;

  Element := Container.ElementByPath['Worldspace Bounds\NAM9\X'];
  if not Assigned(Element) then
    Exit;
  MaxX := Element.NativeValue;
  if (MaxX = Single.MaxValue) or (MaxX = Single.MinValue) then
     MaxX := 0;

  Result := Round(MaxX) - Round(MinX) + 1;
end;

function wbWorldRowsCounter(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Cardinal;
var
  Container  : IwbDataContainer;
  Element    : IwbElement;
  MinY, MaxY : Single;
begin
  Result := 0;

  if not Supports(aElement.Container, IwbDataContainer, Container) then
    Exit;

  if not Supports(Container.Container, IwbDataContainer, Container) then
    Exit;

  Element := Container.ElementByPath['Worldspace Bounds\NAM0\Y'];
  if not Assigned(Element) then
    Exit;
  MinY := Element.NativeValue;
  if (MinY = Single.MaxValue) or (MinY = Single.MinValue) then
     MinY := 0;

  Element := Container.ElementByPath['Worldspace Bounds\NAM9\Y'];
  if not Assigned(Element) then
    Exit;
  MaxY := Element.NativeValue;
  if (MaxY = Single.MaxValue) or (MaxY = Single.MinValue) then
     MaxY := 0;

  Result := Round(MaxY) - Round(MinY) + 1;
end;

{>>> Flag Don't Show Callbacks <<<} //6

function wbFlagNavmeshFilterDontSHow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.Flags._Flags and $8000000 <> 0)
         or ((aElement.ContainingMainRecord.Flags._Flags and $10000000 <> 0) and wbIsStarfield)
         or ((aElement.ContainingMainRecord.Flags._Flags and $20000000 <> 0) and wbIsStarfield)
         or (aElement.ContainingMainRecord.Flags._Flags and $40000000 <> 0);
end;

function wbFlagNavmeshBoundingBoxDontSHow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.Flags._Flags and $4000000 <> 0)
         or ((aElement.ContainingMainRecord.Flags._Flags and $10000000 <> 0) and wbIsStarfield)
         or ((aElement.ContainingMainRecord.Flags._Flags and $20000000 <> 0) and wbIsStarfield)
         or (aElement.ContainingMainRecord.Flags._Flags and $40000000 <> 0);
end;

function wbFlagNavmeshOnlyCutDontSHow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.Flags._Flags and $4000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $8000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $20000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $40000000 <> 0);
end;

function wbFlagNavmeshIgnoreErosionDontSHow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.Flags._Flags and $4000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $8000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $10000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $40000000 <> 0);
end;

function wbFlagNavmeshGroundDontSHow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.Flags._Flags and $4000000 <> 0)
         or (aElement.ContainingMainRecord.Flags._Flags and $8000000 <> 0)
         or ((aElement.ContainingMainRecord.Flags._Flags and $10000000 <> 0) and wbIsStarfield)
         or ((aElement.ContainingMainRecord.Flags._Flags and $20000000 <> 0) and wbIsStarfield);
end;

function wbFlagPartialFormDontShow(const aElement: IwbElement): Boolean;
begin
  Result := False;
  if not Assigned(aElement) then
    Exit;
  var lMainRecord := aElement.ContainingMainRecord;
  if not Assigned(lMainRecord) then
    Exit;
  if lMainRecord.IsPartialForm then
    Exit;
  Result := not lMainRecord.CanBePartial;
end;

{>>> Don't Show Callbacks <<<} //10

function wbCellInteriorDontShow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['DATA'] and 1 = 1);
end;

function wbCellExteriorDontShow(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['DATA'] and 1 = 0);
end;

function wbModelInfoDontShow(const aElement: IwbElement): Boolean;
begin
  if wbGameMode < gmTES5 then
    Exit(False);

  Result := True;

  if not Assigned(aElement) then
    Exit;

  var MainRecord := aElement.GetContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;

  Result := MainRecord.Version < 38;
end;

function wbREGNGrassDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 6;
end;

function wbREGNImposterDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 8;
end;

function wbREGNLandDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 5;
end;

function wbREGNMapDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 4;
end;

function wbREGNObjectsDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 2;
end;

function wbREGNSoundDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 7;
end;

function wbREGNWeatherDontShow(const aElement: IwbElement): Boolean;
begin
  Result := wbGetREGNType(aElement) <> 3;
end;

{>>> Float Normalizers <<<} //1

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

{>>> Get Conflict Priority Callbacks <<<} //3

procedure wbLandNormalsGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
begin
  aConflictPriority := cpBenign;
  if not Assigned(aElement) then
    Exit;

  var MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if MainRecord.ConflictAll > caNoConflict then
    aConflictPriority := cpNormal
end;

procedure wbModelInfoGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
begin
  aConflictPriority := cpNormal;

  if wbGameMode < gmTES5 then
    Exit;

  if not Assigned(aElement) then
    Exit;

  var MainRecord := aElement.GetContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;

  if MainRecord.Version < 38 then
    aConflictPriority := cpIgnore;
end;

procedure wbModelInfoUnknownGetCP(const aElement: IwbElement; var aConflictPriority: TwbConflictPriority);
begin
  aConflictPriority := cpNormal;
  if aElement.EditValue = '' then
    aConflictPriority := cpIgnore;
end;

{>>> Get Functions <<<} //4

/// <summary>Generates "{Count}x {FormID}" string for item. Supports single and double structs.</summary>
/// <param name="aContainer">The Item element</param>
/// <returns>string</return>
function wbGetItemStr(const aContainer: IwbContainerElementRef): string;
var
  MainRecord: IwbMainRecord;
begin
  Result := '';

  var FormID := aContainer.Elements[0];
  if not wbTryGetMainRecord(FormID, MainRecord) then
    Exit;

  var Count := aContainer.Elements[1];

  Result := Count.Value + 'x ' + MainRecord.ShortName;
end;

/// <summary>Generates comma-delimited list of array values for an array-type property</summary>
/// <param name="aContainer">The Array Value element (e.g., "Value\Array of Object")</param>
/// <returns>string from TStringList.CommaText</returns>
function wbGetPropertyValueArrayItems(const aContainer: IwbContainerElementRef): string;
var
  ItemName   : string;
  MainRecord : IwbMainRecord;
begin
  var Items := TStringList.Create;

  if CompareStr(aContainer.Name, 'Array of Object') = 0 then
    for var i := 0 to Pred(aContainer.ElementCount) do begin
      var ObjectUnion := aContainer.Elements[i] as IwbContainerElementRef;
      var ObjectVersion := IfThen(wbGetScriptObjFormat(ObjectUnion) = 0, 'v2', 'v1');

      var FormID := ObjectUnion.ElementByPath['Object ' + ObjectVersion + '\FormID'];
      var Alias := ObjectUnion.ElementByPath['Object ' + ObjectVersion + '\Alias'];
      var AliasValue := Alias.Value;

      if Supports(FormID.LinksTo, IwbMainRecord, MainRecord) then
        if MainRecord <> nil then
          ItemName := MainRecord.ShortName
        else
          ItemName := 'NULL';

      if not (CompareStr(AliasValue, 'None') = 0) and not (Length(AliasValue) = 0) then
        Items.Add(Alias.EditValue + IfThen(Length(ItemName) > 0, ' = ' + ItemName, ''))
      else
        if MainRecord <> nil then
          Items.Add(MainRecord.ShortName)
        else
          Items.Add('NULL');
    end
  else
    for var i := 0 to Pred(aContainer.ElementCount) do
      Items.Add(aContainer.Elements[i].Value);

  Result := Items.CommaText;
  Items.Free;
end;

function wbGetREGNType(aElement: IwbElement): Integer;
var
  Container: IwbContainerElementRef;
begin
  Result := -1;
  if not Assigned(aElement) then
    Exit;

  while aElement.Name <> 'Region Data Entry' do begin
    aElement := aElement.Container;
    if not Assigned(aElement) then
      Exit;
  end;

  if not Supports(aElement, IwbContainerElementRef, Container) then
    Exit;

  Result := Container.ElementNativeValues['RDAT\Type'];
end;

/// <summary>Returns Object Format version of Object Union. Corresponds to index of wbStructSK in Object Union array.</summary>
/// <param name="aElement">The Object Union element</param>
/// <returns>0 = Object v2, 1 = Object v1</returns>
function wbGetScriptObjFormat(const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  Container := aElement.Container;
  while Assigned(Container) and (Container.ElementType <> etSubRecord) do
    Container := Container.Container;

  if Container = nil then
    Exit;

  var ObjFormat := Container.ElementNativeValues['Object Format'];

  if ObjFormat = 1 then
    Result := 1;
end;

{>>> Integer Formatters <<<} //1

function wbBoolEnumSummary(const aTrueSummary: string; const aFalseSummary: string = ''): IwbEnumDef;
begin
  Result :=
    wbEnumSummary([
      'False', aFalseSummary,
      'True',  aTrueSummary
    ]);
end;

{>>> Is Removable Callbacks <<<} //9

function wbCellGridIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['DATA'] and 1 = 1);
end;

function wbCellLightingIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['DATA'] and 1 = 0);
end;

function wbModelInfoHeaderIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := Assigned(aElement) and (aElement.NativeValue = 0);
end;

function wbWorldLandDataIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $01 = 1);
end;

function wbWorldLODDataIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result := (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $02 = 2);
end;

function wbWorldMapDataIsRemovable(const aElement: IwbElement): Boolean;
begin
  if wbIsOblivion then
    Result := Assigned(aElement.ContainingMainRecord.RecordBySignature[WNAM])
  else
    Result := (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $04 = 4);
end;

function wbWorldWaterIsRemovable(const aElement: IwbElement): Boolean;
begin
  if wbIsOblivion then
    Result := Assigned(aElement.ContainingMainRecord.RecordBySignature[WNAM])
  else
    Result := (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $08 = 8);
end;

function wbWorldClimateIsRemovable(const aElement: IwbElement): Boolean;
begin
  if wbIsOblivion then
    Result := Assigned(aElement.ContainingMainRecord.RecordBySignature[WNAM])
  else
    Result := (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $10 = 16);
end;

function wbWorldImageSpaceIsRemovable(const aElement: IwbElement): Boolean;
begin
  Result :=
    (aElement.ContainingMainRecord.ElementNativeValues['Parent Worldspace\PNAM'] and $20 = 32);
end;

{>>> Links To Callbacks <<<} //8

function wbConditionSummaryLinksTo(const aElement: IwbElement): IwbElement;
var
  Container : IwbContainerElementRef;
  cerCTDA   : IwbContainerElementRef;
begin
  if not wbTrySetContainer(aElement, ctToSummary, Container) then
    Exit;

  if wbGameMode > gmFNV then begin
    if not Supports(Container.RecordBySignature[CTDA], IwbContainerElementRef, cerCTDA) then
      Exit;
  end else
    cerCTDA := Container;

  Result := cerCTDA.Elements[5].LinksTo;
  if Assigned(Result) then
    Exit;

  Result := cerCTDA.Elements[6].LinksTo;
  if Assigned(Result) then
    Exit;

  Result := cerCTDA.Elements[2].LinksTo;
end;

function wbCoverLinksTo(const aElement: IwbElement): IwbElement;
var
  aInt       : Int64;
  Cover      : IwbContainerElementRef;
  CoverArray : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Triangle   : IwbContainerElementRef;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Triangle := aElement.Container as IwbContainerElementRef;
  if not Assigned(Triangle) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementByPath['NVNM\Cover Array'], IwbContainerElementRef, CoverArray) then
    Exit;

  aInt := aElement.NativeValue;

  if aInt >= CoverArray.ElementCount then
    Exit;
  if aInt < 0 then
    Exit;

  Cover := CoverArray.Elements[aInt] as IwbContainerElementRef;

  Result := Cover;
end;

function wbEdgeLinksTo(aEdge: Integer; const aElement: IwbElement): IwbElement;
var
  aInt       : Int64;
  Triangle   : IwbContainerElementRef;
  Triangles  : IwbContainerElementRef;
  Flags      : Int64;
  MainRecord : IwbMainRecord;
  EdgeLinks  : IwbContainerElementRef;
  EdgeLink   : IwbContainerElementRef;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Triangle := aElement.Container as IwbContainerElementRef;
  if not Assigned(Triangle) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  aInt := aElement.NativeValue;

  Flags := Triangle.ElementNativeValues['Flags'];
  if Flags and (1 shl aEdge) <> 0 then begin
    if not Supports(MainRecord.ElementByPath['NVNM\Edge Links'], IwbContainerElementRef, EdgeLinks) then
      Exit;

    if aInt >= EdgeLinks.ElementCount then
      Exit;

    if aInt < 0 then
      Exit;

    EdgeLink := EdgeLinks.Elements[aInt] as IwbContainerElementRef;

    MainRecord := nil;
    if not Supports(EdgeLink.ElementLinksTo['Navmesh'], IwbMainRecord, MainRecord) then
      Exit;

    aInt := EdgeLink.ElementNativeValues['Triangle'];
  end;

  if not Supports(MainRecord.ElementByPath['NVNM\Triangles'], IwbContainerElementRef, Triangles) then
    Exit;

  if aInt >= Triangles.ElementCount then
    Exit;

  if aInt < 0 then
    Exit;

  Triangle := Triangles.Elements[aInt] as IwbContainerElementRef;

  Result := Triangle;
end;

function wbEdgeLinksTo0(const aElement: IwbElement): IwbElement;
begin
  Result := wbEdgeLinksTo(0, aElement);
end;

function wbEdgeLinksTo1(const aElement: IwbElement): IwbElement;
begin
  Result := wbEdgeLinksTo(1, aElement);
end;

function wbEdgeLinksTo2(const aElement: IwbElement): IwbElement;
begin
  Result := wbEdgeLinksTo(2, aElement);
end;

function wbTriangleLinksTo(const aElement: IwbElement): IwbElement;
var
  aInt       : Int64;
  Triangle   : IwbContainerElementRef;
  Triangles  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Triangle := aElement.Container as IwbContainerElementRef;
  if not Assigned(Triangle) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  aInt := aElement.NativeValue;

  if not Supports(MainRecord.ElementByPath['NVNM\Triangles'], IwbContainerElementRef, Triangles) then
    Exit;

  if aInt >= Triangles.ElementCount then
    Exit;

  if aInt < 0 then
    Exit;

  Triangle := Triangles.Elements[aInt] as IwbContainerElementRef;

  Result := Triangle;
end;

function wbVertexLinksTo(const aElement: IwbElement): IwbElement;
var
  aInt       : Int64;
  Triangle   : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Vertices   : IwbContainerElementRef;
  Vertex     : IwbContainerElementRef;
begin
  Result := nil;
  if not Assigned(aElement) then
    Exit;

  Triangle := aElement.Container as IwbContainerElementRef;
  if not Assigned(Triangle) then
    Exit;

  MainRecord := aElement.ContainingMainRecord;
  if not Assigned(MainRecord) then
    Exit;

  if not Supports(MainRecord.ElementByPath['NVNM\Vertices'], IwbContainerElementRef, Vertices) then
    Exit;

  aInt := aElement.NativeValue;

  if aInt >= Vertices.ElementCount then
    Exit;
  if aInt < 0 then
    Exit;

  Vertex := Vertices.Elements[aInt] as IwbContainerElementRef;

  Result := Vertex;
end;

{>>> Try Functions <<<} //6

function wbTryGetContainerFromUnion(const aElement: IwbElement; out aContainer: IwbContainer): Boolean;
begin
  Result := False;

  if not Assigned(aElement) then
    Exit;

  aContainer := GetContainerFromUnion(aElement);
  if not Assigned(aContainer) then
    Exit;

  Result := True;
end;

function wbTryGetContainerRefFromUnionOrValue(const aElement: IwbElement; out aContainer: IwbContainerElementRef): Boolean;
begin
  Result := False;

  if not Assigned(aElement) then
    Exit;

  aContainer := GetContainerRefFromUnionOrValue(aElement);
  if not Assigned(aContainer) then
    Exit;

  Result := True;
end;

function wbTryGetContainerWithValidMainRecord(const aElement: IwbElement; out aContainer: IwbContainerElementRef; out aMainRecord: IwbMainRecord): Boolean;
begin
  Result := False;

  if not Supports(aElement, IwbContainerElementRef, aContainer) then
    Exit;
  if aContainer.ElementCount < 1 then
    Exit;
  if not Supports(aElement, IwbMainRecord, aMainRecord) then
    Exit;
  if aMainRecord.IsDeleted then
    Exit;

  Result := True;
end;

function wbTryGetContainingMainRecord(const aElement: IwbElement; out aMainRecord: IwbMainRecord): Boolean;
begin
  Result := False;

  if not Assigned(aElement) then
    Exit;

  aMainRecord := aElement.ContainingMainRecord;

  if not Assigned(aMainRecord) then
    Exit;

  Result := True;
end;

function wbTryGetMainRecord(const aElement: IwbElement; out aMainRecord: IwbMainRecord; aSignature: string = ''): Boolean;
begin
  Result := False;

  if not Assigned(aElement) then
    Exit;

  if not Supports(aElement.LinksTo, IwbMainRecord, aMainRecord) then
    Exit;

  if not SameText(aSignature, '') then
    if aMainRecord.Signature <> aSignature then
      Exit;

  Result := True;
end;

function wbTrySetContainer(const aElement: IwbElement; aType: TwbCallbackType; out aContainer: IwbContainerElementRef): Boolean;
begin
  Result := (aType = ctToSummary) and Supports(aElement, IwbContainerElementRef, aContainer);
end;

{>>> To Integer Callbacks <<<} //16

function Sig2Int(aSignature: TwbSignature): Cardinal; inline;
begin
  Result := PCardinal(@aSignature)^;
end;

function wbConditionTypeToInt(const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
begin
  s := aString + '00000000';
  if s[1] = '1' then begin
    if s[2] = '1' then begin
      if s[3] = '1' then begin
        Result := 0;
      end else begin
        Result := 96;
      end;
    end else begin
      if s[3] = '1' then begin
        Result := 160;
      end else begin
        Result := 0;
      end;
    end;
  end else begin
    if s[2] = '1' then begin
      if s[3] = '1' then begin
        Result := 32;
      end else begin
        Result := 64;
      end;
    end else begin
      if s[3] = '1' then begin
        Result := 128;
      end else begin
        Result := 32;
      end;
    end;
  end;
  // Or
  if s[4] = '1' then
    Result := Result or 1;
  // Run On Target or Use Aliases
  if s[5] = '1' then
    Result := Result or 2;
  // Use global
  if s[6] = '1' then
    Result := Result or 4;
  // Use Packdata
  if s[7] = '1' then
    Result := Result or 8;
  // Swap Subject and Target
  if s[8] = '1' then
    Result := Result or 16;
end;

function wbQuestStageToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  var i := 1;
  var s := Trim(aString);
  while (i <= Length(s)) and (s[i] in ['0'..'9']) do
    Inc(i);
  s := Copy(s, 1, Pred(i));

  Result := StrToInt(s);
end;

function wbEdgeToInt(aEdge: Integer; const aString: string; const aElement: IwbElement): Int64;
var
  s: string;
begin
  s := Trim(aString);
  if (s = '')  or SameText(s, 'None') then
    Result := -1
  else
    Result := StrToIntDef(aString, 0);
end;

function wbEdgeToInt0(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbEdgeToInt(0, aString, aElement);
end;

function wbEdgeToInt1(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbEdgeToInt(1, aString, aElement);
end;

function wbEdgeToInt2(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbEdgeToInt(2, aString, aElement);
end;

function wbNVTREdgeToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := StrToInt64(aString);
end;

function wbScaledInt4ToInt(const aString: string; const aElement: IwbElement): Int64;
var
  f: Extended;
begin
  f := StrToFloat(aString);
  f := f * 10000;
  Result := Round(f);
end;

function wbStrToInt(const aString: string; const aElement: IwbElement): Int64;
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
    Result := StrToInt64(s)
  except
    Result := 0;
  end;
end;

function wbVertexToInt(aVertex: Integer; const aString: string; const aElement: IwbElement): Int64;
begin
  Result := StrToIntDef(aString, 0);
end;

function wbVertexToInt0(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbVertexToInt(0, aString, aElement);
end;

function wbVertexToInt1(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbVertexToInt(1, aString, aElement);
end;

function wbVertexToInt2(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := wbVertexToInt(2, aString, aElement);
end;

function wbWeatherCloudSpeedToInt(const aString: string; const aElement: IwbElement): Int64;
var
  f: Extended;
begin
  f := StrToFloat(aString);
  f := f*10*127 + 127;
  Result := Min(Round(f), 254);
end;

{>>> To String Callbacks <<<} //34

procedure wbABGRToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container : IwbContainerElementRef;
  A         : IwbElement;
  R, G, B   : string;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

    A := Container.Elements[0];
    B := Container.Elements[1].Summary;
    G := Container.Elements[2].Summary;
    R := Container.Elements[3].Summary;

  if Assigned(A) then
    if (A.ConflictPriority <= cpIgnore) or (A.Def.DefType = dtByteArray) then
      A := nil;

  if Assigned(A) then
    aValue := 'RGBA(' + R + ', ' + G + ', ' + B + ', ' + A.Summary + ')'
  else
    aValue := 'RGB(' + R + ', ' + G + ', ' + B + ')';
end;

function wbAliasToStr(aInt: Int64; const aQuestRef: IwbElement; aType: TwbCallbackType): string;
var
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Aliases    : IwbContainerElementRef;
  Alias      : IwbContainerElementRef;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary:
      if aInt = -1 then
        Result := 'None'
      else if (aInt = -2) and not wbIsSkyrim then
        Result := 'Player'
      else if (aInt = -3) and wbIsStarfield then
        Result := 'Non-Actor Track'
      else if (aInt = -4) and wbIsStarfield then
        Result := 'Play Audio At Player(Voice Note)'
      else if (aInt = -5) and wbIsStarfield then
        Result := 'Dialogue For Scene'
      else begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Could not resolve alias>';
      end;
           
    ctToEditValue:
      if aInt = -1 then
        Result := 'None'
      else
        Result := aInt.ToString;

    ctToSortKey: Exit(IntToHex64(aInt, 8));

    ctCheck:
      if  (aInt = -1)
      or ((aInt = -2) and not wbIsSkyrim)
      or ((aInt = -3) and wbIsStarfield)
      or ((aInt = -4) and wbIsStarfield)
      or ((aInt = -5) and wbIsStarfield) then
        Result := ''
      else
        Result := '<Warning: Could not resolve alias [' + aInt.ToString + ']>';
           
    ctEditInfo, ctEditType: Result := '';
  end;

  if  (aInt = -1)
  or ((aInt = -2) and not wbIsSkyrim)
  or ((aInt = -3) and wbIsStarfield)
  or ((aInt = -4) and wbIsStarfield)
  or ((aInt = -5) and wbIsStarfield)
  and (aType <> ctEditType)
  and (aType <> ctEditInfo) then
    Exit;

  if not Assigned(aQuestRef) then
    Exit;

  // aQuestRef can be a QUST record or reference to QUST record
  if not Supports(aQuestRef, IwbMainRecord, MainRecord) then
    if not Supports(aQuestRef.LinksTo, IwbMainRecord, MainRecord) then
      Exit;

  if wbIsSkyrim then
    MainRecord := MainRecord.WinningOverride
  else
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
    ctEditType: Exit('ComboBox');
    ctEditInfo: EditInfos := TStringList.Create;
  else
    EditInfos := nil;
  end;

  try
    if Supports(MainRecord.ElementByName['Aliases'], IwbContainerElementRef, Aliases) then begin
      for var i := 0 to Pred(Aliases.ElementCount) do
        if Supports(Aliases.Elements[i], IwbContainerElementRef, Alias) then begin
          var lHasSignature: IwbHasSignature;
          if Supports(Alias, IwbHasSignature, lHasSignature) and (lHasSignature.Signature = ALCS) then begin
            var lALST := Alias.ElementBySignature[ALST];
            if Assigned(lALST) then
              if not Supports(lALST, IwbContainerElementRef, Alias) then
                Continue;
          end;

          var j := Alias.Elements[0].NativeValue;
          if Assigned(EditInfos) or (j = aInt) then begin
            var s := Alias.ElementEditValues['ALID'];
            var t := IntToStr(j);

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
    end;

    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: Quest Alias [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
      end;
      ctCheck: Result := '<Warning: Quest Alias [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
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

procedure wbBGRAToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container  : IwbContainerElementRef;
  A          : IwbElement;
  R, G, B    : string;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  if Container.ElementCount >= 3 then begin
    B := Container.Elements[0].Summary;
    G := Container.Elements[1].Summary;
    R := Container.Elements[2].Summary;
  end else
    Exit;

  if Container.ElementCount >= 4 then
    A := Container.Elements[3]
  else
    A := nil;

  if Assigned(A) then
    if (A.ConflictPriority <= cpIgnore) or (A.Def.DefType = dtByteArray) then
      A := nil;

  if Assigned(A) then
    aValue := 'RGBA(' + R + ', ' + G + ', ' + B + ', ' + A.Summary + ')'
  else
    aValue := 'RGB(' + R + ', ' + G + ', ' + B + ')';
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
    Secunda := (aInt and 64) <> 0;
    Masser := (aInt and 128) <> 0;
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
  Result := '';
  if aType = ctToSortKey then
    Result := IntToHex64(aInt, 4)
  else if aType in [ctToStr, ctToSummary] then
    Result := TimeToStr( EncodeTime(aInt div 6, (aInt mod 6) * 10, 0, 0) );
end;

procedure wbConditionToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container : IwbContainerElementRef;
  cerCTDA   : IwbContainerElementRef;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  if wbGameMode > gmFNV then begin
    if not Supports(Container.RecordBySignature[CTDA], IwbContainerElementRef, cerCTDA) then
      Exit;
  end else
    cerCTDA := Container;

  var Typ : Byte := cerCTDA.Elements[0].NativeValue;
  var Func := cerCTDA.Elements[3];

  if (cerCTDA.ElementCount >= 9)
  and (cerCTDA.Elements[7].Def.DefType <> dtEmpty)
  and (cerCTDA.Elements[8].Def.DefType <> dtEmpty) then begin
    var RunOn := cerCTDA.Elements[7];

    var RunOnInt: Integer := RunOn.NativeValue;

    if wbIsFalloutNV then begin
      var FuncInt: Integer := Func.NativeValue;
      if (FuncInt = 106) or (FuncInt = 285) then
        RunOnInt := 0;
    end;

    if RunOnInt = 2 then
      aValue := '(' + cerCTDA.Elements[8].Summary + ')'
    else
      aValue := RunOn.Summary.Replace(' ', '', [rfReplaceAll]);
  end
  else
    if (Typ and $02) = 0 then
      aValue := 'Subject'
    else
      aValue := 'Target';

  aValue := aValue + '.' + Func.Summary;

  var Param1 := cerCTDA.Elements[5];
  if Param1.ConflictPriority <> cpIgnore then begin
    aValue := aValue + '(' {+ Param1.Name + ': '} + Param1.Summary;

    var Param2 := cerCTDA.Elements[6];
    if Param2.ConflictPriority <> cpIgnore then
      aValue := aValue + ', ' {+ Param2.Name + ': '} + Param2.Summary;

    aValue := aValue + ')';
  end;

  case Typ and $E0 of
    $00: aValue := aValue + ' = ';
    $20: aValue := aValue + ' <> ';
    $40: aValue := aValue + ' > ';
    $60: aValue := aValue + ' >= ';
    $80: aValue := aValue + ' < ';
    $A0: aValue := aValue + ' <= ';
  end;

  aValue := aValue + cerCTDA.Elements[2].Summary;

  var Conditions: IwbContainerElementRef;
  if Supports(Container.Container, IwbContainerElementRef, Conditions) then
  begin
    var l := Conditions.ElementCount;
    if (l < 2) or Container.Equals(Conditions.Elements[Pred(l)]) then
      Exit;
  end;

  if (Typ and $01) = 0 then
    aValue := aValue + ' AND'
  else
    aValue := aValue + ' OR';
end;

function wbConditionTypeToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Flags : IwbFlagsDef;
  S     : string;
begin
  Result := '';

  Flags :=
    wbFlags([
      {0}           'Or',
      {1} IsTES4FO3('Run On Target', 'Use Aliases'),
      {2}           'Use Global',
      {3} IsTES4FO3('',              'Use Packdata'),
      {4} IsTES4FO3('',              'Swap Subject and Target')
  ]);

  case aType of
    ctEditType:
      Result := 'CheckComboBox';

    ctEditInfo:
      Result :=
        IsTES4FO3(
        '"Equal To", "Greater Than", "Less Than", "Or", "Run On Target", "Use Global"',
        '"Equal To", "Greater Than", "Less Than", "Or", "Use Aliases", "Use Global", "Use Packdata", "Swap Subject and Target"');

    ctToEditValue: begin
      Result := '00000000';
      case aInt and 224 of
        0   :   Result[1] := '1';
        64  :   Result[2] := '1';
        96  : begin
                Result[1] := '1';
                Result[2] := '1';
              end;
        128 :   Result[3] := '1';
        160 : begin
                Result[1] := '1';
                Result[3] := '1';
              end;
      end;
      if (aInt and  1) <> 0 then
        Result[4] := '1';
      if (aInt and  2) <> 0 then
        Result[5] := '1';
      if (aInt and  4) <> 0 then
        Result[6] := '1';
      if (aInt and  8) <> 0then
        Result[7] := '1';
      if (aInt and 16) <> 0 then
        Result[8] := '1';
    end;

    ctToSortKey: begin
      Result := IntToHex64(aInt, 2);
    end;

    ctCheck: begin
      case aInt and 224 of
        0, 32, 64, 96, 128, 160 : Result := '';
      else
        Result := '<Unknown Compare Operator>';
      end;

      S := Flags.Check(aInt and 31, aElement);
      if S <> '' then
        Result := Result + ' / ' + S;
    end;

    ctToStr, ctToSummary: begin
      case aInt and 224 of
        0   : Result := 'Equal To';
        32  : Result := 'Not Equal To';
        64  : Result := 'Greater Than';
        96  : Result := 'Greater Than Or Equal To';
        128 : Result := 'Less Than';
        160 : Result := 'Less Than Or Equal To';
      else
        Result := '<Unknown Compare Operator>';
      end;

      S := Flags.ToString(aInt and 31, aElement, aType = ctToSummary);
      if S <> '' then
        Result := Result + ' / ' + S;
    end;
  end;
end;

procedure wbCrowdPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container: IwbContainerElementRef;
  MainRecord: IwbMainRecord;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  var ActorForm := Container.ElementByName['Actor'];
  if not wbTryGetMainRecord(ActorForm, MainRecord) then
    Exit;

  var ActorValueData := Container.ElementByName['Value'];

  aValue := MainRecord.EditorID + ' = ' + Format('%.*g', [5, StrToFloat(ActorValueData.Value)]);

  if not (wbGameMode in [gmFO76, gmSF1]) then
    Exit;

  var CurveTable := Container.ElementByName['Curve Table'] as IwbContainerElementRef;
  if not Assigned(CurveTable) then
    Exit;

  var CurveTableForm := CurveTable.ElementByName['Curve Table'];
  if not wbTryGetMainRecord(CurveTableForm, MainRecord) then
    Exit;

  aValue := aValue + ' {Curve Table: ' + MainRecord.ShortName + '}';
end;

function wbEdgeToStr(aEdge: Integer; aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Triangle   : IwbContainerElementRef;
  Flags      : Int64;
  MainRecord : IwbMainRecord;
  EdgeLinks  : IwbContainerElementRef;
  EdgeLink   : IwbContainerElementRef;
  FormID     : TwbFormID;
begin
  case aType of
    ctToStr, ctToSummary: begin
      if aInt < 0 then
        Exit('None');

      Result := aInt.ToString;

      if not Assigned(aElement) then
        Exit;

      Triangle := aElement.Container as IwbContainerElementRef;
      if not Assigned(Triangle) then
        Exit;

      MainRecord := aElement.ContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit;

      Flags := Triangle.ElementNativeValues['Flags'];
      if Flags and (1 shl aEdge) <> 0 then begin
        if not Supports(MainRecord.ElementByPath['NVNM\Edge Links'], IwbContainerElementRef, EdgeLinks) then
          Exit;

        if aInt >= EdgeLinks.ElementCount then
          Exit;

        if aInt < 0 then
          Exit;

        EdgeLink := EdgeLinks.Elements[aInt] as IwbContainerElementRef;
        if not Assigned(EdgeLink) then
          Exit;

        MainRecord := nil;
        if not Supports(EdgeLink.ElementLinksTo['Navmesh'], IwbMainRecord, MainRecord) then
          Exit;

        aInt := EdgeLink.ElementNativeValues['Triangle'];

        Result := Result + ' (#' + aInt.ToString + ' in ' + MainRecord.Name + ')';
      end;
    end;
    ctToSortKey: begin
      Result := '00000000' + IntToHex(aInt, 4);
      if not Assigned(aElement) then
        Exit;

      Triangle := aElement.Container as IwbContainerElementRef;
      if not Assigned(Triangle) then
        Exit;

      MainRecord := aElement.ContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit;

      FormID := MainRecord.LoadOrderFormID;

      Flags := Triangle.ElementNativeValues['Flags'];
      if Flags and (1 shl aEdge) <> 0 then begin
        if not Supports(MainRecord.ElementByPath['NVNM\Edge Links'], IwbContainerElementRef, EdgeLinks) then
          Exit;
        if aInt >= EdgeLinks.ElementCount then
          Exit;
        if aInt < 0 then
          Exit;
        EdgeLink := EdgeLinks.Elements[aInt] as IwbContainerElementRef;
        if not Assigned(EdgeLink) then
          Exit;

        MainRecord := nil;
        if not Supports(EdgeLink.ElementLinksTo['Navmesh'], IwbMainRecord, MainRecord) then
          Exit;

        if Assigned(MainRecord) then
          FormID := MainRecord.LoadOrderFormID
        else
          FormID := TwbFormID.Null;

        aInt := EdgeLink.ElementNativeValues['Triangle'];
      end;

      Result := FormID.ToString + IntToHex(aInt, 4);
    end;
    ctCheck: Result := '';
    ctToEditValue: if aInt < 0 then
                     Result := ''
                   else
                     Result := aInt.ToString;
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;
end;

function wbEdgeToStr0(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbEdgeToStr(0, aInt, aElement, aType);
end;

function wbEdgeToStr1(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbEdgeToStr(1, aInt, aElement, aType);
end;

function wbEdgeToStr2(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbEdgeToStr(2, aInt, aElement, aType);
end;

procedure wbFactionRelationToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container: IwbContainerElementRef;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  var Faction := Container.Elements[0];
  if not Assigned(Faction.LinksTo) then
    Exit;

  var Rank := Container.Elements[1];

  aValue := Faction.Value;

  if wbIsOblivion then begin
    var NativeRank := Rank.NativeValue;

    aValue := IntToStr(NativeRank) + ' ' + aValue;

    if NativeRank >= 0 then
      aValue := '+' + aValue;

    Exit;
  end;

  aValue := Container.Elements[2].Value + ' ' + aValue;
end;

function wbFileHashCallback(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  if wbLoaderDone and (aType in [ctToStr, ctToSummary, ctToSortKey] ) then
    Result := wbContainerHandler.ResolveFileHash(aInt);

  if Result = '' then
    case aType of
      ctToSortKey:
        Result := IntToHex64(aInt, 16);
      ctToStr, ctToSummary:
        if (aInt > High(Cardinal)) or (aType = ctToStr) then
          Result := '{' + IntToHex64(aInt, 16) + '}'
        else
          Result := '{' + IntToHex64(aInt, 8) + '}';
      ctToEditValue:
        Result := aInt.ToString;
    end;
end;

function wbFolderHashCallback(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  if wbLoaderDone and (aType in [ctToStr, ctToSummary, ctToSortKey] ) then
    Result := wbContainerHandler.ResolveFolderHash(aInt);

  if Result = '' then
    case aType of
      ctToSortKey:
        Result := IntToHex64(aInt, 16);
      ctToStr, ctToSummary:
        if (aInt > High(Cardinal)) or (aType = ctToStr) then
          Result := '{' + IntToHex64(aInt, 16) + '}'
        else
          Result := '{' + IntToHex64(aInt, 8) + '}';
      ctToEditValue:
        Result := aInt.ToString;
    end;
end;

function wbHideFFFF(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  if aType = ctToSortKey then
    Result := IntToHex64(aInt, 4)
  else if aType in [ctToStr, ctToSummary] then
    if aInt = $FFFF then
      Result := 'None'
    else
      Result := aInt.ToString;
end;

procedure wbItemToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container  : IwbContainerElementRef;
  ItemString : string;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  // check for second struct
  if Container.Elements[0].ElementType = etSubRecord then
    Container := Container.Elements[0] as IwbContainerElementRef;

  ItemString := wbGetItemStr(Container);

  if Length(ItemString) = 0 then
    Exit;

  aValue := ItemString;
end;

function wbNVTREdgeToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Index      : Integer;
  Flags      : Cardinal;
  IsExternal : Boolean;
  Container  : IwbContainerElementRef;
begin
  Result := '';
  IsExternal := False;
  if Supports(aElement, IwbContainerElementRef, Container) then begin
    Index := StrToIntDef(Copy(Container.Name, 11, 1), -1);
    if (Index >= 0) and (Index <= 2) then begin
      Flags := Container.ElementNativeValues['..\..\Flags'];
      IsExternal := Flags and (Cardinal(1) shl Index) <> 0;
    end;
  end;

  if IsExternal then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if Container.ElementExists['..\..\..\..\NVEX\Edge Link #' + aInt.ToString] then
          Result := Result + ' (Triangle #' +
            Container.ElementValues['..\..\..\..\NVEX\Edge Link #' + aInt.ToString + '\Triangle'] + ' in ' +
            Container.ElementValues['..\..\..\..\NVEX\Edge Link #' + aInt.ToString + '\Navmesh'] + ')'
        else
          if aType = ctToStr then
            Result := Result + ' <Error: NVEX\Edge Link #' + aInt.ToString + ' is missing>';
      end;
      ctToSortKey:
        if Container.ElementExists['..\..\..\..\NVEX\Edge Link #' + aInt.ToString] then
          Result :=
            Container.ElementSortKeys['..\..\..\..\NVEX\Edge Link #' + aInt.ToString + '\Navmesh', True] + '|' +
            Container.ElementSortKeys['..\..\..\..\NVEX\Edge Link #' + aInt.ToString + '\Triangle', True];
      ctCheck:
        if Container.ElementExists['..\..\..\..\NVEX\Edge Link #' + aInt.ToString] then
          Result := ''
        else
          Result := 'NVEX\Edge Link #' + aInt.ToString + ' is missing';
    end
  end else
    case aType of
      ctToStr, ctToSummary: Result := aInt.ToString;
    end;
end;

procedure wbObjectPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  var ActorValueForm := Container.ElementByName['Actor Value'];
  if not wbTryGetMainRecord(ActorValueForm, MainRecord) then
    Exit;

  var ActorValueData := Container.ElementByName['Value'];

  aValue := MainRecord.EditorID + ' = ' + Format('%.*g', [5, StrToFloat(ActorValueData.Value)]);

  if not (wbGameMode in [gmFO76, gmSF1]) then
    Exit;

  var CurveTable := Container.ElementByName['Curve Table'] as IwbContainerElementRef;
  if not Assigned(CurveTable) then
    Exit;

  var CurveTableForm := CurveTable.ElementByName['Curve Table'];
  if not wbTryGetMainRecord(CurveTableForm, MainRecord) then
    Exit;

  aValue := aValue + ' {Curve Table: ' + MainRecord.ShortName + '}';
end;

function wbREFRNavmeshTriangleToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Navmesh    : IwbElement;
  Triangles  : IwbContainerElementRef;
begin
  case aType of
    ctToStr, ctToSummary: Result := aInt.ToString;
    ctToEditValue: Result := aInt.ToString;
    ctToSortKey: begin
      Result := IntToHex64(aInt, 8);
      Exit;
    end;
    ctCheck: Result := '';
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  Navmesh := Container.Elements[0];
  if not wbTryGetMainRecord(Navmesh, MainRecord) then
    Exit;

  MainRecord := MainRecord.WinningOverride;

  if MainRecord.Signature <> NAVM then begin
    case aType of
      ctToStr, ctToSummary: begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Warning: "'+MainRecord.ShortName+'" is not a Navmesh record>';
      end;
      ctCheck: Result := '<Warning: "'+MainRecord.ShortName+'" is not a Navmesh record>';
    end;
    Exit;
  end;

  if (aType = ctCheck) and
     (
      Supports(MainRecord.ElementByPath['NVTR'], IwbContainerElementRef, Triangles)
   or Supports(MainRecord.ElementByPath['NVNM\Triangles'], IwbContainerElementRef, Triangles)
     ) then
    if aInt >= Triangles.ElementCount then
      Result := '<Warning: Navmesh triangle [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
end;

procedure wbRGBAToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container : IwbContainerElementRef;
  A         : IwbElement;
  R, G, B   : string;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  if Container.ElementCount >= 3 then begin
    R := Container.Elements[0].Summary;
    G := Container.Elements[1].Summary;
    B := Container.Elements[2].Summary;
  end else
    Exit;

  if Container.ElementCount >= 4 then
    A := Container.Elements[3]
  else
    A := nil;

  if Assigned(A) then
    if (A.ConflictPriority <= cpIgnore) or (A.Def.DefType = dtByteArray) then
      A := nil;

  if Assigned(A) then
    aValue := 'RGBA(' + R + ', ' + G + ', ' + B + ', ' + A.Summary + ')'
  else
    aValue := 'RGB(' + R + ', ' + G + ', ' + B + ')';
end;

function wbScaledInt4ToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
const
  PlusMinus : array[Boolean] of string = ('+', '-');
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := FloatToStrF(aInt / 10000, ffFixed, 99, 4);
    ctToSortKey: begin
      Result := FloatToStrF(aInt / 10000, ffFixed, 99, 4);
      if Length(Result) < 22 then
        Result := StringOfChar('0', 22 - Length(Result)) + Result;
      Result := PlusMinus[aInt < 0] + Result;
    end;
    ctCheck: Result := '';
  end;
end;

procedure wbScriptToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  CER: IwbContainerElementRef;
begin
  if not wbTrySetContainer(aElement, aType, CER) then
    Exit;

  var eSCDA := [IfThen(wbGameMode <> gmTES3, SCDA, SCDT)];
  var eSCTX := CER.ElementBySignature[SCTX];

  if not (Assigned(eSCDA)) then begin
    aValue := IfThen(Assigned(eSCTX), '<Source not compiled>', '<Empty>');
    Exit;
  end;

  if not Assigned(eSCTX) then begin
    aValue := '<Source missing>';
    Exit;
  end;

  with TStringList.Create do
  try
    Text := eSCTX.Value;

    for var i := Pred(Count) downto 0 do begin
      var s := Strings[i].Trim;

      if s.StartsWith(';') then
        s := '';

      if s = '' then
        Delete(i);
    end;

    if Count = 0 then
      aValue := '<Source missing>'
    else
      if Count = 1 then
        aValue := Strings[0].Trim
      else
        aValue := '<'+Count.ToString+' lines>';
  finally
    Free;
  end;
end;

procedure wbScriptPropertyToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container: IwbContainerElementRef;
  PropertyValue: string;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  var PropertyTypeElement := Container.ElementByName['Type'];

  // 0 = None
  if PropertyTypeElement.NativeValue = 0 then
    Exit;

  var PropertyName := Container.ElementByName['propertyName'].Value;

  if Length(PropertyName) = 0 then
    Exit;

  var PropertyType := PropertyTypeElement.Value;

  // 1 = Object
  if PropertyTypeElement.NativeValue = 1 then
    wbScriptPropertyObjectToStr(Container, PropertyName, PropertyType, PropertyValue);

  // 2-5 = String, Int32, Float, Bool
  if InRange(PropertyTypeElement.NativeValue, 2, 5) then
    PropertyValue := Container.ElementByName[PropertyType].Value;

  // 11-15 = Arrays of String, Int32, Float, Bool
  if InRange(PropertyTypeElement.NativeValue, 11, 15) then
    wbScriptPropertyArrayToStr(Container, PropertyType, PropertyValue);

  // 16 = Array of Variable (FO76, Not Implemented)
  if PropertyTypeElement.NativeValue = 16 then
    Exit;

  // 17 = Array of Struct
  if PropertyTypeElement.NativeValue = 17 then begin
    PropertyValue := '';
    PropertyType := PropertyType.Substring(9) + '[]';
  end;

  // set display string
  aValue := PropertyType + ' ' + PropertyName;

  if Length(PropertyValue) > 0 then
    aValue := aValue + ' = ' + PropertyValue;
end;

/// <summary>Fills PropertyType and PropertyValue from array assigned to property</summary>
procedure wbScriptPropertyArrayToStr(const aContainer: IwbContainerElementRef; var PropertyType: string; var PropertyValue: string);
begin
  var ArrayContainer := aContainer.ElementByPath['Value\' + PropertyType] as IwbContainerElementRef;

  if not (ArrayContainer.ElementCount > 0) then
    Exit;

  PropertyValue := wbGetPropertyValueArrayItems(ArrayContainer);
  PropertyType := PropertyType.Substring(9) + '[]';
end;

/// <summary>Fills PropertyName, PropertyType, and PropertyName from object assigned to property</summary>
procedure wbScriptPropertyObjectToStr(const aContainer: IwbContainerElementRef; var PropertyName: string; var PropertyType: string; var PropertyValue: string);
var
  MainRecord: IwbMainRecord;
begin
  PropertyValue := 'NULL';

  var ObjectUnion := aContainer.ElementByPath['Value\Object Union'] as IwbContainerElementRef;

  var Version := IfThen(wbGetScriptObjFormat(ObjectUnion) = 0, 'v2', 'v1');

  var FormID := ObjectUnion.ElementByPath['Object ' + Version + '\FormID'];
  var Alias := ObjectUnion.ElementByPath['Object ' + Version + '\Alias'];

  var AliasValue := Alias.Value;

  // compare length, too, because v1 doesn't default to 'None'
  if not (CompareStr(AliasValue, 'None') = 0) and not (Length(AliasValue) = 0) then begin
    PropertyType := 'Alias';
    PropertyName := Alias.EditValue;
  end;

  if not wbTryGetMainRecord(FormID, MainRecord) then
    Exit;

  PropertyValue := MainRecord.Name;
end;

procedure wbToStringFromLinksToSummary(var aValue:string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
begin
  case aType of
    ctToStr:
    begin
      if Assigned(aElement) then begin
        var lLinksTo := aElement.LinksTo;
        if Assigned(lLinksTo) then begin
          var lSummary := lLinksTo.Summary;
          if lSummary <> '' then begin
            aValue := lSummary;
            var lMainRecord: IwbMainRecord;
            if not Supports(lLinksTo, IwbMainRecord) and
                   wbTryGetContainingMainRecord(lLinksTo, lMainRecord)
            then begin
              var lRecordName := lMainRecord.Name;
              if lRecordName <> '' then
                aValue := aValue + ' on ' + lRecordName;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure wbToStringFromLinksToMainRecordName(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
begin
  case aType of
    ctToStr:
    begin
      if aValue = '' then
        Exit;

      aValue := '[' + aValue + ']';

      if not Assigned(aElement) then
        Exit;

      var lLinksTo := aElement.LinksTo;
      if not Assigned(lLinksTo) then
        Exit;

      var lMainRecord: IwbMainRecord;
      if not Supports(lLinksTo, IwbMainRecord, lMainRecord) then
        Exit;

      var lRecordName := lMainRecord.Name;
      if lRecordName <> '' then
        aValue := aValue + ' ' + lRecordName;
    end;
  end;
end;

// TODO: used in too many places to replace with summary callbacks
procedure wbVec3ToStr(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType);
var
  Container: IwbContainerElementRef;
begin
  if not wbTrySetContainer(aElement, aType, Container) then
    Exit;

  var X := Container.Elements[0].Summary;
  var Y := Container.Elements[1].Summary;
  var Z := Container.Elements[2].Summary;

  aValue := '' + '(' + X + ', ' + Y + ', ' + Z + ')';
end;

function wbVertexToStr(aVertex: Integer; aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Triangle   : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  Vertices   : IwbContainerElementRef;
  Vertex     : IwbContainerElementRef;
begin
  case aType of
    ctToStr, ctToSummary: begin
      Result := aInt.ToString;
      if not Assigned(aElement) then
        Exit;

      Triangle := aElement.Container as IwbContainerElementRef;
      if not Assigned(Triangle) then
        Exit;

      MainRecord := aElement.ContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit;

      if not Supports(MainRecord.ElementByPath['NVNM\Vertices'], IwbContainerElementRef, Vertices) then
        Exit;

      if aInt >= Vertices.ElementCount then
        Exit;

      if aInt < 0 then
        Exit;

      Vertex := Vertices.Elements[aInt] as IwbContainerElementRef;

      with Vertex do try
        Result := Result + Format(' (%s, %s, %s)', [ElementEditValues['X'], ElementEditValues['Y'], ElementEditValues['Z']]);
      except
        // TODO: yikes, suppressing exceptions?
      end;
    end;
    ctToSortKey: begin
      Result := IntToHex(aInt, 4);
      if not Assigned(aElement) then
        Exit;

      Triangle := aElement.Container as IwbContainerElementRef;
      if not Assigned(Triangle) then
        Exit;

      MainRecord := aElement.ContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit;

      if not Supports(MainRecord.ElementByPath['NVNM\Vertices'], IwbContainerElementRef, Vertices) then
        Exit;

      if aInt >= Vertices.ElementCount then
        Exit;

      if aInt < 0 then
        Exit;

      Vertex := Vertices.Elements[aInt] as IwbContainerElementRef;

      with Vertex do try
        Result := SortKey[False];
      except
        // TODO: yikes, suppressing exceptions?
      end;
    end;
    ctCheck: Result := '';
    ctToEditValue: Result := aInt.ToString;
    ctEditType: Result := '';
    ctEditInfo: Result := '';
  end;
end;

function wbVertexToStr0(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbVertexToStr(0, aInt, aElement, aType);
end;

function wbVertexToStr1(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbVertexToStr(1, aInt, aElement, aType);
end;

function wbVertexToStr2(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := wbVertexToStr(2, aInt, aElement, aType);
end;

function wbVTXTPosition(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';

  if aType = ctToSortKey then begin
    Result := IntToHex64(aInt div 17, 2) + IntToHex64(aInt mod 17, 2);
    Exit;
  end;

  if aType = ctCheck then begin
    if (aInt < 0) or (aInt > 288) then
      Result := '<Out of range: '+aInt.ToString+'>'
    else
      Exit;
  end;

  if aType in [ctToStr, ctToSummary] then
    Result := aInt.ToString + ' -> ' + IntToStr(aInt div 17) + ':' + IntToStr(aInt mod 17);
end;

function wbWeatherCloudSpeedToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  case aType of
    ctToStr, ctToSummary, ctToEditValue: Result := FloatToStrF((aInt - 127)/127/10, ffFixed, 99, 4);
    ctCheck: Result := '';
  end;
end;

{>>> Union Deciders <<<} //21

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

function wbConditionCompValueDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  // "use global" flag
  if Integer(Container.ElementByName['Type'].NativeValue) and 4 <> 0 then
    Result := 1;
end;

function wbConditionParam3Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if Integer(Container.ElementNativeValues['Run On']) = 4 then
    Result := 1;
end;

function wbConditionReferenceDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  if wbIsFalloutNV then begin
    // IsFacingUp, IsLeftUp
    var i := Container.ElementNativeValues['Function'];
    if (i = 106) or (i = 285) then
      Exit;
  end;

  if Integer(Container.ElementNativeValues['Run On']) = 2 then
    Result := 1;
end;

function wbFlagDecider(aFlag: Byte): TwbUnionDecider;
begin
  if aFlag > High(_FlagDeciders) then
    SetLength(_FlagDeciders, Succ(aFlag));

  if not Assigned(_FlagDeciders[aFlag]) then
    _FlagDeciders[aFlag] :=
      function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
      var
        lContainer: IwbContainerElementRef;
      begin
        if not wbTryGetContainerRefFromUnionOrValue(aElement, lContainer) then
          Exit(0);

        var lFlags := lContainer.ElementByPath['Flags'];
        if not Assigned(lFlags) then
          Exit(0);

        var lFlagBits: Int64 := lFlags.NativeValue;
        if (lFlagBits and (1 shl aFlag)) <> 0 then
          Exit(1);

        Exit(0);
      end;

  Result := _FlagDeciders[aFlag];
end;

function wbFormVersionDecider(aVersion: Integer): TwbUnionDecider;
begin
  if aVersion > High(_FormVersionDeciders) then
    SetLength(_FormVersionDeciders, Succ(aVersion));

  if not Assigned(_FormVersionDeciders[aVersion]) then
    _FormVersionDeciders[aVersion] :=
      function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
      var
        MainRecord : IwbMainRecord;
      begin
        if not Assigned(aElement) then
          Exit(0);

        MainRecord := aElement.GetContainingMainRecord;
        if not Assigned(MainRecord) then
          Exit(0);

        if MainRecord.Version >= aVersion then
          Exit(1);

        Exit(0);
      end;

  Result := _FormVersionDeciders[aVersion];
end;

function wbFormVersionDecider(aMinVersion, aMaxVersion: Integer): TwbUnionDecider; overload;
begin
  Result :=
    function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
    var
      MainRecord : IwbMainRecord;
    begin
      if not Assigned(aElement) then
        Exit(0);

      MainRecord := aElement.GetContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit(0);

      if not ((MainRecord.Version < aMinVersion) or (MainRecord.Version > aMaxVersion)) then
        Exit(1);

      Exit(0);
    end;
end;

function wbFormVersionDecider(const aVersions: array of Integer): TwbUnionDecider; overload;
var
  Versions : TArray<Integer>;
begin
  SetLength(Versions, Length(aVersions));
  for var i := Low(aVersions) to High(aVersions) do
    Versions[i] := aVersions[i];

  Result :=
    function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
    var
      MainRecord : IwbMainRecord;
    begin
      if not Assigned(aElement) then
        Exit(0);

      MainRecord := aElement.GetContainingMainRecord;
      if not Assigned(MainRecord) then
        Exit(0);

      var FormVersion := MainRecord.Version;

      for var i := Low(Versions) to High(Versions) do
        if FormVersion < Versions[i] then
          Exit(i);

      Exit(Length(Versions));
    end;
end;

function wbGMSTUnionDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  EDID : IwbRecord;
  S    : string;
begin
  if Assigned(aElement) then begin;
    EDID := aElement.Container.RecordBySignature['EDID'];
    if Assigned(EDID) then begin
      S := EDID.Value;
      if Length(S) > 0 then begin
        case s[1] of
          's': Result := 0; {String} {>>> Localization Strings <<<}
          'i': Result := 1; {intS32}
          'f': Result := 2; {Float}
        end;
        if wbGameMode >= gmTES5 then
        case s[1] of
          'b': Result := 3; {Boolean}
        end;
        if (wbGameMode in [gmFO76, gmSF1]) then
        case s[1] of
          'u': Result := 4; {Uint32}
        end;
      end;
    end;
  end;
end;

function wbModelInfoDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  var MainRecord := aElement.GetContainingMainRecord;

  if not Assigned(MainRecord) then
    Exit;

  var Version := MainRecord.Version;

  if Version >= 40 then begin
    if Assigned(aBasePtr) and Assigned(aEndPtr) and ((NativeUInt(aEndPtr)-NativeUInt(aBasePtr)) >= SizeOf(Cardinal)) and (PCardinal(aBasePtr)^ > 8 {arbitary limit of 8 supported headers for now}) then
      Exit(1); // most likely older version format in FormVersion 40+ record
    Exit(3)
  end else if Version >= 38 then begin
    if Assigned(aBasePtr) and Assigned(aEndPtr) and ((NativeUInt(aEndPtr)-NativeUInt(aBasePtr)) >= SizeOf(Cardinal)) and (PCardinal(aBasePtr)^ <= 8 {arbitary limit of 8 supported headers for now}) then
      Exit(1); // most likely newer version format in FormVersion 38-39 record
    Exit(2);
  end;
end;

function wbNoFlagsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  lContainer: IwbContainerElementRef;
begin
  if not wbTryGetContainerRefFromUnionOrValue(aElement, lContainer) then
    Exit(0);

  var lFlags := lContainer.ElementByPath['Flags'];
  if not Assigned(lFlags) then
    Exit(0);

  var lFlagBits: Integer := lFlags.NativeValue;
  if lFlagBits = 0 then
    Exit(1);

  Exit(0);
end;

function wbNoteTypeDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  rDNAM      : IwbElement;
  i          : Integer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Container := Container.Container;
  if not Assigned(Container) then
    Exit;

  rDNAM := Container.ElementBySignature['DNAM'];
  if not Assigned(rDNAM) then
    Exit;

  i := rDNAM.NativeValue;

  case i of
    0: Result := 1;
    1: Result := 2;
    3: Result := 3;
  end;
end;

function wbNAVIIslandDataDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  var lContainer: IwbContainer;
  if not Supports(aElement, IwbContainer, lContainer) then
    lContainer := aElement.Container;

  if not Assigned(lContainer) then
    Exit;

  var lElement := lContainer.ElementByPath['...\Has Island Data'];
  if not Assigned(lElement) then
    Exit;

  Result := lElement.NativeValue;
end;

function wbNAVIParentDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  var lContainer: IwbContainer;
  if not Supports(aElement, IwbContainer, lContainer) then
    lContainer := aElement.Container;

  if not Assigned(lContainer) then
    Exit;

  var lElement := lContainer.ElementByPath['...\Parent World'];
  if not Assigned(lElement) then
    Exit;

  if (lElement.NativeValue = 0) then
    Result := 1;
end;

function wbNVNMParentDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container   : IwbContainer;
  Parent      : IwbElement;
  i           : Int64;
begin
  Result := 0;
  if not Assigned(aElement) then
    Exit;

  Container := aElement.Container;

  Parent := Container.ElementByName['Parent World'];

  if not Assigned(Parent) then
    Exit;
  i := Parent.NativeValue;
  // is interior cell?
  if i = 0 then
    Result := 1;
end;

function wbPxDTLocationDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Result := Container.ElementByName['Type'].NativeValue;
end;

function wbRecordSizeDecider(aSize: Integer): TwbUnionDecider;
begin
  if aSize > High(_RecordSizeDeciders) then
    SetLength(_RecordSizeDeciders, Succ(aSize));

  if not Assigned(_RecordSizeDeciders[aSize]) then
    _RecordSizeDeciders[aSize] :=
      function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
      var
        SubRecord : IwbSubRecord;
      begin
        if not Assigned(aElement) then
          Exit(0);

        if not Supports(aElement, IwbSubRecord, SubRecord) then
          Exit(0);

        if not Assigned(SubRecord.DataBasePtr) or (SubRecord.DataSize >= aSize) then
          Exit(1);

        Exit(0);
      end;

  Result := _RecordSizeDeciders[aSize];
end;

function wbRecordSizeDecider(aMinSize, aMaxSize: Integer): TwbUnionDecider; overload;
begin
  Result :=
    function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
    var
      SubRecord : IwbSubRecord;
    begin
      if not Assigned(aElement) then
        Exit(0);

      if not Supports(aElement, IwbSubRecord, SubRecord) then
        Exit(0);

      if (SubRecord.DataSize > aMaxSize) or (SubRecord.DataSize < aMinSize) then
        Exit(1);

      Exit(0);
    end;
end;

function wbRecordSizeDecider(const aSizes: array of Integer): TwbUnionDecider; overload;
var
  Sizes : TArray<Integer>;
begin
  SetLength(Sizes, Length(aSizes));
  for var i := Low(aSizes) to High(aSizes) do
    Sizes[i] := aSizes[i];

  Result :=
    function(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer
    var
      SubRecord : IwbSubRecord;
    begin
      if not Assigned(aElement) then
        Exit(0);

      if not Supports(aElement, IwbSubRecord, SubRecord) then
        Exit(0);

      var DataSize := SubRecord.DataSize;
      for var i := Low(Sizes) to High(Sizes) do
        if DataSize < Sizes[i] then
          Exit(i);

      Exit(Length(Sizes));
    end;
end;

function wbScriptObjFormatDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := wbGetScriptObjFormat(aElement);
end;

function wbWwiseKeywordMappingSoundDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
begin
  Result := 0;
  If not Assigned(aElement) then
    Exit;
  Result := aElement.ContainingMainRecord.ElementNativeValues[WMTI];
end;

{>>> VarRecs <<<} //2

function wbCombineVarRecs(const a, b : array of const): TwbVarRecs;
begin
  SetLength(Result, Length(a) + Length(b));
  if Length(a) > 0 then
    Move(a[0], Result[0], SizeOf(TVarRec) * Length(a));
  if Length(b) > 0 then
    Move(b[0], Result[Length(a)], SizeOf(TVarRec) * Length(b));
end;

function wbMakeVarRecs(const a : array of const): TwbVarRecs;
begin
  SetLength(Result, Length(a));
  if Length(a) > 0 then
    Move(a[0], Result[0], SizeOf(TVarRec) * Length(a));
end;

{>>> Common Function Definitions <<<}

{>>> IfThen Defs <<<} //4

function IfThen(aBoolean: Boolean; const aTrue: IwbRecordMemberDef; const aFalse: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aFalse;
  if aBoolean then
    Result := aTrue;
end;

function IfThen(aBoolean: Boolean; const aTrue: IwbValueDef; const aFalse: IwbValueDef): IwbValueDef;
begin
  Result := aFalse;
  if aBoolean then
    Result := aTrue;
end;

function IfThen(aBoolean: Boolean; const aTrue: TwbSignature; const aFalse: TwbSignature): TwbSignature;
begin
  Result := aFalse;
  if aBoolean then
    Result := aTrue;
end;

function IfThen(aBoolean: Boolean; const aTrue: TwbToStrCallback; const aFalse: TwbToStrCallback): TwbToStrCallback;
begin
  Result := aFalse;
  if aBoolean then
    Result := aTrue;
end;

{>>> Flags IfThen Defs <<<} //6

function wbHasNoFlags(const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aSignature, aValue.Name, wbNoFlagsDecider, [
        aValue,
        wbUnused()
      ]).IncludeFlagOnValue(dfMustBeUnion)
  else
      Result :=
      wbUnion(aSignature, aValue.Name, wbNoFlagsDecider, [
        aValue,
        wbEmpty(aValue.Name)
      ]).IncludeFlagOnValue(dfMustBeUnion);
end;

function wbHasNoFlags(const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aValue.Name, wbNoFlagsDecider, [
        wbUnused(),
        aValue
      ]).IncludeFlag(dfMustBeUnion)
  else
      Result :=
      wbUnion(aValue.Name, wbNoFlagsDecider, [
        wbEmpty(aValue.Name),
        aValue
      ]).IncludeFlag(dfMustBeUnion);
end;

function wbIsFlag(aFlag: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aSignature, aValue.Name, wbFlagDecider(aFlag), [
        aValue,
        wbUnused()
      ]).IncludeFlagOnValue(dfMustBeUnion)
  else
      Result :=
      wbUnion(aSignature, aValue.Name, wbFlagDecider(aFlag), [
        aValue,
        wbEmpty(aValue.Name)
      ]).IncludeFlagOnValue(dfMustBeUnion);
end;

function wbIsFlag(aFlag: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aValue.Name, wbFlagDecider(aFlag), [
        wbUnused(),
        aValue
      ]).IncludeFlag(dfMustBeUnion)
  else
      Result :=
      wbUnion(aValue.Name, wbFlagDecider(aFlag), [
        wbEmpty(aValue.Name),
        aValue
      ]).IncludeFlag(dfMustBeUnion);
end;

function wbIsNotFlag(aFlag: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aSignature, aValue.Name, wbFlagDecider(aFlag), [
        wbUnused(),
        aValue
      ]).IncludeFlagOnValue(dfMustBeUnion)
  else
      Result :=
      wbUnion(aSignature, aValue.Name, wbFlagDecider(aFlag), [
        wbEmpty(aValue.Name),
        aValue
      ]).IncludeFlagOnValue(dfMustBeUnion);
end;

function wbIsNotFlag(aFlag: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aValue.Name, wbFlagDecider(aFlag), [
        aValue,
        wbUnused()
      ]).IncludeFlag(dfMustBeUnion)
  else
      Result :=
      wbUnion(aValue.Name, wbFlagDecider(aFlag), [
        aValue,
        wbEmpty(aValue.Name)
      ]).IncludeFlag(dfMustBeUnion);
end;

{>>> wbGameMode IfThen Defs <<<} //31

function IsTES3(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsMorrowind then
    Result := aDef1
end;

function IsTES4(const aDef1, aDef2: Integer): Integer;
begin
  Result := aDef2;
  if wbIsOblivion then
    Result := aDef1
end;

function IsTES4(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsOblivion then
    Result := aDef1
end;

function IsTES4(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsOblivion then
    Result := aDef1
end;

function IsTES4(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsOblivion then
    Result := aDef1
end;

function IsTES4(const aDef1, aDef2: TwbSignature): TwbSignature;
begin
  Result := aDef2;
  if wbIsOblivion then
    Result := aDef1
end;

function IsTES4FO3(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsOblivion or wbIsFallout3 then
    Result := aDef1
end;

function IsTES4FO3(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsOblivion or wbIsFallout3 then
    Result := aDef1
end;

function IsFO3(const aDef1, aDef2: Integer): Integer;
begin
  Result := aDef2;
  if wbIsFallout3 then
    Result := aDef1
end;

function IsFO3(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsFallout3 then
    Result := aDef1
end;

function IsFO3(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsFallout3 then
    Result := aDef1
end;

function IsFNV(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsFalloutNV then
    Result := aDef1
end;

function IsFNV(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsFalloutNV then
    Result := aDef1
end;

function IsFNV(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsFalloutNV then
    Result := aDef1
end;

function IsTES5(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsSkyrim then
    Result := aDef1
end;

function IsTES5(const aDef1, aDef2: Integer): Integer;
begin
  Result := aDef2;
  if wbIsSkyrim then
    Result := aDef1
end;

function IsTES5(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsSkyrim then
    Result := aDef1
end;

function IsTES5(const aDef1, aDef2: Cardinal): Cardinal;
begin
  Result := aDef2;
  if wbIsSkyrim then
    Result := aDef1
end;

function IsTES5(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsSkyrim then
    Result := aDef1
end;

function IsSSE(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsSkyrimSE then
    Result := aDef1
end;

function IsSSE(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsSkyrimSE then
    Result := aDef1
end;

function IsSSE(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsSkyrimSE then
    Result := aDef1
end;

function IsFO4Plus(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsFallout4 or wbIsFallout76 or wbIsStarfield then
    Result := aDef1
end;

function IsFO4Plus(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsFallout4 or wbIsFallout76 or wbIsStarfield then
    Result := aDef1
end;

function IsFO4Plus(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsFallout4 or wbIsFallout76 or wbIsStarfield then
    Result := aDef1
end;

function IsFO76(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsFallout76 then
    Result := aDef1
end;

function IsFO76(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsFallout76 then
    Result := aDef1
end;

function IsSF1(const aDef1, aDef2: Integer): Integer;
begin
  Result := aDef2;
  if wbIsStarfield then
    Result := aDef1
end;

function IsSF1(const aDef1, aDef2: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result := aDef2;
  if wbIsStarfield then
    Result := aDef1
end;

function IsSF1(const aDef1, aDef2: IwbValueDef): IwbValueDef;
begin
  Result := aDef2;
  if wbIsStarfield then
    Result := aDef1
end;

function IsSF1(const aDef1, aDef2: string): string;
begin
  Result := aDef2;
  if wbIsStarfield then
    Result := aDef1
end;

{>>> Size IfThen Defs <<<} //4

function wbBelowSize(aSize: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aSignature, aValue.Name, wbRecordSizeDecider(aSize), [
        aValue,
        wbUnused()
      ]).IncludeFlagOnValue(dfUnionStaticResolve)
  else
      Result :=
      wbUnion(aSignature, aValue.Name, wbRecordSizeDecider(aSize), [
        aValue,
        wbEmpty(aValue.Name)
      ]).IncludeFlagOnValue(dfUnionStaticResolve);
end;

function wbBelowSize(aSize: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aValue.Name, wbRecordSizeDecider(aSize), [
        aValue,
        wbUnused()
      ]).IncludeFlag(dfUnionStaticResolve)
  else
      Result :=
      wbUnion(aValue.Name, wbRecordSizeDecider(aSize), [
        aValue,
        wbEmpty(aValue.Name)
      ]).IncludeFlag(dfUnionStaticResolve);
end;

function wbFromSize(aSize: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbRecordMemberDef;
begin
  if aIsUnused then begin
    Result :=
      wbUnion(aSignature, aValue.Name, wbRecordSizeDecider(aSize), [
        wbUnused(),
        aValue
      ]).IncludeFlagOnValue(dfUnionStaticResolve);
  end else begin
      Result :=
      wbUnion(aSignature, aValue.Name, wbRecordSizeDecider(aSize), [
        wbEmpty(aValue.Name),
        aValue
      ]).IncludeFlagOnValue(dfUnionStaticResolve);
  end;
end;

function wbFromSize(aSize: Integer; const aValue: IwbValueDef; aIsUnused: Boolean = True): IwbValueDef;
begin
  if aIsUnused then
    Result :=
      wbUnion(aValue.Name, wbRecordSizeDecider(aSize), [
        wbUnused(),
        aValue
      ]).IncludeFlag(dfUnionStaticResolve)
  else
      Result :=
      wbUnion(aValue.Name, wbRecordSizeDecider(aSize), [
        wbEmpty(aValue.Name),
        aValue
      ]).IncludeFlag(dfUnionStaticResolve);
end;

{>>> Version IfThen Defs <<<} //4

function wbBelowVersion(aVersion: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef): IwbRecordMemberDef;
begin
  Result :=
    wbUnion(aSignature, aValue.Name, wbFormVersionDecider(aVersion), [
      aValue,
      wbEmpty(aValue.Name, cpIgnore)
    ]).IncludeFlagOnValue(dfUnionStaticResolve);
end;

function wbBelowVersion(aVersion: Integer; const aValue: IwbValueDef): IwbValueDef;
begin
  Result :=
    wbUnion(aValue.Name, wbFormVersionDecider(aVersion), [
      aValue,
      wbEmpty(aValue.Name, cpIgnore)
    ]).IncludeFlag(dfUnionStaticResolve);
end;

function wbFromVersion(aVersion: Integer; const aSignature: TwbSignature; const aValue: IwbValueDef): IwbRecordMemberDef;
begin
  Result :=
    wbUnion(aSignature, aValue.Name, wbFormVersionDecider(aVersion), [
      wbEmpty(aValue.Name, cpIgnore),
      aValue
    ]).IncludeFlagOnValue(dfUnionStaticResolve);
end;

function wbFromVersion(aVersion: Integer; const aValue: IwbValueDef): IwbValueDef;
begin
  Result :=
    wbUnion(aValue.Name, wbFormVersionDecider(aVersion), [
      wbEmpty(aValue.Name, cpIgnore),
      aValue
    ]).IncludeFlag(dfUnionStaticResolve);
end;

{>>> Vec3 Defs <<<} //11

function wbVec3(const aName: string = 'Unknown'; const aPrefix: string = ''): IwbValueDef;
begin
  Result :=
    wbStruct(aName, [
      wbFloat('X'),
      wbFloat('Y'),
      wbFloat('Z')
    ]).SetSummaryKey([0, 1, 2])
      .SetSummaryMemberPrefixSuffix(0, aPrefix + '(', '')
      .SetSummaryMemberPrefixSuffix(2, '', ')')
      .SetSummaryDelimiter(', ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseVec3);
end;

function wbVec3(const aSignature: TwbSignature; const aName: string = 'Unknown'; const aPrefix: string = ''): IwbRecordMemberDef;
begin
  Result := wbSubRecord(aSignature, aName, wbVec3(aName, aPrefix));
end;

function wbVec3Pos(const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbValueDef;
begin
  Result := wbVec3(aName, aPrefix);
end;

//Because Morrowind is special :)
function wbVec3PosTES3(const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbValueDef;
begin
  Result :=
    wbStruct(aName, [
      wbInteger('X', itS32),
      wbInteger('Y', itS32),
      wbInteger('Z', itS32)
    ]).SetSummaryKey([0, 1, 2])
      .SetSummaryMemberPrefixSuffix(0, aPrefix + '(', '')
      .SetSummaryMemberPrefixSuffix(2, '', ')')
      .SetSummaryDelimiter(', ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseVec3);
end;

function wbVec3Pos(const aSignature: TwbSignature; const aName: string = 'Position'; const aPrefix: string = 'Pos'): IwbRecordMemberDef;
begin
  Result := wbSubRecord(aSignature, aName, wbVec3Pos(''));
end;

function wbVec3Rot(const aName: string = 'Rotation'; const aPrefix: string = 'Rot'): IwbValueDef;
begin
  Result :=
    wbStruct(aName, [
      wbFloatAngle('X', cpNormal, True),
      wbFloatAngle('Y', cpNormal, True),
      wbFloatAngle('Z', cpNormal, True)
    ]).SetSummaryKey([0, 1, 2])
      .SetSummaryMemberPrefixSuffix(0, aPrefix + '(', '')
      .SetSummaryMemberPrefixSuffix(2, '', ')')
      .SetSummaryDelimiter(', ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseVec3);
end;

function wbVec3Rot(const aSignature: TwbSignature; const aName: string = 'Rotation'; const aPrefix: string = 'Rot'): IwbRecordMemberDef;
begin
  Result := wbSubRecord(aSignature, aName, wbVec3Rot(''));
end;

function wbVec3PosRot(const aCombinedName: string = 'Position/Rotation'; const aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbValueDef;
begin
  Result :=
    wbStruct(aCombinedName, [
      wbVec3Pos(aPosName, aPosPrefix),
      wbVec3Rot(aRotName, aRotPrefix)
    ]).SetSummaryKey([0, 1])
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapsePosRot);
end;

function wbVec3PosRot(const aSignature: TwbSignature; const aCombinedName: string = 'Position/Rotation'; aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbRecordMemberDef;
begin
  Result := wbSubRecord(aSignature, aCombinedName, wbVec3PosRot('', aPosName, aRotName, aPosPrefix, aRotPrefix));
end;

function wbVec3PosRotDegrees(const aCombinedName: string = 'Position/Rotation'; const aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbValueDef;
begin
  Result :=
    wbStruct(aCombinedName, [
      wbVec3Pos(aPosName, aPosPrefix),
      wbVec3(aRotName, aRotPrefix)
    ]).SetSummaryKey([0, 1])
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapsePosRot);
end;

function wbVec3PosRotDegrees(const aSignature: TwbSignature; const aCombinedName: string = 'Position/Rotation'; aPosName: string = 'Position'; const aRotName: string = 'Rotation'; const aPosPrefix: string = 'Pos'; const aRotPrefix: string = 'Rot'): IwbRecordMemberDef;
begin
  Result := wbSubRecord(aSignature, aCombinedName, wbVec3PosRotDegrees('', aPosName, aRotName, aPosPrefix, aRotPrefix));
end;

function wbSizePosRot(aSignature: TwbSignature; aName: string; aPriority: TwbConflictPriority = cpNormal): IwbSubRecordDef;
begin
  Result :=
    wbStruct(aSignature, aName, [
      wbStruct('Size', [
        wbFloat('Width', cpNormal, False, 2),
        wbFloat('Height', cpNormal, False, 2)
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, 'Size(', '')
        .SetSummaryMemberPrefixSuffix(1, '', ')')
        .SetSummaryDelimiter(', ')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed),
      wbVec3Pos,
      wbStruct('Rotation (Quaternion?)', [
        wbFloat('q1'),
        wbFloat('q2'),
        wbFloat('q3'),
        wbFloat('q4')
      ]).SetSummaryKey([0, 1, 2, 3])
        .SetSummaryMemberPrefixSuffix(0, 'Quat(', '')
        .SetSummaryMemberPrefixSuffix(3, '', ')')
        .SetSummaryDelimiter(', ')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed)
    ], aPriority);
end;

{>>> Color Defs <<<} //16

function wbAmbientColors(const aSignature: TwbSignature; const aName: string = 'Directional Ambient Lighting Colors'): IwbSubRecordDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbStruct('Directional', [
      wbByteColors('X+').IncludeFlag(dfSummaryNoName),
      wbByteColors('X-').IncludeFlag(dfSummaryNoName),
      wbByteColors('Y+').IncludeFlag(dfSummaryNoName),
      wbByteColors('Y-').IncludeFlag(dfSummaryNoName),
      wbByteColors('Z+').IncludeFlag(dfSummaryNoName),
      wbByteColors('Z-').IncludeFlag(dfSummaryNoName)
    ]).SetSummaryKey([0, 1, 2, 3, 4, 5])
      .IncludeFlag(dfCollapsed),
    IsFO76(
      wbUnused(4),
      IsSF1(
        nil,
        wbFromVersion(34, wbByteColors('Specular')))),
    IsFO76(
      wbUnused(4),
      IsSF1(
        nil,
        wbFromVersion(34, wbFloat('Fresnel Power').SetDefaultNativeValue(1))))
  ]);
end;

function wbAmbientColors(const aName: string = 'Directional Ambient Lighting Colors'): IwbStructDef;
begin
  Result := wbStruct(aName, [
    wbStruct('Directional', [
      wbByteColors('X+').IncludeFlag(dfSummaryNoName),
      wbByteColors('X-').IncludeFlag(dfSummaryNoName),
      wbByteColors('Y+').IncludeFlag(dfSummaryNoName),
      wbByteColors('Y-').IncludeFlag(dfSummaryNoName),
      wbByteColors('Z+').IncludeFlag(dfSummaryNoName),
      wbByteColors('Z-').IncludeFlag(dfSummaryNoName)
    ]).SetSummaryKey([0, 1, 2, 3, 4, 5])
      .IncludeFlag(dfCollapsed),
    IsFO76(
      wbUnused(4),
      IsSF1(
        nil,
        wbFromVersion(34, wbByteColors('Specular')))),
    IsFO76(
      wbUnused(4),
      IsSF1(
        nil,
        wbFromVersion(34, wbFloat('Fresnel Power').SetDefaultNativeValue(1))))
  ]);
end;

function wbByteColors(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbInteger('Red', itU8),
    wbInteger('Green', itU8),
    wbInteger('Blue', itU8),
    wbUnused(1)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteColors(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbInteger('Red', itU8),
    wbInteger('Green', itU8),
    wbInteger('Blue', itU8),
    wbUnused(1)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

//Because Morrowind is special :)
function wbByteColorsTES3(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbInteger('Red', itU32),
    wbInteger('Green', itU32),
    wbInteger('Blue', itU32)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteABGR(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbInteger('Alpha', itU8),
    wbInteger('Blue', itU8),
    wbInteger('Green', itU8),
    wbInteger('Red', itU8)
  ]).SetToStr(wbABGRToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteABGR(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbInteger('Alpha', itU8),
    wbInteger('Blue', itU8),
    wbInteger('Green', itU8),
    wbInteger('Red', itU8)
  ]).SetToStr(wbABGRToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteRGBA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbInteger('Red', itU8),
    wbInteger('Green', itU8),
    wbInteger('Blue', itU8),
    wbInteger('Alpha', itU8)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteRGBA(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbInteger('Red', itU8),
    wbInteger('Green', itU8),
    wbInteger('Blue', itU8),
    wbInteger('Alpha', itU8)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteBGRA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbInteger('Blue', itU8),
    wbInteger('Green', itU8),
    wbInteger('Red', itU8),
    wbInteger('Alpha', itU8)
  ]).SetToStr(wbBGRAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbByteBGRA(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbInteger('Blue', itU8),
    wbInteger('Green', itU8),
    wbInteger('Red', itU8),
    wbInteger('Alpha', itU8)
  ]).SetToStr(wbBGRAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbCNAM(aRequired: Boolean = False): IwbRecordMemberDef;
begin
  Result :=
    wbStruct(CNAM, 'Color', [
      wbInteger('Red', itU8),
      wbInteger('Green', itU8),
      wbInteger('Blue', itU8),
      wbInteger('Alpha', itU8)
    ]).SetRequired(aRequired)
      .SetToStr(wbRGBAToStr)
      .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbFloatColors(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbFloat('Red', cpNormal, True, 255, 0),
    wbFloat('Green', cpNormal, True, 255, 0),
    wbFloat('Blue', cpNormal, True, 255, 0)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbFloatColors(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbFloat('Red', cpNormal, True, 255, 0),
    wbFloat('Green', cpNormal, True, 255, 0),
    wbFloat('Blue', cpNormal, True, 255, 0)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbRFloatColors(const aName: string = 'Color'; const aSigs: TwbSignatures = []): IwbRecordMemberDef;
begin
  Assert(Length(aSigs) = 3, 'wbRFloatColors called with incorrect number of signatures.');

  Result := wbRStruct(aName, [
    wbFloat(aSigs[0], 'Red', cpNormal, True, 255, 0),
    wbFloat(aSigs[1], 'Green', cpNormal, True, 255, 0),
    wbFloat(aSigs[2], 'Blue', cpNormal, True, 255, 0)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbFloatRGBA(const aSignature: TwbSignature; const aName: string = 'Color'): IwbRecordMemberDef;
begin
  Result := wbStruct(aSignature, aName, [
    wbFloat('Red', cpNormal, True, 255, 0),
    wbFloat('Green', cpNormal, True, 255, 0),
    wbFloat('Blue', cpNormal, True, 255, 0),
    wbFloat('Alpha', cpNormal, True, 255, 0)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

function wbFloatRGBA(const aName: string = 'Color'): IwbValueDef;
begin
  Result := wbStruct(aName, [
    wbFloat('Red', cpNormal, True, 255, 0),
    wbFloat('Green', cpNormal, True, 255, 0),
    wbFloat('Blue', cpNormal, True, 255, 0),
    wbFloat('Alpha', cpNormal, True, 255, 0)
  ]).SetToStr(wbRGBAToStr)
    .IncludeFlag(dfCollapsed, wbCollapseRGBA);
end;

{>>> Many Record Defs <<<} //2

function wbModelInfo(aSignature: TwbSignature; aName: string = ''): IwbRecordMemberDef;
begin
  if wbGameMode >= gmTES5 then begin
    if aName = '' then
      aName := 'Model Information';

    if not wbDecodeTextureHashes then
      Exit(wbByteArray(aSignature, aName, 0, cpIgnore).SetDontShow(wbNeverShow));

    var CreateFileEntry := function(const aName: string): IwbValueDef begin
      Result := wbStruct(aName, [
        wbInteger('File Hash', itU32, wbFileHashCallback),
        wbString('Extension', 4),
        wbInteger('Folder Hash', itU32, wbFolderHashCallback)
      ]).SetSummaryKey([2,0,1])
        .SetSummaryDelimiter('')
        .SetSummaryMemberPrefixSuffix(0, '', '')
        .SetSummaryMemberPrefixSuffix(1, '.', '')
        .SetSummaryMemberPrefixSuffix(2, '', '\')
        .IncludeFlag(dfSummaryMembersNoName);
    end;

    var TextureFile := CreateFileEntry('Texture').IncludeFlag(dfCollapsed, wbCollapseModelInfoTexture);
    var MaterialFile := CreateFileEntry('Material').IncludeFlag(dfCollapsed, wbCollapseModelInfoMaterial);

    var NewModelInfo := wbStruct('', [
      wbArray('Headers',
        wbInteger('Header', itU32, nil, nil, cpIgnore).SetIsRemovable(wbModelInfoHeaderIsRemovable)
      , -1, ['Textures Count', 'Addons Count', 'TextureSets', 'Materials Count'], cpIgnore)
        .IncludeFlag(dfNotAlignable)
        .IncludeFlag(dfRemoveLastOnly)
        .IncludeFlag(dfCollapsed, wbCollapseModelInfoHeader),

      wbArray('Textures', TextureFile, wbModelInfoTextureFileCounter)
        .SetSummaryPassthroughMaxLength(80)
        .SetSummaryPassthroughMaxDepth(1)
        .IncludeFlag(dfCollapsed, wbCollapseModelInfoTextures),

      wbArray('Addons', wbInteger('Addon', itU32), wbModelInfoAddonCounter)
        .SetSummaryPassthroughMaxLength(80)
        .SetSummaryPassthroughMaxDepth(1)
        .IncludeFlag(dfCollapsed, wbCollapseModelInfoAddons),

      wbArray('Materials', MaterialFile, wbModelInfoMaterialFileCounter)
        .SetSummaryPassthroughMaxLength(80)
        .SetSummaryPassthroughMaxDepth(1)
        .IncludeFlag(dfCollapsed, wbCollapseModelInfoMaterials),

      wbByteArray('Unknown', 0, cpNormal, False, nil, wbModelInfoUnknownGetCP)
    ]).SetSummaryKey([1, 2, 3])
      .IncludeFlag(dfSummaryMembersNoName)
      .SetAfterSet(wbModelInfoAfterSet);

    Result := wbUnion(aSignature, aName, wbModelInfoDecider, [
      wbStruct('', [
        wbEmpty('Unused'),
        wbByteArray('Unused'),
        wbEmpty('Unused'),
        wbEmpty('Unused')
      ], cpIgnore),
      wbStruct('', [
        wbEmpty('Unused'),
        wbByteArray('ERROR').SetToStr(procedure(var aValue: string; aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement; aType: TwbCallbackType) begin
          if aType = ctCheck then
            aValue := 'SubRecord has invalid format for the Form Version of this record';
        end),
        wbEmpty('Unused'),
        wbEmpty('Unused')
      ], cpCritical),
      wbStruct('', [
        wbEmpty('Unused'),
        wbArray('Textures', TextureFile).IncludeFlag(dfCollapsed, wbCollapseModelInfoTextures),
        wbEmpty('Unused'),
        wbEmpty('Unused')
      ]).SetSummaryKey([1]),
      NewModelInfo
    ], cpNormal, False, wbModelInfoDontShow, wbModelInfoGetCP).IncludeFlag(dfCollapsed, wbCollapseModelInfo);
  end else begin
    if aName = '' then
      aName := 'Textures';

    if not wbDecodeTextureHashes then
      Exit(wbByteArray(aSignature, aName, 0, cpIgnore).SetDontShow(wbNeverShow));

    var TextureFile := wbStruct('Texture', [
      wbInteger('File Hash (PC)', itU64, wbFileHashCallback),
      wbInteger('File Hash (Console)', itU64, wbFileHashCallback),
      wbInteger('Folder Hash', itU64, wbFolderHashCallback)
    ]).SetSummaryKey([2,0])
      .SetSummaryDelimiter('')
      .SetSummaryMemberPrefixSuffix(0, '', '')
      .SetSummaryMemberPrefixSuffix(2, '', '\')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseModelInfoTexture);

    Result := wbArray(aSignature, aName, TextureFile).IncludeFlag(dfCollapsed, wbCollapseModelInfoTextures);
  end;

end;

function wbOBND(aRequired: Boolean = False): IwbRecordMemberDef;
begin
  Result :=
    wbStruct(OBND, 'Object Bounds', [
      wbInteger('X1', itS16),
      wbInteger('Y1', itS16),
      wbInteger('Z1', itS16),
      wbInteger('X2', itS16),
      wbInteger('Y2', itS16),
      wbInteger('Z2', itS16)
    ]).SetSummaryKeyOnValue([0, 1, 2, 3, 4, 5])
      .SetSummaryPrefixSuffixOnValue(0, '(', '')
      .SetSummaryPrefixSuffixOnValue(2, '', ')')
      .SetSummaryPrefixSuffixOnValue(3, '(', '')
      .SetSummaryPrefixSuffixOnValue(5, '', ')')
      .SetSummaryDelimiterOnValue(', ')
      .IncludeFlagOnValue(dfSummaryMembersNoName)
      .SetRequired(aRequired)
      .IncludeFlag(dfCollapsed, wbCollapseObjectBounds);
end;

{>>> Multiple Record Defs <<<} //3

function wbEnchantment(aCapacity: Boolean = False): IwbRecordMemberDef;
begin
  var aName := IsFO3('Object Effect', 'Enchantment');
  var aSig1 := IsTES4(ENAM, EITM);
  var aSig2 := IsTES4(ANAM, EAMT);

  Result := wbFormIDCk(aSig1, aName, [ENCH]);
  if aCapacity then
    Result :=
      wbRStruct(aName, [
        wbFormIDCk(aSig1, 'Effect', [ENCH]),
        wbInteger(aSig2, 'Capacity', itU16)
      ]).IncludeFlag(dfAllowAnyMember);
end;

function wbLeveledListEntry(aObjectName: string; aSigs: TwbSignatures): IwbRecordMemberDef;
begin
  Result :=
    wbStructExSK(LVLO, [0, 2], [3], IsTES4('Leveled List Entry', 'Base Data'), [
      wbInteger('Level', itU16),
      wbUnused(2),
      wbFormIDCk(aObjectName, aSigs),
      wbInteger('Count', itU16).SetDefaultNativeValue(1),
      IsFO4Plus(
        wbInteger('Chance None', itU8),
        wbUnused(2)),
      IsFO4Plus(
        wbUnused(1),
        nil)
    ], cpNormal, False, nil, 3)
    .SetSummaryKeyOnValue([0, 3, 2])
    .SetSummaryPrefixSuffixOnValue(0, '[Level: ', ']')
    .SetSummaryPrefixSuffixOnValue(3, '', ' x')
    .SetSummaryDelimiterOnValue(' ')
    .IncludeFlagOnValue(dfSummaryMembersNoName)
    .IncludeFlagOnValue(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseLeveledItems);
end;

function wbOwnership(aSkipSigs: TwbSignatures = nil): IwbRecordMemberDef;
begin
  Result :=
    wbRStruct('Ownership', [
      IsFO4Plus(
        wbStruct(XOWN, 'Owner', [
          wbFormIDCkNoReach('Owner', [FACT, NPC_]),
          wbUnused(4),
          wbInteger('No Crime', itU8, wbBoolEnum),
          wbUnused(3)
        ]).SetSummaryKeyOnValue([0]),
        wbFormIDCkNoReach(XOWN, 'Owner', [FACT, NPC_])),
      wbInteger(XRNK, 'Faction rank', itS32),
      IsTES4(
        wbFormIDCk(XGLB, 'Global', [GLOB]),
        nil)
    ], aSkipSigs, cpNormal, False, nil, True)
      .SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(1, '[Rank: ', ']')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfCollapsed)
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey);
end;

function wbTexturedModel(aSubRecordName     : string;
                         aSignatures        : TwbSignatures;
                         aTextureSubRecords : array of IwbRecordMemberDef)
                                            : IwbRecordMemberDef;
var
  Members : array of IwbRecordMemberDef;
begin
  SetLength(Members,
    Length(aTextureSubRecords) +
    1 +            //Model Filename
    IsTES4(1, 0) + //Bound Radius if TES4
    IsSF1(0, 1)    //Model Info if not SF1
  );

  Members[0] := wbString(aSignatures[0], 'Model Filename');
  if wbIsOblivion then begin
    Members[1] := wbFloat(aSignatures[1], 'Bound Radius', cpBenign);
    Members[2] := wbModelInfo(aSignatures[2]);
  end else if not wbIsStarfield then begin
    Members[1] := wbModelInfo(aSignatures[1]);
  end;

  for var i := Low(aTextureSubRecords) to High(aTextureSubRecords) do
    Members[Length(Members) - Length(aTextureSubRecords) + i] := aTextureSubRecords[i];

  Result :=
    wbRStruct(aSubRecordName, Members, nil, cpNormal, False, nil, True)
      .SetSummaryKey([0])
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfAllowAnyMember)
      .IncludeFlag(dfCollapsed, wbCollapseModels)
      .IncludeFlag(dfStructFirstNotRequired);
end;

{>>> Record Header Def <<<} //1

function wbRecordHeader(aRecordFlags: IwbIntegerDef): IwbValueDef;
begin
  Result := wbStruct('Record Header', [
    wbString('Signature', 4, cpCritical),
    wbInteger('Data Size', itU32, nil, cpIgnore),
    aRecordFlags.IncludeFlag(dfIsRecordFlags),
    wbFormID('FormID', cpFormID).IncludeFlag(dfSummarySelfAsShortName),
    wbUnion('Version Control Info 1', wbFormVersionDecider(44), [
      wbByteArray('Version Control Info 1', 4, cpIgnore).SetToStr(wbVCI1ToStrBeforeFO4),
      wbByteArray('Version Control Info 1', 4, cpIgnore).SetToStr(wbVCI1ToStrAfterFO4)
    ]),
    wbInteger('Form Version', itU16, nil, cpIgnore).IncludeFlag(dfSummaryShowIgnore),
    wbByteArray('Version Control Info 2', 2, cpIgnore)
  ]).SetSummaryKey([5, 3, 2])
    .SetSummaryMemberPrefixSuffix(5, '[v', ']')
    .SetSummaryMemberPrefixSuffix(2, '{', '}')
    .SetSummaryDelimiter(' ')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseRecordHeader);
end;

{>>> Climate Defs <<<} //1

function wbClimateTiming(aTimeCallback: TwbIntToStrCallback; aPhaseCallback: TwbIntToStrCallback): IwbRecordMemberDef;
var
  lMoonPhase: IwbValueDef;
begin
  if Assigned(aPhaseCallback) then
    lMoonPhase := wbInteger('Moons / Phase Length', itU8, aPhaseCallback).SetDefaultNativeValue(3)
  else
    lMoonPhase := nil;

  Result :=
    wbStruct(TNAM, 'Timing', [
      wbStruct('Sunrise', [
        wbInteger('Begin', itU8, aTimeCallback),
        wbInteger('End', itU8, aTimeCallback)
      ]),
      wbStruct('Sunset', [
        wbInteger('Begin', itU8, aTimeCallback),
        wbInteger('End', itU8, aTimeCallback)
      ]),
      wbInteger('Volatility', itU8),
      lMoonPhase
    ]).SetRequired;
end;

{>>> Creature Defs <<<} //1

function wbModelInfos(aSignature: TwbSignature; aName: string = ''; aDontShow  : TwbDontShowCallback = nil): IwbRecordMemberDef;
begin
  if wbGameMode >= gmTES5 then
    raise Exception.Create('Not Supported');

  if aName = '' then
    aName := 'Model List Textures';

  if not wbDecodeTextureHashes then
    Exit(wbByteArray(aSignature, aName, 0, cpIgnore).SetDontShow(wbNeverShow));

  var TextureFile := wbStruct('Texture', [
    wbInteger('File Hash (PC)', itU64, wbFileHashCallback),
    wbInteger('File Hash (Console)', itU64, wbFileHashCallback),
    wbInteger('Folder Hash', itU64, wbFolderHashCallback)
  ]).SetSummaryKey([2,0])
    .SetSummaryDelimiter('')
    .SetSummaryMemberPrefixSuffix(0, '', '')
    .SetSummaryMemberPrefixSuffix(2, '', '\')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseModelInfoTexture);

  Result :=
    wbArray(aSignature, aName,
      wbStruct('Model', [
        wbArray('Textures', TextureFile, arcU8).IncludeFlag(dfCollapsed, wbCollapseModelInfoTextures)
      ]).SetSummaryKey([0]),
    -1).SetDontShow(aDontShow)
    .IncludeFlag(dfCollapsed, wbCollapseModelInfo);
end;

{>>> Debris Defs <<<} //1

function wbDebrisModel(aTextureFileHashes: IwbRecordMemberDef): IwbRecordMemberDef;
begin
  Result :=
    wbRStruct('Model', [
      wbStruct(DATA, 'Data', [
        wbInteger('Percentage', itU8),
        wbString('Model FileName'),
        wbInteger('Has Collision', itU8, wbBoolEnum)
      ]).SetSummaryKeyOnValue([0, 1, 2])
        .SetSummaryPrefixSuffixOnValue(0, '[', '%]')
        .SetSummaryPrefixSuffixOnValue(2, '{', '}')
        .SetSummaryMemberMaxDepthOnValue(0, 1)
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .SetRequired,
      aTextureFileHashes
    ]).SetSummaryKey([0])
      .SetRequired
      .IncludeFlag(dfCollapsed, wbCollapseModels);
end;

{>>> Image Space Adapter Defs <<<} //2

function wbTimeInterpolators(const aSignature: TwbSignature; const aName: string): IwbRecordMemberDef;
begin
  Result :=
    wbSubRecord(aSignature, aName,
      wbArray('', wbTimeInterpolator)
        .SetSummaryPassthroughMaxCount(10)
        .SetSummaryPassthroughMaxLength(100)
    ).IncludeFlag(dfCollapsed, wbCollapseTimeInterpolators);
end;

function wbTimeInterpolatorsMultAdd(const aSignatureMult, aSignatureAdd: TwbSignature; const aName: string): IwbRecordMemberDef;
begin
  var sMult := 'Mult';
  var sAdd := 'Add';
  if SameText(aName, 'Unused') then begin
    sMult := aName;
    sAdd := aName;
  end;

  Result :=
    wbRStruct(aName, [
      wbTimeInterpolators(aSignatureMult, sMult),
      wbTimeInterpolators(aSignatureAdd, sAdd)
    ]).SetSummaryKey([0, 1])
      .IncludeFlag(dfCollapsed, wbCollapseTimeInterpolatorsMultAdd);
end;

{>>> Perk Defs <<<} //1

function wbPerkEffectType(aAfterSetCallback: TwbAfterSetCallback): IwbValueDef;
begin
  Result :=
    wbInteger('Type', itU8,
      wbEnum([
        {0} 'Quest + Stage',
        {1} 'Ability',
        {2} 'Entry Point'
    ])).SetAfterSet(aAfterSetCallback);
end;

{>>> Race Defs <<<} //1

function wbHeadPart(aHeadPartIndexEnum: IwbEnumDef = nil; aModel: IwbRecordMemberDef = nil; aHeadPartsAfterSet: TwbAfterSetCallback = nil): IwbRecordMemberDef;
begin
  var wbICON: IwbRecordMemberDef := nil;

  if wbGameMode = gmTES4 then
    wbICON := wbString(ICON, 'Icon FileName')
  else if wbGameMode = gmFNV then
    wbICON :=
      wbRStruct('Icon', [
        wbString(ICON, 'Large Icon FileName').SetRequired,
        wbString(MICO, 'Small Icon FileName')
      ], [], cpNormal, False, nil, True)
  else if wbGameMode = gmFO3 then
    wbICON :=
      wbRStruct('Icon', [
        wbString(ICON, 'Large Icon FileName'),
        wbString(MICO, 'Small Icon FileName')
      ]);

  Result :=
    wbRStructSK([0], IfThen(wbGameMode < gmTES5, 'Part', 'Head Part'), [
      wbInteger(INDX, IfThen(wbGameMode < gmTES5, 'Index', 'Head Part Number'), itU32, aHeadPartIndexEnum),
      IfThen(wbGameMode < gmTES5, aModel, nil),
      IfThen(wbGameMode < gmTES5, nil, wbFormIDCk(HEAD, 'Head', [HDPT, NULL])),
      IfThen(wbGameMode < gmTES5, wbICON, nil)
    ]).SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '[', ']')
      .SetSummaryDelimiter(' ')
      .SetAfterSet(aHeadPartsAfterSet)
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfCollapsed, wbCollapseHeadParts);
end;

{>>> Weather Defs <<<} //1

function wbWeatherTimeOfDay(const aName: string): IwbValueDef;
begin
  wbWeatherTimeOfDay :=
    wbStruct(aName, [
	    wbByteColors('Sunrise').IncludeFlag(dfSummaryNoName),
	    wbByteColors('Day').IncludeFlag(dfSummaryNoName),
	    wbByteColors('Sunset').IncludeFlag(dfSummaryNoName),
	    wbByteColors('Night').IncludeFlag(dfSummaryNoName),
	    IsFNV(
        wbByteColors('High Noon').IncludeFlag(dfSummaryNoName),
        IsFO4Plus(
          wbFromVersion(111, wbByteColors('Early Sunrise').IncludeFlag(dfSummaryNoName)),
          nil)),
	    IsFNV(
        wbByteColors('Midnight').IncludeFlag(dfSummaryNoName),
        IsFO4Plus(
          wbFromVersion(111, wbByteColors('Late Sunrise').IncludeFlag(dfSummaryNoName)),
          nil)),
	    IsFO4Plus(
        wbFromVersion(111, wbByteColors('Early Sunset').IncludeFlag(dfSummaryNoName)),
        nil),
	    IsFO4Plus(
        wbFromVersion(111, wbByteColors('Late Sunset').IncludeFlag(dfSummaryNoName)),
        nil)
	  ], cpNormal, True, nil, 4)
    .SetSummaryKey([0, 1, 2, 3, 4, 5, 6, 7])
    .IncludeFlag(dfCollapsed);
end;

{>>> Common Definitions <<<}
procedure DefineCommon;
begin
  wbActorImpactMaterialEnum :=
    wbEnum([
      {0}  'Stone',
      {1}  'Dirt',
      {2}  'Grass',
      {3}  'Glass',
      {4}  'Metal',
      {5}  'Wood',
      {6}  'Organic',
      {7}  'Cloth',
      {8}  'Water',
      {9}  'Hollow Metal',
      {10} 'Organic Bug',
      {11} 'Organic Glow'
    ]);

  wbAggressionEnum :=
    wbEnum([
      {0} 'Unaggressive',
      {1} 'Aggressive',
      {2} 'Very Aggressive',
      {3} 'Frenzied'
    ]);

  wbAlignmentEnum :=
    wbEnum([
      {0} 'Good',
      {1} 'Neutral',
      {2} 'Evil',
      {3} 'Very Good',
      {4} 'Very Evil'
    ]);

  wbArchtypeEnum :=
    wbEnum([
      {0} 'Value Modifier',
      {1} 'Script',
      {2} 'Dispel',
      {3} 'Cure Disease'
    ], [
      11, 'Invisibility',
      12, 'Chameleon',
      13, 'Light',
      16, 'Lock',
      17, 'Open',
      18, 'Bound Item',
      19, 'Summon Creature',
      24, 'Paralysis',
      30, 'Cure Paralysis',
      31, 'Cure Addiction',
      32, 'Cure Poison',
      33, 'Concussion',
      34, 'Value And Parts',
      35, IsFNV('Limb Condition', ''),
      36, IsFNV('Turbo', '')
    ]);

  wbAssistanceEnum :=
    wbEnum([
      {0} 'Helps Nobody',
      {1} 'Helps Allies',
      {2} 'Helps Friends and Allies'
    ]);

  wbAttackAnimationEnum :=
    wbEnum([],[
       26, 'AttackLeft',
       27, 'AttackLeftUp',
       28, 'AttackLeftDown',
       29, 'AttackLeftIS',
       30, 'AttackLeftISUp',
       31, 'AttackLeftISDown',
       32, 'AttackRight',
       33, 'AttackRightUp',
       34, 'AttackRightDown',
       35, 'AttackRightIS',
       36, 'AttackRightISUp',
       37, 'AttackRightISDown',
       38, 'Attack3',
       39, 'Attack3Up',
       40, 'Attack3Down',
       41, 'Attack3IS',
       42, 'Attack3ISUp',
       43, 'Attack3ISDown',
       44, 'Attack4',
       45, 'Attack4Up',
       46, 'Attack4Down',
       47, 'Attack4IS',
       48, 'Attack4ISUp',
       49, 'Attack4ISDown',
       50, 'Attack5',
       51, 'Attack5Up',
       52, 'Attack5Down',
       53, 'Attack5IS',
       54, 'Attack5ISUp',
       55, 'Attack5ISDown',
       56, 'Attack6',
       57, 'Attack6Up',
       58, 'Attack6Down',
       59, 'Attack6IS',
       60, 'Attack6ISUp',
       61, 'Attack6ISDown',
       62, 'Attack7',
       63, 'Attack7Up',
       64, 'Attack7Down',
       65, 'Attack7IS',
       66, 'Attack7ISUp',
       67, 'Attack7ISDown',
       68, 'Attack8',
       69, 'Attack8Up',
       70, 'Attack8Down',
       71, 'Attack8IS',
       72, 'Attack8ISUp',
       73, 'Attack8ISDown',
       74, 'AttackLoop',
       75, 'AttackLoopUp',
       76, 'AttackLoopDown',
       77, 'AttackLoopIS',
       78, 'AttackLoopISUp',
       79, 'AttackLoopISDown',
       80, 'AttackSpin',
       81, 'AttackSpinUp',
       82, 'AttackSpinDown',
       83, 'AttackSpinIS',
       84, 'AttackSpinISUp',
       85, 'AttackSpinISDown',
       86, 'AttackSpin2',
       87, 'AttackSpin2Up',
       88, 'AttackSpin2Down',
       89, 'AttackSpin2IS',
       90, 'AttackSpin2ISUp',
       91, 'AttackSpin2ISDown',
       92, 'AttackPower',
       93, 'AttackForwardPower',
       94, 'AttackBackPower',
       95, 'AttackLeftPower',
       96, 'AttackRightPower',
       97, 'PlaceMine',
       98, 'PlaceMineUp',
       99, 'PlaceMineDown',
      100, 'PlaceMineIS',
      101, 'PlaceMineISUp',
      102, 'PlaceMineISDown',
      103, 'PlaceMine2',
      104, 'PlaceMine2Up',
      105, 'PlaceMine2Down',
      106, 'PlaceMine2IS',
      107, 'PlaceMine2ISUp',
      108, 'PlaceMine2ISDown',
      109, 'AttackThrow',
      110, 'AttackThrowUp',
      111, 'AttackThrowDown',
      112, 'AttackThrowIS',
      113, 'AttackThrowISUp',
      114, 'AttackThrowISDown',
      115, 'AttackThrow2',
      116, 'AttackThrow2Up',
      117, 'AttackThrow2Down',
      118, 'AttackThrow2IS',
      119, 'AttackThrow2ISUp',
      120, 'AttackThrow2ISDown',
      121, 'AttackThrow3',
      122, 'AttackThrow3Up',
      123, 'AttackThrow3Down',
      124, 'AttackThrow3IS',
      125, 'AttackThrow3ISUp',
      126, 'AttackThrow3ISDown',
      127, 'AttackThrow4',
      128, 'AttackThrow4Up',
      129, 'AttackThrow4Down',
      130, 'AttackThrow4IS',
      131, 'AttackThrow4ISUp',
      132, 'AttackThrow4ISDown',
      133, 'AttackThrow5',
      134, 'AttackThrow5Up',
      135, 'AttackThrow5Down',
      136, 'AttackThrow5IS',
      137, 'AttackThrow5ISUp',
      138, 'AttackThrow5ISDown',
      167, 'PipBoy',
      178, 'PipBoyChild',
      255, 'Any'
    ]);

  wbAxisEnum :=
    wbEnum([], [
      88, 'X',
      89, 'Y',
      90, 'Z'
    ]);

  wbBlendModeEnum :=
    wbEnum([], [
      1,  'Zero',
      2,  'One',
      3,  'Source Color',
      4,  'Source Inverse Color',
      5,  'Source Alpha',
      6,  'Source Inverted Alpha',
      7,  'Dest Alpha',
      8,  'Dest Inverted Alpha',
      9,  'Dest Color',
      10, 'Dest Inverse Color',
      11, 'Source Alpha SAT'
    ]);

  wbBlendOpEnum :=
    wbEnum([], [
      1, 'Add',
      2, 'Subtract',
      3, 'Reverse Subtract',
      4, 'Minimum',
      5, 'Maximum'
    ]);

  wbBodyLocationEnum :=
    wbEnum([
      {0} 'Torso',
      {1} 'Head 1',
      {2} 'Head 2',
      {3} 'Left Arm 1',
      {4} 'Left Arm 2',
      {5} 'Right Arm 1',
      {6} 'Right Arm 2',
      {7} 'Left Leg 1',
      {8} 'Left Leg 2',
      {9} 'Left Leg 3',
      {10} 'Right Leg 1',
      {11} 'Right Leg 2',
      {12} 'Right Leg 3',
      {13} 'Brain',
      {14} 'Weapon'
    ], [
     -1, 'None'
    ]);

  wbBodyPartIndexEnum :=
    wbEnum([
      {0}        'Upper Body',
      {1} IsTES4('Lower Body',
                'Left Hand'),
      {2} IsTES4('Hand',
                'Right Hand'),
      {3} IsTES4('Foot',
                'Upper Body Texture'),
      {4} IsTES4('Tail', '')
    ]);

  wbBoolEnum :=
    wbEnum([
      {0} 'False',
      {1} 'True'
    ]);

  wbConfidenceEnum :=
    wbEnum([
      {0} 'Cowardly',
      {1} 'Cautious',
      {2} 'Average',
      {3} 'Brave',
      {4} 'Foolhardy'
    ]);

  wbCRCValuesEnum :=
    wbEnum([
      {0}               'None'
    ], [
      Int64($ED157AE3), 'BGSAutoWeaponSoundDef',
      Int64($54651A43), 'BGSCompoundSoundDef',
      Int64($23F678C3), 'BGSMusicPaletteTrack',
      Int64($A1A9C4D5), 'BGSMusicSilenceTrack',
      Int64($6ED7E048), 'BGSMusicSingleTrack',
      Int64($1EEF540A), 'BGSStandardSoundDef',
      Int64($18837B4F), 'BSDelayEffect',
      Int64($864804BE), 'BSOverdrive',
      Int64($0534ED31), 'BSPathingRequest',
      Int64($7C61EBDB), 'BSPathingSolution',
      Int64($FF5A7BF9), 'BSPathingStreamSimpleBufferRead',
      Int64($B8B926AB), 'BSPathingStreamSimpleBufferWrite',
      Int64($DAF94F6D), 'BSPathingTraversalLink',
      Int64($EF575F7F), 'BSStateVariableFilter',
      Int64($D2B19B80), 'CharacterBumper',
      Int64($DFD9D295), 'Combat Area Shape',
      Int64($FB4E3968), 'Combat Cluster Shape',
      Int64($6F1CAA87), 'CombatAcquireSearchDebugData',
      Int64($86D330A0), 'CombatAimController',
      Int64($C7356584), 'CombatAnimatedPath',
      Int64($19BD0D6F), 'CombatApproachTargetPathController',
      Int64($55FAB455), 'CombatAreaHoldPosition',
      Int64($55C1257B), 'CombatAreaReference',
      Int64($05E817A3), 'CombatAreaShape',
      Int64($A9BDAAFE), 'CombatAreaStandard',
      Int64($8DF7108B), 'CombatChangePositionPathController',
      Int64($2C7605EF), 'CombatChargingSearch',
      Int64($C0C58495), 'CombatCluster',
      Int64($4F117E2B), 'CombatCoverLocation',
      Int64($93409B55), 'CombatCoverSearch',
      Int64($CEF2A87C), 'CombatCoverSearchDebugData',
      Int64($3BD0B457), 'CombatCoverSearchResult',
      Int64($2F77502E), 'CombatCoveredPath',
      Int64($9B04E6C7), 'CombatCoveredPathDebugData',
      Int64($D092ED0A), 'CombatDebugTaskPath',
      Int64($EE1CC4C7), 'CombatDisableActionController',
      Int64($BE236AC9), 'CombatDisableAimController',
      Int64($46F5F91D), 'CombatEnterCoverPathController',
      Int64($884737D6), 'CombatFindCoverPathSpeedController',
      Int64($D6BCB796), 'CombatFlankingSearch',
      Int64($FD16CDF5), 'CombatFollowTargetPathController',
      Int64($D10237D8), 'CombatInventoryItemGrenade',
      Int64($9C2A0B47), 'CombatInventoryItemMagic',
      Int64($84226BD5), 'CombatInventoryItemMagicT',
      Int64($5ACB99C8), 'CombatInventoryItemMelee',
      Int64($8121581D), 'CombatInventoryItemOneHandedBlock',
      Int64($AC4FAA3E), 'CombatInventoryItemPotion',
      Int64($71B72E31), 'CombatInventoryItemRanged',
      Int64($0BEE2410), 'CombatInventoryItemScroll',
      Int64($F86AC87B), 'CombatInventoryItemShield',
      Int64($D74211FB), 'CombatInventoryItemStaff',
      Int64($26038F0F), 'CombatInventoryItemThrown',
      Int64($66D5D91E), 'CombatInventoryItemTorch',
      Int64($11126C48), 'CombatMagicCasterArmor',
      Int64($3DBA3C9A), 'CombatMagicCasterBoundItem',
      Int64($E18FED78), 'CombatMagicCasterChameleon',
      Int64($22784EA4), 'CombatMagicCasterCloak',
      Int64($B6B0FCAD), 'CombatMagicCasterDisarm',
      Int64($A3055CFB), 'CombatMagicCasterInvisibility',
      Int64($C52FCE43), 'CombatMagicCasterLight',
      Int64($41A74F91), 'CombatMagicCasterOffensive',
      Int64($EC01479B), 'CombatMagicCasterParalyze',
      Int64($0304EC9F), 'CombatMagicCasterReanimate',
      Int64($58A60AE1), 'CombatMagicCasterRestore',
      Int64($02212AB0), 'CombatMagicCasterScript',
      Int64($E694BC11), 'CombatMagicCasterStagger',
      Int64($D2CA5063), 'CombatMagicCasterSummon',
      Int64($5AD2B911), 'CombatMagicCasterTargetEffect',
      Int64($22FDD6D5), 'CombatMagicCasterWard',
      Int64($58D2BC02), 'CombatMantlePathController',
      Int64($4CDADCA1), 'CombatMatchTargetAimController',
      Int64($64927B7C), 'CombatMeleeAimController',
      Int64($9F5CADD3), 'CombatMeleeDebugData',
      Int64($4CAE1AF1), 'CombatMovementRequestFollowActor',
      Int64($E4487BAD), 'CombatPath',
      Int64($3E84D96B), 'CombatPathBuilderOpen',
      Int64($1EBC034E), 'CombatPathBuilderStandard',
      Int64($06546465), 'CombatPathDestinationActor',
      Int64($8D41F733), 'CombatPathDestinationFollowActor',
      Int64($F4CF5520), 'CombatPathDestinationLocation',
      Int64($F296CF1B), 'CombatPathDestinationLocations',
      Int64($E35080C0), 'CombatPathDestinationNone',
      Int64($D283E841), 'CombatPathDestinationRef',
      Int64($C805D268), 'CombatPathDestinationRefs',
      Int64($8103C3F5), 'CombatPathMovementMessage',
      Int64($F8BF5B28), 'CombatPathMovementMessageEvent',
      Int64($FDBCC031), 'CombatPathRequestFlight',
      Int64($42107172), 'CombatPathRequestFlyingAttack',
      Int64($F2148845), 'CombatPathRequestGeneric',
      Int64($AB922554), 'CombatPathRequestHover',
      Int64($8B61E783), 'CombatPathRequestLanding',
      Int64($BEC8C98B), 'CombatPathRequestMultiGoal',
      Int64($E5389793), 'CombatPathRequestOrbit',
      Int64($6254EDF9), 'CombatPathRequestRotatePath',
      Int64($DBFD5552), 'CombatPathRequestStandard',
      Int64($181A275D), 'CombatPathRequestStraightPath',
      Int64($1126F62D), 'CombatPathRequestWeightedMultiGoal',
      Int64($69C1DE5A), 'CombatPathTeleportEvent',
      Int64($0EAB162A), 'CombatPathingDebugData',
      Int64($915016AC), 'CombatPathingGoalPolicyAvoidThreat',
      Int64($EDF37547), 'CombatPathingGoalPolicyCharge',
      Int64($BA6CF790), 'CombatPathingGoalPolicyCovered',
      Int64($8BCD672F), 'CombatPathingGoalPolicyDistract',
      Int64($BCAF5C77), 'CombatPathingGoalPolicyFindAttackLocation',
      Int64($0BD293B3), 'CombatPathingGoalPolicyFindCover',
      Int64($908492DD), 'CombatPathingGoalPolicyFindFlankCover',
      Int64($5B1BCF07), 'CombatPathingGoalPolicyFindPotentialCoverLocations',
      Int64($8E7989FB), 'CombatPathingGoalPolicyFindTargetLocation',
      Int64($A51384C9), 'CombatPathingGoalPolicyFindValidLocation',
      Int64($E3B56EB4), 'CombatPathingGoalPolicyFlank',
      Int64($DABA9C1C), 'CombatPathingGoalPolicyFlankDistant',
      Int64($25DBBA6F), 'CombatPathingGoalPolicyFlee',
      Int64($D0AC9503), 'CombatPathingGoalPolicyFollow',
      Int64($AB978C95), 'CombatPathingGoalPolicyInvestigateLocation',
      Int64($EA81EBDB), 'CombatPathingGoalPolicyLocation',
      Int64($0DE21F5F), 'CombatPathingGoalPolicyRetreat',
      Int64($EEBD7774), 'CombatPathingGoalPolicyReturnToCombatArea',
      Int64($0C680AD4), 'CombatPathingGoalPolicySearch',
      Int64($B3E86A9C), 'CombatPathingGoalPolicySearchWander',
      Int64($01C13D8E), 'CombatPathingGoalPolicyWithdraw',
      Int64($BA27000F), 'CombatPathingRequestAdapter',
      Int64($0221C439), 'CombatPathingRequestCovered',
      Int64($35B4C5A0), 'CombatPathingRequestGeneric',
      Int64($95AC34AF), 'CombatPathingRequestMultiGoal',
      Int64($0B5AE3E8), 'CombatPathingRequestStandard',
      Int64($30290669), 'CombatPathingSearchArea',
      Int64($5C75F15E), 'CombatPathingSearchPolicyCharge',
      Int64($DEB6D9D4), 'CombatPathingSearchPolicyCovered',
      Int64($FA183888), 'CombatPathingSearchPolicyDistract',
      Int64($6ED8538F), 'CombatPathingSearchPolicyFlank',
      Int64($D53DEA30), 'CombatPathingSearchPolicyStandard',
      Int64($70146229), 'CombatPathingSearchPolicyWithdraw',
      Int64($38E53D12), 'CombatPathingTweener',
      Int64($A0DD2269), 'CombatPositionTracker',
      Int64($F06E7A91), 'CombatProjectileAimController',
      Int64($AACFA802), 'CombatProjectileDebugData',
      Int64($D55D0153), 'CombatSearchLockData',
      Int64($D5039E9E), 'CombatSharedPath',
      Int64($150B2FA1), 'CombatSuppressiveFireBehavior',
      Int64($1EE53011), 'CombatTargetLocation',
      Int64($9C2C29FA), 'CombatTargetLocationSearch',
      Int64($C331439E), 'CombatTargetLocationSearchResult',
      Int64($D6E95B87), 'CombatTargetSelector',
      Int64($F7B17BBC), 'CombatTargetSelectorFixed',
      Int64($56E7D0C9), 'CombatTargetSelectorPreferred',
      Int64($CE50E3CA), 'CombatTargetSelectorRandom',
      Int64($C3719B85), 'CombatTargetSelectorStandard',
      Int64($3767DCBF), 'CombatThreatExplosion',
      Int64($3C2E5014), 'CombatThreatLOF',
      Int64($A7A21566), 'CombatThreatMelee',
      Int64($A160AF0F), 'CombatThreatProjectile',
      Int64($5AD9B53F), 'CombatTrackTargetAimController',
      Int64($34F693AE), 'CombatTunnelPathController',
      Int64($CB90834C), 'CombatViewController',
      Int64($5222E337), 'CombatViewControllerGlance',
      Int64($C5642853), 'CombatViewControllerPath',
      Int64($C8CC82FC), 'CombatViewControllerStandard',
      Int64($120782F9), 'Covered Path Shape',
      Int64($B1AA41D8), 'CoveredPath',
      Int64($5894CF75), 'DiveBombPathController',
      Int64($6241C761), 'EquippedWeaponData',
      Int64($76FC2C53), 'MasterFilePathingStreamGetSize',
      Int64($3F0FBE34), 'MasterFilePathingStreamWriteToBuffer',
      Int64($5CC2A237), 'MovementMessageActivateDoor',
      Int64($77A37BFA), 'MovementMessageActorCollision',
      Int64($7663F86A), 'MovementMessageApproachingDoor',
      Int64($C8B4153E), 'MovementMessageBlocked',
      Int64($3BED430B), 'MovementMessageFreezeDirection',
      Int64($00DC870E), 'MovementMessageJump',
      Int64($CDED4F63), 'MovementMessageNewPath',
      Int64($C4D7F551), 'MovementMessageNewPathImmediate',
      Int64($D7578F99), 'MovementMessagePathComplete',
      Int64($8BCEF6C4), 'MovementMessagePathFailed',
      Int64($119563E6), 'MovementMessagePlayIdle',
      Int64($616653D5), 'MovementMessageSetStaticPath',
      Int64($67DA9023), 'MovementMessageWarpToLocation',
      Int64($3CF364EC), 'MovementMessageWarpToMultiple',
      Int64($7291261A), 'MovementNodeAvoidance',
      Int64($3B18904B), 'MovementNodeGoal',
      Int64($0C28D1C5), 'MovementParameters',
      Int64($BCDCF728), 'MovementParametersFixed',
      Int64($CD4E67C5), 'NoSupport',
      Int64($A5E9A03C), 'PathingCell',
      Int64($E48B73F3), 'PathingDoor',
      Int64($5826A5DD), 'PathingLockData',
      Int64($330EB0E3), 'PathingRequest',
      Int64($EB5ED874), 'PathingRequestClosePoint',
      Int64($F31543AB), 'PathingRequestClosestGoal',
      Int64($0618E573), 'PathingRequestCover',
      Int64($FA2763CE), 'PathingRequestFlee',
      Int64($3C5FF134), 'PathingRequestFly',
      Int64($A5021751), 'PathingRequestFlyAction',
      Int64($8353103B), 'PathingRequestFlyHover',
      Int64($F075EEF7), 'PathingRequestFlyLand',
      Int64($CDF9A2FC), 'PathingRequestFlyOrbit',
      Int64($98C4C679), 'PathingRequestFlyTakeOff',
      Int64($0528E757), 'PathingRequestHide',
      Int64($54DACA55), 'PathingRequestLOS',
      Int64($CA622528), 'PathingRequestOptimalLocation',
      Int64($C702BB5B), 'PathingRequestRotate',
      Int64($4773B11D), 'PathingRequestSafeStraightLine',
      Int64($8B2152AF), 'PathingRequestStopMoving',
      Int64($13A2CF42), 'PathingStreamLoadGame',
      Int64($7377FDD0), 'PathingStreamMasterFileRead',
      Int64($C5B58C0B), 'PathingStreamSaveGame',
      Int64($6AF11190), 'QuestPathingRequest',
      Int64($FCD0CCC3), 'Water'
    ]);

  wbCriticalStageEnum :=
    wbEnum([
      {0}           'None',
      {1}           'Goo Start',
      {2}           'Goo End',
      {3}           'Disintegrate Start',
      {4}           'Disintegrate End',
      {5} IsFO4Plus('Freeze Start', ''),
      {6} IsFO4Plus('Freeze End', '')
    ]);

  wbCrimeTypeEnum :=
    wbEnum([
      {0} 'Steal',
      {1} 'Pickpocket',
      {2} 'Trespass',
      {3} 'Attack',
      {4} 'Murder',
      {5} IsTES4('Steal Horse',
          IsFO3 ('', 'Escape Jail')),
      {6} IsTES5('Werewolf Transformation',
          IsSF1 ('Piracy', '')),
      {7} IsSF1 ('Smuggling', '')
    ], [
      -1, 'None'
    ]);

  wbCreatureTypeEnum :=
    wbEnum([
      {0} 'Animal',
      {1} 'Mutated Animal',
      {2} 'Mutated Insect',
      {3} 'Abomination',
      {4} 'Super Mutant',
      {5} 'Feral Ghoul',
      {6} 'Robot',
      {7} 'Giant'
    ]);

  wbEffectTypeEnum :=
    wbEnum([
      {0} 'Self',
      {1} 'Touch',
      {2} 'Target'
    ]);

  wbEquipTypeEnum :=
    wbEnum([
      {0}  'Big Guns',
      {1}  'Energy Weapons',
      {2}  'Small Guns',
      {3}  'Melee Weapons',
      {4}  'Unarmed Weapon',
      {5}  'Thrown Weapons',
      {6}  'Mine',
      {7}  'Body Wear',
      {8}  'Head Wear',
      {9}  'Hand Wear',
      {10} 'Chems',
      {11} 'Stimpak',
      {12} 'Food',
      {13} 'Alcohol'
    ], [
      -1, 'None'
    ]);

  wbMenuModeEnum :=
    wbEnum([],[
      1,           'Type: Character Interface',
      2,           'Type: Other',
      3,           'Type: Console',
      1001,        'Message',
      1002,        'Inventory',
      1003,        'Stats',
      1004, IsTES4('HUDMain',
                   'HUDMainMenu'),
      1005, IsTES4('HUDInfo', ''),
      1006, IsTES4('HUDReticle', ''),
      1007,        'Loading',
      1008, IsTES4('Container, Barter',
                   'Container'),
      1009,        'Dialog',
      1010, IsTES4('HUDSubtitle', ''),
      1011, IsTES4('Generic', ''),
      1012,        'SleepWait',
      1013,       'Pause',
      1014,        'LockPick',
      1015, IsTES4('Options', ''),
      1016,        'Quantity',
      1017, IsTES4('Audio', ''),
      1018, IsTES4('Video', ''),
      1019, IsTES4('VideoDisplay', ''),
      1020, IsTES4('Gameplay', ''),
      1021, IsTES4('Controls', ''),
      1022, IsTES4('Magic', ''),
      1023, IsTES4('Map',
                   'Pipboy Data'),
      1024, IsTES4('MagicPopup', ''),
      1025, IsTES4('Negotiate', ''),
      1026,        'Book',
      1027,        'LevelUp',
      1028, IsTES4('Training', ''),
      1029, IsTES4('BirthSign', ''),
      1030, IsTES4('Class', ''),
      1031, IsTES4('Attributes', ''),
      1032, IsTES4('Skills', ''),
      1033, IsTES4('Specialization', ''),
      1034, IsTES4('Persuasion', ''),
      1035, IsTES4('Repair / Ingredient Selection',
                   'Pipboy Repair'),
      1036, IsTES4('RaceSex',
                   'RaceMenu, BarberMenu, PlasticSurgeryMenu'),
      1037, IsTES4('SpellPurchase', ''),
      1038, IsTES4('Load', ''),
      1039, IsTES4('Save', ''),
      1040, IsTES4('Alchemy', ''),
      1041, IsTES4('Spellmaking', ''),
      1042, IsTES4('Enchantment', ''),
      1043, IsTES4('EffectSetting', ''),
      1044, IsTES4('Main', ''),
      1045, IsTES4('Breath', ''),
      1046, IsTES4('QuickKeys', ''),
      1047,        'Credits',
      1048, IsTES4('SigilStone',
                   'CharGen'),
      1049, IsTES4('Recharge', ''),
      1051,        'TextEdit',
      1053, IsFO3 ('Barter', ''),
      1054, IsFO3 ('Surgery', ''),
      1055, IsFO3 ('Hacking', ''),
      1056, IsFO3 ('VATS', ''),
      1057, IsFO3 ('Computers', ''),
      1058, IsFO3 ('Specific: Vendor Repair', ''),
      1059, IsFO3 ('Tutorial', ''),
      1060, IsFO3 ('You''re SPECIAL Book', ''),
      1061, IsFNV ('Item Mod Menu', '') ,
      1069, IsFNV ('Tweaks Menu', ''),
      1074, IsFNV ('Love Tester', ''),
      1075, IsFNV ('Companion Wheel', ''),
      1076, IsFNV ('The Medical Questionnaire', ''),
      1077, IsFNV ('Recipe', ''),
      1080, IsFNV ('Slot Machine MiniGame', ''),
      1081, IsFNV ('Blackjack Table MiniGame', ''),
      1082, IsFNV ('Roulette Table MiniGame', ''),
      1083, IsFNV ('Caravan MiniGame', ''),
      1084, IsFNV ('Character Creation Traits', '')
    ]);

  wbMoodEnum :=
    wbEnum([
      {0}       'Neutral',
      {1} IsFO3('Afraid',   'Angry'),
      {2} IsFO3('Annoyed',  'Fear'),
      {3} IsFO3('Cocky',    'Happy'),
      {4} IsFO3('Drugged',  'Sad'),
      {5} IsFO3('Pleasant', 'Surprised'),
      {6} IsFO3('Angry',    'Puzzled'),
      {7} IsFO3('Sad',      'Disgusted')
    ]);

  wbMoralityEnum :=
    wbEnum([
      {0} 'Any Crime',
      {1} 'Violence Against Enemies',
      {2} 'Property Crime Only',
      {3} 'No Crime'
    ]);

  wbMusicEnum :=
    wbEnum([
      {0} 'Default',
      {1} 'Public',
      {2} 'Dungeon'
    ]);

  wbPackageTypeEnum :=
    wbEnum([
      {0}         'Find',
      {1}         'Follow',
      {2}         'Escort',
      {3}         'Eat',
      {4}         'Sleep',
      {5}         'Wander',
      {6}         'Travel',
      {7}         'Accompany',
      {8}         'Use Item At',
      {9}         'Ambush',
      {10}        'Flee Not Combat',
      {11} IsTES4('Cast Magic', ''),
      {12} IsFO3 ('Sandbox', ''),
      {13} IsFO3 ('Patrol', ''),
      {14} IsFO3 ('Guard', ''),
      {15} IsFO3 ('Dialogue', ''),
      {16} IsFO3 ('Use Weapon', '')
    ]);

  wbQuadrantEnum :=
    wbEnum([
      {0} 'Bottom Left',
      {1} 'Bottom Right',
      {2} 'Top Left',
      {3} 'Top Right'
    ]);

  wbQuestEventEnum :=
    wbEnum([], [                                                      //Confirmed Exists in the following games
      Sig2Int('ADBO'), IsFO76('Bounty Event', ''),                    //        ,FO76
      Sig2Int('ADCR'), 'Crime Gold Event',                            //TES5,FO4     ,SF1
      Sig2Int('ADIA'), 'Actor Dialogue Event',                        //TES5,FO4,FO76,SF1
      Sig2Int('AFAV'), 'Player Activate Actor',                       //TES5,FO4
      Sig2Int('AHEL'), 'Actor Hello Event',                           //TES5,FO4     ,SF1
      Sig2Int('AIPL'), 'Player Add Item',                             //TES5,FO4     ,SF1
      Sig2Int('AOBJ'), IsTES5('', 'Attraction Object Event'),         //    ,FO4     ,SF1
      Sig2Int('ARRT'), 'Arrest Event',                                //TES5,FO4
      Sig2Int('ASSU'), 'Assault Actor Event',                         //TES5,FO4     ,SF1
      Sig2Int('BRIB'), 'Bribe',                                       //TES5,FO4
      Sig2Int('CAST'), 'Cast Magic Event',                            //TES5,FO4
      Sig2Int('CBGN'), IsFO76('Caravan Begin Event', ''),             //        ,FO76
      Sig2Int('CHRR'), 'Change Relationship Rank',                    //TES5,FO4
      Sig2Int('CLOC'), 'Change Location Event',                       //TES5,FO4,FO76,SF1
      Sig2Int('CLRL'), IsTES5('', 'Clear Location Event'),            //    ,FO4
      Sig2Int('CRFT'), 'Craft Item',                                  //TES5,FO4
      Sig2Int('CURE'), 'Player Cured',                                //TES5,FO4
      Sig2Int('DEAD'), 'Dead Body',                                   //TES5,FO4
      Sig2Int('DOCK'), IsSF1('Ship Docking', ''),                     //             ,SF1
      Sig2Int('ESJA'), 'Escape Jail',                                 //TES5,FO4
      Sig2Int('FLAT'), 'Flatter',                                     //TES5,FO4
      Sig2Int('HACK'), IsTES5('', 'Hack Computer'),                   //    ,FO4,FO76,SF1
      Sig2Int('ILOC'), IsFO76('Instanced Location Created Event', ''),//        ,FO76
      Sig2Int('INFC'), 'Player Infected',                             //TES5,FO4
      Sig2Int('INTM'), 'Intimidate',                                  //TES5,FO4
      Sig2Int('IRON'), IsTES5('', 'Iron Sights'),                     //    ,FO4     ,SF1
      Sig2Int('JAIL'), 'Jail Event',                                  //TES5,FO4
      Sig2Int('KILL'), 'Kill Actor Event',                            //TES5,FO4,FO76
      Sig2Int('LAND'), IsSF1('Ship Landing', ''),                     //             ,SF1
      Sig2Int('LCLD'), IsTES5('','Location Loaded'),                  //    ,FO4,FO76,SF1
      Sig2Int('LCPG'), IsFO76('LCP Global Value Event', ''),          //        ,FO76
      Sig2Int('LEVL'), 'Increase Level',                              //TES5,FO4,FO76,SF1
      Sig2Int('LOCK'), 'Lock Pick',                                   //TES5,FO4,FO76,SF1
      Sig2Int('NVPE'), 'New Voice Power',                             //TES5,FO4
      Sig2Int('OAAT'), IsTES5('', 'On Actor Attach'),                 //    ,FO4     ,SF1
      Sig2Int('PCON'), IsFO76('Player Connect', ''),                  //        ,FO76
      Sig2Int('PFIN'), 'Pay Fine Event',                              //TES5,FO4
      Sig2Int('PICK'), IsTES5('', 'Pickpocket'),                      //    ,FO4
      Sig2Int('PRFV'), 'Player Recieves Favor',                       //TES5,FO4
      Sig2Int('QPMT'), IsFO76('QuickPlay Match Event', ''),           //        ,FO76
      Sig2Int('QSTR'), 'Quest Start',                                 //TES5
      Sig2Int('REMP'), 'Player Remove Item',                          //TES5,FO4,FO76,SF1
      Sig2Int('SCPT'), 'Script Event',                                //TES5,FO4,FO76,SF1
      Sig2Int('SKIL'), IsTES5('Skill Increase', ''),                  //TES5
      Sig2Int('STIJ'), 'Served Time',                                 //TES5,FO4
      Sig2Int('TMEE'), IsTES5('', 'Trigger Mine Explosion Event'),    //    ,FO4,FO76,SF1
      Sig2Int('TRES'), 'Trespass Actor Event',                        //TES5,FO4
      Sig2Int('XPLL'), IsSF1('Clear Location (SF)', '')               //             ,SF1
    ]);

  wbSexEnum :=
    wbEnum([
      {0} 'Male',
      {1} 'Female'
    ], [
      -1, 'None'
    ]);

  wbSoulGemEnum :=
    wbEnum([
      {0} 'None',
      {1} 'Petty',
      {2} 'Lesser',
      {3} 'Common',
      {4} 'Greater',
      {5} 'Grand'
    ]);

  wbWorldImpactMaterialEnum :=
    wbEnum([
      {0} 'ConcSolid',
      {1} 'ConcBroken',
      {2} 'MetalSolid',
      {3} 'MetalHollow',
      {4} 'MetalSheet',
      {5} 'Wood',
      {6} 'Sand',
      {7} 'Dirt',
      {8} 'Grass',
      {9} 'Water'
    ]);

  wbZoomOverlayEnum :=
    wbEnum([
      {0}        'Default',
      {1}        'Fine',
      {2}        'Duplex',
      {3}        'German',
      {4}        'Dot',
      {5}        'Mil-Dot',
      {6}        'Circle',
      {7}        'Old Rangefind',
      {8}        'Modern Rangefind',
      {9}        'SVD',
      {10}        'Hand Painted',
      {11}        'Binoculars',
      {12}        'Cross',
      {13}        'Double Zero',
      {14}        'Rangefinder 1',
      {15}        'Rangefinder 2',
      {16}        'Rectangle',
      {17} IsFO76('Camera',
           IsSF1 ('Standard Scope Circle', '')),
      {18} IsFO76('Camera Medium Zoom', ''),
      {19} IsFO76('Camera Long Zoom', ''),
      {20} IsFO76('Camera Night Vision', ''),
      {21} IsFO76('Camera Targeting', '')
    ]);

  wbZTestFuncEnum :=
    wbEnum([], [
      3, 'Equal To',
      4, 'Normal',
      5, 'Greater Than',
      7, 'Greater Than or Equal To',
      8, 'Always Show'
    ]);

  wbPackageFlags :=
    wbFlags(wbSparseFlags([
      0,           'Offers Services',
      1, IsTES4FO3('Must Reach Location', ''),
      2,           'Must Complete',
      3, IsTES4FO3('Lock Doors At Package Start',
                   'Maintain Speed At Goal'),
      4, IsTES4FO3('Lock Doors At Package End',
         IsTES5   ('', 'Treat As Player Follower')),
      5, IsTES4FO3('Lock Doors At Location',
         IsSF1    ('After Combat Reset', '')),
      6,           'Unlock Doors At Package Start',
      7,           'Unlock Doors At Package End',
      8, IsTES4FO3('Unlock Doors At Location',
         IsTES5   ('', 'Request Block Idles')),
      9,           'Continue If PC Near',
     10,           'Once Per Day',
     11, IsSF1    ('Low Priority', ''),
     12, IsTES4FO3('Skip Fallout Behavior',
         IsTES5   ('', 'Skip Load Into Furniture')),
     13, IsTES4FO3('Always Run',
                   'Preferred Speed'),
     16, IsSF1    ('Disable Headtracking', ''),
     17,           'Always Sneak',
     18,           'Allow Swimming',
     19, IsTES4FO3('Allow Falls',
         IsSF1    ('Disable Advanced Traversals', '')),
     20, IsTES4   ('Armor Unequipped',
         IsFO3    ('Head-Tracking Off',
                   'Ignore Combat')),
     21,           'Weapons Unequipped',
     22, IsTES4FO3('Defensive Combat', ''),
     23, IsTES4   ('Use Horse',
                   'Weapon Drawn'),
     24, IsTES4FO3('No Idle Anims', ''),
     25, IsFO3    ('Pretend In Combat', ''),
     26, IsFO3    ('Continue During Combat', ''),
     27, IsTES4   ('', 'No Combat Alert'),
     28, IsFO3    ('No Warn/Attack Behavior', ''),
     29, IsTES4FO3('',
         IsSF1    ('Weapon Drawn: Ready',
                   'Wear Sleep Outfit')),
     30, IsSF1    ('Group Package', ''),
     31, IsSF1    ('Weapon Drawr: Alert', '')
    ]), True);

  wbServiceFlags :=
    wbFlags([
      {0}         'Weapons',
      {1}         'Armor',
      {2}  IsFO3 ('Alcohol',
                  'Clothing'),
      {3}         'Books',
      {4}  IsFO3 ('Food',
                  'Ingredients'),
      {5}  IsTES3('Picks',
           IsFO3 ('Chems', '')),
      {6}  IsTES3('Probes',
           IsFO3 ('Stimpaks', '')),
      {7}  IsFO3 ('', 'Lights'),
      {8}  IsFO3 ('', 'Apparatus'),
      {9}  IsTES3('Repair',
           IsTES4('Repair', '')),
      {10}        'Miscellaneous',
      {11} IsFO3 ('', 'Spells'),
      {12} IsFO3 ('', 'Magic Items'),
      {13} IsFO3 ('', 'Potions'),
      {14}        'Training',
      {15} IsTES3('Spellmaking', ''),
      {16} IsTES3('Enchanting',
                  'Recharge'),
      {17} IsTES3('Repair Items',
                  'Repair')
    ], True);

  wbTemplateFlags :=
    wbFlags([
      {0}         'Traits',
      {1}         'Stats',
      {2}         'Factions',
      {3}  IsFO3( 'Actor Effect List',
                 'Spell List'),
      {4}         'AI Data',
      {5}         'AI Packages',
      {6}         'Model/Animation',
      {7}         'Base Data',
      {8}         'Inventory',
      {9}         'Script',
      {10} IsFO3 ('', 'Def Pack List'),
      {11} IsFO3 ('', 'Attack Data'),
      {12} IsFO3 ('', 'Keywords'),
      {13} IsFO76('Gender',
           IsSF1 ('Reaction Radius', '')),
      {14} IsSF1 ('Combat Style', '')
    ]);

  wbHEDR :=
    wbStruct(HEDR, 'Header', [
      wbFloat('Version'),
      wbInteger('Number of Records', itU32),
      wbInteger('Next Object ID', itU32, wbNextObjectIDToString, wbNextObjectIDToInt)
    ]).SetRequired;

  wbKWDAs :=
    wbArrayS(KWDA, 'Keywords',
      wbFormIDCk('Keyword', [KYWD, NULL]));

  wbKeywords :=
    wbRStruct('Keywords', [
      wbInteger(KSIZ, 'Keyword Count', itU32, nil, cpBenign).IncludeFlag(dfSkipImplicitEdit),
      wbArrayS(KWDA, 'Keywords',
        wbFormIDCk('Keyword', [KYWD,NULL])
      ).SetCountPathOnValue(KSIZ, False)
       .SetRequired
    ]).SetSummaryKey([1]);

  wbRagdoll :=
    wbRStruct('Ragdoll Data', [
      wbArray(XRGD, 'Bones',
        wbStruct('Bone', [
          wbInteger('Bone Id', itU8),
          wbUnused(3),
          wbVec3PosRot
        ]).SetSummaryKey([0])
          .IncludeFlag(dfCollapsed)
      ).IncludeFlag(dfNotAlignable),
      IsTES4(
        nil,
        wbVec3(XRGB, 'Biped Rotation'))
    ]);

  wbColorInterpolator :=
    wbStructSK([0], 'Data', [
      wbFloat('Time'),
      wbFloatRGBA('Value')
    ]);

  wbTimeInterpolator :=
    wbStructSK([0], 'Data', [
      wbFloat('Time'),
      wbFloat('Value')
    ]).SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '@', '')
      .SetSummaryMemberPrefixSuffix(1, '=', '')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseTimeInterpolator);

  wbActionFlag :=
    wbInteger(XACT, 'Action Flag', itU32,
      wbFlags([
        {0} 'Use Default',
        {1} 'Activate',
        {2} 'Open',
        {3} 'Open by Default'
      ]));

  wbAlternateTexture :=
    wbStructSK([0, 2], 'Alternate Texture', [
      wbLenString('3D Name'),
      wbFormIDCk('New Texture', [TXST]),
      wbInteger('3D Index', itS32)
    ]).SetSummaryKey([2, 0, 1])
      .SetSummaryMemberPrefixSuffix(2, '[', ']')
      .SetSummaryMemberPrefixSuffix(0, '', ' =')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed);

  var wbLandFlags :=
      wbFlags([
        {0} 'Hide - Quad 1',
        {1} 'Hide - Quad 2',
        {2} 'Hide - Quad 3',
        {3} 'Hide - Quad 4',
        {4} IsFO4Plus('No Collision - Quad 1', ''),
        {5} IsFO4Plus('No Collision - Quad 2', ''),
        {6} IsFO4Plus('No Collision - Quad 3', ''),
        {7} IsFO4Plus('No Collision - Quad 4', '')
      ], True);

  wbCellGrid :=
    wbStruct(XCLC, 'Grid', [
      wbInteger('X', itS32),
      wbInteger('Y', itS32),
      wbInteger('Land Flags', itU8, wbLandFlags),
      wbUnused(3)
    ], cpNormal, False, nil, 2)
    .SetSummaryKeyOnValue([0, 1, 2])
    .SetSummaryPrefixSuffixOnValue(0, '(', '')
    .SetSummaryPrefixSuffixOnValue(1, '', ')')
    .SetSummaryPrefixSuffixOnValue(2, ' {Land: ', '}')
    .IncludeFlagOnValue(dfSummaryMembersNoName)
    .SetDontShow(wbCellInteriorDontShow)
    .SetIsRemovable(wbCellGridIsRemovable)
    .IncludeFlag(dfCollapsed);

  wbCinematicIMAD :=
    wbRStruct('Cinematic', [
      wbTimeInterpolatorsMultAdd(_11_IAD, _51_IAD,           'Saturation'),
      wbTimeInterpolatorsMultAdd(_12_IAD, _52_IAD, IsTES4FO3('Contrast',         'Brightness')),
      wbTimeInterpolatorsMultAdd(_13_IAD, _53_IAD, IsTES4FO3('Contrast Avg Lum', 'Contrast')),
      wbTimeInterpolatorsMultAdd(_14_IAD, _54_IAD, IsTES4FO3('Brightness',       'Unused'))
    ]);

  wbDATAPosRot := wbVec3PosRot(DATA).SetRequired;

  wbFaction :=
    wbStructSK(SNAM, [0], 'Faction', [
      wbFormIDCk('Faction', [FACT]),
      wbInteger('Rank', itS8),
      IsFO4Plus(nil, wbUnused(3))
    ]).SetSummaryKeyOnValue([0, 1])
      .SetSummaryPrefixSuffixOnValue(1, '{Rank: ', '}')
      .IncludeFlagOnValue(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFactions);

  wbFactionRelations :=
    wbRArrayS('Relations',
      wbStructSK(XNAM, [0], 'Relation', [
        wbFormIDCkNoReach('Faction', [FACT, RACE]),
        wbInteger('Modifier', itS32),
        IsTES4(
          nil,
          wbInteger('Group Combat Reaction', itU32,
            wbEnum([
              {0} 'Neutral',
              {1} 'Enemy',
              {2} 'Ally',
              {3} 'Friend'
            ])))
      ]).SetToStr(wbFactionRelationToStr)
        .IncludeFlag(dfCollapsed, wbCollapseFactionRelations));

  wbMDOB := wbFormID(MDOB, 'Menu Display Object');

  wbNextSpeaker :=
    wbInteger('Next Speaker', itU8,
      wbEnum([
        {0} 'Target',
        {1} 'Self',
        {2} 'Either'
      ]));

  wbPosRot := wbVec3PosRot;

  wbSeasons :=
    wbStruct(PFPC, 'Seasonal ingredient production', [
      wbInteger('Spring', itU8),
      wbInteger('Summer ', itU8),
      wbInteger('Fall', itU8),
      wbInteger('Winter', itU8)
    ]).SetRequired;

  wbActorSounds :=
    wbRArrayS('Sounds',
      wbRStructSK([0], 'Sound', [
        wbFormIDCk(CS2K, 'Keyword', [KYWD]),
        wbFormIDCk(CS2D, 'Sound', [SNDR]).SetRequired
      ], [], cpNormal, False, nil, True)
        .SetSummaryKey([1, 0])
        .SetSummaryMemberPrefixSuffix(0, '{', '}')
        .SetSummaryDelimiter(' ')
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfSummaryNoSortKey)
      ).SetAfterSet(wbNPCActorSoundsAfterSet);

  wbMagicEffectSounds :=
    wbArray(SNDD, 'Sounds',
      wbStruct('Sound', [
        wbInteger('Type', itU32,
          wbEnum([
            {0} 'Sheathe/Draw',
            {1} 'Charge',
            {2} 'Ready',
            {3} 'Release',
            {4} 'Concentration Cast Loop',
            {5} 'On Hit'
          ])),
        wbFormIDCk('Sound', [SNDR])
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, '[', ']')
        .SetSummaryDelimiter(' ')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed));

  wbRegionSounds :=
    wbArrayS(IfThen(wbGameMode < gmTES5, RDSD, RDSA), 'Sounds', wbStructSK([0], 'Sound', [
        wbFormIDCk('Sound', [SNDR, SOUN, NULL]),
        wbInteger('Flags', itU32,
          wbFlags([
            {0} 'Pleasant',
            {1} 'Cloudy',
            {2} 'Rainy',
            {3} 'Snowy'
          ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
        IsTES4FO3(
          wbInteger('Chance', itU32, wbScaledInt4ToStr, wbScaledInt4ToInt),
          wbFloat('Chance'))
      ])).SetDontShow(wbREGNSoundDontShow);

  wbSoundDescriptorSounds :=
    wbRArray('Sounds',
      wbString(ANAM, 'Sound'));

  wbSoundTypeSounds :=
    wbRArrayS('Sounds',
      wbRStructSK([0], 'Sound', [
        IsTES5(
          wbFormIDCk(CSDI, 'Sound', [SNDR, NULL]),
          wbFormIDCk(CSDI, 'Sound', [SOUN, NULL])
        ).SetRequired,
        wbInteger(CSDC, 'Sound Chance', itU8).SetRequired
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(1, '{Chance: ', '}')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfSummaryNoSortKey)
        .IncludeFlag(dfCollapsed)
    ).SetRequired;

  wbXLOD := wbArray(XLOD, 'Distant LOD Data', wbFloat('Unknown'), 3);

  wbMHDTCELL :=
    IfThen(wbSimpleRecords,
      wbByteArray(MHDT, 'Max Height Data'),
      wbStruct(MHDT, 'Max Height Data', [
        wbFloat('Offset'),
        wbArray('Max Heights',
          wbArray('Row',
            wbInteger('Column', itU8),
          IsSF1(50, 32)).IncludeFlag(dfCollapsed),
        IsSF1(50, 32)).IncludeFlag(dfCollapsed)
      ]));

  wbMODT := wbModelInfo(MODT);
  wbDMDT := wbModelInfo(DMDT);

  wbStaticPartPlacements :=
    wbArrayS(DATA, 'Placements',
      wbStruct('Placement', [
        wbVec3Pos,
        wbVec3Rot,
        wbFloat('Scale')
      ]).SetSummaryKey([0, 1, 2])
        .SetSummaryMemberPrefixSuffix(2, 'Scale: ', '')
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed, wbCollapsePlacement)
    ).SetRequired;

  wbINOM :=
    wbArray(INOM, 'INFO Order (Masters only)',
      wbFormIDCk('INFO', [INFO], False, cpBenign).IncludeFlag(dfUseLoadOrder)
    ).IncludeFlag(dfInternalEditOnly)
     .IncludeFlag(dfDontSave)
     .IncludeFlag(dfDontAssign);

  wbINOA :=
    wbArray(INOA, 'INFO Order (All previous modules)',
      wbFormIDCk('INFO', [INFO], False, cpBenign).IncludeFlag(dfUseLoadOrder)
    ).IncludeFlag(dfInternalEditOnly)
     .IncludeFlag(dfDontSave)
     .IncludeFlag(dfDontAssign);

{>>>Landscape Common Defs<<<}
  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbLandNormals :=
    IfThen(wbSimpleRecords,
      wbByteArray(VNML, 'Vertex Normals', 3267, cpBenign, False, False, nil, wbLandNormalsGetCP),
      wbArray(VNML, 'Vertex Normals',
        wbArray('Row',
          wbStruct('Column', [
            wbInteger('X', itU8, nil, cpBenign, False, nil, nil, 0, wbLandNormalsGetCP),
            wbInteger('Y', itU8, nil, cpBenign, False, nil, nil, 0, wbLandNormalsGetCP),
            wbInteger('Z', itU8, nil, cpBenign, False, nil, nil, 0, wbLandNormalsGetCP)
          ]).SetSummaryKey([0, 1, 2])
            .SetSummaryMemberPrefixSuffix(0, '' + '(', '')
            .SetSummaryMemberPrefixSuffix(2, '', ')')
            .IncludeFlag(dfSummaryMembersNoName)
            .IncludeFlag(dfCollapsed, wbCollapseVec3),
        33).SetSummaryName('Columns')
           .IncludeFlag(dfCollapsed),
      33).SetSummaryName('Rows'));

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbLandHeights :=
    IfThen(wbSimpleRecords,
      wbByteArray(VHGT, 'Vertex Height Map'),
      wbStruct(VHGT, 'Vertex Height Map', [
        wbFloat('Offset'),
        wbArray('Height Data',
          wbArray('Row',
            wbInteger('Column', itS8),
          33).SetSummaryName('Columns')
             .IncludeFlag(dfCollapsed),
        33).SetSummaryName('Rows'),
        wbUnused(3)
      ]));

  //TES4,FO3,FNV,TES5,FO4,FO76
  wbLandColors :=
    IfThen(wbSimpleRecords,
      wbByteArray(VCLR, 'Vertex Colors'),
      wbArray(VCLR, 'Vertex Colors',
        wbArray('Row',
          wbStruct('Column', [
            wbInteger('Red', itU8),
            wbInteger('Green', itU8),
            wbInteger('Blue', itU8)
          ]).SetToStr(wbRGBAToStr)
            .IncludeFlag(dfCollapsed, wbCollapseVec3),
        33).SetSummaryName('Columns')
           .IncludeFlag(dfCollapsed),
      33).SetSummaryName('Rows'));

  //TES4,FO3,FNV,TES5,FO4,FO76
  wbLandLayers :=
    wbRArrayS('Layers',
      wbRUnion('Layer', [
        wbRStructSK([0], 'Base Layer', [
          wbStructSK(BTXT, [1, 3], 'Base Layer', [
            wbFormIDCk('Texture', [LTEX, NULL]),
            wbInteger('Quadrant', itU8, wbQuadrantEnum),
            wbUnused(1),
            wbInteger('Layer', itS16)
          ]).SetSummaryKeyOnValue([1,3,0])
            .SetSummaryPrefixSuffixOnValue(0, ' with ', '')
            .SetSummaryPrefixSuffixOnValue(1, '[', ']')
            .SetSummaryPrefixSuffixOnValue(3, 'on Layer [', ']')
            .IncludeFlagOnValue(dfSummaryMembersNoName)
            .IncludeFlagOnValue(dfSummaryNoSortKey)
            .IncludeFlag(dfCollapsed)
        ]).IncludeFlag(dfCollapsed),
        wbRStructSK([0], 'Alpha Layer', [
          wbStructSK(ATXT, [1, 3], 'Alpha Layer Header', [
            wbFormIDCk('Texture', [LTEX, NULL]),
            wbInteger('Quadrant', itU8, wbQuadrantEnum),
            wbUnused(1),
            wbInteger('Layer', itS16)
          ]).SetSummaryKeyOnValue([1,3,0])
            .SetSummaryPrefixSuffixOnValue(0, ' with ', '')
            .SetSummaryPrefixSuffixOnValue(1, '[', ']')
            .SetSummaryPrefixSuffixOnValue(3, 'on Layer [', ']')
            .IncludeFlagOnValue(dfSummaryMembersNoName)
            .IncludeFlagOnValue(dfSummaryNoSortKey)
            .IncludeFlag(dfCollapsed),
          IfThen(wbSimpleRecords,
            wbByteArray(VTXT, 'Alpha Layer Data'),
            wbArrayS(VTXT, 'Alpha Layer Data',
              wbStructSK([0], 'Cell', [
                wbInteger('Position', itU16, wbVTXTPosition),
                wbUnused(2),
                wbFloat('Opacity')
              ]).SetSummaryKey([2,0])
                .SetSummaryMemberPrefixSuffix(0, ' at Position [', ']')
                .SetSummaryMemberPrefixSuffix(2, 'Opacity: [', ']')
                .IncludeFlag(dfCollapsed)
                .IncludeFlag(dfSummaryMembersNoName)
                .IncludeFlag(dfSummaryNoSortKey)
            ).IncludeFlag(dfCollapsed))
        ]).IncludeFlag(dfCollapsed)
      ]));


{>>>Navmesh Common Defs<<<}
  //FO3,FNV,TES5,FO4,FO76,SF1
  wbNavmeshTriangleFlags :=
    wbFlags(wbSparseFlags([
      0, 'Edge 0-1 Link',
      1, 'Edge 1-2 Link',
      2, 'Edge 2-0 Link',
      3, 'Deleted',
      4, 'No Large Creatures',
      5, 'Overlapping',
      6, 'Preferred',
      9, 'Water',
     10, 'Door',
     11, 'Found'
    ], False, 12));

{ Flags below are wrong. The first 4 bit are an enum as follows:
0000 = Open Edge No Cover
0001 = wall no cover
0010 = ledge cover
0011 = UNUSED
0100 = cover  64
0101 = cover  80
0110 = cover  96
0111 = cover 112
1000 = cover 128
1001 = cover 144
1010 = cover 160
1011 = cover 176
1100 = cover 192
1101 = cover 208
1110 = cover 224
1111 = max cover
then 2 bit flags, then another such enum, and the rest is probably flags.
Can't properly represent that with current record definition methods.
}

  //FO3,FNV,TES5,FO4,FO76,SF1
  wbNavmeshCoverFlags :=
    wbFlags(wbSparseFlags([
      0, 'Edge 0-1 Cover Value 1/4',
      1, 'Edge 0-1 Cover Value 2/4',
      2, 'Edge 0-1 Cover Value 3/4',
      3, 'Edge 0-1 Cover Value 4/4',
      4, 'Edge 0-1 Left',
      5, 'Edge 0-1 Right',
      6, 'Edge 1-2 Cover Value 1/4',
      7, 'Edge 1-2 Cover Value 2/4',
      8, 'Edge 1-2 Cover Value 3/4',
      9, 'Edge 1-2 Cover Value 4/4',
     10, 'Edge 1-2 Left',
     11, 'Edge 1-2 Right',
     14, 'Autogen Cover'
    ], False, 15));

  //FO3,FNV,TES5,FO4,FO76,SF1
  wbNavmeshEdgeLinkEnum :=
    wbEnum([
      {0} 'Portal',
      {1} 'Ledge Up',
      {2} 'Ledge Down',
      {3} 'Enable/Disable Portal'
    ]);

{>>>Region Common Defs<<<}
  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbRegionAreas :=
    wbRArray('Region Areas',
      wbRStruct('Region Area', [
        wbInteger(RPLI, 'Edge Fall-off', itU32),
        wbArray(RPLD, 'Points',
          wbStruct('Point', [
            wbFloat('X'),
            wbFloat('Y')
          ])).SetAfterLoad(wbRPLDAfterLoad),
        IfThen(wbIsFallout4 or wbIsFallout76,
          wbUnknown(ANAM),
          nil)
      ]));

{>>>Weather Common Defs<<<}
  //TES4,FO3,FNV,TES5,FO4,FO76
  wbWeatherCloudTextures :=
    IfThen(wbIsFallout3,
      wbRStruct('Cloud Textures', [
        wbString(DNAM, 'Layer #0'),
        wbString(CNAM, 'Layer #1'),
        wbString(ANAM, 'Layer #2'),
        IsFNV(
          wbString(BNAM, 'Layer #3').SetDefaultEditValue('Sky\WastelandCloudCloudyLower01.dds'),
          wbString(BNAM, 'Layer #3').SetDefaultEditValue('Sky\Alpha.dds')
        ).SetRequired
      ]).IncludeFlag(dfAllowAnyMember)
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfStructFirstNotRequired)
        .SetRequired,
      wbRStruct('Cloud Textures', [
        wbString(_30_0TX, 'Layer #0'),
        wbString(_31_0TX, 'Layer #1'),
        wbString(_32_0TX, 'Layer #2'),
        wbString(_33_0TX, 'Layer #3'),
        wbString(_34_0TX, 'Layer #4'),
        wbString(_35_0TX, 'Layer #5'),
        wbString(_36_0TX, 'Layer #6'),
        wbString(_37_0TX, 'Layer #7'),
        wbString(_38_0TX, 'Layer #8'),
        wbString(_39_0TX, 'Layer #9'),
        wbString(_3A_0TX, 'Layer #10'),
        wbString(_3B_0TX, 'Layer #11'),
        wbString(_3C_0TX, 'Layer #12'),
        wbString(_3D_0TX, 'Layer #13'),
        wbString(_3E_0TX, 'Layer #14'),
        wbString(_3F_0TX, 'Layer #15'),
        wbString(_40_0TX, 'Layer #16'),
        wbString(A0TX, 'Layer #17'),
        wbString(B0TX, 'Layer #18'),
        wbString(C0TX, 'Layer #19'),
        wbString(D0TX, 'Layer #20'),
        wbString(E0TX, 'Layer #21'),
        wbString(F0TX, 'Layer #22'),
        wbString(G0TX, 'Layer #23'),
        wbString(H0TX, 'Layer #24'),
        wbString(I0TX, 'Layer #25'),
        wbString(J0TX, 'Layer #26'),
        wbString(K0TX, 'Layer #27'),
        wbString(L0TX, 'Layer #28')
      ]).IncludeFlag(dfAllowAnyMember)
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfStructFirstNotRequired));

  //FO3,FNV,TES5,FO4,FO76,SF1
  wbWeatherCloudSpeed :=
    IfThen(wbIsFallout3,
	    wbArray(ONAM, 'Cloud Speeds',
		    wbInteger('Layer', itU8),
      4),
	    wbRStruct('Cloud Speeds', [
	      wbArray(RNAM, 'Y Speeds',
		      wbInteger('Layer', itU8, wbWeatherCloudSpeedToStr, wbWeatherCloudSpeedToInt).SetDefaultEditValue('0'),
		    32).IncludeFlag(dfNotAlignable),
		    wbArray(QNAM, 'X Speeds',
		      wbInteger('Layer', itU8, wbWeatherCloudSpeedToStr, wbWeatherCloudSpeedToInt).SetDefaultEditValue('0'),
	    	32).IncludeFlag(dfNotAlignable)
           .SetRequired
	    ])).SetRequired;

  //FO3,FNV,TES4,FO4,FO76,SF1
  wbWeatherCloudColors :=
    wbArray(PNAM, 'Cloud Colors',
      wbWeatherTimeOfDay('Layer'),
    [], wbWeatherCloudColorsCounter)
      .IncludeFlagOnValue(dfArrayStaticSize)
      .IncludeFlagOnValue(dfFastAssign)
      .IncludeFlagOnValue(dfNotAlignable)
      .SetRequired;

  //TES5,FO4,FO76,SF1
  wbWeatherCloudAlphas :=
    wbArray(JNAM, 'Cloud Alphas',
      wbStruct('Layer', [
        wbFloat('Sunrise')
          .SetDefaultNativeValue(1.0)
          .IncludeFlag(dfSummaryNoName),
        wbFloat('Day')
          .SetDefaultNativeValue(1.0)
          .IncludeFlag(dfSummaryNoName),
        wbFloat('Sunset')
          .SetDefaultNativeValue(1.0)
          .IncludeFlag(dfSummaryNoName),
        wbFloat('Night')
          .SetDefaultNativeValue(1.0)
          .IncludeFlag(dfSummaryNoName),
        IsFO4Plus(
          wbFromVersion(111, wbFloat('Early Sunrise')
            .SetDefaultNativeValue(1.0)
            .IncludeFlag(dfSummaryNoName)),
          nil),
        IsFO4Plus(
          wbFromVersion(111, wbFloat('Late Sunrise')
            .SetDefaultNativeValue(1.0)
            .IncludeFlag(dfSummaryNoName)),
          nil),
        IsFO4Plus(
          wbFromVersion(111, wbFloat('Early Sunset')
            .SetDefaultNativeValue(1.0)
            .IncludeFlag(dfSummaryNoName)),
          nil),
        IsFO4Plus(
          wbFromVersion(111, wbFloat('Late Sunset')
            .SetDefaultNativeValue(1.0)
            .IncludeFlag(dfSummaryNoName)),
          nil)
      ]).SetSummaryKey([0,1,2,3,4,5,6,7])
        .IncludeFlag(dfCollapsed),
    32).IncludeFlag(dfNotAlignable)
       .SetRequired;

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbWeatherColors :=
    wbStruct(NAM0, 'Weather Colors', [
      wbWeatherTimeOfDay('Sky-Upper'),
      IfThen(wbGameMode < gmTES5,
        wbWeatherTimeOfDay('Fog'),
        wbWeatherTimeOfDay('Fog Near')),
      IsTES4(
        wbWeatherTimeOfDay('Clouds-Lower'),
        wbWeatherTimeOfDay('Unused')),
      wbWeatherTimeOfDay('Ambient'),
      wbWeatherTimeOfDay('Sunlight'),
      wbWeatherTimeOfDay('Sun'),
      wbWeatherTimeOfDay('Stars'),
      wbWeatherTimeOfDay('Sky-Lower'),
      wbWeatherTimeOfDay('Horizon'),
      IsTES4(
        wbWeatherTimeOfDay('Clouds-Upper'),
        IsFO3(
          wbWeatherTimeOfDay('Clouds (Unused)'),
          wbWeatherTimeOfDay('Effect Lighting'))),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(31, wbWeatherTimeOfDay('Cloud LOD Diffuse')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(31, wbWeatherTimeOfDay('Cloud LOD Ambient')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(31, wbWeatherTimeOfDay('Fog Far')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(35, wbWeatherTimeOfDay('Sky Statics')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(37, wbWeatherTimeOfDay('Water Multiplier')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(37, wbWeatherTimeOfDay('Sun Glare')),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFromVersion(37, wbWeatherTimeOfDay('Moon Glare')),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbWeatherTimeOfDay('Fog Near High')),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbWeatherTimeOfDay('Fog Far High')),
        nil)
    ]).SetRequired;

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbWeatherFogDistance :=
    wbStruct(FNAM, 'Fog Distance', [
      wbFloat('Day - Near'),
      wbFloat('Day - Far'),
      wbFloat('Night - Near'),
      wbFloat('Night - Far'),
      IfThen(wbGameMode > gmTES4,
        wbFloat('Day - Power').SetDefaultNativeValue(1),
        nil),
      IfThen(wbGameMode > gmTES4,
        wbFloat('Night - Power').SetDefaultNativeValue(1),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFloat('Day - Max').SetDefaultNativeValue(1),
        nil),
      IfThen(wbGameMode > gmFNV,
        wbFloat('Night - Max').SetDefaultNativeValue(1),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Day - Near Height Mid')),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Day - Near Height Range').SetDefaultNativeValue(10000)),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Night - Near Height Mid')),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Night - Near Height Range').SetDefaultNativeValue(10000)),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Day - High Density Scale').SetDefaultNativeValue(1)),
        nil),
      IsFO4Plus(
        wbFromVersion(119, wbFloat('Night - High Density Scale').SetDefaultNativeValue(1)),
        nil),
      IsFO4Plus(
        wbFromVersion(120, wbFloat('Day - Far Height Mid')),
        nil),
      IsFO4Plus(
        wbFromVersion(120, wbFloat('Day - Far Height Range')),
        nil),
      IsFO4Plus(
        wbFromVersion(120, wbFloat('Night - Far Height Mid')),
        nil),
      IsFO4Plus(
        wbFromVersion(120, wbFloat('Night - Far Height Range')),
        nil)
    ]).SetRequired;

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbWeatherLightningColor :=
    wbStruct('Lightning Color', [
      wbInteger('Red', itU8),
      wbInteger('Green', itU8),
      wbInteger('Blue', itU8)
    ]).SetToStr(wbRGBAToStr)
      .IncludeFlag(dfCollapsed, wbCollapseRGBA);

  //TES5,FO4,FO76,SF1
  wbWeatherDisabledLayers :=
    wbInteger(NAM1, 'Disabled Cloud Layers', itU32,
      wbFlags([
        '0','1','2','3','4','5','6','7','8','9','10','11',
        '12','13','14','15','16','17','18','19','20','21',
        '22','23','24','25','26','27','28','29','30','31'
      ])).SetDefaultNativeValue(IsTES5(0, 4294967295))
         .IncludeFlag(dfCollapsed, wbCollapseFlags)
         .SetRequired;

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbWeatherSounds :=
    wbRArray('Sounds',
      wbStruct(SNAM, 'Sound', [
        wbFormIDCK('Sound', [SNDR, SOUN, NULL]),
        wbInteger('Type', itU32,
          wbEnum([
            {0} 'Default',
            {1} 'Precipitation',
            {2} 'Wind',
            {3} 'Thunder'
          ]))
      ]).SetSummaryKeyOnValue([1, 0])
        .SetSummaryPrefixSuffixOnValue(1, '[', ']')
        .SetSummaryDelimiterOnValue(' ')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .IncludeFlag(dfCollapsed));

  //TES5,FO4,FO76,SF1
  wbWeatherImageSpaces :=
    wbStruct(IMSP, 'Image Spaces', [
      wbFormIDCK('Sunrise', [IMGS, NULL]).SetDefaultNativeValue(359),
      wbFormIDCK('Day', [IMGS, NULL]).SetDefaultNativeValue(359),
      wbFormIDCK('Sunset', [IMGS, NULL]).SetDefaultNativeValue(359),
      wbFormIDCK('Night', [IMGS, NULL]).SetDefaultNativeValue(359),
      IsFO4Plus(
        wbFromVersion(111, wbFormIDCK('Early Sunrise', [IMGS, NULL]).SetDefaultNativeValue(359)),
        nil),
      IsFO4Plus(
        wbFromVersion(111, wbFormIDCK('Late Sunrise', [IMGS, NULL]).SetDefaultNativeValue(359)),
        nil),
      IsFO4Plus(
        wbFromVersion(111, wbFormIDCK('Early Sunset', [IMGS, NULL]).SetDefaultNativeValue(359)),
        nil),
      IsFO4Plus(
        wbFromVersion(111, wbFormIDCK('Late Sunset', [IMGS, NULL]).SetDefaultNativeValue(359)),
        nil)
    ]).SetRequired;

  //FO4,FO76
  wbWeatherGodRays :=
    wbStruct(WGDR, 'God Rays', [
      wbFormIDCK('Sunrise', [GDRY, NULL]),
      wbFormIDCK('Day', [GDRY, NULL]),
      wbFormIDCK('Sunset', [GDRY, NULL]),
      wbFormIDCK('Night', [GDRY, NULL]),
      wbFormIDCK('Early Sunrise', [GDRY, NULL]),
      wbFormIDCK('Late Sunrise', [GDRY, NULL]),
      wbFormIDCK('Early Sunset', [GDRY, NULL]),
      wbFormIDCK('Late Sunset', [GDRY, NULL])
    ]);

  //TES5,FO76,SF1
  wbWeatherVolumetricLighting :=
    wbStruct(HNAM, 'Volumetric Lighting', [
      wbFormIDCK('Sunrise', [VOLI, NULL]),
      wbFormIDCK('Day', [VOLI, NULL]),
      wbFormIDCK('Sunset', [VOLI, NULL]),
      wbFormIDCK('Night', [VOLI, NULL]),
      IsFO4Plus(
        wbFormIDCK('Early Sunrise', [VOLI, NULL]),
        nil),
      IsFO4Plus(
        wbFormIDCK('Late Sunrise', [VOLI, NULL]),
        nil),
      IsFO4Plus(
        wbFormIDCK('Early Sunset', [VOLI, NULL]),
        nil),
      IsFO4Plus(
        wbFormIDCK('Late Sunset', [VOLI, NULL]),
        nil)
    ]);

  //TES5,FO4,FO76,SF1
  wbWeatherDirectionalLighting :=
    wbRStruct('Directional Ambient Lighting Colors', [
      wbAmbientColors(DALC, 'Sunrise').SetRequired,
      wbAmbientColors(DALC, 'Day').SetRequired,
      wbAmbientColors(DALC, 'Sunset').SetRequired,
      wbAmbientColors(DALC, 'Night').SetRequired,
      IsFO4Plus(
        wbFromVersion(111, DALC, wbAmbientColors('Early Sunrise')).SetRequired,
        nil),
      IsFO4Plus(
        wbFromVersion(111, DALC, wbAmbientColors('Late Sunrise')).SetRequired,
        nil),
      IsFO4Plus(
        wbFromVersion(111, DALC, wbAmbientColors('Early Sunset')).SetRequired,
        nil),
      IsFO4Plus(
        wbFromVersion(111, DALC, wbAmbientColors('Late Sunset')).SetRequired,
        nil)
    ]).SetRequired;

  //FO4,FO76,SF1
  wbWeatherMagic :=
    wbStruct(UNAM, 'Magic', [
      wbStruct('Lighting Strike', [
        wbFormIDCk('Spell', [SPEL, NULL]),
        wbFloat('Threshold')
      ]),
      wbStruct('Weather Activate', [
        wbFormIDCk('Spell', [SPEL, NULL]),
        wbFromVersion(130, wbFloat('Threshold'))
      ]),
      wbFromVersion(130, wbUnused(8))
    ]).SetRequired;

{>>>Worldspace Common Defs<<<}
  //TES5,FO4,FO76,SF1
  wbWorldLargeRefs :=
    wbRArray('Large References',
      wbStruct(RNAM, 'Cell', [
        wbInteger('Y', itS16, nil, cpIgnore),
        wbInteger('X', itS16, nil, cpIgnore),
        wbArray('References',
          wbStruct('Reference', [
            wbFormIDCk('Ref', [REFR], False, cpIgnore),
            wbInteger('Y', itS16, nil, cpIgnore),
            wbInteger('X', itS16, nil, cpIgnore)
          ]).SetSummaryKey([0])
            .IncludeFlag(dfCollapsed),
        -1).IncludeFlag(dfCollapsed)
           .IncludeFlag(dfNotAlignable)
      ]).SetSummaryKeyOnValue([1,0])
        .SetSummaryPrefixSuffixOnValue(0, 'Y: ', '')
        .SetSummaryPrefixSuffixOnValue(1, 'X: ', '')
        .SetSummaryDelimiterOnValue(', ')
        .IncludeFlag(dfCollapsed)
    ).SetDontShow(wbNeverShow)
     .IncludeFlag(dfCollapsed)
     .IncludeFlag(dfFastAssign)
     .IncludeFlag(dfNoCopyAsOverride)
     .IncludeFlag(dfNotAlignable);

  //TES5,FO4,FO76,SF1
  wbWorldMaxHeight :=
    wbStruct(MHDT, 'Max Height Data', [
      wbStruct('Dimensions', [
        wbStruct('Min', [
          wbInteger('X', itS16, nil, nil, cpBenign),
          wbInteger('Y', itS16, nil, nil, cpBenign)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, 'Min(', '')
          .SetSummaryMemberPrefixSuffix(1, '', ')')
          .SetSummaryDelimiter(', ')
          .IncludeFlag(dfCollapsed, wbCollapseObjectBounds),
        wbStruct('Max', [
          wbInteger('X', itS16, nil, nil, cpBenign),
          wbInteger('Y', itS16, nil, nil, cpBenign)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, 'Max(', '')
          .SetSummaryMemberPrefixSuffix(1, '', ')')
          .SetSummaryDelimiter(', ')
          .IncludeFlag(dfCollapsed, wbCollapseObjectBounds)
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, '[', '')
        .SetSummaryMemberPrefixSuffix(1, '', ']')
        .SetSummaryDelimiter(', ')
        .IncludeFlag(dfCollapsed, wbCollapseObjectBounds),
      IfThen(wbRemoveOffsetData,
        wbByteArray('Cell Heights', 0, cpBenign),
        wbArray('Cell Heights',
          wbArray('Row',
            wbStruct('Cell', [
              wbInteger('Bottom Left', itU8, nil, nil, cpBenign),
              wbInteger('Bottom Right', itU8, nil, nil, cpBenign),
              wbInteger('Top Left', itU8, nil, nil, cpBenign),
              wbInteger('Top Right', itU8, nil, nil, cpBenign)
            ]).SetSummaryKey([0, 1, 2, 3])
              .SetSummaryMemberPrefixSuffix(0, 'BL: ','')
              .SetSummaryMemberPrefixSuffix(1, 'BR: ','')
              .SetSummaryMemberPrefixSuffix(2, 'TL: ','')
              .SetSummaryMemberPrefixSuffix(3, 'TR: ','')
              .SetSummaryDelimiter(', ')
              .IncludeFlag(dfCollapsed),
          wbMHDTColumnsCounter)
            .SetSummaryName('Columns')
            .IncludeFlag(dfCollapsed)
            .IncludeFlag(dfNotAlignable)
        ).SetSummaryName('Rows')
         .IncludeFlag(dfCollapsed)
         .IncludeFlag(dfNotAlignable))
    ]).IncludeFlag(dfCollapsed)
      .IncludeFlag(dfFastAssign)
      .IncludeFlag(dfNoCopyAsOverride);

  //TES5,FO4,FO76,SF1
  wbWorldFixedCenter :=
    wbStruct(WCTR, 'Fixed Dimensions Center Cell', [
      wbInteger('X', itS16),
      wbInteger('Y', itS16)
    ]).SetSummaryKeyOnValue([0, 1])
      .SetSummaryPrefixSuffixOnValue(0, '(X: ', ', ')
      .SetSummaryPrefixSuffixOnValue(1, 'Y: ', ')')
      .IncludeFlag(dfCollapsed);

  //FO3,FNV,TES5,FO4,FO76,SF1
  wbWorldLODData :=
    wbRStruct('LOD Data', [
      wbFormIDCk(NAM3, 'LOD Water', [WATR]).SetDefaultNativeValue(24),
      wbFloat(NAM4, 'LOD Water Height').SetRequired
    ]).SetIsRemovable(wbWorldLODDataIsRemovable);

  //FO3,FNV,TES5,FO4,FO76,SF1
  wbWorldLandData :=
    wbStruct(DNAM, 'Land Data', [
      wbFloat('Default Land Height').SetDefaultNativeValue(-2048),
      wbFloat('Default Water Height').SetDefaultNativeValue(IsSF1(-200, 0))
    ]).SetSummaryKeyOnValue([0, 1])
      .SetSummaryPrefixSuffixOnValue(0, 'Land: ', '')
      .SetSummaryPrefixSuffixOnValue(1, 'Water: ', '')
      .SetSummaryDelimiterOnValue(', ')
      .SetIsRemovable(wbWorldLandDataIsRemovable)
      .IncludeFlag(dfCollapsed);

  //TES4,FO3,FNV,TES5,FO4,FO76,SF1
  wbWorldMapData :=
    wbStruct(MNAM, 'World Map Data', [
      wbStruct('Usable Dimensions', [
        wbInteger('X', itS32),
        wbInteger('Y', itS32)
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, '(X: ', '')
        .SetSummaryMemberPrefixSuffix(1, 'Y: ', ')')
        .SetSummaryDelimiter(', ')
        .IncludeFlag(dfCollapsed),
      wbStruct('Cell Coordinates', [
        wbStruct('NW Cell', [
          wbInteger('X', itS16),
          wbInteger('Y', itS16)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, '(X: ', '')
          .SetSummaryMemberPrefixSuffix(1, 'Y: ', ')')
          .SetSummaryDelimiter(', ')
          .IncludeFlag(dfCollapsed),
        wbStruct('SE Cell', [
          wbInteger('X', itS16),
          wbInteger('Y', itS16)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, '(X: ', '')
          .SetSummaryMemberPrefixSuffix(1, 'Y: ', ')')
          .SetSummaryDelimiter(', ')
          .IncludeFlag(dfCollapsed)
      ]).SetSummaryKey([0, 1])
        .SetSummaryMemberPrefixSuffix(0, '[NW', '')
        .SetSummaryMemberPrefixSuffix(1, 'SE', ']')
        .SetSummaryDelimiter(', ')
        .IncludeFlag(dfCollapsed),
      IsTES5(
        wbStruct('Camera Data', [
          wbFloat('Min Height').SetDefaultNativeValue(50000),
          wbFloat('Max Height').SetDefaultNativeValue(80000),
          wbFloat('Initial Pitch').SetDefaultNativeValue(50)
        ]),
        Nil)
    ]).SetIsRemovable(wbWorldMapDataIsRemovable);

  //FO3,FNV,TES5,SSE,FO4,FO76,SF1
  wbWorldMapOffset :=
    wbStruct(ONAM, 'World Map Offset Data', [
      wbFloat('World Map Scale').SetDefaultNativeValue(1),
      IsSF1(
        wbFloat('Cell X Offset', cpNormal, True, 0.01),
        wbFloat('Cell X Offset')),
      IsSF1(
        wbFloat('Cell Y Offset', cpNormal, True, 0.01),
        wbFloat('Cell Y Offset')),
      IsFO3(
        Nil,
        IsSF1(
          wbFloat('Cell Z Offset', cpNormal, True, 0.01),
          wbFloat('Cell Z Offset')))
    ]).SetRequired;

  //TES4,FO3,FNV,TES5,SSE,FO4,FO76,SF1
  wbWorldObjectBounds :=
    wbRStruct('Worldspace Bounds', [
      wbStruct(NAM0, 'Min', [
        IsSF1(
          wbFloat('X', cpNormal, True, 1/100).SetDefaultNativeValue(1073741824),
          wbFloat('X', cpNormal, True, 1/4096).SetDefaultEditValue('Default')),
        IsSF1(
          wbFloat('Y', cpNormal, True, 1/100).SetDefaultNativeValue(1073741824),
          wbFloat('Y', cpNormal, True, 1/4096).SetDefaultEditValue('Default'))
      ]).SetSummaryKeyOnValue([0, 1])
        .SetSummaryPrefixSuffixOnValue(0, 'X: (', '')
        .SetSummaryPrefixSuffixOnValue(1, 'Y: ', ')')
        .SetSummaryDelimiterOnValue(', ')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .SetRequired
        .IncludeFlag(dfCollapsed, wbCollapseObjectBounds),
      wbStruct(NAM9, 'Max', [
        IsSF1(
          wbFloat('X', cpNormal, True, 1/100).SetDefaultNativeValue(-1073741824),
          wbFloat('X', cpNormal, True, 1/4096).SetDefaultEditValue('Min')),
        IsSF1(
          wbFloat('Y', cpNormal, True, 1/100).SetDefaultNativeValue(-1073741824),
          wbFloat('Y', cpNormal, True, 1/4096).SetDefaultEditValue('Min'))
      ]).SetSummaryKeyOnValue([0, 1])
        .SetSummaryPrefixSuffixOnValue(0, '(X: ', '')
        .SetSummaryPrefixSuffixOnValue(1, 'Y: ', ')')
        .SetSummaryDelimiterOnValue(', ')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
        .SetRequired
        .IncludeFlag(dfCollapsed, wbCollapseObjectBounds)
    ]).SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '[Min', '')
      .SetSummaryMemberPrefixSuffix(1, 'Max', ']')
      .SetSummaryDelimiter(', ')
      .SetRequired
      .IncludeFlag(dfCollapsed, wbCollapseObjectBounds);

  //FO3,FNV
  wbWorldSwapsImpactData :=
    wbRStruct('Swaps Impact Data', [
      wbRArrayS('Impact Data',
        wbStructExSK(IMPS, [0, 1], [2], 'Impact Swap Data', [
          wbInteger('Material Type', itU32, wbWorldImpactMaterialEnum),
          wbFormIDCkNoReach('Original Data', [IPCT]),
          wbFormIDCk('New Data', [IPCT, NULL])
        ])).IncludeFlag(dfCollapsed),
      wbStruct(IMPF, 'Footstep Materials', [
        wbString('ConcSolid', 30),
        wbString('ConcBroken', 30),
        wbString('MetalSolid', 30),
        wbString('MetalHollow', 30),
        wbString('MetalSheet', 30),
        wbString('Wood', 30),
        wbString('Sand', 30),
        wbString('Dirt', 30),
        wbString('Grass', 30),
        wbString('Water', 30)
      ]).SetRequired
        .IncludeFlag(dfCollapsed)
    ]).IncludeFlag(dfCollapsed);

  //FO76,SF1
  wbWorldRegionEditorMap :=
    wbRStruct('Region Editor Map', [
      wbString(NAM5, 'Texture'),
      wbStruct(NAM6, 'Bounds', [
        wbInteger('NW Cell X', itS16),
        wbInteger('SE Cell Y', itS16),
        wbInteger('SE Cell X', itS16),
        wbInteger('NW Cell Y', itS16)
      ]).SetSummaryKeyOnValue([0,1,2,3])
        .SetSummaryPrefixSuffixOnValue(0, '[Min(X: ', ', ')
        .SetSummaryPrefixSuffixOnValue(1, 'Y: ', '), ')
        .SetSummaryPrefixSuffixOnValue(2, 'Max(X: ', ', ')
        .SetSummaryPrefixSuffixOnValue(3, 'Y: ', ')]')
        .IncludeFlag(dfCollapsed)
    ]);

  //FO76,SF1
  wbWorldWaterHeightData :=
    wbRStruct('Water Height Data', [
      wbArray(XCLW,'Cell Water Height Locations',
        wbStruct('Cell Water Height Location', [
          wbInteger('Cell Y', itS16),
          wbInteger('Cell X', itS16)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, '(X: ', '')
          .SetSummaryMemberPrefixSuffix(1, 'Y: ', ')')
          .SetSummaryDelimiter(', ')
          .IncludeFlag(dfCollapsed)
      ).IncludeFlagOnValue(dfArrayCanBeEmpty)
       .IncludeFlag(dfNotAlignable),
      wbArray(WHGT, 'Water Heights',
        wbFloat('Water Height')
      ).IncludeFlagOnValue(dfArrayCanBeEmpty)
       .SetRequired
       .IncludeFlag(dfNotAlignable)
    ]);

  //FO4,FO76,SF1
  wbWorldLevelData :=
    wbRStruct('World Default Level Data', [
      wbStruct(WLEV, 'Dimension', [
        wbStruct('NW Cell', [
          wbInteger('X', itS8),
          wbInteger('Y', itS8)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, '(X: ', '')
          .SetSummaryMemberPrefixSuffix(1, 'Y: ', ')')
          .SetSummaryDelimiter(', '),
        wbStruct('Size', [
          wbInteger('Width', itU8),
          wbInteger('Height', itU8)
        ]).SetSummaryKey([0, 1])
          .SetSummaryMemberPrefixSuffix(0, 'Width: ', '')
          .SetSummaryMemberPrefixSuffix(1, 'Height: ', '')
          .SetSummaryDelimiter(', ')
      ]),
      wbByteArray(WLEV, 'Cell Data')
    ]);

  //TES4,FO3,FNV,TES5,SSE,FO4,FO76,SF1
  wbWorldOffsetData :=
    IfThen(wbSimpleRecords,
      wbByteArray(OFST, 'Offsets', 0, cpIgnore).SetDontShow(wbNeverShow),
      wbArray(OFST, 'Offsets',
        wbArray('Row',
          wbInteger('Cell', itU32, nil, cpIgnore),
        wbWorldColumnsCounter)
        .SetSummaryName('Cells')
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfNotAlignable)
      ).SetDontShow(wbNeverShow)
       .SetSummaryName('Rows')
       .IncludeFlag(dfCollapsed)
       .IncludeFlag(dfFastAssign)
       .IncludeFlag(dfNoCopyAsOverride)
       .IncludeFlag(dfNotAlignable));

  //FO4,FO76,SF1
  wbWorldCellSizeData :=
    IfThen(wbSimpleRecords,
      wbByteArray(CLSZ, 'Cell Sizes', 0, cpIgnore).SetDontShow(wbNeverShow),
      wbArray(CLSZ, 'Cell Sizes',
        wbArray('Row',
          wbInteger('Cell', itU32, nil, cpIgnore),
        wbWorldColumnsCounter)
          .SetSummaryName('Cells')
          .IncludeFlag(dfCollapsed)
          .IncludeFlag(dfNotAlignable)
      ).SetDontShow(wbNeverShow)
       .SetSummaryName('Rows')
       .IncludeFlag(dfCollapsed)
       .IncludeFlag(dfFastAssign)
       .IncludeFlag(dfNoCopyAsOverride)
       .IncludeFlag(dfNotAlignable));

  //FO76
  wbWorldVisibleCellsData :=
    IfThen(wbSimpleRecords,
      wbByteArray(VISI, 'Visible Cells', 0, cpIgnore).SetDontShow(wbNeverShow),
      wbStruct(VISI, 'Visible Cells', [
        wbArray('Row',
          wbArray('Column',
            wbFormIDCK('Cell', [CELL, NULL], false, cpIgnore),
          wbWorldColumnsCounter)
            .SetSummaryName('Cells')
            .IncludeFlag(dfCollapsed)
            .IncludeFlag(dfNotAlignable),
        wbWorldRowsCounter)
          .SetSummaryName('Columns')
          .IncludeFlag(dfCollapsed)
          .IncludeFlag(dfNotAlignable),
        wbStruct('Dimensions', [
          wbInteger('Min Y', itS16, nil, cpIgnore),
          wbInteger('Min X', itS16, nil, cpIgnore),
          wbInteger('Rows', itU32, nil, cpIgnore)
        ])
      ]).SetDontShow(wbNeverShow)
        .IncludeFlag(dfCollapsed)
        .IncludeFlag(dfFastAssign)
        .IncludeFlag(dfNoCopyAsOverride));
end;

end.


