# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Autostart tmux on terminal launch
ZSH_TMUX_AUTOSTART=true

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  tmux 
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
# export ARCHFLAGS="-arch x86_64"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$PATH:$HOME/.Garmin/ConnectIQ/Sdks/current/bin"

# You may need to manually set your language environment

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias bat="batcat"
alias top="bpytop"
alias htop="bpytop"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

# Linux related configs
if [[ "$(uname)" == "Linux" ]]; then
  export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
  export ANDROID_HOME=~/Android/Sdk
fi

# MacOs Related configs
if [[ "$OSTYPE" == darwin* ]]; then
  defaults write com.apple.finder AppleShowAllFiles -bool true # Show hidden files
  defaults write com.apple.dock autohide -bool true # Auto hide dock
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true # Secondary Right click
  defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv" # Default finder view icon as list
  defaults write com.apple.Finder FXPreferredGroupBy -string "Kind" # Sort by kind
  defaults write com.microsoft.vscode applepressandholdenabled -bool false              # for vs code
  defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
  defaults write com.vscodium applepressandholdenabled -bool false                      # for vs codium
  defaults write com.microsoft.vscodeexploration applepressandholdenabled -bool false   # for vs codium exploration users
  defaults delete -g applepressandholdenabled                                           # if necessary, reset global default fi
fi

# Nodejs Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ZSH autosuggestions plugin
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  echo "Installing zsh autosuggestions ..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

# Syntax highlighting plugin
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  echo "Installing zsh syntax highlighting ..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

# Check git --global config is set
if [ -z "$(git config --global user.email)" ]; then
  echo "Warning: Git user.email is not set."
  echo "Please set it using the following command:"
  echo "  git config --global user.email 'youremail@example.com'"
  echo "  git config --global user.name 'Name'"
fi

# Check if TPM is already installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  # Clone TPM repository if not installed
  echo "Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  # Start a tmux session or attach to an existing one
  tmux has-session -t mysession 2>/dev/null

  if [ $? != 0 ]; then
    # Create a new tmux session if one doesn't exist
    tmux new-session -d -s mysession
  fi

  # Send the key sequence for installing plugins (`prefix + I`)
  tmux send-keys -t mysession "prefix I" C-m

  echo "Plugins installation triggered. Press 'prefix + I' in the tmux session if needed."
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
