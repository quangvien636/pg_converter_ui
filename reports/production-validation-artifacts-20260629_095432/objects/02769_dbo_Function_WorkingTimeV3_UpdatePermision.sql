-- ─── FUNCTION: workingtimev3_updatepermision ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_updatepermision(integer, boolean);
CREATE OR REPLACE FUNCTION public.workingtimev3_updatepermision(
    p_uno integer,
    p_isuserfull boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    _allowdeviceno integer;
BEGIN



	SELECT _AllowDeviceNo = COUNT(1) FROM WorkingTimeV3_Permisions WHERE UserNo = workingtimev3_updatepermision.p_uno

	IF (_AllowDeviceNo > 0) BEGIN;
		UPDATE WorkingTimeV3_Permisions set
				ModDate = NOW(),
				IsUserFull = workingtimev3_updatepermision.p_isuserfull
			WHERE UserNo = workingtimev3_updatepermision.p_uno
	END
	ELSE BEGIN;
		INSERT INTO WorkingTimeV3_Permisions(UserNo,ModDate,RegDate,IsUserFull) VALUES (p_uNo,NOW(),NOW(),p_IsUserFull)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
