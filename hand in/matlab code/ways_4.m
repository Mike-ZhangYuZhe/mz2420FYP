clc,clear,close all
%% loading
% 获取当前目录中的所有 .mat 文件
matFiles = dir('*.mat');

% 检查是否找到 .mat 文件
if isempty(matFiles)
    disp('No .mat files found in the current directory.');
else
    % 循环遍历每个 .mat 文件
    for k = 1:length(matFiles)
        % 获取文件名
        fileName = matFiles(k).name;
        
        % 显示正在导入的文件
        fprintf('Importing %s...\n', fileName);
        
        % 加载 .mat 文件到工作空间
        load(fileName);
        
        % 可选：根据文件名处理数据
        % 例如，假设文件名没有扩展名
        [~, name] = fileparts(fileName);
        
        % 显示已导入的变量
        disp(['Variables imported from ', fileName, ':']);
        whos('-file', fileName);
    end
    
    disp('All .mat files have been successfully imported.');
end

%% Q vs C
figure
plot(log10(QvsC4(:,1)),log10(QvsC4(:,2)),'-*',LineWidth=2)
xlabel('log(Capacitance(F))');
ylabel('log(Q factor)');
legend('22cm');
title('Q factor')

%% error vs C
plot(log10(EvsC4(1:5,1)),EvsC4(1:5,2)*100,'x',LineWidth=2)

ylim([-100 100]);
xlabel('log(Capacitance(F))');
ylabel('Relative error(%)');
ylim([-100 0])
legend('22cm 1.2E-5(H)');
title('Relative error when testing for different capacitor');


%% T vs W
figure
plot(Tvs2b4(:,1),Tvs2b4(:,2),'-*',LineWidth=2)
hold on
xlabel('Length(cm)');
ylabel('Period(us)');
title('Period vs Length change');