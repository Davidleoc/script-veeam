# script-veeam
# 🔍 Monitoramento de Backup Veeam com Nagios

Este script `check_veeam_backup.sh` foi criado para monitorar backups feitos com **Veeam Agent para Linux**, integrando com Nagios ou derivados.

# ☁️ Veeam Backup – Visão Geral

O **Veeam** é uma solução de **backup e recuperação** confiável e robusta, amplamente usada para proteger dados em ambientes físicos, virtuais e em nuvem.

---

## 🛠️ Sobre o Veeam?

O **Veeam Backup & Replication** é uma plataforma que permite:

- Criar backups de servidores físicos e virtuais (Linux, Windows, VMware, Hyper-V).
- Fazer replicações (cópias completas) de VMs.
- Restaurar arquivos, volumes ou sistemas inteiros com rapidez.
- Monitorar e automatizar rotinas de backup.

---

## 🧰 Componentes principais

- **Veeam Agent for Linux/Windows**: agente instalado nos servidores para executar os backups.
- **Veeam Backup Server**: gerencia e agenda os jobs de backup (usado em grandes ambientes).
- **Repositórios de backup**: local onde os arquivos de backup são armazenados.
- **Jobs de backup**: configurações que definem o que, quando e como será feito o backup.

---

## 🔁 Como funciona o processo de backup?

1. **Agendamento**: o Veeam inicia o job conforme configurado (diariamente, semanalmente, etc).
2. **Execução**: o agente identifica os dados a serem copiados e começa o backup.
3. **Compressão & Deduplicação**: os dados são otimizados antes de serem salvos.
4. **Armazenamento**: os dados são salvos no repositório de backup local ou remoto.
5. **Relatório**: logs e status são gerados automaticamente para auditoria.

---

## 📊 Tipos de backup suportados

- **Full** (completo)
- **Incremental** (somente mudanças desde o último backup)
- **Diferencial** (mudanças desde o último full)

---

## 🔄 Restauração

O Veeam permite restaurar:

- Arquivos individuais
- Volumes inteiros
- Sistemas completos (bare metal)
- Aplicações específicas (ex: SQL Server, AD)

---

## 📦 Funcionalidades do Script

- Detecta automaticamente o backup mais recente.
- Verifica:
  - Nome do job
  - Se o backup iniciou ou não
  - Se está em execução
  - Se finalizou
  - Porcentagem de progresso
  - Porcentaagem de pacotes transferidos
  - Armazena os logs dos backups finalizados para auditoria.

---

## 📁 Requisitos

- Veeam Agent instalado
- Acesso ao diretório `/var/log/veeam/Backup`
- bash

---

## ⚙️ Instalação e uso

1. Copie o script para a pasta de plugins:
   ```bash
   /usr/local/nagios/libexec/check_veeam_backup.sh
   chmod +x /usr/local/nagios/libexec/check_veeam_backup.sh
