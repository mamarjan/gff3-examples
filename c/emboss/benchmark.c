#include "emboss.h"

int main(int argc, char **argv)
{
    AjPFeattaball featin;
    AjPFeattable feat = NULL;

    embInit("benchmark", argc, argv);

    featin = ajAcdGetFeaturesall("features");

    long counter = 0;

    while(ajFeattaballNext(featin, &feat))
    {
      counter++;
    }

    ajFeattableDel(&feat);
    ajFeattaballDel(&featin);

    printf("Read %li records\n", counter);

    embExit();

    return 0;
}

