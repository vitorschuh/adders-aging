# circuit designs

this repo consists on a remote env to centralize some hardware netlists and high-level utils related to my undergrad thesis on B.Sc computer engineering degree

text versioning is kept on another remote and will be appended at the end

the work is entitled 'Impact of charge trap kinetics on CMOS adder circuits' and aims to metrify the delays induced in circuit critical-signals by the contribution of eletric variability effects modeled by traps in cmos adders

## hierarchy
```
├─ /netlists
│  ├─ /4-bit-adder
│  │  ├─ /logic                     -- logic gates under test --
│  │  └─ 4-bit-adder.cir      
│  └─ /4-bit-lookahead
└─ /src
   └─ /pwl-generator                -- generates piecewise linear sources dynamically --
```