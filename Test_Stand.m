%test stand development, Alexander Cusianovic 2018
close all;
g = 32.2;       % ft/s^2
%%% engine parameters
T = 5000;           % 10,000 lbf
Isp = 217;          % s
OF = 2.6;
impTot = 200000;
tb = impTot/T;
Pc = 350;           % psia
gam = 1.14;         % specific heat ratio
exPressRat = 0.0588;% exit pressure ratio, from Dave's design
expansionRat = 4.44;% expansion ratio
contractionRat = 4.1;
Pa = 14.7;          % atmospheric pressure
Cf = sqrt(2*gam^2/(gam-1)*(2/(gam+1))^((gam+1)/(gam-1))*(1-exPressRat^((gam-1)/gam)))+ expansionRat*(exPressRat-Pa/Pc);
% Cstar = Isp*9.81/Cf; %m/s
Cstar = 1786;       % m/s
CstarEff = 0.85;
mdot = T/(Isp*g)*32.2;
oxMdot = OF/(OF+1)*mdot; %lbm/s
fuelMdot = mdot - oxMdot;
%propellant densities
oxRho = 72.2;       % lbm/ft^3
fuelRho = 53.85;    % lbm/ft^3
%flow rates
% oxQ = oxMdot/oxRho*448.831;     %(lbm/s)/(lbm/ft^3) = ft^3/s = > gpm
% fuelQ = fuelMdot/fuelRho*448.831;
oxQ = (oxMdot/oxRho)*12^3;    %in^3/s
oxGPM = oxMdot/oxRho*448.831; %gpm
fuelQ = fuelMdot/fuelRho*12^3; %in^3/s
fuelGPM = fuelMdot/fuelRho*448.831; %Gpm

Qtot = oxQ+fuelQ;
oxMass = tb*oxMdot;         %lbm
fuelMass = tb*fuelMdot;     %lbm
oxVol = oxMass/oxRho;       %ft^3
fuelVol = fuelMass/fuelRho; %ft^3

%tank sizing
fuelTheight = 5; %maximum height, ft
oxTheight = 5;   %maximum heigh, ft
tankD = sqrt(4/pi*fuelTheight/fuelVol);
oxTHdot = (oxQ/12^3)/(pi/4*tankD^2);
fuelTHdot = (fuelQ/12^3)/(pi/4*tankD^2);

%engine sizing
At = (mdot*Cstar*CstarEff/Pc)/9.81; % throat area, (lbm/s)*(m/s)/(lbf/in^2)=>in^2
Ac = At*contractionRat; %in^2
Dc = sqrt(4*Ac/pi);
%plumbing and injector sizing
injDeltaP = 0.3*Pc;
Cd = 0.7; %assume a Cd
oxinjArea = oxMdot/(Cd*sqrt(g*2*injDeltaP*oxRho/12^2));       %in^2
fuelinjArea = fuelMdot/(Cd*sqrt(g*2*injDeltaP*fuelRho/12^2)); %in^2
%  lbm/s   /   sqrt(lbm/in^2*lbm/ft^3*g(ft/s^2)/12^2)
%%% injector hole sizing
%oxElements = 100;
%fuelElements = 80;
%oxElementD = sqrt(4/pi*(oxinjArea/oxElements)); %in, element diameter
%fuelElementD = sqrt(4/pi*(fuelinjArea/fuelElements)); %in, element diameter
oxInjVel = Cd*sqrt(2*g*injDeltaP*12^2/oxRho);     %ft/s
fuelInjVel = Cd*sqrt(2*g*injDeltaP*12^2/fuelRho); %ft/s
%mdot = Cd*A*sqrt(2deltaP*rho)
%rho*A*v = cd*A*sqrt(2*deltaP*rho)
%v = Cd*sqrt(2*deltaP/rho)
z = 0.5:0.001:2;
oxMinorLoss_arr = zeros(length(z),1);
fuelMinorLoss_arr = zeros(length(z),1);
oxMajorLoss_arr = zeros(length(z),1);
fuelMajorLoss_arr = zeros(length(z),1);
for j = 1:length(z)
%%% PLUMBING DROPS
%minor losses
movKL = 1; %assuming ball valve, partially closed
movA = pi/4*(1.5/12)^2;          % ft^2
movLoss = 0.00694*movKL*0.5*(oxRho/g)*((oxQ/12^3)/movA)^2; 
mfvKL = 1;
mfvA = pi/4*(1.5/12)^2; 
mfvLoss = 0.00694*mfvKL*0.5*(fuelRho/g)*((fuelQ/12^3)/mfvA)^2;
lineD = z(j); % in
lineA = pi/4*(lineD/12)^2; % ft^2
elbowKL = 1.5;
num90ElbowsFuel = 5;
num90ElbowsOx = 5;
elbowLossFuel = num90ElbowsFuel*(0.00694*elbowKL*0.5*(fuelRho/g)*((fuelQ/12^3)/lineA)^2);
elbowLossOx = num90ElbowsOx*(0.00694*elbowKL*0.5*(oxRho/g)*((oxQ/12^3)/lineA)^2);
minorLossesOxTotal = elbowLossOx+movLoss;
minorLossesFuelTotal = elbowLossFuel+mfvLoss;
oxMinorLoss_arr(j) = minorLossesOxTotal;
fuelMinorLoss_arr(j) = minorLossesFuelTotal;
%To be con
% major losses
mg2lb = 2.20462e-6;
cm2ft = 0.0328084;
oxVisc = 0.0679*mg2lb/cm2ft; % LOX viscosity at boiling point, mg/cm-s
fuelVisc = 11.0E-4; % lb/ft s
oxVel = (oxQ/12^3)/lineA; %ft/s
fuelVel = (fuelQ/12^3)/lineA; %ft/s
oxRe = oxRho*oxVel*(lineD/12)/oxVisc;
fuelRe = fuelRho*fuelVel*(lineD/12)/fuelVisc;
eqRough = 0.03; %riveted steel
relRough = eqRough/lineD;
oxFric = 0.05;
fuelFric = 0.05;
oxLength = 5*12;
fuelLength = oxLength;
oxMajor = oxFric*(oxLength/lineD)*oxVel^2/(2*32.2);
fuelMajor = fuelFric*(fuelLength/lineD)*fuelVel^2/(2*g);
%^ units-> (ft/ft) ft2/s2 * s2 / ft = ft
oxMajorLoss = oxMajor*(oxRho)/12^2; %ft *( lbm/ft3 * ft/s2 ) -(dividebyg)> ft * (lbf/ft^3)/12^2 -> psi
fuelMajorLoss = fuelMajor*(oxRho)/12^2; %psi
oxMajorLoss_arr(j) = oxMajorLoss;
fuelMajorLoss_arr(j) = fuelMajorLoss;
end
a = pi/4*z.^2;
x = 0:0.1:200;
figure;
plot(z,oxMajorLoss_arr,z,oxMinorLoss_arr,z,(oxMajorLoss_arr+oxMinorLoss_arr));
legend('Ox Major','Ox Minor','Ox Major + Minor')
xlabel('Line Diameter (in)')
ylabel('Pressure Loss (psid)')
ylim([0 150])

figure
plot(z,fuelMajorLoss_arr,z,fuelMinorLoss_arr,z,(fuelMinorLoss_arr+fuelMajorLoss_arr))
legend('Fuel Major','Fuel Minor','Fuel Major+Minor')
xlabel('Line Diameter (in)')
ylabel('Pressure Loss (psid)')
ylim([0 150])

plumbDeltaP = 75;
%%% REGULATOR CALCULATIONS
ankP = (Pc + injDeltaP + plumbDeltaP); %tank pressure, irrelevant since flow is going to be choked

presstankP = 4000;      % psia
ACFM = Qtot/12^3*60;    %actual cubic feet per minute
Pstd = 14.7;            % psia
Tstd = 520;             % R
SCFM = ACFM*(presstankP/Pstd);
SCFH = SCFM*60;
heliumSG = 0.138;
nitrogenSG = 0.967;
Cv = SCFH*sqrt(nitrogenSG*Tstd)/(816*presstankP);

% 