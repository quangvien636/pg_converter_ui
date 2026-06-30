-- ─── PROCEDURE→FUNCTION: bslg_spauthreg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_spauthreg(character varying, character varying, integer, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.bslg_spauthreg(
    IN userid character varying,
    IN shareduserid character varying,
    IN shareddepartno integer,
    IN userofdepart character varying,
    IN reguserno integer,
    IN regdate timestamp without time zone
) RETURNS void
AS $function$
BEGIN
	INSERT INTO BSLG_SpAuthInfo(UserId,SharedUserId,SharedDepartNo,UserofDepart,RegUserNo,RegDate)
	values(UserId,SharedUserId,SharedDepartNo,UserofDepart,RegUserNo,RegDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
