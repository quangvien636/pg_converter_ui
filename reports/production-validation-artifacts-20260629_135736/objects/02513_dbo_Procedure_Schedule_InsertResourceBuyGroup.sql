-- ─── PROCEDURE→FUNCTION: schedule_insertresourcebuygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_insertresourcebuygroup(character varying, date, integer, numeric, integer, integer, integer, character varying, boolean, character varying, boolean, integer, boolean, character varying);
CREATE OR REPLACE FUNCTION public.schedule_insertresourcebuygroup(
    IN companyname character varying,
    IN buydate date,
    IN buyqty integer,
    IN buyamount numeric,
    IN mainmanagerno integer,
    IN submanagerno integer,
    IN categoryno integer DEFAULT 0,
    IN name character varying DEFAULT '',
    IN enabled boolean DEFAULT TRUE,
    IN description character varying DEFAULT '',
    IN isreservation boolean DEFAULT TRUE,
    IN type integer DEFAULT 0,
    IN p_ishidenreg boolean DEFAULT FALSE,
    IN p_color character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
DECLARE
    buygroupno integer;
-- !! WARNING: output needs manual review — see TODO comments
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
	BuyGroupNo := lastval();
	-- 구입수량 만큼 자원을 생성합니다.

	if(BuyQty=0) begin 
		BuyQty := 1;
	END;


	WHILE Cnt < schedule_insertresourcebuygroup.buyqty LOOP;
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
		Cnt := Cnt + 1;
	END LOOP;
	
	RETURN QUERY
	select BuyGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
