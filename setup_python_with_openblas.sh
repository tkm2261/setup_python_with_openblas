#!/bin/sh
#########ここで設定した環境変数は~/.bashrcに書くことをオススメします######
#########コンパイル環境構築(要管理者権限)############

sudo yum install -y git python-devel gcc gcc-gfortran libgfortran gcc-c++ zlib-devel patch
#pipに必要
sudo yum install -y openssl openssl-devel 

#matplotlibに必要
sudo yum install -y freetype-devel libpng-devel bzip2-devel libjpeg-devel ncurses-devel sqlite-devel

#########インストールフォルダの指定############
export PYTHONHOME=$HOME/python
#BLASを他で使いたいなら分けて下さい。
export BLASHOME=$PYTHONHOME

##########作業フォルダ作成#########
mkdir lapack
cd lapack

##########ライブラリのダウンロード（適宜取得先を変えて下さい。）#########
git clone git://github.com/xianyi/OpenBLAS
wget http://sourceforge.net/projects/scipy/files/scipy/0.14.0/scipy-0.14.0.tar.gz
wget http://sourceforge.net/projects/numpy/files/NumPy/1.8.1/numpy-1.8.1.tar.gz
wget https://www.python.org/ftp/python/2.7.7/Python-2.7.7.tar.xz
git clone https://github.com/scikit-learn/scikit-learn
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-5.1.tar.gz
wget https://pypi.python.org/packages/source/p/pip/pip-1.5.6.tar.gz

tar xzf scipy-0.14.0.tar.gz
tar xzf numpy-1.8.1.tar.gz
tar Jxf  Python-2.7.7.tar.xz
tar xzf setuptools-5.1.tar.gz
tar xzf pip-1.5.6.tar.gz

##########BLASのビルド#########

cd OpenBLAS
make DYNAMIC_ARCH=0  BINARY=64 NO_AFFINITY=1
make PREFIX=$BLASHOME install

export BLAS=$BLASHOME/lib/libopenblas.a
export LAPACK=$BLASHOME/lib/libopenblas.a
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BLASHOME/lib/

ln $BLASHOME/lib/libopenblas.a $BLASHOME/lib/libcblas.a
cd ..

##########Pythonのビルド#########

cd Python-2.7.7
./configure --with-threads --prefix=$PYTHONHOME
make
make install

export PYTHONPATH=$PYTHONHOME/lib/python2.7
export PATH=$PYTHONHOME/bin:$PATH

cd ..

##########setuptoolsのビルド#########
cd setuptools-5.1
python setup.py install
cd ..

##########pipのビルド#########
cd pip-1.5.6
python setup.py install
cd ..

##########numpyのビルド#########

cd numpy-1.8.1

echo "
[default]
library_dirs = $BLASHOME/lib
[atlas]
atlas_libs = openblas
library_dirs = $BLASHOME/lib
[lapack]
lapack_libs = openblas
library_dirs = $BLASHOME/lib
" > site.cfg

python setup.py install

cd ..

###以下は、pipで入れたほうが良いかも####
#########scipyのビルド#########

cd scipy-0.14.0
python setup.py install
cd ..

#########scikit-learnのビルド#########

cd scikit-learn
python setup.py install
cd ..


#########諸々インストール###########
pip install nose
pip install pillow
pip install pandas
pip install matplotlib
pip install readline
pip install ipython
######コピペ用環境変数一覧#####
export PYTHONHOME=$HOME/python
export BLASHOME=$PYTHONHOME
export BLAS=$BLASHOME/lib/libopenblas.a
export LAPACK=$BLASHOME/lib/libopenblas.a
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BLASHOME/lib/
export PYTHONPATH=$PYTHONHOME/lib/python2.7
export PATH=$PYTHONHOME/bin:$PATH
	