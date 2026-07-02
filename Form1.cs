using System.Text;
using System.Diagnostics;

namespace pg_converter_ui;

public partial class Form1 : Form
{
    const string DefaultImagesFolderName = "short_video_images";
    const string DefaultVideoRootFolder = "pg_converter_ui";
    const string DefaultVideoOutputFolderName = "short_videos";

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

    // Short video controls
    private TextBox txtFfmpeg = null!;
    private TextBox txtVideoImages = null!;
    private TextBox txtVideoAudio = null!;
    private TextBox txtVideoLogo = null!;
    private TextBox txtVideoWatermark = null!;
    private TextBox txtVideoOutput = null!;
    private NumericUpDown nudImageDuration = null!;
    private NumericUpDown nudMaxDuration = null!;
    private ComboBox cmbVideoPreset = null!;
    private CheckBox chkAutoVideo = null!;
    private Button btnCreateVideo = null!;
    private Button btnVideoPreview = null!;
    private Button btnOpenVideoFolder = null!;
    private ProgressBar prgVideo = null!;
    private Label lblVideoStatus = null!;
    private PictureBox picVideoPreview = null!;
    private string? _lastVideoFile;

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
            RowCount = 4, ColumnCount = 1,
            Padding = new Padding(8),
            BackColor = Color.Transparent
        };
        tbl.RowStyles.Add(new RowStyle(SizeType.Absolute, 155)); // connection panel
        tbl.RowStyles.Add(new RowStyle(SizeType.Absolute, 250)); // results
        tbl.RowStyles.Add(new RowStyle(SizeType.Absolute, 230)); // short video
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
        txtServer = MkTextBox(65, 21, 210); txtServer.Text = "221.148.141.4,14233";
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
        txtUser = MkTextBox(268, 51, 130); txtUser.Text = "dazone"; txtUser.Enabled = true;
        grpConn.Controls.Add(txtUser);

        grpConn.Controls.Add(MkLabel("Pass:", 412, 54));
        txtPass = MkTextBox(448, 51, 130);
        txtPass.PasswordChar = '●'; txtPass.Text = "crewcloud12!@"; txtPass.Enabled = true;
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

        // ── ROW 2: Short video ──────────────────────────────────────────────
        var grpVideo = new GroupBox
        {
            Text = "Auto Create Short Video",
            Dock = DockStyle.Fill,
            Font = new Font("Segoe UI", 9.5f, FontStyle.Bold)
        };

        grpVideo.Controls.Add(MkLabel("FFmpeg:", 10, 29));
        txtFfmpeg = MkTextBox(75, 26, 250);
        txtFfmpeg.Text = "ffmpeg";
        grpVideo.Controls.Add(txtFfmpeg);

        grpVideo.Controls.Add(MkLabel("Images:", 340, 29));
        txtVideoImages = MkTextBox(397, 26, 380);
        txtVideoImages.Text = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyPictures), DefaultImagesFolderName);
        grpVideo.Controls.Add(txtVideoImages);
        var btnBrowseImages = MkButton("...", 786, 25, 36);
        btnBrowseImages.Click += (_, _) => BrowseVideoFolder(txtVideoImages, "Chọn thư mục ảnh nguồn");
        grpVideo.Controls.Add(btnBrowseImages);

        grpVideo.Controls.Add(MkLabel("Audio:", 10, 64));
        txtVideoAudio = MkTextBox(75, 61, 250);
        grpVideo.Controls.Add(txtVideoAudio);
        var btnBrowseAudio = MkButton("...", 334, 60, 36);
        btnBrowseAudio.Click += (_, _) => BrowseVideoFile(txtVideoAudio, "Chọn file nhạc nền", "Audio files|*.mp3;*.wav;*.m4a|All files|*.*");
        grpVideo.Controls.Add(btnBrowseAudio);

        grpVideo.Controls.Add(MkLabel("Logo:", 385, 64));
        txtVideoLogo = MkTextBox(430, 61, 347);
        grpVideo.Controls.Add(txtVideoLogo);
        var btnBrowseLogo = MkButton("...", 786, 60, 36);
        btnBrowseLogo.Click += (_, _) => BrowseVideoFile(txtVideoLogo, "Chọn file logo", "Image files|*.png;*.jpg;*.jpeg;*.bmp;*.webp|All files|*.*");
        grpVideo.Controls.Add(btnBrowseLogo);

        grpVideo.Controls.Add(MkLabel("Watermark:", 10, 99));
        txtVideoWatermark = MkTextBox(96, 96, 274);
        txtVideoWatermark.Text = "MSSQL to PostgreSQL";
        grpVideo.Controls.Add(txtVideoWatermark);

        grpVideo.Controls.Add(MkLabel("Output:", 385, 99));
        txtVideoOutput = MkTextBox(430, 96, 347);
        txtVideoOutput.Text = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), DefaultVideoRootFolder, DefaultVideoOutputFolderName);
        grpVideo.Controls.Add(txtVideoOutput);
        var btnBrowseOutput = MkButton("...", 786, 95, 36);
        btnBrowseOutput.Click += (_, _) => BrowseVideoFolder(txtVideoOutput, "Chọn thư mục output video");
        grpVideo.Controls.Add(btnBrowseOutput);

        grpVideo.Controls.Add(MkLabel("Sec/image:", 10, 134));
        nudImageDuration = new NumericUpDown
        {
            Location = new Point(78, 131),
            Width = 55,
            Minimum = 1,
            Maximum = 10,
            Value = 2
        };
        grpVideo.Controls.Add(nudImageDuration);

        grpVideo.Controls.Add(MkLabel("Max sec:", 145, 134));
        nudMaxDuration = new NumericUpDown
        {
            Location = new Point(205, 131),
            Width = 60,
            Minimum = 5,
            Maximum = 300,
            Value = 30
        };
        grpVideo.Controls.Add(nudMaxDuration);

        grpVideo.Controls.Add(MkLabel("Preset:", 278, 134));
        cmbVideoPreset = new ComboBox
        {
            Location = new Point(332, 131),
            Width = 90,
            DropDownStyle = ComboBoxStyle.DropDownList
        };
        cmbVideoPreset.Items.AddRange(new object[] { "veryfast", "fast", "medium", "slow" });
        cmbVideoPreset.SelectedItem = "medium";
        grpVideo.Controls.Add(cmbVideoPreset);

        chkAutoVideo = MkCheck("Auto tạo sau khi Generate Script", 435, 133, false);
        grpVideo.Controls.Add(chkAutoVideo);

        btnCreateVideo = new Button
        {
            Text = "🎬 Create Short Video",
            Location = new Point(10, 165),
            Width = 170,
            Height = 30,
            BackColor = Color.FromArgb(16, 124, 16),
            ForeColor = Color.White,
            FlatStyle = FlatStyle.Flat,
            Font = new Font("Segoe UI", 9.2f, FontStyle.Bold)
        };
        btnCreateVideo.FlatAppearance.BorderSize = 0;
        btnCreateVideo.Click += async (_, _) => await CreateShortVideoAsync(autoTriggered: false);
        grpVideo.Controls.Add(btnCreateVideo);

        btnVideoPreview = MkButton("🖼 Preview", 190, 166, 92);
        btnVideoPreview.Click += async (_, _) => await RefreshVideoPreviewAsync();
        grpVideo.Controls.Add(btnVideoPreview);

        btnOpenVideoFolder = MkButton("📂 Output", 286, 166, 90);
        btnOpenVideoFolder.Click += (_, _) =>
        {
            try
            {
                var outputPath = txtVideoOutput.Text.Trim();
                if (string.IsNullOrWhiteSpace(outputPath) || outputPath.IndexOfAny(Path.GetInvalidPathChars()) >= 0)
                    throw new InvalidOperationException("Đường dẫn output không hợp lệ.");

                Directory.CreateDirectory(outputPath);
                Process.Start(new ProcessStartInfo(outputPath) { UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Không mở được thư mục output:\n{ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        };
        grpVideo.Controls.Add(btnOpenVideoFolder);

        prgVideo = new ProgressBar
        {
            Location = new Point(385, 167),
            Width = 280,
            Height = 22,
            Minimum = 0,
            Maximum = 100
        };
        grpVideo.Controls.Add(prgVideo);

        lblVideoStatus = new Label
        {
            Location = new Point(675, 171),
            Width = 145,
            Height = 22,
            AutoEllipsis = true,
            ForeColor = Color.Gray,
            Font = new Font("Segoe UI", 8.8f)
        };
        grpVideo.Controls.Add(lblVideoStatus);

        picVideoPreview = new PictureBox
        {
            Location = new Point(829, 22),
            Size = new Size(200, 174),
            BorderStyle = BorderStyle.FixedSingle,
            SizeMode = PictureBoxSizeMode.Zoom,
            BackColor = Color.Black
        };
        grpVideo.Controls.Add(picVideoPreview);

        tbl.Controls.Add(grpVideo, 0, 2);

        // ── ROW 3: Output ──────────────────────────────────────────────────
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
        tbl.Controls.Add(grpOut, 0, 3);
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

        Cursor = Cursors.WaitCursor;
        Logger.Section($"GenerateScript: {selected.Count} objects  owner={owner}  tables in catalog={tableCatalog.Count}");

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
                    var sql = Converter.Convert(obj, owner, tableCatalog);
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
            if (chkAutoVideo.Checked)
                _ = CreateShortVideoAsync(autoTriggered: true);
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

    ShortVideoRequest BuildVideoRequest()
    {
        var outputFolder = txtVideoOutput.Text.Trim();
        if (string.IsNullOrWhiteSpace(outputFolder))
            outputFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), DefaultVideoRootFolder, DefaultVideoOutputFolderName);

        return new ShortVideoRequest(
            txtFfmpeg.Text.Trim(),
            txtVideoImages.Text.Trim(),
            string.IsNullOrWhiteSpace(txtVideoAudio.Text) ? null : txtVideoAudio.Text.Trim(),
            string.IsNullOrWhiteSpace(txtVideoLogo.Text) ? null : txtVideoLogo.Text.Trim(),
            string.IsNullOrWhiteSpace(txtVideoWatermark.Text) ? null : txtVideoWatermark.Text.Trim(),
            outputFolder,
            (int)nudImageDuration.Value,
            (int)nudMaxDuration.Value,
            cmbVideoPreset.SelectedItem?.ToString() ?? "medium",
            chkAutoVideo.Checked);
    }

    async Task CreateShortVideoAsync(bool autoTriggered)
    {
        try
        {
            var request = BuildVideoRequest();
            if (!ShortVideoService.TryCreatePlan(request, out var plan, out var error))
            {
                lblVideoStatus.ForeColor = Color.OrangeRed;
                lblVideoStatus.Text = "Không đủ dữ liệu";
                if (!autoTriggered)
                    MessageBox.Show(error, "Không thể tạo video", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            btnCreateVideo.Enabled = false;
            btnVideoPreview.Enabled = false;
            prgVideo.Value = 0;
            lblVideoStatus.ForeColor = Color.DodgerBlue;
            lblVideoStatus.Text = "Đang render...";
            Logger.Section("Short video render");
            Logger.Info($"Video plan: images={plan.ImageFiles.Count}, audio={plan.HasAudio}, logo={plan.HasLogo}, target={plan.TargetDuration.TotalSeconds:0}s");

            await ShortVideoService.WriteConcatListAsync(plan, (int)nudImageDuration.Value);
            var result = await ShortVideoService.RenderAsync(plan, p =>
            {
                if (IsDisposed) return;
                BeginInvoke(() =>
                {
                    prgVideo.Value = p;
                    lblVideoStatus.Text = $"Đang render... {p}%";
                });
            });

            Logger.Info(result.LogText);
            if (!result.Success || !File.Exists(result.OutputFile))
            {
                lblVideoStatus.ForeColor = Color.OrangeRed;
                lblVideoStatus.Text = "Render lỗi";
                if (!autoTriggered)
                    MessageBox.Show(result.ErrorMessage ?? "Tạo video thất bại.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            _lastVideoFile = result.OutputFile;
            lblVideoStatus.ForeColor = Color.Green;
            lblVideoStatus.Text = "✓ Video đã tạo";
            prgVideo.Value = 100;
            SetStatus($"✓ Video: {Path.GetFileName(result.OutputFile)}", Color.Green, 5000);
            await RefreshVideoPreviewAsync(result.OutputFile, result.PreviewImageFile, request.FfmpegPath);
        }
        catch (Exception ex)
        {
            Logger.Error("CreateShortVideoAsync", ex);
            lblVideoStatus.ForeColor = Color.OrangeRed;
            lblVideoStatus.Text = "Render lỗi";
            if (!autoTriggered)
                MessageBox.Show($"Tạo video thất bại:\n{ex.Message}", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            btnCreateVideo.Enabled = true;
            btnVideoPreview.Enabled = true;
        }
    }

    async Task RefreshVideoPreviewAsync(string? videoPath = null, string? previewPath = null, string? ffmpegPath = null)
    {
        var resolvedVideo = videoPath ?? _lastVideoFile;
        if (string.IsNullOrWhiteSpace(resolvedVideo) || !File.Exists(resolvedVideo))
        {
            MessageBox.Show("Chưa có video nào để preview.", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            return;
        }

        var resolvedPreview = previewPath
            ?? Path.Combine(txtVideoOutput.Text.Trim(), $"{Path.GetFileNameWithoutExtension(resolvedVideo)}_preview.jpg");
        var ffmpeg = string.IsNullOrWhiteSpace(ffmpegPath) ? txtFfmpeg.Text.Trim() : ffmpegPath;

        var ok = await ShortVideoService.GeneratePreviewAsync(ffmpeg, resolvedVideo, resolvedPreview);
        if (!ok || !File.Exists(resolvedPreview))
        {
            lblVideoStatus.ForeColor = Color.OrangeRed;
            lblVideoStatus.Text = "Preview lỗi";
            return;
        }

        picVideoPreview.Image?.Dispose();
        picVideoPreview.Image = new Bitmap(resolvedPreview);
        lblVideoStatus.ForeColor = Color.Green;
        lblVideoStatus.Text = "✓ Preview ready";
    }

    static void BrowseVideoFolder(TextBox target, string title)
    {
        using var dlg = new FolderBrowserDialog
        {
            Description = title,
            UseDescriptionForTitle = true
        };
        if (!string.IsNullOrWhiteSpace(target.Text) && Directory.Exists(target.Text))
            dlg.InitialDirectory = target.Text;
        if (dlg.ShowDialog() == DialogResult.OK)
            target.Text = dlg.SelectedPath;
    }

    static void BrowseVideoFile(TextBox target, string title, string filter)
    {
        using var dlg = new OpenFileDialog
        {
            Title = title,
            Filter = filter
        };
        if (!string.IsNullOrWhiteSpace(target.Text) && File.Exists(target.Text))
        {
            var dir = Path.GetDirectoryName(target.Text);
            if (!string.IsNullOrWhiteSpace(dir))
                dlg.InitialDirectory = dir;
            dlg.FileName = Path.GetFileName(target.Text);
        }

        if (dlg.ShowDialog() == DialogResult.OK)
            target.Text = dlg.FileName;
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
