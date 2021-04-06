 function [sys,x0,str,ts] = s_spaceship(t,x,u,flag) 
% S-Function of a spaceship
% Version 1.0 
% Created by Dr. Tamas Szakacs 2017

switch flag,
	case 0
		[sys,x0,str,ts]=mdlInitializeSizes; % Initialization
	case 1
		sys = mdlDerivatives(t,x,u); % Calculate derivatives
  	case 2
  %		sys = mdlUpdate(t,x,u); % Update
    case 3
		sys = mdlOutputs(t,x,u); % Calculate outputs
	case {4, 9 } % Unused flags
		sys = [];
% 	otherwise
% 		error(['Unhandled flag = ',num2str(flag)]); % Error handling
end

%**************************************************************
%==============================================================
%	 mdlInitializeSizes 
%==============================================================
%**************************************************************

function [sys,x0,str,ts] = mdlInitializeSizes
global r_earthSP2swSP test swSPspeed0 swSPpos0 v_Object_0 %r_earthSP2swSP0 r_earth mu_earth 
% Call simsizes for a sizes structure, fill it in and convert it
% to a sizes array.
sizes = simsizes;
sizes.NumContStates = 12;
sizes.NumDiscStates = 0;
sizes.NumOutputs = 16; 
sizes.NumInputs = 15;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);

% Initialize the initial conditions.
%x0= [cm_x,cm_y,cm_z, cm_v_x,cm_v_y,cm_v_z,... 
%    ...cm_fi_x,cm_fi_y,cm_fi_z cm_omega_x,cm_omega_y,cm_omega_z]
% swSPpos0=[-1*(r_earth+200000);0*r_earth;0*r_earth];
% [0;0;sqrt(mu_earth/(r_earth+200000))*(sqrt(2)*0.99)];
% v_Object_0;
% swSPpos0;
r_earthSP2swSP=1;
swSPspeed0=v_Object_0;
%r_earthSP2swSP=sqrt(sqrt(swSPpos0(1)^2+swSPpos0(2)^2)^2+swSPpos0(3)^2); % vector length from Earth SP to space wehicle SP
swSPangpos0=[0;-pi/2;0]; % Space vehicle initial angular position. 
swSPangspeed0=[0;0*swSPspeed0(1)/r_earthSP2swSP;0]; % Initial angular speed x,y,z
x0 = [swSPpos0;swSPspeed0;swSPangpos0;swSPangspeed0]; %cm_v_x=3 (initial vehicle speed=3m/s)
str = [];
ts = [0 0];
test=[0;0;0];

% End of mdlInitializeSizes.

%**************************************************************
%==============================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%==============================================================
%**************************************************************

function sys = mdlDerivatives(t,x,u)
global mu_earth r_earthSP2swSP tidal_lock test m_sw deltav %m_earth r_earth 
%**************************************************************
%***                           Inputs                       ***
%**************************************************************
%Nozzle_upper=  [ u(1),	 u(2),	 u(3)]
%Nozzle_bottom= [ u(4),	 u(5),   u(6)]
%Nozzle_left=   [ u(7),	 u(8),   u(9)]
%Nozzle_right=  [u(10),	u(11),  u(12)]
%Thrust=  [u(13),	u(14),	u(15)]

Thrust=[u(13),u(14),u(15)];
% markm=1e6; %mass of object  
%delta= u(16); % delta is the articulation angle. 

% Acceleration vector of cm
% acc=(Nozzle_upper+Nozzle_bottom+Nozzle_left+Nozzle_right=+Thrust)/m_sw;
acc=(Thrust)/m_sw;

% Angular acceleration vector of cm
 
%ac=[acc alpha];
ac=[acc,0,0,0];

%**************************************************************
% State variables
%**************************************************************
%x(1)=cm_pos_x		x(2)=cm_pos_y,		x(3)=cm_pos_z, 
%x(4)=cm_v_x,		x(5)=cm_v_y, 		x(6)=cm_v_z, 
%x(7)=cm_fi_x,		x(8)=cm_fi_y,		x(9)=cm_fi_z 
%x(10)=cm_fidot_x x(11)=cm_fidot_y 	x(12)=cm_fidot_z


%*****************************
%*         Altutute          * Altitute from Earth
%*****************************
 
r_earthSP2swSP=sqrt((sqrt(x(1)^2+x(2)^2))^2+x(3)^2); % vector length from Earth SP to space wehicle SP
n_SP=x(1:3)/(-1*r_earthSP2swSP); % direction vector n_SP [0..1, 0..1, 0..1]
g_sw_earth=mu_earth/r_earthSP2swSP^2*n_SP; % gravity vector at space vehicle
%fi_x=atan(SP(1)/SP(2))/pi*180
test=n_SP;
%****************************
%*         Gravity          *
%****************************

ac(1:3)=ac(1:3)+g_sw_earth'; % g is the gravity vector at space vehicle

% 
%    ======================
%    ===   Tidal Lock   ===
%    ======================
    if tidal_lock
        vr_sw=(n_SP*x(4:6)'*n_SP); %radial component of speed vector relative to circular orbit
        vt_sw=x(4:6)-vr_sw; %tangential component of speed vector relative to circular orbit
        abs_vt_sw=sqrt(sqrt(vt_sw(1)^2+vt_sw(2)^2)^2+vt_sw(3)^2); %absolute value of speed vector
        n_vt=vt_sw/abs_vt_sw; % direction of tangential speed vector
        n_w=cross(n_SP,n_vt); % direction of rotation speed
        omega=-abs_vt_sw/r_earthSP2swSP; %rotatinal speed of object.
        test=[omega*n_w(2); x(11); 0];


        x(10:12)=(omega*n_w);   % tidal locked orbit ...
                                % this line constrains the body to be tidal locked.
    end                        

%     if deltav~=0
%         x(6)
%         x(6)=x(6)+deltav;
%         deltav=0;
%     end
%     x(6)
% CALCULATION OF DERIVATIVES /dX(I)/
   sys(1:3)=x(4:6);     % cm_pos_dot   = cm_v      	   
   sys(4:6)=ac(1:3);    % cm_v_dot 	 = ac
   sys(7:9)=x(10:12);    % cm_fi_dot 	 = cm_fidot      	       
   sys(10:12)=ac(4:6);   % cm_fidot_dot = cm_fidotdot
% End of mdlDerivatives.


% function sys = mdlUpdate(t,x,u)
% sys= [];

%**************************************************************
%==============================================================
% mdlOutputs
% Return the block outputs.
%==============================================================
%**************************************************************

function sys = mdlOutputs(t,x,u)
global  r_earthSP2swSP test %r_cm2FL r_cm2FR r_cm2RL r_cm2RR r_cm2lk lk R_postest

% *************************************************
% * calculation the circumferential speed matrice *
% *************************************************
%W=[0     -x(12)  x(11);  
%   x(12)  0     -x(10);
%  -x(11)  x(10)  0   ];

% ***************************************	
% * Associating variable to test output *
% ***************************************        

%  test
%  r_earthSP2swSP
sys=[r_earthSP2swSP x' test'];

% End of mdlOutputs.

