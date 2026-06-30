-- ─── FUNCTION: note_addgroupdefault ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addgroupdefault(uuid, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.note_addgroupdefault(
    groupno uuid,
    name character varying,
    orderpostion integer,
    userno integer
) RETURNS void
AS $function$
DECLARE
    temp integer;
BEGIN


	SET Temp=(SELECT COUNT(*) FROM Note_Group WHERE UserNo=note_addgroupdefault.userno AND CheckDelete=1);
	
	IF Temp=0
	BEGIN;
		INSERT INTO Note_Group(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayEdit,CheckDelete)
			VALUES(GroupNo,Name,OrderPostion,UserNo,Icon,NOW(),NOW(),1)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
