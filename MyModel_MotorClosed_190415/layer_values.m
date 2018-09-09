function [out] = layer_values(somenumber)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
nn_params=somenumber(1:end-1);
plant= [14; 44; 4]   ;%input,hidden,output layer size of plant NN
controller = [12;  38; 4];

if(somenumber==0)
    load('try1.mat');
    Theta4 = randInitializeWeights(controller(1), controller(2));
    Theta5 = randInitializeWeights(controller(2), controller(2));
    Theta6 = randInitializeWeights(controller(2), controller(3));
    nn_params=[Theta1(:); Theta2(:); Theta3(:); Theta4(:); Theta5(:); Theta6(:)]; 
    somenumber(end)=1;
end;
out=[somenumber(end); nn_params(:)];
end

