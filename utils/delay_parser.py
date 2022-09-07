import argparse
from os import path

RCA_ROOT_DATA_DIR = "core/ripple-carry/logs/"
CLA_ROOT_DATA_DIR = "core/carry-lookahead/logs/"


def parse_args() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument(
        "--target",
        required=True,
        choices=[
            "ripple",
            "lookahead",
        ],
    )
    return argument_parser.parse_args()


def parse_logs(base: str) -> None:
    for i in range(-7, 8):
        source_file_path = path.join(base, "raw", f"1e{i}_delays.log")
        target_file_path = path.join(base, "processed", f"1e{i}_delays.csv")

        with open(source_file_path, mode="r") as s, open(
            target_file_path, mode="w"
        ) as t:
            wcp = []
            wsp = []
            for line in s.readlines():
                delay, measure = line.replace("\n", "").split(" = ")
                if delay == "v(wcp)":
                    wcp.append(measure)
                else:
                    wsp.append(measure)

            t.write("worst_carry_propagate,worst_sum_propagate\n")
            for idx in range(100):
                t.write(f"{wcp[idx]},{wsp[idx]}\n")


def main():
    args = parse_args()
    root_data_dir = RCA_ROOT_DATA_DIR if args.target == "ripple" else CLA_ROOT_DATA_DIR
    parse_logs(base=root_data_dir)


if __name__ == "__main__":
    main()
