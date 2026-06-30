-- ─── FUNCTION: edms_getaultauthoritylevelbystring ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getaultauthoritylevelbystring(character varying, character varying);
CREATE OR REPLACE FUNCTION public.edms_getaultauthoritylevelbystring(
    string character varying,
    deliminator character varying
) RETURNS TABLE(
    authorlevel integer
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
#variable_conflict use_column
DECLARE
    temptable table(
	id int identity,
	 aultauthoritylevel nvarchar(500);
    taultauthoritylevel character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	)

	

	insert into TempTable
	RETURN QUERY
	select * from SplitString(String,Deliminator)




		SET RowIndex = 1
	SET MaxIndex=(select count(*) from TempTable)

	if(MaxIndex>0) BEGIN
		WHILE(RowIndex<=MaxIndex) BEGIN
			select TAultAuthorityLevel = AultAuthorityLevel from TempTable where Id=RowIndex


			insert into ReturnTable
			RETURN QUERY
			select /* TOP 1 */ * from SplitString(TAultAuthorityLevel,ChildDeli)

			SET RowIndex = RowIndex + 1
		END
	END
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
