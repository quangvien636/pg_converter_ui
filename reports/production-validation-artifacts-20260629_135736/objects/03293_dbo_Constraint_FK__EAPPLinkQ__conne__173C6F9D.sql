-- ─── FK: fk__eapplinkq__conne__173c6f9d ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eapplinkq__conne__173c6f9d' AND contype = 'f') THEN
        ALTER TABLE public."EAPPLinkQuery" ADD CONSTRAINT fk__eapplinkq__conne__173c6f9d
            FOREIGN KEY (connectionid) REFERENCES public."EAPPLinkConnection" (id);
    END IF;
END;
$$;
