-- ─── PROCEDURE→FUNCTION: bslg_mod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_mod(character varying, character varying, text, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_mod(
    IN userid character varying,
    IN date character varying,
    IN content text,
    IN title character varying,
    IN plot character varying,
    IN orgcd character varying
) RETURNS SETOF record
AS $function$
DECLARE
    chk character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Plot is null THEN
			SELECT UserID INTO chk FROM BSLG_Log WHERE UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot is null and OrgCd =bslg_mod.orgcd
		END IF;
	ELSE
			SELECT UserID INTO chk FROM BSLG_Log WHERE UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot = bslg_mod.plot and OrgCd =bslg_mod.orgcd
		END IF;
		
	IF Plot is null THEN
			IF UserID = Chk THEN;
					UPDATE BSLG_Log SET Content1=bslg_mod.content , Title=bslg_mod.title,OrgCd=bslg_mod.orgcd
					WHERE  UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot is null
				END IF;
			ELSE;
					INSERT INTO BSLG_Log(UserID, RegDate, Content1, Content2, Title,orgcd)
					VALUES(UserID, Date, Content, '', Title,orgcd)
				END IF;
		END IF;
	ELSE
			IF UserID = Chk THEN;
					UPDATE BSLG_Log SET Content1=bslg_mod.content , Title=bslg_mod.title
					WHERE  UserID = bslg_mod.userid AND RegDate=bslg_mod.date AND Plot = bslg_mod.plot and OrgCd=bslg_mod.orgcd
				END IF;
			ELSE;
					INSERT INTO BSLG_Log(UserID, RegDate, Content1, Content2, Title, Plot,Orgcd)
					VALUES(UserID, Date, Content, '', Title,Plot,orgcd)
				END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
