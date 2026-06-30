-- ─── TABLE: CrewChat_IOSDevices ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."CrewChat_IOSDevices" (
    DeviceNo bigserial NOT NULL,
    UserNo integer NOT NULL,
    DeviceID character varying(2000) NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    NotifyEnable boolean NOT NULL,
    NotifyUseTime boolean NOT NULL,
    NotifyStartTime character varying(50) NOT NULL,
    NotifyEndTime character varying(50) NOT NULL,
    NotifyConfirmOnline boolean NOT NULL,
    TimeZoneOffset integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
