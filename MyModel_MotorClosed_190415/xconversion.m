%x conversion from meters to degrees
% INPUT: x in meters
% OUTPUT: x in degrees

function out=xconversion(in)
xinmeters=in(1);
xindegrees=km2deg(xinmeters/1000);
out(1)=xindegrees;