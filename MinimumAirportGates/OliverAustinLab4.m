function gates = lab4()
    % the input files were edited to test both data sets
    departures = csvread('finish1.csv'); 
    arrivals = csvread('start1.csv');
    
    % ensure both sets are in ascending order
    departures = sort(departures);
    arrivals = sort(arrivals);
    
    % uncomment / comment following lines to test each part of lab
    %gates = part1(departures, arrivals);
    gates = part2(departures, arrivals);
end

function gates = part1(departures, arrivals)
    maxPlanes = 0; % store maximum number of planes at airport at any given time
    currentPlanes = 0; % store maximum number of planes currently at airport
    
    % iterate through departure and arrival vectors until reaching the end of the arrivals vector
    departureCounter = 1;
    arrivalCounter = 1;
    while(arrivalCounter ~= length(arrivals))
        % if the next flight is a departure
        if(departures(departureCounter) < arrivals(arrivalCounter))
            currentPlanes = currentPlanes - 1;
            departureCounter = departureCounter + 1;
            
        % if the next flight is an arrival    
        else
            currentPlanes = currentPlanes + 1;
            arrivalCounter = arrivalCounter + 1;
        end

        if maxPlanes < currentPlanes
            maxPlanes = currentPlanes;
        end
    end
    gates = maxPlanes;
end

function output = part2Helper(departures, arrivals, maxDelay)
    lateDivisor = 1/maxDelay; % to calculate delay randomly using inputted maxDelay
    n = length(arrivals);
    fractionLate = rand;
    numberLate = fractionLate*n;
    
    % track which flights were delayed to ensure a delay is not added to an already delayed flight
    lateFlights = [];
    for i=1:floor(numberLate)
        % select random flight to delay
        randIndex = randi(n);
        % if the flight has already been delayed, select a new flight
        while(any(ismember(randIndex, lateFlights)))
            randIndex = randi(n);
        end
        lateFlights = [lateFlights, randIndex];
        
        % calculate random delay on arrival and departure of a flight
        randomDepartureDelay = rand/lateDivisor;
        randomArrivalDelay = rand/lateDivisor;
        
        arrivals(randIndex) = arrivals(randIndex) + randomArrivalDelay; % delay arrival
        while((departures(randIndex) + randomDepartureDelay) - (arrivals(randIndex)) < 0.167) % ensure time between arrival and departure is greater than ten minutes
            randomDepartureDelay = rand/lateDivisor; % if less than ten minutes, calculate a new departure delay
        end
        departures(randIndex) = departures(randIndex) + randomDepartureDelay; % delay departure
    end
    gates = part1(departures, arrivals);
    output = [fractionLate; gates];
end

function output = part2(departures, arrivals)
    % store array of values for each maximum delay time
    quarterHourSeries = [];
    halfHourSeries = [];
    threequarterHourSeries = [];
    hourSeries = [];
    % calculate 100 values for each series
    for i=1:100
        quarterHourSeries = [quarterHourSeries, part2Helper(departures, arrivals, 0.25)];
        halfHourSeries = [halfHourSeries, part2Helper(departures, arrivals, 0.5)];
        threequarterHourSeries = [threequarterHourSeries, part2Helper(departures, arrivals, 0.75)];
        hourSeries = [hourSeries, part2Helper(departures, arrivals, 1)];
    end

    % plot data
    point25 = 0.25*ones(100);
    point5 = 0.5*ones(100);
    point75 = 0.75*ones(100);
    one = ones(100);
    scatter3(point25(1,:), quarterHourSeries(1,:), quarterHourSeries(2,:));
    ylabel('Fraction of flights delayed');
    xlabel('Maximum delay');
    zlabel('Number of gates required');
    xticks([0 0.25 0.5 0.75 1]);
    hold on
    scatter3(point5(1,:), halfHourSeries(1,:), halfHourSeries(2,:));
    scatter3(point75(1,:), threequarterHourSeries(1,:), threequarterHourSeries(2,:));
    scatter3(one(1,:), hourSeries(1,:), hourSeries(2,:));
    hold off
    output = 0;
end