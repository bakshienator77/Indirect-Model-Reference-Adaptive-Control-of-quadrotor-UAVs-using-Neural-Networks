function [sys,x0,str,ts] = mix_sfun(t,x,u,flag)

switch flag,
 
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes;

 
  case 3
    sys=mdlOutputs(t,x,u);

   case { 1, 2, 4, 9 }
    sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end


function [sys,x0,str,ts] = mdlInitializeSizes()

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;  % dynamically sized
sizes.NumInputs      = 4;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

function sys = mdlOutputs(t,x,u)

roll=u(1);
pitch=u(2);
z=u(3);
yaw=u(4);

% Motor voltage outputs

out(1)=0.25*(z+pitch-yaw);
out(2)=0.25*(z-roll+yaw);
out(3)=0.25*(z-pitch-yaw);
out(4)=0.25*(z+roll+yaw);

sys = out;
