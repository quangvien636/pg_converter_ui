-- ─── FUNCTION: schedule_getschedulescontacts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getschedulescontacts();
CREATE OR REPLACE FUNCTION public.schedule_getschedulescontacts(
) RETURNS TABLE(
    scheduleno text,
    userseq text,
    username text,
    groupno text,
    groupname text
)
AS $function$
BEGIN

	IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'ContactsUser' AND  TABLE_NAME = 'ContactsGroup'))
	BEGIN
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
	END
	else
	begin
		RETURN QUERY
		SELECT 
			C.ScheduleNo,
			C.UserSeq,
			'' AS UserName,
			C.GroupNo,
			'' AS GroupName
		FROM ScheduleContentsContacts C
		WHERE C.ScheduleNo = ScheduleNo
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
