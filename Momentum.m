%% Assignement 1 FINE 452
% Matthieu Fouilloux, 261082501
% Giulia Gambaretto, 261103315

%% 1 - Import Data

crsp = readtable("crsp20042008.csv" );

%% 2 - Add Datenum, Year, And Month

% Convert DateOfObservation to MATLAB datenum format
date2str = num2str(crsp.DateOfObservation); % Convert numbers to strings
crsp.datenum = datenum(date2str, 'yyyymmdd'); % Convert strings to datenums
crsp.year = year(crsp.datenum); % Extract year
crsp.month = month(crsp.datenum); % Extract month



%% 3 - Write Function For Momentum
% at the bottom of the script


%% 4 - Calculate Momentum

% Initialize crsp.momentum with NaN values
crsp.momentum = NaN(height(crsp), 1);
permnos = unique(crsp.PERMNO);

% Loop to calculate momentum for each stock
for i = 1:height(crsp)
    thisPermno = crsp.PERMNO(i);
    thisYear = crsp.year(i);
    thisMonth = crsp.month(i);
    crsp.momentum(i) = getMomentum(thisPermno, thisYear, thisMonth, crsp);
end




%% 5 - Calculate Momentum Returns

% Extract unique dates
uniqueDates = unique(crsp.DateOfObservation);
momentum = table(uniqueDates, 'VariableNames', {'DateOfObservation'});

% Convert unique dates to datenum format
date2str2 = num2str(uniqueDates);
momentum.datenum = datenum(date2str2, 'yyyymmdd');
momentum.year = year(momentum.datenum);
momentum.month = month(momentum.datenum);



% Initialize columns for the momentum returns
momentum.mom1 = NaN(height(momentum), 1); % Preallocate with NaNs

% Calculate daily momentum returns for each unique date
for i = 1:length(uniqueDates)
    currentDate = uniqueDates(i);
    
    % Get the daily momentum values for the current date
    dailyMomentum = crsp.momentum(crsp.DateOfObservation == currentDate);
    
    if ~isempty(dailyMomentum)
        % Calculate the 10th percentile to determine bottom decile
        p10 = quantile(dailyMomentum, 0.1);
        
        % Identify stocks in the bottom decile
        bottom_stocks = crsp.DateOfObservation == currentDate & ...
        crsp.momentum <= p10;
        
        % Calculate the equal-weighted return for bottom decile stocks
        momentum.mom1(i) = mean(crsp.Returns(bottom_stocks), 'omitnan');
        % Calculate mean, omitting NaNs
    end
    if ~isempty(dailyMomentum)    
        % Calculate the 90th percentile to determine upper decile
        p90 = quantile(dailyMomentum, 0.9);
        
        % Identify stocks in the bottom decile
        top_stocks = crsp.DateOfObservation == currentDate & ...
            crsp.momentum >= p90;
        
        % Calculate the equal-weighted return for top decile stocks
        momentum.mom10(i) = mean(crsp.Returns(top_stocks), 'omitnan'); 
        % Calculate mean, omitting NaNs
    end
end

momentum.mom = momentum.mom10 - momentum.mom1;

%% 6 - Calculate Cumulative Returns

momentum.cumulativeRet(1) = 0;
% initialize cumulative returns with 0 for the first entry

for i = 2:height(momentum)
    if isnan(momentum.mom(i))
       momentum.cumulativeRet(i) = 1;
    elseif momentum.cumulativeRet(i-1)~=0
       momentum.cumulativeRet(i) = momentum.cumulativeRet(i-1).*(1+ ...
           momentum.mom(i));
    elseif momentum.cumulativeRet(i-1) == 0
       momentum.cumulativeRet(i) = 1+momentum.mom(i);
    end  
end
momentum.cumulativeRet(2:end) = momentum.cumulativeRet(2:end) -1


plot(momentum.cumulativeRet)

 


%% Function for Momentum

function momentum = getMomentum(thisPermno, thisYear, thisMonth, crsp)
    StartYear = thisYear - 1;
    StartMonth = thisMonth;
    if StartMonth == 1
        EndMonth = 12;
        EndYear = thisYear - 1;
    else
        EndYear = thisYear;
        EndMonth = thisMonth - 1;
    end

    EndPrice = crsp.adjustedPrice(crsp.year == EndYear & crsp.month == ...
        EndMonth & crsp.PERMNO == thisPermno);
    StartPrice = crsp.adjustedPrice(crsp.year == StartYear & crsp.month ...
        == StartMonth & crsp.PERMNO == thisPermno);
    
    if isempty(StartPrice) || isempty(EndPrice) || length(StartPrice) ...
        > 1 || length(EndPrice) > 1
        momentum = NaN;
    else
        momentum = (EndPrice / StartPrice) - 1; % Calculate return
    end
end