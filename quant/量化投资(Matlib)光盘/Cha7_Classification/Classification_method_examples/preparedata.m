% Copyright 2014 The MathWorks, Inc.

% Variable Names
names = bank.Properties.VariableNames;

% Convert Categorical Data into Nominal Arrays
% Remove unnecessary double quotes from certain attributes
bank = removequotes(bank);

% Convert all the categorical variables into nominal arrays
[nrows, ncols] = size(bank);
category = false(1,ncols);
for i = 1:ncols
    if isa(bank.(names{i}),'cell') || isa(bank.(names{i}),'categorical')
        category(i) = true;
        bank.(names{i}) = categorical(bank.(names{i}));
    end
end
% Logical array keeping track of categorical attributes
catPred = category(1:end-1);

% Response
Y = bank.y;

% Predictor matrix
X = table2array(varfun(@double,bank(:,1:end-1)));

% Cross Validation
cv = cvpartition(height(bank),'holdout',0.40);

% Training set
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% Test set
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

disp('Training Set')
tabulate(Ytrain)
disp('Test Set')
tabulate(Ytest)

% Prepare Predictors/Response for Neural Networks
[XtrainNum, YtrainNum, XtestNum, YtestNum] = preparedataNum(bank, catPred, cv);