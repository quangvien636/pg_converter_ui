# Runtime pass list

| Procedure | Input | Result columns | Rows observed | Time ms |
|---|---|---|---:|---:|
| `board_insertboard` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false, 0::integer` | board_insertboard:void | 1 | 116 |
| `board_setfolders` | `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false` | board_setfolders:record | 0 | 109 |
| `contacts_delcontactsuser` | `0::integer, 0::integer, ''::character varying` | contacts_delcontactsuser:void | 1 | 108 |
| `contacts_deletecontact` | `0::integer` | contacts_deletecontact:void | 1 | 113 |
| `contacts_deletehistory` | `''::character varying` | contacts_deletehistory:void | 1 | 109 |
| `contacts_downpublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_downpublicgroup:void | 1 | 109 |
| `contacts_downsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_downsharegroup:void | 1 | 108 |
| `contacts_finall` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_finall:record | 0 | 109 |
| `contacts_findnonameuser` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_findnonameuser:record | 0 | 113 |
| `contacts_insertlistgroupcontact` | `0::integer, 0::integer` | contacts_insertlistgroupcontact:void | 1 | 108 |
| `contacts_insertuser` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_insertuser:void | 1 | 113 |
| `contacts_savelocation` | `0::integer, ''::character varying, 0::double precision, 0::double precision, 0::integer, ''::character varying, 0::integer, 0::integer` | contacts_savelocation:void | 1 | 109 |
| `contacts_search_nodistance` | `0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying` | contacts_search_nodistance:record | 0 | 123 |
| `contacts_setaddress` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setaddress:void | 1 | 108 |
| `contacts_setcompany` | `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setcompany:void | 1 | 109 |
| `contacts_setdays` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying, ''::character varying` | contacts_setdays:void | 1 | 109 |
| `contacts_setemail` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setemail:void | 1 | 108 |
| `contacts_setnumber` | `0::integer, 0::integer, 0::smallint, ''::character varying, ''::character varying, ''::character varying` | contacts_setnumber:void | 1 | 108 |
| `contacts_setsns` | `0::integer, 0::integer, ''::character varying, ''::character varying` | contacts_setsns:void | 1 | 108 |
| `contacts_updategroupparent` | `0::integer, 0::integer` | contacts_updategroupparent:void | 1 | 108 |
| `contacts_updatelistgroupcontact` | `0::integer, ''::character varying` | contacts_updatelistgroupcontact:void | 1 | 108 |
| `contacts_updateuserstate` | `0::integer, ''::character varying` | contacts_updateuserstate:void | 1 | 108 |
| `contacts_uppublicgroup` | `0::integer, 0::integer, 0::integer` | contacts_uppublicgroup:void | 1 | 109 |
| `contacts_upsharegroup` | `0::integer, 0::integer, 0::integer` | contacts_upsharegroup:void | 1 | 109 |
