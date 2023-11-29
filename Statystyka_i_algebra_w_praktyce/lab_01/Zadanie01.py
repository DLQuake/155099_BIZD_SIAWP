import pandas as pd

df = pd.read_csv('../Files/MDR_RR_TB_burden_estimates_2023-11-29.csv')

# Wybierz kolumnę numeryczną
column = "e_rr_pct_new"

# Oblicz podstawowe statystyki
mean = df[column].mean()
median = df[column].median()
std_dev = df[column].std()

print(f"Średnia: {mean}")
print(f"Mediana: {median}")
print(f"Odchylenie standardowe: {std_dev}")
