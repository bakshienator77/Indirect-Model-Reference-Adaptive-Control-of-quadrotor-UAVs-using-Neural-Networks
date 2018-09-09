function [J1 J2 grad control M S std sumy k grddy] = CostFunction_in_z(nn_params,input_layer_size,...
    hidden_layer_size, num_labels,d1,d2,d3,desired,states,y_ref, ...
    y_ref_dot, states_new,lambda,M,S,std,sumy,k,nn_paramsg)
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

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetac1 = reshape(nn_params(total+1:total+hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetac2 = reshape(nn_params(total+start2 :total+end2) ,hidden_layer_size, (hidden_layer_size + 1));

Thetac3 = reshape(nn_params(1 +total +end2:end),num_labels, (hidden_layer_size + 1));

delta1_old = reshape(nn_paramsg(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

delta2_old = reshape(nn_paramsg(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));

delta3_old = reshape(nn_paramsg(1 +end2:end),num_labels, (hidden_layer_size + 1));

error=-[y_ref(4)-states(7)];   %error in z

X=[error' [states(1);states(3);(states(8)-y_ref_dot(4))]'];
[X std M S k sumy] = onlinenormalize(M, k, S, X, sumy );

X=[ones(size(X,2),1) X']

a2=sigmoid(Thetac1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Thetac2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=4+8*sigmoid(Thetac3*a2);
%a4=[a4(1); a4(2); a4(3); a4(4)];
%a4=[ones(1,size(a4,2)); a4];
control=a4;
a4=[a4' [states(1);states(3);states(5);states(7)]' ...
    [states(2);states(4);states(6);states(8);states(10); states(12)]'];
a4=[ones(size(a4,1),1) 0 0 0 a4];
a5=sigmoid(Thetap1*a4');
a5=[ones(1,size(a5,2)); a5];
a6=sigmoid(Thetap2*a5);
a6=[ones(1,size(a6,2)); a6];
a7=Thetap3*a6;

adjustment=[10 0 0 0;0 10 0 0; 0 0 10 0; 0 0 0 1];




Tp1_copy=Thetap1;
Tp2_copy=Thetap2;
Tp3_copy=Thetap3;
Tp1_copy(:,1)=[];
Tp2_copy(:,1)=[];
Tp3_copy(:,1)=[];
Tc1_copy=Thetac1;
Tc2_copy=Thetac2;
Tc3_copy=Thetac3;
Tc1_copy(:,1)=[];
Tc2_copy(:,1)=[];
Tc3_copy(:,1)=[];

J1=sum(((a7-[states_new(1);states_new(3);states_new(5);states_new(7)])).^2)/2 
    %+ (lambda(1)/2)*(sum(sum(Tp1_copy.^2),2)+sum(sum(Tp2_copy.^2),2)+sum(sum(Tp3_copy.^2),2))

%J2=sum((([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref)).^2)/2 + (lambda(2)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
 %   sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2))

J2=sum((([states_new(7)]-y_ref(4))).^2)/2 + ((states_new(8)-y_ref_dot(4))^2)/2% + (lambda(2)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
   % sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2))


%del7= ([states_new(1);states_new(3);states_new(5);states_new(7)]-y_ref);

del7= -([states_new(7)]-y_ref(4));

del6= ((Tp3_copy(4,:)'*del7).*sigmoidGradient(Thetap2*a5));

del5 = ((Tp2_copy'*del6).*sigmoidGradient(Thetap1*a4'));

del4= 8*(Tp1_copy'*del5).*sigmoidGradient(Thetac3*a2);

del4= del4(4);

del3 = ((Tc3_copy'*del4).*sigmoidGradient(Thetac2*a2));

del2= ((Tc2_copy'*del3).*sigmoidGradient(Thetac1*X'));


delta6=(del7*a6');

delta5= (del6*a5');

delta4 = (del5*a4);

delta3=(del4*a3');

delta2= (del3*a2');

delta1 = (del2*X);



deld7= -(states_new(8) - y_ref_dot(4));

deld6= ((Tp3_copy(4,:)'*deld7).*sigmoidGradient(Thetap2*a5));

deld5 = ((Tp2_copy'*deld6).*sigmoidGradient(Thetap1*a4'));

deld4= 8*(Tp1_copy'*deld5).*sigmoidGradient(Thetac3*a2);

deld4= deld4(4);

deld3 = ((Tc3_copy'*deld4).*sigmoidGradient(Thetac2*a2));

deld2= ((Tc2_copy'*deld3).*sigmoidGradient(Thetac1*X'));


deltad3=(deld4*a3');

deltad2= (deld3*a2');

deltad1 = (deld2*X);


delp7= (a7-[states_new(1);states_new(3);states_new(5);states_new(7)]);

delp6= ((Tp3_copy'*delp7).*sigmoidGradient(Thetap2*a5));

delp5 = ((Tp2_copy'*delp6).*sigmoidGradient(Thetap1*a4'));


deltap6=(delp7*a6');

deltap5= (delp6*a5');

deltap4 = (delp5*a4);

%disp(size(delta2))

%disp(size(delta1))
if(states_new(8)~=0)
    cbv=-(states_new(8)/abs(states_new(8)))-0.7;
else
    cbv=1;
end;
Tp1_copy=[zeros(size(Tp1_copy,1),1) Tp1_copy];

oth1=(deltad1);%-delta1_old)/0.01;

oth2=(deltad2);%-delta2_old)/0.01;

oth3=(deltad3);%-delta3_old)/0.01;

Thetap1_grad = deltap4 + (lambda(1))*Tp1_copy;

Thetac1_grad = delta1 + oth1+(lambda(2))*[zeros(size(Tc1_copy,1),1) Tc1_copy];

Thetap2_grad = deltap5 + (lambda(1))*[zeros(size(Tp2_copy,1),1) Tp2_copy];

Thetac2_grad = delta2 + oth2+(lambda(2))*[zeros(size(Tc2_copy,1),1) Tc2_copy];

Thetap3_grad = deltap6 + (lambda(1))*[zeros(size(Tp3_copy,1),1) Tp3_copy];

Thetac3_grad = delta3 + oth3 +(lambda(2))*[zeros(size(Tc3_copy,1),1) Tc3_copy];

grad=[Thetap1_grad(:); Thetap2_grad(:); Thetap3_grad(:); Thetac1_grad(:); Thetac2_grad(:); Thetac3_grad(:)];
grddy=[deltad1(:);deltad2(:);deltad3(:)];
end

