zoxide init nushell | save -f ~/.zoxide-nu


#Fnm
$env.path ++= ["~/.local/share/fnm"]

$env.XDEB_PKGROOT = ($env.HOME | path join '.config/xdeb')
$env.STARSHIP_SHELL = 'nu'
$env.STARSHIP_CONFIG = ($env.HOME | path join '.config/starship/starship.toml') 

#FNM Nushell setup
if not (which fnm | is-empty) {
  ^fnm env --json | from json | load-env
  $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
  $env.config.hooks.env_change.PWD = (
      $env.config.hooks.env_change.PWD? | append {
          condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
          code: {|| ^fnm use}
      }
  )
}
#Fnm end

# pnpm
$env.PNPM_HOME = "/home/thalles/.local/share/pnpm"
$env.PATH = ($env.PATH | split row (char esep) | prepend $env.PNPM_HOME )
# pnpm end

