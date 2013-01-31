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





# Running the benchmark

# java FeatureCounter sample.gff
# python python/bcbio-count-records.py ../../test_data/flybase/FB2011_07/dana-all-r1.3.gff
