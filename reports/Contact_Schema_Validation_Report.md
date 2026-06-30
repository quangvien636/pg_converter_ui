# Contact_% Schema DDL Validation Report

This report contains the test results of deploying Contact-related table DDLs, constraint DDLs, and index DDLs to the PostgreSQL test database.

## 1. Tables Deployment Summary

| Table Name | Status | Error Details |
|------------|--------|---------------|
| `ContactsAddress` | **PASS** |  |
| `ContactsAddressHistory` | **PASS** |  |
| `ContactsBackup` | **PASS** |  |
| `ContactsCompany` | **PASS** |  |
| `ContactsCompanyHistory` | **PASS** |  |
| `ContactsDays` | **PASS** |  |
| `ContactsDaysHistory` | **PASS** |  |
| `ContactsEmail` | **PASS** |  |
| `ContactsEmailHistory` | **PASS** |  |
| `ContactsGroup` | **PASS** |  |
| `ContactsGroupOutlook` | **PASS** |  |
| `ContactsGroupUser` | **PASS** |  |
| `ContactsGroupUserHistory` | **PASS** |  |
| `ContactsHomepage` | **PASS** |  |
| `ContactsHomepageHistory` | **PASS** |  |
| `ContactsNumber` | **PASS** |  |
| `ContactsNumberHistory` | **PASS** |  |
| `ContactsSetup` | **PASS** |  |
| `ContactsSharers` | **PASS** |  |
| `ContactsSns` | **PASS** |  |
| `ContactsSnsHistory` | **PASS** |  |
| `ContactsUser` | **PASS** |  |
| `ContactsUserHistory` | **PASS** |  |
| `ContactsUserOutlook` | **PASS** |  |
| `Contacts_ListGroup` | **PASS** |  |
| `Contacts_ListGroupContact` | **PASS** |  |
| `Contacts_Locations` | **PASS** |  |
| `Contact_DepartAllowAccess` | **PASS** |  |
| `Contact_PublicGroup` | **PASS** |  |
| `Contact_PublicGroupUser` | **PASS** |  |
| `Contact_ShareGroup` | **PASS** |  |
| `Contact_ShareGroupUser` | **PASS** |  |
| `ScheduleContentsContacts` | **PASS** |  |

## 2. Constraints Deployment Summary

| Constraint Name | Status | Error Details |
|-----------------|--------|---------------|
| `DF__Contact_P__IsDel__6DE881AB` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_P__ModDa__6CF45D72` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_P__RegDa__6C003939` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Contact_PublicGroup` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_P__IsDel__71B9128F` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_P__ModDa__70C4EE56` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_P__RegDa__6FD0CA1D` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__IsDel__6A17F0C7` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__ModDa__6923CC8E` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__RegDa__682FA855` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Contact_ShareGroup` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__IsDel__7589A373` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__ModDa__74957F3A` | **STUB (Not converted)** | Stub file / Not converted |
| `DF__Contact_S__RegDa__73A15B01` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Contacts_ListGroup` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_Contacts_ListGroupContact` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsAddress_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsAddress_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsAddress` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsAddressHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsBackup_ContactCnt` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsBackup_GroupCnt` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsBackup_Memo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsBackup_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsBackup_Type` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsBackup` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsCompany_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsCompany_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsCompany` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsCompanyHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsDays_ModeDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsDays_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsDays` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactDayHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsEmail_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsEmail_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsEmail` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsEmailHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroup_IsDefault` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroup_Memo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroup_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroup_Sort` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroup_UseYn` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsGroup` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroupOutlook_OutlookFolderEntryID` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsGroupOutlook` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroupUser_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsGroupUser_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsGroupUser` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsGroupUserHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsHomepage_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsHomepage_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsHomepage` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsHomepageHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsNumber_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsNumber_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsNumber` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsNumberHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_IsFolderExpanded` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_ModUserNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_RegUserNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSetup_StartContactBoxNo` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsSetup` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSns_ModDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsSns_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsSns` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsSnsHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsUser_RegDate` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ContactsUser_ViewCount` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsUser` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsUserHistory` | **STUB (Not converted)** | Stub file / Not converted |
| `PK_ContactsUserOutlook` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ScheduleContentsContacts_GroupNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ScheduleContentsContacts_ScheduleNo` | **STUB (Not converted)** | Stub file / Not converted |
| `DF_ScheduleContentsContacts_UserSeq` | **STUB (Not converted)** | Stub file / Not converted |

## 3. Indexes Deployment Summary

| Index Name | Status | Error Details |
|------------|--------|---------------|
No separate index DDL files found for Contact tables.

