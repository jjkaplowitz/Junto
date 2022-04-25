from audioop import reverse
from queue import PriorityQueue
import pandas as pd
import numpy as np
import json
import math
from scipy.spatial import distance
from sentence_transformers import SentenceTransformer
from flask import Flask, request, jsonify
app = Flask(__name__)
model = SentenceTransformer('bert-base-nli-mean-tokens')
sentence_embeddings = np.load('../assets/redditbert.npy')
red = pd.read_csv('../assets/reddit_questions2.csv', delimiter=';')
body = red['text'].tolist()

@app.route('/newest', methods=['GET'])
def newest():
    newsort = (red.sort_values(by=["timestamp"], ascending=False)).values.tolist()
    
    ret = ""
    i = 0
    while i < 100:
        ret = ret + str(newsort[i][1]) + ";" + str(newsort[i][2]) + ";" + str(newsort[i][4]) + "|"
        i+=1  
    d = {}
    d['Query'] = ret
    response = jsonify(d)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

@app.route('/upvote', methods=['GET'])
def upvote():
    ups = (red.sort_values(by=["votes"], ascending=False)).values.tolist()
    ret = ""
    i = 0
    while i < 100:
        ret = ret + str(ups[i][1]) + ";" + str(ups[i][2]) + ";" + str(ups[i][4]) + "|"
        i+=1  
    d = {}
    d['Query'] = ret
    response = jsonify(d)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

@app.route('/popular', methods=['GET'])
def popular():
    
    ups = red.values.tolist()
    ind = 0
    listind = []
    for l in ups:
        if l[2] > 0:
            score = math.log(l[2])/ 2.30258509299 + (l[3] - 1134028003) / 4500000 
            listind.append({"score" : score, "ind" :ind})
        ind+=1
    listind.sort(key=lambda d: d['score'])
    listind.reverse()
    ret = ""
    i = 0
    while i < 100:
        s = listind[i]["ind"]
        ret = ret + str(ups[s][1]) + ";" + str(ups[s][2]) + ";" + str(ups[s][4]) + "|"
        i+=1  
    d = {}
    d['Query'] = ret
    response = jsonify(d)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

@app.route('/search', methods=['GET'])
def search():
    Query = str(request.args['Query'])
    query_vec = model.encode([Query])[0]
    top = []
    count = 0
    for sent in sentence_embeddings:
        sim = distance.cosine(query_vec, sent)
        tup = (sim, count)
        if len(top) < 50: 
            top.append(tup)
        else:
            top.append(tup)
            top.sort()
            top.pop() 
        count += 1
    top.sort(reverse=True)
    
    ret = ""
    while len(top) > 0:
        ret = ret + body[top.pop()[1]] + "|"
    
    d = {}
    d['Query'] = ret
    response = jsonify(d)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

@app.route('/rec', methods=['GET'])
def rec():
    ret = ""
    Query = str(request.args['Query'])
    q = Query.split(',')
    toptop = []
    for query in q:
        query_vec = model.encode([query])[0]
        top = []
        count = 0
        for sent in sentence_embeddings:
            sim = distance.cosine(query_vec, sent)
            tup = (sim, count)
            if len(top) < 20: 
                top.append(tup)
            else:
                top.append(tup)
                top.sort()
                top.pop() 
            count += 1
        toptop = toptop+top    
    toptop.sort(reverse=True)

    for t in toptop:
        ret = ret + str(t[1]) + "|"

    d = {}
    d['Query'] = ret
    print(d)
    response = jsonify(d)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

if __name__ == '__main__':
    app.run()