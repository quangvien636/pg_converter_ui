# Runtime dependency report

Objects are not silently created from error text. Each dependency is traced to converted source DDL or explicitly classified as external.
Temporary objects below existed only inside the smoke transaction and were removed by the final ROLLBACK.

## Temporary source DDL deployment

| Artifact | Status | Evidence |
|---|---|---|
| `00006_dbo_Table_BoardOptions.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00007_dbo_Table_Board_AllowAccess.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00008_dbo_Table_Board_AndroidDevices.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00009_dbo_Table_Board_AuthoGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00010_dbo_Table_Board_Boards.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00011_dbo_Table_Board_CommentSetting.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00012_dbo_Table_Board_Config.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00013_dbo_Table_Board_Contents.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00014_dbo_Table_Board_ContentSetting.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00015_dbo_Table_Board_DepartAllowAccess.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00016_dbo_Table_Board_Files.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00017_dbo_Table_Board_Folders.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00018_dbo_Table_Board_Heads.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00019_dbo_Table_Board_HistoryFolder.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00020_dbo_Table_Board_IOSDevices.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00021_dbo_Table_Board_Managers.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00022_dbo_Table_Board_Menu.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00023_dbo_Table_Board_MultiBoardWidget.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00024_dbo_Table_Board_NewBoardWidget.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00025_dbo_Table_Board_NoticePermission.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00026_dbo_Table_Board_RecommendedLogs.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00027_dbo_Table_Board_Replies.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00028_dbo_Table_Board_ReplyFiles.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00029_dbo_Table_Board_Sharers.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00030_dbo_Table_Board_UserByGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00031_dbo_Table_Board_UserSetting.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00032_dbo_Table_Board_ViewedLogs.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00102_dbo_Table_ContactsAddress.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00103_dbo_Table_ContactsAddressHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00104_dbo_Table_ContactsBackup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00105_dbo_Table_ContactsCompany.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00106_dbo_Table_ContactsCompanyHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00107_dbo_Table_ContactsDays.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00108_dbo_Table_ContactsDaysHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00109_dbo_Table_ContactsEmail.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00110_dbo_Table_ContactsEmailHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00111_dbo_Table_ContactsGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00112_dbo_Table_ContactsGroupOutlook.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00113_dbo_Table_ContactsGroupUser.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00114_dbo_Table_ContactsGroupUserHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00115_dbo_Table_ContactsHomepage.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00116_dbo_Table_ContactsHomepageHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00117_dbo_Table_ContactsNumber.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00118_dbo_Table_ContactsNumberHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00119_dbo_Table_ContactsSetup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00120_dbo_Table_ContactsSharers.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00121_dbo_Table_ContactsSns.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00122_dbo_Table_ContactsSnsHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00123_dbo_Table_ContactsUser.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00124_dbo_Table_ContactsUserHistory.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00125_dbo_Table_ContactsUserOutlook.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00126_dbo_Table_Contacts_ListGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00127_dbo_Table_Contacts_ListGroupContact.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00128_dbo_Table_Contacts_Locations.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00129_dbo_Table_Contact_DepartAllowAccess.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00130_dbo_Table_Contact_PublicGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00131_dbo_Table_Contact_PublicGroupUser.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00132_dbo_Table_Contact_ShareGroup.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00133_dbo_Table_Contact_ShareGroupUser.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00168_dbo_Table_DMake_Boards.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00169_dbo_Table_DMake_Boards_Fields.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00368_dbo_Table_Main_DashBoards.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00452_dbo_Table_PhotoBoard.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00453_dbo_Table_PhotoBoardCmt.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00454_dbo_Table_PhotoBoardFile.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00455_dbo_Table_PhotoBoardLog.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `00480_dbo_Table_ScheduleContentsContacts.sql` | TEMPORARY | Created inside outer transaction; final ROLLBACK removes it. |
| `contacts_deletehistory` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_savearrange` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_savearrangelike` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_saverestore` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_setaddress` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_setemail` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `contacts_setnumber` | TEMPORARY RUNTIME FIX | LEN() replaced by LENGTH() from confirmed SQLSTATE 42883; CREATE OR REPLACE is rolled back. |
| `board_board_maxsortno_select` | INFERRED RECORD SHAPE | column_1 integer |
| `board_countboardinfolder` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_countcontentinboard` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_countfolderinfolder` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_folder_maxsortno_select` | INFERRED RECORD SHAPE | column_1 integer |
| `board_getallowbyitem` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 integer, column_6 integer, column_7 integer, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `board_getallowbyitemtype` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 integer, column_6 integer, column_7 integer, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `board_getallowbyuser` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 integer, column_6 integer, column_7 integer, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `board_getapprovaldoc` | INFERRED RECORD SHAPE | column_1 bigint, column_2 character varying(200), column_3 character varying(200), column_4 character varying(1000), column_5 character varying(1000), column_6 character varying(1000), column_7 character varying(1000), column_8 character varying(260), column_9 text |
| `board_getapprovalfiles` | INFERRED RECORD SHAPE | column_1 character varying(260), column_2 text |
| `board_getboard` | INFERRED RECORD SHAPE | column_1 integer, column_2 timestamp without time zone, column_3 character varying(4000), column_4 character varying(1000), column_5 integer, column_6 integer, column_7 integer, column_8 boolean, column_9 boolean, column_10 boolean, column_11 boolean, column_12 integer, column_13 integer, column_14 boolean, column_15 integer |
| `board_getcommentsetting` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_getconfig` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(50), column_3 character varying(500), column_4 integer, column_5 timestamp without time zone |
| `board_getcontentsetting` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer |
| `board_getfile` | INFERRED RECORD SHAPE | column_1 bigint, column_2 character varying(260), column_3 integer, column_4 text |
| `board_getfiles` | INFERRED RECORD SHAPE | column_1 bigint, column_2 character varying(260), column_3 integer, column_4 text, column_5 integer |
| `board_getfolderbyfolderno` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 timestamp without time zone, column_4 character varying(4000), column_5 integer, column_6 integer, column_7 boolean, column_8 character varying(500), column_9 integer |
| `board_getheads` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 timestamp without time zone, column_5 character varying(100), column_6 integer, column_7 boolean |
| `board_getlistconverturlfile` | INFERRED RECORD SHAPE | column_1 bigint, column_2 bigint, column_3 character varying(260), column_4 integer, column_5 text, column_6 integer |
| `board_getmaxsortoftree` | INFERRED RECORD SHAPE | column_1 integer |
| `board_getrecommendcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_getrecommendedlogbyuserno` | INFERRED RECORD SHAPE | column_1 bigint, column_2 integer, column_3 bigint, column_4 integer, column_5 character varying(100), column_6 integer, column_7 character varying(100), column_8 integer, column_9 character varying(100), column_10 timestamp without time zone |
| `board_getrecommendedlogs` | INFERRED RECORD SHAPE | column_1 bigint, column_2 integer, column_3 bigint, column_4 integer, column_5 character varying(100), column_6 integer, column_7 character varying(100), column_8 integer, column_9 character varying(100), column_10 timestamp without time zone |
| `board_getrecommendlogcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_getreply` | INFERRED RECORD SHAPE | column_1 bigint, column_2 bigint, column_3 integer, column_4 character varying(100), column_5 integer, column_6 character varying(100), column_7 integer, column_8 character varying(100), column_9 timestamp without time zone, column_10 timestamp without time zone, column_11 bigint, column_12 integer, column_13 integer, column_14 text |
| `board_getreplyfilebycontentno` | INFERRED RECORD SHAPE | column_1 bigint, column_2 bigint, column_3 character varying(260), column_4 integer, column_5 text |
| `board_getreplyfilebyreplyfileno` | INFERRED RECORD SHAPE | column_1 bigint, column_2 bigint, column_3 character varying(260), column_4 integer, column_5 text |
| `board_getreplyfilebyreplyno` | INFERRED RECORD SHAPE | column_1 bigint, column_2 character varying(260), column_3 integer, column_4 text |
| `board_getstatusapprovalpermission` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_getusersetting` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer |
| `board_insertdepartallowaccess` | INFERRED RECORD SHAPE | column_1 bigint |
| `board_insertusersetting` | INFERRED RECORD SHAPE | column_1 integer |
| `board_setshare` | INFERRED RECORD SHAPE | column_1 integer |
| `contacts_checkexitgroupandcontact` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_checknumber` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_countgroupcountchild` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_countgroupuser` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_countuserpublicwithoutgroup` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_getalladdress` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(5), column_7 character varying(5), column_8 character varying(500), column_9 character, column_10 timestamp without time zone, column_11 timestamp without time zone, column_12 double precision, column_13 double precision |
| `contacts_getallcompany` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 character varying(50), column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getalldays` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 character, column_9 timestamp without time zone, column_10 timestamp without time zone |
| `contacts_getallemail` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 character varying(50), column_5 character, column_6 timestamp without time zone, column_7 timestamp without time zone |
| `contacts_getallgroups` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 bigint, column_10 character |
| `contacts_getallgroupsrestore` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 bigint, column_10 character |
| `contacts_getallgroupuser` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 timestamp without time zone, column_6 timestamp without time zone |
| `contacts_getallhomepage` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(500), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getalllistgroupcontact` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer |
| `contacts_getallnumber` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone, column_10 integer |
| `contacts_getallsns` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(500), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getalluser` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(100), column_3 character varying(100), column_4 integer, column_5 character varying(500), column_6 timestamp without time zone, column_7 character varying(500), column_8 timestamp without time zone, column_9 timestamp without time zone, column_10 character varying(50), column_11 character varying(1), column_12 timestamp without time zone, column_13 integer, column_14 character varying(20), column_15 integer, column_16 character varying(250) |
| `contacts_getallusernotrequite` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(100), column_3 character varying(100), column_4 integer, column_5 character varying(500), column_6 timestamp without time zone, column_7 character varying(500), column_8 timestamp without time zone, column_9 timestamp without time zone, column_10 character varying(50), column_11 character varying(1), column_12 timestamp without time zone, column_13 integer, column_14 character varying(20), column_15 integer, column_16 character varying(250) |
| `contacts_getbackupinfo` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 character varying(500), column_6 timestamp without time zone, column_7 character varying(1000), column_8 integer |
| `contacts_getbackupinfoonce` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 integer, column_5 character varying(500), column_6 timestamp without time zone, column_7 character varying(1000), column_8 integer |
| `contacts_getcheckgroup` | INFERRED RECORD SHAPE | column_1 character |
| `contacts_getcontactsforoutlook` | INFERRED RECORD SHAPE | column_1 character varying, column_2 character varying, column_3 integer, column_4 text, column_5 integer, column_6 character varying(100), column_7 character varying(100), column_8 integer, column_9 character varying, column_10 character varying, column_11 character varying, column_12 character varying, column_13 character varying, column_14 character varying, column_15 character varying, column_16 character varying, column_17 character varying, column_18 character varying, column_19 text, column_20 character varying, column_21 character varying, column_22 character varying, column_23 text, column_24 character varying, column_25 character varying, column_26 text, column_27 character varying, column_28 character varying(500) |
| `contacts_getcontactsgroup` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 character |
| `contacts_getdefaultcategory` | INFERRED RECORD SHAPE | column_1 integer |
| `contacts_getdupelist` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(100), column_3 character varying(100), column_4 integer, column_5 character varying(50), column_6 integer, column_7 character varying(50), column_8 bigint, column_9 bigint |
| `contacts_getgroupbyuser` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 bigint, column_10 character |
| `contacts_getgroupinfo` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 bigint |
| `contacts_getgrouplist` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 character varying(500), column_4 integer, column_5 integer, column_6 character |
| `contacts_getlatitudeandlongitudecontacts` | INFERRED RECORD SHAPE | column_1 integer, column_2 double precision, column_3 double precision, column_4 character varying(100), column_5 character varying(100), column_6 character varying(500) |
| `contacts_getlatitudeandlongitudeonecontacts` | INFERRED RECORD SHAPE | column_1 integer, column_2 double precision, column_3 double precision, column_4 character varying(100), column_5 character varying(100), column_6 character varying(500) |
| `contacts_getlikelist` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(100), column_3 character varying(100), column_4 integer, column_5 character varying(50), column_6 integer, column_7 character varying(50), column_8 bigint, column_9 bigint |
| `contacts_getlistgroup` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer |
| `contacts_getlistgroupwithid` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(250), column_3 timestamp without time zone, column_4 timestamp without time zone |
| `contacts_getlocationonecontact` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 character varying(100), column_4 double precision, column_5 double precision, column_6 character varying(500), column_7 integer |
| `contacts_getlocations` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 timestamp without time zone, column_4 integer, column_5 timestamp without time zone, column_6 character varying(100), column_7 double precision, column_8 double precision, column_9 integer, column_10 character varying(500) |
| `contacts_getnamegroup` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 text |
| `contacts_getoneaddress` | INFERRED RECORD SHAPE | column_1 character varying(500) |
| `contacts_getprivateboxcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_getpublicboxcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_getranklist` | INFERRED RECORD SHAPE | column_1 bigint, column_2 integer, column_3 character varying(100), column_4 character varying(100), column_5 character varying(500), column_6 integer |
| `contacts_getranklistcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_getsetup` | INFERRED RECORD SHAPE | column_1 integer, column_2 timestamp without time zone, column_3 integer, column_4 timestamp without time zone, column_5 integer, column_6 integer, column_7 bigint, column_8 boolean |
| `contacts_getsharers` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 character varying(100), column_4 character |
| `contacts_gettopcategory` | INFERRED RECORD SHAPE | column_1 bigint, column_2 integer, column_3 text |
| `contacts_gettrashcount` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_getuser_address` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(5), column_7 character varying(5), column_8 character varying(500), column_9 character, column_10 timestamp without time zone, column_11 timestamp without time zone |
| `contacts_getuser_company` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 character varying(50), column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getuser_days` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 character, column_9 timestamp without time zone, column_10 timestamp without time zone |
| `contacts_getuser_email` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 character varying(50), column_5 character, column_6 timestamp without time zone, column_7 timestamp without time zone |
| `contacts_getuser_groupinfo` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 character |
| `contacts_getuser_homepage` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(500), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getuser_number` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(50), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getuser_sns` | INFERRED RECORD SHAPE | column_1 integer, column_2 integer, column_3 integer, column_4 smallint, column_5 character varying(50), column_6 character varying(500), column_7 character, column_8 timestamp without time zone, column_9 timestamp without time zone |
| `contacts_getuser_touserno` | INFERRED RECORD SHAPE | column_1 integer, column_2 character varying(100), column_3 character varying(100), column_4 integer, column_5 character varying(500), column_6 timestamp without time zone, column_7 character varying(500), column_8 timestamp without time zone, column_9 timestamp without time zone, column_10 character varying(50), column_11 character varying(1), column_12 timestamp without time zone, column_13 integer, column_14 character varying(20) |
| `contacts_getusergroupbyuserno` | INFERRED RECORD SHAPE | column_1 integer, column_2 text, column_3 integer, column_4 timestamp without time zone, column_5 character varying(500), column_6 integer, column_7 integer, column_8 character, column_9 bigint, column_10 character |
| `contacts_insertbackupinfo` | INFERRED RECORD SHAPE | column_1 bigint |
| `contacts_insertpublicgroup` | INFERRED RECORD SHAPE | column_1 integer |
| `contacts_insertsharegroup` | INFERRED RECORD SHAPE | column_1 integer |
| `contacts_listgroupcontent` | INFERRED RECORD SHAPE | column_1 character varying(250) |
| `contacts_parentgroupno` | INFERRED RECORD SHAPE | column_1 integer |
| `contacts_seqtoname` | INFERRED RECORD SHAPE | column_1 text |
| `contacts_setshare` | INFERRED RECORD SHAPE | column_1 integer |

## Unresolved runtime dependencies

| Procedure | SQLSTATE | Dependency evidence | Classification | Next action |
|---|---|---|---|---|
| `board_authority_select` | `42P01` | relation "organization_departments" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_checkallowbyitem` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_checkpermission` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_checkpermissionbycontentno` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_deletecurrentmanager` | `42883` | function public.fn_split_array(character varying, character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_deletedepartallowaccess` | `42883` | function splitstring(character varying, unknown) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_deletenotificationservice` | `42P01` | relation "center_notificationservice" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_getallboardcontents` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getallboardcontentsbyboardlist` | `42883` | function nvarchar(integer) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_getallboardwidget` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getandroiddeviceofallusers` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getandroiddeviceofusersbydepartment` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboardbyuserno` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboardcommunitywidget` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboardcontent` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboardcontentinfo` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboardcontents` | `42883` | function nvarchar(integer) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_getboardcontents_bk20181227` | `42883` | function nvarchar(integer) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_getboards` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboards_bk` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getboards_improved` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getcompanylist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getcurrentmanagerlist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getdepartallowaccess` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getdepartandpositionname` | `42P01` | relation "organization_departments" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_getfolderbyuserno` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getfolders` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getiosdeviceofallusers` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getiosdeviceofusersbydepartment` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontent` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontent_bk` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontent_search` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontentbyfolder` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontentsearch` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistboardcontenttoexcel` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistcommentsetting` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getlistnoticepermission` | `42P01` | relation "organization_users" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_getlistuserpermission` | `42P01` | relation "organization_users" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_getlistuserpermissiontoexcel` | `42P01` | relation "organization_users" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_getmultiwidget` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getnewboardcontent` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getnewboardwidget` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getopenfolder` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getprenextcontent` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getreplies` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getreplybycontent` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getsettingcommunitywidget` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getsharers` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getsubmenus` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getteamlist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getteamname` | `42883` | function year(timestamp without time zone) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_gettreeboard` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_gettreesubmenu` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_gettreesubmenu_v2` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_gettreesubmenu_v2_json` | `42P01` | relation "organization_belongtodepartment" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_gettreesubmenutest` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getviewedlogs` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_getwidgetcarousel` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_insertfile` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_insertnotificationservice` | `42P01` | relation "center_notificationservice" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_insertreplyfile` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_setshare` | `42883` | operator does not exist: character varying = integer | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `board_treeboard` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_updateboard` | `42P01` | missing FROM-clause entry for table "board_boards" | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_updatepermissionsbyparent` | `42P01` | relation "organization_departments" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `board_usercollection_select` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `board_web_search` | `42883` | function nvarchar(integer) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_changegroup` | `42883` | function fnstringtolistint(character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_changepublicgroup` | `42883` | function fnstringtolistint(character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_changesharegroup` | `42883` | function fnstringtolistint(character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_checkgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_countusersharewithoutgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_deletedepartallowaccess` | `42883` | function splitstring(character varying, unknown) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_deletepublicgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_deletesharegroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_finduser` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getaddressinfo` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getaddressnotupdatecount` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getallcontactslist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getallgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getalluser_distinct` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getcontactgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getcontactscount` | `42703` | column "p_reguserno" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `contacts_getcontactslist` | `42703` | column "p_reguserno" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `contacts_getcontactstrashlist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getcountchilduser` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getdefaultboxcount` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getdepartallowaccess` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getdepartmentboxcount` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getgroupbyseq` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_gethistorylist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_gethistorylistcount` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getonerowchildgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getpublicgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getsharedepartmentdefault` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getsharegroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getsharegroupbyuser` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getsharegroupsetting` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_gettrashuserlist` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser_department` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser_noname` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser_phoneinfo` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser_share` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuser_ungroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuserbypublicgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuserbysharegroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuserdata` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuserdatahistory` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getuserdetail` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getusergroupbylanguage` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getusergroupmobi` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_getusernumber` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_insertlistgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_insertuserforexcel` | `42883` | function contacts_insertlistgroupcontact(integer, character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_moveallcontact` | `42P01` | relation "g" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `contacts_restorecontactlist` | `42883` | function contacts_stringtolistint(character varying) does not exist | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_searchmobi` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_setcontactsrestore` | `42883` | operator does not exist: integer = character varying | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_setshare` | `42883` | operator does not exist: character varying = integer | Unresolved | Verify the expected helper/signature and create or convert it only if it exists in the source system. |
| `contacts_updateandroiddevice_notificationoptions` | `42P01` | relation "_androiddevices" does not exist | Unresolved | Create the source-owned schema dependency, or document it as external with evidence. |
| `contacts_updatepublicgroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
| `contacts_updatesharegroup` | `0A000` | set-valued function called in context that cannot accept a set | Metadata unavailable | Obtain reviewed result columns from SQL Server metadata, then invoke with AS result(column type, ...). |
