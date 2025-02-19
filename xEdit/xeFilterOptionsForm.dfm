object frmFilterOptions: TfrmFilterOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Filter...'
  ClientHeight = 750
  ClientWidth = 935
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOptions: TPanel
    Left = 0
    Top = 0
    Width = 935
    Height = 715
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 10
      Width = 31
      Height = 13
      Caption = 'Preset'
    end
    object cbAssignPersWrldChild: TCheckBox
      Left = 208
      Top = 648
      Width = 277
      Height = 17
      Caption = 'Assign Persistent Worldspace Children to Cells'
      TabOrder = 4
    end
    object cbBaseRecordSignature: TCheckBox
      Left = 646
      Top = 36
      Width = 281
      Height = 17
      Caption = 'by Base Record Signature'
      TabOrder = 5
    end
    object cbByBaseEditorID: TCheckBox
      Left = 643
      Top = 531
      Width = 282
      Height = 17
      Caption = 'Base Record EditorID contains / or FormID'
      TabOrder = 6
    end
    object cbByBaseName: TCheckBox
      Left = 643
      Top = 587
      Width = 282
      Height = 17
      Caption = 'Base Record Name contains'
      TabOrder = 7
    end
    object cbByEditorID: TCheckBox
      Left = 12
      Top = 412
      Width = 154
      Height = 17
      Caption = 'EditorID contains'
      TabOrder = 8
    end
    object cbByHasVWDMesh: TCheckBox
      Left = 175
      Top = 470
      Width = 201
      Height = 17
      Caption = 'by Has Visible When Distant Mesh'
      TabOrder = 9
    end
    object cbByInjectionStatus: TCheckBox
      Left = 12
      Top = 374
      Width = 145
      Height = 17
      Caption = 'by injection status'
      TabOrder = 10
    end
    object cbByName: TCheckBox
      Left = 12
      Top = 462
      Width = 161
      Height = 17
      Caption = 'Name contains'
      TabOrder = 11
    end
    object cbByNotReachableStatus: TCheckBox
      Left = 175
      Top = 392
      Width = 193
      Height = 17
      Caption = 'by not reachable status'
      TabOrder = 12
    end
    object cbByPersistent: TCheckBox
      Left = 12
      Top = 510
      Width = 145
      Height = 17
      Caption = 'by persistence'
      TabOrder = 13
    end
    object cbByReferencesInjectedStatus: TCheckBox
      Left = 175
      Top = 354
      Width = 193
      Height = 17
      Caption = 'by references injected status'
      TabOrder = 14
    end
    object cbByVWD: TCheckBox
      Left = 175
      Top = 430
      Width = 180
      Height = 17
      Caption = 'by Visible When Distant'
      TabOrder = 15
    end
    object cbConflictAll: TCheckBox
      Left = 12
      Top = 36
      Width = 329
      Height = 17
      Caption = 'by conflict status overall (that'#39's the background color)'
      TabOrder = 16
    end
    object cbConflictThis: TCheckBox
      Left = 12
      Top = 157
      Width = 361
      Height = 17
      Caption = 
        'by conflict status for this particular record  (that'#39's the text ' +
        'color)'
      TabOrder = 17
    end
    object cbDeleted: TCheckBox
      Left = 12
      Top = 354
      Width = 145
      Height = 17
      Caption = 'deleted'
      TabOrder = 18
    end
    object cbFlattenBlocks: TCheckBox
      Left = 12
      Top = 625
      Width = 161
      Height = 17
      Caption = 'Flatten Blocks/Sub-Blocks'
      TabOrder = 19
    end
    object cbFlattenCellChilds: TCheckBox
      Left = 189
      Top = 625
      Width = 157
      Height = 17
      Caption = 'Flatten Cell Children'
      TabOrder = 20
    end
    object cbHasVWDMesh: TCheckBox
      Left = 192
      Top = 485
      Width = 184
      Height = 17
      Caption = 'only Has VWD Mesh'
      TabOrder = 21
    end
    object cbInherit: TCheckBox
      Left = 358
      Top = 625
      Width = 279
      Height = 17
      Caption = 'Conflict status inherited by parent'
      TabOrder = 22
    end
    object cbInjected: TCheckBox
      Left = 27
      Top = 389
      Width = 139
      Height = 17
      Caption = 'only injected'
      TabOrder = 23
    end
    object cbIsMaster: TCheckBox
      Left = 251
      Top = 579
      Width = 114
      Height = 17
      Caption = 'or if it'#39's the master'
      TabOrder = 24
    end
    object cbMasterIsTemporary: TCheckBox
      Left = 58
      Top = 579
      Width = 187
      Height = 17
      Caption = 'only if master is not persistent'
      TabOrder = 25
    end
    object cbNotReachable: TCheckBox
      Left = 192
      Top = 407
      Width = 163
      Height = 17
      Caption = 'only not reachable'
      TabOrder = 26
    end
    object cbPersistent: TCheckBox
      Left = 27
      Top = 533
      Width = 156
      Height = 17
      Caption = 'only persistent'
      TabOrder = 27
    end
    object cbPersistentPosChanged: TCheckBox
      Left = 42
      Top = 602
      Width = 307
      Height = 17
      Caption = 'only if position/rotation was changed'
      TabOrder = 28
    end
    object cbRecordSignature: TCheckBox
      Left = 358
      Top = 36
      Width = 281
      Height = 17
      Caption = 'by Record Signature'
      TabOrder = 29
    end
    object cbReferencesInjected: TCheckBox
      Left = 189
      Top = 369
      Width = 187
      Height = 17
      Caption = 'only references injected'
      TabOrder = 30
    end
    object cbScaledActors: TCheckBox
      Left = 643
      Top = 637
      Width = 161
      Height = 17
      Caption = 'Scaled Actors'
      TabOrder = 31
    end
    object cbUnnecessaryPersistent: TCheckBox
      Left = 42
      Top = 556
      Width = 307
      Height = 17
      Caption = 'only possible unnecessary persistent'
      TabOrder = 32
    end
    object cbVWD: TCheckBox
      Left = 192
      Top = 447
      Width = 176
      Height = 17
      Caption = 'only Visible When Distant'
      TabOrder = 33
    end
    object clbBaseRecordSignatures: TCheckListBox
      Left = 667
      Top = 59
      Width = 258
      Height = 466
      Color = clBtnFace
      ItemHeight = 13
      PopupMenu = pmuSelection
      TabOrder = 34
      OnKeyPress = clbKeyPress
    end
    object clbConflictAll: TCheckListBox
      Left = 34
      Top = 59
      Width = 318
      Height = 92
      Color = clBtnFace
      ItemHeight = 13
      PopupMenu = pmuSelection
      TabOrder = 35
      OnKeyPress = clbKeyPress
    end
    object clbConflictThis: TCheckListBox
      Left = 34
      Top = 180
      Width = 318
      Height = 163
      Color = clBtnFace
      ItemHeight = 13
      PopupMenu = pmuSelection
      TabOrder = 36
      OnKeyPress = clbKeyPress
    end
    object clbRecordSignatures: TCheckListBox
      Left = 379
      Top = 59
      Width = 258
      Height = 560
      Color = clBtnFace
      ItemHeight = 13
      PopupMenu = pmuSelection
      TabOrder = 37
      OnKeyPress = clbKeyPress
    end
    object edBaseEditorID: TEdit
      Left = 665
      Top = 554
      Width = 132
      Height = 21
      TabOrder = 38
    end
    object edBaseName: TEdit
      Left = 665
      Top = 610
      Width = 139
      Height = 21
      TabOrder = 39
    end
    object edEditorID: TEdit
      Left = 34
      Top = 435
      Width = 132
      Height = 21
      TabOrder = 40
    end
    object edName: TEdit
      Left = 34
      Top = 485
      Width = 132
      Height = 21
      TabOrder = 41
    end
    object cmbPreset: TComboBox
      Left = 58
      Top = 6
      Width = 382
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      TabOrder = 0
      OnSelect = cmbPresetSelect
    end
    object btnFilterAdd: TButton
      Left = 546
      Top = 4
      Width = 91
      Height = 25
      Caption = 'Add'
      TabOrder = 2
      OnClick = btnFilterAddClick
    end
    object btnFilterDel: TButton
      Left = 643
      Top = 4
      Width = 91
      Height = 25
      Caption = 'Remove'
      TabOrder = 3
      OnClick = btnFilterDelClick
    end
    object btnFilterSave: TButton
      Left = 449
      Top = 4
      Width = 91
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = btnFilterSaveClick
    end
    object cbByHasPrecombinedMesh: TCheckBox
      Left = 175
      Top = 508
      Width = 201
      Height = 17
      Caption = 'by Has Precombined Mesh'
      TabOrder = 42
    end
    object cbHasPrecombinedMesh: TCheckBox
      Left = 192
      Top = 523
      Width = 184
      Height = 17
      Caption = 'only Has Precombined Mesh'
      TabOrder = 43
    end
    object cbByElementValue: TCheckBox
      Left = 12
      Top = 661
      Width = 145
      Height = 17
      Caption = 'Element value contains'
      TabOrder = 44
    end
    object edElementValue: TEdit
      Left = 36
      Top = 684
      Width = 121
      Height = 23
      TabOrder = 45
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 715
    Width = 935
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      935
      41)
    object btnFilter: TButton
      Left = 737
      Top = 10
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Filter'
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 834
      Top = 10
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object pnlBevel: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 0
      Width = 927
      Height = 1
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 0
      Align = alTop
      TabOrder = 2
    end
  end
  object pmuSelection: TPopupMenu
    Left = 320
    Top = 64
    object mniSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = mniSelectionClick
    end
    object mniSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = mniSelectionClick
    end
    object mniInvertSelection: TMenuItem
      Caption = 'Invert Selection'
      OnClick = mniSelectionClick
    end
  end
end
