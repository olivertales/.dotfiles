$env.EDITOR = "nvim"
$env.edit_mode = "nvim"
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

alias xinstall = sudo xbps-install -S
alias xquery = sudo xbps-query
alias xremove = sudo xbps-remove -Oo

source ~/.zoxide-nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
