% Motor 3
% INPUT: input thrust, thrust coefficient
% OUTPUT: desired omega

function out=motor3(in)


% ******calculation of omegadot********

desiredthrust=in(1);
thrustcoeff=in(2);
desiredomega=sqrt(desiredthrust/thrustcoeff);


out(1)=desiredomega;


