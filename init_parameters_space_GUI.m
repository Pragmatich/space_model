function []= init_parameters_space_GUI(action)
% Used for the simulation parameter display, and alter
% ObjectLengthAnim is the length of the object on the animation window. 
global  param_B param_C param_Tt %param_Ttt    

if nargin<1,
    action='initialize';
end
if strcmp(action,'initialize'),
    global tidal_lock enable_trajectory_track enable_track_window ...
           cm I l m_sw w ObjectLengthAnim enable_video SimulationTimeStep M%

    param_B=[1,0,0]; %Main menu togglebuttons
    param_C=[1,0,0,0]; %Simulation control togglebuttons
    param_Tt=[0,0,0,0,0]; %Space Object Properties in the second coloumn
 %   param_Ttt=[0,0,0,0,0]; % Unused
    
    tidal_lock=1;
    enable_trajectory_track=1;
    enable_track_window=0;
    enable_video=0;
    SimulationTimeStep=200; % Simulation time step in seconds

     I = [4079,14437,14242];%Inertia [kg*m^2] [I_xx, I_yy, I_zz] 
     l=2.7; %length of the the wehicle
     m_sw=1000; % mass of space vehicle [kg]
     w=1.8; %wF=wR=w %width of the wehicle
     cm=[0;0;0]; %coordinates of the center of mass (cm) origin: mittle point of the vehicle

    % %	*****************************************************	
    % %	* Objectsize in te animation  *
    % %	*****************************************************
     ObjectLengthAnim=[-600000;0;0];
     load M;
   
    init_parameters_space_GUI('initialize_Window');
    init_parameters_space_GUI('initialize_ObjectPosition');
    init_parameters_space_GUI('initialize_ObjectSpeed');

elseif strcmp(action,'initialize_Window'),
    global w_pos w_size
        %	*************************
        %	*    Animation window   *
        %	*************************
        w_pos=[-8e6 -8e6]; 
        w_size=[3*8e6 2*8e6];
        
elseif strcmp(action,'initialize_Window_zoom'),
    global w_pos w_size
        %	********************************
        %	*    Animation window_zoomed   *
        %	********************************
        w_pos=[-7e6 -2e6]; 
        w_size=[5e6 5e6/1.5];
                
elseif strcmp(action,'initialize_ObjectPosition'),
        %	*************************
        %	*    Object position    *
        %	*************************
    global r_earth swSPpos0 r_earthSP2swSP0
    swSPpos0=[-1*(r_earth+300000);0*r_earth;0*r_earth];
    r_earthSP2swSP0=sqrt(sqrt(swSPpos0(1)^2+swSPpos0(2)^2)^2+swSPpos0(3)^2);
    
elseif strcmp(action,'initialize_ObjectSpeed'),
        %	*************************
        %	*    Object speed       *
        %	*************************
    global v_Object_0 mu_earth r_earth swSPpos0
    v_Object_0=[0;0;sqrt(mu_earth/(r_earth+300000))*(sqrt(2)*0.99)];

elseif strcmp(action,'initialize_ObjectSpeed1st'),
        %	***********************************
        %	*    Object speed 1st Cosmic      *
        %	***********************************
    global v_Object_0 mu_earth r_earth swSPpos0
    r_earthSP2swSP=sqrt(sqrt(swSPpos0(1)^2+swSPpos0(2)^2)^2+swSPpos0(3)^2);
    v_Object_0=[0;0;sqrt(mu_earth/(r_earthSP2swSP))];

elseif strcmp(action,'initialize_ObjectSpeed2nd'),
        %	***********************************
        %	*    Object speed 2nd Cosmic      *
        %	***********************************
    global v_Object_0 mu_earth r_earth swSPpos0
    r_earthSP2swSP=sqrt(sqrt(swSPpos0(1)^2+swSPpos0(2)^2)^2+swSPpos0(3)^2);
    v_Object_0=[0;0;sqrt(mu_earth/(r_earthSP2swSP))*sqrt(2)];
    
end





