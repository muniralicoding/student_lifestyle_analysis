# 🎓 Statistical Analysis of Student Lifestyle and Academic Performance Using R

[![R Version](https://img.shields.io/badge/R-%3E%3D%204.2.0-blue.svg)](https://www.r-project.org/)
[![Course](https://img.shields.io/badge/MCA-Data%20Science%20(Sem%201)-darkgreen.svg)](#)
[![University](https://img.shields.io/badge/Chandigarh%20University-UIC-red.svg)](https://www.cuchd.in/)
[![License](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

An academic mini-project developed for **Statistics with R** (Course Code: MCA-611 / DS-501) in the **Master of Computer Applications (MCA) – Data Science** program at the **University Institute of Computing (UIC), Chandigarh University**.

---

## 📌 Project Overview

Academic achievement—measured through **Semester CGPA** and **Internal Examination Scores**—is directly shaped by everyday lifestyle routines. This mini-project establishes an end-to-end, reproducible statistical pipeline in Base R to analyze, model, and visualize how:
* **Lecture Attendance (%)**
* **Daily Self-Study Hours**
* **Nightly Sleep Duration**
* **Recreational Social Media Screentime**
* **Peer Study Group Collaboration**

influence academic outcomes among **$N = 100$ postgraduate data science students**. The project strictly emphasizes **foundational statistical methodology and R programming**, deliberately avoiding complex black-box machine learning algorithms.

---

## 📂 Repository Structure

```text
student_lifestyle_analysis/
│
├── student_lifestyle_analysis.R     # Complete, annotated R analysis script (201 lines)
├── student_lifestyle_dataset.csv    # Realistic cohort dataset (100 student records, 10 attributes)
├── PROJECT_REPORT.docx              # University-formatted project report (Word Document)
├── PROJECT_REPORT.md                # Full academic report in Markdown (UIC template)
├── build_docx.ps1                   # Automation script to assemble the .docx report
├── .gitignore                       # Git ignore configuration
└── README.md                        # Project documentation and guide
```

---

## 🔬 Research Hypotheses & Statistical Framework

| Hypothesis | Null Hypothesis ($H_0$) | Statistical Test | Decision | Key Insight |
| :--- | :--- | :--- | :--- | :--- |
| **Normality** | CGPA is normally distributed | Shapiro-Wilk Test (`shapiro.test`) | **Fail to Reject $H_0$** ($p = 0.082$) | Data conforms to Gaussian curve, validating parametric tests. |
| **Study Groups** | $\mu_{\text{Yes}} = \mu_{\text{No}}$ | Welch Two-Sample $t$-test (`t.test`) | **Reject $H_0$** ($p < 0.001$) | Study group members average **$+1.70$ higher CGPA** ($8.72$ vs. $7.02$). |
| **Gender Effect**| $\mu_{\text{Male}} = \mu_{\text{Female}}$ | Welch Two-Sample $t$-test (`t.test`) | **Fail to Reject $H_0$** ($p = 0.253$) | Academic performance is gender-neutral. |
| **Study Tiers** | Means across Low, Med, High tiers equal | One-Way ANOVA (`aov`) | **Reject $H_0$** ($F = 348.6, p < 0.001$) | Study duration tiers create significant performance divides. |
| **Grade Honor** | Grade Category $\perp$ Study Group | Pearson's $\chi^2$ Test (`chisq.test`) | **Reject $H_0$** ($\chi^2 = 54.34, p < 0.001$) | **97.2%** of Distinctions were earned by study group members. |

---

## 📊 Summary of Descriptive Statistics ($N = 100$)

| Feature | Mean | Median | Mode | Range | Variance | Std. Dev. ($s$) | IQR | $CV$ (%) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Semester CGPA** | **7.82** | **7.85** | **8.50** | 4.55 | 1.488 | 1.220 | 2.05 | 15.60% |
| **Daily Study Hours** | **4.17** | **4.10** | **4.00** | 6.00 | 2.298 | 1.516 | 2.30 | 36.35% |
| **Lecture Attendance %** | **81.65** | **82.50** | **88.00** | 36.50 | 96.12 | 9.804 | 15.25 | 12.01% |
| **Social Media Hours** | **2.91** | **2.65** | **2.00** | 5.30 | 1.764 | 1.328 | 2.10 | 45.64% |

### Pearson Correlation Matrix ($r$)
* **Study Hours vs. CGPA:** $r = \mathbf{+0.985}$ ($p < 0.001$, Very Strong Positive)
* **Attendance vs. CGPA:** $r = \mathbf{+0.963}$ ($p < 0.001$, Very Strong Positive)
* **Social Media vs. CGPA:** $r = \mathbf{-0.584}$ ($p < 0.001$, Moderate Negative)
* **Sleep Hours vs. CGPA:** $r = \mathbf{+0.832}$ ($p < 0.001$, Strong Positive)

---

## 📈 Visualizations Produced

The script exports a unified 6-panel statistical graphic:
1. **Histogram of Semester CGPA** with overlaid Kernel Density Estimation (KDE) and Gaussian normal curve.
2. **Frequency Bar Chart** of Grade Categories (Distinction, First Class, Second Class).
3. **Pie Chart** displaying relative grade honor percentages ($36\%$, $42\%$, $22\%$).
4. **Comparative Boxplot** displaying CGPA distributions across study groups with notched confidence intervals.
5. **Scatter Plot with Fitted Linear Regression Line** (Study Hours vs. CGPA).
6. **Progression Line Graph** mapping Internal Examination Scores across attendance percentages.

---

## 🚀 How to Run in R / RStudio

### Prerequisites
* [R](https://cran.r-project.org/) (Version $\ge 4.2.0$)
* [RStudio Desktop](https://posit.co/download/rstudio-desktop/)

### Execution
1. Clone this repository or download the project files:
   ```bash
   git clone https://github.com/muniralicoding/student_lifestyle_analysis.git
   ```
2. Open **RStudio** and set the working directory to the project folder:
   ```R
   setwd("path/to/student_lifestyle_analysis")
   ```
3. Run the complete analysis script:
   ```R
   source("student_lifestyle_analysis.R", echo = TRUE)
   ```
4. Output plots will be displayed in the RStudio plotting window and saved as `student_lifestyle_statistical_plots.png`.

---

## 💡 Key Takeaways
1. **Attendance is Essential:** Students maintaining $\ge 90\%$ attendance averaged a $9.08$ CGPA, compared to $5.92$ for those below $70\%$.
2. **The Collaborative Advantage:** Active participation in a peer study group yielded an average $+1.70$ increase in CGPA.
3. **Digital Screen-Time Deficit:** Each additional hour above $2.0$ hours of daily recreational social media was linked with an average $0.48$-point decrease in CGPA.

---

## 👤 Author

* **Munir Ali** ([@muniralicoding](https://github.com/muniralicoding))
* **Program:** MCA (Data Science) – 1st Semester
* **Department:** University Institute of Computing (UIC), Chandigarh University

---

## 📜 Academic Integrity & License
This project is submitted in partial fulfillment of the academic requirements for the **MCA Data Science** program at **Chandigarh University**. Open-sourced under the [MIT License](LICENSE).
