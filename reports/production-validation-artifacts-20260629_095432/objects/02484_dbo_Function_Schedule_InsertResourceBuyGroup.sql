-- ─── FUNCTION: schedule_insertresourcebuygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourcebuygroup(character varying, date, integer, numeric, integer, integer, integer, character varying, boolean, character varying, boolean, integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcebuygroup(
    companyname character varying,
    buydate date,
    buyqty integer,
    buyamount numeric,
    mainmanagerno integer,
    submanagerno integer,
    categoryno integer DEFAULT 0,
    name character varying DEFAULT '',
    enabled boolean DEFAULT TRUE,
    description character varying DEFAULT '',
    isreservation boolean DEFAULT TRUE,
    type integer DEFAULT 0,
    p_ishidenreg boolean DEFAULT FALSE,
    p_color character varying DEFAULT ''
) RETURNS TABLE(
    buygroupno text
)
AS $function$
DECLARE
    buygroupno integer;
BEGIN




	INSERT INTO ScheduleResourcesBuyGroup
	(
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		CompanyName,
		BuyDate,
		BuyQty,
		BuyAmount,
		MainManagerNo,
		SubManagerNo
	)
	VALUES
	(
		UserNo,
		NOW(),
		UserNo,
		NOW(),
		CompanyName,
		BuyDate,
		BuyQty,
		BuyAmount,
		MainManagerNo,
		SubManagerNo
	)
	SET BuyGroupNo = lastval()
	-- 구입수량 만큼 자원을 생성합니다.

	if(BuyQty=0) begin 
		SET BuyQty = 1;
	end


	WHILE Cnt < schedule_insertresourcebuygroup.buyqty
	BEGIN;
		INSERT INTO ScheduleResources
		(
			RegUserNo,
			RegDate,
			ModUserNo,
			ModDate,
			CategoryNo,
			Name,
			Enabled,
			Description,
			IsReservation,
			BuyGroupNo,
			Type,
			IsHidenReg,Color
		)
		VALUES
		(
			UserNo,
			NOW(),
			UserNo,
			NOW(),
			CategoryNo,
			Name,
			Enabled,
			Description,
			IsReservation,
			BuyGroupNo,
			Type
			,p_IsHidenReg,p_Color
		)
		SET Cnt = Cnt + 1;
	END
	
	RETURN QUERY
	select BuyGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
