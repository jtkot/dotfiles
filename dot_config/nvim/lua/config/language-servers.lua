return {
	["efm-langserver"] = {
		cmd = { 'efm-langserver' },
		filetypes = { 'meson', 'javascript', 'typescript', 'hexpat', 'sh' }
	},
	["nixd"] = {
		cmd = { 'nixd' },
		filetypes = { 'nix' },
		settings = {
			formatting = {
				command = { "nixfmt" }
			}
		}
	},
	["phpactor"] = {
		cmd = { 'phpactor', 'language-server' },
		filetypes = { 'php' },
		root_markers = { 'composer.json', 'vendor', '.git' }
	},
}
