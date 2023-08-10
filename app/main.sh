#! /bin/bash
#
# Run script for flywheel/svrtk-brain-reconstruction Gear.
#
# Authorship: Niall bourke
#

##############################################################################
# Define directory names and containers

FLYWHEEL_BASE=/flywheel/v0
INPUT_DIR=$FLYWHEEL_BASE/input/
OUTPUT_DIR=$FLYWHEEL_BASE/output
CONFIG_FILE=$FLYWHEEL_BASE/config.json
CONTAINER='[flywheel/svrtk-brain-reconstruction]'
WORK=/flywheel/v0/work
mkdir -p ${WORK}

##############################################################################
# Parse configuration
function parse_config {

  CONFIG_FILE=$FLYWHEEL_BASE/config.json
  MANIFEST_FILE=$FLYWHEEL_BASE/manifest.json

  if [[ -f $CONFIG_FILE ]]; then
    echo "$(cat $CONFIG_FILE | jq -r '.config.'$1)"
  else
    CONFIG_FILE=$MANIFEST_FILE
    echo "$(cat $MANIFEST_FILE | jq -r '.config.'$1'.default')"
  fi
}

# define output choise:
config_output_nifti="$(parse_config 'output_nifti')"
# define options:
config_motion="$(parse_config 'motion')"
config_slice="$(parse_config 'sliceThickness')"
config_res="$(parse_config 'resolution')"
config_packages="$(parse_config 'packages')"


##############################################################################
# Handle INPUT files

echo "${CONTAINER}  Running auto-brain-reconstruction algorithm"

# Set initial exit status
mri_svrtk_exit_status=0

# Find input file In input directory with the extension
# .nii, .nii.gz
axi_input_file=`find $INPUT_DIR/axi -iname '*.nii' -o -iname '*.nii.gz'`
cor_input_file=`find $INPUT_DIR/cor -iname '*.nii' -o -iname '*.nii.gz'`
sag_input_file=`find $INPUT_DIR/sag -iname '*.nii' -o -iname '*.nii.gz'`

# Check that input file exists
if [[ -e $axi_input_file ]] && [[ -e $cor_input_file ]] && [[ -e $sag_input_file ]]; then
    echo "${CONTAINER}  Input file found: ${axi_input_file}"
    cp ${axi_input_file} ${WORK}/T2w_AXI.nii.gz
    echo "${CONTAINER}  Input file found: ${cor_input_file}"
    cp ${cor_input_file} ${WORK}/T2w_COR.nii.gz 
    echo "${CONTAINER}  Input file found: ${sag_input_file}"
    cp ${sag_input_file} ${WORK}/T2w_SAG.nii.gz
else
    echo "${CONTAINER} WARNING: Missing one or more Nifti inputs within input directory $INPUT_DIR"
#   echo "${CONTAINER} Exiting..."
#   exit 1  Don't exit, just return error code
fi


if [ "$(ls -A $WORK)" ]; then   
    echo "WORK directory contents:"
    echo "$(ls -l $WORK)"

    echo "Running brain-reconstruction..."
    bash /home/auto-proc-svrtk/auto-brain-reconstruction.sh $WORK $OUTPUT_DIR $config_motion $config_slice $config_res $config_packages
    mri_svrtk_exit_status=$?
else
    echo "WORK directory is empty"
    echo "Exiting..."
    mri_svrtk_exit_status=$?
fi

##############################################################################
# Handle Exit status

if [[ $mri_svrtk_exit_status == 0 ]]; then
  echo -e "${CONTAINER} Success!"
  exit 0
else
  echo "${CONTAINER}  Something went wrong! mri_svrtk exited non-zero!"
  exit 1
fi
