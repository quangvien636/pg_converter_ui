-- ─── FUNCTION: contacts_getuser_days ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_days(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_days(
    userseq integer
) RETURNS TABLE(
    seq text,
    reguserno text,
    userseq text,
    type text,
    typename text,
    value text,
    isdefault text,
    solarlunar text,
    regdate text,
    moddate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
	Seq, 
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	SolarLunar,
	RegDate,
	ModDate
	FROM ContactsDays WHERE UserSeq = contacts_getuser_days.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
