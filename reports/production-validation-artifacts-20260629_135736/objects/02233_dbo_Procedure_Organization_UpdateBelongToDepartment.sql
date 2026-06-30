-- ─── PROCEDURE→FUNCTION: organization_updatebelongtodepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updatebelongtodepartment(bigint, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_updatebelongtodepartment(
    IN belongno bigint,
    IN departno integer,
    IN positionno integer,
    IN dutyno integer,
    IN isdefault boolean
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
