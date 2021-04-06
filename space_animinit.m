function figNumber=space_animinit(namestr)
%ANIMINIT Initializes a figure for Simulink animations.

if (nargin == 0)
  namestr = 'Simulink Animation';
end

[existFlag,figNumber]=figflag(namestr);
    
if ~existFlag,
  % Now initialize the whole figure...
  position=[20 50 550*1.7+50 550+50];
  figNumber=figure( ...
       'Name',namestr, ...
       'NumberTitle','off', ...
       'BackingStore','off', ...
       'Position',position);
  axes( ...
       'Units','normalized', ...
       'Position',[0.05 0.05 0.95 0.95], ...
       'Visible','on');

end

cla reset;
set(gca,'DrawMode','fast');
axis on;
