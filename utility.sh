#!/usr/bin/env bash

BKP_PREFIX="BKP"

source $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/color.sh

function getDiffDay()
{
    local someDate=$1
    local diffDays=$2
    echo $(date +%Y%m%d -d "${someDate} ${diffDays} days")
    return 0
}


function getFirstDayOfMonth()
{
    local someDate=$1
    local thisYearMonth=`date +"%Y%m" -d "${someDate}"`
    local firstDayOfDate="${thisYearMonth}01"

    echo $firstDayOfDate
    return 0
}


function getTotalDaysOfMonth()
{
    local someDate=$1
    local totalDays=`cal $(date +"%m %Y" -d "${someDate}") | awk 'NF {DAYS = $NF}; END {print DAYS}'`

    echo $totalDays
    return 0
}


function getLastDayOfMonth()
{
    local someDate=$1
    local addOneDay=$2

    local totalDays=$(getTotalDaysOfMonth "${someDate}")
    local thisYearMonth=`date +"%Y%m" -d "${someDate}"`
    local lastDayOfDate="${thisYearMonth}${totalDays}"

    if [ "${addOneDay}" = "y" ];then
        echo $(getDiffDay ${lastDayOfDate} 1)
    else
        echo $lastDayOfDate
    fi
    return 0
}


function getFirstDayOfYear()
{
    local someDate=$1
    echo $(date +%Y0101 -d ${someDate})
    return 0
}


function getLastDayOfYear()
{
    local someDate=$1
    local addOneDay=$2

    local lastDay=$(date +%Y1231 -d ${someDate})
    if [ "${addOneDay}" = "y" ];then
        echo $(getDiffDay ${lastDay} 1)
    else
        echo $lastDay
    fi
    return 0
}


function getFirstDayOfWeek()
{
    local someDate=$1
    local weekDay=$(date +%u -d ${someDate})
    if [ $weekDay -eq 1 ];then
        echo $someDate
    else
        local addDays=$(( $weekDay - 1))
        echo $(date +%Y%m%d -d "${someDate} -${addDays} days")
    fi
    return 0
}


function getLastDayOfWeek()
{
    local someDate=$1
    local addOneDay=$2
    local firstDay=$(getFirstDayOfWeek $someDate)
    local addDays=6

    if [ "${addOneDay}" = "y" ];then
        addDays=7
    fi
    echo $(getDiffDay ${firstDay} ${addDays})

    return 0
}


function getDate()
{
    local someDate=$1
    local addNext=$2
    local formattedDate=''

    local someDateLength=${#someDate}
    case "${someDateLength}" in

        
        8)
            formattedDate=$someDate
            if [ "${addNext}" = "yes" ];then
                formattedDate=`date +"%Y%m%d" -d "${formattedDate} + 1day"`
            fi
            ;;

        
        6)
            formattedDate="${someDate}01"
            if [ "${addNext}" = "yes" ];then
                formattedDate=$(getLastDayOfMonth "${formattedDate}")
                formattedDate=`date +"%Y%m%d" -d "${formattedDate} +1 day"`
            fi
            ;;

        
        4)
            formattedDate="${someDate}0101"
            if [ "${addNext}" = "yes" ];then
                formattedDate="${someDate}1231"
                formattedDate=`date +"%Y%m%d" -d "${formattedDate} +1 day"`
            fi
            ;;

        
        *)
            formattedDate=`date +%Y%m%d -d '-1day'`
            if [ "${addNext}" = "yes" ];then
                formattedDate=`date +%Y%m%d`
            fi
            ;;
    esac

    echo $formattedDate
    return 0
}

function strToTime()
{
    local timeString="$1"
    if [ "${timeString}" != "" ] && [[ $timeString =~ [^[:digit:]] ]];then
        echo `date +%Y%m%d -d "${timeString}"`
    else
        echo $timeString
    fi
    return 0
}

function RunCommandByRange()
{
    local start=$1
    local end=$2
    local command=$3
    local format=$4
    local params=$5
    local run=$6
    local sleep=$7

    local startTs=`date +%s -d "${start}"`
    local endTs=`date +%s -d "${end}"`
    local days=$(( ($endTs - $startTs)/86400 + 1 ))
    local count=0

    end=`date -d "+1 day $end" +%Y%m%d`
    while [[ $start -lt $end ]]
    do
        count=$(( $count+1 ))
        runCommand="${command} ${format}${start} ${params}"
        echo
        echo -e "   ${COLOR_PURPLE}=> [${count}/${days}]${COLOR_END} ${COLOR_UL_CYAN}${runCommand}${COLOR_END}"
        [ "$run" != "false" ] || ${runCommand}
        wait
        start=`date -d "+1 day $start" +%Y%m%d`
        sleep $sleep
    done
}

RED="\033[01;31m"
BLUE="\033[01;34m"
NORMAL="\033[00m"
YELLOW="\033[33m"
GRAY="\033[01;30m"

COLORLOG="${COLORLOG:-0}"

function log_error() {
  [[ "${COLORLOG}" -eq 1 ]] && \
  { echo -e "${RED}[!]${NORMAL}[$(date '+%Y-%m-%d %H:%M:%S')] $*" 1>&2; } || \
  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [!] $*" 1>&2; }
}

function log_status() {
  [[ "${COLORLOG}" -eq 1 ]] && \
  { echo -e "${BLUE}[>]${NORMAL}[$(date '+%Y-%m-%d %H:%M:%S')] $*"; } || \
  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [>] $*"; }
}

function log_warn() {
  [[ "${COLORLOG}" -eq 1 ]] && \
  { echo -e "${YELLOW}[W]${NORMAL}[$(date '+%Y-%m-%d %H:%M:%S')] $*"; } || \
  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [W] $*"; }
}

function log_progress() {
  [[ "${COLORLOG}" -eq 1 ]] && \
  { echo -e "${GRAY}[ ]${NORMAL}[$(date '+%Y-%m-%d %H:%M:%S')] $*"; } || \
  { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ ] $*"; }
}

function xxx() {
  local component_name=${1}
  local target_folder=${2}
  local backup_folder="${BACKUP_DIR}/${BKP_PREFIX}${NOW}"

  log_status "Creating backups..."
  if [[ ! -d "${backup_folder}" ]]; then
    mkdir "${backup_folder}"
  fi

  log_progress "Backuping the ${component_name} to ${backup_folder}/${component_name}_bkp.tar..."
  tar cfP "${backup_folder}/${component_name}_bkp.tar" "${target_folder}"
  log_progress "Backup for component ${component_name} done."
}


function yyy() {
  local component_name=${1}
  local target_folder=${2}
  log_status "Cleaning up target folder \"${target_folder}\" for component ${component_name}..."
  if [[ ! -d "${target_folder:-}" ]]; then
    log_error "Target folder \"${target_folder}\" does not exists!"
    exit 1
  fi

  log_progress "Deleting contents..."
  find "${target_folder}" -mindepth 1 -delete || { log_warn "The cleanups of ${target_folder} indicated some problems, please check carefully if everything is still ok..."; }
  log_progress "Cleanup for ${component_name} done."
}


function zzz() {
  local component_name=${1}
  local source_folder=${2}
  local target_folder=${3}

  log_status "Start installing component ${component_name}"
  if [[ ! -d "${source_folder}" ]]; then
    log_error "Cannot install component ${component_name}. Source folder ${source_folder} does not exist."
    exit 1
  fi

  if [[ ! -d "${target_folder}" ]]; then
    log_error "Target folder ${target_folder} does not exist for the installation of ${component_name}, please check what when wrong and restart the installation..."
    exit 1
  fi

  log_progress "Copying all files from ${source_folder} to ${target_folder}..."
  cp -r "${source_folder}/"* "${target_folder}"
  log_progress "All files for component ${component_name} copied."

}
