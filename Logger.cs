namespace pg_converter_ui;

public static class Logger
{
    static readonly string LogDir  = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs");
    static readonly object _lock   = new();

    public static string LogFile =>
        Path.Combine(LogDir, $"converter_{DateTime.Now:yyyyMMdd}.log");

    public static void Info (string msg)              => Write("INFO ", msg);
    public static void Warn (string msg)              => Write("WARN ", msg);
    public static void Error(string msg, Exception? ex = null) =>
        Write("ERROR", ex is null ? msg : $"{msg}\n         {ex.GetType().Name}: {ex.Message}\n         {ex.StackTrace?.Split('\n').FirstOrDefault()?.Trim()}");

    public static void Section(string title) =>
        Write("-----", $"── {title} ──────────────────────────────────────────");

    static void Write(string level, string msg)
    {
        try
        {
            var line = $"[{DateTime.Now:HH:mm:ss}] [{level}] {msg}";
            lock (_lock)
            {
                Directory.CreateDirectory(LogDir);
                File.AppendAllText(LogFile, line + Environment.NewLine);
            }
        }
        catch { /* never throw from logger */ }
    }
}
