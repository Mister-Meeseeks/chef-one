#!/bin/bash -eu

scriptDir=$(dirname $(readlink -f $0))

if [[ $# -eq 0 || $1 == "--help" || $1 == "-h" ]] ; then
    helpMsg=$scriptDir/help.txt
    cat $helpMsg
    exit 0
fi

dataBagDir=/dev/null
if [[ $1 == "--bags" ]] ; then
    dataBagDir=$2
    shift 2;
fi

cookbookDir=$1

recipeName=""
if [[ $# -gt 1 ]] ; then
    recipeName=$2
fi

cookbookName=$(basename $cookbookDir)
if [[ -z $recipeName ]] ; then
    runItem=$cookbookName
else
    runItem=$cookbookName::$recipeName
fi

sandboxDir=$PWD/.chef_one_sandbox/
sandboxCookbooksDir=$sandboxDir/cookbooks/
sandboxDatabagDir=$sandboxDir/data_bags/

function prepareSandbox() {
    mkdir -p $sandboxCookbooksDir
    sandboxDataBags
}

function sandboxDataBags() {
    sandboxDataBagDir $(extractBookRelativeBag)
    sandboxDataBagDir $dataBagDir
}

function sandboxDataBagDir() {
    local targetDatabagDir=$1
    if [[ -d $targetDatabagDir ]] ; then
	cp -r $targetDatabagDir/* $sandboxDatabagDir/
    fi
}

function extractBookRelativeBag() {
    echo $(dirname $(dirname $cookbookDir))/data_bags/
}

function versionBerks() {
    cd $cookbookDir
    berks vendor $sandboxCookbooksDir/
}

function runCapsuledRecipe() {
    cd $sandboxDir
    chef-client -z -o $runItem
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
