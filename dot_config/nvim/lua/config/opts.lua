return {
    colorcolumn = '80,120',
    cursorline = true,
    expandtab = true,
    hlsearch = false,
    ignorecase = true,
    incsearch = true,
    modeline = false,
    mouse = "",
    number = true,
    numberwidth = 6,
    relativenumber = true,
    shiftwidth = 4,  -- indentation width
    softtabstop = 2, -- spaces per tab key
    -- showmode = false,
    -- TODO: align filename to the text buffer
    statusline = " %{%v:lua.get_mode_name_short()%}   %f %h%m%r %= %l,%c %P",
    showmode = false,
    signcolumn = 'yes',
    smartcase = true,
    termguicolors = true,
    wrap = false
}
