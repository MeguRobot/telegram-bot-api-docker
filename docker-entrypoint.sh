#!/bin/sh
set -e

USERNAME=telegram-bot-api
GROUPNAME=telegram-bot-api

if [ -n "$1" ]; then
  exec "$@"
fi

chown -R ${USERNAME}:${GROUPNAME} "${TELEGRAM_WORK_DIR}"

DEFAULT_ARGS="--http-port 8081 --dir=${TELEGRAM_WORK_DIR} --temp-dir=${TELEGRAM_TEMP_DIR} --username=${USERNAME} --groupname=${GROUPNAME}"
CUSTOM_ARGS=""

[ -n "${TELEGRAM_LOG_FILE}" ] && CUSTOM_ARGS=" --log=${TELEGRAM_LOG_FILE}"
[ "${TELEGRAM_STAT}" = "true" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --http-stat-port=8082"
[ "${TELEGRAM_LOCAL}" = "true" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --local"
[ -n "${TELEGRAM_FILTER}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --filter=${TELEGRAM_FILTER}"
[ -n "${TELEGRAM_MAX_WEBHOOK_CONNECTIONS}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --max-webhook-connections=${TELEGRAM_MAX_WEBHOOK_CONNECTIONS}"
[ -n "${TELEGRAM_VERBOSITY}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --verbosity=${TELEGRAM_VERBOSITY}"
[ -n "${TELEGRAM_MAX_CONNECTIONS}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --max-connections=${TELEGRAM_MAX_CONNECTIONS}"
[ -n "${TELEGRAM_PROXY}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --proxy=${TELEGRAM_PROXY}"
[ -n "${TELEGRAM_HTTP_IP_ADDRESS}" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --http-ip-address=${TELEGRAM_HTTP_IP_ADDRESS}"

COMMAND="telegram-bot-api ${DEFAULT_ARGS}${CUSTOM_ARGS}"

echo "$COMMAND"
exec $COMMAND


