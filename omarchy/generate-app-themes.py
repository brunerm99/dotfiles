#!/usr/bin/env python3
"""Regenerate native app themes from the reviewed Workbench palettes (Python 3.11+)."""
import json
from pathlib import Path
import tomllib

ROOT = Path(__file__).resolve().parent
SOURCE = json.loads((ROOT / 'palette-source.json').read_text())
PALETTES = {}
ANSI_NAMES = ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white']


def write(path, text):
    path = ROOT / path
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


def write_json(path, value):
    write(path, json.dumps(value, indent=2) + '\n')


def blend(a, b, fraction):
    return '#' + ''.join(f'{round(int(a[i:i+2],16)*fraction + int(b[i:i+2],16)*(1-fraction)):02x}' for i in (1, 3, 5))


obsidian = []
for mode in ('light', 'dark'):
    theme_dir = f'workbench-{mode}'
    c = tomllib.loads((ROOT / theme_dir / 'colors.toml').read_text())
    p = dict(SOURCE[mode], **c)
    p['orange_text'] = '#914312' if mode == 'light' else '#f09050'
    p['cursor_text'] = '#ffffff' if mode == 'light' else '#1e2c31'
    PALETTES[mode] = p
    bg, fg, surface, alt, muted, border, accent = [p[k] for k in ('background', 'foreground', 'surface', 'alt', 'muted', 'border', 'accent')]
    red, green, yellow, blue, purple, cyan = [c[f'color{i}'] for i in range(1, 7)]
    selected = c['selection_background']
    title = 'Workbench ' + mode.title()
    ghostty = '\n'.join(f'{key} = {value}' for key, value in {
        'background': bg, 'foreground': fg, 'cursor-color': p['cursor'],
        'cursor-text': p['cursor_text'], 'selection-background': selected,
        'selection-foreground': fg,
    }.items()) + '\n' + ''.join(f'palette = {i}={c[f"color{i}"]}\n' for i in range(16))
    write(f'apps/config/ghostty/themes/Workbench{mode.title()}', ghostty)
    write(f'{theme_dir}/ghostty.conf', ghostty)

    write(f'{theme_dir}/mako.ini', f'''include=~/.local/share/omarchy/default/mako/core.ini
font=IBM Plex Serif 11
text-color={fg}
border-color={accent}
background-color={bg}
''')

    gtk = f'''/* Optional GTK 3 overlay for Nemo and other GTK 3 apps. */
@define-color theme_bg_color {bg};
@define-color theme_fg_color {fg};
@define-color theme_base_color {surface};
@define-color theme_text_color {fg};
@define-color theme_selected_bg_color {accent};
@define-color theme_selected_fg_color #1e2c31;
@define-color insensitive_fg_color {muted};
@define-color borders {border};
window {{ background-color: {bg}; color: {fg}; font-family: "IBM Plex Serif"; }}
headerbar, toolbar, statusbar {{ background-image: none; background-color: {alt}; color: {fg}; border-color: {border}; }}
entry, textview text, treeview, .view {{ background-color: {surface}; color: {fg}; }}
button {{ background-image: none; background-color: {surface}; color: {fg}; border-color: {border}; }}
button:hover {{ background-color: {alt}; }}
button:checked, button.suggested-action {{ background-color: {accent}; color: #1e2c31; }}
*:selected, selection {{ background-color: {accent}; color: #1e2c31; }}
.sidebar, .sidebar .view {{ background-color: {alt}; color: {fg}; }}
menu, menuitem, popover {{ background-color: {surface}; color: {fg}; }}
menuitem:hover {{ background-color: {alt}; }}
tooltip {{ background-color: {surface}; color: {fg}; border-color: {border}; }}
'''
    write(f'apps/config/gtk-3.0/workbench/{mode}.css', gtk)

    vs_colors = {
        'foreground': fg, 'descriptionForeground': muted, 'focusBorder': accent,
        'editor.background': bg, 'editor.foreground': fg, 'editorCursor.foreground': accent,
        'editor.selectionBackground': selected, 'editor.selectionForeground': fg,
        'editor.lineHighlightBackground': alt, 'editorLineNumber.foreground': muted,
        'editorLineNumber.activeForeground': p['orange_text'], 'editorIndentGuide.background1': border,
        'editorIndentGuide.activeBackground1': muted, 'editorWhitespace.foreground': border,
        'sideBar.background': surface, 'sideBar.foreground': fg, 'sideBar.border': border,
        'activityBar.background': surface, 'activityBar.foreground': accent,
        'activityBarBadge.background': accent, 'activityBarBadge.foreground': '#1e2c31',
        'statusBar.background': alt, 'statusBar.foreground': fg,
        'statusBar.noFolderBackground': alt, 'statusBar.debuggingBackground': accent,
        'statusBar.debuggingForeground': '#1e2c31',
        'titleBar.activeBackground': alt, 'titleBar.activeForeground': fg,
        'titleBar.inactiveBackground': surface, 'titleBar.inactiveForeground': muted,
        'tab.activeBackground': bg, 'tab.activeForeground': fg, 'tab.activeBorderTop': accent,
        'tab.inactiveBackground': surface, 'tab.inactiveForeground': muted,
        'editorGroupHeader.tabsBackground': surface, 'panel.background': bg, 'panel.border': border,
        'input.background': surface, 'input.foreground': fg, 'input.border': border,
        'dropdown.background': surface, 'dropdown.foreground': fg, 'dropdown.border': border,
        'button.background': accent, 'button.foreground': '#1e2c31',
        'list.activeSelectionBackground': selected, 'list.activeSelectionForeground': fg,
        'list.inactiveSelectionBackground': alt, 'list.inactiveSelectionForeground': fg,
        'list.hoverBackground': alt, 'list.focusOutline': accent,
        'editorWidget.background': surface, 'editorWidget.foreground': fg,
        'editorWidget.border': border, 'editorSuggestWidget.selectedBackground': alt,
        'peekViewEditor.background': bg, 'peekViewResult.background': surface,
        'notifications.background': surface, 'notifications.foreground': fg,
        'textLink.foreground': blue, 'textCodeBlock.background': alt,
        'terminal.background': bg, 'terminal.foreground': fg,
        'terminalCursor.foreground': accent, 'terminal.selectionBackground': selected,
        'gitDecoration.addedResourceForeground': green, 'gitDecoration.modifiedResourceForeground': yellow,
        'gitDecoration.deletedResourceForeground': red, 'editorError.foreground': red,
        'editorWarning.foreground': yellow, 'editorInfo.foreground': blue,
        'diffEditor.insertedTextBackground': blend(green, bg, .15),
        'diffEditor.removedTextBackground': blend(red, bg, .15),
    }
    for i, name in enumerate(ANSI_NAMES):
        vs_colors['terminal.ansi'+name.title()] = c[f'color{i}']
        vs_colors['terminal.ansiBright'+name.title()] = c[f'color{i+8}']
    syntax = [('comment', muted), ('string', green), ('constant.numeric', yellow),
              ('constant.language', p['orange_text']), ('keyword', purple), ('storage', purple),
              ('entity.name.function', blue), ('support.function', blue), ('entity.name.type', cyan),
              ('support.type', cyan), ('variable', fg), ('punctuation', muted),
              ('markup.heading', p['orange_text']), ('markup.inline.raw', green)]
    write_json(f'apps/vscode/workbench-themes/themes/{mode}-color-theme.json', {
        'name': title, 'type': mode, 'colors': vs_colors, 'semanticHighlighting': True,
        'semanticTokenColors': {'variable':fg,'parameter':fg,'function':blue,'method':blue,'type':cyan,'class':cyan,'keyword':purple,'string':green,'number':yellow},
        'tokenColors': [{'scope':scope,'settings':{'foreground':color}} for scope,color in syntax],
    })
    write_json(f'{theme_dir}/vscode.json', {'name':title,'extension':'workbench.workbench-themes'})

    obs = { 'background-primary':bg,'background-primary-alt':alt,'background-secondary':surface,
            'background-secondary-alt':alt,'background-modifier-border':border,'text-normal':fg,'text-muted':muted,
            'text-faint':muted,'text-accent':p['orange_text'],'text-accent-hover':p['orange_text'],
            'text-on-accent':'#1e2c31','text-selection':selected,'interactive-accent':accent,
            'interactive-accent-hover':accent,'text-error':red,'text-success':green,'link-color':blue,
            'link-color-hover':cyan,'code-normal':cyan,'code-background':alt,'graph-line':border,'graph-node':accent,
            'h1-color':p['orange_text'],'h2-color':p['orange_text'],
            'font-interface-theme':'"IBM Plex Serif"','font-text-theme':'"IBM Plex Serif"','font-monospace-theme':'"IBM Plex Mono"'}
    obs_css = f'body.theme-{mode} {{\n'+''.join(f'  --{key}: {value};\n' for key,value in obs.items())+'}\n'
    obsidian.append(obs_css)
    write(f'{theme_dir}/obsidian.css', obs_css.replace(f'body.theme-{mode}', 'body.theme-light, body.theme-dark'))

write_json('apps/vscode/workbench-themes/package.json', {
    'name':'workbench-themes','displayName':'Workbench Themes','publisher':'workbench',
    'version':'0.1.0','engines':{'vscode':'^1.80.0'},'categories':['Themes'],
    'description':'Workbench light and dark palettes with readable terminal and syntax colors.',
    'contributes':{'themes':[{'label':'Workbench '+mode.title(),'uiTheme':'vs' if mode=='light' else 'vs-dark',
                             'path':f'./themes/{mode}-color-theme.json'} for mode in ('light','dark')]},
})
write('apps/obsidian/workbench.css', '\n'.join(obsidian))

# A standalone colorscheme avoids a dependency on Kraken's Tokyo Night plugin.
lua = '-- Generated by generate-app-themes.py; supports :set background=light/dark.\nlocal palettes = {\n'
for mode,p in PALETTES.items():
    lua += f'  {mode} = {{\n' + ''.join(f'    {key} = "{value}",\n' for key,value in p.items()) + '  },\n'
lua += '''}
vim.cmd.highlight('clear')
if vim.fn.exists('syntax_on') == 1 then vim.cmd.syntax('reset') end
vim.g.colors_name = 'workbench'
local p = palettes[vim.o.background]
local function hi(name, fg, bg, extra)
  local value = extra or {}
  value.fg, value.bg = fg, bg
  vim.api.nvim_set_hl(0, name, value)
end
for i = 0, 15 do vim.g['terminal_color_' .. i] = p['color' .. i] end
hi('Normal', p.foreground, p.background)
hi('NormalNC', p.foreground, p.background)
hi('NormalFloat', p.foreground, p.surface)
hi('FloatBorder', p.border, p.surface)
hi('SignColumn', p.muted, p.background)
hi('LineNr', p.muted, p.background)
hi('CursorLineNr', p.orange_text, p.alt)
hi('CursorLine', nil, p.alt)
hi('CursorColumn', nil, p.alt)
hi('Cursor', p.cursor_text, p.cursor)
hi('TermCursor', p.cursor_text, p.cursor)
hi('Visual', p.selection_foreground, p.selection_background)
hi('Search', '#1e2c31', p.accent)
hi('IncSearch', '#1e2c31', p.accent)
hi('StatusLine', p.foreground, p.surface)
hi('StatusLineNC', p.muted, p.alt)
hi('WinSeparator', p.border, p.background)
hi('Pmenu', p.foreground, p.surface)
hi('PmenuSel', p.foreground, p.selection_background)
hi('PmenuSbar', nil, p.alt)
hi('PmenuThumb', nil, p.border)
hi('TabLine', p.muted, p.surface)
hi('TabLineSel', '#1e2c31', p.accent)
hi('TabLineFill', nil, p.surface)
hi('Folded', p.muted, p.alt)
hi('EndOfBuffer', p.background, p.background)
hi('MatchParen', p.foreground, p.selection_background, { bold = true })
hi('Directory', p.color4)
hi('Title', p.orange_text, nil, { bold = true })
hi('NonText', p.muted)
hi('SpecialKey', p.muted)
hi('Comment', p.muted)
hi('Identifier', p.foreground)
hi('String', p.color2)
hi('Character', p.color2)
hi('Number', p.color3)
hi('Boolean', p.orange_text)
hi('Float', p.color3)
hi('Constant', p.orange_text)
hi('Function', p.color4)
hi('Statement', p.color5)
hi('Keyword', p.color5)
hi('PreProc', p.color5)
hi('Type', p.color6)
hi('Special', p.color6)
hi('Operator', p.color6)
hi('Delimiter', p.muted)
hi('Todo', '#1e2c31', p.accent)
hi('Error', p.color1, p.background)
hi('ErrorMsg', p.color1)
hi('WarningMsg', p.color3)
hi('DiffAdd', p.color2, p.alt)
hi('DiffDelete', p.color1, p.alt)
hi('DiffChange', p.color4, p.alt)
hi('DiffText', p.foreground, p.selection_background)
for kind, color in pairs({ Error=p.color1, Warn=p.color3, Info=p.color4, Hint=p.color6, Ok=p.color2 }) do
  hi('Diagnostic' .. kind, color)
  hi('DiagnosticVirtualText' .. kind, color, p.alt)
  hi('DiagnosticUnderline' .. kind, nil, nil, { undercurl=true, sp=color })
end
for name, target in pairs({
  ['@variable']='Identifier', ['@variable.parameter']='Identifier', ['@variable.member']='Identifier',
  ['@variable.builtin']='Constant', ['@function']='Function', ['@function.builtin']='Function',
  ['@function.method']='Function', ['@constructor']='Type', ['@type']='Type',
  ['@keyword']='Keyword', ['@string']='String', ['@number']='Number', ['@boolean']='Boolean',
  ['@constant']='Constant', ['@operator']='Operator', ['@comment']='Comment', ['@punctuation']='Delimiter',
  ['@markup.heading']='Title', ['@markup.raw']='String', ['@markup.link']='Function',
  ['@lsp.type.variable']='Identifier', ['@lsp.type.parameter']='Identifier',
  ['@lsp.type.function']='Function', ['@lsp.type.method']='Function', ['@lsp.type.class']='Type',
  GitSignsAdd='DiffAdd', GitSignsChange='DiffChange', GitSignsDelete='DiffDelete',
  TelescopeNormal='NormalFloat', TelescopeBorder='FloatBorder', TelescopeSelection='PmenuSel',
  SnacksPickerNormal='NormalFloat', SnacksPickerBorder='FloatBorder', SnacksPickerMatch='Special',
}) do vim.api.nvim_set_hl(0, name, { link=target }) end
'''
write('apps/config/nvim/colors/workbench.lua', lua)
for mode in PALETTES:
    write(f'workbench-{mode}/nvim/colors/workbench.lua', lua)
    write(f'workbench-{mode}/neovim.lua', '''-- Omarchy's LazyVim adapter; the standalone Kraken colorscheme needs no plugin.
return {
  { 'LazyVim/LazyVim',
    init = function()
      vim.opt.rtp:prepend(vim.fn.expand('~/.config/omarchy/current/theme/nvim'))
      vim.o.background = MODE
      vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block,a:blinkon0-Cursor'
    end,
    opts = { colorscheme = 'workbench' },
  },
}
'''.replace('MODE', repr(mode)))

# ANSI names follow Ghostty/Kitty automatically when their palette changes.
fish = '''function workbench --description 'Use the Workbench terminal palette for Fish'
'''
for key,value in {
    'normal':'normal','command':'blue','param':'normal','quote':'green','redirection':'cyan',
    'end':'magenta','error':'red','comment':'brblack','autosuggestion':'brblack',
    'operator':'cyan','escape':'cyan','cwd':'blue','cwd_root':'red','user':'green',
    'host':'normal','host_remote':'yellow','status':'red','valid_path':'--underline',
    'selection':'--reverse','search_match':'--reverse','history_current':'--bold','cancel':'--reverse',
}.items(): fish += f'    set --global fish_color_{key} {value}\n'
for key,value in {'prefix':'blue --bold','completion':'normal','description':'brblack',
                  'progress':'cyan','selected_background':'--reverse'}.items():
    fish += f'    set --global fish_pager_color_{key} {value}\n'
fish += 'end\n'
write('apps/config/fish/functions/workbench.fish', fish)
write('apps/snippets/ghostty.conf', '''font-family = ""
font-family = "IBM Plex Mono"
theme = light:WorkbenchLight,dark:WorkbenchDark

# Keep the cursor solid and prevent shell integration from making it a thin bar.
cursor-style = block
cursor-style-blink = false
cursor-opacity = 1
adjust-cursor-thickness = 2
shell-integration-features = no-cursor

# Ghostty 1.3+: mark the active pane while keeping all split text readable.
unfocused-split-opacity = 1
custom-shader = ~/.config/ghostty/shaders/workbench-focus.glsl
custom-shader-animation = false
''')
write_json('apps/snippets/vscode-settings.json', {
    'workbench.colorTheme':'Workbench Dark','window.autoDetectColorScheme':True,
    'workbench.preferredDarkColorTheme':'Workbench Dark','workbench.preferredLightColorTheme':'Workbench Light',
    'editor.fontFamily':"'IBM Plex Mono', monospace",'terminal.integrated.fontFamily':'IBM Plex Mono',
})
print('Generated Ghostty, Neovim, Fish, VS Code, GTK 3, Obsidian, and Mako themes.')
