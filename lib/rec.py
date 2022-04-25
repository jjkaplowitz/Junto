from audioop import reverse
from queue import PriorityQueue
import pandas as pd
import numpy as np
import re
from scipy.spatial import distance
from sentence_transformers import SentenceTransformer


model = SentenceTransformer('bert-base-nli-mean-tokens')

red = pd.read_csv('../assets/reddit_questions2.csv', delimiter=';')
body = red['text'].tolist()
sentence_embeddings = np.load('../assets/redditbert.npy')

query = input("Search: ")
while query != 'quit':
    query = query.lower()
    re.sub('[^A-Za-z0-9]+', ' ', query)
    query_vec = model.encode([query])[0]
    
    top = []
    count = 0
    for sent in sentence_embeddings:
        sim = distance.cosine(query_vec, sent)
        tup = (sim, count)
        if len(top) < 30: 
            top.append(tup)
        else:
            top.append(tup)
            top.sort()
            top.pop() 
        count += 1
    top.sort(reverse=True)
    while len(top) > 0:
        t = top.pop()
        print(str(t[0]) + ":   " + str(body[t[1]]))
    query = input("Search: ")
