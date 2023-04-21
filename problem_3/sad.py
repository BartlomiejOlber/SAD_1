import numpy as np
import matplotlib.pyplot as plt


def load_data(filename, show=False):
    with open(filename, 'rb') as f:
        data = np.fromfile(f, dtype=np.float32)

    if show:
        print(data.shape)
        print(data.min(), data.max(), data.mean(), data[data > 0.01].shape)
        plt.plot(data)
        plt.show()
    return data


# założenie impuls: sygnał > 0.01  50M próbek/s  -> dzielę na interwały o długości 500 000 próbek czyli liczę liczbę impulsów na 1/100 sekundy
# dodatkowe założenie: kolejne impulsy musi dzielić przynajmniej 20 próbek, żeby mieć pewność że to są na pewno oddzielne impulsy, a nie jeden długi
def count_impulses_per_mikros(data, impulse_threshold=0.01, interval=500_000):

    masked = np.where(data > impulse_threshold, 1, 0)
    impulses = []
    interval_impulses = 0
    count_elements = 0 
    dist = 0
    for element in masked:
        count_elements += 1
        if count_elements == interval:
            count_elements = 0
            impulses.append(interval_impulses)
            interval_impulses = 0
            
        if element:
            if dist > 20:
                interval_impulses += 1
            dist = 0
            continue
        dist += 1
    return np.array(impulses)


def count_distances_between_impulses(data, impulse_threshold=0.01):
    masked = np.where(data > impulse_threshold, 1, 0)
    distances = []
    dist = 0
    for element in masked:
        if element:
            if dist > 20:
                distances.append(dist)
            dist = 0
            continue
        dist += 1
    return np.array(distances)


if __name__ == "__main__":
    import struct

    data = load_data("signal_50MHz.bin")
    distances = count_distances_between_impulses(data)
    print(distances, distances.shape)
    count = count_impulses_per_mikros(data)
    print(count, count.shape, count.sum())

    with open("distances.bin", "wb") as f:
        for d in distances:
            f.write(struct.pack('>I', np.int32(d)))

    with open("count.bin", "wb") as f:
        for c in count:
            f.write(struct.pack('>I', np.int32(c)))
