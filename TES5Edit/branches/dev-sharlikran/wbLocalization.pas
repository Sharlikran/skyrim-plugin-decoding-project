{*******************************************************************************

     The contents of this file are subject to the Mozilla Public License
     Version 1.1 (the "License"); you may not use this file except in
     compliance with the License. You may obtain a copy of the License at
     http://www.mozilla.org/MPL/

     Software distributed under the License is distributed on an "AS IS"
     basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
     License for the specific language governing rights and limitations
     under the License.

*******************************************************************************}

{>>>
  Anything written here is a temp hack for dump to show lstrings.
  The purpose is to make it work without large modifications to wbInterface or
  other core files.
  It doesn't free memory.
  Needs complete rewrite for TES5Edit.
<<<}

unit wbLocalization;

interface

uses
  Classes, SysUtils, StrUtils,
  wbInterface, wbBSA;

type
  TwbLStringType = (
    lsDLString,
    lsILString,
    lsString
  );

  TwbLocalizationFile = class
  private
    fName        : string;
    fFileName    : string;
    fFileType    : TwbLStringType;
    fStrings     : TStrings;
    fModified    : boolean;
    fNextID      : integer;

    procedure Init;
    function FileStringType(aFileName: string): TwbLStringType;
    function ReadZString(aStream: TStream): string;
    function ReadLenZString(aStream: TStream): string;
    procedure WriteZString(aStream: TStream; aString: string);
    procedure WriteLenZString(aStream: TStream; aString: string);
    procedure ReadDirectory(aStream: TStream);
  protected
    function Get(Index: Integer): string;
    procedure Put(Index: Integer; const S: string);
  public
    property Strings[Index: Integer]: string read Get write Put; default;
    property Name: string read fName;
    property FileName: string read fFileName;
    property Modified: boolean read fModified write fModified;
    property NextID: integer read fNextID;
    constructor Create(const aFileName: string); overload;
    constructor Create(const aFileName: string; aData: TBytes); overload;
    destructor Destroy; override;
    function Count: Integer;
    function IndexToID(Index: Integer): Integer;
    function AddString(ID: Integer; const S: string): boolean;
    procedure WriteToFile(const aFileName: string);
    procedure ExportToFile(const aFileName: string);
  end;

  TwbLocalizationHandler = class
  private
    lFiles: TStrings;
  protected
    function Get(Index: Integer): TwbLocalizationFile;
  public
    NoTranslate: boolean;
    property Items[Index: Integer]: TwbLocalizationFile read Get; default;
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    function LocalizedValueDecider(aElement: IwbElement): TwbLStringType;
    function AvailableLanguages(DataPath: string): TStringList;
    procedure LoadForFiles(DataPath: string; Files: TStringList);
    function AddLocalization(const aFileName: string): TwbLocalizationFile; overload;
    function AddLocalization(const aFileName: string; aData: TBytes): TwbLocalizationFile; overload;
    function GetValue(ID: Cardinal; aElement: IwbElement): string;
    function GetLocalizationFileName(aElement: IwbElement; var aFileName, aFullName: string): boolean;
    function GetLocalizationFileNameByType(aPluginFile: string; ls: TwbLStringType): string;
    function LocalizeElement(aElement: IwbElement): boolean;
  end;

const
  wbLocalizationExtension: array [TwbLStringType] of string = (
    '.DLSTRINGS',
    '.ILSTRINGS',
    '.STRINGS'
  );

var
  wbLocalizationHandler: TwbLocalizationHandler;

implementation

constructor TwbLocalizationFile.Create(const aFileName: string);
var
  fs: TFileStream;
  fStream: TStream;
  Buffer: PByte;
begin
  fFileName := aFileName;
  Init;
  // cache file in mem
  fStream := TMemoryStream.Create;
  try
    fs := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
    GetMem(Buffer, fs.Size);
    fs.ReadBuffer(Buffer^, fs.Size);
    fStream.WriteBuffer(Buffer^, fs.Size);
    fStream.Position := 0;
    ReadDirectory(fStream);
  finally
    FreeMem(Buffer);
    FreeAndNil(fs);
    FreeAndNil(fStream);
  end;
end;

constructor TwbLocalizationFile.Create(const aFileName: string; aData: TBytes);
var
  fStream: TStream;
begin
  fFileName := aFileName;
  Init;
  fStream := TMemoryStream.Create;
  try
    fStream.WriteBuffer(aData[0], length(aData));
    fStream.Position := 0;
    ReadDirectory(fStream);
  finally
    FreeAndNil(fStream);
  end;
end;

destructor TwbLocalizationFile.Destroy;
begin
  FreeAndNil(fStrings);
  inherited;
end;

procedure TwbLocalizationFile.Init;
begin
  fModified := false;
  fName := ExtractFileName(fFileName);
  fFileType := FileStringType(fFileName);
  fStrings := TwbFastStringList.Create;
  fNextID := 1;
end;

function TwbLocalizationFile.FileStringType(aFileName: string): TwbLStringType;
var
  ext: string;
  i: TwbLStringType;
begin
  Result := lsString;
  ext := ExtractFileExt(aFileName);
  for i := Low(TwbLStringType) to High(TwbLStringType) do
    if SameText(ext, wbLocalizationExtension[i]) then
      Result := i;
end;

function TwbLocalizationFile.ReadZString(aStream: TStream): string;
var
  s: AnsiString;
  c: AnsiChar;
begin
  s := '';
  while aStream.Read(c, 1) = 1 do begin
    if c <> #0 then s := s + c else break;
  end;
  Result := s;
end;

function TwbLocalizationFile.ReadLenZString(aStream: TStream): string;
var
  s: AnsiString;
  Len: Cardinal;
begin
  aStream.ReadBuffer(Len, 4);
  Dec(Len); // trailing null
  SetLength(s, Len);
  aStream.ReadBuffer(s[1], Len);
  Result := s;
end;

procedure TwbLocalizationFile.WriteZString(aStream: TStream; aString: string);
const z: AnsiChar = #0;
var
  s: AnsiString;
begin
  s := aString;
  aStream.WriteBuffer(PAnsiChar(s)^, length(s));
  aStream.WriteBuffer(z, SizeOf(z));
end;

procedure TwbLocalizationFile.WriteLenZString(aStream: TStream; aString: string);
const z: AnsiChar = #0;
var
  s: AnsiString;
  l: Cardinal;
begin
  s := aString;
  l := length(s) + SizeOf(z);
  aStream.WriteBuffer(l, SizeOf(Cardinal));
  aStream.WriteBuffer(PAnsiChar(s)^, length(s));
  aStream.WriteBuffer(z, SizeOf(z));
end;

procedure TwbLocalizationFile.ReadDirectory(aStream: TStream);
var
  i: integer;
  scount, id, offset: Cardinal;
  oldPos: int64;
  s: string;
begin
  if aStream.Size < 8 then
    Exit;

  aStream.Read(scount, 4); // number of strings
  aStream.Position := aStream.Position + 4; // skip dataSize
  for i := 0 to scount - 1 do begin
    aStream.Read(id, 4); // string ID
    aStream.Read(offset, 4); // offset of string relative to data (header + dirsize)
    oldPos := aStream.Position;
    aStream.Position := 8 + scount*8 + offset; // header + dirsize + offset
    if fFileType = lsString then
      s := ReadZString(aStream)
    else
      s := ReadLenZString(aStream);
    fStrings.AddObject(s, pointer(id));
    if Succ(id) > fNextID then
      fNextID := Succ(id);
    aStream.Position := oldPos;
  end;
end;

procedure TwbLocalizationFile.WriteToFile(const aFileName: string);
var
  dir, data: TMemoryStream;
  f: TFileStream;
  i: integer;
  c: Cardinal;
begin
  dir := TMemoryStream.Create;
  data := TMemoryStream.Create;
  c := fStrings.Count;
  dir.WriteBuffer(c, SizeOf(c)); // number of strings
  dir.WriteBuffer(c, SizeOf(c)); // dataSize, will overwrite later
  try
    f := TFileStream.Create(aFileName, fmCreate or fmShareDenyNone);

    for i := 0 to Pred(fStrings.Count) do begin
      c := Cardinal(fStrings.Objects[i]);
      dir.WriteBuffer(c, SizeOf(c)); // ID
      c := data.Position;
      dir.WriteBuffer(c, SizeOf(c)); // relative position
      if fFileType = lsString then
        WriteZString(data, fStrings[i])
      else
        WriteLenZString(data, fStrings[i]);
    end;
    c := data.Size;
    dir.Position := 4;
    dir.WriteBuffer(c, SizeOf(c)); // dataSize

    f.CopyFrom(dir, 0);
    f.CopyFrom(data, 0);
  finally
    FreeAndNil(f);
    FreeAndNil(dir);
    FreeAndNil(data);
  end;
end;

function TwbLocalizationFile.Count: Integer;
begin
  Result := fStrings.Count;
end;

function TwbLocalizationFile.IndexToID(Index: Integer): Integer;
begin
  if Index < Count then
    Result := Integer(fStrings.Objects[Index])
  else
    Result := -1;
end;

function TwbLocalizationFile.Get(Index: Integer): string;
var
  idx: integer;
begin
  Result := '';
  idx := fStrings.IndexOfObject(Pointer(Index));
  if idx <> -1 then
    Result := fStrings[idx]
  else
    Result := '<Error: Unknown lstring ID ' + IntToHex(Index, 8) + '>';
end;

procedure TwbLocalizationFile.Put(Index: Integer; const S: string);
var
  idx: integer;
begin
  idx := fStrings.IndexOfObject(Pointer(Index));
  if idx <> -1 then
    if fStrings[idx] <> S then begin
      fStrings[idx] := S;
      fModified := true;
    end;
end;

function TwbLocalizationFile.AddString(ID: Integer; const S: string): boolean;
begin
  Result := false;
  if ID < NextID then
    Exit;

  fStrings.AddObject(S, Pointer(ID));
  fNextID := Succ(ID);
  fModified := true;

  Result := true;
end;

procedure TwbLocalizationFile.ExportToFile(const aFileName: string);
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    for i := 0 to Pred(fStrings.Count) do begin
      sl.Add('[' + IntToHex(Integer(fStrings.Objects[i]), 8) + ']');
      sl.Add(fStrings[i]);
    end;
    sl.SaveToFile(aFileName);
  finally
    FreeAndNil(sl);
  end;
end;

constructor TwbLocalizationHandler.Create;
begin
  lFiles := TwbFastStringListCS.CreateSorted;
  NoTranslate := false;
end;

destructor TwbLocalizationHandler.Destroy;
var
  i: integer;
begin
  for i := 0 to lFiles.Count - 1 do
    TwbLocalizationFile(lFiles[i]).Free;
  FreeAndNil(lFiles);
end;

function TwbLocalizationHandler.Count: Integer;
begin
  Result := lFiles.Count;
end;

function TwbLocalizationHandler.Get(Index: Integer): TwbLocalizationFile;
begin
  if Index < Count then
    Result := TwbLocalizationFile(lFiles.Objects[Index])
  else
    Result := nil;
end;

function TwbLocalizationHandler.AddLocalization(const aFileName: string): TwbLocalizationFile;
begin
  Result := TwbLocalizationFile.Create(aFileName);
  lFiles.AddObject(ExtractFileName(aFileName), Result);
end;

function TwbLocalizationHandler.AddLocalization(const aFileName: string; aData: TBytes): TwbLocalizationFile;
begin
  Result := TwbLocalizationFile.Create(aFileName, aData);
  lFiles.AddObject(ExtractFileName(aFileName), Result);
end;

function TwbLocalizationHandler.LocalizedValueDecider(aElement: IwbElement): TwbLStringType;
var
  sigElement, sigRecord: TwbSignature;
  aRecord: IwbSubRecord;
begin
  if Supports(aElement, IwbSubRecord, aRecord) then
    sigElement := aRecord.Signature
  else
    sigElement := '';

  sigRecord := aElement.ContainingMainRecord.Signature;

  if (sigRecord <> 'LSCR') and (sigElement = 'DESC') then Result := lsDLString else // DESC always from dlstrings except LSCR
  if (sigRecord = 'QUST') and (sigElement = 'CNAM') then Result := lsDLString else // quest log entry
  if (sigRecord = 'BOOK') and (sigElement = 'CNAM') then Result := lsDLString else // Book CNAM description
  if (sigRecord = 'INFO') and (sigElement <> 'RNAM') then Result := lsILString else // dialog, RNAM are lsString, others lsILString
    Result := lsString; // others
end;

function TwbLocalizationHandler.AvailableLanguages(DataPath: string): TStringList;
var
  F: TSearchRec;
  p: integer;
  s: string;
begin
  Result := TStringList.Create;
  if FindFirst(DataPath + 'Strings\*.*STRINGS', faAnyFile, F) = 0 then try
    repeat
      s := UpperCase(ChangeFileExt(F.Name, ''));
      p := LastDelimiter('_', s);
      if p > 0 then begin
        s := Copy(s, p + 1, length(s));
        if Result.IndexOf(s) = -1 then
          Result.Add(s);
      end;
    until FindNext(F) <> 0;
  finally
    FindClose(F);
  end;
end;

procedure TwbLocalizationHandler.LoadForFiles(DataPath: string; Files: TStringList);
var
  ls: TwbLStringType;
  s: string;
  i: integer;
  res: TDynResources;
begin
  if not Assigned(wbContainerHandler) then
    Exit;

  for i := 0 to Pred(Count) do
    Items[i].Destroy;
  lFiles.Clear;

  for i := 0 to Pred(Files.Count) do begin
    for ls := Low(TwbLStringType) to High(TwbLStringType) do begin
      s := wbLocalizationHandler.GetLocalizationFileNameByType(Files[i], ls);
      res := wbContainerHandler.OpenResource(s);
      if length(res) > 0 then begin
        wbProgressCallback('[' + s + '] Loading Localization.');
        wbLocalizationHandler.AddLocalization(DataPath + s, res[High(res)].GetData);
      end;
    end;
  end;
end;

function TwbLocalizationHandler.GetLocalizationFileNameByType(aPluginFile: string; ls: TwbLStringType): string;
begin
  Result := Format('%s_%s%s', [
    ChangeFileExt(aPluginFile, ''),
    wbLanguage,
    wbLocalizationExtension[ls]
  ]);
  // relative path to Data folder
  Result := 'Strings\' + Result;
end;

function TwbLocalizationHandler.LocalizeElement(aElement: IwbElement): boolean;
var
  ls: TwbLStringType;
  FileName: string;
  wblf: array [TwbLStringType] of TwbLocalizationFile;
  idx, ID: integer;
  data: TBytes;
begin
  Result := False;
  if not Assigned(aElement) then
    Exit;

  // create localization files if absent
  try
    ID := 1;
    for ls := Low(TwbLStringType) to High(TwbLStringType) do begin
      FileName := GetLocalizationFileNameByType(aElement._File.FileName, ls);
      idx := lFiles.IndexOf(ExtractFileName(FileName));
      if idx = -1 then begin
        wblf[ls] := AddLocalization(ExtractFilePath(aElement._File.GetFullFileName) + FileName, data);
        wblf[ls].Modified := true;
      end else
        wblf[ls] := TwbLocalizationFile(lFiles.Objects[idx]);

      if wblf[ls].NextID > ID then
        ID := wblf[ls].NextID;
    end;

    if aElement.EditValue <> '' then
      wblf[LocalizedValueDecider(aElement)].AddString(ID, aElement.EditValue)
    else
      ID := 0;
    NoTranslate := true;
    aElement.EditValue := IntToHex(ID, 8);
    NoTranslate := false;
  finally
    NoTranslate := false;
    Result := true;
  end;
end;

function TwbLocalizationHandler.GetLocalizationFileName(aElement: IwbElement; var aFileName, aFullName: string): boolean;
var
  Extension: String;
begin
  Result := False;

  if not Assigned(aElement) then
    Exit;

  aFileName := GetLocalizationFileNameByType(aElement._File.FileName, LocalizedValueDecider(aElement));
  aFullName := ExtractFilePath(aElement._File.GetFullFileName) + aFileName;

  Result := True;
end;

function TwbLocalizationHandler.GetValue(ID: Cardinal; aElement: IwbElement): string;
var
  lFileName, lFullName, BSAName: string;
  idx: integer;
  wblf: TwbLocalizationFile;
  res: TDynResources;
  bFailed: boolean;
begin
  Result := '';

  if NoTranslate then begin
    Result := IntToHex(ID, 8);
    Exit;
  end;

  if ID = 0 then
    Exit;

  if not GetLocalizationFileName(aElement, lFileName, lFullName) then
    Exit;

  idx := lFiles.IndexOf(ExtractFileName(lFileName));
  if idx = -1 then begin
    bFailed := true;
    if Assigned(wbContainerHandler) then begin
      res := wbContainerHandler.OpenResource(lFileName);
      if length(res) > 0 then begin
        wblf := AddLocalization(lFullName, res[High(res)].GetData);
        bFailed := false;
      end;
    end;
    if bFailed then begin
      Result := '<Error: No localization for lstring ID ' + IntToHex(ID, 8) + '>';
      Exit;
    end;
  end else
    wblf := TwbLocalizationFile(lFiles.Objects[idx]);

  Result := wblf[ID];
end;

initialization
  wbLocalizationHandler := TwbLocalizationHandler.Create;

end.
