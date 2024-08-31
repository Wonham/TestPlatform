function [ipr, pslr, intensity] = caliMerit(I, threshold)
% 标定指标计算，包括积分峰值比（IPR）和经典峰值旁瓣比（PSLR）
% I：输入的相机导出图像
% threshold：主瓣阈值
% intensity：远场一维灰度图，通过每列求最大值计算
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
offset = min(min(I));
edge = 1; % 相机边缘像素裁切, 默认guanyu cam为1像素
I = imgCut(I, edge);
intensity = grayFig(I);
intensity = intensity - offset;

ipr = sum(intensity(intensity>=threshold)) / sum(intensity);
pslr = 10*log10(max(intensity) / threshold);

%---
figure;
subplot(2,1,1);
imagesc(I);
% colorbar;
colormap("gray");
subplot(2,1,2);
plot(intensity);
hold on
xlim([1,length(intensity)]);
print('Result/光束标定质量测试.png','-dpng','-r300');
disp(['标定结果：主瓣能量占比：', num2str(ipr), '; PSLR：', num2str(pslr), 'dB']);
end