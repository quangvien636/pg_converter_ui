-- ─── FK: fk__eappcmono__depar__034ce78e ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk__eappcmono__depar__034ce78e' AND contype = 'f') THEN
        ALTER TABLE public."EAPPCMONOrgan" ADD CONSTRAINT fk__eappcmono__depar__034ce78e
            FOREIGN KEY (DepartNo) REFERENCES public."Organization_Departments" (DepartNo);
    END IF;
END;
$$;
