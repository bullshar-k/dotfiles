#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

fastfetch --config paleofetch --logo arch3

eval "$(starship init bash)"

alias wallert="monero-wallet-cli --wallet /home/shark/monero-wallets/mywallet --daemon-address 192.168.1.67:18081 --trusted-daemon"
