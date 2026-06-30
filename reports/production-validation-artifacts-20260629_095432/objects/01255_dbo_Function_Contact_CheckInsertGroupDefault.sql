-- ─── FUNCTION: contact_checkinsertgroupdefault ───────────────────────────────
DROP FUNCTION IF EXISTS public.contact_checkinsertgroupdefault(integer, character varying);
CREATE OR REPLACE FUNCTION public.contact_checkinsertgroupdefault(
    userno integer,
    isdefault character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    groupno integer;
BEGIN



	if((select count(*)	from ContactsGroup	where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault)=0) begin;
		INSERT INTO ContactsGroup (GroupName, ParentGNo, RegUserNo, Sort,RegDate,IsDefault,UseYn)
		VALUES (GroupName, 0, UserNo, 0 ,NOW(),'1','Y')
		SET GroupNo = lastval()
		RETURN QUERY
		SELECT GroupNo AS GroupNo
	end 
	else begin;
		update ContactsGroup set GroupName=GroupName where RegUserNo=contact_checkinsertgroupdefault.userno and IsDefault=contact_checkinsertgroupdefault.isdefault

	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
