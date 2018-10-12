function lab1(n)
    breakValueHits = zeros(50000,2);
	knownBreaks = [];
    newBreaks = [];
    j = 1;
    iterations = [];
    x = [];
    S = [];
	for i = 2:n
        x(i)=i;
		[iterations(i), newBreaks, breakValueHits]  = collatz(i, knownBreaks, breakValueHits);
        knownBreaks = cat(2, knownBreaks, newBreaks);
        j = j+1;
        S(i) = sum(iterations);
    end
end

function [y, breakValues, breakValueHits] = collatz(x, knownBreaks, breakValueHitsTemp)
    iterations = 0;
    i = 1;
    previousValues=[];
	while x ~= 1
        if x<50000
        breakValueHitsTemp(x,2) = breakValueHitsTemp(x,2) + 1;
        breakValueHitsTemp(x,1) = x;
        previousValues(i) = x;
        i = i+1;
        end
        if (ismember(x,knownBreaks) == 1)
        break
        end
		if not(mod(x,2))
			x = x/2;
        else
			x = 3*x +1;
        end
        iterations = iterations+1;
    end
    y = iterations;
    breakValues = previousValues;
    breakValueHits = breakValueHitsTemp;
end