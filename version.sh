#!/usr/bin/env bash

# telecc/docker-example-1.11.2

SEMVER_REGEX="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"

VER_REGEX=()
VER_REGEX[1]="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$"
VER_REGEX[2]="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\-([a-z0-9]{1,})$"
VER_REGEX[3]="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\-([0-9]*)\\-([a-z0-9]*)$"
VER_REGEX[4]="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\-([a-z0-9]{1,})\\-([0-9]{1,})\\-([a-z0-9]{1,})$"
VER_REGEX[5]="^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\-([a-z0-9]{1,})\\-([a-z0-9]{1,})$"

set -o errexit -o nounset -o pipefail

function usage-help {
    echo "usage-help"
}

function usage-version {
    echo "usage-version"
}

function error {
  echo -e "$1" >&2
  exit 1
}

function command-validate-version {
  local version=$1
  if [[ "$version" =~ $SEMVER_REGEX ]]; then
    echo -e "[Pass] version $version is valid"
  else
    error "version $version does not match the semver scheme 'X.Y.Z(-PRERELEASE)(+BUILD)'. See help for more information."
  fi
}

function command-get-ext {
    local part version version_type
    local version_type=0

    if [[ "$#" -ne "2" ]] || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        usage-help
        exit 0
    fi

    part="$1"
    version="$2"

    # remove ^v | ^v.
    version=`echo ${version} | sed 's/^v\.\?//g'`

    for index in ${!VER_REGEX[*]}
    do
        if [[ "$version" =~  ${VER_REGEX[$index]} ]] ; then version_type=$index; parts=("${BASH_REMATCH[@]}"); fi
    done

    # echo "${version} Pattern matched ${version_type}"
    if [[ "$version_type" -eq "0" ]]; then error "unknown type of pre-semantic version" ; fi

    local major="${parts[1]}"
    local minor="${parts[2]}"
    local patch="${parts[3]}"

    case "t$version_type" in
        "t1")
            local revision=""
            local meta=""
            local meta_sha=""
            local ci_short="${major}.${minor}.${patch}"
            local ci_brief="${major}.${minor}"
            local ci_long="${ci_short}"
        ;;
        "t2")
            local revision="${parts[4]}"
            local meta=""
            local meta_sha=""
            local ci_short="${major}.${minor}.${patch}-${revision}"
            local ci_brief="${major}.${minor}"
            local ci_long="${ci_short}"
        ;;
        "t3")
            local revision=""
            local meta="${parts[4]}"
            local meta_sha="${parts[5]}"
            local ci_short="${major}.${minor}.${patch}"
            local ci_brief="${major}.${minor}"
            local ci_long="${ci_short}+${meta}.sha.${meta_sha}"
        ;;
        "t4")
            local revision="${parts[4]}"
            local meta="${parts[5]}"
            local meta_sha="${parts[6]}"
            local ci_short="${major}.${minor}.${patch}-${revision}"
            local ci_brief="${major}.${minor}"
            local ci_long="${ci_short}+${meta}.sha.${meta_sha}"
        ;;
        "t5")
            local revision="${parts[4]}-${parts[5]}"
            local meta=""
            local meta_sha=""
            local ci_short="${major}.${minor}.${patch}-${revision}"
            local ci_brief="${major}.${minor}"
            local ci_long="${ci_short}"
        ;;
        *) error "unexpected type of pre-semantic version=${version_type}" ;;
    esac

    case "$part" in
        major|minor|patch|revision|meta|meta_sha|ci_short|ci_brief|ci_long) echo "${!part}" ;;
        *) error "unexpected part=${part}" ;;
    esac

    exit 0
}



case $# in
  0) echo "Unknown command: $*"; usage-help;;
esac

case $1 in
  --help|-h) echo -e "$USAGE"; exit 0;;
  --version|-v) usage-version ;;
  get) shift; command-get-ext "$@";;
  validate) shift; command-validate-version "$@";;
  *) echo "Unknown arguments: $*"; usage-help;;
esac
