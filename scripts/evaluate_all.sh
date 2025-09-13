

#!/bin/bash
#PBS -q rt_HG
#PBS -N cceval
#PBS -l select=1
#PBS -l walltime=6:00:00
#PBS -P gah51624
#PBS -o /dev/null
#PBS -e /dev/null
source /etc/profile.d/modules.sh
source ~/.bash_profile

set -e
cd "$PBS_O_WORKDIR/cceval"
source .venv_cceval/bin/activate

echo "Nodes allocated to this job:"
cat $PBS_NODEFILE

PBS_NUMID=$(echo "${PBS_JOBID}" | cut -d '.' -f 1)
mkdir -p $PBS_O_WORKDIR/outputs
LOGFILE="$PBS_O_WORKDIR/outputs/${PBS_NUMID}.log"
exec > "$LOGFILE" 2>&1

# environment variables
export TMP="/groups/gcg51558/kawamura/tmp"
export TMP_DIR="/groups/gcg51558/kawamura/tmp"
export HF_HOME="/groups/gcg51558/kawamura/hf_cache"

export CUDA_VISIBLE_DEVICES=0

export LD_LIBRARY_PATH="$HOME/opt/sqlite3/lib:$LD_LIBRARY_PATH" #ここ三行は自分だけの話
export PATH="$PWD/.venv_cceval/bin:$PATH"
hash -r

export LC_ALL="POSIX"


OUTPUT_DIR="results/${MODEL}"
TP=1

export TOKENIZERS_PARALLELISM=false
export VLLM_ALLOW_LONG_MAX_MODEL_LEN=1

echo "Running CrossCodeEval"
mkdir -p ${OUTPUT_DIR}
python scripts/evaluate.py \
    --task line_completion \
    --model_type codelm_right_cfc_left \
    --model_name_or_path ${MODEL} \
    --cfc_seq_length 2048 \
    --right_context_length 2048 \
    --prompt_file data/LANGUAGE/line_completion_oracle_bm25.jsonl \
    --gen_length 50 \
    --max_seq_length 8192 \
    --output_dir ${OUTPUT_DIR} \
    --dataset cceval \
    --tp ${TP} \
    --ts_lib build/LANGUAGE-lang-parser.so \
    --language python java csharp typescript \
    --all_result_csv "../${RESULT_CSV}"
