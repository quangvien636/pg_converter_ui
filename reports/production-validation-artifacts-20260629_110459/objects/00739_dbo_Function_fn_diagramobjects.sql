-- ─── FUNCTION: fn_diagramobjects ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_diagramobjects();
CREATE OR REPLACE FUNCTION public.fn_diagramobjects(
) RETURNS integer
AS $function$
DECLARE
    id_upgraddiagrams integer;
    id_sysdiagrams integer;
    id_helpdiagrams integer;
    id_helpdiagramdefinition integer;
    id_creatediagram integer;
    id_renamediagram integer;
    id_alterdiagram integer;
    id_dropdiagram integer;
    installedobjects integer;
BEGIN










		select InstalledObjects = 0

		select 	id_upgraddiagrams = object_id('public."sp_upgraddiagrams"'),
			id_sysdiagrams = object_id('public."sysdiagrams"'),
			id_helpdiagrams = object_id('public."sp_helpdiagrams"'),
			id_helpdiagramdefinition = object_id('public."sp_helpdiagramdefinition"'),
			id_creatediagram = object_id('public."sp_creatediagram"'),
			id_renamediagram = object_id('public."sp_renamediagram"'),
			id_alterdiagram = object_id('public."sp_alterdiagram"'), 
			id_dropdiagram = object_id('public."sp_dropdiagram"')

		if id_upgraddiagrams is not null
			select InstalledObjects = InstalledObjects + 1
		if id_sysdiagrams is not null
			select InstalledObjects = InstalledObjects + 2
		if id_helpdiagrams is not null
			select InstalledObjects = InstalledObjects + 4
		if id_helpdiagramdefinition is not null
			select InstalledObjects = InstalledObjects + 8
		if id_creatediagram is not null
			select InstalledObjects = InstalledObjects + 16
		if id_renamediagram is not null
			select InstalledObjects = InstalledObjects + 32
		if id_alterdiagram  is not null
			select InstalledObjects = InstalledObjects + 64
		if id_dropdiagram is not null
			select InstalledObjects = InstalledObjects + 128
		
		return InstalledObjects;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
