from typing import List


def get_probability(arr: List[int]):
    p_k: int = 1

    for x in arr:
        p_k *= x

    return p_k


def get_duty_cycle(gate: str, p: List[int]):
    duty_p = (
        get_probability(arr=p) if gate == "and" else sum(p) - get_probability(arr=p)
    )
    duty_n = 1 - duty_p

    return f"duty cycle for gate {gate}-{len(p)} w/ p-probabilities {p}: nmos: {duty_n} pmos: {duty_p}"
