function [J1 J2 grad control M S std sumy k grddy] = CostFunction_trial_z(nn_params,input_layer_size,...
    hidden_layer_size, num_labels,d1,d2,d3,states,y_ref, ...
    y_ref_dot, states_new,lambda,M,S,std,sumy,k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetap1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3 = reshape(nn_params(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));
total=end2+num_labels*(hidden_layer_size+1);
             
input_layer_size=d1;
hidden_layer_size=d2;
num_labels=d3;

start2 = 1 + num_labels * (input_layer_size + 1);
end2 = num_labels*(input_layer_size + 1) + num_labels * (input_layer_size + 1);

Thetac1 = reshape(nn_params(total+1:total + num_labels * (input_layer_size + 1)), ...
                 num_labels, (input_layer_size + 1));

Thetac2 = reshape(nn_params(total+start2 :total+end2) ,num_labels, (input_layer_size + 1));

Thetac3 = reshape(nn_params(1 +total +end2:total +end2+num_labels * (input_layer_size + 1)),num_labels, (input_layer_size + 1));

Thetac4 = reshape(nn_params(1+total +end2+num_labels * (input_layer_size + 1):end),num_labels,(input_layer_size + 1));

error=-[y_ref(4)-states(7)];   %error in z
for h=1:2:5
states(h)=wrapToPi(states(h));
states_new(h)=wrapToPi(states_new(h));
end;
y_ref(1:3)=wrapToPi(y_ref(1:3));
state_for_z=abs([states(1);states(3)]);
if((abs(states(1))>1.57))
    state_for_z(1)=-abs(state_for_z(1))+1.57;
end;

if(abs(states(3))>1.57)
    state_for_z(2)=-abs(state_for_z(2))+1.57;
end;

X=[error' [(state_for_z(1));(state_for_z(2));(states(8)-y_ref_dot(4))]' ...   %Inputs to controller NN
    [(states(1)-y_ref(1));(states(2)-y_ref_dot(1));states(4);states(6)]'...
    [states(3)-y_ref(2);states(4)-y_ref_dot(2);states(2);states(6)]'...
    [states(5)-y_ref(3);states(6)-y_ref_dot(3);states(2);states(4)]'];

[X std M S k sumy copy] = onlinenormalize(M, k, S, X, sumy );

X_roll=[1 X(5:8)'];
X_pitch=[1 X(9:12)'];
X_yaw=[1 X(13:16)'];
X=[ones(size(X,2),1) X(1:4)'];

a2=0.01*sigmoid(Thetac1(1:5)*X_roll')-0.005;   %Roll Control input

a3=0.01*sigmoid(Thetac2*X_pitch')-0.005;       %Pitch Control input

a1=sigmoid(Thetac4*X_yaw')-0.5;         %yaw control input


a4=4+8*sigmoid(Thetac3(1:5)*X');    %Z CONTROL INPUT
%a2=0;
control=[a2;a3;a1;a4];

a4=[a4' [states(1);states(3);states(5);states(7)]' ...
    [states(2);states(4);states(6);states(8);states(10); states(12)]'];
a4=[ones(size(a4,1),1) a2 a3 a1 a4];
a5=sigmoid(Thetap1*a4');
a5=[ones(1,size(a5,2)); a5];
a6=sigmoid(Thetap2*a5);
a6=[ones(1,size(a6,2)); a6];
a7=Thetap3*a6;


Tp1_copy=Thetap1;
Tp2_copy=Thetap2;
Tp3_copy=Thetap3;
Tp1_copy(:,1)=[];
Tp2_copy(:,1)=[];
Tp3_copy(:,1)=[];
Tc1_copy=Thetac1;
Tc2_copy=Thetac2;
Tc3_copy=Thetac3;
Tc4_copy=Thetac4;
Tc1_copy(:,1)=[];
Tc2_copy(:,1)=[];
Tc3_copy(:,1)=[];
Tc4_copy(:,1)=[];

J1=sum(((a7-[states_new(1);states_new(3);states_new(5);states_new(7)])).^2)/2 %Cost of plant ANN
    %+ (lambda(1)/2)*(sum(sum(Tp1_copy.^2),2)+sum(sum(Tp2_copy.^2),2)+sum(sum(Tp3_copy.^2),2))

%J2=sum((([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref)).^2)/2 + (lambda(2)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
 %   sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2))

 %Cost of Z controller
J2=sum((([states_new(7)]-y_ref(4))).^2)/2 + (((states_new(8)-y_ref_dot(4)))^2)/2% + (lambda(2)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
   % sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2))
   
%Cost of Roll controller    
J3=sum((([states_new(1)]-y_ref(1))./copy(5)).^2)/2 + (((states_new(2)-y_ref_dot(1))/copy(6))^2)/2 

%Cost of Pitch controller
J4=sum((([states_new(3)]-y_ref(2))).^2)/2 + ((states_new(4)-y_ref_dot(2))^2)/2  

%Cost of Yaw controller
J5=sum((([states_new(5)]-y_ref(3))).^2)/2 + ((states_new(6)-y_ref_dot(3))^2)/2   

parity=[-1;-1;-1;-1];
%del7= ([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref);

%Normalised Reference error
del7= parity.*([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref)./[copy(5);copy(9);copy(13);1];

del6= ((Tp3_copy'*del7).*sigmoidGradient(Thetap2*a5));

del5 = ((Tp2_copy'*del6).*sigmoidGradient(Thetap1*a4'));

shell=(Tp1_copy'*del5);
del1= [0.01;0.01;1;8].*shell(1:4).*sigmoidGradient([Thetac1(1:5)*X_roll';...
    Thetac2(1:5)*X_pitch';Thetac4(1:5)*X_yaw';Thetac3(1:5)*X']);  %error in control ins

%error in z control in
del4=del1(4);

%error in roll control in
del3=del1(1);

%error in pitch control in
del2= del1(2);

%error in yaw control in
del1= del1(3);


deltaz=(del4*X);

deltaroll= (del3*X_roll);

deltapitch = (del2*X_pitch);

deltayaw = (del1*X_yaw);



deld7= parity.*([states_new(2);states_new(4);states_new(6);states_new(8)]-y_ref_dot)./[copy(6);copy(10);copy(14);1];

deld6= ((Tp3_copy'*deld7).*sigmoidGradient(Thetap2*a5));

deld5 = ((Tp2_copy'*deld6).*sigmoidGradient(Thetap1*a4'));

shelld=(Tp1_copy'*deld5);
deld1= [0.01;0.01;1;8].*shelld(1:4).*sigmoidGradient([Thetac1(1:5)*X_roll';...
    Thetac2(1:5)*X_pitch';Thetac4(1:5)*X_yaw';Thetac3(1:5)*X']);  %error in control ins

%error in z control in
deld4=deld1(4);

%error in roll control in
deld3=deld1(1);

%error in pitch control in
deld2= deld1(2);

%error in yaw control in
deld1= deld1(3);

deltadz=(deld4*X);

deltadroll= (deld3*X_roll);

deltadpitch = (deld2*X_pitch);

deltadyaw = (deld1*X_yaw);


delp7= (a7-[states_new(1);states_new(3);states_new(5);states_new(7)]);

delp6= ((Tp3_copy'*delp7).*sigmoidGradient(Thetap2*a5));

delp5 = ((Tp2_copy'*delp6).*sigmoidGradient(Thetap1*a4'));

deltap6=(delp7*a6');

deltap5= (delp6*a5');

deltap4 = (delp5*a4);



Tp1_copy=[zeros(size(Tp1_copy,1),1) Tp1_copy];

Thetap1_grad = deltap4 ;%+ (lambda(1))*Tp1_copy;

Thetac1_grad = deltaroll + deltadroll + (lambda(3))*[zeros(size(Tc1_copy,1),1) Tc1_copy];
Thetac1_grad(1)=zeros(1);   %Gradient for bias unit in roll controller set to zero
Thetac1_grad(4)=[0];     %Gradient for dotpitch in roll controller set to zero
Thetap2_grad = deltap5 ;%+ (lambda(1))*[zeros(size(Tp2_copy,1),1) Tp2_copy];

Thetac2_grad = deltapitch + deltadpitch;%+(lambda(2))*[zeros(size(Tc2_copy,1),1) Tc2_copy];
Thetac2_grad(1)=0;  %Gradient for bias unit in pitch controller set to zero
Thetac2_grad(4)=0;   %Gradient for dotroll in pitch controller set to zero

Thetap3_grad = deltap6 ;%+ (lambda(1))*[zeros(size(Tp3_copy,1),1) Tp3_copy];

Thetac3_grad = deltaz + deltadz;%+(lambda(2))*[zeros(size(Tc3_copy,1),1) Tc3_copy];
if(k>990)
    if(k<1100)
        Thetac3_grad(1)=0;   %switching off learning for bias unit beyond 10 seconds
    end;
end;
Thetac4_grad = deltayaw + deltadyaw;
Thetac4_grad(1)=0;  %Gradient for bias unit in yaw controller set to zero

if(J5<0.0001)
%    Thetac4_grad = zeros(size(Thetac4_grad));
end;
grad=[Thetap1_grad(:); Thetap2_grad(:); Thetap3_grad(:); Thetac1_grad(:);...
    Thetac2_grad(:); Thetac3_grad(:);Thetac4_grad(:)];
grddy=[deltadz(:);deltadroll(:);deltadpitch(:);deltadyaw(:)];   %obsolete
end

