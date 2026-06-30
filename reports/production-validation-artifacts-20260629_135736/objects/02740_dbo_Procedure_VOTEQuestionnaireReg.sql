-- ─── PROCEDURE→FUNCTION: votequestionnairereg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.votequestionnairereg(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.votequestionnairereg(
    IN masterid integer,
    IN no integer,
    IN type character varying,
    IN name character varying
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
