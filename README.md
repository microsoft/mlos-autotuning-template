# MLOS Autotuning Template Repo

[![MLOS Autotuning DevContainer CI](https://github.com/microsoft/mlos-autotuning-template/actions/workflows/devcontainer.yml/badge.svg)](https://github.com/microsoft/mlos-autotuning-template/actions/workflows/devcontainer.yml)

This repo (or [the one it was forked](https://github.com/microsoft/mlos-autotuning-template) from) is a barebones template for a developer environment with some basic scripts and configs to help do autotuning for a new target using [MLOS](https://github.com/microsoft/MLOS).

## Getting Started

1. Fork [this repository](https://github.com/microsoft/mlos-autotuning-template), or `Use Template` (preferred).

1. Open the new repository in VSCode.

1. Reopen in a devcontainer.

   > For additional dev environment details, see the devcontainer [README.md](.devcontainer/README.md)

1. Reopen the workspace.

   - Browse to the [`mlos-autouning.code-workspace`](./mlos-autotuning.code-workspace) file and follow the prompt in the lower right to reopen.

1. Add some configs and script to the `config/` tree.

   - At a minimum you'll need to define some [`Environments`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/environments/README.md), typically with a top-level `CompositeEnvironment` to represent your target system and its [`Tunables`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/tunables/README.md) and include some [`Services`](https://github.com/microsoft/MLOS/blob/main/mlos_bench/mlos_bench/services/README.md) to help execute your workloads.
   - See [`mlos_bench/README.md`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/README.md) and [`mlos_bench/config/README.md`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/config/README.md) for additional details.

1. Activate the conda environment in the integrated terminal:

   ```sh
   conda activate mlos
   ```

1. Login to the Azure CLI:

   ```sh
   az login
   ```

1. Stash some relevant auth info (e.g., subscription ID, resource group, etc.):

   ```sh
   ./MLOS/scripts/generate-azure-credentials-config.sh > global_azure_config.json
   ```

1. Run the `mlos_bench` tool.

   For instance, to run the Redis example from the upstream MLOS repo (which is pulled locally automatically by the devcontainer startup
   scripts):

   ```sh
   mlos_bench --config "./MLOS/mlos_bench/mlos_bench/config/cli/azure-redis-opt.jsonc" --globals "./MLOS/mlos_bench/mlos_bench/config/experiments/experiment_RedisBench.jsonc" --max_iterations 10
   ```

   This should take a few minutes to run and does the following:

   - Loads the CLI [config](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/config/cli/azure-redis-opt.jsonc).

     - The "experiment" [config](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/config/experiments/experiment_RedisBench.jsonc) specified by the `--globals` parameter further customizes that config with the experiment specific parameters (e.g., telling it which tunable parameters to use for the experiment, the experiment name, etc.).

       Alternatively, other config files from the `config/experiments/` directory can be referenced with the `--globals` argument as well in order to customize the experiment, while keeping the core other configs the same.

   - The CLI config also references and loads the root Environment config for Redis.

     - In that config the `setup` section lists commands used to
       1. Prepare a config for the `redis` instance based on the tunable parameters specified in the experiment config,
     - Next, the `run` section lists commands used to
       1. Runs a basic `redis-benchmark` to exercise the instance.
       1. assemble the results into a file that is read in the `read_results_file` config section in order to store them into the `mlos_bench` results database.
     - Finally, since their is an optimizer specified, this process repeats 10 times to sample several different config points.

   The overall process looks like this:

   <!-- markdownlint-disable-next-line MD033 -->

   <img src="./doc/images/llamatune-loop.png" style="width:700px" alt="optimization loop" />

   > Source: [LlamaTune: VLDB 2022](https://arxiv.org/abs/2203.05128)

## See Also

- [MLOS](https://github.com/microsoft/MLOS) - the main repo for the `mlos_bench` tool.
- [config tree descriptions](./config/README.md)

### Additional Examples

- [sqlite-autotuning](https://github.com/Microsoft-CISL/sqlite-autotuning)

### Data Science APIs

- [`matplotlib` for Beginners](https://matplotlib.org/cheatsheets/handout-beginner.pdf)
- [`pandas` `Dataframe` Overview](https://www.w3schools.com/python/pandas/pandas_dataframes.asp)
- [`seaborn` Scatterplots](https://www.golinuxcloud.com/seaborn-scatterplot/)
