-- ─── PROCEDURE→FUNCTION: schedule_getschedulescontacts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getschedulescontacts();
CREATE OR REPLACE FUNCTION public.schedule_getschedulescontacts(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'ContactsUser' AND  TABLE_NAME = 'ContactsGroup') THEN
		RETURN QUERY
		SELECT 
		C.ScheduleNo,
		C.UserSeq,
		COALESCE(U.LastName,'') + COALESCE(U.FirstName,'') AS UserName,
		C.GroupNo,
		COALESCE(G.GroupName,'') AS GroupName
		FROM ScheduleContentsContacts C
		LEFT JOIN ContactsUser U ON U.Seq  = C.UserSeq
		LEFT JOIN ContactsGroup G ON G.GroupNo = C.GroupNo
		WHERE C.ScheduleNo = ScheduleNo
	END IF;
	ELSE
		RETURN QUERY
		SELECT 
			C.ScheduleNo,
			C.UserSeq,
			'' AS UserName,
			C.GroupNo,
			'' AS GroupName
		FROM ScheduleContentsContacts C
		WHERE C.ScheduleNo = ScheduleNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
