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
for i=2:5
plot(log10(QvsC30(3:13,1)),log10(QvsC30(3:13,i)),'-*',LineWidth=0.5)
hold on
end
xlabel('log(Capacitance(F))');
ylabel('log(Q factor)');
legend('21cm 4.3E-4(H)','16cm 4.2E-4(H)','11cm 3.82E-4(H)',' 6cm 3.5E-4(H)');

%% error vs C
figure
for i=2:5
plot(log10(EvsC30(:,1)),EvsC30(:,i)*100,'x',LineWidth=2)
hold on
end
ylim([-100 100]);
xlabel('log(Capacitance(F))');
ylabel('Relative error(%)');
legend('21cm','16cm','11cm','6cm');

%% average error
figure
X1=["4.7e-07" "2.2e-07" "1e-07" "6.8e-08" "4.7e-08"];
Y1=transpose(mean(abs(EvsC30(:,2:5)),2)*100);
bar(X1,Y1);
xlabel('Capacitance(F)');
ylabel('Average Relative Error(%)');
title('Average Relative Error(%) of each Capacitor');
%% T vs W
figure
plot(Tvs2b(:,1),Tvs2b(:,2),'-*',LineWidth=2)
hold on
xlabel('Length(cm)');
ylabel('Period(us)');
title('Period vs Length change');

% T vs W theory

N=30;
l=0.015;
W=0.01:0.01:0.21;
b=W/2;
C=4.70E-07;
round=pi*0.21;
mu=(4.3E-4*l)/(N.^2*(pi*(0.21/2).^2));
T=2*pi*sqrt(C*mu*N.^2*(round*pi*b*0.25-(1-pi*0.5)*pi*b.^2)/l);
plot(W*1E2,T*1E6,'-*',LineWidth=2)

legend('measured','estimate');