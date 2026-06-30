-- ─── FUNCTION: noticesyn_setshareupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_setshareupdate(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setshareupdate(
    noticeno integer,
    departno integer,
    ischild character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    count integer;
    departname character varying;
    tdepartno integer;
    tparentno integer;
    ischeck integer;
BEGIN







IF Mode = 0 BEGIN
	SET count = 1
	SET TDepartNo= noticesyn_setshareupdate.departno
	while count>0 BEGIN
		select TDepartNo=noticesyn_setshareupdate.departno,TParentNo=ParentNo,DepartName=Name from Organization_Departments where DepartNo=TDepartNo

		select isCheck= count(*) from NoticeSyn_Sharers where NoticeNo=noticesyn_setshareupdate.noticeno and DepartNo=TDepartNo
		if(isCheck = FALSE) BEGIN;
			INSERT INTO NoticeSyn_Sharers(NoticeNo,DepartNo,DepartName,IsChild)
			VALUES(NoticeNo,TDepartNo,DepartName,IsChild)
			SET TDepartNo=TParentNo
			select count = count(*) from Organization_Departments where DepartNo=TParentNo
		END
		ELSE BEGIN
			SET count =0
		END
	END
END
ELSE BEGIN;
		DELETE FROM NoticeSyn_Sharers WHERE NoticeNo = noticesyn_setshareupdate.noticeno
END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
