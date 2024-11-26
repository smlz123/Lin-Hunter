import json
import scipy.io
import HDL_generate as HDL
import os
import csv
import numpy as np

STATE_FILE = 'simulation_state.json'

# SL_BLOCKLIBS = [
#     {'name': 'Logic and Bit Operations', 'is_blk': False, 'num': 0.05},
#     {'name': 'Math Operations', 'is_blk': False, 'num': 0.83},
#     {'name': 'Sinks', 'is_blk': False, 'num': 0.02},
#     {'name': 'Sources', 'is_blk': False, 'num': 0.02},
#     {'name': 'hdlsllib/Ports & Subsystems/Subsystem', 'is_blk': True, 'num': 0.04},
#     {'name': 'hdlsllib/Signal Routing/Switch', 'is_blk': True, 'num': 0.04}
# ]

LIVE_MUT_WEIGHTS = [
    {'operation': 'emi.live.VirtualChild', 'num': 0},
    {'operation': 'emi.live.ModelReference', 'num': 0},
    {'operation': 'emi.live.Extender', 'num': 0},
    {'operation': 'emi.live.AlwaysTrue', 'num': 0.5},
    {'operation': 'emi.live.ForEach', 'num': 0.5}
]

mat_file = 'live_mut_weights.mat'
scipy.io.savemat(mat_file, {'LIVE_MUT_WEIGHTS': LIVE_MUT_WEIGHTS})

class EpsilonGreedyMAB:
    def __init__(self, n_arms, epsilon=0.1,LIVE_MUT_WEIGHTS=None):
        self.n_arms = n_arms
        self.epsilon = epsilon
        self.counts = np.zeros(n_arms, dtype=int)
        self.values = np.zeros(n_arms)
        self.LIVE_MUT_WEIGHTS = LIVE_MUT_WEIGHTS or []

    def select_arm(self):
        if np.random.rand() < self.epsilon:
            return np.random.randint(self.n_arms)
        else:
            return np.argmax(self.values)

    def update(self, arm, reward):
        self.counts[arm] += 1
        n = self.counts[arm]
        value = self.values[arm]

        self.values[arm] = ((n - 1) / n) * value + (1 / n) * reward

    def save_state(self, iteration):
        state = {
            'counts': self.counts.tolist(),
            'values': self.values.tolist(),
            'LIVE_MUT_WEIGHTS': self.LIVE_MUT_WEIGHTS,
            'iteration': iteration
        }
        with open(STATE_FILE, 'w') as f:
            json.dump(state, f)

    def load_state(self):
        if os.path.exists(STATE_FILE):
            with open(STATE_FILE, 'r') as f:
                state = json.load(f)
                self.counts = np.array(state['counts'], dtype=int)
                self.values = np.array(state['values'])
                self.LIVE_MUT_WEIGHTS = state['LIVE_MUT_WEIGHTS']
                return state['iteration']
        return 0


def adjust_params(selected_arm):

    adjustment = 0.01
    param_index = selected_arm // 2
    operation = selected_arm % 2


    if operation == 0:
        LIVE_MUT_WEIGHTS[param_index]['num'] += adjustment
    else:
        LIVE_MUT_WEIGHTS[param_index]['num'] = max(0, LIVE_MUT_WEIGHTS[param_index]['num'] - adjustment)


    total = sum(param['num'] for param in LIVE_MUT_WEIGHTS)
    for param in LIVE_MUT_WEIGHTS:
        param['num'] /= total

    current_params = [param['num'] for param in LIVE_MUT_WEIGHTS]
    return current_params

def simulate_reward(LIVE_MUT_WEIGHTS):
    print(LIVE_MUT_WEIGHTS)
    print(LIVE_MUT_WEIGHTS)
    print('excuted reward function')
    data = {'LIVE_MUT_WEIGHTS': LIVE_MUT_WEIGHTS}
    scipy.io.savemat('E:\\FPGA\\firstversion\\generate\\upload\\DIATRIBE\\data.mat', data)
    print(data)
    HDL.HDL_generate()#run
    reward = HDL.get_reward()
    if reward[1] > reward[0]:
        return 1
    else:
        return -1


if __name__=="__main__":
    n_arms = 12
    epsilon = 0.1
    mab = EpsilonGreedyMAB(n_arms, epsilon,LIVE_MUT_WEIGHTS)

    if not mab.load_state():
        print("No saved state found, starting fresh.")
    else:
        print("Resuming from saved state.")

    current_iteration = mab.load_state()
    n_iterations = 100
    for _ in range(current_iteration,n_iterations):
        selected_arm = mab.select_arm()
        print('open')
        current_params = adjust_params(selected_arm)
        print('Config is', current_params)
        for i, param in enumerate(mab.LIVE_MUT_WEIGHTS):
            param['num'] = current_params[i]


        print("更新后的LIVE_MUT_WEIGHTS：",mab.LIVE_MUT_WEIGHTS)
        for param in mab.LIVE_MUT_WEIGHTS:
            print(param)
        reward = simulate_reward(mab.LIVE_MUT_WEIGHTS)
        mab.update(selected_arm, reward)
        mab.save_state(i+1)


    print("after optimal paras：")
    for param in current_params:
        print(param)
