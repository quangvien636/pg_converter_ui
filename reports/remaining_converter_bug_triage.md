# Remaining Converter Bug Triage Report

## 1. Executive Summary

- **Total Items Triaged**: 128
- **Triage Breakdown**:
  - **REAL_CONVERTER_BUG**: 120
  - **DEPENDENCY_ORDER_ISSUE**: 0
  - **INTENTIONALLY_SKIPPED**: 3
  - **PARENT_COLUMN_MISSING**: 0
  - **TYPE_MAPPING_ISSUE**: 0
  - **NAME_NORMALIZATION_ISSUE**: 0
  - **NEED_MANUAL_REVIEW**: 0
  - **PARENT_TABLE_MISSING**: 5


## 2. Top Affected Tables
  - **Note_Comments**: 4 items
  - **HNEWAttached**: 2 items
  - **EAPPCostDetail**: 2 items
  - **EAPPDocument**: 2 items
  - **EAPPErpSubData**: 2 items
  - **sysdiagrams**: 2 items
  - **DMake_Shares**: 1 items
  - **Center_NotificationData**: 1 items
  - **DMake_Replies**: 1 items
  - **Vacation_Requests**: 1 items


## 3. Top Affected Object Kinds
  - **PRIMARY_KEY**: 108 items
  - **FOREIGN_KEY**: 13 items
  - **DEFAULT**: 5 items
  - **UNIQUE_CONSTRAINT**: 2 items


## 4. Classifications Details

### DEPENDENCY_ORDER_ISSUE (0)
None.

### INTENTIONALLY_SKIPPED (3)
- **DEFAULT** on `Note_List` (`DF_Note_List_NoteId`, column: `ListNo`)
- **PRIMARY_KEY** on `sysdiagrams` (`PK__sysdiagr__C2B05B6100551192`)
- **UNIQUE_CONSTRAINT** on `sysdiagrams` (`UK_principal_name`)

### NAME_NORMALIZATION_ISSUE (0)
None.

### NEED_MANUAL_REVIEW (0)
None.

### PARENT_COLUMN_MISSING (0)
None.

### PARENT_TABLE_MISSING (5)
- **DEFAULT** on `Note_Comments` (`DF_Note_Comments_ModTimeZone`, column: `ModTimeZone`)
- **DEFAULT** on `Note_Comments` (`DF_Note_Comments_ParentID`, column: `ParentID`)
- **DEFAULT** on `Note_Comments` (`DF_Note_Comments_RegTimeZone`, column: `RegTimeZone`)
- **PRIMARY_KEY** on `UF_TEXT_SPLIT` (`PK__UF_TEXT___7A7484D75C6D822E`)
- **PRIMARY_KEY** on `Note_Comments` (`PK_Note_Comments`)

### REAL_CONVERTER_BUG (120)
- **DEFAULT** on `SurveyPoll` (`DF_SurveyPoll_SelectNo`, column: `SelectNo`)
- **FOREIGN_KEY** on `EAPPCMONOrgan` (`FK__EAPPCMONO__Depar__034CE78E`)
- **FOREIGN_KEY** on `EAPPCostDetail` (`FK__EAPPCostD__Check__0EA7299C`)
- **FOREIGN_KEY** on `EAPPCostDetail` (`FK__EAPPCostD__Maste__0F9B4DD5`)
- **FOREIGN_KEY** on `EAPPDocHistory` (`FK__EAPPDocHi__eadoc__108F720E`)
- **FOREIGN_KEY** on `EAPPDocumentSubData` (`FK__EAPPDocum__docid__146002F2`)
- **FOREIGN_KEY** on `EAPPErpSubData` (`FK__EAPPErpSu__docid__1554272B`)
- **FOREIGN_KEY** on `EAPPErpSubData` (`FK__EAPPErpSu__docid__16484B64`)
- **FOREIGN_KEY** on `EAPPLinkQuery` (`FK__EAPPLinkQ__conne__173C6F9D`)
- **FOREIGN_KEY** on `HNEWAttached` (`FK__HNEWAttac__DocID__614DA09C`)
- **FOREIGN_KEY** on `EAPPDocument` (`FK_EAPPDocument_EAPPHistory`)
- **FOREIGN_KEY** on `EAPPDocument` (`FK_EAPPDocument_EAPPPath`)
- **FOREIGN_KEY** on `EAPPPathDetail` (`FK_EAPPPathDetail_EAPPPath`)
- **FOREIGN_KEY** on `TimeLine_Share` (`FK_TimeLine_Share_TimeLine_Main`)
- **PRIMARY_KEY** on `EAPPEditorForm` (`PK__EAPPEdit__DDDFBCBE39A8F83F`)
- **PRIMARY_KEY** on `EAPPRefDoc_Temp` (`PK__EAPPRefD__3214EC2753E7ED2F`)
- **PRIMARY_KEY** on `eapptempapprovalreadydoc` (`PK__eapptemp__3213E83F5467DB73`)
- **PRIMARY_KEY** on `HNEWAttached` (`PK__HNEWAtta__CA1E3C885D7D0FB8`)
- **PRIMARY_KEY** on `NoticeSyn_UserByGroup` (`PK__NoticeSy__AE84E167520A91B5`)
- **PRIMARY_KEY** on `NoticeSyn_Menu` (`PK__NoticeSy__B10590CF478D0342`)
- **PRIMARY_KEY** on `NoticeSyn_AuthoGroup` (`PK__NoticeSy__E6B77A6E393EE3EB`)
- **PRIMARY_KEY** on `NSFAAttached` (`PK__NSFAAtta__CA1E3C887CFFDCB2`)
- **PRIMARY_KEY** on `Vacation_Setups` (`PK__Vacation__3214EC072D24BC77`)
- **PRIMARY_KEY** on `Vacation_Requests` (`PK__Vacation__33A8517A52757160`)
- **PRIMARY_KEY** on `Vacation_RequestEps` (`PK__Vacation__33A8517A6E1D8BD5`)
- **PRIMARY_KEY** on `Vacation_Types` (`PK__Vacation__516F03B55A169328`)
- **PRIMARY_KEY** on `VOTEAuthority` (`PK__VOTEAuth__3214EC2715417A97`)
- **PRIMARY_KEY** on `WFAXReceive` (`PK__WFAXReceive`)
- **PRIMARY_KEY** on `WFAXSend` (`PK__WFAXSend`)
- **PRIMARY_KEY** on `WorkingTimeV2_Times` (`PK__WorkingT__2EC9C99153C9884C`)
- **PRIMARY_KEY** on `WorkingTimeV2_HOLIDAYS` (`PK__WorkingT__DF11FDDE65E83887`)
- **PRIMARY_KEY** on `WorkingTimeV3_Vacations` (`PK__WorkingT__E420DFE41CEE54AE`)
- **PRIMARY_KEY** on `Center_NotificationData` (`PK_Center_NotificationData`)
- **PRIMARY_KEY** on `Contact_PublicGroup` (`PK_Contact_PublicGroup`)
- **PRIMARY_KEY** on `Contact_ShareGroup` (`PK_Contact_ShareGroup`)
- **PRIMARY_KEY** on `DMake_ViewedLog` (`PK_Dake_ViewedLog`)
- **PRIMARY_KEY** on `DMake_Boards_Fields` (`PK_DMake_Boards_Fields`)
- **PRIMARY_KEY** on `DMake_Class` (`PK_DMake_Class`)
- **PRIMARY_KEY** on `DMake_Contents` (`PK_DMake_Contents`)
- **PRIMARY_KEY** on `DMake_Controls` (`PK_DMake_Controls`)
- **PRIMARY_KEY** on `DMake_Files` (`PK_DMake_Files`)
- **PRIMARY_KEY** on `DMake_Folders` (`PK_DMake_Folders`)
- **PRIMARY_KEY** on `DMake_RecommendLog` (`PK_DMake_RecommendLog`)
- **PRIMARY_KEY** on `DMake_Replies` (`PK_DMake_Replies`)
- **PRIMARY_KEY** on `DMake_Shares` (`PK_DMake_Shares`)
- **PRIMARY_KEY** on `DMake_Boards` (`PK_DMakeBoard`)
- **PRIMARY_KEY** on `Drive_DownloadingLogsForFile` (`PK_Drive_DownloadingLogsForFile`)
- **PRIMARY_KEY** on `Drive_DownloadingLogsForFolder` (`PK_Drive_DownloadingLogsForFolder`)
- **PRIMARY_KEY** on `Drive_Files` (`PK_Drive_Files`)
- **PRIMARY_KEY** on `Drive_SharingForFolders` (`PK_Drive_SharingForFolders`)
- **PRIMARY_KEY** on `Drive_Trash` (`PK_Drive_Trash`)
- **PRIMARY_KEY** on `EAFSM` (`PK_EAFSM`)
- **PRIMARY_KEY** on `EAPPAddFile` (`PK_EAPPAddFile`)
- **PRIMARY_KEY** on `EAPPCertificate` (`PK_EAPPCertificate`)
- **PRIMARY_KEY** on `EAPPCustomAuth` (`PK_EAPPCustomAuth`)
- **PRIMARY_KEY** on `EAPPDepartAuthDetail` (`PK_EAPPDepartAuthDetail`)
- **PRIMARY_KEY** on `EAPPDesignatedAdmin` (`PK_EAPPDesignatedAdmin`)
- **PRIMARY_KEY** on `EAPPFormDepart` (`PK_EAPPFormDepart`)
- **PRIMARY_KEY** on `EASetPopUp` (`PK_EASetPopUp`)
- **PRIMARY_KEY** on `EDMSAuthFile` (`PK_EDMSAuthFile`)
- **PRIMARY_KEY** on `EDMSAuthFolder` (`PK_EDMSAuthFolder`)
- **PRIMARY_KEY** on `hfconvdata` (`pk_hfconvdata`)
- **PRIMARY_KEY** on `hfreceivedata` (`pk_hfreceivedata`)
- **PRIMARY_KEY** on `hfsenddata` (`pk_hfsenddata`)
- **PRIMARY_KEY** on `hfsmsdata` (`pk_hfsmsdata`)
- **PRIMARY_KEY** on `HNEWComment` (`PK_HNEWComment`)
- **PRIMARY_KEY** on `HNEWMaster` (`PK_HNEWMaster`)
- **PRIMARY_KEY** on `Integrated_Files` (`PK_Integrated_Attachs`)
- **PRIMARY_KEY** on `Integrated_Comments` (`PK_Integrated_Comments`)
- **PRIMARY_KEY** on `Integrated_Reference` (`PK_Integrated_Reference`)
- **PRIMARY_KEY** on `Integrated_Replies` (`PK_Integrated_Replys`)
- **PRIMARY_KEY** on `Integrated_TreeItem` (`PK_Integrated_treeitem`)
- **PRIMARY_KEY** on `Integrateds` (`PK_Integrateds`)
- **PRIMARY_KEY** on `Leave_Types` (`PK_Leave_Types`)
- **PRIMARY_KEY** on `Leave_UserApplies` (`PK_Leave_UserApplies`)
- **PRIMARY_KEY** on `Note_AndroidDevices` (`PK_Note_AndroidDevices`)
- **PRIMARY_KEY** on `Note_IOSDevices` (`PK_Note_IOSDevices`)
- **PRIMARY_KEY** on `Notice_AndroidDevices` (`PK_Notice_AndroidDevices`)
- **PRIMARY_KEY** on `Notice_IOSDevices` (`PK_Notice_IOSDevices`)
- **PRIMARY_KEY** on `NoticeSyn_Divisions` (`PK_Notice_Menu`)
- **PRIMARY_KEY** on `NoticesSyn` (`PK_NoticesSyn`)
- **PRIMARY_KEY** on `NoticeSyn_AndroidDevices` (`PK_NoticeSyn_AndroidDevices`)
- **PRIMARY_KEY** on `NoticeSyn_Attachments` (`PK_NoticeSyn_Attachments`)
- **PRIMARY_KEY** on `NoticeSyn_Comments` (`PK_NoticeSyn_Comments`)
- **PRIMARY_KEY** on `NoticeSyn_ContentImgs` (`PK_NoticeSyn_ContentImgs`)
- **PRIMARY_KEY** on `NoticeSyn_IOSDevices` (`PK_NoticeSyn_IOSDevices`)
- **PRIMARY_KEY** on `NoticeSyn_Reference` (`PK_NoticeSyn_Reference`)
- **PRIMARY_KEY** on `NoticeSyn_References` (`PK_NoticeSyn_References`)
- **PRIMARY_KEY** on `NoticeSyn_Type` (`PK_NoticeSyn_Type`)
- **PRIMARY_KEY** on `NSFABusinessInfo` (`PK_NSFABusinessInfo_1`)
- **PRIMARY_KEY** on `NSFAClaimInfo` (`PK_NSFAClaimInfo`)
- **PRIMARY_KEY** on `NSFACompanyInfo` (`PK_NSFACompanyInfo`)
- **PRIMARY_KEY** on `NSFADetailItem` (`PK_NSFADetailItem`)
- **PRIMARY_KEY** on `NSFARefMail` (`PK_NSFARefMailSeq`)
- **PRIMARY_KEY** on `ProposalCommonClass` (`PK_ProposalCommonClass`)
- **PRIMARY_KEY** on `ProposalCommonCode` (`PK_ProposalCommonCode`)
- **PRIMARY_KEY** on `ScheduleContentUds` (`PK_ScheduleContentUpdateds`)
- **PRIMARY_KEY** on `ScheduleResourceAndroidDevices` (`PK_ScheduleResourceAndroidDevices`)
- **PRIMARY_KEY** on `ScheduleResourceIOSDevices` (`PK_ScheduleResourceIOSDevices`)
- **PRIMARY_KEY** on `SMSErrorMessage` (`PK_SMSErrorMessage`)
- **PRIMARY_KEY** on `SMSFavoritesText` (`PK_SMSFavoritesText`)
- **PRIMARY_KEY** on `SourceControl_Company` (`PK_SourceControl_Company`)
- **PRIMARY_KEY** on `SourceControl_CompanyHistory` (`PK_SourceControl_CompanyHistory`)
- **PRIMARY_KEY** on `SourceControl_DatabaseHistory` (`PK_SourceControl_DatabaseHistory`)
- **PRIMARY_KEY** on `SourceControl_Project` (`PK_SourceControl_Project`)
- **PRIMARY_KEY** on `SourceControl_ProjectHistory` (`PK_SourceControl_ProjectHistory`)
- **PRIMARY_KEY** on `TCMBusinessInfo` (`PK_TCMBusinessInfo`)
- **PRIMARY_KEY** on `TCMBusinessInfoFile` (`PK_TCMBusinessInfoFile`)
- **PRIMARY_KEY** on `TCMCollectMoneyMaster` (`PK_TCMCollectMoneyMaster`)
- **PRIMARY_KEY** on `TCMCommonClass` (`PK_TCMCommonClass`)
- **PRIMARY_KEY** on `TCMCommonCode` (`PK_TCMCommonCode`)
- **PRIMARY_KEY** on `TCMCompanyInfo` (`PK_TCMCompanyInfo`)
- **PRIMARY_KEY** on `TCMCompanyStaff` (`PK_TCMCompanyStaff`)
- **PRIMARY_KEY** on `TCMContractInfo` (`PK_TCMContractInfo`)
- **PRIMARY_KEY** on `TCMHoliday` (`PK_TCMHoliday`)
- **PRIMARY_KEY** on `VOTEMaster` (`PK_VOTEMaster`)
- **PRIMARY_KEY** on `VOTESettings` (`PK_VOTESettings`)
- **PRIMARY_KEY** on `WFAXCountryList` (`PK_WFAXCountryList`)
- **PRIMARY_KEY** on `WFAXUserGroupOrgSet` (`PK_WFAXUserGroupOrgSet`)
- **UNIQUE_CONSTRAINT** on `NoticeReference` (`PK_NoticeReference`)

### TYPE_MAPPING_ISSUE (0)
None.



## 5. Conclusion & Recommendations
**NEED VERIFICATION**. Most of the remaining primary/foreign keys and constraints are missing in the current target database due to the historic bugs in the converter (which did not emit primary key constraints for identity/serial columns, and omitted defaults for NEWID()). 
Now that the converter rules have been corrected, a full **rebuild** of the pg_converter_runtime_test database is recommended to verify that these constraints compile and deploy correctly in the next phase.
