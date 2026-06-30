-- ─── PROCEDURE→FUNCTION: contacts_countusersharewithoutgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_countusersharewithoutgroup(integer);
CREATE OR REPLACE FUNCTION public.contacts_countusersharewithoutgroup(
    IN reguserno integer DEFAULT 70
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(u.Seq) FROM ContactsUser U
	LEFT JOIN Contact_ShareGroupUser SU ON SU.UserSeq = U.Seq AND U.UseYn='Y' AND SU.IsDelete= FALSE
	WHERE U.UseYn='Y' AND 
	((U.RegUserNo=contacts_countusersharewithoutgroup.reguserno AND SUBSTRING(U.Share,1,3)='200' AND SU.UserSeq IS NULL)  OR 
	(SUBSTRING(U.Share,1,3)='200' AND SU.UserSeq IS NULL AND ( U.Seq IN (select C.Seq from ContactsSharers C INNER JOIN Organization_BelongToDepartment DP ON DP.DepartNo = C.DepartNo AND DP.UserNo=contacts_countusersharewithoutgroup.reguserno))) );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
