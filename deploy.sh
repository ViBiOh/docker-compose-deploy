#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  docker image prune -f
  docker network prune -f
  docker volume prune -f
}

deploy() {
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'
  local BLUE='\033[0;34m'
  local RESET='\033[0m'

  if [[ "${#}" -lt 1 ]]; then
    printf "${RED}Usage: deploy [PROJECT_NAME] [DOCKER-COMPOSE-FILE]${RESET}"

    return 1
  fi

  local PROJECT_NAME="${1}"
  local COMPOSE_FILE="${2:-docker-compose.yml}"

  printf "${BLUE}Starting services of ${PROJECT_NAME}${RESET}\n"

  docker-compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" config -q
  docker-compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" pull -q
  docker-compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" up -d --remove-orphans

  printf "${BLUE}Logs for services of ${PROJECT_NAME}${RESET}\n"

  docker-compose -p "${PROJECT_NAME}" -f "${COMPOSE_FILE}" logs

  printf "${BLUE}Cleaning${RESET}\n"
  clean

  printf "${GREEN}Deploy successful! ${RESET}\n"
}

deploy "${@}"
