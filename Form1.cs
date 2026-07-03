using System.Text;

namespace pg_converter_ui;

public partial class Form1 : Form
{
    private List<DbObject> _allObjects = new();
    private List<DbObject> _filtered  = new();

    // Connection controls
    private TextBox      txtServer   = null!;
    private TextBox      txtDatabase = null!;
    private RadioButton  radWin      = null!;
    private RadioButton  radSql      = null!;
    private TextBox      txtUser     = null!;
    private TextBox      txtPass     = null!;
    private Button       btnConnect  = null!;
    private Label        lblConnStatus = null!;

    // Filter controls
    private TextBox   txtOwner    = null!;
    private TextBox   txtSearch   = null!;
    private ComboBox  cmbModule   = null!;
    private CheckBox  chkFunction = null!, chkTable = null!, chkIndex = null!;

    // Results + output
    private ListView    lvResults = null!;
    private RichTextBox rtOutput  = null!;
    private Label       lblCount  = null!;
    private Label       lblStatus = null!;

    public Form1()
    {
        InitializeComponent();
        BuildUI();
    }

    void BuildUI()
    {
        Text          = "MSSQL → PostgreSQL Converter v1.0";
        Size          = new Size(1060, 840);
        MinimumSize   = new Size(860, 660);
        StartPosition = FormStartPosition.CenterScreen;
        Font          = new Font("Segoe UI", 9.5f);
        BackColor     = Color.FromArgb(245, 245, 250);

        var tbl = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            RowCount = 3, ColumnCount = 1,
            Padding = new Padding(8),
            BackColor = Color.Transparent
        };
        tbl.RowStyles.Add(new RowStyle(SizeType.Absolute, 155)); // connection panel
        tbl.RowStyles.Add(new RowStyle(SizeType.Absolute, 250)); // results
        tbl.RowStyles.Add(new RowStyle(SizeType.Percent,  100)); // output
        tbl.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        Controls.Add(tbl);

        // ── ROW 0: Connection ──────────────────────────────────────────────
        var grpConn = new GroupBox
        {
            Text = "Kết nối MSSQL",
            Dock = DockStyle.Fill,
            Padding = new Padding(8, 4, 8, 4),
            Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };

        // Row 1 — Server / Database
        grpConn.Controls.Add(MkLabel("Server:", 8, 24));
        txtServer = MkTextBox(65, 21, 210);
        txtServer.Text = Environment.GetEnvironmentVariable("PG_CONVERTER_MSSQL_SERVER") ?? "";
        grpConn.Controls.Add(txtServer);

        grpConn.Controls.Add(MkLabel("Database:", 290, 24));
        txtDatabase = MkTextBox(368, 21, 200); txtDatabase.Text = "CrewCloud_Company_Bootstrap";
        grpConn.Controls.Add(txtDatabase);

        // Row 2 — Auth
        radWin = new RadioButton { Text = "Windows Auth", Location = new Point(8, 54), Checked = false, AutoSize = true, Font = new Font("Segoe UI", 9.5f) };
        radSql = new RadioButton { Text = "SQL Server",   Location = new Point(125, 54), Checked = true, AutoSize = true, Font = new Font("Segoe UI", 9.5f) };
        grpConn.Controls.Add(radWin);
        grpConn.Controls.Add(radSql);

        grpConn.Controls.Add(MkLabel("User:", 230, 54));
        txtUser = MkTextBox(268, 51, 130);
        txtUser.Text = Environment.GetEnvironmentVariable("PG_CONVERTER_MSSQL_USER") ?? "";
        txtUser.Enabled = true;
        grpConn.Controls.Add(txtUser);

        grpConn.Controls.Add(MkLabel("Pass:", 412, 54));
        txtPass = MkTextBox(448, 51, 130);
        txtPass.PasswordChar = '●';
        txtPass.Text = Environment.GetEnvironmentVariable("PG_CONVERTER_MSSQL_PASSWORD") ?? "";
        txtPass.Enabled = true;
        grpConn.Controls.Add(txtPass);

        radSql.CheckedChanged += (s, e) =>
        {
            txtUser.Enabled = radSql.Checked;
            txtPass.Enabled = radSql.Checked;
        };

        btnConnect = new Button
        {
            Text = "🔌 Connect & Load",
            Location = new Point(595, 50), Width = 160, Height = 30,
            BackColor = Color.FromArgb(0, 120, 215), ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat, Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };
        btnConnect.FlatAppearance.BorderSize = 0;
        btnConnect.Click += ConnectAndLoad;
        grpConn.Controls.Add(btnConnect);

        lblConnStatus = new Label
        {
            Location = new Point(770, 56), AutoSize = true,
            Font = new Font("Segoe UI", 9f), ForeColor = Color.Gray
        };
        grpConn.Controls.Add(lblConnStatus);

        // Row 3 — Module / Owner
        grpConn.Controls.Add(MkLabel("Module:", 8, 90));
        cmbModule = new ComboBox
        {
            Location = new Point(68, 87), Width = 130,
            DropDownStyle = ComboBoxStyle.DropDownList,
            Font = new Font("Segoe UI", 9.5f)
        };
        cmbModule.Items.AddRange(new object[] { "Board", "Contact", "Notice", "dday", "Schedule", "EDMS" });
        cmbModule.SelectedIndex = 0;
        grpConn.Controls.Add(cmbModule);

        grpConn.Controls.Add(MkLabel("Owner:", 215, 90));
        txtOwner = MkTextBox(265, 87, 120); txtOwner.Text = "dazone";
        grpConn.Controls.Add(txtOwner);

        // Row 4 — Search
        grpConn.Controls.Add(MkLabel("Tìm kiếm:", 8, 121));
        txtSearch = MkTextBox(80, 118, 370);
        txtSearch.KeyDown += (s, e) => { if (e.KeyCode == Keys.Enter) DoSearch(); };
        grpConn.Controls.Add(txtSearch);

        var btnSearch = MkButton("🔍 Search", 460, 117, 100);
        btnSearch.BackColor = Color.FromArgb(60, 60, 60);
        btnSearch.ForeColor = Color.White;
        btnSearch.FlatStyle = FlatStyle.Flat;
        btnSearch.FlatAppearance.BorderSize = 0;
        btnSearch.Click += (s, e) => DoSearch();
        grpConn.Controls.Add(btnSearch);

        chkFunction = MkCheck("Function/Store", 575, 120, true);
        chkTable    = MkCheck("Table",          715, 120, true);
        chkIndex    = MkCheck("Index",          780, 120, true);
        grpConn.Controls.AddRange(new Control[] { chkFunction, chkTable, chkIndex });

        tbl.Controls.Add(grpConn, 0, 0);

        // ── ROW 1: Results ─────────────────────────────────────────────────
        var grpRes = new GroupBox
        {
            Text = "Kết quả",
            Dock = DockStyle.Fill,
            Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };

        var panResBtns = new Panel { Dock = DockStyle.Bottom, Height = 38, Padding = new Padding(4, 5, 4, 5) };

        var btnSelAll = MkButton("✔ Chọn tất cả",  4,   5, 115);
        var btnDesel  = MkButton("✘ Bỏ chọn",      124, 5, 90);
        lblCount = new Label { Text = "", Location = new Point(224, 9), AutoSize = true, ForeColor = Color.Gray, Font = new Font("Segoe UI", 9f) };

        var btnGen = new Button
        {
            Text = "▶  Generate Script",
            Size = new Size(168, 28),
            BackColor = Color.FromArgb(16, 124, 16),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Anchor = AnchorStyles.Top | AnchorStyles.Right,
            Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };
        btnGen.FlatAppearance.BorderSize = 0;
        btnGen.Click += GenerateScript;

        btnSelAll.Click += (s, e) => { foreach (ListViewItem i in lvResults.Items) i.Checked = true; };
        btnDesel.Click  += (s, e) => { foreach (ListViewItem i in lvResults.Items) i.Checked = false; };
        panResBtns.Controls.AddRange(new Control[] { btnSelAll, btnDesel, lblCount, btnGen });
        panResBtns.Resize += (s, e) =>
        {
            btnGen.Left = panResBtns.Width - btnGen.Width - 4;
            btnGen.Top  = 5;
        };

        lvResults = new ListView
        {
            Dock = DockStyle.Fill,
            View = View.Details, CheckBoxes = true,
            FullRowSelect = true, GridLines = true,
            Font = new Font("Consolas", 9.5f)
        };
        lvResults.Columns.Add("Tên", 440);
        lvResults.Columns.Add("Loại", 110);
        lvResults.Columns.Add("Trạng thái", 110);
        lvResults.ItemChecked += (s, e) =>
            lblCount.Text = $"{lvResults.CheckedItems.Count}/{lvResults.Items.Count} được chọn";

        grpRes.Controls.Add(lvResults);
        grpRes.Controls.Add(panResBtns);
        tbl.Controls.Add(grpRes, 0, 1);

        // ── ROW 2: Output ──────────────────────────────────────────────────
        var grpOut = new GroupBox
        {
            Text = "PostgreSQL Output",
            Dock = DockStyle.Fill,
            Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };

        var panOutBtns = new Panel { Dock = DockStyle.Bottom, Height = 38, Padding = new Padding(4, 5, 4, 5) };
        var btnCopy  = MkButton("📋 Copy",      4,   5, 90);
        var btnSave  = MkButton("💾 Save .sql", 100, 5, 105);
        var btnClear = MkButton("🗑 Clear",     212, 5, 80);
        var btnLog   = MkButton("📄 View Log",  298, 5, 100);
        lblStatus = new Label { Text = "", Location = new Point(408, 9), AutoSize = true, ForeColor = Color.Green, Font = new Font("Segoe UI", 9f) };

        btnCopy.Click += (s, e) =>
        {
            if (string.IsNullOrWhiteSpace(rtOutput.Text)) return;
            Clipboard.SetText(rtOutput.Text);
            SetStatus("✓ Copied!", Color.Green, 2000);
        };
        btnSave.Click  += SaveOutput;
        btnLog.Click   += OpenLog;
        btnClear.Click += (s, e) => { rtOutput.Clear(); lblStatus.Text = ""; };
        panOutBtns.Controls.AddRange(new Control[] { btnCopy, btnSave, btnClear, btnLog, lblStatus });

        rtOutput = new RichTextBox
        {
            Dock = DockStyle.Fill,
            Font = new Font("Consolas", 9.5f),
            BackColor = Color.FromArgb(28, 28, 28),
            ForeColor = Color.FromArgb(212, 212, 212),
            ScrollBars = RichTextBoxScrollBars.Both,
            WordWrap = false, DetectUrls = false
        };

        grpOut.Controls.Add(rtOutput);
        grpOut.Controls.Add(panOutBtns);
        tbl.Controls.Add(grpOut, 0, 2);
    }

    // ── Event handlers ─────────────────────────────────────────────────────

    async void ConnectAndLoad(object? sender, EventArgs e)
    {
        var server   = txtServer.Text.Trim();
        var database = txtDatabase.Text.Trim();

        if (string.IsNullOrEmpty(server) || string.IsNullOrEmpty(database))
        {
            MessageBox.Show("Nhập Server và Database.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return;
        }

        btnConnect.Enabled = false;
        btnConnect.Text = "⏳ Connecting...";
        lblConnStatus.ForeColor = Color.Gray;
        lblConnStatus.Text = "Đang kết nối...";
        Cursor = Cursors.WaitCursor;

        try
        {
            var (objects, error) = await Task.Run(() => MssqlDbReader.Load(
                server, database,
                radWin.Checked,
                txtUser.Text.Trim(), txtPass.Text.Trim(),
                chkFunction.Checked, chkTable.Checked, chkIndex.Checked));

            if (!string.IsNullOrEmpty(error))
            {
                lblConnStatus.ForeColor = Color.Red;
                lblConnStatus.Text = "✗ Lỗi kết nối";
                Logger.Error($"ConnectAndLoad: {server}/{database} — {error}");
                MessageBox.Show($"Lỗi:\n{error}", "Kết nối thất bại",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            _allObjects = objects;
            var fn  = _allObjects.Count(o => o.Type == ObjectType.Function);
            var tb  = _allObjects.Count(o => o.Type == ObjectType.Table);
            var ix  = _allObjects.Count(o => o.Type == ObjectType.Index);

            lblConnStatus.ForeColor = Color.Green;
            lblConnStatus.Text = $"✓ {_allObjects.Count} objects  (Fn:{fn} Tbl:{tb} Idx:{ix})";
            Text = $"MSSQL → PG Converter  │  {database}  │  {_allObjects.Count} objects";

            DoSearch();
        }
        catch (Exception ex)
        {
            Logger.Error("ConnectAndLoad exception", ex);
            lblConnStatus.ForeColor = Color.Red;
            lblConnStatus.Text = "✗ Lỗi";
            MessageBox.Show($"Lỗi không mong đợi:\n{ex.Message}\n\nXem log: {Logger.LogFile}",
                "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnConnect.Enabled = true;
            btnConnect.Text = "🔌 Connect & Load";
            Cursor = Cursors.Default;
        }
    }

    void DoSearch()
    {
        _filtered = MssqlParser.Search(
            _allObjects, txtSearch.Text,
            chkFunction.Checked, chkTable.Checked, chkIndex.Checked);

        lvResults.BeginUpdate();
        lvResults.Items.Clear();
        foreach (var obj in _filtered)
        {
            var item = new ListViewItem(obj.Name) { Checked = true };
            item.SubItems.Add(obj.Type.ToString());
            item.SubItems.Add(obj.Status);
            item.ForeColor = obj.Status switch
            {
                "STUB" => Color.Orange,
                _      => lvResults.ForeColor
            };
            lvResults.Items.Add(item);
        }
        lvResults.EndUpdate();
        lblCount.Text = $"{lvResults.CheckedItems.Count}/{_allObjects.Count} được chọn";
    }

    void GenerateScript(object? sender, EventArgs e)
    {
        lblStatus.Text = "";

        if (_allObjects.Count == 0)
        {
            MessageBox.Show("Chưa kết nối DB. Nhấn Connect & Load trước.", "Thông báo",
                MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        // Build selected list via index to avoid CheckedItems quirks with BeginUpdate
        var selected = new List<DbObject>();
        for (int i = 0; i < lvResults.Items.Count && i < _filtered.Count; i++)
            if (lvResults.Items[i].Checked)
                selected.Add(_filtered[i]);

        if (selected.Count == 0)
        {
            MessageBox.Show("Chọn ít nhất 1 object.", "Thông báo",
                MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        var owner = txtOwner.Text.Trim();
        if (string.IsNullOrEmpty(owner)) owner = "dazone";

        // Build table catalog for SELECT * resolution in functions
        var tableCatalog = _allObjects
            .Where(o => o.Type == ObjectType.Table
                     && o.RawBlock.StartsWith("__TABLE_FROM_CATALOG__", StringComparison.Ordinal))
            .ToDictionary(
                o => o.Name.ToLower(),
                o => MssqlDbReader.ParseTableRaw(o.RawBlock),
                StringComparer.OrdinalIgnoreCase);

        // Optional: verified SQL Server result-set metadata (ignored generated file), used
        // only to resolve RETURNS TABLE columns that static analysis could not infer.
        var resultMetadataCatalog = ResultMetadataCatalog.TryLoadDefault();

        Cursor = Cursors.WaitCursor;
        Logger.Section($"GenerateScript: {selected.Count} objects  owner={owner}  tables in catalog={tableCatalog.Count}  result metadata={resultMetadataCatalog?.Count ?? 0}");

        try
        {
            var sb = new StringBuilder();
            sb.AppendLine("-- ============================================================");
            sb.AppendLine("-- MSSQL → PostgreSQL Converter v1.0");
            sb.AppendLine($"-- Database : {txtDatabase.Text}");
            sb.AppendLine($"-- Module   : {cmbModule.SelectedItem}");
            sb.AppendLine($"-- Owner    : {owner}");
            sb.AppendLine($"-- Objects  : {selected.Count}");
            sb.AppendLine($"-- Date     : {DateTime.Now:yyyy-MM-dd HH:mm}");
            sb.AppendLine("-- ============================================================");
            sb.AppendLine();

            int ok = 0, warn = 0, err = 0;
            foreach (var obj in selected)
            {
                try
                {
                    var sql = Converter.Convert(obj, owner, tableCatalog, resultMetadataCatalog);
                    sb.AppendLine(sql);
                    sb.AppendLine();
                    // -- !! ERROR lines come from Converter's internal catch → count as error
                    if (sql.Contains("-- !! ERROR", StringComparison.OrdinalIgnoreCase))
                        err++;
                    else if (sql.Contains("-- TODO:", StringComparison.OrdinalIgnoreCase)
                          || sql.Contains("-- !!", StringComparison.Ordinal))
                        warn++;
                    else
                        ok++;
                }
                catch (Exception ex)
                {
                    Logger.Error($"GenerateScript [{obj.Type}] {obj.Name}", ex);
                    sb.AppendLine($"-- !! ERROR: {obj.Name} — {ex.Message}");
                    sb.AppendLine();
                    err++;
                }
            }

            rtOutput.Text = sb.ToString();
            HighlightOutput(rtOutput);
            Logger.Info($"GenerateScript done: {ok} OK, {warn} warn, {err} errors");

            string statusMsg;
            Color  statusCol;
            if (err > 0 && warn > 0)
            {
                statusMsg = $"✗ {err} lỗi  |  ⚠ {warn} cần review  |  ✓ {ok} OK";
                statusCol = Color.OrangeRed;
            }
            else if (err > 0)
            {
                statusMsg = $"✗ {err} lỗi  |  ✓ {ok} OK";
                statusCol = Color.OrangeRed;
            }
            else if (warn > 0)
            {
                statusMsg = $"⚠ {warn} cần review (xem TODO trong output)  |  ✓ {ok} OK";
                statusCol = Color.DarkOrange;
            }
            else
            {
                statusMsg = $"✓ {ok} objects generated";
                statusCol = Color.Green;
            }
            SetStatus(statusMsg, statusCol, 0);
        }
        catch (Exception ex)
        {
            Logger.Error("GenerateScript unexpected exception", ex);
            MessageBox.Show($"Lỗi khi generate:\n{ex.Message}\n\nXem log: {Logger.LogFile}",
                "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            Cursor = Cursors.Default;
        }
    }

    void SaveOutput(object? sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(rtOutput.Text)) return;
        using var dlg = new SaveFileDialog
        {
            Title = "Lưu PostgreSQL script",
            Filter = "SQL files (*.sql)|*.sql|All files (*.*)|*.*",
            FileName = $"{cmbModule.SelectedItem}_PG_{DateTime.Now:yyyyMMdd_HHmm}.sql"
        };
        if (dlg.ShowDialog() != DialogResult.OK) return;
        try
        {
            File.WriteAllText(dlg.FileName, rtOutput.Text, new UTF8Encoding(false));
            Logger.Info($"Saved output → {dlg.FileName}  ({rtOutput.Text.Length:N0} chars)");
            SetStatus($"✓ Saved: {Path.GetFileName(dlg.FileName)}", Color.Green, 4000);
        }
        catch (Exception ex)
        {
            Logger.Error($"SaveOutput: {dlg.FileName}", ex);
            MessageBox.Show($"Không thể lưu file:\n{ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    void OpenLog(object? sender, EventArgs e)
    {
        try
        {
            var logFile = Logger.LogFile;
            if (!File.Exists(logFile))
            {
                MessageBox.Show("Chưa có file log hôm nay.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(logFile) { UseShellExecute = true });
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Không mở được log:\n{ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
    }

    void SetStatus(string msg, Color color, int clearAfterMs)
    {
        lblStatus.ForeColor = color;
        lblStatus.Text = msg;
        if (clearAfterMs > 0)
            Task.Delay(clearAfterMs).ContinueWith(_ =>
                Invoke(() => { if (lblStatus.Text == msg) lblStatus.Text = ""; }));
    }

    void HighlightOutput(RichTextBox rtb)
    {
        if (rtb.TextLength == 0) return;
        var text = rtb.Text; // RichTextBox normalises to \n internally
        rtb.SuspendLayout();
        try
        {
            int pos = 0;
            while (pos < text.Length)
            {
                int nl      = text.IndexOf('\n', pos);
                int lineEnd = nl >= 0 ? nl : text.Length;
                var line    = text[pos..lineEnd];

                Color? col = null;
                var trimmed = line.TrimStart();
                if (trimmed.StartsWith("-- !! ERROR", StringComparison.OrdinalIgnoreCase))
                    col = Color.FromArgb(255, 80, 60);       // red — conversion errors
                else if (trimmed.StartsWith("-- !!", StringComparison.Ordinal))
                    col = Color.FromArgb(255, 140, 40);      // orange — !! WARNING header
                else if (line.Contains("-- TODO:", StringComparison.OrdinalIgnoreCase))
                    col = Color.FromArgb(255, 215, 0);       // gold — inline TODO lines
                else if (trimmed.StartsWith("-- ─── FUNCTION:", StringComparison.OrdinalIgnoreCase)
                      || trimmed.StartsWith("-- ─── TABLE:", StringComparison.OrdinalIgnoreCase)
                      || trimmed.StartsWith("-- ─── INDEX:", StringComparison.OrdinalIgnoreCase))
                    col = Color.FromArgb(100, 210, 255);     // cyan — object headers

                if (col.HasValue && lineEnd > pos)
                {
                    rtb.Select(pos, lineEnd - pos);
                    rtb.SelectionColor = col.Value;
                }

                pos = lineEnd + 1;
                if (nl < 0) break;
            }
        }
        finally
        {
            rtb.SelectionStart  = 0;
            rtb.SelectionLength = 0;
            rtb.ResumeLayout();
        }
    }

    // ── UI helpers ─────────────────────────────────────────────────────────

    static Label MkLabel(string text, int x, int y) =>
        new() { Text = text, Location = new Point(x, y), AutoSize = true };

    static TextBox MkTextBox(int x, int y, int w) =>
        new() { Location = new Point(x, y), Width = w, Font = new Font("Segoe UI", 9.5f) };

    static Button MkButton(string text, int x, int y, int w) =>
        new() { Text = text, Location = new Point(x, y), Width = w, Height = 28, Font = new Font("Segoe UI", 9f) };

    static CheckBox MkCheck(string text, int x, int y, bool chk) =>
        new() { Text = text, Location = new Point(x, y), AutoSize = true, Checked = chk };
}
