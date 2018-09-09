%z error
% INPUT: state, zd
% OUTPUT: z error

function out=zrateerr(in)
actualzrate=in(8);
desiredzrate=in(13);
error=desiredzrate-actualzrate;
out(1)=-error;