-- ─── PROCEDURE→FUNCTION: contacts_getsharegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getsharegroup(integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharegroup(
    IN userno integer DEFAULT 222,
    IN isadmin boolean DEFAULT FALSE,
    IN langcode character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF IsAdmin = TRUE THEN
	RETURN QUERY
	SELECT * FROM (
	SELECT SG.ShareGroupNo AS Id,
	ShareGroupName AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME=contacts_getsharegroup.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME='KO')) ELSE SG.ShareGroupName END,'') AS Name ,
	ParentNo ,
	COALESCE(SU.ShareNumber,0) AS ShareNumber,
	SG.Sort
	FROM  Contact_ShareGroup SG
	LEFT JOIN  ( SELECT ShareGroupNo, Count(ShareGroupNo) AS ShareNumber
				FROM Contact_ShareGroupUser S
				INNER JOIN ContactsUser U ON U.Seq=S.UserSeq AND U.UseYn='Y'
				WHERE S.IsDelete= FALSE
				GROUP BY S.ShareGroupNo) SU ON SU.ShareGroupNo = SG.ShareGroupNo
	WHERE SG.IsDelete= FALSE
	UNION ALL
	SELECT 0 AS Id,'' as JsonName,'' AS Name,-1 AS ParentNo,(SELECT Count(*)
				FROM ContactsUser U
				LEFT OUTER JOIN  Contact_ShareGroupUser S   ON U.Seq=S.UserSeq AND S.IsDelete= FALSE
				WHERE  U.UseYn='Y'  AND SUBSTRING(U.Share,1,3)='200') AS ShareNumber,
				0 AS Sort

	) T
	ORDER BY  T.ParentNo, T.Sort
ELSE
BEGIN
	RETURN QUERY
	WITH RECURSIVE DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo
		FROM Contact_DepartAllowAccess BD
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE  OB.UserNo=contacts_getsharegroup.userno AND OB.IsDefault= TRUE
	),SHARE AS (
		SELECT S.Seq FROM ContactsSharers S
		INNER JOIN Organization_BelongToDepartment D ON D.DepartNo=S.DepartNo
		WHERE  D.UserNo=contacts_getsharegroup.userno
	)
	SELECT COALESCE(SG.ShareGroupNo,0) AS Id,
	COALESCE(ShareGroupName,'') AS JsonName,
	COALESCE(CASE WHEN STRPOS(SG.ShareGroupName, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME=contacts_getsharegroup.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(SG.ShareGroupName)  WHERE NAME='KO')) ELSE SG.ShareGroupName END,'') AS Name ,
	COALESCE(ParentNo,-1) AS ParentNo,
	COALESCE(SU.ShareNumber,0) AS ShareNumber
	FROM DEPARTPERMISSION D
	LEFT JOIN Contact_ShareGroup SG   ON D.ItemNo=SG.ShareGroupNo AND SG.IsDelete= FALSE
	LEFT JOIN  ( SELECT ShareGroupNo, Count(ShareGroupNo) AS ShareNumber
				FROM Contact_ShareGroupUser SG
				INNER JOIN ContactsUser U ON U.Seq=SG.UserSeq AND U.UseYn='Y'
				INNER JOIN SHARE CS ON CS.Seq=U.Seq
				WHERE SG.IsDelete= FALSE
				GROUP BY SG.ShareGroupNo
				--UNION
				--SELECT 0 AS ShareGroupNo,
				--(SELECT COUNT (*)FROM ContactsUser U
				--LEFT OUTER JOIN Contact_ShareGroupUser S  ON U.Seq=S.UserSeq AND  S.IsDelete= FALSE
				--INNER JOIN SHARE CS ON CS.Seq=U.Seq
				--WHERE SUBSTRING(U.Share,1,3)='200'  AND U.UseYn='Y') AS ShareNumber
				) SU ON SU.ShareGroupNo =D.ItemNo
	WHERE   D.AllowValue>0
	ORDER BY  SG.ParentNo, SG.Sort
END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.