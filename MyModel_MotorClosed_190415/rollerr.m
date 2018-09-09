%roll error
% INPUT: state, rolld
% OUTPUT: roll error

function out=rollerr(in)
actualroll=in(1);
desiredroll=in(13);
error=desiredroll-actualroll;
out(1)=error;