function [ desired ] = testinputs1( countervariable67  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    desired=[0 0 0 -1 1];
    if(countervariable67>1000)
        if(countervariable67<2000)
            desired=[0 0 0 -1 1];
        elseif(countervariable67<2050)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<3000)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<3050)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<3950)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<4000)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<4050)
            desired=[0 0 0 -3 1];
        elseif(countervariable67<5100)
            desired=[0 0 0 -3 1];
        elseif(countervariable67<5150)
            desired=[0 0 0 -3 1];
        elseif(countervariable67<6000)
            desired=[0 0 0 -3 1];
        elseif(countervariable67<7000)
            desired=[0 0 0 -2 1];
        elseif(countervariable67<8000)
            desired=[0 0 0 -2 1];
        end;
    end;
desired(1,5)=countervariable67+1;
end