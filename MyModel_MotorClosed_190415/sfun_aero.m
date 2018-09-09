function [sys,x0,str,ts] = sfun_aero(t,x,u,flag)

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
sizes.NumOutputs     = 26;  % dynamically sized
sizes.NumInputs      = 18;  % dynamically sized
sizes.DirFeedthrough = 1;   % has direct feedthrough
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-1 0];   % inherited sample time

function sys = mdlOutputs(t,x,u)

glob;
clk=u(18);

% ********* Operational Conditions *********
roll=u(1);     % [rad]
dotroll=u(2);  % [rad/s]
pitch=u(3);
dotpitch=u(4);
yaw=u(5);
dotyaw=u(6);
z=u(7);        % [m]
dotz=u(8);     % [m/s]
x=u(9);
dotx=u(10);
y=u(11);
doty=u(12);

% ********* Actual rotor speeds *********
Omega=u(13:16);    % [rad/s]
P_active = u(17);

% ********* Ratios *********
V=sqrt(dotx^2+doty^2);  % horizontal speed [m/s]
v1=sqrt(-0.5*V^2+sqrt((0.5*V^2)^2+(w/(2*rho*A))^2)); % Inflow velocity [m/s]
lambda=(v1-dotz)/(OmegaH*R); % Inflow ratio [less]
mu=V/(OmegaH*R); % advance ratio [less]
muX=dotx/(OmegaH*R); % advance ratio in x axis [less]
muY=doty/(OmegaH*R); % advance ratio in y axis [less]

Ct=sigma_*a*(((1/6)+(mu^2)/4)*theta0-((1+mu^2)*thetatw/8)-lambda/4); % Lift coeff [less]
ChX=sigma_*a*((muX*Cd/(4*a))+(0.25*lambda*muX*(theta0-0.5*thetatw))); % [less]
ChY=sigma_*a*((muY*Cd/(4*a))+(0.25*lambda*muY*(theta0-0.5*thetatw))); % [less]
Cq=sigma_*a*((1/(8*a))*(1+mu^2)*Cd+lambda*((theta0/6)-(thetatw/8)-(lambda/4))); % [less]

CrX= - sigma_*a*(muX*(theta0/6-thetatw/8-lambda/8)); % NEGATIVE ! % [less]
CrY= - sigma_*a*(muY*(theta0/6-thetatw/8-lambda/8)); % [less]

T = zeros(P,1);
HX = zeros(P,1);
HY = zeros(P,1);
Q = zeros(P,1);
RRX = zeros(P,1);
RRY = zeros(P,1);

%disp(Cq*rho*A*(R^3));
%assignin(ws,'dc',Cq);
disp(Ct*rho*A*(R^2));

for i = 1:P_active
% ********* Thrust force *********
T(i)=sign(Omega(i))*Ct*rho*A*((Omega(i)*R)^2); % Thrust [N]

% ********* Hub force *********
HX(i)=sign(Omega(i))*ChX*rho*A*((Omega(i)*R)^2); % Hub force in X [N]
HY(i)=sign(Omega(i))*ChY*rho*A*((Omega(i)*R)^2); % Hub force in Y [N]

% ********* Torque *********
Q(i)=sign(Omega(i))*Cq*rho*A*(Omega(i)^2)*(R^3); % [Nm]

% ********* Rolling moment *********
RRX(i)=sign(Omega(i))*CrX*rho*A*(Omega(i)^2)*(R^3); % [Nm]
RRY(i)=sign(Omega(i))*CrY*rho*A*(Omega(i)^2)*(R^3); % [Nm]

end

out(1:4)=T;
out(5:8)=Q;
out(9:12)=HX;
out(13:16)=HY;
out(17:20)=RRX;
out(21:24)=RRY;
out(25)=Cq*rho*A*(R^3);
out(26)=Ct*rho*A*(R^2);

sys = out;
