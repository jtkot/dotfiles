if [ ! (command -q nh) ]
	set -l NH_HOME_FLAKE "$HOME/.config/nixos/hm"
	if [ -d "$NH_HOME_FLAKE" ]
		set -gx NH_HOME_FLAKE "$NH_HOME_FLAKE"
	end

	set -l NH_OS_FLAKE "$HOME/.config/nixos/system"
	if [ -d "$NH_OS_FLAKE" ]
		set -gx NH_OS_FLAKE "$NH_OS_FLAKE"
	end
end

set -l BREW "/opt/homebrew/bin/brew"

if [ -f "$BREW" -a (type -q brew; echo $status) -ne 0 ]
	set -gx HOMEBREW_NO_ANALYTICS 1
	set -gx HOMEBREW_NO_EMOJI 1
	set -gx HOMEBREW_NO_ENV_HINTS 1
	set -gx HOMEBREW_CASK_OPTS "--no-quarantine"
	source ($BREW shellenv | psub)
end


fish_add_path "$HOME/.nix-profile/bin" "$HOME/.local/bin" "$HOME/.dotnet/tools"

if status is-interactive
	set -U fish_greeting
	set -gx GPG_TTY "$(tty)"
	set -gx EDITOR "nvim"

	alias .. "cd .."
	alias ... "cd ../.."
	alias .... "cd ../../.."
	alias ..... "cd ../../../.."
	alias ...... "cd ../../../../.."
	alias ....... "cd ../../../../../.."
	alias ........ "cd ../../../../../../.."
	alias ......... "cd ../../../../../../../.."

	alias ls "ls --color=auto"
	alias l "ls -l"
	alias rm "rm -i"
	alias cp "cp -i"
	alias mv "mv -i"

	if [ -x "$(command -v info)" ]
		alias info "info --vi-keys"
	end

	if [ -x "$(command -v brew)" ]
		set HOMEBREW_COMMAND_NOT_FOUND_HANDLER "$(brew --repository)/Library/Homebrew/command-not-found/handler.fish"
		if [ -f "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER" ]
		  source "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER"
		end
	end

	if [ -x "$(command -v fzf)" ]
		source (fzf --fish | psub)
	end

	if [ -x "$(command -v fj)" ]
		alias berg "fj -H codeberg.org"
	end

	if [ -x "$(command -v llama-cli)" ]
		alias gemma="llama-cli -hf unsloth/gemma-4-26b-a4b-it-GGUF:UD-IQ3_S -c 130000"
		alias qwen="llama-cli -hf unsloth/gemma-4-26b-a4b-it-GGUF:UD-IQ3_S -c 130000"
	end

	set -l DOTENV "$HOME/.env"
	if [ -f $DOTENV ]
		source $DOTENV
	end
end
