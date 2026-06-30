-- ─── FUNCTION: fn_getusername ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_getusername(integer);
CREATE OR REPLACE FUNCTION public.fn_getusername(
    u_no integer
) RETURNS character varying
AS $function$
BEGIN


	select name =
	CASE 
		WHEN Lang ='VN' THEN a.Name_VN
		WHEN  Lang ='JP' THEN a.Name_JP
		WHEN  Lang ='CH' THEN a.Name_CH
		WHEN  Lang ='EN' THEN a.Name_EN
		ELSE a.Name 
	END
	from Organization_Users a
	where UserNo  = fn_getusername.u_no
	return name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
