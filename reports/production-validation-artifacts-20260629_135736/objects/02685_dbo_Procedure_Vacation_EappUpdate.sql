-- ─── PROCEDURE→FUNCTION: vacation_eappupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_eappupdate(character varying, character varying, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.vacation_eappupdate(
    IN mode character varying,
    IN userid character varying,
    IN code integer,
    IN fromdt character varying,
    IN todt character varying,
    IN use double precision
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Mode = '신청' THEN

	    ---DELETE FROM Vacation_Requests where UserNo = uno;




		from Vacation_Requests
		where UserNo = uno 
		and  TypeId = vacation_eappupdate.code 
		and Fromd = fromd
		and Tod = vacation_eappupdate.todt
		and VacationsCount = vacation_eappupdate.use);
		if(pcount <= 0)
		begin

			SELECT TimeDis INTO timedis FROM Vacation_Types WHERE TypeId = vacation_eappupdate.code;

			--SET realuse = Use * TimeDis;
			IF TimeDis = 0 THEN;
				insert into Vacation_Requests(UserNo,TypeId,Fromd,Tod,VacationsCount,Note,DateCreate,StatusUser,StatusAdmin) 
				values (uno,Code,fromd,Tod,0,'',NOW(),'0',2);
			END IF;
			ELSE;
				insert into Vacation_Requests(UserNo,TypeId,Fromd,Tod,VacationsCount,Note,DateCreate,StatusUser,StatusAdmin) 
				values (uno,Code,fromd,Tod,Use,'',NOW(),'0',2);
			END IF;
		END;
	END IF;
	ELSE;
		delete from Vacation_Requests where UserNo=(select UserNo from Organization_Users where UserID=vacation_eappupdate.userid)
		and TypeId=vacation_eappupdate.code and Fromd=CONVERT(datetime,FromDt) and Tod=CONVERT(datetime,ToDt) and VacationsCount=vacation_eappupdate.use
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
