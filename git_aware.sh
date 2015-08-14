get_git_porcelain_status() {
  git_porcelain_status=$(git status --porcelain 2> /dev/null)
}

find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="$branch"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  if [[ "$git_porcelain_status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

find_git_file_changes() {
  if [ -n "$git_branch" ]; then
    git_staged_added_files=0
    git_staged_changed_files=0
    git_staged_removed_files=0

    git_unstaged_added_files=0
    git_unstaged_changed_files=0
    git_unstaged_removed_files=0

    git_renamed_files=0

    # Need to manipulate IFS so preceding and leading spaces are not trimmed.
    local old_IFS="$IFS"
    IFS=""

    while read line; do
      if [[ "$line" == ?"M"* ]]; then
        ((git_unstaged_changed_files++))
      fi

      if [[ "$line" == "M"* ]]; then
        ((git_staged_changed_files++))
      fi

      if [[ "$line" == ?"D"* ]]; then
        ((git_unstaged_removed_files++))
      fi

      if [[ "$line" == "D"* ]]; then
        ((git_staged_removed_files++))
      fi

      if [[ "$line" == "??"* ]]; then
        ((git_unstaged_added_files++))
      fi

      if [[ "$line" == "A"* ]]; then
        ((git_staged_added_files++))
      fi

      if [[ "$line" == "R"* ]]; then
        ((git_renamed_files++))
      fi
    done <<< "$git_porcelain_status"

    IFS="$old_IFS"
  else
    git_staged_added_files=""
    git_staged_changed_files=""
    git_staged_removed_files=""

    git_unstaged_added_files=""
    git_unstaged_changed_files=""
    git_unstaged_removed_files=""

    git_renamed_files=""
  fi
}

PROMPT_COMMAND="get_git_porcelain_status; find_git_branch; find_git_dirty; find_git_file_changes; $PROMPT_COMMAND"
