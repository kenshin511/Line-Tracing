function y = bwlineboundaries(BW1)
%*************************************
%* 파일 : bwlineboundaries(BW1)
%* 목적 : 경계선 픽셀을 찾는다.
%* 알림 : 저작권표시
%*************************************
% 입력은 이진 영상(binary)으로 하며
% 영상을 복사하여 copy(BW, Label)하며 레이블링(Label)된 이미지를 생성한다.
Label = BW1;

% B는 트레이싱된 라인 픽셀의 좌표들이 저장되는 (검출된 픽셀 수) x 2의 배열이다.
% B(r_n, c_n), n = number of contour pixels
startP = [1 1];
nO = 1; % number of object, label 값, y{nO}

while(1)
    B = zeros(50, 2); % 배열 초기화
    tmp = zeros(50, 2); % tmp( : , 2) 초기화,
    k = 0; % idx, tmp(k++, : )
    % s는 시작점을 찾기(startPoint)를 위해 검색이 시작되는 첫번째 인덱스(r, c)를 나타낸다.
    % startPoint에 입력되는 시작점 s는 이전의 검색 시작점으로부터 다음 검색시 시작점이
    % 설정된다. s(n) -> s(n+1)이
    % starPoint(label, s) 함수는 라인 트레이싱을 시작하기 위한 라인의 첫번째 인덱스를 찾는 작업이다.
    % 왼쪽 상단에 있는 픽셀을 찾아 좌표(r, c)를 반환한다.
    % s: 검색의 시작점 좌표 초기화(1, 1)
    startP = startPoint(Label, startP);
    
    % 라인트레이싱은 영상에서 시작점이 더 이상 검출되지 않을 때 까지 수행된다.
    % 시작점이 더이상 없으면 s는 빈 행렬([ ])를 반환하며,
    % 아래 조건문에 의하여 빈행렬이 반환되면, 라인트레이싱을 종료(T=0)한다.
    T = 1; % while(T)
    if(isempty(startP)) % 종료조건
        T = 0;
        break;
    end
    
    % B의 첫번째 행에는 시작점 s를 입력한다. B(1, : ) <- start point
    % i는 B(i++, :)의 인덱스로 라인 픽셀이 검출될 때 마다 행 좌표 증가(i++)하며
    % 검출된 픽셀의 좌표(r, c)를 순서대로 저장한다.
    B(1, : ) = startP;
    Label(startP(1), startP(2)) = nO+1;
    i = 2; % idx, B(i++, : )
    
    %% line Tracing
    % 라인트레이싱이 시작되는 부분이다.
    % 라인트레이싱은 시계방향(clockwise)와 반시계방향(anticlockwise)으로
    % 각각 한번씩 수행된다.
    % clock은 search8neighbor(Label, crntP, dir, clock)에 방향값으로 입력되며,
    % clock 0은 시계방향, 1은 반시계방향을 가리킨다.  for clock <- 0 to 1
    for clock = 0 : 1
        
        %% search8neighbor
        % search8neighbor(Label, crntP, dir, clock)은
        % BW 영상, 현재좌표(crntP), 시작방향(dir), 시계,반시계방향(clock)값을 입력받아
        % 현재좌표(crntP)의 주변이웃화소를 시작방향(dir)부터 clock 값 방향으로 검색한다.
        % crntP 시작값은 시작점(startP)를 입력하며, 방향은 1(dir <- 3)로 한다.
        crntP = startP; % crntP: 현재 좌표(current point)
        dir = 3; % 3 -> 1
        
        % tmp는 검색된 주변화소 p[n]의 p[n+1] 픽셀 좌표(만일 1일 경우)가 저장되는 배열이다.
        % tmp 라인트레이싱에서 종료 조건을 결정하는데 사용된다.
        
        % 아래 figure 부분을 활성화하면 라인트레이싱을 하는 것을 실시간으로 관찰가능하다.
        figure, imshow(Label); hold on
        plot(startP(2), startP(1), 'or');
        
        % 종료 조건을 만족할 때 까지, 주변화소를 찾으며 라인 트레이싱을 계속한다.
        % 종료 조건 T는 시작점 없음
        while(T)
            % idx는 주변화소의 좌표 배열이며, nN은 검색된 주변화소의 인덱스를 나타낸다.
            [idx nN] = search8neighbor(Label, crntP, dir, clock);
            
            % idx(nN, : )은 검색된 주변화소의 좌표를 나타내며,
            % tmp1에 좌표를 저장시킨다.
            % tmp2는 idx(nN+1)의 값을 저장시키며 종료조건에 사용된다.
            tmp1 = idx(nN, : );
            tmp2 = idx(nN+1, : );
            
            % p(n+1)값이 1, 즉 화소가 존재하면 tmp에 p(n+1) 값을 저장한다.
            if(Label(tmp2(1), tmp2(2)))
                k = k + 1;
                tmp(k, : ) = tmp2;
            end
            
            %% 종료 조건
            % 2개의 종료 조건
            % 1. p[n]이 B에 포함된 경우 - 이미 검출된 픽셀이 검출된 경우
            if(isInArr(B, tmp1, i)) % condition 1
                break; % teminate the loop
            end
            
            % 2. p[n]이 tmp에 포함된 경우 - 이미 검출된 주변 픽셀(p[n+1])이 검출된 경우
            if(isInArr(tmp, tmp1, k)) % condition 2
                break; % teminate the loop
            end
            
            % 현재 픽셀(crntP)을 검출 픽셀(tmp1)으로 할당 - 검출된 픽셀에서 다시 주변 픽셀 검색을 반복함
            % dir에 검출된 인덱스를 반환함, dir[nN]으로 시작 방향 설정
            crntP = tmp1;
            dir = nN;
            
            %% 결과 할당
            % 배열 B에 현재 픽셀 값을 할당 - contour 픽셀을 할당함
            B(i, : ) = crntP;
            
            % 레이블링: Label(현재좌표) <- 레이블링 값을 할당함
            
            i = i + 1;
            
            plot(tmp1(2), tmp1(1), 'ob');
            drawnow; % pause(1)
        end
        
        % 주변 픽셀을 시계방향(clock = 0)으로 검색하였으면 행의 순서를 반전함(flipud)
        % contour의 좌표가 순서대로(라인끝에서 끝) 들어가도록 하기 위함
        
        if (clock == 0)
            B(1:i-1, : ) = flipud(B(1:i-1, : )); % 행렬을 반전하여 넣음
        end
        
        % 배열 B의 공간 재할당
        if i > 50;
            B(50:100, 1:2) = zeros(50, 2);
        end
        
    end
    
    % 결과값 리턴, contour의 좌표(r_n, c_n)
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
