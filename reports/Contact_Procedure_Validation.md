# Contact_% Procedure Validation Report

**Generated**: 2026-07-01 07:03:48  
**Source**: `CrewCloud_Company_Bootstrap` @ `221.148.141.4,14233`  
**Target**: `pg_converter_runtime_test` @ `221.148.141.4:5432` (PostgreSQL 15.7)  
**Converter fixes applied**: DECLARE extraction, InjectReturnQuery CTE, multi-line IF, semicolons  

## 1. Summary

| Metric | Count |
|--------|------:|
| Total Contact_% procedures (SQL Server) | **189** |
| Conversion succeeded | **189** |
| Conversion failed (timeout/error) | **0** |
| Compile PASS (CREATE succeeded) | **189** |
| Compile FAIL | **0** |
| Compile success rate | **100%** |
| SETOF record (needs RETURNS TABLE) | **141** |

## 2. Contact_% Procedure Feature Matrix

| Procedure | Params | BodyLen | DynSQL | TempTable | Cursor | HasSelect |
|-----------|-------:|--------:|:------:|:---------:|:------:|:---------:|
| `Contact_CheckInsertGroupDefault` | 3 | 609 | - | - | - | Y |
| `Contact_GetGroupDefaultByUserNo` | 2 | 266 | - | - | - | Y |
| `Contact_InsertShareGroup` | 3 | 501 | - | - | - | Y |
| `Contacts_ChangeGroup` | 2 | 454 | - | - | - | Y |
| `Contacts_ChangePublicGroup` | 3 | 1,411 | - | - | Y | Y |
| `Contacts_ChangeShareGroup` | 3 | 1,295 | - | - | Y | Y |
| `Contacts_CheckExitGroupAndContact` | 3 | 289 | - | - | - | Y |
| `Contacts_CheckGroup` | 3 | 632 | - | - | - | Y |
| `Contacts_CheckNumber` | 3 | 726 | - | - | - | Y |
| `contacts_countgroupcountchild` | 2 | 462 | - | - | - | Y |
| `Contacts_CountGroupUser` | 1 | 186 | - | - | - | Y |
| `Contacts_CountUserPublicWithoutGroup` | 0 | 304 | - | - | - | Y |
| `Contacts_CountUserShareWithoutGroup` | 1 | 570 | - | - | - | Y |
| `Contacts_DelAllContactsTrash` | 1 | 1,518 | - | - | - | Y |
| `Contacts_DelContactsGroup` | 1 | 1,189 | - | Y | - | Y |
| `Contacts_DelContactsShare` | 1 | 125 | - | - | - | - |
| `Contacts_DelContactsUser` | 3 | 1,059 | - | - | - | - |
| `Contacts_DeleteAddressAll` | 3 | 1,179 | - | - | - | - |
| `Contacts_DeleteAllGroupByUserSeq` | 2 | 416 | - | - | - | Y |
| `Contacts_DeleteBackupInfo` | 1 | 331 | - | - | - | - |
| `Contacts_DeleteContact` | 1 | 599 | - | - | - | - |
| `Contacts_DeleteDepartAllowAccess` | 1 | 1,478 | - | Y | - | Y |
| `Contacts_DeleteHistory` | 1 | 1,421 | - | - | - | - |
| `Contacts_DeletePublicGroup` | 2 | 243 | - | - | - | Y |
| `Contacts_DeleteShareGroup` | 2 | 234 | - | - | - | Y |
| `Contacts_DownPublicGroup` | 3 | 700 | - | - | - | Y |
| `Contacts_DownShareGroup` | 3 | 686 | - | - | - | Y |
| `Contacts_FinAll` | 7 | 11,502 | - | - | - | Y |
| `Contacts_FindNoNameUser` | 6 | 31,207 | - | - | - | Y |
| `Contacts_FindUser` | 7 | 42,628 | - | - | - | Y |
| `Contacts_GetAddressInfo` | 1 | 978 | - | - | - | Y |
| `Contacts_GetAddressNotUpdateCount` | 1 | 557 | - | - | - | Y |
| `Contacts_GetAllAddress` | 1 | 162 | - | - | - | Y |
| `Contacts_GetAllCompany` | 1 | 363 | - | - | - | Y |
| `Contacts_GetAllContactsList` | 1 | 533 | - | - | - | Y |
| `Contacts_GetAllDays` | 1 | 358 | - | - | - | Y |
| `Contacts_GetAllEmail` | 1 | 360 | - | - | - | Y |
| `Contacts_GetAllGroup` | 2 | 1,248 | - | - | - | Y |
| `Contacts_GetAllGroups` | 1 | 456 | - | - | - | Y |
| `Contacts_GetAllGroupsRestore` | 1 | 423 | - | - | - | Y |
| `Contacts_GetAllGroupUser` | 1 | 166 | - | - | - | Y |
| `Contacts_GetAllHomepage` | 1 | 367 | - | - | - | Y |
| `Contacts_GetAllListGroupContact` | 1 | 173 | - | - | - | Y |
| `Contacts_GetAllNumber` | 1 | 363 | - | - | - | Y |
| `Contacts_GetAllSns` | 1 | 356 | - | - | - | Y |
| `Contacts_GetAllUser` | 1 | 139 | - | - | - | Y |
| `Contacts_GetAllUser_Distinct` | 3 | 856 | - | - | - | Y |
| `Contacts_GetAllUserNotRequite` | 1 | 151 | - | - | - | Y |
| `Contacts_GetBackupInfo` | 1 | 360 | - | - | - | Y |
| `Contacts_GetBackupInfoOnce` | 1 | 413 | - | - | - | Y |
| `Contacts_GetCheckGroup` | 2 | 401 | - | - | - | Y |
| `Contacts_GetContactGroup` | 2 | 1,205 | - | - | - | Y |
| `Contacts_GetContactsCount` | 7 | 3,191 | Y | - | - | Y |
| `Contacts_GetContactsForOutlook` | 1 | 3,890 | - | - | - | Y |
| `Contacts_GetContactsGroup` | 2 | 357 | - | - | - | Y |
| `Contacts_GetContactsList` | 9 | 4,175 | Y | - | - | Y |
| `Contacts_GetContactsTrashList` | 10 | 87,759 | - | - | - | Y |
| `Contacts_GetCountChildUser` | 2 | 549 | - | - | - | Y |
| `Contacts_GetDefaultBoxCount` | 1 | 622 | - | - | - | Y |
| `Contacts_GetDefaultCategory` | 1 | 414 | - | - | - | Y |
| `Contacts_GetDepartAllowAccess` | 2 | 1,277 | - | - | - | Y |
| `Contacts_GetDepartmentBoxCount` | 1 | 539 | - | - | - | Y |
| `Contacts_GetDupeList` | 1 | 1,035 | - | - | - | Y |
| `Contacts_GetGroupBySeq` | 2 | 1,397 | - | - | - | Y |
| `Contacts_GetGroupByUser` | 2 | 741 | - | - | - | Y |
| `Contacts_GetGroupInfo` | 1 | 311 | - | - | - | Y |
| `Contacts_GetGroupList` | 1 | 292 | - | - | - | Y |
| `Contacts_GetHistoryList` | 7 | 1,500 | - | - | - | Y |
| `Contacts_GetHistoryListCount` | 5 | 795 | - | - | - | Y |
| `Contacts_GetLatitudeAndLongitudeContacts` | 1 | 397 | - | - | - | Y |
| `Contacts_GetLatitudeAndLongitudeOneContacts` | 1 | 315 | - | - | - | Y |
| `Contacts_GetLikeList` | 1 | 1,254 | - | - | - | Y |
| `Contacts_GetListGroup` | 1 | 172 | - | - | - | Y |
| `Contacts_GetListGroupWithId` | 1 | 152 | - | - | - | Y |
| `Contacts_GetLocationOneContact` | 2 | 286 | - | - | - | Y |
| `Contacts_GetLocations` | 1 | 280 | - | - | - | Y |
| `Contacts_GetNameGroup` | 2 | 350 | - | - | - | Y |
| `Contacts_GetOneAddress` | 1 | 180 | - | - | - | Y |
| `Contacts_GetOneRowChildGroup` | 2 | 534 | - | - | - | Y |
| `Contacts_GetOutFile` | 2 | 1,899 | - | Y | - | Y |
| `Contacts_GetOutFileExcel` | 2 | 2,891 | - | Y | - | Y |
| `Contacts_GetOutList` | 2 | 2,897 | - | Y | - | Y |
| `Contacts_GetOutListCount` | 2 | 1,171 | - | Y | - | Y |
| `Contacts_GetOutListExcel` | 5 | 12,373 | - | Y | - | Y |
| `Contacts_GetPrivateBoxCount` | 1 | 392 | - | - | - | Y |
| `Contacts_GetPublicBoxCount` | 1 | 509 | - | - | - | Y |
| `Contacts_GetPublicGroup` | 1 | 868 | - | - | - | Y |
| `Contacts_GetRankList` | 1 | 688 | - | - | - | Y |
| `Contacts_GetRankListCount` | 1 | 485 | - | - | - | Y |
| `Contacts_GetSetup` | 1 | 194 | - | - | - | Y |
| `Contacts_GetShareDepartmentDefault` | 2 | 593 | - | - | - | Y |
| `Contacts_GetShareGroup` | 3 | 2,906 | - | - | - | Y |
| `Contacts_GetShareGroupByUser` | 3 | 1,661 | - | - | - | Y |
| `Contacts_GetShareGroupSetting` | 1 | 554 | - | - | - | Y |
| `Contacts_GetSharers` | 1 | 138 | - | - | - | Y |
| `Contacts_GetTopCategory` | 1 | 483 | - | - | - | Y |
| `Contacts_GetTrashCount` | 1 | 384 | - | - | - | Y |
| `Contacts_GetTrashUserList` | 6 | 2,210 | - | - | - | Y |
| `Contacts_GetUser` | 8 | 9,048 | - | - | - | Y |
| `Contacts_GetUser_Address` | 1 | 467 | - | - | - | Y |
| `Contacts_GetUser_Company` | 1 | 441 | - | - | - | Y |
| `Contacts_GetUser_Days` | 1 | 448 | - | - | - | Y |
| `Contacts_GetUser_Department` | 8 | 4,203 | - | - | - | Y |
| `Contacts_GetUser_Email` | 1 | 414 | - | - | - | Y |
| `Contacts_GetUser_GroupInfo` | 2 | 450 | - | - | - | Y |
| `Contacts_GetUser_Homepage` | 1 | 443 | - | - | - | Y |
| `Contacts_GetUser_Noname` | 3 | 878 | - | - | - | Y |
| `Contacts_GetUser_Number` | 1 | 439 | - | - | - | Y |
| `Contacts_GetUser_PhoneInfo` | 1 | 376 | - | - | - | Y |
| `Contacts_GetUser_Share` | 8 | 4,070 | - | - | - | Y |
| `Contacts_GetUser_SNS` | 1 | 432 | - | - | - | Y |
| `Contacts_GetUser_ToGroup` | 9 | 16,172 | - | - | - | Y |
| `Contacts_GetUser_ToGroupMobile` | 8 | 4,816 | - | - | - | Y |
| `Contacts_GetUser_ToUserNo` | 1 | 349 | - | - | - | Y |
| `Contacts_GetUser_UnGroup` | 5 | 4,273 | - | - | - | Y |
| `Contacts_GetUserByPublicGroup` | 8 | 4,568 | - | - | - | Y |
| `Contacts_GetUserByShareGroup` | 9 | 9,710 | - | - | - | Y |
| `Contacts_GetUserData` | 3 | 3,453 | - | - | - | Y |
| `Contacts_GetUserDataHistory` | 4 | 4,321 | - | - | - | Y |
| `Contacts_GetUserDetail` | 1 | 1,597 | - | - | - | Y |
| `Contacts_GetUserGroup` | 3 | 955 | - | - | - | Y |
| `Contacts_GetUserGroupByLanguage` | 2 | 1,020 | - | - | - | Y |
| `Contacts_GetUserGroupByUserNo` | 2 | 880 | - | - | - | Y |
| `Contacts_GetUserGroupMobi` | 4 | 743 | - | - | - | Y |
| `Contacts_GetUserNumber` | 2 | 422 | - | - | - | Y |
| `Contacts_InsertBackupInfo` | 5 | 582 | - | - | - | Y |
| `Contacts_InsertContactForOutlookEntryID` | 3 | 851 | - | - | - | Y |
| `Contacts_InsertContactForOutlookFolderEntryID` | 3 | 903 | - | - | - | Y |
| `Contacts_InsertGroup` | 3 | 510 | - | - | - | Y |
| `Contacts_InsertListGroup` | 2 | 590 | - | - | - | Y |
| `Contacts_InsertListGroupContact` | 2 | 267 | - | - | - | - |
| `Contacts_InsertPublicGroup` | 3 | 559 | - | - | - | Y |
| `Contacts_InsertShareGroup` | 3 | 574 | - | - | - | Y |
| `Contacts_InsertUser` | 9 | 1,350 | - | - | - | - |
| `Contacts_InsertUserForExcel` | 25 | 4,201 | - | - | - | Y |
| `Contacts_ListGroupContent` | 1 | 273 | - | - | - | Y |
| `Contacts_MoveAllContact` | 3 | 317 | - | - | - | - |
| `Contacts_MoveContactGroup` | 4 | 1,050 | - | - | Y | Y |
| `Contacts_MoveUser` | 4 | 608 | - | - | - | - |
| `Contacts_ParentGroupNo` | 2 | 415 | - | - | - | Y |
| `Contacts_RestoreContactList` | 2 | 271 | - | - | - | Y |
| `Contacts_SaveAddressInfo` | 17 | 28,984 | - | Y | - | Y |
| `Contacts_SaveAddressInfo_Web` | 18 | 30,602 | - | Y | - | Y |
| `Contacts_SaveArrange` | 5 | 10,219 | - | - | - | Y |
| `Contacts_SaveArrangeLike` | 5 | 10,223 | - | - | - | Y |
| `Contacts_SaveContactsForOutlook` | 27 | 14,917 | - | - | - | Y |
| `Contacts_SaveContactsHistory` | 3 | 3,491 | - | - | - | Y |
| `Contacts_SaveGroupForOutlook` | 3 | 1,130 | - | - | - | Y |
| `Contacts_SaveLocation` | 8 | 1,110 | - | - | - | - |
| `Contacts_SaveRestore` | 1 | 11,706 | - | - | - | Y |
| `Contacts_SaveSetup` | 4 | 891 | - | - | - | Y |
| `Contacts_Search_NoDistance` | 6 | 2,741 | - | - | - | Y |
| `Contacts_SearchMobi` | 3 | 1,233 | - | - | - | Y |
| `Contacts_SeqToName` | 2 | 375 | - | - | - | Y |
| `Contacts_SetAddress` | 8 | 535 | - | - | - | - |
| `Contacts_SetCallPhone` | 1 | 135 | - | - | - | - |
| `Contacts_SetCompany` | 6 | 465 | - | - | - | - |
| `Contacts_SetContactsGroup` | 5 | 702 | - | - | - | Y |
| `Contacts_SetContactsRestore` | 3 | 316 | - | - | - | - |
| `Contacts_SetContactsTrash` | 2 | 570 | - | - | - | - |
| `Contacts_SetContactsUser` | 9 | 1,649 | - | Y | - | Y |
| `Contacts_SetDays` | 7 | 392 | - | - | - | - |
| `Contacts_SetEmail` | 4 | 364 | - | - | - | - |
| `Contacts_SetMoveContacts` | 3 | 467 | - | - | - | - |
| `Contacts_SetNumber` | 6 | 436 | - | - | - | - |
| `Contacts_SetShare` | 4 | 549 | - | - | - | Y |
| `Contacts_SetSns` | 4 | 274 | - | - | - | - |
| `Contacts_SetUserCheckDate` | 2 | 434 | - | - | - | - |
| `Contacts_UpdateAndroidDevice_NotificationOptions` | 3 | 771 | - | - | - | - |
| `Contacts_UpdateContactGroupUser` | 3 | 801 | - | - | - | Y |
| `Contacts_UpdateContactImportant` | 2 | 186 | - | - | - | - |
| `Contacts_UpDateContactsUser` | 9 | 1,421 | - | Y | - | Y |
| `Contacts_UpdateDepartAllowAccess` | 4 | 3,581 | - | Y | - | Y |
| `Contacts_UpdateGroup` | 3 | 215 | - | - | - | - |
| `Contacts_UpdateGroupMemo` | 3 | 416 | - | - | - | - |
| `Contacts_UpdateGroupParent` | 2 | 391 | - | - | - | - |
| `Contacts_UpdateGroupState` | 2 | 431 | - | - | - | - |
| `Contacts_UpdateListGroup` | 4 | 475 | - | - | - | - |
| `Contacts_UpdateListGroupContact` | 2 | 194 | - | - | - | - |
| `Contacts_UpdatePublicGroup` | 3 | 276 | - | - | - | Y |
| `Contacts_UpdatePublicGroupUser` | 3 | 870 | - | - | - | Y |
| `Contacts_UpdateShareGroup` | 3 | 272 | - | - | - | Y |
| `Contacts_UpdateShareGroupUser` | 3 | 972 | - | - | - | Y |
| `Contacts_UpdateSortDownOfGroup` | 3 | 587 | - | - | - | Y |
| `Contacts_UpdateSortUpOfGroup` | 3 | 573 | - | - | - | Y |
| `Contacts_UpdateUserInfo` | 18 | 30,802 | - | Y | - | Y |
| `Contacts_UpdateUserState` | 2 | 426 | - | - | - | - |
| `Contacts_UpPublicGroup` | 3 | 688 | - | - | - | Y |
| `Contacts_UpShareGroup` | 3 | 673 | - | - | - | Y |

> Total: 189 | DynSQL: 2 | TempTable: 13 | Cursor: 3

## 3. Compile Results

### 3a. PASS

189 procedures compiled successfully:

- `Contact_CheckInsertGroupDefault`
- `Contact_GetGroupDefaultByUserNo`
- `Contact_InsertShareGroup`
- `Contacts_ChangeGroup`
- `Contacts_ChangePublicGroup`
- `Contacts_ChangeShareGroup`
- `Contacts_CheckExitGroupAndContact`
- `Contacts_CheckGroup`
- `Contacts_CheckNumber`
- `contacts_countgroupcountchild`
- `Contacts_CountGroupUser`
- `Contacts_CountUserPublicWithoutGroup`
- `Contacts_CountUserShareWithoutGroup`
- `Contacts_DelAllContactsTrash`
- `Contacts_DelContactsGroup`
- `Contacts_DelContactsShare`
- `Contacts_DelContactsUser`
- `Contacts_DeleteAddressAll`
- `Contacts_DeleteAllGroupByUserSeq`
- `Contacts_DeleteBackupInfo`
- `Contacts_DeleteContact`
- `Contacts_DeleteDepartAllowAccess`
- `Contacts_DeleteHistory`
- `Contacts_DeletePublicGroup`
- `Contacts_DeleteShareGroup`
- `Contacts_DownPublicGroup`
- `Contacts_DownShareGroup`
- `Contacts_FinAll`
- `Contacts_FindNoNameUser`
- `Contacts_FindUser`
- `Contacts_GetAddressInfo`
- `Contacts_GetAddressNotUpdateCount`
- `Contacts_GetAllAddress`
- `Contacts_GetAllCompany`
- `Contacts_GetAllContactsList`
- `Contacts_GetAllDays`
- `Contacts_GetAllEmail`
- `Contacts_GetAllGroup`
- `Contacts_GetAllGroups`
- `Contacts_GetAllGroupsRestore`
- `Contacts_GetAllGroupUser`
- `Contacts_GetAllHomepage`
- `Contacts_GetAllListGroupContact`
- `Contacts_GetAllNumber`
- `Contacts_GetAllSns`
- `Contacts_GetAllUser`
- `Contacts_GetAllUser_Distinct`
- `Contacts_GetAllUserNotRequite`
- `Contacts_GetBackupInfo`
- `Contacts_GetBackupInfoOnce`
- `Contacts_GetCheckGroup`
- `Contacts_GetContactGroup`
- `Contacts_GetContactsCount`
- `Contacts_GetContactsForOutlook`
- `Contacts_GetContactsGroup`
- `Contacts_GetContactsList`
- `Contacts_GetContactsTrashList`
- `Contacts_GetCountChildUser`
- `Contacts_GetDefaultBoxCount`
- `Contacts_GetDefaultCategory`
- `Contacts_GetDepartAllowAccess`
- `Contacts_GetDepartmentBoxCount`
- `Contacts_GetDupeList`
- `Contacts_GetGroupBySeq`
- `Contacts_GetGroupByUser`
- `Contacts_GetGroupInfo`
- `Contacts_GetGroupList`
- `Contacts_GetHistoryList`
- `Contacts_GetHistoryListCount`
- `Contacts_GetLatitudeAndLongitudeContacts`
- `Contacts_GetLatitudeAndLongitudeOneContacts`
- `Contacts_GetLikeList`
- `Contacts_GetListGroup`
- `Contacts_GetListGroupWithId`
- `Contacts_GetLocationOneContact`
- `Contacts_GetLocations`
- `Contacts_GetNameGroup`
- `Contacts_GetOneAddress`
- `Contacts_GetOneRowChildGroup`
- `Contacts_GetOutFile`
- `Contacts_GetOutFileExcel`
- `Contacts_GetOutList`
- `Contacts_GetOutListCount`
- `Contacts_GetOutListExcel`
- `Contacts_GetPrivateBoxCount`
- `Contacts_GetPublicBoxCount`
- `Contacts_GetPublicGroup`
- `Contacts_GetRankList`
- `Contacts_GetRankListCount`
- `Contacts_GetSetup`
- `Contacts_GetShareDepartmentDefault`
- `Contacts_GetShareGroup`
- `Contacts_GetShareGroupByUser`
- `Contacts_GetShareGroupSetting`
- `Contacts_GetSharers`
- `Contacts_GetTopCategory`
- `Contacts_GetTrashCount`
- `Contacts_GetTrashUserList`
- `Contacts_GetUser`
- `Contacts_GetUser_Address`
- `Contacts_GetUser_Company`
- `Contacts_GetUser_Days`
- `Contacts_GetUser_Department`
- `Contacts_GetUser_Email`
- `Contacts_GetUser_GroupInfo`
- `Contacts_GetUser_Homepage`
- `Contacts_GetUser_Noname`
- `Contacts_GetUser_Number`
- `Contacts_GetUser_PhoneInfo`
- `Contacts_GetUser_Share`
- `Contacts_GetUser_SNS`
- `Contacts_GetUser_ToGroup`
- `Contacts_GetUser_ToGroupMobile`
- `Contacts_GetUser_ToUserNo`
- `Contacts_GetUser_UnGroup`
- `Contacts_GetUserByPublicGroup`
- `Contacts_GetUserByShareGroup`
- `Contacts_GetUserData`
- `Contacts_GetUserDataHistory`
- `Contacts_GetUserDetail`
- `Contacts_GetUserGroup`
- `Contacts_GetUserGroupByLanguage`
- `Contacts_GetUserGroupByUserNo`
- `Contacts_GetUserGroupMobi`
- `Contacts_GetUserNumber`
- `Contacts_InsertBackupInfo`
- `Contacts_InsertContactForOutlookEntryID`
- `Contacts_InsertContactForOutlookFolderEntryID`
- `Contacts_InsertGroup`
- `Contacts_InsertListGroup`
- `Contacts_InsertListGroupContact`
- `Contacts_InsertPublicGroup`
- `Contacts_InsertShareGroup`
- `Contacts_InsertUser`
- `Contacts_InsertUserForExcel`
- `Contacts_ListGroupContent`
- `Contacts_MoveAllContact`
- `Contacts_MoveContactGroup`
- `Contacts_MoveUser`
- `Contacts_ParentGroupNo`
- `Contacts_RestoreContactList`
- `Contacts_SaveAddressInfo`
- `Contacts_SaveAddressInfo_Web`
- `Contacts_SaveArrange`
- `Contacts_SaveArrangeLike`
- `Contacts_SaveContactsForOutlook`
- `Contacts_SaveContactsHistory`
- `Contacts_SaveGroupForOutlook`
- `Contacts_SaveLocation`
- `Contacts_SaveRestore`
- `Contacts_SaveSetup`
- `Contacts_Search_NoDistance`
- `Contacts_SearchMobi`
- `Contacts_SeqToName`
- `Contacts_SetAddress`
- `Contacts_SetCallPhone`
- `Contacts_SetCompany`
- `Contacts_SetContactsGroup`
- `Contacts_SetContactsRestore`
- `Contacts_SetContactsTrash`
- `Contacts_SetContactsUser`
- `Contacts_SetDays`
- `Contacts_SetEmail`
- `Contacts_SetMoveContacts`
- `Contacts_SetNumber`
- `Contacts_SetShare`
- `Contacts_SetSns`
- `Contacts_SetUserCheckDate`
- `Contacts_UpdateAndroidDevice_NotificationOptions`
- `Contacts_UpdateContactGroupUser`
- `Contacts_UpdateContactImportant`
- `Contacts_UpDateContactsUser`
- `Contacts_UpdateDepartAllowAccess`
- `Contacts_UpdateGroup`
- `Contacts_UpdateGroupMemo`
- `Contacts_UpdateGroupParent`
- `Contacts_UpdateGroupState`
- `Contacts_UpdateListGroup`
- `Contacts_UpdateListGroupContact`
- `Contacts_UpdatePublicGroup`
- `Contacts_UpdatePublicGroupUser`
- `Contacts_UpdateShareGroup`
- `Contacts_UpdateShareGroupUser`
- `Contacts_UpdateSortDownOfGroup`
- `Contacts_UpdateSortUpOfGroup`
- `Contacts_UpdateUserInfo`
- `Contacts_UpdateUserState`
- `Contacts_UpPublicGroup`
- `Contacts_UpShareGroup`

### 3b. FAIL

All procedures compiled successfully.

## 5. SETOF record â€” Needs Manual RETURNS TABLE(...)

141 procedures have `RETURNS SETOF record` and need explicit column types:

- `Contact_CheckInsertGroupDefault`
- `Contact_GetGroupDefaultByUserNo`
- `Contact_InsertShareGroup`
- `Contacts_ChangeGroup`
- `Contacts_ChangePublicGroup`
- `Contacts_CheckExitGroupAndContact`
- `Contacts_CheckGroup`
- `Contacts_CheckNumber`
- `contacts_countgroupcountchild`
- `Contacts_CountGroupUser`
- `Contacts_CountUserPublicWithoutGroup`
- `Contacts_CountUserShareWithoutGroup`
- `Contacts_DeleteAllGroupByUserSeq`
- `Contacts_DeletePublicGroup`
- `Contacts_DeleteShareGroup`
- `Contacts_FinAll`
- `Contacts_FindNoNameUser`
- `Contacts_FindUser`
- `Contacts_GetAddressInfo`
- `Contacts_GetAddressNotUpdateCount`
- `Contacts_GetAllAddress`
- `Contacts_GetAllCompany`
- `Contacts_GetAllContactsList`
- `Contacts_GetAllDays`
- `Contacts_GetAllEmail`
- `Contacts_GetAllGroup`
- `Contacts_GetAllGroups`
- `Contacts_GetAllGroupsRestore`
- `Contacts_GetAllGroupUser`
- `Contacts_GetAllHomepage`
- `Contacts_GetAllListGroupContact`
- `Contacts_GetAllNumber`
- `Contacts_GetAllSns`
- `Contacts_GetAllUser`
- `Contacts_GetAllUser_Distinct`
- `Contacts_GetAllUserNotRequite`
- `Contacts_GetBackupInfo`
- `Contacts_GetBackupInfoOnce`
- `Contacts_GetCheckGroup`
- `Contacts_GetContactGroup`
- `Contacts_GetContactsCount`
- `Contacts_GetContactsForOutlook`
- `Contacts_GetContactsGroup`
- `Contacts_GetContactsList`
- `Contacts_GetContactsTrashList`
- `Contacts_GetCountChildUser`
- `Contacts_GetDefaultBoxCount`
- `Contacts_GetDefaultCategory`
- `Contacts_GetDepartAllowAccess`
- `Contacts_GetDepartmentBoxCount`
- `Contacts_GetDupeList`
- `Contacts_GetGroupBySeq`
- `Contacts_GetGroupByUser`
- `Contacts_GetGroupInfo`
- `Contacts_GetGroupList`
- `Contacts_GetHistoryList`
- `Contacts_GetHistoryListCount`
- `Contacts_GetLatitudeAndLongitudeContacts`
- `Contacts_GetLatitudeAndLongitudeOneContacts`
- `Contacts_GetLikeList`
- `Contacts_GetListGroup`
- `Contacts_GetListGroupWithId`
- `Contacts_GetLocationOneContact`
- `Contacts_GetLocations`
- `Contacts_GetNameGroup`
- `Contacts_GetOneAddress`
- `Contacts_GetOneRowChildGroup`
- `Contacts_GetOutFile`
- `Contacts_GetOutFileExcel`
- `Contacts_GetOutList`
- `Contacts_GetOutListCount`
- `Contacts_GetOutListExcel`
- `Contacts_GetPrivateBoxCount`
- `Contacts_GetPublicBoxCount`
- `Contacts_GetPublicGroup`
- `Contacts_GetRankList`
- `Contacts_GetRankListCount`
- `Contacts_GetSetup`
- `Contacts_GetShareDepartmentDefault`
- `Contacts_GetShareGroup`
- `Contacts_GetShareGroupByUser`
- `Contacts_GetShareGroupSetting`
- `Contacts_GetSharers`
- `Contacts_GetTopCategory`
- `Contacts_GetTrashCount`
- `Contacts_GetTrashUserList`
- `Contacts_GetUser`
- `Contacts_GetUser_Address`
- `Contacts_GetUser_Company`
- `Contacts_GetUser_Days`
- `Contacts_GetUser_Department`
- `Contacts_GetUser_Email`
- `Contacts_GetUser_GroupInfo`
- `Contacts_GetUser_Homepage`
- `Contacts_GetUser_Noname`
- `Contacts_GetUser_Number`
- `Contacts_GetUser_PhoneInfo`
- `Contacts_GetUser_Share`
- `Contacts_GetUser_SNS`
- `Contacts_GetUser_ToGroup`
- `Contacts_GetUser_ToGroupMobile`
- `Contacts_GetUser_ToUserNo`
- `Contacts_GetUser_UnGroup`
- `Contacts_GetUserByPublicGroup`
- `Contacts_GetUserByShareGroup`
- `Contacts_GetUserData`
- `Contacts_GetUserDataHistory`
- `Contacts_GetUserDetail`
- `Contacts_GetUserGroup`
- `Contacts_GetUserGroupByLanguage`
- `Contacts_GetUserGroupByUserNo`
- `Contacts_GetUserGroupMobi`
- `Contacts_GetUserNumber`
- `Contacts_InsertBackupInfo`
- `Contacts_InsertContactForOutlookEntryID`
- `Contacts_InsertContactForOutlookFolderEntryID`
- `Contacts_InsertGroup`
- `Contacts_InsertListGroup`
- `Contacts_InsertPublicGroup`
- `Contacts_InsertShareGroup`
- `Contacts_InsertUserForExcel`
- `Contacts_ListGroupContent`
- `Contacts_ParentGroupNo`
- `Contacts_SaveAddressInfo`
- `Contacts_SaveAddressInfo_Web`
- `Contacts_SaveArrange`
- `Contacts_SaveArrangeLike`
- `Contacts_SaveContactsForOutlook`
- `Contacts_SaveContactsHistory`
- `Contacts_SaveGroupForOutlook`
- `Contacts_SaveRestore`
- `Contacts_SaveSetup`
- `Contacts_Search_NoDistance`
- `Contacts_SearchMobi`
- `Contacts_SeqToName`
- `Contacts_SetContactsGroup`
- `Contacts_SetContactsUser`
- `Contacts_SetShare`
- `Contacts_UpdatePublicGroup`
- `Contacts_UpdateShareGroup`
- `Contacts_UpdateUserInfo`

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
| 1 | SETOF record â†’ needs RETURNS TABLE | 141 procedures | Infer column types from SELECT list per procedure |

