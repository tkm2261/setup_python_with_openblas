setup_python_with_openblas
==========================

OpenBLASにてPython計算環境を立ち上げるスクリプト

###setup_python_with_openblas.sh  
スクリプト本体 Amazon Linuxで動作検証済み  
OpenBLASとmultiprocessingは相性が悪いことが知られているので、用法用量正しくお使い下さい。非検証ですが、multiprocessing内でmultiprocessingをすると駄目なイメージがあります。