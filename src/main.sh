#!/bin/bash -eu

cookbookDir=$1
recipeName=$2

sandboxDir=$PWD/.sandbox/
sandboxCookbooksDir=$sandboxDir/

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
    runRecipe || cleanupSandbox
}

function cleanupSandbox() {
    rm -r $sandboxDir/
}

runRecipeClean
