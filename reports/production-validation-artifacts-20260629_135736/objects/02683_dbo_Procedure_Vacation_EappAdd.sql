-- ─── PROCEDURE→FUNCTION: vacation_eappadd ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.vacation_eappadd(character varying, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.vacation_eappadd(
    IN userid character varying,
    IN code integer,
    IN fromdt character varying,
    IN todt character varying,
    IN use double precision
) RETURNS void
AS $function$
BEGIN






		from Vacation_Requests
		where UserNo = uno 
		and  TypeId = vacation_eappadd.code 
		and Fromd = fromd
		and Tod = vacation_eappadd.todt
		and VacationsCount = vacation_eappadd.use);
		if(pcount <= 0)
		begin;
		insert into Vacation_Requests(UserNo,TypeId,Fromd,Tod,VacationsCount,Note,DateCreate,StatusUser,StatusAdmin) 
		values (uno,Code,fromd,Tod,Use,'',NOW(),'0',2);
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
