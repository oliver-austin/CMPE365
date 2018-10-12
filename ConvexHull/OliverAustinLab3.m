function output = Lab3(size)
    %Comment/uncomment below lines to invoke solution to each problem
    output = Lab3Part1(size);
    %output = Lab3Part2(size);
    %output = Lab3Part3(size);
    %output = Lab3Part4(size);
end

function averageRatio = Lab3Part1(size)
    for i=1:size
        j=100*i;
    set=[rand(1,j); rand(1,j)]; %generate set of points between 0 and 1
    sortedSet = sortCCW(set); %sort sets in CCW order by polar coordinates
    ch = graham_scan(sortedSet); %calculate convex hull
    ratio(i) = (length(ch)/j);
    end
    scatter(1:size, ratio)
    xlabel("Size of set (*10^2)");
    ylabel("Ratio of convex hull to size of set");
    averageRatio = mean(ratio); 
end

function averageRatio = Lab3Part2(size)
    for i=1:size
        j=100*i;
    set=[normrnd(0,10,[1,j]); normrnd(0,10,[1,j])]; %generate set of points between 0 and 1
    sortedSet = sortCCW(set); %sort sets in CCW order by polar coordinates
    ch = graham_scan(sortedSet); %calculate convex hull
    ratio(i) = (length(ch)/j);
    end
    scatter(1:size, ratio)
    xlabel("Size of set (*10^2)");
    ylabel("Ratio of convex hull to size of set");
    averageRatio = mean(ratio); 
end

function intersect = Lab3Part3(size)
    setA=[rand(1,size); rand(1,size)]; %generate set of points between 0 and 1
    sortedSetA = sortCCW(setA); %sort sets in CCW order by polar coordinates
    chA = graham_scan(sortedSetA); %calculate convex hull
    
    setB=[rand(1,size); rand(1,size)]; %generate set of points between 0 and 1
    sortedSetB = sortCCW(setB); %sort sets in CCW order by polar coordinates
    chB = graham_scan(sortedSetB); %calculate convex hull
    
    boundingCircleA = boundingCircle(chA); % generate bounding circles for convex hulls
    boundingCircleB = boundingCircle(chB);
    intersectionPoint = circcirc(boundingCircleA(1), boundingCircleA(2), boundingCircleA(3), boundingCircleB(1), boundingCircleB(2), boundingCircleB(3)); %check if bounding circles intersect
    intersectTemp = (isnan(intersectionPoint));
    intersect = ~(intersectTemp(1) || intersectTemp(2));
end

function intersect = Lab3Part4(size)
    setA=[rand(1,size); rand(1,size)]; %generate set of points between 0 and 1
    sortedSetA = sortCCW(setA); %sort sets in CCW order by polar coordinates
    chA = graham_scan(sortedSetA); %calculate convex hull
    
    setB=[rand(1,size); rand(1,size)]; %generate set of points between 0 and 1
    sortedSetB = sortCCW(setB); %sort sets in CCW order by polar coordinates
    chB = graham_scan(sortedSetB); %calculate convex hull
    
    
    xA = chA(1,:); % create vectors of x and y coordinates of each convex hull
    yA = chA(2,:);
    xB = chB(1,:);
    yB = chB(2,:);
    
    
    intersectionPoint = polyxpoly(xA,yA,xB,yB); % check if edges of convex hulls intersect
    intersectTemp = (isempty(intersectionPoint));
    intersect = ~(intersectTemp(1));
    end

function boundingCircle = boundingCircle(ch)
    % find mean position of coordinates
    centre = mean(ch,2);
    % find furthest point in convex hull from centre coordinate
    for i=1:length(ch)
        distance(i)=sqrt((ch(1,i)-centre(1))^2 + (ch(2,i)-centre(2))^2);
    end
    radius = max(distance);
    boundingCircle = [centre(1), centre(2), radius];
end

function ch = graham_scan(set)
convexHullTemp=[set(:,1), set(:,2)];
for i=3:length(set)
    convexHullTemp = [convexHullTemp, set(:,i)];
    %calculate angle at P3 from P2 to P1, if negative, angle is obtuse.
       while length(convexHullTemp)>2
        angle = cross(([convexHullTemp(1,end), convexHullTemp(2,end), 0]-[convexHullTemp(1,end-2), convexHullTemp(2,end-2), 0]), ([convexHullTemp(1,end-1), convexHullTemp(2,end-1), 0]-[convexHullTemp(1,end-2), convexHullTemp(2,end-2), 0]));
        if angle < 0
            display("here");
        end
        if angle >=0 % not a left turn
            convexHullTemp(:,end-1) = [];
        else
            break
        end
    end
end
ch = convexHullTemp;
end

function sortedSet = sortCCW(set)
for i=1:length(set) % create x and y vectors for set of coordinates
    x(i) = set(1,i);
    y(i) = set(2,i);
end
[~, P1Index] = min(y); % find P1, the coordinate with the lowest y-value
P1 = [x(P1Index), y(P1Index)];
x(P1Index)=[]; % remove P1 from the set of coordinates
y(P1Index)=[];
for i=1:length(x) % calculate angles between P1 and all coordinates
    angles(i) = atan2(y(i)-P1(2), x(i)-P1(1));
end

[~, order] = sort(angles); % sort set of coordinates in CCW order from P1
x = x(order);
y = y(order);
sortedSet = [P1(1), x; P1(2), y];
end

