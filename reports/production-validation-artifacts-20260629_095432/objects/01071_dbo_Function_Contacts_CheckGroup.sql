-- ─── FUNCTION: contacts_checkgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_checkgroup(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_checkgroup(
    reguserno integer,
    type integer
) RETURNS TABLE(
    groupno text
)
AS $function$
BEGIN

	-- 그룹번호로 체크
	IF Type = 0
	BEGIN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup 
		WHERE RegUserNo=contacts_checkgroup.reguserno 
		AND GroupNo=Value
		AND UseYn='Y'
	END
	-- 그룹이름으로 체크
	ELSE IF Type = 1
	BEGIN
		RETURN QUERY
		SELECT GroupNo FROM ContactsGroup 
		WHERE RegUserNo=contacts_checkgroup.reguserno 
		AND GroupName=Value
		AND UseYn='Y'
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
