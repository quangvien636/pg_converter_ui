-- ─── FUNCTION: contacts_setshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setshare(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setshare(
    seq integer,
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

		SET DepartName = public."COMNGetDepartName"(DepartNo)

		if((select count(*) from ContactsSharers where Seq=contacts_setshare.seq and DepartNo= contacts_setshare.departno )=0) begin;
			INSERT INTO ContactsSharers(Seq,DepartNo,DepartName,IsChild)
			VALUES(Seq,DepartNo,DepartName,IsChild)
		end
		
	END
	ELSE
	BEGIN;
		DELETE FROM ContactsSharers WHERE Seq = contacts_setshare.seq
	END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
