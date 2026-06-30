-- ─── FUNCTION: bslggetorglog_depth ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslggetorglog_depth(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslggetorglog_depth(
    departid character varying,
    date character varying,
    isdepth character varying
) RETURNS TABLE(
    departid text,
    regdate text,
    slog text,
    elog text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text,
    col10 text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	

	
	if IsDepth = '' or SUBSTRING(DepartID,1,1) = 'G'
	 begin 
	RETURN QUERY
	SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5, 
	 (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
	FROM BSLGOrgLog WHERE RegDate=bslggetorglog_depth.date AND DepartID=bslggetorglog_depth.departid
	
	 end 
	else  
	begin
	/*
 RETURN QUERY
 SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5 ,
    (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
   FROM BSLGOrgLog WHERE RegDate=bslggetorglog_depth.date AND DepartID in (
  select OrgCd  from public."COMNGetOrganChild2"(DepartID)
  ) */
  
 RETURN QUERY
 SELECT DepartID, RegDate, SLog, ELog, att1, att2, att3, att4, att5 ,
    (select orgnm1 from CMONOrgan where OrgCd = bslggetorglog_depth.departid) as departname
   FROM BSLGOrgLog a, public."COMNGetOrganChild2"(DepartID) b WHERE RegDate=bslggetorglog_depth.date
   and a.Departid = b.orgcd  order by b.level;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
