DATASET=${1:-"WMT17_de_en"}
DATASET_DIR=${2:-"/media/drive/Datasets/wmt17_de_en"}
OUTPUT_DIR=${3:-"/media/drive/nmt_results"}

WARMUP="4000"
LR0="512**(-0.5)"

python main.py \
  --save transformer \
  --dataset ${DATASET} \
  --dataset_dir ${DATASET_DIR} \
  --results_dir ${OUTPUT_DIR} \
  --model Transformer \
  --model_config "{'num_layers': 3, 'hidden_size': 512, 'num_heads': 8, 'inner_linear': 2048}" \
  --data_config "{'moses_pretok': True, 'tokenization':'bpe', 'num_symbols':32000, 'shared_vocab':True}" \
  --b 128 \
  --max_length 50 \
  --device_ids 0 \
  --label_smoothing 0.1 \
  --trainer Seq2SeqTrainer \
  --optimization_config "[{'step_lambda':
                          \"lambda t: { \
                              'optimizer': 'Adam', \
                              'lr': ${LR0} * min(t ** -0.5, t * ${WARMUP} ** -1.5), \
                              'betas': (0.9, 0.98), 'eps':1e-9}\"
                          }]"
