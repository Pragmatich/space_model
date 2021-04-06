function []= MakeVideo(name)
% clear global M
% M=getframe(2)

global M

video=VideoWriter(name,'MPEG-4')
% video=VideoWriter(name,'Motion JPEG AVI')
% video=VideoWriter(name,'Uncompressed AVI')
open(video)
writeVideo(video,M)
close(video)
 
end