% Yaw setpoint calculation
% INPUT: Initial yaw setpoint, joystick input
% OUTPUT: Dynamic yaw setpoint

function out=yawsetpoint(in)
ysetpoint=in(1);
ysetpoint=ysetpoint+in(2)*0.0025;
out(1)=ysetpoint;