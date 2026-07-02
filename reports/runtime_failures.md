# Runtime failures

## `board_authority_select`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_authority_select"(0::integer);`
- SQLSTATE: `42P01`
- Error: relation "organization_departments" does not exist
- Stack context: PL/pgSQL function board_authority_select(integer) line 21 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_authority_select(user_no integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    rowindex integer;
    maxindex integer;
    departno integer;
    parentno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		CREATE TEMP TABLE ListOfDepartNos (
			DepartNo	INT
		) ON COMMIT DROP;

		CREATE TEMP TABLE BelongToDepartments (
			RowNum		serial,
			DepartNo	INT,
			ParentNo	INT
		) ON COMMIT DROP;

		INSERT INTO BelongToDepartments
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = board_authority_select.user_no
		);


		RowIndex := 1;
		MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);
		WHILE RowIndex <= MaxIndex LOOP

			SELECT DepartNo, ParentNo INTO departno, parentno FROM BelongToDepartments

			WHERE RowNum = RowIndex;

			INSERT INTO ListOfDepartNos
			SELECT DepartNo;

			WHILE ParentNo != 0 LOOP

				SELECT DepartNo, ParentNo INTO departno, parentno FROM Organization_Departments
				WHERE DepartNo = ParentNo;

				INSERT INTO ListOfDepartNos
				SELECT DepartNo;

			END LOOP;

			RowIndex := RowIndex + 1;
		END LOOP;

RETURN QUERY
SELECT  bu.USERGROUP_ID AS "Id",
		bu.USER_NO AS "UserNo",
		CASE
		  WHEN bu.USER_NO >0  THEN ou.Name
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Name" ,
		ou.ModUserNo,
		(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   (Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority,
		bu.DEPARTMENT_ID AS "DepartmentId"

   --ou.UserNo,
   --ou.Name,
   --ou.ModUserNo,
   --(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   --(Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority
  FROM
  Board_UserByGroup bu LEFT JOIN
	  Organization_Users ou
	  on ou.UserNo = bu.USER_NO inner join Board_AuthoGroup ag on bu.AUTH_GRP_ID=ag.AUTH_GRP_ID

	  LEFT JOIN Organization_Departments od on od.DepartNo=bu.DEPARTMENT_ID
  where (UserNo=board_authority_select.user_no OR DEPARTMENT_ID IN (SELECT DepartNo FROM ListOfDepartNos)) and MENU_ID=(Select MENU_IDX From Board_Menu Where MENU_ID='MAIN')
  AND NOT (bu.USER_NO >0 AND ou.UserNo Is null)
  ORDER BY ag.AUTH_GRP_ID ASC;
END;
$function$

```
</details>

## `board_convertboard`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_convertboard"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_convertboard(integer,integer) line 3 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_convertboard(boardno integer, viewmode integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
UPDATE Board_Boards SET ViewMode = board_convertboard.viewmode WHERE BoardNo= board_convertboard.boardno;
END;
$function$

```
</details>

## `board_deletecommentsetting`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_deletecommentsetting"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_deletecommentsetting(integer,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletecommentsetting(userno integer, boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_CommentSetting SET IsDelete= TRUE,ModUserNo=board_deletecommentsetting.userno,ModDate=NOW() WHERE BoardNo = board_deletecommentsetting.boardno;
END;
$function$

```
</details>

## `board_deletecurrentmanager`

- Input: `''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_deletecurrentmanager"(''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: function public.fn_split_array(character varying, character varying) does not exist
- Stack context: PL/pgSQL function board_deletecurrentmanager(character varying,character varying) line 4 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletecurrentmanager(usernos character varying, delimiter character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	DELETE FROM Board_UserByGroup WHERE USERGROUP_ID IN (SELECT Items FROM public."fn_split_array"(UserNos,Delimiter));
END;
$function$

```
</details>

## `board_deletedepartallowaccess`

- Input: `''::character varying`
- Generated SQL: `SELECT "public"."board_deletedepartallowaccess"(''::character varying);`
- SQLSTATE: `42883`
- Error: function splitstring(character varying, unknown) does not exist
- Stack context: PL/pgSQL function board_deletedepartallowaccess(character varying) line 9 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletedepartallowaccess(listallowaccessno character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    departno integer;
    itemno integer;
    itemtype integer;
BEGIN


	CREATE TEMP TABLE Board_DepartAllowAccess ON COMMIT DROP AS SELECT * FROM Board_DepartAllowAccess
	WHERE AllowAccessNo IN(SELECT * FROM SplitString(ListAllowAccessNo,','));




	WHILE (Select Count(*) From Board_DepartAllowAccess) > 0 LOOP
		SELECT DA.DepartNo, DA.ItemNo, DA.ItemType INTO departno, itemno, itemtype FROM Board_DepartAllowAccess DA;
		IF ItemType=2 THEN
			DELETE FROM Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo;
		ELSE
			CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =ItemNo
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
			)SELECT * FROM FolderNos;
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=1 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT FolderNo FROM FolderTemp);
			DELETE FROM Board_DepartAllowAccess WHERE ItemType=2 AND DepartNo=DepartNo AND
			ItemNo IN (SELECT BB.BoardNo FROM Board_Boards BB INNER JOIN FolderTemp BF ON BF.FolderNo=bb.FolderNo);
			DROP TABLE IF EXISTS FolderTemp;
		END IF;
		DELETE FROM Board_DepartAllowAccess WHERE ItemNo=ItemNo AND ItemType=ItemType AND DepartNo=DepartNo;
	END LOOP;
	DROP TABLE IF EXISTS Board_DepartAllowAccess;
END;
$function$

```
</details>

## `board_deletefile`

- Input: `0::bigint`
- Generated SQL: `SELECT "public"."board_deletefile"(0::bigint);`
- SQLSTATE: `42702`
- Error: column reference "fileno" is ambiguous
- Stack context: PL/pgSQL function board_deletefile(bigint) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletefile(fileno bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE FileNo = board_deletefile.fileno;
END;
$function$

```
</details>

## `board_deletefilebycontent`

- Input: `0::bigint`
- Generated SQL: `SELECT "public"."board_deletefilebycontent"(0::bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_deletefilebycontent(bigint) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletefilebycontent(contentno bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	DELETE FROM Board_Files WHERE ContentNo = board_deletefilebycontent.contentno;
END;
$function$

```
</details>

## `board_deleteiosdevice`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_deleteiosdevice"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_deleteiosdevice(integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deleteiosdevice(userno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	DELETE FROM Board_IOSDevices WHERE UserNo = board_deleteiosdevice.userno;
END;
$function$

```
</details>

## `board_deletemultiboardwidget`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_deletemultiboardwidget"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_deletemultiboardwidget(integer,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletemultiboardwidget(userno integer, boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_MultiBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletemultiboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletemultiboardwidget.boardno; --AND Type=Type
END;
$function$

```
</details>

## `board_deletenewboardwidget`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_deletenewboardwidget"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_deletenewboardwidget(integer,integer,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletenewboardwidget(userno integer, boardno integer, type integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_NewBoardWidget SET IsDelete= TRUE,ModUserNo=board_deletenewboardwidget.userno,ModDate=NOW() WHERE BoardNo = board_deletenewboardwidget.boardno; --AND Type=Type
END;
$function$

```
</details>

## `board_deletenotificationservice`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."board_deletenotificationservice"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42P01`
- Error: relation "center_notificationservice" does not exist
- Stack context: PL/pgSQL function board_deletenotificationservice(integer,character varying,integer) line 11 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletenotificationservice(companyno integer, projectcode character varying, connectionkey integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    notificationno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID;
	SELECT NotificationNo INTO notificationno FROM Center_NotificationService where CompanyNo = board_deletenotificationservice.companyno and ProjectCode = board_deletenotificationservice.projectcode and Connectionkey = board_deletenotificationservice.connectionkey;

	--DELETE FROM detail;
	DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo = NotificationNo;

	--DELETE FROM main;
	DELETE FROM Center_NotificationService where NotificationNo = NotificationNo;
END;
$function$

```
</details>

## `board_deletereply`

- Input: `0::bigint`
- Generated SQL: `SELECT "public"."board_deletereply"(0::bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_deletereply(bigint) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deletereply(replyno bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    contentno bigint;
    orderno integer;
BEGIN




	SELECT ContentNo, OrderNo INTO contentno, orderno FROM Board_Replies

	WHERE ReplyNo = board_deletereply.replyno;

	UPDATE Board_Replies SET OrderNo = OrderNo - 1
	WHERE ContentNo = ContentNo AND OrderNo > OrderNo;

	DELETE FROM Board_Replies WHERE ReplyNo = board_deletereply.replyno;

	UPDATE Board_Contents SET ReplyCount = ReplyCount -1
	WHERE ContentNo = ContentNo;
END;
$function$

```
</details>

## `board_deleteshare`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_deleteshare"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_deleteshare(integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_deleteshare(contentno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

DELETE FROM Board_Sharers WHERE ContentNo = board_deleteshare.contentno;
END;
$function$

```
</details>

## `board_downboard`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_downboard"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "sortno" is ambiguous
- Stack context: PL/pgSQL function board_downboard(integer) line 12 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downboard(boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN




SELECT FolderNo, SortNo INTO parentno, sortno FROM Board_Boards where BoardNo= board_downboard.boardno;
RANKTEMPNO := 1;
FOR tempno IN SELECT  BoardNo from Board_Boards WHERE PARENTNO=FolderNo AND Enabled = TRUE ORDER BY SortNo ASC,BoardNo ASC LOOP
		UPDATE Board_Boards SET SortNo = RANKTEMPNO WHERE TEMPNO=board_downboard.boardno;

		IF TEMPNO=board_downboard.boardno THEN
			SORTNO := RANKTEMPNO;
		END IF;
		RANKTEMPNO := RANKTEMPNO+1;
		   END LOOP;
UPDATE Board_Boards SET SortNo = SORTNO WHERE SORTNO = SortNo - 1 AND FolderNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Boards SET SortNo = SORTNO + 1 WHERE BoardNo= board_downboard.boardno;
END;
$function$

```
</details>

## `board_downboardbyuser`

- Input: `0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_downboardbyuser"(0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_downboardbyuser(integer,integer,boolean) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downboardbyuser(boardno integer DEFAULT 1093, userno integer DEFAULT 70, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    curentno integer;
    parentno integer;
    upno integer;
    isboard boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, FolderNo INTO curentno, parentno FROM Board_Boards WHERE  BoardNo = board_downboardbyuser.boardno;

SELECT T.SortNo, T.IsBoard INTO upno, isboard FROM (
SELECT BoardNo AS No, SortNo,TRUE AS IsBoard FROM Board_Boards B
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_downboardbyuser.userno
WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo<CurentNo AND ParentNo=B.FolderNo
UNION ALL
SELECT BF.FolderNo AS No, SortNo,FALSE AS IsBoard
FROM  Board_Folders BF
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_downboardbyuser.userno
WHERE  BF.SortNo<CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
ORDER BY SortNo DESC) T ORDER BY T.SortNo DESC;











--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF UpNo >0 AND IsBoard= TRUE THEN
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Boards SET SortNo=UpNo WHERE BoardNo = board_downboardbyuser.boardno ;
IF UpNo >0 AND IsBoard= FALSE THEN
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Boards SET SortNo=UpNo WHERE BoardNo = board_downboardbyuser.boardno ;

END IF;
END IF;
END;
$function$

```
</details>

## `board_downfolder`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_downfolder"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "parentno" is ambiguous
- Stack context: PL/pgSQL function board_downfolder(integer) line 12 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downfolder(folderno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    foldertempno integer;
    ranktempno integer;
BEGIN




SELECT ParentNo, SortNo INTO parentno, sortno FROM Board_Folders where FolderNo= board_downfolder.folderno;
RANKTEMPNO := 1;
FOR foldertempno IN SELECT FolderNo from Board_Folders WHERE PARENTNO=ParentNo AND Enabled = TRUE ORDER BY SortNo ASC, FolderNo ASC LOOP
		UPDATE Board_Folders SET SortNo = RANKTEMPNO WHERE FOLDERTEMPNO=board_downfolder.folderno;

		IF FOLDERTEMPNO=board_downfolder.folderno THEN
			SORTNO := RANKTEMPNO;
		END IF;

		RANKTEMPNO := RANKTEMPNO + 1;
		   END LOOP;
UPDATE Board_Folders SET SortNo = SORTNO WHERE SORTNO = SortNo - 1 AND ParentNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Folders SET SortNo = SORTNO+1 WHERE FolderNo = board_downfolder.folderno;
END;
$function$

```
</details>

## `board_downfolderbyuser`

- Input: `0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_downfolderbyuser"(0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "parentno" is ambiguous
- Stack context: PL/pgSQL function board_downfolderbyuser(integer,integer,boolean) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downfolderbyuser(folderno integer, userno integer DEFAULT 70, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    curentno integer;
    parentno integer;
    upno integer;
    isfolder boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, ParentNo INTO curentno, parentno FROM Board_Folders WHERE  FolderNo = board_downfolderbyuser.folderno;

SELECT T.SortNo, T.IsFolder INTO upno, isfolder FROM (
SELECT BoardNo AS No, SortNo,FALSE AS IsFolder FROM Board_Boards B
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_downfolderbyuser.userno
WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo<CurentNo AND ParentNo=B.FolderNo
UNION ALL
SELECT BF.FolderNo AS No, SortNo,TRUE AS IsFolder
FROM  Board_Folders BF
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_downfolderbyuser.userno
WHERE  BF.SortNo<CurentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
ORDER BY SortNo DESC) T ORDER BY T.SortNo DESC;











--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF UpNo >0 AND IsFolder= TRUE THEN
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Folders SET SortNo=UpNo WHERE FolderNo = board_downfolderbyuser.folderno ;
IF UpNo >0 AND IsFolder= FALSE THEN
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Folders SET SortNo=UpNo WHERE FolderNo = board_downfolderbyuser.folderno ;

END IF;
END IF;
END;
$function$

```
</details>

## `board_downmultilwidget`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_downmultilwidget"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_downmultilwidget(integer,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downmultilwidget(userno integer, boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_MultiBoardWidget WHERE  BoardNo = board_downmultilwidget.boardno  AND IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_MultiBoardWidget
	WHERE IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET Sort=(SELECT /* /* TOP 1 */ */ T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),ModUserNo= board_downmultilwidget.userno,ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$

```
</details>

## `board_downmultiwidget`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_downmultiwidget"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_downmultiwidget(integer,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downmultiwidget(userno integer, boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_MultiBoardWidget WHERE  BoardNo = board_downmultiwidget.boardno  AND IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_MultiBoardWidget
	WHERE IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET Sort=(SELECT /* /* TOP 1 */ */ T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),ModUserNo= board_downmultiwidget.userno,ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$

```
</details>

## `board_downwidget`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_downwidget"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_downwidget(integer,integer,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_downwidget(userno integer, boardno integer, type integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_NewBoardWidget WHERE  BoardNo = board_downwidget.boardno AND Type=board_downwidget.type AND IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_NewBoardWidget
	WHERE Type=board_downwidget.type AND IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET Sort=(SELECT /* /* TOP 1 */ */ T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),ModUserNo= board_downwidget.userno,ModDate=NOW()
	FROM Board_NewBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$

```
</details>

## `board_getallboardcontentsbyboardlist`

- Input: `0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getallboardcontentsbyboardlist"(0::integer, ''::character varying, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42883`
- Error: function nvarchar(integer) does not exist
- Stack context: PL/pgSQL function board_getallboardcontentsbyboardlist(integer,character varying,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 28 at assignment
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallboardcontentsbyboardlist(userno integer, boardlist character varying, sortcolumn integer, isascending boolean, countperpage integer, currentpageindex integer, languagesign character varying, filtertype integer, fromdate timestamp without time zone, todate timestamp without time zone, typeeff integer DEFAULT 0, isalarm boolean DEFAULT false, isadmin boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    departno integer;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	strAlow := '';
	strWriteAlow := '';
	IF IsAdmin = FALSE THEN
		strAlow := ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo ';
		strWriteAlow := '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF SortColumn <= 1 THEN
	    query := COALESCE(query, '') || COALESCE(('RegDate '), '');
	ELSIF SortColumn = 2 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF SortColumn = 3 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BB.Name) '), '');
	ELSIF SortColumn = 4 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF SortColumn = 5 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF SortColumn  = 6 THEN
	    query := COALESCE(query, '') || COALESCE(('ViewedCount '), '');
	ELSIF SortColumn = 7 THEN
	    query := COALESCE(query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || ' BB.Enabled = TRUE AND  BC.Enabled = TRUE
AND  ''' || BoardList || ''' ILIKE ( ''%,'' || CONVERT(nvarchar(200), BB.BoardNo) || '',%'') '), '');
	query := COALESCE(query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || '''  '), '');

	query := COALESCE(query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || ''' ) > 0 ) '), '');

	IF TypeEff > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF IsAlarm > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
    IF FilterType <> 100 THEN
		query := COALESCE(query, '') || COALESCE(('AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;

	IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = board_getallboardcontentsbyboardlist.userno), 0) <> 1 THEN

		query := COALESCE(query, '') || COALESCE(('		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'), '');
	END IF;

	/*
	 * 게시글 검색 시작
	 */
	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	EXECUTE 'INSERT INTO SearchResult ' || query;
	/*
	 * 페이징 계산
	 */






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalPageCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_getallboardcontentsbyboardlist.currentpageindex * CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards;


	INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, BC.IsNotice AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum
		ORDER BY T.RowNum ASC;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getallboardcontentsbyboardlist.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC;
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$

```
</details>

## `board_getallowbyitem`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getallowbyitem"(0::integer, 0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" integer, "column_5" integer, "column_6" integer, "column_7" integer, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "itemno" is ambiguous
- Stack context: PL/pgSQL function board_getallowbyitem(integer,integer) line 7 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallowbyitem(itemno integer, itemtype integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		RETURN QUERY
		SELECT *
		FROM Board_AllowAccess
		WHERE ItemNo = board_getallowbyitem.itemno AND ItemType=board_getallowbyitem.itemtype;
END;
$function$

```
</details>

## `board_getallowbyitemtype`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getallowbyitemtype"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" integer, "column_5" integer, "column_6" integer, "column_7" integer, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "itemtype" is ambiguous
- Stack context: PL/pgSQL function board_getallowbyitemtype(integer) line 7 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallowbyitemtype(itemtype integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		RETURN QUERY
		SELECT *
		FROM Board_AllowAccess
		WHERE ItemType=board_getallowbyitemtype.itemtype;
END;
$function$

```
</details>

## `board_getallowbyuser`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getallowbyuser"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" integer, "column_5" integer, "column_6" integer, "column_7" integer, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_getallowbyuser(integer) line 7 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getallowbyuser(userno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		RETURN QUERY
		SELECT *
		FROM Board_AllowAccess
		WHERE UserNo = board_getallowbyuser.userno;
END;
$function$

```
</details>

## `board_getapprovaldoc`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getapprovaldoc"(0::integer) AS result("column_1" bigint, "column_2" character varying(200), "column_3" character varying(200), "column_4" character varying(1000), "column_5" character varying(1000), "column_6" character varying(1000), "column_7" character varying(1000), "column_8" character varying(260), "column_9" text);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getapprovaldoc(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getapprovaldoc(contentno integer DEFAULT 5831)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT C.ContentNo,C.Title,C.Title,C.Type,C.ApplyTo,C.DesignNo,C.BadNo,F.Name AS FileName,F.Url AS FileUrl
FROM Board_Contents C
LEFT JOIN (SELECT ContentNo,Url,Name,ROW_NUMBER() OVER(PARTITION BY ContentNo  ORDER BY ContentNo ASC) AS Rn FROM Board_Files ) F ON F.ContentNo=C.ContentNo AND F.Rn=1
where C.ContentNo=board_getapprovaldoc.contentno;
END;
$function$

```
</details>

## `board_getapprovalfiles`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getapprovalfiles"(0::integer) AS result("column_1" character varying(260), "column_2" text);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getapprovalfiles(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getapprovalfiles(contentno integer DEFAULT 16)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT Name,Url FROM Board_Files where ContentNo=board_getapprovalfiles.contentno;
END;
$function$

```
</details>

## `board_getboard`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getboard"(0::integer) AS result("column_1" integer, "column_2" timestamp without time zone, "column_3" character varying(4000), "column_4" character varying(1000), "column_5" integer, "column_6" integer, "column_7" integer, "column_8" boolean, "column_9" boolean, "column_10" boolean, "column_11" boolean, "column_12" integer, "column_13" integer, "column_14" boolean, "column_15" integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_getboard(integer) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboard(boardno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ModUserNo, ModDate, Name, Description, FolderNo, DisplayTypeNo,
		SortNo, IsReply, IsHead, IsNotice, IsRecommend, RecommendedDisplayCount,ViewMode, Enabled,SpecType
	FROM Board_Boards
	WHERE BoardNo = board_getboard.boardno;
END;
$function$

```
</details>

## `board_getboardcontents`

- Input: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getboardcontents"(0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42883`
- Error: function nvarchar(integer) does not exist
- Stack context: PL/pgSQL function board_getboardcontents(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 27 at assignment
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcontents(userno integer DEFAULT 70, boardno integer DEFAULT 53, sortcolumn integer DEFAULT 1, isascending boolean DEFAULT false, countperpage integer DEFAULT 1, currentpageindex integer DEFAULT 10, languagesign character varying DEFAULT 'EN'::character varying, filtertype integer DEFAULT 100, fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, todate timestamp without time zone DEFAULT '2019-01-01 19:20:19.717'::timestamp without time zone, typeeff integer DEFAULT 0, isalarm boolean DEFAULT false, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	strAlow := '';
	strWriteAlow := '';
	IF IsAdmin = FALSE THEN
		strAlow := ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo;
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		strWriteAlow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF SortColumn <= 1 THEN
	    query := COALESCE(query, '') || COALESCE(('(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '), '');
	ELSIF SortColumn = 2 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF SortColumn = 3 THEN
	    query := COALESCE(query, '') || COALESCE(('RegDate '), '');
	ELSIF SortColumn = 4 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF SortColumn = 5 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF SortColumn  = 6 THEN
	    query := COALESCE(query, '') || COALESCE(('ViewedCount '), '');
	ELSIF SortColumn = 7 THEN
	    query := COALESCE(query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	-- Nghiem edit 2018-09-20 change DESC -> ASC
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', BC.LevelRand || CAST(BC.ContentNo As text) ASC, OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	query := COALESCE(query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents BC   INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND BC.Enabled = TRUE '), '');

	query := COALESCE(query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || '''  '), '');

	query := COALESCE(query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || ''' ) > 0 ) '), '');

	IF TypeEff > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF IsAlarm > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF FilterType <> 100 THEN
		query := COALESCE(query, '') || COALESCE(('AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;


	IF IsAdmin = FALSE THEN

		--SET Query +=' AND BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) +  ') DP ON DP.DepartNo= BS1.DepartNo)'

	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 );
		query := COALESCE(query, '') || COALESCE(('  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR ( BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) || ') OR (BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) || ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CONVERT(nvarchar(10),UserNo ) || ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'), '');
		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	--END
	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	END IF;

	/*
	 * 게시글 검색 시작
	 */

	 RAISE NOTICE '%', Query;
	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	EXECUTE format('INSERT INTO SearchResult ' || Query, BoardNo);
	/*
	 * 페이징 계산
	 */






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalItemCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_getboardcontents.currentpageindex * CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE TempTable (
		RN INT,
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards WHERE BoardNo = board_getboardcontents.boardno;


	IF IsHead = TRUE THEN

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
			 BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents.boardno AND BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents.boardno AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents.boardno) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE;


	ELSE

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents.boardno AND BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents.boardno AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE;


	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboardcontents.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC ORDER BY RN ASC;
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;


	--/*
	-- * 쿼리 조합 시작
	-- */

	--DECLARE Query NVARCHAR(2000)
	--SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	--DECLARE strAlow NVARCHAR(2000)
	--DECLARE strWriteAlow NVARCHAR(2000)
	--SET strAlow = ''
	--SET strWriteAlow = ''
	--if (IsAdmin = FALSE)
	--BEGIN
	--	SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo '
	--	SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
	--END

	--/*
	-- * 정렬 컬럼
	-- */

	--IF (SortColumn <= 1) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	--ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	--ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	--ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	--ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	--/*
	-- * 정렬 내림차순 여부
	-- */

	--IF (IsAscending = TRUE) SET Query += 'ASC '
	--ELSE SET Query += 'DESC '


	--SET Query += ', OrderNo ASC'



	--/*
	-- * WHERE 조합 시작
	-- */

	--SET Query +=
	--	') RowNum, ContentNo, Content ' +
	--	'FROM Board_Contents BC
	--		' || strAlow || '
	--		WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND Enabled = TRUE '

	--SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + '''  '

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + ''' ) > 0 ) '

	--IF (TypeEff > 0)
	--BEGIN
	--	SET Query += ' AND BC.TitleEffect <> 2 '
	--END
	--IF (IsAlarm > 0)
	--BEGIN
	--	SET Query += ' AND BC.IsAlarm = TRUE '
	--END
	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	--END

	--/*
	-- * 게시글 검색 시작
	-- */

	--DECLARE SearchResult TABLE (
	--	RowNum		BIGINT,
	--	ContentNo	BIGINT,
	--	Content text
	--)

	--INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL Query,
	--	'BoardNo AS INT',
	--	BoardNo



	--/*
	-- * 페이징 계산
	-- */

	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	----IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage



	--/*
	-- *
	-- */

	--DECLARE TempTable TABLE (
	--	ContentNo			BIGINT,
	--	Content				text,
	--	ModUserNo			INT,
	--	ModUserName			NVARCHAR(100),
	--	ModDepartNo			INT,
	--	ModDepartName		NVARCHAR(100),
	--	RegDate				DATETIME,
	--	Title				NVARCHAR(200),
	--	TitleEffect			INT,
	--	GroupNo				BIGINT,
	--	Depth				INT,
	--	OrderNo				INT,
	--	HeadNo				INT,
	--	IsNotice			BIT,
	--	IsFile				BIT,
	--	ReplyCount			INT,
	--	RecommendedCount	INT,
	--	ViewedCount			INT,

	--	HeadName			NVARCHAR(100),
	--	IsRecommended		BIT,
	--	ModPositionNo		INT,
	--	ModPositionName		nvarchar(100),
	--	FileCount			INT,
	--	BoardNo				INT,
	--	BoardName			nvarchar(100),
	--	RegUserNo			INT,
	--	RegUserName			NVARCHAR(100),
	--	RegPositionNo		INT,
	--	RegPositionName		nvarchar(100),
	--	RegDepartNo			INT,
	--	RegDepartName		NVARCHAR(100),
	--	IsAlarm				BIT
	--)

	--DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
	--DECLARE RecommendedDisplayCount INT

	--SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	--FROM Board_Boards WHERE BoardNo = BoardNo

	--IF (IsHead = TRUE) BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo,( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--		 BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm

	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.IsNotice = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--ELSE BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.IsNotice = TRUE AND BC.Enabled = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	--SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$

```
</details>

## `board_getboardcontents_bk20181227`

- Input: `0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_getboardcontents_bk20181227"(0::integer, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, false, false);`
- SQLSTATE: `42883`
- Error: function nvarchar(integer) does not exist
- Stack context: PL/pgSQL function board_getboardcontents_bk20181227(integer,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,boolean,boolean) line 27 at assignment
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getboardcontents_bk20181227(userno integer DEFAULT 70, boardno integer DEFAULT 53, sortcolumn integer DEFAULT 1, isascending boolean DEFAULT true, countperpage integer DEFAULT 10, currentpageindex integer DEFAULT 1, languagesign character varying DEFAULT 'EN'::character varying, filtertype integer DEFAULT 1, fromdate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, todate timestamp without time zone DEFAULT '2011-01-01 19:20:19.717'::timestamp without time zone, typeeff integer DEFAULT 0, isalarm boolean DEFAULT false, isadmin boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	strAlow := '';
	strWriteAlow := '';
	IF IsAdmin = FALSE THEN
		strAlow := ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo;
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo
			LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',1)) AE ON BC.BoardNo=AE.BoardNo ';
		strWriteAlow := '(AE.BoardNo IS NOT NULL OR AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF SortColumn <= 1 THEN
	    query := COALESCE(query, '') || COALESCE(('(CASE WHEN BC.Depth > 0 THEN BC.RootId ELSE BC.ContentNo END) '), '');
	ELSIF SortColumn = 2 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(Title) '), '');
	ELSIF SortColumn = 3 THEN
	    query := COALESCE(query, '') || COALESCE(('RegDate '), '');
	ELSIF SortColumn = 4 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModUserName) '), '');
	ELSIF SortColumn = 5 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(ModDepartName) '), '');
	ELSIF SortColumn  = 6 THEN
	    query := COALESCE(query, '') || COALESCE(('ViewedCount '), '');
	ELSIF SortColumn = 7 THEN
	    query := COALESCE(query, '') || COALESCE(('IsAlarm '), '');
	END IF;


	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	-- Nghiem edit 2018-09-20 change DESC -> ASC
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', BC.LevelRand || CAST(BC.ContentNo As text) ASC, OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	query := COALESCE(query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents BC   INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND BC.Enabled = TRUE '), '');

	query := COALESCE(query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || '''  '), '');

	query := COALESCE(query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || ''' ) > 0 ) '), '');

	IF TypeEff > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF IsAlarm > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF FilterType <> 100 THEN
		query := COALESCE(query, '') || COALESCE(('AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;


	IF IsAdmin = FALSE THEN

		--SET Query +=' AND BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) +  ') DP ON DP.DepartNo= BS1.DepartNo)'

	--SELECT * FROM Board_Sharers BS1 INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo= BS1.DepartNo WHERE UserNo=222
	--((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = 16) <=0 );
		query := COALESCE(query, '') || COALESCE(('  AND ((AE.BoardNo IS NOT NULL  AND BB.SpecType > 1) OR ( BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) || ') OR (BC.ContentNo IN (SELECT DISTINCT BS1.ContentNo FROM Board_Sharers BS1 inner JOIN public."Organization_GetDepartmentsByUser" (' || CONVERT(nvarchar(10), UserNo) || ') DP ON DP.DepartNo= BS1.DepartNo)) OR (BC.ContentNo IN ( SELECT BSS1.ContentNo FROM Board_Sharers BSS1
where BSS1.contentno=BC.ContentNo and BSS1.userno=' || CONVERT(nvarchar(10),UserNo ) || ')) OR ((SELECT COUNT(*) FROM Board_Sharers BS2 WHERE BS2.CONTENTNO = BC.ContentNO) <=0 ) )'), '');
		--DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
		--SET Query +=  ' AND ( BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	--END
	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	END IF;

	/*
	 * 게시글 검색 시작
	 */

	 RAISE NOTICE '%', Query;
	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,
		ContentNo	BIGINT,
		Content text
	) ON COMMIT DROP;

	EXECUTE format('INSERT INTO SearchResult ' || Query, BoardNo);
	/*
	 * 페이징 계산
	 */






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalItemCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_getboardcontents_bk20181227.currentpageindex * CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE TempTable (
		RN INT,
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards WHERE BoardNo = board_getboardcontents_bk20181227.boardno;


	IF IsHead = TRUE THEN

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo,COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
			 BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT 0, BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = board_getboardcontents_bk20181227.boardno) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE;


	ELSE

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT 0,BC.ContentNo, BC.Content, BC.ModUserNo, COALESCE(( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end),'') as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
			,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.BoardNo = board_getboardcontents_bk20181227.boardno AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT T.RowNum ,BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

			BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE;


	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_getboardcontents_bk20181227.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC ORDER BY RN ASC;
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;


	--/*
	-- * 쿼리 조합 시작
	-- */

	--DECLARE Query NVARCHAR(2000)
	--SET Query = 'SELECT ROW_NUMBER() OVER (ORDER BY '

	--DECLARE strAlow NVARCHAR(2000)
	--DECLARE strWriteAlow NVARCHAR(2000)
	--SET strAlow = ''
	--SET strWriteAlow = ''
	--if (IsAdmin = FALSE)
	--BEGIN
	--	SET strAlow = ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo '
	--	SET strWriteAlow = '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND '
	--END

	--/*
	-- * 정렬 컬럼
	-- */

	--IF (SortColumn <= 1) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 2) SET Query += 'LTRIM(Title) '
	--ELSE IF (SortColumn = 3) SET Query += 'RegDate '
	--ELSE IF (SortColumn = 4) SET Query += 'LTRIM(ModUserName) '
	--ELSE IF (SortColumn = 5) SET Query += 'LTRIM(ModDepartName) '
	--ELSE IF (SortColumn  = 6) SET Query += 'ViewedCount '
	--ELSE IF (SortColumn = 7) SET Query += 'IsAlarm '


	--/*
	-- * 정렬 내림차순 여부
	-- */

	--IF (IsAscending = TRUE) SET Query += 'ASC '
	--ELSE SET Query += 'DESC '


	--SET Query += ', OrderNo ASC'



	--/*
	-- * WHERE 조합 시작
	-- */

	--SET Query +=
	--	') RowNum, ContentNo, Content ' +
	--	'FROM Board_Contents BC
	--		' || strAlow || '
	--		WHERE  ' || strWriteAlow || '  BC.BoardNo = BoardNo AND Enabled = TRUE '

	--SET Query +=  ' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + '''  '

	--SET Query +=  ' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) + ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) + ''' ) > 0 ) '

	--IF (TypeEff > 0)
	--BEGIN
	--	SET Query += ' AND BC.TitleEffect <> 2 '
	--END
	--IF (IsAlarm > 0)
	--BEGIN
	--	SET Query += ' AND BC.IsAlarm = TRUE '
	--END
	--IF (FilterType <> 100)
	--BEGIN
	--	SET Query += 'AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) + ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) + ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '
	--END

	--IF COALESCE((select PermissionType from Authority_SitePermissions where UserNo = UserNo), 0) <> 1 BEGIN
	--	DECLARE DepartNo INT = (SELECT DepartNo FROM Organization_BelongToDepartment WHERE UserNo = UserNo)
	--	SET Query +=  '		AND (RegDepartNo = ' || CONVERT(nvarchar(20), DepartNo) +' Or ContentNo NOT IN (SELECT distinct ContentNo FROM Board_Sharers WHERE DepartNo <> ' || CONVERT(nvarchar(20), DepartNo) +'))'
	--END

	--/*
	-- * 게시글 검색 시작
	-- */

	--DECLARE SearchResult TABLE (
	--	RowNum		BIGINT,
	--	ContentNo	BIGINT,
	--	Content text
	--)

	--INSERT INTO SearchResult
	--EXEC SP_EXECUTESQL Query,
	--	'BoardNo AS INT',
	--	BoardNo



	--/*
	-- * 페이징 계산
	-- */

	--DECLARE TotalItemCount INT
	--DECLARE TotalPageCount INT
	--DECLARE StartRowNum INT
	--DECLARE EndRowNum INT

	--SET TotalItemCount = (SELECT COUNT(*) FROM SearchResult)
	--SET TotalPageCount = TotalItemCount / CountPerPage

	--IF (TotalPageCount % CountPerPage > 0) SET TotalPageCount = TotalPageCount + 1
	--IF (TotalPageCount = 0) SET TotalPageCount = 1
	----IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount

	--SET StartRowNum = ((CurrentPageIndex - 1) * CountPerPage) + 1
	--SET EndRowNum = CurrentPageIndex * CountPerPage



	--/*
	-- *
	-- */

	--DECLARE TempTable TABLE (
	--	ContentNo			BIGINT,
	--	Content				text,
	--	ModUserNo			INT,
	--	ModUserName			NVARCHAR(100),
	--	ModDepartNo			INT,
	--	ModDepartName		NVARCHAR(100),
	--	RegDate				DATETIME,
	--	Title				NVARCHAR(200),
	--	TitleEffect			INT,
	--	GroupNo				BIGINT,
	--	Depth				INT,
	--	OrderNo				INT,
	--	HeadNo				INT,
	--	IsNotice			BIT,
	--	IsFile				BIT,
	--	ReplyCount			INT,
	--	RecommendedCount	INT,
	--	ViewedCount			INT,

	--	HeadName			NVARCHAR(100),
	--	IsRecommended		BIT,
	--	ModPositionNo		INT,
	--	ModPositionName		nvarchar(100),
	--	FileCount			INT,
	--	BoardNo				INT,
	--	BoardName			nvarchar(100),
	--	RegUserNo			INT,
	--	RegUserName			NVARCHAR(100),
	--	RegPositionNo		INT,
	--	RegPositionName		nvarchar(100),
	--	RegDepartNo			INT,
	--	RegDepartName		NVARCHAR(100),
	--	IsAlarm				BIT
	--)

	--DECLARE IsHead BIT, IsNotice BIT, IsRecommend BIT
	--DECLARE RecommendedDisplayCount INT

	--SELECT IsHead = IsHead, IsNotice = IsNotice, IsRecommend = IsRecommend, RecommendedDisplayCount = RecommendedDisplayCount
	--FROM Board_Boards WHERE BoardNo = BoardNo

	--IF (IsHead = TRUE) BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo,( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName,
	--		 BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm

	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.IsNotice = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads WHERE BoardNo = BoardNo) BH ON BH.HeadNo = BC.HeadNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--ELSE BEGIN

	--	IF (IsNotice = TRUE) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.IsNotice = TRUE AND BC.Enabled = TRUE

	--	END

	--	IF (IsRecommend = TRUE AND RecommendedDisplayCount > 0) BEGIN

	--		INSERT INTO TempTable
	--		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
	--			BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--			'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--			BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--		,BC.IsAlarm
	--		FROM Board_Contents BC
	--		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE BC.BoardNo = BoardNo AND BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
	--		ORDER BY RecommendedCount DESC

	--	END

	--	INSERT INTO TempTable
	--	SELECT BC.ContentNo, BC.Content, BC.ModUserNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.ModUserNo ),(Select Name from Organization_Users where UserNo = BC.ModUserNo )) else (Select Name from Organization_Users  where UserNo = BC.ModUserNo ) end) as ModUserName, BC.ModDepartNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.ModDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.ModDepartNo) end) as ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
	--		BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

	--		'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

	--		BC.RegUserNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
	--	BC.RegPositionNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
	--	 BC.RegDepartNo,
	--	( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
	--	,BC.IsAlarm
	--	FROM SearchResult T
	--	INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
	--	LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
	--		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
	--	ORDER BY T.RowNum ASC

	--END

	--SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=UserNo AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC
	--SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex
END;
$function$

```
</details>

## `board_getconfig`

- Input: `''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_getconfig"(''::character varying) AS result("column_1" integer, "column_2" character varying(50), "column_3" character varying(500), "column_4" integer, "column_5" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "configkey" is ambiguous
- Stack context: PL/pgSQL function board_getconfig(character varying) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getconfig(configkey character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *
	FROM Board_Config
	WHERE ConfigKey = board_getconfig.configkey;
END;
$function$

```
</details>

## `board_getcontentsetting`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getcontentsetting"(0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_getcontentsetting(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getcontentsetting(boardno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT * FROM public."Board_ContentSetting" WHERE BoardNo= board_getcontentsetting.boardno LIMIT 1;
END;
$function$

```
</details>

## `board_getdepartandpositionname`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."board_getdepartandpositionname"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42P01`
- Error: relation "organization_departments" does not exist
- Stack context: PL/pgSQL function board_getdepartandpositionname(integer,integer,character varying) line 10 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getdepartandpositionname(departno integer, positionno integer, languageid character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		CREATE TEMP TABLE tmp (
				 DepartName varchar(100),
				 PositionName varchar(100)
				) ON COMMIT DROP;

		Insert into tmp values ((Select case when LanguageId = 'EN' then Dep.Name_EN else Dep.Name end from Organization_Departments as Dep where DepartNo = board_getdepartandpositionname.departno),
									(Select case when LanguageId = 'EN' then Name_EN else Name end from Organization_Positions where PositionNo = board_getdepartandpositionname.positionno));

		RETURN QUERY
		select * from tmp;
END;
$function$

```
</details>

## `board_getfile`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getfile"(0::bigint) AS result("column_1" bigint, "column_2" character varying(260), "column_3" integer, "column_4" text);`
- SQLSTATE: `42702`
- Error: column reference "fileno" is ambiguous
- Stack context: PL/pgSQL function board_getfile(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getfile(fileno bigint DEFAULT 592)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ContentNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_Files
	WHERE FileNo = board_getfile.fileno;
END;
$function$

```
</details>

## `board_getfiles`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getfiles"(0::bigint) AS result("column_1" bigint, "column_2" character varying(260), "column_3" integer, "column_4" text, "column_5" integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getfiles(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getfiles(contentno bigint DEFAULT 5793)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Size,COALESCE(Url,'') AS Url,Sort
	FROM Board_Files
	WHERE ContentNo = board_getfiles.contentno;
END;
$function$

```
</details>

## `board_getfolderbyfolderno`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getfolderbyfolderno"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" timestamp without time zone, "column_4" character varying(4000), "column_5" integer, "column_6" integer, "column_7" boolean, "column_8" character varying(500), "column_9" integer);`
- SQLSTATE: `42702`
- Error: column reference "folderno" is ambiguous
- Stack context: PL/pgSQL function board_getfolderbyfolderno(integer) line 7 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getfolderbyfolderno(folderno integer DEFAULT 49)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		RETURN QUERY
		SELECT FolderNo, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled, LevelRand,SpecType
		FROM Board_Folders where FolderNo=board_getfolderbyfolderno.folderno
		ORDER BY SortNo ASC,FolderNo ASC;
END;
$function$

```
</details>

## `board_getheads`

- Input: `0::integer, false`
- Generated SQL: `SELECT * FROM "public"."board_getheads"(0::integer, false) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(100), "column_6" integer, "column_7" boolean);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_getheads(integer,boolean) line 16 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getheads(boardno integer, isdisabled boolean)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDisabled = TRUE THEN

		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		ORDER BY SortNO ASC;


	ELSE

		RETURN QUERY
		SELECT HeadNo, BoardNo, ModUserNo, ModDate, Name, SortNo, Enabled
		FROM Board_Heads
		WHERE Enabled = TRUE
		ORDER BY SortNO ASC;

	END IF;
END;
$function$

```
</details>

## `board_getlistnoticepermission`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_getlistnoticepermission"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42P01`
- Error: relation "organization_users" does not exist
- Stack context: PL/pgSQL function board_getlistnoticepermission(integer,integer,integer,integer,character varying,integer,integer,character varying,character varying) line 8 at assignment
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistnoticepermission(itemno integer DEFAULT 25, applicationno integer DEFAULT 7, departno integer DEFAULT 1, positionno integer DEFAULT 0, languagecode character varying DEFAULT 'EN'::character varying, pagenumber integer DEFAULT 1, pagesize integer DEFAULT 10, searchvalue character varying DEFAULT ''::character varying, sortcolumn character varying DEFAULT ''::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    total bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH RECURSIVE RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistnoticepermission.departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER (PARTITION BY U.Enabled  ORDER BY
					CASE WHEN  SortColumn='' THEN  CASE LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END ASC,
					CASE WHEN  SortColumn='USERNAME' THEN  CASE LanguageCode WHEN 'EN' THEN  COALESCE(U.Name_EN,U.Name) WHEN 'VN' THEN  COALESCE(U.Name_VN,U.Name) WHEN 'CH' THEN COALESCE(U.Name_CH,U.Name)  WHEN 'JP' THEN COALESCE(U.Name_JP,U.Name) ELSE U.Name END END DESC
		) AS RowNum ,
			U.Name,
            U.UserId,
			U.UserNo,
			OB.DepartNo,
			OB.PositionNo,
			CASE WHEN LanguageCode='EN' THEN OD.Name_EN WHEN LanguageCode='VN' THEN OD.Name_VN WHEN LanguageCode='CH' THEN OD.Name_CH WHEN LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
			CASE WHEN LanguageCode='EN' THEN OP.NAME_EN WHEN LanguageCode='VN' THEN OP.Name_VN WHEN LanguageCode='CH' THEN OP.Name_CH WHEN LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
			CAST( CASE WHEN UP.AllowValue>0 THEN 1  ELSE 0 END AS BIT) AS IsAdmin
		FROM ORGANIZATION_USERS U
		LEFT JOIN Board_NoticePermission UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistnoticepermission.applicationno
		WHERE  (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistnoticepermission.positionno OR PositionNo=0) AND U.Enabled = TRUE AND (U.UserID ILIKE '%' || SearchValue || '%' OR U.Name ILIKE '%' || SearchValue || '%'  )
	)

	SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin
	FROM USERS U--,TOTAL T
	WHERE  U.RowNum >board_getlistnoticepermission.pagesize*(PageNumber-1) AND U.RowNum <=board_getlistnoticepermission.pagesize*PageNumber;
END;
$function$

```
</details>

## `board_getlistuserpermission`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_getlistuserpermission"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "organization_users" does not exist
- Stack context: PL/pgSQL function board_getlistuserpermission(integer,integer,integer,integer,integer,character varying,integer,integer,boolean) line 13 at assignment
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistuserpermission(itemno integer DEFAULT 25, itemtype integer DEFAULT 1, applicationno integer DEFAULT 7, departno integer DEFAULT 1, positionno integer DEFAULT 0, languagecode character varying DEFAULT 'EN'::character varying, pagenumber integer DEFAULT 1, pagesize integer DEFAULT 10, ispermission boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    total bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo);
	Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	UserPermistions as (
		SELECT DISTINCT BA.UserNo,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
		FROM Board_AllowAccess BA
		--LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
		WHERE BA.ItemNo=board_getlistuserpermission.itemno AND BA.ItemType=board_getlistuserpermission.itemtype
	),
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistuserpermission.departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
			U.Name,
            U.UserId,
			U.UserNo,
			OB.DepartNo,
			OB.PositionNo,
			CASE WHEN LanguageCode='EN' THEN OD.Name_EN WHEN LanguageCode='VN' THEN OD.Name_VN WHEN LanguageCode='CH' THEN OD.Name_CH WHEN LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
			CASE WHEN LanguageCode='EN' THEN OP.NAME_EN WHEN LanguageCode='VN' THEN OP.Name_VN WHEN LanguageCode='CH' THEN OP.Name_CH WHEN LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite ,
			CASE WHEN IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE  WHEN UP.DisableAdmin IS NOT NULL THEN  UP.DisableAdmin ELSE FALSE END AS DisableAdmin,
			CASE WHEN IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE WHEN UP.DisableRead IS NOT NULL THEN  UP.DisableRead ELSE FALSE END AS DisableRead,
			CASE WHEN IsPermission = FALSE --OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL
			THEN TRUE  WHEN UP.DisableWrite IS NOT NULL THEN  UP.DisableWrite ELSE FALSE END AS DisableWrite
			FROM ORGANIZATION_USERS U
		LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistuserpermission.applicationno
		WHERE (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistuserpermission.positionno OR PositionNo=0) AND U.Enabled = TRUE
	)--,
	--TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin,U.IsRead,U.IsWrite,U.DisableAdmin,U.DisableRead,U.DisableWrite
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableAdmin ELSE  TRUE  END AS DisableAdmin,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableRead ELSE TRUE END AS DisableRead,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableWrite ELSE TRUE END AS DisableWrite
	FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	WHERE U.RowNum >board_getlistuserpermission.pagesize*(PageNumber-1) AND U.RowNum <=board_getlistuserpermission.pagesize*PageNumber;

	--SET NOCOUNT ON;
	--DECLARE Total BIGINT;
	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo)
	--SET Total =(SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	--WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	--UserPermistions as (
	--	SELECT DISTINCT BA.UserNo,
	--	CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
	--	CASE WHEN UP.AllowValue%2=0 THEN TRUE ELSE FALSE END AS DisableAdmin ,
	--	CASE WHEN BA.AllowValue%2<>0 OR UP.AllowValue=2  THEN TRUE ELSE FALSE END AS DisableWrite ,
	--	CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
	--	FROM Board_AllowAccess BA
	--	LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
	--	WHERE BA.ItemNo=ItemNo AND BA.ItemType=ItemType
	--),
	--RootDeparts AS (
	--	  SELECT *
	--	  FROM Organization_Departments
	--	  WHERE DepartNo = DepartNo
	--	  UNION ALL
	--	  SELECT OD.*
	--	  FROM Organization_Departments OD
	--	  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	-- ),
	-- USERS AS(
	--	SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
	--		U.Name,
 --           U.UserId,
	--		U.UserNo,
	--		OB.DepartNo,
	--		OB.PositionNo,
	--		CASE WHEN LanguageCode='EN' THEN OD.Name_EN WHEN LanguageCode='VN' THEN OD.Name_VN WHEN LanguageCode='CH' THEN OD.Name_CH WHEN LanguageCode='JP' THEN OD.Name_JP ELSE OD.Name  END AS DepartName,
	--		CASE WHEN LanguageCode='EN' THEN OP.NAME_EN WHEN LanguageCode='VN' THEN OP.Name_VN WHEN LanguageCode='CH' THEN OP.Name_CH WHEN LanguageCode='JP' THEN OP.Name_JP ELSE OP.Name END  AS PositionName,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite ,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableAdmin IS NOT NULL THEN  UP.DisableAdmin ELSE FALSE END AS DisableAdmin,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableRead IS NOT NULL THEN  UP.DisableRead ELSE FALSE END AS DisableRead,
	--		CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.DisableWrite IS NOT NULL THEN  UP.DisableWrite ELSE FALSE END AS DisableWrite
	--		FROM ORGANIZATION_USERS U
	--	LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
	--	INNER JOIN ORGANIZATION_BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.IsDefault = TRUE
	--	INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
	--	INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
	--	LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
	--	LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=ApplicationNo
	--	WHERE (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=PositionNo OR PositionNo=0) AND U.Enabled = TRUE
	--)--,
	----TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	--SELECT (SELECT COUNT(*) AS Total  FROM USERS U) AS Total, U.Name,U.UserId,U.UserNo,U.DepartNo,U.PositionNo,U.DepartName,U.PositionName,U.IsAdmin,U.IsRead,U.IsWrite,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableAdmin ELSE  TRUE  END AS DisableAdmin,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableRead ELSE TRUE END AS DisableRead,
	--CASE WHEN  UP.AllowValue IS NOT NULL OR COALESCE(ParentFolderNo,0)=0 THEN  U.DisableWrite ELSE TRUE END AS DisableWrite
	--FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	--WHERE U.RowNum >PageSize*(PageNumber-1) AND U.RowNum <=PageSize*PageNumber
END;
$function$

```
</details>

## `board_getlistuserpermissiontoexcel`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_getlistuserpermissiontoexcel"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, 0::integer, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: relation "organization_users" does not exist
- Stack context: PL/pgSQL function board_getlistuserpermissiontoexcel(integer,integer,integer,integer,integer,character varying,integer,integer,boolean) line 13 at assignment
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getlistuserpermissiontoexcel(itemno integer DEFAULT 25, itemtype integer DEFAULT 1, applicationno integer DEFAULT 7, departno integer DEFAULT 1, positionno integer DEFAULT 0, languagecode character varying DEFAULT 'EN'::character varying, pagenumber integer DEFAULT 1, pagesize integer DEFAULT 10, ispermission boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    total bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--DECLARE ParentFolderNo INT;
	--IF(ItemType=1)
	--	SET ParentFolderNo= (SELECT ParentNo FROM Board_Folders  WHERE  FolderNo=ItemNo)
	--ELSE
	--	SET ParentFolderNo= (SELECT FolderNo FROM Board_Boards  WHERE  BoardNo=ItemNo);
	Total := (SELECT COUNT(UserId) FROM ORGANIZATION_USERS);
	RETURN QUERY
	WITH
	--UserParentPermistions AS(
	--	SELECT * FROM Board_AllowAccess WHERE ItemNo=ParentFolderNo AND ItemType=1
	--),
	UserPermistions as (
		SELECT DISTINCT BA.UserNo,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS IsAdmin ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =2 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsRead ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue =4 OR BA.AllowValue =6 THEN TRUE ELSE FALSE END AS IsWrite ,
		FALSE  AS DisableAdmin ,
		CASE WHEN BA.AllowValue%2<>0 THEN TRUE ELSE FALSE END AS DisableWrite ,
		CASE WHEN BA.AllowValue%2<>0 OR BA.AllowValue=4 OR BA.AllowValue=6 THEN TRUE ELSE FALSE END AS DisableRead
		FROM Board_AllowAccess BA
		--LEFT JOIN UserParentPermistions UP ON UP.UserNo=BA.UserNo AND UP.ItemNo=ParentFolderNo AND UP.ItemType=1
		WHERE BA.ItemNo=board_getlistuserpermissiontoexcel.itemno AND BA.ItemType=board_getlistuserpermissiontoexcel.itemtype
	),
	RootDeparts AS (
		  SELECT *
		  FROM Organization_Departments
		  WHERE DepartNo = board_getlistuserpermissiontoexcel.departno
		  UNION ALL
		  SELECT OD.*
		  FROM Organization_Departments OD
		  JOIN RootDeparts R ON OD.ParentNo = R.DepartNo
	 ),
	 BelongToDepartment AS(
			SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.UserNo,T.DepartNo ORDER BY T.IsDefault) AS Nm FROM ORGANIZATION_BelongToDepartment T
	),
	 USERS AS(
		SELECT	ROW_NUMBER() OVER ( ORDER BY U.UserNo ) AS RowNum ,
			U.Name,
            U.UserId,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsAdmin IS NOT NULL THEN  UP.IsAdmin ELSE FALSE END AS IsAdmin ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsRead ELSE FALSE END AS IsRead ,
			CASE WHEN IsPermission = FALSE OR SP.UserNo IS NOT NULL OR MP.UserNo IS NOT NULL THEN TRUE  WHEN UP.IsRead IS NOT NULL THEN  UP.IsWrite ELSE FALSE END AS IsWrite
			FROM ORGANIZATION_USERS U
		LEFT JOIN UserPermistions UP ON UP.UserNo=U.UserNo
		INNER JOIN BelongToDepartment OB ON OB.UserNo=U.UserNo AND OB.Nm=1
		INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
		INNER JOIN Organization_Positions OP ON OP.PositionNo=OB.PositionNo
		LEFT JOIN Authority_SitePermissions SP ON SP.UserNo=U.UserNo AND SP.PermissionType=1
		LEFT JOIN Authority_ModulePermission MP ON MP.UserNo=U.UserNo AND MP.ApplicationNo=board_getlistuserpermissiontoexcel.applicationno
		WHERE (DepartNo=0 OR  OD.DepartNo IN (SELECT DepartNo FROM RootDeparts)) AND(OP.PositionNo=board_getlistuserpermissiontoexcel.positionno OR PositionNo=0) AND U.Enabled = TRUE
	)--,
	--TOTAL AS (SELECT COUNT(*) AS Total  FROM USERS U)
	SELECT U.UserId,U.Name AS UserName,U.IsAdmin AS "Admin" ,U.IsWrite As Write ,U.IsRead AS "Read"
	FROM USERS U--,TOTAL T
	--LEFT JOIN UserParentPermistions  UP ON UP.UserNo=U.UserNo
	WHERE U.RowNum >board_getlistuserpermissiontoexcel.pagesize*(PageNumber-1) AND U.RowNum <=board_getlistuserpermissiontoexcel.pagesize*PageNumber;
END;
$function$

```
</details>

## `board_getmaxsortoftree`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getmaxsortoftree"(0::integer) AS result("column_1" integer);`
- SQLSTATE: `42702`
- Error: column reference "parentno" is ambiguous
- Stack context: PL/pgSQL function board_getmaxsortoftree(integer) line 4 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getmaxsortoftree(parentno integer DEFAULT 115)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
WITH RECURSIVE SORT AS (
select max(SortNo) AS SortNo from Board_Folders where ParentNo= board_getmaxsortoftree.parentno
UNION
select max(SortNo)  AS SortNo from Board_Boards where FolderNo = board_getmaxsortoftree.parentno)
SELECT MAX(SortNo) FROM SORT;
END;
$function$

```
</details>

## `board_getrecommendcount`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getrecommendcount"(0::bigint) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getrecommendcount(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getrecommendcount(contentno bigint DEFAULT 5721)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT CAST( Count(*) AS BIGINT)
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendcount.contentno;
END;
$function$

```
</details>

## `board_getrecommendedlogbyuserno`

- Input: `0::bigint, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getrecommendedlogbyuserno"(0::bigint, 0::integer) AS result("column_1" bigint, "column_2" integer, "column_3" bigint, "column_4" integer, "column_5" character varying(100), "column_6" integer, "column_7" character varying(100), "column_8" integer, "column_9" character varying(100), "column_10" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getrecommendedlogbyuserno(bigint,integer) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogbyuserno(contentno bigint, userno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LogNo, BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName, DepartNo, DepartName,
		RecommendedDate
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendedlogbyuserno.contentno AND UserNo=board_getrecommendedlogbyuserno.userno;
END;
$function$

```
</details>

## `board_getrecommendedlogs`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getrecommendedlogs"(0::bigint) AS result("column_1" bigint, "column_2" integer, "column_3" bigint, "column_4" integer, "column_5" character varying(100), "column_6" integer, "column_7" character varying(100), "column_8" integer, "column_9" character varying(100), "column_10" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getrecommendedlogs(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogs(contentno bigint DEFAULT 8)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LogNo, BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName, DepartNo, DepartName,
		RecommendedDate
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendedlogs.contentno;
END;
$function$

```
</details>

## `board_getrecommendlogcount`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getrecommendlogcount"(0::bigint) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getrecommendlogcount(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getrecommendlogcount(contentno bigint DEFAULT 524)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT Count(*)
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendlogcount.contentno;
END;
$function$

```
</details>

## `board_getreply`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getreply"(0::bigint) AS result("column_1" bigint, "column_2" bigint, "column_3" integer, "column_4" character varying(100), "column_5" integer, "column_6" character varying(100), "column_7" integer, "column_8" character varying(100), "column_9" timestamp without time zone, "column_10" timestamp without time zone, "column_11" bigint, "column_12" integer, "column_13" integer, "column_14" text);`
- SQLSTATE: `42702`
- Error: column reference "replyno" is ambiguous
- Stack context: PL/pgSQL function board_getreply(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getreply(replyno bigint)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReplyNo,ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, GroupNo, Depth, OrderNo, Content
	FROM Board_Replies
	WHERE ReplyNo = board_getreply.replyno;
END;
$function$

```
</details>

## `board_getreplyfilebyreplyfileno`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getreplyfilebyreplyfileno"(0::bigint) AS result("column_1" bigint, "column_2" bigint, "column_3" character varying(260), "column_4" integer, "column_5" text);`
- SQLSTATE: `42702`
- Error: column reference "replyfileno" is ambiguous
- Stack context: PL/pgSQL function board_getreplyfilebyreplyfileno(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getreplyfilebyreplyfileno(replyfileno bigint DEFAULT 7744)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReplyFileNo,ReplyNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_ReplyFiles
	WHERE ReplyFileNo = board_getreplyfilebyreplyfileno.replyfileno;
END;
$function$

```
</details>

## `board_getreplyfilebyreplyno`

- Input: `0::bigint`
- Generated SQL: `SELECT * FROM "public"."board_getreplyfilebyreplyno"(0::bigint) AS result("column_1" bigint, "column_2" character varying(260), "column_3" integer, "column_4" text);`
- SQLSTATE: `42702`
- Error: column reference "replyno" is ambiguous
- Stack context: PL/pgSQL function board_getreplyfilebyreplyno(bigint) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getreplyfilebyreplyno(replyno bigint DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ReplyFileNo, Name, Size,COALESCE(Url,'') AS Url
	FROM Board_ReplyFiles
	WHERE ReplyNo = board_getreplyfilebyreplyno.replyno;
END;
$function$

```
</details>

## `board_getstatusapprovalpermission`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_getstatusapprovalpermission"(0::integer, 0::integer) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_getstatusapprovalpermission(integer,integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getstatusapprovalpermission(userno integer DEFAULT 6656, boardno integer DEFAULT 1211)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT Count(*)  FROM Board_NoticePermission WHERE UserNo=board_getstatusapprovalpermission.userno AND ItemNo= board_getstatusapprovalpermission.boardno AND AllowValue>0;
END;
$function$

```
</details>

## `board_getteamname`

- Input: `''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_getteamname"(''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: function year(timestamp without time zone) does not exist
- Stack context: PL/pgSQL function board_getteamname(character varying,character varying) line 8 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getteamname(teamno character varying DEFAULT 'O&M'::character varying, companyno character varying DEFAULT 'JN1'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    num integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


SELECT COUNT(*) INTO num FROM Board_Contents C
INNER JOIN Board_Boards B ON B.BoardNo=C.BoardNo
Where B.ViewMode=76 And C.BadNo =board_getteamname.teamno AND C.DesignNo=board_getteamname.companyno AND YEAR(C.RegDate) =YEAR(NOW()) AND C.Enabled = TRUE;
RETURN QUERY
SELECT CompanyNo || '-' || CAST(YEAR(NOW()) AS nvarchar) +'-' || TeamNo || '-' || CAST(REPLICATE('0',5-LEN(RTRIM(Num+1))) + RTRIM(Num+1) AS nvarchar);
END;
$function$

```
</details>

## `board_gettreesubmenu_v2_json`

- Input: `0::integer, false, ''::character varying, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_gettreesubmenu_v2_json"(0::integer, false, ''::character varying, 0::integer, 0::integer);`
- SQLSTATE: `42P01`
- Error: relation "organization_belongtodepartment" does not exist
- Stack context: PL/pgSQL function board_gettreesubmenu_v2_json(integer,boolean,character varying,integer,integer) line 13 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu_v2_json(userno integer DEFAULT 222, isadmin boolean DEFAULT false, langcode character varying DEFAULT 'EN'::character varying, selectedboardno integer DEFAULT 0, selectedfolderno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    json character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


DROP TABLE IF EXISTS T;
DROP TABLE IF EXISTS O;
DROP TABLE IF EXISTS BL;

    -- Step 1: Build flat tree data
    CREATE TEMP TABLE T ON COMMIT DROP AS WITH
    DEPARTPERMISSION AS (
        SELECT ItemNo, AllowValue, AllowAccessNo, ItemType,
               ROW_NUMBER() OVER(PARTITION BY ItemNo, UserNo, ItemType ORDER BY ItemNo ASC) AS Rn
        FROM Board_DepartAllowAccess BD
        INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
        WHERE OB.UserNo = board_gettreesubmenu_v2_json.userno AND OB.IsDefault = TRUE
    ),
    History AS (
        SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY BH.UserNo, BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
        FROM Board_HistoryFolder BH WHERE BH.UserNo = board_gettreesubmenu_v2_json.userno
    ),
    FOLDER AS (
        SELECT BF.*, COALESCE(BH.IsOpen, 1) AS IsOpen
        FROM Board_Folders BF
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenu_v2_json.userno
        LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo AND BH.RowNum = 1
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1 AND D.Rn = 1
        WHERE BF.Enabled = TRUE
          AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
    ),
    BOARD AS (
        SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.FolderNo, B.SortNo,
               B.Enabled, B.ViewMode, B.SpecType,
               (SELECT COUNT(*) FROM Board_Contents BC
                WHERE '2020-12-31'::timestamp < BC.RegDate
                  AND BC.BoardNo = B.BoardNo AND BC.Enabled = TRUE
                  AND BC.RegUserNo <> board_gettreesubmenu_v2_json.userno
                  AND BC.ContentNo NOT IN (SELECT BV.ContentNo FROM Board_ViewedLogs BV WHERE BV.UserNo = board_gettreesubmenu_v2_json.userno)
                  AND (IsAdmin = TRUE OR BA.AllowValue = 7 OR D.AllowValue = 7
                       OR ((BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo, 2)) OR B.SpecType = 1)
                           AND (
                               BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1
                                                INNER JOIN public."Organization_BelongToDepartment" DP
                                                ON DP.DepartNo = BS1.DepartNo AND DP.UserNo = board_gettreesubmenu_v2_json.userno)
                               OR BC.ContentNo IN (SELECT BSS1.ContentNo FROM Board_Sharers BSS1
                                                   WHERE BSS1.ContentNo = BC.ContentNo AND BSS1.UserNo = board_gettreesubmenu_v2_json.userno)
                               OR BC.IsShareAll = TRUE
                           )))
               ) AS CountContent
        FROM Board_Boards B
        LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenu_v2_json.userno
        LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2 AND D.Rn = 1
        WHERE B.Enabled = TRUE
          AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
    ),
    TREESUB AS (
        SELECT COALESCE(CASE WHEN STRPOS(F.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = board_gettreesubmenu_v2_json.langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(F.Name) WHERE NAME = 'EN')))
                      ELSE F.Name END, '') AS Name,
               F.FolderNo AS No, F.ModUserNo, F.ModDate, F.Name AS JsonName,
               F.ParentNo, F.SortNo,
               TRUE AS IsFolder, F.IsOpen,
               CAST(0 AS BIGINT) AS CountContent, 0 AS ViewMode
        FROM FOLDER F
        UNION ALL
        SELECT COALESCE(CASE WHEN STRPOS(B.Name, '{') > 0
                      THEN COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = board_gettreesubmenu_v2_json.langcode), ''),
                           COALESCE(NULLIF((SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'KO'), ''),
                                        (SELECT StringValue FROM ParseJson(B.Name) WHERE NAME = 'EN')))
                      ELSE B.Name END, '') AS Name,
               B.BoardNo AS No, B.ModUserNo, B.ModDate, B.Name AS JsonName,
               B.FolderNo AS ParentNo, B.SortNo,
               FALSE AS IsFolder, FALSE AS IsOpen,
               CAST(B.CountContent AS BIGINT) AS CountContent, B.ViewMode
        FROM BOARD B
    )
    SELECT Name, No, ModUserNo, JsonName, ParentNo, SortNo,
        IsFolder, IsOpen, CountContent, ViewMode,
        CAST(CASE WHEN IsFolder = TRUE AND No = board_gettreesubmenu_v2_json.selectedfolderno THEN 1
                  WHEN IsFolder = FALSE AND No = board_gettreesubmenu_v2_json.selectedboardno  THEN 1
                  ELSE 0 END AS BIT) AS IsSelected FROM TREESUB;

    -- Step 2: Pre-compute boardlist per folder (separate step â€” SQL 2008 R2 no nested FOR XML);;
    RETURN QUERY
    SELECT f.No AS FolderNo,
           STUFF(array_to_string(ARRAY(
               SELECT ',' || CAST(b.No AS text)
               FROM T b
               WHERE b.ParentNo = f.No AND b.IsFolder = FALSE
               ORDER BY b.SortNo DESC), ''), 1, 1, '') AS Boardlist
    INTO BL
    FROM T f WHERE f.IsFolder = TRUE;

    -- Step 3: Depth-first ordering
    --         Path component = (10000000 - SortNo) so higher SortNo â†’ smaller value â†’ sorts first
    CREATE TEMP TABLE O ON COMMIT DROP AS WITH RECURSIVE DFS AS (
        SELECT No, IsFolder,
               CAST(RIGHT('0000000' || CAST(10000000 - SortNo AS text), 7) AS text) AS SortPath
        FROM T WHERE ParentNo = 0
        UNION ALL
        SELECT t.No, t.IsFolder,
               d.SortPath || '|' || RIGHT('0000000' || CAST(10000000 - t.SortNo AS text), 7)
        FROM T t INNER JOIN DFS d ON t.ParentNo = d.No AND d.IsFolder = TRUE
    )
    SELECT No, IsFolder, SortPath FROM DFS;

    -- Step 4: Build JSON array using FOR XML PATH (SQL 2008 R2 compatible);


    json := (COALESCE(array_to_string(ARRAY(
SELECT
',' || '{"id":"' || CASE WHEN t.IsFolder = TRUE THEN 'f' ELSE 'b' END || CAST(t.No AS text) || '",' || '"parent":"' || CASE WHEN t.ParentNo=0 THEN '#' ELSE 'f' || CAST(t.ParentNo AS text) END || '",' || '"text":"' || REPLACE(REPLACE(
CASE WHEN t.IsFolder = FALSE AND t.CountContent>0
THEN t.Name || ' <span class=''submenu_board_content_count''>' || CAST(t.CountContent AS text) || '</span>'
ELSE t.Name END,
'\', '\\'), '"', '\"') || '",' || '"icon":"' || CASE WHEN t.IsFolder = TRUE THEN 'fa fa-folder' ELSE 'fa fa-file-o' END || '",' || '"li_attr":{"type":"' || CASE WHEN t.IsFolder = TRUE THEN '0' ELSE CAST(t.ViewMode AS text) END || '","RegUserNo":' || CAST(t.ModUserNo AS text) || '},' || '"data":{' || '"title":"' || REPLACE(REPLACE(COALESCE(t.Name,''), '\','\\'), '"','\"') || '",' || '"boardlist":' || CASE WHEN t.IsFolder = TRUE
THEN '"' || COALESCE(bl.Boardlist, '') || '"'
ELSE 'null' END || ',' || '"jsonName":"' || REPLACE(REPLACE(COALESCE(t.JsonName,''), '\','\\'), '"','\"') || '"' || '},' || '"state":' || CASE WHEN t.IsFolder = TRUE AND NOT EXISTS (SELECT 1 FROM T c WHERE c.ParentNo=t.No)
THEN 'null'
ELSE '{"opened":' || CASE WHEN t.IsFolder = FALSE THEN 'true'
WHEN t.IsOpen = TRUE   THEN 'true'
ELSE 'false' END || ',"disabled":false,"selected":' || CASE WHEN t.IsSelected = TRUE THEN 'true' ELSE 'false' END || '}'
END || '}'
FROM T t
INNER JOIN O o  ON t.No = o.No AND t.IsFolder = o.IsFolder
LEFT  JOIN BL bl ON t.IsFolder = TRUE AND bl.FolderNo = t.No
ORDER BY o.SortPath), ''), ''));


















    RETURN QUERY
    SELECT '[' || STUFF(COALESCE(Json, ''), 1, 1, '') + ']' AS JsonData;

    DROP TABLE IF EXISTS T;
    DROP TABLE IF EXISTS O;
    DROP TABLE IF EXISTS BL;
END;
$function$

```
</details>

## `board_getuserbyshare`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_getuserbyshare"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_getuserbyshare(integer) line 5 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_getuserbyshare(contentno integer DEFAULT 5347)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF (SELECT COUNT(B.BoardNo) FROM Board_Contents C INNER JOIN Board_Boards B ON B.BoardNo=C.BoardNo AND B.SpecType=0 WHERE ContentNo=board_getuserbyshare.contentno AND B.SpecType=1)>0 THEN
	RETURN QUERY
	WITH PERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Board_AllowAccess
		WHERE ItemType=2 AND ItemNo=board_getuserbyshare.contentno
	),
	SHARE AS(
		SELECT U.UserNo ,U.UserID,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
			SELECT U.UserNo,U.UserID,OP.DepartNo
			FROM Organization_Users U
			INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
			WHERE U.Enabled = TRUE
			) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
		WHERE BS.ContentNo=board_getuserbyshare.contentno
		UNION ALL
		SELECT DISTINCT U.UserNo, U.UserID,ContentNo AS ContentNo
			FROM Organization_Users U
			WHERE U.Enabled = TRUE AND (SELECT COUNT(*) FROM Board_Contents WHERE ContentNo=board_getuserbyshare.contentno AND IsShareAll = TRUE)>0
	)
	SELECT DISTINCT  S.UserNo
	FROM SHARE S
	INNER JOIN Board_Contents BC ON S.ContentNo=BC.ContentNo
	INNER JOIN PERMISSION P ON P.ItemNo=BC.BoardNo;

ELSE
	RETURN QUERY
	WITH RECURSIVE SHARE AS (
		SELECT U.UserNo ,U.UserID,BS.ContentNo
		FROM Board_Sharers BS
		INNER JOIN (
			SELECT U.UserNo,U.UserID,OP.DepartNo
			FROM Organization_Users U
			INNER JOIN Organization_BelongToDepartment OP ON OP.UserNo=U.UserNo
			WHERE U.Enabled = TRUE
			) U ON U.UserNo=BS.UserNo OR U.DepartNo=BS.DepartNo
		WHERE BS.ContentNo=board_getuserbyshare.contentno
		UNION ALL
		SELECT DISTINCT U.UserNo, U.UserID,ContentNo AS ContentNo
			FROM Organization_Users U
			WHERE U.Enabled = TRUE AND (SELECT COUNT(*) FROM Board_Contents WHERE ContentNo=board_getuserbyshare.contentno AND IsShareAll = TRUE)>0
	)
	SELECT DISTINCT  S.UserNo
	FROM SHARE S;
	END IF;
END;
$function$

```
</details>

## `board_insertandroiddevice`

- Input: `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."board_insertandroiddevice"(0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_insertandroiddevice(integer,timestamp without time zone,character varying,character varying,character varying,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertandroiddevice(userno integer, regdate timestamp without time zone, deviceid character varying, osversion character varying, notificationoptions character varying, timezoneoffset integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Board_AndroidDevices WHERE UserNo = board_insertandroiddevice.userno OR DeviceID = board_insertandroiddevice.deviceid;

	INSERT INTO Board_AndroidDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset);


	DeviceNo := lastval();
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$

```
</details>

## `board_insertboardcontent`

- Input: `0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::bigint, 0::integer, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone`
- Generated SQL: `SELECT "public"."board_insertboardcontent"(0::integer, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::bigint, 0::integer, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function board_insertboardcontent(integer,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone,character varying,integer,bigint,integer,integer,integer,boolean,character varying,boolean,integer,timestamp without time zone,timestamp without time zone,boolean,character varying,character varying,character varying,character varying,character varying,character varying,boolean,character varying,character varying,boolean,character varying,character varying,character varying,character varying,character varying,character varying,character varying,integer,boolean,integer,timestamp without time zone,timestamp without time zone,timestamp without time zone,timestamp without time zone) line 10 at assignment
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertboardcontent(boardno integer, moduserno integer, modusername character varying, modpositionno integer, modpositionname character varying, moddepartno integer, moddepartname character varying, regdate timestamp without time zone, title character varying, titleeffect integer, groupno bigint, depth integer, orderno integer, headno integer, isnotice boolean, content character varying, isfile boolean, filecount integer, startdate timestamp without time zone, enddate timestamp without time zone, isshareall boolean, type character varying, errortype character varying, persontype character varying, designno character varying, constructionname character varying, applyto character varying, important boolean, mailrecipientno character varying, mailrecipientname character varying, private boolean, purpose character varying, note character varying, other character varying, inspector character varying, generation character varying, badno character varying, standard character varying, viewmode integer DEFAULT 2, isalarm boolean DEFAULT false, rootid integer DEFAULT 0, visitdate timestamp without time zone DEFAULT NULL::timestamp without time zone, visitcompletedate timestamp without time zone DEFAULT NULL::timestamp without time zone, businessdate timestamp without time zone DEFAULT NULL::timestamp without time zone, dateview timestamp without time zone DEFAULT NULL::timestamp without time zone)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    contentno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GroupNo = 0 THEN

		GroupNo := (SELECT MAX(GroupNo) + 1 FROM Board_Contents WHERE BoardNo = board_insertboardcontent.boardno);
		IF GroupNo IS NULL THEN

			GroupNo := 1;
		END IF;

	END IF;

	UPDATE Board_Contents SET OrderNo = board_insertboardcontent.orderno + 1
	WHERE BoardNo = board_insertboardcontent.boardno AND OrderNo >= board_insertboardcontent.orderno;

	INSERT INTO Board_Contents (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, ModDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		ReplyCount, RecommendedCount, ViewedCount, StartDate, EndDate, Enabled,RegUserNo,  RegPositionNo,  RegDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard)
	VALUES (BoardNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName, ModDepartNo, ModDepartName,
		RegDate, RegDate, Title, TitleEffect, GroupNo, Depth, OrderNo, HeadNo, IsNotice, Content, IsFile, FileCount,
		0, 0, 0, StartDate, EndDate, 1,ModUserNo, ModPositionNo, ModDepartNo,ViewMode,IsAlarm,IsShareAll,Type,ErrorType,PersonType,DesignNo,ConstructionName,VisitDate,VisitCompleteDate,BusinessDate,DateView,ApplyTo,Important,MailRecipientNo,MailRecipientName,Private,Purpose,Note,Other,Inspector,Generation,BadNo,Standard);



	ContentNo := lastval();
	IF RootId=0 THEN
	    UPDATE Board_Contents SET RootId=ContentNo WHERE ContentNo=ContentNo;
	ELSE
	    UPDATE Board_Contents SET RootId=board_insertboardcontent.rootid WHERE ContentNo=ContentNo;
	END IF;
	RETURN QUERY
	SELECT ContentNo;
END;
$function$

```
</details>

## `board_insertcommentsetting`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_insertcommentsetting"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_insertcommentsetting(integer,integer) line 4 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertcommentsetting(userno integer DEFAULT 70, boardno integer DEFAULT 1080)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM  Board_CommentSetting WHERE BoardNo=board_insertcommentsetting.boardno AND IsDelete= FALSE)=0 THEN
	INSERT INTO public."Board_CommentSetting" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,'FALSE' );
	END IF;
END;
$function$

```
</details>

## `board_insertcurrentmanager`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_insertcurrentmanager"(0::integer, 0::integer, 0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "user_no" is ambiguous
- Stack context: PL/pgSQL function board_insertcurrentmanager(integer,integer,integer,integer,timestamp without time zone,integer,integer) line 7 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertcurrentmanager(user_no integer, menu_id integer, auth_grp_id integer, id_insert integer, dts_insert timestamp without time zone, id_update integer, department_id integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    usergroup_id integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF (SELECT COUNT(*) FROM Board_UserByGroup WHERE USER_NO=board_insertcurrentmanager.user_no AND DEPARTMENT_ID=board_insertcurrentmanager.department_id) <=0 THEN
	INSERT INTO Board_UserByGroup (
		USER_NO,
		MENU_ID,
		AUTH_GRP_ID,
		ID_INSERT,
		DTS_INSERT,
		ID_UPDATE,
		DTS_UPDATE,
		DEPARTMENT_ID
	)
	VALUES (
		USER_NO, MENU_ID, 	AUTH_GRP_ID, 	ID_INSERT, 	DTS_INSERT, 	ID_UPDATE, 	NOW(),DEPARTMENT_ID
	);


	USERGROUP_ID := lastval();
	RETURN QUERY
	SELECT USERGROUP_ID;

	ELSE
	 RETURN QUERY
	 SELECT 0;
	END IF;
END;
$function$

```
</details>

## `board_insertiosdevice`

- Input: `0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."board_insertiosdevice"(0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_insertiosdevice(integer,timestamp without time zone,character varying,character varying,character varying,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertiosdevice(userno integer, regdate timestamp without time zone, deviceid character varying, osversion character varying, notificationoptions character varying, timezoneoffset integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Board_IOSDevices WHERE UserNo = board_insertiosdevice.userno OR DeviceID = board_insertiosdevice.deviceid;
	INSERT INTO Board_IOSDevices (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset)
	VALUES (UserNo, RegDate, DeviceID, OSVersion, NotificationOptions, TimezoneOffset);


	DeviceNo := lastval();
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$

```
</details>

## `board_insertmultiboardwidget`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_insertmultiboardwidget"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_insertmultiboardwidget(integer,integer) line 4 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertmultiboardwidget(userno integer DEFAULT 70, boardno integer DEFAULT 1080)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM  Board_MultiBoardWidget WHERE BoardNo=board_insertmultiboardwidget.boardno AND IsDelete= FALSE )=0 THEN
	INSERT INTO public."Board_MultiBoardWidget" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,Sort,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,(SELECT (COALESCE(MAX(Sort),0)+1) FROM Board_MultiBoardWidget WHERE  IsDelete= FALSE),'FALSE' );
	END IF;
END;
$function$

```
</details>

## `board_insertnewboardwidget`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_insertnewboardwidget"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_insertnewboardwidget(integer,integer,integer) line 4 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertnewboardwidget(userno integer DEFAULT 70, boardno integer DEFAULT 1080, type integer DEFAULT 2)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF (SELECT COUNT(*) FROM  Board_NewBoardWidget WHERE BoardNo=board_insertnewboardwidget.boardno AND IsDelete= FALSE AND Type=board_insertnewboardwidget.type)=0 THEN
	INSERT INTO public."Board_NewBoardWidget" (RegUserNo,RegDate, ModUserNo,ModDate,BoardNo,Type,Sort,IsDelete) VALUES(UserNo,NOW(),UserNo,NOW(),BoardNo,Type,(SELECT (COALESCE(MAX(Sort),0)+1) FROM Board_NewBoardWidget WHERE  IsDelete= FALSE),'FALSE' );
	END IF;
END;
$function$

```
</details>

## `board_insertnotificationservice`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- Generated SQL: `SELECT "public"."board_insertnotificationservice"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE);`
- SQLSTATE: `42P01`
- Error: relation "center_notificationservice" does not exist
- Stack context: PL/pgSQL function board_insertnotificationservice(integer,character varying,integer,integer,character varying,character varying,date,date,character varying,character varying,boolean,xml,date) line 13 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertnotificationservice(companyno integer, projectcode character varying, connectionkey integer, senduserno integer, recipientuserno character varying, recipientdepartno character varying, startdate date, enddate date, repeattype character varying, repeatoptions character varying, state boolean, xmldetail xml, execution date DEFAULT NULL::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    notificationno integer;
    dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare


	-- INSERT INTO main;
	INSERT INTO Center_NotificationService(CompanyNo,ProjectCode,Connectionkey,SendUserNo,RecipientUserNo,RecipientDepartNo, StartDate, EndDate, RepeatType, RepeatOptions,State, Execution)
	values (CompanyNo, ProjectCode, Connectionkey, SendUserNo,RecipientUserNo,RecipientDepartNo,StartDate,StartDate,RepeatType,RepeatOptions,State,Execution);

	-- get Notification ID
	-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE
SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE;

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF EXISTS tb;
	DROP TABLE IF EXISTS tb2;
END;
$function$

```
</details>

## `board_insertrecommendedlog`

- Input: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone`
- Generated SQL: `SELECT "public"."board_insertrecommendedlog"(0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_insertrecommendedlog(integer,bigint,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone) line 8 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertrecommendedlog(boardno integer, contentno bigint, userno integer, username character varying, positionno integer, positionname character varying, departno integer, departname character varying, recommendeddate timestamp without time zone)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Board_RecommendedLogs WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno) != 0 THEN
		DELETE FROM public."Board_RecommendedLogs" WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno;
		UPDATE Board_Contents SET RecommendedCount = RecommendedCount -1 WHERE ContentNo = board_insertrecommendedlog.contentno;
		RETURN QUERY
		SELECT CONVERT(BIGINT, 0);
	ELSE

	UPDATE Board_Contents SET RecommendedCount = RecommendedCount + 1 WHERE ContentNo = board_insertrecommendedlog.contentno;

	INSERT INTO Board_RecommendedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate)
	VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate);


	LogNo := lastval();
	RETURN QUERY
	SELECT LogNo;
	 END IF;
END;
$function$

```
</details>

## `board_insertreply`

- Input: `0::bigint, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, 0::bigint, 0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."board_insertreply"(0::bigint, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, 0::bigint, 0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function board_insertreply(bigint,bigint,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone,bigint,integer,integer,character varying) line 10 at assignment
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertreply(parentno bigint, contentno bigint DEFAULT 4742, moduserno integer DEFAULT 222, modusername character varying DEFAULT 'test1'::character varying, modpositionno integer DEFAULT 15, modpositionname character varying DEFAULT 'Staff'::character varying, moddepartno integer DEFAULT 33, moddepartname character varying DEFAULT 'DisDepartment'::character varying, regdate timestamp without time zone DEFAULT '2018-12-06 00:00:00'::timestamp without time zone, groupno bigint DEFAULT 2, depth integer DEFAULT 1, orderno integer DEFAULT 7, content character varying DEFAULT 'lv2'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    replyno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GroupNo = 0 THEN

		GroupNo := (SELECT MAX(GroupNo) + 1 FROM Board_Replies WHERE ContentNo = board_insertreply.contentno);
		IF GroupNo IS NULL THEN

			GroupNo := 1;
		END IF;

	END IF;

	UPDATE Board_Replies SET OrderNo = board_insertreply.orderno + 1
	WHERE ContentNo = board_insertreply.contentno AND OrderNo >= board_insertreply.orderno;

	INSERT INTO Board_Replies (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, ModDate, GroupNo, Depth, OrderNo, Content,ParentNo)
	VALUES (ContentNo, ModUserNo, ModUserName, ModPositionNo, ModPositionName,
		ModDepartNo, ModDepartName, RegDate, RegDate, GroupNo, Depth, OrderNo, Content,ParentNo);


	ReplyNo := lastval();
	RETURN QUERY
	SELECT ReplyNo;

	UPDATE Board_Contents SET ReplyCount = ReplyCount + 1 WHERE ContentNo = board_insertreply.contentno;
END;
$function$

```
</details>

## `board_insertviewedlog`

- Input: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying`
- Generated SQL: `SELECT "public"."board_insertviewedlog"(0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_insertviewedlog(integer,bigint,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone,character varying) line 8 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_insertviewedlog(boardno integer DEFAULT 1, contentno bigint DEFAULT 5547, userno integer DEFAULT 70, username character varying DEFAULT 'Nguyen Ngo Giap'::character varying, positionno integer DEFAULT 0, positionname character varying DEFAULT ''::character varying, departno integer DEFAULT 0, departname character varying DEFAULT '관리부'::character varying, vieweddate timestamp without time zone DEFAULT '2022-02-01 03:52:51.05'::timestamp without time zone, clientip character varying DEFAULT ':'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno) > 0 THEN
		SELECT LogNo INTO logno FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno;
	ELSE
		UPDATE Board_Contents SET ViewedCount = ViewedCount + 1 WHERE ContentNo = board_insertviewedlog.contentno;
		INSERT INTO Board_ViewedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP)
		VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP);
		logno := (lastval());

	END IF;
	RETURN QUERY
	SELECT LogNo;
END;
$function$

```
</details>

## `board_mobile_search`

- Input: `''::character varying, 0::integer, false, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_mobile_search"(''::character varying, 0::integer, false, 0::integer, 0::integer);`
- SQLSTATE: `42601`
- Error: syntax error at or near "DESC"
- Stack context: PL/pgSQL function board_mobile_search(character varying,integer,boolean,integer,integer) line 64 at EXECUTE statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_mobile_search(searchtext character varying, sortcolumn integer, isascending boolean, countperpage integer, currentpageindex integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    query character varying;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	/*
	 * 정렬 컬럼
	 */

	IF SortColumn = 1 THEN
	    query := COALESCE(query, '') || COALESCE(('GroupNo '), '');
	END IF;



	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */

	query := COALESCE(query, '') || COALESCE((') RowNum, ContentNo, Content ' || 'FROM Board_Contents WHERE (Title ILIKE ''%' || SearchText || '%'' OR ModUserName ILIKE ''%' || SearchText || '%'') AND  Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	/*
	 * 게시글 검색 시작
	 */

	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,

		ContentNo	BIGINT,
		Content		text
	) ON COMMIT DROP;
	EXECUTE 'INSERT INTO SearchResult ' || query;
	/*
	 * 페이징 계산
	 */






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalPageCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	IF CurrentPageIndex > TotalPageCount THEN
	    CurrentPageIndex := TotalPageCount;
	END IF;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_mobile_search.currentpageindex * CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,
		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT
	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards;


	IF IsHead = TRUE THEN

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended , BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;


	ELSE

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
			FROM Board_Contents BC
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended, BC.ModPositionNo, BC.ModPositionName,BC.FileCount
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;

	END IF;

	RETURN QUERY
	SELECT * FROM TempTable;
	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END;
$function$

```
</details>

## `board_setallhistoryfolder`

- Input: `0::integer, false`
- Generated SQL: `SELECT "public"."board_setallhistoryfolder"(0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_setallhistoryfolder(integer,boolean) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_setallhistoryfolder(userno integer DEFAULT 70, isopen boolean DEFAULT true)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

--DELETE FROM Board_HistoryFolder WHERE  UserNo= UserNo;
INSERT INTO Board_HistoryFolder(UserNo,FolderNo,IsOpen)
SELECT   UserNo AS UseNo,BF.FolderNo,IsOpen AS IsOpen
	FROM Board_Folders   BF
	INNER JOIN Board_HistoryFolder BH ON BH.UserNo=board_setallhistoryfolder.userno AND BH.FolderNo=BF.FolderNo
	WHERE Enabled= TRUE AND BH.HistoryFolderNo IS NULL;
UPDATE Board_HistoryFolder  SET IsOpen=board_setallhistoryfolder.isopen  WHERE  UserNo=board_setallhistoryfolder.userno;
END;
$function$

```
</details>

## `board_setcontentsetting`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."board_setcontentsetting"(0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_setcontentsetting(integer,character varying) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_setcontentsetting(boardno integer, contentsetting character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

DELETE FROM public."Board_ContentSetting" WHERE BoardNo= board_setcontentsetting.boardno;
INSERT INTO public."Board_ContentSetting"(BoardNo,ContentSetting)VALUES( BoardNo,  ContentSetting);
END;
$function$

```
</details>

## `board_sethistoryfolder`

- Input: `0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_sethistoryfolder"(0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "folderno" is ambiguous
- Stack context: PL/pgSQL function board_sethistoryfolder(integer,integer,boolean) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_sethistoryfolder(folderno integer, userno integer, isopen boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

DELETE FROM public."Board_HistoryFolder" WHERE FolderNo= board_sethistoryfolder.folderno AND UserNo= board_sethistoryfolder.userno;
INSERT INTO public."Board_HistoryFolder"(UserNo,FolderNo,IsOpen)VALUES(UserNo,  FolderNo,  IsOpen);
END;
$function$

```
</details>

## `board_setshare`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_setshare"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying = integer
- Stack context: PL/pgSQL function board_setshare(integer,integer,integer,character varying,character varying) line 7 at IF
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_setshare(contentno integer, departno integer, userno integer, ischild character varying, mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN


		DepartName := public."COMNGetDepartName"(DepartNo);
		IF (select count(*) from Board_Sharers b where b.ContentNo = board_setshare.contentno and b.DepartNo=board_setshare.departno and b.Userno=board_setshare.userno)=0 THEN
		INSERT INTO Board_Sharers(ContentNo,DepartNo,DepartName,IsChild,UserNo)
		VALUES(ContentNo,DepartNo,DepartName,IsChild,UserNo);
		END IF;
	ELSE
		DELETE FROM Board_Sharers WHERE ContentNo = board_setshare.contentno;
	END IF;

	RETURN QUERY
	SELECT 0;
END;
$function$

```
</details>

## `board_upboard`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_upboard"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "sortno" is ambiguous
- Stack context: PL/pgSQL function board_upboard(integer) line 12 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upboard(boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN




SELECT FolderNo, SortNo INTO parentno, sortno FROM Board_Boards where BoardNo= board_upboard.boardno;
RANKTEMPNO := 1;
FOR tempno IN SELECT  BoardNo from Board_Boards WHERE PARENTNO=FolderNo AND Enabled = TRUE ORDER BY SortNo ASC,BoardNo ASC LOOP
		UPDATE Board_Boards SET SortNo = RANKTEMPNO WHERE TEMPNO=board_upboard.boardno;

		IF TEMPNO=board_upboard.boardno THEN
			SORTNO := RANKTEMPNO;
		END IF;
		RANKTEMPNO := RANKTEMPNO+1;
		   END LOOP;
UPDATE Board_Boards SET SortNo = SORTNO WHERE SORTNO = SortNo + 1 AND FolderNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Boards SET SortNo = SORTNO - 1 WHERE BoardNo= board_upboard.boardno;
END;
$function$

```
</details>

## `board_upboardbyuser`

- Input: `0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_upboardbyuser"(0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_upboardbyuser(integer,integer,boolean) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upboardbyuser(boardno integer, userno integer DEFAULT 70, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    curentno integer;
    parentno integer;
    downno integer;
    isboard boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, FolderNo INTO curentno, parentno FROM Board_Boards WHERE  BoardNo = board_upboardbyuser.boardno;

SELECT T.SortNo, T.IsBoard INTO downno, isboard FROM (
SELECT BoardNo AS No, SortNo,TRUE AS IsBoard FROM Board_Boards B
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_upboardbyuser.userno
WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo>CurentNo AND ParentNo=B.FolderNo
UNION ALL
SELECT BF.FolderNo AS No, SortNo,FALSE AS IsBoard
FROM  Board_Folders BF
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_upboardbyuser.userno
WHERE  BF.SortNo>CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
ORDER BY SortNo ASC) T ORDER BY T.SortNo ASC;











--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF DownNo >0 AND IsBoard= TRUE THEN
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Boards SET SortNo=DownNo WHERE BoardNo = board_upboardbyuser.boardno ;
IF DownNo >0 AND IsBoard= FALSE THEN
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Boards SET SortNo=DownNo WHERE BoardNo = board_upboardbyuser.boardno ;

END IF;
END IF;
END;
$function$

```
</details>

## `board_updateallowaccess`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_updateallowaccess"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "folderno" is ambiguous
- Stack context: PL/pgSQL function board_updateallowaccess(integer,integer,integer,integer,integer,integer) line 89 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateallowaccess(departno integer DEFAULT 49, positionno integer DEFAULT 23, userno integer DEFAULT 6656, allowvalue integer DEFAULT 2, itemno integer DEFAULT 137, itemtype integer DEFAULT 1)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    no bigint;
    value integer;
    folderno integer;
    prentaccessno bigint;
    parentvalue integer;
    folderno1 integer;
    no1 bigint;
BEGIN

	IF ItemType=2 THEN
		DELETE FROM Board_AllowAccess
		WHERE UserNo = board_updateallowaccess.userno AND ItemNo=board_updateallowaccess.itemno AND ItemType= board_updateallowaccess.itemtype; -- AND DepartNo=DepartNo AND PositionNo= PositionNo
		IF AllowValue >0 THEN
			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
			VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,NOW(),NOW());
			CREATE TEMP TABLE FolderTemp1 ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updateallowaccess.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderNos F
			LEFT JOIN Board_AllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.UserNo=board_updateallowaccess.userno;



			WHILE (Select Count(*) From FolderTemp1) > 0 LOOP
				SELECT AllowAccessNo, AllowValue, FolderNo INTO no, value, folderno FROM FolderTemp1;
				IF AllowValue >0 THEN
					IF No=0 THEN
						INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
						SELECT DepartNo,PositionNo,UserNo,AllowValue,FT.FolderNo,1,NOW(),NOW() FROM FolderTemp1 FT;

					ELSE
						IF AllowValue>Value THEN
							RAISE NOTICE '%', No;
							UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno WHERE AllowAccessNo=No;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderTemp1 Where FolderNo = FolderNo;

			END LOOP;
		END IF;

	ELSE
		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH RECURSIVE FolderParentNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updateallowaccess.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderParentNos F
		LEFT JOIN Board_AllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.UserNo=board_updateallowaccess.userno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP

			SELECT AllowAccessNo, AllowValue, FolderNo INTO prentaccessno, parentvalue, folderno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
						SELECT DepartNo,PositionNo,UserNo,AllowValue,FT.FolderNo,1,NOW(),NOW() FROM FolderParentTemp FT;

					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN
							RAISE NOTICE '%', No;
							UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderParentTemp Where FolderNo = FolderNo1;
		END LOOP;
		CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
			SELECT     PF.FolderNo
			FROM       Board_Folders PF
			WHERE PF.FolderNo=board_updateallowaccess.itemno AND PF.Enabled = TRUE
			UNION ALL
			SELECT     CF.FolderNo
			FROM       Board_Folders CF
			INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
		)
		---List FolderNo
		SELECT FolderNo FROM FolderNos;
		----List BoardNo
		CREATE TEMP TABLE BoardTemp ON COMMIT DROP AS SELECT BoardNo FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);

		WHILE (Select Count(*) From FolderTemp) > 0 LOOP
			SELECT FolderNo INTO no1 FROM FolderTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_AllowAccess WHERE ItemType=1 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue)>0 THEN
					RAISE NOTICE '%', No1;
					UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue;
				END IF;
			END IF;

			DELETE FROM FolderTemp Where FolderNo = No1;

		END LOOP;
		WHILE (Select Count(*) From BoardTemp) > 0 LOOP
			SELECT BoardNo INTO no1 FROM BoardTemp;
			--Print AllowValue
			--DELETE FROM Board_AllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_AllowAccess WHERE ItemType=2 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue)>0 THEN
					RAISE NOTICE '%', No1;
					UPDATE Board_AllowAccess SET AllowValue=board_updateallowaccess.allowvalue,DepartNo=board_updateallowaccess.departno,PositionNo=board_updateallowaccess.positionno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND UserNo=board_updateallowaccess.userno AND AllowValue>board_updateallowaccess.allowvalue;
				END IF;
			END IF;
			DELETE FROM BoardTemp Where BoardNo = No1;
		END LOOP;
	END IF;

	--IF(ItemType=2)
	--BEGIN
	--	DELETE FROM Board_AllowAccess
	--	WHERE UserNo = UserNo AND ItemNo=ItemNo AND ItemType= ItemType-- AND DepartNo=DepartNo AND PositionNo= PositionNo
	--	IF (AllowValue >0 )
	--	BEGIN
	--		INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--		VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,NOW(),NOW())
	--	END
	--END
	--ELSE BEGIN
	--	WITH FolderNos AS
	--	(
	--		SELECT     PF.FolderNo
	--		FROM       Board_Folders PF
	--		WHERE PF.FolderNo=ItemNo AND PF.Enabled = TRUE
	--		UNION ALL
	--		SELECT     CF.FolderNo
	--		FROM       Board_Folders CF
	--		INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
	--	)
	--	---List FolderNo
	--	SELECT FolderNo
	--	INTO   FolderTemp
	--	FROM FolderNos
	--	----List BoardNo
	--	SELECT BoardNo
	--	INTO   BoardTemp
	--	FROM Board_Boards
	--	WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp)
	--	Declare No BIGINT
	--	WHILE (Select Count(*) From FolderTemp) > 0
	--	BEGIN
	--		SELECT FolderNo INTO no From FolderTemp
	--		Print AllowValue
	--		DELETE FROM Board_AllowAccess
	--		WHERE UserNo = UserNo  AND ItemNo=No AND ItemType= 1
	--		IF (AllowValue >0 )
	--		BEGIN
	--			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--			VALUES(DepartNo,PositionNo,UserNo,AllowValue,No,1,NOW(),NOW())
	--		END

	--		DELETE FROM FolderTemp Where FolderNo = No

	--	END
	--	WHILE (Select Count(*) From BoardTemp) > 0
	--	BEGIN
	--		SELECT BoardNo INTO no From BoardTemp
	--		Print AllowValue
	--		DELETE FROM Board_AllowAccess
	--		WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
	--		IF (AllowValue >0 )
	--		BEGIN
	--			INSERT INTO public."Board_AllowAccess"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ItemType,ModDate,RegDate)
	--			VALUES(DepartNo,PositionNo,UserNo,AllowValue,No,2,NOW(),NOW())
	--		END
	--		DELETE FROM BoardTemp Where BoardNo = No
	--	END
	--END
	SELECT ItemNo;
END;
$function$

```
</details>

## `board_updateandroiddevice_notificationoptions`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_updateandroiddevice_notificationoptions"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_updateandroiddevice_notificationoptions(integer,character varying,character varying) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateandroiddevice_notificationoptions(userno integer DEFAULT 70, deviceid character varying DEFAULT 'cQXYrFi-zgI:APA91bFO_-wi3QTdAe11ZOORe4FKXLHTqNDzxRMlEaciOT2ArI1Jht1-Z8jd2uaQ32i3mk5HdCPF4CN_pQTZJrPQ7_wbZsVvVEPaJ2_AfT9h9UMokm-UaJQ'::character varying, notificationoptions character varying DEFAULT '{\"enabled\": true,\"sound\": true,\"vibrate\": true,\"notitime\": false,\"starttime\": \"08:00\",\"endtime\": \"18:00\"}'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_AndroidDevices SET
		NotificationOptions = board_updateandroiddevice_notificationoptions.notificationoptions
	WHERE UserNo = board_updateandroiddevice_notificationoptions.userno AND DeviceID = board_updateandroiddevice_notificationoptions.deviceid;
END;
$function$

```
</details>

## `board_updateandroiddevice_timezoneoffset`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."board_updateandroiddevice_timezoneoffset"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_updateandroiddevice_timezoneoffset(integer,character varying,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateandroiddevice_timezoneoffset(userno integer, deviceid character varying, timezoneoffset integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_AndroidDevices SET
		TimezoneOffset = board_updateandroiddevice_timezoneoffset.timezoneoffset
	WHERE UserNo = board_updateandroiddevice_timezoneoffset.userno AND DeviceID = board_updateandroiddevice_timezoneoffset.deviceid;
END;
$function$

```
</details>

## `board_updateapprovaldoc`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."board_updateapprovaldoc"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateapprovaldoc(integer,character varying,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateapprovaldoc(contentno integer, status character varying, userno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

UPDATE Board_Contents
SET ApplyTo=board_updateapprovaldoc.status,ModUserNo=board_updateapprovaldoc.userno, ModDate=NOW()
Where ContentNo= board_updateapprovaldoc.contentno;
END;
$function$

```
</details>

## `board_updateboard`

- Input: `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false`
- Generated SQL: `SELECT "public"."board_updateboard"(0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, 0::integer, 0::integer, 0::integer, false, false, false, false, 0::integer, false);`
- SQLSTATE: `42P01`
- Error: missing FROM-clause entry for table "board_boards"
- Stack context: PL/pgSQL function board_updateboard(integer,integer,timestamp without time zone,character varying,character varying,integer,integer,integer,boolean,boolean,boolean,boolean,integer,boolean) line 4 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboard(boardno integer, moduserno integer, moddate timestamp without time zone, name character varying, description character varying, folderno integer, displaytypeno integer, sortno integer, isreply boolean, ishead boolean, isnotice boolean, isrecommend boolean, recommendeddisplaycount integer, enabled boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE public."Board_Boards"
   SET ModUserNo = board_updateboard.moduserno
      ,ModDate = board_updateboard.moddate
      ,Name = board_updateboard.name
      ,Description = board_updateboard.description
      ,FolderNo = board_updateboard.folderno
      ,DisplayTypeNo = board_updateboard.displaytypeno
      ,SortNo = board_updateboard.sortno
      ,IsReply = board_updateboard.isreply
      ,IsHead = board_updateboard.ishead
      ,IsNotice = board_updateboard.isnotice
      ,IsRecommend = board_updateboard.isrecommend
      ,RecommendedDisplayCount = board_updateboard.recommendeddisplaycount
      ,Enabled = board_updateboard.enabled
 WHERE Board_Boards.BoardNo=board_updateboard.boardno;
END;
$function$

```
</details>

## `board_updateboardcontent`

- Input: `0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, false, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone`
- Generated SQL: `SELECT "public"."board_updateboardcontent"(0::integer, 0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false, ''::character varying, false, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, false, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, false, false, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent(integer,bigint,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone,character varying,integer,integer,boolean,character varying,boolean,integer,timestamp without time zone,timestamp without time zone,character varying,character varying,character varying,character varying,character varying,character varying,boolean,character varying,character varying,boolean,character varying,character varying,character varying,character varying,character varying,character varying,character varying,boolean,boolean,timestamp without time zone,timestamp without time zone,timestamp without time zone,timestamp without time zone) line 6 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent(boardno integer, contentno bigint, moduserno integer, modusername character varying, modpositionno integer, modpositionname character varying, moddepartno integer, moddepartname character varying, moddate timestamp without time zone, title character varying, titleeffect integer, headno integer, isnotice boolean, content character varying, isfile boolean, filecount integer, startdate timestamp without time zone, enddate timestamp without time zone, type character varying, errortype character varying, persontype character varying, designno character varying, constructionname character varying, applyto character varying, important boolean, mailrecipientno character varying, mailrecipientname character varying, private boolean, purpose character varying, note character varying, other character varying, inspector character varying, generation character varying, badno character varying, standard character varying, isalarm boolean DEFAULT false, isshareall boolean DEFAULT false, visitdate timestamp without time zone DEFAULT NULL::timestamp without time zone, visitcompletedate timestamp without time zone DEFAULT NULL::timestamp without time zone, businessdate timestamp without time zone DEFAULT NULL::timestamp without time zone, dateview timestamp without time zone DEFAULT NULL::timestamp without time zone)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Board_Contents SET
		BoardNo = board_updateboardcontent.boardno,
		ModUserNo = board_updateboardcontent.moduserno,
		--ModUserName = ModUserName,
		ModPositionNo = board_updateboardcontent.modpositionno,
		--ModPositionName = ModPositionName,
		ModDepartNo = board_updateboardcontent.moddepartno,
		--ModDepartName = ModDepartName,
		ModDate = board_updateboardcontent.moddate,
		Title = board_updateboardcontent.title,
		TitleEffect = board_updateboardcontent.titleeffect,
		HeadNo = board_updateboardcontent.headno,
		IsNotice = board_updateboardcontent.isnotice,
		Content = board_updateboardcontent.content,
		IsFile = board_updateboardcontent.isfile,
		FileCount = board_updateboardcontent.filecount,
		StartDate = board_updateboardcontent.startdate,
		EndDate = board_updateboardcontent.enddate,
		IsAlarm=board_updateboardcontent.isalarm,
		IsShareAll=board_updateboardcontent.isshareall,
		Type = board_updateboardcontent.type,
		ErrorType = board_updateboardcontent.errortype,
		PersonType = board_updateboardcontent.persontype,
		DesignNo = board_updateboardcontent.designno,
		ConstructionName = board_updateboardcontent.constructionname,
		VisitDate=board_updateboardcontent.visitdate,
		VisitCompleteDate=board_updateboardcontent.visitcompletedate,
		BusinessDate=board_updateboardcontent.visitcompletedate,
		DateView=board_updateboardcontent.dateview,
		ApplyTo=board_updateboardcontent.applyto,
		Important=board_updateboardcontent.important,
		MailRecipientNo=board_updateboardcontent.mailrecipientno,
		MailRecipientName=board_updateboardcontent.mailrecipientname,
		Private=board_updateboardcontent.private,
		Purpose=board_updateboardcontent.purpose,
		Note=board_updateboardcontent.note,
		Other=board_updateboardcontent.other,
		Inspector=board_updateboardcontent.inspector,
		Generation=board_updateboardcontent.generation,
		BadNo=board_updateboardcontent.badno,
		Standard=board_updateboardcontent.standard
	WHERE ContentNo = board_updateboardcontent.contentno;

	--SELECT IsAlarm
END;
$function$

```
</details>

## `board_updateboardcontent_content`

- Input: `0::bigint, ''::character varying`
- Generated SQL: `SELECT "public"."board_updateboardcontent_content"(0::bigint, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_content(bigint,character varying) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_content(contentno bigint, content character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		Content = board_updateboardcontent_content.content
	WHERE ContentNo = board_updateboardcontent_content.contentno;
END;
$function$

```
</details>

## `board_updateboardcontent_enabled`

- Input: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false`
- Generated SQL: `SELECT "public"."board_updateboardcontent_enabled"(0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_enabled(bigint,timestamp without time zone,boolean) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_enabled(contentno bigint, moddate timestamp without time zone, enabled boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_enabled.moddate,
		Enabled = board_updateboardcontent_enabled.enabled
	WHERE ContentNo = board_updateboardcontent_enabled.contentno;
END;
$function$

```
</details>

## `board_updateboardcontent_enabledforuser`

- Input: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false, 0::integer`
- Generated SQL: `SELECT "public"."board_updateboardcontent_enabledforuser"(0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_enabledforuser(bigint,timestamp without time zone,boolean,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_enabledforuser(contentno bigint, moddate timestamp without time zone, enabled boolean, userno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_enabledforuser.moddate,
		Enabled = board_updateboardcontent_enabledforuser.enabled
	WHERE ContentNo = board_updateboardcontent_enabledforuser.contentno AND RegUserNo = board_updateboardcontent_enabledforuser.userno;
END;
$function$

```
</details>

## `board_updateboardcontent_isnotice`

- Input: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false`
- Generated SQL: `SELECT "public"."board_updateboardcontent_isnotice"(0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, false);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_isnotice(bigint,timestamp without time zone,boolean) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_isnotice(contentno bigint, moddate timestamp without time zone, isnotice boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_isnotice.moddate,
		IsNotice = board_updateboardcontent_isnotice.isnotice
	WHERE ContentNo = board_updateboardcontent_isnotice.contentno;
END;
$function$

```
</details>

## `board_updateboardcontent_titleeffect`

- Input: `0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer`
- Generated SQL: `SELECT "public"."board_updateboardcontent_titleeffect"(0::bigint, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_titleeffect(bigint,timestamp without time zone,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_titleeffect(contentno bigint, moddate timestamp without time zone, titleeffect integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ModDate = board_updateboardcontent_titleeffect.moddate,
		TitleEffect = board_updateboardcontent_titleeffect.titleeffect
	WHERE ContentNo = board_updateboardcontent_titleeffect.contentno;
END;
$function$

```
</details>

## `board_updateboardcontent_viewed`

- Input: `0::bigint`
- Generated SQL: `SELECT "public"."board_updateboardcontent_viewed"(0::bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcontent_viewed(bigint) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcontent_viewed(contentno bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Contents SET
		ViewedCount = ViewedCount + 1
	WHERE ContentNo = board_updateboardcontent_viewed.contentno;
END;
$function$

```
</details>

## `board_updateboardcustorm`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_updateboardcustorm"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_updateboardcustorm(integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateboardcustorm(boardno integer DEFAULT 49, boardtype integer DEFAULT 23)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

		UPDATE Board_Boards SET ViewMode=board_updateboardcustorm.boardtype WHERE BoardNo=board_updateboardcustorm.boardno;
END;
$function$

```
</details>

## `board_updateconfig`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_updateconfig"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "configkey" is ambiguous
- Stack context: PL/pgSQL function board_updateconfig(integer,character varying,character varying) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateconfig(userno integer, configkey character varying, configvalue character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    temp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT ConfigNo INTO temp FROM Board_Config

	WHERE ConfigKey = board_updateconfig.configkey;

	IF Temp > 0 THEN
		UPDATE Board_Config SET ConfigValue=board_updateconfig.configvalue,LastestDate=NOW(),UserNo= board_updateconfig.userno WHERE ConfigNo=Temp;
	ELSE
		INSERT INTO Board_Config(ConfigKey,ConfigValue,UserNo,LastestDate) VALUES (ConfigKey,ConfigValue,UserNo,NOW());
		Temp := lastval();
	END IF;

	RETURN QUERY
	SELECT Temp;
END;
$function$

```
</details>

## `board_updatedepartallowaccess`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_updatedepartallowaccess"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "folderno" is ambiguous
- Stack context: PL/pgSQL function board_updatedepartallowaccess(integer,integer,integer,integer,integer) line 95 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatedepartallowaccess(departno integer DEFAULT 4, allowvalue integer DEFAULT 2, itemno integer DEFAULT 1160, itemtype integer DEFAULT 2, userno integer DEFAULT 70)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    no bigint;
    value integer;
    folderno integer;
    prentaccessno bigint;
    parentvalue integer;
    folderno1 integer;
    no1 bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	--UPDATE Board_DepartAllowAccess SET DepartNo=DepartNo,AllowValue=AllowValue , ItemNo=ItemNo,ItemType=ItemType,ModUserNo=UserNo,ModDate=NOW()
	--WHERE AllowAccessNo=AllowAccessNo
	--SELECT AllowAccessNo

	IF ItemType=2 THEN
		DELETE FROM Board_DepartAllowAccess
		WHERE DepartNo = board_updatedepartallowaccess.departno AND ItemNo=board_updatedepartallowaccess.itemno AND ItemType= board_updatedepartallowaccess.itemtype;
		IF AllowValue >0 THEN
			INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
			VALUES(DepartNo,AllowValue,ItemNo,ItemType,UserNo,NOW(),UserNo,NOW());
			CREATE TEMP TABLE FolderTemp1 ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderNos F
			LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno;



			WHILE (Select Count(*) From FolderTemp1) > 0 LOOP
				SELECT AllowAccessNo, AllowValue, FolderNo INTO no, value, folderno FROM FolderTemp1;
				IF AllowValue >0 THEN
					IF No=0 THEN
						INSERT INTO  public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderTemp1 FT;

					ELSE
						IF AllowValue>Value THEN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno WHERE AllowAccessNo=No;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderTemp1 Where FolderNo = FolderNo;

			END LOOP;
		END IF;

	ELSE
		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH RECURSIVE FolderParentNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updatedepartallowaccess.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.FolderNo FROM FolderParentNos F
		LEFT JOIN Board_DepartAllowAccess BA ON BA.ItemType=1 AND BA.ItemNo=F.FolderNo AND BA.DepartNo=board_updatedepartallowaccess.departno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP

			SELECT AllowAccessNo, AllowValue, FolderNo INTO prentaccessno, parentvalue, folderno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.FolderNo,1,UserNo,NOW(),UserNo,NOW() FROM FolderParentTemp FT;

					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN
							RAISE NOTICE '%', No;
							UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderParentTemp Where FolderNo = FolderNo1;
		END LOOP;
		CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
			SELECT     PF.FolderNo
			FROM       Board_Folders PF
			WHERE PF.FolderNo=board_updatedepartallowaccess.itemno AND PF.Enabled = TRUE
			UNION ALL
			SELECT     CF.FolderNo
			FROM       Board_Folders CF
			INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
		)
		---List FolderNo;;
		SELECT FolderNo FROM FolderNos;
		----List BoardNo
		CREATE TEMP TABLE BoardTemp ON COMMIT DROP AS SELECT BoardNo FROM Board_Boards
		WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);

		WHILE (Select Count(*) From FolderTemp) > 0 LOOP
			SELECT FolderNo INTO no1 FROM FolderTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno)>0 THEN
					--Print No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemType=1 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW());
				END IF;

			END IF;

			DELETE FROM FolderTemp Where FolderNo = No1;

		END LOOP;
		WHILE (Select Count(*) From BoardTemp) > 0 LOOP
			SELECT BoardNo INTO no1 FROM BoardTemp;
			--Print AllowValue
			--DELETE FROM Board_DepartAllowAccess
			--WHERE UserNo = UserNo AND ItemNo=No AND ItemType= 2
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Board_DepartAllowAccess WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno )>0 THEN
					--Print  No1;
					UPDATE Board_DepartAllowAccess SET AllowValue=board_updatedepartallowaccess.allowvalue,DepartNo=board_updatedepartallowaccess.departno,ModUserNo=board_updatedepartallowaccess.userno,ModDate=NOW()  WHERE ItemType=2 AND ItemNo=No1 AND DepartNo=board_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,2,UserNo,NOW(),UserNo,NOW());
				END IF;
			END IF;
			DELETE FROM BoardTemp Where BoardNo = No1;
		END LOOP;
	END IF;
END;
$function$

```
</details>

## `board_updatefile`

- Input: `0::bigint, 0::bigint, ''::character varying, 0::bigint, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."board_updatefile"(0::bigint, 0::bigint, ''::character varying, 0::bigint, ''::character varying) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "fileno" is ambiguous
- Stack context: PL/pgSQL function board_updatefile(bigint,bigint,character varying,bigint,character varying) line 6 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatefile(fileno bigint, contentno bigint, name character varying, size bigint, filepath character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	Update Board_Files
	SET ContentNo=board_updatefile.contentno,Name=board_updatefile.name,Size=board_updatefile.size,Url=board_updatefile.filepath
	WHERE FileNo=board_updatefile.fileno;
	RETURN QUERY
	SELECT FileNo;
END;
$function$

```
</details>

## `board_updatefolder`

- Input: `0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_updatefolder"(0::integer, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "levelrand" is ambiguous
- Stack context: PL/pgSQL function board_updatefolder(integer,integer,timestamp without time zone,character varying,integer,integer,boolean) line 13 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatefolder(folderno integer, moduserno integer, moddate timestamp without time zone, name character varying, parentno integer, sortno integer, enabled boolean)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    levelrand character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF PARENTNO >0 THEN
		SELECT LevelRand + CONVERT(nvarchar(20), FolderNo) + ',' INTO levelrand FROM Board_Folders WHERE FolderNo=board_updatefolder.parentno;
	ELSE
		LevelRand := ',';
	END IF;

UPDATE public."Board_Folders"
   SET ModUserNo = board_updatefolder.moduserno
      ,ModDate = board_updatefolder.moddate
      ,Name = board_updatefolder.name
      ,ParentNo = board_updatefolder.parentno
      ,SortNo = board_updatefolder.sortno
      ,Enabled = board_updatefolder.enabled
	  ,LevelRand = LevelRand
 WHERE FolderNo=board_updatefolder.folderno;
END;
$function$

```
</details>

## `board_updateiosdevice_notificationoptions`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_updateiosdevice_notificationoptions"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_updateiosdevice_notificationoptions(integer,character varying,character varying) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updateiosdevice_notificationoptions(userno integer, deviceid character varying, notificationoptions character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_IOSDevices SET
		NotificationOptions = board_updateiosdevice_notificationoptions.notificationoptions
	WHERE UserNo = board_updateiosdevice_notificationoptions.userno AND DeviceID = board_updateiosdevice_notificationoptions.deviceid;
END;
$function$

```
</details>

## `board_updatelevelrand`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."board_updatelevelrand"(0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "folderno" is ambiguous
- Stack context: PL/pgSQL function board_updatelevelrand(integer,character varying) line 19 at FOR over SELECT rows
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatelevelrand(parentid integer, parentrand character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    folderno integer;
    levelrand character varying;
BEGIN


	IF ParentId = 0 THEN
		UPDATE Board_Folders SET LevelRand =  ',' WHERE ParentNo= board_updatelevelrand.parentid;
	ELSE
		UPDATE Board_Folders SET LevelRand = board_updatelevelrand.parentrand  + CAST(ParentId AS text) + ',' WHERE ParentNo= board_updatelevelrand.parentid;
	END IF;






		FOR folderno, levelrand IN SELECT FolderNo,LevelRand FROM Board_Folders WHERE ParentNo= board_updatelevelrand.parentid LOOP


		PERFORM board_updatelevelrand(FolderNo, LevelRand);

			END LOOP;
END;
$function$

```
</details>

## `board_updatenoticepermission`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."board_updatenoticepermission"(0::integer, 0::integer, 0::integer, 0::integer, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function board_updatenoticepermission(integer,integer,integer,integer,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatenoticepermission(departno integer DEFAULT 49, positionno integer DEFAULT 23, userno integer DEFAULT 6656, allowvalue integer DEFAULT 2, itemno integer DEFAULT 137)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	DELETE FROM Board_NoticePermission
	WHERE UserNo = board_updatenoticepermission.userno AND ItemNo=board_updatenoticepermission.itemno;
	IF AllowValue >0 THEN
		INSERT INTO public."Board_NoticePermission"(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,ModDate,RegDate)
		VALUES(DepartNo,PositionNo,UserNo,AllowValue,ItemNo,NOW(),NOW());
	END IF;
	RETURN QUERY
	SELECT ItemNo;
END;
$function$

```
</details>

## `board_updatenotificationservice`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE`
- Generated SQL: `SELECT "public"."board_updatenotificationservice"(0::integer, ''::character varying, 0::integer, 0::integer, ''::character varying, ''::character varying, CURRENT_DATE, CURRENT_DATE, ''::character varying, ''::character varying, false, '<root />'::xml, CURRENT_DATE);`
- SQLSTATE: `42601`
- Error: query has no destination for result data
- Stack context: PL/pgSQL function board_updatenotificationservice(integer,character varying,integer,integer,character varying,character varying,date,date,character varying,character varying,boolean,xml,date) line 13 at SQL statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatenotificationservice(companyno integer, projectcode character varying, connectionkey integer, senduserno integer, recipientuserno character varying, recipientdepartno character varying, startdate date, enddate date, repeattype character varying, repeatoptions character varying, state boolean, xmldetail xml, execution date DEFAULT NULL::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    notificationno integer;
    dochandle integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- declare

	-- get Notification ID
	-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE
SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE;

	insert into Center_NotificationService_AlarmDetail(NotificationNo,AlarmCode,AlarmStartTime, Alarm_Time,Title,Content_Json)
	select NotificationNo, a.AlarmCode, a.AlarmStartTime, a.AlarmTime,b.Title, b.ContentJson
	from tb a
	join tb2 b on a.Id = b.Id;

	DROP TABLE IF EXISTS tb;
	DROP TABLE IF EXISTS tb2;
END;
$function$

```
</details>

## `board_updatepermissionsbyparent`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_updatepermissionsbyparent"(0::integer, 0::integer);`
- SQLSTATE: `42P01`
- Error: relation "organization_departments" does not exist
- Stack context: PL/pgSQL function board_updatepermissionsbyparent(integer,integer) line 4 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatepermissionsbyparent(departno integer DEFAULT 6403, userno integer DEFAULT 70)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

INSERT INTO Board_DepartAllowAccess (DepartNo, AllowValue,ItemNo,ItemType,ModDate,ModUserNo,RegDate,RegUserNo)
SELECT DepartNo AS DepartNo,BD.AllowValue,BD.ItemNo,BD.ItemType,NOW() AS ModDate,UserNo AS ModUserNo,NOW() AS ModDate,UserNo AS RegUserNo
FROM Board_DepartAllowAccess BD
INNER JOIN Organization_Departments OD ON OD.ParentNo=BD.DepartNo
WHERE OD.DepartNo=board_updatepermissionsbyparent.departno AND OD.Enabled = TRUE;
END;
$function$

```
</details>

## `board_updaterecommendpublic`

- Input: `0::bigint, false`
- Generated SQL: `SELECT * FROM "public"."board_updaterecommendpublic"(0::bigint, false) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updaterecommendpublic(bigint,boolean) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updaterecommendpublic(contentno bigint, isrecommendpublic boolean)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	UPDATE Board_Contents SET IsRecommendPublic = board_updaterecommendpublic.isrecommendpublic  WHERE ContentNo = board_updaterecommendpublic.contentno;
	RETURN QUERY
	SELECT ContentNo;
END;
$function$

```
</details>

## `board_updatereply`

- Input: `0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::bigint`
- Generated SQL: `SELECT "public"."board_updatereply"(0::bigint, 0::integer, ''::character varying, 0::integer, ''::character varying, 0::integer, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying, 0::bigint);`
- SQLSTATE: `42702`
- Error: column reference "replyno" is ambiguous
- Stack context: PL/pgSQL function board_updatereply(bigint,integer,character varying,integer,character varying,integer,character varying,timestamp without time zone,character varying,bigint) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatereply(replyno bigint, moduserno integer, modusername character varying, modpositionno integer, modpositionname character varying, moddepartno integer, moddepartname character varying, moddate timestamp without time zone, content character varying, parentno bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE Board_Replies SET
		ModUserNo = board_updatereply.moduserno,
		ModUserName = board_updatereply.modusername,
		ModPositionNo = board_updatereply.modpositionno,
		ModPositionName = board_updatereply.modpositionname,
		ModDepartNo = board_updatereply.moddepartno,
		ModDepartName = board_updatereply.moddepartname,
		ModDate = board_updatereply.moddate,
		Content = board_updatereply.content,
		ParentNo=board_updatereply.parentno
	WHERE ReplyNo = board_updatereply.replyno;
END;
$function$

```
</details>

## `board_updatespectype`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_updatespectype"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42601`
- Error: query has no destination for result data
- Stack context: PL/pgSQL function board_updatespectype(integer,integer,integer) line 67 at SQL statement
- Root cause: Generated SQL fails when its dynamic/runtime path executes
- Proposed fix: Capture the failing generated statement, repair that conversion path, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatespectype(itemno integer DEFAULT 111, itemtype integer DEFAULT 1, specvalue integer DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF ItemType=2 THEN
		UPDATE Board_Boards
		SET SpecType = board_updatespectype.specvalue
		WHERE  ItemNo=BoardNo;
		IF SpecValue=1 THEN
			CREATE TEMP TABLE FolderTemp1 ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo IN (SELECT FolderNo FROM Board_Boards where BoardNo=board_updatespectype.itemno AND PF.Enabled = TRUE)
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			SELECT FolderNo FROM FolderNos;
			UPDATE Board_Folders
			SET SpecType = board_updatespectype.specvalue
			WHERE  FolderNo IN (SELECT FolderNo FROM FolderTemp1);
		END IF;
	ELSE
		UPDATE Board_Folders
		SET SpecType = board_updatespectype.specvalue
		WHERE FolderNo=board_updatespectype.itemno;
		---List FolderNo
		IF SpecValue=0 THEN
			CREATE TEMP TABLE FolderTemp ON COMMIT DROP AS WITH RECURSIVE FolderNos AS (
				SELECT     PF.FolderNo
				FROM       Board_Folders PF
				WHERE PF.FolderNo=board_updatespectype.itemno AND PF.Enabled = TRUE
				UNION ALL
				SELECT     CF.FolderNo
				FROM       Board_Folders CF
				INNER JOIN FolderNos FN ON FN.FolderNo = CF.ParentNo AND CF.Enabled = TRUE
			)
			SELECT FolderNo FROM FolderNos;
			----List BoardNo
			CREATE TEMP TABLE BoardTemp ON COMMIT DROP AS SELECT BoardNo FROM Board_Boards
			WHERE Enabled = TRUE AND FolderNo IN (SELECT * FROM FolderTemp);
			UPDATE Board_Folders
			SET SpecType = board_updatespectype.specvalue
			WHERE FolderNo<>board_updatespectype.itemno AND  FolderNo IN (SELECT FolderNo FROM FolderTemp);
			DELETE FROM FolderTemp;
			UPDATE Board_Boards
			SET SpecType = board_updatespectype.specvalue
			WHERE  BoardNo IN (SELECT BoardNo FROM BoardTemp);
			DELETE FROM BoardTemp;
		ELSE
			WITH RECURSIVE FolderParentNos AS (
				SELECT     PF.FolderNo , PF.ParentNo
				FROM       Board_Folders PF

				WHERE PF.FolderNo =board_updatespectype.itemno
				UNION ALL
				SELECT     CF.FolderNo , CF.ParentNo
				FROM       Board_Folders CF
				INNER JOIN FolderParentNos FN ON FN.ParentNo = CF.FolderNo AND CF.Enabled = TRUE
			)
			UPDATE Board_Folders
			SET SpecType = board_updatespectype.specvalue
			WHERE FolderNo<>board_updatespectype.itemno AND  FolderNo IN (SELECT FolderNo FROM FolderParentNos);
		END IF;
	END IF;
	SELECT TRUE;
END;
$function$

```
</details>

## `board_updatestatusapproval`

- Input: `0::bigint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."board_updatestatusapproval"(0::bigint, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "contentno" is ambiguous
- Stack context: PL/pgSQL function board_updatestatusapproval(bigint,character varying,character varying,character varying,character varying,character varying,character varying) line 6 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_updatestatusapproval(contentno bigint, type character varying, errortype character varying, persontype character varying, applyto character varying, designno character varying, purpose character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	UPDATE Board_Contents SET
		Type = board_updatestatusapproval.type,
		ErrorType = board_updatestatusapproval.errortype,
		PersonType = board_updatestatusapproval.persontype,
		ApplyTo=board_updatestatusapproval.applyto,
		DesignNo = board_updatestatusapproval.designno,
		Purpose=board_updatestatusapproval.purpose
	WHERE ContentNo = board_updatestatusapproval.contentno;

	--SELECT IsAlarm
END;
$function$

```
</details>

## `board_upfolder`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."board_upfolder"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "parentno" is ambiguous
- Stack context: PL/pgSQL function board_upfolder(integer) line 12 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upfolder(folderno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    foldertempno integer;
    ranktempno integer;
BEGIN




SELECT ParentNo, SortNo INTO parentno, sortno FROM Board_Folders where FolderNo= board_upfolder.folderno;
RANKTEMPNO := 1;
FOR foldertempno IN SELECT FolderNo from Board_Folders WHERE PARENTNO=ParentNo AND Enabled = TRUE ORDER BY SortNo ASC, FolderNo ASC LOOP
		UPDATE Board_Folders SET SortNo = RANKTEMPNO WHERE FOLDERTEMPNO=board_upfolder.folderno;

		IF FOLDERTEMPNO=board_upfolder.folderno THEN
			SORTNO := RANKTEMPNO;
		END IF;

		RANKTEMPNO := RANKTEMPNO + 1;
		   END LOOP;
UPDATE Board_Folders SET SortNo = SORTNO WHERE SORTNO = SortNo + 1 AND ParentNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Folders SET SortNo = SORTNO-1 WHERE FolderNo = board_upfolder.folderno;
END;
$function$

```
</details>

## `board_upfolderbyuser`

- Input: `0::integer, 0::integer, false`
- Generated SQL: `SELECT "public"."board_upfolderbyuser"(0::integer, 0::integer, false);`
- SQLSTATE: `42702`
- Error: column reference "parentno" is ambiguous
- Stack context: PL/pgSQL function board_upfolderbyuser(integer,integer,boolean) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upfolderbyuser(folderno integer DEFAULT 116, userno integer DEFAULT 70, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    curentno integer;
    parentno integer;
    downno integer;
    isfolder boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, ParentNo INTO curentno, parentno FROM Board_Folders WHERE  FolderNo = board_upfolderbyuser.folderno;

SELECT T.SortNo, T.IsFolder INTO downno, isfolder FROM (
SELECT BoardNo AS No, SortNo,FALSE AS IsFolder FROM Board_Boards B
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_upfolderbyuser.userno
WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo>CurentNo AND ParentNo=B.FolderNo
UNION ALL
SELECT BF.FolderNo AS No, SortNo,TRUE AS IsFolder
FROM  Board_Folders BF
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_upfolderbyuser.userno
WHERE  BF.SortNo>CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
ORDER BY SortNo ASC) T ORDER BY T.SortNo ASC;











--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF DownNo >0 AND IsFolder= TRUE THEN
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;
IF DownNo >0 AND IsFolder= FALSE THEN
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;

END IF;
END IF;
END;
$function$

```
</details>

## `board_upmultiwidget`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_upmultiwidget"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_upmultiwidget(integer,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upmultiwidget(userno integer, boardno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_MultiBoardWidget WHERE  BoardNo = board_upmultiwidget.boardno AND  IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_MultiBoardWidget
	WHERE  IsDelete= FALSE AND Sort>=SortTemp
	ORDER BY Sort ASC;
	UPDATE BW SET Sort=(SELECT /* /* TOP 1 */ */ T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),ModUserNo= board_upmultiwidget.userno,ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$

```
</details>

## `board_upwidget`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."board_upwidget"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "boardno" is ambiguous
- Stack context: PL/pgSQL function board_upwidget(integer,integer,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_upwidget(userno integer, boardno integer, type integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_NewBoardWidget WHERE  BoardNo = board_upwidget.boardno AND Type=board_upwidget.type AND IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_NewBoardWidget
	WHERE Type=board_upwidget.type AND IsDelete= FALSE AND Sort>=SortTemp
	ORDER BY Sort ASC;
	UPDATE BW SET Sort=(SELECT /* /* TOP 1 */ */ T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),ModUserNo= board_upwidget.userno,ModDate=NOW()
	FROM Board_NewBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$

```
</details>

## `board_web_search`

- Input: `0::integer, ''::character varying, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer, false, false`
- Generated SQL: `SELECT "public"."board_web_search"(0::integer, ''::character varying, 0::integer, 0::integer, false, 0::integer, 0::integer, ''::character varying, 0::integer, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, 0::integer, 0::integer, false, false);`
- SQLSTATE: `42883`
- Error: function nvarchar(integer) does not exist
- Stack context: PL/pgSQL function board_web_search(integer,character varying,integer,integer,boolean,integer,integer,character varying,integer,timestamp without time zone,timestamp without time zone,integer,integer,boolean,boolean) line 27 at assignment
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.board_web_search(userno integer, searchtext character varying, searchtype integer, sortcolumn integer, isascending boolean, countperpage integer, currentpageindex integer, languagesign character varying, filtertype integer, fromdate timestamp without time zone, todate timestamp without time zone, viewmode integer DEFAULT 2, typeeff integer DEFAULT 0, isalarm boolean DEFAULT false, isadmin boolean DEFAULT false)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    query character varying;
    stralow character varying;
    strwritealow character varying;
    totalitemcount integer;
    totalpagecount integer;
    startrownum integer;
    endrownum integer;
    ishead boolean;
    isnotice boolean;
    isrecommend boolean;
    recommendeddisplaycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	/*
	 * 쿼리 조합 시작
	 */


	Query := 'SELECT ROW_NUMBER() OVER (ORDER BY ';
	strAlow := '';
	strWriteAlow := '';
	IF IsAdmin = FALSE THEN
		strAlow := ' LEFT JOIN (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',2)) AC ON BC.BoardNo=AC.BoardNo LEFT JOIN  (SELECT * FROM public."Board_GetBoardAllow"(' || CONVERT(nvarchar(20), UserNo) + ',4)) AD ON BC.BoardNo=AD.BoardNo ';
		strWriteAlow := '(AC.BoardNo IS NOT NULL OR (AD.BoardNo IS NOT NULL AND BC.RegUserNo = ' || CONVERT(nvarchar(10), UserNo) + ' )) AND ';
	END IF;

	/*
	 * 정렬 컬럼
	 */

	IF SortColumn <= 1 THEN
	    query := COALESCE(query, '') || COALESCE(('BC.RegDate '), '');
	ELSIF SortColumn = 2 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.Title) '), '');
	ELSIF SortColumn = 3 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BB.Name) '), '');
	ELSIF SortColumn = 4 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.ModUserName) '), '');
	ELSIF SortColumn = 5 THEN
	    query := COALESCE(query, '') || COALESCE(('LTRIM(BC.ModDepartName) '), '');
	ELSIF SortColumn  = 6 THEN
	    query := COALESCE(query, '') || COALESCE(('BC.ViewedCount '), '');
	ELSIF SortColumn = 7 THEN
	    query := COALESCE(query, '') || COALESCE(('IsAlarm '), '');
	END IF;



	/*
	 * 정렬 내림차순 여부
	 */

	IF IsAscending = TRUE THEN
	    query := COALESCE(query, '') || COALESCE(('ASC '), '');
	ELSE
	    query := COALESCE(query, '') || COALESCE(('DESC '), '');
	END IF;


	query := COALESCE(query, '') || COALESCE((', BC.OrderNo ASC'), '');



	/*
	 * WHERE 조합 시작
	 */
	IF SearchType = 0 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND  (BC.Title ILIKE ''%' || SearchText || '%'' OR BC.ModUserName ILIKE ''%' || SearchText || '%'' OR  (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.ModUserName ILIKE ''%' || SearchText || '%'' ) > 0 ) AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 1 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.Title ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 2 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.ModUserName ILIKE ''%' || SearchText || '%'' OR  (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.ModUserName ILIKE ''%' || SearchText || '%'' ) > 0) AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 3 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.ModDepartName ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;

	IF SearchType = 4 THEN
	query := COALESCE(query, '') || COALESCE((') RowNum, BC.ContentNo, BC.Content ' || 'FROM Board_Contents BC  INNER JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
' || strAlow || '
WHERE  ' || strWriteAlow || '  BB.Enabled = TRUE AND (BC.RegDate ILIKE ''%' || SearchText || '%'') AND  BC.Enabled = TRUE '), '');
		RAISE NOTICE '%', Query;
	/*
	 * 게시글 검색 시작
	 */

	query := COALESCE(query, '') || COALESCE((' AND ( BC.ViewMode=' || CONVERT(nvarchar(10), ViewMode) || ' OR ' || CONVERT(nvarchar(10), ViewMode) || '< 0) '), '');

	query := COALESCE(query, '') || COALESCE((' AND ( BC.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BC.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || '''  '), '');

	query := COALESCE(query, '') || COALESCE((' OR (SELECT COUNT(*) FROM Board_Replies BR WHERE BR.ContentNo=BC.ContentNo AND  BR.RegDate >= ''' || CONVERT(nvarchar(20), FromDate) || ''' AND BR.RegDate <= ''' || CONVERT(nvarchar(20), ToDate) || ''' ) > 0 ) '), '');

	IF TypeEff > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.TitleEffect <> 2 '), '');
	END IF;
	IF IsAlarm > 0 THEN
		query := COALESCE(query, '') || COALESCE((' AND BC.IsAlarm = TRUE '), '');
	END IF;
	IF FilterType <> 100 THEN
		query := COALESCE(query, '') || COALESCE(('AND BC.RegUserNo <> ' || CONVERT(nvarchar(10), UserNo) || ' AND (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=' || CONVERT(nvarchar(10), UserNo) || ' AND BC.ContentNo=Board_ViewedLogs.ContentNo) <= 0  '), '');
	END IF;


	CREATE TEMP TABLE SearchResult (
		RowNum		BIGINT,

		ContentNo	BIGINT,
		Content		text
	) ON COMMIT DROP;
	EXECUTE 'INSERT INTO SearchResult ' || query;
	/*
	 * 페이징 계산
	 */






	TotalItemCount := (SELECT COUNT(*) FROM SearchResult);
	TotalPageCount := TotalItemCount / CountPerPage;
	IF TotalPageCount % CountPerPage > 0 THEN
	    TotalPageCount := TotalPageCount + 1;
	END IF;
	IF TotalPageCount = 0 THEN
	    TotalPageCount := 1;
	END IF;
	--IF (CurrentPageIndex > TotalPageCount) SET CurrentPageIndex = TotalPageCount;

	StartRowNum := ((CurrentPageIndex - 1) * CountPerPage) + 1;
	EndRowNum := board_web_search.currentpageindex * CountPerPage;
	/*
	 *
	 */

	CREATE TEMP TABLE TempTable (
		ContentNo			BIGINT,
		Content				text,
		ModUserNo			INT,
		ModUserName			varchar(100),
		ModDepartNo			INT,
		ModDepartName		varchar(100),
		RegDate				timestamp,
		Title				varchar(200),
		TitleEffect			INT,
		GroupNo				BIGINT,
		Depth				INT,
		OrderNo				INT,
		HeadNo				INT,
		IsNotice			boolean,
		IsFile				boolean,
		ReplyCount			INT,
		RecommendedCount	INT,
		ViewedCount			INT,

		HeadName			varchar(100),
		IsRecommended		boolean,

		ModPositionNo		INT,
		ModPositionName		varchar(100),
		FileCount			INT,
		BoardNo				INT,
		BoardName			varchar(100),
		RegUserNo			INT,
		RegUserName			varchar(100),
		RegPositionNo		INT,
		RegPositionName		varchar(100),
		RegDepartNo			INT,
		RegDepartName		varchar(100),
		IsAlarm				boolean

	) ON COMMIT DROP;




	SELECT IsHead, IsNotice, IsRecommend, RecommendedDisplayCount INTO ishead, isnotice, isrecommend, recommendeddisplaycount FROM Board_Boards;


	IF IsHead = TRUE THEN

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm

			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.Enabled = TRUE AND BC.IsNotice = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				COALESCE(BH.Name, '') AS HeadName, 1 AS IsRecommended ,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.Enabled = TRUE AND BC.RecommendedCount > 0 and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			COALESCE(BH.Name, '') AS HeadName, 0 AS IsRecommended,

			BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN (SELECT HeadNo, Name FROM Board_Heads) BH ON BH.HeadNo = BC.HeadNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;


	ELSE

		IF IsNotice = TRUE THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 1 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 0 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.IsNotice = TRUE AND BC.Enabled = TRUE;

		END IF;

		IF IsRecommend = TRUE AND RecommendedDisplayCount > 0 THEN

			INSERT INTO TempTable
			SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, 0 AS TitleEffect,
				BC.GroupNo, 0 AS Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

				'' AS HeadName, 1 AS IsRecommended,

				BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
			FROM Board_Contents BC
			LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
			WHERE BC.RecommendedCount > 0 AND BC.Enabled = TRUE and BC.IsNotice = FALSE
			ORDER BY RecommendedCount DESC;

		END IF;

		INSERT INTO TempTable
		SELECT BC.ContentNo, BC.Content, BC.ModUserNo, BC.ModUserName, BC.ModDepartNo, BC.ModDepartName, BC.RegDate, BC.Title, BC.TitleEffect,
			BC.GroupNo, BC.Depth, BC.OrderNo, BC.HeadNo, 0 AS IsNotice, BC.IsFile, BC.ReplyCount, BC.RecommendedCount, BC.ViewedCount,

			'' AS HeadName, 0 AS IsRecommended,

			BC.ModPositionNo, ( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.ModPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.ModPositionNo) end) as ModPositionName,BC.FileCount,BC.BoardNo,BB.Name,

				BC.RegUserNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Users where UserNo = BC.RegUserNo ),(Select Name from Organization_Users where UserNo = BC.RegUserNo )) else (Select Name from Organization_Users  where UserNo = BC.RegUserNo ) end) as RegUserName,
		BC.RegPositionNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo ),(Select Name_EN from Organization_Positions where PositionNo = BC.RegPositionNo )) else (Select Name from Organization_Positions where PositionNo = BC.RegPositionNo) end) as RegPositionName,
		 BC.RegDepartNo,
		( case when LanguageSign = 'EN' then COALESCE((Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo),(Select Name_EN from Organization_Departments where DepartNo = BC.RegDepartNo) ) else (Select Name from Organization_Departments where DepartNo = BC.RegDepartNo) end) as RegDepartName
		,BC.IsAlarm
		FROM SearchResult T
		INNER JOIN Board_Contents BC ON BC.ContentNo = T.ContentNo
		LEFT JOIN Board_Boards BB ON BC.BoardNo = BB.BoardNo
		WHERE T.RowNum BETWEEN StartRowNum AND EndRowNum and BC.IsNotice = FALSE
		ORDER BY T.RowNum ASC;

	END IF;

	RETURN QUERY
	SELECT * , (Select Count(*) From Board_ViewedLogs where Board_ViewedLogs.UserNo=board_web_search.userno AND BC.ContentNo=Board_ViewedLogs.ContentNo) As ReadCount , (SELECT BF.Name FROM Board_Files BF WHERE BF.ContentNo=BC.ContentNo AND (BF.Name ILIKE '%.gif' OR BF.Name ILIKE '%.png' OR BF.Name ILIKE '%.jpg' OR BF.Name ILIKE '%.jpeg' )) As AvataContent  FROM TempTable As BC;

	RETURN QUERY
	SELECT TotalItemCount AS TotalContentCount, TotalPageCount AS TotalPageCount, CurrentPageIndex AS CurrentPageIndex;
END IF;
END IF;
END IF;
END IF;
END IF;
END;
$function$

```
</details>

## `contact_checkinsertgroupdefault`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contact_checkinsertgroupdefault"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "isdefault" is ambiguous
- Stack context: PL/pgSQL function contact_checkinsertgroupdefault(integer,character varying,character varying) line 10 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contact_checkinsertgroupdefault(userno integer, isdefault character varying, groupname character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	IF (select count(*)	from ContactsGroup	where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault)=0 THEN
		INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
		VALUES (GroupName, 0, UserNo, 0 ,NOW(),'1','Y');
		GroupNo := lastval();
		RETURN QUERY
		SELECT GroupNo AS GroupNo;
	ELSE
		update ContactsGroup set GroupName=contact_checkinsertgroupdefault.groupname where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault;

	END IF;
END;
$function$

```
</details>

## `contact_getgroupdefaultbyuserno`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contact_getgroupdefaultbyuserno"(0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contact_getgroupdefaultbyuserno(integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contact_getgroupdefaultbyuserno(userno integer, isdefault character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



 SELECT GroupNo INTO groupno FROM ContactsGroup	where RegUserNo=contact_getgroupdefaultbyuserno.userno and IsDefault=contact_getgroupdefaultbyuserno.isdefault and UseYn='Y';
 RETURN QUERY
 select GroupNo;
END;
$function$

```
</details>

## `contact_insertsharegroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contact_insertsharegroup"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "sort" is ambiguous
- Stack context: PL/pgSQL function contact_insertsharegroup(integer,character varying,integer) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contact_insertsharegroup(userno integer, sharename character varying, parentno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sort FROM Contact_ShareGroup
	WHERE  ParentNo = contact_insertsharegroup.parentno
	ORDER BY Sort DESC;

	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo, Sort,RegDate,IsDelete)
	VALUES (ShareName, ParentNo, UserNo, Sort+1,NOW(),'FALSE');

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$

```
</details>

## `contacts_changegroup`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_changegroup"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function fnstringtolistint(character varying) does not exist
- Stack context: PL/pgSQL function contacts_changegroup(integer,character varying) line 5 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_changegroup(groupno integer DEFAULT 689, userseqlist character varying DEFAULT '7996,7995'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE ContactsGroupUser SET GroupNo = contacts_changegroup.groupno WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList));


--UPDATE ContactsGroupUser SET GroupNo = 689 WHERE UserSeq IN (SELECT * FROM fnStringtoListInt('7996,7995'))

--SELECT * FROM ContactsGroupUser WHERE UserSeq IN  (SELECT * FROM fnStringtoListInt('7996,7995'))
END;
$function$

```
</details>

## `contacts_changepublicgroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contacts_changepublicgroup"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42883`
- Error: function fnstringtolistint(character varying) does not exist
- Stack context: PL/pgSQL function contacts_changepublicgroup(integer,character varying,integer) line 8 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_changepublicgroup(groupno integer DEFAULT 8, userseqlist character varying DEFAULT '8164'::character varying, userno integer DEFAULT 70)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF GroupNo=0 THEN
	UPDATE Contact_PublicGroupUser SET IsDelete = TRUE WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList));
ELSE




		FOR userseq IN SELECT * FROM fnStringtoListInt(UserSeqList) LOOP
    --Do something with Id here

		IF (SELECT COUNT(*) FROM Contact_PublicGroupUser WHERE UserSeq= UserSeq AND PublicGroupNo=contacts_changepublicgroup.groupno)>0 THEN
			UPDATE Contact_PublicGroupUser SET PublicGroupNo = contacts_changepublicgroup.groupno ,ModDate=NOW(),ModUserNo=contacts_changepublicgroup.userno WHERE PublicGroupNo=contacts_changepublicgroup.groupno AND UserSeq =UserSeq;
		ELSE
			INSERT INTO Contact_PublicGroupUser(PublicGroupNo,UserSeq,RegUserNo,RegDate,ModUserNo,ModDate,IsDelete) VALUES(GroupNo,UserSeq,UserNo,NOW(),UserNo,NOW(),'FALSE');
		END IF;
    --PRINT UserSeq;
			END LOOP;
	END IF;
	--UPDATE Contacts_ChangeGroup SET ShareGroupNo = GroupNo WHERE ShareGroupNo=GroupNo AND UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))



--SELECT COUNT(*) FROM Contact_PublicGroupUser WHERE UserSeq= 8164 AND PublicGroupNo=8
END;
$function$

```
</details>

## `contacts_changesharegroup`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_changesharegroup"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function fnstringtolistint(character varying) does not exist
- Stack context: PL/pgSQL function contacts_changesharegroup(integer,integer,character varying) line 7 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_changesharegroup(userno integer, groupno integer DEFAULT 689, userseqlist character varying DEFAULT '7996,7995'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    userseq integer;
BEGIN

IF GroupNo=0 THEN
	UPDATE Contact_ShareGroupUser SET IsDelete = TRUE WHERE UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList));
ELSE



		FOR userseq IN SELECT * FROM fnStringtoListInt(UserSeqList) LOOP
    --Do something with Id here

		IF (SELECT COUNT(*) FROM Contact_ShareGroupUser WHERE UserSeq= UserSeq AND ShareGroupNo=contacts_changesharegroup.groupno)>0 THEN
			UPDATE Contact_ShareGroupUser SET ShareGroupNo = contacts_changesharegroup.groupno ,ModDate=NOW(),ModUserNo=contacts_changesharegroup.userno WHERE ShareGroupNo=contacts_changesharegroup.groupno AND UserSeq =UserSeq;
		ELSE
			INSERT INTO Contact_ShareGroupUser(ShareGroupNo,UserSeq,RegUserNo,RegDate,ModUserNo,ModDate,IsDelete) VALUES(GroupNo,UserSeq,UserNo,NOW(),UserNo,NOW(),'FALSE');
		END IF;
			END LOOP;
	END IF;
	--UPDATE Contacts_ChangeGroup SET ShareGroupNo = GroupNo WHERE ShareGroupNo=GroupNo AND UserSeq IN (SELECT * FROM fnStringtoListInt(UserSeqList))
END;
$function$

```
</details>

## `contacts_checknumber`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_checknumber"(0::integer, ''::character varying, 0::integer) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "value" is ambiguous
- Stack context: PL/pgSQL function contacts_checknumber(integer,character varying,integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_checknumber(reguserno integer, value character varying, type integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
IF Type = 0 THEN
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsNumber N
	INNER JOIN ContactsUser U ON U.Seq = N.UserSeq AND U.UseYn='Y'
	WHERE N.RegUserNo = contacts_checknumber.reguserno
	AND REPLACE(N.Value,'-','') = REPLACE(Value,'-','');
ELSE
	RETURN QUERY
	SELECT COUNT(*) cnt FROM ContactsEmail E
	INNER JOIN ContactsUser U ON U.Seq = E.UserSeq AND U.UseYn='Y'
	WHERE E.RegUserNo = contacts_checknumber.reguserno AND E.Value = contacts_checknumber.value;







END IF;
END;
$function$

```
</details>

## `contacts_delallcontactstrash`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."contacts_delallcontactstrash"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_delallcontactstrash(integer) line 12 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_delallcontactstrash(reguserno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	--DELETE FROM ContactsNumber WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsEmail WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsDays WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsCompany WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsAddress WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsSns WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsGroupUser WHERE RegUserNo=RegUserNo AND UserSeq IN (SELECT Seq FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '')
	--DELETE FROM ContactsUser WHERE RegUserNo = RegUserNo AND UseYn = '';
	UPDATE ContactsUser SET UseYn='F' WHERE RegUserNo = contacts_delallcontactstrash.reguserno AND UseYn = '';
END;
$function$

```
</details>

## `contacts_delcontactsgroup`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."contacts_delcontactsgroup"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_delcontactsgroup(integer) line 10 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_delcontactsgroup(groupno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--BEGIN TRY
		--BEGIN TRAN
		--DELETE FROM ContactsGroupUser WHERE GroupNo = GroupNo
		--DELETE FROM ContactsGroup WHERE GroupNo = GroupNo
		CREATE TEMP TABLE temp(GroupNo int) ON COMMIT DROP;
		WITH RECURSIVE GroupTmp AS (
			SELECT  G.*
			FROM  ContactsGroup G
			WHERE G.GroupNo= contacts_delcontactsgroup.groupno
			UNION ALL
			SELECT  GC.*
			FROM ContactsGroup GC
			INNER JOIN GroupTmp GT ON GC.ParentGNo=GT.GroupNo
		)
		INSERT INTO temp
		SELECT GroupNo FROM GroupTmp;
		UPDATE ContactsGroup SET UseYn='' WHERE GroupNo IN (SELECT GroupNo FROM temp);
		UPDATE ContactsUser SET UseYn='F', DelDate=NOW() WHERE Seq IN (SELECT UserSeq FROM ContactsGroupUser U INNER JOIN temp GU ON GU.GroupNo=U.GroupNo);
		DELETE FROM ContactsGroupUser  WHERE Seq IN (SELECT GroupNo FROM  temp);
		DROP TABLE IF EXISTS Temp;
		--COMMIT TRAN
	--END TRY
	--BEGIN CATCH
		--ROLLBACK TRAN
	--END CATCH

	PERFORM 0;
END;
$function$

```
</details>

## `contacts_delcontactsshare`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."contacts_delcontactsshare"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_delcontactsshare(integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_delcontactsshare(seq integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	delete from ContactsSharers where Seq=contacts_delcontactsshare.seq;
END;
$function$

```
</details>

## `contacts_deleteaddressall`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_deleteaddressall"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_savecontactshistory(integer,integer,character varying) line 9 at SQL statement SQL statement "SELECT contacts_savecontactshistory(UserNo, Seq, 'DEL')" PL/pgSQL function contacts_deleteaddressall(integer,integer,integer) line 6 at PERFORM
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_deleteaddressall(userno integer, seq integer, mode integer DEFAULT 1)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF Mode = 0 THEN -- 완전삭제

		PERFORM contacts_savecontactshistory(UserNo, Seq, 'DEL');

		DELETE FROM ContactsNumber WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsEmail WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsDays WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsCompany WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsAddress WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsSns WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_deleteaddressall.userno AND UserSeq=contacts_deleteaddressall.seq;
		DELETE FROM ContactsUser WHERE RegUserNo=contacts_deleteaddressall.userno AND Seq=contacts_deleteaddressall.seq;
	ELSE
		UPDATE ContactsUser
		SET
			UseYn = '',
			ModDate = NOW(),
			DelDate = NOW()
		WHERE RegUserNo=contacts_deleteaddressall.userno AND Seq=contacts_deleteaddressall.seq;
	END IF;
END;
$function$

```
</details>

## `contacts_deleteallgroupbyuserseq`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_deleteallgroupbyuserseq"(0::integer, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_deleteallgroupbyuserseq(integer,integer) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_deleteallgroupbyuserseq(userseq integer, userno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	UPDATE Contact_PublicGroupUser SET IsDelete = TRUE,  ModUserNo=contacts_deleteallgroupbyuserseq.userno,ModDate=NOW()
	WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq;
	UPDATE Contact_ShareGroupUser SET IsDelete = TRUE,  ModUserNo=contacts_deleteallgroupbyuserseq.userno,ModDate=NOW()
	WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq;
	Delete FROM ContactsGroupUser WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq;
	RETURN QUERY
	SELECT UserSeq;
END;
$function$

```
</details>

## `contacts_deletebackupinfo`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."contacts_deletebackupinfo"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "backupno" is ambiguous
- Stack context: PL/pgSQL function contacts_deletebackupinfo(integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_deletebackupinfo(backupno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	DELETE FROM ContactsBackup WHERE BackupNo = contacts_deletebackupinfo.backupno;
END;
$function$

```
</details>

## `contacts_deletedepartallowaccess`

- Input: `''::character varying`
- Generated SQL: `SELECT "public"."contacts_deletedepartallowaccess"(''::character varying);`
- SQLSTATE: `42883`
- Error: function splitstring(character varying, unknown) does not exist
- Stack context: PL/pgSQL function contacts_deletedepartallowaccess(character varying) line 8 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_deletedepartallowaccess(listallowaccessno character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    departno integer;
    itemno integer;
BEGIN


	CREATE TEMP TABLE Contact_DepartAllowAccess ON COMMIT DROP AS SELECT * FROM Contact_DepartAllowAccess
	WHERE AllowAccessNo IN(SELECT * FROM SplitString(ListAllowAccessNo,','));



	WHILE (Select Count(*) From Contact_DepartAllowAccess) > 0 LOOP
			SELECT DA.DepartNo, DA.ItemNo INTO departno, itemno FROM Contact_DepartAllowAccess DA;
			CREATE TEMP TABLE ShareGroupTemp ON COMMIT DROP AS WITH RECURSIVE ShareGroupNos AS (
				SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       Contact_ShareGroup PF

				WHERE PF.ShareGroupNo =ItemNo
				UNION ALL
				SELECT     CF.ShareGroupNo , CF.ParentNo
				FROM       Contact_ShareGroup CF
				INNER JOIN ShareGroupNos FN ON FN.ShareGroupNo = CF.ParentNo AND CF.IsDelete = FALSE
			)
			SELECT * FROM ShareGroupNos;

			DELETE FROM Contact_DepartAllowAccess WHERE DepartNo=DepartNo AND ItemNo IN (SELECT BB.ShareGroupNo FROM Contact_ShareGroup BB INNER JOIN ShareGroupTemp BF ON BF.ShareGroupNo=bb.ShareGroupNo);

			DROP TABLE IF EXISTS ShareGroupTemp;

			DELETE FROM Contact_DepartAllowAccess WHERE ItemNo=ItemNo AND  DepartNo=DepartNo;
	END LOOP;
	DROP TABLE IF EXISTS Contact_DepartAllowAccess;
END;
$function$

```
</details>

## `contacts_getallgroups`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getallgroups"(0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint, "column_10" character);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_getallgroups(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getallgroups(reguserno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq AND U.UseYn='Y'
		WHERE C.GroupNo = ContactsGroup.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup
	WHERE RegUserNo=contacts_getallgroups.reguserno AND UseYn='Y'
	ORDER BY Sort;
END;
$function$

```
</details>

## `contacts_getallgroupsrestore`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getallgroupsrestore"(0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint, "column_10" character);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_getallgroupsrestore(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getallgroupsrestore(reguserno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq
		WHERE C.GroupNo = ContactsGroup.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup
	WHERE RegUserNo=contacts_getallgroupsrestore.reguserno
	ORDER BY Sort;
END;
$function$

```
</details>

## `contacts_getalllistgroupcontact`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getalllistgroupcontact"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer);`
- SQLSTATE: `42702`
- Error: column reference "listgroup_id" is ambiguous
- Stack context: PL/pgSQL function contacts_getalllistgroupcontact(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getalllistgroupcontact(listgroup_id integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM Contacts_ListGroupContact
	WHERE ListGroup_Id=contacts_getalllistgroupcontact.listgroup_id;
END;
$function$

```
</details>

## `contacts_getbackupinfo`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getbackupinfo"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" integer, "column_5" character varying(500), "column_6" timestamp without time zone, "column_7" character varying(1000), "column_8" integer);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function contacts_getbackupinfo(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getbackupinfo(userno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsBackup WHERE UserNo = contacts_getbackupinfo.userno
	ORDER BY RegDate DESC;
END;
$function$

```
</details>

## `contacts_getbackupinfoonce`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getbackupinfoonce"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" integer, "column_5" character varying(500), "column_6" timestamp without time zone, "column_7" character varying(1000), "column_8" integer);`
- SQLSTATE: `42702`
- Error: column reference "backupno" is ambiguous
- Stack context: PL/pgSQL function contacts_getbackupinfoonce(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getbackupinfoonce(backupno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT BackupNo, UserNo, ContactCnt, GroupCnt, Memo, RegDate, Path, TYPE
	FROM ContactsBackup WHERE BackupNo=contacts_getbackupinfoonce.backupno;
END;
$function$

```
</details>

## `contacts_getcontactscount`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getcontactscount"(0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42703`
- Error: column "p_reguserno" does not exist
- Stack context: PL/pgSQL function contacts_getcontactscount(integer,character varying,character varying,character varying,character varying,integer,character varying) line 81 at EXECUTE statement
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactscount(reguserno integer, ts character varying, te character varying, search character varying, searchmode character varying, groupno integer, mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    pagingqry character varying;
    countqry character varying;
    param character varying;
    searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	PagingQry := 'SELECT count(*) cnt FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq,Name,Memo FROM ContactsUser';

	CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser';
	PARAM := 'P_RegUserNo INT,;
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

	IF GroupNo > 0 THEN
		pagingqry := COALESCE(pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		countqry := COALESCE(countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo) PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo'), '');
			END IF;
		ELSE
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND
Name BETWEEN P_TS AND P_TE) PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE CU.RegUserNo=P_RegUserNo AND GroupNo=P_GroupNo AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;
	ELSE

		pagingqry := COALESCE(pagingqry, '') || COALESCE((' '), '');
		countqry := COALESCE(countqry, '') || COALESCE((' '), '');

		IF Search = '' THEN
			SearchTxt := '';
		ELSE
			IF SearchMode = '0' THEN
				SearchTxt := ' AND Name ILIKE ''%' || Search || '%''';
			ELSIF SearchMode = '1' THEN
				SearchTxt := '';
			ELSIF SearchMode = '2' THEN
				SearchTxt := '';
			ELSE
				SearchTxt := ' AND Memo ILIKE ''%' || Search || '%''';
			END IF;
		END IF;

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || SearchTxt || ') PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo' || SearchTxt), '');
			END IF;
		ELSE
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || SearchTxt || ') PagingTable'), '');
			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE RegUserNo=P_RegUserNo AND Name BETWEEN P_TS AND P_TE' || SearchTxt), '');
			END IF;
		END IF;
	END IF;

	IF Mode = '0' THEN
		EXECUTE PagingQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	ELSE
		EXECUTE CountQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	END IF;
END;
$function$

```
</details>

## `contacts_getcontactslist`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getcontactslist"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42703`
- Error: column "p_reguserno" does not exist
- Stack context: PL/pgSQL function contacts_getcontactslist(integer,integer,integer,character varying,character varying,character varying,character varying,integer,character varying) line 87 at EXECUTE statement
- Root cause: Missing column dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getcontactslist(reguserno integer, sidx integer, eidx integer, ts character varying, te character varying, search character varying, searchmode character varying, groupno integer, mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    pagingqry character varying;
    countqry character varying;
    param character varying;
    searchtxt character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	PagingQry := 'SELECT ROWNUM, Seq, Name, Memo FROM;
				(SELECT ROW_NUMBER() OVER(ORDER BY RegDate DESC) ROWNUM, Seq, Name, Memo FROM ContactsUser ';

	CountQry := 'SELECT COUNT(*) CNT FROM ContactsUser ';
	PARAM := 'P_RegUserNo INT,;
	P_Sidx INT,
	P_Eidx INT,
	P_TS NVARCHAR(5),
	P_TE NVARCHAR(5),
	P_GroupNo INT';

		pagingqry := COALESCE(pagingqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		countqry := COALESCE(countqry, '') || COALESCE((' CU INNER JOIN ContactsGroupUser CG
ON CU.RegUserNo = CG.RegUserNo AND CU.Seq=CG.UserSeq '), '');

		IF TS = '' AND TE = '' THEN
			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))) PagingTable
WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo))'), '');
			END IF;
		ELSE

			IF Mode = '0' THEN
				pagingqry := COALESCE(pagingqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND
Name BETWEEN P_TS AND P_TE) PagingTable WHERE ROWNUM BETWEEN P_Sidx AND P_Eidx'), '');

			ELSE
				countqry := COALESCE(countqry, '') || COALESCE(('WHERE UseYn = ''Y'' AND CU.RegUserNo=P_RegUserNo AND GroupNo IN (SELECT TreeID FROM public."GetChildGroup"(P_RegUserNo,P_GroupNo)) AND Name BETWEEN P_TS AND P_TE'), '');
			END IF;
		END IF;



		IF Search = '' THEN
			SearchTxt := '';
		ELSE
			IF SearchMode = '0' THEN
				SearchTxt := ' AND Name ILIKE ''%' || Search || '%''';
			ELSIF SearchMode = '1' THEN
				SearchTxt := ' AND Seq IN (select UserSeq from ContactsCompany WHERE Position ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '2' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsNumber WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '3' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Company ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '4' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsCompany WHERE Depart ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '5' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsEmail WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '6' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSEq FROM ContactsGroupUser WHERE;
									GroupNo IN (SELECT GroupNo FROM ContactsGroup WHERE GroupName ILIKE ''%' || Search || '%''))';

			ELSIF SearchMode = '7' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM ContactsGroup WHERE RegDate ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '8' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')';
			ELSIF SearchMode = '9' THEN
				SearchTxt := ' AND Seq IN (SELECT UserSeq FROM  WHERE Value ILIKE ''%' || Search || '%'')';
			END IF;
		END IF;

		pagingqry := COALESCE(pagingqry, '') || COALESCE((SearchTxt), '');
		countqry := COALESCE(countqry, '') || COALESCE((SearchTxt), '');


	IF Mode = '0' THEN
		EXECUTE PagingQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	ELSE
		EXECUTE CountQry; -- TODO: rewrite named sp_executesql bindings as PostgreSQL USING parameters;
	END IF;
END;
$function$

```
</details>

## `contacts_getgroupbyuser`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getgroupbyuser"(0::integer, 0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint, "column_10" character);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_getgroupbyuser(integer,integer) line 6 at IF
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getgroupbyuser(reguserno integer DEFAULT NULL::integer, userseq integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 IF (SELECT COUNT(*) FROM ContactsGroup  WHERE RegUserNo=contacts_getgroupbyuser.reguserno AND UseYn='Y')<=0 THEN
	PERFORM contacts_insertgroup(RegUserNo,'임시 그룹',0);
 END IF;


	RETURN QUERY
	SELECT distinct c.GroupNo, c.GroupName, c.RegUserNo, c.RegDate, c.Memo, c.ParentGNo, c.Sort, c.IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser Cc
		INNER JOIN ContactsUser U ON U.Seq = Cc.UserSeq AND U.UseYn='Y'
		WHERE Cc.GroupNo = c.GroupNo
	) AS UserCount,
	UseYn
	FROM ContactsGroup c
	left join ContactsGroupUser g on c.groupno=g.groupno
	WHERE c.RegUserNo=contacts_getgroupbyuser.reguserno AND c.UseYn='Y' --and --g.userseq=UserSeq
	 ORDER BY c.Sort;
END;
$function$

```
</details>

## `contacts_getgroupinfo`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getgroupinfo"(0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_getgroupinfo(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getgroupinfo(groupno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, ParentGNo, Sort, IsDefault
	,(SELECT COUNT(*) FROM ContactsGroupUser C WHERE C.GroupNo = ContactsGroup.GroupNo) AS UserCount
	FROM ContactsGroup
	WHERE GroupNo = contacts_getgroupinfo.groupno;
END;
$function$

```
</details>

## `contacts_getlocations`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getlocations"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" timestamp without time zone, "column_4" integer, "column_5" timestamp without time zone, "column_6" character varying(100), "column_7" double precision, "column_8" double precision, "column_9" integer, "column_10" character varying(500));`
- SQLSTATE: `42702`
- Error: column reference "contactuserid" is ambiguous
- Stack context: PL/pgSQL function contacts_getlocations(integer) line 6 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getlocations(contactuserid integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LocationNo, RegUserNo, RegDate, ModUserNo, ModDate,
		Name, Latitude, Longitude, ErrorRange, Description
	FROM Contacts_Locations
	WHERE ContactUserId=contacts_getlocations.contactuserid;
END;
$function$

```
</details>

## `contacts_getoutfile`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getoutfile"(0::integer, ''::character varying);`
- SQLSTATE: `22P02`
- Error: invalid input syntax for integer: ""
- Stack context: PL/pgSQL function contacts_getoutfile(integer,character varying) line 33 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutfile(userno integer, userseqlist character varying DEFAULT 'ALL'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserSeqList = 'ALL' THEN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetail"(U.Seq,'number') AS Number,
			public."UF_ContactsDetail"(U.Seq,'company') AS Company,
			public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetail"(U.Seq,'group') AS GroupName,
			public."UF_ContactsDetail"(U.Seq,'email') AS Email,
			U.CheckDate,
			U.ModDate,
			U.RegDate
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfile.userno
		AND UseYn = 'Y';
	ELSE

		CREATE TEMP TABLE tabUser (UserSeq INT) ON COMMIT DROP;

		UserSeqList := contacts_getoutfile.userseqlist || ',';
		WHILE STRPOS(UserSeqList, ',') > 0 LOOP

			UserSeq := SUBSTRING(UserSeqList,0,STRPOS(UserSeqList, ','));
			INSERT INTO tabUser
			(
				UserSeq
			)
			VALUES
			(
				UserSeq
			);

			UserSeqList := SUBSTRING(UserSeqList,STRPOS(UserSeqList, ',')+1,LEN(UserSeqList));
		END LOOP;

		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			U.CheckDate,
			U.ModDate,
			U.RegDate,
			public."UF_ContactsDetail"(U.Seq,'company') AS Company,
			public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetail"(U.Seq,'email') AS Email,
			public."UF_ContactsDetail"(U.Seq,'number') AS Number,
			public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfile.userno
		AND UseYn = 'Y'
		AND Seq IN (SELECT UserSeq FROM tabUser);
	END IF;
END;
$function$

```
</details>

## `contacts_getoutfileexcel`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getoutfileexcel"(0::integer, ''::character varying);`
- SQLSTATE: `22P02`
- Error: invalid input syntax for integer: ""
- Stack context: PL/pgSQL function contacts_getoutfileexcel(integer,character varying) line 41 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutfileexcel(userno integer DEFAULT 1, userseqlist character varying DEFAULT '2,3,4,5'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserSeqList = 'ALL' THEN
		RETURN QUERY
		SELECT
			U.LastName,
			U.FirstName,
			U.CallName,
			public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
			public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
			public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
			public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
			public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
			public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
			public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutfileexcel.userno
		AND UseYn = 'Y';
	ELSE

		CREATE TEMP TABLE tabUser (UserSeq INT) ON COMMIT DROP;

		UserSeqList := contacts_getoutfileexcel.userseqlist || ',';
		WHILE STRPOS(UserSeqList, ',') > 0 LOOP

			UserSeq := SUBSTRING(UserSeqList,0,STRPOS(UserSeqList, ','));
			INSERT INTO tabUser
			(
				UserSeq
			)
			VALUES
			(
				UserSeq
			);

			UserSeqList := SUBSTRING(UserSeqList,STRPOS(UserSeqList, ',')+1,LEN(UserSeqList));
		END LOOP;

		RETURN QUERY
		SELECT
			U.LastName,
			U.FirstName,
			U.CallName,
			public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
			public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
			public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
			public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
			public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
			public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
			public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE
		--RegUserNo = UserNo	AND
		 UseYn = 'Y'
		AND Seq IN (SELECT UserSeq FROM tabUser);
	END IF;
END;
$function$

```
</details>

## `contacts_getoutlist`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getoutlist"(0::integer, ''::character varying);`
- SQLSTATE: `22P02`
- Error: invalid input syntax for integer: ""
- Stack context: PL/pgSQL function contacts_getoutlist(integer,character varying) line 67 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlist(userno integer, grouplist character varying DEFAULT 'ALL'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL' THEN
		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."UF_ContactsDetail"(U.Seq,'company') AS Company,
				public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetail"(U.Seq,'email') AS Email,
				public."UF_ContactsDetail"(U.Seq,'number') AS Number,
				public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			WHERE RegUserNo = contacts_getoutlist.userno
			AND UseYn = 'Y'
		) A
		WHERE 1>0;
	ELSIF GroupList = 'LIST' THEN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			U.CheckDate,
			U.ModDate,
			U.RegDate,
			public."UF_ContactsDetail"(U.Seq,'company') AS Company,
			public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetail"(U.Seq,'email') AS Email,
			public."UF_ContactsDetail"(U.Seq,'number') AS Number,
			public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutlist.userno
		AND UseYn = 'Y';
	ELSE
		CREATE TEMP TABLE tabGroup (GroupNo INT) ON COMMIT DROP;

		GroupList := contacts_getoutlist.grouplist || ',';
		WHILE STRPOS(GroupList, ',') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(GroupList, ','));
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			);

			GroupList := SUBSTRING(GroupList,STRPOS(GroupList, ',')+1,LEN(GroupList));
		END LOOP;

		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."UF_ContactsDetail"(U.Seq,'company') AS Company,
				public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetail"(U.Seq,'email') AS Email,
				public."UF_ContactsDetail"(U.Seq,'number') AS Number,
				public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
			JOIN ContactsGroup GR ON G.GroupNo=GR.GroupNo
			WHERE U.RegUserNo = contacts_getoutlist.userno
			AND U.UseYn = 'Y'
			AND G.GroupNo IN (SELECT GroupNo FROM tabGroup)
		) A
		WHERE 1>0;
	END IF;
END;
$function$

```
</details>

## `contacts_getoutlistcount`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getoutlistcount"(0::integer, ''::character varying);`
- SQLSTATE: `22P02`
- Error: invalid input syntax for integer: ""
- Stack context: PL/pgSQL function contacts_getoutlistcount(integer,character varying) line 21 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlistcount(userno integer, grouplist character varying DEFAULT 'ALL'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL' THEN

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		WHERE RegUserNo = contacts_getoutlistcount.userno
		AND UseYn = 'Y';
	ELSE
		CREATE TEMP TABLE tabGroup (GroupNo INT) ON COMMIT DROP;

		GroupList := contacts_getoutlistcount.grouplist || ',';
		WHILE STRPOS(GroupList, ',') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(GroupList, ','));
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			);

			GroupList := SUBSTRING(GroupList,STRPOS(GroupList, ',')+1,LEN(GroupList));
		END LOOP;

		RETURN QUERY
		SELECT
			COUNT(U.Seq) AS CNT
		FROM ContactsUser U
		JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
		WHERE U.RegUserNo = contacts_getoutlistcount.userno
		AND U.UseYn = 'Y'
		AND G.GroupNo IN (SELECT GroupNo FROM tabGroup);

	END IF;
END;
$function$

```
</details>

## `contacts_getoutlistexcel`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, false`
- Generated SQL: `SELECT "public"."contacts_getoutlistexcel"(0::integer, ''::character varying, ''::character varying, ''::character varying, false);`
- SQLSTATE: `22P02`
- Error: invalid input syntax for integer: ""
- Stack context: PL/pgSQL function contacts_getoutlistexcel(integer,character varying,character varying,character varying,boolean) line 11 at assignment
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getoutlistexcel(userno integer DEFAULT 70, grouplist character varying DEFAULT ''::character varying, sharelist character varying DEFAULT '0'::character varying, publiclist character varying DEFAULT ''::character varying, isadmin boolean DEFAULT true)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

CREATE TEMP TABLE tabGroup (GroupNo INT) ON COMMIT DROP;
	GroupList := contacts_getoutlistexcel.grouplist || ',';
		WHILE STRPOS(GroupList, ',') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(GroupList, ','));
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			);

			GroupList := SUBSTRING(GroupList,STRPOS(GroupList, ',')+1,LEN(GroupList));
		END LOOP;
IF IsAdmin = TRUE THEN
		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN GroupName::json->>'KO' ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel.userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(PublicList))
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 --((U.RegUserNo=UserNo AND SUBSTRING(U.Share,1,3)='200')

				--or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_GetDepartmentsByUser(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			SUBSTRING(U.Share,1,3)='200'
			--AND U.RegUserNo <> UserNo
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(ShareList))
		) A;

		ELSE




		RETURN QUERY
		SELECT distinct
			Seq,
			LastName,
			CallName,
			FirstName,
			cellphone,
			companyphone,
			homephone,
			faxphone,
			Company,
			Position,
			Depart,
			Email,
			companyzipcode,
			companyaddress,
			homezipcode,
			homeaddress,
			homepage,
			ModDate,
			RegDate,
			CASE WHEN STRPOS(GroupName, '{')>0 THEN GroupName::json->>'KO' ELSE GroupName END AS GroupName ,
			--GroupName,
			Memo,
			GroupId,
			RegUserNo,
			UseYn
		FROM
		(
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				gg.GroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			inner join (SELECT DISTINCT  M.GroupNo,G.UserSeq
					FROM  ContactsGroupUser G inner JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getoutlistexcel.userno) gg  ON gg.UserSeq = U.Seq
			WHERE
			U.UseYn = 'Y'
			AND gg.GroupNo IN (SELECT GroupNo FROM tabGroup)
			UNION  ALL
			SELECT
					U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.PublicGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_PublicGroupUser G ON U.Seq = G.UserSeq

			WHERE
			 SUBSTRING(U.Share,1,3)='300'
			AND U.UseYn = 'Y'
			AND COALESCE(G.PublicGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(PublicList))
			UNION  ALL
			SELECT
				U.Seq,
				U.LastName as LastName,
				U.CallName as CallName,
				U.FirstName as FirstName,
				public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
				public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
				public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
				public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
				public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
				public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
				public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
				public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
				public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
				U.Memo,
				CASE WHEN STRPOS(public."UF_ContactsDetailExcel"(U.Seq,'group', '{'))>0 THEN (SELECT StringValue FROM ParseJson(public."UF_ContactsDetailExcel"(U.Seq,'group'))  WHERE NAME='KO') ELSE public."UF_ContactsDetailExcel"(U.Seq,'group') END AS GroupName ,
				--public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
				U.ModDate,
				U.RegDate,
				G.ShareGroupNo as GroupId,
				U.RegUserNo,
				U.UseYn
			FROM ContactsUser U
			LEFT JOIN Contact_ShareGroupUser G ON U.Seq = G.UserSeq
			WHERE
			 ((U.RegUserNo=contacts_getoutlistexcel.userno AND SUBSTRING(U.Share,1,3)='200')

				or (SUBSTRING(U.Share,1,3)='200' AND (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo = contacts_getoutlistexcel.userno))))
			--SUBSTRING(U.Share,1,3)='200'
			AND U.RegUserNo <> contacts_getoutlistexcel.userno
			AND U.UseYn = 'Y'
			AND COALESCE(G.ShareGroupNo,0) IN (SELECT * FROM Contacts_StringToListInt(ShareList))
		) A;
END IF;
END;
$function$

```
</details>

## `contacts_getsetup`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getsetup"(0::integer) AS result("column_1" integer, "column_2" timestamp without time zone, "column_3" integer, "column_4" timestamp without time zone, "column_5" integer, "column_6" integer, "column_7" bigint, "column_8" boolean);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function contacts_getsetup(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getsetup(userno integer DEFAULT 70)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsSetup
	WHERE UserNo = contacts_getsetup.userno;
END;
$function$

```
</details>

## `contacts_getsharers`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getsharers"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" character varying(100), "column_4" character);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_getsharers(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getsharers(seq integer DEFAULT 7914)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM ContactsSharers WHERE Seq = contacts_getsharers.seq;
END;
$function$

```
</details>

## `contacts_gettopcategory`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_gettopcategory"(0::integer) AS result("column_1" bigint, "column_2" integer, "column_3" text);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_gettopcategory(integer) line 4 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_gettopcategory(reguserno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
SELECT *FROM
(SELECT ROW_NUMBER() OVER(ORDER BY RegDate ASC) ROWNUM, GroupNo, GroupName
 FROM ContactsGroup WHERE RegUserNo = contacts_gettopcategory.reguserno and ParentGNo = 0) a;
END;
$function$

```
</details>

## `contacts_getuser_address`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_address"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" smallint, "column_5" character varying(50), "column_6" character varying(5), "column_7" character varying(5), "column_8" character varying(500), "column_9" character, "column_10" timestamp without time zone, "column_11" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_address(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_address(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	ZipCode1,
	ZipCode2,
	Address,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsAddress WHERE UserSeq = contacts_getuser_address.userseq;
END;
$function$

```
</details>

## `contacts_getuser_company`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_company"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" character varying(50), "column_5" character varying(50), "column_6" character varying(50), "column_7" character, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_company(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_company(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Company,
	Depart,
	Position,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsCompany WHERE UserSeq = contacts_getuser_company.userseq;
END;
$function$

```
</details>

## `contacts_getuser_days`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_days"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" smallint, "column_5" character varying(50), "column_6" character varying(50), "column_7" character, "column_8" character, "column_9" timestamp without time zone, "column_10" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_days(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_days(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	SolarLunar,
	RegDate,
	ModDate
	FROM ContactsDays WHERE UserSeq = contacts_getuser_days.userseq;
END;
$function$

```
</details>

## `contacts_getuser_email`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_email"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" character varying(50), "column_5" character, "column_6" timestamp without time zone, "column_7" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_email(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_email(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsEmail WHERE UserSeq = contacts_getuser_email.userseq;
END;
$function$

```
</details>

## `contacts_getuser_homepage`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_homepage"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" smallint, "column_5" character varying(50), "column_6" character varying(500), "column_7" character, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_homepage(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_homepage(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsHomepage WHERE UserSeq = contacts_getuser_homepage.userseq;
END;
$function$

```
</details>

## `contacts_getuser_number`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_number"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" smallint, "column_5" character varying(50), "column_6" character varying(50), "column_7" character, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_number(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_number(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsNumber WHERE UserSeq = contacts_getuser_number.userseq;
END;
$function$

```
</details>

## `contacts_getuser_sns`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getuser_sns"(0::integer) AS result("column_1" integer, "column_2" integer, "column_3" integer, "column_4" smallint, "column_5" character varying(50), "column_6" character varying(500), "column_7" character, "column_8" timestamp without time zone, "column_9" timestamp without time zone);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_sns(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_sns(userseq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsSns WHERE UserSeq = contacts_getuser_sns.userseq;
END;
$function$

```
</details>

## `contacts_getuser_togroup`

- Input: `0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getuser_togroup"(0::integer, 0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_togroup(integer,integer,integer,integer,character varying,character varying,character varying,integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_togroup(userno integer DEFAULT 10, groupno integer DEFAULT 0, viewcount integer DEFAULT 10, currentpageindex integer DEFAULT 1, initial character varying DEFAULT ''::character varying, sortcolumn character varying DEFAULT 'DESC_RegDate'::character varying, isdefault character varying DEFAULT '1'::character varying, serchtype integer DEFAULT 0, serchtext character varying DEFAULT ''::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    topgroupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--전체그룹인지 체크 합니다.;

	SELECT GroupNo INTO topgroupno FROM ContactsGroup WHERE ParentGNo=0 and RegUserNo=contacts_getuser_togroup.userno AND IsDefault='1';

	-- 전체 그룹이라면
	IF TopGroupNo = contacts_getuser_togroup.groupno OR GroupNo=0 OR GroupNo=-1 THEN
		IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT DISTINCT Seq, * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,gg.IsDefault
			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN (SELECT G.UserSeq,M.IsDefault FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault='1'
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share=300)
			AND U.UseYn = 'Y'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName+U.FirstName) = 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;
		ELSE

		IF GroupNo=0 THEN

		RETURN QUERY
		SELECT DISTINCT Seq, * FROM (
			SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,gg.IsDefault
			FROM ContactsUser U


			--inner join (select distinct  gg.GroupNo,gg.UserSeq from ContactsGroupUser gg where  gg.GroupNo=GroupNo ) as G on G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			LEFT JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.GroupNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroup.userno and M.IsDefault='0') as gg ON gg.UserSeq = U.Seq
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select Distinct C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND U.UseYn = 'Y'

			AND PATINDEX('%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0

			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;


		ELSIF GroupNo=-1 THEN

		RETURN QUERY
		SELECT  * FROM (
			SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,gg.IsDefault

			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

			left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroup.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
			WHERE
			(U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND
			 U.UseYn = 'Y'
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
			--AND gg.IsDefault=IsDefault

			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;




		ELSE
			IF IsDefault='1' THEN

			RETURN QUERY
			SELECT  *	 FROM (
				SELECT
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
					CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
					CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				)) AS RowNum
				,COALESCE(C.Company,'') as Company
				,COALESCE(C.Depart,'') as Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				,1 as IsDefault
				FROM ContactsUser U
				LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

				left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
				--nghiem remove 2018-11-12
				--inner JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo
				--	FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
				--	where M.RegUserNo=UserNo and M.IsDefault=IsDefault) as gg ON gg.UserSeq = U.Seq
				--WHERE (U.RegUserNo = UserNo  Or U.Share='300' OR ((SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo)))))--and gg.RegUserNo = UserNo))
				WHERE --(U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))--and gg.RegUserNo = UserNo)
				  U.UseYn = 'Y'
				AND	G.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))
				AND PATINDEX('%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
				--AND gg.IsDefault=IsDefault
				) T
				WHERE T.RowNum
				BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount;
			ELSE

			RETURN QUERY
			SELECT  * FROM (
			SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,M.IsDefault
			FROM ContactsUser U
			LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--LEFT JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.GroupNo,M.IsDefault
			--		FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--		where M.RegUserNo=UserNo ) as gg ON gg.UserSeq = U.Seq

			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			--LEFT JOIN (SELECT G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' AND G.GroupNo=contacts_getuser_togroup.groupno) OR (SUBSTRING(U.Share,1,3)='200' and U.RegUserNo = contacts_getuser_togroup.userno))
			AND U.UseYn = 'Y'
			AND	G.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))

			AND PATINDEX('%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;

			END IF;
		END IF;

		END IF;
	ELSE
		IF Initial = 'ETC' THEN
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,M.IsDefault
			FROM ContactsUser U
			INNER JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			--LEFT JOIN (SELECT G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo) as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share=300) AND G.GroupNo = contacts_getuser_togroup.groupno
			AND U.UseYn = 'Y'
			AND M.UseYn='Y'
			AND PATINDEX(public."UF_RegularExText"('ㄱ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄴ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄷ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㄹ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅁ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅂ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅅ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅇ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅈ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅊ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅋ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅌ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅍ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('ㅎ') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('A') || '%' , U.LastName+U.FirstName) = 0
			AND PATINDEX(public."UF_RegularExText"('0') || '%' , U.LastName+U.FirstName) = 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;
		ELSE
			RETURN QUERY
			SELECT * FROM (SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt,
			CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,C.Company
			,C.Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,0 as IsDefault
			FROM ContactsUser U
			--INNER JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
			LEFT JOIN (SELECT distinct M.GroupNo, G.UserSeq FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo where M.UseYn='Y') as gg ON gg.UserSeq = U.Seq
			LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			WHERE (U.RegUserNo = contacts_getuser_togroup.userno  Or U.Share='300' OR SUBSTRING(U.Share,1,3)='200')
			AND	gg.GroupNo in (select * from Contacts_GetChildGroupByGroupNo(GroupNo))
			AND U.UseYn = 'Y'
			--AND M.UseYn='Y'
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;
		END IF;
	END IF;
END;
$function$

```
</details>

## `contacts_getuser_togroupmobile`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_getuser_togroupmobile"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_getuser_togroupmobile(integer,integer,integer,character varying,character varying,character varying,integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getuser_togroupmobile(groupno integer, viewcount integer, currentpageindex integer, initial character varying, sortcolumn character varying, textsearch character varying, userno integer DEFAULT 10, isdefault character varying DEFAULT '1'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    topgroupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--전체그룹인지 체크 합니다.;

	SELECT GroupNo INTO topgroupno FROM ContactsGroup WHERE ParentGNo=0 and RegUserNo=contacts_getuser_togroupmobile.userno AND IsDefault='1';

	-- 전체 그룹이라면
	IF TopGroupNo = contacts_getuser_togroupmobile.groupno OR GroupNo=0 OR GroupNo=-1 THEN
		IF TextSearch='' THEN
			RETURN QUERY
			SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
			SELECT
			CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
			,CONVERT(INT, ROW_NUMBER() OVER (
			ORDER BY
				CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
				CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
				CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
				CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
				CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
				CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
				CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
			)) AS RowNum
			,COALESCE(C.Company,'') as Company
			,COALESCE(C.Depart,'') as Depart
			,U.Seq
			,U.FirstName
			,U.LastName
			,U.RegUserNo
			,U.Memo
			,U.RegDate
			,U.Photo
			,U.ModDate
			,U.CheckDate
			,U.Share
			,U.UseYn
			,U.DelDate
			,U.Important
			,U.CallName
			,gg.IsDefault
			,E.Value as email

			FROM ContactsUser U
			--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
			--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

			left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
			LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
			left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
					FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
					where M.RegUserNo=contacts_getuser_togroupmobile.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
			WHERE
			(U.RegUserNo = contacts_getuser_togroupmobile.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
			AND
			 U.UseYn = 'Y'
			AND PATINDEX( '%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
			--AND gg.IsDefault=sDefault

			) T
			WHERE T.RowNum
			BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
			AND CurrentPageIndex * ViewCount;

		ELSE
			 RETURN QUERY
			 SELECT  T.Seq as seq,T.FirstName firstName,T.LastName lastName,T.email as email,T.Photo photo FROM (
				SELECT
				CONVERT(INT,COUNT(*) OVER()) AS TotalCnt
				,CONVERT(INT, ROW_NUMBER() OVER (
				ORDER BY
					CASE WHEN SortColumn='ASC_NAME' THEN U.LastName+U.FirstName END ASC,
					CASE WHEN SortColumn='DESC_NAME' THEN U.LastName+U.FirstName END DESC,
					CASE WHEN SortColumn='ASC_COMPANY' THEN C.Company END ASC,
					CASE WHEN SortColumn='DESC_COMPANY' THEN C.Company END DESC,
					CASE WHEN SortColumn='ASC_DEPART' THEN C.Depart END ASC,
					CASE WHEN SortColumn='DESC_DEPART' THEN C.Depart END DESC,
					CASE WHEN SortColumn='DESC_RegDate' THEN U.RegDate END DESC
				)) AS RowNum
				,COALESCE(C.Company,'') as Company
				,COALESCE(C.Depart,'') as Depart
				,U.Seq
				,U.FirstName
				,U.LastName
				,U.RegUserNo
				,U.Memo
				,U.RegDate
				,U.Photo
				,U.ModDate
				,U.CheckDate
				,U.Share
				,U.UseYn
				,U.DelDate
				,U.Important
				,U.CallName
				,gg.IsDefault
				,E.Value as email

				FROM ContactsUser U
				--LEFT JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
				--LEFT JOIN ContactsGroup M ON M.GroupNo = G.GroupNo

				left JOIN ContactsCompany C ON C.UserSeq = U.Seq AND C.IsDefault = TRUE
				LEFT JOIN ContactsEmail E ON E.UserSeq = U.Seq
				left JOIN (SELECT DISTINCT  G.UserSeq,M.RegUserNo,M.IsDefault
						FROM  ContactsGroupUser G INNER JOIN ContactsGroup M ON M.GroupNo = G.GroupNo
						where M.RegUserNo=contacts_getuser_togroupmobile.userno and M.IsDefault = FALSE) as gg ON gg.UserSeq = U.Seq
				WHERE
				(U.RegUserNo = contacts_getuser_togroupmobile.userno  Or U.Share='300' OR (SUBSTRING(U.Share,1,3)='200' and (U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN public."Organization_GetDepartmentsByUser"(UserNo) DP ON DP.DepartNo = C.DepartNo))))
				AND
				 U.UseYn = 'Y'
				AND PATINDEX( '%' || public."UF_RegularExText"(Initial) || '%' , U.LastName+U.FirstName) > 0
				--AND gg.IsDefault=sDefault

				) T
				WHERE ((T.FirstName ILIKE '%' || TextSearch || '%') OR (T.LastName ILIKE '%' || TextSearch || '%')) AND T.RowNum
				BETWEEN ((CurrentPageIndex - 1) * ViewCount) + 1
				AND CurrentPageIndex * ViewCount;
		 END IF;
END IF;
END;
$function$

```
</details>

## `contacts_getusergroup`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_getusergroup"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_getusergroup(integer,integer,integer) line 21 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getusergroup(reguserno integer, userno integer, groupno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupname character varying;
    groupcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	IF GroupNo = 0 THEN
		SELECT b.GroupName INTO groupname FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno;
	ELSE
		SELECT b.GroupName INTO groupname FROM ContactsGroupUser a
		INNER JOIN ContactsGroup b ON a.GroupNo=b.GroupNo
		WHERE a.UserSeq=contacts_getusergroup.userno AND a.RegUserNo=contacts_getusergroup.reguserno AND a.GroupNo IN (select TreeID from public."GetChildGroup"(RegUserNo,GroupNo));
	END IF;

	SELECT COUNT(*) INTO groupcount FROM ContactsGroupUser
	WHERE UserSeq=contacts_getusergroup.userno AND RegUserNo=contacts_getusergroup.reguserno;

	IF GroupCount = 1 THEN
		RETURN QUERY
		SELECT COALESCE(GroupName,'');
	ELSE
		RETURN QUERY
		SELECT COALESCE(GroupName,'') || ';' || CAST(GroupCount - 1 AS text);
	END IF;
END;
$function$

```
</details>

## `contacts_getusergroupbyuserno`

- Input: `0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_getusergroupbyuserno"(0::integer) AS result("column_1" integer, "column_2" text, "column_3" integer, "column_4" timestamp without time zone, "column_5" character varying(500), "column_6" integer, "column_7" integer, "column_8" character, "column_9" bigint, "column_10" character);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_getusergroupbyuserno(integer) line 5 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_getusergroupbyuserno(reguserno integer DEFAULT 70)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	WITH RECURSIVE ContactsGroups AS (
		  SELECT CGP.GroupNo,CGP.GroupNo AS RootGourpNo
		  FROM ContactsGroup CGP
		  WHERE CGP.UseYn='Y'
		  UNION ALL
		  SELECT CGC.GroupNo,C.RootGourpNo
		  FROM ContactsGroup CGC
		  INNER JOIN ContactsGroups C ON CGC.ParentGNo = C.GroupNo AND CGC.UseYn='Y'
	)
	SELECT GroupNo, GroupName, RegUserNo, RegDate, Memo, COALESCE(ParentGNo,0) AS ParentGNo, Sort, IsDefault,
	(
		SELECT COUNT(*)
		FROM ContactsGroupUser C
		INNER JOIN ContactsUser U ON U.Seq = C.UserSeq
		WHERE U.UseYn='Y' AND C.GroupNo IN (SELECT GroupNo FROM ContactsGroups WHERE RootGourpNo=CG.GroupNo)
	) AS UserCount,
	UseYn
	FROM ContactsGroup CG
	WHERE CG.RegUserNo=contacts_getusergroupbyuserno.reguserno AND CG.UseYn='Y'
	ORDER BY CG.Sort;
END;
$function$

```
</details>

## `contacts_insertbackupinfo`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_insertbackupinfo"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying) AS result("column_1" bigint);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function contacts_insertbackupinfo(integer,integer,integer,character varying,character varying) line 8 at RETURN QUERY
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertbackupinfo(userno integer, contactcnt integer, groupcnt integer, memo character varying, fullpath character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	INSERT INTO ContactsBackup (UserNo, ContactCnt, GroupCnt, Memo, RegDate, Path)
	VALUES (UserNo, ContactCnt, GroupCnt, Memo, NOW(), FullPath);

	RETURN QUERY
	SELECT COUNT(*) FROM ContactsBackup WHERE UserNo=contacts_insertbackupinfo.userno;
END;
$function$

```
</details>

## `contacts_insertcontactforoutlookentryid`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_insertcontactforoutlookentryid"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_insertcontactforoutlookentryid(integer,integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookentryid(userno integer, seq integer, outlookentryid character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    entrycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(Seq) INTO entrycount FROM ContactsUserOutlook

	WHERE OutlookEntryID = contacts_insertcontactforoutlookentryid.outlookentryid;

	IF EntryCount = 0 THEN
		INSERT INTO ContactsUserOutlook
		(
			UserNo,
			Seq,
			OutlookEntryID
		)
		VALUES
		(
			UserNo,
			Seq,
			OutlookEntryID
		);
	ELSE
		UPDATE ContactsUserOutlook
		SET
			OutlookEntryID = contacts_insertcontactforoutlookentryid.outlookentryid
		WHERE UserNo = contacts_insertcontactforoutlookentryid.userno
		AND Seq = contacts_insertcontactforoutlookentryid.seq;
	END IF;
END;
$function$

```
</details>

## `contacts_insertcontactforoutlookfolderentryid`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_insertcontactforoutlookfolderentryid"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_insertcontactforoutlookfolderentryid(integer,integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertcontactforoutlookfolderentryid(userno integer, groupno integer, folderentryid character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    entrycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(GroupNo) INTO entrycount FROM ContactsGroupOutlook

	WHERE OutlookFolderEntryID = contacts_insertcontactforoutlookfolderentryid.folderentryid;

	IF EntryCount = 0 THEN
		INSERT INTO ContactsGroupOutlook
		(
			UserNo,
			GroupNo,
			OutlookFolderEntryID
		)
		VALUES
		(
			UserNo,
			GroupNo,
			FolderEntryID
		);
	ELSE
		UPDATE ContactsGroupOutlook
		SET
			OutlookFolderEntryID = contacts_insertcontactforoutlookfolderentryid.folderentryid
		WHERE UserNo = contacts_insertcontactforoutlookfolderentryid.userno
		AND GroupNo = contacts_insertcontactforoutlookfolderentryid.groupno;
	END IF;
END;
$function$

```
</details>

## `contacts_insertgroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contacts_insertgroup"(0::integer, ''::character varying, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "sort" is ambiguous
- Stack context: PL/pgSQL function contacts_insertgroup(integer,character varying,integer) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertgroup(userno integer, grpname character varying, parentno integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sort FROM ContactsGroup
	WHERE RegUserNo = contacts_insertgroup.userno AND ParentGNo = contacts_insertgroup.parentno
	ORDER BY Sort DESC;

	INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
	VALUES (GrpName, ParentNo, UserNo, Sort+1,NOW(),'0','Y');

	GroupNo := lastval();
	RETURN QUERY
	SELECT GroupNo AS GroupNo;
END;
$function$

```
</details>

## `contacts_insertpublicgroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_insertpublicgroup"(0::integer, ''::character varying, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `42702`
- Error: column reference "sort" is ambiguous
- Stack context: PL/pgSQL function contacts_insertpublicgroup(integer,character varying,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertpublicgroup(userno integer DEFAULT 70, groupname character varying DEFAULT '{"KO":"Public 001","EN":"Public 001","VN":"Public 001","CH":"Public 001","JP":"Public 001"}'::character varying, parentno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sort FROM Contact_PublicGroup
	WHERE ParentNo = contacts_insertpublicgroup.parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_PublicGroup (PublicGroupName, ParentNo, RegUserNo, Sort,ModUserNo)
	VALUES (GroupName, ParentNo, UserNo, Sort+1,UserNo);
	RETURN QUERY
	SELECT CAST(lastval() AS INT) AS PublicGroupNo;
END;
$function$

```
</details>

## `contacts_insertsharegroup`

- Input: `0::integer, ''::character varying, 0::integer`
- Generated SQL: `SELECT * FROM "public"."contacts_insertsharegroup"(0::integer, ''::character varying, 0::integer) AS result("column_1" integer);`
- SQLSTATE: `42702`
- Error: column reference "sort" is ambiguous
- Stack context: PL/pgSQL function contacts_insertsharegroup(integer,character varying,integer) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertsharegroup(userno integer DEFAULT 70, sharegroupname character varying DEFAULT '{\"KO\":\"Share 001\",\"EN\":\"Share 001\",\"VN\":\"Share 001\",\"CH\":\"Share 001\",\"JP\":\"Share 001\"}'::character varying, parentno integer DEFAULT 0)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sort FROM Contact_ShareGroup
	WHERE ParentNo = contacts_insertsharegroup.parentno
	ORDER BY Sort DESC;
	INSERT INTO Contact_ShareGroup (ShareGroupName, ParentNo, RegUserNo,ModUserNo, Sort)
	VALUES (ShareGroupName, ParentNo, UserNo,UserNo, Sort+1);
	RETURN QUERY
	SELECT CAST(lastval() AS INT) ShareGroupNo;
END;
$function$

```
</details>

## `contacts_insertuserforexcel`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_insertuserforexcel"(0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, CURRENT_TIMESTAMP::timestamp without time zone, CURRENT_TIMESTAMP::timestamp without time zone, ''::character varying);`
- SQLSTATE: `42883`
- Error: function contacts_insertlistgroupcontact(integer, character varying) does not exist
- Stack context: PL/pgSQL function contacts_insertuserforexcel(integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,timestamp without time zone,timestamp without time zone,character varying) line 15 at PERFORM
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_insertuserforexcel(reguserno integer, lastname character varying, firstname character varying, callname character varying, phonenum character varying, companynum character varying, homenum character varying, faxnum character varying, company character varying, "position" character varying, depart character varying, email character varying, companyzip1 character varying, companyzip2 character varying, companyaddr character varying, homezip1 character varying, homezip2 character varying, homeaddr character varying, homepage character varying, memo character varying, grouplist character varying, regday timestamp without time zone, modday timestamp without time zone, share character varying DEFAULT '100'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    userno integer;
    isphonedef character varying;
    isaddrdef character varying;
    defvalue character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


-- ??? ????.;
INSERT INTO ContactsUser (FirstName, LastName, CallName,Memo, RegUserNo, RegDate,ModDate, UseYn,Share)
VALUES (FirstName, LastName, CallName,Memo, RegUserNo, RegDay,ModDay, 'Y',Share);
UserNo := lastval();
PERFORM contacts_insertlistgroupcontact(UserNo,Grouplist);
-- ?? ??.
--INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate)
--VALUES (GroupNo, UserNo, RegUserNo ,NOW())

-- ???? ??(0:???1:?2:??3:FAX)
-- ?? ???? ??.
IF PhoneNum != '' THEN
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 0, '???', PhoneNum, DefValue ,NOW());
END IF;

-- ? ???? ??.
IF HomeNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 1, '?', HomeNum, DefValue ,NOW());
END IF;

-- ?? ???? ??.
IF CompanyNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 2, '??', CompanyNum, DefValue ,NOW());
END IF;

-- ???? ??.
IF FaxNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 3, 'FAX', FaxNum, DefValue ,NOW());
END IF;

-- ??/??/?? ??.
IF Company != '' OR Depart != '' OR Position != '' THEN
	INSERT INTO ContactsCompany (RegUserNo, UserSeq, Company, Depart, Position, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Company, Depart, Position, '1' ,NOW());
END IF;

-- ?? ??.
IF Email != '' THEN
	INSERT INTO ContactsEmail (RegUserNo, UserSeq, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Email, '1' ,NOW());
END IF;
-- ????(0:??1:?)
-- ????
IF CompanyZip1 != '' OR CompanyZip2 != '' OR CompanyAddr != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 0, '??', CompanyZip1, CompanyZip2, CompanyAddr, DefValue ,NOW());
END IF;

-- ???
IF HomeZip1 != '' OR HomeZip2 != '' OR HomeAddr != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 1, '?', HomeZip1, HomeZip2, HomeAddr, DefValue ,NOW());
END IF;

-- ???? ??(0:????1:???2:??)
IF HomePage != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsHomepage
	(RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 0, '????', HomePage, DefValue ,NOW());
END IF;

RETURN QUERY
SELECT UserNo;
END;
$function$

```
</details>

## `contacts_moveallcontact`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_moveallcontact"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42P01`
- Error: relation "g" does not exist
- Stack context: PL/pgSQL function contacts_moveallcontact(integer,integer,integer) line 3 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_moveallcontact(userno integer DEFAULT 70, groupno integer DEFAULT 687, newgroupno integer DEFAULT 672)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
UPDATE G

SET GroupNo=contacts_moveallcontact.newgroupno
FROM ContactsGroupUser AS G
INNER JOIN ContactsUser AS U ON G.UserSeq= U.Seq AND U.RegUserNo=contacts_moveallcontact.userno AND U.UseYn='Y'
where G.GroupNo=contacts_moveallcontact.groupno;
END;
$function$

```
</details>

## `contacts_movecontactgroup`

- Input: `0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_movecontactgroup"(0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_movecontactgroup(integer,integer,integer,integer) line 9 at FOR over SELECT rows
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_movecontactgroup(userno integer DEFAULT 70, groupno integer DEFAULT 644, newparentno integer DEFAULT 627, "position" integer DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
    tempno integer;
BEGIN


Sort := 0;
FOR tempno IN SELECT  GroupNo from ContactsGroup WHERE RegUserNo=contacts_movecontactgroup.userno AND ParentGNo=contacts_movecontactgroup.newparentno AND UseYn='Y'  ORDER BY Sort ASC LOOP
		RAISE NOTICE '%', TEMPNO;
		IF Sort<Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort WHERE GroupNo=TEMPNO;
		END IF;
		IF Sort=Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort ,ParentGNo=contacts_movecontactgroup.newparentno WHERE GroupNo=contacts_movecontactgroup.groupno;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE GroupNo=TEMPNO;
		END IF;
		IF Sort>Position THEN
			RAISE NOTICE '%', Sort;
			UPDATE ContactsGroup SET Sort = Sort+1 WHERE TEMPNO=contacts_movecontactgroup.groupno;
		END IF;
		Sort := Sort+1;
		   END LOOP;
END;
$function$

```
</details>

## `contacts_moveuser`

- Input: `0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_moveuser"(0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_moveuser(integer,integer,integer,integer) line 7 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_moveuser(reguserno integer, userseq integer, curboxkey integer, newboxkey integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN




    UPDATE ContactsGroupUser SET GroupNo=contacts_moveuser.newboxkey
    WHERE RegUserNo=contacts_moveuser.reguserno AND GroupNo=contacts_moveuser.curboxkey AND UserSeq=contacts_moveuser.userseq;

    IF 0 <> 0 THEN

		END IF;
END;
$function$

```
</details>

## `contacts_restorecontactlist`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_restorecontactlist"(0::integer, ''::character varying);`
- SQLSTATE: `42883`
- Error: function contacts_stringtolistint(character varying) does not exist
- Stack context: PL/pgSQL function contacts_restorecontactlist(integer,character varying) line 4 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_restorecontactlist(reguserno integer, contactlist character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y', ModDate=NOW() WHERE Seq IN (SELECT * FROM Contacts_StringToListInt(ContactList)) AND RegUserNo=contacts_restorecontactlist.reguserno;
END;
$function$

```
</details>

## `contacts_saveaddressinfo`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_saveaddressinfo"(0::integer, 0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42804`
- Error: column "moddate" is of type timestamp without time zone but expression is of type integer
- Stack context: PL/pgSQL function contacts_saveaddressinfo(integer,integer,integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,integer,character varying) line 101 at SQL statement
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_saveaddressinfo(seq integer, userno integer, listgroup integer, firstname character varying DEFAULT ''::character varying, lastname character varying DEFAULT ''::character varying, callname character varying DEFAULT ''::character varying, telinfo character varying DEFAULT ''::character varying, emailinfo character varying DEFAULT ''::character varying, companyinfo character varying DEFAULT ''::character varying, addressinfo character varying DEFAULT ''::character varying, homepageinfo character varying DEFAULT ''::character varying, snsinfo character varying DEFAULT ''::character varying, groupinfo character varying DEFAULT ''::character varying, memo character varying DEFAULT ''::character varying, share character varying DEFAULT ''::character varying, important integer DEFAULT 0, photo character varying DEFAULT ''::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    chktelinfo character varying;
    temptel character varying;
    telisdefault integer;
    teltype smallint;
    teltypename character varying;
    telvalue character varying;
    telcnt integer;
    chkemailinfo character varying;
    tempemail character varying;
    emailisdefault integer;
    emailvalue character varying;
    emailcnt integer;
    chkcompanyinfo character varying;
    tempcompany character varying;
    companyisdefault integer;
    companyname character varying;
    depart character varying;
    position character varying;
    companycnt integer;
    chkaddrinfo character varying;
    tempaddr character varying;
    addrisdefault integer;
    addrtype smallint;
    addrtypename character varying;
    addrzipcode1 character varying;
    addrzipcode2 character varying;
    address character varying;
    addrcnt integer;
    chkhomeinfo character varying;
    temphome character varying;
    homeisdefault integer;
    hometype smallint;
    hometypename character varying;
    homevalue character varying;
    homecnt integer;
    chksnsinfo character varying;
    tempsns character varying;
    snsisdefault integer;
    snstype smallint;
    snstypename character varying;
    snsvalue character varying;
    snscnt integer;
    chkgroupinfo character varying;
    groupcnt integer;
    groupno integer;
    chktelinfoup character varying;
    temptelup character varying;
    telisdefaultup integer;
    teltypeup smallint;
    teltypenameup character varying;
    telvalueup character varying;
    telcntup integer;
    chkemailinfoup character varying;
    tempemailup character varying;
    emailisdefaultup integer;
    emailvalueup character varying;
    emailcntup integer;
    chkcompanyinfoup character varying;
    tempcompanyup character varying;
    companyisdefaultup integer;
    companynameup character varying;
    departup character varying;
    positionup character varying;
    companycntup integer;
    chkaddrinfoup character varying;
    tempaddrup character varying;
    addrisdefaultup integer;
    addrtypeup smallint;
    addrtypenameup character varying;
    addrzipcode1up character varying;
    addrzipcode2up character varying;
    addressup character varying;
    addrcntup integer;
    chkhomeinfoup character varying;
    temphomeup character varying;
    homeisdefaultup integer;
    hometypeup smallint;
    hometypenameup character varying;
    homevalueup character varying;
    homecntup integer;
    chksnsinfoup character varying;
    tempsnsup character varying;
    snsisdefaultup integer;
    snstypeup smallint;
    snstypenameup character varying;
    snsvalueup character varying;
    snscntup integer;
    chkgroupinfoup character varying;
    groupcntup integer;
    groupnoup integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Seq = 0 THEN

		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		INSERT INTO ContactsUser
		(
			FirstName,
			LastName,
			CallName,
			Memo,
			Share,
			Important,
			Photo,
			UseYn,
			RegUserNo,
			RegDate,
			ModDate
		)
		VALUES
		(
			FirstName,
			LastName,
			CallName,
			Memo,
			Share,
			Important,
			Photo,
			'Y',
			UserNo,
			NOW(),
			UserNo
		);
		Seq := lastval();
		-- ===========================================
		PERFORM contacts_insertlistgroupcontact(Seq,Listgroup);

		-- ============================================
		-- 전화번호
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabNumber (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkTelInfo := REPLACE(TelInfo,',','');
		IF LEN(ChkTelInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			TelInfo := contacts_saveaddressinfo.telinfo || '$';
			-- Row 분리
			WHILE STRPOS(TelInfo, '$') > 0 LOOP

				TempTel := SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'));
				--SELECT TempTel AS TempTel






				-- Column 분리
				WHILE STRPOS(TempTel, ',') > 0 LOOP

					IF TelCnt = 0 THEN
						--SET TelIsDefault = SUBSTRING(TempTel,0,STRPOS(TempTel, ','));
						TelIsDefault := 1;
					ELSIF TelCnt = 1 THEN
						TelType := SUBSTRING(TempTel,0,STRPOS(TempTel, ','));
					ELSIF TelCnt = 2 THEN
						TelTypeName := SUBSTRING(TempTel,0,STRPOS(TempTel, ','));
					END IF;
					TelCnt := TelCnt + 1;
					TempTel := SUBSTRING(TempTel,STRPOS(TempTel, ',')+1,LEN(TempTel));
				END LOOP;
				TelValue := TempTel;
				-- 임시테이블에 저장;
				INSERT INTO tabNumber
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					TelIsDefault,
					TelType,
					TelTypeName,
					TelValue
				);
				TelInfo := SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumber;
		ELSE
			DELETE FROM ContactsNumber WHERE RegUserNo = contacts_saveaddressinfo.userno AND UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE tabEmail (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		ChkEmailInfo := REPLACE(EmailInfo,',','');
		IF LEN(ChkEmailInfo) > 0 THEN
			EmailInfo := contacts_saveaddressinfo.emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0 LOOP

				TempEmail := SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempEmail, ',') > 0 LOOP
					IF EmailCnt = 0 THEN
						EmailIsDefault := SUBSTRING(TempEmail,0,STRPOS(TempEmail, ','));
					END IF;
					EmailCnt := EmailCnt + 1;
					TempEmail := SUBSTRING(TempEmail,STRPOS(TempEmail, ',')+1,LEN(TempEmail));
				END LOOP;
				EmailValue := TempEmail;
				INSERT INTO tabEmail
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefault,
					EmailValue
				);
				EmailInfo := SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmail;
		ELSE
			DELETE FROM ContactsEmail WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE tabCompany (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		ChkCompanyInfo := REPLACE(CompanyInfo,',','');
		IF LEN(ChkCompanyInfo) > 0 THEN
			CompanyInfo := contacts_saveaddressinfo.companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0 LOOP

				TempCompany := SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempCompany, ',') > 0 LOOP
					IF CompanyCnt = 0 THEN
						CompanyIsDefault := SUBSTRING(TempCompany,0,STRPOS(TempCompany, ','));
					ELSIF CompanyCnt = 1 THEN
						CompanyName := SUBSTRING(TempCompany,0,STRPOS(TempCompany, ','));
					ELSIF CompanyCnt = 2 THEN
						Depart := SUBSTRING(TempCompany,0,STRPOS(TempCompany, ','));
					END IF;
					CompanyCnt := CompanyCnt + 1;
					TempCompany := SUBSTRING(TempCompany,STRPOS(TempCompany, ',')+1,LEN(TempCompany));
				END LOOP;
				Position := TempCompany;
				INSERT INTO tabCompany
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					CompanyIsDefault,
					CompanyName,
					Depart,
					Position
				);
				CompanyInfo := SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompany;
		ELSE
			DELETE FROM ContactsCompany WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE tabAddr (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500)) ON COMMIT DROP;



		ChkAddrInfo := REPLACE(AddressInfo,',','');
		IF LEN(ChkAddrInfo) > 0 THEN
			AddressInfo := contacts_saveaddressinfo.addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0 LOOP

				TempAddr := SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempAddr, ',') > 0 LOOP
					IF AddrCnt = 0 THEN
						AddrIsDefault := SUBSTRING(TempAddr,0,STRPOS(TempAddr, ','));
					ELSIF AddrCnt = 1 THEN
						AddrType := SUBSTRING(TempAddr,0,STRPOS(TempAddr, ','));
					ELSIF AddrCnt = 2 THEN
						AddrTypeName := SUBSTRING(TempAddr,0,STRPOS(TempAddr, ','));
					ELSIF AddrCnt = 3 THEN
						AddrZipCode1 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, ','));
					ELSIF AddrCnt = 4 THEN
						AddrZipCode2 := SUBSTRING(TempAddr,0,STRPOS(TempAddr, ','));
					END IF;
					AddrCnt := AddrCnt + 1;
					TempAddr := SUBSTRING(TempAddr,STRPOS(TempAddr, ',')+1,LEN(TempAddr));
				END LOOP;
				Address := TempAddr;
				INSERT INTO tabAddr
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address
				)
				VALUES
				(
					AddrIsDefault,
					AddrType,
					AddrTypeName,
					AddrZipCode1,
					AddrZipCode2,
					Address
				);
				AddressInfo := SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW() FROM tabAddr;
		ELSE
			DELETE FROM ContactsAddress WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabHome (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkHomeInfo := REPLACE(HomepageInfo,',','');
		IF LEN(ChkHomeInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			HomepageInfo := contacts_saveaddressinfo.homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(HomepageInfo, '$') > 0 LOOP

				TempHome := SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempHome, ',') > 0 LOOP

					IF HomeCnt = 0 THEN
						HomeIsDefault := SUBSTRING(TempHome,0,STRPOS(TempHome, ','));
					ELSIF HomeCnt = 1 THEN
						HomeType := SUBSTRING(TempHome,0,STRPOS(TempHome, ','));
					ELSIF HomeCnt = 2 THEN
						HomeTypeName := SUBSTRING(TempHome,0,STRPOS(TempHome, ','));
					END IF;
					HomeCnt := HomeCnt + 1;
					TempHome := SUBSTRING(TempHome,STRPOS(TempHome, ',')+1,LEN(TempHome));
				END LOOP;
				HomeValue := TempHome;
				-- 임시테이블에 저장;
				INSERT INTO tabHome
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					HomeIsDefault,
					HomeType,
					HomeTypeName,
					HomeValue
				);
				HomepageInfo := SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHome;
		ELSE
			DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_saveaddressinfo.userno AND UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabSns (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkSnsInfo := REPLACE(SnsInfo,',','');
		IF LEN(ChkSnsInfo) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			SnsInfo := contacts_saveaddressinfo.snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(SnsInfo, '$') > 0 LOOP

				TempSns := SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempSns, ',') > 0 LOOP

					IF SnsCnt = 0 THEN
						SnsIsDefault := SUBSTRING(TempSns,0,STRPOS(TempSns, ','));
					ELSIF SnsCnt = 1 THEN
						SnsType := SUBSTRING(TempSns,0,STRPOS(TempSns, ','));
					ELSIF SnsCnt = 2 THEN
						SnsTypeName := SUBSTRING(TempSns,0,STRPOS(TempSns, ','));
					END IF;
					SnsCnt := SnsCnt + 1;
					TempSns := SUBSTRING(TempSns,STRPOS(TempSns, ',')+1,LEN(TempSns));
				END LOOP;
				SnsValue := TempSns;
				-- 임시테이블에 저장;
				INSERT INTO tabSns
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					SnsIsDefault,
					SnsType,
					SnsTypeName,
					SnsValue
				);
				SnsInfo := SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSns;
		ELSE
			DELETE FROM ContactsSns WHERE RegUserNo = contacts_saveaddressinfo.userno AND UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE tabGroup (GroupNo INT, UserSeq INT) ON COMMIT DROP;



		ChkGroupInfo := REPLACE(GroupInfo,',','');
		IF LEN(ChkGroupInfo) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo.seq;
			-- 정보가 존재하면 끝에 , 추가;
			GroupInfo := contacts_saveaddressinfo.groupinfo || ',';
			WHILE STRPOS(GroupInfo, ',') > 0 LOOP
				GroupNo := SUBSTRING(GroupInfo,0,STRPOS(GroupInfo, ','));
				INSERT INTO tabGroup
				(
					GroupNo,
					UserSeq
				)
				VALUES
				(
					GroupNo,
					Seq
				);

				GroupCnt := GroupCnt + 1;
				GroupInfo := SUBSTRING(GroupInfo,STRPOS(GroupInfo, ',')+1,LEN(GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo.seq;
		END IF;

		IF 0 <> 0 THEN

		END IF;

	ELSE

		-- ============================================
		-- 수정전에 히스토리 저장 처리
		-- ============================================
		PERFORM contacts_savecontactshistory(UserNo, Seq, 'UPD');
		-- ============================================
		-- 주소록 기본 저장
		-- ============================================;
		UPDATE ContactsUser
		SET
			FirstName = contacts_saveaddressinfo.firstname,
			LastName = contacts_saveaddressinfo.lastname,
			CallName = contacts_saveaddressinfo.callname,
			Memo = contacts_saveaddressinfo.memo,
			Share = contacts_saveaddressinfo.share,
			Photo = contacts_saveaddressinfo.photo,
			Important = contacts_saveaddressinfo.important,
			ModDate = NOW()
		WHERE Seq = contacts_saveaddressinfo.seq;

		CREATE TEMP TABLE tabNumberUp (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkTelInfoUp := REPLACE(TelInfo,',','');
		DELETE FROM ContactsNumber WHERE RegUserNo = contacts_saveaddressinfo.userno AND UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkTelInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 전화정보가 존재하면 끝에 $ 추가;
			TelInfo := contacts_saveaddressinfo.telinfo || '$';
			-- Row 분리
			WHILE STRPOS(TelInfo, '$') > 0 LOOP

				TempTelUp := SUBSTRING(TelInfo,0,STRPOS(TelInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempTelUp, ',') > 0 LOOP

					IF TelCntUp = 0 THEN
						TelIsDefaultUp := SUBSTRING(TempTelUp,0,STRPOS(TempTelUp, ','));
					ELSIF TelCntUp = 1 THEN
						TelTypeUp := SUBSTRING(TempTelUp,0,STRPOS(TempTelUp, ','));
					ELSIF TelCntUp = 2 THEN
						TelTypeNameUp := SUBSTRING(TempTelUp,0,STRPOS(TempTelUp, ','));
					END IF;
					TelCntUp := TelCntUp + 1;
					TempTelUp := SUBSTRING(TempTelUp,STRPOS(TempTelUp, ',')+1,LEN(TempTelUp));
				END LOOP;
				TelValueUp := TempTelUp;
				-- 임시테이블에 저장;
				INSERT INTO tabNumberUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					TelIsDefaultUp,
					TelTypeUp,
					TelTypeNameUp,
					TelValueUp
				);
				TelInfo := SUBSTRING(TelInfo,STRPOS(TelInfo, '$')+1,LEN(TelInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabNumberUp;
		END IF;

		-- ============================================
		-- 이메일
		-- ============================================
		CREATE TEMP TABLE tabEmailUp (IsDefault CHAR(1), Value varchar(50)) ON COMMIT DROP;



		ChkEmailInfoUp := REPLACE(EmailInfo,',','');
		DELETE FROM ContactsEmail WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkEmailInfoUp) > 0 THEN
			EmailInfo := contacts_saveaddressinfo.emailinfo || '$';
			-- Row 분리
			WHILE STRPOS(EmailInfo, '$') > 0 LOOP

				TempEmailUp := SUBSTRING(EmailInfo,0,STRPOS(EmailInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempEmailUp, ',') > 0 LOOP
					IF EmailCntUp = 0 THEN
						EmailIsDefaultUp := SUBSTRING(TempEmailUp,0,STRPOS(TempEmailUp, ','));
					END IF;
					EmailCntUp := EmailCntUp + 1;
					TempEmailUp := SUBSTRING(TempEmailUp,STRPOS(TempEmailUp, ',')+1,LEN(TempEmailUp));
				END LOOP;
				EmailValueUp := TempEmailUp;
				INSERT INTO tabEmailUp
				(
					IsDefault,
					Value
				)
				VALUES
				(
					EmailIsDefaultUp,
					EmailValueUp
				);
				EmailInfo := SUBSTRING(EmailInfo,STRPOS(EmailInfo, '$')+1,LEN(EmailInfo));
			END LOOP;
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				UserSeq,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Value, IsDefault, NOW(), NOW() FROM tabEmailUp;
		END IF;

		-- ============================================
		-- 회사
		-- ============================================
		CREATE TEMP TABLE tabCompanyUp (IsDefault CHAR(1), Company varchar(50), Depart varchar(50), Position varchar(50)) ON COMMIT DROP;



		ChkCompanyInfoUp := REPLACE(CompanyInfo,',','');
		DELETE FROM ContactsCompany WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkCompanyInfoUp) > 0 THEN
			CompanyInfo := contacts_saveaddressinfo.companyinfo || '$';
			-- Row 분리
			WHILE STRPOS(CompanyInfo, '$') > 0 LOOP

				TempCompanyUp := SUBSTRING(CompanyInfo,0,STRPOS(CompanyInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempCompanyUp, ',') > 0 LOOP
					IF CompanyCntUp = 0 THEN
						CompanyIsDefaultUp := SUBSTRING(TempCompanyUp,0,STRPOS(TempCompanyUp, ','));
					ELSIF CompanyCntUp = 1 THEN
						CompanyNameUp := SUBSTRING(TempCompanyUp,0,STRPOS(TempCompanyUp, ','));
					ELSIF CompanyCntUp = 2 THEN
						DepartUp := SUBSTRING(TempCompanyUp,0,STRPOS(TempCompanyUp, ','));
					END IF;
					CompanyCntUp := CompanyCntUp + 1;
					TempCompanyUp := SUBSTRING(TempCompanyUp,STRPOS(TempCompanyUp, ',')+1,LEN(TempCompanyUp));
				END LOOP;
				PositionUp := TempCompanyUp;
				INSERT INTO tabCompanyUp
				(
					IsDefault,
					Company,
					Depart,
					Position
				)
				VALUES
				(
					CompanyIsDefaultUp,
					CompanyNameUp,
					DepartUp,
					PositionUp
				);
				CompanyInfo := SUBSTRING(CompanyInfo,STRPOS(CompanyInfo, '$')+1,LEN(CompanyInfo));
			END LOOP;
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Company, Depart, Position, IsDefault, NOW(), NOW() FROM tabCompanyUp;
		END IF;
		-- ============================================
		-- 주소
		-- ============================================
		CREATE TEMP TABLE tabAddrUp (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), ZipCode1 varchar(5), ZipCode2 varchar(5), Address varchar(500)) ON COMMIT DROP;



		ChkAddrInfoUp := REPLACE(AddressInfo,',','');
		DELETE FROM ContactsAddress WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkAddrInfoUp) > 0 THEN
			AddressInfo := contacts_saveaddressinfo.addressinfo || '$';
			-- Row 분리
			WHILE STRPOS(AddressInfo, '$') > 0 LOOP

				TempAddrUp := SUBSTRING(AddressInfo,0,STRPOS(AddressInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempAddrUp, ',') > 0 LOOP
					IF AddrCntUp = 0 THEN
						AddrIsDefaultUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, ','));
					ELSIF AddrCntUp = 1 THEN
						AddrTypeUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, ','));
					ELSIF AddrCntUp = 2 THEN
						AddrTypeNameUp := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, ','));
					ELSIF AddrCntUp = 3 THEN
						AddrZipCode1Up := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, ','));
					ELSIF AddrCntUp = 4 THEN
						AddrZipCode2Up := SUBSTRING(TempAddrUp,0,STRPOS(TempAddrUp, ','));
					END IF;
					AddrCntUp := AddrCntUp + 1;
					TempAddrUp := SUBSTRING(TempAddrUp,STRPOS(TempAddrUp, ',')+1,LEN(TempAddrUp));
				END LOOP;
				AddressUp := TempAddrUp;
				INSERT INTO tabAddrUp
				(
					IsDefault,
					Type,
					TypeName,
					ZipCode1,
					ZipCode2,
					Address
				)
				VALUES
				(
					AddrIsDefaultUp,
					AddrTypeUp,
					AddrTypeNameUp,
					AddrZipCode1Up,
					AddrZipCode2Up,
					AddressUp
				);
				AddressInfo := SUBSTRING(AddressInfo,STRPOS(AddressInfo, '$')+1,LEN(AddressInfo));
			END LOOP;
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, NOW(), NOW() FROM tabAddrUp;
		END IF;

		-- ============================================
		-- 홈페이지
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabHomeUp (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkHomeInfoUp := REPLACE(HomepageInfo,',','');
		DELETE FROM ContactsHomepage WHERE RegUserNo = contacts_saveaddressinfo.userno And UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkHomeInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			HomepageInfo := contacts_saveaddressinfo.homepageinfo || '$';
			-- Row 분리
			WHILE STRPOS(HomepageInfo, '$') > 0 LOOP

				TempHomeUp := SUBSTRING(HomepageInfo,0,STRPOS(HomepageInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempHomeUp, ',') > 0 LOOP

					IF HomeCntUp = 0 THEN
						HomeIsDefaultUp := SUBSTRING(TempHomeUp,0,STRPOS(TempHomeUp, ','));
					ELSIF HomeCntUp = 1 THEN
						HomeTypeUp := SUBSTRING(TempHomeUp,0,STRPOS(TempHomeUp, ','));
					ELSIF HomeCntUp = 2 THEN
						HomeTypeNameUp := SUBSTRING(TempHomeUp,0,STRPOS(TempHomeUp, ','));
					END IF;
					HomeCntUp := HomeCntUp + 1;
					TempHomeUp := SUBSTRING(TempHomeUp,STRPOS(TempHomeUp, ',')+1,LEN(TempHomeUp));
				END LOOP;
				HomeValueUp := TempHomeUp;
				-- 임시테이블에 저장;
				INSERT INTO tabHomeUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					HomeIsDefaultUp,
					HomeTypeUp,
					HomeTypeNameUp,
					HomeValueUp
				);
				HomepageInfo := SUBSTRING(HomepageInfo,STRPOS(HomepageInfo, '$')+1,LEN(HomepageInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabHomeUp;
		END IF;
		-- ============================================
		-- 메신저 SNS
		-- ============================================
		-- 임시테이블 생성
		CREATE TEMP TABLE tabSnsUp (IsDefault CHAR(1), Type TINYINT, TypeName varchar(50), Value varchar(50)) ON COMMIT DROP;
		-- 체크데이터 생성;


		ChkSnsInfoUp := REPLACE(SnsInfo,',','');
		DELETE FROM ContactsSns WHERE RegUserNo = contacts_saveaddressinfo.userno AND UserSeq = contacts_saveaddressinfo.seq;

		IF LEN(ChkSnsInfoUp) > 0 THEN -- 값이 존재하는지 체크
			-- 정보가 존재하면 끝에 $ 추가;
			SnsInfo := contacts_saveaddressinfo.snsinfo || '$';
			-- Row 분리
			WHILE STRPOS(SnsInfo, '$') > 0 LOOP

				TempSnsUp := SUBSTRING(SnsInfo,0,STRPOS(SnsInfo, '$'));
				-- Column 분리
				WHILE STRPOS(TempSnsUp, ',') > 0 LOOP

					IF SnsCntUp = 0 THEN
						SnsIsDefaultUp := SUBSTRING(TempSnsUp,0,STRPOS(TempSnsUp, ','));
					ELSIF SnsCntUp = 1 THEN
						SnsTypeUp := SUBSTRING(TempSnsUp,0,STRPOS(TempSnsUp, ','));
					ELSIF SnsCntUp = 2 THEN
						SnsTypeNameUp := SUBSTRING(TempSnsUp,0,STRPOS(TempSnsUp, ','));
					END IF;
					SnsCntUp := SnsCntUp + 1;
					TempSnsUp := SUBSTRING(TempSnsUp,STRPOS(TempSnsUp, ',')+1,LEN(TempSnsUp));
				END LOOP;
				SnsValueUp := TempSnsUp;
				-- 임시테이블에 저장;
				INSERT INTO tabSnsUp
				(
					IsDefault,
					Type,
					TypeName,
					Value
				)
				VALUES
				(
					SnsIsDefaultUp,
					SnsTypeUp,
					SnsTypeNameUp,
					SnsValueUp
				);
				SnsInfo := SUBSTRING(SnsInfo,STRPOS(SnsInfo, '$')+1,LEN(SnsInfo));
			END LOOP;
			-- 최종 저장;
			INSERT INTO ContactsSns
			(
				RegUserNo,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault,
				RegDate,
				ModDate
			)
			SELECT UserNo, Seq, Type, TypeName, Value, IsDefault, NOW(), NOW() FROM tabSnsUp;
		END IF;

		-- ============================================
		-- 그룹관련
		-- ============================================
		CREATE TEMP TABLE tabGroupUp (GroupNo INT, UserSeq INT) ON COMMIT DROP;



		ChkGroupInfoUp := REPLACE(GroupInfo,',','');
		IF LEN(ChkGroupInfoUp) > 0 THEN
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo.seq;
			-- 정보가 존재하면 끝에 , 추가;
			GroupInfo := contacts_saveaddressinfo.groupinfo || ',';
			WHILE STRPOS(GroupInfo, ',') > 0 LOOP
				GroupNoUp := SUBSTRING(GroupInfo,0,STRPOS(GroupInfo, ','));
				INSERT INTO tabGroup
				(
					GroupNo,
					UserSeq
				)
				VALUES
				(
					GroupNoUp,
					Seq
				);

				GroupCntUp := GroupCntUp + 1;
				GroupInfo := SUBSTRING(GroupInfo,STRPOS(GroupInfo, ',')+1,LEN(GroupInfo));
			END LOOP;

			INSERT INTO ContactsGroupUser
			(
				GroupNo,
				UserSeq,
				RegUserNo,
				RegDate,
				ModDate
			)
			SELECT GroupNo, UserSeq, UserNo, NOW(), NOW() FROM tabGroup;
		ELSE
			DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_saveaddressinfo.seq;
		END IF;
		IF 0 <> 0 THEN

		END IF;

	END IF;

	RETURN QUERY
	Select Seq;
END;
$function$

```
</details>

## `contacts_savecontactsforoutlook`

- Input: `0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_savecontactsforoutlook"(0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "outlookentryid" is ambiguous
- Stack context: PL/pgSQL function contacts_savecontactsforoutlook(integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying) line 13 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_savecontactsforoutlook(userno integer, outlookentryid character varying, folderentryid character varying, firstname character varying, lastname character varying, memo character varying, company character varying, depart character varying, "position" character varying, email1 character varying, email2 character varying, email3 character varying, mobilephone character varying, homephone character varying, homefax character varying, homepost character varying, homeaddress character varying, workphone character varying, workfax character varying, workpost character varying, workaddress character varying, otherphone character varying, otherfax character varying, otherpost character varying, otheraddress character varying, webpage character varying, massenger character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    contactno integer;
    contactscount integer;
    companyseq integer;
    companycount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT COUNT(Seq) INTO contactscount FROM ContactsUserOutlook

	WHERE OutlookEntryID = contacts_savecontactsforoutlook.outlookentryid;

	IF ContactsCount = 0 THEN
		-- 주소록 추가 작업;
		INSERT INTO ContactsUser
		(
			FirstName,
			LastName,
			RegUserNo,
			RegDate,
			ModDate,
			CheckDate,
			Memo,
			Photo,
			Share,
			UseYn,
			Important,
			CallName,
			ViewCount
		)
		VALUES
		(
			FirstName,
			LastName,
			UserNo,
			NOW(),
			NOW(),
			NOW(),
			Memo,
			'',
			'100',
			'Y',
			0,
			'',
			0
		);
		ContactNo := lastval();
		-- 그룹;
		INSERT INTO ContactsGroupUser
		(
			RegUserNo,
			RegDate,
			ModDate,
			UserSeq,
			GroupNo
		)
		VALUES
		(
			UserNo,
			NOW(),
			NOW(),
			ContactNo,
			COALESCE((SELECT GroupNo FROM ContactsGroupOutlook WHERE OutlookFolderEntryID = contacts_savecontactsforoutlook.folderentryid),0)
		);

		-- 회사정보가 있는 경우만
		IF LEN(Company) > 0 OR LEN(Depart) > 0 OR LEN(Position) > 0 THEN
			INSERT INTO ContactsCompany
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Company,
				Depart,
				Position,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				Company,
				Depart,
				Position,
				'1'
			);
		END IF;
		-- 이메일1
		IF LEN(EMail1) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail1,
				'1'
			);
		END IF;
		-- 이메일2
		IF LEN(EMail2) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail2,
				'0'
			);
		END IF;
		-- 이메일3
		IF LEN(EMail3) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail3,
				'0'
			);
		END IF;
		-- 홈페이지
		IF LEN(WebPage) > 0 THEN
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'홈페이지',
				WebPage,
				1
			);
		END IF;
		-- 메신저
		IF LEN(Massenger) > 0 THEN
			INSERT INTO ContactsSns
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				Massenger,
				1
			);
		END IF;
		-- 휴대폰
		IF LEN(MobilePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'휴대폰',
				MobilePhone,
				1
			);
		END IF;
		-- 집전화
		IF LEN(HomePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				HomePhone,
				0
			);
		END IF;
		-- 집팩스
		IF LEN(HomeFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				HomeFax,
				0
			);
		END IF;
		-- 회사전화
		IF LEN(WorkPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				2,
				'회사',
				WorkPhone,
				0
			);
		END IF;
		-- 회사팩스
		IF LEN(WorkFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				WorkFax,
				0
			);
		END IF;
		-- 기타전화
		IF LEN(OtherPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				OtherPhone,
				0
			);
		END IF;
		-- 기타팩스
		IF LEN(OtherFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				OtherFax,
				0
			);
		END IF;
		--집주소
		IF LEN(HomePost) > 0 OR LEN(HomeAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				SUBSTRING(HomePost,1,3),
				SUBSTRING(HomePost,4,3),
				HomeAddress,
				0
			);
		END IF;
		--회사주소
		IF LEN(WorkPost) > 0 OR LEN(WorkAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'회사',
				SUBSTRING(WorkPost,1,3),
				SUBSTRING(WorkPost,4,3),
				WorkAddress,
				0
			);
		END IF;
		--기타주소
		IF LEN(OtherPost) > 0 OR LEN(OtherAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				SUBSTRING(OtherPost,1,3),
				SUBSTRING(OtherPost,4,3),
				OtherAddress,
				0
			);
		END IF;
	ELSE
		SELECT Seq INTO contactno FROM ContactsUserOutlook

		WHERE UserNo = contacts_savecontactsforoutlook.userno
		AND OutlookEntryID = contacts_savecontactsforoutlook.outlookentryid;
		-- 주소록 추가 작업;
		UPDATE ContactsUser
		SET
			FirstName = contacts_savecontactsforoutlook.firstname,
			LastName = contacts_savecontactsforoutlook.lastname,
			ModDate = NOW(),
			Memo = contacts_savecontactsforoutlook.memo
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND Seq = ContactNo;

		-- 그룹;
		UPDATE ContactsGroupUser
		SET
			ModDate = NOW(),
			UserSeq = ContactNo,
			GroupNo = COALESCE((SELECT GroupNo FROM ContactsGroupOutlook WHERE OutlookFolderEntryID = contacts_savecontactsforoutlook.folderentryid),0)
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno;

		-- 회사정보가 있는 경우만
		IF LEN(Company) > 0 OR LEN(Depart) > 0 OR LEN(Position) > 0 THEN


			SELECT COUNT(Company) INTO companycount FROM ContactsCompany

			WHERE Company = contacts_savecontactsforoutlook.company;

			IF CompanyCount = 0 THEN
				INSERT INTO ContactsCompany
				(
					RegUserNo,
					RegDate,
					ModDate,
					UserSeq,
					Company,
					Depart,
					Position,
					IsDefault
				)
				VALUES
				(
					UserNo,
					NOW(),
					NOW(),
					ContactNo,
					Company,
					Depart,
					Position,
					'0'
				);
			END IF;
			BEGIN
				SELECT Seq INTO companyseq FROM ContactsCompany
				WHERE Company = contacts_savecontactsforoutlook.company;

				UPDATE ContactsCompany
				SET
					Company = contacts_savecontactsforoutlook.company,
					Depart = contacts_savecontactsforoutlook.depart,
					Position = Position
				WHERE Seq = CompanySeq;
			END;
			END IF;
		END IF;
		-- 기존 메일 삭제후 재입력;
		DELETE FROM ContactsEmail
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo;
		-- 이메일1
		IF LEN(EMail1) > 0 THEN

			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail1,
				'1'
			);

		END IF;
		-- 이메일2
		IF LEN(EMail2) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail2,
				'0'
			);
		END IF;
		-- 이메일3
		IF LEN(EMail3) > 0 THEN
			INSERT INTO ContactsEmail
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				EMail3,
				'0'
			);
		END IF;
		-- 기존 홈페이지 삭제;
		DELETE FROM ContactsHomepage
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		AND Type = 0;
		-- 홈페이지
		IF LEN(WebPage) > 0 THEN
			INSERT INTO ContactsHomepage
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'홈페이지',
				WebPage,
				1
			);
		END IF;
		-- 기존 메신저정보 삭제;
		DELETE FROM ContactsSns
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo
		AND Type = 8;
		-- 메신저
		IF LEN(Massenger) > 0 THEN
			INSERT INTO ContactsSns
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				Massenger,
				1
			);
		END IF;
		-- 기존 전화번호 삭제;
		DELETE FROM ContactsNumber
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo;
		-- 휴대폰
		IF LEN(MobilePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'휴대폰',
				MobilePhone,
				1
			);
		END IF;
		-- 집전화
		IF LEN(HomePhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				HomePhone,
				0
			);
		END IF;
		-- 집팩스
		IF LEN(HomeFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				HomeFax,
				0
			);
		END IF;
		-- 회사전화
		IF LEN(WorkPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				2,
				'회사',
				WorkPhone,
				0
			);
		END IF;
		-- 회사팩스
		IF LEN(WorkFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				WorkFax,
				0
			);
		END IF;
		-- 기타전화
		IF LEN(OtherPhone) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				OtherPhone,
				0
			);
		END IF;
		-- 기타팩스
		IF LEN(OtherFax) > 0 THEN
			INSERT INTO ContactsNumber
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				Value,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				3,
				'FAX',
				OtherFax,
				0
			);
		END IF;
		-- 기존주소 삭제;
		DELETE FROM ContactsAddress
		WHERE RegUserNo = contacts_savecontactsforoutlook.userno
		AND UserSeq = ContactNo;
		--집주소
		IF LEN(HomePost) > 0 OR LEN(HomeAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				1,
				'집',
				SUBSTRING(HomePost,1,3),
				SUBSTRING(HomePost,4,3),
				HomeAddress,
				0
			);
		END IF;
		--회사주소
		IF LEN(WorkPost) > 0 OR LEN(WorkAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				0,
				'회사',
				SUBSTRING(WorkPost,1,3),
				SUBSTRING(WorkPost,4,3),
				WorkAddress,
				0
			);
		END IF;
		--기타주소
		IF LEN(OtherPost) > 0 OR LEN(OtherAddress) > 0 THEN
			INSERT INTO ContactsAddress
			(
				RegUserNo,
				RegDate,
				ModDate,
				UserSeq,
				Type,
				TypeName,
				ZipCode1,
				ZipCode2,
				Address,
				IsDefault
			)
			VALUES
			(
				UserNo,
				NOW(),
				NOW(),
				ContactNo,
				8,
				'기타',
				SUBSTRING(OtherPost,1,3),
				SUBSTRING(OtherPost,4,3),
				OtherAddress,
				0
			);
		END IF;
END;
$function$

```
</details>

## `contacts_savecontactshistory`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_savecontactshistory"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_savecontactshistory(integer,integer,character varying) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_savecontactshistory(userno integer, seq integer, status character varying DEFAULT 'DEL'::character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    historyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	-- 주소록 메인;
	INSERT INTO ContactsUserHistory
	(
		Seq, FirstName, LastName, RegUserNo, Memo,
		RegDate, Photo, ModDate, CheckDate, Share,
		UseYn, DelDate, Important, CallName, ViewCount,
		Status
	)
	SELECT
		Seq, FirstName,LastName,RegUserNo, Memo,
		RegDate, Photo, NOW(), CheckDate, Share,
		UseYn, DelDate, Important, CallName, ViewCount,
		Status
	FROM ContactsUser
	WHERE RegUserNo=contacts_savecontactshistory.userno AND Seq=contacts_savecontactshistory.seq;

	HistoryNo := lastval();
	-- 전화번호 기록;
	INSERT INTO ContactsNumberHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, NOW()
	FROM ContactsNumber
	WHERE RegUserNo=contacts_savecontactshistory.userno AND UserSeq = contacts_savecontactshistory.seq;
	-- 이메일 이력;
	INSERT INTO ContactsEmailHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Value,
		IsDefault, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Value,
		IsDefault, RegDate, NOW()
	FROM ContactsEmail
	WHERE RegUserNo = contacts_savecontactshistory.userno AND UserSeq = contacts_savecontactshistory.seq;
	-- 기념일 이력;
	INSERT INTO ContactsDaysHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, SolarLunar, RegDate,
		ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, SolarLunar, RegDate,
		NOW()
	FROM ContactsDays
	WHERE RegUserNo = contacts_savecontactshistory.userno AND UserSeq = contacts_savecontactshistory.seq;
	-- 회사;
	INSERT INTO ContactsCompanyHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Company,
		Depart, Position, IsDefault, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Company,
		Depart, Position, IsDefault, RegDate, NOW()
	FROM ContactsCompany
	WHERE RegUserNo = contacts_savecontactshistory.userno AND UserSeq = contacts_savecontactshistory.seq;
	-- 주소;
	INSERT INTO ContactsAddressHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, ZipCode1, ZipCode2, Address, IsDefault,
		RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, ZipCode1, ZipCode2, Address, IsDefault,
		RegDate, NOW()
	FROM ContactsAddress
	WHERE RegUserNo = contacts_savecontactshistory.userno ANd UserSeq = contacts_savecontactshistory.seq;
	-- 홈페이지;
	INSERT INTO ContactsHomepageHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	FROM ContactsHomepage
	WHERE RegUserNo = contacts_savecontactshistory.userno AND UserSeq = contacts_savecontactshistory.seq;
	-- SNS;
	INSERT INTO ContactsSnsHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, NOW()
	FROM ContactsSns
	WHERE RegUserNo = contacts_savecontactshistory.userno ANd UserSeq = contacts_savecontactshistory.seq;

	-- 그룹;
	INSERT INTO ContactsGroupUserHistory
	(
		HistoryNo, Seq, GroupNo, UserSeq, RegUserNo, RegDate, ModDate
	)
	SELECT
		HistoryNo, Seq, GroupNo, UserSeq, RegUserNo, RegDate, NOW()
	FROM ContactsGroupUser
	WHERE RegUserNo = contacts_savecontactshistory.userno ANd UserSeq = contacts_savecontactshistory.seq;
END;
$function$

```
</details>

## `contacts_savegroupforoutlook`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_savegroupforoutlook"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_savegroupforoutlook(integer,character varying,character varying) line 11 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_savegroupforoutlook(userno integer, outlookentryid character varying, groupname character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    groupno integer;
    groupcount integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	SELECT COUNT(GroupNo) INTO groupcount FROM ContactsGroupOutlook

	WHERE UserNo = contacts_savegroupforoutlook.userno
	AND OutlookFolderEntryID = contacts_savegroupforoutlook.outlookentryid;

	IF GroupCount = 0 THEN
		INSERT INTO ContactsGroup
		(
			RegDate,
			RegUserNo,
			ParentGNo,
			GroupName,
			IsDefault,
			Memo,
			Sort
		)
		VALUES
		(
			NOW(),
			UserNo,
			0,
			GroupName,
			1,
			'아웃룩',
			(SELECT COALESCE(MAX(Sort),0)+1 FROM ContactsGroup WHERE RegUserNo = contacts_savegroupforoutlook.userno)
		);

		GroupNo := lastval();
		INSERT INTO ContactsGroupOutlook
		(
			UserNo,
			GroupNo,
			OutlookFolderEntryID
		)
		VALUES
		(
			UserNo,
			GroupNo,
			OutlookEntryID
		);
	END IF;
END;
$function$

```
</details>

## `contacts_savesetup`

- Input: `0::integer, 0::integer, 0::bigint, false`
- Generated SQL: `SELECT "public"."contacts_savesetup"(0::integer, 0::integer, 0::bigint, false);`
- SQLSTATE: `42702`
- Error: column reference "userno" is ambiguous
- Stack context: PL/pgSQL function contacts_savesetup(integer,integer,bigint,boolean) line 9 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_savesetup(userno integer, pagesize integer, startcontactboxno bigint, isfolderexpanded boolean)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    cnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(UserNo) INTO cnt FROM ContactsSetup WHERE UserNo = contacts_savesetup.userno;

	IF CNT = 0 THEN
		INSERT INTO ContactsSetup
		(
			UserNo,
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			PageSize,
			StartContactBoxNo,
			IsFolderExpanded
		)
		VALUES
		(
			UserNo,
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			PageSize,
			StartContactBoxNo,
			IsFolderExpanded
		);
	ELSE

		UPDATE ContactsSetup
		SET
			ModUserNo = contacts_savesetup.userno,
			ModDate = NOW(),
			PageSize = contacts_savesetup.pagesize,
			StartContactBoxNo = contacts_savesetup.startcontactboxno,
			IsFolderExpanded = contacts_savesetup.isfolderexpanded
		WHERE UserNo = contacts_savesetup.userno;
	END IF;
END;
$function$

```
</details>

## `contacts_setcallphone`

- Input: `0::integer`
- Generated SQL: `SELECT "public"."contacts_setcallphone"(0::integer);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_setcallphone(integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcallphone(seq integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsNumber
	SET SetCall=1
	WHERE Seq=contacts_setcallphone.seq;
END;
$function$

```
</details>

## `contacts_setcontactsgroup`

- Input: `0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_setcontactsgroup"(0::integer, ''::character varying, 0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_setcontactsgroup(integer,character varying,integer,character varying,character varying) line 16 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactsgroup(groupno integer, groupname character varying, reguserno integer, memo character varying, mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    sort integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = '0' THEN

		SELECT COUNT(*) + 1 INTO sort FROM ContactsGroup WHERE RegUserNo=contacts_setcontactsgroup.reguserno AND ParentGNo=contacts_setcontactsgroup.groupno;

		INSERT INTO ContactsGroup(GroupName, RegUserNo, RegDate, Memo,ParentGNo,Sort, IsDefault)
		VALUES(GroupName, RegUserNo, NOW(), Memo, GroupNo, Sort , '0');
	ELSIF Mode = '1' THEN
		UPDATE ContactsGroup SET GroupName=contacts_setcontactsgroup.groupname WHERE GroupNo=contacts_setcontactsgroup.groupno;
	ELSE
		UPDATE ContactsGroup SET Memo=contacts_setcontactsgroup.memo WHERE GroupNo=contacts_setcontactsgroup.groupno;
	END IF;
END;
$function$

```
</details>

## `contacts_setcontactsrestore`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_setcontactsrestore"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42883`
- Error: operator does not exist: integer = character varying
- Stack context: PL/pgSQL function contacts_setcontactsrestore(integer,character varying,character varying) line 4 at SQL statement
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactsrestore(reguserno integer, userno character varying, groupno character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn='Y' WHERE Seq=contacts_setcontactsrestore.userno AND RegUserNo=contacts_setcontactsrestore.reguserno;
	UPDATE ContactsGroupUser SET GroupNo=contacts_setcontactsrestore.groupno WHERE UserSeq=contacts_setcontactsrestore.userno AND RegUserNo=contacts_setcontactsrestore.reguserno;
END;
$function$

```
</details>

## `contacts_setcontactstrash`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_setcontactstrash"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_setcontactstrash(integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactstrash(reguserno integer, seq integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn = '', DelDate = NOW() WHERE Seq= contacts_setcontactstrash.seq; --AND RegUserNo=RegUserNo
	--DELETE FROM ContactsGroupUser  WHERE UserSeq= Seq AND RegUserNo=RegUserNo
	--UPDATE Contact_PublicGroupUser SET IsDelete = TRUE, ModDate = NOW(),ModUserNo=RegUserNo WHERE UserSeq= Seq AND RegUserNo=RegUserNo
	--UPDATE Contact_ShareGroupUser SET IsDelete = TRUE, ModDate = NOW(),ModUserNo=RegUserNo WHERE UserSeq= Seq AND RegUserNo=RegUserNo
END;
$function$

```
</details>

## `contacts_setcontactsuser`

- Input: `''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer`
- Generated SQL: `SELECT "public"."contacts_setcontactsuser"(''::character varying, ''::character varying, ''::character varying, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, 0::integer);`
- SQLSTATE: `42804`
- Error: column "groupno" is of type integer but expression is of type character varying
- Stack context: PL/pgSQL function contacts_setcontactsuser(character varying,character varying,character varying,integer,character varying,character varying,character varying,character varying,integer) line 25 at SQL statement
- Root cause: Runtime PostgreSQL error requiring procedure-specific investigation
- Proposed fix: Investigate against source definition and rerun the recorded invocation after a scoped fix.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setcontactsuser(lastname character varying, firstname character varying, nicname character varying, reguserno integer, memo character varying, userpic character varying, groupno character varying, share character varying, seq integer)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    rtn integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Seq = 0 THEN
		INSERT INTO ContactsUser(LastName, FirstName, CallName, RegUserNo, Memo, Photo, RegDate, ModDate, CheckDate, Share, UseYn, Important)
		VALUES(LastName,FirstName,NicName,RegUserNo,Memo,UserPic, NOW(), NOW(), NOW(), Share, 'Y', 0);
		RTN := lastval();
	ELSE
		UPDATE ContactsUser SET FirstName=contacts_setcontactsuser.firstname, LastName=contacts_setcontactsuser.lastname,CallName=contacts_setcontactsuser.nicname,Memo=contacts_setcontactsuser.memo, RegDate = NOW(), Share=contacts_setcontactsuser.share WHERE Seq=contacts_setcontactsuser.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_setcontactsuser.reguserno AND UserSeq=contacts_setcontactsuser.seq;
		RTN := contacts_setcontactsuser.seq;
	END IF;

	CREATE TEMP TABLE tab (GroupNo INT, UserSeq INT,RegUserNo INT) ON COMMIT DROP;
	WHILE STRPOS(GroupNo, ',') > 0 LOOP
		INSERT INTO tab(GroupNo,UserSeq,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(GroupNo, ',')),RTN,RegUserNo);
		GroupNo := SUBSTRING(GroupNo,STRPOS(GroupNo, ',')+1,LEN(GroupNo));
	END LOOP;

	INSERT INTO tab VALUES (GroupNo,RTN,RegUserNo);
	INSERT INTO ContactsGroupUser
	(GroupNo,UserSeq,RegUserNo,RegDate,ModDate)
	SELECT GroupNo, UserSeq, RegUserNo, NOW(), NOW() FROM tab;

	RETURN QUERY
	SELECT RTN;
END;
$function$

```
</details>

## `contacts_setmovecontacts`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_setmovecontacts"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_setmovecontacts(integer,integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setmovecontacts(reguserno integer, groupno integer, movegroupno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsGroupUser
		SET GroupNo = contacts_setmovecontacts.movegroupno
		WHERE RegUserNo = contacts_setmovecontacts.reguserno AND GroupNo = contacts_setmovecontacts.groupno;
END;
$function$

```
</details>

## `contacts_setshare`

- Input: `0::integer, 0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT * FROM "public"."contacts_setshare"(0::integer, 0::integer, ''::character varying, ''::character varying) AS result("column_1" integer);`
- SQLSTATE: `42883`
- Error: operator does not exist: character varying = integer
- Stack context: PL/pgSQL function contacts_setshare(integer,integer,character varying,character varying) line 7 at IF
- Root cause: Missing function or incompatible invocation signature
- Proposed fix: Verify the expected helper/signature and create or convert it only if it exists in the source system.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setshare(seq integer, departno integer, ischild character varying, mode character varying)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN

		DepartName := public."COMNGetDepartName"(DepartNo);
		IF (select count(*) from ContactsSharers where Seq=contacts_setshare.seq and DepartNo= contacts_setshare.departno )=0 THEN
			INSERT INTO ContactsSharers(Seq,DepartNo,DepartName,IsChild)
			VALUES(Seq,DepartNo,DepartName,IsChild);
		END IF;

	ELSE
		DELETE FROM ContactsSharers WHERE Seq = contacts_setshare.seq;
	END IF;

	RETURN QUERY
	SELECT 0;
END;
$function$

```
</details>

## `contacts_setusercheckdate`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_setusercheckdate"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "reguserno" is ambiguous
- Stack context: PL/pgSQL function contacts_setusercheckdate(integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_setusercheckdate(reguserno integer, userseq integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	update ContactsUser set CheckDate= NOW() where RegUserNo = contacts_setusercheckdate.reguserno AND Seq = contacts_setusercheckdate.userseq;
END;
$function$

```
</details>

## `contacts_updateandroiddevice_notificationoptions`

- Input: `0::integer, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updateandroiddevice_notificationoptions"(0::integer, ''::character varying, ''::character varying);`
- SQLSTATE: `42P01`
- Error: relation "_androiddevices" does not exist
- Stack context: PL/pgSQL function contacts_updateandroiddevice_notificationoptions(integer,character varying,character varying) line 5 at SQL statement
- Root cause: Missing relation dependency
- Proposed fix: Create the source-owned schema dependency, or document it as external with evidence.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updateandroiddevice_notificationoptions(userno integer DEFAULT 70, deviceid character varying DEFAULT 'cQXYrFi-zgI:APA91bFO_-wi3QTdAe11ZOORe4FKXLHTqNDzxRMlEaciOT2ArI1Jht1-Z8jd2uaQ32i3mk5HdCPF4CN_pQTZJrPQ7_wbZsVvVEPaJ2_AfT9h9UMokm-UaJQ'::character varying, notificationoptions character varying DEFAULT '{\"enabled\": true,\"sound\": true,\"vibrate\": true,\"notitime\": false,\"starttime\": \"08:00\",\"endtime\": \"18:00\"}'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN


	UPDATE _AndroidDevices SET
		NotificationOptions = contacts_updateandroiddevice_notificationoptions.notificationoptions
	WHERE UserNo = contacts_updateandroiddevice_notificationoptions.userno AND DeviceID = contacts_updateandroiddevice_notificationoptions.deviceid;
END;
$function$

```
</details>

## `contacts_updatecontactgroupuser`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatecontactgroupuser"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_updatecontactgroupuser(integer,integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatecontactgroupuser(userno integer DEFAULT 70, groupno integer DEFAULT 8, userseq integer DEFAULT 7999)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE Contact_PublicGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatecontactgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatecontactgroupuser.userseq;
	UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatecontactgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatecontactgroupuser.userseq;
		IF EXISTS(SELECT Seq FROM ContactsGroupUser GU WHERE GU.GroupNo=contacts_updatecontactgroupuser.groupno AND  GU.UserSeq=contacts_updatecontactgroupuser.userseq  ) THEN
		UPDATE ContactsGroupUser SET GroupNo=contacts_updatecontactgroupuser.groupno,UserSeq=contacts_updatecontactgroupuser.userseq,ModDate=NOW()  WHERE GroupNo=contacts_updatecontactgroupuser.groupno AND  UserSeq=contacts_updatecontactgroupuser.userseq;
	ELSE
		INSERT INTO ContactsGroupUser(GroupNo,UserSeq,RegUserNo) VALUES(GroupNo,UserSeq,UserNo);
	SELECT Seq FROM ContactsGroupUser  WHERE GroupNo=contacts_updatecontactgroupuser.groupno AND  UserSeq=contacts_updatecontactgroupuser.userseq;
END IF;
END;
$function$

```
</details>

## `contacts_updatecontactimportant`

- Input: `0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatecontactimportant"(0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "seq" is ambiguous
- Stack context: PL/pgSQL function contacts_updatecontactimportant(integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatecontactimportant(seq integer, important integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE public."ContactsUser"
   SET Important =contacts_updatecontactimportant.important
 WHERE Seq=contacts_updatecontactimportant.seq;
END;
$function$

```
</details>

## `contacts_updatecontactsuser`

- Input: `0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updatecontactsuser"(0::integer, 0::integer, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_updatecontactsuser(integer,integer,character varying,character varying,character varying,character varying,character varying,character varying,character varying) line 5 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatecontactsuser(reguserno integer, userseq integer, memo character varying, share character varying, groupno character varying, company character varying, zipcode1 character varying, zipcode2 character varying, address character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_updatecontactsuser.userseq;

	UPDATE ContactsUser SET Memo = contacts_updatecontactsuser.memo, RegDate = NOW(), Share = contacts_updatecontactsuser.share
		WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND Seq = contacts_updatecontactsuser.userseq;

	CREATE TEMP TABLE tab (GroupNo INT,ContactsUser INT,RegUserNo INT) ON COMMIT DROP;
	WHILE STRPOS(GroupNo, ',') > 0 LOOP
		INSERT INTO tab(GroupNo,ContactsUser,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(GroupNo, ',')),UserSeq,RegUserNo);
		GroupNo := SUBSTRING(GroupNo,STRPOS(GroupNo, ',')+1,LEN(GroupNo));
	END LOOP;

	INSERT INTO tab VALUES (GroupNo,UserSeq,RegUserNo);
	INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate) SELECT *,NOW() FROM tab;

	UPDATE ContactsCompany SET Company = contacts_updatecontactsuser.company WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq;

	UPDATE ContactsAddress SET ZipCode1 = contacts_updatecontactsuser.zipcode1, ZipCode2 = contacts_updatecontactsuser.zipcode2, Address = contacts_updatecontactsuser.address WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq;
END;
$function$

```
</details>

## `contacts_updatedepartallowaccess`

- Input: `0::integer, 0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatedepartallowaccess"(0::integer, 0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "allowvalue" is ambiguous
- Stack context: PL/pgSQL function contacts_updatedepartallowaccess(integer,integer,integer,integer) line 38 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatedepartallowaccess(departno integer DEFAULT 4, allowvalue integer DEFAULT 2, itemno integer DEFAULT 16, userno integer DEFAULT 70)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    prentaccessno bigint;
    parentvalue integer;
    sharegroupno1 integer;
    no1 bigint;
BEGIN


	--UPDATE Contacts_DepartAllowAccess SET DepartNo=DepartNo,AllowValue=AllowValue , ItemNo=ItemNo,ItemType=ItemType,ModUserNo=UserNo,ModDate=NOW()
	--WHERE AllowAccessNo=AllowAccessNo
	--SELECT AllowAccessNo


		CREATE TEMP TABLE FolderParentTemp ON COMMIT DROP AS WITH RECURSIVE GroupTmp AS (
				SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       Contact_ShareGroup PF

				WHERE PF.ShareGroupNo =contacts_updatedepartallowaccess.itemno
				UNION ALL
				SELECT     CF.ShareGroupNo , CF.ParentNo
				FROM       Contact_ShareGroup CF
				INNER JOIN GroupTmp FN ON FN.ParentNo = CF.ShareGroupNo AND CF.IsDelete = FALSE

		),GroupParentNos AS(
			SELECT 0 AS ShareGroupNo,-1 AS ParentNo
			UNION ALL
			SELECT     PF.ShareGroupNo , PF.ParentNo
				FROM       GroupTmp PF
		)
		SELECT COALESCE(BA.AllowAccessNo,0)AS AllowAccessNo ,COALESCE(BA.AllowValue,0) AS AllowValue,F.ShareGroupNo FROM GroupParentNos F
		LEFT JOIN Contact_DepartAllowAccess BA ON BA.ItemNo=F.ShareGroupNo AND BA.DepartNo=contacts_updatedepartallowaccess.departno;



		WHILE (Select Count(*) From FolderParentTemp) > 0 LOOP

			SELECT AllowAccessNo, AllowValue, ShareGroupNo INTO prentaccessno, parentvalue, sharegroupno1 FROM FolderParentTemp;
				IF AllowValue >0 THEN
					IF PrentAccessNo=0 THEN
						INSERT INTO public."Contact_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ModUserNo,ModDate,RegUserNo,RegDate)
						SELECT DepartNo,AllowValue,FT.ShareGroupNo,UserNo,NOW(),UserNo,NOW() FROM FolderParentTemp FT;

					ELSE
						--IF(AllowValue>Value)

						IF AllowValue>ParentValue THEN

							UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,ModDate=NOW(),DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno WHERE AllowAccessNo=PrentAccessNo;
						END IF;
					END IF;

				END IF;
				DELETE FROM FolderParentTemp Where ShareGroupNo = ShareGroupNo1;
		END LOOP;
		CREATE TEMP TABLE GroupTemp ON COMMIT DROP AS WITH RECURSIVE ShareGroupNos AS (
			SELECT     PF.ShareGroupNo
			FROM       Contact_ShareGroup PF
			WHERE PF.ShareGroupNo=contacts_updatedepartallowaccess.itemno AND PF.IsDelete = FALSE
			UNION ALL
			SELECT     CF.ShareGroupNo
			FROM       Contact_ShareGroup CF
			INNER JOIN ShareGroupNos FN ON FN.ShareGroupNo = CF.ParentNo AND CF.IsDelete = FALSE
		)
		---List ShareGroupNo
		SELECT ShareGroupNo FROM ShareGroupNos;
		----List BoardNo

		WHILE (Select Count(*) From GroupTemp) > 0 LOOP
			SELECT ShareGroupNo INTO no1 FROM GroupTemp;
			IF AllowValue >=0 THEN
				IF (SELECT COUNT(AllowAccessNo) FROM Contact_DepartAllowAccess WHERE  ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno)>0 THEN
					--Print No1;
					UPDATE Contact_DepartAllowAccess SET AllowValue=contacts_updatedepartallowaccess.allowvalue,DepartNo=contacts_updatedepartallowaccess.departno,ModUserNo=contacts_updatedepartallowaccess.userno ,ModDate=NOW() WHERE ItemNo=No1 AND DepartNo=contacts_updatedepartallowaccess.departno;
				ELSE
					INSERT INTO public."Board_DepartAllowAccess"(DepartNo,AllowValue,ItemNo,ItemType,ModUserNo,ModDate,RegUserNo,RegDate)
					VALUES(DepartNo,AllowValue,No1,1,UserNo,NOW(),UserNo,NOW());
				END IF;

			END IF;

			DELETE FROM GroupTemp Where ShareGroupNo = No1;

		END LOOP;
END;
$function$

```
</details>

## `contacts_updategroup`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updategroup"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_updategroup(integer,integer,character varying) line 3 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updategroup(reguserno integer, groupno integer, groupname character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE ContactsGroup SET GroupName=contacts_updategroup.groupname
	WHERE GroupNo=contacts_updategroup.groupno AND RegUserNo = contacts_updategroup.reguserno;
END;
$function$

```
</details>

## `contacts_updategroupmemo`

- Input: `0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updategroupmemo"(0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_updategroupmemo(integer,integer,character varying) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updategroupmemo(groupno integer, userno integer, memo character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsGroup SET Memo = contacts_updategroupmemo.memo
	WHERE GroupNo = contacts_updategroupmemo.groupno
	AND RegUserNo = contacts_updategroupmemo.userno;
END;
$function$

```
</details>

## `contacts_updategroupstate`

- Input: `0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updategroupstate"(0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_updategroupstate(integer,character varying) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updategroupstate(groupno integer, state character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE ContactsGroup SET UseYn=contacts_updategroupstate.state
	WHERE GroupNo = contacts_updategroupstate.groupno;
END;
$function$

```
</details>

## `contacts_updatelistgroup`

- Input: `0::integer, 0::integer, 0::integer, ''::character varying`
- Generated SQL: `SELECT "public"."contacts_updatelistgroup"(0::integer, 0::integer, 0::integer, ''::character varying);`
- SQLSTATE: `42702`
- Error: column reference "listgroup_id" is ambiguous
- Stack context: PL/pgSQL function contacts_updatelistgroup(integer,integer,integer,character varying) line 8 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatelistgroup(type integer, contactid integer, listgroup_id integer, listgroup_content character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	IF Type=1 THEN
			DELETE FROM Contacts_ListGroupContact WHERE ListGroupContact_ContactId=contacts_updatelistgroup.contactid;
			DELETE FROM Contacts_ListGroup WHERE ListGroup_Id=contacts_updatelistgroup.listgroup_id;
	ELSE
			UPDATE Contacts_ListGroup
			SET ListGroup_Content=contacts_updatelistgroup.listgroup_content
			WHERE ListGroup_Id=contacts_updatelistgroup.listgroup_id;
		END IF;
END;
$function$

```
</details>

## `contacts_updatepublicgroupuser`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatepublicgroupuser"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_updatepublicgroupuser(integer,integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatepublicgroupuser(userno integer DEFAULT 70, groupno integer DEFAULT 8, userseq integer DEFAULT 7999)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatepublicgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatepublicgroupuser.userseq;
	DELETE FROM ContactsGroupUser  WHERE   UserSeq=contacts_updatepublicgroupuser.userseq;
	IF EXISTS(SELECT No FROM Contact_PublicGroupUser PG WHERE PG.PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  PG.UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE  ) THEN
		UPDATE Contact_PublicGroupUser SET PublicGroupNo=contacts_updatepublicgroupuser.groupno,UserSeq=contacts_updatepublicgroupuser.userseq,ModUserNo=contacts_updatepublicgroupuser.userno,ModDate=NOW() WHERE PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE;
	ELSE
		INSERT INTO Contact_PublicGroupUser(PublicGroupNo,UserSeq,RegUserNo,ModUserNo) VALUES(GroupNo,UserSeq,UserNo,UserNo);
	SELECT No FROM Contact_PublicGroupUser PG WHERE PG.PublicGroupNo=contacts_updatepublicgroupuser.groupno AND  PG.UserSeq=contacts_updatepublicgroupuser.userseq AND IsDelete= FALSE;
END IF;
END;
$function$

```
</details>

## `contacts_updatesharegroupuser`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatesharegroupuser"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "userseq" is ambiguous
- Stack context: PL/pgSQL function contacts_updatesharegroupuser(integer,integer,integer) line 4 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatesharegroupuser(userno integer DEFAULT 70, groupno integer DEFAULT 0, userseq integer DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

	UPDATE Contact_PublicGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatesharegroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatesharegroupuser.userseq;
	DELETE FROM ContactsGroupUser  WHERE   UserSeq=contacts_updatesharegroupuser.userseq;
	--UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=UserNo,ModDate=NOW() WHERE UserSeq=UserSeq
	IF EXISTS(SELECT No FROM Contact_ShareGroupUser PG WHERE PG.ShareGroupNo=contacts_updatesharegroupuser.groupno AND  PG.UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE ) THEN
		UPDATE Contact_ShareGroupUser SET ShareGroupNo=contacts_updatesharegroupuser.groupno,UserSeq=contacts_updatesharegroupuser.userseq,ModUserNo=contacts_updatesharegroupuser.userno,ModDate=NOW() WHERE ShareGroupNo=contacts_updatesharegroupuser.groupno AND  UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE;
	ELSE
		INSERT INTO Contact_ShareGroupUser(ShareGroupNo,UserSeq,RegUserNo,ModUserNo) VALUES(GroupNo,UserSeq,UserNo,UserNo);

	SELECT No FROM Contact_ShareGroupUser PG WHERE PG.ShareGroupNo=contacts_updatesharegroupuser.groupno AND  PG.UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE;
END IF;
END;
$function$

```
</details>

## `contacts_updatesortdownofgroup`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatesortdownofgroup"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_updatesortdownofgroup(integer,integer,integer) line 3 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatesortdownofgroup(reguserno integer DEFAULT 70, groupno integer DEFAULT 643, parentno integer DEFAULT 641)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
WITH RECURSIVE GroupTmp AS (select CG.*
from ContactsGroup CG
WHERE CG.RegUserNo=contacts_updatesortdownofgroup.reguserno AND CG.ParentGNo=contacts_updatesortdownofgroup.parentno AND CG.UseYn='Y' AND CG.Sort >= (SELECT Sort FROM ContactsGroup WHERE GroupNo=contacts_updatesortdownofgroup.groupno)
ORDER BY Sort ASC)
,
GroupUpdate AS(SELECT T.GroupNo,T1.Sort
FROM GroupTmp T
LEFT JOIN GroupTmp T1 ON T1.GroupNo <> T.GroupNo)
UPDATE ContactsGroup
SET Sort= CGU.Sort
FROM  GroupUpdate CGU WHERE  CGU.GroupNo=ContactsGroup.GroupNo;
END;
$function$

```
</details>

## `contacts_updatesortupofgroup`

- Input: `0::integer, 0::integer, 0::integer`
- Generated SQL: `SELECT "public"."contacts_updatesortupofgroup"(0::integer, 0::integer, 0::integer);`
- SQLSTATE: `42702`
- Error: column reference "groupno" is ambiguous
- Stack context: PL/pgSQL function contacts_updatesortupofgroup(integer,integer,integer) line 3 at SQL statement
- Root cause: Ambiguous column/parameter generated SQL
- Proposed fix: Qualify or rename the confirmed ambiguous parameter/variable in converter output, regenerate, and rerun.
- Validation after fix: NOT YET PASS

<details><summary>Deployed PostgreSQL definition</summary>

```sql
CREATE OR REPLACE FUNCTION public.contacts_updatesortupofgroup(reguserno integer, groupno integer, parentno integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
	WITH RECURSIVE GroupTmp AS (select CG.*
from ContactsGroup CG
WHERE CG.RegUserNo=contacts_updatesortupofgroup.reguserno AND CG.ParentGNo=contacts_updatesortupofgroup.parentno AND CG.UseYn='Y' AND CG.Sort <= (SELECT Sort FROM ContactsGroup WHERE GroupNo=contacts_updatesortupofgroup.groupno)
ORDER BY Sort DESC),
GroupUpdate AS(SELECT T.GroupNo,T1.Sort
FROM GroupTmp T
LEFT JOIN GroupTmp T1 ON T1.GroupNo <> T.GroupNo)
UPDATE ContactsGroup
SET Sort= CGU.Sort
FROM  GroupUpdate CGU WHERE  CGU.GroupNo=ContactsGroup.GroupNo;
END;
$function$

```
</details>

