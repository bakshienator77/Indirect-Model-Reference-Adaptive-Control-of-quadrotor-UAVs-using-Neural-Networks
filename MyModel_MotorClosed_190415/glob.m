
% constants file
% INPUT: NaF
% OUTPUT: all constants

sp= 0.001; % [s] sampling period only used to compute YiA term in dinamica.m
g= 9.806;    % [m/s^2]
b= 3.13E-5;       % [N.s2] thrust factor in hover
d= 7.5E-7;         % [Nm.s2] drag factor in hover

%***** DEG2RAD ***** 
deg2rad=1.745329E-2; % [rad/deg]
rad2deg=57.295779;  % [deg/rad]

%***** Number of propellers  *****/

P=4;
%***** Arm length *****/
L= 0.232; 			%// [m]

%***** Total mass *****/
m = 0.53;	%// [kg]

%***** Inertia components *****/
Ixx = 6.228E-3;	%// [kg.m2]    
Iyy = 6.228E-3;	%// [kg.m2]
Izz = 1.121E-2;	%// [kg.m2]

%***** Rotor inertia *****/
r=4;    % reduction ratio
jm= 4e-7;	%// [kg.m2];  
jp= 6e-5;	%// [kg.m2];  
jr = jp+jm/r;	%// [kg.m2];

%***** CoG position *****/
% h= 0.058; 			%// [m] VERTICAL DISTANCE between CoG and propellers plan
h= 0; 			%// [m] more stable with h=0 !!!

%***** constants of the linear curve Omega=f(bin) *****
slo=2.7542; % slope (of the linear curve om=f(bin))
shi=3.627;  % shift

% *************************** AERODYNAMICS ***************************

% ********* Propeller ********* 
N=2; % number of blades
R=0.15; % [m] propeller radius
A=pi*(R^2); % [m^2] prop disk area
c=0.0394; % [m]   chord
theta0=0.2618;   % [rad] pitch of incidence
thetatw=0.045;   % [rad] twist pitch
sigma_=(N*c)/(pi*R); % solidity ratio (rotor fill ratio) [rad^-1]
a=5.7;  % Lift slope (given in literature)
Cd=0.052;   % Airfoil drag coefficient -- found by tests
Ac=0.005;  % [m^2] helicopter center hub area 

% ********* Gaz ********* 
rho= 1.293;     % [kg/m^3]   air density
nu=1.8e-5;      % [Pa.s] air viscosity @ 20deg

% ********* misc ********* 
w=(m/P)*g;   % [N] weigth of the helicopter/number of propellers
OmegaH=sqrt(w/b); % [rad/s] prop spd at hover
OmegaMax = 600; %[rad/s]
% ********* Longitudinal Drag Coefficients *********
Cx=1.32;    % estimation taken from literature [less]
Cy=1.32;    % estimation taken from literature [less]
Cz=1.32;    % estimation taken from literature [less]

% ***** OS4 volume *****
Vol=3.04E-4; 	% [m3]
PArchim = rho*g*Vol;  % [N]

% ******* Additional motor constants *******

km=5.2E-3;  % [Nm/A]
Rmot=0.6;  % [Ohm]
eta=0.9; %gearbox efficiency



% ***** ANNEXE ! ******
%Ftb=0.5*Cz*A*rho*v^2   % turbulent
%Fl=16*0.3*nu*v   % laminary 