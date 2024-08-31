function [theta_x, theta_y, quality] = spotMerit(I, threshold_2)
% 光斑质量测试模块
% I：相机图像，光强分布
% threshold_2：二值化阈值，也可理解为所取主瓣阈值
% theta_x(_y)：主瓣光斑发散角，mrad
% quality：根据光斑能量距质心离散度定义的质量指标Q因子
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
I = imgCut(I, 1);

%---
I_edge=imbinarize(I,threshold_2); % 二值化过滤噪声
% I = bwmorph(I,'open'); % 开运算消减噪声

% 进行边缘检测
edges = edge(I_edge, 'Canny');

    % 查找轮廓
    [B, ~] = bwboundaries(edges, 'noholes');

    I_temp = I;
    I(~I_edge)=0;

    for k = 1:length(B)
        boundary = B{k};
    end

    %---
    left = min(boundary(:,2));
    right = max(boundary(:,2));
    bottom = max(boundary(:,1));
    top = min(boundary(:,1));

    %---
    theta_x = atan((right-left) * 15e-6 / 100e-3) / 1e-3; %mrad
    theta_y = atan((bottom-top) * 15e-6 / 100e-3) / 1e-3;

    %---
    I_mainlobe = I;
    I_mainlobe(bottom:end, :) = [];
    I_mainlobe(1:top, :) = [];
    I_mainlobe(:, right:end) = [];
    I_mainlobe(:, 1:left) = [];

    I_mainlobe_normalized = I_mainlobe / sum(sum(I_mainlobe));

    temp_x = zeros(size(I_mainlobe_normalized, 1), size(I_mainlobe_normalized, 2));
    temp_y = zeros(size(I_mainlobe_normalized, 1), size(I_mainlobe_normalized, 2));
    temp_q = zeros(size(I_mainlobe_normalized, 1), size(I_mainlobe_normalized, 2));

    for i1 = 1:size(I_mainlobe_normalized, 1)
        for j = 1:size(I_mainlobe_normalized, 2)
            temp_x(i1,j) = j * I_mainlobe_normalized(i1,j);
            temp_y(i1,j) = i1 * I_mainlobe_normalized(i1,j);
        end
    end

    xc = sum(sum(temp_x));
    yc = sum(sum(temp_y));

    for i1 = 1:size(I_mainlobe_normalized, 1)
        for j = 1:size(I_mainlobe_normalized, 2)
            temp_q(i1,j) = sqrt((j-xc)^2 + (i1 - yc)^2) * I_mainlobe_normalized(i1,j);
        end
    end

    quality = sum(sum(temp_q));

    %---
    figure;
    imagesc(I_mainlobe);
    colorbar;
    hold on
    plot(xc, yc, 'r*');
    hold off
    print('Result/光斑质量测试结果_主瓣图像.png','-dpng','-r300');
    
    figure;
    imagesc(I_temp);
    hold on;
    for k = 1:length(B)
        plot(boundary(:,2), boundary(:,1),'r', 'LineWidth', 1.5);
    end
    hold off;
    
    % figure;
    % imagesc(I);
    colorbar;
    % colormap("gray");
    print('Result/光斑质量测试结果.png','-dpng','-r300');
    disp(['光斑质量指标Q-factor：', num2str(quality)]);
    disp(['横向发散角', num2str(theta_x), 'mrad；纵向发散角：', num2str(theta_y), 'mrad'])
end