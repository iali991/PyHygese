import hygese
import hygese._hygese
import numpy as np
import elkai


hygese._hygese._hello()


x = np.random.rand(10) * 1000
y = np.random.rand(10) * 1000
cost, routes = hygese._hygese._solve_tsp(x, y)

n = len(x)
dist_mtx = np.zeros((n, n), dtype=int)
for i in range(n):
    for j in range(n):
        dist_mtx[i, j] = np.round(np.sqrt(
            (x[i] - x[j]) ** 2 + (y[i] - y[j]) ** 2
        ))

tour = elkai.solve_int_matrix(dist_mtx)
val = 0
for i in range(n):
    if i < n-1:
        val = val + dist_mtx[tour[i], tour[i+1]]
    else:
        val = val + dist_mtx[tour[i], tour[0]]

print("elkai = ", val)
print("hgs = ", cost)
print(routes)