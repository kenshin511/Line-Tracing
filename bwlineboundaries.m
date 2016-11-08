function y = bwlineboundaries(BW1)
%*************************************
%* ���� : bwlineboundaries(BW1)
%* ���� : ��輱 �ȼ��� ã�´�.
%* �˸� : ���۱�ǥ��
%*************************************
% �Է��� ���� ����(binary)���� �ϸ�
% ������ �����Ͽ� copy(BW, Label)�ϸ� ���̺�(Label)�� �̹����� �����Ѵ�.
Label = BW1;

% B�� Ʈ���̵̽� ���� �ȼ��� ��ǥ���� ����Ǵ� (����� �ȼ� ��) x 2�� �迭�̴�.
% B(r_n, c_n), n = number of contour pixels
startP = [1 1];
nO = 1; % number of object, label ��, y{nO}

while(1)
    B = zeros(50, 2); % �迭 �ʱ�ȭ
    tmp = zeros(50, 2); % tmp( : , 2) �ʱ�ȭ,
    k = 0; % idx, tmp(k++, : )
    % s�� �������� ã��(startPoint)�� ���� �˻��� ���۵Ǵ� ù��° �ε���(r, c)�� ��Ÿ����.
    % startPoint�� �ԷµǴ� ������ s�� ������ �˻� ���������κ��� ���� �˻��� ��������
    % �����ȴ�. s(n) -> s(n+1)��
    % starPoint(label, s) �Լ��� ���� Ʈ���̽��� �����ϱ� ���� ������ ù��° �ε����� ã�� �۾��̴�.
    % ���� ��ܿ� �ִ� �ȼ��� ã�� ��ǥ(r, c)�� ��ȯ�Ѵ�.
    % s: �˻��� ������ ��ǥ �ʱ�ȭ(1, 1)
    startP = startPoint(Label, startP);
    
    % ����Ʈ���̽��� ���󿡼� �������� �� �̻� ������� ���� �� ���� ����ȴ�.
    % �������� ���̻� ������ s�� �� ���([ ])�� ��ȯ�ϸ�,
    % �Ʒ� ���ǹ��� ���Ͽ� ������� ��ȯ�Ǹ�, ����Ʈ���̽��� ����(T=0)�Ѵ�.
    T = 1; % while(T)
    if(isempty(startP)) % ��������
        T = 0;
        break;
    end
    
    % B�� ù��° �࿡�� ������ s�� �Է��Ѵ�. B(1, : ) <- start point
    % i�� B(i++, :)�� �ε����� ���� �ȼ��� ����� �� ���� �� ��ǥ ����(i++)�ϸ�
    % ����� �ȼ��� ��ǥ(r, c)�� ������� �����Ѵ�.
    B(1, : ) = startP;
    Label(startP(1), startP(2)) = nO+1;
    i = 2; % idx, B(i++, : )
    
    %% line Tracing
    % ����Ʈ���̽��� ���۵Ǵ� �κ��̴�.
    % ����Ʈ���̽��� �ð����(clockwise)�� �ݽð����(anticlockwise)����
    % ���� �ѹ��� ����ȴ�.
    % clock�� search8neighbor(Label, crntP, dir, clock)�� ���Ⱚ���� �ԷµǸ�,
    % clock 0�� �ð����, 1�� �ݽð������ ����Ų��.  for clock <- 0 to 1
    for clock = 0 : 1
        
        %% search8neighbor
        % search8neighbor(Label, crntP, dir, clock)��
        % BW ����, ������ǥ(crntP), ���۹���(dir), �ð�,�ݽð����(clock)���� �Է¹޾�
        % ������ǥ(crntP)�� �ֺ��̿�ȭ�Ҹ� ���۹���(dir)���� clock �� �������� �˻��Ѵ�.
        % crntP ���۰��� ������(startP)�� �Է��ϸ�, ������ 1(dir <- 3)�� �Ѵ�.
        crntP = startP; % crntP: ���� ��ǥ(current point)
        dir = 3; % 3 -> 1
        
        % tmp�� �˻��� �ֺ�ȭ�� p[n]�� p[n+1] �ȼ� ��ǥ(���� 1�� ���)�� ����Ǵ� �迭�̴�.
        % tmp ����Ʈ���̽̿��� ���� ������ �����ϴµ� ���ȴ�.
        
        % �Ʒ� figure �κ��� Ȱ��ȭ�ϸ� ����Ʈ���̽��� �ϴ� ���� �ǽð����� ���������ϴ�.
        figure, imshow(Label); hold on
        plot(startP(2), startP(1), 'or');
        
        % ���� ������ ������ �� ����, �ֺ�ȭ�Ҹ� ã���� ���� Ʈ���̽��� ����Ѵ�.
        % ���� ���� T�� ������ ����
        while(T)
            % idx�� �ֺ�ȭ���� ��ǥ �迭�̸�, nN�� �˻��� �ֺ�ȭ���� �ε����� ��Ÿ����.
            [idx nN] = search8neighbor(Label, crntP, dir, clock);
            
            % idx(nN, : )�� �˻��� �ֺ�ȭ���� ��ǥ�� ��Ÿ����,
            % tmp1�� ��ǥ�� �����Ų��.
            % tmp2�� idx(nN+1)�� ���� �����Ű�� �������ǿ� ���ȴ�.
            tmp1 = idx(nN, : );
            tmp2 = idx(nN+1, : );
            
            % p(n+1)���� 1, �� ȭ�Ұ� �����ϸ� tmp�� p(n+1) ���� �����Ѵ�.
            if(Label(tmp2(1), tmp2(2)))
                k = k + 1;
                tmp(k, : ) = tmp2;
            end
            
            %% ���� ����
            % 2���� ���� ����
            % 1. p[n]�� B�� ���Ե� ��� - �̹� ����� �ȼ��� ����� ���
            if(isInArr(B, tmp1, i)) % condition 1
                break; % teminate the loop
            end
            
            % 2. p[n]�� tmp�� ���Ե� ��� - �̹� ����� �ֺ� �ȼ�(p[n+1])�� ����� ���
            if(isInArr(tmp, tmp1, k)) % condition 2
                break; % teminate the loop
            end
            
            % ���� �ȼ�(crntP)�� ���� �ȼ�(tmp1)���� �Ҵ� - ����� �ȼ����� �ٽ� �ֺ� �ȼ� �˻��� �ݺ���
            % dir�� ����� �ε����� ��ȯ��, dir[nN]���� ���� ���� ����
            crntP = tmp1;
            dir = nN;
            
            %% ��� �Ҵ�
            % �迭 B�� ���� �ȼ� ���� �Ҵ� - contour �ȼ��� �Ҵ���
            B(i, : ) = crntP;
            
            % ���̺�: Label(������ǥ) <- ���̺� ���� �Ҵ���
            
            i = i + 1;
            
            plot(tmp1(2), tmp1(1), 'ob');
            drawnow; % pause(1)
        end
        
        % �ֺ� �ȼ��� �ð����(clock = 0)���� �˻��Ͽ����� ���� ������ ������(flipud)
        % contour�� ��ǥ�� �������(���γ����� ��) ������ �ϱ� ����
        
        if (clock == 0)
            B(1:i-1, : ) = flipud(B(1:i-1, : )); % ����� �����Ͽ� ����
        end
        
        % �迭 B�� ���� ���Ҵ�
        if i > 50;
            B(50:100, 1:2) = zeros(50, 2);
        end
        
    end
    
    % ����� ����, contour�� ��ǥ(r_n, c_n)
    for n = 1 : i -1
        Label(B(n, 1), B(n, 2)) = 0;
    end
    
   for n = 1 : k
        Label(tmp(n, 1), tmp(n, 2)) = 0;
    end
    
    y{nO} = B(1:i-1, : );
    nO = nO + 1;
    clear B;
end
