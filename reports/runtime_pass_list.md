# Runtime pass list

| Procedure | Input | Result columns | Rows observed | Time ms |
|---|---|---|---:|---:|
| `board_board_maxsortno_select` | `0::integer` | column_1:integer | 1 | 204 |
| `board_checkpermission` | `0::integer, 0::integer` | ispermission:boolean, isdisablepermission:boolean | 0 | 218 |
| `board_checkpermissionbycontentno` | `0::integer, 0::integer` | column_1:integer | 1 | 217 |
| `board_convertboard` | `0::integer, 0::integer` | board_convertboard:void | 1 | 211 |
| `board_countboardinfolder` | `0::integer` | column_1:integer | 1 | 217 |
| `board_countcontentinboard` | `0::integer` | column_1:integer | 1 | 216 |
| `board_countfolderinfolder` | `0::integer` | column_1:integer | 1 | 215 |
| `board_deletecommentsetting` | `0::integer, 0::integer` | board_deletecommentsetting:void | 1 | 189 |
| `board_deletecurrentmanager` | `''::character varying, ''::character varying` | board_deletecurrentmanager:void | 1 | 207 |
| `board_deletedepartallowaccess` | `''::character varying` | board_deletedepartallowaccess:void | 1 | 250 |
| `board_deletefile` | `0::bigint` | board_deletefile:void | 1 | 209 |
| `board_deletefilebycontent` | `0::bigint` | board_deletefilebycontent:void | 1 | 208 |
| `board_deleteiosdevice` | `0::integer` | board_deleteiosdevice:void | 1 | 194 |
| `board_deletemultiboardwidget` | `0::integer, 0::integer` | board_deletemultiboardwidget:void | 1 | 123 |
| `board_deletenewboardwidget` | `0::integer, 0::integer, 0::integer` | board_deletenewboardwidget:void | 1 | 115 |
| `board_deletenotificationservice` | `0::integer, ''::character varying, 0::integer` | board_deletenotificationservice:record | 0 | 113 |
| `board_deletereply` | `0::bigint` | board_deletereply:void | 1 | 116 |
| `board_deleteshare` | `0::integer` | board_deleteshare:void | 1 | 111 |
| `board_downboard` | `0::integer` | board_downboard:void | 1 | 112 |
| `board_downboardbyuser` | `0::integer, 0::integer, false` | board_downboardbyuser:record | 0 | 116 |
| `board_downfolder` | `0::integer` | board_downfolder:void | 1 | 116 |
| `board_downfolderbyuser` | `0::integer, 0::integer, false` | board_downfolderbyuser:record | 0 | 113 |
| `board_downmultilwidget` | `0::integer, 0::integer` | board_downmultilwidget:void | 1 | 221 |
| `board_downmultiwidget` | `0::integer, 0::integer` | board_downmultiwidget:void | 1 | 207 |
| `board_downwidget` | `0::integer, 0::integer, 0::integer` | board_downwidget:void | 1 | 139 |
| `board_folder_maxsortno_select` | `0::integer` | column_1:integer | 1 | 114 |
| `board_getallowbyitem` | `0::integer, 0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:integer, column_6:integer, column_7:integer, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 113 |
| `board_getallowbyitemtype` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:integer, column_6:integer, column_7:integer, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 111 |
| `board_getallowbyuser` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:integer, column_6:integer, column_7:integer, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 120 |
| `board_getandroiddeviceofallusers` | `` | column_1:character varying(2000), column_2:character varying(100), column_3:character varying(1000), column_4:integer | 0 | 112 |
| `board_getapprovaldoc` | `0::integer` | column_1:bigint, column_2:character varying(200), column_3:character varying(200), column_4:character varying(1000), column_5:character varying(1000), column_6:character varying(1000), column_7:character varying(1000), column_8:character varying(260), column_9:text | 0 | 126 |
| `board_getapprovalfiles` | `0::integer` | column_1:character varying(260), column_2:text | 0 | 115 |
| `board_getboard` | `0::integer` | column_1:integer, column_2:timestamp without time zone, column_3:character varying(4000), column_4:character varying(1000), column_5:integer, column_6:integer, column_7:integer, column_8:boolean, column_9:boolean, column_10:boolean, column_11:boolean, column_12:integer, column_13:integer, column_14:boolean, column_15:integer | 0 | 249 |
| `board_getboardallow` | `0::integer, 0::integer` | boardno:integer | 0 | 256 |
| `board_getcommentsetting` | `0::integer` | column_1:integer | 1 | 250 |
| `board_getcompanylist` | `` | column_1:integer, column_2:character varying(100) | 0 | 194 |
| `board_getconfig` | `''::character varying` | column_1:integer, column_2:character varying(50), column_3:character varying(500), column_4:integer, column_5:timestamp without time zone | 0 | 163 |
| `board_getcontentsetting` | `0::integer` | column_1:integer, column_2:text, column_3:integer | 0 | 168 |
| `board_getdepartallowaccess` | `0::integer, 0::integer, ''::character varying` | allowaccessno:integer, departno:integer, allowvalue:integer, itemno:integer, itemtype:integer, departname:character varying, isadmin:boolean, isread:boolean, iswrite:boolean, disableadmin:boolean, disablewrite:boolean, disableread:boolean | 0 | 143 |
| `board_getdepartandpositionname` | `0::integer, 0::integer, ''::character varying` | departname:character varying, positionname:character varying | 1 | 163 |
| `board_getfile` | `0::bigint` | column_1:bigint, column_2:character varying(260), column_3:integer, column_4:text | 0 | 150 |
| `board_getfiles` | `0::bigint` | column_1:bigint, column_2:character varying(260), column_3:integer, column_4:text, column_5:integer | 0 | 139 |
| `board_getfolderallow` | `0::integer, 0::integer` | folderno:integer | 0 | 112 |
| `board_getfolderbyfolderno` | `0::integer` | column_1:integer, column_2:integer, column_3:timestamp without time zone, column_4:character varying(4000), column_5:integer, column_6:integer, column_7:boolean, column_8:character varying(500), column_9:integer | 0 | 117 |
| `board_getheads` | `0::integer, false` | column_1:integer, column_2:integer, column_3:integer, column_4:timestamp without time zone, column_5:character varying(100), column_6:integer, column_7:boolean | 0 | 115 |
| `board_getiosdeviceofallusers` | `` | column_1:character varying(2000), column_2:character varying(100), column_3:character varying(1000), column_4:integer | 0 | 116 |
| `board_getlistconverturlfile` | `` | column_1:bigint, column_2:bigint, column_3:character varying(260), column_4:integer, column_5:text, column_6:integer | 0 | 112 |
| `board_getmaxsortoftree` | `0::integer` | column_1:integer | 1 | 111 |
| `board_getnewboardcontent` | `0::integer, 0::integer, 0::integer, ''::character varying, false` | boardno:integer, contentno:bigint, title:character varying, regdate:timestamp without time zone | 0 | 128 |
| `board_getrecommendcount` | `0::bigint` | column_1:bigint | 1 | 113 |
| `board_getrecommendedlogbyuserno` | `0::bigint, 0::integer` | column_1:bigint, column_2:integer, column_3:bigint, column_4:integer, column_5:character varying(100), column_6:integer, column_7:character varying(100), column_8:integer, column_9:character varying(100), column_10:timestamp without time zone | 0 | 111 |
| `board_getrecommendedlogs` | `0::bigint` | column_1:bigint, column_2:integer, column_3:bigint, column_4:integer, column_5:character varying(100), column_6:integer, column_7:character varying(100), column_8:integer, column_9:character varying(100), column_10:timestamp without time zone | 0 | 113 |
| `board_getrecommendlogcount` | `0::bigint` | column_1:integer | 1 | 110 |
| `board_getreplies` | `0::bigint, ''::character varying` | replyno:bigint, moduserno:integer, modusername:character varying, modpositionno:integer, modpositionname:character varying, moddepartno:integer, moddepartname:character varying, regdate:timestamp without time zone, moddate:timestamp without time zone, groupno:bigint, depth:integer, orderno:integer, content:text, userphoto:boolean, photo:character varying | 0 | 115 |
| `board_getreply` | `0::bigint` | column_1:bigint, column_2:bigint, column_3:integer, column_4:character varying(100), column_5:integer, column_6:character varying(100), column_7:integer, column_8:character varying(100), column_9:timestamp without time zone, column_10:timestamp without time zone, column_11:bigint, column_12:integer, column_13:integer, column_14:text | 0 | 111 |
| `board_getreplyfilebycontentno` | `0::bigint` | column_1:bigint, column_2:bigint, column_3:character varying(260), column_4:integer, column_5:text | 0 | 111 |
| `board_getreplyfilebyreplyfileno` | `0::bigint` | column_1:bigint, column_2:bigint, column_3:character varying(260), column_4:integer, column_5:text | 0 | 115 |
| `board_getreplyfilebyreplyno` | `0::bigint` | column_1:bigint, column_2:character varying(260), column_3:integer, column_4:text | 0 | 114 |
| `board_getsharers` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character, column_4:integer, column_5:character varying(100) | 0 | 112 |
| `board_getstatusapprovalpermission` | `0::integer, 0::integer` | column_1:integer | 1 | 111 |
| `board_getteamlist` | `0::integer` | column_1:integer, column_2:character varying(100) | 0 | 111 |
| `board_getuserbyshare` | `0::integer` | userno:integer | 0 | 117 |
| `board_getusersetting` | `0::integer` | column_1:integer, column_2:integer, column_3:integer | 0 | 116 |
| `board_getviewedlogs` | `0::bigint` | column_1:bigint, column_2:integer, column_3:bigint, column_4:integer, column_5:character varying(100), column_6:integer, column_7:character varying, column_8:integer, column_9:character varying, column_10:timestamp without time zone, column_11:character varying(100), column_12:character varying(200), column_13:boolean, column_14:character varying(500) | 0 | 117 |
| `board_getwidgetcarousel` | `0::integer, 0::integer, 0::integer, false` | boardno:integer, contentno:bigint, title:character varying, fileurl:text, thumbnailfileurl:text | 0 | 120 |
| `board_insertboard` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false, 0::integer` | board_insertboard:void | 1 | 113 |
| `board_insertcommentsetting` | `0::integer, 0::integer` | board_insertcommentsetting:void | 1 | 114 |
| `board_insertdepartallowaccess` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer` | column_1:bigint | 1 | 113 |
| `board_insertmultiboardwidget` | `0::integer, 0::integer` | board_insertmultiboardwidget:void | 1 | 112 |
| `board_insertnewboardwidget` | `0::integer, 0::integer, 0::integer` | board_insertnewboardwidget:void | 1 | 112 |
| `board_insertusersetting` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 116 |
| `board_setallhistoryfolder` | `0::integer, false` | board_setallhistoryfolder:void | 1 | 112 |
| `board_setcontentsetting` | `0::integer, ''::character varying` | board_setcontentsetting:void | 1 | 114 |
| `board_setfolders` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false` | board_setfolders:record | 0 | 125 |
| `board_sethistoryfolder` | `0::integer, 0::integer, false` | board_sethistoryfolder:void | 1 | 115 |
| `board_upboard` | `0::integer` | board_upboard:void | 1 | 127 |
| `board_upboardbyuser` | `0::integer, 0::integer, false` | board_upboardbyuser:record | 0 | 117 |
| `board_updateallowaccess` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 123 |
| `board_updateandroiddevice_notificationoptions` | `0::integer, ''::character varying, ''::character varying` | board_updateandroiddevice_notificationoptions:void | 1 | 115 |
| `board_updateandroiddevice_timezoneoffset` | `0::integer, ''::character varying, 0::integer` | board_updateandroiddevice_timezoneoffset:void | 1 | 111 |
| `board_updateapprovaldoc` | `0::integer, ''::character varying, 0::integer` | board_updateapprovaldoc:void | 1 | 111 |
| `board_updateboard` | `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false` | board_updateboard:void | 1 | 123 |
| `board_updateboardcontent` | `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, false, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone` | board_updateboardcontent:record | 0 | 113 |
| `board_updateboardcontent_content` | `0::bigint, ''::character varying` | board_updateboardcontent_content:void | 1 | 114 |
| `board_updateboardcontent_enabled` | `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false` | board_updateboardcontent_enabled:void | 1 | 111 |
| `board_updateboardcontent_enabledforuser` | `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false, 0::integer` | board_updateboardcontent_enabledforuser:void | 1 | 113 |
| `board_updateboardcontent_isnotice` | `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false` | board_updateboardcontent_isnotice:void | 1 | 114 |
| `board_updateboardcontent_titleeffect` | `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer` | board_updateboardcontent_titleeffect:void | 1 | 118 |
| `board_updateboardcontent_viewed` | `0::bigint` | board_updateboardcontent_viewed:void | 1 | 113 |
| `board_updateboardcustorm` | `0::integer, 0::integer` | board_updateboardcustorm:void | 1 | 111 |
| `board_updatedepartallowaccess` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer` | board_updatedepartallowaccess:record | 0 | 124 |
| `board_updatefile` | `0::bigint, 0::bigint, ''::character varying, 0::bigint, ''::character varying` | column_1:bigint | 1 | 114 |
| `board_updatefolder` | `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false` | board_updatefolder:record | 0 | 111 |
| `board_updateiosdevice_notificationoptions` | `0::integer, ''::character varying, ''::character varying` | board_updateiosdevice_notificationoptions:void | 1 | 117 |
| `board_updatelevelrand` | `0::integer, ''::character varying` | board_updatelevelrand:void | 1 | 111 |
| `board_updatenoticepermission` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 111 |
| `board_updatepermissionsbyparent` | `0::integer, 0::integer` | board_updatepermissionsbyparent:void | 1 | 112 |
| `board_updaterecommendpublic` | `0::bigint, false` | column_1:bigint | 1 | 111 |
| `board_updatereply` | `0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::bigint` | board_updatereply:void | 1 | 123 |
| `board_updatestatusapproval` | `0::bigint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | board_updatestatusapproval:record | 0 | 123 |
| `board_upfolder` | `0::integer` | board_upfolder:void | 1 | 111 |
| `board_upfolderbyuser` | `0::integer, 0::integer, false` | board_upfolderbyuser:record | 0 | 113 |
| `board_upmultiwidget` | `0::integer, 0::integer` | board_upmultiwidget:void | 1 | 125 |
| `board_upwidget` | `0::integer, 0::integer, 0::integer` | board_upwidget:void | 1 | 116 |
| `board_usercollection_select` | `` | column_1:integer, column_2:integer, column_3:character varying(100), column_4:character varying(100), column_5:integer, column_6:text, column_7:character varying(100), column_8:character varying(100) | 0 | 114 |
| `board_web_search` | `0::integer, ''::character varying, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer, false, false` | board_web_search:record | 0 | 121 |
| `contact_checkinsertgroupdefault` | `0::integer, ''::character varying, ''::character varying` | groupno:integer | 1 | 143 |
| `contacts_changegroup` | `0::integer, ''::character varying` | contacts_changegroup:record | 0 | 113 |
| `contacts_changepublicgroup` | `0::integer, ''::character varying, 0::integer` | contacts_changepublicgroup:record | 0 | 119 |
| `contacts_changesharegroup` | `0::integer, 0::integer, ''::character varying` | contacts_changesharegroup:void | 1 | 111 |
| `contacts_checkexitgroupandcontact` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 120 |
| `contacts_checknumber` | `0::integer, ''::character varying, 0::integer` | cnt:integer | 1 | 111 |
| `contacts_countgroupcountchild` | `0::integer, 0::integer` | column_1:integer | 1 | 111 |
| `contacts_countgroupuser` | `0::integer` | column_1:integer | 1 | 111 |
| `contacts_countuserpublicwithoutgroup` | `` | column_1:integer | 1 | 112 |
| `contacts_countusersharewithoutgroup` | `0::integer` | column_1:integer | 1 | 112 |
| `contacts_delallcontactstrash` | `0::integer` | contacts_delallcontactstrash:void | 1 | 112 |
| `contacts_delcontactsgroup` | `0::integer` | contacts_delcontactsgroup:void | 1 | 122 |
| `contacts_delcontactsshare` | `0::integer` | contacts_delcontactsshare:void | 1 | 111 |
| `contacts_delcontactsuser` | `0::integer, 0::integer, ''::character varying` | contacts_delcontactsuser:void | 1 | 110 |
| `contacts_deleteaddressall` | `0::integer, 0::integer, 0::integer` | contacts_deleteaddressall:void | 1 | 119 |
| `contacts_deleteallgroupbyuserseq` | `0::integer, 0::integer` | column_1:integer | 1 | 111 |
| `contacts_deletebackupinfo` | `0::integer` | contacts_deletebackupinfo:void | 1 | 110 |
| `contacts_deletecontact` | `0::integer` | contacts_deletecontact:void | 1 | 115 |
| `contacts_deletedepartallowaccess` | `''::character varying` | contacts_deletedepartallowaccess:void | 1 | 116 |
| `contacts_deletehistory` | `''::character varying` | contacts_deletehistory:void | 1 | 116 |
| `contacts_deletepublicgroup` | `0::integer, 0::integer` | column_1:integer | 1 | 113 |
| `contacts_deletesharegroup` | `0::integer, 0::integer` | column_1:integer | 1 | 117 |
| `contacts_downpublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_downpublicgroup:void | 1 | 120 |
| `contacts_downsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_downsharegroup:void | 1 | 112 |
| `contacts_finall` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_finall:record | 0 | 112 |
| `contacts_findnonameuser` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_findnonameuser:record | 0 | 116 |
| `contacts_getalladdress` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(5), column_7:character varying(5), column_8:character varying(500), column_9:character, column_10:timestamp without time zone, column_11:timestamp without time zone, column_12:double precision, column_13:double precision | 0 | 119 |
| `contacts_getallcompany` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 111 |
| `contacts_getalldays` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:character, column_9:timestamp without time zone, column_10:timestamp without time zone | 0 | 120 |
| `contacts_getallemail` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character, column_6:timestamp without time zone, column_7:timestamp without time zone | 0 | 111 |
| `contacts_getallgroup` | `0::integer, ''::character varying` | groupno:integer, groupname:text, rootgroupno:integer, reguserno:integer, regdate:timestamp without time zone, memo:character varying, parentgno:integer, sort:integer, isdefault:character, usercount:integer, name:text | 0 | 113 |
| `contacts_getallgroups` | `0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:integer, column_10:character | 0 | 117 |
| `contacts_getallgroupsrestore` | `0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:integer, column_10:character | 0 | 116 |
| `contacts_getallgroupuser` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:timestamp without time zone, column_6:timestamp without time zone | 0 | 112 |
| `contacts_getallhomepage` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 113 |
| `contacts_getalllistgroupcontact` | `0::integer` | column_1:integer, column_2:integer, column_3:integer | 0 | 110 |
| `contacts_getallnumber` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:integer | 0 | 112 |
| `contacts_getallsns` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 113 |
| `contacts_getalluser` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20), column_15:integer, column_16:character varying(250) | 0 | 111 |
| `contacts_getallusernotrequite` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20), column_15:integer, column_16:character varying(250) | 0 | 111 |
| `contacts_getbackupinfo` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(1000), column_8:integer | 0 | 111 |
| `contacts_getbackupinfoonce` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(1000), column_8:integer | 0 | 112 |
| `contacts_getcheckgroup` | `0::integer, 0::integer` | column_1:character | 0 | 116 |
| `contacts_getcontactgroup` | `0::integer, ''::character varying` | id:integer, jsonname:text, parentno:integer, sharenumber:integer, name:text | 0 | 137 |
| `contacts_getcontactsforoutlook` | `0::integer` | column_1:character varying, column_2:character varying, column_3:integer, column_4:text, column_5:integer, column_6:character varying(100), column_7:character varying(100), column_8:integer, column_9:character varying, column_10:character varying, column_11:character varying, column_12:character varying, column_13:character varying, column_14:character varying, column_15:character varying, column_16:character varying, column_17:character varying, column_18:character varying, column_19:text, column_20:character varying, column_21:character varying, column_22:character varying, column_23:text, column_24:character varying, column_25:character varying, column_26:text, column_27:character varying, column_28:character varying(500) | 0 | 154 |
| `contacts_getcontactsgroup` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:character | 0 | 111 |
| `contacts_getdefaultcategory` | `0::integer` | column_1:integer | 0 | 113 |
| `contacts_getdepartallowaccess` | `''::character varying, ''::character varying` | allowaccessno:integer, departno:integer, allowvalue:integer, itemno:integer, departname:character varying, isadmin:boolean, isread:boolean, iswrite:boolean, disableadmin:boolean, disablewrite:boolean, disableread:boolean | 0 | 112 |
| `contacts_getdupelist` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(50), column_6:integer, column_7:character varying(50), column_8:bigint, column_9:bigint | 0 | 113 |
| `contacts_getgroupbyseq` | `0::integer, ''::character varying` | groupno:integer, name:text | 0 | 113 |
| `contacts_getgroupinfo` | `0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:integer | 0 | 115 |
| `contacts_getgrouplist` | `0::integer` | column_1:integer, column_2:text, column_3:character varying(500), column_4:integer, column_5:integer, column_6:character | 0 | 111 |
| `contacts_gethistorylist` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, CURRENT_DATE, CURRENT_DATE` | rownum:bigint, historyno:integer, seq:integer, firstname:character varying, lastname:character varying, memo:character varying, moddate:timestamp without time zone | 0 | 121 |
| `contacts_gethistorylistcount` | `0::integer, 0::integer, 0::integer, CURRENT_DATE, CURRENT_DATE` | cnt:integer | 1 | 111 |
| `contacts_getlatitudeandlongitudecontacts` | `0::integer` | column_1:integer, column_2:double precision, column_3:double precision, column_4:character varying(100), column_5:character varying(100), column_6:character varying(500) | 0 | 112 |
| `contacts_getlatitudeandlongitudeonecontacts` | `0::integer` | column_1:integer, column_2:double precision, column_3:double precision, column_4:character varying(100), column_5:character varying(100), column_6:character varying(500) | 0 | 115 |
| `contacts_getlikelist` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(50), column_6:integer, column_7:character varying(50), column_8:bigint, column_9:bigint | 0 | 113 |
| `contacts_getlistgroup` | `0::integer` | column_1:integer, column_2:integer, column_3:integer | 0 | 111 |
| `contacts_getlistgroupwithid` | `0::integer` | column_1:integer, column_2:character varying(250), column_3:timestamp without time zone, column_4:timestamp without time zone | 0 | 111 |
| `contacts_getlocationonecontact` | `0::integer, 0::integer` | column_1:integer, column_2:integer, column_3:character varying(100), column_4:double precision, column_5:double precision, column_6:character varying(500), column_7:integer | 0 | 111 |
| `contacts_getlocations` | `0::integer` | column_1:integer, column_2:integer, column_3:timestamp without time zone, column_4:integer, column_5:timestamp without time zone, column_6:character varying(100), column_7:double precision, column_8:double precision, column_9:integer, column_10:character varying(500) | 0 | 115 |
| `contacts_getnamegroup` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:text | 0 | 114 |
| `contacts_getoneaddress` | `0::integer` | column_1:character varying(500) | 0 | 111 |
| `contacts_getoutlistcount` | `0::integer, ''::character varying` | cnt:integer | 1 | 116 |
| `contacts_getprivateboxcount` | `0::integer` | column_1:integer | 1 | 112 |
| `contacts_getpublicboxcount` | `0::integer` | column_1:integer | 1 | 117 |
| `contacts_getpublicgroup` | `''::character varying` | id:integer, jsonname:text, name:text, parentno:integer, sharenumber:integer | 0 | 112 |
| `contacts_getranklist` | `0::integer` | column_1:bigint, column_2:integer, column_3:character varying(100), column_4:character varying(100), column_5:character varying(500), column_6:integer | 0 | 116 |
| `contacts_getranklistcount` | `0::integer` | column_1:integer | 1 | 111 |
| `contacts_getsetup` | `0::integer` | column_1:integer, column_2:timestamp without time zone, column_3:integer, column_4:timestamp without time zone, column_5:integer, column_6:integer, column_7:bigint, column_8:boolean | 0 | 114 |
| `contacts_getsharedepartmentdefault` | `0::integer, ''::character varying` | departno:integer, name:character varying | 0 | 114 |
| `contacts_getsharegroupsetting` | `''::character varying` | id:integer, jsonname:text, name:text, parentno:integer | 0 | 111 |
| `contacts_getsharers` | `0::integer` | column_1:integer, column_2:integer, column_3:character varying(100), column_4:character | 0 | 120 |
| `contacts_gettopcategory` | `0::integer` | column_1:bigint, column_2:integer, column_3:text | 0 | 111 |
| `contacts_gettrashcount` | `0::integer` | column_1:integer | 1 | 110 |
| `contacts_getuser_address` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(5), column_7:character varying(5), column_8:character varying(500), column_9:character, column_10:timestamp without time zone, column_11:timestamp without time zone | 0 | 121 |
| `contacts_getuser_company` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 113 |
| `contacts_getuser_days` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:character, column_9:timestamp without time zone, column_10:timestamp without time zone | 0 | 112 |
| `contacts_getuser_email` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character, column_6:timestamp without time zone, column_7:timestamp without time zone | 0 | 113 |
| `contacts_getuser_groupinfo` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:character | 0 | 112 |
| `contacts_getuser_homepage` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 115 |
| `contacts_getuser_noname` | `0::integer, 0::integer, 0::integer` | totalcnt:integer, rownum:integer, seq:integer, firstname:character varying, lastname:character varying, reguserno:integer, memo:character varying, regdate:timestamp without time zone, photo:character varying, moddate:timestamp without time zone, checkdate:timestamp without time zone, share:character varying, useyn:character varying, deldate:timestamp without time zone, important:integer, callname:character varying | 0 | 114 |
| `contacts_getuser_number` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 111 |
| `contacts_getuser_phoneinfo` | `0::integer` | column_1:character varying(100) | 0 | 111 |
| `contacts_getuser_sns` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 114 |
| `contacts_getuser_touserno` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20) | 0 | 138 |
| `contacts_getusergroupbylanguage` | `0::integer, ''::character varying` | groupno:integer, groupname:text, reguserno:integer, regdate:timestamp without time zone, memo:character varying, parentgno:integer, sort:integer, isdefault:character, usercount:integer, useyn:character | 0 | 146 |
| `contacts_getusergroupbyuserno` | `0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:integer, column_10:character | 0 | 150 |
| `contacts_getusergroupmobi` | `0::integer, 0::integer, 0::integer, 0::integer` | rownum:bigint, userseq:integer, counts:integer | 0 | 149 |
| `contacts_insertbackupinfo` | `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying` | column_1:integer | 1 | 160 |
| `contacts_insertcontactforoutlookentryid` | `0::integer, 0::integer, ''::character varying` | contacts_insertcontactforoutlookentryid:record | 0 | 151 |
| `contacts_insertcontactforoutlookfolderentryid` | `0::integer, 0::integer, ''::character varying` | contacts_insertcontactforoutlookfolderentryid:record | 0 | 153 |
| `contacts_insertlistgroup` | `0::integer, ''::character varying` | column_1:integer | 1 | 152 |
| `contacts_insertlistgroupcontact` | `0::integer, 0::integer` | contacts_insertlistgroupcontact:void | 1 | 153 |
| `contacts_insertuser` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_insertuser:void | 1 | 149 |
| `contacts_listgroupcontent` | `0::integer` | column_1:character varying(250) | 0 | 114 |
| `contacts_moveallcontact` | `0::integer, 0::integer, 0::integer` | contacts_moveallcontact:void | 1 | 114 |
| `contacts_movecontactgroup` | `0::integer, 0::integer, 0::integer, 0::integer` | contacts_movecontactgroup:void | 1 | 115 |
| `contacts_moveuser` | `0::integer, 0::integer, 0::integer, 0::integer` | contacts_moveuser:void | 1 | 113 |
| `contacts_parentgroupno` | `0::integer, 0::integer` | column_1:integer | 0 | 113 |
| `contacts_restorecontactlist` | `0::integer, ''::character varying` | contacts_restorecontactlist:void | 1 | 111 |
| `contacts_saveaddressinfo_web` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, 0::integer, 0::integer` | column_1:integer | 1 | 174 |
| `contacts_savearrange` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_savearrange:record | 0 | 113 |
| `contacts_savearrangelike` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_savearrangelike:record | 0 | 125 |
| `contacts_savecontactsforoutlook` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_savecontactsforoutlook:record | 0 | 126 |
| `contacts_savecontactshistory` | `0::integer, 0::integer, ''::character varying` | contacts_savecontactshistory:record | 0 | 118 |
| `contacts_savegroupforoutlook` | `0::integer, ''::character varying, ''::character varying` | contacts_savegroupforoutlook:record | 0 | 122 |
| `contacts_savelocation` | `0::integer, ''::character varying, 0::double precision, 0::double precision, 0::integer, ''::character varying, 0::integer, 0::integer` | contacts_savelocation:void | 1 | 112 |
| `contacts_saverestore` | `''::character varying` | contacts_saverestore:record | 0 | 144 |
| `contacts_savesetup` | `0::integer, 0::integer, 0::bigint, false` | contacts_savesetup:record | 0 | 114 |
| `contacts_search_nodistance` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_search_nodistance:record | 0 | 111 |
| `contacts_seqtoname` | `0::integer, 0::integer` | column_1:text | 0 | 111 |
| `contacts_setaddress` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setaddress:void | 1 | 111 |
| `contacts_setcallphone` | `0::integer` | contacts_setcallphone:void | 1 | 111 |
| `contacts_setcompany` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setcompany:void | 1 | 121 |
| `contacts_setcontactsgroup` | `0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying` | contacts_setcontactsgroup:record | 0 | 111 |
| `contacts_setcontactstrash` | `0::integer, 0::integer` | contacts_setcontactstrash:void | 1 | 119 |
| `contacts_setdays` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setdays:void | 1 | 114 |
| `contacts_setemail` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setemail:void | 1 | 111 |
| `contacts_setmovecontacts` | `0::integer, 0::integer, 0::integer` | contacts_setmovecontacts:void | 1 | 117 |
| `contacts_setnumber` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying` | contacts_setnumber:void | 1 | 122 |
| `contacts_setsns` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setsns:void | 1 | 114 |
| `contacts_setusercheckdate` | `0::integer, 0::integer` | contacts_setusercheckdate:void | 1 | 112 |
| `contacts_updatecontactgroupuser` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 123 |
| `contacts_updatecontactimportant` | `0::integer, 0::integer` | contacts_updatecontactimportant:void | 1 | 119 |
| `contacts_updatecontactsuser` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_updatecontactsuser:void | 1 | 117 |
| `contacts_updatedepartallowaccess` | `0::integer, 0::integer, 0::integer, 0::integer` | contacts_updatedepartallowaccess:void | 1 | 121 |
| `contacts_updategroup` | `0::integer, 0::integer, ''::character varying` | contacts_updategroup:void | 1 | 114 |
| `contacts_updategroupmemo` | `0::integer, 0::integer, ''::character varying` | contacts_updategroupmemo:void | 1 | 111 |
| `contacts_updategroupparent` | `0::integer, 0::integer` | contacts_updategroupparent:void | 1 | 111 |
| `contacts_updategroupstate` | `0::integer, ''::character varying` | contacts_updategroupstate:void | 1 | 111 |
| `contacts_updatelistgroup` | `0::integer, 0::integer, 0::integer, ''::character varying` | contacts_updatelistgroup:void | 1 | 111 |
| `contacts_updatelistgroupcontact` | `0::integer, ''::character varying` | contacts_updatelistgroupcontact:void | 1 | 111 |
| `contacts_updatepublicgroup` | `0::integer, ''::character varying, 0::integer` | column_1:integer | 1 | 112 |
| `contacts_updatepublicgroupuser` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 114 |
| `contacts_updatesharegroup` | `0::integer, ''::character varying, 0::integer` | column_1:integer | 1 | 111 |
| `contacts_updatesharegroupuser` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 113 |
| `contacts_updatesortdownofgroup` | `0::integer, 0::integer, 0::integer` | contacts_updatesortdownofgroup:void | 1 | 117 |
| `contacts_updatesortupofgroup` | `0::integer, 0::integer, 0::integer` | contacts_updatesortupofgroup:void | 1 | 118 |
| `contacts_updateuserinfo` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, 0::integer, 0::integer` | column_1:integer | 1 | 145 |
| `contacts_updateuserstate` | `0::integer, ''::character varying` | contacts_updateuserstate:void | 1 | 111 |
| `contacts_uppublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_uppublicgroup:void | 1 | 123 |
| `contacts_upsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_upsharegroup:void | 1 | 112 |
| `contactsaddress_insertaddresslocation` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, 0::integer` | contactsaddress_insertaddresslocation:void | 1 | 114 |
