
clc,clearvars
data = xlsread("Cluster_Data_HDBSCAN.xlsx",4);

 
columnselector = 2;


split = 0.8;
col = data(:,columnselector);
%
figure(1);
subplot(2,1,1);
autocorr(col);
[acf,lags] = autocorr(col);
n = size(acf);

q = 4;
for i = 2:n(1)
    if abs(acf(i) - acf(i-1)) < 0.01
          q = lags(i)
          break
    end
end

%ARIMA model is not working for column no. in x therfore i am taking q = 0
%for AR model
x = [31 34 35 37 46 47 48 50];
for i = 1:8
    if(columnselector == x(i))
        q = 0;
        break;
    end
end



% Plot the sample PACF
subplot(2,1,2);
parcorr(col);
[pacf,lags2]=parcorr(col);

n = size(pacf);
for i = 2:n(1)
        if (abs(pacf(i))) < 0.01
            p = lags2(i)+2
            break
        end
end

%%
figure(2)
plot(col,'b','linewidth',2);
hold on;
xtrain = col(1:339*split);
xtest = col(split*339:339);
sz = size(xtest);

Mdl = arima(p,0,q);


EstMdl = estimate(Mdl,xtrain);


residuals = infer(EstMdl,xtest);

residuals2 = infer(EstMdl,xtrain);

% Calculate the fitted values
fitted = xtest + residuals;
fitted2 = xtrain + residuals2; 


time=[339-sz(1) + 1:339];
plot(time,fitted,'g','LineWidth',2);
hold on;
plot(fitted2,'r','LineWidth',2);
xlabel('time');
ylabel('concentration');
title('ARIMA model fitting')
legend('original','test','trained');


% rmse of xtrain and xtest
rmse = sqrt(mean(residuals.^2));
rmse2 = sqrt(mean(residuals2.^2));

% Display RMSE
fprintf('RMSE for xtrain: %.4f\n',rmse);
fprintf('RMSE for xtest: %.4f\n',rmse2);

%
% AR model
model_AR = ar(col,p);
figure(3)
predicted = predict(model_AR,xtest);
predicted2 = predict(model_AR,xtrain);
time=[339-sz(1) + 1:339];
plot(col,'b','LineWidth',2); 
hold on;
plot(time,predicted,'g','LineWidth',2); 
hold on;
plot(predicted2,'r','LineWidth',2);
legend('Original Data','xtest','xtrain');
title('AR Model Fitting');

rmse_AR = sqrt(mean((xtest - predicted).^2));
rmse_AR2 = sqrt(mean((xtrain - predicted2).^2));
fprintf('RMSE for AR model xtest: %.4f\n',rmse_AR);
fprintf('RMSE for AR model xtrain: %.4f\n',rmse_AR2);
 