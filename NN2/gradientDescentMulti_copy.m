function [nn_params, J, state, dot] = gradientDescentMulti(y,nn_params, alpha, ...
    input_layer_size,hidden_layer_size,num_labels,lambda,nn_plant,a,b,c, prev, prev_dot, tp)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples

    

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %

    %J_history(iter)= computeCost(X , y, theta);
start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3 = reshape(nn_params(1 + end2:end), ...
                 num_labels, (hidden_layer_size + 1));


    [J grad state dot]=nnCostFunction_copy(nn_params, input_layer_size, ...
                          hidden_layer_size, num_labels, y, lambda,nn_plant,a,b,c,prev,prev_dot, tp);
   

Theta1_grad = reshape(grad(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2_grad = reshape(grad(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3_grad = reshape(grad(1 + end2:end), ...
                 num_labels, (hidden_layer_size + 1));
 
if(dot(4)~=0)
    cbv=-(dot(4)/abs(dot(4)));
    if(cbv==1)
        cbv=0.2;
    end;
else
    cbv=1;
end;
    Theta1 = Theta1 - cbv*(alpha)*Theta1_grad;
    Theta2 = Theta2 - cbv*(alpha)*Theta2_grad;
    Theta3 = Theta3 - cbv*(alpha)*Theta3_grad;


    % ============================================================

    % Save the cost J in every iteration
    nn_params = [Theta1(:) ; Theta2(:); Theta3(:)];

end
