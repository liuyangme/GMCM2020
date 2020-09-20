clc
clear

%加载文件
filename1 = '附件三处理完成.xlsx';
xlRange_file1_285 = 'B4:MQ43';
xlRange_file1_313 = 'B45:MQ53';
A = xlsread(filename1,xlRange_file1_285);
B = xlsread(filename1,xlRange_file1_313);

%奇异值检测
CheckRes_file1_285 = isoutlier(A,'mean');
CheckRes_file1_313 = isoutlier(B,'mean');

find(CheckRes_file1_285);
find(CheckRes_file1_313);




