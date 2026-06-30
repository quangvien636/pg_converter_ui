-- ─── FUNCTION: bslg_spauthreg ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_spauthreg(character varying, character varying, integer, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.bslg_spauthreg(
    userid character varying,
    shareduserid character varying,
    shareddepartno integer,
    userofdepart character varying,
    reguserno integer,
    regdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN
	INSERT INTO BSLG_SpAuthInfo(UserId,SharedUserId,SharedDepartNo,UserofDepart,RegUserNo,RegDate)
	values(UserId,SharedUserId,SharedDepartNo,UserofDepart,RegUserNo,RegDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
