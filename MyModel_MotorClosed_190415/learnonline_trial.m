function [out] = learnonline_trial(in)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



y_ref=in(1:4)
y_ref_dot=in(5:8);
states=in(9:20);
nn_params=in(21:end-91);
k=in(end-90);
M=in(end-89:end-74);
S=in(end-73:end-58);
std=in(end-57:end-42);
sum=in(end-41:end-26);
states_new=in(end-25:end-14);
input_layer_size=in(end-13);
hidden_layer_size=in(end-12);
num_labels=in(end-11);
plant=in(end-13 :end-11);
controller=in(end-10:end-8);
input_layer_size1=in(end-10);
hidden_layer_size1=in(end-9);
num_labels1=in(end-8);  
alpha=in(end-7:end);


start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetap1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3 = reshape(nn_params(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));


if(Thetap3(1)==1)
    load('try1.mat');
    %load('thinktwice10.mat');
    Thetap1=Theta1;
    Thetap2=Theta2;
    Thetap3=Theta3;
    load('thinkagain13.mat');
    %Thetac1(4:5)=[0;0];
%Thetac2(4:5)=[0;0];
    nn_params=[Thetap1(:); Thetap2(:); Thetap3(:); Thetac1(:); Thetac2(:); Thetac3(:);Thetac4(:)];
end;




[J1 J2 grad control M S std sum k delta]=CostFunction_trial_z(nn_params, input_layer_size, hidden_layer_size, ...
    num_labels, input_layer_size1,hidden_layer_size1, num_labels1, ...
    states, y_ref,y_ref_dot,states_new,[alpha(3:4);alpha(6)],M,S,std,sum,k);



             
Thetap1_grad = reshape(grad(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2_grad = reshape(grad(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3_grad = reshape(grad(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));
total=end2+num_labels*(hidden_layer_size+1);
             
input_layer_size=input_layer_size1;
hidden_layer_size=hidden_layer_size1;
num_labels=num_labels1;

start2 = 1 + num_labels * (input_layer_size + 1);
end2 = num_labels*(input_layer_size + 1) + num_labels * (input_layer_size + 1);

Thetac1 = reshape(nn_params(total+1:total + num_labels * (input_layer_size + 1)), ...
                 num_labels, (input_layer_size + 1));

Thetac2 = reshape(nn_params(total+start2 :total+end2) ,num_labels, (input_layer_size + 1));

Thetac3 = reshape(nn_params(1 +total +end2:total +end2+num_labels * (input_layer_size + 1)),num_labels, (input_layer_size + 1));

Thetac4 = reshape(nn_params(1+total +end2+num_labels * (input_layer_size + 1):end),num_labels,(input_layer_size + 1));

Thetac1_grad = reshape(grad(total+1:total + num_labels * (input_layer_size + 1)), ...
                 num_labels, (input_layer_size + 1));

Thetac2_grad = reshape(grad(total+start2 :total+end2) ,num_labels, (input_layer_size + 1));

Thetac3_grad = reshape(grad(1 +total +end2:total +end2+num_labels * (input_layer_size + 1)),num_labels, (input_layer_size + 1));

Thetac4_grad = reshape(grad(1+total +end2+num_labels * (input_layer_size + 1):end),num_labels,(input_layer_size + 1));


%Gradient descent for plant emulator ANN
Thetap1=Thetap1-alpha(1)*Thetap1_grad;
Thetap2=Thetap2-alpha(1)*Thetap2_grad;
Thetap3=Thetap3-alpha(1)*Thetap3_grad;

%alpha(2)=alpha(2)+k/10000
%if(y_ref(1)~=0)

Thetac3=Thetac3-10*alpha(2)*Thetac3_grad;   %Z

%disp('Im here')
%end;

if(k>1000)
    Thetac1=Thetac1-alpha(5)*Thetac1_grad;  %roll
Thetac2=Thetac2-alpha(5)*Thetac2_grad;     %pitch
%Thetac2(4)=Thetac2(4)-100*Thetac2_grad(4);
%Thetac1(4)=Thetac1(4)-100*Thetac1_grad(4);
Thetac4=Thetac4-0.1*Thetac4_grad;    %yaw
end;
Thetac1(4)=[0];   %roll controller dotpitch input
Thetac2(4)=[0];   %pitch controller dot roll in
%Thetac3(3:4)=[0;0];  %
%Thetac4(4:5)=[0;0];
if(abs(Thetap1(1))<1)
save('thinkagain15.mat','Thetac1','Thetac2','Thetac3','Thetac4');
save('thinktwice15.mat','Thetap1','Thetap2','Thetap3');
end;
nn_params=[Thetap1(:); Thetap2(:); Thetap3(:); Thetac1(:); Thetac2(:); Thetac3(:); Thetac4(:)];
    
out=[nn_params; control; M(:); S(:); std(:); sum(:);k;delta(:)];
end

