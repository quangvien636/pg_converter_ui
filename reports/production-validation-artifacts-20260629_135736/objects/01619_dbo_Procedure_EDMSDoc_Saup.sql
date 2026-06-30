-- ─── PROCEDURE→FUNCTION: edmsdoc_saup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmsdoc_saup(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsdoc_saup(
    IN docid integer,
    IN saupname character varying
) RETURNS void
AS $function$
DECLARE
    chksaup character varying;
BEGIN


	
	IF chkSaup = 1 THEN;
		update EDMS_Saupjang set SaupName = edmsdoc_saup.saupname,
		SaupCode = saupCode where DocID = edmsdoc_saup.docid
	END IF;
	ELSE
		IF SaupName is not null and SaupCode is not null THEN;
			insert into EDMS_Saupjang(DocID,SaupName,SaupCode) 
			values(DocID,SaupName,saupCode)
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
