function [power_input,power_output,loss] = powerTest(mode)
% OPA 最大耐受功率&全链路损耗测试，可切换测试模式
% 'equal'：等间距测试
% 'unequal'：非等间距测试
% 'load'：从工作区变量导入
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
default_mode = 'equal'; % 默认模式为等间距

if nargin < 1
    mode = default_mode;
end

switch mode
    case 'equal'
        power_num = input('请输入要功率测试的采样点数目：');
        power_range = input('请输入测试的最大功率范围（W）：');

        power_interval = power_range / power_num;
        power_input = power_interval:power_interval:power_range;
        power_output = zeros(1, power_num);

        for i = 1:power_num
            power_output(i) = input(['第',num2str(i),'个测试点，输入功率为',num2str(power_input(i)),'W时，对应输出功率(W)：']);
        end

    case 'unequal'
        power_num = input('请输入要功率测试的采样点数目：');
        power_input = zeros(1, power_num);
        power_output = zeros(1, power_num);

        for i = 1:power_num
            power_input(i) = input(['第',num2str(i),'个测试点，输入功率(W)为:']);
            power_output(i) = input(['第',num2str(i),'个测试点，对应输出功率(W)：']);
        end

    case 'load'
        power_input_char = input('测试输入（W）变量名为（一维向量）：','s');
        power_output_char = input('测试输出（W）变量名为（一维向量）：','s');
        power_input = evalin('base', power_input_char);
        power_output = evalin('base', power_output_char);
end

loss = -10*log10(power_output./power_input);

figure;
subplot(2,1,1);
plot(power_input,power_output);
title('功率测试曲线')
xlabel('input(W)')
ylabel('output(W)')

subplot(2,1,2);
plot(power_input,loss);
title('损耗测试曲线')
xlabel('input(W)')
ylabel('loss(dB)')
for i = 2:length(loss)
    if loss(i) - loss(i-1) >= 3
        thres = i-1;
        hold on;
        plot(power_input(thres),loss(thres),'hexagram');
        legend('损耗曲线','损伤阈值');
        disp(['功率损伤阈值为：',num2str(power_input(thres)),'(W)']);
        break;
    end
end
print('Result/耐受功率与损耗测试.png','-dpng','-r300');
end