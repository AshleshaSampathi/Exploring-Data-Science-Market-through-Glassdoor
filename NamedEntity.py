# -*- coding: utf-8 -*-
"""
Created on Wed Nov 27 22:53:41 2019

@author: ashle
"""

import pandas as pd
import numpy as np
import os
import requests
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import nltk
from nltk.stem import PorterStemmer
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('maxent_ne_chunker')
nltk.download('words')
from nltk import word_tokenize, pos_tag, ne_chunk
from nltk.chunk import conlltags2tree, tree2conlltags

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

from wordcloud import WordCloud, STOPWORDS 
import matplotlib as plt 


mc_data = pd.read_excel(r'C:\Users\ashle\Downloads\mckinze_reviews.xlsx')
mc_data.columns
mcpros = mc_data['pros']
mcpros =pd.DataFrame(mcpros)
mcpros = mcpros.rename(columns = {"pros":"review"})
mcpros['review_sentiment']='positive'
mcpros
mccons = mc_data['cons']
mccons =pd.DataFrame(mccons)
mccons = mccons.rename(columns = {"cons":"review"})
mccons['review_sentiment']='negative'
mccons
mcreviews = mcpros.append(mccons)
mcreviews

text = mcreviews['review'].str.cat(sep=' ')


post1 = pos_tag(word_tokenize(text))
print(post1)

tree1 = ne_chunk(post1)
print(tree1)

#nouns, adjectives, verbs, and locations 
entitynn = []
entityjj = []
entityg_air = []
entityvb = []

for y in str(tree1).split('\n'):
    if 'GPE' in y or 'GSP' in y:
        entityg_air.append(y)
    elif '/VB' in y:
        entityvb.append(y)
    elif '/NN' in y:
        entitynn.append(y)
    elif '/JJ' in y:
        entityjj.append(y)
    

entitynn
entityjj
entityg_air
entityvb

# people, organizations, and locations
entityp = []
entityo = []
entityg = []

for x in str(tree1).split('\n'):
    if 'PERSON' in x:
        entityp.append(x)
    elif 'ORGANIZATION' in x:
        entityo.append(x)
    elif 'GPE' in x or 'GSP' in x:
        entityg.append(x)

entityp
entityo
entityg


# **** entityp ********8
for i in range(len(entityp)):
    entityp[i] = str(entityp[i])
for i in range(len(entityp)):
    entityp[i] = entityp[i].replace("  (PERSON ","")
    entityp[i] = entityp[i].replace("/NNP "," ",)
    entityp[i] = entityp[i].replace("/NNP)","",)

#convert list to string and generate
unique_string=(" ").join(entityp)
wordcloud = WordCloud(width = 1000, height = 500).generate(unique_string)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
plt.close()

# **** entityo ********8
for i in range(len(entityo)):
    entityo[i] = str(entityo[i])
for i in range(len(entityp)):
    entityo[i] = entityo[i].replace("  (ORGANIZATION ","")
    entityo[i] = entityo[i].replace("/NNP "," ",)
    entityo[i] = entityo[i].replace("/NNP)","",)

import matplotlib.pyplot as plt
#convert list to string and generate
unique_string=(" ").join(entityo)
wordcloud = WordCloud(width = 1000, height = 500).generate(unique_string)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
plt.close()
plt.savefig(r'C:\Users\ashle\Downloads\organizations.jpeg')

# **** entityg ********8
for i in range(len(entityg)):
    entityo[i] = str(entityg[i])
for i in range(len(entityg)):
    entityg[i] = entityg[i].replace("  (GPE ","")
    entityg[i] = entityg[i].replace("/NNP "," ",)
    entityg[i] = entityg[i].replace("/NNP)","",)

import matplotlib.pyplot as plt
#convert list to string and generate
unique_string=(" ").join(entityg)
wordcloud = WordCloud(width = 1000, height = 500).generate(unique_string)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
plt.close()
plt.savefig(r'C:\Users\ashle\Downloads\locations.jpeg')