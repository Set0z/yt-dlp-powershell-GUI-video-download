#Version: 1.6.0

#region Глобальные переменные
$version = "1.6.0"
$pwshPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$script:debug = $false
$script:multiple_audio = $false
$script:yt_dlp_error = $false
$IsRemoteInvocation = $false
try { node --version *>$null; $script:node_installed = $true } catch { $script:node_installed = $false }
if ($PSScriptRoot -eq "") {$IsRemoteInvocation = $true}
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
#endregion

#region Создание форм Links
$form_links = New-Object System.Windows.Forms.Form
$form_links.Text = "Links"
$form_links.Size = New-Object System.Drawing.Size(300,140)
$form_links.StartPosition = "CenterScreen"
$form_links.FormBorderStyle = 'FixedSingle'
$form_links.MaximizeBox = $false
$form_links.MinimizeBox = $false
$form_links.BackColor = [System.Drawing.Color]::FromArgb(1,46,110)
$form_links.ForeColor = [System.Drawing.Color]::White
$form_links.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($pwshPath)

$button_link_github = New-Object System.Windows.Forms.Button
$button_link_github.Location = New-Object System.Drawing.Point(10,15)
$button_link_github.Size = New-Object System.Drawing.Size(260,25)
$button_link_github.Text = "GitHub"
$button_link_github.UseVisualStyleBackColor = $false
$button_link_github.BackColor = [System.Drawing.Color]::White
$button_link_github.ForeColor = [System.Drawing.Color]::Black
$form_links.Controls.Add($button_link_github)

$button_link_donate = New-Object System.Windows.Forms.Button
$button_link_donate.Location = New-Object System.Drawing.Point(10,55)
$button_link_donate.Size = New-Object System.Drawing.Size(260,25)
$button_link_donate.Text = "Support"
$button_link_donate.UseVisualStyleBackColor = $false
$button_link_donate.BackColor = [System.Drawing.Color]::White
$button_link_donate.ForeColor = [System.Drawing.Color]::Black
$form_links.Controls.Add($button_link_donate)
#endregion

#region Создание форм Cookie

# Создаем форму Cookie
$form_cookie = New-Object System.Windows.Forms.Form
$form_cookie.Text = "Cookie Settings"
$form_cookie.Size = New-Object System.Drawing.Size(225,150)
$form_cookie.StartPosition = "CenterScreen"
$form_cookie.FormBorderStyle = 'FixedSingle' #
$form_cookie.MaximizeBox = $false
$form_cookie.MinimizeBox = $false
$form_cookie.BackColor = [System.Drawing.Color]::FromArgb(1,46,110)
$form_cookie.ForeColor = [System.Drawing.Color]::White
$form_cookie.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($pwshPath)

#Создаём RadioButton Browser
$radio_cookies_browser = New-Object System.Windows.Forms.RadioButton
$radio_cookies_browser.Location = New-Object System.Drawing.Point(11,15)
$radio_cookies_browser.Size = New-Object System.Drawing.Size(95,15)
$radio_cookies_browser.Text = "From browser:"
$radio_cookies_browser.Checked = $true
$radio_cookies_browser.Enabled = $false

#Создаём RadioButton File
$radio_cookies_file = New-Object System.Windows.Forms.RadioButton
$radio_cookies_file.Location = New-Object System.Drawing.Point(11,50)
$radio_cookies_file.Size = New-Object System.Drawing.Size(105,15)
$radio_cookies_file.Text = "From cookie file:"
$radio_cookies_file.Enabled = $false

#Добавляем RadioButtons
$form_cookie.Controls.AddRange(@(
    $radio_cookies_browser,
    $radio_cookies_file
))

# Создаём список Браузеров
$comboBox_browser = New-Object System.Windows.Forms.ComboBox
$comboBox_browser.Location = New-Object System.Drawing.Point(110,15)
$comboBox_browser.Size = New-Object System.Drawing.Size(90,20)
$comboBox_browser.DropDownStyle = 'DropDownList'
$comboBox_browser.Items.Add("Brave") *>$null
$comboBox_browser.Items.Add("Chrome") *>$null
$comboBox_browser.Items.Add("Chromium") *>$null
$comboBox_browser.Items.Add("Edge") *>$null
$comboBox_browser.Items.Add("Firefox") *>$null
$comboBox_browser.Items.Add("Opera") *>$null
$comboBox_browser.Items.Add("Safari") *>$null
$comboBox_browser.Items.Add("Vivaldi") *>$null
$comboBox_browser.Items.Add("Whale") *>$null
$comboBox_browser.SelectedItem = "Firefox"
$comboBox_browser.Enabled = $false
$form_cookie.Controls.Add($comboBox_browser)

# Создаем кнопку Browse
$button_cookie_Browse = New-Object System.Windows.Forms.Button
$button_cookie_Browse.Location = New-Object System.Drawing.Point(120,49)
$button_cookie_Browse.Size = New-Object System.Drawing.Size(80,20)
$button_cookie_Browse.Text = "Browse..."
$button_cookie_Browse.TextAlign = "MiddleCenter"
$button_cookie_Browse.UseVisualStyleBackColor = $false
$button_cookie_Browse.BackColor = [System.Drawing.Color]::White
$button_cookie_Browse.ForeColor = [System.Drawing.Color]::Black
$button_cookie_Browse.TabIndex = 3
$button_cookie_Browse.Enabled = $false
$form_cookie.Controls.Add($button_cookie_Browse)

# Создаем кнопку OK
$button_cookie_OK = New-Object System.Windows.Forms.Button
$button_cookie_OK.Location = New-Object System.Drawing.Point(95,85)
$button_cookie_OK.Size = New-Object System.Drawing.Size(40,20)
$button_cookie_OK.Text = "OK"
$button_cookie_OK.TextAlign = "MiddleCenter"
$button_cookie_OK.UseVisualStyleBackColor = $false
$button_cookie_OK.BackColor = [System.Drawing.Color]::White
$button_cookie_OK.ForeColor = [System.Drawing.Color]::Black
$button_cookie_OK.TabIndex = 3
$form_cookie.Controls.Add($button_cookie_OK)

# Создаем кнопку Cancel
$button_cookie_cancel = New-Object System.Windows.Forms.Button
$button_cookie_cancel.Location = New-Object System.Drawing.Point(140,85)
$button_cookie_cancel.Size = New-Object System.Drawing.Size(60,20)
$button_cookie_cancel.Text = "Cancel"
$button_cookie_cancel.TextAlign = "MiddleCenter"
$button_cookie_cancel.UseVisualStyleBackColor = $false
$button_cookie_cancel.BackColor = [System.Drawing.Color]::White
$button_cookie_cancel.ForeColor = [System.Drawing.Color]::Black
$button_cookie_cancel.TabIndex = 4
$form_cookie.Controls.Add($button_cookie_cancel)

# Создаем CheckBox
$checkBox_cookie = New-Object System.Windows.Forms.CheckBox
$checkBox_cookie.Location = New-Object System.Drawing.Point(10,86)
$checkBox_cookie.Text = "Use Cookie"
$checkBox_cookie.AutoSize = $true
$checkBox_cookie.TabIndex = 2
$form_cookie.Controls.Add($checkBox_cookie)

#endregion

#region Создание форм Proxy

# Создаем форму Proxy
$form_proxy = New-Object System.Windows.Forms.Form
$form_proxy.Text = "Proxy Settings"
$form_proxy.Size = New-Object System.Drawing.Size(225,115)
$form_proxy.StartPosition = "CenterScreen"
$form_proxy.FormBorderStyle = 'FixedSingle' #
$form_proxy.MaximizeBox = $false
$form_proxy.MinimizeBox = $false
$form_proxy.BackColor = [System.Drawing.Color]::FromArgb(1,46,110)
$form_proxy.ForeColor = [System.Drawing.Color]::White
$form_proxy.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($pwshPath)

# Создаем текстовое поле Proxy Ip
$textBox_proxy_ip = New-Object System.Windows.Forms.TextBox
$textBox_proxy_ip.Location = New-Object System.Drawing.Point(10,20)
$textBox_proxy_ip.Size = New-Object System.Drawing.Size(130,25)
$textBox_proxy_ip.TabIndex = 0
$form_proxy.Controls.Add($textBox_proxy_ip)

# Создаем текстовое поле Proxy Port
$textBox_proxy_port = New-Object System.Windows.Forms.TextBox
$textBox_proxy_port.Location = New-Object System.Drawing.Point(150,20)
$textBox_proxy_port.Size = New-Object System.Drawing.Size(50,25)
$textBox_proxy_port.TabIndex = 1
$form_proxy.Controls.Add($textBox_proxy_port)

# Создаем кнопку OK
$button_OK = New-Object System.Windows.Forms.Button
$button_OK.Location = New-Object System.Drawing.Point(90,50)
$button_OK.Size = New-Object System.Drawing.Size(40,20)
$button_OK.Text = "OK"
$button_OK.TextAlign = "MiddleCenter"
$button_OK.UseVisualStyleBackColor = $false
$button_OK.BackColor = [System.Drawing.Color]::White
$button_OK.ForeColor = [System.Drawing.Color]::Black
$button_OK.TabIndex = 3
$form_proxy.Controls.Add($button_OK)

# Создаем кнопку Cancel
$button_cancel = New-Object System.Windows.Forms.Button
$button_cancel.Location = New-Object System.Drawing.Point(140,50)
$button_cancel.Size = New-Object System.Drawing.Size(60,20)
$button_cancel.Text = "Cancel"
$button_cancel.TextAlign = "MiddleCenter"
$button_cancel.UseVisualStyleBackColor = $false
$button_cancel.BackColor = [System.Drawing.Color]::White
$button_cancel.ForeColor = [System.Drawing.Color]::Black
$button_cancel.TabIndex = 4
$form_proxy.Controls.Add($button_cancel)

# Создаем CheckBox
$checkBox_proxy = New-Object System.Windows.Forms.CheckBox
$checkBox_proxy.Location = New-Object System.Drawing.Point(10,50)
$checkBox_proxy.Text = "Use proxy"
$checkBox_proxy.AutoSize = $true
$checkBox_proxy.TabIndex = 2
$form_proxy.Controls.Add($checkBox_proxy)

# Создаем Label Address
$label_Address = New-Object System.Windows.Forms.Label
$label_Address.Location = New-Object System.Drawing.Point(9,7)
$label_Address.Size = New-Object System.Drawing.Size(60,15)
$label_Address.Text = "Address"
$label_Address.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form_proxy.Controls.Add($label_Address)

# Создаем Label Port
$label_Port = New-Object System.Windows.Forms.Label
$label_Port.Location = New-Object System.Drawing.Point(149,7)
$label_Port.Size = New-Object System.Drawing.Size(60,15)
$label_Port.Text = "Port"
$label_Port.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form_proxy.Controls.Add($label_Port)

#endregion

#region Создание форм Runtimes

# Создаем форму Runtimes
$form_runtimes = New-Object System.Windows.Forms.Form
$form_runtimes.Text = "JS Runtimes Settings"
$form_runtimes.Size = New-Object System.Drawing.Size(225,150)
$form_runtimes.StartPosition = "CenterScreen"
$form_runtimes.FormBorderStyle = 'FixedSingle' #
$form_runtimes.MaximizeBox = $false
$form_runtimes.MinimizeBox = $false
$form_runtimes.BackColor = [System.Drawing.Color]::FromArgb(1,46,110)
$form_runtimes.ForeColor = [System.Drawing.Color]::White
$form_runtimes.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($pwshPath)


# Создаем CheckBox
$checkBox_runtime = New-Object System.Windows.Forms.CheckBox
$checkBox_runtime.Location = New-Object System.Drawing.Point(11,15)
$checkBox_runtime.Size = New-Object System.Drawing.Size(95,15)
$checkBox_runtime.Text = "JS Runtimes:"
$checkBox_runtime.AutoSize = $true
$checkBox_runtime.TabIndex = 2
$form_runtimes.Controls.Add($checkBox_runtime)

# Создаем CheckBox
$checkBox_components = New-Object System.Windows.Forms.CheckBox
$checkBox_components.Location = New-Object System.Drawing.Point(11,45)
$checkBox_components.Size = New-Object System.Drawing.Size(105,15)
$checkBox_components.Text = "Remote`nComponents:"
$checkBox_components.AutoSize = $true
$checkBox_components.TabIndex = 2
$form_runtimes.Controls.Add($checkBox_components)

# Создаём список JS runtimes
$comboBox_runtime = New-Object System.Windows.Forms.ComboBox
$comboBox_runtime.Location = New-Object System.Drawing.Point(110,14)
$comboBox_runtime.Size = New-Object System.Drawing.Size(90,20)
$comboBox_runtime.DropDownStyle = 'DropDownList'
$comboBox_runtime.Items.Add("deno") *>$null
$comboBox_runtime.Items.Add("node") *>$null
$comboBox_runtime.Items.Add("quickjs") *>$null
$comboBox_runtime.Items.Add("bun") *>$null
$comboBox_runtime.SelectedItem = "node"
$comboBox_runtime.Enabled = $false
$form_runtimes.Controls.Add($comboBox_runtime)

# Создаём список Remote Components
$comboBox_components = New-Object System.Windows.Forms.ComboBox
$comboBox_components.Location = New-Object System.Drawing.Point(110,49)
$comboBox_components.Size = New-Object System.Drawing.Size(90,20)
$comboBox_components.DropDownStyle = 'DropDownList'
$comboBox_components.Items.Add("ejs:npm") *>$null
$comboBox_components.Items.Add("ejs:github") *>$null
$comboBox_components.SelectedItem = "ejs:github"
$comboBox_components.Enabled = $false
$form_runtimes.Controls.Add($comboBox_components)

# Создаем кнопку OK
$button_runtime_OK = New-Object System.Windows.Forms.Button
$button_runtime_OK.Location = New-Object System.Drawing.Point(95,85)
$button_runtime_OK.Size = New-Object System.Drawing.Size(40,20)
$button_runtime_OK.Text = "OK"
$button_runtime_OK.TextAlign = "MiddleCenter"
$button_runtime_OK.UseVisualStyleBackColor = $false
$button_runtime_OK.BackColor = [System.Drawing.Color]::White
$button_runtime_OK.ForeColor = [System.Drawing.Color]::Black
$button_runtime_OK.TabIndex = 3
$form_runtimes.Controls.Add($button_runtime_OK)

# Создаем кнопку Cancel
$button_runtime_cancel = New-Object System.Windows.Forms.Button
$button_runtime_cancel.Location = New-Object System.Drawing.Point(140,85)
$button_runtime_cancel.Size = New-Object System.Drawing.Size(60,20)
$button_runtime_cancel.Text = "Cancel"
$button_runtime_cancel.TextAlign = "MiddleCenter"
$button_runtime_cancel.UseVisualStyleBackColor = $false
$button_runtime_cancel.BackColor = [System.Drawing.Color]::White
$button_runtime_cancel.ForeColor = [System.Drawing.Color]::Black
$button_runtime_cancel.TabIndex = 4
$form_runtimes.Controls.Add($button_runtime_cancel)

#endregion

#region Создание Основной Формы

# Создаем форму
$form = New-Object System.Windows.Forms.Form
$form.Text = "Video Download"
$form.Size = New-Object System.Drawing.Size(500,95)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle' #
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(1,46,110)
$form.ForeColor = [System.Drawing.Color]::White

# Создаем кнопку Cookie
$button_cookie = New-Object System.Windows.Forms.Button
$button_cookie.Location = New-Object System.Drawing.Point(50,0)
$button_cookie.Size = New-Object System.Drawing.Size(50,20)
$button_cookie.Text = "Cookie"
$button_cookie.TabIndex = 3
$form.Controls.Add($button_cookie)

# Создаем кнопку Update yt-dlp
$button_update = New-Object System.Windows.Forms.Button
$button_update.Location = New-Object System.Drawing.Point(175,0)
$button_update.Size = New-Object System.Drawing.Size(90,20)
$button_update.Text = "Update yt-dlp"
$button_update.TabIndex = 4
$form.Controls.Add($button_update)

# Создаем кнопку Save
$button_save = New-Object System.Windows.Forms.Button
$button_save.Location = New-Object System.Drawing.Point(265,0)
$button_save.Size = New-Object System.Drawing.Size(95,20)
$button_save.Text = "Save settings"
$button_save.TabIndex = 5
$form.Controls.Add($button_save)

# Создаем кнопку Help
$button_Help = New-Object System.Windows.Forms.Button
$button_Help.Location = New-Object System.Drawing.Point(0,40)
$button_Help.Size = New-Object System.Drawing.Size(40,17)
$button_Help.Text = "Help"
$button_Help.Font = New-Object System.Drawing.Font("Arial", 7)
$form.Controls.Add($button_Help)

# Создаем кнопку About Trim
$button_About_Trim = New-Object System.Windows.Forms.Button
$button_About_Trim.Location = New-Object System.Drawing.Point(40,40)
$button_About_Trim.Size = New-Object System.Drawing.Size(60,17)
$button_About_Trim.Text = "About Trim"
$button_About_Trim.Font = New-Object System.Drawing.Font("Arial", 7)
$form.Controls.Add($button_About_Trim)

# Создаем кнопку Links
$button_Links = New-Object System.Windows.Forms.Button
$button_Links.Location = New-Object System.Drawing.Point(100,40)
$button_Links.Size = New-Object System.Drawing.Size(40,17)
$button_Links.Text = "Links"
$button_Links.Font = New-Object System.Drawing.Font("Arial", 7)
$form.Controls.Add($button_Links)

# Создаем кнопку Runtimes
$button_runtimes = New-Object System.Windows.Forms.Button
$button_runtimes.Location = New-Object System.Drawing.Point(100,0)
$button_runtimes.Size = New-Object System.Drawing.Size(75,20)
$button_runtimes.Text = "JS runtimes"
$button_runtimes.TabIndex = 3
$form.Controls.Add($button_runtimes)

# Создаем текстовое поле
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20,20)
$textBox.Size = New-Object System.Drawing.Size(292,25)
$textBox.TabIndex = 0
$form.Controls.Add($textBox)
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($pwshPath)

# Создаем кнопку Paste
$button_paste = New-Object System.Windows.Forms.Button
$button_paste.Location = New-Object System.Drawing.Point(310,20)
$button_paste.Size = New-Object System.Drawing.Size(50,20)
$button_paste.Text = "Paste"
$button_paste.TabIndex = 1
$form.Controls.Add($button_paste)

# Создаем кнопку Reset
$button_reset = New-Object System.Windows.Forms.Button
$button_reset.Location = New-Object System.Drawing.Point(310,20)
$button_reset.Size = New-Object System.Drawing.Size(50,20)
$button_reset.Text = "Reset"
$button_reset.Visible = 0
$form.Controls.Add($button_reset)

# Создаем кнопку Debug
$button_debug = New-Object System.Windows.Forms.Button
$button_debug.Location = New-Object System.Drawing.Point(0,0)
$button_debug.Size = New-Object System.Drawing.Size(50,20)
$button_debug.Text = "Debug"
$button_debug.Visible = $false
$form.Controls.Add($button_debug)

# Создаем кнопку Proxy
$button_proxy = New-Object System.Windows.Forms.Button
$button_proxy.Location = New-Object System.Drawing.Point(0,0)
$button_proxy.Size = New-Object System.Drawing.Size(50,20)
$button_proxy.Text = "Proxy"
$button_proxy.TabIndex = 3
$form.Controls.Add($button_proxy)

# Создаем кнопку Search
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(370,14)
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = "Search"
$button.TabIndex = 2
$form.Controls.Add($button)

# Создаем кнопку Download
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(370,14)
$button1.Size = New-Object System.Drawing.Size(100,30)
$button1.Text = "Download"
$button1.Visible = 0
$form.Controls.Add($button1)

# Создаем первый ComboBox для Quality
$comboRes = New-Object System.Windows.Forms.ComboBox
$comboRes.Location = New-Object System.Drawing.Point(20,70)
$comboRes.Size = New-Object System.Drawing.Size(120,25)
$comboRes.DropDownStyle = 'DropDownList'  #
$comboRes.Visible = 0 #
$form.Controls.Add($comboRes)

# Создаем второй ComboBox для TBR
$comboTBR = New-Object System.Windows.Forms.ComboBox
$comboTBR.Location = New-Object System.Drawing.Point(160,70)
$comboTBR.Size = New-Object System.Drawing.Size(120,25)
$comboTBR.DropDownStyle = 'DropDownList'
$comboTBR.Visible = 0 #
$form.Controls.Add($comboTBR)

# Создаем первый ComboBox для Language
$comboLang = New-Object System.Windows.Forms.ComboBox
$comboLang.Location = New-Object System.Drawing.Point(20,115)
$comboLang.Size = New-Object System.Drawing.Size(120,25)
$comboLang.DropDownStyle = 'DropDownList'
$comboLang.Visible = 0 #
$form.Controls.Add($comboLang)

# Создаем Label1
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(59,50)
$label1.Size = New-Object System.Drawing.Size(60,15)
$label1.Text = "Quality:"
$label1.Visible = 0 #
$label1.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label1)

# Создаем Label2
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(185,50)
$label2.Size = New-Object System.Drawing.Size(80,15)
$label2.Text = "Total BitRate:"
$label2.Visible = 0 #
$label2.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label2)

# Создаем Label4
$label4 = New-Object System.Windows.Forms.Label
$label4.Location = New-Object System.Drawing.Point(409,50)
$label4.Size = New-Object System.Drawing.Size(80,20)
$label4.Text = "Size:"
$label4.Visible = 0 #
$label4.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label4)

# Создаем Label5
$label5 = New-Object System.Windows.Forms.Label
$label5.Location = New-Object System.Drawing.Point(380,68)
$label5.Size = New-Object System.Drawing.Size(80,25)
$label5.Text = "None"
$label5.TextAlign = 'MiddleCenter'
$label5.Visible = 0 #
$label5.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label5)

# Создаем CheckBox
$checkBox = New-Object System.Windows.Forms.CheckBox
$checkBox.Location = New-Object System.Drawing.Point(300,72)
$checkBox.Text = "Audio Only"
$checkBox.AutoSize = $true
$checkBox.Visible = $false
$form.Controls.Add($checkBox)

# Создаем Label7
$label7 = New-Object System.Windows.Forms.Label
$label7.Location = New-Object System.Drawing.Point(53,95)
$label7.Size = New-Object System.Drawing.Size(60,25)
$label7.Text = "Language:"
$label7.Visible = 0 #
$label7.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label7)

# Создаем Version_label
$label_version = New-Object System.Windows.Forms.Label
$label_version.Location = New-Object System.Drawing.Point(445,43)
$label_version.Size = New-Object System.Drawing.Size(80,15)
$label_version.Text = "v. $version"
$label_version.Visible = $true
$label_version.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label_version)

#region Обрезка по времени

# Создаем CheckBox
$checkBox_Trim = New-Object System.Windows.Forms.CheckBox
$checkBox_Trim.Location = New-Object System.Drawing.Point(157,117)
$checkBox_Trim.Text = "Trim by time"
$checkBox_Trim.AutoSize = $true
$checkBox_Trim.Visible = $True
$checkBox_Trim.CheckAlign = 'MiddleRight'
$form.Controls.Add($checkBox_Trim)

$timePicker_Start = New-Object System.Windows.Forms.DateTimePicker
$timePicker_Start.Location = New-Object System.Drawing.Point(250,115)
$timePicker_Start.Size = New-Object System.Drawing.Size(70,50)
$timePicker_Start.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$timePicker_Start.CustomFormat = "HH:mm:ss"
$timePicker_Start.ShowUpDown = $true
$timePicker_Start.Text = "00:00:00"
$timePicker_Start.Enabled = $false
$form.Controls.Add($timePicker_Start)

$label_Start = New-Object System.Windows.Forms.Label
$label_Start.Location = New-Object System.Drawing.Point(270,102)
$label_Start.Size = New-Object System.Drawing.Size(50,25)
$label_Start.Text = "Start"
$label_Start.Visible = 1 #
$label_Start.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label_Start)

$timePicker_End = New-Object System.Windows.Forms.DateTimePicker
$timePicker_End.Location = New-Object System.Drawing.Point(341,115)
$timePicker_End.Size = New-Object System.Drawing.Size(70,50)
$timePicker_End.Format = [System.Windows.Forms.DateTimePickerFormat]::Custom
$timePicker_End.CustomFormat = "HH:mm:ss"
$timePicker_End.ShowUpDown = $true
$timePicker_End.Text = "12:00:00"
$timePicker_End.Enabled = $false
$form.Controls.Add($timePicker_End)

$label_End = New-Object System.Windows.Forms.Label
$label_End.Location = New-Object System.Drawing.Point(361,102)
$label_End.Size = New-Object System.Drawing.Size(50,25)
$label_End.Text = "End"
$label_End.Visible = 1 #
$label_End.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label_End)

$label_Split = New-Object System.Windows.Forms.Label
$label_Split.Location = New-Object System.Drawing.Point(323,117)
$label_Split.Size = New-Object System.Drawing.Size(70,40)
$label_Split.Text = "—"
$label_Split.Visible = 1 #
$label_Split.Font = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label_Split)

#endregion

#endregion


#region Функции
#Проверка ссылки на TikTok
function Test-TikTokUrl {
    param (
        [string]$Url
    )
    $Url = $Url.ToLower()
    
    $TikTokDomains = @(
        'tiktok.com',
        'vm.tiktok.com',
        'vt.tiktok.com',
        'www.tiktok.com',
        'm.tiktok.com'
    )
    foreach ($Domain in $TikTokDomains) {
        if ($Url -match [regex]::Escape($Domain)) {
            return $true
        }
    }
    $script:is_tiktok = $true
    return $false
}

#Проверка ссылки на YouTube
function Test-YouTube {
    param (
        [string]$Url
    )
    $Url = $Url.ToLower()

    $YouTubeDomains = @(
        'youtube.com',
        'www.youtube.com',
        'm.youtube.com',
        'youtu.be',
        'music.youtube.com',
        'gaming.youtube.com',
        'youtu.be',
        'youtube.googleapis.com',
        'www.googleapis.com',
        'googlevideo.com',
        'ytimg.com',
        'i.ytimg.com',
        'img.youtube.com',
        'youtube-nocookie.com'
    )
    foreach ($Domain in $YouTubeDomains) {
        if ($Url -match [regex]::Escape($Domain)) {
            return $true
        }
    }
    
    return $false
}

#Выбор папки
function Folder-choose {

    param (
        [string]$text = ""
    )
    Add-Type -AssemblyName System.Windows.Forms
    
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $text
    $folderBrowser.ShowNewFolderButton = $false

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:selectedPath = $folderBrowser.SelectedPath
        return $script:selectedPath
    } else {
       if ($default -eq $true){return $downloadsPath} else {exit}
    }
}

#Функция для преобразования размера в читаемый формат
function Format-FileSize {
    param([int64]$Size)
    if ($Size -eq 0) { return "0 B" }
    $units = @("B", "KB", "MB", "GB", "TB")
    $i = 0
    $sizeDecimal = [decimal]$Size
    
    while ($sizeDecimal -ge 1024 -and $i -lt $units.Length - 1) {
        $sizeDecimal = $sizeDecimal / 1024
        $i++
    }
    
    return "{0:N2} {1}" -f $sizeDecimal, $units[$i]
}

#Функция для подсчёта объема в плейлиста
function Get-PlaylistSize {
    param(
        [object]$PlaylistJson,
        [string]$SelectedResolution,
        [bool]$AudioOnly
    )

    $totalSize = [double]0

    foreach ($entry in $PlaylistJson.entries) {
        $duration = [double]($entry.duration)

        if ($AudioOnly) {
            $bestFormat = $entry.formats | Where-Object {
                $_.vcodec -eq "none" -and
                $_.acodec -ne "none" -and
                $_.acodec -ne $null
            } | Sort-Object abr -Descending | Select-Object -First 1
        } else {
            $targetHeight = [int]($SelectedResolution -replace "p", "")
            $bestFormat = $entry.formats | Where-Object {
                $_.vcodec -ne "none" -and
                $_.height -le $targetHeight -and
                $_.height -ne $null
            } | Sort-Object tbr -Descending | Select-Object -First 1
        }

        if ($bestFormat) {
            if ($bestFormat.filesize_approx) {
                $totalSize += [double]$bestFormat.filesize_approx
            } elseif ($bestFormat.filesize) {
                $totalSize += [double]$bestFormat.filesize
            } elseif ($bestFormat.tbr -and $duration -gt 0) {
                $totalSize += ($bestFormat.tbr * 1000 / 8) * $duration
            }
        }
    }

    return [int64]$totalSize
}

#Показ уведомления
function Show-BalloonTip {
    param(
        [string]$Title = "B.U.R.A.N. Menu",
        [string]$Message = "Сообщение"
    )
    
    $cmd = @"
Add-Type -AssemblyName System.Windows.Forms; 
Add-Type -AssemblyName System.Drawing;
`$n=New-Object System.Windows.Forms.NotifyIcon;
`$n.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon((Get-Process -Id `$PID).Path);
`$n.Visible=`$true;
`$n.ShowBalloonTip(10000,'$($Title.Replace("'","''"))','$($Message.Replace("'","''"))',[System.Windows.Forms.ToolTipIcon]::None);
Start-Sleep -Seconds 10;
`$n.Dispose()
"@
    
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -EncodedCommand $encoded" -WindowStyle Hidden
}
#endregion

#region События

#region Links

#Событие нажатия на кнопку Links
$button_Links.Add_Click({
    $form_links.ShowDialog()
})

$button_link_github.Add_Click({
    Start-Process "https://github.com/Set0z/ytvd"
})

$button_link_donate.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "This feature is not available yet.",
        "Donate",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

#endregion

#region Cookie

#Событие нажатия на кнопку Cookie
$button_cookie.Add_Click({
    $form_cookie.ShowDialog()
})





#Событие открытия формы Cookie
$form_cookie.Add_Shown({
    $script:last_cookie_comboBox = $comboBox_browser.SelectedItem
    $script:last_cookie_check = $checkBox_cookie.Checked
    if($radio_cookies_browser.Checked){$script:last_radio_check = "browser"} elseif($radio_cookies_file.Checked){$script:last_radio_check = "file"}
    $script:last_cookie_file = $script:cookie_file
})

#Событие закрытия формы Cookie
$form_cookie.Add_FormClosed({
    $comboBox_browser.SelectedItem = $script:last_cookie_comboBox
    $checkBox_cookie.Checked = $script:last_cookie_check
    if($script:last_radio_check -eq "browser"){$radio_cookies_browser.Checked = $true } elseif($script:last_radio_check -eq "file"){$radio_cookies_file.Checked = $true}
    $script:cookie_file = $script:last_cookie_file
})

#Событие нажатия Cancel Cookie
$button_cookie_cancel.Add_Click({
    $comboBox_browser.SelectedItem = $script:last_cookie_comboBox
    $checkBox_cookie.Checked = $script:last_cookie_check
    if($script:last_radio_check -eq "browser"){$radio_cookies_browser.Checked = $true } elseif($script:last_radio_check -eq "file"){$radio_cookies_file.Checked = $true}
    $script:cookie_file = $script:last_cookie_file
    $form_cookie.Hide()
})





#Событие нажатия ОК Cookie
$button_cookie_OK.Add_Click({
    if($checkBox_cookie.Checked){
        $script:use_cookie = $true
        if($radio_cookies_browser.Checked){
            $script:use_cookie_file = $false
            $script:use_cookie_browser = $true
            $script:cookie_browser = $comboBox_browser.SelectedItem
        } elseif($radio_cookies_file.Checked){
            $script:use_cookie_browser = $false
            $script:use_cookie_file = $true
            $script:cookie_file = $script:cookie_file
        }
    } else {$script:use_cookie_browser = $false ; $script:use_cookie_file = $false ; $script:use_cookie = $false}
    #Write-Host "use_cookie=$($script:use_cookie), use_cookie_browser=$($script:use_cookie_browser), cookie_browser=$($script:cookie_browser), use_cookie_file=$($script:use_cookie_file), cookie_file=$($script:cookie_file)"
    $form_cookie.Hide()
})

#Событие нажатия Browse
$button_cookie_Browse.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
    $openFileDialog.Filter = "All files (*.*)|*.*"
    $openFileDialog.Title = "Select a cookie file"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:cookie_file = $openFileDialog.FileName
    }
})


#Событие галочки Use Cookies
$checkBox_cookie.Add_CheckedChanged({
    if ($checkBox_cookie.Checked) {
        $radio_cookies_browser.Enabled = $true
        $radio_cookies_file.Enabled = $true
        if($radio_cookies_browser.Checked){$comboBox_browser.Enabled = $true}else{$button_cookie_Browse.Enabled = $true}
    } else {
        $radio_cookies_browser.Enabled = $false
        $radio_cookies_file.Enabled = $false
        $comboBox_browser.Enabled = $false
        $button_cookie_Browse.Enabled = $false
    }
})

# Событие выбора From browser
$radio_cookies_browser.Add_CheckedChanged({
    if ($radio_cookies_browser.Checked) {
        $comboBox_browser.Enabled = $true
        $button_cookie_Browse.Enabled = $false
    }else{
        $comboBox_browser.Enabled = $false
        $button_cookie_Browse.Enabled = $true
    }
})

#endregion

#region Proxy

#Событие нажатия на кнопку Proxy
$button_proxy.Add_Click({
    $form_proxy.ShowDialog()
})

#Событие нажатия на кнопку OK
$button_OK.Add_Click({
    if($checkBox_proxy.Checked){
        $script:use_proxy = $true
        $script:proxy_address = $($textBox_proxy_ip.Text) + ":" +$($textBox_proxy_port.Text)
    } else {$script:use_proxy = $false}
    $form_proxy.Hide()
})

#Событие открытия формы Proxy
$form_proxy.Add_Shown({
    $script:last_proxy_check = $checkBox_proxy.Checked
    $script:last_proxy_ip = $textBox_proxy_ip.Text
    $script:last_proxy_port = $textBox_proxy_port.Text
})




#Событие закрытия формы Proxy
$form_proxy.Add_FormClosed({
    $checkBox_proxy.Checked = $script:last_proxy_check
    $textBox_proxy_ip.Text = $script:last_proxy_ip
    $textBox_proxy_port.Text = $script:last_proxy_port
})

#Событие нажатия на кнопку Proxy Cancel
$button_Cancel.Add_Click({
    $checkBox_proxy.Checked = $script:last_proxy_check
    $textBox_proxy_ip.Text = $script:last_proxy_ip
    $textBox_proxy_port.Text = $script:last_proxy_port
    $form_proxy.Hide()
})




#endregion

#region Runtimes

#Событие нажатия на кнопку Runtimes
$button_runtimes.Add_Click({
    $form_runtimes.ShowDialog()
})

$checkBox_runtime.Add_CheckedChanged({
    if($comboBox_runtime.Enabled){$comboBox_runtime.Enabled = $false}else{$comboBox_runtime.Enabled = $true}
})

$checkBox_components.Add_CheckedChanged({
    if($comboBox_components.Enabled){$comboBox_components.Enabled = $false}else{$comboBox_components.Enabled = $true}
})

#Событие открытия формы Runtimes
$form_runtimes.Add_Shown({
    $script:last_runtime_comboBox = $comboBox_runtime.SelectedItem
    $script:last_runtime_check = $checkBox_runtime.Checked

    $script:last_components_comboBox = $comboBox_components.SelectedItem
    $script:last_components_check = $checkBox_components.Checked
})

#Событие закрытия формы Runtimes
$form_runtimes.Add_FormClosed({
    $comboBox_runtime.SelectedItem = $script:last_runtime_comboBox
    $checkBox_runtime.Checked = $script:last_runtime_check

    $comboBox_components.SelectedItem = $script:last_components_comboBox
    $checkBox_components.Checked = $script:last_components_check
})

# Действие если выбран node и чекбокс включен
$comboBox_runtime.Add_SelectedIndexChanged({
    if ($checkBox_runtime.Checked -and $comboBox_runtime.SelectedItem -eq "node") {

        if (-not $script:node_installed) {
            $result = [System.Windows.Forms.MessageBox]::Show("Node.js is not installed. Do you want to install it?","Node.js",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                $raw_url = "https://nodejs.org/dist/latest/"
                $page = Invoke-WebRequest -Uri $raw_url
                $zip = ([regex]::Match($page.Content, 'node-v[\d.]+-win-x64\.zip')).Value
                $url = $raw_url + $zip

                $output = "$env:USERPROFILE\node.zip"
                $nodeDir = "$env:USERPROFILE\node"
                Invoke-WebRequest -Uri $url -OutFile $output
                Expand-Archive -Path $output -DestinationPath $nodeDir -Force

                $extracted = (Get-ChildItem $nodeDir -Directory)[0].FullName
                [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$extracted", "User")
                $env:PATH += ";$extracted"
                $script:node_installed = $true  # теперь сохранится глобально
            }
        }

    }
})

# Действие если выбран node и чекбокс включен
$checkBox_runtime.Add_CheckedChanged({
    if ($checkBox_runtime.Checked -and $comboBox_runtime.SelectedItem -eq "node") {

        if (-not $script:node_installed) {
            $result = [System.Windows.Forms.MessageBox]::Show("Node.js is not installed. Do you want to install it?","Node.js",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                $raw_url = "https://nodejs.org/dist/latest/"
                $page = Invoke-WebRequest -Uri $raw_url
                $zip = ([regex]::Match($page.Content, 'node-v[\d.]+-win-x64\.zip')).Value
                $url = $raw_url + $zip

                $output = "$env:USERPROFILE\node.zip"
                $nodeDir = "$env:USERPROFILE\node"
                Invoke-WebRequest -Uri $url -OutFile $output
                Expand-Archive -Path $output -DestinationPath $nodeDir -Force

                $extracted = (Get-ChildItem $nodeDir -Directory)[0].FullName
                [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$extracted", "User")
                $env:PATH += ";$extracted"
                $script:node_installed = $true  # теперь сохранится глобально
            }
        }

    }
})


#Событие нажатия Cancel Runtimes
$button_runtime_cancel.Add_Click({
    $comboBox_runtime.SelectedItem = $script:last_runtime_comboBox
    $checkBox_runtime.Checked = $script:last_runtime_check

    $comboBox_components.SelectedItem = $script:last_components_comboBox
    $checkBox_components.Checked = $script:last_components_check
    $form_runtimes.Hide()
})

#Событие нажатия ОК Runtimes
$button_runtime_OK.Add_Click({
    if($checkBox_runtime.Checked){
        $script:use_runtimes = $true
        $script:selected_runtime = $comboBox_runtime.SelectedItem
    }
    if($checkBox_components.Checked){
        $script:use_components = $true
        $script:selected_components = $comboBox_components.SelectedItem
    }
    $form_runtimes.Hide()
})

#endregion

#region Update

#Событие нажатия на кнопку Update yt-dlp
$button_update.Add_Click({
    $button_update.Text = "Updating..."
    try{
        $ytDlpUpdateResult =  & yt-dlp -U 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw $ytDlpUpdateResult
        }
        if ($ytDlpUpdateResult -match 'yt-dlp is up to date') {
            [System.Windows.Forms.MessageBox]::Show(
                "yt-dlp is up to date!",
                "ytvd",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            ) *>$null
        }elseif($ytDlpUpdateResult -match 'Updated'){
            [System.Windows.Forms.MessageBox]::Show(
                "$(($ytDlpUpdateResult -split "`n") | Where-Object { $_ -match 'Updated' })",
                "ytvd",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            ) *>$null
        }
    }catch{
        [System.Windows.Forms.MessageBox]::Show(
        "$_",
        "ytvd Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
        ) *>$null

    }
    $button_update.Text = "Update yt-dlp"
})

#endregion

#region Form

#Событие нажатия на кнопку Help
$button_Help.Add_Click({
    if($PSCulture -eq "ru-RU"){
        [System.Windows.Forms.MessageBox]::Show(
        "Если при поиске или скачивании видео с возрастными ограничениями на YouTube возникает ошибка, выполните следующие шаги:

    1. НАСТРОЙКА COOKIES:
       - Откройте раздел Cookie и включите опцию 'Use Cookie'
       - Выберите браузер, в котором вы авторизованы на YouTube
       - ВАЖНО: Некоторые браузеры требуют быть закрытыми перед считыванием cookies
       - Убедитесь, что вы авторизованы на YouTube в выбранном браузере

    2. НАСТРОЙКА NODE.JS:
       - Node.js необходим вместе с cookies для скачивания видео с возрастными ограничениями
       - Скачайте и установите Node.js с сайта: https://nodejs.org или разрешите ytvd установить его автоматически
       - После ручной установки перезапустите приложение
       - Перейдите в JS Runtimes и включите Node.js

    Для поиска и скачивания видео с возрастными ограничениями необходимо включить и Cookies, и Node.js.",
        "Справка",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    }else{
        [System.Windows.Forms.MessageBox]::Show(
        "If you encounter an error searching or downloading Age-Restricted videos from YouTube, follow these steps:

    1. COOKIES SETUP:
       - Open Cookie and enable the 'Use Cookie' option
       - Select the browser in which you are logged in to YouTube
       - IMPORTANT: Some browsers require to be closed before cookies can be read
       - Make sure you are logged in to YouTube in the selected browser

    2. NODE.JS SETUP:
       - Node.js is required together with cookies to download Age-Restricted videos
       - Download and install Node.js from: https://nodejs.org or agree to let ytvd install them for you
       - After installation, restart this application if you install it manualy
       - Go to JS Runtimes and enable Node.js

    Both Cookies and Node.js must be enabled to download or search Age-Restricted videos.",
            "Help",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
})

#Событие нажатия на кнопку About Trim
$button_About_Trim.Add_Click({
    if($PSCulture -eq "ru-RU"){
        [System.Windows.Forms.MessageBox]::Show(
        "Функция 'Trim by time' позволяет вырезать нужный фрагмент из видео или аудио.

КАК ЭТО РАБОТАЕТ:
   - Сначала будет скачано ПОЛНОЕ видео или аудио
   - Затем из него автоматически вырежется указанный вами фрагмент
   - Исходный файл будет заменён обрезанным

ИСПОЛЬЗОВАНИЕ:
   - Включите 'Trim by time' и укажите время начала (Start) и конца (End) нужного фрагмента
   - Работает как с видео, так и с аудио

ВАЖНО: Время обработки зависит от длины исходного файла и мощности вашего процессора.",
        "Справка — Обрезка по времени",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }else{
        [System.Windows.Forms.MessageBox]::Show(
        "The 'Trim by time' feature allows you to extract a specific fragment from a video or audio file.

HOW IT WORKS:
   - The FULL video or audio will be downloaded first
   - Then the specified fragment will be automatically cut from it
   - The original file will be replaced with the trimmed one

USAGE:
   - Enable 'Trim by time' and set the Start and End time of the desired fragment
   - Works with both video and audio

NOTE: Processing time depends on the length of the original file and your CPU performance.",
        "Help — Trim by time",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
})

#Событие нажатия на кнопку Paste
$button_paste.Add_Click({
    $textBox.Text = [System.Windows.Forms.Clipboard]::GetText()
})

#Событие нажатия на кнопку Reset
$button_reset.Add_Click({
    $textBox.Text = ""
    $button.Visible = $true
    $button1.Visible = $false
    $button_reset.Visible = $false
    $button_paste.Visible = $true
    $button_proxy.Visible = $true
    $button_runtimes.Visible = $true
    $button_debug.Visible = $false
    $form.Size = New-Object System.Drawing.Size(500,95)
    $textBox.Enabled = $true
    $comboLang.Visible = $false
    $label7.Visible = $false
    $comboRes.Visible = $false
    $comboTBR.Visible = $false
    $label1.Visible = $false
    $label2.Visible = $false
    $label4.Visible = $false
    $label5.Visible = $false
    $button_update.Visible = $true
    $button_cookie.Visible = $true
    $button_Help.Visible = $true
    $button_save.Visible = $true
    $label_version.Visible = $true
    $checkBox.Checked = $false
    $form.Text = "Video Download"
    $script:jsonContent = $null
    $script:is_playlist = $false

    $base = [datetime]::Today
    $timePicker_End.MinDate = $base
    $timePicker_End.MaxDate = $base.AddDays(1)
    $timePicker_End.Value = $base
})

#Событие нажатия на кнопку Search
$button.Add_Click({
    $script:url = $textBox.Text
    if($script:url -eq ""){if($PSCulture -eq "ru-RU"){[System.Windows.Forms.MessageBox]::Show("Пустая ссылка","Ошибка",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}else{[System.Windows.Forms.MessageBox]::Show("Empty link","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null} ; return}
    if((-not (Test-TikTokUrl -Url $script:url)) -and (-not (Test-YouTube -Url $script:url))){if($PSCulture -eq "ru-RU"){[System.Windows.Forms.MessageBox]::Show("Неподдерживаемая ссылка","Ошибка",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}else{[System.Windows.Forms.MessageBox]::Show("Unsupported link","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null} ; return}
    if ($script:url -ne "") {
        $button.Text = "Searching..."
    } else {
        [System.Windows.Forms.MessageBox]::Show("URL is empry!")
        return
    }

    if (Test-Path $env:TEMP\videos.json) {
        Remove-Item -Path "$env:TEMP\videos.json"
    }


    try {
        $exePath = if ($script:yt_dlp_error -eq $true) { $script:yt_dlp_path } else { "yt-dlp.exe" }

        $arguments = @("--dump-single-json", "--no-warnings")

        if ($script:use_proxy) {
            $arguments += "--proxy", "$($script:proxy_address)"
        }

        if ($script:use_cookie) {
            if ($script:use_cookie_browser) {
                $arguments += "--cookies-from-browser", "$script:cookie_browser"
            } elseif ($script:use_cookie_file) {
                $arguments += "--cookies", "$script:cookie_file"
            }
        }

        if($script:use_runtimes){$arguments += "--js-runtimes","$script:selected_runtime"}

        if($script:use_components){$arguments += "--remote-components","$script:selected_components"}

        $arguments += $script:url

        & $exePath @arguments >> "$env:TEMP\videos.json" 2>$env:TEMP\yt_errors.txt 

        if ($LASTEXITCODE -ne 0) {
            $lastError = Get-Content "$env:TEMP\yt_errors.txt" -Raw
            $clean = ($lastError -split "`r?`n")[0] -replace '(\.)\s+Use .*$', '$1'
            throw $clean
        }
    }
    catch {
        $button.Text = "Search"
        [System.Windows.Forms.MessageBox]::Show(
            "$($_)",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        if($($_) -match "Requested format is not available"){
        [System.Windows.Forms.MessageBox]::Show(
            "Try enable JS Runtimes",
            "Tip",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        }
        Clear-Host
        $textBox.Text = ""
        return
    }


    $button_proxy.Visible = $false
    $button_runtimes.Visible = $false
    $button_update.Visible = $false
    $button_cookie.Visible = $false
    $button_Help.Visible = $false
    $button_save.Visible = $false
    $label_version.Visible = $false
    $button_debug.Visible = $true
    $checkBox.Visible = $true

    $jsonContent = Get-Content -Path "$env:TEMP\videos.json" -Raw | ConvertFrom-Json

    $script:videos = @()
    $script:audios = @()

    if (Test-TikTokUrl -Url $script:url){
        
        foreach ($format in $jsonContent.formats) {

            if ($format.ext -eq "mp4" -and $format.vcodec -ne "none") {
                $videoInfo = [PSCustomObject]@{
                    ID = $format.format_id
                    Resolution = $format.resolution
                    Size = if ($format.filesize) { Format-FileSize $format.filesize } else { "Unknown" }
                    Raw_size = $format.filesize
                    TBR = if ($format.tbr) { "{0:N2} kbps" -f $format.tbr } else { "Unknown" }
                    Quality = if ($format.quality) { $format.quality } else { "0" }
                    FormatNote = $format.resolution
                    Width = $format.width
                    Height = $format.height
                }
                $script:videos += $videoInfo
            }
        }

        $encoded_title = $jsonContent.title
        $encoded_chanel = $jsonContent.channel
        $likes = $jsonContent.like_count
        Add-Type -AssemblyName System.Web
        $video_title = [System.Web.HttpUtility]::HtmlDecode($encoded_title)
        $chanel_title = [System.Web.HttpUtility]::HtmlDecode($encoded_chanel)
        $form.Text = $encoded_chanel + " | "+$video_title + " | " + $likes + " likes"
        
        Remove-Item -Path "$env:TEMP\videos.json"
        
        if ($script:debug -eq $true){ $script:videos | Format-Table | Out-Host }
        $comboRes.Items.Clear()

        $sortedResolutions = $script:videos | Select-Object -ExpandProperty Resolution | Sort-Object @{
            Expression = {
                # Извлекаем ширину (первое число из "1080x1920")
                if ($_ -match '(\d+)x\d+') { 
                    [int]$matches[1] 
                } else { 
                    0 
                }
            }
            Descending = $true
        } -Unique
        $comboRes.Items.AddRange($sortedResolutions)

        $form.Size = New-Object System.Drawing.Size(500,140)

        $checkBox.Visible = $false
        $button.Text = "Search"
        $button.Visible = 0
        $button1.Visible = 1
        $label1.Visible = 1
        $label2.Visible = 1
        $label4.Visible = 1
        $label5.Visible = 1
        $comboRes.Visible = 1
        $comboTBR.Visible = 1
        $priority = @("1920x1080", "1280x720", "1080x1920", "720x1280","640x1136","576x1024","480x854","360x640")

        foreach ($res in $priority) {
            if ($comboRes.Items -contains $res) {
               $comboRes.SelectedItem = $res
                break
            }
        }

        $textBox.Enabled = $false
        $button_paste.Visible = $false
        $button_reset.Visible = $true

    } elseif(Test-YouTube -Url $script:url) {
        
        if($jsonContent._type -eq "playlist"){

            $script:is_playlist = $true
            $script:jsonContent = $jsonContent

            $encoded_title = $jsonContent.title
            $encoded_chanel = $jsonContent.channel
            $views = $jsonContent.view_count
            Add-Type -AssemblyName System.Web
            $video_title = [System.Web.HttpUtility]::HtmlDecode($encoded_title)
            $chanel_title = [System.Web.HttpUtility]::HtmlDecode($encoded_chanel)
            $form.Text = "PLAYLIST | "+ $video_title + " | " + $views + " views"
            Remove-Item -Path "$env:TEMP\videos.json"

            $maxPlaylistHeight = 0

            foreach ($entry in $jsonContent.entries) {
                $videoFormats = $entry.formats | Where-Object {
                    $_.vcodec -ne "none" -and $_.height -ne $null
                }

                if ($videoFormats) {
                    $maxHeight = ($videoFormats | Measure-Object -Property height -Maximum).Maximum

                    if ($maxHeight -gt $maxPlaylistHeight) {
                        $maxPlaylistHeight = $maxHeight
                    }
                }
            }

            $maxPlaylistHeight = [int]$maxPlaylistHeight
            $maxHeightStr = "$($maxPlaylistHeight)p"
            $standardResolutions = @("144p", "240p", "360p", "480p", "720p", "1080p", "1440p", "2160p")
            $resolutionsToAdd = $standardResolutions | Where-Object {[int]($_ -replace "p", "") -le $maxPlaylistHeight} | Sort-Object { [int]($_ -replace "p", "") } -Descending
            $comboRes.Items.Clear()
            $comboRes.Items.AddRange($resolutionsToAdd)
            $comboRes.SelectedItem = $maxHeightStr

            $checkBox.Visible = $true

            $totalBytes = Get-PlaylistSize -PlaylistJson $jsonContent -SelectedResolution $comboRes.SelectedItem -AudioOnly $checkBox.Checked
            $label5.Text = "$(Format-FileSize $totalBytes)"

            $button.Text = "Search"
            $button.Visible = $false
            $button1.Visible = $true
            $label1.Visible = $true
            $label4.Visible = $true
            $label4.Text = "Total Size:"
            $label4.Location = New-Object System.Drawing.Point(395,50)
            $label5.Visible = $true
            $comboRes.Visible = $true
            $textBox.Enabled = $false
            $button_paste.Visible = $false
            $button_reset.Visible = $true

            $form.Size = New-Object System.Drawing.Size(500,140)

        }else{

            $duration = $jsonContent.duration
            $ts = [TimeSpan]::FromSeconds($duration)

            if ($ts.Hours -gt 0) {
                $timePicker_End.Value = [datetime]::Today.AddSeconds($duration)
                $timePicker_End.CustomFormat = "HH:mm:ss"
                $timePicker_Start.CustomFormat = "HH:mm:ss"
                $timePicker_End.MaxDate = [datetime]::Today.AddSeconds($duration)
            } else {
                $timePicker_End.Value = [datetime]::Today.AddSeconds($duration)
                $timePicker_End.CustomFormat = "mm:ss"
                $timePicker_Start.CustomFormat = "mm:ss"
                $timePicker_End.MaxDate = [datetime]::Today.AddSeconds($duration)
            }

            foreach ($format in $jsonContent.formats) {

                if ($format.ext -eq "mp4" -and $format.vcodec -ne "none" -and $format.format_note -and $format.format_note -ne "(original)" -and $format.format_note -ne "(default)") {
                    $videoInfo = [PSCustomObject]@{
                        ID = $format.format_id
                        Resolution = $format.resolution
                        Size = if ($format.filesize_approx) { Format-FileSize $format.filesize_approx } else { "Unknown" }
                        Raw_size = $format.filesize_approx
                        TBR = if ($format.tbr) { "{0:N2} kbps" -f $format.tbr } else { "Unknown" }
                        Quality = if ($format.quality) { $format.quality } else { "0,0" }
                        FormatNote = $format.format_note
                        Width = $format.width
                        Height = $format.height
                        FPS = $format.fps
                    }
                    $script:videos += $videoInfo
                }
            
                if ($format.ext -eq "m4a" -and $format.vcodec -eq "none" -and $format.acodec -like "mp4a*") {
                    $audioInfo = [PSCustomObject]@{
                        ID = $format.format_id
                        Size = if ($format.filesize_approx) { Format-FileSize $format.filesize_approx } else { "Unknown" }
                        Raw_size = $format.filesize_approx
                        TBR = if ($format.tbr) { "{0:N2} kbps" -f $format.tbr } else { "Unknown" }
                        Language = if ($format.language) { $format.language } else { "Unknown" }
                        FormatNote = $format.format_note.Split(",")[0].Trim()
                        ASR = if ($format.asr) { "{0} Hz" -f $format.asr } else { "Unknown" }
                        AudioChannels = if ($format.audio_channels) { $format.audio_channels } else { "Unknown" }
                    }
                    $script:audios += $audioInfo
                }
            }
    
            $encoded_title = $jsonContent.title
            $encoded_chanel = $jsonContent.channel
            $likes = $jsonContent.like_count
            Add-Type -AssemblyName System.Web
            $video_title = [System.Web.HttpUtility]::HtmlDecode($encoded_title)
            $script:video_title_ballon = $video_title
            $chanel_title = [System.Web.HttpUtility]::HtmlDecode($encoded_chanel)
            $form.Text = $encoded_chanel + " | "+$video_title + " | " + $likes + " likes"
        
            Remove-Item -Path "$env:TEMP\videos.json"
    
            if ($script:debug -eq $true){
            $script:audios | Format-Table | Out-Host
            $script:videos | Format-Table | Out-Host
            }
    
            $comboRes.Items.Clear()
            $comboTBR.Items.Clear()
            $comboLang.Items.Clear()
        
            $sortedResolutions = $script:videos | Select-Object -ExpandProperty FormatNote | Sort-Object @{
                Expression = {
                    if ($_ -match '(\d+)p') { [int]$matches[1] } else { 0 }
                }
                Descending = $true
            }, @{
                Expression = {
                    if ($_ -match 'HDR') { 2 } 
                    elseif ($_ -match '60') { 1 }
                    else { 0 }
                }
                Descending = $true
            } -Unique
        
            $comboRes.Items.AddRange($sortedResolutions)
    
            if ($script:audios | Where-Object { $_.id -eq "140-0" }) {
                $script:multiple_audio = $true
                $form.Size = New-Object System.Drawing.Size(500,185)
                $comboLang.Visible = $true
                $label7.Visible = $true
                $comboLang.Items.AddRange(($script:audios | Select-Object -ExpandProperty FormatNote | Sort-Object -Unique -Descending))
                $priority = "original"
                foreach ($res in $priority) {
                    $match = $comboLang.Items | Where-Object { 
                        $_ -match "\b$res\b" -or 
                        $_ -like "*$res*" -and $_ -notmatch "[a-zA-Z]$res" -and $_ -notmatch "$res[a-zA-Z]"
                    }
                
                    if ($match) {
                        $comboLang.SelectedItem = $match
                        break
                    }
                }
        } else { $form.Size = New-Object System.Drawing.Size(500,185) }


        $button.Text = "Search"
        $button.Visible = 0
        $button1.Visible = 1
        $label1.Visible = 1
        $label2.Visible = 1
        $label4.Visible = 1
        $label5.Visible = 1
        $comboRes.Visible = 1
        $comboTBR.Visible = 1
        $priority = @("1080p60","1080p","720p60","720p","480p","360p","240p","144p")

        foreach ($res in $priority) {
            if ($comboRes.Items -contains $res) {
               $comboRes.SelectedItem = $res
                break
            }
        }

        $textBox.Enabled = $false
        $button_paste.Visible = $false
        $button_reset.Visible = $true
        }}

        if(-not $script:multiple_audio){
            $form.Size = New-Object System.Drawing.Size(500,185)
            $checkBox_Trim.Location = New-Object System.Drawing.Point(17,117)
            $timePicker_Start.Location = New-Object System.Drawing.Point(110,115)
            $label_Start.Location = New-Object System.Drawing.Point(130,102)
            $timePicker_End.Location = New-Object System.Drawing.Point(201,115)
            $label_End.Location = New-Object System.Drawing.Point(221,102)
            $label_Split.Location = New-Object System.Drawing.Point(183,117)
        }
})

#Событие нажатия на кнопку Download
$button1.Add_Click({

    if ($IsRemoteInvocation -eq $true) {
        Folder-choose -text "Select video download location"
    }

    $button1.Text = "Downloading..."
    $button1.Enabled = $false

    if($script:is_playlist){
        $selectedRes = $comboRes.SelectedItem -replace "p", ""
        $button1.Text = "Downloading..."
        $button_reset.Enabled = $false 
        $button_debug.Visible = $false
        Start-Sleep -Seconds 1

        $proc = New-Object System.Diagnostics.Process

        $proc.StartInfo.FileName = if ($script:yt_dlp_error -eq $true){$script:yt_dlp_path} else {'yt-dlp.exe'}

        $args = @()

        if ($script:yt_dlp_error -eq $true) {
            $args += '--ffmpeg-location'
            $args += "`"$script:ffmpeg_path`""
        }

        if ($IsRemoteInvocation -eq $true) {
            $args += '-P'
            $args += "`"$script:selectedPath`""
        }

        if ($script:use_proxy) {$args += "--proxy", "$($script:proxy_address)"}

        if ($script:use_runtimes) {$args += "--js-runtimes", "$script:selected_runtime"}

        if ($script:use_components) {$args += "--remote-components", "$script:selected_components"}

        if ($script:use_cookie) {
            if ($script:use_cookie_browser) {
                $args += "--cookies-from-browser", "$($script:cookie_browser)"
            } elseif ($script:use_cookie_file) {
                $args += "--cookies", "`"$($script:cookie_file)`""
            }
        }

        if ($checkBox.Checked) {
            $args += "-f", "140"
        }else{
            $args += "-f", "bestvideo[height<=$($selectedRes)]+bestaudio/best[height<=$($selectedRes)]"
        }

        $args += "-o", "%(title)s.%(ext)s"
        $args += "--merge-output-format ", "mp4"
        $args += $script:url
        $proc.StartInfo.Arguments = $args -join ' '

        $proc.StartInfo.UseShellExecute = $false
        $proc.StartInfo.RedirectStandardOutput = $true
        $proc.StartInfo.RedirectStandardError = $true
        $proc.StartInfo.CreateNoWindow = $true
        $proc.Start() | Out-Null

        
        #Clear-Host
        while (-not $proc.HasExited -or -not $proc.StandardOutput.EndOfStream) {
            if (-not $proc.StandardOutput.EndOfStream) {
                $line = $proc.StandardOutput.ReadLine()
    
                if ($line) {
                if ($line -match "Destination" -or $line -match "\[Merger\]" -or $line -match "\[FixupM4a\]" -or $line -match "Deleting" -or $line -match "has already been downloaded") {
                    $bytes = [System.Text.Encoding]::GetEncoding(866).GetBytes($line)
                    $lineCP1251 = [System.Text.Encoding]::GetEncoding(1251).GetString($bytes)
                    Write-Host $lineCP1251
                } else {
                    Write-Host $line
                }
                }
            } else {
                Start-Sleep -Milliseconds 50
            }
        }

        $proc.WaitForExit()
        Write-Host "Downloaded!"
        $button1.Text = "Download"
        Clear-Host
        
        #[System.Media.SystemSounds]::Exclamation.Play()
        Show-BalloonTip -Title "ytvd" -Message "Downloaded!`n $($script:video_title_ballon)"

        $button.Visible = 1
        $button1.Visible = 0
        $button_reset.Enabled = $true
        $button_proxy.Visible = $true
        $button_runtimes.Visible = $true
        $button_debug.Visible = $false
        $checkBox.Visible = $false
        $comboRes.Visible = 0
        $comboTBR.Visible = 0
        $checkBox.Checked = $false
        $label1.Visible = 0
        $label2.Visible = 0
        $label4.Visible = 0
        $label5.Visible = 0
        $textBox.Enabled = $true
        $button_paste.Visible = 1
        $button_reset.Visible = 0
        $button_update.Visible = $true
        $button_cookie.Visible = $true
        $button_Help.Visible = $true
        $button_save.Visible = $true
        $label_version.Visible = $true
        $form.Text = "Video download"
        $textBox.Text = ""
    
        $form.Size = New-Object System.Drawing.Size(500,95)
    }else{
        if (Test-TikTokUrl -Url $script:url){
            $selectedRes = $comboRes.SelectedItem
            $id = $script:videos | Where-Object { $_.Resolution -ieq $selectedRes } |Select-Object -ExpandProperty ID | Sort-Object -Unique -Descending
            $button1.Text = "Downloading..."
            $button_reset.Enabled = $false 
            $button_debug.Visible = $false
            Start-Sleep -Seconds 1

            $proc = New-Object System.Diagnostics.Process
        
            $proc.StartInfo.FileName = if ($script:yt_dlp_error -eq $true){$script:yt_dlp_path} else {'yt-dlp.exe'}

            $args = @()

            if ($script:yt_dlp_error -eq $true) {
                $args += '--ffmpeg-location'
                $args += "`"$script:ffmpeg_path`""
            }

            if ($IsRemoteInvocation -eq $true) {
                $args += '-P'
                $args += "`"$script:selectedPath`""
            }

            if ($script:use_proxy) {$arguments += "--proxy", "$($script:proxy_address)"}

            if ($script:use_runtimes) {$arguments += "--js-runtimes", "$script:selected_runtime"}

            if ($script:use_components) {$arguments += "--remote-components", "$script:selected_components"}

            if ($script:use_cookie) {
                if ($script:use_cookie_browser) {
                    $arguments += "--cookies-from-browser", "$($script:cookie_browser)"
                } elseif ($script:use_cookie_file) {
                    $arguments += "--cookies", "`"$($script:cookie_file)`""
                }
            }

            $args += '-f'
            $args += $id
            $args += $script:url
            $proc.StartInfo.Arguments = $args -join ' '

            $proc.StartInfo.UseShellExecute = $false
            $proc.StartInfo.RedirectStandardOutput = $true
            $proc.StartInfo.RedirectStandardError = $true
            $proc.StartInfo.CreateNoWindow = $true
            $proc.Start() | Out-Null

            while (-not $proc.HasExited -or -not $proc.StandardOutput.EndOfStream) {
                if (-not $proc.StandardOutput.EndOfStream) {
                    $line = $proc.StandardOutput.ReadLine()
    
                    if ($line) {
                    if ($line -match "Destination" -or $line -match "\[Merger\]" -or $line -match "Deleting" -or $line -match "has already been downloaded") {
                        $bytes = [System.Text.Encoding]::GetEncoding(866).GetBytes($line)
                        $lineCP1251 = [System.Text.Encoding]::GetEncoding(1251).GetString($bytes)
                        Write-Host $lineCP1251
                    } else {
                        Write-Host $line
                    }
                    }
                } else {
                    Start-Sleep -Milliseconds 50
                }
            }

            $proc.WaitForExit()
            Write-Host "Downloaded!"
            $button1.Text = "Download"
            Clear-Host
        
            #[System.Media.SystemSounds]::Exclamation.Play()
            Show-BalloonTip -Title "ytvd" -Message "Downloaded!`n $($script:video_title_ballon)"

            $button.Visible = 1
            $button1.Visible = 0
            $button_reset.Enabled = $true
            $button_proxy.Visible = $true
            $button_runtimes.Visible = $true
            $button_debug.Visible = $false
            $checkBox.Visible = $false
            $comboRes.Visible = 0
            $comboTBR.Visible = 0
            $checkBox.Checked = $false
            $label1.Visible = 0
            $label2.Visible = 0
            $label4.Visible = 0
            $label5.Visible = 0
            $textBox.Enabled = $true
            $button_paste.Visible = 1
            $button_reset.Visible = 0
            $button_update.Visible = $true
            $button_cookie.Visible = $true
            $button_Help.Visible = $true
            $button_save.Visible = $true
            $label_version.Visible = $true
            $form.Text = "Video download"
            $textBox.Text = ""
    
            $form.Size = New-Object System.Drawing.Size(500,95)

        } else {
            $selectedRes = $comboRes.SelectedItem
            $selectedTBR = $comboTBR.SelectedItem
            $id = $script:videos | Where-Object { ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty ID | Sort-Object -Unique -Descending
            $audio_id = $script:audios | Where-Object { $_.FormatNote -eq $script:selectedLang } | Select-Object -ExpandProperty ID
            $button1.Text = "Downloading..."
            $button_reset.Enabled = $false 
            $button_debug.Visible = $false
            Start-Sleep -Seconds 1
        
            $proc = New-Object System.Diagnostics.Process
            $proc.StartInfo.FileName = if ($script:yt_dlp_error -eq $true) { $script:yt_dlp_path } else { "yt-dlp.exe" }

            $arguments = @()

            # Output path (Remote Invocation)
            if ($IsRemoteInvocation -eq $true) {$arguments += "-P", "`"$script:selectedPath`""}

            # ffmpeg path
            if ($script:yt_dlp_error -eq $true) {$arguments += "--ffmpeg-location", "`"$script:ffmpeg_path`""}

            # Proxy
            if ($script:use_proxy) {$arguments += "--proxy", "$($script:proxy_address)"}

            # JS Runtimes
            if ($script:use_runtimes) {$arguments += "--js-runtimes", "$script:selected_runtime"}

            # Remote Components
            if ($script:use_components) {$arguments += "--remote-components", "$script:selected_components"}

            # Cookies
            if ($script:use_cookie) {
                if ($script:use_cookie_browser) {
                    $arguments += "--cookies-from-browser", "$($script:cookie_browser)"
                } elseif ($script:use_cookie_file) {
                    $arguments += "--cookies", "`"$($script:cookie_file)`""
                }
            }

            # Format selection
            if ($checkBox.Checked) {
                # Audio only
                if ($script:multiple_audio) {
                    $arguments += "-f", "$audio_id"
                } else {
                    $arguments += "-f", "140"
                }
            } else {
                # Video + Audio
                if ($script:multiple_audio) {
                    $arguments += "-f", "$id+$audio_id"
                } else {
                    $arguments += "-f", "$id+140"
                }
            }

            $arguments += "-o", "%(title)s.%(ext)s"
            $arguments += "$script:url"

            $proc.StartInfo.Arguments = $arguments -join " "
            $proc.StartInfo.UseShellExecute = $false
            $proc.StartInfo.RedirectStandardOutput = $true
            $proc.StartInfo.RedirectStandardError = $true
            $proc.StartInfo.CreateNoWindow = $true

            $proc.Start() | Out-Null

            Clear-Host
            while (-not $proc.HasExited -or -not $proc.StandardOutput.EndOfStream) {
                if (-not $proc.StandardOutput.EndOfStream) {
                    $line = $proc.StandardOutput.ReadLine()
    
                    if ($line) {
                        if ($line -match "Destination" -or $line -match "\[Merger\]" -or $line -match "\[FixupM4a\]" -or $line -match "Deleting" -or $line -match "has already been downloaded") {
                            $bytes = [System.Text.Encoding]::GetEncoding(866).GetBytes($line)
                            $lineCP1251 = [System.Text.Encoding]::GetEncoding(1251).GetString($bytes)
                            Write-Host $lineCP1251
                            $script:file_already_ex = $true
                        } else {
                            Write-Host $line
                        }
                        if ($line -match '\[Merger\].*?"(.+?\.(mp4|mkv|webm))"') {
                            $script:downloadedFile_raw = $matches[1]
                            $bytes_file = [System.Text.Encoding]::GetEncoding(866).GetBytes($downloadedFile_raw)
                            $script:downloadedFile = [System.Text.Encoding]::GetEncoding(1251).GetString($bytes_file)
                        }

                        if ($line -match '\[FixupM4a\].*?"(.+?\.(m4a|mp4))"') {
                            $script:downloadedFile_raw = $matches[1]
                            $bytes_file = [System.Text.Encoding]::GetEncoding(866).GetBytes($downloadedFile_raw)
                            $script:downloadedFile = [System.Text.Encoding]::GetEncoding(1251).GetString($bytes_file)
                        }
                    }
                } else {
                    Start-Sleep -Milliseconds 50
                }
            }

            $proc.WaitForExit()

            $searchName = [System.IO.Path]::GetFileNameWithoutExtension($script:downloadedFile) 
            $searchExt  = [System.IO.Path]::GetExtension($script:downloadedFile)
            $searchDir  = if ($IsRemoteInvocation) { $script:selectedPath } else { $PSScriptRoot }

            $found = Get-ChildItem -Path $searchDir -Filter "*$searchExt" | Where-Object {
                $cleanName = ($_.BaseName -replace '[^\x00-\xFF]', '')
                $cleanSearch = ($searchName -replace '[^\x00-\xFF]', '')
                $cleanName -eq $cleanSearch
            } | Select-Object -First 1

            if ($found) {
                $script:downloadedFile = $found.Name
            }
            $script:file_already_ex = $false



            if ($checkBox_Trim.Checked) {
                $script:Start_Time = $timePicker_Start.Value.ToString("HH:mm:ss")
                $script:End_Time = $timePicker_End.Value.ToString("HH:mm:ss")


                $proc = New-Object System.Diagnostics.Process
                $proc.StartInfo.FileName = if ($script:ffmpeg_error -eq $true) { $script:ffmpeg_path } else { "ffmpeg.exe" }

                $arguments = @()

                $searchDir  = if ($IsRemoteInvocation -and (-not $script:file_already_ex)) { $script:selectedPath } else { $PSScriptRoot }
                $ext        = [System.IO.Path]::GetExtension($script:downloadedFile).TrimStart('.')
                $OutputFile = Join-Path $searchDir "output.$ext"

                if ($IsRemoteInvocation -and (-not $script:file_already_ex)) {
                    $script:FullFilePath = $script:selectedPath + "\" + $script:downloadedFile
                } else {
                    $script:FullFilePath = $PSScriptRoot + "\" + $script:downloadedFile
                }

                $proc.StartInfo.Arguments = @(
                    "-i", "`"$script:FullFilePath`"",
                    "-ss", $script:Start_Time,
                    "-to", $script:End_Time,
                    "-c:v", "libx264",
                    "-c:a", "aac",
                    "`"$OutputFile`""
                ) -join " "

                #$proc.StartInfo.UseShellExecute = $false
                #$proc.StartInfo.CreateNoWindow = $true

                Write-Host "[Trim] Start of trimming. (This may take a while)"

                $proc.Start() | Out-Null
                $proc.WaitForExit()
                $code = $proc.ExitCode
                Remove-Item -Path "$script:FullFilePath"
                Move-Item -Path "$OutputFile" "$script:FullFilePath"

                Write-Host "Done!"
            }




            Write-Host "Downloaded!"
            $button1.Text = "Download"
            Clear-Host
        
            if(-not $script:file_already_ex){Show-BalloonTip -Title "ytvd" -Message "Downloaded!`n $($script:video_title_ballon)"}

            $button.Visible = 1
            $button1.Visible = 0
            $button_reset.Enabled = $true
            $button_proxy.Visible = $true
            $button_runtimes.Visible = $true
            $button_debug.Visible = $false
            $checkBox.Visible = $false
            $comboRes.Visible = 0
            $comboTBR.Visible = 0
            $checkBox.Checked = $false
            $label1.Visible = 0
            $label2.Visible = 0
            $label4.Visible = 0
            $label5.Visible = 0
            $textBox.Enabled = $true
            $button_paste.Visible = 1
            $button_reset.Visible = 0
            $button_update.Visible = $true
            $button_cookie.Visible = $true
            $button_Help.Visible = $true
            $button_save.Visible = $true
            $label_version.Visible = $true
            $form.Text = "Video download"
            $textBox.Text = ""
    
            $form.Size = New-Object System.Drawing.Size(500,95)
        }
    }
    $button1.Enabled = $true
    $script:jsonContent = $null
    $script:is_playlist = $null
})

#Событие нажатия на кнопку Debug
$button_debug.Add_Click({
    if ($script:debug -eq $false) {
        $script:debug = $true

        Clear-Host
        $selectedRes = $comboRes.SelectedItem
        $selectedTBR = $comboTBR.SelectedItem
        $script:selectedLang = $comboLang.SelectedItem
        if(-not(Test-TikTokUrl -Url $script:url)){$size_video = $script:videos | Where-Object { ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Raw_size | Sort-Object -Unique -Descending}
        $size_audio = $script:audios | Where-Object { ($_.ID.ToString().Trim()) -ieq "140" } |Select-Object -ExpandProperty Raw_size
        $total_size = $size_video + $size_audio
        $size = "~ " + $(Format-FileSize $total_size)
        $size_display = "~ " + $(Format-FileSize $total_size)
        if(-not(Test-TikTokUrl -Url $script:url)){$resolution = $script:videos | Where-Object { ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Resolution | Sort-Object -Unique -Descending}

        if(Test-TikTokUrl -Url $script:url) {
            Write-Host "Videos:" -NoNewline
            $script:videos | Format-Table | Out-Host
            Write-Host "Quality: $selectedRes `nTBR: $selectedTBR `nSize: $size_display`nResolution: $resolution`n" -NoNewline
        }else{
            Write-Host "`nAudios:" -NoNewline
            $script:audios | Format-Table | Out-Host
            Write-Host "Videos:" -NoNewline
            $script:videos | Format-Table | Out-Host
            Write-Host "Quality: $selectedRes `nTBR: $selectedTBR `nSize: $size_display`nResolution: $resolution`n" -NoNewline
            if ($script:multiple_audio -like $true){ Write-Host "Language: $script:selectedLang" }
        }
    } elseif ($script:debug -eq $true){
        $script:debug = $false
        Clear-Host
    }
})

#Событие нажатия на кнопку Save settings
$button_save.Add_Click({
    $data = [ordered]@{
        use_proxy                    = $script:use_proxy
        proxy_address                = $script:proxy_address
        textBox_proxy_ip             = $textBox_proxy_ip.Text
        textBox_proxy_port           = $textBox_proxy_port.Text

        use_runtimes                 = $script:use_runtimes
        selected_runtime             = $script:selected_runtime
        use_components               = $script:use_components
        selected_components          = $script:selected_components

        #comboBox_runtime             = $comboBox_runtime.SelectedItem
        checkBox_runtime             = $checkBox_runtime.Checked
        #comboBox_components          = $comboBox_components.SelectedItem
        checkBox_components          = $checkBox_components.Checked
        use_cookie                   = $script:use_cookie
        use_cookie_browser           = $script:use_cookie_browser
        use_cookie_file              = $script:use_cookie_file
        cookie_browser               = $script:cookie_browser
        cookie_file                  = $script:cookie_file
        radio_cookies_browser        = $radio_cookies_browser.Checked
        radio_cookies_file           = $radio_cookies_file.Checked
        checkBox_cookie              = $checkBox_cookie.Checked
        #comboBox_browser             = $comboBox_browser.SelectedItem
        
    }

    if(Test-Path "$env:TEMP/ytvd.json"){
        Clear-Content "$env:TEMP/ytvd.json"
        $data | ConvertTo-Json | Set-Content "$env:TEMP/ytvd.json"
    } else {
        New-Item "$env:TEMP/ytvd.json" -ItemType File -Force
        $data | ConvertTo-Json | Set-Content "$env:TEMP/ytvd.json"
    }
})

#Событие нажатия на галочку
$checkBox.Add_CheckedChanged({
    if ($checkBox.Checked) {
        $comboRes.Enabled = $false
        $comboTBR.Enabled = $false
        $script:old_size = $label5.Text

        if ($script:is_playlist) {
            $totalBytes = Get-PlaylistSize -PlaylistJson $script:jsonContent -SelectedResolution $comboRes.SelectedItem -AudioOnly $true
            $label5.Text = "~ " + $(Format-FileSize $totalBytes)
        } else {
            $audio_id_size = $script:audios | Where-Object { $_.FormatNote -eq $script:selectedLang -and $_.ID -like '140-*' -and $_.ID -notlike '140-drc*' } | Select-Object -ExpandProperty ID
            if ($script:multiple_audio) {
                $label5.Text = "~ " + $(Format-FileSize $($script:audios | Where-Object { ($_.ID.ToString().Trim()) -ieq "$($audio_id_size)" } | Select-Object -ExpandProperty Raw_size))
            } else {
                $label5.Text = "~ " + $(Format-FileSize $($script:audios | Where-Object { ($_.ID.ToString().Trim()) -ieq "140" } | Select-Object -ExpandProperty Raw_size))
            }
        }
    } else {
        $comboRes.Enabled = $true
        $comboTBR.Enabled = $true
        $label5.Text = $script:old_size
    }
})

#Событие нажатия на галочку Trim
$checkBox_Trim.Add_CheckedChanged({
    if($checkBox_Trim.Checked){
        $timePicker_Start.Enabled = $true
        $timePicker_End.Enabled = $true
    } else {
        $timePicker_Start.Enabled = $false
        $timePicker_End.Enabled = $false
    }
})

#Событие при выборе Resolution
$comboRes.Add_SelectedIndexChanged({
    if($script:is_playlist){
        $totalBytes = Get-PlaylistSize -PlaylistJson $script:jsonContent -SelectedResolution $comboRes.SelectedItem -AudioOnly $checkBox.Checked
        $label5.Text = "$(Format-FileSize $totalBytes)"
    }else{
        if (Test-TikTokUrl -Url $script:url){
            $selectedRes = $comboRes.SelectedItem
            if ($selectedRes) {
                # Фильтруем массив по выбранной Resolution
                $tbrList = $script:videos | Where-Object {$_.Resolution -eq $selectedRes} | Select-Object -ExpandProperty TBR | Sort-Object -Unique -Descending
                # Гарантируем массив
                if (-not $tbrList) { $tbrList = @() }
                # Очищаем ComboBox и добавляем новые элементы
                $comboTBR.Items.Clear()
                if ($tbrList.Count -gt 0) { 
                    $comboTBR.Items.AddRange($tbrList) 
                    $comboTBR.SelectedIndex = 0
                }
            }



        } else {
            $selectedRes = $comboRes.SelectedItem
            if ($selectedRes) {
                # Фильтруем массив по выбранной Resolution
                $tbrList = $script:videos | Where-Object { 
                    ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() 
                } | Select-Object -ExpandProperty TBR | Sort-Object -Unique -Descending

                # Гарантируем массив
                if (-not $tbrList) { $tbrList = @() }
    
                # Очищаем ComboBox и добавляем новые элементы
                $comboTBR.Items.Clear()
                if ($tbrList.Count -gt 0) { 
                    $comboTBR.Items.AddRange($tbrList) 
                    $comboTBR.SelectedIndex = 0
                }
            }
        }
    }

})

#Событие при выборе TBR
$comboTBR.Add_SelectedIndexChanged({
    if (Test-TikTokUrl -Url $script:url){
        $selectedRes = $comboRes.SelectedItem
        $selectedTBR = $comboTBR.SelectedItem

        $size_video = $script:videos | Where-Object {$_.Resolution -eq $selectedRes } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Raw_size | Sort-Object -Unique -Descending
        $size = $(Format-FileSize $size_video)
        $size_display = $(Format-FileSize $size_video)

        $resolution = $script:videos | Where-Object {$_.Resolution -eq $selectedRes } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Resolution | Sort-Object -Unique -Descending

        if ($script:debug -eq $true){
            Clear-Host
            Write-Host "Videos:" -NoNewline
            $script:videos | Format-Table | Out-Host
            Write-Host "Resolution: $selectedRes `nTBR: $selectedTBR `nSize: $size_display`n" -NoNewline
        }
        $label5.Text = $size

    } else {
        $selectedRes = $comboRes.SelectedItem
        $selectedTBR = $comboTBR.SelectedItem
        $script:selectedLang = $comboLang.SelectedItem
        
    
        $size_video = $script:videos | Where-Object { ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Raw_size | Sort-Object -Unique -Descending
        $size_audio = $script:audios | Where-Object { ($_.ID.ToString().Trim()) -ieq "140" } |Select-Object -ExpandProperty Raw_size
        $total_size = $size_video + $size_audio
        $size = "~ " + $(Format-FileSize $total_size)
        $size_display = "~ " + $(Format-FileSize $total_size)

        
        $resolution = $script:videos | Where-Object { ($_.FormatNote.ToString().Trim()) -ieq $selectedRes.ToString().Trim() } | Where-Object { ($_.TBR.ToString().Trim()) -ieq $selectedTBR.ToString().Trim() } |Select-Object -ExpandProperty Resolution | Sort-Object -Unique -Descending
        if ($script:debug -eq $true){
            Clear-Host
            Write-Host "`nAudios:" -NoNewline
            $script:audios | Format-Table | Out-Host
            Write-Host "Videos:" -NoNewline
            $script:videos | Format-Table | Out-Host
            Write-Host "Quality: $selectedRes `nTBR: $selectedTBR `nSize: $size_display`nResolution: $resolution`n" -NoNewline
            if ($script:multiple_audio -like $true){ Write-Host "Language: $script:selectedLang" }
        }
        $label5.Text = $size
    }
    if($comboTBR.Items.Count -eq 1){
        $comboTBR.Enabled = $false
    } elseif($comboTBR.Items.Count -ne 1){
        $comboTBR.Enabled = $true
    }
})

#Событие при выботе Language
$comboLang.Add_SelectedIndexChanged({
    $script:selectedLang = $comboLang.SelectedItem
})
#endregion


#endregion


#region Проверка наличия yt-dlp и ffmpeg
try {& "yt-dlp.exe" "--version" *>$null}catch{
    $script:yt_dlp_error = $true
    if($PSCulture -eq "ru-RU"){$result = [System.Windows.Forms.MessageBox]::Show("У вас есть установленный yt-dlp?","yt-dlp.exe не найден",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}else{$result = [System.Windows.Forms.MessageBox]::Show("Do you have yt-dlp installed?","yt-dlp.exe not found",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}
    if ($result -eq [System.Windows.Forms.DialogResult]::No) {
        if($PSCulture -eq "ru-RU"){$result = [System.Windows.Forms.MessageBox]::Show("Установить yt-dlp?","yt-dlp.exe не найден",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}else{$result = [System.Windows.Forms.MessageBox]::Show("Install yt-dlp?","yt-dlp.exe not found",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            try{mkdir "$($env:TEMP)\ytvd" -ErrorAction Stop >$null}catch{}
            try{Invoke-WebRequest https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -OutFile "$($env:TEMP)\ytvd\yt-dlp.exe" -ErrorAction Stop}catch{if($PSCulture -eq "ru-RU"){[System.Windows.Forms.MessageBox]::Show("Ошибка при загрузке yt-dlp.exe","Ошибка",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}else{[System.Windows.Forms.MessageBox]::Show("Error while downloading yt-dlp.exe","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}}
            $script:yt_dlp_path = "$($env:TEMP)\ytvd"
            $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            $newPath = $userPath + ";" + $script:yt_dlp_path
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            $script:ffmpeg_test_Path = $script:yt_dlp_path + "\ffmpeg.exe"
            if (Test-Path $script:ffmpeg_test_Path) {$script:ffmpeg_path = $script:ffmpeg_test_Path  + "\ffmpeg.exe" ; $script:ffmpeg_is_in_path = $true}
            $script:yt_dlp_path = $script:yt_dlp_path + "\yt-dlp.exe"
        }
    }
    elseif ($result -eq [System.Windows.Forms.DialogResult]::Yes) {

        #Выбор папки с yt-dlp

        $script:yt_dlp_error = $true
        if($PSCulture -eq "ru-RU"){[System.Windows.Forms.MessageBox]::Show("Укажите путь к yt-dlp.exe","yt-dlp.exe не найден",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}else{[System.Windows.Forms.MessageBox]::Show("Choose filepath to yt-dlp.exe","yt-dlp.exe not found",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}
        if($PSCulture -eq "ru-RU"){Folder-choose -text "Выберите папку с yt-dlp.exe"}else{Folder-choose -text "Select a folder with yt-dlp.exe"}
        $script:yt_dlp_path = $script:selectedPath + "\yt-dlp.exe"
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        $newPath = $userPath + ";" + $script:selectedPath
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        $script:ffmpeg_test_Path = $script:selectedPath + "\ffmpeg.exe"
        if (Test-Path $script:ffmpeg_test_Path) {
            $script:ffmpeg_path = $script:selectedPath  + "\ffmpeg.exe"
            $script:ffmpeg_is_in_path = $true
        }
    }
}

if (-not $script:ffmpeg_is_in_path){
    try {& "ffmpeg.exe" *>$null}catch{
        $script:ffmpeg_error = $true
        if($PSCulture -eq "ru-RU"){$result = [System.Windows.Forms.MessageBox]::Show("У вас есть установленный ffmpeg?","ffmpeg.exe не найден",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}else{$result = [System.Windows.Forms.MessageBox]::Show("Do you have ffmpeg installed?","ffmpeg.exe not found",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}
        if ($result -eq [System.Windows.Forms.DialogResult]::No) {
            if($PSCulture -eq "ru-RU"){$result = [System.Windows.Forms.MessageBox]::Show("Установить ffmpeg?","ffmpeg.exe не найден",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}else{$result = [System.Windows.Forms.MessageBox]::Show("Install ffmpeg?","ffmpeg.exe not found",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)}
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                try{mkdir "$($env:TEMP)\ytvd" -ErrorAction Stop >$null}catch{}
                $api = "https://api.github.com/repos/GyanD/codexffmpeg/releases/latest"
                $json = Invoke-WebRequest -Uri $api -UseBasicParsing | ConvertFrom-Json
                $zipUrl = $json.assets | Where-Object { $_.name -match "essentials_build.zip" } | Select-Object -ExpandProperty browser_download_url
                $build = Split-Path $zipUrl -Leaf
                try{Invoke-WebRequest "$($zipUrl)" -OutFile "$($env:TEMP)\ytvd\$($build)" -ErrorAction Stop}catch{if($PSCulture -eq "ru-RU"){[System.Windows.Forms.MessageBox]::Show("Ошибка при загрузке ffmpeg.exe","Ошибка",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}else{[System.Windows.Forms.MessageBox]::Show("Error while downloading ffmpeg.exe","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error) >$null}}
                try{mkdir "$($env:TEMP)\ytvd\ffmpeg-temp" -ErrorAction Stop >$null}catch{}
                [System.IO.Compression.ZipFile]::ExtractToDirectory("$($env:TEMP)\ytvd\$build", "$($env:TEMP)\ytvd\ffmpeg-temp")
                $source = Join-Path "$($env:TEMP)\ytvd\ffmpeg-temp" "$([System.IO.Path]::GetFileNameWithoutExtension($build))\bin\ffmpeg.exe"
                Copy-Item $source -Destination "$($env:TEMP)\ytvd"
                Remove-Item "$($env:TEMP)\ytvd\ffmpeg-temp" -Recurse -Force
                Remove-Item "$($env:TEMP)\ytvd\$($build)"
                $script:ffmpeg_path = "$($env:TEMP)\ytvd"
                $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
                $newPath = $userPath + ";" + $script:ffmpeg_path
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
                $script:ffmpeg_path = $script:ffmpeg_path + "\ffmpeg.exe"
            }
        }
        elseif ($result -eq [System.Windows.Forms.DialogResult]::Yes) {

            #Выбор папки с ffmpeg

            if($PSCulture -eq "ru-RU"){Folder-choose -text "Выберите папку с ffmpeg.exe"}else{Folder-choose -text "Select a folder with ffmpeg.exe"}
            $script:ffmpeg_path = $script:selectedPath  + "\ffmpeg.exe"
            $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            $newPath = $userPath + ";" + $script:selectedPath
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        }
    }
}
#endregion

#region Проверка сохранённых настроек
if (Test-Path "$env:TEMP/ytvd.json"){
    $config = Get-Content "$env:TEMP/ytvd.json" | ConvertFrom-Json
    $script:use_proxy                 = $config.use_proxy
    $checkBox_proxy.Checked           = $config.use_proxy
    $script:proxy_address             = $config.proxy_address
    $textBox_proxy_ip.Text            = $config.textBox_proxy_ip
    $textBox_proxy_port.Text          = $config.textBox_proxy_port

    $script:use_runtimes              = $config.use_runtimes
    $script:selected_runtime          = $config.selected_runtime
    $script:use_components            = $config.use_components
    $script:selected_components       = $config.selected_components

    $comboBox_runtime.SelectedItem    = $config.selected_runtime
    $checkBox_runtime.Checked         = $config.checkBox_runtime
    $comboBox_components.SelectedItem = $config.selected_components
    $checkBox_components.Checked      = $config.checkBox_components
    $script:use_cookie                = $config.use_cookie
    $script:use_cookie_browser        = $config.use_cookie_browser
    $script:use_cookie_file           = $config.use_cookie_file
    $script:cookie_browser            = $config.cookie_browser
    $script:cookie_file               = $config.cookie_file
    $radio_cookies_browser.Checked    = $config.radio_cookies_browser
    $radio_cookies_file.Checked       = $config.radio_cookies_file
    $checkBox_cookie.Checked          = $config.checkBox_cookie
    $comboBox_browser.SelectedItem    = $config.cookie_browser
    
}
#endregion

[void]$form.ShowDialog()
