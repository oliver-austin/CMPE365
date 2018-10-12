%CMPE365 Lab 2
%Oliver Austin - 20011458

function OliverAustin15oa16Lab2()
    % test values - to change test case adjust array elements, and right
    % and rightPart2 to match the number of elements in the array
    [left, leftPart2] = deal(1,1);
    [right, rightPart2] = deal(12,12);
    testArray = [100, 28, -12,-44,-1, 19, -5,10,100, 32, 99, 200];
    n = length(testArray);
     
    % array for storing max sum and bounds of segment
    segmentArray = [0,0,0,0];
    setSegmentArray(segmentArray); 
    
    maxSegmentSum = MSS(testArray, 1, n);
    fprintf('max segment sum: %d\n', maxSegmentSum);
    
    %get segment bounds
    segmentArray = getSegmentArray; 
    
    if  segmentArray(2) > left
        left = segmentArray(2);
    end
    
    if  segmentArray(3) < right
        right = segmentArray(3);
    end
    
    fprintf('elements of max segment sum within given left and right bounds: ');
    for i = left:+1:right
        fprintf('%d ', testArray(i));
    end
    fprintf('\n');
    
    % The following is part of the solution to question 2. Commented out to
    % allow solution to question 3 to run
    %{
    %setting max segment elements to zero to ensure they are not included in the second segment
    for j = segmentArray(2):segmentArray(3)
        testArray(j) = 0; 
    end
    %}
    % reinitialize segment array
    segmentArray = [0,0,0, segmentArray(1)];
    setSegmentArray(segmentArray);
    
    % find second max segment sum
    maxSegmentSum = MSS(testArray, 1, n);
    segmentArray = getSegmentArray;
    fprintf('2nd max segment sum: %d\n', segmentArray(1));
    
    % check that 2nd max segment sum bounds are within given left and right bounds
    if  segmentArray(2) > leftPart2
        leftPart2 = segmentArray(2);
    end
    if  segmentArray(3) < rightPart2
        rightPart2 = segmentArray(3);
    end
    
    fprintf('elements of 2nd max segment sum within given left and right bounds: ');
    for i = leftPart2:rightPart2
        fprintf('%d ', testArray(i));
    end
    fprintf('\n');
end

% function to find maximum segment sum recursively
function output = MSS(testArray, x, n)
  % if array is one element, return element
  if n == x
      output = testArray(n);
      return
  end
  
  m = floor((n + x)/2);
  % divide array and recursively call on each half
  output = max(MSS(testArray,x,m),MSS(testArray, m+1, n));
  
  segmentArray = getSegmentArray;
  if (segmentArray(1) < output && segmentArray(4) ~= output) && (output == sum(testArray(m+1:n)))
            setSegmentArray([output, m+1, n, segmentArray(4)]);
  end
  
  if (segmentArray(1) < output && segmentArray(4) ~= output) && (output == sum(testArray(x:m)))            
            setSegmentArray([output, x, m, segmentArray(4)]);
  end
  % check max segment sum of overlapping case    
  overlapSegment = maxSegmentSumOverlapping(testArray, m, n, x);
  output = max(output, overlapSegment(1));
  segmentArray = getSegmentArray;
  
  % if max segment sum of overlapping case is greater than current max, update current max segment
  if segmentArray(1) < output && segmentArray(4) ~= output
     setSegmentArray([output, overlapSegment(2), overlapSegment(3), segmentArray(4)]);
  end
end

% find max segment sum in case where segment overlaps division point
function output = maxSegmentSumOverlapping(testArray, m, n, b)
    sum = 0;
    leftSum = 0;
    left = m;
    
    % if current sum plus current element is greater than current sum,
    % update current sum and current segment
    for i = m:-1:b
        sum = sum + testArray(i);
        if sum >= leftSum
            leftSum = sum;
            left = i;
        end
    end
    sum = 0;
    rightSum = 0;
    right = m + 1;
    
    for i = m+1:1:n
        sum = sum + testArray(i);
        if sum >= rightSum
            rightSum = sum;
            right = i;
        end
    end
    output = [leftSum + rightSum, left, right];
    return
end

%helper to set segment array bounds
function setSegmentArray(val) 
    global segmentArray
    segmentArray = val;
end

%helper to get segment array bounds
function array = getSegmentArray 
    global segmentArray
    array = segmentArray;
end