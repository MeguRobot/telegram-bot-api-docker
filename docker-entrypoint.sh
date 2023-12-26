#!/bin/sh
set -e

USERNAME=telegram-bot-api
GROUPNAME=telegram-bot-api
USER_UID=${USER_UID:-101}
USER_GID=${USER_GID:-101}
HTTP_PORT=${HTTP_PORT:-8081}
STAT_PORT=${STAT_PORT:-8082}

CURRENT_USER_ID=$(id -u ${USERNAME} 2>/dev/null || true)
CURRENT_GROUP_ID=$(getent group ${GROUPNAME} | cut -d: -f3 2>/dev/null || true)

if [ -z "${CURRENT_GROUP_ID}" ] || [ "${CURRENT_GROUP_ID}" -ne "${USER_GID}" ]; then
    delgroup ${GROUPNAME} 2>/dev/null || true
    addgroup -g ${USER_GID} -S ${GROUPNAME}
fi

if [ -z "${CURRENT_USER_ID}" ] || [ "${CURRENT_USER_ID}" -ne "${USER_UID}" ]; then
    deluser ${USERNAME} 2>/dev/null || true
    adduser -S -D -H -u ${USER_UID} -h ${TELEGRAM_WORK_DIR} -s /sbin/nologin -G ${GROUPNAME} -g ${GROUPNAME} ${USERNAME}
fi

if [ "$(id -g ${USERNAME})" -ne "${USER_GID}" ]; then
    usermod -g ${USER_GID} ${USERNAME}
fi

mkdir -p ${TELEGRAM_WORK_DIR} ${TELEGRAM_TEMP_DIR}
chown -R ${USERNAME}:${GROUPNAME} "${TELEGRAM_WORK_DIR}"

if [ -n "$1" ]; then
  exec "$@"
fi

CUSTOM_ARGS=""
DEFAULT_ARGS="--http-port ${HTTP_PORT} --dir=${TELEGRAM_WORK_DIR} --temp-dir=${TELEGRAM_TEMP_DIR} --username=${USERNAME} --groupname=${GROUPNAME}"
[ -n "${TELEGRAM_LOG_FILE}" ] && CUSTOM_ARGS=" --log=${TELEGRAM_LOG_FILE}"
[ "${TELEGRAM_STAT}" = "true" ] && CUSTOM_ARGS="${CUSTOM_ARGS} --http-stat-port=${STAT_PORT}"
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