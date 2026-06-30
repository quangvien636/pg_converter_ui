-- ─── PROCEDURE→FUNCTION: note_addgroupdefault ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_addgroupdefault(uuid, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.note_addgroupdefault(
    IN groupno uuid,
    IN name character varying,
    IN orderpostion integer,
    IN userno integer
) RETURNS void
AS $function$
DECLARE
    temp integer;
BEGIN


	Temp := (SELECT COUNT(*) FROM Note_Group WHERE UserNo=note_addgroupdefault.userno AND CheckDelete=1);
	IF Temp=0 THEN;
		INSERT INTO Note_Group(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayEdit,CheckDelete)
			VALUES(GroupNo,Name,OrderPostion,UserNo,Icon,NOW(),NOW(),1)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
