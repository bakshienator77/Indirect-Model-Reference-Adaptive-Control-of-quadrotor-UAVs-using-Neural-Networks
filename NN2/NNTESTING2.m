clear ; close all; clc

jhist=ones(60,1);
jcvhist=(ones(80,1));
for count=10:60
%% Initialization

%for count=1:50
%% Setup the parameters you will use for this exercise
input_layer_size  = 9;  % 20x20 Input Images of Digits
hidden_layer_size = count;   % 25 hidden units
num_labels = 1;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  You will be working with a dataset that contains handwritten digits.
%

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

load('try1.mat');
%Theta1 = Thetap1;
%Theta2 = Thetap2;
%Theta3 = Thetap3;
Thetac1= randInitializeWeights(input_layer_size, hidden_layer_size);
Thetac2 = randInitializeWeights(hidden_layer_size, hidden_layer_size);
Thetac3 = randInitializeWeights(hidden_layer_size, num_labels);
%displayData(X(sel, :));

fprintf('Program paused. Press enter to continue.\n');



%% ================ Part 2: Loading Parameters ================
% In this part of the exercise, we load some pre-initialized 
% neural network parameters.

fprintf('\nLoading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
%load('ex4weights.mat');

% Unroll parameters 

nn_params_plant = [Theta1(:) ; Theta2(:) ; Theta3(:)];
nn_params= [Thetac1(:); Thetac2(:); Thetac3(:)];


%% =============== Part 7: Implement Backpropagation ===============
%  Once your cost matches up with ours, you should proceed to implement the
%  backpropagation algorithm for the neural network. You should add to the
%  code you've written in nnCostFunction.m to return the partial
%  derivatives of the parameters.
%
fprintf('\nChecking Backpropagation... \n');
lambda=3;
%  Check gradients by running checkNNGradients
%checkNNGradients(lambda,y);

fprintf('\nProgram paused. Press enter to continue.\n');



%% =================== Part 8: Training NN ===================
%  You have now implemented all the code necessary to train a neural 
%  network. To train your neural network, we will now use "fmincg", which
%  is a function which works similarly to "fminunc". Recall that these
%  advanced optimizers are able to train our cost functions efficiently as
%  long as we provide them with the gradient computations.
%
fprintf('\nTraining Neural Network... \n')
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, hidden_layer_size);
initial_Theta3 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:) ; initial_Theta3(:)];

%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.
options = optimset('MaxIter', 100);

%  You should also try different values of lambda

lambda = 0.1;
y=[0 0 0 1];


% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction_copy(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, y, lambda, nn_params_plant);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
%[nn_params, cost] = fmincg(costFunction, nn_params, options);
%figure;
%plot(cost);
% Obtain Theta1 and Theta2 back from nn_params
alpha=100;
num_iters=100;
lambda=0.01;
cost=ones(1000,1);
state=[0;0;0;0];
dot=state;
for kjh=1:1000

[nn_params cost(kjh) state dot]= gradientDescentMulti_copy(y,nn_params,alpha,...
    input_layer_size, hidden_layer_size, num_labels,lambda, nn_params_plant,14,44,4,state, dot, 0.05);

end;

figure;
plot(cost);

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetac1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetac2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetac3 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1)+ (hidden_layer_size+1)*hidden_layer_size:end), ...
                 num_labels, (hidden_layer_size + 1));
             
jhist(count)=cost(end);
end;

figure;
plot(jhist);
