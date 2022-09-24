library (tseries)
library(zoo)
library (forecast)
library (lmtest)
library(uroot)
library(nortest)

data <-read.csv("temperature_dataset_JJuny.csv", sep=",")
head(data)

Temperature <- data$TEMPERATURE
Time <- data$TIME

ts.plot(Temperature)
adf.test(Temperature)

differencing <- diff(Temperature, differences = 1)
differencing

ts.plot(differencing)
adf.test(differencing)

par(mfrow=c(1,2))
acf(differencing, lag.max=40)
pacf(differencing, lag.max=40)

#acf(differencing, lag.max=10)
#pacf(differencing, lag.max=10) maybe ARIMA(0, 1, 2)

#Try to use ARIMA (0, 1, 2)
fit1 <-arima (differencing, order=c(0,1,2), method="ML")
fit1

#Diagnostic Checking 
#1. Uji kesignifikanan parameter: Uji t
coeftest(fit1)

#2. pengujian residual apakah white noise 
Box.test(fit1$residuals, type="Ljung")

#3. Residual berdistribusi normal test
shapiro.test(fit1$residuals)

#   Shapiro-Francia normality test
sf.test(fit1$residuals)

#   Anderson-Darling normality test
ad.test(fit1$residuals)

#   Lilliefors (Kolmogorov-Smirnov) normality test
lillie.test(fit1$residuals)

# Forecasting untuk 12 tahap ke depan
forecasting <-forecast(Temperature, model=fit1, h=12)
forecasting


