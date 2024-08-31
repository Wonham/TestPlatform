function [max_val,row_index,col_index] = findPeaks2D(input)
% find peak and its location of a 2d matrix
% ---------------------------INFO---------------------------------
%                       _      ____ __
%                      | | /| / / // /
%                      | |/ |/ / _  / 
%                      |__/|__/_//_/  
% 
%  Version: 1.0 | Date: 2024-08-31
%  Author: https://github.com/Wonham | wanghan201@mails.ucas.ac.cn
% ----------------------------------------------------------------
[max_val, row_index] = max(max(input, [], 2));
[~, col_index] = max(input(row_index, :));
end