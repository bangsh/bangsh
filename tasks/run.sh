function btask.run.run () {
  local working_dir="$(b.get bang.working_dir)"
  local file="$1"
  shift

  # If "$file" is not an absolute path
  if [ "${file:0:1}" != "/" ]; then
    file="$working_dir/$file"
  fi

  if b.path.file? "$file"; then
    local base_path="$(dirname "$file")"

    # Preloading modules and tasks
    b.path.dir? "$base_path/modules" && b.preload "$base_path/modules"
    b.path.dir? "$base_path/tasks" && b.preload "$base_path/tasks"

    . "$file"
  else
    b.abort "Could not run '$file' because it is not a file."
  fi
}
