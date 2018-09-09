% Mixer
% INPUT: Controller Outputs
% Output: Motor Voltages
function out=mix(in)
%if(in(1)>0.005)
%    roll=0;%0.005;
%elseif(in(1)<-0.005)
%    roll=0;%-0.005;
%else
roll=in(1);
%end;
%if(in(2)>0.005)
%    pitch=0;%0.005;
%elseif(in(2)<-0.005)
%    pitch=0;%-0.005;
%else
pitch=in(2);
%end;

    z=in(4);

%if(in(3)>0.01)
%    yaw=0;%0.01;
%elseif(in(3)<-0.01)
%    yaw=0;%-0.01;
%else
yaw=in(3);
%end;
% Motor voltage outputs

out(1)=0.25*(z+pitch-yaw);
out(2)=0.25*(z-roll+yaw);
out(3)=0.25*(z-pitch-yaw);
out(4)=0.25*(z+roll+yaw);