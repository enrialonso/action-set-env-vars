#!/bin/bash

ACTION_CONTEXT=${{ inputs.context }}

echo "Context Name: ${ACTION_CONTEXT}"
echo "Ref Name: ${GITHUB_REF_NAME}"

if [[ "${GITHUB_REF_NAME}" == "main" ]]; then
    export ENV=pro
elif [[ "${GITHUB_REF_NAME}" == feature* ]]; then
    export ENV=dev
elif [[ "${GITHUB_REF_NAME}" == "develop" ]]; then
    export ENV=dev
elif [[ "${GITHUB_REF_NAME}" == release* ]]; then
    export ENV=qa
else
    echo "Error: Verifica el nombre de la rama"
    exit 1
fi

echo "Env Selected: ${ENV}"
echo "ENV=${ENV}" >> $GITHUB_ENV

while IFS='=' read -r NAME VALUE; do
  if [[ -n "${NAME}" ]]; then
    echo "${NAME}=${VALUE}" >> $GITHUB_ENV
  fi
done < "${{ inputs.env_path }}/${ACTION_CONTEXT}-${ENV}.env"