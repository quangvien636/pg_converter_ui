-- ─── FUNCTION: organization_insertpersonalgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertpersonalgroup(integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_insertpersonalgroup(
    userno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    groupno text
)
AS $function$
DECLARE
    groupno bigint;
BEGIN


	UPDATE Organization_PersonalGroups SET SortNo = SortNo + 1
	WHERE UserNo = organization_insertpersonalgroup.userno

	INSERT INTO Organization_PersonalGroups (UserNo, ModDate, Name, SortNo, ListOfUsers)
	VALUES (UserNo, ModDate, Name, 1, '')


	SET GroupNo = lastval()

	RETURN QUERY
	SELECT GroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
