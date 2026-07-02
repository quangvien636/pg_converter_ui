# Runtime pass list

| Procedure | Input | Result columns | Rows observed | Time ms |
|---|---|---|---:|---:|
| `board_board_maxsortno_select` | `0::integer` | column_1:integer | 1 | 112 |
| `board_countboardinfolder` | `0::integer` | column_1:bigint | 1 | 111 |
| `board_countcontentinboard` | `0::integer` | column_1:bigint | 1 | 111 |
| `board_countfolderinfolder` | `0::integer` | column_1:bigint | 1 | 111 |
| `board_folder_maxsortno_select` | `0::integer` | column_1:integer | 1 | 113 |
| `board_getcommentsetting` | `0::integer` | column_1:bigint | 1 | 111 |
| `board_getlistconverturlfile` | `` | column_1:bigint, column_2:bigint, column_3:character varying(260), column_4:integer, column_5:text, column_6:integer | 0 | 111 |
| `board_getreplyfilebycontentno` | `0::bigint` | column_1:bigint, column_2:bigint, column_3:character varying(260), column_4:integer, column_5:text | 0 | 119 |
| `board_getusersetting` | `0::integer` | column_1:integer, column_2:integer, column_3:integer | 0 | 117 |
| `board_insertboard` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false, 0::integer` | board_insertboard:void | 1 | 123 |
| `board_insertdepartallowaccess` | `0::integer, 0::integer, 0::integer, 0::integer, 0::integer` | column_1:bigint | 1 | 133 |
| `board_insertusersetting` | `0::integer, 0::integer, 0::integer` | column_1:integer | 1 | 117 |
| `board_setfolders` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false` | board_setfolders:record | 0 | 113 |
| `contacts_checkexitgroupandcontact` | `0::integer, 0::integer, 0::integer` | column_1:bigint | 1 | 112 |
| `contacts_countgroupcountchild` | `0::integer, 0::integer` | column_1:bigint | 1 | 111 |
| `contacts_countgroupuser` | `0::integer` | column_1:bigint | 1 | 111 |
| `contacts_countuserpublicwithoutgroup` | `` | column_1:bigint | 1 | 119 |
| `contacts_delcontactsuser` | `0::integer, 0::integer, ''::character varying` | contacts_delcontactsuser:void | 1 | 112 |
| `contacts_deletecontact` | `0::integer` | contacts_deletecontact:void | 1 | 112 |
| `contacts_deletehistory` | `''::character varying` | contacts_deletehistory:void | 1 | 112 |
| `contacts_deletepublicgroup` | `0::integer, 0::integer` | column_1:integer | 1 | 112 |
| `contacts_deletesharegroup` | `0::integer, 0::integer` | column_1:integer | 1 | 112 |
| `contacts_downpublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_downpublicgroup:void | 1 | 120 |
| `contacts_downsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_downsharegroup:void | 1 | 112 |
| `contacts_finall` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_finall:record | 0 | 112 |
| `contacts_findnonameuser` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_findnonameuser:record | 0 | 116 |
| `contacts_getalladdress` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(5), column_7:character varying(5), column_8:character varying(500), column_9:character, column_10:timestamp without time zone, column_11:timestamp without time zone, column_12:double precision, column_13:double precision | 0 | 112 |
| `contacts_getallcompany` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 114 |
| `contacts_getalldays` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:character, column_9:timestamp without time zone, column_10:timestamp without time zone | 0 | 125 |
| `contacts_getallemail` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:character varying(50), column_5:character, column_6:timestamp without time zone, column_7:timestamp without time zone | 0 | 112 |
| `contacts_getallgroupuser` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:integer, column_5:timestamp without time zone, column_6:timestamp without time zone | 0 | 111 |
| `contacts_getallhomepage` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 113 |
| `contacts_getallnumber` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(50), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:integer | 0 | 112 |
| `contacts_getallsns` | `0::integer` | column_1:integer, column_2:integer, column_3:integer, column_4:smallint, column_5:character varying(50), column_6:character varying(500), column_7:character, column_8:timestamp without time zone, column_9:timestamp without time zone | 0 | 111 |
| `contacts_getalluser` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20), column_15:integer, column_16:character varying(250) | 0 | 112 |
| `contacts_getallusernotrequite` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20), column_15:integer, column_16:character varying(250) | 0 | 114 |
| `contacts_getcheckgroup` | `0::integer, 0::integer` | column_1:character | 0 | 111 |
| `contacts_getcontactsforoutlook` | `0::integer` | column_1:character varying, column_2:character varying, column_3:integer, column_4:text, column_5:integer, column_6:character varying(100), column_7:character varying(100), column_8:integer, column_9:character varying, column_10:character varying, column_11:character varying, column_12:character varying, column_13:character varying, column_14:character varying, column_15:character varying, column_16:character varying, column_17:character varying, column_18:character varying, column_19:text, column_20:character varying, column_21:character varying, column_22:character varying, column_23:text, column_24:character varying, column_25:character varying, column_26:text, column_27:character varying, column_28:character varying(500) | 0 | 118 |
| `contacts_getcontactsgroup` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:character | 0 | 112 |
| `contacts_getdefaultcategory` | `0::integer` | column_1:integer | 0 | 111 |
| `contacts_getdupelist` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(50), column_6:integer, column_7:character varying(50), column_8:bigint, column_9:bigint | 0 | 113 |
| `contacts_getgrouplist` | `0::integer` | column_1:integer, column_2:text, column_3:character varying(500), column_4:integer, column_5:integer, column_6:character | 0 | 112 |
| `contacts_getlatitudeandlongitudecontacts` | `0::integer` | column_1:integer, column_2:double precision, column_3:double precision, column_4:character varying(100), column_5:character varying(100), column_6:character varying(500) | 0 | 113 |
| `contacts_getlatitudeandlongitudeonecontacts` | `0::integer` | column_1:integer, column_2:double precision, column_3:double precision, column_4:character varying(100), column_5:character varying(100), column_6:character varying(500) | 0 | 112 |
| `contacts_getlikelist` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(50), column_6:integer, column_7:character varying(50), column_8:bigint, column_9:bigint | 0 | 113 |
| `contacts_getlistgroup` | `0::integer` | column_1:integer, column_2:integer, column_3:integer | 0 | 113 |
| `contacts_getlistgroupwithid` | `0::integer` | column_1:integer, column_2:character varying(250), column_3:timestamp without time zone, column_4:timestamp without time zone | 0 | 114 |
| `contacts_getlocationonecontact` | `0::integer, 0::integer` | column_1:integer, column_2:integer, column_3:character varying(100), column_4:double precision, column_5:double precision, column_6:character varying(500), column_7:integer | 0 | 111 |
| `contacts_getnamegroup` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:text | 0 | 111 |
| `contacts_getoneaddress` | `0::integer` | column_1:character varying(500) | 0 | 111 |
| `contacts_getprivateboxcount` | `0::integer` | column_1:bigint | 1 | 112 |
| `contacts_getpublicboxcount` | `0::integer` | column_1:bigint | 1 | 113 |
| `contacts_getranklist` | `0::integer` | column_1:bigint, column_2:integer, column_3:character varying(100), column_4:character varying(100), column_5:character varying(500), column_6:integer | 0 | 112 |
| `contacts_getranklistcount` | `0::integer` | column_1:bigint | 1 | 114 |
| `contacts_gettrashcount` | `0::integer` | column_1:bigint | 1 | 111 |
| `contacts_getuser_groupinfo` | `0::integer, 0::integer` | column_1:integer, column_2:text, column_3:integer, column_4:timestamp without time zone, column_5:character varying(500), column_6:integer, column_7:integer, column_8:character, column_9:character | 0 | 111 |
| `contacts_getuser_touserno` | `0::integer` | column_1:integer, column_2:character varying(100), column_3:character varying(100), column_4:integer, column_5:character varying(500), column_6:timestamp without time zone, column_7:character varying(500), column_8:timestamp without time zone, column_9:timestamp without time zone, column_10:character varying(50), column_11:character varying(1), column_12:timestamp without time zone, column_13:integer, column_14:character varying(20) | 0 | 111 |
| `contacts_insertlistgroupcontact` | `0::integer, 0::integer` | contacts_insertlistgroupcontact:void | 1 | 111 |
| `contacts_insertuser` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_insertuser:void | 1 | 115 |
| `contacts_listgroupcontent` | `0::integer` | column_1:character varying(250) | 0 | 111 |
| `contacts_parentgroupno` | `0::integer, 0::integer` | column_1:integer | 0 | 111 |
| `contacts_saveaddressinfo_web` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, 0::integer, 0::integer` | column_1:integer | 1 | 145 |
| `contacts_savearrange` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_savearrange:record | 0 | 120 |
| `contacts_savearrangelike` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_savearrangelike:record | 0 | 115 |
| `contacts_savelocation` | `0::integer, ''::character varying, 0::double precision, 0::double precision, 0::integer, ''::character varying, 0::integer, 0::integer` | contacts_savelocation:void | 1 | 112 |
| `contacts_saverestore` | `''::character varying` | contacts_saverestore:record | 0 | 112 |
| `contacts_search_nodistance` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_search_nodistance:record | 0 | 112 |
| `contacts_seqtoname` | `0::integer, 0::integer` | column_1:text | 0 | 111 |
| `contacts_setaddress` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setaddress:void | 1 | 111 |
| `contacts_setcompany` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setcompany:void | 1 | 111 |
| `contacts_setdays` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setdays:void | 1 | 130 |
| `contacts_setemail` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setemail:void | 1 | 144 |
| `contacts_setnumber` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying` | contacts_setnumber:void | 1 | 111 |
| `contacts_setsns` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setsns:void | 1 | 112 |
| `contacts_updategroupparent` | `0::integer, 0::integer` | contacts_updategroupparent:void | 1 | 113 |
| `contacts_updatelistgroupcontact` | `0::integer, ''::character varying` | contacts_updatelistgroupcontact:void | 1 | 111 |
| `contacts_updatepublicgroup` | `0::integer, ''::character varying, 0::integer` | column_1:integer | 1 | 111 |
| `contacts_updatesharegroup` | `0::integer, ''::character varying, 0::integer` | column_1:integer | 1 | 111 |
| `contacts_updateuserinfo` | `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, 0::integer, 0::integer` | column_1:integer | 1 | 143 |
| `contacts_updateuserstate` | `0::integer, ''::character varying` | contacts_updateuserstate:void | 1 | 111 |
| `contacts_uppublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_uppublicgroup:void | 1 | 112 |
| `contacts_upsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_upsharegroup:void | 1 | 112 |
