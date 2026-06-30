-- ─── PROCEDURE→FUNCTION: update_addfields ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.update_addfields(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.update_addfields(
    IN userno integer,
    IN userid character varying,
    IN value character varying
) RETURNS SETOF record
AS $function$
DECLARE
    puserid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		SELECT  INTO  FROM Organization_Users_Addfields WHERE UserNo = update_addfields.userno

	IF pUserId is null THEN;
		INSERT INTO Organization_Users_Addfields VALUES(UserNo,UserId,Key,Value)
	END IF;
	ELSE;
		UPDATe Organization_Users_Addfields
		Value := update_addfields.value;
		WHERE UserNo = update_addfields.userno
		and key = Key
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
