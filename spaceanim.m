function [sys,x0]=spaceanim(t,x,u,flag,ts)
% Space animation. %
% u(1..3) = cm_pos(x,y,z) 
% u(4..6) = fi(x,y,z)

global w_pos w_size r_earth cm ObjectLengthAnim ObjectLengthAnim_r hndl18 hndl19 enable_trajectory_track enable_track_window
% window_x window_y %obsolete on 1028.04.09
% window_x_size window_y_size %obsolete on 1028.04.12

global frame M enable_video SimulationTimeStep %Needed for creating video

if flag==0, % Initialize the figure for use with this simulation
    
    space_animinit('Space Animation');   
    animhandle = findobj('Type','figure','Name','Space Animation');
    frame =1;
    clear M;
 
 %   axis([window_x window_x+w_size(1) window_y window_y+window_y_size]);
 axis([w_pos(1) w_pos(1)+w_size(1) w_pos(2) w_pos(2)+w_size(2)]);
    hold on;
     
   ObjectLengthAnim_r=[-ObjectLengthAnim(1)/2+cm(1) 0;
              ObjectLengthAnim(1)/2+cm(1) 0];
      
%      theta = linspace(-pi,pi,50);      %3rd parameter number of points, defaut 100
%      plot(cos(theta)*r_earth/3*2,sin(theta)*r_earth,'b','LineWidth',0.5);
%      plot(cos(theta)*r_earth,sin(theta)*r_earth/3*2,'b','LineWidth',0.5);
%      plot(cos(theta)*r_earth/3,sin(theta)*r_earth,'b','LineWidth',0.5);
%      plot(cos(theta)*r_earth,sin(theta)*r_earth/3,'b','LineWidth',0.5);
%     plot([-r_earth r_earth],[0 0],'b','LineWidth',1); %horizontal line
%     plot([0 0],[-r_earth r_earth],'b','LineWidth',1); %vertical line


theta = linspace(-pi,pi,50);      %3rd parameter number of points, defaut 100
beta=-15/180*pi;
alfa=0/180*pi;
gamma=15/180*pi;
ROT_x=[1 0 0;0 cos(alfa) -sin(alfa); 0 sin(alfa) cos(alfa)];
ROT_y=[cos(beta) 0 sin(beta);0 1 0; -sin(beta) 0 cos(beta)];
ROT_z=[cos(gamma) -sin(gamma) 0;sin(gamma) cos(gamma) 0; 0 0 1];
data=[cos(theta')*r_earth 0*theta' sin(theta')*r_earth];
    data_r1=data*ROT_z;
    data_r2=data_r1*ROT_z;
    data_r3=data_r2*ROT_z;
    data_r4=data_r3*ROT_z;
    data_r5=data_r4*ROT_z;
    data_r6=data_r5*ROT_z;
    data_r7=data_r6*ROT_z;
    data_r8=data_r7*ROT_z;
    data_r9=data_r8*ROT_z;
    data_r10=data_r9*ROT_z;
    data_r11=data_r10*ROT_z;
    data_r12=data_r11*ROT_z;
    
    data_r1=data_r1*ROT_y;
    data_r2=data_r2*ROT_y;
    data_r3=data_r3*ROT_y;
    data_r4=data_r4*ROT_y;
    data_r5=data_r5*ROT_y;
    data_r6=data_r6*ROT_y;
    data_r7=data_r7*ROT_y;
    data_r8=data_r8*ROT_y;
    data_r9=data_r9*ROT_y;
    data_r10=data_r10*ROT_y;
    data_r11=data_r11*ROT_y;
    data_r12=data_r12*ROT_y;
    
hndl11=plot(data_r1(:,1),data_r1(:,3),'r','EraseMode','background','LineWidth',1);
hndl12=plot(data_r2(:,1),data_r2(:,3),'b','EraseMode','background','LineWidth',1);
hndl13=plot(data_r3(:,1),data_r3(:,3),'b','EraseMode','background','LineWidth',1);
hndl14=plot(data_r4(:,1),data_r4(:,3),'b','EraseMode','background','LineWidth',1);
hndl15=plot(data_r5(:,1),data_r5(:,3),'g','EraseMode','background','LineWidth',1);
hndl16=plot(data_r6(:,1),data_r6(:,3),'b','EraseMode','background','LineWidth',1);
hndl17=plot(data_r7(:,1),data_r7(:,3),'b','EraseMode','background','LineWidth',1);
hndl18=plot(data_r8(:,1),data_r8(:,3),'b','EraseMode','background','LineWidth',1);
hndl19=plot(data_r9(:,1),data_r9(:,3),'g','EraseMode','background','LineWidth',1);
hndl20=plot(data_r10(:,1),data_r10(:,3),'b','EraseMode','background','LineWidth',1);
hndl21=plot(data_r11(:,1),data_r11(:,3),'b','EraseMode','background','LineWidth',1);
hndl22=plot(data_r12(:,1),data_r12(:,3),'b','EraseMode','background','LineWidth',1);
    set(gca,'UserData',hndl11);
    set(gca,'UserData',hndl12);
    set(gca,'UserData',hndl13);
    set(gca,'UserData',hndl14);
    set(gca,'UserData',hndl15);
    set(gca,'UserData',hndl16);
    set(gca,'UserData',hndl17);
    set(gca,'UserData',hndl18);
    set(gca,'UserData',hndl19);
    set(gca,'UserData',hndl20);
    set(gca,'UserData',hndl21);
    set(gca,'UserData',hndl22);

     plot(cos(theta)*r_earth,sin(theta)*r_earth,'b','LineWidth',1.5); %circle
     hndl18=plot(ObjectLengthAnim_r(:,1),ObjectLengthAnim_r(:,2),'r','EraseMode','background','LineWidth',2); %object
     hndl19=plot(0,0,'.','Color','c','EraseMode','none','LineWidth',0.1); %Tracking

%     set(gca,'UserData',hndl18);
%     set(gca,'UserData',hndl19);

    set(gca,'Color',[0.95 0.95 0.95]);
    inputs=6;
    sys=[0 0 0 inputs 0 0];
    x0=[];

elseif flag==2, %flag==2 : update
    if enable_video
        %   frame
        %    M

        %     M(frame)=getframe(findobj('Type','figure','Name','Space Animation'))  % video
              M(frame)=getframe(2);
              frame =frame +1;    % video
    end
          
    animhandle = findobj('Type','figure','Name','Space Animation');
    if any(get(0,'Children')==animhandle),
      if strcmp(get(animhandle,'Name'),'Space Animation'),
        	set(0,'currentfigure',animhandle);
         if enable_track_window
             window_jump=2;
             while  (u(1)-w_size(1)/20)<w_pos(1),	
                w_pos(1)=w_pos(1)-w_size(1)/window_jump;
             end
             while u(1)+w_size(1)/20>w_pos(1)+w_size(1),
                w_pos(1)=w_pos(1)+w_size(1)/window_jump;
             end
             while u(3)-w_size(1)/20<w_pos(2),	
                w_pos(2)=w_pos(2)-w_size(2)/window_jump;
             end
             while u(3)+w_size(1)/20>w_pos(2)+w_size(2),
                w_pos(2)=w_pos(2)+w_size(2)/window_jump;
             end
             axis([w_pos(1) w_pos(1)+w_size(1) w_pos(2) w_pos(2)+w_size(2)]); %axis([XMIN XMAX YMIN YMAX])
         else %zoom window
             window_jump=5;
             if  ((u(1)-w_size(1)/60))<w_pos(1),	
                        w_pos(1)=w_pos(1)-w_size(1)/window_jump;
                        w_size(1)=w_size(1)+0.85*w_size(1)/window_jump;
                        w_size(2)=w_size(1)/1.5;
             end
             if (u(1)+w_size(1)/60)>w_pos(1)+w_size(1),
                        w_size(1)=w_size(1)+0.85*w_size(1)/window_jump;
                        w_size(2)=w_size(1)/1.5;
             end
             if (u(3)-w_size(1)/60)<w_pos(2),	
                        w_pos(2)=w_pos(2)-w_size(2)/window_jump;
                        w_size(2)=w_size(2)+0.85*w_size(2)/window_jump;
                        w_size(1)=w_size(2)*1.5;
             end
             if (u(3)+w_size(1)/60)>w_pos(2)+w_size(2),
                        w_size(2)=w_size(2)+0.85*w_size(2)/window_jump;
                        w_size(1)=w_size(2)*1.5;
             end
         axis([w_pos(1) w_pos(1)+w_size(1) w_pos(2) w_pos(2)+w_size(2)]); %axis([XMIN XMAX YMIN YMAX])    
         end % zoom
        if enable_trajectory_track         
            plot(u(1),u(3),'.','Color','m','LineWidth',0.1);
        end
        
ObjectLengthAnim_r_r=ObjectLengthAnim_r*[cos(u(5)) -sin(u(5));
                     sin(u(5))  cos(u(5))];
            
            set(hndl18,'XData',ObjectLengthAnim_r_r(:,1)+u(1),'YData',ObjectLengthAnim_r_r(:,2)+u(3));          
%MARK       set(hndl19,'XData',u(1),'YData',u(3));
   
%   addpoints(get(findobj('Type','figure','Name','Space Animation'),'Number'),u(1),u(3));

      drawnow;
      end
    end
    sys=[];

% comment out the whole section if no video is recorded from here
elseif flag == 4 % Return next sample hit
    if enable_video
          % ns stores the number of samples
          ts=SimulationTimeStep;  
          ns = t/ts;
          % This is the time of the next sample hit.
          sys = (1 + floor(ns + 1e-13*(1+ns)))*ts;
        % comment out till here
    end
end;

% history
% 2018.4.9 window_x is replaced by w_pos(1)  
