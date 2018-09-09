function [sys,x0,str,ts] = sfun_zerr(t,x,u,flag)

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
sizes.NumOutputs     = 1;  % dynamically sized
sizes.NumInputs      = 13;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

function sys = mdlOutputs(t,x,u)

actualz=u(7);
desiredz=u(13);
error=desiredz-actualz;
out(1)=error;
sys = out;
