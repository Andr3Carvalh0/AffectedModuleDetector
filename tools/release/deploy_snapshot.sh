#!/bin/bash
#
# Deploy a jar, source jar, and javadoc jar to Sonatype's snapshot repo.
#
# Adapted from https://coderwall.com/p/9b_lfq and
# http://benlimmer.com/2013/12/26/automatically-publish-javadoc-to-gh-pages-with-travis-ci/

BRANCH="main"

set -e

if [ "${GITHUB_REF##*/}" != "$BRANCH" ]; then
  echo "Skipping snapshot deployment: wrong branch. Expected '$BRANCH' but was '${GITHUB_REF##*/}'."
else
  echo "Deploying AffectedModuleDetector..."
  openssl aes-256-cbc -md sha256 -d -in tools/release/secring.gpg.aes -out tools/release/secring.gpg -k "${ENCRYPT_KEY}"
  # https://docs.gradle.org/current/userguide/signing_plugin.html#sec:signatory_credentials

  ./gradlew publishMavenPublicationToMavenRepository -PSONATYPE_NEXUS_USERNAME="${SONATYPE_USERNAME}" -PSONATYPE_NEXUS_PASSWORD="${SONATYPE_PASSWORD}" -Psigning.keyId="${SIGNING_ID}" -Psigning.password="${SIGNING_PASSWORD}" -Psigning.secretKeyRingFile=${PWD}/tools/release/secring.gpg
  echo "AffectedModuleDetector deployed!"
fi