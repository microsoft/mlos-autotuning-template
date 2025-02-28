#!/bin/bash
##
## Copyright (c) Microsoft Corporation.
## Licensed under the MIT License.
##


# This is a simple script used to test the repo in the CI pipeline.

set -eu

# Move to repo root.
scriptdir=$(dirname "$(readlink -f "$0")")
cd "$scriptdir/.."

set -x

tests_config_path=$(conda run -n mlos python3 -c 'from importlib.resources import files; print(files("mlos_bench.tests.config"))')

tmpdir=$(mktemp -d)
cd "$tmpdir"
outfile="$tmpdir/mlos_bench.out"

# Run something like the test_launch_main_app_opt test.
conda run -n mlos mlos_bench \
    --config-path "$tests_config_path" \
    --config cli/mock-opt.jsonc \
    --trial_config_repeat_count 3 \
    --max_suggestions 3 \
    --mock_env_seed 42 \
    --storage storage/sqlite.jsonc \
    > "$outfile" 2>&1

function check_output() {
    local regexp="$1"
    if ! egrep -q "$regexp" "$outfile"; then
        echo "ERROR: Failed to find '$regexp' in '$outfile':" >&2
        cat "$outfile" >&2
        echo "ERROR: Failed to find '$regexp' in '$outfile'.  See above." >&2
        exit 1
    fi
}

# Iteration 1: Expect first value to be the baseline
check_output "mlos_core_optimizer\\.py:[0-9]+ bulk_register DEBUG Warm-up END: .* :: \\{'score': [0-9]+\\.[0-9]+\\}$"
# Iteration 2: The result may not always be deterministic
check_output "mlos_core_optimizer\\.py:[0-9]+ bulk_register DEBUG Warm-up END: .* :: \\{'score': [0-9]+\\.[0-9]+\\}$"
# Iteration 3: non-deterministic (depends on the optimizer)
check_output "mlos_core_optimizer\\.py:[0-9]+ bulk_register DEBUG Warm-up END: .* :: \\{'score': [0-9]+\\.[0-9]+\\}$"
# Final result: baseline is the optimum for the mock environment
check_output "run\\.py:[0-9]+ _main INFO Final score: \\{'score': [0-9]+\\.[0-9]+\\}[ ]*$"

experiment_id="MockExperiment"
storage_db="mlos_bench.sqlite"

#trial_id_start=$(echo "SELECT MAX(trial_id) FROM trial WHERE exp_id='$experiment_id';" | sqlite3 "$storage_db")
trial_id_start=0

trial_success_count=$(echo "SELECT COUNT(*) FROM trial WHERE exp_id='$experiment_id' AND status='SUCCEEDED' AND trial_id > $trial_id_start;" | sqlite3 "$storage_db")

# Validate that the number of trials increased as expected.
if [ $trial_success_count -ne 9 ]; then
    echo "ERROR: Unexpected number of trials succeeded: $trial_success_count"
    exit 1
fi

rm -rf "$tmpdir" || true
echo "OK"
exit 0
