-- ─── FUNCTION: personal_deletegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_deletegroup();
CREATE OR REPLACE FUNCTION public.personal_deletegroup(
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	SET GroupNoList = GroupNoList || ','
	

	WHILE STRPOS(',GroupNoList, ') > 0
	BEGIN
		SET GroupNo = SUBSTRING(GroupNoList,0,STRPOS(',GroupNoList, '))
		
		DELETE FROM PersonalGroupUser WHERE GroupNo = GroupNo;
		DELETE FROM PersonalGroup WHERE GroupNo = GroupNo
		
		SET GroupNoList = SUBSTRING(GroupNoList,STRPOS(',GroupNoList, ')+1,LEN(GroupNoList))
	END
END

/****** Object:  StoredProcedure public."Personal_CheckPassword"    Script Date: 11/13/2014 20:06:56 ******/
SET ANSI_NULLS ON;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
