namespace pg_converter_ui;

static class Program
{
    [STAThread]
    static void Main()
    {
        Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);

        Application.ThreadException += (_, e) =>
        {
            Logger.Error("Unhandled UI thread exception", e.Exception);
            MessageBox.Show(
                $"Lỗi không mong đợi:\n{e.Exception.Message}\n\nXem chi tiết tại:\n{Logger.LogFile}",
                "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        };

        AppDomain.CurrentDomain.UnhandledException += (_, e) =>
        {
            if (e.ExceptionObject is Exception ex)
                Logger.Error("Unhandled domain exception", ex);
            else
                Logger.Error($"Fatal domain error: {e.ExceptionObject}");
        };

        Logger.Section("Application Start");
        Logger.Info($"Version 1.0  |  {DateTime.Now:yyyy-MM-dd}  |  PID {Environment.ProcessId}");

        ApplicationConfiguration.Initialize();
        Application.Run(new Form1());

        Logger.Section("Application Exit");
    }
}