
% 测试平台运行脚本，注释掉不需要的测试模块直接运行即可
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
clearvars
close all
clc

addpath('Module');
addpath('Tools');
diary('Result/测试结果.txt');
disp('------------------------------------------')
disp(datetime('now'))

%--- 功率损耗测试
powerTest();

%--- 数据导入
I = importfile('I0.txt');

%--- 标定角度差测试
cam_pitch = 15e-6;
f = 100e-3;
cam_unit_x = 640;

[theta] = caliAngle(I, cam_pitch, cam_unit_x, f);

%--- 光束标定质量测试
threshold = 800;

[ipr, pslr, intensity] = caliMerit(I, threshold);

%--- 光斑质量测试
threshold_2 = 3600;

[theta_x, theta_y, quality] = spotMerit(I, threshold_2);

%---
diary off;