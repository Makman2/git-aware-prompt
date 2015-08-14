PS1_prefix="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w"
PS1_postfix="\$"

update_git_PS1() {
  # Don't forget to wrap colors or any other non-printed strings in \\[ and \\]!

  PS1_text=""
  if [ -n "$git_branch" ]; then
    PS1_text="$PS1_text \\[$txtcyn\\]($git_branch)\\[$txtred\\]$git_dirty\\[$txtrst\\]"
  fi

  export PS1="$PS1_prefix$PS1_text$PS1_postfix "
}

PROMPT_COMMAND="$PROMPT_COMMAND; update_git_PS1"
