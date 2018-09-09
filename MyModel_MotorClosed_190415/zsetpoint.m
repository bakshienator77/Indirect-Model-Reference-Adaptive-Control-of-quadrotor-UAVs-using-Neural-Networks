% Z setpoint calculation
% INPUT: Initial Z setpoint, joystick input
% OUTPUT: Dynamic roll setpoint

function out=zsetpoint(in)
zsetpoint=in(1);
zsetpoint=zsetpoint+in(2)*0.03;
out(1)=zsetpoint;
    