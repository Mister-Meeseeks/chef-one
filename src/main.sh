#!/bin/bash -eu

scriptDir=$(dirname $(readlink -f $0))

if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]] ; then
    helpMsg=$scriptDir/help.txt
    cat $helpMsg
    exit 0
fi

cookbookDir=$1
recipeName=$2

sandboxDir=$PWD/.sandbox/
sandboxCookbooksDir=$sandboxDir/cookbooks/

function prepareSandbox() {
    mkdir -p $sandboxCookbooksDir
}

function versionBerks() {
    cd $cookbookDir
    berks vendor $sandboxCookbooksDir/
}

function runCapsuledRecipe() {
    cd $sandboxDir
    chef-client -z -o $recipeName
}

function runRecipe() {
    prepareSandbox
    versionBerks
    runCapsuledRecipe
}

function runRecipeClean() {
    (runRecipe && cleanupSandbox) \
	|| cleanupSandbox
}

function cleanupSandbox() {
    rm -r $sandboxDir/
}

runRecipeClean
