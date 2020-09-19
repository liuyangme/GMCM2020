clc
clear
filename1 = '附件三处理完成.xlsx';
% filename2 = '附件一处理完成.xlsx';
xlRange_file1_285 = 'B4:MQ43';
xlRange_file1_313 = 'B45:MQ53';
% xlRange_file2 = 'Q4:NF330';

A = xlsread(filename1,xlRange_file1_285);
B = xlsread(filename1,xlRange_file1_313);
% C = xlsread(filename2,xlRange_file2);

CheckRes_file1_285 = isoutlier(A,'mean');
CheckRes_file1_313 = isoutlier(B,'mean');
% CheckRes_file2 = isoutlier(C,'mean');

find(CheckRes_file1_285);
find(CheckRes_file1_313);




