-- ─── PROCEDURE→FUNCTION: center_updateuserfailedlogin ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updateuserfailedlogin(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.center_updateuserfailedlogin(
    IN userno integer,
    IN userid character varying,
    IN failedlogincount integer
) RETURNS void
AS $function$
BEGIN


	IF UserNo <> 0 THEN
		
		update Organization_Users set FailedLoginCount = center_updateuserfailedlogin.failedlogincount  WHERE UserNo = center_updateuserfailedlogin.userno
		
	END IF;
	
	ELSIF UserID <> '' THEN
		
		update Organization_Users set FailedLoginCount = center_updateuserfailedlogin.failedlogincount  WHERE UserID = center_updateuserfailedlogin.userid
		
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
