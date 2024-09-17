clc
data = xlsread("Cluster_Data_HDBSCAN.xlsx",4);

columnselector = 1;
slicing = 0.8;
windowSize = 4;
col = data(:,columnselector);
n = length(col);

%%
plot(col,'b','linewidth',2);
hold on;

for i = 1:(n-windowSize)
    % Select the window of data
    windowData = data(i:(i+windowSize-1));
    
    % Fit a linear regression model to the window of data
    % In this case, we're using the first three values in the window as predictors (X)
    % and the fourth value as the response (y)
    X = [ones(windowSize-1,1), (1:(windowSize-1))'];
    y = windowData(2:end);
    mdl = fitlm(X,y);
    
    output(i) = predict(mdl, [1, windowSize]);
end

n_output = size(output);
n_output = n_output(2);


xtrain = output(1:n_output*slicing);
xtest = output(n_output*slicing:n_output);
time_train = [1+windowSize:n_output*slicing+windowSize];
time_test = [n_output*slicing+windowSize:n_output+windowSize];

plot(time_test,xtest,'g','linewidth',2);
hold on;
plot(time_train,xtrain,'r','LineWidth',2);
legend('original','xtest','xtrain');
xlabel('time');
ylabel('concentration');
title('Regressive model fitting');

sliced_col = (col(n-n_output+1:n))';
rmse = sqrt(mean((sliced_col-output).^2));
fprintf('RMSE for model: %.4f\n',rmse);


