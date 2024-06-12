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
for i=2:7
plot(log10(QvsC(:,1)),log10(QvsC(:,i)),'-*',LineWidth=2)
hold on
end
xlabel('log(Capacitance(F))');
ylabel('log(Q factor)');
legend('100mH','47mH','10mH','4.7mH','2.2mH','0.1mH');
title('Q factor');
%% error vs C
figure
for i=2:7
plot(log10(ErrorvsC(:,1)),ErrorvsC(:,i)*100,'x',LineWidth=2)
hold on
end
ylim([-100 100]);
xlim([-9.5 -5.5]);
xlabel('log(Capacitance(F))');
ylabel('Relative error(%)');
legend('100mH','47mH','10mH','4.7mH','2.2mH','0.1mH');
title('Relative error when testing for different capacitor');
%% average error vs C
figure
X1=["1e-06" "4.7e-07" "2.2e-07" "1e-07" "6.8e-08" "4.7e-08" "2.2e-08" "1e-08" "4.7e-09" "2.2e-09" "1e-09"];
Y1=transpose(mean(abs(ErrorvsC(:,2:7)),2)*100);
bar(X1,Y1);
xlabel('Capacitance(F)');
ylabel('Average Relative Error(%)');
title('Average Relative Error(%) for each Capacitor');

%% ploy fit for C=4.7e-07
figure
plot(log10(QvsL(:,1)),ErrorvsC(2,2:7)*100,'x',LineWidth=2)
ylim([-100 100]);
xlabel('log(inductance(H))');
ylabel('Relative error(%)');
title('polyfit when C=4.7e-07');
hold on
p = polyfit(Lmeasured(:,2),ErrorvsC(2,2:7),2);
x1=linspace(QvsL(6,1),QvsL(1,1));
%x1=linspace(1e-6,0.1);
y1 = polyval(p,x1);

plot(log10(x1),y1*100)
hold off

E_estimate=25.5258*(Lmeasured(:,2).^2)-4.5846*Lmeasured(:,2) +0.3356;
L_regressed=Lmeasured(:,2)./(1+E_estimate);
E_new=(L_regressed-Lmeasured(:,1))./Lmeasured(:,1);

X2=["0.1" "0.047" "0.01" "0.0047" "0.0022" "0.001"];
Y2=zeros([6 2]);
Y2(:,1)=ErrorvsC(2,2:7);
Y2(:,2)=E_new;
figure
bar(X2,Y2*100);
ylim([-50 50])
xlabel('Inducntance(H)');
ylabel('Relative Error(%)');
legend('L direct calculated', 'L linear regressed');
title('Comparison between direct calculated L and regressed L when C=4.7e-07');