#!/usr/bin/env bash

#runnh=run2016_09_29_v2_tr201415_eval2015_hs600_dep50_pos50${learning_rate}_hs${lstm_hidden_size}
#echo ${runnh}
#nohup bash detect_events_v2_bilstm_v3_posdep_run_server.sh ${learning_rate} ${lstm_hidden_size} > ${runnh}.out 2> ${runnh}.err < /dev/null &

run_name="run_v2_tr201415_eval2015_hs600_dep50_pos50"
if [ -n "$1" ]
then
  run_name=$1
fi     # $String is null.

scale_features=True # Not used

# resources
emb_model_type=w2v
# emb_model="resources/external/w2v_embeddings/qatarliving_qc_size20_win10_mincnt5_rpl_skip1_phrFalse_2016_02_23.word2vec.bin"
emb_model=resources/word2vec/GoogleNews-vectors-negative300.bin

# emb_model_type=rand
emb_train=True

emb_size=300 # used in case of emb_model_type=rand

word2vec_load_bin=True # for google pretrained embeddings

data_dir=data

data_tac2014_train=${data_dir}/clear_data/data_tac2014_train.json
data_tac2014_eval=${data_dir}/clear_data/data_tac2014_eval.json
data_tac2015_train=${data_dir}/clear_data/data_tac2015_train.json
data_tac2015_eval=${data_dir}/clear_data/data_tac2015_eval.json
data_tac2015_eval_official_tbf=${data_dir}/clear_data/data_tac2015_eval.tbf

train_data_files="${data_tac2014_train};${data_tac2015_train};${data_tac2014_eval}"
dev_data_files=${data_tac2015_eval}

test_data_files=${data_tac2015_eval}
test_data_file_tbf=${data_tac2015_eval_official_tbf}

learning_rate=0.01
learning_rate_fixed=True
learning_rate_divideby=1.2 # learning_rate=learning_rate/learning_rate_decrease
learning_rate_decr_fromepoch=3 # start decreasing learning rate after this epoch

train_epochs_cnt=20
batch_size=100
lstm_hidden_size=256 # bilstm hidden size is 2*lstm_hidden_size
lstm_layers=1

deps_emb_size=50
pos_emb_size=50

max_sents=0

#Include embeddings in input or output layer(shortcut)
incl_tokemb_out=False
incl_posemb_in=False
incl_posemb_out=False
incl_depemb_in=False
incl_depemb_out=False

# -incl_tokemb_out:${incl_tokemb_out} -incl_posemb_in:${incl_posemb_in} -incl_posemb_out:${incl_posemb_out} -incl_depemb_in:${incl_depemb_in} -incl_depemb_out:${incl_depemb_out}
#run_name=_${run_name}_to_${incl_tokemb_out}_pi_${incl_posemb_in}_po_${incl_posemb_out}_di_${incl_depemb_in}_do_${incl_depemb_out}

run_name=${run_name}_to_${incl_tokemb_out}_pi_${incl_posemb_in}_po_${incl_posemb_out}_di_${incl_depemb_in}_do_${incl_depemb_out}

# event_types_labels_file=data/TAC_KBP_eval_type_2016.txt # 18 types
event_types_labels_file=data/TAC_KBP_eval_type_2015.txt # 38 types
# event_types_labels_file=
# echo "event_types_labels_file:${event_types_labels_file}"

# Official evaluation - realis and event type settings
run_name_eventdetection=${run_name}
run_name_realis=run_et38_class_realis_v2_tr1415_e2015
run_name_type=run_et38_class_type_v2_tr1415_e2015

submission_version=et38_01

log_file=res_exp_${run_name}_$(date +%y-%m-%d-%H-%M-%S).log
. detect_events_v4_bilstm_v4_posdep_stacked_run_server_partial.sh > ${log_file}


