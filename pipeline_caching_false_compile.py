from kfp.compiler import Compiler
import pipeline_caching_false as my_file

Compiler().compile(
    pipeline_func=my_file.my_pipeline,
    package_path='output.yaml',
)
