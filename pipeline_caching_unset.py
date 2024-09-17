from kfp import dsl


@dsl.component(base_image="quay.io/opendatahub/ds-pipelines-ci-executor-image:v1.0")
def my_component():
    pass

@dsl.pipeline(name='tiny-pipeline')
def my_pipeline():
    my_component()
