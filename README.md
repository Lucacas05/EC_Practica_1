# EC_Practica_1

RISC-V assembly exercises implementing combinatorics and numerical series/transformations. The repository contains a single source file, `exercises.s`, with several callable routines grouped by three exercises.

This work was part of an assessment for the course "Estructura de Computadores" at Universidad Carlos III de Madrid (UC3M). The exercises were developed and evaluated using CREATOR, the software provided by the university.

## Contents

- `exercises.s`: RISC-V (RV32I + single-precision FP) assembly with:
  - `Binomial_coef(n, k) -> a0`: Computes C(n, k) = n! / (k!·(n−k)!) using integer arithmetic. Returns in `a0`.
  - `Newton_int(n, a, b) -> fa0`: Newton binomial expansion ∑ C(n,k)·a^{n−k}·b^k for k=0..n. Uses a float `pow` routine (jal to `pow`). Returns in `fa0`.
  - `E(x) -> fa0`: Approximates e^x via Taylor series with 20 terms: sum_{k=0}^{19} x^k / k!. Returns in `fa0`.
  - `Arctanh(y) -> fa0`: Approximates artanh(y) via series with 20 terms: y + y^3/3 + y^5/5 + ... Returns in `fa0`.
  - `Ln(x) -> fa0`: Computes ln(x) using the identity ln(x) = 2·artanh((x−1)/(x+1)). Returns NaN for x ≤ 0.
  - `powf(a, b) -> fa0`: Computes a^b using e^{b·ln(a)} with the above `Ln` and `E`.
  - `Newton_real(a, b, n) -> fa0`: Real-valued Newton expansion using a series approach (20 terms). Returns NaN if n < 0.
  - `Compute_pows(mat, N, a, b, c)`: Fills an N×N float matrix at base address `mat` with `Newton_real(a+i, b+j, c)` for 0 ≤ i,j < N.

## Calling Conventions

- Integer args: `a0`, `a1`, ...; return in `a0`.
- Float args: `fa0`, `fa1`, `fa2`; return in `fa0`.
- Callee-saved registers are preserved (`s0..s4`, `fs0..fs4`, `ra`). Stack is adjusted per routine.

## Numerical Notes

- Series truncation: Many routines use 20 terms for performance and simplicity; accuracy improves as inputs are near series convergence regions.
- Domain checks:
  - `Ln(x)`: Returns IEEE-754 NaN for x ≤ 0 (constructed as `0x7FC00000`).
  - `Newton_real(a, b, n)`: Returns NaN when n < 0.
- `Binomial_coef` uses integer factorials; large `n` can overflow 32-bit.

## Notes

- The practical work was run using CREATOR (UC3M software) rather than external toolchains.
- The workspace includes a `build` task using `msbuild`, which is unrelated to this RISC‑V assembly exercise.

## License

Academic exercise code. No explicit license provided; use for coursework unless stated otherwise.
