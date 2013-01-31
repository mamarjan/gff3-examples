#!/bin/bash

# This script will download all it needs and run x repetitions of every
# benchmark implementation

# Requires Ubuntu 12.10

# Note: running time and used memory tend to depend very much on
#       other applications currently active. Make sure to manually
#       filter the results.


echo Preparing test...

# Create folder for all test executables
mkdir -p build



# Java test setup

## Test if java is installed
echo "  Building Java test..."
echo "    Testing if javac available..."
javac -version 2> /dev/null
if [ $? -ne 0 ]; then
  echo !!! Java has to be installed to successfully run this benchmark
  exit 1
fi

export BIOJAVA_VERSION=3.0.5
export JAVA_EXEC_DIR=build/java

mkdir -p $JAVA_EXEC_DIR

# Downloading biojava
echo "    Downloading biojava $BIOJAVA_VERSION..."
if [ ! -f "$JAVA_EXEC_DIR/biojava3-core-$BIOJAVA_VERSION.jar" ]; then
  wget --directory-prefix=$JAVA_EXEC_DIR http://biojava.org/download/maven/org/biojava/biojava3-core/$BIOJAVA_VERSION/biojava3-core-$BIOJAVA_VERSION.jar
  if [ $? -ne 0 ]; then
    echo !!! Failed to download BioJava $BIOJAVA_VERSION! Maybe a network issue?
    exit 1
  fi
fi
if [ ! -f "$JAVA_EXEC_DIR/biojava3-genome-$BIOJAVA_VERSION.jar" ]; then
  wget --directory-prefix=$JAVA_EXEC_DIR http://biojava.org/download/maven/org/biojava/biojava3-genome/$BIOJAVA_VERSION/biojava3-genome-$BIOJAVA_VERSION.jar
  if [ $? -ne 0 ]; then
    echo !!! Failed to download BioJava $BIOJAVA_VERSION! Maybe a network issue?
    exit 1
  fi
fi

export CLASSPATH=$JAVA_EXEC_DIR:$JAVA_EXEC_DIR/biojava3-core-$BIOJAVA_VERSION.jar:$JAVA_EXEC_DIR/biojava3-genome-$BIOJAVA_VERSION.jar
echo "    Building FeatureCounter.java..."
javac -d $JAVA_EXEC_DIR java/FeatureCounter.java
if [ ! -f $JAVA_EXEC_DIR/FeatureCounter.class ]; then
  echo !!! Failed to build Java benchmark
  exit 1
fi



# Python test setup
export PYTHON_COMMAND=python
export BIOPYTHON_VERSION=1.60
export PYTHON_EXEC_DIR=build/python
export PYTHONPATH=build/python/bcbb/gff:build/python/biopython-1.60

echo "  Setting up Biopython example..."

mkdir -p $PYTHON_EXEC_DIR

echo "    Downloading Biopython $BIOPYTHON_VERSION..."
if [ ! -f "$PYTHON_EXEC_DIR/biopython-$BIOPYTHON_VERSION.tar.gz" ]; then
  wget --directory-prefix=$PYTHON_EXEC_DIR http://biopython.org/DIST/biopython-$BIOPYTHON_VERSION.tar.gz
  if [ $? -ne 0 ]; then
    echo !!! Failed to download Biopython $BIOPYTHON_VERSION! Maybe a network issue?
    exit 1
  fi
fi

echo "    Unpacking Biopython..."
if [ -d $PYTHON_EXEC_DIR/biopython-$BIOPYTHON_VERSION ]; then
  rm -Rf $PYTHON_EXEC_DIR/biopython-$BIOPYTHON_VERSION
fi
tar -zxf $PYTHON_EXEC_DIR/biopython-$BIOPYTHON_VERSION.tar.gz -C $PYTHON_EXEC_DIR
if [ $? -ne 0 ]; then
  echo !!! Failed to unpack Biopython $BIOPYTHON_VERSION
  exit 1
fi

echo "    Downloading GFF parser..."
if [ ! -d "$PYTHON_EXEC_DIR/bcbb" ]; then
  git clone https://github.com/chapmanb/bcbb.git $PYTHON_EXEC_DIR/bcbb
  if [ $? -ne 0 ]; then
    echo !!! Failed to download GFF parser for Python from GitHub
    exit 1
  fi
fi
git --work-tree=$PYTHON_EXEC_DIR/bcbb --git-dir=$PYTHON_EXEC_DIR/bcbb/.git checkout 976627ee26ecb4d3f7a4100ce4745f3e968232ad
if [ $? -ne 0 ]; then
  echo !!! Failed to checkout the correct revision of bcbb
  exit 1
fi



# Ruby setup
echo "  Setting up Ruby examples..."

export USE_RUBY_VERSION=1.9.3
export GEMSET_NAME=gff3-benchmark-script

# We require rvm
echo "    Testing for rvm..."

source "$HOME/.rvm/scripts/rvm"
if [ $? -ne 0 ]; then
  echo !!! RVM has to be installed before the benchmark is run
fi

echo "    Testing for right Ruby version..."
CORRECT_RUBY_VERSION_INSTALLED=`rvm list rubies | grep $USE_RUBY_VERSION`
if [ ! "$CORRECT_RUBY_VERSION_INSTALLED" ]; then
  echo "    Installing Ruby $USE_RUBY_VERSION..."
  rvm install $USE_RUBY_VERSION
fi
rvm $USE_RUBY_VERSION

CORRECT_GEMSET_AVAILABLE=`rvm list gemsets | grep ruby-$USE_RUBY_VERSION | grep $GEMSET_NAME`
echo $CORRECT_GEMSET_AVAILABLE

if [ ! "$CORRECT_GEMSET_AVAILABLE" ]; then
  rvm gemset create $GEMSET_NAME
fi
rvm use $USE_RUBY_VERSION@$GEMSET_NAME

echo "    Installing BioRuby..."
gem install bio -v 1.4.3
if [ $? -ne 0 ]; then
  echo "!!! Instalation of the bio gem failed"
  exit 1
fi

echo "    Installing bio-gff3 gem"
gem install bio-gff3 -v 0.9.1
if [ $? -ne 0 ]; then
  echo "!!! Instalation of the bio-gff3 gem failed"
  exit 1
fi



# Running the benchmark

# java FeatureCounter sample.gff
# python python/bcbio-count-records.py ../../test_data/flybase/FB2011_07/dana-all-r1.3.gff
