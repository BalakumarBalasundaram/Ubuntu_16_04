#!/usr/bin/env bash

BKP_PREFIX="BKP"

function create_backups() {
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


function cleanup_target_folders() {
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


function install_component() {
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
