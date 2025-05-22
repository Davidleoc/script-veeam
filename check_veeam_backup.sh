#!/bin/bash
 
# Caminho base onde os logs das sessões estão
SESSION_BASE="/var/log/veeam/Backup"
LOGS_PATH=$(find "$SESSION_BASE" -type f -name "Job.log" 2>/dev/null | sort -r | head -n1)
 
if [ -z "$LOGS_PATH" ]; then
  echo "CRITICAL: Nenhum arquivo Job.log encontrado"
  exit 2
fi
 
# Extrai o nome do job a partir do caminho
JOB_NAME=$(echo "$LOGS_PATH" | sed -E 's#.*/Backup/(.+)/Session_.*/Job.log#\1#')
 
# Extrai o progresso do backup (última linha com "percent")
PROGRESS=$(grep -iE "percent|progress" "$LOGS_PATH" | tail -n1 | grep -oE '[0-9]{1,3}%' || echo "Desconhecido")
 
# Verifica se o backup foi finalizado
if grep -qi "Backup finished" "$LOGS_PATH"; then
    STATUS="FINALIZADO"
    # Salvar o log em diretório de auditoria
    LOG_OUTPUT_DIR="/var/log/nagios/veeam_backups"
    mkdir -p "$LOG_OUTPUT_DIR"
    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
    cp "$LOGS_PATH" "$LOG_OUTPUT_DIR/backup_${JOB_NAME// /_}_$TIMESTAMP.log"
else
    STATUS="EM EXECUÇÃO"
fi
 
echo "OK: Backup '$JOB_NAME' $STATUS, progresso: $PROGRESS"
exit 0
