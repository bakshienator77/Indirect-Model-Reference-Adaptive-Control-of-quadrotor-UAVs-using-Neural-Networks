function [omega] = giveinputs(countervariable67)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
X=load('datafornn1.txt');
omega=ones(1,size(X,2)+1);
%a=countervariable67/500;
%disp(a)
if(countervariable67>5)
omega(1,1:4)=X(floor((countervariable67-5)/10)+1,:);
end;
omega(1,5)=countervariable67+1;

end

