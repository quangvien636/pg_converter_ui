-- ─── FUNCTION: vacation_eappupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.vacation_eappupdate(character varying, character varying, integer, character varying, character varying, double precision);
CREATE OR REPLACE FUNCTION public.vacation_eappupdate(
    mode character varying,
    userid character varying,
    code integer,
    fromdt character varying,
    todt character varying,
    use double precision
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	IF Mode = '신청'
	BEGIN

	    ---DELETE FROM Vacation_Requests where UserNo = uno;




		from Vacation_Requests
		where UserNo = uno 
		and  TypeId = vacation_eappupdate.code 
		and Fromd = fromd
		and Tod = vacation_eappupdate.todt
		and VacationsCount = vacation_eappupdate.use);
		if(pcount <= 0)
		begin

			SELECT TimeDis = TimeDis FROM Vacation_Types WHERE TypeId = vacation_eappupdate.code;

			--SET realuse = Use * TimeDis;
			if (TimeDis = 0)
			BEGIN;
				insert into Vacation_Requests(UserNo,TypeId,Fromd,Tod,VacationsCount,Note,DateCreate,StatusUser,StatusAdmin) 
				values (uno,Code,fromd,Tod,0,'',NOW(),'0',2);
			END
			ELSE
			BEGIN;
				insert into Vacation_Requests(UserNo,TypeId,Fromd,Tod,VacationsCount,Note,DateCreate,StatusUser,StatusAdmin) 
				values (uno,Code,fromd,Tod,Use,'',NOW(),'0',2);
			END
		end
	END
	ELSE
	BEGIN;
		delete from Vacation_Requests where UserNo=(select UserNo from Organization_Users where UserID=vacation_eappupdate.userid)
		and TypeId=vacation_eappupdate.code and Fromd=CONVERT(datetime,FromDt) and Tod=CONVERT(datetime,ToDt) and VacationsCount=vacation_eappupdate.use
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
