function [J grad errors] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1)+ (hidden_layer_size+1)*hidden_layer_size:end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
Theta3_grad = zeros(size(Theta3));
% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
op=y;
X=[ones(size(X,1),1) X];

a2=sigmoid(Theta1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Theta2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=Theta3*a3;

T1_copy=Theta1;
T2_copy=Theta2;
T3_copy=Theta3;
Theta1(:,1)=[];
Theta2(:,1)=[];
Theta3(:,1)=[];

J=(1/(2*m))*sum(sum((y(:,4)'-a4(4,:)).^2),2) ...
    + (lambda/(2*m))*(sum(sum(Theta1.^2),2)+sum(sum(Theta2.^2),2) + sum(sum(Theta3.^2),2));

del4= a4(1:4,:) - op(:,1:4)';
errors = sum((y(:,1:4)'-a4(1:4,:)).^2,2)/m;

del3= ((Theta3'*del4).*sigmoidGradient(T2_copy*a2));

del2 = ((Theta2'*del3).*sigmoidGradient(T1_copy*X'));

delta3=(del4*a3');

delta2= (del3*a2');

delta1 = (del2*X);

%disp(size(delta2))

%disp(size(delta1))

Theta1_grad(:,1)=(1/m)*delta1(:,1);
Theta1_grad(:,2:end)=(1/m)*delta1(:,2:end) +(lambda/m)*Theta1;
Theta2_grad(:,1)=(1/m)*delta2(:,1);
Theta2_grad(:,2:end)=(1/m)*delta2(:,2:end) +(lambda/m)*Theta2;
Theta3_grad(:,1)=(1/m)*delta3(:,1);
Theta3_grad(:,2:end)=(1/m)*delta3(:,2:end) +(lambda/m)*Theta3;




% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:) ; Theta3_grad(:)];


end
