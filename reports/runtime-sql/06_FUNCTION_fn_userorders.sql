-- ─── FUNCTION: fn_userorders ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_userorders(integer);
CREATE OR REPLACE FUNCTION public.fn_userorders(
    userid integer
) RETURNS TABLE(
    orderid integer,
    amount numeric
)
AS $function$
#variable_conflict use_column
BEGIN

    RETURN QUERY SELECT OrderId, Amount FROM public."Orders" WHERE UserId = fn_userorders.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role qa_owner not verified.
