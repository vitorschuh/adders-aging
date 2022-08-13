import os
from os import path


def parse_logs(raw_path: str, processed_path: str, target: str) -> None:
    source = path.join(raw_path, target)
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
    raw_path = "netlists/4-bit-lookahead/logs/raw/"
    processed_path = "netlists/4-bit-lookahead/logs/processed/"
    signals = [
        "a_0",
        "a_1",
        "a_2",
        "a_3",
        "b_0",
        "b_1",
        "b_2",
        "b_3",
        "c_in",
        "s_0",
        "s_1",
        "s_2",
        "s_3",
        "c_1",
        "c_2",
        "c_3",
        "c_out",
    ]

    for signal in signals:
        parse_logs(
            raw_path=raw_path, processed_path=processed_path, target=f"{signal}.log"
        )
