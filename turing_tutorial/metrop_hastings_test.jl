# import numpy as np
# from   numpy.random import multivariate_normal as mvn
# import matplotlib.pyplot as plt

# n_iters    = 1000
# samples    = np.empty((n_iters, 2))
# samples[0] = np.random.uniform(low=[-3, -3], high=[3, 10], size=2)
# rosen      = lambda x, y: np.exp(-((1 - x)**2 + 100*(y - x**2)**2) / 20)

# for i in range(1, n_iters):
#     curr  = samples[i-1]
#     prop  = curr + mvn(np.zeros(2), np.eye(2) * 0.1)
#     alpha = rosen(*prop) / rosen(*curr)
#     if np.random.uniform() < alpha:
#         curr = prop
#     samples[i] = curr

# plt.plot(samples[:, 0], samples[:, 1])
# plt.show()
#

# %%
n_iters    = 1000

# %%