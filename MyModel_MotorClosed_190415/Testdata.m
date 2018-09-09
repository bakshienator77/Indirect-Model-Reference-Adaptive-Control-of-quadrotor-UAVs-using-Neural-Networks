roll tests

function [ desired ] = testinputs( countervariable67  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
desired=ones(1,5);

if(countervariable67==0)
    desired(1,1:4)=[0.1 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0.3 0 -45 0];

elseif(countervariable67<200)
    desired(1,1:4)=[0.5 0 -45 0];

elseif(countervariable67<300)
    desired(1,1:4)=[0.7 0 -45 0];

elseif(countervariable67<500)
    desired(1,1:4)=[0.9 0 -45 0];

elseif(countervariable67<600)
    desired(1,1:4)=[1 0 -45 0];

elseif(countervariable67<700)
    desired(1,1:4)=[0.5 0 -45 0];

elseif(countervariable67<800)
    desired(1,1:4)=[0 0 -45 0];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[-0.5 0 -45 0];

elseif(countervariable67<1000)
    desired(1,1:4)=[-1.0 0 -45 0];
end;
desired(1,5)=countervariable67+1;
end

z tests

if(countervariable67==0)
    desired(1,1:4)=[0 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0 0 -20 0];

elseif(countervariable67<200)
    desired(1,1:4)=[0 0 -27 0];

elseif(countervariable67<300)
    desired(1,1:4)=[0 0 -32 0];

elseif(countervariable67<500)
    desired(1,1:4)=[0 0 -37 0];

elseif(countervariable67<600)
    desired(1,1:4)=[0 0 -42 0];

elseif(countervariable67<700)
    desired(1,1:4)=[0 0 -47 0];

elseif(countervariable67<800)
    desired(1,1:4)=[0 0 -50 0];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[-0 0 -55 0];

elseif(countervariable67<1000)
    desired(1,1:4)=[0 0 -40 0];
end;
desired(1,5)=countervariable67+1;
end

test zroll


if(countervariable67==0)
    desired(1,1:4)=[0.1 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0.3 0 -20 0];

elseif(countervariable67<200)
    desired(1,1:4)=[0.5 0 -27 0];

elseif(countervariable67<300)
    desired(1,1:4)=[0.7 0 -32 0];

elseif(countervariable67<500)
    desired(1,1:4)=[1.0 0 -37 0];

elseif(countervariable67<600)
    desired(1,1:4)=[0.5 0 -42 0];

elseif(countervariable67<700)
    desired(1,1:4)=[0 0 -47 0];

elseif(countervariable67<800)
    desired(1,1:4)=[-0.5 0 -50 0];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[-1.0 0 -55 0];

elseif(countervariable67<1000)
    desired(1,1:4)=[-1.40 0 -40 0];
end;
desired(1,5)=countervariable67+1;
end

test zpitch

if(countervariable67==0)
    desired(1,1:4)=[0 0.1 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0 0.3 -20 0];

elseif(countervariable67<200)
    desired(1,1:4)=[0 0.5 -27 0];

elseif(countervariable67<300)
    desired(1,1:4)=[0 0.7 -32 0];

elseif(countervariable67<500)
    desired(1,1:4)=[0 1.0 -37 0];

elseif(countervariable67<600)
    desired(1,1:4)=[0 0.5 -42 0];

elseif(countervariable67<700)
    desired(1,1:4)=[0 0 -47 0];

elseif(countervariable67<800)
    desired(1,1:4)=[0 -0.5 -50 0];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[0 -1.0 -55 0];

elseif(countervariable67<1000)
    desired(1,1:4)=[0 -1.40 -40 0];
end;
desired(1,5)=countervariable67+1;
end

yaw tests

if(countervariable67==0)
    desired(1,1:4)=[0 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0 0 -45 0.5];

elseif(countervariable67<200)
    desired(1,1:4)=[0 0 -45 1.0];

elseif(countervariable67<300)
    desired(1,1:4)=[0 0 -45 1.5];
    
elseif(countervariable67<400)
    desired(1,1:4)=[0 0 -45 2];

elseif(countervariable67<500)
    desired(1,1:4)=[0 0 -45 2.5];

elseif(countervariable67<600)
    desired(1,1:4)=[0 0 -45 3.14];

elseif(countervariable67<700)
    desired(1,1:4)=[0 0 -45 2];

elseif(countervariable67<800)
    desired(1,1:4)=[0 0 -45 0];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[0 0 -45 -2];

elseif(countervariable67<1000)
    desired(1,1:4)=[0 0 -45 -3.14];
end;
desired(1,5)=countervariable67+1;
end

zyaw tests

function [ desired ] = testinputs( countervariable67  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
desired=ones(1,5);

if(countervariable67==0)
    desired(1,1:4)=[0 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0 0 -20 1.0];

elseif(countervariable67<200)
    desired(1,1:4)=[0 0 -25 1.0];

elseif(countervariable67<300)
    desired(1,1:4)=[0 0 -25 3.14];
    
elseif(countervariable67<400)
    desired(1,1:4)=[0 0 -30 3.14];

elseif(countervariable67<500)
    desired(1,1:4)=[0 0 -35 3.14];

elseif(countervariable67<600)
    desired(1,1:4)=[0 0 -40 0];

elseif(countervariable67<700)
    desired(1,1:4)=[0 0 -45 0];

elseif(countervariable67<800)
    desired(1,1:4)=[0 0 -50 -0.2];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[0 0 -40 -3.14];

elseif(countervariable67<1000)
    desired(1,1:4)=[0 0 -45 -3.14];
end;
desired(1,5)=countervariable67+1;
end

zrollpitchyaw tests

function [ desired ] = testinputs( countervariable67  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
desired=ones(1,5);

if(countervariable67==0)
    desired(1,1:4)=[0.2 0 -45 0];

elseif(countervariable67<100)
    desired(1,1:4)=[0.4 -0.5 -20 3.14];

elseif(countervariable67<200)
    desired(1,1:4)=[0.1 0 -20 2.14];

elseif(countervariable67<300)
    desired(1,1:4)=[0.4 0.3 -20 1.5];
    
elseif(countervariable67<400)
    desired(1,1:4)=[0.5 0.4 -20 1.8];

elseif(countervariable67<500)
    desired(1,1:4)=[0.4 0.4 -25 2.14];

elseif(countervariable67<600)
    desired(1,1:4)=[-0.1 0 -27 2];

elseif(countervariable67<700)
    desired(1,1:4)=[-0.3 0.3 -27 2];

elseif(countervariable67<800)
    desired(1,1:4)=[-0.7 0.6 -25 1.6];
    
elseif(countervariable67<900)
    
    desired(1,1:4)=[-0.8 0.8 -23 1.4];

elseif(countervariable67<1000)
    desired(1,1:4)=[-1 1 -20 1.2];
end;
desired(1,5)=countervariable67+1;
end