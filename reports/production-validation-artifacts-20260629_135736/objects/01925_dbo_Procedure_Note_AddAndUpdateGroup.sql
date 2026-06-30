-- ─── PROCEDURE→FUNCTION: note_addandupdategroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.note_addandupdategroup(uuid, character varying, integer, integer, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_addandupdategroup(
    IN groupno uuid,
    IN name character varying,
    IN orderpostion integer,
    IN userno integer,
    IN icon character varying,
    IN type integer,
    IN daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN

    IF Type=1 THEN;
			INSERT INTO Note_Group(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayEdit)
			VALUES(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayCreate)
		END IF;
	IF Type=2 THEN;
			UPDATE Note_Group
			Name := note_addandupdategroup.name,OrderPostion=note_addandupdategroup.orderpostion,DayEdit=note_addandupdategroup.daycreate,Icon=note_addandupdategroup.icon;
			WHERE GroupNo=note_addandupdategroup.groupno AND UserNo=note_addandupdategroup.userno
		END IF;
	IF Type=3 THEN
			--UPDATE Note_Group
			--SET Show=2
			--WHERE GroupNo=GroupNo AND UserNo=UserNo;
			DELETE FROM Note_Group
			WHERE GroupNo=note_addandupdategroup.groupno AND UserNo=note_addandupdategroup.userno AND CheckDelete !=1
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
