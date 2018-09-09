%x conversion from meters to degrees
% INPUT: x in meters
% OUTPUT: x in degrees

function out=yconversion(in)
yinmeters=in(1);
yindegrees=km2deg(yinmeters/1000);
out(1)=yindegrees;