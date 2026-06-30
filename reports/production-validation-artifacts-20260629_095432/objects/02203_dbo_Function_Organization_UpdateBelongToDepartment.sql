-- ─── FUNCTION: organization_updatebelongtodepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updatebelongtodepartment(bigint, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_updatebelongtodepartment(
    belongno bigint,
    departno integer,
    positionno integer,
    dutyno integer,
    isdefault boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_BelongToDepartment SET
		DepartNo = organization_updatebelongtodepartment.departno,
		PositionNo = organization_updatebelongtodepartment.positionno,
		DutyNo = organization_updatebelongtodepartment.dutyno,
		IsDefault = organization_updatebelongtodepartment.isdefault
	WHERE BelongNo = organization_updatebelongtodepartment.belongno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
