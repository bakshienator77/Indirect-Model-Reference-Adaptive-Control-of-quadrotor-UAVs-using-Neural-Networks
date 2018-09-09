% calculation of hover angular velocity

glob;
lambdahover=w/2*rho*A;
Cthover=sigma_*a*((1/6)*theta0-(1/8)*thetatw-(1/4)*lambdahover);
disp(Cthover);
thrusthover=m*g/4;
bhover=Cthover*rho*A*(R^2);
omegahover=sqrt(thrusthover/(rho*A*(R^2)*Cthover));
disp(omegahover);
disp(bhover);
