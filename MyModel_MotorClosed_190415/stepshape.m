function varargout=stepshape(n,os,ts,sp)
%STEPSHAPE System Prototype for Step Response Matching.
% STEPSHAPE(N,OS,Ts,SP) returns a continuous time system that meets the
% given unit step response specifications.
% N is the number of system poles. N must be between 2 and 15.
% OS is the percent overshoot. OS must be between 0 and 20.
% Ts is the settling time in seconds.
% SP is the settling time percentage. For example, if SP = 2, Ts specifies
% the 2% settling time. SP must be between 0.1 and 10. If SP is not given,
% SP = 2 is assumed.
%
% Example: STEPSHAPE(7,5,1) returns a 7-th order system having 5% overshoot
% and a 1 second settling time to within 2% of the final value.
% Example: STEPSHAPE(3,0,2,1) returns a 3-rd order system having 0%
% overshoot and a two second settling time to within 1% of the final value.
%
% [N,D] = STEPSHAPE(...) returns the numerator polynomial vector N and
% denominator polynomial D of the prototype system.
% [Z,P,K] = STEPSHAPE(...) returns the zeros Z, the poles P, and the gain K
% of the prototype system.
% [A,B,C,D] = STEPSHAPE(...) returns the state space matrices of the
% prototype system.
% SYS = STEPSHAPE(...) returns a Control System Toolbox system object SYS
% containing the prototype system.
%
% Algorithm: Given N, normalized Butterworth and Bessel low pass filter
% poles are computed. Linear interpolation/extrapolation from these sets of
% poles is used to find a set of poles that have the desired OS. These
% poles are then scaled to provide the desired Ts. If N is even, all poles
% are in complex conjugate pairs. If N is odd, all poles except one are in
% complex conjugate pairs.
%
% See also TF2SS, TF2ZP, ZP2TF, ZP2SS, SS2TF, SS2ZP, LTITR, LTIVIEW

% D.C. Hanselman, University of Maine, Orono, ME 04469
% Mastering MATLAB 7
% 2006-04-27

if nargin<4
   sp=2;
elseif nargin<3
   error('Three or Four Input Arguments Required.')
end
if ~isnumeric(n) || numel(n)>1 || fix(n)~=n || n<2 || n>15
   error('N Must be a Scalar Integer Between 2 and 15.')
end
if ~isnumeric(os) || numel(os)>1 || os<0 || os>20
   error('OS Must be a Scalar Between 0 and 20.')
end
os=max(os,1e-3); % os can't be exactly zero
if ~isnumeric(ts) || numel(ts)>1 || ts<1e-6 || ts>1e6
   error('Ts Must be a Scalar Between 1e-6 and 1e6.')
end
if ~isnumeric(sp) || numel(sp)>1 || sp<0.1 || sp>10
   error('SP Must be a Scalar Between 0.1 and 10.')
end
alim=[-2 -.7 -.5+zeros(1,12); ...               % alpha limits for given n
      2.4 1.75 1.55 1.45 1.3 1.2 1.18 1.15 1.15 1.08+zeros(1,5)]';

[pbut,pbes]=local_getpoles(n);                        % get prototype poles

fun=@(alpha) findalpha(alpha,os,pbut,pbes,sp);         % objective function

options=optimset('TolX',1e-4);
alpha=fzero(fun,alim(n-1,:),options);    % iterate alpha to find desired os

[err,p,tsa]=fun(alpha);                          % gather specs at solution

% Now have poles that meet the percent overshoot spec.
% Scale poles to meet settling time spec.
p=p*tsa/ts;
k=abs(real(prod(p)));
z=[];
% Now have solution in zero-pole-gain form
% convert to form requested and output
if nargout==1                    % SYS
   try
      varargout{1}=zpk(z,p,k);
   catch
      error('Control System Toolbox Required for SYS Output.')
   end
elseif nargout==2                % [N,D]
   [num,den]=zp2tf(z,p,k);
   varargout{1}=num;
   varargout{2}=den;
elseif nargout==3                % [Z,P,K];
   [varargout{1:3}]=deal(z,p,k);
elseif nargout==4                % [A,B,C,D]
   [a,b,c,d]=zp2ss(z,p,k);
   [varargout{1:4}]=deal(a,b,c,d);
end
%--------------------------------------------------------------------------
function [err,p,ts]=findalpha(alpha,osspec,pbut,pbes,sp)
% iterative function to find alpha that matches desired overshoot

p=alpha*pbut + (1-alpha)*pbes;
[os,ts]=local_getspecs(p,sp);
err=os-osspec;
%--------------------------------------------------------------------------
function [pbut,pbes]=local_getpoles(n)
% Get Butterworth and Bessel Filter poles of order N.
% These prototype poles are linearly interpolated between the Bessel and
% Butterworth pole locations to set the percent overshoot and then they are
% frequency scaled to set the settling time.

pbut=exp(-pi/2i*((1:2:n-1)'/n + 1));
pbut=[pbut;conj(pbut)];
if rem(n,2) % n is odd, add negative real pole
   pbut=[pbut;-1];
end
pbut=cplxpair(pbut);                        % unit circle butterworth poles

d=ones(1,n+1); % create bessel polynomial, then find roots
for k=1:n
   d(k+1)=d(k)*(n+k)*(n-k+1)/(2*k);
end
pbes=cplxpair(roots(d))/(prod(n+1:2*n)^(1/n)/2);  % normalized bessel poles
%--------------------------------------------------------------------------
function [os,ts]=local_getspecs(p,sp)
% Given poles in p find unit step response and OS and Ts specs.
% Since I have the poles and none are repeated, do this the old fashioned
% way, find the residues and simply evaluate the step response.
% From the step response get percent overshoot and settling time.

n=length(p);
num=abs(real(prod(p))); % numerator
tend=2*log(sp/100)/max(real(p));      % estimate final time for computation
t=linspace(0,tend,150)';
modes=zeros(length(t),n);                % storage for modes evaluated at t
r=zeros(n,1);
nk=1:n;
for k=1:n
   r(k)=num./(p(k)*prod(p(k)-p(nk~=k)));                     % k-th residue
   modes(:,k)=exp(p(k)*t);             % k-th mode evaluated at time points
end
y=1+real(modes*r);                 % system output is matrix multiplication

idx1=find(abs(y-1)>abs(sp/100),1,'last');
if y(idx1)>1                     % settling time using linear interpolation
   alpha=(y(idx1)-(1+sp/100))/(y(idx1)-y(idx1+1));
   ts=t(idx1)+alpha*(t(idx1+1)-t(idx1));
else
   alpha=((1-sp/100)-y(idx1))/(y(idx1+1)-y(idx1));
   ts=t(idx1)+alpha*(t(idx1+1)-t(idx1));
end
os=max(0,(max(y)-1))*100;                        % percent overshoot search
%--------------------------------------------------------------------------