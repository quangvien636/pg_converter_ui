-- ─── FUNCTION: organization_insertbelongtodepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertbelongtodepartment(integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertbelongtodepartment(
    userno integer,
    departno integer,
    positionno integer,
    dutyno integer,
    isdefault boolean
) RETURNS TABLE(
    belongno text
)
AS $function$
DECLARE
    belongno bigint;
BEGIN


	INSERT INTO Organization_BelongToDepartment (UserNo, DepartNo, PositionNo, DutyNo, IsDefault)
	VALUES (UserNo, DepartNo, PositionNo, DutyNo, IsDefault)


	SET BelongNo = lastval()

	RETURN QUERY
	SELECT BelongNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
