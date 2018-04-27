# Webserver

srv() {
  local DIR=${1:-.}
  local AVAILABLE_PORT=$(get-port)
  local PORT=${2:-$AVAILABLE_PORT}
  if [ "$PORT" -le "1024" ]; then
    sudo -v
  fi
  open "http://localhost:$PORT"
  superstatic "$DIR" -p "$PORT"
}

# Get IP from hostname

hostname2ip() {
  ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
}

# Upload file to transfer.sh
# https://github.com/dutchcoders/transfer.sh/

transfer() {
  tmpfile=$( mktemp -t transferXXX )
  curl --progress-bar --upload-file "$1" https://transfer.sh/$(basename $1) >> $tmpfile;
  cat $tmpfile;
  rm -f $tmpfile;
}

# Find real from shortened url

unshorten() {
  curl -sIL $1 | sed -n 's/Location: *//p'
}
