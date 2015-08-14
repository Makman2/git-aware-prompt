PS1_prefix="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w"
PS1_postfix="\$"

update_git_PS1() {
  # Don't forget to wrap colors or any other non-printed strings in \\[ and \\]!

  PS1_text=""
  if [ -n "$git_branch" ]; then
    PS1_text="$PS1_text \\[$txtcyn\\]($git_branch)"

    if [ "$GITAWAREPROMPT_MODE" == "EXTENDED" ]; then
      extra_space=""

      ((git_unstaged_files=git_unstaged_added_files+git_unstaged_changed_files+git_unstaged_removed_files))
      if (( git_unstaged_files > 0 )); then
        PS1_text="$PS1_text \\[$txtred\\]+$git_unstaged_added_files ~$git_unstaged_changed_files -$git_unstaged_removed_files"
        extra_space=" "
      fi

      # Count renamed files to changed files.
      ((git_staged_files=git_staged_added_files+git_staged_changed_files+git_staged_removed_files+git_renamed_files))
      if (( git_staged_files > 0 )); then
        ((git_staged_changed_files+=git_renamed_files))
        PS1_text="$PS1_text \\[$txtgrn\\]+$git_staged_added_files ~$git_staged_changed_files -$git_staged_removed_files"
        extra_space=" "
      fi

      PS1_text="$PS1_text\\[$txtrst\\]$extra_space"
    else
      PS1_text="$PS1_text\\[$txtred\\]$git_dirty\\[$txtrst\\]"
    fi

  fi

  export PS1="$PS1_prefix$PS1_text$PS1_postfix "
}

PROMPT_COMMAND="$PROMPT_COMMAND; update_git_PS1"
