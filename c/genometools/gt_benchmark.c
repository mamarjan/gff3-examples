#include "genometools.h"
#include "gt_benchmark.h"

static GtOptionParser* gt_benchmark_option_parser_new(void *tool_arguments){
  GtOptionParser *op;
  gt_assert(!tool_arguments);

  op = gt_option_parser_new("test_file ",
                            "Iterate over the GFF3 input file one "
                            "record at a time.");

  return op;
}

static int gt_benchmark_runner(int argc, const char **argv, int parsed_args,
                                       void *tool_arguments, GtError *err)
{
  GtNodeStream * gff3_in_stream;
  int had_err = 0;

  gt_error_check(err);
  gt_assert(!tool_arguments);

  /* create a GFF3 input stream */
  gff3_in_stream = gt_gff3_in_stream_new_unsorted(argc - parsed_args,
                                                  argv + parsed_args);
  had_err = gt_node_stream_pull(gff3_in_stream, err);

  if (!had_err)
    printf("Successfully finished benchmark\n");
  else
    printf("There was an error\n");

  gt_node_stream_delete(gff3_in_stream);

  return had_err;
}

GtTool * gt_benchmark(void)
{
  return gt_tool_new(NULL,
                     NULL,
                     gt_benchmark_option_parser_new,
                     NULL,
                     gt_benchmark_runner);
}

