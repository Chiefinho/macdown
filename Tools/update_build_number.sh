#!/bin/bash

# Writes the version into a header that Xcode uses when preprocessing
# Info.plist (INFOPLIST_PREFIX_HEADER). Editing the built Info.plist directly
# does not work with the new build system, which processes Info.plist after
# this phase and overwrites the edits.
HEADER="${DERIVED_FILE_DIR}/MPInfoPlistVersion.h"
mkdir -p "$(dirname "$HEADER")"

write_header() {
    printf '#define MP_BUILD_VERSION %s\n#define MP_SHORT_VERSION %s\n#define MP_BUNDLE_VERSION %s\n' \
        "$1" "$2" "$3" > "$HEADER"
}

if [ "${CI:-}" == "true" ]; then
    echo "Using placeholder version under CI (shallow clone has no tags)."
    write_header "ci" "$(cat "$(dirname "$0")/version.txt")" "1"
    exit 0
fi

# Source: https://gist.github.com/karlvr/c93a98d7000ecb163895

# This script automatically sets the version and short version string of
# an Xcode project from the Git repository containing the project.
#
# To use this script in Xcode, add the script's path to a "Run Script" build
# phase for your application target.

set -o errexit
set -o nounset

pushd `dirname $0` > /dev/null
source $(pwd -P)/utils.sh
popd > /dev/null

BUILD_VERSION=$(get_build_version)
SHORT_VERSION=$(get_short_version)
BUNDLE_VERSION=$(get_bundle_version)

# Alternatively, we could use Xcode's copy of the Git binary,
# but old Xcodes don't have this.
#GIT=$(xcrun -find git)

write_header "$BUILD_VERSION" "$SHORT_VERSION" "$BUNDLE_VERSION"
echo "Version: $SHORT_VERSION ($BUNDLE_VERSION), build $BUILD_VERSION"
