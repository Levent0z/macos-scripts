alias flushdns='sudo killall -HUP mDNSResponder; say dns cleared successfully'
alias ipv='ip utun2'
alias ports1='lsof -iTCP -sTCP:LISTEN -P -n' # Show Open ports
alias ports2='netstat -an'                   # Show Open ports
alias whoareyou='hostname | cut -d"." -f1'   # First part of FQDN

function ip() {
  local NAME=en0
  if [[ -n "$1" ]]; then
    NAME="$1"
  fi
  ifconfig "$NAME" | egrep "^\s*inet\s" | cut -d' ' -f2
}

# Get mac addresss
function mac() {
  local NAME=en0
  if [[ -n "$1" ]]; then
    NAME="$1"
  fi
  ifconfig "$NAME" | egrep "^\s*ether" | cut -d' ' -f2
}

# Simple Web server, requires python 2 or 3
function serve() {
  if [ -z $1 ]; then
    PORT=8080
  else
    PORT=$1
  fi
  echo http://localhost:$PORT

  PYVER=$(python --version 2>&1 | cut -d ' ' -f2 | cut -d '.' -f1)
  if [ $PYVER -eq 2 ]; then
    python -m SimpleHTTPServer $PORT >/dev/null
  elif [ $PYVER -eq 3 ]; then
    python -m http.server $PORT
  else
    echo 'Unused Python version'
  fi
}

# SSH stuff
SUFFIX=$(hostname | cut -d'.' -f1)
export SSHARGS="-i $HOME/.ssh/id_rsa_$SUFFIX -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=QUIET"
alias scpx="scp $SSHARGS"
alias sshi="ssh -i $SSHARGS" # Specify hostname (FQDN) when calling
