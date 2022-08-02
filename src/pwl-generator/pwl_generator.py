import argparse
import random
from functools import partial
from typing import List


def parse_args() -> argparse.Namespace:
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument("--length", required=False, default=1000)
    argument_parser.add_argument("--period", required=False ,default=5e-9)
    return argument_parser.parse_args()


def generate_base_bitstream(length: int) -> List[int]:
    bitstream = []
    for _ in range(length):
        bitstream.append(random.randint(a=0, b=1))
    return bitstream


def generate_pwl(
    bitstream: List[int], t_0: int, t_r: int, v_u: float, v_d: float
) -> str:
    """
    Generates a string of time-voltage pairs from a binary bitstream

    Args: 
        bitstream (List[int]): bitstream to be parsed
        t_0 (int): signal base period
        t_r (int): lohi/hilo transition period (note: t_r << t_0 for a square target signal)
        v_u (float): voltage for high
        v_d (float): voltage for low

    Returns:
        str: string of type "t0 v0 t1 v1 ... tn vn"
    """
    pwl = f"0 {v_d} " if bitstream[0] == 0 else f"0 {v_u} "

    for i in range(1, len(bitstream)):
        if bitstream[i - 1] == 0 and bitstream[i] == 0:
            pwl += f"{i*t_0} {v_d} {i*t_0 + t_r} {v_d} "
        elif bitstream[i - 1] == 0 and bitstream[i] == 1:
            pwl += f"{i*t_0} {v_d} {i*t_0 + t_r} {v_u} "
        elif bitstream[i - 1] == 1 and bitstream[i] == 0:
            pwl += f"{i*t_0} {v_u} {i*t_0 + t_r} {v_d} "
        elif bitstream[i - 1] == 1 and bitstream[i] == 1:
            pwl += f"{i*t_0} {v_u} {i*t_0 + t_r} {v_u} "

    return pwl[:-1]


def get_pwl_source(source_name: str, pwl: str) -> str:
    return f"v_{source_name} {source_name} 0 pwl({pwl})\n"


def main() -> None:
    args = parse_args()
    length, period = list(map(int, [args.length, args.period]))
    inputs = [
        "a_in_0",
        "a_in_1",
        "a_in_2",
        "a_in_3",
        "b_in_0",
        "b_in_1",
        "b_in_2",
        "b_in_3",
    ]
    base_bitstreams = []
    for _ in inputs:
        base_bitstreams.append(generate_base_bitstream(length=length))
    pwls = list(
        map(partial(generate_pwl, t_0=period, t_r=10e-12, v_u=1, v_d=0), base_bitstreams)
    )
    sources = list(map(get_pwl_source, inputs, pwls))

    for input, bitstream in zip(inputs, base_bitstreams):
        print(input, bitstream)

    with open("sources.txt", "w") as f:
        f.writelines(sources)


if __name__ == "__main__":
    main()
