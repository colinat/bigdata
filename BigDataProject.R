
library(tidyverse)

AMD = read_csv("https://api.worldtradingdata.com/api/v1/history?symbol=AMD&api_token=FM972fUftGH8ORkrsmlt31W2P9zW3DhfjUPJ2Qu0m1FuCVRm6tes40KqhQ8W&output=csv")
MSFT = read_csv("https://api.worldtradingdata.com/api/v1/history?symbol=MSFT&api_token=FM972fUftGH8ORkrsmlt31W2P9zW3DhfjUPJ2Qu0m1FuCVRm6tes40KqhQ8W&output=csv")
AAPL = read_csv("https://api.worldtradingdata.com/api/v1/history?symbol=AAPL&api_token=FM972fUftGH8ORkrsmlt31W2P9zW3DhfjUPJ2Qu0m1FuCVRm6tes40KqhQ8W&output=csv")
INTC = read_csv("https://api.worldtradingdata.com/api/v1/history?symbol=INTC&api_token=FM972fUftGH8ORkrsmlt31W2P9zW3DhfjUPJ2Qu0m1FuCVRm6tes40KqhQ8W&output=csv")
CSCO = read_csv("https://api.worldtradingdata.com/api/v1/history?symbol=CSCO&api_token=FM972fUftGH8ORkrsmlt31W2P9zW3DhfjUPJ2Qu0m1FuCVRm6tes40KqhQ8W&output=csv")

glimpse(AMD)

stockdata = tibble(code = c("AMD", "MSFT", "AAPL", "INTC", "CSCO"), list(AMD, MSFT, AAPL, INTC, CSCO)) %>%
  unnest()

stockdata = stockdata %>% arrange(desc(Date), code)

glimpse(stockdata)

write.csv(stockdata, "stockdata.csv")
