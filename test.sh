#!/bin/bash

set -x

# grep returns 0 if found, 1 if not
function check_for_caching_result() {
    local file="$1"
    local desired_result="$2"
    
    grep -q 'enableCache: true' "$file"
    grep_result=$?
    # grep returns 0 if found, 1 if not
    if [ "$grep_result" -ne "$desired_result" ]; then
        echo "Test failed!"
        exit 1
    fi
}

ENABLED=0
DISABLED=1


# base cases -- nothing has changed
rm -f output.yaml
kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
kfp dsl compile --py ./pipeline_caching_false.py --output output.yaml
check_for_caching_result output.yaml $DISABLED


# use the CLI compiler, set the env var in various ways
rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=true kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=True kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT="True" kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT="YES" kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=On kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=False kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

# check the true and false in the DSL cases too
rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 kfp dsl compile --py ./pipeline_caching_true.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 kfp dsl compile --py ./pipeline_caching_true.py --output output.yaml
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 kfp dsl compile --py ./pipeline_caching_false.py --output output.yaml
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 kfp dsl compile --py ./pipeline_caching_false.py --output output.yaml
check_for_caching_result output.yaml $DISABLED


# use the CLI compiler, set the cli flag
rm -f output.yaml
kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml --disable-execution-caching-by-default
check_for_caching_result output.yaml $DISABLED


# use the CLI compiler, set the cli flag, and make sure it overrides any env var
rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 kfp dsl compile --py ./pipeline_caching_unset.py --output output.yaml --disable-execution-caching-by-default
check_for_caching_result output.yaml $DISABLED


# use compiler.Compile(), set the env var in various ways
rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=true python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=True python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT="True" python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT="YES" python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=On python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=False python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 python ./pipeline_caching_unset_compile.py
check_for_caching_result output.yaml $ENABLED

# check the true and false in the DSL cases too
rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 python ./pipeline_caching_true_compile.py
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 python ./pipeline_caching_true_compile.py
check_for_caching_result output.yaml $ENABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=0 python ./pipeline_caching_false_compile.py
check_for_caching_result output.yaml $DISABLED

rm -f output.yaml
KFP_DISABLE_EXECUTION_CACHING_BY_DEFAULT=1 python ./pipeline_caching_false_compile.py
check_for_caching_result output.yaml $DISABLED


echo "Test passed!"
