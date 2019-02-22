#!/bin/bash

MTI_DIR=$1
email=$2
username=$3
password=$4
in_file=$5
out_file=$6

${MTI_DIR}/SKR_Web_API_V2_3/run.sh GenericBatchCustom --email $email $in_file --username $username --password $password > $out_file
