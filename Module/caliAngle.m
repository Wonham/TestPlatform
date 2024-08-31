function [theta] = caliAngle(I, cam_pitch, cam_unit_x, f)
% 输出标定系统实际角度，默认参考0°点在相机靶面中心
% theta：计算出的实际标定角度deg
% I：相机图像，光强分布
% cam_pitch：相机像素pitch
% cam_unit_x：x方向相机像素单元数
% f：透镜焦距
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
% --- 图像预处理
edge = 1; % 相机边缘像素裁切, 默认guanyu cam为1像素
I = imgCut(I, edge);

[~, ~, col_index] = findPeaks2D(I);
pixel = col_index - cam_unit_x/2;
theta = rad2deg(atan(pixel * cam_pitch / f));

disp(['标定结果的实际角度为：', num2str(theta), 'deg']);
end