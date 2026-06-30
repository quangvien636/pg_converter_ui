-- ─── TABLE: WorkingTime_AllowDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_AllowDevices" (
    AllowDeviceNo serial NOT NULL,
    DepartNo integer NOT NULL DEFAULT 0,
    UserNo integer NOT NULL DEFAULT 0 PRIMARY KEY,
    ContentAllow text NOT NULL,
    ModDate timestamp without time zone DEFAULT now(),
    RegDate timestamp without time zone DEFAULT now(),
    IsUserFull boolean DEFAULT false,
    DeviceId character varying(2000) NOT NULL DEFAULT '',
    verson character varying(100),
    SessionID character(32)
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
