clear; clc; 
rng(966)
% N = [10; 100; 1000];% ���Ż�����ά��
N = 2000;
Time = zeros(length(N), 8);% ����8�����ߵ���ʱ

Nit = 1e3;
%%
for i_N = 1:length(N)
    %% ��������A��x
    A = randn(N(i_N));
    A = A'*A;% ������
    x_ini = randn(N(i_N), 1);% ��ʼ�������
    %��һ��
    x_ini = x_ini/norm(x_ini);
    A = A/norm(A, 'fro');
    %% �̶�����(3�ֲ�ͬ�Ĳ���)
    step = [2; 1; 1e-1; 1e-2];
    f_Fixed = zeros(Nit, length(step));
    for i = 1:length(step)
        tic
        f_Fixed(:, i) = GD_FixedStep(Nit, A, x_ini, step(i));
        Time(i_N, i) = toc;        
    end
    %% Armijo-Goldstein׼��
    rho = 5e-1;% ��ĳ���һ��̩��չ����Ӧ��ֱ������ƫˮƽһЩ
    alpha_ini = [2, 5, 5];
    
    tic
    f_AG = GD_AG(Nit, rho, alpha_ini(i_N), A, x_ini);
    Time(i_N, 5) = toc; 
    %% Wolfe-Powell׼��
    rho = 5e-1;% ��ĳ���һ��̩��չ����Ӧ��ֱ������ƫˮƽһЩ
    alpha_ini = [2, 5, 5];
    sigma = 0.5;
    x = x_ini;
    count = 1;
    count_max = 20;
    const = 1.2;
    
    tic
    f_WP = GD_WP(Nit, rho, alpha_ini(i_N), A, x, sigma, count, count_max, const);
    Time(i_N, 6) = toc;
    %% ���Ų���(�Բ�����=0)
    tic
    f_opt = GD_Opt(Nit, A, x_ini);
    Time(i_N, 7) = toc;
    %% Zhuoran׼��(�Ա�)
    rho = 5e-1;% ��ĳ���һ��̩��չ����Ӧ��ֱ������ƫˮƽһЩ
    sigma = [0.01 0.5 0.5];
    count = 1;
    count_max = 20;
    alpha_ini = [1 1 2];
    
    tic
    f_ZR = GD_ZR(Nit, rho, alpha_ini(i_N), sigma(i_N), count, count_max, A, x_ini);
    Time(i_N, 8) = toc;
    %% ��ͼ
    set(0,'defaultfigurecolor','w') 
    figure; hold on; box on; grid on;
    set(gca,'FontSize',10);
    xlabel('��������');
    ylabel('log_{10}(Ŀ�꺯��)');
    text = ['�Ż�����ά�ȣ�N = ' num2str(N(i_N))];
    title(text)
    plot(log10(f_Fixed(:, 1)),'r-', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_Fixed(:, 2)),'r--', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_Fixed(:, 3)),'r-.', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_Fixed(:, 4)),'k:', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_AG),'g:', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_opt),'m:', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_WP),'b-', 'LineWidth', 1.5,'MarkerSize',10);
    plot(log10(f_ZR),'m-', 'LineWidth', 1.5,'MarkerSize',10);
    legend({  
        ['�̶����� step=' num2str(step(1)) ' | ��ʱ' num2str(Time(i_N, 1)) 's'],...
        ['�̶����� step=' num2str(step(2)) ' | ��ʱ' num2str(Time(i_N, 2)) 's'],...
        ['�̶����� step=' num2str(step(3)) ' | ��ʱ' num2str(Time(i_N, 3)) 's'],...
        ['�̶����� step=' num2str(step(4)) ' | ��ʱ' num2str(Time(i_N, 4)) 's'],...
        ['Armijo-Goldstein' ' | ��ʱ' num2str(Time(i_N, 5)) 's'],...
        ['��ʼ�ݶ��µ����Ų���'  ' | ��ʱ' num2str(Time(i_N, 6)) 's'],...
        ['Wolfe-Powell'  ' | ��ʱ' num2str(Time(i_N, 7)) 's'],...
        ['Zhuoran'  ' | ��ʱ' num2str(Time(i_N, 8)) 's']})
end