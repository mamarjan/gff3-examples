# This script will download all it needs and run x repetitions of every
# benchmark implementation

# Requires Ubuntu 12.10

# Note: running time and used memory tend to depend very much on
#       other applications currently active. Make sure to manually
#       filter the results.


# Create folder for all test executables
echo Creating executables...
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
echo "    Building FatureCounter.java..."
javac -d $JAVA_EXEC_DIR java/FeatureCounter.java
if [ ! -f $JAVA_EXEC_DIR/FeatureCounter.class ]; then
  echo !!! Failed to build Java benchmark
  exit 1
fi

# Python test setup






# Running the benchmark
# java FeatureCounter sample.gff
