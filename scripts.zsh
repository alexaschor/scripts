# create venv
function pyinit() {
    target=$PWD;

    if [ "$#" -gt 0 ]; then
        target=$@;
    fi

    python3 -m venv $target/.venv

    cd $target

    pyactivate

}

# activate venv
function pyactivate() {
    source .venv/bin/activate
}

# re-source zshrc
function srczsh() {
    source ~/.zshrc
}

# get my ip
function myip() {
    echo `ipconfig getifaddr en0`
}

# quicklook file
function ql(){
    qlmanage -p "$@" > /dev/null 2>&1
}

# get documentation for a flag
function flag() {
  local cmd=$1 opt=$2
  [[ $opt == -* ]] || { (( ${#opt} == 1 )) && opt="-$opt" || opt="--$opt"; }
  man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
}

# cp to temp directory
function cptemp(){
	zmodload zsh/zutil
	zparseopts -D -a opts 'n'

	local tmp=`mktemp -d /tmp/TEMP_XXXX`
	cp -r $@ $tmp

	if [[ $opts == "-n" ]]; then
		echo $tmp;
	else
		cd $tmp;
	fi
}

# mv to temp directory
function mvtemp(){
	zmodload zsh/zutil
	zparseopts -D -a opts 'n'

	local tmp=`mktemp -d /tmp/TEMP_XXXX`
	mv -r $@ $tmp

	if [[ $opts == "-n" ]]; then
		echo $tmp;
	else
		cd $tmp;
	fi
}

# clean temp dirs
function cltemp() {
	echo "Cleaning temp dirs created by cptemp/mvtemp:"
	ls /tmp/ | grep -x 'TEMP_.*'| xargs printf -- '/tmp/%s\n' | xargs tree

	if read -q "confirm?Remove all listed files/directories?"
	then
		ls /tmp/ | grep -x 'TEMP_.*'| xargs printf -- '/tmp/%s\n' | xargs rm -rf
	fi
}

# alias for tldr
alias "?"="tldr"

# alias for hexyl
alias "xxh"="hexyl"

# alias for nvim
alias "vim"="nvim"

# alias for ranger
alias "r"="ranger"

function hl() {

	zparseopts -D -a opts 'l'

	declare -A color_map
	color_map[red]=31
	color_map[bred]=41

	color_map[green]=32
	color_map[bgreen]=42

	color_map[yellow]=33
	color_map[byellow]=43

	color_map[blue]=34
	color_map[bblue]=44

	color_map[magenta]=35
	color_map[bmagenta]=45

	color_map[cyan]=36
	color_map[bcyan]=46
	 
	colorcode=$(echo -e "\e[${color_map[$1]}m")
	reset=$'\e[0m'

	if [[ $opts == "-l" ]]; then	
		sed -u s"/\(.*$2.*\)/$colorcode\1$reset/g"
	else
		sed -u s"/$2/$colorcode$2$reset/g"
	fi
}
