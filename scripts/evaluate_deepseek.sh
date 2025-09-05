
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
cd $PBS_O_WORKDIR
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
export gpus=1
export model="deepseek-ai/deepseek-coder-6.7b-base"

export task=line_completion_rg1_bm25
export LD_LIBRARY_PATH="$HOME/opt/sqlite3/lib:$LD_LIBRARY_PATH" #ここ三行は自分だけの話
export PATH="$PWD/.venv_cceval/bin:$PATH"
hash -r

export language=python
export output_dir="results/${model}/${task}/${language}"
mkdir -p $output_dir
python scripts/vllm_inference.py \
  --tp $gpus \
  --task $task \
  --language $language \
  --model $model \
  --output_dir $output_dir \
  --use_crossfile_context \
  --temperature 0.0 \
  --model_max_tokens 2048 \
  --crossfile_max_tokens 512 \
  --generation_max_tokens 50

export ts_lib=./build/${language}-lang-parser.so; 
export prompt_file=./data/${language}/${task}.jsonl 
python scripts/eval.py \
  --prompt_file $prompt_file \
  --output_dir $output_dir \
  --ts_lib $ts_lib \
  --language $language \
  --only_compute_metric

export language=typescript
export output_dir="results/${model}/${task}/${language}"
mkdir -p $output_dir
python scripts/vllm_inference.py \
  --tp $gpus \
  --task $task \
  --language $language \
  --model $model \
  --output_dir $output_dir \
  --use_crossfile_context \
  --temperature 0.0 \
  --model_max_tokens 2048 \
  --crossfile_max_tokens 512 \
  --generation_max_tokens 50

export ts_lib=./build/${language}-lang-parser.so; 
export prompt_file=./data/${language}/${task}.jsonl 
python scripts/eval.py \
  --prompt_file $prompt_file \
  --output_dir $output_dir \
  --ts_lib $ts_lib \
  --language $language \
  --only_compute_metric

export language=csharp
export output_dir="results/${model}/${task}/${language}"
mkdir -p $output_dir
python scripts/vllm_inference.py \
  --tp $gpus \
  --task $task \
  --language $language \
  --model $model \
  --output_dir $output_dir \
  --use_crossfile_context \
  --temperature 0.0 \
  --model_max_tokens 2048 \
  --crossfile_max_tokens 512 \
  --generation_max_tokens 50

export ts_lib=./build/${language}-lang-parser.so; 
export prompt_file=./data/${language}/${task}.jsonl 
python scripts/eval.py \
  --prompt_file $prompt_file \
  --output_dir $output_dir \
  --ts_lib $ts_lib \
  --language $language \
  --only_compute_metric

export language=java
export output_dir="results/${model}/${task}/${language}"
mkdir -p $output_dir
python scripts/vllm_inference.py \
  --tp $gpus \
  --task $task \
  --language $language \
  --model $model \
  --output_dir $output_dir \
  --use_crossfile_context \
  --temperature 0.0 \
  --model_max_tokens 2048 \
  --crossfile_max_tokens 512 \
  --generation_max_tokens 50

export ts_lib=./build/${language}-lang-parser.so; 
export prompt_file=./data/${language}/${task}.jsonl 
python scripts/eval.py \
  --prompt_file $prompt_file \
  --output_dir $output_dir \
  --ts_lib $ts_lib \
  --language $language \
  --only_compute_metric
