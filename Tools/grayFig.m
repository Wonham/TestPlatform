function [intensity] = grayFig(img)
% gray figure of the input img
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
intensity = zeros(1,length(img));
for i = 1 : length(img)
    intensity(i) = max(img(:,i));
end

% figure;
% plot(intensity)
% xlim([1,length(intensity)])
end