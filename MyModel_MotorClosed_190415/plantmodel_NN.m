function [ pred_states ] = plantmodel_NN( in)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
input_layer_size=in(end-2);
hidden_layer_size=in(end-1);
num_labels=in(end);
controlin=in(1:4);
states=[in(5:16)];
nn_params=in(17:end-3);

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Theta3 = reshape(nn_params(1 + hidden_layer_size * (input_layer_size + 1)+ (hidden_layer_size+1)*hidden_layer_size:end), ...
num_labels, (hidden_layer_size + 1));

X=[controlin' [states(1);states(3);states(5);states(7)]' [states(2);states(4);states(6);states(8);states(10); states(12)]'];
X=[ones(size(X,1),1) X];
a2=sigmoid(Theta1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Theta2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=Theta3*a3;

pred_states=a4;
end

