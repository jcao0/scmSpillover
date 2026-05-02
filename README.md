# scmSpillover

This repository contains the public software and replication materials for
*Estimation and Inference for Synthetic Control Methods with Spillover Effects*
by Jianfei Cao and Connor Dowd.

The repository has two public-facing components:

- the CRAN R package `scmSpillover`, which implements synthetic control methods
  with spillover effects;
- the MATLAB replication code for the Proposition 99 empirical application in
  the paper.

## R Package

The package is available from CRAN:

```r
install.packages("scmSpillover")
```

After installation:

```r
library(scmSpillover)

help(package = "scmSpillover")
```

The package source is in [`scmSpillover/`](scmSpillover/). Its main user-facing
function is `run_scm_spillover()`, with lower-level functions for synthetic
control estimation, spillover-adjusted estimation, inference, and plotting.

## Replication Code

The empirical replication files are in
[`replication files/proposition99_matlab/`](replication%20files/proposition99_matlab/).

To reproduce the MATLAB empirical results:

1. Open MATLAB from the `replication files/proposition99_matlab/` folder.
2. Make sure the MATLAB Optimization Toolbox is available.
3. Run:

```matlab
main
```

The script cleans the cigarette-consumption data, estimates the standard and
spillover-adjusted synthetic controls, runs the inference procedures, and writes
tables and figures to the local `output/` folder.

## Repository Layout

```text
.
+-- scmSpillover/                         # CRAN R package source
|   +-- DESCRIPTION
|   +-- R/
|   +-- man/
|   +-- tests/
|   +-- inst/
+-- replication files/
|   +-- proposition99_matlab/             # MATLAB replication bundle
|       +-- main.m
|       +-- code/
|       +-- functions/
|       +-- data/
|       +-- output/
|       +-- readme/
+-- .github/workflows/                    # Package-check workflows
```

## Citation

If you use the package or replication code, please cite the paper:

> Cao, Jianfei, and Connor Dowd. *Estimation and Inference for Synthetic Control
> Methods with Spillover Effects*.

## Issues

Bug reports and questions can be filed through the repository issue tracker:
<https://github.com/jcao0/synthetic-control-spillover/issues>.
