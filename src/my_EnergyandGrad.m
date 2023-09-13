function [ek_m,gk_Ck_m] = my_EnergyandGrad(mode_point,data_point,constuct_data_point,Ck,Attributes_matrix,grad_en,lamd,std_d,pra3,pra4,pra5)
%   -1- mode_point,data_point,constuct_data_point,Ck,tk,Attributes_matrix,max_cost_i,min_cost_i,std_cost,lamd
%	mode_point:                            ��׼�㼯, 2*n, ��һ��Ϊˮƽ���꣬�ڶ���Ϊ��ֱ����
%   data_point:                            ���ݵ㼯, 2*m, ��һ��Ϊˮƽ���꣬�ڶ���Ϊ��ֱ����
%   constuct_data_point:                   ����ķ����Է���任���ݾ���
%   Ck:                                    ���ڿռ�任�Ĳ�������nc*1
%   Attributes_matrix:                     ��׼�㼯�����ݵ㼯�����е�֮�������ֵ��n*m
%   std_a:                                 Attributes_matrix��Ӧ�ı�׼��
%   std_d:                                 ��׼�㼯�����ݵ㼯�����е�֮��ŷ�������Ӧ�ı�׼��
%   pra3 = 0;
%   pra4 = 0;
    %lamd = 0.02;
    N_mode = length(mode_point);
    N_data = length(data_point);
    Ak = my_affine_matrix(Ck,pra3,pra4,pra5);
%     mapk = exp((-1 .* (Attributes_matrix).^2) ./ (2 * std_a^2));
    mapk = Attributes_matrix;
    ek_m = 0;gk_Ck_m = 0;
%     for imode = 1 : N_mode
%         for jdata = 1 : N_data
%             part1 = constuct_data_point(jdata,:) * Ak - [mode_point(:,imode)',1];%�ռ�任
%             ek_m_i = mapk(imode,jdata) .* exp(-1 .* (part1(1)^2 + part1(2)^2) ./ (std_d^2));
%             %ek_m_i = exp(-1 .* (part1(1)^2 + part1(2)^2) ./ (std_d^2));
%             ek_m = ek_m + ek_m_i;
%             if(grad_en == 1)
%                 partial_derivative_matrix = my_affine_partial_derivative_matrix(Ck,data_point(:,jdata),pra3,pra4,pra5); 
%                 gk_Ck_m_i = 2 .* partial_derivative_matrix * part1' .* ek_m_i ./ (std_d^2);
%                 gk_Ck_m = gk_Ck_m + gk_Ck_m_i;
%             end            
%         end
%     end
   for imode = 1 : N_mode
            part1 = constuct_data_point(imode,:) * Ak - [mode_point(:,imode)',1];%�ռ�任
            ek_m_i = exp(-1 .* (part1(1)^2 + part1(2)^2) ./ (std_d^2));
            %ek_m_i = exp(-1 .* (part1(1)^2 + part1(2)^2) ./ (std_d^2));
            ek_m = ek_m + ek_m_i;
            if(grad_en == 1)
                partial_derivative_matrix = my_affine_partial_derivative_matrix(Ck,data_point(:,imode),pra3,pra4,pra5); 
                gk_Ck_m_i = 2 .* partial_derivative_matrix * part1' .* ek_m_i ./ (std_d^2);
                gk_Ck_m = gk_Ck_m + gk_Ck_m_i;
            end            
    end
    
    I_stable = zeros(length(Ck),1);I_stable(2) = 1;I_stable(3) = 1;
    dif_stable = Ck - I_stable;
    ek_m = -1 .* ek_m  + lamd .* trace(dif_stable * dif_stable');
    if(grad_en == 1)
        gk_Ck_m = gk_Ck_m + 2 .* lamd .* dif_stable;
    end
    






%     -1-
%     pra = 1e-4;
%     Ak = my_affine_matrix(Ck,pra);
%     Sk = (max_cost_i - min_cost_i) .* exp(-1 .* (tk.^2)) + min_cost_i;
%     gkSk_array = zeros(size(Sk));
%     N_mode = length(mode_point);
%     N_data = length(data_point);
%     w_match = zeros(N_mode,N_data);
%     ek = 0;gk = 0;
%     for imode = 1 : length(mode_point(1,:))
%             gk_Sk_r = 0;
%             for jdata = 1 : length(data_point(1,:))
%                 part1 = constuct_data_point(jdata,:) * Ak - [mode_point(:,imode)',1];
%                 w_match(imode,jdata) = exp(-1 .* (cost_sc_i(imode,jdata) - Sk(imode,1))^2 ./ (2 * std_cost^2));
%                 eki = w_match(imode,jdata) .* (part1(1)^2 + part1(2)^2);
%                 partial_derivative_matrix = my_affine_partial_derivative_matrix(Ck,data_point(:,jdata),pra);      
%                 gki = 2 .* w_match(imode,jdata) .* partial_derivative_matrix * part1';
%                 gki_Sk = 2 * tk(imode,1) * exp(-1 * (tk(imode,1)^2)) * (max_cost_i(imode,1) - min_cost_i(imode,1)) * ...
%                          (Sk(imode,1) - cost_sc_i(imode,jdata)) * eki ./ (std_cost^2);
%                 ek = ek + eki;
%                 gk = gk + gki;
%                 gk_Sk_r = gk_Sk_r + gki_Sk;
%             end
%             gkSk_array(imode,1) = gk_Sk_r;
%     end
%     I_stable = zeros(length(Ck),1);I_stable(2) = 1;I_stable(3) = 1;
%     dif_stable = Ck - I_stable;
%     ek = ek + lamd .* trace(dif_stable * dif_stable');
%     gk = gk + 2 .* lamd .* dif_stable;
%     gkSk_array = gkSk_array + 2 .* 0 .* Sk;

end

