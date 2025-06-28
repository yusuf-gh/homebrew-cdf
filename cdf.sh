cdf() {
  local current_path="$PWD"
  local selected=""
  local selected_key=""

  while true; do
    # Collecting list of directories
    local entries=()
    while IFS= read -r entry; do
      entries+=("$entry")
    done < <(find "$current_path" -maxdepth 1 -mindepth 1 -not -name '.' 2>/dev/null | sort -f)

    # Including ../, if not in root
    if [[ "$current_path" != "/" ]]; then
      entries=("../" "${entries[@]}")
    fi

    # Dividing hidden and visible directories
    local visible_dirs=()
    local hidden_dirs=()
    for entry in "${entries[@]}"; do
      base="$(basename "$entry")"
      if [[ "$base" == .* ]]; then
        hidden_dirs+=("$base")
      else
        visible_dirs+=("$base")
      fi
    done
    local choices=("${visible_dirs[@]}" "${hidden_dirs[@]}")

    # Running fzf with preview
    local result
    result=$(printf '%s\n' "${choices[@]}" | \
      FZF_DEFAULT_COMMAND="true" \
      fzf \
        --height=100% \
        --layout=reverse \
        --prompt="📁 $current_path > " \
        --preview "
          target='$current_path/{}'
          if [ '{}' = '../' ]; then
            ls -lah --color=always '$current_path/..'
          elif [ -d \"\$target\" ]; then
            ls -lah --color=always \"\$target\"
          elif [ -f \"\$target\" ]; then
            head -n 100 \"\$target\" 2>/dev/null || echo 'failed to read file'
          else
            echo 'unknown type'
          fi
        " \
        --preview-window="right:60%:wrap" \
        --bind "left:accept" \
        --bind "right:accept" \
        --bind "enter:accept" \
        --expect=left,right,enter \
        --header=$'⬆⬇: navigation │ →: enter │ ←: back │ Enter: chose' \
        --ansi \
        --no-sort \
        --cycle \
        --exit-0)

    # Exiting if not chosen
    [[ -z "$result" ]] && return

    # Getting key and chosen element
    selected_key=$(echo "$result" | head -n1)
    selected=$(echo "$result" | tail -n1)

    # Leftward direction processing
    if [[ "$selected_key" == "left" ]]; then
      if [[ "$current_path" != "/" ]]; then
        current_path="$(dirname "$current_path")"
      fi
      continue
    fi

    # Making root
    local next_path="$current_path/$selected"

    # ../
    if [[ "$selected" == "../" ]]; then
      if [[ "$selected_key" == "enter" ]]; then
        cd "$(dirname "$current_path")" || echo "Error: Failed to navigate"
        return
      elif [[ "$selected_key" == "right" ]]; then
        current_path="$(dirname "$current_path")"
        continue
      fi
    #Go inside the directory
    elif [[ -d "$next_path" ]]; then
      if [[ "$selected_key" == "right" ]]; then
        current_path="$next_path"
        continue
      elif [[ "$selected_key" == "enter" ]]; then
        cd "$next_path" || echo "Error: Failed to navigate to $next_path"
        return
      fi
    else
      echo "Error: '$next_path' not a directory or inaccessible"
      continue
    fi
  done
}
