-- ─── PROCEDURE→FUNCTION: board_updatepermissionsbyparent ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updatepermissionsbyparent(integer, integer);
CREATE OR REPLACE FUNCTION public.board_updatepermissionsbyparent(
    IN departno integer DEFAULT 6403,
    IN userno integer DEFAULT 70
) RETURNS void
AS $function$
BEGIN

INSERT INTO Board_DepartAllowAccess (DepartNo, AllowValue,ItemNo,ItemType,ModDate,ModUserNo,RegDate,RegUserNo);
SELECT DepartNo AS DepartNo,BD.AllowValue,BD.ItemNo,BD.ItemType,NOW() AS ModDate,UserNo AS ModUserNo,NOW() AS ModDate,UserNo AS RegUserNo
FROM Board_DepartAllowAccess BD
INNER JOIN Organization_Departments OD ON OD.ParentNo=BD.DepartNo
WHERE OD.DepartNo=board_updatepermissionsbyparent.departno AND OD.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.