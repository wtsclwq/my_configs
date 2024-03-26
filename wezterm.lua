-- Wezterm configuration
-- powered by aquawius
-- this is version 4

-- version 1: initial config
-- version 2: wsl support
-- version 3: update theme to purple style
-- version 4: fix bug "git log" with "terminal is not fully functional" 
--            tracert: term set to "" is not a compatible term for git


local wezterm = require("wezterm")

local config = {
    check_for_updates = false,
    -- color_scheme = "Fahrenheit",
    -- color_scheme = "Gruvbox Dark",
    -- color_scheme = "Blue Matrix",
    -- color_scheme = "Pandora",
    -- color_scheme = "Grape",
    -- color_scheme = "Firewatch",
    -- color_scheme = "Duotone Dark",
    color_scheme = "DotGov",
    -- color_scheme = "lovelace",

    enable_scroll_bar = true,
    exit_behavior = "Close",

    -- tab_bar_at_bottom = true,
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
	-- 取消 Windows 原生标题栏
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	window_close_confirmation = 'NeverPrompt',
    -- font = wezterm.font(''),
    font = wezterm.font_with_fallback({
        "ComicShannsMono Nerd Font",
        "JetBrainsMono Nerd Font",
    }),
    font_size = 14.0,
    default_prog = { 'wsl' },
    default_cwd = "//wsl$/openSUSE-Tumbleweed/home/wtsclwq",
    launch_menu = {

    },
    set_environment_variables = {},
}

-- 取消所有默认的热键
config.disable_default_key_bindings = true
local act = wezterm.action
config.keys = {
  -- Ctrl+Shift+Tab 遍历 tab
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  -- F11 切换全屏
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  -- Ctrl+Shift++ 字体增大
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- Ctrl+Shift+- 字体减小
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  -- Ctrl+Shift+C 复制选中区域
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  -- Ctrl+Shift+N 新窗口
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- Ctrl+Shift+T 新 tab
  { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
  -- Ctrl+Shift+Enter 显示启动菜单
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  -- Ctrl+Shift+V 粘贴剪切板的内容
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- Ctrl+Shift+W 关闭 tab 且不进行确认
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = false } },
  -- Ctrl+Shit+Alt+W 关闭 Pane 且不进行确认
  { key = 'W', mods = 'SHIFT|CTRL|ALT', action = wezterm.action.CloseCurrentPane { confirm = false },},
  -- Ctrl+Shift+PageUp 向上滚动一页
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
  -- Ctrl+Shift+PageDown 向下滚动一页
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
  -- Ctrl+Shift+UpArrow 向上滚动一行
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  -- Ctrl+Shift+DownArrow 向下滚动一行
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
  -- Ctrl+Shit+Alt+% 纵向划分当前Pane
  { key = '%', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },},
  -- Ctrl+Shit+Alt+" 横向划分当前Pane
  { key = '"', mods = 'CTRL|SHIFT|ALT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- config.term = "" -- Set to empty so FZF works on windows
    -- config.term = "xterm"  -- fix bug in command "git log" with "terminal is not fully functional" or delete this term = "xxxx" (using default term value)

    table.insert(config.launch_menu, { label = "PowerShell 7", args = { "pwsh.exe", "-NoLogo" } })
    table.insert(config.launch_menu, { label = "Command Prompt", args = { "cmd.exe" } })

    -- Enumerate any WSL distributions that are installed and add those to the menu
    local success, wsl_list, wsl_err = wezterm.run_child_process({ "wsl", "-l" })
    -- `wsl.exe -l` has a bug where it always outputs utf16:
    -- https://github.com/microsoft/WSL/issues/4607
    -- So we get to convert it
    wsl_list = wezterm.utf16_to_utf8(wsl_list)

    for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
        -- Skip the first line of output; it's just a header
        if idx > 1 then
            -- Remove the "(Default)" marker from the default line to arrive
            -- at the distribution name on its own
            local distro = line:gsub(" %(默认%)", "")

            -- Add an entry that will spawn into the distro with the default shell
            table.insert(config.launch_menu, {
                label = distro .. " (WSL default shell)",
                args = { "wsl.exe", "-d", distro, "--cd", "/home/wtsclwq" },
            })
        end
    end
else
    table.insert(config.launch_menu, { label = "zsh", args = { "zsh", "-l" } })
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function Basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = Basename(pane.foreground_process_name)
    return {
        { Text = " " .. title .. " " },
    }
end)

return config
