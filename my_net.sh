alias flushdns='sudo killall -HUP mDNSResponder; say dns cleared successfully'
alias ips='ifconfig | egrep "\d+\.\d+\.\d+\.\d+"'
alias ipv='ip utun0'
alias ports1='lsof -iTCP -sTCP:LISTEN -P -n' # Show Open ports
alias ports1x="ports1 | 
  grep -v -e idea -e java -e ssh -e Rancher -e Postman -e 'figma*' -i -e 'Logi*' -e 'Cisco*' -e 'Code*' -e 'OneDrive' -e 'TechSmith' -e 'Oracle*' -e 'qemu-*' -e 'steve' -e 'limactl' |
  tail +2 |
  cut -d':' -f2 |
  cut -d' ' -f1 | 
  xargs printf 'http://localhost:%s\n'
"
function ports1y() {
  A=$(ports1x); echo "$A"; echo "$A" | xargs -n1 curl --silent | grep -oE 'src="[^"]+"' | cut -d'"' -f2 | grep -v 'js/main.bundle.js'
}

function ports1z() {
  local urls
  urls=$(ports1x)
  while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    matches=$(curl --silent "$url" | grep -oE 'src="[^"]+"' | cut -d'"' -f2 | grep -v 'js/main.bundle.js' || true)
    if [[ -n "$matches" ]]; then
      while IFS= read -r match; do
        [[ -z "$match" ]] && continue
        printf '%s\t%s\n' "$url" "$match"
      done <<< "$matches"
    else
      printf '%s\t\n' "$url"
    fi
  done <<< "$urls"
}
alias ports2='netstat -an'                   # Show Open ports
alias whoareyou='hostname | cut -d"." -f1'   # First part of FQDN

function ip() {
  local NAME=en0
  if [[ -n "$1" ]]; then
    NAME="$1"
  fi
  ifconfig "$NAME" | egrep "^\s*inet\s" | cut -d' ' -f2
}

alias inet='ifconfig | grep -C 4 "inet "'

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


# Launch Chrome without web security
alias nocors='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security --user-data-dir="/tmp"'

# Capture URLs
alias url-cap-start='echo "Enter sudo password. Capture file: dns_capture.pcap. Press CTRL+C to end capture"; sudo tcpdump -i any -n port 53 -w dns_capture.pcap'
alias url-cap-dump="tcpdump -r dns_capture.pcap -n 2>/dev/null | grep -oE 'A\? [^ ]+' | cut -d' ' -f2 | sort -u"


function getPidOfPort() {
  lsof -t -sTCP:LISTEN "-iTCP:$1"
}

function killPort() {
  getPidOfPort "$1" | xargs kill
}
