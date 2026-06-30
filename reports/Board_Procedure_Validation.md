# Board_% Procedure Validation Report

**Generated**: 2026-06-30 17:08:13  
**Source**: `CrewCloud_Company_Bootstrap` @ `221.148.141.4,14233`  
**Target**: `pg_converter_runtime_test` @ `221.148.141.4:5432` (PostgreSQL 15.7)  
**Converter fixes applied**: DECLARE extraction, InjectReturnQuery CTE, multi-line IF, semicolons  

## 1. Summary

| Metric | Count |
|--------|------:|
| Total Board_% procedures (SQL Server) | **162** |
| Conversion succeeded | **162** |
| Conversion failed (timeout/error) | **0** |
| Compile PASS (CREATE succeeded) | **162** |
| Compile FAIL | **0** |
| Compile success rate | **100%** |
| SETOF record (needs RETURNS TABLE) | **116** |

## 2. Board_% Procedure Feature Matrix

| Procedure | Params | BodyLen | DynSQL | TempTable | Cursor | HasSelect |
|-----------|-------:|--------:|:------:|:---------:|:------:|:---------:|
| `Board_Authority_Select` | 1 | 2,248 | - | Y | - | Y |
| `Board_Board_MaxSortNo_Select` | 1 | 146 | - | - | - | Y |
| `Board_CheckAllowByItem` | 4 | 587 | - | - | - | Y |
| `Board_CheckPermission` | 2 | 563 | - | - | - | Y |
| `Board_CheckPermissionByContentNo` | 2 | 1,253 | - | - | - | Y |
| `Board_ConvertBoard` | 2 | 155 | - | - | - | - |
| `Board_CountBoardInFolder` | 0 | 179 | - | - | - | Y |
| `Board_CountContentInBoard` | 0 | 176 | - | - | - | Y |
| `Board_CountFolderInFolder` | 0 | 184 | - | - | - | Y |
| `Board_DeleteCommentSetting` | 2 | 443 | - | - | - | - |
| `Board_DeleteCurrentManager` | 2 | 465 | - | - | - | Y |
| `Board_DeleteDepartAllowAccess` | 1 | 1,758 | - | Y | - | Y |
| `Board_DeleteFile` | 1 | 356 | - | - | - | - |
| `Board_DeleteFileByContent` | 1 | 150 | - | - | - | - |
| `Board_DeleteIOSDevice` | 1 | 349 | - | - | - | - |
| `Board_DeleteMultiBoardWidget` | 2 | 464 | - | - | - | - |
| `Board_DeleteNewBoardWidget` | 3 | 473 | - | - | - | - |
| `Board_DeleteNotificationService` | 3 | 588 | - | - | - | Y |
| `Board_DeleteReply` | 1 | 702 | - | - | - | Y |
| `Board_DeleteShare` | 1 | 132 | - | - | - | - |
| `Board_DownBoard` | 1 | 963 | - | - | Y | Y |
| `Board_DownBoardByUser` | 3 | 1,439 | - | - | - | Y |
| `Board_DownFolder` | 1 | 1,011 | - | - | Y | Y |
| `Board_DownFolderByUser` | 3 | 1,425 | - | - | - | Y |
| `Board_DownMultilWidget` | 2 | 801 | - | Y | - | Y |
| `Board_DownMultiWidget` | 2 | 800 | - | Y | - | Y |
| `Board_DownWidget` | 3 | 831 | - | Y | - | Y |
| `Board_Folder_MaxSortNo_Select` | 1 | 147 | - | - | - | Y |
| `Board_GetAllBoardContents` | 15 | 14,283 | Y | Y | - | Y |
| `Board_GetAllBoardContentsByBoardList` | 13 | 8,192 | Y | Y | - | Y |
| `Board_GetAllBoardWidget` | 3 | 1,432 | - | - | - | Y |
| `Board_GetAllowByItem` | 2 | 429 | - | - | - | Y |
| `Board_GetAllowByItemType` | 1 | 396 | - | - | - | Y |
| `Board_GetAllowByUser` | 1 | 389 | - | - | - | Y |
| `Board_GetAndroidDeviceOfAllUsers` | 0 | 277 | - | - | - | Y |
| `Board_GetAndroidDeviceOfUsersByDepartment` | 3 | 951 | - | - | - | Y |
| `Board_GetApprovalDoc` | 1 | 430 | - | - | - | Y |
| `Board_GetApprovalFiles` | 1 | 161 | - | - | - | Y |
| `Board_GetBoard` | 1 | 533 | - | - | - | Y |
| `Board_GetBoardByUserNo` | 5 | 1,992 | - | - | - | Y |
| `Board_GetBoardCommunityWidget` | 3 | 1,470 | - | - | - | Y |
| `Board_GetBoardContent` | 2 | 3,264 | - | - | - | Y |
| `Board_GetBoardContentInfo` | 2 | 2,804 | - | - | - | Y |
| `Board_GetBoardContents` | 13 | 44,733 | Y | Y | - | Y |
| `Board_GetBoardContents_BK20181227` | 13 | 44,742 | Y | Y | - | Y |
| `Board_GetBoards` | 5 | 7,503 | - | - | - | Y |
| `Board_GetBoards_BK` | 5 | 4,009 | - | - | - | Y |
| `Board_GetBoards_Improved` | 5 | 7,512 | - | - | - | Y |
| `Board_GetCommentSetting` | 1 | 197 | - | - | - | Y |
| `Board_GetCompanyList` | 0 | 167 | - | - | - | Y |
| `Board_GetConfig` | 1 | 390 | - | - | - | Y |
| `Board_GetContentSetting` | 1 | 171 | - | - | - | Y |
| `Board_GetCurrentManagerList` | 0 | 857 | - | - | - | Y |
| `Board_GetDepartAllowAccess` | 3 | 1,255 | - | - | - | Y |
| `Board_GetDepartAndPositionName` | 3 | 575 | - | Y | - | Y |
| `Board_GetFile` | 1 | 414 | - | - | - | Y |
| `Board_GetFiles` | 1 | 423 | - | - | - | Y |
| `Board_GetFolderByFolderNo` | 1 | 284 | - | - | - | Y |
| `Board_GetFolderByUserNo` | 3 | 1,875 | - | - | - | Y |
| `Board_GetFolders` | 2 | 1,111 | - | - | - | Y |
| `Board_GetHeads` | 2 | 662 | - | - | - | Y |
| `Board_GetIOSDeviceOfAllUsers` | 0 | 271 | - | - | - | Y |
| `Board_GetIOSDeviceOfUsersByDepartment` | 3 | 938 | - | - | - | Y |
| `Board_GetListBoardContent` | 15 | 13,999 | - | - | - | Y |
| `Board_GetListBoardContent_BK` | 15 | 22,614 | - | - | - | Y |
| `Board_GetListBoardContent_Search` | 14 | 10,670 | - | - | - | Y |
| `Board_GetListBoardContentByFolder` | 15 | 11,231 | - | - | - | Y |
| `Board_GetListBoardContentSearch` | 15 | 10,770 | - | - | - | Y |
| `Board_GetListBoardContentToExcel` | 16 | 8,561 | - | - | - | Y |
| `Board_GetListCommentSetting` | 1 | 826 | - | - | - | Y |
| `Board_GetListConvertUrlFile` | 0 | 85 | - | - | - | Y |
| `Board_GetListNoticePermission` | 9 | 3,166 | - | - | - | Y |
| `Board_GetListUserPermission` | 9 | 10,294 | - | - | - | Y |
| `Board_GetListUserPermissionToExcel` | 9 | 3,836 | - | - | - | Y |
| `Board_GetMaxSortOfTree` | 1 | 283 | - | - | - | Y |
| `Board_GetMultiWidget` | 3 | 1,436 | - | - | - | Y |
| `Board_GetNewBoardContent` | 5 | 1,659 | - | - | - | Y |
| `Board_GetNewBoardWidget` | 2 | 854 | - | - | - | Y |
| `Board_GetOpenFolder` | 1 | 213 | - | - | - | Y |
| `Board_GetPreNextContent` | 5 | 15,643 | - | Y | - | Y |
| `Board_GetRecommendCount` | 1 | 429 | - | - | - | Y |
| `Board_GetRecommendedLogByUserNo` | 2 | 551 | - | - | - | Y |
| `Board_GetRecommendedLogs` | 1 | 512 | - | - | - | Y |
| `Board_GetRecommendLogCount` | 1 | 413 | - | - | - | Y |
| `Board_GetReplies` | 2 | 1,432 | - | - | - | Y |
| `Board_GetReply` | 1 | 528 | - | - | - | Y |
| `Board_GetReplyByContent` | 3 | 2,587 | - | - | - | Y |
| `Board_GetReplyFileByContentNo` | 1 | 529 | - | - | - | Y |
| `Board_GetReplyFileByReplyFileNo` | 1 | 459 | - | - | - | Y |
| `Board_GetReplyFileByReplyNo` | 1 | 432 | - | - | - | Y |
| `Board_GetSettingCommunityWidget` | 1 | 933 | - | - | - | Y |
| `Board_GetSharers` | 1 | 282 | - | - | - | Y |
| `Board_GetStatusApprovalPermission` | 2 | 240 | - | - | - | Y |
| `Board_GetSubMenus` | 3 | 4,516 | - | - | - | Y |
| `Board_GetTeamList` | 1 | 381 | - | - | - | Y |
| `Board_GetTeamName` | 2 | 533 | - | - | - | Y |
| `Board_GetTreeBoard` | 4 | 2,951 | - | - | - | Y |
| `Board_GetTreeSubMenu` | 3 | 8,466 | - | - | - | Y |
| `Board_GetTreeSubMenu_V2` | 5 | 3,659 | - | - | - | Y |
| `Board_GetTreeSubMenu_V2_Json` | 5 | 8,883 | - | Y | - | Y |
| `Board_GetTreeSubMenuTest` | 3 | 3,793 | - | - | - | Y |
| `Board_GetUserByShare` | 1 | 1,795 | - | - | - | Y |
| `Board_GetUserSetting` | 1 | 404 | - | - | - | Y |
| `Board_GetViewedLogs` | 1 | 1,300 | - | - | - | Y |
| `Board_GetWidgetCarousel` | 5 | 2,362 | - | - | - | Y |
| `Board_InsertAndroidDevice` | 6 | 610 | - | - | - | Y |
| `Board_InsertBoard` | 14 | 1,033 | - | - | - | - |
| `Board_InsertBoardContent` | 45 | 2,960 | - | - | - | Y |
| `Board_InsertCommentSetting` | 2 | 390 | - | - | - | Y |
| `Board_InsertCurrentManager` | 7 | 745 | - | - | - | Y |
| `Board_InsertDepartAllowAccess` | 5 | 632 | - | - | - | Y |
| `Board_InsertFile` | 5 | 689 | - | - | - | Y |
| `Board_InsertIOSDevice` | 6 | 596 | - | - | - | Y |
| `Board_InsertMultiBoardWidget` | 2 | 491 | - | - | - | Y |
| `Board_InsertNewBoardWidget` | 3 | 521 | - | - | - | Y |
| `Board_InsertNotificationService` | 13 | 2,080 | - | Y | - | Y |
| `Board_InsertRecommendedLog` | 9 | 1,341 | - | - | - | Y |
| `Board_InsertReply` | 13 | 1,532 | - | - | - | Y |
| `Board_InsertReplyFile` | 4 | 578 | - | - | - | Y |
| `Board_InsertUserSetting` | 3 | 736 | - | - | - | Y |
| `Board_InsertViewedLog` | 10 | 1,078 | - | - | - | Y |
| `Board_Mobile_Search` | 5 | 6,711 | Y | Y | - | Y |
| `Board_SetAllHistoryFolder` | 2 | 537 | - | - | - | Y |
| `Board_SetContentSetting` | 2 | 303 | - | - | - | - |
| `Board_SetFolders` | 6 | 567 | - | - | - | Y |
| `Board_SetHistoryFolder` | 3 | 329 | - | - | - | - |
| `Board_SetShare` | 5 | 636 | - | - | - | Y |
| `Board_TreeBoard` | 0 | 996 | - | - | - | Y |
| `Board_UpBoard` | 1 | 961 | - | - | Y | Y |
| `Board_UpBoardByUser` | 3 | 1,445 | - | - | - | Y |
| `Board_UpdateAllowAccess` | 6 | 7,758 | - | Y | - | Y |
| `Board_UpdateAndroidDevice_NotificationOptions` | 3 | 773 | - | - | - | - |
| `Board_UpdateAndroidDevice_TimezoneOffset` | 3 | 480 | - | - | - | - |
| `Board_UpdateApprovalDoc` | 3 | 245 | - | - | - | - |
| `Board_UpdateBoard` | 14 | 884 | - | - | - | - |
| `Board_UpdateBoardContent` | 41 | 2,290 | - | - | - | Y |
| `Board_UpdateBoardContent_Content` | 2 | 435 | - | - | - | - |
| `Board_UpdateBoardContent_Enabled` | 3 | 476 | - | - | - | - |
| `Board_UpdateBoardContent_EnabledForUser` | 4 | 520 | - | - | - | - |
| `Board_UpdateBoardContent_IsNotice` | 3 | 481 | - | - | - | - |
| `Board_UpdateBoardContent_TitleEffect` | 3 | 490 | - | - | - | - |
| `Board_UpdateBoardContent_Viewed` | 1 | 422 | - | - | - | - |
| `Board_UpdateBoardCustorm` | 2 | 193 | - | - | - | - |
| `Board_UpdateConfig` | 3 | 802 | - | - | - | Y |
| `Board_UpdateDepartAllowAccess` | 5 | 6,402 | - | Y | - | Y |
| `Board_UpdateFile` | 5 | 534 | - | - | - | Y |
| `Board_UpdateFolder` | 7 | 670 | - | - | - | Y |
| `Board_UpdateIOSDevice_NotificationOptions` | 3 | 512 | - | - | - | - |
| `Board_UpdateLevelRand` | 2 | 885 | - | - | Y | Y |
| `Board_UpdateNoticePermission` | 5 | 529 | - | - | - | Y |
| `Board_UpdateNotificationService` | 13 | 2,871 | - | Y | - | Y |
| `Board_UpdatePermissionsByParent` | 2 | 528 | - | - | - | Y |
| `Board_UpdateRecommendPublic` | 2 | 481 | - | - | - | Y |
| `Board_UpdateReply` | 10 | 869 | - | - | - | - |
| `Board_UpdateSpecType` | 3 | 2,291 | - | Y | - | Y |
| `Board_UpdateStatusApproval` | 7 | 483 | - | - | - | Y |
| `Board_UpFolder` | 1 | 1,009 | - | - | Y | Y |
| `Board_UpFolderByUser` | 3 | 1,466 | - | - | - | Y |
| `Board_UpMultiWidget` | 2 | 798 | - | Y | - | Y |
| `Board_UpWidget` | 3 | 828 | - | Y | - | Y |
| `Board_UserCollection_Select` | 0 | 574 | - | - | - | Y |
| `Board_Web_Search` | 15 | 19,259 | Y | Y | - | Y |

> Total: 162 | DynSQL: 6 | TempTable: 21 | Cursor: 5

## 3. Compile Results

### 3a. PASS

162 procedures compiled successfully:

- `Board_Authority_Select`
- `Board_Board_MaxSortNo_Select`
- `Board_CheckAllowByItem`
- `Board_CheckPermission`
- `Board_CheckPermissionByContentNo`
- `Board_ConvertBoard`
- `Board_CountBoardInFolder`
- `Board_CountContentInBoard`
- `Board_CountFolderInFolder`
- `Board_DeleteCommentSetting`
- `Board_DeleteCurrentManager`
- `Board_DeleteDepartAllowAccess`
- `Board_DeleteFile`
- `Board_DeleteFileByContent`
- `Board_DeleteIOSDevice`
- `Board_DeleteMultiBoardWidget`
- `Board_DeleteNewBoardWidget`
- `Board_DeleteNotificationService`
- `Board_DeleteReply`
- `Board_DeleteShare`
- `Board_DownBoard`
- `Board_DownBoardByUser`
- `Board_DownFolder`
- `Board_DownFolderByUser`
- `Board_DownMultilWidget`
- `Board_DownMultiWidget`
- `Board_DownWidget`
- `Board_Folder_MaxSortNo_Select`
- `Board_GetAllBoardContents`
- `Board_GetAllBoardContentsByBoardList`
- `Board_GetAllBoardWidget`
- `Board_GetAllowByItem`
- `Board_GetAllowByItemType`
- `Board_GetAllowByUser`
- `Board_GetAndroidDeviceOfAllUsers`
- `Board_GetAndroidDeviceOfUsersByDepartment`
- `Board_GetApprovalDoc`
- `Board_GetApprovalFiles`
- `Board_GetBoard`
- `Board_GetBoardByUserNo`
- `Board_GetBoardCommunityWidget`
- `Board_GetBoardContent`
- `Board_GetBoardContentInfo`
- `Board_GetBoardContents`
- `Board_GetBoardContents_BK20181227`
- `Board_GetBoards`
- `Board_GetBoards_BK`
- `Board_GetBoards_Improved`
- `Board_GetCommentSetting`
- `Board_GetCompanyList`
- `Board_GetConfig`
- `Board_GetContentSetting`
- `Board_GetCurrentManagerList`
- `Board_GetDepartAllowAccess`
- `Board_GetDepartAndPositionName`
- `Board_GetFile`
- `Board_GetFiles`
- `Board_GetFolderByFolderNo`
- `Board_GetFolderByUserNo`
- `Board_GetFolders`
- `Board_GetHeads`
- `Board_GetIOSDeviceOfAllUsers`
- `Board_GetIOSDeviceOfUsersByDepartment`
- `Board_GetListBoardContent`
- `Board_GetListBoardContent_BK`
- `Board_GetListBoardContent_Search`
- `Board_GetListBoardContentByFolder`
- `Board_GetListBoardContentSearch`
- `Board_GetListBoardContentToExcel`
- `Board_GetListCommentSetting`
- `Board_GetListConvertUrlFile`
- `Board_GetListNoticePermission`
- `Board_GetListUserPermission`
- `Board_GetListUserPermissionToExcel`
- `Board_GetMaxSortOfTree`
- `Board_GetMultiWidget`
- `Board_GetNewBoardContent`
- `Board_GetNewBoardWidget`
- `Board_GetOpenFolder`
- `Board_GetPreNextContent`
- `Board_GetRecommendCount`
- `Board_GetRecommendedLogByUserNo`
- `Board_GetRecommendedLogs`
- `Board_GetRecommendLogCount`
- `Board_GetReplies`
- `Board_GetReply`
- `Board_GetReplyByContent`
- `Board_GetReplyFileByContentNo`
- `Board_GetReplyFileByReplyFileNo`
- `Board_GetReplyFileByReplyNo`
- `Board_GetSettingCommunityWidget`
- `Board_GetSharers`
- `Board_GetStatusApprovalPermission`
- `Board_GetSubMenus`
- `Board_GetTeamList`
- `Board_GetTeamName`
- `Board_GetTreeBoard`
- `Board_GetTreeSubMenu`
- `Board_GetTreeSubMenu_V2`
- `Board_GetTreeSubMenu_V2_Json`
- `Board_GetTreeSubMenuTest`
- `Board_GetUserByShare`
- `Board_GetUserSetting`
- `Board_GetViewedLogs`
- `Board_GetWidgetCarousel`
- `Board_InsertAndroidDevice`
- `Board_InsertBoard`
- `Board_InsertBoardContent`
- `Board_InsertCommentSetting`
- `Board_InsertCurrentManager`
- `Board_InsertDepartAllowAccess`
- `Board_InsertFile`
- `Board_InsertIOSDevice`
- `Board_InsertMultiBoardWidget`
- `Board_InsertNewBoardWidget`
- `Board_InsertNotificationService`
- `Board_InsertRecommendedLog`
- `Board_InsertReply`
- `Board_InsertReplyFile`
- `Board_InsertUserSetting`
- `Board_InsertViewedLog`
- `Board_Mobile_Search`
- `Board_SetAllHistoryFolder`
- `Board_SetContentSetting`
- `Board_SetFolders`
- `Board_SetHistoryFolder`
- `Board_SetShare`
- `Board_TreeBoard`
- `Board_UpBoard`
- `Board_UpBoardByUser`
- `Board_UpdateAllowAccess`
- `Board_UpdateAndroidDevice_NotificationOptions`
- `Board_UpdateAndroidDevice_TimezoneOffset`
- `Board_UpdateApprovalDoc`
- `Board_UpdateBoard`
- `Board_UpdateBoardContent`
- `Board_UpdateBoardContent_Content`
- `Board_UpdateBoardContent_Enabled`
- `Board_UpdateBoardContent_EnabledForUser`
- `Board_UpdateBoardContent_IsNotice`
- `Board_UpdateBoardContent_TitleEffect`
- `Board_UpdateBoardContent_Viewed`
- `Board_UpdateBoardCustorm`
- `Board_UpdateConfig`
- `Board_UpdateDepartAllowAccess`
- `Board_UpdateFile`
- `Board_UpdateFolder`
- `Board_UpdateIOSDevice_NotificationOptions`
- `Board_UpdateLevelRand`
- `Board_UpdateNoticePermission`
- `Board_UpdateNotificationService`
- `Board_UpdatePermissionsByParent`
- `Board_UpdateRecommendPublic`
- `Board_UpdateReply`
- `Board_UpdateSpecType`
- `Board_UpdateStatusApproval`
- `Board_UpFolder`
- `Board_UpFolderByUser`
- `Board_UpMultiWidget`
- `Board_UpWidget`
- `Board_UserCollection_Select`
- `Board_Web_Search`

### 3b. FAIL

All procedures compiled successfully.

## 5. SETOF record — Needs Manual RETURNS TABLE(...)

116 procedures have `RETURNS SETOF record` and need explicit column types:

- `Board_Authority_Select`
- `Board_Board_MaxSortNo_Select`
- `Board_CheckAllowByItem`
- `Board_CheckPermission`
- `Board_CheckPermissionByContentNo`
- `Board_CountBoardInFolder`
- `Board_CountContentInBoard`
- `Board_CountFolderInFolder`
- `Board_DeleteNotificationService`
- `Board_DownBoardByUser`
- `Board_DownFolderByUser`
- `Board_Folder_MaxSortNo_Select`
- `Board_GetAllBoardContents`
- `Board_GetAllBoardContentsByBoardList`
- `Board_GetAllBoardWidget`
- `Board_GetAllowByItem`
- `Board_GetAllowByItemType`
- `Board_GetAllowByUser`
- `Board_GetAndroidDeviceOfAllUsers`
- `Board_GetAndroidDeviceOfUsersByDepartment`
- `Board_GetApprovalDoc`
- `Board_GetApprovalFiles`
- `Board_GetBoard`
- `Board_GetBoardByUserNo`
- `Board_GetBoardCommunityWidget`
- `Board_GetBoardContent`
- `Board_GetBoardContentInfo`
- `Board_GetBoardContents`
- `Board_GetBoardContents_BK20181227`
- `Board_GetBoards`
- `Board_GetBoards_BK`
- `Board_GetBoards_Improved`
- `Board_GetCommentSetting`
- `Board_GetCompanyList`
- `Board_GetConfig`
- `Board_GetContentSetting`
- `Board_GetCurrentManagerList`
- `Board_GetDepartAllowAccess`
- `Board_GetDepartAndPositionName`
- `Board_GetFile`
- `Board_GetFiles`
- `Board_GetFolderByFolderNo`
- `Board_GetFolderByUserNo`
- `Board_GetFolders`
- `Board_GetHeads`
- `Board_GetIOSDeviceOfAllUsers`
- `Board_GetIOSDeviceOfUsersByDepartment`
- `Board_GetListBoardContent`
- `Board_GetListBoardContent_BK`
- `Board_GetListBoardContent_Search`
- `Board_GetListBoardContentByFolder`
- `Board_GetListBoardContentSearch`
- `Board_GetListBoardContentToExcel`
- `Board_GetListCommentSetting`
- `Board_GetListConvertUrlFile`
- `Board_GetListNoticePermission`
- `Board_GetListUserPermission`
- `Board_GetListUserPermissionToExcel`
- `Board_GetMaxSortOfTree`
- `Board_GetMultiWidget`
- `Board_GetNewBoardContent`
- `Board_GetNewBoardWidget`
- `Board_GetOpenFolder`
- `Board_GetPreNextContent`
- `Board_GetRecommendCount`
- `Board_GetRecommendedLogByUserNo`
- `Board_GetRecommendedLogs`
- `Board_GetRecommendLogCount`
- `Board_GetReplies`
- `Board_GetReply`
- `Board_GetReplyByContent`
- `Board_GetReplyFileByContentNo`
- `Board_GetReplyFileByReplyFileNo`
- `Board_GetReplyFileByReplyNo`
- `Board_GetSettingCommunityWidget`
- `Board_GetSharers`
- `Board_GetStatusApprovalPermission`
- `Board_GetSubMenus`
- `Board_GetTeamList`
- `Board_GetTeamName`
- `Board_GetTreeBoard`
- `Board_GetTreeSubMenu`
- `Board_GetTreeSubMenu_V2`
- `Board_GetTreeSubMenu_V2_Json`
- `Board_GetTreeSubMenuTest`
- `Board_GetUserByShare`
- `Board_GetUserSetting`
- `Board_GetViewedLogs`
- `Board_GetWidgetCarousel`
- `Board_InsertAndroidDevice`
- `Board_InsertBoardContent`
- `Board_InsertCurrentManager`
- `Board_InsertDepartAllowAccess`
- `Board_InsertFile`
- `Board_InsertIOSDevice`
- `Board_InsertRecommendedLog`
- `Board_InsertReply`
- `Board_InsertReplyFile`
- `Board_InsertUserSetting`
- `Board_InsertViewedLog`
- `Board_Mobile_Search`
- `Board_SetFolders`
- `Board_SetShare`
- `Board_TreeBoard`
- `Board_UpBoardByUser`
- `Board_UpdateBoardContent`
- `Board_UpdateConfig`
- `Board_UpdateDepartAllowAccess`
- `Board_UpdateFile`
- `Board_UpdateFolder`
- `Board_UpdateNoticePermission`
- `Board_UpdateRecommendPublic`
- `Board_UpdateStatusApproval`
- `Board_UpFolderByUser`
- `Board_UserCollection_Select`
- `Board_Web_Search`

## 6. Converter Fixes Applied This Session

| Bug | Fix |
|-----|-----|
| DECLARE extraction failed on Windows `\r\n` line endings | Added `\r?` before `$` in extraction regex |
| Multi-variable `DECLARE @A INT, @B INT` only captured first variable | Rewrote to iterate all `@var TYPE` pairs |
| `DECLARE @tmp TABLE(...)` incorrectly extracted as type `TABLE(...)` | Added `(?!TABLE\b)` negative lookahead |
| `InjectReturnQuery` placed `RETURN QUERY` after `WITH CTE AS (...)` instead of before it | Detect CTE start, inject before WITH, skip the subsequent SELECT |
| Multi-line IF/WHILE conditions (condition spans multiple lines) truncated to first line | `ConvertControlFlow` now uses indexed loop and collects lines until parens balance |
| Missing `;` before plpgsql `:=` after multi-line INSERT/VALUES | Extended DML semicolon rule to cover `\w+ :=` | 
| Double `;` when line already ends with `;` followed by INSERT/DELETE/UPDATE | Added negative lookbehind `(?<!;)` to DML rule |

## 7. Remaining Blockers

| # | Issue | Affected | Notes |
|---|-------|----------|-------|
| 1 | SETOF record → needs RETURNS TABLE | 116 procedures | Infer column types from SELECT list per procedure |

