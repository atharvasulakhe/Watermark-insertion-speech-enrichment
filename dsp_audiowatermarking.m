clc
clear
close all 
[host, f] = audioread ('host.wav'); 
dt=1/f;
t = 0:dt:(length(host)*dt)-dt; 
subplot(1,2,1);
plot(t,host);
title('Original Audio')
host      = uint8(255*(host + 0.5));
wm        = imread('watermark.png');  
[r, c]    = size(wm);               
wm_l      = length(wm(:))*8;         
if length(host) < (length(wm(:))*8)
    disp('Lower the nuber of pixels in the image');
else
host_bin  = dec2bin(host, 8);       
wm_bin    = dec2bin(wm(:), 8);        
wm_str    = zeros(wm_l, 1);           
for j = 1:8                           
for i = 1:length(wm(:))
ind   = (j-1)*length(wm(:)) + i;
wm_str(ind, 1) = str2double(wm_bin(i, j));
end
end

for i     = 1:wm_l                                  
host_bin(i, 8) = dec2bin(wm_str(i)); % Least Significant Bit (LSB)
end 

host_new  = bin2dec(host_bin);       % watermarked host
host_new  = (double(host_new)/255 - 0.5);   
subplot(1,2,2)
plot(t,host_new) 
title('Watermarked Audio')

audiowrite('host_new.wav', host_new, f)     
end