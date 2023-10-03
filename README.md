# MLOS Autotuning Template Repo

This repo is a barebones template for a developer environment with some basic scripts and configs to help do autotuning for a new target using [MLOS](https://github.com/microsoft/MLOS).

## Getting Started

1. Fork this repository.
2. Open this repository in VSCode.
3. Reopen in a devcontainer.

    > For additional dev environment details, see the devcontainer [README.md](.devcontainer/README.md)

4. Reopen the workspace.

    - Browse to the [`mlos-autouning.code-workspace`](./mlos-autotuning.code-workspace) file and follow the prompt in the lower right to reopen.

5. Add some configs and script to the `config/` tree.

    - At a minimum you'll need to define some [`Environments`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/environments/README.md), typically with a top-level `CompositeEnvironment` to represent your target system and its [`Tunables`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/tunables/README.md) and include some [`Services`](https://github.com/microsoft/MLOS/blob/main/mlos_bench/mlos_bench/services/README.md) to help execute your workloads.
    - See [`mlos_bench/README.md`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/README.md) and [`mlos_bench/config/README.md`](https://github.com/microsoft/MLOS/tree/main/mlos_bench/mlos_bench/config/README.md) for additional details.

6. Activate the conda environment in the integrated terminal:

    ```sh
    conda activate mlos
    ```

7. Login to the Azure CLI:

    ```sh
    az login
    ```

8. Stash some relevant auth info (e.g., subscription ID, resource group, etc.):

    ```sh
    ./MLOS/scripts/generate-azure-credentials-config.sh > global_azure_config.json
    ```

9. Run the `mlos_bench` tool.

    For instance, to run the Redis example from the upstream MLOS repo (pulled locally):

    ```sh
    mlos_bench --config "./MLOS/mlos_bench/mlos_bench/config/cli/azure-redis-opt.jsonc" --globals "./MLOS/mlos_bench/mlos_bench/config/experiments/experiment_RedisBench.jsonc" --max_iterations 10
    ```

## See Also

For other examples, please see one of the following:

- [sqlite-autotuning](https://dev.azure.com/msgsl/MLOS/_git/sqlite-autotuning)
