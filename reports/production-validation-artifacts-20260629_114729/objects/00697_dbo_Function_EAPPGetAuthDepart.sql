-- ─── FUNCTION: eappgetauthdepart ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetauthdepart(character varying);
CREATE OR REPLACE FUNCTION public.eappgetauthdepart(
    mainauth character varying
) RETURNS TABLE(
    orgcd character varying
)
AS $function$
#variable_conflict use_column
DECLARE
    temporgan table 
	(
			orgcd	varchar(4);
BEGIN
 

		--전계열사를 불러야 하는데 그방법이 모호해서 아래 55 와 같이 임의로 만들었다.
		IF OrgCd = 'ADM'
		BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT OrgCd FROM CMONOrgan
		END
		ELSE IF MainAuth='100'		--전계열사
 		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT OrgCd FROM  public."COMNGetOrganChild"(OrgCd)
		 END
		ELSE IF MainAuth='200'	--전사
		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT OrgCd FROM  public."COMNGetOrganChild"(OrgCd)
		 END
		ELSE IF MainAuth='300'	--하위부서
		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT OrgCd FROM  public."COMNGetOrganChild"(OrgCd)
		 END
		ELSE IF MainAuth='400'	--팀
		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT OrgCd FROM  public."COMNGetOrganTeam"(OrgCd)
		 END
		ELSE
		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) VALUES(OrgCd)
		 END

		IF UserID<>''	--특정부서
		 BEGIN;
			INSERT INTO TempOrgan(OrgCd) SELECT DepartID FROM EAPPDepartAuth WHERE UserID=UserID
		 END

		INSERT INTO Organ(OrgCd) SELECT distinct OrgCd FROM TempOrgan ORDER BY OrgCd
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
