%pitch error
% INPUT: state, pitchd
% OUTPUT: pitch error

function out=pitcherr(in)
actualpitch=in(3);
desiredpitch=in(13);
error=desiredpitch-actualpitch;
out(1)=error;