# Standardized Runtime Smoke Test Report

## 1. Executive Summary

- **Total Routines Tested**: 351
- **Triage Breakdown**:
  - **RUNTIME_PASS**: 88
  - **RUNTIME_FAIL**: 180
  - **BLOCKED_NEED_SIGNATURE**: 83
  - **BLOCKED_NEED_DATA**: 0
  - **BLOCKED_SIDE_EFFECT_UNSAFE**: 0
  - **NEED_BUSINESS_VALIDATION**: 0

## 2. Failure Details (RUNTIME_FAIL)

### `board_authority_select`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "departno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_checkpermissionbycontentno`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_convertboard`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletecommentsetting`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletecurrentmanager`
- **Input Test Used**: `''::character varying, ''::character varying`
- **Error Message**: `function public.fn_split_array(character varying, character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_deletedepartallowaccess`
- **Input Test Used**: `''::character varying`
- **Error Message**: `function splitstring(character varying, unknown) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_deletefile`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "fileno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletefilebycontent`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deleteiosdevice`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletemultiboardwidget`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletenewboardwidget`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletenotificationservice`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "notificationno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deletereply`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_deleteshare`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downboard`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "sortno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downboardbyuser`
- **Input Test Used**: `0::integer, 0::integer, false`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downfolder`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "parentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downfolderbyuser`
- **Input Test Used**: `0::integer, 0::integer, false`
- **Error Message**: `column reference "parentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downmultilwidget`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downmultiwidget`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_downwidget`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getallboardcontentsbyboardlist`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- **Error Message**: `function nvarchar(integer) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_getallowbyitem`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "itemno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getallowbyitemtype`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "itemtype" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getallowbyuser`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getapprovaldoc`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getapprovalfiles`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getboard`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getboardcontents`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- **Error Message**: `function nvarchar(integer) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_getboardcontents_bk20181227`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- **Error Message**: `function nvarchar(integer) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_getconfig`
- **Input Test Used**: `''::character varying`
- **Error Message**: `column reference "configkey" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getdepartandpositionname`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "departno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getfile`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "fileno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getfiles`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getfolderbyfolderno`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "folderno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getheads`
- **Input Test Used**: `0::integer, false`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getmaxsortoftree`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "parentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getrecommendcount`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getrecommendedlogbyuserno`
- **Input Test Used**: `0::bigint, 0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getrecommendedlogs`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getrecommendlogcount`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getreply`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "replyno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getreplyfilebyreplyfileno`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "replyfileno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getreplyfilebyreplyno`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "replyno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getsharers`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getstatusapprovalpermission`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getteamname`
- **Input Test Used**: `''::character varying, ''::character varying`
- **Error Message**: `function year(timestamp without time zone) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_gettreesubmenu_v2_json`
- **Input Test Used**: `0::integer, false, ''::character varying, 0::integer, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_getuserbyshare`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertandroiddevice`
- **Input Test Used**: `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertboard`
- **Input Test Used**: `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false, 0::integer`
- **Error Message**: `relation "public.Board_Boards" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_insertboardcontent`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::bigint, 0::integer, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertcommentsetting`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertcurrentmanager`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer`
- **Error Message**: `column reference "user_no" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertiosdevice`
- **Input Test Used**: `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertmultiboardwidget`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertnewboardwidget`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertnotificationservice`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- **Error Message**: `query has no destination for result data`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `board_insertrecommendedlog`
- **Input Test Used**: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertreply`
- **Input Test Used**: `0::bigint, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, 0::bigint, 0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_insertviewedlog`
- **Input Test Used**: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_mobile_search`
- **Input Test Used**: `''::character varying, 0::integer, false, 0::integer, 0::integer`
- **Error Message**: `syntax error at or near "DESC"`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `board_setallhistoryfolder`
- **Input Test Used**: `0::integer, false`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_setcontentsetting`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `relation "public.Board_ContentSetting" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_sethistoryfolder`
- **Input Test Used**: `0::integer, 0::integer, false`
- **Error Message**: `relation "public.Board_HistoryFolder" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_setshare`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- **Error Message**: `operator does not exist: character varying = integer`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_upboard`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "sortno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_upboardbyuser`
- **Input Test Used**: `0::integer, 0::integer, false`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateallowaccess`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "folderno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateandroiddevice_notificationoptions`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateandroiddevice_timezoneoffset`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateapprovaldoc`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboard`
- **Input Test Used**: `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false`
- **Error Message**: `relation "public.Board_Boards" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_updateboardcontent`
- **Input Test Used**: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, false, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_content`
- **Input Test Used**: `0::bigint, ''::character varying`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_enabled`
- **Input Test Used**: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_enabledforuser`
- **Input Test Used**: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false, 0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_isnotice`
- **Input Test Used**: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_titleeffect`
- **Input Test Used**: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcontent_viewed`
- **Input Test Used**: `0::bigint`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateboardcustorm`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updateconfig`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "configkey" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatedepartallowaccess`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "folderno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatefile`
- **Input Test Used**: `0::bigint, 0::bigint, ''::character varying, 0::bigint, ''::character varying`
- **Error Message**: `column reference "fileno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatefolder`
- **Input Test Used**: `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false`
- **Error Message**: `relation "public.Board_Folders" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `board_updateiosdevice_notificationoptions`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatelevelrand`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `column reference "folderno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatenoticepermission`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatenotificationservice`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- **Error Message**: `query has no destination for result data`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `board_updatepermissionsbyparent`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "departno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updaterecommendpublic`
- **Input Test Used**: `0::bigint, false`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatereply`
- **Input Test Used**: `0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::bigint`
- **Error Message**: `column reference "replyno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_updatespectype`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `query has no destination for result data`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `board_updatestatusapproval`
- **Input Test Used**: `0::bigint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- **Error Message**: `column reference "contentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_upfolder`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "parentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_upfolderbyuser`
- **Input Test Used**: `0::integer, 0::integer, false`
- **Error Message**: `column reference "parentno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_upmultiwidget`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_upwidget`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "boardno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `board_web_search`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer, false, false`
- **Error Message**: `function nvarchar(integer) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contact_checkinsertgroupdefault`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "isdefault" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contact_getgroupdefaultbyuserno`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contact_insertsharegroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "sort" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_changegroup`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `function fnstringtolistint(character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_changepublicgroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `function fnstringtolistint(character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_changesharegroup`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `function fnstringtolistint(character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_checknumber`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "value" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_delallcontactstrash`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_delcontactsgroup`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_delcontactsshare`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_deleteaddressall`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_deleteallgroupbyuserseq`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_deletebackupinfo`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "backupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_deletedepartallowaccess`
- **Input Test Used**: `''::character varying`
- **Error Message**: `function splitstring(character varying, unknown) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_getallgroups`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getallgroupsrestore`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getalllistgroupcontact`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "listgroup_id" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getbackupinfo`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getbackupinfoonce`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "backupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getcontactscount`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- **Error Message**: `column "p_reguserno" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_getcontactslist`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- **Error Message**: `column "p_reguserno" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_getgroupbyuser`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getgroupinfo`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getlocations`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "contactuserid" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getoutfile`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `invalid input syntax for integer: ""`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `contacts_getoutfileexcel`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `invalid input syntax for integer: ""`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `contacts_getoutlist`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `invalid input syntax for integer: ""`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `contacts_getoutlistcount`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `invalid input syntax for integer: ""`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `contacts_getoutlistexcel`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying, ''::character varying, false`
- **Error Message**: `invalid input syntax for integer: ""`
- **Suspected Cause**: Unknown database mismatch
- **Is Converter Bug**: No (Database schema / type discrepancy)

### `contacts_getsetup`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getsharers`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_gettopcategory`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_address`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_company`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_days`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_email`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_homepage`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_number`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_phoneinfo`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_sns`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_togroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getuser_togroupmobile`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getusergroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_getusergroupbyuserno`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertbackupinfo`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertcontactforoutlookentryid`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertcontactforoutlookfolderentryid`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertgroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "sort" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertpublicgroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "sort" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertsharegroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer`
- **Error Message**: `column reference "sort" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_insertuserforexcel`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying`
- **Error Message**: `function contacts_insertlistgroupcontact(integer, character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_moveallcontact`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `relation "g" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_movecontactgroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_moveuser`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_restorecontactlist`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `function contacts_stringtolistint(character varying) does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_saveaddressinfo`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- **Error Message**: `column "moddate" is of type timestamp without time zone but expression is of type integer`
- **Suspected Cause**: Explicit type mismatch on insert/update assignment
- **Is Converter Bug**: Yes

### `contacts_savecontactsforoutlook`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- **Error Message**: `column reference "outlookentryid" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_savecontactshistory`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_savegroupforoutlook`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_savesetup`
- **Input Test Used**: `0::integer, 0::integer, 0::bigint, false`
- **Error Message**: `column reference "userno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_setcallphone`
- **Input Test Used**: `0::integer`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_setcontactsgroup`
- **Input Test Used**: `0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_setcontactsrestore`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `operator does not exist: integer = character varying`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_setcontactstrash`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "seq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_setcontactsuser`
- **Input Test Used**: `''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- **Error Message**: `column "groupno" is of type integer but expression is of type character varying`
- **Suspected Cause**: Explicit type mismatch on insert/update assignment
- **Is Converter Bug**: Yes

### `contacts_setmovecontacts`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_setshare`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying, ''::character varying`
- **Error Message**: `operator does not exist: character varying = integer`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_setusercheckdate`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `column reference "reguserno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updateandroiddevice_notificationoptions`
- **Input Test Used**: `0::integer, ''::character varying, ''::character varying`
- **Error Message**: `relation "_androiddevices" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_updatecontactgroupuser`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatecontactimportant`
- **Input Test Used**: `0::integer, 0::integer`
- **Error Message**: `relation "public.ContactsUser" does not exist`
- **Suspected Cause**: Missing function, sequence, or table relation dependency
- **Is Converter Bug**: No

### `contacts_updatecontactsuser`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatedepartallowaccess`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "allowvalue" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updategroup`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updategroupmemo`
- **Input Test Used**: `0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updategroupstate`
- **Input Test Used**: `0::integer, ''::character varying`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatelistgroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer, ''::character varying`
- **Error Message**: `column reference "listgroup_id" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatepublicgroupuser`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatesharegroupuser`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "userseq" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatesortdownofgroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes

### `contacts_updatesortupofgroup`
- **Input Test Used**: `0::integer, 0::integer, 0::integer`
- **Error Message**: `column reference "groupno" is ambiguous`
- **Suspected Cause**: Ambiguous column reference (parameter name matches table column)
- **Is Converter Bug**: Yes



## 3. Conclusion & Recommendations
- **Overall Status**: **NEED VERIFICATION** (Some procedures fail execution due to parameter/column name collisions or casting differences).
- **Casting Mismatches**: Converter rules should be refined to add automatic parameter qualification and type-cast handlers (e.g. ::integer or explicit CAST).
