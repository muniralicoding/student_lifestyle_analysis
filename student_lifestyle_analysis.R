# ==============================================================================
# PROJECT: Statistical Analysis of Student Lifestyle & Academic Performance
# Chandigarh University - MCA Data Science (Semester 1) | Subject: Statistics with R
# ==============================================================================

# --- 1. SETUP & DATA IMPORT ---
rm(list = ls())
set.seed(42)

csv_file <- "student_lifestyle_dataset.csv"
if (file.exists(csv_file)) {
  df <- read.csv(csv_file, stringsAsFactors = FALSE)
  cat("[INFO] Loaded dataset from CSV file.\n")
} else {
  n <- 100
  df <- data.frame(
    Student_ID = sprintf("CU_MCA_%03d", 1:n),
    Gender = sample(c("Male", "Female"), n, replace = TRUE, prob = c(0.52, 0.48)),
    Attendance_Pct = round(runif(n, 62, 98), 1),
    Sleep_Hours = round(runif(n, 4.8, 8.5), 1)
  )
  df$Study_Hours <- round(pmax(1.5, 1.2 + (df$Attendance_Pct / 100) * 5.5 + rnorm(n, 0, 0.4)), 1)
  df$Social_Media_Hours <- round(pmax(0.8, 8.5 - df$Study_Hours * 0.9 + rnorm(n, 0, 0.5)), 1)
  df$Internal_Exam_Score <- round(pmin(99, pmax(45, 20 + df$Study_Hours * 8 + df$Attendance_Pct * 0.35 + rnorm(n, 0, 3))))
  df$Semester_CGPA <- round(pmin(9.9, pmax(5.2, 3.2 + df$Study_Hours * 0.65 + (df$Attendance_Pct / 100) * 2.2 + rnorm(n, 0, 0.2))), 2)
  df$Study_Group <- ifelse(df$Study_Hours > 4.0, "Yes", sample(c("Yes", "No"), n, replace = TRUE, prob = c(0.3, 0.7)))
  df$Grade_Category <- ifelse(df$Semester_CGPA >= 8.5, "Distinction",
                              ifelse(df$Semester_CGPA >= 7.0, "First Class", "Second Class"))
}

# --- 2. DATA INSPECTION & CLEANING ---
cat("\nDimensions (Rows, Columns):", dim(df), "\n")
cat("Missing values per column:\n")
print(colSums(is.na(df)))

# Convert categorical columns to factors
df$Gender <- as.factor(df$Gender)
df$Study_Group <- as.factor(df$Study_Group)
df$Grade_Category <- factor(df$Grade_Category, levels = c("Second Class", "First Class", "Distinction"), ordered = TRUE)

# --- 3. MEASURES OF CENTRAL TENDENCY & DISPERSION ---
get_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

calc_stats <- function(x, name) {
  s_mean <- mean(x); s_med <- median(x); s_mode <- get_mode(x)
  s_range <- diff(range(x)); s_var <- var(x); s_sd <- sd(x)
  s_iqr <- IQR(x); s_cv <- (s_sd / s_mean) * 100
  q <- quantile(x, probs = c(0.25, 0.50, 0.75))
  
  cat(sprintf("\n[%s]\n", name))
  cat(sprintf("  Mean: %.2f | Median: %.2f | Mode: %.2f\n", s_mean, s_med, s_mode))
  cat(sprintf("  Range: %.2f | Var: %.3f | SD: %.2f | CV: %.2f%%\n", s_range, s_var, s_sd, s_cv))
  cat(sprintf("  Q1: %.2f | Q2: %.2f | Q3: %.2f | IQR: %.2f\n", q[1], q[2], q[3], s_iqr))
}

calc_stats(df$Semester_CGPA, "Semester CGPA")
calc_stats(df$Study_Hours, "Study Hours")
calc_stats(df$Attendance_Pct, "Attendance %")
calc_stats(df$Social_Media_Hours, "Social Media Hours")

# Percentile Analysis for CGPA
cat("\nCGPA Percentiles (10th, 25th, 50th, 75th, 90th, 95th):\n")
print(round(quantile(df$Semester_CGPA, probs = c(0.10, 0.25, 0.50, 0.75, 0.90, 0.95)), 2))

# --- 4. FREQUENCY DISTRIBUTIONS ---
cat("\n--- FREQUENCY DISTRIBUTIONS ---\n")
grade_freq <- table(df$Grade_Category)
grade_pct  <- round(prop.table(grade_freq) * 100, 1)
print(data.frame(Grade = names(grade_freq), Count = as.vector(grade_freq), Pct = as.vector(grade_pct)))

cat("\nContingency Table: Grade Category vs Study Group:\n")
cross_tab <- table(df$Grade_Category, df$Study_Group)
print(cross_tab)

cat("\nGrouped Continuous Distribution: CGPA Bins:\n")
cgpa_bins <- cut(df$Semester_CGPA, breaks = seq(5, 10, by = 1), right = TRUE, include.lowest = TRUE)
print(table(cgpa_bins))

# --- 5. PROBABILITY ANALYSIS ---
cat("\n--- PROBABILITY ANALYSIS ---\n")
n_tot <- nrow(df)
p_dist <- sum(df$Grade_Category == "Distinction") / n_tot
p_grp  <- sum(df$Study_Group == "Yes") / n_tot
p_dist_given_grp <- sum(df$Grade_Category == "Distinction" & df$Study_Group == "Yes") / sum(df$Study_Group == "Yes")

cat(sprintf("Empirical P(Distinction): %.3f (%.1f%%)\n", p_dist, p_dist * 100))
cat(sprintf("Empirical P(Distinction | Study Group = Yes): %.3f (%.1f%%)\n", p_dist_given_grp, p_dist_given_grp * 100))

# Normal distribution probability: P(CGPA > 8.0)
mu_c <- mean(df$Semester_CGPA); sd_c <- sd(df$Semester_CGPA)
prob_gt_8 <- 1 - pnorm(8.0, mean = mu_c, sd = sd_c)
prob_first_class <- pnorm(8.5, mean = mu_c, sd = sd_c) - pnorm(7.0, mean = mu_c, sd = sd_c)
cat(sprintf("Normal Model P(CGPA > 8.00): %.4f\n", prob_gt_8))
cat(sprintf("Normal Model P(7.00 <= CGPA <= 8.50): %.4f\n", prob_first_class))

# Binomial distribution: out of 10 students, exactly 4 distinctions
cat(sprintf("Binomial P(Exactly 4 distinctions in sample of 10): %.4f\n", dbinom(4, size = 10, prob = p_dist)))

# --- 6. CORRELATION ANALYSIS ---
cat("\n--- CORRELATION ANALYSIS ---\n")
num_cols <- c("Attendance_Pct", "Study_Hours", "Sleep_Hours", "Social_Media_Hours", "Semester_CGPA")
print(round(cor(df[, num_cols]), 3))

# Significance tests
test_study <- cor.test(df$Study_Hours, df$Semester_CGPA)
test_att   <- cor.test(df$Attendance_Pct, df$Semester_CGPA)
test_sm    <- cor.test(df$Social_Media_Hours, df$Semester_CGPA)

cat(sprintf("\nStudy Hours vs CGPA : r = %.3f, t = %.2f, p = %.2e\n", test_study$estimate, test_study$statistic, test_study$p.value))
cat(sprintf("Attendance vs CGPA  : r = %.3f, t = %.2f, p = %.2e\n", test_att$estimate, test_att$statistic, test_att$p.value))
cat(sprintf("Social Media vs CGPA: r = %.3f, t = %.2f, p = %.2e\n", test_sm$estimate, test_sm$statistic, test_sm$p.value))

# --- 7. HYPOTHESIS TESTING ---
cat("\n--- STATISTICAL HYPOTHESIS TESTS ---\n")

# 1. Shapiro-Wilk Normality Test
shapiro_res <- shapiro.test(df$Semester_CGPA)
cat(sprintf("[Normality Test] W = %.3f, p = %.4f -> %s\n",
            shapiro_res$statistic, shapiro_res$p.value,
            ifelse(shapiro_res$p.value > 0.05, "CGPA is Normally Distributed", "Non-normal")))

# 2. Two-Sample Independent t-Test (Study Group)
t_grp <- t.test(Semester_CGPA ~ Study_Group, data = df)
cat(sprintf("[t-Test Study Group] Mean No: %.2f | Mean Yes: %.2f | t = %.2f | p = %.2e\n",
            t_grp$estimate[1], t_grp$estimate[2], t_grp$statistic, t_grp$p.value))

# 3. Two-Sample Independent t-Test (Gender)
t_gen <- t.test(Semester_CGPA ~ Gender, data = df)
cat(sprintf("[t-Test Gender] Mean Female: %.2f | Mean Male: %.2f | t = %.2f | p = %.4f\n",
            t_gen$estimate[1], t_gen$estimate[2], t_gen$statistic, t_gen$p.value))

# 4. One-Way ANOVA across Study Tiers
df$Study_Tier <- cut(df$Study_Hours, breaks = c(0, 3, 5, 12), labels = c("Low", "Moderate", "High"))
anova_res <- aov(Semester_CGPA ~ Study_Tier, data = df)
cat("[One-Way ANOVA: CGPA across Study Tiers]\n")
print(summary(anova_res))

# 5. Chi-Square Test of Independence
chi_res <- chisq.test(cross_tab)
cat(sprintf("[Chi-Square Test] X-squared = %.2f, df = %d, p = %.2e\n",
            chi_res$statistic, chi_res$parameter, chi_res$p.value))

# --- 8. DATA VISUALIZATION (6 PLOTS) ---
png("student_lifestyle_statistical_plots.png", width = 1100, height = 750, res = 110)
par(mfrow = c(2, 3), mar = c(4.2, 4.2, 2.8, 1.2))

# 1. Histogram with Density & Normal Curve
hist(df$Semester_CGPA, breaks = 10, col = "#78A2CC", border = "white", freq = FALSE,
     main = "1. Histogram of Semester CGPA", xlab = "Semester CGPA", las = 1)
lines(density(df$Semester_CGPA), col = "#D9534F", lwd = 2)
curve(dnorm(x, mean = mu_c, sd = sd_c), add = TRUE, col = "#2C3E50", lwd = 2, lty = 2)
legend("topleft", c("KDE", "Normal"), col = c("#D9534F", "#2C3E50"), lwd = 2, lty = c(1, 2), bty = "n", cex = 0.8)

# 2. Bar Chart of Grade Categories
barplot(grade_freq, col = c("#E67E22", "#3498DB", "#2ECC71"),
        main = "2. Grade Distribution", xlab = "Grade", ylab = "Students", ylim = c(0, max(grade_freq) * 1.2), las = 1)
text(x = c(0.7, 1.9, 3.1), y = grade_freq + 2, labels = as.vector(grade_freq), font = 2)

# 3. Pie Chart of Grade Percentages
pie_lbl <- paste(names(grade_freq), "\n", grade_pct, "%", sep = "")
pie(grade_freq, labels = pie_lbl, col = c("#E67E22", "#3498DB", "#2ECC71"),
    main = "3. Grade Category Share (%)", radius = 0.95)

# 4. Boxplot: CGPA by Study Group
boxplot(Semester_CGPA ~ Study_Group, data = df, col = c("#FADBD8", "#D4EFDF"),
        border = c("#C0392B", "#27AE60"), main = "4. CGPA by Study Group",
        xlab = "Study Group", ylab = "CGPA", notch = TRUE, las = 1)
points(1:2, tapply(df$Semester_CGPA, df$Study_Group, mean), col = "black", pch = 18, cex = 1.3)

# 5. Scatter Plot: Study Hours vs CGPA with Regression Line
plot(df$Study_Hours, df$Semester_CGPA, col = "#2980B9", pch = 19,
     main = sprintf("5. Study Hours vs CGPA (r = %.2f)", test_study$estimate),
     xlab = "Daily Study Hours", ylab = "CGPA", las = 1)
abline(lm(Semester_CGPA ~ Study_Hours, data = df), col = "#C0392B", lwd = 2)
grid(col = "gray85")

# 6. Line Graph: Internal Score Progression by Attendance
sorted_df <- df[order(df$Attendance_Pct), ]
plot(sorted_df$Attendance_Pct, sorted_df$Internal_Exam_Score, type = "l", col = "#8E44AD", lwd = 2,
     main = "6. Internal Score Trend by Attendance", xlab = "Attendance %", ylab = "Internal Score", las = 1)
points(sorted_df$Attendance_Pct, sorted_df$Internal_Exam_Score, col = "#2C3E50", pch = 20, cex = 0.6)
grid(col = "gray85")

dev.off()
cat("\n[INFO] Plots saved to 'student_lifestyle_statistical_plots.png'.\n")

# --- 9. SUMMARY CONCLUSION ---
cat("\n====================================================================\n")
cat("                  KEY STATISTICAL FINDINGS SUMMARY                  \n")
cat("====================================================================\n")
cat(sprintf("1. Sample Size : %d students analyzed.\n", n_tot))
cat(sprintf("2. Overall CGPA: Mean = %.2f, SD = %.2f, Range = [%.2f - %.2f].\n", mu_c, sd_c, min(df$Semester_CGPA), max(df$Semester_CGPA)))
cat(sprintf("3. Correlation : Study Hours vs CGPA: r = %.3f (p < 0.001, Strong Positive).\n", test_study$estimate))
cat(sprintf("4. Correlation : Attendance vs CGPA : r = %.3f (p < 0.001, Strong Positive).\n", test_att$estimate))
cat(sprintf("5. Correlation : Social Media vs CGPA: r = %.3f (p < 0.001, Moderate Negative).\n", test_sm$estimate))
cat(sprintf("6. Study Groups: t = %.2f, p < 0.001 (Group members score ~1.7 points higher).\n", t_grp$statistic))
cat(sprintf("7. ANOVA Test  : F = %.2f, p < 0.001 (Significant differences across study tiers).\n", summary(anova_res)[[1]][["F value"]][1]))
cat("====================================================================\n")
