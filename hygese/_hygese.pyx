import numpy as np
cimport numpy as np

cdef extern from "AlgorithmParameters.h":
    struct AlgorithmParameters:
        int nbGranular
        int mu
        int lambda_
        int nbElite
        int nbClose
        double targetFeasible
        int seed
        int nbIter
        double timeLimit
        char useSwapStar

    AlgorithmParameters default_algorithm_parameters()


cdef extern from "C_Interface.h":
    struct SolutionRoute:
        int length
        int *path

    struct Solution:
        double cost
        double time
        int n_routes
        SolutionRoute *routes

    Solution * solve_cvrp(
        int n, double* x, double* y, double* serv_time, double* dem,
        double vehicleCapacity, double durationLimit, char isRoundingInteger, char isDurationConstraint,
        int max_nbVeh, const AlgorithmParameters* ap, char verbose)

    Solution *solve_cvrp_dist_mtx(
        int n, double* x, double* y, double *dist_mtx, double *serv_time, double *dem,
        double vehicleCapacity, double durationLimit, char isDurationConstraint,
        int max_nbVeh, const AlgorithmParameters *ap, char verbose);

    void delete_solution(Solution * sol);

def _solve_tsp(x, y):
    n = len(x)
    assert len(x) == len(y)

    cdef np.ndarray[np.double_t, ndim=1, mode="c"] x_c
    cdef np.ndarray[np.double_t, ndim=1, mode="c"] y_c
    cdef np.ndarray[np.double_t, ndim=1, mode="c"] s_c
    cdef np.ndarray[np.double_t, ndim=1, mode="c"] d_c

    x_c = np.ascontiguousarray(x, dtype=np.double)
    y_c = np.ascontiguousarray(y, dtype=np.double)
    s_c = np.ascontiguousarray(np.zeros(n), dtype=np.double)
    d_c = np.ascontiguousarray(np.ones(n), dtype=np.double)
    d_c[0] = 0.0
    vehicle_capacity = n
    duration_limit = 1000000000

    cdef AlgorithmParameters ap = default_algorithm_parameters()
    cdef Solution * sol

    sol = solve_cvrp(n, &x_c[0], &y_c[0], &s_c[0], &d_c[0],
                     vehicle_capacity, duration_limit, 1, 0,
                     1, &ap, 1)

    cost = sol.cost
    routes = []
    for i in range(sol.n_routes):
        route = sol.routes[i]
        tmp = []
        for j in range(route.length):
            tmp.append(route.path[j])

        routes.append(tmp)


    delete_solution(sol)
    return cost, routes

def _hello():
    print("hello hygese....cythnong")