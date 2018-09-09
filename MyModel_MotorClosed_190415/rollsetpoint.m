% Roll setpoint calculation
% INPUT: Initial roll setpoint, joystick input
% OUTPUT: Dynamic roll setpoint

function out=rollsetpoint(in)
rsetpoint=in(1);
rsetpoint=rsetpoint+in(2)*0.0025;
out(1)=rsetpoint;
    