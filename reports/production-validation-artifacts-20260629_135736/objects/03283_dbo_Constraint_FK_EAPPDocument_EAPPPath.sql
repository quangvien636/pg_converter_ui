-- ─── FK: fk_eappdocument_eapppath ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_eappdocument_eapppath' AND contype = 'f') THEN
        ALTER TABLE public."EAPPDocument" ADD CONSTRAINT fk_eappdocument_eapppath
            FOREIGN KEY (PathID) REFERENCES public."EAPPPath" (ID);
    END IF;
END;
$$;
