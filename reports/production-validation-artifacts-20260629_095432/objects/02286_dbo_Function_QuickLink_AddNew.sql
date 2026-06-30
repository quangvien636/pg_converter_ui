-- ─── FUNCTION: quicklink_addnew ───────────────────────────────
DROP FUNCTION IF EXISTS public.quicklink_addnew(character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.quicklink_addnew(
    title character varying,
    url character varying,
    userno integer
) RETURNS TABLE(
    seq bigserial,
    title text,
    url character varying(1000),
    userno integer,
    orderid integer,
    regdate timestamp without time zone,
    isactive boolean
)
AS $function$
BEGIN


	

	SELECT OrderId = COALESCE(MAX(OrderId), 0)+1 from QuickLink WHERE UserNo=quicklink_addnew.userno and IsActive = TRUE


	INSERT INTO public."QuickLink"
           (Title
           ,Url
           ,UserNo
		   ,OrderId
           ,RegDate
		   ,IsActive)
     VALUES
           (Title ,Url ,UserNo ,OrderId ,NOW() ,1)

	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE UserNo=quicklink_addnew.userno and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
