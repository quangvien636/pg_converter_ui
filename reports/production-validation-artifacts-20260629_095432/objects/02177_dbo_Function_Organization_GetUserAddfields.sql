-- ─── FUNCTION: organization_getuseraddfields ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getuseraddfields(character varying);
CREATE OR REPLACE FUNCTION public.organization_getuseraddfields(
    usernos character varying
) RETURNS TABLE(
    userno integer,
    userid character varying(100),
    key character varying(100),
    value character varying(200)
)
AS $function$
BEGIN


		RETURN QUERY
		select UserNo,Value from Organization_Users_Addfields 
		where UserNo in (select * from string_to_array(UserNos, ',')::integer[])
		and Key = Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
