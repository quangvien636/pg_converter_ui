# Board_% Schema DDL Validation Report

This report contains the test results of deploying Board-related table DDLs, constraint DDLs, and index DDLs to the PostgreSQL test database.

## 1. Tables Deployment Summary

| Table Name | Status | Error Details |
|------------|--------|---------------|
| `BoardOptions` | **PASS** |  |
| `Board_AllowAccess` | **PASS** |  |
| `Board_AndroidDevices` | **PASS** |  |
| `Board_AuthoGroup` | **PASS** |  |
| `Board_Boards` | **PASS** |  |
| `Board_CommentSetting` | **PASS** |  |
| `Board_Config` | **PASS** |  |
| `Board_Contents` | **PASS** |  |
| `Board_ContentSetting` | **PASS** |  |
| `Board_DepartAllowAccess` | **PASS** |  |
| `Board_Files` | **PASS** |  |
| `Board_Folders` | **PASS** |  |
| `Board_Heads` | **PASS** |  |
| `Board_HistoryFolder` | **PASS** |  |
| `Board_IOSDevices` | **PASS** |  |
| `Board_Managers` | **PASS** |  |
| `Board_Menu` | **PASS** |  |
| `Board_MultiBoardWidget` | **PASS** |  |
| `Board_NewBoardWidget` | **PASS** |  |
| `Board_NoticePermission` | **PASS** |  |
| `Board_RecommendedLogs` | **PASS** |  |
| `Board_Replies` | **PASS** |  |
| `Board_ReplyFiles` | **PASS** |  |
| `Board_Sharers` | **PASS** |  |
| `Board_UserByGroup` | **PASS** |  |
| `Board_UserSetting` | **PASS** |  |
| `Board_ViewedLogs` | **PASS** |  |
| `DMake_Boards` | **PASS** |  |
| `DMake_Boards_Fields` | **PASS** |  |
| `Main_DashBoards` | **PASS** |  |
| `PhotoBoard` | **PASS** |  |
| `PhotoBoardCmt` | **PASS** |  |
| `PhotoBoardFile` | **PASS** |  |
| `PhotoBoardLog` | **PASS** |  |

## 2. Constraints Deployment Summary

| Constraint Name | Status | Error Details |
|-----------------|--------|---------------|
| `DF_Board_AllowAccess_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_Board_AllowAccess_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_AllowAccess` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_AndroidDevices` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Aut__DTS_I__3B83265D` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Aut__DTS_U__3C774A96` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Aut__USE_Y__3A8F0224` | **STUB (Not converted)** | Stub file / Not converted |
| `PK__Board_Au__E6B77A6E34D628CE` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Boa__SpecT__13A34AE8` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Boards` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Com__IsDel__6E5D82F7` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Com__ModDa__6D695EBE` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Com__RegDa__6C753A85` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_Board_Config_LastestDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Config` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Contents` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_ContentSetting` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Attachs` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Fol__SpecT__12AF26AF` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Folders` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Heads` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_Board_HistoryFolder_IsOpen` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_HistoryFolder` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_IOSDevices` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Men__DTS_I__3E5F9308` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Men__DTS_U__3F53B741` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Men__USE_Y__3D6B6ECF` | **STUB (Not converted)** | Stub file / Not converted |
| `PK__Board_Me__B10590CF38A6B9B2` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Mul__IsDel__46B9A5F1` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Mul__ModDa__45C581B8` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Mul__RegDa__44D15D7F` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_New__IsDel__7FD227BC` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_New__ModDa__7DE9DF4A` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_New__RegDa__7CF5BB11` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_RecommendedLogs` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_Board_Replys_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_Replys` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Use__DTS_I__310597EA` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Board_Use__DTS_U__31F9BC23` | **STUB (Not converted)** | Stub file / Not converted |
| `PK__Board_Us__AE84E1672F1D4F78` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_UserSetting` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Board_ViewedLogs` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_BoardOptions` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_BoardType` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_ChartColors` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_ChartType` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_IsAttachFile` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_IsLog` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_IsNotRightClick` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_ModUserNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_RegUserNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Description` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Enabled` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_FolderNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_IsAnomymous` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_IsApproval` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_IsNotice` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_IsRecommend` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_IsReply` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Name` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Name_Ch` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Name_EN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_NAME_JP` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_Name_VN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_RecommendedDisplayCount` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMakeBoard_SortNo` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_DMakeBoard` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_BoardNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ChartYN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ClassCd` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ControlNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldDataType` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldName` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldReadOnly` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldRequire` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldType` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_FieldUpNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Height` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ImagePath` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Label_CH` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Label_EN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Label_JP` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Label_KO` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Label_VN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_LabelAlign` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_LabelBackColor` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_LabelFontWeight` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ListOrder` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_ListYN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_PopupLink` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_PopupYn` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_SearchYN` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_SortOrder` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_UseYn` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Boards_Fields_Width` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_DMake_Boards_Fields` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Contents_BoardNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_DMake_Field_Copy_History_BoardNo` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Main_DashBoards` | **STUB (Not converted)** | Stub file / Not converted |

## 3. Indexes Deployment Summary

| Index Name | Status | Error Details |
|------------|--------|---------------|
| `idx_Board_AllowAccess_u_i_a_i` | **PASS** |  |
| `idx_Board_Contents_c` | **PASS** |  |
| `idx_Contents_BoardNo_Enabled_RegDate` | **PASS** |  |

