clc
cluster = xlsread("Cluster_Data_HDBSCAN.xlsx",4);
data = cluster(:,1);

alpha = 0.5; 
split_point = round(length(data) * 0.7);
train_data = data(1:split_point);
test_data = data(split_point+1:end);

smoothed_data = zeros(size(train_data));
smoothed_data(1) = train_data(1);
% Apply exponential smoothing on training data
for i = 2:length(train_data)
    smoothed_data(i) = alpha * train_data(i) + (1 - alpha) * smoothed_data(i-1);
end

% Predict test data
predicted_test_data = zeros(size(test_data));
predicted_test_data(1) = alpha * test_data(1) + (1 - alpha) * smoothed_data(end);
for i = 2:length(test_data)
    predicted_test_data(i) = alpha * test_data(i) + (1 - alpha) * predicted_test_data(i-1);
end

% Plot original training data and smoothed training data
figure;
plot(data, 'b','LineWidth',2);
hold on;
plot(smoothed_data, 'r','LineWidth',2);
hold on;
time = [339 - size(predicted_test_data) + 1 : 339];
plot(time,predicted_test_data,'g','LineWidth',2);
legend('Original Data', 'train','test');
title('Exponential Smoothing');


