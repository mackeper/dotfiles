from datetime import datetime, timedelta

import numpy as np


def calculate_period_cycle(dates: list[tuple[str, str]]) -> tuple[float, datetime]:
    if len(dates) < 2:
        raise ValueError(
            "At least two date ranges are required to calculate the cycle length."
        )

    start_dates = [datetime.strptime(start, "%Y-%m-%d") for start, end in dates]
    cycle_lengths = [
        (start_dates[i] - start_dates[i - 1]).days for i in range(1, len(start_dates))
    ]

    # Remove outliers using the IQR method
    q1, q3 = np.percentile(cycle_lengths, [25, 75])
    iqr = q3 - q1
    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr

    filtered_cycle_lengths = [
        x for x in cycle_lengths if lower_bound <= x <= upper_bound
    ]

    if not filtered_cycle_lengths:
        raise ValueError("No cycle lengths remain after removing outliers.")

    average_cycle_length = sum(filtered_cycle_lengths) / len(filtered_cycle_lengths)
    return average_cycle_length, start_dates[-1]


def predict_next_period_and_fertile_window(
    last_period_start: datetime, average_cycle_length: float
):
    next_period_start = last_period_start + timedelta(days=average_cycle_length)
    ovulation_date = next_period_start - timedelta(days=14)
    fertile_window_start = ovulation_date - timedelta(days=5)
    fertile_window_end = ovulation_date + timedelta(days=1)

    return {
        "next_period_start": next_period_start.strftime("%Y-%m-%d"),
        "ovulation_date": ovulation_date.strftime("%Y-%m-%d"),
        "fertile_window": (
            fertile_window_start.strftime("%Y-%m-%d"),
            fertile_window_end.strftime("%Y-%m-%d"),
        ),
    }


if __name__ == "__main__":
    period_dates = [
        ("2024-03-21", "2024-03-26"),
        ("2024-05-10", "2024-05-13"),
        ("2024-06-10", "2024-06-14"),
        ("2024-07-04", "2024-07-07"),
        ("2024-08-01", "2024-08-04"),
        ("2024-08-26", "2024-08-29"),
        ("2024-09-23", "2024-09-26"),
        ("2024-10-16", "2024-10-19"),
        ("2024-11-12", "2024-11-16"),
    ]

    try:
        average_cycle, last_period_start = calculate_period_cycle(period_dates)
        print(
            f"The average cycle length (excluding outliers) is {average_cycle:.2f} days."
        )

        predictions = predict_next_period_and_fertile_window(
            last_period_start, average_cycle
        )
        print(f"Predicted start of next period: {predictions['next_period_start']}")
        print(f"Estimated ovulation date: {predictions['ovulation_date']}")
        print(
            "Fertile window: "
            f"{predictions['fertile_window'][0]} to "
            f"{predictions['fertile_window'][1]}"
        )
    except ValueError as e:
        print(f"Error: {e}")
