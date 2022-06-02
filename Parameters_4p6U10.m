% "Complete Model - Trajectory Planning / FeedForward Currents"
% Christos Dimosthenous
% Stonybrook, NY - November,21st 2019

clear
close('all') 
clc

%load('TI_Data.mat') % Comment this Line of Code when Doing Real Time Control in the Test Cell

% SET THE FOLLOWING PARAMETERS...

% Encoder Calibration - 4p6U10 Build#02 - June 01, 2022, 11:35am

OHC = 0.00020207092241224200; %Cold Up
OLC = 0.00096167251825955700; %Cold Down

OHH = 0.00093082711447338400; %Hot Up
OLH = 0.00017143413488356100; %Hot Down

cold_low_offset = OLC*(2^26-1);
cold_stroke = (OLC-OHC)*(2^26-1);
hot_low_offset = OLH*(2^26-1);
hot_stroke = (OHH-OLH)*(2^26-1);
S = 0.05; 


% Classic Control Original Gains

Kpp = [110; 110; 110; 110;];
Kpv = [300; 300; 300; 300;];
Kpi = [3500; 1700; 1800; 1700;];


% em = [0.005, 0.005, 0.005, 0.005]';

% maxF = 4.7;

% posmat defines the Targets for Phases 1,2,3,4 respectively (m)...

posmat = [.00010; .00010; .04990; .04990;];

% Error Margins for New Trajectory Generation per Phase (m) 

% em = [0.05, 0.05, 0.05, 0.05]';

% Give Hot Helium Set Point (degC), and Lambda Initial Value...

HHSP = 500;
InHHSP = 495;
lambda = 1.16;

% sc1,sc2,sc3,sc4 set the control start points (m) for each phase...

sc1 = .025;
sc2 = .025;
sc3 = .025;
sc4 = .025;

% Initial Dead Zone Values

DZV = [0.040; 0.040; 0.010; 0.010;];

% Gas Spring Valve & Sump Valve Actuation Parameters

GSV_Counts = 1;

% TH_GSV = GSV_Counts - 1;

% Set Max Counts on all Counters

Count = 1000000000;

% Sampling Time

Ts = 0.0002; %(seconds)

K1m = 1.7E-4;            % Experimental Values
K2m = 7.0E-4; 

% MECHANICAL PARAMETERS

% Compression Spring Parameters Gen 4.2.10

THSConst = 20682; %(N/m) Top Hot Spring Constant
BHSConst = 21244; %(N/m) Bottom Hot Spring Constant

THFSL = 0.13553; %(m) Top Hot Spring Free Length
THatTopL = 0.08155; %(m) Top Hot Spring Length when Hot Rests at Top

BHFSL = 0.15055; %(m) Bottom Hot Spring Free Length
BHatTopL = 0.13845; %(m) Top Hot Spring Length when Hot Rests at Top

BCSConst = 4648; %(N/m) Bottom Cold Spring Constant
BCFSL = 0.125; %(m) Bottom Cold Spring Free Length
BCatTopL = 0.1089; %(m) Bottom Cold Spring Length when Cold Rests at Top

% Coulomb Friction

Ff_Cold_Up = 120;        %(N) Coulomb Friction Cold Displacer (Up/Down) - Gen 4.0 Estimation 150 All 4 phases
Ff_Cold_Down = 120;      %(N) Verified with OL testing / Vaccuum Tests

Ff_Hot_Up = 150;         %(N) Coulomb Friction Hot Displacer (Up/Down)
Ff_Hot_Down = 150;       %(N) Verified with OL testing / Vaccuum Tests

% Gas Pressure Input Data & Damping Coefficients

C_Cold_Up = 1000;         %(N-s/m) Cold Displacer Mechanical Damping Coefficient
C_Cold_Down = 800;       % Gen 4 --- 1200 for Cold Up and Down
C_Hot_Up = 800;          %(N-s/m) Hot Displacer Mechanical Damping Coefficient
C_Hot_Down = 800;        %Gen 4 --- 1000 for Cold Up and Down


g = 9.81;               % Gravity Acceleration m/s^2

% Moving Masses [kg]

Mh = 10.294;
Mc = 15.560;

Ts_lowspeed = 0.05; 

%Added 10/12/2020 Per Sal.
%Correction On Polarities - CD 07/17/21 11am

CUP = 1;
CDP = -1;
HUP = -1;
HDP = 1;

Kpp = [82; 70; 70; 80;];
Kpv = [165; 150; 160; 150;];
Kpi = [2800; 500; 1000; 500;];

KppS = [50; 110; 50; 110;];
KpvS = [180; 90; 100; 100;];

deact = 0;
accF = 2;

sc1 = .015;
sc2 = .015;
sc3 = .035;
sc4 = .035;

VC = [0.90, 0.85, 0.90, 0.85];

