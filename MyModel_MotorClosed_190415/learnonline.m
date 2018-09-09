function [nn_params] =...
    learnonline(in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



y_ref=in(1:4);
y_model=in(5:8);
states=in(9:20);
nn_params=in(21:end-26);
states_new=in(end-25:end-14);
input_layer_size=in(end-13);
hidden_layer_size=in(end-12);
num_labels=in(end-11);
plant=in(end-13 :end-11);
controller=in(end-10:end-8);
input_layer_size1=in(end-10);
hidden_layer_size1=in(end-9);
num_labels1=in(end-8);  
desired=in(end-7:end-4);
alpha=in(end-3:end);



[J1 J2 grad]=CostFunction(nn_params, input_layer_size, hidden_layer_size, ...
    num_labels, input_layer_size1,hidden_layer_size1, num_labels1,desired, ...
    states, y_ref,y_model,states_new,alpha(3:4));



start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetap1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3 = reshape(nn_params(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));
             
Thetap1_grad = reshape(grad(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2_grad = reshape(grad(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3_grad = reshape(grad(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));
total=end2+num_labels*(hidden_layer_size+1);
             
input_layer_size=input_layer_size1;
hidden_layer_size=hidden_layer_size1;
num_labels=num_labels1;

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetac1 = reshape(nn_params(total+1:total+hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetac2 = reshape(nn_params(total+start2 :total+end2) ,hidden_layer_size, (hidden_layer_size + 1));

Thetac3 = reshape(nn_params(1 +total +end2:end),num_labels, (hidden_layer_size + 1));


Thetac1_grad = reshape(grad(total+1:total+hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetac2_grad = reshape(grad(total+start2 :total+end2) ,hidden_layer_size, (hidden_layer_size + 1));

Thetac3_grad = reshape(grad(1 +total +end2:end),num_labels, (hidden_layer_size + 1));

if(Thetap3(1)==1)
    %load('try1.mat');
    load('thinktwice3.mat');
    %Thetap1=Theta1;
    %Thetap2=Theta2;
    %Thetap3=Theta3;
end;
if(Thetac3(1)==1)
    load('thinkagain3.mat');    
    %Thetac1 = randInitializeWeights(controller(1), controller(2));
    %Thetac2 = randInitializeWeights(controller(2), controller(2));
    %Thetac3 = randInitializeWeights(controller(2), controller(3));
end;

%if(cost_pnn>5)
Thetap1=Thetap1-10*alpha(1)*Thetap1_grad;
Thetap2=Thetap2-10*alpha(1)*Thetap2_grad;
Thetap3=Thetap3-10*alpha(1)*Thetap3_grad;

%end;
%if(cost_cnn>10)
Thetac1=Thetac1-10*alpha(2)*Thetac1_grad;
Thetac2=Thetac2-10*alpha(2)*Thetac2_grad;
Thetac3=Thetac3-10*alpha(2)*Thetac3_grad;
%end;
if(Thetap1(1)<3)
save('thinkagain4.mat','Thetac1','Thetac2','Thetac3');
save('thinktwice4.mat','Thetap1','Thetap2','Thetap3');
end;
nn_params=[Thetap1(:); Thetap2(:); Thetap3(:); Thetac1(:); Thetac2(:); Thetac3(:)];
end

