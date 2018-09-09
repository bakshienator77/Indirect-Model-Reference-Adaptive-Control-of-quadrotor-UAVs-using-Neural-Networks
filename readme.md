The NN2 folder was used for testing appropriate hyper parameters for the neural networks and the 2nd folder contains all the files used during simulation.

The codes of interest in them are ‘learnonline_trial’, ‘CostFunction_trial_z’ and ‘onlinenormalize’.
The ‘testinputs’ codes provides set points to the simulation.

Graphs and figures plotted throughout are also present along with all the original file for the model to work with minor modifications.

There may be certain extra files which I will remove later on.

For quadcopter control I developed a control method that was self-tuning and therefore could adjust to any quadcopter without any prior knowledge in an online setting. This is currently a less explored and experimental area of research and yet the approach was successful and innovative and much less involved once implemented as compared to the current most popular PID controller which involves manual tuning of the system-specific Proportional, Integral and Derivative terms.
