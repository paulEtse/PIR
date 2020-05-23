% FIlE INITIALISATION 
%% PARAMETERS OF TWO TANKS BENCHMARK
global Kp Ki h1c A1 A2 h1c_0 Qpmax Qf1 h1max Cvb h2max h2c_0 Qf2 h2c_min h2c_max Cvo Qof1 ro g Patm SimuTime
global rate_noise_my1 rate_noise_my2 rate_noise_mUp rate_noise_mQp rate_noise_mUb rate_noise_mUo Te seed

ro=1000;
g=9.81;
Patm=101325;

app = interface;

%PID CONTROLLER PARAMETERS 
Kp=1e-3;%Gain 
Ki=5*1e-6;%Time integration constant 
h1c_0=0; %initiale value of the level in tank T1
h1c=0.5;%set-point of tank T1

%POMPE P1
Qpmax=1e-2; %The maximum flow from pump 1 [m^3/s]

%TANK T1
A1=0.0154; %Cross section of the tank T1 [m^2]
Qf1=1e-4;%Flow leak from tank T1 [m^3/s] 1e-4
h1max=0.6;%Maximum height of the tank T1 [m]
Qof1=1e-4;%Overflow rate [m^3/s] 1e-4

%VALVE Vb between two tanks
Cvb=1.5938*1e-4;%Global hydraulic flow coefficient of valve Vb
h2max=0.6;%Maximal height of the tank T2 [m]

%TANK T2
A2=0.0154;%Cross section of the tank T2 [m^2]
h2c_0=0;%Initial vlue of the level in tank 2
Qf2=1e-4;%Flow leak from tank T2 [m^3/s] 1e-4

% PARAMETERS OF "ON-OF CONTROLLER"
h2c_min=0.09;%Minimal value of h2 level
h2c_max=0.11;%Maximal value of h2 level

%VALVE Vo (TANK 2 OUTPUT)
Cvo=1.59640*1e-4;%Hydraulic flow coefficient of valve Vo

%OUTPUT PRESSURE TO USER FROM TANK T2
yo=0;
xo=[0.5;0.1];
%SENSORS NOISES 
rate_noise_my1=0.5*0.001;
rate_noise_my2=0.3*0.001;
rate_noise_mUp=0.01*1e-5;
rate_noise_mQp=0.01*1e-5;
rate_noise_mUb=0.0000;
rate_noise_mUo=0;
seed=randi(10000000);

% SAMPLE TIME
Te=1;
SimuTime=250;

%% Simulation

% Matrices A des quatres modes (Ub,Uo)
x = (Cvb/A1)*(1/(2*sqrt(h1c-(h2c_min+h2c_max)/2)));
y = (Cvo/A2)*(1/(2*sqrt((h2c_min+h2c_max)/2)));

A00 =zeros(2);

A01=[0 , 0 ; 
     0 , -y ];
 
A10=[-x , x ;
      x , -x];
  
A11 = [-x , x ;
       x , -x-y];

% Matrices B C et D de l'espace d'état
B=[ 1/A1 ; 
     0   ];
 
B_V2 = [ 1/A1 -(Cvb/A1)*(sqrt(h1c-(h2c_min+h2c_max)/2)) 0 ;
          0    (Cvb/A2)*(sqrt(h1c-(h2c_min+h2c_max)/2)) -(Cvo/A1)*sqrt((h2c_min+h2c_max)/2)];
 
C1=[ 1 0 ; 
     0 1 ];
 
D=[ 0 0 0;
    0 0 0];

L11_h1= acker(A11', C1(1,:)', [7*max(abs(eig(A11))) 7*max(abs(eig(A11)))]);
L11_h2= acker(A11', C1(2,:)', [7*max(abs(eig(A11))) 7*max(abs(eig(A11)))]);
L10_h1= acker(A10', C1(1,:)', [7*max(abs(eig(A10))) 7*max(abs(eig(A10)))]);
L10_h2= acker(A10', C1(2,:)', [7*max(abs(eig(A10))) 7*max(abs(eig(A10)))]);



