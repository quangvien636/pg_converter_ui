-- ─── PROCEDURE→FUNCTION: workingtimev3_updatepermision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_updatepermision(integer, boolean);
CREATE OR REPLACE FUNCTION public.workingtimev3_updatepermision(
    IN p_uno integer,
    IN p_isuserfull boolean
) RETURNS SETOF record
AS $function$
DECLARE
    _allowdeviceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT COUNT(1) INTO _allowdeviceno FROM WorkingTimeV3_Permisions WHERE UserNo = workingtimev3_updatepermision.p_uno

	IF _AllowDeviceNo > 0 THEN;
		UPDATE WorkingTimeV3_Permisions set
				ModDate = NOW(),
				IsUserFull = workingtimev3_updatepermision.p_isuserfull
			WHERE UserNo = workingtimev3_updatepermision.p_uno
	END IF;
	ELSE BEGIN;
		INSERT INTO WorkingTimeV3_Permisions(UserNo,ModDate,RegDate,IsUserFull) VALUES (p_uNo,NOW(),NOW(),p_IsUserFull)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
