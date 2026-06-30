-- ─── FUNCTION: votequestionnairereg ───────────────────────────────
DROP FUNCTION IF EXISTS public.votequestionnairereg(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.votequestionnairereg(
    masterid integer,
    no integer,
    type character varying,
    name character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO VOTEQuestionnaire
		(MasterID
		,No
		,Type
		,Name)
	VALUES
		(MasterID
		,No
		,Type
		,Name);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
