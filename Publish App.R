#Upload and Publish App

install.packages('rsconnect')
library(rsconnect)

rsconnect::setAccountInfo(name='kevin9605horrell',
                          token='4478893BE884CB276083C860557E6A94',
                          secret='WJfE3UoZrvCixIZlQ8QluPujhOWYFd8YnEUAwKQ8')

deployApp('R_HR Diagram/HR_Diagram/app.R')
