% Aerodynamics function
% INPUT: glob, state, prop speeds
% OUTPUT: Aerodynamic forces and torques

function out=aero(in)

try
    
glob;
clk=in(18);

% ********* Operational Conditions *********
roll=in(1);     % [rad]
dotroll=in(2);  % [rad/s]
pitch=in(3);
dotpitch=in(4);
yaw=in(5);
dotyaw=in(6);
z=in(7);        % [m]
dotz=0;     % [m/s]
x=in(9);
dotx=0;
y=in(11);
doty=0;

% ********* Actual rotor speeds *********
Omega=in(13:16);    % [rad/s]
P_active = in(17);

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

catch err
    err
    err.stack
    line=err.stack(1).line
end
