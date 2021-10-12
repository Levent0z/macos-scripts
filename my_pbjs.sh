# protobufjs
PBJSPATH="$HOME/github/protobufjs/protobuf.js/cli/bin"

if [[ -d $PBJSPATH ]]; then
    echo 'Activating Protobuf.js CLIs: You can now use pbjs or pbts.'
    chmod +x $PBJSPATH/pbjs
    chmod +x $PBJSPATH/pbts
    export PATH=$PBJSPATH:$PATH
fi

# Proto
function pbjson() {
    if [ -z $1 ]; then
        echo 'Please provide the base filename of the proto file, without the proto extension'
        return 1
    fi
    pbjs -t json-module -w commonjs -o "$1.js" "$1.proto"
}
