function [ x,std, M1,S,k,sum,copy] = onlinenormalize( M, k, S, x, sum )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=x(:);
if(k==1)
    M1=x;
    S=zeros(size(x));
    std=ones(size(x));
    sum=x;
    x=x;
    copy=ones(size(x));
elseif(k==0)
    size(x)
M1=zeros(size(x));
S=zeros(size(x));
sum=zeros(size(x));
std=zeros(size(x));
copy=ones(size(x));
else
M1=M+(x-M)/k;
S=S +(x-M).*(x-M1);
std=sqrt(S/(k-1))
sum=sum+x;
mean=sum/k;

std_copy=std;
for i=1:size(x)
if(std(i)==0)
    std(i)=1;
end;
end;
std(2:3)=[1;1];   %STD FOR roll/pitch in to z controller set to 1
std(11:12)=[1;1];  %not normalising secondary terms of pitch controller
std(7:8)=[1;1];  %same for roll
%if(k<3000)
%std(5:8)=[1;1;1;1];
%end;
  %not normalising any in to yaw control
if(k<1000)
    std(15:16)=[1;1];
    std(13:14)=[1;1];
end;
x=(x)./std;
copy=std;
std=std_copy;
end;
k=k+1;
end

