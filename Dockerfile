# Use the base image from Freqtrade.
FROM freqtradeorg/freqtrade:stable_plot

# Copy over required files.
COPY ./user_data/config.json /freqtrade/user_data/config.json
COPY ./user_data/strategies /freqtrade/user_data/strategies
COPY ./user_data/hyperopts /freqtrade/user_data/hyperopts

# Download the latest market information for the last 90 days in 1h resolutions.
RUN freqtrade download-data --exchange binance --days 90 -t 1h

# Run a backtest to get the baseline strategy performance.
RUN freqtrade backtesting --export trades --config user_data/config.json --strategy FrostAuraMark1Strategy -i 1h

# Run ML optimization(s).
RUN freqtrade hyperopt --config user_data/config.json -e 1500 --strategy FrostAuraMark1Strategy --hyperopt FrostAuraMark1HyperOpt --hyperopt-loss SharpeHyperOptLossDaily

# Substitute in optimized parameters.

# Run backtest to get optimized strategy performance.
RUN freqtrade backtesting --export trades --config user_data/config.json --strategy FrostAuraMark1Strategy -i 1h

# Report
## on the optimized results.
## on poor performance.