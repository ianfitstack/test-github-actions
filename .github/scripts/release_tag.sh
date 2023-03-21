#!/bin/bash

# release_tag.sh
#
# auto-increments and generates next tag value or validates provided tag value
#

RELEASE_TAG_REGEX='(^[0-9]+\.[0-9]+)\.([0-9]+)$'
RELEASE_TAG_LATEST="$(git tag | egrep $RELEASE_TAG_REGEX | sort -V | tail -n 1)"

RELEASE_TAG_OVERRIDE="$1"
if [[ -n "$RELEASE_TAG_OVERRIDE" ]];then
    if [[ ! $RELEASE_TAG_OVERRIDE =~ $RELEASE_TAG_REGEX ]]; then
        echo "$RELEASE_TAG_OVERRIDE is not a valid release tag, which must be in the format MAJOR.MINOR.PATCH"
        exit 1
    elif [[ ! $RELEASE_TAG_OVERRIDE == $(echo -e "${RELEASE_TAG_LATEST}\n${RELEASE_TAG_OVERRIDE}" | sort -V | tail -n 1 | tr -d '\n') ]]; then
        echo "Provided release tag $RELEASE_TAG_OVERRIDE is not greater than the latest tag $RELEASE_TAG_LATEST"
        exit 1
    elif [[ $RELEASE_TAG_OVERRIDE == $RELEASE_TAG_LATEST ]]; then
        echo "Provided tag $RELEASE_TAG_OVERRIDE is already present"
        exit 1
    fi

    RELEASE_TAG="$RELEASE_TAG_OVERRIDE"
else
    RELEASE_TAG_MAJOR_MINOR=$(echo $RELEASE_TAG_LATEST | sed -E "s/${RELEASE_TAG_REGEX}/\1/")
    RELEASE_TAG_PATCH=$(echo $RELEASE_TAG_LATEST | sed -E "s/${RELEASE_TAG_REGEX}/\2/")
    RELEASE_TAG="${RELEASE_TAG_MAJOR_MINOR}.$((RELEASE_TAG_PATCH+=1))"
fi

echo $RELEASE_TAG