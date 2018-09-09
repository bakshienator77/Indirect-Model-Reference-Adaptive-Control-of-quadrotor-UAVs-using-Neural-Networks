clear ; close all; clc

jtrainhist=ones(80,1);
jcvhist=(ones(80,1));
count=1;
%% Initialization

%for count=1:50
%% Setup the parameters you will use for this exercise
input_layer_size  = 14;  % 20x20 Input Images of Digits
hidden_layer_size = 44;   % 25 hidden units
num_labels = 4;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  You will be working with a dataset that contains handwritten digits.
%

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

b=load('datafornn1.txt');
b=[0,0,0,0;b];
%X=b(1:600,:);

load('datasetz.mat');
load('datasetzroll.mat');
load('datasetroll.mat');
load('datasetpitch.mat');
load('datasetzpitch.mat');
load('datasetyaw.mat');
load('datasetzyaw.mat');
load('datasetzrpypos.mat');
load('datasetzrpyneg.mat');

%y=test4(1:600,:);
%dataset=[b(1:1001,:) test4];
%dataset = dataset(randperm(size(dataset,1)),:);
% Randomly select 100 data points to display
%sel = randperm(size(X, 1));
%sel = sel(1:100);
X=[X_zset ; X_zrollset ; X_pitchset ; X_rollset; X_zpitchset; X_yawset; X_zyawset; X_zrpyset1];
y=[y_zset ; y_zrollset ; y_pitchset ; y_rollset; y_zpitchset; y_yawset; y_zyawset; y_zrpyset1];
Xcv=X_zrpyset2(1:500,:);
ycv=y_zrpyset2(1:500,:);
Xtest=X_zrpyset2(501:end,:);
ytest=y_zrpyset2(501:end,:);
Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
Theta2 = randInitializeWeights(hidden_layer_size, hidden_layer_size);
Theta3 = randInitializeWeights(hidden_layer_size, num_labels);
for i=1:6
    y(:,13)=[];
    X(:,17)=[];
    ycv(:,13)=[];
    Xcv(:,17)=[];
    ytest(:,13)=[];
    Xtest(:,17)=[];
    
end;

for i=1:2
    y(:,5)=[];
    X(:,9)=[];
    ycv(:,5)=[];
    Xcv(:,9)=[];
    ytest(:,5)=[];
    Xtest(:,9)=[];
end;

for i=1:6
    y(:,5)=[];
    ycv(:,5)=[];
    ytest(:,5)=[];
end;
sel=[X y];

sel = sel(randperm(size(sel,1)),:);

X=sel(:,1:size(X,2));
y=sel(:,(size(X,2)+1):end);


m = size(X, 1);
%displayData(X(sel, :));

fprintf('Program paused. Press enter to continue.\n');



%% ================ Part 2: Loading Parameters ================
% In this part of the exercise, we load some pre-initialized 
% neural network parameters.

fprintf('\nLoading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
%load('ex4weights.mat');

% Unroll parameters 

nn_params = [Theta1(:) ; Theta2(:) ; Theta3(:)];


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

lambda = 3;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, nn_params, options);
figure;
plot(cost);
% Obtain Theta1 and Theta2 back from nn_params
alpha=0.01;
num_iters=100;
lambda=0.01;

%        [nn_params cost]= gradientDescentMulti(X,y,nn_params,alpha,num_iters,...
%    input_layer_size, hidden_layer_size, num_labels,lambda);



start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1)+ (hidden_layer_size+1)*hidden_layer_size:end), ...
                 num_labels, (hidden_layer_size + 1));

mintrain=min(y,2)';
maxtrain=max(y,2)';
fprintf('The cost on the training set is %f\n', cost(end));
jtrainhist(count)=cost(end);
names=cell(10,1);
names{1}='roll';
names{2}='pitch';
names{3}='yaw';
names{4}='z';
names{5}='dotroll';
names{6}='dotpitch';
names{7}='dotyaw';
names{8}='dotz';
names{9}='dotx';
names{10}='doty';
[notneeded notneeded2 errors]=nnCostFunction(nn_params,input_layer_size,hidden_layer_size,num_labels,X,y,lambda);
fprintf('The error per term is:\n');
disp(size(errors))
disp(size(mintrain))
for i=1:4
fprintf('percentage Error in %s is %f\n',names{i}, abs(sqrt(errors(i))/(mintrain(i) - maxtrain(i)))*100 );
end;
fprintf('Program paused. Press enter to perform cross validation.\n');
%pause;

[costcv notrequired errors]=nnCostFunction(nn_params,input_layer_size,hidden_layer_size,num_labels,Xcv,ycv,lambda);
mincv=min(ycv,2)';
maxcv=max(ycv,2)';
jcvhist(count)=costcv;
fprintf('The cost on the CV set is %f\n', costcv);
fprintf('The error per term is:\n');
for i=1:4
fprintf('percentage Error in %s is %f \n',names{i}, abs(sqrt(errors(i))/(mincv(i) - maxcv(i)))*100);
end;
%end;
figure;
plot(jtrainhist);
hold on;
legend('J Train');
plot(jcvhist,'r');
legend('J CV');
hold off;
