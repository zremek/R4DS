#https://upload.wikimedia.org/wikipedia/commons/e/ea/Asymptote02_vectorial.svg

przecina_asymptote <- data.frame(t = seq.int(from = 0.01, to = 100, by = 0.001))
n <- length(przecina_asymptote$t)
przecina_asymptote$x <- przecina_asymptote$t + cos(przecina_asymptote$t * n) / przecina_asymptote$t
przecina_asymptote$y <- przecina_asymptote$t + sin(przecina_asymptote$t * n) / przecina_asymptote$t
ggplot(przecina_asymptote, aes(x, y)) + geom_path()
ggplot(przecina_asymptote, aes(x, y)) + geom_point(size = 0.5, alpha = 0.5)
