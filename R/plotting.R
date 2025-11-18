#' Generate all plots for SCM analysis
#'
#' @param result Output from run_scm_spillover
#' @param start_year First year of treatment period
#' @param unit_name Name of treated unit (default "Treated Unit")
#' @param outcome_label Label for outcome variable (default "Outcome")
#' @param treatment_label Label for treatment (default "Treatment")
#' @export
plot_all <- function(result,
                     start_year = NULL,
                     unit_name = "Treated Unit",
                     outcome_label = "Outcome",
                     treatment_label = "Treatment") {

  require(ggplot2)

  # Automatically generate the year or period
  n_post <- length(result$spillover_effects)
  if (is.null(start_year)) {
    periods <- 1:n_post
    x_label <- "Post-treatment Period"
  } else {
    periods <- start_year:(start_year + n_post - 1)
    x_label <- "Year"
  }

  # Plot 1: Method Comparison
  df_compare <- data.frame(
    Period = rep(periods, 2),
    Effect = c(result$spillover_effects, result$vanilla_effects),
    Method = factor(rep(c("Spillover-Adjusted", "Standard SCM"), each = n_post))
  )

  p1 <- ggplot(df_compare, aes(x = Period, y = Effect, color = Method)) +
    geom_line(aes(linetype = Method), size = 1.2) +
    geom_point(size = 2.5) +
    geom_hline(yintercept = 0, linetype = "dotted", alpha = 0.5) +
    scale_color_manual(values = c("Spillover-Adjusted" = "#0072B2",
                                  "Standard SCM" = "#D55E00")) +
    labs(title = paste("Treatment Effects Comparison:", unit_name),
         subtitle = "Spillover-Adjusted vs Standard Synthetic Control",
         x = x_label,
         y = paste("Treatment effect on", outcome_label)) +
    theme_minimal() +
    theme(legend.position = "bottom")

  # Plot 2: Confidence interval
  df_ci <- data.frame(
    Period = periods,
    Effect = result$spillover_effects,
    Lower = result$ci_lower,
    Upper = result$ci_upper
  )

  p2 <- ggplot(df_ci, aes(x = Period, y = Effect)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "red", alpha = 0.6) +
    geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = 0.2, fill = "#0072B2") +
    geom_errorbar(aes(ymin = Lower, ymax = Upper),
                  width = 0.25, color = "gray40", alpha = 0.7) +
    geom_line(color = "#0072B2", size = 1.2) +
    geom_point(size = 3, color = "#0072B2") +
    labs(title = paste("Spillover-Adjusted Treatment Effects:", unit_name),
         subtitle = "With 95% Confidence Intervals",
         x = x_label,
         y = paste("Treatment effect on", outcome_label)) +
    theme_minimal()

  # Plot 3: Time series (actual vs synthetic)）
  n_total <- ncol(result$data$Y0) + ncol(result$data$Y1)

  if (!is.null(start_year)) {
    # If a starting year is provided, calculate the entire period.
    n_pre <- ncol(result$data$Y0)
    periods_full <- (start_year - n_pre):(start_year + n_post - 1)
    treatment_time <- start_year - 0.5
  } else {
    periods_full <- 1:n_total
    treatment_time <- ncol(result$data$Y0) + 0.5
  }

  Y_all <- cbind(result$data$Y0, result$data$Y1)

  df_series <- data.frame(
    Period = rep(periods_full, 2),
    Value = c(
      Y_all[1, ],  # actual value
      c(result$data$Y0[1, ], result$synthetic)  # Synthetic control
    ),
    Type = factor(rep(c(paste("Actual", unit_name),
                        "Synthetic Control (Spillover-Adjusted)"),
                      each = n_total))
  )

  p3 <- ggplot(df_series, aes(x = Period, y = Value, color = Type)) +
    geom_line(size = 1) +
    geom_vline(xintercept = treatment_time, linetype = "dashed", alpha = 0.5) +
    annotate("text",
             x = treatment_time - 1,
             y = max(df_series$Value) * 0.95,
             label = paste(treatment_label, "→"),
             hjust = 1,
             size = 3.5) +
    scale_color_manual(values = c("#E69F00", "#0072B2")) +
    labs(title = paste("Actual vs Synthetic Control:", unit_name),
         x = x_label,
         y = outcome_label) +
    theme_minimal() +
    theme(legend.position = "bottom")

  # print plot
  print(p1)
  cat("Showing plot 1 of 3...\n")
  invisible(readline("Press Enter for next plot..."))

  print(p2)
  cat("Showing plot 2 of 3...\n")
  invisible(readline("Press Enter for next plot..."))

  print(p3)
  cat("Showing plot 3 of 3.\n")

  # Return all chart objects
  invisible(list(p1 = p1, p2 = p2, p3 = p3))
}
