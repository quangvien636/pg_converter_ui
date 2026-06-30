-- ─── FUNCTION: noticesyn_setshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_setshare(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setshare(
    noticeno integer,
    departno integer,
    ischild character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    departname character varying;
BEGIN



	IF Mode = 0
	BEGIN

		SET DepartName = public."COMNGetDepartName"(DepartNo);
		INSERT INTO NoticeSyn_Sharers(NoticeNo,DepartNo,DepartName,IsChild)
		VALUES(NoticeNo,DepartNo,DepartName,IsChild)
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeSyn_Sharers WHERE NoticeNo = noticesyn_setshare.noticeno
	END
	
	RETURN QUERY
	SELECT @ERROR
	END;
-------------------------////////////////////////----------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
