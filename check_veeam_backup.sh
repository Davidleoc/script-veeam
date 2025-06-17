#!/bin/bash

# Caminho base onde os logs das sessões estão
SESSION_BASE="/var/log/veeam/Backup"
LOGS_PATHS=$(find "$SESSION_BASE" -type f -name "Job.log" -mmin -10 2>/dev/null)

if [ -z "$LOGS_PATHS" ]; then
  echo "UNKNOWN: Nenhum backup em execucao no momento (Job.log recente nao encontrado)"
  exit 4
fi

# Pega o Job.log mais recente entre os encontrados
LOGS_PATH=$(echo "$LOGS_PATHS" | sort -r | head -n1)

# Extrai o nome do job a partir do caminho
JOB_NAME=$(echo "$LOGS_PATH" | sed -E 's#.*/Backup/(.+)/Session_.*/Job.log#\1#')

# Extrai a última linha com progresso do backup
PROGRESS_LINE=$(grep -oP 'Session progress:\s*\K[0-9]{1,3}(?=%)' "$LOGS_PATH" | tail -n1)
if [[ "$PROGRESS_LINE" == "" ]]; then
            PROGRESS="Desconhecido"
else
            PROGRESS="$PROGRESS_LINE"
            PROGRESS=${PROGRESS:-"0"}
fi

# Extrai a última linha com taxa de processamento (speed)
SPEED_LINE=$(grep -i "Session progress" "$LOGS_PATH" | grep -Eo 'speed:\s*[0-9]+' | tail -n1)
if [[ "$SPEED_LINE" == "" ]]; then
        RATE="Desconhecido"
else
        SPEED=$(echo "$SPEED_LINE" | grep -oP '[0-9]+')
        SPEED_KB=$((SPEED / 1024))
        RATE="${SPEED_KB} KB/s"
fi

# Verifica se o backup foi finalizado
if grep -qi "Backup finished" "$LOGS_PATH"; then
    STATUS="FINALIZADO"
    # Salvar o log em diretório de auditoria
    LOG_OUTPUT_DIR="/var/log/nagios/veeam_backups"
    mkdir -p "$LOG_OUTPUT_DIR"
    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
    cp "$LOGS_PATH" "$LOG_OUTPUT_DIR/backup_${JOB_NAME// /_}_$TIMESTAMP.log"
else
    STATUS="EM EXECUCAO"
fi

echo "OK: Backup '$JOB_NAME' $STATUS, Progresso: ${PROGRESS}%, Taxa: ${RATE}"
exit 0

