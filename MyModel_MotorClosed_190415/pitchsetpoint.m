% Pitch setpoint calculation
% INPUT: Initial pitch setpoint, joystick input
% OUTPUT: Dynamic pitch setpoint

function out=pitchsetpoint(in)
psetpoint=in(1);
psetpoint=psetpoint+in(2)*0.0025;
out(1)=psetpoint;
    