function [J grad ] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y_model, lambda)
start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetap1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Thetap2 = reshape(nn_params(start2 :end2) ,hidden_layer_size, (hidden_layer_size + 1));
             
Thetap3 = reshape(nn_params(1 + end2:end2+num_labels*(hidden_layer_size+1)), ...
                 num_labels, (hidden_layer_size + 1));
total=end2+num_labels*(hidden_layer_size+1);
             
%input_layer_size=in(end-7);
%hidden_layer_size=in(end-6);
%num_labels=in(end-5);

start2 = 1 + hidden_layer_size * (input_layer_size + 1);
end2 = hidden_layer_size*(input_layer_size + 1) + (hidden_layer_size+1)*hidden_layer_size;

Thetac1 = reshape(nn_params(total+1:total+hidden_layer_size * (input_layer_size + 1)), ...
                hidden_layer_size, (input_layer_size + 1));

Thetac2 = reshape(nn_params(total+start2 :total+end2) ,hidden_layer_size, (hidden_layer_size + 1));

Thetac3 = reshape(nn_params(1 +total +end2:end), ...
num_labels, (hidden_layer_size + 1));

desired=[1; 1; 1; 1];
states=ones(12,1);
alpha=0.01;
y_ref=zeros(4,1);

%X=[desired' states(1:8)'];
X=[ones(size(X,1),1) X];
a2=sigmoid(Thetac1*X');
a2=[ones(1,size(a2,2)); a2];
a3=sigmoid(Thetac2*a2);
a3=[ones(1,size(a3,2)); a3];
a4=8*sigmoid(Thetac3*a3);

%a4=[ones(1,size(a4,2)); a4];

a4=[a4' [states(1);states(3);states(5);states(7)]' [states(2);states(4);states(6);states(8);states(10); states(12)]'];
a4=[ones(size(a4,1),1) 0 0 0 a4];

a5=sigmoid(Thetap1*a4');
a5=[ones(1,size(a5,2)); a5];
a6=sigmoid(Thetap2*a5);
a6=[ones(1,size(a6,2)); a6];
a7=Thetap3*a6;

adjustment=[100 0 0 0;0 100 0 0; 0 0 100 0; 0 0 0 1];





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

cost_pnn=sum(((y_model-a7)).^2)/2 + (lambda(1)/2)*(sum(sum(Tp1_copy.^2),2)+sum(sum(Tp2_copy.^2),2)+sum(sum(Tp3_copy.^2),2));
J=sum(((a7-y_ref(4))).^2)/2  + (lambda(1)/2)*(sum(sum(Tc1_copy.^2),2)+ ...
    sum(sum(Tc2_copy.^2),2)+sum(sum(Tc3_copy.^2),2));;

del7= (a7-y_ref(4));

del6= ((Tp3_copy'*del7).*sigmoidGradient(Thetap2*a5));

del5 = ((Tp2_copy'*del6).*sigmoidGradient(Thetap1*a4'));

del4= 8*(Tp1_copy'*del5).*sigmoidGradient(Thetac3*a3);

del4= del4(4);

del3 = ((Tc3_copy'*del4).*sigmoidGradient(Thetac2*a2));

del2= ((Tc2_copy'*del3).*sigmoidGradient(Thetac1*X'));


delta6=(del7*a6');

delta5= (del6*a5');

delta4 = (del5*a4);

delta3=(del4*a3');

delta2= (del3*a2');

delta1 = (del2*X);

delp7= (a7-y_model);

delp6= ((Tp3_copy'*delp7).*sigmoidGradient(Thetap2*a5));

delp5 = ((Tp2_copy'*delp6).*sigmoidGradient(Thetap1*a4'));

delp4= (Tp1_copy'*delp5);

delp3 = ((Tc3_copy'*delp4(4)).*sigmoidGradient(Thetac2*a2));

delp2= ((Tc2_copy'*delp3).*sigmoidGradient(Thetac1*X'));


deltap6=(delp7*a6');

deltap5= (delp6*a5');

deltap4 = (delp5*a4);

%disp(size(delta2))

%disp(size(delta1))

Tp1_copy=[zeros(size(Tp1_copy,1),1) Tp1_copy];

Thetap1_grad = deltap4 + (lambda(1))*Tp1_copy;

Thetac1_grad = delta1 + (lambda(1))*[zeros(size(Tc1_copy,1),1) Tc1_copy];

Thetap2_grad = deltap5 + (lambda(1))*[zeros(size(Tp2_copy,1),1) Tp2_copy];

Thetac2_grad = delta2 + (lambda(1))*[zeros(size(Tc2_copy,1),1) Tc2_copy];

Thetap3_grad = deltap6 + (lambda(1))*[zeros(size(Tp3_copy,1),1) Tp3_copy];

Thetac3_grad = delta3 + (lambda(1))*[zeros(size(Tc3_copy,1),1) Tc3_copy];
%if(cost_pnn>5)
Thetap1=Thetap1-alpha*Thetap1_grad;
Thetap2=Thetap2-alpha*Thetap2_grad;
Thetap3=Thetap3-alpha*Thetap3_grad;
%end;
%if(cost_cnn>10)
Thetac1=Thetac1-Thetac1_grad;
Thetac2=Thetac2-Thetac2_grad;
Thetac3=Thetac3-Thetac3_grad;
%end;
nn_params=[Thetap1(:); Thetap2(:); Thetap3(:); Thetac1(:); Thetac2(:); Thetac3(:)];

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Thetap1_grad(:) ; Thetap2_grad(:) ; Thetap3_grad(:); Thetac1_grad(:); Thetac2_grad(:); Thetac3_grad(:)];


end
