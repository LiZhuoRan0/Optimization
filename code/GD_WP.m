function f = GD_WP(Nit, rho, alpha_ini, A, x, sigma, count, count_max, const)
f = zeros(Nit, 1);
for i_it = 1:Nit
    f(i_it) = Quadratic(A, x);
    alpha = alpha_ini;
    nabla = Nabla(A, x);
    while Quadratic(A, x-alpha*nabla) >  (Quadratic(A, x)+alpha*rho*nabla) 
        alpha = alpha/2;
    end
    if abs(Nabla_a(A, x - alpha*nabla, alpha)) < sigma*abs(Nabla_a(A, x, 0))% ����Ҫ����ֱ���·�����Ҫ�����ݶ�(��alpha)�ľ���ֵ��С
        alpha = alpha;
    else
        if sign(Nabla_a(A, x - alpha*nabla, alpha))*sign(Nabla_a(A, x, 0)) == -1 % ��2���ݶ����1���ݶ��෴
            alpha = alpha/const;
            while abs(Nabla_a(A, x - alpha*nabla, alpha)) > sigma*abs(Nabla_a(A, x, 0))     
                if count > count_max
                    break;
                end
                if sign(Nabla_a(A, x - alpha*nabla, alpha))*sign(Nabla_a(A, x, alpha)) == -1
                    alpha = alpha/const;
                else
                    alpha = alpha*const;
                end
                count = count + 1;
            end
        else
            alpha = alpha*const;
            while abs(Nabla_a(A, x - alpha*nabla, alpha)) > sigma*abs(Nabla_a(A, x, 0))
                if count > count_max
                    break;
                end
                if sign(Nabla_a(A, x - alpha*nabla, alpha))*sign(Nabla_a(A, x, 0)) == -1
                    alpha = alpha/const;
                else
                    alpha = alpha*const;
                end
                count = count + 1;
            end
        end
    end
    x = x - alpha*nabla;
    count = 1;
end
end