%z error
% INPUT: state, zd
% OUTPUT: z error

function out=zerr(in)
actualz=in(7);
desiredz=in(13);
error=desiredz-actualz;
out(1)=error;