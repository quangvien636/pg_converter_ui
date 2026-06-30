-- ─── FUNCTION: note_getreceiveusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getreceiveusers();
CREATE OR REPLACE FUNCTION public.note_getreceiveusers(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		STUFF
		(
	  (SELECT ',' || CASE WHEN UserNo <> 0 THEN public."COMNGetUserName"(UserNo)
			ELSE public."COMNGetDepartName"(DepartNo)
		END
	  FROM NoteReceiveUser
	  WHERE NoteNo = NoteNo
	  FOR XML PATH('')
	  ),1,1,'') as ReceiveUsers;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
