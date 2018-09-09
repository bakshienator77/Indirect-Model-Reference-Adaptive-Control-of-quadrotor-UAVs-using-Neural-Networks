% Motor 1
% INPUT: input thrust, thrust coefficient
% OUTPUT: desired omega

function out=motor1(in)


% ******calculation of omegadot********

desiredthrust=in(1);
thrustcoeff=in(2);
%disp(desiredthrust);
%disp(thrustcoeff);
desiredomega=sqrt(desiredthrust/thrustcoeff);


out(1)=desiredomega;


