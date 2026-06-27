return {
	["efm-langserver"] = {
		cmd = { 'efm-langserver' },
		filetypes = { 'meson', 'javascript', 'typescript', 'hexpat', 'sh' }
	},
	["deno-lsp"] = {
		cmd = { 'deno', 'lsp' },
		filetypes = { 'javascript', 'typescript', 'typescriptreact' },
		root_markers = { 'deno.json' }
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
