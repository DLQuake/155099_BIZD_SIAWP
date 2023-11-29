import pandas as pd
import matplotlib.pyplot as plt

# Załaduj plik do DataFrame
df = pd.read_csv('../Files/brain_size.csv', sep=';')

# Znajdź średnią dla kolumny VIQ
mean_viq = df['VIQ'].mean()
print(f'Średnia dla kolumny VIQ: {mean_viq}')

# Ile kobiet i mężczyzn jest wyróżnionych w pliku
num_women = df[df['Gender'] == 'Female'].shape[0]
num_men = df[df['Gender'] == 'Male'].shape[0]
print(f'Liczba kobiet: {num_women}, Liczba mężczyzn: {num_men}')

# Wyświetl histogramy dla zmiennych VIQ, PIQ, FSIQ
df[['VIQ', 'PIQ', 'FSIQ']].hist(bins=20)
plt.show()

# Wyświetl histogramy trzech kolumn tylko dla kobiet
df[df['Gender'] == 'Female'][['VIQ', 'PIQ', 'FSIQ']].hist(bins=20)
plt.show()
