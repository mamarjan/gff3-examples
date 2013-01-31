# This script will download all it needs and run x repetitions of every
# benchmark implementation

# Requires Ubuntu 12.10

# Note: running time and used memory tend to depend very much on
#       other applications currently active. Make sure to manually
#       filter the results.

echo Retrieving test code from GitHub...
if [ -d gff3-examples ]; then
  cd gff3-examples
  git pull
  if [ $? -ne 0 ]; then
    echo !!! Could not update test code. Network problems?
    exit 1
  fi
  cd ..
else
  git clone http://github.com/mamarjan/gff3-examples
  if [ $? -ne 0 ]; then
    echo !!! Could not retrieve test code. Network problems?
    exit 1
  fi
fi

# Create folder for all test executables
echo Creating executables...
if [ -d executables ]; then
  rm -Rf executables
fi
mkdir executables

# Java

## Test if java is installed
echo Building Java test...
javac -version 2> /dev/null
if [ $? -ne 0 ]; then
  echo !!! Java has to be installed to successfully run this benchmark
  exit 1
fi


