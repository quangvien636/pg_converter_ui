-- ─── FUNCTION: note_addandupdategroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_addandupdategroup(uuid, character varying, integer, integer, character varying, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.note_addandupdategroup(
    groupno uuid,
    name character varying,
    orderpostion integer,
    userno integer,
    icon character varying,
    type integer,
    daycreate timestamp without time zone DEFAULT 'GETUTCDATE'
) RETURNS void
AS $function$
BEGIN

    IF Type=1
		BEGIN;
			INSERT INTO Note_Group(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayEdit)
			VALUES(GroupNo,Name,OrderPostion,UserNo,Icon,DayCreate,DayCreate)
		END
	IF Type=2
		BEGIN;
			UPDATE Note_Group
			SET Name=note_addandupdategroup.name,OrderPostion=note_addandupdategroup.orderpostion,DayEdit=note_addandupdategroup.daycreate,Icon=note_addandupdategroup.icon
			WHERE GroupNo=note_addandupdategroup.groupno AND UserNo=note_addandupdategroup.userno
		END
	IF Type=3
		BEGIN
			--UPDATE Note_Group
			--SET Show=2
			--WHERE GroupNo=GroupNo AND UserNo=UserNo;
			DELETE FROM Note_Group
			WHERE GroupNo=note_addandupdategroup.groupno AND UserNo=note_addandupdategroup.userno AND CheckDelete !=1
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
