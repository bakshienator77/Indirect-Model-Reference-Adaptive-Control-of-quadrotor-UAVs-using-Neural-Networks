function [nn_params, J_history] = gradientDescentMulti(X, y,nn_params, alpha, num_iters, ...
    input_layer_size,hidden_layer_size,num_labels,lambda)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

    

for iter = 1:num_iters

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

    [J grad]=nnCostFunction(nn_params, input_layer_size, ...
                          hidden_layer_size, num_labels, X, y, lambda);
   

Theta1_grad = reshape(grad(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2_grad = reshape(grad(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3_grad = reshape(grad(1 + end2:end), ...
                 num_labels, (hidden_layer_size + 1));
 

    Theta1 = Theta1 - (alpha)*Theta1_grad;
    Theta2 = Theta2 - (alpha)*Theta2_grad;
    Theta3 = Theta3 - (alpha)*Theta3_grad;







    % ============================================================

    % Save the cost J in every iteration
    nn_params = [Theta1(:) ; Theta2(:); Theta3(:)];
    J_history(iter) = nnCostFunction(nn_params, input_layer_size, ...
                          hidden_layer_size, num_labels, X, y, lambda);
    if(iter>1)
        if(J_history(iter)>J_history(iter-1))
            Theta1 = Theta1 + (alpha)*Theta1_grad;
            Theta2 = Theta2 + (alpha)*Theta2_grad;
            Theta3 = Theta3 + (alpha)*Theta3_grad;
            nn_params = [Theta1(:) ; Theta2(:) ; Theta3(:)];
            J_history(iter) = nnCostFunction(nn_params, input_layer_size, ...
                          hidden_layer_size, num_labels, X, y, lambda);
        end;
    end;
    disp(J_history(iter))
end;

figure;
plot(J_history);

end
