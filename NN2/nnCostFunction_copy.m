function [J grad state dot] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   y, lambda,nn_plant,a,b,c,prev,prev_dot, tp)
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
             
Thetap1 = reshape(nn_plant(1:b*(a+1)),b,a+1);
Thetap2 = reshape(nn_plant(b*(a+1)+1:b*(a+1)+b*(b+1)),b,b+1);
Thetap3 = reshape(nn_plant(b*(a+1)+b*(b+1)+1:end),c,b+1);

% Setup some useful variables

         
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

error=[y(4)-prev(4)];
X=[1 error prev(1) prev_dot(1) prev(2) prev_dot(2) prev(3) prev_dot(3) prev(4) prev_dot(4)];
a2=sigmoid(Theta1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Theta2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=8*sigmoid(Theta3*a3);


a4=[a4' prev' prev_dot' 1 1];
a4=[ones(size(a4,1),1) 0 0 0 a4];
a5=sigmoid(Thetap1*a4');
a5=[ones(1,size(a5,2)); a5];
a6=sigmoid(Thetap2*a5);
a6=[ones(1,size(a6,2)); a6];
a7=Thetap3*a6;

state=a7;
dot=(a7-prev)./tp;




Tp1_copy=Thetap1;
Tp2_copy=Thetap2;
Tp3_copy=Thetap3;
Tp1_copy(:,1)=[];
Tp2_copy(:,1)=[];
Tp3_copy(:,1)=[];
Tc1_copy=Theta1;
Tc2_copy=Theta2;
Tc3_copy=Theta3;
Tc1_copy(:,1)=[];
Tc2_copy(:,1)=[];
Tc3_copy(:,1)=[];


%J2=sum((([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref)).^2)/2 + (lambda(2)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
 %   sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2))

J=sum(((a7(4)-y(4))).^2)/2 + (lambda/2)*(sum(sum(Tc1_copy.^2),2)+ ...
    sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2));


%del7= ([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref);

del7= (a7(4)-y(4));

del6= ((Tp3_copy(4,:)'*del7).*sigmoidGradient(Thetap2*a5));

del5 = ((Tp2_copy'*del6).*sigmoidGradient(Thetap1*a4'));

del4= 8*(Tp1_copy'*del5).*sigmoidGradient(Theta3*a3);

del4= del4(4);

del3 = ((Tc3_copy'*del4).*sigmoidGradient(Theta2*a2));

del2= ((Tc2_copy'*del3).*sigmoidGradient(Theta1*X'));


delta6=(del7*a6');

delta5= (del6*a5');

delta4 = (del5*a4);

delta3=(del4*a3');

delta2= (del3*a2');

delta1 = (del2*X);

if(dot(4)~=0)
    cbv=-(dot(4)/abs(dot(4)));
    if(cbv==1)
        cbv=0.2;
    end;
else
    cbv=1;
end;

Thetac1_grad = delta1 + cbv*(lambda)*[zeros(size(Tc1_copy,1),1) Tc1_copy];

Thetac2_grad = delta2 + cbv*(lambda)*[zeros(size(Tc2_copy,1),1) Tc2_copy];

Thetac3_grad = delta3 + cbv*(lambda)*[zeros(size(Tc3_copy,1),1) Tc3_copy];

grad=[Thetac1_grad(:); Thetac2_grad(:); Thetac3_grad(:)];

end
