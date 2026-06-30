-- ─── FK: fk_eapppathdetail_eapppath ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_eapppathdetail_eapppath' AND contype = 'f') THEN
        ALTER TABLE public."EAPPPathDetail" ADD CONSTRAINT fk_eapppathdetail_eapppath
            FOREIGN KEY (LineID) REFERENCES public."EAPPPath" (ID) ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END;
$$;
