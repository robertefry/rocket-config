
################################################################################
## ZSH OPTIONS
################################################################################

## Use dotfile globbing
setopt GLOB_DOTS

## Extended globbing. Allows using regular expressions with *
setopt extendedglob

## Case insensitive globbing
setopt nocaseglob

## Sort filenames numerically when it makes sense
setopt numericglobsort

## Immediately append history instead of overwriting
setopt appendhistory

## If a new command is a duplicate, remove the older one
setopt histignorealldups

## save commands are added to the history immediately, otherwise only when shell exits.
setopt inc_append_history

## Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

## Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

## automatically find new executables in path
zstyle ':completion:*' rehash true

## Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

## History file
HISTSIZE=10000
SAVEHIST=10000


################################################################################
## ZSH PLUGINS
################################################################################

## Which plugins would you like to load?
## Standard plugins can be found in $ZSH/plugins/
## Custom plugins may be added to $ZSH_CUSTOM/plugins/
## Example format: plugins=(rails git textmate ruby lighthouse)
## Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sudo
)

## Use autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


################################################################################
## ZSH VARIABLES
################################################################################

## If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:/usr/local/bin:$PATH

## Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

## Set name of the theme to load --- if set to "random", it will
## load a random theme each time oh-my-zsh is loaded, in which case,
## to know which specific one was loaded, run: echo $RANDOM_THEME
## See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

## Set list of themes to pick from when loading at random
## Setting this variable when ZSH_THEME=random will cause zsh to load
## a theme from this variable instead of looking in $ZSH/themes/
## If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

## Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

## Uncomment the following line to use hyphen-insensitive completion.
## Case-sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

## Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

## Uncomment the following line to automatically update without prompting.
#DISABLE_UPDATE_PROMPT="true"

## Uncomment the following line to change how often to auto-update (in days).
#export UPDATE_ZSH_DAYS=13

## Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS="true"

## Uncomment the following line to disable colors in ls.
#DISABLE_LS_COLORS="true"

## Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"

## Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

## Uncomment the following line to display red dots whilst waiting for completion.
## Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
## See https://github.com/ohmyzsh/ohmyzsh/issues/5765
#COMPLETION_WAITING_DOTS="true"

## Uncomment the following line if you want to disable marking untracked files
## under VCS as dirty. This makes repository status check for large repositories
## much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

## Uncomment the following line if you want to change the command execution time
## stamp shown in the history command output.
## You can set one of the optional three formats:
## "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
## or set a custom format using the strftime function format specifications,
## see 'man strftime' for details.
#HIST_STAMPS="mm/dd/yyyy"

## Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

## Generate the cache directory
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
    mkdir $ZSHif [[ ! -d $ZSH_CACHE_DIR ]]
fi


################################################################################
## OH-MY-ZSH
################################################################################

## Load in oh-my-zsh
source $ZSH/oh-my-zsh.sh


################################################################################
## SHELL AGNOSTIC PERSONAL PROFILE
################################################################################

## Source my shell-agnostic profile
if [[ -f $HOME/.profile ]]; then
    source $HOME/.profile
fi
