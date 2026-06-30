-- ─── PROCEDURE→FUNCTION: contacts_checkgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_checkgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_checkgroup(
    IN reguserno integer,
    IN type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 그룹번호로 체크
	IF Type = 0 THEN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup 
		WHERE RegUserNo=contacts_checkgroup.reguserno 
		AND GroupNo=Value
		AND UseYn='Y'
	END IF;
	-- 그룹이름으로 체크
	ELSIF Type = 1 THEN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup 
		WHERE RegUserNo=contacts_checkgroup.reguserno 
		AND GroupName=Value
		AND UseYn='Y'
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
