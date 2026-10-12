#!/bin/bash
# Authorization from Step 2:
# OR, GitHub App information:
export GITHUB_APP_ID=1433217
export GITHUB_APP_INSTALL_ID=72204419
export GITHUB_APP_PEM="$(cat okd-runners.2025-06-20.private-key.pem)"
# For an org runner, this is the org.
# For a repo runner, this is the repo owner (org or user).
export GITHUB_OWNER=Solar-Diplomski
# For an org runner, omit this argument.
# For a repo runner, the repo name.
#export GITHUB_REPO=openshift-actions-runner-chart
# Helm release name to use.
export RELEASE_NAME=actions-runner

# If you cloned the repository (eg. to edit the chart)
# replace openshift-actions-runner/actions-runner below with the directory containing Chart.yaml.

# Installing using PAT Auth
# helm install $RELEASE_NAME openshift-actions-runner/actions-runner \
#     --set-string githubPat=$GITHUB_PAT \
#     --set-string githubOwner=$GITHUB_OWNER \
#     --set-string githubRepository=$GITHUB_REPO \
# && echo "---------------------------------------" \
# && helm get manifest $RELEASE_NAME | kubectl get -f -

# OR, Installing using App Auth
helm install $RELEASE_NAME openshift-actions-runner/actions-runner \
    --set-string githubAppId=$GITHUB_APP_ID \
    --set-string githubAppInstallId=$GITHUB_APP_INSTALL_ID \
    --set-string githubAppPem="$GITHUB_APP_PEM" \
    --set-string githubOwner=$GITHUB_OWNER \
    --set runnerImage=image-registry.openshift-image-registry.svc:5000/github-runners/openshift-custom-runner \
    --set runnerTag=latest \
    --set runnerLabels="{ openshift, dependabot }" \
    --set runnerGroup=Openshift \
&& echo "---------------------------------------" \
&& helm get manifest $RELEASE_NAME | kubectl get -f -