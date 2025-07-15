# Momentum Portfolio Strategy (stock returns using CRSP data)

---

## 1. Introduction

 This project analyzes stock momentum and evaluates cumulative returns for a long-short momentum portfolio using CRSP data from 2004 to 2008. The goal is to identify patterns in stock performance and assess the profitability of a momentum-based investment strategy.
---

## 2. Methodology

### 2.1 Data Preparation

We imported the CRSP dataset containing daily stock data using the ”readtable” function.
 We then converted the DateofObservation variable into MATLAB’s datenum format for easier
 manipulation, and then extracted year and month components to facilitate the analysis.
 <img width="821" height="106" alt="image" src="https://github.com/user-attachments/assets/47cb3571-0d1b-44ea-8931-af5b58077048" />


### 2.2 Momentum Function
- A custom function `getMomentum` was developed to calculate the 11-month cumulative gross return for each stock using identifiers and timestamps.

-  Using our getMomentum function, we were able to calculate momentum for each stock and month in a for-loop as shown below.

<img width="856" height="318" alt="image" src="https://github.com/user-attachments/assets/f237c5af-abab-47a7-b7f6-c5959dfe7c99" />

### 2.3 Portfolio Construction
We sorted stocks into deciles based on momentum values for each date. The bottom decile represents the lowest 10% of momentum values, and the top decile represents the highest 10% of momentum values.
Then we derived mom1 and mom10, respectively, the equal-weighted returns on the stock in the bottom momentum decile and in the top momentum decile. With those values, we were able to obtain the returns of the portfolio that longs winners and shorts losers (stored in ”mom”).

### 2.4 Cumulative Returns
- Cumulative returns were computed by compounding the portfolio return across months.

---

## 📊 3. Results and Discussion

The cumulative return graph (not included here) showed:

<img width="546" height="540" alt="image" src="https://github.com/user-attachments/assets/bd826af8-bdf7-462e-ae76-d38e33f0a1ea" />

- **Strong performance** of the momentum strategy prior to 2008
- **Drawdowns during the financial crisis**, likely due to the strategy lagging fast-moving market shifts
- Outperformance relative to the S&P 500, which dropped by 26% in the same period

### Strategy Risks
- Long-short momentum strategies are vulnerable to volatility
- Monthly rebalancing may miss key intramonth events
- Effectiveness may be reduced today due to greater awareness and faster information flow

---

##  Files Included

- `Momentum.m`: main MATLAB script with momentum function and portfolio simulation
- `crsp20042008.csv`: CRSP dataset (2004–2008)

---

##  Authors

- Matthieu Fouilloux  
- Giulia Gambaretto  
- McGill University, 
- December 2024
