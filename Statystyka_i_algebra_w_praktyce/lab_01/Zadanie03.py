import pandas as pd
from scipy import stats
import numpy as np
# Wczytaj plik CSV
df = pd.read_csv('../Files/MDR_RR_TB_burden_estimates_2023-11-29.csv')

column = "e_rr_pct_new_hi"

print("Funkcja describe do obliczania statystyk")
print(f"Statystyki dla kolumny {column}:")
print(stats.describe(df[column]))
print()


print("Inne statystyki jakie mozna znaleźć w bibliotece scipy.stats")
print(f"Statystyki dla kolumny {column}:")
# Średnia geometryczna
print("Średnia geometryczna:")
print(stats.gmean(df[column]))
# Średnia harmoniczna
print("Średnia harmoniczna:")
print(stats.hmean(df[column]))
# Błąd standardowy średniej
print("Błąd standardowy średniej:")
print(stats.sem(df[column]))
# Moda
print("Moda:")
print(stats.mode(df[column]))
# Mediana
print("Mediana:")
print(np.median(df[column]))
# Wariancja
print("Wariancja:")
print(np.var(df[column]))
# Skośność
print("Skośność:")
print(stats.skew(df[column]))
# Kurtoza
print("Kurtoza:")
print(stats.kurtosis(df[column]))
print("\n")
