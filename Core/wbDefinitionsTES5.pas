{******************************************************************************

  This Source Code Form is subject to the terms of the Mozilla Public License, 
  v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain 
  one at https://mozilla.org/MPL/2.0/.

*******************************************************************************}

unit wbDefinitionsTES5;

{$I wbDefines.inc}

interface

uses
  wbInterface;

var
  wbBipedObjectFlags: IwbFlagsDef;
  wbEquipType: IwbFlagsDef;
  wbFurnitureEntryTypeFlags: IwbFlagsDef;
  wbPKDTInterruptFlags: IwbFlagsDef;

  wbPlayerActionEnum: IwbEnumDef;
  wbArmorTypeEnum: IwbEnumDef;
  wbAttackAnimationEnum: IwbEnumDef;
  wbBipedObjectEnum: IwbEnumDef;
  wbCastEnum: IwbEnumDef;
  wbCastingSourceEnum: IwbEnumDef;
  wbEmotionTypeEnum: IwbEnumDef;
  wbEntryPointsEnum: IwbEnumDef;
  wbEventFunctionEnum: IwbEnumDef;
  wbEventMemberEnum: IwbEnumDef;
  wbFormTypeEnum: IwbEnumDef;
  wbFurnitureAnimEnum: IwbEnumDef;
  wbLocationEnum: IwbEnumDef;
  wbMapMarkerEnum: IwbEnumDef;
  wbMiscStatEnum: IwbEnumDef;
  wbObjectTypeEnum: IwbEnumDef;
  wbPropTypeEnum: IwbEnumDef;
  wbQuestTypeEnum: IwbEnumDef;
  wbSkillEnum: IwbEnumDef;
  wbSoundLevelEnum: IwbEnumDef;
  wbTargetEnum: IwbEnumDef;
  wbTintMaskTypeEnum: IwbEnumDef;
  wbVatsValueFunctionEnum: IwbEnumDef;
  wbWardStateEnum: IwbEnumDef;
  wbWeaponAnimTypeEnum: IwbEnumDef;

procedure DefineTES5;

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

var
  wbEDID: IwbSubRecordDef;
  wbCOED: IwbSubRecordDef;
  wbXLCM: IwbSubRecordDef;
  wbDEST: IwbSubRecordStructDef;
  wbDESTActor: IwbSubRecordStructDef;
  wbDODT: IwbSubRecordDef;
  wbSPLO: IwbSubRecordDef;
  wbSPLOs: IwbSubRecordArrayDef;
  wbCNTO: IwbRecordMemberDef;
  wbCNTOs: IwbSubRecordArrayDef;
  wbCNTONoReach: IwbRecordMemberDef;
  wbCNTOsNoReach: IwbSubRecordArrayDef;
  wbAIDT: IwbSubRecordDef;
  wbCSDT: IwbSubRecordStructDef;
  wbCSDTs: IwbSubRecordArrayDef;
  wbFULL: IwbSubRecordDef;
  wbFULLActor: IwbSubRecordDef;
  wbFULLReq: IwbSubRecordDef;
  wbDESC: IwbSubRecordDef;
  wbDESCReq: IwbSubRecordDef;
  wbXSCL: IwbSubRecordDef;
  wbMODD: IwbSubRecordDef;
  wbMODS: IwbSubRecordDef;
  wbMO2S: IwbSubRecordDef;
  wbMO3S: IwbSubRecordDef;
  wbMO4S: IwbSubRecordDef;
  wbConditions: IwbRecordMemberDef;
  wbXESP: IwbSubRecordDef;
  wbICON: IwbSubRecordStructDef;
  wbICONReq: IwbSubRecordStructDef;
  wbICO2: IwbSubRecordStructDef;
  wbActorValue: IwbIntegerDef;
  wbETYP: IwbSubRecordDef;
  wbETYPReq: IwbSubRecordDef;
  wbEFID: IwbSubRecordDef;
  wbEFIT: IwbSubRecordDef;
  wbEffectsReq: IwbSubRecordArrayDef;
  wbFirstPersonFlagsU32: IwbIntegerDef;
  wbBODT: IwbSubRecordDef;
  wbBOD2: IwbSubRecordDef;
  wbBODTBOD2: IwbRecordMemberDef;
  wbScriptEntry: IwbValueDef;
  wbScriptFlags: IwbIntegerDef;
  wbScriptPropertyObject: IwbUnionDef;
  wbScriptProperty: IwbValueDef;
  wbScriptProperties: IwbArrayDef;
  wbScriptFragments: IwbValueDef;
  wbScriptFragmentsQuest: IwbValueDef;
  wbScriptFragmentsInfo: IwbValueDef;
  wbScriptFragmentsPack: IwbValueDef;
  wbScriptFragmentsScen: IwbValueDef;
  wbPLDT: IwbSubRecordDef;
  wbPLVD: IwbSubRecordDef;
  wbTargetData: IwbStructDef;
  wbAttackData: IwbSubRecordStructDef;
  wbLLCT: IwbSubRecordDef;
  wbLVLD: IwbSubRecordDef;
  wbVMAD: IwbSubRecordDef;
  wbVMADFragmentedPERK: IwbSubRecordDef;
  wbVMADFragmentedPACK: IwbSubRecordDef;
  wbVMADFragmentedQUST: IwbSubRecordDef;
  wbVMADFragmentedSCEN: IwbSubRecordDef;
  wbVMADFragmentedINFO: IwbSubRecordDef;
  wbCOCT: IwbSubRecordDef;
  wbCITC: IwbSubRecordDef;
  wbCITCReq: IwbSubRecordDef;
  wbMGEFData: IwbSubRecordStructDef;
  wbMGEFType: IwbIntegerDef;
  wbSPIT: IwbSubRecordDef;
  wbDMDSs: IwbSubRecordDef;
  wbMO5S: IwbSubRecordDef;
  wbSPCT: IwbSubRecordDef;
  wbTints: IwbSubRecordArrayDef;
  wbRACE_DATAFlags01: IwbIntegerDef;
  wbPhonemeTargets: IwbSubRecordDef;
  wbNoseMorphFlags: IwbIntegerDef;
  wbBrowMorphFlags: IwbIntegerDef;
  wbEyesMorphFlags01: IwbIntegerDef;
  wbEyesMorphFlags02: IwbIntegerDef;
  wbLipMorphFlags: IwbIntegerDef;
  wbPHWT: IwbSubRecordStructDef;
  wbMorphs: IwbSubRecordStructDef;
  wbQUSTAliasFlags: IwbSubRecordDef;
  wbPDTO: IwbSubRecordDef;
  wbPDTOs: IwbSubRecordArrayDef;
  wbUNAMs: IwbSubRecordArrayDef;
  wbNull: IwbValueDef;
  wbYNAM: IwbSubRecordDef;
  wbZNAM: IwbSubRecordDef;
  wbTVDT: IwbSubRecordDef;
  wbNVNM: IwbSubRecordDef;
  wbStaticPart: IwbRecordMemberDef;
  a, b, c : TVarRecs;
  s: string;
  wbMenuButton: IwbRecordMemberDef;
  wbFactionRank: IwbRecordMemberDef;
  wbSubtypeNamesEnum: IwbEnumDef;

type
  TConditionParameterType = (
    //Misc
	  {1} ptNone,
    {2} ptFloat,
	  {3} ptInteger,
    {4} ptAlias,
	  {5} ptEvent,
	  {6} ptPackdata,
	  {7} ptQuestStage,
	  {8} ptVariableName,
	  {9} ptVATSValueParam,

	  //Enums
	  {10} ptActorValue,         //wbActorValueEnum
	  {11} ptAlignment,         //wbAlignmentEnum
	  {12} ptAxis,               //wbAxisEnum
	  {13} ptCastingSource,     //wbCastingSourceEnum
	  {14} ptCrimeType,          //wbCrimeTypeEnum
	  {15} ptCriticalStage,     //wbCriticalStageEnum
	  {16} ptFormType,          //wbFormTypeEnum
	  {17} ptFurnitureAnim,     //wbFurnitureAnimEnum
	  {18} ptFurnitureEntry,    //wbFurnitureEntryEnum
	  {19} ptMiscStat,      	  //wbMiscStatEnum
	  {20} ptPlayerAction,      //wbPlayerActionEnum
	  {21} ptSex,                //wbSexEnum
	  {22} ptVATSValueFunction, //wbVATSValueFunctionEnum
	  {23} ptWardState,         //wbWardStateEnum


	  //FormIDs
    {24} ptActor,           //ACHR, PLYR, REFR,
	  {25} ptActorBase,       //NPC_
	  {26} ptAssociationType, //ASTP
	  {27} ptBaseObject,      //ACTI, ALCH, AMMO, ARMA, ARMO, ASPC, BOOK, CONT, DOOR, ENCH, FLOR, FURN, GRAS, HAZD, IDLM, KEYM, LIGH, LVLI, LVSP, MISC, MSTT, NPC_, PROJ, SCRL, SHOU, SLGM, SOUN, SPEL, STAT, TACT, TREE, WEAP
	  {28} ptCell,            //CELL
	  {29} ptClass,           //CLAS
	  {30} ptEffectItem,      //SPEL
	  {31} ptEncounterZone,   //ECZN
	  {32} ptEquipType,       //EQUP
    {33} ptEventData,       //LCTN, KYWD or FLST
	  {34} ptFaction,         //FACT
	  {35} ptFactionOpt,      //FACT, NULL
	  {36} ptFormList,        //FLST
	  {37} ptFurniture,       //FURN
	  {38} ptGlobal,          //GLOB
	  {39} ptIdleForm,        //IDLE
	  {40} ptInventoryObject, //ALCH, AMMO, ARMO, BOOK, COBJ, FLST, INGR, KEYM, LIGH, LVLI, MISC, SCRL, SLGM, WEAP
	  {41} ptKeyword,         //KYWD
	  {42} ptKnowable,        //ENCH, MGEF, WOOP
	  {43} ptLocation,        //LCTN
	  {44} ptLocationRefType, //LCRT
	  {45} ptMagicEffect,     //MGEF
	  {46} ptOwner,           //FACT, NPC_
    {47} ptPackage,         //PACK
	  {48} ptPerk,            //PERK
	  {49} ptQuest,           //QUST
	  {50} ptRace,            //RACE
	  {51} ptReference,  		  //ACHR, PARW, PBAR, PBEA, PCON, PFLA, PGRE, PHZD, PLYR, PMIS, REFR
    {52} ptRegion,          //REGN
	  {53} ptScene,           //SCEN
	  {54} ptShout,           //SHOU
	  {55} ptVoiceType,       //FLST, VTYP
    {56} ptWeather,         //WTHR
    {57} ptWorldspace       //WRLD
  );

  PConditionFunction = ^TConditionFunction;
  TConditionFunction = record
    Index: Integer;
    Name: string;
    ParamType1: TConditionParameterType;
    ParamType2: TConditionParameterType;
    ParamType3: TConditionParameterType;
  end;

const
  wbConditionFunctions : array[0..401] of TConditionFunction = (
    (Index:   0; Name: 'GetWantBlocking'),
    (Index:   1; Name: 'GetDistance'; ParamType1: ptReference),
    (Index:   5; Name: 'GetLocked'),
    (Index:   6; Name: 'GetPos'; ParamType1: ptAxis),
    (Index:   8; Name: 'GetAngle'; ParamType1: ptAxis),
    (Index:  10; Name: 'GetStartingPos'; ParamType1: ptAxis),
    (Index:  11; Name: 'GetStartingAngle'; ParamType1: ptAxis),
    (Index:  12; Name: 'GetSecondsPassed'),
    (Index:  14; Name: 'GetActorValue'; ParamType1: ptActorValue),
    (Index:  18; Name: 'GetCurrentTime'),
    (Index:  24; Name: 'GetScale'),
    (Index:  25; Name: 'IsMoving'),
    (Index:  26; Name: 'IsTurning'),
    (Index:  27; Name: 'GetLineOfSight'; ParamType1: ptReference),
    (Index:  32; Name: 'GetInSameCell'; ParamType1: ptReference),
    (Index:  35; Name: 'GetDisabled'),
    (Index:  36; Name: 'MenuMode'; ParamType1: ptInteger),
    (Index:  39; Name: 'GetDisease'),
    (Index:  41; Name: 'GetClothingValue'),
    (Index:  42; Name: 'SameFaction'; ParamType1: ptActor),
    (Index:  43; Name: 'SameRace'; ParamType1: ptActor),
    (Index:  44; Name: 'SameSex'; ParamType1: ptActor),
    (Index:  45; Name: 'GetDetected'; ParamType1: ptActor),
    (Index:  46; Name: 'GetDead'),
    (Index:  47; Name: 'GetItemCount'; ParamType1: ptInventoryObject),
    (Index:  48; Name: 'GetGold'),
    (Index:  49; Name: 'GetSleeping'),
    (Index:  50; Name: 'GetTalkedToPC'),
    (Index:  53; Name: 'GetScriptVariable'; ParamType1: ptReference; ParamType2: ptVariableName),
    (Index:  56; Name: 'GetQuestRunning'; ParamType1: ptQuest),
    (Index:  58; Name: 'GetStage'; ParamType1: ptQuest),
    (Index:  59; Name: 'GetStageDone'; ParamType1: ptQuest; ParamType2: ptQuestStage),
    (Index:  60; Name: 'GetFactionRankDifference'; ParamType1: ptFaction; ParamType2: ptActor),
    (Index:  61; Name: 'GetAlarmed'),
    (Index:  62; Name: 'IsRaining'),
    (Index:  63; Name: 'GetAttacked'),
    (Index:  64; Name: 'GetIsCreature'),
    (Index:  65; Name: 'GetLockLevel'),
    (Index:  66; Name: 'GetShouldAttack'; ParamType1: ptActor),
    (Index:  67; Name: 'GetInCell'; ParamType1: ptCell),
    (Index:  68; Name: 'GetIsClass'; ParamType1: ptClass),
    (Index:  69; Name: 'GetIsRace'; ParamType1: ptRace),
    (Index:  70; Name: 'GetIsSex'; ParamType1: ptSex),
    (Index:  71; Name: 'GetInFaction'; ParamType1: ptFaction),
    (Index:  72; Name: 'GetIsID'; ParamType1: ptBaseObject),
    (Index:  73; Name: 'GetFactionRank'; ParamType1: ptFaction),
    (Index:  74; Name: 'GetGlobalValue'; ParamType1: ptGlobal),
    (Index:  75; Name: 'IsSnowing'),
    (Index:  77; Name: 'GetRandomPercent'),
    (Index:  79; Name: 'GetQuestVariable'; ParamType1: ptQuest; ParamType2: ptVariableName),
    (Index:  80; Name: 'GetLevel'),
    (Index:  81; Name: 'IsRotating'),
    (Index:  84; Name: 'GetDeadCount'; ParamType1: ptActorBase),
    (Index:  91; Name: 'GetIsAlerted'),
    (Index:  98; Name: 'GetPlayerControlsDisabled'; ParamType1: ptInteger; ParamType2: ptInteger),
    (Index:  99; Name: 'GetHeadingAngle'; ParamType1: ptReference),
    (Index: 101; Name: 'IsWeaponMagicOut'),
    (Index: 102; Name: 'IsTorchOut'),
    (Index: 103; Name: 'IsShieldOut'),
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
    (Index: 129; Name: 'GetPCIsClass'; ParamType1: ptClass),
    (Index: 130; Name: 'GetPCIsRace'; ParamType1: ptRace),
    (Index: 131; Name: 'GetPCIsSex'; ParamType1: ptSex),
    (Index: 132; Name: 'GetPCInFaction'; ParamType1: ptFaction),
    (Index: 133; Name: 'SameFactionAsPC'),
    (Index: 134; Name: 'SameRaceAsPC'),
    (Index: 135; Name: 'SameSexAsPC'),
    (Index: 136; Name: 'GetIsReference'; ParamType1: ptReference),
    (Index: 141; Name: 'IsTalking'),
    (Index: 142; Name: 'GetWalkSpeed'),
    (Index: 143; Name: 'GetCurrentAIProcedure'),
    (Index: 144; Name: 'GetTrespassWarningLevel'),
    (Index: 145; Name: 'IsTrespassing'),
    (Index: 146; Name: 'IsInMyOwnedCell'),
    (Index: 147; Name: 'GetWindSpeed'),
    (Index: 148; Name: 'GetCurrentWeatherPercent'),
    (Index: 149; Name: 'GetIsCurrentWeather'; ParamType1: ptWeather),
    (Index: 150; Name: 'IsContinuingPackagePCNear'),
    (Index: 152; Name: 'GetIsCrimeFaction'; ParamType1: ptFaction),
    (Index: 153; Name: 'CanHaveFlames'),
    (Index: 154; Name: 'HasFlames'),
    (Index: 157; Name: 'GetOpenState'),
    (Index: 159; Name: 'GetSitting'),
    (Index: 161; Name: 'GetIsCurrentPackage'; ParamType1: ptPackage),
    (Index: 162; Name: 'IsCurrentFurnitureRef'; ParamType1: ptReference),
    (Index: 163; Name: 'IsCurrentFurnitureObj'; ParamType1: ptFurniture),
    (Index: 170; Name: 'GetDayOfWeek'),
    (Index: 172; Name: 'GetTalkedToPCParam'; ParamType1: ptActor),
    (Index: 175; Name: 'IsPCSleeping'),
    (Index: 176; Name: 'IsPCAMurderer'),
    (Index: 180; Name: 'HasSameEditorLocAsRef'; ParamType1: ptReference; ParamType2: ptKeyword),
    (Index: 181; Name: 'HasSameEditorLocAsRefAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 182; Name: 'GetEquipped'; ParamType1: ptInventoryObject),
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
    (Index: 219; Name: 'GetAnimAction'),
    (Index: 223; Name: 'IsSpellTarget'; ParamType1: ptEffectItem),
    (Index: 224; Name: 'GetVATSMode'),
    (Index: 225; Name: 'GetPersuasionNumber'),
    (Index: 226; Name: 'GetVampireFeed'),
    (Index: 227; Name: 'GetCannibal'),
    (Index: 228; Name: 'GetIsClassDefault'; ParamType1: ptClass),
    (Index: 229; Name: 'GetClassDefaultMatch'),
    (Index: 230; Name: 'GetInCellParam'; ParamType1: ptCell; ParamType2: ptReference),
    (Index: 235; Name: 'GetVatsTargetHeight'),
    (Index: 237; Name: 'GetIsGhost'),
    (Index: 242; Name: 'GetUnconscious'),
    (Index: 244; Name: 'GetRestrained'),
    (Index: 246; Name: 'GetIsUsedItem'; ParamType1: ptBaseObject),
    (Index: 247; Name: 'GetIsUsedItemType'; ParamType1: ptFormType),
    (Index: 248; Name: 'IsScenePlaying'; ParamType1: ptScene),
    (Index: 249; Name: 'IsInDialogueWithPlayer'),
    (Index: 250; Name: 'GetLocationCleared'; ParamType1: ptLocation),
    (Index: 254; Name: 'GetIsPlayableRace'),
    (Index: 255; Name: 'GetOffersServicesNow'),
    (Index: 258; Name: 'HasAssociationType'; ParamType1: ptActor; ParamType2: ptAssociationType),
    (Index: 259; Name: 'HasFamilyRelationship'; ParamType1: ptActor),
    (Index: 261; Name: 'HasParentRelationship'; ParamType1: ptActor),
    (Index: 262; Name: 'IsWarningAbout'; ParamType1: ptFormList),
    (Index: 263; Name: 'IsWeaponOut'),
    (Index: 264; Name: 'HasSpell'; ParamType1: ptEffectItem),
    (Index: 265; Name: 'IsTimePassing'),
    (Index: 266; Name: 'IsPleasant'),
    (Index: 267; Name: 'IsCloudy'),
    (Index: 274; Name: 'IsSmallBump'),
    (Index: 277; Name: 'GetBaseActorValue'; ParamType1: ptActorValue),
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
    (Index: 359; Name: 'GetInCurrentLoc'; ParamType1: ptLocation),
    (Index: 360; Name: 'GetInCurrentLocAlias'; ParamType1: ptAlias),
    (Index: 361; Name: 'GetTimeDead'),
    (Index: 362; Name: 'HasLinkedRef'; ParamType1: ptKeyword),
    (Index: 365; Name: 'IsChild'),
    (Index: 366; Name: 'GetStolenItemValueNoCrime'; ParamType1: ptFaction),
    (Index: 367; Name: 'GetLastPlayerAction'),
    (Index: 368; Name: 'IsPlayerActionActive'; ParamType1: ptInteger),
    (Index: 370; Name: 'IsTalkingActivatorActor'; ParamType1: ptActor),
    (Index: 372; Name: 'IsInList'; ParamType1: ptFormList),
    (Index: 373; Name: 'GetStolenItemValue'; ParamType1: ptFaction),
    (Index: 375; Name: 'GetCrimeGoldViolent'; ParamType1: ptFactionOpt),
    (Index: 376; Name: 'GetCrimeGoldNonviolent'; ParamType1: ptFactionOpt),
    (Index: 378; Name: 'HasShout'; ParamType1: ptShout),
    (Index: 381; Name: 'GetHasNote'; ParamType1: ptInteger),
    (Index: 390; Name: 'GetHitLocation'),
    (Index: 391; Name: 'IsPC1stPerson'),
    (Index: 396; Name: 'GetCauseofDeath'),
    (Index: 397; Name: 'IsLimbGone'; ParamType1: ptInteger),
    (Index: 398; Name: 'IsWeaponInList'; ParamType1: ptFormList),
    (Index: 402; Name: 'IsBribedbyPlayer'),
    (Index: 403; Name: 'GetRelationshipRank'; ParamType1: ptReference),
    (Index: 407; Name: 'GetVATSValue'; ParamType1: ptVATSValueFunction; ParamType2: ptVATSValueParam),
    (Index: 408; Name: 'IsKiller'; ParamType1: ptActor),
    (Index: 409; Name: 'IsKillerObject'; ParamType1: ptFormList),
    (Index: 410; Name: 'GetFactionCombatReaction'; ParamType1: ptFaction; ParamType2: ptFaction),
    (Index: 414; Name: 'Exists'; ParamType1: ptReference),
    (Index: 415; Name: 'GetGroupMemberCount'),
    (Index: 416; Name: 'GetGroupTargetCount'),
    (Index: 426; Name: 'GetIsVoiceType'; ParamType1: ptVoiceType),
    (Index: 427; Name: 'GetPlantedExplosive'),
    (Index: 429; Name: 'IsScenePackageRunning'),
    (Index: 430; Name: 'GetHealthPercentage'),
    (Index: 432; Name: 'GetIsObjectType'; ParamType1: ptFormType),
    (Index: 434; Name: 'GetDialogueEmotion'),
    (Index: 435; Name: 'GetDialogueEmotionValue'),
    (Index: 437; Name: 'GetIsCreatureType'; ParamType1: ptInteger),
    (Index: 444; Name: 'GetInCurrentLocFormList'; ParamType1: ptFormList),
    (Index: 445; Name: 'GetInZone'; ParamType1: ptEncounterZone),
    (Index: 446; Name: 'GetVelocity'; ParamType1: ptAxis),
    (Index: 447; Name: 'GetGraphVariableFloat'; ParamType1: ptVariableName),
    (Index: 448; Name: 'HasPerk'; ParamType1: ptPerk; ParamType2: ptInteger),
    (Index: 449; Name: 'GetFactionRelation'; ParamType1: ptActor),
    (Index: 450; Name: 'IsLastIdlePlayed'; ParamType1: ptIdleForm),
    (Index: 453; Name: 'GetPlayerTeammate'),
    (Index: 454; Name: 'GetPlayerTeammateCount'),
    (Index: 458; Name: 'GetActorCrimePlayerEnemy'),
    (Index: 459; Name: 'GetCrimeGold'; ParamType1: ptFactionOpt),
    (Index: 463; Name: 'IsPlayerGrabbedRef'; ParamType1: ptReference),
    (Index: 465; Name: 'GetKeywordItemCount'; ParamType1: ptKeyword),
    (Index: 470; Name: 'GetDestructionStage'),
    (Index: 473; Name: 'GetIsAlignment'; ParamType1: ptAlignment),
    (Index: 476; Name: 'IsProtected'),
    (Index: 477; Name: 'GetThreatRatio'; ParamType1: ptActor),
    (Index: 479; Name: 'GetIsUsedItemEquipType'; ParamType1: ptEquipType),
    (Index: 487; Name: 'IsCarryable'),
    (Index: 488; Name: 'GetConcussed'),
    (Index: 491; Name: 'GetMapMarkerVisible'),
    (Index: 493; Name: 'PlayerKnows'; ParamType1: ptKnowable),
    (Index: 494; Name: 'GetPermanentActorValue'; ParamType1: ptActorValue),
    (Index: 495; Name: 'GetKillingBlowLimb'),
    (Index: 497; Name: 'CanPayCrimeGold'),
    (Index: 499; Name: 'GetDaysInJail'),
    (Index: 500; Name: 'EPAlchemyGetMakingPoison'),
    (Index: 501; Name: 'EPAlchemyEffectHasKeyword'; ParamType1: ptKeyword),
    (Index: 503; Name: 'GetAllowWorldInteractions'),
    (Index: 508; Name: 'GetLastHitCritical'),
    (Index: 513; Name: 'IsCombatTarget'; ParamType1: ptActor),
    (Index: 515; Name: 'GetVATSRightAreaFree'; ParamType1: ptReference),
    (Index: 516; Name: 'GetVATSLeftAreaFree'; ParamType1: ptReference),
    (Index: 517; Name: 'GetVATSBackAreaFree'; ParamType1: ptReference),
    (Index: 518; Name: 'GetVATSFrontAreaFree'; ParamType1: ptReference),
    (Index: 519; Name: 'GetLockIsBroken'),
    (Index: 520; Name: 'IsPS3'),
    (Index: 521; Name: 'IsWin32'),
    (Index: 522; Name: 'GetVATSRightTargetVisible'; ParamType1: ptReference),
    (Index: 523; Name: 'GetVATSLeftTargetVisible'; ParamType1: ptReference),
    (Index: 524; Name: 'GetVATSBackTargetVisible'; ParamType1: ptReference),
    (Index: 525; Name: 'GetVATSFrontTargetVisible'; ParamType1: ptReference),
    (Index: 528; Name: 'IsInCriticalStage'; ParamType1: ptCriticalStage),
    (Index: 530; Name: 'GetXPForNextLevel'),
    (Index: 533; Name: 'GetInfamy'; ParamType1: ptFaction),
    (Index: 534; Name: 'GetInfamyViolent'; ParamType1: ptFaction),
    (Index: 535; Name: 'GetInfamyNonViolent'; ParamType1: ptFaction),
    (Index: 543; Name: 'GetQuestCompleted'; ParamType1: ptQuest),
    (Index: 547; Name: 'IsGoreDisabled'),
    (Index: 550; Name: 'IsSceneActionComplete'; ParamType1: ptScene; ParamType2: ptInteger),
    (Index: 552; Name: 'GetSpellUsageNum'; ParamType1: ptEffectItem),
    (Index: 554; Name: 'GetActorsInHigh'),
    (Index: 555; Name: 'HasLoaded3D'),
    (Index: 560; Name: 'HasKeyword'; ParamType1: ptKeyword),
    (Index: 561; Name: 'HasRefType'; ParamType1: ptLocationRefType),
    (Index: 562; Name: 'LocationHasKeyword'; ParamType1: ptKeyword),
    (Index: 563; Name: 'LocationHasRefType'; ParamType1: ptLocationRefType),
    (Index: 565; Name: 'GetIsEditorLocation'; ParamType1: ptLocation),
    (Index: 566; Name: 'GetIsAliasRef'; ParamType1: ptAlias),
    (Index: 567; Name: 'GetIsEditorLocAlias'; ParamType1: ptAlias),
    (Index: 568; Name: 'IsSprinting'),
    (Index: 569; Name: 'IsBlocking'),
    (Index: 570; Name: 'HasEquippedSpell'; ParamType1: ptCastingSource),
    (Index: 571; Name: 'GetCurrentCastingType'; ParamType1: ptCastingSource),
    (Index: 572; Name: 'GetCurrentDeliveryType'; ParamType1: ptCastingSource),
    (Index: 574; Name: 'GetAttackState'),
    (Index: 576; Name: 'GetEventData'; ParamType1: ptEvent; ParamType2: ptEventData; ParamType3: ptNone),
    (Index: 577; Name: 'IsCloserToAThanB'; ParamType1: ptReference; ParamType2: ptReference),
    (Index: 579; Name: 'GetEquippedShout'; ParamType1: ptShout),
    (Index: 580; Name: 'IsBleedingOut'),
    (Index: 584; Name: 'GetRelativeAngle'; ParamType1: ptReference; ParamType2: ptAxis),
    (Index: 589; Name: 'GetMovementDirection'),
    (Index: 590; Name: 'IsInScene'),
    (Index: 591; Name: 'GetRefTypeDeadCount'; ParamType1: ptLocation; ParamType2: ptLocationRefType),
    (Index: 592; Name: 'GetRefTypeAliveCount'; ParamType1: ptLocation; ParamType2: ptLocationRefType),
    (Index: 594; Name: 'GetIsFlying'),
    (Index: 595; Name: 'IsCurrentSpell'; ParamType1: ptEffectItem; ParamType2: ptCastingSource),
    (Index: 596; Name: 'SpellHasKeyword'; ParamType1: ptCastingSource; ParamType2: ptKeyword),
    (Index: 597; Name: 'GetEquippedItemType'; ParamType1: ptCastingSource),
    (Index: 598; Name: 'GetLocationAliasCleared'; ParamType1: ptAlias),
    (Index: 600; Name: 'GetLocAliasRefTypeDeadCount'; ParamType1: ptAlias; ParamType2: ptLocationRefType),
    (Index: 601; Name: 'GetLocAliasRefTypeAliveCount'; ParamType1: ptAlias; ParamType2: ptLocationRefType),
    (Index: 602; Name: 'IsWardState'; ParamType1: ptWardState),
    (Index: 603; Name: 'IsInSameCurrentLocAsRef'; ParamType1: ptReference; ParamType2: ptKeyword),
    (Index: 604; Name: 'IsInSameCurrentLocAsRefAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 605; Name: 'LocAliasIsLocation'; ParamType1: ptAlias; ParamType2: ptLocation),
    (Index: 606; Name: 'GetKeywordDataForLocation'; ParamType1: ptLocation; ParamType2: ptKeyword),
    (Index: 608; Name: 'GetKeywordDataForAlias'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 610; Name: 'LocAliasHasKeyword'; ParamType1: ptAlias; ParamType2: ptKeyword),
    (Index: 611; Name: 'IsNullPackageData'; ParamType1: ptPackdata),
    (Index: 612; Name: 'GetNumericPackageData'; ParamType1: ptInteger),
    (Index: 613; Name: 'IsFurnitureAnimType'; ParamType1: ptFurnitureAnim),
    (Index: 614; Name: 'IsFurnitureEntryType'; ParamType1: ptFurnitureEntry),
    (Index: 615; Name: 'GetHighestRelationshipRank'),
    (Index: 616; Name: 'GetLowestRelationshipRank'),
    (Index: 617; Name: 'HasAssociationTypeAny'; ParamType1: ptAssociationType),
    (Index: 618; Name: 'HasFamilyRelationshipAny'),
    (Index: 619; Name: 'GetPathingTargetOffset'; ParamType1: ptAxis),
    (Index: 620; Name: 'GetPathingTargetAngleOffset'; ParamType1: ptAxis),
    (Index: 621; Name: 'GetPathingTargetSpeed'),
    (Index: 622; Name: 'GetPathingTargetSpeedAngle'; ParamType1: ptAxis),
    (Index: 623; Name: 'GetMovementSpeed'),
    (Index: 624; Name: 'GetInContainer'; ParamType1: ptReference),
    (Index: 625; Name: 'IsLocationLoaded'; ParamType1: ptLocation),
    (Index: 626; Name: 'IsLocAliasLoaded'; ParamType1: ptAlias),
    (Index: 627; Name: 'IsDualCasting'),
    (Index: 629; Name: 'GetVMQuestVariable'; ParamType1: ptQuest; ParamType2: ptVariableName),
    (Index: 630; Name: 'GetVMScriptVariable'; ParamType1: ptReference; ParamType2: ptVariableName),
    (Index: 631; Name: 'IsEnteringInteractionQuick'),
    (Index: 632; Name: 'IsCasting'),
    (Index: 633; Name: 'GetFlyingState'),
    (Index: 635; Name: 'IsInFavorState'),
    (Index: 636; Name: 'HasTwoHandedWeaponEquipped'),
    (Index: 637; Name: 'IsExitingInstant'),
    (Index: 638; Name: 'IsInFriendStateWithPlayer'),
    (Index: 639; Name: 'GetWithinDistance'; ParamType1: ptReference; ParamType2: ptFloat),
    (Index: 640; Name: 'GetActorValuePercent'; ParamType1: ptActorValue),
    (Index: 641; Name: 'IsUnique'),
    (Index: 642; Name: 'GetLastBumpDirection'),
    (Index: 644; Name: 'IsInFurnitureState'; ParamType1: ptFurnitureAnim),
    (Index: 645; Name: 'GetIsInjured'),
    (Index: 646; Name: 'GetIsCrashLandRequest'),
    (Index: 647; Name: 'GetIsHastyLandRequest'),
    (Index: 650; Name: 'IsLinkedTo'; ParamType1: ptReference; ParamType2: ptKeyword),
    (Index: 651; Name: 'GetKeywordDataForCurrentLocation'; ParamType1: ptKeyword),
    (Index: 652; Name: 'GetInSharedCrimeFaction'; ParamType1: ptReference),
    (Index: 654; Name: 'GetBribeSuccess'),
    (Index: 655; Name: 'GetIntimidateSuccess'),
    (Index: 656; Name: 'GetArrestedState'),
    (Index: 657; Name: 'GetArrestingActor'),
    (Index: 659; Name: 'EPTemperingItemIsEnchanted'),
    (Index: 660; Name: 'EPTemperingItemHasKeyword'; ParamType1: ptKeyword),
    (Index: 664; Name: 'GetReplacedItemType'; ParamType1: ptCastingSource),
    (Index: 672; Name: 'IsAttacking'),
    (Index: 673; Name: 'IsPowerAttacking'),
    (Index: 674; Name: 'IsLastHostileActor'),
    (Index: 675; Name: 'GetGraphVariableInt'; ParamType1: ptVariableName),
    (Index: 676; Name: 'GetCurrentShoutVariation'),
    (Index: 678; Name: 'ShouldAttackKill'; ParamType1: ptActor),
    (Index: 680; Name: 'GetActivatorHeight'),
    (Index: 681; Name: 'EPMagic_IsAdvanceSkill'; ParamType1: ptActorValue),
    (Index: 682; Name: 'WornHasKeyword'; ParamType1: ptKeyword),
    (Index: 683; Name: 'GetPathingCurrentSpeed'),
    (Index: 684; Name: 'GetPathingCurrentSpeedAngle'; ParamType1: ptAxis),
    (Index: 691; Name: 'EPModSkillUsage_AdvanceObjectHasKeyword'; ParamType1: ptKeyword),
    (Index: 692; Name: 'EPModSkillUsage_IsAdvanceAction'; ParamType1: ptPlayerAction),
    (Index: 693; Name: 'EPMagic_SpellHasKeyword'; ParamType1: ptKeyword),
    (Index: 694; Name: 'GetNoBleedoutRecovery'),
    (Index: 696; Name: 'EPMagic_SpellHasSkill'; ParamType1: ptActorValue),
    (Index: 697; Name: 'IsAttackType'; ParamType1: ptKeyword),
    (Index: 698; Name: 'IsAllowedToFly'),
    (Index: 699; Name: 'HasMagicEffectKeyword'; ParamType1: ptKeyword),
    (Index: 700; Name: 'IsCommandedActor'),
    (Index: 701; Name: 'IsStaggered'),
    (Index: 702; Name: 'IsRecoiling'),
    (Index: 703; Name: 'IsExitingInteractionQuick'),
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
    (Index: 720; Name: 'GetTargetHeight'; ParamType1: ptReference),
    (Index: 721; Name: 'IsPoison'),
    (Index: 722; Name: 'WornApparelHasKeywordCount'; ParamType1: ptKeyword),
    (Index: 723; Name: 'GetItemHealthPercent'),
    (Index: 724; Name: 'EffectWasDualCast'),
    (Index: 725; Name: 'GetKnockedStateEnum'),
    (Index: 726; Name: 'DoesNotExist'),
    (Index: 730; Name: 'IsOnFlyingMount'),
    (Index: 731; Name: 'CanFlyHere'),
    (Index: 732; Name: 'IsFlyingMountPatrolQueud'),
    (Index: 733; Name: 'IsFlyingMountFastTravelling'),
    (Index: 734; Name: 'IsOverEncumbered'),
    (Index: 735; Name: 'GetActorWarmth'),

    // Added by SKSE
    (Index: 1024; Name: 'GetSKSEVersion'; ),
    (Index: 1025; Name: 'GetSKSEVersionMinor'; ),
    (Index: 1026; Name: 'GetSKSEVersionBeta'; ),
    (Index: 1027; Name: 'GetSKSERelease'; ),
    (Index: 1028; Name: 'ClearInvalidRegistrations'; )
  );

function wbConditionDescFromIndex(aIndex: Integer): PConditionFunction;
begin
  Result := nil;

  var L := Low(wbConditionFunctions);
  var H := High(wbConditionFunctions);
  while L <= H do begin
    var I := (L + H) shr 1;
    var C := CmpW32(wbConditionFunctions[I].Index, aIndex);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        L := I;
        Result := @wbConditionFunctions[L];
      end;
    end;
  end;
end;

function wbConditionFunctionToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  Result := '';
  var Desc := wbConditionDescFromIndex(aInt);
  case aType of
    ctEditType: Result := 'ComboBox';
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctCheck: begin
      if Assigned(Desc) then
        Result := ''
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctToStr, ctToSummary, ctToEditValue: begin
      if Assigned(Desc) then
        Result := Desc.Name
      else if aType in [ctToSummary, ctToEditValue] then
        Result := aInt.ToString
      else
        Result := '<Unknown: '+aInt.ToString+'>';
    end;
    ctEditInfo: begin
      with TStringList.Create do try
        for var i := Low(wbConditionFunctions) to High(wbConditionFunctions) do
          Add(wbConditionFunctions[i].Name);
        Sort;
        Result := CommaText;
      finally
        Free;
      end;
    end;
  end;
end;

function wbConditionFunctionToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  for var i := Low(wbConditionFunctions) to High(wbConditionFunctions) do
    with wbConditionFunctions[i] do
      if SameText(Name, aString) then Exit(Index);

  Result := StrToInt64(aString);
end;

function wbConditionParam1Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  var Desc := wbConditionDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then begin
    var ParamType := Desc.ParamType1;
    var ParamFlag := Container.ElementByName['Type'].NativeValue;
    if ParamType in [ptReference, ptActor, ptPackage] then begin
      if ParamFlag and $02 > 0 then ParamType := ptAlias else {>>> 'use aliases' is set <<<}
      if ParamFlag and $08 > 0 then ParamType := ptPackdata;  {>>> 'use packdata' is set <<<}
    end;
    Result := Succ(Integer(ParamType));
  end;
end;

function wbConditionParam2Decider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container: IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  var Desc := wbConditionDescFromIndex(Container.ElementByName['Function'].NativeValue);
  if Assigned(Desc) then begin
    var ParamType := Desc.ParamType2;
    var ParamFlag := Container.ElementByName['Type'].NativeValue;
    if ParamType in [ptReference, ptActor, ptPackage] then begin
      if ParamFlag and $02 > 0 then ParamType := ptAlias else {>>> 'use aliases' is set <<<}
      if ParamFlag and $08 > 0 then ParamType := ptPackdata;  {>>> 'use packdata' is set <<<}
    end;
    Result := Succ(Integer(ParamType));
  end;
end;

function wbConditionAliasToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainer;
  MainRecord : IwbMainRecord;
  GroupRecord : IwbGroupRecord;
begin
  case aType of
    ctToSortKey: Result := IntToHex64(aInt, 8);
    ctToStr, ctToSummary, ctToEditValue: Result := aInt.ToString;
  else
    Result := '';
  end;

  if wbResolveAlias then begin
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
    else if MainRecord.Signature = PACK then
      Result := wbAliasToStr(aInt, Container.ElementBySignature['QNAM'], aType)
    else if MainRecord.Signature = INFO then begin
      // get DIAL for INFO
      if Supports(MainRecord.Container, IwbGroupRecord, GroupRecord) then
        if Supports(GroupRecord.ChildrenOf, IwbMainRecord, MainRecord) then begin
          MainRecord := MainRecord.HighestOverrideVisibleForFile[aElement._File];
          Result := wbAliasToStr(aInt, MainRecord.ElementBySignature['QNAM'], aType);
        end;
    end;
  end;
end;

function wbConditionEventToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  slMember: TStringList;
begin
  Result := '';
  var EventFunction := aInt and $FFFF;
  var EventMember := aInt shr 16;
  case aType of
    ctEditType: Result := 'ComboBox';
    ctToSortKey: Result := IntToHex(aInt, 8);
    ctToStr, ctToSummary, ctToEditValue: begin
      Result := wbEventFunctionEnum.ToEditValue(EventFunction, nil);
      Result := Result + ':' + wbEventMemberEnum.ToEditValue(EventMember, nil);
    end;
    ctCheck: begin
      var s1 := wbEventFunctionEnum.Check(EventFunction, nil);
      if s1 <> '' then
        s1 := 'EventFunction' + s1;
      var s2 := wbEventMemberEnum.Check(EventMember, nil);
      if s2 <> '' then
        s2 := 'EventMember' + s2;
      if (s1 <> '') or (s2 <> '') then
        Result := s1 + ':' + s2;
    end;
    ctEditInfo: begin
      slMember := TStringList.Create;
      slMember.AddStrings(wbEventMemberEnum.EditInfo[nil]);
      with TStringList.Create do try
        for var i := 0 to Pred(wbEventFunctionEnum.NameCount) do
          for var j := 0 to Pred(slMember.Count) do
            Add(wbEventFunctionEnum.Names[i] + ':' + slMember[j]);
        Sort;
        Result := CommaText;
      finally
        Free;
      end;
    end;
  end;
end;

function wbConditionEventToInt(const aString: string; const aElement: IwbElement): Int64;
var
  EventFunction: Integer;
  EventMember: Integer;
begin
  var i := Pos(':', aString);
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

function wbConditionQuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
begin
  Result := '';
  case aType of
    ctToSortKey: Exit(IntToHex64(aInt, 8));
    ctToEditValue, ctToSummary: Result := aInt.ToString;
    ctCheck: Result := '<Warning: Could not resolve Parameter 1>';
    ctToStr: Result := aInt.ToString + ' <Warning: Could not resolve Parameter 1>';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  if not wbTryGetMainRecord(Container.ElementByName['Parameter #1'], MainRecord) then
    Exit;

  MainRecord := MainRecord.WinningOverride;
  if MainRecord.Signature <> QUST then
  begin
    case aType of
      ctCheck: Result := '<Warning: "' + MainRecord.ShortName + '" is not a Quest record>';
      ctToStr: Result := aInt.ToString + ' <Warning: "' + MainRecord.ShortName + '" is not a Quest record>';
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
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for var i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
        var j := Stage.ElementNativeValues['INDX\Stage Index'];
        var s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
        var t: string := IntToStr(j);
        while Length(t) < 3 do
          t := '0' + t;
        if s <> '' then
          t := t + ' ' + s;
        if Assigned(EditInfos) then
          EditInfos.AddObject(t, TObject(Integer(j)));
        if j = aInt then begin
          case aType of
            ctToStr, ctToSummary, ctToEditValue: Result := t;
            ctCheck: Result := '';
          end;
          Exit;
        end;
      end;
    end;

    case aType of
      ctCheck: Result := '<Warning: Quest Stage [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
      ctToStr: Result := aInt.ToString + ' <Warning: Quest Stage [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbConditionStringToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
begin
  case aType of
    ctToStr, ctToSummary, ctToSortKey, ctToEditValue, ctToNativeValue: begin
      Result := '';
      if not Assigned(aElement) then
        Exit;

      var Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
      if not Assigned(Container) then
        Exit;

      if aElement = Container.Elements[5] then begin
        case aType of
          ctToEditValue, ctToNativeValue, ctToSummary: Result := Container.ElementEditValues['..\CIS1'];
        else
          Result := Container.ElementValues['..\CIS1'];
        end;
      end;

      if aElement = Container.Elements[6] then begin
        case aType of
          ctToEditValue, ctToNativeValue, ctToSummary: Result := Container.ElementEditValues['..\CIS2'];
        else
          Result := Container.ElementValues['..\CIS2'];
        end;
      end;
    end;
    ctCheck, ctEditType, ctEditInfo, ctLinksTo:
      Result := '';
  else
    Result := aInt.ToString;
  end;
end;

function wbConditionStringToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := 0;

  if not Assigned(aElement) then
    Exit;

  var Container := GetContainerFromUnion(aElement) as IwbContainerElementRef;
  if not Assigned(Container) then
    Exit;

  if aElement = Container.Elements[5] then
    Container.ElementEditValues['..\CIS1'] := aString;

  if aElement = Container.Elements[6] then
    Container.ElementEditValues['..\CIS2'] := aString;
end;

function wbConditionVATSValueParamDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container : IwbContainer;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  Result := Container.ElementByName['Parameter #1'].NativeValue;
end;

function wbGenericModel(aRequired: Boolean = False; aDontShow: TwbDontShowCallback = nil): IwbRecordMemberDef;
begin
  Result :=
    wbRStructSK([0], 'Model', [
      wbString(MODL, 'Model FileName', 0, cpNormal, True),
      wbMODT,
      wbMODS
    ], [], cpNormal, aRequired, aDontShow, True)
    .SetSummaryKey([0])
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfSummaryNoSortKey)
    .IncludeFlag(dfCollapsed, wbCollapseModels);
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

function wbPerkDATAQuestStageToStr(aInt: Int64; const aElement: IwbElement; aType: TwbCallbackType): string;
var
  Container  : IwbContainerElementRef;
  Param1     : IwbElement;
  MainRecord : IwbMainRecord;
  EditInfos  : TStringList;
  Stages     : IwbContainerElementRef;
  Stage      : IwbContainerElementRef;
begin
  case aType of
    ctToEditValue, ctToSummary: Result := aInt.ToString;
    ctToStr: Result := aInt.ToString + ' <Warning: Could not resolve Quest>';
    ctToSortKey: Exit(IntToHex64(aInt, 8));
    ctCheck: Result := '<Warning: Could not resolve Quest>';
    ctEditInfo, ctEditType: Result := '';
  end;

  if not wbTryGetContainerRefFromUnionOrValue(aElement, Container) then
    Exit;

  if not wbTryGetMainRecord(Container.ElementByName['Quest'], MainRecord) then
    Exit;

  MainRecord := MainRecord.WinningOverride;
  if MainRecord.Signature <> QUST then
  begin
    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: "' + MainRecord.ShortName + '" is not a Quest record>';
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
    if Supports(MainRecord.ElementByName['Stages'], IwbContainerElementRef, Stages) then begin
      for var i := 0 to Pred(Stages.ElementCount) do
        if Supports(Stages.Elements[i], IwbContainerElementRef, Stage) then begin
          var j := Stage.ElementNativeValues['INDX\Stage Index'];
          var s := Trim(Stage.ElementValues['Log Entries\Log Entry\CNAM']);
          var t := IntToStr(j);
          while Length(t) < 3 do
            t := '0' + t;
          if s <> '' then
            t := t + ' ' + s;
          if Assigned(EditInfos) then
            EditInfos.AddObject(t, TObject(Integer(j)));
          if j = aInt then begin
            case aType of
              ctToStr, ctToSummary, ctToEditValue: Result := t;
              ctCheck: Result := '';
            end;
            Exit;
          end;
        end;
    end;

    case aType of
      ctToStr: Result := aInt.ToString + ' <Warning: Quest Stage [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
      ctCheck: Result := '<Warning: Quest Stage [' + aInt.ToString + '] not found in "' + MainRecord.Name + '">';
      ctEditInfo: begin
        EditInfos.Sort;
        Result := EditInfos.CommaText;
      end;
    end;
  finally
    FreeAndNil(EditInfos);
  end;
end;

function wbStringToInt(const aString: string; const aElement: IwbElement): Int64;
begin
  Result := StrToIntDef(aString, 0);
end;

function wbStrToAlias(const aString: string; const aElement: IwbElement): Int64;
var
  i    : Integer;
  s    : string;
begin
  Result := -1;

  if aString = 'None' then
    Exit;

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

procedure wbINFOPNAMAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
var
  Container : IwbContainer;
  Group     : IwbGroupRecord;
begin
  if not wbSortINFO then
    Exit;

  if VarSameValue(aOldValue, aNewValue) then
    Exit;

  if not Assigned(aElement) then
    Exit;

  Container := aElement.Container;
  while Assigned(Container) do begin
    if Supports(Container, IwbGroupRecord, Group) then begin
      Group.Sort(True);
      Exit;
    end;
    Container := Container.Container;
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

procedure wbAfterSet(const aElement: IwbElement; const aOldValue, aNewValue: Variant);
begin
  Exit;
end;

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
  Element := Container.ElementByName['Archtype'];

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
    12: Result := 1; // Light
    17: Result := 2; // Bound Item
    18: Result := 3; // Summon Creature
    25: Result := 4; // Guide
    34: Result := 8; // Peak Mod
    35: Result := 5; // Cloak
    36: Result := 6; // Werewolf
    39: Result := 7; // Enhance Weapon
    40: Result := 4; // Spawn Hazard
    46: Result := 6; // Vampire Lord
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

  Element := Container.ElementByName['Archtype'];
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

  Element := Container.ElementByName['Archtype'];
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

function wbPerkDATADecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
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

{>>> For VMAD <<<}
function wbScriptFragmentExistsDecider(aBasePtr: Pointer; aEndPtr: Pointer; const aElement: IwbElement): Integer;
var
  Container  : IwbContainer;
  MainRecord : IwbMainRecord;
begin
  Result := 0;
  if not wbTryGetContainerFromUnion(aElement, Container) then
    Exit;

  while Assigned(Container) and (Container.ElementType <> etMainRecord) do
    Container := Container.Container;

  if not Assigned(Container) then Exit;

  // TODO: should this assume there's a MainRecord?
  Supports(Container, IwbMainRecord, MainRecord);

  if MainRecord.Signature = INFO then
    Result := 1
  else if MainRecord.Signature = PACK then
    Result := 2
  else if MainRecord.Signature = PERK then
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
  if not Assigned(Container) then Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then Exit;

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
  if not Assigned(Container) then Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then Exit;

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
  if not Assigned(Container) then Exit;
  while Assigned(Container) and (Container.Name <> 'Script Fragments') do
    Container := Container.Container;
  if not Assigned(Container) then Exit;

  F := Container.ElementByName['Flags'].NativeValue;
  for i := 0 to 7 do begin
    if (F and 1) = 1 then
      Inc(Result);
    F := F shr 1;
  end;
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
  if i and $00000004 <> 0 then Result := 1;
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

    Container.RemoveElement('XPTL');
  finally
    wbEndInternalEdit;
  end;
end;

procedure wbRACEAfterLoad(const aElement: IwbElement);
begin
  wbReplaceBODTwithBOD2(aElement);
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
      // expand legacy itU8 flags to itU16
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


{>>>
  Updated, but not called for Skyrim
  Why is it required to fix particle counts? Because 1 pass = 79 particles?
>>>}
//procedure wbEFSHAfterLoad(const aElement: IwbElement);
//var
//  Container: IwbContainerElementRef;
//  MainRecord   : IwbMainRecord;
//  FullParticleBirthRatio : Extended;
//  PersistantParticleCount : Extended;
//begin
//  if wbBeginInternalEdit then try
//    if not Supports(aElement, IwbContainerElementRef, Container) then
//      Exit;
//
//    if Container.ElementCount < 1 then
//      Exit;
//
//    if not Supports(aElement, IwbMainRecord, MainRecord) then
//      Exit;
//
//    if MainRecord.IsDeleted then
//      Exit;
//
//    if not Container.ElementExists['DATA'] then
//      Exit;
//
//    FullParticleBirthRatio := Container.ElementNativeValues['DATA\Particle Shader - Full Particle Birth Ratio'];
//    PersistantParticleCount := Container.ElementNativeValues['DATA\Particle Shader - Persistant Particle Count'];
//
//    if ((FullParticleBirthRatio <> 0) and (FullParticleBirthRatio <= 1)) then begin
//      FullParticleBirthRatio := FullParticleBirthRatio * 78.0;
//      Container.ElementNativeValues['DATA\Particle Shader - Full Particle Birth Ratio'] := FullParticleBirthRatio;
//    end;
//
//    if ((PersistantParticleCount <> 0) and (PersistantParticleCount <= 1)) then begin
//      PersistantParticleCount := PersistantParticleCount * 78.0;
//      Container.ElementNativeValues['DATA\Particle Shader - Persistant Particle Count'] := PersistantParticleCount;
//    end;
//
//  finally
//    wbEndInternalEdit;
//  end;
//end;

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
  if wbBeginInternalEdit(True) then try
    if wbCounterAfterSet('IDLC - Animation Count', aElement) then
      Exit;

    if not Supports(aElement.Container, IwbContainer, Container) then
      Exit;

    Element := Container.ElementByPath['IDLC\Animation Count'];
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
  if wbBeginInternalEdit(True) then try
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
     (MainRecord.Signature = TREE) or
     (MainRecord.Signature = FLOR)
  then
    Result := 1
  else if MainRecord.Signature = CONT then
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
     (MainRecord.Signature = SLGM) or
     (MainRecord.Signature = WEAP) or
     (MainRecord.Signature = ALCH)
  then
    Result := 7;
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
  // cache of race specific tint layers
  TintLayers: array of TFaceGenFeature;

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
  Female, Female2   : Boolean;
  RaceID, EntryName : string;
  s                 : string;
  Cache             : PFaceGenFeature;
  Index             : Cardinal;
  i, j              : integer;
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

    for i := 0 to 1 do begin

      Female2 := i = 1;
      SetLength(TintLayers, Succ(Length(TintLayers)));
      Cache := @TintLayers[Pred(Length(TintLayers))];
      Cache.RaceID := RaceID;
      Cache.Female := Female2;

      if not Female2 then
        Element := Race.ElementByPath['Head Data\Male Head Data\Tint Masks']
      else
        Element := Race.ElementByPath['Head Data\Female Head Data\Tint Masks'];

      if not Supports(Element, IwbContainerElementRef, Container) then
        Continue;

      SetLength(Cache.Entries, Container.ElementCount);

      for j := 0 to Pred(Container.ElementCount) do begin
        // should never be false
        if not Supports(Container.Elements[j], IwbContainerElementRef, Entry) then
          Continue;
        Cache.Entries[j].Index := Entry.ElementNativeValues['Tint Layer\Texture\TINI'];
        s := Entry.ElementEditValues['Tint Layer\Texture\TINP'];
        // add texture name
        if s <> '' then
          s := '[' + s + '] ';
        s := s + ChangeFileExt(ExtractFileName(Entry.ElementEditValues['Tint Layer\Texture\TINT']), '');
        Cache.Entries[j].Name := s;
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

  case aType of
    ctToStr, ctToSummary: begin
      if EntryName <> '' then
        Result := aInt.ToString + ' ' + EntryName
      else begin
        Result := aInt.ToString;
        if aType = ctToStr then
          Result := Result + ' <Tint Layer Index [' + aInt.ToString + '] not found in ' + Race.Name + '>';
      end;
    end;
    ctCheck: begin
      if EntryName = '' then
        Result := '<Tint Layer Index [' + aInt.ToString + '] not found in ' + Race.Name + '>'
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
        7, 'Turn Off Fire',
       10, 'Persistent',
       11, 'Initially Disabled',
       28, 'Reflected By Auto Water',
       29, 'Don''t Havok Settle',
       30, 'No Respawn'
      ], True, True)), [
      wbEDID,
      wbVMAD,
      wbFormIDCk(NAME, 'Projectile', [PROJ, HAZD]),
      wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),
      wbOwnership([XRGD]),
      wbFloat(XHTW, 'Head-Tracking Weight'),
      wbFloat(XFVC, 'Favor Cost'),
      wbRArrayS('Reflected/Refracted By',
        wbStructSK(XPWR, [0], 'Water', [
          wbFormIDCk('Reference', [REFR]),
          wbInteger('Type', itU32, wbFlags([
            'Reflection',
            'Refraction'
          ]))
        ], cpNormal, False, nil, 1)
      ),
      wbRArrayS('Linked References', wbStructSK(XLKR, [0], 'Linked Reference', [
        wbFormIDCk('Keyword/Ref', [KYWD, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
        wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA])
      ], cpNormal, False, nil, 1)),
      wbRStruct('Activate Parents', [
        wbInteger(XAPD, 'Flags', itU8, wbFlags([
          'Parent Activate Only'
        ], True)),
        wbRArrayS('Activate Parent Refs',
          wbStructSK(XAPR, [0], 'Activate Parent Ref', [
            wbFormIDCk('Reference', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
            wbFloat('Delay')
          ])
        )
      ]),
      wbXESP,
      wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),
      wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),
      wbEmpty(XIS2, 'Ignored by Sandbox'),
      wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),
      wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),
      wbXLOD,
      wbXSCL,
      wbDataPosRot
    ], True).SetAddInfo(wbPlacedAddInfo);
  end;

procedure DefineTES5;
begin
  DefineCommon;

  wbRecordFlags := wbInteger('Record Flags', itU32, wbFlags(wbFlagsList([])));

  wbMainRecordHeader := wbRecordHeader(wbRecordFlags);

  wbSizeOfMainRecordStruct := 24;

  wbNull := wbUnused(-255);
  wbLLCT := wbInteger(LLCT, 'Count', itU8, nil, cpBenign);
  wbCITC := wbInteger(CITC, 'Condition Count', itU32, nil, cpBenign);
  wbCITCReq := wbInteger( CITC, 'Condition Count', itU32, nil, cpBenign, True);
  wbLVLD := wbInteger(LVLD, 'Chance None', itU8, nil, cpNormal, True);

  wbSPCT := wbInteger(SPCT, 'Count', itU32, nil, cpBenign);
  wbSPLO := wbFormIDCk(SPLO, 'Actor Effect', [SPEL, SHOU, LVSP]);
  wbSPLOs := wbRArrayS('Actor Effects', wbSPLO, cpNormal, False, nil, wbSPLOsAfterSet, nil{wbActorTemplateUseActorEffectList});

  wbCOED := wbStructExSK(COED, [2], [0, 1], 'Extra Data', [
    {00} wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
    {04} wbUnion('Global Variable / Required Rank', wbCOEDOwnerDecider, [
           wbUnused(4),
           wbFormIDCk('Global Variable', [GLOB, NULL]),
           wbInteger('Required Rank', itS32)
         ]),
    {08} wbFloat('Item Condition')
  ]);

  wbCNTO :=
    wbRStructExSK([0], [1], 'Item', [
      wbStructExSK(CNTO, [0], [1], 'Item', [
        wbFormIDCk('Item', [ARMO, AMMO, APPA, MISC, WEAP, BOOK, LVLI, KEYM, ALCH, INGR, LIGH, SLGM, SCRL]),
        wbInteger('Count', itS32).SetDefaultNativeValue(1)
      ]),
      wbCOED
    ]).SetToStr(wbItemToStr).IncludeFlag(dfCollapsed, wbCollapseItems);
  wbCOCT := wbInteger(COCT, 'Count', itU32, nil, cpBenign);
  wbCNTOs := wbRArrayS('Items', wbCNTO, cpNormal, False, nil, wbCNTOsAfterSet);

  wbCNTONoReach :=
    wbRStructExSK([0], [1], 'Item', [
      wbStructExSK(CNTO, [0], [1], 'Item', [
        wbFormIDCkNoReach('Item', [ARMO, AMMO, APPA, MISC, WEAP, BOOK, LVLI, KEYM, ALCH, INGR, LIGH, SLGM, SCRL]),
        wbInteger('Count', itS32).SetDefaultNativeValue(1)
      ]),
      wbCOED
    ]).SetToStr(wbItemToStr).IncludeFlag(dfCollapsed, wbCollapseItems);
  wbCNTOsNoReach := wbRArrayS('Items', wbCNTONoReach, cpNormal, False, nil, wbCNTOsAfterSet);

  wbArmorTypeEnum := wbEnum([
    'Light Armor',
    'Heavy Armor',
    'Clothing'
  ]);

  {>>> When NAME is user defined these will be incorrect <<<}
  wbBipedObjectEnum := wbEnum([
    '30 - Head',
    '31 - Hair',
    '32 - Body',
    '33 - Hands',
    '34 - Forearms',
    '35 - Amulet',
    '36 - Ring',
    '37 - Feet',
    '38 - Calves',
    '39 - Shield',
    '40 - Tail',
    '41 - LongHair',
    '42 - Circlet',
    '43 - Ears',
    '44 - Unnamed',
    '45 - Unnamed',
    '46 - Unnamed',
    '47 - Unnamed',
    '48 - Unnamed',
    '49 - Unnamed',
    '50 - DecapitateHead',
    '51 - Decapitate',
    '52 - Unnamed',
    '53 - Unnamed',
    '54 - Unnamed',
    '55 - Unnamed',
    '56 - Unnamed',
    '57 - Unnamed',
    '58 - Unnamed',
    '59 - Unnamed',
    '60 - Unnamed',
    '61 - FX01'
  ], [
    -1, 'None'
  ]);

  wbBipedObjectFlags := wbFlags([
    {0x00000001} '30 - Head',
    {0x00000002} '31 - Hair',
    {0x00000004} '32 - Body',
    {0x00000008} '33 - Hands',
    {0x00000010} '34 - Forearms',
    {0x00000020} '35 - Amulet',
    {0x00000040} '36 - Ring',
    {0x00000080} '37 - Feet',
    {0x00000100} '38 - Calves',
    {0x00000200} '39 - Shield',
    {0x00000400} '40 - Tail',
    {0x00000800} '41 - LongHair',
    {0x00001000} '42 - Circlet',
    {0x00002000} '43 - Ears',
    {0x00004000} '44 - Unnamed',
    {0x00008000} '45 - Unnamed',
    {0x00010000} '46 - Unnamed',
    {0x00020000} '47 - Unnamed',
    {0x00040000} '48 - Unnamed',
    {0x00080000} '49 - Unnamed',
    {0x00100000} '50 - DecapitateHead',
    {0x00200000} '51 - Decapitate',
    {0x00400000} '52 - Unnamed',
    {0x00800000} '53 - Unnamed',
    {0x01000000} '54 - Unnamed',
    {0x02000000} '55 - Unnamed',
    {0x04000000} '56 - Unnamed',
    {0x08000000} '57 - Unnamed',
    {0x10000000} '58 - Unnamed',
    {0x20000000} '59 - Unnamed',
    {0x40000000} '60 - Unnamed',
    {0x80000000} '61 - FX01'
  ], True);

  wbFirstPersonFlagsU32 := wbInteger('First Person Flags', itU32, wbBipedObjectFlags);

  wbBODT := wbStruct(BODT, 'Body Template', [
    wbFirstPersonFlagsU32,
    wbInteger('General Flags', itU8, wbFlags([
      {0x00000001}'(ARMA)Modulates Voice', {>>> From ARMA <<<}
      {0x00000002}'Unknown 2',
      {0x00000004}'Unknown 3',
      {0x00000008}'Unknown 4',
      {0x00000010}'(ARMO)Non-Playable', {>>> From ARMO <<<}
      {0x00000020}'Unknown 6',
      {0x00000040}'Unknown 7',
      {0x00000080}'Unknown 8'
    ], True)),
    wbUnused(3),
    wbInteger('Armor Type', itU32, wbArmorTypeEnum)
  ], cpNormal, False, nil, 3);

  wbBOD2 := wbStruct(BOD2, 'Biped Body Template', [
    wbFirstPersonFlagsU32,
    wbInteger('Armor Type', itU32, wbArmorTypeEnum)
  ], cpNormal, False)
  .SetSummaryKeyOnValue([1, 0])
  .SetSummaryPrefixSuffixOnValue(0, '(', ')')
  .IncludeFlagOnValue(dfSummaryMembersNoName);

  wbBODTBOD2 :=
    wbRUnion('Biped Body Template', [
      wbStruct(BOD2, 'Biped Body Template', [
        wbFirstPersonFlagsU32,
        wbInteger('General Flags', it0, wbFlags([
          {0x00000001}'(ARMA)Modulates Voice', {>>> From ARMA <<<}
          {0x00000002}'Unknown 2',
          {0x00000004}'Unknown 3',
          {0x00000008}'Unknown 4',
          {0x00000010}'(ARMO)Non-Playable', {>>> From ARMO <<<}
          {0x00000020}'Unknown 6',
          {0x00000040}'Unknown 7',
          {0x00000080}'Unknown 8'
        ], True)),
        wbUnused,
        wbInteger('Armor Type', itU32, wbArmorTypeEnum)
      ], cpNormal, True)
        .SetSummaryKeyOnValue([3, 0])
        .SetSummaryPrefixSuffixOnValue(0, '(', ')')
        .IncludeFlagOnValue(dfSummaryMembersNoName),
      wbStruct(BODT, 'Body Template', [
        wbFirstPersonFlagsU32,
        wbInteger('General Flags', itU8, wbFlags([
          {0x00000001}'(ARMA)Modulates Voice', {>>> From ARMA <<<}
          {0x00000002}'Unknown 2',
          {0x00000004}'Unknown 3',
          {0x00000008}'Unknown 4',
          {0x00000010}'(ARMO)Non-Playable', {>>> From ARMO <<<}
          {0x00000020}'Unknown 6',
          {0x00000040}'Unknown 7',
          {0x00000080}'Unknown 8'
        ], True)),
        wbUnused(3),
        wbInteger('Armor Type', itU32, wbArmorTypeEnum)
      ], cpNormal, True, nil, 3)
        .SetSummaryKeyOnValue([3, 0])
        .SetSummaryPrefixSuffixOnValue(0, '(', ')')
        .IncludeFlagOnValue(dfSummaryMembersNoName)
    ]).SetRequired;

  wbDODT := wbStruct(DODT, 'Decal Data', [
    wbFloat('Min Width'),
    wbFloat('Max Width'),
    wbFloat('Min Height'),
    wbFloat('Max Height'),
    wbFloat('Depth'),
    wbFloat('Shininess'),
    wbStruct('Parallax', [
      wbFloat('Scale'),
      wbInteger('Passes', itU8) {>>> This can't be higher than 30 <<<}
    ]),
    wbInteger('Flags', itU8, wbFlags([
      {0x01}'Parallax',
      {0x02}'Alpha - Blending',
      {0x04}'Alpha - Testing',
      {0x08}'No Subtextures'
    ], True)),
    wbByteArray('Unknown', 2),
    wbByteColors('Color')
  ]);

  wbIgnoreRecords.Add(XXXX);

  wbSoundLevelEnum := wbEnum([
     'Loud',
     'Normal',
     'Silent',
     'Very Loud'
    ]);

  wbEntryPointsEnum := wbEnum([
    { 0} 'Calculate Weapon Damage',
    { 1} 'Calculate My Critical Hit Chance',
    { 2} 'Calculate My Critical Hit Damage',
    { 3} 'Calculate Mine Explode Chance',
    { 4} 'Adjust Limb Damage',
    { 5} 'Adjust Book Skill Points',
    { 6} 'Mod Recovered Health',
    { 7} 'Get Should Attack',
    { 8} 'Mod Buy Prices',
    { 9} 'Add Leveled List On Death',
    {10} 'Get Max Carry Weight',
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
    {22} 'Mod Skill Use',
    {23} 'Mod Telekinesis Distance',
    {24} 'Mod Telekinesis Damage Mult',
    {25} 'Mod Telekinesis Damage',
    {26} 'Mod Bashing Damage',
    {27} 'Mod Power Attack Stamina',
    {28} 'Mod Power Attack Damage',
    {29} 'Mod Spell Magnitude',
    {30} 'Mod Spell Duration',
    {31} 'Mod Secondary Value Weight',
    {32} 'Mod Armor Weight',
    {33} 'Mod Incoming Stagger',
    {34} 'Mod Target Stagger',
    {35} 'Mod Attack Damage',
    {36} 'Mod Incoming Damage',
    {37} 'Mod Target Damage Resistance',
    {38} 'Mod Spell Cost',
    {39} 'Mod Percent Blocked',
    {40} 'Mod Shield Deflect Arrow Chance',
    {41} 'Mod Incoming Spell Magnitude',
    {42} 'Mod Incoming Spell Duration',
    {43} 'Mod Player Intimidation',
    {44} 'Mod Player Reputation',
    {45} 'Mod Favor Points',
    {46} 'Mod Bribe Amount',
    {47} 'Mod Detection Light',
    {48} 'Mod Detection Movement',
    {49} 'Mod Soul Gem Recharge',
    {50} 'Set Sweep Attack',
    {51} 'Apply Combat Hit Spell',
    {52} 'Apply Bashing Spell',
    {53} 'Apply Reanimate Spell',
    {54} 'Set Boolean Graph Variable',
    {55} 'Mod Spell Casting Sound Event',
    {56} 'Mod Pickpocket Chance',
    {57} 'Mod Detection Sneak Skill',
    {58} 'Mod Falling Damage',
    {59} 'Mod Lockpick Sweet Spot',
    {60} 'Mod Sell Prices',
    {61} 'Can Pickpocket Equipped Item',
    {62} 'Mod Lockpick Level Allowed',
    {63} 'Set Lockpick Starting Arc',
    {64} 'Set Progression Picking',
    {65} 'Make Lockpicks Unbreakable',
    {66} 'Mod Alchemy Effectiveness',
    {67} 'Apply Weapon Swing Spell',
    {68} 'Mod Commanded Actor Limit',
    {69} 'Apply Sneaking Spell',
    {70} 'Mod Player Magic Slowdown',
    {71} 'Mod Ward Magicka Absorption Pct',
    {72} 'Mod Initial Ingredient Effects Learned',
    {73} 'Purify Alchemy Ingredients',
    {74} 'Filter Activation',
    {75} 'Can Dual Cast Spell',
    {76} 'Mod Tempering Health',
    {77} 'Mod Enchantment Power',
    {78} 'Mod Soul Pct Captured to Weapon',
    {79} 'Mod Soul Gem Enchanting',
    {80} 'Mod # Applied Enchantments Allowed',
    {81} 'Set Activate Label',
    {82} 'Mod Shout OK',
    {83} 'Mod Poison Dose Count',
    {84} 'Should Apply Placed Item',
    {85} 'Mod Armor Rating',
    {86} 'Mod Lockpicking Crime Chance',
    {87} 'Mod Ingredients Harvested',
    {88} 'Mod Spell Range (Target Loc.)',
    {89} 'Mod Potions Created',
    {90} 'Mod Lockpicking Key Reward Chance',
    {91} 'Allow Mount Actor'
  ]);

  wbLocationEnum := wbEnum([
    {0} 'Near reference',
    {1} 'In cell',
    {2} 'Near package start location',
    {3} 'Near editor location',
    {4} 'Object ID',
    {5} 'Object Type',
    {6} 'Near linked reference',
    {7} 'At package location',
    {8} 'Alias (reference)',
    {9} 'Alias (location)',
   {10} 'Unknown 10',
   {11} 'Unknown 11',
   {12} 'Near self'
  ]);

  wbEquipType := wbFlags([
    {0x00000001}'Hand To Hand Melee',
    {0x00000002}'One Hand Sword',
    {0x00000004}'One Hand Dagger',
    {0x00000008}'One Hand Axe',
    {0x00000010}'One Hand Mace',
    {0x00000020}'Two Hand Sword',
    {0x00000040}'Two Hand Axe',
    {0x00000080}'Bow',
    {0x00000100}'Staff',
    {0x00000200}'Spell',
    {0x00000400}'Shield',
    {0x00000800}'Torch',
    {0x00001000}'Crossbow'
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

  wbFurnitureAnimEnum := wbEnum([
    {0} '',
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
    $314F, 'CreatedObject',
    $314C, '(Old)Location',
    $324C, '(New)Location',
    $314B, 'Keyword',
    $3146, 'Form',
    $3156, 'Value1',
    $3256, 'Value2'
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
    {9} 'Crossbow'
  ]);

  wbEDID := wbStringKC(EDID, 'Editor ID', 0, cpOverride);
  wbFULL := wbLStringKC(FULL, 'Name', 0, cpTranslate);
  wbFULLActor := wbLStringKC(FULL, 'Name', 0, cpTranslate, False, nil{wbActorTemplateUseBaseData});
  wbFULLReq := wbLStringKC(FULL, 'Name', 0, cpTranslate, True);
  wbDESC := wbLStringKC(DESC, 'Description', 0, cpTranslate);
  wbDESCReq := wbLStringKC(DESC, 'Description', 0, cpTranslate, True);
  wbXSCL := wbFloat(XSCL, 'Scale');

  wbPropTypeEnum := wbEnumSummary([
    {00} 'None', '',
    {01} 'Object', '',
    {02} 'String', '',
    {03} 'Int32', '',
    {04} 'Float', '',
    {05} 'Bool', '',
    {06} '', '',
    {07} '', '',
    {08} '', '',
    {09} '', '',
    {10} '', '',
    {11} 'Array of Object', 'Object[]',
    {12} 'Array of String', 'String[]',
    {13} 'Array of Int32', 'Int32[]',
    {14} 'Array of Float', 'Float[]',
    {15} 'Array of Bool', 'Bool[]'
  ]);

  wbScriptFlags := wbInteger('Flags', itU8, wbEnum([
    {0x00} 'Local',
    {0x01} 'Inherited',
    {0x02} 'Removed',
    {0x03} 'Inherited and Removed'
  ]));

  wbScriptPropertyObject := wbUnion('Object Union', wbScriptObjFormatDecider, [
    wbStructSK([2, 1], 'Object v2', [
      wbInteger('Unused', itU16, nil, cpIgnore),
      wbInteger('Alias', itS16, wbScriptObjectAliasToStr, wbStrToAlias).SetDefaultEditValue('None'),
      wbFormID('FormID')
    ], [2, 1, 0])
      .SetSummaryKey([1, 2])
      .SetSummaryMemberPrefixSuffix(2, '', '')
      .SetSummaryMemberPrefixSuffix(1, 'Alias[', '] on')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey),
    wbStructSK([0, 1], 'Object v1', [
      wbFormID('FormID'),
      wbInteger('Alias', itS16, wbScriptObjectAliasToStr, wbStrToAlias).SetDefaultEditValue('None'),
      wbInteger('Unused', itU16, nil, cpIgnore)
    ])
      .SetSummaryKey([1, 0])
      .SetSummaryMemberPrefixSuffix(0, '', '')
      .SetSummaryMemberPrefixSuffix(1, 'Alias[', '] on')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryMembersNoName)
  ]);

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
       {11} wbArray('Array of Object', wbScriptPropertyObject, -1),
       {12} wbArray('Array of String', wbLenString('Element', 2).OverrideEncoding(wbEncodingVMAD), -1),
       {13} wbArray('Array of Int32', wbInteger('Element', itS32), -1),
       {14} wbArray('Array of Float', wbFloat('Element'), -1),
       {15} wbArray('Array of Bool', wbInteger('Element', itU8, wbBoolEnum), -1)
      ])
    ])
    .SetSummaryKey([1, 3])
    .SetSummaryMemberPrefixSuffix(0, '', ':')
    .SetSummaryMemberPrefixSuffix(3, '= ', '')
    .IncludeFlag(dfSummaryMembersNoName)
    .IncludeFlag(dfCollapsed, wbCollapseScriptProperties);

  wbScriptProperties :=
    wbArrayS('Properties', wbScriptProperty, -2, cpNormal, False, nil, nil, nil, wbCanAddScriptProperties)
    .SetSummaryPassthroughMaxLength(80)
    .SetSummaryPassthroughMaxDepth(1);

  wbScriptEntry := wbStructSK([0], 'Script', [
    wbLenString('ScriptName', 2),
    wbScriptFlags,
    wbScriptProperties
  ])
  .SetSummaryKey([2])
  .SetSummaryMemberPrefixSuffix(2, '(', ')')
  .SetSummaryDelimiter('')
  .IncludeFlag(dfSummaryMembersNoName);

  wbScriptFragmentsInfo := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(2),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd'
    ])),
    wbLenString('FileName', 2),
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
      .SetSummaryKey([1, 2])
      .SetSummaryMemberPrefixSuffix(1, '', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    , [], wbScriptFragmentsInfoCounter)
  ])
  .SetSummaryKey([1, 2, 3])
  .IncludeFlag(dfSummaryMembersNoName);

  wbScriptFragmentsPack := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(2),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd',
      {4} 'OnChange'
    ])),
    wbLenString('FileName', 2),
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd, OnChange
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
      .SetSummaryKey([1, 2])
      .SetSummaryMemberPrefixSuffix(1, '', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    , [], wbScriptFragmentsPackCounter)
  ])
  .SetSummaryKey([1, 2, 3])
  .IncludeFlag(dfSummaryMembersNoName);

  wbScriptFragmentsQuest := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(2),
    wbInteger('FragmentCount', itU16, nil, cpBenign),
    wbLenString('FileName', 2),
    wbArrayS('Fragments',
      wbStructSK([0, 2], 'Fragment', [
        wbInteger('Quest Stage', itU16),
        wbInteger('Unknown', itS16),
        wbInteger('Quest Stage Index', itS32),
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
      .SetSummaryKey([4, 5])
      .SetSummaryMemberPrefixSuffix(0, '[', '/')
      .SetSummaryMemberPrefixSuffix(2, '', ']')
      .SetSummaryMemberPrefixSuffix(4, ' ', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    ).SetCountPath('FragmentCount', True)
  ])
  .SetSummaryKey([2, 3])
  .IncludeFlag(dfSummaryMembersNoName);

  wbScriptFragmentsScen := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(2),
    wbInteger('Flags', itU8, wbFlags([
      {1} 'OnBegin',
      {2} 'OnEnd'
    ])),
    wbLenString('FileName', 2),
    wbArray('Fragments',  // Do NOT sort, ordered OnBegin, OnEnd
      wbStruct('Fragment', [
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
      .SetSummaryKey([1, 2])
      .SetSummaryMemberPrefixSuffix(1, '', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    , [], wbScriptFragmentsSceneCounter),
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
      ])
      .SetSummaryKey([5, 6])
      .SetSummaryMemberPrefixSuffix(0, '[', ':')
      .SetSummaryMemberPrefixSuffix(1, '', ']')
      .SetSummaryMemberPrefixSuffix(5, ' ', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    , -2)
  ])
  .SetSummaryKey([1, 2, 3, 4])
  .IncludeFlag(dfSummaryMembersNoName);

  wbScriptFragments := wbStruct('Script Fragments', [
    wbInteger('Extra bind data version', itS8).SetDefaultNativeValue(2),
    wbLenString('FileName', 2),
    wbArrayS('Fragments',
      wbStructSK([0], 'Fragment', [
        wbInteger('Fragment Index', itU16),
        wbInteger('Unknown', itS16),
        wbInteger('Unknown', itS8),
        wbLenString('ScriptName', 2),
        wbLenString('FragmentName', 2)
      ])
      .SetSummaryKey([3, 4])
      .SetSummaryMemberPrefixSuffix(0, '[', ']')
      .SetSummaryMemberPrefixSuffix(3, ' ', ':')
      .SetSummaryDelimiter('')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfCollapsed, wbCollapseFragments)
    , -2)
  ])
  .SetSummaryKey([1, 2])
  .IncludeFlag(dfSummaryMembersNoName);

  {>>> http://www.uesp.net/wiki/Tes5Mod:Mod_File_Format/VMAD_Field <<<}
  var wbVMADScripts :=
    wbArrayS('Scripts', wbScriptEntry, -2, cpNormal, False, nil, nil, nil, wbCanAddScripts)
    .SetSummaryPassthroughMaxLength(100);

  var wbVMADVersion :=
    wbInteger('Version', itS16, nil, cpIgnore).SetDefaultNativeValue(5);
  var wbVMADObjectFormat :=
    wbInteger('Object Format', itS16, nil, cpIgnore).SetDefaultNativeValue(2);

  wbVMAD := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts
  ])
  .SetSummaryKeyOnValue([2]);

  wbVMADFragmentedPERK := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts,
    wbScriptFragments
  ], cpNormal, False, nil, 3)
  .SetSummaryKeyOnValue([2, 3]);

  wbVMADFragmentedPACK := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts,
    wbScriptFragmentsPack
  ], cpNormal, False, nil, 3)
  .SetSummaryKeyOnValue([2, 3]);

  wbVMADFragmentedQUST := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts,
    wbScriptFragmentsQuest,
    wbArrayS('Aliases', wbStructSK([0], 'Alias', [
      wbScriptPropertyObject,
      wbVMADVersion,
      wbVMADObjectFormat,
      wbArrayS('Alias Scripts', wbScriptEntry, -2)
    ]), -2)
  ], cpNormal, False, nil, 3)
  .SetSummaryKeyOnValue([2, 3, 4]);

  wbVMADFragmentedSCEN := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts,
    wbScriptFragmentsScen
  ], cpNormal, False, nil, 3)
  .SetSummaryKeyOnValue([2, 3]);

  wbVMADFragmentedINFO := wbStruct(VMAD, 'Virtual Machine Adapter', [
    wbVMADVersion,
    wbVMADObjectFormat,
    wbVMADScripts,
    wbScriptFragmentsInfo
  ], cpNormal, False, nil, 3)
  .SetSummaryKeyOnValue([2, 3]);

  wbAttackData := wbRStructSK([1], 'Attack', [
    wbStruct(ATKD, 'Attack Data', [
      wbFloat('Damage Mult'),
      wbFloat('Attack Chance'),
      wbFormIDCk('Attack Spell', [SPEL, SHOU, NULL]),
      wbInteger('Attack Flags', itU32, wbFlags([
        {0x00000001} 'Ignore Weapon',
        {0x00000002} 'Bash Attack',
        {0x00000004} 'Power Attack',
        {0x00000008} 'Left Attack',
        {0x00000010} 'Rotating Attack',
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
        {0x80000000} 'Override Data'
      ])),
      wbFloat('Attack Angle'),
      wbFloat('Strike Angle'),
      wbFloat('Stagger'),
      wbFormIDCk('Attack Type', [KYWD, NULL]),
      wbFloat('Knockdown'),
      wbFloat('Recovery Time'),
      wbFloat('Stamina Mult')
    ]),
    wbString(ATKE, 'Attack Event')
  ]);

  wbPLDT := wbStruct(PLDT, 'Location', [
    wbInteger('Type', itS32, wbLocationEnum),
    wbUnion('Location Value', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', [NULL, DOOR, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
      {1} wbFormIDCkNoReach('Cell', [NULL, CELL]),
      {2} wbByteArray('Near Package Start Location', 4, cpIgnore),
      {3} wbByteArray('Near Editor Location', 4, cpIgnore),
      {4} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, SCRL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, LIGH, FACT, FLST, IDLM, SHOU]),
      {5} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {6} wbFormIDCk('Keyword', [NULL, KYWD]),
      {7} wbUnused(4),
      {8} wbInteger('Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {9} wbInteger('Reference', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
     {10} wbByteArray('Unknown', 4, cpIgnore),
     {11} wbByteArray('Unknown', 4, cpIgnore),
     {12} wbByteArray('Unknown', 4, cpIgnore)
    ]),
    wbInteger('Radius', itS32)
  ]);

  wbPLVD := wbStruct(PLVD, 'Location', [
    wbInteger('Type', itS32, wbLocationEnum),
    wbUnion('Location Value', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', [NULL, DOOR, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
      {1} wbFormIDCkNoReach('Cell', [NULL, CELL]),
      {2} wbByteArray('Near Package Start Location', 4, cpIgnore),
      {3} wbByteArray('Near Editor Location', 4, cpIgnore),
      {4} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, SCRL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, INGR, LIGH, FACT, FLST, IDLM, SHOU]),
      {5} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {6} wbFormIDCk('Keyword', [NULL, KYWD]),
      {7} wbUnused(4),
      {8} wbInteger('Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {9} wbInteger('Reference', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
     {10} wbByteArray('Unknown', 4, cpIgnore),
     {11} wbByteArray('Unknown', 4, cpIgnore),
     {12} wbByteArray('Unknown', 4, cpIgnore)
    ]),
    wbInteger('Radius', itS32)
  ]);

  wbTargetData := wbStruct('Target Data', [
    wbInteger('Type', itS32, wbEnum([
      {0} 'Specific Reference',
      {1} 'Object ID',
      {2} 'Object Type',
      {3} 'Linked Reference',
      {4} 'Ref Alias',
      {5} 'Unknown 5',
      {6} 'Self'
    ]), cpNormal, False, nil, nil, 2),
    wbUnion('Target', wbTypeDecider, [
      {0} wbFormIDCkNoReach('Reference', [NULL, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], True),
      {1} wbFormIDCkNoReach('Object ID', [NULL, ACTI, DOOR, STAT, MSTT, FURN, SPEL, SCRL, NPC_, CONT, ARMO, AMMO, MISC, WEAP, BOOK, KEYM, ALCH, INGR, LIGH, FACT, FLST, IDLM, SHOU, SOUN, TXST, PROJ, FLOR, SLGM]),
      {2} wbInteger('Object Type', itU32, wbObjectTypeEnum),
      {3} wbFormID('Reference'),
      {4} wbInteger('Alias', itS32, wbPackageLocationAliasToStr, wbStrToAlias),
      {5} wbByteArray('Unknown', 4, cpIgnore),
      {6} wbByteArray('Unknown', 4, cpIgnore)
    ]),
    wbInteger('Count / Distance', itS32)
  ]);

  wbMO2S := wbArrayS(MO2S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO3S := wbArrayS(MO3S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO4S := wbArrayS(MO4S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMO5S := wbArrayS(MO5S, 'Alternate Textures', wbAlternateTexture, -1);
  wbMODS := wbArrayS(MODS, 'Alternate Textures', wbAlternateTexture, -1);

  wbMODD :=
    wbInteger(MODD, 'FaceGen Model Flags', itU8, wbFlags([
      'Head',
      'Torso',
      'Right Hand',
      'Left Hand'
    ]));

  wbDMDSs := wbArrayS(DMDS, 'Alternate Textures', wbAlternateTexture, -1);

  wbDEST := wbRStruct('Destructible', [
    wbStruct(DEST, 'Header', [
      wbInteger('Health', itS32),
      wbInteger('DEST Count', itU8),
      wbInteger('VATS Targetable', itU8, wbBoolEnum),
      wbByteArray('Unknown', 2)
    ]),
    wbRArray('Stages',
      wbRStruct('Stage', [
        wbStruct(DSTD, 'Destruction Stage Data', [
          wbInteger('Health %', itU8),
          wbInteger('Index', itU8),
          wbInteger('Model Damage Stage', itU8),
          wbInteger('Flags', itU8, wbFlags([
            'Cap Damage',
            'Disable',
            'Destroy',
            'Ignore External Dmg'
          ])),
          wbInteger('Self Damage per Second', itS32),
          wbFormIDCk('Explosion', [EXPL, NULL]),
          wbFormIDCk('Debris', [DEBR, NULL]),
          wbInteger('Debris Count', itS32)
        ], cpNormal, True),
        wbRStructSK([0], 'Model', [
          wbString(DMDL, 'Model FileName'),
          wbDMDT,
          wbDMDSs
        ], [], cpNormal, False, nil),
        wbEmpty(DSTF, 'End Marker', cpNormal, True)
      ], [], cpNormal, False, nil)
    )
  ], [], cpNormal, False, nil);

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
            'Cap Damage',
            'Disable',
            'Destroy'
          ])),
          wbInteger('Self Damage per Second', itS32),
          wbFormIDCk('Explosion', [EXPL, NULL]),
          wbFormIDCk('Debris', [DEBR, NULL]),
          wbInteger('Debris Count', itS32)
        ], cpNormal, True), // End DSTD
        wbRStructSK([0], 'Model', [ // Begin DMDL
          wbString(DMDL, 'Model FileName')
        ]), // End DMDL
        wbDMDT,
        wbDMDSs,
        wbEmpty(DSTF, 'End Marker', cpNormal, True)
      ]) // Begin Stage RStruct
    ) // End Stage Array
  ], [], cpNormal, False, nil{wbActorTemplateUseModelAnimation});

  wbXESP := wbStruct(XESP, 'Enable Parent', [
    wbFormIDCk('Reference', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
    wbInteger('Flags', itU8, wbFlags([
      'Set Enable State to Opposite of Parent',
      'Pop In'
    ])),
    wbUnused(3)
  ]);

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

  wbXLCM := wbInteger(XLCM, 'Level Modifier', itS32, wbEnum([
    'Easy',
    'Medium',
    'Hard',
    'Very Hard'
  ]));

  wbTVDT := wbByteArray(TVDT, 'Occlusion Data', 0, cpNormal);
//  wbTVDT := wbArray(TVDT, 'Occlusion Data', wbInteger('Unknown', itS32)),

  wbRefRecord(ACHR, 'Placed NPC',
    wbFlags(wbFlagsList([
      9, 'Starts Dead',
     10, 'Persistent',
     11, 'Initially Disabled',
     15, 'Visible When Distant',
     25, 'No AI Acquire',
     29, 'Don''t Havok Settle'
    ], True, True)), [
    wbEDID,
    wbVMAD,
    wbFormIDCk(NAME, 'Base', [NPC_], False, cpNormal, True),
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    {--- Ragdoll ---}
    wbRagdoll,

    {--- Patrol Data ---}
    wbRStruct('Patrol Data', [
      wbFloat(XPRD, 'Idle Time', cpNormal, True),
      wbEmpty(XPPA, 'Patrol Script Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      {>>> BEGIN leftover from earlier CK versions <<<}
      wbRStruct('Unused', [
        wbUnknown(SCHR),
        wbUnknown(SCDA),
        wbUnknown(SCTX),
        wbUnknown(QNAM),
        wbUnknown(SCRO)
      ], [], cpIgnore, false, wbNeverShow),
      {>>> END leftover from earlier CK versions <<<}
      wbPDTOs,
      wbFormIDCk(TNAM, 'Topic', [DIAL, NULL], False, cpNormal)
    ]),

    {--- Leveled Actor ----}
    wbXLCM,

    {--- Merchant Container ----}
    wbFormIDCk(XMRC, 'Merchant Container', [REFR], True),

    {--- Extra ---}
    wbInteger(XCNT, 'Count', itS32),
    wbFloat(XRDS, 'Radius'),
    wbFloat(XHLP, 'Health'),

    wbRArrayS('Linked References', wbStructSK(XLKR, [0], 'Linked Reference', [
      wbFormIDCk('Keyword/Ref', [KYWD, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA])
    ], cpNormal, False, nil, 1)),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
          wbFloat('Delay')
        ])
      )
    ]),

    {--- Linked Ref ---}
    wbStruct(XCLP, 'Linked Reference Color', [
      wbByteColors('Link Start Color'),
      wbByteColors('Link End Color')
    ]),
    wbXLOD,
    wbFormIDCk(XLCN, 'Persist Location', [LCTN]),
    wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),
    wbEmpty(XIS2, 'Ignored by Sandbox'),
    wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),
    wbFormIDCk(XHOR, 'Horse', [ACHR]),
    wbFloat(XHTW, 'Head-Tracking Weight'),
    wbFloat(XFVC, 'Favor Cost'),

    {--- Enable Parent ---}
    wbXESP,

    {--- Ownership ---}
    wbOwnership([XRGD]),

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),

    {--- Flags ---}
    wbEmpty(XIBS, 'Ignored By Sandbox'),

    {--- 3D Data ---}
    wbXSCL,
    wbDATAPosRot
  ], True).SetAddInfo(wbPlacedAddInfo);

  wbRecord(ACTI, 'Activator',
    wbFlags(wbFlagsList([
      6, 'Has Tree LOD',
      8, 'Must Update Anims',
      9, 'Hidden From Local Map',
     15, 'Has Distant LOD',
     16, 'Random Anim Start',
     17, 'Dangerous',
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
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbByteColors(PNAM, 'Marker Color').SetRequired,
    wbFormIDCk(SNAM, 'Sound - Looping', [SNDR]),
    wbFormIDCk(VNAM, 'Sound - Activation', [SNDR]),
    wbFormIDCk(WNAM, 'Water Type', [WATR]),
    wbLString(RNAM, 'Activate Text Override', 0, cpTranslate),
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      'No Displacement',
      'Ignored by Sandbox'
    ])).SetRequired,
    wbFormIDCk(KNAM, 'Interaction Keyword', [KYWD])
  ]);

  wbRecord(TACT, 'Talking Activator',
    wbFlags(wbFlagsList([
      9, 'Hidden From Local Map',
     16, 'Random Anim Start',
     17, 'Radio Station'
    ]), [17]), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbUnknown(PNAM, cpIgnore, True),
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR]),
    wbUnknown(FNAM, cpIgnore, True),
    wbFormIDCk(VNAM, 'Voice Type', [VTYP])
  ]);

  wbICON := wbRStruct('Icon', [
    wbString(ICON, 'Large Icon FileName', 0, cpNormal, True),
    wbString(MICO, 'Small Icon FileName')
  ], [], cpNormal, False, nil, True);

  wbICONReq := wbRStruct('Icon', [
    wbString(ICON, 'Large Icon FileName', 0, cpNormal, True),
    wbString(MICO, 'Small Icon FileName')
  ], [], cpNormal, True, nil, True);

  wbICO2 := wbRStruct('Icon 2 (female)', [
    wbString(ICO2, 'Large Icon FileName', 0, cpNormal, True),
    wbString(MIC2, 'Small Icon FileName')
  ], [], cpNormal, False, nil, True);

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
      {20} 'Casting Type Is'
    ]);

  wbActorValueEnum :=
    wbEnum([
    {00} 'Aggression',
    {01} 'Confidence',
    {02} 'Energy',
    {03} 'Morality',
    {04} 'Mood',
    {05} 'Assistance',
    {06} 'One-Handed',
    {07} 'Two-Handed',
    {08} 'Archery',
    {09} 'Block',
    {10} 'Smithing',
    {11} 'Heavy Armor',
    {12} 'Light Armor',
    {13} 'Pickpocket',
    {14} 'Lockpicking',
    {15} 'Sneak',
    {16} 'Alchemy',
    {17} 'Speech',
    {18} 'Alteration',
    {19} 'Conjuration',
    {20} 'Destruction',
    {21} 'Illusion',
    {22} 'Restoration',
    {23} 'Enchanting',
    {24} 'Health',
    {25} 'Magicka',
    {26} 'Stamina',
    {27} 'Heal Rate',
    {28} 'Magicka Rate',
    {29} 'Stamina Rate',
    {30} 'Speed Mult',
    {31} 'Inventory Weight',
    {32} 'Carry Weight',
    {33} 'Critical Chance',
    {34} 'Melee Damage',
    {35} 'Unarmed Damage',
    {36} 'Mass',
    {37} 'Voice Points',
    {38} 'Voice Rate',
    {39} 'Damage Resist',
    {40} 'Poison Resist',
    {41} 'Resist Fire',
    {42} 'Resist Shock',
    {43} 'Resist Frost',
    {44} 'Resist Magic',
    {45} 'Resist Disease',
    {46} 'Unknown 46',
    {47} 'Unknown 47',
    {48} 'Unknown 48',
    {49} 'Unknown 49',
    {50} 'Unknown 50',
    {51} 'Unknown 51',
    {52} 'Unknown 52',
    {53} 'Paralysis',
    {54} 'Invisibility',
    {55} 'Night Eye',
    {56} 'Detect Life Range',
    {57} 'Water Breathing',
    {58} 'Water Walking',
    {59} 'Unknown 59',
    {60} 'Fame',
    {61} 'Infamy',
    {62} 'Jumping Bonus',
    {63} 'Ward Power',
    {64} 'Right Item Charge',
    {65} 'Armor Perks',
    {66} 'Shield Perks',
    {67} 'Ward Deflection',
    {68} 'Variable01',
    {69} 'Variable02',
    {70} 'Variable03',
    {71} 'Variable04',
    {72} 'Variable05',
    {73} 'Variable06',
    {74} 'Variable07',
    {75} 'Variable08',
    {76} 'Variable09',
    {77} 'Variable10',
    {78} 'Bow Speed Bonus',
    {79} 'Favor Active',
    {80} 'Favors Per Day',
    {81} 'Favors Per Day Timer',
    {82} 'Left Item Charge',
    {83} 'Absorb Chance',
    {84} 'Blindness',
    {85} 'Weapon Speed Mult',
    {86} 'Shout Recovery Mult',
    {87} 'Bow Stagger Bonus',
    {88} 'Telekinesis',
    {89} 'Favor Points Bonus',
    {90} 'Last Bribed Intimidated',
    {91} 'Last Flattered',
    {92} 'Movement Noise Mult',
    {93} 'Bypass Vendor Stolen Check',
    {94} 'Bypass Vendor Keyword Check',
    {95} 'Waiting For Player',
    {96} 'One-Handed Modifier',
    {97} 'Two-Handed Modifier',
    {98} 'Marksman Modifier',
    {99} 'Block Modifier',
   {100} 'Smithing Modifier',
   {101} 'Heavy Armor Modifier',
   {102} 'Light Armor Modifier',
   {103} 'Pickpocket Modifier',
   {104} 'Lockpicking Modifier',
   {105} 'Sneaking Modifier',
   {106} 'Alchemy Modifier',
   {107} 'Speechcraft Modifier',
   {108} 'Alteration Modifier',
   {109} 'Conjuration Modifier',
   {110} 'Destruction Modifier',
   {111} 'Illusion Modifier',
   {112} 'Restoration Modifier',
   {113} 'Enchanting Modifier',
   {114} 'One-Handed Skill Advance',
   {115} 'Two-Handed Skill Advance',
   {116} 'Marksman Skill Advance',
   {117} 'Block Skill Advance',
   {118} 'Smithing Skill Advance',
   {119} 'Heavy Armor Skill Advance',
   {120} 'Light Armor Skill Advance',
   {121} 'Pickpocket Skill Advance',
   {122} 'Lockpicking Skill Advance',
   {123} 'Sneaking Skill Advance',
   {124} 'Alchemy Skill Advance',
   {125} 'Speechcraft Skill Advance',
   {126} 'Alteration Skill Advance',
   {127} 'Conjuration Skill Advance',
   {128} 'Destruction Skill Advance',
   {129} 'Illusion Skill Advance',
   {130} 'Restoration Skill Advance',
   {131} 'Enchanting Skill Advance',
   {132} 'Left Weapon Speed Multiply',
   {133} 'Dragon Souls',
   {134} 'Combat Health Regen Multiply',
   {135} 'One-Handed Power Modifier',
   {136} 'Two-Handed Power Modifier',
   {137} 'Marksman Power Modifier',
   {138} 'Block Power Modifier',
   {139} 'Smithing Power Modifier',
   {140} 'Heavy Armor Power Modifier',
   {141} 'Light Armor Power Modifier',
   {142} 'Pickpocket Power Modifier',
   {143} 'Lockpicking Power Modifier',
   {144} 'Sneaking Power Modifier',
   {145} 'Alchemy Power Modifier',
   {146} 'Speechcraft Power Modifier',
   {147} 'Alteration Power Modifier',
   {148} 'Conjuration Power Modifier',
   {149} 'Destruction Power Modifier',
   {150} 'Illusion Power Modifier',
   {151} 'Restoration Power Modifier',
   {152} 'Enchanting Power Modifier',
   {153} 'Dragon Rend',
   {154} 'Attack Damage Mult',
   {155} 'Heal Rate Mult',
   {156} 'Magicka Rate Mult',
   {157} 'Stamina Rate Mult',
   {158} 'Werewolf Perks',
   {159} 'Vampire Perks',
   {160} 'Grab Actor Offset',
   {161} 'Grabbed',
   {162} 'Unknown 162',
   {163} 'Reflect Damage'
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
      'Archery',
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
    {1} 'Touch',
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

  wbActorValue := wbInteger('Actor Value', itS32, wbActorValueEnum);

  wbETYP := wbFormIDCk(ETYP, 'Equipment Type', [EQUP, NULL]);
  wbETYPReq := wbFormIDCk(ETYP, 'Equipment Type', [EQUP, NULL], False, cpNormal, True);

  wbFormTypeEnum := wbEnum([], [
     0, 'Activator',
     1, 'Armor',
     2, 'Book',
     3, 'Container',
     4, 'Door',
     5, 'Ingredient',
     6, 'Light',
     7, 'MiscItem',
     8, 'Static',
     9, 'Grass',
    10, 'Tree',
    12, 'Weapon',
    13, 'Actor',
    14, 'LeveledCharacter',
    15, 'Spell',
    16, 'Enchantment',
    17, 'Potion',
    18, 'LeveledItem',
    19, 'Key',
    20, 'Ammo',
    21, 'Flora',
    22, 'Furniture',
    23, 'Sound Marker',
    24, 'LandTexture',
    25, 'CombatStyle',
    26, 'LoadScreen',
    27, 'LeveledSpell',
    28, 'AnimObject',
    29, 'WaterType',
    30, 'IdleMarker',
    31, 'EffectShader',
    32, 'Projectile',
    33, 'TalkingActivator',
    34, 'Explosion',
    35, 'TextureSet',
    36, 'Debris',
    37, 'MenuIcon',
    38, 'FormList',
    39, 'Perk',
    40, 'BodyPartData',
    41, 'AddOnNode',
    42, 'MovableStatic',
    43, 'CameraShot',
    44, 'ImpactData',
    45, 'ImpactDataSet',
    46, 'Quest',
    47, 'Package',
    48, 'VoiceType',
    49, 'Class',
    50, 'Race',
    51, 'Eyes',
    52, 'HeadPart',
    53, 'Faction',
    54, 'Note',
    55, 'Weather',
    56, 'Climate',
    57, 'ArmorAddon',
    58, 'Global',
    59, 'Imagespace',
    60, 'Imagespace Modifier',
    61, 'Encounter Zone',
    62, 'Message',
    63, 'Constructible Object',
    64, 'Acoustic Space',
    65, 'Ragdoll',
    66, 'Script',
    67, 'Magic Effect',
    68, 'Music Type',
    69, 'Static Collection',
    70, 'Keyword',
    71, 'Location',
    72, 'Location Ref Type',
    73, 'Footstep',
    74, 'Footstep Set',
    75, 'Material Type',
    76, 'Actor Action',
    77, 'Music Track',
    78, 'Word of Power',
    79, 'Shout',
    80, 'Relationship',
    81, 'Equip Slot',
    82, 'Association Type',
    83, 'Outfit',
    84, 'Art Object',
    85, 'Material Object',
    87, 'Lighting Template',
    88, 'Shader Particle Geometry',
    89, 'Visual Effect',
    90, 'Apparatus',
    91, 'Movement Type',
    92, 'Hazard',
    93, 'SM Event Node',
    94, 'Sound Descriptor',
    95, 'Dual Cast Data',
    96, 'Sound Category',
    97, 'Soul Gem',
    98, 'Sound Output Model',
    99, 'Collision Layer',
   100, 'Scroll',
   101, 'ColorForm',
   102, 'Reverb Parameters'
  ]);

  wbMiscStatEnum := wbEnum([], [
    Int64($FCDD5011), 'Animals Killed',
    Int64($366D84CF), 'Armor Improved',
    Int64($023497E6), 'Armor Made',
    Int64($8E20D7C9), 'Assaults',
    Int64($579FFA75), 'Automations Killed',
    Int64($B9B50725), 'Backstabs',
    Int64($ED6A0EF2), 'Barters',
    Int64($CCB952CE), 'Books Read',
    Int64($317E8B4C), 'Brawls Won',
    Int64($1D79006B), 'Bribes',
    Int64($3602DE8F), 'Bunnies Slaughtered',
    Int64($53D9E9B5), 'Chests Looted',
    Int64($683C1980), 'Civil War Quests Completed',
    Int64($66CCC50A), 'College of Winterhold Quests Completed',
    Int64($40B11EFE), 'Creatures Killed',
    Int64($22D5BA38), 'Critical Strikes',
    Int64($A930980F), 'Daedra Killed',
    Int64($3558374B), 'Daedric Quests Completed',
    Int64($37A76425), 'Dawnguard Quests Completed',
    Int64($2BDAC36F), 'Days as a Vampire',
    Int64($6E684590), 'Days as a Werewolf',
    Int64($B6F118DB), 'Days Jailed',
    Int64($3C626A90), 'Days Passed',
    Int64($8556AD88), 'Diseases Contracted',
    Int64($46D6FBBC), 'Dragon Souls Collected',
    Int64($AA444695), 'Dungeons Cleared',
    Int64($1A37F336), 'Eastmarch Bounty',
    Int64($5AC3A8ED), 'Falkreath Bounty',
    Int64($87B12ECC), 'Favorite School',
    Int64($518BBC4E), 'Favorite Shout',
    Int64($41DD77A6), 'Favorite Spell',
    Int64($171C5391), 'Favorite Weapon',
    Int64($4F041AA2), 'Fines Paid',
    Int64($9311B22B), 'Food Eaten',
    Int64($57C089F7), 'Gold Found',
    Int64($D20EDA4F), 'Haafingar Bounty',
    Int64($516C486D), 'Hjaalmarch Bounty',
    Int64($B0A1E32E), 'Horses Owned',
    Int64($EBAE35E8), 'Horses Stolen',
    Int64($FA024018), 'Hours Slept',
    Int64($CAD2ECA1), 'Hours Waiting',
    Int64($527DF857), 'Houses Owned',
    Int64($47B4A015), 'Ingredients Eaten',
    Int64($CE842356), 'Ingredients Harvested',
    Int64($7D2E57C0), 'Intimidations',
    Int64($C21702B5), 'Items Pickpocketed',
    Int64($82F190C2), 'Items Stolen',
    Int64($6627464B), 'Jail Escapes',
    Int64($3520E710), 'Largest Bounty',
    Int64($8A24FDE2), 'Locations Discovered',
    Int64($5829CC2E), 'Locks Picked',
    Int64($88089979), 'Magic Items Made',
    Int64($7EA26C2D), 'Main Quests Completed',
    Int64($7187A208), 'Mauls',
    Int64($98EE55DC), 'Misc Objectives Completed',
    Int64($FA06230B), 'Most Gold Carried',
    Int64($D37C6909), 'Murders',
    Int64($22C2CBD0), 'Necks Bitten',
    Int64($BEEBCC87), 'Nirnroots Found',
    Int64($56CCFC54), 'NumVampirePerks',
    Int64($76A1A5C0), 'NumWerewolfPerks',
    Int64($F22A8133), 'People Killed',
    Int64($47A78467), 'Persuasions',
    Int64($F2BAC234), 'Pockets Picked',
    Int64($17C64668), 'Poisons Mixed',
    Int64($7D8F2EA6), 'Poisons Used',
    Int64($4228DE85), 'Potions Mixed',
    Int64($9631EC11), 'Potions Used',
    Int64($DE6C73FE), 'Questlines Completed',
    Int64($0D7B8B16), 'Quests Completed',
    Int64($BB39399E), 'Shouts Learned',
    Int64($731B5333), 'Shouts Mastered',
    Int64($F921D8BA), 'Shouts Unlocked',
    Int64($B1AE4792), 'Side Quests Completed',
    Int64($ACE470D7), 'Skill Books Read',
    Int64($F33130CE), 'Skill Increases',
    Int64($B556CC52), 'Sneak Attacks',
    Int64($A74CBE83), 'Soul Gems Used',
    Int64($C2C9E233), 'Souls Trapped',
    Int64($5EC89F1A), 'Spells Learned',
    Int64($B251A346), 'Standing Stones Found',
    Int64($05D45702), 'Stores Invested In',
    Int64($D0FE7031), 'The Companions Quests Completed',
    Int64($52BA68CB), 'The Dark Brotherhood Quests Completed',
    Int64($3E267D77), 'The Pale Bounty',
    Int64($69B48177), 'The Reach Bounty',
    Int64($50A23F69), 'The Rift Bounty',
    Int64($62B2E95D), 'Thieves'' Guild Quests Completed',
    Int64($944CEA93), 'Times Jailed',
    Int64($50AAB633), 'Times Shouted',
    Int64($99BB86D8), 'Total Lifetime Bounty',
    Int64($4C252391), 'Training Sessions',
    Int64($7AEA9C2B), 'Trespasses',
    Int64($A67626F4), 'Tribal Orcs Bounty',
    Int64($41D4BC0F), 'Undead Killed',
    Int64($F39260A1), 'Vampirism Cures',
    Int64($61A5C5A9), 'Weapons Disarmed',
    Int64($1D3BA844), 'Weapons Improved',
    Int64($25F1EA25), 'Weapons Made',
    Int64($38A2DD66), 'Werewolf Transformations',
    Int64($4231FA4F), 'Whiterun Bounty',
    Int64($92565767), 'Wings Plucked',
    Int64($C7FC518D), 'Winterhold Bounty',
    Int64($949FA7BC), 'Words of Power Learned',
    Int64($2C6E3FC0), 'Words of Power Unlocked'
  ]);

  wbPlayerActionEnum := wbEnum([
    'Normal Usage',
    'Power Attack',
    'Bash',
    'Lockpick Success',
    'Lockpick Broken'
  ]);

  wbEFID := wbFormIDCk(EFID, 'Base Effect', [MGEF]);

  wbEFIT :=
    wbStructSK(EFIT, [0,1,2], '', [
      wbFloat('Magnitude', cpNormal, True),
      wbInteger('Area', itU32),
      wbInteger('Duration', itU32)
    ], cpNormal, True, nil, -1, wbEFITAfterLoad);

  var wbConditionVATSValueParameters : array of IwbValueDef := [
    {0}  wbFormIDCkNoReach('Weapon', [WEAP]),
    {1}  wbFormIDCkNoReach('Weapon List', [FLST], [WEAP]),
    {2}  wbFormIDCkNoReach('Target', [NPC_]),
    {3}  wbFormIDCkNoReach('Target List', [FLST], [NPC_]),
    {4}  wbByteArray('Unknown', 4, cpIgnore),
    {5}  wbInteger('Target Part', itS32, wbActorValueEnum),
    {6}  wbInteger('VATS Action', itU32,
           wbEnum([
             {0}  'Unarmed Attack',
             {1}  'One Hand Melee Attack',
             {2}  'Two Hand Melee Attack',
             {3}  'Magic Attack',
             {4}  'Ranged Attack',
             {5}  'Reload',
             {6}  'Crouch',
             {7}  'Stand',
             {8}  'Switch Weapon',
             {9}  'Toggle Weapon Drawn',
             {10} 'Heal',
             {11} 'Player Death'
           ])),
    {7}  wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {8}  wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {9}  wbFormIDCkNoReach('Critical Effect', [SPEL]),
    {10} wbFormIDCkNoReach('Critical Effect List', [FLST], [SPEL]),
    {11} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {12} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {13} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {14} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {15} wbInteger('Weapon Type', itU32, wbWeaponAnimTypeEnum),
    {16} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {17} wbByteArray('Unknown', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {18} wbInteger('Projectile Type', itU32,
           wbEnum([
             {0} 'Missile',
             {1} 'Lobber',
             {2} 'Beam',
             {3} 'Flame',
             {4} 'Cone',
             {5} 'Barrier',
             {6} 'Arrow'
           ])),
    {19} wbInteger('Delivery Type', itU32, wbTargetEnum),
    {20} wbInteger('Casting Type', itU32, wbCastEnum)
  ];

  var wbConditionBaseObjects : TwbSignatures := [
    ACTI, ALCH, AMMO, ARMA, ARMO, ASPC, BOOK, CONT, DOOR, ENCH,
    FLOR, FURN, GRAS, HAZD, IDLM, KEYM, LIGH, LVLI, LVSP, MISC,
    MSTT, NPC_, PROJ, SCRL, SHOU, SLGM, SOUN, SPEL, STAT, TACT,
    TREE, WEAP];

  var wbFurnitureEntryEnum : IwbEnumDef :=
    wbEnum([], [
      $010000, 'Front',
      $020000, 'Behind',
      $040000, 'Right',
      $080000, 'Left',
      $100000, 'Up']);

  var wbConditionParameters := [
    //Misc
    {0} wbByteArray('Unknown', 4),
    {1} wbByteArray('None', 4, cpIgnore).IncludeFlag(dfZeroSortKey),
    {2} wbFloat('Float'),
    {3} wbInteger('Integer', itS32),
    {4} wbInteger('Alias', itS32, wbConditionAliasToStr, wbStrToAlias),
    {5} wbInteger('Event', itU32, wbConditionEventToStr, wbConditionEventToInt),
    {6} wbInteger('Packdata ID', itU32),
    {7} wbInteger('Quest Stage', itS32, wbConditionQuestStageToStr, wbQuestStageToInt),
    {8} wbInteger('Variable Name', itU32, wbConditionStringToStr, wbConditionStringToInt),
    {9} wbUnion('VATS Value Param', wbConditionVATSValueParamDecider, wbConditionVATSValueParameters),

    //Enums
    {10} wbInteger('Actor Value', itS32, wbActorValueEnum),
    {11} wbInteger('Alignment', itU32, wbAlignmentEnum),
    {12} wbInteger('Axis', itU32, wbAxisEnum),
    {13} wbInteger('Casting Source', itU32, wbCastingSourceEnum),
    {14} wbInteger('Crime Type', itU32, wbCrimeTypeEnum),
    {15} wbInteger('Critical Stage', itU32, wbCriticalStageEnum),
    {16} wbInteger('Form Type', itU32, wbFormTypeEnum),
    {17} wbInteger('Furniture Anim', itU32, wbFurnitureAnimEnum),
    {18} wbInteger('Furniture Entry', itU32, wbFurnitureEntryEnum),
    {19} wbInteger('Misc Stat', itU32, wbMiscStatEnum),
    {20} wbInteger('Player Action', itU32, wbPlayerActionEnum),
    {21} wbInteger('Sex', itU32, wbSexEnum),
    {22} wbInteger('VATS Value Function', itU32, wbVATSValueFunctionEnum),
    {23} wbInteger('Ward State', itU32, wbWardStateEnum),

    //FormIDs
    {24} wbFormIDCkNoReach('Actor', [ACHR, PLYR, REFR, NULL]),
    {25} wbFormIDCkNoReach('Actor Base', [NPC_]),
    {26} wbFormIDCkNoReach('Association Type', [ASTP]),
    {27} wbFormIDCkNoReach('Base Object', wbConditionBaseObjects + [FLST, NULL], wbConditionBaseObjects),
    {28} wbFormIDCkNoReach('Cell', [CELL]),
    {29} wbFormIDCkNoReach('Class', [CLAS]),
    {30} wbFormIDCkNoReach('Effect Item', [ALCH, ENCH, INGR, SCRL, SPEL]),
    {31} wbFormIDCkNoReach('Encounter Zone', [ECZN]),
    {32} wbFormIDCkNoReach('Equip Type', [EQUP]),
    {33} wbFormID('Event Data'),
    {34} wbFormIDCkNoReach('Faction', [FACT]),
    {35} wbFormIDCkNoReach('Faction', [FACT, NULL]),
    {36} wbFormIDCkNoReach('Form List', [FLST]),
    {37} wbFormIDCkNoReach('Furniture', [FLST, FURN]),
    {38} wbFormIDCkNoReach('Global', [GLOB]),
    {39} wbFormIDCkNoReach('Idle', [IDLE]),
    {40} wbFormIDCkNoReach('Inventory Object', [ALCH, AMMO, ARMO, BOOK, COBJ, FLST, INGR, KEYM, LIGH, LVLI, MISC, SCRL, SLGM, WEAP]),
    {41} wbFormIDCkNoReach('Keyword', [KYWD, NULL]),
    {42} wbFormIDCkNoReach('Knowable', [ENCH, MGEF, WOOP]),
    {43} wbFormIDCkNoReach('Location', [LCTN]),
    {44} wbFormIDCkNoReach('Location Ref Type', [LCRT]),
    {45} wbFormIDCkNoReach('Magic Effect', [MGEF]),
    {46} wbFormIDCkNoReach('Owner', [FACT, NPC_, NULL]),
    {47} wbFormIDCkNoReach('Package', [PACK]),
    {48} wbFormIDCkNoReach('Perk', [PERK]),
    {49} wbFormIDCkNoReach('Quest', [QUST]),
    {50} wbFormIDCkNoReach('Race', [RACE]),
    {51} wbFormIDCkNoReach('Reference', [ACHR, PARW, PBAR, PBEA, PCON, PFLA, PGRE, PHZD, PLYR, PMIS, REFR, NULL]),
    {52} wbFormIDCkNoReach('Region', [REGN]),
    {53} wbFormIDCkNoReach('Scene', [SCEN, NULL]),
    {54} wbFormIDCkNoReach('Shout', [SHOU]),
    {55} wbFormIDCkNoReach('Voice Type', [FLST, VTYP]),
    {56} wbFormIDCkNoReach('Weather', [WTHR]),
    {57} wbFormIDCkNoReach('Worldspace', [FLST, WRLD])
  ];

  wbConditions :=
    wbRArray('Conditions',
      wbRStruct('Condition', [
      {0} wbStruct(CTDA, '', [
          {0} wbInteger('Type', itU8, wbConditionTypeToStr, wbConditionTypeToInt).SetAfterSet(wbConditionTypeAfterSet),
          {1} wbUnused(3),
          {2} wbUnion('Comparison Value', wbConditionCompValueDecider, [
              {0} wbFloat('Comparison Value - Float'),
              {1} wbFormIDCk('Comparison Value - Global', [GLOB])
              ]),
          {3} wbInteger('Function', itU16, wbConditionFunctionToStr, wbConditionFunctionToInt),
          {4} wbUnused(2),
          {5} wbUnion('Parameter #1', wbConditionParam1Decider, wbConditionParameters),
          {6} wbUnion('Parameter #2', wbConditionParam2Decider, wbConditionParameters),
          {7} wbInteger('Run On', itU32,
                wbEnum([
                {0} 'Subject',
                {1} 'Target',
                {2} 'Reference',
                {3} 'Combat Target',
                {4} 'Linked Reference',
                {5} 'Quest Alias',
                {6} 'Package Data',
                {7} 'Event Data'
                ])).SetAfterSet(wbConditionRunOnAfterSet),
          {8} wbUnion('Reference', wbConditionReferenceDecider, [
              {0} wbInteger('Unused', itU32, nil, cpIgnore),
              {1} wbFormIDCkNoReach('Reference', [NULL, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False)
              ]),
          {9} wbInteger('Parameter #3', itS32).SetDefaultNativeValue(-1)
          ]),
      {1} wbString(CIS1, 'Parameter #1'),
      {2} wbString(CIS2, 'Parameter #2')
      ]).SetToStr(wbConditionToStr)
        .IncludeFlag(dfCollapsed, wbCollapseConditions)
    ).SetCountPath(CITC)
     .IncludeFlag(dfNotAlignable);

  wbYNAM := wbFormIDCk(YNAM, 'Sound - Pick Up', [SNDR]);
  wbZNAM := wbFormIDCk(ZNAM, 'Sound - Put Down', [SNDR]);

  var wbEffect :=
    wbRStruct('Effect', [
      wbEFID,
      wbEFIT,
      wbConditions
    ], [], cpNormal, True)
    .SetSummaryKey([0,2])
    .IncludeFlag(dfSummaryMembersNoName);

  wbEffectsReq :=
    wbRArray('Effects', wbEffect, cpNormal, True);

  wbRecord(ALCH, 'Ingestible',
    wbFlags(wbFlagsList([
      29, 'Medicine'
    ])), [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbKeywords,
    wbDESC,
    wbGenericModel,
    wbDEST,
    wbICON,
    wbYNAM,
    wbZNAM,
    wbETYP,
    wbFloat(DATA, 'Weight', cpNormal, True),
    wbStruct(ENIT, 'Effect Data', [
      wbInteger('Value', itS32),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'No Auto-Calc',
        {0x00000002} 'Food Item',
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
        {0x00010000} 'Medicine',
        {0x00020000} 'Poison'
      ])),
      wbFormID('Addiction'),
      wbFloat('Addiction Chance'),
      wbFormIDCk('Sound - Consume', [SNDR, NULL])
    ], cpNormal, True),
    wbEffectsReq
  ]);

  wbRecord(AMMO, 'Ammunition',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbDESC,
    wbKeywords,
    IsSSE(
      wbStruct(DATA, 'Data', [
        wbFormIDCk('Projectile', [PROJ, NULL]),
        wbInteger('Flags', itU32, wbFlags([
          'Ignores Normal Weapon Resistance',
          'Non-Playable',
          'Non-Bolt'
        ])),
        wbFloat('Damage'),
        wbInteger('Value', itU32),
        wbFloat('Weight')
      ], cpNormal, True, nil, 4),
      wbStruct(DATA, 'Data', [
        wbFormIDCk('Projectile', [PROJ, NULL]),
        wbInteger('Flags', itU32, wbFlags([
          'Ignores Normal Weapon Resistance',
          'Non-Playable',
          'Non-Bolt'
        ])),
        wbFloat('Damage'),
        wbInteger('Value', itU32)
      ], cpNormal, True)
    ),
    wbString(ONAM, 'Short Name')
  ]);

  wbRecord(ANIO, 'Animated Object',
    wbFlags(wbFlagsList([
      9, 'Unknown 9' // always present in updated records, not in Skyrim.esm
    ]), [9]), [
    wbEDID,
    wbGenericModel,
    wbString(BNAM, 'Unload Event')
  ]).SetSummaryKey([1]);

  wbRecord(ARMO, 'Armor',
    wbFlags(wbFlagsList([
      2, 'Non-Playable',
      6, 'Shield',
     10, 'Unknown 10',
     15, 'Visible When Distant'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbEnchantment,
    wbTexturedModel('Male World Model', [MOD2, MO2T], [wbMO2S]),
    wbICON,
    wbTexturedModel('Female World Model', [MOD4, MO4T], [wbMO4S]),
    wbICO2,
    wbBODTBOD2,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbString(BMCT, 'Ragdoll Constraint Template'),
    wbETYP,
    wbFormIDCk(BIDS, 'Bash Impact Data Set', [IPDS]),
    wbFormIDCk(BAMT, 'Alternate Block Material', [MATT]),
    wbFormIDCk(RNAM, 'Race', [RACE]),
    wbKeywords,
    wbDESC.SetRequired,
    wbRArray('Armature', wbFormIDCK(MODL, 'Model Filename', [ARMA, NULL])),
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbInteger(DNAM, 'Armor Rating', itS32, wbDiv(100), cpNormal, True),
    wbFormIDCk(TNAM, 'Template Armor', [ARMO])
  ], False, nil, cpNormal, False, wbARMOAfterLoad);

  wbRecord(ARMA, 'Armor Addon', [
    wbEDID,
    wbBODTBOD2,
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
    wbTexturedModel('Male Biped Model', [MOD2, MO2T], [wbMO2S]),
    wbTexturedModel('Female Biped Model', [MOD3, MO3T], [wbMO3S]),
    wbTexturedModel('Male 1st Person', [MOD4, MO4T], [wbMO4S]),
    wbTexturedModel('Female 1st Person', [MOD5, MO5T], [wbMO5S]),
    wbFormIDCK(NAM0, 'Male Skin Texture', [TXST, NULL]),
    wbFormIDCK(NAM1, 'Female Skin texture', [TXST, NULL]),
    wbFormIDCK(NAM2, 'Male Skin Texture Swap List', [FLST, NULL]),
    wbFormIDCK(NAM3, 'Female Skin Texture Swap List', [FLST, NULL]),
    wbRArrayS('Additional Races', wbFormIDCK(MODL, 'Race', [RACE, NULL])),
    wbFormIDCk(SNDD, 'Footstep Sound', [FSTS, NULL]),
    wbFormIDCk(ONAM, 'Art Object', [ARTO])
  ], False, nil, cpNormal, False, wbARMAAfterLoad).SetSummaryKey([4]);

  wbRecord(BOOK, 'Book', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbLStringKC(DESC, 'Book Text', 0, cpTranslate, True),
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU8, wbFlags([
       {0x01} 'Teaches Skill',
       {0x02} 'Can''t be Taken',
       {0x04} 'Teaches Spell',
       {0x08} 'Unknown 4',
       {0x10} 'Unknown 5',
       {0x20} 'Unknown 6',
       {0x40} 'Unknown 7',
       {0x80} 'Unknown 8'
      ])),
      wbInteger('Type', itU8, wbEnum([], [
        0, 'Book/Tome', 255, 'Note/Scroll'
      ])),
      wbUnused(2),
      wbUnion('Teaches', wbBOOKTeachesDecider, [
        wbInteger('Skill', itS32, wbSkillEnum),
        wbFormIDCk('Spell', [SPEL])
      ]),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbFormIDCk(INAM, 'Inventory Art', [STAT]),
    wbLString(CNAM, 'Description', 0, cpTranslate)
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

  wbRecord(CELL, 'Cell',
    wbFlags(wbFlagsList([
      10, 'Persistent',
      14, 'Partial Form',
      17, 'Off Limits',
      18, 'Compressed',
      19, 'Can''t Wait'
    ]), [14, 18])
      .SetFlagHasDontShow(14, wbFlagPartialFormDontShow),
  [
    wbEDID,
    wbFULL,
    {>>>
    Flags can be itU8, but CELL\DATA has a critical role in various wbImplementation.pas routines
    and replacing it with wbUnion generates error when setting for example persistent flag in REFR.
    So let it always be an integer
    <<<}
    wbInteger(DATA, 'Flags', itU16, wbFlags([
      {0x0001} 'Is Interior Cell',
      {0x0002} 'Has Water',
      {0x0004} 'Can Travel From Here',
      {0x0008} 'No LOD Water',
      {0x0010} 'Unknown 5',
      {0x0020} 'Public Area',
      {0x0040} 'Hand Changed',
      {0x0080} 'Show Sky',
      {0x0100} 'Use Sky Lighting'
    ]), cpNormal, True, False, nil, wbCELLDATAAfterSet),
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
        {0x00000001}'Ambient Color',
        {0x00000002}'Directional Color',
        {0x00000004}'Fog Color',
        {0x00000008}'Fog Near',
        {0x00000010}'Fog Far',
        {0x00000020}'Directional Rotation',
        {0x00000040}'Directional Fade',
        {0x00000080}'Clip Distance',
        {0x00000100}'Fog Power',
        {0x00000200}'Fog Max',
        {0x00000400}'Light Fade Distances'
      ]))
    ], cpNormal, False, nil, 11)
      .SetDontShow(wbCellExteriorDontShow)
      .SetIsRemovable(wbCellLightingIsRemovable),

    wbTVDT,
    wbMHDTCELL
    .IncludeFlag(dfCollapsed),
    wbFormIDCk(LTMP, 'Lighting Template', [LGTM, NULL], False, cpNormal, True),
    wbByteArray(LNAM, 'Unknown', 0, cpIgnore), // leftover flags, they are now in XCLC

    {>>> XCLW sometimes has $FF7FFFFF and causes invalid floation point <<<}
    wbFloat(XCLW, 'Water Height', cpNormal, False, 1, -1, nil, nil, 0, wbCELLXCLWGetConflictPriority),
    //wbByteArray(XCLW, 'Water Height', 4),
    wbString(XNAM, 'Water Noise Texture'),
    wbArrayS(XCLR, 'Regions', wbFormIDCk('Region', [REGN])),
    wbFormIDCk(XLCN, 'Location', [LCTN]),
    wbInteger(XWCN, 'Water Current Count', itU32, nil, cpBenign),
    wbInteger(XWCS, 'Water Current Count (Old)', itU32, nil, cpBenign),
    wbArray(XWCU, 'Water Currents',
      wbStruct('Water Velocities', [
        wbVec3('Unknown Velocity'),
        wbByteArray('Unknown', 4)
      ]))
    .IncludeFlag(dfCollapsed)
    .IncludeFlag(dfNotAlignable),
    wbFormIDCk(XCWT, 'Water', [WATR]),
    wbOwnership([XRGD]),
    wbFormIDCk(XILL, 'Lock List', [FLST, NPC_]),
    wbString(XWEM, 'Water Environment Map'),
    wbFormIDCk(XCCM, 'Sky/Weather from Region', [REGN]),
    wbFormIDCk(XCAS, 'Acoustic Space', [ASPC]),
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),
    wbFormIDCk(XCMO, 'Music Type', [MUSC]),
    wbFormIDCk(XCIM, 'Image Space', [IMGS])
  ], True)
    .SetAddInfo(wbCellAddInfo)
    .SetAfterLoad(wbCELLAfterLoad);


  wbRecord(CLAS, 'Class', [
    wbEDID,
    wbFULLReq,
    wbDESCReq,
    wbICON,
    wbStruct(DATA, '', [
      wbByteArray('Unknown', 4),
      wbInteger('Teaches', itS8, wbEnum([
        'One Handed',
        'Two Handed',
        'Archery',
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
      ])),
      wbInteger('Maximum training level', itU8),
      wbArray('Skill Weights', wbInteger('Weight', itU8), [
        'One Handed',
        'Two Handed',
        'Archery',
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
      ]),
      wbFloat('Bleedout Default'),
      wbInteger('Voice Points', itU32),
      wbArray('Attribute Weights', wbInteger('Weight', itU8), [
        'Health',
        'Magicka',
        'Stamina',
        'Unknown'
      ])
    ], cpNormal, True)
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
      wbFloat('Rotation Velocity'),
      wbFloat('Particle Size X'),
      wbFloat('Particle Size Y'),
      wbFloat('Center Offset Min'),
      wbFloat('Center Offset Max'),
      wbFloat('Initial Rotation Range'),
      wbInteger('# of Subtextures X', itU32),
      wbInteger('# of Subtextures Y', itU32),
      wbInteger('Type', itU32, wbEnum([
        'Rain',
        'Snow'
      ])),
      wbInteger('Box Size', itU32),
      wbFloat('Particle Density')
    ], cpNormal, True, nil, 10),
    wbString(ICON, 'Particle Texture')
  ]);

  wbRecord(RFCT, 'Visual Effect', [
    wbEDID,
    wbStruct(DATA, 'Effect Data', [
      wbFormIDCK('Effect Art', [ARTO, NULL]),
      wbFormIDCK('Shader', [EFSH, NULL]),
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001}'Rotate to Face Target',
        {0x00000002}'Attach to Camera',
        {0x00000004}'Inherit Rotation'
      ]))
    ], cpNormal, True)
  ]);

  wbRecord(CONT, 'Container',
    wbFlags(wbFlagsList([
      15, 'Has Distant LOD',
      16, 'Random Anim Start',
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
    wbFULL,
    wbGenericModel,
    wbCOCT,
    wbCNTOs,
    wbDEST,
    wbStruct(DATA, '', [
      wbInteger('Flags', itU8, wbFlags([
        {0x01} 'Allow Sounds When Animation',
        {0x02} 'Respawns',
        {0x04} 'Show Owner'
      ])),
      wbFloat('Weight')
    ], cpNormal, True),
    wbFormIDCk(SNAM, 'Sound - Open', [SNDR]),
    wbFormIDCk(QNAM, 'Sound - Close', [SNDR])
  ], True, nil, cpNormal, False, nil, wbContainerAfterSet);

  wbCSDT := wbRStructSK([0], 'Sound Type', [
    wbInteger(CSDT, 'Type', itU32,wbEnum([
      {00} 'Left Foot',
      {01} 'Right Foot',
      {02} 'Left Back Foot',
      {03} 'Right Back Foot',
      {04} 'Idle',
      {05} 'Aware',
      {06} 'Attack',
      {07} 'Hit',
      {08} 'Death',
      {09} 'Weapon',
      {10} 'Movement Loop',
      {11} 'Conscious Loop',
      {12} 'Auxiliary 1',
      {13} 'Auxiliary 2',
      {14} 'Auxiliary 3',
      {15} 'Auxiliary 4',
      {16} 'Auxiliary 5',
      {17} 'Auxiliary 6',
      {18} 'Auxiliary 7',
      {19} 'Auxiliary 8',
      {19} 'Auxiliary 8',
      {20} 'Jump',
      {21} 'PlayRandom/Loop'
    ])),
    wbSoundTypeSounds
  ]);

  wbCSDTs := wbRArrayS('Sound Types', wbCSDT, cpNormal, False, nil, nil, nil{wbActorTemplateUseModelAnimation});

  wbAIDT :=
    wbStruct(AIDT, 'AI Data', [
     {00} wbInteger('Aggression', itU8, wbAggressionEnum),
     {01} wbInteger('Confidence', itU8, wbConfidenceEnum),
     {02} wbInteger('Energy Level', itU8),
     {03} wbInteger('Morality', itU8, wbMoralityEnum),
     {04} wbInteger('Mood', itU8, wbMoodEnum),
          wbInteger('Assistance', itU8, wbAssistanceEnum),
          wbStruct('Aggro', [
            wbInteger('Aggro Radius Behavior', itU8, wbBoolEnum),
            wbInteger('Unused', itU8, nil, nil, cpIgnore),
            wbInteger('Warn', itU32),
            wbInteger('Warn/Attack', itU32),
            wbInteger('Attack', itU32)
          ])
    ], cpNormal, True, nil{wbActorTemplateUseAIData});

  wbAttackAnimationEnum := wbEnum([], [
     26, 'AttackLeft',
     32, 'AttackRight',
     38, 'Attack3',
     44, 'Attack4',
     50, 'Attack5',
     56, 'Attack6',
     62, 'Attack7',
     68, 'Attack8',
     74, 'AttackLoop',
     80, 'AttackSpin',
     86, 'AttackSpin2',
     97, 'PlaceMine',
    103, 'PlaceMine2',
    109, 'AttackThrow',
    115, 'AttackThrow2',
    121, 'AttackThrow3',
    127, 'AttackThrow4',
    133, 'AttackThrow5',
    255, ' DEFAULT'
  ]);

  wbRecord(CSTY, 'Combat Style',
    wbFlags(wbFlagsList([
      19, 'Allow Dual Wielding'
    ])), [
    wbEDID,
    wbStruct(CSGD, 'General', [
      wbFloat('Offensive Mult'),
      wbFloat('Defensive Mult'),
      wbFloat('Group Offensive Mult'),
      // keep as separate floats, some elements can be omitted
      wbFloat('Equipment Score Mult - Melee'),
      wbFloat('Equipment Score Mult - Magic'),
      wbFloat('Equipment Score Mult - Ranged'),
      wbFloat('Equipment Score Mult - Shout'),
      wbFloat('Equipment Score Mult - Unarmed'),
      wbFloat('Equipment Score Mult - Staff'),
      wbFloat('Avoid Threat Chance')
    ], cpNormal, True, nil, 0),
    wbUnknown(CSMD, cpIgnore),
    wbStruct(CSME, 'Melee', [
      wbFloat('Attack Staggered Mult'),
      wbFloat('Power Attack Staggered Mult'),
      wbFloat('Power Attack Blocking Mult'),
      wbFloat('Bash Mult'),
      wbFloat('Bash Recoil Mult'),
      wbFloat('Bash Attack Mult'),
      wbFloat('Bash Power Attack Mult'),
      wbFloat('Special Attack Mult')
    ], cpNormal, True, nil, 0),
    wbStruct(CSCR, 'Close Range', [
      wbFloat('Circle Mult'),
      wbFloat('Fallback Mult'),
      wbFloat('Flank Distance'),
      wbFloat('Stalk Time')
    ], cpNormal, True, nil, 0),
    wbStruct(CSLR, 'Long Range', [
      wbFloat('Strafe Mult')
    ]).SetRequired,
    wbStruct(CSFL, 'Flight', [
      wbFloat('Hover Chance'),
      wbFloat('Dive Bomb Chance'),
      wbFloat('Ground Attack Chance'),
      wbFloat('Hover Time'),
      wbFloat('Ground Attack Time'),
      wbFloat('Perch Attack Chance'),
      wbFloat('Perch Attack Time'),
      wbFloat('Flying Attack Chance')
    ], cpNormal, True, nil, 0),
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      {0x01} 'Dueling',
      {0x02} 'Flanking',
      {0x04} 'Allow Dual Wielding'
    ])).SetRequired
  ]);

  wbSubtypeNamesEnum := wbEnum([], [
    Sig2Int('ACAC'), 'ActorCollidewithActor',
    Sig2Int('ACYI'), 'AcceptYield',
    Sig2Int('AGRE'), 'Agree',
    Sig2Int('ALIL'), 'AlertIdle',
    Sig2Int('ALKL'), 'AllyKilled',
    Sig2Int('ALTC'), 'AlertToCombat',
    Sig2Int('ALTN'), 'AlertToNormal',
    Sig2Int('ASKF'), 'Ask Favor',
    Sig2Int('ASKG'), 'Ask Gift',
    Sig2Int('ASNC'), 'AssaultNC',
    Sig2Int('ASSA'), 'Assault',
    Sig2Int('ATCK'), 'Attack',
    Sig2Int('AVTH'), 'AvoidThreat',
    Sig2Int('BAEX'), 'BarterExit',
    Sig2Int('BASH'), 'Bash',
    Sig2Int('BLED'), 'BleedOut',
    Sig2Int('BLOC'), 'Block',
    Sig2Int('BREA'), 'EnterSprintBreath',
    Sig2Int('BRIB'), 'Bribe',
    Sig2Int('COLO'), 'CombatToLost',
    Sig2Int('COTN'), 'CombatToNormal',
    Sig2Int('CUST'), 'Custom',
    Sig2Int('DEOB'), 'DestroyObject',
    Sig2Int('DETH'), 'Death',
    Sig2Int('DFDA'), 'DetectFriendDie',
    Sig2Int('ENBZ'), 'EnterBowZoomBreath',
    Sig2Int('EXBZ'), 'ExitBowZoomBreath',
    Sig2Int('FAVO'), 'Favor',
    Sig2Int('FEXT'), 'ExitFavorState',
    Sig2Int('FIWE'), 'ShootBow',
    Sig2Int('FLAT'), 'Flatter',
    Sig2Int('FLEE'), 'Flee',
    Sig2Int('FMAT'), 'FlyingMountAcceptTarget',
    Sig2Int('FMDR'), 'FlyingMountDestinationReached',
    Sig2Int('FMLX'), 'FlyingMountLand',
    Sig2Int('FMNT'), 'FlyingMountNoTarget',
    Sig2Int('FMRT'), 'FlyingMountRejectTarget',
    Sig2Int('FMXL'), 'FlyingMountCancelLand',
    Sig2Int('FOLL'), 'Follow',
    Sig2Int('FRJT'), 'Reject',
    Sig2Int('FVDL'), 'Custom?',
    Sig2Int('GBYE'), 'Goodbye',
    Sig2Int('GIFF'), 'Gift',
    Sig2Int('GRNT'), 'CombatGrunt',
    Sig2Int('GRST'), 'GroupStrategy',
    Sig2Int('HELO'), 'Hello',
    Sig2Int('HIT_'), 'Hit',
    Sig2Int('IDAT'), 'SharedInfo',
    Sig2Int('IDLE'), 'Idle',
    Sig2Int('INTI'), 'Intimidate',
    Sig2Int('JUMP'), 'Jump',
    Sig2Int('KNOO'), 'KnockOverObject',
    Sig2Int('LOIL'), 'LostIdle',
    Sig2Int('LOOB'), 'LockedObject',
    Sig2Int('LOTC'), 'LostToCombat',
    Sig2Int('LOTN'), 'LostToNormal',
    Sig2Int('LWBS'), 'LeaveWaterBreath',
    Sig2Int('MREF'), 'MoralRefusal',
    Sig2Int('MUNC'), 'MurderNC',
    Sig2Int('MURD'), 'Murder',
    Sig2Int('NOTA'), 'NormalToAlert',
    Sig2Int('NOTC'), 'NormalToCombat',
    Sig2Int('NOTI'), 'NoticeCorpse',
    Sig2Int('OBCO'), 'ObserveCombat',
    Sig2Int('OUTB'), 'OutofBreath',
    Sig2Int('PCPS'), 'PlayerCastProjectileSpell',
    Sig2Int('PCSH'), 'PlayerShout',
    Sig2Int('PCSS'), 'PlayerCastSelfSpell',
    Sig2Int('PFGT'), 'ForceGreet',
    Sig2Int('PICC'), 'PickpocketCombat',
    Sig2Int('PICN'), 'PickpocketNC',
    Sig2Int('PICT'), 'PickpocketTopic',
    Sig2Int('PIRN'), 'PlayerinIronSights',
    Sig2Int('POAT'), 'PowerAttack',
    Sig2Int('PURS'), 'PursueIdleTopic',
    Sig2Int('RCEX'), 'RechargeExit',
    Sig2Int('RECH'), 'Recharge',
    Sig2Int('REEX'), 'RepairExit',
    Sig2Int('REFU'), 'Refuse',
    Sig2Int('REPA'), 'Repair',
    Sig2Int('RUMO'), 'Rumors',
    Sig2Int('SCEN'), 'Scene',
    Sig2Int('SERU'), 'ServiceRefusal',
    Sig2Int('SHOW'), 'Show',
    Sig2Int('SHRE'), 'Show Relationships',
    Sig2Int('STEA'), 'Steal',
    Sig2Int('STFN'), 'StealFromNC',
    Sig2Int('STOF'), 'StandonFurniture',
    Sig2Int('SWMW'), 'SwingMeleeWeapon',
    Sig2Int('TAUT'), 'Taunt',
    Sig2Int('TITG'), 'TimeToGo',
    Sig2Int('TRAI'), 'Training',
    Sig2Int('TRAN'), 'TrespassAgainstNC',
    Sig2Int('TRAV'), 'Travel',
    Sig2Int('TRES'), 'Trespass',
    Sig2Int('TREX'), 'TrainingExit',
    Sig2Int('VPEL'), 'VoicePowerEndLong',
    Sig2Int('VPES'), 'VoicePowerEndShort',
    Sig2Int('VPSL'), 'VoicePowerStartLong',
    Sig2Int('VPSS'), 'VoicePowerStartShort',
    Sig2Int('WTCR'), 'WereTransformCrime',
    Sig2Int('YIEL'), 'Yield',
    Sig2Int('ZKEY'), 'ZKeyObject'
  ]);

  wbRecord(DIAL, 'Dialog Topic',
    wbFlags(wbFlagsList([
      14, 'Partial Form'
    ]), [14]), [
    wbEDID,
    wbFULL,
    wbFloat(PNAM, 'Priority', cpNormal, True, 1, -1, nil, nil, 50.0),
    wbFormIDCk(BNAM, 'Branch', [DLBR, NULL]),
    wbFormIDCkNoReach(QNAM, 'Quest', [QUST, NULL], False, cpNormal, False),
    wbStruct(DATA, 'Data', [
      // this should not be named Flags since TwbFile.BuildReachable
      // expects Top-Level flag here from FNV
      wbInteger('Topic Flags', itU8, wbFlags([
        'Do All Before Repeating'
      ]), cpNormal, True),
      wbInteger('Category', itU8, wbEnum([
        {0} 'Topic',
        {1} 'Favor', // only in DA14 quest topics
        {2} 'Scene',
        {3} 'Combat',
        {4} 'Favors',
        {5} 'Detection',
        {6} 'Service',
        {7} 'Miscellaneous'
      ])),
      wbInteger('Subtype', itU16, wbEnum([], [
         0, 'Custom',
         1, 'ForceGreet',
         2, 'Rumors',
         3, 'Custom?',
         4, 'Intimidate',
         5, 'Flatter',
         6, 'Bribe',
         7, 'Ask Gift',
         8, 'Gift',
         9, 'Ask Favor',
        10, 'Favor',
        11, 'Show Relationships',
        12, 'Follow',
        13, 'Reject',
        14, 'Scene',
        15, 'Show',
        16, 'Agree',
        17, 'Refuse',
        18, 'ExitFavorState',
        19, 'MoralRefusal',
        20, 'FlyingMountLand',
        21, 'FlyingMountCancelLand',
        22, 'FlyingMountAcceptTarget',
        23, 'FlyingMountRejectTarget',
        24, 'FlyingMountNoTarget',
        25, 'FlyingMountDestinationReached',
        26, 'Attack',
        27, 'PowerAttack',
        28, 'Bash',
        29, 'Hit',
        30, 'Flee',
        31, 'Bleedout',
        32, 'AvoidThreat',
        33, 'Death',
        34, 'GroupStrategy',
        35, 'Block',
        36, 'Taunt',
        37, 'AllyKilled',
        38, 'Steal',
        39, 'Yield',
        40, 'AcceptYield',
        41, 'PickpocketCombat',
        42, 'Assault',
        43, 'Murder',
        44, 'AssaultNC',
        45, 'MurderNC',
        46, 'PickpocketNC',
        47, 'StealFromNC',
        48, 'TrespassAgainstNC',
        49, 'Trespass',
        50, 'WereTransformCrime',
        51, 'VoicePowerStartShort',
        52, 'VoicePowerStartLong',
        53, 'VoicePowerEndShort',
        54, 'VoicePowerEndLong',
        55, 'AlertIdle',
        56, 'LostIdle',
        57, 'NormalToAlert',
        58, 'AlertToCombat',
        59, 'NormalToCombat',
        60, 'AlertToNormal',
        61, 'CombatToNormal',
        62, 'CombatToLost',
        63, 'LostToNormal',
        64, 'LostToCombat',
        65, 'DetectFriendDie',
        66, 'ServiceRefusal',
        67, 'Repair',
        68, 'Travel',
        69, 'Training',
        70, 'BarterExit',
        71, 'RepairExit',
        72, 'Recharge',
        73, 'RechargeExit',
        74, 'TrainingExit',
        75, 'ObserveCombat',
        76, 'NoticeCorpse',
        77, 'TimeToGo',
        78, 'GoodBye',
        79, 'Hello',
        80, 'SwingMeleeWeapon',
        81, 'ShootBow',
        82, 'ZKeyObject',
        83, 'Jump',
        84, 'KnockOverObject',
        85, 'DestroyObject',
        86, 'StandonFurniture',
        87, 'LockedObject',
        88, 'PickpocketTopic',
        89, 'PursueIdleTopic',
        90, 'SharedInfo',
        91, 'PlayerCastProjectileSpell',
        92, 'PlayerCastSelfSpell',
        93, 'PlayerShout',
        94, 'Idle',
        95, 'EnterSprintBreath',
        96, 'EnterBowZoomBreath',
        97, 'ExitBowZoomBreath',
        98, 'ActorCollidewithActor',
        99, 'PlayerinIronSights',
       100, 'OutofBreath',
       101, 'CombatGrunt',
       102, 'LeaveWaterBreath'
      ]), cpIgnore)
    ]),
    //wbString(SNAM, 'Subtype Name', 4).SetDefaultEditValue('CUST').SetRequired,
    wbInteger(SNAM, 'Subtype Name', itU32, wbSubtypeNamesEnum)
      .SetDefaultNativeValue(Sig2Int('CUST'))
      .SetAfterSet(procedure(const aElement: IwbElement; const aOldValue, aNewValue: Variant)
        begin
          var lContainer: IwbContainer;
          if not Supports(aElement, IwbContainer, lContainer) then
            Exit;

          var lSubtype := lContainer.ElementByPath['..\DATA\Subtype'];
          if not Assigned(lSubtype) then
            Exit;

          lSubtype.EditValue := aElement.EditValue;
        end)
       .SetRequired,
    wbInteger(TIFC, 'Info Count', itU32, nil, cpIgnore),
    wbINOM,
    wbINOA
  ]).SetAddInfo(wbDIALAddInfo);

  wbRecord(DOOR, 'Door',
    wbFlags(wbFlagsList([
      15, 'Has Distant LOD',
      16, 'Random Anim Start',
      23, 'Is Marker',
      25, 'Obstacle'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbFormIDCk(SNAM, 'Sound - Open', [SNDR]),
    wbFormIDCk(ANAM, 'Sound - Close', [SNDR]),
    wbFormIDCk(BNAM, 'Sound - Loop', [SNDR]),
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      '',
      'Automatic',
      'Hidden',
      'Minimal Use',
      'Sliding',
      'Do Not Open in Combat Search'
    ]), cpNormal, True),
    wbRArrayS('Random teleport destinations', wbFormIDCk(TNAM, 'Destination', [CELL, WRLD]))
  ]);

  wbRecord(EFSH, 'Effect Shader', [
    wbEDID,
    wbString(ICON, 'Fill Texture'),
    wbString(ICO2, 'Particle Shader Texture'),
    wbString(NAM7, 'Holes Texture'),
    wbString(NAM8, 'Membrane Palette Texture'),
    wbString(NAM9, 'Particle Palette Texture'),
    wbStruct(DATA, '', [
      wbByteArray('Unknown', 4),
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
      wbInteger('Particle Shader - Source Blend Mode', itU32, wbBlendModeEnum),
      wbInteger('Particle Shader - Blend Operation', itU32, wbBlendOpEnum),
      wbInteger('Particle Shader - Z Test Function', itU32, wbZTestFuncEnum),
      wbInteger('Particle Shader - Dest Blend Mode', itU32, wbBlendModeEnum),
      wbFloat('Particle Shader - Particle Birth Ramp Up Time'),
      wbFloat('Particle Shader - Full Particle Birth Time'),
      wbFloat('Particle Shader - Particle Birth Ramp Down Time'),
      wbFloat('Particle Shader - Full Particle Birth Ratio'),
      wbFloat('Particle Shader - Persistant Particle Count'),
      wbFloat('Particle Shader - Particle Lifetime'),
      wbFloat('Particle Shader - Particle Lifetime +/-'),
      wbFloat('Particle Shader - Initial Speed Along Normal'),
      wbFloat('Particle Shader - Acceleration Along Normal'),
      wbFloat('Particle Shader - Initial Velocity #1'),
      wbFloat('Particle Shader - Initial Velocity #2'),
      wbFloat('Particle Shader - Initial Velocity #3'),
      wbFloat('Particle Shader - Acceleration #1'),
      wbFloat('Particle Shader - Acceleration #2'),
      wbFloat('Particle Shader - Acceleration #3'),
      wbFloat('Particle Shader - Scale Key 1'),
      wbFloat('Particle Shader - Scale Key 2'),
      wbFloat('Particle Shader - Scale Key 1 Time'),
      wbFloat('Particle Shader - Scale Key 2 Time'),
      wbByteColors('Color Key 1 - Color'),
      wbByteColors('Color Key 2 - Color'),
      wbByteColors('Color Key 3 - Color'),
      wbFloat('Color Key 1 - Color Alpha'),
      wbFloat('Color Key 2 - Color Alpha'),
      wbFloat('Color Key 3 - Color Alpha'),
      wbFloat('Color Key 1 - Color Key Time'),
      wbFloat('Color Key 2 - Color Key Time'),
      wbFloat('Color Key 3 - Color Key Time'),
      wbFloat('Particle Shader - Initial Speed Along Normal +/-'),
      wbFloat('Particle Shader - Initial Rotation (deg)'),
      wbFloat('Particle Shader - Initial Rotation (deg) +/-'),
      wbFloat('Particle Shader - Rotation Speed (deg/sec)'),
      wbFloat('Particle Shader - Rotation Speed (deg/sec) +/-'),
      wbFormIDCk('Addon Models', [DEBR, NULL]),
      wbFloat('Holes - Start Time'),
      wbFloat('Holes - End Time'),
      wbFloat('Holes - Start Val'),
      wbFloat('Holes - End Val'),
      wbFloat('Edge Width (alpha units)'),
      wbByteColors('Edge Color'),
      wbFloat('Explosion Wind Speed'),
      wbInteger('Texture Count U', itU32),
      wbInteger('Texture Count V', itU32),
      wbFloat('Addon Models - Fade In Time'),
      wbFloat('Addon Models - Fade Out Time'),
      wbFloat('Addon Models - Scale Start'),
      wbFloat('Addon Models - Scale End'),
      wbFloat('Addon Models - Scale In Time'),
      wbFloat('Addon Models - Scale Out Time'),
      wbFormIDCk('Ambient Sound', [SNDR, SOUN, NULL]),
      wbByteColors('Fill/Texture Effect - Color Key 2'),
      wbByteColors('Fill/Texture Effect - Color Key 3'),
      wbStruct('Fill/Texture Effect - Color Key Scale/Time', [
        wbFloat('Color Key 1 - Scale'),
        wbFloat('Color Key 2 - Scale'),
        wbFloat('Color Key 3 - Scale'),
        wbFloat('Color Key 1 - Time'),
        wbFloat('Color Key 2 - Time'),
        wbFloat('Color Key 3 - Time')
      ]),
      wbFloat('Color Scale'),
      wbFloat('Birth Position Offset'),
      wbFloat('Birth Position Offset Range +/-'),
      wbStruct('Particle Shader Animated', [
        wbInteger('Start Frame', itU32),
        wbInteger('Start Frame Variation', itU32),
        wbInteger('End Frame', itU32),
        wbInteger('Loop Start Frame', itU32),
        wbInteger('Loop Start Variation', itU32),
        wbInteger('Frame Count', itU32),
        wbInteger('Frame Count Variation', itU32)
      ]),
      wbInteger('Flags', itU32, wbFlags([
        'No Membrane Shader',
        'Membrane Grayscale Color',
        'Membrane Grayscale Alpha',
        'No Particle Shader',
        'Edge Effect Inverse',
        'Affect Skin Only',
        'Ignore Alpha',
        'Project UVs',
        'Ignore Base Geometry Alpha',
        'Lighting',
        'No Weapons',
        'Unknown 11',
        'Unknown 12',
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
        'Use Blood Geometry'
      ])),
      wbFloat('Fill/Texture Effect - Texture Scale (U)'),
      wbFloat('Fill/Texture Effect - Texture Scale (V)'),
      wbInteger('Scene Graph Emit Depth Limit (unused)', itU32)
    ], cpNormal, True, nil, 0)
  ], False, nil, cpNormal, False, nil {wbEFSHAfterLoad});

  wbRecord(ENCH, 'Enchantment', [
    wbEDID,
    wbOBND(True),
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
    wbEffectsReq
  ]);

  wbRecord(EYES, 'Eyes',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
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

  wbFactionRank :=
    wbRStructSK([0], 'Rank', [
      wbInteger(RNAM, 'Rank#', itU32),
      wbLString(MNAM, 'Male Title', 0, cpTranslate),
      wbLString(FNAM, 'Female Title', 0, cpTranslate),
      wbString(INAM, 'Insignia Unused')
    ]);

  wbRecord(FACT, 'Faction', [
    wbEDID,
    wbFULL,
    wbFactionRelations,
    wbStruct(DATA, 'Flags', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001}'Hidden From NPC',
        {0x00000002}'Special Combat',
        {0x00000004}'Unknown 3',
        {0x00000008}'Unknown 4',
        {0x00000010}'Unknown 5',
        {0x00000020}'Unknown 6',
        {0x00000040}'Track Crime',
        {0x00000080}'Ignore Crimes: Murder',
        {0x00000100}'Ignore Crimes: Assault',
        {0x00000200}'Ignore Crimes: Stealing',
        {0x00000400}'Ignore Crimes: Trespass',
        {0x00000800}'Do Not Report Crimes Against Members',
        {0x00001000}'Crime Gold - Use Defaults',
        {0x00002000}'Ignore Crimes: Pickpocket',
        {0x00004000}'Vendor',
        {0x00008000}'Can Be Owner',
        {0x00010000}'Ignore Crimes: Werewolf',
        {0x00020000}'Unknown 18',
        {0x00040000}'Unknown 19',
        {0x00080000}'Unknown 20',
        {0x00100000}'Unknown 21',
        {0x00200000}'Unknown 22',
        {0x00400000}'Unknown 23',
        {0x00800000}'Unknown 24',
        {0x01000000}'Unknown 25',
        {0x02000000}'Unknown 26',
        {0x04000000}'Unknown 27',
        {0x08000000}'Unknown 28',
        {0x10000000}'Unknown 29',
        {0x20000000}'Unknown 30',
        {0x40000000}'Unknown 31',
        {0x80000000}'Unknown 32'
      ]))
    ], cpNormal, True, nil, 1),
    wbFormIDCk(JAIL, 'Exterior Jail Marker', [REFR]),
    wbFormIDCk(WAIT, 'Follower Wait Marker', [REFR]),
    wbFormIDCk(STOL, 'Stolen Goods Container', [REFR]),
    wbFormIDCk(PLCN, 'Player Inventory Container', [REFR]),
    wbFormIDCk(CRGR, 'Shared Crime Faction List', [FLST]),
    wbFormIDCk(JOUT, 'Jail Outfit', [OTFT]),
    wbStruct(CRVA, 'Crime Values', [
      {01} wbInteger('Arrest', itU8, wbBoolEnum),
      {02} wbInteger('Attack On Sight', itU8, wbBoolEnum),
      {02} wbInteger('Murder', itU16),
      {02} wbInteger('Assault', itU16),
      {02} wbInteger('Trespass', itU16),
      {02} wbInteger('Pickpocket', itU16),
      {02} wbInteger('Unknown', itU16),
      {02} wbFloat('Steal Multiplier'),
      {02} wbInteger('Escape', itU16),
      {02} wbInteger('Werewolf', itU16)
      ], cpNormal, False, nil, 7).SetRequired,
    wbRArrayS('Ranks', wbFactionRank),
    wbFormIDCk(VEND, 'Vendor Buy/Sell List', [FLST]),
    wbFormIDCk(VENC, 'Merchant Container', [REFR]),
    wbStruct(VENV, 'Vendor Values', [
      {01} wbInteger('Start Hour', itU16),
      {02} wbInteger('End Hour', itU16),
      {02} wbInteger('Radius', itU16),
      {02} wbByteArray('Unknown 1', 2),
           wbInteger('Only Buys Stolen Items', itU8, wbBoolEnum),
           wbInteger('Not/Sell Buy', itU8, wbBoolEnum),
      {02} wbByteArray('Unknown 2', 2)
      ]).SetRequired,
    wbPLVD,
    wbCITC,
    wbConditions
  ]);

  wbRecord(FURN, 'Furniture',
    wbFlags(wbFlagsList([
      7, 'Is Perch',
     15, 'Has Distant LOD',
     16, 'Random Anim Start',
     23, 'Is Marker',
     25, 'Obstacle',
     28, 'Must Exit To Talk',
     29, 'Child Can Use'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbByteColors(PNAM, 'Marker Color (Unused)'),
    wbInteger(FNAM, 'Flags', itU16, wbFlags([
      {0x0001} 'Unknown 0',
      {0x0002} 'Ignored By Sandbox'
    ])),
    wbFormIDCk(KNAM, 'Interaction Keyword', [KYWD, NULL]),
    wbInteger(MNAM, 'Active Markers / Flags', itU32, wbFlags([
      {0x00000001} 'Sit 0',
      {0x00000002} 'Sit 1',
      {0x00000004} 'Sit 2',
      {0x00000008} 'Sit 3',
      {0x00000010} 'Sit 4',
      {0x00000020} 'Sit 5',
      {0x00000040} 'Sit 6',
      {0x00000080} 'Sit 7',
      {0x00000100} 'Sit 8',
      {0x00000200} 'Sit 9',
      {0x00000400} 'Sit 10',
      {0x00000800} 'Sit 11',
      {0x00001000} 'Sit 12',
      {0x00002000} 'Sit 13',
      {0x00004000} 'Sit 14',
      {0x00008000} 'Sit 15',
      {0x00010000} 'Sit 16',
      {0x00020000} 'Sit 17',
      {0x00040000} 'Sit 18',
      {0x00080000} 'Sit 19',
      {0x00100000} 'Sit 20',
      {0x00200000} 'Sit 21',
      {0x00400000} 'Sit 22',
      {0x00800000} 'Sit 23',
      {0x01000000} 'Unknown 25',
      {0x02000000} 'Disables Activation',
      {0x04000000} 'Is Perch',
      {0x08000000} 'Must Exit to Talk',
      {0x10000000} 'Unknown 29',
      {0x20000000} 'Unknown 30',
      {0x40000000} 'Unknown 31',
      {0x80000000} 'Unknown 32'
    ])),
    wbStruct(WBDT, 'Workbench Data', [
      wbInteger('Bench Type', itU8, wbEnum([
        {0} 'None',
        {1} 'Create object',
        {2} 'Smithing Weapon',
        {3} 'Enchanting',
        {4} 'Enchanting Experiment',
        {5} 'Alchemy',
        {6} 'Alchemy Experiment',
        {7} 'Smithing Armor'
      ])),
      wbInteger('Uses Skill', itS8, wbSkillEnum)
    ]),
    wbFormIDCk(NAM1, 'Associated Spell', [SPEL]),
    wbRArray('Markers', wbRStruct('Marker', [
      wbInteger(ENAM, 'Marker Index', itU32),
      wbStruct(NAM0, 'Disabled Entry Points', [
        wbByteArray('Unknown', 2),
        wbInteger('Disabled Points', itU16, wbFurnitureEntryTypeFlags)
      ]),
      wbFormIDCk(FNMK, 'Marker Keyword', [KYWD, NULL])
    ])),
    wbRArray('Marker Entry Points', wbStruct(FNPR, 'Marker', [
      wbInteger('Type', itU16, wbFurnitureAnimEnum),
      wbInteger('Entry Points', itU16, wbFurnitureEntryTypeFlags)
    ])),
    wbString(XMRK, 'Model FileName')
  ]);

//----------------------------------------------------------------------------
// For expansion to use wbGLOBUnionDecider to display Short, Long, Float
// correctly without making a signed float by default
//----------------------------------------------------------------------------
  wbRecord(GLOB, 'Global',
    wbFlags(wbFlagsList([
      6, 'Constant'
    ])), [
    wbEDID,
    wbInteger(FNAM, 'Type', itU8, wbEnum([], [
      Ord('s'), 'Short',
      Ord('l'), 'Long',
      Ord('f'), 'Float'
    ]), cpNormal, True).SetDefaultEditValue('Float'),
    wbFloat(FLTV, 'Value', cpNormal, True)
  ]);

  wbRecord(GMST, 'Game Setting', [
    wbString(EDID, 'Editor ID', 0, cpCritical, True, nil, wbGMSTEDIDAfterSet),
    wbUnion(DATA, 'Value', wbGMSTUnionDecider, [
      wbLString('Name', 0, cpTranslate),
      wbInteger('Int', itS32),
      wbFloat('Float'),
      wbInteger('Bool', itU32, wbBoolEnum)
    ]).SetRequired
  ]).SetSummaryKey([1])
    .IncludeFlag(dfIndexEditorID);

  wbRecord(KYWD, 'Keyword', [
    wbEDID,
    wbCNAM.SetRequired
  ]);

  wbRecord(LCRT, 'Location Reference Type', [
    wbEDID,
    wbCNAM.SetRequired
  ]);

  wbRecord(AACT, 'Action', [
    wbEDID,
    wbCNAM.SetRequired
  ]);

  wbRecord(TXST, 'Texture Set', [
    wbEDID,
    wbOBND(True),
    wbRStruct('Textures (RGB/A)', [
      wbString(TX00,'Diffuse'),
      wbString(TX01,'Normal/Gloss'),
      wbString(TX02,'Environment Mask/Subsurface Tint'),
      wbString(TX03,'Glow/Detail Map'),
      wbString(TX04,'Height'),
      wbString(TX05,'Environment'),
      wbString(TX06,'Multilayer'),
      wbString(TX07,'Backlight Mask/Specular')
    ]).SetSummaryKey([0]),
    wbDODT,
    wbInteger(DNAM, 'Flags', itU16, wbFlags([
      {0x0001}'No Specular Map',
      {0x0002}'Facegen Textures',
      {0x0004}'Has Model Space Normal Map'
    ]), cpNormal, False)
  ]).SetSummaryKey([2, 3]);

  wbRecord(HDPT, 'Head Part',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbFULL,
    wbGenericModel,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      {0x01} 'Playable',
      {0x02} 'Male',
      {0x04} 'Female',
      {0x10} 'Is Extra Part',
      {0x20} 'Use Solid Tint'
    ]), cpNormal, True),
    wbInteger(PNAM, 'Type', itU32, wbEnum([
      'Misc',
      'Face',
      'Eyes',
      'Hair',
      'Facial Hair',
      'Scar',
      'Eyebrows'
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
    ])),
    wbFormIDCk(TNAM, 'Texture Set', [TXST, NULL]),
    wbFormIDCk(CNAM, 'Color', [CLFM, NULL]),
    wbFormIDCk(RNAM, 'Valid Races', [FLST, NULL])
  ]);

  wbRecord(ASPC, 'Acoustic Space', [
    wbEDID,
    wbOBND(True),
    wbFormIDCk(SNAM, 'Ambient Sound', [SNDR]),
    wbFormIDCk(RDAT, 'Use Sound from Region (Interiors Only)', [REGN]),
    wbFormIDCk(BNAM, 'Environment Type (reverb)', [REVB])
  ]);

  wbRecord(MSTT, 'Moveable Static',
    wbFlags(wbFlagsList([
      2, 'Never Fades',
      8, 'Must Update Anims',
      9, 'Hidden From Local Map',
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
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbInteger(DATA, 'Flags', itU8, wbFlags([
      'On Local Map',
      'Unknown 1',
      'Unknown 2'
    ]), cpNormal, True),
    wbFormIDCk(SNAM, 'Looping Sound', [SNDR])
  ]);

  wbRecord(IDLM, 'Idle Marker',
    wbFlags(wbFlagsList([
      29, 'Child Can Use'
    ])), [
    wbEDID,
    wbOBND(True),
    wbInteger(IDLF, 'Flags', itU8, wbFlags([
      'Run in Sequence',
      'Unknown 1',
      'Do Once',
      'Unknown 3',
      'Ignored by Sandbox'
    ]), cpNormal, False),
    wbInteger(IDLC, 'Animation Count', itU8, nil, cpBenign),
    wbFloat(IDLT, 'Idle Timer Setting', cpNormal, False),
    wbArray(IDLA, 'Animations', wbFormIDCk('Animation', [IDLE]), 0, nil, wbIDLAsAfterSet, cpNormal, False),
    wbGenericModel
  ], False, nil, cpNormal, False, nil, wbAnimationsAfterSet);

  wbRecord(PROJ, 'Projectile', [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbDEST,
    wbStruct(DATA, 'Data', [
      {00} wbInteger('Flags', itU16, wbFlags([
        'Hitscan',
        'Explosion',
        'Alt. Trigger',
        'Muzzle Flash',
        '',
        'Can Be Disabled',
        'Can Be Picked Up',
        'Supersonic',
        'Pins Limbs',
        'Pass Through Small Transparent',
        'Disable Combat Aim Correction',
        'Rotation'
      ])),
      {02} wbInteger('Type', itU16, wbEnum([], [
        $01, 'Missile',
        $02, 'Lobber',
        $04, 'Beam',
        $08, 'Flame',
        $10, 'Cone',
        $20, 'Barrier',
        $40, 'Arrow'
      ])),
      {04} wbFloat('Gravity'),
      {08} wbFloat('Speed'),
      {12} wbFloat('Range'),
      {16} wbFormIDCk('Light', [LIGH, NULL]),
      {20} wbFormIDCk('Muzzle Flash - Light', [LIGH, NULL]),
      {24} wbFloat('Tracer Chance'),
      {28} wbFloat('Explosion - Alt. Trigger - Proximity'),
      {32} wbFloat('Explosion - Alt. Trigger - Timer'),
      {36} wbFormIDCk('Explosion', [EXPL, NULL]),
      {40} wbFormIDCk('Sound', [SNDR, NULL]),
      {44} wbFloat('Muzzle Flash - Duration'),
      {48} wbFloat('Fade Duration'),
      {52} wbFloat('Impact Force'),
      {56} wbFormIDCk('Sound - Countdown', [SNDR, NULL]),
      {60} wbFormIDCk('Sound - Disable', [SNDR, NULL]),
      {64} wbFormIDCk('Default Weapon Source', [WEAP, NULL]),
      {68} wbFloat('Cone Spread'),
      {72} wbFloat('Collision Radius'),
      {76} wbFloat('Lifetime'),
      {80} wbFloat('Relaunch Interval'),
           wbFormIDCk('Decal Data', [TXST, NULL]),
           wbFormIDCk('Collision Layer', [COLL, NULL])
    ], cpNormal, True, nil, 22),
    wbRStructSK([0], 'Muzzle Flash Model', [
      wbString(NAM1, 'Model FileName'),
      wbModelInfo(NAM2)
    ], [], cpNormal, True),
    wbInteger(VNAM, 'Sound Level', itU32, wbSoundLevelEnum, cpNormal, True)
  ]);

  wbRecord(HAZD, 'Hazard', [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD, NULL]),
    wbStruct(DATA, 'Data', [
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
        {0x10} 'Drop to Ground'
      ])),
      wbFormIDCk('Spell', [SPEL, ENCH, NULL]),
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFormIDCk('Impact Data Set', [IPDS, NULL]),
      wbFormIDCk('Sound', [SNDR, NULL])
    ])
  ]);

  wbRecord(SLGM, 'Soul Gem',
    wbFlags(wbFlagsList([
      17, 'Can Hold NPC Soul'
    ])), [
    wbEDID,
    wbOBND,
    wbFULL,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbStruct(DATA, '', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbInteger(SOUL, 'Contained Soul', itU8, wbSoulGemEnum, cpNormal, True),
    wbInteger(SLCP, 'Maximum Capacity', itU8, wbSoulGemEnum, cpNormal, True),
    wbFormIDCk(NAM0, 'Linked To', [SLGM])
  ]);

  wbNVNM :=
    wbStruct(NVNM, 'Geometry', [
      wbInteger('Version', itU32).SetDefaultNativeValue(12),
      wbStruct('Pathing Cell', [
        wbInteger('CRC Hash', itU32, wbCRCValuesEnum).SetDefaultEditValue('PathingCell'),
        wbFormIDCk('Parent World', [WRLD, NULL]).IncludeFlag(dfSummaryExcludeNULL),
        wbUnion('Parent Cell', wbNVNMParentDecider, [
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
          wbByteArray('Triangles', 16),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Triangles',
          wbStruct('Triangle', [
            wbInteger('Vertex 0', itU16, wbVertexToStr0, wbVertexToInt0).SetLinksToCallback(wbVertexLinksTo),
            wbInteger('Vertex 1', itU16, wbVertexToStr1, wbVertexToInt1).SetLinksToCallback(wbVertexLinksTo),
            wbInteger('Vertex 2', itU16, wbVertexToStr2, wbVertexToInt2).SetLinksToCallback(wbVertexLinksTo),
            wbInteger('Edge 0-1', itS16, wbEdgeToStr0, wbEdgeToInt0).SetLinksToCallback(wbEdgeLinksTo0),
            wbInteger('Edge 1-2', itS16, wbEdgeToStr1, wbEdgeToInt1).SetLinksToCallback(wbEdgeLinksTo1),
            wbInteger('Edge 2-0', itS16, wbEdgeToStr2, wbEdgeToInt2).SetLinksToCallback(wbEdgeLinksTo2),
            wbInteger('Flags', itU16, wbNavmeshTriangleFlags)
              .IncludeFlag(dfCollapsed, wbCollapseFlags),
            wbInteger('Cover Flags', itU16, wbNavmeshCoverFlags)
              .IncludeFlag(dfCollapsed, wbCollapseFlags)
          ]),
        -1).IncludeFlag(dfNotAlignable)
      ),
      wbArray('Edge Links',
        wbStruct('Edge Link', [
          wbInteger('Type', itU32, wbNavmeshEdgeLinkEnum, cpIgnore),
          wbFormIDCk('Navmesh', [NAVM], False, cpIgnore),
          wbInteger('Triangle', itS16, nil, cpIgnore)
        ]).SetSummaryKey([2, 1])
          .SetSummaryMemberPrefixSuffix(2, 'Tri: [', ']')
          .SetSummaryMemberPrefixSuffix(1, 'Nav: ', '')
          .IncludeFlag(dfCollapsed),
      -1).IncludeFlag(dfNotAlignable),
      wbArrayS('Door Links',
        wbStructSK([0, 2], 'Door Link', [
          wbInteger('Triangle', itS16).SetLinksToCallback(wbTriangleLinksTo),
          wbInteger('CRC Hash', itU32, wbCRCValuesEnum)
            .SetDefaultEditValue('PathingDoor'),
          wbFormIDCk('Door Ref', [REFR])
        ]).SetSummaryKey([0, 2])
          .SetSummaryMemberPrefixSuffix(0, 'Tri: [', ']')
          .SetSummaryMemberPrefixSuffix(2, 'Door: ', '')
          .IncludeFlag(dfCollapsed),
      -1),
      IfThen(wbSimpleRecords,
        wbArray('Cover Triangles',
          wbByteArray('Triangle', 2),
        -1).IncludeFlag(dfNotAlignable),
        wbArray('Cover Triangles',
          wbInteger('Triange', itS16).SetLinksToCallback(wbTriangleLinksTo),
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
      wbInteger('Vertex', itU16))
  ]).SetAddInfo(wbNAVMAddInfo);

  wbRecord(NAVI, 'Navmesh Info Map', [
    wbEDID,
    wbInteger(NVER, 'Version', itU32),
    wbRArrayS('Navmesh Infos',
      wbStructSK(NVMI, [0], 'Navmesh Info', [
        wbFormIDCk('Navmesh', [NAVM]).IncludeFlag(dfSummaryNoName),
        wbInteger('Category', itU32,
          wbEnum([], [
            0, 'Is Edited',
           32, 'Is Island',
           64, 'Not Edited'
          ])),
        wbArray('Unknown', wbFloat, 4),
        wbArrayS('Edge Links', wbFormIDCk('Navmesh', [NAVM]), -1).IncludeFlag(dfCollapsed),
        wbArrayS('Preferred Edge Links', wbFormIDCk('Navmesh', [NAVM]), -1).IncludeFlag(dfCollapsed),
        wbArrayS('Door Links',
          wbStructSK([1], 'Door Link', [
            wbInteger('CRC Hash', itU32, wbCRCValuesEnum).SetDefaultEditValue('PathingDoor'),
            wbFormIDCk('Door Ref', [REFR])
          ]).SetSummaryKey([1])
            .IncludeFlag(dfCollapsed)
            .IncludeFlag(dfSummaryMembersNoName),
        -1).IncludeFlag(dfCollapsed),
        wbStruct('Optional Island Data', [
          wbInteger('Has Island Data', itU8, wbBoolEnum).SetAfterSet(wbUpdateSameParentUnions),
          wbUnion('Island Data', wbNAVIIslandDataDecider, [
            wbStruct('Unused', [wbEmpty('Unused')]).IncludeFlag(dfCollapsed),
            wbStruct('Island Data', [
              wbVec3('Min'),
              wbVec3('Max'),
              wbArray('Triangles',
                wbStruct('Triangle', [
                  wbInteger('Vertex 0', itU16),
                  wbInteger('Vertex 1', itU16),
                  wbInteger('Vertex 2', itU16)
                ]).IncludeFlag(dfCollapsed),
              -1).IncludeFlag(dfCollapsed)
                 .IncludeFlag(dfNotAlignable),
              wbArray('Vertices',
                wbVec3('Vertex'),
              -1).IncludeFlag(dfCollapsed)
                 .IncludeFlag(dfNotAlignable)
            ]).SetSummaryKey([2])
              .IncludeFlag(dfCollapsed)
              .IncludeFlag(dfSummaryMembersNoName)
          ]).IncludeFlag(dfCollapsed)
        ]).SetSummaryKey([1])
          .IncludeFlag(dfCollapsed)
          .IncludeFlag(dfSummaryMembersNoName),
        wbStruct('Pathing Cell', [
          wbInteger('CRC Hash', itU32, wbCRCValuesEnum).SetDefaultEditValue('PathingCell'),
          wbFormIDCk('Parent World', [WRLD, NULL]).IncludeFlag(dfSummaryExcludeNull),
          wbUnion('', wbNAVIParentDecider, [
            wbStruct('Coordinates', [
              wbInteger('Grid Y', itS16),
              wbInteger('Grid X', itS16)
            ]).SetSummaryKey([1, 0])
              .SetSummaryMemberPrefixSuffix(0, 'Y: ', '>')
              .SetSummaryMemberPrefixSuffix(1, '<X: ', '')
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
        wbArray('Path', wbFormIDCk('Navmesh', [NAVM]), -1).IncludeFlag(dfCollapsed),
      -1).IncludeFlag(dfCollapsed),
      wbArrayS('Road Marker Index',
        wbStructSK([1], 'Road Marker', [
          wbFormIDCk('Navmesh', [NAVM]),
          wbInteger('Index', itU32)
        ]).IncludeFlag(dfCollapsed),
      -1).IncludeFlag(dfCollapsed)
    ]).IncludeFlag(dfCollapsed),
    wbArrayS(NVSI, 'Deleted Navmeshes', wbFormIDCk('Navmesh', [NAVM])).IncludeFlag(dfCollapsed)
  ]);

   wbRecord(EXPL, 'Explosion', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbEnchantment,
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD]),
    wbStruct(DATA, 'Data', [  // Contradicted by FireStormExplosion02 [EXPL:000877F9]
      wbFormIDCk('Light', [LIGH, NULL]),
      wbFormIDCk('Sound 1', [SNDR, NULL]),
      wbFormIDCk('Sound 2', [SNDR, NULL]),
      wbFormIDCk('Impact Data Set', [IPDS, NULL]),
      wbFormID('Placed Object'),
      wbFormIDCk('Spawn Projectile', [PROJ, NULL]),
      wbFloat('Force'),
      wbFloat('Damage'),
      wbFloat('Radius'),
      wbFloat('IS Radius'),
      wbFloat('Vertical Offset Mult'),
      wbInteger('Flags', itU32, wbFlags([
        'Unknown 0',
        'Always Uses World Orientation',
        'Knock Down - Always',
        'Knock Down - By Formula',
        'Ignore LOS Check',
        'Push Explosion Source Ref Only',
        'Ignore Image Space Swap',
        'Chain',
        'No Controller Vibration'
      ])),
      wbInteger('Sound Level', itU32, wbSoundLevelEnum, cpNormal, True)
    ], cpNormal, True, nil, 10)
  ]);

  wbRecord(DEBR, 'Debris', [
    wbEDID,
    wbRArray('Models', wbDebrisModel(wbMODT), cpNormal, True)
  ]);

  wbRecord(IMGS, 'Image Space', [
    wbEDID,
    wbStruct(ENAM, 'Data', [
      wbStruct('HDR', [
        wbFloat('Eye Adapt Speed'),
        wbFloat('Bloom Blur Radius'),
        wbFloat('Bloom Threshold'),
        wbFloat('Bloom Scale'),
        wbFloat('Receive Bloom Threshold'),
        wbFloat('Sunlight Scale'),
        wbFloat('Sky Scale')
      ]),
      wbStruct('Cinematic', [
        wbFloat('Saturation'),
        wbFloat('Brightness'),
        wbFloat('Contrast')
      ]),
      wbStruct('Tint', [
        wbFloat('Amount'),
        wbFloatColors
      ])
    ]),
    wbStruct(HNAM, 'HDR', [
      wbFloat('Eye Adapt Speed'),
      wbFloat('Bloom Blur Radius'),
      wbFloat('Bloom Threshold'),
      wbFloat('Bloom Scale'),
      wbFloat('Receive Bloom Threshold'),
      wbFloat('White'),
      wbFloat('Sunlight Scale'),
      wbFloat('Sky Scale'),
      wbFloat('Eye Adapt Strength')
    ]),
    wbStruct(CNAM, 'Cinematic', [
      wbFloat('Saturation'),
      wbFloat('Brightness'),
      wbFloat('Contrast')
    ]),
    wbStruct(TNAM, 'Tint', [
      wbFloat('Amount'),
      wbFloatColors
    ]),
    wbStruct(DNAM, 'Depth of Field', [
      wbFloat('Strength'),
      wbFloat('Distance'),
      wbFloat('Range'),
      wbUnused(2),
      wbInteger('Sky / Blur Radius', itU16, wbEnum([], [
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
      ]))
    ], cpNormal, False, nil, 3)
  ]);

  wbRecord(IMAD, 'Image Space Adapter', [
    wbEDID,
    wbStruct(DNAM, 'Data Count', [
      wbInteger('Animatable', itU32, wbBoolEnum),
      wbFloat('Duration'),
      wbStruct('HDR', [
        wbInteger('Eye Adapt Speed Mult', itU32),
        wbInteger('Eye Adapt Speed Add', itU32),
        wbInteger('Bloom Blur Radius Mult', itU32),
        wbInteger('Bloom Blur Radius Add', itU32),
        wbInteger('Bloom Threshold Mult', itU32),
        wbInteger('Bloom Threshold Add', itU32),
        wbInteger('Bloom Scale Mult', itU32),
        wbInteger('Bloom Scale Add', itU32),
        wbInteger('Target Lum Min Mult', itU32),
        wbInteger('Target Lum Min Add', itU32),
        wbInteger('Target Lum Max Mult', itU32),
        wbInteger('Target Lum Max Add', itU32),
        wbInteger('Sunlight Scale Mult', itU32),
        wbInteger('Sunlight Scale Add', itU32),
        wbInteger('Sky Scale Mult', itU32),
        wbInteger('Sky Scale Add', itU32)
      ]),
      wbInteger('Unknown08 Mult', itU32),
      wbInteger('Unknown48 Add', itU32),
      wbInteger('Unknown09 Mult', itU32),
      wbInteger('Unknown49 Add', itU32),
      wbInteger('Unknown0A Mult', itU32),
      wbInteger('Unknown4A Add', itU32),
      wbInteger('Unknown0B Mult', itU32),
      wbInteger('Unknown4B Add', itU32),
      wbInteger('Unknown0C Mult', itU32),
      wbInteger('Unknown4C Add', itU32),
      wbInteger('Unknown0D Mult', itU32),
      wbInteger('Unknown4D Add', itU32),
      wbInteger('Unknown0E Mult', itU32),
      wbInteger('Unknown4E Add', itU32),
      wbInteger('Unknown0F Mult', itU32),
      wbInteger('Unknown4F Add', itU32),
      wbInteger('Unknown10 Mult', itU32),
      wbInteger('Unknown50 Add', itU32),
      wbStruct('Cinematic', [
        wbInteger('Saturation Mult', itU32),
        wbInteger('Saturation Add', itU32),
        wbInteger('Brightness Mult', itU32),
        wbInteger('Brightness Add', itU32),
        wbInteger('Contrast Mult', itU32),
        wbInteger('Contrast Add', itU32)
      ]),
      wbInteger('Unknown14 Mult', itU32),
      wbInteger('Unknown54 Add', itU32),
      wbInteger('Tint Color', itU32),
      wbInteger('Blur Radius', itU32),
      wbInteger('Double Vision Strength', itU32),
      wbInteger('Radial Blur Strength', itU32),
      wbInteger('Radial Blur Ramp Up', itU32),
      wbInteger('Radial Blur Start', itU32),
      wbInteger('Radial Blur Flags', itU32, wbFlags(['Use Target'])),
      wbFloat('Radial Blur Center X'),
      wbFloat('Radial Blur Center Y'),
      wbInteger('DoF Strength', itU32),
      wbInteger('DoF Distance', itU32),
      wbInteger('DoF Range', itU32),
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
      wbInteger('Radial Blur Ramp Down', itU32),
      wbInteger('Radial Blur Down Start', itU32),
      wbInteger('Fade Color', itU32),
      wbInteger('Motion Blur Strength', itU32)
    ]),
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
    ]),
    wbRStruct('Depht of Field', [
      wbTimeInterpolators(WNAM, 'Strength'),
      wbTimeInterpolators(XNAM, 'Distance'),
      wbTimeInterpolators(YNAM, 'Range')
    ]),
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
    ]),
    wbTimeInterpolators(_08_IAD, 'Unused'),
    wbTimeInterpolators(_48_IAD, 'Unused'),
    wbTimeInterpolators(_09_IAD, 'Unused'),
    wbTimeInterpolators(_49_IAD, 'Unused'),
    wbTimeInterpolators(_0A_IAD, 'Unused'),
    wbTimeInterpolators(_4A_IAD, 'Unused'),
    wbTimeInterpolators(_0B_IAD, 'Unused'),
    wbTimeInterpolators(_4B_IAD, 'Unused'),
    wbTimeInterpolators(_0C_IAD, 'Unused'),
    wbTimeInterpolators(_4C_IAD, 'Unused'),
    wbTimeInterpolators(_0D_IAD, 'Unused'),
    wbTimeInterpolators(_4D_IAD, 'Unused'),
    wbTimeInterpolators(_0E_IAD, 'Unused'),
    wbTimeInterpolators(_4E_IAD, 'Unused'),
    wbTimeInterpolators(_0F_IAD, 'Unused'),
    wbTimeInterpolators(_4F_IAD, 'Unused'),
    wbTimeInterpolators(_10_IAD, 'Unused'),
    wbTimeInterpolators(_50_IAD, 'Unused'),
    wbCinematicIMAD
  ]);

  wbRecord(FLST, 'FormID List', [
    wbString(EDID, 'Editor ID', 0, cpBenign, True, nil, wbFLSTEDIDAfterSet),
    wbRArrayS('FormIDs', wbFormID(LNAM, 'FormID'), cpNormal, False, nil, nil, nil, wbFLSTLNAMIsSorted)
  ]);

  var wbPerkConditions :=
    wbRStructSK([0], 'Perk Condition', [
      wbInteger(PRKC, 'Run On (Tab Index)', itS8{, wbPRKCToStr, wbPRKCToInt}),
      wbConditions.SetRequired
    ], [], cpNormal, False{, nil, nil, wbPERKPRKCDontShow});

  var wbPerkEffect :=
    wbRStructSK([0, 1], 'Effect', [
      wbStructSK(PRKE, [1, 2, 0], 'Header', [
        wbPerkEffectType(wbPERKPRKETypeAfterSet),
        wbInteger('Rank', itU8),
        wbInteger('Priority', itU8)
      ]),
      wbUnion(DATA, 'Effect Data', wbPerkDATADecider, [
        wbStructSK([0, 1], 'Quest + Stage', [
          wbFormIDCk('Quest', [QUST]),
          wbInteger('Quest Stage', itU8, wbPerkDATAQuestStageToStr, wbQuestStageToInt),
          wbUnused(3)
        ]),
        wbFormIDCk('Ability', [SPEL]),
        wbStructSK([0, 1], 'Entry Point', [
          wbInteger('Entry Point', itU8, wbEntryPointsEnum, cpNormal, True, nil{, wbPERKEntryPointAfterSet}),
          wbInteger('Function', itU8, wbEnum([
            {0} 'Unknown 0',
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
           {15} 'Set Text' // EPFT=7
          ])),
          wbInteger('Perk Condition Tab Count', itU8, nil, cpIgnore)
        ])
      ], cpNormal, True),

      wbRArrayS('Perk Conditions', wbPerkConditions),

      wbRStruct('Function Parameters', [
        wbInteger(EPFT, 'Type', itU8, wbEnum([
          {0} 'None',
          {1} 'Float',
          {2} 'Float/AV,Float',
          {3} 'LVLI',
          {4} 'SPEL,lstring,flags',
          {5} 'SPEL',
          {6} 'string',
          {7} 'lstring'
        ])),
        // case(EPFT) of
        // 1: EPFD=float
        // 2: EPFD=float,float
        // 3: EPFD=LVLI
        // 4: EPFD=SPEL, EPF2=lstring, EPF3=int32 flags
        // 5: EPFD=SPEL
        // 6: EPFD=string
        // 7: EPFD=lstring
        wbLString(EPF2, 'Button Label', 0, cpTranslate),
        wbStruct(EPF3, 'Script Flags', [
          wbInteger('Script Flags', itU16, wbFlags([
            'Run Immediately',
            'Replace Default'
          ])),
          wbInteger('Fragment Index', itU16)
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
          {8} wbStruct('Actor Value, Float', [
                wbInteger('Actor Value', itU32, wbEPFDActorValueToStr, wbEPFDActorValueToInt),
                wbFloat('Float')
              ])
        ], cpNormal, False{, wbEPFDDontShow})
      ], [], cpNormal, False{, wbPERKPRKCDontShow}),
      wbEmpty(PRKF, 'End Marker', cpIgnore, True)
    ]);

  wbRecord(PERK, 'Perk',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbVMADFragmentedPERK,
    wbFULL,
    wbDESCReq,
    wbICON,
    wbConditions,
    wbStruct(DATA, 'Data', [
      wbInteger('Trait', itU8, wbBoolEnum),
      wbInteger('Level', itU8),
      wbInteger('Num Ranks', itU8),
      wbInteger('Playable', itU8, wbBoolEnum),
      wbInteger('Hidden', itU8, wbBoolEnum)
    ], cpNormal, True),
    wbFormIDCK(NNAM, 'Next Perk', [PERK, NULL]),
    wbRArrayS('Effects', wbPerkEffect)
  ]);

  wbRecord(BPTD, 'Body Part Data', [
    wbEDID,
    wbGenericModel,
    wbRArrayS('Body Parts',
      wbRStructSK([2], 'Body Part', [
        wbLString(BPTN, 'Part Name', 0, cpTranslate),
        wbString(PNAM, 'Pose Matching'),
        wbString(BPNN, 'Part Node').SetRequired,
        wbString(BPNT, 'VATS Target').SetRequired,
        wbString(BPNI, 'IK Data - Start Node').SetRequired,
        wbStruct(BPND, 'Node Data', [
          wbFloat('Damage Mult'),
          wbInteger('Flags', itU8,
            wbFlags([
              {0} 'Severable',
              {1} 'IK Data',
              {2} 'IK Data - Biped Data',
              {3} 'Explodable',
              {4} 'IK Data - Is Head',
              {5} 'IK Data - Headtracking',
              {6} 'To Hit Chance - Absolute'
            ])).IncludeFlag(dfCollapsed, wbCollapseFlags),
          wbInteger('Part Type', itU8,
            wbEnum([
              {0} 'Torso',
              {1} 'Head',
              {2} 'Eye',
              {3} 'LookAt',
              {4} 'Fly Grab',
              {5} 'Saddle'
            ])),
          wbInteger('Health Percent', itU8),
          wbInteger('Actor Value', itS8, wbActorValueEnum),
          wbInteger('To Hit Chance', itU8),
          wbInteger('Explodable - Explosion Chance %', itU8),
          wbInteger('Explodable - Debris Count', itU16),
          wbFormIDCk('Explodable - Debris', [DEBR, NULL]),
          wbFormIDCk('Explodable - Explosion', [EXPL, NULL]),
          wbFloat('Tracking Max Angle'),
          wbFloat('Explodable - Debris Scale'),
          wbInteger('Severable - Debris Count', itS32),
          wbFormIDCk('Severable - Debris', [DEBR, NULL]),
          wbFormIDCk('Severable - Explosion', [EXPL, NULL]),
          wbFloat('Severable - Debris Scale'),
          wbVec3PosRot('Gore Effects Positioning'),
          wbFormIDCk('Severable - Impact DataSet', [IPDS, NULL]),
          wbFormIDCk('Explodable - Impact DataSet', [IPDS, NULL]),
          wbInteger('Severable - Decal Count', itU8),
          wbInteger('Explodable - Decal Count', itU8),
          wbByteArray('Unknown', 2),
          wbFloat('Limb Replacement Scale')
        ]).SetRequired,
        wbString(NAM1, 'Limb Replacement Model').SetRequired,
        wbString(NAM4, 'Gore Effects - Target Bone').SetRequired,
        wbModelInfo(NAM5)
      ]).SetSummaryKey([2])
        .IncludeFlag(dfAllowAnyMember)
        .IncludeFlag(dfSummaryMembersNoName)
        .IncludeFlag(dfSummaryNoSortKey)
        .IncludeFlag(dfStructFirstNotRequired)
    ).SetRequired
  ]).SetSummaryKey([1])
    .IncludeFlag(dfSummaryMembersNoName);

  wbRecord(ADDN, 'Addon Node', [
    wbEDID,
    wbOBND(True),
    wbGenericModel,
    wbInteger(DATA, 'Node Index', itS32, nil, cpNormal, True),
    wbFormIDCk(SNAM, 'Sound', [SNDR, NULL]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Master Particle System Cap', itU16),
      wbInteger('Flags', itU16, wbEnum([], [
        {>>> Value Must be 1 or 3 <<<}
        1, 'Master Particle System',    // {0x0001}'Unknown 0', : The Check-Box is Unchecked in the CK
        3, 'Always Loaded' // {0x0002}'Always Loaded' : The Check-Box is Unchecked in the CK
      ]))
    ], cpNormal, True)
  ]).SetSummaryKey([2]);

  wbRecord(AVIF, 'Actor Value Information', [
    wbEDID,
    wbFULL,
    wbDESCReq,
    wbString(ICON, 'Image FileName'),
    wbString(ANAM, 'Abbreviation'),
    wbInteger(CNAM, 'Skill Category', itU32, wbEnum([
      'None',
      'Combat',
      'Magic',
      'Stealth'
    ])).SetAfterLoad(wbAVIFSkillAfterLoad),
    wbStruct(AVSK, 'Skill', [
      wbFloat('Skill Use Mult'),
      wbFloat('Skill Offset Mult'),
      wbFloat('Skill Improve Mult'),
      wbFloat('Skill Improve Offset')
    ]),
    wbRArray('Perk Tree',
      wbRStruct('Node', [
        wbFormIDCk(PNAM, 'Perk', [PERK, NULL], False, cpNormal, True),
        wbInteger(FNAM, 'Parent Required', itU32, wbBoolEnum, cpNormal, True)
          .SetDefaultNativeValue(1)
          .SetDontShow(function(const aElement: IwbElement): Boolean
            begin
              if not Assigned(aElement) then
                Exit(True);

              var lContainer := aElement.Container;
              // only worry about the root array node where the INAM index is 0 and the PNAM is NULL
              Result := (lContainer.Container.Elements[0].Equals(lContainer)) and (lContainer.ElementByPath['PNAM'].NativeValue = 0) and (lContainer.ElementByPath['INAM'].NativeValue = 0);
            end),
        wbInteger(XNAM, 'Perk-Grid X', itU32, nil, cpNormal, True),
        wbInteger(YNAM, 'Perk-Grid Y', itU32, nil, cpNormal, True),
        wbFloat(HNAM, 'Horizontal Position', cpNormal, True),
        wbFloat(VNAM, 'Vertical Position', cpNormal, True),
        wbFormIDCk(SNAM, 'Associated Skill', [AVIF, NULL], False, cpNormal, True),
        wbRArray('Connections', wbInteger(CNAM, 'Line to Index', itU32)),
        wbInteger(INAM, 'Index', itU32, nil, cpNormal, True)
      ])
    ).IncludeFlag(dfNoMove)
  ]);

  wbRecord(CAMS, 'Camera Shot', [
    wbEDID,
    wbGenericModel,
    wbStruct(DATA, 'Data', [
      {00} wbInteger('Action', itU32, wbEnum([
        'Shoot',
        'Fly',
        'Hit',
        'Zoom'
      ])),
      {04} wbInteger('Location', itU32, wbEnum([
        'Attacker',
        'Projectile',
        'Target',
        'Lead Actor'
      ])),
      {08} wbInteger('Target', itU32, wbEnum([
        'Attacker',
        'Projectile',
        'Target',
        'Lead Actor'
      ])),
      {12} wbInteger('Flags', itU32, wbFlags([
        'Position Follows Location',
        'Rotation Follows Target',
        'Don''t Follow Bone',
        'First Person Camera',
        'No Tracer',
        'Start At Time Zero'
      ])),
      wbStruct('Time Multipliers', [
        {16} wbFloat('Player'),
        {20} wbFloat('Target'),
        {24} wbFloat('Global')
      ]),
      {28} wbFloat('Max Time'),
      {32} wbFloat('Min Time'),
      {36} wbFloat('Target % Between Actors'),
      {40} wbFloat('Near Target Distance')
    ], cpNormal, True, nil, 8)
      .SetSummaryKeyOnValue([0, 1, 2])
      .SetSummaryPrefixSuffixOnValue(0, '', ',')
      .SetSummaryPrefixSuffixOnValue(1, '', ' ->')
      .IncludeFlagOnValue(dfSummaryMembersNoName),
    wbFormIDCk(MNAM, 'Image Space Modifier', [IMAD])
  ])
  .SetSummaryKey([1, 2])
  .SetSummaryMemberPrefixSuffix(2, '[', ']')
  .IncludeFlag(dfSummaryMembersNoName);

  wbRecord(CPTH, 'Camera Path', [
    wbEDID,
    wbConditions,
    wbStruct(ANAM, 'Camera Paths', [
      wbFormIDCk('Parent', [CPTH, NULL], False, cpBenign),
      wbFormIDCk('Previous', [CPTH, NULL], False, cpBenign)
    ]).SetRequired,
    wbInteger(DATA, 'Camera Zoom', itU8, wbEnum([], [
      0, 'Default, Must Have Camera Shots',
      1, 'Disable, Must Have Camera Shots',
      2, 'Shot List, Must Have Camera Shots',
      128, 'Default',
      129, 'Disable',
      130, 'Shot List'
    ]), cpNormal, True),
    wbRArray('Camera Shots', wbFormIDCk(SNAM, 'Camera Shot', [CAMS]))
  ]).SetSummaryKey([1, 4]).IncludeFlag(dfSummaryMembersNoName);

  wbRecord(VTYP, 'Voice Type', [
    wbEDID,
    wbInteger(DNAM, 'Flags', itU8, wbFlags([
      'Allow Default Dialog',
      'Female'
    ]), cpNormal, True)
  ]);

  wbRecord(MATT, 'Material Type', [
    wbEDID,
    wbFormIDCk(PNAM, 'Material Parent', [MATT, NULL]),
    wbString(MNAM, 'Material Name'),
    wbFloatColors(CNAM, 'Havok Display Color'),
    wbFloat(BNAM, 'Buoyancy'),
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      'Stair Material',
      'Arrows Stick'
    ], False)),
    wbFormIDCk(HNAM, 'Havok Impact Data Set', [IPDS, NULL])
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
    ], cpNormal, True, nil, 4),
    wbDODT,
    wbFormIDCk(DNAM, 'Texture Set', [TXST]),
    wbFormIDCk(ENAM, 'Secondary Texture Set', [TXST]),
    wbFormIDCk(SNAM, 'Sound 1', [SNDR, SOUN, NULL]),
    wbFormIDCk(NAM1, 'Sound 2', [SNDR, SOUN, NULL]),
    wbFormIDCk(NAM2, 'Hazard', [HAZD, NULL])
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
    wbUnion(DATA, '', wbFormVersionDecider(34), [
      wbStruct('', [
        wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
        wbFormIDCk('Location', [LCTN, NULL])
      ], cpNormal, True),
      wbStruct('', [
        wbFormIDCkNoReach('Owner', [NPC_, FACT, NULL]),
        wbFormIDCk('Location', [LCTN, NULL]),
        wbInteger('Rank', itS8),
        wbInteger('Min Level', itS8),
        wbInteger('Flags', itU8, wbFlags([
          'Never Resets',
          'Match PC Below Minimum Level',
          'Disable Combat Boundary'
        ])),
        wbInteger('Max Level', itS8)
      ], cpNormal, True)
    ])
  ]);

  wbRecord(LCTN, 'Location', [
    wbEDID,

    wbArrayS(ACPR,'Added Persist Location References', wbStructSK([0],'Reference', [
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('World/Cell', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ], cpBenign), 0, cpBenign),
    wbArrayS(LCPR,'Master Persist Location References', wbStructSK([0],'Reference', [
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('World/Cell', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ], cpBenign), 0, cpBenign),
    {>>> From Danwguard.esm, Does not follow similar previous patterns <<<}
    wbArrayS(RCPR,'Removed Persist Location References', wbFormIDCk('Reference', [ACHR, REFR], False, cpBenign), 0, cpBenign),

    wbArrayS(ACUN,'Added Unique NPCs', wbStructSK([1],'Actor', [
      wbFormIDCk('NPC', [NPC_], False, cpBenign),
      wbFormIDCk('Actor Ref', [ACHR], False, cpBenign),
      wbFormIDCk('Location', [LCTN, NULL], False, cpBenign)
    ], cpBenign), 0, cpBenign),
    wbArrayS(LCUN,'Master Unique NPCs', wbStructSK([1],'Actor', [
      wbFormIDCk('NPC', [NPC_], False, cpBenign),
      wbFormIDCk('Actor Ref', [ACHR], False, cpBenign),
      wbFormIDCk('Location', [LCTN, NULL], False, cpBenign)
    ], cpBenign), 0, cpBenign),
    {>>> in Unofficial Skyrim patch <<<}
    wbArrayS(RCUN, 'Removed Unique NPCs', wbFormIDCk('Actor', [NPC_], False, cpBenign), 0, cpBenign),

    wbArrayS(ACSR,'Added Special References', wbStructSK([1],'Reference', [
      wbFormIDCk('Loc Ref Type', [LCRT], False, cpBenign),
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('World/Cell', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ], cpBenign), 0, cpBenign),
    wbArrays(LCSR,'Master Special References', wbStructSK([1],'Reference', [
      wbFormIDCk('Loc Ref Type', [LCRT], False, cpBenign),
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('World/Cell', [WRLD, CELL], False, cpBenign),
      wbInteger('Grid Y', itS16, nil, cpBenign),
      wbInteger('Grid X', itS16, nil, cpBenign)
    ], cpBenign), 0, cpBenign),
    {>>> Seen in Open Cities <<<}
    wbArrayS(RCSR,'Removed Special References', wbFormIDCk('Reference', [ACHR, REFR], False, cpBenign), 0, cpBenign),

    wbRArrayS('Added Worldsapce Cells',
      wbStructSK(ACEC,[0], 'Worldspace', [
        wbFormIDCk('World', [WRLD], False, cpBenign),
        wbArrayS('Cells', wbStructSK([0,1],'Coords', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]), 0, cpBenign)
      ], cpBenign)
    , cpBenign),
    wbRArrayS('Master Worldspace Cells',
      wbStructSK(LCEC,[0],'Worldspace', [
        wbFormIDCk('World', [WRLD], False, cpBenign),
        wbArrayS('Cells', wbStructSK([0,1],'Coords', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]), 0, cpBenign)
      ], cpBenign)
    , cpBenign),
    {>>> Seen in Open Cities <<<}
    wbRArrayS('Removed Worldspace Cells',
      wbStructSK(RCEC,[0], 'Worldspace', [
        wbFormIDCk('World', [WRLD], False, cpBenign),
        wbArrayS('Cells', wbStructSK([0,1],'Coords', [
          wbInteger('Grid Y', itS16, nil, cpBenign),
          wbInteger('Grid X', itS16, nil, cpBenign)
        ]), 0, cpBenign)
      ], cpBenign)
    , cpBenign),

    wbArrayS(ACID,'Added Initially Disabled References', wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign), 0, cpBenign),
    wbArrayS(LCID,'Master Initially Disabled References', wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign), 0, cpBenign),

    wbArrayS(ACEP,'Added Enable Point References', wbStructSK([0],'Reference', [
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('Enable Parent', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbInteger('Flags', itU8, wbFlags([
      'Set Enable State to Opposite of Parent',
      'Pop In'
    ]), cpBenign),
    wbUnused(3)
    ]), 0, cpBenign),
    wbArrayS(LCEP,'Master Enable Parent References', wbStructSK([0],'Reference', [
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbFormIDCk('Enable Parent', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], False, cpBenign),
      wbInteger('Flags', itU8, wbFlags([
      'Set Enable State to Opposite of Parent',
      'Pop In'
    ]), cpBenign),
    wbUnused(3)
    ]), 0, cpBenign),

    wbFULL,
    wbKeywords,
    wbFormIDCk(PNAM, 'Parent Location', [LCTN, NULL]),
    wbFormIDCk(NAM1, 'Music', [MUSC, NULL]),
    wbFormIDCk(FNAM, 'Unreported Crime Faction', [FACT]),
    wbFormIDCk(MNAM, 'World Location Marker Ref', [REFR, ACHR]),
    wbFloat(RNAM, 'World Location Radius'),
    wbFormIDCk(NAM0, 'Horse Marker Ref', [REFR]),
    wbCNAM
  ]);

  // load map markes list from external file if present
  s := ExtractFilePath(ParamStr(0)) + wbAppName + 'MapMarkers.txt';
  if FileExists(s) then try
    wbMapMarkerEnum := wbEnum(TFile.ReadAllLines(s));
  except end;

  if not Assigned(wbMapMarkerEnum) then
    wbMapMarkerEnum := wbEnum([
      { 0} 'None',
      { 1} 'City',
      { 2} 'Town',
      { 3} 'Settlement',
      { 4} 'Cave',
      { 5} 'Camp',
      { 6} 'Fort',
      { 7} 'Nordic Ruins',
      { 8} 'Dwemer Ruin',
      { 9} 'Shipwreck',
      {10} 'Grove',
      {11} 'Landmark',
      {12} 'Dragon Lair',
      {13} 'Farm',
      {14} 'Wood Mill',
      {15} 'Mine',
      {16} 'Imperial Camp',
      {17} 'Stormcloak Camp',
      {18} 'Doomstone',
      {19} 'Wheat Mill',
      {20} 'Smelter',
      {21} 'Stable',
      {22} 'Imperial Tower',
      {23} 'Clearing',
      {24} 'Pass',
      {25} 'Altar',
      {26} 'Rock',
      {27} 'Lighthouse',
      {28} 'Orc Stronghold',
      {29} 'Giant Camp',
      {30} 'Shack',
      {31} 'Nordic Tower',
      {32} 'Nordic Dwelling',
      {33} 'Docks',
      {34} 'Shrine',
      {35} 'Riften Castle',
      {36} 'Riften Capitol',
      {37} 'Windhelm Castle',
      {38} 'Windhelm Capitol',
      {39} 'Whiterun Castle',
      {40} 'Whiterun Capitol',
      {41} 'Solitude Castle',
      {42} 'Solitude Capitol',
      {43} 'Markarth Castle',
      {44} 'Markarth Capitol',
      {45} 'Winterhold Castle',
      {46} 'Winterhold Capitol',
      {47} 'Morthal Castle',
      {48} 'Morthal Capitol',
      {49} 'Falkreath Castle',
      {50} 'Falkreath Capitol',
      {51} 'Dawnstar Castle',
      {52} 'Dawnstar Capitol',
      {53} 'DLC02 - Temple of Miraak',
      {54} 'DLC02 - Raven Rock',
      {55} 'DLC02 - Beast Stone',
      {56} 'DLC02 - Tel Mithryn',
      {57} 'DLC02 - To Skyrim',
      {58} 'DLC02 - To Solstheim',
      {59} 'DLC02 - Castle Karstaag'
    ]);

  // load quest types list from external file if present
  s := ExtractFilePath(ParamStr(0)) + wbAppName + 'QuestTypes.txt';
  if FileExists(s) then try
    wbQuestTypeEnum := wbEnum(TFile.ReadAllLines(s));
  except end;

  if not Assigned(wbQuestTypeEnum) then
    wbQuestTypeEnum := wbEnum([
      {0} 'None',
      {1} 'Main Quest',
      {2} 'Mages'' Guild',
      {3} 'Thieves'' Guild',
      {4} 'Dark Brotherhood',
      {5} 'Companion Quests',
      {6} 'Miscellaneous',
      {7} 'Daedric',
      {8} 'Side Quest',
      {9} 'Civil War',
     {10} 'DLC01 - Vampire',
     {11} 'DLC02 - Dragonborn'
    ]);

  wbMenuButton :=
    wbRStruct('Menu Button', [
      wbLString(ITXT, 'Button Text', 0, cpTranslate),
      wbConditions
    ]);

  wbRecord(MESG, 'Message', [
    wbEDID,
    wbDESCReq,
    wbFULL,
    wbFormIDCk(INAM, 'Icon (unused)', [NULL], False, cpIgnore, True), // leftover
    wbFormIDCk(QNAM, 'Owner Quest', [QUST]),
    wbInteger(DNAM, 'Flags', itU32, wbFlags([
      'Message Box',
      'Auto Display'
    ]), cpNormal, True, False, nil, wbMESGDNAMAfterSet),
    wbInteger(TNAM, 'Display Time', itU32, nil, cpNormal, False, False, wbMESGTNAMDontShow),
    wbRArray('Menu Buttons', wbMenuButton)
  ], False, nil, cpNormal, False, wbMESGAfterLoad);

  a := MakeVarRecs([
                  0, 'None',
    Sig2Int('RADA'), 'RADA (Unused)',
    Sig2Int('MORP'), 'MORP (Unused)',
    Sig2Int('PPAR'), 'PPAR (Unused)',
    Sig2Int('MYSN'), 'MYSN (Unused)',
    Sig2Int('MYSF'), 'MYSF (Unused)',
    Sig2Int('WWSP'), 'Werewolf Spell',
    Sig2Int('SALT'), 'Sitting Angle Limit',
    Sig2Int('APSH'), 'Allow Player Shout',
    Sig2Int('GOLD'), 'Gold',
    Sig2Int('LKPK'), 'Lockpick',
    Sig2Int('SKLK'), 'SkeletonKey',
    Sig2Int('PFAC'), 'Player Faction',
    Sig2Int('GFAC'), 'Guard Faction',
    Sig2Int('DFMS'), 'Default Music',
    Sig2Int('BTMS'), 'Battle Music',
    Sig2Int('DTMS'), 'Death Music',
    Sig2Int('SCMS'), 'Success Music',
    Sig2Int('LUMS'), 'Level Up Music',
    Sig2Int('DCMS'), 'Dungeon Cleared Music',
    Sig2Int('PVMA'), 'Player Voice (Male)',
    Sig2Int('PVMC'), 'Player Voice (Male Child)',
    Sig2Int('PVFA'), 'Player Voice (Female)',
    Sig2Int('PVFC'), 'Player Voice (Female Child)',
    Sig2Int('EPDF'), 'Eat Package Default Food',
    Sig2Int('LHEQ'), 'LeftHand Equip',
    Sig2Int('RHEQ'), 'RightHand Equip',
    Sig2Int('EHEQ'), 'EitherHand Equip',
    Sig2Int('VOEQ'), 'Voice Equip',
    Sig2Int('POEQ'), 'Potion Equip',
    Sig2Int('EACA'), 'Every Actor Ability',
    Sig2Int('CACA'), 'Commanded Actor Ability',
    Sig2Int('DEIS'), 'Drug Wears Off Image Space',
    Sig2Int('DFTS'), 'Footstep Set',
    Sig2Int('DLMT'), 'Landscape Material',
    Sig2Int('DLZM'), 'Dragon Land Zone Marker',
    Sig2Int('DCZM'), 'Dragon Crash Zone Marker',
    Sig2Int('CSTY'), 'Combat Style',
    Sig2Int('PLST'), 'Default Pack List',
    Sig2Int('PWFD'), 'Wait-For-Dialogue Package',
    Sig2Int('LRTB'), 'LocRefType Boss',
    Sig2Int('VLOC'), 'Virtual Location',
    Sig2Int('PLOC'), 'PersistAll Location',
    Sig2Int('INVP'), 'Inventory Player',
    Sig2Int('PTNP'), 'Pathing Test NPC',
    Sig2Int('FPCS'), 'Favor Cost Small',
    Sig2Int('FPCM'), 'Favor Cost Medium',
    Sig2Int('FPCL'), 'Favor Cost Large',
    Sig2Int('FGPD'), 'Favor Gifts Per Day',
    Sig2Int('AASW'), 'Action Swim State Change',
    Sig2Int('AALK'), 'Action Look',
    Sig2Int('AALA'), 'Action LeftAttack',
    Sig2Int('AALD'), 'Action LeftReady',
    Sig2Int('AALR'), 'Action LeftRelease',
    Sig2Int('AALI'), 'Action LeftInterrupt',
    Sig2Int('AARA'), 'Action RightAttack',
    Sig2Int('AARD'), 'Action RightReady',
    Sig2Int('AARR'), 'Action RightRelease',
    Sig2Int('AARI'), 'Action RightInterrupt',
    Sig2Int('AADA'), 'Action DualAttack',
    Sig2Int('AADL'), 'Action DualRelease',
    Sig2Int('AAAC'), 'Action Activate',
    Sig2Int('AAJP'), 'Action Jump',
    Sig2Int('AAFA'), 'Action Fall',
    Sig2Int('AALN'), 'Action Land',
    Sig2Int('AASN'), 'Action Sneak',
    Sig2Int('AAVC'), 'Action Voice',
    Sig2Int('AAVD'), 'Action VoiceReady',
    Sig2Int('AAVR'), 'Action VoiceRelease',
    Sig2Int('AAVI'), 'Action VoiceInterrupt',
    Sig2Int('AAID'), 'Action Idle',
    Sig2Int('AAST'), 'Action Sprint Start',
    Sig2Int('AASP'), 'Action Sprint Stop',
    Sig2Int('AADR'), 'Action Draw',
    Sig2Int('AASH'), 'Action Sheath',
    Sig2Int('ALPA'), 'Action Left Power Attack',
    Sig2Int('AAPA'), 'Action Right Power Attack',
    Sig2Int('ADPA'), 'Action Dual Power Attack',
    Sig2Int('AAS1'), 'Action Stagger Start',
    Sig2Int('AABH'), 'Action Block Hit',
    Sig2Int('AABA'), 'Action Block Anticipate',
    Sig2Int('AARC'), 'Action Recoil',
    Sig2Int('AAR2'), 'Action Large Recoil',
    Sig2Int('AAB1'), 'Action Bleedout Start',
    Sig2Int('AAB2'), 'Action Bleedout Stop',
    Sig2Int('AAIS'), 'Action Idle Stop',
    Sig2Int('AAWH'), 'Action Ward Hit',
    Sig2Int('AAFQ'), 'Action Force Equip',
    Sig2Int('AASC'), 'Action Shield Change',
    Sig2Int('AAPS'), 'Action Path Start',
    Sig2Int('AAPE'), 'Action Path End',
    Sig2Int('AALM'), 'Action Large Movement Delta',
    Sig2Int('AAF1'), 'Action Fly Start',
    Sig2Int('AAF2'), 'Action Fly Stop',
    Sig2Int('AAH1'), 'Action Hover Start',
    Sig2Int('AAH2'), 'Action Hover Stop',
    Sig2Int('AABI'), 'Action Bumped Into',
    Sig2Int('AASS'), 'Action Summoned Start',
    Sig2Int('ATKI'), 'Action Talking Idle',
    Sig2Int('ALTI'), 'Action Listen Idle',
    Sig2Int('AADE'), 'Action Death',
    Sig2Int('AADW'), 'Action Death Wait',
    Sig2Int('AIDW'), 'Action Idle Warn',
    Sig2Int('AMST'), 'Action Move Start',
    Sig2Int('AMSP'), 'Action Move Stop',
    Sig2Int('ATRI'), 'Action Turn Right',
    Sig2Int('ATLE'), 'Action Turn Left',
    Sig2Int('ATSP'), 'Action Turn Stop',
    Sig2Int('AMFD'), 'Action Move Forward',
    Sig2Int('AMBK'), 'Action Move Backward',
    Sig2Int('AMLT'), 'Action Move Left',
    Sig2Int('AMRT'), 'Action Move Right',
    Sig2Int('ARAG'), 'Action Reset Animation Graph',
    Sig2Int('AKDN'), 'Action Knockdown',
    Sig2Int('AAGU'), 'Action Get Up',
    Sig2Int('ASID'), 'Action Idle Stop Instant',
    Sig2Int('ARGI'), 'Action Ragdoll Instant',
    Sig2Int('AWWS'), 'Action Waterwalk Start',
    Sig2Int('AREL'), 'Action Reload',
    Sig2Int('PUSG'), 'Pickup Sound Generic',
    Sig2Int('PDSG'), 'Putdown Sound Generic',
    Sig2Int('PUSW'), 'Pickup Sound Weapon',
    Sig2Int('PDSW'), 'Putdown Sound Weapon',
    Sig2Int('PUSA'), 'Pickup Sound Armor',
    Sig2Int('PDSA'), 'Putdown Sound Armor',
    Sig2Int('PUSB'), 'Pickup Sound Book',
    Sig2Int('PDSB'), 'Putdown Sound Book',
    Sig2Int('PUSI'), 'Pickup Sound Ingredient',
    Sig2Int('PDSI'), 'Putdown Sound Ingredient',
    Sig2Int('HVSS'), 'Harvest Sound',
    Sig2Int('HVFS'), 'Harvest Failed Sound',
    Sig2Int('WBSN'), 'Ward Break Sound',
    Sig2Int('WASN'), 'Ward Absorb Sound',
    Sig2Int('WDSN'), 'Ward Deflect Sound',
    Sig2Int('MFSN'), 'Magic Fail Sound',
    Sig2Int('SFSN'), 'Shout Fail Sound',
    Sig2Int('HFSD'), 'Heartbeat Sound Fast',
    Sig2Int('HSSD'), 'Heartbeat Sound Slow',
    Sig2Int('IMLH'), 'Imagespace: Low Health',
    Sig2Int('SCSD'), 'Soul Captured Sound',
    Sig2Int('NASD'), 'No-Activation Sound',
    Sig2Int('MMSD'), 'Map Menu Looping Sound',
    Sig2Int('DDSC'), 'Dialogue Voice Category',
    Sig2Int('NDSC'), 'Non-Dialogue Voice Category',
    Sig2Int('SFDC'), 'SFX To Fade In Dialogue Category',
    Sig2Int('PDMC'), 'Pause During Menu Category (Fade)',
    Sig2Int('PIMC'), 'Pause During Menu Category (Immediate)',
    Sig2Int('PDLC'), 'Pause During Loading Menu Category',
    Sig2Int('MDSC'), 'Music Sound Category',
    Sig2Int('SMSC'), 'Stats Mute Category',
    Sig2Int('SSSC'), 'Stats Music',
    Sig2Int('MTSC'), 'Master Sound Category',
    Sig2Int('TSSC'), 'Time Sensitive Sound Category',
    Sig2Int('DOP2'), 'Dialogue Output Model (3D)',
    Sig2Int('DOP3'), 'Dialogue Output Model (2D)',
    Sig2Int('POPM'), 'Player''s Output Model (1st Person)',
    Sig2Int('P3OM'), 'Player''s Output Model (3rd Person)',
    Sig2Int('IOPM'), 'Interface Output Model',
    Sig2Int('RVBT'), 'Reverb Type',
    Sig2Int('UWLS'), 'Underwater Loop Sound',
    Sig2Int('URVT'), 'Underwater Reverb Type',
    Sig2Int('HRSK'), 'Keyword - Horse',
    Sig2Int('UNDK'), 'Keyword - Undead',
    Sig2Int('NPCK'), 'Keyword - NPC',
    Sig2Int('KWBR'), 'Keyword - BeastRace',
    Sig2Int('KWDM'), 'Keyword - DummyObject',
    Sig2Int('KWGE'), 'Keyword - UseGeometryEmitter',
    Sig2Int('KWMS'), 'Keyword - MustStop',
    Sig2Int('KWUA'), 'Keyword - UpdateDuringArchery',
    Sig2Int('KWOT'), 'Keyword - Skip Outfit Items',
    Sig2Int('FTHD'), 'Male Face Texture Set: Head',
    Sig2Int('FTMO'), 'Male Face Texture Set: Mouth',
    Sig2Int('FTEL'), 'Male Face Texture Set: Eyes',
    Sig2Int('FTHF'), 'Female Face Texture Set: Head',
    Sig2Int('FTMF'), 'Female Face Texture Set: Mouth',
    Sig2Int('FTRF'), 'Female Face Texture Set: Eyes',
    Sig2Int('IMID'), 'ImageSpaceModifier for inventory menu.',
    Sig2Int('PTEM'), 'Package template',
    Sig2Int('MMCL'), 'Main Menu Cell',
    Sig2Int('DMWL'), 'Default MovementType: Walk',
    Sig2Int('DMRN'), 'Default MovementType: Run',
    Sig2Int('DMSW'), 'Default MovementType: Swim',
    Sig2Int('DMFL'), 'Default MovementType: Fly',
    Sig2Int('DMSN'), 'Default MovementType: Sneak',
    Sig2Int('DMSP'), 'Default MovementType: Sprint',
    Sig2Int('SPFK'), 'Keyword - Special Furniture',
    Sig2Int('FFFP'), 'Keyword - Furniture Forces 1st Person',
    Sig2Int('FFTP'), 'Keyword - Furniture Forces 3rd Person',
    Sig2Int('AFNP'), 'Keyword - Activator Furniture No Player',
    Sig2Int('TKGS'), 'Telekinesis Grab Sound',
    Sig2Int('TKTS'), 'Telekinesis Throw Sound',
    Sig2Int('WMWE'), 'World Map Weather',
    Sig2Int('HMPC'), 'Help Manual PC',
    Sig2Int('HMXB'), 'Help Manual XBox',
    Sig2Int('TKAM'), 'Keyword - Type Ammo',
    Sig2Int('TKAR'), 'Keyword - Type Armor',
    Sig2Int('TKBK'), 'Keyword - Type Book',
    Sig2Int('TKIG'), 'Keyword - Type Ingredient',
    Sig2Int('TKKY'), 'Keyword - Type Key',
    Sig2Int('TKMS'), 'Keyword - Type Misc',
    Sig2Int('TKSG'), 'Keyword - Type SoulGem',
    Sig2Int('TKWP'), 'Keyword - Type Weapon',
    Sig2Int('TKPT'), 'Keyword - Type Potion',
    Sig2Int('BENW'), 'Base Weapon Enchantment',
    Sig2Int('BENA'), 'Base Armor Enchantment',
    Sig2Int('BAPO'), 'Base Potion',
    Sig2Int('BAPS'), 'Base Poison',
    Sig2Int('DRAK'), 'Keyword - Dragon',
    Sig2Int('MVBL'), 'Keyword - Movable',
    Sig2Int('ABSE'), 'Art Object - Absorb Effect',
    Sig2Int('WEML'), 'Weapon Material List',
    Sig2Int('ARTL'), 'Armor Material List',
    Sig2Int('DIEN'), 'Keyword - Disallow Enchanting',
    Sig2Int('FTML'), 'Favor travel marker location',
    Sig2Int('LKHO'), 'Keyword - Hold Location',
    Sig2Int('CWOK'), 'Keyword - Civil War Owner',
    Sig2Int('CWNE'), 'Keyword - Civil War Neutral',
    Sig2Int('LRSO'), 'LocRefType - Civil War Soldier',
    Sig2Int('KWDO'), 'Keyword - ClearableLocation',
    Sig2Int('LRRD'), 'LocRefType - Resource Destructible',
    Sig2Int('HCLL'), 'FormList - Hair Color List',
    Sig2Int('CMPX'), 'Complex Scene Object',
    Sig2Int('RUSG'), 'Keyword - Reusable SoulGem',
    Sig2Int('ANML'), 'Keyword - Animal',
    Sig2Int('DAED'), 'Keyword - Daedra'
  ]);

  b := MakeVarRecs([
    Sig2Int('BEEP'), 'Keyword - Robot',
    Sig2Int('NRNT'), 'Keyword - Nirnroot',
    Sig2Int('FTGF'), 'Fighters'' Guild Faction',
    Sig2Int('MGGF'), 'Mages'' Guild Faction',
    Sig2Int('TVGF'), 'Thieves'' Guild Faction',
    Sig2Int('DBHF'), 'Dark Brotherhood Faction',
    Sig2Int('JRLF'), 'Jarl Faction',
    Sig2Int('AWWW'), 'Bunny Faction',
    Sig2Int('PIVV'), 'Player Is Vampire Variable',
    Sig2Int('PIWV'), 'Player Is Werewolf Variable',
    Sig2Int('NMRD'), 'Road Marker',
    Sig2Int('SAT1'), 'Keyword: Scale Actor To 1.0',
    Sig2Int('VAMP'), 'Keyword: Vampire',
    Sig2Int('FORG'), 'Keyword: Forge',
    Sig2Int('COOK'), 'Keyword: Cooking Pot',
    Sig2Int('SMLT'), 'Keyword: Smelter',
    Sig2Int('TANN'), 'Keyword: Tanning Rack',
    Sig2Int('HBLK'), 'Help - Basic Lockpicking (PC)',
    Sig2Int('HBLX'), 'Help - Basic Lockpicking (Console)',
    Sig2Int('HBFG'), 'Help - Basic Forging',
    Sig2Int('HBCO'), 'Help - Basic Cooking',
    Sig2Int('HBML'), 'Help - Basic Smelting',
    Sig2Int('HBTA'), 'Help - Basic Tanning',
    Sig2Int('HBOC'), 'Help - Basic Object Creation',
    Sig2Int('HBEC'), 'Help - Basic Enchanting',
    Sig2Int('HBSM'), 'Help - Basic Smithing Weapon',
    Sig2Int('HBSA'), 'Help - Basic Smithing Armor',
    Sig2Int('HBAL'), 'Help - Basic Alchemy',
    Sig2Int('HBBR'), 'Help - Barter',
    Sig2Int('HBLU'), 'Help - Leveling up',
    Sig2Int('HBSK'), 'Help - Skills Menu',
    Sig2Int('HBMM'), 'Help - Map Menu',
    Sig2Int('HBJL'), 'Help - Journal',
    Sig2Int('HBLH'), 'Help - Low Health',
    Sig2Int('HBLM'), 'Help - Low Magicka',
    Sig2Int('HBLS'), 'Help - Low Stamina',
    Sig2Int('HBHJ'), 'Help - Jail',
    Sig2Int('HBFT'), 'Help - Teammate Favor',
    Sig2Int('HBWC'), 'Help - Weapon Charge',
    Sig2Int('HBFS'), 'Help - Favorites',
    Sig2Int('KHFL'), 'Kinect Help FormList',
    Sig2Int('HBFM'), 'Help - Flying Mount',
    Sig2Int('HBTL'), 'Help - Target Lock',
    Sig2Int('HBAT'), 'Help - Attack Target',
    Sig2Int('MHFL'), 'Help - Mods',
    Sig2Int('HMCC'), 'Help - Installed Content',
    Sig2Int('HMAE'), 'Help - Installed Content (AE)',
    Sig2Int('LSIS'), 'Imagespace: Load screen',
    Sig2Int('WMDA'), 'Keyword - Weapon Material Daedric',
    Sig2Int('WMDR'), 'Keyword - Weapon Material Draugr',
    Sig2Int('WMDH'), 'Keyword - Weapon Material DraugrHoned',
    Sig2Int('WMDW'), 'Keyword - Weapon Material Dwarven',
    Sig2Int('WMEB'), 'Keyword - Weapon Material Ebony',
    Sig2Int('WMEL'), 'Keyword - Weapon Material Elven',
    Sig2Int('WMFA'), 'Keyword - Weapon Material Falmer',
    Sig2Int('WMFH'), 'Keyword - Weapon Material FalmerHoned',
    Sig2Int('WMGL'), 'Keyword - Weapon Material Glass',
    Sig2Int('WMIM'), 'Keyword - Weapon Material Imperial',
    Sig2Int('WMIR'), 'Keyword - Weapon Material Iron',
    Sig2Int('WMOR'), 'Keyword - Weapon Material Orcish',
    Sig2Int('WMST'), 'Keyword - Weapon Material Steel',
    Sig2Int('WMWO'), 'Keyword - Weapon Material Wood',
    Sig2Int('WTBA'), 'Keyword - WeaponTypeBoundArrow',
    Sig2Int('AODA'), 'Keyword - Armor Material Daedric',
    Sig2Int('AODP'), 'Keyword - Armor Material Dragonplate',
    Sig2Int('AODS'), 'Keyword - Armor Material Dragonscale',
    Sig2Int('AODB'), 'Keyword - Armor Material Dragonbone',
    Sig2Int('AODW'), 'Keyword - Armor Material Dwarven',
    Sig2Int('AOEB'), 'Keyword - Armor Material Ebony',
    Sig2Int('AOEL'), 'Keyword - Armor Material Elven',
    Sig2Int('AOES'), 'Keyword - Armor Material ElvenSplinted',
    Sig2Int('AOFL'), 'Keyword - Armor Material FullLeather',
    Sig2Int('AOGL'), 'Keyword - Armor Material Glass',
    Sig2Int('AOHI'), 'Keyword - Armor Material Hide',
    Sig2Int('AOIM'), 'Keyword - Armor Material Imperial',
    Sig2Int('AOIH'), 'Keyword - Armor Material ImperialHeavy',
    Sig2Int('AOIR'), 'Keyword - Armor Material ImperialReinforced',
    Sig2Int('AOFE'), 'Keyword - Armor Material Iron',
    Sig2Int('AOIB'), 'Keyword - Armor Material IronBanded',
    Sig2Int('AOOR'), 'Keyword - Armor Material Orcish',
    Sig2Int('AOSC'), 'Keyword - Armor Material Scaled',
    Sig2Int('AOST'), 'Keyword - Armor Material Steel',
    Sig2Int('AOSP'), 'Keyword - Armor Material SteelPlate',
    Sig2Int('AOSK'), 'Keyword - Armor Material Stormcloak',
    Sig2Int('AOSD'), 'Keyword - Armor Material Studded',
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
    Sig2Int('JWLR'), 'Keyword - Jewelry',
    Sig2Int('KWCU'), 'Keyword - Cuirass',
    Sig2Int('MNTK'), 'Keyword - Mount',
    Sig2Int('LMHP'), 'Local Map Hide Plane',
    Sig2Int('SLDM'), 'Snow LOD Material',
    Sig2Int('SLHD'), 'Snow LOD Material (HD)',
    Sig2Int('ALDM'), 'Ash LOD Material',
    Sig2Int('ALHD'), 'Ash LOD Material (HD)',
    Sig2Int('DGFL'), 'DialogueFollower Quest',
    Sig2Int('PTFR'), 'PotentialFollower Faction',
    Sig2Int('AVWP'), 'Werewolf Available Perks',
    Sig2Int('AVVP'), 'Vampire Available Perks',
    Sig2Int('RIWR'), 'Werewolf Race',
    Sig2Int('RIVR'), 'Vampire Race',
    Sig2Int('RIVS'), 'Vampire Spells',
    Sig2Int('DMXL'), 'Dragon Mount No Land List',
    Sig2Int('PCMD'), 'Player Can Mount Dragon Here List',
    Sig2Int('FMYS'), 'Flying Mount - Allowed Spells',
    Sig2Int('FMNS'), 'Flying Mount - Disallowed Spells',
    Sig2Int('MNT2'), 'Keyword - Mount',
    Sig2Int('AIVC'), 'Verlet Cape',
    Sig2Int('FTNP'), 'Furniture Test NPC',
    Sig2Int('COEX'), 'Keyword - Conditional Explosion',
    Sig2Int('VFNC'), 'Vampire Feed No Crime Faction',
    Sig2Int('KWSP'), 'Skyrim - Worldspace',
    Sig2Int('ALBM'), 'Keyword - Armor Material Light Bonemold',
    Sig2Int('ALCH'), 'Keyword - Armor Material Light Chitin',
    Sig2Int('ALNC'), 'Keyword - Armor Material Light Nordic',
    Sig2Int('ALSM'), 'Keyword - Armor Material Light Stalhrim',
    Sig2Int('FMFF'), 'Flying Mount - Fly Fast Worldspaces',
    Sig2Int('AHBM'), 'Keyword - Armor Material Heavy Bonemold',
    Sig2Int('AHCH'), 'Keyword - Armor Material Heavy Chitin',
    Sig2Int('AHNC'), 'Keyword - Armor Material Heavy Nordic',
    Sig2Int('AHSM'), 'Keyword - Armor Material Heavy Stalhrim',
    Sig2Int('WPNC'), 'Keyword - Weapon Material Nordic',
    Sig2Int('WPSM'), 'Keyword - Weapon Material Stalhrim',
    Sig2Int('SKAB'), 'Survival - Keyword Armor Body',
    Sig2Int('SKAF'), 'Survival - Keyword Armor Feet',
    Sig2Int('SKAH'), 'Survival - Keyword Armor Hands',
    Sig2Int('SKAO'), 'Survival - Keyword Armor Head',
    Sig2Int('SKCB'), 'Survival - Keyword Clothing Body',
    Sig2Int('SKCD'), 'Survival - Keyword Cold',
    Sig2Int('SKCF'), 'Survival - Keyword Clothing Feet',
    Sig2Int('SKCH'), 'Survival - Keyword Clothing Hands',
    Sig2Int('SKCO'), 'Survival - Keyword Clothing Head',
    Sig2Int('SKWM'), 'Survival - Keyword Warm',
    Sig2Int('SRCP'), 'Survival - Cold Penalty',
    Sig2Int('SRHP'), 'Survival - Hunger Penalty',
    Sig2Int('SRSP'), 'Survival - Sleep Penalty',
    Sig2Int('SRTP'), 'Survival - Temperature',
    Sig2Int('SRVE'), 'Survival Mode Enabled',
    Sig2Int('SRVS'), 'Survival Mode - Show Option',
    Sig2Int('SRVT'), 'Survival Mode - Toggle'
  ]);

  c := CombineVarRecs(a, b);

  if wbGameMode = gmTES5VR then begin
    b := MakeVarRecs([
      Sig2Int('FIJC'), 'FIJC',
      Sig2Int('HMMC'), 'HMMC',
      Sig2Int('FISC'), 'FISC',
      Sig2Int('FASF'), 'FASF',
      Sig2Int('HBVM'), 'HBVM',
      Sig2Int('HSVM'), 'HSVM',
      Sig2Int('VRPR'), 'VRPR',
      Sig2Int('VRRR'), 'VRRR',
      Sig2Int('CBTR'), 'CBTR',
      Sig2Int('PSIS'), 'PSIS',
      Sig2Int('VRWS'), 'VRWS',
      Sig2Int('CBIT'), 'CBIT',
      Sig2Int('FSIT'), 'FSIT',
      Sig2Int('CBLT'), 'CBLT',
      Sig2Int('CBST'), 'CBST',
      Sig2Int('CBTT'), 'CBTT',
      Sig2Int('HTLV'), 'HTLV',
      Sig2Int('HFMV'), 'HFMV',
      Sig2Int('HMOV'), 'HMOV',
      Sig2Int('HATV'), 'HATV'
    ]);

    c := CombineVarRecs(c, b);
  end;


  wbRecord(DOBJ, 'Default Object Manager', [
    wbEDID,
    wbArrayS(DNAM, 'Objects',
      wbStructSK([0], 'Object', [
        wbInteger('Use', itU32, wbEnum([], c), cpNormalIgnoreEmpty),
        wbFormID('Object ID', cpNormalIgnoreEmpty)
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
      wbFloat('Fog Clip Dist'),
      wbFloat('Fog Power'),
      wbUnused(32), // WindhelmLightingTemplate [LGTM:0007BA87] only find 24 !
      wbFromVersion(34, wbByteColors('Fog Color Far')),
      wbFromVersion(34, wbFloat('Fog Max')),
      wbFromVersion(34, wbStruct('Light Fade Distances', [
        wbFloat('Start'),
        wbFloat('End')
      ])),
      wbFromVersion(34, wbUnused(4))
    ]).SetRequired,
    wbAmbientColors(DALC)
  ]);

  wbRecord(MUSC, 'Music Type', [
    wbEDID,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      {0x01} 'Plays One Selection',
      {0x02} 'Abrupt Transition',
      {0x04} 'Cycle Tracks',
      {0x08} 'Maintain Track Order',
      {0x10} 'Unknown 4',
      {0x20} 'Ducks Current Track',
      {0x40} IsSSE('Doesn''t Queue', 'Unknown 6')
    ]), cpNormal, True),
    wbStruct(PNAM, 'Data', [
      wbInteger('Priority', itU16),
      wbInteger('Ducking (dB)', itU16, wbDiv(100))
    ]),
    wbFloat(WNAM, 'Fade Duration'),
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
      wbInteger('Walk Forward Sets', itU32),
      wbInteger('Run Forward Sets', itU32),
      wbInteger('Walk Forward Alternate Sets', itU32),
      wbInteger('Run Forward Alternate Sets', itU32),
      wbInteger('Walk Forward Alternate 2 Sets', itU32)
    ], cpNormal, True),
    wbArray(DATA, 'Footstep Sets', wbFormIDCk('Footstep', [FSTP]), 0, nil, nil, cpNormal, True)
  ]);

  wbRecord(SMBN, 'Story Manager Branch Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent Node', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Node', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbConditions,
    wbInteger(DNAM, 'Flags', itU32,
      wbFlags([
        'Random',
        'Warn if no child quest started'
      ])
    ).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbInteger(XNAM, 'Max concurrent quests', itU32)
  ]);

  wbRecord(SMQN, 'Story Manager Quest Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent Node', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Node ', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbConditions,
    wbInteger(DNAM, 'Flags', itU32,
      wbFlags(wbSparseFlags([
        0, 'Random',
        1, 'Warn if no child quest started',
       16, 'Do all before repeating',
       17, 'Shares event',
       18, 'Num quests to run'
      ]))
    ).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbInteger(XNAM, 'Max concurrent quests', itU32),
    wbInteger(MNAM, 'Num quests to run', itU32),
    wbInteger(QNAM, 'Quest Count', itU32, nil, cpBenign, True),
    wbRArray('Quests',
      wbRStructSK([0], 'Quest', [
        wbFormIDCk(NNAM, 'Quest', [QUST], False),
        wbInteger(FNAM, '24 Hours Till Reset', itU32, wbBoolEnum),
        wbFloat(RNAM, 'Hours until reset', cpNormal, False, 1/24)
      ])
    ).SetCountPath(QNAM)
  ]);

  wbRecord(SMEN, 'Story Manager Event Node', [
    wbEDID,
    wbFormIDCkNoReach(PNAM, 'Parent Node', [SMQN, SMBN, SMEN, NULL]),
    wbFormIDCkNoReach(SNAM, 'Previous Node', [SMQN, SMBN, SMEN, NULL], False, cpBenign),
    wbCITCReq,
    wbConditions,
    wbInteger(DNAM, 'Flags', itU32,
      wbFlags([
        'Random',
        'Warn if no child quest started'
      ])
    ).IncludeFlag(dfCollapsed, wbCollapseFlags),
    wbInteger(XNAM, 'Max concurrent quests', itU32),
    wbInteger(ENAM, 'Type', itU32, wbQuestEventEnum)
  ]).SetSummaryKey([7]);

  wbRecord(DLBR, 'Dialog Branch', [
    wbEDID,
    wbFormIDCkNoReach(QNAM, 'Quest', [QUST], False, cpNormal, True),
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
    wbConditions,
    wbArray(SNAM, 'Tracks', wbFormIDCk('Track', [MUST, NULL]))
  ], True);

  wbRecord(DLVW, 'Dialog View', [
    wbEDID,
    wbFormIDCk(QNAM, 'Quest', [QUST], False, cpNormal, True),
    wbRArray('Branches',
      wbFormIDCk(BNAM, 'Branch', [DLBR])
    ),
    wbRArray('Topics',
      wbFormIDCK(TNAM, 'Topic', [DIAL])
    ),
    wbInteger(ENAM, 'Topic Type', itU32,
      wbEnum([], [
        0, 'Player Dialogue',
        1, 'Favor Dialogue',
        2, 'Custom',
        3, 'Combat',
        4, 'Favors',
        5, 'Detection',
        6, 'Service',
        7, 'Misc'
      ])).SetRequired,
    wbInteger(DNAM, 'Show All Text', itU8, wbBoolEnum)
      .SetRequired
  ]);

  wbRecord(SHOU, 'Shout',
    wbFlags(wbFlagsList([
      7, 'Treat spells as powers'
    ])), [
    wbEDID,
    wbFULL,
    wbMDOB,
    wbETYP,
    wbDESC,
    {>>> Don't sort <<<}
    wbRArray('Words of Power',
      wbStruct(SNAM, '', [
        wbFormIDCk('Word', [WOOP, NULL]),
        wbFormIDCk('Spell', [SPEL, NULL]),
        wbFloat('Recovery Time')
      ])
    ).IncludeFlag(dfNotAlignable)
  ]);

  wbRecord(EQUP, 'Equip Type', [
    wbEDID,
    wbArray(PNAM, 'Slot Parents', wbFormID('Can Be Equipped'), 0, nil, nil, cpNormal, False),
    wbInteger(DATA, 'Use All Parents', itU32, wbBoolEnum)
  ]);

  wbRecord(RELA, 'Relationship',
    wbFlags(wbFlagsList([
      6, 'Secret'
    ])), [
    wbEDID,
    wbStruct(DATA, 'Data', [
      wbFormIDCkNoReach('Parent', [NPC_, NULL]),
      wbFormIDCkNoReach('Child', [NPC_, NULL]),
      wbInteger('Rank', itU16, wbEnum([
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
      wbByteArray('Unknown', 1),
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

  wbRecord(SCEN, 'Scene', [
    wbEDID,
    wbVMADFragmentedSCEN,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      'Begin on Quest Start',
      'Stop Quest on End',
      'Show All Text',
      'Repeat Conditions While True',
      'Interruptible'
    ])),
    wbRArray('Phases',
      wbRStruct('Phase', [
        wbEmpty(HNAM, 'Marker Phase Start', cpNormal, True),
        wbString(NAM0, 'Name', 0, cpNormal, True),
        wbRStruct('Start Conditions', [wbConditions]),
        wbEmpty(NEXT, 'Marker', cpNormal, True),
        wbRStruct('Completion Conditions', [wbConditions]),
        {>>> BEGIN leftover from earlier CK versions <<<}
        wbRStruct('Unused', [
          wbUnknown(SCHR),
          wbUnknown(SCDA),
          wbUnknown(SCTX),
          wbUnknown(QNAM),
          wbUnknown(SCRO)
        ], [], cpIgnore, false, wbNeverShow),
        wbEmpty(NEXT, 'Marker', cpNormal, True),
        wbRStruct('Unused', [
          wbUnknown(SCHR),
          wbUnknown(SCDA),
          wbUnknown(SCTX),
          wbUnknown(QNAM),
          wbUnknown(SCRO)
        ], [], cpIgnore, false, wbNeverShow),
        {>>> END leftover from earlier CK versions begin <<<}
        wbInteger(WNAM, 'Editor Width', itU32, nil, cpNormal, True, false, nil, nil, 200),
        wbEmpty(HNAM, 'Marker Phase End', cpNormal, True)
      ])
    ),
    wbRArray('Actors', wbRStruct('Actor', [
      wbInteger(ALID, 'Actor ID', itU32, nil, cpNormal, True),
      wbInteger(LNAM, 'Flags', itU32, wbFlags([
        'No Player Activation',
        'Optional'
      ]), cpNormal, True),
      wbInteger(DNAM, 'Behaviour Flags', itU32, wbFlags([
        'Death Pause (unused)',
        'Death End',
        'Combat Pause',
        'Combat End',
        'Dialogue Pause',
        'Dialogue End',
        'OBS_COM Pause',
        'OBS_COM End'
      ]), cpNormal, True, false, nil, nil, 26)
    ])),
    wbRArray('Actions', wbRStructSK([0, 1, 3, 4], 'Action', [
      wbInteger(ANAM, 'Type', itU16, wbEnum([
        {0} 'Dialogue',
        {1} 'Package',
        {2} 'Timer'
      ]), cpNormal, True)
      .SetAfterSet(procedure(const aElement: IwbElement; const aOldValue, aNewValue: Variant)
        begin
          if not (VarIsOrdinal(aOldValue) and VarIsOrdinal(aNewValue)) then
            Exit;
          if aOldValue = aNewValue then
            Exit;
          if not Assigned(aElement) then
            Exit;
          var lContainer: IwbContainerElementRef;
          if not Supports(aElement.Container, IwbContainerElementRef, lContainer) then
            Exit;
          var lDataElement := lContainer.ElementBySortOrder[7]; //'Type Specific Action'
          if Assigned(lDataElement) and (lDataElement.Name <> aElement.Value) then
            lDataElement.Remove;
        end)
      .IncludeFlag(dfIncludeValueInDisplaySignature),
      wbString(NAM0, 'Name'),
      wbInteger(ALID, 'Actor ID', itS32),
      wbUnknown(LNAM),
      wbInteger(INAM, 'Index', itU32),
      wbInteger(FNAM, 'Flags', itU32, wbFlags([
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
        {0x00008000} 'Face Target',
        {0x00010000} 'Looping',
        {0x00020000} 'Headtrack Player'
      ])),
      wbInteger(SNAM, 'Start Phase', itU32),
      wbInteger(ENAM, 'End Phase', itU32),
      wbRUnion('Type Specific Action', function(const aContainer: IwbContainerElementRef): Integer
        begin
          Result := -1;
          if not Assigned(aContainer) then
            Exit;
          var lType := aContainer.ElementNativeValues[ANAM];
          if not VarIsOrdinal(lType) then
            Exit;
          Result := lType;
        end,
      [
        {0 Dialogue}
        wbRStruct('Dialogue', [
          wbFormIDCk(DATA, 'Topic', [DIAL, NULL]),
          wbInteger(HTID, 'Headtrack Actor ID', itS32),
          wbFloat(DMAX, 'Looping - Max'),
          wbFloat(DMIN, 'Looping - Min'),
          wbInteger(DEMO, 'Emotion Type', itU32, wbEmotionTypeEnum),
          wbInteger(DEVA, 'Emotion Value', itU32)
        ]),

        {1 Package}
        wbRStruct('Package', [
          wbRArray('Packages', wbFormIDCk(PNAM, 'Package', [PACK]))
        ]),

        {2 Timer}
        wbRStruct('Timer', [
          wbFloat(SNAM, 'Duration (Seconds)')
        ])
      ]),
      {>>> BEGIN leftover from earlier CK versions <<<}
      wbRStruct('Unused', [
        wbUnknown(SCHR),
        wbUnknown(SCDA),
        wbUnknown(SCTX),
        wbUnknown(QNAM),
        wbUnknown(SCRO)
      ], [], cpIgnore, false, wbNeverShow),
      {>>> END leftover from earlier CK versions <<<}
      wbMarkerReq(ANAM)
    ])),
    {>>> BEGIN leftover from earlier CK versions <<<}
    wbRStruct('Unused', [
      wbUnknown(SCHR),
      wbUnknown(SCDA),
      wbUnknown(SCTX),
      wbUnknown(QNAM),
      wbUnknown(SCRO)
    ], [], cpIgnore, false, wbNeverShow),
    wbEmpty(NEXT, 'Marker', cpNormal, True),
    wbRStruct('Unused', [
      wbUnknown(SCHR),
      wbUnknown(SCDA),
      wbUnknown(SCTX),
      wbUnknown(QNAM),
      wbUnknown(SCRO)
    ], [], cpIgnore, false, wbNeverShow),
    {>>> END leftover from earlier CK versions <<<}
    wbFormIDCk(PNAM, 'Quest', [QUST]),
    wbInteger(INAM, 'Last Action Index', itU32),
    wbStruct(VNAM, 'Actor Behavior Settings', [
      wbInteger('Death', itU32, wbEnum([
        'Set All Normal',
        '',
        'Set All End',
        'Don''t Set All'
      ])),
      wbInteger('Combat', itU32, wbEnum([
        'Set All Normal',
        'Set All Pause',
        'Set All End',
        'Don''t Set All'
      ])),
      wbInteger('Dialogue', itU32, wbEnum([
        'Set All Normal',
        'Set All Pause',
        'Set All End',
        'Don''t Set All'
      ])),
      wbInteger('Observe Combat', itU32, wbEnum([
        'Set All Normal',
        'Set All Pause',
        'Set All End',
        'Don''t Set All'
      ]))
    ]),
    wbConditions
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

  wbRecord(OTFT, 'Outfit', [
    wbEDID,
    wbArrayS(INAM, 'Items', wbFormIDCk('Item', [ARMO, LVLI]))
  ]);

  wbRecord(ARTO, 'Art Object', [
    wbEDID,
    wbOBND(True),
    wbGenericModel,
    wbInteger(DNAM, 'Art Type', itU32, wbEnum([
      'Magic Casting',
      'Magic Hit Effect',
      'Enchantment Effect'
    ]))
  ]).SetSummaryKey([2]);

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
      wbVec3('Projection Vector'),
      wbFromVersion(19, wbFloat('Normal Dampener')),
      wbFromVersion(25, wbFloatColors('Single Pass Color')),
      wbFromVersion(25, wbInteger('Single Pass', itU32, wbBoolEnum)),
      IsSSE(
        wbFromVersion(43, wbInteger('Is Snow', itU32, wbBoolEnum)),
        nil
      )
    ], cpNormal, True, nil, 8)
  ]);

  wbRecord(MOVT, 'Movement Type', [
    wbEDID,
    wbString(MNAM, 'Name'),
    wbStruct(SPED, 'Default Data', [
      wbFloat('Left Walk'),
      wbFloat('Left Run'),
      wbFloat('Right Walk'),
      wbFloat('Right Run'),
      wbFloat('Forward Walk'),
      wbFloat('Forward Run'),
      wbFloat('Back Walk'),
      wbFloat('Back Run'),
      wbFloatAngle('Rotate in Place Walk'),
      wbFloatAngle('Rotate in Place Run'),
      wbFromVersion(28, wbFloatAngle('Rotate while Moving Run'))
    ]).SetRequired,
    wbStruct(INAM, 'Anim Change Thresholds', [
      wbFloat('Directional', cpNormal, True, 180/Pi),
      wbFloat('Movement Speed'),
      wbFloat('Rotation Speed', cpNormal, True, 180/Pi)
    ]).SetRequired
  ]);

  wbRecord(SNDR, 'Sound Descriptor', [
    wbEDID,
    wbInteger(CNAM, 'Descriptor Type', itU32, wbEnum([], [
      Int64($1EEF540A), 'Standard'
    ])),
    wbFormID(GNAM, 'Category'),
    wbFormIDCk(SNAM, 'Alternate Sound For', [SNDR, NULL]),
    wbSoundDescriptorSounds,
    wbFormIDCk(ONAM, 'Output Model', [SOPM, NULL]),
    wbLString(FNAM, 'String', 0, cpIgnore),
    wbConditions,
    wbStruct(LNAM, 'Values', [
      wbByteArray('Unknown', 1),
      wbInteger('Looping', itU8, wbEnum([], [
        $00 , 'None',
        $08 , 'Loop',
        $10 , 'Envelope Fast',
        $20 , 'Envelope Slow'
      ])),
      wbByteArray('Unknown', 1),
      wbInteger('Rumble Send Value = (Small / 7) + ((Big / 7) * 16)', itU8)
    ]).SetRequired,
    wbStruct(BNAM, 'Values', [
      wbInteger('% Frequency Shift', itS8),
      wbInteger('% Frequency Variance', itS8),
      wbInteger('Priority', itU8),
      wbInteger('db Variance', itU8),
      wbInteger('Static Attenuation (db)', itU16, wbDiv(100))
    ])
  ]);

  wbRecord(DUAL, 'Dual Cast Data', [
    wbEDID,
    wbOBND(True),
    wbStruct(DATA, 'Data', [
      wbFormIDCk('Projectile', [PROJ, NULL]),
      wbFormIDCk('Explosion', [EXPL, NULL]),
      wbFormIDCk('Effect Shader', [EFSH, NULL]),
      wbFormIDCk('Hit Effect Art', [ARTO, NULL]),
      wbFormIDCk('Impact Data Set', [IPDS, NULL]),
      wbInteger('Inherit Scale', itU32, wbFlags([
        'Hit Effect Art',
        'Projectile',
        'Explosion'
      ]))
    ], cpNormal, True)
  ]);

  wbRecord(SNCT, 'Sound Category', [
    wbEDID,
    wbFULL,
    wbInteger(FNAM, 'Flags', itU32, wbFlags([
      'Mute When Submerged',
      'Should Appear on Menu'
    ]), cpNormal, True),
    wbFormIDCk(PNAM, 'Parent', [SNCT]),
    wbInteger(VNAM, 'Static Volume Multiplier', itU16, wbDiv(65535)),
    wbInteger(UNAM, 'Default Menu Value', itU16, wbDiv(65535))
  ]);

  wbRecord(SOPM, 'Sound Output Model', [
    wbEDID,
    wbStruct(NAM1, 'Data', [
      wbInteger('Flags', itU8, wbFlags([
        'Attenuates With Distance',
        'Allows Rumble'
      ])),
      wbByteArray('Unknown', 2),
      wbInteger('Reverb Send %', itU8)
    ]),
    wbUnknown(FNAM), // leftover, unused
    wbInteger(MNAM, 'Type', itU32, wbEnum([
      'Uses HRTF',
      'Defined Speaker Output'
    ])),
    wbUnknown(CNAM), // leftover, unused
    wbUnknown(SNAM), // leftover, unused
    wbStruct(ONAM, 'Output Values', [
      wbArray('Channels', wbStruct('', [
        wbInteger('L', itU8),
        wbInteger('R', itU8),
        wbInteger('C', itU8),
        wbInteger('LFE', itU8),
        wbInteger('RL', itU8),
        wbInteger('RR', itU8),
        wbInteger('BL', itU8),
        wbInteger('BR', itU8)
      ]), [
        'Channel 0',
        'Channel 1',
        'Channel 2? (unused)'
      ])
    ]),
    wbStruct(ANAM, 'Attenuation Values', [
      wbByteArray('Unknown', 4),
      wbFloat('Min Distance'),
      wbFloat('Max Distance'),
      wbArray('Curve', wbInteger('Value', itU8), 5),
      wbByteArray('Unknown', 3)
    ])
  ]);

  wbRecord(COLL, 'Collision Layer', [
    wbEDID,
    wbDESCReq,
    wbInteger(BNAM, 'Index', itU32, nil, cpNormal, True),
    wbByteColors(FNAM, 'Debug Color'),
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
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbFULL,
    wbCNAM(True),
    wbInteger(FNAM, 'Playable', itU32, wbBoolEnum, cpNormal, True)
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
    ], cpNormal, True)
  ]);

  wbRecord(GRAS, 'Grass', [
    wbEDID,
    wbOBND(True),
    wbGenericModel,
    wbStruct(DATA, '', [
      wbInteger('Density', itU8),
      wbInteger('Min Slope', itU8),
      wbInteger('Max Slope', itU8),
      wbUnused(1),
      wbInteger('Units From Water', itU16),
      wbUnused(2),
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
      wbUnused(3)
    ], cpNormal, True)
  ]);

  wbRecord(IDLE, 'Idle Animation', [
    wbEDID,
    wbConditions,
    wbString(DNAM, 'FileName'),
    wbString(ENAM, 'Animation Event'),
    wbStruct(ANAM, 'Animations', [
      wbFormIDCk('Parent', [AACT, IDLE, NULL], False, cpBenign),
      wbFormIDCk('Previous', [AACT, IDLE, NULL], False, cpBenign)
    ]).SetRequired,
    wbStruct(DATA, 'Data (unused)', [
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
    ], cpIgnore, True)
  ]);

  wbRecord(INFO, 'Dialog response',
    wbFlags(wbFlagsList([
      13, 'Actor Changed'
    ])), [
    wbEDID,
    wbVMADFragmentedINFO,
    wbStruct(DATA, 'Data', [
      wbInteger('Quest Dialogue Tab', itU16,
        wbEnum([], [
          0, 'Player Dialogue',
          1, 'Favor Dialogue',
          2, 'Scenes',
          3, 'Combat',
          4, 'Favors',
          5, 'Detection',
          6, 'Service',
          7, 'Misc'
        ])),
      wbInteger('Response Flags', itU16,
        wbFlags(wbSparseFlags([
          0, 'Goodbye',
          1, 'Random',
          2, 'Say Once',
          3, 'Requires Player Activation',
          4, 'Info Refusal',
          5, 'Random End',
          6, 'Invisible Continue',
          7, 'Walk Away',
          8, 'Walk Away Invisible In Menu',
          9, 'Force Subtitle',
         10, 'Can Move While Greeting',
         11, 'No LIP File',
         12, 'Requires Post-Processing',
         13, 'Audio Output Override',
         14, 'Spends Favor Points'
        ], False, 15))),
      wbFloat('Reset Days')
    ]),
    wbStruct(ENAM, 'Data', [
      wbInteger('Response Flags', itU16,
        wbFlags(wbSparseFlags([
          0, 'Goodbye',
          1, 'Random',
          2, 'Say once',
          3, 'Requires Player Activation',
          4, 'Info Refusal',
          5, 'Random end',
          6, 'Invisible continue',
          7, 'Walk Away',
          8, 'Walk Away Invisible in Menu',
          9, 'Force subtitle',
         10, 'Can move while greeting',
         11, 'No LIP File',
         12, 'Requires post-processing',
         13, 'Audio Output Override',
         14, 'Spends favor points'
      ], False, 15))),
      wbInteger('Reset Hours', itU16, wbDiv(2730))
    ]),
    wbFormIDCk(TPIC, 'Topic', [DIAL]),
    wbFormIDCkNoReach(PNAM, 'Previous INFO', [INFO, NULL], False, cpBenign).SetAfterSet(wbINFOPNAMAfterSet),
    wbInteger(CNAM, 'Favor Level', itU8, wbEnum([
      'None',
      'Small',
      'Medium',
      'Large'
    ])).SetRequired,

    wbRArray('Link To', wbFormIDCk(TCLT, 'Response', [DIAL, INFO, NULL])),
    wbFormID(DNAM, 'Response Data'),

    wbRArray('Responses', wbRStruct('Response', [
      wbStruct(TRDT, 'Response Data', [
        wbInteger('Emotion Type', itU32, wbEmotionTypeEnum),
        wbInteger('Emotion Value', itU32),
        wbUnused(4),
        wbInteger('Response number', itU8),
        wbUnused(3),
        wbFormIDCk('Sound', [SNDR, NULL]),
        wbInteger('Flags', itU8, wbFlags([
          'Use Emotion Animation'
        ])),
        wbUnused(3)
      ]),
      wbLStringKC(NAM1, 'Response Text', 0, cpTranslate),
      wbString(NAM2, 'Script Notes'),
      wbString(NAM3, 'Edits'),
      wbFormIDCk(SNAM, 'Idle Animations: Speaker', [IDLE]),
      wbFormIDCk(LNAM, 'Idle Animations: Listener', [IDLE])
    ])),

    wbConditions,

    {>>> BEGIN leftover from earlier CK versions <<<}
    wbRArray('Unknown',
      wbRStruct('Unknown', [
        wbUnknown(SCHR),
        wbFormID(QNAM, 'Unknown'),
        wbEmpty(NEXT, 'Marker', cpNormal, True)
      ]), cpIgnore, false, nil, nil, wbNeverShow
    ),
    {>>> END leftover from earlier CK versions <<<}

    wbLStringKC(RNAM, 'Prompt', 0, cpTranslate),
    wbFormIDCkNoReach(ANAM, 'Speaker', [NPC_]),
    wbFormIDCk(TWAT, 'Walk Away Topic', [DIAL]),
    wbFormIDCk(ONAM, 'Audio Output Override', [SOPM])
  ]).SetAddInfo(wbINFOAddInfo);

  wbRecord(INGR, 'Ingredient', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbKeywords,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbETYP,
    wbYNAM,
    wbZNAM,
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
    wbEffectsReq
  ]);

  wbRecord(KEYM, 'Key',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULLReq,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbStruct(DATA, '', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True)
  ]);

  wbRecord(LAND, 'Landscape',
    wbFlags(wbFlagsList([
      18, 'Compressed'
    ]), [18]), [
    wbInteger(DATA, 'Flags', itU32, wbFlags([
      {0x001} 'Has Vertex Normals/Height Map',
      {0x002} 'Has Vertex Colours',
      {0x004} 'Has Layers',
      {0x008} 'Unknown 4',
      {0x010} 'Auto-Calc Normals',
      {0x020} '',
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
    wbRArray('Unknown', wbUnknown(MPCD))
  ]).SetAddInfo(wbLANDAddInfo);

  wbRecord(LIGH, 'Light',
    wbFlags(wbFlagsList([
      16, 'Random Anim Start',
      17, 'Portal-strict',
      25, 'Obstacle'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbGenericModel,
    wbDEST,
    wbFULL,
    wbICON,
    wbStruct(DATA, '', [
      wbInteger('Time', itS32),
      wbInteger('Radius', itU32),
      wbByteColors,
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001} 'Dynamic',
        {0x00000002} 'Can be Carried',
        {0x00000004} 'Negative',
        {0x00000008} 'Flicker',
        {0x00000010} 'Unknown',
        {0x00000020} 'Off By Default',
        {0x00000040} 'Flicker Slow',
        {0x00000080} 'Pulse',
        {0x00000100} 'Pulse Slow',
        {0x00000200} 'Spot Light',
        {0x00000400} 'Shadow Spotlight',
        {0x00000800} 'Shadow Hemisphere',
        {0x00001000} 'Shadow Omnidirectional',
        {0x00002000} 'Portal-strict'
      ])),
      wbFloat('Falloff Exponent')
        .SetDefaultNativeValue(1),
      wbFloat('FOV')
        .SetDefaultNativeValue(90),
      wbFloat('Near Clip'),
      wbStruct('Flicker Effect', [
        wbFloat('Period', cpNormal, False, 0.01),
        wbFloat('Intensity Amplitude'),
        wbFloat('Movement Amplitude')
      ]),
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbFloat(FNAM, 'Fade value')
      .SetDefaultNativeValue(1.0)
      .SetRequired,
    wbFormIDCk(SNAM, 'Sound', [SNDR]),
    // SSE
    wbFormIDCk(LNAM, 'Lens', [LENS])
  ]);

  wbRecord(LSCR, 'Load Screen',
    wbFlags(wbFlagsList([
      10, 'Displays In Main Menu'
    ])), [
    wbEDID,
    wbICON,
    wbDESCReq,
    wbConditions,
    wbFormIDCk(NNAM, 'Loading Screen NIF', [STAT, NULL], False, cpNormal, True),
    wbFloat(SNAM, 'Initial Scale'),
    wbStruct(RNAM, 'Initial Rotation', [
      wbInteger('X', itS16),
      wbInteger('Y', itS16),
      wbInteger('Z', itS16)
    ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
    wbStruct(ONAM, 'Rotation Offset Constraints', [
      wbInteger('Min', itS16),
      wbInteger('Max', itS16)
    ]),
    wbVec3(XNAM, 'Initial Translation Offset'),
    wbString(MOD2, 'Camera Path', 0, cpNormal, False)
  ]);

  wbRecord(LTEX, 'Landscape Texture', [
    wbEDID,
    wbFormIDCk(TNAM, 'Texture Set', [TXST], False, cpNormal, False),
    wbFormIDCk(MNAM, 'Material Type', [MATT, NULL], False, cpNormal, True),
    wbStruct(HNAM, 'Havok Data', [
      wbInteger('Friction', itU8),
      wbInteger('Restitution', itU8)
    ], cpNormal, True),
    wbInteger(SNAM, 'Texture Specular Exponent', itU8, nil, cpNormal, True),
    wbRArrayS('Grasses', wbFormIDCk(GNAM, 'Grass', [GRAS])),
    // SSE
    IsSSE(
      wbInteger(INAM, 'Is Snow', itU32, wbBoolEnum).SetRequired,
      nil
    )
  ]);

  wbRecord(LVLN, 'Leveled NPC', [
    wbEDID,
    wbOBND(True),
    wbLVLD,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count'
    ]), cpNormal, True),
    wbFormIDCk(LVLG, 'Global', [GLOB]),
    wbLLCT,
    wbRArrayS('Leveled List Entries',
      wbRStructExSK([0], [1], 'Leveled List Entry', [
        wbLeveledListEntry('NPC', [LVLN, NPC_]),
        wbCOED
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    ).SetCountPath(LLCT),
    wbGenericModel
  ]);

  wbRecord(LVLI, 'Leveled Item', [
    wbEDID,
    wbOBND(True),
    wbLVLD,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count',
      {0x04} 'Use All',
      {0x08} 'Special Loot'
    ]), cpNormal, True),
    wbFormIDCk(LVLG, 'Global', [GLOB]),
    wbLLCT,
    wbRArrayS('Leveled List Entries',
      wbRStructExSK([0], [1], 'Leveled List Entry', [
        wbLeveledListEntry('Item', [ALCH, AMMO, APPA, ARMO, BOOK, INGR, KEYM, LIGH, LVLI, MISC, SCRL, SLGM, WEAP]),
        wbCOED
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    ).SetCountPath(LLCT)
  ]);

   wbRecord(LVSP, 'Leveled Spell', [
    wbEDID,
    wbOBND(True),
    wbLVLD,
    wbInteger(LVLF, 'Flags', itU8, wbFlags([
      {0x01} 'Calculate from all levels <= player''s level',
      {0x02} 'Calculate for each item in count',
      {0x04} 'Use All Spells'
    ]), cpNormal, True),
    wbLLCT,
    wbRArrayS('Leveled List Entries',
      wbRStructSK([0], 'Leveled List Entry', [
        wbLeveledListEntry('Spell', [LVSP, SPEL])
      ]).SetSummaryMemberMaxDepth(0, 1)
        .IncludeFlag(dfCollapsed, wbCollapseLeveledItems)
    ).SetCountPath(LLCT)
  ]);

  wbMGEFType := wbInteger('Archtype', itU32, wbEnum([
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
    {13} 'Unknown 13',
    {14} 'Unknown 14',
    {15} 'Lock',
    {16} 'Open',
    {17} 'Bound Weapon',
    {18} 'Summon Creature',
    {19} 'Detect Life',
    {20} 'Telekinesis',
    {21} 'Paralysis',
    {22} 'Reanimate',
    {23} 'Soul Trap',
    {24} 'Turn Undead',
    {25} 'Guide',
    {26} 'Werewolf Feed',
    {27} 'Cure Paralysis',
    {28} 'Cure Addiction',
    {29} 'Cure Poison',
    {30} 'Concussion',
    {31} 'Value and Parts',
    {32} 'Accumulate Magnitude',
    {33} 'Stagger',
    {34} 'Peak Value Modifier',
    {35} 'Cloak',
    {36} 'Werewolf',
    {37} 'Slow Time',
    {38} 'Rally',
    {39} 'Enhance Weapon',
    {40} 'Spawn Hazard',
    {41} 'Etherealize',
    {42} 'Banish',
    {43} 'Spawn Scripted Ref',
    {44} 'Disguise',
    {45} 'Grab Actor',
    {46} 'Vampire Lord'
  ]), cpNormal, False, nil, wbMGEFArchtypeAfterSet);

  wbMGEFData := wbRStruct('Magic Effect Data', [
    wbStruct(DATA, 'Data', [
      wbInteger('Flags', itU32, wbFlags([
        {0x00000001}  'Hostile',
        {0x00000002}  'Recover',
        {0x00000004}  'Detrimental',
        {0x00000008}  'Snap to Navmesh',
        {0x00000010}  'No Hit Event',
        {0x00000020}  'Unknown 6',
        {0x00000040}  'Unknown 7',
        {0x00000080}  'Unknown 8',
        {0x00000100}  'Dispel with Keywords',
        {0x00000200}  'No Duration',
        {0x00000400}  'No Magnitude',
        {0x00000800}  'No Area',
        {0x00001000}  'FX Persist',
        {0x00002000}  'Unknown 14',
        {0x00004000}  'Gory Visuals',
        {0x00008000}  'Hide in UI',
        {0x00010000}  'Unknown 17',
        {0x00020000}  'No Recast',
        {0x00040000}  'Unknown 19',
        {0x00080000}  'Unknown 20',
        {0x00100000}  'Unknown 21',
        {0x00200000}  'Power Affects Magnitude',
        {0x00400000}  'Power Affects Duration',
        {0x00800000}  'Unknown 24',
        {0x01000000}  'Unknown 25',
        {0x02000000}  'Unknown 26',
        {0x04000000}  'Painless',
        {0x08000000}  'No Hit Effect',
        {0x10000000}  'No Death Dispel',
        {0x20000000}  'Unknown 30',
        {0x40000000}  'Unknown 31',
        {0x80000000}  'Unknown 32'
      ])),
      wbFloat('Base Cost'),
      wbUnion('Assoc. Item', wbMGEFAssocItemDecider, [
        wbFormID('Unused', cpIgnore),
        wbFormIDCk('Assoc. Item', [LIGH, NULL]),
        wbFormIDCk('Assoc. Item', [WEAP, ARMO, NULL]),
        wbFormIDCk('Assoc. Item', [NPC_, NULL]),
        wbFormIDCk('Assoc. Item', [HAZD, NULL]),
        wbFormIDCk('Assoc. Item', [SPEL, NULL]),
        wbFormIDCk('Assoc. Item', [RACE, NULL]),
        wbFormIDCk('Assoc. Item', [ENCH, NULL]),
        wbFormIDCk('Assoc. Item', [KYWD, NULL])
      ], cpNormal, False, nil, wbMGEFAssocItemAfterSet),
      wbInteger('Magic Skill', itS32, wbActorValueEnum),
      wbInteger('Resist Value', itS32, wbActorValueEnum),
      wbInteger('Counter Effect count', itU16),
      wbUnused(2),
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
      wbInteger('Second Actor Value', itS32, wbActorValueEnum),
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
      ])
    ], cpNormal, True)
  ]);

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
    wbConditions
  ], False, nil, cpNormal, False, nil {wbMGEFAfterLoad}, wbMGEFAfterSet);

  wbRecord(MISC, 'Misc. Item',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itS32),
      wbFloat('Weight')
    ], cpNormal, True)
  ]);

  wbRecord(APPA, 'Alchemical Apparatus', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbInteger(QUAL, 'Quality', itS32, wbEnum([], [
      0, 'Novice',
      1, 'Apprentice',
      2, 'Journeyman',
      3, 'Expert',
      4, 'Master'
    ])),
    wbDESC,
    wbStruct(DATA, 'Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ])
  ]);

  wbRecord(COBJ, 'Constructible Object', [
    wbEDID,
    wbCOCT,
    wbCNTOsNoReach,
    wbConditions,
    wbFormID(CNAM, 'Created Object'),
    wbFormIDCkNoReach(BNAM, 'Workbench Keyword', [KYWD]),
    wbInteger(NAM1, 'Created Object Count', itU16)
  ], False, nil, cpNormal, False, nil, wbContainerAfterSet)
    .SetSummaryKey([6, 4, 2, 3, 5])
    .SetSummaryMemberPrefixSuffix(6, '(', 'x')
    .SetSummaryMemberPrefixSuffix(4, '', ')')
    .SetSummaryMemberPrefixSuffix(2, 'from (', ')')
    .SetSummaryMemberPrefixSuffix(3, 'when (', ')')
    .SetSummaryMemberPrefixSuffix(5, 'at (', ')');

  wbRecord(NPC_, 'Non-Player Character (Actor)',
    wbFlags(wbFlagsList([
      10, 'Unknown 10',
      18, 'Compressed',
      19, 'Unknown 19',
      29, 'Bleedout Override'
    ]), [18]), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
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
        {0x00000100} 'Use Template?',
        {0x00000200} 'Unknown 9',
        {0x00000400} 'Unknown 10',
        {0x00000800} 'Protected',
        {0x00001000} 'Unknown 12',
        {0x00002000} 'Unknown 13',
        {0x00004000} 'Summonable',
        {0x00008000} 'Unknown 15',
        {0x00010000} 'Doesn''t bleed',
        {0x00020000} 'Unknown 17',
        {0x00040000} 'Bleedout Override',
        {0x00080000} 'Opposite Gender Anims',
        {0x00100000} 'Simple Actor',
        {0x00200000} 'looped script?',
        {0x00400000} 'Unknown 22',
        {0x00800000} 'Unknown 23',
        {0x01000000} 'Unknown 24',
        {0x02000000} 'Unknown 25',
        {0x04000000} 'Unknown 26',
        {0x08000000} 'Unknown 27',
        {0x10000000} 'looped audio?',
        {0x20000000} 'Is Ghost',
        {0x40000000} 'Unknown 30',
        {0x80000000} 'Invulnerable'
      ])),
      wbInteger('Magicka Offset', itS16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Stamina Offset', itS16, nil, cpNormal, False, nil{wbActorTemplateUseAIData}),
      wbUnion('Level', wbNPCLevelDecider, [
        wbInteger('Level', itS16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
        wbInteger('Level Mult', itS16, wbDiv(1000), cpNormal, True, nil{wbActorTemplateUseStats})
      ], cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Calc min level', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Calc max level', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Speed Multiplier', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Disposition Base (unused)', itS16, nil, cpIgnore, True, nil{wbActorTemplateUseTraits}),
      wbInteger('Template Flags', itU16, wbTemplateFlags)
        .IncludeFlag(dfCollapsed,  wbCollapseFlags),
      wbInteger('Health Offset', itS16, nil, cpNormal, True, nil{wbActorTemplateUseStats}),
      wbInteger('Bleedout Override', itU16, nil, cpNormal, True, nil{wbActorTemplateUseStats})
    ], cpNormal, True),
    wbRArrayS('Factions', wbFaction, cpNormal, False, nil, nil, nil{wbActorTemplateUseFactions}),
    wbFormIDCk(INAM, 'Death item', [LVLI], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(VTCK, 'Voice', [VTYP], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(TPLT, 'Template', [LVLN, NPC_]),
    wbFormIDCk(RNAM, 'Race', [RACE], False, cpNormal, True, nil{wbActorTemplateUseTraits}),
    wbSPCT,
    wbSPLOs,
    wbDEST,
    wbFormIDCk(WNAM, 'Skin', [ARMO], False, cpNormal, False),
    wbFormIDCk(ANAM, 'Far away model', [ARMO], False, cpNormal, False, nil{wbActorTemplateUseTraits}),
    wbFormIDCk(ATKR, 'Attack Race', [RACE], False, cpNormal, False),
    wbRArrayS('Attacks', wbAttackData),
    wbFormIDCk(SPOR, 'Spectator override package list', [FLST], False, cpNormal, False),
    wbFormIDCk(OCOR, 'Observe dead body override package list', [FLST], False, cpNormal, False),
    wbFormIDCk(GWOR, 'Guard warn override package list', [FLST], False, cpNormal, False),
    wbFormIDCk(ECOR, 'Combat override package list', [FLST], False, cpNormal, False),
    wbInteger(PRKZ, 'Perk Count', itU32, nil, cpBenign),
    wbRArrayS('Perks',
      wbStructSK(PRKR, [0], 'Perk', [
        wbFormIDCk('Perk', [PERK]),
        wbInteger('Rank', itU8),
        wbUnused(3)
      ]), cpNormal, False, nil, wbPRKRsAfterSet
    ),
    wbCOCT,
    wbCNTOs,
    wbAIDT,
    wbRArray('Packages', wbFormIDCk(PKID, 'Package', [PACK]), cpNormal, False, nil{wbActorTemplateUseAIPackages}),
    wbKeywords,
    wbFormIDCk(CNAM, 'Class', [CLAS], False, cpNormal, True),
    wbFULL,
    wbLString(SHRT, 'Short Name', 0, cpTranslate),
    wbEmpty(DATA, 'Marker', cpNormal, True),
    wbStruct(DNAM, 'Player Skills', [
      wbArray('Skill Values', wbInteger('Skill', itU8), [
        'OneHanded',
        'TwoHanded',
        'Marksman',
        'Block',
        'Smithing',
        'HeavyArmor',
        'LightArmor',
        'Pickpocket',
        'Lockpicking',
        'Sneak',
        'Alchemy',
        'Speechcraft',
        'Alteration',
        'Conjuration',
        'Destruction',
        'Illusion',
        'Restoration',
        'Enchanting'
      ]),
      wbArray('Skill Offsets', wbInteger('Skill', itU8), [
        'OneHanded',
        'TwoHanded',
        'Marksman',
        'Block',
        'Smithing',
        'HeavyArmor',
        'LightArmor',
        'Pickpocket',
        'Lockpicking',
        'Sneak',
        'Alchemy',
        'Speechcraft',
        'Alteration',
        'Conjuration',
        'Destruction',
        'Illusion',
        'Restoration',
        'Enchanting'
      ]),
      //wbByteArray('Unknown', 4),
      wbInteger('Health', itU16),
      wbInteger('Magicka', itU16),
      wbInteger('Stamina', itU16),
      wbUnused(2),
      wbFloat('Far away model distance'),
      wbInteger('Geared up weapons', itU8),
      wbUnused(3)
    ], cpNormal, False, nil{wbActorTemplateUseStatsAutoCalc}),
    wbRArrayS('Head Parts', wbFormIDCk(PNAM, 'Head Part', [HDPT]), cpNormal, False, nil, nil, nil{wbActorTemplateUseModelAnimation}),
    wbFormIDCk(HCLF, 'Hair Color', [CLFM], False, cpNormal, False),
    wbFormIDCk(ZNAM, 'Combat Style', [CSTY], False, cpNormal, False),
    wbFormIDCk(GNAM, 'Gift Filter', [FLST], False, cpNormal, False),
    wbUnknown(NAM5, cpNormal, True),
    wbFloat(NAM6, 'Height', cpNormal, True),
    wbFloat(NAM7, 'Weight', cpNormal, True),
    wbInteger(NAM8, 'Sound Level', itU32, wbSoundLevelEnum, cpNormal, True),
    wbCSDTs,
    // When CSCR exists CSDT, CSDI, CSDC are not present
    wbFormIDCk(CSCR, 'Inherits Sounds From', [NPC_], False, cpNormal, False),
    wbFormIDCk(DOFT, 'Default outfit', [OTFT], False, cpNormal, False),
    wbFormIDCk(SOFT, 'Sleeping outfit', [OTFT], False, cpNormal, False),
    wbFormIDCk(DPLT, 'Default Package List', [FLST], False, cpNormal, False),
    wbFormIDCk(CRIF, 'Crime faction', [FACT], False, cpNormal, False),
    wbFormIDCk(FTST, 'Head texture', [TXST], False, cpNormal, False),
    wbFloatColors(QNAM, 'Texture lighting'),
    wbStruct(NAM9, 'Face morph', [
      wbFloat('Nose Long/Short'),
      wbFloat('Nose Up/Down'),
      wbFloat('Jaw Up/Down'),
      wbFloat('Jaw Narrow/Wide'),
      wbFloat('Jaw Farward/Back'),
      wbFloat('Cheeks Up/Down'),
      wbFloat('Cheeks Farward/Back'),
      wbFloat('Eyes Up/Down'),
      wbFloat('Eyes In/Out'),
      wbFloat('Brows Up/Down'),
      wbFloat('Brows In/Out'),
      wbFloat('Brows Farward/Back'),
      wbFloat('Lips Up/Down'),
      wbFloat('Lips In/Out'),
      wbFloat('Chin Narrow/Wide'),
      wbFloat('Chin Up/Down'),
      wbFloat('Chin Underbite/Overbite'),
      wbFloat('Eyes Farward/Back'),
      wbFloat('VampireMorph')
    ], cpNormal, False),
    wbStruct(NAMA, 'Face parts', [
      wbInteger('Nose', itU32),
      wbInteger('Unknown', itS32),
      wbInteger('Eyes', itU32),
      wbInteger('Mouth', itU32)
    ]),
    wbRArrayS('Tint Layers',
      wbRStructSK([0], 'Layer', [
        wbInteger(TINI, 'Tint Index', itU16, wbTintLayerToStr, wbStrToInt),
        wbByteRGBA(TINC, 'Tint Color'),
        wbInteger(TINV, 'Interpolation Value', itU32, wbDiv(100)),
        wbInteger(TIAS, 'Preset', itS16)
      ]))
  ], False, nil, cpNormal, False, nil, wbNPCAfterSet);

  wbObjectTypeEnum := wbEnum([
    ' NONE',
    'Activators',
    'Armor',
    'Books',
    'Clothing',
    'Containers',
    'Doors',
    'Ingredients',
    'Lights',
    'Misc',
    'Flora',
    'Furniture',
    'Weapons: Any',
    'Ammo',
    'NPCs',
    'Creatures',
    'Keys',
    'Alchemy',
    'Food',
    ' All: Combat Wearable',
    ' All: Wearable',
    'Weapons: Ranged',
    'Weapons: Melee',
    'Weapons: NONE',
    'Actor Effects: Any',
    'Actor Effects: Range Target',
    'Actor Effects: Range Touch',
    'Actor Effects: Range Self',
    'Actors: Any'
  ]);

  wbPKDTInterruptFlags := wbFlags([
    {0x0001}'Hellos to player',
    {0x0002}'Random conversations',
    {0x0004}'Observe combat behavior',
    {0x0008}'Greet corpse behavior',
    {0x0010}'Reaction to player actions',
    {0x0020}'Friendly fire comments',
    {0x0040}'Aggro Radius Behavior',
    {0x0080}'Allow Idle Chatter',
    {0x0100}'Unknown 9',
    {0x0200}'World Interactions',
    {0x0400}'Unknown 11',
    {0x0800}'Unknown 12',
    {0x1000}'Unknown 13',
    {0x2000}'Unknown 14',
    {0x4000}'Unknown 15',
    {0x8000}'Unknown 16'
  ]);

  wbUNAMs:= wbRArray('Data Inputs', wbRStruct('Data Input', [
    wbInteger(UNAM, 'Index', itS8),
    wbString(BNAM, 'Name'),
    wbInteger(PNAM, 'Flags', itU32, wbFlags([
      'Public'
    ]))
  ]));

  wbRecord(PACK, 'Package', [
    wbEDID,
    wbVMADFragmentedPACK,

    wbStruct(PKDT, 'Pack Data', [
      wbInteger('General Flags', itU32, wbPackageFlags),
      wbInteger('Type', itU8, wbEnum ([], [
        18, 'Package',
        19, 'Package Template'
      ])).SetDefaultEditValue('Package'),
      wbInteger('Interrupt Override', itU8, wbEnum([
        'None',
        'Spectator',
        'ObserveDead',
        'GuardWarn',
        'Combat'
      ])),
      wbInteger('Preferred Speed', itU8, wbEnum([
        'Walk',
        'Jog',
        'Run',
        'Fast Walk'
      ])),
      wbByteArray('Unknown', 1),
      wbInteger('Interrupt Flags', itU16, wbPKDTInterruptFlags),
      wbByteArray('Unknown', 2)
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
      wbUnused(3),
      wbInteger('Duration (minutes)', itS32)
    ], cpNormal, True),
    wbConditions,

    wbRStruct('Idle Animations', [
      wbInteger(IDLF, 'Flags', itU8, wbEnum([], [
         0, 'Unknown',
         8, 'Random',
         9, 'Run in Sequence',
        12, 'Random, Do Once',
        13, 'Run in Sequence, Do Once'
      ]), cpNormal, True),
      wbStruct(IDLC, '', [
        wbInteger('Animation Count', itU8, nil, cpBenign),
        wbByteArray('Unknown', 3)
      ], cpNormal, True, nil, 1),
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
        wbFormIDCK(TPIC, 'Dialogue Topic', [DIAL])
      ], [], cpNormal, False)),
      wbUNAMs
    ]),
    wbByteArray(XNAM, 'Marker', 0, cpNormal, True),

    wbRStruct('Procedure Tree', [
      wbRArray('Branches', wbRStruct('Branch', [
        wbString(ANAM, 'Branch Type'),
        wbCITCReq,
        wbConditions,
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
            wbInteger('Set General Flags', itU32, wbPackageFlags),
            wbInteger('Clear General Flags', itU32, wbPackageFlags),
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
        wbRArray('Unknown', wbUnknown(PFOR), cpIgnore)
      ]))
    ]),
    wbUNAMs,
    wbRStruct('OnBegin', [
      wbEmpty(POBA, 'OnBegin Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      {>>> BEGIN leftover from earlier CK versions <<<}
      wbByteArray(SCHR, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(SCTX, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(QNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(TNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      {>>> END leftover from earlier CK versions <<<}
      wbPDTOs
    ], [], cpNormal, True),
    wbRStruct('OnEnd', [
      wbEmpty(POEA, 'OnEnd Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      {>>> BEGIN leftover from earlier CK versions <<<}
      wbByteArray(SCHR, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(SCTX, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(QNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(TNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      {>>> END leftover from earlier CK versions <<<}
      wbPDTOs
    ], [], cpNormal, True),
    wbRStruct('OnChange', [
      wbEmpty(POCA, 'OnChange Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      {>>> BEGIN leftover from earlier CK versions <<<}
      wbByteArray(SCHR, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(SCDA, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(SCTX, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(QNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(TNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      {>>> END leftover from earlier CK versions <<<}
      wbPDTOs
    ], [], cpNormal, True)
  ], False, nil, cpNormal, False, nil {wbPACKAfterLoad});

  wbQUSTAliasFlags :=
    wbStruct(FNAM, 'Alias Flags', [
      wbInteger('Flags', itU16, wbFlags([
        {0x0001}'Reserves Location/Reference',
        {0x0002}'Optional',
        {0x0004}'Quest Object',
        {0x0008}'Allow Reuse in Quest',
        {0x0010}'Allow Dead',
        {0x0020}'Matching Ref - In Loaded Area',
        {0x0040}'Essential',
        {0x0080}'Allow Disabled',
        {0x0100}'Stores Text',
        {0x0200}'Allow Reserved',
        {0x0400}'Protected',
        {0x0800}'Forced by Aliases?',
        {0x1000}'Allow Destroyed',
        {0x2000}'Matching Ref - Closest',
        {0x4000}'Uses Stored Text',
        {0x8000}'Initially Disabled'
      ])),
      wbInteger('Additional Flags', itU16, wbFlags([
        {0x0001}'Allow Cleared',
        {0x0002}'Clear Names When Removed'
      ]))
    ], cpNormal, True, nil, 1)
      .SetSummaryKeyOnValue([0, 1])
      .SetSummaryDelimiterOnValue(', ')
      .IncludeFlagOnValue(dfSummaryMembersNoName);

  wbRecord(QUST, 'Quest', [
    wbEDID,
    wbVMADFragmentedQUST,
    wbFULL,
    wbStruct(DNAM, 'General', [
      wbInteger('Flags', itU16, wbFlags([
        {0x0001} 'Start Game Enabled',
        {0x0002} 'Completed',
        {0x0004} 'Add Idle topic to Hello',
        {0x0008} 'Allow repeated stages',
        {0x0010} 'Starts Enabled',
        {0x0020} 'Displayed In HUD',
        {0x0040} 'Failed',
        {0x0080} 'Stage Wait',
        {0x0100} 'Run Once',
        {0x0200} 'Exclude from dialogue export',
        {0x0400} 'Warn on alias fill failure',
        {0x0800} 'Active',
        {0x1000} 'Repeats Conditions',
        {0x2000} 'Keep Instance',
        {0x4000} 'Want Dormant',
        {0x8000} 'Has Dialogue Data'
      ])),
      wbInteger('Priority', itU8),
      wbInteger('Form Version', itU8, nil, cpIgnore),
      wbByteArray('Unknown', 4),
      wbInteger('Type', itU32, wbQuestTypeEnum)
    ], cpNormal, True),
    wbString(ENAM, 'Event', 4),
    wbRArray('Text Display Globals', wbFormIDCk(QTGL, 'Global', [GLOB])),
    wbString(FLTR, 'Object Window Filter', 0, cpTranslate),
    wbRStruct('Quest Dialogue Conditions', [wbConditions]),
    wbEmpty(NEXT, 'Marker', cpNormal, True),
    wbRStruct('Story Manager Conditions', [wbConditions]),
    wbRArrayS('Stages', wbRStructSK([0], 'Stage', [
      wbStructSK(INDX, [0], 'Stage Index', [
        wbInteger('Stage Index', itU16),
        wbInteger('Flags', itU8, wbFlags([
          {0x01} 'Unknown 1',
          {0x02} 'Start Up Stage',
          {0x04} 'Shut Down Stage',
          {0x08} 'Keep Instance Data From Here On'
        ])),
        wbInteger('Unknown', itU8)
      ]),
      wbRArray('Log Entries', wbRStruct('Log Entry', [
        wbInteger(QSDT, 'Stage Flags', itU8, wbFlags([
          {0x01} 'Complete Quest',
          {0x02} 'Fail Quest'
        ])),
        wbConditions,
        wbLStringKC(CNAM, 'Log Entry', 0, cpTranslate),
        wbFormIDCk(NAM0, 'Next Quest', [QUST]),
        {>>> BEGIN leftover from earlier CK versions <<<}
        wbByteArray(SCHR, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
        wbByteArray(SCTX, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
        wbByteArray(QNAM, 'Unused', 0, cpIgnore, false, false, wbNeverShow)
        {>>> END leftover from earlier CK versions <<<}
      ]))
    ])),
    wbRArrayS('Objectives', wbRStructSK([0], 'Objective', [
      wbInteger(QOBJ, 'Objective Index', itU16),
      wbInteger(FNAM, 'Flags', itU32, wbFlags(['ORed With Previous'])),
      wbLStringKC(NNAM, 'Display Text', 0, cpTranslate, True),
      wbRArray('Targets', wbRStruct('Target', [
        wbStruct(QSTA, 'Target', [
          wbInteger('Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbInteger('Flags', itU8, wbFlags([
            {0x01} 'Compass Marker Ignores Locks'
          ])),
          wbUnused(3)
        ]),
        wbConditions
      ]))
    ])),
    wbInteger(ANAM, 'Next Alias ID', itU32, nil, cpNormal, True),
    wbRArray('Aliases',
      wbRUnion('Alias', [

        // Reference Alias
        wbRStructSK([0], 'Alias', [
          wbInteger(ALST, 'Reference Alias ID', itU32, nil, cpNormal, True),
          wbString(ALID, 'Alias Name', 0, cpNormal, True),
          wbQUSTAliasFlags,
          wbInteger(ALFI, 'Force Into Alias When Filled', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbFormIDCk(ALFL, 'Specific Location', [LCTN]),
          wbFormID(ALFR, 'Forced Reference'),
          wbFormIDCk(ALUA, 'Unique Actor', [NPC_]),
          wbRStruct('Location Alias Reference', [
            wbInteger(ALFA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbFormIDCk(KNAM, 'Keyword', [KYWD]),
            wbFormIDCk(ALRT, 'Ref Type', [LCRT])
          ]),
          wbRStruct('External Alias Reference', [
            wbFormIDCk(ALEQ, 'Quest', [QUST]),
            wbInteger(ALEA, 'Alias', itS32, wbQuestExternalAliasToStr, wbStrToAlias)
          ]),
          wbRStruct('Create Reference to Object', [
            wbFormID(ALCO, 'Object'),
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
          ]),
          wbRStruct('Find Matching Reference Near Alias', [
            wbInteger(ALNA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbInteger(ALNT, 'Type', itU32, wbEnum([
              'Linked Ref Child'
            ]))
          ]),
          wbRStruct('Find Matching Reference From Event', [
            wbString(ALFE, 'From Event', 4),
            wbByteArray(ALFD, 'Event Data')
          ]),
          wbConditions,
          wbKeywords,
          wbCOCT,
          wbCNTOs,
          wbFormIDCk(SPOR, 'Spectator override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(OCOR, 'Observe dead body override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(GWOR, 'Guard warn override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(ECOR, 'Combat override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(ALDN, 'Display Name', [MESG]),
          wbRArray('Alias Spells', wbFormIDCk(ALSP, 'Spell', [SPEL])),
          wbRArray('Alias Factions', wbFormIDCk(ALFC, 'Faction', [FACT])),
          wbRArray('Alias Package Data', wbFormIDCk(ALPC, 'Package', [PACK])),
          wbFormIDCk(VTCK, 'Voice Types', [NPC_, FLST, NULL]),
          wbEmpty(ALED, 'Alias End', cpNormal, True)
        ], [], cpNormal, False, nil, False, nil, wbContainerAfterSet)
          .SetSummaryKey([1, 2])
          .SetSummaryDelimiter(' ')
          .SetSummaryMemberPrefixSuffix(0, 'Ref [', ']')
          .SetSummaryMemberPrefixSuffix(1, '', '')
          .SetSummaryMemberPrefixSuffix(2, '{', '}')
          .IncludeFlag(dfSummaryMembersNoName)
          .IncludeFlag(dfCollapsed),

        // Location Alias
        wbRStructSK([0], 'Alias', [
          wbInteger(ALLS, 'Location Alias ID', itU32),
          wbString(ALID, 'Alias Name'),
          wbQUSTAliasFlags,
          wbInteger(ALFI, 'Force Into Alias When Filled', itS32, wbQuestAliasToStr, wbStrToAlias),
          wbFormIDCk(ALFL, 'Specific Location', [LCTN]),
          wbFormID(ALFR, 'Forced Reference'),
          wbFormIDCk(ALUA, 'Unique Actor', [NPC_]),
          wbRStruct('Location Alias Reference', [
            wbInteger(ALFA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbFormIDCk(KNAM, 'Keyword', [KYWD]),
            wbFormIDCk(ALRT, 'Ref Type', [LCRT])
          ]),
          wbRStruct('External Alias Reference', [
            wbFormIDCk(ALEQ, 'Quest', [QUST]),
            wbInteger(ALEA, 'Alias', itS32, wbQuestExternalAliasToStr, wbStrToAlias)
          ]),
          wbRStruct('Create Reference to Object', [
            wbFormID(ALCO, 'Object'),
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
          ]),
          wbRStruct('Find Matching Reference Near Alias', [
            wbInteger(ALNA, 'Alias', itS32, wbQuestAliasToStr, wbStrToAlias),
            wbInteger(ALNT, 'Type', itU32, wbEnum([
              'Linked Ref Child'
            ]))
          ]),
          wbRStruct('Find Matching Reference From Event', [
            wbString(ALFE, 'From Event', 4),
            wbByteArray(ALFD, 'Event Data')
          ]),
          wbConditions,
          wbKeywords,
          wbCOCT,
          wbCNTOs,
          wbFormIDCk(SPOR, 'Spectator override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(OCOR, 'Observe dead body override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(GWOR, 'Guard warn override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(ECOR, 'Combat override package list', [FLST], False, cpNormal, False),
          wbFormIDCk(ALDN, 'Display Name', [MESG]),
          wbRArray('Alias Spells', wbFormIDCk(ALSP, 'Spell', [SPEL])),
          wbRArray('Alias Factions', wbFormIDCk(ALFC, 'Faction', [FACT])),
          wbRArray('Alias Package Data', wbFormIDCk(ALPC, 'Package', [PACK])),
          wbFormIDCk(VTCK, 'Voice Types', [NPC_, FLST, NULL]),
          wbEmpty(ALED, 'Alias End', cpNormal, True)
        ], [], cpNormal, False, nil, False, nil, wbContainerAfterSet)
          .SetSummaryKey([1, 2])
          .SetSummaryDelimiter(' ')
          .SetSummaryMemberPrefixSuffix(0, 'Loc [', ']')
          .SetSummaryMemberPrefixSuffix(1, '', '')
          .SetSummaryMemberPrefixSuffix(2, '{', '}')
          .IncludeFlag(dfSummaryMembersNoName)
          .IncludeFlag(dfCollapsed)
      ])
    ),
    wbString(NNAM, 'Description', 0, cpNormal, False),
    wbRArray('Targets', wbRStruct('Target', [
      wbStruct(QSTA, 'Target', [
        wbFormIDCkNoReach('Target', [ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA], True),
        wbInteger('Flags', itU8, wbFlags([
          {0x01} 'Compass Marker Ignores Locks'
        ])),
        wbByteArray('Unknown', 3)
      ]),
      wbConditions
    ]))
  ]);

  wbNoseMorphFlags := wbInteger('Nose Morph Flags', itU32, wbFlags([
    {0x00000001}'NoseType0',
    {0x00000002}'NoseType1',
    {0x00000004}'NoseType2',
    {0x00000008}'NoseType3',
    {0x00000010}'NoseType4',
    {0x00000020}'NoseType5',
    {0x00000040}'NoseType6',
    {0x00000080}'NoseType7',
    {0x00000100}'NoseType8',
    {0x00000200}'NoseType9',
    {0x00000400}'NoseType10',
    {0x00000800}'NoseType11',
    {0x00001000}'NoseType12',
    {0x00002000}'NoseType13',
    {0x00004000}'NoseType14',
    {0x00008000}'NoseType15',
    {0x00010000}'NoseType16',
    {0x00020000}'NoseType17',
    {0x00040000}'NoseType18',
    {0x00080000}'NoseType19',
    {0x00100000}'NoseType20',
    {0x00200000}'NoseType21',
    {0x00400000}'NoseType22',
    {0x00800000}'NoseType23',
    {0x01000000}'NoseType24',
    {0x02000000}'NoseType25',
    {0x04000000}'NoseType26',
    {0x08000000}'NoseType27',
    {0x10000000}'NoseType28',
    {0x20000000}'NoseType29',
    {0x40000000}'NoseType30',
    {0x80000000}'NoseType31'
  ]));

  wbBrowMorphFlags := wbInteger('Brow Morph Flags', itU32, wbFlags([
    {0x00000001}'BrowType0',
    {0x00000002}'BrowType1',
    {0x00000004}'BrowType2',
    {0x00000008}'BrowType3',
    {0x00000010}'BrowType4',
    {0x00000020}'BrowType5',
    {0x00000040}'BrowType6',
    {0x00000080}'BrowType7',
    {0x00000100}'BrowType8',
    {0x00000200}'BrowType9',
    {0x00000400}'BrowType10',
    {0x00000800}'BrowType11',
    {0x00001000}'BrowType12',
    {0x00002000}'BrowType13',
    {0x00004000}'BrowType14',
    {0x00008000}'BrowType15',
    {0x00010000}'BrowType16',
    {0x00020000}'BrowType17',
    {0x00040000}'BrowType18',
    {0x00080000}'BrowType19',
    {0x00100000}'BrowType20'
  ], True));

  wbEyesMorphFlags01 := wbInteger('Eye Morph Flags 1', itU32, wbFlags([
    {0x00000001}'EyesType0',
    {0x00000002}'EyesType1',
    {0x00000004}'EyesType2',
    {0x00000008}'EyesType3',
    {0x00000010}'EyesType4',
    {0x00000020}'EyesType5',
    {0x00000040}'EyesType6',
    {0x00000080}'EyesType7',
    {0x00000100}'EyesType8',
    {0x00000200}'EyesType9',
    {0x00000400}'EyesType10',
    {0x00000800}'EyesType11',
    {0x00001000}'EyesType12',
    {0x00002000}'EyesType13',
    {0x00004000}'EyesType14',
    {0x00008000}'EyesType15',
    {0x00010000}'EyesType16',
    {0x00020000}'EyesType17',
    {0x00040000}'EyesType18',
    {0x00080000}'EyesType19',
    {0x00100000}'EyesType20',
    {0x00200000}'EyesType21',
    {0x00400000}'EyesType22',
    {0x00800000}'EyesType23',
    {0x01000000}'EyesType24',
    {0x02000000}'EyesType25',
    {0x04000000}'EyesType26',
    {0x08000000}'EyesType27',
    {0x10000000}'EyesType28',
    {0x20000000}'EyesType29',
    {0x40000000}'EyesType30',
    {0x80000000}'EyesType31'
  ]));

  wbEyesMorphFlags02 := wbInteger('Eye Morph Flags 2', itU8, wbFlags([
    {0x00000001}'EyesType32',
    {0x00000002}'EyesType33',
    {0x00000004}'EyesType34',
    {0x00000008}'EyesType35',
    {0x00000010}'EyesType36',
    {0x00000020}'EyesType37',
    {0x00000040}'EyesType38'
  ], True));

  wbLipMorphFlags := wbInteger('Lip Morph Flags', itU32, wbFlags([
    {0x00000001}'LipType0',
    {0x00000002}'LipType1',
    {0x00000004}'LipType2',
    {0x00000008}'LipType3',
    {0x00000010}'LipType4',
    {0x00000020}'LipType5',
    {0x00000040}'LipType6',
    {0x00000080}'LipType7',
    {0x00000100}'LipType8',
    {0x00000200}'LipType9',
    {0x00000400}'LipType10',
    {0x00000800}'LipType11',
    {0x00001000}'LipType12',
    {0x00002000}'LipType13',
    {0x00004000}'LipType14',
    {0x00008000}'LipType15',
    {0x00010000}'LipType16',
    {0x00020000}'LipType17',
    {0x00040000}'LipType18',
    {0x00080000}'LipType19',
    {0x00100000}'LipType20',
    {0x00200000}'LipType21',
    {0x00400000}'LipType22',
    {0x00800000}'LipType23',
    {0x01000000}'LipType24',
    {0x02000000}'LipType25',
    {0x04000000}'LipType26',
    {0x08000000}'LipType27',
    {0x10000000}'LipType28',
    {0x20000000}'LipType29',
    {0x40000000}'LipType30',
    {0x80000000}'LipType31'
  ]));

  wbTintMaskTypeEnum := wbEnum([
    'None',
    'Lip Color',
    'Cheek Color',
    'Eyeliner',
    'EyeSocket Upper',
    'EyeSocket Lower',
    'Skin Tone',
    'Paint',
    'Laugh Lines',
    'Cheek Color Lower',
    'Nose',
    'Chin',
    'Neck',
    'Forehead',
    'Dirt',
    'Unknown 16'
  ]);

  wbTints := wbRArray('Tint Masks', wbRStruct('Tint Assets', [
    wbRArray('Tint Layer', wbRStruct('Texture', [
      wbInteger(TINI, 'Index', itU16),
      wbString(TINT, 'File Name'),
      {>>> When set to None TINP does not exist Needs routine to add when
      changing the Mask Type <<<}
      wbInteger(TINP, 'Mask Type', itU16, wbTintMaskTypeEnum),
      wbFormIDCk(TIND, 'Preset Default', [CLFM, NULL])
    ])),
    wbRArray('Presets', wbRStruct('Preset', [
      wbFormIDCk(TINC, 'Color', [CLFM, NULL]),
      wbFloat(TINV, 'Default Value'),
      wbInteger(TIRS, 'Index', itU16)
    ]))
  ]));

  wbRACE_DATAFlags01 := wbInteger('Flags', itU32, wbFlags([
    {0x00000001}'Playable',
    {0x00000002}'FaceGen Head',
    {0x00000004}'Child',
    {0x00000008}'Tilt Front/Back',
    {0x00000010}'Tilt Left/Right',
    {0x00000020}'No Shadow',
    {0x00000040}'Swims',
    {0x00000080}'Flies',
    {0x00000100}'Walks',
    {0x00000200}'Immobile',
    {0x00000400}'Not Pushable',
    {0x00000800}'No Combat In Water',
    {0x00001000}'No Rotating to Head-Track',
    {0x00002000}'Don''t Show Blood Spray',
    {0x00004000}'Don''t Show Blood Decal',
    {0x00008000}'Uses Head Track Anims',
    {0x00010000}'Spells Align w/Magic Node',
    {0x00020000}'Use World Raycasts For FootIK',
    {0x00040000}'Allow Ragdoll Collision',
    {0x00080000}'Regen HP In Combat',
    {0x00100000}'Can''t Open Doors',
    {0x00200000}'Allow PC Dialogue',
    {0x00400000}'No Knockdowns',
    {0x00800000}'Allow Pickpocket',
    {0x01000000}'Always Use Proxy Controller',
    {0x02000000}'Don''t Show Weapon Blood',
    {0x04000000}'Overlay Head Part List', {>>>Only one can be active<<<}
    {0x08000000}'Override Head Part List', {>>>Only one can be active<<<}
    {0x10000000}'Can Pickup Items',
    {0x20000000}'Allow Multiple Membrane Shaders',
    {0x40000000}'Can Dual Wield',
    {0x80000000}'Avoids Roads'
  ]));

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
    wbFloat('W')
  ], cpNormal, False, nil, 8);

  wbPHWT := wbRStruct('FaceFX Phonemes', [
    wbRStruct('IY', [wbPhonemeTargets]),
    wbRStruct('IH', [wbPhonemeTargets]),
    wbRStruct('EH', [wbPhonemeTargets]),
    wbRStruct('EY', [wbPhonemeTargets]),
    wbRStruct('AE', [wbPhonemeTargets]),
    wbRStruct('AA', [wbPhonemeTargets]),
    wbRStruct('AW', [wbPhonemeTargets]),
    wbRStruct('AY', [wbPhonemeTargets]),
    wbRStruct('AH', [wbPhonemeTargets]),
    wbRStruct('AO', [wbPhonemeTargets]),
    wbRStruct('OY', [wbPhonemeTargets]),
    wbRStruct('OW', [wbPhonemeTargets]),
    wbRStruct('UH', [wbPhonemeTargets]),
    wbRStruct('UW', [wbPhonemeTargets]),
    wbRStruct('ER', [wbPhonemeTargets]),
    wbRStruct('AX', [wbPhonemeTargets]),
    wbRStruct('S',  [wbPhonemeTargets]),
    wbRStruct('SH', [wbPhonemeTargets]),
    wbRStruct('Z',  [wbPhonemeTargets]),
    wbRStruct('ZH', [wbPhonemeTargets]),
    wbRStruct('F',  [wbPhonemeTargets]),
    wbRStruct('TH', [wbPhonemeTargets]),
    wbRStruct('V',  [wbPhonemeTargets]),
    wbRStruct('DH', [wbPhonemeTargets]),
    wbRStruct('M',  [wbPhonemeTargets]),
    wbRStruct('N',  [wbPhonemeTargets]),
    wbRStruct('NG', [wbPhonemeTargets]),
    wbRStruct('L',  [wbPhonemeTargets]),
    wbRStruct('R',  [wbPhonemeTargets]),
    wbRStruct('W',  [wbPhonemeTargets]),
    wbRStruct('Y',  [wbPhonemeTargets]),
    wbRStruct('HH', [wbPhonemeTargets]),
    wbRStruct('B',  [wbPhonemeTargets]),
    wbRStruct('D',  [wbPhonemeTargets]),
    wbRStruct('JH', [wbPhonemeTargets]),
    wbRStruct('G',  [wbPhonemeTargets]),
    wbRStruct('P',  [wbPhonemeTargets]),
    wbRStruct('T',  [wbPhonemeTargets]),
    wbRStruct('K',  [wbPhonemeTargets]),
    wbRStruct('CH', [wbPhonemeTargets]),
    wbRStruct('SIL', [wbPhonemeTargets]),
    wbRStruct('SHOTSIL', [wbPhonemeTargets]),
    wbRStruct('FLAP', [wbPhonemeTargets])
  ]);

  wbMorphs := wbRStruct('Available Morphs', [
    wbByteArray(MPAI, 'Unknown', 0),
    wbStruct(MPAV, 'Nose Variants', [
      wbNoseMorphFlags,
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4)
    ]),
    wbByteArray(MPAI, 'Unknown', 0),
    wbStruct(MPAV, 'Brow Variants', [
      wbBrowMorphFlags,
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4)
    ]),
    wbByteArray(MPAI, 'Unknown', 0),
    wbStruct(MPAV, 'Eye Variants', [
      wbEyesMorphFlags01,
      wbEyesMorphFlags02,
      wbByteArray('Unknown', 3),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4)
    ]),
    wbByteArray(MPAI, 'Unknown', 0),
    wbStruct(MPAV, 'Lip Variants', [
      wbLipMorphFlags,
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4),
      wbByteArray('Unknown', 4)
    ])
  ]);

  var wbHeadParts :=
    wbRArrayS('Head Parts', wbHeadPart, cpNormal);

  var wbBodyParts :=
    wbRArrayS('Parts',
      wbRStructSK([0], 'Part', [
        wbUnused(INDX, 0),
        wbGenericModel
      ])
      .SetSummaryKey([0, 1])
      .SetSummaryMemberPrefixSuffix(0, '[', ']')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryMembersNoName)
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfCollapsed, wbCollapseBodyParts)
    , cpNormal, True);

  wbRecord(RACE, 'Race',
    wbFlags(wbFlagsList([
      19, 'Critter?'
    ])), [
    wbEDID,
    wbFULL,
    wbDESCReq,
    wbSPCT,
    wbSPLOs,
    wbFormIDCk(WNAM, 'Skin', [ARMO, NULL]),
    wbBODTBOD2,
    wbKeywords,
    wbStruct(DATA, '', [
      wbArrayS('Skill Boosts', wbStructSK([0], 'Skill Boost', [
        wbInteger('Skill', itS8, wbActorValueEnum),
        wbInteger('Boost', itS8)
      ]).SetSummaryKey([1, 0])
      .SetSummaryMemberPrefixSuffix(1, '+', '')
      .SetSummaryMemberPrefixSuffix(0, '', '')
      .SetSummaryDelimiter(' ')
      .IncludeFlag(dfSummaryNoSortKey)
      .IncludeFlag(dfSummaryMembersNoName).IncludeFlag(dfCollapsed), 7),
      wbByteArray('Unknown', 2),
      wbFloat('Male Height'),
      wbFloat('Female Height'),
      wbFloat('Male Weight'),
      wbFloat('Female Weight'),
      wbRACE_DATAFlags01,
      wbFloat('Starting Health'),
      wbFloat('Starting Magicka'),
      wbFloat('Starting Stamina'),
      wbFloat('Base Carry Weight'),
      wbFloat('Base Mass'),
      wbFloat('Acceleration rate'),
      wbFloat('Deceleration rate'),
      wbInteger('Size', itU32, wbEnum([
        'Small',
        'Medium',
        'Large',
        'Extra Large'
      ])),
      wbInteger('Head Biped Object', itS32, wbBipedObjectEnum),
      wbInteger('Hair Biped Object', itS32, wbBipedObjectEnum),
      wbFloat('Injured Health Pct'),
      wbInteger('Shield Biped Object', itS32, wbBipedObjectEnum),
      wbFloat('Health Regen'),
      wbFloat('Magicka Regen'),
      wbFloat('Stamina Regen'),
      wbFloat('Unarmed Damage'),
      wbFloat('Unarmed Reach'),
      wbInteger('Body Biped Object', itS32, wbBipedObjectEnum),
      wbFloat('Aim Angle Tolerance'),
      wbFloat('Flight Radius'),
      wbFloat('Angular Acceleration Rate'),
      wbFloat('Angular Tolerance'),
      wbInteger('Flags 2', itU32, wbFlags([
        {0x00000001} 'Use Advanced Avoidance',
        {0x00000002} 'Non-Hostile',
        {0x00000004} 'Unknown 2',
        {0x00000008} 'Unknown 3',
        {0x00000010} 'Allow Mounted Combat'
      ])),
      wbStruct('Mount Data', [
        wbFloat('Mount Offset X', cpNormal, False, 1, -1, nil, nil, -63.479000),
        wbFloat('Mount Offset Y'),
        wbFloat('Mount Offset Z'),
        wbFloat('Dismount Offset X', cpNormal, False, 1, -1, nil, nil, -50.0),
        wbFloat('Dismount Offset Y'),
        wbFloat('Dismount Offset Z', cpNormal, False, 1, -1, nil, nil, 65.0),
        wbFloat('Mount Camera Offset X'),
        wbFloat('Mount Camera Offset Y', cpNormal, False, 1, -1, nil, nil, -300.0),
        wbFloat('Mount Camera Offset Z')
      ])
      //wbByteArray('Unknown', 4*7)
    ], cpNormal, True, nil, 29),
    wbEmpty(MNAM, 'Male Marker').SetRequired,
    wbString(ANAM, 'Male Skeletal Model'),
    wbMODT,
    wbEmpty(FNAM, 'Female Marker').SetRequired,
    wbString(ANAM, 'Female Skeletal Model'),
    wbMODT,
    wbEmpty(NAM2, 'Marker NAM2 #1'),
    wbRArrayS('Movement Type Names', wbString(MTNM, 'Name', 4)).SetDefaultEditValues(['BLDO', 'RUN1', 'SNEK', 'SWIM', 'WALK']).SetRequired,
    wbArray(VTCK, 'Voices', wbFormIDCk('Voice', [VTYP]), ['Male', 'Female'], cpNormal, True).SetDefaultEditValues(['MaleUniqueMolagBal [VTYP:0000002D]', 'FemaleUniqueAzura [VTYP:0000002E]']),
    wbArray(DNAM, 'Decapitate Armors', wbFormIDCk('Decapitate Armor', [NULL, ARMO]), ['Male', 'Female'], cpNormal, False),
    wbArray(HCLF, 'Default Hair Colors', wbFormIDCk('Default Hair Color', [NULL, CLFM]), ['Male', 'Female'], cpNormal, False),
    wbInteger(TINL, 'Total Number of Tints in List', itU16, nil, nil, cpNormal, False), {>>> Needs Count Updated <<<}
    wbFloat(PNAM, 'FaceGen - Main clamp', cpNormal, True).SetDefaultNativeValue(5.0),
    wbFloat(UNAM, 'FaceGen - Face clamp', cpNormal, True).SetDefaultNativeValue(5.0),
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
    wbArrayS(HNAM, 'Hairs', wbFormIDCk('Hair', [HDPT, NULL]), 0, cpNormal),
    wbArrayS(ENAM, 'Eyes', wbFormIDCk('Eye', [EYES, NULL]),  0,  cpNormal),
    wbFormIDCk(GNAM, 'Body Part Data', [BPTD, NULL]).SetDefaultEditValue('DefaultBodyPartData [BPTD:0000001D]').SetRequired,
    wbEmpty(NAM2, 'Marker NAM2 #2', cpNormal),
    wbEmpty(NAM3, 'Marker NAM3 #3', cpNormal, True),
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
    .IncludeFlag(dfCollapsed, wbCollapseModels),
    wbFormIDCk(NAM4, 'Material Type', [MATT, NULL]),
    wbFormIDCk(NAM5, 'Impact Data Set', [IPDS, NULL]),
    wbFormIDCk(NAM7, 'Decapitation FX', [ARTO, NULL]),
    wbFormIDCk(ONAM, 'Open Loot Sound', [SNDR, NULL]),
    wbFormIDCk(LNAM, 'Close Loot Sound', [SNDR, NULL]),
    {>>> When NAME is user defined wbBipedObjectEnum will be incorrect <<<}
    wbRArray('Biped Object Names', wbString(NAME, 'Name'), 32).IncludeFlag(dfNotAlignable).SetRequired,
    wbRArrayS('Movement Types', wbRStructSK([0], 'Movement Types', [
      wbFormIDCk(MTYP, 'Movement Type', [MOVT, NULL]),
      wbStruct(SPED, 'Override Values', [
        wbFloat('Left - Walk'),
        wbFloat('Left - Run'),
        wbFloat('Right - Walk'),
        wbFloat('Right - Run'),
        wbFloat('Forward - Walk'),
        wbFloat('Forward - Run'),
        wbFloat('Back - Walk'),
        wbFloat('Back - Run'),
        wbFloat('Rotate - Walk'),
        wbFloat('Rotate - Walk'),
        wbFloat('Unknown')
      ])
    ])),
    wbInteger(VNAM, 'Equipment Flags', itU32, wbEquipType).SetRequired,
    wbRArrayS('Equip Slots', wbFormIDCk(QNAM, 'Equip Slot', [EQUP, NULL])),
    wbFormIDCk(UNES, 'Unarmed Equip Slot', [EQUP, NULL]),
    wbRArray('Phoneme Target Names', wbString(PHTN, 'Name')),
    wbPHWT,
    wbFormIDCk(WKMV, 'Base Movement Default - Walk', [MOVT, NULL]),
    wbFormIDCk(RNMV, 'Base Movement Default - Run', [MOVT, NULL]),
    wbFormIDCk(SWMV, 'Base Movement Default - Swim', [MOVT, NULL]),
    wbFormIDCk(FLMV, 'Base Movement Default - Fly', [MOVT, NULL]),
    wbFormIDCk(SNMV, 'Base Movement Default - Sneak', [MOVT, NULL]),
    wbFormIDCk(SPMV, 'Base Movement Default - Sprint', [MOVT, NULL]),
    // Start Head Data
    wbRStruct('Head Data', [
      wbEmpty(NAM0, 'Head Data Marker', cpNormal, True),
      wbRStruct('Male Head Data', [
        wbEmpty(MNAM, 'Male Data Marker', cpNormal, True),
          wbHeadParts,
          wbMorphs,
          wbRArrayS('Race Presets Male', wbFormIDCk(RPRM, 'Preset NPC', [NPC_, NULL])),
          wbRArrayS('Available Hair Colors Male', wbFormIDCk(AHCM, 'Hair Color', [CLFM, NULL])),
          wbRArrayS('Face Details Texture Set List Male', wbFormIDCk(FTSM, 'Texture Set', [TXST, NULL])),
          wbFormIDCk(DFTM, 'Default Face Texture Male', [TXST, NULL]),
          wbTints,
          wbGenericModel
      ], [], cpNormal, True),
      wbRStruct('Female Head Data', [
        wbEmpty(NAM0, 'Head Data Marker', cpNormal, True),
        wbEmpty(FNAM, 'Female Data Marker', cpNormal, True),
          wbHeadParts,
          wbMorphs,
          wbRArrayS('Race Presets Female', wbFormIDCk(RPRF, 'Preset NPC', [NPC_, NULL])),
          wbRArrayS('Available Hair Colors Female', wbFormIDCk(AHCF, 'Hair Color', [CLFM, NULL])),
          wbRArrayS('Face Details Texture Set List Female', wbFormIDCk(FTSF, 'Texture Set', [TXST, NULL])),
          wbFormIDCk(DFTF, 'Default Face Texture Female', [TXST, NULL]),
          wbTints,
          wbGenericModel
      ], [], cpNormal, True)
    ], [], cpNormal, False),
    // End Head Data
    wbFormIDCk(NAM8, 'Morph race', [RACE, NULL]),
    wbFormIDCk(RNAM, 'Armor race', [RACE, NULL])
  ], False, nil, cpNormal, False, wbRACEAfterLoad, wbRACEAfterSet);

  wbRefRecord(REFR, 'Placed Object', wbFormaterUnion(wbREFRRecordFlagsDecider, [
    wbFlags(wbFlagsList([
      10, 'Persistent',
      11, 'Initially Disabled',
      16, 'Is Full LOD',
      26, 'Filter (Collision Geometry)',
      27, 'Bounding Box (Collision Geometry)',
      28, 'Reflected By Auto Water',
      30, 'Ground',
      31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {ACTI STAT TREE FLOR}
      9, 'Hidden From Local Map',
     10, 'Persistent',
     11, 'Initially Disabled',
     13, 'Sky Marker',
     15, 'Visible when distant',
     16, 'Is Full LOD',
     26, 'Filter (Collision Geometry)',
     27, 'Bounding Box (Collision Geometry)',
     28, 'Reflected By Auto Water',
     29, 'Don''t Havok Settle',
     30, 'No Respawn',
     31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {CONT}
      10, 'Persistent',
      11, 'Initially Disabled',
      16, 'Is Full LOD',
      25, 'No AI Acquire',
      26, 'Filter (Collision Geometry)',
      27, 'Bounding Box (Collision Geometry)',
      28, 'Reflected By Auto Water',
      29, 'Don''t Havok Settle',
      30, 'Ground',
      31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {DOOR}
      6, 'Hidden From Local Map',
      8, 'Inaccessible',
     10, 'Persistent',
     11, 'Initially Disabled',
     16, 'Is Full LOD',
     26, 'Filter (Collision Geometry)',
     27, 'Bounding Box (Collision Geometry)',
     28, 'Reflected By Auto Water',
     29, 'Don''t Havok Settle',
     30, 'No Respawn',
     31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {LIGH}
      8, 'Doesn''t Light Water',
      9, 'Casts Shadows',
     10, 'Persistent',
     11, 'Initially Disabled',
     16, 'Never Fades',
     17, 'Doesn''t Light Landscape',
     25, 'No AI Acquire',
     28, 'Reflected By Auto Water',
     29, 'Don''t Havok Settle',
     30, 'No Respawn',
     31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {MSTT}
      9, 'Motion Blur',
     10, 'Persistent',
     11, 'Initially Disabled',
     16, 'Is Full LOD',
     26, 'Filter (Collision Geometry)',
     27, 'Bounding Box (Collision Geometry)',
     28, 'Reflected By Auto Water',
     29, 'Don''t Havok Settle',
     30, 'No Respawn',
     31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {ADDN}
      10, 'Persistent',
      11, 'Initially Disabled',
      16, 'Is Full LOD',
      28, 'Reflected By Auto Water',
      29, 'Don''t Havok Settle',
      30, 'No Respawn',
      31, 'Multibound'
    ], True, True)),
    wbFlags(wbFlagsList([ {ALCH SCRL AMMO ARMO INGR KEYM MISC SLGM WEAP}
      10, 'Persistent',
      11, 'Initially Disabled',
      16, 'Is Full LOD',
      25, 'No AI Acquire',
      28, 'Reflected By Auto Water',
      29, 'Don''t Havok Settle',
      30, 'No Respawn',
      31, 'Multibound'
    ], True, True))
  ]), [
    wbEDID,
    wbVMAD,
    wbFormIDCk(NAME, 'Base', [
      TREE, SNDR, ACTI, DOOR, STAT, FURN, CONT, ARMO, AMMO, LVLN, LVLC,
      MISC, WEAP, BOOK, KEYM, ALCH, LIGH, GRAS, ASPC, IDLM, ARMA, INGR,
      MSTT, TACT, TXST, FLOR, SLGM, SCRL, SOUN, APPA, SPEL, ARTO, ADDN
    ], False, cpNormal, True),

    {--- Bound Contents ---}
    {--- Bound Data ---}
    wbVec3(XMBO, 'Bound Half Extents'),

    {--- Primitive ---}
    wbStruct(XPRM, 'Primitive', [
      wbStruct('Bounds', [
        wbFloat('X', cpNormal, True, 2, 4),
        wbFloat('Y', cpNormal, True, 2, 4),
        wbFloat('Z', cpNormal, True, 2, 4)
      ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
      wbFloatColors('Color'),
      wbFloat('Unknown'),
      wbInteger('Type', itU32, wbEnum([
        'None',
        'Box',
        'Sphere',
        'Portal Box',
        'Unknown 4'
      ]))
    ]),
    // Copied from FO3; assuming that the order is the same
    wbArray(XORD, 'Linked Occlusion References', wbFormIDCk('Reference', [REFR, NULL]), [
      'Right',
      'Left',
      'Bottom',
      'Top'
    ]),
    wbSizePosRot(XOCP, 'Occlusion Plane Data'),

    wbArray(XPOD, 'Portal Data', wbStruct('References', [
      wbFormIDCk('Origin', [REFR, NULL]),
      wbFormIDCk('Destination', [REFR, NULL])
    ])),
    wbSizePosRot(XPTL, 'Room Portal (unused)', cpIgnore), // removed by CK

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
    ]),
    wbEmpty(XMBP, 'MultiBound Primitive Marker', cpIgnore),

    wbRagdoll,
    wbFloat(XRDS, 'Radius'),

    {--- Reflected By / Refracted By ---}
    wbRArrayS('Reflected/Refracted By',
      wbStructSK(XPWR, [0], 'Water', [
        wbFormIDCk('Reference', [REFR]),
        wbInteger('Type', itU32, wbFlags([
          'Reflection',
          'Refraction'
        ]))
      ], cpNormal, False, nil, 1)
    ),

    {--- Lit Water ---}
    wbRArrayS('Lit Water',
      wbFormIDCk(XLTW, 'Water', [REFR])
    ),

    {--- Emittance ---}
    wbFormIDCk(XEMI, 'Emittance', [LIGH, REGN]),
    wbStruct(XLIG, 'Light Data', [
      wbFloat('FOV 90+/-'),
      wbFloat('Fade 1.35+/-'),
      wbFloat('End Distance Cap'),
      wbFloat('Shadow Depth Bias'),
      wbByteArray('Unknown', 4) // optional
    ], cpNormal, False, nil, 4),
    wbStruct(XALP, 'Alpha', [
      wbInteger('Cutoff', itU8),
      wbInteger('Base', itU8)
    ]),

    {--- Teleport ---}
    wbStruct(XTEL, 'Teleport Destination', [
      wbFormIDCk('Door', [REFR], True),
      wbPosRot,
      wbInteger('Flags', itU32, wbFlags([
        'No Alarm'
      ]))
    ]),
    wbFormIDCk(XTNM, 'Teleport Message Box', [MESG]),

    {--- MultiBound ---}
    wbFormIDCk(XMBR, 'MultiBound Reference', [REFR]),

    wbInteger(XWCN, 'Water Current Count', itU32, nil, cpBenign),
    wbInteger(XWCS, 'Water Current Count (Old)', itU32, nil, cpBenign),
    wbStruct(XWCU, 'Water Currents', [
      wbVec3('Linear Velocity'),
      wbByteArray('Unknown', 4),
      wbVec3('Angular Velocity'),
      wbByteArray('Unknown', 4),
      wbVec3('Unknown Velocity'),
      wbByteArray('Unknown', 4)
    ])
    .IncludeFlag(dfCollapsed),
    wbVec3(XCVL,'Water Current Linear Velocity'),
    wbVec3(XCVR,'Water Current Rotational Velocity'),
    wbFormIDCk(XCZC, 'Water Current Zone Cell', [CELL, NULL]),
    wbFormIDCk(XCZR, 'Water Current Zone Reference', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
    wbByteArray(XCZA, 'Water Current Zone Action', 4),
    wbXSCL,
    wbFormIDCk(XSPC, 'Spawn Container', [REFR]),

    {--- Activate Parents ---}
    wbRStruct('Activate Parents', [
      wbInteger(XAPD, 'Flags', itU8, wbFlags([
        'Parent Activate Only'
      ], True)),
      wbRArrayS('Activate Parent Refs',
        wbStructSK(XAPR, [0], 'Activate Parent Ref', [
          wbFormIDCk('Reference', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
          wbFloat('Delay')
        ])
      )
    ]),

    wbFormIDCk(XLIB, 'Leveled Item Base Object', [LVLI]),
    wbXLCM,
    wbFormIDCk(XLCN, 'Persist Location', [LCTN]),

    {>>> COLL form Index value <<<}
    wbInteger(XTRI, 'Collision Layer', itU32),

    {--- Lock ---}
    {>>Lock Tab for REFR when 'Locked' is Unchecked this record is not present <<<}
    wbStruct(XLOC, 'Lock Data', [
      wbInteger('Level', itU8, wbEnum([], [
         1, 'Novice',
        25, 'Apprentice',
        50, 'Adept',
        75, 'Expert',
       100, 'Master',
       255, 'Requires Key'
      ])),
      wbUnused(3),
      wbFormIDCkNoReach('Key', [KEYM, NULL]),
      wbInteger('Flags', itU8, wbFlags(['', '', 'Leveled Lock'])),
      wbUnused(3),
      wbUnused(8)
    ], cpNormal, False, nil, 4),

    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),

    {--- Generated Data ---}
    wbStruct(XNDP, 'Navmesh Door Link', [
      wbFormIDCk('Navmesh', [NAVM]),
      wbInteger('Triangle', itS16, wbREFRNavmeshTriangleToStr, wbStringToInt),
      wbUnused(2)
    ]),

    wbArray(XLRT, 'Location Ref Type', wbFormIDCk('Ref', [LCRT, NULL])),
    wbEmpty(XIS2, 'Ignored by Sandbox'),

    {--- Ownership ---}
    wbOwnership([XRGD]),

    wbInteger(XCNT, 'Item Count', itS32),
    wbFloat(XCHG, 'Charge'),
    wbFormIDCk(XLRL, 'Location Reference', [LCRT, LCTN, NULL], False, cpBenignIfAdded),

    wbXESP,
    wbRArray('Linked References', wbStruct(XLKR, 'Linked Reference', [
      wbFormIDCk('Keyword/Ref', [KYWD, PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA, NULL]),
      wbFormIDCk('Ref', [PLYR, ACHR, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA])
    ], cpNormal, False, nil, 1)),

    wbRArray('Patrol', wbRStruct('Data', [
      wbFloat(XPRD, 'Idle Time', cpNormal, True),
      wbEmpty(XPPA, 'Patrol Script Marker', cpNormal, True),
      wbFormIDCk(INAM, 'Idle', [IDLE, NULL], False, cpNormal, True),
      wbByteArray(SCHR, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbByteArray(SCTX, 'Unused', 0, cpIgnore, false, false, wbNeverShow),
      wbPDTOs
    ])),

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
        {0x04} '"Show All" Hidden'
      ]), cpNormal, True),
      wbFULLReq,
      wbStruct(TNAM, '', [
        wbInteger('Type', itU8, wbMapMarkerEnum),
        wbUnused(1)
      ], cpNormal, True)
    ]),
    {--- Attach reference ---}
    wbFormIDCk(XATR, 'Attach Ref', [REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
    wbXLOD,
    wbDataPosRot
  ], True)
    .SetAddInfo(wbPlacedAddInfo)
    .SetAfterLoad(wbREFRAfterLoad);

  wbRecord(REGN, 'Region',
    wbFlags(wbFlagsList([
      6, 'Border Region'
    ])), [
    wbEDID,
    wbByteColors(RCLR, 'Map Color'),
    {>>> Skyrim.esm has some incorrect FormIDs here, probably leftover <<<}
    wbFormIDCkNoReach(WNAM, 'Worldspace', [WRLD]),
    wbRegionAreas,
    wbRArrayS('Region Data Entries', wbRStructSK([0], 'Region Data Entry', [
      {always starts with an RDAT}
      wbStructSK(RDAT, [0], 'Data Header', [
        wbInteger('Type', itU32,
          wbEnum([], [
            2, 'Objects',
            3, 'Weather',
            4, 'Map',
            5, 'Land',
            6, 'Grass',
            7, 'Sound'
          ])
        ),
        wbInteger('Override', itU8, wbBoolEnum),
        wbInteger('Priority', itU8),
        wbByteArray('Unknown')
      ], cpNormal, True),

      {--- Icon ---}
      wbICON,

      {--- Sound ---}
      wbFormIDCk(RDMO, 'Music', [MUSC], False, cpNormal, False, wbREGNSoundDontShow),
      wbRegionSounds,

      {--- Map ---}
      wbLString(RDMP, 'Map Name', 0, cpTranslate, False, wbREGNMapDontShow),

      {followed by one of these: }

      {--- Objects ---}
      wbArray(RDOT, 'Objects', wbStruct('Object', [
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
        ]).SetToStr(wbVec3ToStr).IncludeFlag(dfCollapsed, wbCollapseVec3),
        wbByteArray('Unknown', 2),
        wbByteArray('Unknown', 4)
      ]), 0, nil, nil, cpNormal, False, wbREGNObjectsDontShow),

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
      ]), 0, cpNormal, False, nil, nil, wbREGNWeatherDontShow)

    ]))
  ], True);

  wbRecord(SOUN, 'Sound Marker', [
    wbEDID,
    wbOBND(True),
    wbUnknown(FNAM, cpIgnore), // leftover, unused
    wbUnknown(SNDD, cpIgnore), // leftover, unused
    wbFormIDCk(SDSC, 'Sound Descriptor', [SNDR, NULL])
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
      {0x00040000} 'Unknown 19',
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
      {6} 'Unknown 6',
      {7} 'Unknown 7',
      {8} 'Unknown 8',
      {9} 'Unknown 9',
     {10} 'Addiction',
     {11} 'Voice'
    ])),
    wbFloat('Charge Time'),
    wbInteger('Cast Type', itU32, wbCastEnum),
    wbInteger('Target Type', itU32, wbTargetEnum),
    wbFloat('Cast Duration'),
    wbFloat('Range'),
    wbFormIDCk('Half-cost Perk', [NULL, PERK])
  ], cpNormal, True);

  wbRecord(SPEL, 'Spell', [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbKeywords,
    wbMDOB,
    wbETYP,
    wbDESCReq,
    wbSPIT,
    wbEffectsReq
  ]);

  wbRecord(SCRL, 'Scroll', [
    wbEDID,
    wbOBND(True),
    wbFULL,
    wbKeywords,
    wbMDOB,
    wbETYP,
    wbDESC,
    wbGenericModel,
    wbDEST,
    wbYNAM,
    wbZNAM,
    wbStruct(DATA, 'Item', [
      wbInteger('Value', itU32),
      wbFloat('Weight')
    ], cpNormal, True),
    wbSPIT,
    wbEffectsReq
  ]);

  wbRecord(STAT, 'Static',
    wbFlags(wbFlagsList([
      2, 'Never Fades',
      6, 'Has Tree LOD',
      7, 'Add-On LOD Object',
      9, 'Hidden From Local Map',
     11, 'Unknown 11', // present in Skyrim.esm but can't be set
     15, 'Has Distant LOD',
     16, 'Unknown 16', // present in Skyrim.esm but can't be set
     17, 'Uses HD LOD Texture',
     19, 'Has Currents',
     23, 'Is Marker',
     25, 'Obstacle',
     26, 'Navmesh - Filter',
     27, 'Navmesh - Bounding Box',
     28, 'Show In World Map',
     30, 'Navmesh - Ground'
    ])).SetFlagHasDontShow(26, wbFlagNavmeshFilterDontShow)
       .SetFlagHasDontShow(27, wbFlagNavmeshBoundingBoxDontShow)
       .SetFlagHasDontShow(30, wbFlagNavmeshGroundDontShow), [
    wbEDID,
    wbOBND(True),
    wbGenericModel,
    wbStruct(DNAM, 'Direction Material', [
      wbFloat('Max Angle (30-120)'),
      wbFormIDCk('Material', [MATO, NULL]),
      IsSSE(
        wbInteger('Considered Snow', itU8, wbBoolEnum),
        nil),
      IsSSE(
        wbUnused(3),
        nil)
    ], cpNormal, True, nil, 2),
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
    ),
    wbUnknown(ENAM)
  ]);

  wbRecord(TES4, 'Main File Header',
    wbFlags(wbFlagsList([
      0, 'ESM',
      1, 'Altered',
      2, 'Checked',
      3, 'Active',
      4, 'Optimized',
      5, 'Temp ID Owner',
      7, 'Localized',
      8, 'Precalc Data Only',
      9, IsSSE('ESL', '')
    ], False), True), [
    wbHEDR,
    wbByteArray(OFST, 'Unknown', 0, cpIgnore),
    wbByteArray(DELE, 'Unknown', 0, cpIgnore),
    wbString(CNAM, 'Author', 0, cpTranslate, True),
    wbString(SNAM, 'Description', 0, cpTranslate),
    wbRArray('Master Files', wbRStruct('Master File', [
      wbStringForward(MAST, 'FileName', 0, cpNormal, True),
      wbByteArray(DATA, 'Unknown', 8, cpIgnore, True)
    ], [ONAM])).IncludeFlag(dfInternalEditOnly, not wbAllowMasterFilesEdit),
    wbArray(ONAM, 'Overridden Forms',
      wbFormIDCk('Form', [ACHR, LAND, NAVM, REFR, PGRE, PHZD, PMIS, PARW, PBAR, PBEA, PCON, PFLA]),
      0, nil, nil, cpNormal, False{, wbTES4ONAMDontShow}),
    wbByteArray(SCRN, 'Screenshot'),
    wbUnknown(INTV),
    wbInteger(INCC, 'Interior Cell Count', itU32).SetRequired
  ], True, nil, cpNormal, True);

  wbRecord(PLYR, 'Player Reference', [
    wbEDID,
    wbFormID(PLYR, 'Player', cpNormal, True).SetDefaultNativeValue($7)
  ]).IncludeFlag(dfInternalEditOnly);

  wbRecord(TREE, 'Tree',
    wbFlags(wbFlagsList([
      15, 'Has Distant LOD',
      25, 'Obstacle'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbGenericModel,
    wbFormIDCK(PFIG, 'Ingredient', [INGR, ALCH, MISC, LVLI, NULL]),
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
      wbFloat('Trunk Amplitude'),
      wbFloat('Front Amplitude'),
      wbFloat('Back Amplitude'),
      wbFloat('Side Amplitude'),
      wbFloat('Front Frequency'),
      wbFloat('Back Frequency'),
      wbFloat('Side Frequency'),
      wbFloat('Leaf Flexibility'),
      wbFloat('Leaf Amplitude'),
      wbFloat('Leaf Frequency')
    ], cpNormal, True)
  ]);

  wbRecord(FLOR, 'Flora', [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULLReq,
    wbGenericModel,
    wbDEST,
    wbKeywords,
    wbByteColors(PNAM, 'Marker Color (Unused)'),
    wbLString(RNAM, 'Activate Text Override', 0, cpTranslate),
    wbInteger(FNAM, 'Flags', itU16,
      wbFlags(wbSparseFlags([
        0, 'No Displacement',
        1, 'Ignored by Sandbox'
    ],False, 2))),
    wbFormIDCk(PFIG, 'Ingredient', [ALCH, AMMO, APPA, ARMO, BOOK, INGR, KEYM, LIGH, LVLI, MISC, SCRL, SLGM, WEAP, NULL]),
    wbFormIDCK(SNAM, 'Harvest Sound', [SNDR, NULL]),
    wbSeasons
  ]);

  if wbIsSkyrimSE then begin
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

    wbRecord(LENS, 'Lens Flare', [
      wbEDID,
      wbFloat(CNAM, 'Color Influence'),
      wbFloat(DNAM, 'Fade Distance Radius Scale'),
      wbInteger(LFSP, 'Count', itU32, nil, cpBenign),
      wbRArray('Lens Flare Sprites',
        wbRStruct('Flare', [
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
        ]),
        cpNormal, False, nil, wbLENSAfterSet
      )
    ]);

  end;

  wbRecord(WATR, 'Water', [
    wbEDID,
    wbFULL,
    wbRArray('Unused', wbString(NNAM, 'Noise Map', 0, cpIgnore, False)), // leftover
    wbInteger(ANAM, 'Opacity', itU8, nil, cpNormal, True),
    wbInteger(FNAM, 'Flags', itU8, wbFlags([
      {0x01} 'Causes Damage',
      {0x02} 'Unknown 1',
      {0x04} 'Unknown 2',
      {0x08} IsSSE('Enable Flowmap', 'Unknown 3'),
      {0x10} IsSSE('Blend Normals', 'Unknown 4'),
      {0x20} 'Unknown 5',
      {0x40} 'Unknown 6',
      {0x80} 'Unknown 7'
    ]), cpNormal, True),
    wbByteArray(MNAM, 'Unused', 0, cpIgnore, False),  // leftover
    wbFormIDCk(TNAM, 'Material', [MATT]),
    wbFormIDCk(SNAM, 'Open Sound', [SNDR, NULL]),
    wbFormIDCk(XNAM, 'Spell', [SPEL]),
    wbFormIDCk(INAM, 'Image Space', [IMGS]),
    IsSSE(
      wbInteger(DATA, 'Unused', itU16, nil, cpIgnore, True, True),
      wbInteger(DATA, 'Damage Per Second', itU16, nil, cpNormal, True, True)
    ),
    IsSSE(
      wbStruct(DNAM, 'Visual Data', [
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Specular Properties - Sun Specular Power'),
        wbFloat('Water Properties - Reflectivity Amount'),
        wbFloat('Water Properties - Fresnel Amount'),
        wbByteArray('Unknown', 4),
        wbFloat('Fog Properties - Above Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Above Water - Fog Distance - Far Plane'),
        wbByteColors('Shallow Color'),
        wbByteColors('Deep Color'),
        wbByteColors('Reflection Color'),
        wbByteArray('Unknown', 4),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Displacement Simulator - Starting Size'),
        wbFloat('Displacement Simulator - Force'),
        wbFloat('Displacement Simulator - Velocity'),
        wbFloat('Displacement Simulator - Falloff'),
        wbFloat('Displacement Simulator - Dampner'),
        wbFloat('Unknown'),
        wbFloat('Noise Properties - Noise Falloff'),
        wbFloat('Noise Properties - Layer One - Wind Direction'),
        wbFloat('Noise Properties - Layer Two - Wind Direction'),
        wbFloat('Noise Properties - Layer Three - Wind Direction'),
        wbFloat('Noise Properties - Layer One - Wind Speed'),
        wbFloat('Noise Properties - Layer Two - Wind Speed'),
        wbFloat('Noise Properties - Layer Three - Wind Speed'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Fog Properties - Above Water - Fog Amount'),
        wbFloat('Unknown'),
        wbFloat('Fog Properties - Under Water - Fog Amount'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Far Plane'),
        wbFloat('Water Properties - Refraction Magnitude'),
        wbFloat('Specular Properties - Specular Power'),
        wbFloat('Unknown'),
        wbFloat('Specular Properties - Specular Radius'),
        wbFloat('Specular Properties - Specular Brightness'),
        wbFloat('Noise Properties - Layer One - UV Scale'),
        wbFloat('Noise Properties - Layer Two - UV Scale'),
        wbFloat('Noise Properties - Layer Three - UV Scale'),
        wbFloat('Noise Properties - Layer One - Amplitude Scale'),
        wbFloat('Noise Properties - Layer Two - Amplitude Scale'),
        wbFloat('Noise Properties - Layer Three - Amplitude Scale'),
        wbFloat('Water Properties - Reflection Magnitude'),
        wbFloat('Specular Properties - Sun Sparkle Magnitude'),
        wbFloat('Specular Properties - Sun Specular Magnitude'),
        wbFloat('Depth Properties - Reflections'),
        wbFloat('Depth Properties - Refraction'),
        wbFloat('Depth Properties - Normals'),
        wbFloat('Depth Properties - Specular Lighting'),
        wbFloat('Specular Properties - Sun Sparkle Power'),
        // SSE
        wbFloat('Noise Properties - Flowmap Scale')
      ], cpNormal, True, nil, 57),
      wbStruct(DNAM, 'Visual Data', [
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Specular Properties - Sun Specular Power'),
        wbFloat('Water Properties - Reflectivity Amount'),
        wbFloat('Water Properties - Fresnel Amount'),
        wbByteArray('Unknown', 4),
        wbFloat('Fog Properties - Above Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Above Water - Fog Distance - Far Plane'),
        wbByteColors('Shallow Color'),
        wbByteColors('Deep Color'),
        wbByteColors('Reflection Color'),
        wbByteArray('Unknown', 4),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Displacement Simulator - Starting Size'),
        wbFloat('Displacement Simulator - Force'),
        wbFloat('Displacement Simulator - Velocity'),
        wbFloat('Displacement Simulator - Falloff'),
        wbFloat('Displacement Simulator - Dampner'),
        wbFloat('Unknown'),
        wbFloat('Noise Properties - Noise Falloff'),
        wbFloat('Noise Properties - Layer One - Wind Direction'),
        wbFloat('Noise Properties - Layer Two - Wind Direction'),
        wbFloat('Noise Properties - Layer Three - Wind Direction'),
        wbFloat('Noise Properties - Layer One - Wind Speed'),
        wbFloat('Noise Properties - Layer Two - Wind Speed'),
        wbFloat('Noise Properties - Layer Three - Wind Speed'),
        wbFloat('Unknown'),
        wbFloat('Unknown'),
        wbFloat('Fog Properties - Above Water - Fog Amount'),
        wbFloat('Unknown'),
        wbFloat('Fog Properties - Under Water - Fog Amount'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Near Plane'),
        wbFloat('Fog Properties - Under Water - Fog Distance - Far Plane'),
        wbFloat('Water Properties - Refraction Magnitude'),
        wbFloat('Specular Properties - Specular Power'),
        wbFloat('Unknown'),
        wbFloat('Specular Properties - Specular Radius'),
        wbFloat('Specular Properties - Specular Brightness'),
        wbFloat('Noise Properties - Layer One - UV Scale'),
        wbFloat('Noise Properties - Layer Two - UV Scale'),
        wbFloat('Noise Properties - Layer Three - UV Scale'),
        wbFloat('Noise Properties - Layer One - Amplitude Scale'),
        wbFloat('Noise Properties - Layer Two - Amplitude Scale'),
        wbFloat('Noise Properties - Layer Three - Amplitude Scale'),
        wbFloat('Water Properties - Reflection Magnitude'),
        wbFloat('Specular Properties - Sun Sparkle Magnitude'),
        wbFloat('Specular Properties - Sun Specular Magnitude'),
        wbFloat('Depth Properties - Reflections'),
        wbFloat('Depth Properties - Refraction'),
        wbFloat('Depth Properties - Normals'),
        wbFloat('Depth Properties - Specular Lighting'),
        wbFloat('Specular Properties - Sun Sparkle Power')
      ])
    ),
    wbByteArray(GNAM, 'Unused', 0, cpNormal, True),  // leftover
    wbVec3(NAM0, 'Linear Velocity'),
    wbVec3(NAM1, 'Angular Velocity'),
    wbString(NAM2, 'Noise Layer One - Noise Texture', 0, cpNormal, False),
    wbString(NAM3, 'Noise Layer Two - Noise Texture', 0, cpNormal, False),
    wbString(NAM4, 'Noise Layer Three - Noise Texture', 0, cpNormal, False),
    // SSE
    wbString(NAM5, 'Flow Normals - Noise Texture', 0, cpNormal, False)
  ], False, nil, cpNormal, False);

  wbRecord(WEAP, 'Weapon',
    wbFlags(wbFlagsList([
      2, 'Non-Playable'
    ])), [
    wbEDID,
    wbVMAD,
    wbOBND(True),
    wbFULL,
    wbGenericModel,
    wbICON,
    wbEnchantment(True),
    wbDEST,
    wbETYP,
    wbFormIDCk(BIDS, 'Block Bash Impact Data Set', [IPDS, NULL]),
    wbFormIDCk(BAMT, 'Alternate Block Material', [MATT, NULL]),
    wbYNAM,
    wbZNAM,
    wbKeywords,
    wbDESC,
    wbTexturedModel('Has Scope', [MOD3, MO3T], [wbMO3S]),
    wbFormIDCK(EFSD, 'Scope Effect', [EFSH]),
    wbByteArray(NNAM, 'Unused', 0, cpIgnore, False), // leftover
    wbFormIDCk(INAM, 'Impact Data Set', [IPDS, NULL]),
    wbFormIDCk(WNAM, '1st Person Model Object', [STAT, NULL]),
    wbFormIDCk(SNAM, 'Attack Sound', [SNDR]),
    wbFormIDCk(XNAM, 'Attack Sound 2D', [SNDR]),
    wbFormIDCk(NAM7, 'Attack Loop Sound', [SNDR]),
    wbFormIDCk(TNAM, 'Attack Fail Sound', [SNDR]),
    wbFormIDCk(UNAM, 'Idle Sound', [SNDR]),
    wbFormIDCk(NAM9, 'Equip Sound', [SNDR]),
    wbFormIDCk(NAM8, 'Unequip Sound', [SNDR]),
    wbStruct(DATA, 'Game Data', [
      wbInteger('Value', itU32),
      wbFloat('Weight'),
      wbInteger('Damage', itU16)
    ]),
    wbStruct(DNAM, 'Data', [
      wbInteger('Animation Type', itU8, wbWeaponAnimTypeEnum),
      wbUnused(3),
      wbFloat('Speed'),
      wbFloat('Reach'),
      wbInteger('Flags', itU16, wbFlags([
        {0x0001}'Ignores Normal Weapon Resistance',
        {0x0002}'Automatic (unused)',
        {0x0004}'Has Scope (unused)',
        {0x0008}'Can''t Drop',
        {0x0010}'Hide Backpack (unused)',
        {0x0020}'Embedded Weapon (unused)',
        {0x0040}'Don''t Use 1st Person IS Anim (unused)',
        {0x0080}'Non-playable'
      ], [1, 2, 4, 5, 6])),
      wbUnused(2),
      wbFloat('Sight FOV'),
      wbByteArray('Unknown', 4),
      wbInteger('Base VATS To-Hit Chance', itU8),
      wbInteger('Attack Animation', itU8, wbAttackAnimationEnum),
      wbInteger('# Projectiles', itU8),
      wbInteger('Embedded Weapon AV (unused)', itU8),
      wbFloat('Range Min'),
      wbFloat('Range Max'),
      wbInteger('On Hit', itU32, wbEnum([
        'No formula behaviour',
        'Dismember only',
        'Explode only',
        'No dismember/explode'
      ])),
      wbInteger('Flags2', itU32, wbFlags([
        {0x00000001} 'Player Only',
        {0x00000002} 'NPCs Use Ammo',
        {0x00000004} 'No Jam After Reload (unused)',
        {0x00000008} 'Unknown 4',
        {0x00000010} 'Minor Crime',
        {0x00000020} 'Range Fixed',
        {0x00000040} 'Not Used in Normal Combat',
        {0x00000080} 'Unknown 8',
        {0x00000100} 'Don''t Use 3rd Person IS Anim (unused)',
        {0x00000200} 'Burst Shot',
        {0x00000400} 'Rumble - Alternate',
        {0x00000800} 'Long Bursts',
        {0x00001000} 'Non-hostile',
        {0x00002000} 'Bound Weapon'
      ], [2, 8])),
      wbFloat('Animation Attack Mult'),
      wbFloat('Fire Rate'),
      wbFloat('Rumble - Left Motor Strength'),
      wbFloat('Rumble - Right Motor Strength'),
      wbFloat('Rumble - Duration'),
      wbFloat('Override - Damage to Weapon Mult'),
      wbFloat('Attack Shots/Sec'),
      wbByteArray('Unknown', 4),
      wbInteger('Skill', itS32, wbSkillEnum),
      wbByteArray('Unknown', 8),
      wbInteger('Resist', itS32, wbActorValueEnum),
      wbByteArray('Unknown', 4),
      wbFloat('Stagger')
    ]),
    wbStruct(CRDT, 'Critical Data', [
      wbInteger('Damage', itU16),
      wbUnused(2),
      wbFloat('% Mult'),
      wbInteger('On Death', itU8, wbBoolEnum),
      IsSSE(
        wbUnused(7),
        wbUnused(3)
      ),
      wbFormIDCk('Effect', [SPEL, NULL]),
      IsSSE(
        wbUnused(4),
        nil
      )
    ]),
    wbInteger(VNAM, 'Detection Sound Level', itU32, wbSoundlevelEnum),
    wbFormIDCk(CNAM, 'Template', [WEAP])
  ], False, nil, cpNormal, False, wbWEAPAfterLoad);

  wbRecord(WTHR, 'Weather', [
    wbEDID,
    wbWeatherCloudTextures,
    wbRStruct('Unused', [
      wbUnused(DNAM, 0),
      wbUnused(CNAM, 0),
      wbUnused(ANAM, 0),
      wbUnused(BNAM, 0)
    ], [], cpIgnore, False, wbNeverShow)
      .IncludeFlag(dfCollapsed),
    wbInteger(LNAM, 'Max Cloud Layers', itU32)
      .SetDefaultNativeValue(29)
      .SetRequired,
    wbFormIDCK(MNAM, 'Precipitation Type', [SPGD, NULL])
      .SetRequired,
    wbFormIDCK(NNAM, 'Visual Effect', [RFCT, NULL])
      .SetRequired,
    wbUnused(ONAM, 0),
    wbWeatherCloudSpeed,
    wbWeatherCloudColors,
    wbWeatherCloudAlphas,
    wbWeatherColors,
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
      wbInteger('Thunder/Lightning - Frequency', itU8),
      wbInteger('Flags', itU8,
        wbFlags(wbSparseFlags([
          0, 'Weather - Pleasant',
          1, 'Weather - Cloudy',
          2, 'Weather - Rainy',
          3, 'Weather - Snow',
          4, 'Aurora - Always Visible',
          5, 'Aurora - Follows Sun Position'
        ], False, 6))
      ).IncludeFlag(dfCollapsed, wbCollapseFlags),
      wbWeatherLightningColor,
      wbInteger('Visual Effect - Begin', itU8), // scaled 0..1
      wbInteger('Visual Effect - End', itU8), // scaled 0..1
      wbInteger('Wind Direction', itU8), // scaled 0..360
      wbInteger('Wind Direction Range', itU8) // scaled 0..180
    ]).SetRequired,
    wbWeatherDisabledLayers,
    wbWeatherSounds,
    wbRArrayS('Sky Statics',
      wbFormIDCk(TNAM, 'Static', [STAT, NULL])
    ),
    wbWeatherImageSpaces,
    IsSSE(
      wbWeatherVolumetricLighting
        .SetRequired,
      nil
     ),
    wbWeatherDirectionalLighting,
    wbByteArray(NAM2, 'Unused', 0, cpIgnore),
    wbByteArray(NAM3, 'Unused', 0, cpIgnore),
    wbRStruct('Aurora', [
      wbGenericModel
    ]),
    IsSSE(
      wbFormIDCk(GNAM, 'Sun Glare Lens Flare', [LENS]),
      nil
    )
  ]);

  wbRecord(WOOP, 'Word of Power', [
    wbEDID,
    wbFULL,
    wbLString(TNAM, 'Translation', 0, cpTranslate, True)
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
    wbFormIDCk(XEZN, 'Encounter Zone', [ECZN]),
    wbFormIDCk(XLCN, 'Location', [LCTN]),
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
      ).IncludeFlag(dfCollapsed, wbCollapseFlags)
       .SetRequired
    ]),
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
    ]),
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
    wbFormIDCk(ZNAM, 'Music', [MUSC]),
    wbString(NNAM, 'Canopy Shadow (unused)', 0, cpIgnore),
    wbString(XNAM, 'Water Noise Texture'),
    wbString(TNAM, 'HD LOD Diffuse Texture'),
    wbString(UNAM, 'HD LOD Normal Texture'),
    wbString(XWEM, 'Water Environment Map (unused)', 0, cpIgnore),
    wbWorldOffsetData
  ]).SetAfterLoad(wbWorldAfterLoad)
    .SetAfterSet(wbWorldAfterSet);

{>>> Unused records, they have empty GRUP in skyrim.esm <<<}

  wbRecord(CLDC, 'CLDC', [
    wbEDID
  ]);
  wbRecord(HAIR, 'HAIR', [
    wbEDID
  ]);
  wbRecord(PWAT, 'PWAT', [
    wbEDID
  ]);
  wbRecord(RGDL, 'RGDL', [
    wbEDID
  ]);
  {
  wbRecord(SCOL, 'SCOL', [
    wbEDID
  ]);
  }

  wbStaticPart :=
    wbRStruct('Part', [
      wbFormIDCk(ONAM, 'Static', [STAT]),
      wbStaticPartPlacements
    ], [], cpNormal, True);

  wbRecord(SCOL, 'Static Collection', [
    wbEDID,
    wbOBND(True),
    wbGenericModel(True),
    wbRArray('Parts', wbStaticPart)
  ]);

  wbRecord(SCPT, 'SCPT', [
    wbEDID
  ]);

   wbAddGroupOrder(GMST);
   wbAddGroupOrder(KYWD);
   wbAddGroupOrder(LCRT);
   wbAddGroupOrder(AACT);
   wbAddGroupOrder(TXST);
   //wbAddGroupOrder(MICN);
   wbAddGroupOrder(GLOB);
   wbAddGroupOrder(CLAS);
   wbAddGroupOrder(FACT);
   wbAddGroupOrder(HDPT);
   wbAddGroupOrder(HAIR);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(EYES);
   wbAddGroupOrder(RACE);
   wbAddGroupOrder(SOUN);
   wbAddGroupOrder(ASPC);
   wbAddGroupOrder(MGEF);
   wbAddGroupOrder(SCPT);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(LTEX);
   wbAddGroupOrder(ENCH);
   wbAddGroupOrder(SPEL);
   wbAddGroupOrder(SCRL);
   wbAddGroupOrder(ACTI);
   wbAddGroupOrder(TACT);
   wbAddGroupOrder(ARMO);
   wbAddGroupOrder(BOOK);
   wbAddGroupOrder(CONT);
   wbAddGroupOrder(DOOR);
   wbAddGroupOrder(INGR);
   wbAddGroupOrder(LIGH);
   wbAddGroupOrder(MISC);
   wbAddGroupOrder(APPA);
   wbAddGroupOrder(STAT);
   wbAddGroupOrder(SCOL);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(MSTT);
   wbAddGroupOrder(PWAT);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(GRAS);
   wbAddGroupOrder(TREE);
   wbAddGroupOrder(CLDC);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(FLOR);
   wbAddGroupOrder(FURN);
   wbAddGroupOrder(WEAP);
   wbAddGroupOrder(AMMO);
   wbAddGroupOrder(NPC_);
   wbAddGroupOrder(PLYR);
   wbAddGroupOrder(LVLN);
   wbAddGroupOrder(KEYM);
   wbAddGroupOrder(ALCH);
   wbAddGroupOrder(IDLM);
   //wbAddGroupOrder(NOTE);
   wbAddGroupOrder(COBJ);
   wbAddGroupOrder(PROJ);
   wbAddGroupOrder(HAZD);
   wbAddGroupOrder(SLGM);
   wbAddGroupOrder(LVLI);
   wbAddGroupOrder(WTHR);
   wbAddGroupOrder(CLMT);
   wbAddGroupOrder(SPGD);
   wbAddGroupOrder(RFCT);
   wbAddGroupOrder(REGN);
   wbAddGroupOrder(NAVI);
   wbAddGroupOrder(CELL);
   //wbAddGroupOrder(REFR);
   //wbAddGroupOrder(ACHR);
   //wbAddGroupOrder(PMIS);
   //wbAddGroupOrder(PARW);
   //wbAddGroupOrder(PGRE);
   //wbAddGroupOrder(PBEA);
   //wbAddGroupOrder(PFLA);
   //wbAddGroupOrder(PCON);
   //wbAddGroupOrder(PBAR);
   //wbAddGroupOrder(PHZD);
   wbAddGroupOrder(WRLD);
   //wbAddGroupOrder(LAND);
   //wbAddGroupOrder(NAVM);
   //wbAddGroupOrder(TLOD);
   wbAddGroupOrder(DIAL);
   //wbAddGroupOrder(INFO);
   wbAddGroupOrder(QUST);
   wbAddGroupOrder(IDLE);
   wbAddGroupOrder(PACK);
   wbAddGroupOrder(CSTY);
   wbAddGroupOrder(LSCR);
   wbAddGroupOrder(LVSP);
   wbAddGroupOrder(ANIO);
   wbAddGroupOrder(WATR);
   wbAddGroupOrder(EFSH);
   //wbAddGroupOrder(TOFT);
   wbAddGroupOrder(EXPL);
   wbAddGroupOrder(DEBR);
   wbAddGroupOrder(IMGS);
   wbAddGroupOrder(IMAD);
   wbAddGroupOrder(FLST);
   wbAddGroupOrder(PERK);
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
   wbAddGroupOrder(ECZN);
   wbAddGroupOrder(LCTN);
   wbAddGroupOrder(MESG);
   wbAddGroupOrder(RGDL);{>>> Unused in Skyrim, but contained in Skyrim.esm <<<}
   wbAddGroupOrder(DOBJ);
   wbAddGroupOrder(LGTM);
   wbAddGroupOrder(MUSC);
   wbAddGroupOrder(FSTP);
   wbAddGroupOrder(FSTS);
   wbAddGroupOrder(SMBN);
   wbAddGroupOrder(SMQN);
   wbAddGroupOrder(SMEN);
   wbAddGroupOrder(DLBR);
   wbAddGroupOrder(MUST);
   wbAddGroupOrder(DLVW);
   wbAddGroupOrder(WOOP);
   wbAddGroupOrder(SHOU);
   wbAddGroupOrder(EQUP);
   wbAddGroupOrder(RELA);
   wbAddGroupOrder(SCEN);
   wbAddGroupOrder(ASTP);
   wbAddGroupOrder(OTFT);
   wbAddGroupOrder(ARTO);
   wbAddGroupOrder(MATO);
   wbAddGroupOrder(MOVT);
   wbAddGroupOrder(SNDR);
   wbAddGroupOrder(DUAL);
   wbAddGroupOrder(SNCT);
   wbAddGroupOrder(SOPM);
   wbAddGroupOrder(COLL);
   wbAddGroupOrder(CLFM);
   wbAddGroupOrder(REVB);
   if wbIsSkyrimSE then wbAddGroupOrder(LENS); {New to SSE}
   //wbAddGroupOrder(LSPR);
   if wbIsSkyrimSE then wbAddGroupOrder(VOLI); {New to SSE}
  if wbIsSkyrimSE then begin
    wbNexusModsUrl := 'https://www.nexusmods.com/skyrimspecialedition/mods/164';
    if wbToolMode = tmLODgen then
      wbNexusModsUrl := 'https://www.nexusmods.com/skyrimspecialedition/mods/6642';
  end else begin
    wbNexusModsUrl := 'https://www.nexusmods.com/skyrim/mods/25859';
    if wbToolMode = tmLODgen then
      wbNexusModsUrl := 'https://www.nexusmods.com/skyrim/mods/62698';
  end;
  case wbGameMode of
    gmEnderal: wbNexusModsUrl := 'https://www.nexusmods.com/enderal/mods/23';
    gmEnderalSE: wbNexusModsUrl := 'https://www.nexusmods.com/enderalspecialedition/mods/78';
  end;
  if wbIsSkyrimSE then begin
    SetLength(wbOfficialDLC, 3);
    wbOfficialDLC[0] := 'Dawnguard.esm';
    wbOfficialDLC[1] := 'HearthFires.esm';
    wbOfficialDLC[2] := 'Dragonborn.esm';

    if wbGameMode = gmTES5VR then begin
      // new VR esm is loaded after DLCs
      SetLength(wbOfficialDLC, Succ(Length(wbOfficialDLC)));
      wbOfficialDLC[Pred(Length(wbOfficialDLC))] := 'SkyrimVR.esm';
    end else
      wbCreationClubContentFileName := 'Skyrim.ccc';
  end;
  wbHEDRVersion := 1.7;
  if wbGameMode in [gmSSE, gmEnderalSE] then
    wbHEDRVersion := 1.71;
end;
end.
