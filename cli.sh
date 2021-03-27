#!/bin/bash

################################################################################
# Bash CLI template
# A more flexible CLI parser (way of parsing)
# 20XX (C) Shakiba Moshiri
################################################################################


################################################################################
# Bash CLI to check BGP route from Hurricane Elective root server which we call:
# Website: https://lg.he.net/
# Commands BGP Route
#
# The website does not have a public API and this script is a work around!
# It may not work in the future, so make sure so you how to read the code for
# later manipulation
################################################################################


################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[1;31m';
_colors_[ 'green' ]='\x1b[1;32m';
_colors_[ 'yellow' ]='\x1b[1;33m';
_colors_[ 'cyan' ]='\x1b[1;36m';
_colors_[ 'white' ]='\x1b[1;37m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}

function print_title(){
    echo $(colorize cyan "$@");
}


################################################################################
# key-value array
################################################################################
declare -A _ip;
_ip['flag']=0;
_ip['args']='';

declare -A _log;
_log['flag']=0;
_log['args']='';

################################################################################
# __help function
################################################################################
function _cli_title(){
    printf "%s\n" "helg (Hurricane Elective Looking Glass)";
    printf "%s\n" "Request to Hurricane Elective for BGP route";
}

function _ip_help(){
    printf "%-25s %s\n" "-I │ --ip" "list of IPs to check";
    printf "%-40s %s\n" "   ├── $(colorize 'yellow' '<IP/MASK>')" "request for these IP/MASK ...";
    printf "%-40s %s\n" "   └── $(colorize 'yellow' '<FILE>')" "read list of IP(s) from a file";
}

function _log_help(){
    printf "%-25s %s\n" "-L │ --log" "enable log for";
    printf "%-40s %s\n" "   ├── $(colorize 'cyan' 'html')" "save the log in HTML format";
    printf "%-40s %s\n" "   ├── $(colorize 'cyan' 'txt')" "save the output in txt";
    printf "%-40s %s\n" "   └── $(colorize 'cyan' 'terminal')" "print result on screen (Terminal)";
}

function _pre_help(){
    printf "%-25s %s\n" "-P │ --pre" "check prerequisites";
    printf "%-40s %s\n" "   ├── $(colorize 'cyan' 'check')" "check prerequisite commands";
    printf "%-40s %s\n" "   └── $(colorize 'cyan' 'show')" "show list of commands is needed";
}


function _help(){
    printf "%-25s %s\n" "-h │ --help" "show / print help";
    echo
    echo "$(_ip_help)"
    echo
    echo "$(_log_help)"
    echo
    echo "$(_pre_help)"
    echo
    echo "$(_cli_title)"
    echo
    echo "Developer Shakiba Moshiri"
    echo "source    https://github.com/k-five/helg"
    exit 0;
}

if [[ ${#} == 0 ]]; then
    _help;
fi

mapfile -t ARGS < <( perl -lne 'print $& while /(?:(?! -)[\s\S])+/ig' <<< "$@");
if [[ ${#ARGS[@]} == 0 ]]; then
    _help;
fi

function get_bgp_route(){
    ip=${1///*/};
    mask=${1//*\/};
    server='core3.fmt1.he.net';

    token_value=$(curl -sL 'https://lg.he.net/' | grep -i token | perl -lne '/(?<=value=").*?(?=")/ && print $&');

    # sample
    # fremont1="&routers%5B%5D=core3.fmt1.he.net&command=bgproute&ip=5.145.115.0%2F24&afPref=preferV6";
    fremont1="&routers%5B%5D=${server}&command=bgproute&ip=${ip}%2F${mask}&afPref=preferV6";
    # echo "token_value $token_value";
    # echo "request $token";

    curl -G -sL 'https://lg.he.net/' \
        -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:86.0) Gecko/20100101 Firefox/86.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        --compressed -H 'Referer: https://lg.he.net/' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Origin: https://lg.he.net' \
        -H 'DNT: 1' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Pragma: no-cache' \
        -H 'Cache-Control: no-cache' \
        --data-urlencode "token=${token_value}" \
        --data-raw "${fremont1}" > ${ip}.html 2> ${ip}.error.html
}

function _ip_call(){
    if [[ ${_ip['flag']} == 1 ]]; then
        if [[ ${#_ip['args']} == 0 ]]; then
            _ip_help;
            exit 0;
        fi
        for arg in ${_ip['args']}; do
            get_bgp_route "$arg";
        done
    fi
}

function _log_call(){
    echo "_log_call";
    echo "flag: ${_log['flag']}";
    echo "args: ${_log['args']}";
}

for arg in "${ARGS[@]}"; do
    mapfile -t _options_ < <(tr ' ' '\n' <<< "$arg");

    case ${_options_[0]} in
        -I | --ip )
            _ip['flag']=1;
            _ip['args']=${_options_[@]:1}
            _ip_call;
        ;;
        -L | --log)
            _log['flag']=1;
            _log['args']=${_options_[@]:1}
            _log_call;
        ;;
        -h | --help )
            _help;
        ;;
        * )
            echo "unknown options: ${_options_[0]}";
        ;;
    esac
done
