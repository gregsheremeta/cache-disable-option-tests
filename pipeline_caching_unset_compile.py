from kfp.compiler import Compiler
import pipeline_caching_unset as my_file

Compiler().compile(
    pipeline_func=my_file.my_pipeline,
    package_path='output.yaml',
)
