-- ─── PROCEDURE→FUNCTION: contacts_setshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_setshare(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_setshare(
    IN seq integer,
    IN departno integer,
    IN ischild character varying,
    IN mode character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN

		DepartName := public."COMNGetDepartName"(DepartNo);
		IF (select count(*) from ContactsSharers where Seq=contacts_setshare.seq and DepartNo= contacts_setshare.departno )=0 THEN
			INSERT INTO ContactsSharers(Seq,DepartNo,DepartName,IsChild);
			END IF;
			VALUES(Seq,DepartNo,DepartName,IsChild);
		END IF;

	ELSE
		DELETE FROM ContactsSharers WHERE Seq = contacts_setshare.seq;


	RETURN QUERY
	SELECT 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.