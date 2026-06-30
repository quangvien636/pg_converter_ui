-- ─── FUNCTION: notice_setshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_setshare(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.notice_setshare(
    noticeno integer,
    departno integer,
    userno integer,
    ischild character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    departname character varying;
BEGIN

	IF Mode = 0
	BEGIN

		SET DepartName = public."COMNGetDepartName"(DepartNo)
		if((select count(*) from NoticeSharers b where b.NoticeNo = notice_setshare.noticeno and b.DepartNo=notice_setshare.departno and b.Userno=notice_setshare.userno)=0) begin;
			INSERT INTO NoticeSharers(NoticeNo,DepartNo,DepartName,IsChild,UserNo)
			VALUES(NoticeNo,DepartNo,DepartName,IsChild, UserNo)
			end
	END
	ELSE
	BEGIN;
		DELETE FROM NoticeSharers WHERE NoticeNo = notice_setshare.noticeno
	END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
