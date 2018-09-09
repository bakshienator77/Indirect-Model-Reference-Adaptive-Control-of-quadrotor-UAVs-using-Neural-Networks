%yaw error
% INPUT: state, yawd
% OUTPUT: yaw error

function out=yawerr(in)
actualyaw=in(5);
desiredyaw=in(13);
error=desiredyaw-actualyaw;
out(1)=error;