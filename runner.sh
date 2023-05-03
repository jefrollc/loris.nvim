#!/usr/bin/zsh

get_interpreter() {
  shebang=$(head -n 1 "$1")

  if [[ ! $shebang =~ ^#! ]]; then
    if [[ $shebang =~ ^"//usr/bin/env go run" ]]; then
      # This doesn't work yet
      echo "/usr/bin/go run temp.zig"
      return
    fi
    # herf durf, switch statement!
    if [[ $shebang =~ ^"//usr/bin/env zig run" ]]; then
      echo "/tmp/temp.zig"
      return
    fi
    echo "Must have a shebang at the start"
    exit 1
  fi

  interpreter=$(echo "$shebang" | sed 's/^#! *//' | xargs)

  if [ -z "$interpreter" ]; then
    echo "Invalid shebang: $shebang"
    exit 1
  fi

  echo "$interpreter"
}

temp_file="/tmp/temp.zig"

while true; do
  inotifywait -q -e close_write,moved_to,create -r "$temp_file"
  printf '\033c'

  if [ ! -f "$temp_file" ]; then
    echo "File not found: $temp_file"
    exit 1
  fi

  interpreter=$(get_interpreter "$temp_file")
  chmod +x "$temp_file"
  # echo "Interpreter: $interpreter"
  # echo "File       : $temp_file"
  eval "$interpreter" "\"$temp_file\""
done


