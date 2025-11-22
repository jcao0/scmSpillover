# scmSpillover - Synthetic Control Method with Spillover Effects R Package

## Introduction

`scmSpillover` is an R package that implements the Synthetic Control Method with Spillover Effects. This package is based on the methodology of Cao and Dowd (2019), addressing the limitation of traditional synthetic control methods that ignore interdependence between units.

### Key Features

- **Spillover Effects Modeling**: Accounts for indirect impacts of treated units on other units
- **Comparative Analysis**: Provides results for both traditional SCM and spillover-adjusted SCM simultaneously
- **Visualization Tools**: Built-in professional chart generation capabilities
- **Flexible and General**: Applicable to any panel data, not limited to specific domains

## Installation

### Install from Local Source
```r
# After downloading the source code
install.packages("path/to/scmSpillover_0.1.1.tar.gz", repos = NULL, type = "source")
```

## Quick Start

```r
library(scmSpillover)

# View basic package information
packageDescription("scmSpillover")

# List all functions in the package
ls("package:scmSpillover")
```

### Basic Example

```r
library(scmSpillover)
packageDescription("scmSpillover")
data(cigs)
help(package = "scmSpillover")

result <- run_scm_spillover(
  data = cigs,
  treatment_start = 20,
  affected_units = c(1, 5, 6, 9, 15, 23, 24, 25, 29, 34, 35)
)

# View results
print(result)
summary(result)

# Generate visualizations
plots <- plot_all(result, 
                  start_year = 1989,
                  unit_name = "Treatment Unit",
                  outcome_label = "Outcome Variable")
```

## Core Functions

### 1. Main Analysis Function

#### `run_scm_spillover()`
Performs complete SCM analysis with spillover effects

**Parameters:**
- `data`: Panel data matrix (periods × units)
- `treatment_start`: Treatment start period (integer)
- `treated_unit`: Column index of treated unit (default = 1)
- `affected_units`: Vector of indices for all affected units
- `verbose`: Whether to display progress information

**Returns:**
- `spillover_effects`: Treatment effects adjusted for spillovers
- `vanilla_effects`: Traditional SCM treatment effects
- `ci_lower`, `ci_upper`: 95% confidence intervals
- `synthetic`: Synthetic control unit values

### 2. Visualization Functions

#### `plot_all()`
Generates a complete set of analysis charts

```r
plots <- plot_all(
  result,                    # Analysis result object
  start_year = 2010,        # Start year (optional)
  unit_name = "Beijing",     # Unit name
  outcome_label = "GDP Growth Rate", # Outcome variable label
  treatment_label = "Policy Implementation" # Treatment label
)
```

Generates three charts:
1. **Method Comparison Plot**: Compares spillover-adjusted SCM vs traditional SCM
2. **Effect Confidence Interval Plot**: Shows statistical significance
3. **Time Series Plot**: Actual values vs synthetic control

### 3. Low-level Functions

#### Core Estimation Functions
- `sp_estimation()`: Spillover-adjusted estimation
- `sp_andrews_te()`: Andrews treatment effect test
- `sp_andrews_spillover()`: Spillover effect test

#### Traditional SCM Functions
- `scm()`: Synthetic control for single unit
- `scm_batch()`: Batch computation for all units
- `vanilla_scm()`: Standard SCM (for comparison)

## Practical Application Cases

### Case 1: Policy Evaluation (California Cigarette Tax)

```r
# Load cigarette sales data
load("cigs.RData")

# Analyze Proposition 99 impact
result_cigs <- run_scm_spillover(
  data = cigs,
  treatment_start = 20,  # 1989
  treated_unit = 1,       # California
  affected_units = c(1, 5, 6, 9, 15, 23, 24, 25, 29, 34, 35)
)

# Visualize results
plots <- plot_all(
  result_cigs,
  start_year = 1989,
  unit_name = "California",
  outcome_label = "Per Capita Cigarette Sales (packs)",
  treatment_label = "Proposition 99"
)

# Extract key results
cat("Average Treatment Effect (with spillovers):", mean(result_cigs$spillover_effects), "\n")
cat("Average Treatment Effect (traditional):", mean(result_cigs$vanilla_effects), "\n")
```

### Case 2: Testing with Simulated Data

```r
# Generate test data
test_data <- matrix(rnorm(30*20, 100, 10), 30, 20)

# Add treatment effect
test_data[20:30, 1] <- test_data[20:30, 1] - 15

# Run analysis
result_test <- run_scm_spillover(
  data = test_data,
  treatment_start = 20,
  affected_units = c(1, 2, 3)  # Assume spillovers to units 2 and 3
)

plots <- plot_all(result_test, 
                  start_year = 2001,
                  unit_name = "Treatment Group",
                  outcome_label = "Outcome Variable")
```

## Methodological Notes

### Importance of Spillover Effects

Traditional SCM assumes SUTVA (Stable Unit Treatment Value Assumption), meaning one unit's treatment does not affect other units. However, in many practical situations, this assumption does not hold:

- **Economic Policy**: Policies in one region may affect neighboring regions
- **Public Health**: Vaccination has herd immunity effects
- **Educational Reform**: Demonstration schools may influence surrounding schools

### This Package's Solution

1. **Model Spillover Structure**: Define which units may be affected through matrix A
2. **Adjust Estimation Method**: Correct bias in traditional SCM
3. **Statistical Inference**: Provide hypothesis testing that accounts for spillovers

## Output Interpretation

### Result Object Structure

```r
result$spillover_effects  # Spillover-adjusted effects by period
result$vanilla_effects    # Traditional SCM effects
result$ci_lower          # Lower confidence interval bound
result$ci_upper          # Upper confidence interval bound
result$synthetic         # Synthetic control values
```

### Effect Interpretation

- **Negative Effects**: Treatment reduced the outcome variable (e.g., cigarette tax reduces sales)
- **Positive Effects**: Treatment increased the outcome variable (e.g., training increases productivity)
- **Confidence Interval Excluding 0**: Effect is statistically significant

## Common Issues

## Citation

If you use this package in your research, please cite:

```
Cao, J. and Dowd, C. (2019). "Estimation and Inference for Synthetic Control Methods with Spillover Effects." Working Paper.
```

## License

MIT License

## Contact and Support

- Report issues: fu.zhanc@northeastern.edu
- Contact authors: Jianfei Cao <j.cao@northeastern.edu> and Connor Dowd <cd@codowd.com>

## Changelog

### v0.1.0 (2025-11)
- Initial release
- Implemented core SCM spillover effect estimation
- Added visualization functionality
- Support for general panel data

---

**Note**: This package is under active development. Contributions and suggestions are welcome!


