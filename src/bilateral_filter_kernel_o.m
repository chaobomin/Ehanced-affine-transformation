function W = bilateral_filter_kernel(I,P,centra_i,centra_j,r,thda_s,thda_r)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%              I--���뵼��ͼ����ԭͼ��
%              P--���˲�ͼ��
%              centra_i,centra_j--���ڣ�������������
%              r--���ڣ����򣩰뾶
%              thda_s,thda_r--���ڿռ��ǿ�ȷֲ��Ĳ���
%              W--�ô��ڣ������е��˲��˽��
    I_w = zeros((2 * r + 1),(2 * r + 1));
    P_w = zeros((2 * r + 1),(2 * r + 1));
    w = zeros((2 * r + 1),(2 * r + 1));
    ww = zeros((2 * r + 1),(2 * r + 1));
    I = double(I);
    for i = 1 : (2 * r + 1)
        for j = 1 : (2 * r + 1)      
            I_w(i,j) = I((centra_i - r + i - 1),(centra_j - r + j - 1));
            P_w(i,j) = P((centra_i - r + i - 1),(centra_j - r + j - 1));
            w(i,j) = round(10000 .* exp(-1 .* (((centra_i - r + i - 1) - centra_i).^2 + ((centra_j - r + j - 1) - centra_j).^2) ./ (thda_s.^2)))...
            .* round(10000 .* exp(-1 .* ((I_w(i,j)./255 - I(centra_i,centra_j)./255).^2) ./ (thda_r.^2)));
            ww(i,j) = round(w(i,j) ./ 10000);
        end
    end
    if (sum(ww(:)) == 0)
        W = 0;
    else
        ws = sum(ww(:));
        wp = ww./ws;
        W_t = wp .* P_w./255;
        W = sum(W_t(:)); 
    end
    
       
end

