import os
import argparse
from os import path
from constants import (
    LOOKAHEAD_RAW_PATH,
    LOOKAHEAD_PROCESSED_PATH,
    LOOKAHEAD_INTERFACE_SIGNALS,
    SEQUENTIAL_RAW_PATH,
    SEQUENTIAL_PROCESSED_PATH,
    SEQUENTIAL_INTERFACE_SIGNALS,
)


def parse_args() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument(
        "--target", required=True, choices=["sequential", "lookahead"]
    )
    return argument_parser.parse_args()


def parse_logs(raw_path: str, processed_path: str, target: str) -> None:
    source = path.join(raw_path, f"{target}.log")
    tmp = path.join(raw_path, f"temp_{target}.csv")
    prefix = target.split(".")[0]
    dest = path.join(processed_path, f"{prefix}.csv")

    with open(file=source, mode="r") as s, open(file=tmp, mode="a") as t:
        for line in s.readlines():
            try:
                int(line[0])
                csv_line = line.replace("\t", ",")
                t.write(csv_line)
            except ValueError:
                continue

    with open(file=tmp, mode="r") as t, open(file=dest, mode="a") as d:
        d.write("index,time,voltage\n")
        for line in t.readlines():
            sanatized_line = line[:-2] + "\n"
            d.write(sanatized_line)

    os.system(command=f"rm -rf {tmp}")


if __name__ == "__main__":
    args = parse_args()
    raw_path = (
        SEQUENTIAL_RAW_PATH if args.target == "sequential" else LOOKAHEAD_RAW_PATH
    )
    processed_path = (
        SEQUENTIAL_PROCESSED_PATH
        if args.target == "sequential"
        else LOOKAHEAD_PROCESSED_PATH
    )
    signals = (
        SEQUENTIAL_INTERFACE_SIGNALS
        if args.target == "sequential"
        else LOOKAHEAD_INTERFACE_SIGNALS
    )

    for signal in signals:
        parse_logs(
            raw_path=raw_path, processed_path=processed_path, target=signal
        )
