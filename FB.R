library(tidyverse)
library(tidytext)
library(tm)
library(wordcloud)
library(udpipe)
library(lattice)
#Stemming packages
library(SnowballC)
#library(hunspell)
#library(proustr)



fb = read.csv("C:\\Users\\ashle\\Downloads\\fb_reviews_csv.csv", header = TRUE)
colnames(fb)

fb= fb %>% 
  gather(pros, cons, key = "review_sentiment", value = "review",-heading)
summary(fb$review_sentiment)

fbreviews = fb%>%

  select(review,review_sentiment)

fbreviews$review= as.character(fbreviews $review)

 

tidy_dataset = fbreviews %>%

  unnest_tokens(word, review)

tidy_dataset %>%

  count(word) %>%

  arrange(desc(n))

colnames(tidy_dataset)


data("stop_words")

tidy_dataset2 = tidy_dataset %>%

  anti_join(stop_words)

 

### Compare the count of top words from above ###

tidy_dataset2 %>%

  count(word) %>%

  arrange(desc(n))

patterndigits = '\\b[0-9]+\\b'

 

tidy_dataset2$word = tidy_dataset2$word %>%

  str_replace_all(patterndigits, '')


tidy_dataset2$word = tidy_dataset2$word %>%

  str_replace_all('[:space:]', '')

 

tidy_dataset3 = tidy_dataset2 %>%

  filter(!(word == ''))

 

tidy_dataset3 %>%

  count(word) %>%

  arrange(desc(n))



tidy_dataset4 = tidy_dataset3 %>%

  mutate_at("word", funs(wordStem((.), language="en")))

 

tidy_dataset4 %>%

  count(word) %>%

  arrange(desc(n))


frequency2 = tidy_dataset4 %>%

  count(word) %>%

  arrange(desc(n)) %>%

  mutate(proportion = (n / sum(n)*100)) %>%

  filter(proportion >= 0.5)

 

ggplot(frequency2, aes(x = proportion, y = word)) +

  geom_abline(color = "gray40", lty = 2) +

  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +

  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +

  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +

  theme(legend.position="none") +

  labs(y = 'Word', x = 'Proportion')


positive = tidy_dataset4 %>%

  filter(sentiment == "pros")

 

wordcloud(positive[,2],

          max.words = 100,

          random.order=FALSE,

          rot.per=0.30,

          use.r.layout=FALSE,

          colors=brewer.pal(9, "Greens"))


positive2 = positive %>%

  count(word, sort = TRUE) %>%

  rename(freq = n) %>%

  top_n(21)

 

colourCount = length(unique(positive2$word))

getPalette = colorRampPalette(brewer.pal(9, "Set1"))

positive2 %>%

  mutate(word = reorder(word, freq)) %>%

  ggplot(aes(x = word, y = freq)) +

  geom_col(fill = getPalette(colourCount)) +

  coord_flip()

negative = tidy_dataset4 %>%

  filter(sentiment == "cons")

 

wordcloud(negative[,2],

          max.words = 100,

          random.order=FALSE,

          rot.per=0.30,

          use.r.layout=FALSE,

          colors=brewer.pal(9, "Reds"))
 
negative2 = negative %>%

  count(word, sort = TRUE) %>%

  rename(freq = n) %>%

  top_n(21)

 

colourCount = length(unique(negative2$word))

 

getPalette = colorRampPalette(brewer.pal(8, "Dark2"))

 

negative2 %>%

  mutate(word = reorder(word, freq)) %>%

  ggplot(aes(x = word, y = freq)) +

  geom_col(fill = getPalette(colourCount)) +

  coord_flip()
 
nrc_joysad = get_sentiments('nrc') %>%

  filter(sentiment == 'joy' |

           sentiment == 'sadness')

 

nrow(nrc_joysad)

 

(tweet_joysad = tidy_dataset4 %>%

  inner_join(nrc_joysad,by='word') %>%

  count(word, sentiment) %>%

  spread(sentiment, n, fill = 0) %>%

  mutate(contentment = joy - sadness, linenumber = row_number()) %>%

  arrange(desc(contentment)))


(tweet_joysad2 = tweet_joysad %>%

    slice(1:10,24:34))

 

ggplot(tweet_joysad2, aes(x=linenumber, y=contentment, fill=word)) +

  coord_flip() +

  theme_light(base_size = 15) +

  labs(

    x='Index Value',

    y='Contentment'

  ) +

  theme(

    legend.position = 'bottom',

    panel.grid = element_blank(),

    axis.title = element_text(size = 10),

    axis.text.x = element_text(size = 10),

    axis.text.y = element_text(size = 10)

  ) +

  geom_col()




nrc_trstfear = get_sentiments('nrc') %>%

  filter(sentiment == 'trust' |

           sentiment == 'fear')

 

nrow(nrc_trstfear)

 

(tweet_trstfear = tidy_dataset4 %>%

  inner_join(nrc_trstfear) %>%

  count(word, sentiment) %>%

  spread(sentiment, n, fill = 0) %>%

  mutate(trustworthy = trust - fear, linenumber = row_number()) %>%

  arrange(desc(trustworthy))%>% 
  slice(1:10,53:63))

 

ggplot(tweet_trstfear, aes(x=linenumber, y=trustworthy, fill=word)) +

  coord_flip() +

  theme_light(base_size = 15) +

  labs(

    x='Index Value',

    y='Trustworthiness'

  ) +

  theme(

    legend.position = 'bottom',

    panel.grid = element_blank(),

    axis.title = element_text(size = 10),

    axis.text.x = element_text(size = 10),

    axis.text.y = element_text(size = 10)

  ) +

  geom_col()

 

 
