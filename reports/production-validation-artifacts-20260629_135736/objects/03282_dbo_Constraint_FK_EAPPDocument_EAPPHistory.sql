-- ─── FK: fk_eappdocument_eapphistory ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_eappdocument_eapphistory' AND contype = 'f') THEN
        ALTER TABLE public."EAPPDocument" ADD CONSTRAINT fk_eappdocument_eapphistory
            FOREIGN KEY (HistoryID) REFERENCES public."EAPPHistory" (ID);
    END IF;
END;
$$;
