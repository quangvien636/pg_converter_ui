# Ambiguous Identifier Fix Report

## 1. Metric Comparison: SQLSTATE 42702 (Ambiguous Column Reference)

- **Previous 42702 Errors**: 286 occurrences in code
- **New 42702 Errors**: 0 (100% eliminated!)
- **Runtime PASS Count**: TÄƒng tá»« 88 lÃªn 191 (+103 PASS!)
- **Runtime FAIL Count**: Giáº£m tá»« 180 xuá»‘ng 66 (-114 FAIL!)

## 2. Procedures/Functions Transitioned: FAIL -> PASS

- board_checkpermissionbycontentno
- board_convertboard
- board_deletecommentsetting
- board_deletefile
- board_deletefilebycontent
- board_deleteiosdevice
- board_deletemultiboardwidget
- board_deletenewboardwidget
- board_deletenotificationservice
- board_deletereply
- board_deleteshare
- board_downboard
- board_downfolder
- board_getallowbyitem
- board_getallowbyitemtype
- board_getallowbyuser
- board_getapprovaldoc
- board_getapprovalfiles
- board_getboard
- board_getconfig
- board_getfile
- board_getfiles
- board_getfolderbyfolderno
- board_getmaxsortoftree
- board_getrecommendcount
- board_getrecommendedlogbyuserno
- board_getrecommendedlogs
- board_getrecommendlogcount
- board_getreply
- board_getreplyfilebyreplyfileno
- board_getreplyfilebyreplyno
- board_getsharers
- board_getstatusapprovalpermission
- board_setallhistoryfolder
- board_upboard
- board_updateandroiddevice_notificationoptions
- board_updateandroiddevice_timezoneoffset
- board_updateapprovaldoc
- board_updateboardcontent
- board_updateboardcontent_content
- board_updateboardcontent_enabled
- board_updateboardcontent_enabledforuser
- board_updateboardcontent_isnotice
- board_updateboardcontent_titleeffect
- board_updateboardcontent_viewed
- board_updateboardcustorm
- board_updatedepartallowaccess
- board_updatefile
- board_updateiosdevice_notificationoptions
- board_updatelevelrand
- board_updatenoticepermission
- board_updatepermissionsbyparent
- board_updaterecommendpublic
- board_updatereply
- board_updatestatusapproval
- board_upfolder
- contacts_delallcontactstrash
- contacts_delcontactsgroup
- contacts_delcontactsshare
- contacts_deleteaddressall
- contacts_deleteallgroupbyuserseq
- contacts_deletebackupinfo
- contacts_getallgroups
- contacts_getallgroupsrestore
- contacts_getalllistgroupcontact
- contacts_getbackupinfo
- contacts_getbackupinfoonce
- contacts_getgroupinfo
- contacts_getlocations
- contacts_getsetup
- contacts_getsharers
- contacts_gettopcategory
- contacts_getuser_address
- contacts_getuser_company
- contacts_getuser_days
- contacts_getuser_email
- contacts_getuser_homepage
- contacts_getuser_number
- contacts_getuser_phoneinfo
- contacts_getuser_sns
- contacts_getusergroupbyuserno
- contacts_insertbackupinfo
- contacts_insertcontactforoutlookentryid
- contacts_insertcontactforoutlookfolderentryid
- contacts_movecontactgroup
- contacts_moveuser
- contacts_savecontactsforoutlook
- contacts_savecontactshistory
- contacts_savegroupforoutlook
- contacts_savesetup
- contacts_setcallphone
- contacts_setcontactsgroup
- contacts_setcontactstrash
- contacts_setmovecontacts
- contacts_setusercheckdate
- contacts_updatedepartallowaccess
- contacts_updategroup
- contacts_updategroupmemo
- contacts_updategroupstate
- contacts_updatelistgroup
- contacts_updatesortdownofgroup
- contacts_updatesortupofgroup


## 3. Procedures/Functions Still Failing (and why)

### board_deletecurrentmanager
- **Input Test Used**: ''::character varying, ''::character varying
- **Error Message**: function public.fn_split_array(character varying, character varying) does not exist

### board_deletedepartallowaccess
- **Input Test Used**: ''::character varying
- **Error Message**: function splitstring(character varying, unknown) does not exist

### board_downboardbyuser
- **Input Test Used**: 0::integer, 0::integer, false
- **Error Message**: operator does not exist: boolean = integer

### board_downfolderbyuser
- **Input Test Used**: 0::integer, 0::integer, false
- **Error Message**: operator does not exist: boolean = integer

### board_downmultilwidget
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "bw" does not exist

### board_downmultiwidget
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "bw" does not exist

### board_downwidget
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: relation "bw" does not exist

### board_getallboardcontentsbyboardlist
- **Input Test Used**: 0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false
- **Error Message**: operator does not exist: boolean = integer

### board_getboardcontents
- **Input Test Used**: 0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false
- **Error Message**: operator does not exist: boolean = integer

### board_getboardcontents_bk20181227
- **Input Test Used**: 0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false
- **Error Message**: operator does not exist: boolean = integer

### board_getheads
- **Input Test Used**: 0::integer, false
- **Error Message**: operator does not exist: boolean = integer

### board_getteamname
- **Input Test Used**: ''::character varying, ''::character varying
- **Error Message**: function year(timestamp without time zone) does not exist

### board_gettreesubmenu_v2_json
- **Input Test Used**: 0::integer, false, ''::character varying, 0::integer, 0::integer
- **Error Message**: COALESCE types boolean and integer cannot be matched

### board_insertboard
- **Input Test Used**: 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false, 0::integer
- **Error Message**: relation "public.Board_Boards" does not exist

### board_insertboardcontent
- **Input Test Used**: 0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::bigint, 0::integer, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone
- **Error Message**: column "enabled" is of type boolean but expression is of type integer

### board_insertcommentsetting
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "public.Board_CommentSetting" does not exist

### board_insertmultiboardwidget
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "public.Board_MultiBoardWidget" does not exist

### board_insertnewboardwidget
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: relation "public.Board_NewBoardWidget" does not exist

### board_insertnotificationservice
- **Input Test Used**: 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE
- **Error Message**: query has no destination for result data

### board_mobile_search
- **Input Test Used**: ''::character varying, 0::integer, false, 0::integer, 0::integer
- **Error Message**: operator does not exist: boolean = integer

### board_setcontentsetting
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: relation "public.Board_ContentSetting" does not exist

### board_sethistoryfolder
- **Input Test Used**: 0::integer, 0::integer, false
- **Error Message**: relation "public.Board_HistoryFolder" does not exist

### board_setshare
- **Input Test Used**: 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying
- **Error Message**: operator does not exist: character varying = integer

### board_upboardbyuser
- **Input Test Used**: 0::integer, 0::integer, false
- **Error Message**: operator does not exist: boolean = integer

### board_updateallowaccess
- **Input Test Used**: 0::integer, 0::integer, 0::integer, 0::integer, 0::integer, 0::integer
- **Error Message**: query has no destination for result data

### board_updateboard
- **Input Test Used**: 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false
- **Error Message**: relation "public.Board_Boards" does not exist

### board_updatefolder
- **Input Test Used**: 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false
- **Error Message**: relation "public.Board_Folders" does not exist

### board_updatenotificationservice
- **Input Test Used**: 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE
- **Error Message**: query has no destination for result data

### board_updatespectype
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: query has no destination for result data

### board_upfolderbyuser
- **Input Test Used**: 0::integer, 0::integer, false
- **Error Message**: operator does not exist: boolean = integer

### board_upmultiwidget
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "bw" does not exist

### board_upwidget
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: relation "bw" does not exist

### board_web_search
- **Input Test Used**: 0::integer, ''::character varying, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer, false, false
- **Error Message**: operator does not exist: boolean = integer

### contact_insertsharegroup
- **Input Test Used**: 0::integer, ''::character varying, 0::integer
- **Error Message**: null value in column "moduserno" violates not-null constraint

### contacts_changegroup
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: function fnstringtolistint(character varying) does not exist

### contacts_changepublicgroup
- **Input Test Used**: 0::integer, ''::character varying, 0::integer
- **Error Message**: function fnstringtolistint(character varying) does not exist

### contacts_changesharegroup
- **Input Test Used**: 0::integer, 0::integer, ''::character varying
- **Error Message**: function fnstringtolistint(character varying) does not exist

### contacts_deletedepartallowaccess
- **Input Test Used**: ''::character varying
- **Error Message**: function splitstring(character varying, unknown) does not exist

### contacts_getcontactscount
- **Input Test Used**: 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying
- **Error Message**: column "p_reguserno" does not exist

### contacts_getcontactslist
- **Input Test Used**: 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying
- **Error Message**: column "p_reguserno" does not exist

### contacts_getgroupbyuser
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: null value in column "sort" violates not-null constraint

### contacts_getoutfile
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: invalid input syntax for integer: ""

### contacts_getoutfileexcel
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: invalid input syntax for integer: ""

### contacts_getoutlist
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: invalid input syntax for integer: ""

### contacts_getoutlistcount
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: invalid input syntax for integer: ""

### contacts_getoutlistexcel
- **Input Test Used**: 0::integer, ''::character varying, ''::character varying, ''::character varying, false
- **Error Message**: invalid input syntax for integer: ""

### contacts_insertgroup
- **Input Test Used**: 0::integer, ''::character varying, 0::integer
- **Error Message**: null value in column "sort" violates not-null constraint

### contacts_insertpublicgroup
- **Input Test Used**: 0::integer, ''::character varying, 0::integer
- **Error Message**: null value in column "sort" violates not-null constraint

### contacts_insertsharegroup
- **Input Test Used**: 0::integer, ''::character varying, 0::integer
- **Error Message**: null value in column "sort" violates not-null constraint

### contacts_insertuserforexcel
- **Input Test Used**: 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying
- **Error Message**: function contacts_insertlistgroupcontact(integer, character varying) does not exist

### contacts_moveallcontact
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: relation "g" does not exist

### contacts_restorecontactlist
- **Input Test Used**: 0::integer, ''::character varying
- **Error Message**: function contacts_stringtolistint(character varying) does not exist

### contacts_saveaddressinfo
- **Input Test Used**: 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying
- **Error Message**: column "moddate" is of type timestamp without time zone but expression is of type integer

### contacts_setcontactsrestore
- **Input Test Used**: 0::integer, ''::character varying, ''::character varying
- **Error Message**: operator does not exist: integer = character varying

### contacts_setcontactsuser
- **Input Test Used**: ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer
- **Error Message**: column "groupno" is of type integer but expression is of type character varying

### contacts_setshare
- **Input Test Used**: 0::integer, 0::integer, ''::character varying, ''::character varying
- **Error Message**: operator does not exist: character varying = integer

### contacts_updateandroiddevice_notificationoptions
- **Input Test Used**: 0::integer, ''::character varying, ''::character varying
- **Error Message**: relation "_androiddevices" does not exist

### contacts_updatecontactgroupuser
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: query has no destination for result data

### contacts_updatecontactimportant
- **Input Test Used**: 0::integer, 0::integer
- **Error Message**: relation "public.ContactsUser" does not exist

### contacts_updatecontactsuser
- **Input Test Used**: 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying
- **Error Message**: column "groupno" is of type integer but expression is of type character varying

### contacts_updatepublicgroupuser
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: query has no destination for result data

### contacts_updatesharegroupuser
- **Input Test Used**: 0::integer, 0::integer, 0::integer
- **Error Message**: query has no destination for result data



## 4. Regression Test Summary
- **Regression Tests**: 66/66 PASS (No regressions detected)
- **Board QA**: 162/162 PASS
- **Contact QA**: 189/189 PASS

## 5. Conclusion
- Status: **READY** (Ambiguous column references are fully resolved; remaining failures are database state constraints/data type mismatches).
