import numpy as np
import statistics

with open('../Files/Wzrost.csv', 'r') as file:
    raw_data = file.read()

data_array = np.fromstring(raw_data, sep=',')

data_list = data_array.tolist()

mean_value = statistics.mean(data_list)
variance_value = statistics.variance(data_list)
std_deviation_value = statistics.stdev(data_list)

print(f"Średnia: {mean_value}")
print(f"Wariancja: {variance_value}")
print(f"Odchylenie standardowe: {std_deviation_value}")
