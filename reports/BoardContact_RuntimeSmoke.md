# Board% & Contact% Runtime Smoke Test Report

**Generated**: 2026-07-01 07:46:44  
**Target**: `pg_converter_runtime_test` @ `221.148.141.4:5432` (PostgreSQL 15.7)  
**Method**: Each function invoked with safe dummy params inside `BEGIN; ... ROLLBACK;`  

## 1. Summary

| Metric | Board% | Contact% | Total |
|--------|-------:|--------:|------:|
| Functions tested | 162 | 189 | 351 |
| RUNTIME PASS | 0 | 1 | 1 |
| RUNTIME FAIL | 5 | 3 | 8 |
| BLOCKED | 157 | 185 | 342 |

## 2. Top Recurring Error Patterns

| # | SqlState | Pattern | Count | Examples |
|---|----------|---------|------:|----------|
| 1 | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation | 257 | `board_authority_select`, `board_board_maxsortno_select`, `board_checkallowbyitem` |
| 2 | `42P01` | relation "<name>" does not exist | 73 | `board_convertboard`, `board_deletecommentsetting`, `board_deletecurrentmanager` |
| 3 | `42702` | column reference "<name>" is ambiguous | 3 | `board_setcontentsetting`, `board_sethistoryfolder`, `contacts_updatecontactimportant` |
| 4 | `2200N` | invalid XML content | 2 | `board_insertnotificationservice`, `board_updatenotificationservice` |
| 5 | `42601` | unterminated quoted string at or near "<name>"enabled\"<name>" | 2 | `board_updateandroiddevice_notificationoptions`, `contacts_updateandroiddevice_notificationoptions` |
| 6 | `42883` | function len(character varying) does not exist | 2 | `contacts_deletehistory`, `contacts_setemail` |
| 7 | `42883` | function public.board_insertboard(integer, timestamp with time zone, unknown, unknown, integer, inte | 1 | `board_insertboard` |
| 8 | `42883` | function public.board_updateboard(integer, integer, timestamp with time zone, unknown, unknown, inte | 1 | `board_updateboard` |
| 9 | `42883` | function public.board_updateboardcontent_enabled(integer, timestamp with time zone, boolean) does no | 1 | `board_updateboardcontent_enabled` |
| 10 | `42883` | function public.board_updateboardcontent_enabledforuser(integer, timestamp with time zone, boolean,  | 1 | `board_updateboardcontent_enabledforuser` |
| 11 | `42883` | function public.board_updateboardcontent_isnotice(integer, timestamp with time zone, boolean) does n | 1 | `board_updateboardcontent_isnotice` |
| 12 | `42883` | function public.board_updateboardcontent_titleeffect(integer, timestamp with time zone, integer) doe | 1 | `board_updateboardcontent_titleeffect` |
| 13 | `42883` | function public.board_updatereply(integer, integer, unknown, integer, unknown, integer, unknown, tim | 1 | `board_updatereply` |
| 14 | `42601` | unterminated quoted string at or near "<name>" | 1 | `contacts_changesharegroup` |
| 15 | `42883` | function public.contacts_setaddress(integer, integer, integer, unknown, unknown, unknown, unknown, u | 1 | `contacts_setaddress` |
| 16 | `42883` | function public.contacts_setdays(integer, integer, integer, unknown, unknown, unknown, unknown) does | 1 | `contacts_setdays` |
| 17 | `42883` | function public.contacts_setnumber(integer, integer, integer, unknown, unknown, unknown) does not ex | 1 | `contacts_setnumber` |

## 3. Results by Status

### 3a. RUNTIME PASS

1 procedures invoked successfully (result discarded via ROLLBACK):

- `contacts_delcontactsuser`

### 3b. RUNTIME FAIL

8 procedures failed at runtime:

| Procedure | SqlState | Error Message |
|-----------|----------|---------------|
| `board_insertnotificationservice` | `2200N` | invalid XML content |
| `board_setcontentsetting` | `42702` | column reference "boardno" is ambiguous |
| `board_sethistoryfolder` | `42702` | column reference "folderno" is ambiguous |
| `board_updateandroiddevice_notificationoptions` | `42601` | unterminated quoted string at or near "'{\"enabled\": true, NULL, NULL, NULL, NULL, '');" |
| `board_updatenotificationservice` | `2200N` | invalid XML content |
| `contacts_changesharegroup` | `42601` | unterminated quoted string at or near "'7996, '');" |
| `contacts_updateandroiddevice_notificationoptions` | `42601` | unterminated quoted string at or near "'{\"enabled\": true, NULL, NULL, NULL, NULL, '');" |
| `contacts_updatecontactimportant` | `42702` | column reference "seq" is ambiguous |

### 3c. BLOCKED

342 procedures blocked:

| Procedure | SqlState | Reason |
|-----------|----------|--------|
| `board_authority_select` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_board_maxsortno_select` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_checkallowbyitem` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_checkpermission` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_checkpermissionbycontentno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_convertboard` | `42P01` | relation "board_boards" does not exist |
| `board_countboardinfolder` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_countcontentinboard` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_countfolderinfolder` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_deletecommentsetting` | `42P01` | relation "board_commentsetting" does not exist |
| `board_deletecurrentmanager` | `42P01` | relation "board_userbygroup" does not exist |
| `board_deletedepartallowaccess` | `42P01` | relation "board_departallowaccess" does not exist |
| `board_deletefile` | `42P01` | relation "board_files" does not exist |
| `board_deletefilebycontent` | `42P01` | relation "board_files" does not exist |
| `board_deleteiosdevice` | `42P01` | relation "board_iosdevices" does not exist |
| `board_deletemultiboardwidget` | `42P01` | relation "board_multiboardwidget" does not exist |
| `board_deletenewboardwidget` | `42P01` | relation "board_newboardwidget" does not exist |
| `board_deletenotificationservice` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_deletereply` | `42P01` | relation "board_replies" does not exist |
| `board_deleteshare` | `42P01` | relation "board_sharers" does not exist |
| `board_downboard` | `42P01` | relation "board_boards" does not exist |
| `board_downboardbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_downfolder` | `42P01` | relation "board_folders" does not exist |
| `board_downfolderbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_downmultilwidget` | `42P01` | relation "board_multiboardwidget" does not exist |
| `board_downmultiwidget` | `42P01` | relation "board_multiboardwidget" does not exist |
| `board_downwidget` | `42P01` | relation "board_newboardwidget" does not exist |
| `board_folder_maxsortno_select` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallboardcontents` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallboardcontentsbyboardlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallboardwidget` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallowbyitem` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallowbyitemtype` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getallowbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getandroiddeviceofallusers` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getandroiddeviceofusersbydepartment` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getapprovaldoc` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getapprovalfiles` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboard` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardbyuserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardcommunitywidget` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardcontentinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardcontents` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboardcontents_bk20181227` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboards` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboards_bk` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getboards_improved` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getcommentsetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getcompanylist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getconfig` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getcontentsetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getcurrentmanagerlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getdepartallowaccess` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getdepartandpositionname` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getfile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getfiles` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getfolderbyfolderno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getfolderbyuserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getfolders` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getheads` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getiosdeviceofallusers` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getiosdeviceofusersbydepartment` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontent_bk` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontent_search` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontentbyfolder` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontentsearch` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistboardcontenttoexcel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistcommentsetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistconverturlfile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistnoticepermission` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistuserpermission` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getlistuserpermissiontoexcel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getmaxsortoftree` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getmultiwidget` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getnewboardcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getnewboardwidget` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getopenfolder` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getprenextcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getrecommendcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getrecommendedlogbyuserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getrecommendedlogs` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getrecommendlogcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreplies` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreply` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreplybycontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreplyfilebycontentno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreplyfilebyreplyfileno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getreplyfilebyreplyno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getsettingcommunitywidget` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getsharers` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getstatusapprovalpermission` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getsubmenus` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getteamlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getteamname` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_gettreeboard` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_gettreesubmenu` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_gettreesubmenu_v2` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_gettreesubmenu_v2_json` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_gettreesubmenutest` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getuserbyshare` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getusersetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getviewedlogs` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_getwidgetcarousel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertandroiddevice` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertboard` | `42883` | function public.board_insertboard(integer, timestamp with time zone, unknown, unknown, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean, integer) does not exist |
| `board_insertboardcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertcommentsetting` | `42P01` | relation "board_commentsetting" does not exist |
| `board_insertcurrentmanager` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertdepartallowaccess` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertfile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertiosdevice` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertmultiboardwidget` | `42P01` | relation "board_multiboardwidget" does not exist |
| `board_insertnewboardwidget` | `42P01` | relation "board_newboardwidget" does not exist |
| `board_insertrecommendedlog` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertreply` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertreplyfile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertusersetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_insertviewedlog` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_mobile_search` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_setallhistoryfolder` | `42P01` | relation "board_historyfolder" does not exist |
| `board_setfolders` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_setshare` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_treeboard` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_upboard` | `42P01` | relation "board_boards" does not exist |
| `board_upboardbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updateallowaccess` | `42P01` | relation "board_folders" does not exist |
| `board_updateandroiddevice_timezoneoffset` | `42P01` | relation "board_androiddevices" does not exist |
| `board_updateapprovaldoc` | `42P01` | relation "board_contents" does not exist |
| `board_updateboard` | `42883` | function public.board_updateboard(integer, integer, timestamp with time zone, unknown, unknown, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean) does not exist |
| `board_updateboardcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updateboardcontent_content` | `42P01` | relation "board_contents" does not exist |
| `board_updateboardcontent_enabled` | `42883` | function public.board_updateboardcontent_enabled(integer, timestamp with time zone, boolean) does not exist |
| `board_updateboardcontent_enabledforuser` | `42883` | function public.board_updateboardcontent_enabledforuser(integer, timestamp with time zone, boolean, integer) does not exist |
| `board_updateboardcontent_isnotice` | `42883` | function public.board_updateboardcontent_isnotice(integer, timestamp with time zone, boolean) does not exist |
| `board_updateboardcontent_titleeffect` | `42883` | function public.board_updateboardcontent_titleeffect(integer, timestamp with time zone, integer) does not exist |
| `board_updateboardcontent_viewed` | `42P01` | relation "board_contents" does not exist |
| `board_updateboardcustorm` | `42P01` | relation "board_boards" does not exist |
| `board_updateconfig` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updatedepartallowaccess` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updatefile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updatefolder` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updateiosdevice_notificationoptions` | `42P01` | relation "board_iosdevices" does not exist |
| `board_updatelevelrand` | `42P01` | relation "board_folders" does not exist |
| `board_updatenoticepermission` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updatepermissionsbyparent` | `42P01` | relation "board_departallowaccess" does not exist |
| `board_updaterecommendpublic` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_updatereply` | `42883` | function public.board_updatereply(integer, integer, unknown, integer, unknown, integer, unknown, timestamp with time zone, unknown, integer) does not exist |
| `board_updatespectype` | `42P01` | relation "board_folders" does not exist |
| `board_updatestatusapproval` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_upfolder` | `42P01` | relation "board_folders" does not exist |
| `board_upfolderbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_upmultiwidget` | `42P01` | relation "board_multiboardwidget" does not exist |
| `board_upwidget` | `42P01` | relation "board_newboardwidget" does not exist |
| `board_usercollection_select` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `board_web_search` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contact_checkinsertgroupdefault` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contact_getgroupdefaultbyuserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contact_insertsharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_changegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_changepublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_checkexitgroupandcontact` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_checkgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_checknumber` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_countgroupcountchild` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_countgroupuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_countuserpublicwithoutgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_countusersharewithoutgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_delallcontactstrash` | `42P01` | relation "contactsuser" does not exist |
| `contacts_delcontactsgroup` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_delcontactsshare` | `42P01` | relation "contactssharers" does not exist |
| `contacts_deleteaddressall` | `42P01` | relation "contactsuser" does not exist |
| `contacts_deleteallgroupbyuserseq` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_deletebackupinfo` | `42P01` | relation "contactsbackup" does not exist |
| `contacts_deletecontact` | `42P01` | relation "contactsuser" does not exist |
| `contacts_deletedepartallowaccess` | `42P01` | relation "contact_departallowaccess" does not exist |
| `contacts_deletehistory` | `42883` | function len(character varying) does not exist |
| `contacts_deletepublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_deletesharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_downpublicgroup` | `42P01` | relation "contact_publicgroup" does not exist |
| `contacts_downsharegroup` | `42P01` | relation "contact_sharegroup" does not exist |
| `contacts_finall` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_findnonameuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_finduser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getaddressinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getaddressnotupdatecount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getalladdress` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallcompany` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallcontactslist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getalldays` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallemail` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallgroups` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallgroupsrestore` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallgroupuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallhomepage` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getalllistgroupcontact` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallnumber` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallsns` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getalluser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getalluser_distinct` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getallusernotrequite` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getbackupinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getbackupinfoonce` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcheckgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactscount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactsforoutlook` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactsgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactslist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcontactstrashlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getcountchilduser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getdefaultboxcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getdefaultcategory` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getdepartallowaccess` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getdepartmentboxcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getdupelist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getgroupbyseq` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getgroupbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getgroupinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getgrouplist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_gethistorylist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_gethistorylistcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlatitudeandlongitudecontacts` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlatitudeandlongitudeonecontacts` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlikelist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlistgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlistgroupwithid` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlocationonecontact` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getlocations` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getnamegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoneaddress` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getonerowchildgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoutfile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoutfileexcel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoutlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoutlistcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getoutlistexcel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getprivateboxcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getpublicboxcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getpublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getranklist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getranklistcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsetup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsharedepartmentdefault` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsharegroupbyuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsharegroupsetting` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getsharers` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_gettopcategory` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_gettrashcount` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_gettrashuserlist` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_address` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_company` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_days` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_department` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_email` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_groupinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_homepage` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_noname` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_number` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_phoneinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_share` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_sns` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_togroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_togroupmobile` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_touserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuser_ungroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuserbypublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuserbysharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuserdata` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuserdatahistory` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getuserdetail` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getusergroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getusergroupbylanguage` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getusergroupbyuserno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getusergroupmobi` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_getusernumber` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertbackupinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertcontactforoutlookentryid` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertcontactforoutlookfolderentryid` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertlistgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertlistgroupcontact` | `42P01` | relation "contacts_listgroupcontact" does not exist |
| `contacts_insertpublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertsharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_insertuser` | `42P01` | relation "contactsuser" does not exist |
| `contacts_insertuserforexcel` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_listgroupcontent` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_moveallcontact` | `42P01` | relation "g" does not exist |
| `contacts_movecontactgroup` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_moveuser` | `42P01` | relation "contactsgroupuser" does not exist |
| `contacts_parentgroupno` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_restorecontactlist` | `42P01` | relation "contactsuser" does not exist |
| `contacts_saveaddressinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_saveaddressinfo_web` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savearrange` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savearrangelike` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savecontactsforoutlook` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savecontactshistory` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savegroupforoutlook` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savelocation` | `42P01` | relation "contacts_locations" does not exist |
| `contacts_saverestore` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_savesetup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_search_nodistance` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_searchmobi` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_seqtoname` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_setaddress` | `42883` | function public.contacts_setaddress(integer, integer, integer, unknown, unknown, unknown, unknown, unknown) does not exist |
| `contacts_setcallphone` | `42P01` | relation "contactsnumber" does not exist |
| `contacts_setcompany` | `42P01` | relation "contactscompany" does not exist |
| `contacts_setcontactsgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_setcontactsrestore` | `42P01` | relation "contactsuser" does not exist |
| `contacts_setcontactstrash` | `42P01` | relation "contactsuser" does not exist |
| `contacts_setcontactsuser` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_setdays` | `42883` | function public.contacts_setdays(integer, integer, integer, unknown, unknown, unknown, unknown) does not exist |
| `contacts_setemail` | `42883` | function len(character varying) does not exist |
| `contacts_setmovecontacts` | `42P01` | relation "contactsgroupuser" does not exist |
| `contacts_setnumber` | `42883` | function public.contacts_setnumber(integer, integer, integer, unknown, unknown, unknown) does not exist |
| `contacts_setshare` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_setsns` | `42P01` | relation "contactssns" does not exist |
| `contacts_setusercheckdate` | `42P01` | relation "contactsuser" does not exist |
| `contacts_updatecontactgroupuser` | `42P01` | relation "contact_publicgroupuser" does not exist |
| `contacts_updatecontactsuser` | `42P01` | relation "contactsgroupuser" does not exist |
| `contacts_updatedepartallowaccess` | `42P01` | relation "contact_sharegroup" does not exist |
| `contacts_updategroup` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updategroupmemo` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updategroupparent` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updategroupstate` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updatelistgroup` | `42P01` | relation "contacts_listgroup" does not exist |
| `contacts_updatelistgroupcontact` | `42P01` | relation "contactsuser" does not exist |
| `contacts_updatepublicgroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_updatepublicgroupuser` | `42P01` | relation "contact_sharegroupuser" does not exist |
| `contacts_updatesharegroup` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_updatesharegroupuser` | `42P01` | relation "contact_publicgroupuser" does not exist |
| `contacts_updatesortdownofgroup` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updatesortupofgroup` | `42P01` | relation "contactsgroup" does not exist |
| `contacts_updateuserinfo` | `N/A` | RETURNS SETOF record - requires explicit column definition list for invocation |
| `contacts_updateuserstate` | `42P01` | relation "contactsuser" does not exist |
| `contacts_uppublicgroup` | `42P01` | relation "contact_publicgroup" does not exist |
| `contacts_upsharegroup` | `42P01` | relation "contact_sharegroup" does not exist |

## 4. Compile Status (Unchanged)

| Suite | Status |
|-------|--------|
| Board% Compile | 162 deployed |
| Contact% Compile | 189 deployed |
| NUnit | (run separately) |

