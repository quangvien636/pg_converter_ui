-- ─── PROCEDURE→FUNCTION: contacts_getcontactsgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getcontactsgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getcontactsgroup(
    IN reguserno integer,
    IN pgroupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF PGroupNo = -1 THEN
		RETURN QUERY
		SELECT * FROM ContactsGroup WHERE RegUserNo=contacts_getcontactsgroup.reguserno ORDER BY ParentGNo,Sort
	END IF;
	ELSE
		RETURN QUERY
		SELECT * FROM ContactsGroup WHERE RegUserNo=contacts_getcontactsgroup.reguserno AND ParentGNo=contacts_getcontactsgroup.pgroupno ORDER BY Sort
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
