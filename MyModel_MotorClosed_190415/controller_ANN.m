function [control] = controller_ANN(in)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
input_layer_size=in(end-2);
hidden_layer_size=in(end-1);
num_labels=in(end);
states=in(1:8);
desired=in(13:16);
nn_params=in(17:end-3);
start2 = 1 + hidden_layer_size*(input_layer_size + 1);

end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));

Theta3 = reshape(nn_params(1 + end2:end), num_labels, (hidden_layer_size + 1));

X =[desired' states'];
X =[ones(size(X,1),1) X];
a2=sigmoid(Theta1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Theta2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=Theta3*a3;

control=[0; 0; 0; a4(4)];

end

