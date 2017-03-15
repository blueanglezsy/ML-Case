# KNN STRIKES BACK!
By Shiyun Zhang

### Objective:
To predict future house price based on K nearest neighbors algorithm.

### Methods:
pi_hat = sum(wjpj) where j is the 4 nearest neighbors of i. I have belows settings to implement this algorithm:
1. I used Euclidean Distance to measure the distance between data points since it is spatial data;
2. I defined weight as 1/distance(i,j)^2, and used sum(wjpj)/sum(wj) to calculate the prediction, this makes the weights sum up to 1 and the prediction is in the same scale with the house price. There is one problem with this implementaion: when the data points have exactly same location, the distance is 0 and the prediction become infinite. To solve this problem, I set the weight to be maximum possible value/k for those distance 0 points. In this case, if i have point i has a neighbor that in the exactly same location, that neibor will get highest possible weight, and if all four neighbors are all in the same location, it will just take the average of the four with equal weight. 
3. To prevent the time leakage, a house j can be considered as neighbors of i only if j's closing date is before i.
4. A couple implementation setting were considered throughout the process, due to above (3) temporal nature, also as I believe in our case, we have the past price and try to consider the future values. I ordered the dataset by date, and for a house i, only looking for its neighbors from records above.

Please see codes for details of the implementations.

### Qestions:
1. What is the performance measured in MRAE?__
The overall performance for all records is about 0.20. I took a test set of the last 10000 records and the MRAE is about.

2. What would be an appropriate methodology to dertermine the optimal K?
One way is to plot the error rate by K based on cross validation results. Then select the turning point. In my case, due the above reason I just used one test dataset for now.

3. Spatial or temporal trends in error?
![Spatial vs Error](https://github.com/blueanglezsy/ML-Case/blob/master/spatial.png)

4. How to improve this model?
One thing to be considered is to add more variables into the model. For example, one thing i noticed is that there are negative price in the dataset, which might be sell/buy, partition by this will be very helpful since in our case, if take similar location neighbors and they got negative values, it will heavily affect the prediction.

5. How to productionize the model?
One idea is to whenever we have a result coming in, score the price based on previous training data;
Another idea is to cluster the houses based on their geolocation and other factors, so that when a new record coming in, only look for neighbors in the closest cluster;
Another thing to be considered is to implement the algorithm in parallel, each mapper find close neighbors, then reduce to global minimum. For example by Block Nested Loop Join.



